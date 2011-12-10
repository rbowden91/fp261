/* See COPYRIGHT for copyright information. */

#include <inc/x86.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/time.h>
#include <kern/trap.h>
#include <kern/syscall.h>
#include <kern/console.h>
#include <kern/sched.h>
#include <kern/programs.h>
#include <kern/e1000.h>

// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(uintptr_t s_ptr, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
    user_mem_assert(curenv, s_ptr, len, 0);

	// Print the string supplied by the user.
	cprintf("%.*s", len, (char *) s_ptr);
}

// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
}

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
		return r;
	if (e == curenv)
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
	env_destroy(e);
	return 0;
}

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment.
	// Make sure that, when the new environment is run,
	// sys_exofork will appear to return 0 there.

	// LAB 3: Your code here.
    Env *new_env;
    int r;
    if((r = env_alloc(&new_env, curenv->env_id)))
        return r;
    
    new_env->env_status = ENV_NOT_RUNNABLE;
    new_env->env_tf = curenv->env_tf;
    
    // since eax is the return value, we want the child to see 0 returned
    new_env->env_tf.tf_regs.reg_eax = 0;
    return new_env->env_id; 
}

// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
int
sys_env_set_status(envid_t envid, int status)
{
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 3: Your code here.
	if(status & ~(ENV_RUNNABLE | ENV_NOT_RUNNABLE))
        return -E_INVAL;
    Env *env;
    if(envid2env(envid, &env, 1))
        return -E_BAD_ENV;
    env->env_status = status;
    return 0;
}

/* Sets the priority of a process.  The same rules as above for set_status
 * apply, except there is no restriction on priority value */
static int
sys_env_set_priority(envid_t envid, uint32_t priority)
{
    Env *env;
    if(envid2env(envid, &env, 1))
        return -E_BAD_ENV;
    env->env_priority = priority;
    return 0;
}

// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, uintptr_t func)
{
	// LAB 4: Your code here.
    Env *env;
    if(envid2env(envid, &env, 1))
        return -E_BAD_ENV;
    env->env_pgfault_upcall = func;
    return 0;
}

// Set envid's trap frame to the Trapframe stored in '*tf_ptr',
// modified to make sure that user environments always run with correct
// segment registers and with interrupts enabled.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	Destroy the environment on memory errors.
static int
sys_env_set_trapframe(envid_t envid, uintptr_t tf_ptr)
{
	// LAB 4: Your code here.
    Env *e;
    if (envid2env(envid, &e, true) < 0)
        return -E_BAD_ENV;
    user_mem_assert(curenv, tf_ptr, sizeof(Trapframe), PTE_P|PTE_U|PTE_W);
    Trapframe *tf = (Trapframe *)tf_ptr;
    tf->tf_cs = GD_UT | 3;
    tf->tf_es = tf->tf_ds = tf->tf_ss = GD_UD | 3;
    tf->tf_eflags |= FL_IF;
    memcpy(&e->env_tf, (void *)tf_ptr, sizeof(Trapframe));
    return 0;
}

static int
_sys_page_alloc(envid_t envid, uintptr_t va, int perm, bool exists_on_remote)
{
	// Hint: This function is a wrapper around page_alloc() and
	//   page_insert() from kern/pmap.c.
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 3: Your code here.
    Env *env;

    // check if valid env that we can manipulate
    if(envid2env(envid, &env, 1) || !env)
        return -E_BAD_ENV;

    // check page alignment and permissions
    if((va % PGSIZE) || va >= UTOP || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) || !(perm & PTE_U) || !(perm & PTE_P))
        return -E_INVAL;

    Page *p;
    if (!(p = page_alloc()))
        return -E_NO_MEM;

    // if we fail to insert, we have to free the page we just allocated
    if (page_insert(env->env_pgdir, p, va, perm))
    {
        page_free(p);
        return -E_NO_MEM;
    }

    // zero out the page
    memset(page2kva(p), 0, PGSIZE);
    return 0;    
}

// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.  See PTE_SYSCALL in inc/mmu.h.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, uintptr_t va, int perm) {
	return _sys_page_alloc(envid, va, perm, false);
}
static int
sys_page_alloc_exists_on_remote(envid_t envid, uintptr_t va, int perm) {
	return _sys_page_alloc(envid, va, perm, true);
}

// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, uintptr_t srcva,
	     envid_t dstenvid, uintptr_t dstva, int perm)
{
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 3: Your code here.
    Env *srcenv, *dstenv;

    // check if boths envs are valid for us to manipulate
    if(envid2env(dstenvid, &dstenv, 1) || envid2env(srcenvid, &srcenv, 1) ||
       !dstenv || !srcenv)
        return -E_BAD_ENV;
    // check alignemnt and permissions
    
    if((srcva & PGALIGN) || srcva >= UTOP || (dstva & PGALIGN) || dstva >= UTOP || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) || !(perm & PTE_U) || !(perm & PTE_P))
        return -E_INVAL;
   
    pte_t *pte;
    Page *p = page_lookup(srcenv->env_pgdir, srcva, &pte);

    // if we are trying to map a non-writeable page as writeable, invalid
    if(!p || ((perm & PTE_W) && !(*pte & PTE_W)))
        return -E_INVAL;
    
    // insert the page, which itself can fail
    if(page_insert(dstenv->env_pgdir, p, dstva, perm))
        return -E_NO_MEM;
    return 0;
}

// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, uintptr_t va)
{
	// Hint: This function is a wrapper around page_remove().
    Env *env;

    // get valid env that we can manipulate
    if(envid2env(envid, &env, 1))
        return -E_BAD_ENV;
    
    // check for page alignemnt
    if((va & PGALIGN) || va >= UTOP) 
        return -E_INVAL;

    // remove the page
    page_remove(env->env_pgdir, va);
    return 0;
}

static int
_sys_page_check(unsigned ppn) {
	// Only check userland pages.
	const size_t n_pages = UTOP >> 12;
	// Manual "div round up", so that truncation doesn't lead us to miss pages
    const size_t n_pdx = (UTOP >> 22) + (UTOP % (1 << 22) == 0 ? 0 : 1);

	uint32_t this_envx = ENVX(curenv->env_id);
	struct Env *e;

	int found_in_others = 0;
	int writable = 0;

	lcr3(PADDR(kern_pgdir));
	for (uint32_t envx = 0; envx < NENV; envx++) {

		e = &envs[envx];
		if (e->env_status == ENV_FREE) continue;

		for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
			if(e->env_pgdir[pdx] & PTE_P) {
				pte_t *ptable = (pte_t*)KADDR(PTE_ADDR(e->env_pgdir[pdx]));
				for(unsigned ptx = 0, tpn = pdx << 10;
						tpn < n_pages && (tpn >> 10) == pdx; ptx++, tpn++) {
					if(ptable[ptx] & PTE_P) {
						// We have found a match!
						if (PTE_ADDR(ptable[ptx]) >> PGSHIFT == ppn) {
							if (ptable[ptx] & PTE_W) {
								writable = 1;
							}
							if (this_envx != envx) {
								found_in_others = 1;
							}
							if (writable && found_in_others) {
								return 2;
							}
						}
					}
				}
			}
		}
	}
	lcr3(PADDR(curenv->env_pgdir));

	// If it was both writable and found in others, then we would
	// have already returned 2.
	return found_in_others;
}


