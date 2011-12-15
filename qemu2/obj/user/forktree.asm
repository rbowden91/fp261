
obj/user/forktree:     file format elf32-i386


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
  80002c:	e8 d3 00 00 00       	call   800104 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z8forktreePKc>:
	}
}

void
forktree(const char *cur)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
  80003b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003e:	e8 85 0c 00 00       	call   800cc8 <_Z12sys_getenvidv>
  800043:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800047:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004b:	c7 04 24 e0 43 80 00 	movl   $0x8043e0,(%esp)
  800052:	e8 df 01 00 00       	call   800236 <_Z7cprintfPKcz>

	forkchild(cur, '0');
  800057:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80005e:	00 
  80005f:	89 1c 24             	mov    %ebx,(%esp)
  800062:	e8 1b 00 00 00       	call   800082 <_Z9forkchildPKcc>
	// Yield to give the child a chance to run.
	// This will make child environment IDs slightly more predictable.
	sys_yield();
  800067:	e8 90 0c 00 00       	call   800cfc <_Z9sys_yieldv>
	forkchild(cur, '1');
  80006c:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  800073:	00 
  800074:	89 1c 24             	mov    %ebx,(%esp)
  800077:	e8 06 00 00 00       	call   800082 <_Z9forkchildPKcc>
}
  80007c:	83 c4 14             	add    $0x14,%esp
  80007f:	5b                   	pop    %ebx
  800080:	5d                   	pop    %ebp
  800081:	c3                   	ret    

00800082 <_Z9forkchildPKcc>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800082:	55                   	push   %ebp
  800083:	89 e5                	mov    %esp,%ebp
  800085:	83 ec 38             	sub    $0x38,%esp
  800088:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80008b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80008e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800091:	0f b6 75 0c          	movzbl 0xc(%ebp),%esi
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800095:	89 1c 24             	mov    %ebx,(%esp)
  800098:	e8 73 07 00 00       	call   800810 <_Z6strlenPKc>
  80009d:	83 f8 02             	cmp    $0x2,%eax
  8000a0:	7f 41                	jg     8000e3 <_Z9forkchildPKcc+0x61>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  8000a2:	89 f0                	mov    %esi,%eax
  8000a4:	0f be f0             	movsbl %al,%esi
  8000a7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8000ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000af:	c7 44 24 08 f1 43 80 	movl   $0x8043f1,0x8(%esp)
  8000b6:	00 
  8000b7:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000be:	00 
  8000bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000c2:	89 04 24             	mov    %eax,(%esp)
  8000c5:	e8 17 07 00 00       	call   8007e1 <_Z8snprintfPciPKcz>
	if (sfork() == 0) {
  8000ca:	e8 f1 13 00 00       	call   8014c0 <_Z5sforkv>
  8000cf:	85 c0                	test   %eax,%eax
  8000d1:	75 10                	jne    8000e3 <_Z9forkchildPKcc+0x61>
		forktree(nxt);
  8000d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000d6:	89 04 24             	mov    %eax,(%esp)
  8000d9:	e8 56 ff ff ff       	call   800034 <_Z8forktreePKc>
		exit();
  8000de:	e8 89 00 00 00       	call   80016c <_Z4exitv>
	}
}
  8000e3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000e6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000e9:	89 ec                	mov    %ebp,%esp
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <_Z5umainiPPc>:
	forkchild(cur, '1');
}

void
umain(int argc, char **argv)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	83 ec 18             	sub    $0x18,%esp
	forktree("");
  8000f3:	c7 04 24 f0 43 80 00 	movl   $0x8043f0,(%esp)
  8000fa:	e8 35 ff ff ff       	call   800034 <_Z8forktreePKc>
}
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    
  800101:	00 00                	add    %al,(%eax)
	...

00800104 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	57                   	push   %edi
  800108:	56                   	push   %esi
  800109:	53                   	push   %ebx
  80010a:	83 ec 1c             	sub    $0x1c,%esp
  80010d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800110:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800113:	e8 b0 0b 00 00       	call   800cc8 <_Z12sys_getenvidv>
  800118:	25 ff 03 00 00       	and    $0x3ff,%eax
  80011d:	6b c0 78             	imul   $0x78,%eax,%eax
  800120:	05 00 00 00 ef       	add    $0xef000000,%eax
  800125:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012a:	85 ff                	test   %edi,%edi
  80012c:	7e 07                	jle    800135 <libmain+0x31>
		binaryname = argv[0];
  80012e:	8b 06                	mov    (%esi),%eax
  800130:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800135:	b8 b5 4f 80 00       	mov    $0x804fb5,%eax
  80013a:	3d b5 4f 80 00       	cmp    $0x804fb5,%eax
  80013f:	76 0f                	jbe    800150 <libmain+0x4c>
  800141:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800143:	83 eb 04             	sub    $0x4,%ebx
  800146:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800148:	81 fb b5 4f 80 00    	cmp    $0x804fb5,%ebx
  80014e:	77 f3                	ja     800143 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800150:	89 74 24 04          	mov    %esi,0x4(%esp)
  800154:	89 3c 24             	mov    %edi,(%esp)
  800157:	e8 91 ff ff ff       	call   8000ed <_Z5umainiPPc>

	// exit gracefully
	exit();
  80015c:	e8 0b 00 00 00       	call   80016c <_Z4exitv>
}
  800161:	83 c4 1c             	add    $0x1c,%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
  800169:	00 00                	add    %al,(%eax)
	...

0080016c <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800172:	e8 a7 17 00 00       	call   80191e <_Z9close_allv>
	sys_env_destroy(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 e8 0a 00 00       	call   800c6b <_Z15sys_env_destroyi>
}
  800183:	c9                   	leave  
  800184:	c3                   	ret    
  800185:	00 00                	add    %al,(%eax)
	...

00800188 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 18             	sub    $0x18,%esp
  80018e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800191:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800194:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  800197:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800199:	8b 03                	mov    (%ebx),%eax
  80019b:	8b 55 08             	mov    0x8(%ebp),%edx
  80019e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001a2:	83 c0 01             	add    $0x1,%eax
  8001a5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ac:	75 19                	jne    8001c7 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8001ae:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001b5:	00 
  8001b6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b9:	89 04 24             	mov    %eax,(%esp)
  8001bc:	e8 43 0a 00 00       	call   800c04 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8001c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001c7:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001cb:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001ce:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001d1:	89 ec                	mov    %ebp,%esp
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001de:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e5:	00 00 00 
	b.cnt = 0;
  8001e8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ef:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8001f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800200:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020a:	c7 04 24 88 01 80 00 	movl   $0x800188,(%esp)
  800211:	e8 a1 01 00 00       	call   8003b7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800216:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80021c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800220:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800226:	89 04 24             	mov    %eax,(%esp)
  800229:	e8 d6 09 00 00       	call   800c04 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  80022e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80023c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800243:	8b 45 08             	mov    0x8(%ebp),%eax
  800246:	89 04 24             	mov    %eax,(%esp)
  800249:	e8 87 ff ff ff       	call   8001d5 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 4c             	sub    $0x4c,%esp
  800259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80025c:	89 d6                	mov    %edx,%esi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800264:	8b 55 0c             	mov    0xc(%ebp),%edx
  800267:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80026a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800270:	b8 00 00 00 00       	mov    $0x0,%eax
  800275:	39 d0                	cmp    %edx,%eax
  800277:	72 11                	jb     80028a <_ZL8printnumPFviPvES_yjii+0x3a>
  800279:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80027c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80027f:	76 09                	jbe    80028a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800281:	83 eb 01             	sub    $0x1,%ebx
  800284:	85 db                	test   %ebx,%ebx
  800286:	7f 5d                	jg     8002e5 <_ZL8printnumPFviPvES_yjii+0x95>
  800288:	eb 6c                	jmp    8002f6 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80028a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80028e:	83 eb 01             	sub    $0x1,%ebx
  800291:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800295:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800298:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80029c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002a0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002a7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8002aa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002b1:	00 
  8002b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002b5:	89 14 24             	mov    %edx,(%esp)
  8002b8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002bf:	e8 bc 3e 00 00       	call   804180 <__udivdi3>
  8002c4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002c7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002ca:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ce:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002d2:	89 04 24             	mov    %eax,(%esp)
  8002d5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002d9:	89 f2                	mov    %esi,%edx
  8002db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002de:	e8 6d ff ff ff       	call   800250 <_ZL8printnumPFviPvES_yjii>
  8002e3:	eb 11                	jmp    8002f6 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002e9:	89 3c 24             	mov    %edi,(%esp)
  8002ec:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002ef:	83 eb 01             	sub    $0x1,%ebx
  8002f2:	85 db                	test   %ebx,%ebx
  8002f4:	7f ef                	jg     8002e5 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002fa:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	89 44 24 08          	mov    %eax,0x8(%esp)
  800305:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80030c:	00 
  80030d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800310:	89 14 24             	mov    %edx,(%esp)
  800313:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800316:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80031a:	e8 71 3f 00 00       	call   804290 <__umoddi3>
  80031f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800323:	0f be 80 00 44 80 00 	movsbl 0x804400(%eax),%eax
  80032a:	89 04 24             	mov    %eax,(%esp)
  80032d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800330:	83 c4 4c             	add    $0x4c,%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    

00800338 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80033b:	83 fa 01             	cmp    $0x1,%edx
  80033e:	7e 0e                	jle    80034e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8d 4a 08             	lea    0x8(%edx),%ecx
  800345:	89 08                	mov    %ecx,(%eax)
  800347:	8b 02                	mov    (%edx),%eax
  800349:	8b 52 04             	mov    0x4(%edx),%edx
  80034c:	eb 22                	jmp    800370 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80034e:	85 d2                	test   %edx,%edx
  800350:	74 10                	je     800362 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800352:	8b 10                	mov    (%eax),%edx
  800354:	8d 4a 04             	lea    0x4(%edx),%ecx
  800357:	89 08                	mov    %ecx,(%eax)
  800359:	8b 02                	mov    (%edx),%eax
  80035b:	ba 00 00 00 00       	mov    $0x0,%edx
  800360:	eb 0e                	jmp    800370 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800362:	8b 10                	mov    (%eax),%edx
  800364:	8d 4a 04             	lea    0x4(%edx),%ecx
  800367:	89 08                	mov    %ecx,(%eax)
  800369:	8b 02                	mov    (%edx),%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800370:	5d                   	pop    %ebp
  800371:	c3                   	ret    

00800372 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800378:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80037c:	8b 10                	mov    (%eax),%edx
  80037e:	3b 50 04             	cmp    0x4(%eax),%edx
  800381:	73 0a                	jae    80038d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800383:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800386:	88 0a                	mov    %cl,(%edx)
  800388:	83 c2 01             	add    $0x1,%edx
  80038b:	89 10                	mov    %edx,(%eax)
}
  80038d:	5d                   	pop    %ebp
  80038e:	c3                   	ret    

0080038f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800395:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800398:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80039c:	8b 45 10             	mov    0x10(%ebp),%eax
  80039f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	89 04 24             	mov    %eax,(%esp)
  8003b0:	e8 02 00 00 00       	call   8003b7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	57                   	push   %edi
  8003bb:	56                   	push   %esi
  8003bc:	53                   	push   %ebx
  8003bd:	83 ec 3c             	sub    $0x3c,%esp
  8003c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003c3:	8b 55 10             	mov    0x10(%ebp),%edx
  8003c6:	0f b6 02             	movzbl (%edx),%eax
  8003c9:	89 d3                	mov    %edx,%ebx
  8003cb:	83 c3 01             	add    $0x1,%ebx
  8003ce:	83 f8 25             	cmp    $0x25,%eax
  8003d1:	74 2b                	je     8003fe <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  8003d3:	85 c0                	test   %eax,%eax
  8003d5:	75 10                	jne    8003e7 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  8003d7:	e9 a5 03 00 00       	jmp    800781 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	66 90                	xchg   %ax,%ax
  8003e0:	75 08                	jne    8003ea <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  8003e2:	e9 9a 03 00 00       	jmp    800781 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8003e7:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  8003ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ee:	89 04 24             	mov    %eax,(%esp)
  8003f1:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003f3:	0f b6 03             	movzbl (%ebx),%eax
  8003f6:	83 c3 01             	add    $0x1,%ebx
  8003f9:	83 f8 25             	cmp    $0x25,%eax
  8003fc:	75 de                	jne    8003dc <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8003fe:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800402:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800409:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80040e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800415:	b9 00 00 00 00       	mov    $0x0,%ecx
  80041a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80041d:	eb 2b                	jmp    80044a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800422:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800426:	eb 22                	jmp    80044a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800428:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80042b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80042f:	eb 19                	jmp    80044a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800431:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800434:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80043b:	eb 0d                	jmp    80044a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80043d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800440:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800443:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	0f b6 03             	movzbl (%ebx),%eax
  80044d:	0f b6 d0             	movzbl %al,%edx
  800450:	8d 73 01             	lea    0x1(%ebx),%esi
  800453:	89 75 10             	mov    %esi,0x10(%ebp)
  800456:	83 e8 23             	sub    $0x23,%eax
  800459:	3c 55                	cmp    $0x55,%al
  80045b:	0f 87 d8 02 00 00    	ja     800739 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800461:	0f b6 c0             	movzbl %al,%eax
  800464:	ff 24 85 a0 45 80 00 	jmp    *0x8045a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80046b:	83 ea 30             	sub    $0x30,%edx
  80046e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800471:	8b 55 10             	mov    0x10(%ebp),%edx
  800474:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800477:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80047d:	83 fa 09             	cmp    $0x9,%edx
  800480:	77 4e                	ja     8004d0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800482:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800485:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800488:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80048b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80048f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800492:	8d 50 d0             	lea    -0x30(%eax),%edx
  800495:	83 fa 09             	cmp    $0x9,%edx
  800498:	76 eb                	jbe    800485 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80049a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80049d:	eb 31                	jmp    8004d0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80049f:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a2:	8d 50 04             	lea    0x4(%eax),%edx
  8004a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004b0:	eb 1e                	jmp    8004d0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8004b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004b6:	0f 88 75 ff ff ff    	js     800431 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004bf:	eb 89                	jmp    80044a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8004c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004c4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004cb:	e9 7a ff ff ff       	jmp    80044a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  8004d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004d4:	0f 89 70 ff ff ff    	jns    80044a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8004da:	e9 5e ff ff ff       	jmp    80043d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004df:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004e5:	e9 60 ff ff ff       	jmp    80044a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ed:	8d 50 04             	lea    0x4(%eax),%edx
  8004f0:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	89 04 24             	mov    %eax,(%esp)
  8004fc:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004ff:	e9 bf fe ff ff       	jmp    8003c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8d 50 04             	lea    0x4(%eax),%edx
  80050a:	89 55 14             	mov    %edx,0x14(%ebp)
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	89 c2                	mov    %eax,%edx
  800511:	c1 fa 1f             	sar    $0x1f,%edx
  800514:	31 d0                	xor    %edx,%eax
  800516:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800518:	83 f8 14             	cmp    $0x14,%eax
  80051b:	7f 0f                	jg     80052c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80051d:	8b 14 85 00 47 80 00 	mov    0x804700(,%eax,4),%edx
  800524:	85 d2                	test   %edx,%edx
  800526:	0f 85 35 02 00 00    	jne    800761 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80052c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800530:	c7 44 24 08 18 44 80 	movl   $0x804418,0x8(%esp)
  800537:	00 
  800538:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053c:	8b 75 08             	mov    0x8(%ebp),%esi
  80053f:	89 34 24             	mov    %esi,(%esp)
  800542:	e8 48 fe ff ff       	call   80038f <_Z8printfmtPFviPvES_PKcz>
  800547:	e9 77 fe ff ff       	jmp    8003c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80054c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8d 50 04             	lea    0x4(%eax),%edx
  80055b:	89 55 14             	mov    %edx,0x14(%ebp)
  80055e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800560:	85 db                	test   %ebx,%ebx
  800562:	ba 11 44 80 00       	mov    $0x804411,%edx
  800567:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80056a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80056e:	7e 72                	jle    8005e2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800570:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800574:	74 6c                	je     8005e2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800576:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057a:	89 1c 24             	mov    %ebx,(%esp)
  80057d:	e8 a9 02 00 00       	call   80082b <_Z7strnlenPKcj>
  800582:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800585:	29 c2                	sub    %eax,%edx
  800587:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80058a:	85 d2                	test   %edx,%edx
  80058c:	7e 54                	jle    8005e2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80058e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800592:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800595:	89 d3                	mov    %edx,%ebx
  800597:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80059a:	89 c6                	mov    %eax,%esi
  80059c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a0:	89 34 24             	mov    %esi,(%esp)
  8005a3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a6:	83 eb 01             	sub    $0x1,%ebx
  8005a9:	85 db                	test   %ebx,%ebx
  8005ab:	7f ef                	jg     80059c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  8005ad:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8005b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005ba:	eb 26                	jmp    8005e2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005bc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005bf:	83 fa 5e             	cmp    $0x5e,%edx
  8005c2:	76 10                	jbe    8005d4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  8005c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005cf:	ff 55 08             	call   *0x8(%ebp)
  8005d2:	eb 0a                	jmp    8005de <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  8005d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005d8:	89 04 24             	mov    %eax,(%esp)
  8005db:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005de:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005e2:	0f be 03             	movsbl (%ebx),%eax
  8005e5:	83 c3 01             	add    $0x1,%ebx
  8005e8:	85 c0                	test   %eax,%eax
  8005ea:	74 11                	je     8005fd <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  8005ec:	85 f6                	test   %esi,%esi
  8005ee:	78 05                	js     8005f5 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  8005f0:	83 ee 01             	sub    $0x1,%esi
  8005f3:	78 0d                	js     800602 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  8005f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f9:	75 c1                	jne    8005bc <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  8005fb:	eb d7                	jmp    8005d4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800600:	eb 03                	jmp    800605 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800605:	85 c0                	test   %eax,%eax
  800607:	0f 8e b6 fd ff ff    	jle    8003c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80060d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800610:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800613:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800617:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80061e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800620:	83 eb 01             	sub    $0x1,%ebx
  800623:	85 db                	test   %ebx,%ebx
  800625:	7f ec                	jg     800613 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800627:	e9 97 fd ff ff       	jmp    8003c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80062c:	83 f9 01             	cmp    $0x1,%ecx
  80062f:	90                   	nop
  800630:	7e 10                	jle    800642 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8d 50 08             	lea    0x8(%eax),%edx
  800638:	89 55 14             	mov    %edx,0x14(%ebp)
  80063b:	8b 18                	mov    (%eax),%ebx
  80063d:	8b 70 04             	mov    0x4(%eax),%esi
  800640:	eb 26                	jmp    800668 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800642:	85 c9                	test   %ecx,%ecx
  800644:	74 12                	je     800658 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 50 04             	lea    0x4(%eax),%edx
  80064c:	89 55 14             	mov    %edx,0x14(%ebp)
  80064f:	8b 18                	mov    (%eax),%ebx
  800651:	89 de                	mov    %ebx,%esi
  800653:	c1 fe 1f             	sar    $0x1f,%esi
  800656:	eb 10                	jmp    800668 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 50 04             	lea    0x4(%eax),%edx
  80065e:	89 55 14             	mov    %edx,0x14(%ebp)
  800661:	8b 18                	mov    (%eax),%ebx
  800663:	89 de                	mov    %ebx,%esi
  800665:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800668:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80066d:	85 f6                	test   %esi,%esi
  80066f:	0f 89 8c 00 00 00    	jns    800701 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800675:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800679:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800680:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800683:	f7 db                	neg    %ebx
  800685:	83 d6 00             	adc    $0x0,%esi
  800688:	f7 de                	neg    %esi
			}
			base = 10;
  80068a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068f:	eb 70                	jmp    800701 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800691:	89 ca                	mov    %ecx,%edx
  800693:	8d 45 14             	lea    0x14(%ebp),%eax
  800696:	e8 9d fc ff ff       	call   800338 <_ZL7getuintPPci>
  80069b:	89 c3                	mov    %eax,%ebx
  80069d:	89 d6                	mov    %edx,%esi
			base = 10;
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8006a4:	eb 5b                	jmp    800701 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006a6:	89 ca                	mov    %ecx,%edx
  8006a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ab:	e8 88 fc ff ff       	call   800338 <_ZL7getuintPPci>
  8006b0:	89 c3                	mov    %eax,%ebx
  8006b2:	89 d6                	mov    %edx,%esi
			base = 8;
  8006b4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006b9:	eb 46                	jmp    800701 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8006bb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006bf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006c6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006cd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006d4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 50 04             	lea    0x4(%eax),%edx
  8006dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e0:	8b 18                	mov    (%eax),%ebx
  8006e2:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  8006e7:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  8006ec:	eb 13                	jmp    800701 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006ee:	89 ca                	mov    %ecx,%edx
  8006f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f3:	e8 40 fc ff ff       	call   800338 <_ZL7getuintPPci>
  8006f8:	89 c3                	mov    %eax,%ebx
  8006fa:	89 d6                	mov    %edx,%esi
			base = 16;
  8006fc:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800701:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800705:	89 54 24 10          	mov    %edx,0x10(%esp)
  800709:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80070c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800710:	89 44 24 08          	mov    %eax,0x8(%esp)
  800714:	89 1c 24             	mov    %ebx,(%esp)
  800717:	89 74 24 04          	mov    %esi,0x4(%esp)
  80071b:	89 fa                	mov    %edi,%edx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	e8 2b fb ff ff       	call   800250 <_ZL8printnumPFviPvES_yjii>
			break;
  800725:	e9 99 fc ff ff       	jmp    8003c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80072a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072e:	89 14 24             	mov    %edx,(%esp)
  800731:	ff 55 08             	call   *0x8(%ebp)
			break;
  800734:	e9 8a fc ff ff       	jmp    8003c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800739:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800744:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800747:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80074a:	89 d8                	mov    %ebx,%eax
  80074c:	eb 02                	jmp    800750 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80074e:	89 d0                	mov    %edx,%eax
  800750:	8d 50 ff             	lea    -0x1(%eax),%edx
  800753:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800757:	75 f5                	jne    80074e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800759:	89 45 10             	mov    %eax,0x10(%ebp)
  80075c:	e9 62 fc ff ff       	jmp    8003c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800761:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800765:	c7 44 24 08 26 48 80 	movl   $0x804826,0x8(%esp)
  80076c:	00 
  80076d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800771:	8b 75 08             	mov    0x8(%ebp),%esi
  800774:	89 34 24             	mov    %esi,(%esp)
  800777:	e8 13 fc ff ff       	call   80038f <_Z8printfmtPFviPvES_PKcz>
  80077c:	e9 42 fc ff ff       	jmp    8003c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800781:	83 c4 3c             	add    $0x3c,%esp
  800784:	5b                   	pop    %ebx
  800785:	5e                   	pop    %esi
  800786:	5f                   	pop    %edi
  800787:	5d                   	pop    %ebp
  800788:	c3                   	ret    

00800789 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	83 ec 28             	sub    $0x28,%esp
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800795:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80079c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80079f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  8007a6:	85 c0                	test   %eax,%eax
  8007a8:	74 30                	je     8007da <_Z9vsnprintfPciPKcS_+0x51>
  8007aa:	85 d2                	test   %edx,%edx
  8007ac:	7e 2c                	jle    8007da <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007bc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c3:	c7 04 24 72 03 80 00 	movl   $0x800372,(%esp)
  8007ca:	e8 e8 fb ff ff       	call   8003b7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  8007cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d8:	eb 05                	jmp    8007df <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007df:	c9                   	leave  
  8007e0:	c3                   	ret    

008007e1 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	89 04 24             	mov    %eax,(%esp)
  800802:	e8 82 ff ff ff       	call   800789 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800807:	c9                   	leave  
  800808:	c3                   	ret    
  800809:	00 00                	add    %al,(%eax)
  80080b:	00 00                	add    %al,(%eax)
  80080d:	00 00                	add    %al,(%eax)
	...

00800810 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	80 3a 00             	cmpb   $0x0,(%edx)
  80081e:	74 09                	je     800829 <_Z6strlenPKc+0x19>
		n++;
  800820:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800823:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800827:	75 f7                	jne    800820 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800831:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800834:	b8 00 00 00 00       	mov    $0x0,%eax
  800839:	39 c2                	cmp    %eax,%edx
  80083b:	74 0b                	je     800848 <_Z7strnlenPKcj+0x1d>
  80083d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800841:	74 05                	je     800848 <_Z7strnlenPKcj+0x1d>
		n++;
  800843:	83 c0 01             	add    $0x1,%eax
  800846:	eb f1                	jmp    800839 <_Z7strnlenPKcj+0xe>
	return n;
}
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	53                   	push   %ebx
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800854:	ba 00 00 00 00       	mov    $0x0,%edx
  800859:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80085d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800860:	83 c2 01             	add    $0x1,%edx
  800863:	84 c9                	test   %cl,%cl
  800865:	75 f2                	jne    800859 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800867:	5b                   	pop    %ebx
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	56                   	push   %esi
  80086e:	53                   	push   %ebx
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	8b 55 0c             	mov    0xc(%ebp),%edx
  800875:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800878:	85 f6                	test   %esi,%esi
  80087a:	74 18                	je     800894 <_Z7strncpyPcPKcj+0x2a>
  80087c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800881:	0f b6 1a             	movzbl (%edx),%ebx
  800884:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800887:	80 3a 01             	cmpb   $0x1,(%edx)
  80088a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  80088d:	83 c1 01             	add    $0x1,%ecx
  800890:	39 ce                	cmp    %ecx,%esi
  800892:	77 ed                	ja     800881 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800894:	5b                   	pop    %ebx
  800895:	5e                   	pop    %esi
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	56                   	push   %esi
  80089c:	53                   	push   %ebx
  80089d:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  8008a6:	89 f0                	mov    %esi,%eax
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	74 17                	je     8008c3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  8008ac:	83 ea 01             	sub    $0x1,%edx
  8008af:	74 18                	je     8008c9 <_Z7strlcpyPcPKcj+0x31>
  8008b1:	80 39 00             	cmpb   $0x0,(%ecx)
  8008b4:	74 17                	je     8008cd <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8008b6:	0f b6 19             	movzbl (%ecx),%ebx
  8008b9:	88 18                	mov    %bl,(%eax)
  8008bb:	83 c0 01             	add    $0x1,%eax
  8008be:	83 c1 01             	add    $0x1,%ecx
  8008c1:	eb e9                	jmp    8008ac <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  8008c3:	29 f0                	sub    %esi,%eax
}
  8008c5:	5b                   	pop    %ebx
  8008c6:	5e                   	pop    %esi
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008c9:	89 c2                	mov    %eax,%edx
  8008cb:	eb 02                	jmp    8008cf <_Z7strlcpyPcPKcj+0x37>
  8008cd:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008cf:	c6 02 00             	movb   $0x0,(%edx)
  8008d2:	eb ef                	jmp    8008c3 <_Z7strlcpyPcPKcj+0x2b>

