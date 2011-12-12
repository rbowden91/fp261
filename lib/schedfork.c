// Stupid implementation of fork() does lots of copies.

#include <inc/string.h>
#include <inc/lib.h>

void
duppage(envid_t dstenv, void *addr)
{
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		panic("sys_page_unmap: %e", r);
}

envid_t
schedfork(void)
{
	envid_t envid;
	uint8_t *addr;
	int r;
	extern unsigned char end[];

	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
    for(int i = 0; i < 10; i++)
    {
	    envid = sys_exofork();
        if (envid < 0)
		    panic("sys_exofork: %e", envid);
	    if (envid == 0) {
		    // We're the child.
            // The copied value of the global variable 'thisenv'
            // is no longer valid (it refers to the parent!).
            // Fix it and return 0.
            thisenv = &envs[ENVX(sys_getenvid())];
            return 0;
	    }

        // We're the parent.
        // Eagerly copy program text and data into the child.
        // Do not copy the rest of the parent's address space.
        // (Your fork implementation will copy the parent's ENTIRE user
        // address space to the child, using copy-on-write.)
        for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
            duppage(envid, addr);

        // Also copy the stack we are currently running on.
        duppage(envid, ROUNDDOWN(&addr, PGSIZE));

        // set child priority. lower int is higher priority.
        int priority;
        switch(i){
            case 0: priority = 3; break;
            case 1: priority = 6; break;
            case 2: priority = 1; break;
            case 3: priority = 3; break;
            case 4: priority = 12; break;
            case 5: priority = 9; break;
            case 6: priority = 4; break;
            case 7: priority = 2; break;
            case 8: priority = 6; break;
            case 9: priority = 3; break;
            default: priority = 10;
        }
        sys_env_set_priority(envid, priority);
        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
            panic("sys_env_set_status: %e", r);
    }
    return envid;
}
