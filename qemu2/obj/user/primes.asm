
obj/user/primes:     file format elf32-i386


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
  80002c:	e8 13 01 00 00       	call   800144 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z9primeprocv>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003d:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800040:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800047:	00 
  800048:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004f:	00 
  800050:	89 34 24             	mov    %esi,(%esp)
  800053:	e8 b8 16 00 00       	call   801710 <_Z8ipc_recvPiPvS_>
  800058:	89 c3                	mov    %eax,%ebx
	cprintf("%d ", p);
  80005a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005e:	c7 04 24 20 44 80 00 	movl   $0x804420,(%esp)
  800065:	e8 7c 02 00 00       	call   8002e6 <_Z7cprintfPKcz>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80006a:	e8 ae 13 00 00       	call   80141d <_Z4forkv>
  80006f:	89 c7                	mov    %eax,%edi
  800071:	85 c0                	test   %eax,%eax
  800073:	79 20                	jns    800095 <_Z9primeprocv+0x61>
		panic("fork: %e", id);
  800075:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800079:	c7 44 24 08 28 48 80 	movl   $0x804828,0x8(%esp)
  800080:	00 
  800081:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800088:	00 
  800089:	c7 04 24 24 44 80 00 	movl   $0x804424,(%esp)
  800090:	e8 33 01 00 00       	call   8001c8 <_Z6_panicPKciS0_z>
	if (id == 0)
  800095:	85 c0                	test   %eax,%eax
  800097:	74 a7                	je     800040 <_Z9primeprocv+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800099:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80009c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000a3:	00 
  8000a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ab:	00 
  8000ac:	89 34 24             	mov    %esi,(%esp)
  8000af:	e8 5c 16 00 00       	call   801710 <_Z8ipc_recvPiPvS_>
  8000b4:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000b6:	89 c2                	mov    %eax,%edx
  8000b8:	c1 fa 1f             	sar    $0x1f,%edx
  8000bb:	f7 fb                	idiv   %ebx
  8000bd:	85 d2                	test   %edx,%edx
  8000bf:	74 db                	je     80009c <_Z9primeprocv+0x68>
			ipc_send(id, i, 0, 0);
  8000c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000c8:	00 
  8000c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000d0:	00 
  8000d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000d5:	89 3c 24             	mov    %edi,(%esp)
  8000d8:	e8 c2 16 00 00       	call   80179f <_Z8ipc_sendijPvi>
  8000dd:	eb bd                	jmp    80009c <_Z9primeprocv+0x68>

008000df <_Z5umainiPPc>:
	}
}

void
umain(int argc, char **argv)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	56                   	push   %esi
  8000e3:	53                   	push   %ebx
  8000e4:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000e7:	e8 31 13 00 00       	call   80141d <_Z4forkv>
  8000ec:	89 c6                	mov    %eax,%esi
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	79 20                	jns    800112 <_Z5umainiPPc+0x33>
		panic("fork: %e", id);
  8000f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f6:	c7 44 24 08 28 48 80 	movl   $0x804828,0x8(%esp)
  8000fd:	00 
  8000fe:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800105:	00 
  800106:	c7 04 24 24 44 80 00 	movl   $0x804424,(%esp)
  80010d:	e8 b6 00 00 00       	call   8001c8 <_Z6_panicPKciS0_z>
	if (id == 0)
  800112:	85 c0                	test   %eax,%eax
  800114:	75 05                	jne    80011b <_Z5umainiPPc+0x3c>
		primeproc();
  800116:	e8 19 ff ff ff       	call   800034 <_Z9primeprocv>
	}
}

void
umain(int argc, char **argv)
{
  80011b:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  800120:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800127:	00 
  800128:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80012f:	00 
  800130:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800134:	89 34 24             	mov    %esi,(%esp)
  800137:	e8 63 16 00 00       	call   80179f <_Z8ipc_sendijPvi>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  80013c:	83 c3 01             	add    $0x1,%ebx
  80013f:	eb df                	jmp    800120 <_Z5umainiPPc+0x41>
  800141:	00 00                	add    %al,(%eax)
	...

00800144 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	57                   	push   %edi
  800148:	56                   	push   %esi
  800149:	53                   	push   %ebx
  80014a:	83 ec 1c             	sub    $0x1c,%esp
  80014d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800150:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800153:	e8 20 0c 00 00       	call   800d78 <_Z12sys_getenvidv>
  800158:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015d:	6b c0 78             	imul   $0x78,%eax,%eax
  800160:	05 00 00 00 ef       	add    $0xef000000,%eax
  800165:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016a:	85 ff                	test   %edi,%edi
  80016c:	7e 07                	jle    800175 <libmain+0x31>
		binaryname = argv[0];
  80016e:	8b 06                	mov    (%esi),%eax
  800170:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800175:	b8 ea 4f 80 00       	mov    $0x804fea,%eax
  80017a:	3d ea 4f 80 00       	cmp    $0x804fea,%eax
  80017f:	76 0f                	jbe    800190 <libmain+0x4c>
  800181:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800183:	83 eb 04             	sub    $0x4,%ebx
  800186:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800188:	81 fb ea 4f 80 00    	cmp    $0x804fea,%ebx
  80018e:	77 f3                	ja     800183 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800190:	89 74 24 04          	mov    %esi,0x4(%esp)
  800194:	89 3c 24             	mov    %edi,(%esp)
  800197:	e8 43 ff ff ff       	call   8000df <_Z5umainiPPc>

	// exit gracefully
	exit();
  80019c:	e8 0b 00 00 00       	call   8001ac <_Z4exitv>
}
  8001a1:	83 c4 1c             	add    $0x1c,%esp
  8001a4:	5b                   	pop    %ebx
  8001a5:	5e                   	pop    %esi
  8001a6:	5f                   	pop    %edi
  8001a7:	5d                   	pop    %ebp
  8001a8:	c3                   	ret    
  8001a9:	00 00                	add    %al,(%eax)
	...

008001ac <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b2:	e8 17 19 00 00       	call   801ace <_Z9close_allv>
	sys_env_destroy(0);
  8001b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001be:	e8 58 0b 00 00       	call   800d1b <_Z15sys_env_destroyi>
}
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    
  8001c5:	00 00                	add    %al,(%eax)
	...

008001c8 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001d0:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  8001d3:	a1 04 60 80 00       	mov    0x806004,%eax
  8001d8:	85 c0                	test   %eax,%eax
  8001da:	74 10                	je     8001ec <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  8001dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e0:	c7 04 24 3c 44 80 00 	movl   $0x80443c,(%esp)
  8001e7:	e8 fa 00 00 00       	call   8002e6 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  8001ec:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  8001f2:	e8 81 0b 00 00       	call   800d78 <_Z12sys_getenvidv>
  8001f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fa:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800201:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800205:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800209:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020d:	c7 04 24 44 44 80 00 	movl   $0x804444,(%esp)
  800214:	e8 cd 00 00 00       	call   8002e6 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  800219:	89 74 24 04          	mov    %esi,0x4(%esp)
  80021d:	8b 45 10             	mov    0x10(%ebp),%eax
  800220:	89 04 24             	mov    %eax,(%esp)
  800223:	e8 5d 00 00 00       	call   800285 <_Z8vcprintfPKcPc>
	cprintf("\n");
  800228:	c7 04 24 a3 4e 80 00 	movl   $0x804ea3,(%esp)
  80022f:	e8 b2 00 00 00       	call   8002e6 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800234:	cc                   	int3   
  800235:	eb fd                	jmp    800234 <_Z6_panicPKciS0_z+0x6c>
	...

00800238 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	83 ec 18             	sub    $0x18,%esp
  80023e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800241:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800244:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  800247:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800249:	8b 03                	mov    (%ebx),%eax
  80024b:	8b 55 08             	mov    0x8(%ebp),%edx
  80024e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800252:	83 c0 01             	add    $0x1,%eax
  800255:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800257:	3d ff 00 00 00       	cmp    $0xff,%eax
  80025c:	75 19                	jne    800277 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  80025e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800265:	00 
  800266:	8d 43 08             	lea    0x8(%ebx),%eax
  800269:	89 04 24             	mov    %eax,(%esp)
  80026c:	e8 43 0a 00 00       	call   800cb4 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800271:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800277:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80027b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80027e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800281:	89 ec                	mov    %ebp,%esp
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    

00800285 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80028e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800295:	00 00 00 
	b.cnt = 0;
  800298:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8002a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ba:	c7 04 24 38 02 80 00 	movl   $0x800238,(%esp)
  8002c1:	e8 a1 01 00 00       	call   800467 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  8002c6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d6:	89 04 24             	mov    %eax,(%esp)
  8002d9:	e8 d6 09 00 00       	call   800cb4 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  8002de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ec:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f6:	89 04 24             	mov    %eax,(%esp)
  8002f9:	e8 87 ff ff ff       	call   800285 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	57                   	push   %edi
  800304:	56                   	push   %esi
  800305:	53                   	push   %ebx
  800306:	83 ec 4c             	sub    $0x4c,%esp
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030c:	89 d6                	mov    %edx,%esi
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800314:	8b 55 0c             	mov    0xc(%ebp),%edx
  800317:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80031a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80031d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800320:	b8 00 00 00 00       	mov    $0x0,%eax
  800325:	39 d0                	cmp    %edx,%eax
  800327:	72 11                	jb     80033a <_ZL8printnumPFviPvES_yjii+0x3a>
  800329:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80032c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80032f:	76 09                	jbe    80033a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800331:	83 eb 01             	sub    $0x1,%ebx
  800334:	85 db                	test   %ebx,%ebx
  800336:	7f 5d                	jg     800395 <_ZL8printnumPFviPvES_yjii+0x95>
  800338:	eb 6c                	jmp    8003a6 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80033a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80033e:	83 eb 01             	sub    $0x1,%ebx
  800341:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800345:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800348:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80034c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800350:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800354:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800357:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80035a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800361:	00 
  800362:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800365:	89 14 24             	mov    %edx,(%esp)
  800368:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80036b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80036f:	e8 4c 3e 00 00       	call   8041c0 <__udivdi3>
  800374:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800377:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80037a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80037e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800382:	89 04 24             	mov    %eax,(%esp)
  800385:	89 54 24 04          	mov    %edx,0x4(%esp)
  800389:	89 f2                	mov    %esi,%edx
  80038b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038e:	e8 6d ff ff ff       	call   800300 <_ZL8printnumPFviPvES_yjii>
  800393:	eb 11                	jmp    8003a6 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800395:	89 74 24 04          	mov    %esi,0x4(%esp)
  800399:	89 3c 24             	mov    %edi,(%esp)
  80039c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039f:	83 eb 01             	sub    $0x1,%ebx
  8003a2:	85 db                	test   %ebx,%ebx
  8003a4:	7f ef                	jg     800395 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003aa:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003bc:	00 
  8003bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003c0:	89 14 24             	mov    %edx,(%esp)
  8003c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003ca:	e8 01 3f 00 00       	call   8042d0 <__umoddi3>
  8003cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d3:	0f be 80 67 44 80 00 	movsbl 0x804467(%eax),%eax
  8003da:	89 04 24             	mov    %eax,(%esp)
  8003dd:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003e0:	83 c4 4c             	add    $0x4c,%esp
  8003e3:	5b                   	pop    %ebx
  8003e4:	5e                   	pop    %esi
  8003e5:	5f                   	pop    %edi
  8003e6:	5d                   	pop    %ebp
  8003e7:	c3                   	ret    

008003e8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003eb:	83 fa 01             	cmp    $0x1,%edx
  8003ee:	7e 0e                	jle    8003fe <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  8003f0:	8b 10                	mov    (%eax),%edx
  8003f2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003f5:	89 08                	mov    %ecx,(%eax)
  8003f7:	8b 02                	mov    (%edx),%eax
  8003f9:	8b 52 04             	mov    0x4(%edx),%edx
  8003fc:	eb 22                	jmp    800420 <_ZL7getuintPPci+0x38>
	else if (lflag)
  8003fe:	85 d2                	test   %edx,%edx
  800400:	74 10                	je     800412 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800402:	8b 10                	mov    (%eax),%edx
  800404:	8d 4a 04             	lea    0x4(%edx),%ecx
  800407:	89 08                	mov    %ecx,(%eax)
  800409:	8b 02                	mov    (%edx),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	eb 0e                	jmp    800420 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800412:	8b 10                	mov    (%eax),%edx
  800414:	8d 4a 04             	lea    0x4(%edx),%ecx
  800417:	89 08                	mov    %ecx,(%eax)
  800419:	8b 02                	mov    (%edx),%eax
  80041b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800420:	5d                   	pop    %ebp
  800421:	c3                   	ret    

00800422 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800428:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80042c:	8b 10                	mov    (%eax),%edx
  80042e:	3b 50 04             	cmp    0x4(%eax),%edx
  800431:	73 0a                	jae    80043d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800433:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800436:	88 0a                	mov    %cl,(%edx)
  800438:	83 c2 01             	add    $0x1,%edx
  80043b:	89 10                	mov    %edx,(%eax)
}
  80043d:	5d                   	pop    %ebp
  80043e:	c3                   	ret    

0080043f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
  800442:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800445:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800448:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80044c:	8b 45 10             	mov    0x10(%ebp),%eax
  80044f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800453:	8b 45 0c             	mov    0xc(%ebp),%eax
  800456:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	89 04 24             	mov    %eax,(%esp)
  800460:	e8 02 00 00 00       	call   800467 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	57                   	push   %edi
  80046b:	56                   	push   %esi
  80046c:	53                   	push   %ebx
  80046d:	83 ec 3c             	sub    $0x3c,%esp
  800470:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800473:	8b 55 10             	mov    0x10(%ebp),%edx
  800476:	0f b6 02             	movzbl (%edx),%eax
  800479:	89 d3                	mov    %edx,%ebx
  80047b:	83 c3 01             	add    $0x1,%ebx
  80047e:	83 f8 25             	cmp    $0x25,%eax
  800481:	74 2b                	je     8004ae <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800483:	85 c0                	test   %eax,%eax
  800485:	75 10                	jne    800497 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800487:	e9 a5 03 00 00       	jmp    800831 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80048c:	85 c0                	test   %eax,%eax
  80048e:	66 90                	xchg   %ax,%ax
  800490:	75 08                	jne    80049a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800492:	e9 9a 03 00 00       	jmp    800831 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800497:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80049a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049e:	89 04 24             	mov    %eax,(%esp)
  8004a1:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a3:	0f b6 03             	movzbl (%ebx),%eax
  8004a6:	83 c3 01             	add    $0x1,%ebx
  8004a9:	83 f8 25             	cmp    $0x25,%eax
  8004ac:	75 de                	jne    80048c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8004ae:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8004b2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004b9:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8004be:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ca:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004cd:	eb 2b                	jmp    8004fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  8004d2:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8004d6:	eb 22                	jmp    8004fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004db:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8004df:	eb 19                	jmp    8004fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8004e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004eb:	eb 0d                	jmp    8004fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004ed:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004f0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8004f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	0f b6 03             	movzbl (%ebx),%eax
  8004fd:	0f b6 d0             	movzbl %al,%edx
  800500:	8d 73 01             	lea    0x1(%ebx),%esi
  800503:	89 75 10             	mov    %esi,0x10(%ebp)
  800506:	83 e8 23             	sub    $0x23,%eax
  800509:	3c 55                	cmp    $0x55,%al
  80050b:	0f 87 d8 02 00 00    	ja     8007e9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800511:	0f b6 c0             	movzbl %al,%eax
  800514:	ff 24 85 00 46 80 00 	jmp    *0x804600(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80051b:	83 ea 30             	sub    $0x30,%edx
  80051e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800521:	8b 55 10             	mov    0x10(%ebp),%edx
  800524:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800527:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80052d:	83 fa 09             	cmp    $0x9,%edx
  800530:	77 4e                	ja     800580 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800532:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800535:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800538:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80053b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80053f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800542:	8d 50 d0             	lea    -0x30(%eax),%edx
  800545:	83 fa 09             	cmp    $0x9,%edx
  800548:	76 eb                	jbe    800535 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80054a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80054d:	eb 31                	jmp    800580 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 50 04             	lea    0x4(%eax),%edx
  800555:	89 55 14             	mov    %edx,0x14(%ebp)
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800560:	eb 1e                	jmp    800580 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800562:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800566:	0f 88 75 ff ff ff    	js     8004e1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80056f:	eb 89                	jmp    8004fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800571:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800574:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80057b:	e9 7a ff ff ff       	jmp    8004fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800580:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800584:	0f 89 70 ff ff ff    	jns    8004fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80058a:	e9 5e ff ff ff       	jmp    8004ed <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80058f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800592:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800595:	e9 60 ff ff ff       	jmp    8004fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8d 50 04             	lea    0x4(%eax),%edx
  8005a0:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	89 04 24             	mov    %eax,(%esp)
  8005ac:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005af:	e9 bf fe ff ff       	jmp    800473 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	89 c2                	mov    %eax,%edx
  8005c1:	c1 fa 1f             	sar    $0x1f,%edx
  8005c4:	31 d0                	xor    %edx,%eax
  8005c6:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005c8:	83 f8 14             	cmp    $0x14,%eax
  8005cb:	7f 0f                	jg     8005dc <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  8005cd:	8b 14 85 60 47 80 00 	mov    0x804760(,%eax,4),%edx
  8005d4:	85 d2                	test   %edx,%edx
  8005d6:	0f 85 35 02 00 00    	jne    800811 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  8005dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005e0:	c7 44 24 08 7f 44 80 	movl   $0x80447f,0x8(%esp)
  8005e7:	00 
  8005e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ef:	89 34 24             	mov    %esi,(%esp)
  8005f2:	e8 48 fe ff ff       	call   80043f <_Z8printfmtPFviPvES_PKcz>
  8005f7:	e9 77 fe ff ff       	jmp    800473 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8005fc:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800602:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8d 50 04             	lea    0x4(%eax),%edx
  80060b:	89 55 14             	mov    %edx,0x14(%ebp)
  80060e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800610:	85 db                	test   %ebx,%ebx
  800612:	ba 78 44 80 00       	mov    $0x804478,%edx
  800617:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80061a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061e:	7e 72                	jle    800692 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800620:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800624:	74 6c                	je     800692 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800626:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062a:	89 1c 24             	mov    %ebx,(%esp)
  80062d:	e8 a9 02 00 00       	call   8008db <_Z7strnlenPKcj>
  800632:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800635:	29 c2                	sub    %eax,%edx
  800637:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80063a:	85 d2                	test   %edx,%edx
  80063c:	7e 54                	jle    800692 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80063e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800642:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800645:	89 d3                	mov    %edx,%ebx
  800647:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80064a:	89 c6                	mov    %eax,%esi
  80064c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800650:	89 34 24             	mov    %esi,(%esp)
  800653:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800656:	83 eb 01             	sub    $0x1,%ebx
  800659:	85 db                	test   %ebx,%ebx
  80065b:	7f ef                	jg     80064c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80065d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800660:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800663:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80066a:	eb 26                	jmp    800692 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80066c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80066f:	83 fa 5e             	cmp    $0x5e,%edx
  800672:	76 10                	jbe    800684 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800674:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800678:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80067f:	ff 55 08             	call   *0x8(%ebp)
  800682:	eb 0a                	jmp    80068e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800684:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800688:	89 04 24             	mov    %eax,(%esp)
  80068b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800692:	0f be 03             	movsbl (%ebx),%eax
  800695:	83 c3 01             	add    $0x1,%ebx
  800698:	85 c0                	test   %eax,%eax
  80069a:	74 11                	je     8006ad <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80069c:	85 f6                	test   %esi,%esi
  80069e:	78 05                	js     8006a5 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  8006a0:	83 ee 01             	sub    $0x1,%esi
  8006a3:	78 0d                	js     8006b2 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a9:	75 c1                	jne    80066c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  8006ab:	eb d7                	jmp    800684 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006b0:	eb 03                	jmp    8006b5 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  8006b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b5:	85 c0                	test   %eax,%eax
  8006b7:	0f 8e b6 fd ff ff    	jle    800473 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8006bd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8006c0:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  8006c3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006ce:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d0:	83 eb 01             	sub    $0x1,%ebx
  8006d3:	85 db                	test   %ebx,%ebx
  8006d5:	7f ec                	jg     8006c3 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  8006d7:	e9 97 fd ff ff       	jmp    800473 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006dc:	83 f9 01             	cmp    $0x1,%ecx
  8006df:	90                   	nop
  8006e0:	7e 10                	jle    8006f2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 50 08             	lea    0x8(%eax),%edx
  8006e8:	89 55 14             	mov    %edx,0x14(%ebp)
  8006eb:	8b 18                	mov    (%eax),%ebx
  8006ed:	8b 70 04             	mov    0x4(%eax),%esi
  8006f0:	eb 26                	jmp    800718 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  8006f2:	85 c9                	test   %ecx,%ecx
  8006f4:	74 12                	je     800708 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8d 50 04             	lea    0x4(%eax),%edx
  8006fc:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ff:	8b 18                	mov    (%eax),%ebx
  800701:	89 de                	mov    %ebx,%esi
  800703:	c1 fe 1f             	sar    $0x1f,%esi
  800706:	eb 10                	jmp    800718 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 50 04             	lea    0x4(%eax),%edx
  80070e:	89 55 14             	mov    %edx,0x14(%ebp)
  800711:	8b 18                	mov    (%eax),%ebx
  800713:	89 de                	mov    %ebx,%esi
  800715:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800718:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80071d:	85 f6                	test   %esi,%esi
  80071f:	0f 89 8c 00 00 00    	jns    8007b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800725:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800729:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800730:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800733:	f7 db                	neg    %ebx
  800735:	83 d6 00             	adc    $0x0,%esi
  800738:	f7 de                	neg    %esi
			}
			base = 10;
  80073a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073f:	eb 70                	jmp    8007b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800741:	89 ca                	mov    %ecx,%edx
  800743:	8d 45 14             	lea    0x14(%ebp),%eax
  800746:	e8 9d fc ff ff       	call   8003e8 <_ZL7getuintPPci>
  80074b:	89 c3                	mov    %eax,%ebx
  80074d:	89 d6                	mov    %edx,%esi
			base = 10;
  80074f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800754:	eb 5b                	jmp    8007b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800756:	89 ca                	mov    %ecx,%edx
  800758:	8d 45 14             	lea    0x14(%ebp),%eax
  80075b:	e8 88 fc ff ff       	call   8003e8 <_ZL7getuintPPci>
  800760:	89 c3                	mov    %eax,%ebx
  800762:	89 d6                	mov    %edx,%esi
			base = 8;
  800764:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800769:	eb 46                	jmp    8007b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80076b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800776:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800779:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800784:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 50 04             	lea    0x4(%eax),%edx
  80078d:	89 55 14             	mov    %edx,0x14(%ebp)
  800790:	8b 18                	mov    (%eax),%ebx
  800792:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800797:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80079c:	eb 13                	jmp    8007b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80079e:	89 ca                	mov    %ecx,%edx
  8007a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a3:	e8 40 fc ff ff       	call   8003e8 <_ZL7getuintPPci>
  8007a8:	89 c3                	mov    %eax,%ebx
  8007aa:	89 d6                	mov    %edx,%esi
			base = 16;
  8007ac:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b1:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8007b5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007bc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c4:	89 1c 24             	mov    %ebx,(%esp)
  8007c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007cb:	89 fa                	mov    %edi,%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	e8 2b fb ff ff       	call   800300 <_ZL8printnumPFviPvES_yjii>
			break;
  8007d5:	e9 99 fc ff ff       	jmp    800473 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007de:	89 14 24             	mov    %edx,(%esp)
  8007e1:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007e4:	e9 8a fc ff ff       	jmp    800473 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ed:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007f4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007fa:	89 d8                	mov    %ebx,%eax
  8007fc:	eb 02                	jmp    800800 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  8007fe:	89 d0                	mov    %edx,%eax
  800800:	8d 50 ff             	lea    -0x1(%eax),%edx
  800803:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800807:	75 f5                	jne    8007fe <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800809:	89 45 10             	mov    %eax,0x10(%ebp)
  80080c:	e9 62 fc ff ff       	jmp    800473 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800811:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800815:	c7 44 24 08 9d 48 80 	movl   $0x80489d,0x8(%esp)
  80081c:	00 
  80081d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800821:	8b 75 08             	mov    0x8(%ebp),%esi
  800824:	89 34 24             	mov    %esi,(%esp)
  800827:	e8 13 fc ff ff       	call   80043f <_Z8printfmtPFviPvES_PKcz>
  80082c:	e9 42 fc ff ff       	jmp    800473 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800831:	83 c4 3c             	add    $0x3c,%esp
  800834:	5b                   	pop    %ebx
  800835:	5e                   	pop    %esi
  800836:	5f                   	pop    %edi
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	83 ec 28             	sub    $0x28,%esp
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800845:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80084c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80084f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800853:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800856:	85 c0                	test   %eax,%eax
  800858:	74 30                	je     80088a <_Z9vsnprintfPciPKcS_+0x51>
  80085a:	85 d2                	test   %edx,%edx
  80085c:	7e 2c                	jle    80088a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800865:	8b 45 10             	mov    0x10(%ebp),%eax
  800868:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80086f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800873:	c7 04 24 22 04 80 00 	movl   $0x800422,(%esp)
  80087a:	e8 e8 fb ff ff       	call   800467 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80087f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800882:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800888:	eb 05                	jmp    80088f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80088a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80088f:	c9                   	leave  
  800890:	c3                   	ret    

00800891 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800897:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80089a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80089e:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	89 04 24             	mov    %eax,(%esp)
  8008b2:	e8 82 ff ff ff       	call   800839 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    
  8008b9:	00 00                	add    %al,(%eax)
  8008bb:	00 00                	add    %al,(%eax)
  8008bd:	00 00                	add    %al,(%eax)
	...

