
obj/user/writemotd:     file format elf32-i386


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
  80002c:	e8 13 02 00 00       	call   800244 <libmain>
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
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	81 ec 2c 02 00 00    	sub    $0x22c,%esp
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  800040:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800047:	00 
  800048:	c7 04 24 40 40 80 00 	movl   $0x804040,(%esp)
  80004f:	e8 8a 23 00 00       	call   8023de <_Z4openPKci>
  800054:	89 85 e4 fd ff ff    	mov    %eax,-0x21c(%ebp)
  80005a:	85 c0                	test   %eax,%eax
  80005c:	79 20                	jns    80007e <_Z5umainiPPc+0x4a>
		panic("open /newmotd: %e", rfd);
  80005e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800062:	c7 44 24 08 49 40 80 	movl   $0x804049,0x8(%esp)
  800069:	00 
  80006a:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800071:	00 
  800072:	c7 04 24 5b 40 80 00 	movl   $0x80405b,(%esp)
  800079:	e8 4a 02 00 00       	call   8002c8 <_Z6_panicPKciS0_z>
	if ((wfd = open("/motd", O_RDWR)) < 0)
  80007e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  800085:	00 
  800086:	c7 04 24 6c 40 80 00 	movl   $0x80406c,(%esp)
  80008d:	e8 4c 23 00 00       	call   8023de <_Z4openPKci>
  800092:	89 c7                	mov    %eax,%edi
  800094:	85 c0                	test   %eax,%eax
  800096:	79 20                	jns    8000b8 <_Z5umainiPPc+0x84>
		panic("open /motd: %e", wfd);
  800098:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80009c:	c7 44 24 08 72 40 80 	movl   $0x804072,0x8(%esp)
  8000a3:	00 
  8000a4:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  8000ab:	00 
  8000ac:	c7 04 24 5b 40 80 00 	movl   $0x80405b,(%esp)
  8000b3:	e8 10 02 00 00       	call   8002c8 <_Z6_panicPKciS0_z>
	cprintf("file descriptors %d %d\n", rfd, wfd);
  8000b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000bc:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  8000c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000c6:	c7 04 24 81 40 80 00 	movl   $0x804081,(%esp)
  8000cd:	e8 14 03 00 00       	call   8003e6 <_Z7cprintfPKcz>
	if (rfd == wfd)
  8000d2:	39 bd e4 fd ff ff    	cmp    %edi,-0x21c(%ebp)
  8000d8:	75 1c                	jne    8000f6 <_Z5umainiPPc+0xc2>
		panic("open /newmotd and /motd give same file descriptor");
  8000da:	c7 44 24 08 ec 40 80 	movl   $0x8040ec,0x8(%esp)
  8000e1:	00 
  8000e2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  8000e9:	00 
  8000ea:	c7 04 24 5b 40 80 00 	movl   $0x80405b,(%esp)
  8000f1:	e8 d2 01 00 00       	call   8002c8 <_Z6_panicPKciS0_z>

	cprintf("OLD MOTD\n===\n");
  8000f6:	c7 04 24 99 40 80 00 	movl   $0x804099,(%esp)
  8000fd:	e8 e4 02 00 00       	call   8003e6 <_Z7cprintfPKcz>
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800102:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  800108:	eb 0c                	jmp    800116 <_Z5umainiPPc+0xe2>
		sys_cputs(buf, n);
  80010a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80010e:	89 1c 24             	mov    %ebx,(%esp)
  800111:	e8 9e 0c 00 00       	call   800db4 <_Z9sys_cputsPKcj>
	cprintf("file descriptors %d %d\n", rfd, wfd);
	if (rfd == wfd)
		panic("open /newmotd and /motd give same file descriptor");

	cprintf("OLD MOTD\n===\n");
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800116:	c7 44 24 08 ff 01 00 	movl   $0x1ff,0x8(%esp)
  80011d:	00 
  80011e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800122:	89 3c 24             	mov    %edi,(%esp)
  800125:	e8 24 16 00 00       	call   80174e <_Z4readiPvj>
  80012a:	85 c0                	test   %eax,%eax
  80012c:	7f dc                	jg     80010a <_Z5umainiPPc+0xd6>
		sys_cputs(buf, n);
	cprintf("===\n");
  80012e:	c7 04 24 a2 40 80 00 	movl   $0x8040a2,(%esp)
  800135:	e8 ac 02 00 00       	call   8003e6 <_Z7cprintfPKcz>
	seek(wfd, 0);
  80013a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800141:	00 
  800142:	89 3c 24             	mov    %edi,(%esp)
  800145:	e8 61 17 00 00       	call   8018ab <_Z4seekii>

	if ((r = ftruncate(wfd, 0)) < 0)
  80014a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800151:	00 
  800152:	89 3c 24             	mov    %edi,(%esp)
  800155:	e8 85 17 00 00       	call   8018df <_Z9ftruncateii>
  80015a:	85 c0                	test   %eax,%eax
  80015c:	79 20                	jns    80017e <_Z5umainiPPc+0x14a>
		panic("truncate /motd: %e", r);
  80015e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800162:	c7 44 24 08 a7 40 80 	movl   $0x8040a7,0x8(%esp)
  800169:	00 
  80016a:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800171:	00 
  800172:	c7 04 24 5b 40 80 00 	movl   $0x80405b,(%esp)
  800179:	e8 4a 01 00 00       	call   8002c8 <_Z6_panicPKciS0_z>

	cprintf("NEW MOTD\n===\n");
  80017e:	c7 04 24 ba 40 80 00 	movl   $0x8040ba,(%esp)
  800185:	e8 5c 02 00 00       	call   8003e6 <_Z7cprintfPKcz>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  80018a:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
  800190:	eb 40                	jmp    8001d2 <_Z5umainiPPc+0x19e>
		sys_cputs(buf, n);
  800192:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800196:	89 34 24             	mov    %esi,(%esp)
  800199:	e8 16 0c 00 00       	call   800db4 <_Z9sys_cputsPKcj>
		if ((r = write(wfd, buf, n)) != n)
  80019e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001a6:	89 3c 24             	mov    %edi,(%esp)
  8001a9:	e8 8b 16 00 00       	call   801839 <_Z5writeiPKvj>
  8001ae:	39 c3                	cmp    %eax,%ebx
  8001b0:	74 20                	je     8001d2 <_Z5umainiPPc+0x19e>
			panic("write /motd: %e", r);
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 c8 40 80 	movl   $0x8040c8,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 5b 40 80 00 	movl   $0x80405b,(%esp)
  8001cd:	e8 f6 00 00 00       	call   8002c8 <_Z6_panicPKciS0_z>

	if ((r = ftruncate(wfd, 0)) < 0)
		panic("truncate /motd: %e", r);

	cprintf("NEW MOTD\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8001d2:	c7 44 24 08 ff 01 00 	movl   $0x1ff,0x8(%esp)
  8001d9:	00 
  8001da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001de:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  8001e4:	89 04 24             	mov    %eax,(%esp)
  8001e7:	e8 62 15 00 00       	call   80174e <_Z4readiPvj>
  8001ec:	89 c3                	mov    %eax,%ebx
  8001ee:	85 c0                	test   %eax,%eax
  8001f0:	7f a0                	jg     800192 <_Z5umainiPPc+0x15e>
		sys_cputs(buf, n);
		if ((r = write(wfd, buf, n)) != n)
			panic("write /motd: %e", r);
	}
	cprintf("===\n");
  8001f2:	c7 04 24 a2 40 80 00 	movl   $0x8040a2,(%esp)
  8001f9:	e8 e8 01 00 00       	call   8003e6 <_Z7cprintfPKcz>

	if (n < 0)
  8001fe:	85 db                	test   %ebx,%ebx
  800200:	79 20                	jns    800222 <_Z5umainiPPc+0x1ee>
		panic("read /newmotd: %e", n);
  800202:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800206:	c7 44 24 08 d8 40 80 	movl   $0x8040d8,0x8(%esp)
  80020d:	00 
  80020e:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  800215:	00 
  800216:	c7 04 24 5b 40 80 00 	movl   $0x80405b,(%esp)
  80021d:	e8 a6 00 00 00       	call   8002c8 <_Z6_panicPKciS0_z>

	close(rfd);
  800222:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  800228:	89 04 24             	mov    %eax,(%esp)
  80022b:	e8 75 13 00 00       	call   8015a5 <_Z5closei>
	close(wfd);
  800230:	89 3c 24             	mov    %edi,(%esp)
  800233:	e8 6d 13 00 00       	call   8015a5 <_Z5closei>
}
  800238:	81 c4 2c 02 00 00    	add    $0x22c,%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5e                   	pop    %esi
  800240:	5f                   	pop    %edi
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    
	...

00800244 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	57                   	push   %edi
  800248:	56                   	push   %esi
  800249:	53                   	push   %ebx
  80024a:	83 ec 1c             	sub    $0x1c,%esp
  80024d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800250:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800253:	e8 20 0c 00 00       	call   800e78 <_Z12sys_getenvidv>
  800258:	25 ff 03 00 00       	and    $0x3ff,%eax
  80025d:	6b c0 78             	imul   $0x78,%eax,%eax
  800260:	05 00 00 00 ef       	add    $0xef000000,%eax
  800265:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80026a:	85 ff                	test   %edi,%edi
  80026c:	7e 07                	jle    800275 <libmain+0x31>
		binaryname = argv[0];
  80026e:	8b 06                	mov    (%esi),%eax
  800270:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800275:	b8 41 4c 80 00       	mov    $0x804c41,%eax
  80027a:	3d 41 4c 80 00       	cmp    $0x804c41,%eax
  80027f:	76 0f                	jbe    800290 <libmain+0x4c>
  800281:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800283:	83 eb 04             	sub    $0x4,%ebx
  800286:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800288:	81 fb 41 4c 80 00    	cmp    $0x804c41,%ebx
  80028e:	77 f3                	ja     800283 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800290:	89 74 24 04          	mov    %esi,0x4(%esp)
  800294:	89 3c 24             	mov    %edi,(%esp)
  800297:	e8 98 fd ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  80029c:	e8 0b 00 00 00       	call   8002ac <_Z4exitv>
}
  8002a1:	83 c4 1c             	add    $0x1c,%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    
  8002a9:	00 00                	add    %al,(%eax)
	...

008002ac <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8002b2:	e8 27 13 00 00       	call   8015de <_Z9close_allv>
	sys_env_destroy(0);
  8002b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002be:	e8 58 0b 00 00       	call   800e1b <_Z15sys_env_destroyi>
}
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    
  8002c5:	00 00                	add    %al,(%eax)
	...

008002c8 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8002d0:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  8002d3:	a1 04 60 80 00       	mov    0x806004,%eax
  8002d8:	85 c0                	test   %eax,%eax
  8002da:	74 10                	je     8002ec <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  8002dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e0:	c7 04 24 28 41 80 00 	movl   $0x804128,(%esp)
  8002e7:	e8 fa 00 00 00       	call   8003e6 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  8002ec:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  8002f2:	e8 81 0b 00 00       	call   800e78 <_Z12sys_getenvidv>
  8002f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fa:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800301:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800305:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030d:	c7 04 24 30 41 80 00 	movl   $0x804130,(%esp)
  800314:	e8 cd 00 00 00       	call   8003e6 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  800319:	89 74 24 04          	mov    %esi,0x4(%esp)
  80031d:	8b 45 10             	mov    0x10(%ebp),%eax
  800320:	89 04 24             	mov    %eax,(%esp)
  800323:	e8 5d 00 00 00       	call   800385 <_Z8vcprintfPKcPc>
	cprintf("\n");
  800328:	c7 04 24 a5 40 80 00 	movl   $0x8040a5,(%esp)
  80032f:	e8 b2 00 00 00       	call   8003e6 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800334:	cc                   	int3   
  800335:	eb fd                	jmp    800334 <_Z6_panicPKciS0_z+0x6c>
	...

00800338 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	83 ec 18             	sub    $0x18,%esp
  80033e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800341:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800344:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  800347:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800349:	8b 03                	mov    (%ebx),%eax
  80034b:	8b 55 08             	mov    0x8(%ebp),%edx
  80034e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800352:	83 c0 01             	add    $0x1,%eax
  800355:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800357:	3d ff 00 00 00       	cmp    $0xff,%eax
  80035c:	75 19                	jne    800377 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  80035e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800365:	00 
  800366:	8d 43 08             	lea    0x8(%ebx),%eax
  800369:	89 04 24             	mov    %eax,(%esp)
  80036c:	e8 43 0a 00 00       	call   800db4 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800371:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800377:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80037b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80037e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800381:	89 ec                	mov    %ebp,%esp
  800383:	5d                   	pop    %ebp
  800384:	c3                   	ret    

00800385 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80038e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800395:	00 00 00 
	b.cnt = 0;
  800398:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80039f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8003a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ba:	c7 04 24 38 03 80 00 	movl   $0x800338,(%esp)
  8003c1:	e8 a1 01 00 00       	call   800567 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  8003c6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003d6:	89 04 24             	mov    %eax,(%esp)
  8003d9:	e8 d6 09 00 00       	call   800db4 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  8003de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003ec:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	89 04 24             	mov    %eax,(%esp)
  8003f9:	e8 87 ff ff ff       	call   800385 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	57                   	push   %edi
  800404:	56                   	push   %esi
  800405:	53                   	push   %ebx
  800406:	83 ec 4c             	sub    $0x4c,%esp
  800409:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80040c:	89 d6                	mov    %edx,%esi
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800414:	8b 55 0c             	mov    0xc(%ebp),%edx
  800417:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80041a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80041d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800420:	b8 00 00 00 00       	mov    $0x0,%eax
  800425:	39 d0                	cmp    %edx,%eax
  800427:	72 11                	jb     80043a <_ZL8printnumPFviPvES_yjii+0x3a>
  800429:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80042c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80042f:	76 09                	jbe    80043a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800431:	83 eb 01             	sub    $0x1,%ebx
  800434:	85 db                	test   %ebx,%ebx
  800436:	7f 5d                	jg     800495 <_ZL8printnumPFviPvES_yjii+0x95>
  800438:	eb 6c                	jmp    8004a6 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80043e:	83 eb 01             	sub    $0x1,%ebx
  800441:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800445:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800448:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80044c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800450:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800454:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800457:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80045a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800461:	00 
  800462:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800465:	89 14 24             	mov    %edx,(%esp)
  800468:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80046f:	e8 5c 39 00 00       	call   803dd0 <__udivdi3>
  800474:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800477:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80047a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80047e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800482:	89 04 24             	mov    %eax,(%esp)
  800485:	89 54 24 04          	mov    %edx,0x4(%esp)
  800489:	89 f2                	mov    %esi,%edx
  80048b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80048e:	e8 6d ff ff ff       	call   800400 <_ZL8printnumPFviPvES_yjii>
  800493:	eb 11                	jmp    8004a6 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800495:	89 74 24 04          	mov    %esi,0x4(%esp)
  800499:	89 3c 24             	mov    %edi,(%esp)
  80049c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80049f:	83 eb 01             	sub    $0x1,%ebx
  8004a2:	85 db                	test   %ebx,%ebx
  8004a4:	7f ef                	jg     800495 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004aa:	8b 74 24 04          	mov    0x4(%esp),%esi
  8004ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004b5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004bc:	00 
  8004bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004c0:	89 14 24             	mov    %edx,(%esp)
  8004c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004ca:	e8 11 3a 00 00       	call   803ee0 <__umoddi3>
  8004cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004d3:	0f be 80 53 41 80 00 	movsbl 0x804153(%eax),%eax
  8004da:	89 04 24             	mov    %eax,(%esp)
  8004dd:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8004e0:	83 c4 4c             	add    $0x4c,%esp
  8004e3:	5b                   	pop    %ebx
  8004e4:	5e                   	pop    %esi
  8004e5:	5f                   	pop    %edi
  8004e6:	5d                   	pop    %ebp
  8004e7:	c3                   	ret    

008004e8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004eb:	83 fa 01             	cmp    $0x1,%edx
  8004ee:	7e 0e                	jle    8004fe <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  8004f0:	8b 10                	mov    (%eax),%edx
  8004f2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004f5:	89 08                	mov    %ecx,(%eax)
  8004f7:	8b 02                	mov    (%edx),%eax
  8004f9:	8b 52 04             	mov    0x4(%edx),%edx
  8004fc:	eb 22                	jmp    800520 <_ZL7getuintPPci+0x38>
	else if (lflag)
  8004fe:	85 d2                	test   %edx,%edx
  800500:	74 10                	je     800512 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800502:	8b 10                	mov    (%eax),%edx
  800504:	8d 4a 04             	lea    0x4(%edx),%ecx
  800507:	89 08                	mov    %ecx,(%eax)
  800509:	8b 02                	mov    (%edx),%eax
  80050b:	ba 00 00 00 00       	mov    $0x0,%edx
  800510:	eb 0e                	jmp    800520 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800512:	8b 10                	mov    (%eax),%edx
  800514:	8d 4a 04             	lea    0x4(%edx),%ecx
  800517:	89 08                	mov    %ecx,(%eax)
  800519:	8b 02                	mov    (%edx),%eax
  80051b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800520:	5d                   	pop    %ebp
  800521:	c3                   	ret    

00800522 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800528:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80052c:	8b 10                	mov    (%eax),%edx
  80052e:	3b 50 04             	cmp    0x4(%eax),%edx
  800531:	73 0a                	jae    80053d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800533:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800536:	88 0a                	mov    %cl,(%edx)
  800538:	83 c2 01             	add    $0x1,%edx
  80053b:	89 10                	mov    %edx,(%eax)
}
  80053d:	5d                   	pop    %ebp
  80053e:	c3                   	ret    

0080053f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80053f:	55                   	push   %ebp
  800540:	89 e5                	mov    %esp,%ebp
  800542:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800545:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800548:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80054c:	8b 45 10             	mov    0x10(%ebp),%eax
  80054f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
  800556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	89 04 24             	mov    %eax,(%esp)
  800560:	e8 02 00 00 00       	call   800567 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	57                   	push   %edi
  80056b:	56                   	push   %esi
  80056c:	53                   	push   %ebx
  80056d:	83 ec 3c             	sub    $0x3c,%esp
  800570:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800573:	8b 55 10             	mov    0x10(%ebp),%edx
  800576:	0f b6 02             	movzbl (%edx),%eax
  800579:	89 d3                	mov    %edx,%ebx
  80057b:	83 c3 01             	add    $0x1,%ebx
  80057e:	83 f8 25             	cmp    $0x25,%eax
  800581:	74 2b                	je     8005ae <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800583:	85 c0                	test   %eax,%eax
  800585:	75 10                	jne    800597 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800587:	e9 a5 03 00 00       	jmp    800931 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80058c:	85 c0                	test   %eax,%eax
  80058e:	66 90                	xchg   %ax,%ax
  800590:	75 08                	jne    80059a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800592:	e9 9a 03 00 00       	jmp    800931 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800597:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80059a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059e:	89 04 24             	mov    %eax,(%esp)
  8005a1:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005a3:	0f b6 03             	movzbl (%ebx),%eax
  8005a6:	83 c3 01             	add    $0x1,%ebx
  8005a9:	83 f8 25             	cmp    $0x25,%eax
  8005ac:	75 de                	jne    80058c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8005ae:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8005b2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005b9:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8005be:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ca:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005cd:	eb 2b                	jmp    8005fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005cf:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  8005d2:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8005d6:	eb 22                	jmp    8005fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005db:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8005df:	eb 19                	jmp    8005fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8005e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005eb:	eb 0d                	jmp    8005fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8005ed:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005f0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fa:	0f b6 03             	movzbl (%ebx),%eax
  8005fd:	0f b6 d0             	movzbl %al,%edx
  800600:	8d 73 01             	lea    0x1(%ebx),%esi
  800603:	89 75 10             	mov    %esi,0x10(%ebp)
  800606:	83 e8 23             	sub    $0x23,%eax
  800609:	3c 55                	cmp    $0x55,%al
  80060b:	0f 87 d8 02 00 00    	ja     8008e9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800611:	0f b6 c0             	movzbl %al,%eax
  800614:	ff 24 85 e0 42 80 00 	jmp    *0x8042e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80061b:	83 ea 30             	sub    $0x30,%edx
  80061e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800621:	8b 55 10             	mov    0x10(%ebp),%edx
  800624:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800627:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80062d:	83 fa 09             	cmp    $0x9,%edx
  800630:	77 4e                	ja     800680 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800632:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800635:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800638:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80063b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80063f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800642:	8d 50 d0             	lea    -0x30(%eax),%edx
  800645:	83 fa 09             	cmp    $0x9,%edx
  800648:	76 eb                	jbe    800635 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80064a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80064d:	eb 31                	jmp    800680 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 50 04             	lea    0x4(%eax),%edx
  800655:	89 55 14             	mov    %edx,0x14(%ebp)
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800660:	eb 1e                	jmp    800680 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800662:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800666:	0f 88 75 ff ff ff    	js     8005e1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80066f:	eb 89                	jmp    8005fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800671:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800674:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80067b:	e9 7a ff ff ff       	jmp    8005fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800680:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800684:	0f 89 70 ff ff ff    	jns    8005fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80068a:	e9 5e ff ff ff       	jmp    8005ed <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80068f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800692:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800695:	e9 60 ff ff ff       	jmp    8005fa <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8d 50 04             	lea    0x4(%eax),%edx
  8006a0:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	89 04 24             	mov    %eax,(%esp)
  8006ac:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006af:	e9 bf fe ff ff       	jmp    800573 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	89 c2                	mov    %eax,%edx
  8006c1:	c1 fa 1f             	sar    $0x1f,%edx
  8006c4:	31 d0                	xor    %edx,%eax
  8006c6:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006c8:	83 f8 14             	cmp    $0x14,%eax
  8006cb:	7f 0f                	jg     8006dc <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  8006cd:	8b 14 85 40 44 80 00 	mov    0x804440(,%eax,4),%edx
  8006d4:	85 d2                	test   %edx,%edx
  8006d6:	0f 85 35 02 00 00    	jne    800911 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  8006dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006e0:	c7 44 24 08 6b 41 80 	movl   $0x80416b,0x8(%esp)
  8006e7:	00 
  8006e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ef:	89 34 24             	mov    %esi,(%esp)
  8006f2:	e8 48 fe ff ff       	call   80053f <_Z8printfmtPFviPvES_PKcz>
  8006f7:	e9 77 fe ff ff       	jmp    800573 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8006fc:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800702:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8d 50 04             	lea    0x4(%eax),%edx
  80070b:	89 55 14             	mov    %edx,0x14(%ebp)
  80070e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800710:	85 db                	test   %ebx,%ebx
  800712:	ba 64 41 80 00       	mov    $0x804164,%edx
  800717:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80071a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80071e:	7e 72                	jle    800792 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800720:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800724:	74 6c                	je     800792 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800726:	89 74 24 04          	mov    %esi,0x4(%esp)
  80072a:	89 1c 24             	mov    %ebx,(%esp)
  80072d:	e8 a9 02 00 00       	call   8009db <_Z7strnlenPKcj>
  800732:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800735:	29 c2                	sub    %eax,%edx
  800737:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80073a:	85 d2                	test   %edx,%edx
  80073c:	7e 54                	jle    800792 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80073e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800742:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800745:	89 d3                	mov    %edx,%ebx
  800747:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80074a:	89 c6                	mov    %eax,%esi
  80074c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800750:	89 34 24             	mov    %esi,(%esp)
  800753:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800756:	83 eb 01             	sub    $0x1,%ebx
  800759:	85 db                	test   %ebx,%ebx
  80075b:	7f ef                	jg     80074c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80075d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800760:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800763:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80076a:	eb 26                	jmp    800792 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80076c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80076f:	83 fa 5e             	cmp    $0x5e,%edx
  800772:	76 10                	jbe    800784 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800774:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800778:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80077f:	ff 55 08             	call   *0x8(%ebp)
  800782:	eb 0a                	jmp    80078e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800784:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800788:	89 04 24             	mov    %eax,(%esp)
  80078b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800792:	0f be 03             	movsbl (%ebx),%eax
  800795:	83 c3 01             	add    $0x1,%ebx
  800798:	85 c0                	test   %eax,%eax
  80079a:	74 11                	je     8007ad <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80079c:	85 f6                	test   %esi,%esi
  80079e:	78 05                	js     8007a5 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  8007a0:	83 ee 01             	sub    $0x1,%esi
  8007a3:	78 0d                	js     8007b2 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  8007a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007a9:	75 c1                	jne    80076c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  8007ab:	eb d7                	jmp    800784 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b0:	eb 03                	jmp    8007b5 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  8007b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b5:	85 c0                	test   %eax,%eax
  8007b7:	0f 8e b6 fd ff ff    	jle    800573 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8007bd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8007c0:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  8007c3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007ce:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d0:	83 eb 01             	sub    $0x1,%ebx
  8007d3:	85 db                	test   %ebx,%ebx
  8007d5:	7f ec                	jg     8007c3 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  8007d7:	e9 97 fd ff ff       	jmp    800573 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007dc:	83 f9 01             	cmp    $0x1,%ecx
  8007df:	90                   	nop
  8007e0:	7e 10                	jle    8007f2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8d 50 08             	lea    0x8(%eax),%edx
  8007e8:	89 55 14             	mov    %edx,0x14(%ebp)
  8007eb:	8b 18                	mov    (%eax),%ebx
  8007ed:	8b 70 04             	mov    0x4(%eax),%esi
  8007f0:	eb 26                	jmp    800818 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  8007f2:	85 c9                	test   %ecx,%ecx
  8007f4:	74 12                	je     800808 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8d 50 04             	lea    0x4(%eax),%edx
  8007fc:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ff:	8b 18                	mov    (%eax),%ebx
  800801:	89 de                	mov    %ebx,%esi
  800803:	c1 fe 1f             	sar    $0x1f,%esi
  800806:	eb 10                	jmp    800818 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8d 50 04             	lea    0x4(%eax),%edx
  80080e:	89 55 14             	mov    %edx,0x14(%ebp)
  800811:	8b 18                	mov    (%eax),%ebx
  800813:	89 de                	mov    %ebx,%esi
  800815:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800818:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80081d:	85 f6                	test   %esi,%esi
  80081f:	0f 89 8c 00 00 00    	jns    8008b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800825:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800829:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800830:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800833:	f7 db                	neg    %ebx
  800835:	83 d6 00             	adc    $0x0,%esi
  800838:	f7 de                	neg    %esi
			}
			base = 10;
  80083a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083f:	eb 70                	jmp    8008b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800841:	89 ca                	mov    %ecx,%edx
  800843:	8d 45 14             	lea    0x14(%ebp),%eax
  800846:	e8 9d fc ff ff       	call   8004e8 <_ZL7getuintPPci>
  80084b:	89 c3                	mov    %eax,%ebx
  80084d:	89 d6                	mov    %edx,%esi
			base = 10;
  80084f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800854:	eb 5b                	jmp    8008b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800856:	89 ca                	mov    %ecx,%edx
  800858:	8d 45 14             	lea    0x14(%ebp),%eax
  80085b:	e8 88 fc ff ff       	call   8004e8 <_ZL7getuintPPci>
  800860:	89 c3                	mov    %eax,%ebx
  800862:	89 d6                	mov    %edx,%esi
			base = 8;
  800864:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800869:	eb 46                	jmp    8008b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80086b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80086f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800876:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800879:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80087d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800884:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8d 50 04             	lea    0x4(%eax),%edx
  80088d:	89 55 14             	mov    %edx,0x14(%ebp)
  800890:	8b 18                	mov    (%eax),%ebx
  800892:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800897:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80089c:	eb 13                	jmp    8008b1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089e:	89 ca                	mov    %ecx,%edx
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a3:	e8 40 fc ff ff       	call   8004e8 <_ZL7getuintPPci>
  8008a8:	89 c3                	mov    %eax,%ebx
  8008aa:	89 d6                	mov    %edx,%esi
			base = 16;
  8008ac:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b1:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8008b5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8008b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008bc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c4:	89 1c 24             	mov    %ebx,(%esp)
  8008c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008cb:	89 fa                	mov    %edi,%edx
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	e8 2b fb ff ff       	call   800400 <_ZL8printnumPFviPvES_yjii>
			break;
  8008d5:	e9 99 fc ff ff       	jmp    800573 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008de:	89 14 24             	mov    %edx,(%esp)
  8008e1:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008e4:	e9 8a fc ff ff       	jmp    800573 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ed:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008f4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008f7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008fa:	89 d8                	mov    %ebx,%eax
  8008fc:	eb 02                	jmp    800900 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  8008fe:	89 d0                	mov    %edx,%eax
  800900:	8d 50 ff             	lea    -0x1(%eax),%edx
  800903:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800907:	75 f5                	jne    8008fe <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800909:	89 45 10             	mov    %eax,0x10(%ebp)
  80090c:	e9 62 fc ff ff       	jmp    800573 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800911:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800915:	c7 44 24 08 de 44 80 	movl   $0x8044de,0x8(%esp)
  80091c:	00 
  80091d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800921:	8b 75 08             	mov    0x8(%ebp),%esi
  800924:	89 34 24             	mov    %esi,(%esp)
  800927:	e8 13 fc ff ff       	call   80053f <_Z8printfmtPFviPvES_PKcz>
  80092c:	e9 42 fc ff ff       	jmp    800573 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800931:	83 c4 3c             	add    $0x3c,%esp
  800934:	5b                   	pop    %ebx
  800935:	5e                   	pop    %esi
  800936:	5f                   	pop    %edi
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 28             	sub    $0x28,%esp
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80094c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800953:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800956:	85 c0                	test   %eax,%eax
  800958:	74 30                	je     80098a <_Z9vsnprintfPciPKcS_+0x51>
  80095a:	85 d2                	test   %edx,%edx
  80095c:	7e 2c                	jle    80098a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800965:	8b 45 10             	mov    0x10(%ebp),%eax
  800968:	89 44 24 08          	mov    %eax,0x8(%esp)
  80096c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80096f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800973:	c7 04 24 22 05 80 00 	movl   $0x800522,(%esp)
  80097a:	e8 e8 fb ff ff       	call   800567 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80097f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800982:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800988:	eb 05                	jmp    80098f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80098a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800997:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80099a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80099e:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 04 24             	mov    %eax,(%esp)
  8009b2:	e8 82 ff ff ff       	call   800939 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    
  8009b9:	00 00                	add    %al,(%eax)
  8009bb:	00 00                	add    %al,(%eax)
  8009bd:	00 00                	add    %al,(%eax)
	...

