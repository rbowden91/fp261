
obj/user/testmigrate:     file format elf32-i386


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
  80002c:	e8 bb 00 00 00       	call   8000ec <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_ZL4facti>:
    exit();
}


static int fact(int n)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 04             	sub    $0x4,%esp
  80003b:	89 c3                	mov    %eax,%ebx
    if(n == 0)
  80003d:	85 c0                	test   %eax,%eax
  80003f:	75 0a                	jne    80004b <_ZL4facti+0x17>
        return migrate() + 1;
  800041:	e8 60 3e 00 00       	call   803ea6 <_Z7migratev>
  800046:	83 c0 01             	add    $0x1,%eax
  800049:	eb 0b                	jmp    800056 <_ZL4facti+0x22>
    return n * fact(n-1);
  80004b:	8d 40 ff             	lea    -0x1(%eax),%eax
  80004e:	e8 e1 ff ff ff       	call   800034 <_ZL4facti>
  800053:	0f af c3             	imul   %ebx,%eax
}
  800056:	83 c4 04             	add    $0x4,%esp
  800059:	5b                   	pop    %ebx
  80005a:	5d                   	pop    %ebp
  80005b:	c3                   	ret    

0080005c <_ZL15pgfault_handlerP10UTrapframe>:
#include <inc/lib.h>
#include <inc/migrate.h>

static void
pgfault_handler(UTrapframe *t)
{
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	83 ec 18             	sub    $0x18,%esp
    cprintf("Now we're in the upcall!\n");
  800062:	c7 04 24 e0 4a 80 00 	movl   $0x804ae0,(%esp)
  800069:	e8 b0 01 00 00       	call   80021e <_Z7cprintfPKcz>
    exit();
  80006e:	e8 e1 00 00 00       	call   800154 <_Z4exitv>
}
  800073:	c9                   	leave  
  800074:	c3                   	ret    

00800075 <_Z5umainiPPc>:
        return migrate() + 1;
    return n * fact(n-1);
}

void
umain(int argc, char **argv) {
  800075:	55                   	push   %ebp
  800076:	89 e5                	mov    %esp,%ebp
  800078:	83 ec 18             	sub    $0x18,%esp
    cprintf("starting in umain\n");
  80007b:	c7 04 24 fa 4a 80 00 	movl   $0x804afa,(%esp)
  800082:	e8 97 01 00 00       	call   80021e <_Z7cprintfPKcz>
    add_pgfault_handler(pgfault_handler);
  800087:	c7 04 24 5c 00 80 00 	movl   $0x80005c,(%esp)
  80008e:	e8 28 11 00 00       	call   8011bb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
    cprintf("%08x\n", thisenv->env_pgfault_upcall);
  800093:	a1 00 70 80 00       	mov    0x807000,%eax
  800098:	8b 40 5c             	mov    0x5c(%eax),%eax
  80009b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80009f:	c7 04 24 0d 4b 80 00 	movl   $0x804b0d,(%esp)
  8000a6:	e8 73 01 00 00       	call   80021e <_Z7cprintfPKcz>
    cprintf("%d fact\n", fact(11));
  8000ab:	b8 0b 00 00 00       	mov    $0xb,%eax
  8000b0:	e8 7f ff ff ff       	call   800034 <_ZL4facti>
  8000b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b9:	c7 04 24 13 4b 80 00 	movl   $0x804b13,(%esp)
  8000c0:	e8 59 01 00 00       	call   80021e <_Z7cprintfPKcz>

    cprintf("[%08x]: Hello from your migrated process!\n", thisenv->env_id);
  8000c5:	a1 00 70 80 00       	mov    0x807000,%eax
  8000ca:	8b 40 04             	mov    0x4(%eax),%eax
  8000cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d1:	c7 04 24 1c 4b 80 00 	movl   $0x804b1c,(%esp)
  8000d8:	e8 41 01 00 00       	call   80021e <_Z7cprintfPKcz>
    int *x = (int *)0xdeadbeef;
    *x = 3;
  8000dd:	c7 05 ef be ad de 03 	movl   $0x3,0xdeadbeef
  8000e4:	00 00 00 
}
  8000e7:	c9                   	leave  
  8000e8:	c3                   	ret    
  8000e9:	00 00                	add    %al,(%eax)
	...

008000ec <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	57                   	push   %edi
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	83 ec 1c             	sub    $0x1c,%esp
  8000f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000f8:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8000fb:	e8 b8 0b 00 00       	call   800cb8 <_Z12sys_getenvidv>
  800100:	25 ff 03 00 00       	and    $0x3ff,%eax
  800105:	6b c0 78             	imul   $0x78,%eax,%eax
  800108:	05 00 00 00 ef       	add    $0xef000000,%eax
  80010d:	a3 00 70 80 00       	mov    %eax,0x807000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800112:	85 ff                	test   %edi,%edi
  800114:	7e 07                	jle    80011d <libmain+0x31>
		binaryname = argv[0];
  800116:	8b 06                	mov    (%esi),%eax
  800118:	a3 00 60 80 00       	mov    %eax,0x806000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80011d:	b8 51 59 80 00       	mov    $0x805951,%eax
  800122:	3d 51 59 80 00       	cmp    $0x805951,%eax
  800127:	76 0f                	jbe    800138 <libmain+0x4c>
  800129:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80012b:	83 eb 04             	sub    $0x4,%ebx
  80012e:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800130:	81 fb 51 59 80 00    	cmp    $0x805951,%ebx
  800136:	77 f3                	ja     80012b <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800138:	89 74 24 04          	mov    %esi,0x4(%esp)
  80013c:	89 3c 24             	mov    %edi,(%esp)
  80013f:	e8 31 ff ff ff       	call   800075 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800144:	e8 0b 00 00 00       	call   800154 <_Z4exitv>
}
  800149:	83 c4 1c             	add    $0x1c,%esp
  80014c:	5b                   	pop    %ebx
  80014d:	5e                   	pop    %esi
  80014e:	5f                   	pop    %edi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    
  800151:	00 00                	add    %al,(%eax)
	...

00800154 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80015a:	e8 ef 13 00 00       	call   80154e <_Z9close_allv>
	sys_env_destroy(0);
  80015f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800166:	e8 f0 0a 00 00       	call   800c5b <_Z15sys_env_destroyi>
}
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    
  80016d:	00 00                	add    %al,(%eax)
	...

00800170 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 18             	sub    $0x18,%esp
  800176:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800179:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80017c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  80017f:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800181:	8b 03                	mov    (%ebx),%eax
  800183:	8b 55 08             	mov    0x8(%ebp),%edx
  800186:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80018a:	83 c0 01             	add    $0x1,%eax
  80018d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80018f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800194:	75 19                	jne    8001af <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  800196:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80019d:	00 
  80019e:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a1:	89 04 24             	mov    %eax,(%esp)
  8001a4:	e8 4b 0a 00 00       	call   800bf4 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8001a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001af:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001b3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001b6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001b9:	89 ec                	mov    %ebp,%esp
  8001bb:	5d                   	pop    %ebp
  8001bc:	c3                   	ret    

008001bd <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001c6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001cd:	00 00 00 
	b.cnt = 0;
  8001d0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d7:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8001da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f2:	c7 04 24 70 01 80 00 	movl   $0x800170,(%esp)
  8001f9:	e8 a9 01 00 00       	call   8003a7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  8001fe:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800204:	89 44 24 04          	mov    %eax,0x4(%esp)
  800208:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80020e:	89 04 24             	mov    %eax,(%esp)
  800211:	e8 de 09 00 00       	call   800bf4 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800216:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800224:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800227:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022b:	8b 45 08             	mov    0x8(%ebp),%eax
  80022e:	89 04 24             	mov    %eax,(%esp)
  800231:	e8 87 ff ff ff       	call   8001bd <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800236:	c9                   	leave  
  800237:	c3                   	ret    
	...

00800240 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 4c             	sub    $0x4c,%esp
  800249:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80024c:	89 d6                	mov    %edx,%esi
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800254:	8b 55 0c             	mov    0xc(%ebp),%edx
  800257:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80025a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80025d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800260:	b8 00 00 00 00       	mov    $0x0,%eax
  800265:	39 d0                	cmp    %edx,%eax
  800267:	72 11                	jb     80027a <_ZL8printnumPFviPvES_yjii+0x3a>
  800269:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80026c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80026f:	76 09                	jbe    80027a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800271:	83 eb 01             	sub    $0x1,%ebx
  800274:	85 db                	test   %ebx,%ebx
  800276:	7f 5d                	jg     8002d5 <_ZL8printnumPFviPvES_yjii+0x95>
  800278:	eb 6c                	jmp    8002e6 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80027e:	83 eb 01             	sub    $0x1,%ebx
  800281:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800285:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800288:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80028c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800290:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800294:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800297:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80029a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002a1:	00 
  8002a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002a5:	89 14 24             	mov    %edx,(%esp)
  8002a8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002af:	e8 bc 45 00 00       	call   804870 <__udivdi3>
  8002b4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002b7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002ba:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002be:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002c2:	89 04 24             	mov    %eax,(%esp)
  8002c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002c9:	89 f2                	mov    %esi,%edx
  8002cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ce:	e8 6d ff ff ff       	call   800240 <_ZL8printnumPFviPvES_yjii>
  8002d3:	eb 11                	jmp    8002e6 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002d9:	89 3c 24             	mov    %edi,(%esp)
  8002dc:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002df:	83 eb 01             	sub    $0x1,%ebx
  8002e2:	85 db                	test   %ebx,%ebx
  8002e4:	7f ef                	jg     8002d5 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ea:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002fc:	00 
  8002fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800300:	89 14 24             	mov    %edx,(%esp)
  800303:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800306:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80030a:	e8 71 46 00 00       	call   804980 <__umoddi3>
  80030f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800313:	0f be 80 51 4b 80 00 	movsbl 0x804b51(%eax),%eax
  80031a:	89 04 24             	mov    %eax,(%esp)
  80031d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800320:	83 c4 4c             	add    $0x4c,%esp
  800323:	5b                   	pop    %ebx
  800324:	5e                   	pop    %esi
  800325:	5f                   	pop    %edi
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    

00800328 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80032b:	83 fa 01             	cmp    $0x1,%edx
  80032e:	7e 0e                	jle    80033e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800330:	8b 10                	mov    (%eax),%edx
  800332:	8d 4a 08             	lea    0x8(%edx),%ecx
  800335:	89 08                	mov    %ecx,(%eax)
  800337:	8b 02                	mov    (%edx),%eax
  800339:	8b 52 04             	mov    0x4(%edx),%edx
  80033c:	eb 22                	jmp    800360 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80033e:	85 d2                	test   %edx,%edx
  800340:	74 10                	je     800352 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800342:	8b 10                	mov    (%eax),%edx
  800344:	8d 4a 04             	lea    0x4(%edx),%ecx
  800347:	89 08                	mov    %ecx,(%eax)
  800349:	8b 02                	mov    (%edx),%eax
  80034b:	ba 00 00 00 00       	mov    $0x0,%edx
  800350:	eb 0e                	jmp    800360 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800352:	8b 10                	mov    (%eax),%edx
  800354:	8d 4a 04             	lea    0x4(%edx),%ecx
  800357:	89 08                	mov    %ecx,(%eax)
  800359:	8b 02                	mov    (%edx),%eax
  80035b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800360:	5d                   	pop    %ebp
  800361:	c3                   	ret    

00800362 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800368:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80036c:	8b 10                	mov    (%eax),%edx
  80036e:	3b 50 04             	cmp    0x4(%eax),%edx
  800371:	73 0a                	jae    80037d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800373:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800376:	88 0a                	mov    %cl,(%edx)
  800378:	83 c2 01             	add    $0x1,%edx
  80037b:	89 10                	mov    %edx,(%eax)
}
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800385:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800388:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800393:	8b 45 0c             	mov    0xc(%ebp),%eax
  800396:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	89 04 24             	mov    %eax,(%esp)
  8003a0:	e8 02 00 00 00       	call   8003a7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8003a5:	c9                   	leave  
  8003a6:	c3                   	ret    

008003a7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	57                   	push   %edi
  8003ab:	56                   	push   %esi
  8003ac:	53                   	push   %ebx
  8003ad:	83 ec 3c             	sub    $0x3c,%esp
  8003b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003b3:	8b 55 10             	mov    0x10(%ebp),%edx
  8003b6:	0f b6 02             	movzbl (%edx),%eax
  8003b9:	89 d3                	mov    %edx,%ebx
  8003bb:	83 c3 01             	add    $0x1,%ebx
  8003be:	83 f8 25             	cmp    $0x25,%eax
  8003c1:	74 2b                	je     8003ee <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  8003c3:	85 c0                	test   %eax,%eax
  8003c5:	75 10                	jne    8003d7 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  8003c7:	e9 a5 03 00 00       	jmp    800771 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8003cc:	85 c0                	test   %eax,%eax
  8003ce:	66 90                	xchg   %ax,%ax
  8003d0:	75 08                	jne    8003da <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  8003d2:	e9 9a 03 00 00       	jmp    800771 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8003d7:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  8003da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003de:	89 04 24             	mov    %eax,(%esp)
  8003e1:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003e3:	0f b6 03             	movzbl (%ebx),%eax
  8003e6:	83 c3 01             	add    $0x1,%ebx
  8003e9:	83 f8 25             	cmp    $0x25,%eax
  8003ec:	75 de                	jne    8003cc <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8003ee:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  8003f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
  8003fe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800405:	b9 00 00 00 00       	mov    $0x0,%ecx
  80040a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80040d:	eb 2b                	jmp    80043a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800412:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800416:	eb 22                	jmp    80043a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80041b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80041f:	eb 19                	jmp    80043a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800421:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800424:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80042b:	eb 0d                	jmp    80043a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80042d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800430:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800433:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	0f b6 03             	movzbl (%ebx),%eax
  80043d:	0f b6 d0             	movzbl %al,%edx
  800440:	8d 73 01             	lea    0x1(%ebx),%esi
  800443:	89 75 10             	mov    %esi,0x10(%ebp)
  800446:	83 e8 23             	sub    $0x23,%eax
  800449:	3c 55                	cmp    $0x55,%al
  80044b:	0f 87 d8 02 00 00    	ja     800729 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800451:	0f b6 c0             	movzbl %al,%eax
  800454:	ff 24 85 e0 4c 80 00 	jmp    *0x804ce0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80045b:	83 ea 30             	sub    $0x30,%edx
  80045e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800461:	8b 55 10             	mov    0x10(%ebp),%edx
  800464:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800467:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80046d:	83 fa 09             	cmp    $0x9,%edx
  800470:	77 4e                	ja     8004c0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800472:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800475:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800478:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80047b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80047f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800482:	8d 50 d0             	lea    -0x30(%eax),%edx
  800485:	83 fa 09             	cmp    $0x9,%edx
  800488:	76 eb                	jbe    800475 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80048a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80048d:	eb 31                	jmp    8004c0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80048f:	8b 45 14             	mov    0x14(%ebp),%eax
  800492:	8d 50 04             	lea    0x4(%eax),%edx
  800495:	89 55 14             	mov    %edx,0x14(%ebp)
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004a0:	eb 1e                	jmp    8004c0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8004a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004a6:	0f 88 75 ff ff ff    	js     800421 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004af:	eb 89                	jmp    80043a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8004b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004b4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004bb:	e9 7a ff ff ff       	jmp    80043a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  8004c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004c4:	0f 89 70 ff ff ff    	jns    80043a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8004ca:	e9 5e ff ff ff       	jmp    80042d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004cf:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004d5:	e9 60 ff ff ff       	jmp    80043a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004e7:	8b 00                	mov    (%eax),%eax
  8004e9:	89 04 24             	mov    %eax,(%esp)
  8004ec:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004ef:	e9 bf fe ff ff       	jmp    8003b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	8d 50 04             	lea    0x4(%eax),%edx
  8004fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	89 c2                	mov    %eax,%edx
  800501:	c1 fa 1f             	sar    $0x1f,%edx
  800504:	31 d0                	xor    %edx,%eax
  800506:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800508:	83 f8 14             	cmp    $0x14,%eax
  80050b:	7f 0f                	jg     80051c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80050d:	8b 14 85 40 4e 80 00 	mov    0x804e40(,%eax,4),%edx
  800514:	85 d2                	test   %edx,%edx
  800516:	0f 85 35 02 00 00    	jne    800751 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80051c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800520:	c7 44 24 08 69 4b 80 	movl   $0x804b69,0x8(%esp)
  800527:	00 
  800528:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052c:	8b 75 08             	mov    0x8(%ebp),%esi
  80052f:	89 34 24             	mov    %esi,(%esp)
  800532:	e8 48 fe ff ff       	call   80037f <_Z8printfmtPFviPvES_PKcz>
  800537:	e9 77 fe ff ff       	jmp    8003b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80053c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800542:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800545:	8b 45 14             	mov    0x14(%ebp),%eax
  800548:	8d 50 04             	lea    0x4(%eax),%edx
  80054b:	89 55 14             	mov    %edx,0x14(%ebp)
  80054e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800550:	85 db                	test   %ebx,%ebx
  800552:	ba 62 4b 80 00       	mov    $0x804b62,%edx
  800557:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80055a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80055e:	7e 72                	jle    8005d2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800560:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800564:	74 6c                	je     8005d2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800566:	89 74 24 04          	mov    %esi,0x4(%esp)
  80056a:	89 1c 24             	mov    %ebx,(%esp)
  80056d:	e8 a9 02 00 00       	call   80081b <_Z7strnlenPKcj>
  800572:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800575:	29 c2                	sub    %eax,%edx
  800577:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80057a:	85 d2                	test   %edx,%edx
  80057c:	7e 54                	jle    8005d2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80057e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800582:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800585:	89 d3                	mov    %edx,%ebx
  800587:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80058a:	89 c6                	mov    %eax,%esi
  80058c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800590:	89 34 24             	mov    %esi,(%esp)
  800593:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	83 eb 01             	sub    $0x1,%ebx
  800599:	85 db                	test   %ebx,%ebx
  80059b:	7f ef                	jg     80058c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80059d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005a0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8005a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005aa:	eb 26                	jmp    8005d2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005ac:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005af:	83 fa 5e             	cmp    $0x5e,%edx
  8005b2:	76 10                	jbe    8005c4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  8005b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005bf:	ff 55 08             	call   *0x8(%ebp)
  8005c2:	eb 0a                	jmp    8005ce <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  8005c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c8:	89 04 24             	mov    %eax,(%esp)
  8005cb:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ce:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005d2:	0f be 03             	movsbl (%ebx),%eax
  8005d5:	83 c3 01             	add    $0x1,%ebx
  8005d8:	85 c0                	test   %eax,%eax
  8005da:	74 11                	je     8005ed <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  8005dc:	85 f6                	test   %esi,%esi
  8005de:	78 05                	js     8005e5 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  8005e0:	83 ee 01             	sub    $0x1,%esi
  8005e3:	78 0d                	js     8005f2 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005e9:	75 c1                	jne    8005ac <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  8005eb:	eb d7                	jmp    8005c4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f0:	eb 03                	jmp    8005f5 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  8005f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005f5:	85 c0                	test   %eax,%eax
  8005f7:	0f 8e b6 fd ff ff    	jle    8003b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8005fd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800600:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800603:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800607:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80060e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800610:	83 eb 01             	sub    $0x1,%ebx
  800613:	85 db                	test   %ebx,%ebx
  800615:	7f ec                	jg     800603 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800617:	e9 97 fd ff ff       	jmp    8003b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80061c:	83 f9 01             	cmp    $0x1,%ecx
  80061f:	90                   	nop
  800620:	7e 10                	jle    800632 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8d 50 08             	lea    0x8(%eax),%edx
  800628:	89 55 14             	mov    %edx,0x14(%ebp)
  80062b:	8b 18                	mov    (%eax),%ebx
  80062d:	8b 70 04             	mov    0x4(%eax),%esi
  800630:	eb 26                	jmp    800658 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800632:	85 c9                	test   %ecx,%ecx
  800634:	74 12                	je     800648 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8d 50 04             	lea    0x4(%eax),%edx
  80063c:	89 55 14             	mov    %edx,0x14(%ebp)
  80063f:	8b 18                	mov    (%eax),%ebx
  800641:	89 de                	mov    %ebx,%esi
  800643:	c1 fe 1f             	sar    $0x1f,%esi
  800646:	eb 10                	jmp    800658 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 50 04             	lea    0x4(%eax),%edx
  80064e:	89 55 14             	mov    %edx,0x14(%ebp)
  800651:	8b 18                	mov    (%eax),%ebx
  800653:	89 de                	mov    %ebx,%esi
  800655:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800658:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80065d:	85 f6                	test   %esi,%esi
  80065f:	0f 89 8c 00 00 00    	jns    8006f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800665:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800669:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800670:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800673:	f7 db                	neg    %ebx
  800675:	83 d6 00             	adc    $0x0,%esi
  800678:	f7 de                	neg    %esi
			}
			base = 10;
  80067a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067f:	eb 70                	jmp    8006f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800681:	89 ca                	mov    %ecx,%edx
  800683:	8d 45 14             	lea    0x14(%ebp),%eax
  800686:	e8 9d fc ff ff       	call   800328 <_ZL7getuintPPci>
  80068b:	89 c3                	mov    %eax,%ebx
  80068d:	89 d6                	mov    %edx,%esi
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800694:	eb 5b                	jmp    8006f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800696:	89 ca                	mov    %ecx,%edx
  800698:	8d 45 14             	lea    0x14(%ebp),%eax
  80069b:	e8 88 fc ff ff       	call   800328 <_ZL7getuintPPci>
  8006a0:	89 c3                	mov    %eax,%ebx
  8006a2:	89 d6                	mov    %edx,%esi
			base = 8;
  8006a4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006a9:	eb 46                	jmp    8006f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8006ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006af:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006b6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006bd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006c4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d0:	8b 18                	mov    (%eax),%ebx
  8006d2:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  8006d7:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8006dc:	eb 13                	jmp    8006f1 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006de:	89 ca                	mov    %ecx,%edx
  8006e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e3:	e8 40 fc ff ff       	call   800328 <_ZL7getuintPPci>
  8006e8:	89 c3                	mov    %eax,%ebx
  8006ea:	89 d6                	mov    %edx,%esi
			base = 16;
  8006ec:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006f1:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  8006f5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800700:	89 44 24 08          	mov    %eax,0x8(%esp)
  800704:	89 1c 24             	mov    %ebx,(%esp)
  800707:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070b:	89 fa                	mov    %edi,%edx
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	e8 2b fb ff ff       	call   800240 <_ZL8printnumPFviPvES_yjii>
			break;
  800715:	e9 99 fc ff ff       	jmp    8003b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80071a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071e:	89 14 24             	mov    %edx,(%esp)
  800721:	ff 55 08             	call   *0x8(%ebp)
			break;
  800724:	e9 8a fc ff ff       	jmp    8003b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800729:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800734:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800737:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80073a:	89 d8                	mov    %ebx,%eax
  80073c:	eb 02                	jmp    800740 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80073e:	89 d0                	mov    %edx,%eax
  800740:	8d 50 ff             	lea    -0x1(%eax),%edx
  800743:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800747:	75 f5                	jne    80073e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800749:	89 45 10             	mov    %eax,0x10(%ebp)
  80074c:	e9 62 fc ff ff       	jmp    8003b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800751:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800755:	c7 44 24 08 6e 4f 80 	movl   $0x804f6e,0x8(%esp)
  80075c:	00 
  80075d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800761:	8b 75 08             	mov    0x8(%ebp),%esi
  800764:	89 34 24             	mov    %esi,(%esp)
  800767:	e8 13 fc ff ff       	call   80037f <_Z8printfmtPFviPvES_PKcz>
  80076c:	e9 42 fc ff ff       	jmp    8003b3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800771:	83 c4 3c             	add    $0x3c,%esp
  800774:	5b                   	pop    %ebx
  800775:	5e                   	pop    %esi
  800776:	5f                   	pop    %edi
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	83 ec 28             	sub    $0x28,%esp
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800785:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80078c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80078f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800793:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800796:	85 c0                	test   %eax,%eax
  800798:	74 30                	je     8007ca <_Z9vsnprintfPciPKcS_+0x51>
  80079a:	85 d2                	test   %edx,%edx
  80079c:	7e 2c                	jle    8007ca <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b3:	c7 04 24 62 03 80 00 	movl   $0x800362,(%esp)
  8007ba:	e8 e8 fb ff ff       	call   8003a7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  8007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c8:	eb 05                	jmp    8007cf <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	89 04 24             	mov    %eax,(%esp)
  8007f2:	e8 82 ff ff ff       	call   800779 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  8007f7:	c9                   	leave  
  8007f8:	c3                   	ret    
  8007f9:	00 00                	add    %al,(%eax)
  8007fb:	00 00                	add    %al,(%eax)
  8007fd:	00 00                	add    %al,(%eax)
	...

00800800 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800806:	b8 00 00 00 00       	mov    $0x0,%eax
  80080b:	80 3a 00             	cmpb   $0x0,(%edx)
  80080e:	74 09                	je     800819 <_Z6strlenPKc+0x19>
		n++;
  800810:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800813:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800817:	75 f7                	jne    800810 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800821:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
  800829:	39 c2                	cmp    %eax,%edx
  80082b:	74 0b                	je     800838 <_Z7strnlenPKcj+0x1d>
  80082d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800831:	74 05                	je     800838 <_Z7strnlenPKcj+0x1d>
		n++;
  800833:	83 c0 01             	add    $0x1,%eax
  800836:	eb f1                	jmp    800829 <_Z7strnlenPKcj+0xe>
	return n;
}
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	53                   	push   %ebx
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800844:	ba 00 00 00 00       	mov    $0x0,%edx
  800849:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80084d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800850:	83 c2 01             	add    $0x1,%edx
  800853:	84 c9                	test   %cl,%cl
  800855:	75 f2                	jne    800849 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800857:	5b                   	pop    %ebx
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	56                   	push   %esi
  80085e:	53                   	push   %ebx
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 55 0c             	mov    0xc(%ebp),%edx
  800865:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800868:	85 f6                	test   %esi,%esi
  80086a:	74 18                	je     800884 <_Z7strncpyPcPKcj+0x2a>
  80086c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800871:	0f b6 1a             	movzbl (%edx),%ebx
  800874:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800877:	80 3a 01             	cmpb   $0x1,(%edx)
  80087a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  80087d:	83 c1 01             	add    $0x1,%ecx
  800880:	39 ce                	cmp    %ecx,%esi
  800882:	77 ed                	ja     800871 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800884:	5b                   	pop    %ebx
  800885:	5e                   	pop    %esi
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	56                   	push   %esi
  80088c:	53                   	push   %ebx
  80088d:	8b 75 08             	mov    0x8(%ebp),%esi
  800890:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800893:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800896:	89 f0                	mov    %esi,%eax
  800898:	85 d2                	test   %edx,%edx
  80089a:	74 17                	je     8008b3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  80089c:	83 ea 01             	sub    $0x1,%edx
  80089f:	74 18                	je     8008b9 <_Z7strlcpyPcPKcj+0x31>
  8008a1:	80 39 00             	cmpb   $0x0,(%ecx)
  8008a4:	74 17                	je     8008bd <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8008a6:	0f b6 19             	movzbl (%ecx),%ebx
  8008a9:	88 18                	mov    %bl,(%eax)
  8008ab:	83 c0 01             	add    $0x1,%eax
  8008ae:	83 c1 01             	add    $0x1,%ecx
  8008b1:	eb e9                	jmp    80089c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  8008b3:	29 f0                	sub    %esi,%eax
}
  8008b5:	5b                   	pop    %ebx
  8008b6:	5e                   	pop    %esi
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008b9:	89 c2                	mov    %eax,%edx
  8008bb:	eb 02                	jmp    8008bf <_Z7strlcpyPcPKcj+0x37>
  8008bd:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008bf:	c6 02 00             	movb   $0x0,(%edx)
  8008c2:	eb ef                	jmp    8008b3 <_Z7strlcpyPcPKcj+0x2b>

008008c4 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008cd:	0f b6 01             	movzbl (%ecx),%eax
  8008d0:	84 c0                	test   %al,%al
  8008d2:	74 0c                	je     8008e0 <_Z6strcmpPKcS0_+0x1c>
  8008d4:	3a 02                	cmp    (%edx),%al
  8008d6:	75 08                	jne    8008e0 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  8008d8:	83 c1 01             	add    $0x1,%ecx
  8008db:	83 c2 01             	add    $0x1,%edx
  8008de:	eb ed                	jmp    8008cd <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  8008e0:	0f b6 c0             	movzbl %al,%eax
  8008e3:	0f b6 12             	movzbl (%edx),%edx
  8008e6:	29 d0                	sub    %edx,%eax
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	53                   	push   %ebx
  8008ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008f4:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  8008f7:	85 d2                	test   %edx,%edx
  8008f9:	74 16                	je     800911 <_Z7strncmpPKcS0_j+0x27>
  8008fb:	0f b6 01             	movzbl (%ecx),%eax
  8008fe:	84 c0                	test   %al,%al
  800900:	74 17                	je     800919 <_Z7strncmpPKcS0_j+0x2f>
  800902:	3a 03                	cmp    (%ebx),%al
  800904:	75 13                	jne    800919 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800906:	83 ea 01             	sub    $0x1,%edx
  800909:	83 c1 01             	add    $0x1,%ecx
  80090c:	83 c3 01             	add    $0x1,%ebx
  80090f:	eb e6                	jmp    8008f7 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800911:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800916:	5b                   	pop    %ebx
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800919:	0f b6 01             	movzbl (%ecx),%eax
  80091c:	0f b6 13             	movzbl (%ebx),%edx
  80091f:	29 d0                	sub    %edx,%eax
  800921:	eb f3                	jmp    800916 <_Z7strncmpPKcS0_j+0x2c>