008008c0 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cb:	80 3a 00             	cmpb   $0x0,(%edx)
  8008ce:	74 09                	je     8008d9 <_Z6strlenPKc+0x19>
		n++;
  8008d0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d7:	75 f7                	jne    8008d0 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e9:	39 c2                	cmp    %eax,%edx
  8008eb:	74 0b                	je     8008f8 <_Z7strnlenPKcj+0x1d>
  8008ed:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008f1:	74 05                	je     8008f8 <_Z7strnlenPKcj+0x1d>
		n++;
  8008f3:	83 c0 01             	add    $0x1,%eax
  8008f6:	eb f1                	jmp    8008e9 <_Z7strnlenPKcj+0xe>
	return n;
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	53                   	push   %ebx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800904:	ba 00 00 00 00       	mov    $0x0,%edx
  800909:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80090d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800910:	83 c2 01             	add    $0x1,%edx
  800913:	84 c9                	test   %cl,%cl
  800915:	75 f2                	jne    800909 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800917:	5b                   	pop    %ebx
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	56                   	push   %esi
  80091e:	53                   	push   %ebx
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
  800925:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800928:	85 f6                	test   %esi,%esi
  80092a:	74 18                	je     800944 <_Z7strncpyPcPKcj+0x2a>
  80092c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800931:	0f b6 1a             	movzbl (%edx),%ebx
  800934:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800937:	80 3a 01             	cmpb   $0x1,(%edx)
  80093a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  80093d:	83 c1 01             	add    $0x1,%ecx
  800940:	39 ce                	cmp    %ecx,%esi
  800942:	77 ed                	ja     800931 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800944:	5b                   	pop    %ebx
  800945:	5e                   	pop    %esi
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	56                   	push   %esi
  80094c:	53                   	push   %ebx
  80094d:	8b 75 08             	mov    0x8(%ebp),%esi
  800950:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800953:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800956:	89 f0                	mov    %esi,%eax
  800958:	85 d2                	test   %edx,%edx
  80095a:	74 17                	je     800973 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  80095c:	83 ea 01             	sub    $0x1,%edx
  80095f:	74 18                	je     800979 <_Z7strlcpyPcPKcj+0x31>
  800961:	80 39 00             	cmpb   $0x0,(%ecx)
  800964:	74 17                	je     80097d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800966:	0f b6 19             	movzbl (%ecx),%ebx
  800969:	88 18                	mov    %bl,(%eax)
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	83 c1 01             	add    $0x1,%ecx
  800971:	eb e9                	jmp    80095c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800973:	29 f0                	sub    %esi,%eax
}
  800975:	5b                   	pop    %ebx
  800976:	5e                   	pop    %esi
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800979:	89 c2                	mov    %eax,%edx
  80097b:	eb 02                	jmp    80097f <_Z7strlcpyPcPKcj+0x37>
  80097d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  80097f:	c6 02 00             	movb   $0x0,(%edx)
  800982:	eb ef                	jmp    800973 <_Z7strlcpyPcPKcj+0x2b>

00800984 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80098d:	0f b6 01             	movzbl (%ecx),%eax
  800990:	84 c0                	test   %al,%al
  800992:	74 0c                	je     8009a0 <_Z6strcmpPKcS0_+0x1c>
  800994:	3a 02                	cmp    (%edx),%al
  800996:	75 08                	jne    8009a0 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800998:	83 c1 01             	add    $0x1,%ecx
  80099b:	83 c2 01             	add    $0x1,%edx
  80099e:	eb ed                	jmp    80098d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  8009a0:	0f b6 c0             	movzbl %al,%eax
  8009a3:	0f b6 12             	movzbl (%edx),%edx
  8009a6:	29 d0                	sub    %edx,%eax
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	53                   	push   %ebx
  8009ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009b4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	74 16                	je     8009d1 <_Z7strncmpPKcS0_j+0x27>
  8009bb:	0f b6 01             	movzbl (%ecx),%eax
  8009be:	84 c0                	test   %al,%al
  8009c0:	74 17                	je     8009d9 <_Z7strncmpPKcS0_j+0x2f>
  8009c2:	3a 03                	cmp    (%ebx),%al
  8009c4:	75 13                	jne    8009d9 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  8009c6:	83 ea 01             	sub    $0x1,%edx
  8009c9:	83 c1 01             	add    $0x1,%ecx
  8009cc:	83 c3 01             	add    $0x1,%ebx
  8009cf:	eb e6                	jmp    8009b7 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  8009d6:	5b                   	pop    %ebx
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  8009d9:	0f b6 01             	movzbl (%ecx),%eax
  8009dc:	0f b6 13             	movzbl (%ebx),%edx
  8009df:	29 d0                	sub    %edx,%eax
  8009e1:	eb f3                	jmp    8009d6 <_Z7strncmpPKcS0_j+0x2c>

008009e3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ed:	0f b6 10             	movzbl (%eax),%edx
  8009f0:	84 d2                	test   %dl,%dl
  8009f2:	74 1f                	je     800a13 <_Z6strchrPKcc+0x30>
		if (*s == c)
  8009f4:	38 ca                	cmp    %cl,%dl
  8009f6:	75 0a                	jne    800a02 <_Z6strchrPKcc+0x1f>
  8009f8:	eb 1e                	jmp    800a18 <_Z6strchrPKcc+0x35>
  8009fa:	38 ca                	cmp    %cl,%dl
  8009fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a00:	74 16                	je     800a18 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a02:	83 c0 01             	add    $0x1,%eax
  800a05:	0f b6 10             	movzbl (%eax),%edx
  800a08:	84 d2                	test   %dl,%dl
  800a0a:	75 ee                	jne    8009fa <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	eb 05                	jmp    800a18 <_Z6strchrPKcc+0x35>
  800a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a24:	0f b6 10             	movzbl (%eax),%edx
  800a27:	84 d2                	test   %dl,%dl
  800a29:	74 14                	je     800a3f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800a2b:	38 ca                	cmp    %cl,%dl
  800a2d:	75 06                	jne    800a35 <_Z7strfindPKcc+0x1b>
  800a2f:	eb 0e                	jmp    800a3f <_Z7strfindPKcc+0x25>
  800a31:	38 ca                	cmp    %cl,%dl
  800a33:	74 0a                	je     800a3f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a35:	83 c0 01             	add    $0x1,%eax
  800a38:	0f b6 10             	movzbl (%eax),%edx
  800a3b:	84 d2                	test   %dl,%dl
  800a3d:	75 f2                	jne    800a31 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	89 1c 24             	mov    %ebx,(%esp)
  800a4a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a4e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a52:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a58:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800a5b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a61:	75 25                	jne    800a88 <memset+0x47>
  800a63:	f6 c1 03             	test   $0x3,%cl
  800a66:	75 20                	jne    800a88 <memset+0x47>
		c &= 0xFF;
  800a68:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6b:	89 d3                	mov    %edx,%ebx
  800a6d:	c1 e3 08             	shl    $0x8,%ebx
  800a70:	89 d6                	mov    %edx,%esi
  800a72:	c1 e6 18             	shl    $0x18,%esi
  800a75:	89 d0                	mov    %edx,%eax
  800a77:	c1 e0 10             	shl    $0x10,%eax
  800a7a:	09 f0                	or     %esi,%eax
  800a7c:	09 d0                	or     %edx,%eax
  800a7e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800a80:	c1 e9 02             	shr    $0x2,%ecx
  800a83:	fc                   	cld    
  800a84:	f3 ab                	rep stos %eax,%es:(%edi)
  800a86:	eb 03                	jmp    800a8b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800a88:	fc                   	cld    
  800a89:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800a8b:	89 f8                	mov    %edi,%eax
  800a8d:	8b 1c 24             	mov    (%esp),%ebx
  800a90:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a94:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a98:	89 ec                	mov    %ebp,%esp
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	89 34 24             	mov    %esi,(%esp)
  800aa5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800ab2:	39 c6                	cmp    %eax,%esi
  800ab4:	73 36                	jae    800aec <memmove+0x50>
  800ab6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab9:	39 d0                	cmp    %edx,%eax
  800abb:	73 2f                	jae    800aec <memmove+0x50>
		s += n;
		d += n;
  800abd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800ac0:	f6 c2 03             	test   $0x3,%dl
  800ac3:	75 1b                	jne    800ae0 <memmove+0x44>
  800ac5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800acb:	75 13                	jne    800ae0 <memmove+0x44>
  800acd:	f6 c1 03             	test   $0x3,%cl
  800ad0:	75 0e                	jne    800ae0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ad2:	83 ef 04             	sub    $0x4,%edi
  800ad5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad8:	c1 e9 02             	shr    $0x2,%ecx
  800adb:	fd                   	std    
  800adc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ade:	eb 09                	jmp    800ae9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ae0:	83 ef 01             	sub    $0x1,%edi
  800ae3:	8d 72 ff             	lea    -0x1(%edx),%esi
  800ae6:	fd                   	std    
  800ae7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae9:	fc                   	cld    
  800aea:	eb 20                	jmp    800b0c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800aec:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af2:	75 13                	jne    800b07 <memmove+0x6b>
  800af4:	a8 03                	test   $0x3,%al
  800af6:	75 0f                	jne    800b07 <memmove+0x6b>
  800af8:	f6 c1 03             	test   $0x3,%cl
  800afb:	75 0a                	jne    800b07 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800afd:	c1 e9 02             	shr    $0x2,%ecx
  800b00:	89 c7                	mov    %eax,%edi
  800b02:	fc                   	cld    
  800b03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b05:	eb 05                	jmp    800b0c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b07:	89 c7                	mov    %eax,%edi
  800b09:	fc                   	cld    
  800b0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800b0c:	8b 34 24             	mov    (%esp),%esi
  800b0f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b13:	89 ec                	mov    %ebp,%esp
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	89 34 24             	mov    %esi,(%esp)
  800b20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b2d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b33:	75 13                	jne    800b48 <memcpy+0x31>
  800b35:	a8 03                	test   $0x3,%al
  800b37:	75 0f                	jne    800b48 <memcpy+0x31>
  800b39:	f6 c1 03             	test   $0x3,%cl
  800b3c:	75 0a                	jne    800b48 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b3e:	c1 e9 02             	shr    $0x2,%ecx
  800b41:	89 c7                	mov    %eax,%edi
  800b43:	fc                   	cld    
  800b44:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b46:	eb 05                	jmp    800b4d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b48:	89 c7                	mov    %eax,%edi
  800b4a:	fc                   	cld    
  800b4b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800b4d:	8b 34 24             	mov    (%esp),%esi
  800b50:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b54:	89 ec                	mov    %ebp,%esp
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
  800b5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b61:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b64:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b6c:	85 ff                	test   %edi,%edi
  800b6e:	74 38                	je     800ba8 <memcmp+0x50>
		if (*s1 != *s2)
  800b70:	0f b6 03             	movzbl (%ebx),%eax
  800b73:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b76:	83 ef 01             	sub    $0x1,%edi
  800b79:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b7e:	38 c8                	cmp    %cl,%al
  800b80:	74 1d                	je     800b9f <memcmp+0x47>
  800b82:	eb 11                	jmp    800b95 <memcmp+0x3d>
  800b84:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b89:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	38 c8                	cmp    %cl,%al
  800b93:	74 0a                	je     800b9f <memcmp+0x47>
			return *s1 - *s2;
  800b95:	0f b6 c0             	movzbl %al,%eax
  800b98:	0f b6 c9             	movzbl %cl,%ecx
  800b9b:	29 c8                	sub    %ecx,%eax
  800b9d:	eb 09                	jmp    800ba8 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b9f:	39 fa                	cmp    %edi,%edx
  800ba1:	75 e1                	jne    800b84 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800ba3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5f                   	pop    %edi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	53                   	push   %ebx
  800bb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800bb4:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800bb6:	89 da                	mov    %ebx,%edx
  800bb8:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800bbb:	39 d3                	cmp    %edx,%ebx
  800bbd:	73 15                	jae    800bd4 <memfind+0x27>
		if (*s == (unsigned char) c)
  800bbf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800bc3:	38 0b                	cmp    %cl,(%ebx)
  800bc5:	75 06                	jne    800bcd <memfind+0x20>
  800bc7:	eb 0b                	jmp    800bd4 <memfind+0x27>
  800bc9:	38 08                	cmp    %cl,(%eax)
  800bcb:	74 07                	je     800bd4 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800bcd:	83 c0 01             	add    $0x1,%eax
  800bd0:	39 c2                	cmp    %eax,%edx
  800bd2:	77 f5                	ja     800bc9 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800be0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be3:	0f b6 02             	movzbl (%edx),%eax
  800be6:	3c 20                	cmp    $0x20,%al
  800be8:	74 04                	je     800bee <_Z6strtolPKcPPci+0x17>
  800bea:	3c 09                	cmp    $0x9,%al
  800bec:	75 0e                	jne    800bfc <_Z6strtolPKcPPci+0x25>
		s++;
  800bee:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf1:	0f b6 02             	movzbl (%edx),%eax
  800bf4:	3c 20                	cmp    $0x20,%al
  800bf6:	74 f6                	je     800bee <_Z6strtolPKcPPci+0x17>
  800bf8:	3c 09                	cmp    $0x9,%al
  800bfa:	74 f2                	je     800bee <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bfc:	3c 2b                	cmp    $0x2b,%al
  800bfe:	75 0a                	jne    800c0a <_Z6strtolPKcPPci+0x33>
		s++;
  800c00:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c03:	bf 00 00 00 00       	mov    $0x0,%edi
  800c08:	eb 10                	jmp    800c1a <_Z6strtolPKcPPci+0x43>
  800c0a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c0f:	3c 2d                	cmp    $0x2d,%al
  800c11:	75 07                	jne    800c1a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800c13:	83 c2 01             	add    $0x1,%edx
  800c16:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1a:	85 db                	test   %ebx,%ebx
  800c1c:	0f 94 c0             	sete   %al
  800c1f:	74 05                	je     800c26 <_Z6strtolPKcPPci+0x4f>
  800c21:	83 fb 10             	cmp    $0x10,%ebx
  800c24:	75 15                	jne    800c3b <_Z6strtolPKcPPci+0x64>
  800c26:	80 3a 30             	cmpb   $0x30,(%edx)
  800c29:	75 10                	jne    800c3b <_Z6strtolPKcPPci+0x64>
  800c2b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c2f:	75 0a                	jne    800c3b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800c31:	83 c2 02             	add    $0x2,%edx
  800c34:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c39:	eb 13                	jmp    800c4e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800c3b:	84 c0                	test   %al,%al
  800c3d:	74 0f                	je     800c4e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c3f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c44:	80 3a 30             	cmpb   $0x30,(%edx)
  800c47:	75 05                	jne    800c4e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800c49:	83 c2 01             	add    $0x1,%edx
  800c4c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c53:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c55:	0f b6 0a             	movzbl (%edx),%ecx
  800c58:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c5b:	80 fb 09             	cmp    $0x9,%bl
  800c5e:	77 08                	ja     800c68 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800c60:	0f be c9             	movsbl %cl,%ecx
  800c63:	83 e9 30             	sub    $0x30,%ecx
  800c66:	eb 1e                	jmp    800c86 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c68:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c6b:	80 fb 19             	cmp    $0x19,%bl
  800c6e:	77 08                	ja     800c78 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800c70:	0f be c9             	movsbl %cl,%ecx
  800c73:	83 e9 57             	sub    $0x57,%ecx
  800c76:	eb 0e                	jmp    800c86 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c78:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c7b:	80 fb 19             	cmp    $0x19,%bl
  800c7e:	77 15                	ja     800c95 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800c80:	0f be c9             	movsbl %cl,%ecx
  800c83:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c86:	39 f1                	cmp    %esi,%ecx
  800c88:	7d 0f                	jge    800c99 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800c8a:	83 c2 01             	add    $0x1,%edx
  800c8d:	0f af c6             	imul   %esi,%eax
  800c90:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800c93:	eb c0                	jmp    800c55 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c95:	89 c1                	mov    %eax,%ecx
  800c97:	eb 02                	jmp    800c9b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c99:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9f:	74 05                	je     800ca6 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800ca1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ca4:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ca6:	89 ca                	mov    %ecx,%edx
  800ca8:	f7 da                	neg    %edx
  800caa:	85 ff                	test   %edi,%edi
  800cac:	0f 45 c2             	cmovne %edx,%eax
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 0c             	sub    $0xc,%esp
  800cba:	89 1c 24             	mov    %ebx,(%esp)
  800cbd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cc1:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd0:	89 c3                	mov    %eax,%ebx
  800cd2:	89 c7                	mov    %eax,%edi
  800cd4:	89 c6                	mov    %eax,%esi
  800cd6:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cd8:	8b 1c 24             	mov    (%esp),%ebx
  800cdb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cdf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ce3:	89 ec                	mov    %ebp,%esp
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	83 ec 0c             	sub    $0xc,%esp
  800ced:	89 1c 24             	mov    %ebx,(%esp)
  800cf0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cf4:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800cf8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfd:	b8 01 00 00 00       	mov    $0x1,%eax
  800d02:	89 d1                	mov    %edx,%ecx
  800d04:	89 d3                	mov    %edx,%ebx
  800d06:	89 d7                	mov    %edx,%edi
  800d08:	89 d6                	mov    %edx,%esi
  800d0a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d0c:	8b 1c 24             	mov    (%esp),%ebx
  800d0f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d13:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d17:	89 ec                	mov    %ebp,%esp
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 38             	sub    $0x38,%esp
  800d21:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d24:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d27:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	89 cb                	mov    %ecx,%ebx
  800d39:	89 cf                	mov    %ecx,%edi
  800d3b:	89 ce                	mov    %ecx,%esi
  800d3d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	7e 28                	jle    800d6b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d43:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d47:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d4e:	00 
  800d4f:	c7 44 24 08 b4 47 80 	movl   $0x8047b4,0x8(%esp)
  800d56:	00 
  800d57:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d5e:	00 
  800d5f:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  800d66:	e8 5d f4 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d6e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d71:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d74:	89 ec                	mov    %ebp,%esp
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 0c             	sub    $0xc,%esp
  800d7e:	89 1c 24             	mov    %ebx,(%esp)
  800d81:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d85:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d89:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8e:	b8 02 00 00 00       	mov    $0x2,%eax
  800d93:	89 d1                	mov    %edx,%ecx
  800d95:	89 d3                	mov    %edx,%ebx
  800d97:	89 d7                	mov    %edx,%edi
  800d99:	89 d6                	mov    %edx,%esi
  800d9b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d9d:	8b 1c 24             	mov    (%esp),%ebx
  800da0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800da4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800da8:	89 ec                	mov    %ebp,%esp
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	89 1c 24             	mov    %ebx,(%esp)
  800db5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800db9:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc2:	b8 04 00 00 00       	mov    $0x4,%eax
  800dc7:	89 d1                	mov    %edx,%ecx
  800dc9:	89 d3                	mov    %edx,%ebx
  800dcb:	89 d7                	mov    %edx,%edi
  800dcd:	89 d6                	mov    %edx,%esi
  800dcf:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dd1:	8b 1c 24             	mov    (%esp),%ebx
  800dd4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dd8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ddc:	89 ec                	mov    %ebp,%esp
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 38             	sub    $0x38,%esp
  800de6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dec:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800def:	be 00 00 00 00       	mov    $0x0,%esi
  800df4:	b8 08 00 00 00       	mov    $0x8,%eax
  800df9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	89 f7                	mov    %esi,%edi
  800e04:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	7e 28                	jle    800e32 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e15:	00 
  800e16:	c7 44 24 08 b4 47 80 	movl   $0x8047b4,0x8(%esp)
  800e1d:	00 
  800e1e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e25:	00 
  800e26:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  800e2d:	e8 96 f3 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e32:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e35:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e38:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e3b:	89 ec                	mov    %ebp,%esp
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 38             	sub    $0x38,%esp
  800e45:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e48:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e4b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e4e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e53:	8b 75 18             	mov    0x18(%ebp),%esi
  800e56:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e59:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7e 28                	jle    800e90 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e68:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e73:	00 
  800e74:	c7 44 24 08 b4 47 80 	movl   $0x8047b4,0x8(%esp)
  800e7b:	00 
  800e7c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e83:	00 
  800e84:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  800e8b:	e8 38 f3 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e90:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e93:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e96:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e99:	89 ec                	mov    %ebp,%esp
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    

