#include <inc/x86.h>
#include <inc/string.h>
#include <inc/lib.h>

#include "ide.h"

// Metadata about a disk block, specifically whether the block is locked
// and a circular queue of up to 8 locked and/or waiting environments.
// - bi_head: head pointer of the queue (mod BI_QSIZE)
// - bi_nlocked: number of locked environments in the queue
// - bi_count: number of locked and waiting environments in the queue
//   (0 <= bi_nlocked <= bi_count <= BI_QSIZE)
// - bi_initialized: initially 0, set by BREQ_INITIALIZE,
//   used as return value for lock IPCs
// - bi_envids: queued environment IDs, access with BI_ENVID
// - bi_reqtypes: queued actions, access with BI_ACTION
#define BI_QSIZE	8
struct BlockInfo {
	envid_t bi_envids[BI_QSIZE];
	uint8_t bi_reqtypes[BI_QSIZE];
	uint8_t bi_head;
	uint8_t bi_nlocked;
	uint8_t bi_count;
	uint8_t bi_initialized;
	uint8_t bi_padding[64 - BI_QSIZE * 5 - 4];
};

// The struct BlockInfo for disk block N is stored at
// (struct BlockInfo *) (BLOCKINFOMAP + (N*sizeof(BlockInfo))).
#define BLOCKINFOMAP	0x30000000

// BI_ENVID(bip, offset): env ID at offset in queue (0 <= offset <= bi_count)
#define BI_ENVID(bip, offset)	\
	((bip)->bi_envids[((bip)->bi_head + (offset)) % BI_QSIZE])
// BI_REQTYPE(bip, offset): reqtype at offset in queue (0 <= offset <= bi_count)
// Always either MAP_RLOCK or MAP_WLOCK.
#define BI_REQTYPE(bip, offset)	\
	((bip)->bi_reqtypes[((bip)->bi_head + (offset)) % BI_QSIZE])


// Disk block n, when in memory, is mapped into the file system
// server's address space at DISKMAP + (n*BLKSIZE).
#define DISKMAP		0x50000000

// Maximum disk size we can handle (2GB).
#define DISKSIZE	0x80000000


// Number of sectors per block.
#define BLKSECTS	(BLKSIZE / SECTSIZE)


// Look up the struct BlockInfo for block 'blocknum'.
// Automatically allocates a page for BlockInfo if required & 'create != 0'.
// The resulting BlockInfo is stored in '*result'.
// Returns 0 on success, < 0 on failure.  Error codes include -E_INVAL
//   (blocknum out of range), -E_IO (I/O error), -E_NOT_FOUND (blocknum has
//   no BlockInfo yet and 'create' is 0).
//
static int
get_block_info(blocknum_t blocknum, struct BlockInfo **result, int create)
{
	struct BlockInfo *bip;
	int r;

	*result = 0;
	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;

	bip = &((struct BlockInfo *) BLOCKINFOMAP)[blocknum];

	// ensure that page exists
	if (!(vpd[PDX(bip)] & PTE_P) || !(vpt[PGNUM(bip)] & PTE_P)) {
		struct BlockInfo *page_bip, *end_page_bip;

		if (!create)
			return -E_NOT_FOUND;

		page_bip = (struct BlockInfo *) ROUNDDOWN(bip, PGSIZE);
		if ((r = sys_page_alloc(0, page_bip, PTE_P | PTE_U | PTE_W)) < 0)
			return r;

		// initialize contents
		end_page_bip = (struct BlockInfo *) ROUNDUP(page_bip + 1, PGSIZE);
		while (page_bip < end_page_bip) {
			page_bip->bi_head = 0;
			page_bip->bi_nlocked = 0;
			page_bip->bi_count = 0;
			page_bip->bi_initialized = 0;
			++page_bip;
		}
	}

	*result = bip;
	return 0;
}

// Map the contents of block 'blocknum' into the DISKMAP.
// Returns 0 on success, < 0 on failure.
// Error codes include -E_INVAL (blocknum out of range), -E_NO_MEM.
//
static int
get_block(blocknum_t blocknum)
{
	uintptr_t va = DISKMAP + blocknum * BLKSIZE;
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;

	if ((vpd[PDX(va)] & PTE_P) && (vpt[PGNUM(va)] & PTE_P))
		return 0;	// already mapped

	if ((r = sys_page_alloc(0, (void *) va, PTE_P | PTE_U | PTE_W)) < 0)
		return r;
	if ((r = ide_read(blocknum * BLKSECTS, (void *) va, BLKSECTS)) < 0) {
		cprintf("ide_read of %d fails\n", blocknum * BLKSECTS);
		sys_page_unmap(0, (void *) va);
		return r;
	}
	return 0;
}

// Write the contents of DISKMAP block 'blocknum' to disk.
// Returns 0 on success, < 0 on failure.  Error codes include -E_INVAL
//   (blocknum out of range), -E_FAULT (block not in memory), -E_IO.
//
static int
flush_block(blocknum_t blocknum)
{
	uintptr_t va = DISKMAP + blocknum * BLKSIZE;
	BlockInfo *bip;
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[PGNUM(va)] & PTE_P))
		return -E_FAULT;

	return ide_write(blocknum * BLKSECTS, (void *) va, BLKSECTS);
}

// Send DISKMAP block 'blocknum' to environment 'envid'.
// The block is sent with permissions PTE_P|PTE_U|PTE_W|PTE_SHARE.
//
static void
send_block(envid_t envid, blocknum_t blocknum, int success_value)
{
	int r;
	if ((r = get_block(blocknum)) < 0)
		ipc_send(envid, r, 0, 0);
	else
		ipc_send(envid, success_value, (void *) (DISKMAP + blocknum * BLKSIZE), PTE_P | PTE_W | PTE_U | PTE_SHARE);
}


