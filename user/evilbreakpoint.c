// program to cause a breakpoint trap -- but the debugging symbols
// are invalid!

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	uintptr_t *stabs = (uintptr_t *) 0x200000;
	*stabs = 0;

	asm volatile("int $3");
}
