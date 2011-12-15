
obj/user/testpteshare:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 ff ee    	cmp    $0xeeffe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 87 01 00 00       	call   8001b8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z12childofspawnv>:
	breakpoint();
}

void
childofspawn(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  80003a:	a1 04 60 80 00       	mov    0x806004,%eax
  80003f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800043:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80004a:	e8 2b 09 00 00       	call   80097a <_Z6strcpyPcPKc>
	exit();
  80004f:	e8 cc 01 00 00       	call   800220 <_Z4exitv>
}
  800054:	c9                   	leave  
  800055:	c3                   	ret    

00800056 <_Z5umainiPPc>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	53                   	push   %ebx
  80005a:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800061:	74 05                	je     800068 <_Z5umainiPPc+0x12>
		childofspawn();
  800063:	e8 cc ff ff ff       	call   800034 <_Z12childofspawnv>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800068:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80006f:	00 
  800070:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  800077:	a0 
  800078:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007f:	e8 dc 0d 00 00       	call   800e60 <_Z14sys_page_allociPvi>
  800084:	85 c0                	test   %eax,%eax
  800086:	79 20                	jns    8000a8 <_Z5umainiPPc+0x52>
		panic("sys_page_alloc: %e", r);
  800088:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008c:	c7 44 24 08 6c 4d 80 	movl   $0x804d6c,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009b:	00 
  80009c:	c7 04 24 7f 4d 80 00 	movl   $0x804d7f,(%esp)
  8000a3:	e8 94 01 00 00       	call   80023c <_Z6_panicPKciS0_z>

	// check fork
	if ((r = fork()) < 0)
  8000a8:	e8 f0 13 00 00       	call   80149d <_Z4forkv>
  8000ad:	89 c3                	mov    %eax,%ebx
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	79 20                	jns    8000d3 <_Z5umainiPPc+0x7d>
		panic("fork: %e", r);
  8000b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b7:	c7 44 24 08 f5 51 80 	movl   $0x8051f5,0x8(%esp)
  8000be:	00 
  8000bf:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c6:	00 
  8000c7:	c7 04 24 7f 4d 80 00 	movl   $0x804d7f,(%esp)
  8000ce:	e8 69 01 00 00       	call   80023c <_Z6_panicPKciS0_z>
	if (r == 0) {
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	75 1a                	jne    8000f1 <_Z5umainiPPc+0x9b>
		strcpy(VA, msg);
  8000d7:	a1 00 60 80 00       	mov    0x806000,%eax
  8000dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e0:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e7:	e8 8e 08 00 00       	call   80097a <_Z6strcpyPcPKc>
		exit();
  8000ec:	e8 2f 01 00 00       	call   800220 <_Z4exitv>
	}
	wait(r);
  8000f1:	89 1c 24             	mov    %ebx,(%esp)
  8000f4:	e8 a7 40 00 00       	call   8041a0 <_Z4waiti>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f9:	a1 00 60 80 00       	mov    0x806000,%eax
  8000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800102:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800109:	e8 f6 08 00 00       	call   800a04 <_Z6strcmpPKcS0_>
  80010e:	85 c0                	test   %eax,%eax
  800110:	b8 60 4d 80 00       	mov    $0x804d60,%eax
  800115:	ba 66 4d 80 00       	mov    $0x804d66,%edx
  80011a:	0f 45 c2             	cmovne %edx,%eax
  80011d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800121:	c7 04 24 93 4d 80 00 	movl   $0x804d93,(%esp)
  800128:	e8 2d 02 00 00       	call   80035a <_Z7cprintfPKcz>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800134:	00 
  800135:	c7 44 24 08 ae 4d 80 	movl   $0x804dae,0x8(%esp)
  80013c:	00 
  80013d:	c7 44 24 04 b3 4d 80 	movl   $0x804db3,0x4(%esp)
  800144:	00 
  800145:	c7 04 24 b2 4d 80 00 	movl   $0x804db2,(%esp)
  80014c:	e8 64 1e 00 00       	call   801fb5 <_Z6spawnlPKcS0_z>
  800151:	85 c0                	test   %eax,%eax
  800153:	79 20                	jns    800175 <_Z5umainiPPc+0x11f>
		panic("spawn: %e", r);
  800155:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800159:	c7 44 24 08 c0 4d 80 	movl   $0x804dc0,0x8(%esp)
  800160:	00 
  800161:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800168:	00 
  800169:	c7 04 24 7f 4d 80 00 	movl   $0x804d7f,(%esp)
  800170:	e8 c7 00 00 00       	call   80023c <_Z6_panicPKciS0_z>
	wait(r);
  800175:	89 04 24             	mov    %eax,(%esp)
  800178:	e8 23 40 00 00       	call   8041a0 <_Z4waiti>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017d:	a1 04 60 80 00       	mov    0x806004,%eax
  800182:	89 44 24 04          	mov    %eax,0x4(%esp)
  800186:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018d:	e8 72 08 00 00       	call   800a04 <_Z6strcmpPKcS0_>
  800192:	85 c0                	test   %eax,%eax
  800194:	b8 60 4d 80 00       	mov    $0x804d60,%eax
  800199:	ba 66 4d 80 00       	mov    $0x804d66,%edx
  80019e:	0f 45 c2             	cmovne %edx,%eax
  8001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a5:	c7 04 24 ca 4d 80 00 	movl   $0x804dca,(%esp)
  8001ac:	e8 a9 01 00 00       	call   80035a <_Z7cprintfPKcz>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001b1:	cc                   	int3   

	breakpoint();
}
  8001b2:	83 c4 14             	add    $0x14,%esp
  8001b5:	5b                   	pop    %ebx
  8001b6:	5d                   	pop    %ebp
  8001b7:	c3                   	ret    

008001b8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	57                   	push   %edi
  8001bc:	56                   	push   %esi
  8001bd:	53                   	push   %ebx
  8001be:	83 ec 1c             	sub    $0x1c,%esp
  8001c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8001c4:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8001c7:	e8 2c 0c 00 00       	call   800df8 <_Z12sys_getenvidv>
  8001cc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d1:	6b c0 78             	imul   $0x78,%eax,%eax
  8001d4:	05 00 00 00 ef       	add    $0xef000000,%eax
  8001d9:	a3 00 70 80 00       	mov    %eax,0x807000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001de:	85 ff                	test   %edi,%edi
  8001e0:	7e 07                	jle    8001e9 <libmain+0x31>
		binaryname = argv[0];
  8001e2:	8b 06                	mov    (%esi),%eax
  8001e4:	a3 08 60 80 00       	mov    %eax,0x806008

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8001e9:	b8 25 5a 80 00       	mov    $0x805a25,%eax
  8001ee:	3d 25 5a 80 00       	cmp    $0x805a25,%eax
  8001f3:	76 0f                	jbe    800204 <libmain+0x4c>
  8001f5:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  8001f7:	83 eb 04             	sub    $0x4,%ebx
  8001fa:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8001fc:	81 fb 25 5a 80 00    	cmp    $0x805a25,%ebx
  800202:	77 f3                	ja     8001f7 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800204:	89 74 24 04          	mov    %esi,0x4(%esp)
  800208:	89 3c 24             	mov    %edi,(%esp)
  80020b:	e8 46 fe ff ff       	call   800056 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800210:	e8 0b 00 00 00       	call   800220 <_Z4exitv>
}
  800215:	83 c4 1c             	add    $0x1c,%esp
  800218:	5b                   	pop    %ebx
  800219:	5e                   	pop    %esi
  80021a:	5f                   	pop    %edi
  80021b:	5d                   	pop    %ebp
  80021c:	c3                   	ret    
  80021d:	00 00                	add    %al,(%eax)
	...

00800220 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800226:	e8 63 20 00 00       	call   80228e <_Z9close_allv>
	sys_env_destroy(0);
  80022b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800232:	e8 64 0b 00 00       	call   800d9b <_Z15sys_env_destroyi>
}
  800237:	c9                   	leave  
  800238:	c3                   	ret    
  800239:	00 00                	add    %al,(%eax)
	...

0080023c <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	56                   	push   %esi
  800240:	53                   	push   %ebx
  800241:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800244:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  800247:	a1 04 70 80 00       	mov    0x807004,%eax
  80024c:	85 c0                	test   %eax,%eax
  80024e:	74 10                	je     800260 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  800250:	89 44 24 04          	mov    %eax,0x4(%esp)
  800254:	c7 04 24 0e 4e 80 00 	movl   $0x804e0e,(%esp)
  80025b:	e8 fa 00 00 00       	call   80035a <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  800260:	8b 1d 08 60 80 00    	mov    0x806008,%ebx
  800266:	e8 8d 0b 00 00       	call   800df8 <_Z12sys_getenvidv>
  80026b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800272:	8b 55 08             	mov    0x8(%ebp),%edx
  800275:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800279:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80027d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800281:	c7 04 24 14 4e 80 00 	movl   $0x804e14,(%esp)
  800288:	e8 cd 00 00 00       	call   80035a <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  80028d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800291:	8b 45 10             	mov    0x10(%ebp),%eax
  800294:	89 04 24             	mov    %eax,(%esp)
  800297:	e8 5d 00 00 00       	call   8002f9 <_Z8vcprintfPKcPc>
	cprintf("\n");
  80029c:	c7 04 24 af 58 80 00 	movl   $0x8058af,(%esp)
  8002a3:	e8 b2 00 00 00       	call   80035a <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a8:	cc                   	int3   
  8002a9:	eb fd                	jmp    8002a8 <_Z6_panicPKciS0_z+0x6c>
	...

008002ac <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 18             	sub    $0x18,%esp
  8002b2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8002b5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8002b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  8002bb:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8002bd:	8b 03                	mov    (%ebx),%eax
  8002bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c2:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002c6:	83 c0 01             	add    $0x1,%eax
  8002c9:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 19                	jne    8002eb <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8002d2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002d9:	00 
  8002da:	8d 43 08             	lea    0x8(%ebx),%eax
  8002dd:	89 04 24             	mov    %eax,(%esp)
  8002e0:	e8 4f 0a 00 00       	call   800d34 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8002e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002eb:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8002ef:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8002f2:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8002f5:	89 ec                	mov    %ebp,%esp
  8002f7:	5d                   	pop    %ebp
  8002f8:	c3                   	ret    

008002f9 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800302:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800309:	00 00 00 
	b.cnt = 0;
  80030c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800313:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80031d:	8b 45 08             	mov    0x8(%ebp),%eax
  800320:	89 44 24 08          	mov    %eax,0x8(%esp)
  800324:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032e:	c7 04 24 ac 02 80 00 	movl   $0x8002ac,(%esp)
  800335:	e8 ad 01 00 00       	call   8004e7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80033a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800340:	89 44 24 04          	mov    %eax,0x4(%esp)
  800344:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80034a:	89 04 24             	mov    %eax,(%esp)
  80034d:	e8 e2 09 00 00       	call   800d34 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800352:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800360:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800363:	89 44 24 04          	mov    %eax,0x4(%esp)
  800367:	8b 45 08             	mov    0x8(%ebp),%eax
  80036a:	89 04 24             	mov    %eax,(%esp)
  80036d:	e8 87 ff ff ff       	call   8002f9 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800372:	c9                   	leave  
  800373:	c3                   	ret    
	...

00800380 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	57                   	push   %edi
  800384:	56                   	push   %esi
  800385:	53                   	push   %ebx
  800386:	83 ec 4c             	sub    $0x4c,%esp
  800389:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038c:	89 d6                	mov    %edx,%esi
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80039a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80039d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a5:	39 d0                	cmp    %edx,%eax
  8003a7:	72 11                	jb     8003ba <_ZL8printnumPFviPvES_yjii+0x3a>
  8003a9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ac:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  8003af:	76 09                	jbe    8003ba <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b1:	83 eb 01             	sub    $0x1,%ebx
  8003b4:	85 db                	test   %ebx,%ebx
  8003b6:	7f 5d                	jg     800415 <_ZL8printnumPFviPvES_yjii+0x95>
  8003b8:	eb 6c                	jmp    800426 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ba:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003be:	83 eb 01             	sub    $0x1,%ebx
  8003c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003d0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003d7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8003da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003e1:	00 
  8003e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003e5:	89 14 24             	mov    %edx,(%esp)
  8003e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003ef:	e8 fc 46 00 00       	call   804af0 <__udivdi3>
  8003f4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003f7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003fa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003fe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800402:	89 04 24             	mov    %eax,(%esp)
  800405:	89 54 24 04          	mov    %edx,0x4(%esp)
  800409:	89 f2                	mov    %esi,%edx
  80040b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040e:	e8 6d ff ff ff       	call   800380 <_ZL8printnumPFviPvES_yjii>
  800413:	eb 11                	jmp    800426 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800415:	89 74 24 04          	mov    %esi,0x4(%esp)
  800419:	89 3c 24             	mov    %edi,(%esp)
  80041c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041f:	83 eb 01             	sub    $0x1,%ebx
  800422:	85 db                	test   %ebx,%ebx
  800424:	7f ef                	jg     800415 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800426:	89 74 24 04          	mov    %esi,0x4(%esp)
  80042a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80042e:	8b 45 10             	mov    0x10(%ebp),%eax
  800431:	89 44 24 08          	mov    %eax,0x8(%esp)
  800435:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80043c:	00 
  80043d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800440:	89 14 24             	mov    %edx,(%esp)
  800443:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800446:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80044a:	e8 b1 47 00 00       	call   804c00 <__umoddi3>
  80044f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800453:	0f be 80 37 4e 80 00 	movsbl 0x804e37(%eax),%eax
  80045a:	89 04 24             	mov    %eax,(%esp)
  80045d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800460:	83 c4 4c             	add    $0x4c,%esp
  800463:	5b                   	pop    %ebx
  800464:	5e                   	pop    %esi
  800465:	5f                   	pop    %edi
  800466:	5d                   	pop    %ebp
  800467:	c3                   	ret    

00800468 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80046b:	83 fa 01             	cmp    $0x1,%edx
  80046e:	7e 0e                	jle    80047e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800470:	8b 10                	mov    (%eax),%edx
  800472:	8d 4a 08             	lea    0x8(%edx),%ecx
  800475:	89 08                	mov    %ecx,(%eax)
  800477:	8b 02                	mov    (%edx),%eax
  800479:	8b 52 04             	mov    0x4(%edx),%edx
  80047c:	eb 22                	jmp    8004a0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80047e:	85 d2                	test   %edx,%edx
  800480:	74 10                	je     800492 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800482:	8b 10                	mov    (%eax),%edx
  800484:	8d 4a 04             	lea    0x4(%edx),%ecx
  800487:	89 08                	mov    %ecx,(%eax)
  800489:	8b 02                	mov    (%edx),%eax
  80048b:	ba 00 00 00 00       	mov    $0x0,%edx
  800490:	eb 0e                	jmp    8004a0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800492:	8b 10                	mov    (%eax),%edx
  800494:	8d 4a 04             	lea    0x4(%edx),%ecx
  800497:	89 08                	mov    %ecx,(%eax)
  800499:	8b 02                	mov    (%edx),%eax
  80049b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004a0:	5d                   	pop    %ebp
  8004a1:	c3                   	ret    

008004a2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8004a8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ac:	8b 10                	mov    (%eax),%edx
  8004ae:	3b 50 04             	cmp    0x4(%eax),%edx
  8004b1:	73 0a                	jae    8004bd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8004b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004b6:	88 0a                	mov    %cl,(%edx)
  8004b8:	83 c2 01             	add    $0x1,%edx
  8004bb:	89 10                	mov    %edx,(%eax)
}
  8004bd:	5d                   	pop    %ebp
  8004be:	c3                   	ret    

008004bf <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
  8004c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004c5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	89 04 24             	mov    %eax,(%esp)
  8004e0:	e8 02 00 00 00       	call   8004e7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8004e5:	c9                   	leave  
  8004e6:	c3                   	ret    

008004e7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	57                   	push   %edi
  8004eb:	56                   	push   %esi
  8004ec:	53                   	push   %ebx
  8004ed:	83 ec 3c             	sub    $0x3c,%esp
  8004f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f3:	8b 55 10             	mov    0x10(%ebp),%edx
  8004f6:	0f b6 02             	movzbl (%edx),%eax
  8004f9:	89 d3                	mov    %edx,%ebx
  8004fb:	83 c3 01             	add    $0x1,%ebx
  8004fe:	83 f8 25             	cmp    $0x25,%eax
  800501:	74 2b                	je     80052e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800503:	85 c0                	test   %eax,%eax
  800505:	75 10                	jne    800517 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800507:	e9 a5 03 00 00       	jmp    8008b1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80050c:	85 c0                	test   %eax,%eax
  80050e:	66 90                	xchg   %ax,%ax
  800510:	75 08                	jne    80051a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800512:	e9 9a 03 00 00       	jmp    8008b1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800517:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80051a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800523:	0f b6 03             	movzbl (%ebx),%eax
  800526:	83 c3 01             	add    $0x1,%ebx
  800529:	83 f8 25             	cmp    $0x25,%eax
  80052c:	75 de                	jne    80050c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80052e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800532:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800539:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80053e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800545:	b9 00 00 00 00       	mov    $0x0,%ecx
  80054a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80054d:	eb 2b                	jmp    80057a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800552:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800556:	eb 22                	jmp    80057a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800558:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80055b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80055f:	eb 19                	jmp    80057a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800561:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800564:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80056b:	eb 0d                	jmp    80057a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80056d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800570:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800573:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	0f b6 03             	movzbl (%ebx),%eax
  80057d:	0f b6 d0             	movzbl %al,%edx
  800580:	8d 73 01             	lea    0x1(%ebx),%esi
  800583:	89 75 10             	mov    %esi,0x10(%ebp)
  800586:	83 e8 23             	sub    $0x23,%eax
  800589:	3c 55                	cmp    $0x55,%al
  80058b:	0f 87 d8 02 00 00    	ja     800869 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800591:	0f b6 c0             	movzbl %al,%eax
  800594:	ff 24 85 e0 4f 80 00 	jmp    *0x804fe0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80059b:	83 ea 30             	sub    $0x30,%edx
  80059e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8005a1:	8b 55 10             	mov    0x10(%ebp),%edx
  8005a4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8005a7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8005ad:	83 fa 09             	cmp    $0x9,%edx
  8005b0:	77 4e                	ja     800600 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8005b8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8005bb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8005bf:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  8005c2:	8d 50 d0             	lea    -0x30(%eax),%edx
  8005c5:	83 fa 09             	cmp    $0x9,%edx
  8005c8:	76 eb                	jbe    8005b5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  8005ca:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005cd:	eb 31                	jmp    800600 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 50 04             	lea    0x4(%eax),%edx
  8005d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005e0:	eb 1e                	jmp    800600 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8005e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e6:	0f 88 75 ff ff ff    	js     800561 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005ef:	eb 89                	jmp    80057a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8005f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005fb:	e9 7a ff ff ff       	jmp    80057a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800604:	0f 89 70 ff ff ff    	jns    80057a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80060a:	e9 5e ff ff ff       	jmp    80056d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80060f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800612:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800615:	e9 60 ff ff ff       	jmp    80057a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 50 04             	lea    0x4(%eax),%edx
  800620:	89 55 14             	mov    %edx,0x14(%ebp)
  800623:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800627:	8b 00                	mov    (%eax),%eax
  800629:	89 04 24             	mov    %eax,(%esp)
  80062c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80062f:	e9 bf fe ff ff       	jmp    8004f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8d 50 04             	lea    0x4(%eax),%edx
  80063a:	89 55 14             	mov    %edx,0x14(%ebp)
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	89 c2                	mov    %eax,%edx
  800641:	c1 fa 1f             	sar    $0x1f,%edx
  800644:	31 d0                	xor    %edx,%eax
  800646:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800648:	83 f8 14             	cmp    $0x14,%eax
  80064b:	7f 0f                	jg     80065c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80064d:	8b 14 85 40 51 80 00 	mov    0x805140(,%eax,4),%edx
  800654:	85 d2                	test   %edx,%edx
  800656:	0f 85 35 02 00 00    	jne    800891 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80065c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800660:	c7 44 24 08 4f 4e 80 	movl   $0x804e4f,0x8(%esp)
  800667:	00 
  800668:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80066c:	8b 75 08             	mov    0x8(%ebp),%esi
  80066f:	89 34 24             	mov    %esi,(%esp)
  800672:	e8 48 fe ff ff       	call   8004bf <_Z8printfmtPFviPvES_PKcz>
  800677:	e9 77 fe ff ff       	jmp    8004f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80067c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800682:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	89 55 14             	mov    %edx,0x14(%ebp)
  80068e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800690:	85 db                	test   %ebx,%ebx
  800692:	ba 48 4e 80 00       	mov    $0x804e48,%edx
  800697:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80069a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80069e:	7e 72                	jle    800712 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8006a0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8006a4:	74 6c                	je     800712 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006aa:	89 1c 24             	mov    %ebx,(%esp)
  8006ad:	e8 a9 02 00 00       	call   80095b <_Z7strnlenPKcj>
  8006b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b5:	29 c2                	sub    %eax,%edx
  8006b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006ba:	85 d2                	test   %edx,%edx
  8006bc:	7e 54                	jle    800712 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  8006be:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  8006c2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8006c5:	89 d3                	mov    %edx,%ebx
  8006c7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006ca:	89 c6                	mov    %eax,%esi
  8006cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d0:	89 34 24             	mov    %esi,(%esp)
  8006d3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d6:	83 eb 01             	sub    $0x1,%ebx
  8006d9:	85 db                	test   %ebx,%ebx
  8006db:	7f ef                	jg     8006cc <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  8006dd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8006e0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8006e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006ea:	eb 26                	jmp    800712 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006ec:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006ef:	83 fa 5e             	cmp    $0x5e,%edx
  8006f2:	76 10                	jbe    800704 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  8006f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006ff:	ff 55 08             	call   *0x8(%ebp)
  800702:	eb 0a                	jmp    80070e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800704:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800708:	89 04 24             	mov    %eax,(%esp)
  80070b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800712:	0f be 03             	movsbl (%ebx),%eax
  800715:	83 c3 01             	add    $0x1,%ebx
  800718:	85 c0                	test   %eax,%eax
  80071a:	74 11                	je     80072d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80071c:	85 f6                	test   %esi,%esi
  80071e:	78 05                	js     800725 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800720:	83 ee 01             	sub    $0x1,%esi
  800723:	78 0d                	js     800732 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800725:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800729:	75 c1                	jne    8006ec <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80072b:	eb d7                	jmp    800704 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80072d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800730:	eb 03                	jmp    800735 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800735:	85 c0                	test   %eax,%eax
  800737:	0f 8e b6 fd ff ff    	jle    8004f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80073d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800740:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800743:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800747:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80074e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800750:	83 eb 01             	sub    $0x1,%ebx
  800753:	85 db                	test   %ebx,%ebx
  800755:	7f ec                	jg     800743 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800757:	e9 97 fd ff ff       	jmp    8004f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80075c:	83 f9 01             	cmp    $0x1,%ecx
  80075f:	90                   	nop
  800760:	7e 10                	jle    800772 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8d 50 08             	lea    0x8(%eax),%edx
  800768:	89 55 14             	mov    %edx,0x14(%ebp)
  80076b:	8b 18                	mov    (%eax),%ebx
  80076d:	8b 70 04             	mov    0x4(%eax),%esi
  800770:	eb 26                	jmp    800798 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800772:	85 c9                	test   %ecx,%ecx
  800774:	74 12                	je     800788 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 50 04             	lea    0x4(%eax),%edx
  80077c:	89 55 14             	mov    %edx,0x14(%ebp)
  80077f:	8b 18                	mov    (%eax),%ebx
  800781:	89 de                	mov    %ebx,%esi
  800783:	c1 fe 1f             	sar    $0x1f,%esi
  800786:	eb 10                	jmp    800798 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 50 04             	lea    0x4(%eax),%edx
  80078e:	89 55 14             	mov    %edx,0x14(%ebp)
  800791:	8b 18                	mov    (%eax),%ebx
  800793:	89 de                	mov    %ebx,%esi
  800795:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800798:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80079d:	85 f6                	test   %esi,%esi
  80079f:	0f 89 8c 00 00 00    	jns    800831 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8007a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007b0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007b3:	f7 db                	neg    %ebx
  8007b5:	83 d6 00             	adc    $0x0,%esi
  8007b8:	f7 de                	neg    %esi
			}
			base = 10;
  8007ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bf:	eb 70                	jmp    800831 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c1:	89 ca                	mov    %ecx,%edx
  8007c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c6:	e8 9d fc ff ff       	call   800468 <_ZL7getuintPPci>
  8007cb:	89 c3                	mov    %eax,%ebx
  8007cd:	89 d6                	mov    %edx,%esi
			base = 10;
  8007cf:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8007d4:	eb 5b                	jmp    800831 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007d6:	89 ca                	mov    %ecx,%edx
  8007d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007db:	e8 88 fc ff ff       	call   800468 <_ZL7getuintPPci>
  8007e0:	89 c3                	mov    %eax,%ebx
  8007e2:	89 d6                	mov    %edx,%esi
			base = 8;
  8007e4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8007e9:	eb 46                	jmp    800831 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8007eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ef:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007f6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007fd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800804:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	89 55 14             	mov    %edx,0x14(%ebp)
  800810:	8b 18                	mov    (%eax),%ebx
  800812:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800817:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80081c:	eb 13                	jmp    800831 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80081e:	89 ca                	mov    %ecx,%edx
  800820:	8d 45 14             	lea    0x14(%ebp),%eax
  800823:	e8 40 fc ff ff       	call   800468 <_ZL7getuintPPci>
  800828:	89 c3                	mov    %eax,%ebx
  80082a:	89 d6                	mov    %edx,%esi
			base = 16;
  80082c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800831:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800835:	89 54 24 10          	mov    %edx,0x10(%esp)
  800839:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80083c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800840:	89 44 24 08          	mov    %eax,0x8(%esp)
  800844:	89 1c 24             	mov    %ebx,(%esp)
  800847:	89 74 24 04          	mov    %esi,0x4(%esp)
  80084b:	89 fa                	mov    %edi,%edx
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	e8 2b fb ff ff       	call   800380 <_ZL8printnumPFviPvES_yjii>
			break;
  800855:	e9 99 fc ff ff       	jmp    8004f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80085e:	89 14 24             	mov    %edx,(%esp)
  800861:	ff 55 08             	call   *0x8(%ebp)
			break;
  800864:	e9 8a fc ff ff       	jmp    8004f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800869:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80086d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800874:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800877:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80087a:	89 d8                	mov    %ebx,%eax
  80087c:	eb 02                	jmp    800880 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80087e:	89 d0                	mov    %edx,%eax
  800880:	8d 50 ff             	lea    -0x1(%eax),%edx
  800883:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800887:	75 f5                	jne    80087e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800889:	89 45 10             	mov    %eax,0x10(%ebp)
  80088c:	e9 62 fc ff ff       	jmp    8004f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800891:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800895:	c7 44 24 08 78 52 80 	movl   $0x805278,0x8(%esp)
  80089c:	00 
  80089d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a4:	89 34 24             	mov    %esi,(%esp)
  8008a7:	e8 13 fc ff ff       	call   8004bf <_Z8printfmtPFviPvES_PKcz>
  8008ac:	e9 42 fc ff ff       	jmp    8004f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008b1:	83 c4 3c             	add    $0x3c,%esp
  8008b4:	5b                   	pop    %ebx
  8008b5:	5e                   	pop    %esi
  8008b6:	5f                   	pop    %edi
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	83 ec 28             	sub    $0x28,%esp
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8008cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008cf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008d3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  8008d6:	85 c0                	test   %eax,%eax
  8008d8:	74 30                	je     80090a <_Z9vsnprintfPciPKcS_+0x51>
  8008da:	85 d2                	test   %edx,%edx
  8008dc:	7e 2c                	jle    80090a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f3:	c7 04 24 a2 04 80 00 	movl   $0x8004a2,(%esp)
  8008fa:	e8 e8 fb ff ff       	call   8004e7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  8008ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800902:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800908:	eb 05                	jmp    80090f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80090a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80090f:	c9                   	leave  
  800910:	c3                   	ret    

00800911 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800917:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80091a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	89 44 24 08          	mov    %eax,0x8(%esp)
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	89 04 24             	mov    %eax,(%esp)
  800932:	e8 82 ff ff ff       	call   8008b9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800937:	c9                   	leave  
  800938:	c3                   	ret    
  800939:	00 00                	add    %al,(%eax)
  80093b:	00 00                	add    %al,(%eax)
  80093d:	00 00                	add    %al,(%eax)
	...

00800940 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	80 3a 00             	cmpb   $0x0,(%edx)
  80094e:	74 09                	je     800959 <_Z6strlenPKc+0x19>
		n++;
  800950:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800953:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800957:	75 f7                	jne    800950 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800961:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
  800969:	39 c2                	cmp    %eax,%edx
  80096b:	74 0b                	je     800978 <_Z7strnlenPKcj+0x1d>
  80096d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800971:	74 05                	je     800978 <_Z7strnlenPKcj+0x1d>
		n++;
  800973:	83 c0 01             	add    $0x1,%eax
  800976:	eb f1                	jmp    800969 <_Z7strnlenPKcj+0xe>
	return n;
}
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	53                   	push   %ebx
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
  800989:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80098d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800990:	83 c2 01             	add    $0x1,%edx
  800993:	84 c9                	test   %cl,%cl
  800995:	75 f2                	jne    800989 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800997:	5b                   	pop    %ebx
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	56                   	push   %esi
  80099e:	53                   	push   %ebx
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8009a8:	85 f6                	test   %esi,%esi
  8009aa:	74 18                	je     8009c4 <_Z7strncpyPcPKcj+0x2a>
  8009ac:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009b1:	0f b6 1a             	movzbl (%edx),%ebx
  8009b4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b7:	80 3a 01             	cmpb   $0x1,(%edx)
  8009ba:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8009bd:	83 c1 01             	add    $0x1,%ecx
  8009c0:	39 ce                	cmp    %ecx,%esi
  8009c2:	77 ed                	ja     8009b1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009c4:	5b                   	pop    %ebx
  8009c5:	5e                   	pop    %esi
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  8009d6:	89 f0                	mov    %esi,%eax
  8009d8:	85 d2                	test   %edx,%edx
  8009da:	74 17                	je     8009f3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  8009dc:	83 ea 01             	sub    $0x1,%edx
  8009df:	74 18                	je     8009f9 <_Z7strlcpyPcPKcj+0x31>
  8009e1:	80 39 00             	cmpb   $0x0,(%ecx)
  8009e4:	74 17                	je     8009fd <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8009e6:	0f b6 19             	movzbl (%ecx),%ebx
  8009e9:	88 18                	mov    %bl,(%eax)
  8009eb:	83 c0 01             	add    $0x1,%eax
  8009ee:	83 c1 01             	add    $0x1,%ecx
  8009f1:	eb e9                	jmp    8009dc <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  8009f3:	29 f0                	sub    %esi,%eax
}
  8009f5:	5b                   	pop    %ebx
  8009f6:	5e                   	pop    %esi
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f9:	89 c2                	mov    %eax,%edx
  8009fb:	eb 02                	jmp    8009ff <_Z7strlcpyPcPKcj+0x37>
  8009fd:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009ff:	c6 02 00             	movb   $0x0,(%edx)
  800a02:	eb ef                	jmp    8009f3 <_Z7strlcpyPcPKcj+0x2b>

