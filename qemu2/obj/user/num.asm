
obj/user/num:     file format elf32-i386


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
  80002c:	e8 a3 01 00 00       	call   8001d4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z3numiPKc>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800043:	8d 5d e7             	lea    -0x19(%ebp),%ebx
  800046:	e9 89 00 00 00       	jmp    8000d4 <_Z3numiPKc+0xa0>
		if (bol) {
  80004b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800052:	74 2f                	je     800083 <_Z3numiPKc+0x4f>
			fprintf(1, "%5d ", ++line);
  800054:	a1 00 60 80 00       	mov    0x806000,%eax
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	a3 00 60 80 00       	mov    %eax,0x806000
  800061:	89 44 24 08          	mov    %eax,0x8(%esp)
  800065:	c7 44 24 04 00 41 80 	movl   $0x804100,0x4(%esp)
  80006c:	00 
  80006d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800074:	e8 b7 34 00 00       	call   803530 <_Z7fprintfiPKcz>
			bol = 0;
  800079:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  800080:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  800083:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80008a:	00 
  80008b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800096:	e8 2e 17 00 00       	call   8017c9 <_Z5writeiPKvj>
  80009b:	83 f8 01             	cmp    $0x1,%eax
  80009e:	74 24                	je     8000c4 <_Z3numiPKc+0x90>
			panic("write error copying %s: %e", s, r);
  8000a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000a4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000a8:	c7 44 24 08 05 41 80 	movl   $0x804105,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000b7:	00 
  8000b8:	c7 04 24 20 41 80 00 	movl   $0x804120,(%esp)
  8000bf:	e8 94 01 00 00       	call   800258 <_Z6_panicPKciS0_z>
		if (c == '\n')
  8000c4:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8000c8:	75 0a                	jne    8000d4 <_Z3numiPKc+0xa0>
			bol = 1;
  8000ca:	c7 05 00 50 80 00 01 	movl   $0x1,0x805000
  8000d1:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000db:	00 
  8000dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e0:	89 34 24             	mov    %esi,(%esp)
  8000e3:	e8 f6 15 00 00       	call   8016de <_Z4readiPvj>
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	0f 8f 5b ff ff ff    	jg     80004b <_Z3numiPKc+0x17>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	79 24                	jns    800118 <_Z3numiPKc+0xe4>
		panic("error reading %s: %e", s, n);
  8000f4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000f8:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000fc:	c7 44 24 08 2b 41 80 	movl   $0x80412b,0x8(%esp)
  800103:	00 
  800104:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  80010b:	00 
  80010c:	c7 04 24 20 41 80 00 	movl   $0x804120,(%esp)
  800113:	e8 40 01 00 00       	call   800258 <_Z6_panicPKciS0_z>
}
  800118:	83 c4 3c             	add    $0x3c,%esp
  80011b:	5b                   	pop    %ebx
  80011c:	5e                   	pop    %esi
  80011d:	5f                   	pop    %edi
  80011e:	5d                   	pop    %ebp
  80011f:	c3                   	ret    

00800120 <_Z5umainiPPc>:

void
umain(int argc, char **argv)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
  800126:	83 ec 3c             	sub    $0x3c,%esp
	int f, i;

	argv0 = "num";
  800129:	c7 05 08 60 80 00 40 	movl   $0x804140,0x806008
  800130:	41 80 00 
	if (argc == 1)
  800133:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800137:	74 13                	je     80014c <_Z5umainiPPc+0x2c>
	if (n < 0)
		panic("error reading %s: %e", s, n);
}

void
umain(int argc, char **argv)
  800139:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80013c:	83 c3 04             	add    $0x4,%ebx
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi

	argv0 = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800144:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800148:	7f 18                	jg     800162 <_Z5umainiPPc+0x42>
  80014a:	eb 7b                	jmp    8001c7 <_Z5umainiPPc+0xa7>
{
	int f, i;

	argv0 = "num";
	if (argc == 1)
		num(0, "<stdin>");
  80014c:	c7 44 24 04 44 41 80 	movl   $0x804144,0x4(%esp)
  800153:	00 
  800154:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015b:	e8 d4 fe ff ff       	call   800034 <_Z3numiPKc>
  800160:	eb 65                	jmp    8001c7 <_Z5umainiPPc+0xa7>
  800162:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800165:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80016c:	00 
  80016d:	8b 03                	mov    (%ebx),%eax
  80016f:	89 04 24             	mov    %eax,(%esp)
  800172:	e8 f7 21 00 00       	call   80236e <_Z4openPKci>
  800177:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800179:	85 c0                	test   %eax,%eax
  80017b:	79 29                	jns    8001a6 <_Z5umainiPPc+0x86>
				panic("can't open %s: %e", argv[i], f);
  80017d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800181:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800184:	8b 02                	mov    (%edx),%eax
  800186:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018a:	c7 44 24 08 4c 41 80 	movl   $0x80414c,0x8(%esp)
  800191:	00 
  800192:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  800199:	00 
  80019a:	c7 04 24 20 41 80 00 	movl   $0x804120,(%esp)
  8001a1:	e8 b2 00 00 00       	call   800258 <_Z6_panicPKciS0_z>
			else {
				num(f, argv[i]);
  8001a6:	8b 03                	mov    (%ebx),%eax
  8001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ac:	89 34 24             	mov    %esi,(%esp)
  8001af:	e8 80 fe ff ff       	call   800034 <_Z3numiPKc>
				close(f);
  8001b4:	89 34 24             	mov    %esi,(%esp)
  8001b7:	e8 79 13 00 00       	call   801535 <_Z5closei>

	argv0 = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001bc:	83 c7 01             	add    $0x1,%edi
  8001bf:	83 c3 04             	add    $0x4,%ebx
  8001c2:	39 7d 08             	cmp    %edi,0x8(%ebp)
  8001c5:	7f 9b                	jg     800162 <_Z5umainiPPc+0x42>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001c7:	e8 70 00 00 00       	call   80023c <_Z4exitv>
}
  8001cc:	83 c4 3c             	add    $0x3c,%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5f                   	pop    %edi
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    

008001d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	57                   	push   %edi
  8001d8:	56                   	push   %esi
  8001d9:	53                   	push   %ebx
  8001da:	83 ec 1c             	sub    $0x1c,%esp
  8001dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8001e0:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8001e3:	e8 20 0c 00 00       	call   800e08 <_Z12sys_getenvidv>
  8001e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ed:	6b c0 78             	imul   $0x78,%eax,%eax
  8001f0:	05 00 00 00 ef       	add    $0xef000000,%eax
  8001f5:	a3 04 60 80 00       	mov    %eax,0x806004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fa:	85 ff                	test   %edi,%edi
  8001fc:	7e 07                	jle    800205 <libmain+0x31>
		binaryname = argv[0];
  8001fe:	8b 06                	mov    (%esi),%eax
  800200:	a3 04 50 80 00       	mov    %eax,0x805004

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800205:	b8 81 4c 80 00       	mov    $0x804c81,%eax
  80020a:	3d 81 4c 80 00       	cmp    $0x804c81,%eax
  80020f:	76 0f                	jbe    800220 <libmain+0x4c>
  800211:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800213:	83 eb 04             	sub    $0x4,%ebx
  800216:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800218:	81 fb 81 4c 80 00    	cmp    $0x804c81,%ebx
  80021e:	77 f3                	ja     800213 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800220:	89 74 24 04          	mov    %esi,0x4(%esp)
  800224:	89 3c 24             	mov    %edi,(%esp)
  800227:	e8 f4 fe ff ff       	call   800120 <_Z5umainiPPc>

	// exit gracefully
	exit();
  80022c:	e8 0b 00 00 00       	call   80023c <_Z4exitv>
}
  800231:	83 c4 1c             	add    $0x1c,%esp
  800234:	5b                   	pop    %ebx
  800235:	5e                   	pop    %esi
  800236:	5f                   	pop    %edi
  800237:	5d                   	pop    %ebp
  800238:	c3                   	ret    
  800239:	00 00                	add    %al,(%eax)
	...

0080023c <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800242:	e8 27 13 00 00       	call   80156e <_Z9close_allv>
	sys_env_destroy(0);
  800247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80024e:	e8 58 0b 00 00       	call   800dab <_Z15sys_env_destroyi>
}
  800253:	c9                   	leave  
  800254:	c3                   	ret    
  800255:	00 00                	add    %al,(%eax)
	...

00800258 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800260:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  800263:	a1 08 60 80 00       	mov    0x806008,%eax
  800268:	85 c0                	test   %eax,%eax
  80026a:	74 10                	je     80027c <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  80026c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800270:	c7 04 24 68 41 80 00 	movl   $0x804168,(%esp)
  800277:	e8 fa 00 00 00       	call   800376 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  80027c:	8b 1d 04 50 80 00    	mov    0x805004,%ebx
  800282:	e8 81 0b 00 00       	call   800e08 <_Z12sys_getenvidv>
  800287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80028e:	8b 55 08             	mov    0x8(%ebp),%edx
  800291:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800295:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029d:	c7 04 24 70 41 80 00 	movl   $0x804170,(%esp)
  8002a4:	e8 cd 00 00 00       	call   800376 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8002a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b0:	89 04 24             	mov    %eax,(%esp)
  8002b3:	e8 5d 00 00 00       	call   800315 <_Z8vcprintfPKcPc>
	cprintf("\n");
  8002b8:	c7 04 24 23 4b 80 00 	movl   $0x804b23,(%esp)
  8002bf:	e8 b2 00 00 00       	call   800376 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002c4:	cc                   	int3   
  8002c5:	eb fd                	jmp    8002c4 <_Z6_panicPKciS0_z+0x6c>
	...

008002c8 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 18             	sub    $0x18,%esp
  8002ce:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8002d1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8002d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  8002d7:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8002d9:	8b 03                	mov    (%ebx),%eax
  8002db:	8b 55 08             	mov    0x8(%ebp),%edx
  8002de:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002e2:	83 c0 01             	add    $0x1,%eax
  8002e5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ec:	75 19                	jne    800307 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8002ee:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002f5:	00 
  8002f6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002f9:	89 04 24             	mov    %eax,(%esp)
  8002fc:	e8 43 0a 00 00       	call   800d44 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800301:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800307:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80030b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80030e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800311:	89 ec                	mov    %ebp,%esp
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80031e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800325:	00 00 00 
	b.cnt = 0;
  800328:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800332:	8b 45 0c             	mov    0xc(%ebp),%eax
  800335:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800340:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800346:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034a:	c7 04 24 c8 02 80 00 	movl   $0x8002c8,(%esp)
  800351:	e8 a1 01 00 00       	call   8004f7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800356:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80035c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800360:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800366:	89 04 24             	mov    %eax,(%esp)
  800369:	e8 d6 09 00 00       	call   800d44 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  80036e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800374:	c9                   	leave  
  800375:	c3                   	ret    

00800376 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80037c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80037f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	89 04 24             	mov    %eax,(%esp)
  800389:	e8 87 ff ff ff       	call   800315 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	57                   	push   %edi
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
  800396:	83 ec 4c             	sub    $0x4c,%esp
  800399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039c:	89 d6                	mov    %edx,%esi
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8003aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003ad:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b5:	39 d0                	cmp    %edx,%eax
  8003b7:	72 11                	jb     8003ca <_ZL8printnumPFviPvES_yjii+0x3a>
  8003b9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003bc:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  8003bf:	76 09                	jbe    8003ca <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c1:	83 eb 01             	sub    $0x1,%ebx
  8003c4:	85 db                	test   %ebx,%ebx
  8003c6:	7f 5d                	jg     800425 <_ZL8printnumPFviPvES_yjii+0x95>
  8003c8:	eb 6c                	jmp    800436 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ca:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003ce:	83 eb 01             	sub    $0x1,%ebx
  8003d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003e0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8003ea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003f1:	00 
  8003f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003f5:	89 14 24             	mov    %edx,(%esp)
  8003f8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003ff:	e8 8c 3a 00 00       	call   803e90 <__udivdi3>
  800404:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800407:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80040a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80040e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800412:	89 04 24             	mov    %eax,(%esp)
  800415:	89 54 24 04          	mov    %edx,0x4(%esp)
  800419:	89 f2                	mov    %esi,%edx
  80041b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041e:	e8 6d ff ff ff       	call   800390 <_ZL8printnumPFviPvES_yjii>
  800423:	eb 11                	jmp    800436 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800425:	89 74 24 04          	mov    %esi,0x4(%esp)
  800429:	89 3c 24             	mov    %edi,(%esp)
  80042c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042f:	83 eb 01             	sub    $0x1,%ebx
  800432:	85 db                	test   %ebx,%ebx
  800434:	7f ef                	jg     800425 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800436:	89 74 24 04          	mov    %esi,0x4(%esp)
  80043a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80043e:	8b 45 10             	mov    0x10(%ebp),%eax
  800441:	89 44 24 08          	mov    %eax,0x8(%esp)
  800445:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80044c:	00 
  80044d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800450:	89 14 24             	mov    %edx,(%esp)
  800453:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800456:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80045a:	e8 41 3b 00 00       	call   803fa0 <__umoddi3>
  80045f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800463:	0f be 80 93 41 80 00 	movsbl 0x804193(%eax),%eax
  80046a:	89 04 24             	mov    %eax,(%esp)
  80046d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800470:	83 c4 4c             	add    $0x4c,%esp
  800473:	5b                   	pop    %ebx
  800474:	5e                   	pop    %esi
  800475:	5f                   	pop    %edi
  800476:	5d                   	pop    %ebp
  800477:	c3                   	ret    

00800478 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80047b:	83 fa 01             	cmp    $0x1,%edx
  80047e:	7e 0e                	jle    80048e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800480:	8b 10                	mov    (%eax),%edx
  800482:	8d 4a 08             	lea    0x8(%edx),%ecx
  800485:	89 08                	mov    %ecx,(%eax)
  800487:	8b 02                	mov    (%edx),%eax
  800489:	8b 52 04             	mov    0x4(%edx),%edx
  80048c:	eb 22                	jmp    8004b0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80048e:	85 d2                	test   %edx,%edx
  800490:	74 10                	je     8004a2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800492:	8b 10                	mov    (%eax),%edx
  800494:	8d 4a 04             	lea    0x4(%edx),%ecx
  800497:	89 08                	mov    %ecx,(%eax)
  800499:	8b 02                	mov    (%edx),%eax
  80049b:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a0:	eb 0e                	jmp    8004b0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004a2:	8b 10                	mov    (%eax),%edx
  8004a4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004a7:	89 08                	mov    %ecx,(%eax)
  8004a9:	8b 02                	mov    (%edx),%eax
  8004ab:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b0:	5d                   	pop    %ebp
  8004b1:	c3                   	ret    

008004b2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8004b8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004bc:	8b 10                	mov    (%eax),%edx
  8004be:	3b 50 04             	cmp    0x4(%eax),%edx
  8004c1:	73 0a                	jae    8004cd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8004c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c6:	88 0a                	mov    %cl,(%edx)
  8004c8:	83 c2 01             	add    $0x1,%edx
  8004cb:	89 10                	mov    %edx,(%eax)
}
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    

008004cf <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004d5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	89 04 24             	mov    %eax,(%esp)
  8004f0:	e8 02 00 00 00       	call   8004f7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	57                   	push   %edi
  8004fb:	56                   	push   %esi
  8004fc:	53                   	push   %ebx
  8004fd:	83 ec 3c             	sub    $0x3c,%esp
  800500:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800503:	8b 55 10             	mov    0x10(%ebp),%edx
  800506:	0f b6 02             	movzbl (%edx),%eax
  800509:	89 d3                	mov    %edx,%ebx
  80050b:	83 c3 01             	add    $0x1,%ebx
  80050e:	83 f8 25             	cmp    $0x25,%eax
  800511:	74 2b                	je     80053e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800513:	85 c0                	test   %eax,%eax
  800515:	75 10                	jne    800527 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800517:	e9 a5 03 00 00       	jmp    8008c1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80051c:	85 c0                	test   %eax,%eax
  80051e:	66 90                	xchg   %ax,%ax
  800520:	75 08                	jne    80052a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800522:	e9 9a 03 00 00       	jmp    8008c1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800527:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80052a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800533:	0f b6 03             	movzbl (%ebx),%eax
  800536:	83 c3 01             	add    $0x1,%ebx
  800539:	83 f8 25             	cmp    $0x25,%eax
  80053c:	75 de                	jne    80051c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80053e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800542:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800549:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80054e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800555:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80055d:	eb 2b                	jmp    80058a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800562:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800566:	eb 22                	jmp    80058a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800568:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80056b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80056f:	eb 19                	jmp    80058a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800571:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800574:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80057b:	eb 0d                	jmp    80058a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80057d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800580:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800583:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	0f b6 03             	movzbl (%ebx),%eax
  80058d:	0f b6 d0             	movzbl %al,%edx
  800590:	8d 73 01             	lea    0x1(%ebx),%esi
  800593:	89 75 10             	mov    %esi,0x10(%ebp)
  800596:	83 e8 23             	sub    $0x23,%eax
  800599:	3c 55                	cmp    $0x55,%al
  80059b:	0f 87 d8 02 00 00    	ja     800879 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  8005a1:	0f b6 c0             	movzbl %al,%eax
  8005a4:	ff 24 85 20 43 80 00 	jmp    *0x804320(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005ab:	83 ea 30             	sub    $0x30,%edx
  8005ae:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8005b1:	8b 55 10             	mov    0x10(%ebp),%edx
  8005b4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8005b7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8005bd:	83 fa 09             	cmp    $0x9,%edx
  8005c0:	77 4e                	ja     800610 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005c5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8005c8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8005cb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8005cf:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  8005d2:	8d 50 d0             	lea    -0x30(%eax),%edx
  8005d5:	83 fa 09             	cmp    $0x9,%edx
  8005d8:	76 eb                	jbe    8005c5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  8005da:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005dd:	eb 31                	jmp    800610 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 50 04             	lea    0x4(%eax),%edx
  8005e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005f0:	eb 1e                	jmp    800610 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8005f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f6:	0f 88 75 ff ff ff    	js     800571 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005ff:	eb 89                	jmp    80058a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800601:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800604:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80060b:	e9 7a ff ff ff       	jmp    80058a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800610:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800614:	0f 89 70 ff ff ff    	jns    80058a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80061a:	e9 5e ff ff ff       	jmp    80057d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80061f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800622:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800625:	e9 60 ff ff ff       	jmp    80058a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 50 04             	lea    0x4(%eax),%edx
  800630:	89 55 14             	mov    %edx,0x14(%ebp)
  800633:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800637:	8b 00                	mov    (%eax),%eax
  800639:	89 04 24             	mov    %eax,(%esp)
  80063c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80063f:	e9 bf fe ff ff       	jmp    800503 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 50 04             	lea    0x4(%eax),%edx
  80064a:	89 55 14             	mov    %edx,0x14(%ebp)
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	89 c2                	mov    %eax,%edx
  800651:	c1 fa 1f             	sar    $0x1f,%edx
  800654:	31 d0                	xor    %edx,%eax
  800656:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800658:	83 f8 14             	cmp    $0x14,%eax
  80065b:	7f 0f                	jg     80066c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80065d:	8b 14 85 80 44 80 00 	mov    0x804480(,%eax,4),%edx
  800664:	85 d2                	test   %edx,%edx
  800666:	0f 85 35 02 00 00    	jne    8008a1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80066c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800670:	c7 44 24 08 ab 41 80 	movl   $0x8041ab,0x8(%esp)
  800677:	00 
  800678:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80067c:	8b 75 08             	mov    0x8(%ebp),%esi
  80067f:	89 34 24             	mov    %esi,(%esp)
  800682:	e8 48 fe ff ff       	call   8004cf <_Z8printfmtPFviPvES_PKcz>
  800687:	e9 77 fe ff ff       	jmp    800503 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80068c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800692:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	89 55 14             	mov    %edx,0x14(%ebp)
  80069e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  8006a0:	85 db                	test   %ebx,%ebx
  8006a2:	ba a4 41 80 00       	mov    $0x8041a4,%edx
  8006a7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  8006aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006ae:	7e 72                	jle    800722 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8006b0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8006b4:	74 6c                	je     800722 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ba:	89 1c 24             	mov    %ebx,(%esp)
  8006bd:	e8 a9 02 00 00       	call   80096b <_Z7strnlenPKcj>
  8006c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c5:	29 c2                	sub    %eax,%edx
  8006c7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006ca:	85 d2                	test   %edx,%edx
  8006cc:	7e 54                	jle    800722 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  8006ce:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  8006d2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8006d5:	89 d3                	mov    %edx,%ebx
  8006d7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006da:	89 c6                	mov    %eax,%esi
  8006dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e0:	89 34 24             	mov    %esi,(%esp)
  8006e3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e6:	83 eb 01             	sub    $0x1,%ebx
  8006e9:	85 db                	test   %ebx,%ebx
  8006eb:	7f ef                	jg     8006dc <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  8006ed:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8006f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8006f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006fa:	eb 26                	jmp    800722 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006fc:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006ff:	83 fa 5e             	cmp    $0x5e,%edx
  800702:	76 10                	jbe    800714 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800704:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800708:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80070f:	ff 55 08             	call   *0x8(%ebp)
  800712:	eb 0a                	jmp    80071e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800714:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800718:	89 04 24             	mov    %eax,(%esp)
  80071b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800722:	0f be 03             	movsbl (%ebx),%eax
  800725:	83 c3 01             	add    $0x1,%ebx
  800728:	85 c0                	test   %eax,%eax
  80072a:	74 11                	je     80073d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80072c:	85 f6                	test   %esi,%esi
  80072e:	78 05                	js     800735 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800730:	83 ee 01             	sub    $0x1,%esi
  800733:	78 0d                	js     800742 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800735:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800739:	75 c1                	jne    8006fc <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80073b:	eb d7                	jmp    800714 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800740:	eb 03                	jmp    800745 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800745:	85 c0                	test   %eax,%eax
  800747:	0f 8e b6 fd ff ff    	jle    800503 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80074d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800750:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800753:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800757:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80075e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800760:	83 eb 01             	sub    $0x1,%ebx
  800763:	85 db                	test   %ebx,%ebx
  800765:	7f ec                	jg     800753 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800767:	e9 97 fd ff ff       	jmp    800503 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80076c:	83 f9 01             	cmp    $0x1,%ecx
  80076f:	90                   	nop
  800770:	7e 10                	jle    800782 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8d 50 08             	lea    0x8(%eax),%edx
  800778:	89 55 14             	mov    %edx,0x14(%ebp)
  80077b:	8b 18                	mov    (%eax),%ebx
  80077d:	8b 70 04             	mov    0x4(%eax),%esi
  800780:	eb 26                	jmp    8007a8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800782:	85 c9                	test   %ecx,%ecx
  800784:	74 12                	je     800798 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8d 50 04             	lea    0x4(%eax),%edx
  80078c:	89 55 14             	mov    %edx,0x14(%ebp)
  80078f:	8b 18                	mov    (%eax),%ebx
  800791:	89 de                	mov    %ebx,%esi
  800793:	c1 fe 1f             	sar    $0x1f,%esi
  800796:	eb 10                	jmp    8007a8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8d 50 04             	lea    0x4(%eax),%edx
  80079e:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a1:	8b 18                	mov    (%eax),%ebx
  8007a3:	89 de                	mov    %ebx,%esi
  8007a5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007a8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007ad:	85 f6                	test   %esi,%esi
  8007af:	0f 89 8c 00 00 00    	jns    800841 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8007b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007c0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007c3:	f7 db                	neg    %ebx
  8007c5:	83 d6 00             	adc    $0x0,%esi
  8007c8:	f7 de                	neg    %esi
			}
			base = 10;
  8007ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cf:	eb 70                	jmp    800841 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d1:	89 ca                	mov    %ecx,%edx
  8007d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d6:	e8 9d fc ff ff       	call   800478 <_ZL7getuintPPci>
  8007db:	89 c3                	mov    %eax,%ebx
  8007dd:	89 d6                	mov    %edx,%esi
			base = 10;
  8007df:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8007e4:	eb 5b                	jmp    800841 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007e6:	89 ca                	mov    %ecx,%edx
  8007e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007eb:	e8 88 fc ff ff       	call   800478 <_ZL7getuintPPci>
  8007f0:	89 c3                	mov    %eax,%ebx
  8007f2:	89 d6                	mov    %edx,%esi
			base = 8;
  8007f4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8007f9:	eb 46                	jmp    800841 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8007fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ff:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800806:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800809:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80080d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800814:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8d 50 04             	lea    0x4(%eax),%edx
  80081d:	89 55 14             	mov    %edx,0x14(%ebp)
  800820:	8b 18                	mov    (%eax),%ebx
  800822:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800827:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80082c:	eb 13                	jmp    800841 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80082e:	89 ca                	mov    %ecx,%edx
  800830:	8d 45 14             	lea    0x14(%ebp),%eax
  800833:	e8 40 fc ff ff       	call   800478 <_ZL7getuintPPci>
  800838:	89 c3                	mov    %eax,%ebx
  80083a:	89 d6                	mov    %edx,%esi
			base = 16;
  80083c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800841:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800845:	89 54 24 10          	mov    %edx,0x10(%esp)
  800849:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80084c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800850:	89 44 24 08          	mov    %eax,0x8(%esp)
  800854:	89 1c 24             	mov    %ebx,(%esp)
  800857:	89 74 24 04          	mov    %esi,0x4(%esp)
  80085b:	89 fa                	mov    %edi,%edx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	e8 2b fb ff ff       	call   800390 <_ZL8printnumPFviPvES_yjii>
			break;
  800865:	e9 99 fc ff ff       	jmp    800503 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80086a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80086e:	89 14 24             	mov    %edx,(%esp)
  800871:	ff 55 08             	call   *0x8(%ebp)
			break;
  800874:	e9 8a fc ff ff       	jmp    800503 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800879:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80087d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800884:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800887:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80088a:	89 d8                	mov    %ebx,%eax
  80088c:	eb 02                	jmp    800890 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80088e:	89 d0                	mov    %edx,%eax
  800890:	8d 50 ff             	lea    -0x1(%eax),%edx
  800893:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800897:	75 f5                	jne    80088e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800899:	89 45 10             	mov    %eax,0x10(%ebp)
  80089c:	e9 62 fc ff ff       	jmp    800503 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008a5:	c7 44 24 08 1e 45 80 	movl   $0x80451e,0x8(%esp)
  8008ac:	00 
  8008ad:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b4:	89 34 24             	mov    %esi,(%esp)
  8008b7:	e8 13 fc ff ff       	call   8004cf <_Z8printfmtPFviPvES_PKcz>
  8008bc:	e9 42 fc ff ff       	jmp    800503 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008c1:	83 c4 3c             	add    $0x3c,%esp
  8008c4:	5b                   	pop    %ebx
  8008c5:	5e                   	pop    %esi
  8008c6:	5f                   	pop    %edi
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 28             	sub    $0x28,%esp
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8008dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008df:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  8008e6:	85 c0                	test   %eax,%eax
  8008e8:	74 30                	je     80091a <_Z9vsnprintfPciPKcS_+0x51>
  8008ea:	85 d2                	test   %edx,%edx
  8008ec:	7e 2c                	jle    80091a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  8008ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800903:	c7 04 24 b2 04 80 00 	movl   $0x8004b2,(%esp)
  80090a:	e8 e8 fb ff ff       	call   8004f7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80090f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800912:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800918:	eb 05                	jmp    80091f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80091a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80091f:	c9                   	leave  
  800920:	c3                   	ret    

