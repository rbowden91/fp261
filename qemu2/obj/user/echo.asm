
obj/user/echo:     file format elf32-i386


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
  80002c:	e8 eb 00 00 00       	call   80011c <libmain>
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
  80003d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800040:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;
	cprintf("[%08x] echo\n", thisenv->env_id);
  800043:	a1 00 60 80 00       	mov    0x806000,%eax
  800048:	8b 40 04             	mov    0x4(%eax),%eax
  80004b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004f:	c7 04 24 20 3f 80 00 	movl   $0x803f20,(%esp)
  800056:	e8 f3 01 00 00       	call   80024e <_Z7cprintfPKcz>

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80005b:	83 ff 01             	cmp    $0x1,%edi
  80005e:	0f 8e a4 00 00 00    	jle    800108 <_Z5umainiPPc+0xd4>
  800064:	8d 5e 04             	lea    0x4(%esi),%ebx
  800067:	c7 44 24 04 2d 3f 80 	movl   $0x803f2d,0x4(%esp)
  80006e:	00 
  80006f:	8b 46 04             	mov    0x4(%esi),%eax
  800072:	89 04 24             	mov    %eax,(%esp)
  800075:	e8 7a 08 00 00       	call   8008f4 <_Z6strcmpPKcS0_>
  80007a:	85 c0                	test   %eax,%eax
  80007c:	0f 85 86 00 00 00    	jne    800108 <_Z5umainiPPc+0xd4>
		nflag = 1;
		argc--;
  800082:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800085:	89 de                	mov    %ebx,%esi
	int i, nflag;
	cprintf("[%08x] echo\n", thisenv->env_id);

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
  800087:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80008e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800093:	83 ff 01             	cmp    $0x1,%edi
  800096:	7f 23                	jg     8000bb <_Z5umainiPPc+0x87>
  800098:	eb 4a                	jmp    8000e4 <_Z5umainiPPc+0xb0>
		if (i > 1)
  80009a:	83 fb 01             	cmp    $0x1,%ebx
  80009d:	7e 1c                	jle    8000bb <_Z5umainiPPc+0x87>
			write(1, " ", 1);
  80009f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000a6:	00 
  8000a7:	c7 44 24 04 9b 49 80 	movl   $0x80499b,0x4(%esp)
  8000ae:	00 
  8000af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000b6:	e8 ee 15 00 00       	call   8016a9 <_Z5writeiPKvj>
		write(1, argv[i], strlen(argv[i]));
  8000bb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000be:	89 04 24             	mov    %eax,(%esp)
  8000c1:	e8 6a 07 00 00       	call   800830 <_Z6strlenPKc>
  8000c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ca:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d8:	e8 cc 15 00 00       	call   8016a9 <_Z5writeiPKvj>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000dd:	83 c3 01             	add    $0x1,%ebx
  8000e0:	39 df                	cmp    %ebx,%edi
  8000e2:	7f b6                	jg     80009a <_Z5umainiPPc+0x66>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000e8:	75 2a                	jne    800114 <_Z5umainiPPc+0xe0>
		write(1, "\n", 1);
  8000ea:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000f1:	00 
  8000f2:	c7 44 24 04 e3 48 80 	movl   $0x8048e3,0x4(%esp)
  8000f9:	00 
  8000fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800101:	e8 a3 15 00 00       	call   8016a9 <_Z5writeiPKvj>
  800106:	eb 0c                	jmp    800114 <_Z5umainiPPc+0xe0>
umain(int argc, char **argv)
{
	int i, nflag;
	cprintf("[%08x] echo\n", thisenv->env_id);

	nflag = 0;
  800108:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80010f:	e9 7a ff ff ff       	jmp    80008e <_Z5umainiPPc+0x5a>
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
		write(1, "\n", 1);
}
  800114:	83 c4 2c             	add    $0x2c,%esp
  800117:	5b                   	pop    %ebx
  800118:	5e                   	pop    %esi
  800119:	5f                   	pop    %edi
  80011a:	5d                   	pop    %ebp
  80011b:	c3                   	ret    

0080011c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	57                   	push   %edi
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	83 ec 1c             	sub    $0x1c,%esp
  800125:	8b 7d 08             	mov    0x8(%ebp),%edi
  800128:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  80012b:	e8 b8 0b 00 00       	call   800ce8 <_Z12sys_getenvidv>
  800130:	25 ff 03 00 00       	and    $0x3ff,%eax
  800135:	6b c0 78             	imul   $0x78,%eax,%eax
  800138:	05 00 00 00 ef       	add    $0xef000000,%eax
  80013d:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800142:	85 ff                	test   %edi,%edi
  800144:	7e 07                	jle    80014d <libmain+0x31>
		binaryname = argv[0];
  800146:	8b 06                	mov    (%esi),%eax
  800148:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80014d:	b8 6d 4a 80 00       	mov    $0x804a6d,%eax
  800152:	3d 6d 4a 80 00       	cmp    $0x804a6d,%eax
  800157:	76 0f                	jbe    800168 <libmain+0x4c>
  800159:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80015b:	83 eb 04             	sub    $0x4,%ebx
  80015e:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800160:	81 fb 6d 4a 80 00    	cmp    $0x804a6d,%ebx
  800166:	77 f3                	ja     80015b <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800168:	89 74 24 04          	mov    %esi,0x4(%esp)
  80016c:	89 3c 24             	mov    %edi,(%esp)
  80016f:	e8 c0 fe ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800174:	e8 0b 00 00 00       	call   800184 <_Z4exitv>
}
  800179:	83 c4 1c             	add    $0x1c,%esp
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    
  800181:	00 00                	add    %al,(%eax)
	...

00800184 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80018a:	e8 bf 12 00 00       	call   80144e <_Z9close_allv>
	sys_env_destroy(0);
  80018f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800196:	e8 f0 0a 00 00       	call   800c8b <_Z15sys_env_destroyi>
}
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    
  80019d:	00 00                	add    %al,(%eax)
	...

008001a0 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
  8001a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  8001af:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8001b1:	8b 03                	mov    (%ebx),%eax
  8001b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001ba:	83 c0 01             	add    $0x1,%eax
  8001bd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c4:	75 19                	jne    8001df <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8001c6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001cd:	00 
  8001ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d1:	89 04 24             	mov    %eax,(%esp)
  8001d4:	e8 4b 0a 00 00       	call   800c24 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8001d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001df:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8001e3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001e6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001e9:	89 ec                	mov    %ebp,%esp
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fd:	00 00 00 
	b.cnt = 0;
  800200:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800207:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	89 44 24 08          	mov    %eax,0x8(%esp)
  800218:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800222:	c7 04 24 a0 01 80 00 	movl   $0x8001a0,(%esp)
  800229:	e8 a9 01 00 00       	call   8003d7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80022e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800234:	89 44 24 04          	mov    %eax,0x4(%esp)
  800238:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023e:	89 04 24             	mov    %eax,(%esp)
  800241:	e8 de 09 00 00       	call   800c24 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800246:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800254:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	e8 87 ff ff ff       	call   8001ed <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800266:	c9                   	leave  
  800267:	c3                   	ret    
	...

00800270 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 4c             	sub    $0x4c,%esp
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027c:	89 d6                	mov    %edx,%esi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800284:	8b 55 0c             	mov    0xc(%ebp),%edx
  800287:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80028a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80028d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800290:	b8 00 00 00 00       	mov    $0x0,%eax
  800295:	39 d0                	cmp    %edx,%eax
  800297:	72 11                	jb     8002aa <_ZL8printnumPFviPvES_yjii+0x3a>
  800299:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80029c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80029f:	76 09                	jbe    8002aa <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002a1:	83 eb 01             	sub    $0x1,%ebx
  8002a4:	85 db                	test   %ebx,%ebx
  8002a6:	7f 5d                	jg     800305 <_ZL8printnumPFviPvES_yjii+0x95>
  8002a8:	eb 6c                	jmp    800316 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002aa:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002ae:	83 eb 01             	sub    $0x1,%ebx
  8002b1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002c0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002c7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8002ca:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002d1:	00 
  8002d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002d5:	89 14 24             	mov    %edx,(%esp)
  8002d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002df:	e8 cc 39 00 00       	call   803cb0 <__udivdi3>
  8002e4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002e7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002ea:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002f9:	89 f2                	mov    %esi,%edx
  8002fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fe:	e8 6d ff ff ff       	call   800270 <_ZL8printnumPFviPvES_yjii>
  800303:	eb 11                	jmp    800316 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800305:	89 74 24 04          	mov    %esi,0x4(%esp)
  800309:	89 3c 24             	mov    %edi,(%esp)
  80030c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80030f:	83 eb 01             	sub    $0x1,%ebx
  800312:	85 db                	test   %ebx,%ebx
  800314:	7f ef                	jg     800305 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800316:	89 74 24 04          	mov    %esi,0x4(%esp)
  80031a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80031e:	8b 45 10             	mov    0x10(%ebp),%eax
  800321:	89 44 24 08          	mov    %eax,0x8(%esp)
  800325:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80032c:	00 
  80032d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800330:	89 14 24             	mov    %edx,(%esp)
  800333:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800336:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80033a:	e8 81 3a 00 00       	call   803dc0 <__umoddi3>
  80033f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800343:	0f be 80 3a 3f 80 00 	movsbl 0x803f3a(%eax),%eax
  80034a:	89 04 24             	mov    %eax,(%esp)
  80034d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800350:	83 c4 4c             	add    $0x4c,%esp
  800353:	5b                   	pop    %ebx
  800354:	5e                   	pop    %esi
  800355:	5f                   	pop    %edi
  800356:	5d                   	pop    %ebp
  800357:	c3                   	ret    

00800358 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80035b:	83 fa 01             	cmp    $0x1,%edx
  80035e:	7e 0e                	jle    80036e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800360:	8b 10                	mov    (%eax),%edx
  800362:	8d 4a 08             	lea    0x8(%edx),%ecx
  800365:	89 08                	mov    %ecx,(%eax)
  800367:	8b 02                	mov    (%edx),%eax
  800369:	8b 52 04             	mov    0x4(%edx),%edx
  80036c:	eb 22                	jmp    800390 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80036e:	85 d2                	test   %edx,%edx
  800370:	74 10                	je     800382 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800372:	8b 10                	mov    (%eax),%edx
  800374:	8d 4a 04             	lea    0x4(%edx),%ecx
  800377:	89 08                	mov    %ecx,(%eax)
  800379:	8b 02                	mov    (%edx),%eax
  80037b:	ba 00 00 00 00       	mov    $0x0,%edx
  800380:	eb 0e                	jmp    800390 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800382:	8b 10                	mov    (%eax),%edx
  800384:	8d 4a 04             	lea    0x4(%edx),%ecx
  800387:	89 08                	mov    %ecx,(%eax)
  800389:	8b 02                	mov    (%edx),%eax
  80038b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800390:	5d                   	pop    %ebp
  800391:	c3                   	ret    

00800392 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800398:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039c:	8b 10                	mov    (%eax),%edx
  80039e:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a1:	73 0a                	jae    8003ad <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8003a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a6:	88 0a                	mov    %cl,(%edx)
  8003a8:	83 c2 01             	add    $0x1,%edx
  8003ab:	89 10                	mov    %edx,(%eax)
}
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003b5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	89 04 24             	mov    %eax,(%esp)
  8003d0:	e8 02 00 00 00       	call   8003d7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8003d5:	c9                   	leave  
  8003d6:	c3                   	ret    

008003d7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003d7:	55                   	push   %ebp
  8003d8:	89 e5                	mov    %esp,%ebp
  8003da:	57                   	push   %edi
  8003db:	56                   	push   %esi
  8003dc:	53                   	push   %ebx
  8003dd:	83 ec 3c             	sub    $0x3c,%esp
  8003e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003e3:	8b 55 10             	mov    0x10(%ebp),%edx
  8003e6:	0f b6 02             	movzbl (%edx),%eax
  8003e9:	89 d3                	mov    %edx,%ebx
  8003eb:	83 c3 01             	add    $0x1,%ebx
  8003ee:	83 f8 25             	cmp    $0x25,%eax
  8003f1:	74 2b                	je     80041e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  8003f3:	85 c0                	test   %eax,%eax
  8003f5:	75 10                	jne    800407 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  8003f7:	e9 a5 03 00 00       	jmp    8007a1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8003fc:	85 c0                	test   %eax,%eax
  8003fe:	66 90                	xchg   %ax,%ax
  800400:	75 08                	jne    80040a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800402:	e9 9a 03 00 00       	jmp    8007a1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800407:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80040a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80040e:	89 04 24             	mov    %eax,(%esp)
  800411:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800413:	0f b6 03             	movzbl (%ebx),%eax
  800416:	83 c3 01             	add    $0x1,%ebx
  800419:	83 f8 25             	cmp    $0x25,%eax
  80041c:	75 de                	jne    8003fc <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80041e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800422:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800429:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80042e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800435:	b9 00 00 00 00       	mov    $0x0,%ecx
  80043a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80043d:	eb 2b                	jmp    80046a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800442:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800446:	eb 22                	jmp    80046a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800448:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80044b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80044f:	eb 19                	jmp    80046a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800454:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80045b:	eb 0d                	jmp    80046a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80045d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800460:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800463:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	0f b6 03             	movzbl (%ebx),%eax
  80046d:	0f b6 d0             	movzbl %al,%edx
  800470:	8d 73 01             	lea    0x1(%ebx),%esi
  800473:	89 75 10             	mov    %esi,0x10(%ebp)
  800476:	83 e8 23             	sub    $0x23,%eax
  800479:	3c 55                	cmp    $0x55,%al
  80047b:	0f 87 d8 02 00 00    	ja     800759 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	ff 24 85 e0 40 80 00 	jmp    *0x8040e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80048b:	83 ea 30             	sub    $0x30,%edx
  80048e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800491:	8b 55 10             	mov    0x10(%ebp),%edx
  800494:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800497:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80049d:	83 fa 09             	cmp    $0x9,%edx
  8004a0:	77 4e                	ja     8004f0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004a5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8004a8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8004ab:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8004af:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  8004b2:	8d 50 d0             	lea    -0x30(%eax),%edx
  8004b5:	83 fa 09             	cmp    $0x9,%edx
  8004b8:	76 eb                	jbe    8004a5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  8004ba:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004bd:	eb 31                	jmp    8004f0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c2:	8d 50 04             	lea    0x4(%eax),%edx
  8004c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004d0:	eb 1e                	jmp    8004f0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8004d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004d6:	0f 88 75 ff ff ff    	js     800451 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004df:	eb 89                	jmp    80046a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8004e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004e4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8004eb:	e9 7a ff ff ff       	jmp    80046a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  8004f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004f4:	0f 89 70 ff ff ff    	jns    80046a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8004fa:	e9 5e ff ff ff       	jmp    80045d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004ff:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800502:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800505:	e9 60 ff ff ff       	jmp    80046a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8d 50 04             	lea    0x4(%eax),%edx
  800510:	89 55 14             	mov    %edx,0x14(%ebp)
  800513:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800517:	8b 00                	mov    (%eax),%eax
  800519:	89 04 24             	mov    %eax,(%esp)
  80051c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80051f:	e9 bf fe ff ff       	jmp    8003e3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 50 04             	lea    0x4(%eax),%edx
  80052a:	89 55 14             	mov    %edx,0x14(%ebp)
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 c2                	mov    %eax,%edx
  800531:	c1 fa 1f             	sar    $0x1f,%edx
  800534:	31 d0                	xor    %edx,%eax
  800536:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800538:	83 f8 14             	cmp    $0x14,%eax
  80053b:	7f 0f                	jg     80054c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80053d:	8b 14 85 40 42 80 00 	mov    0x804240(,%eax,4),%edx
  800544:	85 d2                	test   %edx,%edx
  800546:	0f 85 35 02 00 00    	jne    800781 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80054c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800550:	c7 44 24 08 52 3f 80 	movl   $0x803f52,0x8(%esp)
  800557:	00 
  800558:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055c:	8b 75 08             	mov    0x8(%ebp),%esi
  80055f:	89 34 24             	mov    %esi,(%esp)
  800562:	e8 48 fe ff ff       	call   8003af <_Z8printfmtPFviPvES_PKcz>
  800567:	e9 77 fe ff ff       	jmp    8003e3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80056c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800572:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8d 50 04             	lea    0x4(%eax),%edx
  80057b:	89 55 14             	mov    %edx,0x14(%ebp)
  80057e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800580:	85 db                	test   %ebx,%ebx
  800582:	ba 4b 3f 80 00       	mov    $0x803f4b,%edx
  800587:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80058a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80058e:	7e 72                	jle    800602 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800590:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800594:	74 6c                	je     800602 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	89 74 24 04          	mov    %esi,0x4(%esp)
  80059a:	89 1c 24             	mov    %ebx,(%esp)
  80059d:	e8 a9 02 00 00       	call   80084b <_Z7strnlenPKcj>
  8005a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a5:	29 c2                	sub    %eax,%edx
  8005a7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005aa:	85 d2                	test   %edx,%edx
  8005ac:	7e 54                	jle    800602 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  8005ae:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  8005b2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8005b5:	89 d3                	mov    %edx,%ebx
  8005b7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005ba:	89 c6                	mov    %eax,%esi
  8005bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c0:	89 34 24             	mov    %esi,(%esp)
  8005c3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c6:	83 eb 01             	sub    $0x1,%ebx
  8005c9:	85 db                	test   %ebx,%ebx
  8005cb:	7f ef                	jg     8005bc <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  8005cd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005d0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8005d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005da:	eb 26                	jmp    800602 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005dc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005df:	83 fa 5e             	cmp    $0x5e,%edx
  8005e2:	76 10                	jbe    8005f4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  8005e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005e8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005ef:	ff 55 08             	call   *0x8(%ebp)
  8005f2:	eb 0a                	jmp    8005fe <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  8005f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f8:	89 04 24             	mov    %eax,(%esp)
  8005fb:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fe:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800602:	0f be 03             	movsbl (%ebx),%eax
  800605:	83 c3 01             	add    $0x1,%ebx
  800608:	85 c0                	test   %eax,%eax
  80060a:	74 11                	je     80061d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80060c:	85 f6                	test   %esi,%esi
  80060e:	78 05                	js     800615 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800610:	83 ee 01             	sub    $0x1,%esi
  800613:	78 0d                	js     800622 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800615:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800619:	75 c1                	jne    8005dc <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80061b:	eb d7                	jmp    8005f4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800620:	eb 03                	jmp    800625 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800625:	85 c0                	test   %eax,%eax
  800627:	0f 8e b6 fd ff ff    	jle    8003e3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80062d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800630:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800633:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800637:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80063e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800640:	83 eb 01             	sub    $0x1,%ebx
  800643:	85 db                	test   %ebx,%ebx
  800645:	7f ec                	jg     800633 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800647:	e9 97 fd ff ff       	jmp    8003e3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80064c:	83 f9 01             	cmp    $0x1,%ecx
  80064f:	90                   	nop
  800650:	7e 10                	jle    800662 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8d 50 08             	lea    0x8(%eax),%edx
  800658:	89 55 14             	mov    %edx,0x14(%ebp)
  80065b:	8b 18                	mov    (%eax),%ebx
  80065d:	8b 70 04             	mov    0x4(%eax),%esi
  800660:	eb 26                	jmp    800688 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800662:	85 c9                	test   %ecx,%ecx
  800664:	74 12                	je     800678 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8d 50 04             	lea    0x4(%eax),%edx
  80066c:	89 55 14             	mov    %edx,0x14(%ebp)
  80066f:	8b 18                	mov    (%eax),%ebx
  800671:	89 de                	mov    %ebx,%esi
  800673:	c1 fe 1f             	sar    $0x1f,%esi
  800676:	eb 10                	jmp    800688 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8d 50 04             	lea    0x4(%eax),%edx
  80067e:	89 55 14             	mov    %edx,0x14(%ebp)
  800681:	8b 18                	mov    (%eax),%ebx
  800683:	89 de                	mov    %ebx,%esi
  800685:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800688:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80068d:	85 f6                	test   %esi,%esi
  80068f:	0f 89 8c 00 00 00    	jns    800721 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800695:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800699:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006a0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006a3:	f7 db                	neg    %ebx
  8006a5:	83 d6 00             	adc    $0x0,%esi
  8006a8:	f7 de                	neg    %esi
			}
			base = 10;
  8006aa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006af:	eb 70                	jmp    800721 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006b1:	89 ca                	mov    %ecx,%edx
  8006b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b6:	e8 9d fc ff ff       	call   800358 <_ZL7getuintPPci>
  8006bb:	89 c3                	mov    %eax,%ebx
  8006bd:	89 d6                	mov    %edx,%esi
			base = 10;
  8006bf:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8006c4:	eb 5b                	jmp    800721 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006c6:	89 ca                	mov    %ecx,%edx
  8006c8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006cb:	e8 88 fc ff ff       	call   800358 <_ZL7getuintPPci>
  8006d0:	89 c3                	mov    %eax,%ebx
  8006d2:	89 d6                	mov    %edx,%esi
			base = 8;
  8006d4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006d9:	eb 46                	jmp    800721 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8006db:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006df:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006e6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ed:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006f4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8d 50 04             	lea    0x4(%eax),%edx
  8006fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800700:	8b 18                	mov    (%eax),%ebx
  800702:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800707:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80070c:	eb 13                	jmp    800721 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80070e:	89 ca                	mov    %ecx,%edx
  800710:	8d 45 14             	lea    0x14(%ebp),%eax
  800713:	e8 40 fc ff ff       	call   800358 <_ZL7getuintPPci>
  800718:	89 c3                	mov    %eax,%ebx
  80071a:	89 d6                	mov    %edx,%esi
			base = 16;
  80071c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800721:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800725:	89 54 24 10          	mov    %edx,0x10(%esp)
  800729:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80072c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800730:	89 44 24 08          	mov    %eax,0x8(%esp)
  800734:	89 1c 24             	mov    %ebx,(%esp)
  800737:	89 74 24 04          	mov    %esi,0x4(%esp)
  80073b:	89 fa                	mov    %edi,%edx
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	e8 2b fb ff ff       	call   800270 <_ZL8printnumPFviPvES_yjii>
			break;
  800745:	e9 99 fc ff ff       	jmp    8003e3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80074a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074e:	89 14 24             	mov    %edx,(%esp)
  800751:	ff 55 08             	call   *0x8(%ebp)
			break;
  800754:	e9 8a fc ff ff       	jmp    8003e3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800759:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800764:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800767:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80076a:	89 d8                	mov    %ebx,%eax
  80076c:	eb 02                	jmp    800770 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80076e:	89 d0                	mov    %edx,%eax
  800770:	8d 50 ff             	lea    -0x1(%eax),%edx
  800773:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800777:	75 f5                	jne    80076e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800779:	89 45 10             	mov    %eax,0x10(%ebp)
  80077c:	e9 62 fc ff ff       	jmp    8003e3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800781:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800785:	c7 44 24 08 de 42 80 	movl   $0x8042de,0x8(%esp)
  80078c:	00 
  80078d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800791:	8b 75 08             	mov    0x8(%ebp),%esi
  800794:	89 34 24             	mov    %esi,(%esp)
  800797:	e8 13 fc ff ff       	call   8003af <_Z8printfmtPFviPvES_PKcz>
  80079c:	e9 42 fc ff ff       	jmp    8003e3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007a1:	83 c4 3c             	add    $0x3c,%esp
  8007a4:	5b                   	pop    %ebx
  8007a5:	5e                   	pop    %esi
  8007a6:	5f                   	pop    %edi
  8007a7:	5d                   	pop    %ebp
  8007a8:	c3                   	ret    

008007a9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a9:	55                   	push   %ebp
  8007aa:	89 e5                	mov    %esp,%ebp
  8007ac:	83 ec 28             	sub    $0x28,%esp
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8007bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007bf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  8007c6:	85 c0                	test   %eax,%eax
  8007c8:	74 30                	je     8007fa <_Z9vsnprintfPciPKcS_+0x51>
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	7e 2c                	jle    8007fa <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e3:	c7 04 24 92 03 80 00 	movl   $0x800392,(%esp)
  8007ea:	e8 e8 fb ff ff       	call   8003d7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  8007ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f8:	eb 05                	jmp    8007ff <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007ff:	c9                   	leave  
  800800:	c3                   	ret    

00800801 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800807:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80080a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80080e:	8b 45 10             	mov    0x10(%ebp),%eax
  800811:	89 44 24 08          	mov    %eax,0x8(%esp)
  800815:	8b 45 0c             	mov    0xc(%ebp),%eax
  800818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	89 04 24             	mov    %eax,(%esp)
  800822:	e8 82 ff ff ff       	call   8007a9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800827:	c9                   	leave  
  800828:	c3                   	ret    
  800829:	00 00                	add    %al,(%eax)
  80082b:	00 00                	add    %al,(%eax)
  80082d:	00 00                	add    %al,(%eax)
	...