00800a04 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a0d:	0f b6 01             	movzbl (%ecx),%eax
  800a10:	84 c0                	test   %al,%al
  800a12:	74 0c                	je     800a20 <_Z6strcmpPKcS0_+0x1c>
  800a14:	3a 02                	cmp    (%edx),%al
  800a16:	75 08                	jne    800a20 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800a18:	83 c1 01             	add    $0x1,%ecx
  800a1b:	83 c2 01             	add    $0x1,%edx
  800a1e:	eb ed                	jmp    800a0d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800a20:	0f b6 c0             	movzbl %al,%eax
  800a23:	0f b6 12             	movzbl (%edx),%edx
  800a26:	29 d0                	sub    %edx,%eax
}
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	53                   	push   %ebx
  800a2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a34:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800a37:	85 d2                	test   %edx,%edx
  800a39:	74 16                	je     800a51 <_Z7strncmpPKcS0_j+0x27>
  800a3b:	0f b6 01             	movzbl (%ecx),%eax
  800a3e:	84 c0                	test   %al,%al
  800a40:	74 17                	je     800a59 <_Z7strncmpPKcS0_j+0x2f>
  800a42:	3a 03                	cmp    (%ebx),%al
  800a44:	75 13                	jne    800a59 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800a46:	83 ea 01             	sub    $0x1,%edx
  800a49:	83 c1 01             	add    $0x1,%ecx
  800a4c:	83 c3 01             	add    $0x1,%ebx
  800a4f:	eb e6                	jmp    800a37 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800a51:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800a56:	5b                   	pop    %ebx
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800a59:	0f b6 01             	movzbl (%ecx),%eax
  800a5c:	0f b6 13             	movzbl (%ebx),%edx
  800a5f:	29 d0                	sub    %edx,%eax
  800a61:	eb f3                	jmp    800a56 <_Z7strncmpPKcS0_j+0x2c>

00800a63 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6d:	0f b6 10             	movzbl (%eax),%edx
  800a70:	84 d2                	test   %dl,%dl
  800a72:	74 1f                	je     800a93 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800a74:	38 ca                	cmp    %cl,%dl
  800a76:	75 0a                	jne    800a82 <_Z6strchrPKcc+0x1f>
  800a78:	eb 1e                	jmp    800a98 <_Z6strchrPKcc+0x35>
  800a7a:	38 ca                	cmp    %cl,%dl
  800a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a80:	74 16                	je     800a98 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a82:	83 c0 01             	add    $0x1,%eax
  800a85:	0f b6 10             	movzbl (%eax),%edx
  800a88:	84 d2                	test   %dl,%dl
  800a8a:	75 ee                	jne    800a7a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a91:	eb 05                	jmp    800a98 <_Z6strchrPKcc+0x35>
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa4:	0f b6 10             	movzbl (%eax),%edx
  800aa7:	84 d2                	test   %dl,%dl
  800aa9:	74 14                	je     800abf <_Z7strfindPKcc+0x25>
		if (*s == c)
  800aab:	38 ca                	cmp    %cl,%dl
  800aad:	75 06                	jne    800ab5 <_Z7strfindPKcc+0x1b>
  800aaf:	eb 0e                	jmp    800abf <_Z7strfindPKcc+0x25>
  800ab1:	38 ca                	cmp    %cl,%dl
  800ab3:	74 0a                	je     800abf <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ab5:	83 c0 01             	add    $0x1,%eax
  800ab8:	0f b6 10             	movzbl (%eax),%edx
  800abb:	84 d2                	test   %dl,%dl
  800abd:	75 f2                	jne    800ab1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	83 ec 0c             	sub    $0xc,%esp
  800ac7:	89 1c 24             	mov    %ebx,(%esp)
  800aca:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ace:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ad2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800adb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ae1:	75 25                	jne    800b08 <memset+0x47>
  800ae3:	f6 c1 03             	test   $0x3,%cl
  800ae6:	75 20                	jne    800b08 <memset+0x47>
		c &= 0xFF;
  800ae8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aeb:	89 d3                	mov    %edx,%ebx
  800aed:	c1 e3 08             	shl    $0x8,%ebx
  800af0:	89 d6                	mov    %edx,%esi
  800af2:	c1 e6 18             	shl    $0x18,%esi
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	c1 e0 10             	shl    $0x10,%eax
  800afa:	09 f0                	or     %esi,%eax
  800afc:	09 d0                	or     %edx,%eax
  800afe:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800b00:	c1 e9 02             	shr    $0x2,%ecx
  800b03:	fc                   	cld    
  800b04:	f3 ab                	rep stos %eax,%es:(%edi)
  800b06:	eb 03                	jmp    800b0b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800b08:	fc                   	cld    
  800b09:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800b0b:	89 f8                	mov    %edi,%eax
  800b0d:	8b 1c 24             	mov    (%esp),%ebx
  800b10:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b18:	89 ec                	mov    %ebp,%esp
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	89 34 24             	mov    %esi,(%esp)
  800b25:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800b32:	39 c6                	cmp    %eax,%esi
  800b34:	73 36                	jae    800b6c <memmove+0x50>
  800b36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b39:	39 d0                	cmp    %edx,%eax
  800b3b:	73 2f                	jae    800b6c <memmove+0x50>
		s += n;
		d += n;
  800b3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b40:	f6 c2 03             	test   $0x3,%dl
  800b43:	75 1b                	jne    800b60 <memmove+0x44>
  800b45:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b4b:	75 13                	jne    800b60 <memmove+0x44>
  800b4d:	f6 c1 03             	test   $0x3,%cl
  800b50:	75 0e                	jne    800b60 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b52:	83 ef 04             	sub    $0x4,%edi
  800b55:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b58:	c1 e9 02             	shr    $0x2,%ecx
  800b5b:	fd                   	std    
  800b5c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5e:	eb 09                	jmp    800b69 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b60:	83 ef 01             	sub    $0x1,%edi
  800b63:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b66:	fd                   	std    
  800b67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b69:	fc                   	cld    
  800b6a:	eb 20                	jmp    800b8c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b6c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b72:	75 13                	jne    800b87 <memmove+0x6b>
  800b74:	a8 03                	test   $0x3,%al
  800b76:	75 0f                	jne    800b87 <memmove+0x6b>
  800b78:	f6 c1 03             	test   $0x3,%cl
  800b7b:	75 0a                	jne    800b87 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b7d:	c1 e9 02             	shr    $0x2,%ecx
  800b80:	89 c7                	mov    %eax,%edi
  800b82:	fc                   	cld    
  800b83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b85:	eb 05                	jmp    800b8c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b87:	89 c7                	mov    %eax,%edi
  800b89:	fc                   	cld    
  800b8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800b8c:	8b 34 24             	mov    (%esp),%esi
  800b8f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b93:	89 ec                	mov    %ebp,%esp
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	89 34 24             	mov    %esi,(%esp)
  800ba0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800baa:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800bad:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bb3:	75 13                	jne    800bc8 <memcpy+0x31>
  800bb5:	a8 03                	test   $0x3,%al
  800bb7:	75 0f                	jne    800bc8 <memcpy+0x31>
  800bb9:	f6 c1 03             	test   $0x3,%cl
  800bbc:	75 0a                	jne    800bc8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bbe:	c1 e9 02             	shr    $0x2,%ecx
  800bc1:	89 c7                	mov    %eax,%edi
  800bc3:	fc                   	cld    
  800bc4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc6:	eb 05                	jmp    800bcd <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800bc8:	89 c7                	mov    %eax,%edi
  800bca:	fc                   	cld    
  800bcb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800bcd:	8b 34 24             	mov    (%esp),%esi
  800bd0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bd4:	89 ec                	mov    %ebp,%esp
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
  800bde:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800be1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800be7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bec:	85 ff                	test   %edi,%edi
  800bee:	74 38                	je     800c28 <memcmp+0x50>
		if (*s1 != *s2)
  800bf0:	0f b6 03             	movzbl (%ebx),%eax
  800bf3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bf6:	83 ef 01             	sub    $0x1,%edi
  800bf9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800bfe:	38 c8                	cmp    %cl,%al
  800c00:	74 1d                	je     800c1f <memcmp+0x47>
  800c02:	eb 11                	jmp    800c15 <memcmp+0x3d>
  800c04:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c09:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800c0e:	83 c2 01             	add    $0x1,%edx
  800c11:	38 c8                	cmp    %cl,%al
  800c13:	74 0a                	je     800c1f <memcmp+0x47>
			return *s1 - *s2;
  800c15:	0f b6 c0             	movzbl %al,%eax
  800c18:	0f b6 c9             	movzbl %cl,%ecx
  800c1b:	29 c8                	sub    %ecx,%eax
  800c1d:	eb 09                	jmp    800c28 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800c1f:	39 fa                	cmp    %edi,%edx
  800c21:	75 e1                	jne    800c04 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	53                   	push   %ebx
  800c31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800c34:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800c36:	89 da                	mov    %ebx,%edx
  800c38:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800c3b:	39 d3                	cmp    %edx,%ebx
  800c3d:	73 15                	jae    800c54 <memfind+0x27>
		if (*s == (unsigned char) c)
  800c3f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c43:	38 0b                	cmp    %cl,(%ebx)
  800c45:	75 06                	jne    800c4d <memfind+0x20>
  800c47:	eb 0b                	jmp    800c54 <memfind+0x27>
  800c49:	38 08                	cmp    %cl,(%eax)
  800c4b:	74 07                	je     800c54 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800c4d:	83 c0 01             	add    $0x1,%eax
  800c50:	39 c2                	cmp    %eax,%edx
  800c52:	77 f5                	ja     800c49 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c54:	5b                   	pop    %ebx
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	57                   	push   %edi
  800c5b:	56                   	push   %esi
  800c5c:	53                   	push   %ebx
  800c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c63:	0f b6 02             	movzbl (%edx),%eax
  800c66:	3c 20                	cmp    $0x20,%al
  800c68:	74 04                	je     800c6e <_Z6strtolPKcPPci+0x17>
  800c6a:	3c 09                	cmp    $0x9,%al
  800c6c:	75 0e                	jne    800c7c <_Z6strtolPKcPPci+0x25>
		s++;
  800c6e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c71:	0f b6 02             	movzbl (%edx),%eax
  800c74:	3c 20                	cmp    $0x20,%al
  800c76:	74 f6                	je     800c6e <_Z6strtolPKcPPci+0x17>
  800c78:	3c 09                	cmp    $0x9,%al
  800c7a:	74 f2                	je     800c6e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c7c:	3c 2b                	cmp    $0x2b,%al
  800c7e:	75 0a                	jne    800c8a <_Z6strtolPKcPPci+0x33>
		s++;
  800c80:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c83:	bf 00 00 00 00       	mov    $0x0,%edi
  800c88:	eb 10                	jmp    800c9a <_Z6strtolPKcPPci+0x43>
  800c8a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c8f:	3c 2d                	cmp    $0x2d,%al
  800c91:	75 07                	jne    800c9a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800c93:	83 c2 01             	add    $0x1,%edx
  800c96:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9a:	85 db                	test   %ebx,%ebx
  800c9c:	0f 94 c0             	sete   %al
  800c9f:	74 05                	je     800ca6 <_Z6strtolPKcPPci+0x4f>
  800ca1:	83 fb 10             	cmp    $0x10,%ebx
  800ca4:	75 15                	jne    800cbb <_Z6strtolPKcPPci+0x64>
  800ca6:	80 3a 30             	cmpb   $0x30,(%edx)
  800ca9:	75 10                	jne    800cbb <_Z6strtolPKcPPci+0x64>
  800cab:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800caf:	75 0a                	jne    800cbb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800cb1:	83 c2 02             	add    $0x2,%edx
  800cb4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cb9:	eb 13                	jmp    800cce <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800cbb:	84 c0                	test   %al,%al
  800cbd:	74 0f                	je     800cce <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cbf:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc4:	80 3a 30             	cmpb   $0x30,(%edx)
  800cc7:	75 05                	jne    800cce <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800cc9:	83 c2 01             	add    $0x1,%edx
  800ccc:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800cce:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cd5:	0f b6 0a             	movzbl (%edx),%ecx
  800cd8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cdb:	80 fb 09             	cmp    $0x9,%bl
  800cde:	77 08                	ja     800ce8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800ce0:	0f be c9             	movsbl %cl,%ecx
  800ce3:	83 e9 30             	sub    $0x30,%ecx
  800ce6:	eb 1e                	jmp    800d06 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800ce8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800ceb:	80 fb 19             	cmp    $0x19,%bl
  800cee:	77 08                	ja     800cf8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800cf0:	0f be c9             	movsbl %cl,%ecx
  800cf3:	83 e9 57             	sub    $0x57,%ecx
  800cf6:	eb 0e                	jmp    800d06 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800cf8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800cfb:	80 fb 19             	cmp    $0x19,%bl
  800cfe:	77 15                	ja     800d15 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800d00:	0f be c9             	movsbl %cl,%ecx
  800d03:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d06:	39 f1                	cmp    %esi,%ecx
  800d08:	7d 0f                	jge    800d19 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800d0a:	83 c2 01             	add    $0x1,%edx
  800d0d:	0f af c6             	imul   %esi,%eax
  800d10:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800d13:	eb c0                	jmp    800cd5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800d15:	89 c1                	mov    %eax,%ecx
  800d17:	eb 02                	jmp    800d1b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d19:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d1f:	74 05                	je     800d26 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800d21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d24:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d26:	89 ca                	mov    %ecx,%edx
  800d28:	f7 da                	neg    %edx
  800d2a:	85 ff                	test   %edi,%edi
  800d2c:	0f 45 c2             	cmovne %edx,%eax
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	89 1c 24             	mov    %ebx,(%esp)
  800d3d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d41:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d45:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	89 c3                	mov    %eax,%ebx
  800d52:	89 c7                	mov    %eax,%edi
  800d54:	89 c6                	mov    %eax,%esi
  800d56:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d58:	8b 1c 24             	mov    (%esp),%ebx
  800d5b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d5f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d63:	89 ec                	mov    %ebp,%esp
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 0c             	sub    $0xc,%esp
  800d6d:	89 1c 24             	mov    %ebx,(%esp)
  800d70:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d74:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d78:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7d:	b8 01 00 00 00       	mov    $0x1,%eax
  800d82:	89 d1                	mov    %edx,%ecx
  800d84:	89 d3                	mov    %edx,%ebx
  800d86:	89 d7                	mov    %edx,%edi
  800d88:	89 d6                	mov    %edx,%esi
  800d8a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d8c:	8b 1c 24             	mov    (%esp),%ebx
  800d8f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d93:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d97:	89 ec                	mov    %ebp,%esp
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 38             	sub    $0x38,%esp
  800da1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800da4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800da7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800daa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800daf:	b8 03 00 00 00       	mov    $0x3,%eax
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	89 cb                	mov    %ecx,%ebx
  800db9:	89 cf                	mov    %ecx,%edi
  800dbb:	89 ce                	mov    %ecx,%esi
  800dbd:	cd 30                	int    $0x30

	if(check && ret > 0)
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	7e 28                	jle    800deb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800dce:	00 
  800dcf:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  800dd6:	00 
  800dd7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dde:	00 
  800ddf:	c7 04 24 b1 51 80 00 	movl   $0x8051b1,(%esp)
  800de6:	e8 51 f4 ff ff       	call   80023c <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800deb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800df1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800df4:	89 ec                	mov    %ebp,%esp
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 0c             	sub    $0xc,%esp
  800dfe:	89 1c 24             	mov    %ebx,(%esp)
  800e01:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e05:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e09:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0e:	b8 02 00 00 00       	mov    $0x2,%eax
  800e13:	89 d1                	mov    %edx,%ecx
  800e15:	89 d3                	mov    %edx,%ebx
  800e17:	89 d7                	mov    %edx,%edi
  800e19:	89 d6                	mov    %edx,%esi
  800e1b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e1d:	8b 1c 24             	mov    (%esp),%ebx
  800e20:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e28:	89 ec                	mov    %ebp,%esp
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	89 1c 24             	mov    %ebx,(%esp)
  800e35:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e39:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e42:	b8 04 00 00 00       	mov    $0x4,%eax
  800e47:	89 d1                	mov    %edx,%ecx
  800e49:	89 d3                	mov    %edx,%ebx
  800e4b:	89 d7                	mov    %edx,%edi
  800e4d:	89 d6                	mov    %edx,%esi
  800e4f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e51:	8b 1c 24             	mov    (%esp),%ebx
  800e54:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e5c:	89 ec                	mov    %ebp,%esp
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 38             	sub    $0x38,%esp
  800e66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e6f:	be 00 00 00 00       	mov    $0x0,%esi
  800e74:	b8 08 00 00 00       	mov    $0x8,%eax
  800e79:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	89 f7                	mov    %esi,%edi
  800e84:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e86:	85 c0                	test   %eax,%eax
  800e88:	7e 28                	jle    800eb2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e95:	00 
  800e96:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  800e9d:	00 
  800e9e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea5:	00 
  800ea6:	c7 04 24 b1 51 80 00 	movl   $0x8051b1,(%esp)
  800ead:	e8 8a f3 ff ff       	call   80023c <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eb2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eb5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eb8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ebb:	89 ec                	mov    %ebp,%esp
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    

00800ebf <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	83 ec 38             	sub    $0x38,%esp
  800ec5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ec8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ecb:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ece:	b8 09 00 00 00       	mov    $0x9,%eax
  800ed3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	7e 28                	jle    800f10 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eec:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  800efb:	00 
  800efc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f03:	00 
  800f04:	c7 04 24 b1 51 80 00 	movl   $0x8051b1,(%esp)
  800f0b:	e8 2c f3 ff ff       	call   80023c <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f10:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f13:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f16:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f19:	89 ec                	mov    %ebp,%esp
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    

00800f1d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	83 ec 38             	sub    $0x38,%esp
  800f23:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f26:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f29:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	89 df                	mov    %ebx,%edi
  800f3e:	89 de                	mov    %ebx,%esi
  800f40:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f42:	85 c0                	test   %eax,%eax
  800f44:	7e 28                	jle    800f6e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f46:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f4a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f51:	00 
  800f52:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  800f59:	00 
  800f5a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f61:	00 
  800f62:	c7 04 24 b1 51 80 00 	movl   $0x8051b1,(%esp)
  800f69:	e8 ce f2 ff ff       	call   80023c <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f6e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f71:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f74:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f77:	89 ec                	mov    %ebp,%esp
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 38             	sub    $0x38,%esp
  800f81:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f84:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f87:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f97:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9a:	89 df                	mov    %ebx,%edi
  800f9c:	89 de                	mov    %ebx,%esi
  800f9e:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	7e 28                	jle    800fcc <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800faf:	00 
  800fb0:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  800fb7:	00 
  800fb8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fbf:	00 
  800fc0:	c7 04 24 b1 51 80 00 	movl   $0x8051b1,(%esp)
  800fc7:	e8 70 f2 ff ff       	call   80023c <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fcc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fcf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fd2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fd5:	89 ec                	mov    %ebp,%esp
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 38             	sub    $0x38,%esp
  800fdf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fe2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fe5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fe8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fed:	b8 06 00 00 00       	mov    $0x6,%eax
  800ff2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	89 df                	mov    %ebx,%edi
  800ffa:	89 de                	mov    %ebx,%esi
  800ffc:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ffe:	85 c0                	test   %eax,%eax
  801000:	7e 28                	jle    80102a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801002:	89 44 24 10          	mov    %eax,0x10(%esp)
  801006:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80100d:	00 
  80100e:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  801015:	00 
  801016:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80101d:	00 
  80101e:	c7 04 24 b1 51 80 00 	movl   $0x8051b1,(%esp)
  801025:	e8 12 f2 ff ff       	call   80023c <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80102a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80102d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801030:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801033:	89 ec                	mov    %ebp,%esp
  801035:	5d                   	pop    %ebp
  801036:	c3                   	ret    

00801037 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 38             	sub    $0x38,%esp
  80103d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801040:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801043:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	89 df                	mov    %ebx,%edi
  801058:	89 de                	mov    %ebx,%esi
  80105a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	7e 28                	jle    801088 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801060:	89 44 24 10          	mov    %eax,0x10(%esp)
  801064:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80106b:	00 
  80106c:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  801073:	00 
  801074:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80107b:	00 
  80107c:	c7 04 24 b1 51 80 00 	movl   $0x8051b1,(%esp)
  801083:	e8 b4 f1 ff ff       	call   80023c <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801088:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80108b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80108e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801091:	89 ec                	mov    %ebp,%esp
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 38             	sub    $0x38,%esp
  80109b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80109e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b4:	89 df                	mov    %ebx,%edi
  8010b6:	89 de                	mov    %ebx,%esi
  8010b8:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	7e 28                	jle    8010e6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  8010c9:	00 
  8010ca:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  8010d1:	00 
  8010d2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d9:	00 
  8010da:	c7 04 24 b1 51 80 00 	movl   $0x8051b1,(%esp)
  8010e1:	e8 56 f1 ff ff       	call   80023c <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010e6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ef:	89 ec                	mov    %ebp,%esp
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 0c             	sub    $0xc,%esp
  8010f9:	89 1c 24             	mov    %ebx,(%esp)
  8010fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801100:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801104:	be 00 00 00 00       	mov    $0x0,%esi
  801109:	b8 0d 00 00 00       	mov    $0xd,%eax
  80110e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801111:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801114:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80111c:	8b 1c 24             	mov    (%esp),%ebx
  80111f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801123:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801127:	89 ec                	mov    %ebp,%esp
  801129:	5d                   	pop    %ebp
  80112a:	c3                   	ret    

0080112b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	83 ec 38             	sub    $0x38,%esp
  801131:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801134:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801137:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80113a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801144:	8b 55 08             	mov    0x8(%ebp),%edx
  801147:	89 cb                	mov    %ecx,%ebx
  801149:	89 cf                	mov    %ecx,%edi
  80114b:	89 ce                	mov    %ecx,%esi
  80114d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80114f:	85 c0                	test   %eax,%eax
  801151:	7e 28                	jle    80117b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801153:	89 44 24 10          	mov    %eax,0x10(%esp)
  801157:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80115e:	00 
  80115f:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  801166:	00 
  801167:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80116e:	00 
  80116f:	c7 04 24 b1 51 80 00 	movl   $0x8051b1,(%esp)
  801176:	e8 c1 f0 ff ff       	call   80023c <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80117b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80117e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801181:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801184:	89 ec                	mov    %ebp,%esp
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	89 1c 24             	mov    %ebx,(%esp)
  801191:	89 74 24 04          	mov    %esi,0x4(%esp)
  801195:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801199:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119e:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a9:	89 df                	mov    %ebx,%edi
  8011ab:	89 de                	mov    %ebx,%esi
  8011ad:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8011af:	8b 1c 24             	mov    (%esp),%ebx
  8011b2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011b6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ba:	89 ec                	mov    %ebp,%esp
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 0c             	sub    $0xc,%esp
  8011c4:	89 1c 24             	mov    %ebx,(%esp)
  8011c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011cb:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d4:	b8 11 00 00 00       	mov    $0x11,%eax
  8011d9:	89 d1                	mov    %edx,%ecx
  8011db:	89 d3                	mov    %edx,%ebx
  8011dd:	89 d7                	mov    %edx,%edi
  8011df:	89 d6                	mov    %edx,%esi
  8011e1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011e3:	8b 1c 24             	mov    (%esp),%ebx
  8011e6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011ea:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ee:	89 ec                	mov    %ebp,%esp
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    

008011f2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	89 1c 24             	mov    %ebx,(%esp)
  8011fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ff:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801203:	bb 00 00 00 00       	mov    $0x0,%ebx
  801208:	b8 12 00 00 00       	mov    $0x12,%eax
  80120d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801210:	8b 55 08             	mov    0x8(%ebp),%edx
  801213:	89 df                	mov    %ebx,%edi
  801215:	89 de                	mov    %ebx,%esi
  801217:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801219:	8b 1c 24             	mov    (%esp),%ebx
  80121c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801220:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801224:	89 ec                	mov    %ebp,%esp
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    

00801228 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	83 ec 0c             	sub    $0xc,%esp
  80122e:	89 1c 24             	mov    %ebx,(%esp)
  801231:	89 74 24 04          	mov    %esi,0x4(%esp)
  801235:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801239:	b9 00 00 00 00       	mov    $0x0,%ecx
  80123e:	b8 13 00 00 00       	mov    $0x13,%eax
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	89 cb                	mov    %ecx,%ebx
  801248:	89 cf                	mov    %ecx,%edi
  80124a:	89 ce                	mov    %ecx,%esi
  80124c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80124e:	8b 1c 24             	mov    (%esp),%ebx
  801251:	8b 74 24 04          	mov    0x4(%esp),%esi
  801255:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801259:	89 ec                	mov    %ebp,%esp
  80125b:	5d                   	pop    %ebp
  80125c:	c3                   	ret    

0080125d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	89 1c 24             	mov    %ebx,(%esp)
  801266:	89 74 24 04          	mov    %esi,0x4(%esp)
  80126a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80126e:	b8 10 00 00 00       	mov    $0x10,%eax
  801273:	8b 75 18             	mov    0x18(%ebp),%esi
  801276:	8b 7d 14             	mov    0x14(%ebp),%edi
  801279:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80127c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127f:	8b 55 08             	mov    0x8(%ebp),%edx
  801282:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801284:	8b 1c 24             	mov    (%esp),%ebx
  801287:	8b 74 24 04          	mov    0x4(%esp),%esi
  80128b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80128f:	89 ec                	mov    %ebp,%esp
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    
	...

00801294 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	83 ec 38             	sub    $0x38,%esp
  80129a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80129d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012a0:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  8012a3:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  8012aa:	f6 c7 04             	test   $0x4,%bh
  8012ad:	74 31                	je     8012e0 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  8012af:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  8012b6:	c1 e2 0c             	shl    $0xc,%edx
  8012b9:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8012bf:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8012c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d6:	e8 e4 fb ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
        return r;
  8012db:	e9 8c 00 00 00       	jmp    80136c <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  8012e0:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  8012e7:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  8012ec:	f7 c6 00 08 00 00    	test   $0x800,%esi
  8012f2:	75 2a                	jne    80131e <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  8012f4:	84 c9                	test   %cl,%cl
  8012f6:	74 0f                	je     801307 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  8012f8:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  8012ff:	83 e3 02             	and    $0x2,%ebx
  801302:	80 cf 02             	or     $0x2,%bh
  801305:	eb 17                	jmp    80131e <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  801307:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  80130e:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  801311:	83 f9 01             	cmp    $0x1,%ecx
  801314:	19 db                	sbb    %ebx,%ebx
  801316:	f7 d3                	not    %ebx
  801318:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80131e:	89 df                	mov    %ebx,%edi
  801320:	83 cf 05             	or     $0x5,%edi
  801323:	89 d6                	mov    %edx,%esi
  801325:	c1 e6 0c             	shl    $0xc,%esi
  801328:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80132c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801330:	89 44 24 08          	mov    %eax,0x8(%esp)
  801334:	89 74 24 04          	mov    %esi,0x4(%esp)
  801338:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133f:	e8 7b fb ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
  801344:	85 c0                	test   %eax,%eax
  801346:	75 24                	jne    80136c <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  801348:	85 db                	test   %ebx,%ebx
  80134a:	74 20                	je     80136c <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80134c:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801350:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801354:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80135b:	00 
  80135c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801360:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801367:	e8 53 fb ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  80136c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80136f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801372:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801375:	89 ec                	mov    %ebp,%esp
  801377:	5d                   	pop    %ebp
  801378:	c3                   	ret    

00801379 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	83 ec 28             	sub    $0x28,%esp
  80137f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801382:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801385:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  801388:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  80138a:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  80138e:	0f 84 ff 00 00 00    	je     801493 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  801394:	89 f0                	mov    %esi,%eax
  801396:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  801399:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8013a0:	f6 c4 08             	test   $0x8,%ah
  8013a3:	0f 84 ea 00 00 00    	je     801493 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8013a9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013b0:	00 
  8013b1:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013b8:	00 
  8013b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c0:	e8 9b fa ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	79 20                	jns    8013e9 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  8013c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013cd:	c7 44 24 08 6c 4d 80 	movl   $0x804d6c,0x8(%esp)
  8013d4:	00 
  8013d5:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8013dc:	00 
  8013dd:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  8013e4:	e8 53 ee ff ff       	call   80023c <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  8013e9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  8013ef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013f6:	00 
  8013f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013fb:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801402:	e8 90 f7 ff ff       	call   800b97 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801407:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80140e:	00 
  80140f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801413:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80141a:	00 
  80141b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801422:	00 
  801423:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80142a:	e8 90 fa ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
  80142f:	85 c0                	test   %eax,%eax
  801431:	79 20                	jns    801453 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  801433:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801437:	c7 44 24 08 ca 51 80 	movl   $0x8051ca,0x8(%esp)
  80143e:	00 
  80143f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801446:	00 
  801447:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  80144e:	e8 e9 ed ff ff       	call   80023c <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801453:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80145a:	00 
  80145b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801462:	e8 b6 fa ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
  801467:	85 c0                	test   %eax,%eax
  801469:	79 20                	jns    80148b <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  80146b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80146f:	c7 44 24 08 db 51 80 	movl   $0x8051db,0x8(%esp)
  801476:	00 
  801477:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80147e:	00 
  80147f:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  801486:	e8 b1 ed ff ff       	call   80023c <_Z6_panicPKciS0_z>
    resume(utf);
  80148b:	89 1c 24             	mov    %ebx,(%esp)
  80148e:	e8 3d 35 00 00       	call   8049d0 <resume>
}
  801493:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801496:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801499:	89 ec                	mov    %ebp,%esp
  80149b:	5d                   	pop    %ebp
  80149c:	c3                   	ret    

