
obj/boot/boot.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
.set CR0_PE_ON,      0x1         # protected mode enable flag

.globl start
start:
  .code16                     # Assemble for 16-bit mode
  cli                         # Disable interrupts
    7c00:	fa                   	cli    
  cld                         # String operations increment
    7c01:	fc                   	cld    

  # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c0a:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0c:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c14:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c16:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1c:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode, using a bootstrap GDT
  # and segment translation that makes virtual addresses
  # identical to their physical addresses, so that the
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	64                   	fs
    7c22:	7c 0f                	jl     7c33 <protcseg+0x1>
  movl    %cr0, %eax
    7c24:	20 c0                	and    %al,%al
  orl     $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0

  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
  ljmp    $PROT_MODE_CSEG, $protcseg
    7c2d:	ea 32 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c32

00007c32 <protcseg>:

  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c40:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call bootmain
    7c45:	e8 d7 00 00 00       	call   7d21 <bootmain>

00007c4a <spin>:

  # If bootmain returns (it shouldn't), loop.
spin:
  jmp spin
    7c4a:	eb fe                	jmp    7c4a <spin>

00007c4c <gdt>:
	...
    7c54:	ff                   	(bad)  
    7c55:	ff 00                	incl   (%eax)
    7c57:	00 00                	add    %al,(%eax)
    7c59:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c60:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

00007c64 <gdtdesc>:
    7c64:	17                   	pop    %ss
    7c65:	00 4c 7c 00          	add    %cl,0x0(%esp,%edi,2)
    7c69:	00 90 90 55 ba f7    	add    %dl,-0x845aa70(%eax)

00007c6c <_Z8waitdiskv>:
	}
}

void
waitdisk(void)
{
    7c6c:	55                   	push   %ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7c6d:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c72:	89 e5                	mov    %esp,%ebp
    7c74:	ec                   	in     (%dx),%al
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7c75:	25 c0 00 00 00       	and    $0xc0,%eax
    7c7a:	83 f8 40             	cmp    $0x40,%eax
    7c7d:	75 f5                	jne    7c74 <_Z8waitdiskv+0x8>
		/* do nothing */;
}
    7c7f:	5d                   	pop    %ebp
    7c80:	c3                   	ret    

00007c81 <_Z8readsectjj>:

void
readsect(uintptr_t addr, uint32_t offset)
{
    7c81:	55                   	push   %ebp
    7c82:	89 e5                	mov    %esp,%ebp
    7c84:	57                   	push   %edi
    7c85:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// wait for disk to be ready
	waitdisk();
    7c88:	e8 df ff ff ff       	call   7c6c <_Z8waitdiskv>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7c8d:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c92:	b0 01                	mov    $0x1,%al
    7c94:	ee                   	out    %al,(%dx)
    7c95:	b2 f3                	mov    $0xf3,%dl
    7c97:	89 f8                	mov    %edi,%eax
    7c99:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, offset);
	outb(0x1F4, offset >> 8);
    7c9a:	89 f8                	mov    %edi,%eax
    7c9c:	b2 f4                	mov    $0xf4,%dl
    7c9e:	c1 e8 08             	shr    $0x8,%eax
    7ca1:	ee                   	out    %al,(%dx)
	outb(0x1F5, offset >> 16);
    7ca2:	89 f8                	mov    %edi,%eax
    7ca4:	b2 f5                	mov    $0xf5,%dl
    7ca6:	c1 e8 10             	shr    $0x10,%eax
    7ca9:	ee                   	out    %al,(%dx)
	outb(0x1F6, (offset >> 24) | 0xE0);
    7caa:	c1 ef 18             	shr    $0x18,%edi
    7cad:	b2 f6                	mov    $0xf6,%dl
    7caf:	89 f8                	mov    %edi,%eax
    7cb1:	83 c8 e0             	or     $0xffffffe0,%eax
    7cb4:	ee                   	out    %al,(%dx)
    7cb5:	b0 20                	mov    $0x20,%al
    7cb7:	b2 f7                	mov    $0xf7,%dl
    7cb9:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
    7cba:	e8 ad ff ff ff       	call   7c6c <_Z8waitdiskv>
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
    7cbf:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cc2:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cc7:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7ccc:	fc                   	cld    
    7ccd:	f2 6d                	repnz insl (%dx),%es:(%edi)

	// read a sector
	insl(0x1F0, (void *) addr, SECTSIZE/4);
}
    7ccf:	5f                   	pop    %edi
    7cd0:	5d                   	pop    %ebp
    7cd1:	c3                   	ret    