008009c0 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cb:	80 3a 00             	cmpb   $0x0,(%edx)
  8009ce:	74 09                	je     8009d9 <_Z6strlenPKc+0x19>
		n++;
  8009d0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009d7:	75 f7                	jne    8009d0 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 0b                	je     8009f8 <_Z7strnlenPKcj+0x1d>
  8009ed:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009f1:	74 05                	je     8009f8 <_Z7strnlenPKcj+0x1d>
		n++;
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	eb f1                	jmp    8009e9 <_Z7strnlenPKcj+0xe>
	return n;
}
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800a04:	ba 00 00 00 00       	mov    $0x0,%edx
  800a09:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a0d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a10:	83 c2 01             	add    $0x1,%edx
  800a13:	84 c9                	test   %cl,%cl
  800a15:	75 f2                	jne    800a09 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800a17:	5b                   	pop    %ebx
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	56                   	push   %esi
  800a1e:	53                   	push   %ebx
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a25:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800a28:	85 f6                	test   %esi,%esi
  800a2a:	74 18                	je     800a44 <_Z7strncpyPcPKcj+0x2a>
  800a2c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a31:	0f b6 1a             	movzbl (%edx),%ebx
  800a34:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a37:	80 3a 01             	cmpb   $0x1,(%edx)
  800a3a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800a3d:	83 c1 01             	add    $0x1,%ecx
  800a40:	39 ce                	cmp    %ecx,%esi
  800a42:	77 ed                	ja     800a31 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a44:	5b                   	pop    %ebx
  800a45:	5e                   	pop    %esi
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	56                   	push   %esi
  800a4c:	53                   	push   %ebx
  800a4d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a53:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800a56:	89 f0                	mov    %esi,%eax
  800a58:	85 d2                	test   %edx,%edx
  800a5a:	74 17                	je     800a73 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800a5c:	83 ea 01             	sub    $0x1,%edx
  800a5f:	74 18                	je     800a79 <_Z7strlcpyPcPKcj+0x31>
  800a61:	80 39 00             	cmpb   $0x0,(%ecx)
  800a64:	74 17                	je     800a7d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800a66:	0f b6 19             	movzbl (%ecx),%ebx
  800a69:	88 18                	mov    %bl,(%eax)
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	83 c1 01             	add    $0x1,%ecx
  800a71:	eb e9                	jmp    800a5c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800a73:	29 f0                	sub    %esi,%eax
}
  800a75:	5b                   	pop    %ebx
  800a76:	5e                   	pop    %esi
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a79:	89 c2                	mov    %eax,%edx
  800a7b:	eb 02                	jmp    800a7f <_Z7strlcpyPcPKcj+0x37>
  800a7d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a7f:	c6 02 00             	movb   $0x0,(%edx)
  800a82:	eb ef                	jmp    800a73 <_Z7strlcpyPcPKcj+0x2b>

00800a84 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a8d:	0f b6 01             	movzbl (%ecx),%eax
  800a90:	84 c0                	test   %al,%al
  800a92:	74 0c                	je     800aa0 <_Z6strcmpPKcS0_+0x1c>
  800a94:	3a 02                	cmp    (%edx),%al
  800a96:	75 08                	jne    800aa0 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800a98:	83 c1 01             	add    $0x1,%ecx
  800a9b:	83 c2 01             	add    $0x1,%edx
  800a9e:	eb ed                	jmp    800a8d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800aa0:	0f b6 c0             	movzbl %al,%eax
  800aa3:	0f b6 12             	movzbl (%edx),%edx
  800aa6:	29 d0                	sub    %edx,%eax
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	53                   	push   %ebx
  800aae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ab4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800ab7:	85 d2                	test   %edx,%edx
  800ab9:	74 16                	je     800ad1 <_Z7strncmpPKcS0_j+0x27>
  800abb:	0f b6 01             	movzbl (%ecx),%eax
  800abe:	84 c0                	test   %al,%al
  800ac0:	74 17                	je     800ad9 <_Z7strncmpPKcS0_j+0x2f>
  800ac2:	3a 03                	cmp    (%ebx),%al
  800ac4:	75 13                	jne    800ad9 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800ac6:	83 ea 01             	sub    $0x1,%edx
  800ac9:	83 c1 01             	add    $0x1,%ecx
  800acc:	83 c3 01             	add    $0x1,%ebx
  800acf:	eb e6                	jmp    800ab7 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800ad6:	5b                   	pop    %ebx
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800ad9:	0f b6 01             	movzbl (%ecx),%eax
  800adc:	0f b6 13             	movzbl (%ebx),%edx
  800adf:	29 d0                	sub    %edx,%eax
  800ae1:	eb f3                	jmp    800ad6 <_Z7strncmpPKcS0_j+0x2c>

00800ae3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aed:	0f b6 10             	movzbl (%eax),%edx
  800af0:	84 d2                	test   %dl,%dl
  800af2:	74 1f                	je     800b13 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800af4:	38 ca                	cmp    %cl,%dl
  800af6:	75 0a                	jne    800b02 <_Z6strchrPKcc+0x1f>
  800af8:	eb 1e                	jmp    800b18 <_Z6strchrPKcc+0x35>
  800afa:	38 ca                	cmp    %cl,%dl
  800afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b00:	74 16                	je     800b18 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b02:	83 c0 01             	add    $0x1,%eax
  800b05:	0f b6 10             	movzbl (%eax),%edx
  800b08:	84 d2                	test   %dl,%dl
  800b0a:	75 ee                	jne    800afa <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	eb 05                	jmp    800b18 <_Z6strchrPKcc+0x35>
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b24:	0f b6 10             	movzbl (%eax),%edx
  800b27:	84 d2                	test   %dl,%dl
  800b29:	74 14                	je     800b3f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800b2b:	38 ca                	cmp    %cl,%dl
  800b2d:	75 06                	jne    800b35 <_Z7strfindPKcc+0x1b>
  800b2f:	eb 0e                	jmp    800b3f <_Z7strfindPKcc+0x25>
  800b31:	38 ca                	cmp    %cl,%dl
  800b33:	74 0a                	je     800b3f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b35:	83 c0 01             	add    $0x1,%eax
  800b38:	0f b6 10             	movzbl (%eax),%edx
  800b3b:	84 d2                	test   %dl,%dl
  800b3d:	75 f2                	jne    800b31 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	89 1c 24             	mov    %ebx,(%esp)
  800b4a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b4e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b52:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800b5b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b61:	75 25                	jne    800b88 <memset+0x47>
  800b63:	f6 c1 03             	test   $0x3,%cl
  800b66:	75 20                	jne    800b88 <memset+0x47>
		c &= 0xFF;
  800b68:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b6b:	89 d3                	mov    %edx,%ebx
  800b6d:	c1 e3 08             	shl    $0x8,%ebx
  800b70:	89 d6                	mov    %edx,%esi
  800b72:	c1 e6 18             	shl    $0x18,%esi
  800b75:	89 d0                	mov    %edx,%eax
  800b77:	c1 e0 10             	shl    $0x10,%eax
  800b7a:	09 f0                	or     %esi,%eax
  800b7c:	09 d0                	or     %edx,%eax
  800b7e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800b80:	c1 e9 02             	shr    $0x2,%ecx
  800b83:	fc                   	cld    
  800b84:	f3 ab                	rep stos %eax,%es:(%edi)
  800b86:	eb 03                	jmp    800b8b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800b88:	fc                   	cld    
  800b89:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800b8b:	89 f8                	mov    %edi,%eax
  800b8d:	8b 1c 24             	mov    (%esp),%ebx
  800b90:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b94:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b98:	89 ec                	mov    %ebp,%esp
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	89 34 24             	mov    %esi,(%esp)
  800ba5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8b 75 0c             	mov    0xc(%ebp),%esi
  800baf:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800bb2:	39 c6                	cmp    %eax,%esi
  800bb4:	73 36                	jae    800bec <memmove+0x50>
  800bb6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb9:	39 d0                	cmp    %edx,%eax
  800bbb:	73 2f                	jae    800bec <memmove+0x50>
		s += n;
		d += n;
  800bbd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800bc0:	f6 c2 03             	test   $0x3,%dl
  800bc3:	75 1b                	jne    800be0 <memmove+0x44>
  800bc5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bcb:	75 13                	jne    800be0 <memmove+0x44>
  800bcd:	f6 c1 03             	test   $0x3,%cl
  800bd0:	75 0e                	jne    800be0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bd2:	83 ef 04             	sub    $0x4,%edi
  800bd5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd8:	c1 e9 02             	shr    $0x2,%ecx
  800bdb:	fd                   	std    
  800bdc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bde:	eb 09                	jmp    800be9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800be0:	83 ef 01             	sub    $0x1,%edi
  800be3:	8d 72 ff             	lea    -0x1(%edx),%esi
  800be6:	fd                   	std    
  800be7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be9:	fc                   	cld    
  800bea:	eb 20                	jmp    800c0c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800bec:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf2:	75 13                	jne    800c07 <memmove+0x6b>
  800bf4:	a8 03                	test   $0x3,%al
  800bf6:	75 0f                	jne    800c07 <memmove+0x6b>
  800bf8:	f6 c1 03             	test   $0x3,%cl
  800bfb:	75 0a                	jne    800c07 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bfd:	c1 e9 02             	shr    $0x2,%ecx
  800c00:	89 c7                	mov    %eax,%edi
  800c02:	fc                   	cld    
  800c03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c05:	eb 05                	jmp    800c0c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800c07:	89 c7                	mov    %eax,%edi
  800c09:	fc                   	cld    
  800c0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800c0c:	8b 34 24             	mov    (%esp),%esi
  800c0f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c13:	89 ec                	mov    %ebp,%esp
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	89 34 24             	mov    %esi,(%esp)
  800c20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800c2d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c33:	75 13                	jne    800c48 <memcpy+0x31>
  800c35:	a8 03                	test   $0x3,%al
  800c37:	75 0f                	jne    800c48 <memcpy+0x31>
  800c39:	f6 c1 03             	test   $0x3,%cl
  800c3c:	75 0a                	jne    800c48 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c3e:	c1 e9 02             	shr    $0x2,%ecx
  800c41:	89 c7                	mov    %eax,%edi
  800c43:	fc                   	cld    
  800c44:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c46:	eb 05                	jmp    800c4d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800c48:	89 c7                	mov    %eax,%edi
  800c4a:	fc                   	cld    
  800c4b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800c4d:	8b 34 24             	mov    (%esp),%esi
  800c50:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c54:	89 ec                	mov    %ebp,%esp
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c61:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c64:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800c67:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800c6c:	85 ff                	test   %edi,%edi
  800c6e:	74 38                	je     800ca8 <memcmp+0x50>
		if (*s1 != *s2)
  800c70:	0f b6 03             	movzbl (%ebx),%eax
  800c73:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800c76:	83 ef 01             	sub    $0x1,%edi
  800c79:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800c7e:	38 c8                	cmp    %cl,%al
  800c80:	74 1d                	je     800c9f <memcmp+0x47>
  800c82:	eb 11                	jmp    800c95 <memcmp+0x3d>
  800c84:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c89:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800c8e:	83 c2 01             	add    $0x1,%edx
  800c91:	38 c8                	cmp    %cl,%al
  800c93:	74 0a                	je     800c9f <memcmp+0x47>
			return *s1 - *s2;
  800c95:	0f b6 c0             	movzbl %al,%eax
  800c98:	0f b6 c9             	movzbl %cl,%ecx
  800c9b:	29 c8                	sub    %ecx,%eax
  800c9d:	eb 09                	jmp    800ca8 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800c9f:	39 fa                	cmp    %edi,%edx
  800ca1:	75 e1                	jne    800c84 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	53                   	push   %ebx
  800cb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800cb4:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800cb6:	89 da                	mov    %ebx,%edx
  800cb8:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800cbb:	39 d3                	cmp    %edx,%ebx
  800cbd:	73 15                	jae    800cd4 <memfind+0x27>
		if (*s == (unsigned char) c)
  800cbf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800cc3:	38 0b                	cmp    %cl,(%ebx)
  800cc5:	75 06                	jne    800ccd <memfind+0x20>
  800cc7:	eb 0b                	jmp    800cd4 <memfind+0x27>
  800cc9:	38 08                	cmp    %cl,(%eax)
  800ccb:	74 07                	je     800cd4 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800ccd:	83 c0 01             	add    $0x1,%eax
  800cd0:	39 c2                	cmp    %eax,%edx
  800cd2:	77 f5                	ja     800cc9 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cd4:	5b                   	pop    %ebx
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce3:	0f b6 02             	movzbl (%edx),%eax
  800ce6:	3c 20                	cmp    $0x20,%al
  800ce8:	74 04                	je     800cee <_Z6strtolPKcPPci+0x17>
  800cea:	3c 09                	cmp    $0x9,%al
  800cec:	75 0e                	jne    800cfc <_Z6strtolPKcPPci+0x25>
		s++;
  800cee:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf1:	0f b6 02             	movzbl (%edx),%eax
  800cf4:	3c 20                	cmp    $0x20,%al
  800cf6:	74 f6                	je     800cee <_Z6strtolPKcPPci+0x17>
  800cf8:	3c 09                	cmp    $0x9,%al
  800cfa:	74 f2                	je     800cee <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cfc:	3c 2b                	cmp    $0x2b,%al
  800cfe:	75 0a                	jne    800d0a <_Z6strtolPKcPPci+0x33>
		s++;
  800d00:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d03:	bf 00 00 00 00       	mov    $0x0,%edi
  800d08:	eb 10                	jmp    800d1a <_Z6strtolPKcPPci+0x43>
  800d0a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d0f:	3c 2d                	cmp    $0x2d,%al
  800d11:	75 07                	jne    800d1a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800d13:	83 c2 01             	add    $0x1,%edx
  800d16:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1a:	85 db                	test   %ebx,%ebx
  800d1c:	0f 94 c0             	sete   %al
  800d1f:	74 05                	je     800d26 <_Z6strtolPKcPPci+0x4f>
  800d21:	83 fb 10             	cmp    $0x10,%ebx
  800d24:	75 15                	jne    800d3b <_Z6strtolPKcPPci+0x64>
  800d26:	80 3a 30             	cmpb   $0x30,(%edx)
  800d29:	75 10                	jne    800d3b <_Z6strtolPKcPPci+0x64>
  800d2b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d2f:	75 0a                	jne    800d3b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800d31:	83 c2 02             	add    $0x2,%edx
  800d34:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d39:	eb 13                	jmp    800d4e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0f                	je     800d4e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d3f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d44:	80 3a 30             	cmpb   $0x30,(%edx)
  800d47:	75 05                	jne    800d4e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800d49:	83 c2 01             	add    $0x1,%edx
  800d4c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d53:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d55:	0f b6 0a             	movzbl (%edx),%ecx
  800d58:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d5b:	80 fb 09             	cmp    $0x9,%bl
  800d5e:	77 08                	ja     800d68 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800d60:	0f be c9             	movsbl %cl,%ecx
  800d63:	83 e9 30             	sub    $0x30,%ecx
  800d66:	eb 1e                	jmp    800d86 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800d68:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800d6b:	80 fb 19             	cmp    $0x19,%bl
  800d6e:	77 08                	ja     800d78 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800d70:	0f be c9             	movsbl %cl,%ecx
  800d73:	83 e9 57             	sub    $0x57,%ecx
  800d76:	eb 0e                	jmp    800d86 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800d78:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800d7b:	80 fb 19             	cmp    $0x19,%bl
  800d7e:	77 15                	ja     800d95 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800d80:	0f be c9             	movsbl %cl,%ecx
  800d83:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d86:	39 f1                	cmp    %esi,%ecx
  800d88:	7d 0f                	jge    800d99 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800d8a:	83 c2 01             	add    $0x1,%edx
  800d8d:	0f af c6             	imul   %esi,%eax
  800d90:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800d93:	eb c0                	jmp    800d55 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800d95:	89 c1                	mov    %eax,%ecx
  800d97:	eb 02                	jmp    800d9b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d99:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9f:	74 05                	je     800da6 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800da1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800da4:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800da6:	89 ca                	mov    %ecx,%edx
  800da8:	f7 da                	neg    %edx
  800daa:	85 ff                	test   %edi,%edi
  800dac:	0f 45 c2             	cmovne %edx,%eax
}
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 0c             	sub    $0xc,%esp
  800dba:	89 1c 24             	mov    %ebx,(%esp)
  800dbd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dc1:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	89 c3                	mov    %eax,%ebx
  800dd2:	89 c7                	mov    %eax,%edi
  800dd4:	89 c6                	mov    %eax,%esi
  800dd6:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dd8:	8b 1c 24             	mov    (%esp),%ebx
  800ddb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ddf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800de3:	89 ec                	mov    %ebp,%esp
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 0c             	sub    $0xc,%esp
  800ded:	89 1c 24             	mov    %ebx,(%esp)
  800df0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800df4:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800df8:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfd:	b8 01 00 00 00       	mov    $0x1,%eax
  800e02:	89 d1                	mov    %edx,%ecx
  800e04:	89 d3                	mov    %edx,%ebx
  800e06:	89 d7                	mov    %edx,%edi
  800e08:	89 d6                	mov    %edx,%esi
  800e0a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e0c:	8b 1c 24             	mov    (%esp),%ebx
  800e0f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e13:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e17:	89 ec                	mov    %ebp,%esp
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 38             	sub    $0x38,%esp
  800e21:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e24:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e27:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2f:	b8 03 00 00 00       	mov    $0x3,%eax
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	89 cb                	mov    %ecx,%ebx
  800e39:	89 cf                	mov    %ecx,%edi
  800e3b:	89 ce                	mov    %ecx,%esi
  800e3d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	7e 28                	jle    800e6b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e43:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e47:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e4e:	00 
  800e4f:	c7 44 24 08 94 44 80 	movl   $0x804494,0x8(%esp)
  800e56:	00 
  800e57:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e5e:	00 
  800e5f:	c7 04 24 b1 44 80 00 	movl   $0x8044b1,(%esp)
  800e66:	e8 5d f4 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e6b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e6e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e71:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e74:	89 ec                	mov    %ebp,%esp
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	89 1c 24             	mov    %ebx,(%esp)
  800e81:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e85:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e89:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8e:	b8 02 00 00 00       	mov    $0x2,%eax
  800e93:	89 d1                	mov    %edx,%ecx
  800e95:	89 d3                	mov    %edx,%ebx
  800e97:	89 d7                	mov    %edx,%edi
  800e99:	89 d6                	mov    %edx,%esi
  800e9b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e9d:	8b 1c 24             	mov    (%esp),%ebx
  800ea0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ea4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ea8:	89 ec                	mov    %ebp,%esp
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	83 ec 0c             	sub    $0xc,%esp
  800eb2:	89 1c 24             	mov    %ebx,(%esp)
  800eb5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eb9:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ebd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ec7:	89 d1                	mov    %edx,%ecx
  800ec9:	89 d3                	mov    %edx,%ebx
  800ecb:	89 d7                	mov    %edx,%edi
  800ecd:	89 d6                	mov    %edx,%esi
  800ecf:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ed1:	8b 1c 24             	mov    (%esp),%ebx
  800ed4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ed8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800edc:	89 ec                	mov    %ebp,%esp
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 38             	sub    $0x38,%esp
  800ee6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eec:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800eef:	be 00 00 00 00       	mov    $0x0,%esi
  800ef4:	b8 08 00 00 00       	mov    $0x8,%eax
  800ef9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	89 f7                	mov    %esi,%edi
  800f04:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f06:	85 c0                	test   %eax,%eax
  800f08:	7e 28                	jle    800f32 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f15:	00 
  800f16:	c7 44 24 08 94 44 80 	movl   $0x804494,0x8(%esp)
  800f1d:	00 
  800f1e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f25:	00 
  800f26:	c7 04 24 b1 44 80 00 	movl   $0x8044b1,(%esp)
  800f2d:	e8 96 f3 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f32:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f35:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f38:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f3b:	89 ec                	mov    %ebp,%esp
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	83 ec 38             	sub    $0x38,%esp
  800f45:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f48:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f4b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f4e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f53:	8b 75 18             	mov    0x18(%ebp),%esi
  800f56:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f59:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f64:	85 c0                	test   %eax,%eax
  800f66:	7e 28                	jle    800f90 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f68:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f6c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f73:	00 
  800f74:	c7 44 24 08 94 44 80 	movl   $0x804494,0x8(%esp)
  800f7b:	00 
  800f7c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f83:	00 
  800f84:	c7 04 24 b1 44 80 00 	movl   $0x8044b1,(%esp)
  800f8b:	e8 38 f3 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f90:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f93:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f96:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f99:	89 ec                	mov    %ebp,%esp
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	83 ec 38             	sub    $0x38,%esp
  800fa3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fa6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa9:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	89 df                	mov    %ebx,%edi
  800fbe:	89 de                	mov    %ebx,%esi
  800fc0:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7e 28                	jle    800fee <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fd1:	00 
  800fd2:	c7 44 24 08 94 44 80 	movl   $0x804494,0x8(%esp)
  800fd9:	00 
  800fda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe1:	00 
  800fe2:	c7 04 24 b1 44 80 00 	movl   $0x8044b1,(%esp)
  800fe9:	e8 da f2 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ff1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ff4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ff7:	89 ec                	mov    %ebp,%esp
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 38             	sub    $0x38,%esp
  801001:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801004:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801007:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80100a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100f:	b8 05 00 00 00       	mov    $0x5,%eax
  801014:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	89 df                	mov    %ebx,%edi
  80101c:	89 de                	mov    %ebx,%esi
  80101e:	cd 30                	int    $0x30

	if(check && ret > 0)
  801020:	85 c0                	test   %eax,%eax
  801022:	7e 28                	jle    80104c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801024:	89 44 24 10          	mov    %eax,0x10(%esp)
  801028:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80102f:	00 
  801030:	c7 44 24 08 94 44 80 	movl   $0x804494,0x8(%esp)
  801037:	00 
  801038:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103f:	00 
  801040:	c7 04 24 b1 44 80 00 	movl   $0x8044b1,(%esp)
  801047:	e8 7c f2 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80104c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80104f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801052:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801055:	89 ec                	mov    %ebp,%esp
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    

