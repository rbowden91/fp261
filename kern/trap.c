#include <inc/mmu.h>
#include <inc/x86.h>
#include <inc/assert.h>
#include <inc/string.h>

#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/time.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/env.h>
#include <kern/syscall.h>
#include <kern/sched.h>
#include <kern/kclock.h>
#include <kern/picirq.h>
#include <kern/e1000.h>

// Global descriptor table.
//
// The kernel and user segments are identical except for the DPL.
// To load the SS register, the CPL must equal the DPL.  Thus,
// we must duplicate the segments for the user and the kernel.
// The last segment, the "task state segment", is used for grody x86
// purposes.
//
static struct Taskstate ts;

static struct Segdesc gdt[] = {
	SEG_NULL,				// 0x0 - unused (always faults)
	SEG(STA_X | STA_R, 0x0, 0xffffffff, 0), // 0x8 - kernel code segment
	SEG(STA_W, 0x0, 0xffffffff, 0),		// 0x10 - kernel data segment
	SEG(STA_X | STA_R, 0x0, 0xffffffff, 3), // 0x18 - user code segment
	SEG(STA_W, 0x0, 0xffffffff, 3),		// 0x20 - user data segment
	SYSSEG16(STS_T32A, (uint32_t)(&ts), sizeof(struct Taskstate), 0)
						// 0x28 - task state segment
						// (grody x86 internals)
};

struct Pseudodesc gdt_pd = {
	sizeof(gdt) - 1, (unsigned long) gdt
};

// Interrupt descriptor table.  (Must be built at run time because
// shifted function addresses can't be represented in relocation records.)
//
struct Gatedesc idt[256] = { { 0 } };
struct Pseudodesc idt_pd = {
	sizeof(idt) - 1, (uint32_t) idt
};


static const char *trapname(int trapno)
{
	static const char * const excnames[] = {
		"Divide error",
		"Debug",
		"Non-Maskable Interrupt",
		"Breakpoint",
		"Overflow",
		"BOUND Range Exceeded",
		"Invalid Opcode",
		"Device Not Available",
		"Double Fault",
		"Coprocessor Segment Overrun",
		"Invalid TSS",
		"Segment Not Present",
		"Stack Fault",
		"General Protection",
		"Page Fault",
		"(unknown trap)",
		"x87 FPU Floating-Point Error",
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < (int) (sizeof(excnames)/sizeof(excnames[0])))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}

// DUMB DECLARATIONS FOR HANDLERS
asmlinkage void irqhandler0();
asmlinkage void irqhandler1();
asmlinkage void irqhandler2();
asmlinkage void irqhandler3();
asmlinkage void irqhandler4();
asmlinkage void irqhandler5();
asmlinkage void irqhandler6();
asmlinkage void irqhandler7();
asmlinkage void irqhandler8();
asmlinkage void irqhandler9();
asmlinkage void irqhandler10();
asmlinkage void irqhandler11();
asmlinkage void irqhandler12();
asmlinkage void irqhandler13();
asmlinkage void irqhandler14();
asmlinkage void irqhandler15();
asmlinkage void handler0();
asmlinkage void handler1();
asmlinkage void handler2();
asmlinkage void handler3();
asmlinkage void handler4();
asmlinkage void handler5();
asmlinkage void handler6();
asmlinkage void handler7();
asmlinkage void handler8();
asmlinkage void handler10();
asmlinkage void handler11();
asmlinkage void handler12();
asmlinkage void handler13();
asmlinkage void handler14();
asmlinkage void handler16();
asmlinkage void handler17();
asmlinkage void handler18();
asmlinkage void handler19();
asmlinkage void handler20();
asmlinkage void handler21();
asmlinkage void handler22();
asmlinkage void handler23();
asmlinkage void handler24();
asmlinkage void handler25();
asmlinkage void handler26();
asmlinkage void handler27();
asmlinkage void handler28();
asmlinkage void handler29();
asmlinkage void handler30();
asmlinkage void handler31();
asmlinkage void handler48();


