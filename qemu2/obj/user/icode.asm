
obj/user/icode:     file format elf32-i386


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
  80002c:	e8 2b 01 00 00       	call   80015c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z5umainiPPc>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003f:	c7 05 00 60 80 00 a0 	movl   $0x8047a0,0x806000
  800046:	47 80 00 

	cprintf("icode startup\n");
  800049:	c7 04 24 a6 47 80 00 	movl   $0x8047a6,(%esp)
  800050:	e8 a9 02 00 00       	call   8002fe <_Z7cprintfPKcz>

	cprintf("icode: open /motd\n");
  800055:	c7 04 24 b5 47 80 00 	movl   $0x8047b5,(%esp)
  80005c:	e8 9d 02 00 00       	call   8002fe <_Z7cprintfPKcz>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800061:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800068:	00 
  800069:	c7 04 24 c8 47 80 00 	movl   $0x8047c8,(%esp)
  800070:	e8 c9 2a 00 00       	call   802b3e <_Z4openPKci>
  800075:	89 c6                	mov    %eax,%esi
  800077:	85 c0                	test   %eax,%eax
  800079:	79 20                	jns    80009b <_Z5umainiPPc+0x67>
		panic("icode: open /motd: %e", fd);
  80007b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007f:	c7 44 24 08 ce 47 80 	movl   $0x8047ce,0x8(%esp)
  800086:	00 
  800087:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008e:	00 
  80008f:	c7 04 24 e4 47 80 00 	movl   $0x8047e4,(%esp)
  800096:	e8 45 01 00 00       	call   8001e0 <_Z6_panicPKciS0_z>

	cprintf("icode: read /motd\n");
  80009b:	c7 04 24 f1 47 80 00 	movl   $0x8047f1,(%esp)
  8000a2:	e8 57 02 00 00       	call   8002fe <_Z7cprintfPKcz>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a7:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ad:	eb 0c                	jmp    8000bb <_Z5umainiPPc+0x87>
		sys_cputs(buf, n);
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	89 1c 24             	mov    %ebx,(%esp)
  8000b6:	e8 19 0c 00 00       	call   800cd4 <_Z9sys_cputsPKcj>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000bb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c2:	00 
  8000c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c7:	89 34 24             	mov    %esi,(%esp)
  8000ca:	e8 df 1d 00 00       	call   801eae <_Z4readiPvj>
  8000cf:	85 c0                	test   %eax,%eax
  8000d1:	7f dc                	jg     8000af <_Z5umainiPPc+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d3:	c7 04 24 04 48 80 00 	movl   $0x804804,(%esp)
  8000da:	e8 1f 02 00 00       	call   8002fe <_Z7cprintfPKcz>
	close(fd);
  8000df:	89 34 24             	mov    %esi,(%esp)
  8000e2:	e8 1e 1c 00 00       	call   801d05 <_Z5closei>

	cprintf("icode: spawn /init\n");
  8000e7:	c7 04 24 18 48 80 00 	movl   $0x804818,(%esp)
  8000ee:	e8 0b 02 00 00       	call   8002fe <_Z7cprintfPKcz>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000fa:	00 
  8000fb:	c7 44 24 0c 2c 48 80 	movl   $0x80482c,0xc(%esp)
  800102:	00 
  800103:	c7 44 24 08 35 48 80 	movl   $0x804835,0x8(%esp)
  80010a:	00 
  80010b:	c7 44 24 04 3f 48 80 	movl   $0x80483f,0x4(%esp)
  800112:	00 
  800113:	c7 04 24 3e 48 80 00 	movl   $0x80483e,(%esp)
  80011a:	e8 42 19 00 00       	call   801a61 <_Z6spawnlPKcS0_z>
  80011f:	85 c0                	test   %eax,%eax
  800121:	79 20                	jns    800143 <_Z5umainiPPc+0x10f>
		panic("icode: spawn /init: %e", r);
  800123:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800127:	c7 44 24 08 44 48 80 	movl   $0x804844,0x8(%esp)
  80012e:	00 
  80012f:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800136:	00 
  800137:	c7 04 24 e4 47 80 00 	movl   $0x8047e4,(%esp)
  80013e:	e8 9d 00 00 00       	call   8001e0 <_Z6_panicPKciS0_z>

	cprintf("icode: exiting\n");
  800143:	c7 04 24 5b 48 80 00 	movl   $0x80485b,(%esp)
  80014a:	e8 af 01 00 00       	call   8002fe <_Z7cprintfPKcz>
}
  80014f:	81 c4 30 02 00 00    	add    $0x230,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    
  800159:	00 00                	add    %al,(%eax)
	...

0080015c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	57                   	push   %edi
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	83 ec 1c             	sub    $0x1c,%esp
  800165:	8b 7d 08             	mov    0x8(%ebp),%edi
  800168:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  80016b:	e8 28 0c 00 00       	call   800d98 <_Z12sys_getenvidv>
  800170:	25 ff 03 00 00       	and    $0x3ff,%eax
  800175:	6b c0 78             	imul   $0x78,%eax,%eax
  800178:	05 00 00 00 ef       	add    $0xef000000,%eax
  80017d:	a3 00 70 80 00       	mov    %eax,0x807000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800182:	85 ff                	test   %edi,%edi
  800184:	7e 07                	jle    80018d <libmain+0x31>
		binaryname = argv[0];
  800186:	8b 06                	mov    (%esi),%eax
  800188:	a3 00 60 80 00       	mov    %eax,0x806000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80018d:	b8 f5 53 80 00       	mov    $0x8053f5,%eax
  800192:	3d f5 53 80 00       	cmp    $0x8053f5,%eax
  800197:	76 0f                	jbe    8001a8 <libmain+0x4c>
  800199:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80019b:	83 eb 04             	sub    $0x4,%ebx
  80019e:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8001a0:	81 fb f5 53 80 00    	cmp    $0x8053f5,%ebx
  8001a6:	77 f3                	ja     80019b <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  8001a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001ac:	89 3c 24             	mov    %edi,(%esp)
  8001af:	e8 80 fe ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  8001b4:	e8 0b 00 00 00       	call   8001c4 <_Z4exitv>
}
  8001b9:	83 c4 1c             	add    $0x1c,%esp
  8001bc:	5b                   	pop    %ebx
  8001bd:	5e                   	pop    %esi
  8001be:	5f                   	pop    %edi
  8001bf:	5d                   	pop    %ebp
  8001c0:	c3                   	ret    
  8001c1:	00 00                	add    %al,(%eax)
	...

008001c4 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001ca:	e8 6f 1b 00 00       	call   801d3e <_Z9close_allv>
	sys_env_destroy(0);
  8001cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001d6:	e8 60 0b 00 00       	call   800d3b <_Z15sys_env_destroyi>
}
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    
  8001dd:	00 00                	add    %al,(%eax)
	...

008001e0 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001e8:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  8001eb:	a1 04 70 80 00       	mov    0x807004,%eax
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	74 10                	je     800204 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  8001f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f8:	c7 04 24 75 48 80 00 	movl   $0x804875,(%esp)
  8001ff:	e8 fa 00 00 00       	call   8002fe <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  800204:	8b 1d 00 60 80 00    	mov    0x806000,%ebx
  80020a:	e8 89 0b 00 00       	call   800d98 <_Z12sys_getenvidv>
  80020f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800212:	89 54 24 10          	mov    %edx,0x10(%esp)
  800216:	8b 55 08             	mov    0x8(%ebp),%edx
  800219:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80021d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800221:	89 44 24 04          	mov    %eax,0x4(%esp)
  800225:	c7 04 24 7c 48 80 00 	movl   $0x80487c,(%esp)
  80022c:	e8 cd 00 00 00       	call   8002fe <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  800231:	89 74 24 04          	mov    %esi,0x4(%esp)
  800235:	8b 45 10             	mov    0x10(%ebp),%eax
  800238:	89 04 24             	mov    %eax,(%esp)
  80023b:	e8 5d 00 00 00       	call   80029d <_Z8vcprintfPKcPc>
	cprintf("\n");
  800240:	c7 04 24 97 52 80 00 	movl   $0x805297,(%esp)
  800247:	e8 b2 00 00 00       	call   8002fe <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80024c:	cc                   	int3   
  80024d:	eb fd                	jmp    80024c <_Z6_panicPKciS0_z+0x6c>
	...

00800250 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 18             	sub    $0x18,%esp
  800256:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800259:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80025c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  80025f:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800261:	8b 03                	mov    (%ebx),%eax
  800263:	8b 55 08             	mov    0x8(%ebp),%edx
  800266:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80026a:	83 c0 01             	add    $0x1,%eax
  80026d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80026f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800274:	75 19                	jne    80028f <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  800276:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80027d:	00 
  80027e:	8d 43 08             	lea    0x8(%ebx),%eax
  800281:	89 04 24             	mov    %eax,(%esp)
  800284:	e8 4b 0a 00 00       	call   800cd4 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800289:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80028f:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800293:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800296:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800299:	89 ec                	mov    %ebp,%esp
  80029b:	5d                   	pop    %ebp
  80029c:	c3                   	ret    

0080029d <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ad:	00 00 00 
	b.cnt = 0;
  8002b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b7:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8002ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d2:	c7 04 24 50 02 80 00 	movl   $0x800250,(%esp)
  8002d9:	e8 a9 01 00 00       	call   800487 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  8002de:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	e8 de 09 00 00       	call   800cd4 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  8002f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800304:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800307:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030b:	8b 45 08             	mov    0x8(%ebp),%eax
  80030e:	89 04 24             	mov    %eax,(%esp)
  800311:	e8 87 ff ff ff       	call   80029d <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800316:	c9                   	leave  
  800317:	c3                   	ret    
	...

00800320 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 4c             	sub    $0x4c,%esp
  800329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80032c:	89 d6                	mov    %edx,%esi
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800334:	8b 55 0c             	mov    0xc(%ebp),%edx
  800337:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80033a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80033d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	39 d0                	cmp    %edx,%eax
  800347:	72 11                	jb     80035a <_ZL8printnumPFviPvES_yjii+0x3a>
  800349:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80034c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80034f:	76 09                	jbe    80035a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800351:	83 eb 01             	sub    $0x1,%ebx
  800354:	85 db                	test   %ebx,%ebx
  800356:	7f 5d                	jg     8003b5 <_ZL8printnumPFviPvES_yjii+0x95>
  800358:	eb 6c                	jmp    8003c6 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80035a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80035e:	83 eb 01             	sub    $0x1,%ebx
  800361:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800365:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800368:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80036c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800370:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800374:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800377:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80037a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800381:	00 
  800382:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800385:	89 14 24             	mov    %edx,(%esp)
  800388:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80038b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80038f:	e8 9c 41 00 00       	call   804530 <__udivdi3>
  800394:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800397:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80039a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80039e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003a2:	89 04 24             	mov    %eax,(%esp)
  8003a5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003a9:	89 f2                	mov    %esi,%edx
  8003ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ae:	e8 6d ff ff ff       	call   800320 <_ZL8printnumPFviPvES_yjii>
  8003b3:	eb 11                	jmp    8003c6 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b9:	89 3c 24             	mov    %edi,(%esp)
  8003bc:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003bf:	83 eb 01             	sub    $0x1,%ebx
  8003c2:	85 db                	test   %ebx,%ebx
  8003c4:	7f ef                	jg     8003b5 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003ca:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003dc:	00 
  8003dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003e0:	89 14 24             	mov    %edx,(%esp)
  8003e3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003ea:	e8 51 42 00 00       	call   804640 <__umoddi3>
  8003ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f3:	0f be 80 9f 48 80 00 	movsbl 0x80489f(%eax),%eax
  8003fa:	89 04 24             	mov    %eax,(%esp)
  8003fd:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800400:	83 c4 4c             	add    $0x4c,%esp
  800403:	5b                   	pop    %ebx
  800404:	5e                   	pop    %esi
  800405:	5f                   	pop    %edi
  800406:	5d                   	pop    %ebp
  800407:	c3                   	ret    

00800408 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80040b:	83 fa 01             	cmp    $0x1,%edx
  80040e:	7e 0e                	jle    80041e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800410:	8b 10                	mov    (%eax),%edx
  800412:	8d 4a 08             	lea    0x8(%edx),%ecx
  800415:	89 08                	mov    %ecx,(%eax)
  800417:	8b 02                	mov    (%edx),%eax
  800419:	8b 52 04             	mov    0x4(%edx),%edx
  80041c:	eb 22                	jmp    800440 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80041e:	85 d2                	test   %edx,%edx
  800420:	74 10                	je     800432 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800422:	8b 10                	mov    (%eax),%edx
  800424:	8d 4a 04             	lea    0x4(%edx),%ecx
  800427:	89 08                	mov    %ecx,(%eax)
  800429:	8b 02                	mov    (%edx),%eax
  80042b:	ba 00 00 00 00       	mov    $0x0,%edx
  800430:	eb 0e                	jmp    800440 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800432:	8b 10                	mov    (%eax),%edx
  800434:	8d 4a 04             	lea    0x4(%edx),%ecx
  800437:	89 08                	mov    %ecx,(%eax)
  800439:	8b 02                	mov    (%edx),%eax
  80043b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800440:	5d                   	pop    %ebp
  800441:	c3                   	ret    

00800442 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800448:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80044c:	8b 10                	mov    (%eax),%edx
  80044e:	3b 50 04             	cmp    0x4(%eax),%edx
  800451:	73 0a                	jae    80045d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800453:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800456:	88 0a                	mov    %cl,(%edx)
  800458:	83 c2 01             	add    $0x1,%edx
  80045b:	89 10                	mov    %edx,(%eax)
}
  80045d:	5d                   	pop    %ebp
  80045e:	c3                   	ret    

0080045f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800465:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800468:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80046c:	8b 45 10             	mov    0x10(%ebp),%eax
  80046f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800473:	8b 45 0c             	mov    0xc(%ebp),%eax
  800476:	89 44 24 04          	mov    %eax,0x4(%esp)
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	89 04 24             	mov    %eax,(%esp)
  800480:	e8 02 00 00 00       	call   800487 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	57                   	push   %edi
  80048b:	56                   	push   %esi
  80048c:	53                   	push   %ebx
  80048d:	83 ec 3c             	sub    $0x3c,%esp
  800490:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800493:	8b 55 10             	mov    0x10(%ebp),%edx
  800496:	0f b6 02             	movzbl (%edx),%eax
  800499:	89 d3                	mov    %edx,%ebx
  80049b:	83 c3 01             	add    $0x1,%ebx
  80049e:	83 f8 25             	cmp    $0x25,%eax
  8004a1:	74 2b                	je     8004ce <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	75 10                	jne    8004b7 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  8004a7:	e9 a5 03 00 00       	jmp    800851 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8004ac:	85 c0                	test   %eax,%eax
  8004ae:	66 90                	xchg   %ax,%ax
  8004b0:	75 08                	jne    8004ba <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  8004b2:	e9 9a 03 00 00       	jmp    800851 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8004b7:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  8004ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c3:	0f b6 03             	movzbl (%ebx),%eax
  8004c6:	83 c3 01             	add    $0x1,%ebx
  8004c9:	83 f8 25             	cmp    $0x25,%eax
  8004cc:	75 de                	jne    8004ac <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8004ce:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8004d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8004d9:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8004de:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ea:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004ed:	eb 2b                	jmp    80051a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ef:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  8004f2:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8004f6:	eb 22                	jmp    80051a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004fb:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8004ff:	eb 19                	jmp    80051a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800501:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800504:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80050b:	eb 0d                	jmp    80051a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80050d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800510:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800513:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	0f b6 03             	movzbl (%ebx),%eax
  80051d:	0f b6 d0             	movzbl %al,%edx
  800520:	8d 73 01             	lea    0x1(%ebx),%esi
  800523:	89 75 10             	mov    %esi,0x10(%ebp)
  800526:	83 e8 23             	sub    $0x23,%eax
  800529:	3c 55                	cmp    $0x55,%al
  80052b:	0f 87 d8 02 00 00    	ja     800809 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800531:	0f b6 c0             	movzbl %al,%eax
  800534:	ff 24 85 40 4a 80 00 	jmp    *0x804a40(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80053b:	83 ea 30             	sub    $0x30,%edx
  80053e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800541:	8b 55 10             	mov    0x10(%ebp),%edx
  800544:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800547:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80054d:	83 fa 09             	cmp    $0x9,%edx
  800550:	77 4e                	ja     8005a0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800555:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800558:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80055b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80055f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800562:	8d 50 d0             	lea    -0x30(%eax),%edx
  800565:	83 fa 09             	cmp    $0x9,%edx
  800568:	76 eb                	jbe    800555 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80056a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80056d:	eb 31                	jmp    8005a0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 50 04             	lea    0x4(%eax),%edx
  800575:	89 55 14             	mov    %edx,0x14(%ebp)
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800580:	eb 1e                	jmp    8005a0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800586:	0f 88 75 ff ff ff    	js     800501 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80058f:	eb 89                	jmp    80051a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800591:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800594:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80059b:	e9 7a ff ff ff       	jmp    80051a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  8005a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a4:	0f 89 70 ff ff ff    	jns    80051a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8005aa:	e9 5e ff ff ff       	jmp    80050d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005af:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005b5:	e9 60 ff ff ff       	jmp    80051a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 50 04             	lea    0x4(%eax),%edx
  8005c0:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	89 04 24             	mov    %eax,(%esp)
  8005cc:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005cf:	e9 bf fe ff ff       	jmp    800493 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8d 50 04             	lea    0x4(%eax),%edx
  8005da:	89 55 14             	mov    %edx,0x14(%ebp)
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	c1 fa 1f             	sar    $0x1f,%edx
  8005e4:	31 d0                	xor    %edx,%eax
  8005e6:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005e8:	83 f8 14             	cmp    $0x14,%eax
  8005eb:	7f 0f                	jg     8005fc <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  8005ed:	8b 14 85 a0 4b 80 00 	mov    0x804ba0(,%eax,4),%edx
  8005f4:	85 d2                	test   %edx,%edx
  8005f6:	0f 85 35 02 00 00    	jne    800831 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  8005fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800600:	c7 44 24 08 b7 48 80 	movl   $0x8048b7,0x8(%esp)
  800607:	00 
  800608:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060c:	8b 75 08             	mov    0x8(%ebp),%esi
  80060f:	89 34 24             	mov    %esi,(%esp)
  800612:	e8 48 fe ff ff       	call   80045f <_Z8printfmtPFviPvES_PKcz>
  800617:	e9 77 fe ff ff       	jmp    800493 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80061c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800622:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 50 04             	lea    0x4(%eax),%edx
  80062b:	89 55 14             	mov    %edx,0x14(%ebp)
  80062e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800630:	85 db                	test   %ebx,%ebx
  800632:	ba b0 48 80 00       	mov    $0x8048b0,%edx
  800637:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80063a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80063e:	7e 72                	jle    8006b2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800640:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800644:	74 6c                	je     8006b2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800646:	89 74 24 04          	mov    %esi,0x4(%esp)
  80064a:	89 1c 24             	mov    %ebx,(%esp)
  80064d:	e8 a9 02 00 00       	call   8008fb <_Z7strnlenPKcj>
  800652:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800655:	29 c2                	sub    %eax,%edx
  800657:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80065a:	85 d2                	test   %edx,%edx
  80065c:	7e 54                	jle    8006b2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80065e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800662:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800665:	89 d3                	mov    %edx,%ebx
  800667:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80066a:	89 c6                	mov    %eax,%esi
  80066c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800670:	89 34 24             	mov    %esi,(%esp)
  800673:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800676:	83 eb 01             	sub    $0x1,%ebx
  800679:	85 db                	test   %ebx,%ebx
  80067b:	7f ef                	jg     80066c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80067d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800680:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800683:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80068a:	eb 26                	jmp    8006b2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80068c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80068f:	83 fa 5e             	cmp    $0x5e,%edx
  800692:	76 10                	jbe    8006a4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800694:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800698:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80069f:	ff 55 08             	call   *0x8(%ebp)
  8006a2:	eb 0a                	jmp    8006ae <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  8006a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a8:	89 04 24             	mov    %eax,(%esp)
  8006ab:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ae:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006b2:	0f be 03             	movsbl (%ebx),%eax
  8006b5:	83 c3 01             	add    $0x1,%ebx
  8006b8:	85 c0                	test   %eax,%eax
  8006ba:	74 11                	je     8006cd <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  8006bc:	85 f6                	test   %esi,%esi
  8006be:	78 05                	js     8006c5 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  8006c0:	83 ee 01             	sub    $0x1,%esi
  8006c3:	78 0d                	js     8006d2 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c9:	75 c1                	jne    80068c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  8006cb:	eb d7                	jmp    8006a4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d0:	eb 03                	jmp    8006d5 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  8006d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	0f 8e b6 fd ff ff    	jle    800493 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8006dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8006e0:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  8006e3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006ee:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f0:	83 eb 01             	sub    $0x1,%ebx
  8006f3:	85 db                	test   %ebx,%ebx
  8006f5:	7f ec                	jg     8006e3 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  8006f7:	e9 97 fd ff ff       	jmp    800493 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006fc:	83 f9 01             	cmp    $0x1,%ecx
  8006ff:	90                   	nop
  800700:	7e 10                	jle    800712 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 50 08             	lea    0x8(%eax),%edx
  800708:	89 55 14             	mov    %edx,0x14(%ebp)
  80070b:	8b 18                	mov    (%eax),%ebx
  80070d:	8b 70 04             	mov    0x4(%eax),%esi
  800710:	eb 26                	jmp    800738 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800712:	85 c9                	test   %ecx,%ecx
  800714:	74 12                	je     800728 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 50 04             	lea    0x4(%eax),%edx
  80071c:	89 55 14             	mov    %edx,0x14(%ebp)
  80071f:	8b 18                	mov    (%eax),%ebx
  800721:	89 de                	mov    %ebx,%esi
  800723:	c1 fe 1f             	sar    $0x1f,%esi
  800726:	eb 10                	jmp    800738 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	89 55 14             	mov    %edx,0x14(%ebp)
  800731:	8b 18                	mov    (%eax),%ebx
  800733:	89 de                	mov    %ebx,%esi
  800735:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800738:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80073d:	85 f6                	test   %esi,%esi
  80073f:	0f 89 8c 00 00 00    	jns    8007d1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800745:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800749:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800750:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800753:	f7 db                	neg    %ebx
  800755:	83 d6 00             	adc    $0x0,%esi
  800758:	f7 de                	neg    %esi
			}
			base = 10;
  80075a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075f:	eb 70                	jmp    8007d1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800761:	89 ca                	mov    %ecx,%edx
  800763:	8d 45 14             	lea    0x14(%ebp),%eax
  800766:	e8 9d fc ff ff       	call   800408 <_ZL7getuintPPci>
  80076b:	89 c3                	mov    %eax,%ebx
  80076d:	89 d6                	mov    %edx,%esi
			base = 10;
  80076f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800774:	eb 5b                	jmp    8007d1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800776:	89 ca                	mov    %ecx,%edx
  800778:	8d 45 14             	lea    0x14(%ebp),%eax
  80077b:	e8 88 fc ff ff       	call   800408 <_ZL7getuintPPci>
  800780:	89 c3                	mov    %eax,%ebx
  800782:	89 d6                	mov    %edx,%esi
			base = 8;
  800784:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800789:	eb 46                	jmp    8007d1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80078b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800796:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800799:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80079d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007a4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 50 04             	lea    0x4(%eax),%edx
  8007ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8007b0:	8b 18                	mov    (%eax),%ebx
  8007b2:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  8007b7:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8007bc:	eb 13                	jmp    8007d1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007be:	89 ca                	mov    %ecx,%edx
  8007c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c3:	e8 40 fc ff ff       	call   800408 <_ZL7getuintPPci>
  8007c8:	89 c3                	mov    %eax,%ebx
  8007ca:	89 d6                	mov    %edx,%esi
			base = 16;
  8007cc:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007d1:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8007d5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007e4:	89 1c 24             	mov    %ebx,(%esp)
  8007e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007eb:	89 fa                	mov    %edi,%edx
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	e8 2b fb ff ff       	call   800320 <_ZL8printnumPFviPvES_yjii>
			break;
  8007f5:	e9 99 fc ff ff       	jmp    800493 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007fe:	89 14 24             	mov    %edx,(%esp)
  800801:	ff 55 08             	call   *0x8(%ebp)
			break;
  800804:	e9 8a fc ff ff       	jmp    800493 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800809:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80080d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800814:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800817:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	eb 02                	jmp    800820 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80081e:	89 d0                	mov    %edx,%eax
  800820:	8d 50 ff             	lea    -0x1(%eax),%edx
  800823:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800827:	75 f5                	jne    80081e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800829:	89 45 10             	mov    %eax,0x10(%ebp)
  80082c:	e9 62 fc ff ff       	jmp    800493 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800831:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800835:	c7 44 24 08 60 4c 80 	movl   $0x804c60,0x8(%esp)
  80083c:	00 
  80083d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800841:	8b 75 08             	mov    0x8(%ebp),%esi
  800844:	89 34 24             	mov    %esi,(%esp)
  800847:	e8 13 fc ff ff       	call   80045f <_Z8printfmtPFviPvES_PKcz>
  80084c:	e9 42 fc ff ff       	jmp    800493 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800851:	83 c4 3c             	add    $0x3c,%esp
  800854:	5b                   	pop    %ebx
  800855:	5e                   	pop    %esi
  800856:	5f                   	pop    %edi
  800857:	5d                   	pop    %ebp
  800858:	c3                   	ret    

00800859 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	83 ec 28             	sub    $0x28,%esp
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800865:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80086c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80086f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800873:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800876:	85 c0                	test   %eax,%eax
  800878:	74 30                	je     8008aa <_Z9vsnprintfPciPKcS_+0x51>
  80087a:	85 d2                	test   %edx,%edx
  80087c:	7e 2c                	jle    8008aa <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800885:	8b 45 10             	mov    0x10(%ebp),%eax
  800888:	89 44 24 08          	mov    %eax,0x8(%esp)
  80088c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80088f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800893:	c7 04 24 42 04 80 00 	movl   $0x800442,(%esp)
  80089a:	e8 e8 fb ff ff       	call   800487 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80089f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a8:	eb 05                	jmp    8008af <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    

008008b1 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008b7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008be:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	89 04 24             	mov    %eax,(%esp)
  8008d2:	e8 82 ff ff ff       	call   800859 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    
  8008d9:	00 00                	add    %al,(%eax)
  8008db:	00 00                	add    %al,(%eax)
  8008dd:	00 00                	add    %al,(%eax)
	...

008008e0 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	80 3a 00             	cmpb   $0x0,(%edx)
  8008ee:	74 09                	je     8008f9 <_Z6strlenPKc+0x19>
		n++;
  8008f0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f7:	75 f7                	jne    8008f0 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800901:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	39 c2                	cmp    %eax,%edx
  80090b:	74 0b                	je     800918 <_Z7strnlenPKcj+0x1d>
  80090d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800911:	74 05                	je     800918 <_Z7strnlenPKcj+0x1d>
		n++;
  800913:	83 c0 01             	add    $0x1,%eax
  800916:	eb f1                	jmp    800909 <_Z7strnlenPKcj+0xe>
	return n;
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
  800929:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80092d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800930:	83 c2 01             	add    $0x1,%edx
  800933:	84 c9                	test   %cl,%cl
  800935:	75 f2                	jne    800929 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800937:	5b                   	pop    %ebx
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	56                   	push   %esi
  80093e:	53                   	push   %ebx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
  800945:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800948:	85 f6                	test   %esi,%esi
  80094a:	74 18                	je     800964 <_Z7strncpyPcPKcj+0x2a>
  80094c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800951:	0f b6 1a             	movzbl (%edx),%ebx
  800954:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800957:	80 3a 01             	cmpb   $0x1,(%edx)
  80095a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  80095d:	83 c1 01             	add    $0x1,%ecx
  800960:	39 ce                	cmp    %ecx,%esi
  800962:	77 ed                	ja     800951 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800964:	5b                   	pop    %ebx
  800965:	5e                   	pop    %esi
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	56                   	push   %esi
  80096c:	53                   	push   %ebx
  80096d:	8b 75 08             	mov    0x8(%ebp),%esi
  800970:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800973:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800976:	89 f0                	mov    %esi,%eax
  800978:	85 d2                	test   %edx,%edx
  80097a:	74 17                	je     800993 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  80097c:	83 ea 01             	sub    $0x1,%edx
  80097f:	74 18                	je     800999 <_Z7strlcpyPcPKcj+0x31>
  800981:	80 39 00             	cmpb   $0x0,(%ecx)
  800984:	74 17                	je     80099d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800986:	0f b6 19             	movzbl (%ecx),%ebx
  800989:	88 18                	mov    %bl,(%eax)
  80098b:	83 c0 01             	add    $0x1,%eax
  80098e:	83 c1 01             	add    $0x1,%ecx
  800991:	eb e9                	jmp    80097c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800993:	29 f0                	sub    %esi,%eax
}
  800995:	5b                   	pop    %ebx
  800996:	5e                   	pop    %esi
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800999:	89 c2                	mov    %eax,%edx
  80099b:	eb 02                	jmp    80099f <_Z7strlcpyPcPKcj+0x37>
  80099d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  80099f:	c6 02 00             	movb   $0x0,(%edx)
  8009a2:	eb ef                	jmp    800993 <_Z7strlcpyPcPKcj+0x2b>