00801059 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 38             	sub    $0x38,%esp
  80105f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801062:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801065:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801068:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106d:	b8 06 00 00 00       	mov    $0x6,%eax
  801072:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801075:	8b 55 08             	mov    0x8(%ebp),%edx
  801078:	89 df                	mov    %ebx,%edi
  80107a:	89 de                	mov    %ebx,%esi
  80107c:	cd 30                	int    $0x30

	if(check && ret > 0)
  80107e:	85 c0                	test   %eax,%eax
  801080:	7e 28                	jle    8010aa <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801082:	89 44 24 10          	mov    %eax,0x10(%esp)
  801086:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80108d:	00 
  80108e:	c7 44 24 08 94 44 80 	movl   $0x804494,0x8(%esp)
  801095:	00 
  801096:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80109d:	00 
  80109e:	c7 04 24 b1 44 80 00 	movl   $0x8044b1,(%esp)
  8010a5:	e8 1e f2 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  8010aa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ad:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010b0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010b3:	89 ec                	mov    %ebp,%esp
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	83 ec 38             	sub    $0x38,%esp
  8010bd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010c3:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cb:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d6:	89 df                	mov    %ebx,%edi
  8010d8:	89 de                	mov    %ebx,%esi
  8010da:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	7e 28                	jle    801108 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e4:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8010eb:	00 
  8010ec:	c7 44 24 08 94 44 80 	movl   $0x804494,0x8(%esp)
  8010f3:	00 
  8010f4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010fb:	00 
  8010fc:	c7 04 24 b1 44 80 00 	movl   $0x8044b1,(%esp)
  801103:	e8 c0 f1 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801108:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80110b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80110e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801111:	89 ec                	mov    %ebp,%esp
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 38             	sub    $0x38,%esp
  80111b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80111e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801121:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801124:	bb 00 00 00 00       	mov    $0x0,%ebx
  801129:	b8 0c 00 00 00       	mov    $0xc,%eax
  80112e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801131:	8b 55 08             	mov    0x8(%ebp),%edx
  801134:	89 df                	mov    %ebx,%edi
  801136:	89 de                	mov    %ebx,%esi
  801138:	cd 30                	int    $0x30

	if(check && ret > 0)
  80113a:	85 c0                	test   %eax,%eax
  80113c:	7e 28                	jle    801166 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80113e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801142:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801149:	00 
  80114a:	c7 44 24 08 94 44 80 	movl   $0x804494,0x8(%esp)
  801151:	00 
  801152:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801159:	00 
  80115a:	c7 04 24 b1 44 80 00 	movl   $0x8044b1,(%esp)
  801161:	e8 62 f1 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801166:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801169:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80116c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80116f:	89 ec                	mov    %ebp,%esp
  801171:	5d                   	pop    %ebp
  801172:	c3                   	ret    

00801173 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	83 ec 0c             	sub    $0xc,%esp
  801179:	89 1c 24             	mov    %ebx,(%esp)
  80117c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801180:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801184:	be 00 00 00 00       	mov    $0x0,%esi
  801189:	b8 0d 00 00 00       	mov    $0xd,%eax
  80118e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801191:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801194:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801197:	8b 55 08             	mov    0x8(%ebp),%edx
  80119a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80119c:	8b 1c 24             	mov    (%esp),%ebx
  80119f:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011a3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011a7:	89 ec                	mov    %ebp,%esp
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 38             	sub    $0x38,%esp
  8011b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011bf:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c7:	89 cb                	mov    %ecx,%ebx
  8011c9:	89 cf                	mov    %ecx,%edi
  8011cb:	89 ce                	mov    %ecx,%esi
  8011cd:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	7e 28                	jle    8011fb <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d7:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8011de:	00 
  8011df:	c7 44 24 08 94 44 80 	movl   $0x804494,0x8(%esp)
  8011e6:	00 
  8011e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ee:	00 
  8011ef:	c7 04 24 b1 44 80 00 	movl   $0x8044b1,(%esp)
  8011f6:	e8 cd f0 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801201:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801204:	89 ec                	mov    %ebp,%esp
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 0c             	sub    $0xc,%esp
  80120e:	89 1c 24             	mov    %ebx,(%esp)
  801211:	89 74 24 04          	mov    %esi,0x4(%esp)
  801215:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801219:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801223:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	89 df                	mov    %ebx,%edi
  80122b:	89 de                	mov    %ebx,%esi
  80122d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80122f:	8b 1c 24             	mov    (%esp),%ebx
  801232:	8b 74 24 04          	mov    0x4(%esp),%esi
  801236:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80123a:	89 ec                	mov    %ebp,%esp
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    

0080123e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 0c             	sub    $0xc,%esp
  801244:	89 1c 24             	mov    %ebx,(%esp)
  801247:	89 74 24 04          	mov    %esi,0x4(%esp)
  80124b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80124f:	ba 00 00 00 00       	mov    $0x0,%edx
  801254:	b8 11 00 00 00       	mov    $0x11,%eax
  801259:	89 d1                	mov    %edx,%ecx
  80125b:	89 d3                	mov    %edx,%ebx
  80125d:	89 d7                	mov    %edx,%edi
  80125f:	89 d6                	mov    %edx,%esi
  801261:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801263:	8b 1c 24             	mov    (%esp),%ebx
  801266:	8b 74 24 04          	mov    0x4(%esp),%esi
  80126a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80126e:	89 ec                	mov    %ebp,%esp
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    

00801272 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 0c             	sub    $0xc,%esp
  801278:	89 1c 24             	mov    %ebx,(%esp)
  80127b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80127f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801283:	bb 00 00 00 00       	mov    $0x0,%ebx
  801288:	b8 12 00 00 00       	mov    $0x12,%eax
  80128d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801290:	8b 55 08             	mov    0x8(%ebp),%edx
  801293:	89 df                	mov    %ebx,%edi
  801295:	89 de                	mov    %ebx,%esi
  801297:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801299:	8b 1c 24             	mov    (%esp),%ebx
  80129c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012a0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012a4:	89 ec                	mov    %ebp,%esp
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	83 ec 0c             	sub    $0xc,%esp
  8012ae:	89 1c 24             	mov    %ebx,(%esp)
  8012b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012b5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012be:	b8 13 00 00 00       	mov    $0x13,%eax
  8012c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c6:	89 cb                	mov    %ecx,%ebx
  8012c8:	89 cf                	mov    %ecx,%edi
  8012ca:	89 ce                	mov    %ecx,%esi
  8012cc:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  8012ce:	8b 1c 24             	mov    (%esp),%ebx
  8012d1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012d5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012d9:	89 ec                	mov    %ebp,%esp
  8012db:	5d                   	pop    %ebp
  8012dc:	c3                   	ret    

008012dd <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	89 1c 24             	mov    %ebx,(%esp)
  8012e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012ea:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8012f3:	8b 75 18             	mov    0x18(%ebp),%esi
  8012f6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801302:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801304:	8b 1c 24             	mov    (%esp),%ebx
  801307:	8b 74 24 04          	mov    0x4(%esp),%esi
  80130b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80130f:	89 ec                	mov    %ebp,%esp
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    
	...

00801320 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801323:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801328:	75 11                	jne    80133b <_ZL8fd_validPK2Fd+0x1b>
  80132a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80132f:	76 0a                	jbe    80133b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801331:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801336:	0f 96 c0             	setbe  %al
  801339:	eb 05                	jmp    801340 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	53                   	push   %ebx
  801346:	83 ec 14             	sub    $0x14,%esp
  801349:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80134b:	e8 d0 ff ff ff       	call   801320 <_ZL8fd_validPK2Fd>
  801350:	84 c0                	test   %al,%al
  801352:	75 24                	jne    801378 <_ZL9fd_isopenPK2Fd+0x36>
  801354:	c7 44 24 0c bf 44 80 	movl   $0x8044bf,0xc(%esp)
  80135b:	00 
  80135c:	c7 44 24 08 cc 44 80 	movl   $0x8044cc,0x8(%esp)
  801363:	00 
  801364:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80136b:	00 
  80136c:	c7 04 24 e1 44 80 00 	movl   $0x8044e1,(%esp)
  801373:	e8 50 ef ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801378:	89 d8                	mov    %ebx,%eax
  80137a:	c1 e8 16             	shr    $0x16,%eax
  80137d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
  801389:	f6 c2 01             	test   $0x1,%dl
  80138c:	74 0d                	je     80139b <_ZL9fd_isopenPK2Fd+0x59>
  80138e:	c1 eb 0c             	shr    $0xc,%ebx
  801391:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801398:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80139b:	83 c4 14             	add    $0x14,%esp
  80139e:	5b                   	pop    %ebx
  80139f:	5d                   	pop    %ebp
  8013a0:	c3                   	ret    

008013a1 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	83 ec 08             	sub    $0x8,%esp
  8013a7:	89 1c 24             	mov    %ebx,(%esp)
  8013aa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8013b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b4:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8013b8:	83 fb 1f             	cmp    $0x1f,%ebx
  8013bb:	77 18                	ja     8013d5 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  8013bd:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  8013c3:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8013c6:	84 c0                	test   %al,%al
  8013c8:	74 21                	je     8013eb <_Z9fd_lookupiPP2Fdb+0x4a>
  8013ca:	89 d8                	mov    %ebx,%eax
  8013cc:	e8 71 ff ff ff       	call   801342 <_ZL9fd_isopenPK2Fd>
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 16                	jne    8013eb <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  8013d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  8013db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  8013e0:	8b 1c 24             	mov    (%esp),%ebx
  8013e3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013e7:	89 ec                	mov    %ebp,%esp
  8013e9:	5d                   	pop    %ebp
  8013ea:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  8013eb:	89 1e                	mov    %ebx,(%esi)
		return 0;
  8013ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f2:	eb ec                	jmp    8013e0 <_Z9fd_lookupiPP2Fdb+0x3f>

008013f4 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	53                   	push   %ebx
  8013f8:	83 ec 14             	sub    $0x14,%esp
  8013fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  8013fe:	89 d8                	mov    %ebx,%eax
  801400:	e8 1b ff ff ff       	call   801320 <_ZL8fd_validPK2Fd>
  801405:	84 c0                	test   %al,%al
  801407:	75 24                	jne    80142d <_Z6fd2numP2Fd+0x39>
  801409:	c7 44 24 0c bf 44 80 	movl   $0x8044bf,0xc(%esp)
  801410:	00 
  801411:	c7 44 24 08 cc 44 80 	movl   $0x8044cc,0x8(%esp)
  801418:	00 
  801419:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801420:	00 
  801421:	c7 04 24 e1 44 80 00 	movl   $0x8044e1,(%esp)
  801428:	e8 9b ee ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80142d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801433:	c1 e8 0c             	shr    $0xc,%eax
}
  801436:	83 c4 14             	add    $0x14,%esp
  801439:	5b                   	pop    %ebx
  80143a:	5d                   	pop    %ebp
  80143b:	c3                   	ret    

0080143c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	89 04 24             	mov    %eax,(%esp)
  801448:	e8 a7 ff ff ff       	call   8013f4 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  80144d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801452:	c1 e0 0c             	shl    $0xc,%eax
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	57                   	push   %edi
  80145b:	56                   	push   %esi
  80145c:	53                   	push   %ebx
  80145d:	83 ec 2c             	sub    $0x2c,%esp
  801460:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801463:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801468:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80146b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801472:	00 
  801473:	89 74 24 04          	mov    %esi,0x4(%esp)
  801477:	89 1c 24             	mov    %ebx,(%esp)
  80147a:	e8 22 ff ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80147f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801482:	e8 bb fe ff ff       	call   801342 <_ZL9fd_isopenPK2Fd>
  801487:	84 c0                	test   %al,%al
  801489:	75 0c                	jne    801497 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80148b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80148e:	89 07                	mov    %eax,(%edi)
			return 0;
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
  801495:	eb 13                	jmp    8014aa <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801497:	83 c3 01             	add    $0x1,%ebx
  80149a:	83 fb 20             	cmp    $0x20,%ebx
  80149d:	75 cc                	jne    80146b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80149f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  8014a5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8014aa:	83 c4 2c             	add    $0x2c,%esp
  8014ad:	5b                   	pop    %ebx
  8014ae:	5e                   	pop    %esi
  8014af:	5f                   	pop    %edi
  8014b0:	5d                   	pop    %ebp
  8014b1:	c3                   	ret    

008014b2 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	53                   	push   %ebx
  8014b6:	83 ec 14             	sub    $0x14,%esp
  8014b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014c4:	39 0d 04 50 80 00    	cmp    %ecx,0x805004
  8014ca:	75 16                	jne    8014e2 <_Z10dev_lookupiPP3Dev+0x30>
  8014cc:	eb 06                	jmp    8014d4 <_Z10dev_lookupiPP3Dev+0x22>
  8014ce:	39 0a                	cmp    %ecx,(%edx)
  8014d0:	75 10                	jne    8014e2 <_Z10dev_lookupiPP3Dev+0x30>
  8014d2:	eb 05                	jmp    8014d9 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014d4:	ba 04 50 80 00       	mov    $0x805004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8014d9:	89 13                	mov    %edx,(%ebx)
			return 0;
  8014db:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e0:	eb 35                	jmp    801517 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014e2:	83 c0 01             	add    $0x1,%eax
  8014e5:	8b 14 85 4c 45 80 00 	mov    0x80454c(,%eax,4),%edx
  8014ec:	85 d2                	test   %edx,%edx
  8014ee:	75 de                	jne    8014ce <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014f0:	a1 00 60 80 00       	mov    0x806000,%eax
  8014f5:	8b 40 04             	mov    0x4(%eax),%eax
  8014f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801500:	c7 04 24 08 45 80 00 	movl   $0x804508,(%esp)
  801507:	e8 da ee ff ff       	call   8003e6 <_Z7cprintfPKcz>
	*dev = 0;
  80150c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801512:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801517:	83 c4 14             	add    $0x14,%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	56                   	push   %esi
  801521:	53                   	push   %ebx
  801522:	83 ec 20             	sub    $0x20,%esp
  801525:	8b 75 08             	mov    0x8(%ebp),%esi
  801528:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80152c:	89 34 24             	mov    %esi,(%esp)
  80152f:	e8 c0 fe ff ff       	call   8013f4 <_Z6fd2numP2Fd>
  801534:	0f b6 d3             	movzbl %bl,%edx
  801537:	89 54 24 08          	mov    %edx,0x8(%esp)
  80153b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80153e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801542:	89 04 24             	mov    %eax,(%esp)
  801545:	e8 57 fe ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  80154a:	85 c0                	test   %eax,%eax
  80154c:	78 05                	js     801553 <_Z8fd_closeP2Fdb+0x36>
  80154e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801551:	74 0c                	je     80155f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801553:	80 fb 01             	cmp    $0x1,%bl
  801556:	19 db                	sbb    %ebx,%ebx
  801558:	f7 d3                	not    %ebx
  80155a:	83 e3 fd             	and    $0xfffffffd,%ebx
  80155d:	eb 3d                	jmp    80159c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80155f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801562:	89 44 24 04          	mov    %eax,0x4(%esp)
  801566:	8b 06                	mov    (%esi),%eax
  801568:	89 04 24             	mov    %eax,(%esp)
  80156b:	e8 42 ff ff ff       	call   8014b2 <_Z10dev_lookupiPP3Dev>
  801570:	89 c3                	mov    %eax,%ebx
  801572:	85 c0                	test   %eax,%eax
  801574:	78 16                	js     80158c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801579:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80157c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801581:	85 c0                	test   %eax,%eax
  801583:	74 07                	je     80158c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801585:	89 34 24             	mov    %esi,(%esp)
  801588:	ff d0                	call   *%eax
  80158a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80158c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801590:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801597:	e8 01 fa ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
	return r;
}
  80159c:	89 d8                	mov    %ebx,%eax
  80159e:	83 c4 20             	add    $0x20,%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8015ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8015b2:	00 
  8015b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	89 04 24             	mov    %eax,(%esp)
  8015c0:	e8 dc fd ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	78 13                	js     8015dc <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  8015c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015d0:	00 
  8015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d4:	89 04 24             	mov    %eax,(%esp)
  8015d7:	e8 41 ff ff ff       	call   80151d <_Z8fd_closeP2Fdb>
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <_Z9close_allv>:

void
close_all(void)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	53                   	push   %ebx
  8015e2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  8015e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015ea:	89 1c 24             	mov    %ebx,(%esp)
  8015ed:	e8 b3 ff ff ff       	call   8015a5 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  8015f2:	83 c3 01             	add    $0x1,%ebx
  8015f5:	83 fb 20             	cmp    $0x20,%ebx
  8015f8:	75 f0                	jne    8015ea <_Z9close_allv+0xc>
		close(i);
}
  8015fa:	83 c4 14             	add    $0x14,%esp
  8015fd:	5b                   	pop    %ebx
  8015fe:	5d                   	pop    %ebp
  8015ff:	c3                   	ret    

00801600 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 48             	sub    $0x48,%esp
  801606:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801609:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80160c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80160f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801612:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801619:	00 
  80161a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80161d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	e8 75 fd ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  80162c:	89 c3                	mov    %eax,%ebx
  80162e:	85 c0                	test   %eax,%eax
  801630:	0f 88 ce 00 00 00    	js     801704 <_Z3dupii+0x104>
  801636:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80163d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  80163e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801641:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801645:	89 34 24             	mov    %esi,(%esp)
  801648:	e8 54 fd ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  80164d:	89 c3                	mov    %eax,%ebx
  80164f:	85 c0                	test   %eax,%eax
  801651:	0f 89 bc 00 00 00    	jns    801713 <_Z3dupii+0x113>
  801657:	e9 a8 00 00 00       	jmp    801704 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  80165c:	89 d8                	mov    %ebx,%eax
  80165e:	c1 e8 0c             	shr    $0xc,%eax
  801661:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801668:	f6 c2 01             	test   $0x1,%dl
  80166b:	74 32                	je     80169f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80166d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801674:	25 07 0e 00 00       	and    $0xe07,%eax
  801679:	89 44 24 10          	mov    %eax,0x10(%esp)
  80167d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801681:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801688:	00 
  801689:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80168d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801694:	e8 a6 f8 ff ff       	call   800f3f <_Z12sys_page_mapiPviS_i>
  801699:	89 c3                	mov    %eax,%ebx
  80169b:	85 c0                	test   %eax,%eax
  80169d:	78 3e                	js     8016dd <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80169f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a2:	89 c2                	mov    %eax,%edx
  8016a4:	c1 ea 0c             	shr    $0xc,%edx
  8016a7:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  8016ae:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016b4:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016c6:	00 
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d2:	e8 68 f8 ff ff       	call   800f3f <_Z12sys_page_mapiPviS_i>
  8016d7:	89 c3                	mov    %eax,%ebx
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	79 25                	jns    801702 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016eb:	e8 ad f8 ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  8016f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016fb:	e8 9d f8 ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
	return r;
  801700:	eb 02                	jmp    801704 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801702:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801704:	89 d8                	mov    %ebx,%eax
  801706:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801709:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80170c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80170f:	89 ec                	mov    %ebp,%esp
  801711:	5d                   	pop    %ebp
  801712:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801713:	89 34 24             	mov    %esi,(%esp)
  801716:	e8 8a fe ff ff       	call   8015a5 <_Z5closei>

	ova = fd2data(oldfd);
  80171b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80171e:	89 04 24             	mov    %eax,(%esp)
  801721:	e8 16 fd ff ff       	call   80143c <_Z7fd2dataP2Fd>
  801726:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172b:	89 04 24             	mov    %eax,(%esp)
  80172e:	e8 09 fd ff ff       	call   80143c <_Z7fd2dataP2Fd>
  801733:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801735:	89 d8                	mov    %ebx,%eax
  801737:	c1 e8 16             	shr    $0x16,%eax
  80173a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801741:	a8 01                	test   $0x1,%al
  801743:	0f 85 13 ff ff ff    	jne    80165c <_Z3dupii+0x5c>
  801749:	e9 51 ff ff ff       	jmp    80169f <_Z3dupii+0x9f>

0080174e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	53                   	push   %ebx
  801752:	83 ec 24             	sub    $0x24,%esp
  801755:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801758:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80175f:	00 
  801760:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801763:	89 44 24 04          	mov    %eax,0x4(%esp)
  801767:	89 1c 24             	mov    %ebx,(%esp)
  80176a:	e8 32 fc ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  80176f:	85 c0                	test   %eax,%eax
  801771:	78 5f                	js     8017d2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801773:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801776:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80177d:	8b 00                	mov    (%eax),%eax
  80177f:	89 04 24             	mov    %eax,(%esp)
  801782:	e8 2b fd ff ff       	call   8014b2 <_Z10dev_lookupiPP3Dev>
  801787:	85 c0                	test   %eax,%eax
  801789:	79 4d                	jns    8017d8 <_Z4readiPvj+0x8a>
  80178b:	eb 45                	jmp    8017d2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80178d:	a1 00 60 80 00       	mov    0x806000,%eax
  801792:	8b 40 04             	mov    0x4(%eax),%eax
  801795:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801799:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179d:	c7 04 24 ea 44 80 00 	movl   $0x8044ea,(%esp)
  8017a4:	e8 3d ec ff ff       	call   8003e6 <_Z7cprintfPKcz>
		return -E_INVAL;
  8017a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ae:	eb 22                	jmp    8017d2 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  8017b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b3:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  8017b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017bb:	85 d2                	test   %edx,%edx
  8017bd:	74 13                	je     8017d2 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cd:	89 0c 24             	mov    %ecx,(%esp)
  8017d0:	ff d2                	call   *%edx
}
  8017d2:	83 c4 24             	add    $0x24,%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017d8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017db:	8b 41 08             	mov    0x8(%ecx),%eax
  8017de:	83 e0 03             	and    $0x3,%eax
  8017e1:	83 f8 01             	cmp    $0x1,%eax
  8017e4:	75 ca                	jne    8017b0 <_Z4readiPvj+0x62>
  8017e6:	eb a5                	jmp    80178d <_Z4readiPvj+0x3f>

008017e8 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	57                   	push   %edi
  8017ec:	56                   	push   %esi
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 1c             	sub    $0x1c,%esp
  8017f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8017f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8017f7:	85 f6                	test   %esi,%esi
  8017f9:	74 2f                	je     80182a <_Z5readniPvj+0x42>
  8017fb:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801800:	89 f0                	mov    %esi,%eax
  801802:	29 d8                	sub    %ebx,%eax
  801804:	89 44 24 08          	mov    %eax,0x8(%esp)
  801808:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80180b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	89 04 24             	mov    %eax,(%esp)
  801815:	e8 34 ff ff ff       	call   80174e <_Z4readiPvj>
		if (m < 0)
  80181a:	85 c0                	test   %eax,%eax
  80181c:	78 13                	js     801831 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  80181e:	85 c0                	test   %eax,%eax
  801820:	74 0d                	je     80182f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801822:	01 c3                	add    %eax,%ebx
  801824:	39 de                	cmp    %ebx,%esi
  801826:	77 d8                	ja     801800 <_Z5readniPvj+0x18>
  801828:	eb 05                	jmp    80182f <_Z5readniPvj+0x47>
  80182a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80182f:	89 d8                	mov    %ebx,%eax
}
  801831:	83 c4 1c             	add    $0x1c,%esp
  801834:	5b                   	pop    %ebx
  801835:	5e                   	pop    %esi
  801836:	5f                   	pop    %edi
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    

