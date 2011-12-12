#include <inc/lib.h>

void
destination(void)
{
	cprintf("sys_env_set_trapframe works\n");
	sys_env_destroy(0);
}

void
umain(int argc, char **argv)
{
	struct Trapframe tf;
	memcpy(&tf, (void *) &thisenv->env_tf, sizeof(Trapframe));
	tf.tf_eip = (uintptr_t) destination;
	sys_env_set_trapframe(0, &tf);

	cprintf("should not be reached\n");
}