0080149d <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	57                   	push   %edi
  8014a1:	56                   	push   %esi
  8014a2:	53                   	push   %ebx
  8014a3:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  8014a6:	c7 04 24 79 13 80 00 	movl   $0x801379,(%esp)
  8014ad:	e8 49 34 00 00       	call   8048fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  8014b2:	be 07 00 00 00       	mov    $0x7,%esi
  8014b7:	89 f0                	mov    %esi,%eax
  8014b9:	cd 30                	int    $0x30
  8014bb:	89 c6                	mov    %eax,%esi
  8014bd:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	79 20                	jns    8014e3 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  8014c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014c7:	c7 44 24 08 ee 51 80 	movl   $0x8051ee,0x8(%esp)
  8014ce:	00 
  8014cf:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8014d6:	00 
  8014d7:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  8014de:	e8 59 ed ff ff       	call   80023c <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  8014e3:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	75 1c                	jne    801508 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  8014ec:	e8 07 f9 ff ff       	call   800df8 <_Z12sys_getenvidv>
  8014f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014f6:	6b c0 78             	imul   $0x78,%eax,%eax
  8014f9:	05 00 00 00 ef       	add    $0xef000000,%eax
  8014fe:	a3 00 70 80 00       	mov    %eax,0x807000
        return 0;
  801503:	e9 de 00 00 00       	jmp    8015e6 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  801508:	89 d8                	mov    %ebx,%eax
  80150a:	c1 f8 0a             	sar    $0xa,%eax
  80150d:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801514:	a8 01                	test   $0x1,%al
  801516:	75 08                	jne    801520 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  801518:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  80151e:	eb 19                	jmp    801539 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  801520:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801527:	a8 01                	test   $0x1,%al
  801529:	74 0e                	je     801539 <_Z4forkv+0x9c>
            duppage(envid, pn);
  80152b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801530:	89 da                	mov    %ebx,%edx
  801532:	89 f8                	mov    %edi,%eax
  801534:	e8 5b fd ff ff       	call   801294 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801539:	83 eb 01             	sub    $0x1,%ebx
  80153c:	79 ca                	jns    801508 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  80153e:	a1 00 70 80 00       	mov    0x807000,%eax
  801543:	8b 40 5c             	mov    0x5c(%eax),%eax
  801546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154a:	89 34 24             	mov    %esi,(%esp)
  80154d:	e8 43 fb ff ff       	call   801095 <_Z26sys_env_set_pgfault_upcalliPv>
  801552:	85 c0                	test   %eax,%eax
  801554:	74 20                	je     801576 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801556:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80155a:	c7 44 24 08 18 52 80 	movl   $0x805218,0x8(%esp)
  801561:	00 
  801562:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  801569:	00 
  80156a:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  801571:	e8 c6 ec ff ff       	call   80023c <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801576:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80157d:	00 
  80157e:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  801585:	ee 
  801586:	89 34 24             	mov    %esi,(%esp)
  801589:	e8 d2 f8 ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  80158e:	85 c0                	test   %eax,%eax
  801590:	79 20                	jns    8015b2 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  801592:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801596:	c7 44 24 08 6c 4d 80 	movl   $0x804d6c,0x8(%esp)
  80159d:	00 
  80159e:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  8015a5:	00 
  8015a6:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  8015ad:	e8 8a ec ff ff       	call   80023c <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8015b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015b9:	00 
  8015ba:	89 34 24             	mov    %esi,(%esp)
  8015bd:	e8 b9 f9 ff ff       	call   800f7b <_Z18sys_env_set_statusii>
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	79 20                	jns    8015e6 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  8015c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ca:	c7 44 24 08 fe 51 80 	movl   $0x8051fe,0x8(%esp)
  8015d1:	00 
  8015d2:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  8015d9:	00 
  8015da:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  8015e1:	e8 56 ec ff ff       	call   80023c <_Z6_panicPKciS0_z>

    return envid;
}
  8015e6:	89 f0                	mov    %esi,%eax
  8015e8:	83 c4 1c             	add    $0x1c,%esp
  8015eb:	5b                   	pop    %ebx
  8015ec:	5e                   	pop    %esi
  8015ed:	5f                   	pop    %edi
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	57                   	push   %edi
  8015f4:	56                   	push   %esi
  8015f5:	53                   	push   %ebx
  8015f6:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  8015f9:	c7 04 24 79 13 80 00 	movl   $0x801379,(%esp)
  801600:	e8 f6 32 00 00       	call   8048fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  801605:	be 07 00 00 00       	mov    $0x7,%esi
  80160a:	89 f0                	mov    %esi,%eax
  80160c:	cd 30                	int    $0x30
  80160e:	89 c6                	mov    %eax,%esi
  801610:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  801612:	85 c0                	test   %eax,%eax
  801614:	79 20                	jns    801636 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  801616:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80161a:	c7 44 24 08 ee 51 80 	movl   $0x8051ee,0x8(%esp)
  801621:	00 
  801622:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  801629:	00 
  80162a:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  801631:	e8 06 ec ff ff       	call   80023c <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  801636:	85 c0                	test   %eax,%eax
  801638:	0f 84 40 01 00 00    	je     80177e <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  80163e:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  801640:	c1 eb 0c             	shr    $0xc,%ebx
  801643:	83 eb 01             	sub    $0x1,%ebx
  801646:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  801649:	eb 31                	jmp    80167c <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  80164b:	89 d8                	mov    %ebx,%eax
  80164d:	c1 f8 0a             	sar    $0xa,%eax
  801650:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801657:	a8 01                	test   $0x1,%al
  801659:	75 08                	jne    801663 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  80165b:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801661:	eb 19                	jmp    80167c <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  801663:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  80166a:	a8 01                	test   $0x1,%al
  80166c:	74 0e                	je     80167c <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  80166e:	b9 01 00 00 00       	mov    $0x1,%ecx
  801673:	89 da                	mov    %ebx,%edx
  801675:	89 f8                	mov    %edi,%eax
  801677:	e8 18 fc ff ff       	call   801294 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  80167c:	83 eb 01             	sub    $0x1,%ebx
  80167f:	79 ca                	jns    80164b <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  801681:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  801688:	7f 3f                	jg     8016c9 <_Z5sforkv+0xd9>
  80168a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  80168d:	89 d8                	mov    %ebx,%eax
  80168f:	c1 f8 0a             	sar    $0xa,%eax
  801692:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801699:	a8 01                	test   $0x1,%al
  80169b:	75 08                	jne    8016a5 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  80169d:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8016a3:	eb 19                	jmp    8016be <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  8016a5:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8016ac:	a8 01                	test   $0x1,%al
  8016ae:	74 0e                	je     8016be <_Z5sforkv+0xce>
            duppage(envid, i);
  8016b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b5:	89 da                	mov    %ebx,%edx
  8016b7:	89 f8                	mov    %edi,%eax
  8016b9:	e8 d6 fb ff ff       	call   801294 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  8016be:	83 c3 01             	add    $0x1,%ebx
  8016c1:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  8016c7:	7e c4                	jle    80168d <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  8016c9:	e8 2a f7 ff ff       	call   800df8 <_Z12sys_getenvidv>
  8016ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016d3:	6b c0 78             	imul   $0x78,%eax,%eax
  8016d6:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  8016db:	8b 40 50             	mov    0x50(%eax),%eax
  8016de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e2:	89 34 24             	mov    %esi,(%esp)
  8016e5:	e8 ab f9 ff ff       	call   801095 <_Z26sys_env_set_pgfault_upcalliPv>
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	74 20                	je     80170e <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  8016ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016f2:	c7 44 24 08 18 52 80 	movl   $0x805218,0x8(%esp)
  8016f9:	00 
  8016fa:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801701:	00 
  801702:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  801709:	e8 2e eb ff ff       	call   80023c <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80170e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801715:	00 
  801716:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  80171d:	ee 
  80171e:	89 34 24             	mov    %esi,(%esp)
  801721:	e8 3a f7 ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  801726:	85 c0                	test   %eax,%eax
  801728:	79 20                	jns    80174a <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  80172a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80172e:	c7 44 24 08 6c 4d 80 	movl   $0x804d6c,0x8(%esp)
  801735:	00 
  801736:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  80173d:	00 
  80173e:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  801745:	e8 f2 ea ff ff       	call   80023c <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80174a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801751:	00 
  801752:	89 34 24             	mov    %esi,(%esp)
  801755:	e8 21 f8 ff ff       	call   800f7b <_Z18sys_env_set_statusii>
  80175a:	85 c0                	test   %eax,%eax
  80175c:	79 20                	jns    80177e <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  80175e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801762:	c7 44 24 08 fe 51 80 	movl   $0x8051fe,0x8(%esp)
  801769:	00 
  80176a:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  801771:	00 
  801772:	c7 04 24 bf 51 80 00 	movl   $0x8051bf,(%esp)
  801779:	e8 be ea ff ff       	call   80023c <_Z6_panicPKciS0_z>

    return envid;
    
}
  80177e:	89 f0                	mov    %esi,%eax
  801780:	83 c4 2c             	add    $0x2c,%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5f                   	pop    %edi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <_ZL24utemp_addr_to_stack_addrPv>:
//
// Shift an address from the UTEMP page to the corresponding value in the
// normal stack page (top address USTACKTOP).
//
static uintptr_t utemp_addr_to_stack_addr(void *ptr)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 18             	sub    $0x18,%esp
	uintptr_t addr = (uintptr_t) ptr;
	assert(ptr >= UTEMP && ptr < (char *) UTEMP + PGSIZE);
  80178e:	8d 90 00 00 c0 ff    	lea    -0x400000(%eax),%edx
  801794:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
  80179a:	76 24                	jbe    8017c0 <_ZL24utemp_addr_to_stack_addrPv+0x38>
  80179c:	c7 44 24 0c 38 52 80 	movl   $0x805238,0xc(%esp)
  8017a3:	00 
  8017a4:	c7 44 24 08 66 52 80 	movl   $0x805266,0x8(%esp)
  8017ab:	00 
  8017ac:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8017b3:	00 
  8017b4:	c7 04 24 7b 52 80 00 	movl   $0x80527b,(%esp)
  8017bb:	e8 7c ea ff ff       	call   80023c <_Z6_panicPKciS0_z>
	return USTACKTOP - PGSIZE + PGOFF(addr);
  8017c0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8017c5:	2d 00 30 00 11       	sub    $0x11003000,%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <_Z10spawn_readiPvijji>:
//

