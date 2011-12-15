
obj/user/pingpong:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
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
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003d:	e8 2b 13 00 00       	call   80136d <_Z4forkv>
  800042:	89 c3                	mov    %eax,%ebx
  800044:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800047:	85 c0                	test   %eax,%eax
  800049:	74 3c                	je     800087 <_Z5umainiPPc+0x53>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004b:	e8 78 0c 00 00       	call   800cc8 <_Z12sys_getenvidv>
  800050:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800054:	89 44 24 04          	mov    %eax,0x4(%esp)
  800058:	c7 04 24 e0 43 80 00 	movl   $0x8043e0,(%esp)
  80005f:	e8 c6 01 00 00       	call   80022a <_Z7cprintfPKcz>
		ipc_send(who, 0, 0, 0);
  800064:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80006b:	00 
  80006c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800073:	00 
  800074:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007b:	00 
  80007c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 68 16 00 00       	call   8016ef <_Z8ipc_sendijPvi>
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800087:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  80008a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800099:	00 
  80009a:	89 3c 24             	mov    %edi,(%esp)
  80009d:	e8 be 15 00 00       	call   801660 <_Z8ipc_recvPiPvS_>
  8000a2:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000a4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000a7:	e8 1c 0c 00 00       	call   800cc8 <_Z12sys_getenvidv>
  8000ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b8:	c7 04 24 f6 43 80 00 	movl   $0x8043f6,(%esp)
  8000bf:	e8 66 01 00 00       	call   80022a <_Z7cprintfPKcz>
		if (i == 10)
  8000c4:	83 fb 0a             	cmp    $0xa,%ebx
  8000c7:	74 27                	je     8000f0 <_Z5umainiPPc+0xbc>
			return;
		i++;
  8000c9:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d3:	00 
  8000d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000db:	00 
  8000dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e3:	89 04 24             	mov    %eax,(%esp)
  8000e6:	e8 04 16 00 00       	call   8016ef <_Z8ipc_sendijPvi>
		if (i == 10)
  8000eb:	83 fb 0a             	cmp    $0xa,%ebx
  8000ee:	75 9a                	jne    80008a <_Z5umainiPPc+0x56>
			return;
	}

}
  8000f0:	83 c4 2c             	add    $0x2c,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	57                   	push   %edi
  8000fc:	56                   	push   %esi
  8000fd:	53                   	push   %ebx
  8000fe:	83 ec 1c             	sub    $0x1c,%esp
  800101:	8b 7d 08             	mov    0x8(%ebp),%edi
  800104:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800107:	e8 bc 0b 00 00       	call   800cc8 <_Z12sys_getenvidv>
  80010c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800111:	6b c0 78             	imul   $0x78,%eax,%eax
  800114:	05 00 00 00 ef       	add    $0xef000000,%eax
  800119:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011e:	85 ff                	test   %edi,%edi
  800120:	7e 07                	jle    800129 <libmain+0x31>
		binaryname = argv[0];
  800122:	8b 06                	mov    (%esi),%eax
  800124:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800129:	b8 b6 4f 80 00       	mov    $0x804fb6,%eax
  80012e:	3d b6 4f 80 00       	cmp    $0x804fb6,%eax
  800133:	76 0f                	jbe    800144 <libmain+0x4c>
  800135:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800137:	83 eb 04             	sub    $0x4,%ebx
  80013a:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80013c:	81 fb b6 4f 80 00    	cmp    $0x804fb6,%ebx
  800142:	77 f3                	ja     800137 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800144:	89 74 24 04          	mov    %esi,0x4(%esp)
  800148:	89 3c 24             	mov    %edi,(%esp)
  80014b:	e8 e4 fe ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800150:	e8 0b 00 00 00       	call   800160 <_Z4exitv>
}
  800155:	83 c4 1c             	add    $0x1c,%esp
  800158:	5b                   	pop    %ebx
  800159:	5e                   	pop    %esi
  80015a:	5f                   	pop    %edi
  80015b:	5d                   	pop    %ebp
  80015c:	c3                   	ret    
  80015d:	00 00                	add    %al,(%eax)
	...

00800160 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800166:	e8 b3 18 00 00       	call   801a1e <_Z9close_allv>
	sys_env_destroy(0);
  80016b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800172:	e8 f4 0a 00 00       	call   800c6b <_Z15sys_env_destroyi>
}
  800177:	c9                   	leave  
  800178:	c3                   	ret    
  800179:	00 00                	add    %al,(%eax)
	...

0080017c <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
  800182:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800185:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800188:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  80018b:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  80018d:	8b 03                	mov    (%ebx),%eax
  80018f:	8b 55 08             	mov    0x8(%ebp),%edx
  800192:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800196:	83 c0 01             	add    $0x1,%eax
  800199:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80019b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a0:	75 19                	jne    8001bb <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8001a2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001a9:	00 
  8001aa:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ad:	89 04 24             	mov    %eax,(%esp)
  8001b0:	e8 4f 0a 00 00       	call   800c04 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8001b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001bb:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001bf:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001c2:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001c5:	89 ec                	mov    %ebp,%esp
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    

008001c9 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d9:	00 00 00 
	b.cnt = 0;
  8001dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8001e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fe:	c7 04 24 7c 01 80 00 	movl   $0x80017c,(%esp)
  800205:	e8 ad 01 00 00       	call   8003b7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80020a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800210:	89 44 24 04          	mov    %eax,0x4(%esp)
  800214:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021a:	89 04 24             	mov    %eax,(%esp)
  80021d:	e8 e2 09 00 00       	call   800c04 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800222:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800228:	c9                   	leave  
  800229:	c3                   	ret    

0080022a <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800230:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800233:	89 44 24 04          	mov    %eax,0x4(%esp)
  800237:	8b 45 08             	mov    0x8(%ebp),%eax
  80023a:	89 04 24             	mov    %eax,(%esp)
  80023d:	e8 87 ff ff ff       	call   8001c9 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800242:	c9                   	leave  
  800243:	c3                   	ret    
	...

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
  800323:	0f be 80 13 44 80 00 	movsbl 0x804413(%eax),%eax
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
  800530:	c7 44 24 08 2b 44 80 	movl   $0x80442b,0x8(%esp)
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
  800562:	ba 24 44 80 00       	mov    $0x804424,%edx
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
  800765:	c7 44 24 08 3d 48 80 	movl   $0x80483d,0x8(%esp)
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
  800cb6:	e8 01 33 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  800d7d:	e8 3a 32 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  800ddb:	e8 dc 31 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  800e39:	e8 7e 31 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  800e97:	e8 20 31 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  800ef5:	e8 c2 30 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  800f53:	e8 64 30 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  800fb1:	e8 06 30 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  801046:	e8 71 2f 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  8012b4:	e8 03 2d 00 00       	call   803fbc <_Z6_panicPKciS0_z>
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
  80131e:	e8 99 2c 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  801356:	e8 61 2c 00 00       	call   803fbc <_Z6_panicPKciS0_z>
    resume(utf);
  80135b:	89 1c 24             	mov    %ebx,(%esp)
  80135e:	e8 fd 2d 00 00       	call   804160 <resume>
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
  80137d:	e8 09 2d 00 00       	call   80408b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
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
  8013ae:	e8 09 2c 00 00       	call   803fbc <_Z6_panicPKciS0_z>
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
  801441:	e8 76 2b 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  80147d:	e8 3a 2b 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  8014b1:	e8 06 2b 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  8014d0:	e8 b6 2b 00 00       	call   80408b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
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
  801501:	e8 b6 2a 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  8015d9:	e8 de 29 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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
  801615:	e8 a2 29 00 00       	call   803fbc <_Z6_panicPKciS0_z>
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
  801649:	e8 6e 29 00 00       	call   803fbc <_Z6_panicPKciS0_z>

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

00801660 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	83 ec 10             	sub    $0x10,%esp
  801668:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  801671:	85 c0                	test   %eax,%eax
  801673:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  801678:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80167b:	89 04 24             	mov    %eax,(%esp)
  80167e:	e8 78 f9 ff ff       	call   800ffb <_Z12sys_ipc_recvPv>
  801683:	85 c0                	test   %eax,%eax
  801685:	79 16                	jns    80169d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  801687:	85 db                	test   %ebx,%ebx
  801689:	74 06                	je     801691 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80168b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  801691:	85 f6                	test   %esi,%esi
  801693:	74 53                	je     8016e8 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  801695:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80169b:	eb 4b                	jmp    8016e8 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80169d:	85 db                	test   %ebx,%ebx
  80169f:	74 17                	je     8016b8 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  8016a1:	e8 22 f6 ff ff       	call   800cc8 <_Z12sys_getenvidv>
  8016a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016ab:	6b c0 78             	imul   $0x78,%eax,%eax
  8016ae:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  8016b3:	8b 40 60             	mov    0x60(%eax),%eax
  8016b6:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  8016b8:	85 f6                	test   %esi,%esi
  8016ba:	74 17                	je     8016d3 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  8016bc:	e8 07 f6 ff ff       	call   800cc8 <_Z12sys_getenvidv>
  8016c1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016c6:	6b c0 78             	imul   $0x78,%eax,%eax
  8016c9:	05 00 00 00 ef       	add    $0xef000000,%eax
  8016ce:	8b 40 70             	mov    0x70(%eax),%eax
  8016d1:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  8016d3:	e8 f0 f5 ff ff       	call   800cc8 <_Z12sys_getenvidv>
  8016d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016dd:	6b c0 78             	imul   $0x78,%eax,%eax
  8016e0:	05 08 00 00 ef       	add    $0xef000008,%eax
  8016e5:	8b 40 60             	mov    0x60(%eax),%eax

}
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	5b                   	pop    %ebx
  8016ec:	5e                   	pop    %esi
  8016ed:	5d                   	pop    %ebp
  8016ee:	c3                   	ret    

008016ef <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	57                   	push   %edi
  8016f3:	56                   	push   %esi
  8016f4:	53                   	push   %ebx
  8016f5:	83 ec 1c             	sub    $0x1c,%esp
  8016f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8016fb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  801701:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  801703:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  801708:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  80170b:	8b 45 14             	mov    0x14(%ebp),%eax
  80170e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801712:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801716:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80171a:	89 34 24             	mov    %esi,(%esp)
  80171d:	e8 a1 f8 ff ff       	call   800fc3 <_Z16sys_ipc_try_sendijPvi>
  801722:	85 c0                	test   %eax,%eax
  801724:	79 31                	jns    801757 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  801726:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801729:	75 0c                	jne    801737 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  80172b:	90                   	nop
  80172c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801730:	e8 c7 f5 ff ff       	call   800cfc <_Z9sys_yieldv>
  801735:	eb d4                	jmp    80170b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  801737:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80173b:	c7 44 24 08 07 48 80 	movl   $0x804807,0x8(%esp)
  801742:	00 
  801743:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  80174a:	00 
  80174b:	c7 04 24 14 48 80 00 	movl   $0x804814,(%esp)
  801752:	e8 65 28 00 00       	call   803fbc <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  801757:	83 c4 1c             	add    $0x1c,%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5e                   	pop    %esi
  80175c:	5f                   	pop    %edi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    
	...

00801760 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801763:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801768:	75 11                	jne    80177b <_ZL8fd_validPK2Fd+0x1b>
  80176a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80176f:	76 0a                	jbe    80177b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801771:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801776:	0f 96 c0             	setbe  %al
  801779:	eb 05                	jmp    801780 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	53                   	push   %ebx
  801786:	83 ec 14             	sub    $0x14,%esp
  801789:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80178b:	e8 d0 ff ff ff       	call   801760 <_ZL8fd_validPK2Fd>
  801790:	84 c0                	test   %al,%al
  801792:	75 24                	jne    8017b8 <_ZL9fd_isopenPK2Fd+0x36>
  801794:	c7 44 24 0c 1e 48 80 	movl   $0x80481e,0xc(%esp)
  80179b:	00 
  80179c:	c7 44 24 08 2b 48 80 	movl   $0x80482b,0x8(%esp)
  8017a3:	00 
  8017a4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8017ab:	00 
  8017ac:	c7 04 24 40 48 80 00 	movl   $0x804840,(%esp)
  8017b3:	e8 04 28 00 00       	call   803fbc <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  8017b8:	89 d8                	mov    %ebx,%eax
  8017ba:	c1 e8 16             	shr    $0x16,%eax
  8017bd:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c9:	f6 c2 01             	test   $0x1,%dl
  8017cc:	74 0d                	je     8017db <_ZL9fd_isopenPK2Fd+0x59>
  8017ce:	c1 eb 0c             	shr    $0xc,%ebx
  8017d1:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  8017d8:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  8017db:	83 c4 14             	add    $0x14,%esp
  8017de:	5b                   	pop    %ebx
  8017df:	5d                   	pop    %ebp
  8017e0:	c3                   	ret    

008017e1 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 08             	sub    $0x8,%esp
  8017e7:	89 1c 24             	mov    %ebx,(%esp)
  8017ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8017f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017f4:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8017f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8017fb:	77 18                	ja     801815 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  8017fd:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801803:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801806:	84 c0                	test   %al,%al
  801808:	74 21                	je     80182b <_Z9fd_lookupiPP2Fdb+0x4a>
  80180a:	89 d8                	mov    %ebx,%eax
  80180c:	e8 71 ff ff ff       	call   801782 <_ZL9fd_isopenPK2Fd>
  801811:	84 c0                	test   %al,%al
  801813:	75 16                	jne    80182b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801815:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80181b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801820:	8b 1c 24             	mov    (%esp),%ebx
  801823:	8b 74 24 04          	mov    0x4(%esp),%esi
  801827:	89 ec                	mov    %ebp,%esp
  801829:	5d                   	pop    %ebp
  80182a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80182b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80182d:	b8 00 00 00 00       	mov    $0x0,%eax
  801832:	eb ec                	jmp    801820 <_Z9fd_lookupiPP2Fdb+0x3f>

00801834 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	53                   	push   %ebx
  801838:	83 ec 14             	sub    $0x14,%esp
  80183b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80183e:	89 d8                	mov    %ebx,%eax
  801840:	e8 1b ff ff ff       	call   801760 <_ZL8fd_validPK2Fd>
  801845:	84 c0                	test   %al,%al
  801847:	75 24                	jne    80186d <_Z6fd2numP2Fd+0x39>
  801849:	c7 44 24 0c 1e 48 80 	movl   $0x80481e,0xc(%esp)
  801850:	00 
  801851:	c7 44 24 08 2b 48 80 	movl   $0x80482b,0x8(%esp)
  801858:	00 
  801859:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801860:	00 
  801861:	c7 04 24 40 48 80 00 	movl   $0x804840,(%esp)
  801868:	e8 4f 27 00 00       	call   803fbc <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80186d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801873:	c1 e8 0c             	shr    $0xc,%eax
}
  801876:	83 c4 14             	add    $0x14,%esp
  801879:	5b                   	pop    %ebx
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    

0080187c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	89 04 24             	mov    %eax,(%esp)
  801888:	e8 a7 ff ff ff       	call   801834 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  80188d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801892:	c1 e0 0c             	shl    $0xc,%eax
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	57                   	push   %edi
  80189b:	56                   	push   %esi
  80189c:	53                   	push   %ebx
  80189d:	83 ec 2c             	sub    $0x2c,%esp
  8018a0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8018a3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8018a8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8018ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018b2:	00 
  8018b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018b7:	89 1c 24             	mov    %ebx,(%esp)
  8018ba:	e8 22 ff ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  8018bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c2:	e8 bb fe ff ff       	call   801782 <_ZL9fd_isopenPK2Fd>
  8018c7:	84 c0                	test   %al,%al
  8018c9:	75 0c                	jne    8018d7 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  8018cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ce:	89 07                	mov    %eax,(%edi)
			return 0;
  8018d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d5:	eb 13                	jmp    8018ea <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8018d7:	83 c3 01             	add    $0x1,%ebx
  8018da:	83 fb 20             	cmp    $0x20,%ebx
  8018dd:	75 cc                	jne    8018ab <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018df:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  8018e5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8018ea:	83 c4 2c             	add    $0x2c,%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5f                   	pop    %edi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	53                   	push   %ebx
  8018f6:	83 ec 14             	sub    $0x14,%esp
  8018f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  8018ff:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801904:	39 0d 04 50 80 00    	cmp    %ecx,0x805004
  80190a:	75 16                	jne    801922 <_Z10dev_lookupiPP3Dev+0x30>
  80190c:	eb 06                	jmp    801914 <_Z10dev_lookupiPP3Dev+0x22>
  80190e:	39 0a                	cmp    %ecx,(%edx)
  801910:	75 10                	jne    801922 <_Z10dev_lookupiPP3Dev+0x30>
  801912:	eb 05                	jmp    801919 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801914:	ba 04 50 80 00       	mov    $0x805004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801919:	89 13                	mov    %edx,(%ebx)
			return 0;
  80191b:	b8 00 00 00 00       	mov    $0x0,%eax
  801920:	eb 35                	jmp    801957 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801922:	83 c0 01             	add    $0x1,%eax
  801925:	8b 14 85 ac 48 80 00 	mov    0x8048ac(,%eax,4),%edx
  80192c:	85 d2                	test   %edx,%edx
  80192e:	75 de                	jne    80190e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801930:	a1 00 60 80 00       	mov    0x806000,%eax
  801935:	8b 40 04             	mov    0x4(%eax),%eax
  801938:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80193c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801940:	c7 04 24 68 48 80 00 	movl   $0x804868,(%esp)
  801947:	e8 de e8 ff ff       	call   80022a <_Z7cprintfPKcz>
	*dev = 0;
  80194c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801952:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801957:	83 c4 14             	add    $0x14,%esp
  80195a:	5b                   	pop    %ebx
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    