008009a4 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 0c                	je     8009c0 <_Z6strcmpPKcS0_+0x1c>
  8009b4:	3a 02                	cmp    (%edx),%al
  8009b6:	75 08                	jne    8009c0 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  8009b8:	83 c1 01             	add    $0x1,%ecx
  8009bb:	83 c2 01             	add    $0x1,%edx
  8009be:	eb ed                	jmp    8009ad <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  8009c0:	0f b6 c0             	movzbl %al,%eax
  8009c3:	0f b6 12             	movzbl (%edx),%edx
  8009c6:	29 d0                	sub    %edx,%eax
}
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
  8009ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009d4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8009d7:	85 d2                	test   %edx,%edx
  8009d9:	74 16                	je     8009f1 <_Z7strncmpPKcS0_j+0x27>
  8009db:	0f b6 01             	movzbl (%ecx),%eax
  8009de:	84 c0                	test   %al,%al
  8009e0:	74 17                	je     8009f9 <_Z7strncmpPKcS0_j+0x2f>
  8009e2:	3a 03                	cmp    (%ebx),%al
  8009e4:	75 13                	jne    8009f9 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  8009e6:	83 ea 01             	sub    $0x1,%edx
  8009e9:	83 c1 01             	add    $0x1,%ecx
  8009ec:	83 c3 01             	add    $0x1,%ebx
  8009ef:	eb e6                	jmp    8009d7 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  8009f1:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  8009f6:	5b                   	pop    %ebx
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  8009f9:	0f b6 01             	movzbl (%ecx),%eax
  8009fc:	0f b6 13             	movzbl (%ebx),%edx
  8009ff:	29 d0                	sub    %edx,%eax
  800a01:	eb f3                	jmp    8009f6 <_Z7strncmpPKcS0_j+0x2c>

00800a03 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0d:	0f b6 10             	movzbl (%eax),%edx
  800a10:	84 d2                	test   %dl,%dl
  800a12:	74 1f                	je     800a33 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800a14:	38 ca                	cmp    %cl,%dl
  800a16:	75 0a                	jne    800a22 <_Z6strchrPKcc+0x1f>
  800a18:	eb 1e                	jmp    800a38 <_Z6strchrPKcc+0x35>
  800a1a:	38 ca                	cmp    %cl,%dl
  800a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a20:	74 16                	je     800a38 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a22:	83 c0 01             	add    $0x1,%eax
  800a25:	0f b6 10             	movzbl (%eax),%edx
  800a28:	84 d2                	test   %dl,%dl
  800a2a:	75 ee                	jne    800a1a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a31:	eb 05                	jmp    800a38 <_Z6strchrPKcc+0x35>
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a44:	0f b6 10             	movzbl (%eax),%edx
  800a47:	84 d2                	test   %dl,%dl
  800a49:	74 14                	je     800a5f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800a4b:	38 ca                	cmp    %cl,%dl
  800a4d:	75 06                	jne    800a55 <_Z7strfindPKcc+0x1b>
  800a4f:	eb 0e                	jmp    800a5f <_Z7strfindPKcc+0x25>
  800a51:	38 ca                	cmp    %cl,%dl
  800a53:	74 0a                	je     800a5f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a55:	83 c0 01             	add    $0x1,%eax
  800a58:	0f b6 10             	movzbl (%eax),%edx
  800a5b:	84 d2                	test   %dl,%dl
  800a5d:	75 f2                	jne    800a51 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	89 1c 24             	mov    %ebx,(%esp)
  800a6a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a6e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a72:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800a7b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a81:	75 25                	jne    800aa8 <memset+0x47>
  800a83:	f6 c1 03             	test   $0x3,%cl
  800a86:	75 20                	jne    800aa8 <memset+0x47>
		c &= 0xFF;
  800a88:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a8b:	89 d3                	mov    %edx,%ebx
  800a8d:	c1 e3 08             	shl    $0x8,%ebx
  800a90:	89 d6                	mov    %edx,%esi
  800a92:	c1 e6 18             	shl    $0x18,%esi
  800a95:	89 d0                	mov    %edx,%eax
  800a97:	c1 e0 10             	shl    $0x10,%eax
  800a9a:	09 f0                	or     %esi,%eax
  800a9c:	09 d0                	or     %edx,%eax
  800a9e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800aa0:	c1 e9 02             	shr    $0x2,%ecx
  800aa3:	fc                   	cld    
  800aa4:	f3 ab                	rep stos %eax,%es:(%edi)
  800aa6:	eb 03                	jmp    800aab <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800aa8:	fc                   	cld    
  800aa9:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800aab:	89 f8                	mov    %edi,%eax
  800aad:	8b 1c 24             	mov    (%esp),%ebx
  800ab0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ab4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ab8:	89 ec                	mov    %ebp,%esp
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	89 34 24             	mov    %esi,(%esp)
  800ac5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acf:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800ad2:	39 c6                	cmp    %eax,%esi
  800ad4:	73 36                	jae    800b0c <memmove+0x50>
  800ad6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad9:	39 d0                	cmp    %edx,%eax
  800adb:	73 2f                	jae    800b0c <memmove+0x50>
		s += n;
		d += n;
  800add:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800ae0:	f6 c2 03             	test   $0x3,%dl
  800ae3:	75 1b                	jne    800b00 <memmove+0x44>
  800ae5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aeb:	75 13                	jne    800b00 <memmove+0x44>
  800aed:	f6 c1 03             	test   $0x3,%cl
  800af0:	75 0e                	jne    800b00 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af2:	83 ef 04             	sub    $0x4,%edi
  800af5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af8:	c1 e9 02             	shr    $0x2,%ecx
  800afb:	fd                   	std    
  800afc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afe:	eb 09                	jmp    800b09 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b00:	83 ef 01             	sub    $0x1,%edi
  800b03:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b06:	fd                   	std    
  800b07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b09:	fc                   	cld    
  800b0a:	eb 20                	jmp    800b2c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b0c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b12:	75 13                	jne    800b27 <memmove+0x6b>
  800b14:	a8 03                	test   $0x3,%al
  800b16:	75 0f                	jne    800b27 <memmove+0x6b>
  800b18:	f6 c1 03             	test   $0x3,%cl
  800b1b:	75 0a                	jne    800b27 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1d:	c1 e9 02             	shr    $0x2,%ecx
  800b20:	89 c7                	mov    %eax,%edi
  800b22:	fc                   	cld    
  800b23:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b25:	eb 05                	jmp    800b2c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b27:	89 c7                	mov    %eax,%edi
  800b29:	fc                   	cld    
  800b2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800b2c:	8b 34 24             	mov    (%esp),%esi
  800b2f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b33:	89 ec                	mov    %ebp,%esp
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	89 34 24             	mov    %esi,(%esp)
  800b40:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b4d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b53:	75 13                	jne    800b68 <memcpy+0x31>
  800b55:	a8 03                	test   $0x3,%al
  800b57:	75 0f                	jne    800b68 <memcpy+0x31>
  800b59:	f6 c1 03             	test   $0x3,%cl
  800b5c:	75 0a                	jne    800b68 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b5e:	c1 e9 02             	shr    $0x2,%ecx
  800b61:	89 c7                	mov    %eax,%edi
  800b63:	fc                   	cld    
  800b64:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b66:	eb 05                	jmp    800b6d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b68:	89 c7                	mov    %eax,%edi
  800b6a:	fc                   	cld    
  800b6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800b6d:	8b 34 24             	mov    (%esp),%esi
  800b70:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b74:	89 ec                	mov    %ebp,%esp
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	57                   	push   %edi
  800b7c:	56                   	push   %esi
  800b7d:	53                   	push   %ebx
  800b7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b81:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b84:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800b87:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b8c:	85 ff                	test   %edi,%edi
  800b8e:	74 38                	je     800bc8 <memcmp+0x50>
		if (*s1 != *s2)
  800b90:	0f b6 03             	movzbl (%ebx),%eax
  800b93:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b96:	83 ef 01             	sub    $0x1,%edi
  800b99:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b9e:	38 c8                	cmp    %cl,%al
  800ba0:	74 1d                	je     800bbf <memcmp+0x47>
  800ba2:	eb 11                	jmp    800bb5 <memcmp+0x3d>
  800ba4:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800ba9:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800bae:	83 c2 01             	add    $0x1,%edx
  800bb1:	38 c8                	cmp    %cl,%al
  800bb3:	74 0a                	je     800bbf <memcmp+0x47>
			return *s1 - *s2;
  800bb5:	0f b6 c0             	movzbl %al,%eax
  800bb8:	0f b6 c9             	movzbl %cl,%ecx
  800bbb:	29 c8                	sub    %ecx,%eax
  800bbd:	eb 09                	jmp    800bc8 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bbf:	39 fa                	cmp    %edi,%edx
  800bc1:	75 e1                	jne    800ba4 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800bc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	53                   	push   %ebx
  800bd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800bd4:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800bd6:	89 da                	mov    %ebx,%edx
  800bd8:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800bdb:	39 d3                	cmp    %edx,%ebx
  800bdd:	73 15                	jae    800bf4 <memfind+0x27>
		if (*s == (unsigned char) c)
  800bdf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800be3:	38 0b                	cmp    %cl,(%ebx)
  800be5:	75 06                	jne    800bed <memfind+0x20>
  800be7:	eb 0b                	jmp    800bf4 <memfind+0x27>
  800be9:	38 08                	cmp    %cl,(%eax)
  800beb:	74 07                	je     800bf4 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800bed:	83 c0 01             	add    $0x1,%eax
  800bf0:	39 c2                	cmp    %eax,%edx
  800bf2:	77 f5                	ja     800be9 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800c00:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c03:	0f b6 02             	movzbl (%edx),%eax
  800c06:	3c 20                	cmp    $0x20,%al
  800c08:	74 04                	je     800c0e <_Z6strtolPKcPPci+0x17>
  800c0a:	3c 09                	cmp    $0x9,%al
  800c0c:	75 0e                	jne    800c1c <_Z6strtolPKcPPci+0x25>
		s++;
  800c0e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c11:	0f b6 02             	movzbl (%edx),%eax
  800c14:	3c 20                	cmp    $0x20,%al
  800c16:	74 f6                	je     800c0e <_Z6strtolPKcPPci+0x17>
  800c18:	3c 09                	cmp    $0x9,%al
  800c1a:	74 f2                	je     800c0e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c1c:	3c 2b                	cmp    $0x2b,%al
  800c1e:	75 0a                	jne    800c2a <_Z6strtolPKcPPci+0x33>
		s++;
  800c20:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c23:	bf 00 00 00 00       	mov    $0x0,%edi
  800c28:	eb 10                	jmp    800c3a <_Z6strtolPKcPPci+0x43>
  800c2a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c2f:	3c 2d                	cmp    $0x2d,%al
  800c31:	75 07                	jne    800c3a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800c33:	83 c2 01             	add    $0x1,%edx
  800c36:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c3a:	85 db                	test   %ebx,%ebx
  800c3c:	0f 94 c0             	sete   %al
  800c3f:	74 05                	je     800c46 <_Z6strtolPKcPPci+0x4f>
  800c41:	83 fb 10             	cmp    $0x10,%ebx
  800c44:	75 15                	jne    800c5b <_Z6strtolPKcPPci+0x64>
  800c46:	80 3a 30             	cmpb   $0x30,(%edx)
  800c49:	75 10                	jne    800c5b <_Z6strtolPKcPPci+0x64>
  800c4b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c4f:	75 0a                	jne    800c5b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800c51:	83 c2 02             	add    $0x2,%edx
  800c54:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c59:	eb 13                	jmp    800c6e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800c5b:	84 c0                	test   %al,%al
  800c5d:	74 0f                	je     800c6e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c5f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c64:	80 3a 30             	cmpb   $0x30,(%edx)
  800c67:	75 05                	jne    800c6e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800c69:	83 c2 01             	add    $0x1,%edx
  800c6c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c73:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c75:	0f b6 0a             	movzbl (%edx),%ecx
  800c78:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c7b:	80 fb 09             	cmp    $0x9,%bl
  800c7e:	77 08                	ja     800c88 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800c80:	0f be c9             	movsbl %cl,%ecx
  800c83:	83 e9 30             	sub    $0x30,%ecx
  800c86:	eb 1e                	jmp    800ca6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c88:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c8b:	80 fb 19             	cmp    $0x19,%bl
  800c8e:	77 08                	ja     800c98 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800c90:	0f be c9             	movsbl %cl,%ecx
  800c93:	83 e9 57             	sub    $0x57,%ecx
  800c96:	eb 0e                	jmp    800ca6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c98:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c9b:	80 fb 19             	cmp    $0x19,%bl
  800c9e:	77 15                	ja     800cb5 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800ca0:	0f be c9             	movsbl %cl,%ecx
  800ca3:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ca6:	39 f1                	cmp    %esi,%ecx
  800ca8:	7d 0f                	jge    800cb9 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800caa:	83 c2 01             	add    $0x1,%edx
  800cad:	0f af c6             	imul   %esi,%eax
  800cb0:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800cb3:	eb c0                	jmp    800c75 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800cb5:	89 c1                	mov    %eax,%ecx
  800cb7:	eb 02                	jmp    800cbb <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cb9:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800cbb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbf:	74 05                	je     800cc6 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800cc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cc4:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800cc6:	89 ca                	mov    %ecx,%edx
  800cc8:	f7 da                	neg    %edx
  800cca:	85 ff                	test   %edi,%edi
  800ccc:	0f 45 c2             	cmovne %edx,%eax
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 0c             	sub    $0xc,%esp
  800cda:	89 1c 24             	mov    %ebx,(%esp)
  800cdd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ce1:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ced:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf0:	89 c3                	mov    %eax,%ebx
  800cf2:	89 c7                	mov    %eax,%edi
  800cf4:	89 c6                	mov    %eax,%esi
  800cf6:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cf8:	8b 1c 24             	mov    (%esp),%ebx
  800cfb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cff:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d03:	89 ec                	mov    %ebp,%esp
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	89 1c 24             	mov    %ebx,(%esp)
  800d10:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d14:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d18:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1d:	b8 01 00 00 00       	mov    $0x1,%eax
  800d22:	89 d1                	mov    %edx,%ecx
  800d24:	89 d3                	mov    %edx,%ebx
  800d26:	89 d7                	mov    %edx,%edi
  800d28:	89 d6                	mov    %edx,%esi
  800d2a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d2c:	8b 1c 24             	mov    (%esp),%ebx
  800d2f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d33:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d37:	89 ec                	mov    %ebp,%esp
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 38             	sub    $0x38,%esp
  800d41:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d44:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d47:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	89 cb                	mov    %ecx,%ebx
  800d59:	89 cf                	mov    %ecx,%edi
  800d5b:	89 ce                	mov    %ecx,%esi
  800d5d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	7e 28                	jle    800d8b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d63:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d67:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d6e:	00 
  800d6f:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  800d76:	00 
  800d77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d7e:	00 
  800d7f:	c7 04 24 11 4c 80 00 	movl   $0x804c11,(%esp)
  800d86:	e8 55 f4 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d8b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d8e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d91:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d94:	89 ec                	mov    %ebp,%esp
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	89 1c 24             	mov    %ebx,(%esp)
  800da1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800da5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800da9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dae:	b8 02 00 00 00       	mov    $0x2,%eax
  800db3:	89 d1                	mov    %edx,%ecx
  800db5:	89 d3                	mov    %edx,%ebx
  800db7:	89 d7                	mov    %edx,%edi
  800db9:	89 d6                	mov    %edx,%esi
  800dbb:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dbd:	8b 1c 24             	mov    (%esp),%ebx
  800dc0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dc4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dc8:	89 ec                	mov    %ebp,%esp
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	89 1c 24             	mov    %ebx,(%esp)
  800dd5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dd9:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  800de2:	b8 04 00 00 00       	mov    $0x4,%eax
  800de7:	89 d1                	mov    %edx,%ecx
  800de9:	89 d3                	mov    %edx,%ebx
  800deb:	89 d7                	mov    %edx,%edi
  800ded:	89 d6                	mov    %edx,%esi
  800def:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800df1:	8b 1c 24             	mov    (%esp),%ebx
  800df4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800df8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dfc:	89 ec                	mov    %ebp,%esp
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 38             	sub    $0x38,%esp
  800e06:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e09:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e0c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e0f:	be 00 00 00 00       	mov    $0x0,%esi
  800e14:	b8 08 00 00 00       	mov    $0x8,%eax
  800e19:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e22:	89 f7                	mov    %esi,%edi
  800e24:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	7e 28                	jle    800e52 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e2e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e35:	00 
  800e36:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  800e3d:	00 
  800e3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e45:	00 
  800e46:	c7 04 24 11 4c 80 00 	movl   $0x804c11,(%esp)
  800e4d:	e8 8e f3 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e55:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e58:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e5b:	89 ec                	mov    %ebp,%esp
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 38             	sub    $0x38,%esp
  800e65:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e68:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e6b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e6e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e73:	8b 75 18             	mov    0x18(%ebp),%esi
  800e76:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e79:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	7e 28                	jle    800eb0 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e88:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e93:	00 
  800e94:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  800e9b:	00 
  800e9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea3:	00 
  800ea4:	c7 04 24 11 4c 80 00 	movl   $0x804c11,(%esp)
  800eab:	e8 30 f3 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eb3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eb6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eb9:	89 ec                	mov    %ebp,%esp
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 38             	sub    $0x38,%esp
  800ec3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ec6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ec9:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ecc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	89 df                	mov    %ebx,%edi
  800ede:	89 de                	mov    %ebx,%esi
  800ee0:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	7e 28                	jle    800f0e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eea:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ef1:	00 
  800ef2:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  800ef9:	00 
  800efa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f01:	00 
  800f02:	c7 04 24 11 4c 80 00 	movl   $0x804c11,(%esp)
  800f09:	e8 d2 f2 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f0e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f11:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f14:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f17:	89 ec                	mov    %ebp,%esp
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 38             	sub    $0x38,%esp
  800f21:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f24:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f27:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2f:	b8 05 00 00 00       	mov    $0x5,%eax
  800f34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f37:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3a:	89 df                	mov    %ebx,%edi
  800f3c:	89 de                	mov    %ebx,%esi
  800f3e:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f40:	85 c0                	test   %eax,%eax
  800f42:	7e 28                	jle    800f6c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f44:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f48:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f4f:	00 
  800f50:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  800f57:	00 
  800f58:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f5f:	00 
  800f60:	c7 04 24 11 4c 80 00 	movl   $0x804c11,(%esp)
  800f67:	e8 74 f2 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f6f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f72:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f75:	89 ec                	mov    %ebp,%esp
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 38             	sub    $0x38,%esp
  800f7f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f82:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f85:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	89 df                	mov    %ebx,%edi
  800f9a:	89 de                	mov    %ebx,%esi
  800f9c:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f9e:	85 c0                	test   %eax,%eax
  800fa0:	7e 28                	jle    800fca <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fad:	00 
  800fae:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  800fb5:	00 
  800fb6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fbd:	00 
  800fbe:	c7 04 24 11 4c 80 00 	movl   $0x804c11,(%esp)
  800fc5:	e8 16 f2 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800fca:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fcd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fd0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fd3:	89 ec                	mov    %ebp,%esp
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 38             	sub    $0x38,%esp
  800fdd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fe0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fe3:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fe6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800feb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ff0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff6:	89 df                	mov    %ebx,%edi
  800ff8:	89 de                	mov    %ebx,%esi
  800ffa:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	7e 28                	jle    801028 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801000:	89 44 24 10          	mov    %eax,0x10(%esp)
  801004:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80100b:	00 
  80100c:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  801013:	00 
  801014:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80101b:	00 
  80101c:	c7 04 24 11 4c 80 00 	movl   $0x804c11,(%esp)
  801023:	e8 b8 f1 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801028:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80102b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80102e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801031:	89 ec                	mov    %ebp,%esp
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    

00801035 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 38             	sub    $0x38,%esp
  80103b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80103e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801041:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801044:	bb 00 00 00 00       	mov    $0x0,%ebx
  801049:	b8 0c 00 00 00       	mov    $0xc,%eax
  80104e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
  801054:	89 df                	mov    %ebx,%edi
  801056:	89 de                	mov    %ebx,%esi
  801058:	cd 30                	int    $0x30

	if(check && ret > 0)
  80105a:	85 c0                	test   %eax,%eax
  80105c:	7e 28                	jle    801086 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80105e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801062:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801069:	00 
  80106a:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  801071:	00 
  801072:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801079:	00 
  80107a:	c7 04 24 11 4c 80 00 	movl   $0x804c11,(%esp)
  801081:	e8 5a f1 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801086:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801089:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80108c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80108f:	89 ec                	mov    %ebp,%esp
  801091:	5d                   	pop    %ebp
  801092:	c3                   	ret    

00801093 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	89 1c 24             	mov    %ebx,(%esp)
  80109c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010a0:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010a4:	be 00 00 00 00       	mov    $0x0,%esi
  8010a9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ae:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ba:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010bc:	8b 1c 24             	mov    (%esp),%ebx
  8010bf:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010c3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010c7:	89 ec                	mov    %ebp,%esp
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 38             	sub    $0x38,%esp
  8010d1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010d4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010df:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e7:	89 cb                	mov    %ecx,%ebx
  8010e9:	89 cf                	mov    %ecx,%edi
  8010eb:	89 ce                	mov    %ecx,%esi
  8010ed:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	7e 28                	jle    80111b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f7:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8010fe:	00 
  8010ff:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  801106:	00 
  801107:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80110e:	00 
  80110f:	c7 04 24 11 4c 80 00 	movl   $0x804c11,(%esp)
  801116:	e8 c5 f0 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80111b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80111e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801121:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801124:	89 ec                	mov    %ebp,%esp
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 0c             	sub    $0xc,%esp
  80112e:	89 1c 24             	mov    %ebx,(%esp)
  801131:	89 74 24 04          	mov    %esi,0x4(%esp)
  801135:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801139:	bb 00 00 00 00       	mov    $0x0,%ebx
  80113e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801143:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801146:	8b 55 08             	mov    0x8(%ebp),%edx
  801149:	89 df                	mov    %ebx,%edi
  80114b:	89 de                	mov    %ebx,%esi
  80114d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80114f:	8b 1c 24             	mov    (%esp),%ebx
  801152:	8b 74 24 04          	mov    0x4(%esp),%esi
  801156:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80115a:	89 ec                	mov    %ebp,%esp
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	89 1c 24             	mov    %ebx,(%esp)
  801167:	89 74 24 04          	mov    %esi,0x4(%esp)
  80116b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80116f:	ba 00 00 00 00       	mov    $0x0,%edx
  801174:	b8 11 00 00 00       	mov    $0x11,%eax
  801179:	89 d1                	mov    %edx,%ecx
  80117b:	89 d3                	mov    %edx,%ebx
  80117d:	89 d7                	mov    %edx,%edi
  80117f:	89 d6                	mov    %edx,%esi
  801181:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801183:	8b 1c 24             	mov    (%esp),%ebx
  801186:	8b 74 24 04          	mov    0x4(%esp),%esi
  80118a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80118e:	89 ec                	mov    %ebp,%esp
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    

00801192 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	89 1c 24             	mov    %ebx,(%esp)
  80119b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80119f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a8:	b8 12 00 00 00       	mov    $0x12,%eax
  8011ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b3:	89 df                	mov    %ebx,%edi
  8011b5:	89 de                	mov    %ebx,%esi
  8011b7:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  8011b9:	8b 1c 24             	mov    (%esp),%ebx
  8011bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011c0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011c4:	89 ec                	mov    %ebp,%esp
  8011c6:	5d                   	pop    %ebp
  8011c7:	c3                   	ret    

008011c8 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 0c             	sub    $0xc,%esp
  8011ce:	89 1c 24             	mov    %ebx,(%esp)
  8011d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011de:	b8 13 00 00 00       	mov    $0x13,%eax
  8011e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e6:	89 cb                	mov    %ecx,%ebx
  8011e8:	89 cf                	mov    %ecx,%edi
  8011ea:	89 ce                	mov    %ecx,%esi
  8011ec:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  8011ee:	8b 1c 24             	mov    (%esp),%ebx
  8011f1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011f5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011f9:	89 ec                	mov    %ebp,%esp
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    

008011fd <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 0c             	sub    $0xc,%esp
  801203:	89 1c 24             	mov    %ebx,(%esp)
  801206:	89 74 24 04          	mov    %esi,0x4(%esp)
  80120a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80120e:	b8 10 00 00 00       	mov    $0x10,%eax
  801213:	8b 75 18             	mov    0x18(%ebp),%esi
  801216:	8b 7d 14             	mov    0x14(%ebp),%edi
  801219:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80121c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121f:	8b 55 08             	mov    0x8(%ebp),%edx
  801222:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801224:	8b 1c 24             	mov    (%esp),%ebx
  801227:	8b 74 24 04          	mov    0x4(%esp),%esi
  80122b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80122f:	89 ec                	mov    %ebp,%esp
  801231:	5d                   	pop    %ebp
  801232:	c3                   	ret    
	...

00801234 <_ZL24utemp_addr_to_stack_addrPv>:
//
// Shift an address from the UTEMP page to the corresponding value in the
// normal stack page (top address USTACKTOP).
//
static uintptr_t utemp_addr_to_stack_addr(void *ptr)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	83 ec 18             	sub    $0x18,%esp
	uintptr_t addr = (uintptr_t) ptr;
	assert(ptr >= UTEMP && ptr < (char *) UTEMP + PGSIZE);
  80123a:	8d 90 00 00 c0 ff    	lea    -0x400000(%eax),%edx
  801240:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
  801246:	76 24                	jbe    80126c <_ZL24utemp_addr_to_stack_addrPv+0x38>
  801248:	c7 44 24 0c 20 4c 80 	movl   $0x804c20,0xc(%esp)
  80124f:	00 
  801250:	c7 44 24 08 4e 4c 80 	movl   $0x804c4e,0x8(%esp)
  801257:	00 
  801258:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80125f:	00 
  801260:	c7 04 24 63 4c 80 00 	movl   $0x804c63,(%esp)
  801267:	e8 74 ef ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
	return USTACKTOP - PGSIZE + PGOFF(addr);
  80126c:	25 ff 0f 00 00       	and    $0xfff,%eax
  801271:	2d 00 30 00 11       	sub    $0x11003000,%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <_Z10spawn_readiPvijji>:
//