00007cd2 <_Z7readsegjjjj>:
// Read 'filesz' bytes at 'offset' from kernel into load address 'pa',
// then clear the memory from 'pa+filesz' up to 'pa+memsz' (set it to 0).
// (The boot loader requires that load addresses are physical addresses.)
void
readseg(uintptr_t pa, uint32_t filesz, uint32_t memsz, uint32_t offset)
{
    7cd2:	55                   	push   %ebp
    7cd3:	89 e5                	mov    %esp,%ebp
    7cd5:	57                   	push   %edi
    7cd6:	56                   	push   %esi
    7cd7:	53                   	push   %ebx
    7cd8:	83 ec 04             	sub    $0x4,%esp
    7cdb:	8b 75 08             	mov    0x8(%ebp),%esi
    7cde:	8b 7d 14             	mov    0x14(%ebp),%edi
	uintptr_t end_pa;

	end_pa = pa + filesz;
	memsz += pa;
    7ce1:	8b 45 10             	mov    0x10(%ebp),%eax
void
readseg(uintptr_t pa, uint32_t filesz, uint32_t memsz, uint32_t offset)
{
	uintptr_t end_pa;

	end_pa = pa + filesz;
    7ce4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;
    7ce7:	c1 ef 09             	shr    $0x9,%edi
readseg(uintptr_t pa, uint32_t filesz, uint32_t memsz, uint32_t offset)
{
	uintptr_t end_pa;

	end_pa = pa + filesz;
	memsz += pa;
    7cea:	01 f0                	add    %esi,%eax

	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;
    7cec:	47                   	inc    %edi
void
readseg(uintptr_t pa, uint32_t filesz, uint32_t memsz, uint32_t offset)
{
	uintptr_t end_pa;

	end_pa = pa + filesz;
    7ced:	01 f3                	add    %esi,%ebx
	memsz += pa;

	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);
    7cef:	81 e6 00 fe ff ff    	and    $0xfffffe00,%esi
readseg(uintptr_t pa, uint32_t filesz, uint32_t memsz, uint32_t offset)
{
	uintptr_t end_pa;

	end_pa = pa + filesz;
	memsz += pa;
    7cf5:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;

	// read one sector at a time from disk into physical addresses
	while (pa < end_pa) {
    7cf8:	eb 10                	jmp    7d0a <_Z7readsegjjjj+0x38>
		readsect(pa, offset);
    7cfa:	57                   	push   %edi
		pa += SECTSIZE;
		offset++;
    7cfb:	47                   	inc    %edi
	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;

	// read one sector at a time from disk into physical addresses
	while (pa < end_pa) {
		readsect(pa, offset);
    7cfc:	56                   	push   %esi
		pa += SECTSIZE;
    7cfd:	81 c6 00 02 00 00    	add    $0x200,%esi
	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;

	// read one sector at a time from disk into physical addresses
	while (pa < end_pa) {
		readsect(pa, offset);
    7d03:	e8 79 ff ff ff       	call   7c81 <_Z8readsectjj>
		pa += SECTSIZE;
		offset++;
    7d08:	58                   	pop    %eax
    7d09:	5a                   	pop    %edx

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;

	// read one sector at a time from disk into physical addresses
	while (pa < end_pa) {
    7d0a:	39 de                	cmp    %ebx,%esi
    7d0c:	72 ec                	jb     7cfa <_Z7readsegjjjj+0x28>
    7d0e:	eb 04                	jmp    7d14 <_Z7readsegjjjj+0x42>
		offset++;
	}

	// clear bss segment
	while (end_pa < memsz) {
		*((uint8_t *) end_pa) = 0;
    7d10:	c6 03 00             	movb   $0x0,(%ebx)
		++end_pa;
    7d13:	43                   	inc    %ebx
		pa += SECTSIZE;
		offset++;
	}

	// clear bss segment
	while (end_pa < memsz) {
    7d14:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
    7d17:	72 f7                	jb     7d10 <_Z7readsegjjjj+0x3e>
		*((uint8_t *) end_pa) = 0;
		++end_pa;
	}
}
    7d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d1c:	5b                   	pop    %ebx
    7d1d:	5e                   	pop    %esi
    7d1e:	5f                   	pop    %edi
    7d1f:	5d                   	pop    %ebp
    7d20:	c3                   	ret    

00007d21 <bootmain>:
void readsect(uintptr_t addr, uint32_t sectornum);
void readseg(uintptr_t pa, uint32_t filesz, uint32_t memsz, uint32_t offset);

asmlinkage void
bootmain(void)
{
    7d21:	55                   	push   %ebp
    7d22:	89 e5                	mov    %esp,%ebp
    7d24:	56                   	push   %esi
    7d25:	53                   	push   %ebx
	struct Proghdr *ph, *eph;

	// read 1st page off disk
	readseg((uintptr_t) ELFHDR, PAGESIZE, PAGESIZE, 0);
    7d26:	6a 00                	push   $0x0
    7d28:	68 00 10 00 00       	push   $0x1000
    7d2d:	68 00 10 00 00       	push   $0x1000
    7d32:	68 00 00 01 00       	push   $0x10000
    7d37:	e8 96 ff ff ff       	call   7cd2 <_Z7readsegjjjj>

	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d3c:	83 c4 10             	add    $0x10,%esp
    7d3f:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d46:	45 4c 46 
    7d49:	75 3c                	jne    7d87 <bootmain+0x66>
		goto bad;

	// load each program segment (ignoring ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d4b:	8b 1d 1c 00 01 00    	mov    0x1001c,%ebx
	eph = ph + ELFHDR->e_phnum;
    7d51:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
		goto bad;

	// load each program segment (ignoring ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d58:	81 c3 00 00 01 00    	add    $0x10000,%ebx
	eph = ph + ELFHDR->e_phnum;
    7d5e:	c1 e0 05             	shl    $0x5,%eax
    7d61:	8d 34 03             	lea    (%ebx,%eax,1),%esi
	for (; ph < eph; ++ph)
    7d64:	eb 17                	jmp    7d7d <bootmain+0x5c>
		readseg(ph->p_pa, ph->p_filesz, ph->p_memsz, ph->p_offset);
    7d66:	ff 73 04             	pushl  0x4(%ebx)
    7d69:	ff 73 14             	pushl  0x14(%ebx)
    7d6c:	ff 73 10             	pushl  0x10(%ebx)
    7d6f:	ff 73 0c             	pushl  0xc(%ebx)
		goto bad;

	// load each program segment (ignoring ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ++ph)
    7d72:	83 c3 20             	add    $0x20,%ebx
		readseg(ph->p_pa, ph->p_filesz, ph->p_memsz, ph->p_offset);
    7d75:	e8 58 ff ff ff       	call   7cd2 <_Z7readsegjjjj>
		goto bad;

	// load each program segment (ignoring ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ++ph)
    7d7a:	83 c4 10             	add    $0x10,%esp
    7d7d:	39 f3                	cmp    %esi,%ebx
    7d7f:	72 e5                	jb     7d66 <bootmain+0x45>
		readseg(ph->p_pa, ph->p_filesz, ph->p_memsz, ph->p_offset);

	// call the entry point from the ELF header
	// note: does not return!
	((void (*)(void)) ELFHDR->e_entry)();
    7d81:	ff 15 18 00 01 00    	call   *0x10018
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
    7d87:	ba 00 8a 00 00       	mov    $0x8a00,%edx
    7d8c:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7d91:	66 ef                	out    %ax,(%dx)
    7d93:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d98:	66 ef                	out    %ax,(%dx)

bad:
	outw(0x8A00, 0x8A00);
	outw(0x8A00, 0x8E00);
	/* boot.S will spin for us */
}
    7d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    7d9d:	5b                   	pop    %ebx
    7d9e:	5e                   	pop    %esi
    7d9f:	5d                   	pop    %ebp
    7da0:	c3                   	ret    