0080195d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
  801962:	83 ec 20             	sub    $0x20,%esp
  801965:	8b 75 08             	mov    0x8(%ebp),%esi
  801968:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80196c:	89 34 24             	mov    %esi,(%esp)
  80196f:	e8 c0 fe ff ff       	call   801834 <_Z6fd2numP2Fd>
  801974:	0f b6 d3             	movzbl %bl,%edx
  801977:	89 54 24 08          	mov    %edx,0x8(%esp)
  80197b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80197e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801982:	89 04 24             	mov    %eax,(%esp)
  801985:	e8 57 fe ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 05                	js     801993 <_Z8fd_closeP2Fdb+0x36>
  80198e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801991:	74 0c                	je     80199f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801993:	80 fb 01             	cmp    $0x1,%bl
  801996:	19 db                	sbb    %ebx,%ebx
  801998:	f7 d3                	not    %ebx
  80199a:	83 e3 fd             	and    $0xfffffffd,%ebx
  80199d:	eb 3d                	jmp    8019dc <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80199f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a6:	8b 06                	mov    (%esi),%eax
  8019a8:	89 04 24             	mov    %eax,(%esp)
  8019ab:	e8 42 ff ff ff       	call   8018f2 <_Z10dev_lookupiPP3Dev>
  8019b0:	89 c3                	mov    %eax,%ebx
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 16                	js     8019cc <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  8019b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8019bc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	74 07                	je     8019cc <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  8019c5:	89 34 24             	mov    %esi,(%esp)
  8019c8:	ff d0                	call   *%eax
  8019ca:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8019cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019d7:	e8 11 f4 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
	return r;
}
  8019dc:	89 d8                	mov    %ebx,%eax
  8019de:	83 c4 20             	add    $0x20,%esp
  8019e1:	5b                   	pop    %ebx
  8019e2:	5e                   	pop    %esi
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    

008019e5 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8019eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8019f2:	00 
  8019f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	89 04 24             	mov    %eax,(%esp)
  801a00:	e8 dc fd ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 13                	js     801a1c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801a09:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a10:	00 
  801a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a14:	89 04 24             	mov    %eax,(%esp)
  801a17:	e8 41 ff ff ff       	call   80195d <_Z8fd_closeP2Fdb>
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <_Z9close_allv>:

void
close_all(void)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	53                   	push   %ebx
  801a22:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801a25:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a2a:	89 1c 24             	mov    %ebx,(%esp)
  801a2d:	e8 b3 ff ff ff       	call   8019e5 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801a32:	83 c3 01             	add    $0x1,%ebx
  801a35:	83 fb 20             	cmp    $0x20,%ebx
  801a38:	75 f0                	jne    801a2a <_Z9close_allv+0xc>
		close(i);
}
  801a3a:	83 c4 14             	add    $0x14,%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    

00801a40 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 48             	sub    $0x48,%esp
  801a46:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a49:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a4c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a4f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801a52:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801a59:	00 
  801a5a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	89 04 24             	mov    %eax,(%esp)
  801a67:	e8 75 fd ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  801a6c:	89 c3                	mov    %eax,%ebx
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	0f 88 ce 00 00 00    	js     801b44 <_Z3dupii+0x104>
  801a76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a7d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  801a7e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801a81:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801a85:	89 34 24             	mov    %esi,(%esp)
  801a88:	e8 54 fd ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  801a8d:	89 c3                	mov    %eax,%ebx
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	0f 89 bc 00 00 00    	jns    801b53 <_Z3dupii+0x113>
  801a97:	e9 a8 00 00 00       	jmp    801b44 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801a9c:	89 d8                	mov    %ebx,%eax
  801a9e:	c1 e8 0c             	shr    $0xc,%eax
  801aa1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801aa8:	f6 c2 01             	test   $0x1,%dl
  801aab:	74 32                	je     801adf <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801aad:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801ab4:	25 07 0e 00 00       	and    $0xe07,%eax
  801ab9:	89 44 24 10          	mov    %eax,0x10(%esp)
  801abd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ac1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ac8:	00 
  801ac9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801acd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad4:	e8 b6 f2 ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
  801ad9:	89 c3                	mov    %eax,%ebx
  801adb:	85 c0                	test   %eax,%eax
  801add:	78 3e                	js     801b1d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801adf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ae2:	89 c2                	mov    %eax,%edx
  801ae4:	c1 ea 0c             	shr    $0xc,%edx
  801ae7:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  801aee:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801af4:	89 54 24 10          	mov    %edx,0x10(%esp)
  801af8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801afb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801aff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b06:	00 
  801b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b12:	e8 78 f2 ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
  801b17:	89 c3                	mov    %eax,%ebx
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	79 25                	jns    801b42 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2b:	e8 bd f2 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801b30:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b3b:	e8 ad f2 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
	return r;
  801b40:	eb 02                	jmp    801b44 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801b42:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b49:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b4f:	89 ec                	mov    %ebp,%esp
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801b53:	89 34 24             	mov    %esi,(%esp)
  801b56:	e8 8a fe ff ff       	call   8019e5 <_Z5closei>

	ova = fd2data(oldfd);
  801b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b5e:	89 04 24             	mov    %eax,(%esp)
  801b61:	e8 16 fd ff ff       	call   80187c <_Z7fd2dataP2Fd>
  801b66:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b6b:	89 04 24             	mov    %eax,(%esp)
  801b6e:	e8 09 fd ff ff       	call   80187c <_Z7fd2dataP2Fd>
  801b73:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801b75:	89 d8                	mov    %ebx,%eax
  801b77:	c1 e8 16             	shr    $0x16,%eax
  801b7a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801b81:	a8 01                	test   $0x1,%al
  801b83:	0f 85 13 ff ff ff    	jne    801a9c <_Z3dupii+0x5c>
  801b89:	e9 51 ff ff ff       	jmp    801adf <_Z3dupii+0x9f>

00801b8e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	53                   	push   %ebx
  801b92:	83 ec 24             	sub    $0x24,%esp
  801b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801b98:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801b9f:	00 
  801ba0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba7:	89 1c 24             	mov    %ebx,(%esp)
  801baa:	e8 32 fc ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	78 5f                	js     801c12 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	89 04 24             	mov    %eax,(%esp)
  801bc2:	e8 2b fd ff ff       	call   8018f2 <_Z10dev_lookupiPP3Dev>
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	79 4d                	jns    801c18 <_Z4readiPvj+0x8a>
  801bcb:	eb 45                	jmp    801c12 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801bcd:	a1 00 60 80 00       	mov    0x806000,%eax
  801bd2:	8b 40 04             	mov    0x4(%eax),%eax
  801bd5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdd:	c7 04 24 49 48 80 00 	movl   $0x804849,(%esp)
  801be4:	e8 41 e6 ff ff       	call   80022a <_Z7cprintfPKcz>
		return -E_INVAL;
  801be9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bee:	eb 22                	jmp    801c12 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf3:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801bf6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801bfb:	85 d2                	test   %edx,%edx
  801bfd:	74 13                	je     801c12 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801bff:	8b 45 10             	mov    0x10(%ebp),%eax
  801c02:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0d:	89 0c 24             	mov    %ecx,(%esp)
  801c10:	ff d2                	call   *%edx
}
  801c12:	83 c4 24             	add    $0x24,%esp
  801c15:	5b                   	pop    %ebx
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c18:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c1b:	8b 41 08             	mov    0x8(%ecx),%eax
  801c1e:	83 e0 03             	and    $0x3,%eax
  801c21:	83 f8 01             	cmp    $0x1,%eax
  801c24:	75 ca                	jne    801bf0 <_Z4readiPvj+0x62>
  801c26:	eb a5                	jmp    801bcd <_Z4readiPvj+0x3f>

00801c28 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	57                   	push   %edi
  801c2c:	56                   	push   %esi
  801c2d:	53                   	push   %ebx
  801c2e:	83 ec 1c             	sub    $0x1c,%esp
  801c31:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c34:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801c37:	85 f6                	test   %esi,%esi
  801c39:	74 2f                	je     801c6a <_Z5readniPvj+0x42>
  801c3b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c40:	89 f0                	mov    %esi,%eax
  801c42:	29 d8                	sub    %ebx,%eax
  801c44:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c48:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	89 04 24             	mov    %eax,(%esp)
  801c55:	e8 34 ff ff ff       	call   801b8e <_Z4readiPvj>
		if (m < 0)
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 13                	js     801c71 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	74 0d                	je     801c6f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801c62:	01 c3                	add    %eax,%ebx
  801c64:	39 de                	cmp    %ebx,%esi
  801c66:	77 d8                	ja     801c40 <_Z5readniPvj+0x18>
  801c68:	eb 05                	jmp    801c6f <_Z5readniPvj+0x47>
  801c6a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801c6f:	89 d8                	mov    %ebx,%eax
}
  801c71:	83 c4 1c             	add    $0x1c,%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5f                   	pop    %edi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    

00801c79 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801c7f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c86:	00 
  801c87:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	89 04 24             	mov    %eax,(%esp)
  801c94:	e8 48 fb ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 3c                	js     801cd9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801ca7:	8b 00                	mov    (%eax),%eax
  801ca9:	89 04 24             	mov    %eax,(%esp)
  801cac:	e8 41 fc ff ff       	call   8018f2 <_Z10dev_lookupiPP3Dev>
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	79 26                	jns    801cdb <_Z5writeiPKvj+0x62>
  801cb5:	eb 22                	jmp    801cd9 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cba:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  801cbd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801cc2:	85 c9                	test   %ecx,%ecx
  801cc4:	74 13                	je     801cd9 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801cc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd4:	89 14 24             	mov    %edx,(%esp)
  801cd7:	ff d1                	call   *%ecx
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801cdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  801cde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801ce3:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801ce7:	74 f0                	je     801cd9 <_Z5writeiPKvj+0x60>
  801ce9:	eb cc                	jmp    801cb7 <_Z5writeiPKvj+0x3e>

00801ceb <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801cf1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801cf8:	00 
  801cf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	89 04 24             	mov    %eax,(%esp)
  801d06:	e8 d6 fa ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	78 0e                	js     801d1d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  801d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d15:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	53                   	push   %ebx
  801d23:	83 ec 24             	sub    $0x24,%esp
  801d26:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801d29:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d30:	00 
  801d31:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d38:	89 1c 24             	mov    %ebx,(%esp)
  801d3b:	e8 a1 fa ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  801d40:	85 c0                	test   %eax,%eax
  801d42:	78 58                	js     801d9c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801d4e:	8b 00                	mov    (%eax),%eax
  801d50:	89 04 24             	mov    %eax,(%esp)
  801d53:	e8 9a fb ff ff       	call   8018f2 <_Z10dev_lookupiPP3Dev>
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	79 46                	jns    801da2 <_Z9ftruncateii+0x83>
  801d5c:	eb 3e                	jmp    801d9c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801d5e:	a1 00 60 80 00       	mov    0x806000,%eax
  801d63:	8b 40 04             	mov    0x4(%eax),%eax
  801d66:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6e:	c7 04 24 88 48 80 00 	movl   $0x804888,(%esp)
  801d75:	e8 b0 e4 ff ff       	call   80022a <_Z7cprintfPKcz>
		return -E_INVAL;
  801d7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d7f:	eb 1b                	jmp    801d9c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d84:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801d87:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801d8c:	85 d2                	test   %edx,%edx
  801d8e:	74 0c                	je     801d9c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d97:	89 0c 24             	mov    %ecx,(%esp)
  801d9a:	ff d2                	call   *%edx
}
  801d9c:	83 c4 24             	add    $0x24,%esp
  801d9f:	5b                   	pop    %ebx
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801da2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801da5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801da9:	75 d6                	jne    801d81 <_Z9ftruncateii+0x62>
  801dab:	eb b1                	jmp    801d5e <_Z9ftruncateii+0x3f>

00801dad <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	53                   	push   %ebx
  801db1:	83 ec 24             	sub    $0x24,%esp
  801db4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801db7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801dbe:	00 
  801dbf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	89 04 24             	mov    %eax,(%esp)
  801dcc:	e8 10 fa ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	78 3e                	js     801e13 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801ddf:	8b 00                	mov    (%eax),%eax
  801de1:	89 04 24             	mov    %eax,(%esp)
  801de4:	e8 09 fb ff ff       	call   8018f2 <_Z10dev_lookupiPP3Dev>
  801de9:	85 c0                	test   %eax,%eax
  801deb:	79 2c                	jns    801e19 <_Z5fstatiP4Stat+0x6c>
  801ded:	eb 24                	jmp    801e13 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801def:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801df2:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801df9:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801e00:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801e06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0d:	89 04 24             	mov    %eax,(%esp)
  801e10:	ff 52 14             	call   *0x14(%edx)
}
  801e13:	83 c4 24             	add    $0x24,%esp
  801e16:	5b                   	pop    %ebx
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801e19:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  801e1c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801e21:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801e25:	75 c8                	jne    801def <_Z5fstatiP4Stat+0x42>
  801e27:	eb ea                	jmp    801e13 <_Z5fstatiP4Stat+0x66>

00801e29 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 18             	sub    $0x18,%esp
  801e2f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e32:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e35:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e3c:	00 
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	89 04 24             	mov    %eax,(%esp)
  801e43:	e8 d6 09 00 00       	call   80281e <_Z4openPKci>
  801e48:	89 c3                	mov    %eax,%ebx
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	78 1b                	js     801e69 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e55:	89 1c 24             	mov    %ebx,(%esp)
  801e58:	e8 50 ff ff ff       	call   801dad <_Z5fstatiP4Stat>
  801e5d:	89 c6                	mov    %eax,%esi
	close(fd);
  801e5f:	89 1c 24             	mov    %ebx,(%esp)
  801e62:	e8 7e fb ff ff       	call   8019e5 <_Z5closei>
	return r;
  801e67:	89 f3                	mov    %esi,%ebx
}
  801e69:	89 d8                	mov    %ebx,%eax
  801e6b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e6e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e71:	89 ec                	mov    %ebp,%esp
  801e73:	5d                   	pop    %ebp
  801e74:	c3                   	ret    
	...

00801e80 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801e83:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801e88:	85 d2                	test   %edx,%edx
  801e8a:	78 33                	js     801ebf <_ZL10inode_dataP5Inodei+0x3f>
  801e8c:	3b 50 08             	cmp    0x8(%eax),%edx
  801e8f:	7d 2e                	jge    801ebf <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801e91:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801e97:	85 d2                	test   %edx,%edx
  801e99:	0f 49 ca             	cmovns %edx,%ecx
  801e9c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  801e9f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801ea3:	c1 e1 0c             	shl    $0xc,%ecx
  801ea6:	89 d0                	mov    %edx,%eax
  801ea8:	c1 f8 1f             	sar    $0x1f,%eax
  801eab:	c1 e8 14             	shr    $0x14,%eax
  801eae:	01 c2                	add    %eax,%edx
  801eb0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801eb6:	29 c2                	sub    %eax,%edx
  801eb8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801ebf:	89 c8                	mov    %ecx,%eax
  801ec1:	5d                   	pop    %ebp
  801ec2:	c3                   	ret    

00801ec3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801ec6:	8b 48 08             	mov    0x8(%eax),%ecx
  801ec9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801ecc:	8b 00                	mov    (%eax),%eax
  801ece:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801ed1:	c7 82 80 00 00 00 04 	movl   $0x805004,0x80(%edx)
  801ed8:	50 80 00 
}
  801edb:	5d                   	pop    %ebp
  801edc:	c3                   	ret    

00801edd <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801ee3:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	74 08                	je     801ef5 <_ZL9get_inodei+0x18>
  801eed:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801ef3:	7e 20                	jle    801f15 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801ef5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ef9:	c7 44 24 08 c0 48 80 	movl   $0x8048c0,0x8(%esp)
  801f00:	00 
  801f01:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801f08:	00 
  801f09:	c7 04 24 d6 48 80 00 	movl   $0x8048d6,(%esp)
  801f10:	e8 a7 20 00 00       	call   803fbc <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801f15:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801f1b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801f21:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801f27:	85 d2                	test   %edx,%edx
  801f29:	0f 48 d1             	cmovs  %ecx,%edx
  801f2c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801f2f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801f36:	c1 e0 0c             	shl    $0xc,%eax
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	56                   	push   %esi
  801f3f:	53                   	push   %ebx
  801f40:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801f43:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801f49:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801f4c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801f52:	76 20                	jbe    801f74 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801f54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f58:	c7 44 24 08 fc 48 80 	movl   $0x8048fc,0x8(%esp)
  801f5f:	00 
  801f60:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801f67:	00 
  801f68:	c7 04 24 d6 48 80 00 	movl   $0x8048d6,(%esp)
  801f6f:	e8 48 20 00 00       	call   803fbc <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801f74:	83 fe 01             	cmp    $0x1,%esi
  801f77:	7e 08                	jle    801f81 <_ZL10bcache_ipcPvi+0x46>
  801f79:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801f7f:	7d 12                	jge    801f93 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801f81:	89 f3                	mov    %esi,%ebx
  801f83:	c1 e3 04             	shl    $0x4,%ebx
  801f86:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801f88:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801f8e:	c1 e6 0c             	shl    $0xc,%esi
  801f91:	eb 20                	jmp    801fb3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801f93:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f97:	c7 44 24 08 2c 49 80 	movl   $0x80492c,0x8(%esp)
  801f9e:	00 
  801f9f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801fa6:	00 
  801fa7:	c7 04 24 d6 48 80 00 	movl   $0x8048d6,(%esp)
  801fae:	e8 09 20 00 00       	call   803fbc <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801fb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fba:	00 
  801fbb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fc2:	00 
  801fc3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fc7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801fce:	e8 1c f7 ff ff       	call   8016ef <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801fd3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fda:	00 
  801fdb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe6:	e8 75 f6 ff ff       	call   801660 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801feb:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801fee:	74 c3                	je     801fb3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	5b                   	pop    %ebx
  801ff4:	5e                   	pop    %esi
  801ff5:	5d                   	pop    %ebp
  801ff6:	c3                   	ret    

