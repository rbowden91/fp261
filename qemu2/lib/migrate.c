#include <inc/lib.h>
#include <inc/connect.h>
#include <inc/x86.h>
#include <inc/migrate.h>

// XXX: this might not be a very good place for this #define... perhaps
// it should be protected.
#define VA_OF_VPN(vpn) ((vpn) << 12)

/*
 * Pre-condition: f is the file descriptor number of an open file descriptor.
 * The caller is responsible for closing this file.
 */
int
migrate_spawn(int f) {
	int r;
	struct MigrateSuperHeader sh;
	struct MigratePageHeader h;

	cprintf("[%08x] starting migrate_spawn\n", thisenv->env_id);
	envid_t envid = sys_exofork();
	if (envid < 0) {
		return envid;
	}
	if (envid == 0) {
		panic("migrate_spawn: unreachable code in the child");
	}
	

	if ((r = readn(f, &sh, sizeof(struct MigrateSuperHeader)))
			!= sizeof(struct MigrateSuperHeader)) {
		r = (r < 0) ? r : -E_IO;
		goto cleanup;
	}

	if (sh.msh_magic != MIGRATE_MAGIC) {
		// XXX: should we be make some custom error codes for migration?
		r = -E_NOT_EXEC;
		goto cleanup;
	}
	cprintf("[%08x] migrate_spawn: read superheader\n", thisenv->env_id);
	
	for (uint32_t i = 0; i < sh.msh_n_pages; i++) {
		if ((r = readn(f, &h, sizeof(struct MigratePageHeader)))
				!= sizeof(struct MigratePageHeader)) {
			r = (r < 0) ? r : -E_IO;
			panic("migrate_spawn: read page header: %e\n", r);
			goto cleanup;
		}
		if (h.mph_magic != MIGRATE_PG_MAGIC) {
			r =  -E_NOT_EXEC;
			panic("migrate_spawn: magic check failed. %e\n", r);
			goto cleanup;
		}

		if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0) {
			panic("migrate_spawn: alloc page at UTEMP: %e\n", r);
			goto cleanup;
		}
        for(int i = 0; i < 4; i++)
        {
            if ((r = readn(f, (char *)UTEMP + PGSIZE / 4 * i, PGSIZE/4)) != PGSIZE/4) {
                r = (r < 0) ? r : -E_IO;
                panic("migrate_spawn: read page:  %e\n", r);
                sys_page_unmap(0, UTEMP);
                goto cleanup;
            } 
        }
		

		if ((r = sys_page_map(0, UTEMP, envid, h.mph_addr, h.mph_perm)) < 0) {
			panic("migrate_spawn: sys_page_map: %e\n", r);
			sys_page_unmap(0, UTEMP);
			goto cleanup;
		}

		sys_page_unmap(0, UTEMP);
	}
	cprintf("[%08x] migrate_spawn: done reading pages\n", thisenv->env_id);
    cprintf("%08x\n", sh.msh_pgfault_upcall);
	if ((r = sys_env_set_pgfault_upcall(envid, &sh.msh_pgfault_upcall)) < 0) {
		panic("migrate_spawn: sys_env_set_pgfault_upcall%e\n", r);
		goto cleanup;
	}
	if ((r = sys_env_set_trapframe(envid, &sh.msh_tf)) < 0) {
		panic("migrate_spawn: sys_env_set_trapframe%e\n", r);
		goto cleanup;
	}
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
		panic("migrate_spawn: sys_env_set_status%e\n", r);
		goto cleanup;
	}
	cprintf("[%08x] migrate_spawn: done, marked env %08x as runnable\n",
				thisenv->env_id, envid);

	return envid;

cleanup:
	sys_env_destroy(envid);
	return r;
}

/*
 * Precondition and postcondition: f is a handle on an open file.
 */