static void
_sys_evict_at_all_sites(unsigned ppn) {
	// Only check userland pages.
	const size_t n_pages = UTOP >> 12;
	// Manual "div round up", so that truncation doesn't lead us to miss pages
    const size_t n_pdx = (UTOP >> 22) + (UTOP % (1 << 22) == 0 ? 0 : 1);
	uint32_t this_envx = ENVX(curenv->env_id);
	struct Env *e;
	struct Page *pg;

	cprintf("going to evict at all sites.\n");
	lcr3(PADDR(kern_pgdir));
	for (uint32_t envx = 0; envx < NENV; envx++) {
		e = &envs[envx];	
		if (e->env_status == ENV_FREE) continue;
		for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
			if(e->env_pgdir[pdx] & PTE_P) {
				if (PTE_ADDR(e->env_pgdir[pdx]) == 0x3b303000) {
					cprintf("wtf.  envx: %x\n", envx);
					cprintf("npages: %x\n", npages);
				}
				pte_t *ptable = (pte_t*)KADDR(PTE_ADDR(e->env_pgdir[pdx]));
				for(unsigned ptx = 0, tpn = pdx << 10;
						tpn < n_pages && (tpn >> 10) == pdx; ptx++, tpn++) {
					if(ptable[ptx] & PTE_P) {
						// Pages cannot be both present here and remote
						// somewhere else.
						// XXX FIXME: why did this fail?
						//assert(!(ptable[ptx] & PTE_REMOTE));
						// We have found a match!
						if (PTE_ADDR(ptable[ptx]) >> PGSHIFT == ppn) {
							pg = pa2page(ptable[ptx]);
							if (pg->pp_ref == 0) {
								page_free(pg);
								ptable[ptx] = 0;
							}
							else {
								ptable[ptx] &= ~PTE_P;
								ptable[ptx] |= PTE_REMOTE;
							}
						}
					}
				}
			}
		}
	}
	lcr3(PADDR(curenv->env_pgdir));
	cprintf("done evicting at all sites.\n");
}

static int
sys_page_evict(unsigned ppn) {
	int r;

	if ((r = sys_page_alloc(0, (uintptr_t)UTEMP, PTE_P | PTE_U | PTE_W)) < 0) {
		return r;
	}

	lcr3(PADDR(curenv->env_pgdir));
	memcpy(UTEMP, KADDR(ppn << PGSHIFT), PGSIZE);
	lcr3(PADDR(kern_pgdir));

	_sys_evict_at_all_sites(ppn);

	return 0;
}

//
// Return values:
// <0 on failure.
//  0: page is not mapped in any environment other than curenv.
//  1: page is mapped in other environment(s), but never writable.
//  2: page is mapped in other environment(s), and is mapped writable
//     in at least one environment (possible only this environment)
//     In this case, sys_page_audit will:
//     - allocate a new page in the current environment at UTEMP
//     - copy the contents of the original page to the page at UTEMP
//     - "evict" all copies of original page in all environments.
static int
sys_page_audit(unsigned ppn) {
	uint32_t this_envx = ENVX(curenv->env_id);
	struct Env *e;

	int r, check_result;

	check_result = _sys_page_check(ppn);
	assert (check_result  == 0 || check_result == 1 || check_result == 2);
	if (check_result == 0 || check_result == 1) {
		return check_result;
	}
		
	if ((r = sys_page_evict(ppn)) < 0) {
		return r;
	}
	return check_result;
}

static int
_sys_remap_at_all_sites(unsigned ppn) {
	// Only check userland pages.
	const size_t n_pages = UTOP >> 12;
	// Manual "div round up", so that truncation doesn't lead us to miss pages
    const size_t n_pdx = (UTOP >> 22) + (UTOP % (1 << 22) == 0 ? 0 : 1);
	uint32_t this_envx = ENVX(curenv->env_id);
	struct Env *e;

	lcr3(PADDR(kern_pgdir));
	for (uint32_t envx = 0; envx < NENV; envx++) {
		e = &envs[envx];	
		if (e->env_status == ENV_FREE) continue;
		for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
			if(e->env_pgdir[pdx] & PTE_P) {
				pte_t *ptable = (pte_t*)KADDR(PTE_ADDR(e->env_pgdir[pdx]));
				for(unsigned ptx = 0, tpn = pdx << 10;
						tpn < n_pages && (tpn >> 10) == pdx; ptx++, tpn++) {
					// We have found a match!
					if (PTE_ADDR(ptable[ptx]) >> PGSHIFT == ppn) {
						// If we're remapping this page, it shouldn't
						// already be present.
						assert(!(ptable[ptx] & PTE_P));
						ptable[ptx] |= PTE_P;
						ptable[ptx] &= ~PTE_REMOTE;
					}
				}
			}
		}
	}
	lcr3(PADDR(curenv->env_pgdir));

	return 0;
}

static int
sys_page_recover(unsigned ppn) {
	memcpy(KADDR(ppn << PGSHIFT), UTEMP, PGSIZE);

	_sys_remap_at_all_sites(ppn);

	sys_page_unmap(0, (uintptr_t)UTEMP);

	return 0;
}


// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target is not blocked, waiting for an IPC.
//
// The send also can fail for the other reasons listed below.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused sys_ipc_recv system call.  (Hint: does the
// sys_ipc_recv function ever actually return?)
//
// If the sender wants to send a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success, < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, uintptr_t srcva, unsigned perm)
{
	// LAB 4: Your code here.
    Env *e;
    
    // valid env?
    if (envid2env(envid, &e, 0) < 0)
        return -E_BAD_ENV;

    // is the environment waiting on a message?
    if (!e->env_ipc_recving)
        return -E_IPC_NOT_RECV;

    // check for alignment and permission issues
    if (srcva < UTOP && 
       (srcva % PGSIZE || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) ||
       !(perm & PTE_U) || !(perm & PTE_P)))
            return -E_INVAL;

    // transmit the message
    e->env_ipc_recving = 0;
    e->env_ipc_value = value;
    e->env_ipc_from = curenv->env_id;


    int ret = 0;

    // if we are supposed to map a page as part of the message, do so
    if(srcva < UTOP && e->env_ipc_dstva < UTOP)
    {
        Page *p;
        pte_t *pte;

        // check if the page and permissions are valid, and try to insert
        if ((p = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL)
            return -E_INVAL;
        if ((perm & PTE_W) && !(*pte & PTE_W))
            return -E_INVAL;
        if ((ret = page_insert(e->env_pgdir, p, e->env_ipc_dstva, perm)) < 0)
            return ret;
        e->env_ipc_perm = perm;
        ret = 1;
    }
    else
        e->env_ipc_perm = 0;
    
    // and set the environment that was waiting back to runnable
    e->env_status = ENV_RUNNABLE;
    return ret;
}

// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(uintptr_t dstva)
{
	// check for valid page for a mapping
    if (dstva < UTOP && (dstva % PGSIZE))
            return -E_INVAL;

    // and anticipate a message (setting ourselves to NOT_RUNNABLE
    curenv->env_ipc_dstva = dstva;
	curenv->env_status = ENV_NOT_RUNNABLE;
    curenv->env_ipc_recving = true; 
    return 0;
}


// Look up a program from the kernel's program collection.
// Return the ID for the program named 'name' (length of name is 'len').
// If no such program exists, returns -E_NOT_EXEC.
// On memory fault destroys the environment.
// All valid program IDs are large positive numbers
// greater than or equal to PROGRAM_OFFSET.
static int
sys_program_lookup(uintptr_t name_ptr, size_t len)
{
	int i;

    // verify name of program
	user_mem_assert(curenv, name_ptr, len, PTE_U);
	const char *name = (const char *) name_ptr;

    // look for program in list of programs
	for (i = 0; i < nprograms; i++)
		if (strncmp(programs[i].name, name, len) == 0)
			return PROGRAM_OFFSET + i;

	return -E_NOT_EXEC;
}

// Copy 'size' bytes of data from the embedded ELF binary
// for program 'programid' into address 'va' in environment 'envid'.
// Start copying 'offset' bytes into the ELF.
// Thus, multiple calls to sys_program_read can read an entire ELF binary.
// If 'offset' or 'offset + size' is too large for the ELF,
// returns the number of bytes actually copied
// (which might be 0 if nothing was copied).
//
// Returns the number of bytes read on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if programid is an invalid ELF program ID.
//	Kills the calling environment if [va, va+size) is not user-writable.
static ssize_t
sys_program_read(envid_t envid, uintptr_t va,
		 int programid, uint32_t offset, size_t size)
{
    Program *p;
 	Env *e;
    pte_t *pte;
    
    // grab env, chceking permissions
    if (envid2env(envid, &e, true) < 0)
        return -E_BAD_ENV;

    // validate programid
    programid -= PROGRAM_OFFSET;
    if (programid >= nprograms || programid < 0)
        return -E_INVAL;
    p = &programs[programid];

    // go into pgdir of new environment
    lcr3(PADDR(e->env_pgdir));


    uint32_t bytes = 0;
    unsigned int read = ROUNDUP(va, PGSIZE) - va;

    // a separate case for reading in all of the bytes up to page-alignment
    if (read)
    {
        // make sure we don't over-copy
        if(read > size)
            read = size;
        if(read + offset > p->size)
        {
            read = p->size - offset;
        }
        if(read > 0)
        {
            if (!page_lookup(e->env_pgdir, va, &pte)
                || (e->env_pgdir[PDX(va)] & (PTE_U | PTE_W)) != (PTE_U | PTE_W)
                || (*pte & (PTE_U | PTE_W)) != (PTE_U | PTE_W))
                    env_destroy(curenv);
            memcpy((void *)va, (void *)(p->data + offset), read);
        }
    }
    
    bytes += read;


    // now continue to read for the rest of the pages    
    for (uintptr_t i = ROUNDUP(va, PGSIZE); i < va + size && offset + bytes < p->size; i += PGSIZE)
    {
        // again, check permissions and don't overread
        if (!page_lookup(e->env_pgdir, i, &pte)
            || (e->env_pgdir[PDX(i)] & (PTE_U | PTE_W)) != (PTE_U | PTE_W)
            || (*pte & (PTE_U | PTE_W)) != (PTE_U | PTE_W))
            env_destroy(curenv);
        if (p->size <= bytes + offset)
            read = p->size - bytes + offset;
        else
            read = PGSIZE;
        if (size - bytes < read)
            read = size - bytes;
        memcpy((void *)i, (void *)(p->data + offset + bytes), read); 
        bytes += read;
    }

    // return to the pgdir of our old (current) environment
    lcr3(PADDR(curenv->env_pgdir));
	return bytes;
}