008008d4 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008da:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008dd:	0f b6 01             	movzbl (%ecx),%eax
  8008e0:	84 c0                	test   %al,%al
  8008e2:	74 0c                	je     8008f0 <_Z6strcmpPKcS0_+0x1c>
  8008e4:	3a 02                	cmp    (%edx),%al
  8008e6:	75 08                	jne    8008f0 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  8008e8:	83 c1 01             	add    $0x1,%ecx
  8008eb:	83 c2 01             	add    $0x1,%edx
  8008ee:	eb ed                	jmp    8008dd <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  8008f0:	0f b6 c0             	movzbl %al,%eax
  8008f3:	0f b6 12             	movzbl (%edx),%edx
  8008f6:	29 d0                	sub    %edx,%eax
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	53                   	push   %ebx
  8008fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800901:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800904:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800907:	85 d2                	test   %edx,%edx
  800909:	74 16                	je     800921 <_Z7strncmpPKcS0_j+0x27>
  80090b:	0f b6 01             	movzbl (%ecx),%eax
  80090e:	84 c0                	test   %al,%al
  800910:	74 17                	je     800929 <_Z7strncmpPKcS0_j+0x2f>
  800912:	3a 03                	cmp    (%ebx),%al
  800914:	75 13                	jne    800929 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800916:	83 ea 01             	sub    $0x1,%edx
  800919:	83 c1 01             	add    $0x1,%ecx
  80091c:	83 c3 01             	add    $0x1,%ebx
  80091f:	eb e6                	jmp    800907 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800926:	5b                   	pop    %ebx
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800929:	0f b6 01             	movzbl (%ecx),%eax
  80092c:	0f b6 13             	movzbl (%ebx),%edx
  80092f:	29 d0                	sub    %edx,%eax
  800931:	eb f3                	jmp    800926 <_Z7strncmpPKcS0_j+0x2c>

00800933 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093d:	0f b6 10             	movzbl (%eax),%edx
  800940:	84 d2                	test   %dl,%dl
  800942:	74 1f                	je     800963 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800944:	38 ca                	cmp    %cl,%dl
  800946:	75 0a                	jne    800952 <_Z6strchrPKcc+0x1f>
  800948:	eb 1e                	jmp    800968 <_Z6strchrPKcc+0x35>
  80094a:	38 ca                	cmp    %cl,%dl
  80094c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800950:	74 16                	je     800968 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800952:	83 c0 01             	add    $0x1,%eax
  800955:	0f b6 10             	movzbl (%eax),%edx
  800958:	84 d2                	test   %dl,%dl
  80095a:	75 ee                	jne    80094a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80095c:	b8 00 00 00 00       	mov    $0x0,%eax
  800961:	eb 05                	jmp    800968 <_Z6strchrPKcc+0x35>
  800963:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800974:	0f b6 10             	movzbl (%eax),%edx
  800977:	84 d2                	test   %dl,%dl
  800979:	74 14                	je     80098f <_Z7strfindPKcc+0x25>
		if (*s == c)
  80097b:	38 ca                	cmp    %cl,%dl
  80097d:	75 06                	jne    800985 <_Z7strfindPKcc+0x1b>
  80097f:	eb 0e                	jmp    80098f <_Z7strfindPKcc+0x25>
  800981:	38 ca                	cmp    %cl,%dl
  800983:	74 0a                	je     80098f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800985:	83 c0 01             	add    $0x1,%eax
  800988:	0f b6 10             	movzbl (%eax),%edx
  80098b:	84 d2                	test   %dl,%dl
  80098d:	75 f2                	jne    800981 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 0c             	sub    $0xc,%esp
  800997:	89 1c 24             	mov    %ebx,(%esp)
  80099a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80099e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  8009ab:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009b1:	75 25                	jne    8009d8 <memset+0x47>
  8009b3:	f6 c1 03             	test   $0x3,%cl
  8009b6:	75 20                	jne    8009d8 <memset+0x47>
		c &= 0xFF;
  8009b8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009bb:	89 d3                	mov    %edx,%ebx
  8009bd:	c1 e3 08             	shl    $0x8,%ebx
  8009c0:	89 d6                	mov    %edx,%esi
  8009c2:	c1 e6 18             	shl    $0x18,%esi
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	c1 e0 10             	shl    $0x10,%eax
  8009ca:	09 f0                	or     %esi,%eax
  8009cc:	09 d0                	or     %edx,%eax
  8009ce:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  8009d0:	c1 e9 02             	shr    $0x2,%ecx
  8009d3:	fc                   	cld    
  8009d4:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d6:	eb 03                	jmp    8009db <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  8009d8:	fc                   	cld    
  8009d9:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  8009db:	89 f8                	mov    %edi,%eax
  8009dd:	8b 1c 24             	mov    (%esp),%ebx
  8009e0:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009e8:	89 ec                	mov    %ebp,%esp
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	89 34 24             	mov    %esi,(%esp)
  8009f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800a02:	39 c6                	cmp    %eax,%esi
  800a04:	73 36                	jae    800a3c <memmove+0x50>
  800a06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a09:	39 d0                	cmp    %edx,%eax
  800a0b:	73 2f                	jae    800a3c <memmove+0x50>
		s += n;
		d += n;
  800a0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a10:	f6 c2 03             	test   $0x3,%dl
  800a13:	75 1b                	jne    800a30 <memmove+0x44>
  800a15:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a1b:	75 13                	jne    800a30 <memmove+0x44>
  800a1d:	f6 c1 03             	test   $0x3,%cl
  800a20:	75 0e                	jne    800a30 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a22:	83 ef 04             	sub    $0x4,%edi
  800a25:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a28:	c1 e9 02             	shr    $0x2,%ecx
  800a2b:	fd                   	std    
  800a2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a2e:	eb 09                	jmp    800a39 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a30:	83 ef 01             	sub    $0x1,%edi
  800a33:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a36:	fd                   	std    
  800a37:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a39:	fc                   	cld    
  800a3a:	eb 20                	jmp    800a5c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a3c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a42:	75 13                	jne    800a57 <memmove+0x6b>
  800a44:	a8 03                	test   $0x3,%al
  800a46:	75 0f                	jne    800a57 <memmove+0x6b>
  800a48:	f6 c1 03             	test   $0x3,%cl
  800a4b:	75 0a                	jne    800a57 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a4d:	c1 e9 02             	shr    $0x2,%ecx
  800a50:	89 c7                	mov    %eax,%edi
  800a52:	fc                   	cld    
  800a53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a55:	eb 05                	jmp    800a5c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800a57:	89 c7                	mov    %eax,%edi
  800a59:	fc                   	cld    
  800a5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800a5c:	8b 34 24             	mov    (%esp),%esi
  800a5f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a63:	89 ec                	mov    %ebp,%esp
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	89 34 24             	mov    %esi,(%esp)
  800a70:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a7d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a83:	75 13                	jne    800a98 <memcpy+0x31>
  800a85:	a8 03                	test   $0x3,%al
  800a87:	75 0f                	jne    800a98 <memcpy+0x31>
  800a89:	f6 c1 03             	test   $0x3,%cl
  800a8c:	75 0a                	jne    800a98 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a8e:	c1 e9 02             	shr    $0x2,%ecx
  800a91:	89 c7                	mov    %eax,%edi
  800a93:	fc                   	cld    
  800a94:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a96:	eb 05                	jmp    800a9d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800a98:	89 c7                	mov    %eax,%edi
  800a9a:	fc                   	cld    
  800a9b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800a9d:	8b 34 24             	mov    (%esp),%esi
  800aa0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800aa4:	89 ec                	mov    %ebp,%esp
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	57                   	push   %edi
  800aac:	56                   	push   %esi
  800aad:	53                   	push   %ebx
  800aae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ab1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800ab7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800abc:	85 ff                	test   %edi,%edi
  800abe:	74 38                	je     800af8 <memcmp+0x50>
		if (*s1 != *s2)
  800ac0:	0f b6 03             	movzbl (%ebx),%eax
  800ac3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800ac6:	83 ef 01             	sub    $0x1,%edi
  800ac9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800ace:	38 c8                	cmp    %cl,%al
  800ad0:	74 1d                	je     800aef <memcmp+0x47>
  800ad2:	eb 11                	jmp    800ae5 <memcmp+0x3d>
  800ad4:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800ad9:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800ade:	83 c2 01             	add    $0x1,%edx
  800ae1:	38 c8                	cmp    %cl,%al
  800ae3:	74 0a                	je     800aef <memcmp+0x47>
			return *s1 - *s2;
  800ae5:	0f b6 c0             	movzbl %al,%eax
  800ae8:	0f b6 c9             	movzbl %cl,%ecx
  800aeb:	29 c8                	sub    %ecx,%eax
  800aed:	eb 09                	jmp    800af8 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800aef:	39 fa                	cmp    %edi,%edx
  800af1:	75 e1                	jne    800ad4 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800af3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af8:	5b                   	pop    %ebx
  800af9:	5e                   	pop    %esi
  800afa:	5f                   	pop    %edi
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	53                   	push   %ebx
  800b01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800b04:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800b06:	89 da                	mov    %ebx,%edx
  800b08:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800b0b:	39 d3                	cmp    %edx,%ebx
  800b0d:	73 15                	jae    800b24 <memfind+0x27>
		if (*s == (unsigned char) c)
  800b0f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b13:	38 0b                	cmp    %cl,(%ebx)
  800b15:	75 06                	jne    800b1d <memfind+0x20>
  800b17:	eb 0b                	jmp    800b24 <memfind+0x27>
  800b19:	38 08                	cmp    %cl,(%eax)
  800b1b:	74 07                	je     800b24 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800b1d:	83 c0 01             	add    $0x1,%eax
  800b20:	39 c2                	cmp    %eax,%edx
  800b22:	77 f5                	ja     800b19 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b24:	5b                   	pop    %ebx
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	57                   	push   %edi
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b33:	0f b6 02             	movzbl (%edx),%eax
  800b36:	3c 20                	cmp    $0x20,%al
  800b38:	74 04                	je     800b3e <_Z6strtolPKcPPci+0x17>
  800b3a:	3c 09                	cmp    $0x9,%al
  800b3c:	75 0e                	jne    800b4c <_Z6strtolPKcPPci+0x25>
		s++;
  800b3e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b41:	0f b6 02             	movzbl (%edx),%eax
  800b44:	3c 20                	cmp    $0x20,%al
  800b46:	74 f6                	je     800b3e <_Z6strtolPKcPPci+0x17>
  800b48:	3c 09                	cmp    $0x9,%al
  800b4a:	74 f2                	je     800b3e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b4c:	3c 2b                	cmp    $0x2b,%al
  800b4e:	75 0a                	jne    800b5a <_Z6strtolPKcPPci+0x33>
		s++;
  800b50:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b53:	bf 00 00 00 00       	mov    $0x0,%edi
  800b58:	eb 10                	jmp    800b6a <_Z6strtolPKcPPci+0x43>
  800b5a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b5f:	3c 2d                	cmp    $0x2d,%al
  800b61:	75 07                	jne    800b6a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800b63:	83 c2 01             	add    $0x1,%edx
  800b66:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6a:	85 db                	test   %ebx,%ebx
  800b6c:	0f 94 c0             	sete   %al
  800b6f:	74 05                	je     800b76 <_Z6strtolPKcPPci+0x4f>
  800b71:	83 fb 10             	cmp    $0x10,%ebx
  800b74:	75 15                	jne    800b8b <_Z6strtolPKcPPci+0x64>
  800b76:	80 3a 30             	cmpb   $0x30,(%edx)
  800b79:	75 10                	jne    800b8b <_Z6strtolPKcPPci+0x64>
  800b7b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b7f:	75 0a                	jne    800b8b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800b81:	83 c2 02             	add    $0x2,%edx
  800b84:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b89:	eb 13                	jmp    800b9e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800b8b:	84 c0                	test   %al,%al
  800b8d:	74 0f                	je     800b9e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b94:	80 3a 30             	cmpb   $0x30,(%edx)
  800b97:	75 05                	jne    800b9e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800b99:	83 c2 01             	add    $0x1,%edx
  800b9c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ba5:	0f b6 0a             	movzbl (%edx),%ecx
  800ba8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bab:	80 fb 09             	cmp    $0x9,%bl
  800bae:	77 08                	ja     800bb8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800bb0:	0f be c9             	movsbl %cl,%ecx
  800bb3:	83 e9 30             	sub    $0x30,%ecx
  800bb6:	eb 1e                	jmp    800bd6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800bb8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800bbb:	80 fb 19             	cmp    $0x19,%bl
  800bbe:	77 08                	ja     800bc8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800bc0:	0f be c9             	movsbl %cl,%ecx
  800bc3:	83 e9 57             	sub    $0x57,%ecx
  800bc6:	eb 0e                	jmp    800bd6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800bc8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800bcb:	80 fb 19             	cmp    $0x19,%bl
  800bce:	77 15                	ja     800be5 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800bd0:	0f be c9             	movsbl %cl,%ecx
  800bd3:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bd6:	39 f1                	cmp    %esi,%ecx
  800bd8:	7d 0f                	jge    800be9 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800bda:	83 c2 01             	add    $0x1,%edx
  800bdd:	0f af c6             	imul   %esi,%eax
  800be0:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800be3:	eb c0                	jmp    800ba5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800be5:	89 c1                	mov    %eax,%ecx
  800be7:	eb 02                	jmp    800beb <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be9:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800beb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bef:	74 05                	je     800bf6 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800bf1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bf4:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800bf6:	89 ca                	mov    %ecx,%edx
  800bf8:	f7 da                	neg    %edx
  800bfa:	85 ff                	test   %edi,%edi
  800bfc:	0f 45 c2             	cmovne %edx,%eax
}
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 0c             	sub    $0xc,%esp
  800c0a:	89 1c 24             	mov    %ebx,(%esp)
  800c0d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c11:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c20:	89 c3                	mov    %eax,%ebx
  800c22:	89 c7                	mov    %eax,%edi
  800c24:	89 c6                	mov    %eax,%esi
  800c26:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c28:	8b 1c 24             	mov    (%esp),%ebx
  800c2b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c2f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c33:	89 ec                	mov    %ebp,%esp
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	89 1c 24             	mov    %ebx,(%esp)
  800c40:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c44:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c48:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c52:	89 d1                	mov    %edx,%ecx
  800c54:	89 d3                	mov    %edx,%ebx
  800c56:	89 d7                	mov    %edx,%edi
  800c58:	89 d6                	mov    %edx,%esi
  800c5a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c5c:	8b 1c 24             	mov    (%esp),%ebx
  800c5f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c63:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c67:	89 ec                	mov    %ebp,%esp
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 38             	sub    $0x38,%esp
  800c71:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c74:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c77:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c7f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c84:	8b 55 08             	mov    0x8(%ebp),%edx
  800c87:	89 cb                	mov    %ecx,%ebx
  800c89:	89 cf                	mov    %ecx,%edi
  800c8b:	89 ce                	mov    %ecx,%esi
  800c8d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	7e 28                	jle    800cbb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c93:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c97:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c9e:	00 
  800c9f:	c7 44 24 08 54 47 80 	movl   $0x804754,0x8(%esp)
  800ca6:	00 
  800ca7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cae:	00 
  800caf:	c7 04 24 71 47 80 00 	movl   $0x804771,(%esp)
  800cb6:	e8 01 32 00 00       	call   803ebc <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cbe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cc1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cc4:	89 ec                	mov    %ebp,%esp
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 0c             	sub    $0xc,%esp
  800cce:	89 1c 24             	mov    %ebx,(%esp)
  800cd1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cd5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cde:	b8 02 00 00 00       	mov    $0x2,%eax
  800ce3:	89 d1                	mov    %edx,%ecx
  800ce5:	89 d3                	mov    %edx,%ebx
  800ce7:	89 d7                	mov    %edx,%edi
  800ce9:	89 d6                	mov    %edx,%esi
  800ceb:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ced:	8b 1c 24             	mov    (%esp),%ebx
  800cf0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cf4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cf8:	89 ec                	mov    %ebp,%esp
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	89 1c 24             	mov    %ebx,(%esp)
  800d05:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d09:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d12:	b8 04 00 00 00       	mov    $0x4,%eax
  800d17:	89 d1                	mov    %edx,%ecx
  800d19:	89 d3                	mov    %edx,%ebx
  800d1b:	89 d7                	mov    %edx,%edi
  800d1d:	89 d6                	mov    %edx,%esi
  800d1f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d21:	8b 1c 24             	mov    (%esp),%ebx
  800d24:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d28:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d2c:	89 ec                	mov    %ebp,%esp
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 38             	sub    $0x38,%esp
  800d36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d3f:	be 00 00 00 00       	mov    $0x0,%esi
  800d44:	b8 08 00 00 00       	mov    $0x8,%eax
  800d49:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	89 f7                	mov    %esi,%edi
  800d54:	cd 30                	int    $0x30

	if(check && ret > 0)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	7e 28                	jle    800d82 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d65:	00 
  800d66:	c7 44 24 08 54 47 80 	movl   $0x804754,0x8(%esp)
  800d6d:	00 
  800d6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d75:	00 
  800d76:	c7 04 24 71 47 80 00 	movl   $0x804771,(%esp)
  800d7d:	e8 3a 31 00 00       	call   803ebc <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d82:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d85:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d88:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d8b:	89 ec                	mov    %ebp,%esp
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 38             	sub    $0x38,%esp
  800d95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d98:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d9b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800da3:	8b 75 18             	mov    0x18(%ebp),%esi
  800da6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	cd 30                	int    $0x30

	if(check && ret > 0)
  800db4:	85 c0                	test   %eax,%eax
  800db6:	7e 28                	jle    800de0 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dbc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dc3:	00 
  800dc4:	c7 44 24 08 54 47 80 	movl   $0x804754,0x8(%esp)
  800dcb:	00 
  800dcc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd3:	00 
  800dd4:	c7 04 24 71 47 80 00 	movl   $0x804771,(%esp)
  800ddb:	e8 dc 30 00 00       	call   803ebc <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800de3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800de6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800de9:	89 ec                	mov    %ebp,%esp
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    

00800ded <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	83 ec 38             	sub    $0x38,%esp
  800df3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df9:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	89 df                	mov    %ebx,%edi
  800e0e:	89 de                	mov    %ebx,%esi
  800e10:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	7e 28                	jle    800e3e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e16:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e21:	00 
  800e22:	c7 44 24 08 54 47 80 	movl   $0x804754,0x8(%esp)
  800e29:	00 
  800e2a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e31:	00 
  800e32:	c7 04 24 71 47 80 00 	movl   $0x804771,(%esp)
  800e39:	e8 7e 30 00 00       	call   803ebc <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e3e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e41:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e44:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e47:	89 ec                	mov    %ebp,%esp
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 38             	sub    $0x38,%esp
  800e51:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e54:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e57:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5f:	b8 05 00 00 00       	mov    $0x5,%eax
  800e64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	89 df                	mov    %ebx,%edi
  800e6c:	89 de                	mov    %ebx,%esi
  800e6e:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	7e 28                	jle    800e9c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e74:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e78:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e7f:	00 
  800e80:	c7 44 24 08 54 47 80 	movl   $0x804754,0x8(%esp)
  800e87:	00 
  800e88:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8f:	00 
  800e90:	c7 04 24 71 47 80 00 	movl   $0x804771,(%esp)
  800e97:	e8 20 30 00 00       	call   803ebc <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e9c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e9f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ea2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea5:	89 ec                	mov    %ebp,%esp
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	83 ec 38             	sub    $0x38,%esp
  800eaf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eb2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800eb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebd:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	89 df                	mov    %ebx,%edi
  800eca:	89 de                	mov    %ebx,%esi
  800ecc:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	7e 28                	jle    800efa <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800edd:	00 
  800ede:	c7 44 24 08 54 47 80 	movl   $0x804754,0x8(%esp)
  800ee5:	00 
  800ee6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eed:	00 
  800eee:	c7 04 24 71 47 80 00 	movl   $0x804771,(%esp)
  800ef5:	e8 c2 2f 00 00       	call   803ebc <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800efa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800efd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f00:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f03:	89 ec                	mov    %ebp,%esp
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 38             	sub    $0x38,%esp
  800f0d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f10:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f13:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	89 df                	mov    %ebx,%edi
  800f28:	89 de                	mov    %ebx,%esi
  800f2a:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	7e 28                	jle    800f58 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f34:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f3b:	00 
  800f3c:	c7 44 24 08 54 47 80 	movl   $0x804754,0x8(%esp)
  800f43:	00 
  800f44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4b:	00 
  800f4c:	c7 04 24 71 47 80 00 	movl   $0x804771,(%esp)
  800f53:	e8 64 2f 00 00       	call   803ebc <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f58:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f5b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f61:	89 ec                	mov    %ebp,%esp
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 38             	sub    $0x38,%esp
  800f6b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f71:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f79:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	89 df                	mov    %ebx,%edi
  800f86:	89 de                	mov    %ebx,%esi
  800f88:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	7e 28                	jle    800fb6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f92:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  800f99:	00 
  800f9a:	c7 44 24 08 54 47 80 	movl   $0x804754,0x8(%esp)
  800fa1:	00 
  800fa2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa9:	00 
  800faa:	c7 04 24 71 47 80 00 	movl   $0x804771,(%esp)
  800fb1:	e8 06 2f 00 00       	call   803ebc <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fbc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fbf:	89 ec                	mov    %ebp,%esp
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 0c             	sub    $0xc,%esp
  800fc9:	89 1c 24             	mov    %ebx,(%esp)
  800fcc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fd0:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fd4:	be 00 00 00 00       	mov    $0x0,%esi
  800fd9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fde:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fea:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fec:	8b 1c 24             	mov    (%esp),%ebx
  800fef:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ff3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ff7:	89 ec                	mov    %ebp,%esp
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
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
  80100a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801014:	8b 55 08             	mov    0x8(%ebp),%edx
  801017:	89 cb                	mov    %ecx,%ebx
  801019:	89 cf                	mov    %ecx,%edi
  80101b:	89 ce                	mov    %ecx,%esi
  80101d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80101f:	85 c0                	test   %eax,%eax
  801021:	7e 28                	jle    80104b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801023:	89 44 24 10          	mov    %eax,0x10(%esp)
  801027:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80102e:	00 
  80102f:	c7 44 24 08 54 47 80 	movl   $0x804754,0x8(%esp)
  801036:	00 
  801037:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103e:	00 
  80103f:	c7 04 24 71 47 80 00 	movl   $0x804771,(%esp)
  801046:	e8 71 2e 00 00       	call   803ebc <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80104b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80104e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801051:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801054:	89 ec                	mov    %ebp,%esp
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 0c             	sub    $0xc,%esp
  80105e:	89 1c 24             	mov    %ebx,(%esp)
  801061:	89 74 24 04          	mov    %esi,0x4(%esp)
  801065:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801073:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	89 df                	mov    %ebx,%edi
  80107b:	89 de                	mov    %ebx,%esi
  80107d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80107f:	8b 1c 24             	mov    (%esp),%ebx
  801082:	8b 74 24 04          	mov    0x4(%esp),%esi
  801086:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80108a:	89 ec                	mov    %ebp,%esp
  80108c:	5d                   	pop    %ebp
  80108d:	c3                   	ret    

0080108e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 0c             	sub    $0xc,%esp
  801094:	89 1c 24             	mov    %ebx,(%esp)
  801097:	89 74 24 04          	mov    %esi,0x4(%esp)
  80109b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80109f:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a4:	b8 11 00 00 00       	mov    $0x11,%eax
  8010a9:	89 d1                	mov    %edx,%ecx
  8010ab:	89 d3                	mov    %edx,%ebx
  8010ad:	89 d7                	mov    %edx,%edi
  8010af:	89 d6                	mov    %edx,%esi
  8010b1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010b3:	8b 1c 24             	mov    (%esp),%ebx
  8010b6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010ba:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010be:	89 ec                	mov    %ebp,%esp
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    

008010c2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	89 1c 24             	mov    %ebx,(%esp)
  8010cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010cf:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d8:	b8 12 00 00 00       	mov    $0x12,%eax
  8010dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e3:	89 df                	mov    %ebx,%edi
  8010e5:	89 de                	mov    %ebx,%esi
  8010e7:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  8010e9:	8b 1c 24             	mov    (%esp),%ebx
  8010ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010f0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010f4:	89 ec                	mov    %ebp,%esp
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 0c             	sub    $0xc,%esp
  8010fe:	89 1c 24             	mov    %ebx,(%esp)
  801101:	89 74 24 04          	mov    %esi,0x4(%esp)
  801105:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801109:	b9 00 00 00 00       	mov    $0x0,%ecx
  80110e:	b8 13 00 00 00       	mov    $0x13,%eax
  801113:	8b 55 08             	mov    0x8(%ebp),%edx
  801116:	89 cb                	mov    %ecx,%ebx
  801118:	89 cf                	mov    %ecx,%edi
  80111a:	89 ce                	mov    %ecx,%esi
  80111c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80111e:	8b 1c 24             	mov    (%esp),%ebx
  801121:	8b 74 24 04          	mov    0x4(%esp),%esi
  801125:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801129:	89 ec                	mov    %ebp,%esp
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	89 1c 24             	mov    %ebx,(%esp)
  801136:	89 74 24 04          	mov    %esi,0x4(%esp)
  80113a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80113e:	b8 10 00 00 00       	mov    $0x10,%eax
  801143:	8b 75 18             	mov    0x18(%ebp),%esi
  801146:	8b 7d 14             	mov    0x14(%ebp),%edi
  801149:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80114c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114f:	8b 55 08             	mov    0x8(%ebp),%edx
  801152:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801154:	8b 1c 24             	mov    (%esp),%ebx
  801157:	8b 74 24 04          	mov    0x4(%esp),%esi
  80115b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80115f:	89 ec                	mov    %ebp,%esp
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    
	...