00801839 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80183f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801846:	00 
  801847:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	89 04 24             	mov    %eax,(%esp)
  801854:	e8 48 fb ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 3c                	js     801899 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801860:	89 44 24 04          	mov    %eax,0x4(%esp)
  801864:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801867:	8b 00                	mov    (%eax),%eax
  801869:	89 04 24             	mov    %eax,(%esp)
  80186c:	e8 41 fc ff ff       	call   8014b2 <_Z10dev_lookupiPP3Dev>
  801871:	85 c0                	test   %eax,%eax
  801873:	79 26                	jns    80189b <_Z5writeiPKvj+0x62>
  801875:	eb 22                	jmp    801899 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  80187d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801882:	85 c9                	test   %ecx,%ecx
  801884:	74 13                	je     801899 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801886:	8b 45 10             	mov    0x10(%ebp),%eax
  801889:	89 44 24 08          	mov    %eax,0x8(%esp)
  80188d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801890:	89 44 24 04          	mov    %eax,0x4(%esp)
  801894:	89 14 24             	mov    %edx,(%esp)
  801897:	ff d1                	call   *%ecx
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80189b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80189e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  8018a3:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8018a7:	74 f0                	je     801899 <_Z5writeiPKvj+0x60>
  8018a9:	eb cc                	jmp    801877 <_Z5writeiPKvj+0x3e>

008018ab <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8018b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018b8:	00 
  8018b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	89 04 24             	mov    %eax,(%esp)
  8018c6:	e8 d6 fa ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 0e                	js     8018dd <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  8018cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	53                   	push   %ebx
  8018e3:	83 ec 24             	sub    $0x24,%esp
  8018e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8018e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018f0:	00 
  8018f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f8:	89 1c 24             	mov    %ebx,(%esp)
  8018fb:	e8 a1 fa ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  801900:	85 c0                	test   %eax,%eax
  801902:	78 58                	js     80195c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801904:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801907:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80190e:	8b 00                	mov    (%eax),%eax
  801910:	89 04 24             	mov    %eax,(%esp)
  801913:	e8 9a fb ff ff       	call   8014b2 <_Z10dev_lookupiPP3Dev>
  801918:	85 c0                	test   %eax,%eax
  80191a:	79 46                	jns    801962 <_Z9ftruncateii+0x83>
  80191c:	eb 3e                	jmp    80195c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  80191e:	a1 00 60 80 00       	mov    0x806000,%eax
  801923:	8b 40 04             	mov    0x4(%eax),%eax
  801926:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80192a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192e:	c7 04 24 28 45 80 00 	movl   $0x804528,(%esp)
  801935:	e8 ac ea ff ff       	call   8003e6 <_Z7cprintfPKcz>
		return -E_INVAL;
  80193a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80193f:	eb 1b                	jmp    80195c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801944:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801947:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80194c:	85 d2                	test   %edx,%edx
  80194e:	74 0c                	je     80195c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801950:	8b 45 0c             	mov    0xc(%ebp),%eax
  801953:	89 44 24 04          	mov    %eax,0x4(%esp)
  801957:	89 0c 24             	mov    %ecx,(%esp)
  80195a:	ff d2                	call   *%edx
}
  80195c:	83 c4 24             	add    $0x24,%esp
  80195f:	5b                   	pop    %ebx
  801960:	5d                   	pop    %ebp
  801961:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801962:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801965:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801969:	75 d6                	jne    801941 <_Z9ftruncateii+0x62>
  80196b:	eb b1                	jmp    80191e <_Z9ftruncateii+0x3f>

0080196d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	53                   	push   %ebx
  801971:	83 ec 24             	sub    $0x24,%esp
  801974:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801977:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80197e:	00 
  80197f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801982:	89 44 24 04          	mov    %eax,0x4(%esp)
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 04 24             	mov    %eax,(%esp)
  80198c:	e8 10 fa ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  801991:	85 c0                	test   %eax,%eax
  801993:	78 3e                	js     8019d3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801995:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80199f:	8b 00                	mov    (%eax),%eax
  8019a1:	89 04 24             	mov    %eax,(%esp)
  8019a4:	e8 09 fb ff ff       	call   8014b2 <_Z10dev_lookupiPP3Dev>
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	79 2c                	jns    8019d9 <_Z5fstatiP4Stat+0x6c>
  8019ad:	eb 24                	jmp    8019d3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019af:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019b2:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  8019b9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  8019c0:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cd:	89 04 24             	mov    %eax,(%esp)
  8019d0:	ff 52 14             	call   *0x14(%edx)
}
  8019d3:	83 c4 24             	add    $0x24,%esp
  8019d6:	5b                   	pop    %ebx
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8019d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  8019dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8019e1:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8019e5:	75 c8                	jne    8019af <_Z5fstatiP4Stat+0x42>
  8019e7:	eb ea                	jmp    8019d3 <_Z5fstatiP4Stat+0x66>

008019e9 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 18             	sub    $0x18,%esp
  8019ef:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8019f2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019fc:	00 
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	89 04 24             	mov    %eax,(%esp)
  801a03:	e8 d6 09 00 00       	call   8023de <_Z4openPKci>
  801a08:	89 c3                	mov    %eax,%ebx
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	78 1b                	js     801a29 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a15:	89 1c 24             	mov    %ebx,(%esp)
  801a18:	e8 50 ff ff ff       	call   80196d <_Z5fstatiP4Stat>
  801a1d:	89 c6                	mov    %eax,%esi
	close(fd);
  801a1f:	89 1c 24             	mov    %ebx,(%esp)
  801a22:	e8 7e fb ff ff       	call   8015a5 <_Z5closei>
	return r;
  801a27:	89 f3                	mov    %esi,%ebx
}
  801a29:	89 d8                	mov    %ebx,%eax
  801a2b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a2e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a31:	89 ec                	mov    %ebp,%esp
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    
	...

00801a40 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801a43:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801a48:	85 d2                	test   %edx,%edx
  801a4a:	78 33                	js     801a7f <_ZL10inode_dataP5Inodei+0x3f>
  801a4c:	3b 50 08             	cmp    0x8(%eax),%edx
  801a4f:	7d 2e                	jge    801a7f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801a51:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801a57:	85 d2                	test   %edx,%edx
  801a59:	0f 49 ca             	cmovns %edx,%ecx
  801a5c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  801a5f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801a63:	c1 e1 0c             	shl    $0xc,%ecx
  801a66:	89 d0                	mov    %edx,%eax
  801a68:	c1 f8 1f             	sar    $0x1f,%eax
  801a6b:	c1 e8 14             	shr    $0x14,%eax
  801a6e:	01 c2                	add    %eax,%edx
  801a70:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801a76:	29 c2                	sub    %eax,%edx
  801a78:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801a7f:	89 c8                	mov    %ecx,%eax
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801a86:	8b 48 08             	mov    0x8(%eax),%ecx
  801a89:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801a8c:	8b 00                	mov    (%eax),%eax
  801a8e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801a91:	c7 82 80 00 00 00 04 	movl   $0x805004,0x80(%edx)
  801a98:	50 80 00 
}
  801a9b:	5d                   	pop    %ebp
  801a9c:	c3                   	ret    

00801a9d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801aa3:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	74 08                	je     801ab5 <_ZL9get_inodei+0x18>
  801aad:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801ab3:	7e 20                	jle    801ad5 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801ab5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ab9:	c7 44 24 08 60 45 80 	movl   $0x804560,0x8(%esp)
  801ac0:	00 
  801ac1:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801ac8:	00 
  801ac9:	c7 04 24 76 45 80 00 	movl   $0x804576,(%esp)
  801ad0:	e8 f3 e7 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801ad5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801adb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801ae1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801ae7:	85 d2                	test   %edx,%edx
  801ae9:	0f 48 d1             	cmovs  %ecx,%edx
  801aec:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801aef:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801af6:	c1 e0 0c             	shl    $0xc,%eax
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801b03:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801b09:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801b0c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801b12:	76 20                	jbe    801b34 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801b14:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b18:	c7 44 24 08 9c 45 80 	movl   $0x80459c,0x8(%esp)
  801b1f:	00 
  801b20:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801b27:	00 
  801b28:	c7 04 24 76 45 80 00 	movl   $0x804576,(%esp)
  801b2f:	e8 94 e7 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801b34:	83 fe 01             	cmp    $0x1,%esi
  801b37:	7e 08                	jle    801b41 <_ZL10bcache_ipcPvi+0x46>
  801b39:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801b3f:	7d 12                	jge    801b53 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801b41:	89 f3                	mov    %esi,%ebx
  801b43:	c1 e3 04             	shl    $0x4,%ebx
  801b46:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801b48:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801b4e:	c1 e6 0c             	shl    $0xc,%esi
  801b51:	eb 20                	jmp    801b73 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801b53:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801b57:	c7 44 24 08 cc 45 80 	movl   $0x8045cc,0x8(%esp)
  801b5e:	00 
  801b5f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801b66:	00 
  801b67:	c7 04 24 76 45 80 00 	movl   $0x804576,(%esp)
  801b6e:	e8 55 e7 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801b73:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b7a:	00 
  801b7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b82:	00 
  801b83:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b87:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801b8e:	e8 cc 21 00 00       	call   803d5f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801b93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b9a:	00 
  801b9b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ba6:	e8 25 21 00 00       	call   803cd0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801bab:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801bae:	74 c3                	je     801b73 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	5d                   	pop    %ebp
  801bb6:	c3                   	ret    

00801bb7 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 28             	sub    $0x28,%esp
  801bbd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801bc0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801bc3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bc6:	89 c7                	mov    %eax,%edi
  801bc8:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801bca:	c7 04 24 5d 1e 80 00 	movl   $0x801e5d,(%esp)
  801bd1:	e8 05 20 00 00       	call   803bdb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801bd6:	89 f8                	mov    %edi,%eax
  801bd8:	e8 c0 fe ff ff       	call   801a9d <_ZL9get_inodei>
  801bdd:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801bdf:	ba 02 00 00 00       	mov    $0x2,%edx
  801be4:	e8 12 ff ff ff       	call   801afb <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801be9:	85 c0                	test   %eax,%eax
  801beb:	79 08                	jns    801bf5 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801bed:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801bf3:	eb 2e                	jmp    801c23 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	75 1c                	jne    801c15 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801bf9:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801bff:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801c06:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801c09:	ba 06 00 00 00       	mov    $0x6,%edx
  801c0e:	89 d8                	mov    %ebx,%eax
  801c10:	e8 e6 fe ff ff       	call   801afb <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801c15:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801c1c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c23:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c26:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c29:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c2c:	89 ec                	mov    %ebp,%esp
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    

00801c30 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	57                   	push   %edi
  801c34:	56                   	push   %esi
  801c35:	53                   	push   %ebx
  801c36:	83 ec 2c             	sub    $0x2c,%esp
  801c39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801c3c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801c3f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801c44:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801c4a:	0f 87 3d 01 00 00    	ja     801d8d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801c50:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801c53:	8b 42 08             	mov    0x8(%edx),%eax
  801c56:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	0f 49 f0             	cmovns %eax,%esi
  801c61:	c1 fe 0c             	sar    $0xc,%esi
  801c64:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801c66:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801c69:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801c6f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801c72:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801c75:	0f 82 a6 00 00 00    	jb     801d21 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801c7b:	39 fe                	cmp    %edi,%esi
  801c7d:	0f 8d f2 00 00 00    	jge    801d75 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801c83:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801c87:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801c8a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801c8d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801c90:	83 3e 00             	cmpl   $0x0,(%esi)
  801c93:	75 77                	jne    801d0c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801c95:	ba 02 00 00 00       	mov    $0x2,%edx
  801c9a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c9f:	e8 57 fe ff ff       	call   801afb <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801ca4:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801caa:	83 f9 02             	cmp    $0x2,%ecx
  801cad:	7e 43                	jle    801cf2 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801caf:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801cb4:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801cb9:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801cc0:	74 29                	je     801ceb <_ZL14inode_set_sizeP5Inodej+0xbb>
  801cc2:	e9 ce 00 00 00       	jmp    801d95 <_ZL14inode_set_sizeP5Inodej+0x165>
  801cc7:	89 c7                	mov    %eax,%edi
  801cc9:	0f b6 10             	movzbl (%eax),%edx
  801ccc:	83 c0 01             	add    $0x1,%eax
  801ccf:	84 d2                	test   %dl,%dl
  801cd1:	74 18                	je     801ceb <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801cd3:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801cd6:	ba 05 00 00 00       	mov    $0x5,%edx
  801cdb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801ce0:	e8 16 fe ff ff       	call   801afb <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801ce5:	85 db                	test   %ebx,%ebx
  801ce7:	79 1e                	jns    801d07 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801ce9:	eb 07                	jmp    801cf2 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801ceb:	83 c3 01             	add    $0x1,%ebx
  801cee:	39 d9                	cmp    %ebx,%ecx
  801cf0:	7f d5                	jg     801cc7 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801cf2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cf5:	8b 50 08             	mov    0x8(%eax),%edx
  801cf8:	e8 33 ff ff ff       	call   801c30 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801cfd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801d02:	e9 86 00 00 00       	jmp    801d8d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801d07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d0a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801d0c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801d10:	83 c6 04             	add    $0x4,%esi
  801d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d16:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801d19:	0f 8f 6e ff ff ff    	jg     801c8d <_ZL14inode_set_sizeP5Inodej+0x5d>
  801d1f:	eb 54                	jmp    801d75 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801d21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d24:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801d29:	83 f8 01             	cmp    $0x1,%eax
  801d2c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801d2f:	ba 02 00 00 00       	mov    $0x2,%edx
  801d34:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d39:	e8 bd fd ff ff       	call   801afb <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801d3e:	39 f7                	cmp    %esi,%edi
  801d40:	7d 24                	jge    801d66 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801d42:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801d45:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801d49:	8b 10                	mov    (%eax),%edx
  801d4b:	85 d2                	test   %edx,%edx
  801d4d:	74 0d                	je     801d5c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801d4f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801d56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801d5c:	83 eb 01             	sub    $0x1,%ebx
  801d5f:	83 e8 04             	sub    $0x4,%eax
  801d62:	39 fb                	cmp    %edi,%ebx
  801d64:	75 e3                	jne    801d49 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801d66:	ba 05 00 00 00       	mov    $0x5,%edx
  801d6b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d70:	e8 86 fd ff ff       	call   801afb <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801d75:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d7b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801d7e:	ba 04 00 00 00       	mov    $0x4,%edx
  801d83:	e8 73 fd ff ff       	call   801afb <_ZL10bcache_ipcPvi>
	return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	83 c4 2c             	add    $0x2c,%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5f                   	pop    %edi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801d95:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801d9c:	ba 05 00 00 00       	mov    $0x5,%edx
  801da1:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801da6:	e8 50 fd ff ff       	call   801afb <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801dab:	bb 02 00 00 00       	mov    $0x2,%ebx
  801db0:	e9 52 ff ff ff       	jmp    801d07 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801db5 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	53                   	push   %ebx
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801dbe:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801dc4:	83 e8 01             	sub    $0x1,%eax
  801dc7:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801dcd:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801dd1:	75 40                	jne    801e13 <_ZL11inode_closeP5Inode+0x5e>
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	75 3c                	jne    801e13 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801dd7:	ba 02 00 00 00       	mov    $0x2,%edx
  801ddc:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801de1:	e8 15 fd ff ff       	call   801afb <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801de6:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801deb:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801def:	85 d2                	test   %edx,%edx
  801df1:	74 07                	je     801dfa <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801df3:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801dfa:	83 c0 01             	add    $0x1,%eax
  801dfd:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801e02:	75 e7                	jne    801deb <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801e04:	ba 05 00 00 00       	mov    $0x5,%edx
  801e09:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801e0e:	e8 e8 fc ff ff       	call   801afb <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801e13:	ba 03 00 00 00       	mov    $0x3,%edx
  801e18:	89 d8                	mov    %ebx,%eax
  801e1a:	e8 dc fc ff ff       	call   801afb <_ZL10bcache_ipcPvi>
}
  801e1f:	83 c4 04             	add    $0x4,%esp
  801e22:	5b                   	pop    %ebx
  801e23:	5d                   	pop    %ebp
  801e24:	c3                   	ret    

00801e25 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	53                   	push   %ebx
  801e29:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e32:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e35:	e8 7d fd ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  801e3a:	89 c3                	mov    %eax,%ebx
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 15                	js     801e55 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801e40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	e8 e5 fd ff ff       	call   801c30 <_ZL14inode_set_sizeP5Inodej>
  801e4b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	e8 60 ff ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
	return r;
}
  801e55:	89 d8                	mov    %ebx,%eax
  801e57:	83 c4 14             	add    $0x14,%esp
  801e5a:	5b                   	pop    %ebx
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    

00801e5d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	53                   	push   %ebx
  801e61:	83 ec 14             	sub    $0x14,%esp
  801e64:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801e67:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801e69:	89 c2                	mov    %eax,%edx
  801e6b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801e71:	78 32                	js     801ea5 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801e73:	ba 00 00 00 00       	mov    $0x0,%edx
  801e78:	e8 7e fc ff ff       	call   801afb <_ZL10bcache_ipcPvi>
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	74 1c                	je     801e9d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801e81:	c7 44 24 08 81 45 80 	movl   $0x804581,0x8(%esp)
  801e88:	00 
  801e89:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801e90:	00 
  801e91:	c7 04 24 76 45 80 00 	movl   $0x804576,(%esp)
  801e98:	e8 2b e4 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
    resume(utf);
  801e9d:	89 1c 24             	mov    %ebx,(%esp)
  801ea0:	e8 0b 1e 00 00       	call   803cb0 <resume>
}
  801ea5:	83 c4 14             	add    $0x14,%esp
  801ea8:	5b                   	pop    %ebx
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    

00801eab <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 28             	sub    $0x28,%esp
  801eb1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801eb4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801eba:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801ebd:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ec0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ec3:	e8 ef fc ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	78 26                	js     801ef2 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  801ecc:	83 c3 10             	add    $0x10,%ebx
  801ecf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ed3:	89 34 24             	mov    %esi,(%esp)
  801ed6:	e8 1f eb ff ff       	call   8009fa <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801edb:	89 f2                	mov    %esi,%edx
  801edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee0:	e8 9e fb ff ff       	call   801a83 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	e8 c8 fe ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
	return 0;
  801eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ef5:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ef8:	89 ec                	mov    %ebp,%esp
  801efa:	5d                   	pop    %ebp
  801efb:	c3                   	ret    

00801efc <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	53                   	push   %ebx
  801f00:	83 ec 24             	sub    $0x24,%esp
  801f03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801f06:	89 1c 24             	mov    %ebx,(%esp)
  801f09:	e8 9e 15 00 00       	call   8034ac <_Z7pagerefPv>
  801f0e:	89 c2                	mov    %eax,%edx
        return 0;
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801f15:	83 fa 01             	cmp    $0x1,%edx
  801f18:	7f 1e                	jg     801f38 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801f1a:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f1d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f20:	e8 92 fc ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  801f25:	85 c0                	test   %eax,%eax
  801f27:	78 0f                	js     801f38 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  801f33:	e8 7d fe ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
}
  801f38:	83 c4 24             	add    $0x24,%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    

00801f3e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	57                   	push   %edi
  801f42:	56                   	push   %esi
  801f43:	53                   	push   %ebx
  801f44:	83 ec 3c             	sub    $0x3c,%esp
  801f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801f4a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  801f4d:	8b 43 04             	mov    0x4(%ebx),%eax
  801f50:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801f53:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f56:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801f59:	e8 59 fc ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	0f 88 8c 00 00 00    	js     801ff2 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801f66:	8b 53 04             	mov    0x4(%ebx),%edx
  801f69:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  801f6f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801f75:	29 d7                	sub    %edx,%edi
  801f77:	39 f7                	cmp    %esi,%edi
  801f79:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  801f7c:	85 ff                	test   %edi,%edi
  801f7e:	74 16                	je     801f96 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801f80:	8d 14 17             	lea    (%edi,%edx,1),%edx
  801f83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f86:	3b 50 08             	cmp    0x8(%eax),%edx
  801f89:	76 6f                	jbe    801ffa <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  801f8b:	e8 a0 fc ff ff       	call   801c30 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801f90:	85 c0                	test   %eax,%eax
  801f92:	79 66                	jns    801ffa <_ZL13devfile_writeP2FdPKvj+0xbc>
  801f94:	eb 4e                	jmp    801fe4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801f96:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  801f9c:	76 24                	jbe    801fc2 <_ZL13devfile_writeP2FdPKvj+0x84>
  801f9e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801fa0:	8b 53 04             	mov    0x4(%ebx),%edx
  801fa3:	81 c2 00 10 00 00    	add    $0x1000,%edx
  801fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fac:	3b 50 08             	cmp    0x8(%eax),%edx
  801faf:	0f 86 83 00 00 00    	jbe    802038 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  801fb5:	e8 76 fc ff ff       	call   801c30 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	79 7a                	jns    802038 <_ZL13devfile_writeP2FdPKvj+0xfa>
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	eb 22                	jmp    801fe4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  801fc2:	85 f6                	test   %esi,%esi
  801fc4:	74 1e                	je     801fe4 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801fc6:	89 f2                	mov    %esi,%edx
  801fc8:	03 53 04             	add    0x4(%ebx),%edx
  801fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fce:	3b 50 08             	cmp    0x8(%eax),%edx
  801fd1:	0f 86 b8 00 00 00    	jbe    80208f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  801fd7:	e8 54 fc ff ff       	call   801c30 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	0f 89 ab 00 00 00    	jns    80208f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  801fe4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fe7:	e8 c9 fd ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  801fec:	8b 43 04             	mov    0x4(%ebx),%eax
  801fef:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  801ff2:	83 c4 3c             	add    $0x3c,%esp
  801ff5:	5b                   	pop    %ebx
  801ff6:	5e                   	pop    %esi
  801ff7:	5f                   	pop    %edi
  801ff8:	5d                   	pop    %ebp
  801ff9:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  801ffa:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801ffc:	8b 53 04             	mov    0x4(%ebx),%edx
  801fff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802002:	e8 39 fa ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
  802007:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80200a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80200e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802011:	89 44 24 04          	mov    %eax,0x4(%esp)
  802015:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802018:	89 04 24             	mov    %eax,(%esp)
  80201b:	e8 f7 eb ff ff       	call   800c17 <memcpy>
        fd->fd_offset += n2;
  802020:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802023:	ba 04 00 00 00       	mov    $0x4,%edx
  802028:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80202b:	e8 cb fa ff ff       	call   801afb <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802030:	01 7d 0c             	add    %edi,0xc(%ebp)
  802033:	e9 5e ff ff ff       	jmp    801f96 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802038:	8b 53 04             	mov    0x4(%ebx),%edx
  80203b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80203e:	e8 fd f9 ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
  802043:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  802045:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80204c:	00 
  80204d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802050:	89 44 24 04          	mov    %eax,0x4(%esp)
  802054:	89 34 24             	mov    %esi,(%esp)
  802057:	e8 bb eb ff ff       	call   800c17 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80205c:	ba 04 00 00 00       	mov    $0x4,%edx
  802061:	89 f0                	mov    %esi,%eax
  802063:	e8 93 fa ff ff       	call   801afb <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  802068:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  80206e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802075:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80207c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802082:	0f 87 18 ff ff ff    	ja     801fa0 <_ZL13devfile_writeP2FdPKvj+0x62>
  802088:	89 fe                	mov    %edi,%esi
  80208a:	e9 33 ff ff ff       	jmp    801fc2 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80208f:	8b 53 04             	mov    0x4(%ebx),%edx
  802092:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802095:	e8 a6 f9 ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
  80209a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80209c:	89 74 24 08          	mov    %esi,0x8(%esp)
  8020a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a7:	89 3c 24             	mov    %edi,(%esp)
  8020aa:	e8 68 eb ff ff       	call   800c17 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8020af:	ba 04 00 00 00       	mov    $0x4,%edx
  8020b4:	89 f8                	mov    %edi,%eax
  8020b6:	e8 40 fa ff ff       	call   801afb <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  8020bb:	01 73 04             	add    %esi,0x4(%ebx)
  8020be:	e9 21 ff ff ff       	jmp    801fe4 <_ZL13devfile_writeP2FdPKvj+0xa6>