00801ff7 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 28             	sub    $0x28,%esp
  801ffd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802000:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802003:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802006:	89 c7                	mov    %eax,%edi
  802008:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  80200a:	c7 04 24 9d 22 80 00 	movl   $0x80229d,(%esp)
  802011:	e8 75 20 00 00       	call   80408b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  802016:	89 f8                	mov    %edi,%eax
  802018:	e8 c0 fe ff ff       	call   801edd <_ZL9get_inodei>
  80201d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  80201f:	ba 02 00 00 00       	mov    $0x2,%edx
  802024:	e8 12 ff ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  802029:	85 c0                	test   %eax,%eax
  80202b:	79 08                	jns    802035 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  80202d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  802033:	eb 2e                	jmp    802063 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  802035:	85 c0                	test   %eax,%eax
  802037:	75 1c                	jne    802055 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  802039:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  80203f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  802046:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  802049:	ba 06 00 00 00       	mov    $0x6,%edx
  80204e:	89 d8                	mov    %ebx,%eax
  802050:	e8 e6 fe ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  802055:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  80205c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802063:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802066:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802069:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80206c:	89 ec                	mov    %ebp,%esp
  80206e:	5d                   	pop    %ebp
  80206f:	c3                   	ret    

00802070 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	57                   	push   %edi
  802074:	56                   	push   %esi
  802075:	53                   	push   %ebx
  802076:	83 ec 2c             	sub    $0x2c,%esp
  802079:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80207c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  80207f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  802084:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  80208a:	0f 87 3d 01 00 00    	ja     8021cd <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  802090:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802093:	8b 42 08             	mov    0x8(%edx),%eax
  802096:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  80209c:	85 c0                	test   %eax,%eax
  80209e:	0f 49 f0             	cmovns %eax,%esi
  8020a1:	c1 fe 0c             	sar    $0xc,%esi
  8020a4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  8020a6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  8020a9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  8020af:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  8020b2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8020b5:	0f 82 a6 00 00 00    	jb     802161 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  8020bb:	39 fe                	cmp    %edi,%esi
  8020bd:	0f 8d f2 00 00 00    	jge    8021b5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8020c3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  8020c7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8020ca:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8020cd:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  8020d0:	83 3e 00             	cmpl   $0x0,(%esi)
  8020d3:	75 77                	jne    80214c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8020d5:	ba 02 00 00 00       	mov    $0x2,%edx
  8020da:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8020df:	e8 57 fe ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8020e4:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  8020ea:	83 f9 02             	cmp    $0x2,%ecx
  8020ed:	7e 43                	jle    802132 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  8020ef:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8020f4:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  8020f9:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802100:	74 29                	je     80212b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802102:	e9 ce 00 00 00       	jmp    8021d5 <_ZL14inode_set_sizeP5Inodej+0x165>
  802107:	89 c7                	mov    %eax,%edi
  802109:	0f b6 10             	movzbl (%eax),%edx
  80210c:	83 c0 01             	add    $0x1,%eax
  80210f:	84 d2                	test   %dl,%dl
  802111:	74 18                	je     80212b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802113:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802116:	ba 05 00 00 00       	mov    $0x5,%edx
  80211b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802120:	e8 16 fe ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802125:	85 db                	test   %ebx,%ebx
  802127:	79 1e                	jns    802147 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802129:	eb 07                	jmp    802132 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80212b:	83 c3 01             	add    $0x1,%ebx
  80212e:	39 d9                	cmp    %ebx,%ecx
  802130:	7f d5                	jg     802107 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  802132:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802135:	8b 50 08             	mov    0x8(%eax),%edx
  802138:	e8 33 ff ff ff       	call   802070 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  80213d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802142:	e9 86 00 00 00       	jmp    8021cd <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  802147:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80214a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  80214c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  802150:	83 c6 04             	add    $0x4,%esi
  802153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802156:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  802159:	0f 8f 6e ff ff ff    	jg     8020cd <_ZL14inode_set_sizeP5Inodej+0x5d>
  80215f:	eb 54                	jmp    8021b5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  802161:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802164:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  802169:	83 f8 01             	cmp    $0x1,%eax
  80216c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  80216f:	ba 02 00 00 00       	mov    $0x2,%edx
  802174:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802179:	e8 bd fd ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  80217e:	39 f7                	cmp    %esi,%edi
  802180:	7d 24                	jge    8021a6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802182:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802185:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  802189:	8b 10                	mov    (%eax),%edx
  80218b:	85 d2                	test   %edx,%edx
  80218d:	74 0d                	je     80219c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  80218f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  802196:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  80219c:	83 eb 01             	sub    $0x1,%ebx
  80219f:	83 e8 04             	sub    $0x4,%eax
  8021a2:	39 fb                	cmp    %edi,%ebx
  8021a4:	75 e3                	jne    802189 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8021a6:	ba 05 00 00 00       	mov    $0x5,%edx
  8021ab:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8021b0:	e8 86 fd ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  8021b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8021b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021bb:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  8021be:	ba 04 00 00 00       	mov    $0x4,%edx
  8021c3:	e8 73 fd ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
	return 0;
  8021c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021cd:	83 c4 2c             	add    $0x2c,%esp
  8021d0:	5b                   	pop    %ebx
  8021d1:	5e                   	pop    %esi
  8021d2:	5f                   	pop    %edi
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  8021d5:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8021dc:	ba 05 00 00 00       	mov    $0x5,%edx
  8021e1:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8021e6:	e8 50 fd ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8021eb:	bb 02 00 00 00       	mov    $0x2,%ebx
  8021f0:	e9 52 ff ff ff       	jmp    802147 <_ZL14inode_set_sizeP5Inodej+0xd7>

008021f5 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	53                   	push   %ebx
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  8021fe:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802204:	83 e8 01             	sub    $0x1,%eax
  802207:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  80220d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802211:	75 40                	jne    802253 <_ZL11inode_closeP5Inode+0x5e>
  802213:	85 c0                	test   %eax,%eax
  802215:	75 3c                	jne    802253 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802217:	ba 02 00 00 00       	mov    $0x2,%edx
  80221c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802221:	e8 15 fd ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802226:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  80222b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  80222f:	85 d2                	test   %edx,%edx
  802231:	74 07                	je     80223a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  802233:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  80223a:	83 c0 01             	add    $0x1,%eax
  80223d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  802242:	75 e7                	jne    80222b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802244:	ba 05 00 00 00       	mov    $0x5,%edx
  802249:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80224e:	e8 e8 fc ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  802253:	ba 03 00 00 00       	mov    $0x3,%edx
  802258:	89 d8                	mov    %ebx,%eax
  80225a:	e8 dc fc ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
}
  80225f:	83 c4 04             	add    $0x4,%esp
  802262:	5b                   	pop    %ebx
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    

00802265 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	53                   	push   %ebx
  802269:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	8b 40 0c             	mov    0xc(%eax),%eax
  802272:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802275:	e8 7d fd ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  80227a:	89 c3                	mov    %eax,%ebx
  80227c:	85 c0                	test   %eax,%eax
  80227e:	78 15                	js     802295 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  802280:	8b 55 0c             	mov    0xc(%ebp),%edx
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	e8 e5 fd ff ff       	call   802070 <_ZL14inode_set_sizeP5Inodej>
  80228b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	e8 60 ff ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
	return r;
}
  802295:	89 d8                	mov    %ebx,%eax
  802297:	83 c4 14             	add    $0x14,%esp
  80229a:	5b                   	pop    %ebx
  80229b:	5d                   	pop    %ebp
  80229c:	c3                   	ret    

0080229d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	53                   	push   %ebx
  8022a1:	83 ec 14             	sub    $0x14,%esp
  8022a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  8022a7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  8022a9:	89 c2                	mov    %eax,%edx
  8022ab:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  8022b1:	78 32                	js     8022e5 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  8022b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8022b8:	e8 7e fc ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
  8022bd:	85 c0                	test   %eax,%eax
  8022bf:	74 1c                	je     8022dd <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  8022c1:	c7 44 24 08 e1 48 80 	movl   $0x8048e1,0x8(%esp)
  8022c8:	00 
  8022c9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8022d0:	00 
  8022d1:	c7 04 24 d6 48 80 00 	movl   $0x8048d6,(%esp)
  8022d8:	e8 df 1c 00 00       	call   803fbc <_Z6_panicPKciS0_z>
    resume(utf);
  8022dd:	89 1c 24             	mov    %ebx,(%esp)
  8022e0:	e8 7b 1e 00 00       	call   804160 <resume>
}
  8022e5:	83 c4 14             	add    $0x14,%esp
  8022e8:	5b                   	pop    %ebx
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    

008022eb <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	83 ec 28             	sub    $0x28,%esp
  8022f1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8022f4:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8022fa:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8022fd:	8b 43 0c             	mov    0xc(%ebx),%eax
  802300:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802303:	e8 ef fc ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  802308:	85 c0                	test   %eax,%eax
  80230a:	78 26                	js     802332 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80230c:	83 c3 10             	add    $0x10,%ebx
  80230f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802313:	89 34 24             	mov    %esi,(%esp)
  802316:	e8 2f e5 ff ff       	call   80084a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80231b:	89 f2                	mov    %esi,%edx
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	e8 9e fb ff ff       	call   801ec3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	e8 c8 fe ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
	return 0;
  80232d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802332:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802335:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802338:	89 ec                	mov    %ebp,%esp
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    

0080233c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	53                   	push   %ebx
  802340:	83 ec 24             	sub    $0x24,%esp
  802343:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802346:	89 1c 24             	mov    %ebx,(%esp)
  802349:	e8 9e 15 00 00       	call   8038ec <_Z7pagerefPv>
  80234e:	89 c2                	mov    %eax,%edx
        return 0;
  802350:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802355:	83 fa 01             	cmp    $0x1,%edx
  802358:	7f 1e                	jg     802378 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80235a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80235d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802360:	e8 92 fc ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  802365:	85 c0                	test   %eax,%eax
  802367:	78 0f                	js     802378 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802373:	e8 7d fe ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
}
  802378:	83 c4 24             	add    $0x24,%esp
  80237b:	5b                   	pop    %ebx
  80237c:	5d                   	pop    %ebp
  80237d:	c3                   	ret    

0080237e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	57                   	push   %edi
  802382:	56                   	push   %esi
  802383:	53                   	push   %ebx
  802384:	83 ec 3c             	sub    $0x3c,%esp
  802387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80238a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  80238d:	8b 43 04             	mov    0x4(%ebx),%eax
  802390:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802393:	8b 43 0c             	mov    0xc(%ebx),%eax
  802396:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802399:	e8 59 fc ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	0f 88 8c 00 00 00    	js     802432 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8023a6:	8b 53 04             	mov    0x4(%ebx),%edx
  8023a9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  8023af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8023b5:	29 d7                	sub    %edx,%edi
  8023b7:	39 f7                	cmp    %esi,%edi
  8023b9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  8023bc:	85 ff                	test   %edi,%edi
  8023be:	74 16                	je     8023d6 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8023c0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  8023c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c6:	3b 50 08             	cmp    0x8(%eax),%edx
  8023c9:	76 6f                	jbe    80243a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  8023cb:	e8 a0 fc ff ff       	call   802070 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	79 66                	jns    80243a <_ZL13devfile_writeP2FdPKvj+0xbc>
  8023d4:	eb 4e                	jmp    802424 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8023d6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  8023dc:	76 24                	jbe    802402 <_ZL13devfile_writeP2FdPKvj+0x84>
  8023de:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8023e0:	8b 53 04             	mov    0x4(%ebx),%edx
  8023e3:	81 c2 00 10 00 00    	add    $0x1000,%edx
  8023e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ec:	3b 50 08             	cmp    0x8(%eax),%edx
  8023ef:	0f 86 83 00 00 00    	jbe    802478 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  8023f5:	e8 76 fc ff ff       	call   802070 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	79 7a                	jns    802478 <_ZL13devfile_writeP2FdPKvj+0xfa>
  8023fe:	66 90                	xchg   %ax,%ax
  802400:	eb 22                	jmp    802424 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802402:	85 f6                	test   %esi,%esi
  802404:	74 1e                	je     802424 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802406:	89 f2                	mov    %esi,%edx
  802408:	03 53 04             	add    0x4(%ebx),%edx
  80240b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240e:	3b 50 08             	cmp    0x8(%eax),%edx
  802411:	0f 86 b8 00 00 00    	jbe    8024cf <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802417:	e8 54 fc ff ff       	call   802070 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80241c:	85 c0                	test   %eax,%eax
  80241e:	0f 89 ab 00 00 00    	jns    8024cf <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802427:	e8 c9 fd ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80242c:	8b 43 04             	mov    0x4(%ebx),%eax
  80242f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  802432:	83 c4 3c             	add    $0x3c,%esp
  802435:	5b                   	pop    %ebx
  802436:	5e                   	pop    %esi
  802437:	5f                   	pop    %edi
  802438:	5d                   	pop    %ebp
  802439:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80243a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80243c:	8b 53 04             	mov    0x4(%ebx),%edx
  80243f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802442:	e8 39 fa ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
  802447:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80244a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80244e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802451:	89 44 24 04          	mov    %eax,0x4(%esp)
  802455:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802458:	89 04 24             	mov    %eax,(%esp)
  80245b:	e8 07 e6 ff ff       	call   800a67 <memcpy>
        fd->fd_offset += n2;
  802460:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802463:	ba 04 00 00 00       	mov    $0x4,%edx
  802468:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80246b:	e8 cb fa ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802470:	01 7d 0c             	add    %edi,0xc(%ebp)
  802473:	e9 5e ff ff ff       	jmp    8023d6 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802478:	8b 53 04             	mov    0x4(%ebx),%edx
  80247b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80247e:	e8 fd f9 ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
  802483:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  802485:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80248c:	00 
  80248d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802490:	89 44 24 04          	mov    %eax,0x4(%esp)
  802494:	89 34 24             	mov    %esi,(%esp)
  802497:	e8 cb e5 ff ff       	call   800a67 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80249c:	ba 04 00 00 00       	mov    $0x4,%edx
  8024a1:	89 f0                	mov    %esi,%eax
  8024a3:	e8 93 fa ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  8024a8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  8024ae:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  8024b5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8024bc:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8024c2:	0f 87 18 ff ff ff    	ja     8023e0 <_ZL13devfile_writeP2FdPKvj+0x62>
  8024c8:	89 fe                	mov    %edi,%esi
  8024ca:	e9 33 ff ff ff       	jmp    802402 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8024cf:	8b 53 04             	mov    0x4(%ebx),%edx
  8024d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d5:	e8 a6 f9 ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
  8024da:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  8024dc:	89 74 24 08          	mov    %esi,0x8(%esp)
  8024e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e7:	89 3c 24             	mov    %edi,(%esp)
  8024ea:	e8 78 e5 ff ff       	call   800a67 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8024ef:	ba 04 00 00 00       	mov    $0x4,%edx
  8024f4:	89 f8                	mov    %edi,%eax
  8024f6:	e8 40 fa ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  8024fb:	01 73 04             	add    %esi,0x4(%ebx)
  8024fe:	e9 21 ff ff ff       	jmp    802424 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802503 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	57                   	push   %edi
  802507:	56                   	push   %esi
  802508:	53                   	push   %ebx
  802509:	83 ec 3c             	sub    $0x3c,%esp
  80250c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80250f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802512:	8b 43 04             	mov    0x4(%ebx),%eax
  802515:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802518:	8b 43 0c             	mov    0xc(%ebx),%eax
  80251b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80251e:	e8 d4 fa ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  802523:	85 c0                	test   %eax,%eax
  802525:	0f 88 d3 00 00 00    	js     8025fe <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80252b:	8b 73 04             	mov    0x4(%ebx),%esi
  80252e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802531:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802534:	8b 50 08             	mov    0x8(%eax),%edx
  802537:	29 f2                	sub    %esi,%edx
  802539:	3b 48 08             	cmp    0x8(%eax),%ecx
  80253c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80253f:	89 f2                	mov    %esi,%edx
  802541:	e8 3a f9 ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
  802546:	85 c0                	test   %eax,%eax
  802548:	0f 84 a2 00 00 00    	je     8025f0 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80254e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802554:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80255a:	29 f2                	sub    %esi,%edx
  80255c:	39 d7                	cmp    %edx,%edi
  80255e:	0f 46 d7             	cmovbe %edi,%edx
  802561:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802564:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802566:	01 d6                	add    %edx,%esi
  802568:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80256b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80256f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802573:	8b 45 0c             	mov    0xc(%ebp),%eax
  802576:	89 04 24             	mov    %eax,(%esp)
  802579:	e8 e9 e4 ff ff       	call   800a67 <memcpy>
    buf = (void *)((char *)buf + n2);
  80257e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802581:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802584:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80258a:	76 3e                	jbe    8025ca <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80258c:	8b 53 04             	mov    0x4(%ebx),%edx
  80258f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802592:	e8 e9 f8 ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
  802597:	85 c0                	test   %eax,%eax
  802599:	74 55                	je     8025f0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80259b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8025a2:	00 
  8025a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a7:	89 34 24             	mov    %esi,(%esp)
  8025aa:	e8 b8 e4 ff ff       	call   800a67 <memcpy>
        n -= PGSIZE;
  8025af:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8025b5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8025bb:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  8025c2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8025c8:	77 c2                	ja     80258c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8025ca:	85 ff                	test   %edi,%edi
  8025cc:	74 22                	je     8025f0 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8025ce:	8b 53 04             	mov    0x4(%ebx),%edx
  8025d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d4:	e8 a7 f8 ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	74 13                	je     8025f0 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  8025dd:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e5:	89 34 24             	mov    %esi,(%esp)
  8025e8:	e8 7a e4 ff ff       	call   800a67 <memcpy>
        fd->fd_offset += n;
  8025ed:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  8025f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f3:	e8 fd fb ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8025f8:	8b 43 04             	mov    0x4(%ebx),%eax
  8025fb:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  8025fe:	83 c4 3c             	add    $0x3c,%esp
  802601:	5b                   	pop    %ebx
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    

