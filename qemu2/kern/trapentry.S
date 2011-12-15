/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* The TRAPHANDLER macro defines a globally-visible function for handling
 * a trap.
 * The function can be referenced from C++ after you declare it, for
 * instance using "asmlinkage FUNCTIONNAME()".
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 2: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(handler0, 0);
TRAPHANDLER_NOEC(handler1, 1);
TRAPHANDLER_NOEC(handler2, 2);
TRAPHANDLER_NOEC(handler3, 3);
TRAPHANDLER_NOEC(handler4, 4);
TRAPHANDLER_NOEC(handler5, 5);
TRAPHANDLER_NOEC(handler6, 6);
TRAPHANDLER_NOEC(handler7, 7);
TRAPHANDLER(handler8, 8);
TRAPHANDLER(handler10, 10);
TRAPHANDLER(handler11, 11);
TRAPHANDLER(handler12, 12);
TRAPHANDLER(handler13, 13);
TRAPHANDLER(handler14, 14);
TRAPHANDLER_NOEC(handler16, 16);
TRAPHANDLER(handler17, 17);
TRAPHANDLER_NOEC(handler18, 18);
TRAPHANDLER_NOEC(handler19, 19);
TRAPHANDLER_NOEC(handler20, 20);
TRAPHANDLER(handler21, 21);
TRAPHANDLER(handler22, 22);
TRAPHANDLER(handler23, 23);
TRAPHANDLER(handler24, 24);
TRAPHANDLER(handler25, 25);
TRAPHANDLER(handler26, 26);
TRAPHANDLER(handler27, 27);
TRAPHANDLER(handler28, 28);
TRAPHANDLER(handler29, 29);
TRAPHANDLER(handler30, 30);
TRAPHANDLER(handler31, 31);
TRAPHANDLER_NOEC(handler48, 48);

TRAPHANDLER_NOEC(irqhandler0, IRQ_OFFSET);
TRAPHANDLER_NOEC(irqhandler1, IRQ_OFFSET+1);
TRAPHANDLER_NOEC(irqhandler2, IRQ_OFFSET+2);
TRAPHANDLER_NOEC(irqhandler3, IRQ_OFFSET+3);
TRAPHANDLER_NOEC(irqhandler4, IRQ_OFFSET+4);
TRAPHANDLER_NOEC(irqhandler5, IRQ_OFFSET+5);
TRAPHANDLER_NOEC(irqhandler6, IRQ_OFFSET+6);
TRAPHANDLER_NOEC(irqhandler7, IRQ_OFFSET+7);
TRAPHANDLER_NOEC(irqhandler8, IRQ_OFFSET+8);
TRAPHANDLER_NOEC(irqhandler9, IRQ_OFFSET+9);
TRAPHANDLER_NOEC(irqhandler10, IRQ_OFFSET+10);
TRAPHANDLER_NOEC(irqhandler11, IRQ_OFFSET+11);
TRAPHANDLER_NOEC(irqhandler12, IRQ_OFFSET+12);
TRAPHANDLER_NOEC(irqhandler13, IRQ_OFFSET+13);
TRAPHANDLER_NOEC(irqhandler14, IRQ_OFFSET+14);
TRAPHANDLER_NOEC(irqhandler15, IRQ_OFFSET+15);


/*
 * Lab 2: Your code here for _alltraps
 */
_alltraps:
    pushal;
    # override es and ds with GD_KD
    push  %ds;
    push  %es;
    mov $GD_KD, %ax;
    mov %ax, %ds; 
    mov %ax, %es;

    push %esp; # pointer to trapframe
    call trap;
    pop %eax; # pop the trapframe pointer
    popl %es; # pop es
    popl %ds; # pop ds
    popal;
    add $8, %esp;
    iret;