00801164 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 38             	sub    $0x38,%esp
  80116a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80116d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801170:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  801173:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  80117a:	f6 c7 04             	test   $0x4,%bh
  80117d:	74 31                	je     8011b0 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  80117f:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  801186:	c1 e2 0c             	shl    $0xc,%edx
  801189:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80118f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801193:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801197:	89 44 24 08          	mov    %eax,0x8(%esp)
  80119b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80119f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a6:	e8 e4 fb ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
        return r;
  8011ab:	e9 8c 00 00 00       	jmp    80123c <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  8011b0:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  8011b7:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  8011bc:	f7 c6 00 08 00 00    	test   $0x800,%esi
  8011c2:	75 2a                	jne    8011ee <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  8011c4:	84 c9                	test   %cl,%cl
  8011c6:	74 0f                	je     8011d7 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  8011c8:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  8011cf:	83 e3 02             	and    $0x2,%ebx
  8011d2:	80 cf 02             	or     $0x2,%bh
  8011d5:	eb 17                	jmp    8011ee <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  8011d7:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  8011de:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  8011e1:	83 f9 01             	cmp    $0x1,%ecx
  8011e4:	19 db                	sbb    %ebx,%ebx
  8011e6:	f7 d3                	not    %ebx
  8011e8:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  8011ee:	89 df                	mov    %ebx,%edi
  8011f0:	83 cf 05             	or     $0x5,%edi
  8011f3:	89 d6                	mov    %edx,%esi
  8011f5:	c1 e6 0c             	shl    $0xc,%esi
  8011f8:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8011fc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801200:	89 44 24 08          	mov    %eax,0x8(%esp)
  801204:	89 74 24 04          	mov    %esi,0x4(%esp)
  801208:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80120f:	e8 7b fb ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
  801214:	85 c0                	test   %eax,%eax
  801216:	75 24                	jne    80123c <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  801218:	85 db                	test   %ebx,%ebx
  80121a:	74 20                	je     80123c <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80121c:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801220:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801224:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80122b:	00 
  80122c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801230:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801237:	e8 53 fb ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  80123c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80123f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801242:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801245:	89 ec                	mov    %ebp,%esp
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    

00801249 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 28             	sub    $0x28,%esp
  80124f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801252:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801255:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  801258:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  80125a:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  80125e:	0f 84 ff 00 00 00    	je     801363 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  801264:	89 f0                	mov    %esi,%eax
  801266:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  801269:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801270:	f6 c4 08             	test   $0x8,%ah
  801273:	0f 84 ea 00 00 00    	je     801363 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801279:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801280:	00 
  801281:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801288:	00 
  801289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801290:	e8 9b fa ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  801295:	85 c0                	test   %eax,%eax
  801297:	79 20                	jns    8012b9 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  801299:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80129d:	c7 44 24 08 7f 47 80 	movl   $0x80477f,0x8(%esp)
  8012a4:	00 
  8012a5:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8012ac:	00 
  8012ad:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  8012b4:	e8 03 2c 00 00       	call   803ebc <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  8012b9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  8012bf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012c6:	00 
  8012c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012cb:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8012d2:	e8 90 f7 ff ff       	call   800a67 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8012d7:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012de:	00 
  8012df:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012ea:	00 
  8012eb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012f2:	00 
  8012f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012fa:	e8 90 fa ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
  8012ff:	85 c0                	test   %eax,%eax
  801301:	79 20                	jns    801323 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  801303:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801307:	c7 44 24 08 9d 47 80 	movl   $0x80479d,0x8(%esp)
  80130e:	00 
  80130f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801316:	00 
  801317:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  80131e:	e8 99 2b 00 00       	call   803ebc <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801323:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80132a:	00 
  80132b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801332:	e8 b6 fa ff ff       	call   800ded <_Z14sys_page_unmapiPv>
  801337:	85 c0                	test   %eax,%eax
  801339:	79 20                	jns    80135b <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  80133b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133f:	c7 44 24 08 ae 47 80 	movl   $0x8047ae,0x8(%esp)
  801346:	00 
  801347:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80134e:	00 
  80134f:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  801356:	e8 61 2b 00 00       	call   803ebc <_Z6_panicPKciS0_z>
    resume(utf);
  80135b:	89 1c 24             	mov    %ebx,(%esp)
  80135e:	e8 fd 2c 00 00       	call   804060 <resume>
}
  801363:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801366:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801369:	89 ec                	mov    %ebp,%esp
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	57                   	push   %edi
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
  801373:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  801376:	c7 04 24 49 12 80 00 	movl   $0x801249,(%esp)
  80137d:	e8 09 2c 00 00       	call   803f8b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  801382:	be 07 00 00 00       	mov    $0x7,%esi
  801387:	89 f0                	mov    %esi,%eax
  801389:	cd 30                	int    $0x30
  80138b:	89 c6                	mov    %eax,%esi
  80138d:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  80138f:	85 c0                	test   %eax,%eax
  801391:	79 20                	jns    8013b3 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  801393:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801397:	c7 44 24 08 c1 47 80 	movl   $0x8047c1,0x8(%esp)
  80139e:	00 
  80139f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8013a6:	00 
  8013a7:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  8013ae:	e8 09 2b 00 00       	call   803ebc <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  8013b3:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	75 1c                	jne    8013d8 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  8013bc:	e8 07 f9 ff ff       	call   800cc8 <_Z12sys_getenvidv>
  8013c1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013c6:	6b c0 78             	imul   $0x78,%eax,%eax
  8013c9:	05 00 00 00 ef       	add    $0xef000000,%eax
  8013ce:	a3 00 60 80 00       	mov    %eax,0x806000
        return 0;
  8013d3:	e9 de 00 00 00       	jmp    8014b6 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  8013d8:	89 d8                	mov    %ebx,%eax
  8013da:	c1 f8 0a             	sar    $0xa,%eax
  8013dd:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8013e4:	a8 01                	test   $0x1,%al
  8013e6:	75 08                	jne    8013f0 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  8013e8:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8013ee:	eb 19                	jmp    801409 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  8013f0:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8013f7:	a8 01                	test   $0x1,%al
  8013f9:	74 0e                	je     801409 <_Z4forkv+0x9c>
            duppage(envid, pn);
  8013fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801400:	89 da                	mov    %ebx,%edx
  801402:	89 f8                	mov    %edi,%eax
  801404:	e8 5b fd ff ff       	call   801164 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801409:	83 eb 01             	sub    $0x1,%ebx
  80140c:	79 ca                	jns    8013d8 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  80140e:	a1 00 60 80 00       	mov    0x806000,%eax
  801413:	8b 40 5c             	mov    0x5c(%eax),%eax
  801416:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141a:	89 34 24             	mov    %esi,(%esp)
  80141d:	e8 43 fb ff ff       	call   800f65 <_Z26sys_env_set_pgfault_upcalliPv>
  801422:	85 c0                	test   %eax,%eax
  801424:	74 20                	je     801446 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801426:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80142a:	c7 44 24 08 e8 47 80 	movl   $0x8047e8,0x8(%esp)
  801431:	00 
  801432:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  801439:	00 
  80143a:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  801441:	e8 76 2a 00 00       	call   803ebc <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801446:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80144d:	00 
  80144e:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  801455:	ee 
  801456:	89 34 24             	mov    %esi,(%esp)
  801459:	e8 d2 f8 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  80145e:	85 c0                	test   %eax,%eax
  801460:	79 20                	jns    801482 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  801462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801466:	c7 44 24 08 7f 47 80 	movl   $0x80477f,0x8(%esp)
  80146d:	00 
  80146e:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  801475:	00 
  801476:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  80147d:	e8 3a 2a 00 00       	call   803ebc <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801482:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801489:	00 
  80148a:	89 34 24             	mov    %esi,(%esp)
  80148d:	e8 b9 f9 ff ff       	call   800e4b <_Z18sys_env_set_statusii>
  801492:	85 c0                	test   %eax,%eax
  801494:	79 20                	jns    8014b6 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  801496:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80149a:	c7 44 24 08 d1 47 80 	movl   $0x8047d1,0x8(%esp)
  8014a1:	00 
  8014a2:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  8014a9:	00 
  8014aa:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  8014b1:	e8 06 2a 00 00       	call   803ebc <_Z6_panicPKciS0_z>

    return envid;
}
  8014b6:	89 f0                	mov    %esi,%eax
  8014b8:	83 c4 1c             	add    $0x1c,%esp
  8014bb:	5b                   	pop    %ebx
  8014bc:	5e                   	pop    %esi
  8014bd:	5f                   	pop    %edi
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	57                   	push   %edi
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  8014c9:	c7 04 24 49 12 80 00 	movl   $0x801249,(%esp)
  8014d0:	e8 b6 2a 00 00       	call   803f8b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  8014d5:	be 07 00 00 00       	mov    $0x7,%esi
  8014da:	89 f0                	mov    %esi,%eax
  8014dc:	cd 30                	int    $0x30
  8014de:	89 c6                	mov    %eax,%esi
  8014e0:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	79 20                	jns    801506 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  8014e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014ea:	c7 44 24 08 c1 47 80 	movl   $0x8047c1,0x8(%esp)
  8014f1:	00 
  8014f2:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  8014f9:	00 
  8014fa:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  801501:	e8 b6 29 00 00       	call   803ebc <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  801506:	85 c0                	test   %eax,%eax
  801508:	0f 84 40 01 00 00    	je     80164e <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  80150e:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  801510:	c1 eb 0c             	shr    $0xc,%ebx
  801513:	83 eb 01             	sub    $0x1,%ebx
  801516:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  801519:	eb 31                	jmp    80154c <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  80151b:	89 d8                	mov    %ebx,%eax
  80151d:	c1 f8 0a             	sar    $0xa,%eax
  801520:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801527:	a8 01                	test   $0x1,%al
  801529:	75 08                	jne    801533 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  80152b:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801531:	eb 19                	jmp    80154c <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  801533:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  80153a:	a8 01                	test   $0x1,%al
  80153c:	74 0e                	je     80154c <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  80153e:	b9 01 00 00 00       	mov    $0x1,%ecx
  801543:	89 da                	mov    %ebx,%edx
  801545:	89 f8                	mov    %edi,%eax
  801547:	e8 18 fc ff ff       	call   801164 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  80154c:	83 eb 01             	sub    $0x1,%ebx
  80154f:	79 ca                	jns    80151b <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  801551:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  801558:	7f 3f                	jg     801599 <_Z5sforkv+0xd9>
  80155a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  80155d:	89 d8                	mov    %ebx,%eax
  80155f:	c1 f8 0a             	sar    $0xa,%eax
  801562:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801569:	a8 01                	test   $0x1,%al
  80156b:	75 08                	jne    801575 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  80156d:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801573:	eb 19                	jmp    80158e <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  801575:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  80157c:	a8 01                	test   $0x1,%al
  80157e:	74 0e                	je     80158e <_Z5sforkv+0xce>
            duppage(envid, i);
  801580:	b9 00 00 00 00       	mov    $0x0,%ecx
  801585:	89 da                	mov    %ebx,%edx
  801587:	89 f8                	mov    %edi,%eax
  801589:	e8 d6 fb ff ff       	call   801164 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  80158e:	83 c3 01             	add    $0x1,%ebx
  801591:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  801597:	7e c4                	jle    80155d <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  801599:	e8 2a f7 ff ff       	call   800cc8 <_Z12sys_getenvidv>
  80159e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015a3:	6b c0 78             	imul   $0x78,%eax,%eax
  8015a6:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  8015ab:	8b 40 50             	mov    0x50(%eax),%eax
  8015ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b2:	89 34 24             	mov    %esi,(%esp)
  8015b5:	e8 ab f9 ff ff       	call   800f65 <_Z26sys_env_set_pgfault_upcalliPv>
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	74 20                	je     8015de <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  8015be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015c2:	c7 44 24 08 e8 47 80 	movl   $0x8047e8,0x8(%esp)
  8015c9:	00 
  8015ca:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  8015d1:	00 
  8015d2:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  8015d9:	e8 de 28 00 00       	call   803ebc <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8015de:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015e5:	00 
  8015e6:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8015ed:	ee 
  8015ee:	89 34 24             	mov    %esi,(%esp)
  8015f1:	e8 3a f7 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	79 20                	jns    80161a <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  8015fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015fe:	c7 44 24 08 7f 47 80 	movl   $0x80477f,0x8(%esp)
  801605:	00 
  801606:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  80160d:	00 
  80160e:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  801615:	e8 a2 28 00 00       	call   803ebc <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80161a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801621:	00 
  801622:	89 34 24             	mov    %esi,(%esp)
  801625:	e8 21 f8 ff ff       	call   800e4b <_Z18sys_env_set_statusii>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	79 20                	jns    80164e <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  80162e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801632:	c7 44 24 08 d1 47 80 	movl   $0x8047d1,0x8(%esp)
  801639:	00 
  80163a:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  801641:	00 
  801642:	c7 04 24 92 47 80 00 	movl   $0x804792,(%esp)
  801649:	e8 6e 28 00 00       	call   803ebc <_Z6_panicPKciS0_z>

    return envid;
    
}
  80164e:	89 f0                	mov    %esi,%eax
  801650:	83 c4 2c             	add    $0x2c,%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5f                   	pop    %edi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    
	...

00801660 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801663:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801668:	75 11                	jne    80167b <_ZL8fd_validPK2Fd+0x1b>
  80166a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80166f:	76 0a                	jbe    80167b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801671:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801676:	0f 96 c0             	setbe  %al
  801679:	eb 05                	jmp    801680 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801680:	5d                   	pop    %ebp
  801681:	c3                   	ret    

00801682 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	53                   	push   %ebx
  801686:	83 ec 14             	sub    $0x14,%esp
  801689:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80168b:	e8 d0 ff ff ff       	call   801660 <_ZL8fd_validPK2Fd>
  801690:	84 c0                	test   %al,%al
  801692:	75 24                	jne    8016b8 <_ZL9fd_isopenPK2Fd+0x36>
  801694:	c7 44 24 0c 07 48 80 	movl   $0x804807,0xc(%esp)
  80169b:	00 
  80169c:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  8016a3:	00 
  8016a4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8016ab:	00 
  8016ac:	c7 04 24 29 48 80 00 	movl   $0x804829,(%esp)
  8016b3:	e8 04 28 00 00       	call   803ebc <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  8016b8:	89 d8                	mov    %ebx,%eax
  8016ba:	c1 e8 16             	shr    $0x16,%eax
  8016bd:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	f6 c2 01             	test   $0x1,%dl
  8016cc:	74 0d                	je     8016db <_ZL9fd_isopenPK2Fd+0x59>
  8016ce:	c1 eb 0c             	shr    $0xc,%ebx
  8016d1:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  8016d8:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  8016db:	83 c4 14             	add    $0x14,%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5d                   	pop    %ebp
  8016e0:	c3                   	ret    

008016e1 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	89 1c 24             	mov    %ebx,(%esp)
  8016ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8016f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016f4:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8016f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8016fb:	77 18                	ja     801715 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  8016fd:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801703:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801706:	84 c0                	test   %al,%al
  801708:	74 21                	je     80172b <_Z9fd_lookupiPP2Fdb+0x4a>
  80170a:	89 d8                	mov    %ebx,%eax
  80170c:	e8 71 ff ff ff       	call   801682 <_ZL9fd_isopenPK2Fd>
  801711:	84 c0                	test   %al,%al
  801713:	75 16                	jne    80172b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801715:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80171b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801720:	8b 1c 24             	mov    (%esp),%ebx
  801723:	8b 74 24 04          	mov    0x4(%esp),%esi
  801727:	89 ec                	mov    %ebp,%esp
  801729:	5d                   	pop    %ebp
  80172a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80172b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
  801732:	eb ec                	jmp    801720 <_Z9fd_lookupiPP2Fdb+0x3f>

00801734 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	53                   	push   %ebx
  801738:	83 ec 14             	sub    $0x14,%esp
  80173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80173e:	89 d8                	mov    %ebx,%eax
  801740:	e8 1b ff ff ff       	call   801660 <_ZL8fd_validPK2Fd>
  801745:	84 c0                	test   %al,%al
  801747:	75 24                	jne    80176d <_Z6fd2numP2Fd+0x39>
  801749:	c7 44 24 0c 07 48 80 	movl   $0x804807,0xc(%esp)
  801750:	00 
  801751:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  801758:	00 
  801759:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801760:	00 
  801761:	c7 04 24 29 48 80 00 	movl   $0x804829,(%esp)
  801768:	e8 4f 27 00 00       	call   803ebc <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80176d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801773:	c1 e8 0c             	shr    $0xc,%eax
}
  801776:	83 c4 14             	add    $0x14,%esp
  801779:	5b                   	pop    %ebx
  80177a:	5d                   	pop    %ebp
  80177b:	c3                   	ret    

0080177c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	89 04 24             	mov    %eax,(%esp)
  801788:	e8 a7 ff ff ff       	call   801734 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  80178d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801792:	c1 e0 0c             	shl    $0xc,%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	57                   	push   %edi
  80179b:	56                   	push   %esi
  80179c:	53                   	push   %ebx
  80179d:	83 ec 2c             	sub    $0x2c,%esp
  8017a0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8017a3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8017a8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8017ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b2:	00 
  8017b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017b7:	89 1c 24             	mov    %ebx,(%esp)
  8017ba:	e8 22 ff ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  8017bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017c2:	e8 bb fe ff ff       	call   801682 <_ZL9fd_isopenPK2Fd>
  8017c7:	84 c0                	test   %al,%al
  8017c9:	75 0c                	jne    8017d7 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  8017cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ce:	89 07                	mov    %eax,(%edi)
			return 0;
  8017d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d5:	eb 13                	jmp    8017ea <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8017d7:	83 c3 01             	add    $0x1,%ebx
  8017da:	83 fb 20             	cmp    $0x20,%ebx
  8017dd:	75 cc                	jne    8017ab <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017df:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  8017e5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8017ea:	83 c4 2c             	add    $0x2c,%esp
  8017ed:	5b                   	pop    %ebx
  8017ee:	5e                   	pop    %esi
  8017ef:	5f                   	pop    %edi
  8017f0:	5d                   	pop    %ebp
  8017f1:	c3                   	ret    

008017f2 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	53                   	push   %ebx
  8017f6:	83 ec 14             	sub    $0x14,%esp
  8017f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801804:	39 0d 04 50 80 00    	cmp    %ecx,0x805004
  80180a:	75 16                	jne    801822 <_Z10dev_lookupiPP3Dev+0x30>
  80180c:	eb 06                	jmp    801814 <_Z10dev_lookupiPP3Dev+0x22>
  80180e:	39 0a                	cmp    %ecx,(%edx)
  801810:	75 10                	jne    801822 <_Z10dev_lookupiPP3Dev+0x30>
  801812:	eb 05                	jmp    801819 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801814:	ba 04 50 80 00       	mov    $0x805004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801819:	89 13                	mov    %edx,(%ebx)
			return 0;
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	eb 35                	jmp    801857 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801822:	83 c0 01             	add    $0x1,%eax
  801825:	8b 14 85 94 48 80 00 	mov    0x804894(,%eax,4),%edx
  80182c:	85 d2                	test   %edx,%edx
  80182e:	75 de                	jne    80180e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801830:	a1 00 60 80 00       	mov    0x806000,%eax
  801835:	8b 40 04             	mov    0x4(%eax),%eax
  801838:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80183c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801840:	c7 04 24 50 48 80 00 	movl   $0x804850,(%esp)
  801847:	e8 ea e9 ff ff       	call   800236 <_Z7cprintfPKcz>
	*dev = 0;
  80184c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801852:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801857:	83 c4 14             	add    $0x14,%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5d                   	pop    %ebp
  80185c:	c3                   	ret    

0080185d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	56                   	push   %esi
  801861:	53                   	push   %ebx
  801862:	83 ec 20             	sub    $0x20,%esp
  801865:	8b 75 08             	mov    0x8(%ebp),%esi
  801868:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80186c:	89 34 24             	mov    %esi,(%esp)
  80186f:	e8 c0 fe ff ff       	call   801734 <_Z6fd2numP2Fd>
  801874:	0f b6 d3             	movzbl %bl,%edx
  801877:	89 54 24 08          	mov    %edx,0x8(%esp)
  80187b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80187e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801882:	89 04 24             	mov    %eax,(%esp)
  801885:	e8 57 fe ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 05                	js     801893 <_Z8fd_closeP2Fdb+0x36>
  80188e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801891:	74 0c                	je     80189f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801893:	80 fb 01             	cmp    $0x1,%bl
  801896:	19 db                	sbb    %ebx,%ebx
  801898:	f7 d3                	not    %ebx
  80189a:	83 e3 fd             	and    $0xfffffffd,%ebx
  80189d:	eb 3d                	jmp    8018dc <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80189f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a6:	8b 06                	mov    (%esi),%eax
  8018a8:	89 04 24             	mov    %eax,(%esp)
  8018ab:	e8 42 ff ff ff       	call   8017f2 <_Z10dev_lookupiPP3Dev>
  8018b0:	89 c3                	mov    %eax,%ebx
  8018b2:	85 c0                	test   %eax,%eax
  8018b4:	78 16                	js     8018cc <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  8018b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8018bc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	74 07                	je     8018cc <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  8018c5:	89 34 24             	mov    %esi,(%esp)
  8018c8:	ff d0                	call   *%eax
  8018ca:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8018cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018d7:	e8 11 f5 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
	return r;
}
  8018dc:	89 d8                	mov    %ebx,%eax
  8018de:	83 c4 20             	add    $0x20,%esp
  8018e1:	5b                   	pop    %ebx
  8018e2:	5e                   	pop    %esi
  8018e3:	5d                   	pop    %ebp
  8018e4:	c3                   	ret    

008018e5 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8018eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018f2:	00 
  8018f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	89 04 24             	mov    %eax,(%esp)
  801900:	e8 dc fd ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  801905:	85 c0                	test   %eax,%eax
  801907:	78 13                	js     80191c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801909:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801910:	00 
  801911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801914:	89 04 24             	mov    %eax,(%esp)
  801917:	e8 41 ff ff ff       	call   80185d <_Z8fd_closeP2Fdb>
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <_Z9close_allv>:

void
close_all(void)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	53                   	push   %ebx
  801922:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801925:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80192a:	89 1c 24             	mov    %ebx,(%esp)
  80192d:	e8 b3 ff ff ff       	call   8018e5 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801932:	83 c3 01             	add    $0x1,%ebx
  801935:	83 fb 20             	cmp    $0x20,%ebx
  801938:	75 f0                	jne    80192a <_Z9close_allv+0xc>
		close(i);
}
  80193a:	83 c4 14             	add    $0x14,%esp
  80193d:	5b                   	pop    %ebx
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    

00801940 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 48             	sub    $0x48,%esp
  801946:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801949:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80194c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80194f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801952:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801959:	00 
  80195a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80195d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	89 04 24             	mov    %eax,(%esp)
  801967:	e8 75 fd ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  80196c:	89 c3                	mov    %eax,%ebx
  80196e:	85 c0                	test   %eax,%eax
  801970:	0f 88 ce 00 00 00    	js     801a44 <_Z3dupii+0x104>
  801976:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80197d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  80197e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801981:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801985:	89 34 24             	mov    %esi,(%esp)
  801988:	e8 54 fd ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  80198d:	89 c3                	mov    %eax,%ebx
  80198f:	85 c0                	test   %eax,%eax
  801991:	0f 89 bc 00 00 00    	jns    801a53 <_Z3dupii+0x113>
  801997:	e9 a8 00 00 00       	jmp    801a44 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  80199c:	89 d8                	mov    %ebx,%eax
  80199e:	c1 e8 0c             	shr    $0xc,%eax
  8019a1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8019a8:	f6 c2 01             	test   $0x1,%dl
  8019ab:	74 32                	je     8019df <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019ad:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8019b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8019b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019c1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019c8:	00 
  8019c9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019d4:	e8 b6 f3 ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
  8019d9:	89 c3                	mov    %eax,%ebx
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	78 3e                	js     801a1d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019e2:	89 c2                	mov    %eax,%edx
  8019e4:	c1 ea 0c             	shr    $0xc,%edx
  8019e7:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  8019ee:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8019f4:	89 54 24 10          	mov    %edx,0x10(%esp)
  8019f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8019ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a06:	00 
  801a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a12:	e8 78 f3 ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
  801a17:	89 c3                	mov    %eax,%ebx
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	79 25                	jns    801a42 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a2b:	e8 bd f3 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801a30:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3b:	e8 ad f3 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
	return r;
  801a40:	eb 02                	jmp    801a44 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801a42:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a44:	89 d8                	mov    %ebx,%eax
  801a46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a49:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a4f:	89 ec                	mov    %ebp,%esp
  801a51:	5d                   	pop    %ebp
  801a52:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801a53:	89 34 24             	mov    %esi,(%esp)
  801a56:	e8 8a fe ff ff       	call   8018e5 <_Z5closei>

	ova = fd2data(oldfd);
  801a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a5e:	89 04 24             	mov    %eax,(%esp)
  801a61:	e8 16 fd ff ff       	call   80177c <_Z7fd2dataP2Fd>
  801a66:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6b:	89 04 24             	mov    %eax,(%esp)
  801a6e:	e8 09 fd ff ff       	call   80177c <_Z7fd2dataP2Fd>
  801a73:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801a75:	89 d8                	mov    %ebx,%eax
  801a77:	c1 e8 16             	shr    $0x16,%eax
  801a7a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801a81:	a8 01                	test   $0x1,%al
  801a83:	0f 85 13 ff ff ff    	jne    80199c <_Z3dupii+0x5c>
  801a89:	e9 51 ff ff ff       	jmp    8019df <_Z3dupii+0x9f>

