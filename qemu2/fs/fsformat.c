/*
 * JOS file system format
 */

// We don't actually want to define off_t!
#define off_t xxx_off_t
#define bool xxx_bool
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#undef off_t
#undef bool

// Prevent inc/types.h, included from inc/fs.h,
// from attempting to redefine types defined in the host's inttypes.h.
#define JOS_INC_TYPES_H
// Typedef the types that inc/mmu.h needs.
typedef uint32_t physaddr_t;
typedef uint32_t off_t;
typedef int bool;

#include <inc/mmu.h>
#include <inc/fs.h>

#define ROUNDUP(n, v) ((n) - 1 + (v) - ((n) - 1) % (v))
#define MAX_DIR_ENTS 128

struct Dir {
	struct Inode *ino;
	struct Direntry *ents;
	int n;
};

uint32_t nblocks, ninodes, next_inum;
char *diskmap, *diskpos;
struct Super *super;
int8_t *freemap;

void
panic(const char *fmt, ...)
{
        va_list ap;

        va_start(ap, fmt);
        vfprintf(stderr, fmt, ap);
        va_end(ap);
        fputc('\n', stderr);
	abort();
}

void
readn(int f, void *out, size_t n)
{
	size_t p = 0;
	while (p < n) {
		size_t m = read(f, out + p, n - p);
		if (m < 0)
			panic("read: %s", strerror(errno));
		if (m == 0)
			panic("read: Unexpected EOF");
		p += m;
	}
}

uint32_t
blockof(void *pos)
{
	return ((char*)pos - diskmap) / BLKSIZE;
}

void *
alloc(uint32_t bytes)
{
	void *start = diskpos;
	diskpos += ROUNDUP(bytes, BLKSIZE);
	if (blockof(diskpos) >= nblocks)
		panic("out of disk blocks");
	return start;
}

struct Inode *
alloc_inode(void)
{
	inum_t inum = next_inum;
	struct Inode *ino;

	if (next_inum == ninodes)
		panic("too many inodes");
	++next_inum;

	ino = (struct Inode *) (diskmap + ROUNDUP(nblocks, BLKSIZE) + BLKSIZE * (1 + inum));
	memset(ino, 0, sizeof(struct Inode));
	ino->i_inum = inum;
	return ino;
}

void
opendisk(const char *name)
{
	int r, diskfd, nfreeblocks;

	if ((diskfd = open(name, O_RDWR | O_CREAT, 0666)) < 0)
		panic("open %s: %s", name, strerror(errno));

	if ((r = ftruncate(diskfd, 0)) < 0
	    || (r = ftruncate(diskfd, nblocks * BLKSIZE)) < 0)
		panic("truncate %s: %s", name, strerror(errno));

	if ((diskmap = mmap(NULL, nblocks * BLKSIZE, PROT_READ|PROT_WRITE,
			    MAP_SHARED, diskfd, 0)) == MAP_FAILED)
		panic("mmap %s: %s", name, strerror(errno));

	close(diskfd);

	diskpos = diskmap;
	alloc(BLKSIZE);
	super = alloc(BLKSIZE);
	super->s_magic = FS_MAGIC;
	super->s_nblocks = nblocks;
	super->s_ninodes = ninodes;
	super->s_root.de_inum = 1;
	super->s_root.de_namelen = 1;
	strcpy(super->s_root.de_name, "/");
	next_inum = 1;

	nfreeblocks = ROUNDUP(nblocks, BLKSIZE) / BLKSIZE;
	freemap = alloc(nfreeblocks);
	memset(freemap, 1, nfreeblocks * BLKSIZE);

	(void) alloc(BLKSIZE * (ninodes - 1));
}

void
finishdisk(void)
{
	int r;

	memset(freemap, 0, blockof(diskpos));

	// Write garbage over unreferenced inodes.
	while (next_inum < ninodes) {
		struct Inode *ino = alloc_inode();
		memset(ino, 97, sizeof(struct Inode));
		ino->i_refcount = 0;
	}

	if ((r = msync(diskmap, nblocks * BLKSIZE, MS_SYNC)) < 0)
		panic("msync: %s", strerror(errno));
}