00800923 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092d:	0f b6 10             	movzbl (%eax),%edx
  800930:	84 d2                	test   %dl,%dl
  800932:	74 1f                	je     800953 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800934:	38 ca                	cmp    %cl,%dl
  800936:	75 0a                	jne    800942 <_Z6strchrPKcc+0x1f>
  800938:	eb 1e                	jmp    800958 <_Z6strchrPKcc+0x35>
  80093a:	38 ca                	cmp    %cl,%dl
  80093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800940:	74 16                	je     800958 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800942:	83 c0 01             	add    $0x1,%eax
  800945:	0f b6 10             	movzbl (%eax),%edx
  800948:	84 d2                	test   %dl,%dl
  80094a:	75 ee                	jne    80093a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80094c:	b8 00 00 00 00       	mov    $0x0,%eax
  800951:	eb 05                	jmp    800958 <_Z6strchrPKcc+0x35>
  800953:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800964:	0f b6 10             	movzbl (%eax),%edx
  800967:	84 d2                	test   %dl,%dl
  800969:	74 14                	je     80097f <_Z7strfindPKcc+0x25>
		if (*s == c)
  80096b:	38 ca                	cmp    %cl,%dl
  80096d:	75 06                	jne    800975 <_Z7strfindPKcc+0x1b>
  80096f:	eb 0e                	jmp    80097f <_Z7strfindPKcc+0x25>
  800971:	38 ca                	cmp    %cl,%dl
  800973:	74 0a                	je     80097f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800975:	83 c0 01             	add    $0x1,%eax
  800978:	0f b6 10             	movzbl (%eax),%edx
  80097b:	84 d2                	test   %dl,%dl
  80097d:	75 f2                	jne    800971 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	89 1c 24             	mov    %ebx,(%esp)
  80098a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80098e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800992:	8b 7d 08             	mov    0x8(%ebp),%edi
  800995:	8b 45 0c             	mov    0xc(%ebp),%eax
  800998:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  80099b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a1:	75 25                	jne    8009c8 <memset+0x47>
  8009a3:	f6 c1 03             	test   $0x3,%cl
  8009a6:	75 20                	jne    8009c8 <memset+0x47>
		c &= 0xFF;
  8009a8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ab:	89 d3                	mov    %edx,%ebx
  8009ad:	c1 e3 08             	shl    $0x8,%ebx
  8009b0:	89 d6                	mov    %edx,%esi
  8009b2:	c1 e6 18             	shl    $0x18,%esi
  8009b5:	89 d0                	mov    %edx,%eax
  8009b7:	c1 e0 10             	shl    $0x10,%eax
  8009ba:	09 f0                	or     %esi,%eax
  8009bc:	09 d0                	or     %edx,%eax
  8009be:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  8009c0:	c1 e9 02             	shr    $0x2,%ecx
  8009c3:	fc                   	cld    
  8009c4:	f3 ab                	rep stos %eax,%es:(%edi)
  8009c6:	eb 03                	jmp    8009cb <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  8009c8:	fc                   	cld    
  8009c9:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  8009cb:	89 f8                	mov    %edi,%eax
  8009cd:	8b 1c 24             	mov    (%esp),%ebx
  8009d0:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009d4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009d8:	89 ec                	mov    %ebp,%esp
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	89 34 24             	mov    %esi,(%esp)
  8009e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  8009f2:	39 c6                	cmp    %eax,%esi
  8009f4:	73 36                	jae    800a2c <memmove+0x50>
  8009f6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f9:	39 d0                	cmp    %edx,%eax
  8009fb:	73 2f                	jae    800a2c <memmove+0x50>
		s += n;
		d += n;
  8009fd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a00:	f6 c2 03             	test   $0x3,%dl
  800a03:	75 1b                	jne    800a20 <memmove+0x44>
  800a05:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0b:	75 13                	jne    800a20 <memmove+0x44>
  800a0d:	f6 c1 03             	test   $0x3,%cl
  800a10:	75 0e                	jne    800a20 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a12:	83 ef 04             	sub    $0x4,%edi
  800a15:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a18:	c1 e9 02             	shr    $0x2,%ecx
  800a1b:	fd                   	std    
  800a1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1e:	eb 09                	jmp    800a29 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a20:	83 ef 01             	sub    $0x1,%edi
  800a23:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a26:	fd                   	std    
  800a27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a29:	fc                   	cld    
  800a2a:	eb 20                	jmp    800a4c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a2c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a32:	75 13                	jne    800a47 <memmove+0x6b>
  800a34:	a8 03                	test   $0x3,%al
  800a36:	75 0f                	jne    800a47 <memmove+0x6b>
  800a38:	f6 c1 03             	test   $0x3,%cl
  800a3b:	75 0a                	jne    800a47 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3d:	c1 e9 02             	shr    $0x2,%ecx
  800a40:	89 c7                	mov    %eax,%edi
  800a42:	fc                   	cld    
  800a43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a45:	eb 05                	jmp    800a4c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800a47:	89 c7                	mov    %eax,%edi
  800a49:	fc                   	cld    
  800a4a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800a4c:	8b 34 24             	mov    (%esp),%esi
  800a4f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a53:	89 ec                	mov    %ebp,%esp
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	83 ec 08             	sub    $0x8,%esp
  800a5d:	89 34 24             	mov    %esi,(%esp)
  800a60:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a6d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a73:	75 13                	jne    800a88 <memcpy+0x31>
  800a75:	a8 03                	test   $0x3,%al
  800a77:	75 0f                	jne    800a88 <memcpy+0x31>
  800a79:	f6 c1 03             	test   $0x3,%cl
  800a7c:	75 0a                	jne    800a88 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a7e:	c1 e9 02             	shr    $0x2,%ecx
  800a81:	89 c7                	mov    %eax,%edi
  800a83:	fc                   	cld    
  800a84:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a86:	eb 05                	jmp    800a8d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800a88:	89 c7                	mov    %eax,%edi
  800a8a:	fc                   	cld    
  800a8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800a8d:	8b 34 24             	mov    (%esp),%esi
  800a90:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a94:	89 ec                	mov    %ebp,%esp
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	57                   	push   %edi
  800a9c:	56                   	push   %esi
  800a9d:	53                   	push   %ebx
  800a9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800aa1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800aac:	85 ff                	test   %edi,%edi
  800aae:	74 38                	je     800ae8 <memcmp+0x50>
		if (*s1 != *s2)
  800ab0:	0f b6 03             	movzbl (%ebx),%eax
  800ab3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800ab6:	83 ef 01             	sub    $0x1,%edi
  800ab9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800abe:	38 c8                	cmp    %cl,%al
  800ac0:	74 1d                	je     800adf <memcmp+0x47>
  800ac2:	eb 11                	jmp    800ad5 <memcmp+0x3d>
  800ac4:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800ac9:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800ace:	83 c2 01             	add    $0x1,%edx
  800ad1:	38 c8                	cmp    %cl,%al
  800ad3:	74 0a                	je     800adf <memcmp+0x47>
			return *s1 - *s2;
  800ad5:	0f b6 c0             	movzbl %al,%eax
  800ad8:	0f b6 c9             	movzbl %cl,%ecx
  800adb:	29 c8                	sub    %ecx,%eax
  800add:	eb 09                	jmp    800ae8 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800adf:	39 fa                	cmp    %edi,%edx
  800ae1:	75 e1                	jne    800ac4 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800ae3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5f                   	pop    %edi
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	53                   	push   %ebx
  800af1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800af4:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800af6:	89 da                	mov    %ebx,%edx
  800af8:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800afb:	39 d3                	cmp    %edx,%ebx
  800afd:	73 15                	jae    800b14 <memfind+0x27>
		if (*s == (unsigned char) c)
  800aff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b03:	38 0b                	cmp    %cl,(%ebx)
  800b05:	75 06                	jne    800b0d <memfind+0x20>
  800b07:	eb 0b                	jmp    800b14 <memfind+0x27>
  800b09:	38 08                	cmp    %cl,(%eax)
  800b0b:	74 07                	je     800b14 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800b0d:	83 c0 01             	add    $0x1,%eax
  800b10:	39 c2                	cmp    %eax,%edx
  800b12:	77 f5                	ja     800b09 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b14:	5b                   	pop    %ebx
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	57                   	push   %edi
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b23:	0f b6 02             	movzbl (%edx),%eax
  800b26:	3c 20                	cmp    $0x20,%al
  800b28:	74 04                	je     800b2e <_Z6strtolPKcPPci+0x17>
  800b2a:	3c 09                	cmp    $0x9,%al
  800b2c:	75 0e                	jne    800b3c <_Z6strtolPKcPPci+0x25>
		s++;
  800b2e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b31:	0f b6 02             	movzbl (%edx),%eax
  800b34:	3c 20                	cmp    $0x20,%al
  800b36:	74 f6                	je     800b2e <_Z6strtolPKcPPci+0x17>
  800b38:	3c 09                	cmp    $0x9,%al
  800b3a:	74 f2                	je     800b2e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b3c:	3c 2b                	cmp    $0x2b,%al
  800b3e:	75 0a                	jne    800b4a <_Z6strtolPKcPPci+0x33>
		s++;
  800b40:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b43:	bf 00 00 00 00       	mov    $0x0,%edi
  800b48:	eb 10                	jmp    800b5a <_Z6strtolPKcPPci+0x43>
  800b4a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b4f:	3c 2d                	cmp    $0x2d,%al
  800b51:	75 07                	jne    800b5a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800b53:	83 c2 01             	add    $0x1,%edx
  800b56:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b5a:	85 db                	test   %ebx,%ebx
  800b5c:	0f 94 c0             	sete   %al
  800b5f:	74 05                	je     800b66 <_Z6strtolPKcPPci+0x4f>
  800b61:	83 fb 10             	cmp    $0x10,%ebx
  800b64:	75 15                	jne    800b7b <_Z6strtolPKcPPci+0x64>
  800b66:	80 3a 30             	cmpb   $0x30,(%edx)
  800b69:	75 10                	jne    800b7b <_Z6strtolPKcPPci+0x64>
  800b6b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b6f:	75 0a                	jne    800b7b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800b71:	83 c2 02             	add    $0x2,%edx
  800b74:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b79:	eb 13                	jmp    800b8e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800b7b:	84 c0                	test   %al,%al
  800b7d:	74 0f                	je     800b8e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b7f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b84:	80 3a 30             	cmpb   $0x30,(%edx)
  800b87:	75 05                	jne    800b8e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800b89:	83 c2 01             	add    $0x1,%edx
  800b8c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b93:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b95:	0f b6 0a             	movzbl (%edx),%ecx
  800b98:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b9b:	80 fb 09             	cmp    $0x9,%bl
  800b9e:	77 08                	ja     800ba8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800ba0:	0f be c9             	movsbl %cl,%ecx
  800ba3:	83 e9 30             	sub    $0x30,%ecx
  800ba6:	eb 1e                	jmp    800bc6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800ba8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800bab:	80 fb 19             	cmp    $0x19,%bl
  800bae:	77 08                	ja     800bb8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800bb0:	0f be c9             	movsbl %cl,%ecx
  800bb3:	83 e9 57             	sub    $0x57,%ecx
  800bb6:	eb 0e                	jmp    800bc6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800bb8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800bbb:	80 fb 19             	cmp    $0x19,%bl
  800bbe:	77 15                	ja     800bd5 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800bc0:	0f be c9             	movsbl %cl,%ecx
  800bc3:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bc6:	39 f1                	cmp    %esi,%ecx
  800bc8:	7d 0f                	jge    800bd9 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800bca:	83 c2 01             	add    $0x1,%edx
  800bcd:	0f af c6             	imul   %esi,%eax
  800bd0:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800bd3:	eb c0                	jmp    800b95 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800bd5:	89 c1                	mov    %eax,%ecx
  800bd7:	eb 02                	jmp    800bdb <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd9:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800bdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdf:	74 05                	je     800be6 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800be1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800be4:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800be6:	89 ca                	mov    %ecx,%edx
  800be8:	f7 da                	neg    %edx
  800bea:	85 ff                	test   %edi,%edi
  800bec:	0f 45 c2             	cmovne %edx,%eax
}
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 0c             	sub    $0xc,%esp
  800bfa:	89 1c 24             	mov    %ebx,(%esp)
  800bfd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c01:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c05:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c10:	89 c3                	mov    %eax,%ebx
  800c12:	89 c7                	mov    %eax,%edi
  800c14:	89 c6                	mov    %eax,%esi
  800c16:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c18:	8b 1c 24             	mov    (%esp),%ebx
  800c1b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c1f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c23:	89 ec                	mov    %ebp,%esp
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 0c             	sub    $0xc,%esp
  800c2d:	89 1c 24             	mov    %ebx,(%esp)
  800c30:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c34:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c38:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c42:	89 d1                	mov    %edx,%ecx
  800c44:	89 d3                	mov    %edx,%ebx
  800c46:	89 d7                	mov    %edx,%edi
  800c48:	89 d6                	mov    %edx,%esi
  800c4a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4c:	8b 1c 24             	mov    (%esp),%ebx
  800c4f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c53:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c57:	89 ec                	mov    %ebp,%esp
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	83 ec 38             	sub    $0x38,%esp
  800c61:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c64:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c67:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c6f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c74:	8b 55 08             	mov    0x8(%ebp),%edx
  800c77:	89 cb                	mov    %ecx,%ebx
  800c79:	89 cf                	mov    %ecx,%edi
  800c7b:	89 ce                	mov    %ecx,%esi
  800c7d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7e 28                	jle    800cab <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c83:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c87:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c8e:	00 
  800c8f:	c7 44 24 08 94 4e 80 	movl   $0x804e94,0x8(%esp)
  800c96:	00 
  800c97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c9e:	00 
  800c9f:	c7 04 24 b1 4e 80 00 	movl   $0x804eb1,(%esp)
  800ca6:	e8 01 35 00 00       	call   8041ac <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cb1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cb4:	89 ec                	mov    %ebp,%esp
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 0c             	sub    $0xc,%esp
  800cbe:	89 1c 24             	mov    %ebx,(%esp)
  800cc1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cc5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd3:	89 d1                	mov    %edx,%ecx
  800cd5:	89 d3                	mov    %edx,%ebx
  800cd7:	89 d7                	mov    %edx,%edi
  800cd9:	89 d6                	mov    %edx,%esi
  800cdb:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdd:	8b 1c 24             	mov    (%esp),%ebx
  800ce0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ce4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ce8:	89 ec                	mov    %ebp,%esp
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	89 1c 24             	mov    %ebx,(%esp)
  800cf5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cf9:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	b8 04 00 00 00       	mov    $0x4,%eax
  800d07:	89 d1                	mov    %edx,%ecx
  800d09:	89 d3                	mov    %edx,%ebx
  800d0b:	89 d7                	mov    %edx,%edi
  800d0d:	89 d6                	mov    %edx,%esi
  800d0f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d11:	8b 1c 24             	mov    (%esp),%ebx
  800d14:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d18:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d1c:	89 ec                	mov    %ebp,%esp
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	83 ec 38             	sub    $0x38,%esp
  800d26:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d29:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d2c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d2f:	be 00 00 00 00       	mov    $0x0,%esi
  800d34:	b8 08 00 00 00       	mov    $0x8,%eax
  800d39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d42:	89 f7                	mov    %esi,%edi
  800d44:	cd 30                	int    $0x30

	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7e 28                	jle    800d72 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d4e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d55:	00 
  800d56:	c7 44 24 08 94 4e 80 	movl   $0x804e94,0x8(%esp)
  800d5d:	00 
  800d5e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d65:	00 
  800d66:	c7 04 24 b1 4e 80 00 	movl   $0x804eb1,(%esp)
  800d6d:	e8 3a 34 00 00       	call   8041ac <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d72:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d75:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d78:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d7b:	89 ec                	mov    %ebp,%esp
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    

00800d7f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 38             	sub    $0x38,%esp
  800d85:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d88:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d8b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d8e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d93:	8b 75 18             	mov    0x18(%ebp),%esi
  800d96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d99:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	cd 30                	int    $0x30

	if(check && ret > 0)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	7e 28                	jle    800dd0 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dac:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800db3:	00 
  800db4:	c7 44 24 08 94 4e 80 	movl   $0x804e94,0x8(%esp)
  800dbb:	00 
  800dbc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc3:	00 
  800dc4:	c7 04 24 b1 4e 80 00 	movl   $0x804eb1,(%esp)
  800dcb:	e8 dc 33 00 00       	call   8041ac <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd9:	89 ec                	mov    %ebp,%esp
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 38             	sub    $0x38,%esp
  800de3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800de9:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	89 df                	mov    %ebx,%edi
  800dfe:	89 de                	mov    %ebx,%esi
  800e00:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7e 28                	jle    800e2e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e06:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e11:	00 
  800e12:	c7 44 24 08 94 4e 80 	movl   $0x804e94,0x8(%esp)
  800e19:	00 
  800e1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e21:	00 
  800e22:	c7 04 24 b1 4e 80 00 	movl   $0x804eb1,(%esp)
  800e29:	e8 7e 33 00 00       	call   8041ac <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e31:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e34:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e37:	89 ec                	mov    %ebp,%esp
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    

00800e3b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 38             	sub    $0x38,%esp
  800e41:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e44:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e47:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4f:	b8 05 00 00 00       	mov    $0x5,%eax
  800e54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e57:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5a:	89 df                	mov    %ebx,%edi
  800e5c:	89 de                	mov    %ebx,%esi
  800e5e:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	7e 28                	jle    800e8c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e64:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e68:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e6f:	00 
  800e70:	c7 44 24 08 94 4e 80 	movl   $0x804e94,0x8(%esp)
  800e77:	00 
  800e78:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7f:	00 
  800e80:	c7 04 24 b1 4e 80 00 	movl   $0x804eb1,(%esp)
  800e87:	e8 20 33 00 00       	call   8041ac <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e8c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e8f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e92:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e95:	89 ec                	mov    %ebp,%esp
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 38             	sub    $0x38,%esp
  800e9f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ead:	b8 06 00 00 00       	mov    $0x6,%eax
  800eb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb8:	89 df                	mov    %ebx,%edi
  800eba:	89 de                	mov    %ebx,%esi
  800ebc:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7e 28                	jle    800eea <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ecd:	00 
  800ece:	c7 44 24 08 94 4e 80 	movl   $0x804e94,0x8(%esp)
  800ed5:	00 
  800ed6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800edd:	00 
  800ede:	c7 04 24 b1 4e 80 00 	movl   $0x804eb1,(%esp)
  800ee5:	e8 c2 32 00 00       	call   8041ac <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800eea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eed:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef3:	89 ec                	mov    %ebp,%esp
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    

00800ef7 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	83 ec 38             	sub    $0x38,%esp
  800efd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f00:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f03:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	89 df                	mov    %ebx,%edi
  800f18:	89 de                	mov    %ebx,%esi
  800f1a:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	7e 28                	jle    800f48 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f24:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f2b:	00 
  800f2c:	c7 44 24 08 94 4e 80 	movl   $0x804e94,0x8(%esp)
  800f33:	00 
  800f34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3b:	00 
  800f3c:	c7 04 24 b1 4e 80 00 	movl   $0x804eb1,(%esp)
  800f43:	e8 64 32 00 00       	call   8041ac <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f48:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f51:	89 ec                	mov    %ebp,%esp
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 38             	sub    $0x38,%esp
  800f5b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f5e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f61:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f69:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	89 df                	mov    %ebx,%edi
  800f76:	89 de                	mov    %ebx,%esi
  800f78:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	7e 28                	jle    800fa6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f82:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  800f89:	00 
  800f8a:	c7 44 24 08 94 4e 80 	movl   $0x804e94,0x8(%esp)
  800f91:	00 
  800f92:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f99:	00 
  800f9a:	c7 04 24 b1 4e 80 00 	movl   $0x804eb1,(%esp)
  800fa1:	e8 06 32 00 00       	call   8041ac <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800faf:	89 ec                	mov    %ebp,%esp
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 0c             	sub    $0xc,%esp
  800fb9:	89 1c 24             	mov    %ebx,(%esp)
  800fbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fc0:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fc4:	be 00 00 00 00       	mov    $0x0,%esi
  800fc9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fce:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fda:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fdc:	8b 1c 24             	mov    (%esp),%ebx
  800fdf:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fe3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fe7:	89 ec                	mov    %ebp,%esp
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 38             	sub    $0x38,%esp
  800ff1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ff4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ff7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ffa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fff:	b8 0e 00 00 00       	mov    $0xe,%eax
  801004:	8b 55 08             	mov    0x8(%ebp),%edx
  801007:	89 cb                	mov    %ecx,%ebx
  801009:	89 cf                	mov    %ecx,%edi
  80100b:	89 ce                	mov    %ecx,%esi
  80100d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80100f:	85 c0                	test   %eax,%eax
  801011:	7e 28                	jle    80103b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801013:	89 44 24 10          	mov    %eax,0x10(%esp)
  801017:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80101e:	00 
  80101f:	c7 44 24 08 94 4e 80 	movl   $0x804e94,0x8(%esp)
  801026:	00 
  801027:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80102e:	00 
  80102f:	c7 04 24 b1 4e 80 00 	movl   $0x804eb1,(%esp)
  801036:	e8 71 31 00 00       	call   8041ac <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80103b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80103e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801041:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801044:	89 ec                	mov    %ebp,%esp
  801046:	5d                   	pop    %ebp
  801047:	c3                   	ret    

00801048 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	83 ec 0c             	sub    $0xc,%esp
  80104e:	89 1c 24             	mov    %ebx,(%esp)
  801051:	89 74 24 04          	mov    %esi,0x4(%esp)
  801055:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801059:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 df                	mov    %ebx,%edi
  80106b:	89 de                	mov    %ebx,%esi
  80106d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80106f:	8b 1c 24             	mov    (%esp),%ebx
  801072:	8b 74 24 04          	mov    0x4(%esp),%esi
  801076:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80107a:	89 ec                	mov    %ebp,%esp
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 0c             	sub    $0xc,%esp
  801084:	89 1c 24             	mov    %ebx,(%esp)
  801087:	89 74 24 04          	mov    %esi,0x4(%esp)
  80108b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80108f:	ba 00 00 00 00       	mov    $0x0,%edx
  801094:	b8 11 00 00 00       	mov    $0x11,%eax
  801099:	89 d1                	mov    %edx,%ecx
  80109b:	89 d3                	mov    %edx,%ebx
  80109d:	89 d7                	mov    %edx,%edi
  80109f:	89 d6                	mov    %edx,%esi
  8010a1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a3:	8b 1c 24             	mov    (%esp),%ebx
  8010a6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010aa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ae:	89 ec                	mov    %ebp,%esp
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    

008010b2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 0c             	sub    $0xc,%esp
  8010b8:	89 1c 24             	mov    %ebx,(%esp)
  8010bb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010bf:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c8:	b8 12 00 00 00       	mov    $0x12,%eax
  8010cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	89 df                	mov    %ebx,%edi
  8010d5:	89 de                	mov    %ebx,%esi
  8010d7:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  8010d9:	8b 1c 24             	mov    (%esp),%ebx
  8010dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010e0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010e4:	89 ec                	mov    %ebp,%esp
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    

008010e8 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 0c             	sub    $0xc,%esp
  8010ee:	89 1c 24             	mov    %ebx,(%esp)
  8010f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010f5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010fe:	b8 13 00 00 00       	mov    $0x13,%eax
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
  801106:	89 cb                	mov    %ecx,%ebx
  801108:	89 cf                	mov    %ecx,%edi
  80110a:	89 ce                	mov    %ecx,%esi
  80110c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80110e:	8b 1c 24             	mov    (%esp),%ebx
  801111:	8b 74 24 04          	mov    0x4(%esp),%esi
  801115:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801119:	89 ec                	mov    %ebp,%esp
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	83 ec 0c             	sub    $0xc,%esp
  801123:	89 1c 24             	mov    %ebx,(%esp)
  801126:	89 74 24 04          	mov    %esi,0x4(%esp)
  80112a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80112e:	b8 10 00 00 00       	mov    $0x10,%eax
  801133:	8b 75 18             	mov    0x18(%ebp),%esi
  801136:	8b 7d 14             	mov    0x14(%ebp),%edi
  801139:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80113c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113f:	8b 55 08             	mov    0x8(%ebp),%edx
  801142:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801144:	8b 1c 24             	mov    (%esp),%ebx
  801147:	8b 74 24 04          	mov    0x4(%esp),%esi
  80114b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80114f:	89 ec                	mov    %ebp,%esp
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    
	...

00801160 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	56                   	push   %esi
  801164:	53                   	push   %ebx
  801165:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  801168:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  80116d:	8b 04 9d 20 70 80 00 	mov    0x807020(,%ebx,4),%eax
  801174:	85 c0                	test   %eax,%eax
  801176:	74 08                	je     801180 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  801178:	8d 55 08             	lea    0x8(%ebp),%edx
  80117b:	89 14 24             	mov    %edx,(%esp)
  80117e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  801180:	83 eb 01             	sub    $0x1,%ebx
  801183:	83 fb ff             	cmp    $0xffffffff,%ebx
  801186:	75 e5                	jne    80116d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  801188:	8b 5d 38             	mov    0x38(%ebp),%ebx
  80118b:	8b 75 08             	mov    0x8(%ebp),%esi
  80118e:	e8 25 fb ff ff       	call   800cb8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  801193:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  801197:	89 74 24 10          	mov    %esi,0x10(%esp)
  80119b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80119f:	c7 44 24 08 c0 4e 80 	movl   $0x804ec0,0x8(%esp)
  8011a6:	00 
  8011a7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8011ae:	00 
  8011af:	c7 04 24 41 4f 80 00 	movl   $0x804f41,(%esp)
  8011b6:	e8 f1 2f 00 00       	call   8041ac <_Z6_panicPKciS0_z>

008011bb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	56                   	push   %esi
  8011bf:	53                   	push   %ebx
  8011c0:	83 ec 10             	sub    $0x10,%esp
  8011c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  8011c6:	e8 ed fa ff ff       	call   800cb8 <_Z12sys_getenvidv>
  8011cb:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  8011cd:	a1 00 70 80 00       	mov    0x807000,%eax
  8011d2:	8b 40 5c             	mov    0x5c(%eax),%eax
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	75 4c                	jne    801225 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  8011d9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011e0:	00 
  8011e1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8011e8:	ee 
  8011e9:	89 34 24             	mov    %esi,(%esp)
  8011ec:	e8 2f fb ff ff       	call   800d20 <_Z14sys_page_allociPvi>
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	74 20                	je     801215 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  8011f5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011f9:	c7 44 24 08 f8 4e 80 	movl   $0x804ef8,0x8(%esp)
  801200:	00 
  801201:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  801208:	00 
  801209:	c7 04 24 41 4f 80 00 	movl   $0x804f41,(%esp)
  801210:	e8 97 2f 00 00       	call   8041ac <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  801215:	c7 44 24 04 60 11 80 	movl   $0x801160,0x4(%esp)
  80121c:	00 
  80121d:	89 34 24             	mov    %esi,(%esp)
  801220:	e8 30 fd ff ff       	call   800f55 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  801225:	a1 20 70 80 00       	mov    0x807020,%eax
  80122a:	39 d8                	cmp    %ebx,%eax
  80122c:	74 1a                	je     801248 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  80122e:	85 c0                	test   %eax,%eax
  801230:	74 20                	je     801252 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  801232:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  801237:	8b 14 85 20 70 80 00 	mov    0x807020(,%eax,4),%edx
  80123e:	39 da                	cmp    %ebx,%edx
  801240:	74 15                	je     801257 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  801242:	85 d2                	test   %edx,%edx
  801244:	75 1f                	jne    801265 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  801246:	eb 0f                	jmp    801257 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  801248:	b8 00 00 00 00       	mov    $0x0,%eax
  80124d:	8d 76 00             	lea    0x0(%esi),%esi
  801250:	eb 05                	jmp    801257 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  801252:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  801257:	89 1c 85 20 70 80 00 	mov    %ebx,0x807020(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	5b                   	pop    %ebx
  801262:	5e                   	pop    %esi
  801263:	5d                   	pop    %ebp
  801264:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  801265:	83 c0 01             	add    $0x1,%eax
  801268:	83 f8 08             	cmp    $0x8,%eax
  80126b:	75 ca                	jne    801237 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80126d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801271:	c7 44 24 08 1c 4f 80 	movl   $0x804f1c,0x8(%esp)
  801278:	00 
  801279:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  801280:	00 
  801281:	c7 04 24 41 4f 80 00 	movl   $0x804f41,(%esp)
  801288:	e8 1f 2f 00 00       	call   8041ac <_Z6_panicPKciS0_z>
  80128d:	00 00                	add    %al,(%eax)
	...

00801290 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801293:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801298:	75 11                	jne    8012ab <_ZL8fd_validPK2Fd+0x1b>
  80129a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80129f:	76 0a                	jbe    8012ab <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  8012a1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  8012a6:	0f 96 c0             	setbe  %al
  8012a9:	eb 05                	jmp    8012b0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 14             	sub    $0x14,%esp
  8012b9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8012bb:	e8 d0 ff ff ff       	call   801290 <_ZL8fd_validPK2Fd>
  8012c0:	84 c0                	test   %al,%al
  8012c2:	75 24                	jne    8012e8 <_ZL9fd_isopenPK2Fd+0x36>
  8012c4:	c7 44 24 0c 4f 4f 80 	movl   $0x804f4f,0xc(%esp)
  8012cb:	00 
  8012cc:	c7 44 24 08 5c 4f 80 	movl   $0x804f5c,0x8(%esp)
  8012d3:	00 
  8012d4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8012db:	00 
  8012dc:	c7 04 24 71 4f 80 00 	movl   $0x804f71,(%esp)
  8012e3:	e8 c4 2e 00 00       	call   8041ac <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  8012e8:	89 d8                	mov    %ebx,%eax
  8012ea:	c1 e8 16             	shr    $0x16,%eax
  8012ed:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  8012f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f9:	f6 c2 01             	test   $0x1,%dl
  8012fc:	74 0d                	je     80130b <_ZL9fd_isopenPK2Fd+0x59>
  8012fe:	c1 eb 0c             	shr    $0xc,%ebx
  801301:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801308:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80130b:	83 c4 14             	add    $0x14,%esp
  80130e:	5b                   	pop    %ebx
  80130f:	5d                   	pop    %ebp
  801310:	c3                   	ret    

00801311 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 08             	sub    $0x8,%esp
  801317:	89 1c 24             	mov    %ebx,(%esp)
  80131a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80131e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801321:	8b 75 0c             	mov    0xc(%ebp),%esi
  801324:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801328:	83 fb 1f             	cmp    $0x1f,%ebx
  80132b:	77 18                	ja     801345 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80132d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801333:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801336:	84 c0                	test   %al,%al
  801338:	74 21                	je     80135b <_Z9fd_lookupiPP2Fdb+0x4a>
  80133a:	89 d8                	mov    %ebx,%eax
  80133c:	e8 71 ff ff ff       	call   8012b2 <_ZL9fd_isopenPK2Fd>
  801341:	84 c0                	test   %al,%al
  801343:	75 16                	jne    80135b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801345:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80134b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801350:	8b 1c 24             	mov    (%esp),%ebx
  801353:	8b 74 24 04          	mov    0x4(%esp),%esi
  801357:	89 ec                	mov    %ebp,%esp
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80135b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80135d:	b8 00 00 00 00       	mov    $0x0,%eax
  801362:	eb ec                	jmp    801350 <_Z9fd_lookupiPP2Fdb+0x3f>

00801364 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	53                   	push   %ebx
  801368:	83 ec 14             	sub    $0x14,%esp
  80136b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80136e:	89 d8                	mov    %ebx,%eax
  801370:	e8 1b ff ff ff       	call   801290 <_ZL8fd_validPK2Fd>
  801375:	84 c0                	test   %al,%al
  801377:	75 24                	jne    80139d <_Z6fd2numP2Fd+0x39>
  801379:	c7 44 24 0c 4f 4f 80 	movl   $0x804f4f,0xc(%esp)
  801380:	00 
  801381:	c7 44 24 08 5c 4f 80 	movl   $0x804f5c,0x8(%esp)
  801388:	00 
  801389:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801390:	00 
  801391:	c7 04 24 71 4f 80 00 	movl   $0x804f71,(%esp)
  801398:	e8 0f 2e 00 00       	call   8041ac <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80139d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  8013a3:	c1 e8 0c             	shr    $0xc,%eax
}
  8013a6:	83 c4 14             	add    $0x14,%esp
  8013a9:	5b                   	pop    %ebx
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    

008013ac <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 04 24             	mov    %eax,(%esp)
  8013b8:	e8 a7 ff ff ff       	call   801364 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8013bd:	05 20 00 0d 00       	add    $0xd0020,%eax
  8013c2:	c1 e0 0c             	shl    $0xc,%eax
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	57                   	push   %edi
  8013cb:	56                   	push   %esi
  8013cc:	53                   	push   %ebx
  8013cd:	83 ec 2c             	sub    $0x2c,%esp
  8013d0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8013d3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8013d8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8013db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013e2:	00 
  8013e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013e7:	89 1c 24             	mov    %ebx,(%esp)
  8013ea:	e8 22 ff ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  8013ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f2:	e8 bb fe ff ff       	call   8012b2 <_ZL9fd_isopenPK2Fd>
  8013f7:	84 c0                	test   %al,%al
  8013f9:	75 0c                	jne    801407 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  8013fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fe:	89 07                	mov    %eax,(%edi)
			return 0;
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	eb 13                	jmp    80141a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801407:	83 c3 01             	add    $0x1,%ebx
  80140a:	83 fb 20             	cmp    $0x20,%ebx
  80140d:	75 cc                	jne    8013db <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80140f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801415:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80141a:	83 c4 2c             	add    $0x2c,%esp
  80141d:	5b                   	pop    %ebx
  80141e:	5e                   	pop    %esi
  80141f:	5f                   	pop    %edi
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    

00801422 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	53                   	push   %ebx
  801426:	83 ec 14             	sub    $0x14,%esp
  801429:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80142f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801434:	39 0d 04 60 80 00    	cmp    %ecx,0x806004
  80143a:	75 16                	jne    801452 <_Z10dev_lookupiPP3Dev+0x30>
  80143c:	eb 06                	jmp    801444 <_Z10dev_lookupiPP3Dev+0x22>
  80143e:	39 0a                	cmp    %ecx,(%edx)
  801440:	75 10                	jne    801452 <_Z10dev_lookupiPP3Dev+0x30>
  801442:	eb 05                	jmp    801449 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801444:	ba 04 60 80 00       	mov    $0x806004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801449:	89 13                	mov    %edx,(%ebx)
			return 0;
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
  801450:	eb 35                	jmp    801487 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801452:	83 c0 01             	add    $0x1,%eax
  801455:	8b 14 85 dc 4f 80 00 	mov    0x804fdc(,%eax,4),%edx
  80145c:	85 d2                	test   %edx,%edx
  80145e:	75 de                	jne    80143e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801460:	a1 00 70 80 00       	mov    0x807000,%eax
  801465:	8b 40 04             	mov    0x4(%eax),%eax
  801468:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80146c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801470:	c7 04 24 98 4f 80 00 	movl   $0x804f98,(%esp)
  801477:	e8 a2 ed ff ff       	call   80021e <_Z7cprintfPKcz>
	*dev = 0;
  80147c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801482:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801487:	83 c4 14             	add    $0x14,%esp
  80148a:	5b                   	pop    %ebx
  80148b:	5d                   	pop    %ebp
  80148c:	c3                   	ret    