00800830 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	80 3a 00             	cmpb   $0x0,(%edx)
  80083e:	74 09                	je     800849 <_Z6strlenPKc+0x19>
		n++;
  800840:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800843:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800847:	75 f7                	jne    800840 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    

0080084b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80084b:	55                   	push   %ebp
  80084c:	89 e5                	mov    %esp,%ebp
  80084e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800851:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
  800859:	39 c2                	cmp    %eax,%edx
  80085b:	74 0b                	je     800868 <_Z7strnlenPKcj+0x1d>
  80085d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800861:	74 05                	je     800868 <_Z7strnlenPKcj+0x1d>
		n++;
  800863:	83 c0 01             	add    $0x1,%eax
  800866:	eb f1                	jmp    800859 <_Z7strnlenPKcj+0xe>
	return n;
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	53                   	push   %ebx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800874:	ba 00 00 00 00       	mov    $0x0,%edx
  800879:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80087d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800880:	83 c2 01             	add    $0x1,%edx
  800883:	84 c9                	test   %cl,%cl
  800885:	75 f2                	jne    800879 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800887:	5b                   	pop    %ebx
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	56                   	push   %esi
  80088e:	53                   	push   %ebx
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 55 0c             	mov    0xc(%ebp),%edx
  800895:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800898:	85 f6                	test   %esi,%esi
  80089a:	74 18                	je     8008b4 <_Z7strncpyPcPKcj+0x2a>
  80089c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8008a1:	0f b6 1a             	movzbl (%edx),%ebx
  8008a4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008a7:	80 3a 01             	cmpb   $0x1,(%edx)
  8008aa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8008ad:	83 c1 01             	add    $0x1,%ecx
  8008b0:	39 ce                	cmp    %ecx,%esi
  8008b2:	77 ed                	ja     8008a1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008b4:	5b                   	pop    %ebx
  8008b5:	5e                   	pop    %esi
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	56                   	push   %esi
  8008bc:	53                   	push   %ebx
  8008bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  8008c6:	89 f0                	mov    %esi,%eax
  8008c8:	85 d2                	test   %edx,%edx
  8008ca:	74 17                	je     8008e3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  8008cc:	83 ea 01             	sub    $0x1,%edx
  8008cf:	74 18                	je     8008e9 <_Z7strlcpyPcPKcj+0x31>
  8008d1:	80 39 00             	cmpb   $0x0,(%ecx)
  8008d4:	74 17                	je     8008ed <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8008d6:	0f b6 19             	movzbl (%ecx),%ebx
  8008d9:	88 18                	mov    %bl,(%eax)
  8008db:	83 c0 01             	add    $0x1,%eax
  8008de:	83 c1 01             	add    $0x1,%ecx
  8008e1:	eb e9                	jmp    8008cc <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  8008e3:	29 f0                	sub    %esi,%eax
}
  8008e5:	5b                   	pop    %ebx
  8008e6:	5e                   	pop    %esi
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008e9:	89 c2                	mov    %eax,%edx
  8008eb:	eb 02                	jmp    8008ef <_Z7strlcpyPcPKcj+0x37>
  8008ed:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008ef:	c6 02 00             	movb   $0x0,(%edx)
  8008f2:	eb ef                	jmp    8008e3 <_Z7strlcpyPcPKcj+0x2b>

008008f4 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008fd:	0f b6 01             	movzbl (%ecx),%eax
  800900:	84 c0                	test   %al,%al
  800902:	74 0c                	je     800910 <_Z6strcmpPKcS0_+0x1c>
  800904:	3a 02                	cmp    (%edx),%al
  800906:	75 08                	jne    800910 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800908:	83 c1 01             	add    $0x1,%ecx
  80090b:	83 c2 01             	add    $0x1,%edx
  80090e:	eb ed                	jmp    8008fd <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800910:	0f b6 c0             	movzbl %al,%eax
  800913:	0f b6 12             	movzbl (%edx),%edx
  800916:	29 d0                	sub    %edx,%eax
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	53                   	push   %ebx
  80091e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800921:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800924:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800927:	85 d2                	test   %edx,%edx
  800929:	74 16                	je     800941 <_Z7strncmpPKcS0_j+0x27>
  80092b:	0f b6 01             	movzbl (%ecx),%eax
  80092e:	84 c0                	test   %al,%al
  800930:	74 17                	je     800949 <_Z7strncmpPKcS0_j+0x2f>
  800932:	3a 03                	cmp    (%ebx),%al
  800934:	75 13                	jne    800949 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800936:	83 ea 01             	sub    $0x1,%edx
  800939:	83 c1 01             	add    $0x1,%ecx
  80093c:	83 c3 01             	add    $0x1,%ebx
  80093f:	eb e6                	jmp    800927 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800946:	5b                   	pop    %ebx
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800949:	0f b6 01             	movzbl (%ecx),%eax
  80094c:	0f b6 13             	movzbl (%ebx),%edx
  80094f:	29 d0                	sub    %edx,%eax
  800951:	eb f3                	jmp    800946 <_Z7strncmpPKcS0_j+0x2c>

00800953 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095d:	0f b6 10             	movzbl (%eax),%edx
  800960:	84 d2                	test   %dl,%dl
  800962:	74 1f                	je     800983 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800964:	38 ca                	cmp    %cl,%dl
  800966:	75 0a                	jne    800972 <_Z6strchrPKcc+0x1f>
  800968:	eb 1e                	jmp    800988 <_Z6strchrPKcc+0x35>
  80096a:	38 ca                	cmp    %cl,%dl
  80096c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800970:	74 16                	je     800988 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800972:	83 c0 01             	add    $0x1,%eax
  800975:	0f b6 10             	movzbl (%eax),%edx
  800978:	84 d2                	test   %dl,%dl
  80097a:	75 ee                	jne    80096a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
  800981:	eb 05                	jmp    800988 <_Z6strchrPKcc+0x35>
  800983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800994:	0f b6 10             	movzbl (%eax),%edx
  800997:	84 d2                	test   %dl,%dl
  800999:	74 14                	je     8009af <_Z7strfindPKcc+0x25>
		if (*s == c)
  80099b:	38 ca                	cmp    %cl,%dl
  80099d:	75 06                	jne    8009a5 <_Z7strfindPKcc+0x1b>
  80099f:	eb 0e                	jmp    8009af <_Z7strfindPKcc+0x25>
  8009a1:	38 ca                	cmp    %cl,%dl
  8009a3:	74 0a                	je     8009af <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009a5:	83 c0 01             	add    $0x1,%eax
  8009a8:	0f b6 10             	movzbl (%eax),%edx
  8009ab:	84 d2                	test   %dl,%dl
  8009ad:	75 f2                	jne    8009a1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 0c             	sub    $0xc,%esp
  8009b7:	89 1c 24             	mov    %ebx,(%esp)
  8009ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  8009cb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009d1:	75 25                	jne    8009f8 <memset+0x47>
  8009d3:	f6 c1 03             	test   $0x3,%cl
  8009d6:	75 20                	jne    8009f8 <memset+0x47>
		c &= 0xFF;
  8009d8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009db:	89 d3                	mov    %edx,%ebx
  8009dd:	c1 e3 08             	shl    $0x8,%ebx
  8009e0:	89 d6                	mov    %edx,%esi
  8009e2:	c1 e6 18             	shl    $0x18,%esi
  8009e5:	89 d0                	mov    %edx,%eax
  8009e7:	c1 e0 10             	shl    $0x10,%eax
  8009ea:	09 f0                	or     %esi,%eax
  8009ec:	09 d0                	or     %edx,%eax
  8009ee:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  8009f0:	c1 e9 02             	shr    $0x2,%ecx
  8009f3:	fc                   	cld    
  8009f4:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f6:	eb 03                	jmp    8009fb <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  8009f8:	fc                   	cld    
  8009f9:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  8009fb:	89 f8                	mov    %edi,%eax
  8009fd:	8b 1c 24             	mov    (%esp),%ebx
  800a00:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a04:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a08:	89 ec                	mov    %ebp,%esp
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	89 34 24             	mov    %esi,(%esp)
  800a15:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800a22:	39 c6                	cmp    %eax,%esi
  800a24:	73 36                	jae    800a5c <memmove+0x50>
  800a26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a29:	39 d0                	cmp    %edx,%eax
  800a2b:	73 2f                	jae    800a5c <memmove+0x50>
		s += n;
		d += n;
  800a2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a30:	f6 c2 03             	test   $0x3,%dl
  800a33:	75 1b                	jne    800a50 <memmove+0x44>
  800a35:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a3b:	75 13                	jne    800a50 <memmove+0x44>
  800a3d:	f6 c1 03             	test   $0x3,%cl
  800a40:	75 0e                	jne    800a50 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a42:	83 ef 04             	sub    $0x4,%edi
  800a45:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a48:	c1 e9 02             	shr    $0x2,%ecx
  800a4b:	fd                   	std    
  800a4c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4e:	eb 09                	jmp    800a59 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a50:	83 ef 01             	sub    $0x1,%edi
  800a53:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a56:	fd                   	std    
  800a57:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a59:	fc                   	cld    
  800a5a:	eb 20                	jmp    800a7c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a5c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a62:	75 13                	jne    800a77 <memmove+0x6b>
  800a64:	a8 03                	test   $0x3,%al
  800a66:	75 0f                	jne    800a77 <memmove+0x6b>
  800a68:	f6 c1 03             	test   $0x3,%cl
  800a6b:	75 0a                	jne    800a77 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a6d:	c1 e9 02             	shr    $0x2,%ecx
  800a70:	89 c7                	mov    %eax,%edi
  800a72:	fc                   	cld    
  800a73:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a75:	eb 05                	jmp    800a7c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800a77:	89 c7                	mov    %eax,%edi
  800a79:	fc                   	cld    
  800a7a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800a7c:	8b 34 24             	mov    (%esp),%esi
  800a7f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a83:	89 ec                	mov    %ebp,%esp
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	89 34 24             	mov    %esi,(%esp)
  800a90:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a9d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aa3:	75 13                	jne    800ab8 <memcpy+0x31>
  800aa5:	a8 03                	test   $0x3,%al
  800aa7:	75 0f                	jne    800ab8 <memcpy+0x31>
  800aa9:	f6 c1 03             	test   $0x3,%cl
  800aac:	75 0a                	jne    800ab8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aae:	c1 e9 02             	shr    $0x2,%ecx
  800ab1:	89 c7                	mov    %eax,%edi
  800ab3:	fc                   	cld    
  800ab4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab6:	eb 05                	jmp    800abd <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800ab8:	89 c7                	mov    %eax,%edi
  800aba:	fc                   	cld    
  800abb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800abd:	8b 34 24             	mov    (%esp),%esi
  800ac0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ac4:	89 ec                	mov    %ebp,%esp
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	57                   	push   %edi
  800acc:	56                   	push   %esi
  800acd:	53                   	push   %ebx
  800ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ad1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800adc:	85 ff                	test   %edi,%edi
  800ade:	74 38                	je     800b18 <memcmp+0x50>
		if (*s1 != *s2)
  800ae0:	0f b6 03             	movzbl (%ebx),%eax
  800ae3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800ae6:	83 ef 01             	sub    $0x1,%edi
  800ae9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800aee:	38 c8                	cmp    %cl,%al
  800af0:	74 1d                	je     800b0f <memcmp+0x47>
  800af2:	eb 11                	jmp    800b05 <memcmp+0x3d>
  800af4:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800af9:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800afe:	83 c2 01             	add    $0x1,%edx
  800b01:	38 c8                	cmp    %cl,%al
  800b03:	74 0a                	je     800b0f <memcmp+0x47>
			return *s1 - *s2;
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	0f b6 c9             	movzbl %cl,%ecx
  800b0b:	29 c8                	sub    %ecx,%eax
  800b0d:	eb 09                	jmp    800b18 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b0f:	39 fa                	cmp    %edi,%edx
  800b11:	75 e1                	jne    800af4 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5f                   	pop    %edi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	53                   	push   %ebx
  800b21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800b24:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800b26:	89 da                	mov    %ebx,%edx
  800b28:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800b2b:	39 d3                	cmp    %edx,%ebx
  800b2d:	73 15                	jae    800b44 <memfind+0x27>
		if (*s == (unsigned char) c)
  800b2f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b33:	38 0b                	cmp    %cl,(%ebx)
  800b35:	75 06                	jne    800b3d <memfind+0x20>
  800b37:	eb 0b                	jmp    800b44 <memfind+0x27>
  800b39:	38 08                	cmp    %cl,(%eax)
  800b3b:	74 07                	je     800b44 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800b3d:	83 c0 01             	add    $0x1,%eax
  800b40:	39 c2                	cmp    %eax,%edx
  800b42:	77 f5                	ja     800b39 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b44:	5b                   	pop    %ebx
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	57                   	push   %edi
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
  800b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b50:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b53:	0f b6 02             	movzbl (%edx),%eax
  800b56:	3c 20                	cmp    $0x20,%al
  800b58:	74 04                	je     800b5e <_Z6strtolPKcPPci+0x17>
  800b5a:	3c 09                	cmp    $0x9,%al
  800b5c:	75 0e                	jne    800b6c <_Z6strtolPKcPPci+0x25>
		s++;
  800b5e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b61:	0f b6 02             	movzbl (%edx),%eax
  800b64:	3c 20                	cmp    $0x20,%al
  800b66:	74 f6                	je     800b5e <_Z6strtolPKcPPci+0x17>
  800b68:	3c 09                	cmp    $0x9,%al
  800b6a:	74 f2                	je     800b5e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b6c:	3c 2b                	cmp    $0x2b,%al
  800b6e:	75 0a                	jne    800b7a <_Z6strtolPKcPPci+0x33>
		s++;
  800b70:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b73:	bf 00 00 00 00       	mov    $0x0,%edi
  800b78:	eb 10                	jmp    800b8a <_Z6strtolPKcPPci+0x43>
  800b7a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b7f:	3c 2d                	cmp    $0x2d,%al
  800b81:	75 07                	jne    800b8a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800b83:	83 c2 01             	add    $0x1,%edx
  800b86:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8a:	85 db                	test   %ebx,%ebx
  800b8c:	0f 94 c0             	sete   %al
  800b8f:	74 05                	je     800b96 <_Z6strtolPKcPPci+0x4f>
  800b91:	83 fb 10             	cmp    $0x10,%ebx
  800b94:	75 15                	jne    800bab <_Z6strtolPKcPPci+0x64>
  800b96:	80 3a 30             	cmpb   $0x30,(%edx)
  800b99:	75 10                	jne    800bab <_Z6strtolPKcPPci+0x64>
  800b9b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b9f:	75 0a                	jne    800bab <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800ba1:	83 c2 02             	add    $0x2,%edx
  800ba4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba9:	eb 13                	jmp    800bbe <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0f                	je     800bbe <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800baf:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb4:	80 3a 30             	cmpb   $0x30,(%edx)
  800bb7:	75 05                	jne    800bbe <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800bb9:	83 c2 01             	add    $0x1,%edx
  800bbc:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bc5:	0f b6 0a             	movzbl (%edx),%ecx
  800bc8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bcb:	80 fb 09             	cmp    $0x9,%bl
  800bce:	77 08                	ja     800bd8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800bd0:	0f be c9             	movsbl %cl,%ecx
  800bd3:	83 e9 30             	sub    $0x30,%ecx
  800bd6:	eb 1e                	jmp    800bf6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800bd8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800bdb:	80 fb 19             	cmp    $0x19,%bl
  800bde:	77 08                	ja     800be8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800be0:	0f be c9             	movsbl %cl,%ecx
  800be3:	83 e9 57             	sub    $0x57,%ecx
  800be6:	eb 0e                	jmp    800bf6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800be8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800beb:	80 fb 19             	cmp    $0x19,%bl
  800bee:	77 15                	ja     800c05 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800bf0:	0f be c9             	movsbl %cl,%ecx
  800bf3:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bf6:	39 f1                	cmp    %esi,%ecx
  800bf8:	7d 0f                	jge    800c09 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800bfa:	83 c2 01             	add    $0x1,%edx
  800bfd:	0f af c6             	imul   %esi,%eax
  800c00:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800c03:	eb c0                	jmp    800bc5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c05:	89 c1                	mov    %eax,%ecx
  800c07:	eb 02                	jmp    800c0b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c09:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0f:	74 05                	je     800c16 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800c11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c14:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c16:	89 ca                	mov    %ecx,%edx
  800c18:	f7 da                	neg    %edx
  800c1a:	85 ff                	test   %edi,%edi
  800c1c:	0f 45 c2             	cmovne %edx,%eax
}
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 0c             	sub    $0xc,%esp
  800c2a:	89 1c 24             	mov    %ebx,(%esp)
  800c2d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c31:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c40:	89 c3                	mov    %eax,%ebx
  800c42:	89 c7                	mov    %eax,%edi
  800c44:	89 c6                	mov    %eax,%esi
  800c46:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c48:	8b 1c 24             	mov    (%esp),%ebx
  800c4b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c4f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c53:	89 ec                	mov    %ebp,%esp
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 0c             	sub    $0xc,%esp
  800c5d:	89 1c 24             	mov    %ebx,(%esp)
  800c60:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c64:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c68:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c72:	89 d1                	mov    %edx,%ecx
  800c74:	89 d3                	mov    %edx,%ebx
  800c76:	89 d7                	mov    %edx,%edi
  800c78:	89 d6                	mov    %edx,%esi
  800c7a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7c:	8b 1c 24             	mov    (%esp),%ebx
  800c7f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c83:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c87:	89 ec                	mov    %ebp,%esp
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	83 ec 38             	sub    $0x38,%esp
  800c91:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c94:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c97:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	89 cb                	mov    %ecx,%ebx
  800ca9:	89 cf                	mov    %ecx,%edi
  800cab:	89 ce                	mov    %ecx,%esi
  800cad:	cd 30                	int    $0x30

	if(check && ret > 0)
  800caf:	85 c0                	test   %eax,%eax
  800cb1:	7e 28                	jle    800cdb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cbe:	00 
  800cbf:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  800cc6:	00 
  800cc7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cce:	00 
  800ccf:	c7 04 24 b1 42 80 00 	movl   $0x8042b1,(%esp)
  800cd6:	e8 11 2d 00 00       	call   8039ec <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cdb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cde:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ce1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ce4:	89 ec                	mov    %ebp,%esp
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 0c             	sub    $0xc,%esp
  800cee:	89 1c 24             	mov    %ebx,(%esp)
  800cf1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cf5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800cf9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfe:	b8 02 00 00 00       	mov    $0x2,%eax
  800d03:	89 d1                	mov    %edx,%ecx
  800d05:	89 d3                	mov    %edx,%ebx
  800d07:	89 d7                	mov    %edx,%edi
  800d09:	89 d6                	mov    %edx,%esi
  800d0b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0d:	8b 1c 24             	mov    (%esp),%ebx
  800d10:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d18:	89 ec                	mov    %ebp,%esp
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	89 1c 24             	mov    %ebx,(%esp)
  800d25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d29:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d32:	b8 04 00 00 00       	mov    $0x4,%eax
  800d37:	89 d1                	mov    %edx,%ecx
  800d39:	89 d3                	mov    %edx,%ebx
  800d3b:	89 d7                	mov    %edx,%edi
  800d3d:	89 d6                	mov    %edx,%esi
  800d3f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d41:	8b 1c 24             	mov    (%esp),%ebx
  800d44:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d48:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d4c:	89 ec                	mov    %ebp,%esp
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 38             	sub    $0x38,%esp
  800d56:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d59:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d5c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d5f:	be 00 00 00 00       	mov    $0x0,%esi
  800d64:	b8 08 00 00 00       	mov    $0x8,%eax
  800d69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	89 f7                	mov    %esi,%edi
  800d74:	cd 30                	int    $0x30

	if(check && ret > 0)
  800d76:	85 c0                	test   %eax,%eax
  800d78:	7e 28                	jle    800da2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d85:	00 
  800d86:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  800d8d:	00 
  800d8e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d95:	00 
  800d96:	c7 04 24 b1 42 80 00 	movl   $0x8042b1,(%esp)
  800d9d:	e8 4a 2c 00 00       	call   8039ec <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800da5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800da8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dab:	89 ec                	mov    %ebp,%esp
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 38             	sub    $0x38,%esp
  800db5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800db8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dbb:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dbe:	b8 09 00 00 00       	mov    $0x9,%eax
  800dc3:	8b 75 18             	mov    0x18(%ebp),%esi
  800dc6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd2:	cd 30                	int    $0x30

	if(check && ret > 0)
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	7e 28                	jle    800e00 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ddc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800de3:	00 
  800de4:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  800deb:	00 
  800dec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df3:	00 
  800df4:	c7 04 24 b1 42 80 00 	movl   $0x8042b1,(%esp)
  800dfb:	e8 ec 2b 00 00       	call   8039ec <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e00:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e03:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e06:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e09:	89 ec                	mov    %ebp,%esp
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 38             	sub    $0x38,%esp
  800e13:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e16:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e19:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	89 df                	mov    %ebx,%edi
  800e2e:	89 de                	mov    %ebx,%esi
  800e30:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	7e 28                	jle    800e5e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e36:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e41:	00 
  800e42:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  800e49:	00 
  800e4a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e51:	00 
  800e52:	c7 04 24 b1 42 80 00 	movl   $0x8042b1,(%esp)
  800e59:	e8 8e 2b 00 00       	call   8039ec <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e5e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e61:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e64:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e67:	89 ec                	mov    %ebp,%esp
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	83 ec 38             	sub    $0x38,%esp
  800e71:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e74:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e77:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7f:	b8 05 00 00 00       	mov    $0x5,%eax
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e87:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8a:	89 df                	mov    %ebx,%edi
  800e8c:	89 de                	mov    %ebx,%esi
  800e8e:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	7e 28                	jle    800ebc <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e94:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e98:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e9f:	00 
  800ea0:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  800ea7:	00 
  800ea8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eaf:	00 
  800eb0:	c7 04 24 b1 42 80 00 	movl   $0x8042b1,(%esp)
  800eb7:	e8 30 2b 00 00       	call   8039ec <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ebc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ebf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ec5:	89 ec                	mov    %ebp,%esp
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 38             	sub    $0x38,%esp
  800ecf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ed5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ed8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edd:	b8 06 00 00 00       	mov    $0x6,%eax
  800ee2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	89 df                	mov    %ebx,%edi
  800eea:	89 de                	mov    %ebx,%esi
  800eec:	cd 30                	int    $0x30

	if(check && ret > 0)
  800eee:	85 c0                	test   %eax,%eax
  800ef0:	7e 28                	jle    800f1a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800efd:	00 
  800efe:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  800f05:	00 
  800f06:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0d:	00 
  800f0e:	c7 04 24 b1 42 80 00 	movl   $0x8042b1,(%esp)
  800f15:	e8 d2 2a 00 00       	call   8039ec <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800f1a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f1d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f20:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f23:	89 ec                	mov    %ebp,%esp
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	83 ec 38             	sub    $0x38,%esp
  800f2d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f30:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f33:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	89 df                	mov    %ebx,%edi
  800f48:	89 de                	mov    %ebx,%esi
  800f4a:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7e 28                	jle    800f78 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f50:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f54:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f5b:	00 
  800f5c:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  800f63:	00 
  800f64:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f6b:	00 
  800f6c:	c7 04 24 b1 42 80 00 	movl   $0x8042b1,(%esp)
  800f73:	e8 74 2a 00 00       	call   8039ec <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f78:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f7b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f7e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f81:	89 ec                	mov    %ebp,%esp
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 38             	sub    $0x38,%esp
  800f8b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f8e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f91:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f99:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa4:	89 df                	mov    %ebx,%edi
  800fa6:	89 de                	mov    %ebx,%esi
  800fa8:	cd 30                	int    $0x30

	if(check && ret > 0)
  800faa:	85 c0                	test   %eax,%eax
  800fac:	7e 28                	jle    800fd6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fae:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  800fb9:	00 
  800fba:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  800fc1:	00 
  800fc2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc9:	00 
  800fca:	c7 04 24 b1 42 80 00 	movl   $0x8042b1,(%esp)
  800fd1:	e8 16 2a 00 00       	call   8039ec <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fd6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fd9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fdc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fdf:	89 ec                	mov    %ebp,%esp
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	83 ec 0c             	sub    $0xc,%esp
  800fe9:	89 1c 24             	mov    %ebx,(%esp)
  800fec:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ff0:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ff4:	be 00 00 00 00       	mov    $0x0,%esi
  800ff9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ffe:	8b 7d 14             	mov    0x14(%ebp),%edi
  801001:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801004:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801007:	8b 55 08             	mov    0x8(%ebp),%edx
  80100a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80100c:	8b 1c 24             	mov    (%esp),%ebx
  80100f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801013:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801017:	89 ec                	mov    %ebp,%esp
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 38             	sub    $0x38,%esp
  801021:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801024:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801027:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80102a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80102f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801034:	8b 55 08             	mov    0x8(%ebp),%edx
  801037:	89 cb                	mov    %ecx,%ebx
  801039:	89 cf                	mov    %ecx,%edi
  80103b:	89 ce                	mov    %ecx,%esi
  80103d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80103f:	85 c0                	test   %eax,%eax
  801041:	7e 28                	jle    80106b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801043:	89 44 24 10          	mov    %eax,0x10(%esp)
  801047:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80104e:	00 
  80104f:	c7 44 24 08 94 42 80 	movl   $0x804294,0x8(%esp)
  801056:	00 
  801057:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105e:	00 
  80105f:	c7 04 24 b1 42 80 00 	movl   $0x8042b1,(%esp)
  801066:	e8 81 29 00 00       	call   8039ec <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80106b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80106e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801071:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801074:	89 ec                	mov    %ebp,%esp
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    