void
idt_init(void)
{
	extern struct Segdesc gdt[];

	// Set a gate for the system call interrupt.
	// Hint: Must this gate be accessible from userlevel?

	// LAB 3 (Exercise 4): Your code here.

    // DUMB GATE SETTINGS FOR HANDLERS 
    SETGATE(idt[IRQ_OFFSET+0], 0, 0x8, irqhandler0, 0);
    SETGATE(idt[IRQ_OFFSET+1], 0, 0x8, irqhandler1, 0);
    SETGATE(idt[IRQ_OFFSET+2], 0, 0x8, irqhandler2, 0);
    SETGATE(idt[IRQ_OFFSET+3], 0, 0x8, irqhandler3, 3);
    SETGATE(idt[IRQ_OFFSET+4], 0, 0x8, irqhandler4, 0);
    SETGATE(idt[IRQ_OFFSET+5], 0, 0x8, irqhandler5, 0);
    SETGATE(idt[IRQ_OFFSET+6], 0, 0x8, irqhandler6, 0);
    SETGATE(idt[IRQ_OFFSET+7], 0, 0x8, irqhandler7, 0);
    SETGATE(idt[IRQ_OFFSET+8], 0, 0x8, irqhandler8, 0);
    SETGATE(idt[IRQ_OFFSET+9], 0, 0x8, irqhandler9, 0);
    SETGATE(idt[IRQ_OFFSET+10], 0, 0x8, irqhandler10, 0);
    SETGATE(idt[IRQ_OFFSET+11], 0, 0x8, irqhandler11, 0);
    SETGATE(idt[IRQ_OFFSET+12], 0, 0x8, irqhandler12, 0);
    SETGATE(idt[IRQ_OFFSET+13], 0, 0x8, irqhandler13, 0);
    SETGATE(idt[IRQ_OFFSET+14], 0, 0x8, irqhandler14, 0);
    SETGATE(idt[IRQ_OFFSET+15], 0, 0x8, irqhandler15, 0);
    SETGATE(idt[0], 0, 0x8, handler0, 0);
    SETGATE(idt[1], 0, 0x8, handler1, 0);
    SETGATE(idt[2], 0, 0x8, handler2, 0);
    SETGATE(idt[3], 0, 0x8, handler3, 3);
    SETGATE(idt[4], 0, 0x8, handler4, 0);
    SETGATE(idt[5], 0, 0x8, handler5, 0);
    SETGATE(idt[6], 0, 0x8, handler6, 0);
    SETGATE(idt[7], 0, 0x8, handler7, 0);
    SETGATE(idt[8], 0, 0x8, handler8, 0);
    SETGATE(idt[10], 0, 0x8, handler10, 0);
    SETGATE(idt[11], 0, 0x8, handler11, 0);
    SETGATE(idt[12], 0, 0x8, handler12, 0);
    SETGATE(idt[13], 0, 0x8, handler13, 0);
    SETGATE(idt[14], 0, 0x8, handler14, 0);
    SETGATE(idt[16], 0, 0x8, handler16, 0);
    SETGATE(idt[17], 0, 0x8, handler17, 0);
    SETGATE(idt[18], 0, 0x8, handler18, 0);
    SETGATE(idt[19], 0, 0x8, handler19, 0);
    SETGATE(idt[20], 0, 0x8, handler20, 0);
    SETGATE(idt[21], 0, 0x8, handler21, 0);
    SETGATE(idt[22], 0, 0x8, handler22, 0);
    SETGATE(idt[23], 0, 0x8, handler23, 0);
    SETGATE(idt[24], 0, 0x8, handler24, 0);
    SETGATE(idt[25], 0, 0x8, handler25, 0);
    SETGATE(idt[26], 0, 0x8, handler26, 0);
    SETGATE(idt[27], 0, 0x8, handler27, 0);
    SETGATE(idt[28], 0, 0x8, handler28, 0);
    SETGATE(idt[29], 0, 0x8, handler29, 0);
    SETGATE(idt[30], 0, 0x8, handler30, 0);
    SETGATE(idt[31], 0, 0x8, handler31, 0);
    SETGATE(idt[48], 0, 0x8, handler48, 3);
	// Load the GDT (global [segment] descriptor table).
	// Segments serve many purposes on the x86.  We don't use any of their
	// memory-mapping capabilities, but we need them to set
	// privilege levels and to point to the task state segment.
	asm volatile("lgdt gdt_pd");
	// Immediately reload segment registers.
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	asm volatile("lldt %%ax" : : "a" (0));

	// Load the interrupt descriptor table (IDT).
	asm volatile("lidt idt_pd");

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
	ts.ts_ss0 = GD_KD;

	// Load the TSS.
	ltr(GD_TSS);
}


void
print_trapframe(struct Trapframe *tf, bool trap_just_happened)
{
	cprintf("Trap frame at %p\n", tf);
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s", tf->tf_trapno, trapname(tf->tf_trapno));
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (trap_just_happened && tf->tf_trapno == T_PGFLT)
		cprintf(" [la 0x%08x]", rcr2());
	cprintf("\n  err  0x%08x", tf->tf_err);
	// For page faults, print unparsed fault error code:
	// U=fault occurred in user mode (K=kernel),
	// WR=a write caused the fault (R=read),
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [fault err %s,%s,%s]",
			tf->tf_err & 4 ? "U" : "K",
			tf->tf_err & 2 ? "W" : "R",
			tf->tf_err & 1 ? "PR" : "NP");
	cprintf("\n  eip  0x%08x\n", tf->tf_eip);
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
	cprintf("  esp  0x%08x\n", tf->tf_esp);
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
}