int
spawn_read(envid_t dst_env, void *va, int programid, size_t offset, 
           size_t len, int fs_read)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	57                   	push   %edi
  80127c:	56                   	push   %esi
  80127d:	53                   	push   %ebx
  80127e:	83 ec 3c             	sub    $0x3c,%esp
  801281:	8b 75 0c             	mov    0xc(%ebp),%esi
  801284:	8b 7d 10             	mov    0x10(%ebp),%edi
  801287:	8b 45 14             	mov    0x14(%ebp),%eax
    int r;
    if(!fs_read)
  80128a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80128e:	75 25                	jne    8012b5 <_Z10spawn_readiPvijji+0x3d>
        return sys_program_read(dst_env, va, programid, offset, len);
  801290:	8b 55 18             	mov    0x18(%ebp),%edx
  801293:	89 54 24 10          	mov    %edx,0x10(%esp)
  801297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80129b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80129f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	89 04 24             	mov    %eax,(%esp)
  8012a9:	e8 4f ff ff ff       	call   8011fd <_Z16sys_program_readiPvijj>
  8012ae:	89 c3                	mov    %eax,%ebx
  8012b0:	e9 7d 01 00 00       	jmp    801432 <_Z10spawn_readiPvijji+0x1ba>
    if((r = seek(programid, offset)))
  8012b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b9:	89 3c 24             	mov    %edi,(%esp)
  8012bc:	e8 4a 0d 00 00       	call   80200b <_Z4seekii>
  8012c1:	89 c3                	mov    %eax,%ebx
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	0f 85 67 01 00 00    	jne    801432 <_Z10spawn_readiPvijji+0x1ba>
        return r;
    if((uint32_t)va % PGSIZE)
  8012cb:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8012ce:	89 f2                	mov    %esi,%edx
  8012d0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8012d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8012d9:	0f 84 ab 00 00 00    	je     80138a <_Z10spawn_readiPvijji+0x112>
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
  8012df:	a1 00 70 80 00       	mov    0x807000,%eax
  8012e4:	8b 40 04             	mov    0x4(%eax),%eax
  8012e7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012ee:	00 
  8012ef:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8012f6:	00 
  8012f7:	89 04 24             	mov    %eax,(%esp)
  8012fa:	e8 01 fb ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  8012ff:	85 c0                	test   %eax,%eax
  801301:	0f 85 29 01 00 00    	jne    801430 <_Z10spawn_readiPvijji+0x1b8>
        return sys_program_read(dst_env, va, programid, offset, len);
    if((r = seek(programid, offset)))
        return r;
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
  801307:	66 b8 00 10          	mov    $0x1000,%ax
  80130b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
  80130e:	3b 45 18             	cmp    0x18(%ebp),%eax
  801311:	0f 47 45 18          	cmova  0x18(%ebp),%eax
  801315:	89 45 dc             	mov    %eax,-0x24(%ebp)
            return r;
        if((r = readn(programid,(char *)UTEMP+(uint32_t)va%PGSIZE, bytes))<0 ||
  801318:	89 44 24 08          	mov    %eax,0x8(%esp)
  80131c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80131f:	05 00 00 40 00       	add    $0x400000,%eax
  801324:	89 44 24 04          	mov    %eax,0x4(%esp)
  801328:	89 3c 24             	mov    %edi,(%esp)
  80132b:	e8 18 0c 00 00       	call   801f48 <_Z5readniPvj>
  801330:	89 c6                	mov    %eax,%esi
  801332:	85 c0                	test   %eax,%eax
  801334:	78 39                	js     80136f <_Z10spawn_readiPvijji+0xf7>
  801336:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80133d:	00 
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
  80133e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801341:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
            return r;
        if((r = readn(programid,(char *)UTEMP+(uint32_t)va%PGSIZE, bytes))<0 ||
  801346:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801351:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801358:	00 
  801359:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801360:	e8 fa fa ff ff       	call   800e5f <_Z12sys_page_mapiPviS_i>
  801365:	89 c6                	mov    %eax,%esi
  801367:	85 c0                	test   %eax,%eax
  801369:	0f 84 cd 00 00 00    	je     80143c <_Z10spawn_readiPvijji+0x1c4>
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
  80136f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801376:	00 
  801377:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80137e:	e8 3a fb ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
            return r;
  801383:	89 f3                	mov    %esi,%ebx
  801385:	e9 a8 00 00 00       	jmp    801432 <_Z10spawn_readiPvijji+0x1ba>
        sys_page_unmap(0, UTEMP);
        va = ROUNDUP(va, PGSIZE);
        len -= bytes;
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
  80138a:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80138d:	8b 55 18             	mov    0x18(%ebp),%edx
  801390:	01 f2                	add    %esi,%edx
  801392:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801395:	39 f2                	cmp    %esi,%edx
  801397:	0f 86 95 00 00 00    	jbe    801432 <_Z10spawn_readiPvijji+0x1ba>
// Returns the new environment's ID on success, and < 0 on error.
// If an error occurs, any new environment is destroyed.
//

int
spawn_read(envid_t dst_env, void *va, int programid, size_t offset, 
  80139d:	8b 75 18             	mov    0x18(%ebp),%esi
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
    {
        uint32_t bytes = (uint32_t)MIN((uint32_t)va + len - (uint32_t)i, (uint32_t)PGSIZE);
        if((r = sys_page_alloc(0, UTEMP, PTE_U | PTE_P|PTE_W)))
  8013a0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013a7:	00 
  8013a8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8013af:	00 
  8013b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b7:	e8 44 fa ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  8013bc:	89 c3                	mov    %eax,%ebx
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	75 70                	jne    801432 <_Z10spawn_readiPvijji+0x1ba>
            return r;
        if((r = readn(programid, UTEMP, bytes)) < 0 ||
  8013c2:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
  8013c8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8013cd:	0f 46 c6             	cmovbe %esi,%eax
  8013d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d4:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8013db:	00 
  8013dc:	89 3c 24             	mov    %edi,(%esp)
  8013df:	e8 64 0b 00 00       	call   801f48 <_Z5readniPvj>
  8013e4:	89 c3                	mov    %eax,%ebx
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 30                	js     80141a <_Z10spawn_readiPvijji+0x1a2>
  8013ea:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8013f1:	00 
  8013f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fc:	89 54 24 08          	mov    %edx,0x8(%esp)
  801400:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801407:	00 
  801408:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80140f:	e8 4b fa ff ff       	call   800e5f <_Z12sys_page_mapiPviS_i>
  801414:	89 c3                	mov    %eax,%ebx
  801416:	85 c0                	test   %eax,%eax
  801418:	74 50                	je     80146a <_Z10spawn_readiPvijji+0x1f2>
           (r = sys_page_map(0, UTEMP, dst_env, i, PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
  80141a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801421:	00 
  801422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801429:	e8 8f fa ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
            return r;
  80142e:	eb 02                	jmp    801432 <_Z10spawn_readiPvijji+0x1ba>
        return r;
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
            return r;
  801430:	89 c3                	mov    %eax,%ebx
            return r;
        }
        sys_page_unmap(0, UTEMP);
    }
    return 0;
}
  801432:	89 d8                	mov    %ebx,%eax
  801434:	83 c4 3c             	add    $0x3c,%esp
  801437:	5b                   	pop    %ebx
  801438:	5e                   	pop    %esi
  801439:	5f                   	pop    %edi
  80143a:	5d                   	pop    %ebp
  80143b:	c3                   	ret    
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
  80143c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801443:	00 
  801444:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80144b:	e8 6d fa ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
        va = ROUNDUP(va, PGSIZE);
  801450:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801453:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
  801459:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        len -= bytes;
  80145f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801462:	29 45 18             	sub    %eax,0x18(%ebp)
  801465:	e9 20 ff ff ff       	jmp    80138a <_Z10spawn_readiPvijji+0x112>
           (r = sys_page_map(0, UTEMP, dst_env, i, PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
  80146a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801471:	00 
  801472:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801479:	e8 3f fa ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
        sys_page_unmap(0, UTEMP);
        va = ROUNDUP(va, PGSIZE);
        len -= bytes;
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
  80147e:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  801485:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  80148b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80148e:	39 55 e0             	cmp    %edx,-0x20(%ebp)
  801491:	0f 87 09 ff ff ff    	ja     8013a0 <_Z10spawn_readiPvijji+0x128>
  801497:	eb 99                	jmp    801432 <_Z10spawn_readiPvijji+0x1ba>

00801499 <_Z5spawnPKcPS0_>:
    return 0;
}

envid_t
spawn(const char *prog, const char **argv)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	81 ec b8 02 00 00    	sub    $0x2b8,%esp
  8014a2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014a5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014a8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8014ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unfortunately, you cannot 'read' into a child address space,
	// so you'll need to code the 'read' case differently.
	//
	// Also, make sure you close the file descriptor, if any,
	// before returning from spawn().
    int fs_load = prog[0] == '/';
  8014ae:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8014b1:	0f 94 c0             	sete   %al
  8014b4:	0f b6 c0             	movzbl %al,%eax
  8014b7:	89 c6                	mov    %eax,%esi
    memset(elf_buf, 0, sizeof(elf_buf)); // ensure stack is writable
  8014b9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8014c0:	00 
  8014c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014c8:	00 
  8014c9:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8014cf:	89 04 24             	mov    %eax,(%esp)
  8014d2:	e8 8a f5 ff ff       	call   800a61 <memset>
    if(fs_load)
  8014d7:	85 f6                	test   %esi,%esi
  8014d9:	74 41                	je     80151c <_Z5spawnPKcPS0_+0x83>
    {
        if ((progid = open(prog, O_RDONLY)) < 0)
  8014db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014e2:	00 
  8014e3:	89 1c 24             	mov    %ebx,(%esp)
  8014e6:	e8 53 16 00 00       	call   802b3e <_Z4openPKci>
  8014eb:	89 c3                	mov    %eax,%ebx
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	0f 88 4e 05 00 00    	js     801a43 <_Z5spawnPKcPS0_+0x5aa>
            return progid;
        if (readn(progid, elf,sizeof(elf_buf)) != sizeof elf_buf)
  8014f5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8014fc:	00 
  8014fd:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801503:	89 44 24 04          	mov    %eax,0x4(%esp)
  801507:	89 1c 24             	mov    %ebx,(%esp)
  80150a:	e8 39 0a 00 00       	call   801f48 <_Z5readniPvj>
  80150f:	3d 00 02 00 00       	cmp    $0x200,%eax
  801514:	0f 85 11 05 00 00    	jne    801a2b <_Z5spawnPKcPS0_+0x592>
  80151a:	eb 51                	jmp    80156d <_Z5spawnPKcPS0_+0xd4>
            return -E_NOT_EXEC;
    }
    else
    {
        // Read ELF header from the kernel's binary collection.
        if ((progid = sys_program_lookup(prog, strlen(prog))) < 0)
  80151c:	89 1c 24             	mov    %ebx,(%esp)
  80151f:	e8 bc f3 ff ff       	call   8008e0 <_Z6strlenPKc>
  801524:	89 44 24 04          	mov    %eax,0x4(%esp)
  801528:	89 1c 24             	mov    %ebx,(%esp)
  80152b:	e8 f8 fb ff ff       	call   801128 <_Z18sys_program_lookupPKcj>
  801530:	89 c3                	mov    %eax,%ebx
  801532:	85 c0                	test   %eax,%eax
  801534:	0f 88 09 05 00 00    	js     801a43 <_Z5spawnPKcPS0_+0x5aa>
            return progid;
        if (sys_program_read(0, elf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf, 0))
  80153a:	c7 44 24 10 00 02 00 	movl   $0x200,0x10(%esp)
  801541:	00 
  801542:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801549:	00 
  80154a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80154e:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801554:	89 44 24 04          	mov    %eax,0x4(%esp)
  801558:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80155f:	e8 99 fc ff ff       	call   8011fd <_Z16sys_program_readiPvijj>
  801564:	83 f8 04             	cmp    $0x4,%eax
  801567:	0f 85 c5 04 00 00    	jne    801a32 <_Z5spawnPKcPS0_+0x599>
            return -E_NOT_EXEC;
    }
    if (elf->e_magic != ELF_MAGIC) {
  80156d:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
  801573:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  801578:	74 22                	je     80159c <_Z5spawnPKcPS0_+0x103>
        cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80157a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801581:	46 
  801582:	89 44 24 04          	mov    %eax,0x4(%esp)
  801586:	c7 04 24 6f 4c 80 00 	movl   $0x804c6f,(%esp)
  80158d:	e8 6c ed ff ff       	call   8002fe <_Z7cprintfPKcz>
        return -E_NOT_EXEC;
  801592:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  801597:	e9 a7 04 00 00       	jmp    801a43 <_Z5spawnPKcPS0_+0x5aa>
	//   although you won't use that fact here.)
	// - Check out sys_env_set_trapframe and init_stack.
	//
	

    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
  80159c:	8b 95 c0 fd ff ff    	mov    -0x240(%ebp),%edx
  8015a2:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
    struct Proghdr *eph = ph + elf->e_phnum;
  8015a8:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
  8015af:	66 89 85 76 fd ff ff 	mov    %ax,-0x28a(%ebp)
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  8015b6:	ba 07 00 00 00       	mov    $0x7,%edx
  8015bb:	89 d0                	mov    %edx,%eax
  8015bd:	cd 30                	int    $0x30
  8015bf:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  8015c5:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
    
    envid_t envid;
    if ((envid = sys_exofork()) < 0)
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	0f 88 66 04 00 00    	js     801a39 <_Z5spawnPKcPS0_+0x5a0>
        return envid;
    
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
  8015d3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015d8:	6b c0 78             	imul   $0x78,%eax,%eax
  8015db:	05 14 00 00 ef       	add    $0xef000014,%eax
  8015e0:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  8015e7:	00 
  8015e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ec:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  8015ef:	89 04 24             	mov    %eax,(%esp)
  8015f2:	e8 40 f5 ff ff       	call   800b37 <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8015f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fa:	8b 02                	mov    (%edx),%eax
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	0f 84 93 00 00 00    	je     801697 <_Z5spawnPKcPS0_+0x1fe>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801604:	bf 00 00 00 00       	mov    $0x0,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801609:	c7 85 90 fd ff ff 00 	movl   $0x0,-0x270(%ebp)
  801610:	00 00 00 
  801613:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801619:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  80161f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801624:	89 d6                	mov    %edx,%esi
		string_size += strlen(argv[argc]) + 1;
  801626:	89 04 24             	mov    %eax,(%esp)
  801629:	e8 b2 f2 ff ff       	call   8008e0 <_Z6strlenPKc>
  80162e:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801632:	83 c3 01             	add    $0x1,%ebx
  801635:	89 da                	mov    %ebx,%edx
  801637:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80163e:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801641:	85 c0                	test   %eax,%eax
  801643:	75 e1                	jne    801626 <_Z5spawnPKcPS0_+0x18d>
  801645:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  80164b:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801651:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
  801657:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  80165d:	89 8d 70 fd ff ff    	mov    %ecx,-0x290(%ebp)
	// into the temporary page at UTEMP.
	// Later, we'll remap that page into the child environment
	// at (USTACKTOP - PGSIZE).

	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801663:	f7 df                	neg    %edi
  801665:	81 c7 00 10 40 00    	add    $0x401000,%edi

	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);
  80166b:	89 fa                	mov    %edi,%edx
  80166d:	83 e2 fc             	and    $0xfffffffc,%edx
  801670:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801676:	f7 d0                	not    %eax
  801678:	8d 04 82             	lea    (%edx,%eax,4),%eax
  80167b:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801681:	83 e8 08             	sub    $0x8,%eax
  801684:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  80168a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80168f:	0f 86 78 01 00 00    	jbe    80180d <_Z5spawnPKcPS0_+0x374>
  801695:	eb 37                	jmp    8016ce <_Z5spawnPKcPS0_+0x235>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801697:	c7 85 70 fd ff ff 00 	movl   $0x0,-0x290(%ebp)
  80169e:	00 00 00 
  8016a1:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8016a8:	00 00 00 
  8016ab:	c7 85 90 fd ff ff 00 	movl   $0x0,-0x270(%ebp)
  8016b2:	00 00 00 
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8016b5:	c7 85 84 fd ff ff f4 	movl   $0x400ff4,-0x27c(%ebp)
  8016bc:	0f 40 00 
	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;

	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);
  8016bf:	c7 85 8c fd ff ff fc 	movl   $0x400ffc,-0x274(%ebp)
  8016c6:	0f 40 00 
	// into the temporary page at UTEMP.
	// Later, we'll remap that page into the child environment
	// at (USTACKTOP - PGSIZE).

	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  8016c9:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate a page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8016ce:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016d5:	00 
  8016d6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8016dd:	00 
  8016de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e5:	e8 16 f7 ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	0f 88 1b 01 00 00    	js     80180d <_Z5spawnPKcPS0_+0x374>
		return r;

	// Store the 'argc' and 'argv' parameters themselves
	// below 'argv_store' on the stack.  These parameters will be passed
	// to umain().
	argv_store[-2] = argc;
  8016f2:	8b 95 7c fd ff ff    	mov    -0x284(%ebp),%edx
  8016f8:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8016fe:	89 10                	mov    %edx,(%eax)
	argv_store[-1] = utemp_addr_to_stack_addr(argv_store);
  801700:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801706:	e8 29 fb ff ff       	call   801234 <_ZL24utemp_addr_to_stack_addrPv>
  80170b:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801711:	89 42 fc             	mov    %eax,-0x4(%edx)
	// and initialize 'argv_store[i]' to point at argument string i
	// in the child's address space.
	// Then set 'argv_store[argc]' to 0 to null-terminate the args array.
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
  801714:	83 bd 90 fd ff ff 00 	cmpl   $0x0,-0x270(%ebp)
  80171b:	7e 71                	jle    80178e <_Z5spawnPKcPS0_+0x2f5>
  80171d:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801724:	00 00 00 
  801727:	89 9d 6c fd ff ff    	mov    %ebx,-0x294(%ebp)
  80172d:	89 b5 68 fd ff ff    	mov    %esi,-0x298(%ebp)
  801733:	be 00 00 00 00       	mov    $0x0,%esi
  801738:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);
  80173b:	89 f8                	mov    %edi,%eax
  80173d:	e8 f2 fa ff ff       	call   801234 <_ZL24utemp_addr_to_stack_addrPv>
    }
    return 0;
}

envid_t
spawn(const char *prog, const char **argv)
  801742:	89 f1                	mov    %esi,%ecx
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);
  801744:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  80174a:	89 04 b2             	mov    %eax,(%edx,%esi,4)

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  80174d:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801750:	0f b6 00             	movzbl (%eax),%eax
  801753:	84 c0                	test   %al,%al
  801755:	74 18                	je     80176f <_Z5spawnPKcPS0_+0x2d6>
  801757:	ba 00 00 00 00       	mov    $0x0,%edx
        {
            *string_store = argv[i][j];
  80175c:	88 07                	mov    %al,(%edi)
            string_store++;
  80175e:	83 c7 01             	add    $0x1,%edi
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  801761:	83 c2 01             	add    $0x1,%edx
  801764:	8b 04 8b             	mov    (%ebx,%ecx,4),%eax
  801767:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  80176b:	84 c0                	test   %al,%al
  80176d:	75 ed                	jne    80175c <_Z5spawnPKcPS0_+0x2c3>
        {
            *string_store = argv[i][j];
            string_store++;
        }
        // terminate the string
        *string_store = '\0';
  80176f:	c6 07 00             	movb   $0x0,(%edi)
	// and initialize 'argv_store[i]' to point at argument string i
	// in the child's address space.
	// Then set 'argv_store[argc]' to 0 to null-terminate the args array.
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
  801772:	83 c6 01             	add    $0x1,%esi
  801775:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  80177b:	7d 05                	jge    801782 <_Z5spawnPKcPS0_+0x2e9>
            *string_store = argv[i][j];
            string_store++;
        }
        // terminate the string
        *string_store = '\0';
        string_store++;
  80177d:	83 c7 01             	add    $0x1,%edi
  801780:	eb b9                	jmp    80173b <_Z5spawnPKcPS0_+0x2a2>
  801782:	8b 9d 6c fd ff ff    	mov    -0x294(%ebp),%ebx
  801788:	8b b5 68 fd ff ff    	mov    -0x298(%ebp),%esi
    }   
    
    // null-terminate the whole argv array
    argv_store[argc] = 0;
  80178e:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801794:	8b 85 70 fd ff ff    	mov    -0x290(%ebp),%eax
  80179a:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)

	// Set *init_esp to the initial stack pointer for the child:
	// it should point at the "argc" value stored on the stack.
	// set the initial stack to point at argc
    *init_esp = utemp_addr_to_stack_addr(&argv_store[-2]);
  8017a1:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8017a7:	e8 88 fa ff ff       	call   801234 <_ZL24utemp_addr_to_stack_addrPv>
  8017ac:	89 45 e0             	mov    %eax,-0x20(%ebp)


	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8017af:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8017b6:	00 
  8017b7:	c7 44 24 0c 00 d0 ff 	movl   $0xeeffd000,0xc(%esp)
  8017be:	ee 
  8017bf:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8017c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017c9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8017d0:	00 
  8017d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d8:	e8 82 f6 ff ff       	call   800e5f <_Z12sys_page_mapiPviS_i>
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 18                	js     8017f9 <_Z5spawnPKcPS0_+0x360>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8017e1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8017e8:	00 
  8017e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f0:	e8 c8 f6 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	79 14                	jns    80180d <_Z5spawnPKcPS0_+0x374>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8017f9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801800:	00 
  801801:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801808:	e8 b0 f6 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
        return envid;
    
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
  80180d:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
  801813:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if ((r = sys_env_set_trapframe(envid, &tf)))
  801816:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  801819:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181d:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  801823:	89 14 24             	mov    %edx,(%esp)
  801826:	e8 ac f7 ff ff       	call   800fd7 <_Z21sys_env_set_trapframeiP9Trapframe>
  80182b:	85 c0                	test   %eax,%eax
  80182d:	0f 85 0e 02 00 00    	jne    801a41 <_Z5spawnPKcPS0_+0x5a8>
	//   although you won't use that fact here.)
	// - Check out sys_env_set_trapframe and init_stack.
	//
	

    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
  801833:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801839:	03 bd 80 fd ff ff    	add    -0x280(%ebp),%edi
    struct Proghdr *eph = ph + elf->e_phnum;
  80183f:	0f b7 85 76 fd ff ff 	movzwl -0x28a(%ebp),%eax
  801846:	c1 e0 05             	shl    $0x5,%eax
  801849:	8d 04 07             	lea    (%edi,%eax,1),%eax
  80184c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
    // iterate over each program header in the elf file
    for(; ph < eph; ++ph)
  801852:	39 c7                	cmp    %eax,%edi
  801854:	0f 83 25 01 00 00    	jae    80197f <_Z5spawnPKcPS0_+0x4e6>
  80185a:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801860:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801866:	89 fe                	mov    %edi,%esi
  801868:	8b bd 78 fd ff ff    	mov    -0x288(%ebp),%edi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
  80186e:	83 3e 01             	cmpl   $0x1,(%esi)
  801871:	0f 85 ed 00 00 00    	jne    801964 <_Z5spawnPKcPS0_+0x4cb>
{
    // identical to segment alloc for load_elf!
    int r;

    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
  801877:	8b 5e 08             	mov    0x8(%esi),%ebx
  80187a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    len = ROUNDUP(va + len, PGSIZE);
  801880:	8b 46 14             	mov    0x14(%esi),%eax
  801883:	8d 84 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%eax
  80188a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80188f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)

    // allocate pages for the whole region
    for (uintptr_t i = va; i < len; i+=PGSIZE)
  801895:	39 c3                	cmp    %eax,%ebx
  801897:	73 3c                	jae    8018d5 <_Z5spawnPKcPS0_+0x43c>
  801899:	89 b5 8c fd ff ff    	mov    %esi,-0x274(%ebp)
  80189f:	89 c6                	mov    %eax,%esi
        if ((r = sys_page_alloc(dst_env, (void *)i, PTE_P|PTE_U|PTE_W)))
  8018a1:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8018a8:	00 
  8018a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ad:	89 3c 24             	mov    %edi,(%esp)
  8018b0:	e8 4b f5 ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	74 0c                	je     8018c5 <_Z5spawnPKcPS0_+0x42c>
  8018b9:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
        {
            // allocate the region for it and read the data into the region
	        if ((r = segment_alloc(envid, ph->p_va, ph->p_memsz)) ||
  8018bf:	f7 d8                	neg    %eax
  8018c1:	75 4b                	jne    80190e <_Z5spawnPKcPS0_+0x475>
  8018c3:	eb 10                	jmp    8018d5 <_Z5spawnPKcPS0_+0x43c>
    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
    len = ROUNDUP(va + len, PGSIZE);

    // allocate pages for the whole region
    for (uintptr_t i = va; i < len; i+=PGSIZE)
  8018c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8018cb:	39 de                	cmp    %ebx,%esi
  8018cd:	77 d2                	ja     8018a1 <_Z5spawnPKcPS0_+0x408>
  8018cf:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
        {
            // allocate the region for it and read the data into the region
	        if ((r = segment_alloc(envid, ph->p_va, ph->p_memsz)) ||
  8018d5:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8018db:	89 44 24 14          	mov    %eax,0x14(%esp)
  8018df:	8b 46 10             	mov    0x10(%esi),%eax
  8018e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018e6:	8b 46 04             	mov    0x4(%esi),%eax
  8018e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018ed:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  8018f3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018f7:	8b 46 08             	mov    0x8(%esi),%eax
  8018fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fe:	89 3c 24             	mov    %edi,(%esp)
  801901:	e8 72 f9 ff ff       	call   801278 <_Z10spawn_readiPvijji>
  801906:	85 c0                	test   %eax,%eax
  801908:	0f 89 44 01 00 00    	jns    801a52 <_Z5spawnPKcPS0_+0x5b9>
  80190e:	89 c7                	mov    %eax,%edi
               (r = spawn_read(envid, (void *)ph->p_va, progid, ph->p_offset, ph->p_filesz, fs_load)) < 0)
            {
                sys_env_destroy(envid);
  801910:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801916:	89 04 24             	mov    %eax,(%esp)
  801919:	e8 1d f4 ff ff       	call   800d3b <_Z15sys_env_destroyi>
                return r;
  80191e:	89 fb                	mov    %edi,%ebx
  801920:	e9 1e 01 00 00       	jmp    801a43 <_Z5spawnPKcPS0_+0x5aa>
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  801925:	8b 46 08             	mov    0x8(%esi),%eax
  801928:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80192d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801934:	00 
  801935:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801939:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80193d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801941:	89 3c 24             	mov    %edi,(%esp)
  801944:	e8 16 f5 ff ff       	call   800e5f <_Z12sys_page_mapiPviS_i>
  801949:	85 c0                	test   %eax,%eax
  80194b:	74 17                	je     801964 <_Z5spawnPKcPS0_+0x4cb>
  80194d:	89 c7                	mov    %eax,%edi
            {
                sys_env_destroy(envid);
  80194f:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  801955:	89 14 24             	mov    %edx,(%esp)
  801958:	e8 de f3 ff ff       	call   800d3b <_Z15sys_env_destroyi>
                return r;
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  80195d:	89 fb                	mov    %edi,%ebx
            {
                sys_env_destroy(envid);
                return r;
  80195f:	e9 df 00 00 00       	jmp    801a43 <_Z5spawnPKcPS0_+0x5aa>
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
    // iterate over each program header in the elf file
    for(; ph < eph; ++ph)
  801964:	83 c6 20             	add    $0x20,%esi
  801967:	39 b5 94 fd ff ff    	cmp    %esi,-0x26c(%ebp)
  80196d:	0f 87 fb fe ff ff    	ja     80186e <_Z5spawnPKcPS0_+0x3d5>
  801973:	8b 9d 84 fd ff ff    	mov    -0x27c(%ebp),%ebx
  801979:	8b b5 80 fd ff ff    	mov    -0x280(%ebp),%esi
            }
                 
        }
    }

    if(fs_load)
  80197f:	85 f6                	test   %esi,%esi
  801981:	74 08                	je     80198b <_Z5spawnPKcPS0_+0x4f2>
        close(progid);
  801983:	89 1c 24             	mov    %ebx,(%esp)
  801986:	e8 7a 03 00 00       	call   801d05 <_Z5closei>
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  80198b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801990:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
copy_shared_pages(envid_t child)
{
	uintptr_t va;
	int r;
	for (va = 0; va < UTOP; va += PGSIZE)
		if (!(vpd[PDX(va)] & PTE_P))
  801996:	89 d8                	mov    %ebx,%eax
  801998:	c1 e8 16             	shr    $0x16,%eax
  80199b:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8019a2:	a8 01                	test   $0x1,%al
  8019a4:	75 0e                	jne    8019b4 <_Z5spawnPKcPS0_+0x51b>
			va = ROUNDUP(va + 1, PTSIZE) - PGSIZE;
  8019a6:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  8019ac:	8d 9b 00 f0 3f 00    	lea    0x3ff000(%ebx),%ebx
  8019b2:	eb 46                	jmp    8019fa <_Z5spawnPKcPS0_+0x561>
		else if ((vpt[PGNUM(va)] & (PTE_P|PTE_SHARE)) == (PTE_P|PTE_SHARE)) {
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	c1 e8 0c             	shr    $0xc,%eax
  8019b9:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8019c0:	81 e2 01 04 00 00    	and    $0x401,%edx
  8019c6:	81 fa 01 04 00 00    	cmp    $0x401,%edx
  8019cc:	75 2c                	jne    8019fa <_Z5spawnPKcPS0_+0x561>
			r = sys_page_map(0, (void *) va, child, (void *) va,
					 vpt[PGNUM(va)] & PTE_SYSCALL);
  8019ce:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8019d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8019da:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019de:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8019e2:	89 74 24 08          	mov    %esi,0x8(%esp)
  8019e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019f1:	e8 69 f4 ff ff       	call   800e5f <_Z12sys_page_mapiPviS_i>
			if (r < 0)
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 0e                	js     801a08 <_Z5spawnPKcPS0_+0x56f>
static int
copy_shared_pages(envid_t child)
{
	uintptr_t va;
	int r;
	for (va = 0; va < UTOP; va += PGSIZE)
  8019fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a00:	81 fb ff ff ff ee    	cmp    $0xeeffffff,%ebx
  801a06:	76 8e                	jbe    801996 <_Z5spawnPKcPS0_+0x4fd>
    if(fs_load)
        close(progid);
    copy_shared_pages(envid);
    
    // set our spawned process to runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801a08:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a0f:	00 
  801a10:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801a16:	89 04 24             	mov    %eax,(%esp)
  801a19:	e8 fd f4 ff ff       	call   800f1b <_Z18sys_env_set_statusii>
        return r;
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
  801a26:	0f 48 d8             	cmovs  %eax,%ebx
  801a29:	eb 18                	jmp    801a43 <_Z5spawnPKcPS0_+0x5aa>
    if(fs_load)
    {
        if ((progid = open(prog, O_RDONLY)) < 0)
            return progid;
        if (readn(progid, elf,sizeof(elf_buf)) != sizeof elf_buf)
            return -E_NOT_EXEC;
  801a2b:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  801a30:	eb 11                	jmp    801a43 <_Z5spawnPKcPS0_+0x5aa>
    {
        // Read ELF header from the kernel's binary collection.
        if ((progid = sys_program_lookup(prog, strlen(prog))) < 0)
            return progid;
        if (sys_program_read(0, elf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf, 0))
            return -E_NOT_EXEC;
  801a32:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  801a37:	eb 0a                	jmp    801a43 <_Z5spawnPKcPS0_+0x5aa>
    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
    struct Proghdr *eph = ph + elf->e_phnum;
    
    envid_t envid;
    if ((envid = sys_exofork()) < 0)
        return envid;
  801a39:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
  801a3f:	eb 02                	jmp    801a43 <_Z5spawnPKcPS0_+0x5aa>
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
  801a41:	89 c3                	mov    %eax,%ebx
    
    // set our spawned process to runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
        return r;
    return envid;
}
  801a43:	89 d8                	mov    %ebx,%eax
  801a45:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a48:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a4b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a4e:	89 ec                	mov    %ebp,%esp
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    
                return r;
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  801a52:	f6 46 18 02          	testb  $0x2,0x18(%esi)
  801a56:	0f 85 08 ff ff ff    	jne    801964 <_Z5spawnPKcPS0_+0x4cb>
  801a5c:	e9 c4 fe ff ff       	jmp    801925 <_Z5spawnPKcPS0_+0x48c>

00801a61 <_Z6spawnlPKcS0_z>:
}

// Spawn, taking command-line arguments array directly on the stack.
envid_t
spawnl(const char *prog, const char *arg0, ...)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  801a67:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	89 04 24             	mov    %eax,(%esp)
  801a74:	e8 20 fa ff ff       	call   801499 <_Z5spawnPKcPS0_>
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    
  801a7b:	00 00                	add    %al,(%eax)
  801a7d:	00 00                	add    %al,(%eax)
	...

00801a80 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801a83:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801a88:	75 11                	jne    801a9b <_ZL8fd_validPK2Fd+0x1b>
  801a8a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  801a8f:	76 0a                	jbe    801a9b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801a91:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801a96:	0f 96 c0             	setbe  %al
  801a99:	eb 05                	jmp    801aa0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa0:	5d                   	pop    %ebp
  801aa1:	c3                   	ret    

00801aa2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	53                   	push   %ebx
  801aa6:	83 ec 14             	sub    $0x14,%esp
  801aa9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  801aab:	e8 d0 ff ff ff       	call   801a80 <_ZL8fd_validPK2Fd>
  801ab0:	84 c0                	test   %al,%al
  801ab2:	75 24                	jne    801ad8 <_ZL9fd_isopenPK2Fd+0x36>
  801ab4:	c7 44 24 0c 89 4c 80 	movl   $0x804c89,0xc(%esp)
  801abb:	00 
  801abc:	c7 44 24 08 4e 4c 80 	movl   $0x804c4e,0x8(%esp)
  801ac3:	00 
  801ac4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801acb:	00 
  801acc:	c7 04 24 96 4c 80 00 	movl   $0x804c96,(%esp)
  801ad3:	e8 08 e7 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801ad8:	89 d8                	mov    %ebx,%eax
  801ada:	c1 e8 16             	shr    $0x16,%eax
  801add:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae9:	f6 c2 01             	test   $0x1,%dl
  801aec:	74 0d                	je     801afb <_ZL9fd_isopenPK2Fd+0x59>
  801aee:	c1 eb 0c             	shr    $0xc,%ebx
  801af1:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801af8:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  801afb:	83 c4 14             	add    $0x14,%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 08             	sub    $0x8,%esp
  801b07:	89 1c 24             	mov    %ebx,(%esp)
  801b0a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b11:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b14:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801b18:	83 fb 1f             	cmp    $0x1f,%ebx
  801b1b:	77 18                	ja     801b35 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  801b1d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801b23:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801b26:	84 c0                	test   %al,%al
  801b28:	74 21                	je     801b4b <_Z9fd_lookupiPP2Fdb+0x4a>
  801b2a:	89 d8                	mov    %ebx,%eax
  801b2c:	e8 71 ff ff ff       	call   801aa2 <_ZL9fd_isopenPK2Fd>
  801b31:	84 c0                	test   %al,%al
  801b33:	75 16                	jne    801b4b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801b35:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  801b3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801b40:	8b 1c 24             	mov    (%esp),%ebx
  801b43:	8b 74 24 04          	mov    0x4(%esp),%esi
  801b47:	89 ec                	mov    %ebp,%esp
  801b49:	5d                   	pop    %ebp
  801b4a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  801b4b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  801b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b52:	eb ec                	jmp    801b40 <_Z9fd_lookupiPP2Fdb+0x3f>

00801b54 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	53                   	push   %ebx
  801b58:	83 ec 14             	sub    $0x14,%esp
  801b5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  801b5e:	89 d8                	mov    %ebx,%eax
  801b60:	e8 1b ff ff ff       	call   801a80 <_ZL8fd_validPK2Fd>
  801b65:	84 c0                	test   %al,%al
  801b67:	75 24                	jne    801b8d <_Z6fd2numP2Fd+0x39>
  801b69:	c7 44 24 0c 89 4c 80 	movl   $0x804c89,0xc(%esp)
  801b70:	00 
  801b71:	c7 44 24 08 4e 4c 80 	movl   $0x804c4e,0x8(%esp)
  801b78:	00 
  801b79:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801b80:	00 
  801b81:	c7 04 24 96 4c 80 00 	movl   $0x804c96,(%esp)
  801b88:	e8 53 e6 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b8d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801b93:	c1 e8 0c             	shr    $0xc,%eax
}
  801b96:	83 c4 14             	add    $0x14,%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    

00801b9c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	89 04 24             	mov    %eax,(%esp)
  801ba8:	e8 a7 ff ff ff       	call   801b54 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  801bad:	05 20 00 0d 00       	add    $0xd0020,%eax
  801bb2:	c1 e0 0c             	shl    $0xc,%eax
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	57                   	push   %edi
  801bbb:	56                   	push   %esi
  801bbc:	53                   	push   %ebx
  801bbd:	83 ec 2c             	sub    $0x2c,%esp
  801bc0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801bc3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801bc8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  801bcb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bd2:	00 
  801bd3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bd7:	89 1c 24             	mov    %ebx,(%esp)
  801bda:	e8 22 ff ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  801bdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801be2:	e8 bb fe ff ff       	call   801aa2 <_ZL9fd_isopenPK2Fd>
  801be7:	84 c0                	test   %al,%al
  801be9:	75 0c                	jne    801bf7 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  801beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bee:	89 07                	mov    %eax,(%edi)
			return 0;
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf5:	eb 13                	jmp    801c0a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801bf7:	83 c3 01             	add    $0x1,%ebx
  801bfa:	83 fb 20             	cmp    $0x20,%ebx
  801bfd:	75 cc                	jne    801bcb <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801bff:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801c05:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c0a:	83 c4 2c             	add    $0x2c,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5f                   	pop    %edi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    

00801c12 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	53                   	push   %ebx
  801c16:	83 ec 14             	sub    $0x14,%esp
  801c19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  801c1f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801c24:	39 0d 04 60 80 00    	cmp    %ecx,0x806004
  801c2a:	75 16                	jne    801c42 <_Z10dev_lookupiPP3Dev+0x30>
  801c2c:	eb 06                	jmp    801c34 <_Z10dev_lookupiPP3Dev+0x22>
  801c2e:	39 0a                	cmp    %ecx,(%edx)
  801c30:	75 10                	jne    801c42 <_Z10dev_lookupiPP3Dev+0x30>
  801c32:	eb 05                	jmp    801c39 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c34:	ba 04 60 80 00       	mov    $0x806004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801c39:	89 13                	mov    %edx,(%ebx)
			return 0;
  801c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c40:	eb 35                	jmp    801c77 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c42:	83 c0 01             	add    $0x1,%eax
  801c45:	8b 14 85 00 4d 80 00 	mov    0x804d00(,%eax,4),%edx
  801c4c:	85 d2                	test   %edx,%edx
  801c4e:	75 de                	jne    801c2e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c50:	a1 00 70 80 00       	mov    0x807000,%eax
  801c55:	8b 40 04             	mov    0x4(%eax),%eax
  801c58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c60:	c7 04 24 bc 4c 80 00 	movl   $0x804cbc,(%esp)
  801c67:	e8 92 e6 ff ff       	call   8002fe <_Z7cprintfPKcz>
	*dev = 0;
  801c6c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801c72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801c77:	83 c4 14             	add    $0x14,%esp
  801c7a:	5b                   	pop    %ebx
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    

00801c7d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	56                   	push   %esi
  801c81:	53                   	push   %ebx
  801c82:	83 ec 20             	sub    $0x20,%esp
  801c85:	8b 75 08             	mov    0x8(%ebp),%esi
  801c88:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  801c8c:	89 34 24             	mov    %esi,(%esp)
  801c8f:	e8 c0 fe ff ff       	call   801b54 <_Z6fd2numP2Fd>
  801c94:	0f b6 d3             	movzbl %bl,%edx
  801c97:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c9b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c9e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ca2:	89 04 24             	mov    %eax,(%esp)
  801ca5:	e8 57 fe ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  801caa:	85 c0                	test   %eax,%eax
  801cac:	78 05                	js     801cb3 <_Z8fd_closeP2Fdb+0x36>
  801cae:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801cb1:	74 0c                	je     801cbf <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801cb3:	80 fb 01             	cmp    $0x1,%bl
  801cb6:	19 db                	sbb    %ebx,%ebx
  801cb8:	f7 d3                	not    %ebx
  801cba:	83 e3 fd             	and    $0xfffffffd,%ebx
  801cbd:	eb 3d                	jmp    801cfc <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cbf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc6:	8b 06                	mov    (%esi),%eax
  801cc8:	89 04 24             	mov    %eax,(%esp)
  801ccb:	e8 42 ff ff ff       	call   801c12 <_Z10dev_lookupiPP3Dev>
  801cd0:	89 c3                	mov    %eax,%ebx
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	78 16                	js     801cec <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801cdc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	74 07                	je     801cec <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801ce5:	89 34 24             	mov    %esi,(%esp)
  801ce8:	ff d0                	call   *%eax
  801cea:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801cec:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cf0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cf7:	e8 c1 f1 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
	return r;
}
  801cfc:	89 d8                	mov    %ebx,%eax
  801cfe:	83 c4 20             	add    $0x20,%esp
  801d01:	5b                   	pop    %ebx
  801d02:	5e                   	pop    %esi
  801d03:	5d                   	pop    %ebp
  801d04:	c3                   	ret    

00801d05 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801d0b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d12:	00 
  801d13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	89 04 24             	mov    %eax,(%esp)
  801d20:	e8 dc fd ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  801d25:	85 c0                	test   %eax,%eax
  801d27:	78 13                	js     801d3c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801d29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d30:	00 
  801d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d34:	89 04 24             	mov    %eax,(%esp)
  801d37:	e8 41 ff ff ff       	call   801c7d <_Z8fd_closeP2Fdb>
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <_Z9close_allv>:

void
close_all(void)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	53                   	push   %ebx
  801d42:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801d45:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801d4a:	89 1c 24             	mov    %ebx,(%esp)
  801d4d:	e8 b3 ff ff ff       	call   801d05 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801d52:	83 c3 01             	add    $0x1,%ebx
  801d55:	83 fb 20             	cmp    $0x20,%ebx
  801d58:	75 f0                	jne    801d4a <_Z9close_allv+0xc>
		close(i);
}
  801d5a:	83 c4 14             	add    $0x14,%esp
  801d5d:	5b                   	pop    %ebx
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    

00801d60 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 48             	sub    $0x48,%esp
  801d66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801d6f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801d72:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d79:	00 
  801d7a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	89 04 24             	mov    %eax,(%esp)
  801d87:	e8 75 fd ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  801d8c:	89 c3                	mov    %eax,%ebx
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	0f 88 ce 00 00 00    	js     801e64 <_Z3dupii+0x104>
  801d96:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d9d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  801d9e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801da1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801da5:	89 34 24             	mov    %esi,(%esp)
  801da8:	e8 54 fd ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  801dad:	89 c3                	mov    %eax,%ebx
  801daf:	85 c0                	test   %eax,%eax
  801db1:	0f 89 bc 00 00 00    	jns    801e73 <_Z3dupii+0x113>
  801db7:	e9 a8 00 00 00       	jmp    801e64 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801dbc:	89 d8                	mov    %ebx,%eax
  801dbe:	c1 e8 0c             	shr    $0xc,%eax
  801dc1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801dc8:	f6 c2 01             	test   $0x1,%dl
  801dcb:	74 32                	je     801dff <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801dcd:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801dd4:	25 07 0e 00 00       	and    $0xe07,%eax
  801dd9:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ddd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801de1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801de8:	00 
  801de9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ded:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df4:	e8 66 f0 ff ff       	call   800e5f <_Z12sys_page_mapiPviS_i>
  801df9:	89 c3                	mov    %eax,%ebx
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	78 3e                	js     801e3d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e02:	89 c2                	mov    %eax,%edx
  801e04:	c1 ea 0c             	shr    $0xc,%edx
  801e07:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  801e0e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801e14:	89 54 24 10          	mov    %edx,0x10(%esp)
  801e18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e1b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e26:	00 
  801e27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e32:	e8 28 f0 ff ff       	call   800e5f <_Z12sys_page_mapiPviS_i>
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	79 25                	jns    801e62 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e4b:	e8 6d f0 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801e50:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e5b:	e8 5d f0 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
	return r;
  801e60:	eb 02                	jmp    801e64 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801e62:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801e64:	89 d8                	mov    %ebx,%eax
  801e66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801e69:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801e6c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801e6f:	89 ec                	mov    %ebp,%esp
  801e71:	5d                   	pop    %ebp
  801e72:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801e73:	89 34 24             	mov    %esi,(%esp)
  801e76:	e8 8a fe ff ff       	call   801d05 <_Z5closei>

	ova = fd2data(oldfd);
  801e7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e7e:	89 04 24             	mov    %eax,(%esp)
  801e81:	e8 16 fd ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  801e86:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e8b:	89 04 24             	mov    %eax,(%esp)
  801e8e:	e8 09 fd ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  801e93:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801e95:	89 d8                	mov    %ebx,%eax
  801e97:	c1 e8 16             	shr    $0x16,%eax
  801e9a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801ea1:	a8 01                	test   $0x1,%al
  801ea3:	0f 85 13 ff ff ff    	jne    801dbc <_Z3dupii+0x5c>
  801ea9:	e9 51 ff ff ff       	jmp    801dff <_Z3dupii+0x9f>

00801eae <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	53                   	push   %ebx
  801eb2:	83 ec 24             	sub    $0x24,%esp
  801eb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801eb8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ebf:	00 
  801ec0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec7:	89 1c 24             	mov    %ebx,(%esp)
  801eca:	e8 32 fc ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	78 5f                	js     801f32 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ed3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801edd:	8b 00                	mov    (%eax),%eax
  801edf:	89 04 24             	mov    %eax,(%esp)
  801ee2:	e8 2b fd ff ff       	call   801c12 <_Z10dev_lookupiPP3Dev>
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	79 4d                	jns    801f38 <_Z4readiPvj+0x8a>
  801eeb:	eb 45                	jmp    801f32 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801eed:	a1 00 70 80 00       	mov    0x807000,%eax
  801ef2:	8b 40 04             	mov    0x4(%eax),%eax
  801ef5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efd:	c7 04 24 9f 4c 80 00 	movl   $0x804c9f,(%esp)
  801f04:	e8 f5 e3 ff ff       	call   8002fe <_Z7cprintfPKcz>
		return -E_INVAL;
  801f09:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f0e:	eb 22                	jmp    801f32 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f13:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801f16:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801f1b:	85 d2                	test   %edx,%edx
  801f1d:	74 13                	je     801f32 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2d:	89 0c 24             	mov    %ecx,(%esp)
  801f30:	ff d2                	call   *%edx
}
  801f32:	83 c4 24             	add    $0x24,%esp
  801f35:	5b                   	pop    %ebx
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f38:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f3b:	8b 41 08             	mov    0x8(%ecx),%eax
  801f3e:	83 e0 03             	and    $0x3,%eax
  801f41:	83 f8 01             	cmp    $0x1,%eax
  801f44:	75 ca                	jne    801f10 <_Z4readiPvj+0x62>
  801f46:	eb a5                	jmp    801eed <_Z4readiPvj+0x3f>

00801f48 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	57                   	push   %edi
  801f4c:	56                   	push   %esi
  801f4d:	53                   	push   %ebx
  801f4e:	83 ec 1c             	sub    $0x1c,%esp
  801f51:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f54:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801f57:	85 f6                	test   %esi,%esi
  801f59:	74 2f                	je     801f8a <_Z5readniPvj+0x42>
  801f5b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801f60:	89 f0                	mov    %esi,%eax
  801f62:	29 d8                	sub    %ebx,%eax
  801f64:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f68:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801f6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	89 04 24             	mov    %eax,(%esp)
  801f75:	e8 34 ff ff ff       	call   801eae <_Z4readiPvj>
		if (m < 0)
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	78 13                	js     801f91 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 0d                	je     801f8f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801f82:	01 c3                	add    %eax,%ebx
  801f84:	39 de                	cmp    %ebx,%esi
  801f86:	77 d8                	ja     801f60 <_Z5readniPvj+0x18>
  801f88:	eb 05                	jmp    801f8f <_Z5readniPvj+0x47>
  801f8a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801f8f:	89 d8                	mov    %ebx,%eax
}
  801f91:	83 c4 1c             	add    $0x1c,%esp
  801f94:	5b                   	pop    %ebx
  801f95:	5e                   	pop    %esi
  801f96:	5f                   	pop    %edi
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    

00801f99 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801f9f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801fa6:	00 
  801fa7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801faa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	89 04 24             	mov    %eax,(%esp)
  801fb4:	e8 48 fb ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	78 3c                	js     801ff9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	89 04 24             	mov    %eax,(%esp)
  801fcc:	e8 41 fc ff ff       	call   801c12 <_Z10dev_lookupiPP3Dev>
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	79 26                	jns    801ffb <_Z5writeiPKvj+0x62>
  801fd5:	eb 22                	jmp    801ff9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  801fdd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801fe2:	85 c9                	test   %ecx,%ecx
  801fe4:	74 13                	je     801ff9 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff4:	89 14 24             	mov    %edx,(%esp)
  801ff7:	ff d1                	call   *%ecx
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801ffb:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  801ffe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  802003:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  802007:	74 f0                	je     801ff9 <_Z5writeiPKvj+0x60>
  802009:	eb cc                	jmp    801fd7 <_Z5writeiPKvj+0x3e>

0080200b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  802011:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802018:	00 
  802019:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	89 04 24             	mov    %eax,(%esp)
  802026:	e8 d6 fa ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  80202b:	85 c0                	test   %eax,%eax
  80202d:	78 0e                	js     80203d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	8b 55 0c             	mov    0xc(%ebp),%edx
  802035:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	53                   	push   %ebx
  802043:	83 ec 24             	sub    $0x24,%esp
  802046:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802049:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802050:	00 
  802051:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802054:	89 44 24 04          	mov    %eax,0x4(%esp)
  802058:	89 1c 24             	mov    %ebx,(%esp)
  80205b:	e8 a1 fa ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  802060:	85 c0                	test   %eax,%eax
  802062:	78 58                	js     8020bc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802064:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802067:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80206e:	8b 00                	mov    (%eax),%eax
  802070:	89 04 24             	mov    %eax,(%esp)
  802073:	e8 9a fb ff ff       	call   801c12 <_Z10dev_lookupiPP3Dev>
  802078:	85 c0                	test   %eax,%eax
  80207a:	79 46                	jns    8020c2 <_Z9ftruncateii+0x83>
  80207c:	eb 3e                	jmp    8020bc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  80207e:	a1 00 70 80 00       	mov    0x807000,%eax
  802083:	8b 40 04             	mov    0x4(%eax),%eax
  802086:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80208a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208e:	c7 04 24 dc 4c 80 00 	movl   $0x804cdc,(%esp)
  802095:	e8 64 e2 ff ff       	call   8002fe <_Z7cprintfPKcz>
		return -E_INVAL;
  80209a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80209f:	eb 1b                	jmp    8020bc <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8020a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8020ac:	85 d2                	test   %edx,%edx
  8020ae:	74 0c                	je     8020bc <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8020b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b7:	89 0c 24             	mov    %ecx,(%esp)
  8020ba:	ff d2                	call   *%edx
}
  8020bc:	83 c4 24             	add    $0x24,%esp
  8020bf:	5b                   	pop    %ebx
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020c2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020c5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  8020c9:	75 d6                	jne    8020a1 <_Z9ftruncateii+0x62>
  8020cb:	eb b1                	jmp    80207e <_Z9ftruncateii+0x3f>