00800e9d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 38             	sub    $0x38,%esp
  800ea3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea9:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800eac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	89 df                	mov    %ebx,%edi
  800ebe:	89 de                	mov    %ebx,%esi
  800ec0:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	7e 28                	jle    800eee <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ed1:	00 
  800ed2:	c7 44 24 08 b4 47 80 	movl   $0x8047b4,0x8(%esp)
  800ed9:	00 
  800eda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee1:	00 
  800ee2:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  800ee9:	e8 da f2 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef7:	89 ec                	mov    %ebp,%esp
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 38             	sub    $0x38,%esp
  800f01:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f04:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f07:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f17:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1a:	89 df                	mov    %ebx,%edi
  800f1c:	89 de                	mov    %ebx,%esi
  800f1e:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	7e 28                	jle    800f4c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f24:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f28:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f2f:	00 
  800f30:	c7 44 24 08 b4 47 80 	movl   $0x8047b4,0x8(%esp)
  800f37:	00 
  800f38:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3f:	00 
  800f40:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  800f47:	e8 7c f2 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f4c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f4f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f52:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f55:	89 ec                	mov    %ebp,%esp
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	83 ec 38             	sub    $0x38,%esp
  800f5f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f62:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f65:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f75:	8b 55 08             	mov    0x8(%ebp),%edx
  800f78:	89 df                	mov    %ebx,%edi
  800f7a:	89 de                	mov    %ebx,%esi
  800f7c:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	7e 28                	jle    800faa <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f82:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f86:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f8d:	00 
  800f8e:	c7 44 24 08 b4 47 80 	movl   $0x8047b4,0x8(%esp)
  800f95:	00 
  800f96:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9d:	00 
  800f9e:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  800fa5:	e8 1e f2 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800faa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fad:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb3:	89 ec                	mov    %ebp,%esp
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 38             	sub    $0x38,%esp
  800fbd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc3:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	7e 28                	jle    801008 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe4:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800feb:	00 
  800fec:	c7 44 24 08 b4 47 80 	movl   $0x8047b4,0x8(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ffb:	00 
  800ffc:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  801003:	e8 c0 f1 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801008:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80100b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801011:	89 ec                	mov    %ebp,%esp
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 38             	sub    $0x38,%esp
  80101b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801021:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
  801029:	b8 0c 00 00 00       	mov    $0xc,%eax
  80102e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	89 df                	mov    %ebx,%edi
  801036:	89 de                	mov    %ebx,%esi
  801038:	cd 30                	int    $0x30

	if(check && ret > 0)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	7e 28                	jle    801066 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801042:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801049:	00 
  80104a:	c7 44 24 08 b4 47 80 	movl   $0x8047b4,0x8(%esp)
  801051:	00 
  801052:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801059:	00 
  80105a:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  801061:	e8 62 f1 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801066:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801069:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80106c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80106f:	89 ec                	mov    %ebp,%esp
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 0c             	sub    $0xc,%esp
  801079:	89 1c 24             	mov    %ebx,(%esp)
  80107c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801080:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801084:	be 00 00 00 00       	mov    $0x0,%esi
  801089:	b8 0d 00 00 00       	mov    $0xd,%eax
  80108e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801091:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801094:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801097:	8b 55 08             	mov    0x8(%ebp),%edx
  80109a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80109c:	8b 1c 24             	mov    (%esp),%ebx
  80109f:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010a3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010a7:	89 ec                	mov    %ebp,%esp
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 38             	sub    $0x38,%esp
  8010b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010bf:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c7:	89 cb                	mov    %ecx,%ebx
  8010c9:	89 cf                	mov    %ecx,%edi
  8010cb:	89 ce                	mov    %ecx,%esi
  8010cd:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	7e 28                	jle    8010fb <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d7:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8010de:	00 
  8010df:	c7 44 24 08 b4 47 80 	movl   $0x8047b4,0x8(%esp)
  8010e6:	00 
  8010e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ee:	00 
  8010ef:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  8010f6:	e8 cd f0 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801101:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801104:	89 ec                	mov    %ebp,%esp
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    

00801108 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	83 ec 0c             	sub    $0xc,%esp
  80110e:	89 1c 24             	mov    %ebx,(%esp)
  801111:	89 74 24 04          	mov    %esi,0x4(%esp)
  801115:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801119:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801123:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801126:	8b 55 08             	mov    0x8(%ebp),%edx
  801129:	89 df                	mov    %ebx,%edi
  80112b:	89 de                	mov    %ebx,%esi
  80112d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80112f:	8b 1c 24             	mov    (%esp),%ebx
  801132:	8b 74 24 04          	mov    0x4(%esp),%esi
  801136:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80113a:	89 ec                	mov    %ebp,%esp
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    

0080113e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 0c             	sub    $0xc,%esp
  801144:	89 1c 24             	mov    %ebx,(%esp)
  801147:	89 74 24 04          	mov    %esi,0x4(%esp)
  80114b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80114f:	ba 00 00 00 00       	mov    $0x0,%edx
  801154:	b8 11 00 00 00       	mov    $0x11,%eax
  801159:	89 d1                	mov    %edx,%ecx
  80115b:	89 d3                	mov    %edx,%ebx
  80115d:	89 d7                	mov    %edx,%edi
  80115f:	89 d6                	mov    %edx,%esi
  801161:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801163:	8b 1c 24             	mov    (%esp),%ebx
  801166:	8b 74 24 04          	mov    0x4(%esp),%esi
  80116a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80116e:	89 ec                	mov    %ebp,%esp
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    

00801172 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	89 1c 24             	mov    %ebx,(%esp)
  80117b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801183:	bb 00 00 00 00       	mov    $0x0,%ebx
  801188:	b8 12 00 00 00       	mov    $0x12,%eax
  80118d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801190:	8b 55 08             	mov    0x8(%ebp),%edx
  801193:	89 df                	mov    %ebx,%edi
  801195:	89 de                	mov    %ebx,%esi
  801197:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801199:	8b 1c 24             	mov    (%esp),%ebx
  80119c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011a0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011a4:	89 ec                	mov    %ebp,%esp
  8011a6:	5d                   	pop    %ebp
  8011a7:	c3                   	ret    

008011a8 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 0c             	sub    $0xc,%esp
  8011ae:	89 1c 24             	mov    %ebx,(%esp)
  8011b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011b5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011be:	b8 13 00 00 00       	mov    $0x13,%eax
  8011c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c6:	89 cb                	mov    %ecx,%ebx
  8011c8:	89 cf                	mov    %ecx,%edi
  8011ca:	89 ce                	mov    %ecx,%esi
  8011cc:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  8011ce:	8b 1c 24             	mov    (%esp),%ebx
  8011d1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011d5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011d9:	89 ec                	mov    %ebp,%esp
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 0c             	sub    $0xc,%esp
  8011e3:	89 1c 24             	mov    %ebx,(%esp)
  8011e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ea:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8011f3:	8b 75 18             	mov    0x18(%ebp),%esi
  8011f6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801202:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801204:	8b 1c 24             	mov    (%esp),%ebx
  801207:	8b 74 24 04          	mov    0x4(%esp),%esi
  80120b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80120f:	89 ec                	mov    %ebp,%esp
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    
	...

00801214 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	83 ec 38             	sub    $0x38,%esp
  80121a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80121d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801220:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  801223:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  80122a:	f6 c7 04             	test   $0x4,%bh
  80122d:	74 31                	je     801260 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  80122f:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  801236:	c1 e2 0c             	shl    $0xc,%edx
  801239:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80123f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801243:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801247:	89 44 24 08          	mov    %eax,0x8(%esp)
  80124b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80124f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801256:	e8 e4 fb ff ff       	call   800e3f <_Z12sys_page_mapiPviS_i>
        return r;
  80125b:	e9 8c 00 00 00       	jmp    8012ec <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  801260:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  801267:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  80126c:	f7 c6 00 08 00 00    	test   $0x800,%esi
  801272:	75 2a                	jne    80129e <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  801274:	84 c9                	test   %cl,%cl
  801276:	74 0f                	je     801287 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  801278:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  80127f:	83 e3 02             	and    $0x2,%ebx
  801282:	80 cf 02             	or     $0x2,%bh
  801285:	eb 17                	jmp    80129e <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  801287:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  80128e:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  801291:	83 f9 01             	cmp    $0x1,%ecx
  801294:	19 db                	sbb    %ebx,%ebx
  801296:	f7 d3                	not    %ebx
  801298:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80129e:	89 df                	mov    %ebx,%edi
  8012a0:	83 cf 05             	or     $0x5,%edi
  8012a3:	89 d6                	mov    %edx,%esi
  8012a5:	c1 e6 0c             	shl    $0xc,%esi
  8012a8:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8012ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012b4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012bf:	e8 7b fb ff ff       	call   800e3f <_Z12sys_page_mapiPviS_i>
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	75 24                	jne    8012ec <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  8012c8:	85 db                	test   %ebx,%ebx
  8012ca:	74 20                	je     8012ec <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  8012cc:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8012d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012db:	00 
  8012dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e7:	e8 53 fb ff ff       	call   800e3f <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  8012ec:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012ef:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012f5:	89 ec                	mov    %ebp,%esp
  8012f7:	5d                   	pop    %ebp
  8012f8:	c3                   	ret    

008012f9 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	83 ec 28             	sub    $0x28,%esp
  8012ff:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801302:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801305:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  801308:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  80130a:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  80130e:	0f 84 ff 00 00 00    	je     801413 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  801314:	89 f0                	mov    %esi,%eax
  801316:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  801319:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801320:	f6 c4 08             	test   $0x8,%ah
  801323:	0f 84 ea 00 00 00    	je     801413 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801329:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801330:	00 
  801331:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801338:	00 
  801339:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801340:	e8 9b fa ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  801345:	85 c0                	test   %eax,%eax
  801347:	79 20                	jns    801369 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  801349:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80134d:	c7 44 24 08 df 47 80 	movl   $0x8047df,0x8(%esp)
  801354:	00 
  801355:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  80135c:	00 
  80135d:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  801364:	e8 5f ee ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  801369:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  80136f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801376:	00 
  801377:	89 74 24 04          	mov    %esi,0x4(%esp)
  80137b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801382:	e8 90 f7 ff ff       	call   800b17 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801387:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80138e:	00 
  80138f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801393:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80139a:	00 
  80139b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013a2:	00 
  8013a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013aa:	e8 90 fa ff ff       	call   800e3f <_Z12sys_page_mapiPviS_i>
  8013af:	85 c0                	test   %eax,%eax
  8013b1:	79 20                	jns    8013d3 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  8013b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013b7:	c7 44 24 08 fd 47 80 	movl   $0x8047fd,0x8(%esp)
  8013be:	00 
  8013bf:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8013c6:	00 
  8013c7:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  8013ce:	e8 f5 ed ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  8013d3:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013da:	00 
  8013db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e2:	e8 b6 fa ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
  8013e7:	85 c0                	test   %eax,%eax
  8013e9:	79 20                	jns    80140b <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  8013eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ef:	c7 44 24 08 0e 48 80 	movl   $0x80480e,0x8(%esp)
  8013f6:	00 
  8013f7:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8013fe:	00 
  8013ff:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  801406:	e8 bd ed ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
    resume(utf);
  80140b:	89 1c 24             	mov    %ebx,(%esp)
  80140e:	e8 8d 2d 00 00       	call   8041a0 <resume>
}
  801413:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801416:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801419:	89 ec                	mov    %ebp,%esp
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	57                   	push   %edi
  801421:	56                   	push   %esi
  801422:	53                   	push   %ebx
  801423:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  801426:	c7 04 24 f9 12 80 00 	movl   $0x8012f9,(%esp)
  80142d:	e8 99 2c 00 00       	call   8040cb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  801432:	be 07 00 00 00       	mov    $0x7,%esi
  801437:	89 f0                	mov    %esi,%eax
  801439:	cd 30                	int    $0x30
  80143b:	89 c6                	mov    %eax,%esi
  80143d:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  80143f:	85 c0                	test   %eax,%eax
  801441:	79 20                	jns    801463 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  801443:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801447:	c7 44 24 08 21 48 80 	movl   $0x804821,0x8(%esp)
  80144e:	00 
  80144f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801456:	00 
  801457:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  80145e:	e8 65 ed ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801463:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  801468:	85 c0                	test   %eax,%eax
  80146a:	75 1c                	jne    801488 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  80146c:	e8 07 f9 ff ff       	call   800d78 <_Z12sys_getenvidv>
  801471:	25 ff 03 00 00       	and    $0x3ff,%eax
  801476:	6b c0 78             	imul   $0x78,%eax,%eax
  801479:	05 00 00 00 ef       	add    $0xef000000,%eax
  80147e:	a3 00 60 80 00       	mov    %eax,0x806000
        return 0;
  801483:	e9 de 00 00 00       	jmp    801566 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  801488:	89 d8                	mov    %ebx,%eax
  80148a:	c1 f8 0a             	sar    $0xa,%eax
  80148d:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801494:	a8 01                	test   $0x1,%al
  801496:	75 08                	jne    8014a0 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  801498:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  80149e:	eb 19                	jmp    8014b9 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  8014a0:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8014a7:	a8 01                	test   $0x1,%al
  8014a9:	74 0e                	je     8014b9 <_Z4forkv+0x9c>
            duppage(envid, pn);
  8014ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014b0:	89 da                	mov    %ebx,%edx
  8014b2:	89 f8                	mov    %edi,%eax
  8014b4:	e8 5b fd ff ff       	call   801214 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  8014b9:	83 eb 01             	sub    $0x1,%ebx
  8014bc:	79 ca                	jns    801488 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  8014be:	a1 00 60 80 00       	mov    0x806000,%eax
  8014c3:	8b 40 5c             	mov    0x5c(%eax),%eax
  8014c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ca:	89 34 24             	mov    %esi,(%esp)
  8014cd:	e8 43 fb ff ff       	call   801015 <_Z26sys_env_set_pgfault_upcalliPv>
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	74 20                	je     8014f6 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  8014d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014da:	c7 44 24 08 48 48 80 	movl   $0x804848,0x8(%esp)
  8014e1:	00 
  8014e2:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  8014e9:	00 
  8014ea:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  8014f1:	e8 d2 ec ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8014f6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014fd:	00 
  8014fe:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  801505:	ee 
  801506:	89 34 24             	mov    %esi,(%esp)
  801509:	e8 d2 f8 ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  80150e:	85 c0                	test   %eax,%eax
  801510:	79 20                	jns    801532 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  801512:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801516:	c7 44 24 08 df 47 80 	movl   $0x8047df,0x8(%esp)
  80151d:	00 
  80151e:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  801525:	00 
  801526:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  80152d:	e8 96 ec ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801532:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801539:	00 
  80153a:	89 34 24             	mov    %esi,(%esp)
  80153d:	e8 b9 f9 ff ff       	call   800efb <_Z18sys_env_set_statusii>
  801542:	85 c0                	test   %eax,%eax
  801544:	79 20                	jns    801566 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  801546:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80154a:	c7 44 24 08 31 48 80 	movl   $0x804831,0x8(%esp)
  801551:	00 
  801552:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801559:	00 
  80155a:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  801561:	e8 62 ec ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

    return envid;
}
  801566:	89 f0                	mov    %esi,%eax
  801568:	83 c4 1c             	add    $0x1c,%esp
  80156b:	5b                   	pop    %ebx
  80156c:	5e                   	pop    %esi
  80156d:	5f                   	pop    %edi
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	57                   	push   %edi
  801574:	56                   	push   %esi
  801575:	53                   	push   %ebx
  801576:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  801579:	c7 04 24 f9 12 80 00 	movl   $0x8012f9,(%esp)
  801580:	e8 46 2b 00 00       	call   8040cb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  801585:	be 07 00 00 00       	mov    $0x7,%esi
  80158a:	89 f0                	mov    %esi,%eax
  80158c:	cd 30                	int    $0x30
  80158e:	89 c6                	mov    %eax,%esi
  801590:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  801592:	85 c0                	test   %eax,%eax
  801594:	79 20                	jns    8015b6 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  801596:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80159a:	c7 44 24 08 21 48 80 	movl   $0x804821,0x8(%esp)
  8015a1:	00 
  8015a2:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  8015a9:	00 
  8015aa:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  8015b1:	e8 12 ec ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	0f 84 40 01 00 00    	je     8016fe <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  8015be:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  8015c0:	c1 eb 0c             	shr    $0xc,%ebx
  8015c3:	83 eb 01             	sub    $0x1,%ebx
  8015c6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  8015c9:	eb 31                	jmp    8015fc <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  8015cb:	89 d8                	mov    %ebx,%eax
  8015cd:	c1 f8 0a             	sar    $0xa,%eax
  8015d0:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8015d7:	a8 01                	test   $0x1,%al
  8015d9:	75 08                	jne    8015e3 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  8015db:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8015e1:	eb 19                	jmp    8015fc <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  8015e3:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8015ea:	a8 01                	test   $0x1,%al
  8015ec:	74 0e                	je     8015fc <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  8015ee:	b9 01 00 00 00       	mov    $0x1,%ecx
  8015f3:	89 da                	mov    %ebx,%edx
  8015f5:	89 f8                	mov    %edi,%eax
  8015f7:	e8 18 fc ff ff       	call   801214 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  8015fc:	83 eb 01             	sub    $0x1,%ebx
  8015ff:	79 ca                	jns    8015cb <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  801601:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  801608:	7f 3f                	jg     801649 <_Z5sforkv+0xd9>
  80160a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  80160d:	89 d8                	mov    %ebx,%eax
  80160f:	c1 f8 0a             	sar    $0xa,%eax
  801612:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801619:	a8 01                	test   $0x1,%al
  80161b:	75 08                	jne    801625 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  80161d:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801623:	eb 19                	jmp    80163e <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  801625:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  80162c:	a8 01                	test   $0x1,%al
  80162e:	74 0e                	je     80163e <_Z5sforkv+0xce>
            duppage(envid, i);
  801630:	b9 00 00 00 00       	mov    $0x0,%ecx
  801635:	89 da                	mov    %ebx,%edx
  801637:	89 f8                	mov    %edi,%eax
  801639:	e8 d6 fb ff ff       	call   801214 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  80163e:	83 c3 01             	add    $0x1,%ebx
  801641:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  801647:	7e c4                	jle    80160d <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  801649:	e8 2a f7 ff ff       	call   800d78 <_Z12sys_getenvidv>
  80164e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801653:	6b c0 78             	imul   $0x78,%eax,%eax
  801656:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  80165b:	8b 40 50             	mov    0x50(%eax),%eax
  80165e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801662:	89 34 24             	mov    %esi,(%esp)
  801665:	e8 ab f9 ff ff       	call   801015 <_Z26sys_env_set_pgfault_upcalliPv>
  80166a:	85 c0                	test   %eax,%eax
  80166c:	74 20                	je     80168e <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  80166e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801672:	c7 44 24 08 48 48 80 	movl   $0x804848,0x8(%esp)
  801679:	00 
  80167a:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801681:	00 
  801682:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  801689:	e8 3a eb ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80168e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801695:	00 
  801696:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  80169d:	ee 
  80169e:	89 34 24             	mov    %esi,(%esp)
  8016a1:	e8 3a f7 ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	79 20                	jns    8016ca <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  8016aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016ae:	c7 44 24 08 df 47 80 	movl   $0x8047df,0x8(%esp)
  8016b5:	00 
  8016b6:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  8016bd:	00 
  8016be:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  8016c5:	e8 fe ea ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8016ca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016d1:	00 
  8016d2:	89 34 24             	mov    %esi,(%esp)
  8016d5:	e8 21 f8 ff ff       	call   800efb <_Z18sys_env_set_statusii>
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	79 20                	jns    8016fe <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  8016de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016e2:	c7 44 24 08 31 48 80 	movl   $0x804831,0x8(%esp)
  8016e9:	00 
  8016ea:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  8016f1:	00 
  8016f2:	c7 04 24 f2 47 80 00 	movl   $0x8047f2,(%esp)
  8016f9:	e8 ca ea ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

    return envid;
    
}
  8016fe:	89 f0                	mov    %esi,%eax
  801700:	83 c4 2c             	add    $0x2c,%esp
  801703:	5b                   	pop    %ebx
  801704:	5e                   	pop    %esi
  801705:	5f                   	pop    %edi
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    
	...

00801710 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	56                   	push   %esi
  801714:	53                   	push   %ebx
  801715:	83 ec 10             	sub    $0x10,%esp
  801718:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80171b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  801721:	85 c0                	test   %eax,%eax
  801723:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  801728:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80172b:	89 04 24             	mov    %eax,(%esp)
  80172e:	e8 78 f9 ff ff       	call   8010ab <_Z12sys_ipc_recvPv>
  801733:	85 c0                	test   %eax,%eax
  801735:	79 16                	jns    80174d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  801737:	85 db                	test   %ebx,%ebx
  801739:	74 06                	je     801741 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80173b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  801741:	85 f6                	test   %esi,%esi
  801743:	74 53                	je     801798 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  801745:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80174b:	eb 4b                	jmp    801798 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80174d:	85 db                	test   %ebx,%ebx
  80174f:	74 17                	je     801768 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  801751:	e8 22 f6 ff ff       	call   800d78 <_Z12sys_getenvidv>
  801756:	25 ff 03 00 00       	and    $0x3ff,%eax
  80175b:	6b c0 78             	imul   $0x78,%eax,%eax
  80175e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  801763:	8b 40 60             	mov    0x60(%eax),%eax
  801766:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  801768:	85 f6                	test   %esi,%esi
  80176a:	74 17                	je     801783 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80176c:	e8 07 f6 ff ff       	call   800d78 <_Z12sys_getenvidv>
  801771:	25 ff 03 00 00       	and    $0x3ff,%eax
  801776:	6b c0 78             	imul   $0x78,%eax,%eax
  801779:	05 00 00 00 ef       	add    $0xef000000,%eax
  80177e:	8b 40 70             	mov    0x70(%eax),%eax
  801781:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  801783:	e8 f0 f5 ff ff       	call   800d78 <_Z12sys_getenvidv>
  801788:	25 ff 03 00 00       	and    $0x3ff,%eax
  80178d:	6b c0 78             	imul   $0x78,%eax,%eax
  801790:	05 08 00 00 ef       	add    $0xef000008,%eax
  801795:	8b 40 60             	mov    0x60(%eax),%eax

}
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	5b                   	pop    %ebx
  80179c:	5e                   	pop    %esi
  80179d:	5d                   	pop    %ebp
  80179e:	c3                   	ret    

0080179f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	57                   	push   %edi
  8017a3:	56                   	push   %esi
  8017a4:	53                   	push   %ebx
  8017a5:	83 ec 1c             	sub    $0x1c,%esp
  8017a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8017ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8017ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  8017b1:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  8017b3:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8017b8:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017ca:	89 34 24             	mov    %esi,(%esp)
  8017cd:	e8 a1 f8 ff ff       	call   801073 <_Z16sys_ipc_try_sendijPvi>
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	79 31                	jns    801807 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  8017d6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8017d9:	75 0c                	jne    8017e7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  8017db:	90                   	nop
  8017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8017e0:	e8 c7 f5 ff ff       	call   800dac <_Z9sys_yieldv>
  8017e5:	eb d4                	jmp    8017bb <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  8017e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017eb:	c7 44 24 08 67 48 80 	movl   $0x804867,0x8(%esp)
  8017f2:	00 
  8017f3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8017fa:	00 
  8017fb:	c7 04 24 74 48 80 00 	movl   $0x804874,(%esp)
  801802:	e8 c1 e9 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  801807:	83 c4 1c             	add    $0x1c,%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5f                   	pop    %edi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    
	...

00801810 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801813:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801818:	75 11                	jne    80182b <_ZL8fd_validPK2Fd+0x1b>
  80181a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80181f:	76 0a                	jbe    80182b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801821:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801826:	0f 96 c0             	setbe  %al
  801829:	eb 05                	jmp    801830 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	53                   	push   %ebx
  801836:	83 ec 14             	sub    $0x14,%esp
  801839:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80183b:	e8 d0 ff ff ff       	call   801810 <_ZL8fd_validPK2Fd>
  801840:	84 c0                	test   %al,%al
  801842:	75 24                	jne    801868 <_ZL9fd_isopenPK2Fd+0x36>
  801844:	c7 44 24 0c 7e 48 80 	movl   $0x80487e,0xc(%esp)
  80184b:	00 
  80184c:	c7 44 24 08 8b 48 80 	movl   $0x80488b,0x8(%esp)
  801853:	00 
  801854:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80185b:	00 
  80185c:	c7 04 24 a0 48 80 00 	movl   $0x8048a0,(%esp)
  801863:	e8 60 e9 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801868:	89 d8                	mov    %ebx,%eax
  80186a:	c1 e8 16             	shr    $0x16,%eax
  80186d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801874:	b8 00 00 00 00       	mov    $0x0,%eax
  801879:	f6 c2 01             	test   $0x1,%dl
  80187c:	74 0d                	je     80188b <_ZL9fd_isopenPK2Fd+0x59>
  80187e:	c1 eb 0c             	shr    $0xc,%ebx
  801881:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801888:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80188b:	83 c4 14             	add    $0x14,%esp
  80188e:	5b                   	pop    %ebx
  80188f:	5d                   	pop    %ebp
  801890:	c3                   	ret    

00801891 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 08             	sub    $0x8,%esp
  801897:	89 1c 24             	mov    %ebx,(%esp)
  80189a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80189e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8018a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018a4:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8018a8:	83 fb 1f             	cmp    $0x1f,%ebx
  8018ab:	77 18                	ja     8018c5 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  8018ad:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  8018b3:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8018b6:	84 c0                	test   %al,%al
  8018b8:	74 21                	je     8018db <_Z9fd_lookupiPP2Fdb+0x4a>
  8018ba:	89 d8                	mov    %ebx,%eax
  8018bc:	e8 71 ff ff ff       	call   801832 <_ZL9fd_isopenPK2Fd>
  8018c1:	84 c0                	test   %al,%al
  8018c3:	75 16                	jne    8018db <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  8018c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  8018cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  8018d0:	8b 1c 24             	mov    (%esp),%ebx
  8018d3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8018d7:	89 ec                	mov    %ebp,%esp
  8018d9:	5d                   	pop    %ebp
  8018da:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  8018db:	89 1e                	mov    %ebx,(%esi)
		return 0;
  8018dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e2:	eb ec                	jmp    8018d0 <_Z9fd_lookupiPP2Fdb+0x3f>

008018e4 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	53                   	push   %ebx
  8018e8:	83 ec 14             	sub    $0x14,%esp
  8018eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  8018ee:	89 d8                	mov    %ebx,%eax
  8018f0:	e8 1b ff ff ff       	call   801810 <_ZL8fd_validPK2Fd>
  8018f5:	84 c0                	test   %al,%al
  8018f7:	75 24                	jne    80191d <_Z6fd2numP2Fd+0x39>
  8018f9:	c7 44 24 0c 7e 48 80 	movl   $0x80487e,0xc(%esp)
  801900:	00 
  801901:	c7 44 24 08 8b 48 80 	movl   $0x80488b,0x8(%esp)
  801908:	00 
  801909:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801910:	00 
  801911:	c7 04 24 a0 48 80 00 	movl   $0x8048a0,(%esp)
  801918:	e8 ab e8 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80191d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801923:	c1 e8 0c             	shr    $0xc,%eax
}
  801926:	83 c4 14             	add    $0x14,%esp
  801929:	5b                   	pop    %ebx
  80192a:	5d                   	pop    %ebp
  80192b:	c3                   	ret    

0080192c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	89 04 24             	mov    %eax,(%esp)
  801938:	e8 a7 ff ff ff       	call   8018e4 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  80193d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801942:	c1 e0 0c             	shl    $0xc,%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	57                   	push   %edi
  80194b:	56                   	push   %esi
  80194c:	53                   	push   %ebx
  80194d:	83 ec 2c             	sub    $0x2c,%esp
  801950:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801953:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801958:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80195b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801962:	00 
  801963:	89 74 24 04          	mov    %esi,0x4(%esp)
  801967:	89 1c 24             	mov    %ebx,(%esp)
  80196a:	e8 22 ff ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80196f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801972:	e8 bb fe ff ff       	call   801832 <_ZL9fd_isopenPK2Fd>
  801977:	84 c0                	test   %al,%al
  801979:	75 0c                	jne    801987 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80197b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80197e:	89 07                	mov    %eax,(%edi)
			return 0;
  801980:	b8 00 00 00 00       	mov    $0x0,%eax
  801985:	eb 13                	jmp    80199a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801987:	83 c3 01             	add    $0x1,%ebx
  80198a:	83 fb 20             	cmp    $0x20,%ebx
  80198d:	75 cc                	jne    80195b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80198f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801995:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80199a:	83 c4 2c             	add    $0x2c,%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5e                   	pop    %esi
  80199f:	5f                   	pop    %edi
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    

008019a2 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	53                   	push   %ebx
  8019a6:	83 ec 14             	sub    $0x14,%esp
  8019a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8019af:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8019b4:	39 0d 04 50 80 00    	cmp    %ecx,0x805004
  8019ba:	75 16                	jne    8019d2 <_Z10dev_lookupiPP3Dev+0x30>
  8019bc:	eb 06                	jmp    8019c4 <_Z10dev_lookupiPP3Dev+0x22>
  8019be:	39 0a                	cmp    %ecx,(%edx)
  8019c0:	75 10                	jne    8019d2 <_Z10dev_lookupiPP3Dev+0x30>
  8019c2:	eb 05                	jmp    8019c9 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8019c4:	ba 04 50 80 00       	mov    $0x805004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8019c9:	89 13                	mov    %edx,(%ebx)
			return 0;
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d0:	eb 35                	jmp    801a07 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8019d2:	83 c0 01             	add    $0x1,%eax
  8019d5:	8b 14 85 0c 49 80 00 	mov    0x80490c(,%eax,4),%edx
  8019dc:	85 d2                	test   %edx,%edx
  8019de:	75 de                	jne    8019be <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8019e0:	a1 00 60 80 00       	mov    0x806000,%eax
  8019e5:	8b 40 04             	mov    0x4(%eax),%eax
  8019e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f0:	c7 04 24 c8 48 80 00 	movl   $0x8048c8,(%esp)
  8019f7:	e8 ea e8 ff ff       	call   8002e6 <_Z7cprintfPKcz>
	*dev = 0;
  8019fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801a02:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a07:	83 c4 14             	add    $0x14,%esp
  801a0a:	5b                   	pop    %ebx
  801a0b:	5d                   	pop    %ebp
  801a0c:	c3                   	ret    

00801a0d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	83 ec 20             	sub    $0x20,%esp
  801a15:	8b 75 08             	mov    0x8(%ebp),%esi
  801a18:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  801a1c:	89 34 24             	mov    %esi,(%esp)
  801a1f:	e8 c0 fe ff ff       	call   8018e4 <_Z6fd2numP2Fd>
  801a24:	0f b6 d3             	movzbl %bl,%edx
  801a27:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a2b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a2e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a32:	89 04 24             	mov    %eax,(%esp)
  801a35:	e8 57 fe ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 05                	js     801a43 <_Z8fd_closeP2Fdb+0x36>
  801a3e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801a41:	74 0c                	je     801a4f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801a43:	80 fb 01             	cmp    $0x1,%bl
  801a46:	19 db                	sbb    %ebx,%ebx
  801a48:	f7 d3                	not    %ebx
  801a4a:	83 e3 fd             	and    $0xfffffffd,%ebx
  801a4d:	eb 3d                	jmp    801a8c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a56:	8b 06                	mov    (%esi),%eax
  801a58:	89 04 24             	mov    %eax,(%esp)
  801a5b:	e8 42 ff ff ff       	call   8019a2 <_Z10dev_lookupiPP3Dev>
  801a60:	89 c3                	mov    %eax,%ebx
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 16                	js     801a7c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a69:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801a6c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801a71:	85 c0                	test   %eax,%eax
  801a73:	74 07                	je     801a7c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801a75:	89 34 24             	mov    %esi,(%esp)
  801a78:	ff d0                	call   *%eax
  801a7a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a87:	e8 11 f4 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
	return r;
}
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	83 c4 20             	add    $0x20,%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5d                   	pop    %ebp
  801a94:	c3                   	ret    

