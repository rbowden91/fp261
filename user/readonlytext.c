#include <inc/lib.h>
#include <inc/x86.h>

void
my_handler(struct UTrapframe *utf)
{
	if (utf->utf_fault_va == (uintptr_t) my_handler
	    && (utf->utf_err & FEC_U)
	    && (utf->utf_err & FEC_W)
	    && (utf->utf_err & FEC_PR))
		cprintf("program text is read-only\n");
	else
		cprintf("unexpected page fault\n");
	sys_env_destroy(0);
	/* should not be reached */
	resume(utf);
}

void
umain(int argc, char **argv)
{
	add_pgfault_handler(my_handler);

	volatile uint32_t *ptr = (volatile uint32_t *) my_handler;
	*ptr = *ptr;

	cprintf("should not be reached\n");
}