static int
migrate_send_state(int f, struct Trapframe *tf) {
	int r;
	struct MigrateSuperHeader sh;
	struct MigratePageHeader h;

	const size_t n_pages = UTOP >> 12;
	// Manual "div round up", so that truncation doesn't lead us to miss pages
    const size_t n_pdx = (UTOP >> 22) + (UTOP % (1 << 22) == 0 ? 0 : 1);

	cprintf("[%08x]: entering migrate_send_state\n", thisenv->env_id);	

	uint32_t n_used_pages = 0;
	unsigned pn;
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
        if(vpd[pdx] & PTE_P) {
            for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
				if(vpt[pn] & PTE_P) {
					n_used_pages++;
				}
			}
		}
	}
	sh.msh_n_pages = n_used_pages;
    sh.msh_pgfault_upcall = thisenv->env_pgfault_upcall;
	sh.msh_magic = MIGRATE_MAGIC;
	sh.msh_tf = *tf;

	if ((r = write(f, &sh, sizeof(struct MigrateSuperHeader)))
				!= sizeof(struct MigrateSuperHeader)) {
		r = r < 0 ? r : -E_IO;
		return r;
	}
	
	cprintf("[%08x]: migrate_send_state: sent super header\n", thisenv->env_id);	
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
        if(vpd[pdx] & PTE_P) {
			for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
				if(vpt[pn] & PTE_P) {
					h.mph_magic = MIGRATE_PG_MAGIC;
					h.mph_addr = (void *)VA_OF_VPN(pn);	
					h.mph_perm = vpt[pn] & PTE_SYSCALL;
					if ((r = write(f, &h, sizeof(struct MigratePageHeader)))
							!= sizeof(struct MigratePageHeader)) {
						return r < 0 ? r : -E_IO;
					}
                    for(int i = 0; i < 4; i++)
                    {
					    if ((r = write(f, (char *)h.mph_addr + PGSIZE / 4 * i, PGSIZE/4)) != PGSIZE/4) {
						    return r < 0 ? r : -E_IO;
					    }
                    }
				}
            }
        }
    }

	cprintf("[%08x]: migrate_send_state: done sending pages.\n",
				thisenv->env_id);

	return 0;
}

/*
 * Migrate, resuming execution at [callback].
 * This function returns < 0 on error.  On success, it does not return.
 */
static 
int mig_help(void) {
    cprintf("wtf\n");
    thisenv = &envs[ENVX(sys_getenvid())];
    cprintf("%x\n", thisenv->env_id);
    return 0;
}

asmlinkage void mig(struct PushRegs *regs, uintptr_t *ebp, uintptr_t *esp);

int
migrate(void) {
	int r, writesock, readsock;
	int *x = NULL;
    struct Trapframe tf;
    mach_connect(&writesock, &readsock);
	
    sys_time_msec();
	memcpy(&tf, (const void *)&thisenv->env_tf, sizeof(struct Trapframe));
    mig(&tf.tf_regs, &tf.tf_regs.reg_ebp, &tf.tf_esp);
    tf.tf_eip = (uintptr_t)mig_help;
	if ((r = migrate_send_state(writesock, &tf)) < 0) 
		return r;
	
    // Destroy this environment iff we're successful.  Does not return.
	sys_env_destroy(0);
	panic("unreachable code\n");
}

/*
 * Migrate locally, resuming execution at [callback].
 * This function returns < 0 on error.  On success, it does not return.
 */
int
migrate_locally(void (*callback)(void)) {
	int r, p[2];
	
	if ((r = pipe(p)) < 0) {
		goto done;
	}

	// Hook up the read end of our pipe to migrated
	if ((r = pipe_ipc_send(ENVID_MIGRATED, p[0])) < 0) 	{
		goto cleanup_pipe;
	}

	// XXX: this is not yet right.
	// For now, just wipe the stack.
	struct Trapframe tf;
	memset(&tf, 0, sizeof(struct Trapframe));

	tf.tf_eip = (uintptr_t)callback;
	tf.tf_esp = USTACKTOP;
	tf.tf_regs.reg_ebp = USTACKTOP;

	tf.tf_ss = 0x3;
	// XXX: eflags (?), cs, es, ds

	if ((r = migrate_send_state(p[1], &tf)) < 0) {
		goto cleanup_pipe;
	}

	// Destroy this environment iff we're successful.  Does not return.
	sys_env_destroy(0);
	panic("unreachable code\n");

	// XXX: should this involve pipe_is_closed in some way?
cleanup_pipe:
	close(p[0]);
	close(p[1]);
done:
	return r;	
}