00801a95 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801a9b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801aa2:	00 
  801aa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	89 04 24             	mov    %eax,(%esp)
  801ab0:	e8 dc fd ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	78 13                	js     801acc <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801ab9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ac0:	00 
  801ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac4:	89 04 24             	mov    %eax,(%esp)
  801ac7:	e8 41 ff ff ff       	call   801a0d <_Z8fd_closeP2Fdb>
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <_Z9close_allv>:

void
close_all(void)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801ad5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ada:	89 1c 24             	mov    %ebx,(%esp)
  801add:	e8 b3 ff ff ff       	call   801a95 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801ae2:	83 c3 01             	add    $0x1,%ebx
  801ae5:	83 fb 20             	cmp    $0x20,%ebx
  801ae8:	75 f0                	jne    801ada <_Z9close_allv+0xc>
		close(i);
}
  801aea:	83 c4 14             	add    $0x14,%esp
  801aed:	5b                   	pop    %ebx
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    

00801af0 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 48             	sub    $0x48,%esp
  801af6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801af9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801afc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801aff:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801b02:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801b09:	00 
  801b0a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	89 04 24             	mov    %eax,(%esp)
  801b17:	e8 75 fd ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  801b1c:	89 c3                	mov    %eax,%ebx
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	0f 88 ce 00 00 00    	js     801bf4 <_Z3dupii+0x104>
  801b26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b2d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  801b2e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b31:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801b35:	89 34 24             	mov    %esi,(%esp)
  801b38:	e8 54 fd ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  801b3d:	89 c3                	mov    %eax,%ebx
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	0f 89 bc 00 00 00    	jns    801c03 <_Z3dupii+0x113>
  801b47:	e9 a8 00 00 00       	jmp    801bf4 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801b4c:	89 d8                	mov    %ebx,%eax
  801b4e:	c1 e8 0c             	shr    $0xc,%eax
  801b51:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801b58:	f6 c2 01             	test   $0x1,%dl
  801b5b:	74 32                	je     801b8f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801b5d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801b64:	25 07 0e 00 00       	and    $0xe07,%eax
  801b69:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b71:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b78:	00 
  801b79:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b84:	e8 b6 f2 ff ff       	call   800e3f <_Z12sys_page_mapiPviS_i>
  801b89:	89 c3                	mov    %eax,%ebx
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	78 3e                	js     801bcd <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b92:	89 c2                	mov    %eax,%edx
  801b94:	c1 ea 0c             	shr    $0xc,%edx
  801b97:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  801b9e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801ba4:	89 54 24 10          	mov    %edx,0x10(%esp)
  801ba8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801baf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bb6:	00 
  801bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc2:	e8 78 f2 ff ff       	call   800e3f <_Z12sys_page_mapiPviS_i>
  801bc7:	89 c3                	mov    %eax,%ebx
  801bc9:	85 c0                	test   %eax,%eax
  801bcb:	79 25                	jns    801bf2 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801bcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdb:	e8 bd f2 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801be0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801be4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801beb:	e8 ad f2 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
	return r;
  801bf0:	eb 02                	jmp    801bf4 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801bf2:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801bf4:	89 d8                	mov    %ebx,%eax
  801bf6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801bf9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bfc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801bff:	89 ec                	mov    %ebp,%esp
  801c01:	5d                   	pop    %ebp
  801c02:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801c03:	89 34 24             	mov    %esi,(%esp)
  801c06:	e8 8a fe ff ff       	call   801a95 <_Z5closei>

	ova = fd2data(oldfd);
  801c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0e:	89 04 24             	mov    %eax,(%esp)
  801c11:	e8 16 fd ff ff       	call   80192c <_Z7fd2dataP2Fd>
  801c16:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 09 fd ff ff       	call   80192c <_Z7fd2dataP2Fd>
  801c23:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801c25:	89 d8                	mov    %ebx,%eax
  801c27:	c1 e8 16             	shr    $0x16,%eax
  801c2a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801c31:	a8 01                	test   $0x1,%al
  801c33:	0f 85 13 ff ff ff    	jne    801b4c <_Z3dupii+0x5c>
  801c39:	e9 51 ff ff ff       	jmp    801b8f <_Z3dupii+0x9f>

00801c3e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	53                   	push   %ebx
  801c42:	83 ec 24             	sub    $0x24,%esp
  801c45:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801c48:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c4f:	00 
  801c50:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c57:	89 1c 24             	mov    %ebx,(%esp)
  801c5a:	e8 32 fc ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	78 5f                	js     801cc2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801c6d:	8b 00                	mov    (%eax),%eax
  801c6f:	89 04 24             	mov    %eax,(%esp)
  801c72:	e8 2b fd ff ff       	call   8019a2 <_Z10dev_lookupiPP3Dev>
  801c77:	85 c0                	test   %eax,%eax
  801c79:	79 4d                	jns    801cc8 <_Z4readiPvj+0x8a>
  801c7b:	eb 45                	jmp    801cc2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c7d:	a1 00 60 80 00       	mov    0x806000,%eax
  801c82:	8b 40 04             	mov    0x4(%eax),%eax
  801c85:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8d:	c7 04 24 a9 48 80 00 	movl   $0x8048a9,(%esp)
  801c94:	e8 4d e6 ff ff       	call   8002e6 <_Z7cprintfPKcz>
		return -E_INVAL;
  801c99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c9e:	eb 22                	jmp    801cc2 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca3:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801ca6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801cab:	85 d2                	test   %edx,%edx
  801cad:	74 13                	je     801cc2 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801caf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cbd:	89 0c 24             	mov    %ecx,(%esp)
  801cc0:	ff d2                	call   *%edx
}
  801cc2:	83 c4 24             	add    $0x24,%esp
  801cc5:	5b                   	pop    %ebx
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cc8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ccb:	8b 41 08             	mov    0x8(%ecx),%eax
  801cce:	83 e0 03             	and    $0x3,%eax
  801cd1:	83 f8 01             	cmp    $0x1,%eax
  801cd4:	75 ca                	jne    801ca0 <_Z4readiPvj+0x62>
  801cd6:	eb a5                	jmp    801c7d <_Z4readiPvj+0x3f>

00801cd8 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	57                   	push   %edi
  801cdc:	56                   	push   %esi
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 1c             	sub    $0x1c,%esp
  801ce1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ce4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801ce7:	85 f6                	test   %esi,%esi
  801ce9:	74 2f                	je     801d1a <_Z5readniPvj+0x42>
  801ceb:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801cf0:	89 f0                	mov    %esi,%eax
  801cf2:	29 d8                	sub    %ebx,%eax
  801cf4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	89 04 24             	mov    %eax,(%esp)
  801d05:	e8 34 ff ff ff       	call   801c3e <_Z4readiPvj>
		if (m < 0)
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 13                	js     801d21 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	74 0d                	je     801d1f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801d12:	01 c3                	add    %eax,%ebx
  801d14:	39 de                	cmp    %ebx,%esi
  801d16:	77 d8                	ja     801cf0 <_Z5readniPvj+0x18>
  801d18:	eb 05                	jmp    801d1f <_Z5readniPvj+0x47>
  801d1a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801d1f:	89 d8                	mov    %ebx,%eax
}
  801d21:	83 c4 1c             	add    $0x1c,%esp
  801d24:	5b                   	pop    %ebx
  801d25:	5e                   	pop    %esi
  801d26:	5f                   	pop    %edi
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801d2f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d36:	00 
  801d37:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	89 04 24             	mov    %eax,(%esp)
  801d44:	e8 48 fb ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	78 3c                	js     801d89 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801d57:	8b 00                	mov    (%eax),%eax
  801d59:	89 04 24             	mov    %eax,(%esp)
  801d5c:	e8 41 fc ff ff       	call   8019a2 <_Z10dev_lookupiPP3Dev>
  801d61:	85 c0                	test   %eax,%eax
  801d63:	79 26                	jns    801d8b <_Z5writeiPKvj+0x62>
  801d65:	eb 22                	jmp    801d89 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  801d6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801d72:	85 c9                	test   %ecx,%ecx
  801d74:	74 13                	je     801d89 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d76:	8b 45 10             	mov    0x10(%ebp),%eax
  801d79:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d84:	89 14 24             	mov    %edx,(%esp)
  801d87:	ff d1                	call   *%ecx
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801d8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  801d8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801d93:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801d97:	74 f0                	je     801d89 <_Z5writeiPKvj+0x60>
  801d99:	eb cc                	jmp    801d67 <_Z5writeiPKvj+0x3e>

00801d9b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801da1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801da8:	00 
  801da9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	89 04 24             	mov    %eax,(%esp)
  801db6:	e8 d6 fa ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	78 0e                	js     801dcd <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  801dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	53                   	push   %ebx
  801dd3:	83 ec 24             	sub    $0x24,%esp
  801dd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801dd9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801de0:	00 
  801de1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801de4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de8:	89 1c 24             	mov    %ebx,(%esp)
  801deb:	e8 a1 fa ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  801df0:	85 c0                	test   %eax,%eax
  801df2:	78 58                	js     801e4c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801dfe:	8b 00                	mov    (%eax),%eax
  801e00:	89 04 24             	mov    %eax,(%esp)
  801e03:	e8 9a fb ff ff       	call   8019a2 <_Z10dev_lookupiPP3Dev>
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	79 46                	jns    801e52 <_Z9ftruncateii+0x83>
  801e0c:	eb 3e                	jmp    801e4c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801e0e:	a1 00 60 80 00       	mov    0x806000,%eax
  801e13:	8b 40 04             	mov    0x4(%eax),%eax
  801e16:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1e:	c7 04 24 e8 48 80 00 	movl   $0x8048e8,(%esp)
  801e25:	e8 bc e4 ff ff       	call   8002e6 <_Z7cprintfPKcz>
		return -E_INVAL;
  801e2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e2f:	eb 1b                	jmp    801e4c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801e37:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801e3c:	85 d2                	test   %edx,%edx
  801e3e:	74 0c                	je     801e4c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e47:	89 0c 24             	mov    %ecx,(%esp)
  801e4a:	ff d2                	call   *%edx
}
  801e4c:	83 c4 24             	add    $0x24,%esp
  801e4f:	5b                   	pop    %ebx
  801e50:	5d                   	pop    %ebp
  801e51:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e52:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e55:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801e59:	75 d6                	jne    801e31 <_Z9ftruncateii+0x62>
  801e5b:	eb b1                	jmp    801e0e <_Z9ftruncateii+0x3f>

00801e5d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	53                   	push   %ebx
  801e61:	83 ec 24             	sub    $0x24,%esp
  801e64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e67:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e6e:	00 
  801e6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	89 04 24             	mov    %eax,(%esp)
  801e7c:	e8 10 fa ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  801e81:	85 c0                	test   %eax,%eax
  801e83:	78 3e                	js     801ec3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e8f:	8b 00                	mov    (%eax),%eax
  801e91:	89 04 24             	mov    %eax,(%esp)
  801e94:	e8 09 fb ff ff       	call   8019a2 <_Z10dev_lookupiPP3Dev>
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	79 2c                	jns    801ec9 <_Z5fstatiP4Stat+0x6c>
  801e9d:	eb 24                	jmp    801ec3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801e9f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ea2:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801ea9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801eb0:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801eb6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebd:	89 04 24             	mov    %eax,(%esp)
  801ec0:	ff 52 14             	call   *0x14(%edx)
}
  801ec3:	83 c4 24             	add    $0x24,%esp
  801ec6:	5b                   	pop    %ebx
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801ec9:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  801ecc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801ed1:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801ed5:	75 c8                	jne    801e9f <_Z5fstatiP4Stat+0x42>
  801ed7:	eb ea                	jmp    801ec3 <_Z5fstatiP4Stat+0x66>

00801ed9 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 18             	sub    $0x18,%esp
  801edf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ee2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ee5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801eec:	00 
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	89 04 24             	mov    %eax,(%esp)
  801ef3:	e8 d6 09 00 00       	call   8028ce <_Z4openPKci>
  801ef8:	89 c3                	mov    %eax,%ebx
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 1b                	js     801f19 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f05:	89 1c 24             	mov    %ebx,(%esp)
  801f08:	e8 50 ff ff ff       	call   801e5d <_Z5fstatiP4Stat>
  801f0d:	89 c6                	mov    %eax,%esi
	close(fd);
  801f0f:	89 1c 24             	mov    %ebx,(%esp)
  801f12:	e8 7e fb ff ff       	call   801a95 <_Z5closei>
	return r;
  801f17:	89 f3                	mov    %esi,%ebx
}
  801f19:	89 d8                	mov    %ebx,%eax
  801f1b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f1e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f21:	89 ec                	mov    %ebp,%esp
  801f23:	5d                   	pop    %ebp
  801f24:	c3                   	ret    
	...

00801f30 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801f33:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801f38:	85 d2                	test   %edx,%edx
  801f3a:	78 33                	js     801f6f <_ZL10inode_dataP5Inodei+0x3f>
  801f3c:	3b 50 08             	cmp    0x8(%eax),%edx
  801f3f:	7d 2e                	jge    801f6f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801f41:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801f47:	85 d2                	test   %edx,%edx
  801f49:	0f 49 ca             	cmovns %edx,%ecx
  801f4c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  801f4f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801f53:	c1 e1 0c             	shl    $0xc,%ecx
  801f56:	89 d0                	mov    %edx,%eax
  801f58:	c1 f8 1f             	sar    $0x1f,%eax
  801f5b:	c1 e8 14             	shr    $0x14,%eax
  801f5e:	01 c2                	add    %eax,%edx
  801f60:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801f66:	29 c2                	sub    %eax,%edx
  801f68:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801f6f:	89 c8                	mov    %ecx,%eax
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    

00801f73 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801f76:	8b 48 08             	mov    0x8(%eax),%ecx
  801f79:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801f7c:	8b 00                	mov    (%eax),%eax
  801f7e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801f81:	c7 82 80 00 00 00 04 	movl   $0x805004,0x80(%edx)
  801f88:	50 80 00 
}
  801f8b:	5d                   	pop    %ebp
  801f8c:	c3                   	ret    

00801f8d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801f93:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	74 08                	je     801fa5 <_ZL9get_inodei+0x18>
  801f9d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801fa3:	7e 20                	jle    801fc5 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801fa5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fa9:	c7 44 24 08 20 49 80 	movl   $0x804920,0x8(%esp)
  801fb0:	00 
  801fb1:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801fb8:	00 
  801fb9:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  801fc0:	e8 03 e2 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801fc5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801fcb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801fd1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801fd7:	85 d2                	test   %edx,%edx
  801fd9:	0f 48 d1             	cmovs  %ecx,%edx
  801fdc:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801fdf:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801fe6:	c1 e0 0c             	shl    $0xc,%eax
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	56                   	push   %esi
  801fef:	53                   	push   %ebx
  801ff0:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801ff3:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801ff9:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801ffc:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  802002:	76 20                	jbe    802024 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  802004:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802008:	c7 44 24 08 5c 49 80 	movl   $0x80495c,0x8(%esp)
  80200f:	00 
  802010:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802017:	00 
  802018:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  80201f:	e8 a4 e1 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  802024:	83 fe 01             	cmp    $0x1,%esi
  802027:	7e 08                	jle    802031 <_ZL10bcache_ipcPvi+0x46>
  802029:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  80202f:	7d 12                	jge    802043 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802031:	89 f3                	mov    %esi,%ebx
  802033:	c1 e3 04             	shl    $0x4,%ebx
  802036:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802038:	81 c6 00 00 05 00    	add    $0x50000,%esi
  80203e:	c1 e6 0c             	shl    $0xc,%esi
  802041:	eb 20                	jmp    802063 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  802043:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802047:	c7 44 24 08 8c 49 80 	movl   $0x80498c,0x8(%esp)
  80204e:	00 
  80204f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802056:	00 
  802057:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  80205e:	e8 65 e1 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802063:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80206a:	00 
  80206b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802072:	00 
  802073:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802077:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  80207e:	e8 1c f7 ff ff       	call   80179f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802083:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80208a:	00 
  80208b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80208f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802096:	e8 75 f6 ff ff       	call   801710 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  80209b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80209e:	74 c3                	je     802063 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	5b                   	pop    %ebx
  8020a4:	5e                   	pop    %esi
  8020a5:	5d                   	pop    %ebp
  8020a6:	c3                   	ret    

008020a7 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 28             	sub    $0x28,%esp
  8020ad:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8020b0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8020b3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8020b6:	89 c7                	mov    %eax,%edi
  8020b8:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  8020ba:	c7 04 24 4d 23 80 00 	movl   $0x80234d,(%esp)
  8020c1:	e8 05 20 00 00       	call   8040cb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  8020c6:	89 f8                	mov    %edi,%eax
  8020c8:	e8 c0 fe ff ff       	call   801f8d <_ZL9get_inodei>
  8020cd:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  8020cf:	ba 02 00 00 00       	mov    $0x2,%edx
  8020d4:	e8 12 ff ff ff       	call   801feb <_ZL10bcache_ipcPvi>
	if (r < 0) {
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	79 08                	jns    8020e5 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  8020dd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  8020e3:	eb 2e                	jmp    802113 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	75 1c                	jne    802105 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  8020e9:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  8020ef:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  8020f6:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  8020f9:	ba 06 00 00 00       	mov    $0x6,%edx
  8020fe:	89 d8                	mov    %ebx,%eax
  802100:	e8 e6 fe ff ff       	call   801feb <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  802105:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  80210c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802113:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802116:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802119:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80211c:	89 ec                	mov    %ebp,%esp
  80211e:	5d                   	pop    %ebp
  80211f:	c3                   	ret    

00802120 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	57                   	push   %edi
  802124:	56                   	push   %esi
  802125:	53                   	push   %ebx
  802126:	83 ec 2c             	sub    $0x2c,%esp
  802129:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80212c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  80212f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  802134:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  80213a:	0f 87 3d 01 00 00    	ja     80227d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  802140:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802143:	8b 42 08             	mov    0x8(%edx),%eax
  802146:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  80214c:	85 c0                	test   %eax,%eax
  80214e:	0f 49 f0             	cmovns %eax,%esi
  802151:	c1 fe 0c             	sar    $0xc,%esi
  802154:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  802156:	8b 7d d8             	mov    -0x28(%ebp),%edi
  802159:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  80215f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  802162:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802165:	0f 82 a6 00 00 00    	jb     802211 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  80216b:	39 fe                	cmp    %edi,%esi
  80216d:	0f 8d f2 00 00 00    	jge    802265 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802173:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  802177:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80217a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80217d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  802180:	83 3e 00             	cmpl   $0x0,(%esi)
  802183:	75 77                	jne    8021fc <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802185:	ba 02 00 00 00       	mov    $0x2,%edx
  80218a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80218f:	e8 57 fe ff ff       	call   801feb <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802194:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  80219a:	83 f9 02             	cmp    $0x2,%ecx
  80219d:	7e 43                	jle    8021e2 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  80219f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8021a4:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  8021a9:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  8021b0:	74 29                	je     8021db <_ZL14inode_set_sizeP5Inodej+0xbb>
  8021b2:	e9 ce 00 00 00       	jmp    802285 <_ZL14inode_set_sizeP5Inodej+0x165>
  8021b7:	89 c7                	mov    %eax,%edi
  8021b9:	0f b6 10             	movzbl (%eax),%edx
  8021bc:	83 c0 01             	add    $0x1,%eax
  8021bf:	84 d2                	test   %dl,%dl
  8021c1:	74 18                	je     8021db <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  8021c3:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8021c6:	ba 05 00 00 00       	mov    $0x5,%edx
  8021cb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8021d0:	e8 16 fe ff ff       	call   801feb <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  8021d5:	85 db                	test   %ebx,%ebx
  8021d7:	79 1e                	jns    8021f7 <_ZL14inode_set_sizeP5Inodej+0xd7>
  8021d9:	eb 07                	jmp    8021e2 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8021db:	83 c3 01             	add    $0x1,%ebx
  8021de:	39 d9                	cmp    %ebx,%ecx
  8021e0:	7f d5                	jg     8021b7 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  8021e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021e5:	8b 50 08             	mov    0x8(%eax),%edx
  8021e8:	e8 33 ff ff ff       	call   802120 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  8021ed:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8021f2:	e9 86 00 00 00       	jmp    80227d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  8021f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021fa:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  8021fc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  802200:	83 c6 04             	add    $0x4,%esi
  802203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802206:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  802209:	0f 8f 6e ff ff ff    	jg     80217d <_ZL14inode_set_sizeP5Inodej+0x5d>
  80220f:	eb 54                	jmp    802265 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  802211:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802214:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  802219:	83 f8 01             	cmp    $0x1,%eax
  80221c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  80221f:	ba 02 00 00 00       	mov    $0x2,%edx
  802224:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802229:	e8 bd fd ff ff       	call   801feb <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  80222e:	39 f7                	cmp    %esi,%edi
  802230:	7d 24                	jge    802256 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802232:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802235:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  802239:	8b 10                	mov    (%eax),%edx
  80223b:	85 d2                	test   %edx,%edx
  80223d:	74 0d                	je     80224c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  80223f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  802246:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  80224c:	83 eb 01             	sub    $0x1,%ebx
  80224f:	83 e8 04             	sub    $0x4,%eax
  802252:	39 fb                	cmp    %edi,%ebx
  802254:	75 e3                	jne    802239 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802256:	ba 05 00 00 00       	mov    $0x5,%edx
  80225b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802260:	e8 86 fd ff ff       	call   801feb <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  802265:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802268:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80226b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  80226e:	ba 04 00 00 00       	mov    $0x4,%edx
  802273:	e8 73 fd ff ff       	call   801feb <_ZL10bcache_ipcPvi>
	return 0;
  802278:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227d:	83 c4 2c             	add    $0x2c,%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5f                   	pop    %edi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802285:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  80228c:	ba 05 00 00 00       	mov    $0x5,%edx
  802291:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802296:	e8 50 fd ff ff       	call   801feb <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80229b:	bb 02 00 00 00       	mov    $0x2,%ebx
  8022a0:	e9 52 ff ff ff       	jmp    8021f7 <_ZL14inode_set_sizeP5Inodej+0xd7>

008022a5 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	53                   	push   %ebx
  8022a9:	83 ec 04             	sub    $0x4,%esp
  8022ac:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  8022ae:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  8022b4:	83 e8 01             	sub    $0x1,%eax
  8022b7:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  8022bd:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  8022c1:	75 40                	jne    802303 <_ZL11inode_closeP5Inode+0x5e>
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	75 3c                	jne    802303 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8022c7:	ba 02 00 00 00       	mov    $0x2,%edx
  8022cc:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8022d1:	e8 15 fd ff ff       	call   801feb <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  8022db:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  8022df:	85 d2                	test   %edx,%edx
  8022e1:	74 07                	je     8022ea <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  8022e3:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  8022ea:	83 c0 01             	add    $0x1,%eax
  8022ed:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  8022f2:	75 e7                	jne    8022db <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8022f4:	ba 05 00 00 00       	mov    $0x5,%edx
  8022f9:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8022fe:	e8 e8 fc ff ff       	call   801feb <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  802303:	ba 03 00 00 00       	mov    $0x3,%edx
  802308:	89 d8                	mov    %ebx,%eax
  80230a:	e8 dc fc ff ff       	call   801feb <_ZL10bcache_ipcPvi>
}
  80230f:	83 c4 04             	add    $0x4,%esp
  802312:	5b                   	pop    %ebx
  802313:	5d                   	pop    %ebp
  802314:	c3                   	ret    

00802315 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	53                   	push   %ebx
  802319:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	8b 40 0c             	mov    0xc(%eax),%eax
  802322:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802325:	e8 7d fd ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  80232a:	89 c3                	mov    %eax,%ebx
  80232c:	85 c0                	test   %eax,%eax
  80232e:	78 15                	js     802345 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  802330:	8b 55 0c             	mov    0xc(%ebp),%edx
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	e8 e5 fd ff ff       	call   802120 <_ZL14inode_set_sizeP5Inodej>
  80233b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	e8 60 ff ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
	return r;
}
  802345:	89 d8                	mov    %ebx,%eax
  802347:	83 c4 14             	add    $0x14,%esp
  80234a:	5b                   	pop    %ebx
  80234b:	5d                   	pop    %ebp
  80234c:	c3                   	ret    

0080234d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	53                   	push   %ebx
  802351:	83 ec 14             	sub    $0x14,%esp
  802354:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  802357:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  802359:	89 c2                	mov    %eax,%edx
  80235b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  802361:	78 32                	js     802395 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  802363:	ba 00 00 00 00       	mov    $0x0,%edx
  802368:	e8 7e fc ff ff       	call   801feb <_ZL10bcache_ipcPvi>
  80236d:	85 c0                	test   %eax,%eax
  80236f:	74 1c                	je     80238d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  802371:	c7 44 24 08 41 49 80 	movl   $0x804941,0x8(%esp)
  802378:	00 
  802379:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802380:	00 
  802381:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802388:	e8 3b de ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
    resume(utf);
  80238d:	89 1c 24             	mov    %ebx,(%esp)
  802390:	e8 0b 1e 00 00       	call   8041a0 <resume>
}
  802395:	83 c4 14             	add    $0x14,%esp
  802398:	5b                   	pop    %ebx
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    

0080239b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	83 ec 28             	sub    $0x28,%esp
  8023a1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023a4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8023a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8023aa:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8023ad:	8b 43 0c             	mov    0xc(%ebx),%eax
  8023b0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8023b3:	e8 ef fc ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	78 26                	js     8023e2 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  8023bc:	83 c3 10             	add    $0x10,%ebx
  8023bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023c3:	89 34 24             	mov    %esi,(%esp)
  8023c6:	e8 2f e5 ff ff       	call   8008fa <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8023cb:	89 f2                	mov    %esi,%edx
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	e8 9e fb ff ff       	call   801f73 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	e8 c8 fe ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
	return 0;
  8023dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8023e5:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8023e8:	89 ec                	mov    %ebp,%esp
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    