00801a8e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	53                   	push   %ebx
  801a92:	83 ec 24             	sub    $0x24,%esp
  801a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801a98:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801a9f:	00 
  801aa0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa7:	89 1c 24             	mov    %ebx,(%esp)
  801aaa:	e8 32 fc ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 5f                	js     801b12 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801abd:	8b 00                	mov    (%eax),%eax
  801abf:	89 04 24             	mov    %eax,(%esp)
  801ac2:	e8 2b fd ff ff       	call   8017f2 <_Z10dev_lookupiPP3Dev>
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	79 4d                	jns    801b18 <_Z4readiPvj+0x8a>
  801acb:	eb 45                	jmp    801b12 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801acd:	a1 00 60 80 00       	mov    0x806000,%eax
  801ad2:	8b 40 04             	mov    0x4(%eax),%eax
  801ad5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801add:	c7 04 24 32 48 80 00 	movl   $0x804832,(%esp)
  801ae4:	e8 4d e7 ff ff       	call   800236 <_Z7cprintfPKcz>
		return -E_INVAL;
  801ae9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aee:	eb 22                	jmp    801b12 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af3:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801af6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801afb:	85 d2                	test   %edx,%edx
  801afd:	74 13                	je     801b12 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801aff:	8b 45 10             	mov    0x10(%ebp),%eax
  801b02:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0d:	89 0c 24             	mov    %ecx,(%esp)
  801b10:	ff d2                	call   *%edx
}
  801b12:	83 c4 24             	add    $0x24,%esp
  801b15:	5b                   	pop    %ebx
  801b16:	5d                   	pop    %ebp
  801b17:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b18:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b1b:	8b 41 08             	mov    0x8(%ecx),%eax
  801b1e:	83 e0 03             	and    $0x3,%eax
  801b21:	83 f8 01             	cmp    $0x1,%eax
  801b24:	75 ca                	jne    801af0 <_Z4readiPvj+0x62>
  801b26:	eb a5                	jmp    801acd <_Z4readiPvj+0x3f>

00801b28 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	57                   	push   %edi
  801b2c:	56                   	push   %esi
  801b2d:	53                   	push   %ebx
  801b2e:	83 ec 1c             	sub    $0x1c,%esp
  801b31:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b34:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801b37:	85 f6                	test   %esi,%esi
  801b39:	74 2f                	je     801b6a <_Z5readniPvj+0x42>
  801b3b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b40:	89 f0                	mov    %esi,%eax
  801b42:	29 d8                	sub    %ebx,%eax
  801b44:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b48:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	89 04 24             	mov    %eax,(%esp)
  801b55:	e8 34 ff ff ff       	call   801a8e <_Z4readiPvj>
		if (m < 0)
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	78 13                	js     801b71 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	74 0d                	je     801b6f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801b62:	01 c3                	add    %eax,%ebx
  801b64:	39 de                	cmp    %ebx,%esi
  801b66:	77 d8                	ja     801b40 <_Z5readniPvj+0x18>
  801b68:	eb 05                	jmp    801b6f <_Z5readniPvj+0x47>
  801b6a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801b6f:	89 d8                	mov    %ebx,%eax
}
  801b71:	83 c4 1c             	add    $0x1c,%esp
  801b74:	5b                   	pop    %ebx
  801b75:	5e                   	pop    %esi
  801b76:	5f                   	pop    %edi
  801b77:	5d                   	pop    %ebp
  801b78:	c3                   	ret    

00801b79 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801b7f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801b86:	00 
  801b87:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	89 04 24             	mov    %eax,(%esp)
  801b94:	e8 48 fb ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 3c                	js     801bd9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801ba7:	8b 00                	mov    (%eax),%eax
  801ba9:	89 04 24             	mov    %eax,(%esp)
  801bac:	e8 41 fc ff ff       	call   8017f2 <_Z10dev_lookupiPP3Dev>
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	79 26                	jns    801bdb <_Z5writeiPKvj+0x62>
  801bb5:	eb 22                	jmp    801bd9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bba:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  801bbd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801bc2:	85 c9                	test   %ecx,%ecx
  801bc4:	74 13                	je     801bd9 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd4:	89 14 24             	mov    %edx,(%esp)
  801bd7:	ff d1                	call   *%ecx
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801bdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  801bde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801be3:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801be7:	74 f0                	je     801bd9 <_Z5writeiPKvj+0x60>
  801be9:	eb cc                	jmp    801bb7 <_Z5writeiPKvj+0x3e>

00801beb <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801bf1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801bf8:	00 
  801bf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	89 04 24             	mov    %eax,(%esp)
  801c06:	e8 d6 fa ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	78 0e                	js     801c1d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c15:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	53                   	push   %ebx
  801c23:	83 ec 24             	sub    $0x24,%esp
  801c26:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801c29:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c30:	00 
  801c31:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c38:	89 1c 24             	mov    %ebx,(%esp)
  801c3b:	e8 a1 fa ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  801c40:	85 c0                	test   %eax,%eax
  801c42:	78 58                	js     801c9c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801c4e:	8b 00                	mov    (%eax),%eax
  801c50:	89 04 24             	mov    %eax,(%esp)
  801c53:	e8 9a fb ff ff       	call   8017f2 <_Z10dev_lookupiPP3Dev>
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	79 46                	jns    801ca2 <_Z9ftruncateii+0x83>
  801c5c:	eb 3e                	jmp    801c9c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801c5e:	a1 00 60 80 00       	mov    0x806000,%eax
  801c63:	8b 40 04             	mov    0x4(%eax),%eax
  801c66:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6e:	c7 04 24 70 48 80 00 	movl   $0x804870,(%esp)
  801c75:	e8 bc e5 ff ff       	call   800236 <_Z7cprintfPKcz>
		return -E_INVAL;
  801c7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c7f:	eb 1b                	jmp    801c9c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c84:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801c87:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c8c:	85 d2                	test   %edx,%edx
  801c8e:	74 0c                	je     801c9c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c97:	89 0c 24             	mov    %ecx,(%esp)
  801c9a:	ff d2                	call   *%edx
}
  801c9c:	83 c4 24             	add    $0x24,%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5d                   	pop    %ebp
  801ca1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ca2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ca5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801ca9:	75 d6                	jne    801c81 <_Z9ftruncateii+0x62>
  801cab:	eb b1                	jmp    801c5e <_Z9ftruncateii+0x3f>

00801cad <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	53                   	push   %ebx
  801cb1:	83 ec 24             	sub    $0x24,%esp
  801cb4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801cb7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801cbe:	00 
  801cbf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	89 04 24             	mov    %eax,(%esp)
  801ccc:	e8 10 fa ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 3e                	js     801d13 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801cdf:	8b 00                	mov    (%eax),%eax
  801ce1:	89 04 24             	mov    %eax,(%esp)
  801ce4:	e8 09 fb ff ff       	call   8017f2 <_Z10dev_lookupiPP3Dev>
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	79 2c                	jns    801d19 <_Z5fstatiP4Stat+0x6c>
  801ced:	eb 24                	jmp    801d13 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cef:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cf2:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801cf9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801d00:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0d:	89 04 24             	mov    %eax,(%esp)
  801d10:	ff 52 14             	call   *0x14(%edx)
}
  801d13:	83 c4 24             	add    $0x24,%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  801d1c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801d21:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801d25:	75 c8                	jne    801cef <_Z5fstatiP4Stat+0x42>
  801d27:	eb ea                	jmp    801d13 <_Z5fstatiP4Stat+0x66>

00801d29 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 18             	sub    $0x18,%esp
  801d2f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d32:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d35:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d3c:	00 
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	89 04 24             	mov    %eax,(%esp)
  801d43:	e8 d6 09 00 00       	call   80271e <_Z4openPKci>
  801d48:	89 c3                	mov    %eax,%ebx
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	78 1b                	js     801d69 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d55:	89 1c 24             	mov    %ebx,(%esp)
  801d58:	e8 50 ff ff ff       	call   801cad <_Z5fstatiP4Stat>
  801d5d:	89 c6                	mov    %eax,%esi
	close(fd);
  801d5f:	89 1c 24             	mov    %ebx,(%esp)
  801d62:	e8 7e fb ff ff       	call   8018e5 <_Z5closei>
	return r;
  801d67:	89 f3                	mov    %esi,%ebx
}
  801d69:	89 d8                	mov    %ebx,%eax
  801d6b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d6e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d71:	89 ec                	mov    %ebp,%esp
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    
	...

00801d80 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801d83:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801d88:	85 d2                	test   %edx,%edx
  801d8a:	78 33                	js     801dbf <_ZL10inode_dataP5Inodei+0x3f>
  801d8c:	3b 50 08             	cmp    0x8(%eax),%edx
  801d8f:	7d 2e                	jge    801dbf <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801d91:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801d97:	85 d2                	test   %edx,%edx
  801d99:	0f 49 ca             	cmovns %edx,%ecx
  801d9c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  801d9f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801da3:	c1 e1 0c             	shl    $0xc,%ecx
  801da6:	89 d0                	mov    %edx,%eax
  801da8:	c1 f8 1f             	sar    $0x1f,%eax
  801dab:	c1 e8 14             	shr    $0x14,%eax
  801dae:	01 c2                	add    %eax,%edx
  801db0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801db6:	29 c2                	sub    %eax,%edx
  801db8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801dbf:	89 c8                	mov    %ecx,%eax
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    

00801dc3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801dc6:	8b 48 08             	mov    0x8(%eax),%ecx
  801dc9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801dcc:	8b 00                	mov    (%eax),%eax
  801dce:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801dd1:	c7 82 80 00 00 00 04 	movl   $0x805004,0x80(%edx)
  801dd8:	50 80 00 
}
  801ddb:	5d                   	pop    %ebp
  801ddc:	c3                   	ret    

00801ddd <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801de3:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801de9:	85 c0                	test   %eax,%eax
  801deb:	74 08                	je     801df5 <_ZL9get_inodei+0x18>
  801ded:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801df3:	7e 20                	jle    801e15 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801df5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df9:	c7 44 24 08 a8 48 80 	movl   $0x8048a8,0x8(%esp)
  801e00:	00 
  801e01:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801e08:	00 
  801e09:	c7 04 24 be 48 80 00 	movl   $0x8048be,(%esp)
  801e10:	e8 a7 20 00 00       	call   803ebc <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801e15:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801e1b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801e21:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801e27:	85 d2                	test   %edx,%edx
  801e29:	0f 48 d1             	cmovs  %ecx,%edx
  801e2c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801e2f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801e36:	c1 e0 0c             	shl    $0xc,%eax
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	56                   	push   %esi
  801e3f:	53                   	push   %ebx
  801e40:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801e43:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801e49:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801e4c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801e52:	76 20                	jbe    801e74 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801e54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e58:	c7 44 24 08 e4 48 80 	movl   $0x8048e4,0x8(%esp)
  801e5f:	00 
  801e60:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801e67:	00 
  801e68:	c7 04 24 be 48 80 00 	movl   $0x8048be,(%esp)
  801e6f:	e8 48 20 00 00       	call   803ebc <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801e74:	83 fe 01             	cmp    $0x1,%esi
  801e77:	7e 08                	jle    801e81 <_ZL10bcache_ipcPvi+0x46>
  801e79:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801e7f:	7d 12                	jge    801e93 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801e81:	89 f3                	mov    %esi,%ebx
  801e83:	c1 e3 04             	shl    $0x4,%ebx
  801e86:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801e88:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801e8e:	c1 e6 0c             	shl    $0xc,%esi
  801e91:	eb 20                	jmp    801eb3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801e93:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e97:	c7 44 24 08 14 49 80 	movl   $0x804914,0x8(%esp)
  801e9e:	00 
  801e9f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801ea6:	00 
  801ea7:	c7 04 24 be 48 80 00 	movl   $0x8048be,(%esp)
  801eae:	e8 09 20 00 00       	call   803ebc <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801eb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eba:	00 
  801ebb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ec2:	00 
  801ec3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ec7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801ece:	e8 3c 22 00 00       	call   80410f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801ed3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801eda:	00 
  801edb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801edf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee6:	e8 95 21 00 00       	call   804080 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801eeb:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801eee:	74 c3                	je     801eb3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	5b                   	pop    %ebx
  801ef4:	5e                   	pop    %esi
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    

00801ef7 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 28             	sub    $0x28,%esp
  801efd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f00:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f03:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f06:	89 c7                	mov    %eax,%edi
  801f08:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801f0a:	c7 04 24 9d 21 80 00 	movl   $0x80219d,(%esp)
  801f11:	e8 75 20 00 00       	call   803f8b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801f16:	89 f8                	mov    %edi,%eax
  801f18:	e8 c0 fe ff ff       	call   801ddd <_ZL9get_inodei>
  801f1d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801f1f:	ba 02 00 00 00       	mov    $0x2,%edx
  801f24:	e8 12 ff ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	79 08                	jns    801f35 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801f2d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801f33:	eb 2e                	jmp    801f63 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801f35:	85 c0                	test   %eax,%eax
  801f37:	75 1c                	jne    801f55 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801f39:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801f3f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801f46:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801f49:	ba 06 00 00 00       	mov    $0x6,%edx
  801f4e:	89 d8                	mov    %ebx,%eax
  801f50:	e8 e6 fe ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801f55:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801f5c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f63:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f66:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f6c:	89 ec                	mov    %ebp,%esp
  801f6e:	5d                   	pop    %ebp
  801f6f:	c3                   	ret    

00801f70 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	57                   	push   %edi
  801f74:	56                   	push   %esi
  801f75:	53                   	push   %ebx
  801f76:	83 ec 2c             	sub    $0x2c,%esp
  801f79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801f7c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801f7f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801f84:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801f8a:	0f 87 3d 01 00 00    	ja     8020cd <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801f90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801f93:	8b 42 08             	mov    0x8(%edx),%eax
  801f96:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	0f 49 f0             	cmovns %eax,%esi
  801fa1:	c1 fe 0c             	sar    $0xc,%esi
  801fa4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801fa6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801fa9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801faf:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801fb2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801fb5:	0f 82 a6 00 00 00    	jb     802061 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801fbb:	39 fe                	cmp    %edi,%esi
  801fbd:	0f 8d f2 00 00 00    	jge    8020b5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801fc3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801fc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801fca:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801fcd:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801fd0:	83 3e 00             	cmpl   $0x0,(%esi)
  801fd3:	75 77                	jne    80204c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801fd5:	ba 02 00 00 00       	mov    $0x2,%edx
  801fda:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801fdf:	e8 57 fe ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801fe4:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801fea:	83 f9 02             	cmp    $0x2,%ecx
  801fed:	7e 43                	jle    802032 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801fef:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801ff4:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801ff9:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802000:	74 29                	je     80202b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802002:	e9 ce 00 00 00       	jmp    8020d5 <_ZL14inode_set_sizeP5Inodej+0x165>
  802007:	89 c7                	mov    %eax,%edi
  802009:	0f b6 10             	movzbl (%eax),%edx
  80200c:	83 c0 01             	add    $0x1,%eax
  80200f:	84 d2                	test   %dl,%dl
  802011:	74 18                	je     80202b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802013:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802016:	ba 05 00 00 00       	mov    $0x5,%edx
  80201b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802020:	e8 16 fe ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802025:	85 db                	test   %ebx,%ebx
  802027:	79 1e                	jns    802047 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802029:	eb 07                	jmp    802032 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80202b:	83 c3 01             	add    $0x1,%ebx
  80202e:	39 d9                	cmp    %ebx,%ecx
  802030:	7f d5                	jg     802007 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  802032:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802035:	8b 50 08             	mov    0x8(%eax),%edx
  802038:	e8 33 ff ff ff       	call   801f70 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  80203d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802042:	e9 86 00 00 00       	jmp    8020cd <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  802047:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80204a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  80204c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  802050:	83 c6 04             	add    $0x4,%esi
  802053:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802056:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  802059:	0f 8f 6e ff ff ff    	jg     801fcd <_ZL14inode_set_sizeP5Inodej+0x5d>
  80205f:	eb 54                	jmp    8020b5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  802061:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802064:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  802069:	83 f8 01             	cmp    $0x1,%eax
  80206c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  80206f:	ba 02 00 00 00       	mov    $0x2,%edx
  802074:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802079:	e8 bd fd ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  80207e:	39 f7                	cmp    %esi,%edi
  802080:	7d 24                	jge    8020a6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802082:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802085:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  802089:	8b 10                	mov    (%eax),%edx
  80208b:	85 d2                	test   %edx,%edx
  80208d:	74 0d                	je     80209c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  80208f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  802096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  80209c:	83 eb 01             	sub    $0x1,%ebx
  80209f:	83 e8 04             	sub    $0x4,%eax
  8020a2:	39 fb                	cmp    %edi,%ebx
  8020a4:	75 e3                	jne    802089 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8020a6:	ba 05 00 00 00       	mov    $0x5,%edx
  8020ab:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8020b0:	e8 86 fd ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  8020b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8020b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020bb:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  8020be:	ba 04 00 00 00       	mov    $0x4,%edx
  8020c3:	e8 73 fd ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
	return 0;
  8020c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020cd:	83 c4 2c             	add    $0x2c,%esp
  8020d0:	5b                   	pop    %ebx
  8020d1:	5e                   	pop    %esi
  8020d2:	5f                   	pop    %edi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  8020d5:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8020dc:	ba 05 00 00 00       	mov    $0x5,%edx
  8020e1:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8020e6:	e8 50 fd ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8020eb:	bb 02 00 00 00       	mov    $0x2,%ebx
  8020f0:	e9 52 ff ff ff       	jmp    802047 <_ZL14inode_set_sizeP5Inodej+0xd7>

008020f5 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	53                   	push   %ebx
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  8020fe:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802104:	83 e8 01             	sub    $0x1,%eax
  802107:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  80210d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802111:	75 40                	jne    802153 <_ZL11inode_closeP5Inode+0x5e>
  802113:	85 c0                	test   %eax,%eax
  802115:	75 3c                	jne    802153 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802117:	ba 02 00 00 00       	mov    $0x2,%edx
  80211c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802121:	e8 15 fd ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802126:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  80212b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  80212f:	85 d2                	test   %edx,%edx
  802131:	74 07                	je     80213a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  802133:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  80213a:	83 c0 01             	add    $0x1,%eax
  80213d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  802142:	75 e7                	jne    80212b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802144:	ba 05 00 00 00       	mov    $0x5,%edx
  802149:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80214e:	e8 e8 fc ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  802153:	ba 03 00 00 00       	mov    $0x3,%edx
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	e8 dc fc ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
}
  80215f:	83 c4 04             	add    $0x4,%esp
  802162:	5b                   	pop    %ebx
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    

00802165 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	53                   	push   %ebx
  802169:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8b 40 0c             	mov    0xc(%eax),%eax
  802172:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802175:	e8 7d fd ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  80217a:	89 c3                	mov    %eax,%ebx
  80217c:	85 c0                	test   %eax,%eax
  80217e:	78 15                	js     802195 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  802180:	8b 55 0c             	mov    0xc(%ebp),%edx
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	e8 e5 fd ff ff       	call   801f70 <_ZL14inode_set_sizeP5Inodej>
  80218b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	e8 60 ff ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
	return r;
}
  802195:	89 d8                	mov    %ebx,%eax
  802197:	83 c4 14             	add    $0x14,%esp
  80219a:	5b                   	pop    %ebx
  80219b:	5d                   	pop    %ebp
  80219c:	c3                   	ret    

0080219d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	53                   	push   %ebx
  8021a1:	83 ec 14             	sub    $0x14,%esp
  8021a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  8021a7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  8021a9:	89 c2                	mov    %eax,%edx
  8021ab:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  8021b1:	78 32                	js     8021e5 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  8021b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b8:	e8 7e fc ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	74 1c                	je     8021dd <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  8021c1:	c7 44 24 08 c9 48 80 	movl   $0x8048c9,0x8(%esp)
  8021c8:	00 
  8021c9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8021d0:	00 
  8021d1:	c7 04 24 be 48 80 00 	movl   $0x8048be,(%esp)
  8021d8:	e8 df 1c 00 00       	call   803ebc <_Z6_panicPKciS0_z>
    resume(utf);
  8021dd:	89 1c 24             	mov    %ebx,(%esp)
  8021e0:	e8 7b 1e 00 00       	call   804060 <resume>
}
  8021e5:	83 c4 14             	add    $0x14,%esp
  8021e8:	5b                   	pop    %ebx
  8021e9:	5d                   	pop    %ebp
  8021ea:	c3                   	ret    

008021eb <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 28             	sub    $0x28,%esp
  8021f1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8021f4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8021f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8021fa:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8021fd:	8b 43 0c             	mov    0xc(%ebx),%eax
  802200:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802203:	e8 ef fc ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  802208:	85 c0                	test   %eax,%eax
  80220a:	78 26                	js     802232 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80220c:	83 c3 10             	add    $0x10,%ebx
  80220f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802213:	89 34 24             	mov    %esi,(%esp)
  802216:	e8 2f e6 ff ff       	call   80084a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80221b:	89 f2                	mov    %esi,%edx
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	e8 9e fb ff ff       	call   801dc3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	e8 c8 fe ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
	return 0;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802232:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802235:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802238:	89 ec                	mov    %ebp,%esp
  80223a:	5d                   	pop    %ebp
  80223b:	c3                   	ret    

0080223c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	53                   	push   %ebx
  802240:	83 ec 24             	sub    $0x24,%esp
  802243:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802246:	89 1c 24             	mov    %ebx,(%esp)
  802249:	e8 9e 15 00 00       	call   8037ec <_Z7pagerefPv>
  80224e:	89 c2                	mov    %eax,%edx
        return 0;
  802250:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802255:	83 fa 01             	cmp    $0x1,%edx
  802258:	7f 1e                	jg     802278 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80225a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80225d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802260:	e8 92 fc ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  802265:	85 c0                	test   %eax,%eax
  802267:	78 0f                	js     802278 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802273:	e8 7d fe ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
}
  802278:	83 c4 24             	add    $0x24,%esp
  80227b:	5b                   	pop    %ebx
  80227c:	5d                   	pop    %ebp
  80227d:	c3                   	ret    