00801078 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 0c             	sub    $0xc,%esp
  80107e:	89 1c 24             	mov    %ebx,(%esp)
  801081:	89 74 24 04          	mov    %esi,0x4(%esp)
  801085:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801089:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801093:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 df                	mov    %ebx,%edi
  80109b:	89 de                	mov    %ebx,%esi
  80109d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80109f:	8b 1c 24             	mov    (%esp),%ebx
  8010a2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010a6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010aa:	89 ec                	mov    %ebp,%esp
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    

008010ae <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 0c             	sub    $0xc,%esp
  8010b4:	89 1c 24             	mov    %ebx,(%esp)
  8010b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010bb:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c4:	b8 11 00 00 00       	mov    $0x11,%eax
  8010c9:	89 d1                	mov    %edx,%ecx
  8010cb:	89 d3                	mov    %edx,%ebx
  8010cd:	89 d7                	mov    %edx,%edi
  8010cf:	89 d6                	mov    %edx,%esi
  8010d1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010d3:	8b 1c 24             	mov    (%esp),%ebx
  8010d6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010da:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010de:	89 ec                	mov    %ebp,%esp
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    

008010e2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 0c             	sub    $0xc,%esp
  8010e8:	89 1c 24             	mov    %ebx,(%esp)
  8010eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010ef:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f8:	b8 12 00 00 00       	mov    $0x12,%eax
  8010fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	89 df                	mov    %ebx,%edi
  801105:	89 de                	mov    %ebx,%esi
  801107:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801109:	8b 1c 24             	mov    (%esp),%ebx
  80110c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801110:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801114:	89 ec                	mov    %ebp,%esp
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    

00801118 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	83 ec 0c             	sub    $0xc,%esp
  80111e:	89 1c 24             	mov    %ebx,(%esp)
  801121:	89 74 24 04          	mov    %esi,0x4(%esp)
  801125:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801129:	b9 00 00 00 00       	mov    $0x0,%ecx
  80112e:	b8 13 00 00 00       	mov    $0x13,%eax
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 cb                	mov    %ecx,%ebx
  801138:	89 cf                	mov    %ecx,%edi
  80113a:	89 ce                	mov    %ecx,%esi
  80113c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80113e:	8b 1c 24             	mov    (%esp),%ebx
  801141:	8b 74 24 04          	mov    0x4(%esp),%esi
  801145:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801149:	89 ec                	mov    %ebp,%esp
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    

0080114d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 0c             	sub    $0xc,%esp
  801153:	89 1c 24             	mov    %ebx,(%esp)
  801156:	89 74 24 04          	mov    %esi,0x4(%esp)
  80115a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80115e:	b8 10 00 00 00       	mov    $0x10,%eax
  801163:	8b 75 18             	mov    0x18(%ebp),%esi
  801166:	8b 7d 14             	mov    0x14(%ebp),%edi
  801169:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80116c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116f:	8b 55 08             	mov    0x8(%ebp),%edx
  801172:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801174:	8b 1c 24             	mov    (%esp),%ebx
  801177:	8b 74 24 04          	mov    0x4(%esp),%esi
  80117b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80117f:	89 ec                	mov    %ebp,%esp
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    
	...

00801190 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801193:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801198:	75 11                	jne    8011ab <_ZL8fd_validPK2Fd+0x1b>
  80119a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80119f:	76 0a                	jbe    8011ab <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  8011a1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  8011a6:	0f 96 c0             	setbe  %al
  8011a9:	eb 05                	jmp    8011b0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8011ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    

008011b2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	53                   	push   %ebx
  8011b6:	83 ec 14             	sub    $0x14,%esp
  8011b9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8011bb:	e8 d0 ff ff ff       	call   801190 <_ZL8fd_validPK2Fd>
  8011c0:	84 c0                	test   %al,%al
  8011c2:	75 24                	jne    8011e8 <_ZL9fd_isopenPK2Fd+0x36>
  8011c4:	c7 44 24 0c bf 42 80 	movl   $0x8042bf,0xc(%esp)
  8011cb:	00 
  8011cc:	c7 44 24 08 cc 42 80 	movl   $0x8042cc,0x8(%esp)
  8011d3:	00 
  8011d4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8011db:	00 
  8011dc:	c7 04 24 e1 42 80 00 	movl   $0x8042e1,(%esp)
  8011e3:	e8 04 28 00 00       	call   8039ec <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  8011e8:	89 d8                	mov    %ebx,%eax
  8011ea:	c1 e8 16             	shr    $0x16,%eax
  8011ed:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  8011f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f9:	f6 c2 01             	test   $0x1,%dl
  8011fc:	74 0d                	je     80120b <_ZL9fd_isopenPK2Fd+0x59>
  8011fe:	c1 eb 0c             	shr    $0xc,%ebx
  801201:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801208:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80120b:	83 c4 14             	add    $0x14,%esp
  80120e:	5b                   	pop    %ebx
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	89 1c 24             	mov    %ebx,(%esp)
  80121a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80121e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801221:	8b 75 0c             	mov    0xc(%ebp),%esi
  801224:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801228:	83 fb 1f             	cmp    $0x1f,%ebx
  80122b:	77 18                	ja     801245 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80122d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801233:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801236:	84 c0                	test   %al,%al
  801238:	74 21                	je     80125b <_Z9fd_lookupiPP2Fdb+0x4a>
  80123a:	89 d8                	mov    %ebx,%eax
  80123c:	e8 71 ff ff ff       	call   8011b2 <_ZL9fd_isopenPK2Fd>
  801241:	84 c0                	test   %al,%al
  801243:	75 16                	jne    80125b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801245:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80124b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801250:	8b 1c 24             	mov    (%esp),%ebx
  801253:	8b 74 24 04          	mov    0x4(%esp),%esi
  801257:	89 ec                	mov    %ebp,%esp
  801259:	5d                   	pop    %ebp
  80125a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80125b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
  801262:	eb ec                	jmp    801250 <_Z9fd_lookupiPP2Fdb+0x3f>

00801264 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	53                   	push   %ebx
  801268:	83 ec 14             	sub    $0x14,%esp
  80126b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80126e:	89 d8                	mov    %ebx,%eax
  801270:	e8 1b ff ff ff       	call   801190 <_ZL8fd_validPK2Fd>
  801275:	84 c0                	test   %al,%al
  801277:	75 24                	jne    80129d <_Z6fd2numP2Fd+0x39>
  801279:	c7 44 24 0c bf 42 80 	movl   $0x8042bf,0xc(%esp)
  801280:	00 
  801281:	c7 44 24 08 cc 42 80 	movl   $0x8042cc,0x8(%esp)
  801288:	00 
  801289:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801290:	00 
  801291:	c7 04 24 e1 42 80 00 	movl   $0x8042e1,(%esp)
  801298:	e8 4f 27 00 00       	call   8039ec <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80129d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  8012a3:	c1 e8 0c             	shr    $0xc,%eax
}
  8012a6:	83 c4 14             	add    $0x14,%esp
  8012a9:	5b                   	pop    %ebx
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	89 04 24             	mov    %eax,(%esp)
  8012b8:	e8 a7 ff ff ff       	call   801264 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8012bd:	05 20 00 0d 00       	add    $0xd0020,%eax
  8012c2:	c1 e0 0c             	shl    $0xc,%eax
}
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	57                   	push   %edi
  8012cb:	56                   	push   %esi
  8012cc:	53                   	push   %ebx
  8012cd:	83 ec 2c             	sub    $0x2c,%esp
  8012d0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8012d3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8012d8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8012db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012e2:	00 
  8012e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e7:	89 1c 24             	mov    %ebx,(%esp)
  8012ea:	e8 22 ff ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  8012ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f2:	e8 bb fe ff ff       	call   8011b2 <_ZL9fd_isopenPK2Fd>
  8012f7:	84 c0                	test   %al,%al
  8012f9:	75 0c                	jne    801307 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  8012fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012fe:	89 07                	mov    %eax,(%edi)
			return 0;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	eb 13                	jmp    80131a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801307:	83 c3 01             	add    $0x1,%ebx
  80130a:	83 fb 20             	cmp    $0x20,%ebx
  80130d:	75 cc                	jne    8012db <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80130f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801315:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80131a:	83 c4 2c             	add    $0x2c,%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5e                   	pop    %esi
  80131f:	5f                   	pop    %edi
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    

00801322 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	53                   	push   %ebx
  801326:	83 ec 14             	sub    $0x14,%esp
  801329:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80132f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801334:	39 0d 04 50 80 00    	cmp    %ecx,0x805004
  80133a:	75 16                	jne    801352 <_Z10dev_lookupiPP3Dev+0x30>
  80133c:	eb 06                	jmp    801344 <_Z10dev_lookupiPP3Dev+0x22>
  80133e:	39 0a                	cmp    %ecx,(%edx)
  801340:	75 10                	jne    801352 <_Z10dev_lookupiPP3Dev+0x30>
  801342:	eb 05                	jmp    801349 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801344:	ba 04 50 80 00       	mov    $0x805004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801349:	89 13                	mov    %edx,(%ebx)
			return 0;
  80134b:	b8 00 00 00 00       	mov    $0x0,%eax
  801350:	eb 35                	jmp    801387 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801352:	83 c0 01             	add    $0x1,%eax
  801355:	8b 14 85 4c 43 80 00 	mov    0x80434c(,%eax,4),%edx
  80135c:	85 d2                	test   %edx,%edx
  80135e:	75 de                	jne    80133e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801360:	a1 00 60 80 00       	mov    0x806000,%eax
  801365:	8b 40 04             	mov    0x4(%eax),%eax
  801368:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80136c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801370:	c7 04 24 08 43 80 00 	movl   $0x804308,(%esp)
  801377:	e8 d2 ee ff ff       	call   80024e <_Z7cprintfPKcz>
	*dev = 0;
  80137c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801382:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801387:	83 c4 14             	add    $0x14,%esp
  80138a:	5b                   	pop    %ebx
  80138b:	5d                   	pop    %ebp
  80138c:	c3                   	ret    

0080138d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	56                   	push   %esi
  801391:	53                   	push   %ebx
  801392:	83 ec 20             	sub    $0x20,%esp
  801395:	8b 75 08             	mov    0x8(%ebp),%esi
  801398:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80139c:	89 34 24             	mov    %esi,(%esp)
  80139f:	e8 c0 fe ff ff       	call   801264 <_Z6fd2numP2Fd>
  8013a4:	0f b6 d3             	movzbl %bl,%edx
  8013a7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013ab:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8013ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013b2:	89 04 24             	mov    %eax,(%esp)
  8013b5:	e8 57 fe ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	78 05                	js     8013c3 <_Z8fd_closeP2Fdb+0x36>
  8013be:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8013c1:	74 0c                	je     8013cf <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  8013c3:	80 fb 01             	cmp    $0x1,%bl
  8013c6:	19 db                	sbb    %ebx,%ebx
  8013c8:	f7 d3                	not    %ebx
  8013ca:	83 e3 fd             	and    $0xfffffffd,%ebx
  8013cd:	eb 3d                	jmp    80140c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d6:	8b 06                	mov    (%esi),%eax
  8013d8:	89 04 24             	mov    %eax,(%esp)
  8013db:	e8 42 ff ff ff       	call   801322 <_Z10dev_lookupiPP3Dev>
  8013e0:	89 c3                	mov    %eax,%ebx
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 16                	js     8013fc <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8013ec:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	74 07                	je     8013fc <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  8013f5:	89 34 24             	mov    %esi,(%esp)
  8013f8:	ff d0                	call   *%eax
  8013fa:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8013fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801400:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801407:	e8 01 fa ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
	return r;
}
  80140c:	89 d8                	mov    %ebx,%eax
  80140e:	83 c4 20             	add    $0x20,%esp
  801411:	5b                   	pop    %ebx
  801412:	5e                   	pop    %esi
  801413:	5d                   	pop    %ebp
  801414:	c3                   	ret    

00801415 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80141b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801422:	00 
  801423:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801426:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	89 04 24             	mov    %eax,(%esp)
  801430:	e8 dc fd ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  801435:	85 c0                	test   %eax,%eax
  801437:	78 13                	js     80144c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801439:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801440:	00 
  801441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801444:	89 04 24             	mov    %eax,(%esp)
  801447:	e8 41 ff ff ff       	call   80138d <_Z8fd_closeP2Fdb>
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <_Z9close_allv>:

void
close_all(void)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	53                   	push   %ebx
  801452:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801455:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80145a:	89 1c 24             	mov    %ebx,(%esp)
  80145d:	e8 b3 ff ff ff       	call   801415 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801462:	83 c3 01             	add    $0x1,%ebx
  801465:	83 fb 20             	cmp    $0x20,%ebx
  801468:	75 f0                	jne    80145a <_Z9close_allv+0xc>
		close(i);
}
  80146a:	83 c4 14             	add    $0x14,%esp
  80146d:	5b                   	pop    %ebx
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 48             	sub    $0x48,%esp
  801476:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801479:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80147c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80147f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801482:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801489:	00 
  80148a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80148d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	89 04 24             	mov    %eax,(%esp)
  801497:	e8 75 fd ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  80149c:	89 c3                	mov    %eax,%ebx
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	0f 88 ce 00 00 00    	js     801574 <_Z3dupii+0x104>
  8014a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014ad:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  8014ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014b1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8014b5:	89 34 24             	mov    %esi,(%esp)
  8014b8:	e8 54 fd ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  8014bd:	89 c3                	mov    %eax,%ebx
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	0f 89 bc 00 00 00    	jns    801583 <_Z3dupii+0x113>
  8014c7:	e9 a8 00 00 00       	jmp    801574 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8014cc:	89 d8                	mov    %ebx,%eax
  8014ce:	c1 e8 0c             	shr    $0xc,%eax
  8014d1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8014d8:	f6 c2 01             	test   $0x1,%dl
  8014db:	74 32                	je     80150f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014dd:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8014e4:	25 07 0e 00 00       	and    $0xe07,%eax
  8014e9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014f8:	00 
  8014f9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801504:	e8 a6 f8 ff ff       	call   800daf <_Z12sys_page_mapiPviS_i>
  801509:	89 c3                	mov    %eax,%ebx
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 3e                	js     80154d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80150f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801512:	89 c2                	mov    %eax,%edx
  801514:	c1 ea 0c             	shr    $0xc,%edx
  801517:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80151e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801524:	89 54 24 10          	mov    %edx,0x10(%esp)
  801528:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80152b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80152f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801536:	00 
  801537:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801542:	e8 68 f8 ff ff       	call   800daf <_Z12sys_page_mapiPviS_i>
  801547:	89 c3                	mov    %eax,%ebx
  801549:	85 c0                	test   %eax,%eax
  80154b:	79 25                	jns    801572 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80154d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801550:	89 44 24 04          	mov    %eax,0x4(%esp)
  801554:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80155b:	e8 ad f8 ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801560:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801564:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80156b:	e8 9d f8 ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
	return r;
  801570:	eb 02                	jmp    801574 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801572:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801574:	89 d8                	mov    %ebx,%eax
  801576:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801579:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80157c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80157f:	89 ec                	mov    %ebp,%esp
  801581:	5d                   	pop    %ebp
  801582:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801583:	89 34 24             	mov    %esi,(%esp)
  801586:	e8 8a fe ff ff       	call   801415 <_Z5closei>

	ova = fd2data(oldfd);
  80158b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158e:	89 04 24             	mov    %eax,(%esp)
  801591:	e8 16 fd ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  801596:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801598:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80159b:	89 04 24             	mov    %eax,(%esp)
  80159e:	e8 09 fd ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  8015a3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8015a5:	89 d8                	mov    %ebx,%eax
  8015a7:	c1 e8 16             	shr    $0x16,%eax
  8015aa:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8015b1:	a8 01                	test   $0x1,%al
  8015b3:	0f 85 13 ff ff ff    	jne    8014cc <_Z3dupii+0x5c>
  8015b9:	e9 51 ff ff ff       	jmp    80150f <_Z3dupii+0x9f>

008015be <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 24             	sub    $0x24,%esp
  8015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8015c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8015cf:	00 
  8015d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d7:	89 1c 24             	mov    %ebx,(%esp)
  8015da:	e8 32 fc ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 5f                	js     801642 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8015ed:	8b 00                	mov    (%eax),%eax
  8015ef:	89 04 24             	mov    %eax,(%esp)
  8015f2:	e8 2b fd ff ff       	call   801322 <_Z10dev_lookupiPP3Dev>
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	79 4d                	jns    801648 <_Z4readiPvj+0x8a>
  8015fb:	eb 45                	jmp    801642 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015fd:	a1 00 60 80 00       	mov    0x806000,%eax
  801602:	8b 40 04             	mov    0x4(%eax),%eax
  801605:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801609:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160d:	c7 04 24 ea 42 80 00 	movl   $0x8042ea,(%esp)
  801614:	e8 35 ec ff ff       	call   80024e <_Z7cprintfPKcz>
		return -E_INVAL;
  801619:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161e:	eb 22                	jmp    801642 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801623:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801626:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80162b:	85 d2                	test   %edx,%edx
  80162d:	74 13                	je     801642 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80162f:	8b 45 10             	mov    0x10(%ebp),%eax
  801632:	89 44 24 08          	mov    %eax,0x8(%esp)
  801636:	8b 45 0c             	mov    0xc(%ebp),%eax
  801639:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163d:	89 0c 24             	mov    %ecx,(%esp)
  801640:	ff d2                	call   *%edx
}
  801642:	83 c4 24             	add    $0x24,%esp
  801645:	5b                   	pop    %ebx
  801646:	5d                   	pop    %ebp
  801647:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801648:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80164b:	8b 41 08             	mov    0x8(%ecx),%eax
  80164e:	83 e0 03             	and    $0x3,%eax
  801651:	83 f8 01             	cmp    $0x1,%eax
  801654:	75 ca                	jne    801620 <_Z4readiPvj+0x62>
  801656:	eb a5                	jmp    8015fd <_Z4readiPvj+0x3f>

00801658 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	57                   	push   %edi
  80165c:	56                   	push   %esi
  80165d:	53                   	push   %ebx
  80165e:	83 ec 1c             	sub    $0x1c,%esp
  801661:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801664:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801667:	85 f6                	test   %esi,%esi
  801669:	74 2f                	je     80169a <_Z5readniPvj+0x42>
  80166b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801670:	89 f0                	mov    %esi,%eax
  801672:	29 d8                	sub    %ebx,%eax
  801674:	89 44 24 08          	mov    %eax,0x8(%esp)
  801678:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80167b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	89 04 24             	mov    %eax,(%esp)
  801685:	e8 34 ff ff ff       	call   8015be <_Z4readiPvj>
		if (m < 0)
  80168a:	85 c0                	test   %eax,%eax
  80168c:	78 13                	js     8016a1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  80168e:	85 c0                	test   %eax,%eax
  801690:	74 0d                	je     80169f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801692:	01 c3                	add    %eax,%ebx
  801694:	39 de                	cmp    %ebx,%esi
  801696:	77 d8                	ja     801670 <_Z5readniPvj+0x18>
  801698:	eb 05                	jmp    80169f <_Z5readniPvj+0x47>
  80169a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80169f:	89 d8                	mov    %ebx,%eax
}
  8016a1:	83 c4 1c             	add    $0x1c,%esp
  8016a4:	5b                   	pop    %ebx
  8016a5:	5e                   	pop    %esi
  8016a6:	5f                   	pop    %edi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    

008016a9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016af:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8016b6:	00 
  8016b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 04 24             	mov    %eax,(%esp)
  8016c4:	e8 48 fb ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 3c                	js     801709 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016d7:	8b 00                	mov    (%eax),%eax
  8016d9:	89 04 24             	mov    %eax,(%esp)
  8016dc:	e8 41 fc ff ff       	call   801322 <_Z10dev_lookupiPP3Dev>
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	79 26                	jns    80170b <_Z5writeiPKvj+0x62>
  8016e5:	eb 22                	jmp    801709 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8016e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ea:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  8016ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8016f2:	85 c9                	test   %ecx,%ecx
  8016f4:	74 13                	je     801709 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801700:	89 44 24 04          	mov    %eax,0x4(%esp)
  801704:	89 14 24             	mov    %edx,(%esp)
  801707:	ff d1                	call   *%ecx
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80170b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80170e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801713:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801717:	74 f0                	je     801709 <_Z5writeiPKvj+0x60>
  801719:	eb cc                	jmp    8016e7 <_Z5writeiPKvj+0x3e>

0080171b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801721:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801728:	00 
  801729:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	89 04 24             	mov    %eax,(%esp)
  801736:	e8 d6 fa ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  80173b:	85 c0                	test   %eax,%eax
  80173d:	78 0e                	js     80174d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80173f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	53                   	push   %ebx
  801753:	83 ec 24             	sub    $0x24,%esp
  801756:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801759:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801760:	00 
  801761:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801764:	89 44 24 04          	mov    %eax,0x4(%esp)
  801768:	89 1c 24             	mov    %ebx,(%esp)
  80176b:	e8 a1 fa ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  801770:	85 c0                	test   %eax,%eax
  801772:	78 58                	js     8017cc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801774:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80177e:	8b 00                	mov    (%eax),%eax
  801780:	89 04 24             	mov    %eax,(%esp)
  801783:	e8 9a fb ff ff       	call   801322 <_Z10dev_lookupiPP3Dev>
  801788:	85 c0                	test   %eax,%eax
  80178a:	79 46                	jns    8017d2 <_Z9ftruncateii+0x83>
  80178c:	eb 3e                	jmp    8017cc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  80178e:	a1 00 60 80 00       	mov    0x806000,%eax
  801793:	8b 40 04             	mov    0x4(%eax),%eax
  801796:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80179a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179e:	c7 04 24 28 43 80 00 	movl   $0x804328,(%esp)
  8017a5:	e8 a4 ea ff ff       	call   80024e <_Z7cprintfPKcz>
		return -E_INVAL;
  8017aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017af:	eb 1b                	jmp    8017cc <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8017b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017bc:	85 d2                	test   %edx,%edx
  8017be:	74 0c                	je     8017cc <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c7:	89 0c 24             	mov    %ecx,(%esp)
  8017ca:	ff d2                	call   *%edx
}
  8017cc:	83 c4 24             	add    $0x24,%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5d                   	pop    %ebp
  8017d1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017d5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  8017d9:	75 d6                	jne    8017b1 <_Z9ftruncateii+0x62>
  8017db:	eb b1                	jmp    80178e <_Z9ftruncateii+0x3f>

008017dd <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 24             	sub    $0x24,%esp
  8017e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8017e7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017ee:	00 
  8017ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	89 04 24             	mov    %eax,(%esp)
  8017fc:	e8 10 fa ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  801801:	85 c0                	test   %eax,%eax
  801803:	78 3e                	js     801843 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801805:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80180f:	8b 00                	mov    (%eax),%eax
  801811:	89 04 24             	mov    %eax,(%esp)
  801814:	e8 09 fb ff ff       	call   801322 <_Z10dev_lookupiPP3Dev>
  801819:	85 c0                	test   %eax,%eax
  80181b:	79 2c                	jns    801849 <_Z5fstatiP4Stat+0x6c>
  80181d:	eb 24                	jmp    801843 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80181f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801822:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801829:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801830:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801836:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80183a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183d:	89 04 24             	mov    %eax,(%esp)
  801840:	ff 52 14             	call   *0x14(%edx)
}
  801843:	83 c4 24             	add    $0x24,%esp
  801846:	5b                   	pop    %ebx
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801849:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80184c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801851:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801855:	75 c8                	jne    80181f <_Z5fstatiP4Stat+0x42>
  801857:	eb ea                	jmp    801843 <_Z5fstatiP4Stat+0x66>

