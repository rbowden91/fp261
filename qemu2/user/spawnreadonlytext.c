#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
	if ((r = spawnl("readonlytext", "readonlytext", 0)) < 0)
		panic("spawn(readonlytext) failed: %e", r);
}