008020cd <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	53                   	push   %ebx
  8020d1:	83 ec 24             	sub    $0x24,%esp
  8020d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8020d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8020de:	00 
  8020df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	89 04 24             	mov    %eax,(%esp)
  8020ec:	e8 10 fa ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	78 3e                	js     802133 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8020ff:	8b 00                	mov    (%eax),%eax
  802101:	89 04 24             	mov    %eax,(%esp)
  802104:	e8 09 fb ff ff       	call   801c12 <_Z10dev_lookupiPP3Dev>
  802109:	85 c0                	test   %eax,%eax
  80210b:	79 2c                	jns    802139 <_Z5fstatiP4Stat+0x6c>
  80210d:	eb 24                	jmp    802133 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80210f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802112:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  802119:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  802120:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802126:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80212a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212d:	89 04 24             	mov    %eax,(%esp)
  802130:	ff 52 14             	call   *0x14(%edx)
}
  802133:	83 c4 24             	add    $0x24,%esp
  802136:	5b                   	pop    %ebx
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802139:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80213c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802141:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  802145:	75 c8                	jne    80210f <_Z5fstatiP4Stat+0x42>
  802147:	eb ea                	jmp    802133 <_Z5fstatiP4Stat+0x66>

00802149 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 18             	sub    $0x18,%esp
  80214f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802152:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802155:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80215c:	00 
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	89 04 24             	mov    %eax,(%esp)
  802163:	e8 d6 09 00 00       	call   802b3e <_Z4openPKci>
  802168:	89 c3                	mov    %eax,%ebx
  80216a:	85 c0                	test   %eax,%eax
  80216c:	78 1b                	js     802189 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80216e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802171:	89 44 24 04          	mov    %eax,0x4(%esp)
  802175:	89 1c 24             	mov    %ebx,(%esp)
  802178:	e8 50 ff ff ff       	call   8020cd <_Z5fstatiP4Stat>
  80217d:	89 c6                	mov    %eax,%esi
	close(fd);
  80217f:	89 1c 24             	mov    %ebx,(%esp)
  802182:	e8 7e fb ff ff       	call   801d05 <_Z5closei>
	return r;
  802187:	89 f3                	mov    %esi,%ebx
}
  802189:	89 d8                	mov    %ebx,%eax
  80218b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80218e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802191:	89 ec                	mov    %ebp,%esp
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    
	...

008021a0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8021a3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8021a8:	85 d2                	test   %edx,%edx
  8021aa:	78 33                	js     8021df <_ZL10inode_dataP5Inodei+0x3f>
  8021ac:	3b 50 08             	cmp    0x8(%eax),%edx
  8021af:	7d 2e                	jge    8021df <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  8021b1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8021b7:	85 d2                	test   %edx,%edx
  8021b9:	0f 49 ca             	cmovns %edx,%ecx
  8021bc:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  8021bf:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  8021c3:	c1 e1 0c             	shl    $0xc,%ecx
  8021c6:	89 d0                	mov    %edx,%eax
  8021c8:	c1 f8 1f             	sar    $0x1f,%eax
  8021cb:	c1 e8 14             	shr    $0x14,%eax
  8021ce:	01 c2                	add    %eax,%edx
  8021d0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8021d6:	29 c2                	sub    %eax,%edx
  8021d8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  8021df:	89 c8                	mov    %ecx,%eax
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    

008021e3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  8021e6:	8b 48 08             	mov    0x8(%eax),%ecx
  8021e9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  8021ec:	8b 00                	mov    (%eax),%eax
  8021ee:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  8021f1:	c7 82 80 00 00 00 04 	movl   $0x806004,0x80(%edx)
  8021f8:	60 80 00 
}
  8021fb:	5d                   	pop    %ebp
  8021fc:	c3                   	ret    

008021fd <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802203:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  802209:	85 c0                	test   %eax,%eax
  80220b:	74 08                	je     802215 <_ZL9get_inodei+0x18>
  80220d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802213:	7e 20                	jle    802235 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  802215:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802219:	c7 44 24 08 14 4d 80 	movl   $0x804d14,0x8(%esp)
  802220:	00 
  802221:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  802228:	00 
  802229:	c7 04 24 2a 4d 80 00 	movl   $0x804d2a,(%esp)
  802230:	e8 ab df ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802235:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80223b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802241:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802247:	85 d2                	test   %edx,%edx
  802249:	0f 48 d1             	cmovs  %ecx,%edx
  80224c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  80224f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  802256:	c1 e0 0c             	shl    $0xc,%eax
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	56                   	push   %esi
  80225f:	53                   	push   %ebx
  802260:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  802263:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  802269:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  80226c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  802272:	76 20                	jbe    802294 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  802274:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802278:	c7 44 24 08 50 4d 80 	movl   $0x804d50,0x8(%esp)
  80227f:	00 
  802280:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802287:	00 
  802288:	c7 04 24 2a 4d 80 00 	movl   $0x804d2a,(%esp)
  80228f:	e8 4c df ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  802294:	83 fe 01             	cmp    $0x1,%esi
  802297:	7e 08                	jle    8022a1 <_ZL10bcache_ipcPvi+0x46>
  802299:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  80229f:	7d 12                	jge    8022b3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8022a1:	89 f3                	mov    %esi,%ebx
  8022a3:	c1 e3 04             	shl    $0x4,%ebx
  8022a6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8022a8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  8022ae:	c1 e6 0c             	shl    $0xc,%esi
  8022b1:	eb 20                	jmp    8022d3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  8022b3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8022b7:	c7 44 24 08 80 4d 80 	movl   $0x804d80,0x8(%esp)
  8022be:	00 
  8022bf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8022c6:	00 
  8022c7:	c7 04 24 2a 4d 80 00 	movl   $0x804d2a,(%esp)
  8022ce:	e8 0d df ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8022d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022da:	00 
  8022db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022e2:	00 
  8022e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022e7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  8022ee:	e8 cc 21 00 00       	call   8044bf <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8022f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022fa:	00 
  8022fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802306:	e8 25 21 00 00       	call   804430 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  80230b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80230e:	74 c3                	je     8022d3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  802310:	83 c4 10             	add    $0x10,%esp
  802313:	5b                   	pop    %ebx
  802314:	5e                   	pop    %esi
  802315:	5d                   	pop    %ebp
  802316:	c3                   	ret    

00802317 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	83 ec 28             	sub    $0x28,%esp
  80231d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802320:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802323:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802326:	89 c7                	mov    %eax,%edi
  802328:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  80232a:	c7 04 24 bd 25 80 00 	movl   $0x8025bd,(%esp)
  802331:	e8 05 20 00 00       	call   80433b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  802336:	89 f8                	mov    %edi,%eax
  802338:	e8 c0 fe ff ff       	call   8021fd <_ZL9get_inodei>
  80233d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  80233f:	ba 02 00 00 00       	mov    $0x2,%edx
  802344:	e8 12 ff ff ff       	call   80225b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  802349:	85 c0                	test   %eax,%eax
  80234b:	79 08                	jns    802355 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  80234d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  802353:	eb 2e                	jmp    802383 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  802355:	85 c0                	test   %eax,%eax
  802357:	75 1c                	jne    802375 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  802359:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  80235f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  802366:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  802369:	ba 06 00 00 00       	mov    $0x6,%edx
  80236e:	89 d8                	mov    %ebx,%eax
  802370:	e8 e6 fe ff ff       	call   80225b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  802375:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  80237c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  80237e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802383:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802386:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802389:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80238c:	89 ec                	mov    %ebp,%esp
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    