00800921 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800927:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80092a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	89 44 24 08          	mov    %eax,0x8(%esp)
  800935:	8b 45 0c             	mov    0xc(%ebp),%eax
  800938:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 04 24             	mov    %eax,(%esp)
  800942:	e8 82 ff ff ff       	call   8008c9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800947:	c9                   	leave  
  800948:	c3                   	ret    
  800949:	00 00                	add    %al,(%eax)
  80094b:	00 00                	add    %al,(%eax)
  80094d:	00 00                	add    %al,(%eax)
	...

00800950 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	80 3a 00             	cmpb   $0x0,(%edx)
  80095e:	74 09                	je     800969 <_Z6strlenPKc+0x19>
		n++;
  800960:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800963:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800967:	75 f7                	jne    800960 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800971:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800974:	b8 00 00 00 00       	mov    $0x0,%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	74 0b                	je     800988 <_Z7strnlenPKcj+0x1d>
  80097d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800981:	74 05                	je     800988 <_Z7strnlenPKcj+0x1d>
		n++;
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	eb f1                	jmp    800979 <_Z7strnlenPKcj+0xe>
	return n;
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	53                   	push   %ebx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
  800999:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80099d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009a0:	83 c2 01             	add    $0x1,%edx
  8009a3:	84 c9                	test   %cl,%cl
  8009a5:	75 f2                	jne    800999 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	56                   	push   %esi
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8009b8:	85 f6                	test   %esi,%esi
  8009ba:	74 18                	je     8009d4 <_Z7strncpyPcPKcj+0x2a>
  8009bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009c1:	0f b6 1a             	movzbl (%edx),%ebx
  8009c4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c7:	80 3a 01             	cmpb   $0x1,(%edx)
  8009ca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8009cd:	83 c1 01             	add    $0x1,%ecx
  8009d0:	39 ce                	cmp    %ecx,%esi
  8009d2:	77 ed                	ja     8009c1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009d4:	5b                   	pop    %ebx
  8009d5:	5e                   	pop    %esi
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  8009e6:	89 f0                	mov    %esi,%eax
  8009e8:	85 d2                	test   %edx,%edx
  8009ea:	74 17                	je     800a03 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  8009ec:	83 ea 01             	sub    $0x1,%edx
  8009ef:	74 18                	je     800a09 <_Z7strlcpyPcPKcj+0x31>
  8009f1:	80 39 00             	cmpb   $0x0,(%ecx)
  8009f4:	74 17                	je     800a0d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8009f6:	0f b6 19             	movzbl (%ecx),%ebx
  8009f9:	88 18                	mov    %bl,(%eax)
  8009fb:	83 c0 01             	add    $0x1,%eax
  8009fe:	83 c1 01             	add    $0x1,%ecx
  800a01:	eb e9                	jmp    8009ec <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800a03:	29 f0                	sub    %esi,%eax
}
  800a05:	5b                   	pop    %ebx
  800a06:	5e                   	pop    %esi
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a09:	89 c2                	mov    %eax,%edx
  800a0b:	eb 02                	jmp    800a0f <_Z7strlcpyPcPKcj+0x37>
  800a0d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a0f:	c6 02 00             	movb   $0x0,(%edx)
  800a12:	eb ef                	jmp    800a03 <_Z7strlcpyPcPKcj+0x2b>

00800a14 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a1d:	0f b6 01             	movzbl (%ecx),%eax
  800a20:	84 c0                	test   %al,%al
  800a22:	74 0c                	je     800a30 <_Z6strcmpPKcS0_+0x1c>
  800a24:	3a 02                	cmp    (%edx),%al
  800a26:	75 08                	jne    800a30 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800a28:	83 c1 01             	add    $0x1,%ecx
  800a2b:	83 c2 01             	add    $0x1,%edx
  800a2e:	eb ed                	jmp    800a1d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800a30:	0f b6 c0             	movzbl %al,%eax
  800a33:	0f b6 12             	movzbl (%edx),%edx
  800a36:	29 d0                	sub    %edx,%eax
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	53                   	push   %ebx
  800a3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a44:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800a47:	85 d2                	test   %edx,%edx
  800a49:	74 16                	je     800a61 <_Z7strncmpPKcS0_j+0x27>
  800a4b:	0f b6 01             	movzbl (%ecx),%eax
  800a4e:	84 c0                	test   %al,%al
  800a50:	74 17                	je     800a69 <_Z7strncmpPKcS0_j+0x2f>
  800a52:	3a 03                	cmp    (%ebx),%al
  800a54:	75 13                	jne    800a69 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800a56:	83 ea 01             	sub    $0x1,%edx
  800a59:	83 c1 01             	add    $0x1,%ecx
  800a5c:	83 c3 01             	add    $0x1,%ebx
  800a5f:	eb e6                	jmp    800a47 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800a61:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800a66:	5b                   	pop    %ebx
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800a69:	0f b6 01             	movzbl (%ecx),%eax
  800a6c:	0f b6 13             	movzbl (%ebx),%edx
  800a6f:	29 d0                	sub    %edx,%eax
  800a71:	eb f3                	jmp    800a66 <_Z7strncmpPKcS0_j+0x2c>

00800a73 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7d:	0f b6 10             	movzbl (%eax),%edx
  800a80:	84 d2                	test   %dl,%dl
  800a82:	74 1f                	je     800aa3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800a84:	38 ca                	cmp    %cl,%dl
  800a86:	75 0a                	jne    800a92 <_Z6strchrPKcc+0x1f>
  800a88:	eb 1e                	jmp    800aa8 <_Z6strchrPKcc+0x35>
  800a8a:	38 ca                	cmp    %cl,%dl
  800a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a90:	74 16                	je     800aa8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a92:	83 c0 01             	add    $0x1,%eax
  800a95:	0f b6 10             	movzbl (%eax),%edx
  800a98:	84 d2                	test   %dl,%dl
  800a9a:	75 ee                	jne    800a8a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa1:	eb 05                	jmp    800aa8 <_Z6strchrPKcc+0x35>
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab4:	0f b6 10             	movzbl (%eax),%edx
  800ab7:	84 d2                	test   %dl,%dl
  800ab9:	74 14                	je     800acf <_Z7strfindPKcc+0x25>
		if (*s == c)
  800abb:	38 ca                	cmp    %cl,%dl
  800abd:	75 06                	jne    800ac5 <_Z7strfindPKcc+0x1b>
  800abf:	eb 0e                	jmp    800acf <_Z7strfindPKcc+0x25>
  800ac1:	38 ca                	cmp    %cl,%dl
  800ac3:	74 0a                	je     800acf <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ac5:	83 c0 01             	add    $0x1,%eax
  800ac8:	0f b6 10             	movzbl (%eax),%edx
  800acb:	84 d2                	test   %dl,%dl
  800acd:	75 f2                	jne    800ac1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 0c             	sub    $0xc,%esp
  800ad7:	89 1c 24             	mov    %ebx,(%esp)
  800ada:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ade:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ae2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800aeb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800af1:	75 25                	jne    800b18 <memset+0x47>
  800af3:	f6 c1 03             	test   $0x3,%cl
  800af6:	75 20                	jne    800b18 <memset+0x47>
		c &= 0xFF;
  800af8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800afb:	89 d3                	mov    %edx,%ebx
  800afd:	c1 e3 08             	shl    $0x8,%ebx
  800b00:	89 d6                	mov    %edx,%esi
  800b02:	c1 e6 18             	shl    $0x18,%esi
  800b05:	89 d0                	mov    %edx,%eax
  800b07:	c1 e0 10             	shl    $0x10,%eax
  800b0a:	09 f0                	or     %esi,%eax
  800b0c:	09 d0                	or     %edx,%eax
  800b0e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800b10:	c1 e9 02             	shr    $0x2,%ecx
  800b13:	fc                   	cld    
  800b14:	f3 ab                	rep stos %eax,%es:(%edi)
  800b16:	eb 03                	jmp    800b1b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800b18:	fc                   	cld    
  800b19:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800b1b:	89 f8                	mov    %edi,%eax
  800b1d:	8b 1c 24             	mov    (%esp),%ebx
  800b20:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b28:	89 ec                	mov    %ebp,%esp
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	89 34 24             	mov    %esi,(%esp)
  800b35:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800b42:	39 c6                	cmp    %eax,%esi
  800b44:	73 36                	jae    800b7c <memmove+0x50>
  800b46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b49:	39 d0                	cmp    %edx,%eax
  800b4b:	73 2f                	jae    800b7c <memmove+0x50>
		s += n;
		d += n;
  800b4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b50:	f6 c2 03             	test   $0x3,%dl
  800b53:	75 1b                	jne    800b70 <memmove+0x44>
  800b55:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b5b:	75 13                	jne    800b70 <memmove+0x44>
  800b5d:	f6 c1 03             	test   $0x3,%cl
  800b60:	75 0e                	jne    800b70 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b62:	83 ef 04             	sub    $0x4,%edi
  800b65:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b68:	c1 e9 02             	shr    $0x2,%ecx
  800b6b:	fd                   	std    
  800b6c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6e:	eb 09                	jmp    800b79 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b70:	83 ef 01             	sub    $0x1,%edi
  800b73:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b76:	fd                   	std    
  800b77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b79:	fc                   	cld    
  800b7a:	eb 20                	jmp    800b9c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b7c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b82:	75 13                	jne    800b97 <memmove+0x6b>
  800b84:	a8 03                	test   $0x3,%al
  800b86:	75 0f                	jne    800b97 <memmove+0x6b>
  800b88:	f6 c1 03             	test   $0x3,%cl
  800b8b:	75 0a                	jne    800b97 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b8d:	c1 e9 02             	shr    $0x2,%ecx
  800b90:	89 c7                	mov    %eax,%edi
  800b92:	fc                   	cld    
  800b93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b95:	eb 05                	jmp    800b9c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b97:	89 c7                	mov    %eax,%edi
  800b99:	fc                   	cld    
  800b9a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800b9c:	8b 34 24             	mov    (%esp),%esi
  800b9f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ba3:	89 ec                	mov    %ebp,%esp
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	89 34 24             	mov    %esi,(%esp)
  800bb0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bba:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800bbd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bc3:	75 13                	jne    800bd8 <memcpy+0x31>
  800bc5:	a8 03                	test   $0x3,%al
  800bc7:	75 0f                	jne    800bd8 <memcpy+0x31>
  800bc9:	f6 c1 03             	test   $0x3,%cl
  800bcc:	75 0a                	jne    800bd8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bce:	c1 e9 02             	shr    $0x2,%ecx
  800bd1:	89 c7                	mov    %eax,%edi
  800bd3:	fc                   	cld    
  800bd4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd6:	eb 05                	jmp    800bdd <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800bd8:	89 c7                	mov    %eax,%edi
  800bda:	fc                   	cld    
  800bdb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800bdd:	8b 34 24             	mov    (%esp),%esi
  800be0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800be4:	89 ec                	mov    %ebp,%esp
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	57                   	push   %edi
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800bf7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800bfc:	85 ff                	test   %edi,%edi
  800bfe:	74 38                	je     800c38 <memcmp+0x50>
		if (*s1 != *s2)
  800c00:	0f b6 03             	movzbl (%ebx),%eax
  800c03:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800c06:	83 ef 01             	sub    $0x1,%edi
  800c09:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800c0e:	38 c8                	cmp    %cl,%al
  800c10:	74 1d                	je     800c2f <memcmp+0x47>
  800c12:	eb 11                	jmp    800c25 <memcmp+0x3d>
  800c14:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800c19:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800c1e:	83 c2 01             	add    $0x1,%edx
  800c21:	38 c8                	cmp    %cl,%al
  800c23:	74 0a                	je     800c2f <memcmp+0x47>
			return *s1 - *s2;
  800c25:	0f b6 c0             	movzbl %al,%eax
  800c28:	0f b6 c9             	movzbl %cl,%ecx
  800c2b:	29 c8                	sub    %ecx,%eax
  800c2d:	eb 09                	jmp    800c38 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800c2f:	39 fa                	cmp    %edi,%edx
  800c31:	75 e1                	jne    800c14 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5f                   	pop    %edi
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    

00800c3d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	53                   	push   %ebx
  800c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800c44:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800c46:	89 da                	mov    %ebx,%edx
  800c48:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800c4b:	39 d3                	cmp    %edx,%ebx
  800c4d:	73 15                	jae    800c64 <memfind+0x27>
		if (*s == (unsigned char) c)
  800c4f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c53:	38 0b                	cmp    %cl,(%ebx)
  800c55:	75 06                	jne    800c5d <memfind+0x20>
  800c57:	eb 0b                	jmp    800c64 <memfind+0x27>
  800c59:	38 08                	cmp    %cl,(%eax)
  800c5b:	74 07                	je     800c64 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800c5d:	83 c0 01             	add    $0x1,%eax
  800c60:	39 c2                	cmp    %eax,%edx
  800c62:	77 f5                	ja     800c59 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c64:	5b                   	pop    %ebx
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
  800c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c70:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c73:	0f b6 02             	movzbl (%edx),%eax
  800c76:	3c 20                	cmp    $0x20,%al
  800c78:	74 04                	je     800c7e <_Z6strtolPKcPPci+0x17>
  800c7a:	3c 09                	cmp    $0x9,%al
  800c7c:	75 0e                	jne    800c8c <_Z6strtolPKcPPci+0x25>
		s++;
  800c7e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c81:	0f b6 02             	movzbl (%edx),%eax
  800c84:	3c 20                	cmp    $0x20,%al
  800c86:	74 f6                	je     800c7e <_Z6strtolPKcPPci+0x17>
  800c88:	3c 09                	cmp    $0x9,%al
  800c8a:	74 f2                	je     800c7e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c8c:	3c 2b                	cmp    $0x2b,%al
  800c8e:	75 0a                	jne    800c9a <_Z6strtolPKcPPci+0x33>
		s++;
  800c90:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c93:	bf 00 00 00 00       	mov    $0x0,%edi
  800c98:	eb 10                	jmp    800caa <_Z6strtolPKcPPci+0x43>
  800c9a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c9f:	3c 2d                	cmp    $0x2d,%al
  800ca1:	75 07                	jne    800caa <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800ca3:	83 c2 01             	add    $0x1,%edx
  800ca6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800caa:	85 db                	test   %ebx,%ebx
  800cac:	0f 94 c0             	sete   %al
  800caf:	74 05                	je     800cb6 <_Z6strtolPKcPPci+0x4f>
  800cb1:	83 fb 10             	cmp    $0x10,%ebx
  800cb4:	75 15                	jne    800ccb <_Z6strtolPKcPPci+0x64>
  800cb6:	80 3a 30             	cmpb   $0x30,(%edx)
  800cb9:	75 10                	jne    800ccb <_Z6strtolPKcPPci+0x64>
  800cbb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cbf:	75 0a                	jne    800ccb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800cc1:	83 c2 02             	add    $0x2,%edx
  800cc4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cc9:	eb 13                	jmp    800cde <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800ccb:	84 c0                	test   %al,%al
  800ccd:	74 0f                	je     800cde <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ccf:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cd4:	80 3a 30             	cmpb   $0x30,(%edx)
  800cd7:	75 05                	jne    800cde <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800cd9:	83 c2 01             	add    $0x1,%edx
  800cdc:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800cde:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ce5:	0f b6 0a             	movzbl (%edx),%ecx
  800ce8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ceb:	80 fb 09             	cmp    $0x9,%bl
  800cee:	77 08                	ja     800cf8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800cf0:	0f be c9             	movsbl %cl,%ecx
  800cf3:	83 e9 30             	sub    $0x30,%ecx
  800cf6:	eb 1e                	jmp    800d16 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800cf8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800cfb:	80 fb 19             	cmp    $0x19,%bl
  800cfe:	77 08                	ja     800d08 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800d00:	0f be c9             	movsbl %cl,%ecx
  800d03:	83 e9 57             	sub    $0x57,%ecx
  800d06:	eb 0e                	jmp    800d16 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800d08:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800d0b:	80 fb 19             	cmp    $0x19,%bl
  800d0e:	77 15                	ja     800d25 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800d10:	0f be c9             	movsbl %cl,%ecx
  800d13:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d16:	39 f1                	cmp    %esi,%ecx
  800d18:	7d 0f                	jge    800d29 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800d1a:	83 c2 01             	add    $0x1,%edx
  800d1d:	0f af c6             	imul   %esi,%eax
  800d20:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800d23:	eb c0                	jmp    800ce5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800d25:	89 c1                	mov    %eax,%ecx
  800d27:	eb 02                	jmp    800d2b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d29:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2f:	74 05                	je     800d36 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800d31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d34:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d36:	89 ca                	mov    %ecx,%edx
  800d38:	f7 da                	neg    %edx
  800d3a:	85 ff                	test   %edi,%edi
  800d3c:	0f 45 c2             	cmovne %edx,%eax
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 0c             	sub    $0xc,%esp
  800d4a:	89 1c 24             	mov    %ebx,(%esp)
  800d4d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d51:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d55:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d60:	89 c3                	mov    %eax,%ebx
  800d62:	89 c7                	mov    %eax,%edi
  800d64:	89 c6                	mov    %eax,%esi
  800d66:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d68:	8b 1c 24             	mov    (%esp),%ebx
  800d6b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d6f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d73:	89 ec                	mov    %ebp,%esp
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    

00800d77 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 0c             	sub    $0xc,%esp
  800d7d:	89 1c 24             	mov    %ebx,(%esp)
  800d80:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d84:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d88:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8d:	b8 01 00 00 00       	mov    $0x1,%eax
  800d92:	89 d1                	mov    %edx,%ecx
  800d94:	89 d3                	mov    %edx,%ebx
  800d96:	89 d7                	mov    %edx,%edi
  800d98:	89 d6                	mov    %edx,%esi
  800d9a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d9c:	8b 1c 24             	mov    (%esp),%ebx
  800d9f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800da3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800da7:	89 ec                	mov    %ebp,%esp
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 38             	sub    $0x38,%esp
  800db1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800db4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800db7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dbf:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	89 cb                	mov    %ecx,%ebx
  800dc9:	89 cf                	mov    %ecx,%edi
  800dcb:	89 ce                	mov    %ecx,%esi
  800dcd:	cd 30                	int    $0x30

	if(check && ret > 0)
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	7e 28                	jle    800dfb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800dde:	00 
  800ddf:	c7 44 24 08 d4 44 80 	movl   $0x8044d4,0x8(%esp)
  800de6:	00 
  800de7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dee:	00 
  800def:	c7 04 24 f1 44 80 00 	movl   $0x8044f1,(%esp)
  800df6:	e8 5d f4 ff ff       	call   800258 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dfb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dfe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e01:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e04:	89 ec                	mov    %ebp,%esp
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    

00800e08 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 0c             	sub    $0xc,%esp
  800e0e:	89 1c 24             	mov    %ebx,(%esp)
  800e11:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e15:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e19:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1e:	b8 02 00 00 00       	mov    $0x2,%eax
  800e23:	89 d1                	mov    %edx,%ecx
  800e25:	89 d3                	mov    %edx,%ebx
  800e27:	89 d7                	mov    %edx,%edi
  800e29:	89 d6                	mov    %edx,%esi
  800e2b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e2d:	8b 1c 24             	mov    (%esp),%ebx
  800e30:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e38:	89 ec                	mov    %ebp,%esp
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	89 1c 24             	mov    %ebx,(%esp)
  800e45:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e49:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e52:	b8 04 00 00 00       	mov    $0x4,%eax
  800e57:	89 d1                	mov    %edx,%ecx
  800e59:	89 d3                	mov    %edx,%ebx
  800e5b:	89 d7                	mov    %edx,%edi
  800e5d:	89 d6                	mov    %edx,%esi
  800e5f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e61:	8b 1c 24             	mov    (%esp),%ebx
  800e64:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e68:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e6c:	89 ec                	mov    %ebp,%esp
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 38             	sub    $0x38,%esp
  800e76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e79:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e7c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e7f:	be 00 00 00 00       	mov    $0x0,%esi
  800e84:	b8 08 00 00 00       	mov    $0x8,%eax
  800e89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	89 f7                	mov    %esi,%edi
  800e94:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e96:	85 c0                	test   %eax,%eax
  800e98:	7e 28                	jle    800ec2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ea5:	00 
  800ea6:	c7 44 24 08 d4 44 80 	movl   $0x8044d4,0x8(%esp)
  800ead:	00 
  800eae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb5:	00 
  800eb6:	c7 04 24 f1 44 80 00 	movl   $0x8044f1,(%esp)
  800ebd:	e8 96 f3 ff ff       	call   800258 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ec2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ecb:	89 ec                	mov    %ebp,%esp
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 38             	sub    $0x38,%esp
  800ed5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800edb:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ede:	b8 09 00 00 00       	mov    $0x9,%eax
  800ee3:	8b 75 18             	mov    0x18(%ebp),%esi
  800ee6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	7e 28                	jle    800f20 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f03:	00 
  800f04:	c7 44 24 08 d4 44 80 	movl   $0x8044d4,0x8(%esp)
  800f0b:	00 
  800f0c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f13:	00 
  800f14:	c7 04 24 f1 44 80 00 	movl   $0x8044f1,(%esp)
  800f1b:	e8 38 f3 ff ff       	call   800258 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f20:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f23:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f26:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f29:	89 ec                	mov    %ebp,%esp
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 38             	sub    $0x38,%esp
  800f33:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f36:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f39:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	89 df                	mov    %ebx,%edi
  800f4e:	89 de                	mov    %ebx,%esi
  800f50:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f52:	85 c0                	test   %eax,%eax
  800f54:	7e 28                	jle    800f7e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f61:	00 
  800f62:	c7 44 24 08 d4 44 80 	movl   $0x8044d4,0x8(%esp)
  800f69:	00 
  800f6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f71:	00 
  800f72:	c7 04 24 f1 44 80 00 	movl   $0x8044f1,(%esp)
  800f79:	e8 da f2 ff ff       	call   800258 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f7e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f81:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f84:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f87:	89 ec                	mov    %ebp,%esp
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 38             	sub    $0x38,%esp
  800f91:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f94:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f97:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9f:	b8 05 00 00 00       	mov    $0x5,%eax
  800fa4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa7:	8b 55 08             	mov    0x8(%ebp),%edx
  800faa:	89 df                	mov    %ebx,%edi
  800fac:	89 de                	mov    %ebx,%esi
  800fae:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	7e 28                	jle    800fdc <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fbf:	00 
  800fc0:	c7 44 24 08 d4 44 80 	movl   $0x8044d4,0x8(%esp)
  800fc7:	00 
  800fc8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fcf:	00 
  800fd0:	c7 04 24 f1 44 80 00 	movl   $0x8044f1,(%esp)
  800fd7:	e8 7c f2 ff ff       	call   800258 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fdc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fdf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe5:	89 ec                	mov    %ebp,%esp
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    

00800fe9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 38             	sub    $0x38,%esp
  800fef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ff2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ff5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ff8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffd:	b8 06 00 00 00       	mov    $0x6,%eax
  801002:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	89 df                	mov    %ebx,%edi
  80100a:	89 de                	mov    %ebx,%esi
  80100c:	cd 30                	int    $0x30

	if(check && ret > 0)
  80100e:	85 c0                	test   %eax,%eax
  801010:	7e 28                	jle    80103a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801012:	89 44 24 10          	mov    %eax,0x10(%esp)
  801016:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80101d:	00 
  80101e:	c7 44 24 08 d4 44 80 	movl   $0x8044d4,0x8(%esp)
  801025:	00 
  801026:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80102d:	00 
  80102e:	c7 04 24 f1 44 80 00 	movl   $0x8044f1,(%esp)
  801035:	e8 1e f2 ff ff       	call   800258 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80103a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80103d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801040:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801043:	89 ec                	mov    %ebp,%esp
  801045:	5d                   	pop    %ebp
  801046:	c3                   	ret    