int
spawn_read(envid_t dst_env, void *va, int programid, size_t offset, 
           size_t len, int fs_read)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	57                   	push   %edi
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	83 ec 3c             	sub    $0x3c,%esp
  8017d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017d8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017db:	8b 45 14             	mov    0x14(%ebp),%eax
    int r;
    if(!fs_read)
  8017de:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017e2:	75 25                	jne    801809 <_Z10spawn_readiPvijji+0x3d>
        return sys_program_read(dst_env, va, programid, offset, len);
  8017e4:	8b 55 18             	mov    0x18(%ebp),%edx
  8017e7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017ef:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8017f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	89 04 24             	mov    %eax,(%esp)
  8017fd:	e8 5b fa ff ff       	call   80125d <_Z16sys_program_readiPvijj>
  801802:	89 c3                	mov    %eax,%ebx
  801804:	e9 7d 01 00 00       	jmp    801986 <_Z10spawn_readiPvijji+0x1ba>
    if((r = seek(programid, offset)))
  801809:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180d:	89 3c 24             	mov    %edi,(%esp)
  801810:	e8 46 0d 00 00       	call   80255b <_Z4seekii>
  801815:	89 c3                	mov    %eax,%ebx
  801817:	85 c0                	test   %eax,%eax
  801819:	0f 85 67 01 00 00    	jne    801986 <_Z10spawn_readiPvijji+0x1ba>
        return r;
    if((uint32_t)va % PGSIZE)
  80181f:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801822:	89 f2                	mov    %esi,%edx
  801824:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80182a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80182d:	0f 84 ab 00 00 00    	je     8018de <_Z10spawn_readiPvijji+0x112>
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
  801833:	a1 00 70 80 00       	mov    0x807000,%eax
  801838:	8b 40 04             	mov    0x4(%eax),%eax
  80183b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801842:	00 
  801843:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80184a:	00 
  80184b:	89 04 24             	mov    %eax,(%esp)
  80184e:	e8 0d f6 ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  801853:	85 c0                	test   %eax,%eax
  801855:	0f 85 29 01 00 00    	jne    801984 <_Z10spawn_readiPvijji+0x1b8>
        return sys_program_read(dst_env, va, programid, offset, len);
    if((r = seek(programid, offset)))
        return r;
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
  80185b:	66 b8 00 10          	mov    $0x1000,%ax
  80185f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
  801862:	3b 45 18             	cmp    0x18(%ebp),%eax
  801865:	0f 47 45 18          	cmova  0x18(%ebp),%eax
  801869:	89 45 dc             	mov    %eax,-0x24(%ebp)
            return r;
        if((r = readn(programid,(char *)UTEMP+(uint32_t)va%PGSIZE, bytes))<0 ||
  80186c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801873:	05 00 00 40 00       	add    $0x400000,%eax
  801878:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187c:	89 3c 24             	mov    %edi,(%esp)
  80187f:	e8 14 0c 00 00       	call   802498 <_Z5readniPvj>
  801884:	89 c6                	mov    %eax,%esi
  801886:	85 c0                	test   %eax,%eax
  801888:	78 39                	js     8018c3 <_Z10spawn_readiPvijji+0xf7>
  80188a:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801891:	00 
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
  801892:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801895:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
            return r;
        if((r = readn(programid,(char *)UTEMP+(uint32_t)va%PGSIZE, bytes))<0 ||
  80189a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018a5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8018ac:	00 
  8018ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018b4:	e8 06 f6 ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
  8018b9:	89 c6                	mov    %eax,%esi
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	0f 84 cd 00 00 00    	je     801990 <_Z10spawn_readiPvijji+0x1c4>
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
  8018c3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8018ca:	00 
  8018cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018d2:	e8 46 f6 ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
            return r;
  8018d7:	89 f3                	mov    %esi,%ebx
  8018d9:	e9 a8 00 00 00       	jmp    801986 <_Z10spawn_readiPvijji+0x1ba>
        sys_page_unmap(0, UTEMP);
        va = ROUNDUP(va, PGSIZE);
        len -= bytes;
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
  8018de:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8018e1:	8b 55 18             	mov    0x18(%ebp),%edx
  8018e4:	01 f2                	add    %esi,%edx
  8018e6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018e9:	39 f2                	cmp    %esi,%edx
  8018eb:	0f 86 95 00 00 00    	jbe    801986 <_Z10spawn_readiPvijji+0x1ba>
// Returns the new environment's ID on success, and < 0 on error.
// If an error occurs, any new environment is destroyed.
//

int
spawn_read(envid_t dst_env, void *va, int programid, size_t offset, 
  8018f1:	8b 75 18             	mov    0x18(%ebp),%esi
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
    {
        uint32_t bytes = (uint32_t)MIN((uint32_t)va + len - (uint32_t)i, (uint32_t)PGSIZE);
        if((r = sys_page_alloc(0, UTEMP, PTE_U | PTE_P|PTE_W)))
  8018f4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8018fb:	00 
  8018fc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801903:	00 
  801904:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80190b:	e8 50 f5 ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  801910:	89 c3                	mov    %eax,%ebx
  801912:	85 c0                	test   %eax,%eax
  801914:	75 70                	jne    801986 <_Z10spawn_readiPvijji+0x1ba>
            return r;
        if((r = readn(programid, UTEMP, bytes)) < 0 ||
  801916:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
  80191c:	b8 00 10 00 00       	mov    $0x1000,%eax
  801921:	0f 46 c6             	cmovbe %esi,%eax
  801924:	89 44 24 08          	mov    %eax,0x8(%esp)
  801928:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80192f:	00 
  801930:	89 3c 24             	mov    %edi,(%esp)
  801933:	e8 60 0b 00 00       	call   802498 <_Z5readniPvj>
  801938:	89 c3                	mov    %eax,%ebx
  80193a:	85 c0                	test   %eax,%eax
  80193c:	78 30                	js     80196e <_Z10spawn_readiPvijji+0x1a2>
  80193e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801945:	00 
  801946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801949:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80194d:	8b 55 08             	mov    0x8(%ebp),%edx
  801950:	89 54 24 08          	mov    %edx,0x8(%esp)
  801954:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80195b:	00 
  80195c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801963:	e8 57 f5 ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
  801968:	89 c3                	mov    %eax,%ebx
  80196a:	85 c0                	test   %eax,%eax
  80196c:	74 50                	je     8019be <_Z10spawn_readiPvijji+0x1f2>
           (r = sys_page_map(0, UTEMP, dst_env, i, PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
  80196e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801975:	00 
  801976:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80197d:	e8 9b f5 ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
            return r;
  801982:	eb 02                	jmp    801986 <_Z10spawn_readiPvijji+0x1ba>
        return r;
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
            return r;
  801984:	89 c3                	mov    %eax,%ebx
            return r;
        }
        sys_page_unmap(0, UTEMP);
    }
    return 0;
}
  801986:	89 d8                	mov    %ebx,%eax
  801988:	83 c4 3c             	add    $0x3c,%esp
  80198b:	5b                   	pop    %ebx
  80198c:	5e                   	pop    %esi
  80198d:	5f                   	pop    %edi
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
  801990:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801997:	00 
  801998:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80199f:	e8 79 f5 ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
        va = ROUNDUP(va, PGSIZE);
  8019a4:	8b 75 e0             	mov    -0x20(%ebp),%esi
  8019a7:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
  8019ad:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        len -= bytes;
  8019b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019b6:	29 45 18             	sub    %eax,0x18(%ebp)
  8019b9:	e9 20 ff ff ff       	jmp    8018de <_Z10spawn_readiPvijji+0x112>
           (r = sys_page_map(0, UTEMP, dst_env, i, PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
  8019be:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8019c5:	00 
  8019c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019cd:	e8 4b f5 ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
        sys_page_unmap(0, UTEMP);
        va = ROUNDUP(va, PGSIZE);
        len -= bytes;
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
  8019d2:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  8019d9:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  8019df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019e2:	39 55 e0             	cmp    %edx,-0x20(%ebp)
  8019e5:	0f 87 09 ff ff ff    	ja     8018f4 <_Z10spawn_readiPvijji+0x128>
  8019eb:	eb 99                	jmp    801986 <_Z10spawn_readiPvijji+0x1ba>

008019ed <_Z5spawnPKcPS0_>:
    return 0;
}

envid_t
spawn(const char *prog, const char **argv)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	81 ec b8 02 00 00    	sub    $0x2b8,%esp
  8019f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019f9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019fc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unfortunately, you cannot 'read' into a child address space,
	// so you'll need to code the 'read' case differently.
	//
	// Also, make sure you close the file descriptor, if any,
	// before returning from spawn().
    int fs_load = prog[0] == '/';
  801a02:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  801a05:	0f 94 c0             	sete   %al
  801a08:	0f b6 c0             	movzbl %al,%eax
  801a0b:	89 c6                	mov    %eax,%esi
    memset(elf_buf, 0, sizeof(elf_buf)); // ensure stack is writable
  801a0d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801a14:	00 
  801a15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a1c:	00 
  801a1d:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801a23:	89 04 24             	mov    %eax,(%esp)
  801a26:	e8 96 f0 ff ff       	call   800ac1 <memset>
    if(fs_load)
  801a2b:	85 f6                	test   %esi,%esi
  801a2d:	74 41                	je     801a70 <_Z5spawnPKcPS0_+0x83>
    {
        if ((progid = open(prog, O_RDONLY)) < 0)
  801a2f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a36:	00 
  801a37:	89 1c 24             	mov    %ebx,(%esp)
  801a3a:	e8 4f 16 00 00       	call   80308e <_Z4openPKci>
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	85 c0                	test   %eax,%eax
  801a43:	0f 88 4e 05 00 00    	js     801f97 <_Z5spawnPKcPS0_+0x5aa>
            return progid;
        if (readn(progid, elf,sizeof(elf_buf)) != sizeof elf_buf)
  801a49:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801a50:	00 
  801a51:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5b:	89 1c 24             	mov    %ebx,(%esp)
  801a5e:	e8 35 0a 00 00       	call   802498 <_Z5readniPvj>
  801a63:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a68:	0f 85 11 05 00 00    	jne    801f7f <_Z5spawnPKcPS0_+0x592>
  801a6e:	eb 51                	jmp    801ac1 <_Z5spawnPKcPS0_+0xd4>
            return -E_NOT_EXEC;
    }
    else
    {
        // Read ELF header from the kernel's binary collection.
        if ((progid = sys_program_lookup(prog, strlen(prog))) < 0)
  801a70:	89 1c 24             	mov    %ebx,(%esp)
  801a73:	e8 c8 ee ff ff       	call   800940 <_Z6strlenPKc>
  801a78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7c:	89 1c 24             	mov    %ebx,(%esp)
  801a7f:	e8 04 f7 ff ff       	call   801188 <_Z18sys_program_lookupPKcj>
  801a84:	89 c3                	mov    %eax,%ebx
  801a86:	85 c0                	test   %eax,%eax
  801a88:	0f 88 09 05 00 00    	js     801f97 <_Z5spawnPKcPS0_+0x5aa>
            return progid;
        if (sys_program_read(0, elf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf, 0))
  801a8e:	c7 44 24 10 00 02 00 	movl   $0x200,0x10(%esp)
  801a95:	00 
  801a96:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a9d:	00 
  801a9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa2:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab3:	e8 a5 f7 ff ff       	call   80125d <_Z16sys_program_readiPvijj>
  801ab8:	83 f8 04             	cmp    $0x4,%eax
  801abb:	0f 85 c5 04 00 00    	jne    801f86 <_Z5spawnPKcPS0_+0x599>
            return -E_NOT_EXEC;
    }
    if (elf->e_magic != ELF_MAGIC) {
  801ac1:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
  801ac7:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  801acc:	74 22                	je     801af0 <_Z5spawnPKcPS0_+0x103>
        cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801ace:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801ad5:	46 
  801ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ada:	c7 04 24 87 52 80 00 	movl   $0x805287,(%esp)
  801ae1:	e8 74 e8 ff ff       	call   80035a <_Z7cprintfPKcz>
        return -E_NOT_EXEC;
  801ae6:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  801aeb:	e9 a7 04 00 00       	jmp    801f97 <_Z5spawnPKcPS0_+0x5aa>
	//   although you won't use that fact here.)
	// - Check out sys_env_set_trapframe and init_stack.
	//
	

    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
  801af0:	8b 95 c0 fd ff ff    	mov    -0x240(%ebp),%edx
  801af6:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
    struct Proghdr *eph = ph + elf->e_phnum;
  801afc:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
  801b03:	66 89 85 76 fd ff ff 	mov    %ax,-0x28a(%ebp)
  801b0a:	ba 07 00 00 00       	mov    $0x7,%edx
  801b0f:	89 d0                	mov    %edx,%eax
  801b11:	cd 30                	int    $0x30
  801b13:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801b19:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
    
    envid_t envid;
    if ((envid = sys_exofork()) < 0)
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	0f 88 66 04 00 00    	js     801f8d <_Z5spawnPKcPS0_+0x5a0>
        return envid;
    
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
  801b27:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b2c:	6b c0 78             	imul   $0x78,%eax,%eax
  801b2f:	05 14 00 00 ef       	add    $0xef000014,%eax
  801b34:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  801b3b:	00 
  801b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b40:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  801b43:	89 04 24             	mov    %eax,(%esp)
  801b46:	e8 4c f0 ff ff       	call   800b97 <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4e:	8b 02                	mov    (%edx),%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	0f 84 93 00 00 00    	je     801beb <_Z5spawnPKcPS0_+0x1fe>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801b58:	bf 00 00 00 00       	mov    $0x0,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801b5d:	c7 85 90 fd ff ff 00 	movl   $0x0,-0x270(%ebp)
  801b64:	00 00 00 
  801b67:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b6d:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  801b73:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b78:	89 d6                	mov    %edx,%esi
		string_size += strlen(argv[argc]) + 1;
  801b7a:	89 04 24             	mov    %eax,(%esp)
  801b7d:	e8 be ed ff ff       	call   800940 <_Z6strlenPKc>
  801b82:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b86:	83 c3 01             	add    $0x1,%ebx
  801b89:	89 da                	mov    %ebx,%edx
  801b8b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801b92:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801b95:	85 c0                	test   %eax,%eax
  801b97:	75 e1                	jne    801b7a <_Z5spawnPKcPS0_+0x18d>
  801b99:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801b9f:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801ba5:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
  801bab:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  801bb1:	89 8d 70 fd ff ff    	mov    %ecx,-0x290(%ebp)
	// into the temporary page at UTEMP.
	// Later, we'll remap that page into the child environment
	// at (USTACKTOP - PGSIZE).

	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801bb7:	f7 df                	neg    %edi
  801bb9:	81 c7 00 10 40 00    	add    $0x401000,%edi

	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);
  801bbf:	89 fa                	mov    %edi,%edx
  801bc1:	83 e2 fc             	and    $0xfffffffc,%edx
  801bc4:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801bca:	f7 d0                	not    %eax
  801bcc:	8d 04 82             	lea    (%edx,%eax,4),%eax
  801bcf:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801bd5:	83 e8 08             	sub    $0x8,%eax
  801bd8:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801bde:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801be3:	0f 86 78 01 00 00    	jbe    801d61 <_Z5spawnPKcPS0_+0x374>
  801be9:	eb 37                	jmp    801c22 <_Z5spawnPKcPS0_+0x235>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801beb:	c7 85 70 fd ff ff 00 	movl   $0x0,-0x290(%ebp)
  801bf2:	00 00 00 
  801bf5:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801bfc:	00 00 00 
  801bff:	c7 85 90 fd ff ff 00 	movl   $0x0,-0x270(%ebp)
  801c06:	00 00 00 
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801c09:	c7 85 84 fd ff ff f4 	movl   $0x400ff4,-0x27c(%ebp)
  801c10:	0f 40 00 
	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;

	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);
  801c13:	c7 85 8c fd ff ff fc 	movl   $0x400ffc,-0x274(%ebp)
  801c1a:	0f 40 00 
	// into the temporary page at UTEMP.
	// Later, we'll remap that page into the child environment
	// at (USTACKTOP - PGSIZE).

	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801c1d:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate a page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c22:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c29:	00 
  801c2a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c31:	00 
  801c32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c39:	e8 22 f2 ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	0f 88 1b 01 00 00    	js     801d61 <_Z5spawnPKcPS0_+0x374>
		return r;

	// Store the 'argc' and 'argv' parameters themselves
	// below 'argv_store' on the stack.  These parameters will be passed
	// to umain().
	argv_store[-2] = argc;
  801c46:	8b 95 7c fd ff ff    	mov    -0x284(%ebp),%edx
  801c4c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c52:	89 10                	mov    %edx,(%eax)
	argv_store[-1] = utemp_addr_to_stack_addr(argv_store);
  801c54:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801c5a:	e8 29 fb ff ff       	call   801788 <_ZL24utemp_addr_to_stack_addrPv>
  801c5f:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801c65:	89 42 fc             	mov    %eax,-0x4(%edx)
	// and initialize 'argv_store[i]' to point at argument string i
	// in the child's address space.
	// Then set 'argv_store[argc]' to 0 to null-terminate the args array.
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
  801c68:	83 bd 90 fd ff ff 00 	cmpl   $0x0,-0x270(%ebp)
  801c6f:	7e 71                	jle    801ce2 <_Z5spawnPKcPS0_+0x2f5>
  801c71:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801c78:	00 00 00 
  801c7b:	89 9d 6c fd ff ff    	mov    %ebx,-0x294(%ebp)
  801c81:	89 b5 68 fd ff ff    	mov    %esi,-0x298(%ebp)
  801c87:	be 00 00 00 00       	mov    $0x0,%esi
  801c8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);
  801c8f:	89 f8                	mov    %edi,%eax
  801c91:	e8 f2 fa ff ff       	call   801788 <_ZL24utemp_addr_to_stack_addrPv>
    }
    return 0;
}

envid_t
spawn(const char *prog, const char **argv)
  801c96:	89 f1                	mov    %esi,%ecx
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);
  801c98:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801c9e:	89 04 b2             	mov    %eax,(%edx,%esi,4)

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  801ca1:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801ca4:	0f b6 00             	movzbl (%eax),%eax
  801ca7:	84 c0                	test   %al,%al
  801ca9:	74 18                	je     801cc3 <_Z5spawnPKcPS0_+0x2d6>
  801cab:	ba 00 00 00 00       	mov    $0x0,%edx
        {
            *string_store = argv[i][j];
  801cb0:	88 07                	mov    %al,(%edi)
            string_store++;
  801cb2:	83 c7 01             	add    $0x1,%edi
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  801cb5:	83 c2 01             	add    $0x1,%edx
  801cb8:	8b 04 8b             	mov    (%ebx,%ecx,4),%eax
  801cbb:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  801cbf:	84 c0                	test   %al,%al
  801cc1:	75 ed                	jne    801cb0 <_Z5spawnPKcPS0_+0x2c3>
        {
            *string_store = argv[i][j];
            string_store++;
        }
        // terminate the string
        *string_store = '\0';
  801cc3:	c6 07 00             	movb   $0x0,(%edi)
	// and initialize 'argv_store[i]' to point at argument string i
	// in the child's address space.
	// Then set 'argv_store[argc]' to 0 to null-terminate the args array.
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
  801cc6:	83 c6 01             	add    $0x1,%esi
  801cc9:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  801ccf:	7d 05                	jge    801cd6 <_Z5spawnPKcPS0_+0x2e9>
            *string_store = argv[i][j];
            string_store++;
        }
        // terminate the string
        *string_store = '\0';
        string_store++;
  801cd1:	83 c7 01             	add    $0x1,%edi
  801cd4:	eb b9                	jmp    801c8f <_Z5spawnPKcPS0_+0x2a2>
  801cd6:	8b 9d 6c fd ff ff    	mov    -0x294(%ebp),%ebx
  801cdc:	8b b5 68 fd ff ff    	mov    -0x298(%ebp),%esi
    }   
    
    // null-terminate the whole argv array
    argv_store[argc] = 0;
  801ce2:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801ce8:	8b 85 70 fd ff ff    	mov    -0x290(%ebp),%eax
  801cee:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)

	// Set *init_esp to the initial stack pointer for the child:
	// it should point at the "argc" value stored on the stack.
	// set the initial stack to point at argc
    *init_esp = utemp_addr_to_stack_addr(&argv_store[-2]);
  801cf5:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801cfb:	e8 88 fa ff ff       	call   801788 <_ZL24utemp_addr_to_stack_addrPv>
  801d00:	89 45 e0             	mov    %eax,-0x20(%ebp)


	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d03:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801d0a:	00 
  801d0b:	c7 44 24 0c 00 d0 ff 	movl   $0xeeffd000,0xc(%esp)
  801d12:	ee 
  801d13:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d19:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d1d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d24:	00 
  801d25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2c:	e8 8e f1 ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 18                	js     801d4d <_Z5spawnPKcPS0_+0x360>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801d35:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d3c:	00 
  801d3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d44:	e8 d4 f1 ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	79 14                	jns    801d61 <_Z5spawnPKcPS0_+0x374>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801d4d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d54:	00 
  801d55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d5c:	e8 bc f1 ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
        return envid;
    
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
  801d61:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
  801d67:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if ((r = sys_env_set_trapframe(envid, &tf)))
  801d6a:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  801d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d71:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  801d77:	89 14 24             	mov    %edx,(%esp)
  801d7a:	e8 b8 f2 ff ff       	call   801037 <_Z21sys_env_set_trapframeiP9Trapframe>
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	0f 85 0e 02 00 00    	jne    801f95 <_Z5spawnPKcPS0_+0x5a8>
	//   although you won't use that fact here.)
	// - Check out sys_env_set_trapframe and init_stack.
	//
	

    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
  801d87:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801d8d:	03 bd 80 fd ff ff    	add    -0x280(%ebp),%edi
    struct Proghdr *eph = ph + elf->e_phnum;
  801d93:	0f b7 85 76 fd ff ff 	movzwl -0x28a(%ebp),%eax
  801d9a:	c1 e0 05             	shl    $0x5,%eax
  801d9d:	8d 04 07             	lea    (%edi,%eax,1),%eax
  801da0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
    // iterate over each program header in the elf file
    for(; ph < eph; ++ph)
  801da6:	39 c7                	cmp    %eax,%edi
  801da8:	0f 83 25 01 00 00    	jae    801ed3 <_Z5spawnPKcPS0_+0x4e6>
  801dae:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801db4:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801dba:	89 fe                	mov    %edi,%esi
  801dbc:	8b bd 78 fd ff ff    	mov    -0x288(%ebp),%edi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
  801dc2:	83 3e 01             	cmpl   $0x1,(%esi)
  801dc5:	0f 85 ed 00 00 00    	jne    801eb8 <_Z5spawnPKcPS0_+0x4cb>
{
    // identical to segment alloc for load_elf!
    int r;

    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
  801dcb:	8b 5e 08             	mov    0x8(%esi),%ebx
  801dce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    len = ROUNDUP(va + len, PGSIZE);
  801dd4:	8b 46 14             	mov    0x14(%esi),%eax
  801dd7:	8d 84 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%eax
  801dde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801de3:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)

    // allocate pages for the whole region
    for (uintptr_t i = va; i < len; i+=PGSIZE)
  801de9:	39 c3                	cmp    %eax,%ebx
  801deb:	73 3c                	jae    801e29 <_Z5spawnPKcPS0_+0x43c>
  801ded:	89 b5 8c fd ff ff    	mov    %esi,-0x274(%ebp)
  801df3:	89 c6                	mov    %eax,%esi
        if ((r = sys_page_alloc(dst_env, (void *)i, PTE_P|PTE_U|PTE_W)))
  801df5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801dfc:	00 
  801dfd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e01:	89 3c 24             	mov    %edi,(%esp)
  801e04:	e8 57 f0 ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 0c                	je     801e19 <_Z5spawnPKcPS0_+0x42c>
  801e0d:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
        {
            // allocate the region for it and read the data into the region
	        if ((r = segment_alloc(envid, ph->p_va, ph->p_memsz)) ||
  801e13:	f7 d8                	neg    %eax
  801e15:	75 4b                	jne    801e62 <_Z5spawnPKcPS0_+0x475>
  801e17:	eb 10                	jmp    801e29 <_Z5spawnPKcPS0_+0x43c>
    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
    len = ROUNDUP(va + len, PGSIZE);

    // allocate pages for the whole region
    for (uintptr_t i = va; i < len; i+=PGSIZE)
  801e19:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e1f:	39 de                	cmp    %ebx,%esi
  801e21:	77 d2                	ja     801df5 <_Z5spawnPKcPS0_+0x408>
  801e23:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
        {
            // allocate the region for it and read the data into the region
	        if ((r = segment_alloc(envid, ph->p_va, ph->p_memsz)) ||
  801e29:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801e2f:	89 44 24 14          	mov    %eax,0x14(%esp)
  801e33:	8b 46 10             	mov    0x10(%esi),%eax
  801e36:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e3a:	8b 46 04             	mov    0x4(%esi),%eax
  801e3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e41:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  801e47:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e4b:	8b 46 08             	mov    0x8(%esi),%eax
  801e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e52:	89 3c 24             	mov    %edi,(%esp)
  801e55:	e8 72 f9 ff ff       	call   8017cc <_Z10spawn_readiPvijji>
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	0f 89 44 01 00 00    	jns    801fa6 <_Z5spawnPKcPS0_+0x5b9>
  801e62:	89 c7                	mov    %eax,%edi
               (r = spawn_read(envid, (void *)ph->p_va, progid, ph->p_offset, ph->p_filesz, fs_load)) < 0)
            {
                sys_env_destroy(envid);
  801e64:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e6a:	89 04 24             	mov    %eax,(%esp)
  801e6d:	e8 29 ef ff ff       	call   800d9b <_Z15sys_env_destroyi>
                return r;
  801e72:	89 fb                	mov    %edi,%ebx
  801e74:	e9 1e 01 00 00       	jmp    801f97 <_Z5spawnPKcPS0_+0x5aa>
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  801e79:	8b 46 08             	mov    0x8(%esi),%eax
  801e7c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e81:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801e88:	00 
  801e89:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801e91:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e95:	89 3c 24             	mov    %edi,(%esp)
  801e98:	e8 22 f0 ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	74 17                	je     801eb8 <_Z5spawnPKcPS0_+0x4cb>
  801ea1:	89 c7                	mov    %eax,%edi
            {
                sys_env_destroy(envid);
  801ea3:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  801ea9:	89 14 24             	mov    %edx,(%esp)
  801eac:	e8 ea ee ff ff       	call   800d9b <_Z15sys_env_destroyi>
                return r;
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  801eb1:	89 fb                	mov    %edi,%ebx
            {
                sys_env_destroy(envid);
                return r;
  801eb3:	e9 df 00 00 00       	jmp    801f97 <_Z5spawnPKcPS0_+0x5aa>
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
    // iterate over each program header in the elf file
    for(; ph < eph; ++ph)
  801eb8:	83 c6 20             	add    $0x20,%esi
  801ebb:	39 b5 94 fd ff ff    	cmp    %esi,-0x26c(%ebp)
  801ec1:	0f 87 fb fe ff ff    	ja     801dc2 <_Z5spawnPKcPS0_+0x3d5>
  801ec7:	8b 9d 84 fd ff ff    	mov    -0x27c(%ebp),%ebx
  801ecd:	8b b5 80 fd ff ff    	mov    -0x280(%ebp),%esi
            }
                 
        }
    }

    if(fs_load)
  801ed3:	85 f6                	test   %esi,%esi
  801ed5:	74 08                	je     801edf <_Z5spawnPKcPS0_+0x4f2>
        close(progid);
  801ed7:	89 1c 24             	mov    %ebx,(%esp)
  801eda:	e8 76 03 00 00       	call   802255 <_Z5closei>
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  801edf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ee4:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
copy_shared_pages(envid_t child)
{
	uintptr_t va;
	int r;
	for (va = 0; va < UTOP; va += PGSIZE)
		if (!(vpd[PDX(va)] & PTE_P))
  801eea:	89 d8                	mov    %ebx,%eax
  801eec:	c1 e8 16             	shr    $0x16,%eax
  801eef:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801ef6:	a8 01                	test   $0x1,%al
  801ef8:	75 0e                	jne    801f08 <_Z5spawnPKcPS0_+0x51b>
			va = ROUNDUP(va + 1, PTSIZE) - PGSIZE;
  801efa:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  801f00:	8d 9b 00 f0 3f 00    	lea    0x3ff000(%ebx),%ebx
  801f06:	eb 46                	jmp    801f4e <_Z5spawnPKcPS0_+0x561>
		else if ((vpt[PGNUM(va)] & (PTE_P|PTE_SHARE)) == (PTE_P|PTE_SHARE)) {
  801f08:	89 d8                	mov    %ebx,%eax
  801f0a:	c1 e8 0c             	shr    $0xc,%eax
  801f0d:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801f14:	81 e2 01 04 00 00    	and    $0x401,%edx
  801f1a:	81 fa 01 04 00 00    	cmp    $0x401,%edx
  801f20:	75 2c                	jne    801f4e <_Z5spawnPKcPS0_+0x561>
			r = sys_page_map(0, (void *) va, child, (void *) va,
					 vpt[PGNUM(va)] & PTE_SYSCALL);
  801f22:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801f29:	25 07 0e 00 00       	and    $0xe07,%eax
  801f2e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801f32:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f36:	89 74 24 08          	mov    %esi,0x8(%esp)
  801f3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f45:	e8 75 ef ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
			if (r < 0)
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	78 0e                	js     801f5c <_Z5spawnPKcPS0_+0x56f>
static int
copy_shared_pages(envid_t child)
{
	uintptr_t va;
	int r;
	for (va = 0; va < UTOP; va += PGSIZE)
  801f4e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f54:	81 fb ff ff ff ee    	cmp    $0xeeffffff,%ebx
  801f5a:	76 8e                	jbe    801eea <_Z5spawnPKcPS0_+0x4fd>
    if(fs_load)
        close(progid);
    copy_shared_pages(envid);
    
    // set our spawned process to runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801f5c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f63:	00 
  801f64:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801f6a:	89 04 24             	mov    %eax,(%esp)
  801f6d:	e8 09 f0 ff ff       	call   800f7b <_Z18sys_env_set_statusii>
        return r;
  801f72:	85 c0                	test   %eax,%eax
  801f74:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
  801f7a:	0f 48 d8             	cmovs  %eax,%ebx
  801f7d:	eb 18                	jmp    801f97 <_Z5spawnPKcPS0_+0x5aa>
    if(fs_load)
    {
        if ((progid = open(prog, O_RDONLY)) < 0)
            return progid;
        if (readn(progid, elf,sizeof(elf_buf)) != sizeof elf_buf)
            return -E_NOT_EXEC;
  801f7f:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  801f84:	eb 11                	jmp    801f97 <_Z5spawnPKcPS0_+0x5aa>
    {
        // Read ELF header from the kernel's binary collection.
        if ((progid = sys_program_lookup(prog, strlen(prog))) < 0)
            return progid;
        if (sys_program_read(0, elf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf, 0))
            return -E_NOT_EXEC;
  801f86:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  801f8b:	eb 0a                	jmp    801f97 <_Z5spawnPKcPS0_+0x5aa>
    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
    struct Proghdr *eph = ph + elf->e_phnum;
    
    envid_t envid;
    if ((envid = sys_exofork()) < 0)
        return envid;
  801f8d:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
  801f93:	eb 02                	jmp    801f97 <_Z5spawnPKcPS0_+0x5aa>
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
  801f95:	89 c3                	mov    %eax,%ebx
    
    // set our spawned process to runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
        return r;
    return envid;
}
  801f97:	89 d8                	mov    %ebx,%eax
  801f99:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f9c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f9f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801fa2:	89 ec                	mov    %ebp,%esp
  801fa4:	5d                   	pop    %ebp
  801fa5:	c3                   	ret    
                return r;
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  801fa6:	f6 46 18 02          	testb  $0x2,0x18(%esi)
  801faa:	0f 85 08 ff ff ff    	jne    801eb8 <_Z5spawnPKcPS0_+0x4cb>
  801fb0:	e9 c4 fe ff ff       	jmp    801e79 <_Z5spawnPKcPS0_+0x48c>

00801fb5 <_Z6spawnlPKcS0_z>:
}

// Spawn, taking command-line arguments array directly on the stack.
envid_t
spawnl(const char *prog, const char *arg0, ...)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  801fbb:	8d 45 0c             	lea    0xc(%ebp),%eax
  801fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	89 04 24             	mov    %eax,(%esp)
  801fc8:	e8 20 fa ff ff       	call   8019ed <_Z5spawnPKcPS0_>
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    
	...

00801fd0 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801fd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801fd8:	75 11                	jne    801feb <_ZL8fd_validPK2Fd+0x1b>
  801fda:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  801fdf:	76 0a                	jbe    801feb <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801fe1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801fe6:	0f 96 c0             	setbe  %al
  801fe9:	eb 05                	jmp    801ff0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801feb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff0:	5d                   	pop    %ebp
  801ff1:	c3                   	ret    

00801ff2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	53                   	push   %ebx
  801ff6:	83 ec 14             	sub    $0x14,%esp
  801ff9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  801ffb:	e8 d0 ff ff ff       	call   801fd0 <_ZL8fd_validPK2Fd>
  802000:	84 c0                	test   %al,%al
  802002:	75 24                	jne    802028 <_ZL9fd_isopenPK2Fd+0x36>
  802004:	c7 44 24 0c a1 52 80 	movl   $0x8052a1,0xc(%esp)
  80200b:	00 
  80200c:	c7 44 24 08 66 52 80 	movl   $0x805266,0x8(%esp)
  802013:	00 
  802014:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80201b:	00 
  80201c:	c7 04 24 ae 52 80 00 	movl   $0x8052ae,(%esp)
  802023:	e8 14 e2 ff ff       	call   80023c <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  802028:	89 d8                	mov    %ebx,%eax
  80202a:	c1 e8 16             	shr    $0x16,%eax
  80202d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  802034:	b8 00 00 00 00       	mov    $0x0,%eax
  802039:	f6 c2 01             	test   $0x1,%dl
  80203c:	74 0d                	je     80204b <_ZL9fd_isopenPK2Fd+0x59>
  80203e:	c1 eb 0c             	shr    $0xc,%ebx
  802041:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  802048:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80204b:	83 c4 14             	add    $0x14,%esp
  80204e:	5b                   	pop    %ebx
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 08             	sub    $0x8,%esp
  802057:	89 1c 24             	mov    %ebx,(%esp)
  80205a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80205e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802061:	8b 75 0c             	mov    0xc(%ebp),%esi
  802064:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  802068:	83 fb 1f             	cmp    $0x1f,%ebx
  80206b:	77 18                	ja     802085 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80206d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  802073:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  802076:	84 c0                	test   %al,%al
  802078:	74 21                	je     80209b <_Z9fd_lookupiPP2Fdb+0x4a>
  80207a:	89 d8                	mov    %ebx,%eax
  80207c:	e8 71 ff ff ff       	call   801ff2 <_ZL9fd_isopenPK2Fd>
  802081:	84 c0                	test   %al,%al
  802083:	75 16                	jne    80209b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  802085:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80208b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  802090:	8b 1c 24             	mov    (%esp),%ebx
  802093:	8b 74 24 04          	mov    0x4(%esp),%esi
  802097:	89 ec                	mov    %ebp,%esp
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80209b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	eb ec                	jmp    802090 <_Z9fd_lookupiPP2Fdb+0x3f>

008020a4 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	53                   	push   %ebx
  8020a8:	83 ec 14             	sub    $0x14,%esp
  8020ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  8020ae:	89 d8                	mov    %ebx,%eax
  8020b0:	e8 1b ff ff ff       	call   801fd0 <_ZL8fd_validPK2Fd>
  8020b5:	84 c0                	test   %al,%al
  8020b7:	75 24                	jne    8020dd <_Z6fd2numP2Fd+0x39>
  8020b9:	c7 44 24 0c a1 52 80 	movl   $0x8052a1,0xc(%esp)
  8020c0:	00 
  8020c1:	c7 44 24 08 66 52 80 	movl   $0x805266,0x8(%esp)
  8020c8:	00 
  8020c9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8020d0:	00 
  8020d1:	c7 04 24 ae 52 80 00 	movl   $0x8052ae,(%esp)
  8020d8:	e8 5f e1 ff ff       	call   80023c <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020dd:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  8020e3:	c1 e8 0c             	shr    $0xc,%eax
}
  8020e6:	83 c4 14             	add    $0x14,%esp
  8020e9:	5b                   	pop    %ebx
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    

008020ec <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	89 04 24             	mov    %eax,(%esp)
  8020f8:	e8 a7 ff ff ff       	call   8020a4 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8020fd:	05 20 00 0d 00       	add    $0xd0020,%eax
  802102:	c1 e0 0c             	shl    $0xc,%eax
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	57                   	push   %edi
  80210b:	56                   	push   %esi
  80210c:	53                   	push   %ebx
  80210d:	83 ec 2c             	sub    $0x2c,%esp
  802110:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  802113:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  802118:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80211b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802122:	00 
  802123:	89 74 24 04          	mov    %esi,0x4(%esp)
  802127:	89 1c 24             	mov    %ebx,(%esp)
  80212a:	e8 22 ff ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80212f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802132:	e8 bb fe ff ff       	call   801ff2 <_ZL9fd_isopenPK2Fd>
  802137:	84 c0                	test   %al,%al
  802139:	75 0c                	jne    802147 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80213b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80213e:	89 07                	mov    %eax,(%edi)
			return 0;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
  802145:	eb 13                	jmp    80215a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  802147:	83 c3 01             	add    $0x1,%ebx
  80214a:	83 fb 20             	cmp    $0x20,%ebx
  80214d:	75 cc                	jne    80211b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80214f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  802155:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80215a:	83 c4 2c             	add    $0x2c,%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5f                   	pop    %edi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    

00802162 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	53                   	push   %ebx
  802166:	83 ec 14             	sub    $0x14,%esp
  802169:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80216c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  802174:	39 0d 0c 60 80 00    	cmp    %ecx,0x80600c
  80217a:	75 16                	jne    802192 <_Z10dev_lookupiPP3Dev+0x30>
  80217c:	eb 06                	jmp    802184 <_Z10dev_lookupiPP3Dev+0x22>
  80217e:	39 0a                	cmp    %ecx,(%edx)
  802180:	75 10                	jne    802192 <_Z10dev_lookupiPP3Dev+0x30>
  802182:	eb 05                	jmp    802189 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802184:	ba 0c 60 80 00       	mov    $0x80600c,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  802189:	89 13                	mov    %edx,(%ebx)
			return 0;
  80218b:	b8 00 00 00 00       	mov    $0x0,%eax
  802190:	eb 35                	jmp    8021c7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802192:	83 c0 01             	add    $0x1,%eax
  802195:	8b 14 85 18 53 80 00 	mov    0x805318(,%eax,4),%edx
  80219c:	85 d2                	test   %edx,%edx
  80219e:	75 de                	jne    80217e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021a0:	a1 00 70 80 00       	mov    0x807000,%eax
  8021a5:	8b 40 04             	mov    0x4(%eax),%eax
  8021a8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b0:	c7 04 24 d4 52 80 00 	movl   $0x8052d4,(%esp)
  8021b7:	e8 9e e1 ff ff       	call   80035a <_Z7cprintfPKcz>
	*dev = 0;
  8021bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8021c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021c7:	83 c4 14             	add    $0x14,%esp
  8021ca:	5b                   	pop    %ebx
  8021cb:	5d                   	pop    %ebp
  8021cc:	c3                   	ret    

008021cd <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	83 ec 20             	sub    $0x20,%esp
  8021d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8021d8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  8021dc:	89 34 24             	mov    %esi,(%esp)
  8021df:	e8 c0 fe ff ff       	call   8020a4 <_Z6fd2numP2Fd>
  8021e4:	0f b6 d3             	movzbl %bl,%edx
  8021e7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021eb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021f2:	89 04 24             	mov    %eax,(%esp)
  8021f5:	e8 57 fe ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	78 05                	js     802203 <_Z8fd_closeP2Fdb+0x36>
  8021fe:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  802201:	74 0c                	je     80220f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  802203:	80 fb 01             	cmp    $0x1,%bl
  802206:	19 db                	sbb    %ebx,%ebx
  802208:	f7 d3                	not    %ebx
  80220a:	83 e3 fd             	and    $0xfffffffd,%ebx
  80220d:	eb 3d                	jmp    80224c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80220f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802212:	89 44 24 04          	mov    %eax,0x4(%esp)
  802216:	8b 06                	mov    (%esi),%eax
  802218:	89 04 24             	mov    %eax,(%esp)
  80221b:	e8 42 ff ff ff       	call   802162 <_Z10dev_lookupiPP3Dev>
  802220:	89 c3                	mov    %eax,%ebx
  802222:	85 c0                	test   %eax,%eax
  802224:	78 16                	js     80223c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  802226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802229:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80222c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802231:	85 c0                	test   %eax,%eax
  802233:	74 07                	je     80223c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  802235:	89 34 24             	mov    %esi,(%esp)
  802238:	ff d0                	call   *%eax
  80223a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80223c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802247:	e8 d1 ec ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
	return r;
}
  80224c:	89 d8                	mov    %ebx,%eax
  80224e:	83 c4 20             	add    $0x20,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    

00802255 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80225b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802262:	00 
  802263:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802266:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	89 04 24             	mov    %eax,(%esp)
  802270:	e8 dc fd ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  802275:	85 c0                	test   %eax,%eax
  802277:	78 13                	js     80228c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  802279:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802280:	00 
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	89 04 24             	mov    %eax,(%esp)
  802287:	e8 41 ff ff ff       	call   8021cd <_Z8fd_closeP2Fdb>
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <_Z9close_allv>:

void
close_all(void)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	53                   	push   %ebx
  802292:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  802295:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80229a:	89 1c 24             	mov    %ebx,(%esp)
  80229d:	e8 b3 ff ff ff       	call   802255 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  8022a2:	83 c3 01             	add    $0x1,%ebx
  8022a5:	83 fb 20             	cmp    $0x20,%ebx
  8022a8:	75 f0                	jne    80229a <_Z9close_allv+0xc>
		close(i);
}
  8022aa:	83 c4 14             	add    $0x14,%esp
  8022ad:	5b                   	pop    %ebx
  8022ae:	5d                   	pop    %ebp
  8022af:	c3                   	ret    

008022b0 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 48             	sub    $0x48,%esp
  8022b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8022b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8022bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8022bf:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8022c2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022c9:	00 
  8022ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8022cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	89 04 24             	mov    %eax,(%esp)
  8022d7:	e8 75 fd ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  8022dc:	89 c3                	mov    %eax,%ebx
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	0f 88 ce 00 00 00    	js     8023b4 <_Z3dupii+0x104>
  8022e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022ed:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  8022ee:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8022f1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8022f5:	89 34 24             	mov    %esi,(%esp)
  8022f8:	e8 54 fd ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  8022fd:	89 c3                	mov    %eax,%ebx
  8022ff:	85 c0                	test   %eax,%eax
  802301:	0f 89 bc 00 00 00    	jns    8023c3 <_Z3dupii+0x113>
  802307:	e9 a8 00 00 00       	jmp    8023b4 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  80230c:	89 d8                	mov    %ebx,%eax
  80230e:	c1 e8 0c             	shr    $0xc,%eax
  802311:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  802318:	f6 c2 01             	test   $0x1,%dl
  80231b:	74 32                	je     80234f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80231d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  802324:	25 07 0e 00 00       	and    $0xe07,%eax
  802329:	89 44 24 10          	mov    %eax,0x10(%esp)
  80232d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802331:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802338:	00 
  802339:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80233d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802344:	e8 76 eb ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
  802349:	89 c3                	mov    %eax,%ebx
  80234b:	85 c0                	test   %eax,%eax
  80234d:	78 3e                	js     80238d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80234f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802352:	89 c2                	mov    %eax,%edx
  802354:	c1 ea 0c             	shr    $0xc,%edx
  802357:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80235e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802364:	89 54 24 10          	mov    %edx,0x10(%esp)
  802368:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80236b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80236f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802376:	00 
  802377:	89 44 24 04          	mov    %eax,0x4(%esp)
  80237b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802382:	e8 38 eb ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
  802387:	89 c3                	mov    %eax,%ebx
  802389:	85 c0                	test   %eax,%eax
  80238b:	79 25                	jns    8023b2 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80238d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802390:	89 44 24 04          	mov    %eax,0x4(%esp)
  802394:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80239b:	e8 7d eb ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  8023a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ab:	e8 6d eb ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
	return r;
  8023b0:	eb 02                	jmp    8023b4 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8023b2:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8023b4:	89 d8                	mov    %ebx,%eax
  8023b6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023b9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8023bc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8023bf:	89 ec                	mov    %ebp,%esp
  8023c1:	5d                   	pop    %ebp
  8023c2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  8023c3:	89 34 24             	mov    %esi,(%esp)
  8023c6:	e8 8a fe ff ff       	call   802255 <_Z5closei>

	ova = fd2data(oldfd);
  8023cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ce:	89 04 24             	mov    %eax,(%esp)
  8023d1:	e8 16 fd ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  8023d6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8023d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023db:	89 04 24             	mov    %eax,(%esp)
  8023de:	e8 09 fd ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  8023e3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8023e5:	89 d8                	mov    %ebx,%eax
  8023e7:	c1 e8 16             	shr    $0x16,%eax
  8023ea:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8023f1:	a8 01                	test   $0x1,%al
  8023f3:	0f 85 13 ff ff ff    	jne    80230c <_Z3dupii+0x5c>
  8023f9:	e9 51 ff ff ff       	jmp    80234f <_Z3dupii+0x9f>

008023fe <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	53                   	push   %ebx
  802402:	83 ec 24             	sub    $0x24,%esp
  802405:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802408:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80240f:	00 
  802410:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802413:	89 44 24 04          	mov    %eax,0x4(%esp)
  802417:	89 1c 24             	mov    %ebx,(%esp)
  80241a:	e8 32 fc ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  80241f:	85 c0                	test   %eax,%eax
  802421:	78 5f                	js     802482 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802423:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802426:	89 44 24 04          	mov    %eax,0x4(%esp)
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	89 04 24             	mov    %eax,(%esp)
  802432:	e8 2b fd ff ff       	call   802162 <_Z10dev_lookupiPP3Dev>
  802437:	85 c0                	test   %eax,%eax
  802439:	79 4d                	jns    802488 <_Z4readiPvj+0x8a>
  80243b:	eb 45                	jmp    802482 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80243d:	a1 00 70 80 00       	mov    0x807000,%eax
  802442:	8b 40 04             	mov    0x4(%eax),%eax
  802445:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802449:	89 44 24 04          	mov    %eax,0x4(%esp)
  80244d:	c7 04 24 b7 52 80 00 	movl   $0x8052b7,(%esp)
  802454:	e8 01 df ff ff       	call   80035a <_Z7cprintfPKcz>
		return -E_INVAL;
  802459:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80245e:	eb 22                	jmp    802482 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  802466:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80246b:	85 d2                	test   %edx,%edx
  80246d:	74 13                	je     802482 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80246f:	8b 45 10             	mov    0x10(%ebp),%eax
  802472:	89 44 24 08          	mov    %eax,0x8(%esp)
  802476:	8b 45 0c             	mov    0xc(%ebp),%eax
  802479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247d:	89 0c 24             	mov    %ecx,(%esp)
  802480:	ff d2                	call   *%edx
}
  802482:	83 c4 24             	add    $0x24,%esp
  802485:	5b                   	pop    %ebx
  802486:	5d                   	pop    %ebp
  802487:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802488:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80248b:	8b 41 08             	mov    0x8(%ecx),%eax
  80248e:	83 e0 03             	and    $0x3,%eax
  802491:	83 f8 01             	cmp    $0x1,%eax
  802494:	75 ca                	jne    802460 <_Z4readiPvj+0x62>
  802496:	eb a5                	jmp    80243d <_Z4readiPvj+0x3f>

00802498 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	57                   	push   %edi
  80249c:	56                   	push   %esi
  80249d:	53                   	push   %ebx
  80249e:	83 ec 1c             	sub    $0x1c,%esp
  8024a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8024a4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8024a7:	85 f6                	test   %esi,%esi
  8024a9:	74 2f                	je     8024da <_Z5readniPvj+0x42>
  8024ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8024b0:	89 f0                	mov    %esi,%eax
  8024b2:	29 d8                	sub    %ebx,%eax
  8024b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024b8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8024bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	89 04 24             	mov    %eax,(%esp)
  8024c5:	e8 34 ff ff ff       	call   8023fe <_Z4readiPvj>
		if (m < 0)
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	78 13                	js     8024e1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	74 0d                	je     8024df <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8024d2:	01 c3                	add    %eax,%ebx
  8024d4:	39 de                	cmp    %ebx,%esi
  8024d6:	77 d8                	ja     8024b0 <_Z5readniPvj+0x18>
  8024d8:	eb 05                	jmp    8024df <_Z5readniPvj+0x47>
  8024da:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024df:	89 d8                	mov    %ebx,%eax
}
  8024e1:	83 c4 1c             	add    $0x1c,%esp
  8024e4:	5b                   	pop    %ebx
  8024e5:	5e                   	pop    %esi
  8024e6:	5f                   	pop    %edi
  8024e7:	5d                   	pop    %ebp
  8024e8:	c3                   	ret    

008024e9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8024ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8024f6:	00 
  8024f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	89 04 24             	mov    %eax,(%esp)
  802504:	e8 48 fb ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  802509:	85 c0                	test   %eax,%eax
  80250b:	78 3c                	js     802549 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80250d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802510:	89 44 24 04          	mov    %eax,0x4(%esp)
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802517:	8b 00                	mov    (%eax),%eax
  802519:	89 04 24             	mov    %eax,(%esp)
  80251c:	e8 41 fc ff ff       	call   802162 <_Z10dev_lookupiPP3Dev>
  802521:	85 c0                	test   %eax,%eax
  802523:	79 26                	jns    80254b <_Z5writeiPKvj+0x62>
  802525:	eb 22                	jmp    802549 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  80252d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  802532:	85 c9                	test   %ecx,%ecx
  802534:	74 13                	je     802549 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802536:	8b 45 10             	mov    0x10(%ebp),%eax
  802539:	89 44 24 08          	mov    %eax,0x8(%esp)
  80253d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802540:	89 44 24 04          	mov    %eax,0x4(%esp)
  802544:	89 14 24             	mov    %edx,(%esp)
  802547:	ff d1                	call   *%ecx
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80254b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80254e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  802553:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  802557:	74 f0                	je     802549 <_Z5writeiPKvj+0x60>
  802559:	eb cc                	jmp    802527 <_Z5writeiPKvj+0x3e>

0080255b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  802561:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802568:	00 
  802569:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80256c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802570:	8b 45 08             	mov    0x8(%ebp),%eax
  802573:	89 04 24             	mov    %eax,(%esp)
  802576:	e8 d6 fa ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  80257b:	85 c0                	test   %eax,%eax
  80257d:	78 0e                	js     80258d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 55 0c             	mov    0xc(%ebp),%edx
  802585:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	53                   	push   %ebx
  802593:	83 ec 24             	sub    $0x24,%esp
  802596:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802599:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8025a0:	00 
  8025a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a8:	89 1c 24             	mov    %ebx,(%esp)
  8025ab:	e8 a1 fa ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	78 58                	js     80260c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8025be:	8b 00                	mov    (%eax),%eax
  8025c0:	89 04 24             	mov    %eax,(%esp)
  8025c3:	e8 9a fb ff ff       	call   802162 <_Z10dev_lookupiPP3Dev>
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	79 46                	jns    802612 <_Z9ftruncateii+0x83>
  8025cc:	eb 3e                	jmp    80260c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  8025ce:	a1 00 70 80 00       	mov    0x807000,%eax
  8025d3:	8b 40 04             	mov    0x4(%eax),%eax
  8025d6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025de:	c7 04 24 f4 52 80 00 	movl   $0x8052f4,(%esp)
  8025e5:	e8 70 dd ff ff       	call   80035a <_Z7cprintfPKcz>
		return -E_INVAL;
  8025ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025ef:	eb 1b                	jmp    80260c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8025f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8025fc:	85 d2                	test   %edx,%edx
  8025fe:	74 0c                	je     80260c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802600:	8b 45 0c             	mov    0xc(%ebp),%eax
  802603:	89 44 24 04          	mov    %eax,0x4(%esp)
  802607:	89 0c 24             	mov    %ecx,(%esp)
  80260a:	ff d2                	call   *%edx
}
  80260c:	83 c4 24             	add    $0x24,%esp
  80260f:	5b                   	pop    %ebx
  802610:	5d                   	pop    %ebp
  802611:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802612:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802615:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  802619:	75 d6                	jne    8025f1 <_Z9ftruncateii+0x62>
  80261b:	eb b1                	jmp    8025ce <_Z9ftruncateii+0x3f>

0080261d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
  802620:	53                   	push   %ebx
  802621:	83 ec 24             	sub    $0x24,%esp
  802624:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802627:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80262e:	00 
  80262f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802632:	89 44 24 04          	mov    %eax,0x4(%esp)
  802636:	8b 45 08             	mov    0x8(%ebp),%eax
  802639:	89 04 24             	mov    %eax,(%esp)
  80263c:	e8 10 fa ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  802641:	85 c0                	test   %eax,%eax
  802643:	78 3e                	js     802683 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802645:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80264c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	89 04 24             	mov    %eax,(%esp)
  802654:	e8 09 fb ff ff       	call   802162 <_Z10dev_lookupiPP3Dev>
  802659:	85 c0                	test   %eax,%eax
  80265b:	79 2c                	jns    802689 <_Z5fstatiP4Stat+0x6c>
  80265d:	eb 24                	jmp    802683 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80265f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802662:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  802669:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  802670:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802676:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80267a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267d:	89 04 24             	mov    %eax,(%esp)
  802680:	ff 52 14             	call   *0x14(%edx)
}
  802683:	83 c4 24             	add    $0x24,%esp
  802686:	5b                   	pop    %ebx
  802687:	5d                   	pop    %ebp
  802688:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802689:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80268c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802691:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  802695:	75 c8                	jne    80265f <_Z5fstatiP4Stat+0x42>
  802697:	eb ea                	jmp    802683 <_Z5fstatiP4Stat+0x66>

00802699 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
  80269c:	83 ec 18             	sub    $0x18,%esp
  80269f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8026a2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8026ac:	00 
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	89 04 24             	mov    %eax,(%esp)
  8026b3:	e8 d6 09 00 00       	call   80308e <_Z4openPKci>
  8026b8:	89 c3                	mov    %eax,%ebx
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	78 1b                	js     8026d9 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8026be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c5:	89 1c 24             	mov    %ebx,(%esp)
  8026c8:	e8 50 ff ff ff       	call   80261d <_Z5fstatiP4Stat>
  8026cd:	89 c6                	mov    %eax,%esi
	close(fd);
  8026cf:	89 1c 24             	mov    %ebx,(%esp)
  8026d2:	e8 7e fb ff ff       	call   802255 <_Z5closei>
	return r;
  8026d7:	89 f3                	mov    %esi,%ebx
}
  8026d9:	89 d8                	mov    %ebx,%eax
  8026db:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8026de:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8026e1:	89 ec                	mov    %ebp,%esp
  8026e3:	5d                   	pop    %ebp
  8026e4:	c3                   	ret    
	...