void
print_regs(struct PushRegs *regs)
{
	cprintf("  edi  0x%08x\n", regs->reg_edi);
	cprintf("  esi  0x%08x\n", regs->reg_esi);
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
	cprintf("  edx  0x%08x\n", regs->reg_edx);
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
	cprintf("  eax  0x%08x\n", regs->reg_eax);
}

static uint8_t e1000_irqno = 0;

void
set_e1000_irqno(uint8_t e)
{
    e1000_irqno = e;
}

static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle page faults by calling page_fault_handler.

	// LAB 3 (Exercise 3): Your code here.

	// Handle system calls.
	// Extract the system call number and arguments from 'tf',
	// call 'syscall', and arrange for the return value to be passed
	// back to the caller.
	// LAB 3 (Exercise 4): Your code here.

	// Handle clock interrupts.
	// LAB 4: Your code here.


	// Handle keyboard interrupts.
	// LAB 5: Your code here.

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		cprintf("Spurious interrupt on irq 7\n");
		print_trapframe(tf, true);
		return;
	}

    if (e1000_irqno && tf->tf_trapno == (uint32_t)IRQ_OFFSET + e1000_irqno)
    {
        e1000_trap_handler();
        return;
    }

    switch (tf->tf_trapno)
    {
        case T_BRKPT:
        monitor(tf);
        break;
        case T_PGFLT:
        page_fault_handler(tf);
        break;
        case T_SYSCALL:
        tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,tf->tf_regs.reg_ebx,tf->tf_regs.reg_edi,tf->tf_regs.reg_esi);
        break;
	    // Unexpected trap: The user process or the kernel has a bug.
        case IRQ_KBD+IRQ_OFFSET:
        kbd_intr();
        break;
        case IRQ_TIMER+IRQ_OFFSET:
        time_tick();
        sched_yield();
        break;
        default:
        print_trapframe(tf, true);
        if (tf->tf_cs == GD_KT)
	    	panic("unhandled trap in kernel");
	    else {
		    env_destroy(curenv);
		    return;
        }
    }
}

asmlinkage void
trap(struct Trapframe *tf)
{
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" : : : "cc");

	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));

	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		assert(curenv);
		curenv->env_tf = *tf;
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
	}

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNABLE)
		env_run(curenv);
	else
		sched_yield();
}


void
page_fault_handler(struct Trapframe *tf)
{
    uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Page faults in the kernel should cause a panic.
	// LAB 3 (Exercise 8): Your code here.
    if (tf->tf_cs == GD_KT)
    {
        print_trapframe(tf, true);
        panic("Page fault in kernel!!");
	}
    // If we get here, the page fault happened in user mode.

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
	//
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	//
	// In both cases, leave an extra 4 bytes of padding, just below the
	// UTrapframe, to agree with the C calling convention. (What is this
	// padding?)
	//
	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack, the environment can't write to its
	// exception stack page, or the exception stack overflows, then destroy
	// the environment that caused the fault.
	// The grade script assumes you will first check for the page fault
	// upcall and print the "user fault va" message below if there is
	// none.
	//
	// Note that when this function runs, 'tf == &curenv->env_tf'.

	// LAB 4: Your code here.
    
	pte_t *pte = NULL;
    uint32_t *trap_addr = NULL;

    if(!curenv->env_pgfault_upcall) 
    {
        cprintf("[%08x] user fault va %08x ip %08x\n",
            curenv->env_id, fault_va, tf->tf_eip);
        print_trapframe(tf, true);
    }
    user_mem_assert(curenv, curenv->env_pgfault_upcall, 1, PTE_U | PTE_P);
    user_mem_assert(curenv, UXSTACKTOP-PGSIZE, PGSIZE, PTE_U | PTE_P | PTE_W);
    
    if (tf->tf_esp >= USTACKTOP)
    {
        if (tf->tf_esp - 14 < UXSTACKTOP - PGSIZE || tf->tf_esp > UXSTACKTOP-1)
            env_destroy(curenv);
        trap_addr = (uint32_t *)tf->tf_esp;
    }
    else
        trap_addr = (uint32_t *)UXSTACKTOP;
    trap_addr -= 3;
    user_mem_assert(curenv, tf->tf_esp - 4, 4, PTE_U | PTE_P);
    memcpy(trap_addr, (uint32_t [])
           {tf->tf_eflags, (uint32_t)tf->tf_esp, tf->tf_eip}, 12);
    trap_addr -= sizeof(tf->tf_regs)/sizeof(uint32_t);
    memcpy(trap_addr, &tf->tf_regs, sizeof(tf->tf_regs));
    *(trap_addr - 1) = tf->tf_err;
    *(trap_addr - 2) = fault_va;
    tf->tf_esp = (uint32_t)(trap_addr - 3);
    tf->tf_eip = curenv->env_pgfault_upcall;
    return;
}