0080227e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	57                   	push   %edi
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	83 ec 3c             	sub    $0x3c,%esp
  802287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80228a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  80228d:	8b 43 04             	mov    0x4(%ebx),%eax
  802290:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802293:	8b 43 0c             	mov    0xc(%ebx),%eax
  802296:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802299:	e8 59 fc ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	0f 88 8c 00 00 00    	js     802332 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8022a6:	8b 53 04             	mov    0x4(%ebx),%edx
  8022a9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  8022af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8022b5:	29 d7                	sub    %edx,%edi
  8022b7:	39 f7                	cmp    %esi,%edi
  8022b9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  8022bc:	85 ff                	test   %edi,%edi
  8022be:	74 16                	je     8022d6 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8022c0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  8022c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c6:	3b 50 08             	cmp    0x8(%eax),%edx
  8022c9:	76 6f                	jbe    80233a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  8022cb:	e8 a0 fc ff ff       	call   801f70 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	79 66                	jns    80233a <_ZL13devfile_writeP2FdPKvj+0xbc>
  8022d4:	eb 4e                	jmp    802324 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8022d6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  8022dc:	76 24                	jbe    802302 <_ZL13devfile_writeP2FdPKvj+0x84>
  8022de:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8022e0:	8b 53 04             	mov    0x4(%ebx),%edx
  8022e3:	81 c2 00 10 00 00    	add    $0x1000,%edx
  8022e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ec:	3b 50 08             	cmp    0x8(%eax),%edx
  8022ef:	0f 86 83 00 00 00    	jbe    802378 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  8022f5:	e8 76 fc ff ff       	call   801f70 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	79 7a                	jns    802378 <_ZL13devfile_writeP2FdPKvj+0xfa>
  8022fe:	66 90                	xchg   %ax,%ax
  802300:	eb 22                	jmp    802324 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802302:	85 f6                	test   %esi,%esi
  802304:	74 1e                	je     802324 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802306:	89 f2                	mov    %esi,%edx
  802308:	03 53 04             	add    0x4(%ebx),%edx
  80230b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230e:	3b 50 08             	cmp    0x8(%eax),%edx
  802311:	0f 86 b8 00 00 00    	jbe    8023cf <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802317:	e8 54 fc ff ff       	call   801f70 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80231c:	85 c0                	test   %eax,%eax
  80231e:	0f 89 ab 00 00 00    	jns    8023cf <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802327:	e8 c9 fd ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80232c:	8b 43 04             	mov    0x4(%ebx),%eax
  80232f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  802332:	83 c4 3c             	add    $0x3c,%esp
  802335:	5b                   	pop    %ebx
  802336:	5e                   	pop    %esi
  802337:	5f                   	pop    %edi
  802338:	5d                   	pop    %ebp
  802339:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80233a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80233c:	8b 53 04             	mov    0x4(%ebx),%edx
  80233f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802342:	e8 39 fa ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
  802347:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80234a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80234e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802351:	89 44 24 04          	mov    %eax,0x4(%esp)
  802355:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802358:	89 04 24             	mov    %eax,(%esp)
  80235b:	e8 07 e7 ff ff       	call   800a67 <memcpy>
        fd->fd_offset += n2;
  802360:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802363:	ba 04 00 00 00       	mov    $0x4,%edx
  802368:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80236b:	e8 cb fa ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802370:	01 7d 0c             	add    %edi,0xc(%ebp)
  802373:	e9 5e ff ff ff       	jmp    8022d6 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802378:	8b 53 04             	mov    0x4(%ebx),%edx
  80237b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80237e:	e8 fd f9 ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
  802383:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  802385:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80238c:	00 
  80238d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802390:	89 44 24 04          	mov    %eax,0x4(%esp)
  802394:	89 34 24             	mov    %esi,(%esp)
  802397:	e8 cb e6 ff ff       	call   800a67 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80239c:	ba 04 00 00 00       	mov    $0x4,%edx
  8023a1:	89 f0                	mov    %esi,%eax
  8023a3:	e8 93 fa ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  8023a8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  8023ae:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  8023b5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8023bc:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8023c2:	0f 87 18 ff ff ff    	ja     8022e0 <_ZL13devfile_writeP2FdPKvj+0x62>
  8023c8:	89 fe                	mov    %edi,%esi
  8023ca:	e9 33 ff ff ff       	jmp    802302 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8023cf:	8b 53 04             	mov    0x4(%ebx),%edx
  8023d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d5:	e8 a6 f9 ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
  8023da:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  8023dc:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e7:	89 3c 24             	mov    %edi,(%esp)
  8023ea:	e8 78 e6 ff ff       	call   800a67 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8023ef:	ba 04 00 00 00       	mov    $0x4,%edx
  8023f4:	89 f8                	mov    %edi,%eax
  8023f6:	e8 40 fa ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  8023fb:	01 73 04             	add    %esi,0x4(%ebx)
  8023fe:	e9 21 ff ff ff       	jmp    802324 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802403 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	57                   	push   %edi
  802407:	56                   	push   %esi
  802408:	53                   	push   %ebx
  802409:	83 ec 3c             	sub    $0x3c,%esp
  80240c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80240f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802412:	8b 43 04             	mov    0x4(%ebx),%eax
  802415:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802418:	8b 43 0c             	mov    0xc(%ebx),%eax
  80241b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80241e:	e8 d4 fa ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  802423:	85 c0                	test   %eax,%eax
  802425:	0f 88 d3 00 00 00    	js     8024fe <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80242b:	8b 73 04             	mov    0x4(%ebx),%esi
  80242e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802431:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802434:	8b 50 08             	mov    0x8(%eax),%edx
  802437:	29 f2                	sub    %esi,%edx
  802439:	3b 48 08             	cmp    0x8(%eax),%ecx
  80243c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80243f:	89 f2                	mov    %esi,%edx
  802441:	e8 3a f9 ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
  802446:	85 c0                	test   %eax,%eax
  802448:	0f 84 a2 00 00 00    	je     8024f0 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80244e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80245a:	29 f2                	sub    %esi,%edx
  80245c:	39 d7                	cmp    %edx,%edi
  80245e:	0f 46 d7             	cmovbe %edi,%edx
  802461:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802464:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802466:	01 d6                	add    %edx,%esi
  802468:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80246b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80246f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802473:	8b 45 0c             	mov    0xc(%ebp),%eax
  802476:	89 04 24             	mov    %eax,(%esp)
  802479:	e8 e9 e5 ff ff       	call   800a67 <memcpy>
    buf = (void *)((char *)buf + n2);
  80247e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802481:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802484:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80248a:	76 3e                	jbe    8024ca <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80248c:	8b 53 04             	mov    0x4(%ebx),%edx
  80248f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802492:	e8 e9 f8 ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
  802497:	85 c0                	test   %eax,%eax
  802499:	74 55                	je     8024f0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80249b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8024a2:	00 
  8024a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a7:	89 34 24             	mov    %esi,(%esp)
  8024aa:	e8 b8 e5 ff ff       	call   800a67 <memcpy>
        n -= PGSIZE;
  8024af:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8024b5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8024bb:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  8024c2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8024c8:	77 c2                	ja     80248c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8024ca:	85 ff                	test   %edi,%edi
  8024cc:	74 22                	je     8024f0 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8024ce:	8b 53 04             	mov    0x4(%ebx),%edx
  8024d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d4:	e8 a7 f8 ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	74 13                	je     8024f0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  8024dd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e5:	89 34 24             	mov    %esi,(%esp)
  8024e8:	e8 7a e5 ff ff       	call   800a67 <memcpy>
        fd->fd_offset += n;
  8024ed:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  8024f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f3:	e8 fd fb ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8024f8:	8b 43 04             	mov    0x4(%ebx),%eax
  8024fb:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  8024fe:	83 c4 3c             	add    $0x3c,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5f                   	pop    %edi
  802504:	5d                   	pop    %ebp
  802505:	c3                   	ret    

00802506 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	57                   	push   %edi
  80250a:	56                   	push   %esi
  80250b:	53                   	push   %ebx
  80250c:	83 ec 4c             	sub    $0x4c,%esp
  80250f:	89 c6                	mov    %eax,%esi
  802511:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802514:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802517:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80251d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802526:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802529:	b8 01 00 00 00       	mov    $0x1,%eax
  80252e:	e8 c4 f9 ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  802533:	89 c7                	mov    %eax,%edi
  802535:	85 c0                	test   %eax,%eax
  802537:	0f 88 cd 01 00 00    	js     80270a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80253d:	89 f3                	mov    %esi,%ebx
  80253f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802542:	75 08                	jne    80254c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802544:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802547:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80254a:	74 f8                	je     802544 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80254c:	0f b6 03             	movzbl (%ebx),%eax
  80254f:	3c 2f                	cmp    $0x2f,%al
  802551:	74 16                	je     802569 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802553:	84 c0                	test   %al,%al
  802555:	74 12                	je     802569 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802557:	89 da                	mov    %ebx,%edx
		++path;
  802559:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80255c:	0f b6 02             	movzbl (%edx),%eax
  80255f:	3c 2f                	cmp    $0x2f,%al
  802561:	74 08                	je     80256b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802563:	84 c0                	test   %al,%al
  802565:	75 f2                	jne    802559 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802567:	eb 02                	jmp    80256b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802569:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80256b:	89 d0                	mov    %edx,%eax
  80256d:	29 d8                	sub    %ebx,%eax
  80256f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802572:	0f b6 02             	movzbl (%edx),%eax
  802575:	89 d6                	mov    %edx,%esi
  802577:	3c 2f                	cmp    $0x2f,%al
  802579:	75 0a                	jne    802585 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80257b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80257e:	0f b6 06             	movzbl (%esi),%eax
  802581:	3c 2f                	cmp    $0x2f,%al
  802583:	74 f6                	je     80257b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802585:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802589:	75 1b                	jne    8025a6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80258b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802591:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802593:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802596:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80259c:	bf 00 00 00 00       	mov    $0x0,%edi
  8025a1:	e9 64 01 00 00       	jmp    80270a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8025a6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8025aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025ae:	74 06                	je     8025b6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8025b0:	84 c0                	test   %al,%al
  8025b2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8025b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8025bc:	83 3a 02             	cmpl   $0x2,(%edx)
  8025bf:	0f 85 f4 00 00 00    	jne    8026b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8025c5:	89 d0                	mov    %edx,%eax
  8025c7:	8b 52 08             	mov    0x8(%edx),%edx
  8025ca:	85 d2                	test   %edx,%edx
  8025cc:	7e 78                	jle    802646 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  8025ce:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8025d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025da:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8025dd:	89 fb                	mov    %edi,%ebx
  8025df:	89 75 c0             	mov    %esi,-0x40(%ebp)
  8025e2:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8025e4:	89 da                	mov    %ebx,%edx
  8025e6:	89 f0                	mov    %esi,%eax
  8025e8:	e8 93 f7 ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
  8025ed:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  8025ef:	83 38 00             	cmpl   $0x0,(%eax)
  8025f2:	74 26                	je     80261a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  8025f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8025f7:	3b 50 04             	cmp    0x4(%eax),%edx
  8025fa:	75 33                	jne    80262f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  8025fc:	89 54 24 08          	mov    %edx,0x8(%esp)
  802600:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802603:	89 44 24 04          	mov    %eax,0x4(%esp)
  802607:	8d 47 08             	lea    0x8(%edi),%eax
  80260a:	89 04 24             	mov    %eax,(%esp)
  80260d:	e8 96 e4 ff ff       	call   800aa8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802612:	85 c0                	test   %eax,%eax
  802614:	0f 84 fa 00 00 00    	je     802714 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80261a:	83 3f 00             	cmpl   $0x0,(%edi)
  80261d:	75 10                	jne    80262f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80261f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802623:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802626:	84 c0                	test   %al,%al
  802628:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80262c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80262f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802635:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802637:	8b 56 08             	mov    0x8(%esi),%edx
  80263a:	39 d0                	cmp    %edx,%eax
  80263c:	7c a6                	jl     8025e4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80263e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802641:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802644:	eb 07                	jmp    80264d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802646:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80264d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802651:	74 6d                	je     8026c0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802653:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802657:	75 24                	jne    80267d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802659:	83 ea 80             	sub    $0xffffff80,%edx
  80265c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80265f:	e8 0c f9 ff ff       	call   801f70 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802664:	85 c0                	test   %eax,%eax
  802666:	0f 88 90 00 00 00    	js     8026fc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80266c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80266f:	8b 50 08             	mov    0x8(%eax),%edx
  802672:	83 c2 80             	add    $0xffffff80,%edx
  802675:	e8 06 f7 ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
  80267a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80267d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802684:	00 
  802685:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80268c:	00 
  80268d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802690:	89 14 24             	mov    %edx,(%esp)
  802693:	e8 f9 e2 ff ff       	call   800991 <memset>
	empty->de_namelen = namelen;
  802698:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80269b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80269e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8026a1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026a9:	83 c0 08             	add    $0x8,%eax
  8026ac:	89 04 24             	mov    %eax,(%esp)
  8026af:	e8 b3 e3 ff ff       	call   800a67 <memcpy>
	*de_store = empty;
  8026b4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  8026b7:	eb 5e                	jmp    802717 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  8026b9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  8026be:	eb 42                	jmp    802702 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  8026c0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  8026c5:	eb 3b                	jmp    802702 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  8026c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ca:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8026cd:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  8026cf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026d2:	89 38                	mov    %edi,(%eax)
			return 0;
  8026d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d9:	eb 2f                	jmp    80270a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  8026db:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8026de:	8b 07                	mov    (%edi),%eax
  8026e0:	e8 12 f8 ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	78 17                	js     802700 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  8026e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ec:	e8 04 fa ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  8026f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  8026f7:	e9 41 fe ff ff       	jmp    80253d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  8026fc:	89 c7                	mov    %eax,%edi
  8026fe:	eb 02                	jmp    802702 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802700:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802705:	e8 eb f9 ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
	return r;
}
  80270a:	89 f8                	mov    %edi,%eax
  80270c:	83 c4 4c             	add    $0x4c,%esp
  80270f:	5b                   	pop    %ebx
  802710:	5e                   	pop    %esi
  802711:	5f                   	pop    %edi
  802712:	5d                   	pop    %ebp
  802713:	c3                   	ret    
  802714:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802717:	80 3e 00             	cmpb   $0x0,(%esi)
  80271a:	75 bf                	jne    8026db <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80271c:	eb a9                	jmp    8026c7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080271e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	57                   	push   %edi
  802722:	56                   	push   %esi
  802723:	53                   	push   %ebx
  802724:	83 ec 3c             	sub    $0x3c,%esp
  802727:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80272a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80272d:	89 04 24             	mov    %eax,(%esp)
  802730:	e8 62 f0 ff ff       	call   801797 <_Z14fd_find_unusedPP2Fd>
  802735:	89 c3                	mov    %eax,%ebx
  802737:	85 c0                	test   %eax,%eax
  802739:	0f 88 16 02 00 00    	js     802955 <_Z4openPKci+0x237>
  80273f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802746:	00 
  802747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80274e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802755:	e8 d6 e5 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  80275a:	89 c3                	mov    %eax,%ebx
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
  802761:	85 db                	test   %ebx,%ebx
  802763:	0f 88 ec 01 00 00    	js     802955 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802769:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80276d:	0f 84 ec 01 00 00    	je     80295f <_Z4openPKci+0x241>
  802773:	83 c0 01             	add    $0x1,%eax
  802776:	83 f8 78             	cmp    $0x78,%eax
  802779:	75 ee                	jne    802769 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80277b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802780:	e9 b9 01 00 00       	jmp    80293e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802785:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802788:	81 e7 00 01 00 00    	and    $0x100,%edi
  80278e:	89 3c 24             	mov    %edi,(%esp)
  802791:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802794:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802797:	89 f0                	mov    %esi,%eax
  802799:	e8 68 fd ff ff       	call   802506 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80279e:	89 c3                	mov    %eax,%ebx
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	0f 85 96 01 00 00    	jne    80293e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8027a8:	85 ff                	test   %edi,%edi
  8027aa:	75 41                	jne    8027ed <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8027ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027af:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  8027b4:	75 08                	jne    8027be <_Z4openPKci+0xa0>
            fileino = dirino;
  8027b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8027bc:	eb 14                	jmp    8027d2 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  8027be:	8d 55 d8             	lea    -0x28(%ebp),%edx
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	e8 2f f7 ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  8027c8:	89 c3                	mov    %eax,%ebx
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	0f 88 5d 01 00 00    	js     80292f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  8027d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027d5:	83 38 02             	cmpl   $0x2,(%eax)
  8027d8:	0f 85 d2 00 00 00    	jne    8028b0 <_Z4openPKci+0x192>
  8027de:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  8027e2:	0f 84 c8 00 00 00    	je     8028b0 <_Z4openPKci+0x192>
  8027e8:	e9 38 01 00 00       	jmp    802925 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  8027ed:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8027f4:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  8027fb:	0f 8e a8 00 00 00    	jle    8028a9 <_Z4openPKci+0x18b>
  802801:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802806:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802809:	89 f8                	mov    %edi,%eax
  80280b:	e8 e7 f6 ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  802810:	89 c3                	mov    %eax,%ebx
  802812:	85 c0                	test   %eax,%eax
  802814:	0f 88 15 01 00 00    	js     80292f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80281a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80281d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802821:	75 68                	jne    80288b <_Z4openPKci+0x16d>
  802823:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80282a:	75 5f                	jne    80288b <_Z4openPKci+0x16d>
			*ino_store = ino;
  80282c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80282f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802835:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802838:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80283f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802846:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80284d:	00 
  80284e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802855:	00 
  802856:	83 c0 0c             	add    $0xc,%eax
  802859:	89 04 24             	mov    %eax,(%esp)
  80285c:	e8 30 e1 ff ff       	call   800991 <memset>
        de->de_inum = fileino->i_inum;
  802861:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802864:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80286a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80286d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80286f:	ba 04 00 00 00       	mov    $0x4,%edx
  802874:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802877:	e8 bf f5 ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80287c:	ba 04 00 00 00       	mov    $0x4,%edx
  802881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802884:	e8 b2 f5 ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
  802889:	eb 25                	jmp    8028b0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  80288b:	e8 65 f8 ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802890:	83 c7 01             	add    $0x1,%edi
  802893:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802899:	0f 8c 67 ff ff ff    	jl     802806 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  80289f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8028a4:	e9 86 00 00 00       	jmp    80292f <_Z4openPKci+0x211>
  8028a9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8028ae:	eb 7f                	jmp    80292f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  8028b0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  8028b7:	74 0d                	je     8028c6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  8028b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8028be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028c1:	e8 aa f6 ff ff       	call   801f70 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  8028c6:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8028cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028cf:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  8028d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  8028db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028de:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  8028e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028e4:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  8028ea:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  8028ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028f1:	83 c0 10             	add    $0x10,%eax
  8028f4:	89 04 24             	mov    %eax,(%esp)
  8028f7:	e8 4e df ff ff       	call   80084a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  8028fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028ff:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802906:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802909:	e8 e7 f7 ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80290e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802911:	e8 df f7 ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802919:	89 04 24             	mov    %eax,(%esp)
  80291c:	e8 13 ee ff ff       	call   801734 <_Z6fd2numP2Fd>
  802921:	89 c3                	mov    %eax,%ebx
  802923:	eb 30                	jmp    802955 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802925:	e8 cb f7 ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80292a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80292f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802932:	e8 be f7 ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
  802937:	eb 05                	jmp    80293e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802939:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80293e:	a1 00 60 80 00       	mov    0x806000,%eax
  802943:	8b 40 04             	mov    0x4(%eax),%eax
  802946:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802949:	89 54 24 04          	mov    %edx,0x4(%esp)
  80294d:	89 04 24             	mov    %eax,(%esp)
  802950:	e8 98 e4 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802955:	89 d8                	mov    %ebx,%eax
  802957:	83 c4 3c             	add    $0x3c,%esp
  80295a:	5b                   	pop    %ebx
  80295b:	5e                   	pop    %esi
  80295c:	5f                   	pop    %edi
  80295d:	5d                   	pop    %ebp
  80295e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80295f:	83 f8 78             	cmp    $0x78,%eax
  802962:	0f 85 1d fe ff ff    	jne    802785 <_Z4openPKci+0x67>
  802968:	eb cf                	jmp    802939 <_Z4openPKci+0x21b>

0080296a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	53                   	push   %ebx
  80296e:	83 ec 24             	sub    $0x24,%esp
  802971:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802974:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	e8 78 f5 ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  80297f:	85 c0                	test   %eax,%eax
  802981:	78 27                	js     8029aa <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802983:	c7 44 24 04 dc 48 80 	movl   $0x8048dc,0x4(%esp)
  80298a:	00 
  80298b:	89 1c 24             	mov    %ebx,(%esp)
  80298e:	e8 b7 de ff ff       	call   80084a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802993:	89 da                	mov    %ebx,%edx
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	e8 26 f4 ff ff       	call   801dc3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	e8 50 f7 ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
	return 0;
  8029a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029aa:	83 c4 24             	add    $0x24,%esp
  8029ad:	5b                   	pop    %ebx
  8029ae:	5d                   	pop    %ebp
  8029af:	c3                   	ret    

008029b0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
  8029b3:	53                   	push   %ebx
  8029b4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  8029b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029be:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  8029c1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	e8 3a fb ff ff       	call   802506 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8029cc:	89 c3                	mov    %eax,%ebx
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	78 5f                	js     802a31 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  8029d2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8029d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d8:	8b 00                	mov    (%eax),%eax
  8029da:	e8 18 f5 ff ff       	call   801ef7 <_ZL10inode_openiPP5Inode>
  8029df:	89 c3                	mov    %eax,%ebx
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	78 44                	js     802a29 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  8029e5:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  8029ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ed:	83 38 02             	cmpl   $0x2,(%eax)
  8029f0:	74 2f                	je     802a21 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  8029f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  8029fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fe:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802a02:	ba 04 00 00 00       	mov    $0x4,%edx
  802a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0a:	e8 2c f4 ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  802a0f:	ba 04 00 00 00       	mov    $0x4,%edx
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	e8 1f f4 ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
	r = 0;
  802a1c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a24:	e8 cc f6 ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	e8 c4 f6 ff ff       	call   8020f5 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802a31:	89 d8                	mov    %ebx,%eax
  802a33:	83 c4 24             	add    $0x24,%esp
  802a36:	5b                   	pop    %ebx
  802a37:	5d                   	pop    %ebp
  802a38:	c3                   	ret    

00802a39 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  802a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a41:	5d                   	pop    %ebp
  802a42:	c3                   	ret    

