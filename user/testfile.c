#include <inc/lib.h>

const char *msg = "This is the NEW message of the day!\n\n";
const char *altered_msg = "THIS is the NEW message of the day!\n\n";

void
umain(int argc, char **argv)
{
	int f, r, inum;
	struct Fd *fd;
	struct Stat st;
	char buf[512];
	binaryname = "testfile";

	// Test initial file system
	if (fsck() == 0)
		cprintf("initial fsck is good\n");

	// Try out open not-found
	if ((f = open("/not-found", O_RDONLY)) < 0 && f != -E_NOT_FOUND)
		panic("open /not-found: %e", f);
	else if (f >= 0)
		panic("open /not-found succeeded!");
	cprintf("open not-found is good\n");

	// Try out open /
	if ((f = open("/", O_RDONLY)) < 0)
		panic("open root: %e", f);
	cprintf("open root is good\n");
	if ((r = close(f)) < 0)
		panic("file_close: %e", f);

	// Try out open
	if ((f = open("/newmotd", O_RDONLY)) < 0)
		panic("open /newmotd: %e", f);
	fd = (struct Fd*) (0xD0000000 + f * PGSIZE);
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");

	// Try out stat
	if ((r = fstat(f, &st)) < 0)
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");

	memset(buf, 0, sizeof buf);
	if ((r = read(f, buf, sizeof buf)) < 0)
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");

	if ((r = close(f)) < 0)
		panic("file_close: %e", r);
	cprintf("file_close is good\n");

	// Try reading across a block boundary
	if ((f = open("/marriage", O_RDONLY)) < 0)
		panic("open /marriage: %e", f);
	seek(f, 4084);
	if ((r = read(f, buf, 51)) < 0)
		panic("file_read: %e", r);
	if (memcmp(buf, "climbing the trees\nin the garden of the Hesperides,", 51) != 0)
		panic("file_read across a block boundary returned wrong data");
	cprintf("file_read across a block boundary is good\n");
	if ((r = close(f)) < 0)
		panic("file_close: %e", r);

	// Try writing to an existing file
	if ((f = open("/newmotd", O_RDWR)) < 0)
		panic("open /newmotd: %e", f);
	if ((r = write(f, altered_msg, 5)) != 5)
		panic("file_write: %e", r);
	cprintf("file_write is good\n");

	seek(f, 0);
	memset(buf, 0, sizeof buf);
	if ((r = read(f, buf, sizeof buf)) < 0)
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, altered_msg) != 0)
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");

	seek(f, 0);
	if ((r = write(f, msg, 5)) != 5)
		panic("file_write: %e", r);
	if ((r = close(f)) < 0)
		panic("file_close: %e", r);

	// Try writing to a new file
	if ((f = open("/new-file", O_RDWR|O_CREAT)) < 0)
		panic("open /new-file: %e", f);

	if ((r = write(f, msg, strlen(msg))) != strlen(msg))
		panic("file_write: %e", r);
	cprintf("file_write create is good\n");

	seek(f, 0);
	memset(buf, 0, sizeof buf);
	if ((r = read(f, buf, sizeof buf)) < 0)
		panic("file_read after file_write create: %e", r);
	if (r != strlen(msg))
		panic("file_read after file_write create returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
		panic("file_read after file_write create returned wrong data");
	cprintf("file_read after file_write create is good\n");

	// Try removing
	if ((r = unlink("/new-file")) < 0)
		panic("remove: %e", r);
	if ((r = open("/new-file", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
		panic("open after unlink: %e", r);
	else if (r >= 0)
		panic("open after unlink succeeded!");
	else
		cprintf("open after unlink is good\n");

	// Try writing after remove
	seek(f, 0);
	memset(buf, 0, sizeof buf);
	if ((r = read(f, buf, sizeof buf)) < 0)
		panic("file_read after unlink: %e", r);
	if (r != strlen(msg))
		panic("file_read after unlink returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
		panic("file_read after unlink returned wrong data");
	cprintf("file_read after unlink is good\n");

	// Check that closing that unreferenced file frees its inode,
	// by checking that its inumber is reused by the next create.
	fd = (struct Fd*) (0xD0000000 + f * PGSIZE);
	inum = fd->fd_file.inum;
	if ((r = close(f)) < 0)
		panic("file_close: %e", r);
	if ((f = open("/new-file2", O_RDWR|O_CREAT)) < 0)
		panic("open /new-file2: %e", r);
	fd = (struct Fd*) (0xD0000000 + f * PGSIZE);
	if (inum != fd->fd_file.inum)
		panic("/new-file2 expected inum %d, got %d", inum, fd->fd_file.inum);
	if ((r = close(f)) < 0)
		panic("file_close: %e", r);
	if ((r = unlink("/new-file2")) < 0)
		panic("unlink /new-file2: %e", r);
	cprintf("inode deallocation is good\n");

	// Finally, check file system integrity
	if (fsck() == 0)
		cprintf("final fsck is good\n");
}
