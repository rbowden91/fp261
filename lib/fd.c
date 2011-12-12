#include <inc/lib.h>

// Maximum number of file descriptors a program may hold open concurrently
#define NFD		32
// Bottom of file descriptor area
#define FDTABLE		0xD0000000
// Bottom of file data area.  We reserve one data page for each FD,
// which devices can use if they choose.
#define FDDATA		(FDTABLE + NFD*PGSIZE)

static bool fd_isopen(const struct Fd *fd);


// --------------------------------------------------------------
// Low-level file descriptor manipulators
// --------------------------------------------------------------

// Return the 'struct Fd' for a file descriptor number.
// Returns NULL on failure, a pointer on success.
// If 'must_exist' is true, then the file descriptor must currently be open
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
		return 0;
	}
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
	assert(fd_valid(fd));
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
	int num = fd2num(fd);
	return (char *) (FDDATA + num * PGSIZE);
}


// Finds the smallest index from 0 to NFD-1 that doesn't have
// its fd page mapped.
// Sets *fd_store to the corresponding fd page virtual address.
//
// Does NOT actually allocate an fd page.
// It is up to the caller to allocate the page somehow.
// This means that if someone calls fd_find_unused twice in a row
// without allocating the first page we return, we'll return the same
// page the second time.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
		(void) fd_lookup(i, &fd, false);
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
	return -E_MAX_OPEN;
}

// Frees file descriptor 'fd' by closing the corresponding file
// and unmapping the file descriptor page.
// If 'must_exist' is 0, then fd can be a closed or nonexistent file
// descriptor; the function will return 0 and have no other effect.
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
			r = (*dev->dev_close)(fd);
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
	return r;
}

static struct Dev *devtab[] =
{
	&devfile,
	&devpipe,
	&devcons,
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
	*dev = 0;
	return -E_INVAL;
}


// --------------------------------------------------------------
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
		return r;
	else
		return fd_close(fd, true);
}

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
		close(i);
}

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
		return r;
	fd->fd_offset = offset;
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_ftype = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
		return fd;
	r = fstat(fd, stat);
	close(fd);
	return r;
}