008026f0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8026f3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8026f8:	85 d2                	test   %edx,%edx
  8026fa:	78 33                	js     80272f <_ZL10inode_dataP5Inodei+0x3f>
  8026fc:	3b 50 08             	cmp    0x8(%eax),%edx
  8026ff:	7d 2e                	jge    80272f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  802701:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802707:	85 d2                	test   %edx,%edx
  802709:	0f 49 ca             	cmovns %edx,%ecx
  80270c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  80270f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  802713:	c1 e1 0c             	shl    $0xc,%ecx
  802716:	89 d0                	mov    %edx,%eax
  802718:	c1 f8 1f             	sar    $0x1f,%eax
  80271b:	c1 e8 14             	shr    $0x14,%eax
  80271e:	01 c2                	add    %eax,%edx
  802720:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802726:	29 c2                	sub    %eax,%edx
  802728:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  80272f:	89 c8                	mov    %ecx,%eax
  802731:	5d                   	pop    %ebp
  802732:	c3                   	ret    

00802733 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  802733:	55                   	push   %ebp
  802734:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  802736:	8b 48 08             	mov    0x8(%eax),%ecx
  802739:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  802741:	c7 82 80 00 00 00 0c 	movl   $0x80600c,0x80(%edx)
  802748:	60 80 00 
}
  80274b:	5d                   	pop    %ebp
  80274c:	c3                   	ret    

0080274d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802753:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  802759:	85 c0                	test   %eax,%eax
  80275b:	74 08                	je     802765 <_ZL9get_inodei+0x18>
  80275d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802763:	7e 20                	jle    802785 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  802765:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802769:	c7 44 24 08 2c 53 80 	movl   $0x80532c,0x8(%esp)
  802770:	00 
  802771:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  802778:	00 
  802779:	c7 04 24 42 53 80 00 	movl   $0x805342,(%esp)
  802780:	e8 b7 da ff ff       	call   80023c <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802785:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80278b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802791:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802797:	85 d2                	test   %edx,%edx
  802799:	0f 48 d1             	cmovs  %ecx,%edx
  80279c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  80279f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  8027a6:	c1 e0 0c             	shl    $0xc,%eax
}
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
  8027ae:	56                   	push   %esi
  8027af:	53                   	push   %ebx
  8027b0:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  8027b3:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  8027b9:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  8027bc:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  8027c2:	76 20                	jbe    8027e4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  8027c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027c8:	c7 44 24 08 68 53 80 	movl   $0x805368,0x8(%esp)
  8027cf:	00 
  8027d0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8027d7:	00 
  8027d8:	c7 04 24 42 53 80 00 	movl   $0x805342,(%esp)
  8027df:	e8 58 da ff ff       	call   80023c <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  8027e4:	83 fe 01             	cmp    $0x1,%esi
  8027e7:	7e 08                	jle    8027f1 <_ZL10bcache_ipcPvi+0x46>
  8027e9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  8027ef:	7d 12                	jge    802803 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8027f1:	89 f3                	mov    %esi,%ebx
  8027f3:	c1 e3 04             	shl    $0x4,%ebx
  8027f6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8027f8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  8027fe:	c1 e6 0c             	shl    $0xc,%esi
  802801:	eb 20                	jmp    802823 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  802803:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802807:	c7 44 24 08 98 53 80 	movl   $0x805398,0x8(%esp)
  80280e:	00 
  80280f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802816:	00 
  802817:	c7 04 24 42 53 80 00 	movl   $0x805342,(%esp)
  80281e:	e8 19 da ff ff       	call   80023c <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802823:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80282a:	00 
  80282b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802832:	00 
  802833:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802837:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  80283e:	e8 3c 22 00 00       	call   804a7f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802843:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80284a:	00 
  80284b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80284f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802856:	e8 95 21 00 00       	call   8049f0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  80285b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80285e:	74 c3                	je     802823 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  802860:	83 c4 10             	add    $0x10,%esp
  802863:	5b                   	pop    %ebx
  802864:	5e                   	pop    %esi
  802865:	5d                   	pop    %ebp
  802866:	c3                   	ret    

00802867 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
  80286a:	83 ec 28             	sub    $0x28,%esp
  80286d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802870:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802873:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802876:	89 c7                	mov    %eax,%edi
  802878:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  80287a:	c7 04 24 0d 2b 80 00 	movl   $0x802b0d,(%esp)
  802881:	e8 75 20 00 00       	call   8048fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  802886:	89 f8                	mov    %edi,%eax
  802888:	e8 c0 fe ff ff       	call   80274d <_ZL9get_inodei>
  80288d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  80288f:	ba 02 00 00 00       	mov    $0x2,%edx
  802894:	e8 12 ff ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
	if (r < 0) {
  802899:	85 c0                	test   %eax,%eax
  80289b:	79 08                	jns    8028a5 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  80289d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  8028a3:	eb 2e                	jmp    8028d3 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	75 1c                	jne    8028c5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  8028a9:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  8028af:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  8028b6:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  8028b9:	ba 06 00 00 00       	mov    $0x6,%edx
  8028be:	89 d8                	mov    %ebx,%eax
  8028c0:	e8 e6 fe ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  8028c5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  8028cc:	89 1e                	mov    %ebx,(%esi)
	return 0;
  8028ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8028d6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8028d9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8028dc:	89 ec                	mov    %ebp,%esp
  8028de:	5d                   	pop    %ebp
  8028df:	c3                   	ret    

008028e0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	57                   	push   %edi
  8028e4:	56                   	push   %esi
  8028e5:	53                   	push   %ebx
  8028e6:	83 ec 2c             	sub    $0x2c,%esp
  8028e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028ec:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  8028ef:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  8028f4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  8028fa:	0f 87 3d 01 00 00    	ja     802a3d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  802900:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802903:	8b 42 08             	mov    0x8(%edx),%eax
  802906:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  80290c:	85 c0                	test   %eax,%eax
  80290e:	0f 49 f0             	cmovns %eax,%esi
  802911:	c1 fe 0c             	sar    $0xc,%esi
  802914:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  802916:	8b 7d d8             	mov    -0x28(%ebp),%edi
  802919:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  80291f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  802922:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802925:	0f 82 a6 00 00 00    	jb     8029d1 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  80292b:	39 fe                	cmp    %edi,%esi
  80292d:	0f 8d f2 00 00 00    	jge    802a25 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802933:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  802937:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80293a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80293d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  802940:	83 3e 00             	cmpl   $0x0,(%esi)
  802943:	75 77                	jne    8029bc <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802945:	ba 02 00 00 00       	mov    $0x2,%edx
  80294a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80294f:	e8 57 fe ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802954:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  80295a:	83 f9 02             	cmp    $0x2,%ecx
  80295d:	7e 43                	jle    8029a2 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  80295f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802964:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  802969:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802970:	74 29                	je     80299b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802972:	e9 ce 00 00 00       	jmp    802a45 <_ZL14inode_set_sizeP5Inodej+0x165>
  802977:	89 c7                	mov    %eax,%edi
  802979:	0f b6 10             	movzbl (%eax),%edx
  80297c:	83 c0 01             	add    $0x1,%eax
  80297f:	84 d2                	test   %dl,%dl
  802981:	74 18                	je     80299b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802983:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802986:	ba 05 00 00 00       	mov    $0x5,%edx
  80298b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802990:	e8 16 fe ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802995:	85 db                	test   %ebx,%ebx
  802997:	79 1e                	jns    8029b7 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802999:	eb 07                	jmp    8029a2 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80299b:	83 c3 01             	add    $0x1,%ebx
  80299e:	39 d9                	cmp    %ebx,%ecx
  8029a0:	7f d5                	jg     802977 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  8029a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029a5:	8b 50 08             	mov    0x8(%eax),%edx
  8029a8:	e8 33 ff ff ff       	call   8028e0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  8029ad:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8029b2:	e9 86 00 00 00       	jmp    802a3d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  8029b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029ba:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  8029bc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  8029c0:	83 c6 04             	add    $0x4,%esi
  8029c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8029c9:	0f 8f 6e ff ff ff    	jg     80293d <_ZL14inode_set_sizeP5Inodej+0x5d>
  8029cf:	eb 54                	jmp    802a25 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  8029d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029d4:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  8029d9:	83 f8 01             	cmp    $0x1,%eax
  8029dc:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8029df:	ba 02 00 00 00       	mov    $0x2,%edx
  8029e4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8029e9:	e8 bd fd ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  8029ee:	39 f7                	cmp    %esi,%edi
  8029f0:	7d 24                	jge    802a16 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8029f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029f5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  8029f9:	8b 10                	mov    (%eax),%edx
  8029fb:	85 d2                	test   %edx,%edx
  8029fd:	74 0d                	je     802a0c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  8029ff:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  802a06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  802a0c:	83 eb 01             	sub    $0x1,%ebx
  802a0f:	83 e8 04             	sub    $0x4,%eax
  802a12:	39 fb                	cmp    %edi,%ebx
  802a14:	75 e3                	jne    8029f9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802a16:	ba 05 00 00 00       	mov    $0x5,%edx
  802a1b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802a20:	e8 86 fd ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  802a25:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a2b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  802a2e:	ba 04 00 00 00       	mov    $0x4,%edx
  802a33:	e8 73 fd ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
	return 0;
  802a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3d:	83 c4 2c             	add    $0x2c,%esp
  802a40:	5b                   	pop    %ebx
  802a41:	5e                   	pop    %esi
  802a42:	5f                   	pop    %edi
  802a43:	5d                   	pop    %ebp
  802a44:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802a45:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802a4c:	ba 05 00 00 00       	mov    $0x5,%edx
  802a51:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802a56:	e8 50 fd ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802a5b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802a60:	e9 52 ff ff ff       	jmp    8029b7 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802a65 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802a65:	55                   	push   %ebp
  802a66:	89 e5                	mov    %esp,%ebp
  802a68:	53                   	push   %ebx
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  802a6e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802a74:	83 e8 01             	sub    $0x1,%eax
  802a77:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  802a7d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802a81:	75 40                	jne    802ac3 <_ZL11inode_closeP5Inode+0x5e>
  802a83:	85 c0                	test   %eax,%eax
  802a85:	75 3c                	jne    802ac3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802a87:	ba 02 00 00 00       	mov    $0x2,%edx
  802a8c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802a91:	e8 15 fd ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802a96:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  802a9b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  802a9f:	85 d2                	test   %edx,%edx
  802aa1:	74 07                	je     802aaa <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  802aa3:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  802aaa:	83 c0 01             	add    $0x1,%eax
  802aad:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  802ab2:	75 e7                	jne    802a9b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802ab4:	ba 05 00 00 00       	mov    $0x5,%edx
  802ab9:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802abe:	e8 e8 fc ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  802ac3:	ba 03 00 00 00       	mov    $0x3,%edx
  802ac8:	89 d8                	mov    %ebx,%eax
  802aca:	e8 dc fc ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
}
  802acf:	83 c4 04             	add    $0x4,%esp
  802ad2:	5b                   	pop    %ebx
  802ad3:	5d                   	pop    %ebp
  802ad4:	c3                   	ret    

00802ad5 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ad5:	55                   	push   %ebp
  802ad6:	89 e5                	mov    %esp,%ebp
  802ad8:	53                   	push   %ebx
  802ad9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802adc:	8b 45 08             	mov    0x8(%ebp),%eax
  802adf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802ae5:	e8 7d fd ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  802aea:	89 c3                	mov    %eax,%ebx
  802aec:	85 c0                	test   %eax,%eax
  802aee:	78 15                	js     802b05 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  802af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	e8 e5 fd ff ff       	call   8028e0 <_ZL14inode_set_sizeP5Inodej>
  802afb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	e8 60 ff ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
	return r;
}
  802b05:	89 d8                	mov    %ebx,%eax
  802b07:	83 c4 14             	add    $0x14,%esp
  802b0a:	5b                   	pop    %ebx
  802b0b:	5d                   	pop    %ebp
  802b0c:	c3                   	ret    

00802b0d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  802b0d:	55                   	push   %ebp
  802b0e:	89 e5                	mov    %esp,%ebp
  802b10:	53                   	push   %ebx
  802b11:	83 ec 14             	sub    $0x14,%esp
  802b14:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  802b17:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  802b19:	89 c2                	mov    %eax,%edx
  802b1b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  802b21:	78 32                	js     802b55 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  802b23:	ba 00 00 00 00       	mov    $0x0,%edx
  802b28:	e8 7e fc ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 1c                	je     802b4d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  802b31:	c7 44 24 08 4d 53 80 	movl   $0x80534d,0x8(%esp)
  802b38:	00 
  802b39:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802b40:	00 
  802b41:	c7 04 24 42 53 80 00 	movl   $0x805342,(%esp)
  802b48:	e8 ef d6 ff ff       	call   80023c <_Z6_panicPKciS0_z>
    resume(utf);
  802b4d:	89 1c 24             	mov    %ebx,(%esp)
  802b50:	e8 7b 1e 00 00       	call   8049d0 <resume>
}
  802b55:	83 c4 14             	add    $0x14,%esp
  802b58:	5b                   	pop    %ebx
  802b59:	5d                   	pop    %ebp
  802b5a:	c3                   	ret    

00802b5b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  802b5b:	55                   	push   %ebp
  802b5c:	89 e5                	mov    %esp,%ebp
  802b5e:	83 ec 28             	sub    $0x28,%esp
  802b61:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802b64:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802b6a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802b6d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802b70:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802b73:	e8 ef fc ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  802b78:	85 c0                	test   %eax,%eax
  802b7a:	78 26                	js     802ba2 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  802b7c:	83 c3 10             	add    $0x10,%ebx
  802b7f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b83:	89 34 24             	mov    %esi,(%esp)
  802b86:	e8 ef dd ff ff       	call   80097a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802b8b:	89 f2                	mov    %esi,%edx
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	e8 9e fb ff ff       	call   802733 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	e8 c8 fe ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
	return 0;
  802b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802ba5:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802ba8:	89 ec                	mov    %ebp,%esp
  802baa:	5d                   	pop    %ebp
  802bab:	c3                   	ret    

00802bac <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  802bac:	55                   	push   %ebp
  802bad:	89 e5                	mov    %esp,%ebp
  802baf:	53                   	push   %ebx
  802bb0:	83 ec 24             	sub    $0x24,%esp
  802bb3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802bb6:	89 1c 24             	mov    %ebx,(%esp)
  802bb9:	e8 9e 15 00 00       	call   80415c <_Z7pagerefPv>
  802bbe:	89 c2                	mov    %eax,%edx
        return 0;
  802bc0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802bc5:	83 fa 01             	cmp    $0x1,%edx
  802bc8:	7f 1e                	jg     802be8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802bca:	8b 43 0c             	mov    0xc(%ebx),%eax
  802bcd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802bd0:	e8 92 fc ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	78 0f                	js     802be8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802be3:	e8 7d fe ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
}
  802be8:	83 c4 24             	add    $0x24,%esp
  802beb:	5b                   	pop    %ebx
  802bec:	5d                   	pop    %ebp
  802bed:	c3                   	ret    

00802bee <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802bee:	55                   	push   %ebp
  802bef:	89 e5                	mov    %esp,%ebp
  802bf1:	57                   	push   %edi
  802bf2:	56                   	push   %esi
  802bf3:	53                   	push   %ebx
  802bf4:	83 ec 3c             	sub    $0x3c,%esp
  802bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802bfa:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  802bfd:	8b 43 04             	mov    0x4(%ebx),%eax
  802c00:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802c03:	8b 43 0c             	mov    0xc(%ebx),%eax
  802c06:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802c09:	e8 59 fc ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	0f 88 8c 00 00 00    	js     802ca2 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802c16:	8b 53 04             	mov    0x4(%ebx),%edx
  802c19:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  802c1f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802c25:	29 d7                	sub    %edx,%edi
  802c27:	39 f7                	cmp    %esi,%edi
  802c29:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  802c2c:	85 ff                	test   %edi,%edi
  802c2e:	74 16                	je     802c46 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802c30:	8d 14 17             	lea    (%edi,%edx,1),%edx
  802c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c36:	3b 50 08             	cmp    0x8(%eax),%edx
  802c39:	76 6f                	jbe    802caa <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  802c3b:	e8 a0 fc ff ff       	call   8028e0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802c40:	85 c0                	test   %eax,%eax
  802c42:	79 66                	jns    802caa <_ZL13devfile_writeP2FdPKvj+0xbc>
  802c44:	eb 4e                	jmp    802c94 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802c46:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  802c4c:	76 24                	jbe    802c72 <_ZL13devfile_writeP2FdPKvj+0x84>
  802c4e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802c50:	8b 53 04             	mov    0x4(%ebx),%edx
  802c53:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5c:	3b 50 08             	cmp    0x8(%eax),%edx
  802c5f:	0f 86 83 00 00 00    	jbe    802ce8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802c65:	e8 76 fc ff ff       	call   8028e0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	79 7a                	jns    802ce8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  802c6e:	66 90                	xchg   %ax,%ax
  802c70:	eb 22                	jmp    802c94 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802c72:	85 f6                	test   %esi,%esi
  802c74:	74 1e                	je     802c94 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802c76:	89 f2                	mov    %esi,%edx
  802c78:	03 53 04             	add    0x4(%ebx),%edx
  802c7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7e:	3b 50 08             	cmp    0x8(%eax),%edx
  802c81:	0f 86 b8 00 00 00    	jbe    802d3f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802c87:	e8 54 fc ff ff       	call   8028e0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	0f 89 ab 00 00 00    	jns    802d3f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c97:	e8 c9 fd ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802c9c:	8b 43 04             	mov    0x4(%ebx),%eax
  802c9f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  802ca2:	83 c4 3c             	add    $0x3c,%esp
  802ca5:	5b                   	pop    %ebx
  802ca6:	5e                   	pop    %esi
  802ca7:	5f                   	pop    %edi
  802ca8:	5d                   	pop    %ebp
  802ca9:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  802caa:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802cac:	8b 53 04             	mov    0x4(%ebx),%edx
  802caf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb2:	e8 39 fa ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
  802cb7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  802cba:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cc8:	89 04 24             	mov    %eax,(%esp)
  802ccb:	e8 c7 de ff ff       	call   800b97 <memcpy>
        fd->fd_offset += n2;
  802cd0:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802cd3:	ba 04 00 00 00       	mov    $0x4,%edx
  802cd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cdb:	e8 cb fa ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802ce0:	01 7d 0c             	add    %edi,0xc(%ebp)
  802ce3:	e9 5e ff ff ff       	jmp    802c46 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802ce8:	8b 53 04             	mov    0x4(%ebx),%edx
  802ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cee:	e8 fd f9 ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
  802cf3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  802cf5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802cfc:	00 
  802cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d04:	89 34 24             	mov    %esi,(%esp)
  802d07:	e8 8b de ff ff       	call   800b97 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  802d0c:	ba 04 00 00 00       	mov    $0x4,%edx
  802d11:	89 f0                	mov    %esi,%eax
  802d13:	e8 93 fa ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  802d18:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  802d1e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802d25:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802d2c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802d32:	0f 87 18 ff ff ff    	ja     802c50 <_ZL13devfile_writeP2FdPKvj+0x62>
  802d38:	89 fe                	mov    %edi,%esi
  802d3a:	e9 33 ff ff ff       	jmp    802c72 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802d3f:	8b 53 04             	mov    0x4(%ebx),%edx
  802d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d45:	e8 a6 f9 ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
  802d4a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  802d4c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d57:	89 3c 24             	mov    %edi,(%esp)
  802d5a:	e8 38 de ff ff       	call   800b97 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  802d5f:	ba 04 00 00 00       	mov    $0x4,%edx
  802d64:	89 f8                	mov    %edi,%eax
  802d66:	e8 40 fa ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  802d6b:	01 73 04             	add    %esi,0x4(%ebx)
  802d6e:	e9 21 ff ff ff       	jmp    802c94 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802d73 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d73:	55                   	push   %ebp
  802d74:	89 e5                	mov    %esp,%ebp
  802d76:	57                   	push   %edi
  802d77:	56                   	push   %esi
  802d78:	53                   	push   %ebx
  802d79:	83 ec 3c             	sub    $0x3c,%esp
  802d7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802d7f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802d82:	8b 43 04             	mov    0x4(%ebx),%eax
  802d85:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802d88:	8b 43 0c             	mov    0xc(%ebx),%eax
  802d8b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802d8e:	e8 d4 fa ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  802d93:	85 c0                	test   %eax,%eax
  802d95:	0f 88 d3 00 00 00    	js     802e6e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  802d9b:	8b 73 04             	mov    0x4(%ebx),%esi
  802d9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da1:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802da4:	8b 50 08             	mov    0x8(%eax),%edx
  802da7:	29 f2                	sub    %esi,%edx
  802da9:	3b 48 08             	cmp    0x8(%eax),%ecx
  802dac:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  802daf:	89 f2                	mov    %esi,%edx
  802db1:	e8 3a f9 ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
  802db6:	85 c0                	test   %eax,%eax
  802db8:	0f 84 a2 00 00 00    	je     802e60 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802dbe:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802dc4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802dca:	29 f2                	sub    %esi,%edx
  802dcc:	39 d7                	cmp    %edx,%edi
  802dce:	0f 46 d7             	cmovbe %edi,%edx
  802dd1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802dd4:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802dd6:	01 d6                	add    %edx,%esi
  802dd8:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  802ddb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de6:	89 04 24             	mov    %eax,(%esp)
  802de9:	e8 a9 dd ff ff       	call   800b97 <memcpy>
    buf = (void *)((char *)buf + n2);
  802dee:	8b 75 0c             	mov    0xc(%ebp),%esi
  802df1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802df4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802dfa:	76 3e                	jbe    802e3a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  802dfc:	8b 53 04             	mov    0x4(%ebx),%edx
  802dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e02:	e8 e9 f8 ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
  802e07:	85 c0                	test   %eax,%eax
  802e09:	74 55                	je     802e60 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  802e0b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802e12:	00 
  802e13:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e17:	89 34 24             	mov    %esi,(%esp)
  802e1a:	e8 78 dd ff ff       	call   800b97 <memcpy>
        n -= PGSIZE;
  802e1f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802e25:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  802e2b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802e32:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802e38:	77 c2                	ja     802dfc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802e3a:	85 ff                	test   %edi,%edi
  802e3c:	74 22                	je     802e60 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  802e3e:	8b 53 04             	mov    0x4(%ebx),%edx
  802e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e44:	e8 a7 f8 ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	74 13                	je     802e60 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  802e4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e55:	89 34 24             	mov    %esi,(%esp)
  802e58:	e8 3a dd ff ff       	call   800b97 <memcpy>
        fd->fd_offset += n;
  802e5d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802e60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e63:	e8 fd fb ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802e68:	8b 43 04             	mov    0x4(%ebx),%eax
  802e6b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  802e6e:	83 c4 3c             	add    $0x3c,%esp
  802e71:	5b                   	pop    %ebx
  802e72:	5e                   	pop    %esi
  802e73:	5f                   	pop    %edi
  802e74:	5d                   	pop    %ebp
  802e75:	c3                   	ret    

00802e76 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802e76:	55                   	push   %ebp
  802e77:	89 e5                	mov    %esp,%ebp
  802e79:	57                   	push   %edi
  802e7a:	56                   	push   %esi
  802e7b:	53                   	push   %ebx
  802e7c:	83 ec 4c             	sub    $0x4c,%esp
  802e7f:	89 c6                	mov    %eax,%esi
  802e81:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802e84:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802e87:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  802e8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802e96:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802e99:	b8 01 00 00 00       	mov    $0x1,%eax
  802e9e:	e8 c4 f9 ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  802ea3:	89 c7                	mov    %eax,%edi
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	0f 88 cd 01 00 00    	js     80307a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802ead:	89 f3                	mov    %esi,%ebx
  802eaf:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802eb2:	75 08                	jne    802ebc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802eb4:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802eb7:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  802eba:	74 f8                	je     802eb4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  802ebc:	0f b6 03             	movzbl (%ebx),%eax
  802ebf:	3c 2f                	cmp    $0x2f,%al
  802ec1:	74 16                	je     802ed9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802ec3:	84 c0                	test   %al,%al
  802ec5:	74 12                	je     802ed9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802ec7:	89 da                	mov    %ebx,%edx
		++path;
  802ec9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  802ecc:	0f b6 02             	movzbl (%edx),%eax
  802ecf:	3c 2f                	cmp    $0x2f,%al
  802ed1:	74 08                	je     802edb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802ed3:	84 c0                	test   %al,%al
  802ed5:	75 f2                	jne    802ec9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802ed7:	eb 02                	jmp    802edb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802ed9:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  802edb:	89 d0                	mov    %edx,%eax
  802edd:	29 d8                	sub    %ebx,%eax
  802edf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802ee2:	0f b6 02             	movzbl (%edx),%eax
  802ee5:	89 d6                	mov    %edx,%esi
  802ee7:	3c 2f                	cmp    $0x2f,%al
  802ee9:	75 0a                	jne    802ef5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  802eeb:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  802eee:	0f b6 06             	movzbl (%esi),%eax
  802ef1:	3c 2f                	cmp    $0x2f,%al
  802ef3:	74 f6                	je     802eeb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802ef5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802ef9:	75 1b                	jne    802f16 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  802efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802efe:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802f01:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802f03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802f06:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  802f0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802f11:	e9 64 01 00 00       	jmp    80307a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802f16:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  802f1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1e:	74 06                	je     802f26 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802f20:	84 c0                	test   %al,%al
  802f22:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802f26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f29:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  802f2c:	83 3a 02             	cmpl   $0x2,(%edx)
  802f2f:	0f 85 f4 00 00 00    	jne    803029 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802f35:	89 d0                	mov    %edx,%eax
  802f37:	8b 52 08             	mov    0x8(%edx),%edx
  802f3a:	85 d2                	test   %edx,%edx
  802f3c:	7e 78                	jle    802fb6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  802f3e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802f45:	bf 00 00 00 00       	mov    $0x0,%edi
  802f4a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  802f4d:	89 fb                	mov    %edi,%ebx
  802f4f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802f52:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802f54:	89 da                	mov    %ebx,%edx
  802f56:	89 f0                	mov    %esi,%eax
  802f58:	e8 93 f7 ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
  802f5d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  802f5f:	83 38 00             	cmpl   $0x0,(%eax)
  802f62:	74 26                	je     802f8a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802f64:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f67:	3b 50 04             	cmp    0x4(%eax),%edx
  802f6a:	75 33                	jne    802f9f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  802f6c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802f70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f73:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f77:	8d 47 08             	lea    0x8(%edi),%eax
  802f7a:	89 04 24             	mov    %eax,(%esp)
  802f7d:	e8 56 dc ff ff       	call   800bd8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802f82:	85 c0                	test   %eax,%eax
  802f84:	0f 84 fa 00 00 00    	je     803084 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  802f8a:	83 3f 00             	cmpl   $0x0,(%edi)
  802f8d:	75 10                	jne    802f9f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  802f8f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f93:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802f96:	84 c0                	test   %al,%al
  802f98:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  802f9c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802f9f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802fa5:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802fa7:	8b 56 08             	mov    0x8(%esi),%edx
  802faa:	39 d0                	cmp    %edx,%eax
  802fac:	7c a6                	jl     802f54 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  802fae:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802fb1:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802fb4:	eb 07                	jmp    802fbd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802fb6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  802fbd:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802fc1:	74 6d                	je     803030 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802fc3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fc7:	75 24                	jne    802fed <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802fc9:	83 ea 80             	sub    $0xffffff80,%edx
  802fcc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fcf:	e8 0c f9 ff ff       	call   8028e0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	0f 88 90 00 00 00    	js     80306c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  802fdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fdf:	8b 50 08             	mov    0x8(%eax),%edx
  802fe2:	83 c2 80             	add    $0xffffff80,%edx
  802fe5:	e8 06 f7 ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
  802fea:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  802fed:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802ff4:	00 
  802ff5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802ffc:	00 
  802ffd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803000:	89 14 24             	mov    %edx,(%esp)
  803003:	e8 b9 da ff ff       	call   800ac1 <memset>
	empty->de_namelen = namelen;
  803008:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80300b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80300e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  803011:	89 54 24 08          	mov    %edx,0x8(%esp)
  803015:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803019:	83 c0 08             	add    $0x8,%eax
  80301c:	89 04 24             	mov    %eax,(%esp)
  80301f:	e8 73 db ff ff       	call   800b97 <memcpy>
	*de_store = empty;
  803024:	8b 7d cc             	mov    -0x34(%ebp),%edi
  803027:	eb 5e                	jmp    803087 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  803029:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80302e:	eb 42                	jmp    803072 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  803030:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  803035:	eb 3b                	jmp    803072 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  803037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80303d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80303f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803042:	89 38                	mov    %edi,(%eax)
			return 0;
  803044:	bf 00 00 00 00       	mov    $0x0,%edi
  803049:	eb 2f                	jmp    80307a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80304b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80304e:	8b 07                	mov    (%edi),%eax
  803050:	e8 12 f8 ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  803055:	85 c0                	test   %eax,%eax
  803057:	78 17                	js     803070 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  803059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305c:	e8 04 fa ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  803061:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803064:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  803067:	e9 41 fe ff ff       	jmp    802ead <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80306c:	89 c7                	mov    %eax,%edi
  80306e:	eb 02                	jmp    803072 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  803070:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  803072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803075:	e8 eb f9 ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
	return r;
}
  80307a:	89 f8                	mov    %edi,%eax
  80307c:	83 c4 4c             	add    $0x4c,%esp
  80307f:	5b                   	pop    %ebx
  803080:	5e                   	pop    %esi
  803081:	5f                   	pop    %edi
  803082:	5d                   	pop    %ebp
  803083:	c3                   	ret    
  803084:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  803087:	80 3e 00             	cmpb   $0x0,(%esi)
  80308a:	75 bf                	jne    80304b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80308c:	eb a9                	jmp    803037 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080308e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80308e:	55                   	push   %ebp
  80308f:	89 e5                	mov    %esp,%ebp
  803091:	57                   	push   %edi
  803092:	56                   	push   %esi
  803093:	53                   	push   %ebx
  803094:	83 ec 3c             	sub    $0x3c,%esp
  803097:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80309a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80309d:	89 04 24             	mov    %eax,(%esp)
  8030a0:	e8 62 f0 ff ff       	call   802107 <_Z14fd_find_unusedPP2Fd>
  8030a5:	89 c3                	mov    %eax,%ebx
  8030a7:	85 c0                	test   %eax,%eax
  8030a9:	0f 88 16 02 00 00    	js     8032c5 <_Z4openPKci+0x237>
  8030af:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030b6:	00 
  8030b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030c5:	e8 96 dd ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  8030ca:	89 c3                	mov    %eax,%ebx
  8030cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d1:	85 db                	test   %ebx,%ebx
  8030d3:	0f 88 ec 01 00 00    	js     8032c5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  8030d9:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  8030dd:	0f 84 ec 01 00 00    	je     8032cf <_Z4openPKci+0x241>
  8030e3:	83 c0 01             	add    $0x1,%eax
  8030e6:	83 f8 78             	cmp    $0x78,%eax
  8030e9:	75 ee                	jne    8030d9 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8030eb:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8030f0:	e9 b9 01 00 00       	jmp    8032ae <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8030f5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8030f8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8030fe:	89 3c 24             	mov    %edi,(%esp)
  803101:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  803104:	8d 55 e0             	lea    -0x20(%ebp),%edx
  803107:	89 f0                	mov    %esi,%eax
  803109:	e8 68 fd ff ff       	call   802e76 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80310e:	89 c3                	mov    %eax,%ebx
  803110:	85 c0                	test   %eax,%eax
  803112:	0f 85 96 01 00 00    	jne    8032ae <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  803118:	85 ff                	test   %edi,%edi
  80311a:	75 41                	jne    80315d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  80311c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  803124:	75 08                	jne    80312e <_Z4openPKci+0xa0>
            fileino = dirino;
  803126:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803129:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80312c:	eb 14                	jmp    803142 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80312e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  803131:	8b 00                	mov    (%eax),%eax
  803133:	e8 2f f7 ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  803138:	89 c3                	mov    %eax,%ebx
  80313a:	85 c0                	test   %eax,%eax
  80313c:	0f 88 5d 01 00 00    	js     80329f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  803142:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803145:	83 38 02             	cmpl   $0x2,(%eax)
  803148:	0f 85 d2 00 00 00    	jne    803220 <_Z4openPKci+0x192>
  80314e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  803152:	0f 84 c8 00 00 00    	je     803220 <_Z4openPKci+0x192>
  803158:	e9 38 01 00 00       	jmp    803295 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80315d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  803164:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80316b:	0f 8e a8 00 00 00    	jle    803219 <_Z4openPKci+0x18b>
  803171:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  803176:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  803179:	89 f8                	mov    %edi,%eax
  80317b:	e8 e7 f6 ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  803180:	89 c3                	mov    %eax,%ebx
  803182:	85 c0                	test   %eax,%eax
  803184:	0f 88 15 01 00 00    	js     80329f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80318a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80318d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803191:	75 68                	jne    8031fb <_Z4openPKci+0x16d>
  803193:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80319a:	75 5f                	jne    8031fb <_Z4openPKci+0x16d>
			*ino_store = ino;
  80319c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80319f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  8031a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031a8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  8031af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  8031b6:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  8031bd:	00 
  8031be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8031c5:	00 
  8031c6:	83 c0 0c             	add    $0xc,%eax
  8031c9:	89 04 24             	mov    %eax,(%esp)
  8031cc:	e8 f0 d8 ff ff       	call   800ac1 <memset>
        de->de_inum = fileino->i_inum;
  8031d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031d4:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  8031da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031dd:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  8031df:	ba 04 00 00 00       	mov    $0x4,%edx
  8031e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031e7:	e8 bf f5 ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  8031ec:	ba 04 00 00 00       	mov    $0x4,%edx
  8031f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f4:	e8 b2 f5 ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
  8031f9:	eb 25                	jmp    803220 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  8031fb:	e8 65 f8 ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  803200:	83 c7 01             	add    $0x1,%edi
  803203:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  803209:	0f 8c 67 ff ff ff    	jl     803176 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  80320f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  803214:	e9 86 00 00 00       	jmp    80329f <_Z4openPKci+0x211>
  803219:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  80321e:	eb 7f                	jmp    80329f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  803220:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  803227:	74 0d                	je     803236 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  803229:	ba 00 00 00 00       	mov    $0x0,%edx
  80322e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803231:	e8 aa f6 ff ff       	call   8028e0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  803236:	8b 15 0c 60 80 00    	mov    0x80600c,%edx
  80323c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  803241:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803244:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80324b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80324e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  803251:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803254:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80325a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80325d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803261:	83 c0 10             	add    $0x10,%eax
  803264:	89 04 24             	mov    %eax,(%esp)
  803267:	e8 0e d7 ff ff       	call   80097a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80326c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80326f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  803276:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803279:	e8 e7 f7 ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80327e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803281:	e8 df f7 ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  803286:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803289:	89 04 24             	mov    %eax,(%esp)
  80328c:	e8 13 ee ff ff       	call   8020a4 <_Z6fd2numP2Fd>
  803291:	89 c3                	mov    %eax,%ebx
  803293:	eb 30                	jmp    8032c5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  803295:	e8 cb f7 ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80329a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80329f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a2:	e8 be f7 ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
  8032a7:	eb 05                	jmp    8032ae <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8032a9:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  8032ae:	a1 00 70 80 00       	mov    0x807000,%eax
  8032b3:	8b 40 04             	mov    0x4(%eax),%eax
  8032b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8032bd:	89 04 24             	mov    %eax,(%esp)
  8032c0:	e8 58 dc ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  8032c5:	89 d8                	mov    %ebx,%eax
  8032c7:	83 c4 3c             	add    $0x3c,%esp
  8032ca:	5b                   	pop    %ebx
  8032cb:	5e                   	pop    %esi
  8032cc:	5f                   	pop    %edi
  8032cd:	5d                   	pop    %ebp
  8032ce:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  8032cf:	83 f8 78             	cmp    $0x78,%eax
  8032d2:	0f 85 1d fe ff ff    	jne    8030f5 <_Z4openPKci+0x67>
  8032d8:	eb cf                	jmp    8032a9 <_Z4openPKci+0x21b>