00801859 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 18             	sub    $0x18,%esp
  80185f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801862:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801865:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80186c:	00 
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	89 04 24             	mov    %eax,(%esp)
  801873:	e8 d6 09 00 00       	call   80224e <_Z4openPKci>
  801878:	89 c3                	mov    %eax,%ebx
  80187a:	85 c0                	test   %eax,%eax
  80187c:	78 1b                	js     801899 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80187e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801881:	89 44 24 04          	mov    %eax,0x4(%esp)
  801885:	89 1c 24             	mov    %ebx,(%esp)
  801888:	e8 50 ff ff ff       	call   8017dd <_Z5fstatiP4Stat>
  80188d:	89 c6                	mov    %eax,%esi
	close(fd);
  80188f:	89 1c 24             	mov    %ebx,(%esp)
  801892:	e8 7e fb ff ff       	call   801415 <_Z5closei>
	return r;
  801897:	89 f3                	mov    %esi,%ebx
}
  801899:	89 d8                	mov    %ebx,%eax
  80189b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80189e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8018a1:	89 ec                	mov    %ebp,%esp
  8018a3:	5d                   	pop    %ebp
  8018a4:	c3                   	ret    
	...

008018b0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8018b3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8018b8:	85 d2                	test   %edx,%edx
  8018ba:	78 33                	js     8018ef <_ZL10inode_dataP5Inodei+0x3f>
  8018bc:	3b 50 08             	cmp    0x8(%eax),%edx
  8018bf:	7d 2e                	jge    8018ef <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  8018c1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8018c7:	85 d2                	test   %edx,%edx
  8018c9:	0f 49 ca             	cmovns %edx,%ecx
  8018cc:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  8018cf:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  8018d3:	c1 e1 0c             	shl    $0xc,%ecx
  8018d6:	89 d0                	mov    %edx,%eax
  8018d8:	c1 f8 1f             	sar    $0x1f,%eax
  8018db:	c1 e8 14             	shr    $0x14,%eax
  8018de:	01 c2                	add    %eax,%edx
  8018e0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8018e6:	29 c2                	sub    %eax,%edx
  8018e8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  8018ef:	89 c8                	mov    %ecx,%eax
  8018f1:	5d                   	pop    %ebp
  8018f2:	c3                   	ret    

008018f3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  8018f6:	8b 48 08             	mov    0x8(%eax),%ecx
  8018f9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  8018fc:	8b 00                	mov    (%eax),%eax
  8018fe:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801901:	c7 82 80 00 00 00 04 	movl   $0x805004,0x80(%edx)
  801908:	50 80 00 
}
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    

0080190d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801913:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801919:	85 c0                	test   %eax,%eax
  80191b:	74 08                	je     801925 <_ZL9get_inodei+0x18>
  80191d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801923:	7e 20                	jle    801945 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801925:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801929:	c7 44 24 08 60 43 80 	movl   $0x804360,0x8(%esp)
  801930:	00 
  801931:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801938:	00 
  801939:	c7 04 24 76 43 80 00 	movl   $0x804376,(%esp)
  801940:	e8 a7 20 00 00       	call   8039ec <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801945:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80194b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801951:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801957:	85 d2                	test   %edx,%edx
  801959:	0f 48 d1             	cmovs  %ecx,%edx
  80195c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  80195f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801966:	c1 e0 0c             	shl    $0xc,%eax
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801973:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801979:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  80197c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801982:	76 20                	jbe    8019a4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801984:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801988:	c7 44 24 08 9c 43 80 	movl   $0x80439c,0x8(%esp)
  80198f:	00 
  801990:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801997:	00 
  801998:	c7 04 24 76 43 80 00 	movl   $0x804376,(%esp)
  80199f:	e8 48 20 00 00       	call   8039ec <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  8019a4:	83 fe 01             	cmp    $0x1,%esi
  8019a7:	7e 08                	jle    8019b1 <_ZL10bcache_ipcPvi+0x46>
  8019a9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  8019af:	7d 12                	jge    8019c3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8019b1:	89 f3                	mov    %esi,%ebx
  8019b3:	c1 e3 04             	shl    $0x4,%ebx
  8019b6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8019b8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  8019be:	c1 e6 0c             	shl    $0xc,%esi
  8019c1:	eb 20                	jmp    8019e3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  8019c3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019c7:	c7 44 24 08 cc 43 80 	movl   $0x8043cc,0x8(%esp)
  8019ce:	00 
  8019cf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8019d6:	00 
  8019d7:	c7 04 24 76 43 80 00 	movl   $0x804376,(%esp)
  8019de:	e8 09 20 00 00       	call   8039ec <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8019e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ea:	00 
  8019eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019f2:	00 
  8019f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019f7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  8019fe:	e8 3c 22 00 00       	call   803c3f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801a03:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a0a:	00 
  801a0b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a16:	e8 95 21 00 00       	call   803bb0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801a1b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801a1e:	74 c3                	je     8019e3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5d                   	pop    %ebp
  801a26:	c3                   	ret    

00801a27 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 28             	sub    $0x28,%esp
  801a2d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a30:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a33:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a36:	89 c7                	mov    %eax,%edi
  801a38:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801a3a:	c7 04 24 cd 1c 80 00 	movl   $0x801ccd,(%esp)
  801a41:	e8 75 20 00 00       	call   803abb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801a46:	89 f8                	mov    %edi,%eax
  801a48:	e8 c0 fe ff ff       	call   80190d <_ZL9get_inodei>
  801a4d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801a4f:	ba 02 00 00 00       	mov    $0x2,%edx
  801a54:	e8 12 ff ff ff       	call   80196b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	79 08                	jns    801a65 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801a5d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801a63:	eb 2e                	jmp    801a93 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801a65:	85 c0                	test   %eax,%eax
  801a67:	75 1c                	jne    801a85 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801a69:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801a6f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801a76:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801a79:	ba 06 00 00 00       	mov    $0x6,%edx
  801a7e:	89 d8                	mov    %ebx,%eax
  801a80:	e8 e6 fe ff ff       	call   80196b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801a85:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801a8c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801a8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a93:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a96:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a99:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a9c:	89 ec                	mov    %ebp,%esp
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    

00801aa0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	57                   	push   %edi
  801aa4:	56                   	push   %esi
  801aa5:	53                   	push   %ebx
  801aa6:	83 ec 2c             	sub    $0x2c,%esp
  801aa9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801aac:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801aaf:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801ab4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801aba:	0f 87 3d 01 00 00    	ja     801bfd <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801ac0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801ac3:	8b 42 08             	mov    0x8(%edx),%eax
  801ac6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801acc:	85 c0                	test   %eax,%eax
  801ace:	0f 49 f0             	cmovns %eax,%esi
  801ad1:	c1 fe 0c             	sar    $0xc,%esi
  801ad4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801ad6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801ad9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801adf:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801ae2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801ae5:	0f 82 a6 00 00 00    	jb     801b91 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801aeb:	39 fe                	cmp    %edi,%esi
  801aed:	0f 8d f2 00 00 00    	jge    801be5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801af3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801af7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801afa:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801afd:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801b00:	83 3e 00             	cmpl   $0x0,(%esi)
  801b03:	75 77                	jne    801b7c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801b05:	ba 02 00 00 00       	mov    $0x2,%edx
  801b0a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801b0f:	e8 57 fe ff ff       	call   80196b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801b14:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801b1a:	83 f9 02             	cmp    $0x2,%ecx
  801b1d:	7e 43                	jle    801b62 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801b1f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801b24:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801b29:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801b30:	74 29                	je     801b5b <_ZL14inode_set_sizeP5Inodej+0xbb>
  801b32:	e9 ce 00 00 00       	jmp    801c05 <_ZL14inode_set_sizeP5Inodej+0x165>
  801b37:	89 c7                	mov    %eax,%edi
  801b39:	0f b6 10             	movzbl (%eax),%edx
  801b3c:	83 c0 01             	add    $0x1,%eax
  801b3f:	84 d2                	test   %dl,%dl
  801b41:	74 18                	je     801b5b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801b43:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801b46:	ba 05 00 00 00       	mov    $0x5,%edx
  801b4b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801b50:	e8 16 fe ff ff       	call   80196b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801b55:	85 db                	test   %ebx,%ebx
  801b57:	79 1e                	jns    801b77 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801b59:	eb 07                	jmp    801b62 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801b5b:	83 c3 01             	add    $0x1,%ebx
  801b5e:	39 d9                	cmp    %ebx,%ecx
  801b60:	7f d5                	jg     801b37 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801b62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b65:	8b 50 08             	mov    0x8(%eax),%edx
  801b68:	e8 33 ff ff ff       	call   801aa0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801b6d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801b72:	e9 86 00 00 00       	jmp    801bfd <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801b77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b7a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801b7c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801b80:	83 c6 04             	add    $0x4,%esi
  801b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b86:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801b89:	0f 8f 6e ff ff ff    	jg     801afd <_ZL14inode_set_sizeP5Inodej+0x5d>
  801b8f:	eb 54                	jmp    801be5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801b91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b94:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801b99:	83 f8 01             	cmp    $0x1,%eax
  801b9c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801b9f:	ba 02 00 00 00       	mov    $0x2,%edx
  801ba4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801ba9:	e8 bd fd ff ff       	call   80196b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801bae:	39 f7                	cmp    %esi,%edi
  801bb0:	7d 24                	jge    801bd6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801bb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801bb5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801bb9:	8b 10                	mov    (%eax),%edx
  801bbb:	85 d2                	test   %edx,%edx
  801bbd:	74 0d                	je     801bcc <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801bbf:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801bc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801bcc:	83 eb 01             	sub    $0x1,%ebx
  801bcf:	83 e8 04             	sub    $0x4,%eax
  801bd2:	39 fb                	cmp    %edi,%ebx
  801bd4:	75 e3                	jne    801bb9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801bd6:	ba 05 00 00 00       	mov    $0x5,%edx
  801bdb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801be0:	e8 86 fd ff ff       	call   80196b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801be5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801be8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801beb:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801bee:	ba 04 00 00 00       	mov    $0x4,%edx
  801bf3:	e8 73 fd ff ff       	call   80196b <_ZL10bcache_ipcPvi>
	return 0;
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfd:	83 c4 2c             	add    $0x2c,%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5f                   	pop    %edi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801c05:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c0c:	ba 05 00 00 00       	mov    $0x5,%edx
  801c11:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c16:	e8 50 fd ff ff       	call   80196b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c1b:	bb 02 00 00 00       	mov    $0x2,%ebx
  801c20:	e9 52 ff ff ff       	jmp    801b77 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801c25 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	53                   	push   %ebx
  801c29:	83 ec 04             	sub    $0x4,%esp
  801c2c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801c2e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801c34:	83 e8 01             	sub    $0x1,%eax
  801c37:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801c3d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801c41:	75 40                	jne    801c83 <_ZL11inode_closeP5Inode+0x5e>
  801c43:	85 c0                	test   %eax,%eax
  801c45:	75 3c                	jne    801c83 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801c47:	ba 02 00 00 00       	mov    $0x2,%edx
  801c4c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c51:	e8 15 fd ff ff       	call   80196b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801c5b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801c5f:	85 d2                	test   %edx,%edx
  801c61:	74 07                	je     801c6a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801c63:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801c6a:	83 c0 01             	add    $0x1,%eax
  801c6d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801c72:	75 e7                	jne    801c5b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c74:	ba 05 00 00 00       	mov    $0x5,%edx
  801c79:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c7e:	e8 e8 fc ff ff       	call   80196b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801c83:	ba 03 00 00 00       	mov    $0x3,%edx
  801c88:	89 d8                	mov    %ebx,%eax
  801c8a:	e8 dc fc ff ff       	call   80196b <_ZL10bcache_ipcPvi>
}
  801c8f:	83 c4 04             	add    $0x4,%esp
  801c92:	5b                   	pop    %ebx
  801c93:	5d                   	pop    %ebp
  801c94:	c3                   	ret    

00801c95 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	53                   	push   %ebx
  801c99:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ca5:	e8 7d fd ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  801caa:	89 c3                	mov    %eax,%ebx
  801cac:	85 c0                	test   %eax,%eax
  801cae:	78 15                	js     801cc5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb6:	e8 e5 fd ff ff       	call   801aa0 <_ZL14inode_set_sizeP5Inodej>
  801cbb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc0:	e8 60 ff ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
	return r;
}
  801cc5:	89 d8                	mov    %ebx,%eax
  801cc7:	83 c4 14             	add    $0x14,%esp
  801cca:	5b                   	pop    %ebx
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    

00801ccd <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	53                   	push   %ebx
  801cd1:	83 ec 14             	sub    $0x14,%esp
  801cd4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801cd7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801cd9:	89 c2                	mov    %eax,%edx
  801cdb:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801ce1:	78 32                	js     801d15 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce8:	e8 7e fc ff ff       	call   80196b <_ZL10bcache_ipcPvi>
  801ced:	85 c0                	test   %eax,%eax
  801cef:	74 1c                	je     801d0d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801cf1:	c7 44 24 08 81 43 80 	movl   $0x804381,0x8(%esp)
  801cf8:	00 
  801cf9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801d00:	00 
  801d01:	c7 04 24 76 43 80 00 	movl   $0x804376,(%esp)
  801d08:	e8 df 1c 00 00       	call   8039ec <_Z6_panicPKciS0_z>
    resume(utf);
  801d0d:	89 1c 24             	mov    %ebx,(%esp)
  801d10:	e8 7b 1e 00 00       	call   803b90 <resume>
}
  801d15:	83 c4 14             	add    $0x14,%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    

00801d1b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 28             	sub    $0x28,%esp
  801d21:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d24:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d2a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801d2d:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d30:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d33:	e8 ef fc ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	78 26                	js     801d62 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  801d3c:	83 c3 10             	add    $0x10,%ebx
  801d3f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d43:	89 34 24             	mov    %esi,(%esp)
  801d46:	e8 1f eb ff ff       	call   80086a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801d4b:	89 f2                	mov    %esi,%edx
  801d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d50:	e8 9e fb ff ff       	call   8018f3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  801d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d58:	e8 c8 fe ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
	return 0;
  801d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d62:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d65:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d68:	89 ec                	mov    %ebp,%esp
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    

00801d6c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 24             	sub    $0x24,%esp
  801d73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801d76:	89 1c 24             	mov    %ebx,(%esp)
  801d79:	e8 9e 15 00 00       	call   80331c <_Z7pagerefPv>
  801d7e:	89 c2                	mov    %eax,%edx
        return 0;
  801d80:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801d85:	83 fa 01             	cmp    $0x1,%edx
  801d88:	7f 1e                	jg     801da8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801d8a:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d8d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d90:	e8 92 fc ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  801d95:	85 c0                	test   %eax,%eax
  801d97:	78 0f                	js     801da8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  801da3:	e8 7d fe ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
}
  801da8:	83 c4 24             	add    $0x24,%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5d                   	pop    %ebp
  801dad:	c3                   	ret    

00801dae <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	57                   	push   %edi
  801db2:	56                   	push   %esi
  801db3:	53                   	push   %ebx
  801db4:	83 ec 3c             	sub    $0x3c,%esp
  801db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801dba:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  801dbd:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801dc3:	8b 43 0c             	mov    0xc(%ebx),%eax
  801dc6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801dc9:	e8 59 fc ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	0f 88 8c 00 00 00    	js     801e62 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801dd6:	8b 53 04             	mov    0x4(%ebx),%edx
  801dd9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  801ddf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801de5:	29 d7                	sub    %edx,%edi
  801de7:	39 f7                	cmp    %esi,%edi
  801de9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  801dec:	85 ff                	test   %edi,%edi
  801dee:	74 16                	je     801e06 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801df0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  801df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801df6:	3b 50 08             	cmp    0x8(%eax),%edx
  801df9:	76 6f                	jbe    801e6a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  801dfb:	e8 a0 fc ff ff       	call   801aa0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801e00:	85 c0                	test   %eax,%eax
  801e02:	79 66                	jns    801e6a <_ZL13devfile_writeP2FdPKvj+0xbc>
  801e04:	eb 4e                	jmp    801e54 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801e06:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  801e0c:	76 24                	jbe    801e32 <_ZL13devfile_writeP2FdPKvj+0x84>
  801e0e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801e10:	8b 53 04             	mov    0x4(%ebx),%edx
  801e13:	81 c2 00 10 00 00    	add    $0x1000,%edx
  801e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e1c:	3b 50 08             	cmp    0x8(%eax),%edx
  801e1f:	0f 86 83 00 00 00    	jbe    801ea8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  801e25:	e8 76 fc ff ff       	call   801aa0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	79 7a                	jns    801ea8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  801e2e:	66 90                	xchg   %ax,%ax
  801e30:	eb 22                	jmp    801e54 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  801e32:	85 f6                	test   %esi,%esi
  801e34:	74 1e                	je     801e54 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801e36:	89 f2                	mov    %esi,%edx
  801e38:	03 53 04             	add    0x4(%ebx),%edx
  801e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3e:	3b 50 08             	cmp    0x8(%eax),%edx
  801e41:	0f 86 b8 00 00 00    	jbe    801eff <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  801e47:	e8 54 fc ff ff       	call   801aa0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	0f 89 ab 00 00 00    	jns    801eff <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  801e54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e57:	e8 c9 fd ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  801e5c:	8b 43 04             	mov    0x4(%ebx),%eax
  801e5f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  801e62:	83 c4 3c             	add    $0x3c,%esp
  801e65:	5b                   	pop    %ebx
  801e66:	5e                   	pop    %esi
  801e67:	5f                   	pop    %edi
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  801e6a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801e6c:	8b 53 04             	mov    0x4(%ebx),%edx
  801e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e72:	e8 39 fa ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
  801e77:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  801e7a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e85:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e88:	89 04 24             	mov    %eax,(%esp)
  801e8b:	e8 f7 eb ff ff       	call   800a87 <memcpy>
        fd->fd_offset += n2;
  801e90:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  801e93:	ba 04 00 00 00       	mov    $0x4,%edx
  801e98:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e9b:	e8 cb fa ff ff       	call   80196b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  801ea0:	01 7d 0c             	add    %edi,0xc(%ebp)
  801ea3:	e9 5e ff ff ff       	jmp    801e06 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801ea8:	8b 53 04             	mov    0x4(%ebx),%edx
  801eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eae:	e8 fd f9 ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
  801eb3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  801eb5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801ebc:	00 
  801ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec4:	89 34 24             	mov    %esi,(%esp)
  801ec7:	e8 bb eb ff ff       	call   800a87 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801ecc:	ba 04 00 00 00       	mov    $0x4,%edx
  801ed1:	89 f0                	mov    %esi,%eax
  801ed3:	e8 93 fa ff ff       	call   80196b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  801ed8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  801ede:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  801ee5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801eec:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801ef2:	0f 87 18 ff ff ff    	ja     801e10 <_ZL13devfile_writeP2FdPKvj+0x62>
  801ef8:	89 fe                	mov    %edi,%esi
  801efa:	e9 33 ff ff ff       	jmp    801e32 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801eff:	8b 53 04             	mov    0x4(%ebx),%edx
  801f02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f05:	e8 a6 f9 ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
  801f0a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  801f0c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f17:	89 3c 24             	mov    %edi,(%esp)
  801f1a:	e8 68 eb ff ff       	call   800a87 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801f1f:	ba 04 00 00 00       	mov    $0x4,%edx
  801f24:	89 f8                	mov    %edi,%eax
  801f26:	e8 40 fa ff ff       	call   80196b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  801f2b:	01 73 04             	add    %esi,0x4(%ebx)
  801f2e:	e9 21 ff ff ff       	jmp    801e54 <_ZL13devfile_writeP2FdPKvj+0xa6>

00801f33 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	57                   	push   %edi
  801f37:	56                   	push   %esi
  801f38:	53                   	push   %ebx
  801f39:	83 ec 3c             	sub    $0x3c,%esp
  801f3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  801f42:	8b 43 04             	mov    0x4(%ebx),%eax
  801f45:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801f48:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f4b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801f4e:	e8 d4 fa ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  801f53:	85 c0                	test   %eax,%eax
  801f55:	0f 88 d3 00 00 00    	js     80202e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  801f5b:	8b 73 04             	mov    0x4(%ebx),%esi
  801f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f61:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  801f64:	8b 50 08             	mov    0x8(%eax),%edx
  801f67:	29 f2                	sub    %esi,%edx
  801f69:	3b 48 08             	cmp    0x8(%eax),%ecx
  801f6c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  801f6f:	89 f2                	mov    %esi,%edx
  801f71:	e8 3a f9 ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
  801f76:	85 c0                	test   %eax,%eax
  801f78:	0f 84 a2 00 00 00    	je     802020 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801f7e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  801f84:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801f8a:	29 f2                	sub    %esi,%edx
  801f8c:	39 d7                	cmp    %edx,%edi
  801f8e:	0f 46 d7             	cmovbe %edi,%edx
  801f91:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  801f94:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  801f96:	01 d6                	add    %edx,%esi
  801f98:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  801f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa6:	89 04 24             	mov    %eax,(%esp)
  801fa9:	e8 d9 ea ff ff       	call   800a87 <memcpy>
    buf = (void *)((char *)buf + n2);
  801fae:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fb1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  801fb4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801fba:	76 3e                	jbe    801ffa <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  801fbc:	8b 53 04             	mov    0x4(%ebx),%edx
  801fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc2:	e8 e9 f8 ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	74 55                	je     802020 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  801fcb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801fd2:	00 
  801fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd7:	89 34 24             	mov    %esi,(%esp)
  801fda:	e8 a8 ea ff ff       	call   800a87 <memcpy>
        n -= PGSIZE;
  801fdf:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  801fe5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  801feb:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  801ff2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801ff8:	77 c2                	ja     801fbc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  801ffa:	85 ff                	test   %edi,%edi
  801ffc:	74 22                	je     802020 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  801ffe:	8b 53 04             	mov    0x4(%ebx),%edx
  802001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802004:	e8 a7 f8 ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
  802009:	85 c0                	test   %eax,%eax
  80200b:	74 13                	je     802020 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80200d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802011:	89 44 24 04          	mov    %eax,0x4(%esp)
  802015:	89 34 24             	mov    %esi,(%esp)
  802018:	e8 6a ea ff ff       	call   800a87 <memcpy>
        fd->fd_offset += n;
  80201d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802023:	e8 fd fb ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802028:	8b 43 04             	mov    0x4(%ebx),%eax
  80202b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80202e:	83 c4 3c             	add    $0x3c,%esp
  802031:	5b                   	pop    %ebx
  802032:	5e                   	pop    %esi
  802033:	5f                   	pop    %edi
  802034:	5d                   	pop    %ebp
  802035:	c3                   	ret    

