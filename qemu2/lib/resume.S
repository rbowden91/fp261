#include <inc/mmu.h>
#include <inc/memlayout.h>

// Resume execution as specified by a struct UTrapframe.
// All general-purpose registers, flags, stack status, and program counter
// are reset from their values in the *utf argument.
//
// Called from C using the prototype:
//
// asmlinkage void resume(struct UTrapframe *utf) __attribute__((noreturn));
//
// - resume() is allowed to modify *utf.
// - The stack at 'utf->utf_esp' must not overlap with *utf.

.text
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
	// Now the stack pointer points at the UTrapframe.

	// So, how do we return to the stack and registers specified by *utf?
	//   This is a tough problem!
	//   We can't call 'jmp', since that requires that we load the address
	//   into a register, and all registers must have the *utf values
	//   upon resume.
	//   We can't call 'ret' from here either, since %esp would be wrong
	//   upon resume.
	//   How can we set %eip and %esp at the same time? It seems
	//   impossible! But we can do it, by using the stack at
	//   'utf->utf_esp' as a staging area. resume() is allowed to modify
	//   the portion of the old stack that lies below the old stack
	//   pointer, 'utf->utf_esp'.
	//
	// Throughout the remaining code, think carefully about what
	// registers are available for intermediate calculations.  Remember
	// that some instructions, such as arithmetic instructions, can
	// modify the %eflags register, and therefore must be executed
	// before %eflags has been restored to the utf->utf_eflags value.
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
    movl 40(%esp), %eax
    movl 36(%esp), %ebx
    subl $4, %ebx
    movl %eax, (%ebx)
    movl %ebx, 36(%esp)
    popal
    popf
    popl %esp
    ret

spin:	jmp spin