008023ec <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	53                   	push   %ebx
  8023f0:	83 ec 24             	sub    $0x24,%esp
  8023f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8023f6:	89 1c 24             	mov    %ebx,(%esp)
  8023f9:	e8 9e 15 00 00       	call   80399c <_Z7pagerefPv>
  8023fe:	89 c2                	mov    %eax,%edx
        return 0;
  802400:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802405:	83 fa 01             	cmp    $0x1,%edx
  802408:	7f 1e                	jg     802428 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80240a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80240d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802410:	e8 92 fc ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  802415:	85 c0                	test   %eax,%eax
  802417:	78 0f                	js     802428 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802423:	e8 7d fe ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
}
  802428:	83 c4 24             	add    $0x24,%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    

0080242e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 3c             	sub    $0x3c,%esp
  802437:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80243a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  80243d:	8b 43 04             	mov    0x4(%ebx),%eax
  802440:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802443:	8b 43 0c             	mov    0xc(%ebx),%eax
  802446:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802449:	e8 59 fc ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  80244e:	85 c0                	test   %eax,%eax
  802450:	0f 88 8c 00 00 00    	js     8024e2 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802456:	8b 53 04             	mov    0x4(%ebx),%edx
  802459:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  80245f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802465:	29 d7                	sub    %edx,%edi
  802467:	39 f7                	cmp    %esi,%edi
  802469:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  80246c:	85 ff                	test   %edi,%edi
  80246e:	74 16                	je     802486 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802470:	8d 14 17             	lea    (%edi,%edx,1),%edx
  802473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802476:	3b 50 08             	cmp    0x8(%eax),%edx
  802479:	76 6f                	jbe    8024ea <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80247b:	e8 a0 fc ff ff       	call   802120 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802480:	85 c0                	test   %eax,%eax
  802482:	79 66                	jns    8024ea <_ZL13devfile_writeP2FdPKvj+0xbc>
  802484:	eb 4e                	jmp    8024d4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802486:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80248c:	76 24                	jbe    8024b2 <_ZL13devfile_writeP2FdPKvj+0x84>
  80248e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802490:	8b 53 04             	mov    0x4(%ebx),%edx
  802493:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80249c:	3b 50 08             	cmp    0x8(%eax),%edx
  80249f:	0f 86 83 00 00 00    	jbe    802528 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  8024a5:	e8 76 fc ff ff       	call   802120 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	79 7a                	jns    802528 <_ZL13devfile_writeP2FdPKvj+0xfa>
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	eb 22                	jmp    8024d4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8024b2:	85 f6                	test   %esi,%esi
  8024b4:	74 1e                	je     8024d4 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8024b6:	89 f2                	mov    %esi,%edx
  8024b8:	03 53 04             	add    0x4(%ebx),%edx
  8024bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024be:	3b 50 08             	cmp    0x8(%eax),%edx
  8024c1:	0f 86 b8 00 00 00    	jbe    80257f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  8024c7:	e8 54 fc ff ff       	call   802120 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	0f 89 ab 00 00 00    	jns    80257f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  8024d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d7:	e8 c9 fd ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8024dc:	8b 43 04             	mov    0x4(%ebx),%eax
  8024df:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  8024e2:	83 c4 3c             	add    $0x3c,%esp
  8024e5:	5b                   	pop    %ebx
  8024e6:	5e                   	pop    %esi
  8024e7:	5f                   	pop    %edi
  8024e8:	5d                   	pop    %ebp
  8024e9:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  8024ea:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8024ec:	8b 53 04             	mov    0x4(%ebx),%edx
  8024ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f2:	e8 39 fa ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
  8024f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  8024fa:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802501:	89 44 24 04          	mov    %eax,0x4(%esp)
  802505:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802508:	89 04 24             	mov    %eax,(%esp)
  80250b:	e8 07 e6 ff ff       	call   800b17 <memcpy>
        fd->fd_offset += n2;
  802510:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802513:	ba 04 00 00 00       	mov    $0x4,%edx
  802518:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80251b:	e8 cb fa ff ff       	call   801feb <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802520:	01 7d 0c             	add    %edi,0xc(%ebp)
  802523:	e9 5e ff ff ff       	jmp    802486 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802528:	8b 53 04             	mov    0x4(%ebx),%edx
  80252b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252e:	e8 fd f9 ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
  802533:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  802535:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80253c:	00 
  80253d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802540:	89 44 24 04          	mov    %eax,0x4(%esp)
  802544:	89 34 24             	mov    %esi,(%esp)
  802547:	e8 cb e5 ff ff       	call   800b17 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80254c:	ba 04 00 00 00       	mov    $0x4,%edx
  802551:	89 f0                	mov    %esi,%eax
  802553:	e8 93 fa ff ff       	call   801feb <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  802558:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  80255e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802565:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80256c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802572:	0f 87 18 ff ff ff    	ja     802490 <_ZL13devfile_writeP2FdPKvj+0x62>
  802578:	89 fe                	mov    %edi,%esi
  80257a:	e9 33 ff ff ff       	jmp    8024b2 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80257f:	8b 53 04             	mov    0x4(%ebx),%edx
  802582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802585:	e8 a6 f9 ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
  80258a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80258c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802590:	8b 45 0c             	mov    0xc(%ebp),%eax
  802593:	89 44 24 04          	mov    %eax,0x4(%esp)
  802597:	89 3c 24             	mov    %edi,(%esp)
  80259a:	e8 78 e5 ff ff       	call   800b17 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80259f:	ba 04 00 00 00       	mov    $0x4,%edx
  8025a4:	89 f8                	mov    %edi,%eax
  8025a6:	e8 40 fa ff ff       	call   801feb <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  8025ab:	01 73 04             	add    %esi,0x4(%ebx)
  8025ae:	e9 21 ff ff ff       	jmp    8024d4 <_ZL13devfile_writeP2FdPKvj+0xa6>

008025b3 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	57                   	push   %edi
  8025b7:	56                   	push   %esi
  8025b8:	53                   	push   %ebx
  8025b9:	83 ec 3c             	sub    $0x3c,%esp
  8025bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8025bf:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  8025c2:	8b 43 04             	mov    0x4(%ebx),%eax
  8025c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8025c8:	8b 43 0c             	mov    0xc(%ebx),%eax
  8025cb:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8025ce:	e8 d4 fa ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	0f 88 d3 00 00 00    	js     8026ae <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  8025db:	8b 73 04             	mov    0x4(%ebx),%esi
  8025de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e1:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  8025e4:	8b 50 08             	mov    0x8(%eax),%edx
  8025e7:	29 f2                	sub    %esi,%edx
  8025e9:	3b 48 08             	cmp    0x8(%eax),%ecx
  8025ec:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  8025ef:	89 f2                	mov    %esi,%edx
  8025f1:	e8 3a f9 ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	0f 84 a2 00 00 00    	je     8026a0 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8025fe:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802604:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80260a:	29 f2                	sub    %esi,%edx
  80260c:	39 d7                	cmp    %edx,%edi
  80260e:	0f 46 d7             	cmovbe %edi,%edx
  802611:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802614:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802616:	01 d6                	add    %edx,%esi
  802618:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80261b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80261f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802623:	8b 45 0c             	mov    0xc(%ebp),%eax
  802626:	89 04 24             	mov    %eax,(%esp)
  802629:	e8 e9 e4 ff ff       	call   800b17 <memcpy>
    buf = (void *)((char *)buf + n2);
  80262e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802631:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802634:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80263a:	76 3e                	jbe    80267a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80263c:	8b 53 04             	mov    0x4(%ebx),%edx
  80263f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802642:	e8 e9 f8 ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
  802647:	85 c0                	test   %eax,%eax
  802649:	74 55                	je     8026a0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80264b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802652:	00 
  802653:	89 44 24 04          	mov    %eax,0x4(%esp)
  802657:	89 34 24             	mov    %esi,(%esp)
  80265a:	e8 b8 e4 ff ff       	call   800b17 <memcpy>
        n -= PGSIZE;
  80265f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802665:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80266b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802672:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802678:	77 c2                	ja     80263c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80267a:	85 ff                	test   %edi,%edi
  80267c:	74 22                	je     8026a0 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80267e:	8b 53 04             	mov    0x4(%ebx),%edx
  802681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802684:	e8 a7 f8 ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
  802689:	85 c0                	test   %eax,%eax
  80268b:	74 13                	je     8026a0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80268d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802691:	89 44 24 04          	mov    %eax,0x4(%esp)
  802695:	89 34 24             	mov    %esi,(%esp)
  802698:	e8 7a e4 ff ff       	call   800b17 <memcpy>
        fd->fd_offset += n;
  80269d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  8026a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a3:	e8 fd fb ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8026a8:	8b 43 04             	mov    0x4(%ebx),%eax
  8026ab:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  8026ae:	83 c4 3c             	add    $0x3c,%esp
  8026b1:	5b                   	pop    %ebx
  8026b2:	5e                   	pop    %esi
  8026b3:	5f                   	pop    %edi
  8026b4:	5d                   	pop    %ebp
  8026b5:	c3                   	ret    

008026b6 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
  8026b9:	57                   	push   %edi
  8026ba:	56                   	push   %esi
  8026bb:	53                   	push   %ebx
  8026bc:	83 ec 4c             	sub    $0x4c,%esp
  8026bf:	89 c6                	mov    %eax,%esi
  8026c1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8026c4:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  8026c7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  8026cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  8026d6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8026d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8026de:	e8 c4 f9 ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  8026e3:	89 c7                	mov    %eax,%edi
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	0f 88 cd 01 00 00    	js     8028ba <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8026ed:	89 f3                	mov    %esi,%ebx
  8026ef:	80 3e 2f             	cmpb   $0x2f,(%esi)
  8026f2:	75 08                	jne    8026fc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  8026f4:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8026f7:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8026fa:	74 f8                	je     8026f4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8026fc:	0f b6 03             	movzbl (%ebx),%eax
  8026ff:	3c 2f                	cmp    $0x2f,%al
  802701:	74 16                	je     802719 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802703:	84 c0                	test   %al,%al
  802705:	74 12                	je     802719 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802707:	89 da                	mov    %ebx,%edx
		++path;
  802709:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80270c:	0f b6 02             	movzbl (%edx),%eax
  80270f:	3c 2f                	cmp    $0x2f,%al
  802711:	74 08                	je     80271b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802713:	84 c0                	test   %al,%al
  802715:	75 f2                	jne    802709 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802717:	eb 02                	jmp    80271b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802719:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80271b:	89 d0                	mov    %edx,%eax
  80271d:	29 d8                	sub    %ebx,%eax
  80271f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802722:	0f b6 02             	movzbl (%edx),%eax
  802725:	89 d6                	mov    %edx,%esi
  802727:	3c 2f                	cmp    $0x2f,%al
  802729:	75 0a                	jne    802735 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80272b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80272e:	0f b6 06             	movzbl (%esi),%eax
  802731:	3c 2f                	cmp    $0x2f,%al
  802733:	74 f6                	je     80272b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802735:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802739:	75 1b                	jne    802756 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80273b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802741:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802743:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802746:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80274c:	bf 00 00 00 00       	mov    $0x0,%edi
  802751:	e9 64 01 00 00       	jmp    8028ba <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802756:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  80275a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275e:	74 06                	je     802766 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802760:	84 c0                	test   %al,%al
  802762:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802766:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802769:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80276c:	83 3a 02             	cmpl   $0x2,(%edx)
  80276f:	0f 85 f4 00 00 00    	jne    802869 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802775:	89 d0                	mov    %edx,%eax
  802777:	8b 52 08             	mov    0x8(%edx),%edx
  80277a:	85 d2                	test   %edx,%edx
  80277c:	7e 78                	jle    8027f6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80277e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802785:	bf 00 00 00 00       	mov    $0x0,%edi
  80278a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80278d:	89 fb                	mov    %edi,%ebx
  80278f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802792:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802794:	89 da                	mov    %ebx,%edx
  802796:	89 f0                	mov    %esi,%eax
  802798:	e8 93 f7 ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
  80279d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80279f:	83 38 00             	cmpl   $0x0,(%eax)
  8027a2:	74 26                	je     8027ca <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  8027a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8027a7:	3b 50 04             	cmp    0x4(%eax),%edx
  8027aa:	75 33                	jne    8027df <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  8027ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027b0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b7:	8d 47 08             	lea    0x8(%edi),%eax
  8027ba:	89 04 24             	mov    %eax,(%esp)
  8027bd:	e8 96 e3 ff ff       	call   800b58 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	0f 84 fa 00 00 00    	je     8028c4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  8027ca:	83 3f 00             	cmpl   $0x0,(%edi)
  8027cd:	75 10                	jne    8027df <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  8027cf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027d3:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8027d6:	84 c0                	test   %al,%al
  8027d8:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  8027dc:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8027df:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  8027e5:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8027e7:	8b 56 08             	mov    0x8(%esi),%edx
  8027ea:	39 d0                	cmp    %edx,%eax
  8027ec:	7c a6                	jl     802794 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  8027ee:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8027f1:	8b 75 c0             	mov    -0x40(%ebp),%esi
  8027f4:	eb 07                	jmp    8027fd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  8027f6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  8027fd:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802801:	74 6d                	je     802870 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802803:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802807:	75 24                	jne    80282d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802809:	83 ea 80             	sub    $0xffffff80,%edx
  80280c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80280f:	e8 0c f9 ff ff       	call   802120 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802814:	85 c0                	test   %eax,%eax
  802816:	0f 88 90 00 00 00    	js     8028ac <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80281c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80281f:	8b 50 08             	mov    0x8(%eax),%edx
  802822:	83 c2 80             	add    $0xffffff80,%edx
  802825:	e8 06 f7 ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
  80282a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80282d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802834:	00 
  802835:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80283c:	00 
  80283d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802840:	89 14 24             	mov    %edx,(%esp)
  802843:	e8 f9 e1 ff ff       	call   800a41 <memset>
	empty->de_namelen = namelen;
  802848:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80284b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80284e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802851:	89 54 24 08          	mov    %edx,0x8(%esp)
  802855:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802859:	83 c0 08             	add    $0x8,%eax
  80285c:	89 04 24             	mov    %eax,(%esp)
  80285f:	e8 b3 e2 ff ff       	call   800b17 <memcpy>
	*de_store = empty;
  802864:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802867:	eb 5e                	jmp    8028c7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802869:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80286e:	eb 42                	jmp    8028b2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802870:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802875:	eb 3b                	jmp    8028b2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80287d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80287f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802882:	89 38                	mov    %edi,(%eax)
			return 0;
  802884:	bf 00 00 00 00       	mov    $0x0,%edi
  802889:	eb 2f                	jmp    8028ba <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80288b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80288e:	8b 07                	mov    (%edi),%eax
  802890:	e8 12 f8 ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  802895:	85 c0                	test   %eax,%eax
  802897:	78 17                	js     8028b0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802899:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289c:	e8 04 fa ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  8028a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  8028a7:	e9 41 fe ff ff       	jmp    8026ed <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  8028ac:	89 c7                	mov    %eax,%edi
  8028ae:	eb 02                	jmp    8028b2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  8028b0:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  8028b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b5:	e8 eb f9 ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
	return r;
}
  8028ba:	89 f8                	mov    %edi,%eax
  8028bc:	83 c4 4c             	add    $0x4c,%esp
  8028bf:	5b                   	pop    %ebx
  8028c0:	5e                   	pop    %esi
  8028c1:	5f                   	pop    %edi
  8028c2:	5d                   	pop    %ebp
  8028c3:	c3                   	ret    
  8028c4:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  8028c7:	80 3e 00             	cmpb   $0x0,(%esi)
  8028ca:	75 bf                	jne    80288b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  8028cc:	eb a9                	jmp    802877 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

008028ce <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  8028ce:	55                   	push   %ebp
  8028cf:	89 e5                	mov    %esp,%ebp
  8028d1:	57                   	push   %edi
  8028d2:	56                   	push   %esi
  8028d3:	53                   	push   %ebx
  8028d4:	83 ec 3c             	sub    $0x3c,%esp
  8028d7:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  8028da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8028dd:	89 04 24             	mov    %eax,(%esp)
  8028e0:	e8 62 f0 ff ff       	call   801947 <_Z14fd_find_unusedPP2Fd>
  8028e5:	89 c3                	mov    %eax,%ebx
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	0f 88 16 02 00 00    	js     802b05 <_Z4openPKci+0x237>
  8028ef:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028f6:	00 
  8028f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802905:	e8 d6 e4 ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  80290a:	89 c3                	mov    %eax,%ebx
  80290c:	b8 00 00 00 00       	mov    $0x0,%eax
  802911:	85 db                	test   %ebx,%ebx
  802913:	0f 88 ec 01 00 00    	js     802b05 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802919:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80291d:	0f 84 ec 01 00 00    	je     802b0f <_Z4openPKci+0x241>
  802923:	83 c0 01             	add    $0x1,%eax
  802926:	83 f8 78             	cmp    $0x78,%eax
  802929:	75 ee                	jne    802919 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80292b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802930:	e9 b9 01 00 00       	jmp    802aee <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802935:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802938:	81 e7 00 01 00 00    	and    $0x100,%edi
  80293e:	89 3c 24             	mov    %edi,(%esp)
  802941:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802944:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802947:	89 f0                	mov    %esi,%eax
  802949:	e8 68 fd ff ff       	call   8026b6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80294e:	89 c3                	mov    %eax,%ebx
  802950:	85 c0                	test   %eax,%eax
  802952:	0f 85 96 01 00 00    	jne    802aee <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802958:	85 ff                	test   %edi,%edi
  80295a:	75 41                	jne    80299d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  80295c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80295f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802964:	75 08                	jne    80296e <_Z4openPKci+0xa0>
            fileino = dirino;
  802966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802969:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80296c:	eb 14                	jmp    802982 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80296e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802971:	8b 00                	mov    (%eax),%eax
  802973:	e8 2f f7 ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  802978:	89 c3                	mov    %eax,%ebx
  80297a:	85 c0                	test   %eax,%eax
  80297c:	0f 88 5d 01 00 00    	js     802adf <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802982:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802985:	83 38 02             	cmpl   $0x2,(%eax)
  802988:	0f 85 d2 00 00 00    	jne    802a60 <_Z4openPKci+0x192>
  80298e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802992:	0f 84 c8 00 00 00    	je     802a60 <_Z4openPKci+0x192>
  802998:	e9 38 01 00 00       	jmp    802ad5 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80299d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8029a4:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  8029ab:	0f 8e a8 00 00 00    	jle    802a59 <_Z4openPKci+0x18b>
  8029b1:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  8029b6:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  8029b9:	89 f8                	mov    %edi,%eax
  8029bb:	e8 e7 f6 ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  8029c0:	89 c3                	mov    %eax,%ebx
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	0f 88 15 01 00 00    	js     802adf <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  8029ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029cd:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8029d1:	75 68                	jne    802a3b <_Z4openPKci+0x16d>
  8029d3:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  8029da:	75 5f                	jne    802a3b <_Z4openPKci+0x16d>
			*ino_store = ino;
  8029dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  8029df:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  8029e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029e8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  8029ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  8029f6:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  8029fd:	00 
  8029fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a05:	00 
  802a06:	83 c0 0c             	add    $0xc,%eax
  802a09:	89 04 24             	mov    %eax,(%esp)
  802a0c:	e8 30 e0 ff ff       	call   800a41 <memset>
        de->de_inum = fileino->i_inum;
  802a11:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a14:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  802a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a1d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  802a1f:	ba 04 00 00 00       	mov    $0x4,%edx
  802a24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a27:	e8 bf f5 ff ff       	call   801feb <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  802a2c:	ba 04 00 00 00       	mov    $0x4,%edx
  802a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a34:	e8 b2 f5 ff ff       	call   801feb <_ZL10bcache_ipcPvi>
  802a39:	eb 25                	jmp    802a60 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  802a3b:	e8 65 f8 ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802a40:	83 c7 01             	add    $0x1,%edi
  802a43:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802a49:	0f 8c 67 ff ff ff    	jl     8029b6 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  802a4f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802a54:	e9 86 00 00 00       	jmp    802adf <_Z4openPKci+0x211>
  802a59:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802a5e:	eb 7f                	jmp    802adf <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802a60:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802a67:	74 0d                	je     802a76 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802a69:	ba 00 00 00 00       	mov    $0x0,%edx
  802a6e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a71:	e8 aa f6 ff ff       	call   802120 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802a76:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802a81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  802a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a8e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802a91:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a94:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  802a9a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  802a9d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802aa1:	83 c0 10             	add    $0x10,%eax
  802aa4:	89 04 24             	mov    %eax,(%esp)
  802aa7:	e8 4e de ff ff       	call   8008fa <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  802aac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802aaf:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802ab6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab9:	e8 e7 f7 ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  802abe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ac1:	e8 df f7 ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac9:	89 04 24             	mov    %eax,(%esp)
  802acc:	e8 13 ee ff ff       	call   8018e4 <_Z6fd2numP2Fd>
  802ad1:	89 c3                	mov    %eax,%ebx
  802ad3:	eb 30                	jmp    802b05 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802ad5:	e8 cb f7 ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  802ada:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  802adf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae2:	e8 be f7 ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
  802ae7:	eb 05                	jmp    802aee <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802ae9:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  802aee:	a1 00 60 80 00       	mov    0x806000,%eax
  802af3:	8b 40 04             	mov    0x4(%eax),%eax
  802af6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802af9:	89 54 24 04          	mov    %edx,0x4(%esp)
  802afd:	89 04 24             	mov    %eax,(%esp)
  802b00:	e8 98 e3 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802b05:	89 d8                	mov    %ebx,%eax
  802b07:	83 c4 3c             	add    $0x3c,%esp
  802b0a:	5b                   	pop    %ebx
  802b0b:	5e                   	pop    %esi
  802b0c:	5f                   	pop    %edi
  802b0d:	5d                   	pop    %ebp
  802b0e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  802b0f:	83 f8 78             	cmp    $0x78,%eax
  802b12:	0f 85 1d fe ff ff    	jne    802935 <_Z4openPKci+0x67>
  802b18:	eb cf                	jmp    802ae9 <_Z4openPKci+0x21b>

00802b1a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  802b1a:	55                   	push   %ebp
  802b1b:	89 e5                	mov    %esp,%ebp
  802b1d:	53                   	push   %ebx
  802b1e:	83 ec 24             	sub    $0x24,%esp
  802b21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802b24:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	e8 78 f5 ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  802b2f:	85 c0                	test   %eax,%eax
  802b31:	78 27                	js     802b5a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802b33:	c7 44 24 04 54 49 80 	movl   $0x804954,0x4(%esp)
  802b3a:	00 
  802b3b:	89 1c 24             	mov    %ebx,(%esp)
  802b3e:	e8 b7 dd ff ff       	call   8008fa <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802b43:	89 da                	mov    %ebx,%edx
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	e8 26 f4 ff ff       	call   801f73 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	e8 50 f7 ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
	return 0;
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5a:	83 c4 24             	add    $0x24,%esp
  802b5d:	5b                   	pop    %ebx
  802b5e:	5d                   	pop    %ebp
  802b5f:	c3                   	ret    

00802b60 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802b60:	55                   	push   %ebp
  802b61:	89 e5                	mov    %esp,%ebp
  802b63:	53                   	push   %ebx
  802b64:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802b67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b6e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802b71:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	e8 3a fb ff ff       	call   8026b6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802b7c:	89 c3                	mov    %eax,%ebx
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	78 5f                	js     802be1 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802b82:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	e8 18 f5 ff ff       	call   8020a7 <_ZL10inode_openiPP5Inode>
  802b8f:	89 c3                	mov    %eax,%ebx
  802b91:	85 c0                	test   %eax,%eax
  802b93:	78 44                	js     802bd9 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802b95:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	83 38 02             	cmpl   $0x2,(%eax)
  802ba0:	74 2f                	je     802bd1 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  802bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bae:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802bb2:	ba 04 00 00 00       	mov    $0x4,%edx
  802bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bba:	e8 2c f4 ff ff       	call   801feb <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  802bbf:	ba 04 00 00 00       	mov    $0x4,%edx
  802bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc7:	e8 1f f4 ff ff       	call   801feb <_ZL10bcache_ipcPvi>
	r = 0;
  802bcc:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd4:	e8 cc f6 ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	e8 c4 f6 ff ff       	call   8022a5 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802be1:	89 d8                	mov    %ebx,%eax
  802be3:	83 c4 24             	add    $0x24,%esp
  802be6:	5b                   	pop    %ebx
  802be7:	5d                   	pop    %ebp
  802be8:	c3                   	ret    

00802be9 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802be9:	55                   	push   %ebp
  802bea:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  802bec:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf1:	5d                   	pop    %ebp
  802bf2:	c3                   	ret    