00802036 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	57                   	push   %edi
  80203a:	56                   	push   %esi
  80203b:	53                   	push   %ebx
  80203c:	83 ec 4c             	sub    $0x4c,%esp
  80203f:	89 c6                	mov    %eax,%esi
  802041:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802044:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802047:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80204d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802050:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802056:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802059:	b8 01 00 00 00       	mov    $0x1,%eax
  80205e:	e8 c4 f9 ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  802063:	89 c7                	mov    %eax,%edi
  802065:	85 c0                	test   %eax,%eax
  802067:	0f 88 cd 01 00 00    	js     80223a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80206d:	89 f3                	mov    %esi,%ebx
  80206f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802072:	75 08                	jne    80207c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802074:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802077:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80207a:	74 f8                	je     802074 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80207c:	0f b6 03             	movzbl (%ebx),%eax
  80207f:	3c 2f                	cmp    $0x2f,%al
  802081:	74 16                	je     802099 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802083:	84 c0                	test   %al,%al
  802085:	74 12                	je     802099 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802087:	89 da                	mov    %ebx,%edx
		++path;
  802089:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80208c:	0f b6 02             	movzbl (%edx),%eax
  80208f:	3c 2f                	cmp    $0x2f,%al
  802091:	74 08                	je     80209b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802093:	84 c0                	test   %al,%al
  802095:	75 f2                	jne    802089 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802097:	eb 02                	jmp    80209b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802099:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80209b:	89 d0                	mov    %edx,%eax
  80209d:	29 d8                	sub    %ebx,%eax
  80209f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  8020a2:	0f b6 02             	movzbl (%edx),%eax
  8020a5:	89 d6                	mov    %edx,%esi
  8020a7:	3c 2f                	cmp    $0x2f,%al
  8020a9:	75 0a                	jne    8020b5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  8020ab:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  8020ae:	0f b6 06             	movzbl (%esi),%eax
  8020b1:	3c 2f                	cmp    $0x2f,%al
  8020b3:	74 f6                	je     8020ab <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8020b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8020b9:	75 1b                	jne    8020d6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8020bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020be:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8020c1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8020c3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020c6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8020cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d1:	e9 64 01 00 00       	jmp    80223a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8020d6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8020da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020de:	74 06                	je     8020e6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8020e0:	84 c0                	test   %al,%al
  8020e2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8020e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020e9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8020ec:	83 3a 02             	cmpl   $0x2,(%edx)
  8020ef:	0f 85 f4 00 00 00    	jne    8021e9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8020f5:	89 d0                	mov    %edx,%eax
  8020f7:	8b 52 08             	mov    0x8(%edx),%edx
  8020fa:	85 d2                	test   %edx,%edx
  8020fc:	7e 78                	jle    802176 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  8020fe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802105:	bf 00 00 00 00       	mov    $0x0,%edi
  80210a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80210d:	89 fb                	mov    %edi,%ebx
  80210f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802112:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802114:	89 da                	mov    %ebx,%edx
  802116:	89 f0                	mov    %esi,%eax
  802118:	e8 93 f7 ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
  80211d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80211f:	83 38 00             	cmpl   $0x0,(%eax)
  802122:	74 26                	je     80214a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802124:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802127:	3b 50 04             	cmp    0x4(%eax),%edx
  80212a:	75 33                	jne    80215f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80212c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802130:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802133:	89 44 24 04          	mov    %eax,0x4(%esp)
  802137:	8d 47 08             	lea    0x8(%edi),%eax
  80213a:	89 04 24             	mov    %eax,(%esp)
  80213d:	e8 86 e9 ff ff       	call   800ac8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802142:	85 c0                	test   %eax,%eax
  802144:	0f 84 fa 00 00 00    	je     802244 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80214a:	83 3f 00             	cmpl   $0x0,(%edi)
  80214d:	75 10                	jne    80215f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80214f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802153:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802156:	84 c0                	test   %al,%al
  802158:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80215c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80215f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802165:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802167:	8b 56 08             	mov    0x8(%esi),%edx
  80216a:	39 d0                	cmp    %edx,%eax
  80216c:	7c a6                	jl     802114 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80216e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802171:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802174:	eb 07                	jmp    80217d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802176:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80217d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802181:	74 6d                	je     8021f0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802183:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802187:	75 24                	jne    8021ad <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802189:	83 ea 80             	sub    $0xffffff80,%edx
  80218c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80218f:	e8 0c f9 ff ff       	call   801aa0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802194:	85 c0                	test   %eax,%eax
  802196:	0f 88 90 00 00 00    	js     80222c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80219c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80219f:	8b 50 08             	mov    0x8(%eax),%edx
  8021a2:	83 c2 80             	add    $0xffffff80,%edx
  8021a5:	e8 06 f7 ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
  8021aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  8021ad:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8021b4:	00 
  8021b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021bc:	00 
  8021bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8021c0:	89 14 24             	mov    %edx,(%esp)
  8021c3:	e8 e9 e7 ff ff       	call   8009b1 <memset>
	empty->de_namelen = namelen;
  8021c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021ce:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8021d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021d9:	83 c0 08             	add    $0x8,%eax
  8021dc:	89 04 24             	mov    %eax,(%esp)
  8021df:	e8 a3 e8 ff ff       	call   800a87 <memcpy>
	*de_store = empty;
  8021e4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  8021e7:	eb 5e                	jmp    802247 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  8021e9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  8021ee:	eb 42                	jmp    802232 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  8021f0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  8021f5:	eb 3b                	jmp    802232 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  8021f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021fa:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8021fd:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  8021ff:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802202:	89 38                	mov    %edi,(%eax)
			return 0;
  802204:	bf 00 00 00 00       	mov    $0x0,%edi
  802209:	eb 2f                	jmp    80223a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80220b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80220e:	8b 07                	mov    (%edi),%eax
  802210:	e8 12 f8 ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  802215:	85 c0                	test   %eax,%eax
  802217:	78 17                	js     802230 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80221c:	e8 04 fa ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802224:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802227:	e9 41 fe ff ff       	jmp    80206d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80222c:	89 c7                	mov    %eax,%edi
  80222e:	eb 02                	jmp    802232 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802230:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802235:	e8 eb f9 ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
	return r;
}
  80223a:	89 f8                	mov    %edi,%eax
  80223c:	83 c4 4c             	add    $0x4c,%esp
  80223f:	5b                   	pop    %ebx
  802240:	5e                   	pop    %esi
  802241:	5f                   	pop    %edi
  802242:	5d                   	pop    %ebp
  802243:	c3                   	ret    
  802244:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802247:	80 3e 00             	cmpb   $0x0,(%esi)
  80224a:	75 bf                	jne    80220b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80224c:	eb a9                	jmp    8021f7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080224e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	57                   	push   %edi
  802252:	56                   	push   %esi
  802253:	53                   	push   %ebx
  802254:	83 ec 3c             	sub    $0x3c,%esp
  802257:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80225a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80225d:	89 04 24             	mov    %eax,(%esp)
  802260:	e8 62 f0 ff ff       	call   8012c7 <_Z14fd_find_unusedPP2Fd>
  802265:	89 c3                	mov    %eax,%ebx
  802267:	85 c0                	test   %eax,%eax
  802269:	0f 88 16 02 00 00    	js     802485 <_Z4openPKci+0x237>
  80226f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802276:	00 
  802277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80227a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802285:	e8 c6 ea ff ff       	call   800d50 <_Z14sys_page_allociPvi>
  80228a:	89 c3                	mov    %eax,%ebx
  80228c:	b8 00 00 00 00       	mov    $0x0,%eax
  802291:	85 db                	test   %ebx,%ebx
  802293:	0f 88 ec 01 00 00    	js     802485 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802299:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80229d:	0f 84 ec 01 00 00    	je     80248f <_Z4openPKci+0x241>
  8022a3:	83 c0 01             	add    $0x1,%eax
  8022a6:	83 f8 78             	cmp    $0x78,%eax
  8022a9:	75 ee                	jne    802299 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8022ab:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8022b0:	e9 b9 01 00 00       	jmp    80246e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8022b5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022b8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8022be:	89 3c 24             	mov    %edi,(%esp)
  8022c1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  8022c4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8022c7:	89 f0                	mov    %esi,%eax
  8022c9:	e8 68 fd ff ff       	call   802036 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8022ce:	89 c3                	mov    %eax,%ebx
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	0f 85 96 01 00 00    	jne    80246e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8022d8:	85 ff                	test   %edi,%edi
  8022da:	75 41                	jne    80231d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8022dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022df:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  8022e4:	75 08                	jne    8022ee <_Z4openPKci+0xa0>
            fileino = dirino;
  8022e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8022ec:	eb 14                	jmp    802302 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  8022ee:	8d 55 d8             	lea    -0x28(%ebp),%edx
  8022f1:	8b 00                	mov    (%eax),%eax
  8022f3:	e8 2f f7 ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  8022f8:	89 c3                	mov    %eax,%ebx
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	0f 88 5d 01 00 00    	js     80245f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802302:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802305:	83 38 02             	cmpl   $0x2,(%eax)
  802308:	0f 85 d2 00 00 00    	jne    8023e0 <_Z4openPKci+0x192>
  80230e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802312:	0f 84 c8 00 00 00    	je     8023e0 <_Z4openPKci+0x192>
  802318:	e9 38 01 00 00       	jmp    802455 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80231d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802324:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80232b:	0f 8e a8 00 00 00    	jle    8023d9 <_Z4openPKci+0x18b>
  802331:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802336:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802339:	89 f8                	mov    %edi,%eax
  80233b:	e8 e7 f6 ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  802340:	89 c3                	mov    %eax,%ebx
  802342:	85 c0                	test   %eax,%eax
  802344:	0f 88 15 01 00 00    	js     80245f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80234a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80234d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802351:	75 68                	jne    8023bb <_Z4openPKci+0x16d>
  802353:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80235a:	75 5f                	jne    8023bb <_Z4openPKci+0x16d>
			*ino_store = ino;
  80235c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80235f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802365:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802368:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80236f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802376:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80237d:	00 
  80237e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802385:	00 
  802386:	83 c0 0c             	add    $0xc,%eax
  802389:	89 04 24             	mov    %eax,(%esp)
  80238c:	e8 20 e6 ff ff       	call   8009b1 <memset>
        de->de_inum = fileino->i_inum;
  802391:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802394:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80239a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80239d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80239f:	ba 04 00 00 00       	mov    $0x4,%edx
  8023a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023a7:	e8 bf f5 ff ff       	call   80196b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  8023ac:	ba 04 00 00 00       	mov    $0x4,%edx
  8023b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b4:	e8 b2 f5 ff ff       	call   80196b <_ZL10bcache_ipcPvi>
  8023b9:	eb 25                	jmp    8023e0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  8023bb:	e8 65 f8 ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8023c0:	83 c7 01             	add    $0x1,%edi
  8023c3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  8023c9:	0f 8c 67 ff ff ff    	jl     802336 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  8023cf:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8023d4:	e9 86 00 00 00       	jmp    80245f <_Z4openPKci+0x211>
  8023d9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8023de:	eb 7f                	jmp    80245f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  8023e0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  8023e7:	74 0d                	je     8023f6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  8023e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023f1:	e8 aa f6 ff ff       	call   801aa0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  8023f6:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8023fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ff:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802404:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80240b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802411:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802414:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80241a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80241d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802421:	83 c0 10             	add    $0x10,%eax
  802424:	89 04 24             	mov    %eax,(%esp)
  802427:	e8 3e e4 ff ff       	call   80086a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80242c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80242f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802439:	e8 e7 f7 ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80243e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802441:	e8 df f7 ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802449:	89 04 24             	mov    %eax,(%esp)
  80244c:	e8 13 ee ff ff       	call   801264 <_Z6fd2numP2Fd>
  802451:	89 c3                	mov    %eax,%ebx
  802453:	eb 30                	jmp    802485 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802455:	e8 cb f7 ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80245a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80245f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802462:	e8 be f7 ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
  802467:	eb 05                	jmp    80246e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802469:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80246e:	a1 00 60 80 00       	mov    0x806000,%eax
  802473:	8b 40 04             	mov    0x4(%eax),%eax
  802476:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802479:	89 54 24 04          	mov    %edx,0x4(%esp)
  80247d:	89 04 24             	mov    %eax,(%esp)
  802480:	e8 88 e9 ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802485:	89 d8                	mov    %ebx,%eax
  802487:	83 c4 3c             	add    $0x3c,%esp
  80248a:	5b                   	pop    %ebx
  80248b:	5e                   	pop    %esi
  80248c:	5f                   	pop    %edi
  80248d:	5d                   	pop    %ebp
  80248e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80248f:	83 f8 78             	cmp    $0x78,%eax
  802492:	0f 85 1d fe ff ff    	jne    8022b5 <_Z4openPKci+0x67>
  802498:	eb cf                	jmp    802469 <_Z4openPKci+0x21b>

0080249a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	53                   	push   %ebx
  80249e:	83 ec 24             	sub    $0x24,%esp
  8024a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  8024a4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	e8 78 f5 ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	78 27                	js     8024da <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  8024b3:	c7 44 24 04 94 43 80 	movl   $0x804394,0x4(%esp)
  8024ba:	00 
  8024bb:	89 1c 24             	mov    %ebx,(%esp)
  8024be:	e8 a7 e3 ff ff       	call   80086a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8024c3:	89 da                	mov    %ebx,%edx
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	e8 26 f4 ff ff       	call   8018f3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	e8 50 f7 ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
	return 0;
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024da:	83 c4 24             	add    $0x24,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5d                   	pop    %ebp
  8024df:	c3                   	ret    

008024e0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	53                   	push   %ebx
  8024e4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  8024e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024ee:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  8024f1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	e8 3a fb ff ff       	call   802036 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8024fc:	89 c3                	mov    %eax,%ebx
  8024fe:	85 c0                	test   %eax,%eax
  802500:	78 5f                	js     802561 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802502:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802505:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	e8 18 f5 ff ff       	call   801a27 <_ZL10inode_openiPP5Inode>
  80250f:	89 c3                	mov    %eax,%ebx
  802511:	85 c0                	test   %eax,%eax
  802513:	78 44                	js     802559 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802515:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80251a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251d:	83 38 02             	cmpl   $0x2,(%eax)
  802520:	74 2f                	je     802551 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80252b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802532:	ba 04 00 00 00       	mov    $0x4,%edx
  802537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253a:	e8 2c f4 ff ff       	call   80196b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80253f:	ba 04 00 00 00       	mov    $0x4,%edx
  802544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802547:	e8 1f f4 ff ff       	call   80196b <_ZL10bcache_ipcPvi>
	r = 0;
  80254c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802554:	e8 cc f6 ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	e8 c4 f6 ff ff       	call   801c25 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802561:	89 d8                	mov    %ebx,%eax
  802563:	83 c4 24             	add    $0x24,%esp
  802566:	5b                   	pop    %ebx
  802567:	5d                   	pop    %ebp
  802568:	c3                   	ret    

00802569 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	5d                   	pop    %ebp
  802572:	c3                   	ret    

00802573 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	57                   	push   %edi
  802577:	56                   	push   %esi
  802578:	53                   	push   %ebx
  802579:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  80257f:	c7 04 24 cd 1c 80 00 	movl   $0x801ccd,(%esp)
  802586:	e8 30 15 00 00       	call   803abb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  80258b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802590:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802595:	74 28                	je     8025bf <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802597:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  80259e:	4a 
  80259f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025a3:	c7 44 24 08 fc 43 80 	movl   $0x8043fc,0x8(%esp)
  8025aa:	00 
  8025ab:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  8025b2:	00 
  8025b3:	c7 04 24 76 43 80 00 	movl   $0x804376,(%esp)
  8025ba:	e8 2d 14 00 00       	call   8039ec <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  8025bf:	a1 04 10 00 50       	mov    0x50001004,%eax
  8025c4:	83 f8 03             	cmp    $0x3,%eax
  8025c7:	7f 1c                	jg     8025e5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  8025c9:	c7 44 24 08 30 44 80 	movl   $0x804430,0x8(%esp)
  8025d0:	00 
  8025d1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  8025d8:	00 
  8025d9:	c7 04 24 76 43 80 00 	movl   $0x804376,(%esp)
  8025e0:	e8 07 14 00 00       	call   8039ec <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  8025e5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  8025eb:	85 d2                	test   %edx,%edx
  8025ed:	7f 1c                	jg     80260b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  8025ef:	c7 44 24 08 60 44 80 	movl   $0x804460,0x8(%esp)
  8025f6:	00 
  8025f7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  8025fe:	00 
  8025ff:	c7 04 24 76 43 80 00 	movl   $0x804376,(%esp)
  802606:	e8 e1 13 00 00       	call   8039ec <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80260b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802611:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802617:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80261d:	85 c9                	test   %ecx,%ecx
  80261f:	0f 48 cb             	cmovs  %ebx,%ecx
  802622:	c1 f9 0c             	sar    $0xc,%ecx
  802625:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802629:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80262f:	39 c8                	cmp    %ecx,%eax
  802631:	7c 13                	jl     802646 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802633:	85 c0                	test   %eax,%eax
  802635:	7f 3d                	jg     802674 <_Z4fsckv+0x101>
  802637:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80263e:	00 00 00 
  802641:	e9 ac 00 00 00       	jmp    8026f2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802646:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80264c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802650:	89 44 24 10          	mov    %eax,0x10(%esp)
  802654:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802658:	c7 44 24 08 90 44 80 	movl   $0x804490,0x8(%esp)
  80265f:	00 
  802660:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802667:	00 
  802668:	c7 04 24 76 43 80 00 	movl   $0x804376,(%esp)
  80266f:	e8 78 13 00 00       	call   8039ec <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802674:	be 00 20 00 50       	mov    $0x50002000,%esi
  802679:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802680:	00 00 00 
  802683:	bb 00 00 00 00       	mov    $0x0,%ebx
  802688:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  80268e:	39 df                	cmp    %ebx,%edi
  802690:	7e 27                	jle    8026b9 <_Z4fsckv+0x146>
  802692:	0f b6 06             	movzbl (%esi),%eax
  802695:	84 c0                	test   %al,%al
  802697:	74 4b                	je     8026e4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802699:	0f be c0             	movsbl %al,%eax
  80269c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026a4:	c7 04 24 d4 44 80 00 	movl   $0x8044d4,(%esp)
  8026ab:	e8 9e db ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  8026b0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8026b7:	eb 2b                	jmp    8026e4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  8026b9:	0f b6 06             	movzbl (%esi),%eax
  8026bc:	3c 01                	cmp    $0x1,%al
  8026be:	76 24                	jbe    8026e4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  8026c0:	0f be c0             	movsbl %al,%eax
  8026c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026cb:	c7 04 24 08 45 80 00 	movl   $0x804508,(%esp)
  8026d2:	e8 77 db ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  8026d7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  8026de:	80 3e 00             	cmpb   $0x0,(%esi)
  8026e1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8026e4:	83 c3 01             	add    $0x1,%ebx
  8026e7:	83 c6 01             	add    $0x1,%esi
  8026ea:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8026f0:	7f 9c                	jg     80268e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8026f2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8026f9:	0f 8e e1 02 00 00    	jle    8029e0 <_Z4fsckv+0x46d>
  8026ff:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802706:	00 00 00 
		struct Inode *ino = get_inode(i);
  802709:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80270f:	e8 f9 f1 ff ff       	call   80190d <_ZL9get_inodei>
  802714:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80271a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80271e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802725:	75 22                	jne    802749 <_Z4fsckv+0x1d6>
  802727:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80272e:	0f 84 a9 06 00 00    	je     802ddd <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802734:	ba 00 00 00 00       	mov    $0x0,%edx
  802739:	e8 2d f2 ff ff       	call   80196b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 3a                	je     80277c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802742:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802749:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80274f:	8b 02                	mov    (%edx),%eax
  802751:	83 f8 01             	cmp    $0x1,%eax
  802754:	74 26                	je     80277c <_Z4fsckv+0x209>
  802756:	83 f8 02             	cmp    $0x2,%eax
  802759:	74 21                	je     80277c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80275b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80275f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802765:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802769:	c7 04 24 34 45 80 00 	movl   $0x804534,(%esp)
  802770:	e8 d9 da ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  802775:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80277c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802783:	75 3f                	jne    8027c4 <_Z4fsckv+0x251>
  802785:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80278b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80278f:	75 15                	jne    8027a6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802791:	c7 04 24 58 45 80 00 	movl   $0x804558,(%esp)
  802798:	e8 b1 da ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  80279d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8027a4:	eb 1e                	jmp    8027c4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  8027a6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8027ac:	83 3a 02             	cmpl   $0x2,(%edx)
  8027af:	74 13                	je     8027c4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8027b1:	c7 04 24 8c 45 80 00 	movl   $0x80458c,(%esp)
  8027b8:	e8 91 da ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  8027bd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  8027c4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  8027c9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8027d0:	0f 84 93 00 00 00    	je     802869 <_Z4fsckv+0x2f6>
  8027d6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8027dc:	8b 41 08             	mov    0x8(%ecx),%eax
  8027df:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  8027e4:	7e 23                	jle    802809 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  8027e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027ea:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8027f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f4:	c7 04 24 bc 45 80 00 	movl   $0x8045bc,(%esp)
  8027fb:	e8 4e da ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  802800:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802807:	eb 09                	jmp    802812 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802809:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802810:	74 4b                	je     80285d <_Z4fsckv+0x2ea>
  802812:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802818:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80281e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802824:	74 23                	je     802849 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802826:	89 44 24 08          	mov    %eax,0x8(%esp)
  80282a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802830:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802834:	c7 04 24 e0 45 80 00 	movl   $0x8045e0,(%esp)
  80283b:	e8 0e da ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  802840:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802847:	eb 09                	jmp    802852 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802849:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802850:	74 12                	je     802864 <_Z4fsckv+0x2f1>
  802852:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802858:	8b 78 08             	mov    0x8(%eax),%edi
  80285b:	eb 0c                	jmp    802869 <_Z4fsckv+0x2f6>
  80285d:	bf 00 00 00 00       	mov    $0x0,%edi
  802862:	eb 05                	jmp    802869 <_Z4fsckv+0x2f6>
  802864:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802869:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  80286e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802874:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802878:	89 d8                	mov    %ebx,%eax
  80287a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  80287d:	39 c7                	cmp    %eax,%edi
  80287f:	7e 2b                	jle    8028ac <_Z4fsckv+0x339>
  802881:	85 f6                	test   %esi,%esi
  802883:	75 27                	jne    8028ac <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802885:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802889:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80288d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802893:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802897:	c7 04 24 04 46 80 00 	movl   $0x804604,(%esp)
  80289e:	e8 ab d9 ff ff       	call   80024e <_Z7cprintfPKcz>
				++errors;
  8028a3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8028aa:	eb 36                	jmp    8028e2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  8028ac:	39 f8                	cmp    %edi,%eax
  8028ae:	7c 32                	jl     8028e2 <_Z4fsckv+0x36f>
  8028b0:	85 f6                	test   %esi,%esi
  8028b2:	74 2e                	je     8028e2 <_Z4fsckv+0x36f>
  8028b4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8028bb:	74 25                	je     8028e2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8028bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028c1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028c5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8028cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cf:	c7 04 24 48 46 80 00 	movl   $0x804648,(%esp)
  8028d6:	e8 73 d9 ff ff       	call   80024e <_Z7cprintfPKcz>
				++errors;
  8028db:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  8028e2:	85 f6                	test   %esi,%esi
  8028e4:	0f 84 a0 00 00 00    	je     80298a <_Z4fsckv+0x417>
  8028ea:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8028f1:	0f 84 93 00 00 00    	je     80298a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  8028f7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8028fd:	7e 27                	jle    802926 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  8028ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802903:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802907:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  80290d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802911:	c7 04 24 8c 46 80 00 	movl   $0x80468c,(%esp)
  802918:	e8 31 d9 ff ff       	call   80024e <_Z7cprintfPKcz>
					++errors;
  80291d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802924:	eb 64                	jmp    80298a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802926:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80292d:	3c 01                	cmp    $0x1,%al
  80292f:	75 27                	jne    802958 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802931:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802935:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802939:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  80293f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802943:	c7 04 24 d0 46 80 00 	movl   $0x8046d0,(%esp)
  80294a:	e8 ff d8 ff ff       	call   80024e <_Z7cprintfPKcz>
					++errors;
  80294f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802956:	eb 32                	jmp    80298a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802958:	3c ff                	cmp    $0xff,%al
  80295a:	75 27                	jne    802983 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  80295c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802960:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802964:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80296a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80296e:	c7 04 24 0c 47 80 00 	movl   $0x80470c,(%esp)
  802975:	e8 d4 d8 ff ff       	call   80024e <_Z7cprintfPKcz>
					++errors;
  80297a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802981:	eb 07                	jmp    80298a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802983:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  80298a:	83 c3 01             	add    $0x1,%ebx
  80298d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802993:	0f 85 d5 fe ff ff    	jne    80286e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802999:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8029a0:	0f 94 c0             	sete   %al
  8029a3:	0f b6 c0             	movzbl %al,%eax
  8029a6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8029ac:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  8029b2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  8029b9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  8029c0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8029c7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  8029ce:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8029d4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  8029da:	0f 8f 29 fd ff ff    	jg     802709 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8029e0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8029e7:	0f 8e 7f 03 00 00    	jle    802d6c <_Z4fsckv+0x7f9>
  8029ed:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  8029f2:	89 f0                	mov    %esi,%eax
  8029f4:	e8 14 ef ff ff       	call   80190d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  8029f9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802a00:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802a07:	c1 e2 08             	shl    $0x8,%edx
  802a0a:	09 ca                	or     %ecx,%edx
  802a0c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802a13:	c1 e1 10             	shl    $0x10,%ecx
  802a16:	09 ca                	or     %ecx,%edx
  802a18:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802a1f:	83 e1 7f             	and    $0x7f,%ecx
  802a22:	c1 e1 18             	shl    $0x18,%ecx
  802a25:	09 d1                	or     %edx,%ecx
  802a27:	74 0e                	je     802a37 <_Z4fsckv+0x4c4>
  802a29:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802a30:	78 05                	js     802a37 <_Z4fsckv+0x4c4>
  802a32:	83 38 02             	cmpl   $0x2,(%eax)
  802a35:	74 1f                	je     802a56 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802a37:	83 c6 01             	add    $0x1,%esi
  802a3a:	a1 08 10 00 50       	mov    0x50001008,%eax
  802a3f:	39 f0                	cmp    %esi,%eax
  802a41:	7f af                	jg     8029f2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802a43:	bb 01 00 00 00       	mov    $0x1,%ebx
  802a48:	83 f8 01             	cmp    $0x1,%eax
  802a4b:	0f 8f ad 02 00 00    	jg     802cfe <_Z4fsckv+0x78b>
  802a51:	e9 16 03 00 00       	jmp    802d6c <_Z4fsckv+0x7f9>
  802a56:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802a58:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802a5f:	8b 40 08             	mov    0x8(%eax),%eax
  802a62:	a8 7f                	test   $0x7f,%al
  802a64:	74 23                	je     802a89 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802a66:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802a6d:	00 
  802a6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a72:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a76:	c7 04 24 48 47 80 00 	movl   $0x804748,(%esp)
  802a7d:	e8 cc d7 ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  802a82:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802a89:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802a90:	00 00 00 
  802a93:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802a99:	e9 3d 02 00 00       	jmp    802cdb <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802a9e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802aa4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802aaa:	e8 01 ee ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
  802aaf:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802ab1:	83 38 00             	cmpl   $0x0,(%eax)
  802ab4:	0f 84 15 02 00 00    	je     802ccf <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802aba:	8b 40 04             	mov    0x4(%eax),%eax
  802abd:	8d 50 ff             	lea    -0x1(%eax),%edx
  802ac0:	83 fa 76             	cmp    $0x76,%edx
  802ac3:	76 27                	jbe    802aec <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802ac5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ac9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802acf:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ad3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ad7:	c7 04 24 7c 47 80 00 	movl   $0x80477c,(%esp)
  802ade:	e8 6b d7 ff ff       	call   80024e <_Z7cprintfPKcz>
				++errors;
  802ae3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802aea:	eb 28                	jmp    802b14 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802aec:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802af1:	74 21                	je     802b14 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802af3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802af9:	89 54 24 08          	mov    %edx,0x8(%esp)
  802afd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b01:	c7 04 24 a8 47 80 00 	movl   $0x8047a8,(%esp)
  802b08:	e8 41 d7 ff ff       	call   80024e <_Z7cprintfPKcz>
				++errors;
  802b0d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802b14:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802b1b:	00 
  802b1c:	8d 43 08             	lea    0x8(%ebx),%eax
  802b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b23:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802b29:	89 0c 24             	mov    %ecx,(%esp)
  802b2c:	e8 56 df ff ff       	call   800a87 <memcpy>
  802b31:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802b35:	bf 77 00 00 00       	mov    $0x77,%edi
  802b3a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802b3e:	85 ff                	test   %edi,%edi
  802b40:	b8 00 00 00 00       	mov    $0x0,%eax
  802b45:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802b48:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802b4f:	00 

			if (de->de_inum >= super->s_ninodes) {
  802b50:	8b 03                	mov    (%ebx),%eax
  802b52:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802b58:	7c 3e                	jl     802b98 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802b5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b5e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802b64:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b68:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b6e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b72:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b76:	c7 04 24 dc 47 80 00 	movl   $0x8047dc,(%esp)
  802b7d:	e8 cc d6 ff ff       	call   80024e <_Z7cprintfPKcz>
				++errors;
  802b82:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b89:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802b90:	00 00 00 
  802b93:	e9 0b 01 00 00       	jmp    802ca3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802b98:	e8 70 ed ff ff       	call   80190d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802b9d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802ba4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802bab:	c1 e2 08             	shl    $0x8,%edx
  802bae:	09 d1                	or     %edx,%ecx
  802bb0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802bb7:	c1 e2 10             	shl    $0x10,%edx
  802bba:	09 d1                	or     %edx,%ecx
  802bbc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802bc3:	83 e2 7f             	and    $0x7f,%edx
  802bc6:	c1 e2 18             	shl    $0x18,%edx
  802bc9:	09 ca                	or     %ecx,%edx
  802bcb:	83 c2 01             	add    $0x1,%edx
  802bce:	89 d1                	mov    %edx,%ecx
  802bd0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802bd6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802bdc:	0f b6 d5             	movzbl %ch,%edx
  802bdf:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802be5:	89 ca                	mov    %ecx,%edx
  802be7:	c1 ea 10             	shr    $0x10,%edx
  802bea:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802bf0:	c1 e9 18             	shr    $0x18,%ecx
  802bf3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802bfa:	83 e2 80             	and    $0xffffff80,%edx
  802bfd:	09 ca                	or     %ecx,%edx
  802bff:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802c05:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802c09:	0f 85 7a ff ff ff    	jne    802b89 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802c0f:	8b 03                	mov    (%ebx),%eax
  802c11:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c15:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802c1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802c1f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802c25:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c29:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c2d:	c7 04 24 0c 48 80 00 	movl   $0x80480c,(%esp)
  802c34:	e8 15 d6 ff ff       	call   80024e <_Z7cprintfPKcz>
					++errors;
  802c39:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c40:	e9 44 ff ff ff       	jmp    802b89 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802c45:	3b 78 04             	cmp    0x4(%eax),%edi
  802c48:	75 52                	jne    802c9c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802c4a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c4e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802c54:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c58:	83 c0 08             	add    $0x8,%eax
  802c5b:	89 04 24             	mov    %eax,(%esp)
  802c5e:	e8 65 de ff ff       	call   800ac8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802c63:	85 c0                	test   %eax,%eax
  802c65:	75 35                	jne    802c9c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802c67:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802c6d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c71:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802c77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c7b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c81:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c85:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c89:	c7 04 24 3c 48 80 00 	movl   $0x80483c,(%esp)
  802c90:	e8 b9 d5 ff ff       	call   80024e <_Z7cprintfPKcz>
					++errors;
  802c95:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802c9c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802ca3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802ca9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802caf:	7e 1e                	jle    802ccf <_Z4fsckv+0x75c>
  802cb1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802cb5:	7f 18                	jg     802ccf <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802cb7:	89 ca                	mov    %ecx,%edx
  802cb9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802cbf:	e8 ec eb ff ff       	call   8018b0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802cc4:	83 38 00             	cmpl   $0x0,(%eax)
  802cc7:	0f 85 78 ff ff ff    	jne    802c45 <_Z4fsckv+0x6d2>
  802ccd:	eb cd                	jmp    802c9c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802ccf:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802cd5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802cdb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802ce1:	83 ea 80             	sub    $0xffffff80,%edx
  802ce4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802cea:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802cf0:	3b 51 08             	cmp    0x8(%ecx),%edx
  802cf3:	0f 8f e7 fc ff ff    	jg     8029e0 <_Z4fsckv+0x46d>
  802cf9:	e9 a0 fd ff ff       	jmp    802a9e <_Z4fsckv+0x52b>
  802cfe:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802d04:	89 d8                	mov    %ebx,%eax
  802d06:	e8 02 ec ff ff       	call   80190d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802d0b:	8b 50 04             	mov    0x4(%eax),%edx
  802d0e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802d15:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  802d1c:	c1 e7 08             	shl    $0x8,%edi
  802d1f:	09 f9                	or     %edi,%ecx
  802d21:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  802d28:	c1 e7 10             	shl    $0x10,%edi
  802d2b:	09 f9                	or     %edi,%ecx
  802d2d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  802d34:	83 e7 7f             	and    $0x7f,%edi
  802d37:	c1 e7 18             	shl    $0x18,%edi
  802d3a:	09 f9                	or     %edi,%ecx
  802d3c:	39 ca                	cmp    %ecx,%edx
  802d3e:	74 1b                	je     802d5b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  802d40:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802d44:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d48:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d4c:	c7 04 24 6c 48 80 00 	movl   $0x80486c,(%esp)
  802d53:	e8 f6 d4 ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  802d58:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802d5b:	83 c3 01             	add    $0x1,%ebx
  802d5e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802d64:	7f 9e                	jg     802d04 <_Z4fsckv+0x791>
  802d66:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802d6c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802d73:	7e 4f                	jle    802dc4 <_Z4fsckv+0x851>
  802d75:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d7a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  802d80:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  802d87:	3c ff                	cmp    $0xff,%al
  802d89:	75 09                	jne    802d94 <_Z4fsckv+0x821>
			freemap[i] = 0;
  802d8b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  802d92:	eb 1f                	jmp    802db3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  802d94:	84 c0                	test   %al,%al
  802d96:	75 1b                	jne    802db3 <_Z4fsckv+0x840>
  802d98:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  802d9e:	7c 13                	jl     802db3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  802da0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802da4:	c7 04 24 98 48 80 00 	movl   $0x804898,(%esp)
  802dab:	e8 9e d4 ff ff       	call   80024e <_Z7cprintfPKcz>
			++errors;
  802db0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802db3:	83 c3 01             	add    $0x1,%ebx
  802db6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802dbc:	7f c2                	jg     802d80 <_Z4fsckv+0x80d>
  802dbe:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  802dc4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  802dcb:	19 c0                	sbb    %eax,%eax
  802dcd:	f7 d0                	not    %eax
  802dcf:	83 e0 fd             	and    $0xfffffffd,%eax
}
  802dd2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  802dd8:	5b                   	pop    %ebx
  802dd9:	5e                   	pop    %esi
  802dda:	5f                   	pop    %edi
  802ddb:	5d                   	pop    %ebp
  802ddc:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802ddd:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802de4:	0f 84 92 f9 ff ff    	je     80277c <_Z4fsckv+0x209>
  802dea:	e9 5a f9 ff ff       	jmp    802749 <_Z4fsckv+0x1d6>
	...