008032da <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
  8032dd:	53                   	push   %ebx
  8032de:	83 ec 24             	sub    $0x24,%esp
  8032e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  8032e4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	e8 78 f5 ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  8032ef:	85 c0                	test   %eax,%eax
  8032f1:	78 27                	js     80331a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  8032f3:	c7 44 24 04 60 53 80 	movl   $0x805360,0x4(%esp)
  8032fa:	00 
  8032fb:	89 1c 24             	mov    %ebx,(%esp)
  8032fe:	e8 77 d6 ff ff       	call   80097a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  803303:	89 da                	mov    %ebx,%edx
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	e8 26 f4 ff ff       	call   802733 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	e8 50 f7 ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
	return 0;
  803315:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331a:	83 c4 24             	add    $0x24,%esp
  80331d:	5b                   	pop    %ebx
  80331e:	5d                   	pop    %ebp
  80331f:	c3                   	ret    

00803320 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  803320:	55                   	push   %ebp
  803321:	89 e5                	mov    %esp,%ebp
  803323:	53                   	push   %ebx
  803324:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  803327:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80332e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  803331:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	e8 3a fb ff ff       	call   802e76 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80333c:	89 c3                	mov    %eax,%ebx
  80333e:	85 c0                	test   %eax,%eax
  803340:	78 5f                	js     8033a1 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  803342:	8d 55 f0             	lea    -0x10(%ebp),%edx
  803345:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	e8 18 f5 ff ff       	call   802867 <_ZL10inode_openiPP5Inode>
  80334f:	89 c3                	mov    %eax,%ebx
  803351:	85 c0                	test   %eax,%eax
  803353:	78 44                	js     803399 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  803355:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80335a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335d:	83 38 02             	cmpl   $0x2,(%eax)
  803360:	74 2f                	je     803391 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  803362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80336b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  803372:	ba 04 00 00 00       	mov    $0x4,%edx
  803377:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337a:	e8 2c f4 ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80337f:	ba 04 00 00 00       	mov    $0x4,%edx
  803384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803387:	e8 1f f4 ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
	r = 0;
  80338c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  803391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803394:	e8 cc f6 ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  803399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339c:	e8 c4 f6 ff ff       	call   802a65 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  8033a1:	89 d8                	mov    %ebx,%eax
  8033a3:	83 c4 24             	add    $0x24,%esp
  8033a6:	5b                   	pop    %ebx
  8033a7:	5d                   	pop    %ebp
  8033a8:	c3                   	ret    

008033a9 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  8033a9:	55                   	push   %ebp
  8033aa:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  8033ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b1:	5d                   	pop    %ebp
  8033b2:	c3                   	ret    

008033b3 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  8033b3:	55                   	push   %ebp
  8033b4:	89 e5                	mov    %esp,%ebp
  8033b6:	57                   	push   %edi
  8033b7:	56                   	push   %esi
  8033b8:	53                   	push   %ebx
  8033b9:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  8033bf:	c7 04 24 0d 2b 80 00 	movl   $0x802b0d,(%esp)
  8033c6:	e8 30 15 00 00       	call   8048fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  8033cb:	a1 00 10 00 50       	mov    0x50001000,%eax
  8033d0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  8033d5:	74 28                	je     8033ff <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  8033d7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  8033de:	4a 
  8033df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033e3:	c7 44 24 08 c8 53 80 	movl   $0x8053c8,0x8(%esp)
  8033ea:	00 
  8033eb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  8033f2:	00 
  8033f3:	c7 04 24 42 53 80 00 	movl   $0x805342,(%esp)
  8033fa:	e8 3d ce ff ff       	call   80023c <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  8033ff:	a1 04 10 00 50       	mov    0x50001004,%eax
  803404:	83 f8 03             	cmp    $0x3,%eax
  803407:	7f 1c                	jg     803425 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  803409:	c7 44 24 08 fc 53 80 	movl   $0x8053fc,0x8(%esp)
  803410:	00 
  803411:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  803418:	00 
  803419:	c7 04 24 42 53 80 00 	movl   $0x805342,(%esp)
  803420:	e8 17 ce ff ff       	call   80023c <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  803425:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  80342b:	85 d2                	test   %edx,%edx
  80342d:	7f 1c                	jg     80344b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  80342f:	c7 44 24 08 2c 54 80 	movl   $0x80542c,0x8(%esp)
  803436:	00 
  803437:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  80343e:	00 
  80343f:	c7 04 24 42 53 80 00 	movl   $0x805342,(%esp)
  803446:	e8 f1 cd ff ff       	call   80023c <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80344b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  803451:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  803457:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80345d:	85 c9                	test   %ecx,%ecx
  80345f:	0f 48 cb             	cmovs  %ebx,%ecx
  803462:	c1 f9 0c             	sar    $0xc,%ecx
  803465:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  803469:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80346f:	39 c8                	cmp    %ecx,%eax
  803471:	7c 13                	jl     803486 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  803473:	85 c0                	test   %eax,%eax
  803475:	7f 3d                	jg     8034b4 <_Z4fsckv+0x101>
  803477:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80347e:	00 00 00 
  803481:	e9 ac 00 00 00       	jmp    803532 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  803486:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80348c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  803490:	89 44 24 10          	mov    %eax,0x10(%esp)
  803494:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803498:	c7 44 24 08 5c 54 80 	movl   $0x80545c,0x8(%esp)
  80349f:	00 
  8034a0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  8034a7:	00 
  8034a8:	c7 04 24 42 53 80 00 	movl   $0x805342,(%esp)
  8034af:	e8 88 cd ff ff       	call   80023c <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8034b4:	be 00 20 00 50       	mov    $0x50002000,%esi
  8034b9:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  8034c0:	00 00 00 
  8034c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8034c8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  8034ce:	39 df                	cmp    %ebx,%edi
  8034d0:	7e 27                	jle    8034f9 <_Z4fsckv+0x146>
  8034d2:	0f b6 06             	movzbl (%esi),%eax
  8034d5:	84 c0                	test   %al,%al
  8034d7:	74 4b                	je     803524 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  8034d9:	0f be c0             	movsbl %al,%eax
  8034dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8034e4:	c7 04 24 a0 54 80 00 	movl   $0x8054a0,(%esp)
  8034eb:	e8 6a ce ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  8034f0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8034f7:	eb 2b                	jmp    803524 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  8034f9:	0f b6 06             	movzbl (%esi),%eax
  8034fc:	3c 01                	cmp    $0x1,%al
  8034fe:	76 24                	jbe    803524 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  803500:	0f be c0             	movsbl %al,%eax
  803503:	89 44 24 08          	mov    %eax,0x8(%esp)
  803507:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80350b:	c7 04 24 d4 54 80 00 	movl   $0x8054d4,(%esp)
  803512:	e8 43 ce ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  803517:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  80351e:	80 3e 00             	cmpb   $0x0,(%esi)
  803521:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  803524:	83 c3 01             	add    $0x1,%ebx
  803527:	83 c6 01             	add    $0x1,%esi
  80352a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  803530:	7f 9c                	jg     8034ce <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803532:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803539:	0f 8e e1 02 00 00    	jle    803820 <_Z4fsckv+0x46d>
  80353f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  803546:	00 00 00 
		struct Inode *ino = get_inode(i);
  803549:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80354f:	e8 f9 f1 ff ff       	call   80274d <_ZL9get_inodei>
  803554:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80355a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80355e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  803565:	75 22                	jne    803589 <_Z4fsckv+0x1d6>
  803567:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80356e:	0f 84 a9 06 00 00    	je     803c1d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  803574:	ba 00 00 00 00       	mov    $0x0,%edx
  803579:	e8 2d f2 ff ff       	call   8027ab <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80357e:	85 c0                	test   %eax,%eax
  803580:	74 3a                	je     8035bc <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  803582:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  803589:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80358f:	8b 02                	mov    (%edx),%eax
  803591:	83 f8 01             	cmp    $0x1,%eax
  803594:	74 26                	je     8035bc <_Z4fsckv+0x209>
  803596:	83 f8 02             	cmp    $0x2,%eax
  803599:	74 21                	je     8035bc <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80359b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80359f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8035a5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035a9:	c7 04 24 00 55 80 00 	movl   $0x805500,(%esp)
  8035b0:	e8 a5 cd ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  8035b5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  8035bc:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8035c3:	75 3f                	jne    803604 <_Z4fsckv+0x251>
  8035c5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8035cb:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8035cf:	75 15                	jne    8035e6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  8035d1:	c7 04 24 24 55 80 00 	movl   $0x805524,(%esp)
  8035d8:	e8 7d cd ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  8035dd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8035e4:	eb 1e                	jmp    803604 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  8035e6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8035ec:	83 3a 02             	cmpl   $0x2,(%edx)
  8035ef:	74 13                	je     803604 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8035f1:	c7 04 24 58 55 80 00 	movl   $0x805558,(%esp)
  8035f8:	e8 5d cd ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  8035fd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  803604:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  803609:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803610:	0f 84 93 00 00 00    	je     8036a9 <_Z4fsckv+0x2f6>
  803616:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  80361c:	8b 41 08             	mov    0x8(%ecx),%eax
  80361f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  803624:	7e 23                	jle    803649 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  803626:	89 44 24 08          	mov    %eax,0x8(%esp)
  80362a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803630:	89 44 24 04          	mov    %eax,0x4(%esp)
  803634:	c7 04 24 88 55 80 00 	movl   $0x805588,(%esp)
  80363b:	e8 1a cd ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  803640:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803647:	eb 09                	jmp    803652 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  803649:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803650:	74 4b                	je     80369d <_Z4fsckv+0x2ea>
  803652:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803658:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80365e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  803664:	74 23                	je     803689 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  803666:	89 44 24 08          	mov    %eax,0x8(%esp)
  80366a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803670:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803674:	c7 04 24 ac 55 80 00 	movl   $0x8055ac,(%esp)
  80367b:	e8 da cc ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  803680:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803687:	eb 09                	jmp    803692 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  803689:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803690:	74 12                	je     8036a4 <_Z4fsckv+0x2f1>
  803692:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803698:	8b 78 08             	mov    0x8(%eax),%edi
  80369b:	eb 0c                	jmp    8036a9 <_Z4fsckv+0x2f6>
  80369d:	bf 00 00 00 00       	mov    $0x0,%edi
  8036a2:	eb 05                	jmp    8036a9 <_Z4fsckv+0x2f6>
  8036a4:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  8036a9:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  8036ae:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8036b4:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8036b8:	89 d8                	mov    %ebx,%eax
  8036ba:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  8036bd:	39 c7                	cmp    %eax,%edi
  8036bf:	7e 2b                	jle    8036ec <_Z4fsckv+0x339>
  8036c1:	85 f6                	test   %esi,%esi
  8036c3:	75 27                	jne    8036ec <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  8036c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036cd:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8036d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036d7:	c7 04 24 d0 55 80 00 	movl   $0x8055d0,(%esp)
  8036de:	e8 77 cc ff ff       	call   80035a <_Z7cprintfPKcz>
				++errors;
  8036e3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8036ea:	eb 36                	jmp    803722 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  8036ec:	39 f8                	cmp    %edi,%eax
  8036ee:	7c 32                	jl     803722 <_Z4fsckv+0x36f>
  8036f0:	85 f6                	test   %esi,%esi
  8036f2:	74 2e                	je     803722 <_Z4fsckv+0x36f>
  8036f4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8036fb:	74 25                	je     803722 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8036fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803701:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803705:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80370b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80370f:	c7 04 24 14 56 80 00 	movl   $0x805614,(%esp)
  803716:	e8 3f cc ff ff       	call   80035a <_Z7cprintfPKcz>
				++errors;
  80371b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  803722:	85 f6                	test   %esi,%esi
  803724:	0f 84 a0 00 00 00    	je     8037ca <_Z4fsckv+0x417>
  80372a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803731:	0f 84 93 00 00 00    	je     8037ca <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  803737:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  80373d:	7e 27                	jle    803766 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  80373f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803743:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803747:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  80374d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803751:	c7 04 24 58 56 80 00 	movl   $0x805658,(%esp)
  803758:	e8 fd cb ff ff       	call   80035a <_Z7cprintfPKcz>
					++errors;
  80375d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803764:	eb 64                	jmp    8037ca <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  803766:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80376d:	3c 01                	cmp    $0x1,%al
  80376f:	75 27                	jne    803798 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  803771:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803775:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803779:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  80377f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803783:	c7 04 24 9c 56 80 00 	movl   $0x80569c,(%esp)
  80378a:	e8 cb cb ff ff       	call   80035a <_Z7cprintfPKcz>
					++errors;
  80378f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803796:	eb 32                	jmp    8037ca <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  803798:	3c ff                	cmp    $0xff,%al
  80379a:	75 27                	jne    8037c3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  80379c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8037a0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037a4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8037aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037ae:	c7 04 24 d8 56 80 00 	movl   $0x8056d8,(%esp)
  8037b5:	e8 a0 cb ff ff       	call   80035a <_Z7cprintfPKcz>
					++errors;
  8037ba:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8037c1:	eb 07                	jmp    8037ca <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  8037c3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  8037ca:	83 c3 01             	add    $0x1,%ebx
  8037cd:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  8037d3:	0f 85 d5 fe ff ff    	jne    8036ae <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  8037d9:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8037e0:	0f 94 c0             	sete   %al
  8037e3:	0f b6 c0             	movzbl %al,%eax
  8037e6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8037ec:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  8037f2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  8037f9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  803800:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803807:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  80380e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803814:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  80381a:	0f 8f 29 fd ff ff    	jg     803549 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803820:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803827:	0f 8e 7f 03 00 00    	jle    803bac <_Z4fsckv+0x7f9>
  80382d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  803832:	89 f0                	mov    %esi,%eax
  803834:	e8 14 ef ff ff       	call   80274d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  803839:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803840:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803847:	c1 e2 08             	shl    $0x8,%edx
  80384a:	09 ca                	or     %ecx,%edx
  80384c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803853:	c1 e1 10             	shl    $0x10,%ecx
  803856:	09 ca                	or     %ecx,%edx
  803858:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  80385f:	83 e1 7f             	and    $0x7f,%ecx
  803862:	c1 e1 18             	shl    $0x18,%ecx
  803865:	09 d1                	or     %edx,%ecx
  803867:	74 0e                	je     803877 <_Z4fsckv+0x4c4>
  803869:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803870:	78 05                	js     803877 <_Z4fsckv+0x4c4>
  803872:	83 38 02             	cmpl   $0x2,(%eax)
  803875:	74 1f                	je     803896 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803877:	83 c6 01             	add    $0x1,%esi
  80387a:	a1 08 10 00 50       	mov    0x50001008,%eax
  80387f:	39 f0                	cmp    %esi,%eax
  803881:	7f af                	jg     803832 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803883:	bb 01 00 00 00       	mov    $0x1,%ebx
  803888:	83 f8 01             	cmp    $0x1,%eax
  80388b:	0f 8f ad 02 00 00    	jg     803b3e <_Z4fsckv+0x78b>
  803891:	e9 16 03 00 00       	jmp    803bac <_Z4fsckv+0x7f9>
  803896:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  803898:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  80389f:	8b 40 08             	mov    0x8(%eax),%eax
  8038a2:	a8 7f                	test   $0x7f,%al
  8038a4:	74 23                	je     8038c9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  8038a6:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  8038ad:	00 
  8038ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8038b6:	c7 04 24 14 57 80 00 	movl   $0x805714,(%esp)
  8038bd:	e8 98 ca ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  8038c2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8038c9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  8038d0:	00 00 00 
  8038d3:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  8038d9:	e9 3d 02 00 00       	jmp    803b1b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  8038de:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8038e4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8038ea:	e8 01 ee ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
  8038ef:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  8038f1:	83 38 00             	cmpl   $0x0,(%eax)
  8038f4:	0f 84 15 02 00 00    	je     803b0f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  8038fa:	8b 40 04             	mov    0x4(%eax),%eax
  8038fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803900:	83 fa 76             	cmp    $0x76,%edx
  803903:	76 27                	jbe    80392c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  803905:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803909:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80390f:	89 44 24 08          	mov    %eax,0x8(%esp)
  803913:	89 74 24 04          	mov    %esi,0x4(%esp)
  803917:	c7 04 24 48 57 80 00 	movl   $0x805748,(%esp)
  80391e:	e8 37 ca ff ff       	call   80035a <_Z7cprintfPKcz>
				++errors;
  803923:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80392a:	eb 28                	jmp    803954 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  80392c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  803931:	74 21                	je     803954 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  803933:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803939:	89 54 24 08          	mov    %edx,0x8(%esp)
  80393d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803941:	c7 04 24 74 57 80 00 	movl   $0x805774,(%esp)
  803948:	e8 0d ca ff ff       	call   80035a <_Z7cprintfPKcz>
				++errors;
  80394d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803954:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  80395b:	00 
  80395c:	8d 43 08             	lea    0x8(%ebx),%eax
  80395f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803963:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803969:	89 0c 24             	mov    %ecx,(%esp)
  80396c:	e8 26 d2 ff ff       	call   800b97 <memcpy>
  803971:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803975:	bf 77 00 00 00       	mov    $0x77,%edi
  80397a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80397e:	85 ff                	test   %edi,%edi
  803980:	b8 00 00 00 00       	mov    $0x0,%eax
  803985:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803988:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80398f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803990:	8b 03                	mov    (%ebx),%eax
  803992:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803998:	7c 3e                	jl     8039d8 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80399a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80399e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8039a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039a8:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8039ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8039b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8039b6:	c7 04 24 a8 57 80 00 	movl   $0x8057a8,(%esp)
  8039bd:	e8 98 c9 ff ff       	call   80035a <_Z7cprintfPKcz>
				++errors;
  8039c2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8039c9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  8039d0:	00 00 00 
  8039d3:	e9 0b 01 00 00       	jmp    803ae3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  8039d8:	e8 70 ed ff ff       	call   80274d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  8039dd:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8039e4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  8039eb:	c1 e2 08             	shl    $0x8,%edx
  8039ee:	09 d1                	or     %edx,%ecx
  8039f0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  8039f7:	c1 e2 10             	shl    $0x10,%edx
  8039fa:	09 d1                	or     %edx,%ecx
  8039fc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803a03:	83 e2 7f             	and    $0x7f,%edx
  803a06:	c1 e2 18             	shl    $0x18,%edx
  803a09:	09 ca                	or     %ecx,%edx
  803a0b:	83 c2 01             	add    $0x1,%edx
  803a0e:	89 d1                	mov    %edx,%ecx
  803a10:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  803a16:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  803a1c:	0f b6 d5             	movzbl %ch,%edx
  803a1f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  803a25:	89 ca                	mov    %ecx,%edx
  803a27:	c1 ea 10             	shr    $0x10,%edx
  803a2a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  803a30:	c1 e9 18             	shr    $0x18,%ecx
  803a33:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803a3a:	83 e2 80             	and    $0xffffff80,%edx
  803a3d:	09 ca                	or     %ecx,%edx
  803a3f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803a45:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803a49:	0f 85 7a ff ff ff    	jne    8039c9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  803a4f:	8b 03                	mov    (%ebx),%eax
  803a51:	89 44 24 10          	mov    %eax,0x10(%esp)
  803a55:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803a5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a5f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803a65:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a69:	89 74 24 04          	mov    %esi,0x4(%esp)
  803a6d:	c7 04 24 d8 57 80 00 	movl   $0x8057d8,(%esp)
  803a74:	e8 e1 c8 ff ff       	call   80035a <_Z7cprintfPKcz>
					++errors;
  803a79:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803a80:	e9 44 ff ff ff       	jmp    8039c9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803a85:	3b 78 04             	cmp    0x4(%eax),%edi
  803a88:	75 52                	jne    803adc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  803a8a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803a8e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803a94:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a98:	83 c0 08             	add    $0x8,%eax
  803a9b:	89 04 24             	mov    %eax,(%esp)
  803a9e:	e8 35 d1 ff ff       	call   800bd8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803aa3:	85 c0                	test   %eax,%eax
  803aa5:	75 35                	jne    803adc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  803aa7:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803aad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803ab1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803ab7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803abb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803ac1:	89 54 24 08          	mov    %edx,0x8(%esp)
  803ac5:	89 74 24 04          	mov    %esi,0x4(%esp)
  803ac9:	c7 04 24 08 58 80 00 	movl   $0x805808,(%esp)
  803ad0:	e8 85 c8 ff ff       	call   80035a <_Z7cprintfPKcz>
					++errors;
  803ad5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  803adc:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  803ae3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803ae9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  803aef:	7e 1e                	jle    803b0f <_Z4fsckv+0x75c>
  803af1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803af5:	7f 18                	jg     803b0f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  803af7:	89 ca                	mov    %ecx,%edx
  803af9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803aff:	e8 ec eb ff ff       	call   8026f0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  803b04:	83 38 00             	cmpl   $0x0,(%eax)
  803b07:	0f 85 78 ff ff ff    	jne    803a85 <_Z4fsckv+0x6d2>
  803b0d:	eb cd                	jmp    803adc <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  803b0f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  803b15:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  803b1b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803b21:	83 ea 80             	sub    $0xffffff80,%edx
  803b24:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  803b2a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803b30:	3b 51 08             	cmp    0x8(%ecx),%edx
  803b33:	0f 8f e7 fc ff ff    	jg     803820 <_Z4fsckv+0x46d>
  803b39:	e9 a0 fd ff ff       	jmp    8038de <_Z4fsckv+0x52b>
  803b3e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803b44:	89 d8                	mov    %ebx,%eax
  803b46:	e8 02 ec ff ff       	call   80274d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  803b4b:	8b 50 04             	mov    0x4(%eax),%edx
  803b4e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803b55:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  803b5c:	c1 e7 08             	shl    $0x8,%edi
  803b5f:	09 f9                	or     %edi,%ecx
  803b61:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803b68:	c1 e7 10             	shl    $0x10,%edi
  803b6b:	09 f9                	or     %edi,%ecx
  803b6d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803b74:	83 e7 7f             	and    $0x7f,%edi
  803b77:	c1 e7 18             	shl    $0x18,%edi
  803b7a:	09 f9                	or     %edi,%ecx
  803b7c:	39 ca                	cmp    %ecx,%edx
  803b7e:	74 1b                	je     803b9b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803b80:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b84:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b88:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803b8c:	c7 04 24 38 58 80 00 	movl   $0x805838,(%esp)
  803b93:	e8 c2 c7 ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  803b98:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803b9b:	83 c3 01             	add    $0x1,%ebx
  803b9e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  803ba4:	7f 9e                	jg     803b44 <_Z4fsckv+0x791>
  803ba6:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803bac:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  803bb3:	7e 4f                	jle    803c04 <_Z4fsckv+0x851>
  803bb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  803bba:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  803bc0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  803bc7:	3c ff                	cmp    $0xff,%al
  803bc9:	75 09                	jne    803bd4 <_Z4fsckv+0x821>
			freemap[i] = 0;
  803bcb:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803bd2:	eb 1f                	jmp    803bf3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803bd4:	84 c0                	test   %al,%al
  803bd6:	75 1b                	jne    803bf3 <_Z4fsckv+0x840>
  803bd8:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  803bde:	7c 13                	jl     803bf3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803be0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803be4:	c7 04 24 64 58 80 00 	movl   $0x805864,(%esp)
  803beb:	e8 6a c7 ff ff       	call   80035a <_Z7cprintfPKcz>
			++errors;
  803bf0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803bf3:	83 c3 01             	add    $0x1,%ebx
  803bf6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  803bfc:	7f c2                	jg     803bc0 <_Z4fsckv+0x80d>
  803bfe:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803c04:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  803c0b:	19 c0                	sbb    %eax,%eax
  803c0d:	f7 d0                	not    %eax
  803c0f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  803c12:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  803c18:	5b                   	pop    %ebx
  803c19:	5e                   	pop    %esi
  803c1a:	5f                   	pop    %edi
  803c1b:	5d                   	pop    %ebp
  803c1c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  803c1d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803c24:	0f 84 92 f9 ff ff    	je     8035bc <_Z4fsckv+0x209>
  803c2a:	e9 5a f9 ff ff       	jmp    803589 <_Z4fsckv+0x1d6>
	...

00803c30 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c30:	55                   	push   %ebp
  803c31:	89 e5                	mov    %esp,%ebp
  803c33:	83 ec 18             	sub    $0x18,%esp
  803c36:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803c39:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c42:	89 04 24             	mov    %eax,(%esp)
  803c45:	e8 a2 e4 ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  803c4a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  803c4c:	c7 44 24 04 97 58 80 	movl   $0x805897,0x4(%esp)
  803c53:	00 
  803c54:	89 34 24             	mov    %esi,(%esp)
  803c57:	e8 1e cd ff ff       	call   80097a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  803c5c:	8b 43 04             	mov    0x4(%ebx),%eax
  803c5f:	2b 03                	sub    (%ebx),%eax
  803c61:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803c64:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  803c6b:	c7 86 80 00 00 00 28 	movl   $0x806028,0x80(%esi)
  803c72:	60 80 00 
	return 0;
}
  803c75:	b8 00 00 00 00       	mov    $0x0,%eax
  803c7a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803c7d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803c80:	89 ec                	mov    %ebp,%esp
  803c82:	5d                   	pop    %ebp
  803c83:	c3                   	ret    

00803c84 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803c84:	55                   	push   %ebp
  803c85:	89 e5                	mov    %esp,%ebp
  803c87:	53                   	push   %ebx
  803c88:	83 ec 14             	sub    $0x14,%esp
  803c8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803c8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803c92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c99:	e8 7f d2 ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  803c9e:	89 1c 24             	mov    %ebx,(%esp)
  803ca1:	e8 46 e4 ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  803ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
  803caa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803cb1:	e8 67 d2 ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
}
  803cb6:	83 c4 14             	add    $0x14,%esp
  803cb9:	5b                   	pop    %ebx
  803cba:	5d                   	pop    %ebp
  803cbb:	c3                   	ret    