static uint32_t
sys_time_msec(void)
{
    return time_msec();
}

static int
sys_e1000_transmit(uintptr_t buffer, size_t len)
{   
    user_mem_assert(curenv, buffer, len, 0);
    return e1000_transmit((void *)buffer, (size_t)len);
}

static int
sys_e1000_receive(uintptr_t buffer)
{
    return e1000_receive((void *)buffer);
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
    switch(syscallno)
    {
        case SYS_cputs: sys_cputs((uintptr_t)a1, (size_t)a2); return 0;
        case SYS_cgetc: return sys_cgetc();
        case SYS_getenvid: return (int32_t)sys_getenvid();
        case SYS_env_destroy: return sys_env_destroy((envid_t)a1);
        case SYS_yield: sys_yield(); return 0;
        case SYS_ipc_recv: return sys_ipc_recv((uintptr_t)a1);
        case SYS_ipc_try_send: return sys_ipc_try_send((envid_t)a1,(uint32_t)a2, (uintptr_t)a3, (unsigned)a4);
        case SYS_env_set_status: return sys_env_set_status((envid_t)a1,(int)a2);
        case SYS_env_set_priority: return sys_env_set_priority((envid_t)a1,(uint32_t)a2);
        case SYS_env_set_pgfault_upcall: return sys_env_set_pgfault_upcall((envid_t)a1,(uint32_t)a2);
        case SYS_exofork: return (int32_t)sys_exofork();
        case SYS_page_alloc: return sys_page_alloc((envid_t)a1,(uintptr_t)a2,(int)a3);
        case SYS_page_map: return sys_page_map((envid_t)a1,(uintptr_t)a2,(envid_t)a3,(uintptr_t)a4, (int)a5);
        case SYS_page_unmap: return sys_page_unmap((envid_t)a1,(uintptr_t)a2);
        case SYS_program_read: return sys_program_read((envid_t)a1, (uintptr_t)a2, (int)a3, (uint32_t)a4, (size_t)a5);
        case SYS_time_msec: return sys_time_msec();
        case SYS_program_lookup: return sys_program_lookup((uintptr_t)a1, (size_t)a2);
        case SYS_env_set_trapframe: return sys_env_set_trapframe((envid_t) a1, (uintptr_t) a2);
        case SYS_e1000_transmit: return sys_e1000_transmit((uintptr_t)a1, (size_t)a2); 
        case SYS_e1000_receive: return sys_e1000_receive((uintptr_t)a1);
		case SYS_page_evict: return sys_page_evict(a1);
		case SYS_page_audit: return sys_page_audit(a1);
		case SYS_page_recover: return sys_page_recover(a1);
		case SYS_page_alloc_exists_on_remote: return sys_page_alloc_exists_on_remote(a1, a2, a3);
        default: return -E_INVAL;
    }
}

