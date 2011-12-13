/* See COPYRIGHT for copyright information. */

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/assert.h>

#include <kern/env.h>
#include <kern/sched.h>
#include <kern/monitor.h>
#include <kern/console.h>
#include <kern/pmap.h>
#include <kern/kclock.h>
#include <kern/trap.h>
#include <kern/picirq.h>
#include <kern/pci.h>
#include <kern/time.h>
#include <kern/e1000.h>
// Test the stack backtrace function (used in lab 1 only)
void
test_backtrace(int x)
{
	cprintf("entering test_backtrace %d\n", x);
	if (x > 0)
		test_backtrace(x-1);
	else
		mon_backtrace(0, 0, 0);
	cprintf("leaving test_backtrace %d\n", x);
}

// Test kernel breakpoint functionality (used in lab 2 only)
static void test_kernel_breakpoint(void) __attribute__((noinline));
static void
test_kernel_breakpoint(void)
{
	__asm__ __volatile__("int3");
	// Then the breakpoint should return (after the user types 'exit')
	cprintf("Breakpoint succeeded!\n");
}

asmlinkage void
i386_init(void)
{
	extern char edata[], end[];
	extern const uintptr_t sctors[], ectors[];
	const uintptr_t *ctorva;

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();

	// Then call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see kern/kernel.ld.
	// Call after cons_init() so we can cprintf() if necessary.
	for (ctorva = ectors; ctorva > sctors; )
		((void(*)()) *--ctorva)();

	// Lab 2 memory management initialization functions
	mem_init();
	
    // Lab 2 interrupt and gate descriptor initialization functions
	idt_init();

	// Lab 3 user environment initialization functions
	env_init();

	// Lab 4 multitasking initialization functions
	pic_init();
	kclock_init();

    time_init();
    pci_init();

    //const char *c = "hello, world!";
    //e1000_transmit((void *)c, 13);

	// Should always have an idle process as first one.
	ENV_CREATE(user_idle);

	// Start bufcache.  Bufcache is always meant to run as environment
	// 0x1100, so we rearrange the free list to put that environment first.
	{
		extern struct Env *env_free_list;
		struct Env **pprev = &env_free_list, *bce = 0;
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
			if (*pprev == &envs[ENVX(ENVID_BUFCACHE)]) {
				struct Env *e = *pprev;
				*pprev = e->env_link;
				e->env_link = env_free_list;
				env_free_list = e;
				break;
			}
	}
	ENV_CREATE(fs_bufcache);

    {
		extern struct Env *env_free_list;
		struct Env **pprev = &env_free_list, *bce = 0;
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
			if (*pprev == &envs[ENVX(ENVID_NS)]) {
				struct Env *e = *pprev;
				*pprev = e->env_link;
				e->env_link = env_free_list;
				env_free_list = e;
				break;
			}
	}
	ENV_CREATE(net_ns);

#if defined(TEST)
//    ENV_CREATE2(TEST, TESTSIZE);
#else
	// Touch all you want.
	// ENV_CREATE(user_writemotd);
	// ENV_CREATE(user_testfile);
	// ENV_CREATE(user_icode);
#endif // TEST*

	ENV_CREATE(user_echosrv);

	// Schedule and run a user environment!
	// We want to run the bufcache first.
	env_run(&envs[ENVX(ENVID_BUFCACHE)]);

	// Test IDT (lab 2 only)
	//test_kernel_breakpoint();

	// Test the stack backtrace function (lab 1 only)
	//test_backtrace(5);

	// Drop into the kernel monitor (lab 1-2 only; not reached later)
	while (1)
		monitor(NULL);
}


/*
 * Variable panicstr contains argument to first call to panic; used as flag
 * to indicate that the kernel has already called panic.
 */
static const char *panicstr;

/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
	va_list ap;

	if (panicstr)
		goto dead;
	panicstr = fmt;

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");

	va_start(ap, fmt);
	cprintf("kernel panic at %s:%d: ", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	cprintf("kernel warning at %s:%d: ", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);
}
