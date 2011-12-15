// Ping-pong a counter between two processes.
// Only need to start one of these -- splits into two, crudely.

#include <inc/string.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	envid_t who;
	int i;
	// fork a child process]
	who = schedfork();

    envid_t me = sys_getenvid();
	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
		cprintf("%d: I am  %u! I have priority %d\n", i, me, thisenv->env_priority);
		sys_yield();
	}
}