00802df0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	83 ec 18             	sub    $0x18,%esp
  802df6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802df9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	89 04 24             	mov    %eax,(%esp)
  802e05:	e8 a2 e4 ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  802e0a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802e0c:	c7 44 24 04 cb 48 80 	movl   $0x8048cb,0x4(%esp)
  802e13:	00 
  802e14:	89 34 24             	mov    %esi,(%esp)
  802e17:	e8 4e da ff ff       	call   80086a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  802e1c:	8b 43 04             	mov    0x4(%ebx),%eax
  802e1f:	2b 03                	sub    (%ebx),%eax
  802e21:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  802e24:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  802e2b:	c7 86 80 00 00 00 20 	movl   $0x805020,0x80(%esi)
  802e32:	50 80 00 
	return 0;
}
  802e35:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802e3d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802e40:	89 ec                	mov    %ebp,%esp
  802e42:	5d                   	pop    %ebp
  802e43:	c3                   	ret    

00802e44 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  802e44:	55                   	push   %ebp
  802e45:	89 e5                	mov    %esp,%ebp
  802e47:	53                   	push   %ebx
  802e48:	83 ec 14             	sub    $0x14,%esp
  802e4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802e4e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e59:	e8 af df ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  802e5e:	89 1c 24             	mov    %ebx,(%esp)
  802e61:	e8 46 e4 ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  802e66:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e71:	e8 97 df ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
}
  802e76:	83 c4 14             	add    $0x14,%esp
  802e79:	5b                   	pop    %ebx
  802e7a:	5d                   	pop    %ebp
  802e7b:	c3                   	ret    

00802e7c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802e7c:	55                   	push   %ebp
  802e7d:	89 e5                	mov    %esp,%ebp
  802e7f:	57                   	push   %edi
  802e80:	56                   	push   %esi
  802e81:	53                   	push   %ebx
  802e82:	83 ec 2c             	sub    $0x2c,%esp
  802e85:	89 c7                	mov    %eax,%edi
  802e87:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  802e8a:	a1 00 60 80 00       	mov    0x806000,%eax
  802e8f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  802e92:	89 3c 24             	mov    %edi,(%esp)
  802e95:	e8 82 04 00 00       	call   80331c <_Z7pagerefPv>
  802e9a:	89 c3                	mov    %eax,%ebx
  802e9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9f:	89 04 24             	mov    %eax,(%esp)
  802ea2:	e8 75 04 00 00       	call   80331c <_Z7pagerefPv>
  802ea7:	39 c3                	cmp    %eax,%ebx
  802ea9:	0f 94 c0             	sete   %al
  802eac:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  802eaf:	8b 15 00 60 80 00    	mov    0x806000,%edx
  802eb5:	8b 52 58             	mov    0x58(%edx),%edx
  802eb8:	39 d6                	cmp    %edx,%esi
  802eba:	75 08                	jne    802ec4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  802ebc:	83 c4 2c             	add    $0x2c,%esp
  802ebf:	5b                   	pop    %ebx
  802ec0:	5e                   	pop    %esi
  802ec1:	5f                   	pop    %edi
  802ec2:	5d                   	pop    %ebp
  802ec3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 c2                	je     802e8a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  802ec8:	c7 04 24 d2 48 80 00 	movl   $0x8048d2,(%esp)
  802ecf:	e8 7a d3 ff ff       	call   80024e <_Z7cprintfPKcz>
  802ed4:	eb b4                	jmp    802e8a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00802ed6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802ed6:	55                   	push   %ebp
  802ed7:	89 e5                	mov    %esp,%ebp
  802ed9:	57                   	push   %edi
  802eda:	56                   	push   %esi
  802edb:	53                   	push   %ebx
  802edc:	83 ec 1c             	sub    $0x1c,%esp
  802edf:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802ee2:	89 34 24             	mov    %esi,(%esp)
  802ee5:	e8 c2 e3 ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  802eea:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802eec:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ef5:	75 46                	jne    802f3d <_ZL13devpipe_writeP2FdPKvj+0x67>
  802ef7:	eb 52                	jmp    802f4b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  802ef9:	89 da                	mov    %ebx,%edx
  802efb:	89 f0                	mov    %esi,%eax
  802efd:	e8 7a ff ff ff       	call   802e7c <_ZL13_pipeisclosedP2FdP4Pipe>
  802f02:	85 c0                	test   %eax,%eax
  802f04:	75 49                	jne    802f4f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  802f06:	e8 11 de ff ff       	call   800d1c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  802f0b:	8b 43 04             	mov    0x4(%ebx),%eax
  802f0e:	89 c2                	mov    %eax,%edx
  802f10:	2b 13                	sub    (%ebx),%edx
  802f12:	83 fa 20             	cmp    $0x20,%edx
  802f15:	74 e2                	je     802ef9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f17:	89 c2                	mov    %eax,%edx
  802f19:	c1 fa 1f             	sar    $0x1f,%edx
  802f1c:	c1 ea 1b             	shr    $0x1b,%edx
  802f1f:	01 d0                	add    %edx,%eax
  802f21:	83 e0 1f             	and    $0x1f,%eax
  802f24:	29 d0                	sub    %edx,%eax
  802f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f29:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  802f2d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  802f31:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802f35:	83 c7 01             	add    $0x1,%edi
  802f38:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802f3b:	76 0e                	jbe    802f4b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  802f3d:	8b 43 04             	mov    0x4(%ebx),%eax
  802f40:	89 c2                	mov    %eax,%edx
  802f42:	2b 13                	sub    (%ebx),%edx
  802f44:	83 fa 20             	cmp    $0x20,%edx
  802f47:	74 b0                	je     802ef9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  802f49:	eb cc                	jmp    802f17 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  802f4b:	89 f8                	mov    %edi,%eax
  802f4d:	eb 05                	jmp    802f54 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  802f4f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  802f54:	83 c4 1c             	add    $0x1c,%esp
  802f57:	5b                   	pop    %ebx
  802f58:	5e                   	pop    %esi
  802f59:	5f                   	pop    %edi
  802f5a:	5d                   	pop    %ebp
  802f5b:	c3                   	ret    

00802f5c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f5c:	55                   	push   %ebp
  802f5d:	89 e5                	mov    %esp,%ebp
  802f5f:	83 ec 28             	sub    $0x28,%esp
  802f62:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802f65:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802f68:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802f6b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802f6e:	89 3c 24             	mov    %edi,(%esp)
  802f71:	e8 36 e3 ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  802f76:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802f78:	be 00 00 00 00       	mov    $0x0,%esi
  802f7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802f81:	75 47                	jne    802fca <_ZL12devpipe_readP2FdPvj+0x6e>
  802f83:	eb 52                	jmp    802fd7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  802f85:	89 f0                	mov    %esi,%eax
  802f87:	eb 5e                	jmp    802fe7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  802f89:	89 da                	mov    %ebx,%edx
  802f8b:	89 f8                	mov    %edi,%eax
  802f8d:	8d 76 00             	lea    0x0(%esi),%esi
  802f90:	e8 e7 fe ff ff       	call   802e7c <_ZL13_pipeisclosedP2FdP4Pipe>
  802f95:	85 c0                	test   %eax,%eax
  802f97:	75 49                	jne    802fe2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  802f99:	e8 7e dd ff ff       	call   800d1c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802f9e:	8b 03                	mov    (%ebx),%eax
  802fa0:	3b 43 04             	cmp    0x4(%ebx),%eax
  802fa3:	74 e4                	je     802f89 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fa5:	89 c2                	mov    %eax,%edx
  802fa7:	c1 fa 1f             	sar    $0x1f,%edx
  802faa:	c1 ea 1b             	shr    $0x1b,%edx
  802fad:	01 d0                	add    %edx,%eax
  802faf:	83 e0 1f             	and    $0x1f,%eax
  802fb2:	29 d0                	sub    %edx,%eax
  802fb4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  802fbf:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802fc2:	83 c6 01             	add    $0x1,%esi
  802fc5:	39 75 10             	cmp    %esi,0x10(%ebp)
  802fc8:	76 0d                	jbe    802fd7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  802fca:	8b 03                	mov    (%ebx),%eax
  802fcc:	3b 43 04             	cmp    0x4(%ebx),%eax
  802fcf:	75 d4                	jne    802fa5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  802fd1:	85 f6                	test   %esi,%esi
  802fd3:	75 b0                	jne    802f85 <_ZL12devpipe_readP2FdPvj+0x29>
  802fd5:	eb b2                	jmp    802f89 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  802fd7:	89 f0                	mov    %esi,%eax
  802fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802fe0:	eb 05                	jmp    802fe7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  802fe2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  802fe7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802fea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802fed:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802ff0:	89 ec                	mov    %ebp,%esp
  802ff2:	5d                   	pop    %ebp
  802ff3:	c3                   	ret    

00802ff4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
  802ff7:	83 ec 48             	sub    $0x48,%esp
  802ffa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802ffd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803000:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803003:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803006:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803009:	89 04 24             	mov    %eax,(%esp)
  80300c:	e8 b6 e2 ff ff       	call   8012c7 <_Z14fd_find_unusedPP2Fd>
  803011:	89 c3                	mov    %eax,%ebx
  803013:	85 c0                	test   %eax,%eax
  803015:	0f 88 0b 01 00 00    	js     803126 <_Z4pipePi+0x132>
  80301b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803022:	00 
  803023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803026:	89 44 24 04          	mov    %eax,0x4(%esp)
  80302a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803031:	e8 1a dd ff ff       	call   800d50 <_Z14sys_page_allociPvi>
  803036:	89 c3                	mov    %eax,%ebx
  803038:	85 c0                	test   %eax,%eax
  80303a:	0f 89 f5 00 00 00    	jns    803135 <_Z4pipePi+0x141>
  803040:	e9 e1 00 00 00       	jmp    803126 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803045:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80304c:	00 
  80304d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803050:	89 44 24 04          	mov    %eax,0x4(%esp)
  803054:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80305b:	e8 f0 dc ff ff       	call   800d50 <_Z14sys_page_allociPvi>
  803060:	89 c3                	mov    %eax,%ebx
  803062:	85 c0                	test   %eax,%eax
  803064:	0f 89 e2 00 00 00    	jns    80314c <_Z4pipePi+0x158>
  80306a:	e9 a4 00 00 00       	jmp    803113 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80306f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803072:	89 04 24             	mov    %eax,(%esp)
  803075:	e8 32 e2 ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  80307a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803081:	00 
  803082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803086:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80308d:	00 
  80308e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803099:	e8 11 dd ff ff       	call   800daf <_Z12sys_page_mapiPviS_i>
  80309e:	89 c3                	mov    %eax,%ebx
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	78 4c                	js     8030f0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8030a4:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8030aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8030af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8030b9:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8030bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8030c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8030ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d1:	89 04 24             	mov    %eax,(%esp)
  8030d4:	e8 8b e1 ff ff       	call   801264 <_Z6fd2numP2Fd>
  8030d9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8030db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030de:	89 04 24             	mov    %eax,(%esp)
  8030e1:	e8 7e e1 ff ff       	call   801264 <_Z6fd2numP2Fd>
  8030e6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8030e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8030ee:	eb 36                	jmp    803126 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  8030f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030fb:	e8 0d dd ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803103:	89 44 24 04          	mov    %eax,0x4(%esp)
  803107:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80310e:	e8 fa dc ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803116:	89 44 24 04          	mov    %eax,0x4(%esp)
  80311a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803121:	e8 e7 dc ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803126:	89 d8                	mov    %ebx,%eax
  803128:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80312b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80312e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803131:	89 ec                	mov    %ebp,%esp
  803133:	5d                   	pop    %ebp
  803134:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803135:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803138:	89 04 24             	mov    %eax,(%esp)
  80313b:	e8 87 e1 ff ff       	call   8012c7 <_Z14fd_find_unusedPP2Fd>
  803140:	89 c3                	mov    %eax,%ebx
  803142:	85 c0                	test   %eax,%eax
  803144:	0f 89 fb fe ff ff    	jns    803045 <_Z4pipePi+0x51>
  80314a:	eb c7                	jmp    803113 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80314c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314f:	89 04 24             	mov    %eax,(%esp)
  803152:	e8 55 e1 ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  803157:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803159:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803160:	00 
  803161:	89 44 24 04          	mov    %eax,0x4(%esp)
  803165:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80316c:	e8 df db ff ff       	call   800d50 <_Z14sys_page_allociPvi>
  803171:	89 c3                	mov    %eax,%ebx
  803173:	85 c0                	test   %eax,%eax
  803175:	0f 89 f4 fe ff ff    	jns    80306f <_Z4pipePi+0x7b>
  80317b:	eb 83                	jmp    803100 <_Z4pipePi+0x10c>

0080317d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80317d:	55                   	push   %ebp
  80317e:	89 e5                	mov    %esp,%ebp
  803180:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803183:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80318a:	00 
  80318b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80318e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	89 04 24             	mov    %eax,(%esp)
  803198:	e8 74 e0 ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  80319d:	85 c0                	test   %eax,%eax
  80319f:	78 15                	js     8031b6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	89 04 24             	mov    %eax,(%esp)
  8031a7:	e8 00 e1 ff ff       	call   8012ac <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  8031ac:	89 c2                	mov    %eax,%edx
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	e8 c6 fc ff ff       	call   802e7c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8031b6:	c9                   	leave  
  8031b7:	c3                   	ret    

008031b8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8031b8:	55                   	push   %ebp
  8031b9:	89 e5                	mov    %esp,%ebp
  8031bb:	53                   	push   %ebx
  8031bc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8031bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031c2:	89 04 24             	mov    %eax,(%esp)
  8031c5:	e8 fd e0 ff ff       	call   8012c7 <_Z14fd_find_unusedPP2Fd>
  8031ca:	89 c3                	mov    %eax,%ebx
  8031cc:	85 c0                	test   %eax,%eax
  8031ce:	0f 88 be 00 00 00    	js     803292 <_Z18pipe_ipc_recv_readv+0xda>
  8031d4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031db:	00 
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031ea:	e8 61 db ff ff       	call   800d50 <_Z14sys_page_allociPvi>
  8031ef:	89 c3                	mov    %eax,%ebx
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	0f 89 a1 00 00 00    	jns    80329a <_Z18pipe_ipc_recv_readv+0xe2>
  8031f9:	e9 94 00 00 00       	jmp    803292 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  8031fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	75 0e                	jne    803213 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803205:	c7 04 24 30 49 80 00 	movl   $0x804930,(%esp)
  80320c:	e8 3d d0 ff ff       	call   80024e <_Z7cprintfPKcz>
  803211:	eb 10                	jmp    803223 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803213:	89 44 24 04          	mov    %eax,0x4(%esp)
  803217:	c7 04 24 e5 48 80 00 	movl   $0x8048e5,(%esp)
  80321e:	e8 2b d0 ff ff       	call   80024e <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803223:	c7 04 24 ef 48 80 00 	movl   $0x8048ef,(%esp)
  80322a:	e8 1f d0 ff ff       	call   80024e <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80322f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803232:	a8 04                	test   $0x4,%al
  803234:	74 04                	je     80323a <_Z18pipe_ipc_recv_readv+0x82>
  803236:	a8 01                	test   $0x1,%al
  803238:	75 24                	jne    80325e <_Z18pipe_ipc_recv_readv+0xa6>
  80323a:	c7 44 24 0c 02 49 80 	movl   $0x804902,0xc(%esp)
  803241:	00 
  803242:	c7 44 24 08 cc 42 80 	movl   $0x8042cc,0x8(%esp)
  803249:	00 
  80324a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803251:	00 
  803252:	c7 04 24 1f 49 80 00 	movl   $0x80491f,(%esp)
  803259:	e8 8e 07 00 00       	call   8039ec <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80325e:	8b 15 20 50 80 00    	mov    0x805020,%edx
  803264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803267:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803273:	89 04 24             	mov    %eax,(%esp)
  803276:	e8 e9 df ff ff       	call   801264 <_Z6fd2numP2Fd>
  80327b:	89 c3                	mov    %eax,%ebx
  80327d:	eb 13                	jmp    803292 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	89 44 24 04          	mov    %eax,0x4(%esp)
  803286:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80328d:	e8 7b db ff ff       	call   800e0d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803292:	89 d8                	mov    %ebx,%eax
  803294:	83 c4 24             	add    $0x24,%esp
  803297:	5b                   	pop    %ebx
  803298:	5d                   	pop    %ebp
  803299:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	89 04 24             	mov    %eax,(%esp)
  8032a0:	e8 07 e0 ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  8032a5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8032a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8032ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8032b3:	89 04 24             	mov    %eax,(%esp)
  8032b6:	e8 f5 08 00 00       	call   803bb0 <_Z8ipc_recvPiPvS_>
  8032bb:	89 c3                	mov    %eax,%ebx
  8032bd:	85 c0                	test   %eax,%eax
  8032bf:	0f 89 39 ff ff ff    	jns    8031fe <_Z18pipe_ipc_recv_readv+0x46>
  8032c5:	eb b8                	jmp    80327f <_Z18pipe_ipc_recv_readv+0xc7>