00802a43 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
  802a46:	57                   	push   %edi
  802a47:	56                   	push   %esi
  802a48:	53                   	push   %ebx
  802a49:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  802a4f:	c7 04 24 9d 21 80 00 	movl   $0x80219d,(%esp)
  802a56:	e8 30 15 00 00       	call   803f8b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802a5b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802a60:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802a65:	74 28                	je     802a8f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802a67:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802a6e:	4a 
  802a6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a73:	c7 44 24 08 44 49 80 	movl   $0x804944,0x8(%esp)
  802a7a:	00 
  802a7b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802a82:	00 
  802a83:	c7 04 24 be 48 80 00 	movl   $0x8048be,(%esp)
  802a8a:	e8 2d 14 00 00       	call   803ebc <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802a8f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802a94:	83 f8 03             	cmp    $0x3,%eax
  802a97:	7f 1c                	jg     802ab5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802a99:	c7 44 24 08 78 49 80 	movl   $0x804978,0x8(%esp)
  802aa0:	00 
  802aa1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802aa8:	00 
  802aa9:	c7 04 24 be 48 80 00 	movl   $0x8048be,(%esp)
  802ab0:	e8 07 14 00 00       	call   803ebc <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802ab5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802abb:	85 d2                	test   %edx,%edx
  802abd:	7f 1c                	jg     802adb <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802abf:	c7 44 24 08 a8 49 80 	movl   $0x8049a8,0x8(%esp)
  802ac6:	00 
  802ac7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802ace:	00 
  802acf:	c7 04 24 be 48 80 00 	movl   $0x8048be,(%esp)
  802ad6:	e8 e1 13 00 00       	call   803ebc <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802adb:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802ae1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802ae7:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802aed:	85 c9                	test   %ecx,%ecx
  802aef:	0f 48 cb             	cmovs  %ebx,%ecx
  802af2:	c1 f9 0c             	sar    $0xc,%ecx
  802af5:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802af9:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802aff:	39 c8                	cmp    %ecx,%eax
  802b01:	7c 13                	jl     802b16 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802b03:	85 c0                	test   %eax,%eax
  802b05:	7f 3d                	jg     802b44 <_Z4fsckv+0x101>
  802b07:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802b0e:	00 00 00 
  802b11:	e9 ac 00 00 00       	jmp    802bc2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802b16:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802b1c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802b20:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b24:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802b28:	c7 44 24 08 d8 49 80 	movl   $0x8049d8,0x8(%esp)
  802b2f:	00 
  802b30:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802b37:	00 
  802b38:	c7 04 24 be 48 80 00 	movl   $0x8048be,(%esp)
  802b3f:	e8 78 13 00 00       	call   803ebc <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802b44:	be 00 20 00 50       	mov    $0x50002000,%esi
  802b49:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802b50:	00 00 00 
  802b53:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b58:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802b5e:	39 df                	cmp    %ebx,%edi
  802b60:	7e 27                	jle    802b89 <_Z4fsckv+0x146>
  802b62:	0f b6 06             	movzbl (%esi),%eax
  802b65:	84 c0                	test   %al,%al
  802b67:	74 4b                	je     802bb4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802b69:	0f be c0             	movsbl %al,%eax
  802b6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b74:	c7 04 24 1c 4a 80 00 	movl   $0x804a1c,(%esp)
  802b7b:	e8 b6 d6 ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  802b80:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802b87:	eb 2b                	jmp    802bb4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802b89:	0f b6 06             	movzbl (%esi),%eax
  802b8c:	3c 01                	cmp    $0x1,%al
  802b8e:	76 24                	jbe    802bb4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802b90:	0f be c0             	movsbl %al,%eax
  802b93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b97:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b9b:	c7 04 24 50 4a 80 00 	movl   $0x804a50,(%esp)
  802ba2:	e8 8f d6 ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  802ba7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802bae:	80 3e 00             	cmpb   $0x0,(%esi)
  802bb1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802bb4:	83 c3 01             	add    $0x1,%ebx
  802bb7:	83 c6 01             	add    $0x1,%esi
  802bba:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802bc0:	7f 9c                	jg     802b5e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802bc2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802bc9:	0f 8e e1 02 00 00    	jle    802eb0 <_Z4fsckv+0x46d>
  802bcf:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802bd6:	00 00 00 
		struct Inode *ino = get_inode(i);
  802bd9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802bdf:	e8 f9 f1 ff ff       	call   801ddd <_ZL9get_inodei>
  802be4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  802bea:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  802bee:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802bf5:	75 22                	jne    802c19 <_Z4fsckv+0x1d6>
  802bf7:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  802bfe:	0f 84 a9 06 00 00    	je     8032ad <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802c04:	ba 00 00 00 00       	mov    $0x0,%edx
  802c09:	e8 2d f2 ff ff       	call   801e3b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	74 3a                	je     802c4c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802c12:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802c19:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c1f:	8b 02                	mov    (%edx),%eax
  802c21:	83 f8 01             	cmp    $0x1,%eax
  802c24:	74 26                	je     802c4c <_Z4fsckv+0x209>
  802c26:	83 f8 02             	cmp    $0x2,%eax
  802c29:	74 21                	je     802c4c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  802c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c2f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802c35:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c39:	c7 04 24 7c 4a 80 00 	movl   $0x804a7c,(%esp)
  802c40:	e8 f1 d5 ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  802c45:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  802c4c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802c53:	75 3f                	jne    802c94 <_Z4fsckv+0x251>
  802c55:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802c5b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802c5f:	75 15                	jne    802c76 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802c61:	c7 04 24 a0 4a 80 00 	movl   $0x804aa0,(%esp)
  802c68:	e8 c9 d5 ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  802c6d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c74:	eb 1e                	jmp    802c94 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802c76:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c7c:	83 3a 02             	cmpl   $0x2,(%edx)
  802c7f:	74 13                	je     802c94 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802c81:	c7 04 24 d4 4a 80 00 	movl   $0x804ad4,(%esp)
  802c88:	e8 a9 d5 ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  802c8d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802c94:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802c99:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ca0:	0f 84 93 00 00 00    	je     802d39 <_Z4fsckv+0x2f6>
  802ca6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  802cac:	8b 41 08             	mov    0x8(%ecx),%eax
  802caf:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802cb4:	7e 23                	jle    802cd9 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802cb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cba:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cc4:	c7 04 24 04 4b 80 00 	movl   $0x804b04,(%esp)
  802ccb:	e8 66 d5 ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  802cd0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802cd7:	eb 09                	jmp    802ce2 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802cd9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ce0:	74 4b                	je     802d2d <_Z4fsckv+0x2ea>
  802ce2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802ce8:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  802cee:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802cf4:	74 23                	je     802d19 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802cf6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cfa:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802d00:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d04:	c7 04 24 28 4b 80 00 	movl   $0x804b28,(%esp)
  802d0b:	e8 26 d5 ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  802d10:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d17:	eb 09                	jmp    802d22 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802d19:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802d20:	74 12                	je     802d34 <_Z4fsckv+0x2f1>
  802d22:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802d28:	8b 78 08             	mov    0x8(%eax),%edi
  802d2b:	eb 0c                	jmp    802d39 <_Z4fsckv+0x2f6>
  802d2d:	bf 00 00 00 00       	mov    $0x0,%edi
  802d32:	eb 05                	jmp    802d39 <_Z4fsckv+0x2f6>
  802d34:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802d39:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  802d3e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d44:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802d48:	89 d8                	mov    %ebx,%eax
  802d4a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802d4d:	39 c7                	cmp    %eax,%edi
  802d4f:	7e 2b                	jle    802d7c <_Z4fsckv+0x339>
  802d51:	85 f6                	test   %esi,%esi
  802d53:	75 27                	jne    802d7c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802d55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d5d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802d63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d67:	c7 04 24 4c 4b 80 00 	movl   $0x804b4c,(%esp)
  802d6e:	e8 c3 d4 ff ff       	call   800236 <_Z7cprintfPKcz>
				++errors;
  802d73:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d7a:	eb 36                	jmp    802db2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  802d7c:	39 f8                	cmp    %edi,%eax
  802d7e:	7c 32                	jl     802db2 <_Z4fsckv+0x36f>
  802d80:	85 f6                	test   %esi,%esi
  802d82:	74 2e                	je     802db2 <_Z4fsckv+0x36f>
  802d84:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802d8b:	74 25                	je     802db2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  802d8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d95:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d9f:	c7 04 24 90 4b 80 00 	movl   $0x804b90,(%esp)
  802da6:	e8 8b d4 ff ff       	call   800236 <_Z7cprintfPKcz>
				++errors;
  802dab:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802db2:	85 f6                	test   %esi,%esi
  802db4:	0f 84 a0 00 00 00    	je     802e5a <_Z4fsckv+0x417>
  802dba:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802dc1:	0f 84 93 00 00 00    	je     802e5a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802dc7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802dcd:	7e 27                	jle    802df6 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802dcf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802dd3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802dd7:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802ddd:	89 54 24 04          	mov    %edx,0x4(%esp)
  802de1:	c7 04 24 d4 4b 80 00 	movl   $0x804bd4,(%esp)
  802de8:	e8 49 d4 ff ff       	call   800236 <_Z7cprintfPKcz>
					++errors;
  802ded:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802df4:	eb 64                	jmp    802e5a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802df6:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802dfd:	3c 01                	cmp    $0x1,%al
  802dff:	75 27                	jne    802e28 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802e01:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802e05:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e09:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802e0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e13:	c7 04 24 18 4c 80 00 	movl   $0x804c18,(%esp)
  802e1a:	e8 17 d4 ff ff       	call   800236 <_Z7cprintfPKcz>
					++errors;
  802e1f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802e26:	eb 32                	jmp    802e5a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802e28:	3c ff                	cmp    $0xff,%al
  802e2a:	75 27                	jne    802e53 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802e2c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802e30:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e34:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e3e:	c7 04 24 54 4c 80 00 	movl   $0x804c54,(%esp)
  802e45:	e8 ec d3 ff ff       	call   800236 <_Z7cprintfPKcz>
					++errors;
  802e4a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802e51:	eb 07                	jmp    802e5a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802e53:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802e5a:	83 c3 01             	add    $0x1,%ebx
  802e5d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802e63:	0f 85 d5 fe ff ff    	jne    802d3e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802e69:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802e70:	0f 94 c0             	sete   %al
  802e73:	0f b6 c0             	movzbl %al,%eax
  802e76:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e7c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802e82:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802e89:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802e90:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802e97:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802e9e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802ea4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802eaa:	0f 8f 29 fd ff ff    	jg     802bd9 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802eb0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802eb7:	0f 8e 7f 03 00 00    	jle    80323c <_Z4fsckv+0x7f9>
  802ebd:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802ec2:	89 f0                	mov    %esi,%eax
  802ec4:	e8 14 ef ff ff       	call   801ddd <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802ec9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802ed0:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802ed7:	c1 e2 08             	shl    $0x8,%edx
  802eda:	09 ca                	or     %ecx,%edx
  802edc:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802ee3:	c1 e1 10             	shl    $0x10,%ecx
  802ee6:	09 ca                	or     %ecx,%edx
  802ee8:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802eef:	83 e1 7f             	and    $0x7f,%ecx
  802ef2:	c1 e1 18             	shl    $0x18,%ecx
  802ef5:	09 d1                	or     %edx,%ecx
  802ef7:	74 0e                	je     802f07 <_Z4fsckv+0x4c4>
  802ef9:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802f00:	78 05                	js     802f07 <_Z4fsckv+0x4c4>
  802f02:	83 38 02             	cmpl   $0x2,(%eax)
  802f05:	74 1f                	je     802f26 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802f07:	83 c6 01             	add    $0x1,%esi
  802f0a:	a1 08 10 00 50       	mov    0x50001008,%eax
  802f0f:	39 f0                	cmp    %esi,%eax
  802f11:	7f af                	jg     802ec2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802f13:	bb 01 00 00 00       	mov    $0x1,%ebx
  802f18:	83 f8 01             	cmp    $0x1,%eax
  802f1b:	0f 8f ad 02 00 00    	jg     8031ce <_Z4fsckv+0x78b>
  802f21:	e9 16 03 00 00       	jmp    80323c <_Z4fsckv+0x7f9>
  802f26:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802f28:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802f2f:	8b 40 08             	mov    0x8(%eax),%eax
  802f32:	a8 7f                	test   $0x7f,%al
  802f34:	74 23                	je     802f59 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802f36:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802f3d:	00 
  802f3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f42:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f46:	c7 04 24 90 4c 80 00 	movl   $0x804c90,(%esp)
  802f4d:	e8 e4 d2 ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  802f52:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802f59:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802f60:	00 00 00 
  802f63:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802f69:	e9 3d 02 00 00       	jmp    8031ab <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802f6e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f74:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802f7a:	e8 01 ee ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
  802f7f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802f81:	83 38 00             	cmpl   $0x0,(%eax)
  802f84:	0f 84 15 02 00 00    	je     80319f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802f90:	83 fa 76             	cmp    $0x76,%edx
  802f93:	76 27                	jbe    802fbc <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802f95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f99:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802f9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802fa3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802fa7:	c7 04 24 c4 4c 80 00 	movl   $0x804cc4,(%esp)
  802fae:	e8 83 d2 ff ff       	call   800236 <_Z7cprintfPKcz>
				++errors;
  802fb3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802fba:	eb 28                	jmp    802fe4 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802fbc:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802fc1:	74 21                	je     802fe4 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802fc3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802fc9:	89 54 24 08          	mov    %edx,0x8(%esp)
  802fcd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802fd1:	c7 04 24 f0 4c 80 00 	movl   $0x804cf0,(%esp)
  802fd8:	e8 59 d2 ff ff       	call   800236 <_Z7cprintfPKcz>
				++errors;
  802fdd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802fe4:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802feb:	00 
  802fec:	8d 43 08             	lea    0x8(%ebx),%eax
  802fef:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ff3:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802ff9:	89 0c 24             	mov    %ecx,(%esp)
  802ffc:	e8 66 da ff ff       	call   800a67 <memcpy>
  803001:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803005:	bf 77 00 00 00       	mov    $0x77,%edi
  80300a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80300e:	85 ff                	test   %edi,%edi
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
  803015:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803018:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80301f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803020:	8b 03                	mov    (%ebx),%eax
  803022:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803028:	7c 3e                	jl     803068 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80302a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80302e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803034:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803038:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80303e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803042:	89 74 24 04          	mov    %esi,0x4(%esp)
  803046:	c7 04 24 24 4d 80 00 	movl   $0x804d24,(%esp)
  80304d:	e8 e4 d1 ff ff       	call   800236 <_Z7cprintfPKcz>
				++errors;
  803052:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803059:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  803060:	00 00 00 
  803063:	e9 0b 01 00 00       	jmp    803173 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  803068:	e8 70 ed ff ff       	call   801ddd <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  80306d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803074:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  80307b:	c1 e2 08             	shl    $0x8,%edx
  80307e:	09 d1                	or     %edx,%ecx
  803080:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  803087:	c1 e2 10             	shl    $0x10,%edx
  80308a:	09 d1                	or     %edx,%ecx
  80308c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803093:	83 e2 7f             	and    $0x7f,%edx
  803096:	c1 e2 18             	shl    $0x18,%edx
  803099:	09 ca                	or     %ecx,%edx
  80309b:	83 c2 01             	add    $0x1,%edx
  80309e:	89 d1                	mov    %edx,%ecx
  8030a0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  8030a6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  8030ac:	0f b6 d5             	movzbl %ch,%edx
  8030af:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  8030b5:	89 ca                	mov    %ecx,%edx
  8030b7:	c1 ea 10             	shr    $0x10,%edx
  8030ba:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  8030c0:	c1 e9 18             	shr    $0x18,%ecx
  8030c3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  8030ca:	83 e2 80             	and    $0xffffff80,%edx
  8030cd:	09 ca                	or     %ecx,%edx
  8030cf:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  8030d5:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8030d9:	0f 85 7a ff ff ff    	jne    803059 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  8030df:	8b 03                	mov    (%ebx),%eax
  8030e1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8030e5:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  8030eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030ef:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8030f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030fd:	c7 04 24 54 4d 80 00 	movl   $0x804d54,(%esp)
  803104:	e8 2d d1 ff ff       	call   800236 <_Z7cprintfPKcz>
					++errors;
  803109:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803110:	e9 44 ff ff ff       	jmp    803059 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803115:	3b 78 04             	cmp    0x4(%eax),%edi
  803118:	75 52                	jne    80316c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  80311a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80311e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803124:	89 54 24 04          	mov    %edx,0x4(%esp)
  803128:	83 c0 08             	add    $0x8,%eax
  80312b:	89 04 24             	mov    %eax,(%esp)
  80312e:	e8 75 d9 ff ff       	call   800aa8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803133:	85 c0                	test   %eax,%eax
  803135:	75 35                	jne    80316c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  803137:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80313d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803141:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803147:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80314b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803151:	89 54 24 08          	mov    %edx,0x8(%esp)
  803155:	89 74 24 04          	mov    %esi,0x4(%esp)
  803159:	c7 04 24 84 4d 80 00 	movl   $0x804d84,(%esp)
  803160:	e8 d1 d0 ff ff       	call   800236 <_Z7cprintfPKcz>
					++errors;
  803165:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80316c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  803173:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803179:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  80317f:	7e 1e                	jle    80319f <_Z4fsckv+0x75c>
  803181:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803185:	7f 18                	jg     80319f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  803187:	89 ca                	mov    %ecx,%edx
  803189:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80318f:	e8 ec eb ff ff       	call   801d80 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  803194:	83 38 00             	cmpl   $0x0,(%eax)
  803197:	0f 85 78 ff ff ff    	jne    803115 <_Z4fsckv+0x6d2>
  80319d:	eb cd                	jmp    80316c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80319f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8031a5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8031ab:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8031b1:	83 ea 80             	sub    $0xffffff80,%edx
  8031b4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  8031ba:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8031c0:	3b 51 08             	cmp    0x8(%ecx),%edx
  8031c3:	0f 8f e7 fc ff ff    	jg     802eb0 <_Z4fsckv+0x46d>
  8031c9:	e9 a0 fd ff ff       	jmp    802f6e <_Z4fsckv+0x52b>
  8031ce:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  8031d4:	89 d8                	mov    %ebx,%eax
  8031d6:	e8 02 ec ff ff       	call   801ddd <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  8031db:	8b 50 04             	mov    0x4(%eax),%edx
  8031de:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8031e5:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  8031ec:	c1 e7 08             	shl    $0x8,%edi
  8031ef:	09 f9                	or     %edi,%ecx
  8031f1:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  8031f8:	c1 e7 10             	shl    $0x10,%edi
  8031fb:	09 f9                	or     %edi,%ecx
  8031fd:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803204:	83 e7 7f             	and    $0x7f,%edi
  803207:	c1 e7 18             	shl    $0x18,%edi
  80320a:	09 f9                	or     %edi,%ecx
  80320c:	39 ca                	cmp    %ecx,%edx
  80320e:	74 1b                	je     80322b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803210:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803214:	89 54 24 08          	mov    %edx,0x8(%esp)
  803218:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80321c:	c7 04 24 b4 4d 80 00 	movl   $0x804db4,(%esp)
  803223:	e8 0e d0 ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  803228:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80322b:	83 c3 01             	add    $0x1,%ebx
  80322e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  803234:	7f 9e                	jg     8031d4 <_Z4fsckv+0x791>
  803236:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  80323c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  803243:	7e 4f                	jle    803294 <_Z4fsckv+0x851>
  803245:	bb 00 00 00 00       	mov    $0x0,%ebx
  80324a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  803250:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  803257:	3c ff                	cmp    $0xff,%al
  803259:	75 09                	jne    803264 <_Z4fsckv+0x821>
			freemap[i] = 0;
  80325b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803262:	eb 1f                	jmp    803283 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803264:	84 c0                	test   %al,%al
  803266:	75 1b                	jne    803283 <_Z4fsckv+0x840>
  803268:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80326e:	7c 13                	jl     803283 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803270:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803274:	c7 04 24 e0 4d 80 00 	movl   $0x804de0,(%esp)
  80327b:	e8 b6 cf ff ff       	call   800236 <_Z7cprintfPKcz>
			++errors;
  803280:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803283:	83 c3 01             	add    $0x1,%ebx
  803286:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  80328c:	7f c2                	jg     803250 <_Z4fsckv+0x80d>
  80328e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803294:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80329b:	19 c0                	sbb    %eax,%eax
  80329d:	f7 d0                	not    %eax
  80329f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  8032a2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  8032a8:	5b                   	pop    %ebx
  8032a9:	5e                   	pop    %esi
  8032aa:	5f                   	pop    %edi
  8032ab:	5d                   	pop    %ebp
  8032ac:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  8032ad:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8032b4:	0f 84 92 f9 ff ff    	je     802c4c <_Z4fsckv+0x209>
  8032ba:	e9 5a f9 ff ff       	jmp    802c19 <_Z4fsckv+0x1d6>
	...

008032c0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8032c0:	55                   	push   %ebp
  8032c1:	89 e5                	mov    %esp,%ebp
  8032c3:	83 ec 18             	sub    $0x18,%esp
  8032c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8032c9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8032cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	89 04 24             	mov    %eax,(%esp)
  8032d5:	e8 a2 e4 ff ff       	call   80177c <_Z7fd2dataP2Fd>
  8032da:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8032dc:	c7 44 24 04 13 4e 80 	movl   $0x804e13,0x4(%esp)
  8032e3:	00 
  8032e4:	89 34 24             	mov    %esi,(%esp)
  8032e7:	e8 5e d5 ff ff       	call   80084a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  8032ec:	8b 43 04             	mov    0x4(%ebx),%eax
  8032ef:	2b 03                	sub    (%ebx),%eax
  8032f1:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  8032f4:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  8032fb:	c7 86 80 00 00 00 20 	movl   $0x805020,0x80(%esi)
  803302:	50 80 00 
	return 0;
}
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
  80330a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80330d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803310:	89 ec                	mov    %ebp,%esp
  803312:	5d                   	pop    %ebp
  803313:	c3                   	ret    

00803314 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803314:	55                   	push   %ebp
  803315:	89 e5                	mov    %esp,%ebp
  803317:	53                   	push   %ebx
  803318:	83 ec 14             	sub    $0x14,%esp
  80331b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80331e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803322:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803329:	e8 bf da ff ff       	call   800ded <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80332e:	89 1c 24             	mov    %ebx,(%esp)
  803331:	e8 46 e4 ff ff       	call   80177c <_Z7fd2dataP2Fd>
  803336:	89 44 24 04          	mov    %eax,0x4(%esp)
  80333a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803341:	e8 a7 da ff ff       	call   800ded <_Z14sys_page_unmapiPv>
}
  803346:	83 c4 14             	add    $0x14,%esp
  803349:	5b                   	pop    %ebx
  80334a:	5d                   	pop    %ebp
  80334b:	c3                   	ret    

0080334c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80334c:	55                   	push   %ebp
  80334d:	89 e5                	mov    %esp,%ebp
  80334f:	57                   	push   %edi
  803350:	56                   	push   %esi
  803351:	53                   	push   %ebx
  803352:	83 ec 2c             	sub    $0x2c,%esp
  803355:	89 c7                	mov    %eax,%edi
  803357:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80335a:	a1 00 60 80 00       	mov    0x806000,%eax
  80335f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803362:	89 3c 24             	mov    %edi,(%esp)
  803365:	e8 82 04 00 00       	call   8037ec <_Z7pagerefPv>
  80336a:	89 c3                	mov    %eax,%ebx
  80336c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336f:	89 04 24             	mov    %eax,(%esp)
  803372:	e8 75 04 00 00       	call   8037ec <_Z7pagerefPv>
  803377:	39 c3                	cmp    %eax,%ebx
  803379:	0f 94 c0             	sete   %al
  80337c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80337f:	8b 15 00 60 80 00    	mov    0x806000,%edx
  803385:	8b 52 58             	mov    0x58(%edx),%edx
  803388:	39 d6                	cmp    %edx,%esi
  80338a:	75 08                	jne    803394 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  80338c:	83 c4 2c             	add    $0x2c,%esp
  80338f:	5b                   	pop    %ebx
  803390:	5e                   	pop    %esi
  803391:	5f                   	pop    %edi
  803392:	5d                   	pop    %ebp
  803393:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803394:	85 c0                	test   %eax,%eax
  803396:	74 c2                	je     80335a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803398:	c7 04 24 1a 4e 80 00 	movl   $0x804e1a,(%esp)
  80339f:	e8 92 ce ff ff       	call   800236 <_Z7cprintfPKcz>
  8033a4:	eb b4                	jmp    80335a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

008033a6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8033a6:	55                   	push   %ebp
  8033a7:	89 e5                	mov    %esp,%ebp
  8033a9:	57                   	push   %edi
  8033aa:	56                   	push   %esi
  8033ab:	53                   	push   %ebx
  8033ac:	83 ec 1c             	sub    $0x1c,%esp
  8033af:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8033b2:	89 34 24             	mov    %esi,(%esp)
  8033b5:	e8 c2 e3 ff ff       	call   80177c <_Z7fd2dataP2Fd>
  8033ba:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8033bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8033c5:	75 46                	jne    80340d <_ZL13devpipe_writeP2FdPKvj+0x67>
  8033c7:	eb 52                	jmp    80341b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  8033c9:	89 da                	mov    %ebx,%edx
  8033cb:	89 f0                	mov    %esi,%eax
  8033cd:	e8 7a ff ff ff       	call   80334c <_ZL13_pipeisclosedP2FdP4Pipe>
  8033d2:	85 c0                	test   %eax,%eax
  8033d4:	75 49                	jne    80341f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  8033d6:	e8 21 d9 ff ff       	call   800cfc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8033db:	8b 43 04             	mov    0x4(%ebx),%eax
  8033de:	89 c2                	mov    %eax,%edx
  8033e0:	2b 13                	sub    (%ebx),%edx
  8033e2:	83 fa 20             	cmp    $0x20,%edx
  8033e5:	74 e2                	je     8033c9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8033e7:	89 c2                	mov    %eax,%edx
  8033e9:	c1 fa 1f             	sar    $0x1f,%edx
  8033ec:	c1 ea 1b             	shr    $0x1b,%edx
  8033ef:	01 d0                	add    %edx,%eax
  8033f1:	83 e0 1f             	and    $0x1f,%eax
  8033f4:	29 d0                	sub    %edx,%eax
  8033f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8033f9:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  8033fd:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803401:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803405:	83 c7 01             	add    $0x1,%edi
  803408:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80340b:	76 0e                	jbe    80341b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80340d:	8b 43 04             	mov    0x4(%ebx),%eax
  803410:	89 c2                	mov    %eax,%edx
  803412:	2b 13                	sub    (%ebx),%edx
  803414:	83 fa 20             	cmp    $0x20,%edx
  803417:	74 b0                	je     8033c9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803419:	eb cc                	jmp    8033e7 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80341b:	89 f8                	mov    %edi,%eax
  80341d:	eb 05                	jmp    803424 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80341f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803424:	83 c4 1c             	add    $0x1c,%esp
  803427:	5b                   	pop    %ebx
  803428:	5e                   	pop    %esi
  803429:	5f                   	pop    %edi
  80342a:	5d                   	pop    %ebp
  80342b:	c3                   	ret    

0080342c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80342c:	55                   	push   %ebp
  80342d:	89 e5                	mov    %esp,%ebp
  80342f:	83 ec 28             	sub    $0x28,%esp
  803432:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803435:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803438:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80343b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80343e:	89 3c 24             	mov    %edi,(%esp)
  803441:	e8 36 e3 ff ff       	call   80177c <_Z7fd2dataP2Fd>
  803446:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803448:	be 00 00 00 00       	mov    $0x0,%esi
  80344d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803451:	75 47                	jne    80349a <_ZL12devpipe_readP2FdPvj+0x6e>
  803453:	eb 52                	jmp    8034a7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803455:	89 f0                	mov    %esi,%eax
  803457:	eb 5e                	jmp    8034b7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803459:	89 da                	mov    %ebx,%edx
  80345b:	89 f8                	mov    %edi,%eax
  80345d:	8d 76 00             	lea    0x0(%esi),%esi
  803460:	e8 e7 fe ff ff       	call   80334c <_ZL13_pipeisclosedP2FdP4Pipe>
  803465:	85 c0                	test   %eax,%eax
  803467:	75 49                	jne    8034b2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803469:	e8 8e d8 ff ff       	call   800cfc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80346e:	8b 03                	mov    (%ebx),%eax
  803470:	3b 43 04             	cmp    0x4(%ebx),%eax
  803473:	74 e4                	je     803459 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803475:	89 c2                	mov    %eax,%edx
  803477:	c1 fa 1f             	sar    $0x1f,%edx
  80347a:	c1 ea 1b             	shr    $0x1b,%edx
  80347d:	01 d0                	add    %edx,%eax
  80347f:	83 e0 1f             	and    $0x1f,%eax
  803482:	29 d0                	sub    %edx,%eax
  803484:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803489:	8b 55 0c             	mov    0xc(%ebp),%edx
  80348c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80348f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803492:	83 c6 01             	add    $0x1,%esi
  803495:	39 75 10             	cmp    %esi,0x10(%ebp)
  803498:	76 0d                	jbe    8034a7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80349a:	8b 03                	mov    (%ebx),%eax
  80349c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80349f:	75 d4                	jne    803475 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8034a1:	85 f6                	test   %esi,%esi
  8034a3:	75 b0                	jne    803455 <_ZL12devpipe_readP2FdPvj+0x29>
  8034a5:	eb b2                	jmp    803459 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8034a7:	89 f0                	mov    %esi,%eax
  8034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8034b0:	eb 05                	jmp    8034b7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8034b2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8034b7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8034ba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8034bd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8034c0:	89 ec                	mov    %ebp,%esp
  8034c2:	5d                   	pop    %ebp
  8034c3:	c3                   	ret    

008034c4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8034c4:	55                   	push   %ebp
  8034c5:	89 e5                	mov    %esp,%ebp
  8034c7:	83 ec 48             	sub    $0x48,%esp
  8034ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8034cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8034d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8034d3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  8034d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8034d9:	89 04 24             	mov    %eax,(%esp)
  8034dc:	e8 b6 e2 ff ff       	call   801797 <_Z14fd_find_unusedPP2Fd>
  8034e1:	89 c3                	mov    %eax,%ebx
  8034e3:	85 c0                	test   %eax,%eax
  8034e5:	0f 88 0b 01 00 00    	js     8035f6 <_Z4pipePi+0x132>
  8034eb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8034f2:	00 
  8034f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803501:	e8 2a d8 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803506:	89 c3                	mov    %eax,%ebx
  803508:	85 c0                	test   %eax,%eax
  80350a:	0f 89 f5 00 00 00    	jns    803605 <_Z4pipePi+0x141>
  803510:	e9 e1 00 00 00       	jmp    8035f6 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803515:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80351c:	00 
  80351d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803520:	89 44 24 04          	mov    %eax,0x4(%esp)
  803524:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80352b:	e8 00 d8 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803530:	89 c3                	mov    %eax,%ebx
  803532:	85 c0                	test   %eax,%eax
  803534:	0f 89 e2 00 00 00    	jns    80361c <_Z4pipePi+0x158>
  80353a:	e9 a4 00 00 00       	jmp    8035e3 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80353f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803542:	89 04 24             	mov    %eax,(%esp)
  803545:	e8 32 e2 ff ff       	call   80177c <_Z7fd2dataP2Fd>
  80354a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803551:	00 
  803552:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803556:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80355d:	00 
  80355e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803562:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803569:	e8 21 d8 ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
  80356e:	89 c3                	mov    %eax,%ebx
  803570:	85 c0                	test   %eax,%eax
  803572:	78 4c                	js     8035c0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803574:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80357a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80357f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803582:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803589:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80358f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803592:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803597:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80359e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a1:	89 04 24             	mov    %eax,(%esp)
  8035a4:	e8 8b e1 ff ff       	call   801734 <_Z6fd2numP2Fd>
  8035a9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8035ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ae:	89 04 24             	mov    %eax,(%esp)
  8035b1:	e8 7e e1 ff ff       	call   801734 <_Z6fd2numP2Fd>
  8035b6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8035b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8035be:	eb 36                	jmp    8035f6 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  8035c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8035c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035cb:	e8 1d d8 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  8035d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035de:	e8 0a d8 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  8035e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035f1:	e8 f7 d7 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  8035f6:	89 d8                	mov    %ebx,%eax
  8035f8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8035fb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8035fe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803601:	89 ec                	mov    %ebp,%esp
  803603:	5d                   	pop    %ebp
  803604:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803605:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803608:	89 04 24             	mov    %eax,(%esp)
  80360b:	e8 87 e1 ff ff       	call   801797 <_Z14fd_find_unusedPP2Fd>
  803610:	89 c3                	mov    %eax,%ebx
  803612:	85 c0                	test   %eax,%eax
  803614:	0f 89 fb fe ff ff    	jns    803515 <_Z4pipePi+0x51>
  80361a:	eb c7                	jmp    8035e3 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80361c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361f:	89 04 24             	mov    %eax,(%esp)
  803622:	e8 55 e1 ff ff       	call   80177c <_Z7fd2dataP2Fd>
  803627:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803629:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803630:	00 
  803631:	89 44 24 04          	mov    %eax,0x4(%esp)
  803635:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80363c:	e8 ef d6 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803641:	89 c3                	mov    %eax,%ebx
  803643:	85 c0                	test   %eax,%eax
  803645:	0f 89 f4 fe ff ff    	jns    80353f <_Z4pipePi+0x7b>
  80364b:	eb 83                	jmp    8035d0 <_Z4pipePi+0x10c>

