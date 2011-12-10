#include <inc/lib.h>

#define debug 0

static ssize_t devpipe_read(struct Fd *fd, void *buf, size_t n);
static ssize_t devpipe_write(struct Fd *fd, const void *buf, size_t n);
static int devpipe_stat(struct Fd *fd, struct Stat *stat);
static int devpipe_close(struct Fd *fd);

struct Dev devpipe =
{
	/* .dev_id = */		'p',
	/* .dev_name = */	"pipe",
	/* .dev_read = */	devpipe_read,
	/* .dev_write = */	devpipe_write,
	/* .dev_close = */	devpipe_close,
	/* .dev_stat = */	devpipe_stat,
	/* .dev_trunc = */	0
};

#define PIPEBUFSIZ 32		// small to provoke races

struct Pipe {
	off_t p_rpos;		// read position
	off_t p_wpos;		// write position
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
	fd0->fd_omode = O_RDONLY;

	fd1->fd_dev_id = devpipe.dev_id;
	fd1->fd_omode = O_WRONLY;

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
    err1:
	sys_page_unmap(0, fd0);
    err:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	// Check pageref(fd) and pageref(p),
	// returning 1 if they're the same, 0 otherwise.
	//
	// The logic here is that pageref(p) is the total
	// number of readers *and* writers, whereas pageref(fd)
	// is the number of file descriptors like fd (readers if fd is
	// a reader, writers if fd is a writer).
	//
	// If the number of file descriptors like fd is equal
	// to the total number of readers and writers, then
	// everybody left is what fd is.  So the other end of
	// the pipe is closed.
	//
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}

int
pipeisclosed(int fdnum)
{
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
		return r;
	p = (struct Pipe*) fd2data(fd);
	return _pipeisclosed(fd, p);
}

int
pipe_ipc_recv_read(envid_t *from_env) {
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
        || (r = sys_page_alloc(0, fd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
        goto err;
    }

    int perm;
    if ((r = ipc_recv(from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
        cprintf("no page was actually transferred!\n");
    else
        cprintf("perm: %x\n", perm);

    cprintf("finished ipc_recv\n");

    assert(perm & PTE_U && perm & PTE_P);
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
    fd->fd_omode = O_RDONLY;
    return fd2num(fd);

err1:
    sys_page_unmap(0, fd);
err:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
    return 0;
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
	// Write a loop that transfers one byte at a time.
	// Your code should be patterned on pipe_read above.
	// Unlike in read, it is not okay to write only some of the data:
	// if the pipe fills and you've only copied some of the data,
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
	struct Pipe *p = (struct Pipe*) fd2data(fd);
	strcpy(stat->st_name, "<pipe>");
	stat->st_size = p->p_wpos - p->p_rpos;
	stat->st_ftype = FTYPE_REG;
	stat->st_dev = &devpipe;
	return 0;
}

static int
devpipe_close(struct Fd *fd)
{
	(void) sys_page_unmap(0, fd);
	return sys_page_unmap(0, fd2data(fd));
}