00803cbc <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803cbc:	55                   	push   %ebp
  803cbd:	89 e5                	mov    %esp,%ebp
  803cbf:	57                   	push   %edi
  803cc0:	56                   	push   %esi
  803cc1:	53                   	push   %ebx
  803cc2:	83 ec 2c             	sub    $0x2c,%esp
  803cc5:	89 c7                	mov    %eax,%edi
  803cc7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  803cca:	a1 00 70 80 00       	mov    0x807000,%eax
  803ccf:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803cd2:	89 3c 24             	mov    %edi,(%esp)
  803cd5:	e8 82 04 00 00       	call   80415c <_Z7pagerefPv>
  803cda:	89 c3                	mov    %eax,%ebx
  803cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdf:	89 04 24             	mov    %eax,(%esp)
  803ce2:	e8 75 04 00 00       	call   80415c <_Z7pagerefPv>
  803ce7:	39 c3                	cmp    %eax,%ebx
  803ce9:	0f 94 c0             	sete   %al
  803cec:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  803cef:	8b 15 00 70 80 00    	mov    0x807000,%edx
  803cf5:	8b 52 58             	mov    0x58(%edx),%edx
  803cf8:	39 d6                	cmp    %edx,%esi
  803cfa:	75 08                	jne    803d04 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  803cfc:	83 c4 2c             	add    $0x2c,%esp
  803cff:	5b                   	pop    %ebx
  803d00:	5e                   	pop    %esi
  803d01:	5f                   	pop    %edi
  803d02:	5d                   	pop    %ebp
  803d03:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803d04:	85 c0                	test   %eax,%eax
  803d06:	74 c2                	je     803cca <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803d08:	c7 04 24 9e 58 80 00 	movl   $0x80589e,(%esp)
  803d0f:	e8 46 c6 ff ff       	call   80035a <_Z7cprintfPKcz>
  803d14:	eb b4                	jmp    803cca <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00803d16 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d16:	55                   	push   %ebp
  803d17:	89 e5                	mov    %esp,%ebp
  803d19:	57                   	push   %edi
  803d1a:	56                   	push   %esi
  803d1b:	53                   	push   %ebx
  803d1c:	83 ec 1c             	sub    $0x1c,%esp
  803d1f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803d22:	89 34 24             	mov    %esi,(%esp)
  803d25:	e8 c2 e3 ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  803d2a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803d2c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803d35:	75 46                	jne    803d7d <_ZL13devpipe_writeP2FdPKvj+0x67>
  803d37:	eb 52                	jmp    803d8b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803d39:	89 da                	mov    %ebx,%edx
  803d3b:	89 f0                	mov    %esi,%eax
  803d3d:	e8 7a ff ff ff       	call   803cbc <_ZL13_pipeisclosedP2FdP4Pipe>
  803d42:	85 c0                	test   %eax,%eax
  803d44:	75 49                	jne    803d8f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803d46:	e8 e1 d0 ff ff       	call   800e2c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  803d4b:	8b 43 04             	mov    0x4(%ebx),%eax
  803d4e:	89 c2                	mov    %eax,%edx
  803d50:	2b 13                	sub    (%ebx),%edx
  803d52:	83 fa 20             	cmp    $0x20,%edx
  803d55:	74 e2                	je     803d39 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d57:	89 c2                	mov    %eax,%edx
  803d59:	c1 fa 1f             	sar    $0x1f,%edx
  803d5c:	c1 ea 1b             	shr    $0x1b,%edx
  803d5f:	01 d0                	add    %edx,%eax
  803d61:	83 e0 1f             	and    $0x1f,%eax
  803d64:	29 d0                	sub    %edx,%eax
  803d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803d69:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  803d6d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803d71:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803d75:	83 c7 01             	add    $0x1,%edi
  803d78:	39 7d 10             	cmp    %edi,0x10(%ebp)
  803d7b:	76 0e                	jbe    803d8b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  803d7d:	8b 43 04             	mov    0x4(%ebx),%eax
  803d80:	89 c2                	mov    %eax,%edx
  803d82:	2b 13                	sub    (%ebx),%edx
  803d84:	83 fa 20             	cmp    $0x20,%edx
  803d87:	74 b0                	je     803d39 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803d89:	eb cc                	jmp    803d57 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  803d8b:	89 f8                	mov    %edi,%eax
  803d8d:	eb 05                	jmp    803d94 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  803d8f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803d94:	83 c4 1c             	add    $0x1c,%esp
  803d97:	5b                   	pop    %ebx
  803d98:	5e                   	pop    %esi
  803d99:	5f                   	pop    %edi
  803d9a:	5d                   	pop    %ebp
  803d9b:	c3                   	ret    

00803d9c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d9c:	55                   	push   %ebp
  803d9d:	89 e5                	mov    %esp,%ebp
  803d9f:	83 ec 28             	sub    $0x28,%esp
  803da2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803da5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803da8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803dab:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803dae:	89 3c 24             	mov    %edi,(%esp)
  803db1:	e8 36 e3 ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  803db6:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803db8:	be 00 00 00 00       	mov    $0x0,%esi
  803dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803dc1:	75 47                	jne    803e0a <_ZL12devpipe_readP2FdPvj+0x6e>
  803dc3:	eb 52                	jmp    803e17 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803dc5:	89 f0                	mov    %esi,%eax
  803dc7:	eb 5e                	jmp    803e27 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803dc9:	89 da                	mov    %ebx,%edx
  803dcb:	89 f8                	mov    %edi,%eax
  803dcd:	8d 76 00             	lea    0x0(%esi),%esi
  803dd0:	e8 e7 fe ff ff       	call   803cbc <_ZL13_pipeisclosedP2FdP4Pipe>
  803dd5:	85 c0                	test   %eax,%eax
  803dd7:	75 49                	jne    803e22 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803dd9:	e8 4e d0 ff ff       	call   800e2c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803dde:	8b 03                	mov    (%ebx),%eax
  803de0:	3b 43 04             	cmp    0x4(%ebx),%eax
  803de3:	74 e4                	je     803dc9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803de5:	89 c2                	mov    %eax,%edx
  803de7:	c1 fa 1f             	sar    $0x1f,%edx
  803dea:	c1 ea 1b             	shr    $0x1b,%edx
  803ded:	01 d0                	add    %edx,%eax
  803def:	83 e0 1f             	and    $0x1f,%eax
  803df2:	29 d0                	sub    %edx,%eax
  803df4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  803dfc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  803dff:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803e02:	83 c6 01             	add    $0x1,%esi
  803e05:	39 75 10             	cmp    %esi,0x10(%ebp)
  803e08:	76 0d                	jbe    803e17 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  803e0a:	8b 03                	mov    (%ebx),%eax
  803e0c:	3b 43 04             	cmp    0x4(%ebx),%eax
  803e0f:	75 d4                	jne    803de5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803e11:	85 f6                	test   %esi,%esi
  803e13:	75 b0                	jne    803dc5 <_ZL12devpipe_readP2FdPvj+0x29>
  803e15:	eb b2                	jmp    803dc9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803e17:	89 f0                	mov    %esi,%eax
  803e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803e20:	eb 05                	jmp    803e27 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803e22:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803e27:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803e2a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803e2d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803e30:	89 ec                	mov    %ebp,%esp
  803e32:	5d                   	pop    %ebp
  803e33:	c3                   	ret    

00803e34 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e34:	55                   	push   %ebp
  803e35:	89 e5                	mov    %esp,%ebp
  803e37:	83 ec 48             	sub    $0x48,%esp
  803e3a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803e3d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803e40:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803e43:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803e46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803e49:	89 04 24             	mov    %eax,(%esp)
  803e4c:	e8 b6 e2 ff ff       	call   802107 <_Z14fd_find_unusedPP2Fd>
  803e51:	89 c3                	mov    %eax,%ebx
  803e53:	85 c0                	test   %eax,%eax
  803e55:	0f 88 0b 01 00 00    	js     803f66 <_Z4pipePi+0x132>
  803e5b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803e62:	00 
  803e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e66:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e71:	e8 ea cf ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  803e76:	89 c3                	mov    %eax,%ebx
  803e78:	85 c0                	test   %eax,%eax
  803e7a:	0f 89 f5 00 00 00    	jns    803f75 <_Z4pipePi+0x141>
  803e80:	e9 e1 00 00 00       	jmp    803f66 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803e85:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803e8c:	00 
  803e8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e90:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e9b:	e8 c0 cf ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  803ea0:	89 c3                	mov    %eax,%ebx
  803ea2:	85 c0                	test   %eax,%eax
  803ea4:	0f 89 e2 00 00 00    	jns    803f8c <_Z4pipePi+0x158>
  803eaa:	e9 a4 00 00 00       	jmp    803f53 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eb2:	89 04 24             	mov    %eax,(%esp)
  803eb5:	e8 32 e2 ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  803eba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803ec1:	00 
  803ec2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ec6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803ecd:	00 
  803ece:	89 74 24 04          	mov    %esi,0x4(%esp)
  803ed2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ed9:	e8 e1 cf ff ff       	call   800ebf <_Z12sys_page_mapiPviS_i>
  803ede:	89 c3                	mov    %eax,%ebx
  803ee0:	85 c0                	test   %eax,%eax
  803ee2:	78 4c                	js     803f30 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ee4:	8b 15 28 60 80 00    	mov    0x806028,%edx
  803eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803eef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803ef9:	8b 15 28 60 80 00    	mov    0x806028,%edx
  803eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f02:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803f04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f07:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f11:	89 04 24             	mov    %eax,(%esp)
  803f14:	e8 8b e1 ff ff       	call   8020a4 <_Z6fd2numP2Fd>
  803f19:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  803f1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f1e:	89 04 24             	mov    %eax,(%esp)
  803f21:	e8 7e e1 ff ff       	call   8020a4 <_Z6fd2numP2Fd>
  803f26:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803f29:	bb 00 00 00 00       	mov    $0x0,%ebx
  803f2e:	eb 36                	jmp    803f66 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803f30:	89 74 24 04          	mov    %esi,0x4(%esp)
  803f34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f3b:	e8 dd cf ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803f40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f43:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f4e:	e8 ca cf ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f56:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f61:	e8 b7 cf ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803f66:	89 d8                	mov    %ebx,%eax
  803f68:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803f6b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803f6e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803f71:	89 ec                	mov    %ebp,%esp
  803f73:	5d                   	pop    %ebp
  803f74:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803f75:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803f78:	89 04 24             	mov    %eax,(%esp)
  803f7b:	e8 87 e1 ff ff       	call   802107 <_Z14fd_find_unusedPP2Fd>
  803f80:	89 c3                	mov    %eax,%ebx
  803f82:	85 c0                	test   %eax,%eax
  803f84:	0f 89 fb fe ff ff    	jns    803e85 <_Z4pipePi+0x51>
  803f8a:	eb c7                	jmp    803f53 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8f:	89 04 24             	mov    %eax,(%esp)
  803f92:	e8 55 e1 ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  803f97:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f99:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803fa0:	00 
  803fa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fa5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803fac:	e8 af ce ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  803fb1:	89 c3                	mov    %eax,%ebx
  803fb3:	85 c0                	test   %eax,%eax
  803fb5:	0f 89 f4 fe ff ff    	jns    803eaf <_Z4pipePi+0x7b>
  803fbb:	eb 83                	jmp    803f40 <_Z4pipePi+0x10c>

00803fbd <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  803fbd:	55                   	push   %ebp
  803fbe:	89 e5                	mov    %esp,%ebp
  803fc0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803fc3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803fca:	00 
  803fcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803fce:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd5:	89 04 24             	mov    %eax,(%esp)
  803fd8:	e8 74 e0 ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  803fdd:	85 c0                	test   %eax,%eax
  803fdf:	78 15                	js     803ff6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe4:	89 04 24             	mov    %eax,(%esp)
  803fe7:	e8 00 e1 ff ff       	call   8020ec <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  803fec:	89 c2                	mov    %eax,%edx
  803fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ff1:	e8 c6 fc ff ff       	call   803cbc <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803ff6:	c9                   	leave  
  803ff7:	c3                   	ret    

00803ff8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803ff8:	55                   	push   %ebp
  803ff9:	89 e5                	mov    %esp,%ebp
  803ffb:	53                   	push   %ebx
  803ffc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  803fff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804002:	89 04 24             	mov    %eax,(%esp)
  804005:	e8 fd e0 ff ff       	call   802107 <_Z14fd_find_unusedPP2Fd>
  80400a:	89 c3                	mov    %eax,%ebx
  80400c:	85 c0                	test   %eax,%eax
  80400e:	0f 88 be 00 00 00    	js     8040d2 <_Z18pipe_ipc_recv_readv+0xda>
  804014:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80401b:	00 
  80401c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80401f:	89 44 24 04          	mov    %eax,0x4(%esp)
  804023:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80402a:	e8 31 ce ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  80402f:	89 c3                	mov    %eax,%ebx
  804031:	85 c0                	test   %eax,%eax
  804033:	0f 89 a1 00 00 00    	jns    8040da <_Z18pipe_ipc_recv_readv+0xe2>
  804039:	e9 94 00 00 00       	jmp    8040d2 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80403e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804041:	85 c0                	test   %eax,%eax
  804043:	75 0e                	jne    804053 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  804045:	c7 04 24 fc 58 80 00 	movl   $0x8058fc,(%esp)
  80404c:	e8 09 c3 ff ff       	call   80035a <_Z7cprintfPKcz>
  804051:	eb 10                	jmp    804063 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  804053:	89 44 24 04          	mov    %eax,0x4(%esp)
  804057:	c7 04 24 b1 58 80 00 	movl   $0x8058b1,(%esp)
  80405e:	e8 f7 c2 ff ff       	call   80035a <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  804063:	c7 04 24 bb 58 80 00 	movl   $0x8058bb,(%esp)
  80406a:	e8 eb c2 ff ff       	call   80035a <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80406f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804072:	a8 04                	test   $0x4,%al
  804074:	74 04                	je     80407a <_Z18pipe_ipc_recv_readv+0x82>
  804076:	a8 01                	test   $0x1,%al
  804078:	75 24                	jne    80409e <_Z18pipe_ipc_recv_readv+0xa6>
  80407a:	c7 44 24 0c ce 58 80 	movl   $0x8058ce,0xc(%esp)
  804081:	00 
  804082:	c7 44 24 08 66 52 80 	movl   $0x805266,0x8(%esp)
  804089:	00 
  80408a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  804091:	00 
  804092:	c7 04 24 eb 58 80 00 	movl   $0x8058eb,(%esp)
  804099:	e8 9e c1 ff ff       	call   80023c <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80409e:	8b 15 28 60 80 00    	mov    0x806028,%edx
  8040a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a7:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  8040a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  8040b3:	89 04 24             	mov    %eax,(%esp)
  8040b6:	e8 e9 df ff ff       	call   8020a4 <_Z6fd2numP2Fd>
  8040bb:	89 c3                	mov    %eax,%ebx
  8040bd:	eb 13                	jmp    8040d2 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  8040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8040cd:	e8 4b ce ff ff       	call   800f1d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  8040d2:	89 d8                	mov    %ebx,%eax
  8040d4:	83 c4 24             	add    $0x24,%esp
  8040d7:	5b                   	pop    %ebx
  8040d8:	5d                   	pop    %ebp
  8040d9:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  8040da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040dd:	89 04 24             	mov    %eax,(%esp)
  8040e0:	e8 07 e0 ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  8040e5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8040e8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8040ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8040f3:	89 04 24             	mov    %eax,(%esp)
  8040f6:	e8 f5 08 00 00       	call   8049f0 <_Z8ipc_recvPiPvS_>
  8040fb:	89 c3                	mov    %eax,%ebx
  8040fd:	85 c0                	test   %eax,%eax
  8040ff:	0f 89 39 ff ff ff    	jns    80403e <_Z18pipe_ipc_recv_readv+0x46>
  804105:	eb b8                	jmp    8040bf <_Z18pipe_ipc_recv_readv+0xc7>

00804107 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  804107:	55                   	push   %ebp
  804108:	89 e5                	mov    %esp,%ebp
  80410a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80410d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804114:	00 
  804115:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80411c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80411f:	89 04 24             	mov    %eax,(%esp)
  804122:	e8 2a df ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  804127:	85 c0                	test   %eax,%eax
  804129:	78 2f                	js     80415a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80412b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80412e:	89 04 24             	mov    %eax,(%esp)
  804131:	e8 b6 df ff ff       	call   8020ec <_Z7fd2dataP2Fd>
  804136:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80413d:	00 
  80413e:	89 44 24 08          	mov    %eax,0x8(%esp)
  804142:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  804149:	00 
  80414a:	8b 45 08             	mov    0x8(%ebp),%eax
  80414d:	89 04 24             	mov    %eax,(%esp)
  804150:	e8 2a 09 00 00       	call   804a7f <_Z8ipc_sendijPvi>
    return 0;
  804155:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80415a:	c9                   	leave  
  80415b:	c3                   	ret    

0080415c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80415c:	55                   	push   %ebp
  80415d:	89 e5                	mov    %esp,%ebp
  80415f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  804162:	89 d0                	mov    %edx,%eax
  804164:	c1 e8 16             	shr    $0x16,%eax
  804167:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  80416e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  804173:	f6 c1 01             	test   $0x1,%cl
  804176:	74 1d                	je     804195 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  804178:	c1 ea 0c             	shr    $0xc,%edx
  80417b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  804182:	f6 c2 01             	test   $0x1,%dl
  804185:	74 0e                	je     804195 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  804187:	c1 ea 0c             	shr    $0xc,%edx
  80418a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  804191:	ef 
  804192:	0f b7 c0             	movzwl %ax,%eax
}
  804195:	5d                   	pop    %ebp
  804196:	c3                   	ret    
	...

008041a0 <_Z4waiti>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8041a0:	55                   	push   %ebp
  8041a1:	89 e5                	mov    %esp,%ebp
  8041a3:	56                   	push   %esi
  8041a4:	53                   	push   %ebx
  8041a5:	83 ec 10             	sub    $0x10,%esp
  8041a8:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8041ab:	85 f6                	test   %esi,%esi
  8041ad:	75 24                	jne    8041d3 <_Z4waiti+0x33>
  8041af:	c7 44 24 0c 1f 59 80 	movl   $0x80591f,0xc(%esp)
  8041b6:	00 
  8041b7:	c7 44 24 08 66 52 80 	movl   $0x805266,0x8(%esp)
  8041be:	00 
  8041bf:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8041c6:	00 
  8041c7:	c7 04 24 2a 59 80 00 	movl   $0x80592a,(%esp)
  8041ce:	e8 69 c0 ff ff       	call   80023c <_Z6_panicPKciS0_z>
	e = &envs[ENVX(envid)];
  8041d3:	89 f3                	mov    %esi,%ebx
  8041d5:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8041db:	6b db 78             	imul   $0x78,%ebx,%ebx
  8041de:	8b 83 04 00 00 ef    	mov    -0x10fffffc(%ebx),%eax
  8041e4:	39 f0                	cmp    %esi,%eax
  8041e6:	75 11                	jne    8041f9 <_Z4waiti+0x59>
  8041e8:	8b 83 0c 00 00 ef    	mov    -0x10fffff4(%ebx),%eax
  8041ee:	85 c0                	test   %eax,%eax
  8041f0:	74 07                	je     8041f9 <_Z4waiti+0x59>
		sys_yield();
  8041f2:	e8 35 cc ff ff       	call   800e2c <_Z9sys_yieldv>
  8041f7:	eb e5                	jmp    8041de <_Z4waiti+0x3e>
}
  8041f9:	83 c4 10             	add    $0x10,%esp
  8041fc:	5b                   	pop    %ebx
  8041fd:	5e                   	pop    %esi
  8041fe:	5d                   	pop    %ebp
  8041ff:	90                   	nop
  804200:	c3                   	ret    
	...

00804210 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  804210:	55                   	push   %ebp
  804211:	89 e5                	mov    %esp,%ebp
  804213:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  804216:	c7 44 24 04 35 59 80 	movl   $0x805935,0x4(%esp)
  80421d:	00 
  80421e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804221:	89 04 24             	mov    %eax,(%esp)
  804224:	e8 51 c7 ff ff       	call   80097a <_Z6strcpyPcPKc>
	return 0;
}
  804229:	b8 00 00 00 00       	mov    $0x0,%eax
  80422e:	c9                   	leave  
  80422f:	c3                   	ret    

00804230 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  804230:	55                   	push   %ebp
  804231:	89 e5                	mov    %esp,%ebp
  804233:	53                   	push   %ebx
  804234:	83 ec 14             	sub    $0x14,%esp
  804237:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80423a:	89 1c 24             	mov    %ebx,(%esp)
  80423d:	e8 1a ff ff ff       	call   80415c <_Z7pagerefPv>
  804242:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  804244:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  804249:	83 fa 01             	cmp    $0x1,%edx
  80424c:	75 0b                	jne    804259 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80424e:	8b 43 0c             	mov    0xc(%ebx),%eax
  804251:	89 04 24             	mov    %eax,(%esp)
  804254:	e8 fe 02 00 00       	call   804557 <_Z11nsipc_closei>
	else
		return 0;
}
  804259:	83 c4 14             	add    $0x14,%esp
  80425c:	5b                   	pop    %ebx
  80425d:	5d                   	pop    %ebp
  80425e:	c3                   	ret    

0080425f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80425f:	55                   	push   %ebp
  804260:	89 e5                	mov    %esp,%ebp
  804262:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804265:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80426c:	00 
  80426d:	8b 45 10             	mov    0x10(%ebp),%eax
  804270:	89 44 24 08          	mov    %eax,0x8(%esp)
  804274:	8b 45 0c             	mov    0xc(%ebp),%eax
  804277:	89 44 24 04          	mov    %eax,0x4(%esp)
  80427b:	8b 45 08             	mov    0x8(%ebp),%eax
  80427e:	8b 40 0c             	mov    0xc(%eax),%eax
  804281:	89 04 24             	mov    %eax,(%esp)
  804284:	e8 c9 03 00 00       	call   804652 <_Z10nsipc_sendiPKvij>
}
  804289:	c9                   	leave  
  80428a:	c3                   	ret    

0080428b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80428b:	55                   	push   %ebp
  80428c:	89 e5                	mov    %esp,%ebp
  80428e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  804291:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  804298:	00 
  804299:	8b 45 10             	mov    0x10(%ebp),%eax
  80429c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8042a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8042ad:	89 04 24             	mov    %eax,(%esp)
  8042b0:	e8 1d 03 00 00       	call   8045d2 <_Z10nsipc_recviPvij>
}
  8042b5:	c9                   	leave  
  8042b6:	c3                   	ret    

008042b7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8042b7:	55                   	push   %ebp
  8042b8:	89 e5                	mov    %esp,%ebp
  8042ba:	83 ec 28             	sub    $0x28,%esp
  8042bd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8042c0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8042c3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  8042c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8042c8:	89 04 24             	mov    %eax,(%esp)
  8042cb:	e8 37 de ff ff       	call   802107 <_Z14fd_find_unusedPP2Fd>
  8042d0:	89 c3                	mov    %eax,%ebx
  8042d2:	85 c0                	test   %eax,%eax
  8042d4:	78 21                	js     8042f7 <_ZL12alloc_sockfdi+0x40>
  8042d6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8042dd:	00 
  8042de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8042ec:	e8 6f cb ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  8042f1:	89 c3                	mov    %eax,%ebx
  8042f3:	85 c0                	test   %eax,%eax
  8042f5:	79 14                	jns    80430b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8042f7:	89 34 24             	mov    %esi,(%esp)
  8042fa:	e8 58 02 00 00       	call   804557 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  8042ff:	89 d8                	mov    %ebx,%eax
  804301:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  804304:	8b 75 fc             	mov    -0x4(%ebp),%esi
  804307:	89 ec                	mov    %ebp,%esp
  804309:	5d                   	pop    %ebp
  80430a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  80430b:	8b 15 44 60 80 00    	mov    0x806044,%edx
  804311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804314:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  804316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804319:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  804320:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  804323:	89 04 24             	mov    %eax,(%esp)
  804326:	e8 79 dd ff ff       	call   8020a4 <_Z6fd2numP2Fd>
  80432b:	89 c3                	mov    %eax,%ebx
  80432d:	eb d0                	jmp    8042ff <_ZL12alloc_sockfdi+0x48>

0080432f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80432f:	55                   	push   %ebp
  804330:	89 e5                	mov    %esp,%ebp
  804332:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  804335:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80433c:	00 
  80433d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  804340:	89 54 24 04          	mov    %edx,0x4(%esp)
  804344:	89 04 24             	mov    %eax,(%esp)
  804347:	e8 05 dd ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  80434c:	85 c0                	test   %eax,%eax
  80434e:	78 15                	js     804365 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  804350:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  804353:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  804358:	8b 0d 44 60 80 00    	mov    0x806044,%ecx
  80435e:	39 0a                	cmp    %ecx,(%edx)
  804360:	75 03                	jne    804365 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  804362:	8b 42 0c             	mov    0xc(%edx),%eax
}
  804365:	c9                   	leave  
  804366:	c3                   	ret    

00804367 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804367:	55                   	push   %ebp
  804368:	89 e5                	mov    %esp,%ebp
  80436a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80436d:	8b 45 08             	mov    0x8(%ebp),%eax
  804370:	e8 ba ff ff ff       	call   80432f <_ZL9fd2sockidi>
  804375:	85 c0                	test   %eax,%eax
  804377:	78 1f                	js     804398 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804379:	8b 55 10             	mov    0x10(%ebp),%edx
  80437c:	89 54 24 08          	mov    %edx,0x8(%esp)
  804380:	8b 55 0c             	mov    0xc(%ebp),%edx
  804383:	89 54 24 04          	mov    %edx,0x4(%esp)
  804387:	89 04 24             	mov    %eax,(%esp)
  80438a:	e8 19 01 00 00       	call   8044a8 <_Z12nsipc_acceptiP8sockaddrPj>
  80438f:	85 c0                	test   %eax,%eax
  804391:	78 05                	js     804398 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  804393:	e8 1f ff ff ff       	call   8042b7 <_ZL12alloc_sockfdi>
}
  804398:	c9                   	leave  
  804399:	c3                   	ret    

0080439a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80439a:	55                   	push   %ebp
  80439b:	89 e5                	mov    %esp,%ebp
  80439d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8043a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8043a3:	e8 87 ff ff ff       	call   80432f <_ZL9fd2sockidi>
  8043a8:	85 c0                	test   %eax,%eax
  8043aa:	78 16                	js     8043c2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8043ac:	8b 55 10             	mov    0x10(%ebp),%edx
  8043af:	89 54 24 08          	mov    %edx,0x8(%esp)
  8043b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8043ba:	89 04 24             	mov    %eax,(%esp)
  8043bd:	e8 34 01 00 00       	call   8044f6 <_Z10nsipc_bindiP8sockaddrj>
}
  8043c2:	c9                   	leave  
  8043c3:	c3                   	ret    

008043c4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  8043c4:	55                   	push   %ebp
  8043c5:	89 e5                	mov    %esp,%ebp
  8043c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8043ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8043cd:	e8 5d ff ff ff       	call   80432f <_ZL9fd2sockidi>
  8043d2:	85 c0                	test   %eax,%eax
  8043d4:	78 0f                	js     8043e5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8043d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8043dd:	89 04 24             	mov    %eax,(%esp)
  8043e0:	e8 50 01 00 00       	call   804535 <_Z14nsipc_shutdownii>
}
  8043e5:	c9                   	leave  
  8043e6:	c3                   	ret    

008043e7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8043e7:	55                   	push   %ebp
  8043e8:	89 e5                	mov    %esp,%ebp
  8043ea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8043ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8043f0:	e8 3a ff ff ff       	call   80432f <_ZL9fd2sockidi>
  8043f5:	85 c0                	test   %eax,%eax
  8043f7:	78 16                	js     80440f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8043f9:	8b 55 10             	mov    0x10(%ebp),%edx
  8043fc:	89 54 24 08          	mov    %edx,0x8(%esp)
  804400:	8b 55 0c             	mov    0xc(%ebp),%edx
  804403:	89 54 24 04          	mov    %edx,0x4(%esp)
  804407:	89 04 24             	mov    %eax,(%esp)
  80440a:	e8 62 01 00 00       	call   804571 <_Z13nsipc_connectiPK8sockaddrj>
}
  80440f:	c9                   	leave  
  804410:	c3                   	ret    

00804411 <_Z6listenii>:

int
listen(int s, int backlog)
{
  804411:	55                   	push   %ebp
  804412:	89 e5                	mov    %esp,%ebp
  804414:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  804417:	8b 45 08             	mov    0x8(%ebp),%eax
  80441a:	e8 10 ff ff ff       	call   80432f <_ZL9fd2sockidi>
  80441f:	85 c0                	test   %eax,%eax
  804421:	78 0f                	js     804432 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  804423:	8b 55 0c             	mov    0xc(%ebp),%edx
  804426:	89 54 24 04          	mov    %edx,0x4(%esp)
  80442a:	89 04 24             	mov    %eax,(%esp)
  80442d:	e8 7e 01 00 00       	call   8045b0 <_Z12nsipc_listenii>
}
  804432:	c9                   	leave  
  804433:	c3                   	ret    

00804434 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  804434:	55                   	push   %ebp
  804435:	89 e5                	mov    %esp,%ebp
  804437:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80443a:	8b 45 10             	mov    0x10(%ebp),%eax
  80443d:	89 44 24 08          	mov    %eax,0x8(%esp)
  804441:	8b 45 0c             	mov    0xc(%ebp),%eax
  804444:	89 44 24 04          	mov    %eax,0x4(%esp)
  804448:	8b 45 08             	mov    0x8(%ebp),%eax
  80444b:	89 04 24             	mov    %eax,(%esp)
  80444e:	e8 72 02 00 00       	call   8046c5 <_Z12nsipc_socketiii>
  804453:	85 c0                	test   %eax,%eax
  804455:	78 05                	js     80445c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  804457:	e8 5b fe ff ff       	call   8042b7 <_ZL12alloc_sockfdi>
}
  80445c:	c9                   	leave  
  80445d:	8d 76 00             	lea    0x0(%esi),%esi
  804460:	c3                   	ret    
  804461:	00 00                	add    %al,(%eax)
	...

00804464 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  804464:	55                   	push   %ebp
  804465:	89 e5                	mov    %esp,%ebp
  804467:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80446a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  804471:	00 
  804472:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  804479:	00 
  80447a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80447e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  804485:	e8 f5 05 00 00       	call   804a7f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  80448a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  804491:	00 
  804492:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  804499:	00 
  80449a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8044a1:	e8 4a 05 00 00       	call   8049f0 <_Z8ipc_recvPiPvS_>
}
  8044a6:	c9                   	leave  
  8044a7:	c3                   	ret    

008044a8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8044a8:	55                   	push   %ebp
  8044a9:	89 e5                	mov    %esp,%ebp
  8044ab:	53                   	push   %ebx
  8044ac:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  8044af:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b2:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8044b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8044bc:	e8 a3 ff ff ff       	call   804464 <_ZL5nsipcj>
  8044c1:	89 c3                	mov    %eax,%ebx
  8044c3:	85 c0                	test   %eax,%eax
  8044c5:	78 27                	js     8044ee <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  8044c7:	a1 10 80 80 00       	mov    0x808010,%eax
  8044cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8044d0:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8044d7:	00 
  8044d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044db:	89 04 24             	mov    %eax,(%esp)
  8044de:	e8 39 c6 ff ff       	call   800b1c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  8044e3:	8b 15 10 80 80 00    	mov    0x808010,%edx
  8044e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8044ec:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8044ee:	89 d8                	mov    %ebx,%eax
  8044f0:	83 c4 14             	add    $0x14,%esp
  8044f3:	5b                   	pop    %ebx
  8044f4:	5d                   	pop    %ebp
  8044f5:	c3                   	ret    

008044f6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8044f6:	55                   	push   %ebp
  8044f7:	89 e5                	mov    %esp,%ebp
  8044f9:	53                   	push   %ebx
  8044fa:	83 ec 14             	sub    $0x14,%esp
  8044fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  804500:	8b 45 08             	mov    0x8(%ebp),%eax
  804503:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804508:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80450c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80450f:	89 44 24 04          	mov    %eax,0x4(%esp)
  804513:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80451a:	e8 fd c5 ff ff       	call   800b1c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80451f:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  804525:	b8 02 00 00 00       	mov    $0x2,%eax
  80452a:	e8 35 ff ff ff       	call   804464 <_ZL5nsipcj>
}
  80452f:	83 c4 14             	add    $0x14,%esp
  804532:	5b                   	pop    %ebx
  804533:	5d                   	pop    %ebp
  804534:	c3                   	ret    

00804535 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  804535:	55                   	push   %ebp
  804536:	89 e5                	mov    %esp,%ebp
  804538:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80453b:	8b 45 08             	mov    0x8(%ebp),%eax
  80453e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  804543:	8b 45 0c             	mov    0xc(%ebp),%eax
  804546:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80454b:	b8 03 00 00 00       	mov    $0x3,%eax
  804550:	e8 0f ff ff ff       	call   804464 <_ZL5nsipcj>
}
  804555:	c9                   	leave  
  804556:	c3                   	ret    

00804557 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  804557:	55                   	push   %ebp
  804558:	89 e5                	mov    %esp,%ebp
  80455a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80455d:	8b 45 08             	mov    0x8(%ebp),%eax
  804560:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  804565:	b8 04 00 00 00       	mov    $0x4,%eax
  80456a:	e8 f5 fe ff ff       	call   804464 <_ZL5nsipcj>
}
  80456f:	c9                   	leave  
  804570:	c3                   	ret    