0080148d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	83 ec 20             	sub    $0x20,%esp
  801495:	8b 75 08             	mov    0x8(%ebp),%esi
  801498:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80149c:	89 34 24             	mov    %esi,(%esp)
  80149f:	e8 c0 fe ff ff       	call   801364 <_Z6fd2numP2Fd>
  8014a4:	0f b6 d3             	movzbl %bl,%edx
  8014a7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014ab:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014b2:	89 04 24             	mov    %eax,(%esp)
  8014b5:	e8 57 fe ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 05                	js     8014c3 <_Z8fd_closeP2Fdb+0x36>
  8014be:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014c1:	74 0c                	je     8014cf <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  8014c3:	80 fb 01             	cmp    $0x1,%bl
  8014c6:	19 db                	sbb    %ebx,%ebx
  8014c8:	f7 d3                	not    %ebx
  8014ca:	83 e3 fd             	and    $0xfffffffd,%ebx
  8014cd:	eb 3d                	jmp    80150c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d6:	8b 06                	mov    (%esi),%eax
  8014d8:	89 04 24             	mov    %eax,(%esp)
  8014db:	e8 42 ff ff ff       	call   801422 <_Z10dev_lookupiPP3Dev>
  8014e0:	89 c3                	mov    %eax,%ebx
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	78 16                	js     8014fc <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  8014e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014ec:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	74 07                	je     8014fc <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  8014f5:	89 34 24             	mov    %esi,(%esp)
  8014f8:	ff d0                	call   *%eax
  8014fa:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801500:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801507:	e8 d1 f8 ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
	return r;
}
  80150c:	89 d8                	mov    %ebx,%eax
  80150e:	83 c4 20             	add    $0x20,%esp
  801511:	5b                   	pop    %ebx
  801512:	5e                   	pop    %esi
  801513:	5d                   	pop    %ebp
  801514:	c3                   	ret    

00801515 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80151b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801522:	00 
  801523:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801526:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 04 24             	mov    %eax,(%esp)
  801530:	e8 dc fd ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  801535:	85 c0                	test   %eax,%eax
  801537:	78 13                	js     80154c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801539:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801540:	00 
  801541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801544:	89 04 24             	mov    %eax,(%esp)
  801547:	e8 41 ff ff ff       	call   80148d <_Z8fd_closeP2Fdb>
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <_Z9close_allv>:

void
close_all(void)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	53                   	push   %ebx
  801552:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801555:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80155a:	89 1c 24             	mov    %ebx,(%esp)
  80155d:	e8 b3 ff ff ff       	call   801515 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801562:	83 c3 01             	add    $0x1,%ebx
  801565:	83 fb 20             	cmp    $0x20,%ebx
  801568:	75 f0                	jne    80155a <_Z9close_allv+0xc>
		close(i);
}
  80156a:	83 c4 14             	add    $0x14,%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 48             	sub    $0x48,%esp
  801576:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801579:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80157c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80157f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801582:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801589:	00 
  80158a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80158d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	89 04 24             	mov    %eax,(%esp)
  801597:	e8 75 fd ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  80159c:	89 c3                	mov    %eax,%ebx
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	0f 88 ce 00 00 00    	js     801674 <_Z3dupii+0x104>
  8015a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015ad:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  8015ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015b1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8015b5:	89 34 24             	mov    %esi,(%esp)
  8015b8:	e8 54 fd ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  8015bd:	89 c3                	mov    %eax,%ebx
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	0f 89 bc 00 00 00    	jns    801683 <_Z3dupii+0x113>
  8015c7:	e9 a8 00 00 00       	jmp    801674 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8015cc:	89 d8                	mov    %ebx,%eax
  8015ce:	c1 e8 0c             	shr    $0xc,%eax
  8015d1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8015d8:	f6 c2 01             	test   $0x1,%dl
  8015db:	74 32                	je     80160f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015dd:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8015e4:	25 07 0e 00 00       	and    $0xe07,%eax
  8015e9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015f8:	00 
  8015f9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801604:	e8 76 f7 ff ff       	call   800d7f <_Z12sys_page_mapiPviS_i>
  801609:	89 c3                	mov    %eax,%ebx
  80160b:	85 c0                	test   %eax,%eax
  80160d:	78 3e                	js     80164d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80160f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801612:	89 c2                	mov    %eax,%edx
  801614:	c1 ea 0c             	shr    $0xc,%edx
  801617:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80161e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801624:	89 54 24 10          	mov    %edx,0x10(%esp)
  801628:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80162b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80162f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801636:	00 
  801637:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801642:	e8 38 f7 ff ff       	call   800d7f <_Z12sys_page_mapiPviS_i>
  801647:	89 c3                	mov    %eax,%ebx
  801649:	85 c0                	test   %eax,%eax
  80164b:	79 25                	jns    801672 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80164d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801650:	89 44 24 04          	mov    %eax,0x4(%esp)
  801654:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165b:	e8 7d f7 ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801660:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801664:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80166b:	e8 6d f7 ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
	return r;
  801670:	eb 02                	jmp    801674 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801672:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801674:	89 d8                	mov    %ebx,%eax
  801676:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801679:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80167c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80167f:	89 ec                	mov    %ebp,%esp
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801683:	89 34 24             	mov    %esi,(%esp)
  801686:	e8 8a fe ff ff       	call   801515 <_Z5closei>

	ova = fd2data(oldfd);
  80168b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80168e:	89 04 24             	mov    %eax,(%esp)
  801691:	e8 16 fd ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  801696:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801698:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169b:	89 04 24             	mov    %eax,(%esp)
  80169e:	e8 09 fd ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  8016a3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8016a5:	89 d8                	mov    %ebx,%eax
  8016a7:	c1 e8 16             	shr    $0x16,%eax
  8016aa:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8016b1:	a8 01                	test   $0x1,%al
  8016b3:	0f 85 13 ff ff ff    	jne    8015cc <_Z3dupii+0x5c>
  8016b9:	e9 51 ff ff ff       	jmp    80160f <_Z3dupii+0x9f>

008016be <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	53                   	push   %ebx
  8016c2:	83 ec 24             	sub    $0x24,%esp
  8016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8016cf:	00 
  8016d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	e8 32 fc ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 5f                	js     801742 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016ed:	8b 00                	mov    (%eax),%eax
  8016ef:	89 04 24             	mov    %eax,(%esp)
  8016f2:	e8 2b fd ff ff       	call   801422 <_Z10dev_lookupiPP3Dev>
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	79 4d                	jns    801748 <_Z4readiPvj+0x8a>
  8016fb:	eb 45                	jmp    801742 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016fd:	a1 00 70 80 00       	mov    0x807000,%eax
  801702:	8b 40 04             	mov    0x4(%eax),%eax
  801705:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801709:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170d:	c7 04 24 7a 4f 80 00 	movl   $0x804f7a,(%esp)
  801714:	e8 05 eb ff ff       	call   80021e <_Z7cprintfPKcz>
		return -E_INVAL;
  801719:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171e:	eb 22                	jmp    801742 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801726:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80172b:	85 d2                	test   %edx,%edx
  80172d:	74 13                	je     801742 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80172f:	8b 45 10             	mov    0x10(%ebp),%eax
  801732:	89 44 24 08          	mov    %eax,0x8(%esp)
  801736:	8b 45 0c             	mov    0xc(%ebp),%eax
  801739:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173d:	89 0c 24             	mov    %ecx,(%esp)
  801740:	ff d2                	call   *%edx
}
  801742:	83 c4 24             	add    $0x24,%esp
  801745:	5b                   	pop    %ebx
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801748:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80174b:	8b 41 08             	mov    0x8(%ecx),%eax
  80174e:	83 e0 03             	and    $0x3,%eax
  801751:	83 f8 01             	cmp    $0x1,%eax
  801754:	75 ca                	jne    801720 <_Z4readiPvj+0x62>
  801756:	eb a5                	jmp    8016fd <_Z4readiPvj+0x3f>

00801758 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	57                   	push   %edi
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	83 ec 1c             	sub    $0x1c,%esp
  801761:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801764:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801767:	85 f6                	test   %esi,%esi
  801769:	74 2f                	je     80179a <_Z5readniPvj+0x42>
  80176b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801770:	89 f0                	mov    %esi,%eax
  801772:	29 d8                	sub    %ebx,%eax
  801774:	89 44 24 08          	mov    %eax,0x8(%esp)
  801778:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80177b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	89 04 24             	mov    %eax,(%esp)
  801785:	e8 34 ff ff ff       	call   8016be <_Z4readiPvj>
		if (m < 0)
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 13                	js     8017a1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  80178e:	85 c0                	test   %eax,%eax
  801790:	74 0d                	je     80179f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801792:	01 c3                	add    %eax,%ebx
  801794:	39 de                	cmp    %ebx,%esi
  801796:	77 d8                	ja     801770 <_Z5readniPvj+0x18>
  801798:	eb 05                	jmp    80179f <_Z5readniPvj+0x47>
  80179a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80179f:	89 d8                	mov    %ebx,%eax
}
  8017a1:	83 c4 1c             	add    $0x1c,%esp
  8017a4:	5b                   	pop    %ebx
  8017a5:	5e                   	pop    %esi
  8017a6:	5f                   	pop    %edi
  8017a7:	5d                   	pop    %ebp
  8017a8:	c3                   	ret    

008017a9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8017af:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017b6:	00 
  8017b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	89 04 24             	mov    %eax,(%esp)
  8017c4:	e8 48 fb ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 3c                	js     801809 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8017d7:	8b 00                	mov    (%eax),%eax
  8017d9:	89 04 24             	mov    %eax,(%esp)
  8017dc:	e8 41 fc ff ff       	call   801422 <_Z10dev_lookupiPP3Dev>
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	79 26                	jns    80180b <_Z5writeiPKvj+0x62>
  8017e5:	eb 22                	jmp    801809 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  8017ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8017f2:	85 c9                	test   %ecx,%ecx
  8017f4:	74 13                	je     801809 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	89 44 24 04          	mov    %eax,0x4(%esp)
  801804:	89 14 24             	mov    %edx,(%esp)
  801807:	ff d1                	call   *%ecx
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80180b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80180e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801813:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801817:	74 f0                	je     801809 <_Z5writeiPKvj+0x60>
  801819:	eb cc                	jmp    8017e7 <_Z5writeiPKvj+0x3e>

0080181b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801821:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801828:	00 
  801829:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	89 04 24             	mov    %eax,(%esp)
  801836:	e8 d6 fa ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  80183b:	85 c0                	test   %eax,%eax
  80183d:	78 0e                	js     80184d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801842:	8b 55 0c             	mov    0xc(%ebp),%edx
  801845:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801848:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	53                   	push   %ebx
  801853:	83 ec 24             	sub    $0x24,%esp
  801856:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801859:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801860:	00 
  801861:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801864:	89 44 24 04          	mov    %eax,0x4(%esp)
  801868:	89 1c 24             	mov    %ebx,(%esp)
  80186b:	e8 a1 fa ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  801870:	85 c0                	test   %eax,%eax
  801872:	78 58                	js     8018cc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801874:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801877:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80187e:	8b 00                	mov    (%eax),%eax
  801880:	89 04 24             	mov    %eax,(%esp)
  801883:	e8 9a fb ff ff       	call   801422 <_Z10dev_lookupiPP3Dev>
  801888:	85 c0                	test   %eax,%eax
  80188a:	79 46                	jns    8018d2 <_Z9ftruncateii+0x83>
  80188c:	eb 3e                	jmp    8018cc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  80188e:	a1 00 70 80 00       	mov    0x807000,%eax
  801893:	8b 40 04             	mov    0x4(%eax),%eax
  801896:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80189a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189e:	c7 04 24 b8 4f 80 00 	movl   $0x804fb8,(%esp)
  8018a5:	e8 74 e9 ff ff       	call   80021e <_Z7cprintfPKcz>
		return -E_INVAL;
  8018aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018af:	eb 1b                	jmp    8018cc <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8018b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8018b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018bc:	85 d2                	test   %edx,%edx
  8018be:	74 0c                	je     8018cc <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c7:	89 0c 24             	mov    %ecx,(%esp)
  8018ca:	ff d2                	call   *%edx
}
  8018cc:	83 c4 24             	add    $0x24,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018d5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  8018d9:	75 d6                	jne    8018b1 <_Z9ftruncateii+0x62>
  8018db:	eb b1                	jmp    80188e <_Z9ftruncateii+0x3f>

008018dd <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	53                   	push   %ebx
  8018e1:	83 ec 24             	sub    $0x24,%esp
  8018e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8018e7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018ee:	00 
  8018ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	89 04 24             	mov    %eax,(%esp)
  8018fc:	e8 10 fa ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  801901:	85 c0                	test   %eax,%eax
  801903:	78 3e                	js     801943 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801905:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80190f:	8b 00                	mov    (%eax),%eax
  801911:	89 04 24             	mov    %eax,(%esp)
  801914:	e8 09 fb ff ff       	call   801422 <_Z10dev_lookupiPP3Dev>
  801919:	85 c0                	test   %eax,%eax
  80191b:	79 2c                	jns    801949 <_Z5fstatiP4Stat+0x6c>
  80191d:	eb 24                	jmp    801943 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80191f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801922:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801929:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801930:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801936:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193d:	89 04 24             	mov    %eax,(%esp)
  801940:	ff 52 14             	call   *0x14(%edx)
}
  801943:	83 c4 24             	add    $0x24,%esp
  801946:	5b                   	pop    %ebx
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801949:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80194c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801951:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801955:	75 c8                	jne    80191f <_Z5fstatiP4Stat+0x42>
  801957:	eb ea                	jmp    801943 <_Z5fstatiP4Stat+0x66>

00801959 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 18             	sub    $0x18,%esp
  80195f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801962:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801965:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80196c:	00 
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	89 04 24             	mov    %eax,(%esp)
  801973:	e8 d6 09 00 00       	call   80234e <_Z4openPKci>
  801978:	89 c3                	mov    %eax,%ebx
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 1b                	js     801999 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	89 44 24 04          	mov    %eax,0x4(%esp)
  801985:	89 1c 24             	mov    %ebx,(%esp)
  801988:	e8 50 ff ff ff       	call   8018dd <_Z5fstatiP4Stat>
  80198d:	89 c6                	mov    %eax,%esi
	close(fd);
  80198f:	89 1c 24             	mov    %ebx,(%esp)
  801992:	e8 7e fb ff ff       	call   801515 <_Z5closei>
	return r;
  801997:	89 f3                	mov    %esi,%ebx
}
  801999:	89 d8                	mov    %ebx,%eax
  80199b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80199e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8019a1:	89 ec                	mov    %ebp,%esp
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    
	...

008019b0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8019b3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8019b8:	85 d2                	test   %edx,%edx
  8019ba:	78 33                	js     8019ef <_ZL10inode_dataP5Inodei+0x3f>
  8019bc:	3b 50 08             	cmp    0x8(%eax),%edx
  8019bf:	7d 2e                	jge    8019ef <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  8019c1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8019c7:	85 d2                	test   %edx,%edx
  8019c9:	0f 49 ca             	cmovns %edx,%ecx
  8019cc:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  8019cf:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  8019d3:	c1 e1 0c             	shl    $0xc,%ecx
  8019d6:	89 d0                	mov    %edx,%eax
  8019d8:	c1 f8 1f             	sar    $0x1f,%eax
  8019db:	c1 e8 14             	shr    $0x14,%eax
  8019de:	01 c2                	add    %eax,%edx
  8019e0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8019e6:	29 c2                	sub    %eax,%edx
  8019e8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  8019ef:	89 c8                	mov    %ecx,%eax
  8019f1:	5d                   	pop    %ebp
  8019f2:	c3                   	ret    

008019f3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  8019f6:	8b 48 08             	mov    0x8(%eax),%ecx
  8019f9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  8019fc:	8b 00                	mov    (%eax),%eax
  8019fe:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801a01:	c7 82 80 00 00 00 04 	movl   $0x806004,0x80(%edx)
  801a08:	60 80 00 
}
  801a0b:	5d                   	pop    %ebp
  801a0c:	c3                   	ret    

00801a0d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801a13:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	74 08                	je     801a25 <_ZL9get_inodei+0x18>
  801a1d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801a23:	7e 20                	jle    801a45 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801a25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a29:	c7 44 24 08 f0 4f 80 	movl   $0x804ff0,0x8(%esp)
  801a30:	00 
  801a31:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801a38:	00 
  801a39:	c7 04 24 06 50 80 00 	movl   $0x805006,(%esp)
  801a40:	e8 67 27 00 00       	call   8041ac <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801a45:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801a4b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801a51:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801a57:	85 d2                	test   %edx,%edx
  801a59:	0f 48 d1             	cmovs  %ecx,%edx
  801a5c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801a5f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801a66:	c1 e0 0c             	shl    $0xc,%eax
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	56                   	push   %esi
  801a6f:	53                   	push   %ebx
  801a70:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801a73:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801a79:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801a7c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801a82:	76 20                	jbe    801aa4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801a84:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a88:	c7 44 24 08 2c 50 80 	movl   $0x80502c,0x8(%esp)
  801a8f:	00 
  801a90:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801a97:	00 
  801a98:	c7 04 24 06 50 80 00 	movl   $0x805006,(%esp)
  801a9f:	e8 08 27 00 00       	call   8041ac <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801aa4:	83 fe 01             	cmp    $0x1,%esi
  801aa7:	7e 08                	jle    801ab1 <_ZL10bcache_ipcPvi+0x46>
  801aa9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801aaf:	7d 12                	jge    801ac3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801ab1:	89 f3                	mov    %esi,%ebx
  801ab3:	c1 e3 04             	shl    $0x4,%ebx
  801ab6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801ab8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801abe:	c1 e6 0c             	shl    $0xc,%esi
  801ac1:	eb 20                	jmp    801ae3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801ac3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ac7:	c7 44 24 08 5c 50 80 	movl   $0x80505c,0x8(%esp)
  801ace:	00 
  801acf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801ad6:	00 
  801ad7:	c7 04 24 06 50 80 00 	movl   $0x805006,(%esp)
  801ade:	e8 c9 26 00 00       	call   8041ac <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801ae3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801aea:	00 
  801aeb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801af2:	00 
  801af3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801af7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801afe:	e8 cc 27 00 00       	call   8042cf <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801b03:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b0a:	00 
  801b0b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b16:	e8 25 27 00 00       	call   804240 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801b1b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801b1e:	74 c3                	je     801ae3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801b20:	83 c4 10             	add    $0x10,%esp
  801b23:	5b                   	pop    %ebx
  801b24:	5e                   	pop    %esi
  801b25:	5d                   	pop    %ebp
  801b26:	c3                   	ret    

00801b27 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 28             	sub    $0x28,%esp
  801b2d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b30:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b33:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b36:	89 c7                	mov    %eax,%edi
  801b38:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801b3a:	c7 04 24 cd 1d 80 00 	movl   $0x801dcd,(%esp)
  801b41:	e8 75 f6 ff ff       	call   8011bb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801b46:	89 f8                	mov    %edi,%eax
  801b48:	e8 c0 fe ff ff       	call   801a0d <_ZL9get_inodei>
  801b4d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801b4f:	ba 02 00 00 00       	mov    $0x2,%edx
  801b54:	e8 12 ff ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	79 08                	jns    801b65 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801b5d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801b63:	eb 2e                	jmp    801b93 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801b65:	85 c0                	test   %eax,%eax
  801b67:	75 1c                	jne    801b85 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801b69:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801b6f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801b76:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801b79:	ba 06 00 00 00       	mov    $0x6,%edx
  801b7e:	89 d8                	mov    %ebx,%eax
  801b80:	e8 e6 fe ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801b85:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801b8c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b93:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b96:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b99:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b9c:	89 ec                	mov    %ebp,%esp
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    

00801ba0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	57                   	push   %edi
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
  801ba6:	83 ec 2c             	sub    $0x2c,%esp
  801ba9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801bac:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801baf:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801bb4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801bba:	0f 87 3d 01 00 00    	ja     801cfd <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801bc0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801bc3:	8b 42 08             	mov    0x8(%edx),%eax
  801bc6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	0f 49 f0             	cmovns %eax,%esi
  801bd1:	c1 fe 0c             	sar    $0xc,%esi
  801bd4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801bd6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801bd9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801bdf:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801be2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801be5:	0f 82 a6 00 00 00    	jb     801c91 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801beb:	39 fe                	cmp    %edi,%esi
  801bed:	0f 8d f2 00 00 00    	jge    801ce5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801bf3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801bf7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801bfa:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801bfd:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801c00:	83 3e 00             	cmpl   $0x0,(%esi)
  801c03:	75 77                	jne    801c7c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801c05:	ba 02 00 00 00       	mov    $0x2,%edx
  801c0a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c0f:	e8 57 fe ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c14:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801c1a:	83 f9 02             	cmp    $0x2,%ecx
  801c1d:	7e 43                	jle    801c62 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801c1f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c24:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801c29:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801c30:	74 29                	je     801c5b <_ZL14inode_set_sizeP5Inodej+0xbb>
  801c32:	e9 ce 00 00 00       	jmp    801d05 <_ZL14inode_set_sizeP5Inodej+0x165>
  801c37:	89 c7                	mov    %eax,%edi
  801c39:	0f b6 10             	movzbl (%eax),%edx
  801c3c:	83 c0 01             	add    $0x1,%eax
  801c3f:	84 d2                	test   %dl,%dl
  801c41:	74 18                	je     801c5b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801c43:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c46:	ba 05 00 00 00       	mov    $0x5,%edx
  801c4b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c50:	e8 16 fe ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801c55:	85 db                	test   %ebx,%ebx
  801c57:	79 1e                	jns    801c77 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801c59:	eb 07                	jmp    801c62 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c5b:	83 c3 01             	add    $0x1,%ebx
  801c5e:	39 d9                	cmp    %ebx,%ecx
  801c60:	7f d5                	jg     801c37 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801c62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c65:	8b 50 08             	mov    0x8(%eax),%edx
  801c68:	e8 33 ff ff ff       	call   801ba0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801c6d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801c72:	e9 86 00 00 00       	jmp    801cfd <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801c77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c7a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801c7c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801c80:	83 c6 04             	add    $0x4,%esi
  801c83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c86:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801c89:	0f 8f 6e ff ff ff    	jg     801bfd <_ZL14inode_set_sizeP5Inodej+0x5d>
  801c8f:	eb 54                	jmp    801ce5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801c91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c94:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801c99:	83 f8 01             	cmp    $0x1,%eax
  801c9c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801c9f:	ba 02 00 00 00       	mov    $0x2,%edx
  801ca4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801ca9:	e8 bd fd ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801cae:	39 f7                	cmp    %esi,%edi
  801cb0:	7d 24                	jge    801cd6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801cb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801cb5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801cb9:	8b 10                	mov    (%eax),%edx
  801cbb:	85 d2                	test   %edx,%edx
  801cbd:	74 0d                	je     801ccc <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801cbf:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801cc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801ccc:	83 eb 01             	sub    $0x1,%ebx
  801ccf:	83 e8 04             	sub    $0x4,%eax
  801cd2:	39 fb                	cmp    %edi,%ebx
  801cd4:	75 e3                	jne    801cb9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801cd6:	ba 05 00 00 00       	mov    $0x5,%edx
  801cdb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801ce0:	e8 86 fd ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801ce5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ce8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ceb:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801cee:	ba 04 00 00 00       	mov    $0x4,%edx
  801cf3:	e8 73 fd ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
	return 0;
  801cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfd:	83 c4 2c             	add    $0x2c,%esp
  801d00:	5b                   	pop    %ebx
  801d01:	5e                   	pop    %esi
  801d02:	5f                   	pop    %edi
  801d03:	5d                   	pop    %ebp
  801d04:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801d05:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801d0c:	ba 05 00 00 00       	mov    $0x5,%edx
  801d11:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d16:	e8 50 fd ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801d1b:	bb 02 00 00 00       	mov    $0x2,%ebx
  801d20:	e9 52 ff ff ff       	jmp    801c77 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801d25 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	53                   	push   %ebx
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801d2e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801d34:	83 e8 01             	sub    $0x1,%eax
  801d37:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801d3d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801d41:	75 40                	jne    801d83 <_ZL11inode_closeP5Inode+0x5e>
  801d43:	85 c0                	test   %eax,%eax
  801d45:	75 3c                	jne    801d83 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801d47:	ba 02 00 00 00       	mov    $0x2,%edx
  801d4c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d51:	e8 15 fd ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801d56:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801d5b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801d5f:	85 d2                	test   %edx,%edx
  801d61:	74 07                	je     801d6a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801d63:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801d6a:	83 c0 01             	add    $0x1,%eax
  801d6d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801d72:	75 e7                	jne    801d5b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801d74:	ba 05 00 00 00       	mov    $0x5,%edx
  801d79:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d7e:	e8 e8 fc ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801d83:	ba 03 00 00 00       	mov    $0x3,%edx
  801d88:	89 d8                	mov    %ebx,%eax
  801d8a:	e8 dc fc ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
}
  801d8f:	83 c4 04             	add    $0x4,%esp
  801d92:	5b                   	pop    %ebx
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    

00801d95 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	53                   	push   %ebx
  801d99:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801da2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801da5:	e8 7d fd ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  801daa:	89 c3                	mov    %eax,%ebx
  801dac:	85 c0                	test   %eax,%eax
  801dae:	78 15                	js     801dc5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	e8 e5 fd ff ff       	call   801ba0 <_ZL14inode_set_sizeP5Inodej>
  801dbb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc0:	e8 60 ff ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
	return r;
}
  801dc5:	89 d8                	mov    %ebx,%eax
  801dc7:	83 c4 14             	add    $0x14,%esp
  801dca:	5b                   	pop    %ebx
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    

00801dcd <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	53                   	push   %ebx
  801dd1:	83 ec 14             	sub    $0x14,%esp
  801dd4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801dd7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801dd9:	89 c2                	mov    %eax,%edx
  801ddb:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801de1:	78 32                	js     801e15 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801de3:	ba 00 00 00 00       	mov    $0x0,%edx
  801de8:	e8 7e fc ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
  801ded:	85 c0                	test   %eax,%eax
  801def:	74 1c                	je     801e0d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801df1:	c7 44 24 08 11 50 80 	movl   $0x805011,0x8(%esp)
  801df8:	00 
  801df9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801e00:	00 
  801e01:	c7 04 24 06 50 80 00 	movl   $0x805006,(%esp)
  801e08:	e8 9f 23 00 00       	call   8041ac <_Z6_panicPKciS0_z>
    resume(utf);
  801e0d:	89 1c 24             	mov    %ebx,(%esp)
  801e10:	e8 07 24 00 00       	call   80421c <resume>
}
  801e15:	83 c4 14             	add    $0x14,%esp
  801e18:	5b                   	pop    %ebx
  801e19:	5d                   	pop    %ebp
  801e1a:	c3                   	ret    

00801e1b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 28             	sub    $0x28,%esp
  801e21:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e24:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801e2a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801e2d:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e30:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e33:	e8 ef fc ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 26                	js     801e62 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  801e3c:	83 c3 10             	add    $0x10,%ebx
  801e3f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e43:	89 34 24             	mov    %esi,(%esp)
  801e46:	e8 ef e9 ff ff       	call   80083a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801e4b:	89 f2                	mov    %esi,%edx
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	e8 9e fb ff ff       	call   8019f3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	e8 c8 fe ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
	return 0;
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e62:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e65:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e68:	89 ec                	mov    %ebp,%esp
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    

00801e6c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	53                   	push   %ebx
  801e70:	83 ec 24             	sub    $0x24,%esp
  801e73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801e76:	89 1c 24             	mov    %ebx,(%esp)
  801e79:	e8 9e 15 00 00       	call   80341c <_Z7pagerefPv>
  801e7e:	89 c2                	mov    %eax,%edx
        return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801e85:	83 fa 01             	cmp    $0x1,%edx
  801e88:	7f 1e                	jg     801ea8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801e8a:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e8d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e90:	e8 92 fc ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 0f                	js     801ea8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  801ea3:	e8 7d fe ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
}
  801ea8:	83 c4 24             	add    $0x24,%esp
  801eab:	5b                   	pop    %ebx
  801eac:	5d                   	pop    %ebp
  801ead:	c3                   	ret    

00801eae <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	57                   	push   %edi
  801eb2:	56                   	push   %esi
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 3c             	sub    $0x3c,%esp
  801eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801eba:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  801ebd:	8b 43 04             	mov    0x4(%ebx),%eax
  801ec0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801ec3:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ec6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801ec9:	e8 59 fc ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	0f 88 8c 00 00 00    	js     801f62 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801ed6:	8b 53 04             	mov    0x4(%ebx),%edx
  801ed9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  801edf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801ee5:	29 d7                	sub    %edx,%edi
  801ee7:	39 f7                	cmp    %esi,%edi
  801ee9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  801eec:	85 ff                	test   %edi,%edi
  801eee:	74 16                	je     801f06 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801ef0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  801ef3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ef6:	3b 50 08             	cmp    0x8(%eax),%edx
  801ef9:	76 6f                	jbe    801f6a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  801efb:	e8 a0 fc ff ff       	call   801ba0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801f00:	85 c0                	test   %eax,%eax
  801f02:	79 66                	jns    801f6a <_ZL13devfile_writeP2FdPKvj+0xbc>
  801f04:	eb 4e                	jmp    801f54 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801f06:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  801f0c:	76 24                	jbe    801f32 <_ZL13devfile_writeP2FdPKvj+0x84>
  801f0e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801f10:	8b 53 04             	mov    0x4(%ebx),%edx
  801f13:	81 c2 00 10 00 00    	add    $0x1000,%edx
  801f19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f1c:	3b 50 08             	cmp    0x8(%eax),%edx
  801f1f:	0f 86 83 00 00 00    	jbe    801fa8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  801f25:	e8 76 fc ff ff       	call   801ba0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	79 7a                	jns    801fa8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  801f2e:	66 90                	xchg   %ax,%ax
  801f30:	eb 22                	jmp    801f54 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  801f32:	85 f6                	test   %esi,%esi
  801f34:	74 1e                	je     801f54 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801f36:	89 f2                	mov    %esi,%edx
  801f38:	03 53 04             	add    0x4(%ebx),%edx
  801f3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f3e:	3b 50 08             	cmp    0x8(%eax),%edx
  801f41:	0f 86 b8 00 00 00    	jbe    801fff <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  801f47:	e8 54 fc ff ff       	call   801ba0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	0f 89 ab 00 00 00    	jns    801fff <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  801f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f57:	e8 c9 fd ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  801f5c:	8b 43 04             	mov    0x4(%ebx),%eax
  801f5f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  801f62:	83 c4 3c             	add    $0x3c,%esp
  801f65:	5b                   	pop    %ebx
  801f66:	5e                   	pop    %esi
  801f67:	5f                   	pop    %edi
  801f68:	5d                   	pop    %ebp
  801f69:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  801f6a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801f6c:	8b 53 04             	mov    0x4(%ebx),%edx
  801f6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f72:	e8 39 fa ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
  801f77:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  801f7a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f85:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f88:	89 04 24             	mov    %eax,(%esp)
  801f8b:	e8 c7 ea ff ff       	call   800a57 <memcpy>
        fd->fd_offset += n2;
  801f90:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  801f93:	ba 04 00 00 00       	mov    $0x4,%edx
  801f98:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f9b:	e8 cb fa ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  801fa0:	01 7d 0c             	add    %edi,0xc(%ebp)
  801fa3:	e9 5e ff ff ff       	jmp    801f06 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801fa8:	8b 53 04             	mov    0x4(%ebx),%edx
  801fab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fae:	e8 fd f9 ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
  801fb3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  801fb5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801fbc:	00 
  801fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc4:	89 34 24             	mov    %esi,(%esp)
  801fc7:	e8 8b ea ff ff       	call   800a57 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801fcc:	ba 04 00 00 00       	mov    $0x4,%edx
  801fd1:	89 f0                	mov    %esi,%eax
  801fd3:	e8 93 fa ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  801fd8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  801fde:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  801fe5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801fec:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801ff2:	0f 87 18 ff ff ff    	ja     801f10 <_ZL13devfile_writeP2FdPKvj+0x62>
  801ff8:	89 fe                	mov    %edi,%esi
  801ffa:	e9 33 ff ff ff       	jmp    801f32 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801fff:	8b 53 04             	mov    0x4(%ebx),%edx
  802002:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802005:	e8 a6 f9 ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
  80200a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80200c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802010:	8b 45 0c             	mov    0xc(%ebp),%eax
  802013:	89 44 24 04          	mov    %eax,0x4(%esp)
  802017:	89 3c 24             	mov    %edi,(%esp)
  80201a:	e8 38 ea ff ff       	call   800a57 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80201f:	ba 04 00 00 00       	mov    $0x4,%edx
  802024:	89 f8                	mov    %edi,%eax
  802026:	e8 40 fa ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80202b:	01 73 04             	add    %esi,0x4(%ebx)
  80202e:	e9 21 ff ff ff       	jmp    801f54 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802033 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	57                   	push   %edi
  802037:	56                   	push   %esi
  802038:	53                   	push   %ebx
  802039:	83 ec 3c             	sub    $0x3c,%esp
  80203c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80203f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802042:	8b 43 04             	mov    0x4(%ebx),%eax
  802045:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802048:	8b 43 0c             	mov    0xc(%ebx),%eax
  80204b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80204e:	e8 d4 fa ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  802053:	85 c0                	test   %eax,%eax
  802055:	0f 88 d3 00 00 00    	js     80212e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80205b:	8b 73 04             	mov    0x4(%ebx),%esi
  80205e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802061:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802064:	8b 50 08             	mov    0x8(%eax),%edx
  802067:	29 f2                	sub    %esi,%edx
  802069:	3b 48 08             	cmp    0x8(%eax),%ecx
  80206c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80206f:	89 f2                	mov    %esi,%edx
  802071:	e8 3a f9 ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
  802076:	85 c0                	test   %eax,%eax
  802078:	0f 84 a2 00 00 00    	je     802120 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80207e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802084:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80208a:	29 f2                	sub    %esi,%edx
  80208c:	39 d7                	cmp    %edx,%edi
  80208e:	0f 46 d7             	cmovbe %edi,%edx
  802091:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802094:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802096:	01 d6                	add    %edx,%esi
  802098:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80209b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80209f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a6:	89 04 24             	mov    %eax,(%esp)
  8020a9:	e8 a9 e9 ff ff       	call   800a57 <memcpy>
    buf = (void *)((char *)buf + n2);
  8020ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020b1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8020b4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8020ba:	76 3e                	jbe    8020fa <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8020bc:	8b 53 04             	mov    0x4(%ebx),%edx
  8020bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020c2:	e8 e9 f8 ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	74 55                	je     802120 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  8020cb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8020d2:	00 
  8020d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d7:	89 34 24             	mov    %esi,(%esp)
  8020da:	e8 78 e9 ff ff       	call   800a57 <memcpy>
        n -= PGSIZE;
  8020df:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8020e5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8020eb:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  8020f2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8020f8:	77 c2                	ja     8020bc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8020fa:	85 ff                	test   %edi,%edi
  8020fc:	74 22                	je     802120 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8020fe:	8b 53 04             	mov    0x4(%ebx),%edx
  802101:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802104:	e8 a7 f8 ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
  802109:	85 c0                	test   %eax,%eax
  80210b:	74 13                	je     802120 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80210d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802111:	89 44 24 04          	mov    %eax,0x4(%esp)
  802115:	89 34 24             	mov    %esi,(%esp)
  802118:	e8 3a e9 ff ff       	call   800a57 <memcpy>
        fd->fd_offset += n;
  80211d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802120:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802123:	e8 fd fb ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802128:	8b 43 04             	mov    0x4(%ebx),%eax
  80212b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80212e:	83 c4 3c             	add    $0x3c,%esp
  802131:	5b                   	pop    %ebx
  802132:	5e                   	pop    %esi
  802133:	5f                   	pop    %edi
  802134:	5d                   	pop    %ebp
  802135:	c3                   	ret    

