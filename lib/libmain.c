// Called from entry.S to get us going.
// entry.S already took care of defining envs, pages, vpd, and vpt.

#include <inc/lib.h>

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
	// save the name of the program so that panic() can use it
	if (argc > 0)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
		((void(*)()) *--ctorva)();

	// Any process may fall victim to page eviction due to process migration
	// (either because the process forks something that then migrates, or
	// because the process has a pipe open with a process that migrates, etc).
	add_pgfault_handler(migrate_shared_page_fault_handler);

	// call user main routine
	umain(argc, argv);

	// exit gracefully
	exit();
}