00802bf3 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
  802bf6:	57                   	push   %edi
  802bf7:	56                   	push   %esi
  802bf8:	53                   	push   %ebx
  802bf9:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  802bff:	c7 04 24 4d 23 80 00 	movl   $0x80234d,(%esp)
  802c06:	e8 c0 14 00 00       	call   8040cb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802c0b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802c10:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802c15:	74 28                	je     802c3f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802c17:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802c1e:	4a 
  802c1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c23:	c7 44 24 08 bc 49 80 	movl   $0x8049bc,0x8(%esp)
  802c2a:	00 
  802c2b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802c32:	00 
  802c33:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802c3a:	e8 89 d5 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802c3f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802c44:	83 f8 03             	cmp    $0x3,%eax
  802c47:	7f 1c                	jg     802c65 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802c49:	c7 44 24 08 f0 49 80 	movl   $0x8049f0,0x8(%esp)
  802c50:	00 
  802c51:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802c58:	00 
  802c59:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802c60:	e8 63 d5 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802c65:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802c6b:	85 d2                	test   %edx,%edx
  802c6d:	7f 1c                	jg     802c8b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802c6f:	c7 44 24 08 20 4a 80 	movl   $0x804a20,0x8(%esp)
  802c76:	00 
  802c77:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802c7e:	00 
  802c7f:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802c86:	e8 3d d5 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802c8b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802c91:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802c97:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802c9d:	85 c9                	test   %ecx,%ecx
  802c9f:	0f 48 cb             	cmovs  %ebx,%ecx
  802ca2:	c1 f9 0c             	sar    $0xc,%ecx
  802ca5:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802ca9:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802caf:	39 c8                	cmp    %ecx,%eax
  802cb1:	7c 13                	jl     802cc6 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	7f 3d                	jg     802cf4 <_Z4fsckv+0x101>
  802cb7:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802cbe:	00 00 00 
  802cc1:	e9 ac 00 00 00       	jmp    802d72 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802cc6:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802ccc:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802cd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  802cd4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802cd8:	c7 44 24 08 50 4a 80 	movl   $0x804a50,0x8(%esp)
  802cdf:	00 
  802ce0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802ce7:	00 
  802ce8:	c7 04 24 36 49 80 00 	movl   $0x804936,(%esp)
  802cef:	e8 d4 d4 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802cf4:	be 00 20 00 50       	mov    $0x50002000,%esi
  802cf9:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802d00:	00 00 00 
  802d03:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d08:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802d0e:	39 df                	cmp    %ebx,%edi
  802d10:	7e 27                	jle    802d39 <_Z4fsckv+0x146>
  802d12:	0f b6 06             	movzbl (%esi),%eax
  802d15:	84 c0                	test   %al,%al
  802d17:	74 4b                	je     802d64 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802d19:	0f be c0             	movsbl %al,%eax
  802d1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d24:	c7 04 24 94 4a 80 00 	movl   $0x804a94,(%esp)
  802d2b:	e8 b6 d5 ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  802d30:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d37:	eb 2b                	jmp    802d64 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802d39:	0f b6 06             	movzbl (%esi),%eax
  802d3c:	3c 01                	cmp    $0x1,%al
  802d3e:	76 24                	jbe    802d64 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802d40:	0f be c0             	movsbl %al,%eax
  802d43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d47:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d4b:	c7 04 24 c8 4a 80 00 	movl   $0x804ac8,(%esp)
  802d52:	e8 8f d5 ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  802d57:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802d5e:	80 3e 00             	cmpb   $0x0,(%esi)
  802d61:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802d64:	83 c3 01             	add    $0x1,%ebx
  802d67:	83 c6 01             	add    $0x1,%esi
  802d6a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802d70:	7f 9c                	jg     802d0e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802d72:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802d79:	0f 8e e1 02 00 00    	jle    803060 <_Z4fsckv+0x46d>
  802d7f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802d86:	00 00 00 
		struct Inode *ino = get_inode(i);
  802d89:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d8f:	e8 f9 f1 ff ff       	call   801f8d <_ZL9get_inodei>
  802d94:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  802d9a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  802d9e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802da5:	75 22                	jne    802dc9 <_Z4fsckv+0x1d6>
  802da7:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  802dae:	0f 84 a9 06 00 00    	je     80345d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802db4:	ba 00 00 00 00       	mov    $0x0,%edx
  802db9:	e8 2d f2 ff ff       	call   801feb <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	74 3a                	je     802dfc <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802dc2:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802dc9:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802dcf:	8b 02                	mov    (%edx),%eax
  802dd1:	83 f8 01             	cmp    $0x1,%eax
  802dd4:	74 26                	je     802dfc <_Z4fsckv+0x209>
  802dd6:	83 f8 02             	cmp    $0x2,%eax
  802dd9:	74 21                	je     802dfc <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  802ddb:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ddf:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802de5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802de9:	c7 04 24 f4 4a 80 00 	movl   $0x804af4,(%esp)
  802df0:	e8 f1 d4 ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  802df5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  802dfc:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802e03:	75 3f                	jne    802e44 <_Z4fsckv+0x251>
  802e05:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802e0b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802e0f:	75 15                	jne    802e26 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802e11:	c7 04 24 18 4b 80 00 	movl   $0x804b18,(%esp)
  802e18:	e8 c9 d4 ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  802e1d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802e24:	eb 1e                	jmp    802e44 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802e26:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e2c:	83 3a 02             	cmpl   $0x2,(%edx)
  802e2f:	74 13                	je     802e44 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802e31:	c7 04 24 4c 4b 80 00 	movl   $0x804b4c,(%esp)
  802e38:	e8 a9 d4 ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  802e3d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802e44:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802e49:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802e50:	0f 84 93 00 00 00    	je     802ee9 <_Z4fsckv+0x2f6>
  802e56:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  802e5c:	8b 41 08             	mov    0x8(%ecx),%eax
  802e5f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802e64:	7e 23                	jle    802e89 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802e66:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e6a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802e70:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e74:	c7 04 24 7c 4b 80 00 	movl   $0x804b7c,(%esp)
  802e7b:	e8 66 d4 ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  802e80:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802e87:	eb 09                	jmp    802e92 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802e89:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802e90:	74 4b                	je     802edd <_Z4fsckv+0x2ea>
  802e92:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e98:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  802e9e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802ea4:	74 23                	je     802ec9 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802ea6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802eaa:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802eb0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802eb4:	c7 04 24 a0 4b 80 00 	movl   $0x804ba0,(%esp)
  802ebb:	e8 26 d4 ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  802ec0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ec7:	eb 09                	jmp    802ed2 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802ec9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ed0:	74 12                	je     802ee4 <_Z4fsckv+0x2f1>
  802ed2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802ed8:	8b 78 08             	mov    0x8(%eax),%edi
  802edb:	eb 0c                	jmp    802ee9 <_Z4fsckv+0x2f6>
  802edd:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee2:	eb 05                	jmp    802ee9 <_Z4fsckv+0x2f6>
  802ee4:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802ee9:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  802eee:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802ef4:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802ef8:	89 d8                	mov    %ebx,%eax
  802efa:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802efd:	39 c7                	cmp    %eax,%edi
  802eff:	7e 2b                	jle    802f2c <_Z4fsckv+0x339>
  802f01:	85 f6                	test   %esi,%esi
  802f03:	75 27                	jne    802f2c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802f05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f0d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802f13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f17:	c7 04 24 c4 4b 80 00 	movl   $0x804bc4,(%esp)
  802f1e:	e8 c3 d3 ff ff       	call   8002e6 <_Z7cprintfPKcz>
				++errors;
  802f23:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f2a:	eb 36                	jmp    802f62 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  802f2c:	39 f8                	cmp    %edi,%eax
  802f2e:	7c 32                	jl     802f62 <_Z4fsckv+0x36f>
  802f30:	85 f6                	test   %esi,%esi
  802f32:	74 2e                	je     802f62 <_Z4fsckv+0x36f>
  802f34:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802f3b:	74 25                	je     802f62 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  802f3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f41:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f45:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f4f:	c7 04 24 08 4c 80 00 	movl   $0x804c08,(%esp)
  802f56:	e8 8b d3 ff ff       	call   8002e6 <_Z7cprintfPKcz>
				++errors;
  802f5b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802f62:	85 f6                	test   %esi,%esi
  802f64:	0f 84 a0 00 00 00    	je     80300a <_Z4fsckv+0x417>
  802f6a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802f71:	0f 84 93 00 00 00    	je     80300a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802f77:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802f7d:	7e 27                	jle    802fa6 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802f7f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802f83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f87:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802f8d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f91:	c7 04 24 4c 4c 80 00 	movl   $0x804c4c,(%esp)
  802f98:	e8 49 d3 ff ff       	call   8002e6 <_Z7cprintfPKcz>
					++errors;
  802f9d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802fa4:	eb 64                	jmp    80300a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802fa6:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802fad:	3c 01                	cmp    $0x1,%al
  802faf:	75 27                	jne    802fd8 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802fb1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802fb5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fb9:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802fbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fc3:	c7 04 24 90 4c 80 00 	movl   $0x804c90,(%esp)
  802fca:	e8 17 d3 ff ff       	call   8002e6 <_Z7cprintfPKcz>
					++errors;
  802fcf:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802fd6:	eb 32                	jmp    80300a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802fd8:	3c ff                	cmp    $0xff,%al
  802fda:	75 27                	jne    803003 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802fdc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802fe0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fe4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802fea:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fee:	c7 04 24 cc 4c 80 00 	movl   $0x804ccc,(%esp)
  802ff5:	e8 ec d2 ff ff       	call   8002e6 <_Z7cprintfPKcz>
					++errors;
  802ffa:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803001:	eb 07                	jmp    80300a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  803003:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  80300a:	83 c3 01             	add    $0x1,%ebx
  80300d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  803013:	0f 85 d5 fe ff ff    	jne    802eee <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  803019:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  803020:	0f 94 c0             	sete   %al
  803023:	0f b6 c0             	movzbl %al,%eax
  803026:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80302c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  803032:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  803039:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  803040:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803047:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  80304e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803054:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  80305a:	0f 8f 29 fd ff ff    	jg     802d89 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803060:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803067:	0f 8e 7f 03 00 00    	jle    8033ec <_Z4fsckv+0x7f9>
  80306d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  803072:	89 f0                	mov    %esi,%eax
  803074:	e8 14 ef ff ff       	call   801f8d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  803079:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803080:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803087:	c1 e2 08             	shl    $0x8,%edx
  80308a:	09 ca                	or     %ecx,%edx
  80308c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803093:	c1 e1 10             	shl    $0x10,%ecx
  803096:	09 ca                	or     %ecx,%edx
  803098:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  80309f:	83 e1 7f             	and    $0x7f,%ecx
  8030a2:	c1 e1 18             	shl    $0x18,%ecx
  8030a5:	09 d1                	or     %edx,%ecx
  8030a7:	74 0e                	je     8030b7 <_Z4fsckv+0x4c4>
  8030a9:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  8030b0:	78 05                	js     8030b7 <_Z4fsckv+0x4c4>
  8030b2:	83 38 02             	cmpl   $0x2,(%eax)
  8030b5:	74 1f                	je     8030d6 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8030b7:	83 c6 01             	add    $0x1,%esi
  8030ba:	a1 08 10 00 50       	mov    0x50001008,%eax
  8030bf:	39 f0                	cmp    %esi,%eax
  8030c1:	7f af                	jg     803072 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  8030c3:	bb 01 00 00 00       	mov    $0x1,%ebx
  8030c8:	83 f8 01             	cmp    $0x1,%eax
  8030cb:	0f 8f ad 02 00 00    	jg     80337e <_Z4fsckv+0x78b>
  8030d1:	e9 16 03 00 00       	jmp    8033ec <_Z4fsckv+0x7f9>
  8030d6:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  8030d8:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  8030df:	8b 40 08             	mov    0x8(%eax),%eax
  8030e2:	a8 7f                	test   $0x7f,%al
  8030e4:	74 23                	je     803109 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  8030e6:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  8030ed:	00 
  8030ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030f6:	c7 04 24 08 4d 80 00 	movl   $0x804d08,(%esp)
  8030fd:	e8 e4 d1 ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  803102:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803109:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  803110:	00 00 00 
  803113:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  803119:	e9 3d 02 00 00       	jmp    80335b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  80311e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803124:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80312a:	e8 01 ee ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
  80312f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  803131:	83 38 00             	cmpl   $0x0,(%eax)
  803134:	0f 84 15 02 00 00    	je     80334f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  80313a:	8b 40 04             	mov    0x4(%eax),%eax
  80313d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803140:	83 fa 76             	cmp    $0x76,%edx
  803143:	76 27                	jbe    80316c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  803145:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803149:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80314f:	89 44 24 08          	mov    %eax,0x8(%esp)
  803153:	89 74 24 04          	mov    %esi,0x4(%esp)
  803157:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  80315e:	e8 83 d1 ff ff       	call   8002e6 <_Z7cprintfPKcz>
				++errors;
  803163:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80316a:	eb 28                	jmp    803194 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  80316c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  803171:	74 21                	je     803194 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  803173:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803179:	89 54 24 08          	mov    %edx,0x8(%esp)
  80317d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803181:	c7 04 24 68 4d 80 00 	movl   $0x804d68,(%esp)
  803188:	e8 59 d1 ff ff       	call   8002e6 <_Z7cprintfPKcz>
				++errors;
  80318d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803194:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  80319b:	00 
  80319c:	8d 43 08             	lea    0x8(%ebx),%eax
  80319f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031a3:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  8031a9:	89 0c 24             	mov    %ecx,(%esp)
  8031ac:	e8 66 d9 ff ff       	call   800b17 <memcpy>
  8031b1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  8031b5:	bf 77 00 00 00       	mov    $0x77,%edi
  8031ba:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  8031be:	85 ff                	test   %edi,%edi
  8031c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c5:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  8031c8:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  8031cf:	00 

			if (de->de_inum >= super->s_ninodes) {
  8031d0:	8b 03                	mov    (%ebx),%eax
  8031d2:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  8031d8:	7c 3e                	jl     803218 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  8031da:	89 44 24 10          	mov    %eax,0x10(%esp)
  8031de:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8031e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031e8:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8031ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8031f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031f6:	c7 04 24 9c 4d 80 00 	movl   $0x804d9c,(%esp)
  8031fd:	e8 e4 d0 ff ff       	call   8002e6 <_Z7cprintfPKcz>
				++errors;
  803202:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803209:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  803210:	00 00 00 
  803213:	e9 0b 01 00 00       	jmp    803323 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  803218:	e8 70 ed ff ff       	call   801f8d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  80321d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803224:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  80322b:	c1 e2 08             	shl    $0x8,%edx
  80322e:	09 d1                	or     %edx,%ecx
  803230:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  803237:	c1 e2 10             	shl    $0x10,%edx
  80323a:	09 d1                	or     %edx,%ecx
  80323c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803243:	83 e2 7f             	and    $0x7f,%edx
  803246:	c1 e2 18             	shl    $0x18,%edx
  803249:	09 ca                	or     %ecx,%edx
  80324b:	83 c2 01             	add    $0x1,%edx
  80324e:	89 d1                	mov    %edx,%ecx
  803250:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  803256:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  80325c:	0f b6 d5             	movzbl %ch,%edx
  80325f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  803265:	89 ca                	mov    %ecx,%edx
  803267:	c1 ea 10             	shr    $0x10,%edx
  80326a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  803270:	c1 e9 18             	shr    $0x18,%ecx
  803273:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  80327a:	83 e2 80             	and    $0xffffff80,%edx
  80327d:	09 ca                	or     %ecx,%edx
  80327f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803285:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803289:	0f 85 7a ff ff ff    	jne    803209 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  80328f:	8b 03                	mov    (%ebx),%eax
  803291:	89 44 24 10          	mov    %eax,0x10(%esp)
  803295:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80329b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80329f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8032a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8032a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8032ad:	c7 04 24 cc 4d 80 00 	movl   $0x804dcc,(%esp)
  8032b4:	e8 2d d0 ff ff       	call   8002e6 <_Z7cprintfPKcz>
					++errors;
  8032b9:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8032c0:	e9 44 ff ff ff       	jmp    803209 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  8032c5:	3b 78 04             	cmp    0x4(%eax),%edi
  8032c8:	75 52                	jne    80331c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  8032ca:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8032ce:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  8032d4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8032d8:	83 c0 08             	add    $0x8,%eax
  8032db:	89 04 24             	mov    %eax,(%esp)
  8032de:	e8 75 d8 ff ff       	call   800b58 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  8032e3:	85 c0                	test   %eax,%eax
  8032e5:	75 35                	jne    80331c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  8032e7:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8032ed:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8032f1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8032f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032fb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803301:	89 54 24 08          	mov    %edx,0x8(%esp)
  803305:	89 74 24 04          	mov    %esi,0x4(%esp)
  803309:	c7 04 24 fc 4d 80 00 	movl   $0x804dfc,(%esp)
  803310:	e8 d1 cf ff ff       	call   8002e6 <_Z7cprintfPKcz>
					++errors;
  803315:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80331c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  803323:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803329:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  80332f:	7e 1e                	jle    80334f <_Z4fsckv+0x75c>
  803331:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803335:	7f 18                	jg     80334f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  803337:	89 ca                	mov    %ecx,%edx
  803339:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80333f:	e8 ec eb ff ff       	call   801f30 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  803344:	83 38 00             	cmpl   $0x0,(%eax)
  803347:	0f 85 78 ff ff ff    	jne    8032c5 <_Z4fsckv+0x6d2>
  80334d:	eb cd                	jmp    80331c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80334f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  803355:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80335b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803361:	83 ea 80             	sub    $0xffffff80,%edx
  803364:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80336a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803370:	3b 51 08             	cmp    0x8(%ecx),%edx
  803373:	0f 8f e7 fc ff ff    	jg     803060 <_Z4fsckv+0x46d>
  803379:	e9 a0 fd ff ff       	jmp    80311e <_Z4fsckv+0x52b>
  80337e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803384:	89 d8                	mov    %ebx,%eax
  803386:	e8 02 ec ff ff       	call   801f8d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  80338b:	8b 50 04             	mov    0x4(%eax),%edx
  80338e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803395:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80339c:	c1 e7 08             	shl    $0x8,%edi
  80339f:	09 f9                	or     %edi,%ecx
  8033a1:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  8033a8:	c1 e7 10             	shl    $0x10,%edi
  8033ab:	09 f9                	or     %edi,%ecx
  8033ad:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  8033b4:	83 e7 7f             	and    $0x7f,%edi
  8033b7:	c1 e7 18             	shl    $0x18,%edi
  8033ba:	09 f9                	or     %edi,%ecx
  8033bc:	39 ca                	cmp    %ecx,%edx
  8033be:	74 1b                	je     8033db <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  8033c0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033c4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8033c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8033cc:	c7 04 24 2c 4e 80 00 	movl   $0x804e2c,(%esp)
  8033d3:	e8 0e cf ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  8033d8:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  8033db:	83 c3 01             	add    $0x1,%ebx
  8033de:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  8033e4:	7f 9e                	jg     803384 <_Z4fsckv+0x791>
  8033e6:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8033ec:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  8033f3:	7e 4f                	jle    803444 <_Z4fsckv+0x851>
  8033f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8033fa:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  803400:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  803407:	3c ff                	cmp    $0xff,%al
  803409:	75 09                	jne    803414 <_Z4fsckv+0x821>
			freemap[i] = 0;
  80340b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803412:	eb 1f                	jmp    803433 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803414:	84 c0                	test   %al,%al
  803416:	75 1b                	jne    803433 <_Z4fsckv+0x840>
  803418:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80341e:	7c 13                	jl     803433 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803420:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803424:	c7 04 24 58 4e 80 00 	movl   $0x804e58,(%esp)
  80342b:	e8 b6 ce ff ff       	call   8002e6 <_Z7cprintfPKcz>
			++errors;
  803430:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803433:	83 c3 01             	add    $0x1,%ebx
  803436:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  80343c:	7f c2                	jg     803400 <_Z4fsckv+0x80d>
  80343e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803444:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80344b:	19 c0                	sbb    %eax,%eax
  80344d:	f7 d0                	not    %eax
  80344f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  803452:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  803458:	5b                   	pop    %ebx
  803459:	5e                   	pop    %esi
  80345a:	5f                   	pop    %edi
  80345b:	5d                   	pop    %ebp
  80345c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  80345d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803464:	0f 84 92 f9 ff ff    	je     802dfc <_Z4fsckv+0x209>
  80346a:	e9 5a f9 ff ff       	jmp    802dc9 <_Z4fsckv+0x1d6>
	...

00803470 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803470:	55                   	push   %ebp
  803471:	89 e5                	mov    %esp,%ebp
  803473:	83 ec 18             	sub    $0x18,%esp
  803476:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803479:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80347c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	89 04 24             	mov    %eax,(%esp)
  803485:	e8 a2 e4 ff ff       	call   80192c <_Z7fd2dataP2Fd>
  80348a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80348c:	c7 44 24 04 8b 4e 80 	movl   $0x804e8b,0x4(%esp)
  803493:	00 
  803494:	89 34 24             	mov    %esi,(%esp)
  803497:	e8 5e d4 ff ff       	call   8008fa <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80349c:	8b 43 04             	mov    0x4(%ebx),%eax
  80349f:	2b 03                	sub    (%ebx),%eax
  8034a1:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  8034a4:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  8034ab:	c7 86 80 00 00 00 20 	movl   $0x805020,0x80(%esi)
  8034b2:	50 80 00 
	return 0;
}
  8034b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ba:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8034bd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8034c0:	89 ec                	mov    %ebp,%esp
  8034c2:	5d                   	pop    %ebp
  8034c3:	c3                   	ret    

008034c4 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  8034c4:	55                   	push   %ebp
  8034c5:	89 e5                	mov    %esp,%ebp
  8034c7:	53                   	push   %ebx
  8034c8:	83 ec 14             	sub    $0x14,%esp
  8034cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8034ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8034d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034d9:	e8 bf d9 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  8034de:	89 1c 24             	mov    %ebx,(%esp)
  8034e1:	e8 46 e4 ff ff       	call   80192c <_Z7fd2dataP2Fd>
  8034e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034f1:	e8 a7 d9 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
}
  8034f6:	83 c4 14             	add    $0x14,%esp
  8034f9:	5b                   	pop    %ebx
  8034fa:	5d                   	pop    %ebp
  8034fb:	c3                   	ret    

008034fc <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034fc:	55                   	push   %ebp
  8034fd:	89 e5                	mov    %esp,%ebp
  8034ff:	57                   	push   %edi
  803500:	56                   	push   %esi
  803501:	53                   	push   %ebx
  803502:	83 ec 2c             	sub    $0x2c,%esp
  803505:	89 c7                	mov    %eax,%edi
  803507:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80350a:	a1 00 60 80 00       	mov    0x806000,%eax
  80350f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803512:	89 3c 24             	mov    %edi,(%esp)
  803515:	e8 82 04 00 00       	call   80399c <_Z7pagerefPv>
  80351a:	89 c3                	mov    %eax,%ebx
  80351c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351f:	89 04 24             	mov    %eax,(%esp)
  803522:	e8 75 04 00 00       	call   80399c <_Z7pagerefPv>
  803527:	39 c3                	cmp    %eax,%ebx
  803529:	0f 94 c0             	sete   %al
  80352c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80352f:	8b 15 00 60 80 00    	mov    0x806000,%edx
  803535:	8b 52 58             	mov    0x58(%edx),%edx
  803538:	39 d6                	cmp    %edx,%esi
  80353a:	75 08                	jne    803544 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  80353c:	83 c4 2c             	add    $0x2c,%esp
  80353f:	5b                   	pop    %ebx
  803540:	5e                   	pop    %esi
  803541:	5f                   	pop    %edi
  803542:	5d                   	pop    %ebp
  803543:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803544:	85 c0                	test   %eax,%eax
  803546:	74 c2                	je     80350a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803548:	c7 04 24 92 4e 80 00 	movl   $0x804e92,(%esp)
  80354f:	e8 92 cd ff ff       	call   8002e6 <_Z7cprintfPKcz>
  803554:	eb b4                	jmp    80350a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00803556 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803556:	55                   	push   %ebp
  803557:	89 e5                	mov    %esp,%ebp
  803559:	57                   	push   %edi
  80355a:	56                   	push   %esi
  80355b:	53                   	push   %ebx
  80355c:	83 ec 1c             	sub    $0x1c,%esp
  80355f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803562:	89 34 24             	mov    %esi,(%esp)
  803565:	e8 c2 e3 ff ff       	call   80192c <_Z7fd2dataP2Fd>
  80356a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80356c:	bf 00 00 00 00       	mov    $0x0,%edi
  803571:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803575:	75 46                	jne    8035bd <_ZL13devpipe_writeP2FdPKvj+0x67>
  803577:	eb 52                	jmp    8035cb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803579:	89 da                	mov    %ebx,%edx
  80357b:	89 f0                	mov    %esi,%eax
  80357d:	e8 7a ff ff ff       	call   8034fc <_ZL13_pipeisclosedP2FdP4Pipe>
  803582:	85 c0                	test   %eax,%eax
  803584:	75 49                	jne    8035cf <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803586:	e8 21 d8 ff ff       	call   800dac <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80358b:	8b 43 04             	mov    0x4(%ebx),%eax
  80358e:	89 c2                	mov    %eax,%edx
  803590:	2b 13                	sub    (%ebx),%edx
  803592:	83 fa 20             	cmp    $0x20,%edx
  803595:	74 e2                	je     803579 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803597:	89 c2                	mov    %eax,%edx
  803599:	c1 fa 1f             	sar    $0x1f,%edx
  80359c:	c1 ea 1b             	shr    $0x1b,%edx
  80359f:	01 d0                	add    %edx,%eax
  8035a1:	83 e0 1f             	and    $0x1f,%eax
  8035a4:	29 d0                	sub    %edx,%eax
  8035a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8035a9:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  8035ad:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  8035b1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8035b5:	83 c7 01             	add    $0x1,%edi
  8035b8:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8035bb:	76 0e                	jbe    8035cb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8035bd:	8b 43 04             	mov    0x4(%ebx),%eax
  8035c0:	89 c2                	mov    %eax,%edx
  8035c2:	2b 13                	sub    (%ebx),%edx
  8035c4:	83 fa 20             	cmp    $0x20,%edx
  8035c7:	74 b0                	je     803579 <_ZL13devpipe_writeP2FdPKvj+0x23>
  8035c9:	eb cc                	jmp    803597 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  8035cb:	89 f8                	mov    %edi,%eax
  8035cd:	eb 05                	jmp    8035d4 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  8035cf:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  8035d4:	83 c4 1c             	add    $0x1c,%esp
  8035d7:	5b                   	pop    %ebx
  8035d8:	5e                   	pop    %esi
  8035d9:	5f                   	pop    %edi
  8035da:	5d                   	pop    %ebp
  8035db:	c3                   	ret    