0080364d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80364d:	55                   	push   %ebp
  80364e:	89 e5                	mov    %esp,%ebp
  803650:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803653:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80365a:	00 
  80365b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80365e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	89 04 24             	mov    %eax,(%esp)
  803668:	e8 74 e0 ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  80366d:	85 c0                	test   %eax,%eax
  80366f:	78 15                	js     803686 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803674:	89 04 24             	mov    %eax,(%esp)
  803677:	e8 00 e1 ff ff       	call   80177c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80367c:	89 c2                	mov    %eax,%edx
  80367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803681:	e8 c6 fc ff ff       	call   80334c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803686:	c9                   	leave  
  803687:	c3                   	ret    

00803688 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803688:	55                   	push   %ebp
  803689:	89 e5                	mov    %esp,%ebp
  80368b:	53                   	push   %ebx
  80368c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80368f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803692:	89 04 24             	mov    %eax,(%esp)
  803695:	e8 fd e0 ff ff       	call   801797 <_Z14fd_find_unusedPP2Fd>
  80369a:	89 c3                	mov    %eax,%ebx
  80369c:	85 c0                	test   %eax,%eax
  80369e:	0f 88 be 00 00 00    	js     803762 <_Z18pipe_ipc_recv_readv+0xda>
  8036a4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8036ab:	00 
  8036ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036ba:	e8 71 d6 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  8036bf:	89 c3                	mov    %eax,%ebx
  8036c1:	85 c0                	test   %eax,%eax
  8036c3:	0f 89 a1 00 00 00    	jns    80376a <_Z18pipe_ipc_recv_readv+0xe2>
  8036c9:	e9 94 00 00 00       	jmp    803762 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  8036ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	75 0e                	jne    8036e3 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  8036d5:	c7 04 24 78 4e 80 00 	movl   $0x804e78,(%esp)
  8036dc:	e8 55 cb ff ff       	call   800236 <_Z7cprintfPKcz>
  8036e1:	eb 10                	jmp    8036f3 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  8036e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036e7:	c7 04 24 2d 4e 80 00 	movl   $0x804e2d,(%esp)
  8036ee:	e8 43 cb ff ff       	call   800236 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  8036f3:	c7 04 24 37 4e 80 00 	movl   $0x804e37,(%esp)
  8036fa:	e8 37 cb ff ff       	call   800236 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  8036ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803702:	a8 04                	test   $0x4,%al
  803704:	74 04                	je     80370a <_Z18pipe_ipc_recv_readv+0x82>
  803706:	a8 01                	test   $0x1,%al
  803708:	75 24                	jne    80372e <_Z18pipe_ipc_recv_readv+0xa6>
  80370a:	c7 44 24 0c 4a 4e 80 	movl   $0x804e4a,0xc(%esp)
  803711:	00 
  803712:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  803719:	00 
  80371a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803721:	00 
  803722:	c7 04 24 67 4e 80 00 	movl   $0x804e67,(%esp)
  803729:	e8 8e 07 00 00       	call   803ebc <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80372e:	8b 15 20 50 80 00    	mov    0x805020,%edx
  803734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803737:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803743:	89 04 24             	mov    %eax,(%esp)
  803746:	e8 e9 df ff ff       	call   801734 <_Z6fd2numP2Fd>
  80374b:	89 c3                	mov    %eax,%ebx
  80374d:	eb 13                	jmp    803762 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80374f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803752:	89 44 24 04          	mov    %eax,0x4(%esp)
  803756:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80375d:	e8 8b d6 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803762:	89 d8                	mov    %ebx,%eax
  803764:	83 c4 24             	add    $0x24,%esp
  803767:	5b                   	pop    %ebx
  803768:	5d                   	pop    %ebp
  803769:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376d:	89 04 24             	mov    %eax,(%esp)
  803770:	e8 07 e0 ff ff       	call   80177c <_Z7fd2dataP2Fd>
  803775:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803778:	89 54 24 08          	mov    %edx,0x8(%esp)
  80377c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803780:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803783:	89 04 24             	mov    %eax,(%esp)
  803786:	e8 f5 08 00 00       	call   804080 <_Z8ipc_recvPiPvS_>
  80378b:	89 c3                	mov    %eax,%ebx
  80378d:	85 c0                	test   %eax,%eax
  80378f:	0f 89 39 ff ff ff    	jns    8036ce <_Z18pipe_ipc_recv_readv+0x46>
  803795:	eb b8                	jmp    80374f <_Z18pipe_ipc_recv_readv+0xc7>

00803797 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803797:	55                   	push   %ebp
  803798:	89 e5                	mov    %esp,%ebp
  80379a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80379d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8037a4:	00 
  8037a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8037a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037af:	89 04 24             	mov    %eax,(%esp)
  8037b2:	e8 2a df ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  8037b7:	85 c0                	test   %eax,%eax
  8037b9:	78 2f                	js     8037ea <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  8037bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037be:	89 04 24             	mov    %eax,(%esp)
  8037c1:	e8 b6 df ff ff       	call   80177c <_Z7fd2dataP2Fd>
  8037c6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8037cd:	00 
  8037ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8037d9:	00 
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	89 04 24             	mov    %eax,(%esp)
  8037e0:	e8 2a 09 00 00       	call   80410f <_Z8ipc_sendijPvi>
    return 0;
  8037e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037ea:	c9                   	leave  
  8037eb:	c3                   	ret    

008037ec <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8037ec:	55                   	push   %ebp
  8037ed:	89 e5                	mov    %esp,%ebp
  8037ef:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8037f2:	89 d0                	mov    %edx,%eax
  8037f4:	c1 e8 16             	shr    $0x16,%eax
  8037f7:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  8037fe:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803803:	f6 c1 01             	test   $0x1,%cl
  803806:	74 1d                	je     803825 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803808:	c1 ea 0c             	shr    $0xc,%edx
  80380b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803812:	f6 c2 01             	test   $0x1,%dl
  803815:	74 0e                	je     803825 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803817:	c1 ea 0c             	shr    $0xc,%edx
  80381a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803821:	ef 
  803822:	0f b7 c0             	movzwl %ax,%eax
}
  803825:	5d                   	pop    %ebp
  803826:	c3                   	ret    
	...

00803830 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803830:	55                   	push   %ebp
  803831:	89 e5                	mov    %esp,%ebp
  803833:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803836:	c7 44 24 04 9b 4e 80 	movl   $0x804e9b,0x4(%esp)
  80383d:	00 
  80383e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803841:	89 04 24             	mov    %eax,(%esp)
  803844:	e8 01 d0 ff ff       	call   80084a <_Z6strcpyPcPKc>
	return 0;
}
  803849:	b8 00 00 00 00       	mov    $0x0,%eax
  80384e:	c9                   	leave  
  80384f:	c3                   	ret    

00803850 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803850:	55                   	push   %ebp
  803851:	89 e5                	mov    %esp,%ebp
  803853:	53                   	push   %ebx
  803854:	83 ec 14             	sub    $0x14,%esp
  803857:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80385a:	89 1c 24             	mov    %ebx,(%esp)
  80385d:	e8 8a ff ff ff       	call   8037ec <_Z7pagerefPv>
  803862:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803864:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803869:	83 fa 01             	cmp    $0x1,%edx
  80386c:	75 0b                	jne    803879 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80386e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803871:	89 04 24             	mov    %eax,(%esp)
  803874:	e8 fe 02 00 00       	call   803b77 <_Z11nsipc_closei>
	else
		return 0;
}
  803879:	83 c4 14             	add    $0x14,%esp
  80387c:	5b                   	pop    %ebx
  80387d:	5d                   	pop    %ebp
  80387e:	c3                   	ret    

0080387f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80387f:	55                   	push   %ebp
  803880:	89 e5                	mov    %esp,%ebp
  803882:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803885:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80388c:	00 
  80388d:	8b 45 10             	mov    0x10(%ebp),%eax
  803890:	89 44 24 08          	mov    %eax,0x8(%esp)
  803894:	8b 45 0c             	mov    0xc(%ebp),%eax
  803897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80389b:	8b 45 08             	mov    0x8(%ebp),%eax
  80389e:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a1:	89 04 24             	mov    %eax,(%esp)
  8038a4:	e8 c9 03 00 00       	call   803c72 <_Z10nsipc_sendiPKvij>
}
  8038a9:	c9                   	leave  
  8038aa:	c3                   	ret    

008038ab <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8038ab:	55                   	push   %ebp
  8038ac:	89 e5                	mov    %esp,%ebp
  8038ae:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8038b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8038b8:	00 
  8038b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8038bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8038cd:	89 04 24             	mov    %eax,(%esp)
  8038d0:	e8 1d 03 00 00       	call   803bf2 <_Z10nsipc_recviPvij>
}
  8038d5:	c9                   	leave  
  8038d6:	c3                   	ret    

008038d7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8038d7:	55                   	push   %ebp
  8038d8:	89 e5                	mov    %esp,%ebp
  8038da:	83 ec 28             	sub    $0x28,%esp
  8038dd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8038e0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8038e3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  8038e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8038e8:	89 04 24             	mov    %eax,(%esp)
  8038eb:	e8 a7 de ff ff       	call   801797 <_Z14fd_find_unusedPP2Fd>
  8038f0:	89 c3                	mov    %eax,%ebx
  8038f2:	85 c0                	test   %eax,%eax
  8038f4:	78 21                	js     803917 <_ZL12alloc_sockfdi+0x40>
  8038f6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8038fd:	00 
  8038fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803901:	89 44 24 04          	mov    %eax,0x4(%esp)
  803905:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80390c:	e8 1f d4 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803911:	89 c3                	mov    %eax,%ebx
  803913:	85 c0                	test   %eax,%eax
  803915:	79 14                	jns    80392b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803917:	89 34 24             	mov    %esi,(%esp)
  80391a:	e8 58 02 00 00       	call   803b77 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  80391f:	89 d8                	mov    %ebx,%eax
  803921:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803924:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803927:	89 ec                	mov    %ebp,%esp
  803929:	5d                   	pop    %ebp
  80392a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  80392b:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803934:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803939:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803940:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803943:	89 04 24             	mov    %eax,(%esp)
  803946:	e8 e9 dd ff ff       	call   801734 <_Z6fd2numP2Fd>
  80394b:	89 c3                	mov    %eax,%ebx
  80394d:	eb d0                	jmp    80391f <_ZL12alloc_sockfdi+0x48>

0080394f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80394f:	55                   	push   %ebp
  803950:	89 e5                	mov    %esp,%ebp
  803952:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803955:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80395c:	00 
  80395d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803960:	89 54 24 04          	mov    %edx,0x4(%esp)
  803964:	89 04 24             	mov    %eax,(%esp)
  803967:	e8 75 dd ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  80396c:	85 c0                	test   %eax,%eax
  80396e:	78 15                	js     803985 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803970:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803973:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803978:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80397e:	39 0a                	cmp    %ecx,(%edx)
  803980:	75 03                	jne    803985 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803982:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803985:	c9                   	leave  
  803986:	c3                   	ret    

00803987 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803987:	55                   	push   %ebp
  803988:	89 e5                	mov    %esp,%ebp
  80398a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80398d:	8b 45 08             	mov    0x8(%ebp),%eax
  803990:	e8 ba ff ff ff       	call   80394f <_ZL9fd2sockidi>
  803995:	85 c0                	test   %eax,%eax
  803997:	78 1f                	js     8039b8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803999:	8b 55 10             	mov    0x10(%ebp),%edx
  80399c:	89 54 24 08          	mov    %edx,0x8(%esp)
  8039a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039a7:	89 04 24             	mov    %eax,(%esp)
  8039aa:	e8 19 01 00 00       	call   803ac8 <_Z12nsipc_acceptiP8sockaddrPj>
  8039af:	85 c0                	test   %eax,%eax
  8039b1:	78 05                	js     8039b8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  8039b3:	e8 1f ff ff ff       	call   8038d7 <_ZL12alloc_sockfdi>
}
  8039b8:	c9                   	leave  
  8039b9:	c3                   	ret    

008039ba <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039ba:	55                   	push   %ebp
  8039bb:	89 e5                	mov    %esp,%ebp
  8039bd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c3:	e8 87 ff ff ff       	call   80394f <_ZL9fd2sockidi>
  8039c8:	85 c0                	test   %eax,%eax
  8039ca:	78 16                	js     8039e2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8039cc:	8b 55 10             	mov    0x10(%ebp),%edx
  8039cf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8039d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039da:	89 04 24             	mov    %eax,(%esp)
  8039dd:	e8 34 01 00 00       	call   803b16 <_Z10nsipc_bindiP8sockaddrj>
}
  8039e2:	c9                   	leave  
  8039e3:	c3                   	ret    

008039e4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  8039e4:	55                   	push   %ebp
  8039e5:	89 e5                	mov    %esp,%ebp
  8039e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ed:	e8 5d ff ff ff       	call   80394f <_ZL9fd2sockidi>
  8039f2:	85 c0                	test   %eax,%eax
  8039f4:	78 0f                	js     803a05 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8039f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039fd:	89 04 24             	mov    %eax,(%esp)
  803a00:	e8 50 01 00 00       	call   803b55 <_Z14nsipc_shutdownii>
}
  803a05:	c9                   	leave  
  803a06:	c3                   	ret    

00803a07 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a07:	55                   	push   %ebp
  803a08:	89 e5                	mov    %esp,%ebp
  803a0a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a10:	e8 3a ff ff ff       	call   80394f <_ZL9fd2sockidi>
  803a15:	85 c0                	test   %eax,%eax
  803a17:	78 16                	js     803a2f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803a19:	8b 55 10             	mov    0x10(%ebp),%edx
  803a1c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a23:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a27:	89 04 24             	mov    %eax,(%esp)
  803a2a:	e8 62 01 00 00       	call   803b91 <_Z13nsipc_connectiPK8sockaddrj>
}
  803a2f:	c9                   	leave  
  803a30:	c3                   	ret    

00803a31 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803a31:	55                   	push   %ebp
  803a32:	89 e5                	mov    %esp,%ebp
  803a34:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a37:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3a:	e8 10 ff ff ff       	call   80394f <_ZL9fd2sockidi>
  803a3f:	85 c0                	test   %eax,%eax
  803a41:	78 0f                	js     803a52 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a46:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a4a:	89 04 24             	mov    %eax,(%esp)
  803a4d:	e8 7e 01 00 00       	call   803bd0 <_Z12nsipc_listenii>
}
  803a52:	c9                   	leave  
  803a53:	c3                   	ret    

00803a54 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803a54:	55                   	push   %ebp
  803a55:	89 e5                	mov    %esp,%ebp
  803a57:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  803a5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a68:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6b:	89 04 24             	mov    %eax,(%esp)
  803a6e:	e8 72 02 00 00       	call   803ce5 <_Z12nsipc_socketiii>
  803a73:	85 c0                	test   %eax,%eax
  803a75:	78 05                	js     803a7c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803a77:	e8 5b fe ff ff       	call   8038d7 <_ZL12alloc_sockfdi>
}
  803a7c:	c9                   	leave  
  803a7d:	8d 76 00             	lea    0x0(%esi),%esi
  803a80:	c3                   	ret    
  803a81:	00 00                	add    %al,(%eax)
	...

00803a84 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a84:	55                   	push   %ebp
  803a85:	89 e5                	mov    %esp,%ebp
  803a87:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a8a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803a91:	00 
  803a92:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803a99:	00 
  803a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a9e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803aa5:	e8 65 06 00 00       	call   80410f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803aaa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803ab1:	00 
  803ab2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803ab9:	00 
  803aba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ac1:	e8 ba 05 00 00       	call   804080 <_Z8ipc_recvPiPvS_>
}
  803ac6:	c9                   	leave  
  803ac7:	c3                   	ret    

00803ac8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803ac8:	55                   	push   %ebp
  803ac9:	89 e5                	mov    %esp,%ebp
  803acb:	53                   	push   %ebx
  803acc:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803ad7:	b8 01 00 00 00       	mov    $0x1,%eax
  803adc:	e8 a3 ff ff ff       	call   803a84 <_ZL5nsipcj>
  803ae1:	89 c3                	mov    %eax,%ebx
  803ae3:	85 c0                	test   %eax,%eax
  803ae5:	78 27                	js     803b0e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803ae7:	a1 10 70 80 00       	mov    0x807010,%eax
  803aec:	89 44 24 08          	mov    %eax,0x8(%esp)
  803af0:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803af7:	00 
  803af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803afb:	89 04 24             	mov    %eax,(%esp)
  803afe:	e8 e9 ce ff ff       	call   8009ec <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803b03:	8b 15 10 70 80 00    	mov    0x807010,%edx
  803b09:	8b 45 10             	mov    0x10(%ebp),%eax
  803b0c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803b0e:	89 d8                	mov    %ebx,%eax
  803b10:	83 c4 14             	add    $0x14,%esp
  803b13:	5b                   	pop    %ebx
  803b14:	5d                   	pop    %ebp
  803b15:	c3                   	ret    

00803b16 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b16:	55                   	push   %ebp
  803b17:	89 e5                	mov    %esp,%ebp
  803b19:	53                   	push   %ebx
  803b1a:	83 ec 14             	sub    $0x14,%esp
  803b1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803b20:	8b 45 08             	mov    0x8(%ebp),%eax
  803b23:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803b28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b33:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803b3a:	e8 ad ce ff ff       	call   8009ec <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803b3f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803b45:	b8 02 00 00 00       	mov    $0x2,%eax
  803b4a:	e8 35 ff ff ff       	call   803a84 <_ZL5nsipcj>
}
  803b4f:	83 c4 14             	add    $0x14,%esp
  803b52:	5b                   	pop    %ebx
  803b53:	5d                   	pop    %ebp
  803b54:	c3                   	ret    

00803b55 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803b55:	55                   	push   %ebp
  803b56:	89 e5                	mov    %esp,%ebp
  803b58:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b66:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  803b6b:	b8 03 00 00 00       	mov    $0x3,%eax
  803b70:	e8 0f ff ff ff       	call   803a84 <_ZL5nsipcj>
}
  803b75:	c9                   	leave  
  803b76:	c3                   	ret    

00803b77 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803b77:	55                   	push   %ebp
  803b78:	89 e5                	mov    %esp,%ebp
  803b7a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b80:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803b85:	b8 04 00 00 00       	mov    $0x4,%eax
  803b8a:	e8 f5 fe ff ff       	call   803a84 <_ZL5nsipcj>
}
  803b8f:	c9                   	leave  
  803b90:	c3                   	ret    

00803b91 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b91:	55                   	push   %ebp
  803b92:	89 e5                	mov    %esp,%ebp
  803b94:	53                   	push   %ebx
  803b95:	83 ec 14             	sub    $0x14,%esp
  803b98:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ba3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803baa:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bae:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803bb5:	e8 32 ce ff ff       	call   8009ec <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803bba:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803bc0:	b8 05 00 00 00       	mov    $0x5,%eax
  803bc5:	e8 ba fe ff ff       	call   803a84 <_ZL5nsipcj>
}
  803bca:	83 c4 14             	add    $0x14,%esp
  803bcd:	5b                   	pop    %ebx
  803bce:	5d                   	pop    %ebp
  803bcf:	c3                   	ret    

00803bd0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803bd0:	55                   	push   %ebp
  803bd1:	89 e5                	mov    %esp,%ebp
  803bd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  803bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  803be1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803be6:	b8 06 00 00 00       	mov    $0x6,%eax
  803beb:	e8 94 fe ff ff       	call   803a84 <_ZL5nsipcj>
}
  803bf0:	c9                   	leave  
  803bf1:	c3                   	ret    

00803bf2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803bf2:	55                   	push   %ebp
  803bf3:	89 e5                	mov    %esp,%ebp
  803bf5:	56                   	push   %esi
  803bf6:	53                   	push   %ebx
  803bf7:	83 ec 10             	sub    $0x10,%esp
  803bfa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803c00:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803c05:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  803c0b:	8b 45 14             	mov    0x14(%ebp),%eax
  803c0e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c13:	b8 07 00 00 00       	mov    $0x7,%eax
  803c18:	e8 67 fe ff ff       	call   803a84 <_ZL5nsipcj>
  803c1d:	89 c3                	mov    %eax,%ebx
  803c1f:	85 c0                	test   %eax,%eax
  803c21:	78 46                	js     803c69 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803c23:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803c28:	7f 04                	jg     803c2e <_Z10nsipc_recviPvij+0x3c>
  803c2a:	39 f0                	cmp    %esi,%eax
  803c2c:	7e 24                	jle    803c52 <_Z10nsipc_recviPvij+0x60>
  803c2e:	c7 44 24 0c a7 4e 80 	movl   $0x804ea7,0xc(%esp)
  803c35:	00 
  803c36:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  803c3d:	00 
  803c3e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803c45:	00 
  803c46:	c7 04 24 bc 4e 80 00 	movl   $0x804ebc,(%esp)
  803c4d:	e8 6a 02 00 00       	call   803ebc <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803c52:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c56:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803c5d:	00 
  803c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c61:	89 04 24             	mov    %eax,(%esp)
  803c64:	e8 83 cd ff ff       	call   8009ec <memmove>
	}

	return r;
}
  803c69:	89 d8                	mov    %ebx,%eax
  803c6b:	83 c4 10             	add    $0x10,%esp
  803c6e:	5b                   	pop    %ebx
  803c6f:	5e                   	pop    %esi
  803c70:	5d                   	pop    %ebp
  803c71:	c3                   	ret    

00803c72 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803c72:	55                   	push   %ebp
  803c73:	89 e5                	mov    %esp,%ebp
  803c75:	53                   	push   %ebx
  803c76:	83 ec 14             	sub    $0x14,%esp
  803c79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803c84:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803c8a:	7e 24                	jle    803cb0 <_Z10nsipc_sendiPKvij+0x3e>
  803c8c:	c7 44 24 0c c8 4e 80 	movl   $0x804ec8,0xc(%esp)
  803c93:	00 
  803c94:	c7 44 24 08 14 48 80 	movl   $0x804814,0x8(%esp)
  803c9b:	00 
  803c9c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803ca3:	00 
  803ca4:	c7 04 24 bc 4e 80 00 	movl   $0x804ebc,(%esp)
  803cab:	e8 0c 02 00 00       	call   803ebc <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803cb0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cbb:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803cc2:	e8 25 cd ff ff       	call   8009ec <memmove>
	nsipcbuf.send.req_size = size;
  803cc7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  803ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  803cd0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803cd5:	b8 08 00 00 00       	mov    $0x8,%eax
  803cda:	e8 a5 fd ff ff       	call   803a84 <_ZL5nsipcj>
}
  803cdf:	83 c4 14             	add    $0x14,%esp
  803ce2:	5b                   	pop    %ebx
  803ce3:	5d                   	pop    %ebp
  803ce4:	c3                   	ret    

00803ce5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ce5:	55                   	push   %ebp
  803ce6:	89 e5                	mov    %esp,%ebp
  803ce8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cee:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cf6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  803cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  803cfe:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803d03:	b8 09 00 00 00       	mov    $0x9,%eax
  803d08:	e8 77 fd ff ff       	call   803a84 <_ZL5nsipcj>
}
  803d0d:	c9                   	leave  
  803d0e:	c3                   	ret    
	...

00803d10 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803d10:	55                   	push   %ebp
  803d11:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803d13:	b8 00 00 00 00       	mov    $0x0,%eax
  803d18:	5d                   	pop    %ebp
  803d19:	c3                   	ret    

00803d1a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803d1a:	55                   	push   %ebp
  803d1b:	89 e5                	mov    %esp,%ebp
  803d1d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803d20:	c7 44 24 04 d4 4e 80 	movl   $0x804ed4,0x4(%esp)
  803d27:	00 
  803d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d2b:	89 04 24             	mov    %eax,(%esp)
  803d2e:	e8 17 cb ff ff       	call   80084a <_Z6strcpyPcPKc>
	return 0;
}
  803d33:	b8 00 00 00 00       	mov    $0x0,%eax
  803d38:	c9                   	leave  
  803d39:	c3                   	ret    

00803d3a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d3a:	55                   	push   %ebp
  803d3b:	89 e5                	mov    %esp,%ebp
  803d3d:	57                   	push   %edi
  803d3e:	56                   	push   %esi
  803d3f:	53                   	push   %ebx
  803d40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d46:	bb 00 00 00 00       	mov    $0x0,%ebx
  803d4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803d4f:	74 3e                	je     803d8f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803d51:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803d57:	8b 75 10             	mov    0x10(%ebp),%esi
  803d5a:	29 de                	sub    %ebx,%esi
  803d5c:	83 fe 7f             	cmp    $0x7f,%esi
  803d5f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803d64:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803d67:	89 74 24 08          	mov    %esi,0x8(%esp)
  803d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d6e:	01 d8                	add    %ebx,%eax
  803d70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d74:	89 3c 24             	mov    %edi,(%esp)
  803d77:	e8 70 cc ff ff       	call   8009ec <memmove>
		sys_cputs(buf, m);
  803d7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803d80:	89 3c 24             	mov    %edi,(%esp)
  803d83:	e8 7c ce ff ff       	call   800c04 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d88:	01 f3                	add    %esi,%ebx
  803d8a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803d8d:	77 c8                	ja     803d57 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803d8f:	89 d8                	mov    %ebx,%eax
  803d91:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803d97:	5b                   	pop    %ebx
  803d98:	5e                   	pop    %esi
  803d99:	5f                   	pop    %edi
  803d9a:	5d                   	pop    %ebp
  803d9b:	c3                   	ret    