008020c3 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	57                   	push   %edi
  8020c7:	56                   	push   %esi
  8020c8:	53                   	push   %ebx
  8020c9:	83 ec 3c             	sub    $0x3c,%esp
  8020cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8020cf:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  8020d2:	8b 43 04             	mov    0x4(%ebx),%eax
  8020d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8020d8:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020db:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8020de:	e8 d4 fa ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	0f 88 d3 00 00 00    	js     8021be <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  8020eb:	8b 73 04             	mov    0x4(%ebx),%esi
  8020ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020f1:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  8020f4:	8b 50 08             	mov    0x8(%eax),%edx
  8020f7:	29 f2                	sub    %esi,%edx
  8020f9:	3b 48 08             	cmp    0x8(%eax),%ecx
  8020fc:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  8020ff:	89 f2                	mov    %esi,%edx
  802101:	e8 3a f9 ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
  802106:	85 c0                	test   %eax,%eax
  802108:	0f 84 a2 00 00 00    	je     8021b0 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80210e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802114:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80211a:	29 f2                	sub    %esi,%edx
  80211c:	39 d7                	cmp    %edx,%edi
  80211e:	0f 46 d7             	cmovbe %edi,%edx
  802121:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802124:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802126:	01 d6                	add    %edx,%esi
  802128:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80212b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80212f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802133:	8b 45 0c             	mov    0xc(%ebp),%eax
  802136:	89 04 24             	mov    %eax,(%esp)
  802139:	e8 d9 ea ff ff       	call   800c17 <memcpy>
    buf = (void *)((char *)buf + n2);
  80213e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802141:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802144:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80214a:	76 3e                	jbe    80218a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80214c:	8b 53 04             	mov    0x4(%ebx),%edx
  80214f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802152:	e8 e9 f8 ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
  802157:	85 c0                	test   %eax,%eax
  802159:	74 55                	je     8021b0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80215b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802162:	00 
  802163:	89 44 24 04          	mov    %eax,0x4(%esp)
  802167:	89 34 24             	mov    %esi,(%esp)
  80216a:	e8 a8 ea ff ff       	call   800c17 <memcpy>
        n -= PGSIZE;
  80216f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802175:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80217b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802182:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802188:	77 c2                	ja     80214c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80218a:	85 ff                	test   %edi,%edi
  80218c:	74 22                	je     8021b0 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80218e:	8b 53 04             	mov    0x4(%ebx),%edx
  802191:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802194:	e8 a7 f8 ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
  802199:	85 c0                	test   %eax,%eax
  80219b:	74 13                	je     8021b0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80219d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a5:	89 34 24             	mov    %esi,(%esp)
  8021a8:	e8 6a ea ff ff       	call   800c17 <memcpy>
        fd->fd_offset += n;
  8021ad:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  8021b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021b3:	e8 fd fb ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8021b8:	8b 43 04             	mov    0x4(%ebx),%eax
  8021bb:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  8021be:	83 c4 3c             	add    $0x3c,%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5f                   	pop    %edi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    

008021c6 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	57                   	push   %edi
  8021ca:	56                   	push   %esi
  8021cb:	53                   	push   %ebx
  8021cc:	83 ec 4c             	sub    $0x4c,%esp
  8021cf:	89 c6                	mov    %eax,%esi
  8021d1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8021d4:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  8021d7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  8021dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  8021e6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8021e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ee:	e8 c4 f9 ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  8021f3:	89 c7                	mov    %eax,%edi
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	0f 88 cd 01 00 00    	js     8023ca <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8021fd:	89 f3                	mov    %esi,%ebx
  8021ff:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802202:	75 08                	jne    80220c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802204:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802207:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80220a:	74 f8                	je     802204 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80220c:	0f b6 03             	movzbl (%ebx),%eax
  80220f:	3c 2f                	cmp    $0x2f,%al
  802211:	74 16                	je     802229 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802213:	84 c0                	test   %al,%al
  802215:	74 12                	je     802229 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802217:	89 da                	mov    %ebx,%edx
		++path;
  802219:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80221c:	0f b6 02             	movzbl (%edx),%eax
  80221f:	3c 2f                	cmp    $0x2f,%al
  802221:	74 08                	je     80222b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802223:	84 c0                	test   %al,%al
  802225:	75 f2                	jne    802219 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802227:	eb 02                	jmp    80222b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802229:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80222b:	89 d0                	mov    %edx,%eax
  80222d:	29 d8                	sub    %ebx,%eax
  80222f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802232:	0f b6 02             	movzbl (%edx),%eax
  802235:	89 d6                	mov    %edx,%esi
  802237:	3c 2f                	cmp    $0x2f,%al
  802239:	75 0a                	jne    802245 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80223b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80223e:	0f b6 06             	movzbl (%esi),%eax
  802241:	3c 2f                	cmp    $0x2f,%al
  802243:	74 f6                	je     80223b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802245:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802249:	75 1b                	jne    802266 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80224b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80224e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802251:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802253:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802256:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80225c:	bf 00 00 00 00       	mov    $0x0,%edi
  802261:	e9 64 01 00 00       	jmp    8023ca <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802266:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  80226a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80226e:	74 06                	je     802276 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802270:	84 c0                	test   %al,%al
  802272:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802276:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802279:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80227c:	83 3a 02             	cmpl   $0x2,(%edx)
  80227f:	0f 85 f4 00 00 00    	jne    802379 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802285:	89 d0                	mov    %edx,%eax
  802287:	8b 52 08             	mov    0x8(%edx),%edx
  80228a:	85 d2                	test   %edx,%edx
  80228c:	7e 78                	jle    802306 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80228e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802295:	bf 00 00 00 00       	mov    $0x0,%edi
  80229a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80229d:	89 fb                	mov    %edi,%ebx
  80229f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  8022a2:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8022a4:	89 da                	mov    %ebx,%edx
  8022a6:	89 f0                	mov    %esi,%eax
  8022a8:	e8 93 f7 ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
  8022ad:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  8022af:	83 38 00             	cmpl   $0x0,(%eax)
  8022b2:	74 26                	je     8022da <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  8022b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022b7:	3b 50 04             	cmp    0x4(%eax),%edx
  8022ba:	75 33                	jne    8022ef <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  8022bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8022c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c7:	8d 47 08             	lea    0x8(%edi),%eax
  8022ca:	89 04 24             	mov    %eax,(%esp)
  8022cd:	e8 86 e9 ff ff       	call   800c58 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	0f 84 fa 00 00 00    	je     8023d4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  8022da:	83 3f 00             	cmpl   $0x0,(%edi)
  8022dd:	75 10                	jne    8022ef <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  8022df:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8022e3:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8022e6:	84 c0                	test   %al,%al
  8022e8:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  8022ec:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8022ef:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  8022f5:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8022f7:	8b 56 08             	mov    0x8(%esi),%edx
  8022fa:	39 d0                	cmp    %edx,%eax
  8022fc:	7c a6                	jl     8022a4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  8022fe:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802301:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802304:	eb 07                	jmp    80230d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802306:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80230d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802311:	74 6d                	je     802380 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802313:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802317:	75 24                	jne    80233d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802319:	83 ea 80             	sub    $0xffffff80,%edx
  80231c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80231f:	e8 0c f9 ff ff       	call   801c30 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802324:	85 c0                	test   %eax,%eax
  802326:	0f 88 90 00 00 00    	js     8023bc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80232c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80232f:	8b 50 08             	mov    0x8(%eax),%edx
  802332:	83 c2 80             	add    $0xffffff80,%edx
  802335:	e8 06 f7 ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
  80233a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80233d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802344:	00 
  802345:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80234c:	00 
  80234d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802350:	89 14 24             	mov    %edx,(%esp)
  802353:	e8 e9 e7 ff ff       	call   800b41 <memset>
	empty->de_namelen = namelen;
  802358:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80235b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80235e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802361:	89 54 24 08          	mov    %edx,0x8(%esp)
  802365:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802369:	83 c0 08             	add    $0x8,%eax
  80236c:	89 04 24             	mov    %eax,(%esp)
  80236f:	e8 a3 e8 ff ff       	call   800c17 <memcpy>
	*de_store = empty;
  802374:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802377:	eb 5e                	jmp    8023d7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802379:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80237e:	eb 42                	jmp    8023c2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802380:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802385:	eb 3b                	jmp    8023c2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80238a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80238d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80238f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802392:	89 38                	mov    %edi,(%eax)
			return 0;
  802394:	bf 00 00 00 00       	mov    $0x0,%edi
  802399:	eb 2f                	jmp    8023ca <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80239b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80239e:	8b 07                	mov    (%edi),%eax
  8023a0:	e8 12 f8 ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	78 17                	js     8023c0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  8023a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ac:	e8 04 fa ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  8023b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  8023b7:	e9 41 fe ff ff       	jmp    8021fd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  8023bc:	89 c7                	mov    %eax,%edi
  8023be:	eb 02                	jmp    8023c2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  8023c0:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  8023c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c5:	e8 eb f9 ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
	return r;
}
  8023ca:	89 f8                	mov    %edi,%eax
  8023cc:	83 c4 4c             	add    $0x4c,%esp
  8023cf:	5b                   	pop    %ebx
  8023d0:	5e                   	pop    %esi
  8023d1:	5f                   	pop    %edi
  8023d2:	5d                   	pop    %ebp
  8023d3:	c3                   	ret    
  8023d4:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  8023d7:	80 3e 00             	cmpb   $0x0,(%esi)
  8023da:	75 bf                	jne    80239b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  8023dc:	eb a9                	jmp    802387 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

008023de <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 3c             	sub    $0x3c,%esp
  8023e7:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  8023ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8023ed:	89 04 24             	mov    %eax,(%esp)
  8023f0:	e8 62 f0 ff ff       	call   801457 <_Z14fd_find_unusedPP2Fd>
  8023f5:	89 c3                	mov    %eax,%ebx
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	0f 88 16 02 00 00    	js     802615 <_Z4openPKci+0x237>
  8023ff:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802406:	00 
  802407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802415:	e8 c6 ea ff ff       	call   800ee0 <_Z14sys_page_allociPvi>
  80241a:	89 c3                	mov    %eax,%ebx
  80241c:	b8 00 00 00 00       	mov    $0x0,%eax
  802421:	85 db                	test   %ebx,%ebx
  802423:	0f 88 ec 01 00 00    	js     802615 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802429:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80242d:	0f 84 ec 01 00 00    	je     80261f <_Z4openPKci+0x241>
  802433:	83 c0 01             	add    $0x1,%eax
  802436:	83 f8 78             	cmp    $0x78,%eax
  802439:	75 ee                	jne    802429 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80243b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802440:	e9 b9 01 00 00       	jmp    8025fe <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802445:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802448:	81 e7 00 01 00 00    	and    $0x100,%edi
  80244e:	89 3c 24             	mov    %edi,(%esp)
  802451:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802454:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802457:	89 f0                	mov    %esi,%eax
  802459:	e8 68 fd ff ff       	call   8021c6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80245e:	89 c3                	mov    %eax,%ebx
  802460:	85 c0                	test   %eax,%eax
  802462:	0f 85 96 01 00 00    	jne    8025fe <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802468:	85 ff                	test   %edi,%edi
  80246a:	75 41                	jne    8024ad <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  80246c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80246f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802474:	75 08                	jne    80247e <_Z4openPKci+0xa0>
            fileino = dirino;
  802476:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802479:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80247c:	eb 14                	jmp    802492 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80247e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802481:	8b 00                	mov    (%eax),%eax
  802483:	e8 2f f7 ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  802488:	89 c3                	mov    %eax,%ebx
  80248a:	85 c0                	test   %eax,%eax
  80248c:	0f 88 5d 01 00 00    	js     8025ef <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802492:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802495:	83 38 02             	cmpl   $0x2,(%eax)
  802498:	0f 85 d2 00 00 00    	jne    802570 <_Z4openPKci+0x192>
  80249e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  8024a2:	0f 84 c8 00 00 00    	je     802570 <_Z4openPKci+0x192>
  8024a8:	e9 38 01 00 00       	jmp    8025e5 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  8024ad:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8024b4:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  8024bb:	0f 8e a8 00 00 00    	jle    802569 <_Z4openPKci+0x18b>
  8024c1:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  8024c6:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	e8 e7 f6 ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  8024d0:	89 c3                	mov    %eax,%ebx
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	0f 88 15 01 00 00    	js     8025ef <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  8024da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024dd:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8024e1:	75 68                	jne    80254b <_Z4openPKci+0x16d>
  8024e3:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  8024ea:	75 5f                	jne    80254b <_Z4openPKci+0x16d>
			*ino_store = ino;
  8024ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  8024ef:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  8024f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024f8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  8024ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802506:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80250d:	00 
  80250e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802515:	00 
  802516:	83 c0 0c             	add    $0xc,%eax
  802519:	89 04 24             	mov    %eax,(%esp)
  80251c:	e8 20 e6 ff ff       	call   800b41 <memset>
        de->de_inum = fileino->i_inum;
  802521:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802524:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80252a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80252d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80252f:	ba 04 00 00 00       	mov    $0x4,%edx
  802534:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802537:	e8 bf f5 ff ff       	call   801afb <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80253c:	ba 04 00 00 00       	mov    $0x4,%edx
  802541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802544:	e8 b2 f5 ff ff       	call   801afb <_ZL10bcache_ipcPvi>
  802549:	eb 25                	jmp    802570 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  80254b:	e8 65 f8 ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802550:	83 c7 01             	add    $0x1,%edi
  802553:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802559:	0f 8c 67 ff ff ff    	jl     8024c6 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  80255f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802564:	e9 86 00 00 00       	jmp    8025ef <_Z4openPKci+0x211>
  802569:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  80256e:	eb 7f                	jmp    8025ef <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802570:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802577:	74 0d                	je     802586 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802579:	ba 00 00 00 00       	mov    $0x0,%edx
  80257e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802581:	e8 aa f6 ff ff       	call   801c30 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802586:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80258c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802594:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80259b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  8025a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025a4:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  8025aa:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  8025ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025b1:	83 c0 10             	add    $0x10,%eax
  8025b4:	89 04 24             	mov    %eax,(%esp)
  8025b7:	e8 3e e4 ff ff       	call   8009fa <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  8025bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025bf:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  8025c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c9:	e8 e7 f7 ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  8025ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025d1:	e8 df f7 ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  8025d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d9:	89 04 24             	mov    %eax,(%esp)
  8025dc:	e8 13 ee ff ff       	call   8013f4 <_Z6fd2numP2Fd>
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	eb 30                	jmp    802615 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  8025e5:	e8 cb f7 ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  8025ea:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  8025ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f2:	e8 be f7 ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
  8025f7:	eb 05                	jmp    8025fe <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8025f9:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  8025fe:	a1 00 60 80 00       	mov    0x806000,%eax
  802603:	8b 40 04             	mov    0x4(%eax),%eax
  802606:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802609:	89 54 24 04          	mov    %edx,0x4(%esp)
  80260d:	89 04 24             	mov    %eax,(%esp)
  802610:	e8 88 e9 ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802615:	89 d8                	mov    %ebx,%eax
  802617:	83 c4 3c             	add    $0x3c,%esp
  80261a:	5b                   	pop    %ebx
  80261b:	5e                   	pop    %esi
  80261c:	5f                   	pop    %edi
  80261d:	5d                   	pop    %ebp
  80261e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80261f:	83 f8 78             	cmp    $0x78,%eax
  802622:	0f 85 1d fe ff ff    	jne    802445 <_Z4openPKci+0x67>
  802628:	eb cf                	jmp    8025f9 <_Z4openPKci+0x21b>

0080262a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	53                   	push   %ebx
  80262e:	83 ec 24             	sub    $0x24,%esp
  802631:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802634:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802637:	8b 45 08             	mov    0x8(%ebp),%eax
  80263a:	e8 78 f5 ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  80263f:	85 c0                	test   %eax,%eax
  802641:	78 27                	js     80266a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802643:	c7 44 24 04 94 45 80 	movl   $0x804594,0x4(%esp)
  80264a:	00 
  80264b:	89 1c 24             	mov    %ebx,(%esp)
  80264e:	e8 a7 e3 ff ff       	call   8009fa <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802653:	89 da                	mov    %ebx,%edx
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	e8 26 f4 ff ff       	call   801a83 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	e8 50 f7 ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
	return 0;
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266a:	83 c4 24             	add    $0x24,%esp
  80266d:	5b                   	pop    %ebx
  80266e:	5d                   	pop    %ebp
  80266f:	c3                   	ret    

00802670 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	53                   	push   %ebx
  802674:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802677:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80267e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802681:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802684:	8b 45 08             	mov    0x8(%ebp),%eax
  802687:	e8 3a fb ff ff       	call   8021c6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80268c:	89 c3                	mov    %eax,%ebx
  80268e:	85 c0                	test   %eax,%eax
  802690:	78 5f                	js     8026f1 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802692:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	e8 18 f5 ff ff       	call   801bb7 <_ZL10inode_openiPP5Inode>
  80269f:	89 c3                	mov    %eax,%ebx
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	78 44                	js     8026e9 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  8026a5:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  8026aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ad:	83 38 02             	cmpl   $0x2,(%eax)
  8026b0:	74 2f                	je     8026e1 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  8026b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  8026bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026be:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  8026c2:	ba 04 00 00 00       	mov    $0x4,%edx
  8026c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ca:	e8 2c f4 ff ff       	call   801afb <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  8026cf:	ba 04 00 00 00       	mov    $0x4,%edx
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	e8 1f f4 ff ff       	call   801afb <_ZL10bcache_ipcPvi>
	r = 0;
  8026dc:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  8026e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e4:	e8 cc f6 ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	e8 c4 f6 ff ff       	call   801db5 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  8026f1:	89 d8                	mov    %ebx,%eax
  8026f3:	83 c4 24             	add    $0x24,%esp
  8026f6:	5b                   	pop    %ebx
  8026f7:	5d                   	pop    %ebp
  8026f8:	c3                   	ret    

008026f9 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	5d                   	pop    %ebp
  802702:	c3                   	ret    

