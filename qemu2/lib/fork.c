// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>
#include <inc/x86.h>
// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800
#define PTE_SHARED  0x200

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
    void *addr = (void *)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
        return;
	
    // Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_map: %e", r);

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
        panic("sys_page_unmap: %e", r);
    resume(utf);
}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;

    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
        perm = PTE_COW;
    else if (shared)
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
            return r;

    return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use vpd, vpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
    {
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
            pn = (pn >> 10) << 10;

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
        panic("sys_env_set_pgfault_upcall: %e", r);

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
        panic("sys_env_set_status: %e", r);

    return envid;
}

// Challenge!
int
sfork(void)
{
    int r; 

    add_pgfault_handler(pgfault);

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // unlike above, no need to set thisenv for child
    if (envid == 0)
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
    {
        if(!(vpd[pn >> 10] & PTE_P))
            pn = (pn >> 10) << 10;
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
    {
        if(!(vpd[i >> 10] & PTE_P))
            i = (i >> 10) << 10;
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
        panic("sys_env_set_pgfault_upcall: %e", r);

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
        panic("sys_env_set_status: %e", r);

    return envid;
    
}