008035dc <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035dc:	55                   	push   %ebp
  8035dd:	89 e5                	mov    %esp,%ebp
  8035df:	83 ec 28             	sub    $0x28,%esp
  8035e2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8035e5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8035e8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8035eb:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8035ee:	89 3c 24             	mov    %edi,(%esp)
  8035f1:	e8 36 e3 ff ff       	call   80192c <_Z7fd2dataP2Fd>
  8035f6:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8035f8:	be 00 00 00 00       	mov    $0x0,%esi
  8035fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803601:	75 47                	jne    80364a <_ZL12devpipe_readP2FdPvj+0x6e>
  803603:	eb 52                	jmp    803657 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803605:	89 f0                	mov    %esi,%eax
  803607:	eb 5e                	jmp    803667 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803609:	89 da                	mov    %ebx,%edx
  80360b:	89 f8                	mov    %edi,%eax
  80360d:	8d 76 00             	lea    0x0(%esi),%esi
  803610:	e8 e7 fe ff ff       	call   8034fc <_ZL13_pipeisclosedP2FdP4Pipe>
  803615:	85 c0                	test   %eax,%eax
  803617:	75 49                	jne    803662 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803619:	e8 8e d7 ff ff       	call   800dac <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80361e:	8b 03                	mov    (%ebx),%eax
  803620:	3b 43 04             	cmp    0x4(%ebx),%eax
  803623:	74 e4                	je     803609 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803625:	89 c2                	mov    %eax,%edx
  803627:	c1 fa 1f             	sar    $0x1f,%edx
  80362a:	c1 ea 1b             	shr    $0x1b,%edx
  80362d:	01 d0                	add    %edx,%eax
  80362f:	83 e0 1f             	and    $0x1f,%eax
  803632:	29 d0                	sub    %edx,%eax
  803634:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80363c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80363f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803642:	83 c6 01             	add    $0x1,%esi
  803645:	39 75 10             	cmp    %esi,0x10(%ebp)
  803648:	76 0d                	jbe    803657 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80364a:	8b 03                	mov    (%ebx),%eax
  80364c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80364f:	75 d4                	jne    803625 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803651:	85 f6                	test   %esi,%esi
  803653:	75 b0                	jne    803605 <_ZL12devpipe_readP2FdPvj+0x29>
  803655:	eb b2                	jmp    803609 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803657:	89 f0                	mov    %esi,%eax
  803659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803660:	eb 05                	jmp    803667 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803662:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803667:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80366a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80366d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803670:	89 ec                	mov    %ebp,%esp
  803672:	5d                   	pop    %ebp
  803673:	c3                   	ret    

00803674 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803674:	55                   	push   %ebp
  803675:	89 e5                	mov    %esp,%ebp
  803677:	83 ec 48             	sub    $0x48,%esp
  80367a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80367d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803680:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803683:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803686:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803689:	89 04 24             	mov    %eax,(%esp)
  80368c:	e8 b6 e2 ff ff       	call   801947 <_Z14fd_find_unusedPP2Fd>
  803691:	89 c3                	mov    %eax,%ebx
  803693:	85 c0                	test   %eax,%eax
  803695:	0f 88 0b 01 00 00    	js     8037a6 <_Z4pipePi+0x132>
  80369b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8036a2:	00 
  8036a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036b1:	e8 2a d7 ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  8036b6:	89 c3                	mov    %eax,%ebx
  8036b8:	85 c0                	test   %eax,%eax
  8036ba:	0f 89 f5 00 00 00    	jns    8037b5 <_Z4pipePi+0x141>
  8036c0:	e9 e1 00 00 00       	jmp    8037a6 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8036c5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8036cc:	00 
  8036cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036db:	e8 00 d7 ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  8036e0:	89 c3                	mov    %eax,%ebx
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	0f 89 e2 00 00 00    	jns    8037cc <_Z4pipePi+0x158>
  8036ea:	e9 a4 00 00 00       	jmp    803793 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f2:	89 04 24             	mov    %eax,(%esp)
  8036f5:	e8 32 e2 ff ff       	call   80192c <_Z7fd2dataP2Fd>
  8036fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803701:	00 
  803702:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803706:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80370d:	00 
  80370e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803712:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803719:	e8 21 d7 ff ff       	call   800e3f <_Z12sys_page_mapiPviS_i>
  80371e:	89 c3                	mov    %eax,%ebx
  803720:	85 c0                	test   %eax,%eax
  803722:	78 4c                	js     803770 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803724:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80372a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80372f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803739:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80373f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803742:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803747:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80374e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803751:	89 04 24             	mov    %eax,(%esp)
  803754:	e8 8b e1 ff ff       	call   8018e4 <_Z6fd2numP2Fd>
  803759:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80375b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80375e:	89 04 24             	mov    %eax,(%esp)
  803761:	e8 7e e1 ff ff       	call   8018e4 <_Z6fd2numP2Fd>
  803766:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803769:	bb 00 00 00 00       	mov    $0x0,%ebx
  80376e:	eb 36                	jmp    8037a6 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803770:	89 74 24 04          	mov    %esi,0x4(%esp)
  803774:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80377b:	e8 1d d7 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803780:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803783:	89 44 24 04          	mov    %eax,0x4(%esp)
  803787:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80378e:	e8 0a d7 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803796:	89 44 24 04          	mov    %eax,0x4(%esp)
  80379a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037a1:	e8 f7 d6 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  8037a6:	89 d8                	mov    %ebx,%eax
  8037a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8037ab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8037ae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8037b1:	89 ec                	mov    %ebp,%esp
  8037b3:	5d                   	pop    %ebp
  8037b4:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8037b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037b8:	89 04 24             	mov    %eax,(%esp)
  8037bb:	e8 87 e1 ff ff       	call   801947 <_Z14fd_find_unusedPP2Fd>
  8037c0:	89 c3                	mov    %eax,%ebx
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	0f 89 fb fe ff ff    	jns    8036c5 <_Z4pipePi+0x51>
  8037ca:	eb c7                	jmp    803793 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8037cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cf:	89 04 24             	mov    %eax,(%esp)
  8037d2:	e8 55 e1 ff ff       	call   80192c <_Z7fd2dataP2Fd>
  8037d7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037d9:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8037e0:	00 
  8037e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037ec:	e8 ef d5 ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  8037f1:	89 c3                	mov    %eax,%ebx
  8037f3:	85 c0                	test   %eax,%eax
  8037f5:	0f 89 f4 fe ff ff    	jns    8036ef <_Z4pipePi+0x7b>
  8037fb:	eb 83                	jmp    803780 <_Z4pipePi+0x10c>

008037fd <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  8037fd:	55                   	push   %ebp
  8037fe:	89 e5                	mov    %esp,%ebp
  803800:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803803:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80380a:	00 
  80380b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80380e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803812:	8b 45 08             	mov    0x8(%ebp),%eax
  803815:	89 04 24             	mov    %eax,(%esp)
  803818:	e8 74 e0 ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  80381d:	85 c0                	test   %eax,%eax
  80381f:	78 15                	js     803836 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803824:	89 04 24             	mov    %eax,(%esp)
  803827:	e8 00 e1 ff ff       	call   80192c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80382c:	89 c2                	mov    %eax,%edx
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	e8 c6 fc ff ff       	call   8034fc <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803836:	c9                   	leave  
  803837:	c3                   	ret    

00803838 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803838:	55                   	push   %ebp
  803839:	89 e5                	mov    %esp,%ebp
  80383b:	53                   	push   %ebx
  80383c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80383f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803842:	89 04 24             	mov    %eax,(%esp)
  803845:	e8 fd e0 ff ff       	call   801947 <_Z14fd_find_unusedPP2Fd>
  80384a:	89 c3                	mov    %eax,%ebx
  80384c:	85 c0                	test   %eax,%eax
  80384e:	0f 88 be 00 00 00    	js     803912 <_Z18pipe_ipc_recv_readv+0xda>
  803854:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80385b:	00 
  80385c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803863:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80386a:	e8 71 d5 ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  80386f:	89 c3                	mov    %eax,%ebx
  803871:	85 c0                	test   %eax,%eax
  803873:	0f 89 a1 00 00 00    	jns    80391a <_Z18pipe_ipc_recv_readv+0xe2>
  803879:	e9 94 00 00 00       	jmp    803912 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80387e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803881:	85 c0                	test   %eax,%eax
  803883:	75 0e                	jne    803893 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803885:	c7 04 24 f0 4e 80 00 	movl   $0x804ef0,(%esp)
  80388c:	e8 55 ca ff ff       	call   8002e6 <_Z7cprintfPKcz>
  803891:	eb 10                	jmp    8038a3 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803893:	89 44 24 04          	mov    %eax,0x4(%esp)
  803897:	c7 04 24 a5 4e 80 00 	movl   $0x804ea5,(%esp)
  80389e:	e8 43 ca ff ff       	call   8002e6 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  8038a3:	c7 04 24 af 4e 80 00 	movl   $0x804eaf,(%esp)
  8038aa:	e8 37 ca ff ff       	call   8002e6 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  8038af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038b2:	a8 04                	test   $0x4,%al
  8038b4:	74 04                	je     8038ba <_Z18pipe_ipc_recv_readv+0x82>
  8038b6:	a8 01                	test   $0x1,%al
  8038b8:	75 24                	jne    8038de <_Z18pipe_ipc_recv_readv+0xa6>
  8038ba:	c7 44 24 0c c2 4e 80 	movl   $0x804ec2,0xc(%esp)
  8038c1:	00 
  8038c2:	c7 44 24 08 8b 48 80 	movl   $0x80488b,0x8(%esp)
  8038c9:	00 
  8038ca:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8038d1:	00 
  8038d2:	c7 04 24 df 4e 80 00 	movl   $0x804edf,(%esp)
  8038d9:	e8 ea c8 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  8038de:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8038e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e7:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  8038e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  8038f3:	89 04 24             	mov    %eax,(%esp)
  8038f6:	e8 e9 df ff ff       	call   8018e4 <_Z6fd2numP2Fd>
  8038fb:	89 c3                	mov    %eax,%ebx
  8038fd:	eb 13                	jmp    803912 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  8038ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803902:	89 44 24 04          	mov    %eax,0x4(%esp)
  803906:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80390d:	e8 8b d5 ff ff       	call   800e9d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803912:	89 d8                	mov    %ebx,%eax
  803914:	83 c4 24             	add    $0x24,%esp
  803917:	5b                   	pop    %ebx
  803918:	5d                   	pop    %ebp
  803919:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80391a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391d:	89 04 24             	mov    %eax,(%esp)
  803920:	e8 07 e0 ff ff       	call   80192c <_Z7fd2dataP2Fd>
  803925:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803928:	89 54 24 08          	mov    %edx,0x8(%esp)
  80392c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803930:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803933:	89 04 24             	mov    %eax,(%esp)
  803936:	e8 d5 dd ff ff       	call   801710 <_Z8ipc_recvPiPvS_>
  80393b:	89 c3                	mov    %eax,%ebx
  80393d:	85 c0                	test   %eax,%eax
  80393f:	0f 89 39 ff ff ff    	jns    80387e <_Z18pipe_ipc_recv_readv+0x46>
  803945:	eb b8                	jmp    8038ff <_Z18pipe_ipc_recv_readv+0xc7>

00803947 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803947:	55                   	push   %ebp
  803948:	89 e5                	mov    %esp,%ebp
  80394a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80394d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803954:	00 
  803955:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80395c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80395f:	89 04 24             	mov    %eax,(%esp)
  803962:	e8 2a df ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  803967:	85 c0                	test   %eax,%eax
  803969:	78 2f                	js     80399a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80396b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396e:	89 04 24             	mov    %eax,(%esp)
  803971:	e8 b6 df ff ff       	call   80192c <_Z7fd2dataP2Fd>
  803976:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80397d:	00 
  80397e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803982:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803989:	00 
  80398a:	8b 45 08             	mov    0x8(%ebp),%eax
  80398d:	89 04 24             	mov    %eax,(%esp)
  803990:	e8 0a de ff ff       	call   80179f <_Z8ipc_sendijPvi>
    return 0;
  803995:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80399a:	c9                   	leave  
  80399b:	c3                   	ret    

0080399c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80399c:	55                   	push   %ebp
  80399d:	89 e5                	mov    %esp,%ebp
  80399f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8039a2:	89 d0                	mov    %edx,%eax
  8039a4:	c1 e8 16             	shr    $0x16,%eax
  8039a7:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  8039ae:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8039b3:	f6 c1 01             	test   $0x1,%cl
  8039b6:	74 1d                	je     8039d5 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  8039b8:	c1 ea 0c             	shr    $0xc,%edx
  8039bb:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8039c2:	f6 c2 01             	test   $0x1,%dl
  8039c5:	74 0e                	je     8039d5 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8039c7:	c1 ea 0c             	shr    $0xc,%edx
  8039ca:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  8039d1:	ef 
  8039d2:	0f b7 c0             	movzwl %ax,%eax
}
  8039d5:	5d                   	pop    %ebp
  8039d6:	c3                   	ret    
	...

008039e0 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8039e0:	55                   	push   %ebp
  8039e1:	89 e5                	mov    %esp,%ebp
  8039e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8039e6:	c7 44 24 04 13 4f 80 	movl   $0x804f13,0x4(%esp)
  8039ed:	00 
  8039ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039f1:	89 04 24             	mov    %eax,(%esp)
  8039f4:	e8 01 cf ff ff       	call   8008fa <_Z6strcpyPcPKc>
	return 0;
}
  8039f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fe:	c9                   	leave  
  8039ff:	c3                   	ret    

00803a00 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803a00:	55                   	push   %ebp
  803a01:	89 e5                	mov    %esp,%ebp
  803a03:	53                   	push   %ebx
  803a04:	83 ec 14             	sub    $0x14,%esp
  803a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803a0a:	89 1c 24             	mov    %ebx,(%esp)
  803a0d:	e8 8a ff ff ff       	call   80399c <_Z7pagerefPv>
  803a12:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803a14:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803a19:	83 fa 01             	cmp    $0x1,%edx
  803a1c:	75 0b                	jne    803a29 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  803a1e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803a21:	89 04 24             	mov    %eax,(%esp)
  803a24:	e8 fe 02 00 00       	call   803d27 <_Z11nsipc_closei>
	else
		return 0;
}
  803a29:	83 c4 14             	add    $0x14,%esp
  803a2c:	5b                   	pop    %ebx
  803a2d:	5d                   	pop    %ebp
  803a2e:	c3                   	ret    

00803a2f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803a2f:	55                   	push   %ebp
  803a30:	89 e5                	mov    %esp,%ebp
  803a32:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803a35:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803a3c:	00 
  803a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  803a40:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a47:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4e:	8b 40 0c             	mov    0xc(%eax),%eax
  803a51:	89 04 24             	mov    %eax,(%esp)
  803a54:	e8 c9 03 00 00       	call   803e22 <_Z10nsipc_sendiPKvij>
}
  803a59:	c9                   	leave  
  803a5a:	c3                   	ret    

00803a5b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803a5b:	55                   	push   %ebp
  803a5c:	89 e5                	mov    %esp,%ebp
  803a5e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803a61:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803a68:	00 
  803a69:	8b 45 10             	mov    0x10(%ebp),%eax
  803a6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a77:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7a:	8b 40 0c             	mov    0xc(%eax),%eax
  803a7d:	89 04 24             	mov    %eax,(%esp)
  803a80:	e8 1d 03 00 00       	call   803da2 <_Z10nsipc_recviPvij>
}
  803a85:	c9                   	leave  
  803a86:	c3                   	ret    

00803a87 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803a87:	55                   	push   %ebp
  803a88:	89 e5                	mov    %esp,%ebp
  803a8a:	83 ec 28             	sub    $0x28,%esp
  803a8d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803a90:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803a93:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803a95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a98:	89 04 24             	mov    %eax,(%esp)
  803a9b:	e8 a7 de ff ff       	call   801947 <_Z14fd_find_unusedPP2Fd>
  803aa0:	89 c3                	mov    %eax,%ebx
  803aa2:	85 c0                	test   %eax,%eax
  803aa4:	78 21                	js     803ac7 <_ZL12alloc_sockfdi+0x40>
  803aa6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803aad:	00 
  803aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ab5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803abc:	e8 1f d3 ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  803ac1:	89 c3                	mov    %eax,%ebx
  803ac3:	85 c0                	test   %eax,%eax
  803ac5:	79 14                	jns    803adb <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803ac7:	89 34 24             	mov    %esi,(%esp)
  803aca:	e8 58 02 00 00       	call   803d27 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803acf:	89 d8                	mov    %ebx,%eax
  803ad1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803ad4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803ad7:	89 ec                	mov    %ebp,%esp
  803ad9:	5d                   	pop    %ebp
  803ada:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803adb:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803af0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803af3:	89 04 24             	mov    %eax,(%esp)
  803af6:	e8 e9 dd ff ff       	call   8018e4 <_Z6fd2numP2Fd>
  803afb:	89 c3                	mov    %eax,%ebx
  803afd:	eb d0                	jmp    803acf <_ZL12alloc_sockfdi+0x48>

00803aff <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803aff:	55                   	push   %ebp
  803b00:	89 e5                	mov    %esp,%ebp
  803b02:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803b05:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803b0c:	00 
  803b0d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803b10:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b14:	89 04 24             	mov    %eax,(%esp)
  803b17:	e8 75 dd ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  803b1c:	85 c0                	test   %eax,%eax
  803b1e:	78 15                	js     803b35 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803b23:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803b28:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  803b2e:	39 0a                	cmp    %ecx,(%edx)
  803b30:	75 03                	jne    803b35 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803b32:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803b35:	c9                   	leave  
  803b36:	c3                   	ret    

00803b37 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b37:	55                   	push   %ebp
  803b38:	89 e5                	mov    %esp,%ebp
  803b3a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b40:	e8 ba ff ff ff       	call   803aff <_ZL9fd2sockidi>
  803b45:	85 c0                	test   %eax,%eax
  803b47:	78 1f                	js     803b68 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803b49:	8b 55 10             	mov    0x10(%ebp),%edx
  803b4c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b53:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b57:	89 04 24             	mov    %eax,(%esp)
  803b5a:	e8 19 01 00 00       	call   803c78 <_Z12nsipc_acceptiP8sockaddrPj>
  803b5f:	85 c0                	test   %eax,%eax
  803b61:	78 05                	js     803b68 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803b63:	e8 1f ff ff ff       	call   803a87 <_ZL12alloc_sockfdi>
}
  803b68:	c9                   	leave  
  803b69:	c3                   	ret    

00803b6a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b6a:	55                   	push   %ebp
  803b6b:	89 e5                	mov    %esp,%ebp
  803b6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b70:	8b 45 08             	mov    0x8(%ebp),%eax
  803b73:	e8 87 ff ff ff       	call   803aff <_ZL9fd2sockidi>
  803b78:	85 c0                	test   %eax,%eax
  803b7a:	78 16                	js     803b92 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803b7c:	8b 55 10             	mov    0x10(%ebp),%edx
  803b7f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b83:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b86:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b8a:	89 04 24             	mov    %eax,(%esp)
  803b8d:	e8 34 01 00 00       	call   803cc6 <_Z10nsipc_bindiP8sockaddrj>
}
  803b92:	c9                   	leave  
  803b93:	c3                   	ret    

00803b94 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803b94:	55                   	push   %ebp
  803b95:	89 e5                	mov    %esp,%ebp
  803b97:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9d:	e8 5d ff ff ff       	call   803aff <_ZL9fd2sockidi>
  803ba2:	85 c0                	test   %eax,%eax
  803ba4:	78 0f                	js     803bb5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ba9:	89 54 24 04          	mov    %edx,0x4(%esp)
  803bad:	89 04 24             	mov    %eax,(%esp)
  803bb0:	e8 50 01 00 00       	call   803d05 <_Z14nsipc_shutdownii>
}
  803bb5:	c9                   	leave  
  803bb6:	c3                   	ret    

00803bb7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803bb7:	55                   	push   %ebp
  803bb8:	89 e5                	mov    %esp,%ebp
  803bba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc0:	e8 3a ff ff ff       	call   803aff <_ZL9fd2sockidi>
  803bc5:	85 c0                	test   %eax,%eax
  803bc7:	78 16                	js     803bdf <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803bc9:	8b 55 10             	mov    0x10(%ebp),%edx
  803bcc:	89 54 24 08          	mov    %edx,0x8(%esp)
  803bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bd3:	89 54 24 04          	mov    %edx,0x4(%esp)
  803bd7:	89 04 24             	mov    %eax,(%esp)
  803bda:	e8 62 01 00 00       	call   803d41 <_Z13nsipc_connectiPK8sockaddrj>
}
  803bdf:	c9                   	leave  
  803be0:	c3                   	ret    

00803be1 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803be1:	55                   	push   %ebp
  803be2:	89 e5                	mov    %esp,%ebp
  803be4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803be7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bea:	e8 10 ff ff ff       	call   803aff <_ZL9fd2sockidi>
  803bef:	85 c0                	test   %eax,%eax
  803bf1:	78 0f                	js     803c02 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bf6:	89 54 24 04          	mov    %edx,0x4(%esp)
  803bfa:	89 04 24             	mov    %eax,(%esp)
  803bfd:	e8 7e 01 00 00       	call   803d80 <_Z12nsipc_listenii>
}
  803c02:	c9                   	leave  
  803c03:	c3                   	ret    

00803c04 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803c04:	55                   	push   %ebp
  803c05:	89 e5                	mov    %esp,%ebp
  803c07:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803c0a:	8b 45 10             	mov    0x10(%ebp),%eax
  803c0d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c18:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1b:	89 04 24             	mov    %eax,(%esp)
  803c1e:	e8 72 02 00 00       	call   803e95 <_Z12nsipc_socketiii>
  803c23:	85 c0                	test   %eax,%eax
  803c25:	78 05                	js     803c2c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803c27:	e8 5b fe ff ff       	call   803a87 <_ZL12alloc_sockfdi>
}
  803c2c:	c9                   	leave  
  803c2d:	8d 76 00             	lea    0x0(%esi),%esi
  803c30:	c3                   	ret    
  803c31:	00 00                	add    %al,(%eax)
	...

00803c34 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803c34:	55                   	push   %ebp
  803c35:	89 e5                	mov    %esp,%ebp
  803c37:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803c3a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803c41:	00 
  803c42:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803c49:	00 
  803c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c4e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803c55:	e8 45 db ff ff       	call   80179f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803c5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803c61:	00 
  803c62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803c69:	00 
  803c6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c71:	e8 9a da ff ff       	call   801710 <_Z8ipc_recvPiPvS_>
}
  803c76:	c9                   	leave  
  803c77:	c3                   	ret    

00803c78 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c78:	55                   	push   %ebp
  803c79:	89 e5                	mov    %esp,%ebp
  803c7b:	53                   	push   %ebx
  803c7c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c82:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c87:	b8 01 00 00 00       	mov    $0x1,%eax
  803c8c:	e8 a3 ff ff ff       	call   803c34 <_ZL5nsipcj>
  803c91:	89 c3                	mov    %eax,%ebx
  803c93:	85 c0                	test   %eax,%eax
  803c95:	78 27                	js     803cbe <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803c97:	a1 10 70 80 00       	mov    0x807010,%eax
  803c9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ca0:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803ca7:	00 
  803ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cab:	89 04 24             	mov    %eax,(%esp)
  803cae:	e8 e9 cd ff ff       	call   800a9c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803cb3:	8b 15 10 70 80 00    	mov    0x807010,%edx
  803cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  803cbc:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803cbe:	89 d8                	mov    %ebx,%eax
  803cc0:	83 c4 14             	add    $0x14,%esp
  803cc3:	5b                   	pop    %ebx
  803cc4:	5d                   	pop    %ebp
  803cc5:	c3                   	ret    

00803cc6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803cc6:	55                   	push   %ebp
  803cc7:	89 e5                	mov    %esp,%ebp
  803cc9:	53                   	push   %ebx
  803cca:	83 ec 14             	sub    $0x14,%esp
  803ccd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd3:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803cd8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ce3:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803cea:	e8 ad cd ff ff       	call   800a9c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803cef:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803cf5:	b8 02 00 00 00       	mov    $0x2,%eax
  803cfa:	e8 35 ff ff ff       	call   803c34 <_ZL5nsipcj>
}
  803cff:	83 c4 14             	add    $0x14,%esp
  803d02:	5b                   	pop    %ebx
  803d03:	5d                   	pop    %ebp
  803d04:	c3                   	ret    

00803d05 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803d05:	55                   	push   %ebp
  803d06:	89 e5                	mov    %esp,%ebp
  803d08:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d16:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  803d1b:	b8 03 00 00 00       	mov    $0x3,%eax
  803d20:	e8 0f ff ff ff       	call   803c34 <_ZL5nsipcj>
}
  803d25:	c9                   	leave  
  803d26:	c3                   	ret    

00803d27 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803d27:	55                   	push   %ebp
  803d28:	89 e5                	mov    %esp,%ebp
  803d2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d30:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803d35:	b8 04 00 00 00       	mov    $0x4,%eax
  803d3a:	e8 f5 fe ff ff       	call   803c34 <_ZL5nsipcj>
}
  803d3f:	c9                   	leave  
  803d40:	c3                   	ret    

00803d41 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d41:	55                   	push   %ebp
  803d42:	89 e5                	mov    %esp,%ebp
  803d44:	53                   	push   %ebx
  803d45:	83 ec 14             	sub    $0x14,%esp
  803d48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803d53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d5e:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803d65:	e8 32 cd ff ff       	call   800a9c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803d6a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803d70:	b8 05 00 00 00       	mov    $0x5,%eax
  803d75:	e8 ba fe ff ff       	call   803c34 <_ZL5nsipcj>
}
  803d7a:	83 c4 14             	add    $0x14,%esp
  803d7d:	5b                   	pop    %ebx
  803d7e:	5d                   	pop    %ebp
  803d7f:	c3                   	ret    

00803d80 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803d80:	55                   	push   %ebp
  803d81:	89 e5                	mov    %esp,%ebp
  803d83:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803d86:	8b 45 08             	mov    0x8(%ebp),%eax
  803d89:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  803d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d91:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803d96:	b8 06 00 00 00       	mov    $0x6,%eax
  803d9b:	e8 94 fe ff ff       	call   803c34 <_ZL5nsipcj>
}
  803da0:	c9                   	leave  
  803da1:	c3                   	ret    

