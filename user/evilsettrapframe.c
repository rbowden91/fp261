#include <inc/lib.h>
#include <inc/x86.h>
	struct Trapframe tf;

void
destination(void)
{
	// Switch back to user stack, in case we left it
	asm volatile("mov %0, %%esp" : : "g" (USTACKTOP - 24));
	// Grant myself read-write access to UVPT!
	physaddr_t vpd_physaddr = PTE_ADDR(vpd[PDX(UVPT)]);
	pde_t *writable_vpd = (pde_t *) (vpd_physaddr + KERNBASE);
	writable_vpd[PDX(UVPT)] |= PTE_W;

	cprintf("sys_env_set_trapframe works inappropriately\n");
	// That cprintf() will fail to return, because the int $48 system call
	// works differently than our kernel expects when executed from the
	// same privilege level.
	sys_env_destroy(0);
}

void
umain(int argc, char **argv)
{
	memcpy(&tf, (void *) &thisenv->env_tf, sizeof(Trapframe));
	tf.tf_eip = (uintptr_t) destination;

	// try to get kernel privilege, HEH HEH HEH
	tf.tf_cs = GD_KT;
	tf.tf_es = tf.tf_ds = tf.tf_ss = GD_KD;
	sys_env_set_trapframe(0, &tf);

	cprintf("should not be reached\n");
}