00802703 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
  802706:	57                   	push   %edi
  802707:	56                   	push   %esi
  802708:	53                   	push   %ebx
  802709:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  80270f:	c7 04 24 5d 1e 80 00 	movl   $0x801e5d,(%esp)
  802716:	e8 c0 14 00 00       	call   803bdb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  80271b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802720:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802725:	74 28                	je     80274f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802727:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  80272e:	4a 
  80272f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802733:	c7 44 24 08 fc 45 80 	movl   $0x8045fc,0x8(%esp)
  80273a:	00 
  80273b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802742:	00 
  802743:	c7 04 24 76 45 80 00 	movl   $0x804576,(%esp)
  80274a:	e8 79 db ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  80274f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802754:	83 f8 03             	cmp    $0x3,%eax
  802757:	7f 1c                	jg     802775 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802759:	c7 44 24 08 30 46 80 	movl   $0x804630,0x8(%esp)
  802760:	00 
  802761:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802768:	00 
  802769:	c7 04 24 76 45 80 00 	movl   $0x804576,(%esp)
  802770:	e8 53 db ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802775:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  80277b:	85 d2                	test   %edx,%edx
  80277d:	7f 1c                	jg     80279b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  80277f:	c7 44 24 08 60 46 80 	movl   $0x804660,0x8(%esp)
  802786:	00 
  802787:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  80278e:	00 
  80278f:	c7 04 24 76 45 80 00 	movl   $0x804576,(%esp)
  802796:	e8 2d db ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80279b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  8027a1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  8027a7:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  8027ad:	85 c9                	test   %ecx,%ecx
  8027af:	0f 48 cb             	cmovs  %ebx,%ecx
  8027b2:	c1 f9 0c             	sar    $0xc,%ecx
  8027b5:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  8027b9:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  8027bf:	39 c8                	cmp    %ecx,%eax
  8027c1:	7c 13                	jl     8027d6 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	7f 3d                	jg     802804 <_Z4fsckv+0x101>
  8027c7:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  8027ce:	00 00 00 
  8027d1:	e9 ac 00 00 00       	jmp    802882 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  8027d6:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  8027dc:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8027e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8027e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8027e8:	c7 44 24 08 90 46 80 	movl   $0x804690,0x8(%esp)
  8027ef:	00 
  8027f0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  8027f7:	00 
  8027f8:	c7 04 24 76 45 80 00 	movl   $0x804576,(%esp)
  8027ff:	e8 c4 da ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802804:	be 00 20 00 50       	mov    $0x50002000,%esi
  802809:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802810:	00 00 00 
  802813:	bb 00 00 00 00       	mov    $0x0,%ebx
  802818:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  80281e:	39 df                	cmp    %ebx,%edi
  802820:	7e 27                	jle    802849 <_Z4fsckv+0x146>
  802822:	0f b6 06             	movzbl (%esi),%eax
  802825:	84 c0                	test   %al,%al
  802827:	74 4b                	je     802874 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802829:	0f be c0             	movsbl %al,%eax
  80282c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802830:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802834:	c7 04 24 d4 46 80 00 	movl   $0x8046d4,(%esp)
  80283b:	e8 a6 db ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  802840:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802847:	eb 2b                	jmp    802874 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802849:	0f b6 06             	movzbl (%esi),%eax
  80284c:	3c 01                	cmp    $0x1,%al
  80284e:	76 24                	jbe    802874 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802850:	0f be c0             	movsbl %al,%eax
  802853:	89 44 24 08          	mov    %eax,0x8(%esp)
  802857:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80285b:	c7 04 24 08 47 80 00 	movl   $0x804708,(%esp)
  802862:	e8 7f db ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  802867:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  80286e:	80 3e 00             	cmpb   $0x0,(%esi)
  802871:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802874:	83 c3 01             	add    $0x1,%ebx
  802877:	83 c6 01             	add    $0x1,%esi
  80287a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802880:	7f 9c                	jg     80281e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802882:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802889:	0f 8e e1 02 00 00    	jle    802b70 <_Z4fsckv+0x46d>
  80288f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802896:	00 00 00 
		struct Inode *ino = get_inode(i);
  802899:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80289f:	e8 f9 f1 ff ff       	call   801a9d <_ZL9get_inodei>
  8028a4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  8028aa:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  8028ae:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  8028b5:	75 22                	jne    8028d9 <_Z4fsckv+0x1d6>
  8028b7:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  8028be:	0f 84 a9 06 00 00    	je     802f6d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  8028c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c9:	e8 2d f2 ff ff       	call   801afb <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  8028ce:	85 c0                	test   %eax,%eax
  8028d0:	74 3a                	je     80290c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  8028d2:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  8028d9:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8028df:	8b 02                	mov    (%edx),%eax
  8028e1:	83 f8 01             	cmp    $0x1,%eax
  8028e4:	74 26                	je     80290c <_Z4fsckv+0x209>
  8028e6:	83 f8 02             	cmp    $0x2,%eax
  8028e9:	74 21                	je     80290c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  8028eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028ef:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8028f5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028f9:	c7 04 24 34 47 80 00 	movl   $0x804734,(%esp)
  802900:	e8 e1 da ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  802905:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80290c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802913:	75 3f                	jne    802954 <_Z4fsckv+0x251>
  802915:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80291b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80291f:	75 15                	jne    802936 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802921:	c7 04 24 58 47 80 00 	movl   $0x804758,(%esp)
  802928:	e8 b9 da ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  80292d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802934:	eb 1e                	jmp    802954 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802936:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80293c:	83 3a 02             	cmpl   $0x2,(%edx)
  80293f:	74 13                	je     802954 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802941:	c7 04 24 8c 47 80 00 	movl   $0x80478c,(%esp)
  802948:	e8 99 da ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  80294d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802954:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802959:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802960:	0f 84 93 00 00 00    	je     8029f9 <_Z4fsckv+0x2f6>
  802966:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  80296c:	8b 41 08             	mov    0x8(%ecx),%eax
  80296f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802974:	7e 23                	jle    802999 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802976:	89 44 24 08          	mov    %eax,0x8(%esp)
  80297a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802980:	89 44 24 04          	mov    %eax,0x4(%esp)
  802984:	c7 04 24 bc 47 80 00 	movl   $0x8047bc,(%esp)
  80298b:	e8 56 da ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  802990:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802997:	eb 09                	jmp    8029a2 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802999:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8029a0:	74 4b                	je     8029ed <_Z4fsckv+0x2ea>
  8029a2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8029a8:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  8029ae:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  8029b4:	74 23                	je     8029d9 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  8029b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029ba:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8029c0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029c4:	c7 04 24 e0 47 80 00 	movl   $0x8047e0,(%esp)
  8029cb:	e8 16 da ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  8029d0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8029d7:	eb 09                	jmp    8029e2 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  8029d9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8029e0:	74 12                	je     8029f4 <_Z4fsckv+0x2f1>
  8029e2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8029e8:	8b 78 08             	mov    0x8(%eax),%edi
  8029eb:	eb 0c                	jmp    8029f9 <_Z4fsckv+0x2f6>
  8029ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f2:	eb 05                	jmp    8029f9 <_Z4fsckv+0x2f6>
  8029f4:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  8029f9:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  8029fe:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802a04:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802a08:	89 d8                	mov    %ebx,%eax
  802a0a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802a0d:	39 c7                	cmp    %eax,%edi
  802a0f:	7e 2b                	jle    802a3c <_Z4fsckv+0x339>
  802a11:	85 f6                	test   %esi,%esi
  802a13:	75 27                	jne    802a3c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802a15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a1d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802a23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a27:	c7 04 24 04 48 80 00 	movl   $0x804804,(%esp)
  802a2e:	e8 b3 d9 ff ff       	call   8003e6 <_Z7cprintfPKcz>
				++errors;
  802a33:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a3a:	eb 36                	jmp    802a72 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  802a3c:	39 f8                	cmp    %edi,%eax
  802a3e:	7c 32                	jl     802a72 <_Z4fsckv+0x36f>
  802a40:	85 f6                	test   %esi,%esi
  802a42:	74 2e                	je     802a72 <_Z4fsckv+0x36f>
  802a44:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802a4b:	74 25                	je     802a72 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  802a4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a51:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a55:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a5f:	c7 04 24 48 48 80 00 	movl   $0x804848,(%esp)
  802a66:	e8 7b d9 ff ff       	call   8003e6 <_Z7cprintfPKcz>
				++errors;
  802a6b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802a72:	85 f6                	test   %esi,%esi
  802a74:	0f 84 a0 00 00 00    	je     802b1a <_Z4fsckv+0x417>
  802a7a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802a81:	0f 84 93 00 00 00    	je     802b1a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802a87:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802a8d:	7e 27                	jle    802ab6 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802a8f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a97:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802a9d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802aa1:	c7 04 24 8c 48 80 00 	movl   $0x80488c,(%esp)
  802aa8:	e8 39 d9 ff ff       	call   8003e6 <_Z7cprintfPKcz>
					++errors;
  802aad:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ab4:	eb 64                	jmp    802b1a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802ab6:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802abd:	3c 01                	cmp    $0x1,%al
  802abf:	75 27                	jne    802ae8 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802ac1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802ac5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ac9:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802acf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ad3:	c7 04 24 d0 48 80 00 	movl   $0x8048d0,(%esp)
  802ada:	e8 07 d9 ff ff       	call   8003e6 <_Z7cprintfPKcz>
					++errors;
  802adf:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ae6:	eb 32                	jmp    802b1a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802ae8:	3c ff                	cmp    $0xff,%al
  802aea:	75 27                	jne    802b13 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802aec:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802af0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802af4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  802afe:	c7 04 24 0c 49 80 00 	movl   $0x80490c,(%esp)
  802b05:	e8 dc d8 ff ff       	call   8003e6 <_Z7cprintfPKcz>
					++errors;
  802b0a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802b11:	eb 07                	jmp    802b1a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802b13:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802b1a:	83 c3 01             	add    $0x1,%ebx
  802b1d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802b23:	0f 85 d5 fe ff ff    	jne    8029fe <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802b29:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802b30:	0f 94 c0             	sete   %al
  802b33:	0f b6 c0             	movzbl %al,%eax
  802b36:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b3c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802b42:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802b49:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802b50:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802b57:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802b5e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802b64:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802b6a:	0f 8f 29 fd ff ff    	jg     802899 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b70:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802b77:	0f 8e 7f 03 00 00    	jle    802efc <_Z4fsckv+0x7f9>
  802b7d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802b82:	89 f0                	mov    %esi,%eax
  802b84:	e8 14 ef ff ff       	call   801a9d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802b89:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802b90:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802b97:	c1 e2 08             	shl    $0x8,%edx
  802b9a:	09 ca                	or     %ecx,%edx
  802b9c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802ba3:	c1 e1 10             	shl    $0x10,%ecx
  802ba6:	09 ca                	or     %ecx,%edx
  802ba8:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802baf:	83 e1 7f             	and    $0x7f,%ecx
  802bb2:	c1 e1 18             	shl    $0x18,%ecx
  802bb5:	09 d1                	or     %edx,%ecx
  802bb7:	74 0e                	je     802bc7 <_Z4fsckv+0x4c4>
  802bb9:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802bc0:	78 05                	js     802bc7 <_Z4fsckv+0x4c4>
  802bc2:	83 38 02             	cmpl   $0x2,(%eax)
  802bc5:	74 1f                	je     802be6 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802bc7:	83 c6 01             	add    $0x1,%esi
  802bca:	a1 08 10 00 50       	mov    0x50001008,%eax
  802bcf:	39 f0                	cmp    %esi,%eax
  802bd1:	7f af                	jg     802b82 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802bd3:	bb 01 00 00 00       	mov    $0x1,%ebx
  802bd8:	83 f8 01             	cmp    $0x1,%eax
  802bdb:	0f 8f ad 02 00 00    	jg     802e8e <_Z4fsckv+0x78b>
  802be1:	e9 16 03 00 00       	jmp    802efc <_Z4fsckv+0x7f9>
  802be6:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802be8:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802bef:	8b 40 08             	mov    0x8(%eax),%eax
  802bf2:	a8 7f                	test   $0x7f,%al
  802bf4:	74 23                	je     802c19 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802bf6:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802bfd:	00 
  802bfe:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c02:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c06:	c7 04 24 48 49 80 00 	movl   $0x804948,(%esp)
  802c0d:	e8 d4 d7 ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  802c12:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802c19:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802c20:	00 00 00 
  802c23:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802c29:	e9 3d 02 00 00       	jmp    802e6b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802c2e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c34:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802c3a:	e8 01 ee ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
  802c3f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802c41:	83 38 00             	cmpl   $0x0,(%eax)
  802c44:	0f 84 15 02 00 00    	je     802e5f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802c4a:	8b 40 04             	mov    0x4(%eax),%eax
  802c4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c50:	83 fa 76             	cmp    $0x76,%edx
  802c53:	76 27                	jbe    802c7c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802c55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c59:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802c5f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c63:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c67:	c7 04 24 7c 49 80 00 	movl   $0x80497c,(%esp)
  802c6e:	e8 73 d7 ff ff       	call   8003e6 <_Z7cprintfPKcz>
				++errors;
  802c73:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c7a:	eb 28                	jmp    802ca4 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802c7c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802c81:	74 21                	je     802ca4 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802c83:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c89:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c8d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c91:	c7 04 24 a8 49 80 00 	movl   $0x8049a8,(%esp)
  802c98:	e8 49 d7 ff ff       	call   8003e6 <_Z7cprintfPKcz>
				++errors;
  802c9d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802ca4:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802cab:	00 
  802cac:	8d 43 08             	lea    0x8(%ebx),%eax
  802caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cb3:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802cb9:	89 0c 24             	mov    %ecx,(%esp)
  802cbc:	e8 56 df ff ff       	call   800c17 <memcpy>
  802cc1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802cc5:	bf 77 00 00 00       	mov    $0x77,%edi
  802cca:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802cce:	85 ff                	test   %edi,%edi
  802cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd5:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802cd8:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802cdf:	00 

			if (de->de_inum >= super->s_ninodes) {
  802ce0:	8b 03                	mov    (%ebx),%eax
  802ce2:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802ce8:	7c 3e                	jl     802d28 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802cea:	89 44 24 10          	mov    %eax,0x10(%esp)
  802cee:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802cf4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802cf8:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802cfe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d02:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d06:	c7 04 24 dc 49 80 00 	movl   $0x8049dc,(%esp)
  802d0d:	e8 d4 d6 ff ff       	call   8003e6 <_Z7cprintfPKcz>
				++errors;
  802d12:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802d19:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802d20:	00 00 00 
  802d23:	e9 0b 01 00 00       	jmp    802e33 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802d28:	e8 70 ed ff ff       	call   801a9d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802d2d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802d34:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802d3b:	c1 e2 08             	shl    $0x8,%edx
  802d3e:	09 d1                	or     %edx,%ecx
  802d40:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802d47:	c1 e2 10             	shl    $0x10,%edx
  802d4a:	09 d1                	or     %edx,%ecx
  802d4c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802d53:	83 e2 7f             	and    $0x7f,%edx
  802d56:	c1 e2 18             	shl    $0x18,%edx
  802d59:	09 ca                	or     %ecx,%edx
  802d5b:	83 c2 01             	add    $0x1,%edx
  802d5e:	89 d1                	mov    %edx,%ecx
  802d60:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802d66:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802d6c:	0f b6 d5             	movzbl %ch,%edx
  802d6f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802d75:	89 ca                	mov    %ecx,%edx
  802d77:	c1 ea 10             	shr    $0x10,%edx
  802d7a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802d80:	c1 e9 18             	shr    $0x18,%ecx
  802d83:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802d8a:	83 e2 80             	and    $0xffffff80,%edx
  802d8d:	09 ca                	or     %ecx,%edx
  802d8f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802d95:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802d99:	0f 85 7a ff ff ff    	jne    802d19 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802d9f:	8b 03                	mov    (%ebx),%eax
  802da1:	89 44 24 10          	mov    %eax,0x10(%esp)
  802da5:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802dab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802daf:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802db5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802db9:	89 74 24 04          	mov    %esi,0x4(%esp)
  802dbd:	c7 04 24 0c 4a 80 00 	movl   $0x804a0c,(%esp)
  802dc4:	e8 1d d6 ff ff       	call   8003e6 <_Z7cprintfPKcz>
					++errors;
  802dc9:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802dd0:	e9 44 ff ff ff       	jmp    802d19 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802dd5:	3b 78 04             	cmp    0x4(%eax),%edi
  802dd8:	75 52                	jne    802e2c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802dda:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802dde:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802de4:	89 54 24 04          	mov    %edx,0x4(%esp)
  802de8:	83 c0 08             	add    $0x8,%eax
  802deb:	89 04 24             	mov    %eax,(%esp)
  802dee:	e8 65 de ff ff       	call   800c58 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802df3:	85 c0                	test   %eax,%eax
  802df5:	75 35                	jne    802e2c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802df7:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802dfd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802e01:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802e07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e0b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e11:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e15:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e19:	c7 04 24 3c 4a 80 00 	movl   $0x804a3c,(%esp)
  802e20:	e8 c1 d5 ff ff       	call   8003e6 <_Z7cprintfPKcz>
					++errors;
  802e25:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802e2c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802e33:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802e39:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802e3f:	7e 1e                	jle    802e5f <_Z4fsckv+0x75c>
  802e41:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802e45:	7f 18                	jg     802e5f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802e47:	89 ca                	mov    %ecx,%edx
  802e49:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802e4f:	e8 ec eb ff ff       	call   801a40 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802e54:	83 38 00             	cmpl   $0x0,(%eax)
  802e57:	0f 85 78 ff ff ff    	jne    802dd5 <_Z4fsckv+0x6d2>
  802e5d:	eb cd                	jmp    802e2c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802e5f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802e65:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802e6b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e71:	83 ea 80             	sub    $0xffffff80,%edx
  802e74:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802e7a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802e80:	3b 51 08             	cmp    0x8(%ecx),%edx
  802e83:	0f 8f e7 fc ff ff    	jg     802b70 <_Z4fsckv+0x46d>
  802e89:	e9 a0 fd ff ff       	jmp    802c2e <_Z4fsckv+0x52b>
  802e8e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802e94:	89 d8                	mov    %ebx,%eax
  802e96:	e8 02 ec ff ff       	call   801a9d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802e9b:	8b 50 04             	mov    0x4(%eax),%edx
  802e9e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802ea5:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  802eac:	c1 e7 08             	shl    $0x8,%edi
  802eaf:	09 f9                	or     %edi,%ecx
  802eb1:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  802eb8:	c1 e7 10             	shl    $0x10,%edi
  802ebb:	09 f9                	or     %edi,%ecx
  802ebd:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  802ec4:	83 e7 7f             	and    $0x7f,%edi
  802ec7:	c1 e7 18             	shl    $0x18,%edi
  802eca:	09 f9                	or     %edi,%ecx
  802ecc:	39 ca                	cmp    %ecx,%edx
  802ece:	74 1b                	je     802eeb <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  802ed0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802ed4:	89 54 24 08          	mov    %edx,0x8(%esp)
  802ed8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802edc:	c7 04 24 6c 4a 80 00 	movl   $0x804a6c,(%esp)
  802ee3:	e8 fe d4 ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  802ee8:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802eeb:	83 c3 01             	add    $0x1,%ebx
  802eee:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802ef4:	7f 9e                	jg     802e94 <_Z4fsckv+0x791>
  802ef6:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802efc:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802f03:	7e 4f                	jle    802f54 <_Z4fsckv+0x851>
  802f05:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f0a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  802f10:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  802f17:	3c ff                	cmp    $0xff,%al
  802f19:	75 09                	jne    802f24 <_Z4fsckv+0x821>
			freemap[i] = 0;
  802f1b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  802f22:	eb 1f                	jmp    802f43 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  802f24:	84 c0                	test   %al,%al
  802f26:	75 1b                	jne    802f43 <_Z4fsckv+0x840>
  802f28:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  802f2e:	7c 13                	jl     802f43 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  802f30:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f34:	c7 04 24 98 4a 80 00 	movl   $0x804a98,(%esp)
  802f3b:	e8 a6 d4 ff ff       	call   8003e6 <_Z7cprintfPKcz>
			++errors;
  802f40:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802f43:	83 c3 01             	add    $0x1,%ebx
  802f46:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802f4c:	7f c2                	jg     802f10 <_Z4fsckv+0x80d>
  802f4e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  802f54:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  802f5b:	19 c0                	sbb    %eax,%eax
  802f5d:	f7 d0                	not    %eax
  802f5f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  802f62:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  802f68:	5b                   	pop    %ebx
  802f69:	5e                   	pop    %esi
  802f6a:	5f                   	pop    %edi
  802f6b:	5d                   	pop    %ebp
  802f6c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802f6d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802f74:	0f 84 92 f9 ff ff    	je     80290c <_Z4fsckv+0x209>
  802f7a:	e9 5a f9 ff ff       	jmp    8028d9 <_Z4fsckv+0x1d6>
	...

00802f80 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f80:	55                   	push   %ebp
  802f81:	89 e5                	mov    %esp,%ebp
  802f83:	83 ec 18             	sub    $0x18,%esp
  802f86:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802f89:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	89 04 24             	mov    %eax,(%esp)
  802f95:	e8 a2 e4 ff ff       	call   80143c <_Z7fd2dataP2Fd>
  802f9a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802f9c:	c7 44 24 04 cb 4a 80 	movl   $0x804acb,0x4(%esp)
  802fa3:	00 
  802fa4:	89 34 24             	mov    %esi,(%esp)
  802fa7:	e8 4e da ff ff       	call   8009fa <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  802fac:	8b 43 04             	mov    0x4(%ebx),%eax
  802faf:	2b 03                	sub    (%ebx),%eax
  802fb1:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  802fb4:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  802fbb:	c7 86 80 00 00 00 20 	movl   $0x805020,0x80(%esi)
  802fc2:	50 80 00 
	return 0;
}
  802fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802fca:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802fcd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802fd0:	89 ec                	mov    %ebp,%esp
  802fd2:	5d                   	pop    %ebp
  802fd3:	c3                   	ret    

00802fd4 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  802fd4:	55                   	push   %ebp
  802fd5:	89 e5                	mov    %esp,%ebp
  802fd7:	53                   	push   %ebx
  802fd8:	83 ec 14             	sub    $0x14,%esp
  802fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802fde:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802fe2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fe9:	e8 af df ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  802fee:	89 1c 24             	mov    %ebx,(%esp)
  802ff1:	e8 46 e4 ff ff       	call   80143c <_Z7fd2dataP2Fd>
  802ff6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ffa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803001:	e8 97 df ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
}
  803006:	83 c4 14             	add    $0x14,%esp
  803009:	5b                   	pop    %ebx
  80300a:	5d                   	pop    %ebp
  80300b:	c3                   	ret    

0080300c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80300c:	55                   	push   %ebp
  80300d:	89 e5                	mov    %esp,%ebp
  80300f:	57                   	push   %edi
  803010:	56                   	push   %esi
  803011:	53                   	push   %ebx
  803012:	83 ec 2c             	sub    $0x2c,%esp
  803015:	89 c7                	mov    %eax,%edi
  803017:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80301a:	a1 00 60 80 00       	mov    0x806000,%eax
  80301f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803022:	89 3c 24             	mov    %edi,(%esp)
  803025:	e8 82 04 00 00       	call   8034ac <_Z7pagerefPv>
  80302a:	89 c3                	mov    %eax,%ebx
  80302c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302f:	89 04 24             	mov    %eax,(%esp)
  803032:	e8 75 04 00 00       	call   8034ac <_Z7pagerefPv>
  803037:	39 c3                	cmp    %eax,%ebx
  803039:	0f 94 c0             	sete   %al
  80303c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80303f:	8b 15 00 60 80 00    	mov    0x806000,%edx
  803045:	8b 52 58             	mov    0x58(%edx),%edx
  803048:	39 d6                	cmp    %edx,%esi
  80304a:	75 08                	jne    803054 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  80304c:	83 c4 2c             	add    $0x2c,%esp
  80304f:	5b                   	pop    %ebx
  803050:	5e                   	pop    %esi
  803051:	5f                   	pop    %edi
  803052:	5d                   	pop    %ebp
  803053:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803054:	85 c0                	test   %eax,%eax
  803056:	74 c2                	je     80301a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803058:	c7 04 24 d2 4a 80 00 	movl   $0x804ad2,(%esp)
  80305f:	e8 82 d3 ff ff       	call   8003e6 <_Z7cprintfPKcz>
  803064:	eb b4                	jmp    80301a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00803066 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803066:	55                   	push   %ebp
  803067:	89 e5                	mov    %esp,%ebp
  803069:	57                   	push   %edi
  80306a:	56                   	push   %esi
  80306b:	53                   	push   %ebx
  80306c:	83 ec 1c             	sub    $0x1c,%esp
  80306f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803072:	89 34 24             	mov    %esi,(%esp)
  803075:	e8 c2 e3 ff ff       	call   80143c <_Z7fd2dataP2Fd>
  80307a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80307c:	bf 00 00 00 00       	mov    $0x0,%edi
  803081:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803085:	75 46                	jne    8030cd <_ZL13devpipe_writeP2FdPKvj+0x67>
  803087:	eb 52                	jmp    8030db <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803089:	89 da                	mov    %ebx,%edx
  80308b:	89 f0                	mov    %esi,%eax
  80308d:	e8 7a ff ff ff       	call   80300c <_ZL13_pipeisclosedP2FdP4Pipe>
  803092:	85 c0                	test   %eax,%eax
  803094:	75 49                	jne    8030df <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803096:	e8 11 de ff ff       	call   800eac <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80309b:	8b 43 04             	mov    0x4(%ebx),%eax
  80309e:	89 c2                	mov    %eax,%edx
  8030a0:	2b 13                	sub    (%ebx),%edx
  8030a2:	83 fa 20             	cmp    $0x20,%edx
  8030a5:	74 e2                	je     803089 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8030a7:	89 c2                	mov    %eax,%edx
  8030a9:	c1 fa 1f             	sar    $0x1f,%edx
  8030ac:	c1 ea 1b             	shr    $0x1b,%edx
  8030af:	01 d0                	add    %edx,%eax
  8030b1:	83 e0 1f             	and    $0x1f,%eax
  8030b4:	29 d0                	sub    %edx,%eax
  8030b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8030b9:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  8030bd:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  8030c1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8030c5:	83 c7 01             	add    $0x1,%edi
  8030c8:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8030cb:	76 0e                	jbe    8030db <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8030cd:	8b 43 04             	mov    0x4(%ebx),%eax
  8030d0:	89 c2                	mov    %eax,%edx
  8030d2:	2b 13                	sub    (%ebx),%edx
  8030d4:	83 fa 20             	cmp    $0x20,%edx
  8030d7:	74 b0                	je     803089 <_ZL13devpipe_writeP2FdPKvj+0x23>
  8030d9:	eb cc                	jmp    8030a7 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  8030db:	89 f8                	mov    %edi,%eax
  8030dd:	eb 05                	jmp    8030e4 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  8030df:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  8030e4:	83 c4 1c             	add    $0x1c,%esp
  8030e7:	5b                   	pop    %ebx
  8030e8:	5e                   	pop    %esi
  8030e9:	5f                   	pop    %edi
  8030ea:	5d                   	pop    %ebp
  8030eb:	c3                   	ret    

008030ec <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8030ec:	55                   	push   %ebp
  8030ed:	89 e5                	mov    %esp,%ebp
  8030ef:	83 ec 28             	sub    $0x28,%esp
  8030f2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8030f5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8030f8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8030fb:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8030fe:	89 3c 24             	mov    %edi,(%esp)
  803101:	e8 36 e3 ff ff       	call   80143c <_Z7fd2dataP2Fd>
  803106:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803108:	be 00 00 00 00       	mov    $0x0,%esi
  80310d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803111:	75 47                	jne    80315a <_ZL12devpipe_readP2FdPvj+0x6e>
  803113:	eb 52                	jmp    803167 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803115:	89 f0                	mov    %esi,%eax
  803117:	eb 5e                	jmp    803177 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803119:	89 da                	mov    %ebx,%edx
  80311b:	89 f8                	mov    %edi,%eax
  80311d:	8d 76 00             	lea    0x0(%esi),%esi
  803120:	e8 e7 fe ff ff       	call   80300c <_ZL13_pipeisclosedP2FdP4Pipe>
  803125:	85 c0                	test   %eax,%eax
  803127:	75 49                	jne    803172 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803129:	e8 7e dd ff ff       	call   800eac <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80312e:	8b 03                	mov    (%ebx),%eax
  803130:	3b 43 04             	cmp    0x4(%ebx),%eax
  803133:	74 e4                	je     803119 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803135:	89 c2                	mov    %eax,%edx
  803137:	c1 fa 1f             	sar    $0x1f,%edx
  80313a:	c1 ea 1b             	shr    $0x1b,%edx
  80313d:	01 d0                	add    %edx,%eax
  80313f:	83 e0 1f             	and    $0x1f,%eax
  803142:	29 d0                	sub    %edx,%eax
  803144:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803149:	8b 55 0c             	mov    0xc(%ebp),%edx
  80314c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80314f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803152:	83 c6 01             	add    $0x1,%esi
  803155:	39 75 10             	cmp    %esi,0x10(%ebp)
  803158:	76 0d                	jbe    803167 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80315a:	8b 03                	mov    (%ebx),%eax
  80315c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80315f:	75 d4                	jne    803135 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803161:	85 f6                	test   %esi,%esi
  803163:	75 b0                	jne    803115 <_ZL12devpipe_readP2FdPvj+0x29>
  803165:	eb b2                	jmp    803119 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803167:	89 f0                	mov    %esi,%eax
  803169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803170:	eb 05                	jmp    803177 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803172:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803177:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80317a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80317d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803180:	89 ec                	mov    %ebp,%esp
  803182:	5d                   	pop    %ebp
  803183:	c3                   	ret    

00803184 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803184:	55                   	push   %ebp
  803185:	89 e5                	mov    %esp,%ebp
  803187:	83 ec 48             	sub    $0x48,%esp
  80318a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80318d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803190:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803193:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803196:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803199:	89 04 24             	mov    %eax,(%esp)
  80319c:	e8 b6 e2 ff ff       	call   801457 <_Z14fd_find_unusedPP2Fd>
  8031a1:	89 c3                	mov    %eax,%ebx
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	0f 88 0b 01 00 00    	js     8032b6 <_Z4pipePi+0x132>
  8031ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031b2:	00 
  8031b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031c1:	e8 1a dd ff ff       	call   800ee0 <_Z14sys_page_allociPvi>
  8031c6:	89 c3                	mov    %eax,%ebx
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	0f 89 f5 00 00 00    	jns    8032c5 <_Z4pipePi+0x141>
  8031d0:	e9 e1 00 00 00       	jmp    8032b6 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8031d5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031dc:	00 
  8031dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031eb:	e8 f0 dc ff ff       	call   800ee0 <_Z14sys_page_allociPvi>
  8031f0:	89 c3                	mov    %eax,%ebx
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	0f 89 e2 00 00 00    	jns    8032dc <_Z4pipePi+0x158>
  8031fa:	e9 a4 00 00 00       	jmp    8032a3 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803202:	89 04 24             	mov    %eax,(%esp)
  803205:	e8 32 e2 ff ff       	call   80143c <_Z7fd2dataP2Fd>
  80320a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803211:	00 
  803212:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803216:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80321d:	00 
  80321e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803222:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803229:	e8 11 dd ff ff       	call   800f3f <_Z12sys_page_mapiPviS_i>
  80322e:	89 c3                	mov    %eax,%ebx
  803230:	85 c0                	test   %eax,%eax
  803232:	78 4c                	js     803280 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803234:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80323a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80323f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803242:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803249:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80324f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803252:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803254:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803257:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80325e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803261:	89 04 24             	mov    %eax,(%esp)
  803264:	e8 8b e1 ff ff       	call   8013f4 <_Z6fd2numP2Fd>
  803269:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80326b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80326e:	89 04 24             	mov    %eax,(%esp)
  803271:	e8 7e e1 ff ff       	call   8013f4 <_Z6fd2numP2Fd>
  803276:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803279:	bb 00 00 00 00       	mov    $0x0,%ebx
  80327e:	eb 36                	jmp    8032b6 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803280:	89 74 24 04          	mov    %esi,0x4(%esp)
  803284:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80328b:	e8 0d dd ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803290:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803293:	89 44 24 04          	mov    %eax,0x4(%esp)
  803297:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80329e:	e8 fa dc ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  8032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032b1:	e8 e7 dc ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  8032b6:	89 d8                	mov    %ebx,%eax
  8032b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8032bb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8032be:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8032c1:	89 ec                	mov    %ebp,%esp
  8032c3:	5d                   	pop    %ebp
  8032c4:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8032c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8032c8:	89 04 24             	mov    %eax,(%esp)
  8032cb:	e8 87 e1 ff ff       	call   801457 <_Z14fd_find_unusedPP2Fd>
  8032d0:	89 c3                	mov    %eax,%ebx
  8032d2:	85 c0                	test   %eax,%eax
  8032d4:	0f 89 fb fe ff ff    	jns    8031d5 <_Z4pipePi+0x51>
  8032da:	eb c7                	jmp    8032a3 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032df:	89 04 24             	mov    %eax,(%esp)
  8032e2:	e8 55 e1 ff ff       	call   80143c <_Z7fd2dataP2Fd>
  8032e7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032e9:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8032f0:	00 
  8032f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032fc:	e8 df db ff ff       	call   800ee0 <_Z14sys_page_allociPvi>
  803301:	89 c3                	mov    %eax,%ebx
  803303:	85 c0                	test   %eax,%eax
  803305:	0f 89 f4 fe ff ff    	jns    8031ff <_Z4pipePi+0x7b>
  80330b:	eb 83                	jmp    803290 <_Z4pipePi+0x10c>