008032c7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  8032c7:	55                   	push   %ebp
  8032c8:	89 e5                	mov    %esp,%ebp
  8032ca:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  8032cd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8032d4:	00 
  8032d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032df:	89 04 24             	mov    %eax,(%esp)
  8032e2:	e8 2a df ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	78 2f                	js     80331a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  8032eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ee:	89 04 24             	mov    %eax,(%esp)
  8032f1:	e8 b6 df ff ff       	call   8012ac <_Z7fd2dataP2Fd>
  8032f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8032fd:	00 
  8032fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  803302:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803309:	00 
  80330a:	8b 45 08             	mov    0x8(%ebp),%eax
  80330d:	89 04 24             	mov    %eax,(%esp)
  803310:	e8 2a 09 00 00       	call   803c3f <_Z8ipc_sendijPvi>
    return 0;
  803315:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331a:	c9                   	leave  
  80331b:	c3                   	ret    

0080331c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80331c:	55                   	push   %ebp
  80331d:	89 e5                	mov    %esp,%ebp
  80331f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803322:	89 d0                	mov    %edx,%eax
  803324:	c1 e8 16             	shr    $0x16,%eax
  803327:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  80332e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803333:	f6 c1 01             	test   $0x1,%cl
  803336:	74 1d                	je     803355 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803338:	c1 ea 0c             	shr    $0xc,%edx
  80333b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803342:	f6 c2 01             	test   $0x1,%dl
  803345:	74 0e                	je     803355 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803347:	c1 ea 0c             	shr    $0xc,%edx
  80334a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803351:	ef 
  803352:	0f b7 c0             	movzwl %ax,%eax
}
  803355:	5d                   	pop    %ebp
  803356:	c3                   	ret    
	...

00803360 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803360:	55                   	push   %ebp
  803361:	89 e5                	mov    %esp,%ebp
  803363:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803366:	c7 44 24 04 53 49 80 	movl   $0x804953,0x4(%esp)
  80336d:	00 
  80336e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803371:	89 04 24             	mov    %eax,(%esp)
  803374:	e8 f1 d4 ff ff       	call   80086a <_Z6strcpyPcPKc>
	return 0;
}
  803379:	b8 00 00 00 00       	mov    $0x0,%eax
  80337e:	c9                   	leave  
  80337f:	c3                   	ret    

00803380 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803380:	55                   	push   %ebp
  803381:	89 e5                	mov    %esp,%ebp
  803383:	53                   	push   %ebx
  803384:	83 ec 14             	sub    $0x14,%esp
  803387:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80338a:	89 1c 24             	mov    %ebx,(%esp)
  80338d:	e8 8a ff ff ff       	call   80331c <_Z7pagerefPv>
  803392:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803394:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803399:	83 fa 01             	cmp    $0x1,%edx
  80339c:	75 0b                	jne    8033a9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80339e:	8b 43 0c             	mov    0xc(%ebx),%eax
  8033a1:	89 04 24             	mov    %eax,(%esp)
  8033a4:	e8 fe 02 00 00       	call   8036a7 <_Z11nsipc_closei>
	else
		return 0;
}
  8033a9:	83 c4 14             	add    $0x14,%esp
  8033ac:	5b                   	pop    %ebx
  8033ad:	5d                   	pop    %ebp
  8033ae:	c3                   	ret    

008033af <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8033af:	55                   	push   %ebp
  8033b0:	89 e5                	mov    %esp,%ebp
  8033b2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8033b5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8033bc:	00 
  8033bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8033c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d1:	89 04 24             	mov    %eax,(%esp)
  8033d4:	e8 c9 03 00 00       	call   8037a2 <_Z10nsipc_sendiPKvij>
}
  8033d9:	c9                   	leave  
  8033da:	c3                   	ret    

008033db <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8033db:	55                   	push   %ebp
  8033dc:	89 e5                	mov    %esp,%ebp
  8033de:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8033e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8033e8:	00 
  8033e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fd:	89 04 24             	mov    %eax,(%esp)
  803400:	e8 1d 03 00 00       	call   803722 <_Z10nsipc_recviPvij>
}
  803405:	c9                   	leave  
  803406:	c3                   	ret    

00803407 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803407:	55                   	push   %ebp
  803408:	89 e5                	mov    %esp,%ebp
  80340a:	83 ec 28             	sub    $0x28,%esp
  80340d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803410:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803413:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803415:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803418:	89 04 24             	mov    %eax,(%esp)
  80341b:	e8 a7 de ff ff       	call   8012c7 <_Z14fd_find_unusedPP2Fd>
  803420:	89 c3                	mov    %eax,%ebx
  803422:	85 c0                	test   %eax,%eax
  803424:	78 21                	js     803447 <_ZL12alloc_sockfdi+0x40>
  803426:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80342d:	00 
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	89 44 24 04          	mov    %eax,0x4(%esp)
  803435:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80343c:	e8 0f d9 ff ff       	call   800d50 <_Z14sys_page_allociPvi>
  803441:	89 c3                	mov    %eax,%ebx
  803443:	85 c0                	test   %eax,%eax
  803445:	79 14                	jns    80345b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803447:	89 34 24             	mov    %esi,(%esp)
  80344a:	e8 58 02 00 00       	call   8036a7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  80344f:	89 d8                	mov    %ebx,%eax
  803451:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803454:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803457:	89 ec                	mov    %ebp,%esp
  803459:	5d                   	pop    %ebp
  80345a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  80345b:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803464:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803470:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803473:	89 04 24             	mov    %eax,(%esp)
  803476:	e8 e9 dd ff ff       	call   801264 <_Z6fd2numP2Fd>
  80347b:	89 c3                	mov    %eax,%ebx
  80347d:	eb d0                	jmp    80344f <_ZL12alloc_sockfdi+0x48>

0080347f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80347f:	55                   	push   %ebp
  803480:	89 e5                	mov    %esp,%ebp
  803482:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803485:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80348c:	00 
  80348d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803490:	89 54 24 04          	mov    %edx,0x4(%esp)
  803494:	89 04 24             	mov    %eax,(%esp)
  803497:	e8 75 dd ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  80349c:	85 c0                	test   %eax,%eax
  80349e:	78 15                	js     8034b5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8034a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  8034a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8034a8:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  8034ae:	39 0a                	cmp    %ecx,(%edx)
  8034b0:	75 03                	jne    8034b5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8034b2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8034b5:	c9                   	leave  
  8034b6:	c3                   	ret    

008034b7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034b7:	55                   	push   %ebp
  8034b8:	89 e5                	mov    %esp,%ebp
  8034ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	e8 ba ff ff ff       	call   80347f <_ZL9fd2sockidi>
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	78 1f                	js     8034e8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8034c9:	8b 55 10             	mov    0x10(%ebp),%edx
  8034cc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8034d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8034d7:	89 04 24             	mov    %eax,(%esp)
  8034da:	e8 19 01 00 00       	call   8035f8 <_Z12nsipc_acceptiP8sockaddrPj>
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	78 05                	js     8034e8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  8034e3:	e8 1f ff ff ff       	call   803407 <_ZL12alloc_sockfdi>
}
  8034e8:	c9                   	leave  
  8034e9:	c3                   	ret    

008034ea <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8034ea:	55                   	push   %ebp
  8034eb:	89 e5                	mov    %esp,%ebp
  8034ed:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f3:	e8 87 ff ff ff       	call   80347f <_ZL9fd2sockidi>
  8034f8:	85 c0                	test   %eax,%eax
  8034fa:	78 16                	js     803512 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8034fc:	8b 55 10             	mov    0x10(%ebp),%edx
  8034ff:	89 54 24 08          	mov    %edx,0x8(%esp)
  803503:	8b 55 0c             	mov    0xc(%ebp),%edx
  803506:	89 54 24 04          	mov    %edx,0x4(%esp)
  80350a:	89 04 24             	mov    %eax,(%esp)
  80350d:	e8 34 01 00 00       	call   803646 <_Z10nsipc_bindiP8sockaddrj>
}
  803512:	c9                   	leave  
  803513:	c3                   	ret    

00803514 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803514:	55                   	push   %ebp
  803515:	89 e5                	mov    %esp,%ebp
  803517:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	e8 5d ff ff ff       	call   80347f <_ZL9fd2sockidi>
  803522:	85 c0                	test   %eax,%eax
  803524:	78 0f                	js     803535 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803526:	8b 55 0c             	mov    0xc(%ebp),%edx
  803529:	89 54 24 04          	mov    %edx,0x4(%esp)
  80352d:	89 04 24             	mov    %eax,(%esp)
  803530:	e8 50 01 00 00       	call   803685 <_Z14nsipc_shutdownii>
}
  803535:	c9                   	leave  
  803536:	c3                   	ret    

00803537 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803537:	55                   	push   %ebp
  803538:	89 e5                	mov    %esp,%ebp
  80353a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	e8 3a ff ff ff       	call   80347f <_ZL9fd2sockidi>
  803545:	85 c0                	test   %eax,%eax
  803547:	78 16                	js     80355f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803549:	8b 55 10             	mov    0x10(%ebp),%edx
  80354c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803550:	8b 55 0c             	mov    0xc(%ebp),%edx
  803553:	89 54 24 04          	mov    %edx,0x4(%esp)
  803557:	89 04 24             	mov    %eax,(%esp)
  80355a:	e8 62 01 00 00       	call   8036c1 <_Z13nsipc_connectiPK8sockaddrj>
}
  80355f:	c9                   	leave  
  803560:	c3                   	ret    

00803561 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803561:	55                   	push   %ebp
  803562:	89 e5                	mov    %esp,%ebp
  803564:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	e8 10 ff ff ff       	call   80347f <_ZL9fd2sockidi>
  80356f:	85 c0                	test   %eax,%eax
  803571:	78 0f                	js     803582 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803573:	8b 55 0c             	mov    0xc(%ebp),%edx
  803576:	89 54 24 04          	mov    %edx,0x4(%esp)
  80357a:	89 04 24             	mov    %eax,(%esp)
  80357d:	e8 7e 01 00 00       	call   803700 <_Z12nsipc_listenii>
}
  803582:	c9                   	leave  
  803583:	c3                   	ret    

00803584 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803584:	55                   	push   %ebp
  803585:	89 e5                	mov    %esp,%ebp
  803587:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80358a:	8b 45 10             	mov    0x10(%ebp),%eax
  80358d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803591:	8b 45 0c             	mov    0xc(%ebp),%eax
  803594:	89 44 24 04          	mov    %eax,0x4(%esp)
  803598:	8b 45 08             	mov    0x8(%ebp),%eax
  80359b:	89 04 24             	mov    %eax,(%esp)
  80359e:	e8 72 02 00 00       	call   803815 <_Z12nsipc_socketiii>
  8035a3:	85 c0                	test   %eax,%eax
  8035a5:	78 05                	js     8035ac <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  8035a7:	e8 5b fe ff ff       	call   803407 <_ZL12alloc_sockfdi>
}
  8035ac:	c9                   	leave  
  8035ad:	8d 76 00             	lea    0x0(%esi),%esi
  8035b0:	c3                   	ret    
  8035b1:	00 00                	add    %al,(%eax)
	...

008035b4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035b4:	55                   	push   %ebp
  8035b5:	89 e5                	mov    %esp,%ebp
  8035b7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035ba:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8035c1:	00 
  8035c2:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8035c9:	00 
  8035ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035ce:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  8035d5:	e8 65 06 00 00       	call   803c3f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  8035da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8035e1:	00 
  8035e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8035e9:	00 
  8035ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035f1:	e8 ba 05 00 00       	call   803bb0 <_Z8ipc_recvPiPvS_>
}
  8035f6:	c9                   	leave  
  8035f7:	c3                   	ret    

008035f8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8035f8:	55                   	push   %ebp
  8035f9:	89 e5                	mov    %esp,%ebp
  8035fb:	53                   	push   %ebx
  8035fc:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803607:	b8 01 00 00 00       	mov    $0x1,%eax
  80360c:	e8 a3 ff ff ff       	call   8035b4 <_ZL5nsipcj>
  803611:	89 c3                	mov    %eax,%ebx
  803613:	85 c0                	test   %eax,%eax
  803615:	78 27                	js     80363e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803617:	a1 10 70 80 00       	mov    0x807010,%eax
  80361c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803620:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803627:	00 
  803628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362b:	89 04 24             	mov    %eax,(%esp)
  80362e:	e8 d9 d3 ff ff       	call   800a0c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803633:	8b 15 10 70 80 00    	mov    0x807010,%edx
  803639:	8b 45 10             	mov    0x10(%ebp),%eax
  80363c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  80363e:	89 d8                	mov    %ebx,%eax
  803640:	83 c4 14             	add    $0x14,%esp
  803643:	5b                   	pop    %ebx
  803644:	5d                   	pop    %ebp
  803645:	c3                   	ret    

00803646 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803646:	55                   	push   %ebp
  803647:	89 e5                	mov    %esp,%ebp
  803649:	53                   	push   %ebx
  80364a:	83 ec 14             	sub    $0x14,%esp
  80364d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803650:	8b 45 08             	mov    0x8(%ebp),%eax
  803653:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803658:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80365c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803663:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80366a:	e8 9d d3 ff ff       	call   800a0c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80366f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803675:	b8 02 00 00 00       	mov    $0x2,%eax
  80367a:	e8 35 ff ff ff       	call   8035b4 <_ZL5nsipcj>
}
  80367f:	83 c4 14             	add    $0x14,%esp
  803682:	5b                   	pop    %ebx
  803683:	5d                   	pop    %ebp
  803684:	c3                   	ret    

00803685 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803685:	55                   	push   %ebp
  803686:	89 e5                	mov    %esp,%ebp
  803688:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803693:	8b 45 0c             	mov    0xc(%ebp),%eax
  803696:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80369b:	b8 03 00 00 00       	mov    $0x3,%eax
  8036a0:	e8 0f ff ff ff       	call   8035b4 <_ZL5nsipcj>
}
  8036a5:	c9                   	leave  
  8036a6:	c3                   	ret    

008036a7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  8036a7:	55                   	push   %ebp
  8036a8:	89 e5                	mov    %esp,%ebp
  8036aa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8036b5:	b8 04 00 00 00       	mov    $0x4,%eax
  8036ba:	e8 f5 fe ff ff       	call   8035b4 <_ZL5nsipcj>
}
  8036bf:	c9                   	leave  
  8036c0:	c3                   	ret    

008036c1 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036c1:	55                   	push   %ebp
  8036c2:	89 e5                	mov    %esp,%ebp
  8036c4:	53                   	push   %ebx
  8036c5:	83 ec 14             	sub    $0x14,%esp
  8036c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8036cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ce:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8036d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036de:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8036e5:	e8 22 d3 ff ff       	call   800a0c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8036ea:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8036f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8036f5:	e8 ba fe ff ff       	call   8035b4 <_ZL5nsipcj>
}
  8036fa:	83 c4 14             	add    $0x14,%esp
  8036fd:	5b                   	pop    %ebx
  8036fe:	5d                   	pop    %ebp
  8036ff:	c3                   	ret    

00803700 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803700:	55                   	push   %ebp
  803701:	89 e5                	mov    %esp,%ebp
  803703:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80370e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803711:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803716:	b8 06 00 00 00       	mov    $0x6,%eax
  80371b:	e8 94 fe ff ff       	call   8035b4 <_ZL5nsipcj>
}
  803720:	c9                   	leave  
  803721:	c3                   	ret    

00803722 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803722:	55                   	push   %ebp
  803723:	89 e5                	mov    %esp,%ebp
  803725:	56                   	push   %esi
  803726:	53                   	push   %ebx
  803727:	83 ec 10             	sub    $0x10,%esp
  80372a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80372d:	8b 45 08             	mov    0x8(%ebp),%eax
  803730:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803735:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80373b:	8b 45 14             	mov    0x14(%ebp),%eax
  80373e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803743:	b8 07 00 00 00       	mov    $0x7,%eax
  803748:	e8 67 fe ff ff       	call   8035b4 <_ZL5nsipcj>
  80374d:	89 c3                	mov    %eax,%ebx
  80374f:	85 c0                	test   %eax,%eax
  803751:	78 46                	js     803799 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803753:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803758:	7f 04                	jg     80375e <_Z10nsipc_recviPvij+0x3c>
  80375a:	39 f0                	cmp    %esi,%eax
  80375c:	7e 24                	jle    803782 <_Z10nsipc_recviPvij+0x60>
  80375e:	c7 44 24 0c 5f 49 80 	movl   $0x80495f,0xc(%esp)
  803765:	00 
  803766:	c7 44 24 08 cc 42 80 	movl   $0x8042cc,0x8(%esp)
  80376d:	00 
  80376e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803775:	00 
  803776:	c7 04 24 74 49 80 00 	movl   $0x804974,(%esp)
  80377d:	e8 6a 02 00 00       	call   8039ec <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803782:	89 44 24 08          	mov    %eax,0x8(%esp)
  803786:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80378d:	00 
  80378e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803791:	89 04 24             	mov    %eax,(%esp)
  803794:	e8 73 d2 ff ff       	call   800a0c <memmove>
	}

	return r;
}
  803799:	89 d8                	mov    %ebx,%eax
  80379b:	83 c4 10             	add    $0x10,%esp
  80379e:	5b                   	pop    %ebx
  80379f:	5e                   	pop    %esi
  8037a0:	5d                   	pop    %ebp
  8037a1:	c3                   	ret    

008037a2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8037a2:	55                   	push   %ebp
  8037a3:	89 e5                	mov    %esp,%ebp
  8037a5:	53                   	push   %ebx
  8037a6:	83 ec 14             	sub    $0x14,%esp
  8037a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8037ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8037af:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8037b4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8037ba:	7e 24                	jle    8037e0 <_Z10nsipc_sendiPKvij+0x3e>
  8037bc:	c7 44 24 0c 80 49 80 	movl   $0x804980,0xc(%esp)
  8037c3:	00 
  8037c4:	c7 44 24 08 cc 42 80 	movl   $0x8042cc,0x8(%esp)
  8037cb:	00 
  8037cc:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  8037d3:	00 
  8037d4:	c7 04 24 74 49 80 00 	movl   $0x804974,(%esp)
  8037db:	e8 0c 02 00 00       	call   8039ec <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8037e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037eb:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8037f2:	e8 15 d2 ff ff       	call   800a0c <memmove>
	nsipcbuf.send.req_size = size;
  8037f7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8037fd:	8b 45 14             	mov    0x14(%ebp),%eax
  803800:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803805:	b8 08 00 00 00       	mov    $0x8,%eax
  80380a:	e8 a5 fd ff ff       	call   8035b4 <_ZL5nsipcj>
}
  80380f:	83 c4 14             	add    $0x14,%esp
  803812:	5b                   	pop    %ebx
  803813:	5d                   	pop    %ebp
  803814:	c3                   	ret    

00803815 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803815:	55                   	push   %ebp
  803816:	89 e5                	mov    %esp,%ebp
  803818:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803823:	8b 45 0c             	mov    0xc(%ebp),%eax
  803826:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80382b:	8b 45 10             	mov    0x10(%ebp),%eax
  80382e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803833:	b8 09 00 00 00       	mov    $0x9,%eax
  803838:	e8 77 fd ff ff       	call   8035b4 <_ZL5nsipcj>
}
  80383d:	c9                   	leave  
  80383e:	c3                   	ret    
	...

00803840 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803840:	55                   	push   %ebp
  803841:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803843:	b8 00 00 00 00       	mov    $0x0,%eax
  803848:	5d                   	pop    %ebp
  803849:	c3                   	ret    

0080384a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80384a:	55                   	push   %ebp
  80384b:	89 e5                	mov    %esp,%ebp
  80384d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803850:	c7 44 24 04 8c 49 80 	movl   $0x80498c,0x4(%esp)
  803857:	00 
  803858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80385b:	89 04 24             	mov    %eax,(%esp)
  80385e:	e8 07 d0 ff ff       	call   80086a <_Z6strcpyPcPKc>
	return 0;
}
  803863:	b8 00 00 00 00       	mov    $0x0,%eax
  803868:	c9                   	leave  
  803869:	c3                   	ret    

0080386a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80386a:	55                   	push   %ebp
  80386b:	89 e5                	mov    %esp,%ebp
  80386d:	57                   	push   %edi
  80386e:	56                   	push   %esi
  80386f:	53                   	push   %ebx
  803870:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803876:	bb 00 00 00 00       	mov    $0x0,%ebx
  80387b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80387f:	74 3e                	je     8038bf <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803881:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803887:	8b 75 10             	mov    0x10(%ebp),%esi
  80388a:	29 de                	sub    %ebx,%esi
  80388c:	83 fe 7f             	cmp    $0x7f,%esi
  80388f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803894:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803897:	89 74 24 08          	mov    %esi,0x8(%esp)
  80389b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80389e:	01 d8                	add    %ebx,%eax
  8038a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038a4:	89 3c 24             	mov    %edi,(%esp)
  8038a7:	e8 60 d1 ff ff       	call   800a0c <memmove>
		sys_cputs(buf, m);
  8038ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8038b0:	89 3c 24             	mov    %edi,(%esp)
  8038b3:	e8 6c d3 ff ff       	call   800c24 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038b8:	01 f3                	add    %esi,%ebx
  8038ba:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  8038bd:	77 c8                	ja     803887 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8038bf:	89 d8                	mov    %ebx,%eax
  8038c1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8038c7:	5b                   	pop    %ebx
  8038c8:	5e                   	pop    %esi
  8038c9:	5f                   	pop    %edi
  8038ca:	5d                   	pop    %ebp
  8038cb:	c3                   	ret    

008038cc <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038cc:	55                   	push   %ebp
  8038cd:	89 e5                	mov    %esp,%ebp
  8038cf:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8038d2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8038d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8038db:	75 07                	jne    8038e4 <_ZL12devcons_readP2FdPvj+0x18>
  8038dd:	eb 2a                	jmp    803909 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8038df:	e8 38 d4 ff ff       	call   800d1c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8038e4:	e8 6e d3 ff ff       	call   800c57 <_Z9sys_cgetcv>
  8038e9:	85 c0                	test   %eax,%eax
  8038eb:	74 f2                	je     8038df <_ZL12devcons_readP2FdPvj+0x13>
  8038ed:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8038ef:	85 c0                	test   %eax,%eax
  8038f1:	78 16                	js     803909 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8038f3:	83 f8 04             	cmp    $0x4,%eax
  8038f6:	74 0c                	je     803904 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8038f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038fb:	88 10                	mov    %dl,(%eax)
	return 1;
  8038fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803902:	eb 05                	jmp    803909 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803904:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803909:	c9                   	leave  
  80390a:	c3                   	ret    

0080390b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80390b:	55                   	push   %ebp
  80390c:	89 e5                	mov    %esp,%ebp
  80390e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803911:	8b 45 08             	mov    0x8(%ebp),%eax
  803914:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803917:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80391e:	00 
  80391f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803922:	89 04 24             	mov    %eax,(%esp)
  803925:	e8 fa d2 ff ff       	call   800c24 <_Z9sys_cputsPKcj>
}
  80392a:	c9                   	leave  
  80392b:	c3                   	ret    