00802606 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	57                   	push   %edi
  80260a:	56                   	push   %esi
  80260b:	53                   	push   %ebx
  80260c:	83 ec 4c             	sub    $0x4c,%esp
  80260f:	89 c6                	mov    %eax,%esi
  802611:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802614:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802617:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80261d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802626:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802629:	b8 01 00 00 00       	mov    $0x1,%eax
  80262e:	e8 c4 f9 ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  802633:	89 c7                	mov    %eax,%edi
  802635:	85 c0                	test   %eax,%eax
  802637:	0f 88 cd 01 00 00    	js     80280a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80263d:	89 f3                	mov    %esi,%ebx
  80263f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802642:	75 08                	jne    80264c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802644:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802647:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80264a:	74 f8                	je     802644 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80264c:	0f b6 03             	movzbl (%ebx),%eax
  80264f:	3c 2f                	cmp    $0x2f,%al
  802651:	74 16                	je     802669 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802653:	84 c0                	test   %al,%al
  802655:	74 12                	je     802669 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802657:	89 da                	mov    %ebx,%edx
		++path;
  802659:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80265c:	0f b6 02             	movzbl (%edx),%eax
  80265f:	3c 2f                	cmp    $0x2f,%al
  802661:	74 08                	je     80266b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802663:	84 c0                	test   %al,%al
  802665:	75 f2                	jne    802659 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802667:	eb 02                	jmp    80266b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802669:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80266b:	89 d0                	mov    %edx,%eax
  80266d:	29 d8                	sub    %ebx,%eax
  80266f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802672:	0f b6 02             	movzbl (%edx),%eax
  802675:	89 d6                	mov    %edx,%esi
  802677:	3c 2f                	cmp    $0x2f,%al
  802679:	75 0a                	jne    802685 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80267b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80267e:	0f b6 06             	movzbl (%esi),%eax
  802681:	3c 2f                	cmp    $0x2f,%al
  802683:	74 f6                	je     80267b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802685:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802689:	75 1b                	jne    8026a6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80268b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802691:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802693:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802696:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80269c:	bf 00 00 00 00       	mov    $0x0,%edi
  8026a1:	e9 64 01 00 00       	jmp    80280a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8026a6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8026aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026ae:	74 06                	je     8026b6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8026b0:	84 c0                	test   %al,%al
  8026b2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8026b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026b9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8026bc:	83 3a 02             	cmpl   $0x2,(%edx)
  8026bf:	0f 85 f4 00 00 00    	jne    8027b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8026c5:	89 d0                	mov    %edx,%eax
  8026c7:	8b 52 08             	mov    0x8(%edx),%edx
  8026ca:	85 d2                	test   %edx,%edx
  8026cc:	7e 78                	jle    802746 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  8026ce:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  8026d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8026da:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8026dd:	89 fb                	mov    %edi,%ebx
  8026df:	89 75 c0             	mov    %esi,-0x40(%ebp)
  8026e2:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8026e4:	89 da                	mov    %ebx,%edx
  8026e6:	89 f0                	mov    %esi,%eax
  8026e8:	e8 93 f7 ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
  8026ed:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  8026ef:	83 38 00             	cmpl   $0x0,(%eax)
  8026f2:	74 26                	je     80271a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  8026f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026f7:	3b 50 04             	cmp    0x4(%eax),%edx
  8026fa:	75 33                	jne    80272f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  8026fc:	89 54 24 08          	mov    %edx,0x8(%esp)
  802700:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802703:	89 44 24 04          	mov    %eax,0x4(%esp)
  802707:	8d 47 08             	lea    0x8(%edi),%eax
  80270a:	89 04 24             	mov    %eax,(%esp)
  80270d:	e8 96 e3 ff ff       	call   800aa8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802712:	85 c0                	test   %eax,%eax
  802714:	0f 84 fa 00 00 00    	je     802814 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80271a:	83 3f 00             	cmpl   $0x0,(%edi)
  80271d:	75 10                	jne    80272f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80271f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802723:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802726:	84 c0                	test   %al,%al
  802728:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80272c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80272f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802735:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802737:	8b 56 08             	mov    0x8(%esi),%edx
  80273a:	39 d0                	cmp    %edx,%eax
  80273c:	7c a6                	jl     8026e4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80273e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802741:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802744:	eb 07                	jmp    80274d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802746:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80274d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802751:	74 6d                	je     8027c0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802753:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802757:	75 24                	jne    80277d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802759:	83 ea 80             	sub    $0xffffff80,%edx
  80275c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80275f:	e8 0c f9 ff ff       	call   802070 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802764:	85 c0                	test   %eax,%eax
  802766:	0f 88 90 00 00 00    	js     8027fc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80276c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80276f:	8b 50 08             	mov    0x8(%eax),%edx
  802772:	83 c2 80             	add    $0xffffff80,%edx
  802775:	e8 06 f7 ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
  80277a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80277d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802784:	00 
  802785:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80278c:	00 
  80278d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802790:	89 14 24             	mov    %edx,(%esp)
  802793:	e8 f9 e1 ff ff       	call   800991 <memset>
	empty->de_namelen = namelen;
  802798:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80279b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80279e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8027a1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027a9:	83 c0 08             	add    $0x8,%eax
  8027ac:	89 04 24             	mov    %eax,(%esp)
  8027af:	e8 b3 e2 ff ff       	call   800a67 <memcpy>
	*de_store = empty;
  8027b4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  8027b7:	eb 5e                	jmp    802817 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  8027b9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  8027be:	eb 42                	jmp    802802 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  8027c0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  8027c5:	eb 3b                	jmp    802802 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  8027c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ca:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8027cd:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  8027cf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027d2:	89 38                	mov    %edi,(%eax)
			return 0;
  8027d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d9:	eb 2f                	jmp    80280a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  8027db:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8027de:	8b 07                	mov    (%edi),%eax
  8027e0:	e8 12 f8 ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	78 17                	js     802800 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  8027e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ec:	e8 04 fa ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  8027f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  8027f7:	e9 41 fe ff ff       	jmp    80263d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  8027fc:	89 c7                	mov    %eax,%edi
  8027fe:	eb 02                	jmp    802802 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802800:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802805:	e8 eb f9 ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
	return r;
}
  80280a:	89 f8                	mov    %edi,%eax
  80280c:	83 c4 4c             	add    $0x4c,%esp
  80280f:	5b                   	pop    %ebx
  802810:	5e                   	pop    %esi
  802811:	5f                   	pop    %edi
  802812:	5d                   	pop    %ebp
  802813:	c3                   	ret    
  802814:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802817:	80 3e 00             	cmpb   $0x0,(%esi)
  80281a:	75 bf                	jne    8027db <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80281c:	eb a9                	jmp    8027c7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080281e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
  802821:	57                   	push   %edi
  802822:	56                   	push   %esi
  802823:	53                   	push   %ebx
  802824:	83 ec 3c             	sub    $0x3c,%esp
  802827:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80282a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80282d:	89 04 24             	mov    %eax,(%esp)
  802830:	e8 62 f0 ff ff       	call   801897 <_Z14fd_find_unusedPP2Fd>
  802835:	89 c3                	mov    %eax,%ebx
  802837:	85 c0                	test   %eax,%eax
  802839:	0f 88 16 02 00 00    	js     802a55 <_Z4openPKci+0x237>
  80283f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802846:	00 
  802847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802855:	e8 d6 e4 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  80285a:	89 c3                	mov    %eax,%ebx
  80285c:	b8 00 00 00 00       	mov    $0x0,%eax
  802861:	85 db                	test   %ebx,%ebx
  802863:	0f 88 ec 01 00 00    	js     802a55 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802869:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80286d:	0f 84 ec 01 00 00    	je     802a5f <_Z4openPKci+0x241>
  802873:	83 c0 01             	add    $0x1,%eax
  802876:	83 f8 78             	cmp    $0x78,%eax
  802879:	75 ee                	jne    802869 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80287b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802880:	e9 b9 01 00 00       	jmp    802a3e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802885:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802888:	81 e7 00 01 00 00    	and    $0x100,%edi
  80288e:	89 3c 24             	mov    %edi,(%esp)
  802891:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802894:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802897:	89 f0                	mov    %esi,%eax
  802899:	e8 68 fd ff ff       	call   802606 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80289e:	89 c3                	mov    %eax,%ebx
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	0f 85 96 01 00 00    	jne    802a3e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8028a8:	85 ff                	test   %edi,%edi
  8028aa:	75 41                	jne    8028ed <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8028ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028af:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  8028b4:	75 08                	jne    8028be <_Z4openPKci+0xa0>
            fileino = dirino;
  8028b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8028bc:	eb 14                	jmp    8028d2 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  8028be:	8d 55 d8             	lea    -0x28(%ebp),%edx
  8028c1:	8b 00                	mov    (%eax),%eax
  8028c3:	e8 2f f7 ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  8028c8:	89 c3                	mov    %eax,%ebx
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	0f 88 5d 01 00 00    	js     802a2f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  8028d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028d5:	83 38 02             	cmpl   $0x2,(%eax)
  8028d8:	0f 85 d2 00 00 00    	jne    8029b0 <_Z4openPKci+0x192>
  8028de:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  8028e2:	0f 84 c8 00 00 00    	je     8029b0 <_Z4openPKci+0x192>
  8028e8:	e9 38 01 00 00       	jmp    802a25 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  8028ed:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8028f4:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  8028fb:	0f 8e a8 00 00 00    	jle    8029a9 <_Z4openPKci+0x18b>
  802901:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802906:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802909:	89 f8                	mov    %edi,%eax
  80290b:	e8 e7 f6 ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  802910:	89 c3                	mov    %eax,%ebx
  802912:	85 c0                	test   %eax,%eax
  802914:	0f 88 15 01 00 00    	js     802a2f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80291a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80291d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802921:	75 68                	jne    80298b <_Z4openPKci+0x16d>
  802923:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80292a:	75 5f                	jne    80298b <_Z4openPKci+0x16d>
			*ino_store = ino;
  80292c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80292f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802935:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802938:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80293f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802946:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80294d:	00 
  80294e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802955:	00 
  802956:	83 c0 0c             	add    $0xc,%eax
  802959:	89 04 24             	mov    %eax,(%esp)
  80295c:	e8 30 e0 ff ff       	call   800991 <memset>
        de->de_inum = fileino->i_inum;
  802961:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802964:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80296a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80296d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80296f:	ba 04 00 00 00       	mov    $0x4,%edx
  802974:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802977:	e8 bf f5 ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80297c:	ba 04 00 00 00       	mov    $0x4,%edx
  802981:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802984:	e8 b2 f5 ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
  802989:	eb 25                	jmp    8029b0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  80298b:	e8 65 f8 ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802990:	83 c7 01             	add    $0x1,%edi
  802993:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802999:	0f 8c 67 ff ff ff    	jl     802906 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  80299f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8029a4:	e9 86 00 00 00       	jmp    802a2f <_Z4openPKci+0x211>
  8029a9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8029ae:	eb 7f                	jmp    802a2f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  8029b0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  8029b7:	74 0d                	je     8029c6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  8029b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8029be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029c1:	e8 aa f6 ff ff       	call   802070 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  8029c6:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8029cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cf:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  8029d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  8029db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029de:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  8029e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029e4:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  8029ea:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  8029ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029f1:	83 c0 10             	add    $0x10,%eax
  8029f4:	89 04 24             	mov    %eax,(%esp)
  8029f7:	e8 4e de ff ff       	call   80084a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  8029fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ff:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802a06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a09:	e8 e7 f7 ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  802a0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a11:	e8 df f7 ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a19:	89 04 24             	mov    %eax,(%esp)
  802a1c:	e8 13 ee ff ff       	call   801834 <_Z6fd2numP2Fd>
  802a21:	89 c3                	mov    %eax,%ebx
  802a23:	eb 30                	jmp    802a55 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802a25:	e8 cb f7 ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  802a2a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  802a2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a32:	e8 be f7 ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
  802a37:	eb 05                	jmp    802a3e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802a39:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  802a3e:	a1 00 60 80 00       	mov    0x806000,%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a49:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a4d:	89 04 24             	mov    %eax,(%esp)
  802a50:	e8 98 e3 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802a55:	89 d8                	mov    %ebx,%eax
  802a57:	83 c4 3c             	add    $0x3c,%esp
  802a5a:	5b                   	pop    %ebx
  802a5b:	5e                   	pop    %esi
  802a5c:	5f                   	pop    %edi
  802a5d:	5d                   	pop    %ebp
  802a5e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  802a5f:	83 f8 78             	cmp    $0x78,%eax
  802a62:	0f 85 1d fe ff ff    	jne    802885 <_Z4openPKci+0x67>
  802a68:	eb cf                	jmp    802a39 <_Z4openPKci+0x21b>

00802a6a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
  802a6d:	53                   	push   %ebx
  802a6e:	83 ec 24             	sub    $0x24,%esp
  802a71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802a74:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	e8 78 f5 ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	78 27                	js     802aaa <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802a83:	c7 44 24 04 f4 48 80 	movl   $0x8048f4,0x4(%esp)
  802a8a:	00 
  802a8b:	89 1c 24             	mov    %ebx,(%esp)
  802a8e:	e8 b7 dd ff ff       	call   80084a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802a93:	89 da                	mov    %ebx,%edx
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	e8 26 f4 ff ff       	call   801ec3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	e8 50 f7 ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
	return 0;
  802aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aaa:	83 c4 24             	add    $0x24,%esp
  802aad:	5b                   	pop    %ebx
  802aae:	5d                   	pop    %ebp
  802aaf:	c3                   	ret    

00802ab0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
  802ab3:	53                   	push   %ebx
  802ab4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802ab7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802abe:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802ac1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	e8 3a fb ff ff       	call   802606 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802acc:	89 c3                	mov    %eax,%ebx
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	78 5f                	js     802b31 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802ad2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	e8 18 f5 ff ff       	call   801ff7 <_ZL10inode_openiPP5Inode>
  802adf:	89 c3                	mov    %eax,%ebx
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	78 44                	js     802b29 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802ae5:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  802aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aed:	83 38 02             	cmpl   $0x2,(%eax)
  802af0:	74 2f                	je     802b21 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  802afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afe:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802b02:	ba 04 00 00 00       	mov    $0x4,%edx
  802b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0a:	e8 2c f4 ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  802b0f:	ba 04 00 00 00       	mov    $0x4,%edx
  802b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b17:	e8 1f f4 ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
	r = 0;
  802b1c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	e8 cc f6 ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	e8 c4 f6 ff ff       	call   8021f5 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802b31:	89 d8                	mov    %ebx,%eax
  802b33:	83 c4 24             	add    $0x24,%esp
  802b36:	5b                   	pop    %ebx
  802b37:	5d                   	pop    %ebp
  802b38:	c3                   	ret    

00802b39 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802b39:	55                   	push   %ebp
  802b3a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  802b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b41:	5d                   	pop    %ebp
  802b42:	c3                   	ret    