00802136 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	57                   	push   %edi
  80213a:	56                   	push   %esi
  80213b:	53                   	push   %ebx
  80213c:	83 ec 4c             	sub    $0x4c,%esp
  80213f:	89 c6                	mov    %eax,%esi
  802141:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802144:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802147:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80214d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802156:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802159:	b8 01 00 00 00       	mov    $0x1,%eax
  80215e:	e8 c4 f9 ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  802163:	89 c7                	mov    %eax,%edi
  802165:	85 c0                	test   %eax,%eax
  802167:	0f 88 cd 01 00 00    	js     80233a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80216d:	89 f3                	mov    %esi,%ebx
  80216f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802172:	75 08                	jne    80217c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802174:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802177:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80217a:	74 f8                	je     802174 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80217c:	0f b6 03             	movzbl (%ebx),%eax
  80217f:	3c 2f                	cmp    $0x2f,%al
  802181:	74 16                	je     802199 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802183:	84 c0                	test   %al,%al
  802185:	74 12                	je     802199 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802187:	89 da                	mov    %ebx,%edx
		++path;
  802189:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80218c:	0f b6 02             	movzbl (%edx),%eax
  80218f:	3c 2f                	cmp    $0x2f,%al
  802191:	74 08                	je     80219b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802193:	84 c0                	test   %al,%al
  802195:	75 f2                	jne    802189 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802197:	eb 02                	jmp    80219b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802199:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80219b:	89 d0                	mov    %edx,%eax
  80219d:	29 d8                	sub    %ebx,%eax
  80219f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  8021a2:	0f b6 02             	movzbl (%edx),%eax
  8021a5:	89 d6                	mov    %edx,%esi
  8021a7:	3c 2f                	cmp    $0x2f,%al
  8021a9:	75 0a                	jne    8021b5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  8021ab:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  8021ae:	0f b6 06             	movzbl (%esi),%eax
  8021b1:	3c 2f                	cmp    $0x2f,%al
  8021b3:	74 f6                	je     8021ab <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8021b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8021b9:	75 1b                	jne    8021d6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8021bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021be:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8021c1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8021c3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021c6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8021cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d1:	e9 64 01 00 00       	jmp    80233a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8021d6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8021da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021de:	74 06                	je     8021e6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8021e0:	84 c0                	test   %al,%al
  8021e2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8021e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021e9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8021ec:	83 3a 02             	cmpl   $0x2,(%edx)
  8021ef:	0f 85 f4 00 00 00    	jne    8022e9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8021f5:	89 d0                	mov    %edx,%eax
  8021f7:	8b 52 08             	mov    0x8(%edx),%edx
  8021fa:	85 d2                	test   %edx,%edx
  8021fc:	7e 78                	jle    802276 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  8021fe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802205:	bf 00 00 00 00       	mov    $0x0,%edi
  80220a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80220d:	89 fb                	mov    %edi,%ebx
  80220f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802212:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802214:	89 da                	mov    %ebx,%edx
  802216:	89 f0                	mov    %esi,%eax
  802218:	e8 93 f7 ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
  80221d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80221f:	83 38 00             	cmpl   $0x0,(%eax)
  802222:	74 26                	je     80224a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802224:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802227:	3b 50 04             	cmp    0x4(%eax),%edx
  80222a:	75 33                	jne    80225f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80222c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802230:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802233:	89 44 24 04          	mov    %eax,0x4(%esp)
  802237:	8d 47 08             	lea    0x8(%edi),%eax
  80223a:	89 04 24             	mov    %eax,(%esp)
  80223d:	e8 56 e8 ff ff       	call   800a98 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802242:	85 c0                	test   %eax,%eax
  802244:	0f 84 fa 00 00 00    	je     802344 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80224a:	83 3f 00             	cmpl   $0x0,(%edi)
  80224d:	75 10                	jne    80225f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80224f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802253:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802256:	84 c0                	test   %al,%al
  802258:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80225c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80225f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802265:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802267:	8b 56 08             	mov    0x8(%esi),%edx
  80226a:	39 d0                	cmp    %edx,%eax
  80226c:	7c a6                	jl     802214 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80226e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802271:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802274:	eb 07                	jmp    80227d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802276:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80227d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802281:	74 6d                	je     8022f0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802283:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802287:	75 24                	jne    8022ad <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802289:	83 ea 80             	sub    $0xffffff80,%edx
  80228c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80228f:	e8 0c f9 ff ff       	call   801ba0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802294:	85 c0                	test   %eax,%eax
  802296:	0f 88 90 00 00 00    	js     80232c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80229c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80229f:	8b 50 08             	mov    0x8(%eax),%edx
  8022a2:	83 c2 80             	add    $0xffffff80,%edx
  8022a5:	e8 06 f7 ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
  8022aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  8022ad:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8022b4:	00 
  8022b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022bc:	00 
  8022bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8022c0:	89 14 24             	mov    %edx,(%esp)
  8022c3:	e8 b9 e6 ff ff       	call   800981 <memset>
	empty->de_namelen = namelen;
  8022c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8022d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022d9:	83 c0 08             	add    $0x8,%eax
  8022dc:	89 04 24             	mov    %eax,(%esp)
  8022df:	e8 73 e7 ff ff       	call   800a57 <memcpy>
	*de_store = empty;
  8022e4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  8022e7:	eb 5e                	jmp    802347 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  8022e9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  8022ee:	eb 42                	jmp    802332 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  8022f0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  8022f5:	eb 3b                	jmp    802332 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  8022f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022fa:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8022fd:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  8022ff:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802302:	89 38                	mov    %edi,(%eax)
			return 0;
  802304:	bf 00 00 00 00       	mov    $0x0,%edi
  802309:	eb 2f                	jmp    80233a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80230b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80230e:	8b 07                	mov    (%edi),%eax
  802310:	e8 12 f8 ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  802315:	85 c0                	test   %eax,%eax
  802317:	78 17                	js     802330 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80231c:	e8 04 fa ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802321:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802324:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802327:	e9 41 fe ff ff       	jmp    80216d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80232c:	89 c7                	mov    %eax,%edi
  80232e:	eb 02                	jmp    802332 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802330:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802335:	e8 eb f9 ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
	return r;
}
  80233a:	89 f8                	mov    %edi,%eax
  80233c:	83 c4 4c             	add    $0x4c,%esp
  80233f:	5b                   	pop    %ebx
  802340:	5e                   	pop    %esi
  802341:	5f                   	pop    %edi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    
  802344:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802347:	80 3e 00             	cmpb   $0x0,(%esi)
  80234a:	75 bf                	jne    80230b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80234c:	eb a9                	jmp    8022f7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080234e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 3c             	sub    $0x3c,%esp
  802357:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80235a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80235d:	89 04 24             	mov    %eax,(%esp)
  802360:	e8 62 f0 ff ff       	call   8013c7 <_Z14fd_find_unusedPP2Fd>
  802365:	89 c3                	mov    %eax,%ebx
  802367:	85 c0                	test   %eax,%eax
  802369:	0f 88 16 02 00 00    	js     802585 <_Z4openPKci+0x237>
  80236f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802376:	00 
  802377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80237a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80237e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802385:	e8 96 e9 ff ff       	call   800d20 <_Z14sys_page_allociPvi>
  80238a:	89 c3                	mov    %eax,%ebx
  80238c:	b8 00 00 00 00       	mov    $0x0,%eax
  802391:	85 db                	test   %ebx,%ebx
  802393:	0f 88 ec 01 00 00    	js     802585 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802399:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80239d:	0f 84 ec 01 00 00    	je     80258f <_Z4openPKci+0x241>
  8023a3:	83 c0 01             	add    $0x1,%eax
  8023a6:	83 f8 78             	cmp    $0x78,%eax
  8023a9:	75 ee                	jne    802399 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8023ab:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8023b0:	e9 b9 01 00 00       	jmp    80256e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8023b5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8023b8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8023be:	89 3c 24             	mov    %edi,(%esp)
  8023c1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  8023c4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8023c7:	89 f0                	mov    %esi,%eax
  8023c9:	e8 68 fd ff ff       	call   802136 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8023ce:	89 c3                	mov    %eax,%ebx
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	0f 85 96 01 00 00    	jne    80256e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8023d8:	85 ff                	test   %edi,%edi
  8023da:	75 41                	jne    80241d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8023dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023df:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  8023e4:	75 08                	jne    8023ee <_Z4openPKci+0xa0>
            fileino = dirino;
  8023e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023ec:	eb 14                	jmp    802402 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  8023ee:	8d 55 d8             	lea    -0x28(%ebp),%edx
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	e8 2f f7 ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  8023f8:	89 c3                	mov    %eax,%ebx
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	0f 88 5d 01 00 00    	js     80255f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802402:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802405:	83 38 02             	cmpl   $0x2,(%eax)
  802408:	0f 85 d2 00 00 00    	jne    8024e0 <_Z4openPKci+0x192>
  80240e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802412:	0f 84 c8 00 00 00    	je     8024e0 <_Z4openPKci+0x192>
  802418:	e9 38 01 00 00       	jmp    802555 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80241d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802424:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80242b:	0f 8e a8 00 00 00    	jle    8024d9 <_Z4openPKci+0x18b>
  802431:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802436:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802439:	89 f8                	mov    %edi,%eax
  80243b:	e8 e7 f6 ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  802440:	89 c3                	mov    %eax,%ebx
  802442:	85 c0                	test   %eax,%eax
  802444:	0f 88 15 01 00 00    	js     80255f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80244a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80244d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802451:	75 68                	jne    8024bb <_Z4openPKci+0x16d>
  802453:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80245a:	75 5f                	jne    8024bb <_Z4openPKci+0x16d>
			*ino_store = ino;
  80245c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80245f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802465:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802468:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80246f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802476:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80247d:	00 
  80247e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802485:	00 
  802486:	83 c0 0c             	add    $0xc,%eax
  802489:	89 04 24             	mov    %eax,(%esp)
  80248c:	e8 f0 e4 ff ff       	call   800981 <memset>
        de->de_inum = fileino->i_inum;
  802491:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802494:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80249a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80249d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80249f:	ba 04 00 00 00       	mov    $0x4,%edx
  8024a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a7:	e8 bf f5 ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  8024ac:	ba 04 00 00 00       	mov    $0x4,%edx
  8024b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b4:	e8 b2 f5 ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
  8024b9:	eb 25                	jmp    8024e0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  8024bb:	e8 65 f8 ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8024c0:	83 c7 01             	add    $0x1,%edi
  8024c3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  8024c9:	0f 8c 67 ff ff ff    	jl     802436 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  8024cf:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8024d4:	e9 86 00 00 00       	jmp    80255f <_Z4openPKci+0x211>
  8024d9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8024de:	eb 7f                	jmp    80255f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  8024e0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  8024e7:	74 0d                	je     8024f6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  8024e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024f1:	e8 aa f6 ff ff       	call   801ba0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  8024f6:	8b 15 04 60 80 00    	mov    0x806004,%edx
  8024fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ff:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802504:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80250b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802511:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802514:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80251a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80251d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802521:	83 c0 10             	add    $0x10,%eax
  802524:	89 04 24             	mov    %eax,(%esp)
  802527:	e8 0e e3 ff ff       	call   80083a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80252c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80252f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802539:	e8 e7 f7 ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80253e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802541:	e8 df f7 ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802549:	89 04 24             	mov    %eax,(%esp)
  80254c:	e8 13 ee ff ff       	call   801364 <_Z6fd2numP2Fd>
  802551:	89 c3                	mov    %eax,%ebx
  802553:	eb 30                	jmp    802585 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802555:	e8 cb f7 ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80255a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80255f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802562:	e8 be f7 ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
  802567:	eb 05                	jmp    80256e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802569:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80256e:	a1 00 70 80 00       	mov    0x807000,%eax
  802573:	8b 40 04             	mov    0x4(%eax),%eax
  802576:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802579:	89 54 24 04          	mov    %edx,0x4(%esp)
  80257d:	89 04 24             	mov    %eax,(%esp)
  802580:	e8 58 e8 ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802585:	89 d8                	mov    %ebx,%eax
  802587:	83 c4 3c             	add    $0x3c,%esp
  80258a:	5b                   	pop    %ebx
  80258b:	5e                   	pop    %esi
  80258c:	5f                   	pop    %edi
  80258d:	5d                   	pop    %ebp
  80258e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80258f:	83 f8 78             	cmp    $0x78,%eax
  802592:	0f 85 1d fe ff ff    	jne    8023b5 <_Z4openPKci+0x67>
  802598:	eb cf                	jmp    802569 <_Z4openPKci+0x21b>

0080259a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	53                   	push   %ebx
  80259e:	83 ec 24             	sub    $0x24,%esp
  8025a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  8025a4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025aa:	e8 78 f5 ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	78 27                	js     8025da <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  8025b3:	c7 44 24 04 24 50 80 	movl   $0x805024,0x4(%esp)
  8025ba:	00 
  8025bb:	89 1c 24             	mov    %ebx,(%esp)
  8025be:	e8 77 e2 ff ff       	call   80083a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8025c3:	89 da                	mov    %ebx,%edx
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	e8 26 f4 ff ff       	call   8019f3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	e8 50 f7 ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
	return 0;
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025da:	83 c4 24             	add    $0x24,%esp
  8025dd:	5b                   	pop    %ebx
  8025de:	5d                   	pop    %ebp
  8025df:	c3                   	ret    

008025e0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	53                   	push   %ebx
  8025e4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  8025e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025ee:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  8025f1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	e8 3a fb ff ff       	call   802136 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8025fc:	89 c3                	mov    %eax,%ebx
  8025fe:	85 c0                	test   %eax,%eax
  802600:	78 5f                	js     802661 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802602:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802608:	8b 00                	mov    (%eax),%eax
  80260a:	e8 18 f5 ff ff       	call   801b27 <_ZL10inode_openiPP5Inode>
  80260f:	89 c3                	mov    %eax,%ebx
  802611:	85 c0                	test   %eax,%eax
  802613:	78 44                	js     802659 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802615:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80261a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261d:	83 38 02             	cmpl   $0x2,(%eax)
  802620:	74 2f                	je     802651 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80262b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802632:	ba 04 00 00 00       	mov    $0x4,%edx
  802637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263a:	e8 2c f4 ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80263f:	ba 04 00 00 00       	mov    $0x4,%edx
  802644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802647:	e8 1f f4 ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
	r = 0;
  80264c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802654:	e8 cc f6 ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	e8 c4 f6 ff ff       	call   801d25 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802661:	89 d8                	mov    %ebx,%eax
  802663:	83 c4 24             	add    $0x24,%esp
  802666:	5b                   	pop    %ebx
  802667:	5d                   	pop    %ebp
  802668:	c3                   	ret    

00802669 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
  802671:	5d                   	pop    %ebp
  802672:	c3                   	ret    

00802673 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	57                   	push   %edi
  802677:	56                   	push   %esi
  802678:	53                   	push   %ebx
  802679:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  80267f:	c7 04 24 cd 1d 80 00 	movl   $0x801dcd,(%esp)
  802686:	e8 30 eb ff ff       	call   8011bb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  80268b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802690:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802695:	74 28                	je     8026bf <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802697:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  80269e:	4a 
  80269f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026a3:	c7 44 24 08 8c 50 80 	movl   $0x80508c,0x8(%esp)
  8026aa:	00 
  8026ab:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  8026b2:	00 
  8026b3:	c7 04 24 06 50 80 00 	movl   $0x805006,(%esp)
  8026ba:	e8 ed 1a 00 00       	call   8041ac <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  8026bf:	a1 04 10 00 50       	mov    0x50001004,%eax
  8026c4:	83 f8 03             	cmp    $0x3,%eax
  8026c7:	7f 1c                	jg     8026e5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  8026c9:	c7 44 24 08 c0 50 80 	movl   $0x8050c0,0x8(%esp)
  8026d0:	00 
  8026d1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  8026d8:	00 
  8026d9:	c7 04 24 06 50 80 00 	movl   $0x805006,(%esp)
  8026e0:	e8 c7 1a 00 00       	call   8041ac <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  8026e5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  8026eb:	85 d2                	test   %edx,%edx
  8026ed:	7f 1c                	jg     80270b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  8026ef:	c7 44 24 08 f0 50 80 	movl   $0x8050f0,0x8(%esp)
  8026f6:	00 
  8026f7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  8026fe:	00 
  8026ff:	c7 04 24 06 50 80 00 	movl   $0x805006,(%esp)
  802706:	e8 a1 1a 00 00       	call   8041ac <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80270b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802711:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802717:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80271d:	85 c9                	test   %ecx,%ecx
  80271f:	0f 48 cb             	cmovs  %ebx,%ecx
  802722:	c1 f9 0c             	sar    $0xc,%ecx
  802725:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802729:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80272f:	39 c8                	cmp    %ecx,%eax
  802731:	7c 13                	jl     802746 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802733:	85 c0                	test   %eax,%eax
  802735:	7f 3d                	jg     802774 <_Z4fsckv+0x101>
  802737:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80273e:	00 00 00 
  802741:	e9 ac 00 00 00       	jmp    8027f2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802746:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80274c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802750:	89 44 24 10          	mov    %eax,0x10(%esp)
  802754:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802758:	c7 44 24 08 20 51 80 	movl   $0x805120,0x8(%esp)
  80275f:	00 
  802760:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802767:	00 
  802768:	c7 04 24 06 50 80 00 	movl   $0x805006,(%esp)
  80276f:	e8 38 1a 00 00       	call   8041ac <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802774:	be 00 20 00 50       	mov    $0x50002000,%esi
  802779:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802780:	00 00 00 
  802783:	bb 00 00 00 00       	mov    $0x0,%ebx
  802788:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  80278e:	39 df                	cmp    %ebx,%edi
  802790:	7e 27                	jle    8027b9 <_Z4fsckv+0x146>
  802792:	0f b6 06             	movzbl (%esi),%eax
  802795:	84 c0                	test   %al,%al
  802797:	74 4b                	je     8027e4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802799:	0f be c0             	movsbl %al,%eax
  80279c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027a4:	c7 04 24 64 51 80 00 	movl   $0x805164,(%esp)
  8027ab:	e8 6e da ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  8027b0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8027b7:	eb 2b                	jmp    8027e4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  8027b9:	0f b6 06             	movzbl (%esi),%eax
  8027bc:	3c 01                	cmp    $0x1,%al
  8027be:	76 24                	jbe    8027e4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  8027c0:	0f be c0             	movsbl %al,%eax
  8027c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027cb:	c7 04 24 98 51 80 00 	movl   $0x805198,(%esp)
  8027d2:	e8 47 da ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  8027d7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  8027de:	80 3e 00             	cmpb   $0x0,(%esi)
  8027e1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8027e4:	83 c3 01             	add    $0x1,%ebx
  8027e7:	83 c6 01             	add    $0x1,%esi
  8027ea:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8027f0:	7f 9c                	jg     80278e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8027f2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8027f9:	0f 8e e1 02 00 00    	jle    802ae0 <_Z4fsckv+0x46d>
  8027ff:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802806:	00 00 00 
		struct Inode *ino = get_inode(i);
  802809:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80280f:	e8 f9 f1 ff ff       	call   801a0d <_ZL9get_inodei>
  802814:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80281a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80281e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802825:	75 22                	jne    802849 <_Z4fsckv+0x1d6>
  802827:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80282e:	0f 84 a9 06 00 00    	je     802edd <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802834:	ba 00 00 00 00       	mov    $0x0,%edx
  802839:	e8 2d f2 ff ff       	call   801a6b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 3a                	je     80287c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802842:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802849:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80284f:	8b 02                	mov    (%edx),%eax
  802851:	83 f8 01             	cmp    $0x1,%eax
  802854:	74 26                	je     80287c <_Z4fsckv+0x209>
  802856:	83 f8 02             	cmp    $0x2,%eax
  802859:	74 21                	je     80287c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80285b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80285f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802865:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802869:	c7 04 24 c4 51 80 00 	movl   $0x8051c4,(%esp)
  802870:	e8 a9 d9 ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  802875:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80287c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802883:	75 3f                	jne    8028c4 <_Z4fsckv+0x251>
  802885:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80288b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80288f:	75 15                	jne    8028a6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802891:	c7 04 24 e8 51 80 00 	movl   $0x8051e8,(%esp)
  802898:	e8 81 d9 ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  80289d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8028a4:	eb 1e                	jmp    8028c4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  8028a6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8028ac:	83 3a 02             	cmpl   $0x2,(%edx)
  8028af:	74 13                	je     8028c4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8028b1:	c7 04 24 1c 52 80 00 	movl   $0x80521c,(%esp)
  8028b8:	e8 61 d9 ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  8028bd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  8028c4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  8028c9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8028d0:	0f 84 93 00 00 00    	je     802969 <_Z4fsckv+0x2f6>
  8028d6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8028dc:	8b 41 08             	mov    0x8(%ecx),%eax
  8028df:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  8028e4:	7e 23                	jle    802909 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  8028e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028ea:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8028f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f4:	c7 04 24 4c 52 80 00 	movl   $0x80524c,(%esp)
  8028fb:	e8 1e d9 ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  802900:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802907:	eb 09                	jmp    802912 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802909:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802910:	74 4b                	je     80295d <_Z4fsckv+0x2ea>
  802912:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802918:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80291e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802924:	74 23                	je     802949 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802926:	89 44 24 08          	mov    %eax,0x8(%esp)
  80292a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802930:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802934:	c7 04 24 70 52 80 00 	movl   $0x805270,(%esp)
  80293b:	e8 de d8 ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  802940:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802947:	eb 09                	jmp    802952 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802949:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802950:	74 12                	je     802964 <_Z4fsckv+0x2f1>
  802952:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802958:	8b 78 08             	mov    0x8(%eax),%edi
  80295b:	eb 0c                	jmp    802969 <_Z4fsckv+0x2f6>
  80295d:	bf 00 00 00 00       	mov    $0x0,%edi
  802962:	eb 05                	jmp    802969 <_Z4fsckv+0x2f6>
  802964:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802969:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  80296e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802974:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802978:	89 d8                	mov    %ebx,%eax
  80297a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  80297d:	39 c7                	cmp    %eax,%edi
  80297f:	7e 2b                	jle    8029ac <_Z4fsckv+0x339>
  802981:	85 f6                	test   %esi,%esi
  802983:	75 27                	jne    8029ac <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802985:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802989:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80298d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802993:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802997:	c7 04 24 94 52 80 00 	movl   $0x805294,(%esp)
  80299e:	e8 7b d8 ff ff       	call   80021e <_Z7cprintfPKcz>
				++errors;
  8029a3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8029aa:	eb 36                	jmp    8029e2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  8029ac:	39 f8                	cmp    %edi,%eax
  8029ae:	7c 32                	jl     8029e2 <_Z4fsckv+0x36f>
  8029b0:	85 f6                	test   %esi,%esi
  8029b2:	74 2e                	je     8029e2 <_Z4fsckv+0x36f>
  8029b4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8029bb:	74 25                	je     8029e2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8029bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029c1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029c5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8029cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029cf:	c7 04 24 d8 52 80 00 	movl   $0x8052d8,(%esp)
  8029d6:	e8 43 d8 ff ff       	call   80021e <_Z7cprintfPKcz>
				++errors;
  8029db:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  8029e2:	85 f6                	test   %esi,%esi
  8029e4:	0f 84 a0 00 00 00    	je     802a8a <_Z4fsckv+0x417>
  8029ea:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8029f1:	0f 84 93 00 00 00    	je     802a8a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  8029f7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8029fd:	7e 27                	jle    802a26 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  8029ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a07:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802a0d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a11:	c7 04 24 1c 53 80 00 	movl   $0x80531c,(%esp)
  802a18:	e8 01 d8 ff ff       	call   80021e <_Z7cprintfPKcz>
					++errors;
  802a1d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a24:	eb 64                	jmp    802a8a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802a26:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802a2d:	3c 01                	cmp    $0x1,%al
  802a2f:	75 27                	jne    802a58 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802a31:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a35:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a39:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802a3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a43:	c7 04 24 60 53 80 00 	movl   $0x805360,(%esp)
  802a4a:	e8 cf d7 ff ff       	call   80021e <_Z7cprintfPKcz>
					++errors;
  802a4f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a56:	eb 32                	jmp    802a8a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802a58:	3c ff                	cmp    $0xff,%al
  802a5a:	75 27                	jne    802a83 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802a5c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a60:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a64:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6e:	c7 04 24 9c 53 80 00 	movl   $0x80539c,(%esp)
  802a75:	e8 a4 d7 ff ff       	call   80021e <_Z7cprintfPKcz>
					++errors;
  802a7a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a81:	eb 07                	jmp    802a8a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802a83:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802a8a:	83 c3 01             	add    $0x1,%ebx
  802a8d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802a93:	0f 85 d5 fe ff ff    	jne    80296e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802a99:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802aa0:	0f 94 c0             	sete   %al
  802aa3:	0f b6 c0             	movzbl %al,%eax
  802aa6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802aac:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802ab2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802ab9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802ac0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802ac7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802ace:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802ad4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802ada:	0f 8f 29 fd ff ff    	jg     802809 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802ae0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802ae7:	0f 8e 7f 03 00 00    	jle    802e6c <_Z4fsckv+0x7f9>
  802aed:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802af2:	89 f0                	mov    %esi,%eax
  802af4:	e8 14 ef ff ff       	call   801a0d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802af9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802b00:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802b07:	c1 e2 08             	shl    $0x8,%edx
  802b0a:	09 ca                	or     %ecx,%edx
  802b0c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802b13:	c1 e1 10             	shl    $0x10,%ecx
  802b16:	09 ca                	or     %ecx,%edx
  802b18:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802b1f:	83 e1 7f             	and    $0x7f,%ecx
  802b22:	c1 e1 18             	shl    $0x18,%ecx
  802b25:	09 d1                	or     %edx,%ecx
  802b27:	74 0e                	je     802b37 <_Z4fsckv+0x4c4>
  802b29:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802b30:	78 05                	js     802b37 <_Z4fsckv+0x4c4>
  802b32:	83 38 02             	cmpl   $0x2,(%eax)
  802b35:	74 1f                	je     802b56 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b37:	83 c6 01             	add    $0x1,%esi
  802b3a:	a1 08 10 00 50       	mov    0x50001008,%eax
  802b3f:	39 f0                	cmp    %esi,%eax
  802b41:	7f af                	jg     802af2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802b43:	bb 01 00 00 00       	mov    $0x1,%ebx
  802b48:	83 f8 01             	cmp    $0x1,%eax
  802b4b:	0f 8f ad 02 00 00    	jg     802dfe <_Z4fsckv+0x78b>
  802b51:	e9 16 03 00 00       	jmp    802e6c <_Z4fsckv+0x7f9>
  802b56:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802b58:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802b5f:	8b 40 08             	mov    0x8(%eax),%eax
  802b62:	a8 7f                	test   $0x7f,%al
  802b64:	74 23                	je     802b89 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802b66:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802b6d:	00 
  802b6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b72:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b76:	c7 04 24 d8 53 80 00 	movl   $0x8053d8,(%esp)
  802b7d:	e8 9c d6 ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  802b82:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b89:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802b90:	00 00 00 
  802b93:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802b99:	e9 3d 02 00 00       	jmp    802ddb <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802b9e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802ba4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802baa:	e8 01 ee ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
  802baf:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802bb1:	83 38 00             	cmpl   $0x0,(%eax)
  802bb4:	0f 84 15 02 00 00    	je     802dcf <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802bba:	8b 40 04             	mov    0x4(%eax),%eax
  802bbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  802bc0:	83 fa 76             	cmp    $0x76,%edx
  802bc3:	76 27                	jbe    802bec <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802bc5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bc9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802bcf:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bd3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bd7:	c7 04 24 0c 54 80 00 	movl   $0x80540c,(%esp)
  802bde:	e8 3b d6 ff ff       	call   80021e <_Z7cprintfPKcz>
				++errors;
  802be3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802bea:	eb 28                	jmp    802c14 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802bec:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802bf1:	74 21                	je     802c14 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802bf3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802bf9:	89 54 24 08          	mov    %edx,0x8(%esp)
  802bfd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c01:	c7 04 24 38 54 80 00 	movl   $0x805438,(%esp)
  802c08:	e8 11 d6 ff ff       	call   80021e <_Z7cprintfPKcz>
				++errors;
  802c0d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802c14:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802c1b:	00 
  802c1c:	8d 43 08             	lea    0x8(%ebx),%eax
  802c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c23:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802c29:	89 0c 24             	mov    %ecx,(%esp)
  802c2c:	e8 26 de ff ff       	call   800a57 <memcpy>
  802c31:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802c35:	bf 77 00 00 00       	mov    $0x77,%edi
  802c3a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802c3e:	85 ff                	test   %edi,%edi
  802c40:	b8 00 00 00 00       	mov    $0x0,%eax
  802c45:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802c48:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802c4f:	00 

			if (de->de_inum >= super->s_ninodes) {
  802c50:	8b 03                	mov    (%ebx),%eax
  802c52:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802c58:	7c 3e                	jl     802c98 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802c5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c5e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802c64:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c68:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c6e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c72:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c76:	c7 04 24 6c 54 80 00 	movl   $0x80546c,(%esp)
  802c7d:	e8 9c d5 ff ff       	call   80021e <_Z7cprintfPKcz>
				++errors;
  802c82:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802c89:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802c90:	00 00 00 
  802c93:	e9 0b 01 00 00       	jmp    802da3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802c98:	e8 70 ed ff ff       	call   801a0d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802c9d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802ca4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802cab:	c1 e2 08             	shl    $0x8,%edx
  802cae:	09 d1                	or     %edx,%ecx
  802cb0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802cb7:	c1 e2 10             	shl    $0x10,%edx
  802cba:	09 d1                	or     %edx,%ecx
  802cbc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802cc3:	83 e2 7f             	and    $0x7f,%edx
  802cc6:	c1 e2 18             	shl    $0x18,%edx
  802cc9:	09 ca                	or     %ecx,%edx
  802ccb:	83 c2 01             	add    $0x1,%edx
  802cce:	89 d1                	mov    %edx,%ecx
  802cd0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802cd6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802cdc:	0f b6 d5             	movzbl %ch,%edx
  802cdf:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802ce5:	89 ca                	mov    %ecx,%edx
  802ce7:	c1 ea 10             	shr    $0x10,%edx
  802cea:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802cf0:	c1 e9 18             	shr    $0x18,%ecx
  802cf3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802cfa:	83 e2 80             	and    $0xffffff80,%edx
  802cfd:	09 ca                	or     %ecx,%edx
  802cff:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802d05:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802d09:	0f 85 7a ff ff ff    	jne    802c89 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802d0f:	8b 03                	mov    (%ebx),%eax
  802d11:	89 44 24 10          	mov    %eax,0x10(%esp)
  802d15:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802d1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802d1f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802d25:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d29:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d2d:	c7 04 24 9c 54 80 00 	movl   $0x80549c,(%esp)
  802d34:	e8 e5 d4 ff ff       	call   80021e <_Z7cprintfPKcz>
					++errors;
  802d39:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d40:	e9 44 ff ff ff       	jmp    802c89 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802d45:	3b 78 04             	cmp    0x4(%eax),%edi
  802d48:	75 52                	jne    802d9c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802d4a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802d4e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802d54:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d58:	83 c0 08             	add    $0x8,%eax
  802d5b:	89 04 24             	mov    %eax,(%esp)
  802d5e:	e8 35 dd ff ff       	call   800a98 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802d63:	85 c0                	test   %eax,%eax
  802d65:	75 35                	jne    802d9c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802d67:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802d6d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d71:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802d77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d7b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d81:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d85:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d89:	c7 04 24 cc 54 80 00 	movl   $0x8054cc,(%esp)
  802d90:	e8 89 d4 ff ff       	call   80021e <_Z7cprintfPKcz>
					++errors;
  802d95:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802d9c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802da3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802da9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802daf:	7e 1e                	jle    802dcf <_Z4fsckv+0x75c>
  802db1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802db5:	7f 18                	jg     802dcf <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802db7:	89 ca                	mov    %ecx,%edx
  802db9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802dbf:	e8 ec eb ff ff       	call   8019b0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802dc4:	83 38 00             	cmpl   $0x0,(%eax)
  802dc7:	0f 85 78 ff ff ff    	jne    802d45 <_Z4fsckv+0x6d2>
  802dcd:	eb cd                	jmp    802d9c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802dcf:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802dd5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802ddb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802de1:	83 ea 80             	sub    $0xffffff80,%edx
  802de4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802dea:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802df0:	3b 51 08             	cmp    0x8(%ecx),%edx
  802df3:	0f 8f e7 fc ff ff    	jg     802ae0 <_Z4fsckv+0x46d>
  802df9:	e9 a0 fd ff ff       	jmp    802b9e <_Z4fsckv+0x52b>
  802dfe:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802e04:	89 d8                	mov    %ebx,%eax
  802e06:	e8 02 ec ff ff       	call   801a0d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802e0b:	8b 50 04             	mov    0x4(%eax),%edx
  802e0e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802e15:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  802e1c:	c1 e7 08             	shl    $0x8,%edi
  802e1f:	09 f9                	or     %edi,%ecx
  802e21:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  802e28:	c1 e7 10             	shl    $0x10,%edi
  802e2b:	09 f9                	or     %edi,%ecx
  802e2d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  802e34:	83 e7 7f             	and    $0x7f,%edi
  802e37:	c1 e7 18             	shl    $0x18,%edi
  802e3a:	09 f9                	or     %edi,%ecx
  802e3c:	39 ca                	cmp    %ecx,%edx
  802e3e:	74 1b                	je     802e5b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  802e40:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e44:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e48:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e4c:	c7 04 24 fc 54 80 00 	movl   $0x8054fc,(%esp)
  802e53:	e8 c6 d3 ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  802e58:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802e5b:	83 c3 01             	add    $0x1,%ebx
  802e5e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802e64:	7f 9e                	jg     802e04 <_Z4fsckv+0x791>
  802e66:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802e6c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802e73:	7e 4f                	jle    802ec4 <_Z4fsckv+0x851>
  802e75:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e7a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  802e80:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  802e87:	3c ff                	cmp    $0xff,%al
  802e89:	75 09                	jne    802e94 <_Z4fsckv+0x821>
			freemap[i] = 0;
  802e8b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  802e92:	eb 1f                	jmp    802eb3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  802e94:	84 c0                	test   %al,%al
  802e96:	75 1b                	jne    802eb3 <_Z4fsckv+0x840>
  802e98:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  802e9e:	7c 13                	jl     802eb3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  802ea0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ea4:	c7 04 24 28 55 80 00 	movl   $0x805528,(%esp)
  802eab:	e8 6e d3 ff ff       	call   80021e <_Z7cprintfPKcz>
			++errors;
  802eb0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802eb3:	83 c3 01             	add    $0x1,%ebx
  802eb6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802ebc:	7f c2                	jg     802e80 <_Z4fsckv+0x80d>
  802ebe:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  802ec4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  802ecb:	19 c0                	sbb    %eax,%eax
  802ecd:	f7 d0                	not    %eax
  802ecf:	83 e0 fd             	and    $0xfffffffd,%eax
}
  802ed2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  802ed8:	5b                   	pop    %ebx
  802ed9:	5e                   	pop    %esi
  802eda:	5f                   	pop    %edi
  802edb:	5d                   	pop    %ebp
  802edc:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802edd:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ee4:	0f 84 92 f9 ff ff    	je     80287c <_Z4fsckv+0x209>
  802eea:	e9 5a f9 ff ff       	jmp    802849 <_Z4fsckv+0x1d6>
	...