0080392c <_Z7getcharv>:

int
getchar(void)
{
  80392c:	55                   	push   %ebp
  80392d:	89 e5                	mov    %esp,%ebp
  80392f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803932:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803939:	00 
  80393a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80393d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803941:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803948:	e8 71 dc ff ff       	call   8015be <_Z4readiPvj>
	if (r < 0)
  80394d:	85 c0                	test   %eax,%eax
  80394f:	78 0f                	js     803960 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803951:	85 c0                	test   %eax,%eax
  803953:	7e 06                	jle    80395b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803955:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803959:	eb 05                	jmp    803960 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80395b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803960:	c9                   	leave  
  803961:	c3                   	ret    

00803962 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803962:	55                   	push   %ebp
  803963:	89 e5                	mov    %esp,%ebp
  803965:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803968:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80396f:	00 
  803970:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803973:	89 44 24 04          	mov    %eax,0x4(%esp)
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	89 04 24             	mov    %eax,(%esp)
  80397d:	e8 8f d8 ff ff       	call   801211 <_Z9fd_lookupiPP2Fdb>
  803982:	85 c0                	test   %eax,%eax
  803984:	78 11                	js     803997 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803989:	8b 15 58 50 80 00    	mov    0x805058,%edx
  80398f:	39 10                	cmp    %edx,(%eax)
  803991:	0f 94 c0             	sete   %al
  803994:	0f b6 c0             	movzbl %al,%eax
}
  803997:	c9                   	leave  
  803998:	c3                   	ret    

00803999 <_Z8openconsv>:

int
opencons(void)
{
  803999:	55                   	push   %ebp
  80399a:	89 e5                	mov    %esp,%ebp
  80399c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80399f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8039a2:	89 04 24             	mov    %eax,(%esp)
  8039a5:	e8 1d d9 ff ff       	call   8012c7 <_Z14fd_find_unusedPP2Fd>
  8039aa:	85 c0                	test   %eax,%eax
  8039ac:	78 3c                	js     8039ea <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8039ae:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8039b5:	00 
  8039b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039c4:	e8 87 d3 ff ff       	call   800d50 <_Z14sys_page_allociPvi>
  8039c9:	85 c0                	test   %eax,%eax
  8039cb:	78 1d                	js     8039ea <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8039cd:	8b 15 58 50 80 00    	mov    0x805058,%edx
  8039d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8039d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8039e2:	89 04 24             	mov    %eax,(%esp)
  8039e5:	e8 7a d8 ff ff       	call   801264 <_Z6fd2numP2Fd>
}
  8039ea:	c9                   	leave  
  8039eb:	c3                   	ret    

008039ec <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8039ec:	55                   	push   %ebp
  8039ed:	89 e5                	mov    %esp,%ebp
  8039ef:	56                   	push   %esi
  8039f0:	53                   	push   %ebx
  8039f1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8039f4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  8039f7:	a1 00 80 80 00       	mov    0x808000,%eax
  8039fc:	85 c0                	test   %eax,%eax
  8039fe:	74 10                	je     803a10 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  803a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a04:	c7 04 24 98 49 80 00 	movl   $0x804998,(%esp)
  803a0b:	e8 3e c8 ff ff       	call   80024e <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  803a10:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  803a16:	e8 cd d2 ff ff       	call   800ce8 <_Z12sys_getenvidv>
  803a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a1e:	89 54 24 10          	mov    %edx,0x10(%esp)
  803a22:	8b 55 08             	mov    0x8(%ebp),%edx
  803a25:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803a29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a31:	c7 04 24 a0 49 80 00 	movl   $0x8049a0,(%esp)
  803a38:	e8 11 c8 ff ff       	call   80024e <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  803a3d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803a41:	8b 45 10             	mov    0x10(%ebp),%eax
  803a44:	89 04 24             	mov    %eax,(%esp)
  803a47:	e8 a1 c7 ff ff       	call   8001ed <_Z8vcprintfPKcPc>
	cprintf("\n");
  803a4c:	c7 04 24 e3 48 80 00 	movl   $0x8048e3,(%esp)
  803a53:	e8 f6 c7 ff ff       	call   80024e <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803a58:	cc                   	int3   
  803a59:	eb fd                	jmp    803a58 <_Z6_panicPKciS0_z+0x6c>
  803a5b:	00 00                	add    %al,(%eax)
  803a5d:	00 00                	add    %al,(%eax)
	...

00803a60 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803a60:	55                   	push   %ebp
  803a61:	89 e5                	mov    %esp,%ebp
  803a63:	56                   	push   %esi
  803a64:	53                   	push   %ebx
  803a65:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803a68:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803a6d:	8b 04 9d 20 80 80 00 	mov    0x808020(,%ebx,4),%eax
  803a74:	85 c0                	test   %eax,%eax
  803a76:	74 08                	je     803a80 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803a78:	8d 55 08             	lea    0x8(%ebp),%edx
  803a7b:	89 14 24             	mov    %edx,(%esp)
  803a7e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803a80:	83 eb 01             	sub    $0x1,%ebx
  803a83:	83 fb ff             	cmp    $0xffffffff,%ebx
  803a86:	75 e5                	jne    803a6d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803a88:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803a8b:	8b 75 08             	mov    0x8(%ebp),%esi
  803a8e:	e8 55 d2 ff ff       	call   800ce8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803a93:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803a97:	89 74 24 10          	mov    %esi,0x10(%esp)
  803a9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a9f:	c7 44 24 08 c4 49 80 	movl   $0x8049c4,0x8(%esp)
  803aa6:	00 
  803aa7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803aae:	00 
  803aaf:	c7 04 24 48 4a 80 00 	movl   $0x804a48,(%esp)
  803ab6:	e8 31 ff ff ff       	call   8039ec <_Z6_panicPKciS0_z>

00803abb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803abb:	55                   	push   %ebp
  803abc:	89 e5                	mov    %esp,%ebp
  803abe:	56                   	push   %esi
  803abf:	53                   	push   %ebx
  803ac0:	83 ec 10             	sub    $0x10,%esp
  803ac3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803ac6:	e8 1d d2 ff ff       	call   800ce8 <_Z12sys_getenvidv>
  803acb:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803acd:	a1 00 60 80 00       	mov    0x806000,%eax
  803ad2:	8b 40 5c             	mov    0x5c(%eax),%eax
  803ad5:	85 c0                	test   %eax,%eax
  803ad7:	75 4c                	jne    803b25 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803ad9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803ae0:	00 
  803ae1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803ae8:	ee 
  803ae9:	89 34 24             	mov    %esi,(%esp)
  803aec:	e8 5f d2 ff ff       	call   800d50 <_Z14sys_page_allociPvi>
  803af1:	85 c0                	test   %eax,%eax
  803af3:	74 20                	je     803b15 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803af5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803af9:	c7 44 24 08 fc 49 80 	movl   $0x8049fc,0x8(%esp)
  803b00:	00 
  803b01:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803b08:	00 
  803b09:	c7 04 24 48 4a 80 00 	movl   $0x804a48,(%esp)
  803b10:	e8 d7 fe ff ff       	call   8039ec <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803b15:	c7 44 24 04 60 3a 80 	movl   $0x803a60,0x4(%esp)
  803b1c:	00 
  803b1d:	89 34 24             	mov    %esi,(%esp)
  803b20:	e8 60 d4 ff ff       	call   800f85 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803b25:	a1 20 80 80 00       	mov    0x808020,%eax
  803b2a:	39 d8                	cmp    %ebx,%eax
  803b2c:	74 1a                	je     803b48 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803b2e:	85 c0                	test   %eax,%eax
  803b30:	74 20                	je     803b52 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803b32:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803b37:	8b 14 85 20 80 80 00 	mov    0x808020(,%eax,4),%edx
  803b3e:	39 da                	cmp    %ebx,%edx
  803b40:	74 15                	je     803b57 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803b42:	85 d2                	test   %edx,%edx
  803b44:	75 1f                	jne    803b65 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  803b46:	eb 0f                	jmp    803b57 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803b48:	b8 00 00 00 00       	mov    $0x0,%eax
  803b4d:	8d 76 00             	lea    0x0(%esi),%esi
  803b50:	eb 05                	jmp    803b57 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803b52:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  803b57:	89 1c 85 20 80 80 00 	mov    %ebx,0x808020(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  803b5e:	83 c4 10             	add    $0x10,%esp
  803b61:	5b                   	pop    %ebx
  803b62:	5e                   	pop    %esi
  803b63:	5d                   	pop    %ebp
  803b64:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803b65:	83 c0 01             	add    $0x1,%eax
  803b68:	83 f8 08             	cmp    $0x8,%eax
  803b6b:	75 ca                	jne    803b37 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  803b6d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803b71:	c7 44 24 08 20 4a 80 	movl   $0x804a20,0x8(%esp)
  803b78:	00 
  803b79:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803b80:	00 
  803b81:	c7 04 24 48 4a 80 00 	movl   $0x804a48,(%esp)
  803b88:	e8 5f fe ff ff       	call   8039ec <_Z6_panicPKciS0_z>
  803b8d:	00 00                	add    %al,(%eax)
	...

00803b90 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  803b90:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  803b93:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  803b94:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  803b97:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  803b9b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  803b9f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  803ba2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  803ba4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  803ba8:	61                   	popa   
    popf
  803ba9:	9d                   	popf   
    popl %esp
  803baa:	5c                   	pop    %esp
    ret
  803bab:	c3                   	ret    

00803bac <spin>:

spin:	jmp spin
  803bac:	eb fe                	jmp    803bac <spin>
	...

00803bb0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803bb0:	55                   	push   %ebp
  803bb1:	89 e5                	mov    %esp,%ebp
  803bb3:	56                   	push   %esi
  803bb4:	53                   	push   %ebx
  803bb5:	83 ec 10             	sub    $0x10,%esp
  803bb8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bbe:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  803bc1:	85 c0                	test   %eax,%eax
  803bc3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803bc8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  803bcb:	89 04 24             	mov    %eax,(%esp)
  803bce:	e8 48 d4 ff ff       	call   80101b <_Z12sys_ipc_recvPv>
  803bd3:	85 c0                	test   %eax,%eax
  803bd5:	79 16                	jns    803bed <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  803bd7:	85 db                	test   %ebx,%ebx
  803bd9:	74 06                	je     803be1 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  803bdb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  803be1:	85 f6                	test   %esi,%esi
  803be3:	74 53                	je     803c38 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  803be5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803beb:	eb 4b                	jmp    803c38 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  803bed:	85 db                	test   %ebx,%ebx
  803bef:	74 17                	je     803c08 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  803bf1:	e8 f2 d0 ff ff       	call   800ce8 <_Z12sys_getenvidv>
  803bf6:	25 ff 03 00 00       	and    $0x3ff,%eax
  803bfb:	6b c0 78             	imul   $0x78,%eax,%eax
  803bfe:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  803c03:	8b 40 60             	mov    0x60(%eax),%eax
  803c06:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  803c08:	85 f6                	test   %esi,%esi
  803c0a:	74 17                	je     803c23 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  803c0c:	e8 d7 d0 ff ff       	call   800ce8 <_Z12sys_getenvidv>
  803c11:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c16:	6b c0 78             	imul   $0x78,%eax,%eax
  803c19:	05 00 00 00 ef       	add    $0xef000000,%eax
  803c1e:	8b 40 70             	mov    0x70(%eax),%eax
  803c21:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  803c23:	e8 c0 d0 ff ff       	call   800ce8 <_Z12sys_getenvidv>
  803c28:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c2d:	6b c0 78             	imul   $0x78,%eax,%eax
  803c30:	05 08 00 00 ef       	add    $0xef000008,%eax
  803c35:	8b 40 60             	mov    0x60(%eax),%eax

}
  803c38:	83 c4 10             	add    $0x10,%esp
  803c3b:	5b                   	pop    %ebx
  803c3c:	5e                   	pop    %esi
  803c3d:	5d                   	pop    %ebp
  803c3e:	c3                   	ret    

00803c3f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c3f:	55                   	push   %ebp
  803c40:	89 e5                	mov    %esp,%ebp
  803c42:	57                   	push   %edi
  803c43:	56                   	push   %esi
  803c44:	53                   	push   %ebx
  803c45:	83 ec 1c             	sub    $0x1c,%esp
  803c48:	8b 75 08             	mov    0x8(%ebp),%esi
  803c4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803c4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  803c51:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  803c53:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803c58:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  803c5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c62:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c66:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803c6a:	89 34 24             	mov    %esi,(%esp)
  803c6d:	e8 71 d3 ff ff       	call   800fe3 <_Z16sys_ipc_try_sendijPvi>
  803c72:	85 c0                	test   %eax,%eax
  803c74:	79 31                	jns    803ca7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  803c76:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803c79:	75 0c                	jne    803c87 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  803c7b:	90                   	nop
  803c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803c80:	e8 97 d0 ff ff       	call   800d1c <_Z9sys_yieldv>
  803c85:	eb d4                	jmp    803c5b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  803c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c8b:	c7 44 24 08 56 4a 80 	movl   $0x804a56,0x8(%esp)
  803c92:	00 
  803c93:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  803c9a:	00 
  803c9b:	c7 04 24 63 4a 80 00 	movl   $0x804a63,(%esp)
  803ca2:	e8 45 fd ff ff       	call   8039ec <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  803ca7:	83 c4 1c             	add    $0x1c,%esp
  803caa:	5b                   	pop    %ebx
  803cab:	5e                   	pop    %esi
  803cac:	5f                   	pop    %edi
  803cad:	5d                   	pop    %ebp
  803cae:	c3                   	ret    
	...

00803cb0 <__udivdi3>:
  803cb0:	55                   	push   %ebp
  803cb1:	89 e5                	mov    %esp,%ebp
  803cb3:	57                   	push   %edi
  803cb4:	56                   	push   %esi
  803cb5:	83 ec 20             	sub    $0x20,%esp
  803cb8:	8b 45 14             	mov    0x14(%ebp),%eax
  803cbb:	8b 75 08             	mov    0x8(%ebp),%esi
  803cbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803cc1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803cc4:	85 c0                	test   %eax,%eax
  803cc6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803cc9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  803ccc:	75 3a                	jne    803d08 <__udivdi3+0x58>
  803cce:	39 f9                	cmp    %edi,%ecx
  803cd0:	77 66                	ja     803d38 <__udivdi3+0x88>
  803cd2:	85 c9                	test   %ecx,%ecx
  803cd4:	75 0b                	jne    803ce1 <__udivdi3+0x31>
  803cd6:	b8 01 00 00 00       	mov    $0x1,%eax
  803cdb:	31 d2                	xor    %edx,%edx
  803cdd:	f7 f1                	div    %ecx
  803cdf:	89 c1                	mov    %eax,%ecx
  803ce1:	89 f8                	mov    %edi,%eax
  803ce3:	31 d2                	xor    %edx,%edx
  803ce5:	f7 f1                	div    %ecx
  803ce7:	89 c7                	mov    %eax,%edi
  803ce9:	89 f0                	mov    %esi,%eax
  803ceb:	f7 f1                	div    %ecx
  803ced:	89 fa                	mov    %edi,%edx
  803cef:	89 c6                	mov    %eax,%esi
  803cf1:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803cf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cfd:	83 c4 20             	add    $0x20,%esp
  803d00:	5e                   	pop    %esi
  803d01:	5f                   	pop    %edi
  803d02:	5d                   	pop    %ebp
  803d03:	c3                   	ret    
  803d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d08:	31 d2                	xor    %edx,%edx
  803d0a:	31 f6                	xor    %esi,%esi
  803d0c:	39 f8                	cmp    %edi,%eax
  803d0e:	77 e1                	ja     803cf1 <__udivdi3+0x41>
  803d10:	0f bd d0             	bsr    %eax,%edx
  803d13:	83 f2 1f             	xor    $0x1f,%edx
  803d16:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803d19:	75 2d                	jne    803d48 <__udivdi3+0x98>
  803d1b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803d1e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  803d21:	76 06                	jbe    803d29 <__udivdi3+0x79>
  803d23:	39 f8                	cmp    %edi,%eax
  803d25:	89 f2                	mov    %esi,%edx
  803d27:	73 c8                	jae    803cf1 <__udivdi3+0x41>
  803d29:	31 d2                	xor    %edx,%edx
  803d2b:	be 01 00 00 00       	mov    $0x1,%esi
  803d30:	eb bf                	jmp    803cf1 <__udivdi3+0x41>
  803d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803d38:	89 f0                	mov    %esi,%eax
  803d3a:	89 fa                	mov    %edi,%edx
  803d3c:	f7 f1                	div    %ecx
  803d3e:	31 d2                	xor    %edx,%edx
  803d40:	89 c6                	mov    %eax,%esi
  803d42:	eb ad                	jmp    803cf1 <__udivdi3+0x41>
  803d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d48:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d4c:	89 c2                	mov    %eax,%edx
  803d4e:	b8 20 00 00 00       	mov    $0x20,%eax
  803d53:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803d56:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803d59:	d3 e2                	shl    %cl,%edx
  803d5b:	89 c1                	mov    %eax,%ecx
  803d5d:	d3 ee                	shr    %cl,%esi
  803d5f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d63:	09 d6                	or     %edx,%esi
  803d65:	89 fa                	mov    %edi,%edx
  803d67:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  803d6a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803d6d:	d3 e6                	shl    %cl,%esi
  803d6f:	89 c1                	mov    %eax,%ecx
  803d71:	d3 ea                	shr    %cl,%edx
  803d73:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d77:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803d7a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  803d7d:	d3 e7                	shl    %cl,%edi
  803d7f:	89 c1                	mov    %eax,%ecx
  803d81:	d3 ee                	shr    %cl,%esi
  803d83:	09 fe                	or     %edi,%esi
  803d85:	89 f0                	mov    %esi,%eax
  803d87:	f7 75 e4             	divl   -0x1c(%ebp)
  803d8a:	89 d7                	mov    %edx,%edi
  803d8c:	89 c6                	mov    %eax,%esi
  803d8e:	f7 65 f0             	mull   -0x10(%ebp)
  803d91:	39 d7                	cmp    %edx,%edi
  803d93:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  803d96:	72 12                	jb     803daa <__udivdi3+0xfa>
  803d98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d9b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d9f:	d3 e2                	shl    %cl,%edx
  803da1:	39 c2                	cmp    %eax,%edx
  803da3:	73 08                	jae    803dad <__udivdi3+0xfd>
  803da5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  803da8:	75 03                	jne    803dad <__udivdi3+0xfd>
  803daa:	83 ee 01             	sub    $0x1,%esi
  803dad:	31 d2                	xor    %edx,%edx
  803daf:	e9 3d ff ff ff       	jmp    803cf1 <__udivdi3+0x41>
	...

00803dc0 <__umoddi3>:
  803dc0:	55                   	push   %ebp
  803dc1:	89 e5                	mov    %esp,%ebp
  803dc3:	57                   	push   %edi
  803dc4:	56                   	push   %esi
  803dc5:	83 ec 20             	sub    $0x20,%esp
  803dc8:	8b 7d 14             	mov    0x14(%ebp),%edi
  803dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803dce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803dd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  803dd4:	85 ff                	test   %edi,%edi
  803dd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803dd9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  803ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ddf:	89 f2                	mov    %esi,%edx
  803de1:	75 15                	jne    803df8 <__umoddi3+0x38>
  803de3:	39 f1                	cmp    %esi,%ecx
  803de5:	76 41                	jbe    803e28 <__umoddi3+0x68>
  803de7:	f7 f1                	div    %ecx
  803de9:	89 d0                	mov    %edx,%eax
  803deb:	31 d2                	xor    %edx,%edx
  803ded:	83 c4 20             	add    $0x20,%esp
  803df0:	5e                   	pop    %esi
  803df1:	5f                   	pop    %edi
  803df2:	5d                   	pop    %ebp
  803df3:	c3                   	ret    
  803df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803df8:	39 f7                	cmp    %esi,%edi
  803dfa:	77 4c                	ja     803e48 <__umoddi3+0x88>
  803dfc:	0f bd c7             	bsr    %edi,%eax
  803dff:	83 f0 1f             	xor    $0x1f,%eax
  803e02:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803e05:	75 51                	jne    803e58 <__umoddi3+0x98>
  803e07:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  803e0a:	0f 87 e8 00 00 00    	ja     803ef8 <__umoddi3+0x138>
  803e10:	89 f2                	mov    %esi,%edx
  803e12:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803e15:	29 ce                	sub    %ecx,%esi
  803e17:	19 fa                	sbb    %edi,%edx
  803e19:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1f:	83 c4 20             	add    $0x20,%esp
  803e22:	5e                   	pop    %esi
  803e23:	5f                   	pop    %edi
  803e24:	5d                   	pop    %ebp
  803e25:	c3                   	ret    
  803e26:	66 90                	xchg   %ax,%ax
  803e28:	85 c9                	test   %ecx,%ecx
  803e2a:	75 0b                	jne    803e37 <__umoddi3+0x77>
  803e2c:	b8 01 00 00 00       	mov    $0x1,%eax
  803e31:	31 d2                	xor    %edx,%edx
  803e33:	f7 f1                	div    %ecx
  803e35:	89 c1                	mov    %eax,%ecx
  803e37:	89 f0                	mov    %esi,%eax
  803e39:	31 d2                	xor    %edx,%edx
  803e3b:	f7 f1                	div    %ecx
  803e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e40:	eb a5                	jmp    803de7 <__umoddi3+0x27>
  803e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803e48:	89 f2                	mov    %esi,%edx
  803e4a:	83 c4 20             	add    $0x20,%esp
  803e4d:	5e                   	pop    %esi
  803e4e:	5f                   	pop    %edi
  803e4f:	5d                   	pop    %ebp
  803e50:	c3                   	ret    
  803e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803e58:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e5c:	89 f2                	mov    %esi,%edx
  803e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e61:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  803e68:	29 45 f0             	sub    %eax,-0x10(%ebp)
  803e6b:	d3 e7                	shl    %cl,%edi
  803e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e70:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e74:	d3 e8                	shr    %cl,%eax
  803e76:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e7a:	09 f8                	or     %edi,%eax
  803e7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e82:	d3 e0                	shl    %cl,%eax
  803e84:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e8e:	d3 ea                	shr    %cl,%edx
  803e90:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803e94:	d3 e6                	shl    %cl,%esi
  803e96:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803e9a:	d3 e8                	shr    %cl,%eax
  803e9c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803ea0:	09 f0                	or     %esi,%eax
  803ea2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  803ea5:	f7 75 e4             	divl   -0x1c(%ebp)
  803ea8:	d3 e6                	shl    %cl,%esi
  803eaa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803ead:	89 d6                	mov    %edx,%esi
  803eaf:	f7 65 f4             	mull   -0xc(%ebp)
  803eb2:	89 d7                	mov    %edx,%edi
  803eb4:	89 c2                	mov    %eax,%edx
  803eb6:	39 fe                	cmp    %edi,%esi
  803eb8:	89 f9                	mov    %edi,%ecx
  803eba:	72 30                	jb     803eec <__umoddi3+0x12c>
  803ebc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  803ebf:	72 27                	jb     803ee8 <__umoddi3+0x128>
  803ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ec4:	29 d0                	sub    %edx,%eax
  803ec6:	19 ce                	sbb    %ecx,%esi
  803ec8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803ecc:	89 f2                	mov    %esi,%edx
  803ece:	d3 e8                	shr    %cl,%eax
  803ed0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803ed4:	d3 e2                	shl    %cl,%edx
  803ed6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803eda:	09 d0                	or     %edx,%eax
  803edc:	89 f2                	mov    %esi,%edx
  803ede:	d3 ea                	shr    %cl,%edx
  803ee0:	83 c4 20             	add    $0x20,%esp
  803ee3:	5e                   	pop    %esi
  803ee4:	5f                   	pop    %edi
  803ee5:	5d                   	pop    %ebp
  803ee6:	c3                   	ret    
  803ee7:	90                   	nop
  803ee8:	39 fe                	cmp    %edi,%esi
  803eea:	75 d5                	jne    803ec1 <__umoddi3+0x101>
  803eec:	89 f9                	mov    %edi,%ecx
  803eee:	89 c2                	mov    %eax,%edx
  803ef0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  803ef3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  803ef6:	eb c9                	jmp    803ec1 <__umoddi3+0x101>
  803ef8:	39 f7                	cmp    %esi,%edi
  803efa:	0f 82 10 ff ff ff    	jb     803e10 <__umoddi3+0x50>
  803f00:	e9 17 ff ff ff       	jmp    803e1c <__umoddi3+0x5c>