00802b43 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802b43:	55                   	push   %ebp
  802b44:	89 e5                	mov    %esp,%ebp
  802b46:	57                   	push   %edi
  802b47:	56                   	push   %esi
  802b48:	53                   	push   %ebx
  802b49:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  802b4f:	c7 04 24 9d 22 80 00 	movl   $0x80229d,(%esp)
  802b56:	e8 30 15 00 00       	call   80408b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802b5b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802b60:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802b65:	74 28                	je     802b8f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802b67:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802b6e:	4a 
  802b6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b73:	c7 44 24 08 5c 49 80 	movl   $0x80495c,0x8(%esp)
  802b7a:	00 
  802b7b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802b82:	00 
  802b83:	c7 04 24 d6 48 80 00 	movl   $0x8048d6,(%esp)
  802b8a:	e8 2d 14 00 00       	call   803fbc <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802b8f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802b94:	83 f8 03             	cmp    $0x3,%eax
  802b97:	7f 1c                	jg     802bb5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802b99:	c7 44 24 08 90 49 80 	movl   $0x804990,0x8(%esp)
  802ba0:	00 
  802ba1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802ba8:	00 
  802ba9:	c7 04 24 d6 48 80 00 	movl   $0x8048d6,(%esp)
  802bb0:	e8 07 14 00 00       	call   803fbc <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802bb5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802bbb:	85 d2                	test   %edx,%edx
  802bbd:	7f 1c                	jg     802bdb <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802bbf:	c7 44 24 08 c0 49 80 	movl   $0x8049c0,0x8(%esp)
  802bc6:	00 
  802bc7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802bce:	00 
  802bcf:	c7 04 24 d6 48 80 00 	movl   $0x8048d6,(%esp)
  802bd6:	e8 e1 13 00 00       	call   803fbc <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802bdb:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802be1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802be7:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802bed:	85 c9                	test   %ecx,%ecx
  802bef:	0f 48 cb             	cmovs  %ebx,%ecx
  802bf2:	c1 f9 0c             	sar    $0xc,%ecx
  802bf5:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802bf9:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802bff:	39 c8                	cmp    %ecx,%eax
  802c01:	7c 13                	jl     802c16 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802c03:	85 c0                	test   %eax,%eax
  802c05:	7f 3d                	jg     802c44 <_Z4fsckv+0x101>
  802c07:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802c0e:	00 00 00 
  802c11:	e9 ac 00 00 00       	jmp    802cc2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802c16:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802c1c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802c20:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c24:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802c28:	c7 44 24 08 f0 49 80 	movl   $0x8049f0,0x8(%esp)
  802c2f:	00 
  802c30:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802c37:	00 
  802c38:	c7 04 24 d6 48 80 00 	movl   $0x8048d6,(%esp)
  802c3f:	e8 78 13 00 00       	call   803fbc <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802c44:	be 00 20 00 50       	mov    $0x50002000,%esi
  802c49:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802c50:	00 00 00 
  802c53:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c58:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802c5e:	39 df                	cmp    %ebx,%edi
  802c60:	7e 27                	jle    802c89 <_Z4fsckv+0x146>
  802c62:	0f b6 06             	movzbl (%esi),%eax
  802c65:	84 c0                	test   %al,%al
  802c67:	74 4b                	je     802cb4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802c69:	0f be c0             	movsbl %al,%eax
  802c6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c74:	c7 04 24 34 4a 80 00 	movl   $0x804a34,(%esp)
  802c7b:	e8 aa d5 ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  802c80:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c87:	eb 2b                	jmp    802cb4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802c89:	0f b6 06             	movzbl (%esi),%eax
  802c8c:	3c 01                	cmp    $0x1,%al
  802c8e:	76 24                	jbe    802cb4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802c90:	0f be c0             	movsbl %al,%eax
  802c93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c97:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c9b:	c7 04 24 68 4a 80 00 	movl   $0x804a68,(%esp)
  802ca2:	e8 83 d5 ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  802ca7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802cae:	80 3e 00             	cmpb   $0x0,(%esi)
  802cb1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802cb4:	83 c3 01             	add    $0x1,%ebx
  802cb7:	83 c6 01             	add    $0x1,%esi
  802cba:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802cc0:	7f 9c                	jg     802c5e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802cc2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802cc9:	0f 8e e1 02 00 00    	jle    802fb0 <_Z4fsckv+0x46d>
  802ccf:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802cd6:	00 00 00 
		struct Inode *ino = get_inode(i);
  802cd9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802cdf:	e8 f9 f1 ff ff       	call   801edd <_ZL9get_inodei>
  802ce4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  802cea:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  802cee:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802cf5:	75 22                	jne    802d19 <_Z4fsckv+0x1d6>
  802cf7:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  802cfe:	0f 84 a9 06 00 00    	je     8033ad <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802d04:	ba 00 00 00 00       	mov    $0x0,%edx
  802d09:	e8 2d f2 ff ff       	call   801f3b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	74 3a                	je     802d4c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802d12:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802d19:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d1f:	8b 02                	mov    (%edx),%eax
  802d21:	83 f8 01             	cmp    $0x1,%eax
  802d24:	74 26                	je     802d4c <_Z4fsckv+0x209>
  802d26:	83 f8 02             	cmp    $0x2,%eax
  802d29:	74 21                	je     802d4c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  802d2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d2f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802d35:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802d39:	c7 04 24 94 4a 80 00 	movl   $0x804a94,(%esp)
  802d40:	e8 e5 d4 ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  802d45:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  802d4c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802d53:	75 3f                	jne    802d94 <_Z4fsckv+0x251>
  802d55:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802d5b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802d5f:	75 15                	jne    802d76 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802d61:	c7 04 24 b8 4a 80 00 	movl   $0x804ab8,(%esp)
  802d68:	e8 bd d4 ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  802d6d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d74:	eb 1e                	jmp    802d94 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802d76:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d7c:	83 3a 02             	cmpl   $0x2,(%edx)
  802d7f:	74 13                	je     802d94 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802d81:	c7 04 24 ec 4a 80 00 	movl   $0x804aec,(%esp)
  802d88:	e8 9d d4 ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  802d8d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802d94:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802d99:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802da0:	0f 84 93 00 00 00    	je     802e39 <_Z4fsckv+0x2f6>
  802da6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  802dac:	8b 41 08             	mov    0x8(%ecx),%eax
  802daf:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802db4:	7e 23                	jle    802dd9 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802db6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802dba:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802dc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dc4:	c7 04 24 1c 4b 80 00 	movl   $0x804b1c,(%esp)
  802dcb:	e8 5a d4 ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  802dd0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802dd7:	eb 09                	jmp    802de2 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802dd9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802de0:	74 4b                	je     802e2d <_Z4fsckv+0x2ea>
  802de2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802de8:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  802dee:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802df4:	74 23                	je     802e19 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802df6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802dfa:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802e00:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e04:	c7 04 24 40 4b 80 00 	movl   $0x804b40,(%esp)
  802e0b:	e8 1a d4 ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  802e10:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802e17:	eb 09                	jmp    802e22 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802e19:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802e20:	74 12                	je     802e34 <_Z4fsckv+0x2f1>
  802e22:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802e28:	8b 78 08             	mov    0x8(%eax),%edi
  802e2b:	eb 0c                	jmp    802e39 <_Z4fsckv+0x2f6>
  802e2d:	bf 00 00 00 00       	mov    $0x0,%edi
  802e32:	eb 05                	jmp    802e39 <_Z4fsckv+0x2f6>
  802e34:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802e39:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  802e3e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e44:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802e48:	89 d8                	mov    %ebx,%eax
  802e4a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802e4d:	39 c7                	cmp    %eax,%edi
  802e4f:	7e 2b                	jle    802e7c <_Z4fsckv+0x339>
  802e51:	85 f6                	test   %esi,%esi
  802e53:	75 27                	jne    802e7c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802e55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e5d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802e63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e67:	c7 04 24 64 4b 80 00 	movl   $0x804b64,(%esp)
  802e6e:	e8 b7 d3 ff ff       	call   80022a <_Z7cprintfPKcz>
				++errors;
  802e73:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802e7a:	eb 36                	jmp    802eb2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  802e7c:	39 f8                	cmp    %edi,%eax
  802e7e:	7c 32                	jl     802eb2 <_Z4fsckv+0x36f>
  802e80:	85 f6                	test   %esi,%esi
  802e82:	74 2e                	je     802eb2 <_Z4fsckv+0x36f>
  802e84:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802e8b:	74 25                	je     802eb2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  802e8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e95:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802e9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e9f:	c7 04 24 a8 4b 80 00 	movl   $0x804ba8,(%esp)
  802ea6:	e8 7f d3 ff ff       	call   80022a <_Z7cprintfPKcz>
				++errors;
  802eab:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802eb2:	85 f6                	test   %esi,%esi
  802eb4:	0f 84 a0 00 00 00    	je     802f5a <_Z4fsckv+0x417>
  802eba:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ec1:	0f 84 93 00 00 00    	je     802f5a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802ec7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802ecd:	7e 27                	jle    802ef6 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802ecf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802ed3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ed7:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802edd:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ee1:	c7 04 24 ec 4b 80 00 	movl   $0x804bec,(%esp)
  802ee8:	e8 3d d3 ff ff       	call   80022a <_Z7cprintfPKcz>
					++errors;
  802eed:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ef4:	eb 64                	jmp    802f5a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802ef6:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802efd:	3c 01                	cmp    $0x1,%al
  802eff:	75 27                	jne    802f28 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802f01:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802f05:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f09:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802f0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f13:	c7 04 24 30 4c 80 00 	movl   $0x804c30,(%esp)
  802f1a:	e8 0b d3 ff ff       	call   80022a <_Z7cprintfPKcz>
					++errors;
  802f1f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f26:	eb 32                	jmp    802f5a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802f28:	3c ff                	cmp    $0xff,%al
  802f2a:	75 27                	jne    802f53 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802f2c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802f30:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f34:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f3e:	c7 04 24 6c 4c 80 00 	movl   $0x804c6c,(%esp)
  802f45:	e8 e0 d2 ff ff       	call   80022a <_Z7cprintfPKcz>
					++errors;
  802f4a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f51:	eb 07                	jmp    802f5a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802f53:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802f5a:	83 c3 01             	add    $0x1,%ebx
  802f5d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802f63:	0f 85 d5 fe ff ff    	jne    802e3e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802f69:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802f70:	0f 94 c0             	sete   %al
  802f73:	0f b6 c0             	movzbl %al,%eax
  802f76:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f7c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802f82:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802f89:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802f90:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802f97:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802f9e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802fa4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802faa:	0f 8f 29 fd ff ff    	jg     802cd9 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802fb0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802fb7:	0f 8e 7f 03 00 00    	jle    80333c <_Z4fsckv+0x7f9>
  802fbd:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802fc2:	89 f0                	mov    %esi,%eax
  802fc4:	e8 14 ef ff ff       	call   801edd <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802fc9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802fd0:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802fd7:	c1 e2 08             	shl    $0x8,%edx
  802fda:	09 ca                	or     %ecx,%edx
  802fdc:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802fe3:	c1 e1 10             	shl    $0x10,%ecx
  802fe6:	09 ca                	or     %ecx,%edx
  802fe8:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802fef:	83 e1 7f             	and    $0x7f,%ecx
  802ff2:	c1 e1 18             	shl    $0x18,%ecx
  802ff5:	09 d1                	or     %edx,%ecx
  802ff7:	74 0e                	je     803007 <_Z4fsckv+0x4c4>
  802ff9:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803000:	78 05                	js     803007 <_Z4fsckv+0x4c4>
  803002:	83 38 02             	cmpl   $0x2,(%eax)
  803005:	74 1f                	je     803026 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803007:	83 c6 01             	add    $0x1,%esi
  80300a:	a1 08 10 00 50       	mov    0x50001008,%eax
  80300f:	39 f0                	cmp    %esi,%eax
  803011:	7f af                	jg     802fc2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803013:	bb 01 00 00 00       	mov    $0x1,%ebx
  803018:	83 f8 01             	cmp    $0x1,%eax
  80301b:	0f 8f ad 02 00 00    	jg     8032ce <_Z4fsckv+0x78b>
  803021:	e9 16 03 00 00       	jmp    80333c <_Z4fsckv+0x7f9>
  803026:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  803028:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  80302f:	8b 40 08             	mov    0x8(%eax),%eax
  803032:	a8 7f                	test   $0x7f,%al
  803034:	74 23                	je     803059 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  803036:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  80303d:	00 
  80303e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803042:	89 74 24 04          	mov    %esi,0x4(%esp)
  803046:	c7 04 24 a8 4c 80 00 	movl   $0x804ca8,(%esp)
  80304d:	e8 d8 d1 ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  803052:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803059:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  803060:	00 00 00 
  803063:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  803069:	e9 3d 02 00 00       	jmp    8032ab <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  80306e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803074:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80307a:	e8 01 ee ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
  80307f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  803081:	83 38 00             	cmpl   $0x0,(%eax)
  803084:	0f 84 15 02 00 00    	je     80329f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803090:	83 fa 76             	cmp    $0x76,%edx
  803093:	76 27                	jbe    8030bc <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  803095:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803099:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80309f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030a7:	c7 04 24 dc 4c 80 00 	movl   $0x804cdc,(%esp)
  8030ae:	e8 77 d1 ff ff       	call   80022a <_Z7cprintfPKcz>
				++errors;
  8030b3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8030ba:	eb 28                	jmp    8030e4 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  8030bc:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  8030c1:	74 21                	je     8030e4 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  8030c3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8030c9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8030cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030d1:	c7 04 24 08 4d 80 00 	movl   $0x804d08,(%esp)
  8030d8:	e8 4d d1 ff ff       	call   80022a <_Z7cprintfPKcz>
				++errors;
  8030dd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  8030e4:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  8030eb:	00 
  8030ec:	8d 43 08             	lea    0x8(%ebx),%eax
  8030ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030f3:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  8030f9:	89 0c 24             	mov    %ecx,(%esp)
  8030fc:	e8 66 d9 ff ff       	call   800a67 <memcpy>
  803101:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803105:	bf 77 00 00 00       	mov    $0x77,%edi
  80310a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80310e:	85 ff                	test   %edi,%edi
  803110:	b8 00 00 00 00       	mov    $0x0,%eax
  803115:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803118:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80311f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803120:	8b 03                	mov    (%ebx),%eax
  803122:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803128:	7c 3e                	jl     803168 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80312a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80312e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803134:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803138:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80313e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803142:	89 74 24 04          	mov    %esi,0x4(%esp)
  803146:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  80314d:	e8 d8 d0 ff ff       	call   80022a <_Z7cprintfPKcz>
				++errors;
  803152:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803159:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  803160:	00 00 00 
  803163:	e9 0b 01 00 00       	jmp    803273 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  803168:	e8 70 ed ff ff       	call   801edd <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  80316d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803174:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  80317b:	c1 e2 08             	shl    $0x8,%edx
  80317e:	09 d1                	or     %edx,%ecx
  803180:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  803187:	c1 e2 10             	shl    $0x10,%edx
  80318a:	09 d1                	or     %edx,%ecx
  80318c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803193:	83 e2 7f             	and    $0x7f,%edx
  803196:	c1 e2 18             	shl    $0x18,%edx
  803199:	09 ca                	or     %ecx,%edx
  80319b:	83 c2 01             	add    $0x1,%edx
  80319e:	89 d1                	mov    %edx,%ecx
  8031a0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  8031a6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  8031ac:	0f b6 d5             	movzbl %ch,%edx
  8031af:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  8031b5:	89 ca                	mov    %ecx,%edx
  8031b7:	c1 ea 10             	shr    $0x10,%edx
  8031ba:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  8031c0:	c1 e9 18             	shr    $0x18,%ecx
  8031c3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  8031ca:	83 e2 80             	and    $0xffffff80,%edx
  8031cd:	09 ca                	or     %ecx,%edx
  8031cf:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  8031d5:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8031d9:	0f 85 7a ff ff ff    	jne    803159 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  8031df:	8b 03                	mov    (%ebx),%eax
  8031e1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8031e5:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  8031eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031ef:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8031f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031fd:	c7 04 24 6c 4d 80 00 	movl   $0x804d6c,(%esp)
  803204:	e8 21 d0 ff ff       	call   80022a <_Z7cprintfPKcz>
					++errors;
  803209:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803210:	e9 44 ff ff ff       	jmp    803159 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803215:	3b 78 04             	cmp    0x4(%eax),%edi
  803218:	75 52                	jne    80326c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  80321a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80321e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803224:	89 54 24 04          	mov    %edx,0x4(%esp)
  803228:	83 c0 08             	add    $0x8,%eax
  80322b:	89 04 24             	mov    %eax,(%esp)
  80322e:	e8 75 d8 ff ff       	call   800aa8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803233:	85 c0                	test   %eax,%eax
  803235:	75 35                	jne    80326c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  803237:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80323d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803241:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803247:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80324b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803251:	89 54 24 08          	mov    %edx,0x8(%esp)
  803255:	89 74 24 04          	mov    %esi,0x4(%esp)
  803259:	c7 04 24 9c 4d 80 00 	movl   $0x804d9c,(%esp)
  803260:	e8 c5 cf ff ff       	call   80022a <_Z7cprintfPKcz>
					++errors;
  803265:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80326c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  803273:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803279:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  80327f:	7e 1e                	jle    80329f <_Z4fsckv+0x75c>
  803281:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803285:	7f 18                	jg     80329f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  803287:	89 ca                	mov    %ecx,%edx
  803289:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80328f:	e8 ec eb ff ff       	call   801e80 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  803294:	83 38 00             	cmpl   $0x0,(%eax)
  803297:	0f 85 78 ff ff ff    	jne    803215 <_Z4fsckv+0x6d2>
  80329d:	eb cd                	jmp    80326c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80329f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8032a5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8032ab:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8032b1:	83 ea 80             	sub    $0xffffff80,%edx
  8032b4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  8032ba:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8032c0:	3b 51 08             	cmp    0x8(%ecx),%edx
  8032c3:	0f 8f e7 fc ff ff    	jg     802fb0 <_Z4fsckv+0x46d>
  8032c9:	e9 a0 fd ff ff       	jmp    80306e <_Z4fsckv+0x52b>
  8032ce:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  8032d4:	89 d8                	mov    %ebx,%eax
  8032d6:	e8 02 ec ff ff       	call   801edd <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  8032db:	8b 50 04             	mov    0x4(%eax),%edx
  8032de:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8032e5:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  8032ec:	c1 e7 08             	shl    $0x8,%edi
  8032ef:	09 f9                	or     %edi,%ecx
  8032f1:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  8032f8:	c1 e7 10             	shl    $0x10,%edi
  8032fb:	09 f9                	or     %edi,%ecx
  8032fd:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803304:	83 e7 7f             	and    $0x7f,%edi
  803307:	c1 e7 18             	shl    $0x18,%edi
  80330a:	09 f9                	or     %edi,%ecx
  80330c:	39 ca                	cmp    %ecx,%edx
  80330e:	74 1b                	je     80332b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803310:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803314:	89 54 24 08          	mov    %edx,0x8(%esp)
  803318:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80331c:	c7 04 24 cc 4d 80 00 	movl   $0x804dcc,(%esp)
  803323:	e8 02 cf ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  803328:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80332b:	83 c3 01             	add    $0x1,%ebx
  80332e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  803334:	7f 9e                	jg     8032d4 <_Z4fsckv+0x791>
  803336:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  80333c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  803343:	7e 4f                	jle    803394 <_Z4fsckv+0x851>
  803345:	bb 00 00 00 00       	mov    $0x0,%ebx
  80334a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  803350:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  803357:	3c ff                	cmp    $0xff,%al
  803359:	75 09                	jne    803364 <_Z4fsckv+0x821>
			freemap[i] = 0;
  80335b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803362:	eb 1f                	jmp    803383 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803364:	84 c0                	test   %al,%al
  803366:	75 1b                	jne    803383 <_Z4fsckv+0x840>
  803368:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80336e:	7c 13                	jl     803383 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803370:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803374:	c7 04 24 f8 4d 80 00 	movl   $0x804df8,(%esp)
  80337b:	e8 aa ce ff ff       	call   80022a <_Z7cprintfPKcz>
			++errors;
  803380:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803383:	83 c3 01             	add    $0x1,%ebx
  803386:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  80338c:	7f c2                	jg     803350 <_Z4fsckv+0x80d>
  80338e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803394:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80339b:	19 c0                	sbb    %eax,%eax
  80339d:	f7 d0                	not    %eax
  80339f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  8033a2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  8033a8:	5b                   	pop    %ebx
  8033a9:	5e                   	pop    %esi
  8033aa:	5f                   	pop    %edi
  8033ab:	5d                   	pop    %ebp
  8033ac:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  8033ad:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8033b4:	0f 84 92 f9 ff ff    	je     802d4c <_Z4fsckv+0x209>
  8033ba:	e9 5a f9 ff ff       	jmp    802d19 <_Z4fsckv+0x1d6>
	...