00801047 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 38             	sub    $0x38,%esp
  80104d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801050:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801053:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801056:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801060:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801063:	8b 55 08             	mov    0x8(%ebp),%edx
  801066:	89 df                	mov    %ebx,%edi
  801068:	89 de                	mov    %ebx,%esi
  80106a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80106c:	85 c0                	test   %eax,%eax
  80106e:	7e 28                	jle    801098 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801070:	89 44 24 10          	mov    %eax,0x10(%esp)
  801074:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80107b:	00 
  80107c:	c7 44 24 08 d4 44 80 	movl   $0x8044d4,0x8(%esp)
  801083:	00 
  801084:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80108b:	00 
  80108c:	c7 04 24 f1 44 80 00 	movl   $0x8044f1,(%esp)
  801093:	e8 c0 f1 ff ff       	call   800258 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801098:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80109b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80109e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010a1:	89 ec                	mov    %ebp,%esp
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 38             	sub    $0x38,%esp
  8010ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c4:	89 df                	mov    %ebx,%edi
  8010c6:	89 de                	mov    %ebx,%esi
  8010c8:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	7e 28                	jle    8010f6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  8010d9:	00 
  8010da:	c7 44 24 08 d4 44 80 	movl   $0x8044d4,0x8(%esp)
  8010e1:	00 
  8010e2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e9:	00 
  8010ea:	c7 04 24 f1 44 80 00 	movl   $0x8044f1,(%esp)
  8010f1:	e8 62 f1 ff ff       	call   800258 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010f6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010fc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ff:	89 ec                	mov    %ebp,%esp
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    

00801103 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	89 1c 24             	mov    %ebx,(%esp)
  80110c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801110:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801114:	be 00 00 00 00       	mov    $0x0,%esi
  801119:	b8 0d 00 00 00       	mov    $0xd,%eax
  80111e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801121:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801124:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801127:	8b 55 08             	mov    0x8(%ebp),%edx
  80112a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80112c:	8b 1c 24             	mov    (%esp),%ebx
  80112f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801133:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801137:	89 ec                	mov    %ebp,%esp
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	83 ec 38             	sub    $0x38,%esp
  801141:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801144:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801147:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80114a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80114f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	89 cb                	mov    %ecx,%ebx
  801159:	89 cf                	mov    %ecx,%edi
  80115b:	89 ce                	mov    %ecx,%esi
  80115d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80115f:	85 c0                	test   %eax,%eax
  801161:	7e 28                	jle    80118b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801163:	89 44 24 10          	mov    %eax,0x10(%esp)
  801167:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80116e:	00 
  80116f:	c7 44 24 08 d4 44 80 	movl   $0x8044d4,0x8(%esp)
  801176:	00 
  801177:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80117e:	00 
  80117f:	c7 04 24 f1 44 80 00 	movl   $0x8044f1,(%esp)
  801186:	e8 cd f0 ff ff       	call   800258 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80118b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80118e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801191:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801194:	89 ec                	mov    %ebp,%esp
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	89 1c 24             	mov    %ebx,(%esp)
  8011a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011a5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ae:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b9:	89 df                	mov    %ebx,%edi
  8011bb:	89 de                	mov    %ebx,%esi
  8011bd:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8011bf:	8b 1c 24             	mov    (%esp),%ebx
  8011c2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011c6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ca:	89 ec                	mov    %ebp,%esp
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    

008011ce <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 0c             	sub    $0xc,%esp
  8011d4:	89 1c 24             	mov    %ebx,(%esp)
  8011d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011db:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011df:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e4:	b8 11 00 00 00       	mov    $0x11,%eax
  8011e9:	89 d1                	mov    %edx,%ecx
  8011eb:	89 d3                	mov    %edx,%ebx
  8011ed:	89 d7                	mov    %edx,%edi
  8011ef:	89 d6                	mov    %edx,%esi
  8011f1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011f3:	8b 1c 24             	mov    (%esp),%ebx
  8011f6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011fa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011fe:	89 ec                	mov    %ebp,%esp
  801200:	5d                   	pop    %ebp
  801201:	c3                   	ret    

00801202 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	89 1c 24             	mov    %ebx,(%esp)
  80120b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80120f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801213:	bb 00 00 00 00       	mov    $0x0,%ebx
  801218:	b8 12 00 00 00       	mov    $0x12,%eax
  80121d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801220:	8b 55 08             	mov    0x8(%ebp),%edx
  801223:	89 df                	mov    %ebx,%edi
  801225:	89 de                	mov    %ebx,%esi
  801227:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801229:	8b 1c 24             	mov    (%esp),%ebx
  80122c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801230:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801234:	89 ec                	mov    %ebp,%esp
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	89 1c 24             	mov    %ebx,(%esp)
  801241:	89 74 24 04          	mov    %esi,0x4(%esp)
  801245:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801249:	b9 00 00 00 00       	mov    $0x0,%ecx
  80124e:	b8 13 00 00 00       	mov    $0x13,%eax
  801253:	8b 55 08             	mov    0x8(%ebp),%edx
  801256:	89 cb                	mov    %ecx,%ebx
  801258:	89 cf                	mov    %ecx,%edi
  80125a:	89 ce                	mov    %ecx,%esi
  80125c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80125e:	8b 1c 24             	mov    (%esp),%ebx
  801261:	8b 74 24 04          	mov    0x4(%esp),%esi
  801265:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801269:	89 ec                	mov    %ebp,%esp
  80126b:	5d                   	pop    %ebp
  80126c:	c3                   	ret    

0080126d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	89 1c 24             	mov    %ebx,(%esp)
  801276:	89 74 24 04          	mov    %esi,0x4(%esp)
  80127a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80127e:	b8 10 00 00 00       	mov    $0x10,%eax
  801283:	8b 75 18             	mov    0x18(%ebp),%esi
  801286:	8b 7d 14             	mov    0x14(%ebp),%edi
  801289:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80128c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128f:	8b 55 08             	mov    0x8(%ebp),%edx
  801292:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801294:	8b 1c 24             	mov    (%esp),%ebx
  801297:	8b 74 24 04          	mov    0x4(%esp),%esi
  80129b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80129f:	89 ec                	mov    %ebp,%esp
  8012a1:	5d                   	pop    %ebp
  8012a2:	c3                   	ret    
	...

008012b0 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8012b3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8012b8:	75 11                	jne    8012cb <_ZL8fd_validPK2Fd+0x1b>
  8012ba:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  8012bf:	76 0a                	jbe    8012cb <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  8012c1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  8012c6:	0f 96 c0             	setbe  %al
  8012c9:	eb 05                	jmp    8012d0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8012cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d0:	5d                   	pop    %ebp
  8012d1:	c3                   	ret    

008012d2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	53                   	push   %ebx
  8012d6:	83 ec 14             	sub    $0x14,%esp
  8012d9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8012db:	e8 d0 ff ff ff       	call   8012b0 <_ZL8fd_validPK2Fd>
  8012e0:	84 c0                	test   %al,%al
  8012e2:	75 24                	jne    801308 <_ZL9fd_isopenPK2Fd+0x36>
  8012e4:	c7 44 24 0c ff 44 80 	movl   $0x8044ff,0xc(%esp)
  8012eb:	00 
  8012ec:	c7 44 24 08 0c 45 80 	movl   $0x80450c,0x8(%esp)
  8012f3:	00 
  8012f4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8012fb:	00 
  8012fc:	c7 04 24 21 45 80 00 	movl   $0x804521,(%esp)
  801303:	e8 50 ef ff ff       	call   800258 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801308:	89 d8                	mov    %ebx,%eax
  80130a:	c1 e8 16             	shr    $0x16,%eax
  80130d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801314:	b8 00 00 00 00       	mov    $0x0,%eax
  801319:	f6 c2 01             	test   $0x1,%dl
  80131c:	74 0d                	je     80132b <_ZL9fd_isopenPK2Fd+0x59>
  80131e:	c1 eb 0c             	shr    $0xc,%ebx
  801321:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801328:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80132b:	83 c4 14             	add    $0x14,%esp
  80132e:	5b                   	pop    %ebx
  80132f:	5d                   	pop    %ebp
  801330:	c3                   	ret    

00801331 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	89 1c 24             	mov    %ebx,(%esp)
  80133a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80133e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801341:	8b 75 0c             	mov    0xc(%ebp),%esi
  801344:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801348:	83 fb 1f             	cmp    $0x1f,%ebx
  80134b:	77 18                	ja     801365 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80134d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801353:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801356:	84 c0                	test   %al,%al
  801358:	74 21                	je     80137b <_Z9fd_lookupiPP2Fdb+0x4a>
  80135a:	89 d8                	mov    %ebx,%eax
  80135c:	e8 71 ff ff ff       	call   8012d2 <_ZL9fd_isopenPK2Fd>
  801361:	84 c0                	test   %al,%al
  801363:	75 16                	jne    80137b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801365:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80136b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801370:	8b 1c 24             	mov    (%esp),%ebx
  801373:	8b 74 24 04          	mov    0x4(%esp),%esi
  801377:	89 ec                	mov    %ebp,%esp
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80137b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80137d:	b8 00 00 00 00       	mov    $0x0,%eax
  801382:	eb ec                	jmp    801370 <_Z9fd_lookupiPP2Fdb+0x3f>

00801384 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	53                   	push   %ebx
  801388:	83 ec 14             	sub    $0x14,%esp
  80138b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80138e:	89 d8                	mov    %ebx,%eax
  801390:	e8 1b ff ff ff       	call   8012b0 <_ZL8fd_validPK2Fd>
  801395:	84 c0                	test   %al,%al
  801397:	75 24                	jne    8013bd <_Z6fd2numP2Fd+0x39>
  801399:	c7 44 24 0c ff 44 80 	movl   $0x8044ff,0xc(%esp)
  8013a0:	00 
  8013a1:	c7 44 24 08 0c 45 80 	movl   $0x80450c,0x8(%esp)
  8013a8:	00 
  8013a9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8013b0:	00 
  8013b1:	c7 04 24 21 45 80 00 	movl   $0x804521,(%esp)
  8013b8:	e8 9b ee ff ff       	call   800258 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013bd:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  8013c3:	c1 e8 0c             	shr    $0xc,%eax
}
  8013c6:	83 c4 14             	add    $0x14,%esp
  8013c9:	5b                   	pop    %ebx
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    

008013cc <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	89 04 24             	mov    %eax,(%esp)
  8013d8:	e8 a7 ff ff ff       	call   801384 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8013dd:	05 20 00 0d 00       	add    $0xd0020,%eax
  8013e2:	c1 e0 0c             	shl    $0xc,%eax
}
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	57                   	push   %edi
  8013eb:	56                   	push   %esi
  8013ec:	53                   	push   %ebx
  8013ed:	83 ec 2c             	sub    $0x2c,%esp
  8013f0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8013f3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8013f8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8013fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801402:	00 
  801403:	89 74 24 04          	mov    %esi,0x4(%esp)
  801407:	89 1c 24             	mov    %ebx,(%esp)
  80140a:	e8 22 ff ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80140f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801412:	e8 bb fe ff ff       	call   8012d2 <_ZL9fd_isopenPK2Fd>
  801417:	84 c0                	test   %al,%al
  801419:	75 0c                	jne    801427 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80141b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80141e:	89 07                	mov    %eax,(%edi)
			return 0;
  801420:	b8 00 00 00 00       	mov    $0x0,%eax
  801425:	eb 13                	jmp    80143a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801427:	83 c3 01             	add    $0x1,%ebx
  80142a:	83 fb 20             	cmp    $0x20,%ebx
  80142d:	75 cc                	jne    8013fb <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80142f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801435:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80143a:	83 c4 2c             	add    $0x2c,%esp
  80143d:	5b                   	pop    %ebx
  80143e:	5e                   	pop    %esi
  80143f:	5f                   	pop    %edi
  801440:	5d                   	pop    %ebp
  801441:	c3                   	ret    

00801442 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	53                   	push   %ebx
  801446:	83 ec 14             	sub    $0x14,%esp
  801449:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80144c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80144f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801454:	39 0d 08 50 80 00    	cmp    %ecx,0x805008
  80145a:	75 16                	jne    801472 <_Z10dev_lookupiPP3Dev+0x30>
  80145c:	eb 06                	jmp    801464 <_Z10dev_lookupiPP3Dev+0x22>
  80145e:	39 0a                	cmp    %ecx,(%edx)
  801460:	75 10                	jne    801472 <_Z10dev_lookupiPP3Dev+0x30>
  801462:	eb 05                	jmp    801469 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801464:	ba 08 50 80 00       	mov    $0x805008,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801469:	89 13                	mov    %edx,(%ebx)
			return 0;
  80146b:	b8 00 00 00 00       	mov    $0x0,%eax
  801470:	eb 35                	jmp    8014a7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801472:	83 c0 01             	add    $0x1,%eax
  801475:	8b 14 85 8c 45 80 00 	mov    0x80458c(,%eax,4),%edx
  80147c:	85 d2                	test   %edx,%edx
  80147e:	75 de                	jne    80145e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801480:	a1 04 60 80 00       	mov    0x806004,%eax
  801485:	8b 40 04             	mov    0x4(%eax),%eax
  801488:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80148c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801490:	c7 04 24 48 45 80 00 	movl   $0x804548,(%esp)
  801497:	e8 da ee ff ff       	call   800376 <_Z7cprintfPKcz>
	*dev = 0;
  80149c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8014a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014a7:	83 c4 14             	add    $0x14,%esp
  8014aa:	5b                   	pop    %ebx
  8014ab:	5d                   	pop    %ebp
  8014ac:	c3                   	ret    

008014ad <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	56                   	push   %esi
  8014b1:	53                   	push   %ebx
  8014b2:	83 ec 20             	sub    $0x20,%esp
  8014b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8014b8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  8014bc:	89 34 24             	mov    %esi,(%esp)
  8014bf:	e8 c0 fe ff ff       	call   801384 <_Z6fd2numP2Fd>
  8014c4:	0f b6 d3             	movzbl %bl,%edx
  8014c7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014cb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014d2:	89 04 24             	mov    %eax,(%esp)
  8014d5:	e8 57 fe ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	78 05                	js     8014e3 <_Z8fd_closeP2Fdb+0x36>
  8014de:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014e1:	74 0c                	je     8014ef <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  8014e3:	80 fb 01             	cmp    $0x1,%bl
  8014e6:	19 db                	sbb    %ebx,%ebx
  8014e8:	f7 d3                	not    %ebx
  8014ea:	83 e3 fd             	and    $0xfffffffd,%ebx
  8014ed:	eb 3d                	jmp    80152c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f6:	8b 06                	mov    (%esi),%eax
  8014f8:	89 04 24             	mov    %eax,(%esp)
  8014fb:	e8 42 ff ff ff       	call   801442 <_Z10dev_lookupiPP3Dev>
  801500:	89 c3                	mov    %eax,%ebx
  801502:	85 c0                	test   %eax,%eax
  801504:	78 16                	js     80151c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80150c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801511:	85 c0                	test   %eax,%eax
  801513:	74 07                	je     80151c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801515:	89 34 24             	mov    %esi,(%esp)
  801518:	ff d0                	call   *%eax
  80151a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80151c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801520:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801527:	e8 01 fa ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
	return r;
}
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	83 c4 20             	add    $0x20,%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    

00801535 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80153b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801542:	00 
  801543:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	89 04 24             	mov    %eax,(%esp)
  801550:	e8 dc fd ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  801555:	85 c0                	test   %eax,%eax
  801557:	78 13                	js     80156c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801559:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801560:	00 
  801561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	e8 41 ff ff ff       	call   8014ad <_Z8fd_closeP2Fdb>
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <_Z9close_allv>:

void
close_all(void)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	53                   	push   %ebx
  801572:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801575:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80157a:	89 1c 24             	mov    %ebx,(%esp)
  80157d:	e8 b3 ff ff ff       	call   801535 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801582:	83 c3 01             	add    $0x1,%ebx
  801585:	83 fb 20             	cmp    $0x20,%ebx
  801588:	75 f0                	jne    80157a <_Z9close_allv+0xc>
		close(i);
}
  80158a:	83 c4 14             	add    $0x14,%esp
  80158d:	5b                   	pop    %ebx
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    

00801590 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 48             	sub    $0x48,%esp
  801596:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801599:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80159c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80159f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8015a2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8015a9:	00 
  8015aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	e8 75 fd ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  8015bc:	89 c3                	mov    %eax,%ebx
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	0f 88 ce 00 00 00    	js     801694 <_Z3dupii+0x104>
  8015c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015cd:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  8015ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015d1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8015d5:	89 34 24             	mov    %esi,(%esp)
  8015d8:	e8 54 fd ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  8015dd:	89 c3                	mov    %eax,%ebx
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	0f 89 bc 00 00 00    	jns    8016a3 <_Z3dupii+0x113>
  8015e7:	e9 a8 00 00 00       	jmp    801694 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8015ec:	89 d8                	mov    %ebx,%eax
  8015ee:	c1 e8 0c             	shr    $0xc,%eax
  8015f1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8015f8:	f6 c2 01             	test   $0x1,%dl
  8015fb:	74 32                	je     80162f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015fd:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801604:	25 07 0e 00 00       	and    $0xe07,%eax
  801609:	89 44 24 10          	mov    %eax,0x10(%esp)
  80160d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801611:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801618:	00 
  801619:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80161d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801624:	e8 a6 f8 ff ff       	call   800ecf <_Z12sys_page_mapiPviS_i>
  801629:	89 c3                	mov    %eax,%ebx
  80162b:	85 c0                	test   %eax,%eax
  80162d:	78 3e                	js     80166d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80162f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801632:	89 c2                	mov    %eax,%edx
  801634:	c1 ea 0c             	shr    $0xc,%edx
  801637:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80163e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801644:	89 54 24 10          	mov    %edx,0x10(%esp)
  801648:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80164b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80164f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801656:	00 
  801657:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801662:	e8 68 f8 ff ff       	call   800ecf <_Z12sys_page_mapiPviS_i>
  801667:	89 c3                	mov    %eax,%ebx
  801669:	85 c0                	test   %eax,%eax
  80166b:	79 25                	jns    801692 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80166d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801670:	89 44 24 04          	mov    %eax,0x4(%esp)
  801674:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80167b:	e8 ad f8 ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801680:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801684:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168b:	e8 9d f8 ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
	return r;
  801690:	eb 02                	jmp    801694 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801692:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801694:	89 d8                	mov    %ebx,%eax
  801696:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801699:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80169c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80169f:	89 ec                	mov    %ebp,%esp
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  8016a3:	89 34 24             	mov    %esi,(%esp)
  8016a6:	e8 8a fe ff ff       	call   801535 <_Z5closei>

	ova = fd2data(oldfd);
  8016ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ae:	89 04 24             	mov    %eax,(%esp)
  8016b1:	e8 16 fd ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  8016b6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016bb:	89 04 24             	mov    %eax,(%esp)
  8016be:	e8 09 fd ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  8016c3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8016c5:	89 d8                	mov    %ebx,%eax
  8016c7:	c1 e8 16             	shr    $0x16,%eax
  8016ca:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8016d1:	a8 01                	test   $0x1,%al
  8016d3:	0f 85 13 ff ff ff    	jne    8015ec <_Z3dupii+0x5c>
  8016d9:	e9 51 ff ff ff       	jmp    80162f <_Z3dupii+0x9f>

008016de <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 24             	sub    $0x24,%esp
  8016e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8016e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8016ef:	00 
  8016f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f7:	89 1c 24             	mov    %ebx,(%esp)
  8016fa:	e8 32 fc ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  8016ff:	85 c0                	test   %eax,%eax
  801701:	78 5f                	js     801762 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801703:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801706:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80170d:	8b 00                	mov    (%eax),%eax
  80170f:	89 04 24             	mov    %eax,(%esp)
  801712:	e8 2b fd ff ff       	call   801442 <_Z10dev_lookupiPP3Dev>
  801717:	85 c0                	test   %eax,%eax
  801719:	79 4d                	jns    801768 <_Z4readiPvj+0x8a>
  80171b:	eb 45                	jmp    801762 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80171d:	a1 04 60 80 00       	mov    0x806004,%eax
  801722:	8b 40 04             	mov    0x4(%eax),%eax
  801725:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801729:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172d:	c7 04 24 2a 45 80 00 	movl   $0x80452a,(%esp)
  801734:	e8 3d ec ff ff       	call   800376 <_Z7cprintfPKcz>
		return -E_INVAL;
  801739:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80173e:	eb 22                	jmp    801762 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801743:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801746:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80174b:	85 d2                	test   %edx,%edx
  80174d:	74 13                	je     801762 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80174f:	8b 45 10             	mov    0x10(%ebp),%eax
  801752:	89 44 24 08          	mov    %eax,0x8(%esp)
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175d:	89 0c 24             	mov    %ecx,(%esp)
  801760:	ff d2                	call   *%edx
}
  801762:	83 c4 24             	add    $0x24,%esp
  801765:	5b                   	pop    %ebx
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801768:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80176b:	8b 41 08             	mov    0x8(%ecx),%eax
  80176e:	83 e0 03             	and    $0x3,%eax
  801771:	83 f8 01             	cmp    $0x1,%eax
  801774:	75 ca                	jne    801740 <_Z4readiPvj+0x62>
  801776:	eb a5                	jmp    80171d <_Z4readiPvj+0x3f>

00801778 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	57                   	push   %edi
  80177c:	56                   	push   %esi
  80177d:	53                   	push   %ebx
  80177e:	83 ec 1c             	sub    $0x1c,%esp
  801781:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801784:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801787:	85 f6                	test   %esi,%esi
  801789:	74 2f                	je     8017ba <_Z5readniPvj+0x42>
  80178b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801790:	89 f0                	mov    %esi,%eax
  801792:	29 d8                	sub    %ebx,%eax
  801794:	89 44 24 08          	mov    %eax,0x8(%esp)
  801798:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80179b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	89 04 24             	mov    %eax,(%esp)
  8017a5:	e8 34 ff ff ff       	call   8016de <_Z4readiPvj>
		if (m < 0)
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 13                	js     8017c1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  8017ae:	85 c0                	test   %eax,%eax
  8017b0:	74 0d                	je     8017bf <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8017b2:	01 c3                	add    %eax,%ebx
  8017b4:	39 de                	cmp    %ebx,%esi
  8017b6:	77 d8                	ja     801790 <_Z5readniPvj+0x18>
  8017b8:	eb 05                	jmp    8017bf <_Z5readniPvj+0x47>
  8017ba:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8017bf:	89 d8                	mov    %ebx,%eax
}
  8017c1:	83 c4 1c             	add    $0x1c,%esp
  8017c4:	5b                   	pop    %ebx
  8017c5:	5e                   	pop    %esi
  8017c6:	5f                   	pop    %edi
  8017c7:	5d                   	pop    %ebp
  8017c8:	c3                   	ret    

008017c9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8017cf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017d6:	00 
  8017d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	89 04 24             	mov    %eax,(%esp)
  8017e4:	e8 48 fb ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	78 3c                	js     801829 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8017f7:	8b 00                	mov    (%eax),%eax
  8017f9:	89 04 24             	mov    %eax,(%esp)
  8017fc:	e8 41 fc ff ff       	call   801442 <_Z10dev_lookupiPP3Dev>
  801801:	85 c0                	test   %eax,%eax
  801803:	79 26                	jns    80182b <_Z5writeiPKvj+0x62>
  801805:	eb 22                	jmp    801829 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  80180d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801812:	85 c9                	test   %ecx,%ecx
  801814:	74 13                	je     801829 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801816:	8b 45 10             	mov    0x10(%ebp),%eax
  801819:	89 44 24 08          	mov    %eax,0x8(%esp)
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 44 24 04          	mov    %eax,0x4(%esp)
  801824:	89 14 24             	mov    %edx,(%esp)
  801827:	ff d1                	call   *%ecx
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80182b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80182e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801833:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801837:	74 f0                	je     801829 <_Z5writeiPKvj+0x60>
  801839:	eb cc                	jmp    801807 <_Z5writeiPKvj+0x3e>

0080183b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801841:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801848:	00 
  801849:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	89 04 24             	mov    %eax,(%esp)
  801856:	e8 d6 fa ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 0e                	js     80186d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801862:	8b 55 0c             	mov    0xc(%ebp),%edx
  801865:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801868:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	53                   	push   %ebx
  801873:	83 ec 24             	sub    $0x24,%esp
  801876:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801879:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801880:	00 
  801881:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801884:	89 44 24 04          	mov    %eax,0x4(%esp)
  801888:	89 1c 24             	mov    %ebx,(%esp)
  80188b:	e8 a1 fa ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  801890:	85 c0                	test   %eax,%eax
  801892:	78 58                	js     8018ec <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801894:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80189e:	8b 00                	mov    (%eax),%eax
  8018a0:	89 04 24             	mov    %eax,(%esp)
  8018a3:	e8 9a fb ff ff       	call   801442 <_Z10dev_lookupiPP3Dev>
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	79 46                	jns    8018f2 <_Z9ftruncateii+0x83>
  8018ac:	eb 3e                	jmp    8018ec <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ae:	a1 04 60 80 00       	mov    0x806004,%eax
  8018b3:	8b 40 04             	mov    0x4(%eax),%eax
  8018b6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018be:	c7 04 24 68 45 80 00 	movl   $0x804568,(%esp)
  8018c5:	e8 ac ea ff ff       	call   800376 <_Z7cprintfPKcz>
		return -E_INVAL;
  8018ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018cf:	eb 1b                	jmp    8018ec <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8018d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8018d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018dc:	85 d2                	test   %edx,%edx
  8018de:	74 0c                	je     8018ec <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e7:	89 0c 24             	mov    %ecx,(%esp)
  8018ea:	ff d2                	call   *%edx
}
  8018ec:	83 c4 24             	add    $0x24,%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018f5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  8018f9:	75 d6                	jne    8018d1 <_Z9ftruncateii+0x62>
  8018fb:	eb b1                	jmp    8018ae <_Z9ftruncateii+0x3f>

008018fd <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	53                   	push   %ebx
  801901:	83 ec 24             	sub    $0x24,%esp
  801904:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801907:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80190e:	00 
  80190f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801912:	89 44 24 04          	mov    %eax,0x4(%esp)
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	89 04 24             	mov    %eax,(%esp)
  80191c:	e8 10 fa ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  801921:	85 c0                	test   %eax,%eax
  801923:	78 3e                	js     801963 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801925:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801928:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	89 04 24             	mov    %eax,(%esp)
  801934:	e8 09 fb ff ff       	call   801442 <_Z10dev_lookupiPP3Dev>
  801939:	85 c0                	test   %eax,%eax
  80193b:	79 2c                	jns    801969 <_Z5fstatiP4Stat+0x6c>
  80193d:	eb 24                	jmp    801963 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80193f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801942:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801949:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801950:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801956:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80195a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195d:	89 04 24             	mov    %eax,(%esp)
  801960:	ff 52 14             	call   *0x14(%edx)
}
  801963:	83 c4 24             	add    $0x24,%esp
  801966:	5b                   	pop    %ebx
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801969:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80196c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801971:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801975:	75 c8                	jne    80193f <_Z5fstatiP4Stat+0x42>
  801977:	eb ea                	jmp    801963 <_Z5fstatiP4Stat+0x66>

00801979 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 18             	sub    $0x18,%esp
  80197f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801982:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801985:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80198c:	00 
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	89 04 24             	mov    %eax,(%esp)
  801993:	e8 d6 09 00 00       	call   80236e <_Z4openPKci>
  801998:	89 c3                	mov    %eax,%ebx
  80199a:	85 c0                	test   %eax,%eax
  80199c:	78 1b                	js     8019b9 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80199e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a5:	89 1c 24             	mov    %ebx,(%esp)
  8019a8:	e8 50 ff ff ff       	call   8018fd <_Z5fstatiP4Stat>
  8019ad:	89 c6                	mov    %eax,%esi
	close(fd);
  8019af:	89 1c 24             	mov    %ebx,(%esp)
  8019b2:	e8 7e fb ff ff       	call   801535 <_Z5closei>
	return r;
  8019b7:	89 f3                	mov    %esi,%ebx
}
  8019b9:	89 d8                	mov    %ebx,%eax
  8019bb:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8019be:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8019c1:	89 ec                	mov    %ebp,%esp
  8019c3:	5d                   	pop    %ebp
  8019c4:	c3                   	ret    
	...

008019d0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8019d3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8019d8:	85 d2                	test   %edx,%edx
  8019da:	78 33                	js     801a0f <_ZL10inode_dataP5Inodei+0x3f>
  8019dc:	3b 50 08             	cmp    0x8(%eax),%edx
  8019df:	7d 2e                	jge    801a0f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  8019e1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8019e7:	85 d2                	test   %edx,%edx
  8019e9:	0f 49 ca             	cmovns %edx,%ecx
  8019ec:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  8019ef:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  8019f3:	c1 e1 0c             	shl    $0xc,%ecx
  8019f6:	89 d0                	mov    %edx,%eax
  8019f8:	c1 f8 1f             	sar    $0x1f,%eax
  8019fb:	c1 e8 14             	shr    $0x14,%eax
  8019fe:	01 c2                	add    %eax,%edx
  801a00:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801a06:	29 c2                	sub    %eax,%edx
  801a08:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801a0f:	89 c8                	mov    %ecx,%eax
  801a11:	5d                   	pop    %ebp
  801a12:	c3                   	ret    

00801a13 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801a16:	8b 48 08             	mov    0x8(%eax),%ecx
  801a19:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801a21:	c7 82 80 00 00 00 08 	movl   $0x805008,0x80(%edx)
  801a28:	50 80 00 
}
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    

00801a2d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801a33:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	74 08                	je     801a45 <_ZL9get_inodei+0x18>
  801a3d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801a43:	7e 20                	jle    801a65 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801a45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a49:	c7 44 24 08 a0 45 80 	movl   $0x8045a0,0x8(%esp)
  801a50:	00 
  801a51:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801a58:	00 
  801a59:	c7 04 24 b6 45 80 00 	movl   $0x8045b6,(%esp)
  801a60:	e8 f3 e7 ff ff       	call   800258 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801a65:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801a6b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801a71:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801a77:	85 d2                	test   %edx,%edx
  801a79:	0f 48 d1             	cmovs  %ecx,%edx
  801a7c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  801a7f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  801a86:	c1 e0 0c             	shl    $0xc,%eax
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  801a93:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  801a99:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  801a9c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  801aa2:	76 20                	jbe    801ac4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  801aa4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aa8:	c7 44 24 08 dc 45 80 	movl   $0x8045dc,0x8(%esp)
  801aaf:	00 
  801ab0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801ab7:	00 
  801ab8:	c7 04 24 b6 45 80 00 	movl   $0x8045b6,(%esp)
  801abf:	e8 94 e7 ff ff       	call   800258 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801ac4:	83 fe 01             	cmp    $0x1,%esi
  801ac7:	7e 08                	jle    801ad1 <_ZL10bcache_ipcPvi+0x46>
  801ac9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801acf:	7d 12                	jge    801ae3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801ad1:	89 f3                	mov    %esi,%ebx
  801ad3:	c1 e3 04             	shl    $0x4,%ebx
  801ad6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801ad8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801ade:	c1 e6 0c             	shl    $0xc,%esi
  801ae1:	eb 20                	jmp    801b03 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801ae3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ae7:	c7 44 24 08 0c 46 80 	movl   $0x80460c,0x8(%esp)
  801aee:	00 
  801aef:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801af6:	00 
  801af7:	c7 04 24 b6 45 80 00 	movl   $0x8045b6,(%esp)
  801afe:	e8 55 e7 ff ff       	call   800258 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801b03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b0a:	00 
  801b0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b12:	00 
  801b13:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b17:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801b1e:	e8 fc 22 00 00       	call   803e1f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801b23:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b2a:	00 
  801b2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b36:	e8 55 22 00 00       	call   803d90 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801b3b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801b3e:	74 c3                	je     801b03 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5d                   	pop    %ebp
  801b46:	c3                   	ret    

00801b47 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	83 ec 28             	sub    $0x28,%esp
  801b4d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b50:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b53:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b56:	89 c7                	mov    %eax,%edi
  801b58:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801b5a:	c7 04 24 ed 1d 80 00 	movl   $0x801ded,(%esp)
  801b61:	e8 35 21 00 00       	call   803c9b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801b66:	89 f8                	mov    %edi,%eax
  801b68:	e8 c0 fe ff ff       	call   801a2d <_ZL9get_inodei>
  801b6d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801b6f:	ba 02 00 00 00       	mov    $0x2,%edx
  801b74:	e8 12 ff ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	79 08                	jns    801b85 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801b7d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801b83:	eb 2e                	jmp    801bb3 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801b85:	85 c0                	test   %eax,%eax
  801b87:	75 1c                	jne    801ba5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801b89:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801b8f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801b96:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801b99:	ba 06 00 00 00       	mov    $0x6,%edx
  801b9e:	89 d8                	mov    %ebx,%eax
  801ba0:	e8 e6 fe ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801ba5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801bac:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801bb6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bb9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801bbc:	89 ec                	mov    %ebp,%esp
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    

00801bc0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	57                   	push   %edi
  801bc4:	56                   	push   %esi
  801bc5:	53                   	push   %ebx
  801bc6:	83 ec 2c             	sub    $0x2c,%esp
  801bc9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801bcc:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801bcf:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801bd4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801bda:	0f 87 3d 01 00 00    	ja     801d1d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801be0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801be3:	8b 42 08             	mov    0x8(%edx),%eax
  801be6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801bec:	85 c0                	test   %eax,%eax
  801bee:	0f 49 f0             	cmovns %eax,%esi
  801bf1:	c1 fe 0c             	sar    $0xc,%esi
  801bf4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801bf6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801bf9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801bff:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801c02:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801c05:	0f 82 a6 00 00 00    	jb     801cb1 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801c0b:	39 fe                	cmp    %edi,%esi
  801c0d:	0f 8d f2 00 00 00    	jge    801d05 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801c13:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801c17:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801c1a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801c1d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801c20:	83 3e 00             	cmpl   $0x0,(%esi)
  801c23:	75 77                	jne    801c9c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801c25:	ba 02 00 00 00       	mov    $0x2,%edx
  801c2a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c2f:	e8 57 fe ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c34:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801c3a:	83 f9 02             	cmp    $0x2,%ecx
  801c3d:	7e 43                	jle    801c82 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801c3f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c44:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801c49:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801c50:	74 29                	je     801c7b <_ZL14inode_set_sizeP5Inodej+0xbb>
  801c52:	e9 ce 00 00 00       	jmp    801d25 <_ZL14inode_set_sizeP5Inodej+0x165>
  801c57:	89 c7                	mov    %eax,%edi
  801c59:	0f b6 10             	movzbl (%eax),%edx
  801c5c:	83 c0 01             	add    $0x1,%eax
  801c5f:	84 d2                	test   %dl,%dl
  801c61:	74 18                	je     801c7b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801c63:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c66:	ba 05 00 00 00       	mov    $0x5,%edx
  801c6b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c70:	e8 16 fe ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801c75:	85 db                	test   %ebx,%ebx
  801c77:	79 1e                	jns    801c97 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801c79:	eb 07                	jmp    801c82 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c7b:	83 c3 01             	add    $0x1,%ebx
  801c7e:	39 d9                	cmp    %ebx,%ecx
  801c80:	7f d5                	jg     801c57 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801c82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c85:	8b 50 08             	mov    0x8(%eax),%edx
  801c88:	e8 33 ff ff ff       	call   801bc0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801c8d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801c92:	e9 86 00 00 00       	jmp    801d1d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801c97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c9a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801c9c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801ca0:	83 c6 04             	add    $0x4,%esi
  801ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ca6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801ca9:	0f 8f 6e ff ff ff    	jg     801c1d <_ZL14inode_set_sizeP5Inodej+0x5d>
  801caf:	eb 54                	jmp    801d05 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801cb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cb4:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801cb9:	83 f8 01             	cmp    $0x1,%eax
  801cbc:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801cbf:	ba 02 00 00 00       	mov    $0x2,%edx
  801cc4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801cc9:	e8 bd fd ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801cce:	39 f7                	cmp    %esi,%edi
  801cd0:	7d 24                	jge    801cf6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801cd2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801cd5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801cd9:	8b 10                	mov    (%eax),%edx
  801cdb:	85 d2                	test   %edx,%edx
  801cdd:	74 0d                	je     801cec <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801cdf:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801cec:	83 eb 01             	sub    $0x1,%ebx
  801cef:	83 e8 04             	sub    $0x4,%eax
  801cf2:	39 fb                	cmp    %edi,%ebx
  801cf4:	75 e3                	jne    801cd9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801cf6:	ba 05 00 00 00       	mov    $0x5,%edx
  801cfb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d00:	e8 86 fd ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801d05:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d0b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801d0e:	ba 04 00 00 00       	mov    $0x4,%edx
  801d13:	e8 73 fd ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
	return 0;
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1d:	83 c4 2c             	add    $0x2c,%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5f                   	pop    %edi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801d25:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801d2c:	ba 05 00 00 00       	mov    $0x5,%edx
  801d31:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d36:	e8 50 fd ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801d3b:	bb 02 00 00 00       	mov    $0x2,%ebx
  801d40:	e9 52 ff ff ff       	jmp    801c97 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801d45 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	53                   	push   %ebx
  801d49:	83 ec 04             	sub    $0x4,%esp
  801d4c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801d4e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801d54:	83 e8 01             	sub    $0x1,%eax
  801d57:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801d5d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801d61:	75 40                	jne    801da3 <_ZL11inode_closeP5Inode+0x5e>
  801d63:	85 c0                	test   %eax,%eax
  801d65:	75 3c                	jne    801da3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801d67:	ba 02 00 00 00       	mov    $0x2,%edx
  801d6c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d71:	e8 15 fd ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801d7b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801d7f:	85 d2                	test   %edx,%edx
  801d81:	74 07                	je     801d8a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801d83:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801d8a:	83 c0 01             	add    $0x1,%eax
  801d8d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801d92:	75 e7                	jne    801d7b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801d94:	ba 05 00 00 00       	mov    $0x5,%edx
  801d99:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801d9e:	e8 e8 fc ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801da3:	ba 03 00 00 00       	mov    $0x3,%edx
  801da8:	89 d8                	mov    %ebx,%eax
  801daa:	e8 dc fc ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
}
  801daf:	83 c4 04             	add    $0x4,%esp
  801db2:	5b                   	pop    %ebx
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    

00801db5 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	53                   	push   %ebx
  801db9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dc5:	e8 7d fd ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  801dca:	89 c3                	mov    %eax,%ebx
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	78 15                	js     801de5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	e8 e5 fd ff ff       	call   801bc0 <_ZL14inode_set_sizeP5Inodej>
  801ddb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de0:	e8 60 ff ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
	return r;
}
  801de5:	89 d8                	mov    %ebx,%eax
  801de7:	83 c4 14             	add    $0x14,%esp
  801dea:	5b                   	pop    %ebx
  801deb:	5d                   	pop    %ebp
  801dec:	c3                   	ret    

00801ded <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	53                   	push   %ebx
  801df1:	83 ec 14             	sub    $0x14,%esp
  801df4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801df7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801df9:	89 c2                	mov    %eax,%edx
  801dfb:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801e01:	78 32                	js     801e35 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801e03:	ba 00 00 00 00       	mov    $0x0,%edx
  801e08:	e8 7e fc ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	74 1c                	je     801e2d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801e11:	c7 44 24 08 c1 45 80 	movl   $0x8045c1,0x8(%esp)
  801e18:	00 
  801e19:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801e20:	00 
  801e21:	c7 04 24 b6 45 80 00 	movl   $0x8045b6,(%esp)
  801e28:	e8 2b e4 ff ff       	call   800258 <_Z6_panicPKciS0_z>
    resume(utf);
  801e2d:	89 1c 24             	mov    %ebx,(%esp)
  801e30:	e8 3b 1f 00 00       	call   803d70 <resume>
}
  801e35:	83 c4 14             	add    $0x14,%esp
  801e38:	5b                   	pop    %ebx
  801e39:	5d                   	pop    %ebp
  801e3a:	c3                   	ret    

00801e3b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 28             	sub    $0x28,%esp
  801e41:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e44:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801e4a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801e4d:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e50:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e53:	e8 ef fc ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	78 26                	js     801e82 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  801e5c:	83 c3 10             	add    $0x10,%ebx
  801e5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e63:	89 34 24             	mov    %esi,(%esp)
  801e66:	e8 1f eb ff ff       	call   80098a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801e6b:	89 f2                	mov    %esi,%edx
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	e8 9e fb ff ff       	call   801a13 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  801e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e78:	e8 c8 fe ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
	return 0;
  801e7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e82:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e85:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e88:	89 ec                	mov    %ebp,%esp
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    

00801e8c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	53                   	push   %ebx
  801e90:	83 ec 24             	sub    $0x24,%esp
  801e93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801e96:	89 1c 24             	mov    %ebx,(%esp)
  801e99:	e8 d6 16 00 00       	call   803574 <_Z7pagerefPv>
  801e9e:	89 c2                	mov    %eax,%edx
        return 0;
  801ea0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801ea5:	83 fa 01             	cmp    $0x1,%edx
  801ea8:	7f 1e                	jg     801ec8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801eaa:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ead:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801eb0:	e8 92 fc ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 0f                	js     801ec8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  801ec3:	e8 7d fe ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
}
  801ec8:	83 c4 24             	add    $0x24,%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    

00801ece <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	57                   	push   %edi
  801ed2:	56                   	push   %esi
  801ed3:	53                   	push   %ebx
  801ed4:	83 ec 3c             	sub    $0x3c,%esp
  801ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801eda:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  801edd:	8b 43 04             	mov    0x4(%ebx),%eax
  801ee0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801ee3:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ee6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801ee9:	e8 59 fc ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	0f 88 8c 00 00 00    	js     801f82 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801ef6:	8b 53 04             	mov    0x4(%ebx),%edx
  801ef9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  801eff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801f05:	29 d7                	sub    %edx,%edi
  801f07:	39 f7                	cmp    %esi,%edi
  801f09:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  801f0c:	85 ff                	test   %edi,%edi
  801f0e:	74 16                	je     801f26 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801f10:	8d 14 17             	lea    (%edi,%edx,1),%edx
  801f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f16:	3b 50 08             	cmp    0x8(%eax),%edx
  801f19:	76 6f                	jbe    801f8a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  801f1b:	e8 a0 fc ff ff       	call   801bc0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801f20:	85 c0                	test   %eax,%eax
  801f22:	79 66                	jns    801f8a <_ZL13devfile_writeP2FdPKvj+0xbc>
  801f24:	eb 4e                	jmp    801f74 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801f26:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  801f2c:	76 24                	jbe    801f52 <_ZL13devfile_writeP2FdPKvj+0x84>
  801f2e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801f30:	8b 53 04             	mov    0x4(%ebx),%edx
  801f33:	81 c2 00 10 00 00    	add    $0x1000,%edx
  801f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f3c:	3b 50 08             	cmp    0x8(%eax),%edx
  801f3f:	0f 86 83 00 00 00    	jbe    801fc8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  801f45:	e8 76 fc ff ff       	call   801bc0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	79 7a                	jns    801fc8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  801f4e:	66 90                	xchg   %ax,%ax
  801f50:	eb 22                	jmp    801f74 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  801f52:	85 f6                	test   %esi,%esi
  801f54:	74 1e                	je     801f74 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801f56:	89 f2                	mov    %esi,%edx
  801f58:	03 53 04             	add    0x4(%ebx),%edx
  801f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f5e:	3b 50 08             	cmp    0x8(%eax),%edx
  801f61:	0f 86 b8 00 00 00    	jbe    80201f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  801f67:	e8 54 fc ff ff       	call   801bc0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	0f 89 ab 00 00 00    	jns    80201f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  801f74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f77:	e8 c9 fd ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  801f7c:	8b 43 04             	mov    0x4(%ebx),%eax
  801f7f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  801f82:	83 c4 3c             	add    $0x3c,%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5f                   	pop    %edi
  801f88:	5d                   	pop    %ebp
  801f89:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  801f8a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801f8c:	8b 53 04             	mov    0x4(%ebx),%edx
  801f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f92:	e8 39 fa ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
  801f97:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  801f9a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fa8:	89 04 24             	mov    %eax,(%esp)
  801fab:	e8 f7 eb ff ff       	call   800ba7 <memcpy>
        fd->fd_offset += n2;
  801fb0:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  801fb3:	ba 04 00 00 00       	mov    $0x4,%edx
  801fb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fbb:	e8 cb fa ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  801fc0:	01 7d 0c             	add    %edi,0xc(%ebp)
  801fc3:	e9 5e ff ff ff       	jmp    801f26 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801fc8:	8b 53 04             	mov    0x4(%ebx),%edx
  801fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fce:	e8 fd f9 ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
  801fd3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  801fd5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801fdc:	00 
  801fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe4:	89 34 24             	mov    %esi,(%esp)
  801fe7:	e8 bb eb ff ff       	call   800ba7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801fec:	ba 04 00 00 00       	mov    $0x4,%edx
  801ff1:	89 f0                	mov    %esi,%eax
  801ff3:	e8 93 fa ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  801ff8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  801ffe:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802005:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80200c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802012:	0f 87 18 ff ff ff    	ja     801f30 <_ZL13devfile_writeP2FdPKvj+0x62>
  802018:	89 fe                	mov    %edi,%esi
  80201a:	e9 33 ff ff ff       	jmp    801f52 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80201f:	8b 53 04             	mov    0x4(%ebx),%edx
  802022:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802025:	e8 a6 f9 ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
  80202a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80202c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802030:	8b 45 0c             	mov    0xc(%ebp),%eax
  802033:	89 44 24 04          	mov    %eax,0x4(%esp)
  802037:	89 3c 24             	mov    %edi,(%esp)
  80203a:	e8 68 eb ff ff       	call   800ba7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80203f:	ba 04 00 00 00       	mov    $0x4,%edx
  802044:	89 f8                	mov    %edi,%eax
  802046:	e8 40 fa ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80204b:	01 73 04             	add    %esi,0x4(%ebx)
  80204e:	e9 21 ff ff ff       	jmp    801f74 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802053 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	57                   	push   %edi
  802057:	56                   	push   %esi
  802058:	53                   	push   %ebx
  802059:	83 ec 3c             	sub    $0x3c,%esp
  80205c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80205f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802062:	8b 43 04             	mov    0x4(%ebx),%eax
  802065:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802068:	8b 43 0c             	mov    0xc(%ebx),%eax
  80206b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80206e:	e8 d4 fa ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  802073:	85 c0                	test   %eax,%eax
  802075:	0f 88 d3 00 00 00    	js     80214e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80207b:	8b 73 04             	mov    0x4(%ebx),%esi
  80207e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802081:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802084:	8b 50 08             	mov    0x8(%eax),%edx
  802087:	29 f2                	sub    %esi,%edx
  802089:	3b 48 08             	cmp    0x8(%eax),%ecx
  80208c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80208f:	89 f2                	mov    %esi,%edx
  802091:	e8 3a f9 ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
  802096:	85 c0                	test   %eax,%eax
  802098:	0f 84 a2 00 00 00    	je     802140 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80209e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  8020a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8020aa:	29 f2                	sub    %esi,%edx
  8020ac:	39 d7                	cmp    %edx,%edi
  8020ae:	0f 46 d7             	cmovbe %edi,%edx
  8020b1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  8020b4:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  8020b6:	01 d6                	add    %edx,%esi
  8020b8:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  8020bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c6:	89 04 24             	mov    %eax,(%esp)
  8020c9:	e8 d9 ea ff ff       	call   800ba7 <memcpy>
    buf = (void *)((char *)buf + n2);
  8020ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020d1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8020d4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8020da:	76 3e                	jbe    80211a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8020dc:	8b 53 04             	mov    0x4(%ebx),%edx
  8020df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e2:	e8 e9 f8 ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	74 55                	je     802140 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  8020eb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8020f2:	00 
  8020f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f7:	89 34 24             	mov    %esi,(%esp)
  8020fa:	e8 a8 ea ff ff       	call   800ba7 <memcpy>
        n -= PGSIZE;
  8020ff:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802105:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80210b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802112:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802118:	77 c2                	ja     8020dc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80211a:	85 ff                	test   %edi,%edi
  80211c:	74 22                	je     802140 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80211e:	8b 53 04             	mov    0x4(%ebx),%edx
  802121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802124:	e8 a7 f8 ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
  802129:	85 c0                	test   %eax,%eax
  80212b:	74 13                	je     802140 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80212d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802131:	89 44 24 04          	mov    %eax,0x4(%esp)
  802135:	89 34 24             	mov    %esi,(%esp)
  802138:	e8 6a ea ff ff       	call   800ba7 <memcpy>
        fd->fd_offset += n;
  80213d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802143:	e8 fd fb ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802148:	8b 43 04             	mov    0x4(%ebx),%eax
  80214b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80214e:	83 c4 3c             	add    $0x3c,%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5f                   	pop    %edi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    

00802156 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	57                   	push   %edi
  80215a:	56                   	push   %esi
  80215b:	53                   	push   %ebx
  80215c:	83 ec 4c             	sub    $0x4c,%esp
  80215f:	89 c6                	mov    %eax,%esi
  802161:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802164:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802167:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80216d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802176:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802179:	b8 01 00 00 00       	mov    $0x1,%eax
  80217e:	e8 c4 f9 ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  802183:	89 c7                	mov    %eax,%edi
  802185:	85 c0                	test   %eax,%eax
  802187:	0f 88 cd 01 00 00    	js     80235a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80218d:	89 f3                	mov    %esi,%ebx
  80218f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802192:	75 08                	jne    80219c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802194:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802197:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80219a:	74 f8                	je     802194 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80219c:	0f b6 03             	movzbl (%ebx),%eax
  80219f:	3c 2f                	cmp    $0x2f,%al
  8021a1:	74 16                	je     8021b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8021a3:	84 c0                	test   %al,%al
  8021a5:	74 12                	je     8021b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8021a7:	89 da                	mov    %ebx,%edx
		++path;
  8021a9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8021ac:	0f b6 02             	movzbl (%edx),%eax
  8021af:	3c 2f                	cmp    $0x2f,%al
  8021b1:	74 08                	je     8021bb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8021b3:	84 c0                	test   %al,%al
  8021b5:	75 f2                	jne    8021a9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  8021b7:	eb 02                	jmp    8021bb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8021b9:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  8021bb:	89 d0                	mov    %edx,%eax
  8021bd:	29 d8                	sub    %ebx,%eax
  8021bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  8021c2:	0f b6 02             	movzbl (%edx),%eax
  8021c5:	89 d6                	mov    %edx,%esi
  8021c7:	3c 2f                	cmp    $0x2f,%al
  8021c9:	75 0a                	jne    8021d5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  8021cb:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  8021ce:	0f b6 06             	movzbl (%esi),%eax
  8021d1:	3c 2f                	cmp    $0x2f,%al
  8021d3:	74 f6                	je     8021cb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8021d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8021d9:	75 1b                	jne    8021f6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8021db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021de:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8021e1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8021e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021e6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8021ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f1:	e9 64 01 00 00       	jmp    80235a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8021f6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8021fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fe:	74 06                	je     802206 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802200:	84 c0                	test   %al,%al
  802202:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802206:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802209:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80220c:	83 3a 02             	cmpl   $0x2,(%edx)
  80220f:	0f 85 f4 00 00 00    	jne    802309 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802215:	89 d0                	mov    %edx,%eax
  802217:	8b 52 08             	mov    0x8(%edx),%edx
  80221a:	85 d2                	test   %edx,%edx
  80221c:	7e 78                	jle    802296 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80221e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802225:	bf 00 00 00 00       	mov    $0x0,%edi
  80222a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80222d:	89 fb                	mov    %edi,%ebx
  80222f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802232:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802234:	89 da                	mov    %ebx,%edx
  802236:	89 f0                	mov    %esi,%eax
  802238:	e8 93 f7 ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
  80223d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80223f:	83 38 00             	cmpl   $0x0,(%eax)
  802242:	74 26                	je     80226a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802244:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802247:	3b 50 04             	cmp    0x4(%eax),%edx
  80224a:	75 33                	jne    80227f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80224c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802250:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802253:	89 44 24 04          	mov    %eax,0x4(%esp)
  802257:	8d 47 08             	lea    0x8(%edi),%eax
  80225a:	89 04 24             	mov    %eax,(%esp)
  80225d:	e8 86 e9 ff ff       	call   800be8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802262:	85 c0                	test   %eax,%eax
  802264:	0f 84 fa 00 00 00    	je     802364 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80226a:	83 3f 00             	cmpl   $0x0,(%edi)
  80226d:	75 10                	jne    80227f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80226f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802273:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802276:	84 c0                	test   %al,%al
  802278:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80227c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80227f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802285:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802287:	8b 56 08             	mov    0x8(%esi),%edx
  80228a:	39 d0                	cmp    %edx,%eax
  80228c:	7c a6                	jl     802234 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80228e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802291:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802294:	eb 07                	jmp    80229d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802296:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80229d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  8022a1:	74 6d                	je     802310 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  8022a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8022a7:	75 24                	jne    8022cd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  8022a9:	83 ea 80             	sub    $0xffffff80,%edx
  8022ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022af:	e8 0c f9 ff ff       	call   801bc0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	0f 88 90 00 00 00    	js     80234c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  8022bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022bf:	8b 50 08             	mov    0x8(%eax),%edx
  8022c2:	83 c2 80             	add    $0xffffff80,%edx
  8022c5:	e8 06 f7 ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
  8022ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  8022cd:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8022d4:	00 
  8022d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022dc:	00 
  8022dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8022e0:	89 14 24             	mov    %edx,(%esp)
  8022e3:	e8 e9 e7 ff ff       	call   800ad1 <memset>
	empty->de_namelen = namelen;
  8022e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022ee:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8022f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022f9:	83 c0 08             	add    $0x8,%eax
  8022fc:	89 04 24             	mov    %eax,(%esp)
  8022ff:	e8 a3 e8 ff ff       	call   800ba7 <memcpy>
	*de_store = empty;
  802304:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802307:	eb 5e                	jmp    802367 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802309:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80230e:	eb 42                	jmp    802352 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802310:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802315:	eb 3b                	jmp    802352 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80231a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80231d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80231f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802322:	89 38                	mov    %edi,(%eax)
			return 0;
  802324:	bf 00 00 00 00       	mov    $0x0,%edi
  802329:	eb 2f                	jmp    80235a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80232b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80232e:	8b 07                	mov    (%edi),%eax
  802330:	e8 12 f8 ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  802335:	85 c0                	test   %eax,%eax
  802337:	78 17                	js     802350 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802339:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80233c:	e8 04 fa ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802341:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802344:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802347:	e9 41 fe ff ff       	jmp    80218d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80234c:	89 c7                	mov    %eax,%edi
  80234e:	eb 02                	jmp    802352 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802350:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802355:	e8 eb f9 ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
	return r;
}
  80235a:	89 f8                	mov    %edi,%eax
  80235c:	83 c4 4c             	add    $0x4c,%esp
  80235f:	5b                   	pop    %ebx
  802360:	5e                   	pop    %esi
  802361:	5f                   	pop    %edi
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    
  802364:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802367:	80 3e 00             	cmpb   $0x0,(%esi)
  80236a:	75 bf                	jne    80232b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80236c:	eb a9                	jmp    802317 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080236e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 3c             	sub    $0x3c,%esp
  802377:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80237a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80237d:	89 04 24             	mov    %eax,(%esp)
  802380:	e8 62 f0 ff ff       	call   8013e7 <_Z14fd_find_unusedPP2Fd>
  802385:	89 c3                	mov    %eax,%ebx
  802387:	85 c0                	test   %eax,%eax
  802389:	0f 88 16 02 00 00    	js     8025a5 <_Z4openPKci+0x237>
  80238f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802396:	00 
  802397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80239a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023a5:	e8 c6 ea ff ff       	call   800e70 <_Z14sys_page_allociPvi>
  8023aa:	89 c3                	mov    %eax,%ebx
  8023ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b1:	85 db                	test   %ebx,%ebx
  8023b3:	0f 88 ec 01 00 00    	js     8025a5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  8023b9:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  8023bd:	0f 84 ec 01 00 00    	je     8025af <_Z4openPKci+0x241>
  8023c3:	83 c0 01             	add    $0x1,%eax
  8023c6:	83 f8 78             	cmp    $0x78,%eax
  8023c9:	75 ee                	jne    8023b9 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8023cb:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8023d0:	e9 b9 01 00 00       	jmp    80258e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8023d5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8023d8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8023de:	89 3c 24             	mov    %edi,(%esp)
  8023e1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  8023e4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8023e7:	89 f0                	mov    %esi,%eax
  8023e9:	e8 68 fd ff ff       	call   802156 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8023ee:	89 c3                	mov    %eax,%ebx
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	0f 85 96 01 00 00    	jne    80258e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8023f8:	85 ff                	test   %edi,%edi
  8023fa:	75 41                	jne    80243d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8023fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023ff:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802404:	75 08                	jne    80240e <_Z4openPKci+0xa0>
            fileino = dirino;
  802406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802409:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80240c:	eb 14                	jmp    802422 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80240e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802411:	8b 00                	mov    (%eax),%eax
  802413:	e8 2f f7 ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  802418:	89 c3                	mov    %eax,%ebx
  80241a:	85 c0                	test   %eax,%eax
  80241c:	0f 88 5d 01 00 00    	js     80257f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802425:	83 38 02             	cmpl   $0x2,(%eax)
  802428:	0f 85 d2 00 00 00    	jne    802500 <_Z4openPKci+0x192>
  80242e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802432:	0f 84 c8 00 00 00    	je     802500 <_Z4openPKci+0x192>
  802438:	e9 38 01 00 00       	jmp    802575 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80243d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802444:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80244b:	0f 8e a8 00 00 00    	jle    8024f9 <_Z4openPKci+0x18b>
  802451:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802456:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802459:	89 f8                	mov    %edi,%eax
  80245b:	e8 e7 f6 ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  802460:	89 c3                	mov    %eax,%ebx
  802462:	85 c0                	test   %eax,%eax
  802464:	0f 88 15 01 00 00    	js     80257f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80246a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80246d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802471:	75 68                	jne    8024db <_Z4openPKci+0x16d>
  802473:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80247a:	75 5f                	jne    8024db <_Z4openPKci+0x16d>
			*ino_store = ino;
  80247c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80247f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802485:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802488:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80248f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802496:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80249d:	00 
  80249e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024a5:	00 
  8024a6:	83 c0 0c             	add    $0xc,%eax
  8024a9:	89 04 24             	mov    %eax,(%esp)
  8024ac:	e8 20 e6 ff ff       	call   800ad1 <memset>
        de->de_inum = fileino->i_inum;
  8024b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b4:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  8024ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024bd:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  8024bf:	ba 04 00 00 00       	mov    $0x4,%edx
  8024c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c7:	e8 bf f5 ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  8024cc:	ba 04 00 00 00       	mov    $0x4,%edx
  8024d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d4:	e8 b2 f5 ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
  8024d9:	eb 25                	jmp    802500 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  8024db:	e8 65 f8 ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8024e0:	83 c7 01             	add    $0x1,%edi
  8024e3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  8024e9:	0f 8c 67 ff ff ff    	jl     802456 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  8024ef:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8024f4:	e9 86 00 00 00       	jmp    80257f <_Z4openPKci+0x211>
  8024f9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8024fe:	eb 7f                	jmp    80257f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802500:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802507:	74 0d                	je     802516 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802509:	ba 00 00 00 00       	mov    $0x0,%edx
  80250e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802511:	e8 aa f6 ff ff       	call   801bc0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802516:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80251c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802524:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80252b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802531:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802534:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80253a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80253d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802541:	83 c0 10             	add    $0x10,%eax
  802544:	89 04 24             	mov    %eax,(%esp)
  802547:	e8 3e e4 ff ff       	call   80098a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80254c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80254f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802559:	e8 e7 f7 ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80255e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802561:	e8 df f7 ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802569:	89 04 24             	mov    %eax,(%esp)
  80256c:	e8 13 ee ff ff       	call   801384 <_Z6fd2numP2Fd>
  802571:	89 c3                	mov    %eax,%ebx
  802573:	eb 30                	jmp    8025a5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802575:	e8 cb f7 ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80257a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80257f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802582:	e8 be f7 ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
  802587:	eb 05                	jmp    80258e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802589:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80258e:	a1 04 60 80 00       	mov    0x806004,%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802599:	89 54 24 04          	mov    %edx,0x4(%esp)
  80259d:	89 04 24             	mov    %eax,(%esp)
  8025a0:	e8 88 e9 ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  8025a5:	89 d8                	mov    %ebx,%eax
  8025a7:	83 c4 3c             	add    $0x3c,%esp
  8025aa:	5b                   	pop    %ebx
  8025ab:	5e                   	pop    %esi
  8025ac:	5f                   	pop    %edi
  8025ad:	5d                   	pop    %ebp
  8025ae:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  8025af:	83 f8 78             	cmp    $0x78,%eax
  8025b2:	0f 85 1d fe ff ff    	jne    8023d5 <_Z4openPKci+0x67>
  8025b8:	eb cf                	jmp    802589 <_Z4openPKci+0x21b>

008025ba <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	53                   	push   %ebx
  8025be:	83 ec 24             	sub    $0x24,%esp
  8025c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  8025c4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	e8 78 f5 ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	78 27                	js     8025fa <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  8025d3:	c7 44 24 04 d4 45 80 	movl   $0x8045d4,0x4(%esp)
  8025da:	00 
  8025db:	89 1c 24             	mov    %ebx,(%esp)
  8025de:	e8 a7 e3 ff ff       	call   80098a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8025e3:	89 da                	mov    %ebx,%edx
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	e8 26 f4 ff ff       	call   801a13 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	e8 50 f7 ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
	return 0;
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fa:	83 c4 24             	add    $0x24,%esp
  8025fd:	5b                   	pop    %ebx
  8025fe:	5d                   	pop    %ebp
  8025ff:	c3                   	ret    

00802600 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	53                   	push   %ebx
  802604:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802607:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80260e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802611:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	e8 3a fb ff ff       	call   802156 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80261c:	89 c3                	mov    %eax,%ebx
  80261e:	85 c0                	test   %eax,%eax
  802620:	78 5f                	js     802681 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802622:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802625:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	e8 18 f5 ff ff       	call   801b47 <_ZL10inode_openiPP5Inode>
  80262f:	89 c3                	mov    %eax,%ebx
  802631:	85 c0                	test   %eax,%eax
  802633:	78 44                	js     802679 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802635:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80263a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263d:	83 38 02             	cmpl   $0x2,(%eax)
  802640:	74 2f                	je     802671 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802642:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802645:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80264b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802652:	ba 04 00 00 00       	mov    $0x4,%edx
  802657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265a:	e8 2c f4 ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80265f:	ba 04 00 00 00       	mov    $0x4,%edx
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	e8 1f f4 ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
	r = 0;
  80266c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802674:	e8 cc f6 ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	e8 c4 f6 ff ff       	call   801d45 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802681:	89 d8                	mov    %ebx,%eax
  802683:	83 c4 24             	add    $0x24,%esp
  802686:	5b                   	pop    %ebx
  802687:	5d                   	pop    %ebp
  802688:	c3                   	ret    

00802689 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
  802691:	5d                   	pop    %ebp
  802692:	c3                   	ret    

00802693 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	57                   	push   %edi
  802697:	56                   	push   %esi
  802698:	53                   	push   %ebx
  802699:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  80269f:	c7 04 24 ed 1d 80 00 	movl   $0x801ded,(%esp)
  8026a6:	e8 f0 15 00 00       	call   803c9b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  8026ab:	a1 00 10 00 50       	mov    0x50001000,%eax
  8026b0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  8026b5:	74 28                	je     8026df <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  8026b7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  8026be:	4a 
  8026bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026c3:	c7 44 24 08 3c 46 80 	movl   $0x80463c,0x8(%esp)
  8026ca:	00 
  8026cb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  8026d2:	00 
  8026d3:	c7 04 24 b6 45 80 00 	movl   $0x8045b6,(%esp)
  8026da:	e8 79 db ff ff       	call   800258 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  8026df:	a1 04 10 00 50       	mov    0x50001004,%eax
  8026e4:	83 f8 03             	cmp    $0x3,%eax
  8026e7:	7f 1c                	jg     802705 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  8026e9:	c7 44 24 08 70 46 80 	movl   $0x804670,0x8(%esp)
  8026f0:	00 
  8026f1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  8026f8:	00 
  8026f9:	c7 04 24 b6 45 80 00 	movl   $0x8045b6,(%esp)
  802700:	e8 53 db ff ff       	call   800258 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802705:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  80270b:	85 d2                	test   %edx,%edx
  80270d:	7f 1c                	jg     80272b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  80270f:	c7 44 24 08 a0 46 80 	movl   $0x8046a0,0x8(%esp)
  802716:	00 
  802717:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  80271e:	00 
  80271f:	c7 04 24 b6 45 80 00 	movl   $0x8045b6,(%esp)
  802726:	e8 2d db ff ff       	call   800258 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80272b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802731:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802737:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80273d:	85 c9                	test   %ecx,%ecx
  80273f:	0f 48 cb             	cmovs  %ebx,%ecx
  802742:	c1 f9 0c             	sar    $0xc,%ecx
  802745:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802749:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80274f:	39 c8                	cmp    %ecx,%eax
  802751:	7c 13                	jl     802766 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802753:	85 c0                	test   %eax,%eax
  802755:	7f 3d                	jg     802794 <_Z4fsckv+0x101>
  802757:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80275e:	00 00 00 
  802761:	e9 ac 00 00 00       	jmp    802812 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802766:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80276c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802770:	89 44 24 10          	mov    %eax,0x10(%esp)
  802774:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802778:	c7 44 24 08 d0 46 80 	movl   $0x8046d0,0x8(%esp)
  80277f:	00 
  802780:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802787:	00 
  802788:	c7 04 24 b6 45 80 00 	movl   $0x8045b6,(%esp)
  80278f:	e8 c4 da ff ff       	call   800258 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802794:	be 00 20 00 50       	mov    $0x50002000,%esi
  802799:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  8027a0:	00 00 00 
  8027a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027a8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  8027ae:	39 df                	cmp    %ebx,%edi
  8027b0:	7e 27                	jle    8027d9 <_Z4fsckv+0x146>
  8027b2:	0f b6 06             	movzbl (%esi),%eax
  8027b5:	84 c0                	test   %al,%al
  8027b7:	74 4b                	je     802804 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  8027b9:	0f be c0             	movsbl %al,%eax
  8027bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027c4:	c7 04 24 14 47 80 00 	movl   $0x804714,(%esp)
  8027cb:	e8 a6 db ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  8027d0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8027d7:	eb 2b                	jmp    802804 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  8027d9:	0f b6 06             	movzbl (%esi),%eax
  8027dc:	3c 01                	cmp    $0x1,%al
  8027de:	76 24                	jbe    802804 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  8027e0:	0f be c0             	movsbl %al,%eax
  8027e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027eb:	c7 04 24 48 47 80 00 	movl   $0x804748,(%esp)
  8027f2:	e8 7f db ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  8027f7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  8027fe:	80 3e 00             	cmpb   $0x0,(%esi)
  802801:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802804:	83 c3 01             	add    $0x1,%ebx
  802807:	83 c6 01             	add    $0x1,%esi
  80280a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802810:	7f 9c                	jg     8027ae <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802812:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802819:	0f 8e e1 02 00 00    	jle    802b00 <_Z4fsckv+0x46d>
  80281f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802826:	00 00 00 
		struct Inode *ino = get_inode(i);
  802829:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80282f:	e8 f9 f1 ff ff       	call   801a2d <_ZL9get_inodei>
  802834:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80283a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80283e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802845:	75 22                	jne    802869 <_Z4fsckv+0x1d6>
  802847:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80284e:	0f 84 a9 06 00 00    	je     802efd <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802854:	ba 00 00 00 00       	mov    $0x0,%edx
  802859:	e8 2d f2 ff ff       	call   801a8b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80285e:	85 c0                	test   %eax,%eax
  802860:	74 3a                	je     80289c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802862:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802869:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80286f:	8b 02                	mov    (%edx),%eax
  802871:	83 f8 01             	cmp    $0x1,%eax
  802874:	74 26                	je     80289c <_Z4fsckv+0x209>
  802876:	83 f8 02             	cmp    $0x2,%eax
  802879:	74 21                	je     80289c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80287b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80287f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802885:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802889:	c7 04 24 74 47 80 00 	movl   $0x804774,(%esp)
  802890:	e8 e1 da ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  802895:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80289c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8028a3:	75 3f                	jne    8028e4 <_Z4fsckv+0x251>
  8028a5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8028ab:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8028af:	75 15                	jne    8028c6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  8028b1:	c7 04 24 98 47 80 00 	movl   $0x804798,(%esp)
  8028b8:	e8 b9 da ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  8028bd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8028c4:	eb 1e                	jmp    8028e4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  8028c6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8028cc:	83 3a 02             	cmpl   $0x2,(%edx)
  8028cf:	74 13                	je     8028e4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8028d1:	c7 04 24 cc 47 80 00 	movl   $0x8047cc,(%esp)
  8028d8:	e8 99 da ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  8028dd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  8028e4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  8028e9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8028f0:	0f 84 93 00 00 00    	je     802989 <_Z4fsckv+0x2f6>
  8028f6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8028fc:	8b 41 08             	mov    0x8(%ecx),%eax
  8028ff:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802904:	7e 23                	jle    802929 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802906:	89 44 24 08          	mov    %eax,0x8(%esp)
  80290a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802910:	89 44 24 04          	mov    %eax,0x4(%esp)
  802914:	c7 04 24 fc 47 80 00 	movl   $0x8047fc,(%esp)
  80291b:	e8 56 da ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  802920:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802927:	eb 09                	jmp    802932 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802929:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802930:	74 4b                	je     80297d <_Z4fsckv+0x2ea>
  802932:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802938:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80293e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802944:	74 23                	je     802969 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802946:	89 44 24 08          	mov    %eax,0x8(%esp)
  80294a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802950:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802954:	c7 04 24 20 48 80 00 	movl   $0x804820,(%esp)
  80295b:	e8 16 da ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  802960:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802967:	eb 09                	jmp    802972 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802969:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802970:	74 12                	je     802984 <_Z4fsckv+0x2f1>
  802972:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802978:	8b 78 08             	mov    0x8(%eax),%edi
  80297b:	eb 0c                	jmp    802989 <_Z4fsckv+0x2f6>
  80297d:	bf 00 00 00 00       	mov    $0x0,%edi
  802982:	eb 05                	jmp    802989 <_Z4fsckv+0x2f6>
  802984:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802989:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  80298e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802994:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802998:	89 d8                	mov    %ebx,%eax
  80299a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  80299d:	39 c7                	cmp    %eax,%edi
  80299f:	7e 2b                	jle    8029cc <_Z4fsckv+0x339>
  8029a1:	85 f6                	test   %esi,%esi
  8029a3:	75 27                	jne    8029cc <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  8029a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029ad:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8029b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029b7:	c7 04 24 44 48 80 00 	movl   $0x804844,(%esp)
  8029be:	e8 b3 d9 ff ff       	call   800376 <_Z7cprintfPKcz>
				++errors;
  8029c3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8029ca:	eb 36                	jmp    802a02 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  8029cc:	39 f8                	cmp    %edi,%eax
  8029ce:	7c 32                	jl     802a02 <_Z4fsckv+0x36f>
  8029d0:	85 f6                	test   %esi,%esi
  8029d2:	74 2e                	je     802a02 <_Z4fsckv+0x36f>
  8029d4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8029db:	74 25                	je     802a02 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8029dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029e1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029e5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8029eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ef:	c7 04 24 88 48 80 00 	movl   $0x804888,(%esp)
  8029f6:	e8 7b d9 ff ff       	call   800376 <_Z7cprintfPKcz>
				++errors;
  8029fb:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802a02:	85 f6                	test   %esi,%esi
  802a04:	0f 84 a0 00 00 00    	je     802aaa <_Z4fsckv+0x417>
  802a0a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802a11:	0f 84 93 00 00 00    	je     802aaa <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802a17:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802a1d:	7e 27                	jle    802a46 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802a1f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a27:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  802a2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a31:	c7 04 24 cc 48 80 00 	movl   $0x8048cc,(%esp)
  802a38:	e8 39 d9 ff ff       	call   800376 <_Z7cprintfPKcz>
					++errors;
  802a3d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a44:	eb 64                	jmp    802aaa <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802a46:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  802a4d:	3c 01                	cmp    $0x1,%al
  802a4f:	75 27                	jne    802a78 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  802a51:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a55:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a59:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802a5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a63:	c7 04 24 10 49 80 00 	movl   $0x804910,(%esp)
  802a6a:	e8 07 d9 ff ff       	call   800376 <_Z7cprintfPKcz>
					++errors;
  802a6f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802a76:	eb 32                	jmp    802aaa <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  802a78:	3c ff                	cmp    $0xff,%al
  802a7a:	75 27                	jne    802aa3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  802a7c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a80:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a84:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a8e:	c7 04 24 4c 49 80 00 	movl   $0x80494c,(%esp)
  802a95:	e8 dc d8 ff ff       	call   800376 <_Z7cprintfPKcz>
					++errors;
  802a9a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802aa1:	eb 07                	jmp    802aaa <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  802aa3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  802aaa:	83 c3 01             	add    $0x1,%ebx
  802aad:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802ab3:	0f 85 d5 fe ff ff    	jne    80298e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802ab9:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802ac0:	0f 94 c0             	sete   %al
  802ac3:	0f b6 c0             	movzbl %al,%eax
  802ac6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802acc:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802ad2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802ad9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802ae0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802ae7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802aee:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802af4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802afa:	0f 8f 29 fd ff ff    	jg     802829 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b00:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802b07:	0f 8e 7f 03 00 00    	jle    802e8c <_Z4fsckv+0x7f9>
  802b0d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802b12:	89 f0                	mov    %esi,%eax
  802b14:	e8 14 ef ff ff       	call   801a2d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802b19:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802b20:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802b27:	c1 e2 08             	shl    $0x8,%edx
  802b2a:	09 ca                	or     %ecx,%edx
  802b2c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802b33:	c1 e1 10             	shl    $0x10,%ecx
  802b36:	09 ca                	or     %ecx,%edx
  802b38:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802b3f:	83 e1 7f             	and    $0x7f,%ecx
  802b42:	c1 e1 18             	shl    $0x18,%ecx
  802b45:	09 d1                	or     %edx,%ecx
  802b47:	74 0e                	je     802b57 <_Z4fsckv+0x4c4>
  802b49:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802b50:	78 05                	js     802b57 <_Z4fsckv+0x4c4>
  802b52:	83 38 02             	cmpl   $0x2,(%eax)
  802b55:	74 1f                	je     802b76 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802b57:	83 c6 01             	add    $0x1,%esi
  802b5a:	a1 08 10 00 50       	mov    0x50001008,%eax
  802b5f:	39 f0                	cmp    %esi,%eax
  802b61:	7f af                	jg     802b12 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802b63:	bb 01 00 00 00       	mov    $0x1,%ebx
  802b68:	83 f8 01             	cmp    $0x1,%eax
  802b6b:	0f 8f ad 02 00 00    	jg     802e1e <_Z4fsckv+0x78b>
  802b71:	e9 16 03 00 00       	jmp    802e8c <_Z4fsckv+0x7f9>
  802b76:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802b78:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802b7f:	8b 40 08             	mov    0x8(%eax),%eax
  802b82:	a8 7f                	test   $0x7f,%al
  802b84:	74 23                	je     802ba9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802b86:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802b8d:	00 
  802b8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b92:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b96:	c7 04 24 88 49 80 00 	movl   $0x804988,(%esp)
  802b9d:	e8 d4 d7 ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  802ba2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802ba9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802bb0:	00 00 00 
  802bb3:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802bb9:	e9 3d 02 00 00       	jmp    802dfb <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802bbe:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802bc4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802bca:	e8 01 ee ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
  802bcf:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802bd1:	83 38 00             	cmpl   $0x0,(%eax)
  802bd4:	0f 84 15 02 00 00    	je     802def <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802bda:	8b 40 04             	mov    0x4(%eax),%eax
  802bdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  802be0:	83 fa 76             	cmp    $0x76,%edx
  802be3:	76 27                	jbe    802c0c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802be5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802be9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802bef:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bf3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bf7:	c7 04 24 bc 49 80 00 	movl   $0x8049bc,(%esp)
  802bfe:	e8 73 d7 ff ff       	call   800376 <_Z7cprintfPKcz>
				++errors;
  802c03:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802c0a:	eb 28                	jmp    802c34 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802c0c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802c11:	74 21                	je     802c34 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802c13:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c19:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c1d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c21:	c7 04 24 e8 49 80 00 	movl   $0x8049e8,(%esp)
  802c28:	e8 49 d7 ff ff       	call   800376 <_Z7cprintfPKcz>
				++errors;
  802c2d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802c34:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802c3b:	00 
  802c3c:	8d 43 08             	lea    0x8(%ebx),%eax
  802c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c43:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802c49:	89 0c 24             	mov    %ecx,(%esp)
  802c4c:	e8 56 df ff ff       	call   800ba7 <memcpy>
  802c51:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802c55:	bf 77 00 00 00       	mov    $0x77,%edi
  802c5a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802c5e:	85 ff                	test   %edi,%edi
  802c60:	b8 00 00 00 00       	mov    $0x0,%eax
  802c65:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802c68:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802c6f:	00 

			if (de->de_inum >= super->s_ninodes) {
  802c70:	8b 03                	mov    (%ebx),%eax
  802c72:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802c78:	7c 3e                	jl     802cb8 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802c7a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c7e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802c84:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c88:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802c8e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c92:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c96:	c7 04 24 1c 4a 80 00 	movl   $0x804a1c,(%esp)
  802c9d:	e8 d4 d6 ff ff       	call   800376 <_Z7cprintfPKcz>
				++errors;
  802ca2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802ca9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802cb0:	00 00 00 
  802cb3:	e9 0b 01 00 00       	jmp    802dc3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802cb8:	e8 70 ed ff ff       	call   801a2d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802cbd:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802cc4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802ccb:	c1 e2 08             	shl    $0x8,%edx
  802cce:	09 d1                	or     %edx,%ecx
  802cd0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802cd7:	c1 e2 10             	shl    $0x10,%edx
  802cda:	09 d1                	or     %edx,%ecx
  802cdc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802ce3:	83 e2 7f             	and    $0x7f,%edx
  802ce6:	c1 e2 18             	shl    $0x18,%edx
  802ce9:	09 ca                	or     %ecx,%edx
  802ceb:	83 c2 01             	add    $0x1,%edx
  802cee:	89 d1                	mov    %edx,%ecx
  802cf0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802cf6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802cfc:	0f b6 d5             	movzbl %ch,%edx
  802cff:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802d05:	89 ca                	mov    %ecx,%edx
  802d07:	c1 ea 10             	shr    $0x10,%edx
  802d0a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802d10:	c1 e9 18             	shr    $0x18,%ecx
  802d13:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802d1a:	83 e2 80             	and    $0xffffff80,%edx
  802d1d:	09 ca                	or     %ecx,%edx
  802d1f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802d25:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802d29:	0f 85 7a ff ff ff    	jne    802ca9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802d2f:	8b 03                	mov    (%ebx),%eax
  802d31:	89 44 24 10          	mov    %eax,0x10(%esp)
  802d35:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802d3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802d3f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802d45:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d49:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d4d:	c7 04 24 4c 4a 80 00 	movl   $0x804a4c,(%esp)
  802d54:	e8 1d d6 ff ff       	call   800376 <_Z7cprintfPKcz>
					++errors;
  802d59:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802d60:	e9 44 ff ff ff       	jmp    802ca9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802d65:	3b 78 04             	cmp    0x4(%eax),%edi
  802d68:	75 52                	jne    802dbc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802d6a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802d6e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802d74:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d78:	83 c0 08             	add    $0x8,%eax
  802d7b:	89 04 24             	mov    %eax,(%esp)
  802d7e:	e8 65 de ff ff       	call   800be8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802d83:	85 c0                	test   %eax,%eax
  802d85:	75 35                	jne    802dbc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802d87:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802d8d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d91:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802d97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d9b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802da1:	89 54 24 08          	mov    %edx,0x8(%esp)
  802da5:	89 74 24 04          	mov    %esi,0x4(%esp)
  802da9:	c7 04 24 7c 4a 80 00 	movl   $0x804a7c,(%esp)
  802db0:	e8 c1 d5 ff ff       	call   800376 <_Z7cprintfPKcz>
					++errors;
  802db5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802dbc:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802dc3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802dc9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802dcf:	7e 1e                	jle    802def <_Z4fsckv+0x75c>
  802dd1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802dd5:	7f 18                	jg     802def <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802dd7:	89 ca                	mov    %ecx,%edx
  802dd9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802ddf:	e8 ec eb ff ff       	call   8019d0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802de4:	83 38 00             	cmpl   $0x0,(%eax)
  802de7:	0f 85 78 ff ff ff    	jne    802d65 <_Z4fsckv+0x6d2>
  802ded:	eb cd                	jmp    802dbc <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802def:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802df5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802dfb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e01:	83 ea 80             	sub    $0xffffff80,%edx
  802e04:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802e0a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802e10:	3b 51 08             	cmp    0x8(%ecx),%edx
  802e13:	0f 8f e7 fc ff ff    	jg     802b00 <_Z4fsckv+0x46d>
  802e19:	e9 a0 fd ff ff       	jmp    802bbe <_Z4fsckv+0x52b>
  802e1e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802e24:	89 d8                	mov    %ebx,%eax
  802e26:	e8 02 ec ff ff       	call   801a2d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802e2b:	8b 50 04             	mov    0x4(%eax),%edx
  802e2e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802e35:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  802e3c:	c1 e7 08             	shl    $0x8,%edi
  802e3f:	09 f9                	or     %edi,%ecx
  802e41:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  802e48:	c1 e7 10             	shl    $0x10,%edi
  802e4b:	09 f9                	or     %edi,%ecx
  802e4d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  802e54:	83 e7 7f             	and    $0x7f,%edi
  802e57:	c1 e7 18             	shl    $0x18,%edi
  802e5a:	09 f9                	or     %edi,%ecx
  802e5c:	39 ca                	cmp    %ecx,%edx
  802e5e:	74 1b                	je     802e7b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  802e60:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e64:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e68:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e6c:	c7 04 24 ac 4a 80 00 	movl   $0x804aac,(%esp)
  802e73:	e8 fe d4 ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  802e78:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802e7b:	83 c3 01             	add    $0x1,%ebx
  802e7e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802e84:	7f 9e                	jg     802e24 <_Z4fsckv+0x791>
  802e86:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802e8c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802e93:	7e 4f                	jle    802ee4 <_Z4fsckv+0x851>
  802e95:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e9a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  802ea0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  802ea7:	3c ff                	cmp    $0xff,%al
  802ea9:	75 09                	jne    802eb4 <_Z4fsckv+0x821>
			freemap[i] = 0;
  802eab:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  802eb2:	eb 1f                	jmp    802ed3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  802eb4:	84 c0                	test   %al,%al
  802eb6:	75 1b                	jne    802ed3 <_Z4fsckv+0x840>
  802eb8:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  802ebe:	7c 13                	jl     802ed3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  802ec0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ec4:	c7 04 24 d8 4a 80 00 	movl   $0x804ad8,(%esp)
  802ecb:	e8 a6 d4 ff ff       	call   800376 <_Z7cprintfPKcz>
			++errors;
  802ed0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802ed3:	83 c3 01             	add    $0x1,%ebx
  802ed6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802edc:	7f c2                	jg     802ea0 <_Z4fsckv+0x80d>
  802ede:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  802ee4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  802eeb:	19 c0                	sbb    %eax,%eax
  802eed:	f7 d0                	not    %eax
  802eef:	83 e0 fd             	and    $0xfffffffd,%eax
}
  802ef2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  802ef8:	5b                   	pop    %ebx
  802ef9:	5e                   	pop    %esi
  802efa:	5f                   	pop    %edi
  802efb:	5d                   	pop    %ebp
  802efc:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802efd:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802f04:	0f 84 92 f9 ff ff    	je     80289c <_Z4fsckv+0x209>
  802f0a:	e9 5a f9 ff ff       	jmp    802869 <_Z4fsckv+0x1d6>
	...

00802f10 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f10:	55                   	push   %ebp
  802f11:	89 e5                	mov    %esp,%ebp
  802f13:	83 ec 18             	sub    $0x18,%esp
  802f16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802f19:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802f1c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	89 04 24             	mov    %eax,(%esp)
  802f25:	e8 a2 e4 ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  802f2a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802f2c:	c7 44 24 04 0b 4b 80 	movl   $0x804b0b,0x4(%esp)
  802f33:	00 
  802f34:	89 34 24             	mov    %esi,(%esp)
  802f37:	e8 4e da ff ff       	call   80098a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  802f3c:	8b 43 04             	mov    0x4(%ebx),%eax
  802f3f:	2b 03                	sub    (%ebx),%eax
  802f41:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  802f44:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  802f4b:	c7 86 80 00 00 00 24 	movl   $0x805024,0x80(%esi)
  802f52:	50 80 00 
	return 0;
}
  802f55:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802f5d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802f60:	89 ec                	mov    %ebp,%esp
  802f62:	5d                   	pop    %ebp
  802f63:	c3                   	ret    

00802f64 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  802f64:	55                   	push   %ebp
  802f65:	89 e5                	mov    %esp,%ebp
  802f67:	53                   	push   %ebx
  802f68:	83 ec 14             	sub    $0x14,%esp
  802f6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802f6e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f79:	e8 af df ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  802f7e:	89 1c 24             	mov    %ebx,(%esp)
  802f81:	e8 46 e4 ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  802f86:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f91:	e8 97 df ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
}
  802f96:	83 c4 14             	add    $0x14,%esp
  802f99:	5b                   	pop    %ebx
  802f9a:	5d                   	pop    %ebp
  802f9b:	c3                   	ret    

00802f9c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f9c:	55                   	push   %ebp
  802f9d:	89 e5                	mov    %esp,%ebp
  802f9f:	57                   	push   %edi
  802fa0:	56                   	push   %esi
  802fa1:	53                   	push   %ebx
  802fa2:	83 ec 2c             	sub    $0x2c,%esp
  802fa5:	89 c7                	mov    %eax,%edi
  802fa7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  802faa:	a1 04 60 80 00       	mov    0x806004,%eax
  802faf:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  802fb2:	89 3c 24             	mov    %edi,(%esp)
  802fb5:	e8 ba 05 00 00       	call   803574 <_Z7pagerefPv>
  802fba:	89 c3                	mov    %eax,%ebx
  802fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbf:	89 04 24             	mov    %eax,(%esp)
  802fc2:	e8 ad 05 00 00       	call   803574 <_Z7pagerefPv>
  802fc7:	39 c3                	cmp    %eax,%ebx
  802fc9:	0f 94 c0             	sete   %al
  802fcc:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  802fcf:	8b 15 04 60 80 00    	mov    0x806004,%edx
  802fd5:	8b 52 58             	mov    0x58(%edx),%edx
  802fd8:	39 d6                	cmp    %edx,%esi
  802fda:	75 08                	jne    802fe4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  802fdc:	83 c4 2c             	add    $0x2c,%esp
  802fdf:	5b                   	pop    %ebx
  802fe0:	5e                   	pop    %esi
  802fe1:	5f                   	pop    %edi
  802fe2:	5d                   	pop    %ebp
  802fe3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  802fe4:	85 c0                	test   %eax,%eax
  802fe6:	74 c2                	je     802faa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  802fe8:	c7 04 24 12 4b 80 00 	movl   $0x804b12,(%esp)
  802fef:	e8 82 d3 ff ff       	call   800376 <_Z7cprintfPKcz>
  802ff4:	eb b4                	jmp    802faa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00802ff6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802ff6:	55                   	push   %ebp
  802ff7:	89 e5                	mov    %esp,%ebp
  802ff9:	57                   	push   %edi
  802ffa:	56                   	push   %esi
  802ffb:	53                   	push   %ebx
  802ffc:	83 ec 1c             	sub    $0x1c,%esp
  802fff:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803002:	89 34 24             	mov    %esi,(%esp)
  803005:	e8 c2 e3 ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  80300a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80300c:	bf 00 00 00 00       	mov    $0x0,%edi
  803011:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803015:	75 46                	jne    80305d <_ZL13devpipe_writeP2FdPKvj+0x67>
  803017:	eb 52                	jmp    80306b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803019:	89 da                	mov    %ebx,%edx
  80301b:	89 f0                	mov    %esi,%eax
  80301d:	e8 7a ff ff ff       	call   802f9c <_ZL13_pipeisclosedP2FdP4Pipe>
  803022:	85 c0                	test   %eax,%eax
  803024:	75 49                	jne    80306f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803026:	e8 11 de ff ff       	call   800e3c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80302b:	8b 43 04             	mov    0x4(%ebx),%eax
  80302e:	89 c2                	mov    %eax,%edx
  803030:	2b 13                	sub    (%ebx),%edx
  803032:	83 fa 20             	cmp    $0x20,%edx
  803035:	74 e2                	je     803019 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803037:	89 c2                	mov    %eax,%edx
  803039:	c1 fa 1f             	sar    $0x1f,%edx
  80303c:	c1 ea 1b             	shr    $0x1b,%edx
  80303f:	01 d0                	add    %edx,%eax
  803041:	83 e0 1f             	and    $0x1f,%eax
  803044:	29 d0                	sub    %edx,%eax
  803046:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803049:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80304d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803051:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803055:	83 c7 01             	add    $0x1,%edi
  803058:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80305b:	76 0e                	jbe    80306b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80305d:	8b 43 04             	mov    0x4(%ebx),%eax
  803060:	89 c2                	mov    %eax,%edx
  803062:	2b 13                	sub    (%ebx),%edx
  803064:	83 fa 20             	cmp    $0x20,%edx
  803067:	74 b0                	je     803019 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803069:	eb cc                	jmp    803037 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80306b:	89 f8                	mov    %edi,%eax
  80306d:	eb 05                	jmp    803074 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80306f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803074:	83 c4 1c             	add    $0x1c,%esp
  803077:	5b                   	pop    %ebx
  803078:	5e                   	pop    %esi
  803079:	5f                   	pop    %edi
  80307a:	5d                   	pop    %ebp
  80307b:	c3                   	ret    

0080307c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80307c:	55                   	push   %ebp
  80307d:	89 e5                	mov    %esp,%ebp
  80307f:	83 ec 28             	sub    $0x28,%esp
  803082:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803085:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803088:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80308b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80308e:	89 3c 24             	mov    %edi,(%esp)
  803091:	e8 36 e3 ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  803096:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803098:	be 00 00 00 00       	mov    $0x0,%esi
  80309d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8030a1:	75 47                	jne    8030ea <_ZL12devpipe_readP2FdPvj+0x6e>
  8030a3:	eb 52                	jmp    8030f7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  8030a5:	89 f0                	mov    %esi,%eax
  8030a7:	eb 5e                	jmp    803107 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  8030a9:	89 da                	mov    %ebx,%edx
  8030ab:	89 f8                	mov    %edi,%eax
  8030ad:	8d 76 00             	lea    0x0(%esi),%esi
  8030b0:	e8 e7 fe ff ff       	call   802f9c <_ZL13_pipeisclosedP2FdP4Pipe>
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	75 49                	jne    803102 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  8030b9:	e8 7e dd ff ff       	call   800e3c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8030be:	8b 03                	mov    (%ebx),%eax
  8030c0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8030c3:	74 e4                	je     8030a9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8030c5:	89 c2                	mov    %eax,%edx
  8030c7:	c1 fa 1f             	sar    $0x1f,%edx
  8030ca:	c1 ea 1b             	shr    $0x1b,%edx
  8030cd:	01 d0                	add    %edx,%eax
  8030cf:	83 e0 1f             	and    $0x1f,%eax
  8030d2:	29 d0                	sub    %edx,%eax
  8030d4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8030d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030dc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8030df:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8030e2:	83 c6 01             	add    $0x1,%esi
  8030e5:	39 75 10             	cmp    %esi,0x10(%ebp)
  8030e8:	76 0d                	jbe    8030f7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8030ea:	8b 03                	mov    (%ebx),%eax
  8030ec:	3b 43 04             	cmp    0x4(%ebx),%eax
  8030ef:	75 d4                	jne    8030c5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8030f1:	85 f6                	test   %esi,%esi
  8030f3:	75 b0                	jne    8030a5 <_ZL12devpipe_readP2FdPvj+0x29>
  8030f5:	eb b2                	jmp    8030a9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8030f7:	89 f0                	mov    %esi,%eax
  8030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803100:	eb 05                	jmp    803107 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803102:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803107:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80310a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80310d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803110:	89 ec                	mov    %ebp,%esp
  803112:	5d                   	pop    %ebp
  803113:	c3                   	ret    

00803114 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803114:	55                   	push   %ebp
  803115:	89 e5                	mov    %esp,%ebp
  803117:	83 ec 48             	sub    $0x48,%esp
  80311a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80311d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803120:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803123:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803126:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803129:	89 04 24             	mov    %eax,(%esp)
  80312c:	e8 b6 e2 ff ff       	call   8013e7 <_Z14fd_find_unusedPP2Fd>
  803131:	89 c3                	mov    %eax,%ebx
  803133:	85 c0                	test   %eax,%eax
  803135:	0f 88 0b 01 00 00    	js     803246 <_Z4pipePi+0x132>
  80313b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803142:	00 
  803143:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803146:	89 44 24 04          	mov    %eax,0x4(%esp)
  80314a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803151:	e8 1a dd ff ff       	call   800e70 <_Z14sys_page_allociPvi>
  803156:	89 c3                	mov    %eax,%ebx
  803158:	85 c0                	test   %eax,%eax
  80315a:	0f 89 f5 00 00 00    	jns    803255 <_Z4pipePi+0x141>
  803160:	e9 e1 00 00 00       	jmp    803246 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803165:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80316c:	00 
  80316d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803170:	89 44 24 04          	mov    %eax,0x4(%esp)
  803174:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80317b:	e8 f0 dc ff ff       	call   800e70 <_Z14sys_page_allociPvi>
  803180:	89 c3                	mov    %eax,%ebx
  803182:	85 c0                	test   %eax,%eax
  803184:	0f 89 e2 00 00 00    	jns    80326c <_Z4pipePi+0x158>
  80318a:	e9 a4 00 00 00       	jmp    803233 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80318f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803192:	89 04 24             	mov    %eax,(%esp)
  803195:	e8 32 e2 ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  80319a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8031a1:	00 
  8031a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8031ad:	00 
  8031ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031b9:	e8 11 dd ff ff       	call   800ecf <_Z12sys_page_mapiPviS_i>
  8031be:	89 c3                	mov    %eax,%ebx
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	78 4c                	js     803210 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8031c4:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8031ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8031cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031d9:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8031df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8031e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f1:	89 04 24             	mov    %eax,(%esp)
  8031f4:	e8 8b e1 ff ff       	call   801384 <_Z6fd2numP2Fd>
  8031f9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8031fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031fe:	89 04 24             	mov    %eax,(%esp)
  803201:	e8 7e e1 ff ff       	call   801384 <_Z6fd2numP2Fd>
  803206:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803209:	bb 00 00 00 00       	mov    $0x0,%ebx
  80320e:	eb 36                	jmp    803246 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803210:	89 74 24 04          	mov    %esi,0x4(%esp)
  803214:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80321b:	e8 0d dd ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803220:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803223:	89 44 24 04          	mov    %eax,0x4(%esp)
  803227:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80322e:	e8 fa dc ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80323a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803241:	e8 e7 dc ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803246:	89 d8                	mov    %ebx,%eax
  803248:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80324b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80324e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803251:	89 ec                	mov    %ebp,%esp
  803253:	5d                   	pop    %ebp
  803254:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803255:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803258:	89 04 24             	mov    %eax,(%esp)
  80325b:	e8 87 e1 ff ff       	call   8013e7 <_Z14fd_find_unusedPP2Fd>
  803260:	89 c3                	mov    %eax,%ebx
  803262:	85 c0                	test   %eax,%eax
  803264:	0f 89 fb fe ff ff    	jns    803165 <_Z4pipePi+0x51>
  80326a:	eb c7                	jmp    803233 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80326c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326f:	89 04 24             	mov    %eax,(%esp)
  803272:	e8 55 e1 ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  803277:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803279:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803280:	00 
  803281:	89 44 24 04          	mov    %eax,0x4(%esp)
  803285:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80328c:	e8 df db ff ff       	call   800e70 <_Z14sys_page_allociPvi>
  803291:	89 c3                	mov    %eax,%ebx
  803293:	85 c0                	test   %eax,%eax
  803295:	0f 89 f4 fe ff ff    	jns    80318f <_Z4pipePi+0x7b>
  80329b:	eb 83                	jmp    803220 <_Z4pipePi+0x10c>

0080329d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80329d:	55                   	push   %ebp
  80329e:	89 e5                	mov    %esp,%ebp
  8032a0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8032a3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8032aa:	00 
  8032ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	89 04 24             	mov    %eax,(%esp)
  8032b8:	e8 74 e0 ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  8032bd:	85 c0                	test   %eax,%eax
  8032bf:	78 15                	js     8032d6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8032c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c4:	89 04 24             	mov    %eax,(%esp)
  8032c7:	e8 00 e1 ff ff       	call   8013cc <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  8032cc:	89 c2                	mov    %eax,%edx
  8032ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d1:	e8 c6 fc ff ff       	call   802f9c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8032d6:	c9                   	leave  
  8032d7:	c3                   	ret    

008032d8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8032d8:	55                   	push   %ebp
  8032d9:	89 e5                	mov    %esp,%ebp
  8032db:	53                   	push   %ebx
  8032dc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8032df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032e2:	89 04 24             	mov    %eax,(%esp)
  8032e5:	e8 fd e0 ff ff       	call   8013e7 <_Z14fd_find_unusedPP2Fd>
  8032ea:	89 c3                	mov    %eax,%ebx
  8032ec:	85 c0                	test   %eax,%eax
  8032ee:	0f 88 be 00 00 00    	js     8033b2 <_Z18pipe_ipc_recv_readv+0xda>
  8032f4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8032fb:	00 
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  803303:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80330a:	e8 61 db ff ff       	call   800e70 <_Z14sys_page_allociPvi>
  80330f:	89 c3                	mov    %eax,%ebx
  803311:	85 c0                	test   %eax,%eax
  803313:	0f 89 a1 00 00 00    	jns    8033ba <_Z18pipe_ipc_recv_readv+0xe2>
  803319:	e9 94 00 00 00       	jmp    8033b2 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80331e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803321:	85 c0                	test   %eax,%eax
  803323:	75 0e                	jne    803333 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803325:	c7 04 24 70 4b 80 00 	movl   $0x804b70,(%esp)
  80332c:	e8 45 d0 ff ff       	call   800376 <_Z7cprintfPKcz>
  803331:	eb 10                	jmp    803343 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803333:	89 44 24 04          	mov    %eax,0x4(%esp)
  803337:	c7 04 24 25 4b 80 00 	movl   $0x804b25,(%esp)
  80333e:	e8 33 d0 ff ff       	call   800376 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803343:	c7 04 24 2f 4b 80 00 	movl   $0x804b2f,(%esp)
  80334a:	e8 27 d0 ff ff       	call   800376 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80334f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803352:	a8 04                	test   $0x4,%al
  803354:	74 04                	je     80335a <_Z18pipe_ipc_recv_readv+0x82>
  803356:	a8 01                	test   $0x1,%al
  803358:	75 24                	jne    80337e <_Z18pipe_ipc_recv_readv+0xa6>
  80335a:	c7 44 24 0c 42 4b 80 	movl   $0x804b42,0xc(%esp)
  803361:	00 
  803362:	c7 44 24 08 0c 45 80 	movl   $0x80450c,0x8(%esp)
  803369:	00 
  80336a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803371:	00 
  803372:	c7 04 24 5f 4b 80 00 	movl   $0x804b5f,(%esp)
  803379:	e8 da ce ff ff       	call   800258 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80337e:	8b 15 24 50 80 00    	mov    0x805024,%edx
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803393:	89 04 24             	mov    %eax,(%esp)
  803396:	e8 e9 df ff ff       	call   801384 <_Z6fd2numP2Fd>
  80339b:	89 c3                	mov    %eax,%ebx
  80339d:	eb 13                	jmp    8033b2 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033ad:	e8 7b db ff ff       	call   800f2d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  8033b2:	89 d8                	mov    %ebx,%eax
  8033b4:	83 c4 24             	add    $0x24,%esp
  8033b7:	5b                   	pop    %ebx
  8033b8:	5d                   	pop    %ebp
  8033b9:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	89 04 24             	mov    %eax,(%esp)
  8033c0:	e8 07 e0 ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  8033c5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8033c8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8033cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8033d3:	89 04 24             	mov    %eax,(%esp)
  8033d6:	e8 b5 09 00 00       	call   803d90 <_Z8ipc_recvPiPvS_>
  8033db:	89 c3                	mov    %eax,%ebx
  8033dd:	85 c0                	test   %eax,%eax
  8033df:	0f 89 39 ff ff ff    	jns    80331e <_Z18pipe_ipc_recv_readv+0x46>
  8033e5:	eb b8                	jmp    80339f <_Z18pipe_ipc_recv_readv+0xc7>

008033e7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  8033e7:	55                   	push   %ebp
  8033e8:	89 e5                	mov    %esp,%ebp
  8033ea:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  8033ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8033f4:	00 
  8033f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8033f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ff:	89 04 24             	mov    %eax,(%esp)
  803402:	e8 2a df ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  803407:	85 c0                	test   %eax,%eax
  803409:	78 2f                	js     80343a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80340b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340e:	89 04 24             	mov    %eax,(%esp)
  803411:	e8 b6 df ff ff       	call   8013cc <_Z7fd2dataP2Fd>
  803416:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80341d:	00 
  80341e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803422:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803429:	00 
  80342a:	8b 45 08             	mov    0x8(%ebp),%eax
  80342d:	89 04 24             	mov    %eax,(%esp)
  803430:	e8 ea 09 00 00       	call   803e1f <_Z8ipc_sendijPvi>
    return 0;
  803435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80343a:	c9                   	leave  
  80343b:	c3                   	ret    

0080343c <_ZL8writebufP8printbuf>:
};


static void
writebuf(struct printbuf *b)
{
  80343c:	55                   	push   %ebp
  80343d:	89 e5                	mov    %esp,%ebp
  80343f:	53                   	push   %ebx
  803440:	83 ec 14             	sub    $0x14,%esp
  803443:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  803445:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  803449:	7e 31                	jle    80347c <_ZL8writebufP8printbuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80344b:	8b 40 04             	mov    0x4(%eax),%eax
  80344e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803452:	8d 43 10             	lea    0x10(%ebx),%eax
  803455:	89 44 24 04          	mov    %eax,0x4(%esp)
  803459:	8b 03                	mov    (%ebx),%eax
  80345b:	89 04 24             	mov    %eax,(%esp)
  80345e:	e8 66 e3 ff ff       	call   8017c9 <_Z5writeiPKvj>
		if (result > 0)
  803463:	85 c0                	test   %eax,%eax
  803465:	7e 03                	jle    80346a <_ZL8writebufP8printbuf+0x2e>
			b->result += result;
  803467:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80346a:	39 43 04             	cmp    %eax,0x4(%ebx)
  80346d:	74 0d                	je     80347c <_ZL8writebufP8printbuf+0x40>
			b->error = (result < 0 ? result : 0);
  80346f:	85 c0                	test   %eax,%eax
  803471:	ba 00 00 00 00       	mov    $0x0,%edx
  803476:	0f 4f c2             	cmovg  %edx,%eax
  803479:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80347c:	83 c4 14             	add    $0x14,%esp
  80347f:	5b                   	pop    %ebx
  803480:	5d                   	pop    %ebp
  803481:	c3                   	ret    

00803482 <_ZL5putchiPv>:

static void
putch(int ch, void *thunk)
{
  803482:	55                   	push   %ebp
  803483:	89 e5                	mov    %esp,%ebp
  803485:	53                   	push   %ebx
  803486:	83 ec 04             	sub    $0x4,%esp
  803489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80348c:	8b 43 04             	mov    0x4(%ebx),%eax
  80348f:	8b 55 08             	mov    0x8(%ebp),%edx
  803492:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  803496:	83 c0 01             	add    $0x1,%eax
  803499:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  80349c:	3d 00 01 00 00       	cmp    $0x100,%eax
  8034a1:	75 0e                	jne    8034b1 <_ZL5putchiPv+0x2f>
		writebuf(b);
  8034a3:	89 d8                	mov    %ebx,%eax
  8034a5:	e8 92 ff ff ff       	call   80343c <_ZL8writebufP8printbuf>
		b->idx = 0;
  8034aa:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  8034b1:	83 c4 04             	add    $0x4,%esp
  8034b4:	5b                   	pop    %ebx
  8034b5:	5d                   	pop    %ebp
  8034b6:	c3                   	ret    

008034b7 <_Z8vfprintfiPKcPc>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8034b7:	55                   	push   %ebp
  8034b8:	89 e5                	mov    %esp,%ebp
  8034ba:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8034c9:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8034d0:	00 00 00 
	b.result = 0;
  8034d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8034da:	00 00 00 
	b.error = 1;
  8034dd:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8034e4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8034e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8034ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034f5:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8034fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034ff:	c7 04 24 82 34 80 00 	movl   $0x803482,(%esp)
  803506:	e8 ec cf ff ff       	call   8004f7 <_Z9vprintfmtPFviPvES_PKcPc>
	if (b.idx > 0)
  80350b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  803512:	7e 0b                	jle    80351f <_Z8vfprintfiPKcPc+0x68>
		writebuf(&b);
  803514:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80351a:	e8 1d ff ff ff       	call   80343c <_ZL8writebufP8printbuf>

	return (b.result ? b.result : b.error);
  80351f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  803525:	85 c0                	test   %eax,%eax
  803527:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80352e:	c9                   	leave  
  80352f:	c3                   	ret    

00803530 <_Z7fprintfiPKcz>:

int
fprintf(int fd, const char *fmt, ...)
{
  803530:	55                   	push   %ebp
  803531:	89 e5                	mov    %esp,%ebp
  803533:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803536:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  803539:	89 44 24 08          	mov    %eax,0x8(%esp)
  80353d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803540:	89 44 24 04          	mov    %eax,0x4(%esp)
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	89 04 24             	mov    %eax,(%esp)
  80354a:	e8 68 ff ff ff       	call   8034b7 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  80354f:	c9                   	leave  
  803550:	c3                   	ret    

00803551 <_Z6printfPKcz>:

int
printf(const char *fmt, ...)
{
  803551:	55                   	push   %ebp
  803552:	89 e5                	mov    %esp,%ebp
  803554:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803557:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80355a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	89 44 24 04          	mov    %eax,0x4(%esp)
  803565:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80356c:	e8 46 ff ff ff       	call   8034b7 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  803571:	c9                   	leave  
  803572:	c3                   	ret    
	...

00803574 <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803574:	55                   	push   %ebp
  803575:	89 e5                	mov    %esp,%ebp
  803577:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80357a:	89 d0                	mov    %edx,%eax
  80357c:	c1 e8 16             	shr    $0x16,%eax
  80357f:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  803586:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80358b:	f6 c1 01             	test   $0x1,%cl
  80358e:	74 1d                	je     8035ad <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803590:	c1 ea 0c             	shr    $0xc,%edx
  803593:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80359a:	f6 c2 01             	test   $0x1,%dl
  80359d:	74 0e                	je     8035ad <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80359f:	c1 ea 0c             	shr    $0xc,%edx
  8035a2:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  8035a9:	ef 
  8035aa:	0f b7 c0             	movzwl %ax,%eax
}
  8035ad:	5d                   	pop    %ebp
  8035ae:	c3                   	ret    
	...

008035b0 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8035b0:	55                   	push   %ebp
  8035b1:	89 e5                	mov    %esp,%ebp
  8035b3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8035b6:	c7 44 24 04 93 4b 80 	movl   $0x804b93,0x4(%esp)
  8035bd:	00 
  8035be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c1:	89 04 24             	mov    %eax,(%esp)
  8035c4:	e8 c1 d3 ff ff       	call   80098a <_Z6strcpyPcPKc>
	return 0;
}
  8035c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ce:	c9                   	leave  
  8035cf:	c3                   	ret    

008035d0 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8035d0:	55                   	push   %ebp
  8035d1:	89 e5                	mov    %esp,%ebp
  8035d3:	53                   	push   %ebx
  8035d4:	83 ec 14             	sub    $0x14,%esp
  8035d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8035da:	89 1c 24             	mov    %ebx,(%esp)
  8035dd:	e8 92 ff ff ff       	call   803574 <_Z7pagerefPv>
  8035e2:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8035e4:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8035e9:	83 fa 01             	cmp    $0x1,%edx
  8035ec:	75 0b                	jne    8035f9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8035ee:	8b 43 0c             	mov    0xc(%ebx),%eax
  8035f1:	89 04 24             	mov    %eax,(%esp)
  8035f4:	e8 fe 02 00 00       	call   8038f7 <_Z11nsipc_closei>
	else
		return 0;
}
  8035f9:	83 c4 14             	add    $0x14,%esp
  8035fc:	5b                   	pop    %ebx
  8035fd:	5d                   	pop    %ebp
  8035fe:	c3                   	ret    

008035ff <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8035ff:	55                   	push   %ebp
  803600:	89 e5                	mov    %esp,%ebp
  803602:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803605:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80360c:	00 
  80360d:	8b 45 10             	mov    0x10(%ebp),%eax
  803610:	89 44 24 08          	mov    %eax,0x8(%esp)
  803614:	8b 45 0c             	mov    0xc(%ebp),%eax
  803617:	89 44 24 04          	mov    %eax,0x4(%esp)
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	8b 40 0c             	mov    0xc(%eax),%eax
  803621:	89 04 24             	mov    %eax,(%esp)
  803624:	e8 c9 03 00 00       	call   8039f2 <_Z10nsipc_sendiPKvij>
}
  803629:	c9                   	leave  
  80362a:	c3                   	ret    

0080362b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80362b:	55                   	push   %ebp
  80362c:	89 e5                	mov    %esp,%ebp
  80362e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803631:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803638:	00 
  803639:	8b 45 10             	mov    0x10(%ebp),%eax
  80363c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803640:	8b 45 0c             	mov    0xc(%ebp),%eax
  803643:	89 44 24 04          	mov    %eax,0x4(%esp)
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	8b 40 0c             	mov    0xc(%eax),%eax
  80364d:	89 04 24             	mov    %eax,(%esp)
  803650:	e8 1d 03 00 00       	call   803972 <_Z10nsipc_recviPvij>
}
  803655:	c9                   	leave  
  803656:	c3                   	ret    

00803657 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803657:	55                   	push   %ebp
  803658:	89 e5                	mov    %esp,%ebp
  80365a:	83 ec 28             	sub    $0x28,%esp
  80365d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803660:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803663:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803665:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803668:	89 04 24             	mov    %eax,(%esp)
  80366b:	e8 77 dd ff ff       	call   8013e7 <_Z14fd_find_unusedPP2Fd>
  803670:	89 c3                	mov    %eax,%ebx
  803672:	85 c0                	test   %eax,%eax
  803674:	78 21                	js     803697 <_ZL12alloc_sockfdi+0x40>
  803676:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80367d:	00 
  80367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803681:	89 44 24 04          	mov    %eax,0x4(%esp)
  803685:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80368c:	e8 df d7 ff ff       	call   800e70 <_Z14sys_page_allociPvi>
  803691:	89 c3                	mov    %eax,%ebx
  803693:	85 c0                	test   %eax,%eax
  803695:	79 14                	jns    8036ab <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803697:	89 34 24             	mov    %esi,(%esp)
  80369a:	e8 58 02 00 00       	call   8038f7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  80369f:	89 d8                	mov    %ebx,%eax
  8036a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8036a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8036a7:	89 ec                	mov    %ebp,%esp
  8036a9:	5d                   	pop    %ebp
  8036aa:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  8036ab:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8036b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8036b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8036c0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8036c3:	89 04 24             	mov    %eax,(%esp)
  8036c6:	e8 b9 dc ff ff       	call   801384 <_Z6fd2numP2Fd>
  8036cb:	89 c3                	mov    %eax,%ebx
  8036cd:	eb d0                	jmp    80369f <_ZL12alloc_sockfdi+0x48>

008036cf <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  8036cf:	55                   	push   %ebp
  8036d0:	89 e5                	mov    %esp,%ebp
  8036d2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  8036d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8036dc:	00 
  8036dd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8036e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8036e4:	89 04 24             	mov    %eax,(%esp)
  8036e7:	e8 45 dc ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  8036ec:	85 c0                	test   %eax,%eax
  8036ee:	78 15                	js     803705 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8036f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  8036f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8036f8:	8b 0d 40 50 80 00    	mov    0x805040,%ecx
  8036fe:	39 0a                	cmp    %ecx,(%edx)
  803700:	75 03                	jne    803705 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803702:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803705:	c9                   	leave  
  803706:	c3                   	ret    

00803707 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803707:	55                   	push   %ebp
  803708:	89 e5                	mov    %esp,%ebp
  80370a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80370d:	8b 45 08             	mov    0x8(%ebp),%eax
  803710:	e8 ba ff ff ff       	call   8036cf <_ZL9fd2sockidi>
  803715:	85 c0                	test   %eax,%eax
  803717:	78 1f                	js     803738 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803719:	8b 55 10             	mov    0x10(%ebp),%edx
  80371c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803720:	8b 55 0c             	mov    0xc(%ebp),%edx
  803723:	89 54 24 04          	mov    %edx,0x4(%esp)
  803727:	89 04 24             	mov    %eax,(%esp)
  80372a:	e8 19 01 00 00       	call   803848 <_Z12nsipc_acceptiP8sockaddrPj>
  80372f:	85 c0                	test   %eax,%eax
  803731:	78 05                	js     803738 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803733:	e8 1f ff ff ff       	call   803657 <_ZL12alloc_sockfdi>
}
  803738:	c9                   	leave  
  803739:	c3                   	ret    

0080373a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80373a:	55                   	push   %ebp
  80373b:	89 e5                	mov    %esp,%ebp
  80373d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	e8 87 ff ff ff       	call   8036cf <_ZL9fd2sockidi>
  803748:	85 c0                	test   %eax,%eax
  80374a:	78 16                	js     803762 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80374c:	8b 55 10             	mov    0x10(%ebp),%edx
  80374f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803753:	8b 55 0c             	mov    0xc(%ebp),%edx
  803756:	89 54 24 04          	mov    %edx,0x4(%esp)
  80375a:	89 04 24             	mov    %eax,(%esp)
  80375d:	e8 34 01 00 00       	call   803896 <_Z10nsipc_bindiP8sockaddrj>
}
  803762:	c9                   	leave  
  803763:	c3                   	ret    

00803764 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803764:	55                   	push   %ebp
  803765:	89 e5                	mov    %esp,%ebp
  803767:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80376a:	8b 45 08             	mov    0x8(%ebp),%eax
  80376d:	e8 5d ff ff ff       	call   8036cf <_ZL9fd2sockidi>
  803772:	85 c0                	test   %eax,%eax
  803774:	78 0f                	js     803785 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803776:	8b 55 0c             	mov    0xc(%ebp),%edx
  803779:	89 54 24 04          	mov    %edx,0x4(%esp)
  80377d:	89 04 24             	mov    %eax,(%esp)
  803780:	e8 50 01 00 00       	call   8038d5 <_Z14nsipc_shutdownii>
}
  803785:	c9                   	leave  
  803786:	c3                   	ret    

00803787 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803787:	55                   	push   %ebp
  803788:	89 e5                	mov    %esp,%ebp
  80378a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80378d:	8b 45 08             	mov    0x8(%ebp),%eax
  803790:	e8 3a ff ff ff       	call   8036cf <_ZL9fd2sockidi>
  803795:	85 c0                	test   %eax,%eax
  803797:	78 16                	js     8037af <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803799:	8b 55 10             	mov    0x10(%ebp),%edx
  80379c:	89 54 24 08          	mov    %edx,0x8(%esp)
  8037a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8037a7:	89 04 24             	mov    %eax,(%esp)
  8037aa:	e8 62 01 00 00       	call   803911 <_Z13nsipc_connectiPK8sockaddrj>
}
  8037af:	c9                   	leave  
  8037b0:	c3                   	ret    

008037b1 <_Z6listenii>:

int
listen(int s, int backlog)
{
  8037b1:	55                   	push   %ebp
  8037b2:	89 e5                	mov    %esp,%ebp
  8037b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ba:	e8 10 ff ff ff       	call   8036cf <_ZL9fd2sockidi>
  8037bf:	85 c0                	test   %eax,%eax
  8037c1:	78 0f                	js     8037d2 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8037c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8037ca:	89 04 24             	mov    %eax,(%esp)
  8037cd:	e8 7e 01 00 00       	call   803950 <_Z12nsipc_listenii>
}
  8037d2:	c9                   	leave  
  8037d3:	c3                   	ret    

008037d4 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8037d4:	55                   	push   %ebp
  8037d5:	89 e5                	mov    %esp,%ebp
  8037d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8037da:	8b 45 10             	mov    0x10(%ebp),%eax
  8037dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	89 04 24             	mov    %eax,(%esp)
  8037ee:	e8 72 02 00 00       	call   803a65 <_Z12nsipc_socketiii>
  8037f3:	85 c0                	test   %eax,%eax
  8037f5:	78 05                	js     8037fc <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  8037f7:	e8 5b fe ff ff       	call   803657 <_ZL12alloc_sockfdi>
}
  8037fc:	c9                   	leave  
  8037fd:	8d 76 00             	lea    0x0(%esi),%esi
  803800:	c3                   	ret    
  803801:	00 00                	add    %al,(%eax)
	...

00803804 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803804:	55                   	push   %ebp
  803805:	89 e5                	mov    %esp,%ebp
  803807:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80380a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803811:	00 
  803812:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803819:	00 
  80381a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80381e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803825:	e8 f5 05 00 00       	call   803e1f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  80382a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803831:	00 
  803832:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803839:	00 
  80383a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803841:	e8 4a 05 00 00       	call   803d90 <_Z8ipc_recvPiPvS_>
}
  803846:	c9                   	leave  
  803847:	c3                   	ret    

00803848 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803848:	55                   	push   %ebp
  803849:	89 e5                	mov    %esp,%ebp
  80384b:	53                   	push   %ebx
  80384c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  80384f:	8b 45 08             	mov    0x8(%ebp),%eax
  803852:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803857:	b8 01 00 00 00       	mov    $0x1,%eax
  80385c:	e8 a3 ff ff ff       	call   803804 <_ZL5nsipcj>
  803861:	89 c3                	mov    %eax,%ebx
  803863:	85 c0                	test   %eax,%eax
  803865:	78 27                	js     80388e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803867:	a1 10 70 80 00       	mov    0x807010,%eax
  80386c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803870:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803877:	00 
  803878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80387b:	89 04 24             	mov    %eax,(%esp)
  80387e:	e8 a9 d2 ff ff       	call   800b2c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803883:	8b 15 10 70 80 00    	mov    0x807010,%edx
  803889:	8b 45 10             	mov    0x10(%ebp),%eax
  80388c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  80388e:	89 d8                	mov    %ebx,%eax
  803890:	83 c4 14             	add    $0x14,%esp
  803893:	5b                   	pop    %ebx
  803894:	5d                   	pop    %ebp
  803895:	c3                   	ret    

00803896 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803896:	55                   	push   %ebp
  803897:	89 e5                	mov    %esp,%ebp
  803899:	53                   	push   %ebx
  80389a:	83 ec 14             	sub    $0x14,%esp
  80389d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038b3:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8038ba:	e8 6d d2 ff ff       	call   800b2c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8038bf:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8038c5:	b8 02 00 00 00       	mov    $0x2,%eax
  8038ca:	e8 35 ff ff ff       	call   803804 <_ZL5nsipcj>
}
  8038cf:	83 c4 14             	add    $0x14,%esp
  8038d2:	5b                   	pop    %ebx
  8038d3:	5d                   	pop    %ebp
  8038d4:	c3                   	ret    

008038d5 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  8038d5:	55                   	push   %ebp
  8038d6:	89 e5                	mov    %esp,%ebp
  8038d8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8038db:	8b 45 08             	mov    0x8(%ebp),%eax
  8038de:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8038e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8038eb:	b8 03 00 00 00       	mov    $0x3,%eax
  8038f0:	e8 0f ff ff ff       	call   803804 <_ZL5nsipcj>
}
  8038f5:	c9                   	leave  
  8038f6:	c3                   	ret    

008038f7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  8038f7:	55                   	push   %ebp
  8038f8:	89 e5                	mov    %esp,%ebp
  8038fa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803905:	b8 04 00 00 00       	mov    $0x4,%eax
  80390a:	e8 f5 fe ff ff       	call   803804 <_ZL5nsipcj>
}
  80390f:	c9                   	leave  
  803910:	c3                   	ret    

00803911 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803911:	55                   	push   %ebp
  803912:	89 e5                	mov    %esp,%ebp
  803914:	53                   	push   %ebx
  803915:	83 ec 14             	sub    $0x14,%esp
  803918:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80391b:	8b 45 08             	mov    0x8(%ebp),%eax
  80391e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803923:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80392a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80392e:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803935:	e8 f2 d1 ff ff       	call   800b2c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80393a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803940:	b8 05 00 00 00       	mov    $0x5,%eax
  803945:	e8 ba fe ff ff       	call   803804 <_ZL5nsipcj>
}
  80394a:	83 c4 14             	add    $0x14,%esp
  80394d:	5b                   	pop    %ebx
  80394e:	5d                   	pop    %ebp
  80394f:	c3                   	ret    

00803950 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803950:	55                   	push   %ebp
  803951:	89 e5                	mov    %esp,%ebp
  803953:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803956:	8b 45 08             	mov    0x8(%ebp),%eax
  803959:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80395e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803961:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803966:	b8 06 00 00 00       	mov    $0x6,%eax
  80396b:	e8 94 fe ff ff       	call   803804 <_ZL5nsipcj>
}
  803970:	c9                   	leave  
  803971:	c3                   	ret    

00803972 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803972:	55                   	push   %ebp
  803973:	89 e5                	mov    %esp,%ebp
  803975:	56                   	push   %esi
  803976:	53                   	push   %ebx
  803977:	83 ec 10             	sub    $0x10,%esp
  80397a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80397d:	8b 45 08             	mov    0x8(%ebp),%eax
  803980:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803985:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80398b:	8b 45 14             	mov    0x14(%ebp),%eax
  80398e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803993:	b8 07 00 00 00       	mov    $0x7,%eax
  803998:	e8 67 fe ff ff       	call   803804 <_ZL5nsipcj>
  80399d:	89 c3                	mov    %eax,%ebx
  80399f:	85 c0                	test   %eax,%eax
  8039a1:	78 46                	js     8039e9 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  8039a3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8039a8:	7f 04                	jg     8039ae <_Z10nsipc_recviPvij+0x3c>
  8039aa:	39 f0                	cmp    %esi,%eax
  8039ac:	7e 24                	jle    8039d2 <_Z10nsipc_recviPvij+0x60>
  8039ae:	c7 44 24 0c 9f 4b 80 	movl   $0x804b9f,0xc(%esp)
  8039b5:	00 
  8039b6:	c7 44 24 08 0c 45 80 	movl   $0x80450c,0x8(%esp)
  8039bd:	00 
  8039be:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8039c5:	00 
  8039c6:	c7 04 24 b4 4b 80 00 	movl   $0x804bb4,(%esp)
  8039cd:	e8 86 c8 ff ff       	call   800258 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8039d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8039d6:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8039dd:	00 
  8039de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e1:	89 04 24             	mov    %eax,(%esp)
  8039e4:	e8 43 d1 ff ff       	call   800b2c <memmove>
	}

	return r;
}
  8039e9:	89 d8                	mov    %ebx,%eax
  8039eb:	83 c4 10             	add    $0x10,%esp
  8039ee:	5b                   	pop    %ebx
  8039ef:	5e                   	pop    %esi
  8039f0:	5d                   	pop    %ebp
  8039f1:	c3                   	ret    

008039f2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8039f2:	55                   	push   %ebp
  8039f3:	89 e5                	mov    %esp,%ebp
  8039f5:	53                   	push   %ebx
  8039f6:	83 ec 14             	sub    $0x14,%esp
  8039f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8039fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ff:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803a04:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803a0a:	7e 24                	jle    803a30 <_Z10nsipc_sendiPKvij+0x3e>
  803a0c:	c7 44 24 0c c0 4b 80 	movl   $0x804bc0,0xc(%esp)
  803a13:	00 
  803a14:	c7 44 24 08 0c 45 80 	movl   $0x80450c,0x8(%esp)
  803a1b:	00 
  803a1c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803a23:	00 
  803a24:	c7 04 24 b4 4b 80 00 	movl   $0x804bb4,(%esp)
  803a2b:	e8 28 c8 ff ff       	call   800258 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a30:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a3b:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803a42:	e8 e5 d0 ff ff       	call   800b2c <memmove>
	nsipcbuf.send.req_size = size;
  803a47:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  803a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  803a50:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803a55:	b8 08 00 00 00       	mov    $0x8,%eax
  803a5a:	e8 a5 fd ff ff       	call   803804 <_ZL5nsipcj>
}
  803a5f:	83 c4 14             	add    $0x14,%esp
  803a62:	5b                   	pop    %ebx
  803a63:	5d                   	pop    %ebp
  803a64:	c3                   	ret    

00803a65 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a65:	55                   	push   %ebp
  803a66:	89 e5                	mov    %esp,%ebp
  803a68:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a76:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  803a7b:	8b 45 10             	mov    0x10(%ebp),%eax
  803a7e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803a83:	b8 09 00 00 00       	mov    $0x9,%eax
  803a88:	e8 77 fd ff ff       	call   803804 <_ZL5nsipcj>
}
  803a8d:	c9                   	leave  
  803a8e:	c3                   	ret    
	...

00803a90 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803a90:	55                   	push   %ebp
  803a91:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803a93:	b8 00 00 00 00       	mov    $0x0,%eax
  803a98:	5d                   	pop    %ebp
  803a99:	c3                   	ret    

00803a9a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a9a:	55                   	push   %ebp
  803a9b:	89 e5                	mov    %esp,%ebp
  803a9d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803aa0:	c7 44 24 04 cc 4b 80 	movl   $0x804bcc,0x4(%esp)
  803aa7:	00 
  803aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aab:	89 04 24             	mov    %eax,(%esp)
  803aae:	e8 d7 ce ff ff       	call   80098a <_Z6strcpyPcPKc>
	return 0;
}
  803ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab8:	c9                   	leave  
  803ab9:	c3                   	ret    

00803aba <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803aba:	55                   	push   %ebp
  803abb:	89 e5                	mov    %esp,%ebp
  803abd:	57                   	push   %edi
  803abe:	56                   	push   %esi
  803abf:	53                   	push   %ebx
  803ac0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ac6:	bb 00 00 00 00       	mov    $0x0,%ebx
  803acb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803acf:	74 3e                	je     803b0f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803ad1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803ad7:	8b 75 10             	mov    0x10(%ebp),%esi
  803ada:	29 de                	sub    %ebx,%esi
  803adc:	83 fe 7f             	cmp    $0x7f,%esi
  803adf:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803ae4:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803ae7:	89 74 24 08          	mov    %esi,0x8(%esp)
  803aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aee:	01 d8                	add    %ebx,%eax
  803af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803af4:	89 3c 24             	mov    %edi,(%esp)
  803af7:	e8 30 d0 ff ff       	call   800b2c <memmove>
		sys_cputs(buf, m);
  803afc:	89 74 24 04          	mov    %esi,0x4(%esp)
  803b00:	89 3c 24             	mov    %edi,(%esp)
  803b03:	e8 3c d2 ff ff       	call   800d44 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b08:	01 f3                	add    %esi,%ebx
  803b0a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803b0d:	77 c8                	ja     803ad7 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803b0f:	89 d8                	mov    %ebx,%eax
  803b11:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803b17:	5b                   	pop    %ebx
  803b18:	5e                   	pop    %esi
  803b19:	5f                   	pop    %edi
  803b1a:	5d                   	pop    %ebp
  803b1b:	c3                   	ret    

00803b1c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b1c:	55                   	push   %ebp
  803b1d:	89 e5                	mov    %esp,%ebp
  803b1f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803b22:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803b27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803b2b:	75 07                	jne    803b34 <_ZL12devcons_readP2FdPvj+0x18>
  803b2d:	eb 2a                	jmp    803b59 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803b2f:	e8 08 d3 ff ff       	call   800e3c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803b34:	e8 3e d2 ff ff       	call   800d77 <_Z9sys_cgetcv>
  803b39:	85 c0                	test   %eax,%eax
  803b3b:	74 f2                	je     803b2f <_ZL12devcons_readP2FdPvj+0x13>
  803b3d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803b3f:	85 c0                	test   %eax,%eax
  803b41:	78 16                	js     803b59 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803b43:	83 f8 04             	cmp    $0x4,%eax
  803b46:	74 0c                	je     803b54 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b4b:	88 10                	mov    %dl,(%eax)
	return 1;
  803b4d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b52:	eb 05                	jmp    803b59 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803b54:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803b59:	c9                   	leave  
  803b5a:	c3                   	ret    

00803b5b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b5b:	55                   	push   %ebp
  803b5c:	89 e5                	mov    %esp,%ebp
  803b5e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803b61:	8b 45 08             	mov    0x8(%ebp),%eax
  803b64:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b67:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803b6e:	00 
  803b6f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803b72:	89 04 24             	mov    %eax,(%esp)
  803b75:	e8 ca d1 ff ff       	call   800d44 <_Z9sys_cputsPKcj>
}
  803b7a:	c9                   	leave  
  803b7b:	c3                   	ret    

00803b7c <_Z7getcharv>:

int
getchar(void)
{
  803b7c:	55                   	push   %ebp
  803b7d:	89 e5                	mov    %esp,%ebp
  803b7f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b82:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803b89:	00 
  803b8a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b98:	e8 41 db ff ff       	call   8016de <_Z4readiPvj>
	if (r < 0)
  803b9d:	85 c0                	test   %eax,%eax
  803b9f:	78 0f                	js     803bb0 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803ba1:	85 c0                	test   %eax,%eax
  803ba3:	7e 06                	jle    803bab <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803ba5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803ba9:	eb 05                	jmp    803bb0 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803bab:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803bb0:	c9                   	leave  
  803bb1:	c3                   	ret    

00803bb2 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803bb2:	55                   	push   %ebp
  803bb3:	89 e5                	mov    %esp,%ebp
  803bb5:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803bb8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803bbf:	00 
  803bc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bca:	89 04 24             	mov    %eax,(%esp)
  803bcd:	e8 5f d7 ff ff       	call   801331 <_Z9fd_lookupiPP2Fdb>
  803bd2:	85 c0                	test   %eax,%eax
  803bd4:	78 11                	js     803be7 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd9:	8b 15 5c 50 80 00    	mov    0x80505c,%edx
  803bdf:	39 10                	cmp    %edx,(%eax)
  803be1:	0f 94 c0             	sete   %al
  803be4:	0f b6 c0             	movzbl %al,%eax
}
  803be7:	c9                   	leave  
  803be8:	c3                   	ret    

00803be9 <_Z8openconsv>:

int
opencons(void)
{
  803be9:	55                   	push   %ebp
  803bea:	89 e5                	mov    %esp,%ebp
  803bec:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803bef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803bf2:	89 04 24             	mov    %eax,(%esp)
  803bf5:	e8 ed d7 ff ff       	call   8013e7 <_Z14fd_find_unusedPP2Fd>
  803bfa:	85 c0                	test   %eax,%eax
  803bfc:	78 3c                	js     803c3a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803bfe:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803c05:	00 
  803c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c14:	e8 57 d2 ff ff       	call   800e70 <_Z14sys_page_allociPvi>
  803c19:	85 c0                	test   %eax,%eax
  803c1b:	78 1d                	js     803c3a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803c1d:	8b 15 5c 50 80 00    	mov    0x80505c,%edx
  803c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c26:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803c32:	89 04 24             	mov    %eax,(%esp)
  803c35:	e8 4a d7 ff ff       	call   801384 <_Z6fd2numP2Fd>
}
  803c3a:	c9                   	leave  
  803c3b:	c3                   	ret    
  803c3c:	00 00                	add    %al,(%eax)
	...

00803c40 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803c40:	55                   	push   %ebp
  803c41:	89 e5                	mov    %esp,%ebp
  803c43:	56                   	push   %esi
  803c44:	53                   	push   %ebx
  803c45:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803c48:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803c4d:	8b 04 9d 00 80 80 00 	mov    0x808000(,%ebx,4),%eax
  803c54:	85 c0                	test   %eax,%eax
  803c56:	74 08                	je     803c60 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803c58:	8d 55 08             	lea    0x8(%ebp),%edx
  803c5b:	89 14 24             	mov    %edx,(%esp)
  803c5e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803c60:	83 eb 01             	sub    $0x1,%ebx
  803c63:	83 fb ff             	cmp    $0xffffffff,%ebx
  803c66:	75 e5                	jne    803c4d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803c68:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803c6b:	8b 75 08             	mov    0x8(%ebp),%esi
  803c6e:	e8 95 d1 ff ff       	call   800e08 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803c73:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803c77:	89 74 24 10          	mov    %esi,0x10(%esp)
  803c7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c7f:	c7 44 24 08 d8 4b 80 	movl   $0x804bd8,0x8(%esp)
  803c86:	00 
  803c87:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803c8e:	00 
  803c8f:	c7 04 24 5c 4c 80 00 	movl   $0x804c5c,(%esp)
  803c96:	e8 bd c5 ff ff       	call   800258 <_Z6_panicPKciS0_z>

00803c9b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803c9b:	55                   	push   %ebp
  803c9c:	89 e5                	mov    %esp,%ebp
  803c9e:	56                   	push   %esi
  803c9f:	53                   	push   %ebx
  803ca0:	83 ec 10             	sub    $0x10,%esp
  803ca3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803ca6:	e8 5d d1 ff ff       	call   800e08 <_Z12sys_getenvidv>
  803cab:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803cad:	a1 04 60 80 00       	mov    0x806004,%eax
  803cb2:	8b 40 5c             	mov    0x5c(%eax),%eax
  803cb5:	85 c0                	test   %eax,%eax
  803cb7:	75 4c                	jne    803d05 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803cb9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803cc0:	00 
  803cc1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803cc8:	ee 
  803cc9:	89 34 24             	mov    %esi,(%esp)
  803ccc:	e8 9f d1 ff ff       	call   800e70 <_Z14sys_page_allociPvi>
  803cd1:	85 c0                	test   %eax,%eax
  803cd3:	74 20                	je     803cf5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803cd5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803cd9:	c7 44 24 08 10 4c 80 	movl   $0x804c10,0x8(%esp)
  803ce0:	00 
  803ce1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803ce8:	00 
  803ce9:	c7 04 24 5c 4c 80 00 	movl   $0x804c5c,(%esp)
  803cf0:	e8 63 c5 ff ff       	call   800258 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803cf5:	c7 44 24 04 40 3c 80 	movl   $0x803c40,0x4(%esp)
  803cfc:	00 
  803cfd:	89 34 24             	mov    %esi,(%esp)
  803d00:	e8 a0 d3 ff ff       	call   8010a5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803d05:	a1 00 80 80 00       	mov    0x808000,%eax
  803d0a:	39 d8                	cmp    %ebx,%eax
  803d0c:	74 1a                	je     803d28 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803d0e:	85 c0                	test   %eax,%eax
  803d10:	74 20                	je     803d32 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803d12:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803d17:	8b 14 85 00 80 80 00 	mov    0x808000(,%eax,4),%edx
  803d1e:	39 da                	cmp    %ebx,%edx
  803d20:	74 15                	je     803d37 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803d22:	85 d2                	test   %edx,%edx
  803d24:	75 1f                	jne    803d45 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  803d26:	eb 0f                	jmp    803d37 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803d28:	b8 00 00 00 00       	mov    $0x0,%eax
  803d2d:	8d 76 00             	lea    0x0(%esi),%esi
  803d30:	eb 05                	jmp    803d37 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803d32:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  803d37:	89 1c 85 00 80 80 00 	mov    %ebx,0x808000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  803d3e:	83 c4 10             	add    $0x10,%esp
  803d41:	5b                   	pop    %ebx
  803d42:	5e                   	pop    %esi
  803d43:	5d                   	pop    %ebp
  803d44:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803d45:	83 c0 01             	add    $0x1,%eax
  803d48:	83 f8 08             	cmp    $0x8,%eax
  803d4b:	75 ca                	jne    803d17 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  803d4d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803d51:	c7 44 24 08 34 4c 80 	movl   $0x804c34,0x8(%esp)
  803d58:	00 
  803d59:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803d60:	00 
  803d61:	c7 04 24 5c 4c 80 00 	movl   $0x804c5c,(%esp)
  803d68:	e8 eb c4 ff ff       	call   800258 <_Z6_panicPKciS0_z>
  803d6d:	00 00                	add    %al,(%eax)
	...

00803d70 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  803d70:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  803d73:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  803d74:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  803d77:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  803d7b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  803d7f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  803d82:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  803d84:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  803d88:	61                   	popa   
    popf
  803d89:	9d                   	popf   
    popl %esp
  803d8a:	5c                   	pop    %esp
    ret
  803d8b:	c3                   	ret    

00803d8c <spin>:

spin:	jmp spin
  803d8c:	eb fe                	jmp    803d8c <spin>
	...

00803d90 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d90:	55                   	push   %ebp
  803d91:	89 e5                	mov    %esp,%ebp
  803d93:	56                   	push   %esi
  803d94:	53                   	push   %ebx
  803d95:	83 ec 10             	sub    $0x10,%esp
  803d98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d9e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  803da1:	85 c0                	test   %eax,%eax
  803da3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803da8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  803dab:	89 04 24             	mov    %eax,(%esp)
  803dae:	e8 88 d3 ff ff       	call   80113b <_Z12sys_ipc_recvPv>
  803db3:	85 c0                	test   %eax,%eax
  803db5:	79 16                	jns    803dcd <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  803db7:	85 db                	test   %ebx,%ebx
  803db9:	74 06                	je     803dc1 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  803dbb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  803dc1:	85 f6                	test   %esi,%esi
  803dc3:	74 53                	je     803e18 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  803dc5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803dcb:	eb 4b                	jmp    803e18 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  803dcd:	85 db                	test   %ebx,%ebx
  803dcf:	74 17                	je     803de8 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  803dd1:	e8 32 d0 ff ff       	call   800e08 <_Z12sys_getenvidv>
  803dd6:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ddb:	6b c0 78             	imul   $0x78,%eax,%eax
  803dde:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  803de3:	8b 40 60             	mov    0x60(%eax),%eax
  803de6:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  803de8:	85 f6                	test   %esi,%esi
  803dea:	74 17                	je     803e03 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  803dec:	e8 17 d0 ff ff       	call   800e08 <_Z12sys_getenvidv>
  803df1:	25 ff 03 00 00       	and    $0x3ff,%eax
  803df6:	6b c0 78             	imul   $0x78,%eax,%eax
  803df9:	05 00 00 00 ef       	add    $0xef000000,%eax
  803dfe:	8b 40 70             	mov    0x70(%eax),%eax
  803e01:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  803e03:	e8 00 d0 ff ff       	call   800e08 <_Z12sys_getenvidv>
  803e08:	25 ff 03 00 00       	and    $0x3ff,%eax
  803e0d:	6b c0 78             	imul   $0x78,%eax,%eax
  803e10:	05 08 00 00 ef       	add    $0xef000008,%eax
  803e15:	8b 40 60             	mov    0x60(%eax),%eax

}
  803e18:	83 c4 10             	add    $0x10,%esp
  803e1b:	5b                   	pop    %ebx
  803e1c:	5e                   	pop    %esi
  803e1d:	5d                   	pop    %ebp
  803e1e:	c3                   	ret    

00803e1f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e1f:	55                   	push   %ebp
  803e20:	89 e5                	mov    %esp,%ebp
  803e22:	57                   	push   %edi
  803e23:	56                   	push   %esi
  803e24:	53                   	push   %ebx
  803e25:	83 ec 1c             	sub    $0x1c,%esp
  803e28:	8b 75 08             	mov    0x8(%ebp),%esi
  803e2b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803e2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  803e31:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  803e33:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803e38:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803e3b:	8b 45 14             	mov    0x14(%ebp),%eax
  803e3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e42:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e46:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803e4a:	89 34 24             	mov    %esi,(%esp)
  803e4d:	e8 b1 d2 ff ff       	call   801103 <_Z16sys_ipc_try_sendijPvi>
  803e52:	85 c0                	test   %eax,%eax
  803e54:	79 31                	jns    803e87 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  803e56:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803e59:	75 0c                	jne    803e67 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  803e5b:	90                   	nop
  803e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803e60:	e8 d7 cf ff ff       	call   800e3c <_Z9sys_yieldv>
  803e65:	eb d4                	jmp    803e3b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  803e67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e6b:	c7 44 24 08 6a 4c 80 	movl   $0x804c6a,0x8(%esp)
  803e72:	00 
  803e73:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  803e7a:	00 
  803e7b:	c7 04 24 77 4c 80 00 	movl   $0x804c77,(%esp)
  803e82:	e8 d1 c3 ff ff       	call   800258 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  803e87:	83 c4 1c             	add    $0x1c,%esp
  803e8a:	5b                   	pop    %ebx
  803e8b:	5e                   	pop    %esi
  803e8c:	5f                   	pop    %edi
  803e8d:	5d                   	pop    %ebp
  803e8e:	c3                   	ret    
	...

00803e90 <__udivdi3>:
  803e90:	55                   	push   %ebp
  803e91:	89 e5                	mov    %esp,%ebp
  803e93:	57                   	push   %edi
  803e94:	56                   	push   %esi
  803e95:	83 ec 20             	sub    $0x20,%esp
  803e98:	8b 45 14             	mov    0x14(%ebp),%eax
  803e9b:	8b 75 08             	mov    0x8(%ebp),%esi
  803e9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803ea1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803ea4:	85 c0                	test   %eax,%eax
  803ea6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803ea9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  803eac:	75 3a                	jne    803ee8 <__udivdi3+0x58>
  803eae:	39 f9                	cmp    %edi,%ecx
  803eb0:	77 66                	ja     803f18 <__udivdi3+0x88>
  803eb2:	85 c9                	test   %ecx,%ecx
  803eb4:	75 0b                	jne    803ec1 <__udivdi3+0x31>
  803eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebb:	31 d2                	xor    %edx,%edx
  803ebd:	f7 f1                	div    %ecx
  803ebf:	89 c1                	mov    %eax,%ecx
  803ec1:	89 f8                	mov    %edi,%eax
  803ec3:	31 d2                	xor    %edx,%edx
  803ec5:	f7 f1                	div    %ecx
  803ec7:	89 c7                	mov    %eax,%edi
  803ec9:	89 f0                	mov    %esi,%eax
  803ecb:	f7 f1                	div    %ecx
  803ecd:	89 fa                	mov    %edi,%edx
  803ecf:	89 c6                	mov    %eax,%esi
  803ed1:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803ed4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803edd:	83 c4 20             	add    $0x20,%esp
  803ee0:	5e                   	pop    %esi
  803ee1:	5f                   	pop    %edi
  803ee2:	5d                   	pop    %ebp
  803ee3:	c3                   	ret    
  803ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803ee8:	31 d2                	xor    %edx,%edx
  803eea:	31 f6                	xor    %esi,%esi
  803eec:	39 f8                	cmp    %edi,%eax
  803eee:	77 e1                	ja     803ed1 <__udivdi3+0x41>
  803ef0:	0f bd d0             	bsr    %eax,%edx
  803ef3:	83 f2 1f             	xor    $0x1f,%edx
  803ef6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803ef9:	75 2d                	jne    803f28 <__udivdi3+0x98>
  803efb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803efe:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  803f01:	76 06                	jbe    803f09 <__udivdi3+0x79>
  803f03:	39 f8                	cmp    %edi,%eax
  803f05:	89 f2                	mov    %esi,%edx
  803f07:	73 c8                	jae    803ed1 <__udivdi3+0x41>
  803f09:	31 d2                	xor    %edx,%edx
  803f0b:	be 01 00 00 00       	mov    $0x1,%esi
  803f10:	eb bf                	jmp    803ed1 <__udivdi3+0x41>
  803f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803f18:	89 f0                	mov    %esi,%eax
  803f1a:	89 fa                	mov    %edi,%edx
  803f1c:	f7 f1                	div    %ecx
  803f1e:	31 d2                	xor    %edx,%edx
  803f20:	89 c6                	mov    %eax,%esi
  803f22:	eb ad                	jmp    803ed1 <__udivdi3+0x41>
  803f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803f28:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f2c:	89 c2                	mov    %eax,%edx
  803f2e:	b8 20 00 00 00       	mov    $0x20,%eax
  803f33:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803f36:	2b 45 ec             	sub    -0x14(%ebp),%eax
  803f39:	d3 e2                	shl    %cl,%edx
  803f3b:	89 c1                	mov    %eax,%ecx
  803f3d:	d3 ee                	shr    %cl,%esi
  803f3f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f43:	09 d6                	or     %edx,%esi
  803f45:	89 fa                	mov    %edi,%edx
  803f47:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  803f4a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803f4d:	d3 e6                	shl    %cl,%esi
  803f4f:	89 c1                	mov    %eax,%ecx
  803f51:	d3 ea                	shr    %cl,%edx
  803f53:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f57:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803f5a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  803f5d:	d3 e7                	shl    %cl,%edi
  803f5f:	89 c1                	mov    %eax,%ecx
  803f61:	d3 ee                	shr    %cl,%esi
  803f63:	09 fe                	or     %edi,%esi
  803f65:	89 f0                	mov    %esi,%eax
  803f67:	f7 75 e4             	divl   -0x1c(%ebp)
  803f6a:	89 d7                	mov    %edx,%edi
  803f6c:	89 c6                	mov    %eax,%esi
  803f6e:	f7 65 f0             	mull   -0x10(%ebp)
  803f71:	39 d7                	cmp    %edx,%edi
  803f73:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  803f76:	72 12                	jb     803f8a <__udivdi3+0xfa>
  803f78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f7b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803f7f:	d3 e2                	shl    %cl,%edx
  803f81:	39 c2                	cmp    %eax,%edx
  803f83:	73 08                	jae    803f8d <__udivdi3+0xfd>
  803f85:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  803f88:	75 03                	jne    803f8d <__udivdi3+0xfd>
  803f8a:	83 ee 01             	sub    $0x1,%esi
  803f8d:	31 d2                	xor    %edx,%edx
  803f8f:	e9 3d ff ff ff       	jmp    803ed1 <__udivdi3+0x41>
	...

00803fa0 <__umoddi3>:
  803fa0:	55                   	push   %ebp
  803fa1:	89 e5                	mov    %esp,%ebp
  803fa3:	57                   	push   %edi
  803fa4:	56                   	push   %esi
  803fa5:	83 ec 20             	sub    $0x20,%esp
  803fa8:	8b 7d 14             	mov    0x14(%ebp),%edi
  803fab:	8b 45 08             	mov    0x8(%ebp),%eax
  803fae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803fb1:	8b 75 0c             	mov    0xc(%ebp),%esi
  803fb4:	85 ff                	test   %edi,%edi
  803fb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803fb9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  803fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803fbf:	89 f2                	mov    %esi,%edx
  803fc1:	75 15                	jne    803fd8 <__umoddi3+0x38>
  803fc3:	39 f1                	cmp    %esi,%ecx
  803fc5:	76 41                	jbe    804008 <__umoddi3+0x68>
  803fc7:	f7 f1                	div    %ecx
  803fc9:	89 d0                	mov    %edx,%eax
  803fcb:	31 d2                	xor    %edx,%edx
  803fcd:	83 c4 20             	add    $0x20,%esp
  803fd0:	5e                   	pop    %esi
  803fd1:	5f                   	pop    %edi
  803fd2:	5d                   	pop    %ebp
  803fd3:	c3                   	ret    
  803fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803fd8:	39 f7                	cmp    %esi,%edi
  803fda:	77 4c                	ja     804028 <__umoddi3+0x88>
  803fdc:	0f bd c7             	bsr    %edi,%eax
  803fdf:	83 f0 1f             	xor    $0x1f,%eax
  803fe2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803fe5:	75 51                	jne    804038 <__umoddi3+0x98>
  803fe7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  803fea:	0f 87 e8 00 00 00    	ja     8040d8 <__umoddi3+0x138>
  803ff0:	89 f2                	mov    %esi,%edx
  803ff2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  803ff5:	29 ce                	sub    %ecx,%esi
  803ff7:	19 fa                	sbb    %edi,%edx
  803ff9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fff:	83 c4 20             	add    $0x20,%esp
  804002:	5e                   	pop    %esi
  804003:	5f                   	pop    %edi
  804004:	5d                   	pop    %ebp
  804005:	c3                   	ret    
  804006:	66 90                	xchg   %ax,%ax
  804008:	85 c9                	test   %ecx,%ecx
  80400a:	75 0b                	jne    804017 <__umoddi3+0x77>
  80400c:	b8 01 00 00 00       	mov    $0x1,%eax
  804011:	31 d2                	xor    %edx,%edx
  804013:	f7 f1                	div    %ecx
  804015:	89 c1                	mov    %eax,%ecx
  804017:	89 f0                	mov    %esi,%eax
  804019:	31 d2                	xor    %edx,%edx
  80401b:	f7 f1                	div    %ecx
  80401d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804020:	eb a5                	jmp    803fc7 <__umoddi3+0x27>
  804022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804028:	89 f2                	mov    %esi,%edx
  80402a:	83 c4 20             	add    $0x20,%esp
  80402d:	5e                   	pop    %esi
  80402e:	5f                   	pop    %edi
  80402f:	5d                   	pop    %ebp
  804030:	c3                   	ret    
  804031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804038:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80403c:	89 f2                	mov    %esi,%edx
  80403e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804041:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804048:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80404b:	d3 e7                	shl    %cl,%edi
  80404d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804050:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804054:	d3 e8                	shr    %cl,%eax
  804056:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80405a:	09 f8                	or     %edi,%eax
  80405c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80405f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804062:	d3 e0                	shl    %cl,%eax
  804064:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80406b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80406e:	d3 ea                	shr    %cl,%edx
  804070:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804074:	d3 e6                	shl    %cl,%esi
  804076:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80407a:	d3 e8                	shr    %cl,%eax
  80407c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804080:	09 f0                	or     %esi,%eax
  804082:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804085:	f7 75 e4             	divl   -0x1c(%ebp)
  804088:	d3 e6                	shl    %cl,%esi
  80408a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80408d:	89 d6                	mov    %edx,%esi
  80408f:	f7 65 f4             	mull   -0xc(%ebp)
  804092:	89 d7                	mov    %edx,%edi
  804094:	89 c2                	mov    %eax,%edx
  804096:	39 fe                	cmp    %edi,%esi
  804098:	89 f9                	mov    %edi,%ecx
  80409a:	72 30                	jb     8040cc <__umoddi3+0x12c>
  80409c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80409f:	72 27                	jb     8040c8 <__umoddi3+0x128>
  8040a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040a4:	29 d0                	sub    %edx,%eax
  8040a6:	19 ce                	sbb    %ecx,%esi
  8040a8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8040ac:	89 f2                	mov    %esi,%edx
  8040ae:	d3 e8                	shr    %cl,%eax
  8040b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8040b4:	d3 e2                	shl    %cl,%edx
  8040b6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8040ba:	09 d0                	or     %edx,%eax
  8040bc:	89 f2                	mov    %esi,%edx
  8040be:	d3 ea                	shr    %cl,%edx
  8040c0:	83 c4 20             	add    $0x20,%esp
  8040c3:	5e                   	pop    %esi
  8040c4:	5f                   	pop    %edi
  8040c5:	5d                   	pop    %ebp
  8040c6:	c3                   	ret    
  8040c7:	90                   	nop
  8040c8:	39 fe                	cmp    %edi,%esi
  8040ca:	75 d5                	jne    8040a1 <__umoddi3+0x101>
  8040cc:	89 f9                	mov    %edi,%ecx
  8040ce:	89 c2                	mov    %eax,%edx
  8040d0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  8040d3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8040d6:	eb c9                	jmp    8040a1 <__umoddi3+0x101>
  8040d8:	39 f7                	cmp    %esi,%edi
  8040da:	0f 82 10 ff ff ff    	jb     803ff0 <__umoddi3+0x50>
  8040e0:	e9 17 ff ff ff       	jmp    803ffc <__umoddi3+0x5c>