00802390 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	57                   	push   %edi
  802394:	56                   	push   %esi
  802395:	53                   	push   %ebx
  802396:	83 ec 2c             	sub    $0x2c,%esp
  802399:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80239c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  80239f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  8023a4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  8023aa:	0f 87 3d 01 00 00    	ja     8024ed <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  8023b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023b3:	8b 42 08             	mov    0x8(%edx),%eax
  8023b6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	0f 49 f0             	cmovns %eax,%esi
  8023c1:	c1 fe 0c             	sar    $0xc,%esi
  8023c4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  8023c6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  8023c9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  8023cf:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  8023d2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8023d5:	0f 82 a6 00 00 00    	jb     802481 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  8023db:	39 fe                	cmp    %edi,%esi
  8023dd:	0f 8d f2 00 00 00    	jge    8024d5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8023e3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  8023e7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8023ea:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8023ed:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  8023f0:	83 3e 00             	cmpl   $0x0,(%esi)
  8023f3:	75 77                	jne    80246c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8023f5:	ba 02 00 00 00       	mov    $0x2,%edx
  8023fa:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8023ff:	e8 57 fe ff ff       	call   80225b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802404:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  80240a:	83 f9 02             	cmp    $0x2,%ecx
  80240d:	7e 43                	jle    802452 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  80240f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802414:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  802419:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802420:	74 29                	je     80244b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802422:	e9 ce 00 00 00       	jmp    8024f5 <_ZL14inode_set_sizeP5Inodej+0x165>
  802427:	89 c7                	mov    %eax,%edi
  802429:	0f b6 10             	movzbl (%eax),%edx
  80242c:	83 c0 01             	add    $0x1,%eax
  80242f:	84 d2                	test   %dl,%dl
  802431:	74 18                	je     80244b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802433:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802436:	ba 05 00 00 00       	mov    $0x5,%edx
  80243b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802440:	e8 16 fe ff ff       	call   80225b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802445:	85 db                	test   %ebx,%ebx
  802447:	79 1e                	jns    802467 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802449:	eb 07                	jmp    802452 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80244b:	83 c3 01             	add    $0x1,%ebx
  80244e:	39 d9                	cmp    %ebx,%ecx
  802450:	7f d5                	jg     802427 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  802452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802455:	8b 50 08             	mov    0x8(%eax),%edx
  802458:	e8 33 ff ff ff       	call   802390 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  80245d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802462:	e9 86 00 00 00       	jmp    8024ed <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  802467:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80246a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  80246c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  802470:	83 c6 04             	add    $0x4,%esi
  802473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802476:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  802479:	0f 8f 6e ff ff ff    	jg     8023ed <_ZL14inode_set_sizeP5Inodej+0x5d>
  80247f:	eb 54                	jmp    8024d5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  802481:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802484:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  802489:	83 f8 01             	cmp    $0x1,%eax
  80248c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  80248f:	ba 02 00 00 00       	mov    $0x2,%edx
  802494:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802499:	e8 bd fd ff ff       	call   80225b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  80249e:	39 f7                	cmp    %esi,%edi
  8024a0:	7d 24                	jge    8024c6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8024a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024a5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  8024a9:	8b 10                	mov    (%eax),%edx
  8024ab:	85 d2                	test   %edx,%edx
  8024ad:	74 0d                	je     8024bc <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  8024af:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  8024b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  8024bc:	83 eb 01             	sub    $0x1,%ebx
  8024bf:	83 e8 04             	sub    $0x4,%eax
  8024c2:	39 fb                	cmp    %edi,%ebx
  8024c4:	75 e3                	jne    8024a9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8024c6:	ba 05 00 00 00       	mov    $0x5,%edx
  8024cb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8024d0:	e8 86 fd ff ff       	call   80225b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  8024d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024db:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  8024de:	ba 04 00 00 00       	mov    $0x4,%edx
  8024e3:	e8 73 fd ff ff       	call   80225b <_ZL10bcache_ipcPvi>
	return 0;
  8024e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ed:	83 c4 2c             	add    $0x2c,%esp
  8024f0:	5b                   	pop    %ebx
  8024f1:	5e                   	pop    %esi
  8024f2:	5f                   	pop    %edi
  8024f3:	5d                   	pop    %ebp
  8024f4:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  8024f5:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8024fc:	ba 05 00 00 00       	mov    $0x5,%edx
  802501:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802506:	e8 50 fd ff ff       	call   80225b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80250b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802510:	e9 52 ff ff ff       	jmp    802467 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802515 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	53                   	push   %ebx
  802519:	83 ec 04             	sub    $0x4,%esp
  80251c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  80251e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802524:	83 e8 01             	sub    $0x1,%eax
  802527:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  80252d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802531:	75 40                	jne    802573 <_ZL11inode_closeP5Inode+0x5e>
  802533:	85 c0                	test   %eax,%eax
  802535:	75 3c                	jne    802573 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802537:	ba 02 00 00 00       	mov    $0x2,%edx
  80253c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802541:	e8 15 fd ff ff       	call   80225b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802546:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  80254b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  80254f:	85 d2                	test   %edx,%edx
  802551:	74 07                	je     80255a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  802553:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  80255a:	83 c0 01             	add    $0x1,%eax
  80255d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  802562:	75 e7                	jne    80254b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802564:	ba 05 00 00 00       	mov    $0x5,%edx
  802569:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80256e:	e8 e8 fc ff ff       	call   80225b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  802573:	ba 03 00 00 00       	mov    $0x3,%edx
  802578:	89 d8                	mov    %ebx,%eax
  80257a:	e8 dc fc ff ff       	call   80225b <_ZL10bcache_ipcPvi>
}
  80257f:	83 c4 04             	add    $0x4,%esp
  802582:	5b                   	pop    %ebx
  802583:	5d                   	pop    %ebp
  802584:	c3                   	ret    

00802585 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	53                   	push   %ebx
  802589:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	8b 40 0c             	mov    0xc(%eax),%eax
  802592:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802595:	e8 7d fd ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  80259a:	89 c3                	mov    %eax,%ebx
  80259c:	85 c0                	test   %eax,%eax
  80259e:	78 15                	js     8025b5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  8025a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	e8 e5 fd ff ff       	call   802390 <_ZL14inode_set_sizeP5Inodej>
  8025ab:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	e8 60 ff ff ff       	call   802515 <_ZL11inode_closeP5Inode>
	return r;
}
  8025b5:	89 d8                	mov    %ebx,%eax
  8025b7:	83 c4 14             	add    $0x14,%esp
  8025ba:	5b                   	pop    %ebx
  8025bb:	5d                   	pop    %ebp
  8025bc:	c3                   	ret    

008025bd <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	53                   	push   %ebx
  8025c1:	83 ec 14             	sub    $0x14,%esp
  8025c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  8025c7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  8025c9:	89 c2                	mov    %eax,%edx
  8025cb:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  8025d1:	78 32                	js     802605 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  8025d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d8:	e8 7e fc ff ff       	call   80225b <_ZL10bcache_ipcPvi>
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 1c                	je     8025fd <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  8025e1:	c7 44 24 08 35 4d 80 	movl   $0x804d35,0x8(%esp)
  8025e8:	00 
  8025e9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8025f0:	00 
  8025f1:	c7 04 24 2a 4d 80 00 	movl   $0x804d2a,(%esp)
  8025f8:	e8 e3 db ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
    resume(utf);
  8025fd:	89 1c 24             	mov    %ebx,(%esp)
  802600:	e8 0b 1e 00 00       	call   804410 <resume>
}
  802605:	83 c4 14             	add    $0x14,%esp
  802608:	5b                   	pop    %ebx
  802609:	5d                   	pop    %ebp
  80260a:	c3                   	ret    

0080260b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
  80260e:	83 ec 28             	sub    $0x28,%esp
  802611:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802614:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80261a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80261d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802620:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802623:	e8 ef fc ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  802628:	85 c0                	test   %eax,%eax
  80262a:	78 26                	js     802652 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80262c:	83 c3 10             	add    $0x10,%ebx
  80262f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802633:	89 34 24             	mov    %esi,(%esp)
  802636:	e8 df e2 ff ff       	call   80091a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80263b:	89 f2                	mov    %esi,%edx
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	e8 9e fb ff ff       	call   8021e3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	e8 c8 fe ff ff       	call   802515 <_ZL11inode_closeP5Inode>
	return 0;
  80264d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802652:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802655:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802658:	89 ec                	mov    %ebp,%esp
  80265a:	5d                   	pop    %ebp
  80265b:	c3                   	ret    

0080265c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	53                   	push   %ebx
  802660:	83 ec 24             	sub    $0x24,%esp
  802663:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802666:	89 1c 24             	mov    %ebx,(%esp)
  802669:	e8 9e 15 00 00       	call   803c0c <_Z7pagerefPv>
  80266e:	89 c2                	mov    %eax,%edx
        return 0;
  802670:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802675:	83 fa 01             	cmp    $0x1,%edx
  802678:	7f 1e                	jg     802698 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80267a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80267d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802680:	e8 92 fc ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  802685:	85 c0                	test   %eax,%eax
  802687:	78 0f                	js     802698 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802693:	e8 7d fe ff ff       	call   802515 <_ZL11inode_closeP5Inode>
}
  802698:	83 c4 24             	add    $0x24,%esp
  80269b:	5b                   	pop    %ebx
  80269c:	5d                   	pop    %ebp
  80269d:	c3                   	ret    

0080269e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	57                   	push   %edi
  8026a2:	56                   	push   %esi
  8026a3:	53                   	push   %ebx
  8026a4:	83 ec 3c             	sub    $0x3c,%esp
  8026a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8026aa:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  8026ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8026b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8026b3:	8b 43 0c             	mov    0xc(%ebx),%eax
  8026b6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8026b9:	e8 59 fc ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	0f 88 8c 00 00 00    	js     802752 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8026c6:	8b 53 04             	mov    0x4(%ebx),%edx
  8026c9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  8026cf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8026d5:	29 d7                	sub    %edx,%edi
  8026d7:	39 f7                	cmp    %esi,%edi
  8026d9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  8026dc:	85 ff                	test   %edi,%edi
  8026de:	74 16                	je     8026f6 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8026e0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  8026e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e6:	3b 50 08             	cmp    0x8(%eax),%edx
  8026e9:	76 6f                	jbe    80275a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  8026eb:	e8 a0 fc ff ff       	call   802390 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	79 66                	jns    80275a <_ZL13devfile_writeP2FdPKvj+0xbc>
  8026f4:	eb 4e                	jmp    802744 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8026f6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  8026fc:	76 24                	jbe    802722 <_ZL13devfile_writeP2FdPKvj+0x84>
  8026fe:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802700:	8b 53 04             	mov    0x4(%ebx),%edx
  802703:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270c:	3b 50 08             	cmp    0x8(%eax),%edx
  80270f:	0f 86 83 00 00 00    	jbe    802798 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802715:	e8 76 fc ff ff       	call   802390 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80271a:	85 c0                	test   %eax,%eax
  80271c:	79 7a                	jns    802798 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80271e:	66 90                	xchg   %ax,%ax
  802720:	eb 22                	jmp    802744 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802722:	85 f6                	test   %esi,%esi
  802724:	74 1e                	je     802744 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802726:	89 f2                	mov    %esi,%edx
  802728:	03 53 04             	add    0x4(%ebx),%edx
  80272b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272e:	3b 50 08             	cmp    0x8(%eax),%edx
  802731:	0f 86 b8 00 00 00    	jbe    8027ef <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802737:	e8 54 fc ff ff       	call   802390 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80273c:	85 c0                	test   %eax,%eax
  80273e:	0f 89 ab 00 00 00    	jns    8027ef <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802747:	e8 c9 fd ff ff       	call   802515 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80274c:	8b 43 04             	mov    0x4(%ebx),%eax
  80274f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  802752:	83 c4 3c             	add    $0x3c,%esp
  802755:	5b                   	pop    %ebx
  802756:	5e                   	pop    %esi
  802757:	5f                   	pop    %edi
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80275a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80275c:	8b 53 04             	mov    0x4(%ebx),%edx
  80275f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802762:	e8 39 fa ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
  802767:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80276a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80276e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802771:	89 44 24 04          	mov    %eax,0x4(%esp)
  802775:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802778:	89 04 24             	mov    %eax,(%esp)
  80277b:	e8 b7 e3 ff ff       	call   800b37 <memcpy>
        fd->fd_offset += n2;
  802780:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802783:	ba 04 00 00 00       	mov    $0x4,%edx
  802788:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80278b:	e8 cb fa ff ff       	call   80225b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802790:	01 7d 0c             	add    %edi,0xc(%ebp)
  802793:	e9 5e ff ff ff       	jmp    8026f6 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802798:	8b 53 04             	mov    0x4(%ebx),%edx
  80279b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279e:	e8 fd f9 ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
  8027a3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  8027a5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8027ac:	00 
  8027ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b4:	89 34 24             	mov    %esi,(%esp)
  8027b7:	e8 7b e3 ff ff       	call   800b37 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8027bc:	ba 04 00 00 00       	mov    $0x4,%edx
  8027c1:	89 f0                	mov    %esi,%eax
  8027c3:	e8 93 fa ff ff       	call   80225b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  8027c8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  8027ce:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  8027d5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8027dc:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8027e2:	0f 87 18 ff ff ff    	ja     802700 <_ZL13devfile_writeP2FdPKvj+0x62>
  8027e8:	89 fe                	mov    %edi,%esi
  8027ea:	e9 33 ff ff ff       	jmp    802722 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8027ef:	8b 53 04             	mov    0x4(%ebx),%edx
  8027f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f5:	e8 a6 f9 ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
  8027fa:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  8027fc:	89 74 24 08          	mov    %esi,0x8(%esp)
  802800:	8b 45 0c             	mov    0xc(%ebp),%eax
  802803:	89 44 24 04          	mov    %eax,0x4(%esp)
  802807:	89 3c 24             	mov    %edi,(%esp)
  80280a:	e8 28 e3 ff ff       	call   800b37 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80280f:	ba 04 00 00 00       	mov    $0x4,%edx
  802814:	89 f8                	mov    %edi,%eax
  802816:	e8 40 fa ff ff       	call   80225b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80281b:	01 73 04             	add    %esi,0x4(%ebx)
  80281e:	e9 21 ff ff ff       	jmp    802744 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802823 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
  802826:	57                   	push   %edi
  802827:	56                   	push   %esi
  802828:	53                   	push   %ebx
  802829:	83 ec 3c             	sub    $0x3c,%esp
  80282c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80282f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802832:	8b 43 04             	mov    0x4(%ebx),%eax
  802835:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802838:	8b 43 0c             	mov    0xc(%ebx),%eax
  80283b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80283e:	e8 d4 fa ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  802843:	85 c0                	test   %eax,%eax
  802845:	0f 88 d3 00 00 00    	js     80291e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80284b:	8b 73 04             	mov    0x4(%ebx),%esi
  80284e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802851:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802854:	8b 50 08             	mov    0x8(%eax),%edx
  802857:	29 f2                	sub    %esi,%edx
  802859:	3b 48 08             	cmp    0x8(%eax),%ecx
  80285c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80285f:	89 f2                	mov    %esi,%edx
  802861:	e8 3a f9 ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
  802866:	85 c0                	test   %eax,%eax
  802868:	0f 84 a2 00 00 00    	je     802910 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80286e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802874:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80287a:	29 f2                	sub    %esi,%edx
  80287c:	39 d7                	cmp    %edx,%edi
  80287e:	0f 46 d7             	cmovbe %edi,%edx
  802881:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802884:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802886:	01 d6                	add    %edx,%esi
  802888:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80288b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80288f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802893:	8b 45 0c             	mov    0xc(%ebp),%eax
  802896:	89 04 24             	mov    %eax,(%esp)
  802899:	e8 99 e2 ff ff       	call   800b37 <memcpy>
    buf = (void *)((char *)buf + n2);
  80289e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028a1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8028a4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8028aa:	76 3e                	jbe    8028ea <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8028ac:	8b 53 04             	mov    0x4(%ebx),%edx
  8028af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b2:	e8 e9 f8 ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	74 55                	je     802910 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  8028bb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8028c2:	00 
  8028c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c7:	89 34 24             	mov    %esi,(%esp)
  8028ca:	e8 68 e2 ff ff       	call   800b37 <memcpy>
        n -= PGSIZE;
  8028cf:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8028d5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8028db:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  8028e2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8028e8:	77 c2                	ja     8028ac <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8028ea:	85 ff                	test   %edi,%edi
  8028ec:	74 22                	je     802910 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8028ee:	8b 53 04             	mov    0x4(%ebx),%edx
  8028f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f4:	e8 a7 f8 ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 13                	je     802910 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  8028fd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802901:	89 44 24 04          	mov    %eax,0x4(%esp)
  802905:	89 34 24             	mov    %esi,(%esp)
  802908:	e8 2a e2 ff ff       	call   800b37 <memcpy>
        fd->fd_offset += n;
  80290d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802913:	e8 fd fb ff ff       	call   802515 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802918:	8b 43 04             	mov    0x4(%ebx),%eax
  80291b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80291e:	83 c4 3c             	add    $0x3c,%esp
  802921:	5b                   	pop    %ebx
  802922:	5e                   	pop    %esi
  802923:	5f                   	pop    %edi
  802924:	5d                   	pop    %ebp
  802925:	c3                   	ret    

00802926 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	57                   	push   %edi
  80292a:	56                   	push   %esi
  80292b:	53                   	push   %ebx
  80292c:	83 ec 4c             	sub    $0x4c,%esp
  80292f:	89 c6                	mov    %eax,%esi
  802931:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802934:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802937:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80293d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802946:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802949:	b8 01 00 00 00       	mov    $0x1,%eax
  80294e:	e8 c4 f9 ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  802953:	89 c7                	mov    %eax,%edi
  802955:	85 c0                	test   %eax,%eax
  802957:	0f 88 cd 01 00 00    	js     802b2a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80295d:	89 f3                	mov    %esi,%ebx
  80295f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802962:	75 08                	jne    80296c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802964:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802967:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80296a:	74 f8                	je     802964 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80296c:	0f b6 03             	movzbl (%ebx),%eax
  80296f:	3c 2f                	cmp    $0x2f,%al
  802971:	74 16                	je     802989 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802973:	84 c0                	test   %al,%al
  802975:	74 12                	je     802989 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802977:	89 da                	mov    %ebx,%edx
		++path;
  802979:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80297c:	0f b6 02             	movzbl (%edx),%eax
  80297f:	3c 2f                	cmp    $0x2f,%al
  802981:	74 08                	je     80298b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802983:	84 c0                	test   %al,%al
  802985:	75 f2                	jne    802979 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802987:	eb 02                	jmp    80298b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802989:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80298b:	89 d0                	mov    %edx,%eax
  80298d:	29 d8                	sub    %ebx,%eax
  80298f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802992:	0f b6 02             	movzbl (%edx),%eax
  802995:	89 d6                	mov    %edx,%esi
  802997:	3c 2f                	cmp    $0x2f,%al
  802999:	75 0a                	jne    8029a5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80299b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80299e:	0f b6 06             	movzbl (%esi),%eax
  8029a1:	3c 2f                	cmp    $0x2f,%al
  8029a3:	74 f6                	je     80299b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8029a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8029a9:	75 1b                	jne    8029c6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8029ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ae:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8029b1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8029b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029b6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8029bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c1:	e9 64 01 00 00       	jmp    802b2a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8029c6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8029ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ce:	74 06                	je     8029d6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8029d0:	84 c0                	test   %al,%al
  8029d2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8029d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029d9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8029dc:	83 3a 02             	cmpl   $0x2,(%edx)
  8029df:	0f 85 f4 00 00 00    	jne    802ad9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8029e5:	89 d0                	mov    %edx,%eax
  8029e7:	8b 52 08             	mov    0x8(%edx),%edx
  8029ea:	85 d2                	test   %edx,%edx
  8029ec:	7e 78                	jle    802a66 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  8029ee:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8029f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8029fa:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8029fd:	89 fb                	mov    %edi,%ebx
  8029ff:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802a02:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802a04:	89 da                	mov    %ebx,%edx
  802a06:	89 f0                	mov    %esi,%eax
  802a08:	e8 93 f7 ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
  802a0d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  802a0f:	83 38 00             	cmpl   $0x0,(%eax)
  802a12:	74 26                	je     802a3a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802a14:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a17:	3b 50 04             	cmp    0x4(%eax),%edx
  802a1a:	75 33                	jne    802a4f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  802a1c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a27:	8d 47 08             	lea    0x8(%edi),%eax
  802a2a:	89 04 24             	mov    %eax,(%esp)
  802a2d:	e8 46 e1 ff ff       	call   800b78 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802a32:	85 c0                	test   %eax,%eax
  802a34:	0f 84 fa 00 00 00    	je     802b34 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  802a3a:	83 3f 00             	cmpl   $0x0,(%edi)
  802a3d:	75 10                	jne    802a4f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  802a3f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a43:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802a46:	84 c0                	test   %al,%al
  802a48:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  802a4c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802a4f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802a55:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802a57:	8b 56 08             	mov    0x8(%esi),%edx
  802a5a:	39 d0                	cmp    %edx,%eax
  802a5c:	7c a6                	jl     802a04 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  802a5e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802a61:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802a64:	eb 07                	jmp    802a6d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802a66:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  802a6d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802a71:	74 6d                	je     802ae0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802a73:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a77:	75 24                	jne    802a9d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802a79:	83 ea 80             	sub    $0xffffff80,%edx
  802a7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a7f:	e8 0c f9 ff ff       	call   802390 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802a84:	85 c0                	test   %eax,%eax
  802a86:	0f 88 90 00 00 00    	js     802b1c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  802a8c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a8f:	8b 50 08             	mov    0x8(%eax),%edx
  802a92:	83 c2 80             	add    $0xffffff80,%edx
  802a95:	e8 06 f7 ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
  802a9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  802a9d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802aa4:	00 
  802aa5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802aac:	00 
  802aad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ab0:	89 14 24             	mov    %edx,(%esp)
  802ab3:	e8 a9 df ff ff       	call   800a61 <memset>
	empty->de_namelen = namelen;
  802ab8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802abb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802abe:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802ac1:	89 54 24 08          	mov    %edx,0x8(%esp)
  802ac5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ac9:	83 c0 08             	add    $0x8,%eax
  802acc:	89 04 24             	mov    %eax,(%esp)
  802acf:	e8 63 e0 ff ff       	call   800b37 <memcpy>
	*de_store = empty;
  802ad4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802ad7:	eb 5e                	jmp    802b37 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802ad9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  802ade:	eb 42                	jmp    802b22 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802ae0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802ae5:	eb 3b                	jmp    802b22 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802ae7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aea:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802aed:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  802aef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802af2:	89 38                	mov    %edi,(%eax)
			return 0;
  802af4:	bf 00 00 00 00       	mov    $0x0,%edi
  802af9:	eb 2f                	jmp    802b2a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  802afb:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802afe:	8b 07                	mov    (%edi),%eax
  802b00:	e8 12 f8 ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  802b05:	85 c0                	test   %eax,%eax
  802b07:	78 17                	js     802b20 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802b09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b0c:	e8 04 fa ff ff       	call   802515 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802b17:	e9 41 fe ff ff       	jmp    80295d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  802b1c:	89 c7                	mov    %eax,%edi
  802b1e:	eb 02                	jmp    802b22 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802b20:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b25:	e8 eb f9 ff ff       	call   802515 <_ZL11inode_closeP5Inode>
	return r;
}
  802b2a:	89 f8                	mov    %edi,%eax
  802b2c:	83 c4 4c             	add    $0x4c,%esp
  802b2f:	5b                   	pop    %ebx
  802b30:	5e                   	pop    %esi
  802b31:	5f                   	pop    %edi
  802b32:	5d                   	pop    %ebp
  802b33:	c3                   	ret    
  802b34:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802b37:	80 3e 00             	cmpb   $0x0,(%esi)
  802b3a:	75 bf                	jne    802afb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  802b3c:	eb a9                	jmp    802ae7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

00802b3e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
  802b41:	57                   	push   %edi
  802b42:	56                   	push   %esi
  802b43:	53                   	push   %ebx
  802b44:	83 ec 3c             	sub    $0x3c,%esp
  802b47:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  802b4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b4d:	89 04 24             	mov    %eax,(%esp)
  802b50:	e8 62 f0 ff ff       	call   801bb7 <_Z14fd_find_unusedPP2Fd>
  802b55:	89 c3                	mov    %eax,%ebx
  802b57:	85 c0                	test   %eax,%eax
  802b59:	0f 88 16 02 00 00    	js     802d75 <_Z4openPKci+0x237>
  802b5f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b66:	00 
  802b67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b75:	e8 86 e2 ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  802b7a:	89 c3                	mov    %eax,%ebx
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b81:	85 db                	test   %ebx,%ebx
  802b83:	0f 88 ec 01 00 00    	js     802d75 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802b89:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  802b8d:	0f 84 ec 01 00 00    	je     802d7f <_Z4openPKci+0x241>
  802b93:	83 c0 01             	add    $0x1,%eax
  802b96:	83 f8 78             	cmp    $0x78,%eax
  802b99:	75 ee                	jne    802b89 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802b9b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802ba0:	e9 b9 01 00 00       	jmp    802d5e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802ba5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ba8:	81 e7 00 01 00 00    	and    $0x100,%edi
  802bae:	89 3c 24             	mov    %edi,(%esp)
  802bb1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802bb4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802bb7:	89 f0                	mov    %esi,%eax
  802bb9:	e8 68 fd ff ff       	call   802926 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802bbe:	89 c3                	mov    %eax,%ebx
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	0f 85 96 01 00 00    	jne    802d5e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802bc8:	85 ff                	test   %edi,%edi
  802bca:	75 41                	jne    802c0d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  802bcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bcf:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802bd4:	75 08                	jne    802bde <_Z4openPKci+0xa0>
            fileino = dirino;
  802bd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802bdc:	eb 14                	jmp    802bf2 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  802bde:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802be1:	8b 00                	mov    (%eax),%eax
  802be3:	e8 2f f7 ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  802be8:	89 c3                	mov    %eax,%ebx
  802bea:	85 c0                	test   %eax,%eax
  802bec:	0f 88 5d 01 00 00    	js     802d4f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802bf2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bf5:	83 38 02             	cmpl   $0x2,(%eax)
  802bf8:	0f 85 d2 00 00 00    	jne    802cd0 <_Z4openPKci+0x192>
  802bfe:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802c02:	0f 84 c8 00 00 00    	je     802cd0 <_Z4openPKci+0x192>
  802c08:	e9 38 01 00 00       	jmp    802d45 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  802c0d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802c14:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  802c1b:	0f 8e a8 00 00 00    	jle    802cc9 <_Z4openPKci+0x18b>
  802c21:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802c26:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802c29:	89 f8                	mov    %edi,%eax
  802c2b:	e8 e7 f6 ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  802c30:	89 c3                	mov    %eax,%ebx
  802c32:	85 c0                	test   %eax,%eax
  802c34:	0f 88 15 01 00 00    	js     802d4f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  802c3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c3d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802c41:	75 68                	jne    802cab <_Z4openPKci+0x16d>
  802c43:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  802c4a:	75 5f                	jne    802cab <_Z4openPKci+0x16d>
			*ino_store = ino;
  802c4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  802c4f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802c55:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c58:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  802c5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802c66:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  802c6d:	00 
  802c6e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802c75:	00 
  802c76:	83 c0 0c             	add    $0xc,%eax
  802c79:	89 04 24             	mov    %eax,(%esp)
  802c7c:	e8 e0 dd ff ff       	call   800a61 <memset>
        de->de_inum = fileino->i_inum;
  802c81:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c84:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  802c8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c8d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  802c8f:	ba 04 00 00 00       	mov    $0x4,%edx
  802c94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c97:	e8 bf f5 ff ff       	call   80225b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  802c9c:	ba 04 00 00 00       	mov    $0x4,%edx
  802ca1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca4:	e8 b2 f5 ff ff       	call   80225b <_ZL10bcache_ipcPvi>
  802ca9:	eb 25                	jmp    802cd0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  802cab:	e8 65 f8 ff ff       	call   802515 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802cb0:	83 c7 01             	add    $0x1,%edi
  802cb3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802cb9:	0f 8c 67 ff ff ff    	jl     802c26 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  802cbf:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802cc4:	e9 86 00 00 00       	jmp    802d4f <_Z4openPKci+0x211>
  802cc9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802cce:	eb 7f                	jmp    802d4f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802cd0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802cd7:	74 0d                	je     802ce6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  802cde:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ce1:	e8 aa f6 ff ff       	call   802390 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802ce6:	8b 15 04 60 80 00    	mov    0x806004,%edx
  802cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cef:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802cf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  802cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfe:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802d01:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d04:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  802d0a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  802d0d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d11:	83 c0 10             	add    $0x10,%eax
  802d14:	89 04 24             	mov    %eax,(%esp)
  802d17:	e8 fe db ff ff       	call   80091a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  802d1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d1f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802d26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d29:	e8 e7 f7 ff ff       	call   802515 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  802d2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d31:	e8 df f7 ff ff       	call   802515 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d39:	89 04 24             	mov    %eax,(%esp)
  802d3c:	e8 13 ee ff ff       	call   801b54 <_Z6fd2numP2Fd>
  802d41:	89 c3                	mov    %eax,%ebx
  802d43:	eb 30                	jmp    802d75 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802d45:	e8 cb f7 ff ff       	call   802515 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  802d4a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  802d4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d52:	e8 be f7 ff ff       	call   802515 <_ZL11inode_closeP5Inode>
  802d57:	eb 05                	jmp    802d5e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802d59:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  802d5e:	a1 00 70 80 00       	mov    0x807000,%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d69:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d6d:	89 04 24             	mov    %eax,(%esp)
  802d70:	e8 48 e1 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802d75:	89 d8                	mov    %ebx,%eax
  802d77:	83 c4 3c             	add    $0x3c,%esp
  802d7a:	5b                   	pop    %ebx
  802d7b:	5e                   	pop    %esi
  802d7c:	5f                   	pop    %edi
  802d7d:	5d                   	pop    %ebp
  802d7e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  802d7f:	83 f8 78             	cmp    $0x78,%eax
  802d82:	0f 85 1d fe ff ff    	jne    802ba5 <_Z4openPKci+0x67>
  802d88:	eb cf                	jmp    802d59 <_Z4openPKci+0x21b>

