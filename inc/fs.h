// See COPYRIGHT for copyright information.

#ifndef JOS_INC_FS_H
#define JOS_INC_FS_H

#include <inc/types.h>
#include <inc/mmu.h>

// Bytes per file system block - same as page size
#define BLKSIZE		PGSIZE

// Maximum size of a filename (a single path component), including null
#define MAXNAMELEN	120

// Maximum size of a complete pathname, including null
#define MAXPATHLEN	1024

// Number of block pointers in an Inode
#define NDIRECT		1018

// Maximum file size
#define MAXFILESIZE	(NDIRECT * BLKSIZE)

// Typedefs for block numbers and inode numbers
typedef int32_t blocknum_t;
typedef int32_t inum_t;


// File system directory entry (in memory and on disk)
struct Direntry {
	inum_t de_inum;			// inode number of entry
	int32_t de_namelen;		// length of filename
	char de_name[MAXNAMELEN];	// filename
} __attribute__((packed));	// required on some 64-bit machines


// File system super-block (in memory and on disk)
#define FS_MAGIC	0x4A0530AE	// related vaguely to 'J\0S!'

struct Super {
	uint32_t s_magic;		// Magic number: FS_MAGIC
	blocknum_t s_nblocks;		// number of blocks in file system
	inum_t s_ninodes;		// number of inodes in file system

	struct Direntry s_root;		// directory entry for root
					// (convenient to have around)
} __attribute__((packed));	// required on some 64-bit machines


// File system inode (in memory and on disk; sizeof(struct Inode) == BLKSIZE)
struct Inode {
	uint32_t i_ftype;		// file type
	uint32_t i_refcount;		// number of hard links
	off_t i_size;			// file size in bytes

	blocknum_t i_direct[NDIRECT];	// block pointers

	// These fields only have meaning in memory:
	inum_t i_inum;			// inode number
	uint32_t i_opencount;		// number of memory references
	uint32_t i_fsck_refcount : 31;	// used during fsck
	unsigned i_fsck_checked : 1;
} __attribute__((packed));	// required on some 64-bit machines

// File types (Inode::i_type)
#define FTYPE_REG	1	// Regular file
#define FTYPE_DIR	2	// Directory


// Buffer cache requests

#define BCREQ_MAP		0	// Map this block without locking
#define BCREQ_MAP_RLOCK		1	// Map this block + shared lock
#define BCREQ_MAP_WLOCK		2	// Map this block + exclusive lock
#define BCREQ_UNLOCK		3	// Unlock previous RLOCK or WLOCK
#define BCREQ_FLUSH		4	// Flush this block's contents to disk
#define BCREQ_UNLOCK_FLUSH	5	// == UNLOCK + FLUSH
#define BCREQ_INITIALIZE	6	// Mark block as initialized

#define MAKE_BCREQ(blockno, reqtype)	((blockno << 4) | (reqtype))
#define BCREQ_BLOCKNUM(bcreq)		(((bcreq) >> 4) & 0xFFFFFFF)
#define BCREQ_TYPE(bcreq)		((bcreq) & 0xF)

#endif /* !JOS_INC_FS_H */