00802ef0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ef0:	55                   	push   %ebp
  802ef1:	89 e5                	mov    %esp,%ebp
  802ef3:	83 ec 18             	sub    $0x18,%esp
  802ef6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802ef9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802efc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	89 04 24             	mov    %eax,(%esp)
  802f05:	e8 a2 e4 ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  802f0a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802f0c:	c7 44 24 04 5b 55 80 	movl   $0x80555b,0x4(%esp)
  802f13:	00 
  802f14:	89 34 24             	mov    %esi,(%esp)
  802f17:	e8 1e d9 ff ff       	call   80083a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  802f1c:	8b 43 04             	mov    0x4(%ebx),%eax
  802f1f:	2b 03                	sub    (%ebx),%eax
  802f21:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  802f24:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  802f2b:	c7 86 80 00 00 00 20 	movl   $0x806020,0x80(%esi)
  802f32:	60 80 00 
	return 0;
}
  802f35:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802f3d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802f40:	89 ec                	mov    %ebp,%esp
  802f42:	5d                   	pop    %ebp
  802f43:	c3                   	ret    

00802f44 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  802f44:	55                   	push   %ebp
  802f45:	89 e5                	mov    %esp,%ebp
  802f47:	53                   	push   %ebx
  802f48:	83 ec 14             	sub    $0x14,%esp
  802f4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802f4e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f59:	e8 7f de ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  802f5e:	89 1c 24             	mov    %ebx,(%esp)
  802f61:	e8 46 e4 ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  802f66:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f71:	e8 67 de ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
}
  802f76:	83 c4 14             	add    $0x14,%esp
  802f79:	5b                   	pop    %ebx
  802f7a:	5d                   	pop    %ebp
  802f7b:	c3                   	ret    

00802f7c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f7c:	55                   	push   %ebp
  802f7d:	89 e5                	mov    %esp,%ebp
  802f7f:	57                   	push   %edi
  802f80:	56                   	push   %esi
  802f81:	53                   	push   %ebx
  802f82:	83 ec 2c             	sub    $0x2c,%esp
  802f85:	89 c7                	mov    %eax,%edi
  802f87:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  802f8a:	a1 00 70 80 00       	mov    0x807000,%eax
  802f8f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  802f92:	89 3c 24             	mov    %edi,(%esp)
  802f95:	e8 82 04 00 00       	call   80341c <_Z7pagerefPv>
  802f9a:	89 c3                	mov    %eax,%ebx
  802f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9f:	89 04 24             	mov    %eax,(%esp)
  802fa2:	e8 75 04 00 00       	call   80341c <_Z7pagerefPv>
  802fa7:	39 c3                	cmp    %eax,%ebx
  802fa9:	0f 94 c0             	sete   %al
  802fac:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  802faf:	8b 15 00 70 80 00    	mov    0x807000,%edx
  802fb5:	8b 52 58             	mov    0x58(%edx),%edx
  802fb8:	39 d6                	cmp    %edx,%esi
  802fba:	75 08                	jne    802fc4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  802fbc:	83 c4 2c             	add    $0x2c,%esp
  802fbf:	5b                   	pop    %ebx
  802fc0:	5e                   	pop    %esi
  802fc1:	5f                   	pop    %edi
  802fc2:	5d                   	pop    %ebp
  802fc3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 c2                	je     802f8a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  802fc8:	c7 04 24 62 55 80 00 	movl   $0x805562,(%esp)
  802fcf:	e8 4a d2 ff ff       	call   80021e <_Z7cprintfPKcz>
  802fd4:	eb b4                	jmp    802f8a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00802fd6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802fd6:	55                   	push   %ebp
  802fd7:	89 e5                	mov    %esp,%ebp
  802fd9:	57                   	push   %edi
  802fda:	56                   	push   %esi
  802fdb:	53                   	push   %ebx
  802fdc:	83 ec 1c             	sub    $0x1c,%esp
  802fdf:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802fe2:	89 34 24             	mov    %esi,(%esp)
  802fe5:	e8 c2 e3 ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  802fea:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802fec:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ff5:	75 46                	jne    80303d <_ZL13devpipe_writeP2FdPKvj+0x67>
  802ff7:	eb 52                	jmp    80304b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  802ff9:	89 da                	mov    %ebx,%edx
  802ffb:	89 f0                	mov    %esi,%eax
  802ffd:	e8 7a ff ff ff       	call   802f7c <_ZL13_pipeisclosedP2FdP4Pipe>
  803002:	85 c0                	test   %eax,%eax
  803004:	75 49                	jne    80304f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803006:	e8 e1 dc ff ff       	call   800cec <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80300b:	8b 43 04             	mov    0x4(%ebx),%eax
  80300e:	89 c2                	mov    %eax,%edx
  803010:	2b 13                	sub    (%ebx),%edx
  803012:	83 fa 20             	cmp    $0x20,%edx
  803015:	74 e2                	je     802ff9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803017:	89 c2                	mov    %eax,%edx
  803019:	c1 fa 1f             	sar    $0x1f,%edx
  80301c:	c1 ea 1b             	shr    $0x1b,%edx
  80301f:	01 d0                	add    %edx,%eax
  803021:	83 e0 1f             	and    $0x1f,%eax
  803024:	29 d0                	sub    %edx,%eax
  803026:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803029:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80302d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803031:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803035:	83 c7 01             	add    $0x1,%edi
  803038:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80303b:	76 0e                	jbe    80304b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80303d:	8b 43 04             	mov    0x4(%ebx),%eax
  803040:	89 c2                	mov    %eax,%edx
  803042:	2b 13                	sub    (%ebx),%edx
  803044:	83 fa 20             	cmp    $0x20,%edx
  803047:	74 b0                	je     802ff9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803049:	eb cc                	jmp    803017 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80304b:	89 f8                	mov    %edi,%eax
  80304d:	eb 05                	jmp    803054 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80304f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803054:	83 c4 1c             	add    $0x1c,%esp
  803057:	5b                   	pop    %ebx
  803058:	5e                   	pop    %esi
  803059:	5f                   	pop    %edi
  80305a:	5d                   	pop    %ebp
  80305b:	c3                   	ret    

0080305c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80305c:	55                   	push   %ebp
  80305d:	89 e5                	mov    %esp,%ebp
  80305f:	83 ec 28             	sub    $0x28,%esp
  803062:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803065:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803068:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80306b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80306e:	89 3c 24             	mov    %edi,(%esp)
  803071:	e8 36 e3 ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  803076:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803078:	be 00 00 00 00       	mov    $0x0,%esi
  80307d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803081:	75 47                	jne    8030ca <_ZL12devpipe_readP2FdPvj+0x6e>
  803083:	eb 52                	jmp    8030d7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803085:	89 f0                	mov    %esi,%eax
  803087:	eb 5e                	jmp    8030e7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803089:	89 da                	mov    %ebx,%edx
  80308b:	89 f8                	mov    %edi,%eax
  80308d:	8d 76 00             	lea    0x0(%esi),%esi
  803090:	e8 e7 fe ff ff       	call   802f7c <_ZL13_pipeisclosedP2FdP4Pipe>
  803095:	85 c0                	test   %eax,%eax
  803097:	75 49                	jne    8030e2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803099:	e8 4e dc ff ff       	call   800cec <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80309e:	8b 03                	mov    (%ebx),%eax
  8030a0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8030a3:	74 e4                	je     803089 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8030a5:	89 c2                	mov    %eax,%edx
  8030a7:	c1 fa 1f             	sar    $0x1f,%edx
  8030aa:	c1 ea 1b             	shr    $0x1b,%edx
  8030ad:	01 d0                	add    %edx,%eax
  8030af:	83 e0 1f             	and    $0x1f,%eax
  8030b2:	29 d0                	sub    %edx,%eax
  8030b4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8030b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030bc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8030bf:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8030c2:	83 c6 01             	add    $0x1,%esi
  8030c5:	39 75 10             	cmp    %esi,0x10(%ebp)
  8030c8:	76 0d                	jbe    8030d7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8030ca:	8b 03                	mov    (%ebx),%eax
  8030cc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8030cf:	75 d4                	jne    8030a5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8030d1:	85 f6                	test   %esi,%esi
  8030d3:	75 b0                	jne    803085 <_ZL12devpipe_readP2FdPvj+0x29>
  8030d5:	eb b2                	jmp    803089 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8030d7:	89 f0                	mov    %esi,%eax
  8030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030e0:	eb 05                	jmp    8030e7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8030e2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8030e7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8030ea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8030ed:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8030f0:	89 ec                	mov    %ebp,%esp
  8030f2:	5d                   	pop    %ebp
  8030f3:	c3                   	ret    

008030f4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030f4:	55                   	push   %ebp
  8030f5:	89 e5                	mov    %esp,%ebp
  8030f7:	83 ec 48             	sub    $0x48,%esp
  8030fa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8030fd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803100:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803103:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803106:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803109:	89 04 24             	mov    %eax,(%esp)
  80310c:	e8 b6 e2 ff ff       	call   8013c7 <_Z14fd_find_unusedPP2Fd>
  803111:	89 c3                	mov    %eax,%ebx
  803113:	85 c0                	test   %eax,%eax
  803115:	0f 88 0b 01 00 00    	js     803226 <_Z4pipePi+0x132>
  80311b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803122:	00 
  803123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803126:	89 44 24 04          	mov    %eax,0x4(%esp)
  80312a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803131:	e8 ea db ff ff       	call   800d20 <_Z14sys_page_allociPvi>
  803136:	89 c3                	mov    %eax,%ebx
  803138:	85 c0                	test   %eax,%eax
  80313a:	0f 89 f5 00 00 00    	jns    803235 <_Z4pipePi+0x141>
  803140:	e9 e1 00 00 00       	jmp    803226 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803145:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80314c:	00 
  80314d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803150:	89 44 24 04          	mov    %eax,0x4(%esp)
  803154:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80315b:	e8 c0 db ff ff       	call   800d20 <_Z14sys_page_allociPvi>
  803160:	89 c3                	mov    %eax,%ebx
  803162:	85 c0                	test   %eax,%eax
  803164:	0f 89 e2 00 00 00    	jns    80324c <_Z4pipePi+0x158>
  80316a:	e9 a4 00 00 00       	jmp    803213 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80316f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803172:	89 04 24             	mov    %eax,(%esp)
  803175:	e8 32 e2 ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  80317a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803181:	00 
  803182:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803186:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80318d:	00 
  80318e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803192:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803199:	e8 e1 db ff ff       	call   800d7f <_Z12sys_page_mapiPviS_i>
  80319e:	89 c3                	mov    %eax,%ebx
  8031a0:	85 c0                	test   %eax,%eax
  8031a2:	78 4c                	js     8031f0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8031a4:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8031aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8031af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031b9:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8031bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8031c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d1:	89 04 24             	mov    %eax,(%esp)
  8031d4:	e8 8b e1 ff ff       	call   801364 <_Z6fd2numP2Fd>
  8031d9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8031db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031de:	89 04 24             	mov    %eax,(%esp)
  8031e1:	e8 7e e1 ff ff       	call   801364 <_Z6fd2numP2Fd>
  8031e6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8031e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8031ee:	eb 36                	jmp    803226 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  8031f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031fb:	e8 dd db ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803200:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803203:	89 44 24 04          	mov    %eax,0x4(%esp)
  803207:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80320e:	e8 ca db ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80321a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803221:	e8 b7 db ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803226:	89 d8                	mov    %ebx,%eax
  803228:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80322b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80322e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803231:	89 ec                	mov    %ebp,%esp
  803233:	5d                   	pop    %ebp
  803234:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803235:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803238:	89 04 24             	mov    %eax,(%esp)
  80323b:	e8 87 e1 ff ff       	call   8013c7 <_Z14fd_find_unusedPP2Fd>
  803240:	89 c3                	mov    %eax,%ebx
  803242:	85 c0                	test   %eax,%eax
  803244:	0f 89 fb fe ff ff    	jns    803145 <_Z4pipePi+0x51>
  80324a:	eb c7                	jmp    803213 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80324c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324f:	89 04 24             	mov    %eax,(%esp)
  803252:	e8 55 e1 ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  803257:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803259:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803260:	00 
  803261:	89 44 24 04          	mov    %eax,0x4(%esp)
  803265:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80326c:	e8 af da ff ff       	call   800d20 <_Z14sys_page_allociPvi>
  803271:	89 c3                	mov    %eax,%ebx
  803273:	85 c0                	test   %eax,%eax
  803275:	0f 89 f4 fe ff ff    	jns    80316f <_Z4pipePi+0x7b>
  80327b:	eb 83                	jmp    803200 <_Z4pipePi+0x10c>

0080327d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80327d:	55                   	push   %ebp
  80327e:	89 e5                	mov    %esp,%ebp
  803280:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803283:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80328a:	00 
  80328b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80328e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	89 04 24             	mov    %eax,(%esp)
  803298:	e8 74 e0 ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  80329d:	85 c0                	test   %eax,%eax
  80329f:	78 15                	js     8032b6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	89 04 24             	mov    %eax,(%esp)
  8032a7:	e8 00 e1 ff ff       	call   8013ac <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  8032ac:	89 c2                	mov    %eax,%edx
  8032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b1:	e8 c6 fc ff ff       	call   802f7c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8032b6:	c9                   	leave  
  8032b7:	c3                   	ret    

008032b8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8032b8:	55                   	push   %ebp
  8032b9:	89 e5                	mov    %esp,%ebp
  8032bb:	53                   	push   %ebx
  8032bc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8032bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032c2:	89 04 24             	mov    %eax,(%esp)
  8032c5:	e8 fd e0 ff ff       	call   8013c7 <_Z14fd_find_unusedPP2Fd>
  8032ca:	89 c3                	mov    %eax,%ebx
  8032cc:	85 c0                	test   %eax,%eax
  8032ce:	0f 88 be 00 00 00    	js     803392 <_Z18pipe_ipc_recv_readv+0xda>
  8032d4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8032db:	00 
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032ea:	e8 31 da ff ff       	call   800d20 <_Z14sys_page_allociPvi>
  8032ef:	89 c3                	mov    %eax,%ebx
  8032f1:	85 c0                	test   %eax,%eax
  8032f3:	0f 89 a1 00 00 00    	jns    80339a <_Z18pipe_ipc_recv_readv+0xe2>
  8032f9:	e9 94 00 00 00       	jmp    803392 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  8032fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803301:	85 c0                	test   %eax,%eax
  803303:	75 0e                	jne    803313 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803305:	c7 04 24 c0 55 80 00 	movl   $0x8055c0,(%esp)
  80330c:	e8 0d cf ff ff       	call   80021e <_Z7cprintfPKcz>
  803311:	eb 10                	jmp    803323 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803313:	89 44 24 04          	mov    %eax,0x4(%esp)
  803317:	c7 04 24 75 55 80 00 	movl   $0x805575,(%esp)
  80331e:	e8 fb ce ff ff       	call   80021e <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803323:	c7 04 24 7f 55 80 00 	movl   $0x80557f,(%esp)
  80332a:	e8 ef ce ff ff       	call   80021e <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80332f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803332:	a8 04                	test   $0x4,%al
  803334:	74 04                	je     80333a <_Z18pipe_ipc_recv_readv+0x82>
  803336:	a8 01                	test   $0x1,%al
  803338:	75 24                	jne    80335e <_Z18pipe_ipc_recv_readv+0xa6>
  80333a:	c7 44 24 0c 92 55 80 	movl   $0x805592,0xc(%esp)
  803341:	00 
  803342:	c7 44 24 08 5c 4f 80 	movl   $0x804f5c,0x8(%esp)
  803349:	00 
  80334a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803351:	00 
  803352:	c7 04 24 af 55 80 00 	movl   $0x8055af,(%esp)
  803359:	e8 4e 0e 00 00       	call   8041ac <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80335e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803373:	89 04 24             	mov    %eax,(%esp)
  803376:	e8 e9 df ff ff       	call   801364 <_Z6fd2numP2Fd>
  80337b:	89 c3                	mov    %eax,%ebx
  80337d:	eb 13                	jmp    803392 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803382:	89 44 24 04          	mov    %eax,0x4(%esp)
  803386:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80338d:	e8 4b da ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803392:	89 d8                	mov    %ebx,%eax
  803394:	83 c4 24             	add    $0x24,%esp
  803397:	5b                   	pop    %ebx
  803398:	5d                   	pop    %ebp
  803399:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	89 04 24             	mov    %eax,(%esp)
  8033a0:	e8 07 e0 ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  8033a5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8033a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8033ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8033b3:	89 04 24             	mov    %eax,(%esp)
  8033b6:	e8 85 0e 00 00       	call   804240 <_Z8ipc_recvPiPvS_>
  8033bb:	89 c3                	mov    %eax,%ebx
  8033bd:	85 c0                	test   %eax,%eax
  8033bf:	0f 89 39 ff ff ff    	jns    8032fe <_Z18pipe_ipc_recv_readv+0x46>
  8033c5:	eb b8                	jmp    80337f <_Z18pipe_ipc_recv_readv+0xc7>

008033c7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  8033c7:	55                   	push   %ebp
  8033c8:	89 e5                	mov    %esp,%ebp
  8033ca:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  8033cd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8033d4:	00 
  8033d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8033d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033df:	89 04 24             	mov    %eax,(%esp)
  8033e2:	e8 2a df ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  8033e7:	85 c0                	test   %eax,%eax
  8033e9:	78 2f                	js     80341a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	89 04 24             	mov    %eax,(%esp)
  8033f1:	e8 b6 df ff ff       	call   8013ac <_Z7fd2dataP2Fd>
  8033f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8033fd:	00 
  8033fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  803402:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803409:	00 
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	89 04 24             	mov    %eax,(%esp)
  803410:	e8 ba 0e 00 00       	call   8042cf <_Z8ipc_sendijPvi>
    return 0;
  803415:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80341a:	c9                   	leave  
  80341b:	c3                   	ret    

0080341c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80341c:	55                   	push   %ebp
  80341d:	89 e5                	mov    %esp,%ebp
  80341f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803422:	89 d0                	mov    %edx,%eax
  803424:	c1 e8 16             	shr    $0x16,%eax
  803427:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  80342e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803433:	f6 c1 01             	test   $0x1,%cl
  803436:	74 1d                	je     803455 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803438:	c1 ea 0c             	shr    $0xc,%edx
  80343b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803442:	f6 c2 01             	test   $0x1,%dl
  803445:	74 0e                	je     803455 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803447:	c1 ea 0c             	shr    $0xc,%edx
  80344a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803451:	ef 
  803452:	0f b7 c0             	movzwl %ax,%eax
}
  803455:	5d                   	pop    %ebp
  803456:	c3                   	ret    
	...

00803460 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803460:	55                   	push   %ebp
  803461:	89 e5                	mov    %esp,%ebp
  803463:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803466:	c7 44 24 04 e3 55 80 	movl   $0x8055e3,0x4(%esp)
  80346d:	00 
  80346e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803471:	89 04 24             	mov    %eax,(%esp)
  803474:	e8 c1 d3 ff ff       	call   80083a <_Z6strcpyPcPKc>
	return 0;
}
  803479:	b8 00 00 00 00       	mov    $0x0,%eax
  80347e:	c9                   	leave  
  80347f:	c3                   	ret    

00803480 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803480:	55                   	push   %ebp
  803481:	89 e5                	mov    %esp,%ebp
  803483:	53                   	push   %ebx
  803484:	83 ec 14             	sub    $0x14,%esp
  803487:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80348a:	89 1c 24             	mov    %ebx,(%esp)
  80348d:	e8 8a ff ff ff       	call   80341c <_Z7pagerefPv>
  803492:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803494:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803499:	83 fa 01             	cmp    $0x1,%edx
  80349c:	75 0b                	jne    8034a9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80349e:	8b 43 0c             	mov    0xc(%ebx),%eax
  8034a1:	89 04 24             	mov    %eax,(%esp)
  8034a4:	e8 fe 02 00 00       	call   8037a7 <_Z11nsipc_closei>
	else
		return 0;
}
  8034a9:	83 c4 14             	add    $0x14,%esp
  8034ac:	5b                   	pop    %ebx
  8034ad:	5d                   	pop    %ebp
  8034ae:	c3                   	ret    

008034af <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8034af:	55                   	push   %ebp
  8034b0:	89 e5                	mov    %esp,%ebp
  8034b2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8034b5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8034bc:	00 
  8034bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8034c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d1:	89 04 24             	mov    %eax,(%esp)
  8034d4:	e8 c9 03 00 00       	call   8038a2 <_Z10nsipc_sendiPKvij>
}
  8034d9:	c9                   	leave  
  8034da:	c3                   	ret    

008034db <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034db:	55                   	push   %ebp
  8034dc:	89 e5                	mov    %esp,%ebp
  8034de:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8034e8:	00 
  8034e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8034ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fd:	89 04 24             	mov    %eax,(%esp)
  803500:	e8 1d 03 00 00       	call   803822 <_Z10nsipc_recviPvij>
}
  803505:	c9                   	leave  
  803506:	c3                   	ret    

00803507 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803507:	55                   	push   %ebp
  803508:	89 e5                	mov    %esp,%ebp
  80350a:	83 ec 28             	sub    $0x28,%esp
  80350d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803510:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803513:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803515:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803518:	89 04 24             	mov    %eax,(%esp)
  80351b:	e8 a7 de ff ff       	call   8013c7 <_Z14fd_find_unusedPP2Fd>
  803520:	89 c3                	mov    %eax,%ebx
  803522:	85 c0                	test   %eax,%eax
  803524:	78 21                	js     803547 <_ZL12alloc_sockfdi+0x40>
  803526:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80352d:	00 
  80352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803531:	89 44 24 04          	mov    %eax,0x4(%esp)
  803535:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80353c:	e8 df d7 ff ff       	call   800d20 <_Z14sys_page_allociPvi>
  803541:	89 c3                	mov    %eax,%ebx
  803543:	85 c0                	test   %eax,%eax
  803545:	79 14                	jns    80355b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803547:	89 34 24             	mov    %esi,(%esp)
  80354a:	e8 58 02 00 00       	call   8037a7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  80354f:	89 d8                	mov    %ebx,%eax
  803551:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803554:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803557:	89 ec                	mov    %ebp,%esp
  803559:	5d                   	pop    %ebp
  80355a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  80355b:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  803561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803564:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803570:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803573:	89 04 24             	mov    %eax,(%esp)
  803576:	e8 e9 dd ff ff       	call   801364 <_Z6fd2numP2Fd>
  80357b:	89 c3                	mov    %eax,%ebx
  80357d:	eb d0                	jmp    80354f <_ZL12alloc_sockfdi+0x48>

0080357f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80357f:	55                   	push   %ebp
  803580:	89 e5                	mov    %esp,%ebp
  803582:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803585:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80358c:	00 
  80358d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803590:	89 54 24 04          	mov    %edx,0x4(%esp)
  803594:	89 04 24             	mov    %eax,(%esp)
  803597:	e8 75 dd ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  80359c:	85 c0                	test   %eax,%eax
  80359e:	78 15                	js     8035b5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8035a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  8035a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8035a8:	8b 0d 3c 60 80 00    	mov    0x80603c,%ecx
  8035ae:	39 0a                	cmp    %ecx,(%edx)
  8035b0:	75 03                	jne    8035b5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8035b2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8035b5:	c9                   	leave  
  8035b6:	c3                   	ret    

008035b7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035b7:	55                   	push   %ebp
  8035b8:	89 e5                	mov    %esp,%ebp
  8035ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	e8 ba ff ff ff       	call   80357f <_ZL9fd2sockidi>
  8035c5:	85 c0                	test   %eax,%eax
  8035c7:	78 1f                	js     8035e8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8035c9:	8b 55 10             	mov    0x10(%ebp),%edx
  8035cc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8035d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8035d7:	89 04 24             	mov    %eax,(%esp)
  8035da:	e8 19 01 00 00       	call   8036f8 <_Z12nsipc_acceptiP8sockaddrPj>
  8035df:	85 c0                	test   %eax,%eax
  8035e1:	78 05                	js     8035e8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  8035e3:	e8 1f ff ff ff       	call   803507 <_ZL12alloc_sockfdi>
}
  8035e8:	c9                   	leave  
  8035e9:	c3                   	ret    

008035ea <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035ea:	55                   	push   %ebp
  8035eb:	89 e5                	mov    %esp,%ebp
  8035ed:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	e8 87 ff ff ff       	call   80357f <_ZL9fd2sockidi>
  8035f8:	85 c0                	test   %eax,%eax
  8035fa:	78 16                	js     803612 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8035fc:	8b 55 10             	mov    0x10(%ebp),%edx
  8035ff:	89 54 24 08          	mov    %edx,0x8(%esp)
  803603:	8b 55 0c             	mov    0xc(%ebp),%edx
  803606:	89 54 24 04          	mov    %edx,0x4(%esp)
  80360a:	89 04 24             	mov    %eax,(%esp)
  80360d:	e8 34 01 00 00       	call   803746 <_Z10nsipc_bindiP8sockaddrj>
}
  803612:	c9                   	leave  
  803613:	c3                   	ret    

00803614 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803614:	55                   	push   %ebp
  803615:	89 e5                	mov    %esp,%ebp
  803617:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80361a:	8b 45 08             	mov    0x8(%ebp),%eax
  80361d:	e8 5d ff ff ff       	call   80357f <_ZL9fd2sockidi>
  803622:	85 c0                	test   %eax,%eax
  803624:	78 0f                	js     803635 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803626:	8b 55 0c             	mov    0xc(%ebp),%edx
  803629:	89 54 24 04          	mov    %edx,0x4(%esp)
  80362d:	89 04 24             	mov    %eax,(%esp)
  803630:	e8 50 01 00 00       	call   803785 <_Z14nsipc_shutdownii>
}
  803635:	c9                   	leave  
  803636:	c3                   	ret    

00803637 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803637:	55                   	push   %ebp
  803638:	89 e5                	mov    %esp,%ebp
  80363a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	e8 3a ff ff ff       	call   80357f <_ZL9fd2sockidi>
  803645:	85 c0                	test   %eax,%eax
  803647:	78 16                	js     80365f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803649:	8b 55 10             	mov    0x10(%ebp),%edx
  80364c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803650:	8b 55 0c             	mov    0xc(%ebp),%edx
  803653:	89 54 24 04          	mov    %edx,0x4(%esp)
  803657:	89 04 24             	mov    %eax,(%esp)
  80365a:	e8 62 01 00 00       	call   8037c1 <_Z13nsipc_connectiPK8sockaddrj>
}
  80365f:	c9                   	leave  
  803660:	c3                   	ret    

00803661 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803661:	55                   	push   %ebp
  803662:	89 e5                	mov    %esp,%ebp
  803664:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	e8 10 ff ff ff       	call   80357f <_ZL9fd2sockidi>
  80366f:	85 c0                	test   %eax,%eax
  803671:	78 0f                	js     803682 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803673:	8b 55 0c             	mov    0xc(%ebp),%edx
  803676:	89 54 24 04          	mov    %edx,0x4(%esp)
  80367a:	89 04 24             	mov    %eax,(%esp)
  80367d:	e8 7e 01 00 00       	call   803800 <_Z12nsipc_listenii>
}
  803682:	c9                   	leave  
  803683:	c3                   	ret    

00803684 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803684:	55                   	push   %ebp
  803685:	89 e5                	mov    %esp,%ebp
  803687:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80368a:	8b 45 10             	mov    0x10(%ebp),%eax
  80368d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803691:	8b 45 0c             	mov    0xc(%ebp),%eax
  803694:	89 44 24 04          	mov    %eax,0x4(%esp)
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	89 04 24             	mov    %eax,(%esp)
  80369e:	e8 72 02 00 00       	call   803915 <_Z12nsipc_socketiii>
  8036a3:	85 c0                	test   %eax,%eax
  8036a5:	78 05                	js     8036ac <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  8036a7:	e8 5b fe ff ff       	call   803507 <_ZL12alloc_sockfdi>
}
  8036ac:	c9                   	leave  
  8036ad:	8d 76 00             	lea    0x0(%esi),%esi
  8036b0:	c3                   	ret    
  8036b1:	00 00                	add    %al,(%eax)
	...