00804571 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804571:	55                   	push   %ebp
  804572:	89 e5                	mov    %esp,%ebp
  804574:	53                   	push   %ebx
  804575:	83 ec 14             	sub    $0x14,%esp
  804578:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80457b:	8b 45 08             	mov    0x8(%ebp),%eax
  80457e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804583:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80458a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80458e:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  804595:	e8 82 c5 ff ff       	call   800b1c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80459a:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8045a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8045a5:	e8 ba fe ff ff       	call   804464 <_ZL5nsipcj>
}
  8045aa:	83 c4 14             	add    $0x14,%esp
  8045ad:	5b                   	pop    %ebx
  8045ae:	5d                   	pop    %ebp
  8045af:	c3                   	ret    

008045b0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  8045b0:	55                   	push   %ebp
  8045b1:	89 e5                	mov    %esp,%ebp
  8045b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8045b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8045b9:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8045be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045c1:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8045c6:	b8 06 00 00 00       	mov    $0x6,%eax
  8045cb:	e8 94 fe ff ff       	call   804464 <_ZL5nsipcj>
}
  8045d0:	c9                   	leave  
  8045d1:	c3                   	ret    

008045d2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8045d2:	55                   	push   %ebp
  8045d3:	89 e5                	mov    %esp,%ebp
  8045d5:	56                   	push   %esi
  8045d6:	53                   	push   %ebx
  8045d7:	83 ec 10             	sub    $0x10,%esp
  8045da:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8045dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e0:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8045e5:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8045eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8045ee:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8045f3:	b8 07 00 00 00       	mov    $0x7,%eax
  8045f8:	e8 67 fe ff ff       	call   804464 <_ZL5nsipcj>
  8045fd:	89 c3                	mov    %eax,%ebx
  8045ff:	85 c0                	test   %eax,%eax
  804601:	78 46                	js     804649 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  804603:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  804608:	7f 04                	jg     80460e <_Z10nsipc_recviPvij+0x3c>
  80460a:	39 f0                	cmp    %esi,%eax
  80460c:	7e 24                	jle    804632 <_Z10nsipc_recviPvij+0x60>
  80460e:	c7 44 24 0c 41 59 80 	movl   $0x805941,0xc(%esp)
  804615:	00 
  804616:	c7 44 24 08 66 52 80 	movl   $0x805266,0x8(%esp)
  80461d:	00 
  80461e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  804625:	00 
  804626:	c7 04 24 56 59 80 00 	movl   $0x805956,(%esp)
  80462d:	e8 0a bc ff ff       	call   80023c <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804632:	89 44 24 08          	mov    %eax,0x8(%esp)
  804636:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80463d:	00 
  80463e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804641:	89 04 24             	mov    %eax,(%esp)
  804644:	e8 d3 c4 ff ff       	call   800b1c <memmove>
	}

	return r;
}
  804649:	89 d8                	mov    %ebx,%eax
  80464b:	83 c4 10             	add    $0x10,%esp
  80464e:	5b                   	pop    %ebx
  80464f:	5e                   	pop    %esi
  804650:	5d                   	pop    %ebp
  804651:	c3                   	ret    

00804652 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804652:	55                   	push   %ebp
  804653:	89 e5                	mov    %esp,%ebp
  804655:	53                   	push   %ebx
  804656:	83 ec 14             	sub    $0x14,%esp
  804659:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80465c:	8b 45 08             	mov    0x8(%ebp),%eax
  80465f:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  804664:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80466a:	7e 24                	jle    804690 <_Z10nsipc_sendiPKvij+0x3e>
  80466c:	c7 44 24 0c 62 59 80 	movl   $0x805962,0xc(%esp)
  804673:	00 
  804674:	c7 44 24 08 66 52 80 	movl   $0x805266,0x8(%esp)
  80467b:	00 
  80467c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  804683:	00 
  804684:	c7 04 24 56 59 80 00 	movl   $0x805956,(%esp)
  80468b:	e8 ac bb ff ff       	call   80023c <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804690:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804694:	8b 45 0c             	mov    0xc(%ebp),%eax
  804697:	89 44 24 04          	mov    %eax,0x4(%esp)
  80469b:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8046a2:	e8 75 c4 ff ff       	call   800b1c <memmove>
	nsipcbuf.send.req_size = size;
  8046a7:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8046ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8046b0:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8046b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8046ba:	e8 a5 fd ff ff       	call   804464 <_ZL5nsipcj>
}
  8046bf:	83 c4 14             	add    $0x14,%esp
  8046c2:	5b                   	pop    %ebx
  8046c3:	5d                   	pop    %ebp
  8046c4:	c3                   	ret    

008046c5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8046c5:	55                   	push   %ebp
  8046c6:	89 e5                	mov    %esp,%ebp
  8046c8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8046cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8046ce:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8046d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046d6:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8046db:	8b 45 10             	mov    0x10(%ebp),%eax
  8046de:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8046e3:	b8 09 00 00 00       	mov    $0x9,%eax
  8046e8:	e8 77 fd ff ff       	call   804464 <_ZL5nsipcj>
}
  8046ed:	c9                   	leave  
  8046ee:	c3                   	ret    
	...

008046f0 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8046f0:	55                   	push   %ebp
  8046f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8046f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8046f8:	5d                   	pop    %ebp
  8046f9:	c3                   	ret    

008046fa <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8046fa:	55                   	push   %ebp
  8046fb:	89 e5                	mov    %esp,%ebp
  8046fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804700:	c7 44 24 04 6e 59 80 	movl   $0x80596e,0x4(%esp)
  804707:	00 
  804708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80470b:	89 04 24             	mov    %eax,(%esp)
  80470e:	e8 67 c2 ff ff       	call   80097a <_Z6strcpyPcPKc>
	return 0;
}
  804713:	b8 00 00 00 00       	mov    $0x0,%eax
  804718:	c9                   	leave  
  804719:	c3                   	ret    

0080471a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80471a:	55                   	push   %ebp
  80471b:	89 e5                	mov    %esp,%ebp
  80471d:	57                   	push   %edi
  80471e:	56                   	push   %esi
  80471f:	53                   	push   %ebx
  804720:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804726:	bb 00 00 00 00       	mov    $0x0,%ebx
  80472b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80472f:	74 3e                	je     80476f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804731:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  804737:	8b 75 10             	mov    0x10(%ebp),%esi
  80473a:	29 de                	sub    %ebx,%esi
  80473c:	83 fe 7f             	cmp    $0x7f,%esi
  80473f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  804744:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804747:	89 74 24 08          	mov    %esi,0x8(%esp)
  80474b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80474e:	01 d8                	add    %ebx,%eax
  804750:	89 44 24 04          	mov    %eax,0x4(%esp)
  804754:	89 3c 24             	mov    %edi,(%esp)
  804757:	e8 c0 c3 ff ff       	call   800b1c <memmove>
		sys_cputs(buf, m);
  80475c:	89 74 24 04          	mov    %esi,0x4(%esp)
  804760:	89 3c 24             	mov    %edi,(%esp)
  804763:	e8 cc c5 ff ff       	call   800d34 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804768:	01 f3                	add    %esi,%ebx
  80476a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  80476d:	77 c8                	ja     804737 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80476f:	89 d8                	mov    %ebx,%eax
  804771:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  804777:	5b                   	pop    %ebx
  804778:	5e                   	pop    %esi
  804779:	5f                   	pop    %edi
  80477a:	5d                   	pop    %ebp
  80477b:	c3                   	ret    

0080477c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80477c:	55                   	push   %ebp
  80477d:	89 e5                	mov    %esp,%ebp
  80477f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  804782:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  804787:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80478b:	75 07                	jne    804794 <_ZL12devcons_readP2FdPvj+0x18>
  80478d:	eb 2a                	jmp    8047b9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80478f:	e8 98 c6 ff ff       	call   800e2c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804794:	e8 ce c5 ff ff       	call   800d67 <_Z9sys_cgetcv>
  804799:	85 c0                	test   %eax,%eax
  80479b:	74 f2                	je     80478f <_ZL12devcons_readP2FdPvj+0x13>
  80479d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80479f:	85 c0                	test   %eax,%eax
  8047a1:	78 16                	js     8047b9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8047a3:	83 f8 04             	cmp    $0x4,%eax
  8047a6:	74 0c                	je     8047b4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8047a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8047ab:	88 10                	mov    %dl,(%eax)
	return 1;
  8047ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8047b2:	eb 05                	jmp    8047b9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8047b4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8047b9:	c9                   	leave  
  8047ba:	c3                   	ret    

008047bb <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8047bb:	55                   	push   %ebp
  8047bc:	89 e5                	mov    %esp,%ebp
  8047be:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8047c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8047c4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8047c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8047ce:	00 
  8047cf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8047d2:	89 04 24             	mov    %eax,(%esp)
  8047d5:	e8 5a c5 ff ff       	call   800d34 <_Z9sys_cputsPKcj>
}
  8047da:	c9                   	leave  
  8047db:	c3                   	ret    

008047dc <_Z7getcharv>:

int
getchar(void)
{
  8047dc:	55                   	push   %ebp
  8047dd:	89 e5                	mov    %esp,%ebp
  8047df:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8047e2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8047e9:	00 
  8047ea:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8047ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8047f8:	e8 01 dc ff ff       	call   8023fe <_Z4readiPvj>
	if (r < 0)
  8047fd:	85 c0                	test   %eax,%eax
  8047ff:	78 0f                	js     804810 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  804801:	85 c0                	test   %eax,%eax
  804803:	7e 06                	jle    80480b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  804805:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804809:	eb 05                	jmp    804810 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80480b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  804810:	c9                   	leave  
  804811:	c3                   	ret    

00804812 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  804812:	55                   	push   %ebp
  804813:	89 e5                	mov    %esp,%ebp
  804815:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  804818:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80481f:	00 
  804820:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804823:	89 44 24 04          	mov    %eax,0x4(%esp)
  804827:	8b 45 08             	mov    0x8(%ebp),%eax
  80482a:	89 04 24             	mov    %eax,(%esp)
  80482d:	e8 1f d8 ff ff       	call   802051 <_Z9fd_lookupiPP2Fdb>
  804832:	85 c0                	test   %eax,%eax
  804834:	78 11                	js     804847 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  804836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804839:	8b 15 60 60 80 00    	mov    0x806060,%edx
  80483f:	39 10                	cmp    %edx,(%eax)
  804841:	0f 94 c0             	sete   %al
  804844:	0f b6 c0             	movzbl %al,%eax
}
  804847:	c9                   	leave  
  804848:	c3                   	ret    

00804849 <_Z8openconsv>:

int
opencons(void)
{
  804849:	55                   	push   %ebp
  80484a:	89 e5                	mov    %esp,%ebp
  80484c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80484f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804852:	89 04 24             	mov    %eax,(%esp)
  804855:	e8 ad d8 ff ff       	call   802107 <_Z14fd_find_unusedPP2Fd>
  80485a:	85 c0                	test   %eax,%eax
  80485c:	78 3c                	js     80489a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80485e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804865:	00 
  804866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804869:	89 44 24 04          	mov    %eax,0x4(%esp)
  80486d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804874:	e8 e7 c5 ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  804879:	85 c0                	test   %eax,%eax
  80487b:	78 1d                	js     80489a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80487d:	8b 15 60 60 80 00    	mov    0x806060,%edx
  804883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804886:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  804888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80488b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  804892:	89 04 24             	mov    %eax,(%esp)
  804895:	e8 0a d8 ff ff       	call   8020a4 <_Z6fd2numP2Fd>
}
  80489a:	c9                   	leave  
  80489b:	c3                   	ret    
  80489c:	00 00                	add    %al,(%eax)
	...

008048a0 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  8048a0:	55                   	push   %ebp
  8048a1:	89 e5                	mov    %esp,%ebp
  8048a3:	56                   	push   %esi
  8048a4:	53                   	push   %ebx
  8048a5:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8048a8:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  8048ad:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  8048b4:	85 c0                	test   %eax,%eax
  8048b6:	74 08                	je     8048c0 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  8048b8:	8d 55 08             	lea    0x8(%ebp),%edx
  8048bb:	89 14 24             	mov    %edx,(%esp)
  8048be:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8048c0:	83 eb 01             	sub    $0x1,%ebx
  8048c3:	83 fb ff             	cmp    $0xffffffff,%ebx
  8048c6:	75 e5                	jne    8048ad <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  8048c8:	8b 5d 38             	mov    0x38(%ebp),%ebx
  8048cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8048ce:	e8 25 c5 ff ff       	call   800df8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  8048d3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8048d7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8048db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8048df:	c7 44 24 08 7c 59 80 	movl   $0x80597c,0x8(%esp)
  8048e6:	00 
  8048e7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8048ee:	00 
  8048ef:	c7 04 24 00 5a 80 00 	movl   $0x805a00,(%esp)
  8048f6:	e8 41 b9 ff ff       	call   80023c <_Z6_panicPKciS0_z>

008048fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  8048fb:	55                   	push   %ebp
  8048fc:	89 e5                	mov    %esp,%ebp
  8048fe:	56                   	push   %esi
  8048ff:	53                   	push   %ebx
  804900:	83 ec 10             	sub    $0x10,%esp
  804903:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804906:	e8 ed c4 ff ff       	call   800df8 <_Z12sys_getenvidv>
  80490b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80490d:	a1 00 70 80 00       	mov    0x807000,%eax
  804912:	8b 40 5c             	mov    0x5c(%eax),%eax
  804915:	85 c0                	test   %eax,%eax
  804917:	75 4c                	jne    804965 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  804919:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  804920:	00 
  804921:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  804928:	ee 
  804929:	89 34 24             	mov    %esi,(%esp)
  80492c:	e8 2f c5 ff ff       	call   800e60 <_Z14sys_page_allociPvi>
  804931:	85 c0                	test   %eax,%eax
  804933:	74 20                	je     804955 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  804935:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804939:	c7 44 24 08 b4 59 80 	movl   $0x8059b4,0x8(%esp)
  804940:	00 
  804941:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  804948:	00 
  804949:	c7 04 24 00 5a 80 00 	movl   $0x805a00,(%esp)
  804950:	e8 e7 b8 ff ff       	call   80023c <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  804955:	c7 44 24 04 a0 48 80 	movl   $0x8048a0,0x4(%esp)
  80495c:	00 
  80495d:	89 34 24             	mov    %esi,(%esp)
  804960:	e8 30 c7 ff ff       	call   801095 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804965:	a1 00 90 80 00       	mov    0x809000,%eax
  80496a:	39 d8                	cmp    %ebx,%eax
  80496c:	74 1a                	je     804988 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  80496e:	85 c0                	test   %eax,%eax
  804970:	74 20                	je     804992 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804972:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804977:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  80497e:	39 da                	cmp    %ebx,%edx
  804980:	74 15                	je     804997 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804982:	85 d2                	test   %edx,%edx
  804984:	75 1f                	jne    8049a5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804986:	eb 0f                	jmp    804997 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804988:	b8 00 00 00 00       	mov    $0x0,%eax
  80498d:	8d 76 00             	lea    0x0(%esi),%esi
  804990:	eb 05                	jmp    804997 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804992:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804997:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80499e:	83 c4 10             	add    $0x10,%esp
  8049a1:	5b                   	pop    %ebx
  8049a2:	5e                   	pop    %esi
  8049a3:	5d                   	pop    %ebp
  8049a4:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8049a5:	83 c0 01             	add    $0x1,%eax
  8049a8:	83 f8 08             	cmp    $0x8,%eax
  8049ab:	75 ca                	jne    804977 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  8049ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8049b1:	c7 44 24 08 d8 59 80 	movl   $0x8059d8,0x8(%esp)
  8049b8:	00 
  8049b9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8049c0:	00 
  8049c1:	c7 04 24 00 5a 80 00 	movl   $0x805a00,(%esp)
  8049c8:	e8 6f b8 ff ff       	call   80023c <_Z6_panicPKciS0_z>
  8049cd:	00 00                	add    %al,(%eax)
	...

008049d0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  8049d0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  8049d3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  8049d4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  8049d7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  8049db:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  8049df:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  8049e2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  8049e4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  8049e8:	61                   	popa   
    popf
  8049e9:	9d                   	popf   
    popl %esp
  8049ea:	5c                   	pop    %esp
    ret
  8049eb:	c3                   	ret    

008049ec <spin>:

spin:	jmp spin
  8049ec:	eb fe                	jmp    8049ec <spin>
	...

008049f0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8049f0:	55                   	push   %ebp
  8049f1:	89 e5                	mov    %esp,%ebp
  8049f3:	56                   	push   %esi
  8049f4:	53                   	push   %ebx
  8049f5:	83 ec 10             	sub    $0x10,%esp
  8049f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8049fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8049fe:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  804a01:	85 c0                	test   %eax,%eax
  804a03:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  804a08:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  804a0b:	89 04 24             	mov    %eax,(%esp)
  804a0e:	e8 18 c7 ff ff       	call   80112b <_Z12sys_ipc_recvPv>
  804a13:	85 c0                	test   %eax,%eax
  804a15:	79 16                	jns    804a2d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  804a17:	85 db                	test   %ebx,%ebx
  804a19:	74 06                	je     804a21 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  804a1b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804a21:	85 f6                	test   %esi,%esi
  804a23:	74 53                	je     804a78 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804a25:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  804a2b:	eb 4b                	jmp    804a78 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  804a2d:	85 db                	test   %ebx,%ebx
  804a2f:	74 17                	je     804a48 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804a31:	e8 c2 c3 ff ff       	call   800df8 <_Z12sys_getenvidv>
  804a36:	25 ff 03 00 00       	and    $0x3ff,%eax
  804a3b:	6b c0 78             	imul   $0x78,%eax,%eax
  804a3e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804a43:	8b 40 60             	mov    0x60(%eax),%eax
  804a46:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804a48:	85 f6                	test   %esi,%esi
  804a4a:	74 17                	je     804a63 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  804a4c:	e8 a7 c3 ff ff       	call   800df8 <_Z12sys_getenvidv>
  804a51:	25 ff 03 00 00       	and    $0x3ff,%eax
  804a56:	6b c0 78             	imul   $0x78,%eax,%eax
  804a59:	05 00 00 00 ef       	add    $0xef000000,%eax
  804a5e:	8b 40 70             	mov    0x70(%eax),%eax
  804a61:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  804a63:	e8 90 c3 ff ff       	call   800df8 <_Z12sys_getenvidv>
  804a68:	25 ff 03 00 00       	and    $0x3ff,%eax
  804a6d:	6b c0 78             	imul   $0x78,%eax,%eax
  804a70:	05 08 00 00 ef       	add    $0xef000008,%eax
  804a75:	8b 40 60             	mov    0x60(%eax),%eax

}
  804a78:	83 c4 10             	add    $0x10,%esp
  804a7b:	5b                   	pop    %ebx
  804a7c:	5e                   	pop    %esi
  804a7d:	5d                   	pop    %ebp
  804a7e:	c3                   	ret    

00804a7f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804a7f:	55                   	push   %ebp
  804a80:	89 e5                	mov    %esp,%ebp
  804a82:	57                   	push   %edi
  804a83:	56                   	push   %esi
  804a84:	53                   	push   %ebx
  804a85:	83 ec 1c             	sub    $0x1c,%esp
  804a88:	8b 75 08             	mov    0x8(%ebp),%esi
  804a8b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804a8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  804a91:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  804a93:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  804a98:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  804a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  804a9e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804aa2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804aa6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  804aaa:	89 34 24             	mov    %esi,(%esp)
  804aad:	e8 41 c6 ff ff       	call   8010f3 <_Z16sys_ipc_try_sendijPvi>
  804ab2:	85 c0                	test   %eax,%eax
  804ab4:	79 31                	jns    804ae7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  804ab6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  804ab9:	75 0c                	jne    804ac7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  804abb:	90                   	nop
  804abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804ac0:	e8 67 c3 ff ff       	call   800e2c <_Z9sys_yieldv>
  804ac5:	eb d4                	jmp    804a9b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  804ac7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804acb:	c7 44 24 08 0e 5a 80 	movl   $0x805a0e,0x8(%esp)
  804ad2:	00 
  804ad3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  804ada:	00 
  804adb:	c7 04 24 1b 5a 80 00 	movl   $0x805a1b,(%esp)
  804ae2:	e8 55 b7 ff ff       	call   80023c <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  804ae7:	83 c4 1c             	add    $0x1c,%esp
  804aea:	5b                   	pop    %ebx
  804aeb:	5e                   	pop    %esi
  804aec:	5f                   	pop    %edi
  804aed:	5d                   	pop    %ebp
  804aee:	c3                   	ret    
	...

00804af0 <__udivdi3>:
  804af0:	55                   	push   %ebp
  804af1:	89 e5                	mov    %esp,%ebp
  804af3:	57                   	push   %edi
  804af4:	56                   	push   %esi
  804af5:	83 ec 20             	sub    $0x20,%esp
  804af8:	8b 45 14             	mov    0x14(%ebp),%eax
  804afb:	8b 75 08             	mov    0x8(%ebp),%esi
  804afe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804b01:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804b04:	85 c0                	test   %eax,%eax
  804b06:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804b09:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  804b0c:	75 3a                	jne    804b48 <__udivdi3+0x58>
  804b0e:	39 f9                	cmp    %edi,%ecx
  804b10:	77 66                	ja     804b78 <__udivdi3+0x88>
  804b12:	85 c9                	test   %ecx,%ecx
  804b14:	75 0b                	jne    804b21 <__udivdi3+0x31>
  804b16:	b8 01 00 00 00       	mov    $0x1,%eax
  804b1b:	31 d2                	xor    %edx,%edx
  804b1d:	f7 f1                	div    %ecx
  804b1f:	89 c1                	mov    %eax,%ecx
  804b21:	89 f8                	mov    %edi,%eax
  804b23:	31 d2                	xor    %edx,%edx
  804b25:	f7 f1                	div    %ecx
  804b27:	89 c7                	mov    %eax,%edi
  804b29:	89 f0                	mov    %esi,%eax
  804b2b:	f7 f1                	div    %ecx
  804b2d:	89 fa                	mov    %edi,%edx
  804b2f:	89 c6                	mov    %eax,%esi
  804b31:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804b34:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804b3d:	83 c4 20             	add    $0x20,%esp
  804b40:	5e                   	pop    %esi
  804b41:	5f                   	pop    %edi
  804b42:	5d                   	pop    %ebp
  804b43:	c3                   	ret    
  804b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804b48:	31 d2                	xor    %edx,%edx
  804b4a:	31 f6                	xor    %esi,%esi
  804b4c:	39 f8                	cmp    %edi,%eax
  804b4e:	77 e1                	ja     804b31 <__udivdi3+0x41>
  804b50:	0f bd d0             	bsr    %eax,%edx
  804b53:	83 f2 1f             	xor    $0x1f,%edx
  804b56:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804b59:	75 2d                	jne    804b88 <__udivdi3+0x98>
  804b5b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  804b5e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804b61:	76 06                	jbe    804b69 <__udivdi3+0x79>
  804b63:	39 f8                	cmp    %edi,%eax
  804b65:	89 f2                	mov    %esi,%edx
  804b67:	73 c8                	jae    804b31 <__udivdi3+0x41>
  804b69:	31 d2                	xor    %edx,%edx
  804b6b:	be 01 00 00 00       	mov    $0x1,%esi
  804b70:	eb bf                	jmp    804b31 <__udivdi3+0x41>
  804b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804b78:	89 f0                	mov    %esi,%eax
  804b7a:	89 fa                	mov    %edi,%edx
  804b7c:	f7 f1                	div    %ecx
  804b7e:	31 d2                	xor    %edx,%edx
  804b80:	89 c6                	mov    %eax,%esi
  804b82:	eb ad                	jmp    804b31 <__udivdi3+0x41>
  804b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804b88:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804b8c:	89 c2                	mov    %eax,%edx
  804b8e:	b8 20 00 00 00       	mov    $0x20,%eax
  804b93:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804b96:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804b99:	d3 e2                	shl    %cl,%edx
  804b9b:	89 c1                	mov    %eax,%ecx
  804b9d:	d3 ee                	shr    %cl,%esi
  804b9f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804ba3:	09 d6                	or     %edx,%esi
  804ba5:	89 fa                	mov    %edi,%edx
  804ba7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  804baa:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804bad:	d3 e6                	shl    %cl,%esi
  804baf:	89 c1                	mov    %eax,%ecx
  804bb1:	d3 ea                	shr    %cl,%edx
  804bb3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804bb7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804bba:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804bbd:	d3 e7                	shl    %cl,%edi
  804bbf:	89 c1                	mov    %eax,%ecx
  804bc1:	d3 ee                	shr    %cl,%esi
  804bc3:	09 fe                	or     %edi,%esi
  804bc5:	89 f0                	mov    %esi,%eax
  804bc7:	f7 75 e4             	divl   -0x1c(%ebp)
  804bca:	89 d7                	mov    %edx,%edi
  804bcc:	89 c6                	mov    %eax,%esi
  804bce:	f7 65 f0             	mull   -0x10(%ebp)
  804bd1:	39 d7                	cmp    %edx,%edi
  804bd3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804bd6:	72 12                	jb     804bea <__udivdi3+0xfa>
  804bd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804bdb:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804bdf:	d3 e2                	shl    %cl,%edx
  804be1:	39 c2                	cmp    %eax,%edx
  804be3:	73 08                	jae    804bed <__udivdi3+0xfd>
  804be5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804be8:	75 03                	jne    804bed <__udivdi3+0xfd>
  804bea:	83 ee 01             	sub    $0x1,%esi
  804bed:	31 d2                	xor    %edx,%edx
  804bef:	e9 3d ff ff ff       	jmp    804b31 <__udivdi3+0x41>
	...

00804c00 <__umoddi3>:
  804c00:	55                   	push   %ebp
  804c01:	89 e5                	mov    %esp,%ebp
  804c03:	57                   	push   %edi
  804c04:	56                   	push   %esi
  804c05:	83 ec 20             	sub    $0x20,%esp
  804c08:	8b 7d 14             	mov    0x14(%ebp),%edi
  804c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  804c0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804c11:	8b 75 0c             	mov    0xc(%ebp),%esi
  804c14:	85 ff                	test   %edi,%edi
  804c16:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804c19:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  804c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804c1f:	89 f2                	mov    %esi,%edx
  804c21:	75 15                	jne    804c38 <__umoddi3+0x38>
  804c23:	39 f1                	cmp    %esi,%ecx
  804c25:	76 41                	jbe    804c68 <__umoddi3+0x68>
  804c27:	f7 f1                	div    %ecx
  804c29:	89 d0                	mov    %edx,%eax
  804c2b:	31 d2                	xor    %edx,%edx
  804c2d:	83 c4 20             	add    $0x20,%esp
  804c30:	5e                   	pop    %esi
  804c31:	5f                   	pop    %edi
  804c32:	5d                   	pop    %ebp
  804c33:	c3                   	ret    
  804c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804c38:	39 f7                	cmp    %esi,%edi
  804c3a:	77 4c                	ja     804c88 <__umoddi3+0x88>
  804c3c:	0f bd c7             	bsr    %edi,%eax
  804c3f:	83 f0 1f             	xor    $0x1f,%eax
  804c42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804c45:	75 51                	jne    804c98 <__umoddi3+0x98>
  804c47:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  804c4a:	0f 87 e8 00 00 00    	ja     804d38 <__umoddi3+0x138>
  804c50:	89 f2                	mov    %esi,%edx
  804c52:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804c55:	29 ce                	sub    %ecx,%esi
  804c57:	19 fa                	sbb    %edi,%edx
  804c59:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c5f:	83 c4 20             	add    $0x20,%esp
  804c62:	5e                   	pop    %esi
  804c63:	5f                   	pop    %edi
  804c64:	5d                   	pop    %ebp
  804c65:	c3                   	ret    
  804c66:	66 90                	xchg   %ax,%ax
  804c68:	85 c9                	test   %ecx,%ecx
  804c6a:	75 0b                	jne    804c77 <__umoddi3+0x77>
  804c6c:	b8 01 00 00 00       	mov    $0x1,%eax
  804c71:	31 d2                	xor    %edx,%edx
  804c73:	f7 f1                	div    %ecx
  804c75:	89 c1                	mov    %eax,%ecx
  804c77:	89 f0                	mov    %esi,%eax
  804c79:	31 d2                	xor    %edx,%edx
  804c7b:	f7 f1                	div    %ecx
  804c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c80:	eb a5                	jmp    804c27 <__umoddi3+0x27>
  804c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804c88:	89 f2                	mov    %esi,%edx
  804c8a:	83 c4 20             	add    $0x20,%esp
  804c8d:	5e                   	pop    %esi
  804c8e:	5f                   	pop    %edi
  804c8f:	5d                   	pop    %ebp
  804c90:	c3                   	ret    
  804c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804c98:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804c9c:	89 f2                	mov    %esi,%edx
  804c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ca1:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804ca8:	29 45 f0             	sub    %eax,-0x10(%ebp)
  804cab:	d3 e7                	shl    %cl,%edi
  804cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804cb0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804cb4:	d3 e8                	shr    %cl,%eax
  804cb6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804cba:	09 f8                	or     %edi,%eax
  804cbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  804cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804cc2:	d3 e0                	shl    %cl,%eax
  804cc4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804cce:	d3 ea                	shr    %cl,%edx
  804cd0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804cd4:	d3 e6                	shl    %cl,%esi
  804cd6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804cda:	d3 e8                	shr    %cl,%eax
  804cdc:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804ce0:	09 f0                	or     %esi,%eax
  804ce2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804ce5:	f7 75 e4             	divl   -0x1c(%ebp)
  804ce8:	d3 e6                	shl    %cl,%esi
  804cea:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804ced:	89 d6                	mov    %edx,%esi
  804cef:	f7 65 f4             	mull   -0xc(%ebp)
  804cf2:	89 d7                	mov    %edx,%edi
  804cf4:	89 c2                	mov    %eax,%edx
  804cf6:	39 fe                	cmp    %edi,%esi
  804cf8:	89 f9                	mov    %edi,%ecx
  804cfa:	72 30                	jb     804d2c <__umoddi3+0x12c>
  804cfc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  804cff:	72 27                	jb     804d28 <__umoddi3+0x128>
  804d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d04:	29 d0                	sub    %edx,%eax
  804d06:	19 ce                	sbb    %ecx,%esi
  804d08:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804d0c:	89 f2                	mov    %esi,%edx
  804d0e:	d3 e8                	shr    %cl,%eax
  804d10:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804d14:	d3 e2                	shl    %cl,%edx
  804d16:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804d1a:	09 d0                	or     %edx,%eax
  804d1c:	89 f2                	mov    %esi,%edx
  804d1e:	d3 ea                	shr    %cl,%edx
  804d20:	83 c4 20             	add    $0x20,%esp
  804d23:	5e                   	pop    %esi
  804d24:	5f                   	pop    %edi
  804d25:	5d                   	pop    %ebp
  804d26:	c3                   	ret    
  804d27:	90                   	nop
  804d28:	39 fe                	cmp    %edi,%esi
  804d2a:	75 d5                	jne    804d01 <__umoddi3+0x101>
  804d2c:	89 f9                	mov    %edi,%ecx
  804d2e:	89 c2                	mov    %eax,%edx
  804d30:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804d33:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804d36:	eb c9                	jmp    804d01 <__umoddi3+0x101>
  804d38:	39 f7                	cmp    %esi,%edi
  804d3a:	0f 82 10 ff ff ff    	jb     804c50 <__umoddi3+0x50>
  804d40:	e9 17 ff ff ff       	jmp    804c5c <__umoddi3+0x5c>
