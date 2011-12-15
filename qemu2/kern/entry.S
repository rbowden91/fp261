/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

# Shift Right Logical
#define SRL(val, shamt)		(((val) >> (shamt)) & ~(-1 << (32 - (shamt))))


###################################################################
# The kernel (this code) is linked at address KERNBASE+1MB (0xF0100000),
# but the bootloader loads it at address 1MB (0x00100000).
# RELOC(x) maps a symbol x from its link address to its actual
# location in physical memory (its load address).
###################################################################
#define	RELOC(x) ((x) - KERNBASE)


.text

#define MULTIBOOT_HEADER_MAGIC (0x1BADB002)
#define MULTIBOOT_HEADER_FLAGS (0)
#define CHECKSUM (-(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS))

# The Multiboot header
.align 4
.long MULTIBOOT_HEADER_MAGIC
.long MULTIBOOT_HEADER_FLAGS
.long CHECKSUM

# '_start' specifies the ELF entry point.  Since we haven't set up
# virtual memory when the bootloader enters this code, we need the
# bootloader to jump to the *physical* address of the entry point.
.globl _start
_start = RELOC(entry)


###################################################################
# Entry point
###################################################################
.globl entry
entry:
	movw	$0x1234,0x472			# warm boot

        # We haven't set up virtual memory yet, so we're running from
        # an address close to 1MB.  However, the C code is linked to run at
        # KERNBASE+1MB.  Hence, we set up a simple page directory that
        # translates virtual addresses [KERNBASE, KERNBASE+16MB) to
        # physical addresses [0, 16MB).  This 16MB region will suffice
        # until we set up our real page table in i386_vm_init in lab 2.

	# Load the physical address of entry_pgdir into %cr3.
	movl	$(RELOC(entry_pgdir)), %eax
	movl	%eax, %cr3
	# Turn on the page size extension required by entry_pgdir.
	movl	%cr4, %eax
	orl	$(CR4_PSE), %eax
	movl	%eax, %cr4
	# Turn on paging.
	movl	%cr0, %eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
	movl	%eax, %cr0

	# Leave a few words on the stack for the user trap frame.
	movl	$(entry_stacktop-SIZEOF_STRUCT_TRAPFRAME), %esp

	# Clear the frame pointer register %ebp and push a fake return address
	# so that once we start debugging in kern/monitor.c,
	# stack backtraces will be terminated properly.
	movl	$0, %ebp		# clear frame pointer
	pushl	$(spin)			# fake return address

	# Now to C code.
	# ("jmp i386_init" doesn't work on its own: we need an absolute jump.)
	movl	$(i386_init), %eax
	jmp	*%eax

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin


.data

###################################################################
# Initial page directory (entry_pgdir)
#
# This simple page directory helps the kernel bootstrap itself until
# it's time for full-fledged virtual memory.
# All it must do is ensure that the kernel's code and global data, which
# is stored in physical addresses like 1MB (0x00010000),
# can also be accessed via virtual addresses like KERNBASE+1MB (0xF0010000).
# (Question: How does it work?  See Section 4.3 of the Intel IA32-3 manual.)
###################################################################
.p2align PGSHIFT		# force page alignment
.globl entry_pgdir
entry_pgdir:
	.long	((0 << PTSHIFT) | PTE_P | PTE_W | PTE_PS)
	.space	(PDX(KERNBASE) - 1) * 4
	.long	((0 << PTSHIFT) | PTE_P | PTE_W | PTE_PS)
	.long	((1 << PTSHIFT) | PTE_P | PTE_W | PTE_PS)
	.long	((2 << PTSHIFT) | PTE_P | PTE_W | PTE_PS)
	.long	((3 << PTSHIFT) | PTE_P | PTE_W | PTE_PS)
	.space	(NPTENTRIES - PDX(KERNBASE) - 4) * 4

###################################################################
# Initial stack (entry_stack)
###################################################################
.p2align PGSHIFT		# force page alignment
.globl entry_stack
entry_stack:
	.space	KSTKSIZE
.globl entry_stacktop
entry_stacktop:

