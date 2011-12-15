
obj/user/migrated:     file format elf32-i386


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
  80002c:	e8 9f 00 00 00       	call   8000d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z5umainiPPc>:
#include <inc/migrate.h>
#include <inc/connect.h>

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 28             	sub    $0x28,%esp
    assert(thisenv->env_id == ENVID_MIGRATED);
  80003a:	a1 00 70 80 00       	mov    0x807000,%eax
  80003f:	8b 40 04             	mov    0x4(%eax),%eax
  800042:	3d 02 11 00 00       	cmp    $0x1102,%eax
  800047:	74 24                	je     80006d <_Z5umainiPPc+0x39>
  800049:	c7 44 24 0c c0 4a 80 	movl   $0x804ac0,0xc(%esp)
  800050:	00 
  800051:	c7 44 24 08 0a 4b 80 	movl   $0x804b0a,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800060:	00 
  800061:	c7 04 24 1f 4b 80 00 	movl   $0x804b1f,(%esp)
  800068:	e8 e7 00 00 00       	call   800154 <_Z6_panicPKciS0_z>
    int f, r;
    // TODO: bind a socket.
    int writesock, readsock;

    if(mach_connect(&writesock, &readsock) < 0)
  80006d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800070:	89 44 24 04          	mov    %eax,0x4(%esp)
  800074:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800077:	89 04 24             	mov    %eax,(%esp)
  80007a:	e8 e1 37 00 00       	call   803860 <_Z12mach_connectPiS_>
  80007f:	85 c0                	test   %eax,%eax
  800081:	79 1c                	jns    80009f <_Z5umainiPPc+0x6b>
        panic("Could not connect with remote machine");
  800083:	c7 44 24 08 e4 4a 80 	movl   $0x804ae4,0x8(%esp)
  80008a:	00 
  80008b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  800092:	00 
  800093:	c7 04 24 1f 4b 80 00 	movl   $0x804b1f,(%esp)
  80009a:	e8 b5 00 00 00       	call   800154 <_Z6_panicPKciS0_z>

    while (1) {
        if ((r = migrate_spawn(readsock)) < 0)
  80009f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a2:	89 04 24             	mov    %eax,(%esp)
  8000a5:	e8 8d 3b 00 00       	call   803c37 <_Z13migrate_spawni>
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 f1                	jns    80009f <_Z5umainiPPc+0x6b>
            panic("migrate_spawn: %e\n", r);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 2f 4b 80 	movl   $0x804b2f,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 1f 4b 80 00 	movl   $0x804b1f,(%esp)
  8000c9:	e8 86 00 00 00       	call   800154 <_Z6_panicPKciS0_z>
	...

008000d0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8000d0:	55                   	push   %ebp
  8000d1:	89 e5                	mov    %esp,%ebp
  8000d3:	57                   	push   %edi
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 1c             	sub    $0x1c,%esp
  8000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8000df:	e8 24 0c 00 00       	call   800d08 <_Z12sys_getenvidv>
  8000e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000e9:	6b c0 78             	imul   $0x78,%eax,%eax
  8000ec:	05 00 00 00 ef       	add    $0xef000000,%eax
  8000f1:	a3 00 70 80 00       	mov    %eax,0x807000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f6:	85 ff                	test   %edi,%edi
  8000f8:	7e 07                	jle    800101 <libmain+0x31>
		binaryname = argv[0];
  8000fa:	8b 06                	mov    (%esi),%eax
  8000fc:	a3 00 60 80 00       	mov    %eax,0x806000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800101:	b8 5d 59 80 00       	mov    $0x80595d,%eax
  800106:	3d 5d 59 80 00       	cmp    $0x80595d,%eax
  80010b:	76 0f                	jbe    80011c <libmain+0x4c>
  80010d:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80010f:	83 eb 04             	sub    $0x4,%ebx
  800112:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800114:	81 fb 5d 59 80 00    	cmp    $0x80595d,%ebx
  80011a:	77 f3                	ja     80010f <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  80011c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800120:	89 3c 24             	mov    %edi,(%esp)
  800123:	e8 0c ff ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800128:	e8 0b 00 00 00       	call   800138 <_Z4exitv>
}
  80012d:	83 c4 1c             	add    $0x1c,%esp
  800130:	5b                   	pop    %ebx
  800131:	5e                   	pop    %esi
  800132:	5f                   	pop    %edi
  800133:	5d                   	pop    %ebp
  800134:	c3                   	ret    
  800135:	00 00                	add    %al,(%eax)
	...

00800138 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80013e:	e8 2b 13 00 00       	call   80146e <_Z9close_allv>
	sys_env_destroy(0);
  800143:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014a:	e8 5c 0b 00 00       	call   800cab <_Z15sys_env_destroyi>
}
  80014f:	c9                   	leave  
  800150:	c3                   	ret    
  800151:	00 00                	add    %al,(%eax)
	...

00800154 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	56                   	push   %esi
  800158:	53                   	push   %ebx
  800159:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80015c:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  80015f:	a1 04 70 80 00       	mov    0x807004,%eax
  800164:	85 c0                	test   %eax,%eax
  800166:	74 10                	je     800178 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  800168:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016c:	c7 04 24 4c 4b 80 00 	movl   $0x804b4c,(%esp)
  800173:	e8 fa 00 00 00       	call   800272 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  800178:	8b 1d 00 60 80 00    	mov    0x806000,%ebx
  80017e:	e8 85 0b 00 00       	call   800d08 <_Z12sys_getenvidv>
  800183:	8b 55 0c             	mov    0xc(%ebp),%edx
  800186:	89 54 24 10          	mov    %edx,0x10(%esp)
  80018a:	8b 55 08             	mov    0x8(%ebp),%edx
  80018d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800191:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800195:	89 44 24 04          	mov    %eax,0x4(%esp)
  800199:	c7 04 24 54 4b 80 00 	movl   $0x804b54,(%esp)
  8001a0:	e8 cd 00 00 00       	call   800272 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8001a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ac:	89 04 24             	mov    %eax,(%esp)
  8001af:	e8 5d 00 00 00       	call   800211 <_Z8vcprintfPKcPc>
	cprintf("\n");
  8001b4:	c7 04 24 0f 55 80 00 	movl   $0x80550f,(%esp)
  8001bb:	e8 b2 00 00 00       	call   800272 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c0:	cc                   	int3   
  8001c1:	eb fd                	jmp    8001c0 <_Z6_panicPKciS0_z+0x6c>
	...

008001c4 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	83 ec 18             	sub    $0x18,%esp
  8001ca:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001cd:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  8001d3:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8001d5:	8b 03                	mov    (%ebx),%eax
  8001d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001da:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001de:	83 c0 01             	add    $0x1,%eax
  8001e1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e8:	75 19                	jne    800203 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8001ea:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001f1:	00 
  8001f2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f5:	89 04 24             	mov    %eax,(%esp)
  8001f8:	e8 47 0a 00 00       	call   800c44 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8001fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800203:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800207:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80020a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80020d:	89 ec                	mov    %ebp,%esp
  80020f:	5d                   	pop    %ebp
  800210:	c3                   	ret    

00800211 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80021a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800221:	00 00 00 
	b.cnt = 0;
  800224:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80022e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800231:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800235:	8b 45 08             	mov    0x8(%ebp),%eax
  800238:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800242:	89 44 24 04          	mov    %eax,0x4(%esp)
  800246:	c7 04 24 c4 01 80 00 	movl   $0x8001c4,(%esp)
  80024d:	e8 a5 01 00 00       	call   8003f7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800252:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800262:	89 04 24             	mov    %eax,(%esp)
  800265:	e8 da 09 00 00       	call   800c44 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  80026a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800278:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027f:	8b 45 08             	mov    0x8(%ebp),%eax
  800282:	89 04 24             	mov    %eax,(%esp)
  800285:	e8 87 ff ff ff       	call   800211 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    
  80028c:	00 00                	add    %al,(%eax)
	...

00800290 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 4c             	sub    $0x4c,%esp
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	89 d6                	mov    %edx,%esi
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ad:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b5:	39 d0                	cmp    %edx,%eax
  8002b7:	72 11                	jb     8002ca <_ZL8printnumPFviPvES_yjii+0x3a>
  8002b9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002bc:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  8002bf:	76 09                	jbe    8002ca <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c1:	83 eb 01             	sub    $0x1,%ebx
  8002c4:	85 db                	test   %ebx,%ebx
  8002c6:	7f 5d                	jg     800325 <_ZL8printnumPFviPvES_yjii+0x95>
  8002c8:	eb 6c                	jmp    800336 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ca:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002ce:	83 eb 01             	sub    $0x1,%ebx
  8002d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002e0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8002ea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002f1:	00 
  8002f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002f5:	89 14 24             	mov    %edx,(%esp)
  8002f8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002ff:	e8 4c 45 00 00       	call   804850 <__udivdi3>
  800304:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800307:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80030a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80030e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800312:	89 04 24             	mov    %eax,(%esp)
  800315:	89 54 24 04          	mov    %edx,0x4(%esp)
  800319:	89 f2                	mov    %esi,%edx
  80031b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031e:	e8 6d ff ff ff       	call   800290 <_ZL8printnumPFviPvES_yjii>
  800323:	eb 11                	jmp    800336 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800325:	89 74 24 04          	mov    %esi,0x4(%esp)
  800329:	89 3c 24             	mov    %edi,(%esp)
  80032c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80032f:	83 eb 01             	sub    $0x1,%ebx
  800332:	85 db                	test   %ebx,%ebx
  800334:	7f ef                	jg     800325 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800336:	89 74 24 04          	mov    %esi,0x4(%esp)
  80033a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80033e:	8b 45 10             	mov    0x10(%ebp),%eax
  800341:	89 44 24 08          	mov    %eax,0x8(%esp)
  800345:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80034c:	00 
  80034d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800350:	89 14 24             	mov    %edx,(%esp)
  800353:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800356:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80035a:	e8 01 46 00 00       	call   804960 <__umoddi3>
  80035f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800363:	0f be 80 77 4b 80 00 	movsbl 0x804b77(%eax),%eax
  80036a:	89 04 24             	mov    %eax,(%esp)
  80036d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800370:	83 c4 4c             	add    $0x4c,%esp
  800373:	5b                   	pop    %ebx
  800374:	5e                   	pop    %esi
  800375:	5f                   	pop    %edi
  800376:	5d                   	pop    %ebp
  800377:	c3                   	ret    

00800378 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80037b:	83 fa 01             	cmp    $0x1,%edx
  80037e:	7e 0e                	jle    80038e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800380:	8b 10                	mov    (%eax),%edx
  800382:	8d 4a 08             	lea    0x8(%edx),%ecx
  800385:	89 08                	mov    %ecx,(%eax)
  800387:	8b 02                	mov    (%edx),%eax
  800389:	8b 52 04             	mov    0x4(%edx),%edx
  80038c:	eb 22                	jmp    8003b0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80038e:	85 d2                	test   %edx,%edx
  800390:	74 10                	je     8003a2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800392:	8b 10                	mov    (%eax),%edx
  800394:	8d 4a 04             	lea    0x4(%edx),%ecx
  800397:	89 08                	mov    %ecx,(%eax)
  800399:	8b 02                	mov    (%edx),%eax
  80039b:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a0:	eb 0e                	jmp    8003b0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003a2:	8b 10                	mov    (%eax),%edx
  8003a4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a7:	89 08                	mov    %ecx,(%eax)
  8003a9:	8b 02                	mov    (%edx),%eax
  8003ab:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003b0:	5d                   	pop    %ebp
  8003b1:	c3                   	ret    

008003b2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8003b8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003bc:	8b 10                	mov    (%eax),%edx
  8003be:	3b 50 04             	cmp    0x4(%eax),%edx
  8003c1:	73 0a                	jae    8003cd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8003c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003c6:	88 0a                	mov    %cl,(%edx)
  8003c8:	83 c2 01             	add    $0x1,%edx
  8003cb:	89 10                	mov    %edx,(%eax)
}
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003d5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	89 04 24             	mov    %eax,(%esp)
  8003f0:	e8 02 00 00 00       	call   8003f7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	57                   	push   %edi
  8003fb:	56                   	push   %esi
  8003fc:	53                   	push   %ebx
  8003fd:	83 ec 3c             	sub    $0x3c,%esp
  800400:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800403:	8b 55 10             	mov    0x10(%ebp),%edx
  800406:	0f b6 02             	movzbl (%edx),%eax
  800409:	89 d3                	mov    %edx,%ebx
  80040b:	83 c3 01             	add    $0x1,%ebx
  80040e:	83 f8 25             	cmp    $0x25,%eax
  800411:	74 2b                	je     80043e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800413:	85 c0                	test   %eax,%eax
  800415:	75 10                	jne    800427 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800417:	e9 a5 03 00 00       	jmp    8007c1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80041c:	85 c0                	test   %eax,%eax
  80041e:	66 90                	xchg   %ax,%ax
  800420:	75 08                	jne    80042a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800422:	e9 9a 03 00 00       	jmp    8007c1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800427:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80042a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042e:	89 04 24             	mov    %eax,(%esp)
  800431:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800433:	0f b6 03             	movzbl (%ebx),%eax
  800436:	83 c3 01             	add    $0x1,%ebx
  800439:	83 f8 25             	cmp    $0x25,%eax
  80043c:	75 de                	jne    80041c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80043e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800442:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800449:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80044e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800455:	b9 00 00 00 00       	mov    $0x0,%ecx
  80045a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80045d:	eb 2b                	jmp    80048a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800462:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800466:	eb 22                	jmp    80048a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800468:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80046b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80046f:	eb 19                	jmp    80048a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800471:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800474:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80047b:	eb 0d                	jmp    80048a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80047d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800480:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800483:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	0f b6 03             	movzbl (%ebx),%eax
  80048d:	0f b6 d0             	movzbl %al,%edx
  800490:	8d 73 01             	lea    0x1(%ebx),%esi
  800493:	89 75 10             	mov    %esi,0x10(%ebp)
  800496:	83 e8 23             	sub    $0x23,%eax
  800499:	3c 55                	cmp    $0x55,%al
  80049b:	0f 87 d8 02 00 00    	ja     800779 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  8004a1:	0f b6 c0             	movzbl %al,%eax
  8004a4:	ff 24 85 20 4d 80 00 	jmp    *0x804d20(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004ab:	83 ea 30             	sub    $0x30,%edx
  8004ae:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8004b1:	8b 55 10             	mov    0x10(%ebp),%edx
  8004b4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8004b7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8004bd:	83 fa 09             	cmp    $0x9,%edx
  8004c0:	77 4e                	ja     800510 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004c5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8004c8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8004cb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8004cf:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  8004d2:	8d 50 d0             	lea    -0x30(%eax),%edx
  8004d5:	83 fa 09             	cmp    $0x9,%edx
  8004d8:	76 eb                	jbe    8004c5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  8004da:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004dd:	eb 31                	jmp    800510 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004df:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e2:	8d 50 04             	lea    0x4(%eax),%edx
  8004e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004f0:	eb 1e                	jmp    800510 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8004f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004f6:	0f 88 75 ff ff ff    	js     800471 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004ff:	eb 89                	jmp    80048a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800501:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800504:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80050b:	e9 7a ff ff ff       	jmp    80048a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800510:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800514:	0f 89 70 ff ff ff    	jns    80048a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80051a:	e9 5e ff ff ff       	jmp    80047d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80051f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800522:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800525:	e9 60 ff ff ff       	jmp    80048a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8d 50 04             	lea    0x4(%eax),%edx
  800530:	89 55 14             	mov    %edx,0x14(%ebp)
  800533:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800537:	8b 00                	mov    (%eax),%eax
  800539:	89 04 24             	mov    %eax,(%esp)
  80053c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80053f:	e9 bf fe ff ff       	jmp    800403 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 50 04             	lea    0x4(%eax),%edx
  80054a:	89 55 14             	mov    %edx,0x14(%ebp)
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	89 c2                	mov    %eax,%edx
  800551:	c1 fa 1f             	sar    $0x1f,%edx
  800554:	31 d0                	xor    %edx,%eax
  800556:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800558:	83 f8 14             	cmp    $0x14,%eax
  80055b:	7f 0f                	jg     80056c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80055d:	8b 14 85 80 4e 80 00 	mov    0x804e80(,%eax,4),%edx
  800564:	85 d2                	test   %edx,%edx
  800566:	0f 85 35 02 00 00    	jne    8007a1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80056c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800570:	c7 44 24 08 8f 4b 80 	movl   $0x804b8f,0x8(%esp)
  800577:	00 
  800578:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80057c:	8b 75 08             	mov    0x8(%ebp),%esi
  80057f:	89 34 24             	mov    %esi,(%esp)
  800582:	e8 48 fe ff ff       	call   8003cf <_Z8printfmtPFviPvES_PKcz>
  800587:	e9 77 fe ff ff       	jmp    800403 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80058c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800592:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 50 04             	lea    0x4(%eax),%edx
  80059b:	89 55 14             	mov    %edx,0x14(%ebp)
  80059e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  8005a0:	85 db                	test   %ebx,%ebx
  8005a2:	ba 88 4b 80 00       	mov    $0x804b88,%edx
  8005a7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  8005aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ae:	7e 72                	jle    800622 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8005b0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8005b4:	74 6c                	je     800622 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ba:	89 1c 24             	mov    %ebx,(%esp)
  8005bd:	e8 a9 02 00 00       	call   80086b <_Z7strnlenPKcj>
  8005c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005ca:	85 d2                	test   %edx,%edx
  8005cc:	7e 54                	jle    800622 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  8005ce:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  8005d2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8005d5:	89 d3                	mov    %edx,%ebx
  8005d7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005da:	89 c6                	mov    %eax,%esi
  8005dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005e0:	89 34 24             	mov    %esi,(%esp)
  8005e3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e6:	83 eb 01             	sub    $0x1,%ebx
  8005e9:	85 db                	test   %ebx,%ebx
  8005eb:	7f ef                	jg     8005dc <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  8005ed:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8005f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005fa:	eb 26                	jmp    800622 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005fc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005ff:	83 fa 5e             	cmp    $0x5e,%edx
  800602:	76 10                	jbe    800614 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800604:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800608:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80060f:	ff 55 08             	call   *0x8(%ebp)
  800612:	eb 0a                	jmp    80061e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800614:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800618:	89 04 24             	mov    %eax,(%esp)
  80061b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800622:	0f be 03             	movsbl (%ebx),%eax
  800625:	83 c3 01             	add    $0x1,%ebx
  800628:	85 c0                	test   %eax,%eax
  80062a:	74 11                	je     80063d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80062c:	85 f6                	test   %esi,%esi
  80062e:	78 05                	js     800635 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800630:	83 ee 01             	sub    $0x1,%esi
  800633:	78 0d                	js     800642 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800635:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800639:	75 c1                	jne    8005fc <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80063b:	eb d7                	jmp    800614 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80063d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800640:	eb 03                	jmp    800645 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800645:	85 c0                	test   %eax,%eax
  800647:	0f 8e b6 fd ff ff    	jle    800403 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80064d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800650:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800653:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800657:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80065e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800660:	83 eb 01             	sub    $0x1,%ebx
  800663:	85 db                	test   %ebx,%ebx
  800665:	7f ec                	jg     800653 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800667:	e9 97 fd ff ff       	jmp    800403 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80066c:	83 f9 01             	cmp    $0x1,%ecx
  80066f:	90                   	nop
  800670:	7e 10                	jle    800682 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 50 08             	lea    0x8(%eax),%edx
  800678:	89 55 14             	mov    %edx,0x14(%ebp)
  80067b:	8b 18                	mov    (%eax),%ebx
  80067d:	8b 70 04             	mov    0x4(%eax),%esi
  800680:	eb 26                	jmp    8006a8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800682:	85 c9                	test   %ecx,%ecx
  800684:	74 12                	je     800698 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8d 50 04             	lea    0x4(%eax),%edx
  80068c:	89 55 14             	mov    %edx,0x14(%ebp)
  80068f:	8b 18                	mov    (%eax),%ebx
  800691:	89 de                	mov    %ebx,%esi
  800693:	c1 fe 1f             	sar    $0x1f,%esi
  800696:	eb 10                	jmp    8006a8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8d 50 04             	lea    0x4(%eax),%edx
  80069e:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a1:	8b 18                	mov    (%eax),%ebx
  8006a3:	89 de                	mov    %ebx,%esi
  8006a5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006a8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006ad:	85 f6                	test   %esi,%esi
  8006af:	0f 89 8c 00 00 00    	jns    800741 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8006b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006c0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006c3:	f7 db                	neg    %ebx
  8006c5:	83 d6 00             	adc    $0x0,%esi
  8006c8:	f7 de                	neg    %esi
			}
			base = 10;
  8006ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cf:	eb 70                	jmp    800741 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006d1:	89 ca                	mov    %ecx,%edx
  8006d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d6:	e8 9d fc ff ff       	call   800378 <_ZL7getuintPPci>
  8006db:	89 c3                	mov    %eax,%ebx
  8006dd:	89 d6                	mov    %edx,%esi
			base = 10;
  8006df:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8006e4:	eb 5b                	jmp    800741 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006e6:	89 ca                	mov    %ecx,%edx
  8006e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006eb:	e8 88 fc ff ff       	call   800378 <_ZL7getuintPPci>
  8006f0:	89 c3                	mov    %eax,%ebx
  8006f2:	89 d6                	mov    %edx,%esi
			base = 8;
  8006f4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8006f9:	eb 46                	jmp    800741 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8006fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ff:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800706:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800709:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800714:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	89 55 14             	mov    %edx,0x14(%ebp)
  800720:	8b 18                	mov    (%eax),%ebx
  800722:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800727:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80072c:	eb 13                	jmp    800741 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80072e:	89 ca                	mov    %ecx,%edx
  800730:	8d 45 14             	lea    0x14(%ebp),%eax
  800733:	e8 40 fc ff ff       	call   800378 <_ZL7getuintPPci>
  800738:	89 c3                	mov    %eax,%ebx
  80073a:	89 d6                	mov    %edx,%esi
			base = 16;
  80073c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800741:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800745:	89 54 24 10          	mov    %edx,0x10(%esp)
  800749:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80074c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800750:	89 44 24 08          	mov    %eax,0x8(%esp)
  800754:	89 1c 24             	mov    %ebx,(%esp)
  800757:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075b:	89 fa                	mov    %edi,%edx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	e8 2b fb ff ff       	call   800290 <_ZL8printnumPFviPvES_yjii>
			break;
  800765:	e9 99 fc ff ff       	jmp    800403 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80076a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076e:	89 14 24             	mov    %edx,(%esp)
  800771:	ff 55 08             	call   *0x8(%ebp)
			break;
  800774:	e9 8a fc ff ff       	jmp    800403 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800779:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800784:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800787:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80078a:	89 d8                	mov    %ebx,%eax
  80078c:	eb 02                	jmp    800790 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80078e:	89 d0                	mov    %edx,%eax
  800790:	8d 50 ff             	lea    -0x1(%eax),%edx
  800793:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800797:	75 f5                	jne    80078e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800799:	89 45 10             	mov    %eax,0x10(%ebp)
  80079c:	e9 62 fc ff ff       	jmp    800403 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007a5:	c7 44 24 08 1c 4b 80 	movl   $0x804b1c,0x8(%esp)
  8007ac:	00 
  8007ad:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b4:	89 34 24             	mov    %esi,(%esp)
  8007b7:	e8 13 fc ff ff       	call   8003cf <_Z8printfmtPFviPvES_PKcz>
  8007bc:	e9 42 fc ff ff       	jmp    800403 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007c1:	83 c4 3c             	add    $0x3c,%esp
  8007c4:	5b                   	pop    %ebx
  8007c5:	5e                   	pop    %esi
  8007c6:	5f                   	pop    %edi
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 28             	sub    $0x28,%esp
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8007dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007df:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  8007e6:	85 c0                	test   %eax,%eax
  8007e8:	74 30                	je     80081a <_Z9vsnprintfPciPKcS_+0x51>
  8007ea:	85 d2                	test   %edx,%edx
  8007ec:	7e 2c                	jle    80081a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800803:	c7 04 24 b2 03 80 00 	movl   $0x8003b2,(%esp)
  80080a:	e8 e8 fb ff ff       	call   8003f7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80080f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800812:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800818:	eb 05                	jmp    80081f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80081a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80081f:	c9                   	leave  
  800820:	c3                   	ret    

00800821 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800827:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80082a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80082e:	8b 45 10             	mov    0x10(%ebp),%eax
  800831:	89 44 24 08          	mov    %eax,0x8(%esp)
  800835:	8b 45 0c             	mov    0xc(%ebp),%eax
  800838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	89 04 24             	mov    %eax,(%esp)
  800842:	e8 82 ff ff ff       	call   8007c9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800847:	c9                   	leave  
  800848:	c3                   	ret    
  800849:	00 00                	add    %al,(%eax)
  80084b:	00 00                	add    %al,(%eax)
  80084d:	00 00                	add    %al,(%eax)
	...

00800850 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800856:	b8 00 00 00 00       	mov    $0x0,%eax
  80085b:	80 3a 00             	cmpb   $0x0,(%edx)
  80085e:	74 09                	je     800869 <_Z6strlenPKc+0x19>
		n++;
  800860:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800863:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800867:	75 f7                	jne    800860 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800871:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800874:	b8 00 00 00 00       	mov    $0x0,%eax
  800879:	39 c2                	cmp    %eax,%edx
  80087b:	74 0b                	je     800888 <_Z7strnlenPKcj+0x1d>
  80087d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800881:	74 05                	je     800888 <_Z7strnlenPKcj+0x1d>
		n++;
  800883:	83 c0 01             	add    $0x1,%eax
  800886:	eb f1                	jmp    800879 <_Z7strnlenPKcj+0xe>
	return n;
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	53                   	push   %ebx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800894:	ba 00 00 00 00       	mov    $0x0,%edx
  800899:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80089d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008a0:	83 c2 01             	add    $0x1,%edx
  8008a3:	84 c9                	test   %cl,%cl
  8008a5:	75 f2                	jne    800899 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  8008a7:	5b                   	pop    %ebx
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	56                   	push   %esi
  8008ae:	53                   	push   %ebx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8008b8:	85 f6                	test   %esi,%esi
  8008ba:	74 18                	je     8008d4 <_Z7strncpyPcPKcj+0x2a>
  8008bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8008c1:	0f b6 1a             	movzbl (%edx),%ebx
  8008c4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c7:	80 3a 01             	cmpb   $0x1,(%edx)
  8008ca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8008cd:	83 c1 01             	add    $0x1,%ecx
  8008d0:	39 ce                	cmp    %ecx,%esi
  8008d2:	77 ed                	ja     8008c1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008d4:	5b                   	pop    %ebx
  8008d5:	5e                   	pop    %esi
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	56                   	push   %esi
  8008dc:	53                   	push   %ebx
  8008dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  8008e6:	89 f0                	mov    %esi,%eax
  8008e8:	85 d2                	test   %edx,%edx
  8008ea:	74 17                	je     800903 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  8008ec:	83 ea 01             	sub    $0x1,%edx
  8008ef:	74 18                	je     800909 <_Z7strlcpyPcPKcj+0x31>
  8008f1:	80 39 00             	cmpb   $0x0,(%ecx)
  8008f4:	74 17                	je     80090d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8008f6:	0f b6 19             	movzbl (%ecx),%ebx
  8008f9:	88 18                	mov    %bl,(%eax)
  8008fb:	83 c0 01             	add    $0x1,%eax
  8008fe:	83 c1 01             	add    $0x1,%ecx
  800901:	eb e9                	jmp    8008ec <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800903:	29 f0                	sub    %esi,%eax
}
  800905:	5b                   	pop    %ebx
  800906:	5e                   	pop    %esi
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800909:	89 c2                	mov    %eax,%edx
  80090b:	eb 02                	jmp    80090f <_Z7strlcpyPcPKcj+0x37>
  80090d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  80090f:	c6 02 00             	movb   $0x0,(%edx)
  800912:	eb ef                	jmp    800903 <_Z7strlcpyPcPKcj+0x2b>

00800914 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80091d:	0f b6 01             	movzbl (%ecx),%eax
  800920:	84 c0                	test   %al,%al
  800922:	74 0c                	je     800930 <_Z6strcmpPKcS0_+0x1c>
  800924:	3a 02                	cmp    (%edx),%al
  800926:	75 08                	jne    800930 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800928:	83 c1 01             	add    $0x1,%ecx
  80092b:	83 c2 01             	add    $0x1,%edx
  80092e:	eb ed                	jmp    80091d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800930:	0f b6 c0             	movzbl %al,%eax
  800933:	0f b6 12             	movzbl (%edx),%edx
  800936:	29 d0                	sub    %edx,%eax
}
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	53                   	push   %ebx
  80093e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800941:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800944:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800947:	85 d2                	test   %edx,%edx
  800949:	74 16                	je     800961 <_Z7strncmpPKcS0_j+0x27>
  80094b:	0f b6 01             	movzbl (%ecx),%eax
  80094e:	84 c0                	test   %al,%al
  800950:	74 17                	je     800969 <_Z7strncmpPKcS0_j+0x2f>
  800952:	3a 03                	cmp    (%ebx),%al
  800954:	75 13                	jne    800969 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800956:	83 ea 01             	sub    $0x1,%edx
  800959:	83 c1 01             	add    $0x1,%ecx
  80095c:	83 c3 01             	add    $0x1,%ebx
  80095f:	eb e6                	jmp    800947 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800961:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800966:	5b                   	pop    %ebx
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800969:	0f b6 01             	movzbl (%ecx),%eax
  80096c:	0f b6 13             	movzbl (%ebx),%edx
  80096f:	29 d0                	sub    %edx,%eax
  800971:	eb f3                	jmp    800966 <_Z7strncmpPKcS0_j+0x2c>

00800973 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097d:	0f b6 10             	movzbl (%eax),%edx
  800980:	84 d2                	test   %dl,%dl
  800982:	74 1f                	je     8009a3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800984:	38 ca                	cmp    %cl,%dl
  800986:	75 0a                	jne    800992 <_Z6strchrPKcc+0x1f>
  800988:	eb 1e                	jmp    8009a8 <_Z6strchrPKcc+0x35>
  80098a:	38 ca                	cmp    %cl,%dl
  80098c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800990:	74 16                	je     8009a8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800992:	83 c0 01             	add    $0x1,%eax
  800995:	0f b6 10             	movzbl (%eax),%edx
  800998:	84 d2                	test   %dl,%dl
  80099a:	75 ee                	jne    80098a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80099c:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a1:	eb 05                	jmp    8009a8 <_Z6strchrPKcc+0x35>
  8009a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b4:	0f b6 10             	movzbl (%eax),%edx
  8009b7:	84 d2                	test   %dl,%dl
  8009b9:	74 14                	je     8009cf <_Z7strfindPKcc+0x25>
		if (*s == c)
  8009bb:	38 ca                	cmp    %cl,%dl
  8009bd:	75 06                	jne    8009c5 <_Z7strfindPKcc+0x1b>
  8009bf:	eb 0e                	jmp    8009cf <_Z7strfindPKcc+0x25>
  8009c1:	38 ca                	cmp    %cl,%dl
  8009c3:	74 0a                	je     8009cf <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009c5:	83 c0 01             	add    $0x1,%eax
  8009c8:	0f b6 10             	movzbl (%eax),%edx
  8009cb:	84 d2                	test   %dl,%dl
  8009cd:	75 f2                	jne    8009c1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 0c             	sub    $0xc,%esp
  8009d7:	89 1c 24             	mov    %ebx,(%esp)
  8009da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  8009eb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009f1:	75 25                	jne    800a18 <memset+0x47>
  8009f3:	f6 c1 03             	test   $0x3,%cl
  8009f6:	75 20                	jne    800a18 <memset+0x47>
		c &= 0xFF;
  8009f8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009fb:	89 d3                	mov    %edx,%ebx
  8009fd:	c1 e3 08             	shl    $0x8,%ebx
  800a00:	89 d6                	mov    %edx,%esi
  800a02:	c1 e6 18             	shl    $0x18,%esi
  800a05:	89 d0                	mov    %edx,%eax
  800a07:	c1 e0 10             	shl    $0x10,%eax
  800a0a:	09 f0                	or     %esi,%eax
  800a0c:	09 d0                	or     %edx,%eax
  800a0e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800a10:	c1 e9 02             	shr    $0x2,%ecx
  800a13:	fc                   	cld    
  800a14:	f3 ab                	rep stos %eax,%es:(%edi)
  800a16:	eb 03                	jmp    800a1b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800a18:	fc                   	cld    
  800a19:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800a1b:	89 f8                	mov    %edi,%eax
  800a1d:	8b 1c 24             	mov    (%esp),%ebx
  800a20:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a28:	89 ec                	mov    %ebp,%esp
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	89 34 24             	mov    %esi,(%esp)
  800a35:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800a42:	39 c6                	cmp    %eax,%esi
  800a44:	73 36                	jae    800a7c <memmove+0x50>
  800a46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a49:	39 d0                	cmp    %edx,%eax
  800a4b:	73 2f                	jae    800a7c <memmove+0x50>
		s += n;
		d += n;
  800a4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a50:	f6 c2 03             	test   $0x3,%dl
  800a53:	75 1b                	jne    800a70 <memmove+0x44>
  800a55:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a5b:	75 13                	jne    800a70 <memmove+0x44>
  800a5d:	f6 c1 03             	test   $0x3,%cl
  800a60:	75 0e                	jne    800a70 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a62:	83 ef 04             	sub    $0x4,%edi
  800a65:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a68:	c1 e9 02             	shr    $0x2,%ecx
  800a6b:	fd                   	std    
  800a6c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6e:	eb 09                	jmp    800a79 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a70:	83 ef 01             	sub    $0x1,%edi
  800a73:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a76:	fd                   	std    
  800a77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a79:	fc                   	cld    
  800a7a:	eb 20                	jmp    800a9c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a7c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a82:	75 13                	jne    800a97 <memmove+0x6b>
  800a84:	a8 03                	test   $0x3,%al
  800a86:	75 0f                	jne    800a97 <memmove+0x6b>
  800a88:	f6 c1 03             	test   $0x3,%cl
  800a8b:	75 0a                	jne    800a97 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a8d:	c1 e9 02             	shr    $0x2,%ecx
  800a90:	89 c7                	mov    %eax,%edi
  800a92:	fc                   	cld    
  800a93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a95:	eb 05                	jmp    800a9c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800a97:	89 c7                	mov    %eax,%edi
  800a99:	fc                   	cld    
  800a9a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800a9c:	8b 34 24             	mov    (%esp),%esi
  800a9f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800aa3:	89 ec                	mov    %ebp,%esp
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 08             	sub    $0x8,%esp
  800aad:	89 34 24             	mov    %esi,(%esp)
  800ab0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aba:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800abd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac3:	75 13                	jne    800ad8 <memcpy+0x31>
  800ac5:	a8 03                	test   $0x3,%al
  800ac7:	75 0f                	jne    800ad8 <memcpy+0x31>
  800ac9:	f6 c1 03             	test   $0x3,%cl
  800acc:	75 0a                	jne    800ad8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ace:	c1 e9 02             	shr    $0x2,%ecx
  800ad1:	89 c7                	mov    %eax,%edi
  800ad3:	fc                   	cld    
  800ad4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad6:	eb 05                	jmp    800add <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800ad8:	89 c7                	mov    %eax,%edi
  800ada:	fc                   	cld    
  800adb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800add:	8b 34 24             	mov    (%esp),%esi
  800ae0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ae4:	89 ec                	mov    %ebp,%esp
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	57                   	push   %edi
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
  800aee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800af1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800af7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800afc:	85 ff                	test   %edi,%edi
  800afe:	74 38                	je     800b38 <memcmp+0x50>
		if (*s1 != *s2)
  800b00:	0f b6 03             	movzbl (%ebx),%eax
  800b03:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b06:	83 ef 01             	sub    $0x1,%edi
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b0e:	38 c8                	cmp    %cl,%al
  800b10:	74 1d                	je     800b2f <memcmp+0x47>
  800b12:	eb 11                	jmp    800b25 <memcmp+0x3d>
  800b14:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b19:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800b1e:	83 c2 01             	add    $0x1,%edx
  800b21:	38 c8                	cmp    %cl,%al
  800b23:	74 0a                	je     800b2f <memcmp+0x47>
			return *s1 - *s2;
  800b25:	0f b6 c0             	movzbl %al,%eax
  800b28:	0f b6 c9             	movzbl %cl,%ecx
  800b2b:	29 c8                	sub    %ecx,%eax
  800b2d:	eb 09                	jmp    800b38 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b2f:	39 fa                	cmp    %edi,%edx
  800b31:	75 e1                	jne    800b14 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	53                   	push   %ebx
  800b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800b44:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800b46:	89 da                	mov    %ebx,%edx
  800b48:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800b4b:	39 d3                	cmp    %edx,%ebx
  800b4d:	73 15                	jae    800b64 <memfind+0x27>
		if (*s == (unsigned char) c)
  800b4f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b53:	38 0b                	cmp    %cl,(%ebx)
  800b55:	75 06                	jne    800b5d <memfind+0x20>
  800b57:	eb 0b                	jmp    800b64 <memfind+0x27>
  800b59:	38 08                	cmp    %cl,(%eax)
  800b5b:	74 07                	je     800b64 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800b5d:	83 c0 01             	add    $0x1,%eax
  800b60:	39 c2                	cmp    %eax,%edx
  800b62:	77 f5                	ja     800b59 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b64:	5b                   	pop    %ebx
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	57                   	push   %edi
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b70:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b73:	0f b6 02             	movzbl (%edx),%eax
  800b76:	3c 20                	cmp    $0x20,%al
  800b78:	74 04                	je     800b7e <_Z6strtolPKcPPci+0x17>
  800b7a:	3c 09                	cmp    $0x9,%al
  800b7c:	75 0e                	jne    800b8c <_Z6strtolPKcPPci+0x25>
		s++;
  800b7e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b81:	0f b6 02             	movzbl (%edx),%eax
  800b84:	3c 20                	cmp    $0x20,%al
  800b86:	74 f6                	je     800b7e <_Z6strtolPKcPPci+0x17>
  800b88:	3c 09                	cmp    $0x9,%al
  800b8a:	74 f2                	je     800b7e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b8c:	3c 2b                	cmp    $0x2b,%al
  800b8e:	75 0a                	jne    800b9a <_Z6strtolPKcPPci+0x33>
		s++;
  800b90:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b93:	bf 00 00 00 00       	mov    $0x0,%edi
  800b98:	eb 10                	jmp    800baa <_Z6strtolPKcPPci+0x43>
  800b9a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b9f:	3c 2d                	cmp    $0x2d,%al
  800ba1:	75 07                	jne    800baa <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800ba3:	83 c2 01             	add    $0x1,%edx
  800ba6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800baa:	85 db                	test   %ebx,%ebx
  800bac:	0f 94 c0             	sete   %al
  800baf:	74 05                	je     800bb6 <_Z6strtolPKcPPci+0x4f>
  800bb1:	83 fb 10             	cmp    $0x10,%ebx
  800bb4:	75 15                	jne    800bcb <_Z6strtolPKcPPci+0x64>
  800bb6:	80 3a 30             	cmpb   $0x30,(%edx)
  800bb9:	75 10                	jne    800bcb <_Z6strtolPKcPPci+0x64>
  800bbb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bbf:	75 0a                	jne    800bcb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800bc1:	83 c2 02             	add    $0x2,%edx
  800bc4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc9:	eb 13                	jmp    800bde <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800bcb:	84 c0                	test   %al,%al
  800bcd:	74 0f                	je     800bde <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bcf:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bd4:	80 3a 30             	cmpb   $0x30,(%edx)
  800bd7:	75 05                	jne    800bde <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800bd9:	83 c2 01             	add    $0x1,%edx
  800bdc:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800bde:	b8 00 00 00 00       	mov    $0x0,%eax
  800be3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800be5:	0f b6 0a             	movzbl (%edx),%ecx
  800be8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800beb:	80 fb 09             	cmp    $0x9,%bl
  800bee:	77 08                	ja     800bf8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800bf0:	0f be c9             	movsbl %cl,%ecx
  800bf3:	83 e9 30             	sub    $0x30,%ecx
  800bf6:	eb 1e                	jmp    800c16 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800bf8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800bfb:	80 fb 19             	cmp    $0x19,%bl
  800bfe:	77 08                	ja     800c08 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800c00:	0f be c9             	movsbl %cl,%ecx
  800c03:	83 e9 57             	sub    $0x57,%ecx
  800c06:	eb 0e                	jmp    800c16 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c08:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c0b:	80 fb 19             	cmp    $0x19,%bl
  800c0e:	77 15                	ja     800c25 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800c10:	0f be c9             	movsbl %cl,%ecx
  800c13:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c16:	39 f1                	cmp    %esi,%ecx
  800c18:	7d 0f                	jge    800c29 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800c1a:	83 c2 01             	add    $0x1,%edx
  800c1d:	0f af c6             	imul   %esi,%eax
  800c20:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800c23:	eb c0                	jmp    800be5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c25:	89 c1                	mov    %eax,%ecx
  800c27:	eb 02                	jmp    800c2b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c29:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2f:	74 05                	je     800c36 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800c31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c34:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c36:	89 ca                	mov    %ecx,%edx
  800c38:	f7 da                	neg    %edx
  800c3a:	85 ff                	test   %edi,%edi
  800c3c:	0f 45 c2             	cmovne %edx,%eax
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 0c             	sub    $0xc,%esp
  800c4a:	89 1c 24             	mov    %ebx,(%esp)
  800c4d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c51:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c55:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c60:	89 c3                	mov    %eax,%ebx
  800c62:	89 c7                	mov    %eax,%edi
  800c64:	89 c6                	mov    %eax,%esi
  800c66:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c68:	8b 1c 24             	mov    (%esp),%ebx
  800c6b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c6f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c73:	89 ec                	mov    %ebp,%esp
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	83 ec 0c             	sub    $0xc,%esp
  800c7d:	89 1c 24             	mov    %ebx,(%esp)
  800c80:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c84:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c88:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c92:	89 d1                	mov    %edx,%ecx
  800c94:	89 d3                	mov    %edx,%ebx
  800c96:	89 d7                	mov    %edx,%edi
  800c98:	89 d6                	mov    %edx,%esi
  800c9a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c9c:	8b 1c 24             	mov    (%esp),%ebx
  800c9f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ca3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ca7:	89 ec                	mov    %ebp,%esp
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 38             	sub    $0x38,%esp
  800cb1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cb4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cb7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800cba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbf:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc7:	89 cb                	mov    %ecx,%ebx
  800cc9:	89 cf                	mov    %ecx,%edi
  800ccb:	89 ce                	mov    %ecx,%esi
  800ccd:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7e 28                	jle    800cfb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cd7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cde:	00 
  800cdf:	c7 44 24 08 d4 4e 80 	movl   $0x804ed4,0x8(%esp)
  800ce6:	00 
  800ce7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cee:	00 
  800cef:	c7 04 24 f1 4e 80 00 	movl   $0x804ef1,(%esp)
  800cf6:	e8 59 f4 ff ff       	call   800154 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cfb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cfe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d01:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d04:	89 ec                	mov    %ebp,%esp
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 0c             	sub    $0xc,%esp
  800d0e:	89 1c 24             	mov    %ebx,(%esp)
  800d11:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d15:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d19:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1e:	b8 02 00 00 00       	mov    $0x2,%eax
  800d23:	89 d1                	mov    %edx,%ecx
  800d25:	89 d3                	mov    %edx,%ebx
  800d27:	89 d7                	mov    %edx,%edi
  800d29:	89 d6                	mov    %edx,%esi
  800d2b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d2d:	8b 1c 24             	mov    (%esp),%ebx
  800d30:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d38:	89 ec                	mov    %ebp,%esp
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	89 1c 24             	mov    %ebx,(%esp)
  800d45:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d49:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d52:	b8 04 00 00 00       	mov    $0x4,%eax
  800d57:	89 d1                	mov    %edx,%ecx
  800d59:	89 d3                	mov    %edx,%ebx
  800d5b:	89 d7                	mov    %edx,%edi
  800d5d:	89 d6                	mov    %edx,%esi
  800d5f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d61:	8b 1c 24             	mov    (%esp),%ebx
  800d64:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d68:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d6c:	89 ec                	mov    %ebp,%esp
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 38             	sub    $0x38,%esp
  800d76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d79:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d7c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d7f:	be 00 00 00 00       	mov    $0x0,%esi
  800d84:	b8 08 00 00 00       	mov    $0x8,%eax
  800d89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	89 f7                	mov    %esi,%edi
  800d94:	cd 30                	int    $0x30

	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7e 28                	jle    800dc2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d9e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800da5:	00 
  800da6:	c7 44 24 08 d4 4e 80 	movl   $0x804ed4,0x8(%esp)
  800dad:	00 
  800dae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db5:	00 
  800db6:	c7 04 24 f1 4e 80 00 	movl   $0x804ef1,(%esp)
  800dbd:	e8 92 f3 ff ff       	call   800154 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dc2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dc5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dc8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dcb:	89 ec                	mov    %ebp,%esp
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 38             	sub    $0x38,%esp
  800dd5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dd8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ddb:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dde:	b8 09 00 00 00       	mov    $0x9,%eax
  800de3:	8b 75 18             	mov    0x18(%ebp),%esi
  800de6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	cd 30                	int    $0x30

	if(check && ret > 0)
  800df4:	85 c0                	test   %eax,%eax
  800df6:	7e 28                	jle    800e20 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dfc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e03:	00 
  800e04:	c7 44 24 08 d4 4e 80 	movl   $0x804ed4,0x8(%esp)
  800e0b:	00 
  800e0c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e13:	00 
  800e14:	c7 04 24 f1 4e 80 00 	movl   $0x804ef1,(%esp)
  800e1b:	e8 34 f3 ff ff       	call   800154 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e20:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e23:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e26:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e29:	89 ec                	mov    %ebp,%esp
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 38             	sub    $0x38,%esp
  800e33:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e36:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e39:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7e 28                	jle    800e7e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e61:	00 
  800e62:	c7 44 24 08 d4 4e 80 	movl   $0x804ed4,0x8(%esp)
  800e69:	00 
  800e6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e71:	00 
  800e72:	c7 04 24 f1 4e 80 00 	movl   $0x804ef1,(%esp)
  800e79:	e8 d6 f2 ff ff       	call   800154 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e7e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e81:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e84:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e87:	89 ec                	mov    %ebp,%esp
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 38             	sub    $0x38,%esp
  800e91:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e94:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e97:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9f:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	89 df                	mov    %ebx,%edi
  800eac:	89 de                	mov    %ebx,%esi
  800eae:	cd 30                	int    $0x30

	if(check && ret > 0)
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	7e 28                	jle    800edc <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ebf:	00 
  800ec0:	c7 44 24 08 d4 4e 80 	movl   $0x804ed4,0x8(%esp)
  800ec7:	00 
  800ec8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ecf:	00 
  800ed0:	c7 04 24 f1 4e 80 00 	movl   $0x804ef1,(%esp)
  800ed7:	e8 78 f2 ff ff       	call   800154 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800edc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800edf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ee2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ee5:	89 ec                	mov    %ebp,%esp
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 38             	sub    $0x38,%esp
  800eef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ef2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ef5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ef8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efd:	b8 06 00 00 00       	mov    $0x6,%eax
  800f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	89 df                	mov    %ebx,%edi
  800f0a:	89 de                	mov    %ebx,%esi
  800f0c:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	7e 28                	jle    800f3a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f12:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f16:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f1d:	00 
  800f1e:	c7 44 24 08 d4 4e 80 	movl   $0x804ed4,0x8(%esp)
  800f25:	00 
  800f26:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f2d:	00 
  800f2e:	c7 04 24 f1 4e 80 00 	movl   $0x804ef1,(%esp)
  800f35:	e8 1a f2 ff ff       	call   800154 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800f3a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f3d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f40:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f43:	89 ec                	mov    %ebp,%esp
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 38             	sub    $0x38,%esp
  800f4d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f50:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f53:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	89 df                	mov    %ebx,%edi
  800f68:	89 de                	mov    %ebx,%esi
  800f6a:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	7e 28                	jle    800f98 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f70:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f74:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f7b:	00 
  800f7c:	c7 44 24 08 d4 4e 80 	movl   $0x804ed4,0x8(%esp)
  800f83:	00 
  800f84:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f8b:	00 
  800f8c:	c7 04 24 f1 4e 80 00 	movl   $0x804ef1,(%esp)
  800f93:	e8 bc f1 ff ff       	call   800154 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f98:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f9b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f9e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fa1:	89 ec                	mov    %ebp,%esp
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 38             	sub    $0x38,%esp
  800fab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fb1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc4:	89 df                	mov    %ebx,%edi
  800fc6:	89 de                	mov    %ebx,%esi
  800fc8:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	7e 28                	jle    800ff6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fce:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  800fd9:	00 
  800fda:	c7 44 24 08 d4 4e 80 	movl   $0x804ed4,0x8(%esp)
  800fe1:	00 
  800fe2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe9:	00 
  800fea:	c7 04 24 f1 4e 80 00 	movl   $0x804ef1,(%esp)
  800ff1:	e8 5e f1 ff ff       	call   800154 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ff9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ffc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fff:	89 ec                	mov    %ebp,%esp
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	89 1c 24             	mov    %ebx,(%esp)
  80100c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801010:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801014:	be 00 00 00 00       	mov    $0x0,%esi
  801019:	b8 0d 00 00 00       	mov    $0xd,%eax
  80101e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801021:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801024:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801027:	8b 55 08             	mov    0x8(%ebp),%edx
  80102a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80102c:	8b 1c 24             	mov    (%esp),%ebx
  80102f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801033:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801037:	89 ec                	mov    %ebp,%esp
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 38             	sub    $0x38,%esp
  801041:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801044:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801047:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80104a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	89 cb                	mov    %ecx,%ebx
  801059:	89 cf                	mov    %ecx,%edi
  80105b:	89 ce                	mov    %ecx,%esi
  80105d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80105f:	85 c0                	test   %eax,%eax
  801061:	7e 28                	jle    80108b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801063:	89 44 24 10          	mov    %eax,0x10(%esp)
  801067:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80106e:	00 
  80106f:	c7 44 24 08 d4 4e 80 	movl   $0x804ed4,0x8(%esp)
  801076:	00 
  801077:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80107e:	00 
  80107f:	c7 04 24 f1 4e 80 00 	movl   $0x804ef1,(%esp)
  801086:	e8 c9 f0 ff ff       	call   800154 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80108b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80108e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801091:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801094:	89 ec                	mov    %ebp,%esp
  801096:	5d                   	pop    %ebp
  801097:	c3                   	ret    

00801098 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 0c             	sub    $0xc,%esp
  80109e:	89 1c 24             	mov    %ebx,(%esp)
  8010a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010a5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ae:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	89 df                	mov    %ebx,%edi
  8010bb:	89 de                	mov    %ebx,%esi
  8010bd:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8010bf:	8b 1c 24             	mov    (%esp),%ebx
  8010c2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010c6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ca:	89 ec                	mov    %ebp,%esp
  8010cc:	5d                   	pop    %ebp
  8010cd:	c3                   	ret    

008010ce <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	83 ec 0c             	sub    $0xc,%esp
  8010d4:	89 1c 24             	mov    %ebx,(%esp)
  8010d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010db:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010df:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e4:	b8 11 00 00 00       	mov    $0x11,%eax
  8010e9:	89 d1                	mov    %edx,%ecx
  8010eb:	89 d3                	mov    %edx,%ebx
  8010ed:	89 d7                	mov    %edx,%edi
  8010ef:	89 d6                	mov    %edx,%esi
  8010f1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010f3:	8b 1c 24             	mov    (%esp),%ebx
  8010f6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010fa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010fe:	89 ec                	mov    %ebp,%esp
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    

00801102 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	89 1c 24             	mov    %ebx,(%esp)
  80110b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80110f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801113:	bb 00 00 00 00       	mov    $0x0,%ebx
  801118:	b8 12 00 00 00       	mov    $0x12,%eax
  80111d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801120:	8b 55 08             	mov    0x8(%ebp),%edx
  801123:	89 df                	mov    %ebx,%edi
  801125:	89 de                	mov    %ebx,%esi
  801127:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801129:	8b 1c 24             	mov    (%esp),%ebx
  80112c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801130:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801134:	89 ec                	mov    %ebp,%esp
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 0c             	sub    $0xc,%esp
  80113e:	89 1c 24             	mov    %ebx,(%esp)
  801141:	89 74 24 04          	mov    %esi,0x4(%esp)
  801145:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801149:	b9 00 00 00 00       	mov    $0x0,%ecx
  80114e:	b8 13 00 00 00       	mov    $0x13,%eax
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	89 cb                	mov    %ecx,%ebx
  801158:	89 cf                	mov    %ecx,%edi
  80115a:	89 ce                	mov    %ecx,%esi
  80115c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80115e:	8b 1c 24             	mov    (%esp),%ebx
  801161:	8b 74 24 04          	mov    0x4(%esp),%esi
  801165:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801169:	89 ec                	mov    %ebp,%esp
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	89 1c 24             	mov    %ebx,(%esp)
  801176:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80117e:	b8 10 00 00 00       	mov    $0x10,%eax
  801183:	8b 75 18             	mov    0x18(%ebp),%esi
  801186:	8b 7d 14             	mov    0x14(%ebp),%edi
  801189:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80118c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801194:	8b 1c 24             	mov    (%esp),%ebx
  801197:	8b 74 24 04          	mov    0x4(%esp),%esi
  80119b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80119f:	89 ec                	mov    %ebp,%esp
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    
	...

008011b0 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8011b3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8011b8:	75 11                	jne    8011cb <_ZL8fd_validPK2Fd+0x1b>
  8011ba:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  8011bf:	76 0a                	jbe    8011cb <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  8011c1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  8011c6:	0f 96 c0             	setbe  %al
  8011c9:	eb 05                	jmp    8011d0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8011cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    

008011d2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 14             	sub    $0x14,%esp
  8011d9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8011db:	e8 d0 ff ff ff       	call   8011b0 <_ZL8fd_validPK2Fd>
  8011e0:	84 c0                	test   %al,%al
  8011e2:	75 24                	jne    801208 <_ZL9fd_isopenPK2Fd+0x36>
  8011e4:	c7 44 24 0c ff 4e 80 	movl   $0x804eff,0xc(%esp)
  8011eb:	00 
  8011ec:	c7 44 24 08 0a 4b 80 	movl   $0x804b0a,0x8(%esp)
  8011f3:	00 
  8011f4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8011fb:	00 
  8011fc:	c7 04 24 0c 4f 80 00 	movl   $0x804f0c,(%esp)
  801203:	e8 4c ef ff ff       	call   800154 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801208:	89 d8                	mov    %ebx,%eax
  80120a:	c1 e8 16             	shr    $0x16,%eax
  80120d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801214:	b8 00 00 00 00       	mov    $0x0,%eax
  801219:	f6 c2 01             	test   $0x1,%dl
  80121c:	74 0d                	je     80122b <_ZL9fd_isopenPK2Fd+0x59>
  80121e:	c1 eb 0c             	shr    $0xc,%ebx
  801221:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801228:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80122b:	83 c4 14             	add    $0x14,%esp
  80122e:	5b                   	pop    %ebx
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    

00801231 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	89 1c 24             	mov    %ebx,(%esp)
  80123a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80123e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801241:	8b 75 0c             	mov    0xc(%ebp),%esi
  801244:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801248:	83 fb 1f             	cmp    $0x1f,%ebx
  80124b:	77 18                	ja     801265 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80124d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801253:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801256:	84 c0                	test   %al,%al
  801258:	74 21                	je     80127b <_Z9fd_lookupiPP2Fdb+0x4a>
  80125a:	89 d8                	mov    %ebx,%eax
  80125c:	e8 71 ff ff ff       	call   8011d2 <_ZL9fd_isopenPK2Fd>
  801261:	84 c0                	test   %al,%al
  801263:	75 16                	jne    80127b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801265:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80126b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801270:	8b 1c 24             	mov    (%esp),%ebx
  801273:	8b 74 24 04          	mov    0x4(%esp),%esi
  801277:	89 ec                	mov    %ebp,%esp
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80127b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80127d:	b8 00 00 00 00       	mov    $0x0,%eax
  801282:	eb ec                	jmp    801270 <_Z9fd_lookupiPP2Fdb+0x3f>

00801284 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	53                   	push   %ebx
  801288:	83 ec 14             	sub    $0x14,%esp
  80128b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80128e:	89 d8                	mov    %ebx,%eax
  801290:	e8 1b ff ff ff       	call   8011b0 <_ZL8fd_validPK2Fd>
  801295:	84 c0                	test   %al,%al
  801297:	75 24                	jne    8012bd <_Z6fd2numP2Fd+0x39>
  801299:	c7 44 24 0c ff 4e 80 	movl   $0x804eff,0xc(%esp)
  8012a0:	00 
  8012a1:	c7 44 24 08 0a 4b 80 	movl   $0x804b0a,0x8(%esp)
  8012a8:	00 
  8012a9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8012b0:	00 
  8012b1:	c7 04 24 0c 4f 80 00 	movl   $0x804f0c,(%esp)
  8012b8:	e8 97 ee ff ff       	call   800154 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bd:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  8012c3:	c1 e8 0c             	shr    $0xc,%eax
}
  8012c6:	83 c4 14             	add    $0x14,%esp
  8012c9:	5b                   	pop    %ebx
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	89 04 24             	mov    %eax,(%esp)
  8012d8:	e8 a7 ff ff ff       	call   801284 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8012dd:	05 20 00 0d 00       	add    $0xd0020,%eax
  8012e2:	c1 e0 0c             	shl    $0xc,%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	57                   	push   %edi
  8012eb:	56                   	push   %esi
  8012ec:	53                   	push   %ebx
  8012ed:	83 ec 2c             	sub    $0x2c,%esp
  8012f0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8012f3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8012f8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8012fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801302:	00 
  801303:	89 74 24 04          	mov    %esi,0x4(%esp)
  801307:	89 1c 24             	mov    %ebx,(%esp)
  80130a:	e8 22 ff ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80130f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801312:	e8 bb fe ff ff       	call   8011d2 <_ZL9fd_isopenPK2Fd>
  801317:	84 c0                	test   %al,%al
  801319:	75 0c                	jne    801327 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80131b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80131e:	89 07                	mov    %eax,(%edi)
			return 0;
  801320:	b8 00 00 00 00       	mov    $0x0,%eax
  801325:	eb 13                	jmp    80133a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801327:	83 c3 01             	add    $0x1,%ebx
  80132a:	83 fb 20             	cmp    $0x20,%ebx
  80132d:	75 cc                	jne    8012fb <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80132f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801335:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80133a:	83 c4 2c             	add    $0x2c,%esp
  80133d:	5b                   	pop    %ebx
  80133e:	5e                   	pop    %esi
  80133f:	5f                   	pop    %edi
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	53                   	push   %ebx
  801346:	83 ec 14             	sub    $0x14,%esp
  801349:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80134f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801354:	39 0d 04 60 80 00    	cmp    %ecx,0x806004
  80135a:	75 16                	jne    801372 <_Z10dev_lookupiPP3Dev+0x30>
  80135c:	eb 06                	jmp    801364 <_Z10dev_lookupiPP3Dev+0x22>
  80135e:	39 0a                	cmp    %ecx,(%edx)
  801360:	75 10                	jne    801372 <_Z10dev_lookupiPP3Dev+0x30>
  801362:	eb 05                	jmp    801369 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801364:	ba 04 60 80 00       	mov    $0x806004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801369:	89 13                	mov    %edx,(%ebx)
			return 0;
  80136b:	b8 00 00 00 00       	mov    $0x0,%eax
  801370:	eb 35                	jmp    8013a7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801372:	83 c0 01             	add    $0x1,%eax
  801375:	8b 14 85 78 4f 80 00 	mov    0x804f78(,%eax,4),%edx
  80137c:	85 d2                	test   %edx,%edx
  80137e:	75 de                	jne    80135e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801380:	a1 00 70 80 00       	mov    0x807000,%eax
  801385:	8b 40 04             	mov    0x4(%eax),%eax
  801388:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80138c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801390:	c7 04 24 34 4f 80 00 	movl   $0x804f34,(%esp)
  801397:	e8 d6 ee ff ff       	call   800272 <_Z7cprintfPKcz>
	*dev = 0;
  80139c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8013a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013a7:	83 c4 14             	add    $0x14,%esp
  8013aa:	5b                   	pop    %ebx
  8013ab:	5d                   	pop    %ebp
  8013ac:	c3                   	ret    

008013ad <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	56                   	push   %esi
  8013b1:	53                   	push   %ebx
  8013b2:	83 ec 20             	sub    $0x20,%esp
  8013b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8013b8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  8013bc:	89 34 24             	mov    %esi,(%esp)
  8013bf:	e8 c0 fe ff ff       	call   801284 <_Z6fd2numP2Fd>
  8013c4:	0f b6 d3             	movzbl %bl,%edx
  8013c7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013cb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8013ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013d2:	89 04 24             	mov    %eax,(%esp)
  8013d5:	e8 57 fe ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 05                	js     8013e3 <_Z8fd_closeP2Fdb+0x36>
  8013de:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8013e1:	74 0c                	je     8013ef <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  8013e3:	80 fb 01             	cmp    $0x1,%bl
  8013e6:	19 db                	sbb    %ebx,%ebx
  8013e8:	f7 d3                	not    %ebx
  8013ea:	83 e3 fd             	and    $0xfffffffd,%ebx
  8013ed:	eb 3d                	jmp    80142c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f6:	8b 06                	mov    (%esi),%eax
  8013f8:	89 04 24             	mov    %eax,(%esp)
  8013fb:	e8 42 ff ff ff       	call   801342 <_Z10dev_lookupiPP3Dev>
  801400:	89 c3                	mov    %eax,%ebx
  801402:	85 c0                	test   %eax,%eax
  801404:	78 16                	js     80141c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801409:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80140c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801411:	85 c0                	test   %eax,%eax
  801413:	74 07                	je     80141c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801415:	89 34 24             	mov    %esi,(%esp)
  801418:	ff d0                	call   *%eax
  80141a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80141c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801420:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801427:	e8 01 fa ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
	return r;
}
  80142c:	89 d8                	mov    %ebx,%eax
  80142e:	83 c4 20             	add    $0x20,%esp
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    

00801435 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80143b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801442:	00 
  801443:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	89 04 24             	mov    %eax,(%esp)
  801450:	e8 dc fd ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  801455:	85 c0                	test   %eax,%eax
  801457:	78 13                	js     80146c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801459:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801460:	00 
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	89 04 24             	mov    %eax,(%esp)
  801467:	e8 41 ff ff ff       	call   8013ad <_Z8fd_closeP2Fdb>
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <_Z9close_allv>:

void
close_all(void)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	53                   	push   %ebx
  801472:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801475:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80147a:	89 1c 24             	mov    %ebx,(%esp)
  80147d:	e8 b3 ff ff ff       	call   801435 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801482:	83 c3 01             	add    $0x1,%ebx
  801485:	83 fb 20             	cmp    $0x20,%ebx
  801488:	75 f0                	jne    80147a <_Z9close_allv+0xc>
		close(i);
}
  80148a:	83 c4 14             	add    $0x14,%esp
  80148d:	5b                   	pop    %ebx
  80148e:	5d                   	pop    %ebp
  80148f:	c3                   	ret    

00801490 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 48             	sub    $0x48,%esp
  801496:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801499:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80149c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80149f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8014a2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8014a9:	00 
  8014aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	89 04 24             	mov    %eax,(%esp)
  8014b7:	e8 75 fd ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  8014bc:	89 c3                	mov    %eax,%ebx
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	0f 88 ce 00 00 00    	js     801594 <_Z3dupii+0x104>
  8014c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014cd:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  8014ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014d1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8014d5:	89 34 24             	mov    %esi,(%esp)
  8014d8:	e8 54 fd ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  8014dd:	89 c3                	mov    %eax,%ebx
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	0f 89 bc 00 00 00    	jns    8015a3 <_Z3dupii+0x113>
  8014e7:	e9 a8 00 00 00       	jmp    801594 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8014ec:	89 d8                	mov    %ebx,%eax
  8014ee:	c1 e8 0c             	shr    $0xc,%eax
  8014f1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8014f8:	f6 c2 01             	test   $0x1,%dl
  8014fb:	74 32                	je     80152f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014fd:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801504:	25 07 0e 00 00       	and    $0xe07,%eax
  801509:	89 44 24 10          	mov    %eax,0x10(%esp)
  80150d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801511:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801518:	00 
  801519:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80151d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801524:	e8 a6 f8 ff ff       	call   800dcf <_Z12sys_page_mapiPviS_i>
  801529:	89 c3                	mov    %eax,%ebx
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 3e                	js     80156d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80152f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801532:	89 c2                	mov    %eax,%edx
  801534:	c1 ea 0c             	shr    $0xc,%edx
  801537:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80153e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801544:	89 54 24 10          	mov    %edx,0x10(%esp)
  801548:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80154b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80154f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801556:	00 
  801557:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801562:	e8 68 f8 ff ff       	call   800dcf <_Z12sys_page_mapiPviS_i>
  801567:	89 c3                	mov    %eax,%ebx
  801569:	85 c0                	test   %eax,%eax
  80156b:	79 25                	jns    801592 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80156d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801570:	89 44 24 04          	mov    %eax,0x4(%esp)
  801574:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80157b:	e8 ad f8 ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801580:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80158b:	e8 9d f8 ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
	return r;
  801590:	eb 02                	jmp    801594 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801592:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801594:	89 d8                	mov    %ebx,%eax
  801596:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801599:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80159c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80159f:	89 ec                	mov    %ebp,%esp
  8015a1:	5d                   	pop    %ebp
  8015a2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  8015a3:	89 34 24             	mov    %esi,(%esp)
  8015a6:	e8 8a fe ff ff       	call   801435 <_Z5closei>

	ova = fd2data(oldfd);
  8015ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ae:	89 04 24             	mov    %eax,(%esp)
  8015b1:	e8 16 fd ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  8015b6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015bb:	89 04 24             	mov    %eax,(%esp)
  8015be:	e8 09 fd ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  8015c3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8015c5:	89 d8                	mov    %ebx,%eax
  8015c7:	c1 e8 16             	shr    $0x16,%eax
  8015ca:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8015d1:	a8 01                	test   $0x1,%al
  8015d3:	0f 85 13 ff ff ff    	jne    8014ec <_Z3dupii+0x5c>
  8015d9:	e9 51 ff ff ff       	jmp    80152f <_Z3dupii+0x9f>

008015de <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	53                   	push   %ebx
  8015e2:	83 ec 24             	sub    $0x24,%esp
  8015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8015e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8015ef:	00 
  8015f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f7:	89 1c 24             	mov    %ebx,(%esp)
  8015fa:	e8 32 fc ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 5f                	js     801662 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801603:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801606:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80160d:	8b 00                	mov    (%eax),%eax
  80160f:	89 04 24             	mov    %eax,(%esp)
  801612:	e8 2b fd ff ff       	call   801342 <_Z10dev_lookupiPP3Dev>
  801617:	85 c0                	test   %eax,%eax
  801619:	79 4d                	jns    801668 <_Z4readiPvj+0x8a>
  80161b:	eb 45                	jmp    801662 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80161d:	a1 00 70 80 00       	mov    0x807000,%eax
  801622:	8b 40 04             	mov    0x4(%eax),%eax
  801625:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801629:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162d:	c7 04 24 15 4f 80 00 	movl   $0x804f15,(%esp)
  801634:	e8 39 ec ff ff       	call   800272 <_Z7cprintfPKcz>
		return -E_INVAL;
  801639:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80163e:	eb 22                	jmp    801662 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801643:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801646:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80164b:	85 d2                	test   %edx,%edx
  80164d:	74 13                	je     801662 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80164f:	8b 45 10             	mov    0x10(%ebp),%eax
  801652:	89 44 24 08          	mov    %eax,0x8(%esp)
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165d:	89 0c 24             	mov    %ecx,(%esp)
  801660:	ff d2                	call   *%edx
}
  801662:	83 c4 24             	add    $0x24,%esp
  801665:	5b                   	pop    %ebx
  801666:	5d                   	pop    %ebp
  801667:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801668:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80166b:	8b 41 08             	mov    0x8(%ecx),%eax
  80166e:	83 e0 03             	and    $0x3,%eax
  801671:	83 f8 01             	cmp    $0x1,%eax
  801674:	75 ca                	jne    801640 <_Z4readiPvj+0x62>
  801676:	eb a5                	jmp    80161d <_Z4readiPvj+0x3f>

00801678 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	57                   	push   %edi
  80167c:	56                   	push   %esi
  80167d:	53                   	push   %ebx
  80167e:	83 ec 1c             	sub    $0x1c,%esp
  801681:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801684:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801687:	85 f6                	test   %esi,%esi
  801689:	74 2f                	je     8016ba <_Z5readniPvj+0x42>
  80168b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801690:	89 f0                	mov    %esi,%eax
  801692:	29 d8                	sub    %ebx,%eax
  801694:	89 44 24 08          	mov    %eax,0x8(%esp)
  801698:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80169b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	89 04 24             	mov    %eax,(%esp)
  8016a5:	e8 34 ff ff ff       	call   8015de <_Z4readiPvj>
		if (m < 0)
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 13                	js     8016c1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	74 0d                	je     8016bf <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8016b2:	01 c3                	add    %eax,%ebx
  8016b4:	39 de                	cmp    %ebx,%esi
  8016b6:	77 d8                	ja     801690 <_Z5readniPvj+0x18>
  8016b8:	eb 05                	jmp    8016bf <_Z5readniPvj+0x47>
  8016ba:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8016bf:	89 d8                	mov    %ebx,%eax
}
  8016c1:	83 c4 1c             	add    $0x1c,%esp
  8016c4:	5b                   	pop    %ebx
  8016c5:	5e                   	pop    %esi
  8016c6:	5f                   	pop    %edi
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016cf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8016d6:	00 
  8016d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	89 04 24             	mov    %eax,(%esp)
  8016e4:	e8 48 fb ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	78 3c                	js     801729 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	89 04 24             	mov    %eax,(%esp)
  8016fc:	e8 41 fc ff ff       	call   801342 <_Z10dev_lookupiPP3Dev>
  801701:	85 c0                	test   %eax,%eax
  801703:	79 26                	jns    80172b <_Z5writeiPKvj+0x62>
  801705:	eb 22                	jmp    801729 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  80170d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801712:	85 c9                	test   %ecx,%ecx
  801714:	74 13                	je     801729 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801716:	8b 45 10             	mov    0x10(%ebp),%eax
  801719:	89 44 24 08          	mov    %eax,0x8(%esp)
  80171d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801720:	89 44 24 04          	mov    %eax,0x4(%esp)
  801724:	89 14 24             	mov    %edx,(%esp)
  801727:	ff d1                	call   *%ecx
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80172b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80172e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801733:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801737:	74 f0                	je     801729 <_Z5writeiPKvj+0x60>
  801739:	eb cc                	jmp    801707 <_Z5writeiPKvj+0x3e>

0080173b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801741:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801748:	00 
  801749:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	89 04 24             	mov    %eax,(%esp)
  801756:	e8 d6 fa ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  80175b:	85 c0                	test   %eax,%eax
  80175d:	78 0e                	js     80176d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80175f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801762:	8b 55 0c             	mov    0xc(%ebp),%edx
  801765:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801768:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	53                   	push   %ebx
  801773:	83 ec 24             	sub    $0x24,%esp
  801776:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801779:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801780:	00 
  801781:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801784:	89 44 24 04          	mov    %eax,0x4(%esp)
  801788:	89 1c 24             	mov    %ebx,(%esp)
  80178b:	e8 a1 fa ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  801790:	85 c0                	test   %eax,%eax
  801792:	78 58                	js     8017ec <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801794:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80179e:	8b 00                	mov    (%eax),%eax
  8017a0:	89 04 24             	mov    %eax,(%esp)
  8017a3:	e8 9a fb ff ff       	call   801342 <_Z10dev_lookupiPP3Dev>
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	79 46                	jns    8017f2 <_Z9ftruncateii+0x83>
  8017ac:	eb 3e                	jmp    8017ec <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ae:	a1 00 70 80 00       	mov    0x807000,%eax
  8017b3:	8b 40 04             	mov    0x4(%eax),%eax
  8017b6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017be:	c7 04 24 54 4f 80 00 	movl   $0x804f54,(%esp)
  8017c5:	e8 a8 ea ff ff       	call   800272 <_Z7cprintfPKcz>
		return -E_INVAL;
  8017ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017cf:	eb 1b                	jmp    8017ec <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8017d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8017d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017dc:	85 d2                	test   %edx,%edx
  8017de:	74 0c                	je     8017ec <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e7:	89 0c 24             	mov    %ecx,(%esp)
  8017ea:	ff d2                	call   *%edx
}
  8017ec:	83 c4 24             	add    $0x24,%esp
  8017ef:	5b                   	pop    %ebx
  8017f0:	5d                   	pop    %ebp
  8017f1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017f2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017f5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  8017f9:	75 d6                	jne    8017d1 <_Z9ftruncateii+0x62>
  8017fb:	eb b1                	jmp    8017ae <_Z9ftruncateii+0x3f>

008017fd <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	53                   	push   %ebx
  801801:	83 ec 24             	sub    $0x24,%esp
  801804:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801807:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80180e:	00 
  80180f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801812:	89 44 24 04          	mov    %eax,0x4(%esp)
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	89 04 24             	mov    %eax,(%esp)
  80181c:	e8 10 fa ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  801821:	85 c0                	test   %eax,%eax
  801823:	78 3e                	js     801863 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801825:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80182f:	8b 00                	mov    (%eax),%eax
  801831:	89 04 24             	mov    %eax,(%esp)
  801834:	e8 09 fb ff ff       	call   801342 <_Z10dev_lookupiPP3Dev>
  801839:	85 c0                	test   %eax,%eax
  80183b:	79 2c                	jns    801869 <_Z5fstatiP4Stat+0x6c>
  80183d:	eb 24                	jmp    801863 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80183f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801842:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801849:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801850:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801856:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	89 04 24             	mov    %eax,(%esp)
  801860:	ff 52 14             	call   *0x14(%edx)
}
  801863:	83 c4 24             	add    $0x24,%esp
  801866:	5b                   	pop    %ebx
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801869:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80186c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801871:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801875:	75 c8                	jne    80183f <_Z5fstatiP4Stat+0x42>
  801877:	eb ea                	jmp    801863 <_Z5fstatiP4Stat+0x66>

00801879 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 18             	sub    $0x18,%esp
  80187f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801882:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801885:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80188c:	00 
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	89 04 24             	mov    %eax,(%esp)
  801893:	e8 d6 09 00 00       	call   80226e <_Z4openPKci>
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	85 c0                	test   %eax,%eax
  80189c:	78 1b                	js     8018b9 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80189e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a5:	89 1c 24             	mov    %ebx,(%esp)
  8018a8:	e8 50 ff ff ff       	call   8017fd <_Z5fstatiP4Stat>
  8018ad:	89 c6                	mov    %eax,%esi
	close(fd);
  8018af:	89 1c 24             	mov    %ebx,(%esp)
  8018b2:	e8 7e fb ff ff       	call   801435 <_Z5closei>
	return r;
  8018b7:	89 f3                	mov    %esi,%ebx
}
  8018b9:	89 d8                	mov    %ebx,%eax
  8018bb:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8018be:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8018c1:	89 ec                	mov    %ebp,%esp
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    
	...

008018d0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8018d3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8018d8:	85 d2                	test   %edx,%edx
  8018da:	78 33                	js     80190f <_ZL10inode_dataP5Inodei+0x3f>
  8018dc:	3b 50 08             	cmp    0x8(%eax),%edx
  8018df:	7d 2e                	jge    80190f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  8018e1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8018e7:	85 d2                	test   %edx,%edx
  8018e9:	0f 49 ca             	cmovns %edx,%ecx
  8018ec:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  8018ef:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  8018f3:	c1 e1 0c             	shl    $0xc,%ecx
  8018f6:	89 d0                	mov    %edx,%eax
  8018f8:	c1 f8 1f             	sar    $0x1f,%eax
  8018fb:	c1 e8 14             	shr    $0x14,%eax
  8018fe:	01 c2                	add    %eax,%edx
  801900:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801906:	29 c2                	sub    %eax,%edx
  801908:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  80190f:	89 c8                	mov    %ecx,%eax
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    

00801913 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801916:	8b 48 08             	mov    0x8(%eax),%ecx
  801919:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  80191c:	8b 00                	mov    (%eax),%eax
  80191e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801921:	c7 82 80 00 00 00 04 	movl   $0x806004,0x80(%edx)
  801928:	60 80 00 
}
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    

0080192d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801933:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801939:	85 c0                	test   %eax,%eax
  80193b:	74 08                	je     801945 <_ZL9get_inodei+0x18>
  80193d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801943:	7e 20                	jle    801965 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801945:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801949:	c7 44 24 08 8c 4f 80 	movl   $0x804f8c,0x8(%esp)
  801950:	00 
  801951:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801958:	00 
  801959:	c7 04 24 a2 4f 80 00 	movl   $0x804fa2,(%esp)
  801960:	e8 ef e7 ff ff       	call   800154 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801965:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80196b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801971:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801977:	85 d2                	test   %edx,%edx
  801979:	0f 48 d1             	cmovs  %ecx,%edx
  80197c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  80197f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801986:	c1 e0 0c             	shl    $0xc,%eax
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801993:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801999:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  80199c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  8019a2:	76 20                	jbe    8019c4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  8019a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019a8:	c7 44 24 08 c8 4f 80 	movl   $0x804fc8,0x8(%esp)
  8019af:	00 
  8019b0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8019b7:	00 
  8019b8:	c7 04 24 a2 4f 80 00 	movl   $0x804fa2,(%esp)
  8019bf:	e8 90 e7 ff ff       	call   800154 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  8019c4:	83 fe 01             	cmp    $0x1,%esi
  8019c7:	7e 08                	jle    8019d1 <_ZL10bcache_ipcPvi+0x46>
  8019c9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  8019cf:	7d 12                	jge    8019e3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8019d1:	89 f3                	mov    %esi,%ebx
  8019d3:	c1 e3 04             	shl    $0x4,%ebx
  8019d6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8019d8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  8019de:	c1 e6 0c             	shl    $0xc,%esi
  8019e1:	eb 20                	jmp    801a03 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  8019e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019e7:	c7 44 24 08 f8 4f 80 	movl   $0x804ff8,0x8(%esp)
  8019ee:	00 
  8019ef:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8019f6:	00 
  8019f7:	c7 04 24 a2 4f 80 00 	movl   $0x804fa2,(%esp)
  8019fe:	e8 51 e7 ff ff       	call   800154 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801a03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a0a:	00 
  801a0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a12:	00 
  801a13:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a17:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801a1e:	e8 3c 2a 00 00       	call   80445f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801a23:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a2a:	00 
  801a2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a36:	e8 95 29 00 00       	call   8043d0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801a3b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801a3e:	74 c3                	je     801a03 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 28             	sub    $0x28,%esp
  801a4d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a50:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a53:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a56:	89 c7                	mov    %eax,%edi
  801a58:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801a5a:	c7 04 24 ed 1c 80 00 	movl   $0x801ced,(%esp)
  801a61:	e8 75 28 00 00       	call   8042db <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801a66:	89 f8                	mov    %edi,%eax
  801a68:	e8 c0 fe ff ff       	call   80192d <_ZL9get_inodei>
  801a6d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801a6f:	ba 02 00 00 00       	mov    $0x2,%edx
  801a74:	e8 12 ff ff ff       	call   80198b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	79 08                	jns    801a85 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801a7d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801a83:	eb 2e                	jmp    801ab3 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801a85:	85 c0                	test   %eax,%eax
  801a87:	75 1c                	jne    801aa5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801a89:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801a8f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801a96:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801a99:	ba 06 00 00 00       	mov    $0x6,%edx
  801a9e:	89 d8                	mov    %ebx,%eax
  801aa0:	e8 e6 fe ff ff       	call   80198b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801aa5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801aac:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801aae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ab6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ab9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801abc:	89 ec                	mov    %ebp,%esp
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    

00801ac0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	57                   	push   %edi
  801ac4:	56                   	push   %esi
  801ac5:	53                   	push   %ebx
  801ac6:	83 ec 2c             	sub    $0x2c,%esp
  801ac9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801acc:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801acf:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801ad4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801ada:	0f 87 3d 01 00 00    	ja     801c1d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801ae0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801ae3:	8b 42 08             	mov    0x8(%edx),%eax
  801ae6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801aec:	85 c0                	test   %eax,%eax
  801aee:	0f 49 f0             	cmovns %eax,%esi
  801af1:	c1 fe 0c             	sar    $0xc,%esi
  801af4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801af6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801af9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801aff:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801b02:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801b05:	0f 82 a6 00 00 00    	jb     801bb1 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801b0b:	39 fe                	cmp    %edi,%esi
  801b0d:	0f 8d f2 00 00 00    	jge    801c05 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801b13:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801b17:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801b1a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801b1d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801b20:	83 3e 00             	cmpl   $0x0,(%esi)
  801b23:	75 77                	jne    801b9c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801b25:	ba 02 00 00 00       	mov    $0x2,%edx
  801b2a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801b2f:	e8 57 fe ff ff       	call   80198b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801b34:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801b3a:	83 f9 02             	cmp    $0x2,%ecx
  801b3d:	7e 43                	jle    801b82 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801b3f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801b44:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801b49:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801b50:	74 29                	je     801b7b <_ZL14inode_set_sizeP5Inodej+0xbb>
  801b52:	e9 ce 00 00 00       	jmp    801c25 <_ZL14inode_set_sizeP5Inodej+0x165>
  801b57:	89 c7                	mov    %eax,%edi
  801b59:	0f b6 10             	movzbl (%eax),%edx
  801b5c:	83 c0 01             	add    $0x1,%eax
  801b5f:	84 d2                	test   %dl,%dl
  801b61:	74 18                	je     801b7b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801b63:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801b66:	ba 05 00 00 00       	mov    $0x5,%edx
  801b6b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801b70:	e8 16 fe ff ff       	call   80198b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801b75:	85 db                	test   %ebx,%ebx
  801b77:	79 1e                	jns    801b97 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801b79:	eb 07                	jmp    801b82 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801b7b:	83 c3 01             	add    $0x1,%ebx
  801b7e:	39 d9                	cmp    %ebx,%ecx
  801b80:	7f d5                	jg     801b57 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801b82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b85:	8b 50 08             	mov    0x8(%eax),%edx
  801b88:	e8 33 ff ff ff       	call   801ac0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801b8d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801b92:	e9 86 00 00 00       	jmp    801c1d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801b97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b9a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801b9c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801ba0:	83 c6 04             	add    $0x4,%esi
  801ba3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801ba9:	0f 8f 6e ff ff ff    	jg     801b1d <_ZL14inode_set_sizeP5Inodej+0x5d>
  801baf:	eb 54                	jmp    801c05 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801bb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bb4:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801bb9:	83 f8 01             	cmp    $0x1,%eax
  801bbc:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801bbf:	ba 02 00 00 00       	mov    $0x2,%edx
  801bc4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801bc9:	e8 bd fd ff ff       	call   80198b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801bce:	39 f7                	cmp    %esi,%edi
  801bd0:	7d 24                	jge    801bf6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801bd2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801bd5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801bd9:	8b 10                	mov    (%eax),%edx
  801bdb:	85 d2                	test   %edx,%edx
  801bdd:	74 0d                	je     801bec <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801bdf:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801be6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801bec:	83 eb 01             	sub    $0x1,%ebx
  801bef:	83 e8 04             	sub    $0x4,%eax
  801bf2:	39 fb                	cmp    %edi,%ebx
  801bf4:	75 e3                	jne    801bd9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801bf6:	ba 05 00 00 00       	mov    $0x5,%edx
  801bfb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c00:	e8 86 fd ff ff       	call   80198b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801c05:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c0b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801c0e:	ba 04 00 00 00       	mov    $0x4,%edx
  801c13:	e8 73 fd ff ff       	call   80198b <_ZL10bcache_ipcPvi>
	return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1d:	83 c4 2c             	add    $0x2c,%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5f                   	pop    %edi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801c25:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c2c:	ba 05 00 00 00       	mov    $0x5,%edx
  801c31:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c36:	e8 50 fd ff ff       	call   80198b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c3b:	bb 02 00 00 00       	mov    $0x2,%ebx
  801c40:	e9 52 ff ff ff       	jmp    801b97 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801c45 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	53                   	push   %ebx
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801c4e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801c54:	83 e8 01             	sub    $0x1,%eax
  801c57:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801c5d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801c61:	75 40                	jne    801ca3 <_ZL11inode_closeP5Inode+0x5e>
  801c63:	85 c0                	test   %eax,%eax
  801c65:	75 3c                	jne    801ca3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801c67:	ba 02 00 00 00       	mov    $0x2,%edx
  801c6c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c71:	e8 15 fd ff ff       	call   80198b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801c76:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801c7b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801c7f:	85 d2                	test   %edx,%edx
  801c81:	74 07                	je     801c8a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801c83:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801c8a:	83 c0 01             	add    $0x1,%eax
  801c8d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801c92:	75 e7                	jne    801c7b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c94:	ba 05 00 00 00       	mov    $0x5,%edx
  801c99:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c9e:	e8 e8 fc ff ff       	call   80198b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801ca3:	ba 03 00 00 00       	mov    $0x3,%edx
  801ca8:	89 d8                	mov    %ebx,%eax
  801caa:	e8 dc fc ff ff       	call   80198b <_ZL10bcache_ipcPvi>
}
  801caf:	83 c4 04             	add    $0x4,%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    

00801cb5 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	53                   	push   %ebx
  801cb9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801cc5:	e8 7d fd ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  801cca:	89 c3                	mov    %eax,%ebx
  801ccc:	85 c0                	test   %eax,%eax
  801cce:	78 15                	js     801ce5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd6:	e8 e5 fd ff ff       	call   801ac0 <_ZL14inode_set_sizeP5Inodej>
  801cdb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce0:	e8 60 ff ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
	return r;
}
  801ce5:	89 d8                	mov    %ebx,%eax
  801ce7:	83 c4 14             	add    $0x14,%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5d                   	pop    %ebp
  801cec:	c3                   	ret    

00801ced <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	53                   	push   %ebx
  801cf1:	83 ec 14             	sub    $0x14,%esp
  801cf4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801cf7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801cf9:	89 c2                	mov    %eax,%edx
  801cfb:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801d01:	78 32                	js     801d35 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801d03:	ba 00 00 00 00       	mov    $0x0,%edx
  801d08:	e8 7e fc ff ff       	call   80198b <_ZL10bcache_ipcPvi>
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	74 1c                	je     801d2d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801d11:	c7 44 24 08 ad 4f 80 	movl   $0x804fad,0x8(%esp)
  801d18:	00 
  801d19:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801d20:	00 
  801d21:	c7 04 24 a2 4f 80 00 	movl   $0x804fa2,(%esp)
  801d28:	e8 27 e4 ff ff       	call   800154 <_Z6_panicPKciS0_z>
    resume(utf);
  801d2d:	89 1c 24             	mov    %ebx,(%esp)
  801d30:	e8 7b 26 00 00       	call   8043b0 <resume>
}
  801d35:	83 c4 14             	add    $0x14,%esp
  801d38:	5b                   	pop    %ebx
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    

00801d3b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 28             	sub    $0x28,%esp
  801d41:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d44:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d4a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801d4d:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d50:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d53:	e8 ef fc ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	78 26                	js     801d82 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  801d5c:	83 c3 10             	add    $0x10,%ebx
  801d5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d63:	89 34 24             	mov    %esi,(%esp)
  801d66:	e8 1f eb ff ff       	call   80088a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801d6b:	89 f2                	mov    %esi,%edx
  801d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d70:	e8 9e fb ff ff       	call   801913 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  801d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d78:	e8 c8 fe ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
	return 0;
  801d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d82:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d85:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d88:	89 ec                	mov    %ebp,%esp
  801d8a:	5d                   	pop    %ebp
  801d8b:	c3                   	ret    

00801d8c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	53                   	push   %ebx
  801d90:	83 ec 24             	sub    $0x24,%esp
  801d93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801d96:	89 1c 24             	mov    %ebx,(%esp)
  801d99:	e8 9e 15 00 00       	call   80333c <_Z7pagerefPv>
  801d9e:	89 c2                	mov    %eax,%edx
        return 0;
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801da5:	83 fa 01             	cmp    $0x1,%edx
  801da8:	7f 1e                	jg     801dc8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801daa:	8b 43 0c             	mov    0xc(%ebx),%eax
  801dad:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801db0:	e8 92 fc ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  801db5:	85 c0                	test   %eax,%eax
  801db7:	78 0f                	js     801dc8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  801dc3:	e8 7d fe ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
}
  801dc8:	83 c4 24             	add    $0x24,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 3c             	sub    $0x3c,%esp
  801dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801dda:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  801ddd:	8b 43 04             	mov    0x4(%ebx),%eax
  801de0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801de3:	8b 43 0c             	mov    0xc(%ebx),%eax
  801de6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801de9:	e8 59 fc ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  801dee:	85 c0                	test   %eax,%eax
  801df0:	0f 88 8c 00 00 00    	js     801e82 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801df6:	8b 53 04             	mov    0x4(%ebx),%edx
  801df9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  801dff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801e05:	29 d7                	sub    %edx,%edi
  801e07:	39 f7                	cmp    %esi,%edi
  801e09:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  801e0c:	85 ff                	test   %edi,%edi
  801e0e:	74 16                	je     801e26 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801e10:	8d 14 17             	lea    (%edi,%edx,1),%edx
  801e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e16:	3b 50 08             	cmp    0x8(%eax),%edx
  801e19:	76 6f                	jbe    801e8a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  801e1b:	e8 a0 fc ff ff       	call   801ac0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801e20:	85 c0                	test   %eax,%eax
  801e22:	79 66                	jns    801e8a <_ZL13devfile_writeP2FdPKvj+0xbc>
  801e24:	eb 4e                	jmp    801e74 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801e26:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  801e2c:	76 24                	jbe    801e52 <_ZL13devfile_writeP2FdPKvj+0x84>
  801e2e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801e30:	8b 53 04             	mov    0x4(%ebx),%edx
  801e33:	81 c2 00 10 00 00    	add    $0x1000,%edx
  801e39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3c:	3b 50 08             	cmp    0x8(%eax),%edx
  801e3f:	0f 86 83 00 00 00    	jbe    801ec8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  801e45:	e8 76 fc ff ff       	call   801ac0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	79 7a                	jns    801ec8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  801e4e:	66 90                	xchg   %ax,%ax
  801e50:	eb 22                	jmp    801e74 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  801e52:	85 f6                	test   %esi,%esi
  801e54:	74 1e                	je     801e74 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801e56:	89 f2                	mov    %esi,%edx
  801e58:	03 53 04             	add    0x4(%ebx),%edx
  801e5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e5e:	3b 50 08             	cmp    0x8(%eax),%edx
  801e61:	0f 86 b8 00 00 00    	jbe    801f1f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  801e67:	e8 54 fc ff ff       	call   801ac0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	0f 89 ab 00 00 00    	jns    801f1f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  801e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e77:	e8 c9 fd ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  801e7c:	8b 43 04             	mov    0x4(%ebx),%eax
  801e7f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  801e82:	83 c4 3c             	add    $0x3c,%esp
  801e85:	5b                   	pop    %ebx
  801e86:	5e                   	pop    %esi
  801e87:	5f                   	pop    %edi
  801e88:	5d                   	pop    %ebp
  801e89:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  801e8a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801e8c:	8b 53 04             	mov    0x4(%ebx),%edx
  801e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e92:	e8 39 fa ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
  801e97:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  801e9a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ea8:	89 04 24             	mov    %eax,(%esp)
  801eab:	e8 f7 eb ff ff       	call   800aa7 <memcpy>
        fd->fd_offset += n2;
  801eb0:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  801eb3:	ba 04 00 00 00       	mov    $0x4,%edx
  801eb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ebb:	e8 cb fa ff ff       	call   80198b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  801ec0:	01 7d 0c             	add    %edi,0xc(%ebp)
  801ec3:	e9 5e ff ff ff       	jmp    801e26 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801ec8:	8b 53 04             	mov    0x4(%ebx),%edx
  801ecb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ece:	e8 fd f9 ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
  801ed3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  801ed5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801edc:	00 
  801edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee4:	89 34 24             	mov    %esi,(%esp)
  801ee7:	e8 bb eb ff ff       	call   800aa7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801eec:	ba 04 00 00 00       	mov    $0x4,%edx
  801ef1:	89 f0                	mov    %esi,%eax
  801ef3:	e8 93 fa ff ff       	call   80198b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  801ef8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  801efe:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  801f05:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801f0c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801f12:	0f 87 18 ff ff ff    	ja     801e30 <_ZL13devfile_writeP2FdPKvj+0x62>
  801f18:	89 fe                	mov    %edi,%esi
  801f1a:	e9 33 ff ff ff       	jmp    801e52 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801f1f:	8b 53 04             	mov    0x4(%ebx),%edx
  801f22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f25:	e8 a6 f9 ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
  801f2a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  801f2c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f37:	89 3c 24             	mov    %edi,(%esp)
  801f3a:	e8 68 eb ff ff       	call   800aa7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801f3f:	ba 04 00 00 00       	mov    $0x4,%edx
  801f44:	89 f8                	mov    %edi,%eax
  801f46:	e8 40 fa ff ff       	call   80198b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  801f4b:	01 73 04             	add    %esi,0x4(%ebx)
  801f4e:	e9 21 ff ff ff       	jmp    801e74 <_ZL13devfile_writeP2FdPKvj+0xa6>

00801f53 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	57                   	push   %edi
  801f57:	56                   	push   %esi
  801f58:	53                   	push   %ebx
  801f59:	83 ec 3c             	sub    $0x3c,%esp
  801f5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  801f62:	8b 43 04             	mov    0x4(%ebx),%eax
  801f65:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801f68:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f6b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801f6e:	e8 d4 fa ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  801f73:	85 c0                	test   %eax,%eax
  801f75:	0f 88 d3 00 00 00    	js     80204e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  801f7b:	8b 73 04             	mov    0x4(%ebx),%esi
  801f7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f81:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  801f84:	8b 50 08             	mov    0x8(%eax),%edx
  801f87:	29 f2                	sub    %esi,%edx
  801f89:	3b 48 08             	cmp    0x8(%eax),%ecx
  801f8c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  801f8f:	89 f2                	mov    %esi,%edx
  801f91:	e8 3a f9 ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
  801f96:	85 c0                	test   %eax,%eax
  801f98:	0f 84 a2 00 00 00    	je     802040 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801f9e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  801fa4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801faa:	29 f2                	sub    %esi,%edx
  801fac:	39 d7                	cmp    %edx,%edi
  801fae:	0f 46 d7             	cmovbe %edi,%edx
  801fb1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  801fb4:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  801fb6:	01 d6                	add    %edx,%esi
  801fb8:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  801fbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc6:	89 04 24             	mov    %eax,(%esp)
  801fc9:	e8 d9 ea ff ff       	call   800aa7 <memcpy>
    buf = (void *)((char *)buf + n2);
  801fce:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fd1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  801fd4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801fda:	76 3e                	jbe    80201a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  801fdc:	8b 53 04             	mov    0x4(%ebx),%edx
  801fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fe2:	e8 e9 f8 ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	74 55                	je     802040 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  801feb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801ff2:	00 
  801ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff7:	89 34 24             	mov    %esi,(%esp)
  801ffa:	e8 a8 ea ff ff       	call   800aa7 <memcpy>
        n -= PGSIZE;
  801fff:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802005:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80200b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802012:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802018:	77 c2                	ja     801fdc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80201a:	85 ff                	test   %edi,%edi
  80201c:	74 22                	je     802040 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80201e:	8b 53 04             	mov    0x4(%ebx),%edx
  802021:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802024:	e8 a7 f8 ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
  802029:	85 c0                	test   %eax,%eax
  80202b:	74 13                	je     802040 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80202d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802031:	89 44 24 04          	mov    %eax,0x4(%esp)
  802035:	89 34 24             	mov    %esi,(%esp)
  802038:	e8 6a ea ff ff       	call   800aa7 <memcpy>
        fd->fd_offset += n;
  80203d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802040:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802043:	e8 fd fb ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802048:	8b 43 04             	mov    0x4(%ebx),%eax
  80204b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80204e:	83 c4 3c             	add    $0x3c,%esp
  802051:	5b                   	pop    %ebx
  802052:	5e                   	pop    %esi
  802053:	5f                   	pop    %edi
  802054:	5d                   	pop    %ebp
  802055:	c3                   	ret    

00802056 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	57                   	push   %edi
  80205a:	56                   	push   %esi
  80205b:	53                   	push   %ebx
  80205c:	83 ec 4c             	sub    $0x4c,%esp
  80205f:	89 c6                	mov    %eax,%esi
  802061:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802064:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802067:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80206d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802076:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802079:	b8 01 00 00 00       	mov    $0x1,%eax
  80207e:	e8 c4 f9 ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  802083:	89 c7                	mov    %eax,%edi
  802085:	85 c0                	test   %eax,%eax
  802087:	0f 88 cd 01 00 00    	js     80225a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80208d:	89 f3                	mov    %esi,%ebx
  80208f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802092:	75 08                	jne    80209c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802094:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802097:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80209a:	74 f8                	je     802094 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80209c:	0f b6 03             	movzbl (%ebx),%eax
  80209f:	3c 2f                	cmp    $0x2f,%al
  8020a1:	74 16                	je     8020b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8020a3:	84 c0                	test   %al,%al
  8020a5:	74 12                	je     8020b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8020a7:	89 da                	mov    %ebx,%edx
		++path;
  8020a9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8020ac:	0f b6 02             	movzbl (%edx),%eax
  8020af:	3c 2f                	cmp    $0x2f,%al
  8020b1:	74 08                	je     8020bb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8020b3:	84 c0                	test   %al,%al
  8020b5:	75 f2                	jne    8020a9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  8020b7:	eb 02                	jmp    8020bb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8020b9:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  8020bb:	89 d0                	mov    %edx,%eax
  8020bd:	29 d8                	sub    %ebx,%eax
  8020bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  8020c2:	0f b6 02             	movzbl (%edx),%eax
  8020c5:	89 d6                	mov    %edx,%esi
  8020c7:	3c 2f                	cmp    $0x2f,%al
  8020c9:	75 0a                	jne    8020d5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  8020cb:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  8020ce:	0f b6 06             	movzbl (%esi),%eax
  8020d1:	3c 2f                	cmp    $0x2f,%al
  8020d3:	74 f6                	je     8020cb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8020d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8020d9:	75 1b                	jne    8020f6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8020db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020de:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8020e1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8020e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020e6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8020ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f1:	e9 64 01 00 00       	jmp    80225a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8020f6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8020fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020fe:	74 06                	je     802106 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802100:	84 c0                	test   %al,%al
  802102:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802106:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802109:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80210c:	83 3a 02             	cmpl   $0x2,(%edx)
  80210f:	0f 85 f4 00 00 00    	jne    802209 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802115:	89 d0                	mov    %edx,%eax
  802117:	8b 52 08             	mov    0x8(%edx),%edx
  80211a:	85 d2                	test   %edx,%edx
  80211c:	7e 78                	jle    802196 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80211e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802125:	bf 00 00 00 00       	mov    $0x0,%edi
  80212a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80212d:	89 fb                	mov    %edi,%ebx
  80212f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802132:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802134:	89 da                	mov    %ebx,%edx
  802136:	89 f0                	mov    %esi,%eax
  802138:	e8 93 f7 ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
  80213d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80213f:	83 38 00             	cmpl   $0x0,(%eax)
  802142:	74 26                	je     80216a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802144:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802147:	3b 50 04             	cmp    0x4(%eax),%edx
  80214a:	75 33                	jne    80217f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80214c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802150:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802153:	89 44 24 04          	mov    %eax,0x4(%esp)
  802157:	8d 47 08             	lea    0x8(%edi),%eax
  80215a:	89 04 24             	mov    %eax,(%esp)
  80215d:	e8 86 e9 ff ff       	call   800ae8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802162:	85 c0                	test   %eax,%eax
  802164:	0f 84 fa 00 00 00    	je     802264 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80216a:	83 3f 00             	cmpl   $0x0,(%edi)
  80216d:	75 10                	jne    80217f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80216f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802173:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802176:	84 c0                	test   %al,%al
  802178:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80217c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80217f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802185:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802187:	8b 56 08             	mov    0x8(%esi),%edx
  80218a:	39 d0                	cmp    %edx,%eax
  80218c:	7c a6                	jl     802134 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80218e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802191:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802194:	eb 07                	jmp    80219d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802196:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80219d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  8021a1:	74 6d                	je     802210 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  8021a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8021a7:	75 24                	jne    8021cd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  8021a9:	83 ea 80             	sub    $0xffffff80,%edx
  8021ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021af:	e8 0c f9 ff ff       	call   801ac0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	0f 88 90 00 00 00    	js     80224c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  8021bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021bf:	8b 50 08             	mov    0x8(%eax),%edx
  8021c2:	83 c2 80             	add    $0xffffff80,%edx
  8021c5:	e8 06 f7 ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
  8021ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  8021cd:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8021d4:	00 
  8021d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021dc:	00 
  8021dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8021e0:	89 14 24             	mov    %edx,(%esp)
  8021e3:	e8 e9 e7 ff ff       	call   8009d1 <memset>
	empty->de_namelen = namelen;
  8021e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021ee:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8021f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021f9:	83 c0 08             	add    $0x8,%eax
  8021fc:	89 04 24             	mov    %eax,(%esp)
  8021ff:	e8 a3 e8 ff ff       	call   800aa7 <memcpy>
	*de_store = empty;
  802204:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802207:	eb 5e                	jmp    802267 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802209:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80220e:	eb 42                	jmp    802252 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802210:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802215:	eb 3b                	jmp    802252 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80221a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80221d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80221f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802222:	89 38                	mov    %edi,(%eax)
			return 0;
  802224:	bf 00 00 00 00       	mov    $0x0,%edi
  802229:	eb 2f                	jmp    80225a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80222b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80222e:	8b 07                	mov    (%edi),%eax
  802230:	e8 12 f8 ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  802235:	85 c0                	test   %eax,%eax
  802237:	78 17                	js     802250 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802239:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80223c:	e8 04 fa ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802241:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802244:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802247:	e9 41 fe ff ff       	jmp    80208d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80224c:	89 c7                	mov    %eax,%edi
  80224e:	eb 02                	jmp    802252 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802250:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802255:	e8 eb f9 ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
	return r;
}
  80225a:	89 f8                	mov    %edi,%eax
  80225c:	83 c4 4c             	add    $0x4c,%esp
  80225f:	5b                   	pop    %ebx
  802260:	5e                   	pop    %esi
  802261:	5f                   	pop    %edi
  802262:	5d                   	pop    %ebp
  802263:	c3                   	ret    
  802264:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802267:	80 3e 00             	cmpb   $0x0,(%esi)
  80226a:	75 bf                	jne    80222b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80226c:	eb a9                	jmp    802217 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080226e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	57                   	push   %edi
  802272:	56                   	push   %esi
  802273:	53                   	push   %ebx
  802274:	83 ec 3c             	sub    $0x3c,%esp
  802277:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80227a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80227d:	89 04 24             	mov    %eax,(%esp)
  802280:	e8 62 f0 ff ff       	call   8012e7 <_Z14fd_find_unusedPP2Fd>
  802285:	89 c3                	mov    %eax,%ebx
  802287:	85 c0                	test   %eax,%eax
  802289:	0f 88 16 02 00 00    	js     8024a5 <_Z4openPKci+0x237>
  80228f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802296:	00 
  802297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80229a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a5:	e8 c6 ea ff ff       	call   800d70 <_Z14sys_page_allociPvi>
  8022aa:	89 c3                	mov    %eax,%ebx
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b1:	85 db                	test   %ebx,%ebx
  8022b3:	0f 88 ec 01 00 00    	js     8024a5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  8022b9:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  8022bd:	0f 84 ec 01 00 00    	je     8024af <_Z4openPKci+0x241>
  8022c3:	83 c0 01             	add    $0x1,%eax
  8022c6:	83 f8 78             	cmp    $0x78,%eax
  8022c9:	75 ee                	jne    8022b9 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8022cb:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8022d0:	e9 b9 01 00 00       	jmp    80248e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8022d5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022d8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8022de:	89 3c 24             	mov    %edi,(%esp)
  8022e1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  8022e4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8022e7:	89 f0                	mov    %esi,%eax
  8022e9:	e8 68 fd ff ff       	call   802056 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8022ee:	89 c3                	mov    %eax,%ebx
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	0f 85 96 01 00 00    	jne    80248e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8022f8:	85 ff                	test   %edi,%edi
  8022fa:	75 41                	jne    80233d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8022fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022ff:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802304:	75 08                	jne    80230e <_Z4openPKci+0xa0>
            fileino = dirino;
  802306:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802309:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80230c:	eb 14                	jmp    802322 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80230e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802311:	8b 00                	mov    (%eax),%eax
  802313:	e8 2f f7 ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  802318:	89 c3                	mov    %eax,%ebx
  80231a:	85 c0                	test   %eax,%eax
  80231c:	0f 88 5d 01 00 00    	js     80247f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802322:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802325:	83 38 02             	cmpl   $0x2,(%eax)
  802328:	0f 85 d2 00 00 00    	jne    802400 <_Z4openPKci+0x192>
  80232e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802332:	0f 84 c8 00 00 00    	je     802400 <_Z4openPKci+0x192>
  802338:	e9 38 01 00 00       	jmp    802475 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80233d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802344:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80234b:	0f 8e a8 00 00 00    	jle    8023f9 <_Z4openPKci+0x18b>
  802351:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802356:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802359:	89 f8                	mov    %edi,%eax
  80235b:	e8 e7 f6 ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  802360:	89 c3                	mov    %eax,%ebx
  802362:	85 c0                	test   %eax,%eax
  802364:	0f 88 15 01 00 00    	js     80247f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80236a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80236d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802371:	75 68                	jne    8023db <_Z4openPKci+0x16d>
  802373:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80237a:	75 5f                	jne    8023db <_Z4openPKci+0x16d>
			*ino_store = ino;
  80237c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80237f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802385:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802388:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80238f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802396:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80239d:	00 
  80239e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023a5:	00 
  8023a6:	83 c0 0c             	add    $0xc,%eax
  8023a9:	89 04 24             	mov    %eax,(%esp)
  8023ac:	e8 20 e6 ff ff       	call   8009d1 <memset>
        de->de_inum = fileino->i_inum;
  8023b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023b4:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  8023ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023bd:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  8023bf:	ba 04 00 00 00       	mov    $0x4,%edx
  8023c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023c7:	e8 bf f5 ff ff       	call   80198b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  8023cc:	ba 04 00 00 00       	mov    $0x4,%edx
  8023d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d4:	e8 b2 f5 ff ff       	call   80198b <_ZL10bcache_ipcPvi>
  8023d9:	eb 25                	jmp    802400 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  8023db:	e8 65 f8 ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8023e0:	83 c7 01             	add    $0x1,%edi
  8023e3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  8023e9:	0f 8c 67 ff ff ff    	jl     802356 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  8023ef:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8023f4:	e9 86 00 00 00       	jmp    80247f <_Z4openPKci+0x211>
  8023f9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8023fe:	eb 7f                	jmp    80247f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802400:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802407:	74 0d                	je     802416 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802409:	ba 00 00 00 00       	mov    $0x0,%edx
  80240e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802411:	e8 aa f6 ff ff       	call   801ac0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802416:	8b 15 04 60 80 00    	mov    0x806004,%edx
  80241c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802424:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80242b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802431:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802434:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80243a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80243d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802441:	83 c0 10             	add    $0x10,%eax
  802444:	89 04 24             	mov    %eax,(%esp)
  802447:	e8 3e e4 ff ff       	call   80088a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80244c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80244f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802459:	e8 e7 f7 ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80245e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802461:	e8 df f7 ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802469:	89 04 24             	mov    %eax,(%esp)
  80246c:	e8 13 ee ff ff       	call   801284 <_Z6fd2numP2Fd>
  802471:	89 c3                	mov    %eax,%ebx
  802473:	eb 30                	jmp    8024a5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802475:	e8 cb f7 ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80247a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80247f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802482:	e8 be f7 ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
  802487:	eb 05                	jmp    80248e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802489:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80248e:	a1 00 70 80 00       	mov    0x807000,%eax
  802493:	8b 40 04             	mov    0x4(%eax),%eax
  802496:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802499:	89 54 24 04          	mov    %edx,0x4(%esp)
  80249d:	89 04 24             	mov    %eax,(%esp)
  8024a0:	e8 88 e9 ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  8024a5:	89 d8                	mov    %ebx,%eax
  8024a7:	83 c4 3c             	add    $0x3c,%esp
  8024aa:	5b                   	pop    %ebx
  8024ab:	5e                   	pop    %esi
  8024ac:	5f                   	pop    %edi
  8024ad:	5d                   	pop    %ebp
  8024ae:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  8024af:	83 f8 78             	cmp    $0x78,%eax
  8024b2:	0f 85 1d fe ff ff    	jne    8022d5 <_Z4openPKci+0x67>
  8024b8:	eb cf                	jmp    802489 <_Z4openPKci+0x21b>

008024ba <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	53                   	push   %ebx
  8024be:	83 ec 24             	sub    $0x24,%esp
  8024c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  8024c4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	e8 78 f5 ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	78 27                	js     8024fa <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  8024d3:	c7 44 24 04 c0 4f 80 	movl   $0x804fc0,0x4(%esp)
  8024da:	00 
  8024db:	89 1c 24             	mov    %ebx,(%esp)
  8024de:	e8 a7 e3 ff ff       	call   80088a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8024e3:	89 da                	mov    %ebx,%edx
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	e8 26 f4 ff ff       	call   801913 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	e8 50 f7 ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
	return 0;
  8024f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fa:	83 c4 24             	add    $0x24,%esp
  8024fd:	5b                   	pop    %ebx
  8024fe:	5d                   	pop    %ebp
  8024ff:	c3                   	ret    

00802500 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	53                   	push   %ebx
  802504:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802507:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80250e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802511:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	e8 3a fb ff ff       	call   802056 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80251c:	89 c3                	mov    %eax,%ebx
  80251e:	85 c0                	test   %eax,%eax
  802520:	78 5f                	js     802581 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802522:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802528:	8b 00                	mov    (%eax),%eax
  80252a:	e8 18 f5 ff ff       	call   801a47 <_ZL10inode_openiPP5Inode>
  80252f:	89 c3                	mov    %eax,%ebx
  802531:	85 c0                	test   %eax,%eax
  802533:	78 44                	js     802579 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802535:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80253a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253d:	83 38 02             	cmpl   $0x2,(%eax)
  802540:	74 2f                	je     802571 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802542:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802545:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80254b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802552:	ba 04 00 00 00       	mov    $0x4,%edx
  802557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255a:	e8 2c f4 ff ff       	call   80198b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80255f:	ba 04 00 00 00       	mov    $0x4,%edx
  802564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802567:	e8 1f f4 ff ff       	call   80198b <_ZL10bcache_ipcPvi>
	r = 0;
  80256c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802574:	e8 cc f6 ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	e8 c4 f6 ff ff       	call   801c45 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802581:	89 d8                	mov    %ebx,%eax
  802583:	83 c4 24             	add    $0x24,%esp
  802586:	5b                   	pop    %ebx
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    

00802589 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    

00802593 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
  802596:	57                   	push   %edi
  802597:	56                   	push   %esi
  802598:	53                   	push   %ebx
  802599:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  80259f:	c7 04 24 ed 1c 80 00 	movl   $0x801ced,(%esp)
  8025a6:	e8 30 1d 00 00       	call   8042db <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  8025ab:	a1 00 10 00 50       	mov    0x50001000,%eax
  8025b0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  8025b5:	74 28                	je     8025df <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  8025b7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  8025be:	4a 
  8025bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025c3:	c7 44 24 08 28 50 80 	movl   $0x805028,0x8(%esp)
  8025ca:	00 
  8025cb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  8025d2:	00 
  8025d3:	c7 04 24 a2 4f 80 00 	movl   $0x804fa2,(%esp)
  8025da:	e8 75 db ff ff       	call   800154 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  8025df:	a1 04 10 00 50       	mov    0x50001004,%eax
  8025e4:	83 f8 03             	cmp    $0x3,%eax
  8025e7:	7f 1c                	jg     802605 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  8025e9:	c7 44 24 08 5c 50 80 	movl   $0x80505c,0x8(%esp)
  8025f0:	00 
  8025f1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  8025f8:	00 
  8025f9:	c7 04 24 a2 4f 80 00 	movl   $0x804fa2,(%esp)
  802600:	e8 4f db ff ff       	call   800154 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802605:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  80260b:	85 d2                	test   %edx,%edx
  80260d:	7f 1c                	jg     80262b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  80260f:	c7 44 24 08 8c 50 80 	movl   $0x80508c,0x8(%esp)
  802616:	00 
  802617:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  80261e:	00 
  80261f:	c7 04 24 a2 4f 80 00 	movl   $0x804fa2,(%esp)
  802626:	e8 29 db ff ff       	call   800154 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80262b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802631:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802637:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80263d:	85 c9                	test   %ecx,%ecx
  80263f:	0f 48 cb             	cmovs  %ebx,%ecx
  802642:	c1 f9 0c             	sar    $0xc,%ecx
  802645:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802649:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80264f:	39 c8                	cmp    %ecx,%eax
  802651:	7c 13                	jl     802666 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802653:	85 c0                	test   %eax,%eax
  802655:	7f 3d                	jg     802694 <_Z4fsckv+0x101>
  802657:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80265e:	00 00 00 
  802661:	e9 ac 00 00 00       	jmp    802712 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802666:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80266c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802670:	89 44 24 10          	mov    %eax,0x10(%esp)
  802674:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802678:	c7 44 24 08 bc 50 80 	movl   $0x8050bc,0x8(%esp)
  80267f:	00 
  802680:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802687:	00 
  802688:	c7 04 24 a2 4f 80 00 	movl   $0x804fa2,(%esp)
  80268f:	e8 c0 da ff ff       	call   800154 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802694:	be 00 20 00 50       	mov    $0x50002000,%esi
  802699:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  8026a0:	00 00 00 
  8026a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026a8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  8026ae:	39 df                	cmp    %ebx,%edi
  8026b0:	7e 27                	jle    8026d9 <_Z4fsckv+0x146>
  8026b2:	0f b6 06             	movzbl (%esi),%eax
  8026b5:	84 c0                	test   %al,%al
  8026b7:	74 4b                	je     802704 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  8026b9:	0f be c0             	movsbl %al,%eax
  8026bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026c4:	c7 04 24 00 51 80 00 	movl   $0x805100,(%esp)
  8026cb:	e8 a2 db ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  8026d0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8026d7:	eb 2b                	jmp    802704 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  8026d9:	0f b6 06             	movzbl (%esi),%eax
  8026dc:	3c 01                	cmp    $0x1,%al
  8026de:	76 24                	jbe    802704 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  8026e0:	0f be c0             	movsbl %al,%eax
  8026e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026eb:	c7 04 24 34 51 80 00 	movl   $0x805134,(%esp)
  8026f2:	e8 7b db ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  8026f7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  8026fe:	80 3e 00             	cmpb   $0x0,(%esi)
  802701:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802704:	83 c3 01             	add    $0x1,%ebx
  802707:	83 c6 01             	add    $0x1,%esi
  80270a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802710:	7f 9c                	jg     8026ae <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802712:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802719:	0f 8e e1 02 00 00    	jle    802a00 <_Z4fsckv+0x46d>
  80271f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802726:	00 00 00 
		struct Inode *ino = get_inode(i);
  802729:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80272f:	e8 f9 f1 ff ff       	call   80192d <_ZL9get_inodei>
  802734:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80273a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80273e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802745:	75 22                	jne    802769 <_Z4fsckv+0x1d6>
  802747:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80274e:	0f 84 a9 06 00 00    	je     802dfd <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802754:	ba 00 00 00 00       	mov    $0x0,%edx
  802759:	e8 2d f2 ff ff       	call   80198b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80275e:	85 c0                	test   %eax,%eax
  802760:	74 3a                	je     80279c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802762:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802769:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80276f:	8b 02                	mov    (%edx),%eax
  802771:	83 f8 01             	cmp    $0x1,%eax
  802774:	74 26                	je     80279c <_Z4fsckv+0x209>
  802776:	83 f8 02             	cmp    $0x2,%eax
  802779:	74 21                	je     80279c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80277b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80277f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802785:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802789:	c7 04 24 60 51 80 00 	movl   $0x805160,(%esp)
  802790:	e8 dd da ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  802795:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80279c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8027a3:	75 3f                	jne    8027e4 <_Z4fsckv+0x251>
  8027a5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8027ab:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8027af:	75 15                	jne    8027c6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  8027b1:	c7 04 24 84 51 80 00 	movl   $0x805184,(%esp)
  8027b8:	e8 b5 da ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  8027bd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8027c4:	eb 1e                	jmp    8027e4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  8027c6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8027cc:	83 3a 02             	cmpl   $0x2,(%edx)
  8027cf:	74 13                	je     8027e4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8027d1:	c7 04 24 b8 51 80 00 	movl   $0x8051b8,(%esp)
  8027d8:	e8 95 da ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  8027dd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  8027e4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  8027e9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8027f0:	0f 84 93 00 00 00    	je     802889 <_Z4fsckv+0x2f6>
  8027f6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8027fc:	8b 41 08             	mov    0x8(%ecx),%eax
  8027ff:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802804:	7e 23                	jle    802829 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802806:	89 44 24 08          	mov    %eax,0x8(%esp)
  80280a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802810:	89 44 24 04          	mov    %eax,0x4(%esp)
  802814:	c7 04 24 e8 51 80 00 	movl   $0x8051e8,(%esp)
  80281b:	e8 52 da ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  802820:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802827:	eb 09                	jmp    802832 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802829:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802830:	74 4b                	je     80287d <_Z4fsckv+0x2ea>
  802832:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802838:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80283e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802844:	74 23                	je     802869 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802846:	89 44 24 08          	mov    %eax,0x8(%esp)
  80284a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802850:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802854:	c7 04 24 0c 52 80 00 	movl   $0x80520c,(%esp)
  80285b:	e8 12 da ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  802860:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802867:	eb 09                	jmp    802872 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802869:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802870:	74 12                	je     802884 <_Z4fsckv+0x2f1>
  802872:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802878:	8b 78 08             	mov    0x8(%eax),%edi
  80287b:	eb 0c                	jmp    802889 <_Z4fsckv+0x2f6>
  80287d:	bf 00 00 00 00       	mov    $0x0,%edi
  802882:	eb 05                	jmp    802889 <_Z4fsckv+0x2f6>
  802884:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802889:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  80288e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802894:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802898:	89 d8                	mov    %ebx,%eax
  80289a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  80289d:	39 c7                	cmp    %eax,%edi
  80289f:	7e 2b                	jle    8028cc <_Z4fsckv+0x339>
  8028a1:	85 f6                	test   %esi,%esi
  8028a3:	75 27                	jne    8028cc <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  8028a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028ad:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8028b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028b7:	c7 04 24 30 52 80 00 	movl   $0x805230,(%esp)
  8028be:	e8 af d9 ff ff       	call   800272 <_Z7cprintfPKcz>
				++errors;
  8028c3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8028ca:	eb 36                	jmp    802902 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  8028cc:	39 f8                	cmp    %edi,%eax
  8028ce:	7c 32                	jl     802902 <_Z4fsckv+0x36f>
  8028d0:	85 f6                	test   %esi,%esi
  8028d2:	74 2e                	je     802902 <_Z4fsckv+0x36f>
  8028d4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8028db:	74 25                	je     802902 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8028dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028e1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028e5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8028eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ef:	c7 04 24 74 52 80 00 	movl   $0x805274,(%esp)
  8028f6:	e8 77 d9 ff ff       	call   800272 <_Z7cprintfPKcz>
				++errors;
  8028fb:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802902:	85 f6                	test   %esi,%esi
  802904:	0f 84 a0 00 00 00    	je     8029aa <_Z4fsckv+0x417>
  80290a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802911:	0f 84 93 00 00 00    	je     8029aa <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802917:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  80291d:	7e 27                	jle    802946 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  80291f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802923:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802927:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  80292d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802931:	c7 04 24 b8 52 80 00 	movl   $0x8052b8,(%esp)
  802938:	e8 35 d9 ff ff       	call   800272 <_Z7cprintfPKcz>
					++errors;
  80293d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802944:	eb 64                	jmp    8029aa <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802946:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80294d:	3c 01                	cmp    $0x1,%al
  80294f:	75 27                	jne    802978 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802951:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802955:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802959:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  80295f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802963:	c7 04 24 fc 52 80 00 	movl   $0x8052fc,(%esp)
  80296a:	e8 03 d9 ff ff       	call   800272 <_Z7cprintfPKcz>
					++errors;
  80296f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802976:	eb 32                	jmp    8029aa <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802978:	3c ff                	cmp    $0xff,%al
  80297a:	75 27                	jne    8029a3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  80297c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802980:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802984:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80298a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298e:	c7 04 24 38 53 80 00 	movl   $0x805338,(%esp)
  802995:	e8 d8 d8 ff ff       	call   800272 <_Z7cprintfPKcz>
					++errors;
  80299a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8029a1:	eb 07                	jmp    8029aa <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  8029a3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  8029aa:	83 c3 01             	add    $0x1,%ebx
  8029ad:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  8029b3:	0f 85 d5 fe ff ff    	jne    80288e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  8029b9:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8029c0:	0f 94 c0             	sete   %al
  8029c3:	0f b6 c0             	movzbl %al,%eax
  8029c6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8029cc:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  8029d2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  8029d9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  8029e0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8029e7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  8029ee:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8029f4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  8029fa:	0f 8f 29 fd ff ff    	jg     802729 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802a00:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802a07:	0f 8e 7f 03 00 00    	jle    802d8c <_Z4fsckv+0x7f9>
  802a0d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802a12:	89 f0                	mov    %esi,%eax
  802a14:	e8 14 ef ff ff       	call   80192d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802a19:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802a20:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802a27:	c1 e2 08             	shl    $0x8,%edx
  802a2a:	09 ca                	or     %ecx,%edx
  802a2c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802a33:	c1 e1 10             	shl    $0x10,%ecx
  802a36:	09 ca                	or     %ecx,%edx
  802a38:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802a3f:	83 e1 7f             	and    $0x7f,%ecx
  802a42:	c1 e1 18             	shl    $0x18,%ecx
  802a45:	09 d1                	or     %edx,%ecx
  802a47:	74 0e                	je     802a57 <_Z4fsckv+0x4c4>
  802a49:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802a50:	78 05                	js     802a57 <_Z4fsckv+0x4c4>
  802a52:	83 38 02             	cmpl   $0x2,(%eax)
  802a55:	74 1f                	je     802a76 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802a57:	83 c6 01             	add    $0x1,%esi
  802a5a:	a1 08 10 00 50       	mov    0x50001008,%eax
  802a5f:	39 f0                	cmp    %esi,%eax
  802a61:	7f af                	jg     802a12 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802a63:	bb 01 00 00 00       	mov    $0x1,%ebx
  802a68:	83 f8 01             	cmp    $0x1,%eax
  802a6b:	0f 8f ad 02 00 00    	jg     802d1e <_Z4fsckv+0x78b>
  802a71:	e9 16 03 00 00       	jmp    802d8c <_Z4fsckv+0x7f9>
  802a76:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802a78:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802a7f:	8b 40 08             	mov    0x8(%eax),%eax
  802a82:	a8 7f                	test   $0x7f,%al
  802a84:	74 23                	je     802aa9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802a86:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802a8d:	00 
  802a8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a92:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a96:	c7 04 24 74 53 80 00 	movl   $0x805374,(%esp)
  802a9d:	e8 d0 d7 ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  802aa2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802aa9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802ab0:	00 00 00 
  802ab3:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802ab9:	e9 3d 02 00 00       	jmp    802cfb <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802abe:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802ac4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802aca:	e8 01 ee ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
  802acf:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802ad1:	83 38 00             	cmpl   $0x0,(%eax)
  802ad4:	0f 84 15 02 00 00    	je     802cef <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802ada:	8b 40 04             	mov    0x4(%eax),%eax
  802add:	8d 50 ff             	lea    -0x1(%eax),%edx
  802ae0:	83 fa 76             	cmp    $0x76,%edx
  802ae3:	76 27                	jbe    802b0c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802ae5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ae9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802aef:	89 44 24 08          	mov    %eax,0x8(%esp)
  802af3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802af7:	c7 04 24 a8 53 80 00 	movl   $0x8053a8,(%esp)
  802afe:	e8 6f d7 ff ff       	call   800272 <_Z7cprintfPKcz>
				++errors;
  802b03:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802b0a:	eb 28                	jmp    802b34 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802b0c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802b11:	74 21                	je     802b34 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802b13:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b19:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b1d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b21:	c7 04 24 d4 53 80 00 	movl   $0x8053d4,(%esp)
  802b28:	e8 45 d7 ff ff       	call   800272 <_Z7cprintfPKcz>
				++errors;
  802b2d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802b34:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802b3b:	00 
  802b3c:	8d 43 08             	lea    0x8(%ebx),%eax
  802b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b43:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802b49:	89 0c 24             	mov    %ecx,(%esp)
  802b4c:	e8 56 df ff ff       	call   800aa7 <memcpy>
  802b51:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802b55:	bf 77 00 00 00       	mov    $0x77,%edi
  802b5a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802b5e:	85 ff                	test   %edi,%edi
  802b60:	b8 00 00 00 00       	mov    $0x0,%eax
  802b65:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802b68:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802b6f:	00 

			if (de->de_inum >= super->s_ninodes) {
  802b70:	8b 03                	mov    (%ebx),%eax
  802b72:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802b78:	7c 3e                	jl     802bb8 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802b7a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b7e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802b84:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b88:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b8e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b92:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b96:	c7 04 24 08 54 80 00 	movl   $0x805408,(%esp)
  802b9d:	e8 d0 d6 ff ff       	call   800272 <_Z7cprintfPKcz>
				++errors;
  802ba2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802ba9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802bb0:	00 00 00 
  802bb3:	e9 0b 01 00 00       	jmp    802cc3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802bb8:	e8 70 ed ff ff       	call   80192d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802bbd:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802bc4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802bcb:	c1 e2 08             	shl    $0x8,%edx
  802bce:	09 d1                	or     %edx,%ecx
  802bd0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802bd7:	c1 e2 10             	shl    $0x10,%edx
  802bda:	09 d1                	or     %edx,%ecx
  802bdc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802be3:	83 e2 7f             	and    $0x7f,%edx
  802be6:	c1 e2 18             	shl    $0x18,%edx
  802be9:	09 ca                	or     %ecx,%edx
  802beb:	83 c2 01             	add    $0x1,%edx
  802bee:	89 d1                	mov    %edx,%ecx
  802bf0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802bf6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802bfc:	0f b6 d5             	movzbl %ch,%edx
  802bff:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802c05:	89 ca                	mov    %ecx,%edx
  802c07:	c1 ea 10             	shr    $0x10,%edx
  802c0a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802c10:	c1 e9 18             	shr    $0x18,%ecx
  802c13:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802c1a:	83 e2 80             	and    $0xffffff80,%edx
  802c1d:	09 ca                	or     %ecx,%edx
  802c1f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802c25:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802c29:	0f 85 7a ff ff ff    	jne    802ba9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802c2f:	8b 03                	mov    (%ebx),%eax
  802c31:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c35:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802c3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802c3f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802c45:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c49:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c4d:	c7 04 24 38 54 80 00 	movl   $0x805438,(%esp)
  802c54:	e8 19 d6 ff ff       	call   800272 <_Z7cprintfPKcz>
					++errors;
  802c59:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c60:	e9 44 ff ff ff       	jmp    802ba9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802c65:	3b 78 04             	cmp    0x4(%eax),%edi
  802c68:	75 52                	jne    802cbc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802c6a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c6e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802c74:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c78:	83 c0 08             	add    $0x8,%eax
  802c7b:	89 04 24             	mov    %eax,(%esp)
  802c7e:	e8 65 de ff ff       	call   800ae8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802c83:	85 c0                	test   %eax,%eax
  802c85:	75 35                	jne    802cbc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802c87:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802c8d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c91:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802c97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c9b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802ca1:	89 54 24 08          	mov    %edx,0x8(%esp)
  802ca5:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ca9:	c7 04 24 68 54 80 00 	movl   $0x805468,(%esp)
  802cb0:	e8 bd d5 ff ff       	call   800272 <_Z7cprintfPKcz>
					++errors;
  802cb5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802cbc:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802cc3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802cc9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802ccf:	7e 1e                	jle    802cef <_Z4fsckv+0x75c>
  802cd1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802cd5:	7f 18                	jg     802cef <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802cd7:	89 ca                	mov    %ecx,%edx
  802cd9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802cdf:	e8 ec eb ff ff       	call   8018d0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802ce4:	83 38 00             	cmpl   $0x0,(%eax)
  802ce7:	0f 85 78 ff ff ff    	jne    802c65 <_Z4fsckv+0x6d2>
  802ced:	eb cd                	jmp    802cbc <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802cef:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802cf5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802cfb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d01:	83 ea 80             	sub    $0xffffff80,%edx
  802d04:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802d0a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802d10:	3b 51 08             	cmp    0x8(%ecx),%edx
  802d13:	0f 8f e7 fc ff ff    	jg     802a00 <_Z4fsckv+0x46d>
  802d19:	e9 a0 fd ff ff       	jmp    802abe <_Z4fsckv+0x52b>
  802d1e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802d24:	89 d8                	mov    %ebx,%eax
  802d26:	e8 02 ec ff ff       	call   80192d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802d2b:	8b 50 04             	mov    0x4(%eax),%edx
  802d2e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802d35:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  802d3c:	c1 e7 08             	shl    $0x8,%edi
  802d3f:	09 f9                	or     %edi,%ecx
  802d41:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  802d48:	c1 e7 10             	shl    $0x10,%edi
  802d4b:	09 f9                	or     %edi,%ecx
  802d4d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  802d54:	83 e7 7f             	and    $0x7f,%edi
  802d57:	c1 e7 18             	shl    $0x18,%edi
  802d5a:	09 f9                	or     %edi,%ecx
  802d5c:	39 ca                	cmp    %ecx,%edx
  802d5e:	74 1b                	je     802d7b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  802d60:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802d64:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d68:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d6c:	c7 04 24 98 54 80 00 	movl   $0x805498,(%esp)
  802d73:	e8 fa d4 ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  802d78:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802d7b:	83 c3 01             	add    $0x1,%ebx
  802d7e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802d84:	7f 9e                	jg     802d24 <_Z4fsckv+0x791>
  802d86:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802d8c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802d93:	7e 4f                	jle    802de4 <_Z4fsckv+0x851>
  802d95:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d9a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  802da0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  802da7:	3c ff                	cmp    $0xff,%al
  802da9:	75 09                	jne    802db4 <_Z4fsckv+0x821>
			freemap[i] = 0;
  802dab:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  802db2:	eb 1f                	jmp    802dd3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  802db4:	84 c0                	test   %al,%al
  802db6:	75 1b                	jne    802dd3 <_Z4fsckv+0x840>
  802db8:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  802dbe:	7c 13                	jl     802dd3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  802dc0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802dc4:	c7 04 24 c4 54 80 00 	movl   $0x8054c4,(%esp)
  802dcb:	e8 a2 d4 ff ff       	call   800272 <_Z7cprintfPKcz>
			++errors;
  802dd0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802dd3:	83 c3 01             	add    $0x1,%ebx
  802dd6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802ddc:	7f c2                	jg     802da0 <_Z4fsckv+0x80d>
  802dde:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  802de4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  802deb:	19 c0                	sbb    %eax,%eax
  802ded:	f7 d0                	not    %eax
  802def:	83 e0 fd             	and    $0xfffffffd,%eax
}
  802df2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  802df8:	5b                   	pop    %ebx
  802df9:	5e                   	pop    %esi
  802dfa:	5f                   	pop    %edi
  802dfb:	5d                   	pop    %ebp
  802dfc:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802dfd:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802e04:	0f 84 92 f9 ff ff    	je     80279c <_Z4fsckv+0x209>
  802e0a:	e9 5a f9 ff ff       	jmp    802769 <_Z4fsckv+0x1d6>
	...

00802e10 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
  802e13:	83 ec 18             	sub    $0x18,%esp
  802e16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802e19:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802e1c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	89 04 24             	mov    %eax,(%esp)
  802e25:	e8 a2 e4 ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  802e2a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802e2c:	c7 44 24 04 f7 54 80 	movl   $0x8054f7,0x4(%esp)
  802e33:	00 
  802e34:	89 34 24             	mov    %esi,(%esp)
  802e37:	e8 4e da ff ff       	call   80088a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  802e3c:	8b 43 04             	mov    0x4(%ebx),%eax
  802e3f:	2b 03                	sub    (%ebx),%eax
  802e41:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  802e44:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  802e4b:	c7 86 80 00 00 00 20 	movl   $0x806020,0x80(%esi)
  802e52:	60 80 00 
	return 0;
}
  802e55:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802e5d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802e60:	89 ec                	mov    %ebp,%esp
  802e62:	5d                   	pop    %ebp
  802e63:	c3                   	ret    

00802e64 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
  802e67:	53                   	push   %ebx
  802e68:	83 ec 14             	sub    $0x14,%esp
  802e6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802e6e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e79:	e8 af df ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  802e7e:	89 1c 24             	mov    %ebx,(%esp)
  802e81:	e8 46 e4 ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  802e86:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e91:	e8 97 df ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
}
  802e96:	83 c4 14             	add    $0x14,%esp
  802e99:	5b                   	pop    %ebx
  802e9a:	5d                   	pop    %ebp
  802e9b:	c3                   	ret    

00802e9c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802e9c:	55                   	push   %ebp
  802e9d:	89 e5                	mov    %esp,%ebp
  802e9f:	57                   	push   %edi
  802ea0:	56                   	push   %esi
  802ea1:	53                   	push   %ebx
  802ea2:	83 ec 2c             	sub    $0x2c,%esp
  802ea5:	89 c7                	mov    %eax,%edi
  802ea7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  802eaa:	a1 00 70 80 00       	mov    0x807000,%eax
  802eaf:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  802eb2:	89 3c 24             	mov    %edi,(%esp)
  802eb5:	e8 82 04 00 00       	call   80333c <_Z7pagerefPv>
  802eba:	89 c3                	mov    %eax,%ebx
  802ebc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebf:	89 04 24             	mov    %eax,(%esp)
  802ec2:	e8 75 04 00 00       	call   80333c <_Z7pagerefPv>
  802ec7:	39 c3                	cmp    %eax,%ebx
  802ec9:	0f 94 c0             	sete   %al
  802ecc:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  802ecf:	8b 15 00 70 80 00    	mov    0x807000,%edx
  802ed5:	8b 52 58             	mov    0x58(%edx),%edx
  802ed8:	39 d6                	cmp    %edx,%esi
  802eda:	75 08                	jne    802ee4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  802edc:	83 c4 2c             	add    $0x2c,%esp
  802edf:	5b                   	pop    %ebx
  802ee0:	5e                   	pop    %esi
  802ee1:	5f                   	pop    %edi
  802ee2:	5d                   	pop    %ebp
  802ee3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	74 c2                	je     802eaa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  802ee8:	c7 04 24 fe 54 80 00 	movl   $0x8054fe,(%esp)
  802eef:	e8 7e d3 ff ff       	call   800272 <_Z7cprintfPKcz>
  802ef4:	eb b4                	jmp    802eaa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00802ef6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802ef6:	55                   	push   %ebp
  802ef7:	89 e5                	mov    %esp,%ebp
  802ef9:	57                   	push   %edi
  802efa:	56                   	push   %esi
  802efb:	53                   	push   %ebx
  802efc:	83 ec 1c             	sub    $0x1c,%esp
  802eff:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802f02:	89 34 24             	mov    %esi,(%esp)
  802f05:	e8 c2 e3 ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  802f0a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802f0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802f15:	75 46                	jne    802f5d <_ZL13devpipe_writeP2FdPKvj+0x67>
  802f17:	eb 52                	jmp    802f6b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  802f19:	89 da                	mov    %ebx,%edx
  802f1b:	89 f0                	mov    %esi,%eax
  802f1d:	e8 7a ff ff ff       	call   802e9c <_ZL13_pipeisclosedP2FdP4Pipe>
  802f22:	85 c0                	test   %eax,%eax
  802f24:	75 49                	jne    802f6f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  802f26:	e8 11 de ff ff       	call   800d3c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  802f2b:	8b 43 04             	mov    0x4(%ebx),%eax
  802f2e:	89 c2                	mov    %eax,%edx
  802f30:	2b 13                	sub    (%ebx),%edx
  802f32:	83 fa 20             	cmp    $0x20,%edx
  802f35:	74 e2                	je     802f19 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f37:	89 c2                	mov    %eax,%edx
  802f39:	c1 fa 1f             	sar    $0x1f,%edx
  802f3c:	c1 ea 1b             	shr    $0x1b,%edx
  802f3f:	01 d0                	add    %edx,%eax
  802f41:	83 e0 1f             	and    $0x1f,%eax
  802f44:	29 d0                	sub    %edx,%eax
  802f46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f49:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  802f4d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  802f51:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802f55:	83 c7 01             	add    $0x1,%edi
  802f58:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802f5b:	76 0e                	jbe    802f6b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  802f5d:	8b 43 04             	mov    0x4(%ebx),%eax
  802f60:	89 c2                	mov    %eax,%edx
  802f62:	2b 13                	sub    (%ebx),%edx
  802f64:	83 fa 20             	cmp    $0x20,%edx
  802f67:	74 b0                	je     802f19 <_ZL13devpipe_writeP2FdPKvj+0x23>
  802f69:	eb cc                	jmp    802f37 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  802f6b:	89 f8                	mov    %edi,%eax
  802f6d:	eb 05                	jmp    802f74 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  802f6f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  802f74:	83 c4 1c             	add    $0x1c,%esp
  802f77:	5b                   	pop    %ebx
  802f78:	5e                   	pop    %esi
  802f79:	5f                   	pop    %edi
  802f7a:	5d                   	pop    %ebp
  802f7b:	c3                   	ret    

00802f7c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f7c:	55                   	push   %ebp
  802f7d:	89 e5                	mov    %esp,%ebp
  802f7f:	83 ec 28             	sub    $0x28,%esp
  802f82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802f85:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802f88:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802f8b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802f8e:	89 3c 24             	mov    %edi,(%esp)
  802f91:	e8 36 e3 ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  802f96:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802f98:	be 00 00 00 00       	mov    $0x0,%esi
  802f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fa1:	75 47                	jne    802fea <_ZL12devpipe_readP2FdPvj+0x6e>
  802fa3:	eb 52                	jmp    802ff7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  802fa5:	89 f0                	mov    %esi,%eax
  802fa7:	eb 5e                	jmp    803007 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  802fa9:	89 da                	mov    %ebx,%edx
  802fab:	89 f8                	mov    %edi,%eax
  802fad:	8d 76 00             	lea    0x0(%esi),%esi
  802fb0:	e8 e7 fe ff ff       	call   802e9c <_ZL13_pipeisclosedP2FdP4Pipe>
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	75 49                	jne    803002 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  802fb9:	e8 7e dd ff ff       	call   800d3c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802fbe:	8b 03                	mov    (%ebx),%eax
  802fc0:	3b 43 04             	cmp    0x4(%ebx),%eax
  802fc3:	74 e4                	je     802fa9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fc5:	89 c2                	mov    %eax,%edx
  802fc7:	c1 fa 1f             	sar    $0x1f,%edx
  802fca:	c1 ea 1b             	shr    $0x1b,%edx
  802fcd:	01 d0                	add    %edx,%eax
  802fcf:	83 e0 1f             	and    $0x1f,%eax
  802fd2:	29 d0                	sub    %edx,%eax
  802fd4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fdc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  802fdf:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802fe2:	83 c6 01             	add    $0x1,%esi
  802fe5:	39 75 10             	cmp    %esi,0x10(%ebp)
  802fe8:	76 0d                	jbe    802ff7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  802fea:	8b 03                	mov    (%ebx),%eax
  802fec:	3b 43 04             	cmp    0x4(%ebx),%eax
  802fef:	75 d4                	jne    802fc5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  802ff1:	85 f6                	test   %esi,%esi
  802ff3:	75 b0                	jne    802fa5 <_ZL12devpipe_readP2FdPvj+0x29>
  802ff5:	eb b2                	jmp    802fa9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  802ff7:	89 f0                	mov    %esi,%eax
  802ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803000:	eb 05                	jmp    803007 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803002:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803007:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80300a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80300d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803010:	89 ec                	mov    %ebp,%esp
  803012:	5d                   	pop    %ebp
  803013:	c3                   	ret    

00803014 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803014:	55                   	push   %ebp
  803015:	89 e5                	mov    %esp,%ebp
  803017:	83 ec 48             	sub    $0x48,%esp
  80301a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80301d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803020:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803023:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803026:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803029:	89 04 24             	mov    %eax,(%esp)
  80302c:	e8 b6 e2 ff ff       	call   8012e7 <_Z14fd_find_unusedPP2Fd>
  803031:	89 c3                	mov    %eax,%ebx
  803033:	85 c0                	test   %eax,%eax
  803035:	0f 88 0b 01 00 00    	js     803146 <_Z4pipePi+0x132>
  80303b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803042:	00 
  803043:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80304a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803051:	e8 1a dd ff ff       	call   800d70 <_Z14sys_page_allociPvi>
  803056:	89 c3                	mov    %eax,%ebx
  803058:	85 c0                	test   %eax,%eax
  80305a:	0f 89 f5 00 00 00    	jns    803155 <_Z4pipePi+0x141>
  803060:	e9 e1 00 00 00       	jmp    803146 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803065:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80306c:	00 
  80306d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803070:	89 44 24 04          	mov    %eax,0x4(%esp)
  803074:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80307b:	e8 f0 dc ff ff       	call   800d70 <_Z14sys_page_allociPvi>
  803080:	89 c3                	mov    %eax,%ebx
  803082:	85 c0                	test   %eax,%eax
  803084:	0f 89 e2 00 00 00    	jns    80316c <_Z4pipePi+0x158>
  80308a:	e9 a4 00 00 00       	jmp    803133 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80308f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803092:	89 04 24             	mov    %eax,(%esp)
  803095:	e8 32 e2 ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  80309a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8030a1:	00 
  8030a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8030ad:	00 
  8030ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030b9:	e8 11 dd ff ff       	call   800dcf <_Z12sys_page_mapiPviS_i>
  8030be:	89 c3                	mov    %eax,%ebx
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	78 4c                	js     803110 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8030c4:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8030ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8030cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8030d9:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8030df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8030e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8030ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f1:	89 04 24             	mov    %eax,(%esp)
  8030f4:	e8 8b e1 ff ff       	call   801284 <_Z6fd2numP2Fd>
  8030f9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8030fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fe:	89 04 24             	mov    %eax,(%esp)
  803101:	e8 7e e1 ff ff       	call   801284 <_Z6fd2numP2Fd>
  803106:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803109:	bb 00 00 00 00       	mov    $0x0,%ebx
  80310e:	eb 36                	jmp    803146 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803110:	89 74 24 04          	mov    %esi,0x4(%esp)
  803114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80311b:	e8 0d dd ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803120:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803123:	89 44 24 04          	mov    %eax,0x4(%esp)
  803127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80312e:	e8 fa dc ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80313a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803141:	e8 e7 dc ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803146:	89 d8                	mov    %ebx,%eax
  803148:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80314b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80314e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803151:	89 ec                	mov    %ebp,%esp
  803153:	5d                   	pop    %ebp
  803154:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803155:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803158:	89 04 24             	mov    %eax,(%esp)
  80315b:	e8 87 e1 ff ff       	call   8012e7 <_Z14fd_find_unusedPP2Fd>
  803160:	89 c3                	mov    %eax,%ebx
  803162:	85 c0                	test   %eax,%eax
  803164:	0f 89 fb fe ff ff    	jns    803065 <_Z4pipePi+0x51>
  80316a:	eb c7                	jmp    803133 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80316c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316f:	89 04 24             	mov    %eax,(%esp)
  803172:	e8 55 e1 ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  803177:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803179:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803180:	00 
  803181:	89 44 24 04          	mov    %eax,0x4(%esp)
  803185:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80318c:	e8 df db ff ff       	call   800d70 <_Z14sys_page_allociPvi>
  803191:	89 c3                	mov    %eax,%ebx
  803193:	85 c0                	test   %eax,%eax
  803195:	0f 89 f4 fe ff ff    	jns    80308f <_Z4pipePi+0x7b>
  80319b:	eb 83                	jmp    803120 <_Z4pipePi+0x10c>

0080319d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80319d:	55                   	push   %ebp
  80319e:	89 e5                	mov    %esp,%ebp
  8031a0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8031a3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8031aa:	00 
  8031ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	89 04 24             	mov    %eax,(%esp)
  8031b8:	e8 74 e0 ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	78 15                	js     8031d6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	89 04 24             	mov    %eax,(%esp)
  8031c7:	e8 00 e1 ff ff       	call   8012cc <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  8031cc:	89 c2                	mov    %eax,%edx
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	e8 c6 fc ff ff       	call   802e9c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8031d6:	c9                   	leave  
  8031d7:	c3                   	ret    

008031d8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8031d8:	55                   	push   %ebp
  8031d9:	89 e5                	mov    %esp,%ebp
  8031db:	53                   	push   %ebx
  8031dc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8031df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031e2:	89 04 24             	mov    %eax,(%esp)
  8031e5:	e8 fd e0 ff ff       	call   8012e7 <_Z14fd_find_unusedPP2Fd>
  8031ea:	89 c3                	mov    %eax,%ebx
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	0f 88 be 00 00 00    	js     8032b2 <_Z18pipe_ipc_recv_readv+0xda>
  8031f4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031fb:	00 
  8031fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  803203:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80320a:	e8 61 db ff ff       	call   800d70 <_Z14sys_page_allociPvi>
  80320f:	89 c3                	mov    %eax,%ebx
  803211:	85 c0                	test   %eax,%eax
  803213:	0f 89 a1 00 00 00    	jns    8032ba <_Z18pipe_ipc_recv_readv+0xe2>
  803219:	e9 94 00 00 00       	jmp    8032b2 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80321e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	75 0e                	jne    803233 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803225:	c7 04 24 5c 55 80 00 	movl   $0x80555c,(%esp)
  80322c:	e8 41 d0 ff ff       	call   800272 <_Z7cprintfPKcz>
  803231:	eb 10                	jmp    803243 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803233:	89 44 24 04          	mov    %eax,0x4(%esp)
  803237:	c7 04 24 11 55 80 00 	movl   $0x805511,(%esp)
  80323e:	e8 2f d0 ff ff       	call   800272 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803243:	c7 04 24 1b 55 80 00 	movl   $0x80551b,(%esp)
  80324a:	e8 23 d0 ff ff       	call   800272 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80324f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803252:	a8 04                	test   $0x4,%al
  803254:	74 04                	je     80325a <_Z18pipe_ipc_recv_readv+0x82>
  803256:	a8 01                	test   $0x1,%al
  803258:	75 24                	jne    80327e <_Z18pipe_ipc_recv_readv+0xa6>
  80325a:	c7 44 24 0c 2e 55 80 	movl   $0x80552e,0xc(%esp)
  803261:	00 
  803262:	c7 44 24 08 0a 4b 80 	movl   $0x804b0a,0x8(%esp)
  803269:	00 
  80326a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803271:	00 
  803272:	c7 04 24 4b 55 80 00 	movl   $0x80554b,(%esp)
  803279:	e8 d6 ce ff ff       	call   800154 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80327e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803293:	89 04 24             	mov    %eax,(%esp)
  803296:	e8 e9 df ff ff       	call   801284 <_Z6fd2numP2Fd>
  80329b:	89 c3                	mov    %eax,%ebx
  80329d:	eb 13                	jmp    8032b2 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80329f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032ad:	e8 7b db ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  8032b2:	89 d8                	mov    %ebx,%eax
  8032b4:	83 c4 24             	add    $0x24,%esp
  8032b7:	5b                   	pop    %ebx
  8032b8:	5d                   	pop    %ebp
  8032b9:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	89 04 24             	mov    %eax,(%esp)
  8032c0:	e8 07 e0 ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  8032c5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8032c8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8032cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8032d3:	89 04 24             	mov    %eax,(%esp)
  8032d6:	e8 f5 10 00 00       	call   8043d0 <_Z8ipc_recvPiPvS_>
  8032db:	89 c3                	mov    %eax,%ebx
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	0f 89 39 ff ff ff    	jns    80321e <_Z18pipe_ipc_recv_readv+0x46>
  8032e5:	eb b8                	jmp    80329f <_Z18pipe_ipc_recv_readv+0xc7>

008032e7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  8032e7:	55                   	push   %ebp
  8032e8:	89 e5                	mov    %esp,%ebp
  8032ea:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  8032ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8032f4:	00 
  8032f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ff:	89 04 24             	mov    %eax,(%esp)
  803302:	e8 2a df ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  803307:	85 c0                	test   %eax,%eax
  803309:	78 2f                	js     80333a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	89 04 24             	mov    %eax,(%esp)
  803311:	e8 b6 df ff ff       	call   8012cc <_Z7fd2dataP2Fd>
  803316:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80331d:	00 
  80331e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803322:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803329:	00 
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	89 04 24             	mov    %eax,(%esp)
  803330:	e8 2a 11 00 00       	call   80445f <_Z8ipc_sendijPvi>
    return 0;
  803335:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80333a:	c9                   	leave  
  80333b:	c3                   	ret    

0080333c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80333c:	55                   	push   %ebp
  80333d:	89 e5                	mov    %esp,%ebp
  80333f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803342:	89 d0                	mov    %edx,%eax
  803344:	c1 e8 16             	shr    $0x16,%eax
  803347:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  80334e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803353:	f6 c1 01             	test   $0x1,%cl
  803356:	74 1d                	je     803375 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803358:	c1 ea 0c             	shr    $0xc,%edx
  80335b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803362:	f6 c2 01             	test   $0x1,%dl
  803365:	74 0e                	je     803375 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803367:	c1 ea 0c             	shr    $0xc,%edx
  80336a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803371:	ef 
  803372:	0f b7 c0             	movzwl %ax,%eax
}
  803375:	5d                   	pop    %ebp
  803376:	c3                   	ret    
	...

00803380 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803380:	55                   	push   %ebp
  803381:	89 e5                	mov    %esp,%ebp
  803383:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803386:	c7 44 24 04 7f 55 80 	movl   $0x80557f,0x4(%esp)
  80338d:	00 
  80338e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803391:	89 04 24             	mov    %eax,(%esp)
  803394:	e8 f1 d4 ff ff       	call   80088a <_Z6strcpyPcPKc>
	return 0;
}
  803399:	b8 00 00 00 00       	mov    $0x0,%eax
  80339e:	c9                   	leave  
  80339f:	c3                   	ret    

008033a0 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8033a0:	55                   	push   %ebp
  8033a1:	89 e5                	mov    %esp,%ebp
  8033a3:	53                   	push   %ebx
  8033a4:	83 ec 14             	sub    $0x14,%esp
  8033a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8033aa:	89 1c 24             	mov    %ebx,(%esp)
  8033ad:	e8 8a ff ff ff       	call   80333c <_Z7pagerefPv>
  8033b2:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8033b4:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8033b9:	83 fa 01             	cmp    $0x1,%edx
  8033bc:	75 0b                	jne    8033c9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8033be:	8b 43 0c             	mov    0xc(%ebx),%eax
  8033c1:	89 04 24             	mov    %eax,(%esp)
  8033c4:	e8 fe 02 00 00       	call   8036c7 <_Z11nsipc_closei>
	else
		return 0;
}
  8033c9:	83 c4 14             	add    $0x14,%esp
  8033cc:	5b                   	pop    %ebx
  8033cd:	5d                   	pop    %ebp
  8033ce:	c3                   	ret    

008033cf <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8033cf:	55                   	push   %ebp
  8033d0:	89 e5                	mov    %esp,%ebp
  8033d2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8033d5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8033dc:	00 
  8033dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8033e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f1:	89 04 24             	mov    %eax,(%esp)
  8033f4:	e8 c9 03 00 00       	call   8037c2 <_Z10nsipc_sendiPKvij>
}
  8033f9:	c9                   	leave  
  8033fa:	c3                   	ret    

008033fb <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8033fb:	55                   	push   %ebp
  8033fc:	89 e5                	mov    %esp,%ebp
  8033fe:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803401:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803408:	00 
  803409:	8b 45 10             	mov    0x10(%ebp),%eax
  80340c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803410:	8b 45 0c             	mov    0xc(%ebp),%eax
  803413:	89 44 24 04          	mov    %eax,0x4(%esp)
  803417:	8b 45 08             	mov    0x8(%ebp),%eax
  80341a:	8b 40 0c             	mov    0xc(%eax),%eax
  80341d:	89 04 24             	mov    %eax,(%esp)
  803420:	e8 1d 03 00 00       	call   803742 <_Z10nsipc_recviPvij>
}
  803425:	c9                   	leave  
  803426:	c3                   	ret    

00803427 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803427:	55                   	push   %ebp
  803428:	89 e5                	mov    %esp,%ebp
  80342a:	83 ec 28             	sub    $0x28,%esp
  80342d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803430:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803433:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803435:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803438:	89 04 24             	mov    %eax,(%esp)
  80343b:	e8 a7 de ff ff       	call   8012e7 <_Z14fd_find_unusedPP2Fd>
  803440:	89 c3                	mov    %eax,%ebx
  803442:	85 c0                	test   %eax,%eax
  803444:	78 21                	js     803467 <_ZL12alloc_sockfdi+0x40>
  803446:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80344d:	00 
  80344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803451:	89 44 24 04          	mov    %eax,0x4(%esp)
  803455:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80345c:	e8 0f d9 ff ff       	call   800d70 <_Z14sys_page_allociPvi>
  803461:	89 c3                	mov    %eax,%ebx
  803463:	85 c0                	test   %eax,%eax
  803465:	79 14                	jns    80347b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803467:	89 34 24             	mov    %esi,(%esp)
  80346a:	e8 58 02 00 00       	call   8036c7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  80346f:	89 d8                	mov    %ebx,%eax
  803471:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803474:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803477:	89 ec                	mov    %ebp,%esp
  803479:	5d                   	pop    %ebp
  80347a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  80347b:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803490:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803493:	89 04 24             	mov    %eax,(%esp)
  803496:	e8 e9 dd ff ff       	call   801284 <_Z6fd2numP2Fd>
  80349b:	89 c3                	mov    %eax,%ebx
  80349d:	eb d0                	jmp    80346f <_ZL12alloc_sockfdi+0x48>

0080349f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80349f:	55                   	push   %ebp
  8034a0:	89 e5                	mov    %esp,%ebp
  8034a2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  8034a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8034ac:	00 
  8034ad:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8034b0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8034b4:	89 04 24             	mov    %eax,(%esp)
  8034b7:	e8 75 dd ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	78 15                	js     8034d5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8034c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  8034c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8034c8:	8b 0d 3c 60 80 00    	mov    0x80603c,%ecx
  8034ce:	39 0a                	cmp    %ecx,(%edx)
  8034d0:	75 03                	jne    8034d5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8034d2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8034d5:	c9                   	leave  
  8034d6:	c3                   	ret    

008034d7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034d7:	55                   	push   %ebp
  8034d8:	89 e5                	mov    %esp,%ebp
  8034da:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	e8 ba ff ff ff       	call   80349f <_ZL9fd2sockidi>
  8034e5:	85 c0                	test   %eax,%eax
  8034e7:	78 1f                	js     803508 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8034e9:	8b 55 10             	mov    0x10(%ebp),%edx
  8034ec:	89 54 24 08          	mov    %edx,0x8(%esp)
  8034f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8034f7:	89 04 24             	mov    %eax,(%esp)
  8034fa:	e8 19 01 00 00       	call   803618 <_Z12nsipc_acceptiP8sockaddrPj>
  8034ff:	85 c0                	test   %eax,%eax
  803501:	78 05                	js     803508 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803503:	e8 1f ff ff ff       	call   803427 <_ZL12alloc_sockfdi>
}
  803508:	c9                   	leave  
  803509:	c3                   	ret    

0080350a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80350a:	55                   	push   %ebp
  80350b:	89 e5                	mov    %esp,%ebp
  80350d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	e8 87 ff ff ff       	call   80349f <_ZL9fd2sockidi>
  803518:	85 c0                	test   %eax,%eax
  80351a:	78 16                	js     803532 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80351c:	8b 55 10             	mov    0x10(%ebp),%edx
  80351f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803523:	8b 55 0c             	mov    0xc(%ebp),%edx
  803526:	89 54 24 04          	mov    %edx,0x4(%esp)
  80352a:	89 04 24             	mov    %eax,(%esp)
  80352d:	e8 34 01 00 00       	call   803666 <_Z10nsipc_bindiP8sockaddrj>
}
  803532:	c9                   	leave  
  803533:	c3                   	ret    

00803534 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803534:	55                   	push   %ebp
  803535:	89 e5                	mov    %esp,%ebp
  803537:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	e8 5d ff ff ff       	call   80349f <_ZL9fd2sockidi>
  803542:	85 c0                	test   %eax,%eax
  803544:	78 0f                	js     803555 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803546:	8b 55 0c             	mov    0xc(%ebp),%edx
  803549:	89 54 24 04          	mov    %edx,0x4(%esp)
  80354d:	89 04 24             	mov    %eax,(%esp)
  803550:	e8 50 01 00 00       	call   8036a5 <_Z14nsipc_shutdownii>
}
  803555:	c9                   	leave  
  803556:	c3                   	ret    

00803557 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803557:	55                   	push   %ebp
  803558:	89 e5                	mov    %esp,%ebp
  80355a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	e8 3a ff ff ff       	call   80349f <_ZL9fd2sockidi>
  803565:	85 c0                	test   %eax,%eax
  803567:	78 16                	js     80357f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803569:	8b 55 10             	mov    0x10(%ebp),%edx
  80356c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803570:	8b 55 0c             	mov    0xc(%ebp),%edx
  803573:	89 54 24 04          	mov    %edx,0x4(%esp)
  803577:	89 04 24             	mov    %eax,(%esp)
  80357a:	e8 62 01 00 00       	call   8036e1 <_Z13nsipc_connectiPK8sockaddrj>
}
  80357f:	c9                   	leave  
  803580:	c3                   	ret    

00803581 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803581:	55                   	push   %ebp
  803582:	89 e5                	mov    %esp,%ebp
  803584:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	e8 10 ff ff ff       	call   80349f <_ZL9fd2sockidi>
  80358f:	85 c0                	test   %eax,%eax
  803591:	78 0f                	js     8035a2 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803593:	8b 55 0c             	mov    0xc(%ebp),%edx
  803596:	89 54 24 04          	mov    %edx,0x4(%esp)
  80359a:	89 04 24             	mov    %eax,(%esp)
  80359d:	e8 7e 01 00 00       	call   803720 <_Z12nsipc_listenii>
}
  8035a2:	c9                   	leave  
  8035a3:	c3                   	ret    

008035a4 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8035a4:	55                   	push   %ebp
  8035a5:	89 e5                	mov    %esp,%ebp
  8035a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8035aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8035ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8035b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	89 04 24             	mov    %eax,(%esp)
  8035be:	e8 72 02 00 00       	call   803835 <_Z12nsipc_socketiii>
  8035c3:	85 c0                	test   %eax,%eax
  8035c5:	78 05                	js     8035cc <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  8035c7:	e8 5b fe ff ff       	call   803427 <_ZL12alloc_sockfdi>
}
  8035cc:	c9                   	leave  
  8035cd:	8d 76 00             	lea    0x0(%esi),%esi
  8035d0:	c3                   	ret    
  8035d1:	00 00                	add    %al,(%eax)
	...

008035d4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035d4:	55                   	push   %ebp
  8035d5:	89 e5                	mov    %esp,%ebp
  8035d7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035da:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8035e1:	00 
  8035e2:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8035e9:	00 
  8035ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035ee:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  8035f5:	e8 65 0e 00 00       	call   80445f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  8035fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803601:	00 
  803602:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803609:	00 
  80360a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803611:	e8 ba 0d 00 00       	call   8043d0 <_Z8ipc_recvPiPvS_>
}
  803616:	c9                   	leave  
  803617:	c3                   	ret    

00803618 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803618:	55                   	push   %ebp
  803619:	89 e5                	mov    %esp,%ebp
  80361b:	53                   	push   %ebx
  80361c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803627:	b8 01 00 00 00       	mov    $0x1,%eax
  80362c:	e8 a3 ff ff ff       	call   8035d4 <_ZL5nsipcj>
  803631:	89 c3                	mov    %eax,%ebx
  803633:	85 c0                	test   %eax,%eax
  803635:	78 27                	js     80365e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803637:	a1 10 80 80 00       	mov    0x808010,%eax
  80363c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803640:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803647:	00 
  803648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364b:	89 04 24             	mov    %eax,(%esp)
  80364e:	e8 d9 d3 ff ff       	call   800a2c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803653:	8b 15 10 80 80 00    	mov    0x808010,%edx
  803659:	8b 45 10             	mov    0x10(%ebp),%eax
  80365c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  80365e:	89 d8                	mov    %ebx,%eax
  803660:	83 c4 14             	add    $0x14,%esp
  803663:	5b                   	pop    %ebx
  803664:	5d                   	pop    %ebp
  803665:	c3                   	ret    

00803666 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803666:	55                   	push   %ebp
  803667:	89 e5                	mov    %esp,%ebp
  803669:	53                   	push   %ebx
  80366a:	83 ec 14             	sub    $0x14,%esp
  80366d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803678:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80367c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80367f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803683:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80368a:	e8 9d d3 ff ff       	call   800a2c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80368f:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803695:	b8 02 00 00 00       	mov    $0x2,%eax
  80369a:	e8 35 ff ff ff       	call   8035d4 <_ZL5nsipcj>
}
  80369f:	83 c4 14             	add    $0x14,%esp
  8036a2:	5b                   	pop    %ebx
  8036a3:	5d                   	pop    %ebp
  8036a4:	c3                   	ret    

008036a5 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  8036a5:	55                   	push   %ebp
  8036a6:	89 e5                	mov    %esp,%ebp
  8036a8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8036ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ae:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8036b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b6:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8036bb:	b8 03 00 00 00       	mov    $0x3,%eax
  8036c0:	e8 0f ff ff ff       	call   8035d4 <_ZL5nsipcj>
}
  8036c5:	c9                   	leave  
  8036c6:	c3                   	ret    

008036c7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  8036c7:	55                   	push   %ebp
  8036c8:	89 e5                	mov    %esp,%ebp
  8036ca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8036d5:	b8 04 00 00 00       	mov    $0x4,%eax
  8036da:	e8 f5 fe ff ff       	call   8035d4 <_ZL5nsipcj>
}
  8036df:	c9                   	leave  
  8036e0:	c3                   	ret    

008036e1 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036e1:	55                   	push   %ebp
  8036e2:	89 e5                	mov    %esp,%ebp
  8036e4:	53                   	push   %ebx
  8036e5:	83 ec 14             	sub    $0x14,%esp
  8036e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8036eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ee:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8036f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036fe:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803705:	e8 22 d3 ff ff       	call   800a2c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80370a:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803710:	b8 05 00 00 00       	mov    $0x5,%eax
  803715:	e8 ba fe ff ff       	call   8035d4 <_ZL5nsipcj>
}
  80371a:	83 c4 14             	add    $0x14,%esp
  80371d:	5b                   	pop    %ebx
  80371e:	5d                   	pop    %ebp
  80371f:	c3                   	ret    

00803720 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803720:	55                   	push   %ebp
  803721:	89 e5                	mov    %esp,%ebp
  803723:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803726:	8b 45 08             	mov    0x8(%ebp),%eax
  803729:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  80372e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803731:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803736:	b8 06 00 00 00       	mov    $0x6,%eax
  80373b:	e8 94 fe ff ff       	call   8035d4 <_ZL5nsipcj>
}
  803740:	c9                   	leave  
  803741:	c3                   	ret    

00803742 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803742:	55                   	push   %ebp
  803743:	89 e5                	mov    %esp,%ebp
  803745:	56                   	push   %esi
  803746:	53                   	push   %ebx
  803747:	83 ec 10             	sub    $0x10,%esp
  80374a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80374d:	8b 45 08             	mov    0x8(%ebp),%eax
  803750:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803755:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80375b:	8b 45 14             	mov    0x14(%ebp),%eax
  80375e:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803763:	b8 07 00 00 00       	mov    $0x7,%eax
  803768:	e8 67 fe ff ff       	call   8035d4 <_ZL5nsipcj>
  80376d:	89 c3                	mov    %eax,%ebx
  80376f:	85 c0                	test   %eax,%eax
  803771:	78 46                	js     8037b9 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803773:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803778:	7f 04                	jg     80377e <_Z10nsipc_recviPvij+0x3c>
  80377a:	39 f0                	cmp    %esi,%eax
  80377c:	7e 24                	jle    8037a2 <_Z10nsipc_recviPvij+0x60>
  80377e:	c7 44 24 0c 8b 55 80 	movl   $0x80558b,0xc(%esp)
  803785:	00 
  803786:	c7 44 24 08 0a 4b 80 	movl   $0x804b0a,0x8(%esp)
  80378d:	00 
  80378e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803795:	00 
  803796:	c7 04 24 a0 55 80 00 	movl   $0x8055a0,(%esp)
  80379d:	e8 b2 c9 ff ff       	call   800154 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8037a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037a6:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8037ad:	00 
  8037ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b1:	89 04 24             	mov    %eax,(%esp)
  8037b4:	e8 73 d2 ff ff       	call   800a2c <memmove>
	}

	return r;
}
  8037b9:	89 d8                	mov    %ebx,%eax
  8037bb:	83 c4 10             	add    $0x10,%esp
  8037be:	5b                   	pop    %ebx
  8037bf:	5e                   	pop    %esi
  8037c0:	5d                   	pop    %ebp
  8037c1:	c3                   	ret    

008037c2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8037c2:	55                   	push   %ebp
  8037c3:	89 e5                	mov    %esp,%ebp
  8037c5:	53                   	push   %ebx
  8037c6:	83 ec 14             	sub    $0x14,%esp
  8037c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8037cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cf:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8037d4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8037da:	7e 24                	jle    803800 <_Z10nsipc_sendiPKvij+0x3e>
  8037dc:	c7 44 24 0c ac 55 80 	movl   $0x8055ac,0xc(%esp)
  8037e3:	00 
  8037e4:	c7 44 24 08 0a 4b 80 	movl   $0x804b0a,0x8(%esp)
  8037eb:	00 
  8037ec:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  8037f3:	00 
  8037f4:	c7 04 24 a0 55 80 00 	movl   $0x8055a0,(%esp)
  8037fb:	e8 54 c9 ff ff       	call   800154 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803800:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803804:	8b 45 0c             	mov    0xc(%ebp),%eax
  803807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80380b:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  803812:	e8 15 d2 ff ff       	call   800a2c <memmove>
	nsipcbuf.send.req_size = size;
  803817:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  80381d:	8b 45 14             	mov    0x14(%ebp),%eax
  803820:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  803825:	b8 08 00 00 00       	mov    $0x8,%eax
  80382a:	e8 a5 fd ff ff       	call   8035d4 <_ZL5nsipcj>
}
  80382f:	83 c4 14             	add    $0x14,%esp
  803832:	5b                   	pop    %ebx
  803833:	5d                   	pop    %ebp
  803834:	c3                   	ret    

00803835 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803835:	55                   	push   %ebp
  803836:	89 e5                	mov    %esp,%ebp
  803838:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80383b:	8b 45 08             	mov    0x8(%ebp),%eax
  80383e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803843:	8b 45 0c             	mov    0xc(%ebp),%eax
  803846:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  80384b:	8b 45 10             	mov    0x10(%ebp),%eax
  80384e:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  803853:	b8 09 00 00 00       	mov    $0x9,%eax
  803858:	e8 77 fd ff ff       	call   8035d4 <_ZL5nsipcj>
}
  80385d:	c9                   	leave  
  80385e:	c3                   	ret    
	...

00803860 <_Z12mach_connectPiS_>:

static int to_mach_sock = -1, from_mach_sock = -1;

int
mach_connect(int *writesock, int *readsock)
{
  803860:	55                   	push   %ebp
  803861:	89 e5                	mov    %esp,%ebp
  803863:	83 ec 48             	sub    $0x48,%esp
  803866:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803869:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80386c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80386f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803872:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct sockaddr_in server;

    if(!(writesock && readsock))
  803875:	85 db                	test   %ebx,%ebx
  803877:	0f 84 6a 01 00 00    	je     8039e7 <_Z12mach_connectPiS_+0x187>
  80387d:	85 ff                	test   %edi,%edi
  80387f:	0f 84 62 01 00 00    	je     8039e7 <_Z12mach_connectPiS_+0x187>
        return -1;

    // for now, only one connection is allowed, so if it has already been made
    // return it
    if(to_mach_sock != -1)
  803885:	a1 58 60 80 00       	mov    0x806058,%eax
  80388a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80388d:	74 13                	je     8038a2 <_Z12mach_connectPiS_+0x42>
    {
        *writesock = to_mach_sock;
  80388f:	89 03                	mov    %eax,(%ebx)
        *readsock = from_mach_sock;
  803891:	a1 5c 60 80 00       	mov    0x80605c,%eax
  803896:	89 07                	mov    %eax,(%edi)
        return 0;
  803898:	b8 00 00 00 00       	mov    $0x0,%eax
  80389d:	e9 5f 01 00 00       	jmp    803a01 <_Z12mach_connectPiS_+0x1a1>
    if(!(writesock && readsock))
        return -1;

    // for now, only one connection is allowed, so if it has already been made
    // return it
    if(to_mach_sock != -1)
  8038a2:	be 01 00 00 00       	mov    $0x1,%esi
	    // Create the TCP socket
	    if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
		    return -1;
	    
        // Construct the server sockaddr_in structure
        memset(&server, 0, sizeof(server));       // Clear struct
  8038a7:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8038aa:	89 7d d0             	mov    %edi,-0x30(%ebp)

    for (int i = 0; i < 2; i++)
    {
	    int sock, port;
	    // Create the TCP socket
	    if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8038ad:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8038b4:	00 
  8038b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8038bc:	00 
  8038bd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8038c4:	e8 db fc ff ff       	call   8035a4 <_Z6socketiii>
  8038c9:	89 c7                	mov    %eax,%edi
  8038cb:	85 c0                	test   %eax,%eax
  8038cd:	0f 88 1b 01 00 00    	js     8039ee <_Z12mach_connectPiS_+0x18e>
		    return -1;
	    
        // Construct the server sockaddr_in structure
        memset(&server, 0, sizeof(server));       // Clear struct
  8038d3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8038da:	00 
  8038db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8038e2:	00 
  8038e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8038e6:	89 04 24             	mov    %eax,(%esp)
  8038e9:	e8 e3 d0 ff ff       	call   8009d1 <memset>
        server.sin_family = AF_INET;                  // Internet/IP
  8038ee:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
        server.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8038f2:	c7 04 24 b8 55 80 00 	movl   $0x8055b8,(%esp)
  8038f9:	e8 16 0f 00 00       	call   804814 <inet_addr>
  8038fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803901:	89 f3                	mov    %esi,%ebx
        
        switch(MACHINE + 2 * i)
  803903:	83 fe 01             	cmp    $0x1,%esi
  803906:	74 38                	je     803940 <_Z12mach_connectPiS_+0xe0>
  803908:	83 fe 01             	cmp    $0x1,%esi
  80390b:	7f 09                	jg     803916 <_Z12mach_connectPiS_+0xb6>
  80390d:	85 f6                	test   %esi,%esi
  80390f:	74 17                	je     803928 <_Z12mach_connectPiS_+0xc8>
  803911:	e9 df 00 00 00       	jmp    8039f5 <_Z12mach_connectPiS_+0x195>
  803916:	83 fe 02             	cmp    $0x2,%esi
  803919:	74 17                	je     803932 <_Z12mach_connectPiS_+0xd2>
  80391b:	83 fe 03             	cmp    $0x3,%esi
  80391e:	66 90                	xchg   %ax,%ax
  803920:	0f 85 cf 00 00 00    	jne    8039f5 <_Z12mach_connectPiS_+0x195>
  803926:	eb 11                	jmp    803939 <_Z12mach_connectPiS_+0xd9>
        {
            case 0: port = TOPORT1; break;
  803928:	b8 d1 04 00 00       	mov    $0x4d1,%eax
  80392d:	8d 76 00             	lea    0x0(%esi),%esi
  803930:	eb 13                	jmp    803945 <_Z12mach_connectPiS_+0xe5>
            case 1: port = FROMPORT1; break;
            case 2: port = FROMPORT2; break;
  803932:	b8 d4 04 00 00       	mov    $0x4d4,%eax
  803937:	eb 0c                	jmp    803945 <_Z12mach_connectPiS_+0xe5>
            case 3: port = TOPORT2; break;
  803939:	b8 d3 04 00 00       	mov    $0x4d3,%eax
  80393e:	eb 05                	jmp    803945 <_Z12mach_connectPiS_+0xe5>
        server.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
        
        switch(MACHINE + 2 * i)
        {
            case 0: port = TOPORT1; break;
            case 1: port = FROMPORT1; break;
  803940:	b8 d2 04 00 00       	mov    $0x4d2,%eax
            case 2: port = FROMPORT2; break;
            case 3: port = TOPORT2; break;
            default: port = 0; return -1;
        }

        server.sin_port = htons(port);  // server port
  803945:	89 04 24             	mov    %eax,(%esp)
  803948:	e8 6c 0c 00 00       	call   8045b9 <htons>
  80394d:	66 89 45 da          	mov    %ax,-0x26(%ebp)

        // Establish connection
        if (connect(sock, (struct sockaddr *) &server, sizeof(server)) < 0)
  803951:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  803958:	00 
  803959:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80395c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803960:	89 3c 24             	mov    %edi,(%esp)
  803963:	e8 ef fb ff ff       	call   803557 <_Z7connectiPK8sockaddrj>
  803968:	85 c0                	test   %eax,%eax
  80396a:	0f 88 8c 00 00 00    	js     8039fc <_Z12mach_connectPiS_+0x19c>
            return -1;

        cprintf("connected to server\n");
  803970:	c7 04 24 c1 55 80 00 	movl   $0x8055c1,(%esp)
  803977:	e8 f6 c8 ff ff       	call   800272 <_Z7cprintfPKcz>
        switch(MACHINE + 2 * i)
  80397c:	83 fb 01             	cmp    $0x1,%ebx
  80397f:	74 29                	je     8039aa <_Z12mach_connectPiS_+0x14a>
  803981:	83 fb 01             	cmp    $0x1,%ebx
  803984:	7f 0c                	jg     803992 <_Z12mach_connectPiS_+0x132>
  803986:	85 db                	test   %ebx,%ebx
  803988:	74 18                	je     8039a2 <_Z12mach_connectPiS_+0x142>
  80398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803990:	eb 2e                	jmp    8039c0 <_Z12mach_connectPiS_+0x160>
  803992:	83 fb 02             	cmp    $0x2,%ebx
  803995:	74 1b                	je     8039b2 <_Z12mach_connectPiS_+0x152>
  803997:	83 fb 03             	cmp    $0x3,%ebx
  80399a:	75 24                	jne    8039c0 <_Z12mach_connectPiS_+0x160>
  80399c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8039a0:	eb 18                	jmp    8039ba <_Z12mach_connectPiS_+0x15a>
        {
            case 0: to_mach_sock = sock; break;
  8039a2:	89 3d 58 60 80 00    	mov    %edi,0x806058
  8039a8:	eb 16                	jmp    8039c0 <_Z12mach_connectPiS_+0x160>
            case 1: from_mach_sock = sock; break;
  8039aa:	89 3d 5c 60 80 00    	mov    %edi,0x80605c
  8039b0:	eb 0e                	jmp    8039c0 <_Z12mach_connectPiS_+0x160>
            case 2: from_mach_sock = sock; break;
  8039b2:	89 3d 5c 60 80 00    	mov    %edi,0x80605c
  8039b8:	eb 06                	jmp    8039c0 <_Z12mach_connectPiS_+0x160>
            case 3: to_mach_sock = sock; break;
  8039ba:	89 3d 58 60 80 00    	mov    %edi,0x806058
  8039c0:	83 c6 02             	add    $0x2,%esi
        *writesock = to_mach_sock;
        *readsock = from_mach_sock;
        return 0;
    }

    for (int i = 0; i < 2; i++)
  8039c3:	83 fe 05             	cmp    $0x5,%esi
  8039c6:	0f 85 e1 fe ff ff    	jne    8038ad <_Z12mach_connectPiS_+0x4d>
  8039cc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8039cf:	8b 7d d0             	mov    -0x30(%ebp),%edi
            case 1: from_mach_sock = sock; break;
            case 2: from_mach_sock = sock; break;
            case 3: to_mach_sock = sock; break;
        }
    }
    *writesock = to_mach_sock;
  8039d2:	a1 58 60 80 00       	mov    0x806058,%eax
  8039d7:	89 03                	mov    %eax,(%ebx)
    *readsock = from_mach_sock;
  8039d9:	a1 5c 60 80 00       	mov    0x80605c,%eax
  8039de:	89 07                	mov    %eax,(%edi)
    return 0;
  8039e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e5:	eb 1a                	jmp    803a01 <_Z12mach_connectPiS_+0x1a1>
mach_connect(int *writesock, int *readsock)
{
	struct sockaddr_in server;

    if(!(writesock && readsock))
        return -1;
  8039e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8039ec:	eb 13                	jmp    803a01 <_Z12mach_connectPiS_+0x1a1>
    for (int i = 0; i < 2; i++)
    {
	    int sock, port;
	    // Create the TCP socket
	    if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
		    return -1;
  8039ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8039f3:	eb 0c                	jmp    803a01 <_Z12mach_connectPiS_+0x1a1>
        {
            case 0: port = TOPORT1; break;
            case 1: port = FROMPORT1; break;
            case 2: port = FROMPORT2; break;
            case 3: port = TOPORT2; break;
            default: port = 0; return -1;
  8039f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8039fa:	eb 05                	jmp    803a01 <_Z12mach_connectPiS_+0x1a1>

        server.sin_port = htons(port);  // server port

        // Establish connection
        if (connect(sock, (struct sockaddr *) &server, sizeof(server)) < 0)
            return -1;
  8039fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }
    }
    *writesock = to_mach_sock;
    *readsock = from_mach_sock;
    return 0;
}
  803a01:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803a04:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803a07:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803a0a:	89 ec                	mov    %ebp,%esp
  803a0c:	5d                   	pop    %ebp
  803a0d:	c3                   	ret    
	...

00803a10 <_ZL18migrate_send_stateiP9Trapframe>:

/*
 * Precondition and postcondition: f is a handle on an open file.
 */
static int
migrate_send_state(int f, struct Trapframe *tf) {
  803a10:	55                   	push   %ebp
  803a11:	89 e5                	mov    %esp,%ebp
  803a13:	57                   	push   %edi
  803a14:	56                   	push   %esi
  803a15:	53                   	push   %ebx
  803a16:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  803a1c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  803a1f:	89 d6                	mov    %edx,%esi

	const size_t n_pages = UTOP >> 12;
	// Manual "div round up", so that truncation doesn't lead us to miss pages
    const size_t n_pdx = (UTOP >> 22) + (UTOP % (1 << 22) == 0 ? 0 : 1);

	cprintf("[%08x]: entering migrate_send_state\n", thisenv->env_id);	
  803a21:	a1 00 70 80 00       	mov    0x807000,%eax
  803a26:	8b 40 04             	mov    0x4(%eax),%eax
  803a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a2d:	c7 04 24 d8 55 80 00 	movl   $0x8055d8,(%esp)
  803a34:	e8 39 c8 ff ff       	call   800272 <_Z7cprintfPKcz>

	uint32_t n_used_pages = 0;
	unsigned pn;
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
  803a39:	ba 00 00 00 00       	mov    $0x0,%edx
	// Manual "div round up", so that truncation doesn't lead us to miss pages
    const size_t n_pdx = (UTOP >> 22) + (UTOP % (1 << 22) == 0 ? 0 : 1);

	cprintf("[%08x]: entering migrate_send_state\n", thisenv->env_id);	

	uint32_t n_used_pages = 0;
  803a3e:	bb 00 00 00 00       	mov    $0x0,%ebx
	unsigned pn;
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
        if(vpd[pdx] & PTE_P) {
  803a43:	8b 04 95 00 e0 bb ef 	mov    -0x10442000(,%edx,4),%eax
  803a4a:	a8 01                	test   $0x1,%al
  803a4c:	74 2a                	je     803a78 <_ZL18migrate_send_stateiP9Trapframe+0x68>
            for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
  803a4e:	89 d0                	mov    %edx,%eax
  803a50:	c1 e0 0a             	shl    $0xa,%eax
  803a53:	3d ff ef 0e 00       	cmp    $0xeefff,%eax
  803a58:	77 1e                	ja     803a78 <_ZL18migrate_send_stateiP9Trapframe+0x68>
  803a5a:	89 c1                	mov    %eax,%ecx
  803a5c:	c1 e9 0a             	shr    $0xa,%ecx
  803a5f:	39 d1                	cmp    %edx,%ecx
  803a61:	75 15                	jne    803a78 <_ZL18migrate_send_stateiP9Trapframe+0x68>
				if(vpt[pn] & PTE_P) {
  803a63:	8b 0c 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%ecx
  803a6a:	83 e1 01             	and    $0x1,%ecx
					n_used_pages++;
  803a6d:	83 f9 01             	cmp    $0x1,%ecx
  803a70:	83 db ff             	sbb    $0xffffffff,%ebx

	uint32_t n_used_pages = 0;
	unsigned pn;
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
        if(vpd[pdx] & PTE_P) {
            for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
  803a73:	83 c0 01             	add    $0x1,%eax
  803a76:	eb db                	jmp    803a53 <_ZL18migrate_send_stateiP9Trapframe+0x43>

	cprintf("[%08x]: entering migrate_send_state\n", thisenv->env_id);	

	uint32_t n_used_pages = 0;
	unsigned pn;
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
  803a78:	83 c2 01             	add    $0x1,%edx
  803a7b:	81 fa bc 03 00 00    	cmp    $0x3bc,%edx
  803a81:	75 c0                	jne    803a43 <_ZL18migrate_send_stateiP9Trapframe+0x33>
					n_used_pages++;
				}
			}
		}
	}
	sh.msh_n_pages = n_used_pages;
  803a83:	89 5d 94             	mov    %ebx,-0x6c(%ebp)
    sh.msh_pgfault_upcall = thisenv->env_pgfault_upcall;
  803a86:	a1 00 70 80 00       	mov    0x807000,%eax
  803a8b:	8b 40 5c             	mov    0x5c(%eax),%eax
  803a8e:	89 45 90             	mov    %eax,-0x70(%ebp)
	sh.msh_magic = MIGRATE_MAGIC;
  803a91:	c7 45 8c de ca fa 1e 	movl   $0x1efacade,-0x74(%ebp)
	sh.msh_tf = *tf;
  803a98:	8d 7d 98             	lea    -0x68(%ebp),%edi
  803a9b:	b9 11 00 00 00       	mov    $0x11,%ecx
  803aa0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	if ((r = write(f, &sh, sizeof(struct MigrateSuperHeader)))
  803aa2:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  803aa9:	00 
  803aaa:	8d 45 8c             	lea    -0x74(%ebp),%eax
  803aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ab1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  803ab4:	89 04 24             	mov    %eax,(%esp)
  803ab7:	e8 0d dc ff ff       	call   8016c9 <_Z5writeiPKvj>
  803abc:	83 f8 50             	cmp    $0x50,%eax
  803abf:	74 0f                	je     803ad0 <_ZL18migrate_send_stateiP9Trapframe+0xc0>
				!= sizeof(struct MigrateSuperHeader)) {
		r = r < 0 ? r : -E_IO;
  803ac1:	85 c0                	test   %eax,%eax
  803ac3:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  803ac8:	0f 49 c2             	cmovns %edx,%eax
  803acb:	e9 14 01 00 00       	jmp    803be4 <_ZL18migrate_send_stateiP9Trapframe+0x1d4>
		return r;
	}
	
	cprintf("[%08x]: migrate_send_state: sent super header\n", thisenv->env_id);	
  803ad0:	a1 00 70 80 00       	mov    0x807000,%eax
  803ad5:	8b 40 04             	mov    0x4(%eax),%eax
  803ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803adc:	c7 04 24 00 56 80 00 	movl   $0x805600,(%esp)
  803ae3:	e8 8a c7 ff ff       	call   800272 <_Z7cprintfPKcz>
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
  803ae8:	bf 00 00 00 00       	mov    $0x0,%edi
        if(vpd[pdx] & PTE_P) {
  803aed:	8b 04 bd 00 e0 bb ef 	mov    -0x10442000(,%edi,4),%eax
  803af4:	a8 01                	test   $0x1,%al
  803af6:	0f 84 bc 00 00 00    	je     803bb8 <_ZL18migrate_send_stateiP9Trapframe+0x1a8>
			for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
  803afc:	89 fe                	mov    %edi,%esi
  803afe:	c1 e6 0a             	shl    $0xa,%esi
  803b01:	e9 91 00 00 00       	jmp    803b97 <_ZL18migrate_send_stateiP9Trapframe+0x187>
				if(vpt[pn] & PTE_P) {
					h.mph_magic = MIGRATE_PG_MAGIC;
  803b06:	c7 45 dc 42 de ca de 	movl   $0xdecade42,-0x24(%ebp)
					h.mph_addr = (void *)VA_OF_VPN(pn);	
  803b0d:	89 f0                	mov    %esi,%eax
  803b0f:	c1 e0 0c             	shl    $0xc,%eax
  803b12:	89 45 e0             	mov    %eax,-0x20(%ebp)
					h.mph_perm = vpt[pn] & PTE_SYSCALL;
  803b15:	8b 04 b5 00 00 80 ef 	mov    -0x10800000(,%esi,4),%eax
  803b1c:	25 07 0e 00 00       	and    $0xe07,%eax
  803b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					if ((r = write(f, &h, sizeof(struct MigratePageHeader)))
  803b24:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  803b2b:	00 
  803b2c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  803b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b33:	8b 45 84             	mov    -0x7c(%ebp),%eax
  803b36:	89 04 24             	mov    %eax,(%esp)
  803b39:	e8 8b db ff ff       	call   8016c9 <_Z5writeiPKvj>
  803b3e:	83 f8 0c             	cmp    $0xc,%eax
  803b41:	74 0f                	je     803b52 <_ZL18migrate_send_stateiP9Trapframe+0x142>
							!= sizeof(struct MigratePageHeader)) {
						return r < 0 ? r : -E_IO;
  803b43:	85 c0                	test   %eax,%eax
  803b45:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  803b4a:	0f 49 c2             	cmovns %edx,%eax
  803b4d:	e9 92 00 00 00       	jmp    803be4 <_ZL18migrate_send_stateiP9Trapframe+0x1d4>
			for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
				if(vpt[pn] & PTE_P) {
					h.mph_magic = MIGRATE_PG_MAGIC;
					h.mph_addr = (void *)VA_OF_VPN(pn);	
					h.mph_perm = vpt[pn] & PTE_SYSCALL;
					if ((r = write(f, &h, sizeof(struct MigratePageHeader)))
  803b52:	bb 00 00 00 00       	mov    $0x0,%ebx
							!= sizeof(struct MigratePageHeader)) {
						return r < 0 ? r : -E_IO;
					}
                    for(int i = 0; i < 4; i++)
                    {
					    if ((r = write(f, (char *)h.mph_addr + PGSIZE / 4 * i, PGSIZE/4)) != PGSIZE/4) {
  803b57:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  803b5e:	00 
  803b5f:	89 d8                	mov    %ebx,%eax
  803b61:	03 45 e0             	add    -0x20(%ebp),%eax
  803b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b68:	8b 45 84             	mov    -0x7c(%ebp),%eax
  803b6b:	89 04 24             	mov    %eax,(%esp)
  803b6e:	e8 56 db ff ff       	call   8016c9 <_Z5writeiPKvj>
  803b73:	3d 00 04 00 00       	cmp    $0x400,%eax
  803b78:	74 0c                	je     803b86 <_ZL18migrate_send_stateiP9Trapframe+0x176>
						    return r < 0 ? r : -E_IO;
  803b7a:	85 c0                	test   %eax,%eax
  803b7c:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  803b81:	0f 49 c2             	cmovns %edx,%eax
  803b84:	eb 5e                	jmp    803be4 <_ZL18migrate_send_stateiP9Trapframe+0x1d4>
  803b86:	81 c3 00 04 00 00    	add    $0x400,%ebx
					h.mph_perm = vpt[pn] & PTE_SYSCALL;
					if ((r = write(f, &h, sizeof(struct MigratePageHeader)))
							!= sizeof(struct MigratePageHeader)) {
						return r < 0 ? r : -E_IO;
					}
                    for(int i = 0; i < 4; i++)
  803b8c:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  803b92:	75 c3                	jne    803b57 <_ZL18migrate_send_stateiP9Trapframe+0x147>
	}
	
	cprintf("[%08x]: migrate_send_state: sent super header\n", thisenv->env_id);	
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
        if(vpd[pdx] & PTE_P) {
			for (pn = pdx << 10; pn < n_pages && (pn >> 10) == pdx; pn++) {
  803b94:	83 c6 01             	add    $0x1,%esi
  803b97:	81 fe ff ef 0e 00    	cmp    $0xeefff,%esi
  803b9d:	77 19                	ja     803bb8 <_ZL18migrate_send_stateiP9Trapframe+0x1a8>
  803b9f:	89 f0                	mov    %esi,%eax
  803ba1:	c1 e8 0a             	shr    $0xa,%eax
  803ba4:	39 f8                	cmp    %edi,%eax
  803ba6:	75 10                	jne    803bb8 <_ZL18migrate_send_stateiP9Trapframe+0x1a8>
				if(vpt[pn] & PTE_P) {
  803ba8:	8b 04 b5 00 00 80 ef 	mov    -0x10800000(,%esi,4),%eax
  803baf:	a8 01                	test   $0x1,%al
  803bb1:	74 e1                	je     803b94 <_ZL18migrate_send_stateiP9Trapframe+0x184>
  803bb3:	e9 4e ff ff ff       	jmp    803b06 <_ZL18migrate_send_stateiP9Trapframe+0xf6>
		r = r < 0 ? r : -E_IO;
		return r;
	}
	
	cprintf("[%08x]: migrate_send_state: sent super header\n", thisenv->env_id);	
    for (unsigned pdx = 0; pdx < n_pdx; pdx++) {
  803bb8:	83 c7 01             	add    $0x1,%edi
  803bbb:	81 ff bc 03 00 00    	cmp    $0x3bc,%edi
  803bc1:	0f 85 26 ff ff ff    	jne    803aed <_ZL18migrate_send_stateiP9Trapframe+0xdd>
            }
        }
    }

	cprintf("[%08x]: migrate_send_state: done sending pages.\n",
				thisenv->env_id);
  803bc7:	a1 00 70 80 00       	mov    0x807000,%eax
  803bcc:	8b 40 04             	mov    0x4(%eax),%eax
  803bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bd3:	c7 04 24 30 56 80 00 	movl   $0x805630,(%esp)
  803bda:	e8 93 c6 ff ff       	call   800272 <_Z7cprintfPKcz>

	return 0;
  803bdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803be4:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  803bea:	5b                   	pop    %ebx
  803beb:	5e                   	pop    %esi
  803bec:	5f                   	pop    %edi
  803bed:	5d                   	pop    %ebp
  803bee:	c3                   	ret    

00803bef <_ZL8mig_helpv>:
/*
 * Migrate, resuming execution at [callback].
 * This function returns < 0 on error.  On success, it does not return.
 */
static 
int mig_help(void) {
  803bef:	55                   	push   %ebp
  803bf0:	89 e5                	mov    %esp,%ebp
  803bf2:	83 ec 18             	sub    $0x18,%esp
    cprintf("wtf\n");
  803bf5:	c7 04 24 7d 58 80 00 	movl   $0x80587d,(%esp)
  803bfc:	e8 71 c6 ff ff       	call   800272 <_Z7cprintfPKcz>
    thisenv = &envs[ENVX(sys_getenvid())];
  803c01:	e8 02 d1 ff ff       	call   800d08 <_Z12sys_getenvidv>
  803c06:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c0b:	6b c0 78             	imul   $0x78,%eax,%eax
  803c0e:	8d 90 00 00 00 ef    	lea    -0x11000000(%eax),%edx
  803c14:	89 15 00 70 80 00    	mov    %edx,0x807000
    cprintf("%x\n", thisenv->env_id);
  803c1a:	8b 80 04 00 00 ef    	mov    -0x10fffffc(%eax),%eax
  803c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c24:	c7 04 24 17 55 80 00 	movl   $0x805517,(%esp)
  803c2b:	e8 42 c6 ff ff       	call   800272 <_Z7cprintfPKcz>
    return 0;
}
  803c30:	b8 00 00 00 00       	mov    $0x0,%eax
  803c35:	c9                   	leave  
  803c36:	c3                   	ret    

00803c37 <_Z13migrate_spawni>:
/*
 * Pre-condition: f is the file descriptor number of an open file descriptor.
 * The caller is responsible for closing this file.
 */
int
migrate_spawn(int f) {
  803c37:	55                   	push   %ebp
  803c38:	89 e5                	mov    %esp,%ebp
  803c3a:	57                   	push   %edi
  803c3b:	56                   	push   %esi
  803c3c:	53                   	push   %ebx
  803c3d:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  803c43:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	struct MigrateSuperHeader sh;
	struct MigratePageHeader h;

	cprintf("[%08x] starting migrate_spawn\n", thisenv->env_id);
  803c46:	a1 00 70 80 00       	mov    0x807000,%eax
  803c4b:	8b 40 04             	mov    0x4(%eax),%eax
  803c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c52:	c7 04 24 64 56 80 00 	movl   $0x805664,(%esp)
  803c59:	e8 14 c6 ff ff       	call   800272 <_Z7cprintfPKcz>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  803c5e:	bf 07 00 00 00       	mov    $0x7,%edi
  803c63:	89 f8                	mov    %edi,%eax
  803c65:	cd 30                	int    $0x30
  803c67:	89 c7                	mov    %eax,%edi
  803c69:	89 45 84             	mov    %eax,-0x7c(%ebp)
	envid_t envid = sys_exofork();
	if (envid < 0) {
  803c6c:	85 c0                	test   %eax,%eax
  803c6e:	0f 88 f4 02 00 00    	js     803f68 <_Z13migrate_spawni+0x331>
		return envid;
	}
	if (envid == 0) {
  803c74:	85 c0                	test   %eax,%eax
  803c76:	75 1c                	jne    803c94 <_Z13migrate_spawni+0x5d>
		panic("migrate_spawn: unreachable code in the child");
  803c78:	c7 44 24 08 84 56 80 	movl   $0x805684,0x8(%esp)
  803c7f:	00 
  803c80:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803c87:	00 
  803c88:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  803c8f:	e8 c0 c4 ff ff       	call   800154 <_Z6_panicPKciS0_z>
	}
	

	if ((r = readn(f, &sh, sizeof(struct MigrateSuperHeader)))
  803c94:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  803c9b:	00 
  803c9c:	8d 45 8c             	lea    -0x74(%ebp),%eax
  803c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ca3:	89 34 24             	mov    %esi,(%esp)
  803ca6:	e8 cd d9 ff ff       	call   801678 <_Z5readniPvj>
  803cab:	89 c3                	mov    %eax,%ebx
  803cad:	83 f8 50             	cmp    $0x50,%eax
  803cb0:	74 0f                	je     803cc1 <_Z13migrate_spawni+0x8a>
			!= sizeof(struct MigrateSuperHeader)) {
		r = (r < 0) ? r : -E_IO;
  803cb2:	85 c0                	test   %eax,%eax
  803cb4:	b8 ec ff ff ff       	mov    $0xffffffec,%eax
  803cb9:	0f 49 d8             	cmovns %eax,%ebx
  803cbc:	e9 9c 02 00 00       	jmp    803f5d <_Z13migrate_spawni+0x326>
		goto cleanup;
	}

	if (sh.msh_magic != MIGRATE_MAGIC) {
		// XXX: should we be make some custom error codes for migration?
		r = -E_NOT_EXEC;
  803cc1:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
			!= sizeof(struct MigrateSuperHeader)) {
		r = (r < 0) ? r : -E_IO;
		goto cleanup;
	}

	if (sh.msh_magic != MIGRATE_MAGIC) {
  803cc6:	81 7d 8c de ca fa 1e 	cmpl   $0x1efacade,-0x74(%ebp)
  803ccd:	0f 85 8a 02 00 00    	jne    803f5d <_Z13migrate_spawni+0x326>
		// XXX: should we be make some custom error codes for migration?
		r = -E_NOT_EXEC;
		goto cleanup;
	}
	cprintf("[%08x] migrate_spawn: read superheader\n", thisenv->env_id);
  803cd3:	a1 00 70 80 00       	mov    0x807000,%eax
  803cd8:	8b 40 04             	mov    0x4(%eax),%eax
  803cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cdf:	c7 04 24 b4 56 80 00 	movl   $0x8056b4,(%esp)
  803ce6:	e8 87 c5 ff ff       	call   800272 <_Z7cprintfPKcz>
	
	for (uint32_t i = 0; i < sh.msh_n_pages; i++) {
  803ceb:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  803cef:	0f 84 85 01 00 00    	je     803e7a <_Z13migrate_spawni+0x243>
  803cf5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if ((r = readn(f, &h, sizeof(struct MigratePageHeader)))
  803cfa:	89 7d 80             	mov    %edi,-0x80(%ebp)
  803cfd:	89 df                	mov    %ebx,%edi
  803cff:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  803d06:	00 
  803d07:	8d 45 dc             	lea    -0x24(%ebp),%eax
  803d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d0e:	89 34 24             	mov    %esi,(%esp)
  803d11:	e8 62 d9 ff ff       	call   801678 <_Z5readniPvj>
  803d16:	83 f8 0c             	cmp    $0xc,%eax
  803d19:	74 2a                	je     803d45 <_Z13migrate_spawni+0x10e>
				!= sizeof(struct MigratePageHeader)) {
			r = (r < 0) ? r : -E_IO;
  803d1b:	85 c0                	test   %eax,%eax
  803d1d:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  803d22:	0f 49 c2             	cmovns %edx,%eax
			panic("migrate_spawn: read page header: %e\n", r);
  803d25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d29:	c7 44 24 08 dc 56 80 	movl   $0x8056dc,0x8(%esp)
  803d30:	00 
  803d31:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  803d38:	00 
  803d39:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  803d40:	e8 0f c4 ff ff       	call   800154 <_Z6_panicPKciS0_z>
			goto cleanup;
		}
		if (h.mph_magic != MIGRATE_PG_MAGIC) {
  803d45:	81 7d dc 42 de ca de 	cmpl   $0xdecade42,-0x24(%ebp)
  803d4c:	74 24                	je     803d72 <_Z13migrate_spawni+0x13b>
			r =  -E_NOT_EXEC;
			panic("migrate_spawn: magic check failed. %e\n", r);
  803d4e:	c7 44 24 0c f7 ff ff 	movl   $0xfffffff7,0xc(%esp)
  803d55:	ff 
  803d56:	c7 44 24 08 04 57 80 	movl   $0x805704,0x8(%esp)
  803d5d:	00 
  803d5e:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803d65:	00 
  803d66:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  803d6d:	e8 e2 c3 ff ff       	call   800154 <_Z6_panicPKciS0_z>
			goto cleanup;
		}

		if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0) {
  803d72:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803d79:	00 
  803d7a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  803d81:	00 
  803d82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d89:	e8 e2 cf ff ff       	call   800d70 <_Z14sys_page_allociPvi>
  803d8e:	85 c0                	test   %eax,%eax
  803d90:	79 20                	jns    803db2 <_Z13migrate_spawni+0x17b>
			panic("migrate_spawn: alloc page at UTEMP: %e\n", r);
  803d92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d96:	c7 44 24 08 2c 57 80 	movl   $0x80572c,0x8(%esp)
  803d9d:	00 
  803d9e:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  803da5:	00 
  803da6:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  803dad:	e8 a2 c3 ff ff       	call   800154 <_Z6_panicPKciS0_z>
			r =  -E_NOT_EXEC;
			panic("migrate_spawn: magic check failed. %e\n", r);
			goto cleanup;
		}

		if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0) {
  803db2:	bb 00 00 40 00       	mov    $0x400000,%ebx
			panic("migrate_spawn: alloc page at UTEMP: %e\n", r);
			goto cleanup;
		}
        for(int i = 0; i < 4; i++)
        {
            if ((r = readn(f, (char *)UTEMP + PGSIZE / 4 * i, PGSIZE/4)) != PGSIZE/4) {
  803db7:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  803dbe:	00 
  803dbf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803dc3:	89 34 24             	mov    %esi,(%esp)
  803dc6:	e8 ad d8 ff ff       	call   801678 <_Z5readniPvj>
  803dcb:	3d 00 04 00 00       	cmp    $0x400,%eax
  803dd0:	74 2a                	je     803dfc <_Z13migrate_spawni+0x1c5>
                r = (r < 0) ? r : -E_IO;
  803dd2:	85 c0                	test   %eax,%eax
  803dd4:	ba ec ff ff ff       	mov    $0xffffffec,%edx
  803dd9:	0f 49 c2             	cmovns %edx,%eax
                panic("migrate_spawn: read page:  %e\n", r);
  803ddc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803de0:	c7 44 24 08 54 57 80 	movl   $0x805754,0x8(%esp)
  803de7:	00 
  803de8:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  803def:	00 
  803df0:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  803df7:	e8 58 c3 ff ff       	call   800154 <_Z6_panicPKciS0_z>
  803dfc:	81 c3 00 04 00 00    	add    $0x400,%ebx

		if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0) {
			panic("migrate_spawn: alloc page at UTEMP: %e\n", r);
			goto cleanup;
		}
        for(int i = 0; i < 4; i++)
  803e02:	81 fb 00 10 40 00    	cmp    $0x401000,%ebx
  803e08:	75 ad                	jne    803db7 <_Z13migrate_spawni+0x180>
                goto cleanup;
            } 
        }
		

		if ((r = sys_page_map(0, UTEMP, envid, h.mph_addr, h.mph_perm)) < 0) {
  803e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  803e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e14:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e18:	8b 45 84             	mov    -0x7c(%ebp),%eax
  803e1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  803e1f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  803e26:	00 
  803e27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e2e:	e8 9c cf ff ff       	call   800dcf <_Z12sys_page_mapiPviS_i>
  803e33:	85 c0                	test   %eax,%eax
  803e35:	79 20                	jns    803e57 <_Z13migrate_spawni+0x220>
			panic("migrate_spawn: sys_page_map: %e\n", r);
  803e37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e3b:	c7 44 24 08 74 57 80 	movl   $0x805774,0x8(%esp)
  803e42:	00 
  803e43:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  803e4a:	00 
  803e4b:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  803e52:	e8 fd c2 ff ff       	call   800154 <_Z6_panicPKciS0_z>
			sys_page_unmap(0, UTEMP);
			goto cleanup;
		}

		sys_page_unmap(0, UTEMP);
  803e57:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  803e5e:	00 
  803e5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e66:	e8 c2 cf ff ff       	call   800e2d <_Z14sys_page_unmapiPv>
		r = -E_NOT_EXEC;
		goto cleanup;
	}
	cprintf("[%08x] migrate_spawn: read superheader\n", thisenv->env_id);
	
	for (uint32_t i = 0; i < sh.msh_n_pages; i++) {
  803e6b:	83 c7 01             	add    $0x1,%edi
  803e6e:	39 7d 94             	cmp    %edi,-0x6c(%ebp)
  803e71:	0f 87 88 fe ff ff    	ja     803cff <_Z13migrate_spawni+0xc8>
  803e77:	8b 7d 80             	mov    -0x80(%ebp),%edi
			goto cleanup;
		}

		sys_page_unmap(0, UTEMP);
	}
	cprintf("[%08x] migrate_spawn: done reading pages\n", thisenv->env_id);
  803e7a:	a1 00 70 80 00       	mov    0x807000,%eax
  803e7f:	8b 40 04             	mov    0x4(%eax),%eax
  803e82:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e86:	c7 04 24 98 57 80 00 	movl   $0x805798,(%esp)
  803e8d:	e8 e0 c3 ff ff       	call   800272 <_Z7cprintfPKcz>
    cprintf("%08x\n", sh.msh_pgfault_upcall);
  803e92:	8b 45 90             	mov    -0x70(%ebp),%eax
  803e95:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e99:	c7 04 24 90 58 80 00 	movl   $0x805890,(%esp)
  803ea0:	e8 cd c3 ff ff       	call   800272 <_Z7cprintfPKcz>
	if ((r = sys_env_set_pgfault_upcall(envid, &sh.msh_pgfault_upcall)) < 0) {
  803ea5:	8d 45 90             	lea    -0x70(%ebp),%eax
  803ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eac:	89 3c 24             	mov    %edi,(%esp)
  803eaf:	e8 f1 d0 ff ff       	call   800fa5 <_Z26sys_env_set_pgfault_upcalliPv>
  803eb4:	85 c0                	test   %eax,%eax
  803eb6:	79 20                	jns    803ed8 <_Z13migrate_spawni+0x2a1>
		panic("migrate_spawn: sys_env_set_pgfault_upcall%e\n", r);
  803eb8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ebc:	c7 44 24 08 c4 57 80 	movl   $0x8057c4,0x8(%esp)
  803ec3:	00 
  803ec4:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
  803ecb:	00 
  803ecc:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  803ed3:	e8 7c c2 ff ff       	call   800154 <_Z6_panicPKciS0_z>
		goto cleanup;
	}
	if ((r = sys_env_set_trapframe(envid, &sh.msh_tf)) < 0) {
  803ed8:	8d 45 98             	lea    -0x68(%ebp),%eax
  803edb:	89 44 24 04          	mov    %eax,0x4(%esp)
  803edf:	89 3c 24             	mov    %edi,(%esp)
  803ee2:	e8 60 d0 ff ff       	call   800f47 <_Z21sys_env_set_trapframeiP9Trapframe>
  803ee7:	85 c0                	test   %eax,%eax
  803ee9:	79 20                	jns    803f0b <_Z13migrate_spawni+0x2d4>
		panic("migrate_spawn: sys_env_set_trapframe%e\n", r);
  803eeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803eef:	c7 44 24 08 f4 57 80 	movl   $0x8057f4,0x8(%esp)
  803ef6:	00 
  803ef7:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  803efe:	00 
  803eff:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  803f06:	e8 49 c2 ff ff       	call   800154 <_Z6_panicPKciS0_z>
		goto cleanup;
	}
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  803f0b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803f12:	00 
  803f13:	89 3c 24             	mov    %edi,(%esp)
  803f16:	e8 70 cf ff ff       	call   800e8b <_Z18sys_env_set_statusii>
  803f1b:	85 c0                	test   %eax,%eax
  803f1d:	79 20                	jns    803f3f <_Z13migrate_spawni+0x308>
		panic("migrate_spawn: sys_env_set_status%e\n", r);
  803f1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f23:	c7 44 24 08 1c 58 80 	movl   $0x80581c,0x8(%esp)
  803f2a:	00 
  803f2b:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  803f32:	00 
  803f33:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  803f3a:	e8 15 c2 ff ff       	call   800154 <_Z6_panicPKciS0_z>
		goto cleanup;
	}
	cprintf("[%08x] migrate_spawn: done, marked env %08x as runnable\n",
				thisenv->env_id, envid);
  803f3f:	a1 00 70 80 00       	mov    0x807000,%eax
  803f44:	8b 40 04             	mov    0x4(%eax),%eax
  803f47:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f4f:	c7 04 24 44 58 80 00 	movl   $0x805844,(%esp)
  803f56:	e8 17 c3 ff ff       	call   800272 <_Z7cprintfPKcz>

	return envid;
  803f5b:	eb 0b                	jmp    803f68 <_Z13migrate_spawni+0x331>

cleanup:
	sys_env_destroy(envid);
  803f5d:	89 3c 24             	mov    %edi,(%esp)
  803f60:	e8 46 cd ff ff       	call   800cab <_Z15sys_env_destroyi>
	return r;
  803f65:	89 5d 84             	mov    %ebx,-0x7c(%ebp)
}
  803f68:	8b 45 84             	mov    -0x7c(%ebp),%eax
  803f6b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803f71:	5b                   	pop    %ebx
  803f72:	5e                   	pop    %esi
  803f73:	5f                   	pop    %edi
  803f74:	5d                   	pop    %ebp
  803f75:	c3                   	ret    

00803f76 <_Z7migratev>:
}

asmlinkage void mig(struct PushRegs *regs, uintptr_t *ebp, uintptr_t *esp);

int
migrate(void) {
  803f76:	55                   	push   %ebp
  803f77:	89 e5                	mov    %esp,%ebp
  803f79:	53                   	push   %ebx
  803f7a:	83 ec 64             	sub    $0x64,%esp
	int r, writesock, readsock;
	int *x = NULL;
    struct Trapframe tf;
    mach_connect(&writesock, &readsock);
  803f7d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f87:	89 04 24             	mov    %eax,(%esp)
  803f8a:	e8 d1 f8 ff ff       	call   803860 <_Z12mach_connectPiS_>
	
    sys_time_msec();
  803f8f:	e8 3a d1 ff ff       	call   8010ce <_Z13sys_time_msecv>
	memcpy(&tf, (const void *)&thisenv->env_tf, sizeof(struct Trapframe));
  803f94:	a1 00 70 80 00       	mov    0x807000,%eax
  803f99:	83 c0 14             	add    $0x14,%eax
  803f9c:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  803fa3:	00 
  803fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fa8:	8d 5d ac             	lea    -0x54(%ebp),%ebx
  803fab:	89 1c 24             	mov    %ebx,(%esp)
  803fae:	e8 f4 ca ff ff       	call   800aa7 <memcpy>
    mig(&tf.tf_regs, &tf.tf_regs.reg_ebp, &tf.tf_esp);
  803fb3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803fb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  803fba:	8d 45 bc             	lea    -0x44(%ebp),%eax
  803fbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fc1:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  803fc4:	89 04 24             	mov    %eax,(%esp)
  803fc7:	e8 04 05 00 00       	call   8044d0 <mig>
    tf.tf_eip = (uintptr_t)mig_help;
  803fcc:	c7 45 dc ef 3b 80 00 	movl   $0x803bef,-0x24(%ebp)
	if ((r = migrate_send_state(writesock, &tf)) < 0) 
  803fd3:	89 da                	mov    %ebx,%edx
  803fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd8:	e8 33 fa ff ff       	call   803a10 <_ZL18migrate_send_stateiP9Trapframe>
  803fdd:	85 c0                	test   %eax,%eax
  803fdf:	79 06                	jns    803fe7 <_Z7migratev+0x71>
		return r;
	
    // Destroy this environment iff we're successful.  Does not return.
	sys_env_destroy(0);
	panic("unreachable code\n");
}
  803fe1:	83 c4 64             	add    $0x64,%esp
  803fe4:	5b                   	pop    %ebx
  803fe5:	5d                   	pop    %ebp
  803fe6:	c3                   	ret    
    tf.tf_eip = (uintptr_t)mig_help;
	if ((r = migrate_send_state(writesock, &tf)) < 0) 
		return r;
	
    // Destroy this environment iff we're successful.  Does not return.
	sys_env_destroy(0);
  803fe7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803fee:	e8 b8 cc ff ff       	call   800cab <_Z15sys_env_destroyi>
	panic("unreachable code\n");
  803ff3:	c7 44 24 08 96 58 80 	movl   $0x805896,0x8(%esp)
  803ffa:	00 
  803ffb:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  804002:	00 
  804003:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  80400a:	e8 45 c1 ff ff       	call   800154 <_Z6_panicPKciS0_z>

0080400f <_Z15migrate_locallyPFvvE>:
/*
 * Migrate locally, resuming execution at [callback].
 * This function returns < 0 on error.  On success, it does not return.
 */
int
migrate_locally(void (*callback)(void)) {
  80400f:	55                   	push   %ebp
  804010:	89 e5                	mov    %esp,%ebp
  804012:	53                   	push   %ebx
  804013:	83 ec 64             	sub    $0x64,%esp
	int r, p[2];
	
	if ((r = pipe(p)) < 0) {
  804016:	8d 45 f0             	lea    -0x10(%ebp),%eax
  804019:	89 04 24             	mov    %eax,(%esp)
  80401c:	e8 f3 ef ff ff       	call   803014 <_Z4pipePi>
  804021:	89 c3                	mov    %eax,%ebx
  804023:	85 c0                	test   %eax,%eax
  804025:	0f 88 9c 00 00 00    	js     8040c7 <_Z15migrate_locallyPFvvE+0xb8>
		goto done;
	}

	// Hook up the read end of our pipe to migrated
	if ((r = pipe_ipc_send(ENVID_MIGRATED, p[0])) < 0) 	{
  80402b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80402e:	89 44 24 04          	mov    %eax,0x4(%esp)
  804032:	c7 04 24 02 11 00 00 	movl   $0x1102,(%esp)
  804039:	e8 a9 f2 ff ff       	call   8032e7 <_Z13pipe_ipc_sendii>
  80403e:	89 c3                	mov    %eax,%ebx
  804040:	85 c0                	test   %eax,%eax
  804042:	78 6d                	js     8040b1 <_Z15migrate_locallyPFvvE+0xa2>
	}

	// XXX: this is not yet right.
	// For now, just wipe the stack.
	struct Trapframe tf;
	memset(&tf, 0, sizeof(struct Trapframe));
  804044:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  80404b:	00 
  80404c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  804053:	00 
  804054:	8d 5d ac             	lea    -0x54(%ebp),%ebx
  804057:	89 1c 24             	mov    %ebx,(%esp)
  80405a:	e8 72 c9 ff ff       	call   8009d1 <memset>

	tf.tf_eip = (uintptr_t)callback;
  80405f:	8b 45 08             	mov    0x8(%ebp),%eax
  804062:	89 45 dc             	mov    %eax,-0x24(%ebp)
	tf.tf_esp = USTACKTOP;
  804065:	c7 45 e8 00 e0 ff ee 	movl   $0xeeffe000,-0x18(%ebp)
	tf.tf_regs.reg_ebp = USTACKTOP;
  80406c:	c7 45 bc 00 e0 ff ee 	movl   $0xeeffe000,-0x44(%ebp)

	tf.tf_ss = 0x3;
  804073:	66 c7 45 ec 03 00    	movw   $0x3,-0x14(%ebp)
	// XXX: eflags (?), cs, es, ds

	if ((r = migrate_send_state(p[1], &tf)) < 0) {
  804079:	89 da                	mov    %ebx,%edx
  80407b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80407e:	e8 8d f9 ff ff       	call   803a10 <_ZL18migrate_send_stateiP9Trapframe>
  804083:	89 c3                	mov    %eax,%ebx
  804085:	85 c0                	test   %eax,%eax
  804087:	78 28                	js     8040b1 <_Z15migrate_locallyPFvvE+0xa2>
		goto cleanup_pipe;
	}

	// Destroy this environment iff we're successful.  Does not return.
	sys_env_destroy(0);
  804089:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804090:	e8 16 cc ff ff       	call   800cab <_Z15sys_env_destroyi>
	panic("unreachable code\n");
  804095:	c7 44 24 08 96 58 80 	movl   $0x805896,0x8(%esp)
  80409c:	00 
  80409d:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  8040a4:	00 
  8040a5:	c7 04 24 82 58 80 00 	movl   $0x805882,(%esp)
  8040ac:	e8 a3 c0 ff ff       	call   800154 <_Z6_panicPKciS0_z>

	// XXX: should this involve pipe_is_closed in some way?
cleanup_pipe:
	close(p[0]);
  8040b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040b4:	89 04 24             	mov    %eax,(%esp)
  8040b7:	e8 79 d3 ff ff       	call   801435 <_Z5closei>
	close(p[1]);
  8040bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040bf:	89 04 24             	mov    %eax,(%esp)
  8040c2:	e8 6e d3 ff ff       	call   801435 <_Z5closei>
done:
	return r;	
}
  8040c7:	89 d8                	mov    %ebx,%eax
  8040c9:	83 c4 64             	add    $0x64,%esp
  8040cc:	5b                   	pop    %ebx
  8040cd:	5d                   	pop    %ebp
  8040ce:	c3                   	ret    
	...

008040d0 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8040d0:	55                   	push   %ebp
  8040d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8040d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d8:	5d                   	pop    %ebp
  8040d9:	c3                   	ret    

008040da <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8040da:	55                   	push   %ebp
  8040db:	89 e5                	mov    %esp,%ebp
  8040dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8040e0:	c7 44 24 04 a8 58 80 	movl   $0x8058a8,0x4(%esp)
  8040e7:	00 
  8040e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040eb:	89 04 24             	mov    %eax,(%esp)
  8040ee:	e8 97 c7 ff ff       	call   80088a <_Z6strcpyPcPKc>
	return 0;
}
  8040f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f8:	c9                   	leave  
  8040f9:	c3                   	ret    

008040fa <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040fa:	55                   	push   %ebp
  8040fb:	89 e5                	mov    %esp,%ebp
  8040fd:	57                   	push   %edi
  8040fe:	56                   	push   %esi
  8040ff:	53                   	push   %ebx
  804100:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804106:	bb 00 00 00 00       	mov    $0x0,%ebx
  80410b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80410f:	74 3e                	je     80414f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804111:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  804117:	8b 75 10             	mov    0x10(%ebp),%esi
  80411a:	29 de                	sub    %ebx,%esi
  80411c:	83 fe 7f             	cmp    $0x7f,%esi
  80411f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  804124:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804127:	89 74 24 08          	mov    %esi,0x8(%esp)
  80412b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80412e:	01 d8                	add    %ebx,%eax
  804130:	89 44 24 04          	mov    %eax,0x4(%esp)
  804134:	89 3c 24             	mov    %edi,(%esp)
  804137:	e8 f0 c8 ff ff       	call   800a2c <memmove>
		sys_cputs(buf, m);
  80413c:	89 74 24 04          	mov    %esi,0x4(%esp)
  804140:	89 3c 24             	mov    %edi,(%esp)
  804143:	e8 fc ca ff ff       	call   800c44 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804148:	01 f3                	add    %esi,%ebx
  80414a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  80414d:	77 c8                	ja     804117 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80414f:	89 d8                	mov    %ebx,%eax
  804151:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  804157:	5b                   	pop    %ebx
  804158:	5e                   	pop    %esi
  804159:	5f                   	pop    %edi
  80415a:	5d                   	pop    %ebp
  80415b:	c3                   	ret    

0080415c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80415c:	55                   	push   %ebp
  80415d:	89 e5                	mov    %esp,%ebp
  80415f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  804162:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  804167:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80416b:	75 07                	jne    804174 <_ZL12devcons_readP2FdPvj+0x18>
  80416d:	eb 2a                	jmp    804199 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80416f:	e8 c8 cb ff ff       	call   800d3c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804174:	e8 fe ca ff ff       	call   800c77 <_Z9sys_cgetcv>
  804179:	85 c0                	test   %eax,%eax
  80417b:	74 f2                	je     80416f <_ZL12devcons_readP2FdPvj+0x13>
  80417d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80417f:	85 c0                	test   %eax,%eax
  804181:	78 16                	js     804199 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  804183:	83 f8 04             	cmp    $0x4,%eax
  804186:	74 0c                	je     804194 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  804188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80418b:	88 10                	mov    %dl,(%eax)
	return 1;
  80418d:	b8 01 00 00 00       	mov    $0x1,%eax
  804192:	eb 05                	jmp    804199 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  804194:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  804199:	c9                   	leave  
  80419a:	c3                   	ret    

0080419b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80419b:	55                   	push   %ebp
  80419c:	89 e5                	mov    %esp,%ebp
  80419e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8041a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8041a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8041ae:	00 
  8041af:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8041b2:	89 04 24             	mov    %eax,(%esp)
  8041b5:	e8 8a ca ff ff       	call   800c44 <_Z9sys_cputsPKcj>
}
  8041ba:	c9                   	leave  
  8041bb:	c3                   	ret    

008041bc <_Z7getcharv>:

int
getchar(void)
{
  8041bc:	55                   	push   %ebp
  8041bd:	89 e5                	mov    %esp,%ebp
  8041bf:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8041c2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8041c9:	00 
  8041ca:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8041cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8041d8:	e8 01 d4 ff ff       	call   8015de <_Z4readiPvj>
	if (r < 0)
  8041dd:	85 c0                	test   %eax,%eax
  8041df:	78 0f                	js     8041f0 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  8041e1:	85 c0                	test   %eax,%eax
  8041e3:	7e 06                	jle    8041eb <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  8041e5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8041e9:	eb 05                	jmp    8041f0 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8041eb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8041f0:	c9                   	leave  
  8041f1:	c3                   	ret    

008041f2 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  8041f2:	55                   	push   %ebp
  8041f3:	89 e5                	mov    %esp,%ebp
  8041f5:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8041f8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8041ff:	00 
  804200:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804203:	89 44 24 04          	mov    %eax,0x4(%esp)
  804207:	8b 45 08             	mov    0x8(%ebp),%eax
  80420a:	89 04 24             	mov    %eax,(%esp)
  80420d:	e8 1f d0 ff ff       	call   801231 <_Z9fd_lookupiPP2Fdb>
  804212:	85 c0                	test   %eax,%eax
  804214:	78 11                	js     804227 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  804216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804219:	8b 15 60 60 80 00    	mov    0x806060,%edx
  80421f:	39 10                	cmp    %edx,(%eax)
  804221:	0f 94 c0             	sete   %al
  804224:	0f b6 c0             	movzbl %al,%eax
}
  804227:	c9                   	leave  
  804228:	c3                   	ret    

00804229 <_Z8openconsv>:

int
opencons(void)
{
  804229:	55                   	push   %ebp
  80422a:	89 e5                	mov    %esp,%ebp
  80422c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80422f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804232:	89 04 24             	mov    %eax,(%esp)
  804235:	e8 ad d0 ff ff       	call   8012e7 <_Z14fd_find_unusedPP2Fd>
  80423a:	85 c0                	test   %eax,%eax
  80423c:	78 3c                	js     80427a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80423e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804245:	00 
  804246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804249:	89 44 24 04          	mov    %eax,0x4(%esp)
  80424d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804254:	e8 17 cb ff ff       	call   800d70 <_Z14sys_page_allociPvi>
  804259:	85 c0                	test   %eax,%eax
  80425b:	78 1d                	js     80427a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80425d:	8b 15 60 60 80 00    	mov    0x806060,%edx
  804263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804266:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  804268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80426b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  804272:	89 04 24             	mov    %eax,(%esp)
  804275:	e8 0a d0 ff ff       	call   801284 <_Z6fd2numP2Fd>
}
  80427a:	c9                   	leave  
  80427b:	c3                   	ret    
  80427c:	00 00                	add    %al,(%eax)
	...

00804280 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  804280:	55                   	push   %ebp
  804281:	89 e5                	mov    %esp,%ebp
  804283:	56                   	push   %esi
  804284:	53                   	push   %ebx
  804285:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804288:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  80428d:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  804294:	85 c0                	test   %eax,%eax
  804296:	74 08                	je     8042a0 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  804298:	8d 55 08             	lea    0x8(%ebp),%edx
  80429b:	89 14 24             	mov    %edx,(%esp)
  80429e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8042a0:	83 eb 01             	sub    $0x1,%ebx
  8042a3:	83 fb ff             	cmp    $0xffffffff,%ebx
  8042a6:	75 e5                	jne    80428d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  8042a8:	8b 5d 38             	mov    0x38(%ebp),%ebx
  8042ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8042ae:	e8 55 ca ff ff       	call   800d08 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  8042b3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8042b7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8042bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042bf:	c7 44 24 08 b4 58 80 	movl   $0x8058b4,0x8(%esp)
  8042c6:	00 
  8042c7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8042ce:	00 
  8042cf:	c7 04 24 38 59 80 00 	movl   $0x805938,(%esp)
  8042d6:	e8 79 be ff ff       	call   800154 <_Z6_panicPKciS0_z>

008042db <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  8042db:	55                   	push   %ebp
  8042dc:	89 e5                	mov    %esp,%ebp
  8042de:	56                   	push   %esi
  8042df:	53                   	push   %ebx
  8042e0:	83 ec 10             	sub    $0x10,%esp
  8042e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  8042e6:	e8 1d ca ff ff       	call   800d08 <_Z12sys_getenvidv>
  8042eb:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  8042ed:	a1 00 70 80 00       	mov    0x807000,%eax
  8042f2:	8b 40 5c             	mov    0x5c(%eax),%eax
  8042f5:	85 c0                	test   %eax,%eax
  8042f7:	75 4c                	jne    804345 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  8042f9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  804300:	00 
  804301:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  804308:	ee 
  804309:	89 34 24             	mov    %esi,(%esp)
  80430c:	e8 5f ca ff ff       	call   800d70 <_Z14sys_page_allociPvi>
  804311:	85 c0                	test   %eax,%eax
  804313:	74 20                	je     804335 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  804315:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804319:	c7 44 24 08 ec 58 80 	movl   $0x8058ec,0x8(%esp)
  804320:	00 
  804321:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  804328:	00 
  804329:	c7 04 24 38 59 80 00 	movl   $0x805938,(%esp)
  804330:	e8 1f be ff ff       	call   800154 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  804335:	c7 44 24 04 80 42 80 	movl   $0x804280,0x4(%esp)
  80433c:	00 
  80433d:	89 34 24             	mov    %esi,(%esp)
  804340:	e8 60 cc ff ff       	call   800fa5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804345:	a1 00 90 80 00       	mov    0x809000,%eax
  80434a:	39 d8                	cmp    %ebx,%eax
  80434c:	74 1a                	je     804368 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  80434e:	85 c0                	test   %eax,%eax
  804350:	74 20                	je     804372 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804352:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804357:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  80435e:	39 da                	cmp    %ebx,%edx
  804360:	74 15                	je     804377 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804362:	85 d2                	test   %edx,%edx
  804364:	75 1f                	jne    804385 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804366:	eb 0f                	jmp    804377 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804368:	b8 00 00 00 00       	mov    $0x0,%eax
  80436d:	8d 76 00             	lea    0x0(%esi),%esi
  804370:	eb 05                	jmp    804377 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804372:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804377:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80437e:	83 c4 10             	add    $0x10,%esp
  804381:	5b                   	pop    %ebx
  804382:	5e                   	pop    %esi
  804383:	5d                   	pop    %ebp
  804384:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804385:	83 c0 01             	add    $0x1,%eax
  804388:	83 f8 08             	cmp    $0x8,%eax
  80438b:	75 ca                	jne    804357 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80438d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804391:	c7 44 24 08 10 59 80 	movl   $0x805910,0x8(%esp)
  804398:	00 
  804399:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8043a0:	00 
  8043a1:	c7 04 24 38 59 80 00 	movl   $0x805938,(%esp)
  8043a8:	e8 a7 bd ff ff       	call   800154 <_Z6_panicPKciS0_z>
  8043ad:	00 00                	add    %al,(%eax)
	...

008043b0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  8043b0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  8043b3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  8043b4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  8043b7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  8043bb:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  8043bf:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  8043c2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  8043c4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  8043c8:	61                   	popa   
    popf
  8043c9:	9d                   	popf   
    popl %esp
  8043ca:	5c                   	pop    %esp
    ret
  8043cb:	c3                   	ret    

008043cc <spin>:

spin:	jmp spin
  8043cc:	eb fe                	jmp    8043cc <spin>
	...

008043d0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8043d0:	55                   	push   %ebp
  8043d1:	89 e5                	mov    %esp,%ebp
  8043d3:	56                   	push   %esi
  8043d4:	53                   	push   %ebx
  8043d5:	83 ec 10             	sub    $0x10,%esp
  8043d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8043db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043de:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  8043e1:	85 c0                	test   %eax,%eax
  8043e3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8043e8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  8043eb:	89 04 24             	mov    %eax,(%esp)
  8043ee:	e8 48 cc ff ff       	call   80103b <_Z12sys_ipc_recvPv>
  8043f3:	85 c0                	test   %eax,%eax
  8043f5:	79 16                	jns    80440d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  8043f7:	85 db                	test   %ebx,%ebx
  8043f9:	74 06                	je     804401 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  8043fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804401:	85 f6                	test   %esi,%esi
  804403:	74 53                	je     804458 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804405:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80440b:	eb 4b                	jmp    804458 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80440d:	85 db                	test   %ebx,%ebx
  80440f:	74 17                	je     804428 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804411:	e8 f2 c8 ff ff       	call   800d08 <_Z12sys_getenvidv>
  804416:	25 ff 03 00 00       	and    $0x3ff,%eax
  80441b:	6b c0 78             	imul   $0x78,%eax,%eax
  80441e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804423:	8b 40 60             	mov    0x60(%eax),%eax
  804426:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804428:	85 f6                	test   %esi,%esi
  80442a:	74 17                	je     804443 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80442c:	e8 d7 c8 ff ff       	call   800d08 <_Z12sys_getenvidv>
  804431:	25 ff 03 00 00       	and    $0x3ff,%eax
  804436:	6b c0 78             	imul   $0x78,%eax,%eax
  804439:	05 00 00 00 ef       	add    $0xef000000,%eax
  80443e:	8b 40 70             	mov    0x70(%eax),%eax
  804441:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  804443:	e8 c0 c8 ff ff       	call   800d08 <_Z12sys_getenvidv>
  804448:	25 ff 03 00 00       	and    $0x3ff,%eax
  80444d:	6b c0 78             	imul   $0x78,%eax,%eax
  804450:	05 08 00 00 ef       	add    $0xef000008,%eax
  804455:	8b 40 60             	mov    0x60(%eax),%eax

}
  804458:	83 c4 10             	add    $0x10,%esp
  80445b:	5b                   	pop    %ebx
  80445c:	5e                   	pop    %esi
  80445d:	5d                   	pop    %ebp
  80445e:	c3                   	ret    

0080445f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80445f:	55                   	push   %ebp
  804460:	89 e5                	mov    %esp,%ebp
  804462:	57                   	push   %edi
  804463:	56                   	push   %esi
  804464:	53                   	push   %ebx
  804465:	83 ec 1c             	sub    $0x1c,%esp
  804468:	8b 75 08             	mov    0x8(%ebp),%esi
  80446b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80446e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  804471:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  804473:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  804478:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  80447b:	8b 45 14             	mov    0x14(%ebp),%eax
  80447e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804482:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804486:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80448a:	89 34 24             	mov    %esi,(%esp)
  80448d:	e8 71 cb ff ff       	call   801003 <_Z16sys_ipc_try_sendijPvi>
  804492:	85 c0                	test   %eax,%eax
  804494:	79 31                	jns    8044c7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  804496:	83 f8 f9             	cmp    $0xfffffff9,%eax
  804499:	75 0c                	jne    8044a7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  80449b:	90                   	nop
  80449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8044a0:	e8 97 c8 ff ff       	call   800d3c <_Z9sys_yieldv>
  8044a5:	eb d4                	jmp    80447b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  8044a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044ab:	c7 44 24 08 46 59 80 	movl   $0x805946,0x8(%esp)
  8044b2:	00 
  8044b3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8044ba:	00 
  8044bb:	c7 04 24 53 59 80 00 	movl   $0x805953,(%esp)
  8044c2:	e8 8d bc ff ff       	call   800154 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  8044c7:	83 c4 1c             	add    $0x1c,%esp
  8044ca:	5b                   	pop    %ebx
  8044cb:	5e                   	pop    %esi
  8044cc:	5f                   	pop    %edi
  8044cd:	5d                   	pop    %ebp
  8044ce:	c3                   	ret    
	...

008044d0 <mig>:
.text
.globl mig
mig:
    movl (%ebp), %ecx
  8044d0:	8b 4d 00             	mov    0x0(%ebp),%ecx
    leal 4(%ebp), %eax
  8044d3:	8d 45 04             	lea    0x4(%ebp),%eax
    push %ebp
  8044d6:	55                   	push   %ebp
    movl %esp, %ebp
  8044d7:	89 e5                	mov    %esp,%ebp
    
    push %eax
  8044d9:	50                   	push   %eax
    push %ecx
  8044da:	51                   	push   %ecx
	pushal
  8044db:	60                   	pusha  
    movl 8(%ebp), %edx
  8044dc:	8b 55 08             	mov    0x8(%ebp),%edx
    movl $0, %eax
  8044df:	b8 00 00 00 00       	mov    $0x0,%eax

008044e4 <loop>:

loop:
    movl (%esp,%eax,4), %ecx
  8044e4:	8b 0c 84             	mov    (%esp,%eax,4),%ecx
    movl %ecx, (%edx, %eax, 4)
  8044e7:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
    add $1, %eax
  8044ea:	83 c0 01             	add    $0x1,%eax
    cmp $8, %eax
  8044ed:	83 f8 08             	cmp    $0x8,%eax
    jne loop
  8044f0:	75 f2                	jne    8044e4 <loop>
    
    popal
  8044f2:	61                   	popa   
    pop %eax
  8044f3:	58                   	pop    %eax
    movl 0xc(%ebp), %edx
  8044f4:	8b 55 0c             	mov    0xc(%ebp),%edx
    movl %eax, (%edx)
  8044f7:	89 02                	mov    %eax,(%edx)
    pop %eax
  8044f9:	58                   	pop    %eax
    movl 0x10(%ebp), %edx
  8044fa:	8b 55 10             	mov    0x10(%ebp),%edx
    movl %eax, (%edx)
  8044fd:	89 02                	mov    %eax,(%edx)
    
    movl %ebp, %esp
  8044ff:	89 ec                	mov    %ebp,%esp
    popl %ebp
  804501:	5d                   	pop    %ebp
    ret
  804502:	c3                   	ret    
	...

00804510 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804510:	55                   	push   %ebp
  804511:	89 e5                	mov    %esp,%ebp
  804513:	57                   	push   %edi
  804514:	56                   	push   %esi
  804515:	53                   	push   %ebx
  804516:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804519:	8b 45 08             	mov    0x8(%ebp),%eax
  80451c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80451f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  804522:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  804525:	8d 45 ef             	lea    -0x11(%ebp),%eax
  804528:	89 45 e0             	mov    %eax,-0x20(%ebp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80452b:	bb 20 90 80 00       	mov    $0x809020,%ebx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  804530:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804533:	0f b6 08             	movzbl (%eax),%ecx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804536:	ba 00 00 00 00       	mov    $0x0,%edx
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  80453b:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  804540:	f6 e1                	mul    %cl
  804542:	66 c1 e8 08          	shr    $0x8,%ax
  804546:	c0 e8 03             	shr    $0x3,%al
  804549:	89 c6                	mov    %eax,%esi
  80454b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80454e:	01 c0                	add    %eax,%eax
  804550:	28 c1                	sub    %al,%cl
  804552:	89 c8                	mov    %ecx,%eax
      *ap /= (u8_t)10;
  804554:	89 f1                	mov    %esi,%ecx
      inv[i++] = '0' + rem;
  804556:	0f b6 fa             	movzbl %dl,%edi
  804559:	83 c0 30             	add    $0x30,%eax
  80455c:	88 44 3d f1          	mov    %al,-0xf(%ebp,%edi,1)
  804560:	83 c2 01             	add    $0x1,%edx

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
  804563:	84 c9                	test   %cl,%cl
  804565:	75 d4                	jne    80453b <inet_ntoa+0x2b>
  804567:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80456a:	88 08                	mov    %cl,(%eax)
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80456c:	84 d2                	test   %dl,%dl
  80456e:	74 24                	je     804594 <inet_ntoa+0x84>
  804570:	83 ea 01             	sub    $0x1,%edx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  804573:	0f b6 fa             	movzbl %dl,%edi
  804576:	8d 74 3b 01          	lea    0x1(%ebx,%edi,1),%esi
  80457a:	89 d8                	mov    %ebx,%eax
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  80457c:	0f b6 ca             	movzbl %dl,%ecx
  80457f:	0f b6 4c 0d f1       	movzbl -0xf(%ebp,%ecx,1),%ecx
  804584:	88 08                	mov    %cl,(%eax)
  804586:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  804589:	83 ea 01             	sub    $0x1,%edx
  80458c:	39 f0                	cmp    %esi,%eax
  80458e:	75 ec                	jne    80457c <inet_ntoa+0x6c>
  804590:	8d 5c 3b 01          	lea    0x1(%ebx,%edi,1),%ebx
      *rp++ = inv[i];
    *rp++ = '.';
  804594:	c6 03 2e             	movb   $0x2e,(%ebx)
  804597:	83 c3 01             	add    $0x1,%ebx
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80459a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80459d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8045a0:	74 06                	je     8045a8 <inet_ntoa+0x98>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  8045a2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  8045a6:	eb 88                	jmp    804530 <inet_ntoa+0x20>
  }
  *--rp = 0;
  8045a8:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  8045ac:	b8 20 90 80 00       	mov    $0x809020,%eax
  8045b1:	83 c4 18             	add    $0x18,%esp
  8045b4:	5b                   	pop    %ebx
  8045b5:	5e                   	pop    %esi
  8045b6:	5f                   	pop    %edi
  8045b7:	5d                   	pop    %ebp
  8045b8:	c3                   	ret    

008045b9 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8045b9:	55                   	push   %ebp
  8045ba:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8045bc:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8045c0:	66 c1 c0 08          	rol    $0x8,%ax
}
  8045c4:	5d                   	pop    %ebp
  8045c5:	c3                   	ret    

008045c6 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8045c6:	55                   	push   %ebp
  8045c7:	89 e5                	mov    %esp,%ebp
  8045c9:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  8045cc:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8045d0:	89 04 24             	mov    %eax,(%esp)
  8045d3:	e8 e1 ff ff ff       	call   8045b9 <htons>
}
  8045d8:	c9                   	leave  
  8045d9:	c3                   	ret    

008045da <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8045da:	55                   	push   %ebp
  8045db:	89 e5                	mov    %esp,%ebp
  8045dd:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8045e0:	89 d1                	mov    %edx,%ecx
  8045e2:	c1 e9 18             	shr    $0x18,%ecx
  8045e5:	89 d0                	mov    %edx,%eax
  8045e7:	c1 e0 18             	shl    $0x18,%eax
  8045ea:	09 c8                	or     %ecx,%eax
  8045ec:	89 d1                	mov    %edx,%ecx
  8045ee:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8045f4:	c1 e1 08             	shl    $0x8,%ecx
  8045f7:	09 c8                	or     %ecx,%eax
  8045f9:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  8045ff:	c1 ea 08             	shr    $0x8,%edx
  804602:	09 d0                	or     %edx,%eax
}
  804604:	5d                   	pop    %ebp
  804605:	c3                   	ret    

00804606 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804606:	55                   	push   %ebp
  804607:	89 e5                	mov    %esp,%ebp
  804609:	57                   	push   %edi
  80460a:	56                   	push   %esi
  80460b:	53                   	push   %ebx
  80460c:	83 ec 28             	sub    $0x28,%esp
  80460f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  804612:	0f be 11             	movsbl (%ecx),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804615:	8d 5a d0             	lea    -0x30(%edx),%ebx
      return (0);
  804618:	b8 00 00 00 00       	mov    $0x0,%eax
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  80461d:	80 fb 09             	cmp    $0x9,%bl
  804620:	0f 87 c4 01 00 00    	ja     8047ea <inet_aton+0x1e4>
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804626:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  804629:	89 45 d8             	mov    %eax,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80462c:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  80462f:	89 5d e0             	mov    %ebx,-0x20(%ebp)
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
  804632:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  804639:	83 fa 30             	cmp    $0x30,%edx
  80463c:	75 25                	jne    804663 <inet_aton+0x5d>
      c = *++cp;
  80463e:	83 c1 01             	add    $0x1,%ecx
  804641:	0f be 11             	movsbl (%ecx),%edx
      if (c == 'x' || c == 'X') {
  804644:	83 fa 78             	cmp    $0x78,%edx
  804647:	74 0c                	je     804655 <inet_aton+0x4f>
        base = 16;
        c = *++cp;
      } else
        base = 8;
  804649:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
  804650:	83 fa 58             	cmp    $0x58,%edx
  804653:	75 0e                	jne    804663 <inet_aton+0x5d>
        base = 16;
        c = *++cp;
  804655:	0f be 51 01          	movsbl 0x1(%ecx),%edx
  804659:	83 c1 01             	add    $0x1,%ecx
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80465c:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  804663:	8d 41 01             	lea    0x1(%ecx),%eax
  804666:	be 00 00 00 00       	mov    $0x0,%esi
  80466b:	eb 03                	jmp    804670 <inet_aton+0x6a>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  80466d:	83 c0 01             	add    $0x1,%eax
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  804670:	8d 78 ff             	lea    -0x1(%eax),%edi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  804673:	89 d1                	mov    %edx,%ecx
  804675:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  804678:	80 fb 09             	cmp    $0x9,%bl
  80467b:	77 0d                	ja     80468a <inet_aton+0x84>
        val = (val * base) + (int)(c - '0');
  80467d:	0f af 75 dc          	imul   -0x24(%ebp),%esi
  804681:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  804685:	0f be 10             	movsbl (%eax),%edx
  804688:	eb e3                	jmp    80466d <inet_aton+0x67>
      } else if (base == 16 && isxdigit(c)) {
  80468a:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  80468e:	0f 85 5e 01 00 00    	jne    8047f2 <inet_aton+0x1ec>
  804694:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  804697:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  80469a:	80 fb 05             	cmp    $0x5,%bl
  80469d:	76 0c                	jbe    8046ab <inet_aton+0xa5>
  80469f:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8046a2:	80 fb 05             	cmp    $0x5,%bl
  8046a5:	0f 87 4d 01 00 00    	ja     8047f8 <inet_aton+0x1f2>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8046ab:	89 f1                	mov    %esi,%ecx
  8046ad:	c1 e1 04             	shl    $0x4,%ecx
  8046b0:	8d 72 0a             	lea    0xa(%edx),%esi
  8046b3:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8046b7:	19 d2                	sbb    %edx,%edx
  8046b9:	83 e2 20             	and    $0x20,%edx
  8046bc:	83 c2 41             	add    $0x41,%edx
  8046bf:	29 d6                	sub    %edx,%esi
  8046c1:	09 ce                	or     %ecx,%esi
        c = *++cp;
  8046c3:	0f be 10             	movsbl (%eax),%edx
  8046c6:	eb a5                	jmp    80466d <inet_aton+0x67>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8046c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8046cb:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8046ce:	0f 83 0a 01 00 00    	jae    8047de <inet_aton+0x1d8>
        return (0);
      *pp++ = val;
  8046d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8046d7:	89 1a                	mov    %ebx,(%edx)
      c = *++cp;
  8046d9:	8d 4f 01             	lea    0x1(%edi),%ecx
  8046dc:	0f be 57 01          	movsbl 0x1(%edi),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8046e0:	8d 42 d0             	lea    -0x30(%edx),%eax
  8046e3:	3c 09                	cmp    $0x9,%al
  8046e5:	0f 87 fa 00 00 00    	ja     8047e5 <inet_aton+0x1df>
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
  8046eb:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8046ef:	e9 3e ff ff ff       	jmp    804632 <inet_aton+0x2c>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8046f4:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8046f9:	80 f9 1f             	cmp    $0x1f,%cl
  8046fc:	0f 86 e8 00 00 00    	jbe    8047ea <inet_aton+0x1e4>
  804702:	84 d2                	test   %dl,%dl
  804704:	0f 88 e0 00 00 00    	js     8047ea <inet_aton+0x1e4>
  80470a:	83 fa 20             	cmp    $0x20,%edx
  80470d:	74 1d                	je     80472c <inet_aton+0x126>
  80470f:	83 fa 0c             	cmp    $0xc,%edx
  804712:	74 18                	je     80472c <inet_aton+0x126>
  804714:	83 fa 0a             	cmp    $0xa,%edx
  804717:	74 13                	je     80472c <inet_aton+0x126>
  804719:	83 fa 0d             	cmp    $0xd,%edx
  80471c:	74 0e                	je     80472c <inet_aton+0x126>
  80471e:	83 fa 09             	cmp    $0x9,%edx
  804721:	74 09                	je     80472c <inet_aton+0x126>
  804723:	83 fa 0b             	cmp    $0xb,%edx
  804726:	0f 85 be 00 00 00    	jne    8047ea <inet_aton+0x1e4>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80472c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80472f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804732:	29 c2                	sub    %eax,%edx
  804734:	c1 fa 02             	sar    $0x2,%edx
  804737:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80473a:	83 fa 02             	cmp    $0x2,%edx
  80473d:	74 25                	je     804764 <inet_aton+0x15e>
  80473f:	83 fa 02             	cmp    $0x2,%edx
  804742:	7f 0f                	jg     804753 <inet_aton+0x14d>

  case 0:
    return (0);       /* initial nondigit */
  804744:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  804749:	85 d2                	test   %edx,%edx
  80474b:	0f 84 99 00 00 00    	je     8047ea <inet_aton+0x1e4>
  804751:	eb 6c                	jmp    8047bf <inet_aton+0x1b9>
  804753:	83 fa 03             	cmp    $0x3,%edx
  804756:	74 23                	je     80477b <inet_aton+0x175>
  804758:	83 fa 04             	cmp    $0x4,%edx
  80475b:	90                   	nop
  80475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804760:	75 5d                	jne    8047bf <inet_aton+0x1b9>
  804762:	eb 36                	jmp    80479a <inet_aton+0x194>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  804764:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  804769:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  80476f:	77 79                	ja     8047ea <inet_aton+0x1e4>
      return (0);
    val |= parts[0] << 24;
  804771:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  804774:	c1 e6 18             	shl    $0x18,%esi
  804777:	09 de                	or     %ebx,%esi
    break;
  804779:	eb 44                	jmp    8047bf <inet_aton+0x1b9>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  80477b:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  804780:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  804786:	77 62                	ja     8047ea <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  804788:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80478b:	c1 e6 10             	shl    $0x10,%esi
  80478e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804791:	c1 e0 18             	shl    $0x18,%eax
  804794:	09 c6                	or     %eax,%esi
  804796:	09 de                	or     %ebx,%esi
    break;
  804798:	eb 25                	jmp    8047bf <inet_aton+0x1b9>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  80479a:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80479f:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8047a5:	77 43                	ja     8047ea <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8047a7:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8047aa:	c1 e6 10             	shl    $0x10,%esi
  8047ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047b0:	c1 e0 18             	shl    $0x18,%eax
  8047b3:	09 c6                	or     %eax,%esi
  8047b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047b8:	c1 e0 08             	shl    $0x8,%eax
  8047bb:	09 c6                	or     %eax,%esi
  8047bd:	09 de                	or     %ebx,%esi
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8047bf:	b8 01 00 00 00       	mov    $0x1,%eax
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8047c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8047c8:	74 20                	je     8047ea <inet_aton+0x1e4>
    addr->s_addr = htonl(val);
  8047ca:	89 34 24             	mov    %esi,(%esp)
  8047cd:	e8 08 fe ff ff       	call   8045da <htonl>
  8047d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8047d5:	89 03                	mov    %eax,(%ebx)
  return (1);
  8047d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8047dc:	eb 0c                	jmp    8047ea <inet_aton+0x1e4>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8047de:	b8 00 00 00 00       	mov    $0x0,%eax
  8047e3:	eb 05                	jmp    8047ea <inet_aton+0x1e4>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8047e5:	b8 00 00 00 00       	mov    $0x0,%eax
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
}
  8047ea:	83 c4 28             	add    $0x28,%esp
  8047ed:	5b                   	pop    %ebx
  8047ee:	5e                   	pop    %esi
  8047ef:	5f                   	pop    %edi
  8047f0:	5d                   	pop    %ebp
  8047f1:	c3                   	ret    
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  8047f2:	89 d0                	mov    %edx,%eax
  8047f4:	89 f3                	mov    %esi,%ebx
  8047f6:	eb 04                	jmp    8047fc <inet_aton+0x1f6>
  8047f8:	89 d0                	mov    %edx,%eax
  8047fa:	89 f3                	mov    %esi,%ebx
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
    if (c == '.') {
  8047fc:	83 f8 2e             	cmp    $0x2e,%eax
  8047ff:	0f 84 c3 fe ff ff    	je     8046c8 <inet_aton+0xc2>
  804805:	89 f3                	mov    %esi,%ebx
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804807:	85 d2                	test   %edx,%edx
  804809:	0f 84 1d ff ff ff    	je     80472c <inet_aton+0x126>
  80480f:	e9 e0 fe ff ff       	jmp    8046f4 <inet_aton+0xee>

00804814 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804814:	55                   	push   %ebp
  804815:	89 e5                	mov    %esp,%ebp
  804817:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80481a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80481d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804821:	8b 45 08             	mov    0x8(%ebp),%eax
  804824:	89 04 24             	mov    %eax,(%esp)
  804827:	e8 da fd ff ff       	call   804606 <inet_aton>
  80482c:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80482e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  804833:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  804837:	c9                   	leave  
  804838:	c3                   	ret    

00804839 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804839:	55                   	push   %ebp
  80483a:	89 e5                	mov    %esp,%ebp
  80483c:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  80483f:	8b 45 08             	mov    0x8(%ebp),%eax
  804842:	89 04 24             	mov    %eax,(%esp)
  804845:	e8 90 fd ff ff       	call   8045da <htonl>
}
  80484a:	c9                   	leave  
  80484b:	c3                   	ret    
  80484c:	00 00                	add    %al,(%eax)
	...

00804850 <__udivdi3>:
  804850:	55                   	push   %ebp
  804851:	89 e5                	mov    %esp,%ebp
  804853:	57                   	push   %edi
  804854:	56                   	push   %esi
  804855:	83 ec 20             	sub    $0x20,%esp
  804858:	8b 45 14             	mov    0x14(%ebp),%eax
  80485b:	8b 75 08             	mov    0x8(%ebp),%esi
  80485e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804861:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804864:	85 c0                	test   %eax,%eax
  804866:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804869:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80486c:	75 3a                	jne    8048a8 <__udivdi3+0x58>
  80486e:	39 f9                	cmp    %edi,%ecx
  804870:	77 66                	ja     8048d8 <__udivdi3+0x88>
  804872:	85 c9                	test   %ecx,%ecx
  804874:	75 0b                	jne    804881 <__udivdi3+0x31>
  804876:	b8 01 00 00 00       	mov    $0x1,%eax
  80487b:	31 d2                	xor    %edx,%edx
  80487d:	f7 f1                	div    %ecx
  80487f:	89 c1                	mov    %eax,%ecx
  804881:	89 f8                	mov    %edi,%eax
  804883:	31 d2                	xor    %edx,%edx
  804885:	f7 f1                	div    %ecx
  804887:	89 c7                	mov    %eax,%edi
  804889:	89 f0                	mov    %esi,%eax
  80488b:	f7 f1                	div    %ecx
  80488d:	89 fa                	mov    %edi,%edx
  80488f:	89 c6                	mov    %eax,%esi
  804891:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804894:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80489a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80489d:	83 c4 20             	add    $0x20,%esp
  8048a0:	5e                   	pop    %esi
  8048a1:	5f                   	pop    %edi
  8048a2:	5d                   	pop    %ebp
  8048a3:	c3                   	ret    
  8048a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8048a8:	31 d2                	xor    %edx,%edx
  8048aa:	31 f6                	xor    %esi,%esi
  8048ac:	39 f8                	cmp    %edi,%eax
  8048ae:	77 e1                	ja     804891 <__udivdi3+0x41>
  8048b0:	0f bd d0             	bsr    %eax,%edx
  8048b3:	83 f2 1f             	xor    $0x1f,%edx
  8048b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8048b9:	75 2d                	jne    8048e8 <__udivdi3+0x98>
  8048bb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8048be:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  8048c1:	76 06                	jbe    8048c9 <__udivdi3+0x79>
  8048c3:	39 f8                	cmp    %edi,%eax
  8048c5:	89 f2                	mov    %esi,%edx
  8048c7:	73 c8                	jae    804891 <__udivdi3+0x41>
  8048c9:	31 d2                	xor    %edx,%edx
  8048cb:	be 01 00 00 00       	mov    $0x1,%esi
  8048d0:	eb bf                	jmp    804891 <__udivdi3+0x41>
  8048d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8048d8:	89 f0                	mov    %esi,%eax
  8048da:	89 fa                	mov    %edi,%edx
  8048dc:	f7 f1                	div    %ecx
  8048de:	31 d2                	xor    %edx,%edx
  8048e0:	89 c6                	mov    %eax,%esi
  8048e2:	eb ad                	jmp    804891 <__udivdi3+0x41>
  8048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8048e8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8048ec:	89 c2                	mov    %eax,%edx
  8048ee:	b8 20 00 00 00       	mov    $0x20,%eax
  8048f3:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8048f6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8048f9:	d3 e2                	shl    %cl,%edx
  8048fb:	89 c1                	mov    %eax,%ecx
  8048fd:	d3 ee                	shr    %cl,%esi
  8048ff:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804903:	09 d6                	or     %edx,%esi
  804905:	89 fa                	mov    %edi,%edx
  804907:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80490a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80490d:	d3 e6                	shl    %cl,%esi
  80490f:	89 c1                	mov    %eax,%ecx
  804911:	d3 ea                	shr    %cl,%edx
  804913:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804917:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80491a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80491d:	d3 e7                	shl    %cl,%edi
  80491f:	89 c1                	mov    %eax,%ecx
  804921:	d3 ee                	shr    %cl,%esi
  804923:	09 fe                	or     %edi,%esi
  804925:	89 f0                	mov    %esi,%eax
  804927:	f7 75 e4             	divl   -0x1c(%ebp)
  80492a:	89 d7                	mov    %edx,%edi
  80492c:	89 c6                	mov    %eax,%esi
  80492e:	f7 65 f0             	mull   -0x10(%ebp)
  804931:	39 d7                	cmp    %edx,%edi
  804933:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804936:	72 12                	jb     80494a <__udivdi3+0xfa>
  804938:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80493b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80493f:	d3 e2                	shl    %cl,%edx
  804941:	39 c2                	cmp    %eax,%edx
  804943:	73 08                	jae    80494d <__udivdi3+0xfd>
  804945:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804948:	75 03                	jne    80494d <__udivdi3+0xfd>
  80494a:	83 ee 01             	sub    $0x1,%esi
  80494d:	31 d2                	xor    %edx,%edx
  80494f:	e9 3d ff ff ff       	jmp    804891 <__udivdi3+0x41>
	...

00804960 <__umoddi3>:
  804960:	55                   	push   %ebp
  804961:	89 e5                	mov    %esp,%ebp
  804963:	57                   	push   %edi
  804964:	56                   	push   %esi
  804965:	83 ec 20             	sub    $0x20,%esp
  804968:	8b 7d 14             	mov    0x14(%ebp),%edi
  80496b:	8b 45 08             	mov    0x8(%ebp),%eax
  80496e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804971:	8b 75 0c             	mov    0xc(%ebp),%esi
  804974:	85 ff                	test   %edi,%edi
  804976:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804979:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80497c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80497f:	89 f2                	mov    %esi,%edx
  804981:	75 15                	jne    804998 <__umoddi3+0x38>
  804983:	39 f1                	cmp    %esi,%ecx
  804985:	76 41                	jbe    8049c8 <__umoddi3+0x68>
  804987:	f7 f1                	div    %ecx
  804989:	89 d0                	mov    %edx,%eax
  80498b:	31 d2                	xor    %edx,%edx
  80498d:	83 c4 20             	add    $0x20,%esp
  804990:	5e                   	pop    %esi
  804991:	5f                   	pop    %edi
  804992:	5d                   	pop    %ebp
  804993:	c3                   	ret    
  804994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804998:	39 f7                	cmp    %esi,%edi
  80499a:	77 4c                	ja     8049e8 <__umoddi3+0x88>
  80499c:	0f bd c7             	bsr    %edi,%eax
  80499f:	83 f0 1f             	xor    $0x1f,%eax
  8049a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8049a5:	75 51                	jne    8049f8 <__umoddi3+0x98>
  8049a7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  8049aa:	0f 87 e8 00 00 00    	ja     804a98 <__umoddi3+0x138>
  8049b0:	89 f2                	mov    %esi,%edx
  8049b2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8049b5:	29 ce                	sub    %ecx,%esi
  8049b7:	19 fa                	sbb    %edi,%edx
  8049b9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8049bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049bf:	83 c4 20             	add    $0x20,%esp
  8049c2:	5e                   	pop    %esi
  8049c3:	5f                   	pop    %edi
  8049c4:	5d                   	pop    %ebp
  8049c5:	c3                   	ret    
  8049c6:	66 90                	xchg   %ax,%ax
  8049c8:	85 c9                	test   %ecx,%ecx
  8049ca:	75 0b                	jne    8049d7 <__umoddi3+0x77>
  8049cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8049d1:	31 d2                	xor    %edx,%edx
  8049d3:	f7 f1                	div    %ecx
  8049d5:	89 c1                	mov    %eax,%ecx
  8049d7:	89 f0                	mov    %esi,%eax
  8049d9:	31 d2                	xor    %edx,%edx
  8049db:	f7 f1                	div    %ecx
  8049dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049e0:	eb a5                	jmp    804987 <__umoddi3+0x27>
  8049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8049e8:	89 f2                	mov    %esi,%edx
  8049ea:	83 c4 20             	add    $0x20,%esp
  8049ed:	5e                   	pop    %esi
  8049ee:	5f                   	pop    %edi
  8049ef:	5d                   	pop    %ebp
  8049f0:	c3                   	ret    
  8049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8049f8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8049fc:	89 f2                	mov    %esi,%edx
  8049fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a01:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804a08:	29 45 f0             	sub    %eax,-0x10(%ebp)
  804a0b:	d3 e7                	shl    %cl,%edi
  804a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a10:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804a14:	d3 e8                	shr    %cl,%eax
  804a16:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a1a:	09 f8                	or     %edi,%eax
  804a1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  804a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804a22:	d3 e0                	shl    %cl,%eax
  804a24:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804a2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a2e:	d3 ea                	shr    %cl,%edx
  804a30:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a34:	d3 e6                	shl    %cl,%esi
  804a36:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804a3a:	d3 e8                	shr    %cl,%eax
  804a3c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a40:	09 f0                	or     %esi,%eax
  804a42:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804a45:	f7 75 e4             	divl   -0x1c(%ebp)
  804a48:	d3 e6                	shl    %cl,%esi
  804a4a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804a4d:	89 d6                	mov    %edx,%esi
  804a4f:	f7 65 f4             	mull   -0xc(%ebp)
  804a52:	89 d7                	mov    %edx,%edi
  804a54:	89 c2                	mov    %eax,%edx
  804a56:	39 fe                	cmp    %edi,%esi
  804a58:	89 f9                	mov    %edi,%ecx
  804a5a:	72 30                	jb     804a8c <__umoddi3+0x12c>
  804a5c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  804a5f:	72 27                	jb     804a88 <__umoddi3+0x128>
  804a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a64:	29 d0                	sub    %edx,%eax
  804a66:	19 ce                	sbb    %ecx,%esi
  804a68:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a6c:	89 f2                	mov    %esi,%edx
  804a6e:	d3 e8                	shr    %cl,%eax
  804a70:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804a74:	d3 e2                	shl    %cl,%edx
  804a76:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a7a:	09 d0                	or     %edx,%eax
  804a7c:	89 f2                	mov    %esi,%edx
  804a7e:	d3 ea                	shr    %cl,%edx
  804a80:	83 c4 20             	add    $0x20,%esp
  804a83:	5e                   	pop    %esi
  804a84:	5f                   	pop    %edi
  804a85:	5d                   	pop    %ebp
  804a86:	c3                   	ret    
  804a87:	90                   	nop
  804a88:	39 fe                	cmp    %edi,%esi
  804a8a:	75 d5                	jne    804a61 <__umoddi3+0x101>
  804a8c:	89 f9                	mov    %edi,%ecx
  804a8e:	89 c2                	mov    %eax,%edx
  804a90:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804a93:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804a96:	eb c9                	jmp    804a61 <__umoddi3+0x101>
  804a98:	39 f7                	cmp    %esi,%edi
  804a9a:	0f 82 10 ff ff ff    	jb     8049b0 <__umoddi3+0x50>
  804aa0:	e9 17 ff ff ff       	jmp    8049bc <__umoddi3+0x5c>