00802d8a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
  802d8d:	53                   	push   %ebx
  802d8e:	83 ec 24             	sub    $0x24,%esp
  802d91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802d94:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	e8 78 f5 ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	78 27                	js     802dca <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802da3:	c7 44 24 04 48 4d 80 	movl   $0x804d48,0x4(%esp)
  802daa:	00 
  802dab:	89 1c 24             	mov    %ebx,(%esp)
  802dae:	e8 67 db ff ff       	call   80091a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802db3:	89 da                	mov    %ebx,%edx
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	e8 26 f4 ff ff       	call   8021e3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	e8 50 f7 ff ff       	call   802515 <_ZL11inode_closeP5Inode>
	return 0;
  802dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dca:	83 c4 24             	add    $0x24,%esp
  802dcd:	5b                   	pop    %ebx
  802dce:	5d                   	pop    %ebp
  802dcf:	c3                   	ret    

00802dd0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802dd0:	55                   	push   %ebp
  802dd1:	89 e5                	mov    %esp,%ebp
  802dd3:	53                   	push   %ebx
  802dd4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dde:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802de1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	e8 3a fb ff ff       	call   802926 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802dec:	89 c3                	mov    %eax,%ebx
  802dee:	85 c0                	test   %eax,%eax
  802df0:	78 5f                	js     802e51 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802df2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	e8 18 f5 ff ff       	call   802317 <_ZL10inode_openiPP5Inode>
  802dff:	89 c3                	mov    %eax,%ebx
  802e01:	85 c0                	test   %eax,%eax
  802e03:	78 44                	js     802e49 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802e05:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  802e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0d:	83 38 02             	cmpl   $0x2,(%eax)
  802e10:	74 2f                	je     802e41 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  802e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802e22:	ba 04 00 00 00       	mov    $0x4,%edx
  802e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2a:	e8 2c f4 ff ff       	call   80225b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  802e2f:	ba 04 00 00 00       	mov    $0x4,%edx
  802e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e37:	e8 1f f4 ff ff       	call   80225b <_ZL10bcache_ipcPvi>
	r = 0;
  802e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e44:	e8 cc f6 ff ff       	call   802515 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	e8 c4 f6 ff ff       	call   802515 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802e51:	89 d8                	mov    %ebx,%eax
  802e53:	83 c4 24             	add    $0x24,%esp
  802e56:	5b                   	pop    %ebx
  802e57:	5d                   	pop    %ebp
  802e58:	c3                   	ret    

00802e59 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802e59:	55                   	push   %ebp
  802e5a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  802e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e61:	5d                   	pop    %ebp
  802e62:	c3                   	ret    

00802e63 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802e63:	55                   	push   %ebp
  802e64:	89 e5                	mov    %esp,%ebp
  802e66:	57                   	push   %edi
  802e67:	56                   	push   %esi
  802e68:	53                   	push   %ebx
  802e69:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  802e6f:	c7 04 24 bd 25 80 00 	movl   $0x8025bd,(%esp)
  802e76:	e8 c0 14 00 00       	call   80433b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802e7b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802e80:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802e85:	74 28                	je     802eaf <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802e87:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802e8e:	4a 
  802e8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e93:	c7 44 24 08 b0 4d 80 	movl   $0x804db0,0x8(%esp)
  802e9a:	00 
  802e9b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802ea2:	00 
  802ea3:	c7 04 24 2a 4d 80 00 	movl   $0x804d2a,(%esp)
  802eaa:	e8 31 d3 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802eaf:	a1 04 10 00 50       	mov    0x50001004,%eax
  802eb4:	83 f8 03             	cmp    $0x3,%eax
  802eb7:	7f 1c                	jg     802ed5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802eb9:	c7 44 24 08 e4 4d 80 	movl   $0x804de4,0x8(%esp)
  802ec0:	00 
  802ec1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802ec8:	00 
  802ec9:	c7 04 24 2a 4d 80 00 	movl   $0x804d2a,(%esp)
  802ed0:	e8 0b d3 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802ed5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802edb:	85 d2                	test   %edx,%edx
  802edd:	7f 1c                	jg     802efb <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802edf:	c7 44 24 08 14 4e 80 	movl   $0x804e14,0x8(%esp)
  802ee6:	00 
  802ee7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802eee:	00 
  802eef:	c7 04 24 2a 4d 80 00 	movl   $0x804d2a,(%esp)
  802ef6:	e8 e5 d2 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802efb:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802f01:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802f07:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802f0d:	85 c9                	test   %ecx,%ecx
  802f0f:	0f 48 cb             	cmovs  %ebx,%ecx
  802f12:	c1 f9 0c             	sar    $0xc,%ecx
  802f15:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802f19:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802f1f:	39 c8                	cmp    %ecx,%eax
  802f21:	7c 13                	jl     802f36 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802f23:	85 c0                	test   %eax,%eax
  802f25:	7f 3d                	jg     802f64 <_Z4fsckv+0x101>
  802f27:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802f2e:	00 00 00 
  802f31:	e9 ac 00 00 00       	jmp    802fe2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802f36:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802f3c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802f40:	89 44 24 10          	mov    %eax,0x10(%esp)
  802f44:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802f48:	c7 44 24 08 44 4e 80 	movl   $0x804e44,0x8(%esp)
  802f4f:	00 
  802f50:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802f57:	00 
  802f58:	c7 04 24 2a 4d 80 00 	movl   $0x804d2a,(%esp)
  802f5f:	e8 7c d2 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802f64:	be 00 20 00 50       	mov    $0x50002000,%esi
  802f69:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802f70:	00 00 00 
  802f73:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f78:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802f7e:	39 df                	cmp    %ebx,%edi
  802f80:	7e 27                	jle    802fa9 <_Z4fsckv+0x146>
  802f82:	0f b6 06             	movzbl (%esi),%eax
  802f85:	84 c0                	test   %al,%al
  802f87:	74 4b                	je     802fd4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802f89:	0f be c0             	movsbl %al,%eax
  802f8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f94:	c7 04 24 88 4e 80 00 	movl   $0x804e88,(%esp)
  802f9b:	e8 5e d3 ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  802fa0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802fa7:	eb 2b                	jmp    802fd4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802fa9:	0f b6 06             	movzbl (%esi),%eax
  802fac:	3c 01                	cmp    $0x1,%al
  802fae:	76 24                	jbe    802fd4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802fb0:	0f be c0             	movsbl %al,%eax
  802fb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802fb7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802fbb:	c7 04 24 bc 4e 80 00 	movl   $0x804ebc,(%esp)
  802fc2:	e8 37 d3 ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  802fc7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802fce:	80 3e 00             	cmpb   $0x0,(%esi)
  802fd1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802fd4:	83 c3 01             	add    $0x1,%ebx
  802fd7:	83 c6 01             	add    $0x1,%esi
  802fda:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802fe0:	7f 9c                	jg     802f7e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802fe2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802fe9:	0f 8e e1 02 00 00    	jle    8032d0 <_Z4fsckv+0x46d>
  802fef:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802ff6:	00 00 00 
		struct Inode *ino = get_inode(i);
  802ff9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802fff:	e8 f9 f1 ff ff       	call   8021fd <_ZL9get_inodei>
  803004:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80300a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80300e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  803015:	75 22                	jne    803039 <_Z4fsckv+0x1d6>
  803017:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80301e:	0f 84 a9 06 00 00    	je     8036cd <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  803024:	ba 00 00 00 00       	mov    $0x0,%edx
  803029:	e8 2d f2 ff ff       	call   80225b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80302e:	85 c0                	test   %eax,%eax
  803030:	74 3a                	je     80306c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  803032:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  803039:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80303f:	8b 02                	mov    (%edx),%eax
  803041:	83 f8 01             	cmp    $0x1,%eax
  803044:	74 26                	je     80306c <_Z4fsckv+0x209>
  803046:	83 f8 02             	cmp    $0x2,%eax
  803049:	74 21                	je     80306c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80304b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80304f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803055:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803059:	c7 04 24 e8 4e 80 00 	movl   $0x804ee8,(%esp)
  803060:	e8 99 d2 ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  803065:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80306c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  803073:	75 3f                	jne    8030b4 <_Z4fsckv+0x251>
  803075:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80307b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80307f:	75 15                	jne    803096 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  803081:	c7 04 24 0c 4f 80 00 	movl   $0x804f0c,(%esp)
  803088:	e8 71 d2 ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  80308d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803094:	eb 1e                	jmp    8030b4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  803096:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80309c:	83 3a 02             	cmpl   $0x2,(%edx)
  80309f:	74 13                	je     8030b4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8030a1:	c7 04 24 40 4f 80 00 	movl   $0x804f40,(%esp)
  8030a8:	e8 51 d2 ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  8030ad:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  8030b4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  8030b9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8030c0:	0f 84 93 00 00 00    	je     803159 <_Z4fsckv+0x2f6>
  8030c6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8030cc:	8b 41 08             	mov    0x8(%ecx),%eax
  8030cf:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  8030d4:	7e 23                	jle    8030f9 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  8030d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030da:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8030e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030e4:	c7 04 24 70 4f 80 00 	movl   $0x804f70,(%esp)
  8030eb:	e8 0e d2 ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  8030f0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8030f7:	eb 09                	jmp    803102 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  8030f9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803100:	74 4b                	je     80314d <_Z4fsckv+0x2ea>
  803102:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803108:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80310e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  803114:	74 23                	je     803139 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  803116:	89 44 24 08          	mov    %eax,0x8(%esp)
  80311a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803120:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803124:	c7 04 24 94 4f 80 00 	movl   $0x804f94,(%esp)
  80312b:	e8 ce d1 ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  803130:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803137:	eb 09                	jmp    803142 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  803139:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803140:	74 12                	je     803154 <_Z4fsckv+0x2f1>
  803142:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803148:	8b 78 08             	mov    0x8(%eax),%edi
  80314b:	eb 0c                	jmp    803159 <_Z4fsckv+0x2f6>
  80314d:	bf 00 00 00 00       	mov    $0x0,%edi
  803152:	eb 05                	jmp    803159 <_Z4fsckv+0x2f6>
  803154:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  803159:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  80315e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803164:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  803168:	89 d8                	mov    %ebx,%eax
  80316a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  80316d:	39 c7                	cmp    %eax,%edi
  80316f:	7e 2b                	jle    80319c <_Z4fsckv+0x339>
  803171:	85 f6                	test   %esi,%esi
  803173:	75 27                	jne    80319c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  803175:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803179:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80317d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803183:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803187:	c7 04 24 b8 4f 80 00 	movl   $0x804fb8,(%esp)
  80318e:	e8 6b d1 ff ff       	call   8002fe <_Z7cprintfPKcz>
				++errors;
  803193:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80319a:	eb 36                	jmp    8031d2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  80319c:	39 f8                	cmp    %edi,%eax
  80319e:	7c 32                	jl     8031d2 <_Z4fsckv+0x36f>
  8031a0:	85 f6                	test   %esi,%esi
  8031a2:	74 2e                	je     8031d2 <_Z4fsckv+0x36f>
  8031a4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8031ab:	74 25                	je     8031d2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8031ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031b5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8031bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031bf:	c7 04 24 fc 4f 80 00 	movl   $0x804ffc,(%esp)
  8031c6:	e8 33 d1 ff ff       	call   8002fe <_Z7cprintfPKcz>
				++errors;
  8031cb:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  8031d2:	85 f6                	test   %esi,%esi
  8031d4:	0f 84 a0 00 00 00    	je     80327a <_Z4fsckv+0x417>
  8031da:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8031e1:	0f 84 93 00 00 00    	je     80327a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  8031e7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8031ed:	7e 27                	jle    803216 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  8031ef:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8031f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031f7:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  8031fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  803201:	c7 04 24 40 50 80 00 	movl   $0x805040,(%esp)
  803208:	e8 f1 d0 ff ff       	call   8002fe <_Z7cprintfPKcz>
					++errors;
  80320d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803214:	eb 64                	jmp    80327a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  803216:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80321d:	3c 01                	cmp    $0x1,%al
  80321f:	75 27                	jne    803248 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  803221:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803225:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803229:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  80322f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803233:	c7 04 24 84 50 80 00 	movl   $0x805084,(%esp)
  80323a:	e8 bf d0 ff ff       	call   8002fe <_Z7cprintfPKcz>
					++errors;
  80323f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803246:	eb 32                	jmp    80327a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  803248:	3c ff                	cmp    $0xff,%al
  80324a:	75 27                	jne    803273 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  80324c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803250:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803254:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80325a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80325e:	c7 04 24 c0 50 80 00 	movl   $0x8050c0,(%esp)
  803265:	e8 94 d0 ff ff       	call   8002fe <_Z7cprintfPKcz>
					++errors;
  80326a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803271:	eb 07                	jmp    80327a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  803273:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  80327a:	83 c3 01             	add    $0x1,%ebx
  80327d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  803283:	0f 85 d5 fe ff ff    	jne    80315e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  803289:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  803290:	0f 94 c0             	sete   %al
  803293:	0f b6 c0             	movzbl %al,%eax
  803296:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80329c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  8032a2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  8032a9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  8032b0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8032b7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  8032be:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8032c4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  8032ca:	0f 8f 29 fd ff ff    	jg     802ff9 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8032d0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8032d7:	0f 8e 7f 03 00 00    	jle    80365c <_Z4fsckv+0x7f9>
  8032dd:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  8032e2:	89 f0                	mov    %esi,%eax
  8032e4:	e8 14 ef ff ff       	call   8021fd <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  8032e9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8032f0:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  8032f7:	c1 e2 08             	shl    $0x8,%edx
  8032fa:	09 ca                	or     %ecx,%edx
  8032fc:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803303:	c1 e1 10             	shl    $0x10,%ecx
  803306:	09 ca                	or     %ecx,%edx
  803308:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  80330f:	83 e1 7f             	and    $0x7f,%ecx
  803312:	c1 e1 18             	shl    $0x18,%ecx
  803315:	09 d1                	or     %edx,%ecx
  803317:	74 0e                	je     803327 <_Z4fsckv+0x4c4>
  803319:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803320:	78 05                	js     803327 <_Z4fsckv+0x4c4>
  803322:	83 38 02             	cmpl   $0x2,(%eax)
  803325:	74 1f                	je     803346 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803327:	83 c6 01             	add    $0x1,%esi
  80332a:	a1 08 10 00 50       	mov    0x50001008,%eax
  80332f:	39 f0                	cmp    %esi,%eax
  803331:	7f af                	jg     8032e2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803333:	bb 01 00 00 00       	mov    $0x1,%ebx
  803338:	83 f8 01             	cmp    $0x1,%eax
  80333b:	0f 8f ad 02 00 00    	jg     8035ee <_Z4fsckv+0x78b>
  803341:	e9 16 03 00 00       	jmp    80365c <_Z4fsckv+0x7f9>
  803346:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  803348:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  80334f:	8b 40 08             	mov    0x8(%eax),%eax
  803352:	a8 7f                	test   $0x7f,%al
  803354:	74 23                	je     803379 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  803356:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  80335d:	00 
  80335e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803362:	89 74 24 04          	mov    %esi,0x4(%esp)
  803366:	c7 04 24 fc 50 80 00 	movl   $0x8050fc,(%esp)
  80336d:	e8 8c cf ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  803372:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803379:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  803380:	00 00 00 
  803383:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  803389:	e9 3d 02 00 00       	jmp    8035cb <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  80338e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803394:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80339a:	e8 01 ee ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
  80339f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  8033a1:	83 38 00             	cmpl   $0x0,(%eax)
  8033a4:	0f 84 15 02 00 00    	je     8035bf <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  8033aa:	8b 40 04             	mov    0x4(%eax),%eax
  8033ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033b0:	83 fa 76             	cmp    $0x76,%edx
  8033b3:	76 27                	jbe    8033dc <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  8033b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033b9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8033bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8033c7:	c7 04 24 30 51 80 00 	movl   $0x805130,(%esp)
  8033ce:	e8 2b cf ff ff       	call   8002fe <_Z7cprintfPKcz>
				++errors;
  8033d3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8033da:	eb 28                	jmp    803404 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  8033dc:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  8033e1:	74 21                	je     803404 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  8033e3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8033e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8033ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8033f1:	c7 04 24 5c 51 80 00 	movl   $0x80515c,(%esp)
  8033f8:	e8 01 cf ff ff       	call   8002fe <_Z7cprintfPKcz>
				++errors;
  8033fd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803404:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  80340b:	00 
  80340c:	8d 43 08             	lea    0x8(%ebx),%eax
  80340f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803413:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803419:	89 0c 24             	mov    %ecx,(%esp)
  80341c:	e8 16 d7 ff ff       	call   800b37 <memcpy>
  803421:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803425:	bf 77 00 00 00       	mov    $0x77,%edi
  80342a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80342e:	85 ff                	test   %edi,%edi
  803430:	b8 00 00 00 00       	mov    $0x0,%eax
  803435:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803438:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80343f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803440:	8b 03                	mov    (%ebx),%eax
  803442:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803448:	7c 3e                	jl     803488 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80344a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80344e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803454:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803458:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80345e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803462:	89 74 24 04          	mov    %esi,0x4(%esp)
  803466:	c7 04 24 90 51 80 00 	movl   $0x805190,(%esp)
  80346d:	e8 8c ce ff ff       	call   8002fe <_Z7cprintfPKcz>
				++errors;
  803472:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803479:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  803480:	00 00 00 
  803483:	e9 0b 01 00 00       	jmp    803593 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  803488:	e8 70 ed ff ff       	call   8021fd <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  80348d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803494:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  80349b:	c1 e2 08             	shl    $0x8,%edx
  80349e:	09 d1                	or     %edx,%ecx
  8034a0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  8034a7:	c1 e2 10             	shl    $0x10,%edx
  8034aa:	09 d1                	or     %edx,%ecx
  8034ac:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  8034b3:	83 e2 7f             	and    $0x7f,%edx
  8034b6:	c1 e2 18             	shl    $0x18,%edx
  8034b9:	09 ca                	or     %ecx,%edx
  8034bb:	83 c2 01             	add    $0x1,%edx
  8034be:	89 d1                	mov    %edx,%ecx
  8034c0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  8034c6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  8034cc:	0f b6 d5             	movzbl %ch,%edx
  8034cf:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  8034d5:	89 ca                	mov    %ecx,%edx
  8034d7:	c1 ea 10             	shr    $0x10,%edx
  8034da:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  8034e0:	c1 e9 18             	shr    $0x18,%ecx
  8034e3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  8034ea:	83 e2 80             	and    $0xffffff80,%edx
  8034ed:	09 ca                	or     %ecx,%edx
  8034ef:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  8034f5:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8034f9:	0f 85 7a ff ff ff    	jne    803479 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  8034ff:	8b 03                	mov    (%ebx),%eax
  803501:	89 44 24 10          	mov    %eax,0x10(%esp)
  803505:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80350b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80350f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803515:	89 44 24 08          	mov    %eax,0x8(%esp)
  803519:	89 74 24 04          	mov    %esi,0x4(%esp)
  80351d:	c7 04 24 c0 51 80 00 	movl   $0x8051c0,(%esp)
  803524:	e8 d5 cd ff ff       	call   8002fe <_Z7cprintfPKcz>
					++errors;
  803529:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803530:	e9 44 ff ff ff       	jmp    803479 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803535:	3b 78 04             	cmp    0x4(%eax),%edi
  803538:	75 52                	jne    80358c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  80353a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80353e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803544:	89 54 24 04          	mov    %edx,0x4(%esp)
  803548:	83 c0 08             	add    $0x8,%eax
  80354b:	89 04 24             	mov    %eax,(%esp)
  80354e:	e8 25 d6 ff ff       	call   800b78 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803553:	85 c0                	test   %eax,%eax
  803555:	75 35                	jne    80358c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  803557:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80355d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803561:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803567:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80356b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803571:	89 54 24 08          	mov    %edx,0x8(%esp)
  803575:	89 74 24 04          	mov    %esi,0x4(%esp)
  803579:	c7 04 24 f0 51 80 00 	movl   $0x8051f0,(%esp)
  803580:	e8 79 cd ff ff       	call   8002fe <_Z7cprintfPKcz>
					++errors;
  803585:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80358c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  803593:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803599:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  80359f:	7e 1e                	jle    8035bf <_Z4fsckv+0x75c>
  8035a1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  8035a5:	7f 18                	jg     8035bf <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  8035a7:	89 ca                	mov    %ecx,%edx
  8035a9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8035af:	e8 ec eb ff ff       	call   8021a0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  8035b4:	83 38 00             	cmpl   $0x0,(%eax)
  8035b7:	0f 85 78 ff ff ff    	jne    803535 <_Z4fsckv+0x6d2>
  8035bd:	eb cd                	jmp    80358c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  8035bf:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8035c5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8035cb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8035d1:	83 ea 80             	sub    $0xffffff80,%edx
  8035d4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  8035da:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8035e0:	3b 51 08             	cmp    0x8(%ecx),%edx
  8035e3:	0f 8f e7 fc ff ff    	jg     8032d0 <_Z4fsckv+0x46d>
  8035e9:	e9 a0 fd ff ff       	jmp    80338e <_Z4fsckv+0x52b>
  8035ee:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  8035f4:	89 d8                	mov    %ebx,%eax
  8035f6:	e8 02 ec ff ff       	call   8021fd <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  8035fb:	8b 50 04             	mov    0x4(%eax),%edx
  8035fe:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803605:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80360c:	c1 e7 08             	shl    $0x8,%edi
  80360f:	09 f9                	or     %edi,%ecx
  803611:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803618:	c1 e7 10             	shl    $0x10,%edi
  80361b:	09 f9                	or     %edi,%ecx
  80361d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803624:	83 e7 7f             	and    $0x7f,%edi
  803627:	c1 e7 18             	shl    $0x18,%edi
  80362a:	09 f9                	or     %edi,%ecx
  80362c:	39 ca                	cmp    %ecx,%edx
  80362e:	74 1b                	je     80364b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803630:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803634:	89 54 24 08          	mov    %edx,0x8(%esp)
  803638:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80363c:	c7 04 24 20 52 80 00 	movl   $0x805220,(%esp)
  803643:	e8 b6 cc ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  803648:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80364b:	83 c3 01             	add    $0x1,%ebx
  80364e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  803654:	7f 9e                	jg     8035f4 <_Z4fsckv+0x791>
  803656:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  80365c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  803663:	7e 4f                	jle    8036b4 <_Z4fsckv+0x851>
  803665:	bb 00 00 00 00       	mov    $0x0,%ebx
  80366a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  803670:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  803677:	3c ff                	cmp    $0xff,%al
  803679:	75 09                	jne    803684 <_Z4fsckv+0x821>
			freemap[i] = 0;
  80367b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803682:	eb 1f                	jmp    8036a3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803684:	84 c0                	test   %al,%al
  803686:	75 1b                	jne    8036a3 <_Z4fsckv+0x840>
  803688:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80368e:	7c 13                	jl     8036a3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803690:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803694:	c7 04 24 4c 52 80 00 	movl   $0x80524c,(%esp)
  80369b:	e8 5e cc ff ff       	call   8002fe <_Z7cprintfPKcz>
			++errors;
  8036a0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8036a3:	83 c3 01             	add    $0x1,%ebx
  8036a6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8036ac:	7f c2                	jg     803670 <_Z4fsckv+0x80d>
  8036ae:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  8036b4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  8036bb:	19 c0                	sbb    %eax,%eax
  8036bd:	f7 d0                	not    %eax
  8036bf:	83 e0 fd             	and    $0xfffffffd,%eax
}
  8036c2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  8036c8:	5b                   	pop    %ebx
  8036c9:	5e                   	pop    %esi
  8036ca:	5f                   	pop    %edi
  8036cb:	5d                   	pop    %ebp
  8036cc:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  8036cd:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8036d4:	0f 84 92 f9 ff ff    	je     80306c <_Z4fsckv+0x209>
  8036da:	e9 5a f9 ff ff       	jmp    803039 <_Z4fsckv+0x1d6>
	...

008036e0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8036e0:	55                   	push   %ebp
  8036e1:	89 e5                	mov    %esp,%ebp
  8036e3:	83 ec 18             	sub    $0x18,%esp
  8036e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8036e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8036ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f2:	89 04 24             	mov    %eax,(%esp)
  8036f5:	e8 a2 e4 ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  8036fa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8036fc:	c7 44 24 04 7f 52 80 	movl   $0x80527f,0x4(%esp)
  803703:	00 
  803704:	89 34 24             	mov    %esi,(%esp)
  803707:	e8 0e d2 ff ff       	call   80091a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80370c:	8b 43 04             	mov    0x4(%ebx),%eax
  80370f:	2b 03                	sub    (%ebx),%eax
  803711:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803714:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80371b:	c7 86 80 00 00 00 20 	movl   $0x806020,0x80(%esi)
  803722:	60 80 00 
	return 0;
}
  803725:	b8 00 00 00 00       	mov    $0x0,%eax
  80372a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80372d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803730:	89 ec                	mov    %ebp,%esp
  803732:	5d                   	pop    %ebp
  803733:	c3                   	ret    

00803734 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803734:	55                   	push   %ebp
  803735:	89 e5                	mov    %esp,%ebp
  803737:	53                   	push   %ebx
  803738:	83 ec 14             	sub    $0x14,%esp
  80373b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80373e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803742:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803749:	e8 6f d7 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80374e:	89 1c 24             	mov    %ebx,(%esp)
  803751:	e8 46 e4 ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  803756:	89 44 24 04          	mov    %eax,0x4(%esp)
  80375a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803761:	e8 57 d7 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
}
  803766:	83 c4 14             	add    $0x14,%esp
  803769:	5b                   	pop    %ebx
  80376a:	5d                   	pop    %ebp
  80376b:	c3                   	ret    

0080376c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80376c:	55                   	push   %ebp
  80376d:	89 e5                	mov    %esp,%ebp
  80376f:	57                   	push   %edi
  803770:	56                   	push   %esi
  803771:	53                   	push   %ebx
  803772:	83 ec 2c             	sub    $0x2c,%esp
  803775:	89 c7                	mov    %eax,%edi
  803777:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80377a:	a1 00 70 80 00       	mov    0x807000,%eax
  80377f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803782:	89 3c 24             	mov    %edi,(%esp)
  803785:	e8 82 04 00 00       	call   803c0c <_Z7pagerefPv>
  80378a:	89 c3                	mov    %eax,%ebx
  80378c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378f:	89 04 24             	mov    %eax,(%esp)
  803792:	e8 75 04 00 00       	call   803c0c <_Z7pagerefPv>
  803797:	39 c3                	cmp    %eax,%ebx
  803799:	0f 94 c0             	sete   %al
  80379c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80379f:	8b 15 00 70 80 00    	mov    0x807000,%edx
  8037a5:	8b 52 58             	mov    0x58(%edx),%edx
  8037a8:	39 d6                	cmp    %edx,%esi
  8037aa:	75 08                	jne    8037b4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  8037ac:	83 c4 2c             	add    $0x2c,%esp
  8037af:	5b                   	pop    %ebx
  8037b0:	5e                   	pop    %esi
  8037b1:	5f                   	pop    %edi
  8037b2:	5d                   	pop    %ebp
  8037b3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  8037b4:	85 c0                	test   %eax,%eax
  8037b6:	74 c2                	je     80377a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  8037b8:	c7 04 24 86 52 80 00 	movl   $0x805286,(%esp)
  8037bf:	e8 3a cb ff ff       	call   8002fe <_Z7cprintfPKcz>
  8037c4:	eb b4                	jmp    80377a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