void
finishfile(struct Inode *ino, uint32_t start, uint32_t len, bool backwards)
{
	int i, nblocks = ROUNDUP(len, BLKSIZE) / BLKSIZE;
	ino->i_size = len;
	if (backwards)
		start += nblocks - 1;
	for (i = 0; i < nblocks; ++i)
		ino->i_direct[i] = backwards ? start - i : start + i;
}

void
startdir(struct Dir *dout)
{
	dout->ino = alloc_inode();
	dout->ino->i_ftype = FTYPE_DIR;
	dout->ino->i_refcount = 1;
	dout->ents = malloc(MAX_DIR_ENTS * sizeof *dout->ents);
	memset(dout->ents, 0, MAX_DIR_ENTS * sizeof *dout->ents);
	dout->n = 0;
}

struct Inode *
diradd(struct Dir *d, uint32_t type, const char *name)
{
	struct Direntry *out = &d->ents[d->n++];
	struct Inode *ino;
	if (d->n > MAX_DIR_ENTS)
		panic("too many directory entries");
	ino = alloc_inode();
	ino->i_ftype = type;
	ino->i_refcount = 1;
	out->de_inum = ino->i_inum;
	strcpy(out->de_name, name);
	out->de_namelen = strlen(name);
	return ino;
}

void
finishdir(struct Dir *d)
{
	int size = d->n * sizeof(struct Direntry);
	void *start = alloc(size);
	memmove(start, d->ents, size);
	finishfile(d->ino, blockof(start), ROUNDUP(size, BLKSIZE), 0);
	free(d->ents);
	d->ents = NULL;
}

void
writefile(struct Dir *dir, const char *name)
{
	int r, fd, i, npages;
	struct Inode *ino;
	struct stat st;
	const char *last;
	char *start, buf[PGSIZE];

	if ((fd = open(name, O_RDONLY)) < 0)
		panic("open %s: %s", name, strerror(errno));
	if ((r = fstat(fd, &st)) < 0)
		panic("stat %s: %s", name, strerror(errno));
	if (!S_ISREG(st.st_mode))
		panic("%s is not a regular file", name);
	if (st.st_size >= MAXFILESIZE)
		panic("%s too large", name);

	last = strrchr(name, '/');
	if (last)
		last++;
	else
		last = name;

	ino = diradd(dir, FTYPE_REG, last);
	start = alloc(st.st_size);
	readn(fd, start, st.st_size);

	// Regular files are stored BACKWARDS to help students catch
	// block boundary errors.
	npages = ROUNDUP(st.st_size, PGSIZE) / PGSIZE;
	for (i = 0; i < npages - 1 - i; ++i) {
		int j = npages - 1 - i;
		memcpy(buf, start + i * PGSIZE, PGSIZE);
		memcpy(start + i * PGSIZE, start + j * PGSIZE, PGSIZE);
		memcpy(start + j * PGSIZE, buf, PGSIZE);
	}

	finishfile(ino, blockof(start), st.st_size, 1);
	close(fd);
}

void
usage(void)
{
	fprintf(stderr, "Usage: fsformat fs.img NBLOCKS NINODES files...\n");
	exit(2);
}

int
main(int argc, char **argv)
{
	int i;
	char *s;
	struct Dir root;

	assert(sizeof(struct Inode) == BLKSIZE);
	assert(BLKSIZE % sizeof(struct Direntry) == 0);

	if (argc < 4)
		usage();

	nblocks = strtol(argv[2], &s, 0);
	if (*s || s == argv[2] || nblocks < 3 || nblocks > 4096)
		usage();

	ninodes = strtol(argv[3], &s, 0);
	if (*s || s == argv[3] || ninodes < 1)
		usage();

	// Cross-check that there is room for file data
	if (nblocks <= 2 + ROUNDUP(nblocks, BLKSIZE) / BLKSIZE + ninodes)
		panic("disk too small");

	opendisk(argv[1]);

	startdir(&root);
	for (i = 4; i < argc; i++)
		writefile(&root, argv[i]);
	finishdir(&root);

	finishdisk();
	return 0;
}