// Handle an environment's block cache request.
// BCREQ_FLUSH and BCREQ_MAP can be satisified right away.
// BCREQ_MAP_RLOCK, BCREQ_MAP_WLOCK, and BCREQ_UNLOCK manipulate the queue
//   of waiting environments.
// At most 8 IPC requests per block are queued and will be handled in the
//   order they arrive (for fairness).
// The 9th and furhter concurrent requests are ignored; a -E_AGAIN error asks
//   the sending environment to try again later.
//
static void
handle_breq(envid_t envid, int32_t breq)
{
	struct BlockInfo *bip;
	int r;

	// Extract block number and request type from request.
	blocknum_t blocknum = BCREQ_BLOCKNUM(breq);
	int reqtype = BCREQ_TYPE(breq);
	// Check request type.
	if (reqtype < BCREQ_MAP || reqtype > BCREQ_INITIALIZE) {
		ipc_send(envid, -E_NOT_SUPP, 0, 0);
		return;
	}

	// Handle simple requests.
	if (reqtype == BCREQ_FLUSH) {
		ipc_send(envid, flush_block(blocknum), 0, 0);
		return;
	} else if (reqtype == BCREQ_MAP) {
		r = get_block_info(blocknum, &bip, 0);
		send_block(envid, blocknum, r >= 0 ? bip->bi_initialized : 0);
		return;
	}

	// More complex requests need the block_info pointer.
	if ((r = get_block_info(blocknum, &bip, 1)) < 0) {
		ipc_send(envid, r, 0, 0);
		return;
	}

	if (reqtype == BCREQ_INITIALIZE) {
		int old_initialized = bip->bi_initialized;
		bip->bi_initialized = 1;
		ipc_send(envid, old_initialized, 0, 0);
		return;
	}

	// Warn about one particularly simple deadlock.
	if (reqtype == BCREQ_MAP_WLOCK && bip->bi_nlocked > 0
	    && BI_REQTYPE(bip, 0) == BCREQ_MAP_WLOCK
	    && BI_ENVID(bip, 0) == envid)
		cprintf("bufcache: DEADLOCK: env [%08x] re-requests write lock on block %d!\n", envid, blocknum);

	if (reqtype == BCREQ_UNLOCK || reqtype == BCREQ_UNLOCK_FLUSH) {
		// Ensure that envid is one of the environments
		// currently locking the block
		int n = 0;
		while (n < bip->bi_nlocked && BI_ENVID(bip, n) != envid)
			++n;
		if (n == bip->bi_nlocked) {
			ipc_send(envid, -E_NOT_LOCKED, 0, 0);
			return;
		}

		BI_ENVID(bip, n) = BI_ENVID(bip, 0);
		BI_REQTYPE(bip, n) = BI_REQTYPE(bip, 0);
		++bip->bi_head;
		--bip->bi_nlocked;
		--bip->bi_count;

		r = (reqtype == BCREQ_UNLOCK ? 0 : flush_block(blocknum));
		ipc_send(envid, r, 0, 0);
		// Continue on to clear the request queue: perhaps this
		// environment's unlock reqtype lets the next environment lock

	} else if (bip->bi_count == BI_QSIZE) {
		// The queue is full; ask the environment to try again later
		ipc_send(envid, -E_AGAIN, 0, 0);
		return;

	} else {
		BI_ENVID(bip, bip->bi_count) = envid;
		BI_REQTYPE(bip, bip->bi_count) = reqtype;
		++bip->bi_count;
	}

	// Process the request queue
	while (bip->bi_nlocked < bip->bi_count) {
		// If trying to write lock, must be first attempt
		if (BI_REQTYPE(bip, bip->bi_nlocked) == BCREQ_MAP_WLOCK
		    && bip->bi_nlocked > 0)
			break;
		// If trying to read lock, any existing lock must be read
		if (BI_REQTYPE(bip, bip->bi_nlocked) == BCREQ_MAP_RLOCK
		    && bip->bi_nlocked > 0
		    && BI_REQTYPE(bip, 0) != BCREQ_MAP_RLOCK)
			break;
		// If we get here, we can grant the page to this queue element
		send_block(BI_ENVID(bip, bip->bi_nlocked), blocknum,
			   bip->bi_initialized);
		++bip->bi_nlocked;
	}
}


// Server loop

static bool
another_runnable_environment_exists(void)
{
	int e;
	for (e = 1; e < NENV; ++e)
		if (&envs[e] != thisenv && envs[e].env_status == ENV_RUNNABLE)
			return 1;
	return 0;
}

void
umain(int argc, char **argv)
{
	static_assert(sizeof(struct BlockInfo) == 64);
	static_assert(BLOCKINFOMAP + (DISKSIZE / BLKSIZE) * sizeof(struct BlockInfo) <= DISKMAP);
	assert(thisenv->env_id == ENVID_BUFCACHE);

	binaryname = "bufcache";
	cprintf("bufcache is running\n");

	// Check that we are able to do I/O

	// If it looks like I/O will definitely fail, then yield first to
	// other runnable, non-idle environments.
	// (This helps previous grading scripts: environment IDs are as
	// expected, but tests still complete quickly.)
	while (!(thisenv->env_tf.tf_eflags & FL_IOPL_MASK)
	       && another_runnable_environment_exists())
		sys_yield();

	outw(0x8A00, 0x8A00);
	cprintf("bufcache can do I/O\n");

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
		ide_set_disk(1);
	else
		ide_set_disk(0);

	// Process incoming requests
	while (1) {
		int32_t breq;
		envid_t envid;

		breq = ipc_recv(&envid, 0, 0);
		handle_breq(envid, breq);
	}
}