008033c0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8033c0:	55                   	push   %ebp
  8033c1:	89 e5                	mov    %esp,%ebp
  8033c3:	83 ec 18             	sub    $0x18,%esp
  8033c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8033c9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8033cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	89 04 24             	mov    %eax,(%esp)
  8033d5:	e8 a2 e4 ff ff       	call   80187c <_Z7fd2dataP2Fd>
  8033da:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8033dc:	c7 44 24 04 2b 4e 80 	movl   $0x804e2b,0x4(%esp)
  8033e3:	00 
  8033e4:	89 34 24             	mov    %esi,(%esp)
  8033e7:	e8 5e d4 ff ff       	call   80084a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  8033ec:	8b 43 04             	mov    0x4(%ebx),%eax
  8033ef:	2b 03                	sub    (%ebx),%eax
  8033f1:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  8033f4:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  8033fb:	c7 86 80 00 00 00 20 	movl   $0x805020,0x80(%esi)
  803402:	50 80 00 
	return 0;
}
  803405:	b8 00 00 00 00       	mov    $0x0,%eax
  80340a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80340d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803410:	89 ec                	mov    %ebp,%esp
  803412:	5d                   	pop    %ebp
  803413:	c3                   	ret    

00803414 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803414:	55                   	push   %ebp
  803415:	89 e5                	mov    %esp,%ebp
  803417:	53                   	push   %ebx
  803418:	83 ec 14             	sub    $0x14,%esp
  80341b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80341e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803429:	e8 bf d9 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80342e:	89 1c 24             	mov    %ebx,(%esp)
  803431:	e8 46 e4 ff ff       	call   80187c <_Z7fd2dataP2Fd>
  803436:	89 44 24 04          	mov    %eax,0x4(%esp)
  80343a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803441:	e8 a7 d9 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
}
  803446:	83 c4 14             	add    $0x14,%esp
  803449:	5b                   	pop    %ebx
  80344a:	5d                   	pop    %ebp
  80344b:	c3                   	ret    

0080344c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80344c:	55                   	push   %ebp
  80344d:	89 e5                	mov    %esp,%ebp
  80344f:	57                   	push   %edi
  803450:	56                   	push   %esi
  803451:	53                   	push   %ebx
  803452:	83 ec 2c             	sub    $0x2c,%esp
  803455:	89 c7                	mov    %eax,%edi
  803457:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80345a:	a1 00 60 80 00       	mov    0x806000,%eax
  80345f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803462:	89 3c 24             	mov    %edi,(%esp)
  803465:	e8 82 04 00 00       	call   8038ec <_Z7pagerefPv>
  80346a:	89 c3                	mov    %eax,%ebx
  80346c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346f:	89 04 24             	mov    %eax,(%esp)
  803472:	e8 75 04 00 00       	call   8038ec <_Z7pagerefPv>
  803477:	39 c3                	cmp    %eax,%ebx
  803479:	0f 94 c0             	sete   %al
  80347c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80347f:	8b 15 00 60 80 00    	mov    0x806000,%edx
  803485:	8b 52 58             	mov    0x58(%edx),%edx
  803488:	39 d6                	cmp    %edx,%esi
  80348a:	75 08                	jne    803494 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  80348c:	83 c4 2c             	add    $0x2c,%esp
  80348f:	5b                   	pop    %ebx
  803490:	5e                   	pop    %esi
  803491:	5f                   	pop    %edi
  803492:	5d                   	pop    %ebp
  803493:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803494:	85 c0                	test   %eax,%eax
  803496:	74 c2                	je     80345a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803498:	c7 04 24 32 4e 80 00 	movl   $0x804e32,(%esp)
  80349f:	e8 86 cd ff ff       	call   80022a <_Z7cprintfPKcz>
  8034a4:	eb b4                	jmp    80345a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

008034a6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034a6:	55                   	push   %ebp
  8034a7:	89 e5                	mov    %esp,%ebp
  8034a9:	57                   	push   %edi
  8034aa:	56                   	push   %esi
  8034ab:	53                   	push   %ebx
  8034ac:	83 ec 1c             	sub    $0x1c,%esp
  8034af:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8034b2:	89 34 24             	mov    %esi,(%esp)
  8034b5:	e8 c2 e3 ff ff       	call   80187c <_Z7fd2dataP2Fd>
  8034ba:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8034bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8034c5:	75 46                	jne    80350d <_ZL13devpipe_writeP2FdPKvj+0x67>
  8034c7:	eb 52                	jmp    80351b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  8034c9:	89 da                	mov    %ebx,%edx
  8034cb:	89 f0                	mov    %esi,%eax
  8034cd:	e8 7a ff ff ff       	call   80344c <_ZL13_pipeisclosedP2FdP4Pipe>
  8034d2:	85 c0                	test   %eax,%eax
  8034d4:	75 49                	jne    80351f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  8034d6:	e8 21 d8 ff ff       	call   800cfc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  8034db:	8b 43 04             	mov    0x4(%ebx),%eax
  8034de:	89 c2                	mov    %eax,%edx
  8034e0:	2b 13                	sub    (%ebx),%edx
  8034e2:	83 fa 20             	cmp    $0x20,%edx
  8034e5:	74 e2                	je     8034c9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8034e7:	89 c2                	mov    %eax,%edx
  8034e9:	c1 fa 1f             	sar    $0x1f,%edx
  8034ec:	c1 ea 1b             	shr    $0x1b,%edx
  8034ef:	01 d0                	add    %edx,%eax
  8034f1:	83 e0 1f             	and    $0x1f,%eax
  8034f4:	29 d0                	sub    %edx,%eax
  8034f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8034f9:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  8034fd:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803501:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803505:	83 c7 01             	add    $0x1,%edi
  803508:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80350b:	76 0e                	jbe    80351b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80350d:	8b 43 04             	mov    0x4(%ebx),%eax
  803510:	89 c2                	mov    %eax,%edx
  803512:	2b 13                	sub    (%ebx),%edx
  803514:	83 fa 20             	cmp    $0x20,%edx
  803517:	74 b0                	je     8034c9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803519:	eb cc                	jmp    8034e7 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80351b:	89 f8                	mov    %edi,%eax
  80351d:	eb 05                	jmp    803524 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80351f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803524:	83 c4 1c             	add    $0x1c,%esp
  803527:	5b                   	pop    %ebx
  803528:	5e                   	pop    %esi
  803529:	5f                   	pop    %edi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    

0080352c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80352c:	55                   	push   %ebp
  80352d:	89 e5                	mov    %esp,%ebp
  80352f:	83 ec 28             	sub    $0x28,%esp
  803532:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803535:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803538:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80353b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80353e:	89 3c 24             	mov    %edi,(%esp)
  803541:	e8 36 e3 ff ff       	call   80187c <_Z7fd2dataP2Fd>
  803546:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803548:	be 00 00 00 00       	mov    $0x0,%esi
  80354d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803551:	75 47                	jne    80359a <_ZL12devpipe_readP2FdPvj+0x6e>
  803553:	eb 52                	jmp    8035a7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803555:	89 f0                	mov    %esi,%eax
  803557:	eb 5e                	jmp    8035b7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803559:	89 da                	mov    %ebx,%edx
  80355b:	89 f8                	mov    %edi,%eax
  80355d:	8d 76 00             	lea    0x0(%esi),%esi
  803560:	e8 e7 fe ff ff       	call   80344c <_ZL13_pipeisclosedP2FdP4Pipe>
  803565:	85 c0                	test   %eax,%eax
  803567:	75 49                	jne    8035b2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803569:	e8 8e d7 ff ff       	call   800cfc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80356e:	8b 03                	mov    (%ebx),%eax
  803570:	3b 43 04             	cmp    0x4(%ebx),%eax
  803573:	74 e4                	je     803559 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803575:	89 c2                	mov    %eax,%edx
  803577:	c1 fa 1f             	sar    $0x1f,%edx
  80357a:	c1 ea 1b             	shr    $0x1b,%edx
  80357d:	01 d0                	add    %edx,%eax
  80357f:	83 e0 1f             	and    $0x1f,%eax
  803582:	29 d0                	sub    %edx,%eax
  803584:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80358f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803592:	83 c6 01             	add    $0x1,%esi
  803595:	39 75 10             	cmp    %esi,0x10(%ebp)
  803598:	76 0d                	jbe    8035a7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80359a:	8b 03                	mov    (%ebx),%eax
  80359c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80359f:	75 d4                	jne    803575 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8035a1:	85 f6                	test   %esi,%esi
  8035a3:	75 b0                	jne    803555 <_ZL12devpipe_readP2FdPvj+0x29>
  8035a5:	eb b2                	jmp    803559 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8035a7:	89 f0                	mov    %esi,%eax
  8035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8035b0:	eb 05                	jmp    8035b7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8035b2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8035b7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8035ba:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8035bd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8035c0:	89 ec                	mov    %ebp,%esp
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    

008035c4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8035c4:	55                   	push   %ebp
  8035c5:	89 e5                	mov    %esp,%ebp
  8035c7:	83 ec 48             	sub    $0x48,%esp
  8035ca:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8035cd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8035d0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8035d3:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  8035d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8035d9:	89 04 24             	mov    %eax,(%esp)
  8035dc:	e8 b6 e2 ff ff       	call   801897 <_Z14fd_find_unusedPP2Fd>
  8035e1:	89 c3                	mov    %eax,%ebx
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	0f 88 0b 01 00 00    	js     8036f6 <_Z4pipePi+0x132>
  8035eb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8035f2:	00 
  8035f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803601:	e8 2a d7 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803606:	89 c3                	mov    %eax,%ebx
  803608:	85 c0                	test   %eax,%eax
  80360a:	0f 89 f5 00 00 00    	jns    803705 <_Z4pipePi+0x141>
  803610:	e9 e1 00 00 00       	jmp    8036f6 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803615:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80361c:	00 
  80361d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803620:	89 44 24 04          	mov    %eax,0x4(%esp)
  803624:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80362b:	e8 00 d7 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803630:	89 c3                	mov    %eax,%ebx
  803632:	85 c0                	test   %eax,%eax
  803634:	0f 89 e2 00 00 00    	jns    80371c <_Z4pipePi+0x158>
  80363a:	e9 a4 00 00 00       	jmp    8036e3 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80363f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803642:	89 04 24             	mov    %eax,(%esp)
  803645:	e8 32 e2 ff ff       	call   80187c <_Z7fd2dataP2Fd>
  80364a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803651:	00 
  803652:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803656:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80365d:	00 
  80365e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803662:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803669:	e8 21 d7 ff ff       	call   800d8f <_Z12sys_page_mapiPviS_i>
  80366e:	89 c3                	mov    %eax,%ebx
  803670:	85 c0                	test   %eax,%eax
  803672:	78 4c                	js     8036c0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803674:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80367a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80367f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803682:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803689:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80368f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803692:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803694:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803697:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80369e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a1:	89 04 24             	mov    %eax,(%esp)
  8036a4:	e8 8b e1 ff ff       	call   801834 <_Z6fd2numP2Fd>
  8036a9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8036ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036ae:	89 04 24             	mov    %eax,(%esp)
  8036b1:	e8 7e e1 ff ff       	call   801834 <_Z6fd2numP2Fd>
  8036b6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8036b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8036be:	eb 36                	jmp    8036f6 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  8036c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8036c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036cb:	e8 1d d7 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  8036d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036de:	e8 0a d7 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  8036e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036f1:	e8 f7 d6 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  8036f6:	89 d8                	mov    %ebx,%eax
  8036f8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8036fb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8036fe:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803701:	89 ec                	mov    %ebp,%esp
  803703:	5d                   	pop    %ebp
  803704:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803705:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803708:	89 04 24             	mov    %eax,(%esp)
  80370b:	e8 87 e1 ff ff       	call   801897 <_Z14fd_find_unusedPP2Fd>
  803710:	89 c3                	mov    %eax,%ebx
  803712:	85 c0                	test   %eax,%eax
  803714:	0f 89 fb fe ff ff    	jns    803615 <_Z4pipePi+0x51>
  80371a:	eb c7                	jmp    8036e3 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80371c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371f:	89 04 24             	mov    %eax,(%esp)
  803722:	e8 55 e1 ff ff       	call   80187c <_Z7fd2dataP2Fd>
  803727:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803729:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803730:	00 
  803731:	89 44 24 04          	mov    %eax,0x4(%esp)
  803735:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80373c:	e8 ef d5 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803741:	89 c3                	mov    %eax,%ebx
  803743:	85 c0                	test   %eax,%eax
  803745:	0f 89 f4 fe ff ff    	jns    80363f <_Z4pipePi+0x7b>
  80374b:	eb 83                	jmp    8036d0 <_Z4pipePi+0x10c>

0080374d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80374d:	55                   	push   %ebp
  80374e:	89 e5                	mov    %esp,%ebp
  803750:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803753:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80375a:	00 
  80375b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80375e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	89 04 24             	mov    %eax,(%esp)
  803768:	e8 74 e0 ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  80376d:	85 c0                	test   %eax,%eax
  80376f:	78 15                	js     803786 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803774:	89 04 24             	mov    %eax,(%esp)
  803777:	e8 00 e1 ff ff       	call   80187c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80377c:	89 c2                	mov    %eax,%edx
  80377e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803781:	e8 c6 fc ff ff       	call   80344c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803786:	c9                   	leave  
  803787:	c3                   	ret    