008036b4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8036b4:	55                   	push   %ebp
  8036b5:	89 e5                	mov    %esp,%ebp
  8036b7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8036ba:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8036c1:	00 
  8036c2:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8036c9:	00 
  8036ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036ce:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  8036d5:	e8 f5 0b 00 00       	call   8042cf <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  8036da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8036e1:	00 
  8036e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8036e9:	00 
  8036ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036f1:	e8 4a 0b 00 00       	call   804240 <_Z8ipc_recvPiPvS_>
}
  8036f6:	c9                   	leave  
  8036f7:	c3                   	ret    

008036f8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036f8:	55                   	push   %ebp
  8036f9:	89 e5                	mov    %esp,%ebp
  8036fb:	53                   	push   %ebx
  8036fc:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803707:	b8 01 00 00 00       	mov    $0x1,%eax
  80370c:	e8 a3 ff ff ff       	call   8036b4 <_ZL5nsipcj>
  803711:	89 c3                	mov    %eax,%ebx
  803713:	85 c0                	test   %eax,%eax
  803715:	78 27                	js     80373e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803717:	a1 10 80 80 00       	mov    0x808010,%eax
  80371c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803720:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803727:	00 
  803728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80372b:	89 04 24             	mov    %eax,(%esp)
  80372e:	e8 a9 d2 ff ff       	call   8009dc <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803733:	8b 15 10 80 80 00    	mov    0x808010,%edx
  803739:	8b 45 10             	mov    0x10(%ebp),%eax
  80373c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  80373e:	89 d8                	mov    %ebx,%eax
  803740:	83 c4 14             	add    $0x14,%esp
  803743:	5b                   	pop    %ebx
  803744:	5d                   	pop    %ebp
  803745:	c3                   	ret    

00803746 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803746:	55                   	push   %ebp
  803747:	89 e5                	mov    %esp,%ebp
  803749:	53                   	push   %ebx
  80374a:	83 ec 14             	sub    $0x14,%esp
  80374d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803750:	8b 45 08             	mov    0x8(%ebp),%eax
  803753:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803758:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80375c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803763:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80376a:	e8 6d d2 ff ff       	call   8009dc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80376f:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803775:	b8 02 00 00 00       	mov    $0x2,%eax
  80377a:	e8 35 ff ff ff       	call   8036b4 <_ZL5nsipcj>
}
  80377f:	83 c4 14             	add    $0x14,%esp
  803782:	5b                   	pop    %ebx
  803783:	5d                   	pop    %ebp
  803784:	c3                   	ret    

00803785 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803785:	55                   	push   %ebp
  803786:	89 e5                	mov    %esp,%ebp
  803788:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803793:	8b 45 0c             	mov    0xc(%ebp),%eax
  803796:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80379b:	b8 03 00 00 00       	mov    $0x3,%eax
  8037a0:	e8 0f ff ff ff       	call   8036b4 <_ZL5nsipcj>
}
  8037a5:	c9                   	leave  
  8037a6:	c3                   	ret    

008037a7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  8037a7:	55                   	push   %ebp
  8037a8:	89 e5                	mov    %esp,%ebp
  8037aa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8037b5:	b8 04 00 00 00       	mov    $0x4,%eax
  8037ba:	e8 f5 fe ff ff       	call   8036b4 <_ZL5nsipcj>
}
  8037bf:	c9                   	leave  
  8037c0:	c3                   	ret    

008037c1 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037c1:	55                   	push   %ebp
  8037c2:	89 e5                	mov    %esp,%ebp
  8037c4:	53                   	push   %ebx
  8037c5:	83 ec 14             	sub    $0x14,%esp
  8037c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8037cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ce:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037de:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8037e5:	e8 f2 d1 ff ff       	call   8009dc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8037ea:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8037f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8037f5:	e8 ba fe ff ff       	call   8036b4 <_ZL5nsipcj>
}
  8037fa:	83 c4 14             	add    $0x14,%esp
  8037fd:	5b                   	pop    %ebx
  8037fe:	5d                   	pop    %ebp
  8037ff:	c3                   	ret    

00803800 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803800:	55                   	push   %ebp
  803801:	89 e5                	mov    %esp,%ebp
  803803:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803806:	8b 45 08             	mov    0x8(%ebp),%eax
  803809:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  80380e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803811:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803816:	b8 06 00 00 00       	mov    $0x6,%eax
  80381b:	e8 94 fe ff ff       	call   8036b4 <_ZL5nsipcj>
}
  803820:	c9                   	leave  
  803821:	c3                   	ret    

00803822 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803822:	55                   	push   %ebp
  803823:	89 e5                	mov    %esp,%ebp
  803825:	56                   	push   %esi
  803826:	53                   	push   %ebx
  803827:	83 ec 10             	sub    $0x10,%esp
  80382a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803835:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80383b:	8b 45 14             	mov    0x14(%ebp),%eax
  80383e:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803843:	b8 07 00 00 00       	mov    $0x7,%eax
  803848:	e8 67 fe ff ff       	call   8036b4 <_ZL5nsipcj>
  80384d:	89 c3                	mov    %eax,%ebx
  80384f:	85 c0                	test   %eax,%eax
  803851:	78 46                	js     803899 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803853:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803858:	7f 04                	jg     80385e <_Z10nsipc_recviPvij+0x3c>
  80385a:	39 f0                	cmp    %esi,%eax
  80385c:	7e 24                	jle    803882 <_Z10nsipc_recviPvij+0x60>
  80385e:	c7 44 24 0c ef 55 80 	movl   $0x8055ef,0xc(%esp)
  803865:	00 
  803866:	c7 44 24 08 5c 4f 80 	movl   $0x804f5c,0x8(%esp)
  80386d:	00 
  80386e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803875:	00 
  803876:	c7 04 24 04 56 80 00 	movl   $0x805604,(%esp)
  80387d:	e8 2a 09 00 00       	call   8041ac <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803882:	89 44 24 08          	mov    %eax,0x8(%esp)
  803886:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80388d:	00 
  80388e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803891:	89 04 24             	mov    %eax,(%esp)
  803894:	e8 43 d1 ff ff       	call   8009dc <memmove>
	}

	return r;
}
  803899:	89 d8                	mov    %ebx,%eax
  80389b:	83 c4 10             	add    $0x10,%esp
  80389e:	5b                   	pop    %ebx
  80389f:	5e                   	pop    %esi
  8038a0:	5d                   	pop    %ebp
  8038a1:	c3                   	ret    

008038a2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8038a2:	55                   	push   %ebp
  8038a3:	89 e5                	mov    %esp,%ebp
  8038a5:	53                   	push   %ebx
  8038a6:	83 ec 14             	sub    $0x14,%esp
  8038a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8038b4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8038ba:	7e 24                	jle    8038e0 <_Z10nsipc_sendiPKvij+0x3e>
  8038bc:	c7 44 24 0c 10 56 80 	movl   $0x805610,0xc(%esp)
  8038c3:	00 
  8038c4:	c7 44 24 08 5c 4f 80 	movl   $0x804f5c,0x8(%esp)
  8038cb:	00 
  8038cc:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  8038d3:	00 
  8038d4:	c7 04 24 04 56 80 00 	movl   $0x805604,(%esp)
  8038db:	e8 cc 08 00 00       	call   8041ac <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8038e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038eb:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8038f2:	e8 e5 d0 ff ff       	call   8009dc <memmove>
	nsipcbuf.send.req_size = size;
  8038f7:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8038fd:	8b 45 14             	mov    0x14(%ebp),%eax
  803900:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  803905:	b8 08 00 00 00       	mov    $0x8,%eax
  80390a:	e8 a5 fd ff ff       	call   8036b4 <_ZL5nsipcj>
}
  80390f:	83 c4 14             	add    $0x14,%esp
  803912:	5b                   	pop    %ebx
  803913:	5d                   	pop    %ebp
  803914:	c3                   	ret    

00803915 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803915:	55                   	push   %ebp
  803916:	89 e5                	mov    %esp,%ebp
  803918:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80391b:	8b 45 08             	mov    0x8(%ebp),%eax
  80391e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803923:	8b 45 0c             	mov    0xc(%ebp),%eax
  803926:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  80392b:	8b 45 10             	mov    0x10(%ebp),%eax
  80392e:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  803933:	b8 09 00 00 00       	mov    $0x9,%eax
  803938:	e8 77 fd ff ff       	call   8036b4 <_ZL5nsipcj>
}
  80393d:	c9                   	leave  
  80393e:	c3                   	ret    
	...

00803940 <_ZL18migrate_send_stateiP9Trapframe>:

/*
 * Precondition and postcondition: f is a handle on an open file.
 */
static int
migrate_send_state(int f, struct Trapframe *tf) {
  803940:	55                   	push   %ebp
  803941:	89 e5                	mov    %esp,%ebp
  803943:	57                   	push   %edi
  803944:	56                   	push   %esi
  803945:	53                   	push   %ebx
  803946:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80394c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  80394f:	89 d6                	mov    %edx,%esi

	const size_t n_pages = UTOP >> 12;
	// Manual "div round up", so that truncation doesn't lead us to miss pages
    const size_t n_pdx = (UTOP >> 22) + (UTOP % (1 << 22) == 0 ? 0 : 1);

	cprintf("[%08x]: entering migrate_send_state\n", thisenv->env_id);	
  803951:	a1 00 70 80 00       	mov    0x807000,%eax
  803956:	8b 40 04             	mov    0x4(%eax),%eax
  803959:	89 44 24 04          	mov    %eax,0x4(%esp)
  80395d:	c7 04 24 1c 56 80 00 	movl   $0x80561c,(%esp)
  803964:	e8 b5 c8 ff ff       	call   80021e <_Z7cprintfPKcz>

	uint32_t n_used_pages = 0;
	unsigned pn;
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
  803969:	ba 00 00 00 00       	mov    $0x0,%edx
	// Manual "div round up", so that truncation doesn't lead us to miss pages
    const size_t n_pdx = (UTOP >> 22) + (UTOP % (1 << 22) == 0 ? 0 : 1);

	cprintf("[%08x]: entering migrate_send_state\n", thisenv->env_id);	

	uint32_t n_used_pages = 0;
  80396e:	bb 00 00 00 00       	mov    $0x0,%ebx
	unsigned pn;
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
        if(vpd[pdx] & PTE_P) {
  803973:	8b 04 95 00 e0 bb ef 	mov    -0x10442000(,%edx,4),%eax
  80397a:	a8 01                	test   $0x1,%al
  80397c:	74 2a                	je     8039a8 <_ZL18migrate_send_stateiP9Trapframe+0x68>
            for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
  80397e:	89 d0                	mov    %edx,%eax
  803980:	c1 e0 0a             	shl    $0xa,%eax
  803983:	3d ff ef 0e 00       	cmp    $0xeefff,%eax
  803988:	77 1e                	ja     8039a8 <_ZL18migrate_send_stateiP9Trapframe+0x68>
  80398a:	89 c1                	mov    %eax,%ecx
  80398c:	c1 e9 0a             	shr    $0xa,%ecx
  80398f:	39 d1                	cmp    %edx,%ecx
  803991:	75 15                	jne    8039a8 <_ZL18migrate_send_stateiP9Trapframe+0x68>
				if(vpt[pn] & PTE_P) {
  803993:	8b 0c 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%ecx
  80399a:	83 e1 01             	and    $0x1,%ecx
					n_used_pages++;
  80399d:	83 f9 01             	cmp    $0x1,%ecx
  8039a0:	83 db ff             	sbb    $0xffffffff,%ebx

	uint32_t n_used_pages = 0;
	unsigned pn;
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
        if(vpd[pdx] & PTE_P) {
            for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
  8039a3:	83 c0 01             	add    $0x1,%eax
  8039a6:	eb db                	jmp    803983 <_ZL18migrate_send_stateiP9Trapframe+0x43>

	cprintf("[%08x]: entering migrate_send_state\n", thisenv->env_id);	

	uint32_t n_used_pages = 0;
	unsigned pn;
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
  8039a8:	83 c2 01             	add    $0x1,%edx
  8039ab:	81 fa bc 03 00 00    	cmp    $0x3bc,%edx
  8039b1:	75 c0                	jne    803973 <_ZL18migrate_send_stateiP9Trapframe+0x33>
					n_used_pages++;
				}
			}
		}
	}
	sh.msh_n_pages = n_used_pages;
  8039b3:	89 5d 94             	mov    %ebx,-0x6c(%ebp)
    sh.msh_pgfault_upcall = thisenv->env_pgfault_upcall;
  8039b6:	a1 00 70 80 00       	mov    0x807000,%eax
  8039bb:	8b 40 5c             	mov    0x5c(%eax),%eax
  8039be:	89 45 90             	mov    %eax,-0x70(%ebp)
	sh.msh_magic = MIGRATE_MAGIC;
  8039c1:	c7 45 8c de ca fa 1e 	movl   $0x1efacade,-0x74(%ebp)
	sh.msh_tf = *tf;
  8039c8:	8d 7d 98             	lea    -0x68(%ebp),%edi
  8039cb:	b9 11 00 00 00       	mov    $0x11,%ecx
  8039d0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	if ((r = write(f, &sh, sizeof(struct MigrateSuperHeader)))
  8039d2:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  8039d9:	00 
  8039da:	8d 45 8c             	lea    -0x74(%ebp),%eax
  8039dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039e1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8039e4:	89 04 24             	mov    %eax,(%esp)
  8039e7:	e8 bd dd ff ff       	call   8017a9 <_Z5writeiPKvj>
  8039ec:	83 f8 50             	cmp    $0x50,%eax
  8039ef:	74 0f                	je     803a00 <_ZL18migrate_send_stateiP9Trapframe+0xc0>
				!= sizeof(struct MigrateSuperHeader)) {
		r = r < 0 ? r : -E_IO;
  8039f1:	85 c0                	test   %eax,%eax
  8039f3:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  8039f8:	0f 49 c2             	cmovns %edx,%eax
  8039fb:	e9 14 01 00 00       	jmp    803b14 <_ZL18migrate_send_stateiP9Trapframe+0x1d4>
		return r;
	}
	
	cprintf("[%08x]: migrate_send_state: sent super header\n", thisenv->env_id);	
  803a00:	a1 00 70 80 00       	mov    0x807000,%eax
  803a05:	8b 40 04             	mov    0x4(%eax),%eax
  803a08:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a0c:	c7 04 24 44 56 80 00 	movl   $0x805644,(%esp)
  803a13:	e8 06 c8 ff ff       	call   80021e <_Z7cprintfPKcz>
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
  803a18:	bf 00 00 00 00       	mov    $0x0,%edi
        if(vpd[pdx] & PTE_P) {
  803a1d:	8b 04 bd 00 e0 bb ef 	mov    -0x10442000(,%edi,4),%eax
  803a24:	a8 01                	test   $0x1,%al
  803a26:	0f 84 bc 00 00 00    	je     803ae8 <_ZL18migrate_send_stateiP9Trapframe+0x1a8>
			for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
  803a2c:	89 fe                	mov    %edi,%esi
  803a2e:	c1 e6 0a             	shl    $0xa,%esi
  803a31:	e9 91 00 00 00       	jmp    803ac7 <_ZL18migrate_send_stateiP9Trapframe+0x187>
				if(vpt[pn] & PTE_P) {
					h.mph_magic = MIGRATE_PG_MAGIC;
  803a36:	c7 45 dc 42 de ca de 	movl   $0xdecade42,-0x24(%ebp)
					h.mph_addr = (void *)VA_OF_VPN(pn);	
  803a3d:	89 f0                	mov    %esi,%eax
  803a3f:	c1 e0 0c             	shl    $0xc,%eax
  803a42:	89 45 e0             	mov    %eax,-0x20(%ebp)
					h.mph_perm = vpt[pn] & PTE_SYSCALL;
  803a45:	8b 04 b5 00 00 80 ef 	mov    -0x10800000(,%esi,4),%eax
  803a4c:	25 07 0e 00 00       	and    $0xe07,%eax
  803a51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					if ((r = write(f, &h, sizeof(struct MigratePageHeader)))
  803a54:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  803a5b:	00 
  803a5c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  803a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a63:	8b 45 84             	mov    -0x7c(%ebp),%eax
  803a66:	89 04 24             	mov    %eax,(%esp)
  803a69:	e8 3b dd ff ff       	call   8017a9 <_Z5writeiPKvj>
  803a6e:	83 f8 0c             	cmp    $0xc,%eax
  803a71:	74 0f                	je     803a82 <_ZL18migrate_send_stateiP9Trapframe+0x142>
							!= sizeof(struct MigratePageHeader)) {
						return r < 0 ? r : -E_IO;
  803a73:	85 c0                	test   %eax,%eax
  803a75:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  803a7a:	0f 49 c2             	cmovns %edx,%eax
  803a7d:	e9 92 00 00 00       	jmp    803b14 <_ZL18migrate_send_stateiP9Trapframe+0x1d4>
			for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
				if(vpt[pn] & PTE_P) {
					h.mph_magic = MIGRATE_PG_MAGIC;
					h.mph_addr = (void *)VA_OF_VPN(pn);	
					h.mph_perm = vpt[pn] & PTE_SYSCALL;
					if ((r = write(f, &h, sizeof(struct MigratePageHeader)))
  803a82:	bb 00 00 00 00       	mov    $0x0,%ebx
							!= sizeof(struct MigratePageHeader)) {
						return r < 0 ? r : -E_IO;
					}
                    for(int i = 0; i < 4; i++)
                    {
					    if ((r = write(f, (char *)h.mph_addr + PGSIZE / 4 * i, PGSIZE/4)) != PGSIZE/4) {
  803a87:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  803a8e:	00 
  803a8f:	89 d8                	mov    %ebx,%eax
  803a91:	03 45 e0             	add    -0x20(%ebp),%eax
  803a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a98:	8b 45 84             	mov    -0x7c(%ebp),%eax
  803a9b:	89 04 24             	mov    %eax,(%esp)
  803a9e:	e8 06 dd ff ff       	call   8017a9 <_Z5writeiPKvj>
  803aa3:	3d 00 04 00 00       	cmp    $0x400,%eax
  803aa8:	74 0c                	je     803ab6 <_ZL18migrate_send_stateiP9Trapframe+0x176>
						    return r < 0 ? r : -E_IO;
  803aaa:	85 c0                	test   %eax,%eax
  803aac:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  803ab1:	0f 49 c2             	cmovns %edx,%eax
  803ab4:	eb 5e                	jmp    803b14 <_ZL18migrate_send_stateiP9Trapframe+0x1d4>
  803ab6:	81 c3 00 04 00 00    	add    $0x400,%ebx
					h.mph_perm = vpt[pn] & PTE_SYSCALL;
					if ((r = write(f, &h, sizeof(struct MigratePageHeader)))
							!= sizeof(struct MigratePageHeader)) {
						return r < 0 ? r : -E_IO;
					}
                    for(int i = 0; i < 4; i++)
  803abc:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  803ac2:	75 c3                	jne    803a87 <_ZL18migrate_send_stateiP9Trapframe+0x147>
	}
	
	cprintf("[%08x]: migrate_send_state: sent super header\n", thisenv->env_id);	
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
        if(vpd[pdx] & PTE_P) {
			for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
  803ac4:	83 c6 01             	add    $0x1,%esi
  803ac7:	81 fe ff ef 0e 00    	cmp    $0xeefff,%esi
  803acd:	77 19                	ja     803ae8 <_ZL18migrate_send_stateiP9Trapframe+0x1a8>
  803acf:	89 f0                	mov    %esi,%eax
  803ad1:	c1 e8 0a             	shr    $0xa,%eax
  803ad4:	39 f8                	cmp    %edi,%eax
  803ad6:	75 10                	jne    803ae8 <_ZL18migrate_send_stateiP9Trapframe+0x1a8>
				if(vpt[pn] & PTE_P) {
  803ad8:	8b 04 b5 00 00 80 ef 	mov    -0x10800000(,%esi,4),%eax
  803adf:	a8 01                	test   $0x1,%al
  803ae1:	74 e1                	je     803ac4 <_ZL18migrate_send_stateiP9Trapframe+0x184>
  803ae3:	e9 4e ff ff ff       	jmp    803a36 <_ZL18migrate_send_stateiP9Trapframe+0xf6>
		r = r < 0 ? r : -E_IO;
		return r;
	}
	
	cprintf("[%08x]: migrate_send_state: sent super header\n", thisenv->env_id);	
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
  803ae8:	83 c7 01             	add    $0x1,%edi
  803aeb:	81 ff bc 03 00 00    	cmp    $0x3bc,%edi
  803af1:	0f 85 26 ff ff ff    	jne    803a1d <_ZL18migrate_send_stateiP9Trapframe+0xdd>
            }
        }
    }

	cprintf("[%08x]: migrate_send_state: done sending pages.\n",
				thisenv->env_id);
  803af7:	a1 00 70 80 00       	mov    0x807000,%eax
  803afc:	8b 40 04             	mov    0x4(%eax),%eax
  803aff:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b03:	c7 04 24 74 56 80 00 	movl   $0x805674,(%esp)
  803b0a:	e8 0f c7 ff ff       	call   80021e <_Z7cprintfPKcz>

	return 0;
  803b0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b14:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  803b1a:	5b                   	pop    %ebx
  803b1b:	5e                   	pop    %esi
  803b1c:	5f                   	pop    %edi
  803b1d:	5d                   	pop    %ebp
  803b1e:	c3                   	ret    

00803b1f <_ZL8mig_helpv>:
/*
 * Migrate, resuming execution at [callback].
 * This function returns < 0 on error.  On success, it does not return.
 */
static 
int mig_help(void) {
  803b1f:	55                   	push   %ebp
  803b20:	89 e5                	mov    %esp,%ebp
  803b22:	83 ec 18             	sub    $0x18,%esp
    cprintf("wtf\n");
  803b25:	c7 04 24 c1 58 80 00 	movl   $0x8058c1,(%esp)
  803b2c:	e8 ed c6 ff ff       	call   80021e <_Z7cprintfPKcz>
    thisenv = &envs[ENVX(sys_getenvid())];
  803b31:	e8 82 d1 ff ff       	call   800cb8 <_Z12sys_getenvidv>
  803b36:	25 ff 03 00 00       	and    $0x3ff,%eax
  803b3b:	6b c0 78             	imul   $0x78,%eax,%eax
  803b3e:	8d 90 00 00 00 ef    	lea    -0x11000000(%eax),%edx
  803b44:	89 15 00 70 80 00    	mov    %edx,0x807000
    cprintf("%x\n", thisenv->env_id);
  803b4a:	8b 80 04 00 00 ef    	mov    -0x10fffffc(%eax),%eax
  803b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b54:	c7 04 24 7b 55 80 00 	movl   $0x80557b,(%esp)
  803b5b:	e8 be c6 ff ff       	call   80021e <_Z7cprintfPKcz>
    return 0;
}
  803b60:	b8 00 00 00 00       	mov    $0x0,%eax
  803b65:	c9                   	leave  
  803b66:	c3                   	ret    

00803b67 <_Z13migrate_spawni>:
/*
 * Pre-condition: f is the file descriptor number of an open file descriptor.
 * The caller is responsible for closing this file.
 */
int
migrate_spawn(int f) {
  803b67:	55                   	push   %ebp
  803b68:	89 e5                	mov    %esp,%ebp
  803b6a:	57                   	push   %edi
  803b6b:	56                   	push   %esi
  803b6c:	53                   	push   %ebx
  803b6d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  803b73:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct MigrateSuperHeader sh;
	struct MigratePageHeader h;

	cprintf("[%08x] starting migrate_spawn\n", thisenv->env_id);
  803b76:	a1 00 70 80 00       	mov    0x807000,%eax
  803b7b:	8b 40 04             	mov    0x4(%eax),%eax
  803b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b82:	c7 04 24 a8 56 80 00 	movl   $0x8056a8,(%esp)
  803b89:	e8 90 c6 ff ff       	call   80021e <_Z7cprintfPKcz>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  803b8e:	bf 07 00 00 00       	mov    $0x7,%edi
  803b93:	89 f8                	mov    %edi,%eax
  803b95:	cd 30                	int    $0x30
  803b97:	89 c7                	mov    %eax,%edi
  803b99:	89 45 84             	mov    %eax,-0x7c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0) {
  803b9c:	85 c0                	test   %eax,%eax
  803b9e:	0f 88 f4 02 00 00    	js     803e98 <_Z13migrate_spawni+0x331>
		return envid;
	}
	if (envid == 0) {
  803ba4:	85 c0                	test   %eax,%eax
  803ba6:	75 1c                	jne    803bc4 <_Z13migrate_spawni+0x5d>
		panic("migrate_spawn: unreachable code in the child");
  803ba8:	c7 44 24 08 c8 56 80 	movl   $0x8056c8,0x8(%esp)
  803baf:	00 
  803bb0:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803bb7:	00 
  803bb8:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803bbf:	e8 e8 05 00 00       	call   8041ac <_Z6_panicPKciS0_z>
	}
	

	if ((r = readn(f, &sh, sizeof(struct MigrateSuperHeader)))
  803bc4:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  803bcb:	00 
  803bcc:	8d 45 8c             	lea    -0x74(%ebp),%eax
  803bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bd3:	89 34 24             	mov    %esi,(%esp)
  803bd6:	e8 7d db ff ff       	call   801758 <_Z5readniPvj>
  803bdb:	89 c3                	mov    %eax,%ebx
  803bdd:	83 f8 50             	cmp    $0x50,%eax
  803be0:	74 0f                	je     803bf1 <_Z13migrate_spawni+0x8a>
			!= sizeof(struct MigrateSuperHeader)) {
		r = (r < 0) ? r : -E_IO;
  803be2:	85 c0                	test   %eax,%eax
  803be4:	b8 ec ff ff ff       	mov    $0xffffffec,%eax
  803be9:	0f 49 d8             	cmovns %eax,%ebx
  803bec:	e9 9c 02 00 00       	jmp    803e8d <_Z13migrate_spawni+0x326>
		goto cleanup;
	}

	if (sh.msh_magic != MIGRATE_MAGIC) {
		// XXX: should we be make some custom error codes for migration?
		r = -E_NOT_EXEC;
  803bf1:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
			!= sizeof(struct MigrateSuperHeader)) {
		r = (r < 0) ? r : -E_IO;
		goto cleanup;
	}

	if (sh.msh_magic != MIGRATE_MAGIC) {
  803bf6:	81 7d 8c de ca fa 1e 	cmpl   $0x1efacade,-0x74(%ebp)
  803bfd:	0f 85 8a 02 00 00    	jne    803e8d <_Z13migrate_spawni+0x326>
		// XXX: should we be make some custom error codes for migration?
		r = -E_NOT_EXEC;
		goto cleanup;
	}
	cprintf("[%08x] migrate_spawn: read superheader\n", thisenv->env_id);
  803c03:	a1 00 70 80 00       	mov    0x807000,%eax
  803c08:	8b 40 04             	mov    0x4(%eax),%eax
  803c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c0f:	c7 04 24 f8 56 80 00 	movl   $0x8056f8,(%esp)
  803c16:	e8 03 c6 ff ff       	call   80021e <_Z7cprintfPKcz>
	
	for (uint32_t i = 0; i < sh.msh_n_pages; i++) {
  803c1b:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  803c1f:	0f 84 85 01 00 00    	je     803daa <_Z13migrate_spawni+0x243>
  803c25:	bb 00 00 00 00       	mov    $0x0,%ebx
		if ((r = readn(f, &h, sizeof(struct MigratePageHeader)))
  803c2a:	89 7d 80             	mov    %edi,-0x80(%ebp)
  803c2d:	89 df                	mov    %ebx,%edi
  803c2f:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  803c36:	00 
  803c37:	8d 45 dc             	lea    -0x24(%ebp),%eax
  803c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c3e:	89 34 24             	mov    %esi,(%esp)
  803c41:	e8 12 db ff ff       	call   801758 <_Z5readniPvj>
  803c46:	83 f8 0c             	cmp    $0xc,%eax
  803c49:	74 2a                	je     803c75 <_Z13migrate_spawni+0x10e>
				!= sizeof(struct MigratePageHeader)) {
			r = (r < 0) ? r : -E_IO;
  803c4b:	85 c0                	test   %eax,%eax
  803c4d:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  803c52:	0f 49 c2             	cmovns %edx,%eax
			panic("migrate_spawn: read page header: %e\n", r);
  803c55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c59:	c7 44 24 08 20 57 80 	movl   $0x805720,0x8(%esp)
  803c60:	00 
  803c61:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  803c68:	00 
  803c69:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803c70:	e8 37 05 00 00       	call   8041ac <_Z6_panicPKciS0_z>
			goto cleanup;
		}
		if (h.mph_magic != MIGRATE_PG_MAGIC) {
  803c75:	81 7d dc 42 de ca de 	cmpl   $0xdecade42,-0x24(%ebp)
  803c7c:	74 24                	je     803ca2 <_Z13migrate_spawni+0x13b>
			r =  -E_NOT_EXEC;
			panic("migrate_spawn: magic check failed. %e\n", r);
  803c7e:	c7 44 24 0c f7 ff ff 	movl   $0xfffffff7,0xc(%esp)
  803c85:	ff 
  803c86:	c7 44 24 08 48 57 80 	movl   $0x805748,0x8(%esp)
  803c8d:	00 
  803c8e:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803c95:	00 
  803c96:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803c9d:	e8 0a 05 00 00       	call   8041ac <_Z6_panicPKciS0_z>
			goto cleanup;
		}

		if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0) {
  803ca2:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803ca9:	00 
  803caa:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  803cb1:	00 
  803cb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803cb9:	e8 62 d0 ff ff       	call   800d20 <_Z14sys_page_allociPvi>
  803cbe:	85 c0                	test   %eax,%eax
  803cc0:	79 20                	jns    803ce2 <_Z13migrate_spawni+0x17b>
			panic("migrate_spawn: alloc page at UTEMP: %e\n", r);
  803cc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cc6:	c7 44 24 08 70 57 80 	movl   $0x805770,0x8(%esp)
  803ccd:	00 
  803cce:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  803cd5:	00 
  803cd6:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803cdd:	e8 ca 04 00 00       	call   8041ac <_Z6_panicPKciS0_z>
			r =  -E_NOT_EXEC;
			panic("migrate_spawn: magic check failed. %e\n", r);
			goto cleanup;
		}

		if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0) {
  803ce2:	bb 00 00 40 00       	mov    $0x400000,%ebx
			panic("migrate_spawn: alloc page at UTEMP: %e\n", r);
			goto cleanup;
		}
        for(int i = 0; i < 4; i++)
        {
            if ((r = readn(f, (char *)UTEMP + PGSIZE / 4 * i, PGSIZE/4)) != PGSIZE/4) {
  803ce7:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  803cee:	00 
  803cef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803cf3:	89 34 24             	mov    %esi,(%esp)
  803cf6:	e8 5d da ff ff       	call   801758 <_Z5readniPvj>
  803cfb:	3d 00 04 00 00       	cmp    $0x400,%eax
  803d00:	74 2a                	je     803d2c <_Z13migrate_spawni+0x1c5>
                r = (r < 0) ? r : -E_IO;
  803d02:	85 c0                	test   %eax,%eax
  803d04:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  803d09:	0f 49 c2             	cmovns %edx,%eax
                panic("migrate_spawn: read page:  %e\n", r);
  803d0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d10:	c7 44 24 08 98 57 80 	movl   $0x805798,0x8(%esp)
  803d17:	00 
  803d18:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  803d1f:	00 
  803d20:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803d27:	e8 80 04 00 00       	call   8041ac <_Z6_panicPKciS0_z>
  803d2c:	81 c3 00 04 00 00    	add    $0x400,%ebx

		if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0) {
			panic("migrate_spawn: alloc page at UTEMP: %e\n", r);
			goto cleanup;
		}
        for(int i = 0; i < 4; i++)
  803d32:	81 fb 00 10 40 00    	cmp    $0x401000,%ebx
  803d38:	75 ad                	jne    803ce7 <_Z13migrate_spawni+0x180>
                goto cleanup;
            } 
        }
		

		if ((r = sys_page_map(0, UTEMP, envid, h.mph_addr, h.mph_perm)) < 0) {
  803d3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  803d41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d44:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d48:	8b 45 84             	mov    -0x7c(%ebp),%eax
  803d4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  803d4f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  803d56:	00 
  803d57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d5e:	e8 1c d0 ff ff       	call   800d7f <_Z12sys_page_mapiPviS_i>
  803d63:	85 c0                	test   %eax,%eax
  803d65:	79 20                	jns    803d87 <_Z13migrate_spawni+0x220>
			panic("migrate_spawn: sys_page_map: %e\n", r);
  803d67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d6b:	c7 44 24 08 b8 57 80 	movl   $0x8057b8,0x8(%esp)
  803d72:	00 
  803d73:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  803d7a:	00 
  803d7b:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803d82:	e8 25 04 00 00       	call   8041ac <_Z6_panicPKciS0_z>
			sys_page_unmap(0, UTEMP);
			goto cleanup;
		}

		sys_page_unmap(0, UTEMP);
  803d87:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  803d8e:	00 
  803d8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d96:	e8 42 d0 ff ff       	call   800ddd <_Z14sys_page_unmapiPv>
		r = -E_NOT_EXEC;
		goto cleanup;
	}
	cprintf("[%08x] migrate_spawn: read superheader\n", thisenv->env_id);
	
	for (uint32_t i = 0; i < sh.msh_n_pages; i++) {
  803d9b:	83 c7 01             	add    $0x1,%edi
  803d9e:	39 7d 94             	cmp    %edi,-0x6c(%ebp)
  803da1:	0f 87 88 fe ff ff    	ja     803c2f <_Z13migrate_spawni+0xc8>
  803da7:	8b 7d 80             	mov    -0x80(%ebp),%edi
			goto cleanup;
		}

		sys_page_unmap(0, UTEMP);
	}
	cprintf("[%08x] migrate_spawn: done reading pages\n", thisenv->env_id);
  803daa:	a1 00 70 80 00       	mov    0x807000,%eax
  803daf:	8b 40 04             	mov    0x4(%eax),%eax
  803db2:	89 44 24 04          	mov    %eax,0x4(%esp)
  803db6:	c7 04 24 dc 57 80 00 	movl   $0x8057dc,(%esp)
  803dbd:	e8 5c c4 ff ff       	call   80021e <_Z7cprintfPKcz>
    cprintf("%08x\n", sh.msh_pgfault_upcall);
  803dc2:	8b 45 90             	mov    -0x70(%ebp),%eax
  803dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dc9:	c7 04 24 0d 4b 80 00 	movl   $0x804b0d,(%esp)
  803dd0:	e8 49 c4 ff ff       	call   80021e <_Z7cprintfPKcz>
	if ((r = sys_env_set_pgfault_upcall(envid, &sh.msh_pgfault_upcall)) < 0) {
  803dd5:	8d 45 90             	lea    -0x70(%ebp),%eax
  803dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ddc:	89 3c 24             	mov    %edi,(%esp)
  803ddf:	e8 71 d1 ff ff       	call   800f55 <_Z26sys_env_set_pgfault_upcalliPv>
  803de4:	85 c0                	test   %eax,%eax
  803de6:	79 20                	jns    803e08 <_Z13migrate_spawni+0x2a1>
		panic("migrate_spawn: sys_env_set_pgfault_upcall%e\n", r);
  803de8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dec:	c7 44 24 08 08 58 80 	movl   $0x805808,0x8(%esp)
  803df3:	00 
  803df4:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  803dfb:	00 
  803dfc:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803e03:	e8 a4 03 00 00       	call   8041ac <_Z6_panicPKciS0_z>
		goto cleanup;
	}
	if ((r = sys_env_set_trapframe(envid, &sh.msh_tf)) < 0) {
  803e08:	8d 45 98             	lea    -0x68(%ebp),%eax
  803e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e0f:	89 3c 24             	mov    %edi,(%esp)
  803e12:	e8 e0 d0 ff ff       	call   800ef7 <_Z21sys_env_set_trapframeiP9Trapframe>
  803e17:	85 c0                	test   %eax,%eax
  803e19:	79 20                	jns    803e3b <_Z13migrate_spawni+0x2d4>
		panic("migrate_spawn: sys_env_set_trapframe%e\n", r);
  803e1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e1f:	c7 44 24 08 38 58 80 	movl   $0x805838,0x8(%esp)
  803e26:	00 
  803e27:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  803e2e:	00 
  803e2f:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803e36:	e8 71 03 00 00       	call   8041ac <_Z6_panicPKciS0_z>
		goto cleanup;
	}
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  803e3b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803e42:	00 
  803e43:	89 3c 24             	mov    %edi,(%esp)
  803e46:	e8 f0 cf ff ff       	call   800e3b <_Z18sys_env_set_statusii>
  803e4b:	85 c0                	test   %eax,%eax
  803e4d:	79 20                	jns    803e6f <_Z13migrate_spawni+0x308>
		panic("migrate_spawn: sys_env_set_status%e\n", r);
  803e4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e53:	c7 44 24 08 60 58 80 	movl   $0x805860,0x8(%esp)
  803e5a:	00 
  803e5b:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  803e62:	00 
  803e63:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803e6a:	e8 3d 03 00 00       	call   8041ac <_Z6_panicPKciS0_z>
		goto cleanup;
	}
	cprintf("[%08x] migrate_spawn: done, marked env %08x as runnable\n",
				thisenv->env_id, envid);
  803e6f:	a1 00 70 80 00       	mov    0x807000,%eax
  803e74:	8b 40 04             	mov    0x4(%eax),%eax
  803e77:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e7f:	c7 04 24 88 58 80 00 	movl   $0x805888,(%esp)
  803e86:	e8 93 c3 ff ff       	call   80021e <_Z7cprintfPKcz>

	return envid;
  803e8b:	eb 0b                	jmp    803e98 <_Z13migrate_spawni+0x331>