008037c6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037c6:	55                   	push   %ebp
  8037c7:	89 e5                	mov    %esp,%ebp
  8037c9:	57                   	push   %edi
  8037ca:	56                   	push   %esi
  8037cb:	53                   	push   %ebx
  8037cc:	83 ec 1c             	sub    $0x1c,%esp
  8037cf:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8037d2:	89 34 24             	mov    %esi,(%esp)
  8037d5:	e8 c2 e3 ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  8037da:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8037dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8037e5:	75 46                	jne    80382d <_ZL13devpipe_writeP2FdPKvj+0x67>
  8037e7:	eb 52                	jmp    80383b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  8037e9:	89 da                	mov    %ebx,%edx
  8037eb:	89 f0                	mov    %esi,%eax
  8037ed:	e8 7a ff ff ff       	call   80376c <_ZL13_pipeisclosedP2FdP4Pipe>
  8037f2:	85 c0                	test   %eax,%eax
  8037f4:	75 49                	jne    80383f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  8037f6:	e8 d1 d5 ff ff       	call   800dcc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8037fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8037fe:	89 c2                	mov    %eax,%edx
  803800:	2b 13                	sub    (%ebx),%edx
  803802:	83 fa 20             	cmp    $0x20,%edx
  803805:	74 e2                	je     8037e9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803807:	89 c2                	mov    %eax,%edx
  803809:	c1 fa 1f             	sar    $0x1f,%edx
  80380c:	c1 ea 1b             	shr    $0x1b,%edx
  80380f:	01 d0                	add    %edx,%eax
  803811:	83 e0 1f             	and    $0x1f,%eax
  803814:	29 d0                	sub    %edx,%eax
  803816:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803819:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80381d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803821:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803825:	83 c7 01             	add    $0x1,%edi
  803828:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80382b:	76 0e                	jbe    80383b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80382d:	8b 43 04             	mov    0x4(%ebx),%eax
  803830:	89 c2                	mov    %eax,%edx
  803832:	2b 13                	sub    (%ebx),%edx
  803834:	83 fa 20             	cmp    $0x20,%edx
  803837:	74 b0                	je     8037e9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803839:	eb cc                	jmp    803807 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80383b:	89 f8                	mov    %edi,%eax
  80383d:	eb 05                	jmp    803844 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80383f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803844:	83 c4 1c             	add    $0x1c,%esp
  803847:	5b                   	pop    %ebx
  803848:	5e                   	pop    %esi
  803849:	5f                   	pop    %edi
  80384a:	5d                   	pop    %ebp
  80384b:	c3                   	ret    

0080384c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80384c:	55                   	push   %ebp
  80384d:	89 e5                	mov    %esp,%ebp
  80384f:	83 ec 28             	sub    $0x28,%esp
  803852:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803855:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803858:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80385b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80385e:	89 3c 24             	mov    %edi,(%esp)
  803861:	e8 36 e3 ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  803866:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803868:	be 00 00 00 00       	mov    $0x0,%esi
  80386d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803871:	75 47                	jne    8038ba <_ZL12devpipe_readP2FdPvj+0x6e>
  803873:	eb 52                	jmp    8038c7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803875:	89 f0                	mov    %esi,%eax
  803877:	eb 5e                	jmp    8038d7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803879:	89 da                	mov    %ebx,%edx
  80387b:	89 f8                	mov    %edi,%eax
  80387d:	8d 76 00             	lea    0x0(%esi),%esi
  803880:	e8 e7 fe ff ff       	call   80376c <_ZL13_pipeisclosedP2FdP4Pipe>
  803885:	85 c0                	test   %eax,%eax
  803887:	75 49                	jne    8038d2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803889:	e8 3e d5 ff ff       	call   800dcc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80388e:	8b 03                	mov    (%ebx),%eax
  803890:	3b 43 04             	cmp    0x4(%ebx),%eax
  803893:	74 e4                	je     803879 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803895:	89 c2                	mov    %eax,%edx
  803897:	c1 fa 1f             	sar    $0x1f,%edx
  80389a:	c1 ea 1b             	shr    $0x1b,%edx
  80389d:	01 d0                	add    %edx,%eax
  80389f:	83 e0 1f             	and    $0x1f,%eax
  8038a2:	29 d0                	sub    %edx,%eax
  8038a4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8038a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038ac:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8038af:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8038b2:	83 c6 01             	add    $0x1,%esi
  8038b5:	39 75 10             	cmp    %esi,0x10(%ebp)
  8038b8:	76 0d                	jbe    8038c7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8038ba:	8b 03                	mov    (%ebx),%eax
  8038bc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8038bf:	75 d4                	jne    803895 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8038c1:	85 f6                	test   %esi,%esi
  8038c3:	75 b0                	jne    803875 <_ZL12devpipe_readP2FdPvj+0x29>
  8038c5:	eb b2                	jmp    803879 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8038c7:	89 f0                	mov    %esi,%eax
  8038c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8038d0:	eb 05                	jmp    8038d7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8038d2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8038d7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8038da:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8038dd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8038e0:	89 ec                	mov    %ebp,%esp
  8038e2:	5d                   	pop    %ebp
  8038e3:	c3                   	ret    

008038e4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8038e4:	55                   	push   %ebp
  8038e5:	89 e5                	mov    %esp,%ebp
  8038e7:	83 ec 48             	sub    $0x48,%esp
  8038ea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8038ed:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8038f0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8038f3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  8038f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8038f9:	89 04 24             	mov    %eax,(%esp)
  8038fc:	e8 b6 e2 ff ff       	call   801bb7 <_Z14fd_find_unusedPP2Fd>
  803901:	89 c3                	mov    %eax,%ebx
  803903:	85 c0                	test   %eax,%eax
  803905:	0f 88 0b 01 00 00    	js     803a16 <_Z4pipePi+0x132>
  80390b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803912:	00 
  803913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803916:	89 44 24 04          	mov    %eax,0x4(%esp)
  80391a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803921:	e8 da d4 ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  803926:	89 c3                	mov    %eax,%ebx
  803928:	85 c0                	test   %eax,%eax
  80392a:	0f 89 f5 00 00 00    	jns    803a25 <_Z4pipePi+0x141>
  803930:	e9 e1 00 00 00       	jmp    803a16 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803935:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80393c:	00 
  80393d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803940:	89 44 24 04          	mov    %eax,0x4(%esp)
  803944:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80394b:	e8 b0 d4 ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  803950:	89 c3                	mov    %eax,%ebx
  803952:	85 c0                	test   %eax,%eax
  803954:	0f 89 e2 00 00 00    	jns    803a3c <_Z4pipePi+0x158>
  80395a:	e9 a4 00 00 00       	jmp    803a03 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80395f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803962:	89 04 24             	mov    %eax,(%esp)
  803965:	e8 32 e2 ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  80396a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803971:	00 
  803972:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803976:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80397d:	00 
  80397e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803982:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803989:	e8 d1 d4 ff ff       	call   800e5f <_Z12sys_page_mapiPviS_i>
  80398e:	89 c3                	mov    %eax,%ebx
  803990:	85 c0                	test   %eax,%eax
  803992:	78 4c                	js     8039e0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803994:	8b 15 20 60 80 00    	mov    0x806020,%edx
  80399a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80399f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8039a9:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8039af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8039b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8039be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c1:	89 04 24             	mov    %eax,(%esp)
  8039c4:	e8 8b e1 ff ff       	call   801b54 <_Z6fd2numP2Fd>
  8039c9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8039cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ce:	89 04 24             	mov    %eax,(%esp)
  8039d1:	e8 7e e1 ff ff       	call   801b54 <_Z6fd2numP2Fd>
  8039d6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8039d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8039de:	eb 36                	jmp    803a16 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  8039e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8039e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039eb:	e8 cd d4 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  8039f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039fe:	e8 ba d4 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a06:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a11:	e8 a7 d4 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803a16:	89 d8                	mov    %ebx,%eax
  803a18:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803a1b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803a1e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803a21:	89 ec                	mov    %ebp,%esp
  803a23:	5d                   	pop    %ebp
  803a24:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803a25:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803a28:	89 04 24             	mov    %eax,(%esp)
  803a2b:	e8 87 e1 ff ff       	call   801bb7 <_Z14fd_find_unusedPP2Fd>
  803a30:	89 c3                	mov    %eax,%ebx
  803a32:	85 c0                	test   %eax,%eax
  803a34:	0f 89 fb fe ff ff    	jns    803935 <_Z4pipePi+0x51>
  803a3a:	eb c7                	jmp    803a03 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3f:	89 04 24             	mov    %eax,(%esp)
  803a42:	e8 55 e1 ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  803a47:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a49:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803a50:	00 
  803a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a5c:	e8 9f d3 ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  803a61:	89 c3                	mov    %eax,%ebx
  803a63:	85 c0                	test   %eax,%eax
  803a65:	0f 89 f4 fe ff ff    	jns    80395f <_Z4pipePi+0x7b>
  803a6b:	eb 83                	jmp    8039f0 <_Z4pipePi+0x10c>

00803a6d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  803a6d:	55                   	push   %ebp
  803a6e:	89 e5                	mov    %esp,%ebp
  803a70:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803a73:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803a7a:	00 
  803a7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a82:	8b 45 08             	mov    0x8(%ebp),%eax
  803a85:	89 04 24             	mov    %eax,(%esp)
  803a88:	e8 74 e0 ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  803a8d:	85 c0                	test   %eax,%eax
  803a8f:	78 15                	js     803aa6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a94:	89 04 24             	mov    %eax,(%esp)
  803a97:	e8 00 e1 ff ff       	call   801b9c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  803a9c:	89 c2                	mov    %eax,%edx
  803a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa1:	e8 c6 fc ff ff       	call   80376c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803aa6:	c9                   	leave  
  803aa7:	c3                   	ret    

00803aa8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803aa8:	55                   	push   %ebp
  803aa9:	89 e5                	mov    %esp,%ebp
  803aab:	53                   	push   %ebx
  803aac:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  803aaf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ab2:	89 04 24             	mov    %eax,(%esp)
  803ab5:	e8 fd e0 ff ff       	call   801bb7 <_Z14fd_find_unusedPP2Fd>
  803aba:	89 c3                	mov    %eax,%ebx
  803abc:	85 c0                	test   %eax,%eax
  803abe:	0f 88 be 00 00 00    	js     803b82 <_Z18pipe_ipc_recv_readv+0xda>
  803ac4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803acb:	00 
  803acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ad3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ada:	e8 21 d3 ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  803adf:	89 c3                	mov    %eax,%ebx
  803ae1:	85 c0                	test   %eax,%eax
  803ae3:	0f 89 a1 00 00 00    	jns    803b8a <_Z18pipe_ipc_recv_readv+0xe2>
  803ae9:	e9 94 00 00 00       	jmp    803b82 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  803aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af1:	85 c0                	test   %eax,%eax
  803af3:	75 0e                	jne    803b03 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803af5:	c7 04 24 e4 52 80 00 	movl   $0x8052e4,(%esp)
  803afc:	e8 fd c7 ff ff       	call   8002fe <_Z7cprintfPKcz>
  803b01:	eb 10                	jmp    803b13 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b07:	c7 04 24 99 52 80 00 	movl   $0x805299,(%esp)
  803b0e:	e8 eb c7 ff ff       	call   8002fe <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803b13:	c7 04 24 a3 52 80 00 	movl   $0x8052a3,(%esp)
  803b1a:	e8 df c7 ff ff       	call   8002fe <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  803b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b22:	a8 04                	test   $0x4,%al
  803b24:	74 04                	je     803b2a <_Z18pipe_ipc_recv_readv+0x82>
  803b26:	a8 01                	test   $0x1,%al
  803b28:	75 24                	jne    803b4e <_Z18pipe_ipc_recv_readv+0xa6>
  803b2a:	c7 44 24 0c b6 52 80 	movl   $0x8052b6,0xc(%esp)
  803b31:	00 
  803b32:	c7 44 24 08 4e 4c 80 	movl   $0x804c4e,0x8(%esp)
  803b39:	00 
  803b3a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803b41:	00 
  803b42:	c7 04 24 d3 52 80 00 	movl   $0x8052d3,(%esp)
  803b49:	e8 92 c6 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  803b4e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  803b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b57:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803b63:	89 04 24             	mov    %eax,(%esp)
  803b66:	e8 e9 df ff ff       	call   801b54 <_Z6fd2numP2Fd>
  803b6b:	89 c3                	mov    %eax,%ebx
  803b6d:	eb 13                	jmp    803b82 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  803b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b7d:	e8 3b d3 ff ff       	call   800ebd <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803b82:	89 d8                	mov    %ebx,%eax
  803b84:	83 c4 24             	add    $0x24,%esp
  803b87:	5b                   	pop    %ebx
  803b88:	5d                   	pop    %ebp
  803b89:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  803b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8d:	89 04 24             	mov    %eax,(%esp)
  803b90:	e8 07 e0 ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  803b95:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803b98:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ba0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803ba3:	89 04 24             	mov    %eax,(%esp)
  803ba6:	e8 85 08 00 00       	call   804430 <_Z8ipc_recvPiPvS_>
  803bab:	89 c3                	mov    %eax,%ebx
  803bad:	85 c0                	test   %eax,%eax
  803baf:	0f 89 39 ff ff ff    	jns    803aee <_Z18pipe_ipc_recv_readv+0x46>
  803bb5:	eb b8                	jmp    803b6f <_Z18pipe_ipc_recv_readv+0xc7>

00803bb7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803bb7:	55                   	push   %ebp
  803bb8:	89 e5                	mov    %esp,%ebp
  803bba:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  803bbd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803bc4:	00 
  803bc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bcf:	89 04 24             	mov    %eax,(%esp)
  803bd2:	e8 2a df ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  803bd7:	85 c0                	test   %eax,%eax
  803bd9:	78 2f                	js     803c0a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  803bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bde:	89 04 24             	mov    %eax,(%esp)
  803be1:	e8 b6 df ff ff       	call   801b9c <_Z7fd2dataP2Fd>
  803be6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803bed:	00 
  803bee:	89 44 24 08          	mov    %eax,0x8(%esp)
  803bf2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803bf9:	00 
  803bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfd:	89 04 24             	mov    %eax,(%esp)
  803c00:	e8 ba 08 00 00       	call   8044bf <_Z8ipc_sendijPvi>
    return 0;
  803c05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c0a:	c9                   	leave  
  803c0b:	c3                   	ret    

00803c0c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c0c:	55                   	push   %ebp
  803c0d:	89 e5                	mov    %esp,%ebp
  803c0f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803c12:	89 d0                	mov    %edx,%eax
  803c14:	c1 e8 16             	shr    $0x16,%eax
  803c17:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  803c1e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803c23:	f6 c1 01             	test   $0x1,%cl
  803c26:	74 1d                	je     803c45 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803c28:	c1 ea 0c             	shr    $0xc,%edx
  803c2b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803c32:	f6 c2 01             	test   $0x1,%dl
  803c35:	74 0e                	je     803c45 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803c37:	c1 ea 0c             	shr    $0xc,%edx
  803c3a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803c41:	ef 
  803c42:	0f b7 c0             	movzwl %ax,%eax
}
  803c45:	5d                   	pop    %ebp
  803c46:	c3                   	ret    
	...

00803c50 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803c50:	55                   	push   %ebp
  803c51:	89 e5                	mov    %esp,%ebp
  803c53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803c56:	c7 44 24 04 07 53 80 	movl   $0x805307,0x4(%esp)
  803c5d:	00 
  803c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c61:	89 04 24             	mov    %eax,(%esp)
  803c64:	e8 b1 cc ff ff       	call   80091a <_Z6strcpyPcPKc>
	return 0;
}
  803c69:	b8 00 00 00 00       	mov    $0x0,%eax
  803c6e:	c9                   	leave  
  803c6f:	c3                   	ret    

00803c70 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803c70:	55                   	push   %ebp
  803c71:	89 e5                	mov    %esp,%ebp
  803c73:	53                   	push   %ebx
  803c74:	83 ec 14             	sub    $0x14,%esp
  803c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803c7a:	89 1c 24             	mov    %ebx,(%esp)
  803c7d:	e8 8a ff ff ff       	call   803c0c <_Z7pagerefPv>
  803c82:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803c84:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803c89:	83 fa 01             	cmp    $0x1,%edx
  803c8c:	75 0b                	jne    803c99 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  803c8e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803c91:	89 04 24             	mov    %eax,(%esp)
  803c94:	e8 fe 02 00 00       	call   803f97 <_Z11nsipc_closei>
	else
		return 0;
}
  803c99:	83 c4 14             	add    $0x14,%esp
  803c9c:	5b                   	pop    %ebx
  803c9d:	5d                   	pop    %ebp
  803c9e:	c3                   	ret    

00803c9f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803c9f:	55                   	push   %ebp
  803ca0:	89 e5                	mov    %esp,%ebp
  803ca2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803ca5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803cac:	00 
  803cad:	8b 45 10             	mov    0x10(%ebp),%eax
  803cb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  803cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  803cc1:	89 04 24             	mov    %eax,(%esp)
  803cc4:	e8 c9 03 00 00       	call   804092 <_Z10nsipc_sendiPKvij>
}
  803cc9:	c9                   	leave  
  803cca:	c3                   	ret    

00803ccb <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803ccb:	55                   	push   %ebp
  803ccc:	89 e5                	mov    %esp,%ebp
  803cce:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803cd1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803cd8:	00 
  803cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  803cdc:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cea:	8b 40 0c             	mov    0xc(%eax),%eax
  803ced:	89 04 24             	mov    %eax,(%esp)
  803cf0:	e8 1d 03 00 00       	call   804012 <_Z10nsipc_recviPvij>
}
  803cf5:	c9                   	leave  
  803cf6:	c3                   	ret    

00803cf7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803cf7:	55                   	push   %ebp
  803cf8:	89 e5                	mov    %esp,%ebp
  803cfa:	83 ec 28             	sub    $0x28,%esp
  803cfd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803d00:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803d03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803d05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803d08:	89 04 24             	mov    %eax,(%esp)
  803d0b:	e8 a7 de ff ff       	call   801bb7 <_Z14fd_find_unusedPP2Fd>
  803d10:	89 c3                	mov    %eax,%ebx
  803d12:	85 c0                	test   %eax,%eax
  803d14:	78 21                	js     803d37 <_ZL12alloc_sockfdi+0x40>
  803d16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803d1d:	00 
  803d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d2c:	e8 cf d0 ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  803d31:	89 c3                	mov    %eax,%ebx
  803d33:	85 c0                	test   %eax,%eax
  803d35:	79 14                	jns    803d4b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803d37:	89 34 24             	mov    %esi,(%esp)
  803d3a:	e8 58 02 00 00       	call   803f97 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803d3f:	89 d8                	mov    %ebx,%eax
  803d41:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803d44:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803d47:	89 ec                	mov    %ebp,%esp
  803d49:	5d                   	pop    %ebp
  803d4a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803d4b:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  803d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d54:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d59:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803d60:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803d63:	89 04 24             	mov    %eax,(%esp)
  803d66:	e8 e9 dd ff ff       	call   801b54 <_Z6fd2numP2Fd>
  803d6b:	89 c3                	mov    %eax,%ebx
  803d6d:	eb d0                	jmp    803d3f <_ZL12alloc_sockfdi+0x48>

00803d6f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803d6f:	55                   	push   %ebp
  803d70:	89 e5                	mov    %esp,%ebp
  803d72:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803d75:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803d7c:	00 
  803d7d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803d80:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d84:	89 04 24             	mov    %eax,(%esp)
  803d87:	e8 75 dd ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  803d8c:	85 c0                	test   %eax,%eax
  803d8e:	78 15                	js     803da5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803d90:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803d93:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803d98:	8b 0d 3c 60 80 00    	mov    0x80603c,%ecx
  803d9e:	39 0a                	cmp    %ecx,(%edx)
  803da0:	75 03                	jne    803da5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803da2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803da5:	c9                   	leave  
  803da6:	c3                   	ret    

00803da7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803da7:	55                   	push   %ebp
  803da8:	89 e5                	mov    %esp,%ebp
  803daa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803dad:	8b 45 08             	mov    0x8(%ebp),%eax
  803db0:	e8 ba ff ff ff       	call   803d6f <_ZL9fd2sockidi>
  803db5:	85 c0                	test   %eax,%eax
  803db7:	78 1f                	js     803dd8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803db9:	8b 55 10             	mov    0x10(%ebp),%edx
  803dbc:	89 54 24 08          	mov    %edx,0x8(%esp)
  803dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803dc3:	89 54 24 04          	mov    %edx,0x4(%esp)
  803dc7:	89 04 24             	mov    %eax,(%esp)
  803dca:	e8 19 01 00 00       	call   803ee8 <_Z12nsipc_acceptiP8sockaddrPj>
  803dcf:	85 c0                	test   %eax,%eax
  803dd1:	78 05                	js     803dd8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803dd3:	e8 1f ff ff ff       	call   803cf7 <_ZL12alloc_sockfdi>
}
  803dd8:	c9                   	leave  
  803dd9:	c3                   	ret    

00803dda <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803dda:	55                   	push   %ebp
  803ddb:	89 e5                	mov    %esp,%ebp
  803ddd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803de0:	8b 45 08             	mov    0x8(%ebp),%eax
  803de3:	e8 87 ff ff ff       	call   803d6f <_ZL9fd2sockidi>
  803de8:	85 c0                	test   %eax,%eax
  803dea:	78 16                	js     803e02 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803dec:	8b 55 10             	mov    0x10(%ebp),%edx
  803def:	89 54 24 08          	mov    %edx,0x8(%esp)
  803df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803df6:	89 54 24 04          	mov    %edx,0x4(%esp)
  803dfa:	89 04 24             	mov    %eax,(%esp)
  803dfd:	e8 34 01 00 00       	call   803f36 <_Z10nsipc_bindiP8sockaddrj>
}
  803e02:	c9                   	leave  
  803e03:	c3                   	ret    

00803e04 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803e04:	55                   	push   %ebp
  803e05:	89 e5                	mov    %esp,%ebp
  803e07:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0d:	e8 5d ff ff ff       	call   803d6f <_ZL9fd2sockidi>
  803e12:	85 c0                	test   %eax,%eax
  803e14:	78 0f                	js     803e25 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e19:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e1d:	89 04 24             	mov    %eax,(%esp)
  803e20:	e8 50 01 00 00       	call   803f75 <_Z14nsipc_shutdownii>
}
  803e25:	c9                   	leave  
  803e26:	c3                   	ret    

00803e27 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803e27:	55                   	push   %ebp
  803e28:	89 e5                	mov    %esp,%ebp
  803e2a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e30:	e8 3a ff ff ff       	call   803d6f <_ZL9fd2sockidi>
  803e35:	85 c0                	test   %eax,%eax
  803e37:	78 16                	js     803e4f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803e39:	8b 55 10             	mov    0x10(%ebp),%edx
  803e3c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803e40:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e43:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e47:	89 04 24             	mov    %eax,(%esp)
  803e4a:	e8 62 01 00 00       	call   803fb1 <_Z13nsipc_connectiPK8sockaddrj>
}
  803e4f:	c9                   	leave  
  803e50:	c3                   	ret    

00803e51 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803e51:	55                   	push   %ebp
  803e52:	89 e5                	mov    %esp,%ebp
  803e54:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e57:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5a:	e8 10 ff ff ff       	call   803d6f <_ZL9fd2sockidi>
  803e5f:	85 c0                	test   %eax,%eax
  803e61:	78 0f                	js     803e72 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e66:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e6a:	89 04 24             	mov    %eax,(%esp)
  803e6d:	e8 7e 01 00 00       	call   803ff0 <_Z12nsipc_listenii>
}
  803e72:	c9                   	leave  
  803e73:	c3                   	ret    

00803e74 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803e74:	55                   	push   %ebp
  803e75:	89 e5                	mov    %esp,%ebp
  803e77:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  803e7d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e88:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8b:	89 04 24             	mov    %eax,(%esp)
  803e8e:	e8 72 02 00 00       	call   804105 <_Z12nsipc_socketiii>
  803e93:	85 c0                	test   %eax,%eax
  803e95:	78 05                	js     803e9c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803e97:	e8 5b fe ff ff       	call   803cf7 <_ZL12alloc_sockfdi>
}
  803e9c:	c9                   	leave  
  803e9d:	8d 76 00             	lea    0x0(%esi),%esi
  803ea0:	c3                   	ret    
  803ea1:	00 00                	add    %al,(%eax)
	...

00803ea4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803ea4:	55                   	push   %ebp
  803ea5:	89 e5                	mov    %esp,%ebp
  803ea7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803eaa:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803eb1:	00 
  803eb2:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803eb9:	00 
  803eba:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ebe:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803ec5:	e8 f5 05 00 00       	call   8044bf <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803eca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803ed1:	00 
  803ed2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803ed9:	00 
  803eda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ee1:	e8 4a 05 00 00       	call   804430 <_Z8ipc_recvPiPvS_>
}
  803ee6:	c9                   	leave  
  803ee7:	c3                   	ret    

00803ee8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803ee8:	55                   	push   %ebp
  803ee9:	89 e5                	mov    %esp,%ebp
  803eeb:	53                   	push   %ebx
  803eec:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803eef:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef2:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803ef7:	b8 01 00 00 00       	mov    $0x1,%eax
  803efc:	e8 a3 ff ff ff       	call   803ea4 <_ZL5nsipcj>
  803f01:	89 c3                	mov    %eax,%ebx
  803f03:	85 c0                	test   %eax,%eax
  803f05:	78 27                	js     803f2e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803f07:	a1 10 80 80 00       	mov    0x808010,%eax
  803f0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803f10:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803f17:	00 
  803f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f1b:	89 04 24             	mov    %eax,(%esp)
  803f1e:	e8 99 cb ff ff       	call   800abc <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803f23:	8b 15 10 80 80 00    	mov    0x808010,%edx
  803f29:	8b 45 10             	mov    0x10(%ebp),%eax
  803f2c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803f2e:	89 d8                	mov    %ebx,%eax
  803f30:	83 c4 14             	add    $0x14,%esp
  803f33:	5b                   	pop    %ebx
  803f34:	5d                   	pop    %ebp
  803f35:	c3                   	ret    

00803f36 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f36:	55                   	push   %ebp
  803f37:	89 e5                	mov    %esp,%ebp
  803f39:	53                   	push   %ebx
  803f3a:	83 ec 14             	sub    $0x14,%esp
  803f3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803f40:	8b 45 08             	mov    0x8(%ebp),%eax
  803f43:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803f48:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f53:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803f5a:	e8 5d cb ff ff       	call   800abc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803f5f:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803f65:	b8 02 00 00 00       	mov    $0x2,%eax
  803f6a:	e8 35 ff ff ff       	call   803ea4 <_ZL5nsipcj>
}
  803f6f:	83 c4 14             	add    $0x14,%esp
  803f72:	5b                   	pop    %ebx
  803f73:	5d                   	pop    %ebp
  803f74:	c3                   	ret    

00803f75 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803f75:	55                   	push   %ebp
  803f76:	89 e5                	mov    %esp,%ebp
  803f78:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f86:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803f8b:	b8 03 00 00 00       	mov    $0x3,%eax
  803f90:	e8 0f ff ff ff       	call   803ea4 <_ZL5nsipcj>
}
  803f95:	c9                   	leave  
  803f96:	c3                   	ret    

00803f97 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803f97:	55                   	push   %ebp
  803f98:	89 e5                	mov    %esp,%ebp
  803f9a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa0:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803fa5:	b8 04 00 00 00       	mov    $0x4,%eax
  803faa:	e8 f5 fe ff ff       	call   803ea4 <_ZL5nsipcj>
}
  803faf:	c9                   	leave  
  803fb0:	c3                   	ret    

00803fb1 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803fb1:	55                   	push   %ebp
  803fb2:	89 e5                	mov    %esp,%ebp
  803fb4:	53                   	push   %ebx
  803fb5:	83 ec 14             	sub    $0x14,%esp
  803fb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fbe:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803fc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fca:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fce:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803fd5:	e8 e2 ca ff ff       	call   800abc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803fda:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803fe0:	b8 05 00 00 00       	mov    $0x5,%eax
  803fe5:	e8 ba fe ff ff       	call   803ea4 <_ZL5nsipcj>
}
  803fea:	83 c4 14             	add    $0x14,%esp
  803fed:	5b                   	pop    %ebx
  803fee:	5d                   	pop    %ebp
  803fef:	c3                   	ret    

00803ff0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803ff0:	55                   	push   %ebp
  803ff1:	89 e5                	mov    %esp,%ebp
  803ff3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff9:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  804001:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  804006:	b8 06 00 00 00       	mov    $0x6,%eax
  80400b:	e8 94 fe ff ff       	call   803ea4 <_ZL5nsipcj>
}
  804010:	c9                   	leave  
  804011:	c3                   	ret    