00803d9c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d9c:	55                   	push   %ebp
  803d9d:	89 e5                	mov    %esp,%ebp
  803d9f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803da2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803da7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803dab:	75 07                	jne    803db4 <_ZL12devcons_readP2FdPvj+0x18>
  803dad:	eb 2a                	jmp    803dd9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803daf:	e8 48 cf ff ff       	call   800cfc <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803db4:	e8 7e ce ff ff       	call   800c37 <_Z9sys_cgetcv>
  803db9:	85 c0                	test   %eax,%eax
  803dbb:	74 f2                	je     803daf <_ZL12devcons_readP2FdPvj+0x13>
  803dbd:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803dbf:	85 c0                	test   %eax,%eax
  803dc1:	78 16                	js     803dd9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803dc3:	83 f8 04             	cmp    $0x4,%eax
  803dc6:	74 0c                	je     803dd4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dcb:	88 10                	mov    %dl,(%eax)
	return 1;
  803dcd:	b8 01 00 00 00       	mov    $0x1,%eax
  803dd2:	eb 05                	jmp    803dd9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803dd4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803dd9:	c9                   	leave  
  803dda:	c3                   	ret    

00803ddb <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803ddb:	55                   	push   %ebp
  803ddc:	89 e5                	mov    %esp,%ebp
  803dde:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803de1:	8b 45 08             	mov    0x8(%ebp),%eax
  803de4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803de7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803dee:	00 
  803def:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803df2:	89 04 24             	mov    %eax,(%esp)
  803df5:	e8 0a ce ff ff       	call   800c04 <_Z9sys_cputsPKcj>
}
  803dfa:	c9                   	leave  
  803dfb:	c3                   	ret    

00803dfc <_Z7getcharv>:

int
getchar(void)
{
  803dfc:	55                   	push   %ebp
  803dfd:	89 e5                	mov    %esp,%ebp
  803dff:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e02:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803e09:	00 
  803e0a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e18:	e8 71 dc ff ff       	call   801a8e <_Z4readiPvj>
	if (r < 0)
  803e1d:	85 c0                	test   %eax,%eax
  803e1f:	78 0f                	js     803e30 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803e21:	85 c0                	test   %eax,%eax
  803e23:	7e 06                	jle    803e2b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803e25:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803e29:	eb 05                	jmp    803e30 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803e2b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803e30:	c9                   	leave  
  803e31:	c3                   	ret    

00803e32 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803e32:	55                   	push   %ebp
  803e33:	89 e5                	mov    %esp,%ebp
  803e35:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803e38:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803e3f:	00 
  803e40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803e43:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e47:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4a:	89 04 24             	mov    %eax,(%esp)
  803e4d:	e8 8f d8 ff ff       	call   8016e1 <_Z9fd_lookupiPP2Fdb>
  803e52:	85 c0                	test   %eax,%eax
  803e54:	78 11                	js     803e67 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e59:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803e5f:	39 10                	cmp    %edx,(%eax)
  803e61:	0f 94 c0             	sete   %al
  803e64:	0f b6 c0             	movzbl %al,%eax
}
  803e67:	c9                   	leave  
  803e68:	c3                   	ret    

00803e69 <_Z8openconsv>:

int
opencons(void)
{
  803e69:	55                   	push   %ebp
  803e6a:	89 e5                	mov    %esp,%ebp
  803e6c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803e6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803e72:	89 04 24             	mov    %eax,(%esp)
  803e75:	e8 1d d9 ff ff       	call   801797 <_Z14fd_find_unusedPP2Fd>
  803e7a:	85 c0                	test   %eax,%eax
  803e7c:	78 3c                	js     803eba <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e7e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803e85:	00 
  803e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e89:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e94:	e8 97 ce ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803e99:	85 c0                	test   %eax,%eax
  803e9b:	78 1d                	js     803eba <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803e9d:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803eb2:	89 04 24             	mov    %eax,(%esp)
  803eb5:	e8 7a d8 ff ff       	call   801734 <_Z6fd2numP2Fd>
}
  803eba:	c9                   	leave  
  803ebb:	c3                   	ret    

00803ebc <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803ebc:	55                   	push   %ebp
  803ebd:	89 e5                	mov    %esp,%ebp
  803ebf:	56                   	push   %esi
  803ec0:	53                   	push   %ebx
  803ec1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  803ec4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  803ec7:	a1 00 80 80 00       	mov    0x808000,%eax
  803ecc:	85 c0                	test   %eax,%eax
  803ece:	74 10                	je     803ee0 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  803ed0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ed4:	c7 04 24 e0 4e 80 00 	movl   $0x804ee0,(%esp)
  803edb:	e8 56 c3 ff ff       	call   800236 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  803ee0:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  803ee6:	e8 dd cd ff ff       	call   800cc8 <_Z12sys_getenvidv>
  803eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  803eee:	89 54 24 10          	mov    %edx,0x10(%esp)
  803ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ef5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803ef9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803efd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f01:	c7 04 24 e8 4e 80 00 	movl   $0x804ee8,(%esp)
  803f08:	e8 29 c3 ff ff       	call   800236 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  803f0d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803f11:	8b 45 10             	mov    0x10(%ebp),%eax
  803f14:	89 04 24             	mov    %eax,(%esp)
  803f17:	e8 b9 c2 ff ff       	call   8001d5 <_Z8vcprintfPKcPc>
	cprintf("\n");
  803f1c:	c7 04 24 ef 43 80 00 	movl   $0x8043ef,(%esp)
  803f23:	e8 0e c3 ff ff       	call   800236 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803f28:	cc                   	int3   
  803f29:	eb fd                	jmp    803f28 <_Z6_panicPKciS0_z+0x6c>
  803f2b:	00 00                	add    %al,(%eax)
  803f2d:	00 00                	add    %al,(%eax)
	...

00803f30 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803f30:	55                   	push   %ebp
  803f31:	89 e5                	mov    %esp,%ebp
  803f33:	56                   	push   %esi
  803f34:	53                   	push   %ebx
  803f35:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803f38:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803f3d:	8b 04 9d 20 80 80 00 	mov    0x808020(,%ebx,4),%eax
  803f44:	85 c0                	test   %eax,%eax
  803f46:	74 08                	je     803f50 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803f48:	8d 55 08             	lea    0x8(%ebp),%edx
  803f4b:	89 14 24             	mov    %edx,(%esp)
  803f4e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803f50:	83 eb 01             	sub    $0x1,%ebx
  803f53:	83 fb ff             	cmp    $0xffffffff,%ebx
  803f56:	75 e5                	jne    803f3d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803f58:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803f5b:	8b 75 08             	mov    0x8(%ebp),%esi
  803f5e:	e8 65 cd ff ff       	call   800cc8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803f63:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803f67:	89 74 24 10          	mov    %esi,0x10(%esp)
  803f6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f6f:	c7 44 24 08 0c 4f 80 	movl   $0x804f0c,0x8(%esp)
  803f76:	00 
  803f77:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803f7e:	00 
  803f7f:	c7 04 24 90 4f 80 00 	movl   $0x804f90,(%esp)
  803f86:	e8 31 ff ff ff       	call   803ebc <_Z6_panicPKciS0_z>

00803f8b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803f8b:	55                   	push   %ebp
  803f8c:	89 e5                	mov    %esp,%ebp
  803f8e:	56                   	push   %esi
  803f8f:	53                   	push   %ebx
  803f90:	83 ec 10             	sub    $0x10,%esp
  803f93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803f96:	e8 2d cd ff ff       	call   800cc8 <_Z12sys_getenvidv>
  803f9b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803f9d:	a1 00 60 80 00       	mov    0x806000,%eax
  803fa2:	8b 40 5c             	mov    0x5c(%eax),%eax
  803fa5:	85 c0                	test   %eax,%eax
  803fa7:	75 4c                	jne    803ff5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803fa9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803fb0:	00 
  803fb1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803fb8:	ee 
  803fb9:	89 34 24             	mov    %esi,(%esp)
  803fbc:	e8 6f cd ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803fc1:	85 c0                	test   %eax,%eax
  803fc3:	74 20                	je     803fe5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803fc5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803fc9:	c7 44 24 08 44 4f 80 	movl   $0x804f44,0x8(%esp)
  803fd0:	00 
  803fd1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803fd8:	00 
  803fd9:	c7 04 24 90 4f 80 00 	movl   $0x804f90,(%esp)
  803fe0:	e8 d7 fe ff ff       	call   803ebc <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803fe5:	c7 44 24 04 30 3f 80 	movl   $0x803f30,0x4(%esp)
  803fec:	00 
  803fed:	89 34 24             	mov    %esi,(%esp)
  803ff0:	e8 70 cf ff ff       	call   800f65 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803ff5:	a1 20 80 80 00       	mov    0x808020,%eax
  803ffa:	39 d8                	cmp    %ebx,%eax
  803ffc:	74 1a                	je     804018 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803ffe:	85 c0                	test   %eax,%eax
  804000:	74 20                	je     804022 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804002:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804007:	8b 14 85 20 80 80 00 	mov    0x808020(,%eax,4),%edx
  80400e:	39 da                	cmp    %ebx,%edx
  804010:	74 15                	je     804027 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804012:	85 d2                	test   %edx,%edx
  804014:	75 1f                	jne    804035 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804016:	eb 0f                	jmp    804027 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804018:	b8 00 00 00 00       	mov    $0x0,%eax
  80401d:	8d 76 00             	lea    0x0(%esi),%esi
  804020:	eb 05                	jmp    804027 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804022:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804027:	89 1c 85 20 80 80 00 	mov    %ebx,0x808020(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80402e:	83 c4 10             	add    $0x10,%esp
  804031:	5b                   	pop    %ebx
  804032:	5e                   	pop    %esi
  804033:	5d                   	pop    %ebp
  804034:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804035:	83 c0 01             	add    $0x1,%eax
  804038:	83 f8 08             	cmp    $0x8,%eax
  80403b:	75 ca                	jne    804007 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80403d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804041:	c7 44 24 08 68 4f 80 	movl   $0x804f68,0x8(%esp)
  804048:	00 
  804049:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804050:	00 
  804051:	c7 04 24 90 4f 80 00 	movl   $0x804f90,(%esp)
  804058:	e8 5f fe ff ff       	call   803ebc <_Z6_panicPKciS0_z>
  80405d:	00 00                	add    %al,(%eax)
	...

00804060 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  804060:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  804063:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  804064:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  804067:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  80406b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  80406f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  804072:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  804074:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  804078:	61                   	popa   
    popf
  804079:	9d                   	popf   
    popl %esp
  80407a:	5c                   	pop    %esp
    ret
  80407b:	c3                   	ret    

0080407c <spin>:

spin:	jmp spin
  80407c:	eb fe                	jmp    80407c <spin>
	...

00804080 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804080:	55                   	push   %ebp
  804081:	89 e5                	mov    %esp,%ebp
  804083:	56                   	push   %esi
  804084:	53                   	push   %ebx
  804085:	83 ec 10             	sub    $0x10,%esp
  804088:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80408b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80408e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  804091:	85 c0                	test   %eax,%eax
  804093:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  804098:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80409b:	89 04 24             	mov    %eax,(%esp)
  80409e:	e8 58 cf ff ff       	call   800ffb <_Z12sys_ipc_recvPv>
  8040a3:	85 c0                	test   %eax,%eax
  8040a5:	79 16                	jns    8040bd <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  8040a7:	85 db                	test   %ebx,%ebx
  8040a9:	74 06                	je     8040b1 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  8040ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  8040b1:	85 f6                	test   %esi,%esi
  8040b3:	74 53                	je     804108 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  8040b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8040bb:	eb 4b                	jmp    804108 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  8040bd:	85 db                	test   %ebx,%ebx
  8040bf:	74 17                	je     8040d8 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  8040c1:	e8 02 cc ff ff       	call   800cc8 <_Z12sys_getenvidv>
  8040c6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8040cb:	6b c0 78             	imul   $0x78,%eax,%eax
  8040ce:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  8040d3:	8b 40 60             	mov    0x60(%eax),%eax
  8040d6:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  8040d8:	85 f6                	test   %esi,%esi
  8040da:	74 17                	je     8040f3 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  8040dc:	e8 e7 cb ff ff       	call   800cc8 <_Z12sys_getenvidv>
  8040e1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8040e6:	6b c0 78             	imul   $0x78,%eax,%eax
  8040e9:	05 00 00 00 ef       	add    $0xef000000,%eax
  8040ee:	8b 40 70             	mov    0x70(%eax),%eax
  8040f1:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  8040f3:	e8 d0 cb ff ff       	call   800cc8 <_Z12sys_getenvidv>
  8040f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8040fd:	6b c0 78             	imul   $0x78,%eax,%eax
  804100:	05 08 00 00 ef       	add    $0xef000008,%eax
  804105:	8b 40 60             	mov    0x60(%eax),%eax

}
  804108:	83 c4 10             	add    $0x10,%esp
  80410b:	5b                   	pop    %ebx
  80410c:	5e                   	pop    %esi
  80410d:	5d                   	pop    %ebp
  80410e:	c3                   	ret    

0080410f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80410f:	55                   	push   %ebp
  804110:	89 e5                	mov    %esp,%ebp
  804112:	57                   	push   %edi
  804113:	56                   	push   %esi
  804114:	53                   	push   %ebx
  804115:	83 ec 1c             	sub    $0x1c,%esp
  804118:	8b 75 08             	mov    0x8(%ebp),%esi
  80411b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80411e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  804121:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  804123:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  804128:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  80412b:	8b 45 14             	mov    0x14(%ebp),%eax
  80412e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804132:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804136:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80413a:	89 34 24             	mov    %esi,(%esp)
  80413d:	e8 81 ce ff ff       	call   800fc3 <_Z16sys_ipc_try_sendijPvi>
  804142:	85 c0                	test   %eax,%eax
  804144:	79 31                	jns    804177 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  804146:	83 f8 f9             	cmp    $0xfffffff9,%eax
  804149:	75 0c                	jne    804157 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  80414b:	90                   	nop
  80414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804150:	e8 a7 cb ff ff       	call   800cfc <_Z9sys_yieldv>
  804155:	eb d4                	jmp    80412b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  804157:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80415b:	c7 44 24 08 9e 4f 80 	movl   $0x804f9e,0x8(%esp)
  804162:	00 
  804163:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  80416a:	00 
  80416b:	c7 04 24 ab 4f 80 00 	movl   $0x804fab,(%esp)
  804172:	e8 45 fd ff ff       	call   803ebc <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  804177:	83 c4 1c             	add    $0x1c,%esp
  80417a:	5b                   	pop    %ebx
  80417b:	5e                   	pop    %esi
  80417c:	5f                   	pop    %edi
  80417d:	5d                   	pop    %ebp
  80417e:	c3                   	ret    
	...

00804180 <__udivdi3>:
  804180:	55                   	push   %ebp
  804181:	89 e5                	mov    %esp,%ebp
  804183:	57                   	push   %edi
  804184:	56                   	push   %esi
  804185:	83 ec 20             	sub    $0x20,%esp
  804188:	8b 45 14             	mov    0x14(%ebp),%eax
  80418b:	8b 75 08             	mov    0x8(%ebp),%esi
  80418e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804191:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804194:	85 c0                	test   %eax,%eax
  804196:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804199:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80419c:	75 3a                	jne    8041d8 <__udivdi3+0x58>
  80419e:	39 f9                	cmp    %edi,%ecx
  8041a0:	77 66                	ja     804208 <__udivdi3+0x88>
  8041a2:	85 c9                	test   %ecx,%ecx
  8041a4:	75 0b                	jne    8041b1 <__udivdi3+0x31>
  8041a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8041ab:	31 d2                	xor    %edx,%edx
  8041ad:	f7 f1                	div    %ecx
  8041af:	89 c1                	mov    %eax,%ecx
  8041b1:	89 f8                	mov    %edi,%eax
  8041b3:	31 d2                	xor    %edx,%edx
  8041b5:	f7 f1                	div    %ecx
  8041b7:	89 c7                	mov    %eax,%edi
  8041b9:	89 f0                	mov    %esi,%eax
  8041bb:	f7 f1                	div    %ecx
  8041bd:	89 fa                	mov    %edi,%edx
  8041bf:	89 c6                	mov    %eax,%esi
  8041c1:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8041c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8041c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8041cd:	83 c4 20             	add    $0x20,%esp
  8041d0:	5e                   	pop    %esi
  8041d1:	5f                   	pop    %edi
  8041d2:	5d                   	pop    %ebp
  8041d3:	c3                   	ret    
  8041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8041d8:	31 d2                	xor    %edx,%edx
  8041da:	31 f6                	xor    %esi,%esi
  8041dc:	39 f8                	cmp    %edi,%eax
  8041de:	77 e1                	ja     8041c1 <__udivdi3+0x41>
  8041e0:	0f bd d0             	bsr    %eax,%edx
  8041e3:	83 f2 1f             	xor    $0x1f,%edx
  8041e6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8041e9:	75 2d                	jne    804218 <__udivdi3+0x98>
  8041eb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8041ee:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  8041f1:	76 06                	jbe    8041f9 <__udivdi3+0x79>
  8041f3:	39 f8                	cmp    %edi,%eax
  8041f5:	89 f2                	mov    %esi,%edx
  8041f7:	73 c8                	jae    8041c1 <__udivdi3+0x41>
  8041f9:	31 d2                	xor    %edx,%edx
  8041fb:	be 01 00 00 00       	mov    $0x1,%esi
  804200:	eb bf                	jmp    8041c1 <__udivdi3+0x41>
  804202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804208:	89 f0                	mov    %esi,%eax
  80420a:	89 fa                	mov    %edi,%edx
  80420c:	f7 f1                	div    %ecx
  80420e:	31 d2                	xor    %edx,%edx
  804210:	89 c6                	mov    %eax,%esi
  804212:	eb ad                	jmp    8041c1 <__udivdi3+0x41>
  804214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804218:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80421c:	89 c2                	mov    %eax,%edx
  80421e:	b8 20 00 00 00       	mov    $0x20,%eax
  804223:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804226:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804229:	d3 e2                	shl    %cl,%edx
  80422b:	89 c1                	mov    %eax,%ecx
  80422d:	d3 ee                	shr    %cl,%esi
  80422f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804233:	09 d6                	or     %edx,%esi
  804235:	89 fa                	mov    %edi,%edx
  804237:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80423a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80423d:	d3 e6                	shl    %cl,%esi
  80423f:	89 c1                	mov    %eax,%ecx
  804241:	d3 ea                	shr    %cl,%edx
  804243:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804247:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80424a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80424d:	d3 e7                	shl    %cl,%edi
  80424f:	89 c1                	mov    %eax,%ecx
  804251:	d3 ee                	shr    %cl,%esi
  804253:	09 fe                	or     %edi,%esi
  804255:	89 f0                	mov    %esi,%eax
  804257:	f7 75 e4             	divl   -0x1c(%ebp)
  80425a:	89 d7                	mov    %edx,%edi
  80425c:	89 c6                	mov    %eax,%esi
  80425e:	f7 65 f0             	mull   -0x10(%ebp)
  804261:	39 d7                	cmp    %edx,%edi
  804263:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804266:	72 12                	jb     80427a <__udivdi3+0xfa>
  804268:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80426b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80426f:	d3 e2                	shl    %cl,%edx
  804271:	39 c2                	cmp    %eax,%edx
  804273:	73 08                	jae    80427d <__udivdi3+0xfd>
  804275:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804278:	75 03                	jne    80427d <__udivdi3+0xfd>
  80427a:	83 ee 01             	sub    $0x1,%esi
  80427d:	31 d2                	xor    %edx,%edx
  80427f:	e9 3d ff ff ff       	jmp    8041c1 <__udivdi3+0x41>
	...

00804290 <__umoddi3>:
  804290:	55                   	push   %ebp
  804291:	89 e5                	mov    %esp,%ebp
  804293:	57                   	push   %edi
  804294:	56                   	push   %esi
  804295:	83 ec 20             	sub    $0x20,%esp
  804298:	8b 7d 14             	mov    0x14(%ebp),%edi
  80429b:	8b 45 08             	mov    0x8(%ebp),%eax
  80429e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8042a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8042a4:	85 ff                	test   %edi,%edi
  8042a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8042a9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8042ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8042af:	89 f2                	mov    %esi,%edx
  8042b1:	75 15                	jne    8042c8 <__umoddi3+0x38>
  8042b3:	39 f1                	cmp    %esi,%ecx
  8042b5:	76 41                	jbe    8042f8 <__umoddi3+0x68>
  8042b7:	f7 f1                	div    %ecx
  8042b9:	89 d0                	mov    %edx,%eax
  8042bb:	31 d2                	xor    %edx,%edx
  8042bd:	83 c4 20             	add    $0x20,%esp
  8042c0:	5e                   	pop    %esi
  8042c1:	5f                   	pop    %edi
  8042c2:	5d                   	pop    %ebp
  8042c3:	c3                   	ret    
  8042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8042c8:	39 f7                	cmp    %esi,%edi
  8042ca:	77 4c                	ja     804318 <__umoddi3+0x88>
  8042cc:	0f bd c7             	bsr    %edi,%eax
  8042cf:	83 f0 1f             	xor    $0x1f,%eax
  8042d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8042d5:	75 51                	jne    804328 <__umoddi3+0x98>
  8042d7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  8042da:	0f 87 e8 00 00 00    	ja     8043c8 <__umoddi3+0x138>
  8042e0:	89 f2                	mov    %esi,%edx
  8042e2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8042e5:	29 ce                	sub    %ecx,%esi
  8042e7:	19 fa                	sbb    %edi,%edx
  8042e9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8042ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ef:	83 c4 20             	add    $0x20,%esp
  8042f2:	5e                   	pop    %esi
  8042f3:	5f                   	pop    %edi
  8042f4:	5d                   	pop    %ebp
  8042f5:	c3                   	ret    
  8042f6:	66 90                	xchg   %ax,%ax
  8042f8:	85 c9                	test   %ecx,%ecx
  8042fa:	75 0b                	jne    804307 <__umoddi3+0x77>
  8042fc:	b8 01 00 00 00       	mov    $0x1,%eax
  804301:	31 d2                	xor    %edx,%edx
  804303:	f7 f1                	div    %ecx
  804305:	89 c1                	mov    %eax,%ecx
  804307:	89 f0                	mov    %esi,%eax
  804309:	31 d2                	xor    %edx,%edx
  80430b:	f7 f1                	div    %ecx
  80430d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804310:	eb a5                	jmp    8042b7 <__umoddi3+0x27>
  804312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804318:	89 f2                	mov    %esi,%edx
  80431a:	83 c4 20             	add    $0x20,%esp
  80431d:	5e                   	pop    %esi
  80431e:	5f                   	pop    %edi
  80431f:	5d                   	pop    %ebp
  804320:	c3                   	ret    
  804321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804328:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80432c:	89 f2                	mov    %esi,%edx
  80432e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804331:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804338:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80433b:	d3 e7                	shl    %cl,%edi
  80433d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804340:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804344:	d3 e8                	shr    %cl,%eax
  804346:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80434a:	09 f8                	or     %edi,%eax
  80434c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80434f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804352:	d3 e0                	shl    %cl,%eax
  804354:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804358:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80435b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80435e:	d3 ea                	shr    %cl,%edx
  804360:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804364:	d3 e6                	shl    %cl,%esi
  804366:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80436a:	d3 e8                	shr    %cl,%eax
  80436c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804370:	09 f0                	or     %esi,%eax
  804372:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804375:	f7 75 e4             	divl   -0x1c(%ebp)
  804378:	d3 e6                	shl    %cl,%esi
  80437a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80437d:	89 d6                	mov    %edx,%esi
  80437f:	f7 65 f4             	mull   -0xc(%ebp)
  804382:	89 d7                	mov    %edx,%edi
  804384:	89 c2                	mov    %eax,%edx
  804386:	39 fe                	cmp    %edi,%esi
  804388:	89 f9                	mov    %edi,%ecx
  80438a:	72 30                	jb     8043bc <__umoddi3+0x12c>
  80438c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80438f:	72 27                	jb     8043b8 <__umoddi3+0x128>
  804391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804394:	29 d0                	sub    %edx,%eax
  804396:	19 ce                	sbb    %ecx,%esi
  804398:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80439c:	89 f2                	mov    %esi,%edx
  80439e:	d3 e8                	shr    %cl,%eax
  8043a0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8043a4:	d3 e2                	shl    %cl,%edx
  8043a6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043aa:	09 d0                	or     %edx,%eax
  8043ac:	89 f2                	mov    %esi,%edx
  8043ae:	d3 ea                	shr    %cl,%edx
  8043b0:	83 c4 20             	add    $0x20,%esp
  8043b3:	5e                   	pop    %esi
  8043b4:	5f                   	pop    %edi
  8043b5:	5d                   	pop    %ebp
  8043b6:	c3                   	ret    
  8043b7:	90                   	nop
  8043b8:	39 fe                	cmp    %edi,%esi
  8043ba:	75 d5                	jne    804391 <__umoddi3+0x101>
  8043bc:	89 f9                	mov    %edi,%ecx
  8043be:	89 c2                	mov    %eax,%edx
  8043c0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  8043c3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8043c6:	eb c9                	jmp    804391 <__umoddi3+0x101>
  8043c8:	39 f7                	cmp    %esi,%edi
  8043ca:	0f 82 10 ff ff ff    	jb     8042e0 <__umoddi3+0x50>
  8043d0:	e9 17 ff ff ff       	jmp    8042ec <__umoddi3+0x5c>