00803da2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803da2:	55                   	push   %ebp
  803da3:	89 e5                	mov    %esp,%ebp
  803da5:	56                   	push   %esi
  803da6:	53                   	push   %ebx
  803da7:	83 ec 10             	sub    $0x10,%esp
  803daa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803dad:	8b 45 08             	mov    0x8(%ebp),%eax
  803db0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803db5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  803dbb:	8b 45 14             	mov    0x14(%ebp),%eax
  803dbe:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803dc3:	b8 07 00 00 00       	mov    $0x7,%eax
  803dc8:	e8 67 fe ff ff       	call   803c34 <_ZL5nsipcj>
  803dcd:	89 c3                	mov    %eax,%ebx
  803dcf:	85 c0                	test   %eax,%eax
  803dd1:	78 46                	js     803e19 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803dd3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803dd8:	7f 04                	jg     803dde <_Z10nsipc_recviPvij+0x3c>
  803dda:	39 f0                	cmp    %esi,%eax
  803ddc:	7e 24                	jle    803e02 <_Z10nsipc_recviPvij+0x60>
  803dde:	c7 44 24 0c 1f 4f 80 	movl   $0x804f1f,0xc(%esp)
  803de5:	00 
  803de6:	c7 44 24 08 8b 48 80 	movl   $0x80488b,0x8(%esp)
  803ded:	00 
  803dee:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803df5:	00 
  803df6:	c7 04 24 34 4f 80 00 	movl   $0x804f34,(%esp)
  803dfd:	e8 c6 c3 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803e02:	89 44 24 08          	mov    %eax,0x8(%esp)
  803e06:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803e0d:	00 
  803e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e11:	89 04 24             	mov    %eax,(%esp)
  803e14:	e8 83 cc ff ff       	call   800a9c <memmove>
	}

	return r;
}
  803e19:	89 d8                	mov    %ebx,%eax
  803e1b:	83 c4 10             	add    $0x10,%esp
  803e1e:	5b                   	pop    %ebx
  803e1f:	5e                   	pop    %esi
  803e20:	5d                   	pop    %ebp
  803e21:	c3                   	ret    

00803e22 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803e22:	55                   	push   %ebp
  803e23:	89 e5                	mov    %esp,%ebp
  803e25:	53                   	push   %ebx
  803e26:	83 ec 14             	sub    $0x14,%esp
  803e29:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803e34:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803e3a:	7e 24                	jle    803e60 <_Z10nsipc_sendiPKvij+0x3e>
  803e3c:	c7 44 24 0c 40 4f 80 	movl   $0x804f40,0xc(%esp)
  803e43:	00 
  803e44:	c7 44 24 08 8b 48 80 	movl   $0x80488b,0x8(%esp)
  803e4b:	00 
  803e4c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803e53:	00 
  803e54:	c7 04 24 34 4f 80 00 	movl   $0x804f34,(%esp)
  803e5b:	e8 68 c3 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803e60:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e67:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e6b:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803e72:	e8 25 cc ff ff       	call   800a9c <memmove>
	nsipcbuf.send.req_size = size;
  803e77:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  803e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  803e80:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803e85:	b8 08 00 00 00       	mov    $0x8,%eax
  803e8a:	e8 a5 fd ff ff       	call   803c34 <_ZL5nsipcj>
}
  803e8f:	83 c4 14             	add    $0x14,%esp
  803e92:	5b                   	pop    %ebx
  803e93:	5d                   	pop    %ebp
  803e94:	c3                   	ret    

00803e95 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e95:	55                   	push   %ebp
  803e96:	89 e5                	mov    %esp,%ebp
  803e98:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ea6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  803eab:	8b 45 10             	mov    0x10(%ebp),%eax
  803eae:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803eb3:	b8 09 00 00 00       	mov    $0x9,%eax
  803eb8:	e8 77 fd ff ff       	call   803c34 <_ZL5nsipcj>
}
  803ebd:	c9                   	leave  
  803ebe:	c3                   	ret    
	...

00803ec0 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803ec0:	55                   	push   %ebp
  803ec1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ec8:	5d                   	pop    %ebp
  803ec9:	c3                   	ret    

00803eca <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803eca:	55                   	push   %ebp
  803ecb:	89 e5                	mov    %esp,%ebp
  803ecd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803ed0:	c7 44 24 04 4c 4f 80 	movl   $0x804f4c,0x4(%esp)
  803ed7:	00 
  803ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803edb:	89 04 24             	mov    %eax,(%esp)
  803ede:	e8 17 ca ff ff       	call   8008fa <_Z6strcpyPcPKc>
	return 0;
}
  803ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee8:	c9                   	leave  
  803ee9:	c3                   	ret    

00803eea <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803eea:	55                   	push   %ebp
  803eeb:	89 e5                	mov    %esp,%ebp
  803eed:	57                   	push   %edi
  803eee:	56                   	push   %esi
  803eef:	53                   	push   %ebx
  803ef0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ef6:	bb 00 00 00 00       	mov    $0x0,%ebx
  803efb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803eff:	74 3e                	je     803f3f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803f01:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803f07:	8b 75 10             	mov    0x10(%ebp),%esi
  803f0a:	29 de                	sub    %ebx,%esi
  803f0c:	83 fe 7f             	cmp    $0x7f,%esi
  803f0f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803f14:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803f17:	89 74 24 08          	mov    %esi,0x8(%esp)
  803f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f1e:	01 d8                	add    %ebx,%eax
  803f20:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f24:	89 3c 24             	mov    %edi,(%esp)
  803f27:	e8 70 cb ff ff       	call   800a9c <memmove>
		sys_cputs(buf, m);
  803f2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803f30:	89 3c 24             	mov    %edi,(%esp)
  803f33:	e8 7c cd ff ff       	call   800cb4 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f38:	01 f3                	add    %esi,%ebx
  803f3a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803f3d:	77 c8                	ja     803f07 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803f3f:	89 d8                	mov    %ebx,%eax
  803f41:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803f47:	5b                   	pop    %ebx
  803f48:	5e                   	pop    %esi
  803f49:	5f                   	pop    %edi
  803f4a:	5d                   	pop    %ebp
  803f4b:	c3                   	ret    

00803f4c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f4c:	55                   	push   %ebp
  803f4d:	89 e5                	mov    %esp,%ebp
  803f4f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803f52:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803f57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803f5b:	75 07                	jne    803f64 <_ZL12devcons_readP2FdPvj+0x18>
  803f5d:	eb 2a                	jmp    803f89 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803f5f:	e8 48 ce ff ff       	call   800dac <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f64:	e8 7e cd ff ff       	call   800ce7 <_Z9sys_cgetcv>
  803f69:	85 c0                	test   %eax,%eax
  803f6b:	74 f2                	je     803f5f <_ZL12devcons_readP2FdPvj+0x13>
  803f6d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803f6f:	85 c0                	test   %eax,%eax
  803f71:	78 16                	js     803f89 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803f73:	83 f8 04             	cmp    $0x4,%eax
  803f76:	74 0c                	je     803f84 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f7b:	88 10                	mov    %dl,(%eax)
	return 1;
  803f7d:	b8 01 00 00 00       	mov    $0x1,%eax
  803f82:	eb 05                	jmp    803f89 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803f84:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803f89:	c9                   	leave  
  803f8a:	c3                   	ret    

00803f8b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803f8b:	55                   	push   %ebp
  803f8c:	89 e5                	mov    %esp,%ebp
  803f8e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803f91:	8b 45 08             	mov    0x8(%ebp),%eax
  803f94:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f97:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803f9e:	00 
  803f9f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803fa2:	89 04 24             	mov    %eax,(%esp)
  803fa5:	e8 0a cd ff ff       	call   800cb4 <_Z9sys_cputsPKcj>
}
  803faa:	c9                   	leave  
  803fab:	c3                   	ret    

00803fac <_Z7getcharv>:

int
getchar(void)
{
  803fac:	55                   	push   %ebp
  803fad:	89 e5                	mov    %esp,%ebp
  803faf:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803fb2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803fb9:	00 
  803fba:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803fbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803fc8:	e8 71 dc ff ff       	call   801c3e <_Z4readiPvj>
	if (r < 0)
  803fcd:	85 c0                	test   %eax,%eax
  803fcf:	78 0f                	js     803fe0 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803fd1:	85 c0                	test   %eax,%eax
  803fd3:	7e 06                	jle    803fdb <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803fd5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803fd9:	eb 05                	jmp    803fe0 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803fdb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803fe0:	c9                   	leave  
  803fe1:	c3                   	ret    

00803fe2 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803fe2:	55                   	push   %ebp
  803fe3:	89 e5                	mov    %esp,%ebp
  803fe5:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803fe8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803fef:	00 
  803ff0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffa:	89 04 24             	mov    %eax,(%esp)
  803ffd:	e8 8f d8 ff ff       	call   801891 <_Z9fd_lookupiPP2Fdb>
  804002:	85 c0                	test   %eax,%eax
  804004:	78 11                	js     804017 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  804006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804009:	8b 15 58 50 80 00    	mov    0x805058,%edx
  80400f:	39 10                	cmp    %edx,(%eax)
  804011:	0f 94 c0             	sete   %al
  804014:	0f b6 c0             	movzbl %al,%eax
}
  804017:	c9                   	leave  
  804018:	c3                   	ret    

00804019 <_Z8openconsv>:

int
opencons(void)
{
  804019:	55                   	push   %ebp
  80401a:	89 e5                	mov    %esp,%ebp
  80401c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80401f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804022:	89 04 24             	mov    %eax,(%esp)
  804025:	e8 1d d9 ff ff       	call   801947 <_Z14fd_find_unusedPP2Fd>
  80402a:	85 c0                	test   %eax,%eax
  80402c:	78 3c                	js     80406a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80402e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804035:	00 
  804036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80403d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804044:	e8 97 cd ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  804049:	85 c0                	test   %eax,%eax
  80404b:	78 1d                	js     80406a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80404d:	8b 15 58 50 80 00    	mov    0x805058,%edx
  804053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804056:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  804058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80405b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  804062:	89 04 24             	mov    %eax,(%esp)
  804065:	e8 7a d8 ff ff       	call   8018e4 <_Z6fd2numP2Fd>
}
  80406a:	c9                   	leave  
  80406b:	c3                   	ret    
  80406c:	00 00                	add    %al,(%eax)
	...

00804070 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  804070:	55                   	push   %ebp
  804071:	89 e5                	mov    %esp,%ebp
  804073:	56                   	push   %esi
  804074:	53                   	push   %ebx
  804075:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804078:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  80407d:	8b 04 9d 00 80 80 00 	mov    0x808000(,%ebx,4),%eax
  804084:	85 c0                	test   %eax,%eax
  804086:	74 08                	je     804090 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  804088:	8d 55 08             	lea    0x8(%ebp),%edx
  80408b:	89 14 24             	mov    %edx,(%esp)
  80408e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804090:	83 eb 01             	sub    $0x1,%ebx
  804093:	83 fb ff             	cmp    $0xffffffff,%ebx
  804096:	75 e5                	jne    80407d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  804098:	8b 5d 38             	mov    0x38(%ebp),%ebx
  80409b:	8b 75 08             	mov    0x8(%ebp),%esi
  80409e:	e8 d5 cc ff ff       	call   800d78 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  8040a3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8040a7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8040ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040af:	c7 44 24 08 58 4f 80 	movl   $0x804f58,0x8(%esp)
  8040b6:	00 
  8040b7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8040be:	00 
  8040bf:	c7 04 24 dc 4f 80 00 	movl   $0x804fdc,(%esp)
  8040c6:	e8 fd c0 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>

008040cb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  8040cb:	55                   	push   %ebp
  8040cc:	89 e5                	mov    %esp,%ebp
  8040ce:	56                   	push   %esi
  8040cf:	53                   	push   %ebx
  8040d0:	83 ec 10             	sub    $0x10,%esp
  8040d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  8040d6:	e8 9d cc ff ff       	call   800d78 <_Z12sys_getenvidv>
  8040db:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  8040dd:	a1 00 60 80 00       	mov    0x806000,%eax
  8040e2:	8b 40 5c             	mov    0x5c(%eax),%eax
  8040e5:	85 c0                	test   %eax,%eax
  8040e7:	75 4c                	jne    804135 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  8040e9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8040f0:	00 
  8040f1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8040f8:	ee 
  8040f9:	89 34 24             	mov    %esi,(%esp)
  8040fc:	e8 df cc ff ff       	call   800de0 <_Z14sys_page_allociPvi>
  804101:	85 c0                	test   %eax,%eax
  804103:	74 20                	je     804125 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  804105:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804109:	c7 44 24 08 90 4f 80 	movl   $0x804f90,0x8(%esp)
  804110:	00 
  804111:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  804118:	00 
  804119:	c7 04 24 dc 4f 80 00 	movl   $0x804fdc,(%esp)
  804120:	e8 a3 c0 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  804125:	c7 44 24 04 70 40 80 	movl   $0x804070,0x4(%esp)
  80412c:	00 
  80412d:	89 34 24             	mov    %esi,(%esp)
  804130:	e8 e0 ce ff ff       	call   801015 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804135:	a1 00 80 80 00       	mov    0x808000,%eax
  80413a:	39 d8                	cmp    %ebx,%eax
  80413c:	74 1a                	je     804158 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  80413e:	85 c0                	test   %eax,%eax
  804140:	74 20                	je     804162 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804142:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804147:	8b 14 85 00 80 80 00 	mov    0x808000(,%eax,4),%edx
  80414e:	39 da                	cmp    %ebx,%edx
  804150:	74 15                	je     804167 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804152:	85 d2                	test   %edx,%edx
  804154:	75 1f                	jne    804175 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804156:	eb 0f                	jmp    804167 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804158:	b8 00 00 00 00       	mov    $0x0,%eax
  80415d:	8d 76 00             	lea    0x0(%esi),%esi
  804160:	eb 05                	jmp    804167 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804162:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804167:	89 1c 85 00 80 80 00 	mov    %ebx,0x808000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80416e:	83 c4 10             	add    $0x10,%esp
  804171:	5b                   	pop    %ebx
  804172:	5e                   	pop    %esi
  804173:	5d                   	pop    %ebp
  804174:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804175:	83 c0 01             	add    $0x1,%eax
  804178:	83 f8 08             	cmp    $0x8,%eax
  80417b:	75 ca                	jne    804147 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80417d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804181:	c7 44 24 08 b4 4f 80 	movl   $0x804fb4,0x8(%esp)
  804188:	00 
  804189:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804190:	00 
  804191:	c7 04 24 dc 4f 80 00 	movl   $0x804fdc,(%esp)
  804198:	e8 2b c0 ff ff       	call   8001c8 <_Z6_panicPKciS0_z>
  80419d:	00 00                	add    %al,(%eax)
	...

008041a0 <resume>:
  8041a0:	83 c4 04             	add    $0x4,%esp
  8041a3:	5c                   	pop    %esp
  8041a4:	83 c4 08             	add    $0x8,%esp
  8041a7:	8b 44 24 28          	mov    0x28(%esp),%eax
  8041ab:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  8041af:	83 eb 04             	sub    $0x4,%ebx
  8041b2:	89 03                	mov    %eax,(%ebx)
  8041b4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
  8041b8:	61                   	popa   
  8041b9:	9d                   	popf   
  8041ba:	5c                   	pop    %esp
  8041bb:	c3                   	ret    

008041bc <spin>:
  8041bc:	eb fe                	jmp    8041bc <spin>
	...

008041c0 <__udivdi3>:
  8041c0:	55                   	push   %ebp
  8041c1:	89 e5                	mov    %esp,%ebp
  8041c3:	57                   	push   %edi
  8041c4:	56                   	push   %esi
  8041c5:	83 ec 20             	sub    $0x20,%esp
  8041c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8041cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8041ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8041d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8041d4:	85 c0                	test   %eax,%eax
  8041d6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8041d9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8041dc:	75 3a                	jne    804218 <__udivdi3+0x58>
  8041de:	39 f9                	cmp    %edi,%ecx
  8041e0:	77 66                	ja     804248 <__udivdi3+0x88>
  8041e2:	85 c9                	test   %ecx,%ecx
  8041e4:	75 0b                	jne    8041f1 <__udivdi3+0x31>
  8041e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8041eb:	31 d2                	xor    %edx,%edx
  8041ed:	f7 f1                	div    %ecx
  8041ef:	89 c1                	mov    %eax,%ecx
  8041f1:	89 f8                	mov    %edi,%eax
  8041f3:	31 d2                	xor    %edx,%edx
  8041f5:	f7 f1                	div    %ecx
  8041f7:	89 c7                	mov    %eax,%edi
  8041f9:	89 f0                	mov    %esi,%eax
  8041fb:	f7 f1                	div    %ecx
  8041fd:	89 fa                	mov    %edi,%edx
  8041ff:	89 c6                	mov    %eax,%esi
  804201:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804204:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80420a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80420d:	83 c4 20             	add    $0x20,%esp
  804210:	5e                   	pop    %esi
  804211:	5f                   	pop    %edi
  804212:	5d                   	pop    %ebp
  804213:	c3                   	ret    
  804214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804218:	31 d2                	xor    %edx,%edx
  80421a:	31 f6                	xor    %esi,%esi
  80421c:	39 f8                	cmp    %edi,%eax
  80421e:	77 e1                	ja     804201 <__udivdi3+0x41>
  804220:	0f bd d0             	bsr    %eax,%edx
  804223:	83 f2 1f             	xor    $0x1f,%edx
  804226:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804229:	75 2d                	jne    804258 <__udivdi3+0x98>
  80422b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80422e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804231:	76 06                	jbe    804239 <__udivdi3+0x79>
  804233:	39 f8                	cmp    %edi,%eax
  804235:	89 f2                	mov    %esi,%edx
  804237:	73 c8                	jae    804201 <__udivdi3+0x41>
  804239:	31 d2                	xor    %edx,%edx
  80423b:	be 01 00 00 00       	mov    $0x1,%esi
  804240:	eb bf                	jmp    804201 <__udivdi3+0x41>
  804242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804248:	89 f0                	mov    %esi,%eax
  80424a:	89 fa                	mov    %edi,%edx
  80424c:	f7 f1                	div    %ecx
  80424e:	31 d2                	xor    %edx,%edx
  804250:	89 c6                	mov    %eax,%esi
  804252:	eb ad                	jmp    804201 <__udivdi3+0x41>
  804254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804258:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80425c:	89 c2                	mov    %eax,%edx
  80425e:	b8 20 00 00 00       	mov    $0x20,%eax
  804263:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804266:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804269:	d3 e2                	shl    %cl,%edx
  80426b:	89 c1                	mov    %eax,%ecx
  80426d:	d3 ee                	shr    %cl,%esi
  80426f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804273:	09 d6                	or     %edx,%esi
  804275:	89 fa                	mov    %edi,%edx
  804277:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80427a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80427d:	d3 e6                	shl    %cl,%esi
  80427f:	89 c1                	mov    %eax,%ecx
  804281:	d3 ea                	shr    %cl,%edx
  804283:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804287:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80428a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80428d:	d3 e7                	shl    %cl,%edi
  80428f:	89 c1                	mov    %eax,%ecx
  804291:	d3 ee                	shr    %cl,%esi
  804293:	09 fe                	or     %edi,%esi
  804295:	89 f0                	mov    %esi,%eax
  804297:	f7 75 e4             	divl   -0x1c(%ebp)
  80429a:	89 d7                	mov    %edx,%edi
  80429c:	89 c6                	mov    %eax,%esi
  80429e:	f7 65 f0             	mull   -0x10(%ebp)
  8042a1:	39 d7                	cmp    %edx,%edi
  8042a3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8042a6:	72 12                	jb     8042ba <__udivdi3+0xfa>
  8042a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042ab:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8042af:	d3 e2                	shl    %cl,%edx
  8042b1:	39 c2                	cmp    %eax,%edx
  8042b3:	73 08                	jae    8042bd <__udivdi3+0xfd>
  8042b5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8042b8:	75 03                	jne    8042bd <__udivdi3+0xfd>
  8042ba:	83 ee 01             	sub    $0x1,%esi
  8042bd:	31 d2                	xor    %edx,%edx
  8042bf:	e9 3d ff ff ff       	jmp    804201 <__udivdi3+0x41>
	...

008042d0 <__umoddi3>:
  8042d0:	55                   	push   %ebp
  8042d1:	89 e5                	mov    %esp,%ebp
  8042d3:	57                   	push   %edi
  8042d4:	56                   	push   %esi
  8042d5:	83 ec 20             	sub    $0x20,%esp
  8042d8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8042db:	8b 45 08             	mov    0x8(%ebp),%eax
  8042de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8042e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8042e4:	85 ff                	test   %edi,%edi
  8042e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8042e9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8042ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8042ef:	89 f2                	mov    %esi,%edx
  8042f1:	75 15                	jne    804308 <__umoddi3+0x38>
  8042f3:	39 f1                	cmp    %esi,%ecx
  8042f5:	76 41                	jbe    804338 <__umoddi3+0x68>
  8042f7:	f7 f1                	div    %ecx
  8042f9:	89 d0                	mov    %edx,%eax
  8042fb:	31 d2                	xor    %edx,%edx
  8042fd:	83 c4 20             	add    $0x20,%esp
  804300:	5e                   	pop    %esi
  804301:	5f                   	pop    %edi
  804302:	5d                   	pop    %ebp
  804303:	c3                   	ret    
  804304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804308:	39 f7                	cmp    %esi,%edi
  80430a:	77 4c                	ja     804358 <__umoddi3+0x88>
  80430c:	0f bd c7             	bsr    %edi,%eax
  80430f:	83 f0 1f             	xor    $0x1f,%eax
  804312:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804315:	75 51                	jne    804368 <__umoddi3+0x98>
  804317:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80431a:	0f 87 e8 00 00 00    	ja     804408 <__umoddi3+0x138>
  804320:	89 f2                	mov    %esi,%edx
  804322:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804325:	29 ce                	sub    %ecx,%esi
  804327:	19 fa                	sbb    %edi,%edx
  804329:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80432c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80432f:	83 c4 20             	add    $0x20,%esp
  804332:	5e                   	pop    %esi
  804333:	5f                   	pop    %edi
  804334:	5d                   	pop    %ebp
  804335:	c3                   	ret    
  804336:	66 90                	xchg   %ax,%ax
  804338:	85 c9                	test   %ecx,%ecx
  80433a:	75 0b                	jne    804347 <__umoddi3+0x77>
  80433c:	b8 01 00 00 00       	mov    $0x1,%eax
  804341:	31 d2                	xor    %edx,%edx
  804343:	f7 f1                	div    %ecx
  804345:	89 c1                	mov    %eax,%ecx
  804347:	89 f0                	mov    %esi,%eax
  804349:	31 d2                	xor    %edx,%edx
  80434b:	f7 f1                	div    %ecx
  80434d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804350:	eb a5                	jmp    8042f7 <__umoddi3+0x27>
  804352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804358:	89 f2                	mov    %esi,%edx
  80435a:	83 c4 20             	add    $0x20,%esp
  80435d:	5e                   	pop    %esi
  80435e:	5f                   	pop    %edi
  80435f:	5d                   	pop    %ebp
  804360:	c3                   	ret    
  804361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804368:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80436c:	89 f2                	mov    %esi,%edx
  80436e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804371:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804378:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80437b:	d3 e7                	shl    %cl,%edi
  80437d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804380:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804384:	d3 e8                	shr    %cl,%eax
  804386:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80438a:	09 f8                	or     %edi,%eax
  80438c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80438f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804392:	d3 e0                	shl    %cl,%eax
  804394:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804398:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80439b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80439e:	d3 ea                	shr    %cl,%edx
  8043a0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043a4:	d3 e6                	shl    %cl,%esi
  8043a6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8043aa:	d3 e8                	shr    %cl,%eax
  8043ac:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043b0:	09 f0                	or     %esi,%eax
  8043b2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8043b5:	f7 75 e4             	divl   -0x1c(%ebp)
  8043b8:	d3 e6                	shl    %cl,%esi
  8043ba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8043bd:	89 d6                	mov    %edx,%esi
  8043bf:	f7 65 f4             	mull   -0xc(%ebp)
  8043c2:	89 d7                	mov    %edx,%edi
  8043c4:	89 c2                	mov    %eax,%edx
  8043c6:	39 fe                	cmp    %edi,%esi
  8043c8:	89 f9                	mov    %edi,%ecx
  8043ca:	72 30                	jb     8043fc <__umoddi3+0x12c>
  8043cc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8043cf:	72 27                	jb     8043f8 <__umoddi3+0x128>
  8043d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043d4:	29 d0                	sub    %edx,%eax
  8043d6:	19 ce                	sbb    %ecx,%esi
  8043d8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043dc:	89 f2                	mov    %esi,%edx
  8043de:	d3 e8                	shr    %cl,%eax
  8043e0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8043e4:	d3 e2                	shl    %cl,%edx
  8043e6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043ea:	09 d0                	or     %edx,%eax
  8043ec:	89 f2                	mov    %esi,%edx
  8043ee:	d3 ea                	shr    %cl,%edx
  8043f0:	83 c4 20             	add    $0x20,%esp
  8043f3:	5e                   	pop    %esi
  8043f4:	5f                   	pop    %edi
  8043f5:	5d                   	pop    %ebp
  8043f6:	c3                   	ret    
  8043f7:	90                   	nop
  8043f8:	39 fe                	cmp    %edi,%esi
  8043fa:	75 d5                	jne    8043d1 <__umoddi3+0x101>
  8043fc:	89 f9                	mov    %edi,%ecx
  8043fe:	89 c2                	mov    %eax,%edx
  804400:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804403:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804406:	eb c9                	jmp    8043d1 <__umoddi3+0x101>
  804408:	39 f7                	cmp    %esi,%edi
  80440a:	0f 82 10 ff ff ff    	jb     804320 <__umoddi3+0x50>
  804410:	e9 17 ff ff ff       	jmp    80432c <__umoddi3+0x5c>