00804012 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804012:	55                   	push   %ebp
  804013:	89 e5                	mov    %esp,%ebp
  804015:	56                   	push   %esi
  804016:	53                   	push   %ebx
  804017:	83 ec 10             	sub    $0x10,%esp
  80401a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80401d:	8b 45 08             	mov    0x8(%ebp),%eax
  804020:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  804025:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80402b:	8b 45 14             	mov    0x14(%ebp),%eax
  80402e:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804033:	b8 07 00 00 00       	mov    $0x7,%eax
  804038:	e8 67 fe ff ff       	call   803ea4 <_ZL5nsipcj>
  80403d:	89 c3                	mov    %eax,%ebx
  80403f:	85 c0                	test   %eax,%eax
  804041:	78 46                	js     804089 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  804043:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  804048:	7f 04                	jg     80404e <_Z10nsipc_recviPvij+0x3c>
  80404a:	39 f0                	cmp    %esi,%eax
  80404c:	7e 24                	jle    804072 <_Z10nsipc_recviPvij+0x60>
  80404e:	c7 44 24 0c 13 53 80 	movl   $0x805313,0xc(%esp)
  804055:	00 
  804056:	c7 44 24 08 4e 4c 80 	movl   $0x804c4e,0x8(%esp)
  80405d:	00 
  80405e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  804065:	00 
  804066:	c7 04 24 28 53 80 00 	movl   $0x805328,(%esp)
  80406d:	e8 6e c1 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804072:	89 44 24 08          	mov    %eax,0x8(%esp)
  804076:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80407d:	00 
  80407e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804081:	89 04 24             	mov    %eax,(%esp)
  804084:	e8 33 ca ff ff       	call   800abc <memmove>
	}

	return r;
}
  804089:	89 d8                	mov    %ebx,%eax
  80408b:	83 c4 10             	add    $0x10,%esp
  80408e:	5b                   	pop    %ebx
  80408f:	5e                   	pop    %esi
  804090:	5d                   	pop    %ebp
  804091:	c3                   	ret    

00804092 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804092:	55                   	push   %ebp
  804093:	89 e5                	mov    %esp,%ebp
  804095:	53                   	push   %ebx
  804096:	83 ec 14             	sub    $0x14,%esp
  804099:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80409c:	8b 45 08             	mov    0x8(%ebp),%eax
  80409f:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8040a4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8040aa:	7e 24                	jle    8040d0 <_Z10nsipc_sendiPKvij+0x3e>
  8040ac:	c7 44 24 0c 34 53 80 	movl   $0x805334,0xc(%esp)
  8040b3:	00 
  8040b4:	c7 44 24 08 4e 4c 80 	movl   $0x804c4e,0x8(%esp)
  8040bb:	00 
  8040bc:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  8040c3:	00 
  8040c4:	c7 04 24 28 53 80 00 	movl   $0x805328,(%esp)
  8040cb:	e8 10 c1 ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8040d0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040db:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8040e2:	e8 d5 c9 ff ff       	call   800abc <memmove>
	nsipcbuf.send.req_size = size;
  8040e7:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8040ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8040f0:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8040f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8040fa:	e8 a5 fd ff ff       	call   803ea4 <_ZL5nsipcj>
}
  8040ff:	83 c4 14             	add    $0x14,%esp
  804102:	5b                   	pop    %ebx
  804103:	5d                   	pop    %ebp
  804104:	c3                   	ret    

00804105 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804105:	55                   	push   %ebp
  804106:	89 e5                	mov    %esp,%ebp
  804108:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80410b:	8b 45 08             	mov    0x8(%ebp),%eax
  80410e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  804113:	8b 45 0c             	mov    0xc(%ebp),%eax
  804116:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  80411b:	8b 45 10             	mov    0x10(%ebp),%eax
  80411e:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  804123:	b8 09 00 00 00       	mov    $0x9,%eax
  804128:	e8 77 fd ff ff       	call   803ea4 <_ZL5nsipcj>
}
  80412d:	c9                   	leave  
  80412e:	c3                   	ret    
	...

00804130 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  804130:	55                   	push   %ebp
  804131:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  804133:	b8 00 00 00 00       	mov    $0x0,%eax
  804138:	5d                   	pop    %ebp
  804139:	c3                   	ret    

0080413a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80413a:	55                   	push   %ebp
  80413b:	89 e5                	mov    %esp,%ebp
  80413d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804140:	c7 44 24 04 40 53 80 	movl   $0x805340,0x4(%esp)
  804147:	00 
  804148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80414b:	89 04 24             	mov    %eax,(%esp)
  80414e:	e8 c7 c7 ff ff       	call   80091a <_Z6strcpyPcPKc>
	return 0;
}
  804153:	b8 00 00 00 00       	mov    $0x0,%eax
  804158:	c9                   	leave  
  804159:	c3                   	ret    

0080415a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80415a:	55                   	push   %ebp
  80415b:	89 e5                	mov    %esp,%ebp
  80415d:	57                   	push   %edi
  80415e:	56                   	push   %esi
  80415f:	53                   	push   %ebx
  804160:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804166:	bb 00 00 00 00       	mov    $0x0,%ebx
  80416b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80416f:	74 3e                	je     8041af <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804171:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  804177:	8b 75 10             	mov    0x10(%ebp),%esi
  80417a:	29 de                	sub    %ebx,%esi
  80417c:	83 fe 7f             	cmp    $0x7f,%esi
  80417f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  804184:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804187:	89 74 24 08          	mov    %esi,0x8(%esp)
  80418b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80418e:	01 d8                	add    %ebx,%eax
  804190:	89 44 24 04          	mov    %eax,0x4(%esp)
  804194:	89 3c 24             	mov    %edi,(%esp)
  804197:	e8 20 c9 ff ff       	call   800abc <memmove>
		sys_cputs(buf, m);
  80419c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8041a0:	89 3c 24             	mov    %edi,(%esp)
  8041a3:	e8 2c cb ff ff       	call   800cd4 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041a8:	01 f3                	add    %esi,%ebx
  8041aa:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  8041ad:	77 c8                	ja     804177 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8041af:	89 d8                	mov    %ebx,%eax
  8041b1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8041b7:	5b                   	pop    %ebx
  8041b8:	5e                   	pop    %esi
  8041b9:	5f                   	pop    %edi
  8041ba:	5d                   	pop    %ebp
  8041bb:	c3                   	ret    

008041bc <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041bc:	55                   	push   %ebp
  8041bd:	89 e5                	mov    %esp,%ebp
  8041bf:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8041c2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8041c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8041cb:	75 07                	jne    8041d4 <_ZL12devcons_readP2FdPvj+0x18>
  8041cd:	eb 2a                	jmp    8041f9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8041cf:	e8 f8 cb ff ff       	call   800dcc <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8041d4:	e8 2e cb ff ff       	call   800d07 <_Z9sys_cgetcv>
  8041d9:	85 c0                	test   %eax,%eax
  8041db:	74 f2                	je     8041cf <_ZL12devcons_readP2FdPvj+0x13>
  8041dd:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8041df:	85 c0                	test   %eax,%eax
  8041e1:	78 16                	js     8041f9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8041e3:	83 f8 04             	cmp    $0x4,%eax
  8041e6:	74 0c                	je     8041f4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8041e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041eb:	88 10                	mov    %dl,(%eax)
	return 1;
  8041ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8041f2:	eb 05                	jmp    8041f9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8041f4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8041f9:	c9                   	leave  
  8041fa:	c3                   	ret    

008041fb <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8041fb:	55                   	push   %ebp
  8041fc:	89 e5                	mov    %esp,%ebp
  8041fe:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  804201:	8b 45 08             	mov    0x8(%ebp),%eax
  804204:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804207:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80420e:	00 
  80420f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804212:	89 04 24             	mov    %eax,(%esp)
  804215:	e8 ba ca ff ff       	call   800cd4 <_Z9sys_cputsPKcj>
}
  80421a:	c9                   	leave  
  80421b:	c3                   	ret    

0080421c <_Z7getcharv>:

int
getchar(void)
{
  80421c:	55                   	push   %ebp
  80421d:	89 e5                	mov    %esp,%ebp
  80421f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804222:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804229:	00 
  80422a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80422d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804231:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804238:	e8 71 dc ff ff       	call   801eae <_Z4readiPvj>
	if (r < 0)
  80423d:	85 c0                	test   %eax,%eax
  80423f:	78 0f                	js     804250 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  804241:	85 c0                	test   %eax,%eax
  804243:	7e 06                	jle    80424b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  804245:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804249:	eb 05                	jmp    804250 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80424b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  804250:	c9                   	leave  
  804251:	c3                   	ret    

00804252 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  804252:	55                   	push   %ebp
  804253:	89 e5                	mov    %esp,%ebp
  804255:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  804258:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80425f:	00 
  804260:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804263:	89 44 24 04          	mov    %eax,0x4(%esp)
  804267:	8b 45 08             	mov    0x8(%ebp),%eax
  80426a:	89 04 24             	mov    %eax,(%esp)
  80426d:	e8 8f d8 ff ff       	call   801b01 <_Z9fd_lookupiPP2Fdb>
  804272:	85 c0                	test   %eax,%eax
  804274:	78 11                	js     804287 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  804276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804279:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80427f:	39 10                	cmp    %edx,(%eax)
  804281:	0f 94 c0             	sete   %al
  804284:	0f b6 c0             	movzbl %al,%eax
}
  804287:	c9                   	leave  
  804288:	c3                   	ret    

00804289 <_Z8openconsv>:

int
opencons(void)
{
  804289:	55                   	push   %ebp
  80428a:	89 e5                	mov    %esp,%ebp
  80428c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80428f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804292:	89 04 24             	mov    %eax,(%esp)
  804295:	e8 1d d9 ff ff       	call   801bb7 <_Z14fd_find_unusedPP2Fd>
  80429a:	85 c0                	test   %eax,%eax
  80429c:	78 3c                	js     8042da <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80429e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8042a5:	00 
  8042a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8042b4:	e8 47 cb ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  8042b9:	85 c0                	test   %eax,%eax
  8042bb:	78 1d                	js     8042da <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8042bd:	8b 15 58 60 80 00    	mov    0x806058,%edx
  8042c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8042c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042cb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8042d2:	89 04 24             	mov    %eax,(%esp)
  8042d5:	e8 7a d8 ff ff       	call   801b54 <_Z6fd2numP2Fd>
}
  8042da:	c9                   	leave  
  8042db:	c3                   	ret    
  8042dc:	00 00                	add    %al,(%eax)
	...

008042e0 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  8042e0:	55                   	push   %ebp
  8042e1:	89 e5                	mov    %esp,%ebp
  8042e3:	56                   	push   %esi
  8042e4:	53                   	push   %ebx
  8042e5:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8042e8:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  8042ed:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  8042f4:	85 c0                	test   %eax,%eax
  8042f6:	74 08                	je     804300 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  8042f8:	8d 55 08             	lea    0x8(%ebp),%edx
  8042fb:	89 14 24             	mov    %edx,(%esp)
  8042fe:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804300:	83 eb 01             	sub    $0x1,%ebx
  804303:	83 fb ff             	cmp    $0xffffffff,%ebx
  804306:	75 e5                	jne    8042ed <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  804308:	8b 5d 38             	mov    0x38(%ebp),%ebx
  80430b:	8b 75 08             	mov    0x8(%ebp),%esi
  80430e:	e8 85 ca ff ff       	call   800d98 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  804313:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  804317:	89 74 24 10          	mov    %esi,0x10(%esp)
  80431b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80431f:	c7 44 24 08 4c 53 80 	movl   $0x80534c,0x8(%esp)
  804326:	00 
  804327:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80432e:	00 
  80432f:	c7 04 24 d0 53 80 00 	movl   $0x8053d0,(%esp)
  804336:	e8 a5 be ff ff       	call   8001e0 <_Z6_panicPKciS0_z>

0080433b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  80433b:	55                   	push   %ebp
  80433c:	89 e5                	mov    %esp,%ebp
  80433e:	56                   	push   %esi
  80433f:	53                   	push   %ebx
  804340:	83 ec 10             	sub    $0x10,%esp
  804343:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804346:	e8 4d ca ff ff       	call   800d98 <_Z12sys_getenvidv>
  80434b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80434d:	a1 00 70 80 00       	mov    0x807000,%eax
  804352:	8b 40 5c             	mov    0x5c(%eax),%eax
  804355:	85 c0                	test   %eax,%eax
  804357:	75 4c                	jne    8043a5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  804359:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  804360:	00 
  804361:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  804368:	ee 
  804369:	89 34 24             	mov    %esi,(%esp)
  80436c:	e8 8f ca ff ff       	call   800e00 <_Z14sys_page_allociPvi>
  804371:	85 c0                	test   %eax,%eax
  804373:	74 20                	je     804395 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  804375:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804379:	c7 44 24 08 84 53 80 	movl   $0x805384,0x8(%esp)
  804380:	00 
  804381:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  804388:	00 
  804389:	c7 04 24 d0 53 80 00 	movl   $0x8053d0,(%esp)
  804390:	e8 4b be ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  804395:	c7 44 24 04 e0 42 80 	movl   $0x8042e0,0x4(%esp)
  80439c:	00 
  80439d:	89 34 24             	mov    %esi,(%esp)
  8043a0:	e8 90 cc ff ff       	call   801035 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  8043a5:	a1 00 90 80 00       	mov    0x809000,%eax
  8043aa:	39 d8                	cmp    %ebx,%eax
  8043ac:	74 1a                	je     8043c8 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  8043ae:	85 c0                	test   %eax,%eax
  8043b0:	74 20                	je     8043d2 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8043b2:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  8043b7:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  8043be:	39 da                	cmp    %ebx,%edx
  8043c0:	74 15                	je     8043d7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  8043c2:	85 d2                	test   %edx,%edx
  8043c4:	75 1f                	jne    8043e5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  8043c6:	eb 0f                	jmp    8043d7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8043c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8043cd:	8d 76 00             	lea    0x0(%esi),%esi
  8043d0:	eb 05                	jmp    8043d7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  8043d2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  8043d7:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  8043de:	83 c4 10             	add    $0x10,%esp
  8043e1:	5b                   	pop    %ebx
  8043e2:	5e                   	pop    %esi
  8043e3:	5d                   	pop    %ebp
  8043e4:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8043e5:	83 c0 01             	add    $0x1,%eax
  8043e8:	83 f8 08             	cmp    $0x8,%eax
  8043eb:	75 ca                	jne    8043b7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  8043ed:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8043f1:	c7 44 24 08 a8 53 80 	movl   $0x8053a8,0x8(%esp)
  8043f8:	00 
  8043f9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804400:	00 
  804401:	c7 04 24 d0 53 80 00 	movl   $0x8053d0,(%esp)
  804408:	e8 d3 bd ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
  80440d:	00 00                	add    %al,(%eax)
	...

00804410 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  804410:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  804413:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  804414:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  804417:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  80441b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  80441f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  804422:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  804424:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  804428:	61                   	popa   
    popf
  804429:	9d                   	popf   
    popl %esp
  80442a:	5c                   	pop    %esp
    ret
  80442b:	c3                   	ret    

0080442c <spin>:

spin:	jmp spin
  80442c:	eb fe                	jmp    80442c <spin>
	...

00804430 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804430:	55                   	push   %ebp
  804431:	89 e5                	mov    %esp,%ebp
  804433:	56                   	push   %esi
  804434:	53                   	push   %ebx
  804435:	83 ec 10             	sub    $0x10,%esp
  804438:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80443b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80443e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  804441:	85 c0                	test   %eax,%eax
  804443:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  804448:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80444b:	89 04 24             	mov    %eax,(%esp)
  80444e:	e8 78 cc ff ff       	call   8010cb <_Z12sys_ipc_recvPv>
  804453:	85 c0                	test   %eax,%eax
  804455:	79 16                	jns    80446d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  804457:	85 db                	test   %ebx,%ebx
  804459:	74 06                	je     804461 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80445b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804461:	85 f6                	test   %esi,%esi
  804463:	74 53                	je     8044b8 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804465:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80446b:	eb 4b                	jmp    8044b8 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80446d:	85 db                	test   %ebx,%ebx
  80446f:	74 17                	je     804488 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804471:	e8 22 c9 ff ff       	call   800d98 <_Z12sys_getenvidv>
  804476:	25 ff 03 00 00       	and    $0x3ff,%eax
  80447b:	6b c0 78             	imul   $0x78,%eax,%eax
  80447e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804483:	8b 40 60             	mov    0x60(%eax),%eax
  804486:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804488:	85 f6                	test   %esi,%esi
  80448a:	74 17                	je     8044a3 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80448c:	e8 07 c9 ff ff       	call   800d98 <_Z12sys_getenvidv>
  804491:	25 ff 03 00 00       	and    $0x3ff,%eax
  804496:	6b c0 78             	imul   $0x78,%eax,%eax
  804499:	05 00 00 00 ef       	add    $0xef000000,%eax
  80449e:	8b 40 70             	mov    0x70(%eax),%eax
  8044a1:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  8044a3:	e8 f0 c8 ff ff       	call   800d98 <_Z12sys_getenvidv>
  8044a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8044ad:	6b c0 78             	imul   $0x78,%eax,%eax
  8044b0:	05 08 00 00 ef       	add    $0xef000008,%eax
  8044b5:	8b 40 60             	mov    0x60(%eax),%eax

}
  8044b8:	83 c4 10             	add    $0x10,%esp
  8044bb:	5b                   	pop    %ebx
  8044bc:	5e                   	pop    %esi
  8044bd:	5d                   	pop    %ebp
  8044be:	c3                   	ret    

008044bf <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8044bf:	55                   	push   %ebp
  8044c0:	89 e5                	mov    %esp,%ebp
  8044c2:	57                   	push   %edi
  8044c3:	56                   	push   %esi
  8044c4:	53                   	push   %ebx
  8044c5:	83 ec 1c             	sub    $0x1c,%esp
  8044c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8044cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8044ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  8044d1:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  8044d3:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8044d8:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8044db:	8b 45 14             	mov    0x14(%ebp),%eax
  8044de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8044e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8044ea:	89 34 24             	mov    %esi,(%esp)
  8044ed:	e8 a1 cb ff ff       	call   801093 <_Z16sys_ipc_try_sendijPvi>
  8044f2:	85 c0                	test   %eax,%eax
  8044f4:	79 31                	jns    804527 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  8044f6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8044f9:	75 0c                	jne    804507 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  8044fb:	90                   	nop
  8044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804500:	e8 c7 c8 ff ff       	call   800dcc <_Z9sys_yieldv>
  804505:	eb d4                	jmp    8044db <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  804507:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80450b:	c7 44 24 08 de 53 80 	movl   $0x8053de,0x8(%esp)
  804512:	00 
  804513:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  80451a:	00 
  80451b:	c7 04 24 eb 53 80 00 	movl   $0x8053eb,(%esp)
  804522:	e8 b9 bc ff ff       	call   8001e0 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  804527:	83 c4 1c             	add    $0x1c,%esp
  80452a:	5b                   	pop    %ebx
  80452b:	5e                   	pop    %esi
  80452c:	5f                   	pop    %edi
  80452d:	5d                   	pop    %ebp
  80452e:	c3                   	ret    
	...

00804530 <__udivdi3>:
  804530:	55                   	push   %ebp
  804531:	89 e5                	mov    %esp,%ebp
  804533:	57                   	push   %edi
  804534:	56                   	push   %esi
  804535:	83 ec 20             	sub    $0x20,%esp
  804538:	8b 45 14             	mov    0x14(%ebp),%eax
  80453b:	8b 75 08             	mov    0x8(%ebp),%esi
  80453e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804541:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804544:	85 c0                	test   %eax,%eax
  804546:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804549:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80454c:	75 3a                	jne    804588 <__udivdi3+0x58>
  80454e:	39 f9                	cmp    %edi,%ecx
  804550:	77 66                	ja     8045b8 <__udivdi3+0x88>
  804552:	85 c9                	test   %ecx,%ecx
  804554:	75 0b                	jne    804561 <__udivdi3+0x31>
  804556:	b8 01 00 00 00       	mov    $0x1,%eax
  80455b:	31 d2                	xor    %edx,%edx
  80455d:	f7 f1                	div    %ecx
  80455f:	89 c1                	mov    %eax,%ecx
  804561:	89 f8                	mov    %edi,%eax
  804563:	31 d2                	xor    %edx,%edx
  804565:	f7 f1                	div    %ecx
  804567:	89 c7                	mov    %eax,%edi
  804569:	89 f0                	mov    %esi,%eax
  80456b:	f7 f1                	div    %ecx
  80456d:	89 fa                	mov    %edi,%edx
  80456f:	89 c6                	mov    %eax,%esi
  804571:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804574:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80457a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80457d:	83 c4 20             	add    $0x20,%esp
  804580:	5e                   	pop    %esi
  804581:	5f                   	pop    %edi
  804582:	5d                   	pop    %ebp
  804583:	c3                   	ret    
  804584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804588:	31 d2                	xor    %edx,%edx
  80458a:	31 f6                	xor    %esi,%esi
  80458c:	39 f8                	cmp    %edi,%eax
  80458e:	77 e1                	ja     804571 <__udivdi3+0x41>
  804590:	0f bd d0             	bsr    %eax,%edx
  804593:	83 f2 1f             	xor    $0x1f,%edx
  804596:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804599:	75 2d                	jne    8045c8 <__udivdi3+0x98>
  80459b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80459e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  8045a1:	76 06                	jbe    8045a9 <__udivdi3+0x79>
  8045a3:	39 f8                	cmp    %edi,%eax
  8045a5:	89 f2                	mov    %esi,%edx
  8045a7:	73 c8                	jae    804571 <__udivdi3+0x41>
  8045a9:	31 d2                	xor    %edx,%edx
  8045ab:	be 01 00 00 00       	mov    $0x1,%esi
  8045b0:	eb bf                	jmp    804571 <__udivdi3+0x41>
  8045b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8045b8:	89 f0                	mov    %esi,%eax
  8045ba:	89 fa                	mov    %edi,%edx
  8045bc:	f7 f1                	div    %ecx
  8045be:	31 d2                	xor    %edx,%edx
  8045c0:	89 c6                	mov    %eax,%esi
  8045c2:	eb ad                	jmp    804571 <__udivdi3+0x41>
  8045c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8045c8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045cc:	89 c2                	mov    %eax,%edx
  8045ce:	b8 20 00 00 00       	mov    $0x20,%eax
  8045d3:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8045d6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8045d9:	d3 e2                	shl    %cl,%edx
  8045db:	89 c1                	mov    %eax,%ecx
  8045dd:	d3 ee                	shr    %cl,%esi
  8045df:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045e3:	09 d6                	or     %edx,%esi
  8045e5:	89 fa                	mov    %edi,%edx
  8045e7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8045ea:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8045ed:	d3 e6                	shl    %cl,%esi
  8045ef:	89 c1                	mov    %eax,%ecx
  8045f1:	d3 ea                	shr    %cl,%edx
  8045f3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045f7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8045fa:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8045fd:	d3 e7                	shl    %cl,%edi
  8045ff:	89 c1                	mov    %eax,%ecx
  804601:	d3 ee                	shr    %cl,%esi
  804603:	09 fe                	or     %edi,%esi
  804605:	89 f0                	mov    %esi,%eax
  804607:	f7 75 e4             	divl   -0x1c(%ebp)
  80460a:	89 d7                	mov    %edx,%edi
  80460c:	89 c6                	mov    %eax,%esi
  80460e:	f7 65 f0             	mull   -0x10(%ebp)
  804611:	39 d7                	cmp    %edx,%edi
  804613:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804616:	72 12                	jb     80462a <__udivdi3+0xfa>
  804618:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80461b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80461f:	d3 e2                	shl    %cl,%edx
  804621:	39 c2                	cmp    %eax,%edx
  804623:	73 08                	jae    80462d <__udivdi3+0xfd>
  804625:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804628:	75 03                	jne    80462d <__udivdi3+0xfd>
  80462a:	83 ee 01             	sub    $0x1,%esi
  80462d:	31 d2                	xor    %edx,%edx
  80462f:	e9 3d ff ff ff       	jmp    804571 <__udivdi3+0x41>
	...

00804640 <__umoddi3>:
  804640:	55                   	push   %ebp
  804641:	89 e5                	mov    %esp,%ebp
  804643:	57                   	push   %edi
  804644:	56                   	push   %esi
  804645:	83 ec 20             	sub    $0x20,%esp
  804648:	8b 7d 14             	mov    0x14(%ebp),%edi
  80464b:	8b 45 08             	mov    0x8(%ebp),%eax
  80464e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804651:	8b 75 0c             	mov    0xc(%ebp),%esi
  804654:	85 ff                	test   %edi,%edi
  804656:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804659:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80465c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80465f:	89 f2                	mov    %esi,%edx
  804661:	75 15                	jne    804678 <__umoddi3+0x38>
  804663:	39 f1                	cmp    %esi,%ecx
  804665:	76 41                	jbe    8046a8 <__umoddi3+0x68>
  804667:	f7 f1                	div    %ecx
  804669:	89 d0                	mov    %edx,%eax
  80466b:	31 d2                	xor    %edx,%edx
  80466d:	83 c4 20             	add    $0x20,%esp
  804670:	5e                   	pop    %esi
  804671:	5f                   	pop    %edi
  804672:	5d                   	pop    %ebp
  804673:	c3                   	ret    
  804674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804678:	39 f7                	cmp    %esi,%edi
  80467a:	77 4c                	ja     8046c8 <__umoddi3+0x88>
  80467c:	0f bd c7             	bsr    %edi,%eax
  80467f:	83 f0 1f             	xor    $0x1f,%eax
  804682:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804685:	75 51                	jne    8046d8 <__umoddi3+0x98>
  804687:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80468a:	0f 87 e8 00 00 00    	ja     804778 <__umoddi3+0x138>
  804690:	89 f2                	mov    %esi,%edx
  804692:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804695:	29 ce                	sub    %ecx,%esi
  804697:	19 fa                	sbb    %edi,%edx
  804699:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80469c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80469f:	83 c4 20             	add    $0x20,%esp
  8046a2:	5e                   	pop    %esi
  8046a3:	5f                   	pop    %edi
  8046a4:	5d                   	pop    %ebp
  8046a5:	c3                   	ret    
  8046a6:	66 90                	xchg   %ax,%ax
  8046a8:	85 c9                	test   %ecx,%ecx
  8046aa:	75 0b                	jne    8046b7 <__umoddi3+0x77>
  8046ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8046b1:	31 d2                	xor    %edx,%edx
  8046b3:	f7 f1                	div    %ecx
  8046b5:	89 c1                	mov    %eax,%ecx
  8046b7:	89 f0                	mov    %esi,%eax
  8046b9:	31 d2                	xor    %edx,%edx
  8046bb:	f7 f1                	div    %ecx
  8046bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8046c0:	eb a5                	jmp    804667 <__umoddi3+0x27>
  8046c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8046c8:	89 f2                	mov    %esi,%edx
  8046ca:	83 c4 20             	add    $0x20,%esp
  8046cd:	5e                   	pop    %esi
  8046ce:	5f                   	pop    %edi
  8046cf:	5d                   	pop    %ebp
  8046d0:	c3                   	ret    
  8046d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8046d8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8046dc:	89 f2                	mov    %esi,%edx
  8046de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046e1:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  8046e8:	29 45 f0             	sub    %eax,-0x10(%ebp)
  8046eb:	d3 e7                	shl    %cl,%edi
  8046ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046f0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8046f4:	d3 e8                	shr    %cl,%eax
  8046f6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8046fa:	09 f8                	or     %edi,%eax
  8046fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8046ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804702:	d3 e0                	shl    %cl,%eax
  804704:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804708:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80470b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80470e:	d3 ea                	shr    %cl,%edx
  804710:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804714:	d3 e6                	shl    %cl,%esi
  804716:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80471a:	d3 e8                	shr    %cl,%eax
  80471c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804720:	09 f0                	or     %esi,%eax
  804722:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804725:	f7 75 e4             	divl   -0x1c(%ebp)
  804728:	d3 e6                	shl    %cl,%esi
  80472a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80472d:	89 d6                	mov    %edx,%esi
  80472f:	f7 65 f4             	mull   -0xc(%ebp)
  804732:	89 d7                	mov    %edx,%edi
  804734:	89 c2                	mov    %eax,%edx
  804736:	39 fe                	cmp    %edi,%esi
  804738:	89 f9                	mov    %edi,%ecx
  80473a:	72 30                	jb     80476c <__umoddi3+0x12c>
  80473c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80473f:	72 27                	jb     804768 <__umoddi3+0x128>
  804741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804744:	29 d0                	sub    %edx,%eax
  804746:	19 ce                	sbb    %ecx,%esi
  804748:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80474c:	89 f2                	mov    %esi,%edx
  80474e:	d3 e8                	shr    %cl,%eax
  804750:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804754:	d3 e2                	shl    %cl,%edx
  804756:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80475a:	09 d0                	or     %edx,%eax
  80475c:	89 f2                	mov    %esi,%edx
  80475e:	d3 ea                	shr    %cl,%edx
  804760:	83 c4 20             	add    $0x20,%esp
  804763:	5e                   	pop    %esi
  804764:	5f                   	pop    %edi
  804765:	5d                   	pop    %ebp
  804766:	c3                   	ret    
  804767:	90                   	nop
  804768:	39 fe                	cmp    %edi,%esi
  80476a:	75 d5                	jne    804741 <__umoddi3+0x101>
  80476c:	89 f9                	mov    %edi,%ecx
  80476e:	89 c2                	mov    %eax,%edx
  804770:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804773:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804776:	eb c9                	jmp    804741 <__umoddi3+0x101>
  804778:	39 f7                	cmp    %esi,%edi
  80477a:	0f 82 10 ff ff ff    	jb     804690 <__umoddi3+0x50>
  804780:	e9 17 ff ff ff       	jmp    80469c <__umoddi3+0x5c>