0080330d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80330d:	55                   	push   %ebp
  80330e:	89 e5                	mov    %esp,%ebp
  803310:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803313:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80331a:	00 
  80331b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80331e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	89 04 24             	mov    %eax,(%esp)
  803328:	e8 74 e0 ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  80332d:	85 c0                	test   %eax,%eax
  80332f:	78 15                	js     803346 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803334:	89 04 24             	mov    %eax,(%esp)
  803337:	e8 00 e1 ff ff       	call   80143c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80333c:	89 c2                	mov    %eax,%edx
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	e8 c6 fc ff ff       	call   80300c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803346:	c9                   	leave  
  803347:	c3                   	ret    

00803348 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803348:	55                   	push   %ebp
  803349:	89 e5                	mov    %esp,%ebp
  80334b:	53                   	push   %ebx
  80334c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80334f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803352:	89 04 24             	mov    %eax,(%esp)
  803355:	e8 fd e0 ff ff       	call   801457 <_Z14fd_find_unusedPP2Fd>
  80335a:	89 c3                	mov    %eax,%ebx
  80335c:	85 c0                	test   %eax,%eax
  80335e:	0f 88 be 00 00 00    	js     803422 <_Z18pipe_ipc_recv_readv+0xda>
  803364:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80336b:	00 
  80336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803373:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80337a:	e8 61 db ff ff       	call   800ee0 <_Z14sys_page_allociPvi>
  80337f:	89 c3                	mov    %eax,%ebx
  803381:	85 c0                	test   %eax,%eax
  803383:	0f 89 a1 00 00 00    	jns    80342a <_Z18pipe_ipc_recv_readv+0xe2>
  803389:	e9 94 00 00 00       	jmp    803422 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80338e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803391:	85 c0                	test   %eax,%eax
  803393:	75 0e                	jne    8033a3 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803395:	c7 04 24 30 4b 80 00 	movl   $0x804b30,(%esp)
  80339c:	e8 45 d0 ff ff       	call   8003e6 <_Z7cprintfPKcz>
  8033a1:	eb 10                	jmp    8033b3 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  8033a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033a7:	c7 04 24 e5 4a 80 00 	movl   $0x804ae5,(%esp)
  8033ae:	e8 33 d0 ff ff       	call   8003e6 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  8033b3:	c7 04 24 ef 4a 80 00 	movl   $0x804aef,(%esp)
  8033ba:	e8 27 d0 ff ff       	call   8003e6 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  8033bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c2:	a8 04                	test   $0x4,%al
  8033c4:	74 04                	je     8033ca <_Z18pipe_ipc_recv_readv+0x82>
  8033c6:	a8 01                	test   $0x1,%al
  8033c8:	75 24                	jne    8033ee <_Z18pipe_ipc_recv_readv+0xa6>
  8033ca:	c7 44 24 0c 02 4b 80 	movl   $0x804b02,0xc(%esp)
  8033d1:	00 
  8033d2:	c7 44 24 08 cc 44 80 	movl   $0x8044cc,0x8(%esp)
  8033d9:	00 
  8033da:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8033e1:	00 
  8033e2:	c7 04 24 1f 4b 80 00 	movl   $0x804b1f,(%esp)
  8033e9:	e8 da ce ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  8033ee:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803403:	89 04 24             	mov    %eax,(%esp)
  803406:	e8 e9 df ff ff       	call   8013f4 <_Z6fd2numP2Fd>
  80340b:	89 c3                	mov    %eax,%ebx
  80340d:	eb 13                	jmp    803422 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	89 44 24 04          	mov    %eax,0x4(%esp)
  803416:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80341d:	e8 7b db ff ff       	call   800f9d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803422:	89 d8                	mov    %ebx,%eax
  803424:	83 c4 24             	add    $0x24,%esp
  803427:	5b                   	pop    %ebx
  803428:	5d                   	pop    %ebp
  803429:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80342a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342d:	89 04 24             	mov    %eax,(%esp)
  803430:	e8 07 e0 ff ff       	call   80143c <_Z7fd2dataP2Fd>
  803435:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803438:	89 54 24 08          	mov    %edx,0x8(%esp)
  80343c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803440:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803443:	89 04 24             	mov    %eax,(%esp)
  803446:	e8 85 08 00 00       	call   803cd0 <_Z8ipc_recvPiPvS_>
  80344b:	89 c3                	mov    %eax,%ebx
  80344d:	85 c0                	test   %eax,%eax
  80344f:	0f 89 39 ff ff ff    	jns    80338e <_Z18pipe_ipc_recv_readv+0x46>
  803455:	eb b8                	jmp    80340f <_Z18pipe_ipc_recv_readv+0xc7>

00803457 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803457:	55                   	push   %ebp
  803458:	89 e5                	mov    %esp,%ebp
  80345a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80345d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803464:	00 
  803465:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803468:	89 44 24 04          	mov    %eax,0x4(%esp)
  80346c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346f:	89 04 24             	mov    %eax,(%esp)
  803472:	e8 2a df ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  803477:	85 c0                	test   %eax,%eax
  803479:	78 2f                	js     8034aa <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347e:	89 04 24             	mov    %eax,(%esp)
  803481:	e8 b6 df ff ff       	call   80143c <_Z7fd2dataP2Fd>
  803486:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80348d:	00 
  80348e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803492:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803499:	00 
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	89 04 24             	mov    %eax,(%esp)
  8034a0:	e8 ba 08 00 00       	call   803d5f <_Z8ipc_sendijPvi>
    return 0;
  8034a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034aa:	c9                   	leave  
  8034ab:	c3                   	ret    

008034ac <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034ac:	55                   	push   %ebp
  8034ad:	89 e5                	mov    %esp,%ebp
  8034af:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8034b2:	89 d0                	mov    %edx,%eax
  8034b4:	c1 e8 16             	shr    $0x16,%eax
  8034b7:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  8034be:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8034c3:	f6 c1 01             	test   $0x1,%cl
  8034c6:	74 1d                	je     8034e5 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  8034c8:	c1 ea 0c             	shr    $0xc,%edx
  8034cb:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8034d2:	f6 c2 01             	test   $0x1,%dl
  8034d5:	74 0e                	je     8034e5 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8034d7:	c1 ea 0c             	shr    $0xc,%edx
  8034da:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  8034e1:	ef 
  8034e2:	0f b7 c0             	movzwl %ax,%eax
}
  8034e5:	5d                   	pop    %ebp
  8034e6:	c3                   	ret    
	...

008034f0 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8034f0:	55                   	push   %ebp
  8034f1:	89 e5                	mov    %esp,%ebp
  8034f3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8034f6:	c7 44 24 04 53 4b 80 	movl   $0x804b53,0x4(%esp)
  8034fd:	00 
  8034fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803501:	89 04 24             	mov    %eax,(%esp)
  803504:	e8 f1 d4 ff ff       	call   8009fa <_Z6strcpyPcPKc>
	return 0;
}
  803509:	b8 00 00 00 00       	mov    $0x0,%eax
  80350e:	c9                   	leave  
  80350f:	c3                   	ret    

00803510 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803510:	55                   	push   %ebp
  803511:	89 e5                	mov    %esp,%ebp
  803513:	53                   	push   %ebx
  803514:	83 ec 14             	sub    $0x14,%esp
  803517:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80351a:	89 1c 24             	mov    %ebx,(%esp)
  80351d:	e8 8a ff ff ff       	call   8034ac <_Z7pagerefPv>
  803522:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803524:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803529:	83 fa 01             	cmp    $0x1,%edx
  80352c:	75 0b                	jne    803539 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80352e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803531:	89 04 24             	mov    %eax,(%esp)
  803534:	e8 fe 02 00 00       	call   803837 <_Z11nsipc_closei>
	else
		return 0;
}
  803539:	83 c4 14             	add    $0x14,%esp
  80353c:	5b                   	pop    %ebx
  80353d:	5d                   	pop    %ebp
  80353e:	c3                   	ret    

0080353f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80353f:	55                   	push   %ebp
  803540:	89 e5                	mov    %esp,%ebp
  803542:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803545:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80354c:	00 
  80354d:	8b 45 10             	mov    0x10(%ebp),%eax
  803550:	89 44 24 08          	mov    %eax,0x8(%esp)
  803554:	8b 45 0c             	mov    0xc(%ebp),%eax
  803557:	89 44 24 04          	mov    %eax,0x4(%esp)
  80355b:	8b 45 08             	mov    0x8(%ebp),%eax
  80355e:	8b 40 0c             	mov    0xc(%eax),%eax
  803561:	89 04 24             	mov    %eax,(%esp)
  803564:	e8 c9 03 00 00       	call   803932 <_Z10nsipc_sendiPKvij>
}
  803569:	c9                   	leave  
  80356a:	c3                   	ret    

0080356b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80356b:	55                   	push   %ebp
  80356c:	89 e5                	mov    %esp,%ebp
  80356e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803571:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803578:	00 
  803579:	8b 45 10             	mov    0x10(%ebp),%eax
  80357c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803580:	8b 45 0c             	mov    0xc(%ebp),%eax
  803583:	89 44 24 04          	mov    %eax,0x4(%esp)
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	8b 40 0c             	mov    0xc(%eax),%eax
  80358d:	89 04 24             	mov    %eax,(%esp)
  803590:	e8 1d 03 00 00       	call   8038b2 <_Z10nsipc_recviPvij>
}
  803595:	c9                   	leave  
  803596:	c3                   	ret    

00803597 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803597:	55                   	push   %ebp
  803598:	89 e5                	mov    %esp,%ebp
  80359a:	83 ec 28             	sub    $0x28,%esp
  80359d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8035a0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8035a3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  8035a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8035a8:	89 04 24             	mov    %eax,(%esp)
  8035ab:	e8 a7 de ff ff       	call   801457 <_Z14fd_find_unusedPP2Fd>
  8035b0:	89 c3                	mov    %eax,%ebx
  8035b2:	85 c0                	test   %eax,%eax
  8035b4:	78 21                	js     8035d7 <_ZL12alloc_sockfdi+0x40>
  8035b6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8035bd:	00 
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035cc:	e8 0f d9 ff ff       	call   800ee0 <_Z14sys_page_allociPvi>
  8035d1:	89 c3                	mov    %eax,%ebx
  8035d3:	85 c0                	test   %eax,%eax
  8035d5:	79 14                	jns    8035eb <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8035d7:	89 34 24             	mov    %esi,(%esp)
  8035da:	e8 58 02 00 00       	call   803837 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  8035df:	89 d8                	mov    %ebx,%eax
  8035e1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8035e4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8035e7:	89 ec                	mov    %ebp,%esp
  8035e9:	5d                   	pop    %ebp
  8035ea:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  8035eb:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8035f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803600:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803603:	89 04 24             	mov    %eax,(%esp)
  803606:	e8 e9 dd ff ff       	call   8013f4 <_Z6fd2numP2Fd>
  80360b:	89 c3                	mov    %eax,%ebx
  80360d:	eb d0                	jmp    8035df <_ZL12alloc_sockfdi+0x48>

0080360f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80360f:	55                   	push   %ebp
  803610:	89 e5                	mov    %esp,%ebp
  803612:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803615:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80361c:	00 
  80361d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803620:	89 54 24 04          	mov    %edx,0x4(%esp)
  803624:	89 04 24             	mov    %eax,(%esp)
  803627:	e8 75 dd ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  80362c:	85 c0                	test   %eax,%eax
  80362e:	78 15                	js     803645 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803630:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803633:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803638:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80363e:	39 0a                	cmp    %ecx,(%edx)
  803640:	75 03                	jne    803645 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803642:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803645:	c9                   	leave  
  803646:	c3                   	ret    

00803647 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803647:	55                   	push   %ebp
  803648:	89 e5                	mov    %esp,%ebp
  80364a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	e8 ba ff ff ff       	call   80360f <_ZL9fd2sockidi>
  803655:	85 c0                	test   %eax,%eax
  803657:	78 1f                	js     803678 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803659:	8b 55 10             	mov    0x10(%ebp),%edx
  80365c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803660:	8b 55 0c             	mov    0xc(%ebp),%edx
  803663:	89 54 24 04          	mov    %edx,0x4(%esp)
  803667:	89 04 24             	mov    %eax,(%esp)
  80366a:	e8 19 01 00 00       	call   803788 <_Z12nsipc_acceptiP8sockaddrPj>
  80366f:	85 c0                	test   %eax,%eax
  803671:	78 05                	js     803678 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803673:	e8 1f ff ff ff       	call   803597 <_ZL12alloc_sockfdi>
}
  803678:	c9                   	leave  
  803679:	c3                   	ret    

0080367a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80367a:	55                   	push   %ebp
  80367b:	89 e5                	mov    %esp,%ebp
  80367d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	e8 87 ff ff ff       	call   80360f <_ZL9fd2sockidi>
  803688:	85 c0                	test   %eax,%eax
  80368a:	78 16                	js     8036a2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80368c:	8b 55 10             	mov    0x10(%ebp),%edx
  80368f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803693:	8b 55 0c             	mov    0xc(%ebp),%edx
  803696:	89 54 24 04          	mov    %edx,0x4(%esp)
  80369a:	89 04 24             	mov    %eax,(%esp)
  80369d:	e8 34 01 00 00       	call   8037d6 <_Z10nsipc_bindiP8sockaddrj>
}
  8036a2:	c9                   	leave  
  8036a3:	c3                   	ret    

008036a4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  8036a4:	55                   	push   %ebp
  8036a5:	89 e5                	mov    %esp,%ebp
  8036a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	e8 5d ff ff ff       	call   80360f <_ZL9fd2sockidi>
  8036b2:	85 c0                	test   %eax,%eax
  8036b4:	78 0f                	js     8036c5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8036b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8036bd:	89 04 24             	mov    %eax,(%esp)
  8036c0:	e8 50 01 00 00       	call   803815 <_Z14nsipc_shutdownii>
}
  8036c5:	c9                   	leave  
  8036c6:	c3                   	ret    

008036c7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036c7:	55                   	push   %ebp
  8036c8:	89 e5                	mov    %esp,%ebp
  8036ca:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	e8 3a ff ff ff       	call   80360f <_ZL9fd2sockidi>
  8036d5:	85 c0                	test   %eax,%eax
  8036d7:	78 16                	js     8036ef <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8036d9:	8b 55 10             	mov    0x10(%ebp),%edx
  8036dc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8036e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8036e7:	89 04 24             	mov    %eax,(%esp)
  8036ea:	e8 62 01 00 00       	call   803851 <_Z13nsipc_connectiPK8sockaddrj>
}
  8036ef:	c9                   	leave  
  8036f0:	c3                   	ret    

008036f1 <_Z6listenii>:

int
listen(int s, int backlog)
{
  8036f1:	55                   	push   %ebp
  8036f2:	89 e5                	mov    %esp,%ebp
  8036f4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fa:	e8 10 ff ff ff       	call   80360f <_ZL9fd2sockidi>
  8036ff:	85 c0                	test   %eax,%eax
  803701:	78 0f                	js     803712 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803703:	8b 55 0c             	mov    0xc(%ebp),%edx
  803706:	89 54 24 04          	mov    %edx,0x4(%esp)
  80370a:	89 04 24             	mov    %eax,(%esp)
  80370d:	e8 7e 01 00 00       	call   803890 <_Z12nsipc_listenii>
}
  803712:	c9                   	leave  
  803713:	c3                   	ret    

00803714 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803714:	55                   	push   %ebp
  803715:	89 e5                	mov    %esp,%ebp
  803717:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80371a:	8b 45 10             	mov    0x10(%ebp),%eax
  80371d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803721:	8b 45 0c             	mov    0xc(%ebp),%eax
  803724:	89 44 24 04          	mov    %eax,0x4(%esp)
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	89 04 24             	mov    %eax,(%esp)
  80372e:	e8 72 02 00 00       	call   8039a5 <_Z12nsipc_socketiii>
  803733:	85 c0                	test   %eax,%eax
  803735:	78 05                	js     80373c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803737:	e8 5b fe ff ff       	call   803597 <_ZL12alloc_sockfdi>
}
  80373c:	c9                   	leave  
  80373d:	8d 76 00             	lea    0x0(%esi),%esi
  803740:	c3                   	ret    
  803741:	00 00                	add    %al,(%eax)
	...

00803744 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803744:	55                   	push   %ebp
  803745:	89 e5                	mov    %esp,%ebp
  803747:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80374a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803751:	00 
  803752:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803759:	00 
  80375a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80375e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803765:	e8 f5 05 00 00       	call   803d5f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  80376a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803771:	00 
  803772:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803779:	00 
  80377a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803781:	e8 4a 05 00 00       	call   803cd0 <_Z8ipc_recvPiPvS_>
}
  803786:	c9                   	leave  
  803787:	c3                   	ret    

00803788 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803788:	55                   	push   %ebp
  803789:	89 e5                	mov    %esp,%ebp
  80378b:	53                   	push   %ebx
  80378c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803797:	b8 01 00 00 00       	mov    $0x1,%eax
  80379c:	e8 a3 ff ff ff       	call   803744 <_ZL5nsipcj>
  8037a1:	89 c3                	mov    %eax,%ebx
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	78 27                	js     8037ce <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  8037a7:	a1 10 70 80 00       	mov    0x807010,%eax
  8037ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037b0:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8037b7:	00 
  8037b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037bb:	89 04 24             	mov    %eax,(%esp)
  8037be:	e8 d9 d3 ff ff       	call   800b9c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  8037c3:	8b 15 10 70 80 00    	mov    0x807010,%edx
  8037c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8037cc:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8037ce:	89 d8                	mov    %ebx,%eax
  8037d0:	83 c4 14             	add    $0x14,%esp
  8037d3:	5b                   	pop    %ebx
  8037d4:	5d                   	pop    %ebp
  8037d5:	c3                   	ret    

008037d6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037d6:	55                   	push   %ebp
  8037d7:	89 e5                	mov    %esp,%ebp
  8037d9:	53                   	push   %ebx
  8037da:	83 ec 14             	sub    $0x14,%esp
  8037dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8037e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e3:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8037e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037f3:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8037fa:	e8 9d d3 ff ff       	call   800b9c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8037ff:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803805:	b8 02 00 00 00       	mov    $0x2,%eax
  80380a:	e8 35 ff ff ff       	call   803744 <_ZL5nsipcj>
}
  80380f:	83 c4 14             	add    $0x14,%esp
  803812:	5b                   	pop    %ebx
  803813:	5d                   	pop    %ebp
  803814:	c3                   	ret    

00803815 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803815:	55                   	push   %ebp
  803816:	89 e5                	mov    %esp,%ebp
  803818:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803823:	8b 45 0c             	mov    0xc(%ebp),%eax
  803826:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80382b:	b8 03 00 00 00       	mov    $0x3,%eax
  803830:	e8 0f ff ff ff       	call   803744 <_ZL5nsipcj>
}
  803835:	c9                   	leave  
  803836:	c3                   	ret    

00803837 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803837:	55                   	push   %ebp
  803838:	89 e5                	mov    %esp,%ebp
  80383a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80383d:	8b 45 08             	mov    0x8(%ebp),%eax
  803840:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803845:	b8 04 00 00 00       	mov    $0x4,%eax
  80384a:	e8 f5 fe ff ff       	call   803744 <_ZL5nsipcj>
}
  80384f:	c9                   	leave  
  803850:	c3                   	ret    

00803851 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803851:	55                   	push   %ebp
  803852:	89 e5                	mov    %esp,%ebp
  803854:	53                   	push   %ebx
  803855:	83 ec 14             	sub    $0x14,%esp
  803858:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80385b:	8b 45 08             	mov    0x8(%ebp),%eax
  80385e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803863:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80386a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80386e:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803875:	e8 22 d3 ff ff       	call   800b9c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80387a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803880:	b8 05 00 00 00       	mov    $0x5,%eax
  803885:	e8 ba fe ff ff       	call   803744 <_ZL5nsipcj>
}
  80388a:	83 c4 14             	add    $0x14,%esp
  80388d:	5b                   	pop    %ebx
  80388e:	5d                   	pop    %ebp
  80388f:	c3                   	ret    

00803890 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803890:	55                   	push   %ebp
  803891:	89 e5                	mov    %esp,%ebp
  803893:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80389e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8038a6:	b8 06 00 00 00       	mov    $0x6,%eax
  8038ab:	e8 94 fe ff ff       	call   803744 <_ZL5nsipcj>
}
  8038b0:	c9                   	leave  
  8038b1:	c3                   	ret    

008038b2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8038b2:	55                   	push   %ebp
  8038b3:	89 e5                	mov    %esp,%ebp
  8038b5:	56                   	push   %esi
  8038b6:	53                   	push   %ebx
  8038b7:	83 ec 10             	sub    $0x10,%esp
  8038ba:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8038c5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8038cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8038ce:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8038d3:	b8 07 00 00 00       	mov    $0x7,%eax
  8038d8:	e8 67 fe ff ff       	call   803744 <_ZL5nsipcj>
  8038dd:	89 c3                	mov    %eax,%ebx
  8038df:	85 c0                	test   %eax,%eax
  8038e1:	78 46                	js     803929 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  8038e3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8038e8:	7f 04                	jg     8038ee <_Z10nsipc_recviPvij+0x3c>
  8038ea:	39 f0                	cmp    %esi,%eax
  8038ec:	7e 24                	jle    803912 <_Z10nsipc_recviPvij+0x60>
  8038ee:	c7 44 24 0c 5f 4b 80 	movl   $0x804b5f,0xc(%esp)
  8038f5:	00 
  8038f6:	c7 44 24 08 cc 44 80 	movl   $0x8044cc,0x8(%esp)
  8038fd:	00 
  8038fe:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803905:	00 
  803906:	c7 04 24 74 4b 80 00 	movl   $0x804b74,(%esp)
  80390d:	e8 b6 c9 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803912:	89 44 24 08          	mov    %eax,0x8(%esp)
  803916:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80391d:	00 
  80391e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803921:	89 04 24             	mov    %eax,(%esp)
  803924:	e8 73 d2 ff ff       	call   800b9c <memmove>
	}

	return r;
}
  803929:	89 d8                	mov    %ebx,%eax
  80392b:	83 c4 10             	add    $0x10,%esp
  80392e:	5b                   	pop    %ebx
  80392f:	5e                   	pop    %esi
  803930:	5d                   	pop    %ebp
  803931:	c3                   	ret    

00803932 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803932:	55                   	push   %ebp
  803933:	89 e5                	mov    %esp,%ebp
  803935:	53                   	push   %ebx
  803936:	83 ec 14             	sub    $0x14,%esp
  803939:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80393c:	8b 45 08             	mov    0x8(%ebp),%eax
  80393f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803944:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80394a:	7e 24                	jle    803970 <_Z10nsipc_sendiPKvij+0x3e>
  80394c:	c7 44 24 0c 80 4b 80 	movl   $0x804b80,0xc(%esp)
  803953:	00 
  803954:	c7 44 24 08 cc 44 80 	movl   $0x8044cc,0x8(%esp)
  80395b:	00 
  80395c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803963:	00 
  803964:	c7 04 24 74 4b 80 00 	movl   $0x804b74,(%esp)
  80396b:	e8 58 c9 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803970:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803974:	8b 45 0c             	mov    0xc(%ebp),%eax
  803977:	89 44 24 04          	mov    %eax,0x4(%esp)
  80397b:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803982:	e8 15 d2 ff ff       	call   800b9c <memmove>
	nsipcbuf.send.req_size = size;
  803987:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80398d:	8b 45 14             	mov    0x14(%ebp),%eax
  803990:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803995:	b8 08 00 00 00       	mov    $0x8,%eax
  80399a:	e8 a5 fd ff ff       	call   803744 <_ZL5nsipcj>
}
  80399f:	83 c4 14             	add    $0x14,%esp
  8039a2:	5b                   	pop    %ebx
  8039a3:	5d                   	pop    %ebp
  8039a4:	c3                   	ret    

008039a5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039a5:	55                   	push   %ebp
  8039a6:	89 e5                	mov    %esp,%ebp
  8039a8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8039ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ae:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8039b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8039bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8039be:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8039c3:	b8 09 00 00 00       	mov    $0x9,%eax
  8039c8:	e8 77 fd ff ff       	call   803744 <_ZL5nsipcj>
}
  8039cd:	c9                   	leave  
  8039ce:	c3                   	ret    
	...

008039d0 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8039d0:	55                   	push   %ebp
  8039d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8039d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d8:	5d                   	pop    %ebp
  8039d9:	c3                   	ret    

008039da <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8039da:	55                   	push   %ebp
  8039db:	89 e5                	mov    %esp,%ebp
  8039dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8039e0:	c7 44 24 04 8c 4b 80 	movl   $0x804b8c,0x4(%esp)
  8039e7:	00 
  8039e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039eb:	89 04 24             	mov    %eax,(%esp)
  8039ee:	e8 07 d0 ff ff       	call   8009fa <_Z6strcpyPcPKc>
	return 0;
}
  8039f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f8:	c9                   	leave  
  8039f9:	c3                   	ret    