cleanup:
	sys_env_destroy(envid);
  803e8d:	89 3c 24             	mov    %edi,(%esp)
  803e90:	e8 c6 cd ff ff       	call   800c5b <_Z15sys_env_destroyi>
	return r;
  803e95:	89 5d 84             	mov    %ebx,-0x7c(%ebp)
}
  803e98:	8b 45 84             	mov    -0x7c(%ebp),%eax
  803e9b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803ea1:	5b                   	pop    %ebx
  803ea2:	5e                   	pop    %esi
  803ea3:	5f                   	pop    %edi
  803ea4:	5d                   	pop    %ebp
  803ea5:	c3                   	ret    

00803ea6 <_Z7migratev>:
}

asmlinkage void mig(struct PushRegs *regs, uintptr_t *ebp, uintptr_t *esp);

int
migrate(void) {
  803ea6:	55                   	push   %ebp
  803ea7:	89 e5                	mov    %esp,%ebp
  803ea9:	53                   	push   %ebx
  803eaa:	83 ec 64             	sub    $0x64,%esp
	int r, writesock, readsock;
	int *x = NULL;
    struct Trapframe tf;
    mach_connect(&writesock, &readsock);
  803ead:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803eb7:	89 04 24             	mov    %eax,(%esp)
  803eba:	e8 c1 04 00 00       	call   804380 <_Z12mach_connectPiS_>
	
    sys_time_msec();
  803ebf:	e8 ba d1 ff ff       	call   80107e <_Z13sys_time_msecv>
	memcpy(&tf, (const void *)&thisenv->env_tf, sizeof(struct Trapframe));
  803ec4:	a1 00 70 80 00       	mov    0x807000,%eax
  803ec9:	83 c0 14             	add    $0x14,%eax
  803ecc:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  803ed3:	00 
  803ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ed8:	8d 5d ac             	lea    -0x54(%ebp),%ebx
  803edb:	89 1c 24             	mov    %ebx,(%esp)
  803ede:	e8 74 cb ff ff       	call   800a57 <memcpy>
    mig(&tf.tf_regs, &tf.tf_regs.reg_ebp, &tf.tf_esp);
  803ee3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803ee6:	89 44 24 08          	mov    %eax,0x8(%esp)
  803eea:	8d 45 bc             	lea    -0x44(%ebp),%eax
  803eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ef1:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  803ef4:	89 04 24             	mov    %eax,(%esp)
  803ef7:	e8 44 04 00 00       	call   804340 <mig>
    tf.tf_eip = (uintptr_t)mig_help;
  803efc:	c7 45 dc 1f 3b 80 00 	movl   $0x803b1f,-0x24(%ebp)
	if ((r = migrate_send_state(writesock, &tf)) < 0) 
  803f03:	89 da                	mov    %ebx,%edx
  803f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f08:	e8 33 fa ff ff       	call   803940 <_ZL18migrate_send_stateiP9Trapframe>
  803f0d:	85 c0                	test   %eax,%eax
  803f0f:	79 06                	jns    803f17 <_Z7migratev+0x71>
		return r;
	
    // Destroy this environment iff we're successful.  Does not return.
	sys_env_destroy(0);
	panic("unreachable code\n");
}
  803f11:	83 c4 64             	add    $0x64,%esp
  803f14:	5b                   	pop    %ebx
  803f15:	5d                   	pop    %ebp
  803f16:	c3                   	ret    
    tf.tf_eip = (uintptr_t)mig_help;
	if ((r = migrate_send_state(writesock, &tf)) < 0) 
		return r;
	
    // Destroy this environment iff we're successful.  Does not return.
	sys_env_destroy(0);
  803f17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f1e:	e8 38 cd ff ff       	call   800c5b <_Z15sys_env_destroyi>
	panic("unreachable code\n");
  803f23:	c7 44 24 08 d4 58 80 	movl   $0x8058d4,0x8(%esp)
  803f2a:	00 
  803f2b:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  803f32:	00 
  803f33:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803f3a:	e8 6d 02 00 00       	call   8041ac <_Z6_panicPKciS0_z>

00803f3f <_Z15migrate_locallyPFvvE>:
/*
 * Migrate locally, resuming execution at [callback].
 * This function returns < 0 on error.  On success, it does not return.
 */
int
migrate_locally(void (*callback)(void)) {
  803f3f:	55                   	push   %ebp
  803f40:	89 e5                	mov    %esp,%ebp
  803f42:	53                   	push   %ebx
  803f43:	83 ec 64             	sub    $0x64,%esp
	int r, p[2];
	
	if ((r = pipe(p)) < 0) {
  803f46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803f49:	89 04 24             	mov    %eax,(%esp)
  803f4c:	e8 a3 f1 ff ff       	call   8030f4 <_Z4pipePi>
  803f51:	89 c3                	mov    %eax,%ebx
  803f53:	85 c0                	test   %eax,%eax
  803f55:	0f 88 9c 00 00 00    	js     803ff7 <_Z15migrate_locallyPFvvE+0xb8>
		goto done;
	}

	// Hook up the read end of our pipe to migrated
	if ((r = pipe_ipc_send(ENVID_MIGRATED, p[0])) < 0) 	{
  803f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f62:	c7 04 24 02 11 00 00 	movl   $0x1102,(%esp)
  803f69:	e8 59 f4 ff ff       	call   8033c7 <_Z13pipe_ipc_sendii>
  803f6e:	89 c3                	mov    %eax,%ebx
  803f70:	85 c0                	test   %eax,%eax
  803f72:	78 6d                	js     803fe1 <_Z15migrate_locallyPFvvE+0xa2>
	}

	// XXX: this is not yet right.
	// For now, just wipe the stack.
	struct Trapframe tf;
	memset(&tf, 0, sizeof(struct Trapframe));
  803f74:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  803f7b:	00 
  803f7c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803f83:	00 
  803f84:	8d 5d ac             	lea    -0x54(%ebp),%ebx
  803f87:	89 1c 24             	mov    %ebx,(%esp)
  803f8a:	e8 f2 c9 ff ff       	call   800981 <memset>

	tf.tf_eip = (uintptr_t)callback;
  803f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
	tf.tf_esp = USTACKTOP;
  803f95:	c7 45 e8 00 e0 ff ee 	movl   $0xeeffe000,-0x18(%ebp)
	tf.tf_regs.reg_ebp = USTACKTOP;
  803f9c:	c7 45 bc 00 e0 ff ee 	movl   $0xeeffe000,-0x44(%ebp)

	tf.tf_ss = 0x3;
  803fa3:	66 c7 45 ec 03 00    	movw   $0x3,-0x14(%ebp)
	// XXX: eflags (?), cs, es, ds

	if ((r = migrate_send_state(p[1], &tf)) < 0) {
  803fa9:	89 da                	mov    %ebx,%edx
  803fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fae:	e8 8d f9 ff ff       	call   803940 <_ZL18migrate_send_stateiP9Trapframe>
  803fb3:	89 c3                	mov    %eax,%ebx
  803fb5:	85 c0                	test   %eax,%eax
  803fb7:	78 28                	js     803fe1 <_Z15migrate_locallyPFvvE+0xa2>
		goto cleanup_pipe;
	}

	// Destroy this environment iff we're successful.  Does not return.
	sys_env_destroy(0);
  803fb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803fc0:	e8 96 cc ff ff       	call   800c5b <_Z15sys_env_destroyi>
	panic("unreachable code\n");
  803fc5:	c7 44 24 08 d4 58 80 	movl   $0x8058d4,0x8(%esp)
  803fcc:	00 
  803fcd:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  803fd4:	00 
  803fd5:	c7 04 24 c6 58 80 00 	movl   $0x8058c6,(%esp)
  803fdc:	e8 cb 01 00 00       	call   8041ac <_Z6_panicPKciS0_z>

	// XXX: should this involve pipe_is_closed in some way?
cleanup_pipe:
	close(p[0]);
  803fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe4:	89 04 24             	mov    %eax,(%esp)
  803fe7:	e8 29 d5 ff ff       	call   801515 <_Z5closei>
	close(p[1]);
  803fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fef:	89 04 24             	mov    %eax,(%esp)
  803ff2:	e8 1e d5 ff ff       	call   801515 <_Z5closei>
done:
	return r;	
}
  803ff7:	89 d8                	mov    %ebx,%eax
  803ff9:	83 c4 64             	add    $0x64,%esp
  803ffc:	5b                   	pop    %ebx
  803ffd:	5d                   	pop    %ebp
  803ffe:	c3                   	ret    
	...

00804000 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  804000:	55                   	push   %ebp
  804001:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  804003:	b8 00 00 00 00       	mov    $0x0,%eax
  804008:	5d                   	pop    %ebp
  804009:	c3                   	ret    

0080400a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80400a:	55                   	push   %ebp
  80400b:	89 e5                	mov    %esp,%ebp
  80400d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804010:	c7 44 24 04 e6 58 80 	movl   $0x8058e6,0x4(%esp)
  804017:	00 
  804018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80401b:	89 04 24             	mov    %eax,(%esp)
  80401e:	e8 17 c8 ff ff       	call   80083a <_Z6strcpyPcPKc>
	return 0;
}
  804023:	b8 00 00 00 00       	mov    $0x0,%eax
  804028:	c9                   	leave  
  804029:	c3                   	ret    

0080402a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80402a:	55                   	push   %ebp
  80402b:	89 e5                	mov    %esp,%ebp
  80402d:	57                   	push   %edi
  80402e:	56                   	push   %esi
  80402f:	53                   	push   %ebx
  804030:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804036:	bb 00 00 00 00       	mov    $0x0,%ebx
  80403b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80403f:	74 3e                	je     80407f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804041:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  804047:	8b 75 10             	mov    0x10(%ebp),%esi
  80404a:	29 de                	sub    %ebx,%esi
  80404c:	83 fe 7f             	cmp    $0x7f,%esi
  80404f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  804054:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804057:	89 74 24 08          	mov    %esi,0x8(%esp)
  80405b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80405e:	01 d8                	add    %ebx,%eax
  804060:	89 44 24 04          	mov    %eax,0x4(%esp)
  804064:	89 3c 24             	mov    %edi,(%esp)
  804067:	e8 70 c9 ff ff       	call   8009dc <memmove>
		sys_cputs(buf, m);
  80406c:	89 74 24 04          	mov    %esi,0x4(%esp)
  804070:	89 3c 24             	mov    %edi,(%esp)
  804073:	e8 7c cb ff ff       	call   800bf4 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804078:	01 f3                	add    %esi,%ebx
  80407a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  80407d:	77 c8                	ja     804047 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80407f:	89 d8                	mov    %ebx,%eax
  804081:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  804087:	5b                   	pop    %ebx
  804088:	5e                   	pop    %esi
  804089:	5f                   	pop    %edi
  80408a:	5d                   	pop    %ebp
  80408b:	c3                   	ret    

0080408c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80408c:	55                   	push   %ebp
  80408d:	89 e5                	mov    %esp,%ebp
  80408f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  804092:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  804097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80409b:	75 07                	jne    8040a4 <_ZL12devcons_readP2FdPvj+0x18>
  80409d:	eb 2a                	jmp    8040c9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80409f:	e8 48 cc ff ff       	call   800cec <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8040a4:	e8 7e cb ff ff       	call   800c27 <_Z9sys_cgetcv>
  8040a9:	85 c0                	test   %eax,%eax
  8040ab:	74 f2                	je     80409f <_ZL12devcons_readP2FdPvj+0x13>
  8040ad:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8040af:	85 c0                	test   %eax,%eax
  8040b1:	78 16                	js     8040c9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8040b3:	83 f8 04             	cmp    $0x4,%eax
  8040b6:	74 0c                	je     8040c4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8040b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040bb:	88 10                	mov    %dl,(%eax)
	return 1;
  8040bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8040c2:	eb 05                	jmp    8040c9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8040c4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8040c9:	c9                   	leave  
  8040ca:	c3                   	ret    

008040cb <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8040cb:	55                   	push   %ebp
  8040cc:	89 e5                	mov    %esp,%ebp
  8040ce:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8040d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8040d7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8040de:	00 
  8040df:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8040e2:	89 04 24             	mov    %eax,(%esp)
  8040e5:	e8 0a cb ff ff       	call   800bf4 <_Z9sys_cputsPKcj>
}
  8040ea:	c9                   	leave  
  8040eb:	c3                   	ret    

008040ec <_Z7getcharv>:

int
getchar(void)
{
  8040ec:	55                   	push   %ebp
  8040ed:	89 e5                	mov    %esp,%ebp
  8040ef:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8040f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8040f9:	00 
  8040fa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8040fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  804101:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804108:	e8 b1 d5 ff ff       	call   8016be <_Z4readiPvj>
	if (r < 0)
  80410d:	85 c0                	test   %eax,%eax
  80410f:	78 0f                	js     804120 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  804111:	85 c0                	test   %eax,%eax
  804113:	7e 06                	jle    80411b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  804115:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804119:	eb 05                	jmp    804120 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80411b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  804120:	c9                   	leave  
  804121:	c3                   	ret    

00804122 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  804122:	55                   	push   %ebp
  804123:	89 e5                	mov    %esp,%ebp
  804125:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  804128:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80412f:	00 
  804130:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804133:	89 44 24 04          	mov    %eax,0x4(%esp)
  804137:	8b 45 08             	mov    0x8(%ebp),%eax
  80413a:	89 04 24             	mov    %eax,(%esp)
  80413d:	e8 cf d1 ff ff       	call   801311 <_Z9fd_lookupiPP2Fdb>
  804142:	85 c0                	test   %eax,%eax
  804144:	78 11                	js     804157 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  804146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804149:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80414f:	39 10                	cmp    %edx,(%eax)
  804151:	0f 94 c0             	sete   %al
  804154:	0f b6 c0             	movzbl %al,%eax
}
  804157:	c9                   	leave  
  804158:	c3                   	ret    

00804159 <_Z8openconsv>:

int
opencons(void)
{
  804159:	55                   	push   %ebp
  80415a:	89 e5                	mov    %esp,%ebp
  80415c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80415f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804162:	89 04 24             	mov    %eax,(%esp)
  804165:	e8 5d d2 ff ff       	call   8013c7 <_Z14fd_find_unusedPP2Fd>
  80416a:	85 c0                	test   %eax,%eax
  80416c:	78 3c                	js     8041aa <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80416e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804175:	00 
  804176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80417d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804184:	e8 97 cb ff ff       	call   800d20 <_Z14sys_page_allociPvi>
  804189:	85 c0                	test   %eax,%eax
  80418b:	78 1d                	js     8041aa <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80418d:	8b 15 58 60 80 00    	mov    0x806058,%edx
  804193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804196:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  804198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80419b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8041a2:	89 04 24             	mov    %eax,(%esp)
  8041a5:	e8 ba d1 ff ff       	call   801364 <_Z6fd2numP2Fd>
}
  8041aa:	c9                   	leave  
  8041ab:	c3                   	ret    

008041ac <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8041ac:	55                   	push   %ebp
  8041ad:	89 e5                	mov    %esp,%ebp
  8041af:	56                   	push   %esi
  8041b0:	53                   	push   %ebx
  8041b1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8041b4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  8041b7:	a1 00 90 80 00       	mov    0x809000,%eax
  8041bc:	85 c0                	test   %eax,%eax
  8041be:	74 10                	je     8041d0 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  8041c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041c4:	c7 04 24 f2 58 80 00 	movl   $0x8058f2,(%esp)
  8041cb:	e8 4e c0 ff ff       	call   80021e <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  8041d0:	8b 1d 00 60 80 00    	mov    0x806000,%ebx
  8041d6:	e8 dd ca ff ff       	call   800cb8 <_Z12sys_getenvidv>
  8041db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041de:	89 54 24 10          	mov    %edx,0x10(%esp)
  8041e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8041e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8041e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041f1:	c7 04 24 f8 58 80 00 	movl   $0x8058f8,(%esp)
  8041f8:	e8 21 c0 ff ff       	call   80021e <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8041fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  804201:	8b 45 10             	mov    0x10(%ebp),%eax
  804204:	89 04 24             	mov    %eax,(%esp)
  804207:	e8 b1 bf ff ff       	call   8001bd <_Z8vcprintfPKcPc>
	cprintf("\n");
  80420c:	c7 04 24 f8 4a 80 00 	movl   $0x804af8,(%esp)
  804213:	e8 06 c0 ff ff       	call   80021e <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804218:	cc                   	int3   
  804219:	eb fd                	jmp    804218 <_Z6_panicPKciS0_z+0x6c>
	...

0080421c <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  80421c:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  80421f:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  804220:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  804223:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  804227:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  80422b:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  80422e:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  804230:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  804234:	61                   	popa   
    popf
  804235:	9d                   	popf   
    popl %esp
  804236:	5c                   	pop    %esp
    ret
  804237:	c3                   	ret    

00804238 <spin>:

spin:	jmp spin
  804238:	eb fe                	jmp    804238 <spin>
  80423a:	00 00                	add    %al,(%eax)
  80423c:	00 00                	add    %al,(%eax)
	...

00804240 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804240:	55                   	push   %ebp
  804241:	89 e5                	mov    %esp,%ebp
  804243:	56                   	push   %esi
  804244:	53                   	push   %ebx
  804245:	83 ec 10             	sub    $0x10,%esp
  804248:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80424b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80424e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  804251:	85 c0                	test   %eax,%eax
  804253:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  804258:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80425b:	89 04 24             	mov    %eax,(%esp)
  80425e:	e8 88 cd ff ff       	call   800feb <_Z12sys_ipc_recvPv>
  804263:	85 c0                	test   %eax,%eax
  804265:	79 16                	jns    80427d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  804267:	85 db                	test   %ebx,%ebx
  804269:	74 06                	je     804271 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80426b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804271:	85 f6                	test   %esi,%esi
  804273:	74 53                	je     8042c8 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804275:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80427b:	eb 4b                	jmp    8042c8 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80427d:	85 db                	test   %ebx,%ebx
  80427f:	74 17                	je     804298 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804281:	e8 32 ca ff ff       	call   800cb8 <_Z12sys_getenvidv>
  804286:	25 ff 03 00 00       	and    $0x3ff,%eax
  80428b:	6b c0 78             	imul   $0x78,%eax,%eax
  80428e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804293:	8b 40 60             	mov    0x60(%eax),%eax
  804296:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804298:	85 f6                	test   %esi,%esi
  80429a:	74 17                	je     8042b3 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80429c:	e8 17 ca ff ff       	call   800cb8 <_Z12sys_getenvidv>
  8042a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8042a6:	6b c0 78             	imul   $0x78,%eax,%eax
  8042a9:	05 00 00 00 ef       	add    $0xef000000,%eax
  8042ae:	8b 40 70             	mov    0x70(%eax),%eax
  8042b1:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  8042b3:	e8 00 ca ff ff       	call   800cb8 <_Z12sys_getenvidv>
  8042b8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8042bd:	6b c0 78             	imul   $0x78,%eax,%eax
  8042c0:	05 08 00 00 ef       	add    $0xef000008,%eax
  8042c5:	8b 40 60             	mov    0x60(%eax),%eax

}
  8042c8:	83 c4 10             	add    $0x10,%esp
  8042cb:	5b                   	pop    %ebx
  8042cc:	5e                   	pop    %esi
  8042cd:	5d                   	pop    %ebp
  8042ce:	c3                   	ret    

008042cf <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8042cf:	55                   	push   %ebp
  8042d0:	89 e5                	mov    %esp,%ebp
  8042d2:	57                   	push   %edi
  8042d3:	56                   	push   %esi
  8042d4:	53                   	push   %ebx
  8042d5:	83 ec 1c             	sub    $0x1c,%esp
  8042d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8042db:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8042de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  8042e1:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  8042e3:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8042e8:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8042eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8042ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042f2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8042fa:	89 34 24             	mov    %esi,(%esp)
  8042fd:	e8 b1 cc ff ff       	call   800fb3 <_Z16sys_ipc_try_sendijPvi>
  804302:	85 c0                	test   %eax,%eax
  804304:	79 31                	jns    804337 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  804306:	83 f8 f9             	cmp    $0xfffffff9,%eax
  804309:	75 0c                	jne    804317 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  80430b:	90                   	nop
  80430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804310:	e8 d7 c9 ff ff       	call   800cec <_Z9sys_yieldv>
  804315:	eb d4                	jmp    8042eb <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  804317:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80431b:	c7 44 24 08 1c 59 80 	movl   $0x80591c,0x8(%esp)
  804322:	00 
  804323:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  80432a:	00 
  80432b:	c7 04 24 29 59 80 00 	movl   $0x805929,(%esp)
  804332:	e8 75 fe ff ff       	call   8041ac <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  804337:	83 c4 1c             	add    $0x1c,%esp
  80433a:	5b                   	pop    %ebx
  80433b:	5e                   	pop    %esi
  80433c:	5f                   	pop    %edi
  80433d:	5d                   	pop    %ebp
  80433e:	c3                   	ret    
	...

00804340 <mig>:
.text
.globl mig
mig:
    movl (%ebp), %ecx
  804340:	8b 4d 00             	mov    0x0(%ebp),%ecx
    leal 4(%ebp), %eax
  804343:	8d 45 04             	lea    0x4(%ebp),%eax
    push %ebp
  804346:	55                   	push   %ebp
    movl %esp, %ebp
  804347:	89 e5                	mov    %esp,%ebp
    
    push %eax
  804349:	50                   	push   %eax
    push %ecx
  80434a:	51                   	push   %ecx
	pushal
  80434b:	60                   	pusha  
    movl 8(%ebp), %edx
  80434c:	8b 55 08             	mov    0x8(%ebp),%edx
    movl $0, %eax
  80434f:	b8 00 00 00 00       	mov    $0x0,%eax

00804354 <loop>:

loop:
    movl (%esp,%eax,4), %ecx
  804354:	8b 0c 84             	mov    (%esp,%eax,4),%ecx
    movl %ecx, (%edx, %eax, 4)
  804357:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
    add $1, %eax
  80435a:	83 c0 01             	add    $0x1,%eax
    cmp $8, %eax
  80435d:	83 f8 08             	cmp    $0x8,%eax
    jne loop
  804360:	75 f2                	jne    804354 <loop>
    
    popal
  804362:	61                   	popa   
    pop %eax
  804363:	58                   	pop    %eax
    movl 0xc(%ebp), %edx
  804364:	8b 55 0c             	mov    0xc(%ebp),%edx
    movl %eax, (%edx)
  804367:	89 02                	mov    %eax,(%edx)
    pop %eax
  804369:	58                   	pop    %eax
    movl 0x10(%ebp), %edx
  80436a:	8b 55 10             	mov    0x10(%ebp),%edx
    movl %eax, (%edx)
  80436d:	89 02                	mov    %eax,(%edx)
    
    movl %ebp, %esp
  80436f:	89 ec                	mov    %ebp,%esp
    popl %ebp
  804371:	5d                   	pop    %ebp
    ret
  804372:	c3                   	ret    
	...

00804380 <_Z12mach_connectPiS_>:

static int to_mach_sock = -1, from_mach_sock = -1;

