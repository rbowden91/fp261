
obj/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
###################################################################
# Entry point
###################################################################
.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
        # translates virtual addresses [KERNBASE, KERNBASE+16MB) to
        # physical addresses [0, 16MB).  This 16MB region will suffice
        # until we set up our real page table in i386_vm_init in lab 2.

	# Load the physical address of entry_pgdir into %cr3.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 f0 11 00       	mov    $0x11f000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on the page size extension required by entry_pgdir.
	movl	%cr4, %eax
f010001d:	0f 20 e0             	mov    %cr4,%eax
	orl	$(CR4_PSE), %eax
f0100020:	83 c8 10             	or     $0x10,%eax
	movl	%eax, %cr4
f0100023:	0f 22 e0             	mov    %eax,%cr4
	# Turn on paging.
	movl	%cr0, %eax
f0100026:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100029:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f010002e:	0f 22 c0             	mov    %eax,%cr0

	# Leave a few words on the stack for the user trap frame.
	movl	$(entry_stacktop-SIZEOF_STRUCT_TRAPFRAME), %esp
f0100031:	bc bc 7f 12 f0       	mov    $0xf0127fbc,%esp

	# Clear the frame pointer register %ebp and push a fake return address
	# so that once we start debugging in kern/monitor.c,
	# stack backtraces will be terminated properly.
	movl	$0, %ebp		# clear frame pointer
f0100036:	bd 00 00 00 00       	mov    $0x0,%ebp
	pushl	$(spin)			# fake return address
f010003b:	68 47 00 10 f0       	push   $0xf0100047

	# Now to C code.
	# ("jmp i386_init" doesn't work on its own: we need an absolute jump.)
	movl	$(i386_init), %eax
f0100040:	b8 ad 00 10 f0       	mov    $0xf01000ad,%eax
	jmp	*%eax
f0100045:	ff e0                	jmp    *%eax

f0100047 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f0100047:	eb fe                	jmp    f0100047 <spin>
f0100049:	00 00                	add    %al,(%eax)
f010004b:	00 00                	add    %al,(%eax)
f010004d:	00 00                	add    %al,(%eax)
	...

f0100050 <_Z14test_backtracei>:
#include <kern/time.h>
#include <kern/e1000.h>
// Test the stack backtrace function (used in lab 1 only)
void
test_backtrace(int x)
{
f0100050:	55                   	push   %ebp
f0100051:	89 e5                	mov    %esp,%ebp
f0100053:	53                   	push   %ebx
f0100054:	83 ec 14             	sub    $0x14,%esp
f0100057:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("entering test_backtrace %d\n", x);
f010005a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010005e:	c7 04 24 00 78 10 f0 	movl   $0xf0107800,(%esp)
f0100065:	e8 48 40 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	if (x > 0)
f010006a:	85 db                	test   %ebx,%ebx
f010006c:	7e 0d                	jle    f010007b <_Z14test_backtracei+0x2b>
		test_backtrace(x-1);
f010006e:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100071:	89 04 24             	mov    %eax,(%esp)
f0100074:	e8 d7 ff ff ff       	call   f0100050 <_Z14test_backtracei>
f0100079:	eb 1c                	jmp    f0100097 <_Z14test_backtracei+0x47>
	else
		mon_backtrace(0, 0, 0);
f010007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100082:	00 
f0100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010008a:	00 
f010008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100092:	e8 de 0c 00 00       	call   f0100d75 <_Z13mon_backtraceiPPcP9Trapframe>
	cprintf("leaving test_backtrace %d\n", x);
f0100097:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010009b:	c7 04 24 1c 78 10 f0 	movl   $0xf010781c,(%esp)
f01000a2:	e8 0b 40 00 00       	call   f01040b2 <_Z7cprintfPKcz>
}
f01000a7:	83 c4 14             	add    $0x14,%esp
f01000aa:	5b                   	pop    %ebx
f01000ab:	5d                   	pop    %ebp
f01000ac:	c3                   	ret    

f01000ad <i386_init>:
	cprintf("Breakpoint succeeded!\n");
}

asmlinkage void
i386_init(void)
{
f01000ad:	55                   	push   %ebp
f01000ae:	89 e5                	mov    %esp,%ebp
f01000b0:	53                   	push   %ebx
f01000b1:	83 ec 14             	sub    $0x14,%esp
	extern const uintptr_t sctors[], ectors[];
	const uintptr_t *ctorva;

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f01000b4:	e8 2e 08 00 00       	call   f01008e7 <_Z9cons_initv>

	// Then call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see kern/kernel.ld.
	// Call after cons_init() so we can cprintf() if necessary.
	for (ctorva = ectors; ctorva > sctors; )
f01000b9:	b8 24 e2 11 f0       	mov    $0xf011e224,%eax
f01000be:	3d 20 e2 11 f0       	cmp    $0xf011e220,%eax
f01000c3:	76 0f                	jbe    f01000d4 <i386_init+0x27>
f01000c5:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
f01000c7:	83 eb 04             	sub    $0x4,%ebx
f01000ca:	ff 13                	call   *(%ebx)

	// Then call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see kern/kernel.ld.
	// Call after cons_init() so we can cprintf() if necessary.
	for (ctorva = ectors; ctorva > sctors; )
f01000cc:	81 fb 20 e2 11 f0    	cmp    $0xf011e220,%ebx
f01000d2:	77 f3                	ja     f01000c7 <i386_init+0x1a>
		((void(*)()) *--ctorva)();

	// Lab 2 memory management initialization functions
	mem_init();
f01000d4:	e8 9f 17 00 00       	call   f0101878 <_Z8mem_initv>
	
    // Lab 2 interrupt and gate descriptor initialization functions
	idt_init();
f01000d9:	e8 f2 3f 00 00       	call   f01040d0 <_Z8idt_initv>

	// Lab 3 user environment initialization functions
	env_init();
f01000de:	66 90                	xchg   %ax,%ax
f01000e0:	e8 74 36 00 00       	call   f0103759 <_Z8env_initv>

	// Lab 4 multitasking initialization functions
	pic_init();
f01000e5:	e8 f7 3e 00 00       	call   f0103fe1 <_Z8pic_initv>
	kclock_init();
f01000ea:	e8 31 3e 00 00       	call   f0103f20 <_Z11kclock_initv>

    time_init();
f01000ef:	90                   	nop
f01000f0:	e8 37 74 00 00       	call   f010752c <_Z9time_initv>
    pci_init();
f01000f5:	e8 04 74 00 00       	call   f01074fe <_Z8pci_initv>

	// Should always have an idle process as first one.
	ENV_CREATE(user_idle);
f01000fa:	c7 44 24 04 31 c9 01 	movl   $0x1c931,0x4(%esp)
f0100101:	00 
f0100102:	c7 04 24 30 81 12 f0 	movl   $0xf0128130,(%esp)
f0100109:	e8 94 38 00 00       	call   f01039a2 <_Z10env_createPhj>

	// Start bufcache.  Bufcache is always meant to run as environment
	// 0x1100, so we rearrange the free list to put that environment first.
	{
	    extern struct Env *env_free_list;
		struct Env **pprev = &env_free_list, *bce = 0;
f010010e:	a1 90 82 37 f0       	mov    0xf0378290,%eax
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
f0100113:	85 c0                	test   %eax,%eax
f0100115:	74 3b                	je     f0100152 <i386_init+0xa5>
			if (*pprev == &envs[ENVX(ENVID_BUFCACHE)]) {
f0100117:	8b 15 88 82 37 f0    	mov    0xf0378288,%edx
f010011d:	81 c2 00 78 00 00    	add    $0x7800,%edx
f0100123:	39 d0                	cmp    %edx,%eax
f0100125:	75 23                	jne    f010014a <i386_init+0x9d>
f0100127:	eb 09                	jmp    f0100132 <i386_init+0x85>
f0100129:	39 d0                	cmp    %edx,%eax
f010012b:	75 1d                	jne    f010014a <i386_init+0x9d>
f010012d:	8d 76 00             	lea    0x0(%esi),%esi
f0100130:	eb 05                	jmp    f0100137 <i386_init+0x8a>

	// Start bufcache.  Bufcache is always meant to run as environment
	// 0x1100, so we rearrange the free list to put that environment first.
	{
	    extern struct Env *env_free_list;
		struct Env **pprev = &env_free_list, *bce = 0;
f0100132:	b9 90 82 37 f0       	mov    $0xf0378290,%ecx
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
			if (*pprev == &envs[ENVX(ENVID_BUFCACHE)]) {
				struct Env *e = *pprev;
				*pprev = e->env_link;
f0100137:	8b 10                	mov    (%eax),%edx
f0100139:	89 11                	mov    %edx,(%ecx)
				e->env_link = env_free_list;
f010013b:	8b 15 90 82 37 f0    	mov    0xf0378290,%edx
f0100141:	89 10                	mov    %edx,(%eax)
				env_free_list = e;
f0100143:	a3 90 82 37 f0       	mov    %eax,0xf0378290
				break;
f0100148:	eb 08                	jmp    f0100152 <i386_init+0xa5>
	// Start bufcache.  Bufcache is always meant to run as environment
	// 0x1100, so we rearrange the free list to put that environment first.
	{
	    extern struct Env *env_free_list;
		struct Env **pprev = &env_free_list, *bce = 0;
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
f010014a:	89 c1                	mov    %eax,%ecx
f010014c:	8b 00                	mov    (%eax),%eax
f010014e:	85 c0                	test   %eax,%eax
f0100150:	75 d7                	jne    f0100129 <i386_init+0x7c>
				e->env_link = env_free_list;
				env_free_list = e;
				break;
			}
	}
	ENV_CREATE(fs_bufcache);
f0100152:	c7 44 24 04 8f fa 01 	movl   $0x1fa8f,0x4(%esp)
f0100159:	00 
f010015a:	c7 04 24 f3 53 25 f0 	movl   $0xf02553f3,(%esp)
f0100161:	e8 3c 38 00 00       	call   f01039a2 <_Z10env_createPhj>

    {
	    extern struct Env *env_free_list;
		struct Env **pprev = &env_free_list, *bce = 0;
f0100166:	a1 90 82 37 f0       	mov    0xf0378290,%eax
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
f010016b:	85 c0                	test   %eax,%eax
f010016d:	74 38                	je     f01001a7 <i386_init+0xfa>
			if (*pprev == &envs[ENVX(ENVID_NS)]) {
f010016f:	8b 15 88 82 37 f0    	mov    0xf0378288,%edx
f0100175:	81 c2 78 78 00 00    	add    $0x7878,%edx
f010017b:	39 d0                	cmp    %edx,%eax
f010017d:	75 20                	jne    f010019f <i386_init+0xf2>
f010017f:	eb 06                	jmp    f0100187 <i386_init+0xda>
f0100181:	39 d0                	cmp    %edx,%eax
f0100183:	75 1a                	jne    f010019f <i386_init+0xf2>
f0100185:	eb 05                	jmp    f010018c <i386_init+0xdf>
	}
	ENV_CREATE(fs_bufcache);

    {
	    extern struct Env *env_free_list;
		struct Env **pprev = &env_free_list, *bce = 0;
f0100187:	b9 90 82 37 f0       	mov    $0xf0378290,%ecx
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
			if (*pprev == &envs[ENVX(ENVID_NS)]) {
				struct Env *e = *pprev;
				*pprev = e->env_link;
f010018c:	8b 10                	mov    (%eax),%edx
f010018e:	89 11                	mov    %edx,(%ecx)
				e->env_link = env_free_list;
f0100190:	8b 15 90 82 37 f0    	mov    0xf0378290,%edx
f0100196:	89 10                	mov    %edx,(%eax)
				env_free_list = e;
f0100198:	a3 90 82 37 f0       	mov    %eax,0xf0378290
				break;
f010019d:	eb 08                	jmp    f01001a7 <i386_init+0xfa>
	ENV_CREATE(fs_bufcache);

    {
	    extern struct Env *env_free_list;
		struct Env **pprev = &env_free_list, *bce = 0;
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
f010019f:	89 c1                	mov    %eax,%ecx
f01001a1:	8b 00                	mov    (%eax),%eax
f01001a3:	85 c0                	test   %eax,%eax
f01001a5:	75 da                	jne    f0100181 <i386_init+0xd4>
				e->env_link = env_free_list;
				env_free_list = e;
				break;
			}
	}
	ENV_CREATE(net_ns);
f01001a7:	c7 44 24 04 e4 7b 07 	movl   $0x77be4,0x4(%esp)
f01001ae:	00 
f01001af:	c7 04 24 8a 94 2b f0 	movl   $0xf02b948a,(%esp)
f01001b6:	e8 e7 37 00 00       	call   f01039a2 <_Z10env_createPhj>
    
    // Start migrated. Migrated is always meant to run as environment
    // 0x1101, so we rearrange the free list to put that first.
    {
	    extern struct Env *env_free_list;
    	struct Env **pprev = &env_free_list, *bce = 0;
f01001bb:	a1 90 82 37 f0       	mov    0xf0378290,%eax
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
f01001c0:	85 c0                	test   %eax,%eax
f01001c2:	74 3e                	je     f0100202 <i386_init+0x155>
			if (*pprev == &envs[ENVX(ENVID_MIGRATED)]) {
f01001c4:	8b 15 88 82 37 f0    	mov    0xf0378288,%edx
f01001ca:	81 c2 f0 78 00 00    	add    $0x78f0,%edx
f01001d0:	39 c2                	cmp    %eax,%edx
f01001d2:	75 26                	jne    f01001fa <i386_init+0x14d>
f01001d4:	eb 0c                	jmp    f01001e2 <i386_init+0x135>
f01001d6:	39 c2                	cmp    %eax,%edx
f01001d8:	75 20                	jne    f01001fa <i386_init+0x14d>
f01001da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01001e0:	eb 05                	jmp    f01001e7 <i386_init+0x13a>
    
    // Start migrated. Migrated is always meant to run as environment
    // 0x1101, so we rearrange the free list to put that first.
    {
	    extern struct Env *env_free_list;
    	struct Env **pprev = &env_free_list, *bce = 0;
f01001e2:	b9 90 82 37 f0       	mov    $0xf0378290,%ecx
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
			if (*pprev == &envs[ENVX(ENVID_MIGRATED)]) {
				struct Env *e = *pprev;
				*pprev = e->env_link;
f01001e7:	8b 10                	mov    (%eax),%edx
f01001e9:	89 11                	mov    %edx,(%ecx)
				e->env_link = env_free_list;
f01001eb:	8b 15 90 82 37 f0    	mov    0xf0378290,%edx
f01001f1:	89 10                	mov    %edx,(%eax)
				env_free_list = e;
f01001f3:	a3 90 82 37 f0       	mov    %eax,0xf0378290
				break;
f01001f8:	eb 08                	jmp    f0100202 <i386_init+0x155>
    // Start migrated. Migrated is always meant to run as environment
    // 0x1101, so we rearrange the free list to put that first.
    {
	    extern struct Env *env_free_list;
    	struct Env **pprev = &env_free_list, *bce = 0;
		for (bce = 0; *pprev; pprev = &(*pprev)->env_link)
f01001fa:	89 c1                	mov    %eax,%ecx
f01001fc:	8b 00                	mov    (%eax),%eax
f01001fe:	85 c0                	test   %eax,%eax
f0100200:	75 d4                	jne    f01001d6 <i386_init+0x129>
				env_free_list = e;
				break;
			}
    }
    //ENV_CREATE(user_migrated);
    ENV_CREATE(user_testmigrate);
f0100202:	c7 44 24 04 ee 0b 02 	movl   $0x20bee,0x4(%esp)
f0100209:	00 
f010020a:	c7 04 24 0d 1c 35 f0 	movl   $0xf0351c0d,(%esp)
f0100211:	e8 8c 37 00 00       	call   f01039a2 <_Z10env_createPhj>

    // Schedule and run a user environment!
	// We want to run the bufcache first.
	env_run(&envs[ENVX(ENVID_BUFCACHE)]);
f0100216:	a1 88 82 37 f0       	mov    0xf0378288,%eax
f010021b:	05 00 78 00 00       	add    $0x7800,%eax
f0100220:	89 04 24             	mov    %eax,(%esp)
f0100223:	e8 7e 3c 00 00       	call   f0103ea6 <_Z7env_runP3Env>

f0100228 <_Z6_panicPKciS0_z>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
f0100228:	55                   	push   %ebp
f0100229:	89 e5                	mov    %esp,%ebp
f010022b:	56                   	push   %esi
f010022c:	53                   	push   %ebx
f010022d:	83 ec 10             	sub    $0x10,%esp
f0100230:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100233:	83 3d 00 30 37 f0 00 	cmpl   $0x0,0xf0373000
f010023a:	75 3d                	jne    f0100279 <_Z6_panicPKciS0_z+0x51>
		goto dead;
	panicstr = fmt;
f010023c:	89 35 00 30 37 f0    	mov    %esi,0xf0373000

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f0100242:	fa                   	cli    
f0100243:	fc                   	cld    

	va_start(ap, fmt);
f0100244:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic at %s:%d: ", file, line);
f0100247:	8b 45 0c             	mov    0xc(%ebp),%eax
f010024a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010024e:	8b 45 08             	mov    0x8(%ebp),%eax
f0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100255:	c7 04 24 37 78 10 f0 	movl   $0xf0107837,(%esp)
f010025c:	e8 51 3e 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
f0100261:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100265:	89 34 24             	mov    %esi,(%esp)
f0100268:	e8 12 3e 00 00       	call   f010407f <_Z8vcprintfPKcPc>
	cprintf("\n");
f010026d:	c7 04 24 2f 8b 10 f0 	movl   $0xf0108b2f,(%esp)
f0100274:	e8 39 3e 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100279:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100280:	e8 cf 0e 00 00       	call   f0101154 <_Z7monitorP9Trapframe>
f0100285:	eb f2                	jmp    f0100279 <_Z6_panicPKciS0_z+0x51>

f0100287 <_Z5_warnPKciS0_z>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt, ...)
{
f0100287:	55                   	push   %ebp
f0100288:	89 e5                	mov    %esp,%ebp
f010028a:	53                   	push   %ebx
f010028b:	83 ec 14             	sub    $0x14,%esp
	va_list ap;

	va_start(ap, fmt);
f010028e:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100291:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100294:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100298:	8b 45 08             	mov    0x8(%ebp),%eax
f010029b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010029f:	c7 04 24 4f 78 10 f0 	movl   $0xf010784f,(%esp)
f01002a6:	e8 07 3e 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
f01002ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01002af:	8b 45 10             	mov    0x10(%ebp),%eax
f01002b2:	89 04 24             	mov    %eax,(%esp)
f01002b5:	e8 c5 3d 00 00       	call   f010407f <_Z8vcprintfPKcPc>
	cprintf("\n");
f01002ba:	c7 04 24 2f 8b 10 f0 	movl   $0xf0108b2f,(%esp)
f01002c1:	e8 ec 3d 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	va_end(ap);
}
f01002c6:	83 c4 14             	add    $0x14,%esp
f01002c9:	5b                   	pop    %ebx
f01002ca:	5d                   	pop    %ebp
f01002cb:	c3                   	ret    
f01002cc:	00 00                	add    %al,(%eax)
	...

f01002d0 <_ZL5delayv>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f01002d0:	55                   	push   %ebp
f01002d1:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002d3:	ba 84 00 00 00       	mov    $0x84,%edx
f01002d8:	ec                   	in     (%dx),%al
f01002d9:	ec                   	in     (%dx),%al
f01002da:	ec                   	in     (%dx),%al
f01002db:	ec                   	in     (%dx),%al
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
f01002dc:	5d                   	pop    %ebp
f01002dd:	c3                   	ret    

f01002de <_ZL16serial_proc_datav>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f01002de:	55                   	push   %ebp
f01002df:	89 e5                	mov    %esp,%ebp
f01002e1:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002e6:	ec                   	in     (%dx),%al
f01002e7:	89 c2                	mov    %eax,%edx
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f01002e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
static bool serial_exists;

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01002ee:	f6 c2 01             	test   $0x1,%dl
f01002f1:	74 09                	je     f01002fc <_ZL16serial_proc_datav+0x1e>
f01002f3:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002f8:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01002f9:	0f b6 c0             	movzbl %al,%eax
}
f01002fc:	5d                   	pop    %ebp
f01002fd:	c3                   	ret    

f01002fe <_ZL9cons_intrPFivE>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01002fe:	55                   	push   %ebp
f01002ff:	89 e5                	mov    %esp,%ebp
f0100301:	53                   	push   %ebx
f0100302:	83 ec 04             	sub    $0x4,%esp
f0100305:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100307:	eb 25                	jmp    f010032e <_ZL9cons_intrPFivE+0x30>
		if (c == 0)
f0100309:	85 c0                	test   %eax,%eax
f010030b:	74 21                	je     f010032e <_ZL9cons_intrPFivE+0x30>
			continue;
		cons.buf[cons.wpos++] = c;
f010030d:	8b 15 64 82 37 f0    	mov    0xf0378264,%edx
f0100313:	88 82 60 80 37 f0    	mov    %al,-0xfc87fa0(%edx)
f0100319:	8d 42 01             	lea    0x1(%edx),%eax
		if (cons.wpos == CONSBUFSIZE)
f010031c:	3d 00 02 00 00       	cmp    $0x200,%eax
			cons.wpos = 0;
f0100321:	ba 00 00 00 00       	mov    $0x0,%edx
f0100326:	0f 44 c2             	cmove  %edx,%eax
f0100329:	a3 64 82 37 f0       	mov    %eax,0xf0378264
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f010032e:	ff d3                	call   *%ebx
f0100330:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100333:	75 d4                	jne    f0100309 <_ZL9cons_intrPFivE+0xb>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f0100335:	83 c4 04             	add    $0x4,%esp
f0100338:	5b                   	pop    %ebx
f0100339:	5d                   	pop    %ebp
f010033a:	c3                   	ret    

f010033b <_ZL16cga_savebuf_copyib>:
#if CRT_SAVEROWS > 0
// Copy one screen's worth of data to or from the save buffer,
// starting at line 'first_line'.
static void
cga_savebuf_copy(int first_line, bool to_screen)
{
f010033b:	55                   	push   %ebp
f010033c:	89 e5                	mov    %esp,%ebp
f010033e:	83 ec 38             	sub    $0x38,%esp
f0100341:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0100344:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0100347:	89 7d fc             	mov    %edi,-0x4(%ebp)
f010034a:	88 55 e7             	mov    %dl,-0x19(%ebp)
	uint16_t *pos;
	uint16_t *end;
	uint16_t *trueend;

	// Calculate the beginning & end of the save buffer area.
	pos = crtsave_buf + (first_line % CRT_SAVEROWS) * CRT_COLS;
f010034d:	89 c2                	mov    %eax,%edx
f010034f:	c1 fa 1f             	sar    $0x1f,%edx
f0100352:	c1 ea 19             	shr    $0x19,%edx
f0100355:	01 d0                	add    %edx,%eax
f0100357:	83 e0 7f             	and    $0x7f,%eax
f010035a:	29 d0                	sub    %edx,%eax
f010035c:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
f010035f:	c1 e3 05             	shl    $0x5,%ebx
f0100362:	81 c3 40 30 37 f0    	add    $0xf0373040,%ebx
	end = pos + CRT_ROWS * CRT_COLS;
f0100368:	8d b3 a0 0f 00 00    	lea    0xfa0(%ebx),%esi
f010036e:	81 fe 40 80 37 f0    	cmp    $0xf0378040,%esi
f0100374:	bf 40 80 37 f0       	mov    $0xf0378040,%edi
f0100379:	0f 46 fe             	cmovbe %esi,%edi
	// Check for wraparound.
	trueend = MIN(end, crtsave_buf + CRT_SAVEROWS * CRT_COLS);

	// Copy the initial portion.
	if (to_screen)
f010037c:	80 7d e7 00          	cmpb   $0x0,-0x19(%ebp)
f0100380:	74 1e                	je     f01003a0 <_ZL16cga_savebuf_copyib+0x65>
		memmove(crt_buf, pos, (trueend - pos) * sizeof(uint16_t));
f0100382:	89 f8                	mov    %edi,%eax
f0100384:	29 d8                	sub    %ebx,%eax
f0100386:	83 e0 fe             	and    $0xfffffffe,%eax
f0100389:	89 44 24 08          	mov    %eax,0x8(%esp)
f010038d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100391:	a1 28 30 37 f0       	mov    0xf0373028,%eax
f0100396:	89 04 24             	mov    %eax,(%esp)
f0100399:	e8 be 63 00 00       	call   f010675c <memmove>
f010039e:	eb 1c                	jmp    f01003bc <_ZL16cga_savebuf_copyib+0x81>
	else
		memmove(pos, crt_buf, (trueend - pos) * sizeof(uint16_t));
f01003a0:	89 f8                	mov    %edi,%eax
f01003a2:	29 d8                	sub    %ebx,%eax
f01003a4:	83 e0 fe             	and    $0xfffffffe,%eax
f01003a7:	89 44 24 08          	mov    %eax,0x8(%esp)
f01003ab:	a1 28 30 37 f0       	mov    0xf0373028,%eax
f01003b0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01003b4:	89 1c 24             	mov    %ebx,(%esp)
f01003b7:	e8 a0 63 00 00       	call   f010675c <memmove>

	// If there was wraparound, copy the second part of the screen.
	if (end == trueend)
f01003bc:	39 fe                	cmp    %edi,%esi
f01003be:	74 50                	je     f0100410 <_ZL16cga_savebuf_copyib+0xd5>
		/* do nothing */;
	else if (to_screen)
f01003c0:	80 7d e7 00          	cmpb   $0x0,-0x19(%ebp)
f01003c4:	74 26                	je     f01003ec <_ZL16cga_savebuf_copyib+0xb1>
		memmove(crt_buf + (trueend - pos), crtsave_buf, (end - trueend) * sizeof(uint16_t));
f01003c6:	29 fe                	sub    %edi,%esi
f01003c8:	83 e6 fe             	and    $0xfffffffe,%esi
f01003cb:	89 74 24 08          	mov    %esi,0x8(%esp)
f01003cf:	c7 44 24 04 40 30 37 	movl   $0xf0373040,0x4(%esp)
f01003d6:	f0 
f01003d7:	29 df                	sub    %ebx,%edi
f01003d9:	83 e7 fe             	and    $0xfffffffe,%edi
f01003dc:	03 3d 28 30 37 f0    	add    0xf0373028,%edi
f01003e2:	89 3c 24             	mov    %edi,(%esp)
f01003e5:	e8 72 63 00 00       	call   f010675c <memmove>
f01003ea:	eb 24                	jmp    f0100410 <_ZL16cga_savebuf_copyib+0xd5>
	else
		memmove(crtsave_buf, crt_buf + (trueend - pos), (end - trueend) * sizeof(uint16_t));
f01003ec:	29 fe                	sub    %edi,%esi
f01003ee:	83 e6 fe             	and    $0xfffffffe,%esi
f01003f1:	89 74 24 08          	mov    %esi,0x8(%esp)
f01003f5:	29 df                	sub    %ebx,%edi
f01003f7:	83 e7 fe             	and    $0xfffffffe,%edi
f01003fa:	03 3d 28 30 37 f0    	add    0xf0373028,%edi
f0100400:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100404:	c7 04 24 40 30 37 f0 	movl   $0xf0373040,(%esp)
f010040b:	e8 4c 63 00 00       	call   f010675c <memmove>
}
f0100410:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0100413:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0100416:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0100419:	89 ec                	mov    %ebp,%esp
f010041b:	5d                   	pop    %ebp
f010041c:	c3                   	ret    

f010041d <_ZL9cons_putci>:
}

// output a character to the console
static void
cons_putc(int c)
{
f010041d:	55                   	push   %ebp
f010041e:	89 e5                	mov    %esp,%ebp
f0100420:	57                   	push   %edi
f0100421:	56                   	push   %esi
f0100422:	53                   	push   %ebx
f0100423:	83 ec 2c             	sub    $0x2c,%esp
f0100426:	89 45 e4             	mov    %eax,-0x1c(%ebp)
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f0100429:	bb 00 00 00 00       	mov    $0x0,%ebx
f010042e:	be fd 03 00 00       	mov    $0x3fd,%esi
f0100433:	89 f2                	mov    %esi,%edx
f0100435:	ec                   	in     (%dx),%al
f0100436:	a8 20                	test   $0x20,%al
f0100438:	0f 85 46 02 00 00    	jne    f0100684 <_ZL9cons_putci+0x267>
f010043e:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f0100444:	0f 84 3a 02 00 00    	je     f0100684 <_ZL9cons_putci+0x267>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f010044a:	e8 81 fe ff ff       	call   f01002d0 <_ZL5delayv>
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f010044f:	83 c3 01             	add    $0x1,%ebx
f0100452:	eb df                	jmp    f0100433 <_ZL9cons_putci+0x16>
f0100454:	89 fa                	mov    %edi,%edx
f0100456:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100457:	84 c0                	test   %al,%al
f0100459:	0f 88 40 02 00 00    	js     f010069f <_ZL9cons_putci+0x282>
f010045f:	83 eb 01             	sub    $0x1,%ebx
f0100462:	0f 84 37 02 00 00    	je     f010069f <_ZL9cons_putci+0x282>
		delay();
f0100468:	e8 63 fe ff ff       	call   f01002d0 <_ZL5delayv>
f010046d:	8d 76 00             	lea    0x0(%esi),%esi
f0100470:	eb e2                	jmp    f0100454 <_ZL9cons_putci+0x37>
cga_putc(int c)
{
#if CRT_SAVEROWS > 0
	// unscroll if necessary
	if (crtsave_backscroll > 0) {
		cga_savebuf_copy(crtsave_pos + crtsave_size, 1);
f0100472:	0f b7 15 24 30 37 f0 	movzwl 0xf0373024,%edx
f0100479:	0f b7 05 22 30 37 f0 	movzwl 0xf0373022,%eax
f0100480:	8d 04 02             	lea    (%edx,%eax,1),%eax
f0100483:	ba 01 00 00 00       	mov    $0x1,%edx
f0100488:	e8 ae fe ff ff       	call   f010033b <_ZL16cga_savebuf_copyib>
		crtsave_backscroll = 0;
f010048d:	66 c7 05 20 30 37 f0 	movw   $0x0,0xf0373020
f0100494:	00 00 
	}

#endif
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f0100496:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0100499:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f010049f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01004a2:	80 cc 07             	or     $0x7,%ah
f01004a5:	85 d2                	test   %edx,%edx
f01004a7:	0f 45 45 e4          	cmovne -0x1c(%ebp),%eax
f01004ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	switch (c & 0xff) {
f01004ae:	25 ff 00 00 00       	and    $0xff,%eax
f01004b3:	83 f8 09             	cmp    $0x9,%eax
f01004b6:	0f 84 7d 00 00 00    	je     f0100539 <_ZL9cons_putci+0x11c>
f01004bc:	83 f8 09             	cmp    $0x9,%eax
f01004bf:	7f 0b                	jg     f01004cc <_ZL9cons_putci+0xaf>
f01004c1:	83 f8 08             	cmp    $0x8,%eax
f01004c4:	0f 85 a3 00 00 00    	jne    f010056d <_ZL9cons_putci+0x150>
f01004ca:	eb 16                	jmp    f01004e2 <_ZL9cons_putci+0xc5>
f01004cc:	83 f8 0a             	cmp    $0xa,%eax
f01004cf:	90                   	nop
f01004d0:	74 41                	je     f0100513 <_ZL9cons_putci+0xf6>
f01004d2:	83 f8 0d             	cmp    $0xd,%eax
f01004d5:	0f 85 92 00 00 00    	jne    f010056d <_ZL9cons_putci+0x150>
f01004db:	90                   	nop
f01004dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01004e0:	eb 39                	jmp    f010051b <_ZL9cons_putci+0xfe>
	case '\b':
		if (crt_pos > 0) {
f01004e2:	0f b7 05 26 30 37 f0 	movzwl 0xf0373026,%eax
f01004e9:	66 85 c0             	test   %ax,%ax
f01004ec:	0f 84 5d 01 00 00    	je     f010064f <_ZL9cons_putci+0x232>
			crt_pos--;
f01004f2:	83 e8 01             	sub    $0x1,%eax
f01004f5:	66 a3 26 30 37 f0    	mov    %ax,0xf0373026
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01004fb:	0f b7 c0             	movzwl %ax,%eax
f01004fe:	0f b7 4d e4          	movzwl -0x1c(%ebp),%ecx
f0100502:	b1 00                	mov    $0x0,%cl
f0100504:	83 c9 20             	or     $0x20,%ecx
f0100507:	8b 15 28 30 37 f0    	mov    0xf0373028,%edx
f010050d:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
f0100511:	eb 7b                	jmp    f010058e <_ZL9cons_putci+0x171>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f0100513:	66 83 05 26 30 37 f0 	addw   $0x50,0xf0373026
f010051a:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f010051b:	0f b7 05 26 30 37 f0 	movzwl 0xf0373026,%eax
f0100522:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100528:	c1 e8 16             	shr    $0x16,%eax
f010052b:	8d 04 80             	lea    (%eax,%eax,4),%eax
f010052e:	c1 e0 04             	shl    $0x4,%eax
f0100531:	66 a3 26 30 37 f0    	mov    %ax,0xf0373026
f0100537:	eb 55                	jmp    f010058e <_ZL9cons_putci+0x171>
		break;
	case '\t':
		cons_putc(' ');
f0100539:	b8 20 00 00 00       	mov    $0x20,%eax
f010053e:	e8 da fe ff ff       	call   f010041d <_ZL9cons_putci>
		cons_putc(' ');
f0100543:	b8 20 00 00 00       	mov    $0x20,%eax
f0100548:	e8 d0 fe ff ff       	call   f010041d <_ZL9cons_putci>
		cons_putc(' ');
f010054d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100552:	e8 c6 fe ff ff       	call   f010041d <_ZL9cons_putci>
		cons_putc(' ');
f0100557:	b8 20 00 00 00       	mov    $0x20,%eax
f010055c:	e8 bc fe ff ff       	call   f010041d <_ZL9cons_putci>
		cons_putc(' ');
f0100561:	b8 20 00 00 00       	mov    $0x20,%eax
f0100566:	e8 b2 fe ff ff       	call   f010041d <_ZL9cons_putci>
f010056b:	eb 21                	jmp    f010058e <_ZL9cons_putci+0x171>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f010056d:	0f b7 05 26 30 37 f0 	movzwl 0xf0373026,%eax
f0100574:	0f b7 c8             	movzwl %ax,%ecx
f0100577:	8b 15 28 30 37 f0    	mov    0xf0373028,%edx
f010057d:	0f b7 5d e4          	movzwl -0x1c(%ebp),%ebx
f0100581:	66 89 1c 4a          	mov    %bx,(%edx,%ecx,2)
f0100585:	83 c0 01             	add    $0x1,%eax
f0100588:	66 a3 26 30 37 f0    	mov    %ax,0xf0373026
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f010058e:	66 81 3d 26 30 37 f0 	cmpw   $0x7cf,0xf0373026
f0100595:	cf 07 
f0100597:	0f 86 b2 00 00 00    	jbe    f010064f <_ZL9cons_putci+0x232>
		int i;

#if CRT_SAVEROWS > 0
		// Save the scrolled-back row
		if (crtsave_size == CRT_SAVEROWS - CRT_ROWS)
f010059d:	0f b7 05 24 30 37 f0 	movzwl 0xf0373024,%eax
f01005a4:	66 83 f8 67          	cmp    $0x67,%ax
f01005a8:	75 15                	jne    f01005bf <_ZL9cons_putci+0x1a2>
			crtsave_pos = (crtsave_pos + 1) % CRT_SAVEROWS;
f01005aa:	0f b7 05 22 30 37 f0 	movzwl 0xf0373022,%eax
f01005b1:	83 c0 01             	add    $0x1,%eax
f01005b4:	83 e0 7f             	and    $0x7f,%eax
f01005b7:	66 a3 22 30 37 f0    	mov    %ax,0xf0373022
f01005bd:	eb 09                	jmp    f01005c8 <_ZL9cons_putci+0x1ab>
		else
			crtsave_size++;
f01005bf:	83 c0 01             	add    $0x1,%eax
f01005c2:	66 a3 24 30 37 f0    	mov    %ax,0xf0373024
		memmove(crtsave_buf + ((crtsave_pos + crtsave_size - 1) % CRT_SAVEROWS) * CRT_COLS, crt_buf, CRT_COLS * sizeof(uint16_t));
f01005c8:	c7 44 24 08 a0 00 00 	movl   $0xa0,0x8(%esp)
f01005cf:	00 
f01005d0:	a1 28 30 37 f0       	mov    0xf0373028,%eax
f01005d5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01005d9:	0f b7 15 22 30 37 f0 	movzwl 0xf0373022,%edx
f01005e0:	0f b7 05 24 30 37 f0 	movzwl 0xf0373024,%eax
f01005e7:	8d 44 02 ff          	lea    -0x1(%edx,%eax,1),%eax
f01005eb:	89 c2                	mov    %eax,%edx
f01005ed:	c1 fa 1f             	sar    $0x1f,%edx
f01005f0:	c1 ea 19             	shr    $0x19,%edx
f01005f3:	01 d0                	add    %edx,%eax
f01005f5:	83 e0 7f             	and    $0x7f,%eax
f01005f8:	29 d0                	sub    %edx,%eax
f01005fa:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01005fd:	c1 e0 05             	shl    $0x5,%eax
f0100600:	05 40 30 37 f0       	add    $0xf0373040,%eax
f0100605:	89 04 24             	mov    %eax,(%esp)
f0100608:	e8 4f 61 00 00       	call   f010675c <memmove>

#endif
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f010060d:	a1 28 30 37 f0       	mov    0xf0373028,%eax
f0100612:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f0100619:	00 
f010061a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100620:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100624:	89 04 24             	mov    %eax,(%esp)
f0100627:	e8 30 61 00 00       	call   f010675c <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f010062c:	8b 15 28 30 37 f0    	mov    0xf0373028,%edx
			crtsave_size++;
		memmove(crtsave_buf + ((crtsave_pos + crtsave_size - 1) % CRT_SAVEROWS) * CRT_COLS, crt_buf, CRT_COLS * sizeof(uint16_t));

#endif
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100632:	b8 80 07 00 00       	mov    $0x780,%eax
			crt_buf[i] = 0x0700 | ' ';
f0100637:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
			crtsave_size++;
		memmove(crtsave_buf + ((crtsave_pos + crtsave_size - 1) % CRT_SAVEROWS) * CRT_COLS, crt_buf, CRT_COLS * sizeof(uint16_t));

#endif
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f010063d:	83 c0 01             	add    $0x1,%eax
f0100640:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100645:	75 f0                	jne    f0100637 <_ZL9cons_putci+0x21a>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f0100647:	66 83 2d 26 30 37 f0 	subw   $0x50,0xf0373026
f010064e:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f010064f:	8b 0d 40 80 37 f0    	mov    0xf0378040,%ecx
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100655:	b8 0e 00 00 00       	mov    $0xe,%eax
f010065a:	89 ca                	mov    %ecx,%edx
f010065c:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010065d:	0f b7 35 26 30 37 f0 	movzwl 0xf0373026,%esi
f0100664:	8d 59 01             	lea    0x1(%ecx),%ebx
f0100667:	89 f2                	mov    %esi,%edx
f0100669:	0f b6 c6             	movzbl %dh,%eax
f010066c:	89 da                	mov    %ebx,%edx
f010066e:	ee                   	out    %al,(%dx)
f010066f:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100674:	89 ca                	mov    %ecx,%edx
f0100676:	ee                   	out    %al,(%dx)
f0100677:	89 f0                	mov    %esi,%eax
f0100679:	89 da                	mov    %ebx,%edx
f010067b:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010067c:	83 c4 2c             	add    $0x2c,%esp
f010067f:	5b                   	pop    %ebx
f0100680:	5e                   	pop    %esi
f0100681:	5f                   	pop    %edi
f0100682:	5d                   	pop    %ebp
f0100683:	c3                   	ret    
	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
f0100684:	0f b6 75 e4          	movzbl -0x1c(%ebp),%esi
f0100688:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010068d:	89 f0                	mov    %esi,%eax
f010068f:	ee                   	out    %al,(%dx)
f0100690:	bb 01 32 00 00       	mov    $0x3201,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100695:	bf 79 03 00 00       	mov    $0x379,%edi
f010069a:	e9 b5 fd ff ff       	jmp    f0100454 <_ZL9cons_putci+0x37>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010069f:	ba 78 03 00 00       	mov    $0x378,%edx
f01006a4:	89 f0                	mov    %esi,%eax
f01006a6:	ee                   	out    %al,(%dx)
f01006a7:	b2 7a                	mov    $0x7a,%dl
f01006a9:	b8 0d 00 00 00       	mov    $0xd,%eax
f01006ae:	ee                   	out    %al,(%dx)
f01006af:	b8 08 00 00 00       	mov    $0x8,%eax
f01006b4:	ee                   	out    %al,(%dx)
static void
cga_putc(int c)
{
#if CRT_SAVEROWS > 0
	// unscroll if necessary
	if (crtsave_backscroll > 0) {
f01006b5:	66 83 3d 20 30 37 f0 	cmpw   $0x0,0xf0373020
f01006bc:	00 
f01006bd:	0f 8f af fd ff ff    	jg     f0100472 <_ZL9cons_putci+0x55>
f01006c3:	e9 ce fd ff ff       	jmp    f0100496 <_ZL9cons_putci+0x79>

f01006c8 <_ZL13kbd_proc_datav>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f01006c8:	55                   	push   %ebp
f01006c9:	89 e5                	mov    %esp,%ebp
f01006cb:	83 ec 28             	sub    $0x28,%esp
f01006ce:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f01006d1:	89 75 f8             	mov    %esi,-0x8(%ebp)
f01006d4:	89 7d fc             	mov    %edi,-0x4(%ebp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006d7:	ba 64 00 00 00       	mov    $0x64,%edx
f01006dc:	ec                   	in     (%dx),%al
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
f01006dd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
{
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f01006e2:	a8 01                	test   $0x1,%al
f01006e4:	0f 84 7e 01 00 00    	je     f0100868 <_ZL13kbd_proc_datav+0x1a0>
f01006ea:	b2 60                	mov    $0x60,%dl
f01006ec:	ec                   	in     (%dx),%al
f01006ed:	89 c2                	mov    %eax,%edx
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f01006ef:	3c e0                	cmp    $0xe0,%al
f01006f1:	75 11                	jne    f0100704 <_ZL13kbd_proc_datav+0x3c>
		// E0 escape character
		shift |= E0ESC;
f01006f3:	83 0d 68 82 37 f0 40 	orl    $0x40,0xf0378268
		return 0;
f01006fa:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006ff:	e9 64 01 00 00       	jmp    f0100868 <_ZL13kbd_proc_datav+0x1a0>
	} else if (data & 0x80) {
f0100704:	84 c0                	test   %al,%al
f0100706:	79 37                	jns    f010073f <_ZL13kbd_proc_datav+0x77>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f0100708:	8b 0d 68 82 37 f0    	mov    0xf0378268,%ecx
f010070e:	89 cb                	mov    %ecx,%ebx
f0100710:	83 e3 40             	and    $0x40,%ebx
f0100713:	83 e0 7f             	and    $0x7f,%eax
f0100716:	85 db                	test   %ebx,%ebx
f0100718:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010071b:	0f b6 d2             	movzbl %dl,%edx
f010071e:	0f b6 82 00 79 10 f0 	movzbl -0xfef8700(%edx),%eax
f0100725:	83 c8 40             	or     $0x40,%eax
f0100728:	0f b6 c0             	movzbl %al,%eax
f010072b:	f7 d0                	not    %eax
f010072d:	21 c1                	and    %eax,%ecx
f010072f:	89 0d 68 82 37 f0    	mov    %ecx,0xf0378268
		return 0;
f0100735:	bb 00 00 00 00       	mov    $0x0,%ebx
f010073a:	e9 29 01 00 00       	jmp    f0100868 <_ZL13kbd_proc_datav+0x1a0>
	} else if (shift & E0ESC) {
f010073f:	8b 0d 68 82 37 f0    	mov    0xf0378268,%ecx
f0100745:	f6 c1 40             	test   $0x40,%cl
f0100748:	74 0e                	je     f0100758 <_ZL13kbd_proc_datav+0x90>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f010074a:	89 c2                	mov    %eax,%edx
f010074c:	83 ca 80             	or     $0xffffff80,%edx
		shift &= ~E0ESC;
f010074f:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100752:	89 0d 68 82 37 f0    	mov    %ecx,0xf0378268
	}

	shift |= shiftcode[data];
f0100758:	0f b6 d2             	movzbl %dl,%edx
f010075b:	0f b6 82 00 79 10 f0 	movzbl -0xfef8700(%edx),%eax
f0100762:	0b 05 68 82 37 f0    	or     0xf0378268,%eax
	shift ^= togglecode[data];
f0100768:	0f b6 8a 00 7a 10 f0 	movzbl -0xfef8600(%edx),%ecx
f010076f:	31 c8                	xor    %ecx,%eax
f0100771:	a3 68 82 37 f0       	mov    %eax,0xf0378268

	c = charcode[shift & (CTL | SHIFT)][data];
f0100776:	89 c1                	mov    %eax,%ecx
f0100778:	83 e1 03             	and    $0x3,%ecx
f010077b:	8b 1c 8d 00 7b 10 f0 	mov    -0xfef8500(,%ecx,4),%ebx
f0100782:	0f b6 1c 13          	movzbl (%ebx,%edx,1),%ebx
	if (shift & CAPSLOCK) {
f0100786:	a8 08                	test   $0x8,%al
f0100788:	74 19                	je     f01007a3 <_ZL13kbd_proc_datav+0xdb>
		if ('a' <= c && c <= 'z')
f010078a:	8d 53 9f             	lea    -0x61(%ebx),%edx
f010078d:	83 fa 19             	cmp    $0x19,%edx
f0100790:	77 05                	ja     f0100797 <_ZL13kbd_proc_datav+0xcf>
			c += 'A' - 'a';
f0100792:	83 eb 20             	sub    $0x20,%ebx
f0100795:	eb 0c                	jmp    f01007a3 <_ZL13kbd_proc_datav+0xdb>
		else if ('A' <= c && c <= 'Z')
f0100797:	8d 73 bf             	lea    -0x41(%ebx),%esi
			c += 'a' - 'A';
f010079a:	8d 53 20             	lea    0x20(%ebx),%edx
f010079d:	83 fe 19             	cmp    $0x19,%esi
f01007a0:	0f 46 da             	cmovbe %edx,%ebx
	}

	// Process special keys
#if CRT_SAVEROWS > 0
	// Shift-PageUp and Shift-PageDown: scroll console
	if ((shift & (CTL | SHIFT)) && (c == KEY_PGUP || c == KEY_PGDN)) {
f01007a3:	85 c9                	test   %ecx,%ecx
f01007a5:	0f 84 98 00 00 00    	je     f0100843 <_ZL13kbd_proc_datav+0x17b>
f01007ab:	8d 93 1a ff ff ff    	lea    -0xe6(%ebx),%edx
f01007b1:	83 fa 01             	cmp    $0x1,%edx
f01007b4:	0f 87 89 00 00 00    	ja     f0100843 <_ZL13kbd_proc_datav+0x17b>
		cga_scroll(c == KEY_PGUP ? -CRT_ROWS : CRT_ROWS);
f01007ba:	81 fb e6 00 00 00    	cmp    $0xe6,%ebx
f01007c0:	b8 e7 ff ff ff       	mov    $0xffffffe7,%eax
f01007c5:	b9 19 00 00 00       	mov    $0x19,%ecx
f01007ca:	0f 44 c8             	cmove  %eax,%ecx

#if CRT_SAVEROWS > 0
static void
cga_scroll(int delta)
{
	int new_backscroll = MAX(MIN(crtsave_backscroll - delta, crtsave_size), 0);
f01007cd:	0f b7 3d 20 30 37 f0 	movzwl 0xf0373020,%edi
f01007d4:	0f bf d7             	movswl %di,%edx
f01007d7:	0f b7 05 24 30 37 f0 	movzwl 0xf0373024,%eax
f01007de:	89 d3                	mov    %edx,%ebx
f01007e0:	29 cb                	sub    %ecx,%ebx
f01007e2:	89 d9                	mov    %ebx,%ecx
f01007e4:	39 c3                	cmp    %eax,%ebx
f01007e6:	0f 4f c8             	cmovg  %eax,%ecx
f01007e9:	85 c9                	test   %ecx,%ecx
f01007eb:	be 00 00 00 00       	mov    $0x0,%esi
f01007f0:	0f 49 f1             	cmovns %ecx,%esi
	// Process special keys
#if CRT_SAVEROWS > 0
	// Shift-PageUp and Shift-PageDown: scroll console
	if ((shift & (CTL | SHIFT)) && (c == KEY_PGUP || c == KEY_PGDN)) {
		cga_scroll(c == KEY_PGUP ? -CRT_ROWS : CRT_ROWS);
		return 0;
f01007f3:	bb 00 00 00 00       	mov    $0x0,%ebx
static void
cga_scroll(int delta)
{
	int new_backscroll = MAX(MIN(crtsave_backscroll - delta, crtsave_size), 0);

	if (new_backscroll == crtsave_backscroll)
f01007f8:	39 d6                	cmp    %edx,%esi
f01007fa:	74 6c                	je     f0100868 <_ZL13kbd_proc_datav+0x1a0>
		return;
	if (crtsave_backscroll == 0)
f01007fc:	66 85 ff             	test   %di,%di
f01007ff:	75 14                	jne    f0100815 <_ZL13kbd_proc_datav+0x14d>
		// save current screen
		cga_savebuf_copy(crtsave_pos + crtsave_size, 0);
f0100801:	0f b7 15 22 30 37 f0 	movzwl 0xf0373022,%edx
f0100808:	8d 04 02             	lea    (%edx,%eax,1),%eax
f010080b:	ba 00 00 00 00       	mov    $0x0,%edx
f0100810:	e8 26 fb ff ff       	call   f010033b <_ZL16cga_savebuf_copyib>

	crtsave_backscroll = new_backscroll;
f0100815:	66 89 35 20 30 37 f0 	mov    %si,0xf0373020
	cga_savebuf_copy(crtsave_pos + crtsave_size - crtsave_backscroll, 1);
f010081c:	0f b7 15 24 30 37 f0 	movzwl 0xf0373024,%edx
f0100823:	0f b7 05 22 30 37 f0 	movzwl 0xf0373022,%eax
f010082a:	8d 04 02             	lea    (%edx,%eax,1),%eax
f010082d:	0f bf f6             	movswl %si,%esi
f0100830:	29 f0                	sub    %esi,%eax
f0100832:	ba 01 00 00 00       	mov    $0x1,%edx
f0100837:	e8 ff fa ff ff       	call   f010033b <_ZL16cga_savebuf_copyib>
	// Process special keys
#if CRT_SAVEROWS > 0
	// Shift-PageUp and Shift-PageDown: scroll console
	if ((shift & (CTL | SHIFT)) && (c == KEY_PGUP || c == KEY_PGDN)) {
		cga_scroll(c == KEY_PGUP ? -CRT_ROWS : CRT_ROWS);
		return 0;
f010083c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100841:	eb 25                	jmp    f0100868 <_ZL13kbd_proc_datav+0x1a0>
	}
#endif
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100843:	f7 d0                	not    %eax
f0100845:	a8 06                	test   $0x6,%al
f0100847:	75 1f                	jne    f0100868 <_ZL13kbd_proc_datav+0x1a0>
f0100849:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010084f:	75 17                	jne    f0100868 <_ZL13kbd_proc_datav+0x1a0>
		cprintf("Rebooting!\n");
f0100851:	c7 04 24 69 78 10 f0 	movl   $0xf0107869,(%esp)
f0100858:	e8 55 38 00 00       	call   f01040b2 <_Z7cprintfPKcz>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010085d:	ba 92 00 00 00       	mov    $0x92,%edx
f0100862:	b8 03 00 00 00       	mov    $0x3,%eax
f0100867:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f0100868:	89 d8                	mov    %ebx,%eax
f010086a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f010086d:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0100870:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0100873:	89 ec                	mov    %ebp,%esp
f0100875:	5d                   	pop    %ebp
f0100876:	c3                   	ret    

f0100877 <_Z11serial_intrv>:
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f0100877:	55                   	push   %ebp
f0100878:	89 e5                	mov    %esp,%ebp
f010087a:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
f010087d:	80 3d 48 80 37 f0 00 	cmpb   $0x0,0xf0378048
f0100884:	74 0a                	je     f0100890 <_Z11serial_intrv+0x19>
		cons_intr(serial_proc_data);
f0100886:	b8 de 02 10 f0       	mov    $0xf01002de,%eax
f010088b:	e8 6e fa ff ff       	call   f01002fe <_ZL9cons_intrPFivE>
}
f0100890:	c9                   	leave  
f0100891:	c3                   	ret    

f0100892 <_Z8kbd_intrv>:
	return c;
}

void
kbd_intr(void)
{
f0100892:	55                   	push   %ebp
f0100893:	89 e5                	mov    %esp,%ebp
f0100895:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100898:	b8 c8 06 10 f0       	mov    $0xf01006c8,%eax
f010089d:	e8 5c fa ff ff       	call   f01002fe <_ZL9cons_intrPFivE>
}
f01008a2:	c9                   	leave  
f01008a3:	c3                   	ret    

f01008a4 <_Z9cons_getcv>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f01008a4:	55                   	push   %ebp
f01008a5:	89 e5                	mov    %esp,%ebp
f01008a7:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f01008aa:	e8 c8 ff ff ff       	call   f0100877 <_Z11serial_intrv>
	kbd_intr();
f01008af:	e8 de ff ff ff       	call   f0100892 <_Z8kbd_intrv>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f01008b4:	8b 15 60 82 37 f0    	mov    0xf0378260,%edx
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
	}
	return 0;
f01008ba:	b8 00 00 00 00       	mov    $0x0,%eax
	// (e.g., when called from the kernel monitor).
	serial_intr();
	kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f01008bf:	3b 15 64 82 37 f0    	cmp    0xf0378264,%edx
f01008c5:	74 1e                	je     f01008e5 <_Z9cons_getcv+0x41>
		c = cons.buf[cons.rpos++];
f01008c7:	0f b6 82 60 80 37 f0 	movzbl -0xfc87fa0(%edx),%eax
f01008ce:	83 c2 01             	add    $0x1,%edx
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
f01008d1:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01008d7:	b9 00 00 00 00       	mov    $0x0,%ecx
f01008dc:	0f 44 d1             	cmove  %ecx,%edx
f01008df:	89 15 60 82 37 f0    	mov    %edx,0xf0378260
		return c;
	}
	return 0;
}
f01008e5:	c9                   	leave  
f01008e6:	c3                   	ret    

f01008e7 <_Z9cons_initv>:
}

// initialize the console devices
void
cons_init(void)
{
f01008e7:	55                   	push   %ebp
f01008e8:	89 e5                	mov    %esp,%ebp
f01008ea:	57                   	push   %edi
f01008eb:	56                   	push   %esi
f01008ec:	53                   	push   %ebx
f01008ed:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f01008f0:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01008f7:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01008fe:	5a a5 
	if (*cp != 0xA55A) {
f0100900:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100907:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010090b:	74 11                	je     f010091e <_Z9cons_initv+0x37>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f010090d:	c7 05 40 80 37 f0 b4 	movl   $0x3b4,0xf0378040
f0100914:	03 00 00 

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
	*cp = (uint16_t) 0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100917:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f010091c:	eb 16                	jmp    f0100934 <_Z9cons_initv+0x4d>
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
f010091e:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100925:	c7 05 40 80 37 f0 d4 	movl   $0x3d4,0xf0378040
f010092c:	03 00 00 
{
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f010092f:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f0100934:	8b 0d 40 80 37 f0    	mov    0xf0378040,%ecx
f010093a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010093f:	89 ca                	mov    %ecx,%edx
f0100941:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100942:	8d 59 01             	lea    0x1(%ecx),%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100945:	89 da                	mov    %ebx,%edx
f0100947:	ec                   	in     (%dx),%al
f0100948:	0f b6 f8             	movzbl %al,%edi
f010094b:	c1 e7 08             	shl    $0x8,%edi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010094e:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100953:	89 ca                	mov    %ecx,%edx
f0100955:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100956:	89 da                	mov    %ebx,%edx
f0100958:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f0100959:	89 35 28 30 37 f0    	mov    %esi,0xf0373028

	/* Extract cursor location */
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);
f010095f:	0f b6 d8             	movzbl %al,%ebx
f0100962:	09 df                	or     %ebx,%edi

	crt_buf = (uint16_t*) cp;
	crt_pos = pos;
f0100964:	66 89 3d 26 30 37 f0 	mov    %di,0xf0373026

static void
kbd_init(void)
{
	// Drain the kbd buffer so that Bochs generates interrupts.
	kbd_intr();
f010096b:	e8 22 ff ff ff       	call   f0100892 <_Z8kbd_intrv>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f0100970:	0f b7 05 04 80 12 f0 	movzwl 0xf0128004,%eax
f0100977:	25 fd ff 00 00       	and    $0xfffd,%eax
f010097c:	89 04 24             	mov    %eax,(%esp)
f010097f:	e8 ec 35 00 00       	call   f0103f70 <_Z17irq_setmask_8259At>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100984:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f0100989:	b8 00 00 00 00       	mov    $0x0,%eax
f010098e:	89 da                	mov    %ebx,%edx
f0100990:	ee                   	out    %al,(%dx)
f0100991:	b2 fb                	mov    $0xfb,%dl
f0100993:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100998:	ee                   	out    %al,(%dx)
f0100999:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
f010099e:	b8 0c 00 00 00       	mov    $0xc,%eax
f01009a3:	89 ca                	mov    %ecx,%edx
f01009a5:	ee                   	out    %al,(%dx)
f01009a6:	b2 f9                	mov    $0xf9,%dl
f01009a8:	b8 00 00 00 00       	mov    $0x0,%eax
f01009ad:	ee                   	out    %al,(%dx)
f01009ae:	b2 fb                	mov    $0xfb,%dl
f01009b0:	b8 03 00 00 00       	mov    $0x3,%eax
f01009b5:	ee                   	out    %al,(%dx)
f01009b6:	b2 fc                	mov    $0xfc,%dl
f01009b8:	b8 00 00 00 00       	mov    $0x0,%eax
f01009bd:	ee                   	out    %al,(%dx)
f01009be:	b2 f9                	mov    $0xf9,%dl
f01009c0:	b8 01 00 00 00       	mov    $0x1,%eax
f01009c5:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01009c6:	b2 fd                	mov    $0xfd,%dl
f01009c8:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01009c9:	3c ff                	cmp    $0xff,%al
f01009cb:	0f 95 c0             	setne  %al
f01009ce:	89 c6                	mov    %eax,%esi
f01009d0:	a2 48 80 37 f0       	mov    %al,0xf0378048
f01009d5:	89 da                	mov    %ebx,%edx
f01009d7:	ec                   	in     (%dx),%al
f01009d8:	89 ca                	mov    %ecx,%edx
f01009da:	ec                   	in     (%dx),%al
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01009db:	89 f0                	mov    %esi,%eax
f01009dd:	84 c0                	test   %al,%al
f01009df:	75 0c                	jne    f01009ed <_Z9cons_initv+0x106>
		cprintf("Serial port does not exist!\n");
f01009e1:	c7 04 24 75 78 10 f0 	movl   $0xf0107875,(%esp)
f01009e8:	e8 c5 36 00 00       	call   f01040b2 <_Z7cprintfPKcz>
}
f01009ed:	83 c4 1c             	add    $0x1c,%esp
f01009f0:	5b                   	pop    %ebx
f01009f1:	5e                   	pop    %esi
f01009f2:	5f                   	pop    %edi
f01009f3:	5d                   	pop    %ebp
f01009f4:	c3                   	ret    

f01009f5 <_Z7is_ansii>:

/* Handle ANSI Escape Sequences, setting the vga_attribute byte appropriately
 * if we need to change colors */
int
is_ansi(int c) 
{
f01009f5:	55                   	push   %ebp
f01009f6:	89 e5                	mov    %esp,%ebp
	// clear out anything that isn't the character value, just in case
	c &= 0xFF;
f01009f8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax

	// the first char in the sequence.  if we've already started the sequence,
	// another ESC is invalid
	if (c == ESC)
f01009fc:	83 f8 1b             	cmp    $0x1b,%eax
f01009ff:	75 17                	jne    f0100a18 <_Z7is_ansii+0x23>
		ansi_seq = !ansi_seq;
f0100a01:	83 3d 44 80 37 f0 00 	cmpl   $0x0,0xf0378044
f0100a08:	0f 94 c0             	sete   %al
f0100a0b:	0f b6 c0             	movzbl %al,%eax
f0100a0e:	a3 44 80 37 f0       	mov    %eax,0xf0378044
f0100a13:	e9 e3 01 00 00       	jmp    f0100bfb <_Z7is_ansii+0x206>
	
	// the second char in the sequence.  If entered at any point other than as
	// the second char, the sequence is invalid
	else if (c == '[') {
f0100a18:	83 f8 5b             	cmp    $0x5b,%eax
f0100a1b:	75 19                	jne    f0100a36 <_Z7is_ansii+0x41>
		if(ansi_seq == 1)
			ansi_seq = 2;
f0100a1d:	83 3d 44 80 37 f0 01 	cmpl   $0x1,0xf0378044
f0100a24:	0f 94 c0             	sete   %al
f0100a27:	0f b6 c0             	movzbl %al,%eax
f0100a2a:	01 c0                	add    %eax,%eax
f0100a2c:	a3 44 80 37 f0       	mov    %eax,0xf0378044
f0100a31:	e9 c5 01 00 00       	jmp    f0100bfb <_Z7is_ansii+0x206>
			ansi_seq = 0;
	}

	// if the sequence has been set up, then a digit is the only remaining valid
	// character
	else if ((ansi_seq & 0x2) == 2 && c <= '9' && c >= '0') {
f0100a36:	8b 15 44 80 37 f0    	mov    0xf0378044,%edx
f0100a3c:	f6 c2 02             	test   $0x2,%dl
f0100a3f:	0f 84 a1 01 00 00    	je     f0100be6 <_Z7is_ansii+0x1f1>
f0100a45:	83 f8 39             	cmp    $0x39,%eax
f0100a48:	0f 8f 98 01 00 00    	jg     f0100be6 <_Z7is_ansii+0x1f1>
f0100a4e:	83 f8 2f             	cmp    $0x2f,%eax
f0100a51:	0f 8e 8f 01 00 00    	jle    f0100be6 <_Z7is_ansii+0x1f1>
		// the first digit entered is stored in ansi_seq, shifted left two bytes
		// the next digit is then combined with that to create the full number
		char entered = ((ansi_seq & 0x3C)>>2) * 10 + (c - '0');
f0100a57:	89 d1                	mov    %edx,%ecx
f0100a59:	83 e1 3c             	and    $0x3c,%ecx
f0100a5c:	c1 e9 02             	shr    $0x2,%ecx
f0100a5f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
f0100a62:	8d 44 48 d0          	lea    -0x30(%eax,%ecx,2),%eax

		// if first number
		if (entered < 10)
f0100a66:	3c 09                	cmp    $0x9,%al
f0100a68:	7f 13                	jg     f0100a7d <_Z7is_ansii+0x88>
			ansi_seq |= (entered)<<2;
f0100a6a:	0f be c0             	movsbl %al,%eax
f0100a6d:	c1 e0 02             	shl    $0x2,%eax
f0100a70:	09 c2                	or     %eax,%edx
f0100a72:	89 15 44 80 37 f0    	mov    %edx,0xf0378044
			}
			// regardless of whether the number was actually valid, we reset
			// the sequence
			ansi_seq = 0;
			return 1;
		}
f0100a78:	e9 7e 01 00 00       	jmp    f0100bfb <_Z7is_ansii+0x206>
		if (entered < 10)
			ansi_seq |= (entered)<<2;

		// if second number
		else {
			switch(entered) {
f0100a7d:	83 e8 1e             	sub    $0x1e,%eax
f0100a80:	3c 11                	cmp    $0x11,%al
f0100a82:	0f 87 4d 01 00 00    	ja     f0100bd5 <_Z7is_ansii+0x1e0>
f0100a88:	0f b6 c0             	movzbl %al,%eax
f0100a8b:	ff 24 85 a0 78 10 f0 	jmp    *-0xfef8760(,%eax,4)
				case ANSI_BLACK: VGA_BLACK(vga_attribute); break;
f0100a92:	80 25 00 80 12 f0 f0 	andb   $0xf0,0xf0128000
f0100a99:	e9 37 01 00 00       	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_RED: VGA_RED(vga_attribute); break;
f0100a9e:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100aa5:	83 e0 f0             	and    $0xfffffff0,%eax
f0100aa8:	83 c8 04             	or     $0x4,%eax
f0100aab:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100ab0:	e9 20 01 00 00       	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_GREEN: VGA_GREEN(vga_attribute); break;
f0100ab5:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100abc:	83 e0 f0             	and    $0xfffffff0,%eax
f0100abf:	83 c8 02             	or     $0x2,%eax
f0100ac2:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100ac7:	e9 09 01 00 00       	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_YELLOW: VGA_YELLOW(vga_attribute); break;
f0100acc:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100ad3:	83 e0 f0             	and    $0xfffffff0,%eax
f0100ad6:	83 c8 0e             	or     $0xe,%eax
f0100ad9:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100ade:	e9 f2 00 00 00       	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_BLUE: VGA_BLUE(vga_attribute); break;
f0100ae3:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100aea:	83 e0 f0             	and    $0xfffffff0,%eax
f0100aed:	83 c8 01             	or     $0x1,%eax
f0100af0:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100af5:	e9 db 00 00 00       	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_MAGENTA: VGA_MAGENTA(vga_attribute); break;
f0100afa:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100b01:	83 e0 f0             	and    $0xfffffff0,%eax
f0100b04:	83 c8 05             	or     $0x5,%eax
f0100b07:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100b0c:	e9 c4 00 00 00       	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_CYAN: VGA_CYAN(vga_attribute); break;
f0100b11:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100b18:	83 e0 f0             	and    $0xfffffff0,%eax
f0100b1b:	83 c8 03             	or     $0x3,%eax
f0100b1e:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100b23:	e9 ad 00 00 00       	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_WHITE: VGA_WHITE(vga_attribute); break;
f0100b28:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100b2f:	83 e0 f0             	and    $0xfffffff0,%eax
f0100b32:	83 c8 07             	or     $0x7,%eax
f0100b35:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100b3a:	e9 96 00 00 00       	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_BG_BLACK: VGA_BG_BLACK(vga_attribute); break;
f0100b3f:	80 25 00 80 12 f0 0f 	andb   $0xf,0xf0128000
f0100b46:	e9 8a 00 00 00       	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_BG_RED: VGA_BG_RED(vga_attribute); break;
f0100b4b:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100b52:	83 e0 0f             	and    $0xf,%eax
f0100b55:	83 c8 40             	or     $0x40,%eax
f0100b58:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100b5d:	eb 76                	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_BG_GREEN: VGA_BG_GREEN(vga_attribute); break;
f0100b5f:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100b66:	83 e0 0f             	and    $0xf,%eax
f0100b69:	83 c8 20             	or     $0x20,%eax
f0100b6c:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100b71:	eb 62                	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_BG_YELLOW: VGA_BG_YELLOW(vga_attribute); break;
f0100b73:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100b7a:	83 e0 0f             	and    $0xf,%eax
f0100b7d:	83 c8 e0             	or     $0xffffffe0,%eax
f0100b80:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100b85:	eb 4e                	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_BG_BLUE: VGA_BG_BLUE(vga_attribute); break;
f0100b87:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100b8e:	83 e0 0f             	and    $0xf,%eax
f0100b91:	83 c8 10             	or     $0x10,%eax
f0100b94:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100b99:	eb 3a                	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_BG_MAGENTA: VGA_BG_MAGENTA(vga_attribute); break;
f0100b9b:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100ba2:	83 e0 0f             	and    $0xf,%eax
f0100ba5:	83 c8 50             	or     $0x50,%eax
f0100ba8:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100bad:	eb 26                	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_BG_CYAN: VGA_BG_CYAN(vga_attribute); break;
f0100baf:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100bb6:	83 e0 0f             	and    $0xf,%eax
f0100bb9:	83 c8 30             	or     $0x30,%eax
f0100bbc:	a2 00 80 12 f0       	mov    %al,0xf0128000
f0100bc1:	eb 12                	jmp    f0100bd5 <_Z7is_ansii+0x1e0>
				case ANSI_BG_WHITE: VGA_BG_WHITE(vga_attribute); break;
f0100bc3:	0f b6 05 00 80 12 f0 	movzbl 0xf0128000,%eax
f0100bca:	83 e0 0f             	and    $0xf,%eax
f0100bcd:	83 c8 70             	or     $0x70,%eax
f0100bd0:	a2 00 80 12 f0       	mov    %al,0xf0128000
			}
			// regardless of whether the number was actually valid, we reset
			// the sequence
			ansi_seq = 0;
f0100bd5:	c7 05 44 80 37 f0 00 	movl   $0x0,0xf0378044
f0100bdc:	00 00 00 
			return 1;
f0100bdf:	b8 01 00 00 00       	mov    $0x1,%eax
f0100be4:	eb 1a                	jmp    f0100c00 <_Z7is_ansii+0x20b>
		}
	}

	// any other character is invalid.  BUT it is considered part of the invalid
	// sequence, and so is not printed.
	else if (ansi_seq != 0) {
f0100be6:	85 d2                	test   %edx,%edx
f0100be8:	74 11                	je     f0100bfb <_Z7is_ansii+0x206>
		ansi_seq = 0;
f0100bea:	c7 05 44 80 37 f0 00 	movl   $0x0,0xf0378044
f0100bf1:	00 00 00 
		return 1;
f0100bf4:	b8 01 00 00 00       	mov    $0x1,%eax
f0100bf9:	eb 05                	jmp    f0100c00 <_Z7is_ansii+0x20b>
	}
	return ansi_seq;
f0100bfb:	a1 44 80 37 f0       	mov    0xf0378044,%eax
}
f0100c00:	5d                   	pop    %ebp
f0100c01:	c3                   	ret    

f0100c02 <_Z8cputchari>:

// `High'-level console I/O.  Used by readline and cprintf.
void
cputchar(int c)
{
f0100c02:	55                   	push   %ebp
f0100c03:	89 e5                	mov    %esp,%ebp
f0100c05:	53                   	push   %ebx
f0100c06:	83 ec 14             	sub    $0x14,%esp
f0100c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Only if the char isn't part of an ANSI escape sequence do we print it
	if(!is_ansi(c)) {
f0100c0c:	89 1c 24             	mov    %ebx,(%esp)
f0100c0f:	e8 e1 fd ff ff       	call   f01009f5 <_Z7is_ansii>
f0100c14:	85 c0                	test   %eax,%eax
f0100c16:	75 11                	jne    f0100c29 <_Z8cputchari+0x27>
		cons_putc(c | vga_attribute << 8);
f0100c18:	0f be 05 00 80 12 f0 	movsbl 0xf0128000,%eax
f0100c1f:	c1 e0 08             	shl    $0x8,%eax
f0100c22:	09 d8                	or     %ebx,%eax
f0100c24:	e8 f4 f7 ff ff       	call   f010041d <_ZL9cons_putci>
	}
}
f0100c29:	83 c4 14             	add    $0x14,%esp
f0100c2c:	5b                   	pop    %ebx
f0100c2d:	5d                   	pop    %ebp
f0100c2e:	c3                   	ret    

f0100c2f <_Z7getcharv>:

int
getchar(void)
{
f0100c2f:	55                   	push   %ebp
f0100c30:	89 e5                	mov    %esp,%ebp
f0100c32:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100c35:	e8 6a fc ff ff       	call   f01008a4 <_Z9cons_getcv>
f0100c3a:	85 c0                	test   %eax,%eax
f0100c3c:	74 f7                	je     f0100c35 <_Z7getcharv+0x6>
		/* do nothing */;
	return c;
}
f0100c3e:	c9                   	leave  
f0100c3f:	c3                   	ret    

f0100c40 <_Z6isconsi>:

int
iscons(int fdnum)
{
f0100c40:	55                   	push   %ebp
f0100c41:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f0100c43:	b8 01 00 00 00       	mov    $0x1,%eax
f0100c48:	5d                   	pop    %ebp
f0100c49:	c3                   	ret    
f0100c4a:	00 00                	add    %al,(%eax)
f0100c4c:	00 00                	add    %al,(%eax)
	...

f0100c50 <_Z8mon_exitiPPcP9Trapframe>:

/***** Implementations of basic kernel monitor commands *****/

int 
mon_exit(int argc, char **argv, struct Trapframe *tf)
{
f0100c50:	55                   	push   %ebp
f0100c51:	89 e5                	mov    %esp,%ebp
    return -1;
}
f0100c53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c58:	5d                   	pop    %ebp
f0100c59:	c3                   	ret    

f0100c5a <_Z12mon_kerninfoiPPcP9Trapframe>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100c5a:	55                   	push   %ebp
f0100c5b:	89 e5                	mov    %esp,%ebp
f0100c5d:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100c60:	c7 04 24 20 7e 10 f0 	movl   $0xf0107e20,(%esp)
f0100c67:	e8 46 34 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
f0100c6c:	c7 44 24 08 0c 00 10 	movl   $0x1010000c,0x8(%esp)
f0100c73:	10 
f0100c74:	c7 44 24 04 0c 00 10 	movl   $0x10000c,0x4(%esp)
f0100c7b:	00 
f0100c7c:	c7 04 24 5c 7f 10 f0 	movl   $0xf0107f5c,(%esp)
f0100c83:	e8 2a 34 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100c88:	c7 44 24 08 e5 77 10 	movl   $0x1077e5,0x8(%esp)
f0100c8f:	00 
f0100c90:	c7 44 24 04 e5 77 10 	movl   $0xf01077e5,0x4(%esp)
f0100c97:	f0 
f0100c98:	c7 04 24 80 7f 10 f0 	movl   $0xf0107f80,(%esp)
f0100c9f:	e8 0e 34 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100ca4:	c7 44 24 08 fb 27 37 	movl   $0x3727fb,0x8(%esp)
f0100cab:	00 
f0100cac:	c7 44 24 04 fb 27 37 	movl   $0xf03727fb,0x4(%esp)
f0100cb3:	f0 
f0100cb4:	c7 04 24 a4 7f 10 f0 	movl   $0xf0107fa4,(%esp)
f0100cbb:	e8 f2 33 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100cc0:	c7 44 24 08 0c a0 3b 	movl   $0x3ba00c,0x8(%esp)
f0100cc7:	00 
f0100cc8:	c7 44 24 04 0c a0 3b 	movl   $0xf03ba00c,0x4(%esp)
f0100ccf:	f0 
f0100cd0:	c7 04 24 c8 7f 10 f0 	movl   $0xf0107fc8,(%esp)
f0100cd7:	e8 d6 33 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("Kernel executable memory footprint: %dKB\n",
		(end-_start+1023)/1024);
f0100cdc:	b8 0c 00 10 00       	mov    $0x10000c,%eax
f0100ce1:	f7 d8                	neg    %eax
f0100ce3:	8d 90 0a a8 3b f0    	lea    -0xfc457f6(%eax),%edx
f0100ce9:	05 0b a4 3b f0       	add    $0xf03ba40b,%eax
f0100cee:	85 c0                	test   %eax,%eax
f0100cf0:	0f 48 c2             	cmovs  %edx,%eax
f0100cf3:	c1 f8 0a             	sar    $0xa,%eax
f0100cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100cfa:	c7 04 24 ec 7f 10 f0 	movl   $0xf0107fec,(%esp)
f0100d01:	e8 ac 33 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	return 0;
}
f0100d06:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d0b:	c9                   	leave  
f0100d0c:	c3                   	ret    

f0100d0d <_Z8mon_helpiPPcP9Trapframe>:
	return 0;
}

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100d0d:	55                   	push   %ebp
f0100d0e:	89 e5                	mov    %esp,%ebp
f0100d10:	53                   	push   %ebx
f0100d11:	83 ec 14             	sub    $0x14,%esp
f0100d14:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100d19:	8b 83 04 81 10 f0    	mov    -0xfef7efc(%ebx),%eax
f0100d1f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100d23:	8b 83 00 81 10 f0    	mov    -0xfef7f00(%ebx),%eax
f0100d29:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100d2d:	c7 04 24 39 7e 10 f0 	movl   $0xf0107e39,(%esp)
f0100d34:	e8 79 33 00 00       	call   f01040b2 <_Z7cprintfPKcz>
f0100d39:	83 c3 0c             	add    $0xc,%ebx
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
f0100d3c:	83 fb 3c             	cmp    $0x3c,%ebx
f0100d3f:	75 d8                	jne    f0100d19 <_Z8mon_helpiPPcP9Trapframe+0xc>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}
f0100d41:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d46:	83 c4 14             	add    $0x14,%esp
f0100d49:	5b                   	pop    %ebx
f0100d4a:	5d                   	pop    %ebp
f0100d4b:	c3                   	ret    

f0100d4c <_Z7mon_boriPPcP9Trapframe>:
}

// A silly test function to make sure that the console changes colors correctly
int 
mon_bor(int argc, char **argv, struct Trapframe *tf)
{
f0100d4c:	55                   	push   %ebp
f0100d4d:	89 e5                	mov    %esp,%ebp
f0100d4f:	83 ec 18             	sub    $0x18,%esp
	cprintf("%c[41%c[34", 0x1b, 0x1b);
f0100d52:	c7 44 24 08 1b 00 00 	movl   $0x1b,0x8(%esp)
f0100d59:	00 
f0100d5a:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0100d61:	00 
f0100d62:	c7 04 24 42 7e 10 f0 	movl   $0xf0107e42,(%esp)
f0100d69:	e8 44 33 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	return 0;
}
f0100d6e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d73:	c9                   	leave  
f0100d74:	c3                   	ret    

f0100d75 <_Z13mon_backtraceiPPcP9Trapframe>:
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100d75:	55                   	push   %ebp
f0100d76:	89 e5                	mov    %esp,%ebp
f0100d78:	57                   	push   %edi
f0100d79:	56                   	push   %esi
f0100d7a:	53                   	push   %ebx
f0100d7b:	83 ec 5c             	sub    $0x5c,%esp
f0100d7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int frame_num = 0;			// the number of frames we've traversed
	struct Eipdebuginfo info;	// handy stabs info
    bool user_break = false;

	// make sure the font background isn't a disgusting color
	FONT_COLOR(ANSI_BG_BLACK);
f0100d81:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
f0100d88:	00 
f0100d89:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0100d90:	00 
f0100d91:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f0100d98:	e8 15 33 00 00       	call   f01040b2 <_Z7cprintfPKcz>

	cprintf("Stack backtrace:\n");
f0100d9d:	c7 04 24 53 7e 10 f0 	movl   $0xf0107e53,(%esp)
f0100da4:	e8 09 33 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	


    // If we are coming from a breakpoint, we need to use the eip and ebp
    // from our stackframe
    if (tf && tf->tf_trapno == T_BRKPT)
f0100da9:	85 db                	test   %ebx,%ebx
f0100dab:	74 23                	je     f0100dd0 <_Z13mon_backtraceiPPcP9Trapframe+0x5b>
f0100dad:	83 7b 28 03          	cmpl   $0x3,0x28(%ebx)
f0100db1:	75 1d                	jne    f0100dd0 <_Z13mon_backtraceiPPcP9Trapframe+0x5b>
    {
        
		eip = tf->tf_eip;
f0100db3:	8b 43 30             	mov    0x30(%ebx),%eax
f0100db6:	89 45 bc             	mov    %eax,-0x44(%ebp)
        ebp = (uint32_t *)tf->tf_regs.reg_ebp;
f0100db9:	8b 7b 10             	mov    0x10(%ebx),%edi
        user_break = true;
f0100dbc:	c6 45 c7 01          	movb   $0x1,-0x39(%ebp)
    else
        ebp = (uint32_t *)read_ebp();

	// keep following ebp, printing function info, until it hits 0
	// at which point we can't go any further back
    while(ebp != 0) {
f0100dc0:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
f0100dc7:	85 ff                	test   %edi,%edi
f0100dc9:	75 14                	jne    f0100ddf <_Z13mon_backtraceiPPcP9Trapframe+0x6a>
f0100dcb:	e9 da 02 00 00       	jmp    f01010aa <_Z13mon_backtraceiPPcP9Trapframe+0x335>
		eip = tf->tf_eip;
        ebp = (uint32_t *)tf->tf_regs.reg_ebp;
        user_break = true;
    }
    else
        ebp = (uint32_t *)read_ebp();
f0100dd0:	89 ef                	mov    %ebp,%edi
{
	uint32_t *ebp;				// the base pointer for this stack frame
	uint32_t eip = 0;		    // the return address of the callee
	int frame_num = 0;			// the number of frames we've traversed
	struct Eipdebuginfo info;	// handy stabs info
    bool user_break = false;
f0100dd2:	c6 45 c7 00          	movb   $0x0,-0x39(%ebp)

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	uint32_t *ebp;				// the base pointer for this stack frame
	uint32_t eip = 0;		    // the return address of the callee
f0100dd6:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
f0100ddd:	eb e1                	jmp    f0100dc0 <_Z13mon_backtraceiPPcP9Trapframe+0x4b>
		eip = tf->tf_eip;
        ebp = (uint32_t *)tf->tf_regs.reg_ebp;
        user_break = true;
    }
    else
        ebp = (uint32_t *)read_ebp();
f0100ddf:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0100de2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
f0100de5:	89 65 b8             	mov    %esp,-0x48(%ebp)

	// keep following ebp, printing function info, until it hits 0
	// at which point we can't go any further back
    while(ebp != 0) {
        // print the frame number that we are on
		FONT_COLOR(ANSI_RED);
f0100de8:	c7 44 24 08 1f 00 00 	movl   $0x1f,0x8(%esp)
f0100def:	00 
f0100df0:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0100df7:	00 
f0100df8:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f0100dff:	e8 ae 32 00 00       	call   f01040b2 <_Z7cprintfPKcz>
		cprintf("  %d: ", frame_num);
f0100e04:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0100e07:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e0b:	c7 04 24 65 7e 10 f0 	movl   $0xf0107e65,(%esp)
f0100e12:	e8 9b 32 00 00       	call   f01040b2 <_Z7cprintfPKcz>

        if(!user_break || frame_num) {
f0100e17:	80 7d c7 00          	cmpb   $0x0,-0x39(%ebp)
f0100e1b:	0f 84 b2 02 00 00    	je     f01010d3 <_Z13mon_backtraceiPPcP9Trapframe+0x35e>
f0100e21:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
f0100e25:	0f 84 13 01 00 00    	je     f0100f3e <_Z13mon_backtraceiPPcP9Trapframe+0x1c9>
            // print the address of the current base pointer
            FONT_COLOR(ANSI_CYAN);
f0100e2b:	c7 44 24 08 24 00 00 	movl   $0x24,0x8(%esp)
f0100e32:	00 
f0100e33:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0100e3a:	00 
f0100e3b:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f0100e42:	e8 6b 32 00 00       	call   f01040b2 <_Z7cprintfPKcz>
            cprintf("ebp %08x  ", ebp);
f0100e47:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100e4b:	c7 04 24 6c 7e 10 f0 	movl   $0xf0107e6c,(%esp)
f0100e52:	e8 5b 32 00 00       	call   f01040b2 <_Z7cprintfPKcz>

            // print the callee's return address
            FONT_COLOR(ANSI_GREEN);
f0100e57:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
f0100e5e:	00 
f0100e5f:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0100e66:	00 
f0100e67:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f0100e6e:	e8 3f 32 00 00       	call   f01040b2 <_Z7cprintfPKcz>
            if(user_break && user_mem_check(curenv, (uintptr_t)ebp + 1, sizeof (*ebp), PTE_W) < 0)
f0100e73:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0100e7a:	00 
f0100e7b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0100e82:	00 
f0100e83:	8d 47 01             	lea    0x1(%edi),%eax
f0100e86:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e8a:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0100e8f:	89 04 24             	mov    %eax,(%esp)
f0100e92:	e8 24 27 00 00       	call   f01035bb <_Z14user_mem_checkP3Envjjj>
f0100e97:	85 c0                	test   %eax,%eax
f0100e99:	0f 89 7c 02 00 00    	jns    f010111b <_Z13mon_backtraceiPPcP9Trapframe+0x3a6>
            {
                cprintf("eip ?  ", eip);
f0100e9f:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0100ea2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ea6:	c7 04 24 77 7e 10 f0 	movl   $0xf0107e77,(%esp)
f0100ead:	e8 00 32 00 00       	call   f01040b2 <_Z7cprintfPKcz>
                eip = 0;
f0100eb2:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
                eip = *(ebp+1);
                cprintf("eip %08x  ", eip);
            }
            // print the four 4-byte blocks above the return address, which 
            // may or may not be actual arguments to the function
            FONT_COLOR(ANSI_BLUE);
f0100eb9:	c7 44 24 08 22 00 00 	movl   $0x22,0x8(%esp)
f0100ec0:	00 
f0100ec1:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0100ec8:	00 
f0100ec9:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f0100ed0:	e8 dd 31 00 00       	call   f01040b2 <_Z7cprintfPKcz>
            cprintf("args");
f0100ed5:	c7 04 24 7f 7e 10 f0 	movl   $0xf0107e7f,(%esp)
f0100edc:	e8 d1 31 00 00       	call   f01040b2 <_Z7cprintfPKcz>
		(end-_start+1023)/1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
f0100ee1:	8d 5f 08             	lea    0x8(%edi),%ebx
f0100ee4:	be 04 00 00 00       	mov    $0x4,%esi
            // may or may not be actual arguments to the function
            FONT_COLOR(ANSI_BLUE);
            cprintf("args");
            for(int i = 2; i < 6; i++)
            {
                if(user_break && user_mem_check(curenv, (uintptr_t)(ebp + i), sizeof (*ebp), PTE_W) < 0)
f0100ee9:	80 7d c7 00          	cmpb   $0x0,-0x39(%ebp)
f0100eed:	0f 84 43 02 00 00    	je     f0101136 <_Z13mon_backtraceiPPcP9Trapframe+0x3c1>
f0100ef3:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0100efa:	00 
f0100efb:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0100f02:	00 
f0100f03:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100f07:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0100f0c:	89 04 24             	mov    %eax,(%esp)
f0100f0f:	e8 a7 26 00 00       	call   f01035bb <_Z14user_mem_checkP3Envjjj>
f0100f14:	85 c0                	test   %eax,%eax
f0100f16:	0f 89 1a 02 00 00    	jns    f0101136 <_Z13mon_backtraceiPPcP9Trapframe+0x3c1>
                    cprintf(" ?");
f0100f1c:	c7 04 24 84 7e 10 f0 	movl   $0xf0107e84,(%esp)
f0100f23:	e8 8a 31 00 00       	call   f01040b2 <_Z7cprintfPKcz>
f0100f28:	83 c3 04             	add    $0x4,%ebx
            }
            // print the four 4-byte blocks above the return address, which 
            // may or may not be actual arguments to the function
            FONT_COLOR(ANSI_BLUE);
            cprintf("args");
            for(int i = 2; i < 6; i++)
f0100f2b:	83 ee 01             	sub    $0x1,%esi
f0100f2e:	75 b9                	jne    f0100ee9 <_Z13mon_backtraceiPPcP9Trapframe+0x174>
                if(user_break && user_mem_check(curenv, (uintptr_t)(ebp + i), sizeof (*ebp), PTE_W) < 0)
                    cprintf(" ?");
                else
                    cprintf(" %08x", *(ebp+i));
            }
            cprintf("\n");
f0100f30:	c7 04 24 2f 8b 10 f0 	movl   $0xf0108b2f,(%esp)
f0100f37:	e8 76 31 00 00       	call   f01040b2 <_Z7cprintfPKcz>
f0100f3c:	eb 2f                	jmp    f0100f6d <_Z13mon_backtraceiPPcP9Trapframe+0x1f8>
        }
        else
        {
            FONT_COLOR(ANSI_GREEN);
f0100f3e:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
f0100f45:	00 
f0100f46:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0100f4d:	00 
f0100f4e:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f0100f55:	e8 58 31 00 00       	call   f01040b2 <_Z7cprintfPKcz>
            cprintf("eip %08x\n", eip);
f0100f5a:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0100f5d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100f61:	c7 04 24 87 7e 10 f0 	movl   $0xf0107e87,(%esp)
f0100f68:	e8 45 31 00 00       	call   f01040b2 <_Z7cprintfPKcz>
        }
		// grab the stab info about the caller's stack frame
        if(debuginfo_eip(eip, &info))
f0100f6d:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100f70:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100f74:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0100f77:	89 04 24             	mov    %eax,(%esp)
f0100f7a:	e8 63 4c 00 00       	call   f0105be2 <_Z13debuginfo_eipjP12Eipdebuginfo>
f0100f7f:	85 c0                	test   %eax,%eax
f0100f81:	74 16                	je     f0100f99 <_Z13mon_backtraceiPPcP9Trapframe+0x224>
        {
            if(!user_break || frame_num)
f0100f83:	80 7d c7 00          	cmpb   $0x0,-0x39(%ebp)
f0100f87:	74 06                	je     f0100f8f <_Z13mon_backtraceiPPcP9Trapframe+0x21a>
f0100f89:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
f0100f8d:	74 02                	je     f0100f91 <_Z13mon_backtraceiPPcP9Trapframe+0x21c>
            {
                ebp = (uint32_t *)(*ebp);
f0100f8f:	8b 3f                	mov    (%edi),%edi
f0100f91:	8b 65 b8             	mov    -0x48(%ebp),%esp
f0100f94:	e9 05 01 00 00       	jmp    f010109e <_Z13mon_backtraceiPPcP9Trapframe+0x329>
            }
            frame_num++;
            continue;;
        }
		// copy over the non-null-terminated caller function name
		char fun_name[info.eip_fn_namelen+1];
f0100f99:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0100f9c:	8d 50 1f             	lea    0x1f(%eax),%edx
f0100f9f:	83 e2 f0             	and    $0xfffffff0,%edx
f0100fa2:	29 d4                	sub    %edx,%esp
f0100fa4:	8d 5c 24 1f          	lea    0x1f(%esp),%ebx
f0100fa8:	83 e3 f0             	and    $0xfffffff0,%ebx
		fun_name[info.eip_fn_namelen] = '\0';
f0100fab:	c6 04 03 00          	movb   $0x0,(%ebx,%eax,1)
		strncpy(fun_name, info.eip_fn_name, info.eip_fn_namelen);
f0100faf:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100fb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100fb6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100fba:	89 1c 24             	mov    %ebx,(%esp)
f0100fbd:	e8 18 56 00 00       	call   f01065da <_Z7strncpyPcPKcj>

		// print the filename and line number of the caller
		FONT_COLOR(ANSI_YELLOW);
f0100fc2:	c7 44 24 08 21 00 00 	movl   $0x21,0x8(%esp)
f0100fc9:	00 
f0100fca:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0100fd1:	00 
f0100fd2:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f0100fd9:	e8 d4 30 00 00       	call   f01040b2 <_Z7cprintfPKcz>
		cprintf("     %s:%d: ", info.eip_file, info.eip_line);
f0100fde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0100fe1:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100fe5:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100fec:	c7 04 24 91 7e 10 f0 	movl   $0xf0107e91,(%esp)
f0100ff3:	e8 ba 30 00 00       	call   f01040b2 <_Z7cprintfPKcz>

		// print the function name and number of bytes into the caller function
		FONT_COLOR(ANSI_MAGENTA);
f0100ff8:	c7 44 24 08 23 00 00 	movl   $0x23,0x8(%esp)
f0100fff:	00 
f0101000:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0101007:	00 
f0101008:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f010100f:	e8 9e 30 00 00       	call   f01040b2 <_Z7cprintfPKcz>
		cprintf("%s+%x ",fun_name, eip - info.eip_fn_addr);
f0101014:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0101017:	2b 45 e0             	sub    -0x20(%ebp),%eax
f010101a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010101e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101022:	c7 04 24 9e 7e 10 f0 	movl   $0xf0107e9e,(%esp)
f0101029:	e8 84 30 00 00       	call   f01040b2 <_Z7cprintfPKcz>

		// print the number of arguments that the caller takes
		FONT_COLOR(ANSI_WHITE);
f010102e:	c7 44 24 08 25 00 00 	movl   $0x25,0x8(%esp)
f0101035:	00 
f0101036:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f010103d:	00 
f010103e:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f0101045:	e8 68 30 00 00       	call   f01040b2 <_Z7cprintfPKcz>
		cprintf("(%d arg)\n", info.eip_fn_narg);
f010104a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010104d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101051:	c7 04 24 a5 7e 10 f0 	movl   $0xf0107ea5,(%esp)
f0101058:	e8 55 30 00 00       	call   f01040b2 <_Z7cprintfPKcz>

		// move up the stack frame
        if(!user_break || frame_num)
f010105d:	80 7d c7 00          	cmpb   $0x0,-0x39(%ebp)
f0101061:	0f 84 e6 00 00 00    	je     f010114d <_Z13mon_backtraceiPPcP9Trapframe+0x3d8>
f0101067:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
f010106b:	74 2e                	je     f010109b <_Z13mon_backtraceiPPcP9Trapframe+0x326>
        {
            if(user_break && user_mem_check(curenv, (uintptr_t)ebp, sizeof *ebp, PTE_W) < 0)
f010106d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0101074:	00 
f0101075:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f010107c:	00 
f010107d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101081:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0101086:	89 04 24             	mov    %eax,(%esp)
f0101089:	e8 2d 25 00 00       	call   f01035bb <_Z14user_mem_checkP3Envjjj>
f010108e:	85 c0                	test   %eax,%eax
f0101090:	0f 89 b7 00 00 00    	jns    f010114d <_Z13mon_backtraceiPPcP9Trapframe+0x3d8>
f0101096:	8b 65 b8             	mov    -0x48(%ebp),%esp
f0101099:	eb 0f                	jmp    f01010aa <_Z13mon_backtraceiPPcP9Trapframe+0x335>
f010109b:	8b 65 b8             	mov    -0x48(%ebp),%esp
f010109e:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
    else
        ebp = (uint32_t *)read_ebp();

	// keep following ebp, printing function info, until it hits 0
	// at which point we can't go any further back
    while(ebp != 0) {
f01010a2:	85 ff                	test   %edi,%edi
f01010a4:	0f 85 35 fd ff ff    	jne    f0100ddf <_Z13mon_backtraceiPPcP9Trapframe+0x6a>
                ebp = (uint32_t *)(*ebp);
	    }

		frame_num++;
    }
    FONT_COLOR(ANSI_WHITE);
f01010aa:	c7 44 24 08 25 00 00 	movl   $0x25,0x8(%esp)
f01010b1:	00 
f01010b2:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f01010b9:	00 
f01010ba:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f01010c1:	e8 ec 2f 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	return 0;
}
f01010c6:	b8 00 00 00 00       	mov    $0x0,%eax
f01010cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01010ce:	5b                   	pop    %ebx
f01010cf:	5e                   	pop    %esi
f01010d0:	5f                   	pop    %edi
f01010d1:	5d                   	pop    %ebp
f01010d2:	c3                   	ret    
		FONT_COLOR(ANSI_RED);
		cprintf("  %d: ", frame_num);

        if(!user_break || frame_num) {
            // print the address of the current base pointer
            FONT_COLOR(ANSI_CYAN);
f01010d3:	c7 44 24 08 24 00 00 	movl   $0x24,0x8(%esp)
f01010da:	00 
f01010db:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f01010e2:	00 
f01010e3:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f01010ea:	e8 c3 2f 00 00       	call   f01040b2 <_Z7cprintfPKcz>
            cprintf("ebp %08x  ", ebp);
f01010ef:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01010f3:	c7 04 24 6c 7e 10 f0 	movl   $0xf0107e6c,(%esp)
f01010fa:	e8 b3 2f 00 00       	call   f01040b2 <_Z7cprintfPKcz>

            // print the callee's return address
            FONT_COLOR(ANSI_GREEN);
f01010ff:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
f0101106:	00 
f0101107:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f010110e:	00 
f010110f:	c7 04 24 4d 7e 10 f0 	movl   $0xf0107e4d,(%esp)
f0101116:	e8 97 2f 00 00       	call   f01040b2 <_Z7cprintfPKcz>
                cprintf("eip ?  ", eip);
                eip = 0;
            }
            else
            {
                eip = *(ebp+1);
f010111b:	8b 47 04             	mov    0x4(%edi),%eax
f010111e:	89 45 bc             	mov    %eax,-0x44(%ebp)
                cprintf("eip %08x  ", eip);
f0101121:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101125:	c7 04 24 af 7e 10 f0 	movl   $0xf0107eaf,(%esp)
f010112c:	e8 81 2f 00 00       	call   f01040b2 <_Z7cprintfPKcz>
f0101131:	e9 83 fd ff ff       	jmp    f0100eb9 <_Z13mon_backtraceiPPcP9Trapframe+0x144>
            for(int i = 2; i < 6; i++)
            {
                if(user_break && user_mem_check(curenv, (uintptr_t)(ebp + i), sizeof (*ebp), PTE_W) < 0)
                    cprintf(" ?");
                else
                    cprintf(" %08x", *(ebp+i));
f0101136:	8b 03                	mov    (%ebx),%eax
f0101138:	89 44 24 04          	mov    %eax,0x4(%esp)
f010113c:	c7 04 24 ba 7e 10 f0 	movl   $0xf0107eba,(%esp)
f0101143:	e8 6a 2f 00 00       	call   f01040b2 <_Z7cprintfPKcz>
f0101148:	e9 db fd ff ff       	jmp    f0100f28 <_Z13mon_backtraceiPPcP9Trapframe+0x1b3>
        if(!user_break || frame_num)
        {
            if(user_break && user_mem_check(curenv, (uintptr_t)ebp, sizeof *ebp, PTE_W) < 0)
                break;
            else
                ebp = (uint32_t *)(*ebp);
f010114d:	8b 3f                	mov    (%edi),%edi
f010114f:	e9 47 ff ff ff       	jmp    f010109b <_Z13mon_backtraceiPPcP9Trapframe+0x326>

f0101154 <_Z7monitorP9Trapframe>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0101154:	55                   	push   %ebp
f0101155:	89 e5                	mov    %esp,%ebp
f0101157:	57                   	push   %edi
f0101158:	56                   	push   %esi
f0101159:	53                   	push   %ebx
f010115a:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f010115d:	c7 04 24 18 80 10 f0 	movl   $0xf0108018,(%esp)
f0101164:	e8 49 2f 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("Type 'help' for a list of commands.\n");
f0101169:	c7 04 24 3c 80 10 f0 	movl   $0xf010803c,(%esp)
f0101170:	e8 3d 2f 00 00       	call   f01040b2 <_Z7cprintfPKcz>


	while (1) {
		buf = readline("K> ");
f0101175:	c7 04 24 c0 7e 10 f0 	movl   $0xf0107ec0,(%esp)
f010117c:	e8 1f 53 00 00       	call   f01064a0 <_Z8readlinePKc>
f0101181:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0101183:	85 c0                	test   %eax,%eax
f0101185:	74 ee                	je     f0101175 <_Z7monitorP9Trapframe+0x21>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0101187:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f010118e:	be 00 00 00 00       	mov    $0x0,%esi
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0101193:	0f b6 03             	movzbl (%ebx),%eax
f0101196:	84 c0                	test   %al,%al
f0101198:	74 68                	je     f0101202 <_Z7monitorP9Trapframe+0xae>
f010119a:	0f be c0             	movsbl %al,%eax
f010119d:	89 44 24 04          	mov    %eax,0x4(%esp)
f01011a1:	c7 04 24 c4 7e 10 f0 	movl   $0xf0107ec4,(%esp)
f01011a8:	e8 f6 54 00 00       	call   f01066a3 <_Z6strchrPKcc>
f01011ad:	85 c0                	test   %eax,%eax
f01011af:	0f 85 c2 00 00 00    	jne    f0101277 <_Z7monitorP9Trapframe+0x123>
			*buf++ = 0;
		if (*buf == 0)
f01011b5:	80 3b 00             	cmpb   $0x0,(%ebx)
f01011b8:	74 48                	je     f0101202 <_Z7monitorP9Trapframe+0xae>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f01011ba:	83 fe 0f             	cmp    $0xf,%esi
f01011bd:	8d 76 00             	lea    0x0(%esi),%esi
f01011c0:	75 16                	jne    f01011d8 <_Z7monitorP9Trapframe+0x84>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f01011c2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f01011c9:	00 
f01011ca:	c7 04 24 c9 7e 10 f0 	movl   $0xf0107ec9,(%esp)
f01011d1:	e8 dc 2e 00 00       	call   f01040b2 <_Z7cprintfPKcz>
f01011d6:	eb 9d                	jmp    f0101175 <_Z7monitorP9Trapframe+0x21>
			return 0;
		}
		argv[argc++] = buf;
f01011d8:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f01011dc:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f01011df:	0f b6 03             	movzbl (%ebx),%eax
f01011e2:	84 c0                	test   %al,%al
f01011e4:	74 ad                	je     f0101193 <_Z7monitorP9Trapframe+0x3f>
f01011e6:	0f be c0             	movsbl %al,%eax
f01011e9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01011ed:	c7 04 24 c4 7e 10 f0 	movl   $0xf0107ec4,(%esp)
f01011f4:	e8 aa 54 00 00       	call   f01066a3 <_Z6strchrPKcc>
f01011f9:	85 c0                	test   %eax,%eax
f01011fb:	75 96                	jne    f0101193 <_Z7monitorP9Trapframe+0x3f>
f01011fd:	e9 80 00 00 00       	jmp    f0101282 <_Z7monitorP9Trapframe+0x12e>
			buf++;
	}
	argv[argc] = 0;
f0101202:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0101209:	00 

	// Lookup and invoke the command
	if (argc == 0)
f010120a:	85 f6                	test   %esi,%esi
f010120c:	0f 84 63 ff ff ff    	je     f0101175 <_Z7monitorP9Trapframe+0x21>
f0101212:	bb 00 81 10 f0       	mov    $0xf0108100,%ebx
f0101217:	bf 00 00 00 00       	mov    $0x0,%edi
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f010121c:	8b 03                	mov    (%ebx),%eax
f010121e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101222:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0101225:	89 04 24             	mov    %eax,(%esp)
f0101228:	e8 17 54 00 00       	call   f0106644 <_Z6strcmpPKcS0_>
f010122d:	85 c0                	test   %eax,%eax
f010122f:	75 23                	jne    f0101254 <_Z7monitorP9Trapframe+0x100>
			return commands[i].func(argc, argv, tf);
f0101231:	6b ff 0c             	imul   $0xc,%edi,%edi
f0101234:	8b 45 08             	mov    0x8(%ebp),%eax
f0101237:	89 44 24 08          	mov    %eax,0x8(%esp)
f010123b:	8d 45 a8             	lea    -0x58(%ebp),%eax
f010123e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101242:	89 34 24             	mov    %esi,(%esp)
f0101245:	ff 97 08 81 10 f0    	call   *-0xfef7ef8(%edi)


	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f010124b:	85 c0                	test   %eax,%eax
f010124d:	78 3b                	js     f010128a <_Z7monitorP9Trapframe+0x136>
f010124f:	e9 21 ff ff ff       	jmp    f0101175 <_Z7monitorP9Trapframe+0x21>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f0101254:	83 c7 01             	add    $0x1,%edi
f0101257:	83 c3 0c             	add    $0xc,%ebx
f010125a:	83 ff 05             	cmp    $0x5,%edi
f010125d:	75 bd                	jne    f010121c <_Z7monitorP9Trapframe+0xc8>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f010125f:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0101262:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101266:	c7 04 24 e6 7e 10 f0 	movl   $0xf0107ee6,(%esp)
f010126d:	e8 40 2e 00 00       	call   f01040b2 <_Z7cprintfPKcz>
f0101272:	e9 fe fe ff ff       	jmp    f0101175 <_Z7monitorP9Trapframe+0x21>
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0101277:	c6 03 00             	movb   $0x0,(%ebx)
f010127a:	83 c3 01             	add    $0x1,%ebx
f010127d:	e9 11 ff ff ff       	jmp    f0101193 <_Z7monitorP9Trapframe+0x3f>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
f0101282:	83 c3 01             	add    $0x1,%ebx
f0101285:	e9 55 ff ff ff       	jmp    f01011df <_Z7monitorP9Trapframe+0x8b>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f010128a:	83 c4 5c             	add    $0x5c,%esp
f010128d:	5b                   	pop    %ebx
f010128e:	5e                   	pop    %esi
f010128f:	5f                   	pop    %edi
f0101290:	5d                   	pop    %ebp
f0101291:	c3                   	ret    

f0101292 <_Z8read_eipv>:

// Return EIP of caller.  Does not work if inlined.
unsigned
read_eip()
{
f0101292:	55                   	push   %ebp
f0101293:	89 e5                	mov    %esp,%ebp
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
f0101295:	8b 45 04             	mov    0x4(%ebp),%eax
	return callerpc;
}
f0101298:	5d                   	pop    %ebp
f0101299:	c3                   	ret    
f010129a:	00 00                	add    %al,(%eax)
f010129c:	00 00                	add    %al,(%eax)
	...

f01012a0 <_ZL10boot_allocj>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the free_pages list has been set up.
static void *
boot_alloc(uint32_t n)
{
f01012a0:	55                   	push   %ebp
f01012a1:	89 e5                	mov    %esp,%ebp
f01012a3:	89 c2                	mov    %eax,%edx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f01012a5:	83 3d 84 82 37 f0 00 	cmpl   $0x0,0xf0378284
f01012ac:	75 0f                	jne    f01012bd <_ZL10boot_allocj+0x1d>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f01012ae:	b8 0b b0 3b f0       	mov    $0xf03bb00b,%eax
f01012b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01012b8:	a3 84 82 37 f0       	mov    %eax,0xf0378284

	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.

	char *ret_page = nextfree;
f01012bd:	a1 84 82 37 f0       	mov    0xf0378284,%eax
	nextfree = ROUNDUP(nextfree + n, PGSIZE);
f01012c2:	8d 94 10 ff 0f 00 00 	lea    0xfff(%eax,%edx,1),%edx
f01012c9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01012cf:	89 15 84 82 37 f0    	mov    %edx,0xf0378284

	return ret_page;
}
f01012d5:	5d                   	pop    %ebp
f01012d6:	c3                   	ret    

f01012d7 <_ZL11check_va2paPjj>:
// The hardware normally performs this functionality for us!
// We define our own version to help check the check_kern_pgdir() function.
//
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f01012d7:	55                   	push   %ebp
f01012d8:	89 e5                	mov    %esp,%ebp
f01012da:	83 ec 18             	sub    $0x18,%esp
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f01012dd:	89 d1                	mov    %edx,%ecx
f01012df:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f01012e2:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f01012e5:	a8 01                	test   $0x1,%al
f01012e7:	74 58                	je     f0101341 <_ZL11check_va2paPjj+0x6a>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f01012e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01012ee:	89 c1                	mov    %eax,%ecx
f01012f0:	c1 e9 0c             	shr    $0xc,%ecx
f01012f3:	3b 0d 6c 82 37 f0    	cmp    0xf037826c,%ecx
f01012f9:	72 20                	jb     f010131b <_ZL11check_va2paPjj+0x44>
f01012fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01012ff:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0101306:	f0 
f0101307:	c7 44 24 04 4d 03 00 	movl   $0x34d,0x4(%esp)
f010130e:	00 
f010130f:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101316:	e8 0d ef ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	if (!(p[PTX(va)] & PTE_P))
f010131b:	c1 ea 0c             	shr    $0xc,%edx
f010131e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0101324:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f010132b:	89 c2                	mov    %eax,%edx
f010132d:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0101330:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101335:	84 d2                	test   %dl,%dl
f0101337:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f010133c:	0f 44 c2             	cmove  %edx,%eax
f010133f:	eb 05                	jmp    f0101346 <_ZL11check_va2paPjj+0x6f>
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f0101341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f0101346:	c9                   	leave  
f0101347:	c3                   	ret    

f0101348 <_ZL10nvram_readi>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0101348:	55                   	push   %ebp
f0101349:	89 e5                	mov    %esp,%ebp
f010134b:	83 ec 18             	sub    $0x18,%esp
f010134e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0101351:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0101354:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0101356:	89 04 24             	mov    %eax,(%esp)
f0101359:	e8 9a 2b 00 00       	call   f0103ef8 <_Z13mc146818_readj>
f010135e:	89 c6                	mov    %eax,%esi
f0101360:	83 c3 01             	add    $0x1,%ebx
f0101363:	89 1c 24             	mov    %ebx,(%esp)
f0101366:	e8 8d 2b 00 00       	call   f0103ef8 <_Z13mc146818_readj>
f010136b:	c1 e0 08             	shl    $0x8,%eax
f010136e:	09 f0                	or     %esi,%eax
}
f0101370:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0101373:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0101376:	89 ec                	mov    %ebp,%esp
f0101378:	5d                   	pop    %ebp
f0101379:	c3                   	ret    

f010137a <_Z9page_initv>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f010137a:	55                   	push   %ebp
f010137b:	89 e5                	mov    %esp,%ebp
f010137d:	56                   	push   %esi
f010137e:	53                   	push   %ebx
f010137f:	83 ec 10             	sub    $0x10,%esp
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	size_t i;

    // first page is null
	pages[0].pp_ref = 1;
f0101382:	a1 74 82 37 f0       	mov    0xf0378274,%eax
f0101387:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	pages[0].pp_link = NULL;
f010138d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	page_free_list = NULL;
f0101393:	c7 05 7c 82 37 f0 00 	movl   $0x0,0xf037827c
f010139a:	00 00 00 

    // base mem is free
	for (i = 1; i < npages_basemem; i++) {
f010139d:	8b 35 80 82 37 f0    	mov    0xf0378280,%esi
f01013a3:	bb 01 00 00 00       	mov    $0x1,%ebx
f01013a8:	83 fe 01             	cmp    $0x1,%esi
f01013ab:	76 31                	jbe    f01013de <_Z9page_initv+0x64>
f01013ad:	b9 00 00 00 00       	mov    $0x0,%ecx
f01013b2:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
		pages[i].pp_ref = 0;
f01013b9:	89 c2                	mov    %eax,%edx
f01013bb:	03 15 74 82 37 f0    	add    0xf0378274,%edx
f01013c1:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
		pages[i].pp_link = page_free_list;
f01013c7:	89 0a                	mov    %ecx,(%edx)
		page_free_list = &pages[i];
f01013c9:	89 c1                	mov    %eax,%ecx
f01013cb:	03 0d 74 82 37 f0    	add    0xf0378274,%ecx
	pages[0].pp_ref = 1;
	pages[0].pp_link = NULL;
	page_free_list = NULL;

    // base mem is free
	for (i = 1; i < npages_basemem; i++) {
f01013d1:	83 c3 01             	add    $0x1,%ebx
f01013d4:	39 f3                	cmp    %esi,%ebx
f01013d6:	72 da                	jb     f01013b2 <_Z9page_initv+0x38>
f01013d8:	89 0d 7c 82 37 f0    	mov    %ecx,0xf037827c
		page_free_list = &pages[i];
	}

	// i is already at IOPHYSMEM, and we pass through the EXTPHYSMEM/PGSIZE
    // all the way up to the stuff already filled by boot_alloc
	for (size_t end = PGNUM(PADDR(boot_alloc(0))); i < end; i++)
f01013de:	b8 00 00 00 00       	mov    $0x0,%eax
f01013e3:	e8 b8 fe ff ff       	call   f01012a0 <_ZL10boot_allocj>
f01013e8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01013ed:	77 20                	ja     f010140f <_Z9page_initv+0x95>
f01013ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01013f3:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f01013fa:	f0 
f01013fb:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
f0101402:	00 
f0101403:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010140a:	e8 19 ee ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f010140f:	8d 88 00 00 00 10    	lea    0x10000000(%eax),%ecx
f0101415:	c1 e9 0c             	shr    $0xc,%ecx
f0101418:	39 d9                	cmp    %ebx,%ecx
f010141a:	76 26                	jbe    f0101442 <_Z9page_initv+0xc8>
f010141c:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
	{
		pages[i].pp_ref = 1;
f0101423:	8b 15 74 82 37 f0    	mov    0xf0378274,%edx
f0101429:	66 c7 44 02 04 01 00 	movw   $0x1,0x4(%edx,%eax,1)
		pages[0].pp_link = NULL;
f0101430:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
		page_free_list = &pages[i];
	}

	// i is already at IOPHYSMEM, and we pass through the EXTPHYSMEM/PGSIZE
    // all the way up to the stuff already filled by boot_alloc
	for (size_t end = PGNUM(PADDR(boot_alloc(0))); i < end; i++)
f0101436:	83 c3 01             	add    $0x1,%ebx
f0101439:	83 c0 08             	add    $0x8,%eax
f010143c:	39 d9                	cmp    %ebx,%ecx
f010143e:	77 e3                	ja     f0101423 <_Z9page_initv+0xa9>
// After this is done, NEVER use boot_alloc again.  ONLY use the page
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
f0101440:	89 cb                	mov    %ecx,%ebx
		pages[i].pp_ref = 1;
		pages[0].pp_link = NULL;
	}

    // everything above is free
	for (; i < npages; i++) {
f0101442:	3b 1d 6c 82 37 f0    	cmp    0xf037826c,%ebx
f0101448:	73 39                	jae    f0101483 <_Z9page_initv+0x109>
f010144a:	8b 0d 7c 82 37 f0    	mov    0xf037827c,%ecx
f0101450:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
		pages[i].pp_ref = 0;
f0101457:	89 c2                	mov    %eax,%edx
f0101459:	03 15 74 82 37 f0    	add    0xf0378274,%edx
f010145f:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
		pages[i].pp_link = page_free_list;
f0101465:	89 0a                	mov    %ecx,(%edx)
		page_free_list = &pages[i];
f0101467:	89 c1                	mov    %eax,%ecx
f0101469:	03 0d 74 82 37 f0    	add    0xf0378274,%ecx
		pages[i].pp_ref = 1;
		pages[0].pp_link = NULL;
	}

    // everything above is free
	for (; i < npages; i++) {
f010146f:	83 c3 01             	add    $0x1,%ebx
f0101472:	83 c0 08             	add    $0x8,%eax
f0101475:	39 1d 6c 82 37 f0    	cmp    %ebx,0xf037826c
f010147b:	77 da                	ja     f0101457 <_Z9page_initv+0xdd>
f010147d:	89 0d 7c 82 37 f0    	mov    %ecx,0xf037827c
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
}
f0101483:	83 c4 10             	add    $0x10,%esp
f0101486:	5b                   	pop    %ebx
f0101487:	5e                   	pop    %esi
f0101488:	5d                   	pop    %ebp
f0101489:	c3                   	ret    

f010148a <_Z10page_allocv>:
// these if necessary.
// Returns NULL if out of free memory.
//
struct Page *
page_alloc(void)
{
f010148a:	55                   	push   %ebp
f010148b:	89 e5                	mov    %esp,%ebp
    // if we have no free pages, return null
	if (!page_free_list)
f010148d:	a1 7c 82 37 f0       	mov    0xf037827c,%eax
f0101492:	85 c0                	test   %eax,%eax
f0101494:	74 08                	je     f010149e <_Z10page_allocv+0x14>
		return NULL;

    // take one from the linked list if we do
	struct Page *p = page_free_list;
	page_free_list = p->pp_link;
f0101496:	8b 10                	mov    (%eax),%edx
f0101498:	89 15 7c 82 37 f0    	mov    %edx,0xf037827c
	return p;
}
f010149e:	5d                   	pop    %ebp
f010149f:	c3                   	ret    

f01014a0 <_Z9page_freeP4Page>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct Page *pp)
{
f01014a0:	55                   	push   %ebp
f01014a1:	89 e5                	mov    %esp,%ebp
f01014a3:	83 ec 18             	sub    $0x18,%esp
f01014a6:	8b 45 08             	mov    0x8(%ebp),%eax
    // put the page back on the linked list
	assert(pp->pp_ref == 0);
f01014a9:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01014ae:	74 24                	je     f01014d4 <_Z9page_freeP4Page+0x34>
f01014b0:	c7 44 24 0c c1 88 10 	movl   $0xf01088c1,0xc(%esp)
f01014b7:	f0 
f01014b8:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01014bf:	f0 
f01014c0:	c7 44 24 04 5e 01 00 	movl   $0x15e,0x4(%esp)
f01014c7:	00 
f01014c8:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01014cf:	e8 54 ed ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	pp->pp_link = page_free_list;
f01014d4:	8b 15 7c 82 37 f0    	mov    0xf037827c,%edx
f01014da:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f01014dc:	a3 7c 82 37 f0       	mov    %eax,0xf037827c
}
f01014e1:	c9                   	leave  
f01014e2:	c3                   	ret    

f01014e3 <_Z10pgdir_walkPjjb>:
//
// Hint 2: the x86 MMU checks permission bits in both the page directory
// and the page table.
pte_t *
pgdir_walk(pde_t *pgdir, uintptr_t va, bool create)
{
f01014e3:	55                   	push   %ebp
f01014e4:	89 e5                	mov    %esp,%ebp
f01014e6:	83 ec 28             	sub    $0x28,%esp
f01014e9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f01014ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
f01014ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
f01014f2:	8b 75 0c             	mov    0xc(%ebp),%esi
f01014f5:	0f b6 55 10          	movzbl 0x10(%ebp),%edx
    // grab the relevant PDE
	pgdir = &pgdir[PDX(va)];
f01014f9:	89 f3                	mov    %esi,%ebx
f01014fb:	c1 eb 16             	shr    $0x16,%ebx
f01014fe:	c1 e3 02             	shl    $0x2,%ebx
f0101501:	03 5d 08             	add    0x8(%ebp),%ebx

    // if it's null, we have to fetch a page for a page table

	if (!(*pgdir & PTE_P))
f0101504:	f6 03 01             	testb  $0x1,(%ebx)
f0101507:	75 76                	jne    f010157f <_Z10pgdir_walkPjjb+0x9c>
	{
		struct Page *p;
        
		if (!create || !(p = page_alloc()))
			return NULL;
f0101509:	b8 00 00 00 00       	mov    $0x0,%eax

	if (!(*pgdir & PTE_P))
	{
		struct Page *p;
        
		if (!create || !(p = page_alloc()))
f010150e:	84 d2                	test   %dl,%dl
f0101510:	0f 84 b4 00 00 00    	je     f01015ca <_Z10pgdir_walkPjjb+0xe7>
f0101516:	e8 6f ff ff ff       	call   f010148a <_Z10page_allocv>
f010151b:	89 c7                	mov    %eax,%edi
f010151d:	85 c0                	test   %eax,%eax
f010151f:	0f 85 b2 00 00 00    	jne    f01015d7 <_Z10pgdir_walkPjjb+0xf4>
f0101525:	e9 9b 00 00 00       	jmp    f01015c5 <_Z10pgdir_walkPjjb+0xe2>
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f010152a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010152e:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0101535:	f0 
f0101536:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f010153d:	00 
f010153e:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0101545:	e8 de ec ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
			return NULL;

        // zero out the page, increase the refcount, and insert it into PDE
		memset(page2kva(p), 0, PGSIZE);
f010154a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101551:	00 
f0101552:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101559:	00 
f010155a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010155f:	89 04 24             	mov    %eax,(%esp)
f0101562:	e8 9a 51 00 00       	call   f0106701 <memset>
		p->pp_ref++;
f0101567:	66 83 47 04 01       	addw   $0x1,0x4(%edi)
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f010156c:	2b 3d 74 82 37 f0    	sub    0xf0378274,%edi
f0101572:	c1 ff 03             	sar    $0x3,%edi
f0101575:	89 f8                	mov    %edi,%eax
f0101577:	c1 e0 0c             	shl    $0xc,%eax
		*pgdir = (pde_t) (page2pa(p) | PTE_P);
f010157a:	83 c8 01             	or     $0x1,%eax
f010157d:	89 03                	mov    %eax,(%ebx)
	}
	
    // return the virtual address that the PTE refers to
	pte_t *p = (pte_t *)KADDR(PTE_ADDR(*pgdir));
f010157f:	8b 03                	mov    (%ebx),%eax
f0101581:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101586:	89 c2                	mov    %eax,%edx
f0101588:	c1 ea 0c             	shr    $0xc,%edx
f010158b:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f0101591:	72 20                	jb     f01015b3 <_Z10pgdir_walkPjjb+0xd0>
f0101593:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101597:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f010159e:	f0 
f010159f:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
f01015a6:	00 
f01015a7:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01015ae:	e8 75 ec ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	return &p[PTX(va)];
f01015b3:	c1 ee 0a             	shr    $0xa,%esi
f01015b6:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01015bc:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f01015c3:	eb 05                	jmp    f01015ca <_Z10pgdir_walkPjjb+0xe7>
	if (!(*pgdir & PTE_P))
	{
		struct Page *p;
        
		if (!create || !(p = page_alloc()))
			return NULL;
f01015c5:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	
    // return the virtual address that the PTE refers to
	pte_t *p = (pte_t *)KADDR(PTE_ADDR(*pgdir));
	return &p[PTX(va)];
}
f01015ca:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f01015cd:	8b 75 f8             	mov    -0x8(%ebp),%esi
f01015d0:	8b 7d fc             	mov    -0x4(%ebp),%edi
f01015d3:	89 ec                	mov    %ebp,%esp
f01015d5:	5d                   	pop    %ebp
f01015d6:	c3                   	ret    
f01015d7:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f01015dd:	c1 f8 03             	sar    $0x3,%eax
f01015e0:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f01015e3:	89 c2                	mov    %eax,%edx
f01015e5:	c1 ea 0c             	shr    $0xc,%edx
f01015e8:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f01015ee:	0f 82 56 ff ff ff    	jb     f010154a <_Z10pgdir_walkPjjb+0x67>
f01015f4:	e9 31 ff ff ff       	jmp    f010152a <_Z10pgdir_walkPjjb+0x47>

f01015f9 <_Z16page_map_segmentPjjjjib>:

// XXX Assumes there is no page at that is already at the pgdir? Does not
// say to remove...
void
page_map_segment(pde_t *pgdir, uintptr_t la, size_t size, physaddr_t pa, int perm, bool ps_bit)
{
f01015f9:	55                   	push   %ebp
f01015fa:	89 e5                	mov    %esp,%ebp
f01015fc:	57                   	push   %edi
f01015fd:	56                   	push   %esi
f01015fe:	53                   	push   %ebx
f01015ff:	83 ec 4c             	sub    $0x4c,%esp
f0101602:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101605:	0f b6 45 1c          	movzbl 0x1c(%ebp),%eax
f0101609:	88 45 e7             	mov    %al,-0x19(%ebp)
    
    pte_t *pte;
    
    // 4MB vs 4KB pages
    size_t incr = (ps_bit)?BIG_PGSIZE:PGSIZE;
f010160c:	3c 01                	cmp    $0x1,%al
f010160e:	19 db                	sbb    %ebx,%ebx
f0101610:	81 e3 00 10 c0 ff    	and    $0xffc01000,%ebx
f0101616:	81 c3 00 00 40 00    	add    $0x400000,%ebx
    for (size_t i = 0; i < size; i += incr) 
f010161c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101620:	74 77                	je     f0101699 <_Z16page_map_segmentPjjjjib+0xa0>
f0101622:	89 df                	mov    %ebx,%edi
                return;
            pgdir[PDX(la + i)] |= perm;
            *pte = (pa + i) | perm | PTE_P;
        }
        else
            pgdir[PDX(la + i)] = (pde_t)((pa + i) | PTE_P | perm | PTE_PS);
f0101624:	8b 55 18             	mov    0x18(%ebp),%edx
f0101627:	80 ca 81             	or     $0x81,%dl
f010162a:	89 55 e0             	mov    %edx,-0x20(%ebp)
        if (!ps_bit) 
        {
            if (!(pte = pgdir_walk(pgdir, la + i, true)))
                return;
            pgdir[PDX(la + i)] |= perm;
            *pte = (pa + i) | perm | PTE_P;
f010162d:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0101630:	83 c9 01             	or     $0x1,%ecx
f0101633:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    // 4MB vs 4KB pages
    size_t incr = (ps_bit)?BIG_PGSIZE:PGSIZE;
    for (size_t i = 0; i < size; i += incr) 
    {
        // we don't touch PTEs if we are doing 4mb pages; everything's in PDE
        if (!ps_bit) 
f0101636:	80 7d e7 00          	cmpb   $0x0,-0x19(%ebp)
f010163a:	75 3c                	jne    f0101678 <_Z16page_map_segmentPjjjjib+0x7f>
        {
            if (!(pte = pgdir_walk(pgdir, la + i, true)))
f010163c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0101643:	00 
f0101644:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101648:	8b 45 08             	mov    0x8(%ebp),%eax
f010164b:	89 04 24             	mov    %eax,(%esp)
f010164e:	e8 90 fe ff ff       	call   f01014e3 <_Z10pgdir_walkPjjb>
f0101653:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0101656:	85 c0                	test   %eax,%eax
f0101658:	74 3f                	je     f0101699 <_Z16page_map_segmentPjjjjib+0xa0>
                return;
            pgdir[PDX(la + i)] |= perm;
f010165a:	89 f2                	mov    %esi,%edx
f010165c:	c1 ea 16             	shr    $0x16,%edx
f010165f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0101662:	8b 45 18             	mov    0x18(%ebp),%eax
f0101665:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101668:	09 04 91             	or     %eax,(%ecx,%edx,4)
            *pte = (pa + i) | perm | PTE_P;
f010166b:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010166e:	0b 55 14             	or     0x14(%ebp),%edx
f0101671:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0101674:	89 11                	mov    %edx,(%ecx)
f0101676:	eb 11                	jmp    f0101689 <_Z16page_map_segmentPjjjjib+0x90>
        }
        else
            pgdir[PDX(la + i)] = (pde_t)((pa + i) | PTE_P | perm | PTE_PS);
f0101678:	89 f0                	mov    %esi,%eax
f010167a:	c1 e8 16             	shr    $0x16,%eax
f010167d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0101680:	0b 55 14             	or     0x14(%ebp),%edx
f0101683:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101686:	89 14 81             	mov    %edx,(%ecx,%eax,4)
f0101689:	01 df                	add    %ebx,%edi
f010168b:	01 de                	add    %ebx,%esi
f010168d:	01 5d 14             	add    %ebx,0x14(%ebp)
    
    pte_t *pte;
    
    // 4MB vs 4KB pages
    size_t incr = (ps_bit)?BIG_PGSIZE:PGSIZE;
    for (size_t i = 0; i < size; i += incr) 
f0101690:	89 f8                	mov    %edi,%eax
f0101692:	29 d8                	sub    %ebx,%eax
f0101694:	39 45 10             	cmp    %eax,0x10(%ebp)
f0101697:	77 9d                	ja     f0101636 <_Z16page_map_segmentPjjjjib+0x3d>
            *pte = (pa + i) | perm | PTE_P;
        }
        else
            pgdir[PDX(la + i)] = (pde_t)((pa + i) | PTE_P | perm | PTE_PS);
    }
}
f0101699:	83 c4 4c             	add    $0x4c,%esp
f010169c:	5b                   	pop    %ebx
f010169d:	5e                   	pop    %esi
f010169e:	5f                   	pop    %edi
f010169f:	5d                   	pop    %ebp
f01016a0:	c3                   	ret    

f01016a1 <_Z11page_lookupPjjPS_>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct Page *
page_lookup(pde_t *pgdir, uintptr_t va, pte_t **pte_store)
{
f01016a1:	55                   	push   %ebp
f01016a2:	89 e5                	mov    %esp,%ebp
f01016a4:	53                   	push   %ebx
f01016a5:	83 ec 14             	sub    $0x14,%esp
f01016a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	physaddr_t pa;
	pte_t *pte;

    // grab the pte
	if (!(pte = pgdir_walk(pgdir, va, false)))
f01016ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01016b2:	00 
f01016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016b6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016ba:	8b 45 08             	mov    0x8(%ebp),%eax
f01016bd:	89 04 24             	mov    %eax,(%esp)
f01016c0:	e8 1e fe ff ff       	call   f01014e3 <_Z10pgdir_walkPjjb>
		return NULL;
f01016c5:	ba 00 00 00 00       	mov    $0x0,%edx
{
	physaddr_t pa;
	pte_t *pte;

    // grab the pte
	if (!(pte = pgdir_walk(pgdir, va, false)))
f01016ca:	85 c0                	test   %eax,%eax
f01016cc:	74 43                	je     f0101711 <_Z11page_lookupPjjPS_+0x70>
		return NULL;

    // grab the physical address
	if (!(pa = (physaddr_t) *pte))
f01016ce:	8b 10                	mov    (%eax),%edx
f01016d0:	85 d2                	test   %edx,%edx
f01016d2:	74 38                	je     f010170c <_Z11page_lookupPjjPS_+0x6b>
		return NULL;

    // store pte in pte_store if possible
	if (pte_store)
f01016d4:	85 db                	test   %ebx,%ebx
f01016d6:	74 02                	je     f01016da <_Z11page_lookupPjjPS_+0x39>
		*pte_store = pte;
f01016d8:	89 03                	mov    %eax,(%ebx)
}

static inline struct Page *
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01016da:	c1 ea 0c             	shr    $0xc,%edx
f01016dd:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f01016e3:	72 1c                	jb     f0101701 <_Z11page_lookupPjjPS_+0x60>
		panic("pa2page called with invalid pa");
f01016e5:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f01016ec:	f0 
f01016ed:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f01016f4:	00 
f01016f5:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f01016fc:	e8 27 eb ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	return &pages[PGNUM(pa)];
f0101701:	c1 e2 03             	shl    $0x3,%edx
f0101704:	03 15 74 82 37 f0    	add    0xf0378274,%edx

    // return page
	return pa2page(pa);
f010170a:	eb 05                	jmp    f0101711 <_Z11page_lookupPjjPS_+0x70>
	if (!(pte = pgdir_walk(pgdir, va, false)))
		return NULL;

    // grab the physical address
	if (!(pa = (physaddr_t) *pte))
		return NULL;
f010170c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pte_store)
		*pte_store = pte;

    // return page
	return pa2page(pa);
}
f0101711:	89 d0                	mov    %edx,%eax
f0101713:	83 c4 14             	add    $0x14,%esp
f0101716:	5b                   	pop    %ebx
f0101717:	5d                   	pop    %ebp
f0101718:	c3                   	ret    

f0101719 <_Z11page_decrefP4Page>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct Page* pp)
{
f0101719:	55                   	push   %ebp
f010171a:	89 e5                	mov    %esp,%ebp
f010171c:	83 ec 18             	sub    $0x18,%esp
f010171f:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0101722:	0f b7 50 04          	movzwl 0x4(%eax),%edx
f0101726:	83 ea 01             	sub    $0x1,%edx
f0101729:	66 89 50 04          	mov    %dx,0x4(%eax)
f010172d:	66 85 d2             	test   %dx,%dx
f0101730:	75 08                	jne    f010173a <_Z11page_decrefP4Page+0x21>
		page_free(pp);
f0101732:	89 04 24             	mov    %eax,(%esp)
f0101735:	e8 66 fd ff ff       	call   f01014a0 <_Z9page_freeP4Page>
}
f010173a:	c9                   	leave  
f010173b:	c3                   	ret    

f010173c <_Z14tlb_invalidatePjj>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, uintptr_t va)
{
f010173c:	55                   	push   %ebp
f010173d:	89 e5                	mov    %esp,%ebp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f010173f:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0101744:	85 c0                	test   %eax,%eax
f0101746:	74 08                	je     f0101750 <_Z14tlb_invalidatePjj+0x14>
f0101748:	8b 55 08             	mov    0x8(%ebp),%edx
f010174b:	39 50 10             	cmp    %edx,0x10(%eax)
f010174e:	75 06                	jne    f0101756 <_Z14tlb_invalidatePjj+0x1a>
}

static __inline void
invlpg(uintptr_t addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101750:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101753:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f0101756:	5d                   	pop    %ebp
f0101757:	c3                   	ret    

f0101758 <_Z11page_removePjj>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, uintptr_t va)
{
f0101758:	55                   	push   %ebp
f0101759:	89 e5                	mov    %esp,%ebp
f010175b:	83 ec 28             	sub    $0x28,%esp
f010175e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0101761:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0101764:	8b 75 08             	mov    0x8(%ebp),%esi
f0101767:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *pte_store;
	struct Page *page;

    // grabs the page and PTE
	page = page_lookup(pgdir, va, &pte_store);
f010176a:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010176d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101771:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101775:	89 34 24             	mov    %esi,(%esp)
f0101778:	e8 24 ff ff ff       	call   f01016a1 <_Z11page_lookupPjjPS_>
	if (!page)
f010177d:	85 c0                	test   %eax,%eax
f010177f:	74 1d                	je     f010179e <_Z11page_removePjj+0x46>
		return;

	page_decref(page);
f0101781:	89 04 24             	mov    %eax,(%esp)
f0101784:	e8 90 ff ff ff       	call   f0101719 <_Z11page_decrefP4Page>

    // clear out PTE
	*pte_store = 0;
f0101789:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010178c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    
    tlb_invalidate(pgdir, va);
f0101792:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101796:	89 34 24             	mov    %esi,(%esp)
f0101799:	e8 9e ff ff ff       	call   f010173c <_Z14tlb_invalidatePjj>
}
f010179e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f01017a1:	8b 75 fc             	mov    -0x4(%ebp),%esi
f01017a4:	89 ec                	mov    %ebp,%esp
f01017a6:	5d                   	pop    %ebp
f01017a7:	c3                   	ret    

f01017a8 <_Z11page_insertPjP4Pagejj>:
//
// Hint: Check out pgdir_walk, page_remove, page2pa, and similar functions.
//
int
page_insert(pde_t *pgdir, struct Page *pp, uintptr_t va, pte_t perm)
{
f01017a8:	55                   	push   %ebp
f01017a9:	89 e5                	mov    %esp,%ebp
f01017ab:	83 ec 38             	sub    $0x38,%esp
f01017ae:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f01017b1:	89 75 f8             	mov    %esi,-0x8(%ebp)
f01017b4:	89 7d fc             	mov    %edi,-0x4(%ebp)
f01017b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01017ba:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01017bd:	8b 75 10             	mov    0x10(%ebp),%esi

	pte_t *pte;

    // check if page is already here, update permissions if so
	if (pp == page_lookup(pgdir, va, &pte))
f01017c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01017c3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01017c7:	89 74 24 04          	mov    %esi,0x4(%esp)
f01017cb:	89 1c 24             	mov    %ebx,(%esp)
f01017ce:	e8 ce fe ff ff       	call   f01016a1 <_Z11page_lookupPjjPS_>
f01017d3:	39 f8                	cmp    %edi,%eax
f01017d5:	75 3f                	jne    f0101816 <_Z11page_insertPjP4Pagejj+0x6e>
	{
		if (*pte != (page2pa(pp) | perm | PTE_P))
f01017d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01017da:	8b 4d 14             	mov    0x14(%ebp),%ecx
f01017dd:	83 c9 01             	or     $0x1,%ecx
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f01017e0:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f01017e6:	c1 f8 03             	sar    $0x3,%eax
f01017e9:	89 c7                	mov    %eax,%edi
f01017eb:	c1 e7 0c             	shl    $0xc,%edi
f01017ee:	09 cf                	or     %ecx,%edi
			*pte = page2pa(pp) | perm | PTE_P;
			pgdir[PDX(va)] |= perm | PTE_P;
			tlb_invalidate(pgdir, va);
		}
        // if the page is already properly mapped, just return
		return 0;
f01017f0:	b8 00 00 00 00       	mov    $0x0,%eax
	pte_t *pte;

    // check if page is already here, update permissions if so
	if (pp == page_lookup(pgdir, va, &pte))
	{
		if (*pte != (page2pa(pp) | perm | PTE_P))
f01017f5:	39 3a                	cmp    %edi,(%edx)
f01017f7:	74 72                	je     f010186b <_Z11page_insertPjP4Pagejj+0xc3>
		{
            // if we update permissions, we have to invalidate TLB
			*pte = page2pa(pp) | perm | PTE_P;
f01017f9:	89 3a                	mov    %edi,(%edx)
			pgdir[PDX(va)] |= perm | PTE_P;
f01017fb:	89 f0                	mov    %esi,%eax
f01017fd:	c1 e8 16             	shr    $0x16,%eax
f0101800:	09 0c 83             	or     %ecx,(%ebx,%eax,4)
			tlb_invalidate(pgdir, va);
f0101803:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101807:	89 1c 24             	mov    %ebx,(%esp)
f010180a:	e8 2d ff ff ff       	call   f010173c <_Z14tlb_invalidatePjj>
		}
        // if the page is already properly mapped, just return
		return 0;
f010180f:	b8 00 00 00 00       	mov    $0x0,%eax
f0101814:	eb 55                	jmp    f010186b <_Z11page_insertPjP4Pagejj+0xc3>
	}

    // kick out the old page mapped at va
	page_remove(pgdir, va);
f0101816:	89 74 24 04          	mov    %esi,0x4(%esp)
f010181a:	89 1c 24             	mov    %ebx,(%esp)
f010181d:	e8 36 ff ff ff       	call   f0101758 <_Z11page_removePjj>
	
    // grab the pte
	pte = pgdir_walk(pgdir, va, true);
f0101822:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0101829:	00 
f010182a:	89 74 24 04          	mov    %esi,0x4(%esp)
f010182e:	89 1c 24             	mov    %ebx,(%esp)
f0101831:	e8 ad fc ff ff       	call   f01014e3 <_Z10pgdir_walkPjjb>
f0101836:	89 c2                	mov    %eax,%edx
	if(!pte)
		return -E_NO_MEM;
f0101838:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    // kick out the old page mapped at va
	page_remove(pgdir, va);
	
    // grab the pte
	pte = pgdir_walk(pgdir, va, true);
	if(!pte)
f010183d:	85 d2                	test   %edx,%edx
f010183f:	74 2a                	je     f010186b <_Z11page_insertPjP4Pagejj+0xc3>
		return -E_NO_MEM;

    // update permissions on PDE and PTE and set PTE to point to the page
	pgdir[PDX(va)] |= perm;
f0101841:	c1 ee 16             	shr    $0x16,%esi
f0101844:	8b 45 14             	mov    0x14(%ebp),%eax
f0101847:	09 04 b3             	or     %eax,(%ebx,%esi,4)
	*pte = page2pa(pp) | perm | PTE_P;
f010184a:	89 c1                	mov    %eax,%ecx
f010184c:	83 c9 01             	or     $0x1,%ecx
f010184f:	89 f8                	mov    %edi,%eax
f0101851:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f0101857:	c1 f8 03             	sar    $0x3,%eax
f010185a:	c1 e0 0c             	shl    $0xc,%eax
f010185d:	09 c8                	or     %ecx,%eax
f010185f:	89 02                	mov    %eax,(%edx)
	pp->pp_ref++;
f0101861:	66 83 47 04 01       	addw   $0x1,0x4(%edi)
	return 0;
f0101866:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010186b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f010186e:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0101871:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0101874:	89 ec                	mov    %ebp,%esp
f0101876:	5d                   	pop    %ebp
f0101877:	c3                   	ret    

f0101878 <_Z8mem_initv>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0101878:	55                   	push   %ebp
f0101879:	89 e5                	mov    %esp,%ebp
f010187b:	57                   	push   %edi
f010187c:	56                   	push   %esi
f010187d:	53                   	push   %ebx
f010187e:	83 ec 5c             	sub    $0x5c,%esp
	// This code is BIOS-specific; it works on QEMU, but not necessarily
	// on all hardware. For something more robust, see, e.g., Linux's
	// arch/x86/boot/memory.c.
	// NVRAM_BASE and EXT return results in KB. EXTABOVE16M returns
	// (total memory - 16MB) / 64KB.
	baseval = nvram_read(NVRAM_BASELO);
f0101881:	b8 15 00 00 00       	mov    $0x15,%eax
f0101886:	e8 bd fa ff ff       	call   f0101348 <_ZL10nvram_readi>
f010188b:	89 c3                	mov    %eax,%ebx
	extval = nvram_read(NVRAM_EXTLO);
f010188d:	b8 17 00 00 00       	mov    $0x17,%eax
f0101892:	e8 b1 fa ff ff       	call   f0101348 <_ZL10nvram_readi>
f0101897:	89 c6                	mov    %eax,%esi
	extabove16mval = nvram_read(NVRAM_EXTABOVE16M_LO);
f0101899:	b8 34 00 00 00       	mov    $0x34,%eax
f010189e:	e8 a5 fa ff ff       	call   f0101348 <_ZL10nvram_readi>

	// Double-checks.
	if (baseval != 640)
f01018a3:	81 fb 80 02 00 00    	cmp    $0x280,%ebx
f01018a9:	74 1c                	je     f01018c7 <_Z8mem_initv+0x4f>
		panic("Physical memory detection error: base != 640K");
f01018ab:	c7 44 24 08 a4 81 10 	movl   $0xf01081a4,0x8(%esp)
f01018b2:	f0 
f01018b3:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
f01018ba:	00 
f01018bb:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01018c2:	e8 61 e9 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	if (extabove16mval != 0 && extval != 65535) {
f01018c7:	85 c0                	test   %eax,%eax
f01018c9:	0f 95 c2             	setne  %dl
f01018cc:	74 25                	je     f01018f3 <_Z8mem_initv+0x7b>
f01018ce:	81 fe ff ff 00 00    	cmp    $0xffff,%esi
f01018d4:	74 1d                	je     f01018f3 <_Z8mem_initv+0x7b>
		cprintf("Physical memory detection warning: BIOS mismatch\n");
f01018d6:	c7 04 24 d4 81 10 f0 	movl   $0xf01081d4,(%esp)
f01018dd:	e8 d0 27 00 00       	call   f01040b2 <_Z7cprintfPKcz>
		extabove16mval = 0;
	}

	// Set npages based on read values.
	npages_basemem = baseval * 1024 / PGSIZE;
f01018e2:	c7 05 80 82 37 f0 a0 	movl   $0xa0,0xf0378280
f01018e9:	00 00 00 
f01018ec:	bb a0 00 00 00       	mov    $0xa0,%ebx
f01018f1:	eb 1f                	jmp    f0101912 <_Z8mem_initv+0x9a>
f01018f3:	c1 e3 0a             	shl    $0xa,%ebx
f01018f6:	c1 eb 0c             	shr    $0xc,%ebx
f01018f9:	89 1d 80 82 37 f0    	mov    %ebx,0xf0378280
	if (extabove16mval != 0)
f01018ff:	84 d2                	test   %dl,%dl
f0101901:	74 0f                	je     f0101912 <_Z8mem_initv+0x9a>
		npages = (extabove16mval + (16<<20)/65536) * (65536 / PGSIZE);
f0101903:	05 00 01 00 00       	add    $0x100,%eax
f0101908:	c1 e0 04             	shl    $0x4,%eax
f010190b:	a3 6c 82 37 f0       	mov    %eax,0xf037826c
f0101910:	eb 1d                	jmp    f010192f <_Z8mem_initv+0xb7>
	else if (extval != 0)
f0101912:	85 f6                	test   %esi,%esi
f0101914:	74 13                	je     f0101929 <_Z8mem_initv+0xb1>
		npages = (extval * 1024 + EXTPHYSMEM) / PGSIZE;
f0101916:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f010191c:	c1 e0 0a             	shl    $0xa,%eax
f010191f:	c1 e8 0c             	shr    $0xc,%eax
f0101922:	a3 6c 82 37 f0       	mov    %eax,0xf037826c
f0101927:	eb 06                	jmp    f010192f <_Z8mem_initv+0xb7>
	else
		npages = npages_basemem;
f0101929:	89 1d 6c 82 37 f0    	mov    %ebx,0xf037826c

	cprintf("Physical memory: %uK available\n", npages * PGSIZE / 1024);
f010192f:	a1 6c 82 37 f0       	mov    0xf037826c,%eax
f0101934:	c1 e0 0c             	shl    $0xc,%eax
f0101937:	c1 e8 0a             	shr    $0xa,%eax
f010193a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010193e:	c7 04 24 08 82 10 f0 	movl   $0xf0108208,(%esp)
f0101945:	e8 68 27 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	// We can't use more than 256MB.
	if (npages > -KERNBASE / PGSIZE) {
f010194a:	81 3d 6c 82 37 f0 00 	cmpl   $0x10000,0xf037826c
f0101951:	00 01 00 
f0101954:	76 1e                	jbe    f0101974 <_Z8mem_initv+0xfc>
		npages = -KERNBASE / PGSIZE;
f0101956:	c7 05 6c 82 37 f0 00 	movl   $0x10000,0xf037826c
f010195d:	00 01 00 
		cprintf("(restricting to %uK)\n", npages * PGSIZE / 1024);
f0101960:	c7 44 24 04 00 00 04 	movl   $0x40000,0x4(%esp)
f0101967:	00 
f0101968:	c7 04 24 f4 88 10 f0 	movl   $0xf01088f4,(%esp)
f010196f:	e8 3e 27 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101974:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101979:	e8 22 f9 ff ff       	call   f01012a0 <_ZL10boot_allocj>
f010197e:	a3 70 82 37 f0       	mov    %eax,0xf0378270
	memset(kern_pgdir, 0, PGSIZE);
f0101983:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010198a:	00 
f010198b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101992:	00 
f0101993:	89 04 24             	mov    %eax,(%esp)
f0101996:	e8 66 4d 00 00       	call   f0106701 <memset>
	// Recursively insert PD in itself as a page table, to form
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)
	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f010199b:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01019a0:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01019a5:	77 20                	ja     f01019c7 <_Z8mem_initv+0x14f>
f01019a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01019ab:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f01019b2:	f0 
f01019b3:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
f01019ba:	00 
f01019bb:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01019c2:	e8 61 e8 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f01019c7:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01019cd:	83 ca 05             	or     $0x5,%edx
f01019d0:	89 90 f8 0e 00 00    	mov    %edx,0xef8(%eax)
	// Allocate an array of npages 'struct Page's and store it in 'pages'.
	// The kernel uses this array to keep track of physical pages: for
	// each physical page, there is a corresponding struct Page in this
	// array.  'npages' is the number of physical pages in memory.

	pages = (Page *) boot_alloc(npages * sizeof(Page));
f01019d6:	a1 6c 82 37 f0       	mov    0xf037826c,%eax
f01019db:	c1 e0 03             	shl    $0x3,%eax
f01019de:	e8 bd f8 ff ff       	call   f01012a0 <_ZL10boot_allocj>
f01019e3:	a3 74 82 37 f0       	mov    %eax,0xf0378274

	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.

    envs = (Env *) boot_alloc(NENV * sizeof(Env));
f01019e8:	b8 00 e0 01 00       	mov    $0x1e000,%eax
f01019ed:	e8 ae f8 ff ff       	call   f01012a0 <_ZL10boot_allocj>
f01019f2:	a3 88 82 37 f0       	mov    %eax,0xf0378288
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using page_map_segment
	// or page_insert
	page_init();
f01019f7:	e8 7e f9 ff ff       	call   f010137a <_Z9page_initv>
	struct Page *pp;
	unsigned pdx_limit = only_low_memory ? 4 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f01019fc:	8b 1d 7c 82 37 f0    	mov    0xf037827c,%ebx
f0101a02:	85 db                	test   %ebx,%ebx
f0101a04:	75 1c                	jne    f0101a22 <_Z8mem_initv+0x1aa>
		panic("'page_free_list' is a null pointer!");
f0101a06:	c7 44 24 08 28 82 10 	movl   $0xf0108228,0x8(%esp)
f0101a0d:	f0 
f0101a0e:	c7 44 24 04 93 02 00 	movl   $0x293,0x4(%esp)
f0101a15:	00 
f0101a16:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101a1d:	e8 06 e8 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0101a22:	89 d8                	mov    %ebx,%eax
f0101a24:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f0101a2a:	c1 f8 03             	sar    $0x3,%eax
f0101a2d:	c1 e0 0c             	shl    $0xc,%eax

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
f0101a30:	89 c2                	mov    %eax,%edx
f0101a32:	c1 ea 16             	shr    $0x16,%edx
f0101a35:	83 fa 03             	cmp    $0x3,%edx
f0101a38:	77 4a                	ja     f0101a84 <_Z8mem_initv+0x20c>
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0101a3a:	89 c2                	mov    %eax,%edx
f0101a3c:	c1 ea 0c             	shr    $0xc,%edx
f0101a3f:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f0101a45:	72 20                	jb     f0101a67 <_Z8mem_initv+0x1ef>
f0101a47:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101a4b:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0101a52:	f0 
f0101a53:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101a5a:	00 
f0101a5b:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0101a62:	e8 c1 e7 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
			memset(page2kva(pp), 0x97, 128);
f0101a67:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f0101a6e:	00 
f0101a6f:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0101a76:	00 
f0101a77:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101a7c:	89 04 24             	mov    %eax,(%esp)
f0101a7f:	e8 7d 4c 00 00       	call   f0106701 <memset>
	if (!page_free_list)
		panic("'page_free_list' is a null pointer!");

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101a84:	8b 1b                	mov    (%ebx),%ebx
f0101a86:	85 db                	test   %ebx,%ebx
f0101a88:	75 98                	jne    f0101a22 <_Z8mem_initv+0x1aa>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f0101a8a:	b8 00 00 00 00       	mov    $0x0,%eax
f0101a8f:	e8 0c f8 ff ff       	call   f01012a0 <_ZL10boot_allocj>
f0101a94:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101a97:	8b 0d 7c 82 37 f0    	mov    0xf037827c,%ecx
f0101a9d:	85 c9                	test   %ecx,%ecx
f0101a9f:	0f 84 ff 01 00 00    	je     f0101ca4 <_Z8mem_initv+0x42c>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0101aa5:	8b 35 74 82 37 f0    	mov    0xf0378274,%esi
f0101aab:	39 f1                	cmp    %esi,%ecx
f0101aad:	72 53                	jb     f0101b02 <_Z8mem_initv+0x28a>
		assert(pp < pages + npages);
f0101aaf:	a1 6c 82 37 f0       	mov    0xf037826c,%eax
f0101ab4:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101ab7:	8d 1c c6             	lea    (%esi,%eax,8),%ebx
f0101aba:	39 d9                	cmp    %ebx,%ecx
f0101abc:	73 6c                	jae    f0101b2a <_Z8mem_initv+0x2b2>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101abe:	89 75 d0             	mov    %esi,-0x30(%ebp)
f0101ac1:	89 c8                	mov    %ecx,%eax
f0101ac3:	29 f0                	sub    %esi,%eax
f0101ac5:	a8 07                	test   $0x7,%al
f0101ac7:	0f 85 8a 00 00 00    	jne    f0101b57 <_Z8mem_initv+0x2df>
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f0101acd:	c1 f8 03             	sar    $0x3,%eax
f0101ad0:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0101ad3:	85 c0                	test   %eax,%eax
f0101ad5:	0f 84 aa 00 00 00    	je     f0101b85 <_Z8mem_initv+0x30d>
		assert(page2pa(pp) != IOPHYSMEM);
f0101adb:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101ae0:	0f 84 ca 00 00 00    	je     f0101bb0 <_Z8mem_initv+0x338>
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101ae6:	89 ca                	mov    %ecx,%edx
static void
check_page_free_list(bool only_low_memory)
{
	struct Page *pp;
	unsigned pdx_limit = only_low_memory ? 4 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f0101ae8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0101aef:	bf 00 00 00 00       	mov    $0x0,%edi
f0101af4:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
f0101af7:	89 d9                	mov    %ebx,%ecx
f0101af9:	e9 d6 00 00 00       	jmp    f0101bd4 <_Z8mem_initv+0x35c>
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0101afe:	39 f2                	cmp    %esi,%edx
f0101b00:	73 24                	jae    f0101b26 <_Z8mem_initv+0x2ae>
f0101b02:	c7 44 24 0c 0a 89 10 	movl   $0xf010890a,0xc(%esp)
f0101b09:	f0 
f0101b0a:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101b11:	f0 
f0101b12:	c7 44 24 04 9e 02 00 	movl   $0x29e,0x4(%esp)
f0101b19:	00 
f0101b1a:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101b21:	e8 02 e7 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
		assert(pp < pages + npages);
f0101b26:	39 ca                	cmp    %ecx,%edx
f0101b28:	72 24                	jb     f0101b4e <_Z8mem_initv+0x2d6>
f0101b2a:	c7 44 24 0c 16 89 10 	movl   $0xf0108916,0xc(%esp)
f0101b31:	f0 
f0101b32:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101b39:	f0 
f0101b3a:	c7 44 24 04 9f 02 00 	movl   $0x29f,0x4(%esp)
f0101b41:	00 
f0101b42:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101b49:	e8 da e6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101b4e:	89 d0                	mov    %edx,%eax
f0101b50:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0101b53:	a8 07                	test   $0x7,%al
f0101b55:	74 24                	je     f0101b7b <_Z8mem_initv+0x303>
f0101b57:	c7 44 24 0c 4c 82 10 	movl   $0xf010824c,0xc(%esp)
f0101b5e:	f0 
f0101b5f:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101b66:	f0 
f0101b67:	c7 44 24 04 a0 02 00 	movl   $0x2a0,0x4(%esp)
f0101b6e:	00 
f0101b6f:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101b76:	e8 ad e6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0101b7b:	c1 f8 03             	sar    $0x3,%eax
f0101b7e:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0101b81:	85 c0                	test   %eax,%eax
f0101b83:	75 24                	jne    f0101ba9 <_Z8mem_initv+0x331>
f0101b85:	c7 44 24 0c 2a 89 10 	movl   $0xf010892a,0xc(%esp)
f0101b8c:	f0 
f0101b8d:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101b94:	f0 
f0101b95:	c7 44 24 04 a3 02 00 	movl   $0x2a3,0x4(%esp)
f0101b9c:	00 
f0101b9d:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101ba4:	e8 7f e6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
		assert(page2pa(pp) != IOPHYSMEM);
f0101ba9:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0101bae:	75 24                	jne    f0101bd4 <_Z8mem_initv+0x35c>
f0101bb0:	c7 44 24 0c 3b 89 10 	movl   $0xf010893b,0xc(%esp)
f0101bb7:	f0 
f0101bb8:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101bbf:	f0 
f0101bc0:	c7 44 24 04 a4 02 00 	movl   $0x2a4,0x4(%esp)
f0101bc7:	00 
f0101bc8:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101bcf:	e8 54 e6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0101bd4:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0101bd9:	75 24                	jne    f0101bff <_Z8mem_initv+0x387>
f0101bdb:	c7 44 24 0c 80 82 10 	movl   $0xf0108280,0xc(%esp)
f0101be2:	f0 
f0101be3:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101bea:	f0 
f0101beb:	c7 44 24 04 a5 02 00 	movl   $0x2a5,0x4(%esp)
f0101bf2:	00 
f0101bf3:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101bfa:	e8 29 e6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101bff:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0101c04:	75 24                	jne    f0101c2a <_Z8mem_initv+0x3b2>
f0101c06:	c7 44 24 0c 54 89 10 	movl   $0xf0108954,0xc(%esp)
f0101c0d:	f0 
f0101c0e:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101c15:	f0 
f0101c16:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
f0101c1d:	00 
f0101c1e:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101c25:	e8 fe e5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0101c2a:	89 c3                	mov    %eax,%ebx
		assert(page2pa(pp) < EXTPHYSMEM || page2kva(pp) >= first_free_page);
f0101c2c:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101c31:	76 57                	jbe    f0101c8a <_Z8mem_initv+0x412>
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0101c33:	c1 e8 0c             	shr    $0xc,%eax
f0101c36:	3b 45 cc             	cmp    -0x34(%ebp),%eax
f0101c39:	72 20                	jb     f0101c5b <_Z8mem_initv+0x3e3>
f0101c3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0101c3f:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0101c46:	f0 
f0101c47:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101c4e:	00 
f0101c4f:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0101c56:	e8 cd e5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0101c5b:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0101c61:	39 5d c8             	cmp    %ebx,-0x38(%ebp)
f0101c64:	76 29                	jbe    f0101c8f <_Z8mem_initv+0x417>
f0101c66:	c7 44 24 0c a4 82 10 	movl   $0xf01082a4,0xc(%esp)
f0101c6d:	f0 
f0101c6e:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101c75:	f0 
f0101c76:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
f0101c7d:	00 
f0101c7e:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101c85:	e8 9e e5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

		if (page2pa(pp) < EXTPHYSMEM)
			++nfree_basemem;
f0101c8a:	83 c7 01             	add    $0x1,%edi
f0101c8d:	eb 04                	jmp    f0101c93 <_Z8mem_initv+0x41b>
		else
			++nfree_extmem;
f0101c8f:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101c93:	8b 12                	mov    (%edx),%edx
f0101c95:	85 d2                	test   %edx,%edx
f0101c97:	0f 85 61 fe ff ff    	jne    f0101afe <_Z8mem_initv+0x286>
f0101c9d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f0101ca0:	85 ff                	test   %edi,%edi
f0101ca2:	7f 24                	jg     f0101cc8 <_Z8mem_initv+0x450>
f0101ca4:	c7 44 24 0c 6e 89 10 	movl   $0xf010896e,0xc(%esp)
f0101cab:	f0 
f0101cac:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101cb3:	f0 
f0101cb4:	c7 44 24 04 af 02 00 	movl   $0x2af,0x4(%esp)
f0101cbb:	00 
f0101cbc:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101cc3:	e8 60 e5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(nfree_extmem > 0);
f0101cc8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0101ccc:	7f 24                	jg     f0101cf2 <_Z8mem_initv+0x47a>
f0101cce:	c7 44 24 0c 80 89 10 	movl   $0xf0108980,0xc(%esp)
f0101cd5:	f0 
f0101cd6:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101cdd:	f0 
f0101cde:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
f0101ce5:	00 
f0101ce6:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101ced:	e8 36 e5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
{
	struct Page *pp, *pp0, *pp1, *pp2;
	int nfree;
	struct Page *fl;

	if (!pages)
f0101cf2:	85 f6                	test   %esi,%esi
f0101cf4:	75 1c                	jne    f0101d12 <_Z8mem_initv+0x49a>
		panic("'pages' is a null pointer!");
f0101cf6:	c7 44 24 08 91 89 10 	movl   $0xf0108991,0x8(%esp)
f0101cfd:	f0 
f0101cfe:	c7 44 24 04 bf 02 00 	movl   $0x2bf,0x4(%esp)
f0101d05:	00 
f0101d06:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101d0d:	e8 16 e5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// Sort the free list so that pages with lower addresses
	// come first.  (The entry_pgdir does not map all pages.)
	{
		struct Page **tp[2] = { &pp1, &pp2 };
f0101d12:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101d15:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0101d18:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0101d1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f0101d1e:	89 c8                	mov    %ecx,%eax
f0101d20:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f0101d26:	c1 e0 09             	shl    $0x9,%eax
		for (pp0 = page_free_list; pp0; pp0 = pp0->pp_link) {
			int pagetype = PDX(page2pa(pp0)) >= 4;
f0101d29:	c1 e8 16             	shr    $0x16,%eax
f0101d2c:	83 f8 03             	cmp    $0x3,%eax
f0101d2f:	0f 97 c0             	seta   %al
f0101d32:	0f b6 c0             	movzbl %al,%eax
			*tp[pagetype] = pp0;
f0101d35:	8b 54 85 d8          	mov    -0x28(%ebp,%eax,4),%edx
f0101d39:	89 0a                	mov    %ecx,(%edx)
			tp[pagetype] = &pp0->pp_link;
f0101d3b:	89 4c 85 d8          	mov    %ecx,-0x28(%ebp,%eax,4)

	// Sort the free list so that pages with lower addresses
	// come first.  (The entry_pgdir does not map all pages.)
	{
		struct Page **tp[2] = { &pp1, &pp2 };
		for (pp0 = page_free_list; pp0; pp0 = pp0->pp_link) {
f0101d3f:	8b 09                	mov    (%ecx),%ecx
f0101d41:	85 c9                	test   %ecx,%ecx
f0101d43:	75 d9                	jne    f0101d1e <_Z8mem_initv+0x4a6>
			int pagetype = PDX(page2pa(pp0)) >= 4;
			*tp[pagetype] = pp0;
			tp[pagetype] = &pp0->pp_link;
		}
		*tp[1] = 0;
f0101d45:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0101d4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0101d51:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101d54:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101d59:	a3 7c 82 37 f0       	mov    %eax,0xf037827c
	}

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101d5e:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101d63:	85 c0                	test   %eax,%eax
f0101d65:	74 09                	je     f0101d70 <_Z8mem_initv+0x4f8>
		++nfree;
f0101d67:	83 c3 01             	add    $0x1,%ebx
		*tp[0] = pp2;
		page_free_list = pp1;
	}

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101d6a:	8b 00                	mov    (%eax),%eax
f0101d6c:	85 c0                	test   %eax,%eax
f0101d6e:	75 f7                	jne    f0101d67 <_Z8mem_initv+0x4ef>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0101d70:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0101d77:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	assert((pp0 = page_alloc()));
f0101d7e:	e8 07 f7 ff ff       	call   f010148a <_Z10page_allocv>
f0101d83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101d86:	85 c0                	test   %eax,%eax
f0101d88:	75 24                	jne    f0101dae <_Z8mem_initv+0x536>
f0101d8a:	c7 44 24 0c ac 89 10 	movl   $0xf01089ac,0xc(%esp)
f0101d91:	f0 
f0101d92:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101d99:	f0 
f0101d9a:	c7 44 24 04 d5 02 00 	movl   $0x2d5,0x4(%esp)
f0101da1:	00 
f0101da2:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101da9:	e8 7a e4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert((pp1 = page_alloc()));
f0101dae:	e8 d7 f6 ff ff       	call   f010148a <_Z10page_allocv>
f0101db3:	89 c6                	mov    %eax,%esi
f0101db5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101db8:	85 c0                	test   %eax,%eax
f0101dba:	75 24                	jne    f0101de0 <_Z8mem_initv+0x568>
f0101dbc:	c7 44 24 0c c1 89 10 	movl   $0xf01089c1,0xc(%esp)
f0101dc3:	f0 
f0101dc4:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101dcb:	f0 
f0101dcc:	c7 44 24 04 d6 02 00 	movl   $0x2d6,0x4(%esp)
f0101dd3:	00 
f0101dd4:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101ddb:	e8 48 e4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert((pp2 = page_alloc()));
f0101de0:	e8 a5 f6 ff ff       	call   f010148a <_Z10page_allocv>
f0101de5:	89 c7                	mov    %eax,%edi
f0101de7:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101dea:	85 c0                	test   %eax,%eax
f0101dec:	75 24                	jne    f0101e12 <_Z8mem_initv+0x59a>
f0101dee:	c7 44 24 0c d6 89 10 	movl   $0xf01089d6,0xc(%esp)
f0101df5:	f0 
f0101df6:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101dfd:	f0 
f0101dfe:	c7 44 24 04 d7 02 00 	movl   $0x2d7,0x4(%esp)
f0101e05:	00 
f0101e06:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101e0d:	e8 16 e4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101e12:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f0101e15:	75 24                	jne    f0101e3b <_Z8mem_initv+0x5c3>
f0101e17:	c7 44 24 0c eb 89 10 	movl   $0xf01089eb,0xc(%esp)
f0101e1e:	f0 
f0101e1f:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101e26:	f0 
f0101e27:	c7 44 24 04 da 02 00 	movl   $0x2da,0x4(%esp)
f0101e2e:	00 
f0101e2f:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101e36:	e8 ed e3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101e3b:	39 c6                	cmp    %eax,%esi
f0101e3d:	74 05                	je     f0101e44 <_Z8mem_initv+0x5cc>
f0101e3f:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101e42:	75 24                	jne    f0101e68 <_Z8mem_initv+0x5f0>
f0101e44:	c7 44 24 0c e0 82 10 	movl   $0xf01082e0,0xc(%esp)
f0101e4b:	f0 
f0101e4c:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101e53:	f0 
f0101e54:	c7 44 24 04 db 02 00 	movl   $0x2db,0x4(%esp)
f0101e5b:	00 
f0101e5c:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101e63:	e8 c0 e3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0101e68:	8b 15 74 82 37 f0    	mov    0xf0378274,%edx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101e6e:	a1 6c 82 37 f0       	mov    0xf037826c,%eax
f0101e73:	c1 e0 0c             	shl    $0xc,%eax
f0101e76:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101e79:	29 d1                	sub    %edx,%ecx
f0101e7b:	c1 f9 03             	sar    $0x3,%ecx
f0101e7e:	c1 e1 0c             	shl    $0xc,%ecx
f0101e81:	39 c1                	cmp    %eax,%ecx
f0101e83:	72 24                	jb     f0101ea9 <_Z8mem_initv+0x631>
f0101e85:	c7 44 24 0c fd 89 10 	movl   $0xf01089fd,0xc(%esp)
f0101e8c:	f0 
f0101e8d:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101e94:	f0 
f0101e95:	c7 44 24 04 dc 02 00 	movl   $0x2dc,0x4(%esp)
f0101e9c:	00 
f0101e9d:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101ea4:	e8 7f e3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0101ea9:	89 f1                	mov    %esi,%ecx
f0101eab:	29 d1                	sub    %edx,%ecx
f0101ead:	c1 f9 03             	sar    $0x3,%ecx
f0101eb0:	c1 e1 0c             	shl    $0xc,%ecx
	assert(page2pa(pp1) < npages*PGSIZE);
f0101eb3:	39 c8                	cmp    %ecx,%eax
f0101eb5:	77 24                	ja     f0101edb <_Z8mem_initv+0x663>
f0101eb7:	c7 44 24 0c 1a 8a 10 	movl   $0xf0108a1a,0xc(%esp)
f0101ebe:	f0 
f0101ebf:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101ec6:	f0 
f0101ec7:	c7 44 24 04 dd 02 00 	movl   $0x2dd,0x4(%esp)
f0101ece:	00 
f0101ecf:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101ed6:	e8 4d e3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0101edb:	89 f9                	mov    %edi,%ecx
f0101edd:	29 d1                	sub    %edx,%ecx
f0101edf:	89 ca                	mov    %ecx,%edx
f0101ee1:	c1 fa 03             	sar    $0x3,%edx
f0101ee4:	c1 e2 0c             	shl    $0xc,%edx
	assert(page2pa(pp2) < npages*PGSIZE);
f0101ee7:	39 d0                	cmp    %edx,%eax
f0101ee9:	77 24                	ja     f0101f0f <_Z8mem_initv+0x697>
f0101eeb:	c7 44 24 0c 37 8a 10 	movl   $0xf0108a37,0xc(%esp)
f0101ef2:	f0 
f0101ef3:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101efa:	f0 
f0101efb:	c7 44 24 04 de 02 00 	movl   $0x2de,0x4(%esp)
f0101f02:	00 
f0101f03:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101f0a:	e8 19 e3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101f0f:	a1 7c 82 37 f0       	mov    0xf037827c,%eax
f0101f14:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101f17:	c7 05 7c 82 37 f0 00 	movl   $0x0,0xf037827c
f0101f1e:	00 00 00 

	// should be no free memory
	assert(!page_alloc());
f0101f21:	e8 64 f5 ff ff       	call   f010148a <_Z10page_allocv>
f0101f26:	85 c0                	test   %eax,%eax
f0101f28:	74 24                	je     f0101f4e <_Z8mem_initv+0x6d6>
f0101f2a:	c7 44 24 0c 54 8a 10 	movl   $0xf0108a54,0xc(%esp)
f0101f31:	f0 
f0101f32:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101f39:	f0 
f0101f3a:	c7 44 24 04 e5 02 00 	movl   $0x2e5,0x4(%esp)
f0101f41:	00 
f0101f42:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101f49:	e8 da e2 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// free and re-allocate?
	page_free(pp0);
f0101f4e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101f51:	89 14 24             	mov    %edx,(%esp)
f0101f54:	e8 47 f5 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	page_free(pp1);
f0101f59:	89 34 24             	mov    %esi,(%esp)
f0101f5c:	e8 3f f5 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	page_free(pp2);
f0101f61:	89 3c 24             	mov    %edi,(%esp)
f0101f64:	e8 37 f5 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	pp0 = pp1 = pp2 = 0;
f0101f69:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0101f70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	assert((pp0 = page_alloc()));
f0101f77:	e8 0e f5 ff ff       	call   f010148a <_Z10page_allocv>
f0101f7c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101f7f:	85 c0                	test   %eax,%eax
f0101f81:	75 24                	jne    f0101fa7 <_Z8mem_initv+0x72f>
f0101f83:	c7 44 24 0c ac 89 10 	movl   $0xf01089ac,0xc(%esp)
f0101f8a:	f0 
f0101f8b:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101f92:	f0 
f0101f93:	c7 44 24 04 ec 02 00 	movl   $0x2ec,0x4(%esp)
f0101f9a:	00 
f0101f9b:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101fa2:	e8 81 e2 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert((pp1 = page_alloc()));
f0101fa7:	e8 de f4 ff ff       	call   f010148a <_Z10page_allocv>
f0101fac:	89 c6                	mov    %eax,%esi
f0101fae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101fb1:	85 c0                	test   %eax,%eax
f0101fb3:	75 24                	jne    f0101fd9 <_Z8mem_initv+0x761>
f0101fb5:	c7 44 24 0c c1 89 10 	movl   $0xf01089c1,0xc(%esp)
f0101fbc:	f0 
f0101fbd:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101fc4:	f0 
f0101fc5:	c7 44 24 04 ed 02 00 	movl   $0x2ed,0x4(%esp)
f0101fcc:	00 
f0101fcd:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0101fd4:	e8 4f e2 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert((pp2 = page_alloc()));
f0101fd9:	e8 ac f4 ff ff       	call   f010148a <_Z10page_allocv>
f0101fde:	89 c7                	mov    %eax,%edi
f0101fe0:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101fe3:	85 c0                	test   %eax,%eax
f0101fe5:	75 24                	jne    f010200b <_Z8mem_initv+0x793>
f0101fe7:	c7 44 24 0c d6 89 10 	movl   $0xf01089d6,0xc(%esp)
f0101fee:	f0 
f0101fef:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0101ff6:	f0 
f0101ff7:	c7 44 24 04 ee 02 00 	movl   $0x2ee,0x4(%esp)
f0101ffe:	00 
f0101fff:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102006:	e8 1d e2 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f010200b:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f010200e:	75 24                	jne    f0102034 <_Z8mem_initv+0x7bc>
f0102010:	c7 44 24 0c eb 89 10 	movl   $0xf01089eb,0xc(%esp)
f0102017:	f0 
f0102018:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010201f:	f0 
f0102020:	c7 44 24 04 f0 02 00 	movl   $0x2f0,0x4(%esp)
f0102027:	00 
f0102028:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010202f:	e8 f4 e1 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102034:	39 c6                	cmp    %eax,%esi
f0102036:	74 05                	je     f010203d <_Z8mem_initv+0x7c5>
f0102038:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f010203b:	75 24                	jne    f0102061 <_Z8mem_initv+0x7e9>
f010203d:	c7 44 24 0c e0 82 10 	movl   $0xf01082e0,0xc(%esp)
f0102044:	f0 
f0102045:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010204c:	f0 
f010204d:	c7 44 24 04 f1 02 00 	movl   $0x2f1,0x4(%esp)
f0102054:	00 
f0102055:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010205c:	e8 c7 e1 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(!page_alloc());
f0102061:	e8 24 f4 ff ff       	call   f010148a <_Z10page_allocv>
f0102066:	85 c0                	test   %eax,%eax
f0102068:	74 24                	je     f010208e <_Z8mem_initv+0x816>
f010206a:	c7 44 24 0c 54 8a 10 	movl   $0xf0108a54,0xc(%esp)
f0102071:	f0 
f0102072:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102079:	f0 
f010207a:	c7 44 24 04 f2 02 00 	movl   $0x2f2,0x4(%esp)
f0102081:	00 
f0102082:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102089:	e8 9a e1 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// give free list back
	page_free_list = fl;
f010208e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102091:	89 0d 7c 82 37 f0    	mov    %ecx,0xf037827c

	// free the pages we took
	page_free(pp0);
f0102097:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010209a:	89 04 24             	mov    %eax,(%esp)
f010209d:	e8 fe f3 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	page_free(pp1);
f01020a2:	89 34 24             	mov    %esi,(%esp)
f01020a5:	e8 f6 f3 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	page_free(pp2);
f01020aa:	89 3c 24             	mov    %edi,(%esp)
f01020ad:	e8 ee f3 ff ff       	call   f01014a0 <_Z9page_freeP4Page>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01020b2:	a1 7c 82 37 f0       	mov    0xf037827c,%eax
f01020b7:	85 c0                	test   %eax,%eax
f01020b9:	74 09                	je     f01020c4 <_Z8mem_initv+0x84c>
		--nfree;
f01020bb:	83 eb 01             	sub    $0x1,%ebx
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01020be:	8b 00                	mov    (%eax),%eax
f01020c0:	85 c0                	test   %eax,%eax
f01020c2:	75 f7                	jne    f01020bb <_Z8mem_initv+0x843>
		--nfree;
	assert(nfree == 0);
f01020c4:	85 db                	test   %ebx,%ebx
f01020c6:	74 24                	je     f01020ec <_Z8mem_initv+0x874>
f01020c8:	c7 44 24 0c 62 8a 10 	movl   $0xf0108a62,0xc(%esp)
f01020cf:	f0 
f01020d0:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01020d7:	f0 
f01020d8:	c7 44 24 04 ff 02 00 	movl   $0x2ff,0x4(%esp)
f01020df:	00 
f01020e0:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01020e7:	e8 3c e1 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	cprintf("check_page_alloc() succeeded!\n");
f01020ec:	c7 04 24 00 83 10 f0 	movl   $0xf0108300,(%esp)
f01020f3:	e8 ba 1f 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	uintptr_t va;
	int i;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc()));
f01020f8:	e8 8d f3 ff ff       	call   f010148a <_Z10page_allocv>
f01020fd:	89 c3                	mov    %eax,%ebx
f01020ff:	85 c0                	test   %eax,%eax
f0102101:	75 24                	jne    f0102127 <_Z8mem_initv+0x8af>
f0102103:	c7 44 24 0c ac 89 10 	movl   $0xf01089ac,0xc(%esp)
f010210a:	f0 
f010210b:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102112:	f0 
f0102113:	c7 44 24 04 5f 03 00 	movl   $0x35f,0x4(%esp)
f010211a:	00 
f010211b:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102122:	e8 01 e1 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert((pp1 = page_alloc()));
f0102127:	e8 5e f3 ff ff       	call   f010148a <_Z10page_allocv>
f010212c:	89 c7                	mov    %eax,%edi
f010212e:	85 c0                	test   %eax,%eax
f0102130:	75 24                	jne    f0102156 <_Z8mem_initv+0x8de>
f0102132:	c7 44 24 0c c1 89 10 	movl   $0xf01089c1,0xc(%esp)
f0102139:	f0 
f010213a:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102141:	f0 
f0102142:	c7 44 24 04 60 03 00 	movl   $0x360,0x4(%esp)
f0102149:	00 
f010214a:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102151:	e8 d2 e0 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert((pp2 = page_alloc()));
f0102156:	e8 2f f3 ff ff       	call   f010148a <_Z10page_allocv>
f010215b:	89 c6                	mov    %eax,%esi
f010215d:	85 c0                	test   %eax,%eax
f010215f:	75 24                	jne    f0102185 <_Z8mem_initv+0x90d>
f0102161:	c7 44 24 0c d6 89 10 	movl   $0xf01089d6,0xc(%esp)
f0102168:	f0 
f0102169:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102170:	f0 
f0102171:	c7 44 24 04 61 03 00 	movl   $0x361,0x4(%esp)
f0102178:	00 
f0102179:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102180:	e8 a3 e0 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102185:	39 fb                	cmp    %edi,%ebx
f0102187:	75 24                	jne    f01021ad <_Z8mem_initv+0x935>
f0102189:	c7 44 24 0c eb 89 10 	movl   $0xf01089eb,0xc(%esp)
f0102190:	f0 
f0102191:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102198:	f0 
f0102199:	c7 44 24 04 64 03 00 	movl   $0x364,0x4(%esp)
f01021a0:	00 
f01021a1:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01021a8:	e8 7b e0 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01021ad:	39 c7                	cmp    %eax,%edi
f01021af:	74 04                	je     f01021b5 <_Z8mem_initv+0x93d>
f01021b1:	39 c3                	cmp    %eax,%ebx
f01021b3:	75 24                	jne    f01021d9 <_Z8mem_initv+0x961>
f01021b5:	c7 44 24 0c e0 82 10 	movl   $0xf01082e0,0xc(%esp)
f01021bc:	f0 
f01021bd:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01021c4:	f0 
f01021c5:	c7 44 24 04 65 03 00 	movl   $0x365,0x4(%esp)
f01021cc:	00 
f01021cd:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01021d4:	e8 4f e0 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01021d9:	8b 15 7c 82 37 f0    	mov    0xf037827c,%edx
f01021df:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	page_free_list = 0;
f01021e2:	c7 05 7c 82 37 f0 00 	movl   $0x0,0xf037827c
f01021e9:	00 00 00 

	// should be no free memory
	assert(!page_alloc());
f01021ec:	e8 99 f2 ff ff       	call   f010148a <_Z10page_allocv>
f01021f1:	85 c0                	test   %eax,%eax
f01021f3:	74 24                	je     f0102219 <_Z8mem_initv+0x9a1>
f01021f5:	c7 44 24 0c 54 8a 10 	movl   $0xf0108a54,0xc(%esp)
f01021fc:	f0 
f01021fd:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102204:	f0 
f0102205:	c7 44 24 04 6b 03 00 	movl   $0x36b,0x4(%esp)
f010220c:	00 
f010220d:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102214:	e8 0f e0 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, 0x0, &ptep) == NULL);
f0102219:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010221c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0102220:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102227:	00 
f0102228:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f010222d:	89 04 24             	mov    %eax,(%esp)
f0102230:	e8 6c f4 ff ff       	call   f01016a1 <_Z11page_lookupPjjPS_>
f0102235:	85 c0                	test   %eax,%eax
f0102237:	74 24                	je     f010225d <_Z8mem_initv+0x9e5>
f0102239:	c7 44 24 0c 20 83 10 	movl   $0xf0108320,0xc(%esp)
f0102240:	f0 
f0102241:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102248:	f0 
f0102249:	c7 44 24 04 6e 03 00 	movl   $0x36e,0x4(%esp)
f0102250:	00 
f0102251:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102258:	e8 cb df ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010225d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102264:	00 
f0102265:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010226c:	00 
f010226d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0102271:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102276:	89 04 24             	mov    %eax,(%esp)
f0102279:	e8 2a f5 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f010227e:	85 c0                	test   %eax,%eax
f0102280:	78 24                	js     f01022a6 <_Z8mem_initv+0xa2e>
f0102282:	c7 44 24 0c 4c 83 10 	movl   $0xf010834c,0xc(%esp)
f0102289:	f0 
f010228a:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102291:	f0 
f0102292:	c7 44 24 04 71 03 00 	movl   $0x371,0x4(%esp)
f0102299:	00 
f010229a:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01022a1:	e8 82 df ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f01022a6:	89 1c 24             	mov    %ebx,(%esp)
f01022a9:	e8 f2 f1 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01022ae:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01022b5:	00 
f01022b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01022bd:	00 
f01022be:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01022c2:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01022c7:	89 04 24             	mov    %eax,(%esp)
f01022ca:	e8 d9 f4 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f01022cf:	85 c0                	test   %eax,%eax
f01022d1:	74 24                	je     f01022f7 <_Z8mem_initv+0xa7f>
f01022d3:	c7 44 24 0c 7c 83 10 	movl   $0xf010837c,0xc(%esp)
f01022da:	f0 
f01022db:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01022e2:	f0 
f01022e3:	c7 44 24 04 75 03 00 	movl   $0x375,0x4(%esp)
f01022ea:	00 
f01022eb:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01022f2:	e8 31 df ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01022f7:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01022fc:	8b 08                	mov    (%eax),%ecx
f01022fe:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102304:	89 da                	mov    %ebx,%edx
f0102306:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f010230c:	c1 fa 03             	sar    $0x3,%edx
f010230f:	c1 e2 0c             	shl    $0xc,%edx
f0102312:	39 d1                	cmp    %edx,%ecx
f0102314:	74 24                	je     f010233a <_Z8mem_initv+0xac2>
f0102316:	c7 44 24 0c ac 83 10 	movl   $0xf01083ac,0xc(%esp)
f010231d:	f0 
f010231e:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102325:	f0 
f0102326:	c7 44 24 04 76 03 00 	movl   $0x376,0x4(%esp)
f010232d:	00 
f010232e:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102335:	e8 ee de ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010233a:	ba 00 00 00 00       	mov    $0x0,%edx
f010233f:	e8 93 ef ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102344:	89 fa                	mov    %edi,%edx
f0102346:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f010234c:	c1 fa 03             	sar    $0x3,%edx
f010234f:	c1 e2 0c             	shl    $0xc,%edx
f0102352:	39 d0                	cmp    %edx,%eax
f0102354:	74 24                	je     f010237a <_Z8mem_initv+0xb02>
f0102356:	c7 44 24 0c d4 83 10 	movl   $0xf01083d4,0xc(%esp)
f010235d:	f0 
f010235e:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102365:	f0 
f0102366:	c7 44 24 04 77 03 00 	movl   $0x377,0x4(%esp)
f010236d:	00 
f010236e:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102375:	e8 ae de ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp1->pp_ref == 1);
f010237a:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010237f:	74 24                	je     f01023a5 <_Z8mem_initv+0xb2d>
f0102381:	c7 44 24 0c 6d 8a 10 	movl   $0xf0108a6d,0xc(%esp)
f0102388:	f0 
f0102389:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102390:	f0 
f0102391:	c7 44 24 04 78 03 00 	movl   $0x378,0x4(%esp)
f0102398:	00 
f0102399:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01023a0:	e8 83 de ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp0->pp_ref == 1);
f01023a5:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01023aa:	74 24                	je     f01023d0 <_Z8mem_initv+0xb58>
f01023ac:	c7 44 24 0c 7e 8a 10 	movl   $0xf0108a7e,0xc(%esp)
f01023b3:	f0 
f01023b4:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01023bb:	f0 
f01023bc:	c7 44 24 04 79 03 00 	movl   $0x379,0x4(%esp)
f01023c3:	00 
f01023c4:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01023cb:	e8 58 de ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, PGSIZE, PTE_W) == 0);
f01023d0:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01023d7:	00 
f01023d8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01023df:	00 
f01023e0:	89 74 24 04          	mov    %esi,0x4(%esp)
f01023e4:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01023e9:	89 04 24             	mov    %eax,(%esp)
f01023ec:	e8 b7 f3 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f01023f1:	85 c0                	test   %eax,%eax
f01023f3:	74 24                	je     f0102419 <_Z8mem_initv+0xba1>
f01023f5:	c7 44 24 0c 04 84 10 	movl   $0xf0108404,0xc(%esp)
f01023fc:	f0 
f01023fd:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102404:	f0 
f0102405:	c7 44 24 04 7c 03 00 	movl   $0x37c,0x4(%esp)
f010240c:	00 
f010240d:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102414:	e8 0f de ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102419:	ba 00 10 00 00       	mov    $0x1000,%edx
f010241e:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102423:	e8 af ee ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102428:	89 f2                	mov    %esi,%edx
f010242a:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f0102430:	c1 fa 03             	sar    $0x3,%edx
f0102433:	c1 e2 0c             	shl    $0xc,%edx
f0102436:	39 d0                	cmp    %edx,%eax
f0102438:	74 24                	je     f010245e <_Z8mem_initv+0xbe6>
f010243a:	c7 44 24 0c 38 84 10 	movl   $0xf0108438,0xc(%esp)
f0102441:	f0 
f0102442:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102449:	f0 
f010244a:	c7 44 24 04 7d 03 00 	movl   $0x37d,0x4(%esp)
f0102451:	00 
f0102452:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102459:	e8 ca dd ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2->pp_ref == 1);
f010245e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102463:	74 24                	je     f0102489 <_Z8mem_initv+0xc11>
f0102465:	c7 44 24 0c 8f 8a 10 	movl   $0xf0108a8f,0xc(%esp)
f010246c:	f0 
f010246d:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102474:	f0 
f0102475:	c7 44 24 04 7e 03 00 	movl   $0x37e,0x4(%esp)
f010247c:	00 
f010247d:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102484:	e8 9f dd ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// should be no free memory
	assert(!page_alloc());
f0102489:	e8 fc ef ff ff       	call   f010148a <_Z10page_allocv>
f010248e:	85 c0                	test   %eax,%eax
f0102490:	74 24                	je     f01024b6 <_Z8mem_initv+0xc3e>
f0102492:	c7 44 24 0c 54 8a 10 	movl   $0xf0108a54,0xc(%esp)
f0102499:	f0 
f010249a:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01024a1:	f0 
f01024a2:	c7 44 24 04 81 03 00 	movl   $0x381,0x4(%esp)
f01024a9:	00 
f01024aa:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01024b1:	e8 72 dd ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, PGSIZE, PTE_W) == 0);
f01024b6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01024bd:	00 
f01024be:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01024c5:	00 
f01024c6:	89 74 24 04          	mov    %esi,0x4(%esp)
f01024ca:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01024cf:	89 04 24             	mov    %eax,(%esp)
f01024d2:	e8 d1 f2 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f01024d7:	85 c0                	test   %eax,%eax
f01024d9:	74 24                	je     f01024ff <_Z8mem_initv+0xc87>
f01024db:	c7 44 24 0c 04 84 10 	movl   $0xf0108404,0xc(%esp)
f01024e2:	f0 
f01024e3:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01024ea:	f0 
f01024eb:	c7 44 24 04 84 03 00 	movl   $0x384,0x4(%esp)
f01024f2:	00 
f01024f3:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01024fa:	e8 29 dd ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024ff:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102504:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102509:	e8 c9 ed ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f010250e:	89 f2                	mov    %esi,%edx
f0102510:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f0102516:	c1 fa 03             	sar    $0x3,%edx
f0102519:	c1 e2 0c             	shl    $0xc,%edx
f010251c:	39 d0                	cmp    %edx,%eax
f010251e:	74 24                	je     f0102544 <_Z8mem_initv+0xccc>
f0102520:	c7 44 24 0c 38 84 10 	movl   $0xf0108438,0xc(%esp)
f0102527:	f0 
f0102528:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010252f:	f0 
f0102530:	c7 44 24 04 85 03 00 	movl   $0x385,0x4(%esp)
f0102537:	00 
f0102538:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010253f:	e8 e4 dc ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2->pp_ref == 1);
f0102544:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102549:	74 24                	je     f010256f <_Z8mem_initv+0xcf7>
f010254b:	c7 44 24 0c 8f 8a 10 	movl   $0xf0108a8f,0xc(%esp)
f0102552:	f0 
f0102553:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010255a:	f0 
f010255b:	c7 44 24 04 86 03 00 	movl   $0x386,0x4(%esp)
f0102562:	00 
f0102563:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010256a:	e8 b9 dc ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc());
f010256f:	e8 16 ef ff ff       	call   f010148a <_Z10page_allocv>
f0102574:	85 c0                	test   %eax,%eax
f0102576:	74 24                	je     f010259c <_Z8mem_initv+0xd24>
f0102578:	c7 44 24 0c 54 8a 10 	movl   $0xf0108a54,0xc(%esp)
f010257f:	f0 
f0102580:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102587:	f0 
f0102588:	c7 44 24 04 8a 03 00 	movl   $0x38a,0x4(%esp)
f010258f:	00 
f0102590:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102597:	e8 8c dc ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f010259c:	8b 15 70 82 37 f0    	mov    0xf0378270,%edx
f01025a2:	8b 02                	mov    (%edx),%eax
f01025a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01025a9:	89 c1                	mov    %eax,%ecx
f01025ab:	c1 e9 0c             	shr    $0xc,%ecx
f01025ae:	3b 0d 6c 82 37 f0    	cmp    0xf037826c,%ecx
f01025b4:	72 20                	jb     f01025d6 <_Z8mem_initv+0xd5e>
f01025b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01025ba:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f01025c1:	f0 
f01025c2:	c7 44 24 04 8d 03 00 	movl   $0x38d,0x4(%esp)
f01025c9:	00 
f01025ca:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01025d1:	e8 52 dc ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f01025d6:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01025db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	assert(pgdir_walk(kern_pgdir, PGSIZE, false) == ptep+PTX(PGSIZE));
f01025de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01025e5:	00 
f01025e6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01025ed:	00 
f01025ee:	89 14 24             	mov    %edx,(%esp)
f01025f1:	e8 ed ee ff ff       	call   f01014e3 <_Z10pgdir_walkPjjb>
f01025f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01025f9:	83 c2 04             	add    $0x4,%edx
f01025fc:	39 d0                	cmp    %edx,%eax
f01025fe:	74 24                	je     f0102624 <_Z8mem_initv+0xdac>
f0102600:	c7 44 24 0c 68 84 10 	movl   $0xf0108468,0xc(%esp)
f0102607:	f0 
f0102608:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010260f:	f0 
f0102610:	c7 44 24 04 8e 03 00 	movl   $0x38e,0x4(%esp)
f0102617:	00 
f0102618:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010261f:	e8 04 dc ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, PGSIZE, PTE_W|PTE_U) == 0);
f0102624:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f010262b:	00 
f010262c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102633:	00 
f0102634:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102638:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f010263d:	89 04 24             	mov    %eax,(%esp)
f0102640:	e8 63 f1 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f0102645:	85 c0                	test   %eax,%eax
f0102647:	74 24                	je     f010266d <_Z8mem_initv+0xdf5>
f0102649:	c7 44 24 0c a4 84 10 	movl   $0xf01084a4,0xc(%esp)
f0102650:	f0 
f0102651:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102658:	f0 
f0102659:	c7 44 24 04 91 03 00 	movl   $0x391,0x4(%esp)
f0102660:	00 
f0102661:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102668:	e8 bb db ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010266d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102672:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102677:	e8 5b ec ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f010267c:	89 f2                	mov    %esi,%edx
f010267e:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f0102684:	c1 fa 03             	sar    $0x3,%edx
f0102687:	c1 e2 0c             	shl    $0xc,%edx
f010268a:	39 d0                	cmp    %edx,%eax
f010268c:	74 24                	je     f01026b2 <_Z8mem_initv+0xe3a>
f010268e:	c7 44 24 0c 38 84 10 	movl   $0xf0108438,0xc(%esp)
f0102695:	f0 
f0102696:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010269d:	f0 
f010269e:	c7 44 24 04 92 03 00 	movl   $0x392,0x4(%esp)
f01026a5:	00 
f01026a6:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01026ad:	e8 76 db ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2->pp_ref == 1);
f01026b2:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01026b7:	74 24                	je     f01026dd <_Z8mem_initv+0xe65>
f01026b9:	c7 44 24 0c 8f 8a 10 	movl   $0xf0108a8f,0xc(%esp)
f01026c0:	f0 
f01026c1:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01026c8:	f0 
f01026c9:	c7 44 24 04 93 03 00 	movl   $0x393,0x4(%esp)
f01026d0:	00 
f01026d1:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01026d8:	e8 4b db ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(*pgdir_walk(kern_pgdir, PGSIZE, false) & PTE_U);
f01026dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01026e4:	00 
f01026e5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01026ec:	00 
f01026ed:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01026f2:	89 04 24             	mov    %eax,(%esp)
f01026f5:	e8 e9 ed ff ff       	call   f01014e3 <_Z10pgdir_walkPjjb>
f01026fa:	f6 00 04             	testb  $0x4,(%eax)
f01026fd:	75 24                	jne    f0102723 <_Z8mem_initv+0xeab>
f01026ff:	c7 44 24 0c dc 84 10 	movl   $0xf01084dc,0xc(%esp)
f0102706:	f0 
f0102707:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010270e:	f0 
f010270f:	c7 44 24 04 94 03 00 	movl   $0x394,0x4(%esp)
f0102716:	00 
f0102717:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010271e:	e8 05 db ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(kern_pgdir[0] & PTE_U);
f0102723:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102728:	f6 00 04             	testb  $0x4,(%eax)
f010272b:	75 24                	jne    f0102751 <_Z8mem_initv+0xed9>
f010272d:	c7 44 24 0c a0 8a 10 	movl   $0xf0108aa0,0xc(%esp)
f0102734:	f0 
f0102735:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010273c:	f0 
f010273d:	c7 44 24 04 95 03 00 	movl   $0x395,0x4(%esp)
f0102744:	00 
f0102745:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010274c:	e8 d7 da ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, PTSIZE, PTE_W) < 0);
f0102751:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102758:	00 
f0102759:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f0102760:	00 
f0102761:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102765:	89 04 24             	mov    %eax,(%esp)
f0102768:	e8 3b f0 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f010276d:	85 c0                	test   %eax,%eax
f010276f:	78 24                	js     f0102795 <_Z8mem_initv+0xf1d>
f0102771:	c7 44 24 0c 0c 85 10 	movl   $0xf010850c,0xc(%esp)
f0102778:	f0 
f0102779:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102780:	f0 
f0102781:	c7 44 24 04 98 03 00 	movl   $0x398,0x4(%esp)
f0102788:	00 
f0102789:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102790:	e8 93 da ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, PGSIZE, PTE_W) == 0);
f0102795:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010279c:	00 
f010279d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01027a4:	00 
f01027a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01027a9:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01027ae:	89 04 24             	mov    %eax,(%esp)
f01027b1:	e8 f2 ef ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f01027b6:	85 c0                	test   %eax,%eax
f01027b8:	74 24                	je     f01027de <_Z8mem_initv+0xf66>
f01027ba:	c7 44 24 0c 3c 85 10 	movl   $0xf010853c,0xc(%esp)
f01027c1:	f0 
f01027c2:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01027c9:	f0 
f01027ca:	c7 44 24 04 9b 03 00 	movl   $0x39b,0x4(%esp)
f01027d1:	00 
f01027d2:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01027d9:	e8 4a da ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(!(*pgdir_walk(kern_pgdir, PGSIZE, false) & PTE_U));
f01027de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01027e5:	00 
f01027e6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01027ed:	00 
f01027ee:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01027f3:	89 04 24             	mov    %eax,(%esp)
f01027f6:	e8 e8 ec ff ff       	call   f01014e3 <_Z10pgdir_walkPjjb>
f01027fb:	f6 00 04             	testb  $0x4,(%eax)
f01027fe:	74 24                	je     f0102824 <_Z8mem_initv+0xfac>
f0102800:	c7 44 24 0c 70 85 10 	movl   $0xf0108570,0xc(%esp)
f0102807:	f0 
f0102808:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010280f:	f0 
f0102810:	c7 44 24 04 9c 03 00 	movl   $0x39c,0x4(%esp)
f0102817:	00 
f0102818:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010281f:	e8 04 da ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102824:	ba 00 00 00 00       	mov    $0x0,%edx
f0102829:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f010282e:	e8 a4 ea ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102833:	89 fa                	mov    %edi,%edx
f0102835:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f010283b:	c1 fa 03             	sar    $0x3,%edx
f010283e:	c1 e2 0c             	shl    $0xc,%edx
f0102841:	39 d0                	cmp    %edx,%eax
f0102843:	74 24                	je     f0102869 <_Z8mem_initv+0xff1>
f0102845:	c7 44 24 0c a4 85 10 	movl   $0xf01085a4,0xc(%esp)
f010284c:	f0 
f010284d:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102854:	f0 
f0102855:	c7 44 24 04 9f 03 00 	movl   $0x39f,0x4(%esp)
f010285c:	00 
f010285d:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102864:	e8 bf d9 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102869:	ba 00 10 00 00       	mov    $0x1000,%edx
f010286e:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102873:	e8 5f ea ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102878:	89 fa                	mov    %edi,%edx
f010287a:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f0102880:	c1 fa 03             	sar    $0x3,%edx
f0102883:	c1 e2 0c             	shl    $0xc,%edx
f0102886:	39 d0                	cmp    %edx,%eax
f0102888:	74 24                	je     f01028ae <_Z8mem_initv+0x1036>
f010288a:	c7 44 24 0c d0 85 10 	movl   $0xf01085d0,0xc(%esp)
f0102891:	f0 
f0102892:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102899:	f0 
f010289a:	c7 44 24 04 a0 03 00 	movl   $0x3a0,0x4(%esp)
f01028a1:	00 
f01028a2:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01028a9:	e8 7a d9 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01028ae:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f01028b3:	74 24                	je     f01028d9 <_Z8mem_initv+0x1061>
f01028b5:	c7 44 24 0c b6 8a 10 	movl   $0xf0108ab6,0xc(%esp)
f01028bc:	f0 
f01028bd:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01028c4:	f0 
f01028c5:	c7 44 24 04 a2 03 00 	movl   $0x3a2,0x4(%esp)
f01028cc:	00 
f01028cd:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01028d4:	e8 4f d9 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2->pp_ref == 0);
f01028d9:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01028de:	74 24                	je     f0102904 <_Z8mem_initv+0x108c>
f01028e0:	c7 44 24 0c c7 8a 10 	movl   $0xf0108ac7,0xc(%esp)
f01028e7:	f0 
f01028e8:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01028ef:	f0 
f01028f0:	c7 44 24 04 a3 03 00 	movl   $0x3a3,0x4(%esp)
f01028f7:	00 
f01028f8:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01028ff:	e8 24 d9 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc()) && pp == pp2);
f0102904:	e8 81 eb ff ff       	call   f010148a <_Z10page_allocv>
f0102909:	85 c0                	test   %eax,%eax
f010290b:	74 05                	je     f0102912 <_Z8mem_initv+0x109a>
f010290d:	39 c6                	cmp    %eax,%esi
f010290f:	90                   	nop
f0102910:	74 24                	je     f0102936 <_Z8mem_initv+0x10be>
f0102912:	c7 44 24 0c 00 86 10 	movl   $0xf0108600,0xc(%esp)
f0102919:	f0 
f010291a:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102921:	f0 
f0102922:	c7 44 24 04 a6 03 00 	movl   $0x3a6,0x4(%esp)
f0102929:	00 
f010292a:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102931:	e8 f2 d8 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0102936:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010293d:	00 
f010293e:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102943:	89 04 24             	mov    %eax,(%esp)
f0102946:	e8 0d ee ff ff       	call   f0101758 <_Z11page_removePjj>
	assert(check_va2pa(kern_pgdir, 0x0) == (physaddr_t) ~0);
f010294b:	ba 00 00 00 00       	mov    $0x0,%edx
f0102950:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102955:	e8 7d e9 ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f010295a:	83 f8 ff             	cmp    $0xffffffff,%eax
f010295d:	74 24                	je     f0102983 <_Z8mem_initv+0x110b>
f010295f:	c7 44 24 0c 24 86 10 	movl   $0xf0108624,0xc(%esp)
f0102966:	f0 
f0102967:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010296e:	f0 
f010296f:	c7 44 24 04 aa 03 00 	movl   $0x3aa,0x4(%esp)
f0102976:	00 
f0102977:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010297e:	e8 a5 d8 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102983:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102988:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f010298d:	e8 45 e9 ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102992:	89 fa                	mov    %edi,%edx
f0102994:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f010299a:	c1 fa 03             	sar    $0x3,%edx
f010299d:	c1 e2 0c             	shl    $0xc,%edx
f01029a0:	39 d0                	cmp    %edx,%eax
f01029a2:	74 24                	je     f01029c8 <_Z8mem_initv+0x1150>
f01029a4:	c7 44 24 0c d0 85 10 	movl   $0xf01085d0,0xc(%esp)
f01029ab:	f0 
f01029ac:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01029b3:	f0 
f01029b4:	c7 44 24 04 ab 03 00 	movl   $0x3ab,0x4(%esp)
f01029bb:	00 
f01029bc:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01029c3:	e8 60 d8 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp1->pp_ref == 1);
f01029c8:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f01029cd:	74 24                	je     f01029f3 <_Z8mem_initv+0x117b>
f01029cf:	c7 44 24 0c 6d 8a 10 	movl   $0xf0108a6d,0xc(%esp)
f01029d6:	f0 
f01029d7:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01029de:	f0 
f01029df:	c7 44 24 04 ac 03 00 	movl   $0x3ac,0x4(%esp)
f01029e6:	00 
f01029e7:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01029ee:	e8 35 d8 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2->pp_ref == 0);
f01029f3:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01029f8:	74 24                	je     f0102a1e <_Z8mem_initv+0x11a6>
f01029fa:	c7 44 24 0c c7 8a 10 	movl   $0xf0108ac7,0xc(%esp)
f0102a01:	f0 
f0102a02:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102a09:	f0 
f0102a0a:	c7 44 24 04 ad 03 00 	movl   $0x3ad,0x4(%esp)
f0102a11:	00 
f0102a12:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102a19:	e8 0a d8 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, PGSIZE);
f0102a1e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102a25:	00 
f0102a26:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102a2b:	89 04 24             	mov    %eax,(%esp)
f0102a2e:	e8 25 ed ff ff       	call   f0101758 <_Z11page_removePjj>
	assert(check_va2pa(kern_pgdir, 0x0) == (physaddr_t) ~0);
f0102a33:	ba 00 00 00 00       	mov    $0x0,%edx
f0102a38:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102a3d:	e8 95 e8 ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102a42:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a45:	74 24                	je     f0102a6b <_Z8mem_initv+0x11f3>
f0102a47:	c7 44 24 0c 24 86 10 	movl   $0xf0108624,0xc(%esp)
f0102a4e:	f0 
f0102a4f:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102a56:	f0 
f0102a57:	c7 44 24 04 b1 03 00 	movl   $0x3b1,0x4(%esp)
f0102a5e:	00 
f0102a5f:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102a66:	e8 bd d7 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(check_va2pa(kern_pgdir, PGSIZE) == (physaddr_t) ~0);
f0102a6b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102a70:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102a75:	e8 5d e8 ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102a7a:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a7d:	74 24                	je     f0102aa3 <_Z8mem_initv+0x122b>
f0102a7f:	c7 44 24 0c 54 86 10 	movl   $0xf0108654,0xc(%esp)
f0102a86:	f0 
f0102a87:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102a8e:	f0 
f0102a8f:	c7 44 24 04 b2 03 00 	movl   $0x3b2,0x4(%esp)
f0102a96:	00 
f0102a97:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102a9e:	e8 85 d7 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp1->pp_ref == 0);
f0102aa3:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102aa8:	74 24                	je     f0102ace <_Z8mem_initv+0x1256>
f0102aaa:	c7 44 24 0c d8 8a 10 	movl   $0xf0108ad8,0xc(%esp)
f0102ab1:	f0 
f0102ab2:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102ab9:	f0 
f0102aba:	c7 44 24 04 b3 03 00 	movl   $0x3b3,0x4(%esp)
f0102ac1:	00 
f0102ac2:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102ac9:	e8 5a d7 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2->pp_ref == 0);
f0102ace:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102ad3:	74 24                	je     f0102af9 <_Z8mem_initv+0x1281>
f0102ad5:	c7 44 24 0c c7 8a 10 	movl   $0xf0108ac7,0xc(%esp)
f0102adc:	f0 
f0102add:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102ae4:	f0 
f0102ae5:	c7 44 24 04 b4 03 00 	movl   $0x3b4,0x4(%esp)
f0102aec:	00 
f0102aed:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102af4:	e8 2f d7 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// so it should be returned by page_alloc
	assert((pp = page_alloc()) && pp == pp1);
f0102af9:	e8 8c e9 ff ff       	call   f010148a <_Z10page_allocv>
f0102afe:	85 c0                	test   %eax,%eax
f0102b00:	74 04                	je     f0102b06 <_Z8mem_initv+0x128e>
f0102b02:	39 c7                	cmp    %eax,%edi
f0102b04:	74 24                	je     f0102b2a <_Z8mem_initv+0x12b2>
f0102b06:	c7 44 24 0c 88 86 10 	movl   $0xf0108688,0xc(%esp)
f0102b0d:	f0 
f0102b0e:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102b15:	f0 
f0102b16:	c7 44 24 04 b7 03 00 	movl   $0x3b7,0x4(%esp)
f0102b1d:	00 
f0102b1e:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102b25:	e8 fe d6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// should be no free memory
	assert(!page_alloc());
f0102b2a:	e8 5b e9 ff ff       	call   f010148a <_Z10page_allocv>
f0102b2f:	85 c0                	test   %eax,%eax
f0102b31:	74 24                	je     f0102b57 <_Z8mem_initv+0x12df>
f0102b33:	c7 44 24 0c 54 8a 10 	movl   $0xf0108a54,0xc(%esp)
f0102b3a:	f0 
f0102b3b:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102b42:	f0 
f0102b43:	c7 44 24 04 ba 03 00 	movl   $0x3ba,0x4(%esp)
f0102b4a:	00 
f0102b4b:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102b52:	e8 d1 d6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b57:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102b5c:	8b 08                	mov    (%eax),%ecx
f0102b5e:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102b64:	89 da                	mov    %ebx,%edx
f0102b66:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f0102b6c:	c1 fa 03             	sar    $0x3,%edx
f0102b6f:	c1 e2 0c             	shl    $0xc,%edx
f0102b72:	39 d1                	cmp    %edx,%ecx
f0102b74:	74 24                	je     f0102b9a <_Z8mem_initv+0x1322>
f0102b76:	c7 44 24 0c ac 83 10 	movl   $0xf01083ac,0xc(%esp)
f0102b7d:	f0 
f0102b7e:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102b85:	f0 
f0102b86:	c7 44 24 04 bd 03 00 	movl   $0x3bd,0x4(%esp)
f0102b8d:	00 
f0102b8e:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102b95:	e8 8e d6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	kern_pgdir[0] = 0;
f0102b9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0102ba0:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102ba5:	74 24                	je     f0102bcb <_Z8mem_initv+0x1353>
f0102ba7:	c7 44 24 0c 7e 8a 10 	movl   $0xf0108a7e,0xc(%esp)
f0102bae:	f0 
f0102baf:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102bb6:	f0 
f0102bb7:	c7 44 24 04 bf 03 00 	movl   $0x3bf,0x4(%esp)
f0102bbe:	00 
f0102bbf:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102bc6:	e8 5d d6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	pp0->pp_ref = 0;
f0102bcb:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102bd1:	89 1c 24             	mov    %ebx,(%esp)
f0102bd4:	e8 c7 e8 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	va = PGSIZE * NPDENTRIES + PGSIZE;
	ptep = pgdir_walk(kern_pgdir, va, true);
f0102bd9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102be0:	00 
f0102be1:	c7 44 24 04 00 10 40 	movl   $0x401000,0x4(%esp)
f0102be8:	00 
f0102be9:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102bee:	89 04 24             	mov    %eax,(%esp)
f0102bf1:	e8 ed e8 ff ff       	call   f01014e3 <_Z10pgdir_walkPjjb>
f0102bf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102bf9:	8b 0d 70 82 37 f0    	mov    0xf0378270,%ecx
f0102bff:	8b 51 04             	mov    0x4(%ecx),%edx
f0102c02:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102c08:	89 55 cc             	mov    %edx,-0x34(%ebp)
f0102c0b:	c1 ea 0c             	shr    $0xc,%edx
f0102c0e:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f0102c14:	72 23                	jb     f0102c39 <_Z8mem_initv+0x13c1>
f0102c16:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102c19:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0102c1d:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0102c24:	f0 
f0102c25:	c7 44 24 04 c6 03 00 	movl   $0x3c6,0x4(%esp)
f0102c2c:	00 
f0102c2d:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102c34:	e8 ef d5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(ptep == ptep1 + PTX(va));
f0102c39:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0102c3c:	81 ea fc ff ff 0f    	sub    $0xffffffc,%edx
f0102c42:	39 d0                	cmp    %edx,%eax
f0102c44:	74 24                	je     f0102c6a <_Z8mem_initv+0x13f2>
f0102c46:	c7 44 24 0c e9 8a 10 	movl   $0xf0108ae9,0xc(%esp)
f0102c4d:	f0 
f0102c4e:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102c55:	f0 
f0102c56:	c7 44 24 04 c7 03 00 	movl   $0x3c7,0x4(%esp)
f0102c5d:	00 
f0102c5e:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102c65:	e8 be d5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	kern_pgdir[PDX(va)] = 0;
f0102c6a:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
	pp0->pp_ref = 0;
f0102c71:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
f0102c77:	89 d8                	mov    %ebx,%eax
f0102c79:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f0102c7f:	c1 f8 03             	sar    $0x3,%eax
f0102c82:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0102c85:	89 c2                	mov    %eax,%edx
f0102c87:	c1 ea 0c             	shr    $0xc,%edx
f0102c8a:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f0102c90:	72 20                	jb     f0102cb2 <_Z8mem_initv+0x143a>
f0102c92:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102c96:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0102c9d:	f0 
f0102c9e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0102ca5:	00 
f0102ca6:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0102cad:	e8 76 d5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102cb2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102cb9:	00 
f0102cba:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f0102cc1:	00 
f0102cc2:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102cc7:	89 04 24             	mov    %eax,(%esp)
f0102cca:	e8 32 3a 00 00       	call   f0106701 <memset>
	page_free(pp0);
f0102ccf:	89 1c 24             	mov    %ebx,(%esp)
f0102cd2:	e8 c9 e7 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	pgdir_walk(kern_pgdir, 0x0, true);
f0102cd7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102cde:	00 
f0102cdf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102ce6:	00 
f0102ce7:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102cec:	89 04 24             	mov    %eax,(%esp)
f0102cef:	e8 ef e7 ff ff       	call   f01014e3 <_Z10pgdir_walkPjjb>
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f0102cf4:	89 da                	mov    %ebx,%edx
f0102cf6:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f0102cfc:	c1 fa 03             	sar    $0x3,%edx
f0102cff:	c1 e2 0c             	shl    $0xc,%edx
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0102d02:	89 d0                	mov    %edx,%eax
f0102d04:	c1 e8 0c             	shr    $0xc,%eax
f0102d07:	3b 05 6c 82 37 f0    	cmp    0xf037826c,%eax
f0102d0d:	72 20                	jb     f0102d2f <_Z8mem_initv+0x14b7>
f0102d0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0102d13:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0102d1a:	f0 
f0102d1b:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0102d22:	00 
f0102d23:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0102d2a:	e8 f9 d4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0102d2f:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102d35:	89 45 e0             	mov    %eax,-0x20(%ebp)
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102d38:	f6 82 00 00 00 f0 01 	testb  $0x1,-0x10000000(%edx)
f0102d3f:	75 11                	jne    f0102d52 <_Z8mem_initv+0x14da>
f0102d41:	8d 82 04 00 00 f0    	lea    -0xffffffc(%edx),%eax
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0102d47:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, true);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102d4d:	f6 00 01             	testb  $0x1,(%eax)
f0102d50:	74 24                	je     f0102d76 <_Z8mem_initv+0x14fe>
f0102d52:	c7 44 24 0c 01 8b 10 	movl   $0xf0108b01,0xc(%esp)
f0102d59:	f0 
f0102d5a:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102d61:	f0 
f0102d62:	c7 44 24 04 d1 03 00 	movl   $0x3d1,0x4(%esp)
f0102d69:	00 
f0102d6a:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102d71:	e8 b2 d4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0102d76:	83 c0 04             	add    $0x4,%eax
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, true);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f0102d79:	39 d0                	cmp    %edx,%eax
f0102d7b:	75 d0                	jne    f0102d4d <_Z8mem_initv+0x14d5>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f0102d7d:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102d88:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// give free list back
	page_free_list = fl;
f0102d8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d91:	a3 7c 82 37 f0       	mov    %eax,0xf037827c

	// free the pages we took
	page_free(pp0);
f0102d96:	89 1c 24             	mov    %ebx,(%esp)
f0102d99:	e8 02 e7 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	page_free(pp1);
f0102d9e:	89 3c 24             	mov    %edi,(%esp)
f0102da1:	e8 fa e6 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
	page_free(pp2);
f0102da6:	89 34 24             	mov    %esi,(%esp)
f0102da9:	e8 f2 e6 ff ff       	call   f01014a0 <_Z9page_freeP4Page>

	cprintf("check_page() succeeded!\n");
f0102dae:	c7 04 24 18 8b 10 f0 	movl   $0xf0108b18,(%esp)
f0102db5:	e8 f8 12 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	//     * [KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE) -- not backed; so if
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE

    page_map_segment(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(entry_stack), PTE_W);
f0102dba:	bb 00 00 12 f0       	mov    $0xf0120000,%ebx
f0102dbf:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102dc5:	77 20                	ja     f0102de7 <_Z8mem_initv+0x156f>
f0102dc7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0102dcb:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0102dd2:	f0 
f0102dd3:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
f0102dda:	00 
f0102ddb:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102de2:	e8 41 d4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0102de7:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
f0102dee:	00 
f0102def:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
f0102df6:	00 
f0102df7:	c7 44 24 0c 00 00 12 	movl   $0x120000,0xc(%esp)
f0102dfe:	00 
f0102dff:	c7 44 24 08 00 80 00 	movl   $0x8000,0x8(%esp)
f0102e06:	00 
f0102e07:	c7 44 24 04 00 80 ff 	movl   $0xefff8000,0x4(%esp)
f0102e0e:	ef 
f0102e0f:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102e14:	89 04 24             	mov    %eax,(%esp)
f0102e17:	e8 dd e7 ff ff       	call   f01015f9 <_Z16page_map_segmentPjjjjib>

static __inline uint32_t
rcr4(void)
{
	uint32_t cr4;
	__asm __volatile("movl %%cr4,%0" : "=r" (cr4));
f0102e1c:	0f 20 e0             	mov    %cr4,%eax
    
   
    // Enable PSE
    lcr4(rcr4() | 0x10);
f0102e1f:	83 c8 10             	or     $0x10,%eax
}

static __inline void
lcr4(uint32_t val)
{
	__asm __volatile("movl %0,%%cr4" : : "r" (val));
f0102e22:	0f 22 e0             	mov    %eax,%cr4
	//////////////////////////////////////////////////////////////////////
	// Map the 'envs' array read-only by the user at linear address UENVS.
	// Permissions: kernel R, user R
	// (That's the UENVS version; 'envs' itself is kernel RW, user NONE.)
	// LAB 3: Your code here.
    page_map_segment(kern_pgdir, UENVS, sizeof(Env) * NENV, PADDR(envs), PTE_U);
f0102e25:	a1 88 82 37 f0       	mov    0xf0378288,%eax
f0102e2a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102e2f:	77 20                	ja     f0102e51 <_Z8mem_initv+0x15d9>
f0102e31:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102e35:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0102e3c:	f0 
f0102e3d:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
f0102e44:	00 
f0102e45:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102e4c:	e8 d7 d3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0102e51:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
f0102e58:	00 
f0102e59:	c7 44 24 10 04 00 00 	movl   $0x4,0x10(%esp)
f0102e60:	00 
f0102e61:	05 00 00 00 10       	add    $0x10000000,%eax
f0102e66:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102e6a:	c7 44 24 08 00 e0 01 	movl   $0x1e000,0x8(%esp)
f0102e71:	00 
f0102e72:	c7 44 24 04 00 00 00 	movl   $0xef000000,0x4(%esp)
f0102e79:	ef 
f0102e7a:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102e7f:	89 04 24             	mov    %eax,(%esp)
f0102e82:	e8 72 e7 ff ff       	call   f01015f9 <_Z16page_map_segmentPjjjjib>
	//////////////////////////////////////////////////////////////////////
	// Map 'pages' read-only by the user at linear address UPAGES.
	// Permissions: kernel R, user R
	// (That's the UPAGES version; 'pages' itself is kernel RW, user NONE.)
	// LAB 3: Your code here.
    page_map_segment(kern_pgdir, UPAGES, sizeof(Page) * npages, PADDR(pages), PTE_U); 
f0102e87:	a1 74 82 37 f0       	mov    0xf0378274,%eax
f0102e8c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102e91:	77 20                	ja     f0102eb3 <_Z8mem_initv+0x163b>
f0102e93:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102e97:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0102e9e:	f0 
f0102e9f:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
f0102ea6:	00 
f0102ea7:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102eae:	e8 75 d3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0102eb3:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
f0102eba:	00 
f0102ebb:	c7 44 24 10 04 00 00 	movl   $0x4,0x10(%esp)
f0102ec2:	00 
f0102ec3:	05 00 00 00 10       	add    $0x10000000,%eax
f0102ec8:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102ecc:	a1 6c 82 37 f0       	mov    0xf037826c,%eax
f0102ed1:	c1 e0 03             	shl    $0x3,%eax
f0102ed4:	89 44 24 08          	mov    %eax,0x8(%esp)
f0102ed8:	c7 44 24 04 00 00 40 	movl   $0xef400000,0x4(%esp)
f0102edf:	ef 
f0102ee0:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102ee5:	89 04 24             	mov    %eax,(%esp)
f0102ee8:	e8 0c e7 ff ff       	call   f01015f9 <_Z16page_map_segmentPjjjjib>
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
  
    // XXX: If you want to enable 4MB pages, you have to comment out
    // check_kern_pgdir, since it checks the PTE entry (which we don't have)
    page_map_segment(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W/*, 1*/); 
f0102eed:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
f0102ef4:	00 
f0102ef5:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
f0102efc:	00 
f0102efd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0102f04:	00 
f0102f05:	c7 44 24 08 ff ff ff 	movl   $0xfffffff,0x8(%esp)
f0102f0c:	0f 
f0102f0d:	c7 44 24 04 00 00 00 	movl   $0xf0000000,0x4(%esp)
f0102f14:	f0 
f0102f15:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0102f1a:	89 04 24             	mov    %eax,(%esp)
f0102f1d:	e8 d7 e6 ff ff       	call   f01015f9 <_Z16page_map_segmentPjjjjib>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f0102f22:	8b 35 70 82 37 f0    	mov    0xf0378270,%esi

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f28:	bf 00 00 00 00       	mov    $0x0,%edi
f0102f2d:	eb 3b                	jmp    f0102f6a <_Z8mem_initv+0x16f2>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102f2f:	8d 97 00 00 00 f0    	lea    -0x10000000(%edi),%edx
f0102f35:	89 f0                	mov    %esi,%eax
f0102f37:	e8 9b e3 ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102f3c:	39 c7                	cmp    %eax,%edi
f0102f3e:	74 24                	je     f0102f64 <_Z8mem_initv+0x16ec>
f0102f40:	c7 44 24 0c ac 86 10 	movl   $0xf01086ac,0xc(%esp)
f0102f47:	f0 
f0102f48:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102f4f:	f0 
f0102f50:	c7 44 24 04 17 03 00 	movl   $0x317,0x4(%esp)
f0102f57:	00 
f0102f58:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102f5f:	e8 c4 d2 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	pde_t *pgdir;

	pgdir = kern_pgdir;

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102f64:	81 c7 00 10 00 00    	add    $0x1000,%edi
f0102f6a:	a1 6c 82 37 f0       	mov    0xf037826c,%eax
f0102f6f:	c1 e0 0c             	shl    $0xc,%eax
f0102f72:	39 c7                	cmp    %eax,%edi
f0102f74:	72 b9                	jb     f0102f2f <_Z8mem_initv+0x16b7>
f0102f76:	bf 00 80 ff ef       	mov    $0xefff8000,%edi
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0102f7b:	81 c3 00 80 00 20    	add    $0x20008000,%ebx
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(entry_stack) + i);
f0102f81:	89 fa                	mov    %edi,%edx
f0102f83:	89 f0                	mov    %esi,%eax
f0102f85:	e8 4d e3 ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102f8a:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
f0102f8d:	39 d0                	cmp    %edx,%eax
f0102f8f:	74 24                	je     f0102fb5 <_Z8mem_initv+0x173d>
f0102f91:	c7 44 24 0c d4 86 10 	movl   $0xf01086d4,0xc(%esp)
f0102f98:	f0 
f0102f99:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102fa0:	f0 
f0102fa1:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
f0102fa8:	00 
f0102fa9:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102fb0:	e8 73 d2 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0102fb5:	81 c7 00 10 00 00    	add    $0x1000,%edi
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102fbb:	81 ff 00 00 00 f0    	cmp    $0xf0000000,%edi
f0102fc1:	75 be                	jne    f0102f81 <_Z8mem_initv+0x1709>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(entry_stack) + i);
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == (physaddr_t) ~0);
f0102fc3:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f0102fc8:	89 f0                	mov    %esi,%eax
f0102fca:	e8 08 e3 ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f0102fcf:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102fd2:	74 24                	je     f0102ff8 <_Z8mem_initv+0x1780>
f0102fd4:	c7 44 24 0c 1c 87 10 	movl   $0xf010871c,0xc(%esp)
f0102fdb:	f0 
f0102fdc:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0102fe3:	f0 
f0102fe4:	c7 44 24 04 1c 03 00 	movl   $0x31c,0x4(%esp)
f0102feb:	00 
f0102fec:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0102ff3:	e8 30 d2 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
		case PDX(UPAGES):
		case PDX(UENVS):
			assert(pgdir[i]);
			break;
		default:
			if (i >= PDX(KERNBASE + npages * PGSIZE))
f0102ff8:	8b 15 6c 82 37 f0    	mov    0xf037826c,%edx
f0102ffe:	8d 8a 00 00 0f 00    	lea    0xf0000(%edx),%ecx
f0103004:	c1 e1 0c             	shl    $0xc,%ecx
f0103007:	c1 e9 16             	shr    $0x16,%ecx
f010300a:	b8 00 00 00 00       	mov    $0x0,%eax
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(entry_stack) + i);
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == (physaddr_t) ~0);

	// check for zero/non-zero in PDEs
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f010300f:	8d 98 44 fc ff ff    	lea    -0x3bc(%eax),%ebx
f0103015:	83 fb 03             	cmp    $0x3,%ebx
f0103018:	77 2e                	ja     f0103048 <_Z8mem_initv+0x17d0>
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
			assert(pgdir[i]);
f010301a:	83 3c 86 00          	cmpl   $0x0,(%esi,%eax,4)
f010301e:	0f 85 83 00 00 00    	jne    f01030a7 <_Z8mem_initv+0x182f>
f0103024:	c7 44 24 0c 31 8b 10 	movl   $0xf0108b31,0xc(%esp)
f010302b:	f0 
f010302c:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103033:	f0 
f0103034:	c7 44 24 04 25 03 00 	movl   $0x325,0x4(%esp)
f010303b:	00 
f010303c:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103043:	e8 e0 d1 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
			break;
		default:
			if (i >= PDX(KERNBASE + npages * PGSIZE))
f0103048:	39 c8                	cmp    %ecx,%eax
f010304a:	73 5b                	jae    f01030a7 <_Z8mem_initv+0x182f>
				/* either way is OK */;
			else if (i >= PDX(KERNBASE))
f010304c:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0103051:	76 2a                	jbe    f010307d <_Z8mem_initv+0x1805>
				assert(pgdir[i]);
f0103053:	83 3c 86 00          	cmpl   $0x0,(%esi,%eax,4)
f0103057:	75 4e                	jne    f01030a7 <_Z8mem_initv+0x182f>
f0103059:	c7 44 24 0c 31 8b 10 	movl   $0xf0108b31,0xc(%esp)
f0103060:	f0 
f0103061:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103068:	f0 
f0103069:	c7 44 24 04 2b 03 00 	movl   $0x32b,0x4(%esp)
f0103070:	00 
f0103071:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103078:	e8 ab d1 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
			else
				assert(pgdir[i] == 0);
f010307d:	83 3c 86 00          	cmpl   $0x0,(%esi,%eax,4)
f0103081:	74 24                	je     f01030a7 <_Z8mem_initv+0x182f>
f0103083:	c7 44 24 0c 3a 8b 10 	movl   $0xf0108b3a,0xc(%esp)
f010308a:	f0 
f010308b:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103092:	f0 
f0103093:	c7 44 24 04 2d 03 00 	movl   $0x32d,0x4(%esp)
f010309a:	00 
f010309b:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01030a2:	e8 81 d1 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(entry_stack) + i);
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == (physaddr_t) ~0);

	// check for zero/non-zero in PDEs
	for (i = 0; i < NPDENTRIES; i++) {
f01030a7:	83 c0 01             	add    $0x1,%eax
f01030aa:	3d 00 04 00 00       	cmp    $0x400,%eax
f01030af:	0f 85 5a ff ff ff    	jne    f010300f <_Z8mem_initv+0x1797>
			break;
		}
	}

	// check pages array
	n = ROUNDUP(npages*sizeof(struct Page), PGSIZE);
f01030b5:	8d 3c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%edi
f01030bc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	for (i = 0; i < n; i += PGSIZE)
f01030c2:	bb 00 00 00 00       	mov    $0x0,%ebx
f01030c7:	eb 70                	jmp    f0103139 <_Z8mem_initv+0x18c1>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01030c9:	8d 93 00 00 40 ef    	lea    -0x10c00000(%ebx),%edx
f01030cf:	89 f0                	mov    %esi,%eax
f01030d1:	e8 01 e2 ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f01030d6:	8b 15 74 82 37 f0    	mov    0xf0378274,%edx
f01030dc:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01030e2:	77 20                	ja     f0103104 <_Z8mem_initv+0x188c>
f01030e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01030e8:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f01030ef:	f0 
f01030f0:	c7 44 24 04 35 03 00 	movl   $0x335,0x4(%esp)
f01030f7:	00 
f01030f8:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01030ff:	e8 24 d1 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0103104:	8d 94 1a 00 00 00 10 	lea    0x10000000(%edx,%ebx,1),%edx
f010310b:	39 d0                	cmp    %edx,%eax
f010310d:	74 24                	je     f0103133 <_Z8mem_initv+0x18bb>
f010310f:	c7 44 24 0c 58 87 10 	movl   $0xf0108758,0xc(%esp)
f0103116:	f0 
f0103117:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010311e:	f0 
f010311f:	c7 44 24 04 35 03 00 	movl   $0x335,0x4(%esp)
f0103126:	00 
f0103127:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010312e:	e8 f5 d0 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
		}
	}

	// check pages array
	n = ROUNDUP(npages*sizeof(struct Page), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0103133:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103139:	39 df                	cmp    %ebx,%edi
f010313b:	77 8c                	ja     f01030c9 <_Z8mem_initv+0x1851>
f010313d:	bb 00 00 00 00       	mov    $0x0,%ebx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0103142:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0103148:	89 f0                	mov    %esi,%eax
f010314a:	e8 88 e1 ff ff       	call   f01012d7 <_ZL11check_va2paPjj>
f010314f:	8b 15 88 82 37 f0    	mov    0xf0378288,%edx
f0103155:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010315b:	77 20                	ja     f010317d <_Z8mem_initv+0x1905>
f010315d:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103161:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0103168:	f0 
f0103169:	c7 44 24 04 3a 03 00 	movl   $0x33a,0x4(%esp)
f0103170:	00 
f0103171:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103178:	e8 ab d0 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f010317d:	8d 94 1a 00 00 00 10 	lea    0x10000000(%edx,%ebx,1),%edx
f0103184:	39 d0                	cmp    %edx,%eax
f0103186:	74 24                	je     f01031ac <_Z8mem_initv+0x1934>
f0103188:	c7 44 24 0c 8c 87 10 	movl   $0xf010878c,0xc(%esp)
f010318f:	f0 
f0103190:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103197:	f0 
f0103198:	c7 44 24 04 3a 03 00 	movl   $0x33a,0x4(%esp)
f010319f:	00 
f01031a0:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01031a7:	e8 7c d0 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f01031ac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01031b2:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
f01031b8:	75 88                	jne    f0103142 <_Z8mem_initv+0x18ca>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	cprintf("check_kern_pgdir() succeeded!\n");
f01031ba:	c7 04 24 c0 87 10 f0 	movl   $0xf01087c0,(%esp)
f01031c1:	e8 ec 0e 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f01031c6:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01031cb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01031d0:	77 20                	ja     f01031f2 <_Z8mem_initv+0x197a>
f01031d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01031d6:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f01031dd:	f0 
f01031de:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
f01031e5:	00 
f01031e6:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01031ed:	e8 36 d0 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f01031f2:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f01031f7:	0f 22 d8             	mov    %eax,%cr3

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f01031fa:	0f 20 c0             	mov    %cr0,%eax

    // entry.S set the really important flags in cr0 (including enabling
    // paging).  Here we configure the rest of the flags we need.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
f01031fd:	0d 23 00 05 80       	or     $0x80050023,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0103202:	83 e0 f3             	and    $0xfffffff3,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0103205:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc()));
f0103208:	e8 7d e2 ff ff       	call   f010148a <_Z10page_allocv>
f010320d:	89 c6                	mov    %eax,%esi
f010320f:	85 c0                	test   %eax,%eax
f0103211:	75 24                	jne    f0103237 <_Z8mem_initv+0x19bf>
f0103213:	c7 44 24 0c ac 89 10 	movl   $0xf01089ac,0xc(%esp)
f010321a:	f0 
f010321b:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103222:	f0 
f0103223:	c7 44 24 04 ec 03 00 	movl   $0x3ec,0x4(%esp)
f010322a:	00 
f010322b:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103232:	e8 f1 cf ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert((pp1 = page_alloc()));
f0103237:	e8 4e e2 ff ff       	call   f010148a <_Z10page_allocv>
f010323c:	89 c7                	mov    %eax,%edi
f010323e:	85 c0                	test   %eax,%eax
f0103240:	75 24                	jne    f0103266 <_Z8mem_initv+0x19ee>
f0103242:	c7 44 24 0c c1 89 10 	movl   $0xf01089c1,0xc(%esp)
f0103249:	f0 
f010324a:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103251:	f0 
f0103252:	c7 44 24 04 ed 03 00 	movl   $0x3ed,0x4(%esp)
f0103259:	00 
f010325a:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103261:	e8 c2 cf ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert((pp2 = page_alloc()));
f0103266:	e8 1f e2 ff ff       	call   f010148a <_Z10page_allocv>
f010326b:	89 c3                	mov    %eax,%ebx
f010326d:	85 c0                	test   %eax,%eax
f010326f:	75 24                	jne    f0103295 <_Z8mem_initv+0x1a1d>
f0103271:	c7 44 24 0c d6 89 10 	movl   $0xf01089d6,0xc(%esp)
f0103278:	f0 
f0103279:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103280:	f0 
f0103281:	c7 44 24 04 ee 03 00 	movl   $0x3ee,0x4(%esp)
f0103288:	00 
f0103289:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103290:	e8 93 cf ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	page_free(pp0);
f0103295:	89 34 24             	mov    %esi,(%esp)
f0103298:	e8 03 e2 ff ff       	call   f01014a0 <_Z9page_freeP4Page>
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f010329d:	89 f8                	mov    %edi,%eax
f010329f:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f01032a5:	c1 f8 03             	sar    $0x3,%eax
f01032a8:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f01032ab:	89 c2                	mov    %eax,%edx
f01032ad:	c1 ea 0c             	shr    $0xc,%edx
f01032b0:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f01032b6:	72 20                	jb     f01032d8 <_Z8mem_initv+0x1a60>
f01032b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01032bc:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f01032c3:	f0 
f01032c4:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f01032cb:	00 
f01032cc:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f01032d3:	e8 50 cf ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	memset(page2kva(pp1), 1, PGSIZE);
f01032d8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01032df:	00 
f01032e0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f01032e7:	00 
f01032e8:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01032ed:	89 04 24             	mov    %eax,(%esp)
f01032f0:	e8 0c 34 00 00       	call   f0106701 <memset>
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f01032f5:	89 d8                	mov    %ebx,%eax
f01032f7:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f01032fd:	c1 f8 03             	sar    $0x3,%eax
f0103300:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0103303:	89 c2                	mov    %eax,%edx
f0103305:	c1 ea 0c             	shr    $0xc,%edx
f0103308:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f010330e:	72 20                	jb     f0103330 <_Z8mem_initv+0x1ab8>
f0103310:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103314:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f010331b:	f0 
f010331c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0103323:	00 
f0103324:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f010332b:	e8 f8 ce ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	memset(page2kva(pp2), 2, PGSIZE);
f0103330:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103337:	00 
f0103338:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f010333f:	00 
f0103340:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103345:	89 04 24             	mov    %eax,(%esp)
f0103348:	e8 b4 33 00 00       	call   f0106701 <memset>
	page_insert(kern_pgdir, pp1, PGSIZE, PTE_W);
f010334d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0103354:	00 
f0103355:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010335c:	00 
f010335d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0103361:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0103366:	89 04 24             	mov    %eax,(%esp)
f0103369:	e8 3a e4 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
	assert(pp1->pp_ref == 1);
f010336e:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103373:	74 24                	je     f0103399 <_Z8mem_initv+0x1b21>
f0103375:	c7 44 24 0c 6d 8a 10 	movl   $0xf0108a6d,0xc(%esp)
f010337c:	f0 
f010337d:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103384:	f0 
f0103385:	c7 44 24 04 f3 03 00 	movl   $0x3f3,0x4(%esp)
f010338c:	00 
f010338d:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103394:	e8 8f ce ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0103399:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f01033a0:	01 01 01 
f01033a3:	74 24                	je     f01033c9 <_Z8mem_initv+0x1b51>
f01033a5:	c7 44 24 0c e0 87 10 	movl   $0xf01087e0,0xc(%esp)
f01033ac:	f0 
f01033ad:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01033b4:	f0 
f01033b5:	c7 44 24 04 f4 03 00 	movl   $0x3f4,0x4(%esp)
f01033bc:	00 
f01033bd:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01033c4:	e8 5f ce ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	page_insert(kern_pgdir, pp2, PGSIZE, PTE_W);
f01033c9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01033d0:	00 
f01033d1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01033d8:	00 
f01033d9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01033dd:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01033e2:	89 04 24             	mov    %eax,(%esp)
f01033e5:	e8 be e3 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01033ea:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f01033f1:	02 02 02 
f01033f4:	74 24                	je     f010341a <_Z8mem_initv+0x1ba2>
f01033f6:	c7 44 24 0c 04 88 10 	movl   $0xf0108804,0xc(%esp)
f01033fd:	f0 
f01033fe:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103405:	f0 
f0103406:	c7 44 24 04 f6 03 00 	movl   $0x3f6,0x4(%esp)
f010340d:	00 
f010340e:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103415:	e8 0e ce ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp2->pp_ref == 1);
f010341a:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010341f:	74 24                	je     f0103445 <_Z8mem_initv+0x1bcd>
f0103421:	c7 44 24 0c 8f 8a 10 	movl   $0xf0108a8f,0xc(%esp)
f0103428:	f0 
f0103429:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103430:	f0 
f0103431:	c7 44 24 04 f7 03 00 	movl   $0x3f7,0x4(%esp)
f0103438:	00 
f0103439:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103440:	e8 e3 cd ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(pp1->pp_ref == 0);
f0103445:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010344a:	74 24                	je     f0103470 <_Z8mem_initv+0x1bf8>
f010344c:	c7 44 24 0c d8 8a 10 	movl   $0xf0108ad8,0xc(%esp)
f0103453:	f0 
f0103454:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f010345b:	f0 
f010345c:	c7 44 24 04 f8 03 00 	movl   $0x3f8,0x4(%esp)
f0103463:	00 
f0103464:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f010346b:	e8 b8 cd ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0103470:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0103477:	03 03 03 
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f010347a:	89 d8                	mov    %ebx,%eax
f010347c:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f0103482:	c1 f8 03             	sar    $0x3,%eax
f0103485:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0103488:	89 c2                	mov    %eax,%edx
f010348a:	c1 ea 0c             	shr    $0xc,%edx
f010348d:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f0103493:	72 20                	jb     f01034b5 <_Z8mem_initv+0x1c3d>
f0103495:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103499:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f01034a0:	f0 
f01034a1:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f01034a8:	00 
f01034a9:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f01034b0:	e8 73 cd ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01034b5:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01034bc:	03 03 03 
f01034bf:	74 24                	je     f01034e5 <_Z8mem_initv+0x1c6d>
f01034c1:	c7 44 24 0c 28 88 10 	movl   $0xf0108828,0xc(%esp)
f01034c8:	f0 
f01034c9:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f01034d0:	f0 
f01034d1:	c7 44 24 04 fa 03 00 	movl   $0x3fa,0x4(%esp)
f01034d8:	00 
f01034d9:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f01034e0:	e8 43 cd ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	page_remove(kern_pgdir, PGSIZE);
f01034e5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01034ec:	00 
f01034ed:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f01034f2:	89 04 24             	mov    %eax,(%esp)
f01034f5:	e8 5e e2 ff ff       	call   f0101758 <_Z11page_removePjj>
	assert(pp2->pp_ref == 0);
f01034fa:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01034ff:	74 24                	je     f0103525 <_Z8mem_initv+0x1cad>
f0103501:	c7 44 24 0c c7 8a 10 	movl   $0xf0108ac7,0xc(%esp)
f0103508:	f0 
f0103509:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103510:	f0 
f0103511:	c7 44 24 04 fc 03 00 	movl   $0x3fc,0x4(%esp)
f0103518:	00 
f0103519:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103520:	e8 03 cd ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103525:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f010352a:	8b 08                	mov    (%eax),%ecx
f010352c:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f0103532:	89 f2                	mov    %esi,%edx
f0103534:	2b 15 74 82 37 f0    	sub    0xf0378274,%edx
f010353a:	c1 fa 03             	sar    $0x3,%edx
f010353d:	c1 e2 0c             	shl    $0xc,%edx
f0103540:	39 d1                	cmp    %edx,%ecx
f0103542:	74 24                	je     f0103568 <_Z8mem_initv+0x1cf0>
f0103544:	c7 44 24 0c ac 83 10 	movl   $0xf01083ac,0xc(%esp)
f010354b:	f0 
f010354c:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103553:	f0 
f0103554:	c7 44 24 04 ff 03 00 	movl   $0x3ff,0x4(%esp)
f010355b:	00 
f010355c:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103563:	e8 c0 cc ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	kern_pgdir[0] = 0;
f0103568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f010356e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0103573:	74 24                	je     f0103599 <_Z8mem_initv+0x1d21>
f0103575:	c7 44 24 0c 7e 8a 10 	movl   $0xf0108a7e,0xc(%esp)
f010357c:	f0 
f010357d:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0103584:	f0 
f0103585:	c7 44 24 04 01 04 00 	movl   $0x401,0x4(%esp)
f010358c:	00 
f010358d:	c7 04 24 b5 88 10 f0 	movl   $0xf01088b5,(%esp)
f0103594:	e8 8f cc ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	pp0->pp_ref = 0;
f0103599:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f010359f:	89 34 24             	mov    %esi,(%esp)
f01035a2:	e8 f9 de ff ff       	call   f01014a0 <_Z9page_freeP4Page>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f01035a7:	c7 04 24 54 88 10 f0 	movl   $0xf0108854,(%esp)
f01035ae:	e8 ff 0a 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);
	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f01035b3:	83 c4 5c             	add    $0x5c,%esp
f01035b6:	5b                   	pop    %ebx
f01035b7:	5e                   	pop    %esi
f01035b8:	5f                   	pop    %edi
f01035b9:	5d                   	pop    %ebp
f01035ba:	c3                   	ret    

f01035bb <_Z14user_mem_checkP3Envjjj>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, uintptr_t va, size_t len, pte_t perm)
{
f01035bb:	55                   	push   %ebp
f01035bc:	89 e5                	mov    %esp,%ebp
f01035be:	57                   	push   %edi
f01035bf:	56                   	push   %esi
f01035c0:	53                   	push   %ebx
f01035c1:	83 ec 3c             	sub    $0x3c,%esp
f01035c4:	8b 75 08             	mov    0x8(%ebp),%esi
	// LAB 3: Your code here.
    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
f01035c7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01035ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01035cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    len = ROUNDUP(oldva - va + len, PGSIZE);
f01035d2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01035d5:	05 ff 0f 00 00       	add    $0xfff,%eax
f01035da:	03 45 10             	add    0x10(%ebp),%eax
f01035dd:	2b 45 d4             	sub    -0x2c(%ebp),%eax
    perm |= PTE_P;
f01035e0:	8b 7d 14             	mov    0x14(%ebp),%edi
f01035e3:	83 cf 01             	or     $0x1,%edi
user_mem_check(struct Env *env, uintptr_t va, size_t len, pte_t perm)
{
	// LAB 3: Your code here.
    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
    len = ROUNDUP(oldva - va + len, PGSIZE);
f01035e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    perm |= PTE_P;
        
    pte_t *pte;
    uintptr_t i;
    for (i = va; i < len + va; i+=PGSIZE)
f01035eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01035ee:	8d 04 10             	lea    (%eax,%edx,1),%eax
f01035f1:	89 45 cc             	mov    %eax,-0x34(%ebp)
        {
            user_mem_check_addr = (ROUNDDOWN(i, PGSIZE) == va)?oldva:i;
            return -E_FAULT;
        }
    }
    return 0;
f01035f4:	b8 00 00 00 00       	mov    $0x0,%eax
    len = ROUNDUP(oldva - va + len, PGSIZE);
    perm |= PTE_P;
        
    pte_t *pte;
    uintptr_t i;
    for (i = va; i < len + va; i+=PGSIZE)
f01035f9:	8b 55 cc             	mov    -0x34(%ebp),%edx
f01035fc:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
f01035ff:	73 70                	jae    f0103671 <_Z14user_mem_checkP3Envjjj+0xb6>
    {
        if(i >= ULIM ||
           !(page_lookup(env->env_pgdir, i, &pte)) ||
           (((env->env_pgdir[PDX(va)] & perm) != perm) ||
f0103601:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103604:	c1 e8 16             	shr    $0x16,%eax
f0103607:	c1 e0 02             	shl    $0x2,%eax
f010360a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    len = ROUNDUP(oldva - va + len, PGSIZE);
    perm |= PTE_P;
        
    pte_t *pte;
    uintptr_t i;
    for (i = va; i < len + va; i+=PGSIZE)
f010360d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    {
        if(i >= ULIM ||
f0103610:	81 fb ff ff bf ef    	cmp    $0xefbfffff,%ebx
f0103616:	77 38                	ja     f0103650 <_Z14user_mem_checkP3Envjjj+0x95>
           !(page_lookup(env->env_pgdir, i, &pte)) ||
f0103618:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010361b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010361f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103623:	8b 46 10             	mov    0x10(%esi),%eax
f0103626:	89 04 24             	mov    %eax,(%esp)
f0103629:	e8 73 e0 ff ff       	call   f01016a1 <_Z11page_lookupPjjPS_>
        
    pte_t *pte;
    uintptr_t i;
    for (i = va; i < len + va; i+=PGSIZE)
    {
        if(i >= ULIM ||
f010362e:	85 c0                	test   %eax,%eax
f0103630:	74 22                	je     f0103654 <_Z14user_mem_checkP3Envjjj+0x99>
           !(page_lookup(env->env_pgdir, i, &pte)) ||
           (((env->env_pgdir[PDX(va)] & perm) != perm) ||
f0103632:	8b 46 10             	mov    0x10(%esi),%eax
        
    pte_t *pte;
    uintptr_t i;
    for (i = va; i < len + va; i+=PGSIZE)
    {
        if(i >= ULIM ||
f0103635:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0103638:	8b 04 10             	mov    (%eax,%edx,1),%eax
f010363b:	21 f8                	and    %edi,%eax
f010363d:	39 f8                	cmp    %edi,%eax
f010363f:	75 17                	jne    f0103658 <_Z14user_mem_checkP3Envjjj+0x9d>
f0103641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103644:	8b 00                	mov    (%eax),%eax
f0103646:	21 f8                	and    %edi,%eax
f0103648:	39 f8                	cmp    %edi,%eax
f010364a:	74 2d                	je     f0103679 <_Z14user_mem_checkP3Envjjj+0xbe>
f010364c:	89 d8                	mov    %ebx,%eax
f010364e:	eb 0a                	jmp    f010365a <_Z14user_mem_checkP3Envjjj+0x9f>
f0103650:	89 d8                	mov    %ebx,%eax
f0103652:	eb 06                	jmp    f010365a <_Z14user_mem_checkP3Envjjj+0x9f>
f0103654:	89 d8                	mov    %ebx,%eax
f0103656:	eb 02                	jmp    f010365a <_Z14user_mem_checkP3Envjjj+0x9f>
f0103658:	89 d8                	mov    %ebx,%eax
           !(page_lookup(env->env_pgdir, i, &pte)) ||
           (((env->env_pgdir[PDX(va)] & perm) != perm) ||
           ((*pte & perm) != perm)))
        {
            user_mem_check_addr = (ROUNDDOWN(i, PGSIZE) == va)?oldva:i;
f010365a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010365f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
f0103662:	0f 44 5d 0c          	cmove  0xc(%ebp),%ebx
f0103666:	89 1d 78 82 37 f0    	mov    %ebx,0xf0378278
            return -E_FAULT;
f010366c:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
        }
    }
    return 0;
}
f0103671:	83 c4 3c             	add    $0x3c,%esp
f0103674:	5b                   	pop    %ebx
f0103675:	5e                   	pop    %esi
f0103676:	5f                   	pop    %edi
f0103677:	5d                   	pop    %ebp
f0103678:	c3                   	ret    
    len = ROUNDUP(oldva - va + len, PGSIZE);
    perm |= PTE_P;
        
    pte_t *pte;
    uintptr_t i;
    for (i = va; i < len + va; i+=PGSIZE)
f0103679:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010367f:	3b 5d cc             	cmp    -0x34(%ebp),%ebx
f0103682:	72 8c                	jb     f0103610 <_Z14user_mem_checkP3Envjjj+0x55>
        {
            user_mem_check_addr = (ROUNDDOWN(i, PGSIZE) == va)?oldva:i;
            return -E_FAULT;
        }
    }
    return 0;
f0103684:	b8 00 00 00 00       	mov    $0x0,%eax
f0103689:	eb e6                	jmp    f0103671 <_Z14user_mem_checkP3Envjjj+0xb6>

f010368b <_Z15user_mem_assertP3Envjjj>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm)
{
f010368b:	55                   	push   %ebp
f010368c:	89 e5                	mov    %esp,%ebp
f010368e:	53                   	push   %ebx
f010368f:	83 ec 14             	sub    $0x14,%esp
f0103692:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0103695:	8b 45 14             	mov    0x14(%ebp),%eax
f0103698:	83 c8 04             	or     $0x4,%eax
f010369b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010369f:	8b 45 10             	mov    0x10(%ebp),%eax
f01036a2:	89 44 24 08          	mov    %eax,0x8(%esp)
f01036a6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036a9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01036ad:	89 1c 24             	mov    %ebx,(%esp)
f01036b0:	e8 06 ff ff ff       	call   f01035bb <_Z14user_mem_checkP3Envjjj>
f01036b5:	85 c0                	test   %eax,%eax
f01036b7:	79 24                	jns    f01036dd <_Z15user_mem_assertP3Envjjj+0x52>
		cprintf("[%08x] user_mem_check assertion failure for "
			"va %08x\n", env->env_id, user_mem_check_addr);
f01036b9:	a1 78 82 37 f0       	mov    0xf0378278,%eax
f01036be:	89 44 24 08          	mov    %eax,0x8(%esp)
f01036c2:	8b 43 04             	mov    0x4(%ebx),%eax
f01036c5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01036c9:	c7 04 24 80 88 10 f0 	movl   $0xf0108880,(%esp)
f01036d0:	e8 dd 09 00 00       	call   f01040b2 <_Z7cprintfPKcz>
		env_destroy(env);	// may not return
f01036d5:	89 1c 24             	mov    %ebx,(%esp)
f01036d8:	e8 6e 07 00 00       	call   f0103e4b <_Z11env_destroyP3Env>
	}
}
f01036dd:	83 c4 14             	add    $0x14,%esp
f01036e0:	5b                   	pop    %ebx
f01036e1:	5d                   	pop    %ebp
f01036e2:	c3                   	ret    
	...

f01036e4 <_Z9envid2enviPP3Envb>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f01036e4:	55                   	push   %ebp
f01036e5:	89 e5                	mov    %esp,%ebp
f01036e7:	53                   	push   %ebx
f01036e8:	8b 45 08             	mov    0x8(%ebp),%eax
f01036eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01036ee:	0f b6 5d 10          	movzbl 0x10(%ebp),%ebx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f01036f2:	85 c0                	test   %eax,%eax
f01036f4:	75 0e                	jne    f0103704 <_Z9envid2enviPP3Envb+0x20>
		*env_store = curenv;
f01036f6:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f01036fb:	89 01                	mov    %eax,(%ecx)
		return 0;
f01036fd:	b8 00 00 00 00       	mov    $0x0,%eax
f0103702:	eb 52                	jmp    f0103756 <_Z9envid2enviPP3Envb+0x72>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f0103704:	89 c2                	mov    %eax,%edx
f0103706:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f010370c:	6b d2 78             	imul   $0x78,%edx,%edx
f010370f:	03 15 88 82 37 f0    	add    0xf0378288,%edx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103715:	83 7a 0c 00          	cmpl   $0x0,0xc(%edx)
f0103719:	74 05                	je     f0103720 <_Z9envid2enviPP3Envb+0x3c>
f010371b:	39 42 04             	cmp    %eax,0x4(%edx)
f010371e:	74 0d                	je     f010372d <_Z9envid2enviPP3Envb+0x49>
		*env_store = 0;
f0103720:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
		return -E_BAD_ENV;
f0103726:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010372b:	eb 29                	jmp    f0103756 <_Z9envid2enviPP3Envb+0x72>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010372d:	84 db                	test   %bl,%bl
f010372f:	74 1e                	je     f010374f <_Z9envid2enviPP3Envb+0x6b>
f0103731:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0103736:	39 c2                	cmp    %eax,%edx
f0103738:	74 15                	je     f010374f <_Z9envid2enviPP3Envb+0x6b>
f010373a:	8b 58 04             	mov    0x4(%eax),%ebx
f010373d:	39 5a 08             	cmp    %ebx,0x8(%edx)
f0103740:	74 0d                	je     f010374f <_Z9envid2enviPP3Envb+0x6b>
		*env_store = 0;
f0103742:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
		return -E_BAD_ENV;
f0103748:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010374d:	eb 07                	jmp    f0103756 <_Z9envid2enviPP3Envb+0x72>
	}

	*env_store = e;
f010374f:	89 11                	mov    %edx,(%ecx)
	return 0;
f0103751:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103756:	5b                   	pop    %ebx
f0103757:	5d                   	pop    %ebp
f0103758:	c3                   	ret    

f0103759 <_Z8env_initv>:
// Insert in reverse order, so that the first call to env_alloc()
// returns envs[0].  (This is important for grading.)
//
void
env_init(void)
{
f0103759:	55                   	push   %ebp
f010375a:	89 e5                	mov    %esp,%ebp
f010375c:	b8 88 df 01 00       	mov    $0x1df88,%eax
	// Set up envs array
    for (int i = NENV - 1; i >= 0; i--)
    {
        // add all envs to free list
        envs[i].env_link = env_free_list;
f0103761:	8b 0d 90 82 37 f0    	mov    0xf0378290,%ecx
f0103767:	8b 15 88 82 37 f0    	mov    0xf0378288,%edx
f010376d:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
        env_free_list = &envs[i];
f0103770:	89 c2                	mov    %eax,%edx
f0103772:	03 15 88 82 37 f0    	add    0xf0378288,%edx
f0103778:	89 15 90 82 37 f0    	mov    %edx,0xf0378290

        // begin with no id, set to free
        envs[i].env_id = 0;
f010377e:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
        envs[i].env_status = ENV_FREE;
f0103785:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
f010378c:	83 e8 78             	sub    $0x78,%eax
//
void
env_init(void)
{
	// Set up envs array
    for (int i = NENV - 1; i >= 0; i--)
f010378f:	83 f8 88             	cmp    $0xffffff88,%eax
f0103792:	75 cd                	jne    f0103761 <_Z8env_initv+0x8>

        // begin with no id, set to free
        envs[i].env_id = 0;
        envs[i].env_status = ENV_FREE;
    }
}
f0103794:	5d                   	pop    %ebp
f0103795:	c3                   	ret    

f0103796 <_Z9env_allocPP3Envi>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103796:	55                   	push   %ebp
f0103797:	89 e5                	mov    %esp,%ebp
f0103799:	56                   	push   %esi
f010379a:	53                   	push   %ebx
f010379b:	83 ec 10             	sub    $0x10,%esp
	int32_t generation;
	int r;
	struct Env *e = env_free_list;
f010379e:	8b 1d 90 82 37 f0    	mov    0xf0378290,%ebx
	if (!e)
f01037a4:	85 db                	test   %ebx,%ebx
f01037a6:	0f 84 e3 01 00 00    	je     f010398f <_Z9env_allocPP3Envi+0x1f9>
	pte_t i;
	int r;
	struct Page *p;

	// Allocate a page for the page directory
	p = page_alloc();
f01037ac:	e8 d9 dc ff ff       	call   f010148a <_Z10page_allocv>
f01037b1:	89 c6                	mov    %eax,%esi
	if (!p)
f01037b3:	85 c0                	test   %eax,%eax
f01037b5:	0f 84 db 01 00 00    	je     f0103996 <_Z9env_allocPP3Envi+0x200>
f01037bb:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f01037c1:	c1 f8 03             	sar    $0x3,%eax
f01037c4:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f01037c7:	89 c2                	mov    %eax,%edx
f01037c9:	c1 ea 0c             	shr    $0xc,%edx
f01037cc:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f01037d2:	72 20                	jb     f01037f4 <_Z9env_allocPP3Envi+0x5e>
f01037d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01037d8:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f01037df:	f0 
f01037e0:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f01037e7:	00 
f01037e8:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f01037ef:	e8 34 ca ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
		return -E_NO_MEM;
    memset(page2kva(p), 0, PGSIZE);
f01037f4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01037fb:	00 
f01037fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103803:	00 
f0103804:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103809:	89 04 24             	mov    %eax,(%esp)
f010380c:	e8 f0 2e 00 00       	call   f0106701 <memset>
    p->pp_ref++;
f0103811:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f0103816:	2b 35 74 82 37 f0    	sub    0xf0378274,%esi
f010381c:	c1 fe 03             	sar    $0x3,%esi
f010381f:	89 f0                	mov    %esi,%eax
f0103821:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0103824:	89 c2                	mov    %eax,%edx
f0103826:	c1 ea 0c             	shr    $0xc,%edx
f0103829:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f010382f:	72 20                	jb     f0103851 <_Z9env_allocPP3Envi+0xbb>
f0103831:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103835:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f010383c:	f0 
f010383d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0103844:	00 
f0103845:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f010384c:	e8 d7 c9 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0103851:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103856:	89 43 10             	mov    %eax,0x10(%ebx)
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.
    e->env_pgdir = (pte_t *)page2kva(p);
f0103859:	b8 f0 0e 00 00       	mov    $0xef0,%eax
    for (i = PDX(UTOP); i < NPDENTRIES; i++)
        e->env_pgdir[i] = kern_pgdir[i];
f010385e:	8b 53 10             	mov    0x10(%ebx),%edx
f0103861:	8b 0d 70 82 37 f0    	mov    0xf0378270,%ecx
f0103867:	8b 0c 01             	mov    (%ecx,%eax,1),%ecx
f010386a:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
f010386d:	83 c0 04             	add    $0x4,%eax
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.
    e->env_pgdir = (pte_t *)page2kva(p);
    for (i = PDX(UTOP); i < NPDENTRIES; i++)
f0103870:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0103875:	75 e7                	jne    f010385e <_Z9env_allocPP3Envi+0xc8>
        e->env_pgdir[i] = kern_pgdir[i];
	
    // UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103877:	8b 43 10             	mov    0x10(%ebx),%eax
f010387a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010387f:	77 20                	ja     f01038a1 <_Z9env_allocPP3Envi+0x10b>
f0103881:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103885:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f010388c:	f0 
f010388d:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
f0103894:	00 
f0103895:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f010389c:	e8 87 c9 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f01038a1:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01038a7:	83 ca 05             	or     $0x5,%edx
f01038aa:	89 90 f8 0e 00 00    	mov    %edx,0xef8(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_mem_init(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01038b0:	8b 43 04             	mov    0x4(%ebx),%eax
f01038b3:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f01038b8:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f01038bd:	ba 00 10 00 00       	mov    $0x1000,%edx
f01038c2:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01038c5:	89 da                	mov    %ebx,%edx
f01038c7:	2b 15 88 82 37 f0    	sub    0xf0378288,%edx
f01038cd:	c1 fa 03             	sar    $0x3,%edx
f01038d0:	69 d2 ef ee ee ee    	imul   $0xeeeeeeef,%edx,%edx
f01038d6:	09 d0                	or     %edx,%eax
f01038d8:	89 43 04             	mov    %eax,0x4(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f01038db:	8b 45 0c             	mov    0xc(%ebp),%eax
f01038de:	89 43 08             	mov    %eax,0x8(%ebx)
	e->env_status = ENV_RUNNABLE;
f01038e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	e->env_runs = 0;
f01038e8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    e->env_priority = 10;
f01038ef:	c7 43 74 0a 00 00 00 	movl   $0xa,0x74(%ebx)
	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01038f6:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f01038fd:	00 
f01038fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103905:	00 
f0103906:	8d 43 14             	lea    0x14(%ebx),%eax
f0103909:	89 04 24             	mov    %eax,(%esp)
f010390c:	e8 f0 2d 00 00       	call   f0106701 <memset>
	// Set up appropriate initial values for the segment registers.
	// GD_UD is the user data segment selector in the GDT, and
	// GD_UT is the user text segment selector (see inc/memlayout.h).
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.
	e->env_tf.tf_ds = GD_UD | 3;
f0103911:	66 c7 43 18 23 00    	movw   $0x23,0x18(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103917:	66 c7 43 14 23 00    	movw   $0x23,0x14(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f010391d:	66 c7 43 54 23 00    	movw   $0x23,0x54(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103923:	c7 43 50 00 e0 ff ee 	movl   $0xeeffe000,0x50(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f010392a:	66 c7 43 48 1b 00    	movw   $0x1b,0x48(%ebx)
    e->env_tf.tf_eflags |= FL_IF;
f0103930:	8b 43 4c             	mov    0x4c(%ebx),%eax
f0103933:	80 cc 02             	or     $0x2,%ah
f0103936:	89 43 4c             	mov    %eax,0x4c(%ebx)

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.

	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0103939:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0103940:	c6 43 60 00          	movb   $0x0,0x60(%ebx)

	// If this is the buffer cache server (env_id == ENVID_BUFCACHE)
	// give it I/O privileges.
	// LAB 5: Your code here.

	if (e->env_id == ENVID_BUFCACHE)
f0103944:	81 7b 04 00 11 00 00 	cmpl   $0x1100,0x4(%ebx)
f010394b:	75 06                	jne    f0103953 <_Z9env_allocPP3Envi+0x1bd>
        e->env_tf.tf_eflags |= FL_IOPL_3;
f010394d:	80 cc 30             	or     $0x30,%ah
f0103950:	89 43 4c             	mov    %eax,0x4c(%ebx)
	// commit the allocation
	env_free_list = e->env_link;
f0103953:	8b 03                	mov    (%ebx),%eax
f0103955:	a3 90 82 37 f0       	mov    %eax,0xf0378290
	*newenv_store = e;
f010395a:	8b 45 08             	mov    0x8(%ebp),%eax
f010395d:	89 18                	mov    %ebx,(%eax)

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010395f:	8b 4b 04             	mov    0x4(%ebx),%ecx
f0103962:	8b 15 8c 82 37 f0    	mov    0xf037828c,%edx
f0103968:	b8 00 00 00 00       	mov    $0x0,%eax
f010396d:	85 d2                	test   %edx,%edx
f010396f:	74 03                	je     f0103974 <_Z9env_allocPP3Envi+0x1de>
f0103971:	8b 42 04             	mov    0x4(%edx),%eax
f0103974:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0103978:	89 44 24 04          	mov    %eax,0x4(%esp)
f010397c:	c7 04 24 a2 8b 10 f0 	movl   $0xf0108ba2,(%esp)
f0103983:	e8 2a 07 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	return 0;
f0103988:	b8 00 00 00 00       	mov    $0x0,%eax
f010398d:	eb 0c                	jmp    f010399b <_Z9env_allocPP3Envi+0x205>
{
	int32_t generation;
	int r;
	struct Env *e = env_free_list;
	if (!e)
		return -E_NO_FREE_ENV;
f010398f:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103994:	eb 05                	jmp    f010399b <_Z9env_allocPP3Envi+0x205>
	struct Page *p;

	// Allocate a page for the page directory
	p = page_alloc();
	if (!p)
		return -E_NO_MEM;
f0103996:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	env_free_list = e->env_link;
	*newenv_store = e;

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
}
f010399b:	83 c4 10             	add    $0x10,%esp
f010399e:	5b                   	pop    %ebx
f010399f:	5e                   	pop    %esi
f01039a0:	5d                   	pop    %ebp
f01039a1:	c3                   	ret    

f01039a2 <_Z10env_createPhj>:
// The new env's parent ID is set to 0.
// The implementation is a simple wrapper around env_alloc and load_elf.
//
void
env_create(uint8_t *binary, size_t size)
{
f01039a2:	55                   	push   %ebp
f01039a3:	89 e5                	mov    %esp,%ebp
f01039a5:	57                   	push   %edi
f01039a6:	56                   	push   %esi
f01039a7:	53                   	push   %ebx
f01039a8:	83 ec 3c             	sub    $0x3c,%esp
    struct Env *e;
    if(env_alloc(&e, 0))
f01039ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01039b2:	00 
f01039b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01039b6:	89 04 24             	mov    %eax,(%esp)
f01039b9:	e8 d8 fd ff ff       	call   f0103796 <_Z9env_allocPP3Envi>
f01039be:	85 c0                	test   %eax,%eax
f01039c0:	74 1c                	je     f01039de <_Z10env_createPhj+0x3c>
        panic("env_create: Environment allocation failed");
f01039c2:	c7 44 24 08 48 8b 10 	movl   $0xf0108b48,0x8(%esp)
f01039c9:	f0 
f01039ca:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
f01039d1:	00 
f01039d2:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f01039d9:	e8 4a c8 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
    load_elf(e, binary, size);
f01039de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	// to make sure that the environment starts executing at that point.
	// See env_run() and env_iret() below.
    

	// LAB 3: Your code here.
    lcr3(PADDR(e->env_pgdir));
f01039e1:	8b 47 10             	mov    0x10(%edi),%eax
f01039e4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039e9:	77 20                	ja     f0103a0b <_Z10env_createPhj+0x69>
f01039eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01039ef:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f01039f6:	f0 
f01039f7:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
f01039fe:	00 
f01039ff:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f0103a06:	e8 1d c8 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0103a0b:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103a10:	0f 22 d8             	mov    %eax,%cr3

    if (elf->e_magic != ELF_MAGIC)
f0103a13:	8b 45 08             	mov    0x8(%ebp),%eax
f0103a16:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f0103a1c:	74 1c                	je     f0103a3a <_Z10env_createPhj+0x98>
        panic("Invalid Elf Magic");
f0103a1e:	c7 44 24 08 b7 8b 10 	movl   $0xf0108bb7,0x8(%esp)
f0103a25:	f0 
f0103a26:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
f0103a2d:	00 
f0103a2e:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f0103a35:	e8 ee c7 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
    struct Proghdr *ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
f0103a3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103a3d:	8b 51 1c             	mov    0x1c(%ecx),%edx
    int ph_num = elf->e_phnum;
f0103a40:	0f b7 41 2c          	movzwl 0x2c(%ecx),%eax

    // iterate over all program headers
    for (; --ph_num >= 0; ph++) 
f0103a44:	83 e8 01             	sub    $0x1,%eax
f0103a47:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0103a4a:	0f 88 fc 00 00 00    	js     f0103b4c <_Z10env_createPhj+0x1aa>
	// LAB 3: Your code here.
    lcr3(PADDR(e->env_pgdir));

    if (elf->e_magic != ELF_MAGIC)
        panic("Invalid Elf Magic");
    struct Proghdr *ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
f0103a50:	01 ca                	add    %ecx,%edx
f0103a52:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    int ph_num = elf->e_phnum;

    // iterate over all program headers
    for (; --ph_num >= 0; ph++) 
        if (ph->p_type == ELF_PROG_LOAD)
f0103a55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103a58:	83 38 01             	cmpl   $0x1,(%eax)
f0103a5b:	0f 85 dc 00 00 00    	jne    f0103b3d <_Z10env_createPhj+0x19b>
        {
            segment_alloc(e, ph->p_va, ph->p_memsz);
f0103a61:	8b 70 08             	mov    0x8(%eax),%esi
	//   'va' and 'len' values that are not page-aligned.
	//   You should round 'va' down, and round 'va + len' up.
    struct Page *p;
    
    // span all pages that are touched
    len = ROUNDUP(len + va, PGSIZE);
f0103a64:	89 f0                	mov    %esi,%eax
f0103a66:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0103a69:	03 42 14             	add    0x14(%edx),%eax
f0103a6c:	05 ff 0f 00 00       	add    $0xfff,%eax
f0103a71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103a76:	89 45 d0             	mov    %eax,-0x30(%ebp)
    va = ROUNDDOWN(va, PGSIZE);
f0103a79:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    for (uintptr_t i = va; i < len; i += PGSIZE)
f0103a7f:	39 f0                	cmp    %esi,%eax
f0103a81:	0f 86 97 00 00 00    	jbe    f0103b1e <_Z10env_createPhj+0x17c>
        if ((p = page_alloc()) == NULL || page_insert(e->env_pgdir, p, i, PTE_U|PTE_W|PTE_P))
f0103a87:	e8 fe d9 ff ff       	call   f010148a <_Z10page_allocv>
f0103a8c:	89 c3                	mov    %eax,%ebx
f0103a8e:	85 c0                	test   %eax,%eax
f0103a90:	74 23                	je     f0103ab5 <_Z10env_createPhj+0x113>
f0103a92:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0103a99:	00 
f0103a9a:	89 74 24 08          	mov    %esi,0x8(%esp)
f0103a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103aa2:	8b 47 10             	mov    0x10(%edi),%eax
f0103aa5:	89 04 24             	mov    %eax,(%esp)
f0103aa8:	e8 fb dc ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f0103aad:	85 c0                	test   %eax,%eax
f0103aaf:	0f 84 3a 01 00 00    	je     f0103bef <_Z10env_createPhj+0x24d>
            panic("segment_alloc: Can't allocate page");
f0103ab5:	c7 44 24 08 74 8b 10 	movl   $0xf0108b74,0x8(%esp)
f0103abc:	f0 
f0103abd:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
f0103ac4:	00 
f0103ac5:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f0103acc:	e8 57 c7 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0103ad1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0103ad5:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0103adc:	f0 
f0103add:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0103ae4:	00 
f0103ae5:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0103aec:	e8 37 c7 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
        else
            memset(page2kva(p), 0, PGSIZE);
f0103af1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103af8:	00 
f0103af9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103b00:	00 
f0103b01:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0103b07:	89 1c 24             	mov    %ebx,(%esp)
f0103b0a:	e8 f2 2b 00 00       	call   f0106701 <memset>
    struct Page *p;
    
    // span all pages that are touched
    len = ROUNDUP(len + va, PGSIZE);
    va = ROUNDDOWN(va, PGSIZE);
    for (uintptr_t i = va; i < len; i += PGSIZE)
f0103b0f:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103b15:	39 75 d0             	cmp    %esi,-0x30(%ebp)
f0103b18:	0f 87 69 ff ff ff    	ja     f0103a87 <_Z10env_createPhj+0xe5>
    for (; --ph_num >= 0; ph++) 
        if (ph->p_type == ELF_PROG_LOAD)
        {
            segment_alloc(e, ph->p_va, ph->p_memsz);
            // copy data from binary to address space
            memmove((void *)ph->p_va, binary + ph->p_offset, ph->p_filesz);
f0103b1e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103b21:	8b 41 10             	mov    0x10(%ecx),%eax
f0103b24:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103b28:	8b 45 08             	mov    0x8(%ebp),%eax
f0103b2b:	03 41 04             	add    0x4(%ecx),%eax
f0103b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103b32:	8b 41 08             	mov    0x8(%ecx),%eax
f0103b35:	89 04 24             	mov    %eax,(%esp)
f0103b38:	e8 1f 2c 00 00       	call   f010675c <memmove>
        panic("Invalid Elf Magic");
    struct Proghdr *ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
    int ph_num = elf->e_phnum;

    // iterate over all program headers
    for (; --ph_num >= 0; ph++) 
f0103b3d:	83 6d cc 01          	subl   $0x1,-0x34(%ebp)
f0103b41:	78 09                	js     f0103b4c <_Z10env_createPhj+0x1aa>
f0103b43:	83 45 d4 20          	addl   $0x20,-0x2c(%ebp)
f0103b47:	e9 09 ff ff ff       	jmp    f0103a55 <_Z10env_createPhj+0xb3>
            // copy data from binary to address space
            memmove((void *)ph->p_va, binary + ph->p_offset, ph->p_filesz);
        }

    // set entry point for new env
    e->env_tf.tf_eip = elf->e_entry;
f0103b4c:	8b 55 08             	mov    0x8(%ebp),%edx
f0103b4f:	8b 42 18             	mov    0x18(%edx),%eax
f0103b52:	89 47 44             	mov    %eax,0x44(%edi)
    e->env_tf.tf_esp = USTACKTOP;
f0103b55:	c7 47 50 00 e0 ff ee 	movl   $0xeeffe000,0x50(%edi)
	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.
	// (What should the permissions be?)
    struct Page *p;
    if ((p = page_alloc()) == NULL || page_insert(e->env_pgdir, p, USTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P))
f0103b5c:	e8 29 d9 ff ff       	call   f010148a <_Z10page_allocv>
f0103b61:	89 c3                	mov    %eax,%ebx
f0103b63:	85 c0                	test   %eax,%eax
f0103b65:	74 27                	je     f0103b8e <_Z10env_createPhj+0x1ec>
f0103b67:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0103b6e:	00 
f0103b6f:	c7 44 24 08 00 d0 ff 	movl   $0xeeffd000,0x8(%esp)
f0103b76:	ee 
f0103b77:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103b7b:	8b 47 10             	mov    0x10(%edi),%eax
f0103b7e:	89 04 24             	mov    %eax,(%esp)
f0103b81:	e8 22 dc ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f0103b86:	85 c0                	test   %eax,%eax
f0103b88:	0f 84 83 00 00 00    	je     f0103c11 <_Z10env_createPhj+0x26f>
        panic("segment_alloc: Can't allocate page");
f0103b8e:	c7 44 24 08 74 8b 10 	movl   $0xf0108b74,0x8(%esp)
f0103b95:	f0 
f0103b96:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
f0103b9d:	00 
f0103b9e:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f0103ba5:	e8 7e c6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0103baa:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103bae:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0103bb5:	f0 
f0103bb6:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0103bbd:	00 
f0103bbe:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0103bc5:	e8 5e c6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
    memset(page2kva(p), 0, PGSIZE);
f0103bca:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103bd1:	00 
f0103bd2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103bd9:	00 
f0103bda:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103bdf:	89 04 24             	mov    %eax,(%esp)
f0103be2:	e8 1a 2b 00 00       	call   f0106701 <memset>
{
    struct Env *e;
    if(env_alloc(&e, 0))
        panic("env_create: Environment allocation failed");
    load_elf(e, binary, size);
}
f0103be7:	83 c4 3c             	add    $0x3c,%esp
f0103bea:	5b                   	pop    %ebx
f0103beb:	5e                   	pop    %esi
f0103bec:	5f                   	pop    %edi
f0103bed:	5d                   	pop    %ebp
f0103bee:	c3                   	ret    
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f0103bef:	2b 1d 74 82 37 f0    	sub    0xf0378274,%ebx
f0103bf5:	c1 fb 03             	sar    $0x3,%ebx
f0103bf8:	c1 e3 0c             	shl    $0xc,%ebx
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0103bfb:	89 d8                	mov    %ebx,%eax
f0103bfd:	c1 e8 0c             	shr    $0xc,%eax
f0103c00:	3b 05 6c 82 37 f0    	cmp    0xf037826c,%eax
f0103c06:	0f 82 e5 fe ff ff    	jb     f0103af1 <_Z10env_createPhj+0x14f>
f0103c0c:	e9 c0 fe ff ff       	jmp    f0103ad1 <_Z10env_createPhj+0x12f>
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f0103c11:	2b 1d 74 82 37 f0    	sub    0xf0378274,%ebx
f0103c17:	c1 fb 03             	sar    $0x3,%ebx
f0103c1a:	89 d8                	mov    %ebx,%eax
f0103c1c:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0103c1f:	89 c2                	mov    %eax,%edx
f0103c21:	c1 ea 0c             	shr    $0xc,%edx
f0103c24:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f0103c2a:	72 9e                	jb     f0103bca <_Z10env_createPhj+0x228>
f0103c2c:	e9 79 ff ff ff       	jmp    f0103baa <_Z10env_createPhj+0x208>

f0103c31 <_Z8env_freeP3Env>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103c31:	55                   	push   %ebp
f0103c32:	89 e5                	mov    %esp,%ebp
f0103c34:	57                   	push   %edi
f0103c35:	56                   	push   %esi
f0103c36:	53                   	push   %ebx
f0103c37:	83 ec 2c             	sub    $0x2c,%esp
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103c3a:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0103c3f:	39 45 08             	cmp    %eax,0x8(%ebp)
f0103c42:	75 37                	jne    f0103c7b <_Z8env_freeP3Env+0x4a>
		lcr3(PADDR(kern_pgdir));
f0103c44:	8b 15 70 82 37 f0    	mov    0xf0378270,%edx
f0103c4a:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0103c50:	77 20                	ja     f0103c72 <_Z8env_freeP3Env+0x41>
f0103c52:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103c56:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0103c5d:	f0 
f0103c5e:	c7 44 24 04 62 01 00 	movl   $0x162,0x4(%esp)
f0103c65:	00 
f0103c66:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f0103c6d:	e8 b6 c5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0103c72:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0103c78:	0f 22 da             	mov    %edx,%cr3

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103c7b:	8b 55 08             	mov    0x8(%ebp),%edx
f0103c7e:	8b 4a 04             	mov    0x4(%edx),%ecx
f0103c81:	ba 00 00 00 00       	mov    $0x0,%edx
f0103c86:	85 c0                	test   %eax,%eax
f0103c88:	74 03                	je     f0103c8d <_Z8env_freeP3Env+0x5c>
f0103c8a:	8b 50 04             	mov    0x4(%eax),%edx
f0103c8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0103c91:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103c95:	c7 04 24 c9 8b 10 f0 	movl   $0xf0108bc9,(%esp)
f0103c9c:	e8 11 04 00 00       	call   f01040b2 <_Z7cprintfPKcz>

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	pgdir = e->env_pgdir;
f0103ca1:	8b 45 08             	mov    0x8(%ebp),%eax
f0103ca4:	8b 78 10             	mov    0x10(%eax),%edi
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103ca7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		// only look at mapped page tables
		if (!(pgdir[pdeno] & PTE_P))
f0103cae:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103cb1:	8b 34 97             	mov    (%edi,%edx,4),%esi
f0103cb4:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103cba:	0f 84 eb 00 00 00    	je     f0103dab <_Z8env_freeP3Env+0x17a>
			continue;

		// find the pa and va of the page table
		pt = (pte_t *) KADDR(PTE_ADDR(pgdir[pdeno]));
f0103cc0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f0103cc6:	89 f0                	mov    %esi,%eax
f0103cc8:	c1 e8 0c             	shr    $0xc,%eax
f0103ccb:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103cce:	3b 05 6c 82 37 f0    	cmp    0xf037826c,%eax
f0103cd4:	72 20                	jb     f0103cf6 <_Z8env_freeP3Env+0xc5>
f0103cd6:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0103cda:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0103ce1:	f0 
f0103ce2:	c7 44 24 04 70 01 00 	movl   $0x170,0x4(%esp)
f0103ce9:	00 
f0103cea:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f0103cf1:	e8 32 c5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0103cf6:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f0103cfc:	89 55 d8             	mov    %edx,-0x28(%ebp)

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(pgdir, PGADDR(pdeno, pteno, 0));
f0103cff:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103d02:	c1 e0 16             	shl    $0x16,%eax
f0103d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		// find the pa and va of the page table
		pt = (pte_t *) KADDR(PTE_ADDR(pgdir[pdeno]));

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103d08:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (pt[pteno] & PTE_P)
f0103d0d:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f0103d14:	01 
f0103d15:	74 14                	je     f0103d2b <_Z8env_freeP3Env+0xfa>
				page_remove(pgdir, PGADDR(pdeno, pteno, 0));
f0103d17:	89 d8                	mov    %ebx,%eax
f0103d19:	c1 e0 0c             	shl    $0xc,%eax
f0103d1c:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103d23:	89 3c 24             	mov    %edi,(%esp)
f0103d26:	e8 2d da ff ff       	call   f0101758 <_Z11page_removePjj>

		// find the pa and va of the page table
		pt = (pte_t *) KADDR(PTE_ADDR(pgdir[pdeno]));

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103d2b:	83 c3 01             	add    $0x1,%ebx
f0103d2e:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103d34:	75 d7                	jne    f0103d0d <_Z8env_freeP3Env+0xdc>
			if (pt[pteno] & PTE_P)
				page_remove(pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		pgdir[pdeno] = 0;
f0103d36:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103d39:	c7 04 97 00 00 00 00 	movl   $0x0,(%edi,%edx,4)
}

static inline struct Page *
kva2page(void *kva)
{
	return pa2page(PADDR(kva));
f0103d40:	81 7d d8 ff ff ff ef 	cmpl   $0xefffffff,-0x28(%ebp)
f0103d47:	77 23                	ja     f0103d6c <_Z8env_freeP3Env+0x13b>
f0103d49:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103d4c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103d50:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0103d57:	f0 
f0103d58:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
f0103d5f:	00 
f0103d60:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0103d67:	e8 bc c4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
}

static inline struct Page *
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103d6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103d6f:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f0103d75:	72 1c                	jb     f0103d93 <_Z8env_freeP3Env+0x162>
		panic("pa2page called with invalid pa");
f0103d77:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0103d7e:	f0 
f0103d7f:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0103d86:	00 
f0103d87:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0103d8e:	e8 95 c4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	return &pages[PGNUM(pa)];
f0103d93:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103d96:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
f0103d9d:	03 05 74 82 37 f0    	add    0xf0378274,%eax
		page_decref(kva2page(pt));
f0103da3:	89 04 24             	mov    %eax,(%esp)
f0103da6:	e8 6e d9 ff ff       	call   f0101719 <_Z11page_decrefP4Page>
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	pgdir = e->env_pgdir;
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103dab:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0103daf:	81 7d e0 bc 03 00 00 	cmpl   $0x3bc,-0x20(%ebp)
f0103db6:	0f 85 f2 fe ff ff    	jne    f0103cae <_Z8env_freeP3Env+0x7d>
		pgdir[pdeno] = 0;
		page_decref(kva2page(pt));
	}

	// free the page directory
	e->env_pgdir = 0;
f0103dbc:	8b 45 08             	mov    0x8(%ebp),%eax
f0103dbf:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
}

static inline struct Page *
kva2page(void *kva)
{
	return pa2page(PADDR(kva));
f0103dc6:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f0103dcc:	77 20                	ja     f0103dee <_Z8env_freeP3Env+0x1bd>
f0103dce:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0103dd2:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0103dd9:	f0 
f0103dda:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
f0103de1:	00 
f0103de2:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0103de9:	e8 3a c4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0103dee:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
}

static inline struct Page *
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103df4:	c1 e8 0c             	shr    $0xc,%eax
f0103df7:	3b 05 6c 82 37 f0    	cmp    0xf037826c,%eax
f0103dfd:	72 1c                	jb     f0103e1b <_Z8env_freeP3Env+0x1ea>
		panic("pa2page called with invalid pa");
f0103dff:	c7 44 24 08 84 81 10 	movl   $0xf0108184,0x8(%esp)
f0103e06:	f0 
f0103e07:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0103e0e:	00 
f0103e0f:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0103e16:	e8 0d c4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	return &pages[PGNUM(pa)];
f0103e1b:	c1 e0 03             	shl    $0x3,%eax
f0103e1e:	03 05 74 82 37 f0    	add    0xf0378274,%eax
	page_decref(kva2page(pgdir));
f0103e24:	89 04 24             	mov    %eax,(%esp)
f0103e27:	e8 ed d8 ff ff       	call   f0101719 <_Z11page_decrefP4Page>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103e2c:	8b 55 08             	mov    0x8(%ebp),%edx
f0103e2f:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
	e->env_link = env_free_list;
f0103e36:	a1 90 82 37 f0       	mov    0xf0378290,%eax
f0103e3b:	89 02                	mov    %eax,(%edx)
	env_free_list = e;
f0103e3d:	89 15 90 82 37 f0    	mov    %edx,0xf0378290
}
f0103e43:	83 c4 2c             	add    $0x2c,%esp
f0103e46:	5b                   	pop    %ebx
f0103e47:	5e                   	pop    %esi
f0103e48:	5f                   	pop    %edi
f0103e49:	5d                   	pop    %ebp
f0103e4a:	c3                   	ret    

f0103e4b <_Z11env_destroyP3Env>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103e4b:	55                   	push   %ebp
f0103e4c:	89 e5                	mov    %esp,%ebp
f0103e4e:	53                   	push   %ebx
f0103e4f:	83 ec 14             	sub    $0x14,%esp
f0103e52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	env_free(e);
f0103e55:	89 1c 24             	mov    %ebx,(%esp)
f0103e58:	e8 d4 fd ff ff       	call   f0103c31 <_Z8env_freeP3Env>

	if (curenv == e) {
f0103e5d:	39 1d 8c 82 37 f0    	cmp    %ebx,0xf037828c
f0103e63:	75 0f                	jne    f0103e74 <_Z11env_destroyP3Env+0x29>
		curenv = NULL;
f0103e65:	c7 05 8c 82 37 f0 00 	movl   $0x0,0xf037828c
f0103e6c:	00 00 00 
		sched_yield();
f0103e6f:	e8 fc 11 00 00       	call   f0105070 <_Z11sched_yieldv>
	}
}
f0103e74:	83 c4 14             	add    $0x14,%esp
f0103e77:	5b                   	pop    %ebx
f0103e78:	5d                   	pop    %ebp
f0103e79:	c3                   	ret    

f0103e7a <_Z8env_iretP9Trapframe>:
//
// This function does not return.
//
void
env_iret(struct Trapframe *tf)
{
f0103e7a:	55                   	push   %ebp
f0103e7b:	89 e5                	mov    %esp,%ebp
f0103e7d:	83 ec 18             	sub    $0x18,%esp
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\tpopal\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
f0103e80:	8b 65 08             	mov    0x8(%ebp),%esp
f0103e83:	07                   	pop    %es
f0103e84:	1f                   	pop    %ds
f0103e85:	61                   	popa   
f0103e86:	83 c4 08             	add    $0x8,%esp
f0103e89:	cf                   	iret   
	panic("iret failed");  /* mostly to placate the compiler */
f0103e8a:	c7 44 24 08 df 8b 10 	movl   $0xf0108bdf,0x8(%esp)
f0103e91:	f0 
f0103e92:	c7 44 24 04 a9 01 00 	movl   $0x1a9,0x4(%esp)
f0103e99:	00 
f0103e9a:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f0103ea1:	e8 82 c3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

f0103ea6 <_Z7env_runP3Env>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103ea6:	55                   	push   %ebp
f0103ea7:	89 e5                	mov    %esp,%ebp
f0103ea9:	83 ec 18             	sub    $0x18,%esp
f0103eac:	8b 45 08             	mov    0x8(%ebp),%eax
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
    curenv = e;
f0103eaf:	a3 8c 82 37 f0       	mov    %eax,0xf037828c
    curenv->env_runs++;
f0103eb4:	83 40 58 01          	addl   $0x1,0x58(%eax)
    lcr3(PADDR(e->env_pgdir));
f0103eb8:	8b 50 10             	mov    0x10(%eax),%edx
f0103ebb:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0103ec1:	77 20                	ja     f0103ee3 <_Z7env_runP3Env+0x3d>
f0103ec3:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103ec7:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0103ece:	f0 
f0103ecf:	c7 44 24 04 c5 01 00 	movl   $0x1c5,0x4(%esp)
f0103ed6:	00 
f0103ed7:	c7 04 24 97 8b 10 f0 	movl   $0xf0108b97,(%esp)
f0103ede:	e8 45 c3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0103ee3:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0103ee9:	0f 22 da             	mov    %edx,%cr3
    env_iret(&e->env_tf);
f0103eec:	83 c0 14             	add    $0x14,%eax
f0103eef:	89 04 24             	mov    %eax,(%esp)
f0103ef2:	e8 83 ff ff ff       	call   f0103e7a <_Z8env_iretP9Trapframe>
	...

f0103ef8 <_Z13mc146818_readj>:
#include <kern/picirq.h>


unsigned
mc146818_read(unsigned reg)
{
f0103ef8:	55                   	push   %ebp
f0103ef9:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103efb:	ba 70 00 00 00       	mov    $0x70,%edx
f0103f00:	8b 45 08             	mov    0x8(%ebp),%eax
f0103f03:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103f04:	b2 71                	mov    $0x71,%dl
f0103f06:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103f07:	0f b6 c0             	movzbl %al,%eax
}
f0103f0a:	5d                   	pop    %ebp
f0103f0b:	c3                   	ret    

f0103f0c <_Z14mc146818_writejj>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103f0c:	55                   	push   %ebp
f0103f0d:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103f0f:	ba 70 00 00 00       	mov    $0x70,%edx
f0103f14:	8b 45 08             	mov    0x8(%ebp),%eax
f0103f17:	ee                   	out    %al,(%dx)
f0103f18:	b2 71                	mov    $0x71,%dl
f0103f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103f1d:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103f1e:	5d                   	pop    %ebp
f0103f1f:	c3                   	ret    

f0103f20 <_Z11kclock_initv>:


void
kclock_init(void)
{
f0103f20:	55                   	push   %ebp
f0103f21:	89 e5                	mov    %esp,%ebp
f0103f23:	83 ec 18             	sub    $0x18,%esp
f0103f26:	ba 43 00 00 00       	mov    $0x43,%edx
f0103f2b:	b8 34 00 00 00       	mov    $0x34,%eax
f0103f30:	ee                   	out    %al,(%dx)
f0103f31:	b2 40                	mov    $0x40,%dl
f0103f33:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
f0103f38:	ee                   	out    %al,(%dx)
f0103f39:	b8 2e 00 00 00       	mov    $0x2e,%eax
f0103f3e:	ee                   	out    %al,(%dx)
	/* initialize 8253 clock to interrupt 100 times/sec */
	outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
	outb(IO_TIMER1, TIMER_DIV(100) % 256);
	outb(IO_TIMER1, TIMER_DIV(100) / 256);
	cprintf("	Setup timer interrupts via 8259A\n");
f0103f3f:	c7 04 24 ec 8b 10 f0 	movl   $0xf0108bec,(%esp)
f0103f46:	e8 67 01 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<0));
f0103f4b:	0f b7 05 04 80 12 f0 	movzwl 0xf0128004,%eax
f0103f52:	25 fe ff 00 00       	and    $0xfffe,%eax
f0103f57:	89 04 24             	mov    %eax,(%esp)
f0103f5a:	e8 11 00 00 00       	call   f0103f70 <_Z17irq_setmask_8259At>
	cprintf("	unmasked timer interrupt\n");
f0103f5f:	c7 04 24 0f 8c 10 f0 	movl   $0xf0108c0f,(%esp)
f0103f66:	e8 47 01 00 00       	call   f01040b2 <_Z7cprintfPKcz>
}
f0103f6b:	c9                   	leave  
f0103f6c:	c3                   	ret    
f0103f6d:	00 00                	add    %al,(%eax)
	...

f0103f70 <_Z17irq_setmask_8259At>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103f70:	55                   	push   %ebp
f0103f71:	89 e5                	mov    %esp,%ebp
f0103f73:	56                   	push   %esi
f0103f74:	53                   	push   %ebx
f0103f75:	83 ec 10             	sub    $0x10,%esp
f0103f78:	8b 55 08             	mov    0x8(%ebp),%edx
f0103f7b:	89 d0                	mov    %edx,%eax
	int i;
	irq_mask_8259A = mask;
f0103f7d:	66 89 15 04 80 12 f0 	mov    %dx,0xf0128004
	if (!didinit)
f0103f84:	80 3d 94 82 37 f0 00 	cmpb   $0x0,0xf0378294
f0103f8b:	74 4d                	je     f0103fda <_Z17irq_setmask_8259At+0x6a>
f0103f8d:	ba 21 00 00 00       	mov    $0x21,%edx
f0103f92:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103f93:	0f b7 f0             	movzwl %ax,%esi
f0103f96:	89 f0                	mov    %esi,%eax
f0103f98:	c1 f8 08             	sar    $0x8,%eax
f0103f9b:	b2 a1                	mov    $0xa1,%dl
f0103f9d:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103f9e:	c7 04 24 2a 8c 10 f0 	movl   $0xf0108c2a,(%esp)
f0103fa5:	e8 08 01 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	for (i = 0; i < 16; i++)
f0103faa:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103faf:	f7 d6                	not    %esi
f0103fb1:	0f a3 de             	bt     %ebx,%esi
f0103fb4:	73 10                	jae    f0103fc6 <_Z17irq_setmask_8259At+0x56>
			cprintf(" %d", i);
f0103fb6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103fba:	c7 04 24 af 91 10 f0 	movl   $0xf01091af,(%esp)
f0103fc1:	e8 ec 00 00 00       	call   f01040b2 <_Z7cprintfPKcz>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f0103fc6:	83 c3 01             	add    $0x1,%ebx
f0103fc9:	83 fb 10             	cmp    $0x10,%ebx
f0103fcc:	75 e3                	jne    f0103fb1 <_Z17irq_setmask_8259At+0x41>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f0103fce:	c7 04 24 2f 8b 10 f0 	movl   $0xf0108b2f,(%esp)
f0103fd5:	e8 d8 00 00 00       	call   f01040b2 <_Z7cprintfPKcz>
}
f0103fda:	83 c4 10             	add    $0x10,%esp
f0103fdd:	5b                   	pop    %ebx
f0103fde:	5e                   	pop    %esi
f0103fdf:	5d                   	pop    %ebp
f0103fe0:	c3                   	ret    

f0103fe1 <_Z8pic_initv>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0103fe1:	55                   	push   %ebp
f0103fe2:	89 e5                	mov    %esp,%ebp
f0103fe4:	83 ec 18             	sub    $0x18,%esp
	didinit = 1;
f0103fe7:	c6 05 94 82 37 f0 01 	movb   $0x1,0xf0378294
f0103fee:	ba 21 00 00 00       	mov    $0x21,%edx
f0103ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103ff8:	ee                   	out    %al,(%dx)
f0103ff9:	b2 a1                	mov    $0xa1,%dl
f0103ffb:	ee                   	out    %al,(%dx)
f0103ffc:	b2 20                	mov    $0x20,%dl
f0103ffe:	b8 11 00 00 00       	mov    $0x11,%eax
f0104003:	ee                   	out    %al,(%dx)
f0104004:	b2 21                	mov    $0x21,%dl
f0104006:	b8 20 00 00 00       	mov    $0x20,%eax
f010400b:	ee                   	out    %al,(%dx)
f010400c:	b8 04 00 00 00       	mov    $0x4,%eax
f0104011:	ee                   	out    %al,(%dx)
f0104012:	b8 03 00 00 00       	mov    $0x3,%eax
f0104017:	ee                   	out    %al,(%dx)
f0104018:	b2 a0                	mov    $0xa0,%dl
f010401a:	b8 11 00 00 00       	mov    $0x11,%eax
f010401f:	ee                   	out    %al,(%dx)
f0104020:	b2 a1                	mov    $0xa1,%dl
f0104022:	b8 28 00 00 00       	mov    $0x28,%eax
f0104027:	ee                   	out    %al,(%dx)
f0104028:	b8 02 00 00 00       	mov    $0x2,%eax
f010402d:	ee                   	out    %al,(%dx)
f010402e:	b8 01 00 00 00       	mov    $0x1,%eax
f0104033:	ee                   	out    %al,(%dx)
f0104034:	b2 20                	mov    $0x20,%dl
f0104036:	b8 68 00 00 00       	mov    $0x68,%eax
f010403b:	ee                   	out    %al,(%dx)
f010403c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104041:	ee                   	out    %al,(%dx)
f0104042:	b2 a0                	mov    $0xa0,%dl
f0104044:	b8 68 00 00 00       	mov    $0x68,%eax
f0104049:	ee                   	out    %al,(%dx)
f010404a:	b8 0a 00 00 00       	mov    $0xa,%eax
f010404f:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0104050:	0f b7 05 04 80 12 f0 	movzwl 0xf0128004,%eax
f0104057:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f010405b:	74 0b                	je     f0104068 <_Z8pic_initv+0x87>
		irq_setmask_8259A(irq_mask_8259A);
f010405d:	0f b7 c0             	movzwl %ax,%eax
f0104060:	89 04 24             	mov    %eax,(%esp)
f0104063:	e8 08 ff ff ff       	call   f0103f70 <_Z17irq_setmask_8259At>
}
f0104068:	c9                   	leave  
f0104069:	c3                   	ret    
	...

f010406c <_ZL5putchiPv>:
#include <inc/stdarg.h>


static void
putch(int ch, void *ptr)
{
f010406c:	55                   	push   %ebp
f010406d:	89 e5                	mov    %esp,%ebp
f010406f:	83 ec 18             	sub    $0x18,%esp
	int *cnt = (int *) ptr;
	cputchar(ch);
f0104072:	8b 45 08             	mov    0x8(%ebp),%eax
f0104075:	89 04 24             	mov    %eax,(%esp)
f0104078:	e8 85 cb ff ff       	call   f0100c02 <_Z8cputchari>
	*cnt++;
}
f010407d:	c9                   	leave  
f010407e:	c3                   	ret    

f010407f <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
f010407f:	55                   	push   %ebp
f0104080:	89 e5                	mov    %esp,%ebp
f0104082:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0104085:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt(&putch, &cnt, fmt, ap);
f010408c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010408f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104093:	8b 45 08             	mov    0x8(%ebp),%eax
f0104096:	89 44 24 08          	mov    %eax,0x8(%esp)
f010409a:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010409d:	89 44 24 04          	mov    %eax,0x4(%esp)
f01040a1:	c7 04 24 6c 40 10 f0 	movl   $0xf010406c,(%esp)
f01040a8:	e8 9a 1f 00 00       	call   f0106047 <_Z9vprintfmtPFviPvES_PKcPc>
	return cnt;
}
f01040ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01040b0:	c9                   	leave  
f01040b1:	c3                   	ret    

f01040b2 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
f01040b2:	55                   	push   %ebp
f01040b3:	89 e5                	mov    %esp,%ebp
f01040b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01040b8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01040bb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01040bf:	8b 45 08             	mov    0x8(%ebp),%eax
f01040c2:	89 04 24             	mov    %eax,(%esp)
f01040c5:	e8 b5 ff ff ff       	call   f010407f <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
f01040ca:	c9                   	leave  
f01040cb:	c3                   	ret    
f01040cc:	00 00                	add    %al,(%eax)
	...

f01040d0 <_Z8idt_initv>:
asmlinkage void handler48();


void
idt_init(void)
{
f01040d0:	55                   	push   %ebp
f01040d1:	89 e5                	mov    %esp,%ebp
	// Hint: Must this gate be accessible from userlevel?

	// LAB 3 (Exercise 4): Your code here.

    // DUMB GATE SETTINGS FOR HANDLERS 
    SETGATE(idt[IRQ_OFFSET+0], 0, 0x8, irqhandler0, 0);
f01040d3:	b8 f2 4f 10 f0       	mov    $0xf0104ff2,%eax
f01040d8:	66 a3 a0 83 37 f0    	mov    %ax,0xf03783a0
f01040de:	66 c7 05 a2 83 37 f0 	movw   $0x8,0xf03783a2
f01040e5:	08 00 
f01040e7:	c6 05 a4 83 37 f0 00 	movb   $0x0,0xf03783a4
f01040ee:	c6 05 a5 83 37 f0 8e 	movb   $0x8e,0xf03783a5
f01040f5:	c1 e8 10             	shr    $0x10,%eax
f01040f8:	66 a3 a6 83 37 f0    	mov    %ax,0xf03783a6
    SETGATE(idt[IRQ_OFFSET+1], 0, 0x8, irqhandler1, 0);
f01040fe:	b8 f8 4f 10 f0       	mov    $0xf0104ff8,%eax
f0104103:	66 a3 a8 83 37 f0    	mov    %ax,0xf03783a8
f0104109:	66 c7 05 aa 83 37 f0 	movw   $0x8,0xf03783aa
f0104110:	08 00 
f0104112:	c6 05 ac 83 37 f0 00 	movb   $0x0,0xf03783ac
f0104119:	c6 05 ad 83 37 f0 8e 	movb   $0x8e,0xf03783ad
f0104120:	c1 e8 10             	shr    $0x10,%eax
f0104123:	66 a3 ae 83 37 f0    	mov    %ax,0xf03783ae
    SETGATE(idt[IRQ_OFFSET+2], 0, 0x8, irqhandler2, 0);
f0104129:	b8 fe 4f 10 f0       	mov    $0xf0104ffe,%eax
f010412e:	66 a3 b0 83 37 f0    	mov    %ax,0xf03783b0
f0104134:	66 c7 05 b2 83 37 f0 	movw   $0x8,0xf03783b2
f010413b:	08 00 
f010413d:	c6 05 b4 83 37 f0 00 	movb   $0x0,0xf03783b4
f0104144:	c6 05 b5 83 37 f0 8e 	movb   $0x8e,0xf03783b5
f010414b:	c1 e8 10             	shr    $0x10,%eax
f010414e:	66 a3 b6 83 37 f0    	mov    %ax,0xf03783b6
    SETGATE(idt[IRQ_OFFSET+3], 0, 0x8, irqhandler3, 3);
f0104154:	b8 04 50 10 f0       	mov    $0xf0105004,%eax
f0104159:	66 a3 b8 83 37 f0    	mov    %ax,0xf03783b8
f010415f:	66 c7 05 ba 83 37 f0 	movw   $0x8,0xf03783ba
f0104166:	08 00 
f0104168:	c6 05 bc 83 37 f0 00 	movb   $0x0,0xf03783bc
f010416f:	c6 05 bd 83 37 f0 ee 	movb   $0xee,0xf03783bd
f0104176:	c1 e8 10             	shr    $0x10,%eax
f0104179:	66 a3 be 83 37 f0    	mov    %ax,0xf03783be
    SETGATE(idt[IRQ_OFFSET+4], 0, 0x8, irqhandler4, 0);
f010417f:	b8 0a 50 10 f0       	mov    $0xf010500a,%eax
f0104184:	66 a3 c0 83 37 f0    	mov    %ax,0xf03783c0
f010418a:	66 c7 05 c2 83 37 f0 	movw   $0x8,0xf03783c2
f0104191:	08 00 
f0104193:	c6 05 c4 83 37 f0 00 	movb   $0x0,0xf03783c4
f010419a:	c6 05 c5 83 37 f0 8e 	movb   $0x8e,0xf03783c5
f01041a1:	c1 e8 10             	shr    $0x10,%eax
f01041a4:	66 a3 c6 83 37 f0    	mov    %ax,0xf03783c6
    SETGATE(idt[IRQ_OFFSET+5], 0, 0x8, irqhandler5, 0);
f01041aa:	b8 10 50 10 f0       	mov    $0xf0105010,%eax
f01041af:	66 a3 c8 83 37 f0    	mov    %ax,0xf03783c8
f01041b5:	66 c7 05 ca 83 37 f0 	movw   $0x8,0xf03783ca
f01041bc:	08 00 
f01041be:	c6 05 cc 83 37 f0 00 	movb   $0x0,0xf03783cc
f01041c5:	c6 05 cd 83 37 f0 8e 	movb   $0x8e,0xf03783cd
f01041cc:	c1 e8 10             	shr    $0x10,%eax
f01041cf:	66 a3 ce 83 37 f0    	mov    %ax,0xf03783ce
    SETGATE(idt[IRQ_OFFSET+6], 0, 0x8, irqhandler6, 0);
f01041d5:	b8 16 50 10 f0       	mov    $0xf0105016,%eax
f01041da:	66 a3 d0 83 37 f0    	mov    %ax,0xf03783d0
f01041e0:	66 c7 05 d2 83 37 f0 	movw   $0x8,0xf03783d2
f01041e7:	08 00 
f01041e9:	c6 05 d4 83 37 f0 00 	movb   $0x0,0xf03783d4
f01041f0:	c6 05 d5 83 37 f0 8e 	movb   $0x8e,0xf03783d5
f01041f7:	c1 e8 10             	shr    $0x10,%eax
f01041fa:	66 a3 d6 83 37 f0    	mov    %ax,0xf03783d6
    SETGATE(idt[IRQ_OFFSET+7], 0, 0x8, irqhandler7, 0);
f0104200:	b8 1c 50 10 f0       	mov    $0xf010501c,%eax
f0104205:	66 a3 d8 83 37 f0    	mov    %ax,0xf03783d8
f010420b:	66 c7 05 da 83 37 f0 	movw   $0x8,0xf03783da
f0104212:	08 00 
f0104214:	c6 05 dc 83 37 f0 00 	movb   $0x0,0xf03783dc
f010421b:	c6 05 dd 83 37 f0 8e 	movb   $0x8e,0xf03783dd
f0104222:	c1 e8 10             	shr    $0x10,%eax
f0104225:	66 a3 de 83 37 f0    	mov    %ax,0xf03783de
    SETGATE(idt[IRQ_OFFSET+8], 0, 0x8, irqhandler8, 0);
f010422b:	b8 22 50 10 f0       	mov    $0xf0105022,%eax
f0104230:	66 a3 e0 83 37 f0    	mov    %ax,0xf03783e0
f0104236:	66 c7 05 e2 83 37 f0 	movw   $0x8,0xf03783e2
f010423d:	08 00 
f010423f:	c6 05 e4 83 37 f0 00 	movb   $0x0,0xf03783e4
f0104246:	c6 05 e5 83 37 f0 8e 	movb   $0x8e,0xf03783e5
f010424d:	c1 e8 10             	shr    $0x10,%eax
f0104250:	66 a3 e6 83 37 f0    	mov    %ax,0xf03783e6
    SETGATE(idt[IRQ_OFFSET+9], 0, 0x8, irqhandler9, 0);
f0104256:	b8 28 50 10 f0       	mov    $0xf0105028,%eax
f010425b:	66 a3 e8 83 37 f0    	mov    %ax,0xf03783e8
f0104261:	66 c7 05 ea 83 37 f0 	movw   $0x8,0xf03783ea
f0104268:	08 00 
f010426a:	c6 05 ec 83 37 f0 00 	movb   $0x0,0xf03783ec
f0104271:	c6 05 ed 83 37 f0 8e 	movb   $0x8e,0xf03783ed
f0104278:	c1 e8 10             	shr    $0x10,%eax
f010427b:	66 a3 ee 83 37 f0    	mov    %ax,0xf03783ee
    SETGATE(idt[IRQ_OFFSET+10], 0, 0x8, irqhandler10, 0);
f0104281:	b8 2e 50 10 f0       	mov    $0xf010502e,%eax
f0104286:	66 a3 f0 83 37 f0    	mov    %ax,0xf03783f0
f010428c:	66 c7 05 f2 83 37 f0 	movw   $0x8,0xf03783f2
f0104293:	08 00 
f0104295:	c6 05 f4 83 37 f0 00 	movb   $0x0,0xf03783f4
f010429c:	c6 05 f5 83 37 f0 8e 	movb   $0x8e,0xf03783f5
f01042a3:	c1 e8 10             	shr    $0x10,%eax
f01042a6:	66 a3 f6 83 37 f0    	mov    %ax,0xf03783f6
    SETGATE(idt[IRQ_OFFSET+11], 0, 0x8, irqhandler11, 0);
f01042ac:	b8 34 50 10 f0       	mov    $0xf0105034,%eax
f01042b1:	66 a3 f8 83 37 f0    	mov    %ax,0xf03783f8
f01042b7:	66 c7 05 fa 83 37 f0 	movw   $0x8,0xf03783fa
f01042be:	08 00 
f01042c0:	c6 05 fc 83 37 f0 00 	movb   $0x0,0xf03783fc
f01042c7:	c6 05 fd 83 37 f0 8e 	movb   $0x8e,0xf03783fd
f01042ce:	c1 e8 10             	shr    $0x10,%eax
f01042d1:	66 a3 fe 83 37 f0    	mov    %ax,0xf03783fe
    SETGATE(idt[IRQ_OFFSET+12], 0, 0x8, irqhandler12, 0);
f01042d7:	b8 3a 50 10 f0       	mov    $0xf010503a,%eax
f01042dc:	66 a3 00 84 37 f0    	mov    %ax,0xf0378400
f01042e2:	66 c7 05 02 84 37 f0 	movw   $0x8,0xf0378402
f01042e9:	08 00 
f01042eb:	c6 05 04 84 37 f0 00 	movb   $0x0,0xf0378404
f01042f2:	c6 05 05 84 37 f0 8e 	movb   $0x8e,0xf0378405
f01042f9:	c1 e8 10             	shr    $0x10,%eax
f01042fc:	66 a3 06 84 37 f0    	mov    %ax,0xf0378406
    SETGATE(idt[IRQ_OFFSET+13], 0, 0x8, irqhandler13, 0);
f0104302:	b8 40 50 10 f0       	mov    $0xf0105040,%eax
f0104307:	66 a3 08 84 37 f0    	mov    %ax,0xf0378408
f010430d:	66 c7 05 0a 84 37 f0 	movw   $0x8,0xf037840a
f0104314:	08 00 
f0104316:	c6 05 0c 84 37 f0 00 	movb   $0x0,0xf037840c
f010431d:	c6 05 0d 84 37 f0 8e 	movb   $0x8e,0xf037840d
f0104324:	c1 e8 10             	shr    $0x10,%eax
f0104327:	66 a3 0e 84 37 f0    	mov    %ax,0xf037840e
    SETGATE(idt[IRQ_OFFSET+14], 0, 0x8, irqhandler14, 0);
f010432d:	b8 46 50 10 f0       	mov    $0xf0105046,%eax
f0104332:	66 a3 10 84 37 f0    	mov    %ax,0xf0378410
f0104338:	66 c7 05 12 84 37 f0 	movw   $0x8,0xf0378412
f010433f:	08 00 
f0104341:	c6 05 14 84 37 f0 00 	movb   $0x0,0xf0378414
f0104348:	c6 05 15 84 37 f0 8e 	movb   $0x8e,0xf0378415
f010434f:	c1 e8 10             	shr    $0x10,%eax
f0104352:	66 a3 16 84 37 f0    	mov    %ax,0xf0378416
    SETGATE(idt[IRQ_OFFSET+15], 0, 0x8, irqhandler15, 0);
f0104358:	b8 4c 50 10 f0       	mov    $0xf010504c,%eax
f010435d:	66 a3 18 84 37 f0    	mov    %ax,0xf0378418
f0104363:	66 c7 05 1a 84 37 f0 	movw   $0x8,0xf037841a
f010436a:	08 00 
f010436c:	c6 05 1c 84 37 f0 00 	movb   $0x0,0xf037841c
f0104373:	c6 05 1d 84 37 f0 8e 	movb   $0x8e,0xf037841d
f010437a:	c1 e8 10             	shr    $0x10,%eax
f010437d:	66 a3 1e 84 37 f0    	mov    %ax,0xf037841e
    SETGATE(idt[0], 0, 0x8, handler0, 0);
f0104383:	b8 00 4f 10 f0       	mov    $0xf0104f00,%eax
f0104388:	66 a3 a0 82 37 f0    	mov    %ax,0xf03782a0
f010438e:	66 c7 05 a2 82 37 f0 	movw   $0x8,0xf03782a2
f0104395:	08 00 
f0104397:	c6 05 a4 82 37 f0 00 	movb   $0x0,0xf03782a4
f010439e:	c6 05 a5 82 37 f0 8e 	movb   $0x8e,0xf03782a5
f01043a5:	c1 e8 10             	shr    $0x10,%eax
f01043a8:	66 a3 a6 82 37 f0    	mov    %ax,0xf03782a6
    SETGATE(idt[1], 0, 0x8, handler1, 0);
f01043ae:	b8 0a 4f 10 f0       	mov    $0xf0104f0a,%eax
f01043b3:	66 a3 a8 82 37 f0    	mov    %ax,0xf03782a8
f01043b9:	66 c7 05 aa 82 37 f0 	movw   $0x8,0xf03782aa
f01043c0:	08 00 
f01043c2:	c6 05 ac 82 37 f0 00 	movb   $0x0,0xf03782ac
f01043c9:	c6 05 ad 82 37 f0 8e 	movb   $0x8e,0xf03782ad
f01043d0:	c1 e8 10             	shr    $0x10,%eax
f01043d3:	66 a3 ae 82 37 f0    	mov    %ax,0xf03782ae
    SETGATE(idt[2], 0, 0x8, handler2, 0);
f01043d9:	b8 14 4f 10 f0       	mov    $0xf0104f14,%eax
f01043de:	66 a3 b0 82 37 f0    	mov    %ax,0xf03782b0
f01043e4:	66 c7 05 b2 82 37 f0 	movw   $0x8,0xf03782b2
f01043eb:	08 00 
f01043ed:	c6 05 b4 82 37 f0 00 	movb   $0x0,0xf03782b4
f01043f4:	c6 05 b5 82 37 f0 8e 	movb   $0x8e,0xf03782b5
f01043fb:	c1 e8 10             	shr    $0x10,%eax
f01043fe:	66 a3 b6 82 37 f0    	mov    %ax,0xf03782b6
    SETGATE(idt[3], 0, 0x8, handler3, 3);
f0104404:	b8 1e 4f 10 f0       	mov    $0xf0104f1e,%eax
f0104409:	66 a3 b8 82 37 f0    	mov    %ax,0xf03782b8
f010440f:	66 c7 05 ba 82 37 f0 	movw   $0x8,0xf03782ba
f0104416:	08 00 
f0104418:	c6 05 bc 82 37 f0 00 	movb   $0x0,0xf03782bc
f010441f:	c6 05 bd 82 37 f0 ee 	movb   $0xee,0xf03782bd
f0104426:	c1 e8 10             	shr    $0x10,%eax
f0104429:	66 a3 be 82 37 f0    	mov    %ax,0xf03782be
    SETGATE(idt[4], 0, 0x8, handler4, 0);
f010442f:	b8 28 4f 10 f0       	mov    $0xf0104f28,%eax
f0104434:	66 a3 c0 82 37 f0    	mov    %ax,0xf03782c0
f010443a:	66 c7 05 c2 82 37 f0 	movw   $0x8,0xf03782c2
f0104441:	08 00 
f0104443:	c6 05 c4 82 37 f0 00 	movb   $0x0,0xf03782c4
f010444a:	c6 05 c5 82 37 f0 8e 	movb   $0x8e,0xf03782c5
f0104451:	c1 e8 10             	shr    $0x10,%eax
f0104454:	66 a3 c6 82 37 f0    	mov    %ax,0xf03782c6
    SETGATE(idt[5], 0, 0x8, handler5, 0);
f010445a:	b8 32 4f 10 f0       	mov    $0xf0104f32,%eax
f010445f:	66 a3 c8 82 37 f0    	mov    %ax,0xf03782c8
f0104465:	66 c7 05 ca 82 37 f0 	movw   $0x8,0xf03782ca
f010446c:	08 00 
f010446e:	c6 05 cc 82 37 f0 00 	movb   $0x0,0xf03782cc
f0104475:	c6 05 cd 82 37 f0 8e 	movb   $0x8e,0xf03782cd
f010447c:	c1 e8 10             	shr    $0x10,%eax
f010447f:	66 a3 ce 82 37 f0    	mov    %ax,0xf03782ce
    SETGATE(idt[6], 0, 0x8, handler6, 0);
f0104485:	b8 3c 4f 10 f0       	mov    $0xf0104f3c,%eax
f010448a:	66 a3 d0 82 37 f0    	mov    %ax,0xf03782d0
f0104490:	66 c7 05 d2 82 37 f0 	movw   $0x8,0xf03782d2
f0104497:	08 00 
f0104499:	c6 05 d4 82 37 f0 00 	movb   $0x0,0xf03782d4
f01044a0:	c6 05 d5 82 37 f0 8e 	movb   $0x8e,0xf03782d5
f01044a7:	c1 e8 10             	shr    $0x10,%eax
f01044aa:	66 a3 d6 82 37 f0    	mov    %ax,0xf03782d6
    SETGATE(idt[7], 0, 0x8, handler7, 0);
f01044b0:	b8 46 4f 10 f0       	mov    $0xf0104f46,%eax
f01044b5:	66 a3 d8 82 37 f0    	mov    %ax,0xf03782d8
f01044bb:	66 c7 05 da 82 37 f0 	movw   $0x8,0xf03782da
f01044c2:	08 00 
f01044c4:	c6 05 dc 82 37 f0 00 	movb   $0x0,0xf03782dc
f01044cb:	c6 05 dd 82 37 f0 8e 	movb   $0x8e,0xf03782dd
f01044d2:	c1 e8 10             	shr    $0x10,%eax
f01044d5:	66 a3 de 82 37 f0    	mov    %ax,0xf03782de
    SETGATE(idt[8], 0, 0x8, handler8, 0);
f01044db:	b8 50 4f 10 f0       	mov    $0xf0104f50,%eax
f01044e0:	66 a3 e0 82 37 f0    	mov    %ax,0xf03782e0
f01044e6:	66 c7 05 e2 82 37 f0 	movw   $0x8,0xf03782e2
f01044ed:	08 00 
f01044ef:	c6 05 e4 82 37 f0 00 	movb   $0x0,0xf03782e4
f01044f6:	c6 05 e5 82 37 f0 8e 	movb   $0x8e,0xf03782e5
f01044fd:	c1 e8 10             	shr    $0x10,%eax
f0104500:	66 a3 e6 82 37 f0    	mov    %ax,0xf03782e6
    SETGATE(idt[10], 0, 0x8, handler10, 0);
f0104506:	b8 58 4f 10 f0       	mov    $0xf0104f58,%eax
f010450b:	66 a3 f0 82 37 f0    	mov    %ax,0xf03782f0
f0104511:	66 c7 05 f2 82 37 f0 	movw   $0x8,0xf03782f2
f0104518:	08 00 
f010451a:	c6 05 f4 82 37 f0 00 	movb   $0x0,0xf03782f4
f0104521:	c6 05 f5 82 37 f0 8e 	movb   $0x8e,0xf03782f5
f0104528:	c1 e8 10             	shr    $0x10,%eax
f010452b:	66 a3 f6 82 37 f0    	mov    %ax,0xf03782f6
    SETGATE(idt[11], 0, 0x8, handler11, 0);
f0104531:	b8 60 4f 10 f0       	mov    $0xf0104f60,%eax
f0104536:	66 a3 f8 82 37 f0    	mov    %ax,0xf03782f8
f010453c:	66 c7 05 fa 82 37 f0 	movw   $0x8,0xf03782fa
f0104543:	08 00 
f0104545:	c6 05 fc 82 37 f0 00 	movb   $0x0,0xf03782fc
f010454c:	c6 05 fd 82 37 f0 8e 	movb   $0x8e,0xf03782fd
f0104553:	c1 e8 10             	shr    $0x10,%eax
f0104556:	66 a3 fe 82 37 f0    	mov    %ax,0xf03782fe
    SETGATE(idt[12], 0, 0x8, handler12, 0);
f010455c:	b8 68 4f 10 f0       	mov    $0xf0104f68,%eax
f0104561:	66 a3 00 83 37 f0    	mov    %ax,0xf0378300
f0104567:	66 c7 05 02 83 37 f0 	movw   $0x8,0xf0378302
f010456e:	08 00 
f0104570:	c6 05 04 83 37 f0 00 	movb   $0x0,0xf0378304
f0104577:	c6 05 05 83 37 f0 8e 	movb   $0x8e,0xf0378305
f010457e:	c1 e8 10             	shr    $0x10,%eax
f0104581:	66 a3 06 83 37 f0    	mov    %ax,0xf0378306
    SETGATE(idt[13], 0, 0x8, handler13, 0);
f0104587:	b8 70 4f 10 f0       	mov    $0xf0104f70,%eax
f010458c:	66 a3 08 83 37 f0    	mov    %ax,0xf0378308
f0104592:	66 c7 05 0a 83 37 f0 	movw   $0x8,0xf037830a
f0104599:	08 00 
f010459b:	c6 05 0c 83 37 f0 00 	movb   $0x0,0xf037830c
f01045a2:	c6 05 0d 83 37 f0 8e 	movb   $0x8e,0xf037830d
f01045a9:	c1 e8 10             	shr    $0x10,%eax
f01045ac:	66 a3 0e 83 37 f0    	mov    %ax,0xf037830e
    SETGATE(idt[14], 0, 0x8, handler14, 0);
f01045b2:	b8 78 4f 10 f0       	mov    $0xf0104f78,%eax
f01045b7:	66 a3 10 83 37 f0    	mov    %ax,0xf0378310
f01045bd:	66 c7 05 12 83 37 f0 	movw   $0x8,0xf0378312
f01045c4:	08 00 
f01045c6:	c6 05 14 83 37 f0 00 	movb   $0x0,0xf0378314
f01045cd:	c6 05 15 83 37 f0 8e 	movb   $0x8e,0xf0378315
f01045d4:	c1 e8 10             	shr    $0x10,%eax
f01045d7:	66 a3 16 83 37 f0    	mov    %ax,0xf0378316
    SETGATE(idt[16], 0, 0x8, handler16, 0);
f01045dd:	b8 80 4f 10 f0       	mov    $0xf0104f80,%eax
f01045e2:	66 a3 20 83 37 f0    	mov    %ax,0xf0378320
f01045e8:	66 c7 05 22 83 37 f0 	movw   $0x8,0xf0378322
f01045ef:	08 00 
f01045f1:	c6 05 24 83 37 f0 00 	movb   $0x0,0xf0378324
f01045f8:	c6 05 25 83 37 f0 8e 	movb   $0x8e,0xf0378325
f01045ff:	c1 e8 10             	shr    $0x10,%eax
f0104602:	66 a3 26 83 37 f0    	mov    %ax,0xf0378326
    SETGATE(idt[17], 0, 0x8, handler17, 0);
f0104608:	b8 8a 4f 10 f0       	mov    $0xf0104f8a,%eax
f010460d:	66 a3 28 83 37 f0    	mov    %ax,0xf0378328
f0104613:	66 c7 05 2a 83 37 f0 	movw   $0x8,0xf037832a
f010461a:	08 00 
f010461c:	c6 05 2c 83 37 f0 00 	movb   $0x0,0xf037832c
f0104623:	c6 05 2d 83 37 f0 8e 	movb   $0x8e,0xf037832d
f010462a:	c1 e8 10             	shr    $0x10,%eax
f010462d:	66 a3 2e 83 37 f0    	mov    %ax,0xf037832e
    SETGATE(idt[18], 0, 0x8, handler18, 0);
f0104633:	b8 92 4f 10 f0       	mov    $0xf0104f92,%eax
f0104638:	66 a3 30 83 37 f0    	mov    %ax,0xf0378330
f010463e:	66 c7 05 32 83 37 f0 	movw   $0x8,0xf0378332
f0104645:	08 00 
f0104647:	c6 05 34 83 37 f0 00 	movb   $0x0,0xf0378334
f010464e:	c6 05 35 83 37 f0 8e 	movb   $0x8e,0xf0378335
f0104655:	c1 e8 10             	shr    $0x10,%eax
f0104658:	66 a3 36 83 37 f0    	mov    %ax,0xf0378336
    SETGATE(idt[19], 0, 0x8, handler19, 0);
f010465e:	b8 9c 4f 10 f0       	mov    $0xf0104f9c,%eax
f0104663:	66 a3 38 83 37 f0    	mov    %ax,0xf0378338
f0104669:	66 c7 05 3a 83 37 f0 	movw   $0x8,0xf037833a
f0104670:	08 00 
f0104672:	c6 05 3c 83 37 f0 00 	movb   $0x0,0xf037833c
f0104679:	c6 05 3d 83 37 f0 8e 	movb   $0x8e,0xf037833d
f0104680:	c1 e8 10             	shr    $0x10,%eax
f0104683:	66 a3 3e 83 37 f0    	mov    %ax,0xf037833e
    SETGATE(idt[20], 0, 0x8, handler20, 0);
f0104689:	b8 a6 4f 10 f0       	mov    $0xf0104fa6,%eax
f010468e:	66 a3 40 83 37 f0    	mov    %ax,0xf0378340
f0104694:	66 c7 05 42 83 37 f0 	movw   $0x8,0xf0378342
f010469b:	08 00 
f010469d:	c6 05 44 83 37 f0 00 	movb   $0x0,0xf0378344
f01046a4:	c6 05 45 83 37 f0 8e 	movb   $0x8e,0xf0378345
f01046ab:	c1 e8 10             	shr    $0x10,%eax
f01046ae:	66 a3 46 83 37 f0    	mov    %ax,0xf0378346
    SETGATE(idt[21], 0, 0x8, handler21, 0);
f01046b4:	b8 b0 4f 10 f0       	mov    $0xf0104fb0,%eax
f01046b9:	66 a3 48 83 37 f0    	mov    %ax,0xf0378348
f01046bf:	66 c7 05 4a 83 37 f0 	movw   $0x8,0xf037834a
f01046c6:	08 00 
f01046c8:	c6 05 4c 83 37 f0 00 	movb   $0x0,0xf037834c
f01046cf:	c6 05 4d 83 37 f0 8e 	movb   $0x8e,0xf037834d
f01046d6:	c1 e8 10             	shr    $0x10,%eax
f01046d9:	66 a3 4e 83 37 f0    	mov    %ax,0xf037834e
    SETGATE(idt[22], 0, 0x8, handler22, 0);
f01046df:	b8 b8 4f 10 f0       	mov    $0xf0104fb8,%eax
f01046e4:	66 a3 50 83 37 f0    	mov    %ax,0xf0378350
f01046ea:	66 c7 05 52 83 37 f0 	movw   $0x8,0xf0378352
f01046f1:	08 00 
f01046f3:	c6 05 54 83 37 f0 00 	movb   $0x0,0xf0378354
f01046fa:	c6 05 55 83 37 f0 8e 	movb   $0x8e,0xf0378355
f0104701:	c1 e8 10             	shr    $0x10,%eax
f0104704:	66 a3 56 83 37 f0    	mov    %ax,0xf0378356
    SETGATE(idt[23], 0, 0x8, handler23, 0);
f010470a:	b8 c0 4f 10 f0       	mov    $0xf0104fc0,%eax
f010470f:	66 a3 58 83 37 f0    	mov    %ax,0xf0378358
f0104715:	66 c7 05 5a 83 37 f0 	movw   $0x8,0xf037835a
f010471c:	08 00 
f010471e:	c6 05 5c 83 37 f0 00 	movb   $0x0,0xf037835c
f0104725:	c6 05 5d 83 37 f0 8e 	movb   $0x8e,0xf037835d
f010472c:	c1 e8 10             	shr    $0x10,%eax
f010472f:	66 a3 5e 83 37 f0    	mov    %ax,0xf037835e
    SETGATE(idt[24], 0, 0x8, handler24, 0);
f0104735:	b8 c8 4f 10 f0       	mov    $0xf0104fc8,%eax
f010473a:	66 a3 60 83 37 f0    	mov    %ax,0xf0378360
f0104740:	66 c7 05 62 83 37 f0 	movw   $0x8,0xf0378362
f0104747:	08 00 
f0104749:	c6 05 64 83 37 f0 00 	movb   $0x0,0xf0378364
f0104750:	c6 05 65 83 37 f0 8e 	movb   $0x8e,0xf0378365
f0104757:	c1 e8 10             	shr    $0x10,%eax
f010475a:	66 a3 66 83 37 f0    	mov    %ax,0xf0378366
    SETGATE(idt[25], 0, 0x8, handler25, 0);
f0104760:	b8 d0 4f 10 f0       	mov    $0xf0104fd0,%eax
f0104765:	66 a3 68 83 37 f0    	mov    %ax,0xf0378368
f010476b:	66 c7 05 6a 83 37 f0 	movw   $0x8,0xf037836a
f0104772:	08 00 
f0104774:	c6 05 6c 83 37 f0 00 	movb   $0x0,0xf037836c
f010477b:	c6 05 6d 83 37 f0 8e 	movb   $0x8e,0xf037836d
f0104782:	c1 e8 10             	shr    $0x10,%eax
f0104785:	66 a3 6e 83 37 f0    	mov    %ax,0xf037836e
    SETGATE(idt[26], 0, 0x8, handler26, 0);
f010478b:	b8 d4 4f 10 f0       	mov    $0xf0104fd4,%eax
f0104790:	66 a3 70 83 37 f0    	mov    %ax,0xf0378370
f0104796:	66 c7 05 72 83 37 f0 	movw   $0x8,0xf0378372
f010479d:	08 00 
f010479f:	c6 05 74 83 37 f0 00 	movb   $0x0,0xf0378374
f01047a6:	c6 05 75 83 37 f0 8e 	movb   $0x8e,0xf0378375
f01047ad:	c1 e8 10             	shr    $0x10,%eax
f01047b0:	66 a3 76 83 37 f0    	mov    %ax,0xf0378376
    SETGATE(idt[27], 0, 0x8, handler27, 0);
f01047b6:	b8 d8 4f 10 f0       	mov    $0xf0104fd8,%eax
f01047bb:	66 a3 78 83 37 f0    	mov    %ax,0xf0378378
f01047c1:	66 c7 05 7a 83 37 f0 	movw   $0x8,0xf037837a
f01047c8:	08 00 
f01047ca:	c6 05 7c 83 37 f0 00 	movb   $0x0,0xf037837c
f01047d1:	c6 05 7d 83 37 f0 8e 	movb   $0x8e,0xf037837d
f01047d8:	c1 e8 10             	shr    $0x10,%eax
f01047db:	66 a3 7e 83 37 f0    	mov    %ax,0xf037837e
    SETGATE(idt[28], 0, 0x8, handler28, 0);
f01047e1:	b8 dc 4f 10 f0       	mov    $0xf0104fdc,%eax
f01047e6:	66 a3 80 83 37 f0    	mov    %ax,0xf0378380
f01047ec:	66 c7 05 82 83 37 f0 	movw   $0x8,0xf0378382
f01047f3:	08 00 
f01047f5:	c6 05 84 83 37 f0 00 	movb   $0x0,0xf0378384
f01047fc:	c6 05 85 83 37 f0 8e 	movb   $0x8e,0xf0378385
f0104803:	c1 e8 10             	shr    $0x10,%eax
f0104806:	66 a3 86 83 37 f0    	mov    %ax,0xf0378386
    SETGATE(idt[29], 0, 0x8, handler29, 0);
f010480c:	b8 e0 4f 10 f0       	mov    $0xf0104fe0,%eax
f0104811:	66 a3 88 83 37 f0    	mov    %ax,0xf0378388
f0104817:	66 c7 05 8a 83 37 f0 	movw   $0x8,0xf037838a
f010481e:	08 00 
f0104820:	c6 05 8c 83 37 f0 00 	movb   $0x0,0xf037838c
f0104827:	c6 05 8d 83 37 f0 8e 	movb   $0x8e,0xf037838d
f010482e:	c1 e8 10             	shr    $0x10,%eax
f0104831:	66 a3 8e 83 37 f0    	mov    %ax,0xf037838e
    SETGATE(idt[30], 0, 0x8, handler30, 0);
f0104837:	b8 e4 4f 10 f0       	mov    $0xf0104fe4,%eax
f010483c:	66 a3 90 83 37 f0    	mov    %ax,0xf0378390
f0104842:	66 c7 05 92 83 37 f0 	movw   $0x8,0xf0378392
f0104849:	08 00 
f010484b:	c6 05 94 83 37 f0 00 	movb   $0x0,0xf0378394
f0104852:	c6 05 95 83 37 f0 8e 	movb   $0x8e,0xf0378395
f0104859:	c1 e8 10             	shr    $0x10,%eax
f010485c:	66 a3 96 83 37 f0    	mov    %ax,0xf0378396
    SETGATE(idt[31], 0, 0x8, handler31, 0);
f0104862:	b8 e8 4f 10 f0       	mov    $0xf0104fe8,%eax
f0104867:	66 a3 98 83 37 f0    	mov    %ax,0xf0378398
f010486d:	66 c7 05 9a 83 37 f0 	movw   $0x8,0xf037839a
f0104874:	08 00 
f0104876:	c6 05 9c 83 37 f0 00 	movb   $0x0,0xf037839c
f010487d:	c6 05 9d 83 37 f0 8e 	movb   $0x8e,0xf037839d
f0104884:	c1 e8 10             	shr    $0x10,%eax
f0104887:	66 a3 9e 83 37 f0    	mov    %ax,0xf037839e
    SETGATE(idt[48], 0, 0x8, handler48, 3);
f010488d:	b8 ec 4f 10 f0       	mov    $0xf0104fec,%eax
f0104892:	66 a3 20 84 37 f0    	mov    %ax,0xf0378420
f0104898:	66 c7 05 22 84 37 f0 	movw   $0x8,0xf0378422
f010489f:	08 00 
f01048a1:	c6 05 24 84 37 f0 00 	movb   $0x0,0xf0378424
f01048a8:	c6 05 25 84 37 f0 ee 	movb   $0xee,0xf0378425
f01048af:	c1 e8 10             	shr    $0x10,%eax
f01048b2:	66 a3 26 84 37 f0    	mov    %ax,0xf0378426
	// Load the GDT (global [segment] descriptor table).
	// Segments serve many purposes on the x86.  We don't use any of their
	// memory-mapping capabilities, but we need them to set
	// privilege levels and to point to the task state segment.
	asm volatile("lgdt gdt_pd");
f01048b8:	0f 01 15 08 80 12 f0 	lgdtl  0xf0128008
	// Immediately reload segment registers.
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01048bf:	b8 23 00 00 00       	mov    $0x23,%eax
f01048c4:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f01048c6:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f01048c8:	b0 10                	mov    $0x10,%al
f01048ca:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f01048cc:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f01048ce:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f01048d0:	ea d7 48 10 f0 08 00 	ljmp   $0x8,$0xf01048d7
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	asm volatile("lldt %%ax" : : "a" (0));
f01048d7:	b0 00                	mov    $0x0,%al
f01048d9:	0f 00 d0             	lldt   %ax

	// Load the interrupt descriptor table (IDT).
	asm volatile("lidt idt_pd");
f01048dc:	0f 01 1d 0e 80 12 f0 	lidtl  0xf012800e

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f01048e3:	c7 05 e4 8a 37 f0 00 	movl   $0xf0000000,0xf0378ae4
f01048ea:	00 00 f0 
	ts.ts_ss0 = GD_KD;
f01048ed:	66 c7 05 e8 8a 37 f0 	movw   $0x10,0xf0378ae8
f01048f4:	10 00 
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f01048f6:	b0 28                	mov    $0x28,%al
f01048f8:	0f 00 d8             	ltr    %ax

	// Load the TSS.
	ltr(GD_TSS);
}
f01048fb:	5d                   	pop    %ebp
f01048fc:	c3                   	ret    

f01048fd <_Z10print_regsP8PushRegs>:
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
}

void
print_regs(struct PushRegs *regs)
{
f01048fd:	55                   	push   %ebp
f01048fe:	89 e5                	mov    %esp,%ebp
f0104900:	53                   	push   %ebx
f0104901:	83 ec 14             	sub    $0x14,%esp
f0104904:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104907:	8b 03                	mov    (%ebx),%eax
f0104909:	89 44 24 04          	mov    %eax,0x4(%esp)
f010490d:	c7 04 24 3e 8c 10 f0 	movl   $0xf0108c3e,(%esp)
f0104914:	e8 99 f7 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104919:	8b 43 04             	mov    0x4(%ebx),%eax
f010491c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104920:	c7 04 24 4d 8c 10 f0 	movl   $0xf0108c4d,(%esp)
f0104927:	e8 86 f7 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f010492c:	8b 43 08             	mov    0x8(%ebx),%eax
f010492f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104933:	c7 04 24 5c 8c 10 f0 	movl   $0xf0108c5c,(%esp)
f010493a:	e8 73 f7 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f010493f:	8b 43 0c             	mov    0xc(%ebx),%eax
f0104942:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104946:	c7 04 24 6b 8c 10 f0 	movl   $0xf0108c6b,(%esp)
f010494d:	e8 60 f7 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104952:	8b 43 10             	mov    0x10(%ebx),%eax
f0104955:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104959:	c7 04 24 7a 8c 10 f0 	movl   $0xf0108c7a,(%esp)
f0104960:	e8 4d f7 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104965:	8b 43 14             	mov    0x14(%ebx),%eax
f0104968:	89 44 24 04          	mov    %eax,0x4(%esp)
f010496c:	c7 04 24 89 8c 10 f0 	movl   $0xf0108c89,(%esp)
f0104973:	e8 3a f7 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104978:	8b 43 18             	mov    0x18(%ebx),%eax
f010497b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010497f:	c7 04 24 98 8c 10 f0 	movl   $0xf0108c98,(%esp)
f0104986:	e8 27 f7 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f010498b:	8b 43 1c             	mov    0x1c(%ebx),%eax
f010498e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104992:	c7 04 24 a7 8c 10 f0 	movl   $0xf0108ca7,(%esp)
f0104999:	e8 14 f7 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
}
f010499e:	83 c4 14             	add    $0x14,%esp
f01049a1:	5b                   	pop    %ebx
f01049a2:	5d                   	pop    %ebp
f01049a3:	c3                   	ret    

f01049a4 <_Z15print_trapframeP9Trapframeb>:
}


void
print_trapframe(struct Trapframe *tf, bool trap_just_happened)
{
f01049a4:	55                   	push   %ebp
f01049a5:	89 e5                	mov    %esp,%ebp
f01049a7:	56                   	push   %esi
f01049a8:	53                   	push   %ebx
f01049a9:	83 ec 10             	sub    $0x10,%esp
f01049ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01049af:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	cprintf("Trap frame at %p\n", tf);
f01049b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01049b7:	c7 04 24 ee 8c 10 f0 	movl   $0xf0108cee,(%esp)
f01049be:	e8 ef f6 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	print_regs(&tf->tf_regs);
f01049c3:	8d 43 08             	lea    0x8(%ebx),%eax
f01049c6:	89 04 24             	mov    %eax,(%esp)
f01049c9:	e8 2f ff ff ff       	call   f01048fd <_Z10print_regsP8PushRegs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01049ce:	0f b7 03             	movzwl (%ebx),%eax
f01049d1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01049d5:	c7 04 24 00 8d 10 f0 	movl   $0xf0108d00,(%esp)
f01049dc:	e8 d1 f6 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01049e1:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
f01049e5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01049e9:	c7 04 24 13 8d 10 f0 	movl   $0xf0108d13,(%esp)
f01049f0:	e8 bd f6 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  trap 0x%08x %s", tf->tf_trapno, trapname(tf->tf_trapno));
f01049f5:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < (int) (sizeof(excnames)/sizeof(excnames[0])))
f01049f8:	83 f8 13             	cmp    $0x13,%eax
f01049fb:	7f 09                	jg     f0104a06 <_Z15print_trapframeP9Trapframeb+0x62>
		return excnames[trapno];
f01049fd:	8b 14 85 80 90 10 f0 	mov    -0xfef6f80(,%eax,4),%edx
f0104a04:	eb 1d                	jmp    f0104a23 <_Z15print_trapframeP9Trapframeb+0x7f>
	if (trapno == T_SYSCALL)
		return "System call";
f0104a06:	ba b6 8c 10 f0       	mov    $0xf0108cb6,%edx
		"SIMD Floating-Point Exception"
	};

	if (trapno < (int) (sizeof(excnames)/sizeof(excnames[0])))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
f0104a0b:	83 f8 30             	cmp    $0x30,%eax
f0104a0e:	74 13                	je     f0104a23 <_Z15print_trapframeP9Trapframeb+0x7f>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104a10:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0104a13:	83 fa 0f             	cmp    $0xf,%edx
f0104a16:	ba c2 8c 10 f0       	mov    $0xf0108cc2,%edx
f0104a1b:	b9 d5 8c 10 f0       	mov    $0xf0108cd5,%ecx
f0104a20:	0f 47 d1             	cmova  %ecx,%edx
{
	cprintf("Trap frame at %p\n", tf);
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s", tf->tf_trapno, trapname(tf->tf_trapno));
f0104a23:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104a27:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a2b:	c7 04 24 26 8d 10 f0 	movl   $0xf0108d26,(%esp)
f0104a32:	e8 7b f6 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (trap_just_happened && tf->tf_trapno == T_PGFLT)
f0104a37:	89 f0                	mov    %esi,%eax
f0104a39:	84 c0                	test   %al,%al
f0104a3b:	74 19                	je     f0104a56 <_Z15print_trapframeP9Trapframeb+0xb2>
f0104a3d:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104a41:	75 13                	jne    f0104a56 <_Z15print_trapframeP9Trapframeb+0xb2>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0104a43:	0f 20 d0             	mov    %cr2,%eax
		cprintf(" [la 0x%08x]", rcr2());
f0104a46:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a4a:	c7 04 24 37 8d 10 f0 	movl   $0xf0108d37,(%esp)
f0104a51:	e8 5c f6 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("\n  err  0x%08x", tf->tf_err);
f0104a56:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104a59:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a5d:	c7 04 24 44 8d 10 f0 	movl   $0xf0108d44,(%esp)
f0104a64:	e8 49 f6 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	// For page faults, print unparsed fault error code:
	// U=fault occurred in user mode (K=kernel),
	// WR=a write caused the fault (R=read),
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0104a69:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104a6d:	75 4f                	jne    f0104abe <_Z15print_trapframeP9Trapframeb+0x11a>
		cprintf(" [fault err %s,%s,%s]",
			tf->tf_err & 4 ? "U" : "K",
			tf->tf_err & 2 ? "W" : "R",
			tf->tf_err & 1 ? "PR" : "NP");
f0104a6f:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104a72:	89 c2                	mov    %eax,%edx
f0104a74:	83 e2 01             	and    $0x1,%edx
f0104a77:	ba e4 8c 10 f0       	mov    $0xf0108ce4,%edx
f0104a7c:	b9 e7 8c 10 f0       	mov    $0xf0108ce7,%ecx
f0104a81:	0f 45 ca             	cmovne %edx,%ecx
f0104a84:	89 c2                	mov    %eax,%edx
f0104a86:	83 e2 02             	and    $0x2,%edx
f0104a89:	ba ea 8c 10 f0       	mov    $0xf0108cea,%edx
f0104a8e:	be e5 8c 10 f0       	mov    $0xf0108ce5,%esi
f0104a93:	0f 44 d6             	cmove  %esi,%edx
f0104a96:	83 e0 04             	and    $0x4,%eax
f0104a99:	b8 b4 8a 10 f0       	mov    $0xf0108ab4,%eax
f0104a9e:	be ec 8c 10 f0       	mov    $0xf0108cec,%esi
f0104aa3:	0f 44 c6             	cmove  %esi,%eax
f0104aa6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0104aaa:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104aae:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ab2:	c7 04 24 53 8d 10 f0 	movl   $0xf0108d53,(%esp)
f0104ab9:	e8 f4 f5 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("\n  eip  0x%08x\n", tf->tf_eip);
f0104abe:	8b 43 30             	mov    0x30(%ebx),%eax
f0104ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ac5:	c7 04 24 69 8d 10 f0 	movl   $0xf0108d69,(%esp)
f0104acc:	e8 e1 f5 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104ad1:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ad9:	c7 04 24 79 8d 10 f0 	movl   $0xf0108d79,(%esp)
f0104ae0:	e8 cd f5 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104ae5:	8b 43 38             	mov    0x38(%ebx),%eax
f0104ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104aec:	c7 04 24 8c 8d 10 f0 	movl   $0xf0108d8c,(%esp)
f0104af3:	e8 ba f5 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104af8:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104afb:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104aff:	c7 04 24 9b 8d 10 f0 	movl   $0xf0108d9b,(%esp)
f0104b06:	e8 a7 f5 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104b0b:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104b13:	c7 04 24 aa 8d 10 f0 	movl   $0xf0108daa,(%esp)
f0104b1a:	e8 93 f5 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
}
f0104b1f:	83 c4 10             	add    $0x10,%esp
f0104b22:	5b                   	pop    %ebx
f0104b23:	5e                   	pop    %esi
f0104b24:	5d                   	pop    %ebp
f0104b25:	c3                   	ret    

f0104b26 <_Z15set_e1000_irqnoh>:

static uint8_t e1000_irqno = 0;

void
set_e1000_irqno(uint8_t e)
{
f0104b26:	55                   	push   %ebp
f0104b27:	89 e5                	mov    %esp,%ebp
    e1000_irqno = e;
f0104b29:	8b 45 08             	mov    0x8(%ebp),%eax
f0104b2c:	a2 48 8b 37 f0       	mov    %al,0xf0378b48
}
f0104b31:	5d                   	pop    %ebp
f0104b32:	c3                   	ret    

f0104b33 <_Z18page_fault_handlerP9Trapframe>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104b33:	55                   	push   %ebp
f0104b34:	89 e5                	mov    %esp,%ebp
f0104b36:	57                   	push   %edi
f0104b37:	56                   	push   %esi
f0104b38:	53                   	push   %ebx
f0104b39:	83 ec 3c             	sub    $0x3c,%esp
f0104b3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104b3f:	0f 20 d0             	mov    %cr2,%eax
f0104b42:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Page faults in the kernel should cause a panic.
	// LAB 3 (Exercise 8): Your code here.
    if (tf->tf_cs == GD_KT)
f0104b45:	66 83 7b 34 08       	cmpw   $0x8,0x34(%ebx)
f0104b4a:	75 2c                	jne    f0104b78 <_Z18page_fault_handlerP9Trapframe+0x45>
    {
        print_trapframe(tf, true);
f0104b4c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0104b53:	00 
f0104b54:	89 1c 24             	mov    %ebx,(%esp)
f0104b57:	e8 48 fe ff ff       	call   f01049a4 <_Z15print_trapframeP9Trapframeb>
        panic("Page fault in kernel!!");
f0104b5c:	c7 44 24 08 bd 8d 10 	movl   $0xf0108dbd,0x8(%esp)
f0104b63:	f0 
f0104b64:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
f0104b6b:	00 
f0104b6c:	c7 04 24 d4 8d 10 f0 	movl   $0xf0108dd4,(%esp)
f0104b73:	e8 b0 b6 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	// LAB 4: Your code here.
    
	pte_t *pte = NULL;
    uint32_t *trap_addr = NULL;

    if(!curenv->env_pgfault_upcall) 
f0104b78:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0104b7d:	83 78 5c 00          	cmpl   $0x0,0x5c(%eax)
f0104b81:	75 31                	jne    f0104bb4 <_Z18page_fault_handlerP9Trapframe+0x81>
    {
        cprintf("[%08x] user fault va %08x ip %08x\n",
            curenv->env_id, fault_va, tf->tf_eip);
f0104b83:	8b 53 30             	mov    0x30(%ebx),%edx
f0104b86:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0104b8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104b8d:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104b91:	8b 40 04             	mov    0x4(%eax),%eax
f0104b94:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104b98:	c7 04 24 7c 8f 10 f0 	movl   $0xf0108f7c,(%esp)
f0104b9f:	e8 0e f5 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
        print_trapframe(tf, true);
f0104ba4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0104bab:	00 
f0104bac:	89 1c 24             	mov    %ebx,(%esp)
f0104baf:	e8 f0 fd ff ff       	call   f01049a4 <_Z15print_trapframeP9Trapframeb>
    }
    user_mem_assert(curenv, curenv->env_pgfault_upcall, 1, PTE_U | PTE_P);
f0104bb4:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0104bb9:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f0104bc0:	00 
f0104bc1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104bc8:	00 
f0104bc9:	8b 50 5c             	mov    0x5c(%eax),%edx
f0104bcc:	89 54 24 04          	mov    %edx,0x4(%esp)
f0104bd0:	89 04 24             	mov    %eax,(%esp)
f0104bd3:	e8 b3 ea ff ff       	call   f010368b <_Z15user_mem_assertP3Envjjj>
    user_mem_assert(curenv, UXSTACKTOP-PGSIZE, PGSIZE, PTE_U | PTE_P | PTE_W);
f0104bd8:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0104bdf:	00 
f0104be0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0104be7:	00 
f0104be8:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
f0104bef:	ee 
f0104bf0:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0104bf5:	89 04 24             	mov    %eax,(%esp)
f0104bf8:	e8 8e ea ff ff       	call   f010368b <_Z15user_mem_assertP3Envjjj>
    
    if (tf->tf_esp >= USTACKTOP)
f0104bfd:	8b 43 3c             	mov    0x3c(%ebx),%eax
        if (tf->tf_esp - 14 < UXSTACKTOP - PGSIZE || tf->tf_esp > UXSTACKTOP-1)
            env_destroy(curenv);
        trap_addr = (uint32_t *)tf->tf_esp;
    }
    else
        trap_addr = (uint32_t *)UXSTACKTOP;
f0104c00:	be 00 00 00 ef       	mov    $0xef000000,%esi
        print_trapframe(tf, true);
    }
    user_mem_assert(curenv, curenv->env_pgfault_upcall, 1, PTE_U | PTE_P);
    user_mem_assert(curenv, UXSTACKTOP-PGSIZE, PGSIZE, PTE_U | PTE_P | PTE_W);
    
    if (tf->tf_esp >= USTACKTOP)
f0104c05:	3d ff df ff ee       	cmp    $0xeeffdfff,%eax
f0104c0a:	76 22                	jbe    f0104c2e <_Z18page_fault_handlerP9Trapframe+0xfb>
    {
        if (tf->tf_esp - 14 < UXSTACKTOP - PGSIZE || tf->tf_esp > UXSTACKTOP-1)
f0104c0c:	8d 50 f2             	lea    -0xe(%eax),%edx
f0104c0f:	81 fa ff ef ff ee    	cmp    $0xeeffefff,%edx
f0104c15:	76 07                	jbe    f0104c1e <_Z18page_fault_handlerP9Trapframe+0xeb>
f0104c17:	3d ff ff ff ee       	cmp    $0xeeffffff,%eax
f0104c1c:	76 0d                	jbe    f0104c2b <_Z18page_fault_handlerP9Trapframe+0xf8>
            env_destroy(curenv);
f0104c1e:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0104c23:	89 04 24             	mov    %eax,(%esp)
f0104c26:	e8 20 f2 ff ff       	call   f0103e4b <_Z11env_destroyP3Env>
        trap_addr = (uint32_t *)tf->tf_esp;
f0104c2b:	8b 73 3c             	mov    0x3c(%ebx),%esi
    }
    else
        trap_addr = (uint32_t *)UXSTACKTOP;
    trap_addr -= 3;
f0104c2e:	8d 7e f4             	lea    -0xc(%esi),%edi
    user_mem_assert(curenv, tf->tf_esp - 4, 4, PTE_U | PTE_P);
f0104c31:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f0104c38:	00 
f0104c39:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0104c40:	00 
f0104c41:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104c44:	83 e8 04             	sub    $0x4,%eax
f0104c47:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104c4b:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0104c50:	89 04 24             	mov    %eax,(%esp)
f0104c53:	e8 33 ea ff ff       	call   f010368b <_Z15user_mem_assertP3Envjjj>
    memcpy(trap_addr, (uint32_t [])
           {tf->tf_eflags, (uint32_t)tf->tf_esp, tf->tf_eip}, 12);
f0104c58:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104c5b:	8b 4b 30             	mov    0x30(%ebx),%ecx
f0104c5e:	8b 53 38             	mov    0x38(%ebx),%edx
f0104c61:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0104c64:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104c67:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0104c6a:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
f0104c71:	00 
f0104c72:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104c75:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104c79:	89 3c 24             	mov    %edi,(%esp)
f0104c7c:	e8 56 1b 00 00       	call   f01067d7 <memcpy>
    trap_addr -= sizeof(tf->tf_regs)/sizeof(uint32_t);
f0104c81:	8d 7e d4             	lea    -0x2c(%esi),%edi
    memcpy(trap_addr, &tf->tf_regs, sizeof(tf->tf_regs));
f0104c84:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
f0104c8b:	00 
f0104c8c:	8d 43 08             	lea    0x8(%ebx),%eax
f0104c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104c93:	89 3c 24             	mov    %edi,(%esp)
f0104c96:	e8 3c 1b 00 00       	call   f01067d7 <memcpy>
    *(trap_addr - 1) = tf->tf_err;
f0104c9b:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104c9e:	89 46 d0             	mov    %eax,-0x30(%esi)
    *(trap_addr - 2) = fault_va;
f0104ca1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104ca4:	89 46 cc             	mov    %eax,-0x34(%esi)
    tf->tf_esp = (uint32_t)(trap_addr - 3);
f0104ca7:	83 ee 38             	sub    $0x38,%esi
f0104caa:	89 73 3c             	mov    %esi,0x3c(%ebx)
    tf->tf_eip = curenv->env_pgfault_upcall;
f0104cad:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0104cb2:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104cb5:	89 43 30             	mov    %eax,0x30(%ebx)
    return;
}
f0104cb8:	83 c4 3c             	add    $0x3c,%esp
f0104cbb:	5b                   	pop    %ebx
f0104cbc:	5e                   	pop    %esi
f0104cbd:	5f                   	pop    %edi
f0104cbe:	5d                   	pop    %ebp
f0104cbf:	c3                   	ret    

f0104cc0 <trap>:
    }
}

asmlinkage void
trap(struct Trapframe *tf)
{
f0104cc0:	55                   	push   %ebp
f0104cc1:	89 e5                	mov    %esp,%ebp
f0104cc3:	57                   	push   %edi
f0104cc4:	56                   	push   %esi
f0104cc5:	83 ec 20             	sub    $0x20,%esp
f0104cc8:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" : : : "cc");
f0104ccb:	fc                   	cld    

static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
f0104ccc:	9c                   	pushf  
f0104ccd:	58                   	pop    %eax

	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0104cce:	f6 c4 02             	test   $0x2,%ah
f0104cd1:	74 24                	je     f0104cf7 <trap+0x37>
f0104cd3:	c7 44 24 0c e0 8d 10 	movl   $0xf0108de0,0xc(%esp)
f0104cda:	f0 
f0104cdb:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0104ce2:	f0 
f0104ce3:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
f0104cea:	00 
f0104ceb:	c7 04 24 d4 8d 10 f0 	movl   $0xf0108dd4,(%esp)
f0104cf2:	e8 31 b5 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	if ((tf->tf_cs & 3) == 3) {
f0104cf7:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104cfb:	83 e0 03             	and    $0x3,%eax
f0104cfe:	83 f8 03             	cmp    $0x3,%eax
f0104d01:	75 3a                	jne    f0104d3d <trap+0x7d>
		// Trapped from user mode.
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		assert(curenv);
f0104d03:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0104d08:	85 c0                	test   %eax,%eax
f0104d0a:	75 24                	jne    f0104d30 <trap+0x70>
f0104d0c:	c7 44 24 0c f9 8d 10 	movl   $0xf0108df9,0xc(%esp)
f0104d13:	f0 
f0104d14:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0104d1b:	f0 
f0104d1c:	c7 44 24 04 68 01 00 	movl   $0x168,0x4(%esp)
f0104d23:	00 
f0104d24:	c7 04 24 d4 8d 10 f0 	movl   $0xf0108dd4,(%esp)
f0104d2b:	e8 f8 b4 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
		curenv->env_tf = *tf;
f0104d30:	8d 78 14             	lea    0x14(%eax),%edi
f0104d33:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104d38:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0104d3a:	8d 70 14             	lea    0x14(%eax),%esi
	// LAB 5: Your code here.

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104d3d:	8b 46 28             	mov    0x28(%esi),%eax
f0104d40:	83 f8 27             	cmp    $0x27,%eax
f0104d43:	75 21                	jne    f0104d66 <trap+0xa6>
		cprintf("Spurious interrupt on irq 7\n");
f0104d45:	c7 04 24 00 8e 10 f0 	movl   $0xf0108e00,(%esp)
f0104d4c:	e8 61 f3 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
		print_trapframe(tf, true);
f0104d51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0104d58:	00 
f0104d59:	89 34 24             	mov    %esi,(%esp)
f0104d5c:	e8 43 fc ff ff       	call   f01049a4 <_Z15print_trapframeP9Trapframeb>
f0104d61:	e9 d6 00 00 00       	jmp    f0104e3c <trap+0x17c>
		return;
	}

    if (e1000_irqno && tf->tf_trapno == (uint32_t)IRQ_OFFSET + e1000_irqno)
f0104d66:	0f b6 15 48 8b 37 f0 	movzbl 0xf0378b48,%edx
f0104d6d:	84 d2                	test   %dl,%dl
f0104d6f:	74 14                	je     f0104d85 <trap+0xc5>
f0104d71:	0f b6 d2             	movzbl %dl,%edx
f0104d74:	83 c2 20             	add    $0x20,%edx
f0104d77:	39 d0                	cmp    %edx,%eax
f0104d79:	75 0a                	jne    f0104d85 <trap+0xc5>
    {
        e1000_trap_handler();
f0104d7b:	e8 03 1c 00 00       	call   f0106983 <_Z18e1000_trap_handlerv>
f0104d80:	e9 b7 00 00 00       	jmp    f0104e3c <trap+0x17c>
        return;
    }

    switch (tf->tf_trapno)
f0104d85:	83 e8 03             	sub    $0x3,%eax
f0104d88:	83 f8 2d             	cmp    $0x2d,%eax
f0104d8b:	77 6f                	ja     f0104dfc <trap+0x13c>
f0104d8d:	8d 76 00             	lea    0x0(%esi),%esi
f0104d90:	ff 24 85 a0 8f 10 f0 	jmp    *-0xfef7060(,%eax,4)
    {
        case T_BRKPT:
        monitor(tf);
f0104d97:	89 34 24             	mov    %esi,(%esp)
f0104d9a:	e8 b5 c3 ff ff       	call   f0101154 <_Z7monitorP9Trapframe>
f0104d9f:	90                   	nop
f0104da0:	e9 97 00 00 00       	jmp    f0104e3c <trap+0x17c>
        break;
        case T_PGFLT:
        page_fault_handler(tf);
f0104da5:	89 34 24             	mov    %esi,(%esp)
f0104da8:	e8 86 fd ff ff       	call   f0104b33 <_Z18page_fault_handlerP9Trapframe>
f0104dad:	8d 76 00             	lea    0x0(%esi),%esi
f0104db0:	e9 87 00 00 00       	jmp    f0104e3c <trap+0x17c>
        break;
        case T_SYSCALL:
        tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,tf->tf_regs.reg_ebx,tf->tf_regs.reg_edi,tf->tf_regs.reg_esi);
f0104db5:	8b 46 0c             	mov    0xc(%esi),%eax
f0104db8:	89 44 24 14          	mov    %eax,0x14(%esp)
f0104dbc:	8b 46 08             	mov    0x8(%esi),%eax
f0104dbf:	89 44 24 10          	mov    %eax,0x10(%esp)
f0104dc3:	8b 46 18             	mov    0x18(%esi),%eax
f0104dc6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104dca:	8b 46 20             	mov    0x20(%esi),%eax
f0104dcd:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104dd1:	8b 46 1c             	mov    0x1c(%esi),%eax
f0104dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104dd8:	8b 46 24             	mov    0x24(%esi),%eax
f0104ddb:	89 04 24             	mov    %eax,(%esp)
f0104dde:	e8 4d 03 00 00       	call   f0105130 <_Z7syscalljjjjjj>
f0104de3:	89 46 24             	mov    %eax,0x24(%esi)
f0104de6:	eb 54                	jmp    f0104e3c <trap+0x17c>
        break;
	    // Unexpected trap: The user process or the kernel has a bug.
        case IRQ_KBD+IRQ_OFFSET:
        kbd_intr();
f0104de8:	e8 a5 ba ff ff       	call   f0100892 <_Z8kbd_intrv>
f0104ded:	8d 76 00             	lea    0x0(%esi),%esi
f0104df0:	eb 4a                	jmp    f0104e3c <trap+0x17c>
        break;
        case IRQ_TIMER+IRQ_OFFSET:
        time_tick();
f0104df2:	e8 44 27 00 00       	call   f010753b <_Z9time_tickv>
        sched_yield();
f0104df7:	e8 74 02 00 00       	call   f0105070 <_Z11sched_yieldv>
        break;
        default:
        print_trapframe(tf, true);
f0104dfc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0104e03:	00 
f0104e04:	89 34 24             	mov    %esi,(%esp)
f0104e07:	e8 98 fb ff ff       	call   f01049a4 <_Z15print_trapframeP9Trapframeb>
        if (tf->tf_cs == GD_KT)
f0104e0c:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104e11:	75 1c                	jne    f0104e2f <trap+0x16f>
	    	panic("unhandled trap in kernel");
f0104e13:	c7 44 24 08 1d 8e 10 	movl   $0xf0108e1d,0x8(%esp)
f0104e1a:	f0 
f0104e1b:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
f0104e22:	00 
f0104e23:	c7 04 24 d4 8d 10 f0 	movl   $0xf0108dd4,(%esp)
f0104e2a:	e8 f9 b3 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	    else {
		    env_destroy(curenv);
f0104e2f:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0104e34:	89 04 24             	mov    %eax,(%esp)
f0104e37:	e8 0f f0 ff ff       	call   f0103e4b <_Z11env_destroyP3Env>
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNABLE)
f0104e3c:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0104e41:	85 c0                	test   %eax,%eax
f0104e43:	74 0e                	je     f0104e53 <trap+0x193>
f0104e45:	83 78 0c 01          	cmpl   $0x1,0xc(%eax)
f0104e49:	75 08                	jne    f0104e53 <trap+0x193>
		env_run(curenv);
f0104e4b:	89 04 24             	mov    %eax,(%esp)
f0104e4e:	e8 53 f0 ff ff       	call   f0103ea6 <_Z7env_runP3Env>
	else
		sched_yield();
f0104e53:	e8 18 02 00 00       	call   f0105070 <_Z11sched_yieldv>

f0104e58 <_GLOBAL__I_gdt_pd>:
    *(trap_addr - 1) = tf->tf_err;
    *(trap_addr - 2) = fault_va;
    tf->tf_esp = (uint32_t)(trap_addr - 3);
    tf->tf_eip = curenv->env_pgfault_upcall;
    return;
}
f0104e58:	55                   	push   %ebp
f0104e59:	89 e5                	mov    %esp,%ebp
	SEG(STA_X | STA_R, 0x0, 0xffffffff, 3), // 0x18 - user code segment
	SEG(STA_W, 0x0, 0xffffffff, 3),		// 0x20 - user data segment
	SYSSEG16(STS_T32A, (uint32_t)(&ts), sizeof(struct Taskstate), 0)
						// 0x28 - task state segment
						// (grody x86 internals)
};
f0104e5b:	a1 58 90 10 f0       	mov    0xf0109058,%eax
f0104e60:	8b 15 5c 90 10 f0    	mov    0xf010905c,%edx
f0104e66:	a3 a0 8a 37 f0       	mov    %eax,0xf0378aa0
f0104e6b:	89 15 a4 8a 37 f0    	mov    %edx,0xf0378aa4
f0104e71:	a1 60 90 10 f0       	mov    0xf0109060,%eax
f0104e76:	8b 15 64 90 10 f0    	mov    0xf0109064,%edx
f0104e7c:	a3 a8 8a 37 f0       	mov    %eax,0xf0378aa8
f0104e81:	89 15 ac 8a 37 f0    	mov    %edx,0xf0378aac
f0104e87:	a1 68 90 10 f0       	mov    0xf0109068,%eax
f0104e8c:	8b 15 6c 90 10 f0    	mov    0xf010906c,%edx
f0104e92:	a3 b0 8a 37 f0       	mov    %eax,0xf0378ab0
f0104e97:	89 15 b4 8a 37 f0    	mov    %edx,0xf0378ab4
f0104e9d:	a1 70 90 10 f0       	mov    0xf0109070,%eax
f0104ea2:	8b 15 74 90 10 f0    	mov    0xf0109074,%edx
f0104ea8:	a3 b8 8a 37 f0       	mov    %eax,0xf0378ab8
f0104ead:	89 15 bc 8a 37 f0    	mov    %edx,0xf0378abc
f0104eb3:	a1 78 90 10 f0       	mov    0xf0109078,%eax
f0104eb8:	8b 15 7c 90 10 f0    	mov    0xf010907c,%edx
f0104ebe:	a3 c0 8a 37 f0       	mov    %eax,0xf0378ac0
f0104ec3:	89 15 c4 8a 37 f0    	mov    %edx,0xf0378ac4
f0104ec9:	66 c7 05 c8 8a 37 f0 	movw   $0x68,0xf0378ac8
f0104ed0:	68 00 
f0104ed2:	b8 e0 8a 37 f0       	mov    $0xf0378ae0,%eax
f0104ed7:	66 a3 ca 8a 37 f0    	mov    %ax,0xf0378aca
f0104edd:	89 c2                	mov    %eax,%edx
f0104edf:	c1 ea 10             	shr    $0x10,%edx
f0104ee2:	88 15 cc 8a 37 f0    	mov    %dl,0xf0378acc
f0104ee8:	c6 05 cd 8a 37 f0 89 	movb   $0x89,0xf0378acd
f0104eef:	c6 05 ce 8a 37 f0 40 	movb   $0x40,0xf0378ace
f0104ef6:	c1 e8 18             	shr    $0x18,%eax
f0104ef9:	a2 cf 8a 37 f0       	mov    %al,0xf0378acf
    *(trap_addr - 1) = tf->tf_err;
    *(trap_addr - 2) = fault_va;
    tf->tf_esp = (uint32_t)(trap_addr - 3);
    tf->tf_eip = curenv->env_pgfault_upcall;
    return;
}
f0104efe:	5d                   	pop    %ebp
f0104eff:	c3                   	ret    

f0104f00 <handler0>:
.text

/*
 * Lab 2: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(handler0, 0);
f0104f00:	6a 00                	push   $0x0
f0104f02:	6a 00                	push   $0x0
f0104f04:	e9 49 01 00 00       	jmp    f0105052 <_alltraps>
f0104f09:	90                   	nop

f0104f0a <handler1>:
TRAPHANDLER_NOEC(handler1, 1);
f0104f0a:	6a 00                	push   $0x0
f0104f0c:	6a 01                	push   $0x1
f0104f0e:	e9 3f 01 00 00       	jmp    f0105052 <_alltraps>
f0104f13:	90                   	nop

f0104f14 <handler2>:
TRAPHANDLER_NOEC(handler2, 2);
f0104f14:	6a 00                	push   $0x0
f0104f16:	6a 02                	push   $0x2
f0104f18:	e9 35 01 00 00       	jmp    f0105052 <_alltraps>
f0104f1d:	90                   	nop

f0104f1e <handler3>:
TRAPHANDLER_NOEC(handler3, 3);
f0104f1e:	6a 00                	push   $0x0
f0104f20:	6a 03                	push   $0x3
f0104f22:	e9 2b 01 00 00       	jmp    f0105052 <_alltraps>
f0104f27:	90                   	nop

f0104f28 <handler4>:
TRAPHANDLER_NOEC(handler4, 4);
f0104f28:	6a 00                	push   $0x0
f0104f2a:	6a 04                	push   $0x4
f0104f2c:	e9 21 01 00 00       	jmp    f0105052 <_alltraps>
f0104f31:	90                   	nop

f0104f32 <handler5>:
TRAPHANDLER_NOEC(handler5, 5);
f0104f32:	6a 00                	push   $0x0
f0104f34:	6a 05                	push   $0x5
f0104f36:	e9 17 01 00 00       	jmp    f0105052 <_alltraps>
f0104f3b:	90                   	nop

f0104f3c <handler6>:
TRAPHANDLER_NOEC(handler6, 6);
f0104f3c:	6a 00                	push   $0x0
f0104f3e:	6a 06                	push   $0x6
f0104f40:	e9 0d 01 00 00       	jmp    f0105052 <_alltraps>
f0104f45:	90                   	nop

f0104f46 <handler7>:
TRAPHANDLER_NOEC(handler7, 7);
f0104f46:	6a 00                	push   $0x0
f0104f48:	6a 07                	push   $0x7
f0104f4a:	e9 03 01 00 00       	jmp    f0105052 <_alltraps>
f0104f4f:	90                   	nop

f0104f50 <handler8>:
TRAPHANDLER(handler8, 8);
f0104f50:	6a 08                	push   $0x8
f0104f52:	e9 fb 00 00 00       	jmp    f0105052 <_alltraps>
f0104f57:	90                   	nop

f0104f58 <handler10>:
TRAPHANDLER(handler10, 10);
f0104f58:	6a 0a                	push   $0xa
f0104f5a:	e9 f3 00 00 00       	jmp    f0105052 <_alltraps>
f0104f5f:	90                   	nop

f0104f60 <handler11>:
TRAPHANDLER(handler11, 11);
f0104f60:	6a 0b                	push   $0xb
f0104f62:	e9 eb 00 00 00       	jmp    f0105052 <_alltraps>
f0104f67:	90                   	nop

f0104f68 <handler12>:
TRAPHANDLER(handler12, 12);
f0104f68:	6a 0c                	push   $0xc
f0104f6a:	e9 e3 00 00 00       	jmp    f0105052 <_alltraps>
f0104f6f:	90                   	nop

f0104f70 <handler13>:
TRAPHANDLER(handler13, 13);
f0104f70:	6a 0d                	push   $0xd
f0104f72:	e9 db 00 00 00       	jmp    f0105052 <_alltraps>
f0104f77:	90                   	nop

f0104f78 <handler14>:
TRAPHANDLER(handler14, 14);
f0104f78:	6a 0e                	push   $0xe
f0104f7a:	e9 d3 00 00 00       	jmp    f0105052 <_alltraps>
f0104f7f:	90                   	nop

f0104f80 <handler16>:
TRAPHANDLER_NOEC(handler16, 16);
f0104f80:	6a 00                	push   $0x0
f0104f82:	6a 10                	push   $0x10
f0104f84:	e9 c9 00 00 00       	jmp    f0105052 <_alltraps>
f0104f89:	90                   	nop

f0104f8a <handler17>:
TRAPHANDLER(handler17, 17);
f0104f8a:	6a 11                	push   $0x11
f0104f8c:	e9 c1 00 00 00       	jmp    f0105052 <_alltraps>
f0104f91:	90                   	nop

f0104f92 <handler18>:
TRAPHANDLER_NOEC(handler18, 18);
f0104f92:	6a 00                	push   $0x0
f0104f94:	6a 12                	push   $0x12
f0104f96:	e9 b7 00 00 00       	jmp    f0105052 <_alltraps>
f0104f9b:	90                   	nop

f0104f9c <handler19>:
TRAPHANDLER_NOEC(handler19, 19);
f0104f9c:	6a 00                	push   $0x0
f0104f9e:	6a 13                	push   $0x13
f0104fa0:	e9 ad 00 00 00       	jmp    f0105052 <_alltraps>
f0104fa5:	90                   	nop

f0104fa6 <handler20>:
TRAPHANDLER_NOEC(handler20, 20);
f0104fa6:	6a 00                	push   $0x0
f0104fa8:	6a 14                	push   $0x14
f0104faa:	e9 a3 00 00 00       	jmp    f0105052 <_alltraps>
f0104faf:	90                   	nop

f0104fb0 <handler21>:
TRAPHANDLER(handler21, 21);
f0104fb0:	6a 15                	push   $0x15
f0104fb2:	e9 9b 00 00 00       	jmp    f0105052 <_alltraps>
f0104fb7:	90                   	nop

f0104fb8 <handler22>:
TRAPHANDLER(handler22, 22);
f0104fb8:	6a 16                	push   $0x16
f0104fba:	e9 93 00 00 00       	jmp    f0105052 <_alltraps>
f0104fbf:	90                   	nop

f0104fc0 <handler23>:
TRAPHANDLER(handler23, 23);
f0104fc0:	6a 17                	push   $0x17
f0104fc2:	e9 8b 00 00 00       	jmp    f0105052 <_alltraps>
f0104fc7:	90                   	nop

f0104fc8 <handler24>:
TRAPHANDLER(handler24, 24);
f0104fc8:	6a 18                	push   $0x18
f0104fca:	e9 83 00 00 00       	jmp    f0105052 <_alltraps>
f0104fcf:	90                   	nop

f0104fd0 <handler25>:
TRAPHANDLER(handler25, 25);
f0104fd0:	6a 19                	push   $0x19
f0104fd2:	eb 7e                	jmp    f0105052 <_alltraps>

f0104fd4 <handler26>:
TRAPHANDLER(handler26, 26);
f0104fd4:	6a 1a                	push   $0x1a
f0104fd6:	eb 7a                	jmp    f0105052 <_alltraps>

f0104fd8 <handler27>:
TRAPHANDLER(handler27, 27);
f0104fd8:	6a 1b                	push   $0x1b
f0104fda:	eb 76                	jmp    f0105052 <_alltraps>

f0104fdc <handler28>:
TRAPHANDLER(handler28, 28);
f0104fdc:	6a 1c                	push   $0x1c
f0104fde:	eb 72                	jmp    f0105052 <_alltraps>

f0104fe0 <handler29>:
TRAPHANDLER(handler29, 29);
f0104fe0:	6a 1d                	push   $0x1d
f0104fe2:	eb 6e                	jmp    f0105052 <_alltraps>

f0104fe4 <handler30>:
TRAPHANDLER(handler30, 30);
f0104fe4:	6a 1e                	push   $0x1e
f0104fe6:	eb 6a                	jmp    f0105052 <_alltraps>

f0104fe8 <handler31>:
TRAPHANDLER(handler31, 31);
f0104fe8:	6a 1f                	push   $0x1f
f0104fea:	eb 66                	jmp    f0105052 <_alltraps>

f0104fec <handler48>:
TRAPHANDLER_NOEC(handler48, 48);
f0104fec:	6a 00                	push   $0x0
f0104fee:	6a 30                	push   $0x30
f0104ff0:	eb 60                	jmp    f0105052 <_alltraps>

f0104ff2 <irqhandler0>:

TRAPHANDLER_NOEC(irqhandler0, IRQ_OFFSET);
f0104ff2:	6a 00                	push   $0x0
f0104ff4:	6a 20                	push   $0x20
f0104ff6:	eb 5a                	jmp    f0105052 <_alltraps>

f0104ff8 <irqhandler1>:
TRAPHANDLER_NOEC(irqhandler1, IRQ_OFFSET+1);
f0104ff8:	6a 00                	push   $0x0
f0104ffa:	6a 21                	push   $0x21
f0104ffc:	eb 54                	jmp    f0105052 <_alltraps>

f0104ffe <irqhandler2>:
TRAPHANDLER_NOEC(irqhandler2, IRQ_OFFSET+2);
f0104ffe:	6a 00                	push   $0x0
f0105000:	6a 22                	push   $0x22
f0105002:	eb 4e                	jmp    f0105052 <_alltraps>

f0105004 <irqhandler3>:
TRAPHANDLER_NOEC(irqhandler3, IRQ_OFFSET+3);
f0105004:	6a 00                	push   $0x0
f0105006:	6a 23                	push   $0x23
f0105008:	eb 48                	jmp    f0105052 <_alltraps>

f010500a <irqhandler4>:
TRAPHANDLER_NOEC(irqhandler4, IRQ_OFFSET+4);
f010500a:	6a 00                	push   $0x0
f010500c:	6a 24                	push   $0x24
f010500e:	eb 42                	jmp    f0105052 <_alltraps>

f0105010 <irqhandler5>:
TRAPHANDLER_NOEC(irqhandler5, IRQ_OFFSET+5);
f0105010:	6a 00                	push   $0x0
f0105012:	6a 25                	push   $0x25
f0105014:	eb 3c                	jmp    f0105052 <_alltraps>

f0105016 <irqhandler6>:
TRAPHANDLER_NOEC(irqhandler6, IRQ_OFFSET+6);
f0105016:	6a 00                	push   $0x0
f0105018:	6a 26                	push   $0x26
f010501a:	eb 36                	jmp    f0105052 <_alltraps>

f010501c <irqhandler7>:
TRAPHANDLER_NOEC(irqhandler7, IRQ_OFFSET+7);
f010501c:	6a 00                	push   $0x0
f010501e:	6a 27                	push   $0x27
f0105020:	eb 30                	jmp    f0105052 <_alltraps>

f0105022 <irqhandler8>:
TRAPHANDLER_NOEC(irqhandler8, IRQ_OFFSET+8);
f0105022:	6a 00                	push   $0x0
f0105024:	6a 28                	push   $0x28
f0105026:	eb 2a                	jmp    f0105052 <_alltraps>

f0105028 <irqhandler9>:
TRAPHANDLER_NOEC(irqhandler9, IRQ_OFFSET+9);
f0105028:	6a 00                	push   $0x0
f010502a:	6a 29                	push   $0x29
f010502c:	eb 24                	jmp    f0105052 <_alltraps>

f010502e <irqhandler10>:
TRAPHANDLER_NOEC(irqhandler10, IRQ_OFFSET+10);
f010502e:	6a 00                	push   $0x0
f0105030:	6a 2a                	push   $0x2a
f0105032:	eb 1e                	jmp    f0105052 <_alltraps>

f0105034 <irqhandler11>:
TRAPHANDLER_NOEC(irqhandler11, IRQ_OFFSET+11);
f0105034:	6a 00                	push   $0x0
f0105036:	6a 2b                	push   $0x2b
f0105038:	eb 18                	jmp    f0105052 <_alltraps>

f010503a <irqhandler12>:
TRAPHANDLER_NOEC(irqhandler12, IRQ_OFFSET+12);
f010503a:	6a 00                	push   $0x0
f010503c:	6a 2c                	push   $0x2c
f010503e:	eb 12                	jmp    f0105052 <_alltraps>

f0105040 <irqhandler13>:
TRAPHANDLER_NOEC(irqhandler13, IRQ_OFFSET+13);
f0105040:	6a 00                	push   $0x0
f0105042:	6a 2d                	push   $0x2d
f0105044:	eb 0c                	jmp    f0105052 <_alltraps>

f0105046 <irqhandler14>:
TRAPHANDLER_NOEC(irqhandler14, IRQ_OFFSET+14);
f0105046:	6a 00                	push   $0x0
f0105048:	6a 2e                	push   $0x2e
f010504a:	eb 06                	jmp    f0105052 <_alltraps>

f010504c <irqhandler15>:
TRAPHANDLER_NOEC(irqhandler15, IRQ_OFFSET+15);
f010504c:	6a 00                	push   $0x0
f010504e:	6a 2f                	push   $0x2f
f0105050:	eb 00                	jmp    f0105052 <_alltraps>

f0105052 <_alltraps>:

/*
 * Lab 2: Your code here for _alltraps
 */
_alltraps:
    pushal;
f0105052:	60                   	pusha  
    # override es and ds with GD_KD
    push  %ds;
f0105053:	1e                   	push   %ds
    push  %es;
f0105054:	06                   	push   %es
    mov $GD_KD, %ax;
f0105055:	66 b8 10 00          	mov    $0x10,%ax
    mov %ax, %ds; 
f0105059:	8e d8                	mov    %eax,%ds
    mov %ax, %es;
f010505b:	8e c0                	mov    %eax,%es

    push %esp; # pointer to trapframe
f010505d:	54                   	push   %esp
    call trap;
f010505e:	e8 5d fc ff ff       	call   f0104cc0 <trap>
    pop %eax; # pop the trapframe pointer
f0105063:	58                   	pop    %eax
    popl %es; # pop es
f0105064:	07                   	pop    %es
    popl %ds; # pop ds
f0105065:	1f                   	pop    %ds
    popal;
f0105066:	61                   	popa   
    add $8, %esp;
f0105067:	83 c4 08             	add    $0x8,%esp
    iret;
f010506a:	cf                   	iret   
f010506b:	00 00                	add    %al,(%eax)
f010506d:	00 00                	add    %al,(%eax)
	...

f0105070 <_Z11sched_yieldv>:
static int last_env = 0;

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f0105070:	55                   	push   %ebp
f0105071:	89 e5                	mov    %esp,%ebp
f0105073:	57                   	push   %edi
f0105074:	56                   	push   %esi
f0105075:	53                   	push   %ebx
f0105076:	83 ec 1c             	sub    $0x1c,%esp
	// unless NOTHING else is runnable.

    // if PRIORITY (from sched.h) is true, we do priority scheduling
    
    Env *cur_choice = NULL; // the next candidate
    int match = (last_env?last_env:NENV);
f0105079:	8b 3d 4c 8b 37 f0    	mov    0xf0378b4c,%edi
f010507f:	85 ff                	test   %edi,%edi
f0105081:	bb 00 04 00 00       	mov    $0x400,%ebx
f0105086:	0f 45 df             	cmovne %edi,%ebx
    int cur = (last_env+1)%NENV;
f0105089:	8d 47 01             	lea    0x1(%edi),%eax
f010508c:	89 c2                	mov    %eax,%edx
f010508e:	c1 fa 1f             	sar    $0x1f,%edx
f0105091:	c1 ea 16             	shr    $0x16,%edx
f0105094:	01 d0                	add    %edx,%eax
f0105096:	25 ff 03 00 00       	and    $0x3ff,%eax
f010509b:	29 d0                	sub    %edx,%eax
               (!cur_choice || envs[cur].env_priority<cur_choice->env_priority))
                    cur_choice = &envs[cur]; 
        }

        // round robin version
	    else if (envs[cur].env_status == ENV_RUNNABLE)
f010509d:	8b 35 88 82 37 f0    	mov    0xf0378288,%esi
    // if PRIORITY (from sched.h) is true, we do priority scheduling
    
    Env *cur_choice = NULL; // the next candidate
    int match = (last_env?last_env:NENV);
    int cur = (last_env+1)%NENV;
    while(cur != match)
f01050a3:	eb 34                	jmp    f01050d9 <_Z11sched_yieldv+0x69>
f01050a5:	89 d1                	mov    %edx,%ecx
               (!cur_choice || envs[cur].env_priority<cur_choice->env_priority))
                    cur_choice = &envs[cur]; 
        }

        // round robin version
	    else if (envs[cur].env_status == ENV_RUNNABLE)
f01050a7:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
f01050ab:	75 0d                	jne    f01050ba <_Z11sched_yieldv+0x4a>
        {
            last_env = cur;
f01050ad:	a3 4c 8b 37 f0       	mov    %eax,0xf0378b4c
		    env_run(&envs[cur]);
f01050b2:	89 0c 24             	mov    %ecx,(%esp)
f01050b5:	e8 ec ed ff ff       	call   f0103ea6 <_Z7env_runP3Env>
        }
        // ids only go up so high, then wrap around
        if(++cur == NENV)
f01050ba:	83 c0 01             	add    $0x1,%eax
f01050bd:	83 c2 78             	add    $0x78,%edx
f01050c0:	3d 00 04 00 00       	cmp    $0x400,%eax
f01050c5:	74 06                	je     f01050cd <_Z11sched_yieldv+0x5d>
    // if PRIORITY (from sched.h) is true, we do priority scheduling
    
    Env *cur_choice = NULL; // the next candidate
    int match = (last_env?last_env:NENV);
    int cur = (last_env+1)%NENV;
    while(cur != match)
f01050c7:	39 c3                	cmp    %eax,%ebx
f01050c9:	75 da                	jne    f01050a5 <_Z11sched_yieldv+0x35>
f01050cb:	eb 2e                	jmp    f01050fb <_Z11sched_yieldv+0x8b>
            last_env = cur;
		    env_run(&envs[cur]);
        }
        // ids only go up so high, then wrap around
        if(++cur == NENV)
            cur = 1;
f01050cd:	b8 01 00 00 00       	mov    $0x1,%eax
f01050d2:	eb 05                	jmp    f01050d9 <_Z11sched_yieldv+0x69>
f01050d4:	b8 01 00 00 00       	mov    $0x1,%eax
    // if PRIORITY (from sched.h) is true, we do priority scheduling
    
    Env *cur_choice = NULL; // the next candidate
    int match = (last_env?last_env:NENV);
    int cur = (last_env+1)%NENV;
    while(cur != match)
f01050d9:	39 c3                	cmp    %eax,%ebx
f01050db:	74 1e                	je     f01050fb <_Z11sched_yieldv+0x8b>
               (!cur_choice || envs[cur].env_priority<cur_choice->env_priority))
                    cur_choice = &envs[cur]; 
        }

        // round robin version
	    else if (envs[cur].env_status == ENV_RUNNABLE)
f01050dd:	6b c8 78             	imul   $0x78,%eax,%ecx
f01050e0:	8d 0c 0e             	lea    (%esi,%ecx,1),%ecx
f01050e3:	83 79 0c 01          	cmpl   $0x1,0xc(%ecx)
f01050e7:	74 c4                	je     f01050ad <_Z11sched_yieldv+0x3d>
        {
            last_env = cur;
		    env_run(&envs[cur]);
        }
        // ids only go up so high, then wrap around
        if(++cur == NENV)
f01050e9:	83 c0 01             	add    $0x1,%eax
f01050ec:	3d 00 04 00 00       	cmp    $0x400,%eax
f01050f1:	74 e1                	je     f01050d4 <_Z11sched_yieldv+0x64>

static int last_env = 0;

// Choose a user environment to run and run it.
void
sched_yield(void)
f01050f3:	6b d0 78             	imul   $0x78,%eax,%edx
f01050f6:	8d 14 16             	lea    (%esi,%edx,1),%edx
f01050f9:	eb cc                	jmp    f01050c7 <_Z11sched_yieldv+0x57>
        }
    }
    // round robin version
    // if there wasn't another env to run, try to run the 
    // previous env that was running
    else if (envs[last_env].env_status == ENV_RUNNABLE)
f01050fb:	6b ff 78             	imul   $0x78,%edi,%edi
f01050fe:	01 fe                	add    %edi,%esi
f0105100:	83 7e 0c 01          	cmpl   $0x1,0xc(%esi)
f0105104:	75 08                	jne    f010510e <_Z11sched_yieldv+0x9e>
        env_run(&envs[last_env]);
f0105106:	89 34 24             	mov    %esi,(%esp)
f0105109:	e8 98 ed ff ff       	call   f0103ea6 <_Z7env_runP3Env>
    cprintf("Idle loop - nothing more to do!\n");
f010510e:	c7 04 24 d0 90 10 f0 	movl   $0xf01090d0,(%esp)
f0105115:	e8 98 ef ff ff       	call   f01040b2 <_Z7cprintfPKcz>
    env_run(&envs[0]);
f010511a:	a1 88 82 37 f0       	mov    0xf0378288,%eax
f010511f:	89 04 24             	mov    %eax,(%esp)
f0105122:	e8 7f ed ff ff       	call   f0103ea6 <_Z7env_runP3Env>
	...

f0105130 <_Z7syscalljjjjjj>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0105130:	55                   	push   %ebp
f0105131:	89 e5                	mov    %esp,%ebp
f0105133:	83 ec 48             	sub    $0x48,%esp
f0105136:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0105139:	89 75 f8             	mov    %esi,-0x8(%ebp)
f010513c:	89 7d fc             	mov    %edi,-0x4(%ebp)
f010513f:	8b 55 08             	mov    0x8(%ebp),%edx
f0105142:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105145:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105148:	8b 75 14             	mov    0x14(%ebp),%esi
        case SYS_time_msec: return sys_time_msec();
        case SYS_program_lookup: return sys_program_lookup((uintptr_t)a1, (size_t)a2);
        case SYS_env_set_trapframe: return sys_env_set_trapframe((envid_t) a1, (uintptr_t) a2);
        case SYS_e1000_transmit: return sys_e1000_transmit((uintptr_t)a1, (size_t)a2); 
        case SYS_e1000_receive: return sys_e1000_receive((uintptr_t)a1);
        default: return -E_INVAL;
f010514b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
    switch(syscallno)
f0105150:	83 fa 13             	cmp    $0x13,%edx
f0105153:	0f 87 10 09 00 00    	ja     f0105a69 <_Z7syscalljjjjjj+0x939>
f0105159:	ff 24 95 38 91 10 f0 	jmp    *-0xfef6ec8(,%edx,4)
static void
sys_cputs(uintptr_t s_ptr, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
    user_mem_assert(curenv, s_ptr, len, 0);
f0105160:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0105167:	00 
f0105168:	89 7c 24 08          	mov    %edi,0x8(%esp)
f010516c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105170:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0105175:	89 04 24             	mov    %eax,(%esp)
f0105178:	e8 0e e5 ff ff       	call   f010368b <_Z15user_mem_assertP3Envjjj>

	// Print the string supplied by the user.
	cprintf("%.*s", len, (char *) s_ptr);
f010517d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0105181:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105185:	c7 04 24 f1 90 10 f0 	movl   $0xf01090f1,(%esp)
f010518c:	e8 21 ef ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
    switch(syscallno)
    {
        case SYS_cputs: sys_cputs((uintptr_t)a1, (size_t)a2); return 0;
f0105191:	b8 00 00 00 00       	mov    $0x0,%eax
f0105196:	e9 ce 08 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f010519b:	e8 04 b7 ff ff       	call   f01008a4 <_Z9cons_getcv>
	// Return any appropriate return value.
	// LAB 3: Your code here.
    switch(syscallno)
    {
        case SYS_cputs: sys_cputs((uintptr_t)a1, (size_t)a2); return 0;
        case SYS_cgetc: return sys_cgetc();
f01051a0:	e9 c4 08 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f01051a5:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f01051aa:	8b 40 04             	mov    0x4(%eax),%eax
	// LAB 3: Your code here.
    switch(syscallno)
    {
        case SYS_cputs: sys_cputs((uintptr_t)a1, (size_t)a2); return 0;
        case SYS_cgetc: return sys_cgetc();
        case SYS_getenvid: return (int32_t)sys_getenvid();
f01051ad:	e9 b7 08 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f01051b2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01051b9:	00 
f01051ba:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01051bd:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051c1:	89 1c 24             	mov    %ebx,(%esp)
f01051c4:	e8 1b e5 ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f01051c9:	85 c0                	test   %eax,%eax
f01051cb:	0f 88 98 08 00 00    	js     f0105a69 <_Z7syscalljjjjjj+0x939>
		return r;
	if (e == curenv)
f01051d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01051d4:	8b 15 8c 82 37 f0    	mov    0xf037828c,%edx
f01051da:	39 d0                	cmp    %edx,%eax
f01051dc:	75 15                	jne    f01051f3 <_Z7syscalljjjjjj+0xc3>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f01051de:	8b 40 04             	mov    0x4(%eax),%eax
f01051e1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051e5:	c7 04 24 f6 90 10 f0 	movl   $0xf01090f6,(%esp)
f01051ec:	e8 c1 ee ff ff       	call   f01040b2 <_Z7cprintfPKcz>
f01051f1:	eb 1a                	jmp    f010520d <_Z7syscalljjjjjj+0xdd>
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01051f3:	8b 40 04             	mov    0x4(%eax),%eax
f01051f6:	89 44 24 08          	mov    %eax,0x8(%esp)
f01051fa:	8b 42 04             	mov    0x4(%edx),%eax
f01051fd:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105201:	c7 04 24 11 91 10 f0 	movl   $0xf0109111,(%esp)
f0105208:	e8 a5 ee ff ff       	call   f01040b2 <_Z7cprintfPKcz>
	env_destroy(e);
f010520d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105210:	89 04 24             	mov    %eax,(%esp)
f0105213:	e8 33 ec ff ff       	call   f0103e4b <_Z11env_destroyP3Env>
	return 0;
f0105218:	b8 00 00 00 00       	mov    $0x0,%eax
    switch(syscallno)
    {
        case SYS_cputs: sys_cputs((uintptr_t)a1, (size_t)a2); return 0;
        case SYS_cgetc: return sys_cgetc();
        case SYS_getenvid: return (int32_t)sys_getenvid();
        case SYS_env_destroy: return sys_env_destroy((envid_t)a1);
f010521d:	e9 47 08 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f0105222:	e8 49 fe ff ff       	call   f0105070 <_Z11sched_yieldv>
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(uintptr_t dstva)
{
	// check for valid page for a mapping
    if (dstva < UTOP && (dstva % PGSIZE))
f0105227:	81 fb ff ff ff ee    	cmp    $0xeeffffff,%ebx
f010522d:	77 11                	ja     f0105240 <_Z7syscalljjjjjj+0x110>
            return -E_INVAL;
f010522f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(uintptr_t dstva)
{
	// check for valid page for a mapping
    if (dstva < UTOP && (dstva % PGSIZE))
f0105234:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f010523a:	0f 85 29 08 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
            return -E_INVAL;

    // and anticipate a message (setting ourselves to NOT_RUNNABLE
    curenv->env_ipc_dstva = dstva;
f0105240:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0105245:	89 58 64             	mov    %ebx,0x64(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105248:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    curenv->env_ipc_recving = true; 
f010524f:	c6 40 60 01          	movb   $0x1,0x60(%eax)
    return 0;
f0105253:	b8 00 00 00 00       	mov    $0x0,%eax
f0105258:	e9 0c 08 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
{
	// LAB 4: Your code here.
    Env *e;
    
    // valid env?
    if (envid2env(envid, &e, 0) < 0)
f010525d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0105264:	00 
f0105265:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105268:	89 44 24 04          	mov    %eax,0x4(%esp)
f010526c:	89 1c 24             	mov    %ebx,(%esp)
f010526f:	e8 70 e4 ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f0105274:	89 c2                	mov    %eax,%edx
        return -E_BAD_ENV;
f0105276:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
{
	// LAB 4: Your code here.
    Env *e;
    
    // valid env?
    if (envid2env(envid, &e, 0) < 0)
f010527b:	85 d2                	test   %edx,%edx
f010527d:	0f 88 e6 07 00 00    	js     f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_BAD_ENV;

    // is the environment waiting on a message?
    if (!e->env_ipc_recving)
f0105283:	8b 55 dc             	mov    -0x24(%ebp),%edx
        return -E_IPC_NOT_RECV;
f0105286:	b0 f9                	mov    $0xf9,%al
    // valid env?
    if (envid2env(envid, &e, 0) < 0)
        return -E_BAD_ENV;

    // is the environment waiting on a message?
    if (!e->env_ipc_recving)
f0105288:	80 7a 60 00          	cmpb   $0x0,0x60(%edx)
f010528c:	0f 84 d7 07 00 00    	je     f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_IPC_NOT_RECV;

    // check for alignment and permission issues
    if (srcva < UTOP && 
f0105292:	81 fe ff ff ff ee    	cmp    $0xeeffffff,%esi
f0105298:	77 2f                	ja     f01052c9 <_Z7syscalljjjjjj+0x199>
       (srcva % PGSIZE || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) ||
       !(perm & PTE_U) || !(perm & PTE_P)))
            return -E_INVAL;
f010529a:	b0 fd                	mov    $0xfd,%al
    // is the environment waiting on a message?
    if (!e->env_ipc_recving)
        return -E_IPC_NOT_RECV;

    // check for alignment and permission issues
    if (srcva < UTOP && 
f010529c:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
f01052a2:	0f 85 c1 07 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
f01052a8:	8b 4d 18             	mov    0x18(%ebp),%ecx
f01052ab:	81 e1 fc f1 ff ff    	and    $0xfffff1fc,%ecx
f01052b1:	83 f9 04             	cmp    $0x4,%ecx
f01052b4:	0f 85 af 07 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
f01052ba:	f6 45 18 01          	testb  $0x1,0x18(%ebp)
f01052be:	0f 85 b2 07 00 00    	jne    f0105a76 <_Z7syscalljjjjjj+0x946>
f01052c4:	e9 a0 07 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
       (srcva % PGSIZE || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) ||
       !(perm & PTE_U) || !(perm & PTE_P)))
            return -E_INVAL;

    // transmit the message
    e->env_ipc_recving = 0;
f01052c9:	c6 42 60 00          	movb   $0x0,0x60(%edx)
    e->env_ipc_value = value;
f01052cd:	89 7a 68             	mov    %edi,0x68(%edx)
    e->env_ipc_from = curenv->env_id;
f01052d0:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f01052d5:	8b 40 04             	mov    0x4(%eax),%eax
f01052d8:	89 42 6c             	mov    %eax,0x6c(%edx)
f01052db:	eb 6f                	jmp    f010534c <_Z7syscalljjjjjj+0x21c>
    {
        Page *p;
        pte_t *pte;

        // check if the page and permissions are valid, and try to insert
        if ((p = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL)
f01052dd:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01052e0:	89 54 24 08          	mov    %edx,0x8(%esp)
f01052e4:	89 74 24 04          	mov    %esi,0x4(%esp)
f01052e8:	8b 40 10             	mov    0x10(%eax),%eax
f01052eb:	89 04 24             	mov    %eax,(%esp)
f01052ee:	e8 ae c3 ff ff       	call   f01016a1 <_Z11page_lookupPjjPS_>
f01052f3:	89 c1                	mov    %eax,%ecx
            return -E_INVAL;
f01052f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
    {
        Page *p;
        pte_t *pte;

        // check if the page and permissions are valid, and try to insert
        if ((p = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL)
f01052fa:	85 c9                	test   %ecx,%ecx
f01052fc:	0f 84 67 07 00 00    	je     f0105a69 <_Z7syscalljjjjjj+0x939>
            return -E_INVAL;
        if ((perm & PTE_W) && !(*pte & PTE_W))
f0105302:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105306:	74 0c                	je     f0105314 <_Z7syscalljjjjjj+0x1e4>
f0105308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010530b:	f6 02 02             	testb  $0x2,(%edx)
f010530e:	0f 84 55 07 00 00    	je     f0105a69 <_Z7syscalljjjjjj+0x939>
            return -E_INVAL;
        if ((ret = page_insert(e->env_pgdir, p, e->env_ipc_dstva, perm)) < 0)
f0105314:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105317:	8b 45 18             	mov    0x18(%ebp),%eax
f010531a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010531e:	8b 42 64             	mov    0x64(%edx),%eax
f0105321:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105325:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105329:	8b 42 10             	mov    0x10(%edx),%eax
f010532c:	89 04 24             	mov    %eax,(%esp)
f010532f:	e8 74 c4 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f0105334:	85 c0                	test   %eax,%eax
f0105336:	0f 88 2d 07 00 00    	js     f0105a69 <_Z7syscalljjjjjj+0x939>
            return ret;
        e->env_ipc_perm = perm;
f010533c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010533f:	8b 55 18             	mov    0x18(%ebp),%edx
f0105342:	89 50 70             	mov    %edx,0x70(%eax)
        ret = 1;
f0105345:	b8 01 00 00 00       	mov    $0x1,%eax
f010534a:	eb 0c                	jmp    f0105358 <_Z7syscalljjjjjj+0x228>
    }
    else
        e->env_ipc_perm = 0;
f010534c:	c7 42 70 00 00 00 00 	movl   $0x0,0x70(%edx)
    e->env_ipc_recving = 0;
    e->env_ipc_value = value;
    e->env_ipc_from = curenv->env_id;


    int ret = 0;
f0105353:	b8 00 00 00 00       	mov    $0x0,%eax
    }
    else
        e->env_ipc_perm = 0;
    
    // and set the environment that was waiting back to runnable
    e->env_status = ENV_RUNNABLE;
f0105358:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010535b:	c7 42 0c 01 00 00 00 	movl   $0x1,0xc(%edx)
f0105362:	e9 02 07 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 3: Your code here.
	if(status & ~(ENV_RUNNABLE | ENV_NOT_RUNNABLE))
f0105367:	f7 c7 fc ff ff ff    	test   $0xfffffffc,%edi
f010536d:	75 36                	jne    f01053a5 <_Z7syscalljjjjjj+0x275>
        return -E_INVAL;
    Env *env;
    if(envid2env(envid, &env, 1))
f010536f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105376:	00 
f0105377:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010537a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010537e:	89 1c 24             	mov    %ebx,(%esp)
f0105381:	e8 5e e3 ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f0105386:	89 c2                	mov    %eax,%edx
        return -E_BAD_ENV;
f0105388:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

	// LAB 3: Your code here.
	if(status & ~(ENV_RUNNABLE | ENV_NOT_RUNNABLE))
        return -E_INVAL;
    Env *env;
    if(envid2env(envid, &env, 1))
f010538d:	85 d2                	test   %edx,%edx
f010538f:	0f 85 d4 06 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_BAD_ENV;
    env->env_status = status;
f0105395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105398:	89 78 0c             	mov    %edi,0xc(%eax)
    return 0;
f010539b:	b8 00 00 00 00       	mov    $0x0,%eax
f01053a0:	e9 c4 06 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 3: Your code here.
	if(status & ~(ENV_RUNNABLE | ENV_NOT_RUNNABLE))
        return -E_INVAL;
f01053a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01053aa:	e9 ba 06 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
 * apply, except there is no restriction on priority value */
static int
sys_env_set_priority(envid_t envid, uint32_t priority)
{
    Env *env;
    if(envid2env(envid, &env, 1))
f01053af:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01053b6:	00 
f01053b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01053ba:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053be:	89 1c 24             	mov    %ebx,(%esp)
f01053c1:	e8 1e e3 ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f01053c6:	89 c2                	mov    %eax,%edx
        return -E_BAD_ENV;
f01053c8:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
 * apply, except there is no restriction on priority value */
static int
sys_env_set_priority(envid_t envid, uint32_t priority)
{
    Env *env;
    if(envid2env(envid, &env, 1))
f01053cd:	85 d2                	test   %edx,%edx
f01053cf:	0f 85 94 06 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_BAD_ENV;
    env->env_priority = priority;
f01053d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01053d8:	89 78 74             	mov    %edi,0x74(%eax)
    return 0;
f01053db:	b8 00 00 00 00       	mov    $0x0,%eax
f01053e0:	e9 84 06 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
static int
sys_env_set_pgfault_upcall(envid_t envid, uintptr_t func)
{
	// LAB 4: Your code here.
    Env *env;
    if(envid2env(envid, &env, 1))
f01053e5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01053ec:	00 
f01053ed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01053f0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053f4:	89 1c 24             	mov    %ebx,(%esp)
f01053f7:	e8 e8 e2 ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f01053fc:	89 c2                	mov    %eax,%edx
        return -E_BAD_ENV;
f01053fe:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
static int
sys_env_set_pgfault_upcall(envid_t envid, uintptr_t func)
{
	// LAB 4: Your code here.
    Env *env;
    if(envid2env(envid, &env, 1))
f0105403:	85 d2                	test   %edx,%edx
f0105405:	0f 85 5e 06 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_BAD_ENV;
    env->env_pgfault_upcall = func;
f010540b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010540e:	89 78 5c             	mov    %edi,0x5c(%eax)
    return 0;
f0105411:	b8 00 00 00 00       	mov    $0x0,%eax
f0105416:	e9 4e 06 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
	// sys_exofork will appear to return 0 there.

	// LAB 3: Your code here.
    Env *new_env;
    int r;
    if((r = env_alloc(&new_env, curenv->env_id)))
f010541b:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0105420:	8b 40 04             	mov    0x4(%eax),%eax
f0105423:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105427:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010542a:	89 04 24             	mov    %eax,(%esp)
f010542d:	e8 64 e3 ff ff       	call   f0103796 <_Z9env_allocPP3Envi>
f0105432:	85 c0                	test   %eax,%eax
f0105434:	0f 85 2f 06 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
        return r;
    
    new_env->env_status = ENV_NOT_RUNNABLE;
f010543a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010543d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    new_env->env_tf = curenv->env_tf;
f0105444:	8d 78 14             	lea    0x14(%eax),%edi
f0105447:	8b 35 8c 82 37 f0    	mov    0xf037828c,%esi
f010544d:	83 c6 14             	add    $0x14,%esi
f0105450:	b9 11 00 00 00       	mov    $0x11,%ecx
f0105455:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    
    // since eax is the return value, we want the child to see 0 returned
    new_env->env_tf.tf_regs.reg_eax = 0;
f0105457:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    return new_env->env_id; 
f010545e:	8b 40 04             	mov    0x4(%eax),%eax
        case SYS_ipc_recv: return sys_ipc_recv((uintptr_t)a1);
        case SYS_ipc_try_send: return sys_ipc_try_send((envid_t)a1,(uint32_t)a2, (uintptr_t)a3, (unsigned)a4);
        case SYS_env_set_status: return sys_env_set_status((envid_t)a1,(int)a2);
        case SYS_env_set_priority: return sys_env_set_priority((envid_t)a1,(uint32_t)a2);
        case SYS_env_set_pgfault_upcall: return sys_env_set_pgfault_upcall((envid_t)a1,(uint32_t)a2);
        case SYS_exofork: return (int32_t)sys_exofork();
f0105461:	e9 03 06 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>

	// LAB 3: Your code here.
    Env *env;

    // check if valid env that we can manipulate
    if(envid2env(envid, &env, 1) || !env)
f0105466:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010546d:	00 
f010546e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105471:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105475:	89 1c 24             	mov    %ebx,(%esp)
f0105478:	e8 67 e2 ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f010547d:	89 c2                	mov    %eax,%edx
        return -E_BAD_ENV;
f010547f:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

	// LAB 3: Your code here.
    Env *env;

    // check if valid env that we can manipulate
    if(envid2env(envid, &env, 1) || !env)
f0105484:	85 d2                	test   %edx,%edx
f0105486:	0f 85 dd 05 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
f010548c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105490:	0f 84 d3 05 00 00    	je     f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_BAD_ENV;

    // check page alignment and permissions
    if((va % PGSIZE) || va >= UTOP || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) || !(perm & PTE_U) || !(perm & PTE_P))
f0105496:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f010549c:	0f 85 cc 00 00 00    	jne    f010556e <_Z7syscalljjjjjj+0x43e>
f01054a2:	81 ff ff ff ff ee    	cmp    $0xeeffffff,%edi
f01054a8:	0f 87 c0 00 00 00    	ja     f010556e <_Z7syscalljjjjjj+0x43e>
f01054ae:	89 f2                	mov    %esi,%edx
f01054b0:	81 e2 fc f1 ff ff    	and    $0xfffff1fc,%edx
        return -E_INVAL;
f01054b6:	b0 fd                	mov    $0xfd,%al
    // check if valid env that we can manipulate
    if(envid2env(envid, &env, 1) || !env)
        return -E_BAD_ENV;

    // check page alignment and permissions
    if((va % PGSIZE) || va >= UTOP || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) || !(perm & PTE_U) || !(perm & PTE_P))
f01054b8:	83 fa 04             	cmp    $0x4,%edx
f01054bb:	0f 85 a8 05 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
f01054c1:	f7 c6 01 00 00 00    	test   $0x1,%esi
f01054c7:	0f 84 9c 05 00 00    	je     f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_INVAL;

    Page *p;
    if (!(p = page_alloc()))
f01054cd:	e8 b8 bf ff ff       	call   f010148a <_Z10page_allocv>
f01054d2:	89 c3                	mov    %eax,%ebx
f01054d4:	85 c0                	test   %eax,%eax
f01054d6:	0f 84 9c 00 00 00    	je     f0105578 <_Z7syscalljjjjjj+0x448>
        return -E_NO_MEM;

    // if we fail to insert, we have to free the page we just allocated
    if (page_insert(env->env_pgdir, p, va, perm))
f01054dc:	89 74 24 0c          	mov    %esi,0xc(%esp)
f01054e0:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01054e4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01054e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01054eb:	8b 40 10             	mov    0x10(%eax),%eax
f01054ee:	89 04 24             	mov    %eax,(%esp)
f01054f1:	e8 b2 c2 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
f01054f6:	85 c0                	test   %eax,%eax
f01054f8:	74 12                	je     f010550c <_Z7syscalljjjjjj+0x3dc>
    {
        page_free(p);
f01054fa:	89 1c 24             	mov    %ebx,(%esp)
f01054fd:	e8 9e bf ff ff       	call   f01014a0 <_Z9page_freeP4Page>
        return -E_NO_MEM;
f0105502:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105507:	e9 5d 05 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
void	user_mem_assert(struct Env *env, uintptr_t va, size_t len, pte_t perm);

static inline physaddr_t
page2pa(struct Page *pp)
{
	return (pp - pages) << PGSHIFT;
f010550c:	89 d8                	mov    %ebx,%eax
f010550e:	2b 05 74 82 37 f0    	sub    0xf0378274,%eax
f0105514:	c1 f8 03             	sar    $0x3,%eax
f0105517:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void *
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f010551a:	89 c2                	mov    %eax,%edx
f010551c:	c1 ea 0c             	shr    $0xc,%edx
f010551f:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f0105525:	72 20                	jb     f0105547 <_Z7syscalljjjjjj+0x417>
f0105527:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010552b:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0105532:	f0 
f0105533:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f010553a:	00 
f010553b:	c7 04 24 e6 88 10 f0 	movl   $0xf01088e6,(%esp)
f0105542:	e8 e1 ac ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
    }

    // zero out the page
    memset(page2kva(p), 0, PGSIZE);
f0105547:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010554e:	00 
f010554f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0105556:	00 
f0105557:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010555c:	89 04 24             	mov    %eax,(%esp)
f010555f:	e8 9d 11 00 00       	call   f0106701 <memset>
    return 0;    
f0105564:	b8 00 00 00 00       	mov    $0x0,%eax
f0105569:	e9 fb 04 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
    if(envid2env(envid, &env, 1) || !env)
        return -E_BAD_ENV;

    // check page alignment and permissions
    if((va % PGSIZE) || va >= UTOP || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) || !(perm & PTE_U) || !(perm & PTE_P))
        return -E_INVAL;
f010556e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105573:	e9 f1 04 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>

    Page *p;
    if (!(p = page_alloc()))
        return -E_NO_MEM;
f0105578:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
        case SYS_ipc_try_send: return sys_ipc_try_send((envid_t)a1,(uint32_t)a2, (uintptr_t)a3, (unsigned)a4);
        case SYS_env_set_status: return sys_env_set_status((envid_t)a1,(int)a2);
        case SYS_env_set_priority: return sys_env_set_priority((envid_t)a1,(uint32_t)a2);
        case SYS_env_set_pgfault_upcall: return sys_env_set_pgfault_upcall((envid_t)a1,(uint32_t)a2);
        case SYS_exofork: return (int32_t)sys_exofork();
        case SYS_page_alloc: return sys_page_alloc((envid_t)a1,(uintptr_t)a2,(int)a3);
f010557d:	e9 e7 04 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>

	// LAB 3: Your code here.
    Env *srcenv, *dstenv;

    // check if boths envs are valid for us to manipulate
    if(envid2env(dstenvid, &dstenv, 1) || envid2env(srcenvid, &srcenv, 1) ||
f0105582:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105589:	00 
f010558a:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010558d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105591:	89 34 24             	mov    %esi,(%esp)
f0105594:	e8 4b e1 ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f0105599:	89 c2                	mov    %eax,%edx
       !dstenv || !srcenv)
        return -E_BAD_ENV;
f010559b:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

	// LAB 3: Your code here.
    Env *srcenv, *dstenv;

    // check if boths envs are valid for us to manipulate
    if(envid2env(dstenvid, &dstenv, 1) || envid2env(srcenvid, &srcenv, 1) ||
f01055a0:	85 d2                	test   %edx,%edx
f01055a2:	0f 85 c1 04 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
f01055a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01055af:	00 
f01055b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01055b3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01055b7:	89 1c 24             	mov    %ebx,(%esp)
f01055ba:	e8 25 e1 ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f01055bf:	89 c2                	mov    %eax,%edx
       !dstenv || !srcenv)
        return -E_BAD_ENV;
f01055c1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

	// LAB 3: Your code here.
    Env *srcenv, *dstenv;

    // check if boths envs are valid for us to manipulate
    if(envid2env(dstenvid, &dstenv, 1) || envid2env(srcenvid, &srcenv, 1) ||
f01055c6:	85 d2                	test   %edx,%edx
f01055c8:	0f 85 9b 04 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
f01055ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01055d2:	0f 84 91 04 00 00    	je     f0105a69 <_Z7syscalljjjjjj+0x939>
       !dstenv || !srcenv)
f01055d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx

	// LAB 3: Your code here.
    Env *srcenv, *dstenv;

    // check if boths envs are valid for us to manipulate
    if(envid2env(dstenvid, &dstenv, 1) || envid2env(srcenvid, &srcenv, 1) ||
f01055db:	85 d2                	test   %edx,%edx
f01055dd:	0f 85 b7 04 00 00    	jne    f0105a9a <_Z7syscalljjjjjj+0x96a>
f01055e3:	e9 81 04 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
       !dstenv || !srcenv)
        return -E_BAD_ENV;
    // check alignemnt and permissions
    
    if((srcva & PGALIGN) || srcva >= UTOP || (dstva & PGALIGN) || dstva >= UTOP || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) || !(perm & PTE_U) || !(perm & PTE_P))
f01055e8:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f01055ef:	0f 85 94 00 00 00    	jne    f0105689 <_Z7syscalljjjjjj+0x559>
f01055f5:	81 7d 18 ff ff ff ee 	cmpl   $0xeeffffff,0x18(%ebp)
f01055fc:	0f 87 87 00 00 00    	ja     f0105689 <_Z7syscalljjjjjj+0x559>
f0105602:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
f0105605:	81 e1 fc f1 ff ff    	and    $0xfffff1fc,%ecx
        return -E_INVAL;
f010560b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
    if(envid2env(dstenvid, &dstenv, 1) || envid2env(srcenvid, &srcenv, 1) ||
       !dstenv || !srcenv)
        return -E_BAD_ENV;
    // check alignemnt and permissions
    
    if((srcva & PGALIGN) || srcva >= UTOP || (dstva & PGALIGN) || dstva >= UTOP || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) || !(perm & PTE_U) || !(perm & PTE_P))
f0105610:	83 f9 04             	cmp    $0x4,%ecx
f0105613:	0f 85 50 04 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
f0105619:	f6 45 1c 01          	testb  $0x1,0x1c(%ebp)
f010561d:	0f 84 46 04 00 00    	je     f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_INVAL;
   
    pte_t *pte;
    Page *p = page_lookup(srcenv->env_pgdir, srcva, &pte);
f0105623:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105626:	89 44 24 08          	mov    %eax,0x8(%esp)
f010562a:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010562e:	8b 42 10             	mov    0x10(%edx),%eax
f0105631:	89 04 24             	mov    %eax,(%esp)
f0105634:	e8 68 c0 ff ff       	call   f01016a1 <_Z11page_lookupPjjPS_>
f0105639:	89 c2                	mov    %eax,%edx

    // if we are trying to map a non-writeable page as writeable, invalid
    if(!p || ((perm & PTE_W) && !(*pte & PTE_W)))
        return -E_INVAL;
f010563b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
   
    pte_t *pte;
    Page *p = page_lookup(srcenv->env_pgdir, srcva, &pte);

    // if we are trying to map a non-writeable page as writeable, invalid
    if(!p || ((perm & PTE_W) && !(*pte & PTE_W)))
f0105640:	85 d2                	test   %edx,%edx
f0105642:	0f 84 21 04 00 00    	je     f0105a69 <_Z7syscalljjjjjj+0x939>
f0105648:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f010564c:	74 0c                	je     f010565a <_Z7syscalljjjjjj+0x52a>
f010564e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105651:	f6 01 02             	testb  $0x2,(%ecx)
f0105654:	0f 84 0f 04 00 00    	je     f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_INVAL;
    
    // insert the page, which itself can fail
    if(page_insert(dstenv->env_pgdir, p, dstva, perm))
f010565a:	8b 4d 1c             	mov    0x1c(%ebp),%ecx
f010565d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0105661:	8b 45 18             	mov    0x18(%ebp),%eax
f0105664:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105668:	89 54 24 04          	mov    %edx,0x4(%esp)
f010566c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010566f:	8b 40 10             	mov    0x10(%eax),%eax
f0105672:	89 04 24             	mov    %eax,(%esp)
f0105675:	e8 2e c1 ff ff       	call   f01017a8 <_Z11page_insertPjP4Pagejj>
        return -E_NO_MEM;
f010567a:	83 f8 01             	cmp    $0x1,%eax
f010567d:	19 c0                	sbb    %eax,%eax
f010567f:	f7 d0                	not    %eax
f0105681:	83 e0 fc             	and    $0xfffffffc,%eax
f0105684:	e9 e0 03 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
       !dstenv || !srcenv)
        return -E_BAD_ENV;
    // check alignemnt and permissions
    
    if((srcva & PGALIGN) || srcva >= UTOP || (dstva & PGALIGN) || dstva >= UTOP || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) || !(perm & PTE_U) || !(perm & PTE_P))
        return -E_INVAL;
f0105689:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010568e:	e9 d6 03 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
f0105693:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
        case SYS_env_set_status: return sys_env_set_status((envid_t)a1,(int)a2);
        case SYS_env_set_priority: return sys_env_set_priority((envid_t)a1,(uint32_t)a2);
        case SYS_env_set_pgfault_upcall: return sys_env_set_pgfault_upcall((envid_t)a1,(uint32_t)a2);
        case SYS_exofork: return (int32_t)sys_exofork();
        case SYS_page_alloc: return sys_page_alloc((envid_t)a1,(uintptr_t)a2,(int)a3);
        case SYS_page_map: return sys_page_map((envid_t)a1,(uintptr_t)a2,(envid_t)a3,(uintptr_t)a4, (int)a5);
f0105698:	e9 cc 03 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
{
	// Hint: This function is a wrapper around page_remove().
    Env *env;

    // get valid env that we can manipulate
    if(envid2env(envid, &env, 1))
f010569d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01056a4:	00 
f01056a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01056a8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01056ac:	89 1c 24             	mov    %ebx,(%esp)
f01056af:	e8 30 e0 ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f01056b4:	89 c2                	mov    %eax,%edx
        return -E_BAD_ENV;
f01056b6:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
{
	// Hint: This function is a wrapper around page_remove().
    Env *env;

    // get valid env that we can manipulate
    if(envid2env(envid, &env, 1))
f01056bb:	85 d2                	test   %edx,%edx
f01056bd:	0f 85 a6 03 00 00    	jne    f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_BAD_ENV;
    
    // check for page alignemnt
    if((va & PGALIGN) || va >= UTOP) 
f01056c3:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f01056c9:	75 24                	jne    f01056ef <_Z7syscalljjjjjj+0x5bf>
f01056cb:	81 ff ff ff ff ee    	cmp    $0xeeffffff,%edi
f01056d1:	77 1c                	ja     f01056ef <_Z7syscalljjjjjj+0x5bf>
        return -E_INVAL;

    // remove the page
    page_remove(env->env_pgdir, va);
f01056d3:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01056d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01056da:	8b 40 10             	mov    0x10(%eax),%eax
f01056dd:	89 04 24             	mov    %eax,(%esp)
f01056e0:	e8 73 c0 ff ff       	call   f0101758 <_Z11page_removePjj>
    return 0;
f01056e5:	b8 00 00 00 00       	mov    $0x0,%eax
f01056ea:	e9 7a 03 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
    if(envid2env(envid, &env, 1))
        return -E_BAD_ENV;
    
    // check for page alignemnt
    if((va & PGALIGN) || va >= UTOP) 
        return -E_INVAL;
f01056ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
        case SYS_env_set_priority: return sys_env_set_priority((envid_t)a1,(uint32_t)a2);
        case SYS_env_set_pgfault_upcall: return sys_env_set_pgfault_upcall((envid_t)a1,(uint32_t)a2);
        case SYS_exofork: return (int32_t)sys_exofork();
        case SYS_page_alloc: return sys_page_alloc((envid_t)a1,(uintptr_t)a2,(int)a3);
        case SYS_page_map: return sys_page_map((envid_t)a1,(uintptr_t)a2,(envid_t)a3,(uintptr_t)a4, (int)a5);
        case SYS_page_unmap: return sys_page_unmap((envid_t)a1,(uintptr_t)a2);
f01056f4:	e9 70 03 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
    Program *p;
 	Env *e;
    pte_t *pte;
    
    // grab env, chceking permissions
    if (envid2env(envid, &e, true) < 0)
f01056f9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105700:	00 
f0105701:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0105704:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105708:	89 1c 24             	mov    %ebx,(%esp)
f010570b:	e8 d4 df ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f0105710:	89 c2                	mov    %eax,%edx
        return -E_BAD_ENV;
f0105712:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
    Program *p;
 	Env *e;
    pte_t *pte;
    
    // grab env, chceking permissions
    if (envid2env(envid, &e, true) < 0)
f0105717:	85 d2                	test   %edx,%edx
f0105719:	0f 88 4a 03 00 00    	js     f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_BAD_ENV;

    // validate programid
    programid -= PROGRAM_OFFSET;
f010571f:	81 ee 00 00 00 40    	sub    $0x40000000,%esi
f0105725:	89 75 d0             	mov    %esi,-0x30(%ebp)
    if (programid >= nprograms || programid < 0)
f0105728:	3b 35 2c 81 12 f0    	cmp    0xf012812c,%esi
f010572e:	0f 8d f0 01 00 00    	jge    f0105924 <_Z7syscalljjjjjj+0x7f4>
f0105734:	89 f0                	mov    %esi,%eax
f0105736:	c1 e8 1f             	shr    $0x1f,%eax
f0105739:	84 c0                	test   %al,%al
f010573b:	0f 85 e3 01 00 00    	jne    f0105924 <_Z7syscalljjjjjj+0x7f4>
        return -E_INVAL;
    p = &programs[programid];

    // go into pgdir of new environment
    lcr3(PADDR(e->env_pgdir));
f0105741:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105744:	8b 50 10             	mov    0x10(%eax),%edx
f0105747:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010574d:	77 20                	ja     f010576f <_Z7syscalljjjjjj+0x63f>
f010574f:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105753:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f010575a:	f0 
f010575b:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
f0105762:	00 
f0105763:	c7 04 24 29 91 10 f0 	movl   $0xf0109129,(%esp)
f010576a:	e8 b9 aa ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f010576f:	8d 82 00 00 00 10    	lea    0x10000000(%edx),%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0105775:	0f 22 d8             	mov    %eax,%cr3


    uint32_t bytes = 0;
    unsigned int read = ROUNDUP(va, PGSIZE) - va;
f0105778:	8d 9f ff 0f 00 00    	lea    0xfff(%edi),%ebx
f010577e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

    // a separate case for reading in all of the bytes up to page-alignment
    if (read)
f0105784:	89 de                	mov    %ebx,%esi
f0105786:	29 fe                	sub    %edi,%esi
f0105788:	0f 84 11 01 00 00    	je     f010589f <_Z7syscalljjjjjj+0x76f>
f010578e:	3b 75 1c             	cmp    0x1c(%ebp),%esi
f0105791:	0f 47 75 1c          	cmova  0x1c(%ebp),%esi
    {
        // make sure we don't over-copy
        if(read > size)
            read = size;
        if(read + offset > p->size)
f0105795:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0105798:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f010579b:	8b 04 85 68 80 12 f0 	mov    -0xfed7f98(,%eax,4),%eax
f01057a2:	8b 4d 18             	mov    0x18(%ebp),%ecx
f01057a5:	01 f1                	add    %esi,%ecx
f01057a7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        {
            read = p->size - offset;
f01057aa:	89 c1                	mov    %eax,%ecx
f01057ac:	2b 4d 18             	sub    0x18(%ebp),%ecx
f01057af:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01057b2:	0f 47 f1             	cmova  %ecx,%esi
        }
        if(read > 0)
f01057b5:	85 f6                	test   %esi,%esi
f01057b7:	0f 84 e2 00 00 00    	je     f010589f <_Z7syscalljjjjjj+0x76f>
        {
            if (!page_lookup(e->env_pgdir, va, &pte)
f01057bd:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01057c0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01057c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01057c8:	89 14 24             	mov    %edx,(%esp)
f01057cb:	e8 d1 be ff ff       	call   f01016a1 <_Z11page_lookupPjjPS_>
f01057d0:	85 c0                	test   %eax,%eax
f01057d2:	74 23                	je     f01057f7 <_Z7syscalljjjjjj+0x6c7>
                || (e->env_pgdir[PDX(va)] & (PTE_U | PTE_W)) != (PTE_U | PTE_W)
f01057d4:	89 fa                	mov    %edi,%edx
f01057d6:	c1 ea 16             	shr    $0x16,%edx
f01057d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057dc:	8b 40 10             	mov    0x10(%eax),%eax
        {
            read = p->size - offset;
        }
        if(read > 0)
        {
            if (!page_lookup(e->env_pgdir, va, &pte)
f01057df:	8b 04 90             	mov    (%eax,%edx,4),%eax
f01057e2:	83 e0 06             	and    $0x6,%eax
f01057e5:	83 f8 06             	cmp    $0x6,%eax
f01057e8:	75 0d                	jne    f01057f7 <_Z7syscalljjjjjj+0x6c7>
f01057ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01057ed:	8b 00                	mov    (%eax),%eax
f01057ef:	83 e0 06             	and    $0x6,%eax
f01057f2:	83 f8 06             	cmp    $0x6,%eax
f01057f5:	74 0d                	je     f0105804 <_Z7syscalljjjjjj+0x6d4>
                || (e->env_pgdir[PDX(va)] & (PTE_U | PTE_W)) != (PTE_U | PTE_W)
                || (*pte & (PTE_U | PTE_W)) != (PTE_U | PTE_W))
                    env_destroy(curenv);
f01057f7:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f01057fc:	89 04 24             	mov    %eax,(%esp)
f01057ff:	e8 47 e6 ff ff       	call   f0103e4b <_Z11env_destroyP3Env>
            memcpy((void *)va, (void *)(p->data + offset), read);
f0105804:	89 74 24 08          	mov    %esi,0x8(%esp)
f0105808:	6b 45 d0 0c          	imul   $0xc,-0x30(%ebp),%eax
f010580c:	8b 80 64 80 12 f0    	mov    -0xfed7f9c(%eax),%eax
f0105812:	03 45 18             	add    0x18(%ebp),%eax
f0105815:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105819:	89 3c 24             	mov    %edi,(%esp)
f010581c:	e8 b6 0f 00 00       	call   f01067d7 <memcpy>
f0105821:	eb 7c                	jmp    f010589f <_Z7syscalljjjjjj+0x76f>
    // now continue to read for the rest of the pages    
    for (uintptr_t i = ROUNDUP(va, PGSIZE); i < va + size && offset + bytes < p->size; i += PGSIZE)
    {
        // again, check permissions and don't overread
        if (!page_lookup(e->env_pgdir, i, &pte)
            || (e->env_pgdir[PDX(i)] & (PTE_U | PTE_W)) != (PTE_U | PTE_W)
f0105823:	89 da                	mov    %ebx,%edx
f0105825:	c1 ea 16             	shr    $0x16,%edx
f0105828:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010582b:	8b 40 10             	mov    0x10(%eax),%eax

    // now continue to read for the rest of the pages    
    for (uintptr_t i = ROUNDUP(va, PGSIZE); i < va + size && offset + bytes < p->size; i += PGSIZE)
    {
        // again, check permissions and don't overread
        if (!page_lookup(e->env_pgdir, i, &pte)
f010582e:	8b 04 90             	mov    (%eax,%edx,4),%eax
f0105831:	83 e0 06             	and    $0x6,%eax
f0105834:	83 f8 06             	cmp    $0x6,%eax
f0105837:	75 0d                	jne    f0105846 <_Z7syscalljjjjjj+0x716>
f0105839:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010583c:	8b 00                	mov    (%eax),%eax
f010583e:	83 e0 06             	and    $0x6,%eax
f0105841:	83 f8 06             	cmp    $0x6,%eax
f0105844:	74 0d                	je     f0105853 <_Z7syscalljjjjjj+0x723>
            || (e->env_pgdir[PDX(i)] & (PTE_U | PTE_W)) != (PTE_U | PTE_W)
            || (*pte & (PTE_U | PTE_W)) != (PTE_U | PTE_W))
            env_destroy(curenv);
f0105846:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f010584b:	89 04 24             	mov    %eax,(%esp)
f010584e:	e8 f8 e5 ff ff       	call   f0103e4b <_Z11env_destroyP3Env>
        if (p->size <= bytes + offset)
f0105853:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0105856:	8b 14 85 68 80 12 f0 	mov    -0xfed7f98(,%eax,4),%edx
            read = p->size - bytes + offset;
        else
            read = PGSIZE;
f010585d:	b8 00 10 00 00       	mov    $0x1000,%eax
        // again, check permissions and don't overread
        if (!page_lookup(e->env_pgdir, i, &pte)
            || (e->env_pgdir[PDX(i)] & (PTE_U | PTE_W)) != (PTE_U | PTE_W)
            || (*pte & (PTE_U | PTE_W)) != (PTE_U | PTE_W))
            env_destroy(curenv);
        if (p->size <= bytes + offset)
f0105862:	39 fa                	cmp    %edi,%edx
f0105864:	77 07                	ja     f010586d <_Z7syscalljjjjjj+0x73d>
            read = p->size - bytes + offset;
f0105866:	8b 45 18             	mov    0x18(%ebp),%eax
f0105869:	01 d0                	add    %edx,%eax
f010586b:	29 f0                	sub    %esi,%eax
        else
            read = PGSIZE;
        if (size - bytes < read)
f010586d:	8b 55 1c             	mov    0x1c(%ebp),%edx
f0105870:	29 f2                	sub    %esi,%edx
        if (!page_lookup(e->env_pgdir, i, &pte)
            || (e->env_pgdir[PDX(i)] & (PTE_U | PTE_W)) != (PTE_U | PTE_W)
            || (*pte & (PTE_U | PTE_W)) != (PTE_U | PTE_W))
            env_destroy(curenv);
        if (p->size <= bytes + offset)
            read = p->size - bytes + offset;
f0105872:	39 d0                	cmp    %edx,%eax
f0105874:	0f 46 d0             	cmovbe %eax,%edx
f0105877:	89 55 d0             	mov    %edx,-0x30(%ebp)
        else
            read = PGSIZE;
        if (size - bytes < read)
            read = size - bytes;
        memcpy((void *)i, (void *)(p->data + offset + bytes), read); 
f010587a:	89 54 24 08          	mov    %edx,0x8(%esp)
f010587e:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0105881:	03 3c 95 64 80 12 f0 	add    -0xfed7f9c(,%edx,4),%edi
f0105888:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010588c:	89 1c 24             	mov    %ebx,(%esp)
f010588f:	e8 43 0f 00 00       	call   f01067d7 <memcpy>
        bytes += read;
f0105894:	03 75 d0             	add    -0x30(%ebp),%esi
    
    bytes += read;


    // now continue to read for the rest of the pages    
    for (uintptr_t i = ROUNDUP(va, PGSIZE); i < va + size && offset + bytes < p->size; i += PGSIZE)
f0105897:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010589d:	eb 0c                	jmp    f01058ab <_Z7syscalljjjjjj+0x77b>
f010589f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f01058a2:	8d 0c 49             	lea    (%ecx,%ecx,2),%ecx
f01058a5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f01058a8:	89 7d c8             	mov    %edi,-0x38(%ebp)
f01058ab:	8b 45 1c             	mov    0x1c(%ebp),%eax
f01058ae:	03 45 c8             	add    -0x38(%ebp),%eax
f01058b1:	39 c3                	cmp    %eax,%ebx
f01058b3:	0f 83 fe 01 00 00    	jae    f0105ab7 <_Z7syscalljjjjjj+0x987>
f01058b9:	8b 7d 18             	mov    0x18(%ebp),%edi
f01058bc:	8d 3c 3e             	lea    (%esi,%edi,1),%edi
f01058bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01058c2:	3b 3c 85 68 80 12 f0 	cmp    -0xfed7f98(,%eax,4),%edi
f01058c9:	0f 83 e8 01 00 00    	jae    f0105ab7 <_Z7syscalljjjjjj+0x987>
    {
        // again, check permissions and don't overread
        if (!page_lookup(e->env_pgdir, i, &pte)
f01058cf:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01058d2:	89 44 24 08          	mov    %eax,0x8(%esp)
f01058d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01058da:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01058dd:	8b 40 10             	mov    0x10(%eax),%eax
f01058e0:	89 04 24             	mov    %eax,(%esp)
f01058e3:	e8 b9 bd ff ff       	call   f01016a1 <_Z11page_lookupPjjPS_>
f01058e8:	85 c0                	test   %eax,%eax
f01058ea:	0f 85 33 ff ff ff    	jne    f0105823 <_Z7syscalljjjjjj+0x6f3>
f01058f0:	e9 51 ff ff ff       	jmp    f0105846 <_Z7syscalljjjjjj+0x716>
        memcpy((void *)i, (void *)(p->data + offset + bytes), read); 
        bytes += read;
    }

    // return to the pgdir of our old (current) environment
    lcr3(PADDR(curenv->env_pgdir));
f01058f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01058f9:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0105900:	f0 
f0105901:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
f0105908:	00 
f0105909:	c7 04 24 29 91 10 f0 	movl   $0xf0109129,(%esp)
f0105910:	e8 13 a9 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0105915:	05 00 00 00 10       	add    $0x10000000,%eax
f010591a:	0f 22 d8             	mov    %eax,%cr3
	return bytes;
f010591d:	89 f0                	mov    %esi,%eax
f010591f:	e9 45 01 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_BAD_ENV;

    // validate programid
    programid -= PROGRAM_OFFSET;
    if (programid >= nprograms || programid < 0)
        return -E_INVAL;
f0105924:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
        case SYS_env_set_pgfault_upcall: return sys_env_set_pgfault_upcall((envid_t)a1,(uint32_t)a2);
        case SYS_exofork: return (int32_t)sys_exofork();
        case SYS_page_alloc: return sys_page_alloc((envid_t)a1,(uintptr_t)a2,(int)a3);
        case SYS_page_map: return sys_page_map((envid_t)a1,(uintptr_t)a2,(envid_t)a3,(uintptr_t)a4, (int)a5);
        case SYS_page_unmap: return sys_page_unmap((envid_t)a1,(uintptr_t)a2);
        case SYS_program_read: return sys_program_read((envid_t)a1, (uintptr_t)a2, (int)a3, (uint32_t)a4, (size_t)a5);
f0105929:	e9 3b 01 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>


static uint32_t
sys_time_msec(void)
{
    return time_msec();
f010592e:	e8 42 1c 00 00       	call   f0107575 <_Z9time_msecv>
        case SYS_exofork: return (int32_t)sys_exofork();
        case SYS_page_alloc: return sys_page_alloc((envid_t)a1,(uintptr_t)a2,(int)a3);
        case SYS_page_map: return sys_page_map((envid_t)a1,(uintptr_t)a2,(envid_t)a3,(uintptr_t)a4, (int)a5);
        case SYS_page_unmap: return sys_page_unmap((envid_t)a1,(uintptr_t)a2);
        case SYS_program_read: return sys_program_read((envid_t)a1, (uintptr_t)a2, (int)a3, (uint32_t)a4, (size_t)a5);
        case SYS_time_msec: return sys_time_msec();
f0105933:	e9 31 01 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
sys_program_lookup(uintptr_t name_ptr, size_t len)
{
	int i;

    // verify name of program
	user_mem_assert(curenv, name_ptr, len, PTE_U);
f0105938:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f010593f:	00 
f0105940:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0105944:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105948:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f010594d:	89 04 24             	mov    %eax,(%esp)
f0105950:	e8 36 dd ff ff       	call   f010368b <_Z15user_mem_assertP3Envjjj>
	const char *name = (const char *) name_ptr;
f0105955:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    // look for program in list of programs
	for (i = 0; i < nprograms; i++)
		if (strncmp(programs[i].name, name, len) == 0)
			return PROGRAM_OFFSET + i;

	return -E_NOT_EXEC;
f0105958:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
    // verify name of program
	user_mem_assert(curenv, name_ptr, len, PTE_U);
	const char *name = (const char *) name_ptr;

    // look for program in list of programs
	for (i = 0; i < nprograms; i++)
f010595d:	83 3d 2c 81 12 f0 00 	cmpl   $0x0,0xf012812c
f0105964:	0f 8e ff 00 00 00    	jle    f0105a69 <_Z7syscalljjjjjj+0x939>
f010596a:	bb 60 80 12 f0       	mov    $0xf0128060,%ebx
f010596f:	be 00 00 00 00       	mov    $0x0,%esi
		if (strncmp(programs[i].name, name, len) == 0)
f0105974:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0105978:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010597b:	89 54 24 04          	mov    %edx,0x4(%esp)
f010597f:	8b 03                	mov    (%ebx),%eax
f0105981:	89 04 24             	mov    %eax,(%esp)
f0105984:	e8 e1 0c 00 00       	call   f010666a <_Z7strncmpPKcS0_j>
f0105989:	85 c0                	test   %eax,%eax
f010598b:	75 0b                	jne    f0105998 <_Z7syscalljjjjjj+0x868>
			return PROGRAM_OFFSET + i;
f010598d:	8d 86 00 00 00 40    	lea    0x40000000(%esi),%eax
f0105993:	e9 d1 00 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
    // verify name of program
	user_mem_assert(curenv, name_ptr, len, PTE_U);
	const char *name = (const char *) name_ptr;

    // look for program in list of programs
	for (i = 0; i < nprograms; i++)
f0105998:	83 c6 01             	add    $0x1,%esi
f010599b:	83 c3 0c             	add    $0xc,%ebx
f010599e:	3b 35 2c 81 12 f0    	cmp    0xf012812c,%esi
f01059a4:	7c ce                	jl     f0105974 <_Z7syscalljjjjjj+0x844>
		if (strncmp(programs[i].name, name, len) == 0)
			return PROGRAM_OFFSET + i;

	return -E_NOT_EXEC;
f01059a6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
f01059ab:	e9 b9 00 00 00       	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
static int
sys_env_set_trapframe(envid_t envid, uintptr_t tf_ptr)
{
	// LAB 4: Your code here.
    Env *e;
    if (envid2env(envid, &e, true) < 0)
f01059b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01059b7:	00 
f01059b8:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01059bb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01059bf:	89 1c 24             	mov    %ebx,(%esp)
f01059c2:	e8 1d dd ff ff       	call   f01036e4 <_Z9envid2enviPP3Envb>
f01059c7:	89 c2                	mov    %eax,%edx
        return -E_BAD_ENV;
f01059c9:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
static int
sys_env_set_trapframe(envid_t envid, uintptr_t tf_ptr)
{
	// LAB 4: Your code here.
    Env *e;
    if (envid2env(envid, &e, true) < 0)
f01059ce:	85 d2                	test   %edx,%edx
f01059d0:	0f 88 93 00 00 00    	js     f0105a69 <_Z7syscalljjjjjj+0x939>
        return -E_BAD_ENV;
    user_mem_assert(curenv, tf_ptr, sizeof(Trapframe), PTE_P|PTE_U|PTE_W);
f01059d6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f01059dd:	00 
f01059de:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f01059e5:	00 
f01059e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01059ea:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f01059ef:	89 04 24             	mov    %eax,(%esp)
f01059f2:	e8 94 dc ff ff       	call   f010368b <_Z15user_mem_assertP3Envjjj>
    Trapframe *tf = (Trapframe *)tf_ptr;
    tf->tf_cs = GD_UT | 3;
f01059f7:	66 c7 47 34 1b 00    	movw   $0x1b,0x34(%edi)
    tf->tf_es = tf->tf_ds = tf->tf_ss = GD_UD | 3;
f01059fd:	66 c7 47 40 23 00    	movw   $0x23,0x40(%edi)
f0105a03:	66 c7 47 04 23 00    	movw   $0x23,0x4(%edi)
f0105a09:	66 c7 07 23 00       	movw   $0x23,(%edi)
    tf->tf_eflags |= FL_IF;
f0105a0e:	81 4f 38 00 02 00 00 	orl    $0x200,0x38(%edi)
    memcpy(&e->env_tf, (void *)tf_ptr, sizeof(Trapframe));
f0105a15:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0105a1c:	00 
f0105a1d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105a24:	83 c0 14             	add    $0x14,%eax
f0105a27:	89 04 24             	mov    %eax,(%esp)
f0105a2a:	e8 a8 0d 00 00       	call   f01067d7 <memcpy>
    return 0;
f0105a2f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105a34:	eb 33                	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
}

static int
sys_e1000_transmit(uintptr_t buffer, size_t len)
{   
    user_mem_assert(curenv, buffer, len, 0);
f0105a36:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0105a3d:	00 
f0105a3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0105a42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105a46:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0105a4b:	89 04 24             	mov    %eax,(%esp)
f0105a4e:	e8 38 dc ff ff       	call   f010368b <_Z15user_mem_assertP3Envjjj>
    return e1000_transmit((void *)buffer, (size_t)len);
f0105a53:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105a57:	89 1c 24             	mov    %ebx,(%esp)
f0105a5a:	e8 e9 12 00 00       	call   f0106d48 <_Z14e1000_transmitPvj>
        case SYS_page_unmap: return sys_page_unmap((envid_t)a1,(uintptr_t)a2);
        case SYS_program_read: return sys_program_read((envid_t)a1, (uintptr_t)a2, (int)a3, (uint32_t)a4, (size_t)a5);
        case SYS_time_msec: return sys_time_msec();
        case SYS_program_lookup: return sys_program_lookup((uintptr_t)a1, (size_t)a2);
        case SYS_env_set_trapframe: return sys_env_set_trapframe((envid_t) a1, (uintptr_t) a2);
        case SYS_e1000_transmit: return sys_e1000_transmit((uintptr_t)a1, (size_t)a2); 
f0105a5f:	eb 08                	jmp    f0105a69 <_Z7syscalljjjjjj+0x939>
}

static int
sys_e1000_receive(uintptr_t buffer)
{
    return e1000_receive((void *)buffer);
f0105a61:	89 1c 24             	mov    %ebx,(%esp)
f0105a64:	e8 b4 13 00 00       	call   f0106e1d <_Z13e1000_receivePv>
        case SYS_env_set_trapframe: return sys_env_set_trapframe((envid_t) a1, (uintptr_t) a2);
        case SYS_e1000_transmit: return sys_e1000_transmit((uintptr_t)a1, (size_t)a2); 
        case SYS_e1000_receive: return sys_e1000_receive((uintptr_t)a1);
        default: return -E_INVAL;
    }
}
f0105a69:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0105a6c:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0105a6f:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0105a72:	89 ec                	mov    %ebp,%esp
f0105a74:	5d                   	pop    %ebp
f0105a75:	c3                   	ret    
       (srcva % PGSIZE || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) ||
       !(perm & PTE_U) || !(perm & PTE_P)))
            return -E_INVAL;

    // transmit the message
    e->env_ipc_recving = 0;
f0105a76:	c6 42 60 00          	movb   $0x0,0x60(%edx)
    e->env_ipc_value = value;
f0105a7a:	89 7a 68             	mov    %edi,0x68(%edx)
    e->env_ipc_from = curenv->env_id;
f0105a7d:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0105a82:	8b 48 04             	mov    0x4(%eax),%ecx
f0105a85:	89 4a 6c             	mov    %ecx,0x6c(%edx)


    int ret = 0;

    // if we are supposed to map a page as part of the message, do so
    if(srcva < UTOP && e->env_ipc_dstva < UTOP)
f0105a88:	81 7a 64 ff ff ff ee 	cmpl   $0xeeffffff,0x64(%edx)
f0105a8f:	0f 87 b7 f8 ff ff    	ja     f010534c <_Z7syscalljjjjjj+0x21c>
f0105a95:	e9 43 f8 ff ff       	jmp    f01052dd <_Z7syscalljjjjjj+0x1ad>
    if(envid2env(dstenvid, &dstenv, 1) || envid2env(srcenvid, &srcenv, 1) ||
       !dstenv || !srcenv)
        return -E_BAD_ENV;
    // check alignemnt and permissions
    
    if((srcva & PGALIGN) || srcva >= UTOP || (dstva & PGALIGN) || dstva >= UTOP || (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) || !(perm & PTE_U) || !(perm & PTE_P))
f0105a9a:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f0105aa0:	0f 85 ed fb ff ff    	jne    f0105693 <_Z7syscalljjjjjj+0x563>
f0105aa6:	81 ff ff ff ff ee    	cmp    $0xeeffffff,%edi
f0105aac:	0f 87 e1 fb ff ff    	ja     f0105693 <_Z7syscalljjjjjj+0x563>
f0105ab2:	e9 31 fb ff ff       	jmp    f01055e8 <_Z7syscalljjjjjj+0x4b8>
        memcpy((void *)i, (void *)(p->data + offset + bytes), read); 
        bytes += read;
    }

    // return to the pgdir of our old (current) environment
    lcr3(PADDR(curenv->env_pgdir));
f0105ab7:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0105abc:	8b 40 10             	mov    0x10(%eax),%eax
f0105abf:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0105ac4:	0f 87 4b fe ff ff    	ja     f0105915 <_Z7syscalljjjjjj+0x7e5>
f0105aca:	e9 26 fe ff ff       	jmp    f01058f5 <_Z7syscalljjjjjj+0x7c5>
	...

f0105ad0 <_ZL14stab_binsearchPK4StabPiS2_ij>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105ad0:	55                   	push   %ebp
f0105ad1:	89 e5                	mov    %esp,%ebp
f0105ad3:	57                   	push   %edi
f0105ad4:	56                   	push   %esi
f0105ad5:	53                   	push   %ebx
f0105ad6:	83 ec 14             	sub    $0x14,%esp
f0105ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105adc:	89 55 e8             	mov    %edx,-0x18(%ebp)
f0105adf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105ae2:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105ae5:	8b 12                	mov    (%edx),%edx
f0105ae7:	8b 09                	mov    (%ecx),%ecx
f0105ae9:	89 4d ec             	mov    %ecx,-0x14(%ebp)

	while (l <= r) {
f0105aec:	39 ca                	cmp    %ecx,%edx
f0105aee:	0f 8f 89 00 00 00    	jg     f0105b7d <_ZL14stab_binsearchPK4StabPiS2_ij+0xad>
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
f0105af4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
f0105afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105afe:	01 d0                	add    %edx,%eax
f0105b00:	89 c6                	mov    %eax,%esi
f0105b02:	c1 ee 1f             	shr    $0x1f,%esi
f0105b05:	01 c6                	add    %eax,%esi
f0105b07:	d1 fe                	sar    %esi

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105b09:	8d 04 76             	lea    (%esi,%esi,2),%eax
//		left = 0, right = 657;
//		stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
f0105b0c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0105b0f:	8d 4c 83 04          	lea    0x4(%ebx,%eax,4),%ecx
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
f0105b13:	89 f0                	mov    %esi,%eax

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105b15:	39 d0                	cmp    %edx,%eax
f0105b17:	0f 8c b8 00 00 00    	jl     f0105bd5 <_ZL14stab_binsearchPK4StabPiS2_ij+0x105>
f0105b1d:	0f b6 19             	movzbl (%ecx),%ebx
f0105b20:	83 e9 0c             	sub    $0xc,%ecx
f0105b23:	39 fb                	cmp    %edi,%ebx
f0105b25:	0f 84 88 00 00 00    	je     f0105bb3 <_ZL14stab_binsearchPK4StabPiS2_ij+0xe3>
			m--;
f0105b2b:	83 e8 01             	sub    $0x1,%eax
f0105b2e:	eb e5                	jmp    f0105b15 <_ZL14stab_binsearchPK4StabPiS2_ij+0x45>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0105b30:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105b33:	89 02                	mov    %eax,(%edx)
			l = true_m + 1;
f0105b35:	8d 56 01             	lea    0x1(%esi),%edx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105b38:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0105b3f:	eb 31                	jmp    f0105b72 <_ZL14stab_binsearchPK4StabPiS2_ij+0xa2>
		if (stabs[m].n_value < addr) {
			*region_left = m;
			l = true_m + 1;
		} else if (stabs[m].n_value > addr) {
f0105b41:	3b 4d 0c             	cmp    0xc(%ebp),%ecx
f0105b44:	76 17                	jbe    f0105b5d <_ZL14stab_binsearchPK4StabPiS2_ij+0x8d>
			*region_right = m - 1;
f0105b46:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105b49:	83 e9 01             	sub    $0x1,%ecx
f0105b4c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
f0105b4f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0105b52:	89 0b                	mov    %ecx,(%ebx)
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105b54:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0105b5b:	eb 15                	jmp    f0105b72 <_ZL14stab_binsearchPK4StabPiS2_ij+0xa2>
			*region_right = m - 1;
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105b5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105b60:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105b63:	89 0a                	mov    %ecx,(%edx)
			l = m;
			addr++;
f0105b65:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105b69:	89 c2                	mov    %eax,%edx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105b6b:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
f0105b72:	3b 55 ec             	cmp    -0x14(%ebp),%edx
f0105b75:	7e 84                	jle    f0105afb <_ZL14stab_binsearchPK4StabPiS2_ij+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0105b77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105b7b:	75 0f                	jne    f0105b8c <_ZL14stab_binsearchPK4StabPiS2_ij+0xbc>
		*region_right = *region_left - 1;
f0105b7d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0105b80:	8b 03                	mov    (%ebx),%eax
f0105b82:	83 e8 01             	sub    $0x1,%eax
f0105b85:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105b88:	89 02                	mov    %eax,(%edx)
f0105b8a:	eb 4e                	jmp    f0105bda <_ZL14stab_binsearchPK4StabPiS2_ij+0x10a>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105b8c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105b8f:	8b 01                	mov    (%ecx),%eax
f0105b91:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0105b94:	8b 0b                	mov    (%ebx),%ecx
		     l > *region_left && stabs[l].n_type != type;
f0105b96:	8d 14 40             	lea    (%eax,%eax,2),%edx
//		left = 0, right = 657;
//		stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
f0105b99:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0105b9c:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105ba0:	39 c8                	cmp    %ecx,%eax
f0105ba2:	7e 2a                	jle    f0105bce <_ZL14stab_binsearchPK4StabPiS2_ij+0xfe>
f0105ba4:	0f b6 1a             	movzbl (%edx),%ebx
f0105ba7:	83 ea 0c             	sub    $0xc,%edx
f0105baa:	39 fb                	cmp    %edi,%ebx
f0105bac:	74 20                	je     f0105bce <_ZL14stab_binsearchPK4StabPiS2_ij+0xfe>
f0105bae:	83 e8 01             	sub    $0x1,%eax
f0105bb1:	eb ed                	jmp    f0105ba0 <_ZL14stab_binsearchPK4StabPiS2_ij+0xd0>

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105bb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105bb6:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0105bb9:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0105bbc:	8b 4c 8b 08          	mov    0x8(%ebx,%ecx,4),%ecx
f0105bc0:	3b 4d 0c             	cmp    0xc(%ebp),%ecx
f0105bc3:	0f 82 67 ff ff ff    	jb     f0105b30 <_ZL14stab_binsearchPK4StabPiS2_ij+0x60>
f0105bc9:	e9 73 ff ff ff       	jmp    f0105b41 <_ZL14stab_binsearchPK4StabPiS2_ij+0x71>
		// find rightmost region containing 'addr'
		for (l = *region_right;
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f0105bce:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0105bd1:	89 02                	mov    %eax,(%edx)
f0105bd3:	eb 05                	jmp    f0105bda <_ZL14stab_binsearchPK4StabPiS2_ij+0x10a>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105bd5:	8d 56 01             	lea    0x1(%esi),%edx
			continue;
f0105bd8:	eb 98                	jmp    f0105b72 <_ZL14stab_binsearchPK4StabPiS2_ij+0xa2>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0105bda:	83 c4 14             	add    $0x14,%esp
f0105bdd:	5b                   	pop    %ebx
f0105bde:	5e                   	pop    %esi
f0105bdf:	5f                   	pop    %edi
f0105be0:	5d                   	pop    %ebp
f0105be1:	c3                   	ret    

f0105be2 <_Z13debuginfo_eipjP12Eipdebuginfo>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105be2:	55                   	push   %ebp
f0105be3:	89 e5                	mov    %esp,%ebp
f0105be5:	83 ec 68             	sub    $0x68,%esp
f0105be8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0105beb:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0105bee:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0105bf1:	8b 75 08             	mov    0x8(%ebp),%esi
f0105bf4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;
	int num_args;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105bf7:	c7 03 88 91 10 f0    	movl   $0xf0109188,(%ebx)
	info->eip_line = 0;
f0105bfd:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105c04:	c7 43 08 88 91 10 f0 	movl   $0xf0109188,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0105c0b:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105c12:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105c15:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105c1c:	81 fe ff ff bf ef    	cmp    $0xefbfffff,%esi
f0105c22:	0f 87 ca 00 00 00    	ja     f0105cf2 <_Z13debuginfo_eipjP12Eipdebuginfo+0x110>
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid in the current environment.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
        if(user_mem_check(curenv, (uintptr_t)usd, sizeof *usd, PTE_U) < 0)
f0105c28:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105c2f:	00 
f0105c30:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0105c37:	00 
f0105c38:	c7 44 24 04 00 00 20 	movl   $0x200000,0x4(%esp)
f0105c3f:	00 
f0105c40:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0105c45:	89 04 24             	mov    %eax,(%esp)
f0105c48:	e8 6e d9 ff ff       	call   f01035bb <_Z14user_mem_checkP3Envjjj>
f0105c4d:	89 c2                	mov    %eax,%edx
            return -1;
f0105c4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid in the current environment.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
        if(user_mem_check(curenv, (uintptr_t)usd, sizeof *usd, PTE_U) < 0)
f0105c54:	85 d2                	test   %edx,%edx
f0105c56:	0f 88 44 02 00 00    	js     f0105ea0 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2be>
            return -1;
		stabs = usd->stabs;
f0105c5c:	a1 00 00 20 00       	mov    0x200000,%eax
f0105c61:	89 45 c0             	mov    %eax,-0x40(%ebp)
		stab_end = usd->stab_end;
f0105c64:	8b 15 04 00 20 00    	mov    0x200004,%edx
f0105c6a:	89 55 bc             	mov    %edx,-0x44(%ebp)
		stabstr = usd->stabstr;
f0105c6d:	8b 0d 08 00 20 00    	mov    0x200008,%ecx
f0105c73:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105c76:	8b 3d 0c 00 20 00    	mov    0x20000c,%edi

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
        if(user_mem_check(curenv,(uintptr_t)stabs, stab_end-stabs+1, PTE_U)<0 ||
f0105c7c:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105c83:	00 
f0105c84:	89 d0                	mov    %edx,%eax
f0105c86:	2b 45 c0             	sub    -0x40(%ebp),%eax
f0105c89:	c1 f8 02             	sar    $0x2,%eax
f0105c8c:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0105c92:	83 c0 01             	add    $0x1,%eax
f0105c95:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105c99:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0105c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105ca0:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0105ca5:	89 04 24             	mov    %eax,(%esp)
f0105ca8:	e8 0e d9 ff ff       	call   f01035bb <_Z14user_mem_checkP3Envjjj>
f0105cad:	89 c2                	mov    %eax,%edx
           user_mem_check(curenv, (uintptr_t)stabstr, stabstr_end-stabstr+1, PTE_U) < 0)
            return -1;
f0105caf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		stabstr = usd->stabstr;
		stabstr_end = usd->stabstr_end;

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
        if(user_mem_check(curenv,(uintptr_t)stabs, stab_end-stabs+1, PTE_U)<0 ||
f0105cb4:	85 d2                	test   %edx,%edx
f0105cb6:	0f 88 e4 01 00 00    	js     f0105ea0 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2be>
           user_mem_check(curenv, (uintptr_t)stabstr, stabstr_end-stabstr+1, PTE_U) < 0)
f0105cbc:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0105cc3:	00 
f0105cc4:	8d 47 01             	lea    0x1(%edi),%eax
f0105cc7:	2b 45 c4             	sub    -0x3c(%ebp),%eax
f0105cca:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105cce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0105cd1:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105cd5:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0105cda:	89 04 24             	mov    %eax,(%esp)
f0105cdd:	e8 d9 d8 ff ff       	call   f01035bb <_Z14user_mem_checkP3Envjjj>
f0105ce2:	89 c2                	mov    %eax,%edx
            return -1;
f0105ce4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		stabstr = usd->stabstr;
		stabstr_end = usd->stabstr_end;

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
        if(user_mem_check(curenv,(uintptr_t)stabs, stab_end-stabs+1, PTE_U)<0 ||
f0105ce9:	85 d2                	test   %edx,%edx
f0105ceb:	79 1f                	jns    f0105d0c <_Z13debuginfo_eipjP12Eipdebuginfo+0x12a>
f0105ced:	e9 ae 01 00 00       	jmp    f0105ea0 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2be>
	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0105cf2:	bf 1d e2 11 f0       	mov    $0xf011e21d,%edi

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
f0105cf7:	c7 45 c4 75 6c 11 f0 	movl   $0xf0116c75,-0x3c(%ebp)
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
f0105cfe:	c7 45 bc 74 6c 11 f0 	movl   $0xf0116c74,-0x44(%ebp)
	info->eip_fn_addr = addr;
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
f0105d05:	c7 45 c0 e0 97 10 f0 	movl   $0xf01097e0,-0x40(%ebp)
            return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f0105d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
           user_mem_check(curenv, (uintptr_t)stabstr, stabstr_end-stabstr+1, PTE_U) < 0)
            return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105d11:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
f0105d14:	0f 83 86 01 00 00    	jae    f0105ea0 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2be>
f0105d1a:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
f0105d1e:	0f 85 77 01 00 00    	jne    f0105e9b <_Z13debuginfo_eipjP12Eipdebuginfo+0x2b9>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0105d24:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0105d2b:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0105d2e:	2b 45 c0             	sub    -0x40(%ebp),%eax
f0105d31:	c1 f8 02             	sar    $0x2,%eax
f0105d34:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0105d3a:	83 e8 01             	sub    $0x1,%eax
f0105d3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0105d40:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105d44:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0105d4b:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0105d4e:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105d51:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0105d54:	e8 77 fd ff ff       	call   f0105ad0 <_ZL14stab_binsearchPK4StabPiS2_ij>
	if (lfile == 0)
f0105d59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
		return -1;
f0105d5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
	rfile = (stab_end - stabs) - 1;
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
	if (lfile == 0)
f0105d61:	85 d2                	test   %edx,%edx
f0105d63:	0f 84 37 01 00 00    	je     f0105ea0 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2be>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105d69:	89 55 dc             	mov    %edx,-0x24(%ebp)
	rfun = rfile;
f0105d6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105d72:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105d76:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0105d7d:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0105d80:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105d83:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0105d86:	e8 45 fd ff ff       	call   f0105ad0 <_ZL14stab_binsearchPK4StabPiS2_ij>

	if (lfun <= rfun) {
f0105d8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105d8e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105d91:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
f0105d94:	39 ca                	cmp    %ecx,%edx
f0105d96:	7f 31                	jg     f0105dc9 <_Z13debuginfo_eipjP12Eipdebuginfo+0x1e7>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < (uint32_t) (stabstr_end - stabstr))
f0105d98:	6b c2 0c             	imul   $0xc,%edx,%eax
f0105d9b:	03 45 c0             	add    -0x40(%ebp),%eax
f0105d9e:	8b 08                	mov    (%eax),%ecx
f0105da0:	89 4d bc             	mov    %ecx,-0x44(%ebp)
f0105da3:	89 f9                	mov    %edi,%ecx
f0105da5:	2b 4d c4             	sub    -0x3c(%ebp),%ecx
f0105da8:	39 4d bc             	cmp    %ecx,-0x44(%ebp)
f0105dab:	73 09                	jae    f0105db6 <_Z13debuginfo_eipjP12Eipdebuginfo+0x1d4>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105dad:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0105db0:	03 4d bc             	add    -0x44(%ebp),%ecx
f0105db3:	89 4b 08             	mov    %ecx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105db6:	8b 40 08             	mov    0x8(%eax),%eax
f0105db9:	89 43 10             	mov    %eax,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105dbc:	29 c6                	sub    %eax,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0105dbe:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		rline = rfun;
f0105dc1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
f0105dc4:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105dc7:	eb 0f                	jmp    f0105dd8 <_Z13debuginfo_eipjP12Eipdebuginfo+0x1f6>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0105dc9:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0105dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105dcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105dd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105dd5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105dd8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0105ddf:	00 
f0105de0:	8b 43 08             	mov    0x8(%ebx),%eax
f0105de3:	89 04 24             	mov    %eax,(%esp)
f0105de6:	e8 ef 08 00 00       	call   f01066da <_Z7strfindPKcc>
f0105deb:	2b 43 08             	sub    0x8(%ebx),%eax
f0105dee:	89 43 0c             	mov    %eax,0xc(%ebx)


	// Search within [lline, rline] for the line number stab.
	// If found, set info->eip_line to the right line number.
	// If not found, return -1.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105df1:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105df5:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0105dfc:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105dff:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105e02:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0105e05:	e8 c6 fc ff ff       	call   f0105ad0 <_ZL14stab_binsearchPK4StabPiS2_ij>
	if (lline <= rline)
f0105e0a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
		info->eip_line = stabs[lline].n_desc;
	else
		return -1;
f0105e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	// Search within [lline, rline] for the line number stab.
	// If found, set info->eip_line to the right line number.
	// If not found, return -1.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
	if (lline <= rline)
f0105e12:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0105e15:	0f 8f 85 00 00 00    	jg     f0105ea0 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2be>
		info->eip_line = stabs[lline].n_desc;
f0105e1b:	6b d2 0c             	imul   $0xc,%edx,%edx
f0105e1e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0105e21:	0f b7 44 11 06       	movzwl 0x6(%ecx,%edx,1),%eax
f0105e26:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e2c:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0105e2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
f0105e32:	8d 54 11 08          	lea    0x8(%ecx,%edx,1),%edx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105e36:	39 45 bc             	cmp    %eax,-0x44(%ebp)
f0105e39:	7f 72                	jg     f0105ead <_Z13debuginfo_eipjP12Eipdebuginfo+0x2cb>
f0105e3b:	0f b6 4a fc          	movzbl -0x4(%edx),%ecx
f0105e3f:	80 f9 84             	cmp    $0x84,%cl
f0105e42:	75 05                	jne    f0105e49 <_Z13debuginfo_eipjP12Eipdebuginfo+0x267>
f0105e44:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105e47:	eb 69                	jmp    f0105eb2 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2d0>
f0105e49:	80 f9 64             	cmp    $0x64,%cl
f0105e4c:	75 0a                	jne    f0105e58 <_Z13debuginfo_eipjP12Eipdebuginfo+0x276>
f0105e4e:	83 3a 00             	cmpl   $0x0,(%edx)
f0105e51:	74 05                	je     f0105e58 <_Z13debuginfo_eipjP12Eipdebuginfo+0x276>
f0105e53:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105e56:	eb 5a                	jmp    f0105eb2 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2d0>
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
f0105e58:	83 e8 01             	sub    $0x1,%eax
f0105e5b:	83 ea 0c             	sub    $0xc,%edx
f0105e5e:	eb d6                	jmp    f0105e36 <_Z13debuginfo_eipjP12Eipdebuginfo+0x254>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile
	    && stabs[lline].n_strx < (uint32_t) (stabstr_end - stabstr))
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105e60:	03 45 c4             	add    -0x3c(%ebp),%eax
f0105e63:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	num_args = 0;
	while (++lfun <= rfile && stabs[lfun].n_type == N_PSYM)
f0105e65:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105e68:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105e6b:	8d 41 01             	lea    0x1(%ecx),%eax
f0105e6e:	6b c0 0c             	imul   $0xc,%eax,%eax
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
f0105e71:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0105e74:	8d 54 07 04          	lea    0x4(%edi,%eax,1),%edx
f0105e78:	b8 00 00 00 00       	mov    $0x0,%eax
f0105e7d:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
f0105e80:	8d 79 01             	lea    0x1(%ecx),%edi
f0105e83:	89 f9                	mov    %edi,%ecx


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	num_args = 0;
	while (++lfun <= rfile && stabs[lfun].n_type == N_PSYM)
f0105e85:	39 f7                	cmp    %esi,%edi
f0105e87:	7f 3b                	jg     f0105ec4 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2e2>
f0105e89:	0f b6 3a             	movzbl (%edx),%edi
f0105e8c:	83 c2 0c             	add    $0xc,%edx
f0105e8f:	89 fb                	mov    %edi,%ebx
f0105e91:	80 fb a0             	cmp    $0xa0,%bl
f0105e94:	75 2e                	jne    f0105ec4 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2e2>
		num_args++;
f0105e96:	83 c0 01             	add    $0x1,%eax
f0105e99:	eb e5                	jmp    f0105e80 <_Z13debuginfo_eipjP12Eipdebuginfo+0x29e>
            return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f0105e9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	while (++lfun <= rfile && stabs[lfun].n_type == N_PSYM)
		num_args++;
	info->eip_fn_narg = num_args;

	return 0;
}
f0105ea0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0105ea3:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0105ea6:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0105ea9:	89 ec                	mov    %ebp,%esp
f0105eab:	5d                   	pop    %ebp
f0105eac:	c3                   	ret    

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	num_args = 0;
	while (++lfun <= rfile && stabs[lfun].n_type == N_PSYM)
		num_args++;
f0105ead:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105eb0:	eb b3                	jmp    f0105e65 <_Z13debuginfo_eipjP12Eipdebuginfo+0x283>
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile
	    && stabs[lline].n_strx < (uint32_t) (stabstr_end - stabstr))
f0105eb2:	6b c0 0c             	imul   $0xc,%eax,%eax
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile
f0105eb5:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0105eb8:	8b 04 02             	mov    (%edx,%eax,1),%eax
f0105ebb:	2b 7d c4             	sub    -0x3c(%ebp),%edi
f0105ebe:	39 f8                	cmp    %edi,%eax
f0105ec0:	72 9e                	jb     f0105e60 <_Z13debuginfo_eipjP12Eipdebuginfo+0x27e>
f0105ec2:	eb a1                	jmp    f0105e65 <_Z13debuginfo_eipjP12Eipdebuginfo+0x283>
f0105ec4:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	num_args = 0;
	while (++lfun <= rfile && stabs[lfun].n_type == N_PSYM)
		num_args++;
	info->eip_fn_narg = num_args;
f0105ec7:	89 43 14             	mov    %eax,0x14(%ebx)

	return 0;
f0105eca:	b8 00 00 00 00       	mov    $0x0,%eax
f0105ecf:	eb cf                	jmp    f0105ea0 <_Z13debuginfo_eipjP12Eipdebuginfo+0x2be>
	...

f0105ee0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105ee0:	55                   	push   %ebp
f0105ee1:	89 e5                	mov    %esp,%ebp
f0105ee3:	57                   	push   %edi
f0105ee4:	56                   	push   %esi
f0105ee5:	53                   	push   %ebx
f0105ee6:	83 ec 4c             	sub    $0x4c,%esp
f0105ee9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105eec:	89 d6                	mov    %edx,%esi
f0105eee:	8b 45 08             	mov    0x8(%ebp),%eax
f0105ef1:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0105ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105ef7:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0105efa:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105efd:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105f00:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f05:	39 d0                	cmp    %edx,%eax
f0105f07:	72 11                	jb     f0105f1a <_ZL8printnumPFviPvES_yjii+0x3a>
f0105f09:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105f0c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
f0105f0f:	76 09                	jbe    f0105f1a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0105f11:	83 eb 01             	sub    $0x1,%ebx
f0105f14:	85 db                	test   %ebx,%ebx
f0105f16:	7f 5d                	jg     f0105f75 <_ZL8printnumPFviPvES_yjii+0x95>
f0105f18:	eb 6c                	jmp    f0105f86 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105f1a:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0105f1e:	83 eb 01             	sub    $0x1,%ebx
f0105f21:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0105f25:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0105f28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0105f2c:	8b 44 24 08          	mov    0x8(%esp),%eax
f0105f30:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0105f34:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105f37:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105f3a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0105f41:	00 
f0105f42:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105f45:	89 14 24             	mov    %edx,(%esp)
f0105f48:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105f4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105f4f:	e8 3c 16 00 00       	call   f0107590 <__udivdi3>
f0105f54:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0105f57:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0105f5a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105f5e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0105f62:	89 04 24             	mov    %eax,(%esp)
f0105f65:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105f69:	89 f2                	mov    %esi,%edx
f0105f6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105f6e:	e8 6d ff ff ff       	call   f0105ee0 <_ZL8printnumPFviPvES_yjii>
f0105f73:	eb 11                	jmp    f0105f86 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0105f75:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105f79:	89 3c 24             	mov    %edi,(%esp)
f0105f7c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0105f7f:	83 eb 01             	sub    $0x1,%ebx
f0105f82:	85 db                	test   %ebx,%ebx
f0105f84:	7f ef                	jg     f0105f75 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105f86:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105f8a:	8b 74 24 04          	mov    0x4(%esp),%esi
f0105f8e:	8b 45 10             	mov    0x10(%ebp),%eax
f0105f91:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105f95:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0105f9c:	00 
f0105f9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105fa0:	89 14 24             	mov    %edx,(%esp)
f0105fa3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105fa6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105faa:	e8 f1 16 00 00       	call   f01076a0 <__umoddi3>
f0105faf:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105fb3:	0f be 80 92 91 10 f0 	movsbl -0xfef6e6e(%eax),%eax
f0105fba:	89 04 24             	mov    %eax,(%esp)
f0105fbd:	ff 55 e4             	call   *-0x1c(%ebp)
}
f0105fc0:	83 c4 4c             	add    $0x4c,%esp
f0105fc3:	5b                   	pop    %ebx
f0105fc4:	5e                   	pop    %esi
f0105fc5:	5f                   	pop    %edi
f0105fc6:	5d                   	pop    %ebp
f0105fc7:	c3                   	ret    

f0105fc8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0105fc8:	55                   	push   %ebp
f0105fc9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0105fcb:	83 fa 01             	cmp    $0x1,%edx
f0105fce:	7e 0e                	jle    f0105fde <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
f0105fd0:	8b 10                	mov    (%eax),%edx
f0105fd2:	8d 4a 08             	lea    0x8(%edx),%ecx
f0105fd5:	89 08                	mov    %ecx,(%eax)
f0105fd7:	8b 02                	mov    (%edx),%eax
f0105fd9:	8b 52 04             	mov    0x4(%edx),%edx
f0105fdc:	eb 22                	jmp    f0106000 <_ZL7getuintPPci+0x38>
	else if (lflag)
f0105fde:	85 d2                	test   %edx,%edx
f0105fe0:	74 10                	je     f0105ff2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
f0105fe2:	8b 10                	mov    (%eax),%edx
f0105fe4:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105fe7:	89 08                	mov    %ecx,(%eax)
f0105fe9:	8b 02                	mov    (%edx),%eax
f0105feb:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ff0:	eb 0e                	jmp    f0106000 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
f0105ff2:	8b 10                	mov    (%eax),%edx
f0105ff4:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105ff7:	89 08                	mov    %ecx,(%eax)
f0105ff9:	8b 02                	mov    (%edx),%eax
f0105ffb:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0106000:	5d                   	pop    %ebp
f0106001:	c3                   	ret    

f0106002 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
f0106002:	55                   	push   %ebp
f0106003:	89 e5                	mov    %esp,%ebp
f0106005:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
f0106008:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f010600c:	8b 10                	mov    (%eax),%edx
f010600e:	3b 50 04             	cmp    0x4(%eax),%edx
f0106011:	73 0a                	jae    f010601d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
f0106013:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106016:	88 0a                	mov    %cl,(%edx)
f0106018:	83 c2 01             	add    $0x1,%edx
f010601b:	89 10                	mov    %edx,(%eax)
}
f010601d:	5d                   	pop    %ebp
f010601e:	c3                   	ret    

f010601f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f010601f:	55                   	push   %ebp
f0106020:	89 e5                	mov    %esp,%ebp
f0106022:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
f0106025:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0106028:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010602c:	8b 45 10             	mov    0x10(%ebp),%eax
f010602f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106033:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106036:	89 44 24 04          	mov    %eax,0x4(%esp)
f010603a:	8b 45 08             	mov    0x8(%ebp),%eax
f010603d:	89 04 24             	mov    %eax,(%esp)
f0106040:	e8 02 00 00 00       	call   f0106047 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
f0106045:	c9                   	leave  
f0106046:	c3                   	ret    

f0106047 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0106047:	55                   	push   %ebp
f0106048:	89 e5                	mov    %esp,%ebp
f010604a:	57                   	push   %edi
f010604b:	56                   	push   %esi
f010604c:	53                   	push   %ebx
f010604d:	83 ec 3c             	sub    $0x3c,%esp
f0106050:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106053:	8b 55 10             	mov    0x10(%ebp),%edx
f0106056:	0f b6 02             	movzbl (%edx),%eax
f0106059:	89 d3                	mov    %edx,%ebx
f010605b:	83 c3 01             	add    $0x1,%ebx
f010605e:	83 f8 25             	cmp    $0x25,%eax
f0106061:	74 2b                	je     f010608e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
f0106063:	85 c0                	test   %eax,%eax
f0106065:	75 10                	jne    f0106077 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
f0106067:	e9 a5 03 00 00       	jmp    f0106411 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
f010606c:	85 c0                	test   %eax,%eax
f010606e:	66 90                	xchg   %ax,%ax
f0106070:	75 08                	jne    f010607a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
f0106072:	e9 9a 03 00 00       	jmp    f0106411 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
f0106077:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
f010607a:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010607e:	89 04 24             	mov    %eax,(%esp)
f0106081:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106083:	0f b6 03             	movzbl (%ebx),%eax
f0106086:	83 c3 01             	add    $0x1,%ebx
f0106089:	83 f8 25             	cmp    $0x25,%eax
f010608c:	75 de                	jne    f010606c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
f010608e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
f0106092:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0106099:	be ff ff ff ff       	mov    $0xffffffff,%esi
f010609e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f01060a5:	b9 00 00 00 00       	mov    $0x0,%ecx
f01060aa:	89 75 d8             	mov    %esi,-0x28(%ebp)
f01060ad:	eb 2b                	jmp    f01060da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01060af:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
f01060b2:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
f01060b6:	eb 22                	jmp    f01060da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01060b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f01060bb:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
f01060bf:	eb 19                	jmp    f01060da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01060c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
f01060c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01060cb:	eb 0d                	jmp    f01060da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f01060cd:	8b 75 d8             	mov    -0x28(%ebp),%esi
f01060d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f01060d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01060da:	0f b6 03             	movzbl (%ebx),%eax
f01060dd:	0f b6 d0             	movzbl %al,%edx
f01060e0:	8d 73 01             	lea    0x1(%ebx),%esi
f01060e3:	89 75 10             	mov    %esi,0x10(%ebp)
f01060e6:	83 e8 23             	sub    $0x23,%eax
f01060e9:	3c 55                	cmp    $0x55,%al
f01060eb:	0f 87 d8 02 00 00    	ja     f01063c9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
f01060f1:	0f b6 c0             	movzbl %al,%eax
f01060f4:	ff 24 85 20 93 10 f0 	jmp    *-0xfef6ce0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f01060fb:	83 ea 30             	sub    $0x30,%edx
f01060fe:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
f0106101:	8b 55 10             	mov    0x10(%ebp),%edx
f0106104:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
f0106107:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010610a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
f010610d:	83 fa 09             	cmp    $0x9,%edx
f0106110:	77 4e                	ja     f0106160 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0106112:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0106115:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f0106118:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f010611b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f010611f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
f0106122:	8d 50 d0             	lea    -0x30(%eax),%edx
f0106125:	83 fa 09             	cmp    $0x9,%edx
f0106128:	76 eb                	jbe    f0106115 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
f010612a:	89 75 d8             	mov    %esi,-0x28(%ebp)
f010612d:	eb 31                	jmp    f0106160 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f010612f:	8b 45 14             	mov    0x14(%ebp),%eax
f0106132:	8d 50 04             	lea    0x4(%eax),%edx
f0106135:	89 55 14             	mov    %edx,0x14(%ebp)
f0106138:	8b 00                	mov    (%eax),%eax
f010613a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010613d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0106140:	eb 1e                	jmp    f0106160 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
f0106142:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0106146:	0f 88 75 ff ff ff    	js     f01060c1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010614c:	8b 5d 10             	mov    0x10(%ebp),%ebx
f010614f:	eb 89                	jmp    f01060da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
f0106151:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f0106154:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
f010615b:	e9 7a ff ff ff       	jmp    f01060da <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
f0106160:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0106164:	0f 89 70 ff ff ff    	jns    f01060da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
f010616a:	e9 5e ff ff ff       	jmp    f01060cd <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f010616f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0106172:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0106175:	e9 60 ff ff ff       	jmp    f01060da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f010617a:	8b 45 14             	mov    0x14(%ebp),%eax
f010617d:	8d 50 04             	lea    0x4(%eax),%edx
f0106180:	89 55 14             	mov    %edx,0x14(%ebp)
f0106183:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106187:	8b 00                	mov    (%eax),%eax
f0106189:	89 04 24             	mov    %eax,(%esp)
f010618c:	ff 55 08             	call   *0x8(%ebp)
			break;
f010618f:	e9 bf fe ff ff       	jmp    f0106053 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
f0106194:	8b 45 14             	mov    0x14(%ebp),%eax
f0106197:	8d 50 04             	lea    0x4(%eax),%edx
f010619a:	89 55 14             	mov    %edx,0x14(%ebp)
f010619d:	8b 00                	mov    (%eax),%eax
f010619f:	89 c2                	mov    %eax,%edx
f01061a1:	c1 fa 1f             	sar    $0x1f,%edx
f01061a4:	31 d0                	xor    %edx,%eax
f01061a6:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
f01061a8:	83 f8 14             	cmp    $0x14,%eax
f01061ab:	7f 0f                	jg     f01061bc <_Z9vprintfmtPFviPvES_PKcPc+0x175>
f01061ad:	8b 14 85 80 94 10 f0 	mov    -0xfef6b80(,%eax,4),%edx
f01061b4:	85 d2                	test   %edx,%edx
f01061b6:	0f 85 35 02 00 00    	jne    f01063f1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
f01061bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01061c0:	c7 44 24 08 aa 91 10 	movl   $0xf01091aa,0x8(%esp)
f01061c7:	f0 
f01061c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01061cc:	8b 75 08             	mov    0x8(%ebp),%esi
f01061cf:	89 34 24             	mov    %esi,(%esp)
f01061d2:	e8 48 fe ff ff       	call   f010601f <_Z8printfmtPFviPvES_PKcz>
f01061d7:	e9 77 fe ff ff       	jmp    f0106053 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
f01061dc:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01061df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01061e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f01061e5:	8b 45 14             	mov    0x14(%ebp),%eax
f01061e8:	8d 50 04             	lea    0x4(%eax),%edx
f01061eb:	89 55 14             	mov    %edx,0x14(%ebp)
f01061ee:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
f01061f0:	85 db                	test   %ebx,%ebx
f01061f2:	ba a3 91 10 f0       	mov    $0xf01091a3,%edx
f01061f7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
f01061fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01061fe:	7e 72                	jle    f0106272 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
f0106200:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
f0106204:	74 6c                	je     f0106272 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
f0106206:	89 74 24 04          	mov    %esi,0x4(%esp)
f010620a:	89 1c 24             	mov    %ebx,(%esp)
f010620d:	e8 89 03 00 00       	call   f010659b <_Z7strnlenPKcj>
f0106212:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0106215:	29 c2                	sub    %eax,%edx
f0106217:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010621a:	85 d2                	test   %edx,%edx
f010621c:	7e 54                	jle    f0106272 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
f010621e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
f0106222:	89 5d d8             	mov    %ebx,-0x28(%ebp)
f0106225:	89 d3                	mov    %edx,%ebx
f0106227:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f010622a:	89 c6                	mov    %eax,%esi
f010622c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106230:	89 34 24             	mov    %esi,(%esp)
f0106233:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0106236:	83 eb 01             	sub    $0x1,%ebx
f0106239:	85 db                	test   %ebx,%ebx
f010623b:	7f ef                	jg     f010622c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
f010623d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0106240:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0106243:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f010624a:	eb 26                	jmp    f0106272 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f010624c:	8d 50 e0             	lea    -0x20(%eax),%edx
f010624f:	83 fa 5e             	cmp    $0x5e,%edx
f0106252:	76 10                	jbe    f0106264 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
f0106254:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106258:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f010625f:	ff 55 08             	call   *0x8(%ebp)
f0106262:	eb 0a                	jmp    f010626e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
f0106264:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106268:	89 04 24             	mov    %eax,(%esp)
f010626b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010626e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0106272:	0f be 03             	movsbl (%ebx),%eax
f0106275:	83 c3 01             	add    $0x1,%ebx
f0106278:	85 c0                	test   %eax,%eax
f010627a:	74 11                	je     f010628d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
f010627c:	85 f6                	test   %esi,%esi
f010627e:	78 05                	js     f0106285 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
f0106280:	83 ee 01             	sub    $0x1,%esi
f0106283:	78 0d                	js     f0106292 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
f0106285:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0106289:	75 c1                	jne    f010624c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
f010628b:	eb d7                	jmp    f0106264 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010628d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106290:	eb 03                	jmp    f0106295 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
f0106292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0106295:	85 c0                	test   %eax,%eax
f0106297:	0f 8e b6 fd ff ff    	jle    f0106053 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
f010629d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01062a0:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
f01062a3:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01062a7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01062ae:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f01062b0:	83 eb 01             	sub    $0x1,%ebx
f01062b3:	85 db                	test   %ebx,%ebx
f01062b5:	7f ec                	jg     f01062a3 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
f01062b7:	e9 97 fd ff ff       	jmp    f0106053 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f01062bc:	83 f9 01             	cmp    $0x1,%ecx
f01062bf:	90                   	nop
f01062c0:	7e 10                	jle    f01062d2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
f01062c2:	8b 45 14             	mov    0x14(%ebp),%eax
f01062c5:	8d 50 08             	lea    0x8(%eax),%edx
f01062c8:	89 55 14             	mov    %edx,0x14(%ebp)
f01062cb:	8b 18                	mov    (%eax),%ebx
f01062cd:	8b 70 04             	mov    0x4(%eax),%esi
f01062d0:	eb 26                	jmp    f01062f8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
f01062d2:	85 c9                	test   %ecx,%ecx
f01062d4:	74 12                	je     f01062e8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
f01062d6:	8b 45 14             	mov    0x14(%ebp),%eax
f01062d9:	8d 50 04             	lea    0x4(%eax),%edx
f01062dc:	89 55 14             	mov    %edx,0x14(%ebp)
f01062df:	8b 18                	mov    (%eax),%ebx
f01062e1:	89 de                	mov    %ebx,%esi
f01062e3:	c1 fe 1f             	sar    $0x1f,%esi
f01062e6:	eb 10                	jmp    f01062f8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
f01062e8:	8b 45 14             	mov    0x14(%ebp),%eax
f01062eb:	8d 50 04             	lea    0x4(%eax),%edx
f01062ee:	89 55 14             	mov    %edx,0x14(%ebp)
f01062f1:	8b 18                	mov    (%eax),%ebx
f01062f3:	89 de                	mov    %ebx,%esi
f01062f5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f01062f8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f01062fd:	85 f6                	test   %esi,%esi
f01062ff:	0f 89 8c 00 00 00    	jns    f0106391 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
f0106305:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106309:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f0106310:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f0106313:	f7 db                	neg    %ebx
f0106315:	83 d6 00             	adc    $0x0,%esi
f0106318:	f7 de                	neg    %esi
			}
			base = 10;
f010631a:	b8 0a 00 00 00       	mov    $0xa,%eax
f010631f:	eb 70                	jmp    f0106391 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0106321:	89 ca                	mov    %ecx,%edx
f0106323:	8d 45 14             	lea    0x14(%ebp),%eax
f0106326:	e8 9d fc ff ff       	call   f0105fc8 <_ZL7getuintPPci>
f010632b:	89 c3                	mov    %eax,%ebx
f010632d:	89 d6                	mov    %edx,%esi
			base = 10;
f010632f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
f0106334:	eb 5b                	jmp    f0106391 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
f0106336:	89 ca                	mov    %ecx,%edx
f0106338:	8d 45 14             	lea    0x14(%ebp),%eax
f010633b:	e8 88 fc ff ff       	call   f0105fc8 <_ZL7getuintPPci>
f0106340:	89 c3                	mov    %eax,%ebx
f0106342:	89 d6                	mov    %edx,%esi
			base = 8;
f0106344:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
f0106349:	eb 46                	jmp    f0106391 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
f010634b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010634f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0106356:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f0106359:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010635d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0106364:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f0106367:	8b 45 14             	mov    0x14(%ebp),%eax
f010636a:	8d 50 04             	lea    0x4(%eax),%edx
f010636d:	89 55 14             	mov    %edx,0x14(%ebp)
f0106370:	8b 18                	mov    (%eax),%ebx
f0106372:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
f0106377:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
f010637c:	eb 13                	jmp    f0106391 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f010637e:	89 ca                	mov    %ecx,%edx
f0106380:	8d 45 14             	lea    0x14(%ebp),%eax
f0106383:	e8 40 fc ff ff       	call   f0105fc8 <_ZL7getuintPPci>
f0106388:	89 c3                	mov    %eax,%ebx
f010638a:	89 d6                	mov    %edx,%esi
			base = 16;
f010638c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
f0106391:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
f0106395:	89 54 24 10          	mov    %edx,0x10(%esp)
f0106399:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010639c:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01063a0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01063a4:	89 1c 24             	mov    %ebx,(%esp)
f01063a7:	89 74 24 04          	mov    %esi,0x4(%esp)
f01063ab:	89 fa                	mov    %edi,%edx
f01063ad:	8b 45 08             	mov    0x8(%ebp),%eax
f01063b0:	e8 2b fb ff ff       	call   f0105ee0 <_ZL8printnumPFviPvES_yjii>
			break;
f01063b5:	e9 99 fc ff ff       	jmp    f0106053 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f01063ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01063be:	89 14 24             	mov    %edx,(%esp)
f01063c1:	ff 55 08             	call   *0x8(%ebp)
			break;
f01063c4:	e9 8a fc ff ff       	jmp    f0106053 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f01063c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01063cd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f01063d4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f01063d7:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01063da:	89 d8                	mov    %ebx,%eax
f01063dc:	eb 02                	jmp    f01063e0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
f01063de:	89 d0                	mov    %edx,%eax
f01063e0:	8d 50 ff             	lea    -0x1(%eax),%edx
f01063e3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01063e7:	75 f5                	jne    f01063de <_Z9vprintfmtPFviPvES_PKcPc+0x397>
f01063e9:	89 45 10             	mov    %eax,0x10(%ebp)
f01063ec:	e9 62 fc ff ff       	jmp    f0106053 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f01063f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01063f5:	c7 44 24 08 e3 88 10 	movl   $0xf01088e3,0x8(%esp)
f01063fc:	f0 
f01063fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106401:	8b 75 08             	mov    0x8(%ebp),%esi
f0106404:	89 34 24             	mov    %esi,(%esp)
f0106407:	e8 13 fc ff ff       	call   f010601f <_Z8printfmtPFviPvES_PKcz>
f010640c:	e9 42 fc ff ff       	jmp    f0106053 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
f0106411:	83 c4 3c             	add    $0x3c,%esp
f0106414:	5b                   	pop    %ebx
f0106415:	5e                   	pop    %esi
f0106416:	5f                   	pop    %edi
f0106417:	5d                   	pop    %ebp
f0106418:	c3                   	ret    

f0106419 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0106419:	55                   	push   %ebp
f010641a:	89 e5                	mov    %esp,%ebp
f010641c:	83 ec 28             	sub    $0x28,%esp
f010641f:	8b 45 08             	mov    0x8(%ebp),%eax
f0106422:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0106425:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f010642c:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010642f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0106433:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
f0106436:	85 c0                	test   %eax,%eax
f0106438:	74 30                	je     f010646a <_Z9vsnprintfPciPKcS_+0x51>
f010643a:	85 d2                	test   %edx,%edx
f010643c:	7e 2c                	jle    f010646a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
f010643e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106441:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106445:	8b 45 10             	mov    0x10(%ebp),%eax
f0106448:	89 44 24 08          	mov    %eax,0x8(%esp)
f010644c:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010644f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106453:	c7 04 24 02 60 10 f0 	movl   $0xf0106002,(%esp)
f010645a:	e8 e8 fb ff ff       	call   f0106047 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
f010645f:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0106462:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0106465:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106468:	eb 05                	jmp    f010646f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f010646a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f010646f:	c9                   	leave  
f0106470:	c3                   	ret    

f0106471 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0106471:	55                   	push   %ebp
f0106472:	89 e5                	mov    %esp,%ebp
f0106474:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106477:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010647a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010647e:	8b 45 10             	mov    0x10(%ebp),%eax
f0106481:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106485:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106488:	89 44 24 04          	mov    %eax,0x4(%esp)
f010648c:	8b 45 08             	mov    0x8(%ebp),%eax
f010648f:	89 04 24             	mov    %eax,(%esp)
f0106492:	e8 82 ff ff ff       	call   f0106419 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
f0106497:	c9                   	leave  
f0106498:	c3                   	ret    
f0106499:	00 00                	add    %al,(%eax)
f010649b:	00 00                	add    %al,(%eax)
f010649d:	00 00                	add    %al,(%eax)
	...

f01064a0 <_Z8readlinePKc>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01064a0:	55                   	push   %ebp
f01064a1:	89 e5                	mov    %esp,%ebp
f01064a3:	57                   	push   %edi
f01064a4:	56                   	push   %esi
f01064a5:	53                   	push   %ebx
f01064a6:	83 ec 1c             	sub    $0x1c,%esp
f01064a9:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f01064ac:	85 c0                	test   %eax,%eax
f01064ae:	74 10                	je     f01064c0 <_Z8readlinePKc+0x20>
		cprintf("%s", prompt);
f01064b0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01064b4:	c7 04 24 e3 88 10 f0 	movl   $0xf01088e3,(%esp)
f01064bb:	e8 f2 db ff ff       	call   f01040b2 <_Z7cprintfPKcz>

	i = 0;
	echoing = iscons(0) > 0;
f01064c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01064c7:	e8 74 a7 ff ff       	call   f0100c40 <_Z6isconsi>
f01064cc:	85 c0                	test   %eax,%eax
f01064ce:	0f 9f c0             	setg   %al
f01064d1:	0f b6 c0             	movzbl %al,%eax
f01064d4:	89 c7                	mov    %eax,%edi
	int i, c, echoing;

	if (prompt != NULL)
		cprintf("%s", prompt);

	i = 0;
f01064d6:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0) > 0;
	while (1) {
		c = getchar();
f01064db:	e8 4f a7 ff ff       	call   f0100c2f <_Z7getcharv>
f01064e0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01064e2:	85 c0                	test   %eax,%eax
f01064e4:	79 17                	jns    f01064fd <_Z8readlinePKc+0x5d>
			cprintf("read error: %e\n", c);
f01064e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01064ea:	c7 04 24 d4 94 10 f0 	movl   $0xf01094d4,(%esp)
f01064f1:	e8 bc db ff ff       	call   f01040b2 <_Z7cprintfPKcz>
			return NULL;
f01064f6:	b8 00 00 00 00       	mov    $0x0,%eax
f01064fb:	eb 70                	jmp    f010656d <_Z8readlinePKc+0xcd>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01064fd:	83 f8 08             	cmp    $0x8,%eax
f0106500:	74 05                	je     f0106507 <_Z8readlinePKc+0x67>
f0106502:	83 f8 7f             	cmp    $0x7f,%eax
f0106505:	75 1c                	jne    f0106523 <_Z8readlinePKc+0x83>
f0106507:	85 f6                	test   %esi,%esi
f0106509:	7e 18                	jle    f0106523 <_Z8readlinePKc+0x83>
			if (echoing)
f010650b:	85 ff                	test   %edi,%edi
f010650d:	8d 76 00             	lea    0x0(%esi),%esi
f0106510:	74 0c                	je     f010651e <_Z8readlinePKc+0x7e>
				cputchar('\b');
f0106512:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0106519:	e8 e4 a6 ff ff       	call   f0100c02 <_Z8cputchari>
			i--;
f010651e:	83 ee 01             	sub    $0x1,%esi
f0106521:	eb b8                	jmp    f01064db <_Z8readlinePKc+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0106523:	83 fb 1f             	cmp    $0x1f,%ebx
f0106526:	7e 1f                	jle    f0106547 <_Z8readlinePKc+0xa7>
f0106528:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f010652e:	7f 17                	jg     f0106547 <_Z8readlinePKc+0xa7>
			if (echoing)
f0106530:	85 ff                	test   %edi,%edi
f0106532:	74 08                	je     f010653c <_Z8readlinePKc+0x9c>
				cputchar(c);
f0106534:	89 1c 24             	mov    %ebx,(%esp)
f0106537:	e8 c6 a6 ff ff       	call   f0100c02 <_Z8cputchari>
			buf[i++] = c;
f010653c:	88 9e 60 8b 37 f0    	mov    %bl,-0xfc874a0(%esi)
f0106542:	83 c6 01             	add    $0x1,%esi
f0106545:	eb 94                	jmp    f01064db <_Z8readlinePKc+0x3b>
		} else if (c == '\n' || c == '\r') {
f0106547:	83 fb 0a             	cmp    $0xa,%ebx
f010654a:	74 05                	je     f0106551 <_Z8readlinePKc+0xb1>
f010654c:	83 fb 0d             	cmp    $0xd,%ebx
f010654f:	75 8a                	jne    f01064db <_Z8readlinePKc+0x3b>
			if (echoing)
f0106551:	85 ff                	test   %edi,%edi
f0106553:	74 0c                	je     f0106561 <_Z8readlinePKc+0xc1>
				cputchar('\n');
f0106555:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f010655c:	e8 a1 a6 ff ff       	call   f0100c02 <_Z8cputchari>
			buf[i] = 0;
f0106561:	c6 86 60 8b 37 f0 00 	movb   $0x0,-0xfc874a0(%esi)
			return buf;
f0106568:	b8 60 8b 37 f0       	mov    $0xf0378b60,%eax
		}
	}
}
f010656d:	83 c4 1c             	add    $0x1c,%esp
f0106570:	5b                   	pop    %ebx
f0106571:	5e                   	pop    %esi
f0106572:	5f                   	pop    %edi
f0106573:	5d                   	pop    %ebp
f0106574:	c3                   	ret    
	...

f0106580 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106580:	55                   	push   %ebp
f0106581:	89 e5                	mov    %esp,%ebp
f0106583:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0106586:	b8 00 00 00 00       	mov    $0x0,%eax
f010658b:	80 3a 00             	cmpb   $0x0,(%edx)
f010658e:	74 09                	je     f0106599 <_Z6strlenPKc+0x19>
		n++;
f0106590:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0106593:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106597:	75 f7                	jne    f0106590 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
f0106599:	5d                   	pop    %ebp
f010659a:	c3                   	ret    

f010659b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
f010659b:	55                   	push   %ebp
f010659c:	89 e5                	mov    %esp,%ebp
f010659e:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01065a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01065a4:	b8 00 00 00 00       	mov    $0x0,%eax
f01065a9:	39 c2                	cmp    %eax,%edx
f01065ab:	74 0b                	je     f01065b8 <_Z7strnlenPKcj+0x1d>
f01065ad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f01065b1:	74 05                	je     f01065b8 <_Z7strnlenPKcj+0x1d>
		n++;
f01065b3:	83 c0 01             	add    $0x1,%eax
f01065b6:	eb f1                	jmp    f01065a9 <_Z7strnlenPKcj+0xe>
	return n;
}
f01065b8:	5d                   	pop    %ebp
f01065b9:	c3                   	ret    

f01065ba <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
f01065ba:	55                   	push   %ebp
f01065bb:	89 e5                	mov    %esp,%ebp
f01065bd:	53                   	push   %ebx
f01065be:	8b 45 08             	mov    0x8(%ebp),%eax
f01065c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
f01065c4:	ba 00 00 00 00       	mov    $0x0,%edx
f01065c9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f01065cd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f01065d0:	83 c2 01             	add    $0x1,%edx
f01065d3:	84 c9                	test   %cl,%cl
f01065d5:	75 f2                	jne    f01065c9 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
f01065d7:	5b                   	pop    %ebx
f01065d8:	5d                   	pop    %ebp
f01065d9:	c3                   	ret    

f01065da <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
f01065da:	55                   	push   %ebp
f01065db:	89 e5                	mov    %esp,%ebp
f01065dd:	56                   	push   %esi
f01065de:	53                   	push   %ebx
f01065df:	8b 45 08             	mov    0x8(%ebp),%eax
f01065e2:	8b 55 0c             	mov    0xc(%ebp),%edx
f01065e5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
f01065e8:	85 f6                	test   %esi,%esi
f01065ea:	74 18                	je     f0106604 <_Z7strncpyPcPKcj+0x2a>
f01065ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f01065f1:	0f b6 1a             	movzbl (%edx),%ebx
f01065f4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01065f7:	80 3a 01             	cmpb   $0x1,(%edx)
f01065fa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
f01065fd:	83 c1 01             	add    $0x1,%ecx
f0106600:	39 ce                	cmp    %ecx,%esi
f0106602:	77 ed                	ja     f01065f1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0106604:	5b                   	pop    %ebx
f0106605:	5e                   	pop    %esi
f0106606:	5d                   	pop    %ebp
f0106607:	c3                   	ret    

f0106608 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0106608:	55                   	push   %ebp
f0106609:	89 e5                	mov    %esp,%ebp
f010660b:	56                   	push   %esi
f010660c:	53                   	push   %ebx
f010660d:	8b 75 08             	mov    0x8(%ebp),%esi
f0106610:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106613:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
f0106616:	89 f0                	mov    %esi,%eax
f0106618:	85 d2                	test   %edx,%edx
f010661a:	74 17                	je     f0106633 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
f010661c:	83 ea 01             	sub    $0x1,%edx
f010661f:	74 18                	je     f0106639 <_Z7strlcpyPcPKcj+0x31>
f0106621:	80 39 00             	cmpb   $0x0,(%ecx)
f0106624:	74 17                	je     f010663d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
f0106626:	0f b6 19             	movzbl (%ecx),%ebx
f0106629:	88 18                	mov    %bl,(%eax)
f010662b:	83 c0 01             	add    $0x1,%eax
f010662e:	83 c1 01             	add    $0x1,%ecx
f0106631:	eb e9                	jmp    f010661c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
f0106633:	29 f0                	sub    %esi,%eax
}
f0106635:	5b                   	pop    %ebx
f0106636:	5e                   	pop    %esi
f0106637:	5d                   	pop    %ebp
f0106638:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0106639:	89 c2                	mov    %eax,%edx
f010663b:	eb 02                	jmp    f010663f <_Z7strlcpyPcPKcj+0x37>
f010663d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
f010663f:	c6 02 00             	movb   $0x0,(%edx)
f0106642:	eb ef                	jmp    f0106633 <_Z7strlcpyPcPKcj+0x2b>

f0106644 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
f0106644:	55                   	push   %ebp
f0106645:	89 e5                	mov    %esp,%ebp
f0106647:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010664a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f010664d:	0f b6 01             	movzbl (%ecx),%eax
f0106650:	84 c0                	test   %al,%al
f0106652:	74 0c                	je     f0106660 <_Z6strcmpPKcS0_+0x1c>
f0106654:	3a 02                	cmp    (%edx),%al
f0106656:	75 08                	jne    f0106660 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
f0106658:	83 c1 01             	add    $0x1,%ecx
f010665b:	83 c2 01             	add    $0x1,%edx
f010665e:	eb ed                	jmp    f010664d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
f0106660:	0f b6 c0             	movzbl %al,%eax
f0106663:	0f b6 12             	movzbl (%edx),%edx
f0106666:	29 d0                	sub    %edx,%eax
}
f0106668:	5d                   	pop    %ebp
f0106669:	c3                   	ret    

f010666a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010666a:	55                   	push   %ebp
f010666b:	89 e5                	mov    %esp,%ebp
f010666d:	53                   	push   %ebx
f010666e:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106671:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106674:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
f0106677:	85 d2                	test   %edx,%edx
f0106679:	74 16                	je     f0106691 <_Z7strncmpPKcS0_j+0x27>
f010667b:	0f b6 01             	movzbl (%ecx),%eax
f010667e:	84 c0                	test   %al,%al
f0106680:	74 17                	je     f0106699 <_Z7strncmpPKcS0_j+0x2f>
f0106682:	3a 03                	cmp    (%ebx),%al
f0106684:	75 13                	jne    f0106699 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
f0106686:	83 ea 01             	sub    $0x1,%edx
f0106689:	83 c1 01             	add    $0x1,%ecx
f010668c:	83 c3 01             	add    $0x1,%ebx
f010668f:	eb e6                	jmp    f0106677 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
f0106691:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
f0106696:	5b                   	pop    %ebx
f0106697:	5d                   	pop    %ebp
f0106698:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
f0106699:	0f b6 01             	movzbl (%ecx),%eax
f010669c:	0f b6 13             	movzbl (%ebx),%edx
f010669f:	29 d0                	sub    %edx,%eax
f01066a1:	eb f3                	jmp    f0106696 <_Z7strncmpPKcS0_j+0x2c>

f01066a3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01066a3:	55                   	push   %ebp
f01066a4:	89 e5                	mov    %esp,%ebp
f01066a6:	8b 45 08             	mov    0x8(%ebp),%eax
f01066a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01066ad:	0f b6 10             	movzbl (%eax),%edx
f01066b0:	84 d2                	test   %dl,%dl
f01066b2:	74 1f                	je     f01066d3 <_Z6strchrPKcc+0x30>
		if (*s == c)
f01066b4:	38 ca                	cmp    %cl,%dl
f01066b6:	75 0a                	jne    f01066c2 <_Z6strchrPKcc+0x1f>
f01066b8:	eb 1e                	jmp    f01066d8 <_Z6strchrPKcc+0x35>
f01066ba:	38 ca                	cmp    %cl,%dl
f01066bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01066c0:	74 16                	je     f01066d8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f01066c2:	83 c0 01             	add    $0x1,%eax
f01066c5:	0f b6 10             	movzbl (%eax),%edx
f01066c8:	84 d2                	test   %dl,%dl
f01066ca:	75 ee                	jne    f01066ba <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
f01066cc:	b8 00 00 00 00       	mov    $0x0,%eax
f01066d1:	eb 05                	jmp    f01066d8 <_Z6strchrPKcc+0x35>
f01066d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01066d8:	5d                   	pop    %ebp
f01066d9:	c3                   	ret    

f01066da <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01066da:	55                   	push   %ebp
f01066db:	89 e5                	mov    %esp,%ebp
f01066dd:	8b 45 08             	mov    0x8(%ebp),%eax
f01066e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01066e4:	0f b6 10             	movzbl (%eax),%edx
f01066e7:	84 d2                	test   %dl,%dl
f01066e9:	74 14                	je     f01066ff <_Z7strfindPKcc+0x25>
		if (*s == c)
f01066eb:	38 ca                	cmp    %cl,%dl
f01066ed:	75 06                	jne    f01066f5 <_Z7strfindPKcc+0x1b>
f01066ef:	eb 0e                	jmp    f01066ff <_Z7strfindPKcc+0x25>
f01066f1:	38 ca                	cmp    %cl,%dl
f01066f3:	74 0a                	je     f01066ff <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f01066f5:	83 c0 01             	add    $0x1,%eax
f01066f8:	0f b6 10             	movzbl (%eax),%edx
f01066fb:	84 d2                	test   %dl,%dl
f01066fd:	75 f2                	jne    f01066f1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
f01066ff:	5d                   	pop    %ebp
f0106700:	c3                   	ret    

f0106701 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
f0106701:	55                   	push   %ebp
f0106702:	89 e5                	mov    %esp,%ebp
f0106704:	83 ec 0c             	sub    $0xc,%esp
f0106707:	89 1c 24             	mov    %ebx,(%esp)
f010670a:	89 74 24 04          	mov    %esi,0x4(%esp)
f010670e:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0106712:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106715:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106718:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
f010671b:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0106721:	75 25                	jne    f0106748 <memset+0x47>
f0106723:	f6 c1 03             	test   $0x3,%cl
f0106726:	75 20                	jne    f0106748 <memset+0x47>
		c &= 0xFF;
f0106728:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f010672b:	89 d3                	mov    %edx,%ebx
f010672d:	c1 e3 08             	shl    $0x8,%ebx
f0106730:	89 d6                	mov    %edx,%esi
f0106732:	c1 e6 18             	shl    $0x18,%esi
f0106735:	89 d0                	mov    %edx,%eax
f0106737:	c1 e0 10             	shl    $0x10,%eax
f010673a:	09 f0                	or     %esi,%eax
f010673c:	09 d0                	or     %edx,%eax
f010673e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
f0106740:	c1 e9 02             	shr    $0x2,%ecx
f0106743:	fc                   	cld    
f0106744:	f3 ab                	rep stos %eax,%es:(%edi)
f0106746:	eb 03                	jmp    f010674b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
f0106748:	fc                   	cld    
f0106749:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
f010674b:	89 f8                	mov    %edi,%eax
f010674d:	8b 1c 24             	mov    (%esp),%ebx
f0106750:	8b 74 24 04          	mov    0x4(%esp),%esi
f0106754:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0106758:	89 ec                	mov    %ebp,%esp
f010675a:	5d                   	pop    %ebp
f010675b:	c3                   	ret    

f010675c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
f010675c:	55                   	push   %ebp
f010675d:	89 e5                	mov    %esp,%ebp
f010675f:	83 ec 08             	sub    $0x8,%esp
f0106762:	89 34 24             	mov    %esi,(%esp)
f0106765:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106769:	8b 45 08             	mov    0x8(%ebp),%eax
f010676c:	8b 75 0c             	mov    0xc(%ebp),%esi
f010676f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
f0106772:	39 c6                	cmp    %eax,%esi
f0106774:	73 36                	jae    f01067ac <memmove+0x50>
f0106776:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106779:	39 d0                	cmp    %edx,%eax
f010677b:	73 2f                	jae    f01067ac <memmove+0x50>
		s += n;
		d += n;
f010677d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
f0106780:	f6 c2 03             	test   $0x3,%dl
f0106783:	75 1b                	jne    f01067a0 <memmove+0x44>
f0106785:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010678b:	75 13                	jne    f01067a0 <memmove+0x44>
f010678d:	f6 c1 03             	test   $0x3,%cl
f0106790:	75 0e                	jne    f01067a0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106792:	83 ef 04             	sub    $0x4,%edi
f0106795:	8d 72 fc             	lea    -0x4(%edx),%esi
f0106798:	c1 e9 02             	shr    $0x2,%ecx
f010679b:	fd                   	std    
f010679c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010679e:	eb 09                	jmp    f01067a9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f01067a0:	83 ef 01             	sub    $0x1,%edi
f01067a3:	8d 72 ff             	lea    -0x1(%edx),%esi
f01067a6:	fd                   	std    
f01067a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f01067a9:	fc                   	cld    
f01067aa:	eb 20                	jmp    f01067cc <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
f01067ac:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01067b2:	75 13                	jne    f01067c7 <memmove+0x6b>
f01067b4:	a8 03                	test   $0x3,%al
f01067b6:	75 0f                	jne    f01067c7 <memmove+0x6b>
f01067b8:	f6 c1 03             	test   $0x3,%cl
f01067bb:	75 0a                	jne    f01067c7 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f01067bd:	c1 e9 02             	shr    $0x2,%ecx
f01067c0:	89 c7                	mov    %eax,%edi
f01067c2:	fc                   	cld    
f01067c3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01067c5:	eb 05                	jmp    f01067cc <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
f01067c7:	89 c7                	mov    %eax,%edi
f01067c9:	fc                   	cld    
f01067ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
f01067cc:	8b 34 24             	mov    (%esp),%esi
f01067cf:	8b 7c 24 04          	mov    0x4(%esp),%edi
f01067d3:	89 ec                	mov    %ebp,%esp
f01067d5:	5d                   	pop    %ebp
f01067d6:	c3                   	ret    

f01067d7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
f01067d7:	55                   	push   %ebp
f01067d8:	89 e5                	mov    %esp,%ebp
f01067da:	83 ec 08             	sub    $0x8,%esp
f01067dd:	89 34 24             	mov    %esi,(%esp)
f01067e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01067e4:	8b 45 08             	mov    0x8(%ebp),%eax
f01067e7:	8b 75 0c             	mov    0xc(%ebp),%esi
f01067ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
f01067ed:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01067f3:	75 13                	jne    f0106808 <memcpy+0x31>
f01067f5:	a8 03                	test   $0x3,%al
f01067f7:	75 0f                	jne    f0106808 <memcpy+0x31>
f01067f9:	f6 c1 03             	test   $0x3,%cl
f01067fc:	75 0a                	jne    f0106808 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f01067fe:	c1 e9 02             	shr    $0x2,%ecx
f0106801:	89 c7                	mov    %eax,%edi
f0106803:	fc                   	cld    
f0106804:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106806:	eb 05                	jmp    f010680d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
f0106808:	89 c7                	mov    %eax,%edi
f010680a:	fc                   	cld    
f010680b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
f010680d:	8b 34 24             	mov    (%esp),%esi
f0106810:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0106814:	89 ec                	mov    %ebp,%esp
f0106816:	5d                   	pop    %ebp
f0106817:	c3                   	ret    

f0106818 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
f0106818:	55                   	push   %ebp
f0106819:	89 e5                	mov    %esp,%ebp
f010681b:	57                   	push   %edi
f010681c:	56                   	push   %esi
f010681d:	53                   	push   %ebx
f010681e:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0106821:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106824:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
f0106827:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
f010682c:	85 ff                	test   %edi,%edi
f010682e:	74 38                	je     f0106868 <memcmp+0x50>
		if (*s1 != *s2)
f0106830:	0f b6 03             	movzbl (%ebx),%eax
f0106833:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
f0106836:	83 ef 01             	sub    $0x1,%edi
f0106839:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
f010683e:	38 c8                	cmp    %cl,%al
f0106840:	74 1d                	je     f010685f <memcmp+0x47>
f0106842:	eb 11                	jmp    f0106855 <memcmp+0x3d>
f0106844:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
f0106849:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
f010684e:	83 c2 01             	add    $0x1,%edx
f0106851:	38 c8                	cmp    %cl,%al
f0106853:	74 0a                	je     f010685f <memcmp+0x47>
			return *s1 - *s2;
f0106855:	0f b6 c0             	movzbl %al,%eax
f0106858:	0f b6 c9             	movzbl %cl,%ecx
f010685b:	29 c8                	sub    %ecx,%eax
f010685d:	eb 09                	jmp    f0106868 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
f010685f:	39 fa                	cmp    %edi,%edx
f0106861:	75 e1                	jne    f0106844 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
f0106863:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106868:	5b                   	pop    %ebx
f0106869:	5e                   	pop    %esi
f010686a:	5f                   	pop    %edi
f010686b:	5d                   	pop    %ebp
f010686c:	c3                   	ret    

f010686d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
f010686d:	55                   	push   %ebp
f010686e:	89 e5                	mov    %esp,%ebp
f0106870:	53                   	push   %ebx
f0106871:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
f0106874:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
f0106876:	89 da                	mov    %ebx,%edx
f0106878:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
f010687b:	39 d3                	cmp    %edx,%ebx
f010687d:	73 15                	jae    f0106894 <memfind+0x27>
		if (*s == (unsigned char) c)
f010687f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f0106883:	38 0b                	cmp    %cl,(%ebx)
f0106885:	75 06                	jne    f010688d <memfind+0x20>
f0106887:	eb 0b                	jmp    f0106894 <memfind+0x27>
f0106889:	38 08                	cmp    %cl,(%eax)
f010688b:	74 07                	je     f0106894 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
f010688d:	83 c0 01             	add    $0x1,%eax
f0106890:	39 c2                	cmp    %eax,%edx
f0106892:	77 f5                	ja     f0106889 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
f0106894:	5b                   	pop    %ebx
f0106895:	5d                   	pop    %ebp
f0106896:	c3                   	ret    

f0106897 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
f0106897:	55                   	push   %ebp
f0106898:	89 e5                	mov    %esp,%ebp
f010689a:	57                   	push   %edi
f010689b:	56                   	push   %esi
f010689c:	53                   	push   %ebx
f010689d:	8b 55 08             	mov    0x8(%ebp),%edx
f01068a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01068a3:	0f b6 02             	movzbl (%edx),%eax
f01068a6:	3c 20                	cmp    $0x20,%al
f01068a8:	74 04                	je     f01068ae <_Z6strtolPKcPPci+0x17>
f01068aa:	3c 09                	cmp    $0x9,%al
f01068ac:	75 0e                	jne    f01068bc <_Z6strtolPKcPPci+0x25>
		s++;
f01068ae:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01068b1:	0f b6 02             	movzbl (%edx),%eax
f01068b4:	3c 20                	cmp    $0x20,%al
f01068b6:	74 f6                	je     f01068ae <_Z6strtolPKcPPci+0x17>
f01068b8:	3c 09                	cmp    $0x9,%al
f01068ba:	74 f2                	je     f01068ae <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
f01068bc:	3c 2b                	cmp    $0x2b,%al
f01068be:	75 0a                	jne    f01068ca <_Z6strtolPKcPPci+0x33>
		s++;
f01068c0:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f01068c3:	bf 00 00 00 00       	mov    $0x0,%edi
f01068c8:	eb 10                	jmp    f01068da <_Z6strtolPKcPPci+0x43>
f01068ca:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f01068cf:	3c 2d                	cmp    $0x2d,%al
f01068d1:	75 07                	jne    f01068da <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
f01068d3:	83 c2 01             	add    $0x1,%edx
f01068d6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01068da:	85 db                	test   %ebx,%ebx
f01068dc:	0f 94 c0             	sete   %al
f01068df:	74 05                	je     f01068e6 <_Z6strtolPKcPPci+0x4f>
f01068e1:	83 fb 10             	cmp    $0x10,%ebx
f01068e4:	75 15                	jne    f01068fb <_Z6strtolPKcPPci+0x64>
f01068e6:	80 3a 30             	cmpb   $0x30,(%edx)
f01068e9:	75 10                	jne    f01068fb <_Z6strtolPKcPPci+0x64>
f01068eb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01068ef:	75 0a                	jne    f01068fb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
f01068f1:	83 c2 02             	add    $0x2,%edx
f01068f4:	bb 10 00 00 00       	mov    $0x10,%ebx
f01068f9:	eb 13                	jmp    f010690e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
f01068fb:	84 c0                	test   %al,%al
f01068fd:	74 0f                	je     f010690e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01068ff:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0106904:	80 3a 30             	cmpb   $0x30,(%edx)
f0106907:	75 05                	jne    f010690e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
f0106909:	83 c2 01             	add    $0x1,%edx
f010690c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
f010690e:	b8 00 00 00 00       	mov    $0x0,%eax
f0106913:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0106915:	0f b6 0a             	movzbl (%edx),%ecx
f0106918:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f010691b:	80 fb 09             	cmp    $0x9,%bl
f010691e:	77 08                	ja     f0106928 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
f0106920:	0f be c9             	movsbl %cl,%ecx
f0106923:	83 e9 30             	sub    $0x30,%ecx
f0106926:	eb 1e                	jmp    f0106946 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
f0106928:	8d 59 9f             	lea    -0x61(%ecx),%ebx
f010692b:	80 fb 19             	cmp    $0x19,%bl
f010692e:	77 08                	ja     f0106938 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
f0106930:	0f be c9             	movsbl %cl,%ecx
f0106933:	83 e9 57             	sub    $0x57,%ecx
f0106936:	eb 0e                	jmp    f0106946 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
f0106938:	8d 59 bf             	lea    -0x41(%ecx),%ebx
f010693b:	80 fb 19             	cmp    $0x19,%bl
f010693e:	77 15                	ja     f0106955 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
f0106940:	0f be c9             	movsbl %cl,%ecx
f0106943:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0106946:	39 f1                	cmp    %esi,%ecx
f0106948:	7d 0f                	jge    f0106959 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
f010694a:	83 c2 01             	add    $0x1,%edx
f010694d:	0f af c6             	imul   %esi,%eax
f0106950:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
f0106953:	eb c0                	jmp    f0106915 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
f0106955:	89 c1                	mov    %eax,%ecx
f0106957:	eb 02                	jmp    f010695b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0106959:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
f010695b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f010695f:	74 05                	je     f0106966 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
f0106961:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106964:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f0106966:	89 ca                	mov    %ecx,%edx
f0106968:	f7 da                	neg    %edx
f010696a:	85 ff                	test   %edi,%edi
f010696c:	0f 45 c2             	cmovne %edx,%eax
}
f010696f:	5b                   	pop    %ebx
f0106970:	5e                   	pop    %esi
f0106971:	5f                   	pop    %edi
f0106972:	5d                   	pop    %ebp
f0106973:	c3                   	ret    

f0106974 <_ZL11e1000_writejj>:
extern struct Env envs[];


static void
e1000_write(uint32_t offset, uint32_t val)
{
f0106974:	55                   	push   %ebp
f0106975:	89 e5                	mov    %esp,%ebp
    *((uint32_t *)IOMEMBASE + (offset / sizeof(uint32_t))) = (uint32_t)val;
f0106977:	c1 e8 02             	shr    $0x2,%eax
f010697a:	89 14 85 00 00 c0 ff 	mov    %edx,-0x400000(,%eax,4)
}
f0106981:	5d                   	pop    %ebp
f0106982:	c3                   	ret    

f0106983 <_Z18e1000_trap_handlerv>:


//XXX have to handle this in trap.c???
void
e1000_trap_handler()
{
f0106983:	55                   	push   %ebp
f0106984:	89 e5                	mov    %esp,%ebp
f0106986:	83 ec 18             	sub    $0x18,%esp
    cprintf("inside interrupt\n");
f0106989:	c7 04 24 e4 94 10 f0 	movl   $0xf01094e4,(%esp)
f0106990:	e8 1d d7 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
    if(q_start != q_end)
f0106995:	a1 00 90 37 f0       	mov    0xf0379000,%eax
f010699a:	85 c0                	test   %eax,%eax
f010699c:	74 25                	je     f01069c3 <_Z18e1000_trap_handlerv+0x40>
    {
        envs[ENVX(recv_q[q_start])].env_status = ENV_RUNNABLE;
f010699e:	8b 14 85 20 90 37 f0 	mov    -0xfc86fe0(,%eax,4),%edx
f01069a5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f01069ab:	6b d2 78             	imul   $0x78,%edx,%edx
f01069ae:	c7 82 94 82 37 f0 01 	movl   $0x1,-0xfc87d6c(%edx)
f01069b5:	00 00 00 
        q_start = (q_start + 1) % ENVID_QLEN;
f01069b8:	83 c0 01             	add    $0x1,%eax
f01069bb:	83 e0 3f             	and    $0x3f,%eax
f01069be:	a3 00 90 37 f0       	mov    %eax,0xf0379000
    }
    
    // reset e1000 interrupt
    e1000_write(0xC0, 0);
f01069c3:	ba 00 00 00 00       	mov    $0x0,%edx
f01069c8:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01069cd:	e8 a2 ff ff ff       	call   f0106974 <_ZL11e1000_writejj>
}
f01069d2:	c9                   	leave  
f01069d3:	c3                   	ret    

f01069d4 <_Z12e1000_attachP8pci_func>:
    e1000_write(0x100, EN|SECRC); 
}

int
e1000_attach(struct pci_func *f)
{
f01069d4:	55                   	push   %ebp
f01069d5:	89 e5                	mov    %esp,%ebp
f01069d7:	57                   	push   %edi
f01069d8:	56                   	push   %esi
f01069d9:	83 ec 20             	sub    $0x20,%esp
f01069dc:	8b 75 08             	mov    0x8(%ebp),%esi
    pci_func_enable(f);
f01069df:	89 34 24             	mov    %esi,(%esp)
f01069e2:	e8 b6 09 00 00       	call   f010739d <_Z15pci_func_enableP8pci_func>
    e1000 = *f;
f01069e7:	bf 40 99 37 f0       	mov    $0xf0379940,%edi
f01069ec:	b9 12 00 00 00       	mov    $0x12,%ecx
f01069f1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    page_map_segment(kern_pgdir, IOMEMBASE, e1000.reg_size[0], e1000.reg_base[0], PTE_W|PTE_PCD|PTE_PWT|PTE_P);
f01069f3:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
f01069fa:	00 
f01069fb:	c7 44 24 10 1b 00 00 	movl   $0x1b,0x10(%esp)
f0106a02:	00 
f0106a03:	a1 54 99 37 f0       	mov    0xf0379954,%eax
f0106a08:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106a0c:	a1 6c 99 37 f0       	mov    0xf037996c,%eax
f0106a11:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106a15:	c7 44 24 04 00 00 c0 	movl   $0xffc00000,0x4(%esp)
f0106a1c:	ff 
f0106a1d:	a1 70 82 37 f0       	mov    0xf0378270,%eax
f0106a22:	89 04 24             	mov    %eax,(%esp)
f0106a25:	e8 cf ab ff ff       	call   f01015f9 <_Z16page_map_segmentPjjjjib>
    set_e1000_irqno(e1000.irq_line);
f0106a2a:	0f b6 05 84 99 37 f0 	movzbl 0xf0379984,%eax
f0106a31:	89 04 24             	mov    %eax,(%esp)
f0106a34:	e8 ed e0 ff ff       	call   f0104b26 <_Z15set_e1000_irqnoh>
    SETGATE(idt[IRQ_OFFSET + e1000.irq_line], 0, 0x8, e1000_trap_handler, 0);
f0106a39:	0f b6 05 84 99 37 f0 	movzbl 0xf0379984,%eax
f0106a40:	83 c0 20             	add    $0x20,%eax
f0106a43:	ba 83 69 10 f0       	mov    $0xf0106983,%edx
f0106a48:	66 89 14 c5 a0 82 37 	mov    %dx,-0xfc87d60(,%eax,8)
f0106a4f:	f0 
f0106a50:	66 c7 04 c5 a2 82 37 	movw   $0x8,-0xfc87d5e(,%eax,8)
f0106a57:	f0 08 00 
f0106a5a:	c6 04 c5 a4 82 37 f0 	movb   $0x0,-0xfc87d5c(,%eax,8)
f0106a61:	00 
f0106a62:	c6 04 c5 a5 82 37 f0 	movb   $0x8e,-0xfc87d5b(,%eax,8)
f0106a69:	8e 
f0106a6a:	c1 ea 10             	shr    $0x10,%edx
f0106a6d:	66 89 14 c5 a6 82 37 	mov    %dx,-0xfc87d5a(,%eax,8)
f0106a74:	f0 
static void
e1000_init_tring(void)
{
    for(int i = 0; i < NUM_TDESCS; i++)
    {
        tdesc_list[i].addr = (uint64_t)PADDR(&tpackets[i].p);
f0106a75:	b9 00 a0 37 f0       	mov    $0xf037a000,%ecx
f0106a7a:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0106a80:	0f 87 71 02 00 00    	ja     f0106cf7 <_Z12e1000_attachP8pci_func+0x323>
f0106a86:	eb 13                	jmp    f0106a9b <_Z12e1000_attachP8pci_func+0xc7>
f0106a88:	89 d1                	mov    %edx,%ecx
f0106a8a:	c1 e1 0b             	shl    $0xb,%ecx
f0106a8d:	81 c1 00 a0 37 f0    	add    $0xf037a000,%ecx
f0106a93:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0106a99:	77 20                	ja     f0106abb <_Z12e1000_attachP8pci_func+0xe7>
f0106a9b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0106a9f:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0106aa6:	f0 
f0106aa7:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
f0106aae:	00 
f0106aaf:	c7 04 24 f6 94 10 f0 	movl   $0xf01094f6,(%esp)
f0106ab6:	e8 6d 97 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0106abb:	81 c1 00 00 00 10    	add    $0x10000000,%ecx
f0106ac1:	89 08                	mov    %ecx,(%eax)
f0106ac3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        tdesc_list[i].length = 0;
f0106aca:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
        tdesc_list[i].cso = 0;
f0106ad0:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
        tdesc_list[i].cmd = RS;
f0106ad4:	c6 40 0b 08          	movb   $0x8,0xb(%eax)
        tdesc_list[i].status = DD;
f0106ad8:	c6 40 0c 01          	movb   $0x1,0xc(%eax)
        tdesc_list[i].css = 0;
f0106adc:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
        tdesc_list[i].special = 0;
f0106ae0:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
}

static void
e1000_init_tring(void)
{
    for(int i = 0; i < NUM_TDESCS; i++)
f0106ae6:	83 c2 01             	add    $0x1,%edx
f0106ae9:	83 c0 10             	add    $0x10,%eax
f0106aec:	83 fa 40             	cmp    $0x40,%edx
f0106aef:	75 97                	jne    f0106a88 <_Z12e1000_attachP8pci_func+0xb4>
static void
e1000_tinit(void)
{
    e1000_init_tring();
    // TDBAL
    e1000_write(0x3800, (uint32_t)PADDR(tdesc_list));// (uint32_t)tdesc_list);
f0106af1:	b8 40 95 37 f0       	mov    $0xf0379540,%eax
f0106af6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0106afb:	77 20                	ja     f0106b1d <_Z12e1000_attachP8pci_func+0x149>
f0106afd:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106b01:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0106b08:	f0 
f0106b09:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
f0106b10:	00 
f0106b11:	c7 04 24 f6 94 10 f0 	movl   $0xf01094f6,(%esp)
f0106b18:	e8 0b 97 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0106b1d:	ba 40 95 37 00       	mov    $0x379540,%edx
f0106b22:	b8 00 38 00 00       	mov    $0x3800,%eax
f0106b27:	e8 48 fe ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // TDBAH
    e1000_write(0x3804, 0);
f0106b2c:	ba 00 00 00 00       	mov    $0x0,%edx
f0106b31:	b8 04 38 00 00       	mov    $0x3804,%eax
f0106b36:	e8 39 fe ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // TDLEN
    e1000_write(0x3808, sizeof tdesc_list);
f0106b3b:	ba 00 04 00 00       	mov    $0x400,%edx
f0106b40:	b8 08 38 00 00       	mov    $0x3808,%eax
f0106b45:	e8 2a fe ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // TDH
    e1000_write(0x3810, 0);
f0106b4a:	ba 00 00 00 00       	mov    $0x0,%edx
f0106b4f:	b8 10 38 00 00       	mov    $0x3810,%eax
f0106b54:	e8 1b fe ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // TDT
    e1000_write(0x3818, 0);
f0106b59:	ba 00 00 00 00       	mov    $0x0,%edx
f0106b5e:	b8 18 38 00 00       	mov    $0x3818,%eax
f0106b63:	e8 0c fe ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // TCTL
    e1000_write(0x400, 0x2|0x8|(0x40<<12));
f0106b68:	ba 0a 00 04 00       	mov    $0x4000a,%edx
f0106b6d:	b8 00 04 00 00       	mov    $0x400,%eax
f0106b72:	e8 fd fd ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // TIPG
    e1000_write(0x410, 0x60200A);
f0106b77:	ba 0a 20 60 00       	mov    $0x60200a,%edx
f0106b7c:	b8 10 04 00 00       	mov    $0x410,%eax
f0106b81:	e8 ee fd ff ff       	call   f0106974 <_ZL11e1000_writejj>
f0106b86:	b8 00 00 00 00       	mov    $0x0,%eax
}

static void
e1000_init_rring(void)
{
    for(int i = 0; i < NUM_RDESCS; i++)
f0106b8b:	ba 00 00 00 00       	mov    $0x0,%edx
    {
        rdesc_list[i].addr = (uint64_t)PADDR(&rbuffer[i]);
f0106b90:	89 d1                	mov    %edx,%ecx
f0106b92:	c1 e1 0b             	shl    $0xb,%ecx
f0106b95:	81 c1 00 a0 39 f0    	add    $0xf039a000,%ecx
f0106b9b:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0106ba1:	77 20                	ja     f0106bc3 <_Z12e1000_attachP8pci_func+0x1ef>
f0106ba3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0106ba7:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0106bae:	f0 
f0106baf:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
f0106bb6:	00 
f0106bb7:	c7 04 24 f6 94 10 f0 	movl   $0xf01094f6,(%esp)
f0106bbe:	e8 65 96 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0106bc3:	81 c1 00 00 00 10    	add    $0x10000000,%ecx
f0106bc9:	89 88 30 91 37 f0    	mov    %ecx,-0xfc86ed0(%eax)
f0106bcf:	c7 80 34 91 37 f0 00 	movl   $0x0,-0xfc86ecc(%eax)
f0106bd6:	00 00 00 
        rdesc_list[i].length = 0;
f0106bd9:	66 c7 80 38 91 37 f0 	movw   $0x0,-0xfc86ec8(%eax)
f0106be0:	00 00 
        rdesc_list[i].pcs = 0;
f0106be2:	66 c7 80 3a 91 37 f0 	movw   $0x0,-0xfc86ec6(%eax)
f0106be9:	00 00 
        rdesc_list[i].status = 0;
f0106beb:	c6 80 3c 91 37 f0 00 	movb   $0x0,-0xfc86ec4(%eax)
        rdesc_list[i].errors = 0;
f0106bf2:	c6 80 3d 91 37 f0 00 	movb   $0x0,-0xfc86ec3(%eax)
        rdesc_list[i].special = 0;
f0106bf9:	66 c7 80 3e 91 37 f0 	movw   $0x0,-0xfc86ec2(%eax)
f0106c00:	00 00 
}

static void
e1000_init_rring(void)
{
    for(int i = 0; i < NUM_RDESCS; i++)
f0106c02:	83 c2 01             	add    $0x1,%edx
f0106c05:	83 c0 10             	add    $0x10,%eax
f0106c08:	83 fa 40             	cmp    $0x40,%edx
f0106c0b:	75 83                	jne    f0106b90 <_Z12e1000_attachP8pci_func+0x1bc>
static void
e1000_rinit(void)
{
    e1000_init_rring();
    // RAL
    e1000_write(0x5400, 0x12005452);
f0106c0d:	ba 52 54 00 12       	mov    $0x12005452,%edx
f0106c12:	b8 00 54 00 00       	mov    $0x5400,%eax
f0106c17:	e8 58 fd ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // RAH
    e1000_write(0x5404, (MACHINE?0x5734:0x5634) + (1<<31));
f0106c1c:	ba 34 57 00 80       	mov    $0x80005734,%edx
f0106c21:	b8 04 54 00 00       	mov    $0x5404,%eax
f0106c26:	e8 49 fd ff ff       	call   f0106974 <_ZL11e1000_writejj>
f0106c2b:	be 00 52 00 00       	mov    $0x5200,%esi
    // MTA
    for(uint32_t i = 0; i < 128; i++)
        e1000_write(0x5200 + 4 * i, 0);
f0106c30:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c35:	89 f0                	mov    %esi,%eax
f0106c37:	e8 38 fd ff ff       	call   f0106974 <_ZL11e1000_writejj>
f0106c3c:	83 c6 04             	add    $0x4,%esi
    // RAL
    e1000_write(0x5400, 0x12005452);
    // RAH
    e1000_write(0x5404, (MACHINE?0x5734:0x5634) + (1<<31));
    // MTA
    for(uint32_t i = 0; i < 128; i++)
f0106c3f:	81 fe 00 54 00 00    	cmp    $0x5400,%esi
f0106c45:	75 e9                	jne    f0106c30 <_Z12e1000_attachP8pci_func+0x25c>
        e1000_write(0x5200 + 4 * i, 0);
    // IMS
    e1000_write(0xD0, RXT0);
f0106c47:	ba 80 00 00 00       	mov    $0x80,%edx
f0106c4c:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106c51:	e8 1e fd ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // RDBAL
    e1000_write(0x2800, (uint32_t)PADDR(rdesc_list));
f0106c56:	b8 30 91 37 f0       	mov    $0xf0379130,%eax
f0106c5b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0106c60:	77 20                	ja     f0106c82 <_Z12e1000_attachP8pci_func+0x2ae>
f0106c62:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106c66:	c7 44 24 08 60 81 10 	movl   $0xf0108160,0x8(%esp)
f0106c6d:	f0 
f0106c6e:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
f0106c75:	00 
f0106c76:	c7 04 24 f6 94 10 f0 	movl   $0xf01094f6,(%esp)
f0106c7d:	e8 a6 95 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0106c82:	ba 30 91 37 00       	mov    $0x379130,%edx
f0106c87:	b8 00 28 00 00       	mov    $0x2800,%eax
f0106c8c:	e8 e3 fc ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // RDBAH
    e1000_write(0x2804, 0);
f0106c91:	ba 00 00 00 00       	mov    $0x0,%edx
f0106c96:	b8 04 28 00 00       	mov    $0x2804,%eax
f0106c9b:	e8 d4 fc ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // RDLEN
    e1000_write(0x2808, sizeof rdesc_list);
f0106ca0:	ba 00 04 00 00       	mov    $0x400,%edx
f0106ca5:	b8 08 28 00 00       	mov    $0x2808,%eax
f0106caa:	e8 c5 fc ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // RDH
    e1000_write(0x2810, 0);
f0106caf:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cb4:	b8 10 28 00 00       	mov    $0x2810,%eax
f0106cb9:	e8 b6 fc ff ff       	call   f0106974 <_ZL11e1000_writejj>
   // RDT
    e1000_write(0x2818, 0);
f0106cbe:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cc3:	b8 18 28 00 00       	mov    $0x2818,%eax
f0106cc8:	e8 a7 fc ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // Set RDTR Delay Time to 0 (just to make sure)
    e1000_write(0x2820, 0x0);
f0106ccd:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cd2:	b8 20 28 00 00       	mov    $0x2820,%eax
f0106cd7:	e8 98 fc ff ff       	call   f0106974 <_ZL11e1000_writejj>
    // RCTL
    e1000_write(0x100, EN|SECRC); 
f0106cdc:	ba 02 00 00 04       	mov    $0x4000002,%edx
f0106ce1:	b8 00 01 00 00       	mov    $0x100,%eax
f0106ce6:	e8 89 fc ff ff       	call   f0106974 <_ZL11e1000_writejj>
    set_e1000_irqno(e1000.irq_line);
    SETGATE(idt[IRQ_OFFSET + e1000.irq_line], 0, 0x8, e1000_trap_handler, 0);
    e1000_tinit();
    e1000_rinit();
    return 1;
}
f0106ceb:	b8 01 00 00 00       	mov    $0x1,%eax
f0106cf0:	83 c4 20             	add    $0x20,%esp
f0106cf3:	5e                   	pop    %esi
f0106cf4:	5f                   	pop    %edi
f0106cf5:	5d                   	pop    %ebp
f0106cf6:	c3                   	ret    
static void
e1000_init_tring(void)
{
    for(int i = 0; i < NUM_TDESCS; i++)
    {
        tdesc_list[i].addr = (uint64_t)PADDR(&tpackets[i].p);
f0106cf7:	c7 05 40 95 37 f0 00 	movl   $0x37a000,0xf0379540
f0106cfe:	a0 37 00 
f0106d01:	c7 05 44 95 37 f0 00 	movl   $0x0,0xf0379544
f0106d08:	00 00 00 
        tdesc_list[i].length = 0;
f0106d0b:	66 c7 05 48 95 37 f0 	movw   $0x0,0xf0379548
f0106d12:	00 00 
        tdesc_list[i].cso = 0;
f0106d14:	c6 05 4a 95 37 f0 00 	movb   $0x0,0xf037954a
        tdesc_list[i].cmd = RS;
f0106d1b:	c6 05 4b 95 37 f0 08 	movb   $0x8,0xf037954b
        tdesc_list[i].status = DD;
f0106d22:	c6 05 4c 95 37 f0 01 	movb   $0x1,0xf037954c
        tdesc_list[i].css = 0;
f0106d29:	c6 05 4d 95 37 f0 00 	movb   $0x0,0xf037954d
        tdesc_list[i].special = 0;
f0106d30:	66 c7 05 4e 95 37 f0 	movw   $0x0,0xf037954e
f0106d37:	00 00 
f0106d39:	b8 50 95 37 f0       	mov    $0xf0379550,%eax
}

static void
e1000_init_tring(void)
{
    for(int i = 0; i < NUM_TDESCS; i++)
f0106d3e:	ba 01 00 00 00       	mov    $0x1,%edx
f0106d43:	e9 40 fd ff ff       	jmp    f0106a88 <_Z12e1000_attachP8pci_func+0xb4>

f0106d48 <_Z14e1000_transmitPvj>:
    return 1;
}

int
e1000_transmit(void *buffer, size_t len)
{
f0106d48:	55                   	push   %ebp
f0106d49:	89 e5                	mov    %esp,%ebp
f0106d4b:	53                   	push   %ebx
f0106d4c:	83 ec 14             	sub    $0x14,%esp
f0106d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
    if (len > MAXPACKETLEN)
        return -E_INVAL;
f0106d52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}

int
e1000_transmit(void *buffer, size_t len)
{
    if (len > MAXPACKETLEN)
f0106d57:	81 fa 00 08 00 00    	cmp    $0x800,%edx
f0106d5d:	0f 87 b4 00 00 00    	ja     f0106e17 <_Z14e1000_transmitPvj+0xcf>
        return -E_INVAL;
    if(!(tdesc_list[td_idx].status & DD))
f0106d63:	a1 30 95 37 f0       	mov    0xf0379530,%eax
f0106d68:	89 c1                	mov    %eax,%ecx
f0106d6a:	c1 e1 04             	shl    $0x4,%ecx
f0106d6d:	0f b6 89 4c 95 37 f0 	movzbl -0xfc86ab4(%ecx),%ecx
f0106d74:	f6 c1 01             	test   $0x1,%cl
f0106d77:	0f 84 95 00 00 00    	je     f0106e12 <_Z14e1000_transmitPvj+0xca>
        return -E_AGAIN;
    tdesc_list[td_idx].status &= ~DD;
f0106d7d:	89 c3                	mov    %eax,%ebx
f0106d7f:	c1 e3 04             	shl    $0x4,%ebx
f0106d82:	8d 83 40 95 37 f0    	lea    -0xfc86ac0(%ebx),%eax
f0106d88:	83 e1 fe             	and    $0xfffffffe,%ecx
f0106d8b:	88 8b 4c 95 37 f0    	mov    %cl,-0xfc86ab4(%ebx)
    tdesc_list[td_idx].length = len;
f0106d91:	66 89 93 48 95 37 f0 	mov    %dx,-0xfc86ab8(%ebx)
    // EOP
    tdesc_list[td_idx].cmd |= 1;
f0106d98:	80 48 0b 01          	orb    $0x1,0xb(%eax)
    memcpy((void *)KADDR(tdesc_list[td_idx].addr), buffer, len);
f0106d9c:	8b 83 40 95 37 f0    	mov    -0xfc86ac0(%ebx),%eax
f0106da2:	89 c1                	mov    %eax,%ecx
f0106da4:	c1 e9 0c             	shr    $0xc,%ecx
f0106da7:	3b 0d 6c 82 37 f0    	cmp    0xf037826c,%ecx
f0106dad:	72 20                	jb     f0106dcf <_Z14e1000_transmitPvj+0x87>
f0106daf:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106db3:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0106dba:	f0 
f0106dbb:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
f0106dc2:	00 
f0106dc3:	c7 04 24 f6 94 10 f0 	movl   $0xf01094f6,(%esp)
f0106dca:	e8 59 94 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0106dcf:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106dd3:	8b 55 08             	mov    0x8(%ebp),%edx
f0106dd6:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106dda:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0106ddf:	89 04 24             	mov    %eax,(%esp)
f0106de2:	e8 f0 f9 ff ff       	call   f01067d7 <memcpy>
    if(++td_idx == NUM_TDESCS)
f0106de7:	a1 30 95 37 f0       	mov    0xf0379530,%eax
f0106dec:	83 c0 01             	add    $0x1,%eax
        td_idx = 0;
f0106def:	83 f8 40             	cmp    $0x40,%eax
f0106df2:	ba 00 00 00 00       	mov    $0x0,%edx
f0106df7:	0f 44 c2             	cmove  %edx,%eax
f0106dfa:	89 c2                	mov    %eax,%edx
f0106dfc:	a3 30 95 37 f0       	mov    %eax,0xf0379530
    e1000_write(0x3818, td_idx);
f0106e01:	b8 18 38 00 00       	mov    $0x3818,%eax
f0106e06:	e8 69 fb ff ff       	call   f0106974 <_ZL11e1000_writejj>
    return 0;
f0106e0b:	b8 00 00 00 00       	mov    $0x0,%eax
f0106e10:	eb 05                	jmp    f0106e17 <_Z14e1000_transmitPvj+0xcf>
e1000_transmit(void *buffer, size_t len)
{
    if (len > MAXPACKETLEN)
        return -E_INVAL;
    if(!(tdesc_list[td_idx].status & DD))
        return -E_AGAIN;
f0106e12:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
    memcpy((void *)KADDR(tdesc_list[td_idx].addr), buffer, len);
    if(++td_idx == NUM_TDESCS)
        td_idx = 0;
    e1000_write(0x3818, td_idx);
    return 0;
}
f0106e17:	83 c4 14             	add    $0x14,%esp
f0106e1a:	5b                   	pop    %ebx
f0106e1b:	5d                   	pop    %ebp
f0106e1c:	c3                   	ret    

f0106e1d <_Z13e1000_receivePv>:
static unsigned int q_start = 0;
static unsigned int q_end = 0;

int
e1000_receive(void *dst)
{
f0106e1d:	55                   	push   %ebp
f0106e1e:	89 e5                	mov    %esp,%ebp
f0106e20:	83 ec 28             	sub    $0x28,%esp
f0106e23:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0106e26:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0106e29:	89 7d fc             	mov    %edi,-0x4(%ebp)
    struct rx_desc *cur;
    size_t len;
    cur = &rdesc_list[rd_idx];
f0106e2c:	8b 1d 20 91 37 f0    	mov    0xf0379120,%ebx
    if(!(cur->status & DD))
f0106e32:	89 da                	mov    %ebx,%edx
f0106e34:	c1 e2 04             	shl    $0x4,%edx
    {
        if(1 || (q_end + 1) % ENVID_QLEN == q_start)
            return -1;
f0106e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
e1000_receive(void *dst)
{
    struct rx_desc *cur;
    size_t len;
    cur = &rdesc_list[rd_idx];
    if(!(cur->status & DD))
f0106e3c:	f6 82 3c 91 37 f0 01 	testb  $0x1,-0xfc86ec4(%edx)
f0106e43:	0f 84 a4 00 00 00    	je     f0106eed <_Z13e1000_receivePv+0xd0>
        curenv->env_status = ENV_NOT_RUNNABLE;
        sched_yield();
    } 
    else
    {
        len = cur->length;
f0106e49:	89 d7                	mov    %edx,%edi
f0106e4b:	0f b7 b2 38 91 37 f0 	movzwl -0xfc86ec8(%edx),%esi
        user_mem_assert(curenv, (uintptr_t)dst, len, PTE_P|PTE_U|PTE_W);
f0106e52:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0106e59:	00 
f0106e5a:	89 74 24 08          	mov    %esi,0x8(%esp)
f0106e5e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106e61:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106e65:	a1 8c 82 37 f0       	mov    0xf037828c,%eax
f0106e6a:	89 04 24             	mov    %eax,(%esp)
f0106e6d:	e8 19 c8 ff ff       	call   f010368b <_Z15user_mem_assertP3Envjjj>
        memcpy(dst, (void *)KADDR(cur->addr), len);
f0106e72:	8b 87 30 91 37 f0    	mov    -0xfc86ed0(%edi),%eax
f0106e78:	89 c2                	mov    %eax,%edx
f0106e7a:	c1 ea 0c             	shr    $0xc,%edx
f0106e7d:	3b 15 6c 82 37 f0    	cmp    0xf037826c,%edx
f0106e83:	72 20                	jb     f0106ea5 <_Z13e1000_receivePv+0x88>
f0106e85:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106e89:	c7 44 24 08 3c 81 10 	movl   $0xf010813c,0x8(%esp)
f0106e90:	f0 
f0106e91:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
f0106e98:	00 
f0106e99:	c7 04 24 f6 94 10 f0 	movl   $0xf01094f6,(%esp)
f0106ea0:	e8 83 93 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
f0106ea5:	89 74 24 08          	mov    %esi,0x8(%esp)
f0106ea9:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0106eae:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106eb2:	8b 45 08             	mov    0x8(%ebp),%eax
f0106eb5:	89 04 24             	mov    %eax,(%esp)
f0106eb8:	e8 1a f9 ff ff       	call   f01067d7 <memcpy>
        cur->status = 0;
f0106ebd:	c1 e3 04             	shl    $0x4,%ebx
f0106ec0:	c6 83 3c 91 37 f0 00 	movb   $0x0,-0xfc86ec4(%ebx)
        if(++rd_idx == NUM_RDESCS)
f0106ec7:	a1 20 91 37 f0       	mov    0xf0379120,%eax
f0106ecc:	83 c0 01             	add    $0x1,%eax
            rd_idx = 0;
f0106ecf:	83 f8 40             	cmp    $0x40,%eax
f0106ed2:	ba 00 00 00 00       	mov    $0x0,%edx
f0106ed7:	0f 44 c2             	cmove  %edx,%eax
f0106eda:	89 c2                	mov    %eax,%edx
f0106edc:	a3 20 91 37 f0       	mov    %eax,0xf0379120
        // RDT
        e1000_write(0x2818, rd_idx);
f0106ee1:	b8 18 28 00 00       	mov    $0x2818,%eax
f0106ee6:	e8 89 fa ff ff       	call   f0106974 <_ZL11e1000_writejj>
        return len;
f0106eeb:	89 f0                	mov    %esi,%eax
    }
    // shouldn't reach
    return 0;
}
f0106eed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0106ef0:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0106ef3:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0106ef6:	89 ec                	mov    %ebp,%esp
f0106ef8:	5d                   	pop    %ebp
f0106ef9:	c3                   	ret    
	...

f0106efc <_ZL16pci_attach_matchjjP10pci_driverP8pci_func>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0106efc:	55                   	push   %ebp
f0106efd:	89 e5                	mov    %esp,%ebp
f0106eff:	57                   	push   %edi
f0106f00:	56                   	push   %esi
f0106f01:	53                   	push   %ebx
f0106f02:	83 ec 3c             	sub    $0x3c,%esp
f0106f05:	89 c7                	mov    %eax,%edi
f0106f07:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0106f0a:	89 ce                	mov    %ecx,%esi
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0106f0c:	8b 51 08             	mov    0x8(%ecx),%edx
				cprintf("pci_attach_match: attaching "
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
f0106f0f:	b8 00 00 00 00       	mov    $0x0,%eax
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0106f14:	85 d2                	test   %edx,%edx
f0106f16:	74 52                	je     f0106f6a <_ZL16pci_attach_matchjjP10pci_driverP8pci_func+0x6e>
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
	outl(pci_conf1_data_ioport, v);
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
f0106f18:	8d 59 0c             	lea    0xc(%ecx),%ebx
		 struct pci_driver *list, struct pci_func *pcif)
{
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0106f1b:	39 3e                	cmp    %edi,(%esi)
f0106f1d:	75 3a                	jne    f0106f59 <_ZL16pci_attach_matchjjP10pci_driverP8pci_func+0x5d>
f0106f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106f22:	39 46 04             	cmp    %eax,0x4(%esi)
f0106f25:	75 32                	jne    f0106f59 <_ZL16pci_attach_matchjjP10pci_driverP8pci_func+0x5d>
			int r = list[i].attachfn(pcif);
f0106f27:	8b 45 08             	mov    0x8(%ebp),%eax
f0106f2a:	89 04 24             	mov    %eax,(%esp)
f0106f2d:	ff d2                	call   *%edx
			if (r > 0)
f0106f2f:	85 c0                	test   %eax,%eax
f0106f31:	7f 37                	jg     f0106f6a <_ZL16pci_attach_matchjjP10pci_driverP8pci_func+0x6e>
				return r;
			if (r < 0)
f0106f33:	85 c0                	test   %eax,%eax
f0106f35:	79 22                	jns    f0106f59 <_ZL16pci_attach_matchjjP10pci_driverP8pci_func+0x5d>
				cprintf("pci_attach_match: attaching "
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
f0106f37:	89 44 24 10          	mov    %eax,0x10(%esp)
f0106f3b:	8b 46 08             	mov    0x8(%esi),%eax
f0106f3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106f42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106f45:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106f49:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106f4d:	c7 04 24 04 95 10 f0 	movl   $0xf0109504,(%esp)
f0106f54:	e8 59 d1 ff ff       	call   f01040b2 <_Z7cprintfPKcz>
f0106f59:	89 de                	mov    %ebx,%esi
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0106f5b:	8b 53 08             	mov    0x8(%ebx),%edx
f0106f5e:	83 c3 0c             	add    $0xc,%ebx
f0106f61:	85 d2                	test   %edx,%edx
f0106f63:	75 b6                	jne    f0106f1b <_ZL16pci_attach_matchjjP10pci_driverP8pci_func+0x1f>
				cprintf("pci_attach_match: attaching "
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
f0106f65:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106f6a:	83 c4 3c             	add    $0x3c,%esp
f0106f6d:	5b                   	pop    %ebx
f0106f6e:	5e                   	pop    %esi
f0106f6f:	5f                   	pop    %edi
f0106f70:	5d                   	pop    %ebp
f0106f71:	c3                   	ret    

f0106f72 <_ZL18pci_conf1_set_addrjjjj>:
static void
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f0106f72:	55                   	push   %ebp
f0106f73:	89 e5                	mov    %esp,%ebp
f0106f75:	53                   	push   %ebx
f0106f76:	83 ec 14             	sub    $0x14,%esp
f0106f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0106f7c:	3d ff 00 00 00       	cmp    $0xff,%eax
f0106f81:	76 24                	jbe    f0106fa7 <_ZL18pci_conf1_set_addrjjjj+0x35>
f0106f83:	c7 44 24 0c 5c 96 10 	movl   $0xf010965c,0xc(%esp)
f0106f8a:	f0 
f0106f8b:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0106f92:	f0 
f0106f93:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
f0106f9a:	00 
f0106f9b:	c7 04 24 66 96 10 f0 	movl   $0xf0109666,(%esp)
f0106fa2:	e8 81 92 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(dev < 32);
f0106fa7:	83 fa 1f             	cmp    $0x1f,%edx
f0106faa:	76 24                	jbe    f0106fd0 <_ZL18pci_conf1_set_addrjjjj+0x5e>
f0106fac:	c7 44 24 0c 71 96 10 	movl   $0xf0109671,0xc(%esp)
f0106fb3:	f0 
f0106fb4:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0106fbb:	f0 
f0106fbc:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
f0106fc3:	00 
f0106fc4:	c7 04 24 66 96 10 f0 	movl   $0xf0109666,(%esp)
f0106fcb:	e8 58 92 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(func < 8);
f0106fd0:	83 f9 07             	cmp    $0x7,%ecx
f0106fd3:	76 24                	jbe    f0106ff9 <_ZL18pci_conf1_set_addrjjjj+0x87>
f0106fd5:	c7 44 24 0c 7a 96 10 	movl   $0xf010967a,0xc(%esp)
f0106fdc:	f0 
f0106fdd:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0106fe4:	f0 
f0106fe5:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
f0106fec:	00 
f0106fed:	c7 04 24 66 96 10 f0 	movl   $0xf0109666,(%esp)
f0106ff4:	e8 2f 92 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert(offset < 256);
f0106ff9:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0106fff:	76 24                	jbe    f0107025 <_ZL18pci_conf1_set_addrjjjj+0xb3>
f0107001:	c7 44 24 0c 83 96 10 	movl   $0xf0109683,0xc(%esp)
f0107008:	f0 
f0107009:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0107010:	f0 
f0107011:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
f0107018:	00 
f0107019:	c7 04 24 66 96 10 f0 	movl   $0xf0109666,(%esp)
f0107020:	e8 03 92 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
	assert((offset & 0x3) == 0);
f0107025:	f6 c3 03             	test   $0x3,%bl
f0107028:	74 24                	je     f010704e <_ZL18pci_conf1_set_addrjjjj+0xdc>
f010702a:	c7 44 24 0c 90 96 10 	movl   $0xf0109690,0xc(%esp)
f0107031:	f0 
f0107032:	c7 44 24 08 d1 88 10 	movl   $0xf01088d1,0x8(%esp)
f0107039:	f0 
f010703a:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
f0107041:	00 
f0107042:	c7 04 24 66 96 10 f0 	movl   $0xf0109666,(%esp)
f0107049:	e8 da 91 ff ff       	call   f0100228 <_Z6_panicPKciS0_z>

	uint32_t v = (1 << 31) |		// config-space
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f010704e:	c1 e0 10             	shl    $0x10,%eax
f0107051:	0d 00 00 00 80       	or     $0x80000000,%eax
f0107056:	c1 e2 0b             	shl    $0xb,%edx
f0107059:	09 d0                	or     %edx,%eax
f010705b:	09 d8                	or     %ebx,%eax
f010705d:	c1 e1 08             	shl    $0x8,%ecx
f0107060:	09 c8                	or     %ecx,%eax
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107062:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0107067:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_addr_ioport, v);
}
f0107068:	83 c4 14             	add    $0x14,%esp
f010706b:	5b                   	pop    %ebx
f010706c:	5d                   	pop    %ebp
f010706d:	c3                   	ret    

f010706e <_ZL13pci_conf_readP8pci_funcj>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f010706e:	55                   	push   %ebp
f010706f:	89 e5                	mov    %esp,%ebp
f0107071:	53                   	push   %ebx
f0107072:	83 ec 14             	sub    $0x14,%esp
f0107075:	89 d3                	mov    %edx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107077:	8b 48 08             	mov    0x8(%eax),%ecx
f010707a:	8b 50 04             	mov    0x4(%eax),%edx
f010707d:	8b 00                	mov    (%eax),%eax
f010707f:	8b 40 04             	mov    0x4(%eax),%eax
f0107082:	89 1c 24             	mov    %ebx,(%esp)
f0107085:	e8 e8 fe ff ff       	call   f0106f72 <_ZL18pci_conf1_set_addrjjjj>

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f010708a:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f010708f:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f0107090:	83 c4 14             	add    $0x14,%esp
f0107093:	5b                   	pop    %ebx
f0107094:	5d                   	pop    %ebp
f0107095:	c3                   	ret    

f0107096 <_ZL12pci_scan_busP7pci_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0107096:	55                   	push   %ebp
f0107097:	89 e5                	mov    %esp,%ebp
f0107099:	57                   	push   %edi
f010709a:	56                   	push   %esi
f010709b:	53                   	push   %ebx
f010709c:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
f01070a2:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f01070a4:	c7 44 24 08 48 00 00 	movl   $0x48,0x8(%esp)
f01070ab:	00 
f01070ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01070b3:	00 
f01070b4:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01070b7:	89 04 24             	mov    %eax,(%esp)
f01070ba:	e8 42 f6 ff ff       	call   f0106701 <memset>
	df.bus = bus;
f01070bf:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f01070c2:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
}

static int
pci_scan_bus(struct pci_bus *bus)
{
	int totaldev = 0;
f01070c9:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%ebp)
f01070d0:	00 00 00 
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f01070d3:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01070d6:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
			continue;

		totaldev++;

		struct pci_func f = df;
f01070dc:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
f01070e2:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f01070e8:	ba 0c 00 00 00       	mov    $0xc,%edx
f01070ed:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01070f0:	e8 79 ff ff ff       	call   f010706e <_ZL13pci_conf_readP8pci_funcj>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f01070f5:	89 c2                	mov    %eax,%edx
f01070f7:	c1 ea 10             	shr    $0x10,%edx
f01070fa:	83 e2 7f             	and    $0x7f,%edx
f01070fd:	83 fa 01             	cmp    $0x1,%edx
f0107100:	0f 87 6c 01 00 00    	ja     f0107272 <_ZL12pci_scan_busP7pci_bus+0x1dc>
			continue;

		totaldev++;
f0107106:	83 85 f8 fe ff ff 01 	addl   $0x1,-0x108(%ebp)

		struct pci_func f = df;
f010710d:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107112:	8b bd 00 ff ff ff    	mov    -0x100(%ebp),%edi
f0107118:	8b b5 04 ff ff ff    	mov    -0xfc(%ebp),%esi
f010711e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107120:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
f0107127:	00 00 00 
f010712a:	25 00 00 80 00       	and    $0x800000,%eax
f010712f:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
		     f.func++) {
			struct pci_func af = f;
f0107135:	8d 9d 10 ff ff ff    	lea    -0xf0(%ebp),%ebx
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f010713b:	e9 17 01 00 00       	jmp    f0107257 <_ZL12pci_scan_busP7pci_bus+0x1c1>
		     f.func++) {
			struct pci_func af = f;
f0107140:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107145:	89 df                	mov    %ebx,%edi
f0107147:	8b b5 00 ff ff ff    	mov    -0x100(%ebp),%esi
f010714d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f010714f:	ba 00 00 00 00       	mov    $0x0,%edx
f0107154:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
f010715a:	e8 0f ff ff ff       	call   f010706e <_ZL13pci_conf_readP8pci_funcj>
f010715f:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0107165:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f0107169:	0f 84 e1 00 00 00    	je     f0107250 <_ZL12pci_scan_busP7pci_bus+0x1ba>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f010716f:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0107174:	89 d8                	mov    %ebx,%eax
f0107176:	e8 f3 fe ff ff       	call   f010706e <_ZL13pci_conf_readP8pci_funcj>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f010717b:	88 85 54 ff ff ff    	mov    %al,-0xac(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107181:	ba 08 00 00 00       	mov    $0x8,%edx
f0107186:	89 d8                	mov    %ebx,%eax
f0107188:	e8 e1 fe ff ff       	call   f010706e <_ZL13pci_conf_readP8pci_funcj>
f010718d:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)

static void
pci_print_func(struct pci_func *f)
{
	const char *c = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f0107193:	89 c2                	mov    %eax,%edx
f0107195:	c1 ea 18             	shr    $0x18,%edx
};

static void
pci_print_func(struct pci_func *f)
{
	const char *c = pci_class[0];
f0107198:	b9 a4 96 10 f0       	mov    $0xf01096a4,%ecx
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f010719d:	83 fa 06             	cmp    $0x6,%edx
f01071a0:	77 07                	ja     f01071a9 <_ZL12pci_scan_busP7pci_bus+0x113>
		c = pci_class[PCI_CLASS(f->dev_class)];
f01071a2:	8b 0c 95 18 97 10 f0 	mov    -0xfef68e8(,%edx,4),%ecx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), c,
		f->irq_line);
f01071a9:	8b bd 1c ff ff ff    	mov    -0xe4(%ebp),%edi
f01071af:	0f b6 b5 54 ff ff ff 	movzbl -0xac(%ebp),%esi
f01071b6:	89 74 24 24          	mov    %esi,0x24(%esp)
f01071ba:	89 4c 24 20          	mov    %ecx,0x20(%esp)
f01071be:	c1 e8 10             	shr    $0x10,%eax
f01071c1:	25 ff 00 00 00       	and    $0xff,%eax
f01071c6:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f01071ca:	89 54 24 18          	mov    %edx,0x18(%esp)
f01071ce:	89 f8                	mov    %edi,%eax
f01071d0:	c1 e8 10             	shr    $0x10,%eax
f01071d3:	89 44 24 14          	mov    %eax,0x14(%esp)
f01071d7:	81 e7 ff ff 00 00    	and    $0xffff,%edi
f01071dd:	89 7c 24 10          	mov    %edi,0x10(%esp)
f01071e1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
f01071e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01071eb:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
f01071f1:	89 44 24 08          	mov    %eax,0x8(%esp)
f01071f5:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
f01071fb:	8b 40 04             	mov    0x4(%eax),%eax
f01071fe:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107202:	c7 04 24 30 95 10 f0 	movl   $0xf0109530,(%esp)
f0107209:	e8 a4 ce ff ff       	call   f01040b2 <_Z7cprintfPKcz>
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
f010720e:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
f0107214:	89 c2                	mov    %eax,%edx
f0107216:	c1 ea 10             	shr    $0x10,%edx
f0107219:	81 e2 ff 00 00 00    	and    $0xff,%edx
f010721f:	c1 e8 18             	shr    $0x18,%eax
			af.irq_line = PCI_INTERRUPT_LINE(intr);

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
			if (pci_show_devs)
				pci_print_func(&af);
			pci_attach(&af);
f0107222:	89 1c 24             	mov    %ebx,(%esp)
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
f0107225:	b9 14 80 12 f0       	mov    $0xf0128014,%ecx
f010722a:	e8 cd fc ff ff       	call   f0106efc <_ZL16pci_attach_matchjjP10pci_driverP8pci_func>
		pci_attach_match(PCI_VENDOR(f->dev_id),
				 PCI_PRODUCT(f->dev_id),
				 &pci_attach_vendor[0], f);
f010722f:	85 c0                	test   %eax,%eax
f0107231:	75 1d                	jne    f0107250 <_ZL12pci_scan_busP7pci_bus+0x1ba>
f0107233:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
f0107239:	89 c2                	mov    %eax,%edx
f010723b:	c1 ea 10             	shr    $0x10,%edx
f010723e:	25 ff ff 00 00       	and    $0xffff,%eax
			af.irq_line = PCI_INTERRUPT_LINE(intr);

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
			if (pci_show_devs)
				pci_print_func(&af);
			pci_attach(&af);
f0107243:	89 1c 24             	mov    %ebx,(%esp)
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
		pci_attach_match(PCI_VENDOR(f->dev_id),
				 PCI_PRODUCT(f->dev_id),
				 &pci_attach_vendor[0], f);
f0107246:	b9 2c 80 12 f0       	mov    $0xf012802c,%ecx
f010724b:	e8 ac fc ff ff       	call   f0106efc <_ZL16pci_attach_matchjjP10pci_driverP8pci_func>
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107250:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
f0107257:	83 bd fc fe ff ff 01 	cmpl   $0x1,-0x104(%ebp)
f010725e:	19 c0                	sbb    %eax,%eax
f0107260:	83 e0 f9             	and    $0xfffffff9,%eax
f0107263:	83 c0 08             	add    $0x8,%eax
f0107266:	3b 85 60 ff ff ff    	cmp    -0xa0(%ebp),%eax
f010726c:	0f 87 ce fe ff ff    	ja     f0107140 <_ZL12pci_scan_busP7pci_bus+0xaa>
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107272:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0107275:	83 c0 01             	add    $0x1,%eax
f0107278:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f010727b:	83 f8 1f             	cmp    $0x1f,%eax
f010727e:	0f 86 64 fe ff ff    	jbe    f01070e8 <_ZL12pci_scan_busP7pci_bus+0x52>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0107284:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
f010728a:	81 c4 2c 01 00 00    	add    $0x12c,%esp
f0107290:	5b                   	pop    %ebx
f0107291:	5e                   	pop    %esi
f0107292:	5f                   	pop    %edi
f0107293:	5d                   	pop    %ebp
f0107294:	c3                   	ret    

f0107295 <_ZL17pci_bridge_attachP8pci_func>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0107295:	55                   	push   %ebp
f0107296:	89 e5                	mov    %esp,%ebp
f0107298:	83 ec 48             	sub    $0x48,%esp
f010729b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f010729e:	89 75 f8             	mov    %esi,-0x8(%ebp)
f01072a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
f01072a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f01072a7:	ba 1c 00 00 00       	mov    $0x1c,%edx
f01072ac:	89 d8                	mov    %ebx,%eax
f01072ae:	e8 bb fd ff ff       	call   f010706e <_ZL13pci_conf_readP8pci_funcj>
f01072b3:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f01072b5:	ba 18 00 00 00       	mov    $0x18,%edx
f01072ba:	89 d8                	mov    %ebx,%eax
f01072bc:	e8 ad fd ff ff       	call   f010706e <_ZL13pci_conf_readP8pci_funcj>
f01072c1:	89 c6                	mov    %eax,%esi

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f01072c3:	83 e7 0f             	and    $0xf,%edi
f01072c6:	83 ff 01             	cmp    $0x1,%edi
f01072c9:	75 2a                	jne    f01072f5 <_ZL17pci_bridge_attachP8pci_func+0x60>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
			pcif->bus->busno, pcif->dev, pcif->func);
f01072cb:	8b 43 08             	mov    0x8(%ebx),%eax
f01072ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01072d2:	8b 43 04             	mov    0x4(%ebx),%eax
f01072d5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01072d9:	8b 03                	mov    (%ebx),%eax
f01072db:	8b 40 04             	mov    0x4(%eax),%eax
f01072de:	89 44 24 04          	mov    %eax,0x4(%esp)
f01072e2:	c7 04 24 6c 95 10 f0 	movl   $0xf010956c,(%esp)
f01072e9:	e8 c4 cd ff ff       	call   f01040b2 <_Z7cprintfPKcz>
		return 0;
f01072ee:	b8 00 00 00 00       	mov    $0x0,%eax
f01072f3:	eb 66                	jmp    f010735b <_ZL17pci_bridge_attachP8pci_func+0xc6>
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f01072f5:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f01072fc:	00 
f01072fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107304:	00 
f0107305:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0107308:	89 3c 24             	mov    %edi,(%esp)
f010730b:	e8 f1 f3 ff ff       	call   f0106701 <memset>
	nbus.parent_bridge = pcif;
f0107310:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0107313:	89 f2                	mov    %esi,%edx
f0107315:	0f b6 c6             	movzbl %dh,%eax
f0107318:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f010731b:	c1 ee 10             	shr    $0x10,%esi
f010731e:	81 e6 ff 00 00 00    	and    $0xff,%esi
f0107324:	89 74 24 14          	mov    %esi,0x14(%esp)
f0107328:	89 44 24 10          	mov    %eax,0x10(%esp)
f010732c:	8b 43 08             	mov    0x8(%ebx),%eax
f010732f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107333:	8b 43 04             	mov    0x4(%ebx),%eax
f0107336:	89 44 24 08          	mov    %eax,0x8(%esp)
f010733a:	8b 03                	mov    (%ebx),%eax
f010733c:	8b 40 04             	mov    0x4(%eax),%eax
f010733f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107343:	c7 04 24 a0 95 10 f0 	movl   $0xf01095a0,(%esp)
f010734a:	e8 63 cd ff ff       	call   f01040b2 <_Z7cprintfPKcz>

	pci_scan_bus(&nbus);
f010734f:	89 f8                	mov    %edi,%eax
f0107351:	e8 40 fd ff ff       	call   f0107096 <_ZL12pci_scan_busP7pci_bus>
	return 1;
f0107356:	b8 01 00 00 00       	mov    $0x1,%eax
}
f010735b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f010735e:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0107361:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0107364:	89 ec                	mov    %ebp,%esp
f0107366:	5d                   	pop    %ebp
f0107367:	c3                   	ret    

f0107368 <_ZL14pci_conf_writeP8pci_funcjj>:
	return inl(pci_conf1_data_ioport);
}

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f0107368:	55                   	push   %ebp
f0107369:	89 e5                	mov    %esp,%ebp
f010736b:	83 ec 18             	sub    $0x18,%esp
f010736e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0107371:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0107374:	89 d3                	mov    %edx,%ebx
f0107376:	89 ce                	mov    %ecx,%esi
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107378:	8b 48 08             	mov    0x8(%eax),%ecx
f010737b:	8b 50 04             	mov    0x4(%eax),%edx
f010737e:	8b 00                	mov    (%eax),%eax
f0107380:	8b 40 04             	mov    0x4(%eax),%eax
f0107383:	89 1c 24             	mov    %ebx,(%esp)
f0107386:	e8 e7 fb ff ff       	call   f0106f72 <_ZL18pci_conf1_set_addrjjjj>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010738b:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107390:	89 f0                	mov    %esi,%eax
f0107392:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f0107393:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0107396:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0107399:	89 ec                	mov    %ebp,%esp
f010739b:	5d                   	pop    %ebp
f010739c:	c3                   	ret    

f010739d <_Z15pci_func_enableP8pci_func>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f010739d:	55                   	push   %ebp
f010739e:	89 e5                	mov    %esp,%ebp
f01073a0:	57                   	push   %edi
f01073a1:	56                   	push   %esi
f01073a2:	53                   	push   %ebx
f01073a3:	83 ec 4c             	sub    $0x4c,%esp
f01073a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
		       PCI_COMMAND_IO_ENABLE |
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);
f01073a9:	b9 07 00 00 00       	mov    $0x7,%ecx
f01073ae:	ba 04 00 00 00       	mov    $0x4,%edx
f01073b3:	89 d8                	mov    %ebx,%eax
f01073b5:	e8 ae ff ff ff       	call   f0107368 <_ZL14pci_conf_writeP8pci_funcjj>

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01073ba:	be 10 00 00 00       	mov    $0x10,%esi
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f01073bf:	89 f2                	mov    %esi,%edx
f01073c1:	89 d8                	mov    %ebx,%eax
f01073c3:	e8 a6 fc ff ff       	call   f010706e <_ZL13pci_conf_readP8pci_funcj>
f01073c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		bar_width = 4;
		pci_conf_write(f, bar, 0xffffffff);
f01073cb:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01073d0:	89 f2                	mov    %esi,%edx
f01073d2:	89 d8                	mov    %ebx,%eax
f01073d4:	e8 8f ff ff ff       	call   f0107368 <_ZL14pci_conf_writeP8pci_funcjj>
		uint32_t rv = pci_conf_read(f, bar);
f01073d9:	89 f2                	mov    %esi,%edx
f01073db:	89 d8                	mov    %ebx,%eax
f01073dd:	e8 8c fc ff ff       	call   f010706e <_ZL13pci_conf_readP8pci_funcj>
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f01073e2:	bf 04 00 00 00       	mov    $0x4,%edi
		pci_conf_write(f, bar, 0xffffffff);
		uint32_t rv = pci_conf_read(f, bar);

		if (rv == 0)
f01073e7:	85 c0                	test   %eax,%eax
f01073e9:	0f 84 c4 00 00 00    	je     f01074b3 <_Z15pci_func_enableP8pci_func+0x116>
			continue;

		int regnum = PCI_MAPREG_NUM(bar);
f01073ef:	8d 56 f0             	lea    -0x10(%esi),%edx
f01073f2:	c1 ea 02             	shr    $0x2,%edx
f01073f5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f01073f8:	a8 01                	test   $0x1,%al
f01073fa:	75 2c                	jne    f0107428 <_Z15pci_func_enableP8pci_func+0x8b>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f01073fc:	89 c2                	mov    %eax,%edx
f01073fe:	83 e2 06             	and    $0x6,%edx
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f0107401:	83 fa 04             	cmp    $0x4,%edx
f0107404:	0f 94 c2             	sete   %dl
f0107407:	0f b6 d2             	movzbl %dl,%edx
f010740a:	8d 3c 95 04 00 00 00 	lea    0x4(,%edx,4),%edi
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
				bar_width = 8;

			size = PCI_MAPREG_MEM_SIZE(rv);
f0107411:	83 e0 f0             	and    $0xfffffff0,%eax
f0107414:	89 c2                	mov    %eax,%edx
f0107416:	f7 da                	neg    %edx
f0107418:	21 d0                	and    %edx,%eax
f010741a:	89 45 dc             	mov    %eax,-0x24(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
f010741d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0107420:	83 e0 f0             	and    $0xfffffff0,%eax
f0107423:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0107426:	eb 1a                	jmp    f0107442 <_Z15pci_func_enableP8pci_func+0xa5>
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0107428:	83 e0 fc             	and    $0xfffffffc,%eax
f010742b:	89 c2                	mov    %eax,%edx
f010742d:	f7 da                	neg    %edx
f010742f:	21 d0                	and    %edx,%eax
f0107431:	89 45 dc             	mov    %eax,-0x24(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
f0107434:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0107437:	83 e2 fc             	and    $0xfffffffc,%edx
f010743a:	89 55 d8             	mov    %edx,-0x28(%ebp)
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f010743d:	bf 04 00 00 00       	mov    $0x4,%edi
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0107442:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0107445:	89 f2                	mov    %esi,%edx
f0107447:	89 d8                	mov    %ebx,%eax
f0107449:	e8 1a ff ff ff       	call   f0107368 <_ZL14pci_conf_writeP8pci_funcjj>
		f->reg_base[regnum] = base;
f010744e:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0107451:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0107454:	89 54 83 14          	mov    %edx,0x14(%ebx,%eax,4)
		f->reg_size[regnum] = size;
f0107458:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010745b:	89 54 83 2c          	mov    %edx,0x2c(%ebx,%eax,4)

		if (size && !base)
f010745f:	85 d2                	test   %edx,%edx
f0107461:	74 50                	je     f01074b3 <_Z15pci_func_enableP8pci_func+0x116>
f0107463:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0107467:	75 4a                	jne    f01074b3 <_Z15pci_func_enableP8pci_func+0x116>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
f0107469:	8b 43 0c             	mov    0xc(%ebx),%eax
f010746c:	89 54 24 20          	mov    %edx,0x20(%esp)
f0107470:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0107473:	89 54 24 1c          	mov    %edx,0x1c(%esp)
f0107477:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010747a:	89 54 24 18          	mov    %edx,0x18(%esp)
f010747e:	89 c2                	mov    %eax,%edx
f0107480:	c1 ea 10             	shr    $0x10,%edx
f0107483:	89 54 24 14          	mov    %edx,0x14(%esp)
f0107487:	25 ff ff 00 00       	and    $0xffff,%eax
f010748c:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107490:	8b 43 08             	mov    0x8(%ebx),%eax
f0107493:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107497:	8b 43 04             	mov    0x4(%ebx),%eax
f010749a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010749e:	8b 03                	mov    (%ebx),%eax
f01074a0:	8b 40 04             	mov    0x4(%eax),%eax
f01074a3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01074a7:	c7 04 24 d0 95 10 f0 	movl   $0xf01095d0,(%esp)
f01074ae:	e8 ff cb ff ff       	call   f01040b2 <_Z7cprintfPKcz>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01074b3:	01 fe                	add    %edi,%esi
f01074b5:	83 fe 27             	cmp    $0x27,%esi
f01074b8:	0f 86 01 ff ff ff    	jbe    f01073bf <_Z15pci_func_enableP8pci_func+0x22>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f01074be:	8b 43 0c             	mov    0xc(%ebx),%eax
f01074c1:	89 c2                	mov    %eax,%edx
f01074c3:	c1 ea 10             	shr    $0x10,%edx
f01074c6:	89 54 24 14          	mov    %edx,0x14(%esp)
f01074ca:	25 ff ff 00 00       	and    $0xffff,%eax
f01074cf:	89 44 24 10          	mov    %eax,0x10(%esp)
f01074d3:	8b 43 08             	mov    0x8(%ebx),%eax
f01074d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01074da:	8b 43 04             	mov    0x4(%ebx),%eax
f01074dd:	89 44 24 08          	mov    %eax,0x8(%esp)
f01074e1:	8b 03                	mov    (%ebx),%eax
f01074e3:	8b 40 04             	mov    0x4(%eax),%eax
f01074e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01074ea:	c7 04 24 2c 96 10 f0 	movl   $0xf010962c,(%esp)
f01074f1:	e8 bc cb ff ff       	call   f01040b2 <_Z7cprintfPKcz>
}
f01074f6:	83 c4 4c             	add    $0x4c,%esp
f01074f9:	5b                   	pop    %ebx
f01074fa:	5e                   	pop    %esi
f01074fb:	5f                   	pop    %edi
f01074fc:	5d                   	pop    %ebp
f01074fd:	c3                   	ret    

f01074fe <_Z8pci_initv>:

int
pci_init(void)
{
f01074fe:	55                   	push   %ebp
f01074ff:	89 e5                	mov    %esp,%ebp
f0107501:	83 ec 18             	sub    $0x18,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107504:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f010750b:	00 
f010750c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107513:	00 
f0107514:	c7 04 24 00 a0 3b f0 	movl   $0xf03ba000,(%esp)
f010751b:	e8 e1 f1 ff ff       	call   f0106701 <memset>

	return pci_scan_bus(&root_bus);
f0107520:	b8 00 a0 3b f0       	mov    $0xf03ba000,%eax
f0107525:	e8 6c fb ff ff       	call   f0107096 <_ZL12pci_scan_busP7pci_bus>
}
f010752a:	c9                   	leave  
f010752b:	c3                   	ret    

f010752c <_Z9time_initv>:

static unsigned int ticks;

void
time_init(void)
{
f010752c:	55                   	push   %ebp
f010752d:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f010752f:	c7 05 08 a0 3b f0 00 	movl   $0x0,0xf03ba008
f0107536:	00 00 00 
}
f0107539:	5d                   	pop    %ebp
f010753a:	c3                   	ret    

f010753b <_Z9time_tickv>:

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
f010753b:	55                   	push   %ebp
f010753c:	89 e5                	mov    %esp,%ebp
f010753e:	83 ec 18             	sub    $0x18,%esp
	ticks++;
f0107541:	a1 08 a0 3b f0       	mov    0xf03ba008,%eax
f0107546:	83 c0 01             	add    $0x1,%eax
f0107549:	a3 08 a0 3b f0       	mov    %eax,0xf03ba008
	if (ticks * 10 < ticks)
f010754e:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0107551:	01 d2                	add    %edx,%edx
f0107553:	39 d0                	cmp    %edx,%eax
f0107555:	76 1c                	jbe    f0107573 <_Z9time_tickv+0x38>
		panic("time_tick: time overflowed");
f0107557:	c7 44 24 08 34 97 10 	movl   $0xf0109734,0x8(%esp)
f010755e:	f0 
f010755f:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
f0107566:	00 
f0107567:	c7 04 24 4f 97 10 f0 	movl   $0xf010974f,(%esp)
f010756e:	e8 b5 8c ff ff       	call   f0100228 <_Z6_panicPKciS0_z>
}
f0107573:	c9                   	leave  
f0107574:	c3                   	ret    

f0107575 <_Z9time_msecv>:

unsigned int
time_msec(void)
{
f0107575:	55                   	push   %ebp
f0107576:	89 e5                	mov    %esp,%ebp
	return ticks * 10;
f0107578:	a1 08 a0 3b f0       	mov    0xf03ba008,%eax
f010757d:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0107580:	01 c0                	add    %eax,%eax
}
f0107582:	5d                   	pop    %ebp
f0107583:	c3                   	ret    
	...

f0107590 <__udivdi3>:
f0107590:	55                   	push   %ebp
f0107591:	89 e5                	mov    %esp,%ebp
f0107593:	57                   	push   %edi
f0107594:	56                   	push   %esi
f0107595:	83 ec 20             	sub    $0x20,%esp
f0107598:	8b 45 14             	mov    0x14(%ebp),%eax
f010759b:	8b 75 08             	mov    0x8(%ebp),%esi
f010759e:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01075a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01075a4:	85 c0                	test   %eax,%eax
f01075a6:	89 75 e8             	mov    %esi,-0x18(%ebp)
f01075a9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01075ac:	75 3a                	jne    f01075e8 <__udivdi3+0x58>
f01075ae:	39 f9                	cmp    %edi,%ecx
f01075b0:	77 66                	ja     f0107618 <__udivdi3+0x88>
f01075b2:	85 c9                	test   %ecx,%ecx
f01075b4:	75 0b                	jne    f01075c1 <__udivdi3+0x31>
f01075b6:	b8 01 00 00 00       	mov    $0x1,%eax
f01075bb:	31 d2                	xor    %edx,%edx
f01075bd:	f7 f1                	div    %ecx
f01075bf:	89 c1                	mov    %eax,%ecx
f01075c1:	89 f8                	mov    %edi,%eax
f01075c3:	31 d2                	xor    %edx,%edx
f01075c5:	f7 f1                	div    %ecx
f01075c7:	89 c7                	mov    %eax,%edi
f01075c9:	89 f0                	mov    %esi,%eax
f01075cb:	f7 f1                	div    %ecx
f01075cd:	89 fa                	mov    %edi,%edx
f01075cf:	89 c6                	mov    %eax,%esi
f01075d1:	89 75 f0             	mov    %esi,-0x10(%ebp)
f01075d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
f01075d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01075da:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01075dd:	83 c4 20             	add    $0x20,%esp
f01075e0:	5e                   	pop    %esi
f01075e1:	5f                   	pop    %edi
f01075e2:	5d                   	pop    %ebp
f01075e3:	c3                   	ret    
f01075e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01075e8:	31 d2                	xor    %edx,%edx
f01075ea:	31 f6                	xor    %esi,%esi
f01075ec:	39 f8                	cmp    %edi,%eax
f01075ee:	77 e1                	ja     f01075d1 <__udivdi3+0x41>
f01075f0:	0f bd d0             	bsr    %eax,%edx
f01075f3:	83 f2 1f             	xor    $0x1f,%edx
f01075f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
f01075f9:	75 2d                	jne    f0107628 <__udivdi3+0x98>
f01075fb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f01075fe:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
f0107601:	76 06                	jbe    f0107609 <__udivdi3+0x79>
f0107603:	39 f8                	cmp    %edi,%eax
f0107605:	89 f2                	mov    %esi,%edx
f0107607:	73 c8                	jae    f01075d1 <__udivdi3+0x41>
f0107609:	31 d2                	xor    %edx,%edx
f010760b:	be 01 00 00 00       	mov    $0x1,%esi
f0107610:	eb bf                	jmp    f01075d1 <__udivdi3+0x41>
f0107612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107618:	89 f0                	mov    %esi,%eax
f010761a:	89 fa                	mov    %edi,%edx
f010761c:	f7 f1                	div    %ecx
f010761e:	31 d2                	xor    %edx,%edx
f0107620:	89 c6                	mov    %eax,%esi
f0107622:	eb ad                	jmp    f01075d1 <__udivdi3+0x41>
f0107624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107628:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010762c:	89 c2                	mov    %eax,%edx
f010762e:	b8 20 00 00 00       	mov    $0x20,%eax
f0107633:	8b 75 f0             	mov    -0x10(%ebp),%esi
f0107636:	2b 45 ec             	sub    -0x14(%ebp),%eax
f0107639:	d3 e2                	shl    %cl,%edx
f010763b:	89 c1                	mov    %eax,%ecx
f010763d:	d3 ee                	shr    %cl,%esi
f010763f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0107643:	09 d6                	or     %edx,%esi
f0107645:	89 fa                	mov    %edi,%edx
f0107647:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f010764a:	8b 75 f0             	mov    -0x10(%ebp),%esi
f010764d:	d3 e6                	shl    %cl,%esi
f010764f:	89 c1                	mov    %eax,%ecx
f0107651:	d3 ea                	shr    %cl,%edx
f0107653:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0107657:	89 75 f0             	mov    %esi,-0x10(%ebp)
f010765a:	8b 75 e8             	mov    -0x18(%ebp),%esi
f010765d:	d3 e7                	shl    %cl,%edi
f010765f:	89 c1                	mov    %eax,%ecx
f0107661:	d3 ee                	shr    %cl,%esi
f0107663:	09 fe                	or     %edi,%esi
f0107665:	89 f0                	mov    %esi,%eax
f0107667:	f7 75 e4             	divl   -0x1c(%ebp)
f010766a:	89 d7                	mov    %edx,%edi
f010766c:	89 c6                	mov    %eax,%esi
f010766e:	f7 65 f0             	mull   -0x10(%ebp)
f0107671:	39 d7                	cmp    %edx,%edi
f0107673:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0107676:	72 12                	jb     f010768a <__udivdi3+0xfa>
f0107678:	8b 55 e8             	mov    -0x18(%ebp),%edx
f010767b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010767f:	d3 e2                	shl    %cl,%edx
f0107681:	39 c2                	cmp    %eax,%edx
f0107683:	73 08                	jae    f010768d <__udivdi3+0xfd>
f0107685:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
f0107688:	75 03                	jne    f010768d <__udivdi3+0xfd>
f010768a:	83 ee 01             	sub    $0x1,%esi
f010768d:	31 d2                	xor    %edx,%edx
f010768f:	e9 3d ff ff ff       	jmp    f01075d1 <__udivdi3+0x41>
	...

f01076a0 <__umoddi3>:
f01076a0:	55                   	push   %ebp
f01076a1:	89 e5                	mov    %esp,%ebp
f01076a3:	57                   	push   %edi
f01076a4:	56                   	push   %esi
f01076a5:	83 ec 20             	sub    $0x20,%esp
f01076a8:	8b 7d 14             	mov    0x14(%ebp),%edi
f01076ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01076ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01076b1:	8b 75 0c             	mov    0xc(%ebp),%esi
f01076b4:	85 ff                	test   %edi,%edi
f01076b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
f01076b9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f01076bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01076bf:	89 f2                	mov    %esi,%edx
f01076c1:	75 15                	jne    f01076d8 <__umoddi3+0x38>
f01076c3:	39 f1                	cmp    %esi,%ecx
f01076c5:	76 41                	jbe    f0107708 <__umoddi3+0x68>
f01076c7:	f7 f1                	div    %ecx
f01076c9:	89 d0                	mov    %edx,%eax
f01076cb:	31 d2                	xor    %edx,%edx
f01076cd:	83 c4 20             	add    $0x20,%esp
f01076d0:	5e                   	pop    %esi
f01076d1:	5f                   	pop    %edi
f01076d2:	5d                   	pop    %ebp
f01076d3:	c3                   	ret    
f01076d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01076d8:	39 f7                	cmp    %esi,%edi
f01076da:	77 4c                	ja     f0107728 <__umoddi3+0x88>
f01076dc:	0f bd c7             	bsr    %edi,%eax
f01076df:	83 f0 1f             	xor    $0x1f,%eax
f01076e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01076e5:	75 51                	jne    f0107738 <__umoddi3+0x98>
f01076e7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
f01076ea:	0f 87 e8 00 00 00    	ja     f01077d8 <__umoddi3+0x138>
f01076f0:	89 f2                	mov    %esi,%edx
f01076f2:	8b 75 f0             	mov    -0x10(%ebp),%esi
f01076f5:	29 ce                	sub    %ecx,%esi
f01076f7:	19 fa                	sbb    %edi,%edx
f01076f9:	89 75 f0             	mov    %esi,-0x10(%ebp)
f01076fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01076ff:	83 c4 20             	add    $0x20,%esp
f0107702:	5e                   	pop    %esi
f0107703:	5f                   	pop    %edi
f0107704:	5d                   	pop    %ebp
f0107705:	c3                   	ret    
f0107706:	66 90                	xchg   %ax,%ax
f0107708:	85 c9                	test   %ecx,%ecx
f010770a:	75 0b                	jne    f0107717 <__umoddi3+0x77>
f010770c:	b8 01 00 00 00       	mov    $0x1,%eax
f0107711:	31 d2                	xor    %edx,%edx
f0107713:	f7 f1                	div    %ecx
f0107715:	89 c1                	mov    %eax,%ecx
f0107717:	89 f0                	mov    %esi,%eax
f0107719:	31 d2                	xor    %edx,%edx
f010771b:	f7 f1                	div    %ecx
f010771d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0107720:	eb a5                	jmp    f01076c7 <__umoddi3+0x27>
f0107722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107728:	89 f2                	mov    %esi,%edx
f010772a:	83 c4 20             	add    $0x20,%esp
f010772d:	5e                   	pop    %esi
f010772e:	5f                   	pop    %edi
f010772f:	5d                   	pop    %ebp
f0107730:	c3                   	ret    
f0107731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107738:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010773c:	89 f2                	mov    %esi,%edx
f010773e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0107741:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
f0107748:	29 45 f0             	sub    %eax,-0x10(%ebp)
f010774b:	d3 e7                	shl    %cl,%edi
f010774d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0107750:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0107754:	d3 e8                	shr    %cl,%eax
f0107756:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010775a:	09 f8                	or     %edi,%eax
f010775c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010775f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0107762:	d3 e0                	shl    %cl,%eax
f0107764:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0107768:	89 45 f4             	mov    %eax,-0xc(%ebp)
f010776b:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010776e:	d3 ea                	shr    %cl,%edx
f0107770:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0107774:	d3 e6                	shl    %cl,%esi
f0107776:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f010777a:	d3 e8                	shr    %cl,%eax
f010777c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0107780:	09 f0                	or     %esi,%eax
f0107782:	8b 75 e8             	mov    -0x18(%ebp),%esi
f0107785:	f7 75 e4             	divl   -0x1c(%ebp)
f0107788:	d3 e6                	shl    %cl,%esi
f010778a:	89 75 e8             	mov    %esi,-0x18(%ebp)
f010778d:	89 d6                	mov    %edx,%esi
f010778f:	f7 65 f4             	mull   -0xc(%ebp)
f0107792:	89 d7                	mov    %edx,%edi
f0107794:	89 c2                	mov    %eax,%edx
f0107796:	39 fe                	cmp    %edi,%esi
f0107798:	89 f9                	mov    %edi,%ecx
f010779a:	72 30                	jb     f01077cc <__umoddi3+0x12c>
f010779c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
f010779f:	72 27                	jb     f01077c8 <__umoddi3+0x128>
f01077a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01077a4:	29 d0                	sub    %edx,%eax
f01077a6:	19 ce                	sbb    %ecx,%esi
f01077a8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01077ac:	89 f2                	mov    %esi,%edx
f01077ae:	d3 e8                	shr    %cl,%eax
f01077b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f01077b4:	d3 e2                	shl    %cl,%edx
f01077b6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01077ba:	09 d0                	or     %edx,%eax
f01077bc:	89 f2                	mov    %esi,%edx
f01077be:	d3 ea                	shr    %cl,%edx
f01077c0:	83 c4 20             	add    $0x20,%esp
f01077c3:	5e                   	pop    %esi
f01077c4:	5f                   	pop    %edi
f01077c5:	5d                   	pop    %ebp
f01077c6:	c3                   	ret    
f01077c7:	90                   	nop
f01077c8:	39 fe                	cmp    %edi,%esi
f01077ca:	75 d5                	jne    f01077a1 <__umoddi3+0x101>
f01077cc:	89 f9                	mov    %edi,%ecx
f01077ce:	89 c2                	mov    %eax,%edx
f01077d0:	2b 55 f4             	sub    -0xc(%ebp),%edx
f01077d3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f01077d6:	eb c9                	jmp    f01077a1 <__umoddi3+0x101>
f01077d8:	39 f7                	cmp    %esi,%edi
f01077da:	0f 82 10 ff ff ff    	jb     f01076f0 <__umoddi3+0x50>
f01077e0:	e9 17 ff ff ff       	jmp    f01076fc <__umoddi3+0x5c>