00803788 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803788:	55                   	push   %ebp
  803789:	89 e5                	mov    %esp,%ebp
  80378b:	53                   	push   %ebx
  80378c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80378f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803792:	89 04 24             	mov    %eax,(%esp)
  803795:	e8 fd e0 ff ff       	call   801897 <_Z14fd_find_unusedPP2Fd>
  80379a:	89 c3                	mov    %eax,%ebx
  80379c:	85 c0                	test   %eax,%eax
  80379e:	0f 88 be 00 00 00    	js     803862 <_Z18pipe_ipc_recv_readv+0xda>
  8037a4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8037ab:	00 
  8037ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037ba:	e8 71 d5 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  8037bf:	89 c3                	mov    %eax,%ebx
  8037c1:	85 c0                	test   %eax,%eax
  8037c3:	0f 89 a1 00 00 00    	jns    80386a <_Z18pipe_ipc_recv_readv+0xe2>
  8037c9:	e9 94 00 00 00       	jmp    803862 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  8037ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d1:	85 c0                	test   %eax,%eax
  8037d3:	75 0e                	jne    8037e3 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  8037d5:	c7 04 24 90 4e 80 00 	movl   $0x804e90,(%esp)
  8037dc:	e8 49 ca ff ff       	call   80022a <_Z7cprintfPKcz>
  8037e1:	eb 10                	jmp    8037f3 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  8037e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037e7:	c7 04 24 45 4e 80 00 	movl   $0x804e45,(%esp)
  8037ee:	e8 37 ca ff ff       	call   80022a <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  8037f3:	c7 04 24 4f 4e 80 00 	movl   $0x804e4f,(%esp)
  8037fa:	e8 2b ca ff ff       	call   80022a <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  8037ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803802:	a8 04                	test   $0x4,%al
  803804:	74 04                	je     80380a <_Z18pipe_ipc_recv_readv+0x82>
  803806:	a8 01                	test   $0x1,%al
  803808:	75 24                	jne    80382e <_Z18pipe_ipc_recv_readv+0xa6>
  80380a:	c7 44 24 0c 62 4e 80 	movl   $0x804e62,0xc(%esp)
  803811:	00 
  803812:	c7 44 24 08 2b 48 80 	movl   $0x80482b,0x8(%esp)
  803819:	00 
  80381a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803821:	00 
  803822:	c7 04 24 7f 4e 80 00 	movl   $0x804e7f,(%esp)
  803829:	e8 8e 07 00 00       	call   803fbc <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80382e:	8b 15 20 50 80 00    	mov    0x805020,%edx
  803834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803837:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803843:	89 04 24             	mov    %eax,(%esp)
  803846:	e8 e9 df ff ff       	call   801834 <_Z6fd2numP2Fd>
  80384b:	89 c3                	mov    %eax,%ebx
  80384d:	eb 13                	jmp    803862 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80384f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803852:	89 44 24 04          	mov    %eax,0x4(%esp)
  803856:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80385d:	e8 8b d5 ff ff       	call   800ded <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803862:	89 d8                	mov    %ebx,%eax
  803864:	83 c4 24             	add    $0x24,%esp
  803867:	5b                   	pop    %ebx
  803868:	5d                   	pop    %ebp
  803869:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80386a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386d:	89 04 24             	mov    %eax,(%esp)
  803870:	e8 07 e0 ff ff       	call   80187c <_Z7fd2dataP2Fd>
  803875:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803878:	89 54 24 08          	mov    %edx,0x8(%esp)
  80387c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803880:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803883:	89 04 24             	mov    %eax,(%esp)
  803886:	e8 d5 dd ff ff       	call   801660 <_Z8ipc_recvPiPvS_>
  80388b:	89 c3                	mov    %eax,%ebx
  80388d:	85 c0                	test   %eax,%eax
  80388f:	0f 89 39 ff ff ff    	jns    8037ce <_Z18pipe_ipc_recv_readv+0x46>
  803895:	eb b8                	jmp    80384f <_Z18pipe_ipc_recv_readv+0xc7>

00803897 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803897:	55                   	push   %ebp
  803898:	89 e5                	mov    %esp,%ebp
  80389a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80389d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8038a4:	00 
  8038a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8038a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038af:	89 04 24             	mov    %eax,(%esp)
  8038b2:	e8 2a df ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  8038b7:	85 c0                	test   %eax,%eax
  8038b9:	78 2f                	js     8038ea <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  8038bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038be:	89 04 24             	mov    %eax,(%esp)
  8038c1:	e8 b6 df ff ff       	call   80187c <_Z7fd2dataP2Fd>
  8038c6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8038cd:	00 
  8038ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8038d9:	00 
  8038da:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dd:	89 04 24             	mov    %eax,(%esp)
  8038e0:	e8 0a de ff ff       	call   8016ef <_Z8ipc_sendijPvi>
    return 0;
  8038e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038ea:	c9                   	leave  
  8038eb:	c3                   	ret    

008038ec <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8038ec:	55                   	push   %ebp
  8038ed:	89 e5                	mov    %esp,%ebp
  8038ef:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8038f2:	89 d0                	mov    %edx,%eax
  8038f4:	c1 e8 16             	shr    $0x16,%eax
  8038f7:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  8038fe:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803903:	f6 c1 01             	test   $0x1,%cl
  803906:	74 1d                	je     803925 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803908:	c1 ea 0c             	shr    $0xc,%edx
  80390b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803912:	f6 c2 01             	test   $0x1,%dl
  803915:	74 0e                	je     803925 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803917:	c1 ea 0c             	shr    $0xc,%edx
  80391a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803921:	ef 
  803922:	0f b7 c0             	movzwl %ax,%eax
}
  803925:	5d                   	pop    %ebp
  803926:	c3                   	ret    
	...

00803930 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803930:	55                   	push   %ebp
  803931:	89 e5                	mov    %esp,%ebp
  803933:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803936:	c7 44 24 04 b3 4e 80 	movl   $0x804eb3,0x4(%esp)
  80393d:	00 
  80393e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803941:	89 04 24             	mov    %eax,(%esp)
  803944:	e8 01 cf ff ff       	call   80084a <_Z6strcpyPcPKc>
	return 0;
}
  803949:	b8 00 00 00 00       	mov    $0x0,%eax
  80394e:	c9                   	leave  
  80394f:	c3                   	ret    

00803950 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803950:	55                   	push   %ebp
  803951:	89 e5                	mov    %esp,%ebp
  803953:	53                   	push   %ebx
  803954:	83 ec 14             	sub    $0x14,%esp
  803957:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80395a:	89 1c 24             	mov    %ebx,(%esp)
  80395d:	e8 8a ff ff ff       	call   8038ec <_Z7pagerefPv>
  803962:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803964:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803969:	83 fa 01             	cmp    $0x1,%edx
  80396c:	75 0b                	jne    803979 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80396e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803971:	89 04 24             	mov    %eax,(%esp)
  803974:	e8 fe 02 00 00       	call   803c77 <_Z11nsipc_closei>
	else
		return 0;
}
  803979:	83 c4 14             	add    $0x14,%esp
  80397c:	5b                   	pop    %ebx
  80397d:	5d                   	pop    %ebp
  80397e:	c3                   	ret    

0080397f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80397f:	55                   	push   %ebp
  803980:	89 e5                	mov    %esp,%ebp
  803982:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803985:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80398c:	00 
  80398d:	8b 45 10             	mov    0x10(%ebp),%eax
  803990:	89 44 24 08          	mov    %eax,0x8(%esp)
  803994:	8b 45 0c             	mov    0xc(%ebp),%eax
  803997:	89 44 24 04          	mov    %eax,0x4(%esp)
  80399b:	8b 45 08             	mov    0x8(%ebp),%eax
  80399e:	8b 40 0c             	mov    0xc(%eax),%eax
  8039a1:	89 04 24             	mov    %eax,(%esp)
  8039a4:	e8 c9 03 00 00       	call   803d72 <_Z10nsipc_sendiPKvij>
}
  8039a9:	c9                   	leave  
  8039aa:	c3                   	ret    

008039ab <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8039ab:	55                   	push   %ebp
  8039ac:	89 e5                	mov    %esp,%ebp
  8039ae:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8039b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8039b8:	00 
  8039b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8039bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8039c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8039cd:	89 04 24             	mov    %eax,(%esp)
  8039d0:	e8 1d 03 00 00       	call   803cf2 <_Z10nsipc_recviPvij>
}
  8039d5:	c9                   	leave  
  8039d6:	c3                   	ret    

008039d7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8039d7:	55                   	push   %ebp
  8039d8:	89 e5                	mov    %esp,%ebp
  8039da:	83 ec 28             	sub    $0x28,%esp
  8039dd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8039e0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8039e3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  8039e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8039e8:	89 04 24             	mov    %eax,(%esp)
  8039eb:	e8 a7 de ff ff       	call   801897 <_Z14fd_find_unusedPP2Fd>
  8039f0:	89 c3                	mov    %eax,%ebx
  8039f2:	85 c0                	test   %eax,%eax
  8039f4:	78 21                	js     803a17 <_ZL12alloc_sockfdi+0x40>
  8039f6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8039fd:	00 
  8039fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a0c:	e8 1f d3 ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803a11:	89 c3                	mov    %eax,%ebx
  803a13:	85 c0                	test   %eax,%eax
  803a15:	79 14                	jns    803a2b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803a17:	89 34 24             	mov    %esi,(%esp)
  803a1a:	e8 58 02 00 00       	call   803c77 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803a1f:	89 d8                	mov    %ebx,%eax
  803a21:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803a24:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803a27:	89 ec                	mov    %ebp,%esp
  803a29:	5d                   	pop    %ebp
  803a2a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803a2b:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a34:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a39:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803a40:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803a43:	89 04 24             	mov    %eax,(%esp)
  803a46:	e8 e9 dd ff ff       	call   801834 <_Z6fd2numP2Fd>
  803a4b:	89 c3                	mov    %eax,%ebx
  803a4d:	eb d0                	jmp    803a1f <_ZL12alloc_sockfdi+0x48>

00803a4f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803a4f:	55                   	push   %ebp
  803a50:	89 e5                	mov    %esp,%ebp
  803a52:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803a55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803a5c:	00 
  803a5d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803a60:	89 54 24 04          	mov    %edx,0x4(%esp)
  803a64:	89 04 24             	mov    %eax,(%esp)
  803a67:	e8 75 dd ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  803a6c:	85 c0                	test   %eax,%eax
  803a6e:	78 15                	js     803a85 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803a73:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803a78:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  803a7e:	39 0a                	cmp    %ecx,(%edx)
  803a80:	75 03                	jne    803a85 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803a82:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803a85:	c9                   	leave  
  803a86:	c3                   	ret    

00803a87 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a87:	55                   	push   %ebp
  803a88:	89 e5                	mov    %esp,%ebp
  803a8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a90:	e8 ba ff ff ff       	call   803a4f <_ZL9fd2sockidi>
  803a95:	85 c0                	test   %eax,%eax
  803a97:	78 1f                	js     803ab8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803a99:	8b 55 10             	mov    0x10(%ebp),%edx
  803a9c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803aa3:	89 54 24 04          	mov    %edx,0x4(%esp)
  803aa7:	89 04 24             	mov    %eax,(%esp)
  803aaa:	e8 19 01 00 00       	call   803bc8 <_Z12nsipc_acceptiP8sockaddrPj>
  803aaf:	85 c0                	test   %eax,%eax
  803ab1:	78 05                	js     803ab8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803ab3:	e8 1f ff ff ff       	call   8039d7 <_ZL12alloc_sockfdi>
}
  803ab8:	c9                   	leave  
  803ab9:	c3                   	ret    

00803aba <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803aba:	55                   	push   %ebp
  803abb:	89 e5                	mov    %esp,%ebp
  803abd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac3:	e8 87 ff ff ff       	call   803a4f <_ZL9fd2sockidi>
  803ac8:	85 c0                	test   %eax,%eax
  803aca:	78 16                	js     803ae2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803acc:	8b 55 10             	mov    0x10(%ebp),%edx
  803acf:	89 54 24 08          	mov    %edx,0x8(%esp)
  803ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ad6:	89 54 24 04          	mov    %edx,0x4(%esp)
  803ada:	89 04 24             	mov    %eax,(%esp)
  803add:	e8 34 01 00 00       	call   803c16 <_Z10nsipc_bindiP8sockaddrj>
}
  803ae2:	c9                   	leave  
  803ae3:	c3                   	ret    

00803ae4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803ae4:	55                   	push   %ebp
  803ae5:	89 e5                	mov    %esp,%ebp
  803ae7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803aea:	8b 45 08             	mov    0x8(%ebp),%eax
  803aed:	e8 5d ff ff ff       	call   803a4f <_ZL9fd2sockidi>
  803af2:	85 c0                	test   %eax,%eax
  803af4:	78 0f                	js     803b05 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803af9:	89 54 24 04          	mov    %edx,0x4(%esp)
  803afd:	89 04 24             	mov    %eax,(%esp)
  803b00:	e8 50 01 00 00       	call   803c55 <_Z14nsipc_shutdownii>
}
  803b05:	c9                   	leave  
  803b06:	c3                   	ret    

00803b07 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b07:	55                   	push   %ebp
  803b08:	89 e5                	mov    %esp,%ebp
  803b0a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b10:	e8 3a ff ff ff       	call   803a4f <_ZL9fd2sockidi>
  803b15:	85 c0                	test   %eax,%eax
  803b17:	78 16                	js     803b2f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803b19:	8b 55 10             	mov    0x10(%ebp),%edx
  803b1c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b23:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b27:	89 04 24             	mov    %eax,(%esp)
  803b2a:	e8 62 01 00 00       	call   803c91 <_Z13nsipc_connectiPK8sockaddrj>
}
  803b2f:	c9                   	leave  
  803b30:	c3                   	ret    

00803b31 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803b31:	55                   	push   %ebp
  803b32:	89 e5                	mov    %esp,%ebp
  803b34:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b37:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3a:	e8 10 ff ff ff       	call   803a4f <_ZL9fd2sockidi>
  803b3f:	85 c0                	test   %eax,%eax
  803b41:	78 0f                	js     803b52 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  803b46:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b4a:	89 04 24             	mov    %eax,(%esp)
  803b4d:	e8 7e 01 00 00       	call   803cd0 <_Z12nsipc_listenii>
}
  803b52:	c9                   	leave  
  803b53:	c3                   	ret    

00803b54 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803b54:	55                   	push   %ebp
  803b55:	89 e5                	mov    %esp,%ebp
  803b57:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803b5a:	8b 45 10             	mov    0x10(%ebp),%eax
  803b5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b68:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6b:	89 04 24             	mov    %eax,(%esp)
  803b6e:	e8 72 02 00 00       	call   803de5 <_Z12nsipc_socketiii>
  803b73:	85 c0                	test   %eax,%eax
  803b75:	78 05                	js     803b7c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803b77:	e8 5b fe ff ff       	call   8039d7 <_ZL12alloc_sockfdi>
}
  803b7c:	c9                   	leave  
  803b7d:	8d 76 00             	lea    0x0(%esi),%esi
  803b80:	c3                   	ret    
  803b81:	00 00                	add    %al,(%eax)
	...

00803b84 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803b84:	55                   	push   %ebp
  803b85:	89 e5                	mov    %esp,%ebp
  803b87:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803b8a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803b91:	00 
  803b92:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803b99:	00 
  803b9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b9e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803ba5:	e8 45 db ff ff       	call   8016ef <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803baa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803bb1:	00 
  803bb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803bb9:	00 
  803bba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803bc1:	e8 9a da ff ff       	call   801660 <_Z8ipc_recvPiPvS_>
}
  803bc6:	c9                   	leave  
  803bc7:	c3                   	ret    

00803bc8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803bc8:	55                   	push   %ebp
  803bc9:	89 e5                	mov    %esp,%ebp
  803bcb:	53                   	push   %ebx
  803bcc:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd2:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803bd7:	b8 01 00 00 00       	mov    $0x1,%eax
  803bdc:	e8 a3 ff ff ff       	call   803b84 <_ZL5nsipcj>
  803be1:	89 c3                	mov    %eax,%ebx
  803be3:	85 c0                	test   %eax,%eax
  803be5:	78 27                	js     803c0e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803be7:	a1 10 70 80 00       	mov    0x807010,%eax
  803bec:	89 44 24 08          	mov    %eax,0x8(%esp)
  803bf0:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803bf7:	00 
  803bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bfb:	89 04 24             	mov    %eax,(%esp)
  803bfe:	e8 e9 cd ff ff       	call   8009ec <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803c03:	8b 15 10 70 80 00    	mov    0x807010,%edx
  803c09:	8b 45 10             	mov    0x10(%ebp),%eax
  803c0c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803c0e:	89 d8                	mov    %ebx,%eax
  803c10:	83 c4 14             	add    $0x14,%esp
  803c13:	5b                   	pop    %ebx
  803c14:	5d                   	pop    %ebp
  803c15:	c3                   	ret    

00803c16 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c16:	55                   	push   %ebp
  803c17:	89 e5                	mov    %esp,%ebp
  803c19:	53                   	push   %ebx
  803c1a:	83 ec 14             	sub    $0x14,%esp
  803c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803c20:	8b 45 08             	mov    0x8(%ebp),%eax
  803c23:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c33:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803c3a:	e8 ad cd ff ff       	call   8009ec <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803c3f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803c45:	b8 02 00 00 00       	mov    $0x2,%eax
  803c4a:	e8 35 ff ff ff       	call   803b84 <_ZL5nsipcj>
}
  803c4f:	83 c4 14             	add    $0x14,%esp
  803c52:	5b                   	pop    %ebx
  803c53:	5d                   	pop    %ebp
  803c54:	c3                   	ret    

00803c55 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803c55:	55                   	push   %ebp
  803c56:	89 e5                	mov    %esp,%ebp
  803c58:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803c63:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c66:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  803c6b:	b8 03 00 00 00       	mov    $0x3,%eax
  803c70:	e8 0f ff ff ff       	call   803b84 <_ZL5nsipcj>
}
  803c75:	c9                   	leave  
  803c76:	c3                   	ret    

00803c77 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803c77:	55                   	push   %ebp
  803c78:	89 e5                	mov    %esp,%ebp
  803c7a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c80:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803c85:	b8 04 00 00 00       	mov    $0x4,%eax
  803c8a:	e8 f5 fe ff ff       	call   803b84 <_ZL5nsipcj>
}
  803c8f:	c9                   	leave  
  803c90:	c3                   	ret    

00803c91 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c91:	55                   	push   %ebp
  803c92:	89 e5                	mov    %esp,%ebp
  803c94:	53                   	push   %ebx
  803c95:	83 ec 14             	sub    $0x14,%esp
  803c98:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ca3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803caa:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cae:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803cb5:	e8 32 cd ff ff       	call   8009ec <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803cba:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803cc0:	b8 05 00 00 00       	mov    $0x5,%eax
  803cc5:	e8 ba fe ff ff       	call   803b84 <_ZL5nsipcj>
}
  803cca:	83 c4 14             	add    $0x14,%esp
  803ccd:	5b                   	pop    %ebx
  803cce:	5d                   	pop    %ebp
  803ccf:	c3                   	ret    