008039fa <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039fa:	55                   	push   %ebp
  8039fb:	89 e5                	mov    %esp,%ebp
  8039fd:	57                   	push   %edi
  8039fe:	56                   	push   %esi
  8039ff:	53                   	push   %ebx
  803a00:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a06:	bb 00 00 00 00       	mov    $0x0,%ebx
  803a0b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803a0f:	74 3e                	je     803a4f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803a11:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803a17:	8b 75 10             	mov    0x10(%ebp),%esi
  803a1a:	29 de                	sub    %ebx,%esi
  803a1c:	83 fe 7f             	cmp    $0x7f,%esi
  803a1f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803a24:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803a27:	89 74 24 08          	mov    %esi,0x8(%esp)
  803a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a2e:	01 d8                	add    %ebx,%eax
  803a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a34:	89 3c 24             	mov    %edi,(%esp)
  803a37:	e8 60 d1 ff ff       	call   800b9c <memmove>
		sys_cputs(buf, m);
  803a3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803a40:	89 3c 24             	mov    %edi,(%esp)
  803a43:	e8 6c d3 ff ff       	call   800db4 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a48:	01 f3                	add    %esi,%ebx
  803a4a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803a4d:	77 c8                	ja     803a17 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803a4f:	89 d8                	mov    %ebx,%eax
  803a51:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803a57:	5b                   	pop    %ebx
  803a58:	5e                   	pop    %esi
  803a59:	5f                   	pop    %edi
  803a5a:	5d                   	pop    %ebp
  803a5b:	c3                   	ret    

00803a5c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a5c:	55                   	push   %ebp
  803a5d:	89 e5                	mov    %esp,%ebp
  803a5f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803a62:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803a67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803a6b:	75 07                	jne    803a74 <_ZL12devcons_readP2FdPvj+0x18>
  803a6d:	eb 2a                	jmp    803a99 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803a6f:	e8 38 d4 ff ff       	call   800eac <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803a74:	e8 6e d3 ff ff       	call   800de7 <_Z9sys_cgetcv>
  803a79:	85 c0                	test   %eax,%eax
  803a7b:	74 f2                	je     803a6f <_ZL12devcons_readP2FdPvj+0x13>
  803a7d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803a7f:	85 c0                	test   %eax,%eax
  803a81:	78 16                	js     803a99 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803a83:	83 f8 04             	cmp    $0x4,%eax
  803a86:	74 0c                	je     803a94 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a8b:	88 10                	mov    %dl,(%eax)
	return 1;
  803a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a92:	eb 05                	jmp    803a99 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803a94:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803a99:	c9                   	leave  
  803a9a:	c3                   	ret    

00803a9b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a9b:	55                   	push   %ebp
  803a9c:	89 e5                	mov    %esp,%ebp
  803a9e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803aa7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803aae:	00 
  803aaf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803ab2:	89 04 24             	mov    %eax,(%esp)
  803ab5:	e8 fa d2 ff ff       	call   800db4 <_Z9sys_cputsPKcj>
}
  803aba:	c9                   	leave  
  803abb:	c3                   	ret    

00803abc <_Z7getcharv>:

int
getchar(void)
{
  803abc:	55                   	push   %ebp
  803abd:	89 e5                	mov    %esp,%ebp
  803abf:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ac2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803ac9:	00 
  803aca:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ad1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ad8:	e8 71 dc ff ff       	call   80174e <_Z4readiPvj>
	if (r < 0)
  803add:	85 c0                	test   %eax,%eax
  803adf:	78 0f                	js     803af0 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803ae1:	85 c0                	test   %eax,%eax
  803ae3:	7e 06                	jle    803aeb <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803ae5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803ae9:	eb 05                	jmp    803af0 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803aeb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803af0:	c9                   	leave  
  803af1:	c3                   	ret    

00803af2 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803af2:	55                   	push   %ebp
  803af3:	89 e5                	mov    %esp,%ebp
  803af5:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803af8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803aff:	00 
  803b00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b07:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0a:	89 04 24             	mov    %eax,(%esp)
  803b0d:	e8 8f d8 ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  803b12:	85 c0                	test   %eax,%eax
  803b14:	78 11                	js     803b27 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b19:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803b1f:	39 10                	cmp    %edx,(%eax)
  803b21:	0f 94 c0             	sete   %al
  803b24:	0f b6 c0             	movzbl %al,%eax
}
  803b27:	c9                   	leave  
  803b28:	c3                   	ret    

00803b29 <_Z8openconsv>:

int
opencons(void)
{
  803b29:	55                   	push   %ebp
  803b2a:	89 e5                	mov    %esp,%ebp
  803b2c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803b2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803b32:	89 04 24             	mov    %eax,(%esp)
  803b35:	e8 1d d9 ff ff       	call   801457 <_Z14fd_find_unusedPP2Fd>
  803b3a:	85 c0                	test   %eax,%eax
  803b3c:	78 3c                	js     803b7a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b3e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803b45:	00 
  803b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b4d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b54:	e8 87 d3 ff ff       	call   800ee0 <_Z14sys_page_allociPvi>
  803b59:	85 c0                	test   %eax,%eax
  803b5b:	78 1d                	js     803b7a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803b5d:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b66:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803b72:	89 04 24             	mov    %eax,(%esp)
  803b75:	e8 7a d8 ff ff       	call   8013f4 <_Z6fd2numP2Fd>
}
  803b7a:	c9                   	leave  
  803b7b:	c3                   	ret    
  803b7c:	00 00                	add    %al,(%eax)
	...

00803b80 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803b80:	55                   	push   %ebp
  803b81:	89 e5                	mov    %esp,%ebp
  803b83:	56                   	push   %esi
  803b84:	53                   	push   %ebx
  803b85:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803b88:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803b8d:	8b 04 9d 00 80 80 00 	mov    0x808000(,%ebx,4),%eax
  803b94:	85 c0                	test   %eax,%eax
  803b96:	74 08                	je     803ba0 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803b98:	8d 55 08             	lea    0x8(%ebp),%edx
  803b9b:	89 14 24             	mov    %edx,(%esp)
  803b9e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803ba0:	83 eb 01             	sub    $0x1,%ebx
  803ba3:	83 fb ff             	cmp    $0xffffffff,%ebx
  803ba6:	75 e5                	jne    803b8d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803ba8:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803bab:	8b 75 08             	mov    0x8(%ebp),%esi
  803bae:	e8 c5 d2 ff ff       	call   800e78 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803bb3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803bb7:	89 74 24 10          	mov    %esi,0x10(%esp)
  803bbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bbf:	c7 44 24 08 98 4b 80 	movl   $0x804b98,0x8(%esp)
  803bc6:	00 
  803bc7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803bce:	00 
  803bcf:	c7 04 24 1c 4c 80 00 	movl   $0x804c1c,(%esp)
  803bd6:	e8 ed c6 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>

00803bdb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803bdb:	55                   	push   %ebp
  803bdc:	89 e5                	mov    %esp,%ebp
  803bde:	56                   	push   %esi
  803bdf:	53                   	push   %ebx
  803be0:	83 ec 10             	sub    $0x10,%esp
  803be3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803be6:	e8 8d d2 ff ff       	call   800e78 <_Z12sys_getenvidv>
  803beb:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803bed:	a1 00 60 80 00       	mov    0x806000,%eax
  803bf2:	8b 40 5c             	mov    0x5c(%eax),%eax
  803bf5:	85 c0                	test   %eax,%eax
  803bf7:	75 4c                	jne    803c45 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803bf9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803c00:	00 
  803c01:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803c08:	ee 
  803c09:	89 34 24             	mov    %esi,(%esp)
  803c0c:	e8 cf d2 ff ff       	call   800ee0 <_Z14sys_page_allociPvi>
  803c11:	85 c0                	test   %eax,%eax
  803c13:	74 20                	je     803c35 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803c15:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803c19:	c7 44 24 08 d0 4b 80 	movl   $0x804bd0,0x8(%esp)
  803c20:	00 
  803c21:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803c28:	00 
  803c29:	c7 04 24 1c 4c 80 00 	movl   $0x804c1c,(%esp)
  803c30:	e8 93 c6 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803c35:	c7 44 24 04 80 3b 80 	movl   $0x803b80,0x4(%esp)
  803c3c:	00 
  803c3d:	89 34 24             	mov    %esi,(%esp)
  803c40:	e8 d0 d4 ff ff       	call   801115 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803c45:	a1 00 80 80 00       	mov    0x808000,%eax
  803c4a:	39 d8                	cmp    %ebx,%eax
  803c4c:	74 1a                	je     803c68 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803c4e:	85 c0                	test   %eax,%eax
  803c50:	74 20                	je     803c72 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803c52:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803c57:	8b 14 85 00 80 80 00 	mov    0x808000(,%eax,4),%edx
  803c5e:	39 da                	cmp    %ebx,%edx
  803c60:	74 15                	je     803c77 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803c62:	85 d2                	test   %edx,%edx
  803c64:	75 1f                	jne    803c85 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  803c66:	eb 0f                	jmp    803c77 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803c68:	b8 00 00 00 00       	mov    $0x0,%eax
  803c6d:	8d 76 00             	lea    0x0(%esi),%esi
  803c70:	eb 05                	jmp    803c77 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803c72:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  803c77:	89 1c 85 00 80 80 00 	mov    %ebx,0x808000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  803c7e:	83 c4 10             	add    $0x10,%esp
  803c81:	5b                   	pop    %ebx
  803c82:	5e                   	pop    %esi
  803c83:	5d                   	pop    %ebp
  803c84:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803c85:	83 c0 01             	add    $0x1,%eax
  803c88:	83 f8 08             	cmp    $0x8,%eax
  803c8b:	75 ca                	jne    803c57 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  803c8d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803c91:	c7 44 24 08 f4 4b 80 	movl   $0x804bf4,0x8(%esp)
  803c98:	00 
  803c99:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803ca0:	00 
  803ca1:	c7 04 24 1c 4c 80 00 	movl   $0x804c1c,(%esp)
  803ca8:	e8 1b c6 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
  803cad:	00 00                	add    %al,(%eax)
	...

00803cb0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  803cb0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  803cb3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  803cb4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  803cb7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  803cbb:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  803cbf:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  803cc2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  803cc4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  803cc8:	61                   	popa   
    popf
  803cc9:	9d                   	popf   
    popl %esp
  803cca:	5c                   	pop    %esp
    ret
  803ccb:	c3                   	ret    

00803ccc <spin>:

spin:	jmp spin
  803ccc:	eb fe                	jmp    803ccc <spin>
	...

00803cd0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803cd0:	55                   	push   %ebp
  803cd1:	89 e5                	mov    %esp,%ebp
  803cd3:	56                   	push   %esi
  803cd4:	53                   	push   %ebx
  803cd5:	83 ec 10             	sub    $0x10,%esp
  803cd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cde:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  803ce1:	85 c0                	test   %eax,%eax
  803ce3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803ce8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  803ceb:	89 04 24             	mov    %eax,(%esp)
  803cee:	e8 b8 d4 ff ff       	call   8011ab <_Z12sys_ipc_recvPv>
  803cf3:	85 c0                	test   %eax,%eax
  803cf5:	79 16                	jns    803d0d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  803cf7:	85 db                	test   %ebx,%ebx
  803cf9:	74 06                	je     803d01 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  803cfb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  803d01:	85 f6                	test   %esi,%esi
  803d03:	74 53                	je     803d58 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  803d05:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803d0b:	eb 4b                	jmp    803d58 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  803d0d:	85 db                	test   %ebx,%ebx
  803d0f:	74 17                	je     803d28 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  803d11:	e8 62 d1 ff ff       	call   800e78 <_Z12sys_getenvidv>
  803d16:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d1b:	6b c0 78             	imul   $0x78,%eax,%eax
  803d1e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  803d23:	8b 40 60             	mov    0x60(%eax),%eax
  803d26:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  803d28:	85 f6                	test   %esi,%esi
  803d2a:	74 17                	je     803d43 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  803d2c:	e8 47 d1 ff ff       	call   800e78 <_Z12sys_getenvidv>
  803d31:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d36:	6b c0 78             	imul   $0x78,%eax,%eax
  803d39:	05 00 00 00 ef       	add    $0xef000000,%eax
  803d3e:	8b 40 70             	mov    0x70(%eax),%eax
  803d41:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  803d43:	e8 30 d1 ff ff       	call   800e78 <_Z12sys_getenvidv>
  803d48:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d4d:	6b c0 78             	imul   $0x78,%eax,%eax
  803d50:	05 08 00 00 ef       	add    $0xef000008,%eax
  803d55:	8b 40 60             	mov    0x60(%eax),%eax

}
  803d58:	83 c4 10             	add    $0x10,%esp
  803d5b:	5b                   	pop    %ebx
  803d5c:	5e                   	pop    %esi
  803d5d:	5d                   	pop    %ebp
  803d5e:	c3                   	ret    

00803d5f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d5f:	55                   	push   %ebp
  803d60:	89 e5                	mov    %esp,%ebp
  803d62:	57                   	push   %edi
  803d63:	56                   	push   %esi
  803d64:	53                   	push   %ebx
  803d65:	83 ec 1c             	sub    $0x1c,%esp
  803d68:	8b 75 08             	mov    0x8(%ebp),%esi
  803d6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803d6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  803d71:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  803d73:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803d78:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803d7b:	8b 45 14             	mov    0x14(%ebp),%eax
  803d7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d82:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d86:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803d8a:	89 34 24             	mov    %esi,(%esp)
  803d8d:	e8 e1 d3 ff ff       	call   801173 <_Z16sys_ipc_try_sendijPvi>
  803d92:	85 c0                	test   %eax,%eax
  803d94:	79 31                	jns    803dc7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  803d96:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803d99:	75 0c                	jne    803da7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  803d9b:	90                   	nop
  803d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803da0:	e8 07 d1 ff ff       	call   800eac <_Z9sys_yieldv>
  803da5:	eb d4                	jmp    803d7b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  803da7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dab:	c7 44 24 08 2a 4c 80 	movl   $0x804c2a,0x8(%esp)
  803db2:	00 
  803db3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  803dba:	00 
  803dbb:	c7 04 24 37 4c 80 00 	movl   $0x804c37,(%esp)
  803dc2:	e8 01 c5 ff ff       	call   8002c8 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  803dc7:	83 c4 1c             	add    $0x1c,%esp
  803dca:	5b                   	pop    %ebx
  803dcb:	5e                   	pop    %esi
  803dcc:	5f                   	pop    %edi
  803dcd:	5d                   	pop    %ebp
  803dce:	c3                   	ret    
	...

00803dd0 <__udivdi3>:
  803dd0:	55                   	push   %ebp
  803dd1:	89 e5                	mov    %esp,%ebp
  803dd3:	57                   	push   %edi
  803dd4:	56                   	push   %esi
  803dd5:	83 ec 20             	sub    $0x20,%esp
  803dd8:	8b 45 14             	mov    0x14(%ebp),%eax
  803ddb:	8b 75 08             	mov    0x8(%ebp),%esi
  803dde:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803de1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803de4:	85 c0                	test   %eax,%eax
  803de6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803de9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  803dec:	75 3a                	jne    803e28 <__udivdi3+0x58>
  803dee:	39 f9                	cmp    %edi,%ecx
  803df0:	77 66                	ja     803e58 <__udivdi3+0x88>
  803df2:	85 c9                	test   %ecx,%ecx
  803df4:	75 0b                	jne    803e01 <__udivdi3+0x31>
  803df6:	b8 01 00 00 00       	mov    $0x1,%eax
  803dfb:	31 d2                	xor    %edx,%edx
  803dfd:	f7 f1                	div    %ecx
  803dff:	89 c1                	mov    %eax,%ecx
  803e01:	89 f8                	mov    %edi,%eax
  803e03:	31 d2                	xor    %edx,%edx
  803e05:	f7 f1                	div    %ecx
  803e07:	89 c7                	mov    %eax,%edi
  803e09:	89 f0                	mov    %esi,%eax
  803e0b:	f7 f1                	div    %ecx
  803e0d:	89 fa                	mov    %edi,%edx
  803e0f:	89 c6                	mov    %eax,%esi
  803e11:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803e14:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e1d:	83 c4 20             	add    $0x20,%esp
  803e20:	5e                   	pop    %esi
  803e21:	5f                   	pop    %edi
  803e22:	5d                   	pop    %ebp
  803e23:	c3                   	ret    
  803e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803e28:	31 d2                	xor    %edx,%edx
  803e2a:	31 f6                	xor    %esi,%esi
  803e2c:	39 f8                	cmp    %edi,%eax
  803e2e:	77 e1                	ja     803e11 <__udivdi3+0x41>
  803e30:	0f bd d0             	bsr    %eax,%edx
  803e33:	83 f2 1f             	xor    $0x1f,%edx
  803e36:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803e39:	75 2d                	jne    803e68 <__udivdi3+0x98>
  803e3b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803e3e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  803e41:	76 06                	jbe    803e49 <__udivdi3+0x79>
  803e43:	39 f8                	cmp    %edi,%eax
  803e45:	89 f2                	mov    %esi,%edx
  803e47:	73 c8                	jae    803e11 <__udivdi3+0x41>
  803e49:	31 d2                	xor    %edx,%edx
  803e4b:	be 01 00 00 00       	mov    $0x1,%esi
  803e50:	eb bf                	jmp    803e11 <__udivdi3+0x41>
  803e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803e58:	89 f0                	mov    %esi,%eax
  803e5a:	89 fa                	mov    %edi,%edx
  803e5c:	f7 f1                	div    %ecx
  803e5e:	31 d2                	xor    %edx,%edx
  803e60:	89 c6                	mov    %eax,%esi
  803e62:	eb ad                	jmp    803e11 <__udivdi3+0x41>
  803e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803e68:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e6c:	89 c2                	mov    %eax,%edx
  803e6e:	b8 20 00 00 00       	mov    $0x20,%eax
  803e73:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803e76:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803e79:	d3 e2                	shl    %cl,%edx
  803e7b:	89 c1                	mov    %eax,%ecx
  803e7d:	d3 ee                	shr    %cl,%esi
  803e7f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e83:	09 d6                	or     %edx,%esi
  803e85:	89 fa                	mov    %edi,%edx
  803e87:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  803e8a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803e8d:	d3 e6                	shl    %cl,%esi
  803e8f:	89 c1                	mov    %eax,%ecx
  803e91:	d3 ea                	shr    %cl,%edx
  803e93:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e97:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803e9a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  803e9d:	d3 e7                	shl    %cl,%edi
  803e9f:	89 c1                	mov    %eax,%ecx
  803ea1:	d3 ee                	shr    %cl,%esi
  803ea3:	09 fe                	or     %edi,%esi
  803ea5:	89 f0                	mov    %esi,%eax
  803ea7:	f7 75 e4             	divl   -0x1c(%ebp)
  803eaa:	89 d7                	mov    %edx,%edi
  803eac:	89 c6                	mov    %eax,%esi
  803eae:	f7 65 f0             	mull   -0x10(%ebp)
  803eb1:	39 d7                	cmp    %edx,%edi
  803eb3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  803eb6:	72 12                	jb     803eca <__udivdi3+0xfa>
  803eb8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ebb:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803ebf:	d3 e2                	shl    %cl,%edx
  803ec1:	39 c2                	cmp    %eax,%edx
  803ec3:	73 08                	jae    803ecd <__udivdi3+0xfd>
  803ec5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  803ec8:	75 03                	jne    803ecd <__udivdi3+0xfd>
  803eca:	83 ee 01             	sub    $0x1,%esi
  803ecd:	31 d2                	xor    %edx,%edx
  803ecf:	e9 3d ff ff ff       	jmp    803e11 <__udivdi3+0x41>
	...

00803ee0 <__umoddi3>:
  803ee0:	55                   	push   %ebp
  803ee1:	89 e5                	mov    %esp,%ebp
  803ee3:	57                   	push   %edi
  803ee4:	56                   	push   %esi
  803ee5:	83 ec 20             	sub    $0x20,%esp
  803ee8:	8b 7d 14             	mov    0x14(%ebp),%edi
  803eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  803eee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803ef1:	8b 75 0c             	mov    0xc(%ebp),%esi
  803ef4:	85 ff                	test   %edi,%edi
  803ef6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803ef9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  803efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803eff:	89 f2                	mov    %esi,%edx
  803f01:	75 15                	jne    803f18 <__umoddi3+0x38>
  803f03:	39 f1                	cmp    %esi,%ecx
  803f05:	76 41                	jbe    803f48 <__umoddi3+0x68>
  803f07:	f7 f1                	div    %ecx
  803f09:	89 d0                	mov    %edx,%eax
  803f0b:	31 d2                	xor    %edx,%edx
  803f0d:	83 c4 20             	add    $0x20,%esp
  803f10:	5e                   	pop    %esi
  803f11:	5f                   	pop    %edi
  803f12:	5d                   	pop    %ebp
  803f13:	c3                   	ret    
  803f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803f18:	39 f7                	cmp    %esi,%edi
  803f1a:	77 4c                	ja     803f68 <__umoddi3+0x88>
  803f1c:	0f bd c7             	bsr    %edi,%eax
  803f1f:	83 f0 1f             	xor    $0x1f,%eax
  803f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803f25:	75 51                	jne    803f78 <__umoddi3+0x98>
  803f27:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  803f2a:	0f 87 e8 00 00 00    	ja     804018 <__umoddi3+0x138>
  803f30:	89 f2                	mov    %esi,%edx
  803f32:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803f35:	29 ce                	sub    %ecx,%esi
  803f37:	19 fa                	sbb    %edi,%edx
  803f39:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f3f:	83 c4 20             	add    $0x20,%esp
  803f42:	5e                   	pop    %esi
  803f43:	5f                   	pop    %edi
  803f44:	5d                   	pop    %ebp
  803f45:	c3                   	ret    
  803f46:	66 90                	xchg   %ax,%ax
  803f48:	85 c9                	test   %ecx,%ecx
  803f4a:	75 0b                	jne    803f57 <__umoddi3+0x77>
  803f4c:	b8 01 00 00 00       	mov    $0x1,%eax
  803f51:	31 d2                	xor    %edx,%edx
  803f53:	f7 f1                	div    %ecx
  803f55:	89 c1                	mov    %eax,%ecx
  803f57:	89 f0                	mov    %esi,%eax
  803f59:	31 d2                	xor    %edx,%edx
  803f5b:	f7 f1                	div    %ecx
  803f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f60:	eb a5                	jmp    803f07 <__umoddi3+0x27>
  803f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803f68:	89 f2                	mov    %esi,%edx
  803f6a:	83 c4 20             	add    $0x20,%esp
  803f6d:	5e                   	pop    %esi
  803f6e:	5f                   	pop    %edi
  803f6f:	5d                   	pop    %ebp
  803f70:	c3                   	ret    
  803f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f78:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f7c:	89 f2                	mov    %esi,%edx
  803f7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f81:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  803f88:	29 45 f0             	sub    %eax,-0x10(%ebp)
  803f8b:	d3 e7                	shl    %cl,%edi
  803f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f90:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803f94:	d3 e8                	shr    %cl,%eax
  803f96:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f9a:	09 f8                	or     %edi,%eax
  803f9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa2:	d3 e0                	shl    %cl,%eax
  803fa4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fae:	d3 ea                	shr    %cl,%edx
  803fb0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803fb4:	d3 e6                	shl    %cl,%esi
  803fb6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803fba:	d3 e8                	shr    %cl,%eax
  803fbc:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803fc0:	09 f0                	or     %esi,%eax
  803fc2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  803fc5:	f7 75 e4             	divl   -0x1c(%ebp)
  803fc8:	d3 e6                	shl    %cl,%esi
  803fca:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803fcd:	89 d6                	mov    %edx,%esi
  803fcf:	f7 65 f4             	mull   -0xc(%ebp)
  803fd2:	89 d7                	mov    %edx,%edi
  803fd4:	89 c2                	mov    %eax,%edx
  803fd6:	39 fe                	cmp    %edi,%esi
  803fd8:	89 f9                	mov    %edi,%ecx
  803fda:	72 30                	jb     80400c <__umoddi3+0x12c>
  803fdc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  803fdf:	72 27                	jb     804008 <__umoddi3+0x128>
  803fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe4:	29 d0                	sub    %edx,%eax
  803fe6:	19 ce                	sbb    %ecx,%esi
  803fe8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803fec:	89 f2                	mov    %esi,%edx
  803fee:	d3 e8                	shr    %cl,%eax
  803ff0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803ff4:	d3 e2                	shl    %cl,%edx
  803ff6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803ffa:	09 d0                	or     %edx,%eax
  803ffc:	89 f2                	mov    %esi,%edx
  803ffe:	d3 ea                	shr    %cl,%edx
  804000:	83 c4 20             	add    $0x20,%esp
  804003:	5e                   	pop    %esi
  804004:	5f                   	pop    %edi
  804005:	5d                   	pop    %ebp
  804006:	c3                   	ret    
  804007:	90                   	nop
  804008:	39 fe                	cmp    %edi,%esi
  80400a:	75 d5                	jne    803fe1 <__umoddi3+0x101>
  80400c:	89 f9                	mov    %edi,%ecx
  80400e:	89 c2                	mov    %eax,%edx
  804010:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804013:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804016:	eb c9                	jmp    803fe1 <__umoddi3+0x101>
  804018:	39 f7                	cmp    %esi,%edi
  80401a:	0f 82 10 ff ff ff    	jb     803f30 <__umoddi3+0x50>
  804020:	e9 17 ff ff ff       	jmp    803f3c <__umoddi3+0x5c>