int
mach_connect(int *writesock, int *readsock)
{
  804380:	55                   	push   %ebp
  804381:	89 e5                	mov    %esp,%ebp
  804383:	83 ec 48             	sub    $0x48,%esp
  804386:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  804389:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80438c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80438f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  804392:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct sockaddr_in server;

    if(!(writesock && readsock))
  804395:	85 db                	test   %ebx,%ebx
  804397:	0f 84 6a 01 00 00    	je     804507 <_Z12mach_connectPiS_+0x187>
  80439d:	85 ff                	test   %edi,%edi
  80439f:	0f 84 62 01 00 00    	je     804507 <_Z12mach_connectPiS_+0x187>
        return -1;

    // for now, only one connection is allowed, so if it has already been made
    // return it
    if(to_mach_sock != -1)
  8043a5:	a1 74 60 80 00       	mov    0x806074,%eax
  8043aa:	83 f8 ff             	cmp    $0xffffffff,%eax
  8043ad:	74 13                	je     8043c2 <_Z12mach_connectPiS_+0x42>
    {
        *writesock = to_mach_sock;
  8043af:	89 03                	mov    %eax,(%ebx)
        *readsock = from_mach_sock;
  8043b1:	a1 78 60 80 00       	mov    0x806078,%eax
  8043b6:	89 07                	mov    %eax,(%edi)
        return 0;
  8043b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8043bd:	e9 5f 01 00 00       	jmp    804521 <_Z12mach_connectPiS_+0x1a1>
    if(!(writesock && readsock))
        return -1;

    // for now, only one connection is allowed, so if it has already been made
    // return it
    if(to_mach_sock != -1)
  8043c2:	be 01 00 00 00       	mov    $0x1,%esi
	    // Create the TCP socket
	    if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
		    return -1;
	    
        // Construct the server sockaddr_in structure
        memset(&server, 0, sizeof(server));       // Clear struct
  8043c7:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8043ca:	89 7d d0             	mov    %edi,-0x30(%ebp)

    for (int i = 0; i < 2; i++)
    {
	    int sock, port;
	    // Create the TCP socket
	    if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8043cd:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8043d4:	00 
  8043d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8043dc:	00 
  8043dd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8043e4:	e8 9b f2 ff ff       	call   803684 <_Z6socketiii>
  8043e9:	89 c7                	mov    %eax,%edi
  8043eb:	85 c0                	test   %eax,%eax
  8043ed:	0f 88 1b 01 00 00    	js     80450e <_Z12mach_connectPiS_+0x18e>
		    return -1;
	    
        // Construct the server sockaddr_in structure
        memset(&server, 0, sizeof(server));       // Clear struct
  8043f3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8043fa:	00 
  8043fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  804402:	00 
  804403:	8d 45 d8             	lea    -0x28(%ebp),%eax
  804406:	89 04 24             	mov    %eax,(%esp)
  804409:	e8 73 c5 ff ff       	call   800981 <memset>
        server.sin_family = AF_INET;                  // Internet/IP
  80440e:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
        server.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  804412:	c7 04 24 33 59 80 00 	movl   $0x805933,(%esp)
  804419:	e8 16 04 00 00       	call   804834 <inet_addr>
  80441e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804421:	89 f3                	mov    %esi,%ebx
        
        switch(MACHINE + 2 * i)
  804423:	83 fe 01             	cmp    $0x1,%esi
  804426:	74 38                	je     804460 <_Z12mach_connectPiS_+0xe0>
  804428:	83 fe 01             	cmp    $0x1,%esi
  80442b:	7f 09                	jg     804436 <_Z12mach_connectPiS_+0xb6>
  80442d:	85 f6                	test   %esi,%esi
  80442f:	74 17                	je     804448 <_Z12mach_connectPiS_+0xc8>
  804431:	e9 df 00 00 00       	jmp    804515 <_Z12mach_connectPiS_+0x195>
  804436:	83 fe 02             	cmp    $0x2,%esi
  804439:	74 17                	je     804452 <_Z12mach_connectPiS_+0xd2>
  80443b:	83 fe 03             	cmp    $0x3,%esi
  80443e:	66 90                	xchg   %ax,%ax
  804440:	0f 85 cf 00 00 00    	jne    804515 <_Z12mach_connectPiS_+0x195>
  804446:	eb 11                	jmp    804459 <_Z12mach_connectPiS_+0xd9>
        {
            case 0: port = TOPORT1; break;
  804448:	b8 d1 04 00 00       	mov    $0x4d1,%eax
  80444d:	8d 76 00             	lea    0x0(%esi),%esi
  804450:	eb 13                	jmp    804465 <_Z12mach_connectPiS_+0xe5>
            case 1: port = FROMPORT1; break;
            case 2: port = FROMPORT2; break;
  804452:	b8 d4 04 00 00       	mov    $0x4d4,%eax
  804457:	eb 0c                	jmp    804465 <_Z12mach_connectPiS_+0xe5>
            case 3: port = TOPORT2; break;
  804459:	b8 d3 04 00 00       	mov    $0x4d3,%eax
  80445e:	eb 05                	jmp    804465 <_Z12mach_connectPiS_+0xe5>
        server.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
        
        switch(MACHINE + 2 * i)
        {
            case 0: port = TOPORT1; break;
            case 1: port = FROMPORT1; break;
  804460:	b8 d2 04 00 00       	mov    $0x4d2,%eax
            case 2: port = FROMPORT2; break;
            case 3: port = TOPORT2; break;
            default: port = 0; return -1;
        }

        server.sin_port = htons(port);  // server port
  804465:	89 04 24             	mov    %eax,(%esp)
  804468:	e8 6c 01 00 00       	call   8045d9 <htons>
  80446d:	66 89 45 da          	mov    %ax,-0x26(%ebp)

        // Establish connection
        if (connect(sock, (struct sockaddr *) &server, sizeof(server)) < 0)
  804471:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  804478:	00 
  804479:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80447c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804480:	89 3c 24             	mov    %edi,(%esp)
  804483:	e8 af f1 ff ff       	call   803637 <_Z7connectiPK8sockaddrj>
  804488:	85 c0                	test   %eax,%eax
  80448a:	0f 88 8c 00 00 00    	js     80451c <_Z12mach_connectPiS_+0x19c>
            return -1;

        cprintf("connected to server\n");
  804490:	c7 04 24 3c 59 80 00 	movl   $0x80593c,(%esp)
  804497:	e8 82 bd ff ff       	call   80021e <_Z7cprintfPKcz>
        switch(MACHINE + 2 * i)
  80449c:	83 fb 01             	cmp    $0x1,%ebx
  80449f:	74 29                	je     8044ca <_Z12mach_connectPiS_+0x14a>
  8044a1:	83 fb 01             	cmp    $0x1,%ebx
  8044a4:	7f 0c                	jg     8044b2 <_Z12mach_connectPiS_+0x132>
  8044a6:	85 db                	test   %ebx,%ebx
  8044a8:	74 18                	je     8044c2 <_Z12mach_connectPiS_+0x142>
  8044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8044b0:	eb 2e                	jmp    8044e0 <_Z12mach_connectPiS_+0x160>
  8044b2:	83 fb 02             	cmp    $0x2,%ebx
  8044b5:	74 1b                	je     8044d2 <_Z12mach_connectPiS_+0x152>
  8044b7:	83 fb 03             	cmp    $0x3,%ebx
  8044ba:	75 24                	jne    8044e0 <_Z12mach_connectPiS_+0x160>
  8044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8044c0:	eb 18                	jmp    8044da <_Z12mach_connectPiS_+0x15a>
        {
            case 0: to_mach_sock = sock; break;
  8044c2:	89 3d 74 60 80 00    	mov    %edi,0x806074
  8044c8:	eb 16                	jmp    8044e0 <_Z12mach_connectPiS_+0x160>
            case 1: from_mach_sock = sock; break;
  8044ca:	89 3d 78 60 80 00    	mov    %edi,0x806078
  8044d0:	eb 0e                	jmp    8044e0 <_Z12mach_connectPiS_+0x160>
            case 2: from_mach_sock = sock; break;
  8044d2:	89 3d 78 60 80 00    	mov    %edi,0x806078
  8044d8:	eb 06                	jmp    8044e0 <_Z12mach_connectPiS_+0x160>
            case 3: to_mach_sock = sock; break;
  8044da:	89 3d 74 60 80 00    	mov    %edi,0x806074
  8044e0:	83 c6 02             	add    $0x2,%esi
        *writesock = to_mach_sock;
        *readsock = from_mach_sock;
        return 0;
    }

    for (int i = 0; i < 2; i++)
  8044e3:	83 fe 05             	cmp    $0x5,%esi
  8044e6:	0f 85 e1 fe ff ff    	jne    8043cd <_Z12mach_connectPiS_+0x4d>
  8044ec:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8044ef:	8b 7d d0             	mov    -0x30(%ebp),%edi
            case 1: from_mach_sock = sock; break;
            case 2: from_mach_sock = sock; break;
            case 3: to_mach_sock = sock; break;
        }
    }
    *writesock = to_mach_sock;
  8044f2:	a1 74 60 80 00       	mov    0x806074,%eax
  8044f7:	89 03                	mov    %eax,(%ebx)
    *readsock = from_mach_sock;
  8044f9:	a1 78 60 80 00       	mov    0x806078,%eax
  8044fe:	89 07                	mov    %eax,(%edi)
    return 0;
  804500:	b8 00 00 00 00       	mov    $0x0,%eax
  804505:	eb 1a                	jmp    804521 <_Z12mach_connectPiS_+0x1a1>
mach_connect(int *writesock, int *readsock)
{
	struct sockaddr_in server;

    if(!(writesock && readsock))
        return -1;
  804507:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80450c:	eb 13                	jmp    804521 <_Z12mach_connectPiS_+0x1a1>
    for (int i = 0; i < 2; i++)
    {
	    int sock, port;
	    // Create the TCP socket
	    if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
		    return -1;
  80450e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  804513:	eb 0c                	jmp    804521 <_Z12mach_connectPiS_+0x1a1>
        {
            case 0: port = TOPORT1; break;
            case 1: port = FROMPORT1; break;
            case 2: port = FROMPORT2; break;
            case 3: port = TOPORT2; break;
            default: port = 0; return -1;
  804515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80451a:	eb 05                	jmp    804521 <_Z12mach_connectPiS_+0x1a1>

        server.sin_port = htons(port);  // server port

        // Establish connection
        if (connect(sock, (struct sockaddr *) &server, sizeof(server)) < 0)
            return -1;
  80451c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }
    }
    *writesock = to_mach_sock;
    *readsock = from_mach_sock;
    return 0;
}
  804521:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  804524:	8b 75 f8             	mov    -0x8(%ebp),%esi
  804527:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80452a:	89 ec                	mov    %ebp,%esp
  80452c:	5d                   	pop    %ebp
  80452d:	c3                   	ret    
	...

00804530 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804530:	55                   	push   %ebp
  804531:	89 e5                	mov    %esp,%ebp
  804533:	57                   	push   %edi
  804534:	56                   	push   %esi
  804535:	53                   	push   %ebx
  804536:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804539:	8b 45 08             	mov    0x8(%ebp),%eax
  80453c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80453f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  804542:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  804545:	8d 45 ef             	lea    -0x11(%ebp),%eax
  804548:	89 45 e0             	mov    %eax,-0x20(%ebp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80454b:	bb 04 90 80 00       	mov    $0x809004,%ebx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  804550:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804553:	0f b6 08             	movzbl (%eax),%ecx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804556:	ba 00 00 00 00       	mov    $0x0,%edx
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  80455b:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  804560:	f6 e1                	mul    %cl
  804562:	66 c1 e8 08          	shr    $0x8,%ax
  804566:	c0 e8 03             	shr    $0x3,%al
  804569:	89 c6                	mov    %eax,%esi
  80456b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80456e:	01 c0                	add    %eax,%eax
  804570:	28 c1                	sub    %al,%cl
  804572:	89 c8                	mov    %ecx,%eax
      *ap /= (u8_t)10;
  804574:	89 f1                	mov    %esi,%ecx
      inv[i++] = '0' + rem;
  804576:	0f b6 fa             	movzbl %dl,%edi
  804579:	83 c0 30             	add    $0x30,%eax
  80457c:	88 44 3d f1          	mov    %al,-0xf(%ebp,%edi,1)
  804580:	83 c2 01             	add    $0x1,%edx

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
  804583:	84 c9                	test   %cl,%cl
  804585:	75 d4                	jne    80455b <inet_ntoa+0x2b>
  804587:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80458a:	88 08                	mov    %cl,(%eax)
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80458c:	84 d2                	test   %dl,%dl
  80458e:	74 24                	je     8045b4 <inet_ntoa+0x84>
  804590:	83 ea 01             	sub    $0x1,%edx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  804593:	0f b6 fa             	movzbl %dl,%edi
  804596:	8d 74 3b 01          	lea    0x1(%ebx,%edi,1),%esi
  80459a:	89 d8                	mov    %ebx,%eax
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  80459c:	0f b6 ca             	movzbl %dl,%ecx
  80459f:	0f b6 4c 0d f1       	movzbl -0xf(%ebp,%ecx,1),%ecx
  8045a4:	88 08                	mov    %cl,(%eax)
  8045a6:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8045a9:	83 ea 01             	sub    $0x1,%edx
  8045ac:	39 f0                	cmp    %esi,%eax
  8045ae:	75 ec                	jne    80459c <inet_ntoa+0x6c>
  8045b0:	8d 5c 3b 01          	lea    0x1(%ebx,%edi,1),%ebx
      *rp++ = inv[i];
    *rp++ = '.';
  8045b4:	c6 03 2e             	movb   $0x2e,(%ebx)
  8045b7:	83 c3 01             	add    $0x1,%ebx
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8045ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045bd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8045c0:	74 06                	je     8045c8 <inet_ntoa+0x98>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  8045c2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  8045c6:	eb 88                	jmp    804550 <inet_ntoa+0x20>
  }
  *--rp = 0;
  8045c8:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  8045cc:	b8 04 90 80 00       	mov    $0x809004,%eax
  8045d1:	83 c4 18             	add    $0x18,%esp
  8045d4:	5b                   	pop    %ebx
  8045d5:	5e                   	pop    %esi
  8045d6:	5f                   	pop    %edi
  8045d7:	5d                   	pop    %ebp
  8045d8:	c3                   	ret    

008045d9 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8045d9:	55                   	push   %ebp
  8045da:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8045dc:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8045e0:	66 c1 c0 08          	rol    $0x8,%ax
}
  8045e4:	5d                   	pop    %ebp
  8045e5:	c3                   	ret    

008045e6 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8045e6:	55                   	push   %ebp
  8045e7:	89 e5                	mov    %esp,%ebp
  8045e9:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  8045ec:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8045f0:	89 04 24             	mov    %eax,(%esp)
  8045f3:	e8 e1 ff ff ff       	call   8045d9 <htons>
}
  8045f8:	c9                   	leave  
  8045f9:	c3                   	ret    

008045fa <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8045fa:	55                   	push   %ebp
  8045fb:	89 e5                	mov    %esp,%ebp
  8045fd:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  804600:	89 d1                	mov    %edx,%ecx
  804602:	c1 e9 18             	shr    $0x18,%ecx
  804605:	89 d0                	mov    %edx,%eax
  804607:	c1 e0 18             	shl    $0x18,%eax
  80460a:	09 c8                	or     %ecx,%eax
  80460c:	89 d1                	mov    %edx,%ecx
  80460e:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  804614:	c1 e1 08             	shl    $0x8,%ecx
  804617:	09 c8                	or     %ecx,%eax
  804619:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  80461f:	c1 ea 08             	shr    $0x8,%edx
  804622:	09 d0                	or     %edx,%eax
}
  804624:	5d                   	pop    %ebp
  804625:	c3                   	ret    

00804626 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804626:	55                   	push   %ebp
  804627:	89 e5                	mov    %esp,%ebp
  804629:	57                   	push   %edi
  80462a:	56                   	push   %esi
  80462b:	53                   	push   %ebx
  80462c:	83 ec 28             	sub    $0x28,%esp
  80462f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  804632:	0f be 11             	movsbl (%ecx),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804635:	8d 5a d0             	lea    -0x30(%edx),%ebx
      return (0);
  804638:	b8 00 00 00 00       	mov    $0x0,%eax
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  80463d:	80 fb 09             	cmp    $0x9,%bl
  804640:	0f 87 c4 01 00 00    	ja     80480a <inet_aton+0x1e4>
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804646:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  804649:	89 45 d8             	mov    %eax,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80464c:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  80464f:	89 5d e0             	mov    %ebx,-0x20(%ebp)
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
  804652:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  804659:	83 fa 30             	cmp    $0x30,%edx
  80465c:	75 25                	jne    804683 <inet_aton+0x5d>
      c = *++cp;
  80465e:	83 c1 01             	add    $0x1,%ecx
  804661:	0f be 11             	movsbl (%ecx),%edx
      if (c == 'x' || c == 'X') {
  804664:	83 fa 78             	cmp    $0x78,%edx
  804667:	74 0c                	je     804675 <inet_aton+0x4f>
        base = 16;
        c = *++cp;
      } else
        base = 8;
  804669:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
  804670:	83 fa 58             	cmp    $0x58,%edx
  804673:	75 0e                	jne    804683 <inet_aton+0x5d>
        base = 16;
        c = *++cp;
  804675:	0f be 51 01          	movsbl 0x1(%ecx),%edx
  804679:	83 c1 01             	add    $0x1,%ecx
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80467c:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  804683:	8d 41 01             	lea    0x1(%ecx),%eax
  804686:	be 00 00 00 00       	mov    $0x0,%esi
  80468b:	eb 03                	jmp    804690 <inet_aton+0x6a>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  80468d:	83 c0 01             	add    $0x1,%eax
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  804690:	8d 78 ff             	lea    -0x1(%eax),%edi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  804693:	89 d1                	mov    %edx,%ecx
  804695:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  804698:	80 fb 09             	cmp    $0x9,%bl
  80469b:	77 0d                	ja     8046aa <inet_aton+0x84>
        val = (val * base) + (int)(c - '0');
  80469d:	0f af 75 dc          	imul   -0x24(%ebp),%esi
  8046a1:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  8046a5:	0f be 10             	movsbl (%eax),%edx
  8046a8:	eb e3                	jmp    80468d <inet_aton+0x67>
      } else if (base == 16 && isxdigit(c)) {
  8046aa:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  8046ae:	0f 85 5e 01 00 00    	jne    804812 <inet_aton+0x1ec>
  8046b4:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8046b7:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  8046ba:	80 fb 05             	cmp    $0x5,%bl
  8046bd:	76 0c                	jbe    8046cb <inet_aton+0xa5>
  8046bf:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8046c2:	80 fb 05             	cmp    $0x5,%bl
  8046c5:	0f 87 4d 01 00 00    	ja     804818 <inet_aton+0x1f2>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8046cb:	89 f1                	mov    %esi,%ecx
  8046cd:	c1 e1 04             	shl    $0x4,%ecx
  8046d0:	8d 72 0a             	lea    0xa(%edx),%esi
  8046d3:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8046d7:	19 d2                	sbb    %edx,%edx
  8046d9:	83 e2 20             	and    $0x20,%edx
  8046dc:	83 c2 41             	add    $0x41,%edx
  8046df:	29 d6                	sub    %edx,%esi
  8046e1:	09 ce                	or     %ecx,%esi
        c = *++cp;
  8046e3:	0f be 10             	movsbl (%eax),%edx
  8046e6:	eb a5                	jmp    80468d <inet_aton+0x67>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8046e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8046eb:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8046ee:	0f 83 0a 01 00 00    	jae    8047fe <inet_aton+0x1d8>
        return (0);
      *pp++ = val;
  8046f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8046f7:	89 1a                	mov    %ebx,(%edx)
      c = *++cp;
  8046f9:	8d 4f 01             	lea    0x1(%edi),%ecx
  8046fc:	0f be 57 01          	movsbl 0x1(%edi),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804700:	8d 42 d0             	lea    -0x30(%edx),%eax
  804703:	3c 09                	cmp    $0x9,%al
  804705:	0f 87 fa 00 00 00    	ja     804805 <inet_aton+0x1df>
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
  80470b:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  80470f:	e9 3e ff ff ff       	jmp    804652 <inet_aton+0x2c>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  804714:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804719:	80 f9 1f             	cmp    $0x1f,%cl
  80471c:	0f 86 e8 00 00 00    	jbe    80480a <inet_aton+0x1e4>
  804722:	84 d2                	test   %dl,%dl
  804724:	0f 88 e0 00 00 00    	js     80480a <inet_aton+0x1e4>
  80472a:	83 fa 20             	cmp    $0x20,%edx
  80472d:	74 1d                	je     80474c <inet_aton+0x126>
  80472f:	83 fa 0c             	cmp    $0xc,%edx
  804732:	74 18                	je     80474c <inet_aton+0x126>
  804734:	83 fa 0a             	cmp    $0xa,%edx
  804737:	74 13                	je     80474c <inet_aton+0x126>
  804739:	83 fa 0d             	cmp    $0xd,%edx
  80473c:	74 0e                	je     80474c <inet_aton+0x126>
  80473e:	83 fa 09             	cmp    $0x9,%edx
  804741:	74 09                	je     80474c <inet_aton+0x126>
  804743:	83 fa 0b             	cmp    $0xb,%edx
  804746:	0f 85 be 00 00 00    	jne    80480a <inet_aton+0x1e4>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80474c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80474f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804752:	29 c2                	sub    %eax,%edx
  804754:	c1 fa 02             	sar    $0x2,%edx
  804757:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80475a:	83 fa 02             	cmp    $0x2,%edx
  80475d:	74 25                	je     804784 <inet_aton+0x15e>
  80475f:	83 fa 02             	cmp    $0x2,%edx
  804762:	7f 0f                	jg     804773 <inet_aton+0x14d>

  case 0:
    return (0);       /* initial nondigit */
  804764:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  804769:	85 d2                	test   %edx,%edx
  80476b:	0f 84 99 00 00 00    	je     80480a <inet_aton+0x1e4>
  804771:	eb 6c                	jmp    8047df <inet_aton+0x1b9>
  804773:	83 fa 03             	cmp    $0x3,%edx
  804776:	74 23                	je     80479b <inet_aton+0x175>
  804778:	83 fa 04             	cmp    $0x4,%edx
  80477b:	90                   	nop
  80477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804780:	75 5d                	jne    8047df <inet_aton+0x1b9>
  804782:	eb 36                	jmp    8047ba <inet_aton+0x194>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  804784:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804789:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  80478f:	77 79                	ja     80480a <inet_aton+0x1e4>
      return (0);
    val |= parts[0] << 24;
  804791:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  804794:	c1 e6 18             	shl    $0x18,%esi
  804797:	09 de                	or     %ebx,%esi
    break;
  804799:	eb 44                	jmp    8047df <inet_aton+0x1b9>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  80479b:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8047a0:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  8047a6:	77 62                	ja     80480a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8047a8:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8047ab:	c1 e6 10             	shl    $0x10,%esi
  8047ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047b1:	c1 e0 18             	shl    $0x18,%eax
  8047b4:	09 c6                	or     %eax,%esi
  8047b6:	09 de                	or     %ebx,%esi
    break;
  8047b8:	eb 25                	jmp    8047df <inet_aton+0x1b9>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  8047ba:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8047bf:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8047c5:	77 43                	ja     80480a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8047c7:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8047ca:	c1 e6 10             	shl    $0x10,%esi
  8047cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047d0:	c1 e0 18             	shl    $0x18,%eax
  8047d3:	09 c6                	or     %eax,%esi
  8047d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047d8:	c1 e0 08             	shl    $0x8,%eax
  8047db:	09 c6                	or     %eax,%esi
  8047dd:	09 de                	or     %ebx,%esi
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8047df:	b8 01 00 00 00       	mov    $0x1,%eax
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8047e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8047e8:	74 20                	je     80480a <inet_aton+0x1e4>
    addr->s_addr = htonl(val);
  8047ea:	89 34 24             	mov    %esi,(%esp)
  8047ed:	e8 08 fe ff ff       	call   8045fa <htonl>
  8047f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8047f5:	89 03                	mov    %eax,(%ebx)
  return (1);
  8047f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8047fc:	eb 0c                	jmp    80480a <inet_aton+0x1e4>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8047fe:	b8 00 00 00 00       	mov    $0x0,%eax
  804803:	eb 05                	jmp    80480a <inet_aton+0x1e4>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  804805:	b8 00 00 00 00       	mov    $0x0,%eax
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
}
  80480a:	83 c4 28             	add    $0x28,%esp
  80480d:	5b                   	pop    %ebx
  80480e:	5e                   	pop    %esi
  80480f:	5f                   	pop    %edi
  804810:	5d                   	pop    %ebp
  804811:	c3                   	ret    
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804812:	89 d0                	mov    %edx,%eax
  804814:	89 f3                	mov    %esi,%ebx
  804816:	eb 04                	jmp    80481c <inet_aton+0x1f6>
  804818:	89 d0                	mov    %edx,%eax
  80481a:	89 f3                	mov    %esi,%ebx
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
    if (c == '.') {
  80481c:	83 f8 2e             	cmp    $0x2e,%eax
  80481f:	0f 84 c3 fe ff ff    	je     8046e8 <inet_aton+0xc2>
  804825:	89 f3                	mov    %esi,%ebx
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804827:	85 d2                	test   %edx,%edx
  804829:	0f 84 1d ff ff ff    	je     80474c <inet_aton+0x126>
  80482f:	e9 e0 fe ff ff       	jmp    804714 <inet_aton+0xee>

00804834 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804834:	55                   	push   %ebp
  804835:	89 e5                	mov    %esp,%ebp
  804837:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80483a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80483d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804841:	8b 45 08             	mov    0x8(%ebp),%eax
  804844:	89 04 24             	mov    %eax,(%esp)
  804847:	e8 da fd ff ff       	call   804626 <inet_aton>
  80484c:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80484e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  804853:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  804857:	c9                   	leave  
  804858:	c3                   	ret    

00804859 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804859:	55                   	push   %ebp
  80485a:	89 e5                	mov    %esp,%ebp
  80485c:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  80485f:	8b 45 08             	mov    0x8(%ebp),%eax
  804862:	89 04 24             	mov    %eax,(%esp)
  804865:	e8 90 fd ff ff       	call   8045fa <htonl>
}
  80486a:	c9                   	leave  
  80486b:	c3                   	ret    
  80486c:	00 00                	add    %al,(%eax)
	...

00804870 <__udivdi3>:
  804870:	55                   	push   %ebp
  804871:	89 e5                	mov    %esp,%ebp
  804873:	57                   	push   %edi
  804874:	56                   	push   %esi
  804875:	83 ec 20             	sub    $0x20,%esp
  804878:	8b 45 14             	mov    0x14(%ebp),%eax
  80487b:	8b 75 08             	mov    0x8(%ebp),%esi
  80487e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804881:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804884:	85 c0                	test   %eax,%eax
  804886:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804889:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80488c:	75 3a                	jne    8048c8 <__udivdi3+0x58>
  80488e:	39 f9                	cmp    %edi,%ecx
  804890:	77 66                	ja     8048f8 <__udivdi3+0x88>
  804892:	85 c9                	test   %ecx,%ecx
  804894:	75 0b                	jne    8048a1 <__udivdi3+0x31>
  804896:	b8 01 00 00 00       	mov    $0x1,%eax
  80489b:	31 d2                	xor    %edx,%edx
  80489d:	f7 f1                	div    %ecx
  80489f:	89 c1                	mov    %eax,%ecx
  8048a1:	89 f8                	mov    %edi,%eax
  8048a3:	31 d2                	xor    %edx,%edx
  8048a5:	f7 f1                	div    %ecx
  8048a7:	89 c7                	mov    %eax,%edi
  8048a9:	89 f0                	mov    %esi,%eax
  8048ab:	f7 f1                	div    %ecx
  8048ad:	89 fa                	mov    %edi,%edx
  8048af:	89 c6                	mov    %eax,%esi
  8048b1:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8048b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8048b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8048ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8048bd:	83 c4 20             	add    $0x20,%esp
  8048c0:	5e                   	pop    %esi
  8048c1:	5f                   	pop    %edi
  8048c2:	5d                   	pop    %ebp
  8048c3:	c3                   	ret    
  8048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8048c8:	31 d2                	xor    %edx,%edx
  8048ca:	31 f6                	xor    %esi,%esi
  8048cc:	39 f8                	cmp    %edi,%eax
  8048ce:	77 e1                	ja     8048b1 <__udivdi3+0x41>
  8048d0:	0f bd d0             	bsr    %eax,%edx
  8048d3:	83 f2 1f             	xor    $0x1f,%edx
  8048d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8048d9:	75 2d                	jne    804908 <__udivdi3+0x98>
  8048db:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8048de:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  8048e1:	76 06                	jbe    8048e9 <__udivdi3+0x79>
  8048e3:	39 f8                	cmp    %edi,%eax
  8048e5:	89 f2                	mov    %esi,%edx
  8048e7:	73 c8                	jae    8048b1 <__udivdi3+0x41>
  8048e9:	31 d2                	xor    %edx,%edx
  8048eb:	be 01 00 00 00       	mov    $0x1,%esi
  8048f0:	eb bf                	jmp    8048b1 <__udivdi3+0x41>
  8048f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8048f8:	89 f0                	mov    %esi,%eax
  8048fa:	89 fa                	mov    %edi,%edx
  8048fc:	f7 f1                	div    %ecx
  8048fe:	31 d2                	xor    %edx,%edx
  804900:	89 c6                	mov    %eax,%esi
  804902:	eb ad                	jmp    8048b1 <__udivdi3+0x41>
  804904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804908:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80490c:	89 c2                	mov    %eax,%edx
  80490e:	b8 20 00 00 00       	mov    $0x20,%eax
  804913:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804916:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804919:	d3 e2                	shl    %cl,%edx
  80491b:	89 c1                	mov    %eax,%ecx
  80491d:	d3 ee                	shr    %cl,%esi
  80491f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804923:	09 d6                	or     %edx,%esi
  804925:	89 fa                	mov    %edi,%edx
  804927:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80492a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80492d:	d3 e6                	shl    %cl,%esi
  80492f:	89 c1                	mov    %eax,%ecx
  804931:	d3 ea                	shr    %cl,%edx
  804933:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804937:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80493a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80493d:	d3 e7                	shl    %cl,%edi
  80493f:	89 c1                	mov    %eax,%ecx
  804941:	d3 ee                	shr    %cl,%esi
  804943:	09 fe                	or     %edi,%esi
  804945:	89 f0                	mov    %esi,%eax
  804947:	f7 75 e4             	divl   -0x1c(%ebp)
  80494a:	89 d7                	mov    %edx,%edi
  80494c:	89 c6                	mov    %eax,%esi
  80494e:	f7 65 f0             	mull   -0x10(%ebp)
  804951:	39 d7                	cmp    %edx,%edi
  804953:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804956:	72 12                	jb     80496a <__udivdi3+0xfa>
  804958:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80495b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80495f:	d3 e2                	shl    %cl,%edx
  804961:	39 c2                	cmp    %eax,%edx
  804963:	73 08                	jae    80496d <__udivdi3+0xfd>
  804965:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804968:	75 03                	jne    80496d <__udivdi3+0xfd>
  80496a:	83 ee 01             	sub    $0x1,%esi
  80496d:	31 d2                	xor    %edx,%edx
  80496f:	e9 3d ff ff ff       	jmp    8048b1 <__udivdi3+0x41>
	...

00804980 <__umoddi3>:
  804980:	55                   	push   %ebp
  804981:	89 e5                	mov    %esp,%ebp
  804983:	57                   	push   %edi
  804984:	56                   	push   %esi
  804985:	83 ec 20             	sub    $0x20,%esp
  804988:	8b 7d 14             	mov    0x14(%ebp),%edi
  80498b:	8b 45 08             	mov    0x8(%ebp),%eax
  80498e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804991:	8b 75 0c             	mov    0xc(%ebp),%esi
  804994:	85 ff                	test   %edi,%edi
  804996:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804999:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80499c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80499f:	89 f2                	mov    %esi,%edx
  8049a1:	75 15                	jne    8049b8 <__umoddi3+0x38>
  8049a3:	39 f1                	cmp    %esi,%ecx
  8049a5:	76 41                	jbe    8049e8 <__umoddi3+0x68>
  8049a7:	f7 f1                	div    %ecx
  8049a9:	89 d0                	mov    %edx,%eax
  8049ab:	31 d2                	xor    %edx,%edx
  8049ad:	83 c4 20             	add    $0x20,%esp
  8049b0:	5e                   	pop    %esi
  8049b1:	5f                   	pop    %edi
  8049b2:	5d                   	pop    %ebp
  8049b3:	c3                   	ret    
  8049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8049b8:	39 f7                	cmp    %esi,%edi
  8049ba:	77 4c                	ja     804a08 <__umoddi3+0x88>
  8049bc:	0f bd c7             	bsr    %edi,%eax
  8049bf:	83 f0 1f             	xor    $0x1f,%eax
  8049c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8049c5:	75 51                	jne    804a18 <__umoddi3+0x98>
  8049c7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  8049ca:	0f 87 e8 00 00 00    	ja     804ab8 <__umoddi3+0x138>
  8049d0:	89 f2                	mov    %esi,%edx
  8049d2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8049d5:	29 ce                	sub    %ecx,%esi
  8049d7:	19 fa                	sbb    %edi,%edx
  8049d9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8049dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049df:	83 c4 20             	add    $0x20,%esp
  8049e2:	5e                   	pop    %esi
  8049e3:	5f                   	pop    %edi
  8049e4:	5d                   	pop    %ebp
  8049e5:	c3                   	ret    
  8049e6:	66 90                	xchg   %ax,%ax
  8049e8:	85 c9                	test   %ecx,%ecx
  8049ea:	75 0b                	jne    8049f7 <__umoddi3+0x77>
  8049ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8049f1:	31 d2                	xor    %edx,%edx
  8049f3:	f7 f1                	div    %ecx
  8049f5:	89 c1                	mov    %eax,%ecx
  8049f7:	89 f0                	mov    %esi,%eax
  8049f9:	31 d2                	xor    %edx,%edx
  8049fb:	f7 f1                	div    %ecx
  8049fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804a00:	eb a5                	jmp    8049a7 <__umoddi3+0x27>
  804a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804a08:	89 f2                	mov    %esi,%edx
  804a0a:	83 c4 20             	add    $0x20,%esp
  804a0d:	5e                   	pop    %esi
  804a0e:	5f                   	pop    %edi
  804a0f:	5d                   	pop    %ebp
  804a10:	c3                   	ret    
  804a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804a18:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a1c:	89 f2                	mov    %esi,%edx
  804a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a21:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804a28:	29 45 f0             	sub    %eax,-0x10(%ebp)
  804a2b:	d3 e7                	shl    %cl,%edi
  804a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a30:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804a34:	d3 e8                	shr    %cl,%eax
  804a36:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a3a:	09 f8                	or     %edi,%eax
  804a3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  804a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a42:	d3 e0                	shl    %cl,%eax
  804a44:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a4e:	d3 ea                	shr    %cl,%edx
  804a50:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a54:	d3 e6                	shl    %cl,%esi
  804a56:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804a5a:	d3 e8                	shr    %cl,%eax
  804a5c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a60:	09 f0                	or     %esi,%eax
  804a62:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804a65:	f7 75 e4             	divl   -0x1c(%ebp)
  804a68:	d3 e6                	shl    %cl,%esi
  804a6a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804a6d:	89 d6                	mov    %edx,%esi
  804a6f:	f7 65 f4             	mull   -0xc(%ebp)
  804a72:	89 d7                	mov    %edx,%edi
  804a74:	89 c2                	mov    %eax,%edx
  804a76:	39 fe                	cmp    %edi,%esi
  804a78:	89 f9                	mov    %edi,%ecx
  804a7a:	72 30                	jb     804aac <__umoddi3+0x12c>
  804a7c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  804a7f:	72 27                	jb     804aa8 <__umoddi3+0x128>
  804a81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a84:	29 d0                	sub    %edx,%eax
  804a86:	19 ce                	sbb    %ecx,%esi
  804a88:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a8c:	89 f2                	mov    %esi,%edx
  804a8e:	d3 e8                	shr    %cl,%eax
  804a90:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804a94:	d3 e2                	shl    %cl,%edx
  804a96:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a9a:	09 d0                	or     %edx,%eax
  804a9c:	89 f2                	mov    %esi,%edx
  804a9e:	d3 ea                	shr    %cl,%edx
  804aa0:	83 c4 20             	add    $0x20,%esp
  804aa3:	5e                   	pop    %esi
  804aa4:	5f                   	pop    %edi
  804aa5:	5d                   	pop    %ebp
  804aa6:	c3                   	ret    
  804aa7:	90                   	nop
  804aa8:	39 fe                	cmp    %edi,%esi
  804aaa:	75 d5                	jne    804a81 <__umoddi3+0x101>
  804aac:	89 f9                	mov    %edi,%ecx
  804aae:	89 c2                	mov    %eax,%edx
  804ab0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804ab3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804ab6:	eb c9                	jmp    804a81 <__umoddi3+0x101>
  804ab8:	39 f7                	cmp    %esi,%edi
  804aba:	0f 82 10 ff ff ff    	jb     8049d0 <__umoddi3+0x50>
  804ac0:	e9 17 ff ff ff       	jmp    8049dc <__umoddi3+0x5c>
