#include <inc/lib.h>
#include <inc/migrate.h>

void a() {
	thisenv = &envs[ENVX(sys_getenvid())];
	cprintf("[%08x]: Hello from your migrated process!\n", thisenv->env_id);
}

void
umain(int argc, char **argv) {
	void *addr = (void *)(USTACKTOP - 10*PGSIZE);
	cprintf("starting in umain\n");
	int r = fork();
	if (r < 0) panic("testmigrate: fork: %e\n", r);
	if (r == 0) {
		for (int i = 0; i < 100; i++) {
			sys_yield();
		}
		cprintf("CHILD: going to migrate locally\n");
		cprintf("CHILD: physical pg num: %x\n", PGNUM(vpt[PGNUM(addr)]));
		int *addr_int = (int *)addr;
		addr_int[1] = 55;
		int r = migrate();
		cprintf("[%08x]: Hello from your migrated process!\n", thisenv->env_id);
		cprintf("addr_int[0] = %d, addr_int[1] = %d\n",
				addr_int[0], addr_int[1]);
		return;
	}
	else {
		envid_t envid = (envid_t)r;
		cprintf("XXX LA LA LA: fork good.  new envid %x\n", envid);
		if (sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W) < 0)
			panic("sys_page_alloc");
		if (sys_page_map(0, addr, envid, addr, PTE_U | PTE_P | PTE_W) < 0)
			panic("sys_page_map");
		cprintf("XXX LA LA LA: mapped a shared page.\n");
		cprintf("XXX LA LA LA: physical pg num: %x\n", PGNUM(vpt[PGNUM(addr)]));
		int *addr_int = (int *)addr;
		addr_int[0] = 60;
		for (int i = 0; i < 6000; i++) {
			sys_yield();
		}
		cprintf("TRYING TO WRITE TO THE PAGE THAT GOT MIGRATED AWAY\n");
		addr_int[2] = 42;
		cprintf("SUCCESSFULLY WROTE TO THE PAGE THAT GOT MIGRATED AWAY\n");
		cprintf("AND THE ANSWER IS: %d\n", addr_int[0]);
		cprintf("AND THE ANSWER IS: %d\n", addr_int[1]);
		cprintf("AND THE ANSWER IS: %d\n", addr_int[2]);
		while (1) sys_yield() ;
	}
}