00803cd0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803cd0:	55                   	push   %ebp
  803cd1:	89 e5                	mov    %esp,%ebp
  803cd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  803cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803ce6:	b8 06 00 00 00       	mov    $0x6,%eax
  803ceb:	e8 94 fe ff ff       	call   803b84 <_ZL5nsipcj>
}
  803cf0:	c9                   	leave  
  803cf1:	c3                   	ret    

00803cf2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803cf2:	55                   	push   %ebp
  803cf3:	89 e5                	mov    %esp,%ebp
  803cf5:	56                   	push   %esi
  803cf6:	53                   	push   %ebx
  803cf7:	83 ec 10             	sub    $0x10,%esp
  803cfa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803d00:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803d05:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  803d0b:	8b 45 14             	mov    0x14(%ebp),%eax
  803d0e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d13:	b8 07 00 00 00       	mov    $0x7,%eax
  803d18:	e8 67 fe ff ff       	call   803b84 <_ZL5nsipcj>
  803d1d:	89 c3                	mov    %eax,%ebx
  803d1f:	85 c0                	test   %eax,%eax
  803d21:	78 46                	js     803d69 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803d23:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803d28:	7f 04                	jg     803d2e <_Z10nsipc_recviPvij+0x3c>
  803d2a:	39 f0                	cmp    %esi,%eax
  803d2c:	7e 24                	jle    803d52 <_Z10nsipc_recviPvij+0x60>
  803d2e:	c7 44 24 0c bf 4e 80 	movl   $0x804ebf,0xc(%esp)
  803d35:	00 
  803d36:	c7 44 24 08 2b 48 80 	movl   $0x80482b,0x8(%esp)
  803d3d:	00 
  803d3e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803d45:	00 
  803d46:	c7 04 24 d4 4e 80 00 	movl   $0x804ed4,(%esp)
  803d4d:	e8 6a 02 00 00       	call   803fbc <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d52:	89 44 24 08          	mov    %eax,0x8(%esp)
  803d56:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803d5d:	00 
  803d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d61:	89 04 24             	mov    %eax,(%esp)
  803d64:	e8 83 cc ff ff       	call   8009ec <memmove>
	}

	return r;
}
  803d69:	89 d8                	mov    %ebx,%eax
  803d6b:	83 c4 10             	add    $0x10,%esp
  803d6e:	5b                   	pop    %ebx
  803d6f:	5e                   	pop    %esi
  803d70:	5d                   	pop    %ebp
  803d71:	c3                   	ret    

00803d72 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d72:	55                   	push   %ebp
  803d73:	89 e5                	mov    %esp,%ebp
  803d75:	53                   	push   %ebx
  803d76:	83 ec 14             	sub    $0x14,%esp
  803d79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803d84:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803d8a:	7e 24                	jle    803db0 <_Z10nsipc_sendiPKvij+0x3e>
  803d8c:	c7 44 24 0c e0 4e 80 	movl   $0x804ee0,0xc(%esp)
  803d93:	00 
  803d94:	c7 44 24 08 2b 48 80 	movl   $0x80482b,0x8(%esp)
  803d9b:	00 
  803d9c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803da3:	00 
  803da4:	c7 04 24 d4 4e 80 00 	movl   $0x804ed4,(%esp)
  803dab:	e8 0c 02 00 00       	call   803fbc <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803db0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803db7:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dbb:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803dc2:	e8 25 cc ff ff       	call   8009ec <memmove>
	nsipcbuf.send.req_size = size;
  803dc7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  803dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  803dd0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803dd5:	b8 08 00 00 00       	mov    $0x8,%eax
  803dda:	e8 a5 fd ff ff       	call   803b84 <_ZL5nsipcj>
}
  803ddf:	83 c4 14             	add    $0x14,%esp
  803de2:	5b                   	pop    %ebx
  803de3:	5d                   	pop    %ebp
  803de4:	c3                   	ret    

00803de5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803de5:	55                   	push   %ebp
  803de6:	89 e5                	mov    %esp,%ebp
  803de8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803deb:	8b 45 08             	mov    0x8(%ebp),%eax
  803dee:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803df6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  803dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  803dfe:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803e03:	b8 09 00 00 00       	mov    $0x9,%eax
  803e08:	e8 77 fd ff ff       	call   803b84 <_ZL5nsipcj>
}
  803e0d:	c9                   	leave  
  803e0e:	c3                   	ret    
	...

00803e10 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803e10:	55                   	push   %ebp
  803e11:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803e13:	b8 00 00 00 00       	mov    $0x0,%eax
  803e18:	5d                   	pop    %ebp
  803e19:	c3                   	ret    

00803e1a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e1a:	55                   	push   %ebp
  803e1b:	89 e5                	mov    %esp,%ebp
  803e1d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803e20:	c7 44 24 04 ec 4e 80 	movl   $0x804eec,0x4(%esp)
  803e27:	00 
  803e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e2b:	89 04 24             	mov    %eax,(%esp)
  803e2e:	e8 17 ca ff ff       	call   80084a <_Z6strcpyPcPKc>
	return 0;
}
  803e33:	b8 00 00 00 00       	mov    $0x0,%eax
  803e38:	c9                   	leave  
  803e39:	c3                   	ret    

00803e3a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e3a:	55                   	push   %ebp
  803e3b:	89 e5                	mov    %esp,%ebp
  803e3d:	57                   	push   %edi
  803e3e:	56                   	push   %esi
  803e3f:	53                   	push   %ebx
  803e40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e46:	bb 00 00 00 00       	mov    $0x0,%ebx
  803e4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e4f:	74 3e                	je     803e8f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803e51:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803e57:	8b 75 10             	mov    0x10(%ebp),%esi
  803e5a:	29 de                	sub    %ebx,%esi
  803e5c:	83 fe 7f             	cmp    $0x7f,%esi
  803e5f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803e64:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803e67:	89 74 24 08          	mov    %esi,0x8(%esp)
  803e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e6e:	01 d8                	add    %ebx,%eax
  803e70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e74:	89 3c 24             	mov    %edi,(%esp)
  803e77:	e8 70 cb ff ff       	call   8009ec <memmove>
		sys_cputs(buf, m);
  803e7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803e80:	89 3c 24             	mov    %edi,(%esp)
  803e83:	e8 7c cd ff ff       	call   800c04 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e88:	01 f3                	add    %esi,%ebx
  803e8a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803e8d:	77 c8                	ja     803e57 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803e8f:	89 d8                	mov    %ebx,%eax
  803e91:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803e97:	5b                   	pop    %ebx
  803e98:	5e                   	pop    %esi
  803e99:	5f                   	pop    %edi
  803e9a:	5d                   	pop    %ebp
  803e9b:	c3                   	ret    

00803e9c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e9c:	55                   	push   %ebp
  803e9d:	89 e5                	mov    %esp,%ebp
  803e9f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803ea2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803eab:	75 07                	jne    803eb4 <_ZL12devcons_readP2FdPvj+0x18>
  803ead:	eb 2a                	jmp    803ed9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803eaf:	e8 48 ce ff ff       	call   800cfc <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803eb4:	e8 7e cd ff ff       	call   800c37 <_Z9sys_cgetcv>
  803eb9:	85 c0                	test   %eax,%eax
  803ebb:	74 f2                	je     803eaf <_ZL12devcons_readP2FdPvj+0x13>
  803ebd:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803ebf:	85 c0                	test   %eax,%eax
  803ec1:	78 16                	js     803ed9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803ec3:	83 f8 04             	cmp    $0x4,%eax
  803ec6:	74 0c                	je     803ed4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ecb:	88 10                	mov    %dl,(%eax)
	return 1;
  803ecd:	b8 01 00 00 00       	mov    $0x1,%eax
  803ed2:	eb 05                	jmp    803ed9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803ed4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803ed9:	c9                   	leave  
  803eda:	c3                   	ret    

00803edb <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803edb:	55                   	push   %ebp
  803edc:	89 e5                	mov    %esp,%ebp
  803ede:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ee7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803eee:	00 
  803eef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803ef2:	89 04 24             	mov    %eax,(%esp)
  803ef5:	e8 0a cd ff ff       	call   800c04 <_Z9sys_cputsPKcj>
}
  803efa:	c9                   	leave  
  803efb:	c3                   	ret    

00803efc <_Z7getcharv>:

int
getchar(void)
{
  803efc:	55                   	push   %ebp
  803efd:	89 e5                	mov    %esp,%ebp
  803eff:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803f02:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803f09:	00 
  803f0a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f18:	e8 71 dc ff ff       	call   801b8e <_Z4readiPvj>
	if (r < 0)
  803f1d:	85 c0                	test   %eax,%eax
  803f1f:	78 0f                	js     803f30 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803f21:	85 c0                	test   %eax,%eax
  803f23:	7e 06                	jle    803f2b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803f25:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803f29:	eb 05                	jmp    803f30 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803f2b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803f30:	c9                   	leave  
  803f31:	c3                   	ret    

00803f32 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803f32:	55                   	push   %ebp
  803f33:	89 e5                	mov    %esp,%ebp
  803f35:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803f38:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803f3f:	00 
  803f40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f43:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f47:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4a:	89 04 24             	mov    %eax,(%esp)
  803f4d:	e8 8f d8 ff ff       	call   8017e1 <_Z9fd_lookupiPP2Fdb>
  803f52:	85 c0                	test   %eax,%eax
  803f54:	78 11                	js     803f67 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f59:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803f5f:	39 10                	cmp    %edx,(%eax)
  803f61:	0f 94 c0             	sete   %al
  803f64:	0f b6 c0             	movzbl %al,%eax
}
  803f67:	c9                   	leave  
  803f68:	c3                   	ret    

00803f69 <_Z8openconsv>:

int
opencons(void)
{
  803f69:	55                   	push   %ebp
  803f6a:	89 e5                	mov    %esp,%ebp
  803f6c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803f6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f72:	89 04 24             	mov    %eax,(%esp)
  803f75:	e8 1d d9 ff ff       	call   801897 <_Z14fd_find_unusedPP2Fd>
  803f7a:	85 c0                	test   %eax,%eax
  803f7c:	78 3c                	js     803fba <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f7e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f85:	00 
  803f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f89:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f94:	e8 97 cd ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  803f99:	85 c0                	test   %eax,%eax
  803f9b:	78 1d                	js     803fba <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803f9d:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803fb2:	89 04 24             	mov    %eax,(%esp)
  803fb5:	e8 7a d8 ff ff       	call   801834 <_Z6fd2numP2Fd>
}
  803fba:	c9                   	leave  
  803fbb:	c3                   	ret    

00803fbc <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803fbc:	55                   	push   %ebp
  803fbd:	89 e5                	mov    %esp,%ebp
  803fbf:	56                   	push   %esi
  803fc0:	53                   	push   %ebx
  803fc1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  803fc4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  803fc7:	a1 00 80 80 00       	mov    0x808000,%eax
  803fcc:	85 c0                	test   %eax,%eax
  803fce:	74 10                	je     803fe0 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  803fd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fd4:	c7 04 24 f8 4e 80 00 	movl   $0x804ef8,(%esp)
  803fdb:	e8 4a c2 ff ff       	call   80022a <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  803fe0:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  803fe6:	e8 dd cc ff ff       	call   800cc8 <_Z12sys_getenvidv>
  803feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  803fee:	89 54 24 10          	mov    %edx,0x10(%esp)
  803ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ff5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803ff9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
  804001:	c7 04 24 00 4f 80 00 	movl   $0x804f00,(%esp)
  804008:	e8 1d c2 ff ff       	call   80022a <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  80400d:	89 74 24 04          	mov    %esi,0x4(%esp)
  804011:	8b 45 10             	mov    0x10(%ebp),%eax
  804014:	89 04 24             	mov    %eax,(%esp)
  804017:	e8 ad c1 ff ff       	call   8001c9 <_Z8vcprintfPKcPc>
	cprintf("\n");
  80401c:	c7 04 24 43 4e 80 00 	movl   $0x804e43,(%esp)
  804023:	e8 02 c2 ff ff       	call   80022a <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804028:	cc                   	int3   
  804029:	eb fd                	jmp    804028 <_Z6_panicPKciS0_z+0x6c>
  80402b:	00 00                	add    %al,(%eax)
  80402d:	00 00                	add    %al,(%eax)
	...

00804030 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  804030:	55                   	push   %ebp
  804031:	89 e5                	mov    %esp,%ebp
  804033:	56                   	push   %esi
  804034:	53                   	push   %ebx
  804035:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804038:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  80403d:	8b 04 9d 20 80 80 00 	mov    0x808020(,%ebx,4),%eax
  804044:	85 c0                	test   %eax,%eax
  804046:	74 08                	je     804050 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  804048:	8d 55 08             	lea    0x8(%ebp),%edx
  80404b:	89 14 24             	mov    %edx,(%esp)
  80404e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804050:	83 eb 01             	sub    $0x1,%ebx
  804053:	83 fb ff             	cmp    $0xffffffff,%ebx
  804056:	75 e5                	jne    80403d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  804058:	8b 5d 38             	mov    0x38(%ebp),%ebx
  80405b:	8b 75 08             	mov    0x8(%ebp),%esi
  80405e:	e8 65 cc ff ff       	call   800cc8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  804063:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  804067:	89 74 24 10          	mov    %esi,0x10(%esp)
  80406b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80406f:	c7 44 24 08 24 4f 80 	movl   $0x804f24,0x8(%esp)
  804076:	00 
  804077:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80407e:	00 
  80407f:	c7 04 24 a8 4f 80 00 	movl   $0x804fa8,(%esp)
  804086:	e8 31 ff ff ff       	call   803fbc <_Z6_panicPKciS0_z>

0080408b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  80408b:	55                   	push   %ebp
  80408c:	89 e5                	mov    %esp,%ebp
  80408e:	56                   	push   %esi
  80408f:	53                   	push   %ebx
  804090:	83 ec 10             	sub    $0x10,%esp
  804093:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804096:	e8 2d cc ff ff       	call   800cc8 <_Z12sys_getenvidv>
  80409b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80409d:	a1 00 60 80 00       	mov    0x806000,%eax
  8040a2:	8b 40 5c             	mov    0x5c(%eax),%eax
  8040a5:	85 c0                	test   %eax,%eax
  8040a7:	75 4c                	jne    8040f5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  8040a9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8040b0:	00 
  8040b1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8040b8:	ee 
  8040b9:	89 34 24             	mov    %esi,(%esp)
  8040bc:	e8 6f cc ff ff       	call   800d30 <_Z14sys_page_allociPvi>
  8040c1:	85 c0                	test   %eax,%eax
  8040c3:	74 20                	je     8040e5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  8040c5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8040c9:	c7 44 24 08 5c 4f 80 	movl   $0x804f5c,0x8(%esp)
  8040d0:	00 
  8040d1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8040d8:	00 
  8040d9:	c7 04 24 a8 4f 80 00 	movl   $0x804fa8,(%esp)
  8040e0:	e8 d7 fe ff ff       	call   803fbc <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  8040e5:	c7 44 24 04 30 40 80 	movl   $0x804030,0x4(%esp)
  8040ec:	00 
  8040ed:	89 34 24             	mov    %esi,(%esp)
  8040f0:	e8 70 ce ff ff       	call   800f65 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  8040f5:	a1 20 80 80 00       	mov    0x808020,%eax
  8040fa:	39 d8                	cmp    %ebx,%eax
  8040fc:	74 1a                	je     804118 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  8040fe:	85 c0                	test   %eax,%eax
  804100:	74 20                	je     804122 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804102:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804107:	8b 14 85 20 80 80 00 	mov    0x808020(,%eax,4),%edx
  80410e:	39 da                	cmp    %ebx,%edx
  804110:	74 15                	je     804127 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804112:	85 d2                	test   %edx,%edx
  804114:	75 1f                	jne    804135 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804116:	eb 0f                	jmp    804127 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804118:	b8 00 00 00 00       	mov    $0x0,%eax
  80411d:	8d 76 00             	lea    0x0(%esi),%esi
  804120:	eb 05                	jmp    804127 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804122:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804127:	89 1c 85 20 80 80 00 	mov    %ebx,0x808020(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80412e:	83 c4 10             	add    $0x10,%esp
  804131:	5b                   	pop    %ebx
  804132:	5e                   	pop    %esi
  804133:	5d                   	pop    %ebp
  804134:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804135:	83 c0 01             	add    $0x1,%eax
  804138:	83 f8 08             	cmp    $0x8,%eax
  80413b:	75 ca                	jne    804107 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80413d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804141:	c7 44 24 08 80 4f 80 	movl   $0x804f80,0x8(%esp)
  804148:	00 
  804149:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804150:	00 
  804151:	c7 04 24 a8 4f 80 00 	movl   $0x804fa8,(%esp)
  804158:	e8 5f fe ff ff       	call   803fbc <_Z6_panicPKciS0_z>
  80415d:	00 00                	add    %al,(%eax)
	...

00804160 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  804160:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  804163:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  804164:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  804167:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  80416b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  80416f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  804172:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  804174:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  804178:	61                   	popa   
    popf
  804179:	9d                   	popf   
    popl %esp
  80417a:	5c                   	pop    %esp
    ret
  80417b:	c3                   	ret    

0080417c <spin>:

spin:	jmp spin
  80417c:	eb fe                	jmp    80417c <spin>
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
