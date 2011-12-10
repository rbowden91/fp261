#include <inc/lib.h>
#include <inc/connect.h>
#include <inc/x86.h>
#include <inc/migrate.h>

// XXX: this might not be a very good place for this #define... perhaps
// it should be protected.
#define VA_OF_VPN(vpn) ((vpn) << 12)

#define PTE_REMOTE 0x400 // XXX FIXME: duplicated in kern/pmap.h

int
migrate_client_open_write_pipe(uint32_t network_addr) {
	int r, p[2];
	if ((r = pipe(p)) < 0) {
		return r;
	}

	// Hook up the read end of our pipe to migrated
	if ((r = pipe_ipc_send(ENVID_MIGRATE_CLIENT, p[0])) < 0) 	{
		close(p[0]);
		close(p[1]);
		return r;
	}

	// XXX: should I actually close this?
	close(p[0]);
	return p[1];
}

int
migrate_client_open_read_pipe(uint32_t network_addr) {
	envid_t envid;
	return pipe_ipc_recv_read(&envid);
}

int
migrate_request_page(physaddr_t local_physaddr, uint32_t network_addr,
						physaddr_t remote_physaddr) {
	int r, f;
	if ((f = migrate_client_open_write_pipe(network_addr)) < 0) {
		return f;
	}

	struct MigratePageRequest request;
	request.mpr_magic = MIGRATE_PG_REQUEST_MAGIC;
	request.mpr_src_envid = thisenv->env_id;
	request.mpr_physaddr = remote_physaddr;
	request.mpr_physaddr_on_requesting_machine = local_physaddr;

	if ((r = write(f, &request, sizeof(struct MigratePageRequest)))
			!= sizeof(struct MigratePageRequest)) {
		return r < 0 ? r : -E_IO;
	}
	close(f);

	if ((f = migrate_client_open_read_pipe(network_addr)) < 0) {
		return f;
	}

	cprintf("migrate_request_page: succesfully opened ipc\n");

	struct MigratePageRequestResponseHeader response;
	if ((r = read(f, &response,sizeof(struct MigratePageRequestResponseHeader)))
			!= sizeof(struct MigratePageRequestResponseHeader)) {
		cprintf("die 1\n");
		return r < 0 ? r : -E_IO;
	}
	
	if (response.mprr_magic != MIGRATE_PG_REQUEST_RESPONSE_MAGIC
			|| response.mprr_physaddr != local_physaddr) {
		cprintf("die 2\n");
		return -E_IO;
	}

	if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0) {
		return r;
	}
	for (int i = 0; i < 4; i++) {
		if ((r = readn(f, (char *)UTEMP + PGSIZE / 4 * i, PGSIZE/4)) != PGSIZE/4) {
			cprintf("die 4. r: %x\n", r);
			return r < 0 ? r : -E_IO;
		}
	}

	return 0;
}

int
migrate_recover_page(physaddr_t local_physaddr, uint32_t network_addr,
					 physaddr_t remote_physaddr) {
	// Step 1) Send an IPC to migrate_client requesting the page.  Receive
	//         it at a freshly allocate page at UTEMP.
	// Step 2) Copy this page from UTEMP back to physaddr
	int r = migrate_request_page(local_physaddr, network_addr, remote_physaddr);
	if (r < 0) {
		return r;
	}

	return sys_page_recover(local_physaddr >> PGSHIFT);
}

int
migrate_recover_remote_page(uintptr_t addr) {
	if (!(vpd[PDX(addr)] & PTE_P))
		return -E_INVAL;
	pte_t pte = vpt[PGNUM(addr)];
	const volatile struct Page *pg = &pages[PGNUM(pte)];
	return migrate_recover_page(PTE_ADDR(pte),
								pg->pp_remote_network_addr,
								pg->pp_remote_page_physaddr);
}

void
migrate_shared_page_fault_handler(struct UTrapframe *utf) {
	if(utf == NULL)
		panic("utf is null!");
	
	cprintf("OMG OMG OMG\n");
	uintptr_t addr = utf->utf_fault_va;

	if (!(vpd[PDX(addr)] & PTE_P))
		return;
	pte_t pte = vpt[PGNUM(addr)];

	if (pte & PTE_REMOTE) {
		if (migrate_recover_remote_page(addr) < 0) {
			return;
		}
		else {
			resume(utf);
		}
	}
	return;
}

int
migrate_process_page_request(int f) {
	int r;
	struct MigratePageRequest request;
	// If we got here, then user/migrated.c already read MIGRATE_MAGIC
	if ((r = readn(f, ((char*)&request)+4, sizeof(struct MigratePageRequest)-4))
			!= sizeof(struct MigratePageRequest)-4) {
		cprintf("MIGRATED: migrate_process_page_request: read header failed\n");
		return (r < 0) ? r : -E_IO;
	}

	if ((r = sys_page_evict(request.mpr_physaddr >> PGSHIFT)) < 0) {
		cprintf("migrated: migrate_proc_pg_req: evict failed\n");
		return r;
	}

	int p[2];
	if ((r = pipe(p)) < 0) {
		cprintf("migrated: migrate_proc_pg_req: pipe failed\n");
		return r;
	}
	if ((r = pipe_ipc_send(ENVID_MIGRATE_CLIENT, p[0])) < 0) {
		cprintf("migrated: migrate_proc_pg_req: pipe_ipc_send failed\n");
		return r;
	}
	close(p[0]);
	int wf = p[1];

	cprintf("set up a pipe ipc with migrate client.  trying to send page.\n");
	struct MigrateResponseHeader response_header;
	response_header.mr_magic = MIGRATE_RESPONSE_MAGIC;
	cprintf("migrate daemon: mpr_src_envid: %d\n", request.mpr_src_envid);
	assert(request.mpr_src_envid != 0);
	response_header.mr_recipient_envid = request.mpr_src_envid;
	if ((r = write(wf, &response_header, sizeof(struct MigrateResponseHeader)))
			!= sizeof(struct MigrateResponseHeader)) {
		sys_page_unmap(0, UTEMP);
		return (r < 0) ? r : -E_IO;
	}
	cprintf("sent response header.\n");

	struct MigratePageRequestResponseHeader page_request_response_header;
	page_request_response_header.mprr_magic =
		MIGRATE_PG_REQUEST_RESPONSE_MAGIC;
	page_request_response_header.mprr_physaddr =
		request.mpr_physaddr_on_requesting_machine;
	if ((r = write(wf, &page_request_response_header,
					sizeof(struct MigratePageRequestResponseHeader)))
			!= sizeof(struct MigratePageRequestResponseHeader)) {
		sys_page_unmap(0, UTEMP);
		return (r < 0) ? r : -E_IO;
	}
	cprintf("sent page request response header\n");

	// Send the page itself.
	for (int i = 0; i < 4; i++)
	{
		if ((r = write(wf, (char *)UTEMP + PGSIZE / 4 * i, PGSIZE/4)) != PGSIZE/4) {
			sys_page_unmap(0, UTEMP);
			return r < 0 ? r : -E_IO;
		}
		return (r < 0) ? r : -E_IO;
	}
	cprintf("sent page itself\n");

	sys_page_unmap(0, UTEMP);
	cprintf("MIGRATED: migrate_process_page_request: done\n");
	return 0;
}

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
