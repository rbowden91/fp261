
obj/user/testtime:     file format elf32-i386


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
  80002c:	e8 e7 00 00 00       	call   800118 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <_Z5sleepi>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	unsigned now = sys_time_msec();
  800047:	e8 d2 10 00 00       	call   80111e <_Z13sys_time_msecv>
	unsigned end = now + sec * 1000;

	if ((int)now < 0 && (int)now > -MAXERROR)
  80004c:	89 c2                	mov    %eax,%edx
  80004e:	c1 ea 1f             	shr    $0x1f,%edx
  800051:	84 d2                	test   %dl,%dl
  800053:	74 25                	je     80007a <_Z5sleepi+0x3a>
  800055:	83 f8 ed             	cmp    $0xffffffed,%eax
  800058:	7c 20                	jl     80007a <_Z5sleepi+0x3a>
		panic("sys_time_msec: %e", (int)now);
  80005a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005e:	c7 44 24 08 20 3f 80 	movl   $0x803f20,0x8(%esp)
  800065:	00 
  800066:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  80006d:	00 
  80006e:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  800075:	e8 22 01 00 00       	call   80019c <_Z6_panicPKciS0_z>

void
sleep(int sec)
{
	unsigned now = sys_time_msec();
	unsigned end = now + sec * 1000;
  80007a:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800081:	01 c3                	add    %eax,%ebx
  800083:	73 21                	jae    8000a6 <_Z5sleepi+0x66>
		panic("sleep: wrap");
  800085:	c7 44 24 08 42 3f 80 	movl   $0x803f42,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 32 3f 80 00 	movl   $0x803f32,(%esp)
  80009c:	e8 fb 00 00 00       	call   80019c <_Z6_panicPKciS0_z>

	while (sys_time_msec() < end)
		sys_yield();
  8000a1:	e8 e6 0c 00 00       	call   800d8c <_Z9sys_yieldv>
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000a6:	e8 73 10 00 00       	call   80111e <_Z13sys_time_msecv>
  8000ab:	39 c3                	cmp    %eax,%ebx
  8000ad:	8d 76 00             	lea    0x0(%esi),%esi
  8000b0:	77 ef                	ja     8000a1 <_Z5sleepi+0x61>
		sys_yield();
}
  8000b2:	83 c4 14             	add    $0x14,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <_Z5umainiPPc>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	53                   	push   %ebx
  8000bc:	83 ec 14             	sub    $0x14,%esp
  8000bf:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  8000c4:	e8 c3 0c 00 00       	call   800d8c <_Z9sys_yieldv>
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  8000c9:	83 eb 01             	sub    $0x1,%ebx
  8000cc:	75 f6                	jne    8000c4 <_Z5umainiPPc+0xc>
		sys_yield();

	cprintf("starting count down: ");
  8000ce:	c7 04 24 4e 3f 80 00 	movl   $0x803f4e,(%esp)
  8000d5:	e8 e0 01 00 00       	call   8002ba <_Z7cprintfPKcz>
	for (i = 5; i >= 0; i--) {
  8000da:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e3:	c7 04 24 64 3f 80 00 	movl   $0x803f64,(%esp)
  8000ea:	e8 cb 01 00 00       	call   8002ba <_Z7cprintfPKcz>
		sleep(1);
  8000ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000f6:	e8 45 ff ff ff       	call   800040 <_Z5sleepi>
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  8000fb:	83 eb 01             	sub    $0x1,%ebx
  8000fe:	83 fb ff             	cmp    $0xffffffff,%ebx
  800101:	75 dc                	jne    8000df <_Z5umainiPPc+0x27>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  800103:	c7 04 24 43 49 80 00 	movl   $0x804943,(%esp)
  80010a:	e8 ab 01 00 00       	call   8002ba <_Z7cprintfPKcz>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  80010f:	cc                   	int3   
	breakpoint();
}
  800110:	83 c4 14             	add    $0x14,%esp
  800113:	5b                   	pop    %ebx
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    
	...

00800118 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 1c             	sub    $0x1c,%esp
  800121:	8b 7d 08             	mov    0x8(%ebp),%edi
  800124:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800127:	e8 2c 0c 00 00       	call   800d58 <_Z12sys_getenvidv>
  80012c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800131:	6b c0 78             	imul   $0x78,%eax,%eax
  800134:	05 00 00 00 ef       	add    $0xef000000,%eax
  800139:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013e:	85 ff                	test   %edi,%edi
  800140:	7e 07                	jle    800149 <libmain+0x31>
		binaryname = argv[0];
  800142:	8b 06                	mov    (%esi),%eax
  800144:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800149:	b8 a1 4a 80 00       	mov    $0x804aa1,%eax
  80014e:	3d a1 4a 80 00       	cmp    $0x804aa1,%eax
  800153:	76 0f                	jbe    800164 <libmain+0x4c>
  800155:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800157:	83 eb 04             	sub    $0x4,%ebx
  80015a:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80015c:	81 fb a1 4a 80 00    	cmp    $0x804aa1,%ebx
  800162:	77 f3                	ja     800157 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800164:	89 74 24 04          	mov    %esi,0x4(%esp)
  800168:	89 3c 24             	mov    %edi,(%esp)
  80016b:	e8 48 ff ff ff       	call   8000b8 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800170:	e8 0b 00 00 00       	call   800180 <_Z4exitv>
}
  800175:	83 c4 1c             	add    $0x1c,%esp
  800178:	5b                   	pop    %ebx
  800179:	5e                   	pop    %esi
  80017a:	5f                   	pop    %edi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    
  80017d:	00 00                	add    %al,(%eax)
	...

00800180 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800186:	e8 33 13 00 00       	call   8014be <_Z9close_allv>
	sys_env_destroy(0);
  80018b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800192:	e8 64 0b 00 00       	call   800cfb <_Z15sys_env_destroyi>
}
  800197:	c9                   	leave  
  800198:	c3                   	ret    
  800199:	00 00                	add    %al,(%eax)
	...

0080019c <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	56                   	push   %esi
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001a4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  8001a7:	a1 04 60 80 00       	mov    0x806004,%eax
  8001ac:	85 c0                	test   %eax,%eax
  8001ae:	74 10                	je     8001c0 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  8001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b4:	c7 04 24 72 3f 80 00 	movl   $0x803f72,(%esp)
  8001bb:	e8 fa 00 00 00       	call   8002ba <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  8001c0:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  8001c6:	e8 8d 0b 00 00       	call   800d58 <_Z12sys_getenvidv>
  8001cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ce:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e1:	c7 04 24 78 3f 80 00 	movl   $0x803f78,(%esp)
  8001e8:	e8 cd 00 00 00       	call   8002ba <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8001ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 5d 00 00 00       	call   800259 <_Z8vcprintfPKcPc>
	cprintf("\n");
  8001fc:	c7 04 24 43 49 80 00 	movl   $0x804943,(%esp)
  800203:	e8 b2 00 00 00       	call   8002ba <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800208:	cc                   	int3   
  800209:	eb fd                	jmp    800208 <_Z6_panicPKciS0_z+0x6c>
	...

0080020c <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	83 ec 18             	sub    $0x18,%esp
  800212:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800215:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800218:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  80021b:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  80021d:	8b 03                	mov    (%ebx),%eax
  80021f:	8b 55 08             	mov    0x8(%ebp),%edx
  800222:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800226:	83 c0 01             	add    $0x1,%eax
  800229:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80022b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800230:	75 19                	jne    80024b <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  800232:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800239:	00 
  80023a:	8d 43 08             	lea    0x8(%ebx),%eax
  80023d:	89 04 24             	mov    %eax,(%esp)
  800240:	e8 4f 0a 00 00       	call   800c94 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800245:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80024b:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80024f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800252:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800255:	89 ec                	mov    %ebp,%esp
  800257:	5d                   	pop    %ebp
  800258:	c3                   	ret    

00800259 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800262:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800269:	00 00 00 
	b.cnt = 0;
  80026c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800273:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800276:	8b 45 0c             	mov    0xc(%ebp),%eax
  800279:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80027d:	8b 45 08             	mov    0x8(%ebp),%eax
  800280:	89 44 24 08          	mov    %eax,0x8(%esp)
  800284:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028e:	c7 04 24 0c 02 80 00 	movl   $0x80020c,(%esp)
  800295:	e8 ad 01 00 00       	call   800447 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80029a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002aa:	89 04 24             	mov    %eax,(%esp)
  8002ad:	e8 e2 09 00 00       	call   800c94 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  8002b2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	89 04 24             	mov    %eax,(%esp)
  8002cd:	e8 87 ff ff ff       	call   800259 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  8002d2:	c9                   	leave  
  8002d3:	c3                   	ret    
	...

008002e0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 4c             	sub    $0x4c,%esp
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	89 d6                	mov    %edx,%esi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002fd:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800300:	b8 00 00 00 00       	mov    $0x0,%eax
  800305:	39 d0                	cmp    %edx,%eax
  800307:	72 11                	jb     80031a <_ZL8printnumPFviPvES_yjii+0x3a>
  800309:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80030c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80030f:	76 09                	jbe    80031a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800311:	83 eb 01             	sub    $0x1,%ebx
  800314:	85 db                	test   %ebx,%ebx
  800316:	7f 5d                	jg     800375 <_ZL8printnumPFviPvES_yjii+0x95>
  800318:	eb 6c                	jmp    800386 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80031a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80031e:	83 eb 01             	sub    $0x1,%ebx
  800321:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800325:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800328:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80032c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800330:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800334:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800337:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80033a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800341:	00 
  800342:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800345:	89 14 24             	mov    %edx,(%esp)
  800348:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80034b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80034f:	e8 5c 39 00 00       	call   803cb0 <__udivdi3>
  800354:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800357:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80035a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80035e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800362:	89 04 24             	mov    %eax,(%esp)
  800365:	89 54 24 04          	mov    %edx,0x4(%esp)
  800369:	89 f2                	mov    %esi,%edx
  80036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80036e:	e8 6d ff ff ff       	call   8002e0 <_ZL8printnumPFviPvES_yjii>
  800373:	eb 11                	jmp    800386 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800375:	89 74 24 04          	mov    %esi,0x4(%esp)
  800379:	89 3c 24             	mov    %edi,(%esp)
  80037c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80037f:	83 eb 01             	sub    $0x1,%ebx
  800382:	85 db                	test   %ebx,%ebx
  800384:	7f ef                	jg     800375 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800386:	89 74 24 04          	mov    %esi,0x4(%esp)
  80038a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80038e:	8b 45 10             	mov    0x10(%ebp),%eax
  800391:	89 44 24 08          	mov    %eax,0x8(%esp)
  800395:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80039c:	00 
  80039d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003a0:	89 14 24             	mov    %edx,(%esp)
  8003a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003aa:	e8 11 3a 00 00       	call   803dc0 <__umoddi3>
  8003af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b3:	0f be 80 9b 3f 80 00 	movsbl 0x803f9b(%eax),%eax
  8003ba:	89 04 24             	mov    %eax,(%esp)
  8003bd:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003c0:	83 c4 4c             	add    $0x4c,%esp
  8003c3:	5b                   	pop    %ebx
  8003c4:	5e                   	pop    %esi
  8003c5:	5f                   	pop    %edi
  8003c6:	5d                   	pop    %ebp
  8003c7:	c3                   	ret    

008003c8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003cb:	83 fa 01             	cmp    $0x1,%edx
  8003ce:	7e 0e                	jle    8003de <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  8003d0:	8b 10                	mov    (%eax),%edx
  8003d2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003d5:	89 08                	mov    %ecx,(%eax)
  8003d7:	8b 02                	mov    (%edx),%eax
  8003d9:	8b 52 04             	mov    0x4(%edx),%edx
  8003dc:	eb 22                	jmp    800400 <_ZL7getuintPPci+0x38>
	else if (lflag)
  8003de:	85 d2                	test   %edx,%edx
  8003e0:	74 10                	je     8003f2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  8003e2:	8b 10                	mov    (%eax),%edx
  8003e4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003e7:	89 08                	mov    %ecx,(%eax)
  8003e9:	8b 02                	mov    (%edx),%eax
  8003eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f0:	eb 0e                	jmp    800400 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003f2:	8b 10                	mov    (%eax),%edx
  8003f4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f7:	89 08                	mov    %ecx,(%eax)
  8003f9:	8b 02                	mov    (%edx),%eax
  8003fb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800400:	5d                   	pop    %ebp
  800401:	c3                   	ret    

00800402 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800408:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80040c:	8b 10                	mov    (%eax),%edx
  80040e:	3b 50 04             	cmp    0x4(%eax),%edx
  800411:	73 0a                	jae    80041d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800413:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800416:	88 0a                	mov    %cl,(%edx)
  800418:	83 c2 01             	add    $0x1,%edx
  80041b:	89 10                	mov    %edx,(%eax)
}
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800425:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800428:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80042c:	8b 45 10             	mov    0x10(%ebp),%eax
  80042f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	89 04 24             	mov    %eax,(%esp)
  800440:	e8 02 00 00 00       	call   800447 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800445:	c9                   	leave  
  800446:	c3                   	ret    

00800447 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	57                   	push   %edi
  80044b:	56                   	push   %esi
  80044c:	53                   	push   %ebx
  80044d:	83 ec 3c             	sub    $0x3c,%esp
  800450:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800453:	8b 55 10             	mov    0x10(%ebp),%edx
  800456:	0f b6 02             	movzbl (%edx),%eax
  800459:	89 d3                	mov    %edx,%ebx
  80045b:	83 c3 01             	add    $0x1,%ebx
  80045e:	83 f8 25             	cmp    $0x25,%eax
  800461:	74 2b                	je     80048e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800463:	85 c0                	test   %eax,%eax
  800465:	75 10                	jne    800477 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800467:	e9 a5 03 00 00       	jmp    800811 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80046c:	85 c0                	test   %eax,%eax
  80046e:	66 90                	xchg   %ax,%ax
  800470:	75 08                	jne    80047a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800472:	e9 9a 03 00 00       	jmp    800811 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800477:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80047a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047e:	89 04 24             	mov    %eax,(%esp)
  800481:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800483:	0f b6 03             	movzbl (%ebx),%eax
  800486:	83 c3 01             	add    $0x1,%ebx
  800489:	83 f8 25             	cmp    $0x25,%eax
  80048c:	75 de                	jne    80046c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80048e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800492:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800499:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80049e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004aa:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004ad:	eb 2b                	jmp    8004da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004af:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  8004b2:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8004b6:	eb 22                	jmp    8004da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004bb:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8004bf:	eb 19                	jmp    8004da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8004c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004cb:	eb 0d                	jmp    8004da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004cd:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8004d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	0f b6 03             	movzbl (%ebx),%eax
  8004dd:	0f b6 d0             	movzbl %al,%edx
  8004e0:	8d 73 01             	lea    0x1(%ebx),%esi
  8004e3:	89 75 10             	mov    %esi,0x10(%ebp)
  8004e6:	83 e8 23             	sub    $0x23,%eax
  8004e9:	3c 55                	cmp    $0x55,%al
  8004eb:	0f 87 d8 02 00 00    	ja     8007c9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  8004f1:	0f b6 c0             	movzbl %al,%eax
  8004f4:	ff 24 85 40 41 80 00 	jmp    *0x804140(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004fb:	83 ea 30             	sub    $0x30,%edx
  8004fe:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800501:	8b 55 10             	mov    0x10(%ebp),%edx
  800504:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800507:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80050d:	83 fa 09             	cmp    $0x9,%edx
  800510:	77 4e                	ja     800560 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800512:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800515:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800518:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80051b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80051f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800522:	8d 50 d0             	lea    -0x30(%eax),%edx
  800525:	83 fa 09             	cmp    $0x9,%edx
  800528:	76 eb                	jbe    800515 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80052a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80052d:	eb 31                	jmp    800560 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8d 50 04             	lea    0x4(%eax),%edx
  800535:	89 55 14             	mov    %edx,0x14(%ebp)
  800538:	8b 00                	mov    (%eax),%eax
  80053a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800540:	eb 1e                	jmp    800560 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800542:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800546:	0f 88 75 ff ff ff    	js     8004c1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80054f:	eb 89                	jmp    8004da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800551:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800554:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80055b:	e9 7a ff ff ff       	jmp    8004da <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800560:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800564:	0f 89 70 ff ff ff    	jns    8004da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80056a:	e9 5e ff ff ff       	jmp    8004cd <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80056f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800572:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800575:	e9 60 ff ff ff       	jmp    8004da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8d 50 04             	lea    0x4(%eax),%edx
  800580:	89 55 14             	mov    %edx,0x14(%ebp)
  800583:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800587:	8b 00                	mov    (%eax),%eax
  800589:	89 04 24             	mov    %eax,(%esp)
  80058c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80058f:	e9 bf fe ff ff       	jmp    800453 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 50 04             	lea    0x4(%eax),%edx
  80059a:	89 55 14             	mov    %edx,0x14(%ebp)
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 c2                	mov    %eax,%edx
  8005a1:	c1 fa 1f             	sar    $0x1f,%edx
  8005a4:	31 d0                	xor    %edx,%eax
  8005a6:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005a8:	83 f8 14             	cmp    $0x14,%eax
  8005ab:	7f 0f                	jg     8005bc <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  8005ad:	8b 14 85 a0 42 80 00 	mov    0x8042a0(,%eax,4),%edx
  8005b4:	85 d2                	test   %edx,%edx
  8005b6:	0f 85 35 02 00 00    	jne    8007f1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  8005bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005c0:	c7 44 24 08 b3 3f 80 	movl   $0x803fb3,0x8(%esp)
  8005c7:	00 
  8005c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8005cf:	89 34 24             	mov    %esi,(%esp)
  8005d2:	e8 48 fe ff ff       	call   80041f <_Z8printfmtPFviPvES_PKcz>
  8005d7:	e9 77 fe ff ff       	jmp    800453 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8005dc:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 50 04             	lea    0x4(%eax),%edx
  8005eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ee:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  8005f0:	85 db                	test   %ebx,%ebx
  8005f2:	ba ac 3f 80 00       	mov    $0x803fac,%edx
  8005f7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  8005fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fe:	7e 72                	jle    800672 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800600:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800604:	74 6c                	je     800672 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800606:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060a:	89 1c 24             	mov    %ebx,(%esp)
  80060d:	e8 a9 02 00 00       	call   8008bb <_Z7strnlenPKcj>
  800612:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800615:	29 c2                	sub    %eax,%edx
  800617:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80061a:	85 d2                	test   %edx,%edx
  80061c:	7e 54                	jle    800672 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80061e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800622:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800625:	89 d3                	mov    %edx,%ebx
  800627:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80062a:	89 c6                	mov    %eax,%esi
  80062c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800630:	89 34 24             	mov    %esi,(%esp)
  800633:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800636:	83 eb 01             	sub    $0x1,%ebx
  800639:	85 db                	test   %ebx,%ebx
  80063b:	7f ef                	jg     80062c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80063d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800640:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800643:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80064a:	eb 26                	jmp    800672 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80064c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80064f:	83 fa 5e             	cmp    $0x5e,%edx
  800652:	76 10                	jbe    800664 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800654:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800658:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80065f:	ff 55 08             	call   *0x8(%ebp)
  800662:	eb 0a                	jmp    80066e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800664:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800668:	89 04 24             	mov    %eax,(%esp)
  80066b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800672:	0f be 03             	movsbl (%ebx),%eax
  800675:	83 c3 01             	add    $0x1,%ebx
  800678:	85 c0                	test   %eax,%eax
  80067a:	74 11                	je     80068d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80067c:	85 f6                	test   %esi,%esi
  80067e:	78 05                	js     800685 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800680:	83 ee 01             	sub    $0x1,%esi
  800683:	78 0d                	js     800692 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800685:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800689:	75 c1                	jne    80064c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80068b:	eb d7                	jmp    800664 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800690:	eb 03                	jmp    800695 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800695:	85 c0                	test   %eax,%eax
  800697:	0f 8e b6 fd ff ff    	jle    800453 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80069d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8006a0:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  8006a3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006ae:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b0:	83 eb 01             	sub    $0x1,%ebx
  8006b3:	85 db                	test   %ebx,%ebx
  8006b5:	7f ec                	jg     8006a3 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  8006b7:	e9 97 fd ff ff       	jmp    800453 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006bc:	83 f9 01             	cmp    $0x1,%ecx
  8006bf:	90                   	nop
  8006c0:	7e 10                	jle    8006d2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 50 08             	lea    0x8(%eax),%edx
  8006c8:	89 55 14             	mov    %edx,0x14(%ebp)
  8006cb:	8b 18                	mov    (%eax),%ebx
  8006cd:	8b 70 04             	mov    0x4(%eax),%esi
  8006d0:	eb 26                	jmp    8006f8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  8006d2:	85 c9                	test   %ecx,%ecx
  8006d4:	74 12                	je     8006e8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 50 04             	lea    0x4(%eax),%edx
  8006dc:	89 55 14             	mov    %edx,0x14(%ebp)
  8006df:	8b 18                	mov    (%eax),%ebx
  8006e1:	89 de                	mov    %ebx,%esi
  8006e3:	c1 fe 1f             	sar    $0x1f,%esi
  8006e6:	eb 10                	jmp    8006f8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ee:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f1:	8b 18                	mov    (%eax),%ebx
  8006f3:	89 de                	mov    %ebx,%esi
  8006f5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006f8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006fd:	85 f6                	test   %esi,%esi
  8006ff:	0f 89 8c 00 00 00    	jns    800791 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800705:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800709:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800710:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800713:	f7 db                	neg    %ebx
  800715:	83 d6 00             	adc    $0x0,%esi
  800718:	f7 de                	neg    %esi
			}
			base = 10;
  80071a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071f:	eb 70                	jmp    800791 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800721:	89 ca                	mov    %ecx,%edx
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
  800726:	e8 9d fc ff ff       	call   8003c8 <_ZL7getuintPPci>
  80072b:	89 c3                	mov    %eax,%ebx
  80072d:	89 d6                	mov    %edx,%esi
			base = 10;
  80072f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800734:	eb 5b                	jmp    800791 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800736:	89 ca                	mov    %ecx,%edx
  800738:	8d 45 14             	lea    0x14(%ebp),%eax
  80073b:	e8 88 fc ff ff       	call   8003c8 <_ZL7getuintPPci>
  800740:	89 c3                	mov    %eax,%ebx
  800742:	89 d6                	mov    %edx,%esi
			base = 8;
  800744:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800749:	eb 46                	jmp    800791 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80074b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800756:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800759:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800764:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 50 04             	lea    0x4(%eax),%edx
  80076d:	89 55 14             	mov    %edx,0x14(%ebp)
  800770:	8b 18                	mov    (%eax),%ebx
  800772:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800777:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80077c:	eb 13                	jmp    800791 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80077e:	89 ca                	mov    %ecx,%edx
  800780:	8d 45 14             	lea    0x14(%ebp),%eax
  800783:	e8 40 fc ff ff       	call   8003c8 <_ZL7getuintPPci>
  800788:	89 c3                	mov    %eax,%ebx
  80078a:	89 d6                	mov    %edx,%esi
			base = 16;
  80078c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800791:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800795:	89 54 24 10          	mov    %edx,0x10(%esp)
  800799:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80079c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007a4:	89 1c 24             	mov    %ebx,(%esp)
  8007a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ab:	89 fa                	mov    %edi,%edx
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	e8 2b fb ff ff       	call   8002e0 <_ZL8printnumPFviPvES_yjii>
			break;
  8007b5:	e9 99 fc ff ff       	jmp    800453 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007be:	89 14 24             	mov    %edx,(%esp)
  8007c1:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007c4:	e9 8a fc ff ff       	jmp    800453 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007cd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007d4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007d7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007da:	89 d8                	mov    %ebx,%eax
  8007dc:	eb 02                	jmp    8007e0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  8007de:	89 d0                	mov    %edx,%eax
  8007e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8007e3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007e7:	75 f5                	jne    8007de <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  8007e9:	89 45 10             	mov    %eax,0x10(%ebp)
  8007ec:	e9 62 fc ff ff       	jmp    800453 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007f5:	c7 44 24 08 3e 43 80 	movl   $0x80433e,0x8(%esp)
  8007fc:	00 
  8007fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800801:	8b 75 08             	mov    0x8(%ebp),%esi
  800804:	89 34 24             	mov    %esi,(%esp)
  800807:	e8 13 fc ff ff       	call   80041f <_Z8printfmtPFviPvES_PKcz>
  80080c:	e9 42 fc ff ff       	jmp    800453 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800811:	83 c4 3c             	add    $0x3c,%esp
  800814:	5b                   	pop    %ebx
  800815:	5e                   	pop    %esi
  800816:	5f                   	pop    %edi
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	83 ec 28             	sub    $0x28,%esp
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800825:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80082c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80082f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800833:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800836:	85 c0                	test   %eax,%eax
  800838:	74 30                	je     80086a <_Z9vsnprintfPciPKcS_+0x51>
  80083a:	85 d2                	test   %edx,%edx
  80083c:	7e 2c                	jle    80086a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800845:	8b 45 10             	mov    0x10(%ebp),%eax
  800848:	89 44 24 08          	mov    %eax,0x8(%esp)
  80084c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80084f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800853:	c7 04 24 02 04 80 00 	movl   $0x800402,(%esp)
  80085a:	e8 e8 fb ff ff       	call   800447 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80085f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800862:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800868:	eb 05                	jmp    80086f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80086a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80086f:	c9                   	leave  
  800870:	c3                   	ret    

00800871 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800877:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80087a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	89 44 24 08          	mov    %eax,0x8(%esp)
  800885:	8b 45 0c             	mov    0xc(%ebp),%eax
  800888:	89 44 24 04          	mov    %eax,0x4(%esp)
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	89 04 24             	mov    %eax,(%esp)
  800892:	e8 82 ff ff ff       	call   800819 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800897:	c9                   	leave  
  800898:	c3                   	ret    
  800899:	00 00                	add    %al,(%eax)
  80089b:	00 00                	add    %al,(%eax)
  80089d:	00 00                	add    %al,(%eax)
	...

008008a0 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	80 3a 00             	cmpb   $0x0,(%edx)
  8008ae:	74 09                	je     8008b9 <_Z6strlenPKc+0x19>
		n++;
  8008b0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b7:	75 f7                	jne    8008b0 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 0b                	je     8008d8 <_Z7strnlenPKcj+0x1d>
  8008cd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d1:	74 05                	je     8008d8 <_Z7strnlenPKcj+0x1d>
		n++;
  8008d3:	83 c0 01             	add    $0x1,%eax
  8008d6:	eb f1                	jmp    8008c9 <_Z7strnlenPKcj+0xe>
	return n;
}
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	53                   	push   %ebx
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  8008e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	84 c9                	test   %cl,%cl
  8008f5:	75 f2                	jne    8008e9 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  8008f7:	5b                   	pop    %ebx
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	56                   	push   %esi
  8008fe:	53                   	push   %ebx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 55 0c             	mov    0xc(%ebp),%edx
  800905:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800908:	85 f6                	test   %esi,%esi
  80090a:	74 18                	je     800924 <_Z7strncpyPcPKcj+0x2a>
  80090c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800911:	0f b6 1a             	movzbl (%edx),%ebx
  800914:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800917:	80 3a 01             	cmpb   $0x1,(%edx)
  80091a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  80091d:	83 c1 01             	add    $0x1,%ecx
  800920:	39 ce                	cmp    %ecx,%esi
  800922:	77 ed                	ja     800911 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800924:	5b                   	pop    %ebx
  800925:	5e                   	pop    %esi
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	8b 75 08             	mov    0x8(%ebp),%esi
  800930:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800933:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800936:	89 f0                	mov    %esi,%eax
  800938:	85 d2                	test   %edx,%edx
  80093a:	74 17                	je     800953 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  80093c:	83 ea 01             	sub    $0x1,%edx
  80093f:	74 18                	je     800959 <_Z7strlcpyPcPKcj+0x31>
  800941:	80 39 00             	cmpb   $0x0,(%ecx)
  800944:	74 17                	je     80095d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800946:	0f b6 19             	movzbl (%ecx),%ebx
  800949:	88 18                	mov    %bl,(%eax)
  80094b:	83 c0 01             	add    $0x1,%eax
  80094e:	83 c1 01             	add    $0x1,%ecx
  800951:	eb e9                	jmp    80093c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800953:	29 f0                	sub    %esi,%eax
}
  800955:	5b                   	pop    %ebx
  800956:	5e                   	pop    %esi
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800959:	89 c2                	mov    %eax,%edx
  80095b:	eb 02                	jmp    80095f <_Z7strlcpyPcPKcj+0x37>
  80095d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  80095f:	c6 02 00             	movb   $0x0,(%edx)
  800962:	eb ef                	jmp    800953 <_Z7strlcpyPcPKcj+0x2b>

00800964 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80096d:	0f b6 01             	movzbl (%ecx),%eax
  800970:	84 c0                	test   %al,%al
  800972:	74 0c                	je     800980 <_Z6strcmpPKcS0_+0x1c>
  800974:	3a 02                	cmp    (%edx),%al
  800976:	75 08                	jne    800980 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800978:	83 c1 01             	add    $0x1,%ecx
  80097b:	83 c2 01             	add    $0x1,%edx
  80097e:	eb ed                	jmp    80096d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800980:	0f b6 c0             	movzbl %al,%eax
  800983:	0f b6 12             	movzbl (%edx),%edx
  800986:	29 d0                	sub    %edx,%eax
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	53                   	push   %ebx
  80098e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800991:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800994:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800997:	85 d2                	test   %edx,%edx
  800999:	74 16                	je     8009b1 <_Z7strncmpPKcS0_j+0x27>
  80099b:	0f b6 01             	movzbl (%ecx),%eax
  80099e:	84 c0                	test   %al,%al
  8009a0:	74 17                	je     8009b9 <_Z7strncmpPKcS0_j+0x2f>
  8009a2:	3a 03                	cmp    (%ebx),%al
  8009a4:	75 13                	jne    8009b9 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  8009a6:	83 ea 01             	sub    $0x1,%edx
  8009a9:	83 c1 01             	add    $0x1,%ecx
  8009ac:	83 c3 01             	add    $0x1,%ebx
  8009af:	eb e6                	jmp    800997 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  8009b1:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  8009b6:	5b                   	pop    %ebx
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  8009b9:	0f b6 01             	movzbl (%ecx),%eax
  8009bc:	0f b6 13             	movzbl (%ebx),%edx
  8009bf:	29 d0                	sub    %edx,%eax
  8009c1:	eb f3                	jmp    8009b6 <_Z7strncmpPKcS0_j+0x2c>

008009c3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009cd:	0f b6 10             	movzbl (%eax),%edx
  8009d0:	84 d2                	test   %dl,%dl
  8009d2:	74 1f                	je     8009f3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  8009d4:	38 ca                	cmp    %cl,%dl
  8009d6:	75 0a                	jne    8009e2 <_Z6strchrPKcc+0x1f>
  8009d8:	eb 1e                	jmp    8009f8 <_Z6strchrPKcc+0x35>
  8009da:	38 ca                	cmp    %cl,%dl
  8009dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8009e0:	74 16                	je     8009f8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009e2:	83 c0 01             	add    $0x1,%eax
  8009e5:	0f b6 10             	movzbl (%eax),%edx
  8009e8:	84 d2                	test   %dl,%dl
  8009ea:	75 ee                	jne    8009da <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8009ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f1:	eb 05                	jmp    8009f8 <_Z6strchrPKcc+0x35>
  8009f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a04:	0f b6 10             	movzbl (%eax),%edx
  800a07:	84 d2                	test   %dl,%dl
  800a09:	74 14                	je     800a1f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800a0b:	38 ca                	cmp    %cl,%dl
  800a0d:	75 06                	jne    800a15 <_Z7strfindPKcc+0x1b>
  800a0f:	eb 0e                	jmp    800a1f <_Z7strfindPKcc+0x25>
  800a11:	38 ca                	cmp    %cl,%dl
  800a13:	74 0a                	je     800a1f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a15:	83 c0 01             	add    $0x1,%eax
  800a18:	0f b6 10             	movzbl (%eax),%edx
  800a1b:	84 d2                	test   %dl,%dl
  800a1d:	75 f2                	jne    800a11 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 0c             	sub    $0xc,%esp
  800a27:	89 1c 24             	mov    %ebx,(%esp)
  800a2a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a32:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800a3b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a41:	75 25                	jne    800a68 <memset+0x47>
  800a43:	f6 c1 03             	test   $0x3,%cl
  800a46:	75 20                	jne    800a68 <memset+0x47>
		c &= 0xFF;
  800a48:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4b:	89 d3                	mov    %edx,%ebx
  800a4d:	c1 e3 08             	shl    $0x8,%ebx
  800a50:	89 d6                	mov    %edx,%esi
  800a52:	c1 e6 18             	shl    $0x18,%esi
  800a55:	89 d0                	mov    %edx,%eax
  800a57:	c1 e0 10             	shl    $0x10,%eax
  800a5a:	09 f0                	or     %esi,%eax
  800a5c:	09 d0                	or     %edx,%eax
  800a5e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800a60:	c1 e9 02             	shr    $0x2,%ecx
  800a63:	fc                   	cld    
  800a64:	f3 ab                	rep stos %eax,%es:(%edi)
  800a66:	eb 03                	jmp    800a6b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800a68:	fc                   	cld    
  800a69:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800a6b:	89 f8                	mov    %edi,%eax
  800a6d:	8b 1c 24             	mov    (%esp),%ebx
  800a70:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a74:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a78:	89 ec                	mov    %ebp,%esp
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	89 34 24             	mov    %esi,(%esp)
  800a85:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800a92:	39 c6                	cmp    %eax,%esi
  800a94:	73 36                	jae    800acc <memmove+0x50>
  800a96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a99:	39 d0                	cmp    %edx,%eax
  800a9b:	73 2f                	jae    800acc <memmove+0x50>
		s += n;
		d += n;
  800a9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800aa0:	f6 c2 03             	test   $0x3,%dl
  800aa3:	75 1b                	jne    800ac0 <memmove+0x44>
  800aa5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aab:	75 13                	jne    800ac0 <memmove+0x44>
  800aad:	f6 c1 03             	test   $0x3,%cl
  800ab0:	75 0e                	jne    800ac0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab2:	83 ef 04             	sub    $0x4,%edi
  800ab5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab8:	c1 e9 02             	shr    $0x2,%ecx
  800abb:	fd                   	std    
  800abc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abe:	eb 09                	jmp    800ac9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ac0:	83 ef 01             	sub    $0x1,%edi
  800ac3:	8d 72 ff             	lea    -0x1(%edx),%esi
  800ac6:	fd                   	std    
  800ac7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac9:	fc                   	cld    
  800aca:	eb 20                	jmp    800aec <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800acc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad2:	75 13                	jne    800ae7 <memmove+0x6b>
  800ad4:	a8 03                	test   $0x3,%al
  800ad6:	75 0f                	jne    800ae7 <memmove+0x6b>
  800ad8:	f6 c1 03             	test   $0x3,%cl
  800adb:	75 0a                	jne    800ae7 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800add:	c1 e9 02             	shr    $0x2,%ecx
  800ae0:	89 c7                	mov    %eax,%edi
  800ae2:	fc                   	cld    
  800ae3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae5:	eb 05                	jmp    800aec <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800ae7:	89 c7                	mov    %eax,%edi
  800ae9:	fc                   	cld    
  800aea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800aec:	8b 34 24             	mov    (%esp),%esi
  800aef:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800af3:	89 ec                	mov    %ebp,%esp
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	89 34 24             	mov    %esi,(%esp)
  800b00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800b0d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b13:	75 13                	jne    800b28 <memcpy+0x31>
  800b15:	a8 03                	test   $0x3,%al
  800b17:	75 0f                	jne    800b28 <memcpy+0x31>
  800b19:	f6 c1 03             	test   $0x3,%cl
  800b1c:	75 0a                	jne    800b28 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1e:	c1 e9 02             	shr    $0x2,%ecx
  800b21:	89 c7                	mov    %eax,%edi
  800b23:	fc                   	cld    
  800b24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b26:	eb 05                	jmp    800b2d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800b28:	89 c7                	mov    %eax,%edi
  800b2a:	fc                   	cld    
  800b2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800b2d:	8b 34 24             	mov    (%esp),%esi
  800b30:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b34:	89 ec                	mov    %ebp,%esp
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	57                   	push   %edi
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
  800b3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b41:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b44:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b4c:	85 ff                	test   %edi,%edi
  800b4e:	74 38                	je     800b88 <memcmp+0x50>
		if (*s1 != *s2)
  800b50:	0f b6 03             	movzbl (%ebx),%eax
  800b53:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b56:	83 ef 01             	sub    $0x1,%edi
  800b59:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b5e:	38 c8                	cmp    %cl,%al
  800b60:	74 1d                	je     800b7f <memcmp+0x47>
  800b62:	eb 11                	jmp    800b75 <memcmp+0x3d>
  800b64:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b69:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800b6e:	83 c2 01             	add    $0x1,%edx
  800b71:	38 c8                	cmp    %cl,%al
  800b73:	74 0a                	je     800b7f <memcmp+0x47>
			return *s1 - *s2;
  800b75:	0f b6 c0             	movzbl %al,%eax
  800b78:	0f b6 c9             	movzbl %cl,%ecx
  800b7b:	29 c8                	sub    %ecx,%eax
  800b7d:	eb 09                	jmp    800b88 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b7f:	39 fa                	cmp    %edi,%edx
  800b81:	75 e1                	jne    800b64 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5f                   	pop    %edi
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	53                   	push   %ebx
  800b91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800b94:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800b96:	89 da                	mov    %ebx,%edx
  800b98:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800b9b:	39 d3                	cmp    %edx,%ebx
  800b9d:	73 15                	jae    800bb4 <memfind+0x27>
		if (*s == (unsigned char) c)
  800b9f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ba3:	38 0b                	cmp    %cl,(%ebx)
  800ba5:	75 06                	jne    800bad <memfind+0x20>
  800ba7:	eb 0b                	jmp    800bb4 <memfind+0x27>
  800ba9:	38 08                	cmp    %cl,(%eax)
  800bab:	74 07                	je     800bb4 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800bad:	83 c0 01             	add    $0x1,%eax
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	77 f5                	ja     800ba9 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bb4:	5b                   	pop    %ebx
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc3:	0f b6 02             	movzbl (%edx),%eax
  800bc6:	3c 20                	cmp    $0x20,%al
  800bc8:	74 04                	je     800bce <_Z6strtolPKcPPci+0x17>
  800bca:	3c 09                	cmp    $0x9,%al
  800bcc:	75 0e                	jne    800bdc <_Z6strtolPKcPPci+0x25>
		s++;
  800bce:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd1:	0f b6 02             	movzbl (%edx),%eax
  800bd4:	3c 20                	cmp    $0x20,%al
  800bd6:	74 f6                	je     800bce <_Z6strtolPKcPPci+0x17>
  800bd8:	3c 09                	cmp    $0x9,%al
  800bda:	74 f2                	je     800bce <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bdc:	3c 2b                	cmp    $0x2b,%al
  800bde:	75 0a                	jne    800bea <_Z6strtolPKcPPci+0x33>
		s++;
  800be0:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800be3:	bf 00 00 00 00       	mov    $0x0,%edi
  800be8:	eb 10                	jmp    800bfa <_Z6strtolPKcPPci+0x43>
  800bea:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bef:	3c 2d                	cmp    $0x2d,%al
  800bf1:	75 07                	jne    800bfa <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bfa:	85 db                	test   %ebx,%ebx
  800bfc:	0f 94 c0             	sete   %al
  800bff:	74 05                	je     800c06 <_Z6strtolPKcPPci+0x4f>
  800c01:	83 fb 10             	cmp    $0x10,%ebx
  800c04:	75 15                	jne    800c1b <_Z6strtolPKcPPci+0x64>
  800c06:	80 3a 30             	cmpb   $0x30,(%edx)
  800c09:	75 10                	jne    800c1b <_Z6strtolPKcPPci+0x64>
  800c0b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c0f:	75 0a                	jne    800c1b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800c11:	83 c2 02             	add    $0x2,%edx
  800c14:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c19:	eb 13                	jmp    800c2e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800c1b:	84 c0                	test   %al,%al
  800c1d:	74 0f                	je     800c2e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c1f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c24:	80 3a 30             	cmpb   $0x30,(%edx)
  800c27:	75 05                	jne    800c2e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800c29:	83 c2 01             	add    $0x1,%edx
  800c2c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c33:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c35:	0f b6 0a             	movzbl (%edx),%ecx
  800c38:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c3b:	80 fb 09             	cmp    $0x9,%bl
  800c3e:	77 08                	ja     800c48 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800c40:	0f be c9             	movsbl %cl,%ecx
  800c43:	83 e9 30             	sub    $0x30,%ecx
  800c46:	eb 1e                	jmp    800c66 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c48:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c4b:	80 fb 19             	cmp    $0x19,%bl
  800c4e:	77 08                	ja     800c58 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800c50:	0f be c9             	movsbl %cl,%ecx
  800c53:	83 e9 57             	sub    $0x57,%ecx
  800c56:	eb 0e                	jmp    800c66 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c58:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c5b:	80 fb 19             	cmp    $0x19,%bl
  800c5e:	77 15                	ja     800c75 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800c60:	0f be c9             	movsbl %cl,%ecx
  800c63:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c66:	39 f1                	cmp    %esi,%ecx
  800c68:	7d 0f                	jge    800c79 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800c6a:	83 c2 01             	add    $0x1,%edx
  800c6d:	0f af c6             	imul   %esi,%eax
  800c70:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800c73:	eb c0                	jmp    800c35 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c75:	89 c1                	mov    %eax,%ecx
  800c77:	eb 02                	jmp    800c7b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c79:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7f:	74 05                	je     800c86 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800c81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c84:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c86:	89 ca                	mov    %ecx,%edx
  800c88:	f7 da                	neg    %edx
  800c8a:	85 ff                	test   %edi,%edi
  800c8c:	0f 45 c2             	cmovne %edx,%eax
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 0c             	sub    $0xc,%esp
  800c9a:	89 1c 24             	mov    %ebx,(%esp)
  800c9d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ca1:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	89 c3                	mov    %eax,%ebx
  800cb2:	89 c7                	mov    %eax,%edi
  800cb4:	89 c6                	mov    %eax,%esi
  800cb6:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb8:	8b 1c 24             	mov    (%esp),%ebx
  800cbb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cbf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cc3:	89 ec                	mov    %ebp,%esp
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 0c             	sub    $0xc,%esp
  800ccd:	89 1c 24             	mov    %ebx,(%esp)
  800cd0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cd4:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800cd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdd:	b8 01 00 00 00       	mov    $0x1,%eax
  800ce2:	89 d1                	mov    %edx,%ecx
  800ce4:	89 d3                	mov    %edx,%ebx
  800ce6:	89 d7                	mov    %edx,%edi
  800ce8:	89 d6                	mov    %edx,%esi
  800cea:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cec:	8b 1c 24             	mov    (%esp),%ebx
  800cef:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cf3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cf7:	89 ec                	mov    %ebp,%esp
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	83 ec 38             	sub    $0x38,%esp
  800d01:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d04:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d07:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d0f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	89 cb                	mov    %ecx,%ebx
  800d19:	89 cf                	mov    %ecx,%edi
  800d1b:	89 ce                	mov    %ecx,%esi
  800d1d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	7e 28                	jle    800d4b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d27:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d2e:	00 
  800d2f:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  800d36:	00 
  800d37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d3e:	00 
  800d3f:	c7 04 24 11 43 80 00 	movl   $0x804311,(%esp)
  800d46:	e8 51 f4 ff ff       	call   80019c <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d4b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d4e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d51:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d54:	89 ec                	mov    %ebp,%esp
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 0c             	sub    $0xc,%esp
  800d5e:	89 1c 24             	mov    %ebx,(%esp)
  800d61:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d65:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d69:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6e:	b8 02 00 00 00       	mov    $0x2,%eax
  800d73:	89 d1                	mov    %edx,%ecx
  800d75:	89 d3                	mov    %edx,%ebx
  800d77:	89 d7                	mov    %edx,%edi
  800d79:	89 d6                	mov    %edx,%esi
  800d7b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d7d:	8b 1c 24             	mov    (%esp),%ebx
  800d80:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d84:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d88:	89 ec                	mov    %ebp,%esp
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	89 1c 24             	mov    %ebx,(%esp)
  800d95:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d99:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800da2:	b8 04 00 00 00       	mov    $0x4,%eax
  800da7:	89 d1                	mov    %edx,%ecx
  800da9:	89 d3                	mov    %edx,%ebx
  800dab:	89 d7                	mov    %edx,%edi
  800dad:	89 d6                	mov    %edx,%esi
  800daf:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800db1:	8b 1c 24             	mov    (%esp),%ebx
  800db4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800db8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dbc:	89 ec                	mov    %ebp,%esp
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 38             	sub    $0x38,%esp
  800dc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dcc:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dcf:	be 00 00 00 00       	mov    $0x0,%esi
  800dd4:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  800de2:	89 f7                	mov    %esi,%edi
  800de4:	cd 30                	int    $0x30

	if(check && ret > 0)
  800de6:	85 c0                	test   %eax,%eax
  800de8:	7e 28                	jle    800e12 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dea:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dee:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800df5:	00 
  800df6:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  800dfd:	00 
  800dfe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e05:	00 
  800e06:	c7 04 24 11 43 80 00 	movl   $0x804311,(%esp)
  800e0d:	e8 8a f3 ff ff       	call   80019c <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e12:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e15:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e18:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e1b:	89 ec                	mov    %ebp,%esp
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    

00800e1f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 38             	sub    $0x38,%esp
  800e25:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e28:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e2b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e2e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e33:	8b 75 18             	mov    0x18(%ebp),%esi
  800e36:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	7e 28                	jle    800e70 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e48:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e53:	00 
  800e54:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  800e5b:	00 
  800e5c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e63:	00 
  800e64:	c7 04 24 11 43 80 00 	movl   $0x804311,(%esp)
  800e6b:	e8 2c f3 ff ff       	call   80019c <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e70:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e73:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e76:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e79:	89 ec                	mov    %ebp,%esp
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 38             	sub    $0x38,%esp
  800e83:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e86:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e89:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	89 df                	mov    %ebx,%edi
  800e9e:	89 de                	mov    %ebx,%esi
  800ea0:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	7e 28                	jle    800ece <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eaa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800eb1:	00 
  800eb2:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  800eb9:	00 
  800eba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec1:	00 
  800ec2:	c7 04 24 11 43 80 00 	movl   $0x804311,(%esp)
  800ec9:	e8 ce f2 ff ff       	call   80019c <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ece:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ed1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ed4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ed7:	89 ec                	mov    %ebp,%esp
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 38             	sub    $0x38,%esp
  800ee1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ee7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800eea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eef:	b8 05 00 00 00       	mov    $0x5,%eax
  800ef4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  800efa:	89 df                	mov    %ebx,%edi
  800efc:	89 de                	mov    %ebx,%esi
  800efe:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f00:	85 c0                	test   %eax,%eax
  800f02:	7e 28                	jle    800f2c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f04:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f08:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f0f:	00 
  800f10:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  800f17:	00 
  800f18:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1f:	00 
  800f20:	c7 04 24 11 43 80 00 	movl   $0x804311,(%esp)
  800f27:	e8 70 f2 ff ff       	call   80019c <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f2c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f2f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f32:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f35:	89 ec                	mov    %ebp,%esp
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	83 ec 38             	sub    $0x38,%esp
  800f3f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f45:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f55:	8b 55 08             	mov    0x8(%ebp),%edx
  800f58:	89 df                	mov    %ebx,%edi
  800f5a:	89 de                	mov    %ebx,%esi
  800f5c:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	7e 28                	jle    800f8a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f62:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f66:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f6d:	00 
  800f6e:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  800f75:	00 
  800f76:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7d:	00 
  800f7e:	c7 04 24 11 43 80 00 	movl   $0x804311,(%esp)
  800f85:	e8 12 f2 ff ff       	call   80019c <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800f8a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f8d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f90:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f93:	89 ec                	mov    %ebp,%esp
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 38             	sub    $0x38,%esp
  800f9d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fa0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa3:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fa6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fab:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb6:	89 df                	mov    %ebx,%edi
  800fb8:	89 de                	mov    %ebx,%esi
  800fba:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	7e 28                	jle    800fe8 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc4:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800fcb:	00 
  800fcc:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  800fd3:	00 
  800fd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fdb:	00 
  800fdc:	c7 04 24 11 43 80 00 	movl   $0x804311,(%esp)
  800fe3:	e8 b4 f1 ff ff       	call   80019c <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fe8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800feb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ff1:	89 ec                	mov    %ebp,%esp
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 38             	sub    $0x38,%esp
  800ffb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ffe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801001:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801004:	bb 00 00 00 00       	mov    $0x0,%ebx
  801009:	b8 0c 00 00 00       	mov    $0xc,%eax
  80100e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	89 df                	mov    %ebx,%edi
  801016:	89 de                	mov    %ebx,%esi
  801018:	cd 30                	int    $0x30

	if(check && ret > 0)
  80101a:	85 c0                	test   %eax,%eax
  80101c:	7e 28                	jle    801046 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801022:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801029:	00 
  80102a:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  801031:	00 
  801032:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801039:	00 
  80103a:	c7 04 24 11 43 80 00 	movl   $0x804311,(%esp)
  801041:	e8 56 f1 ff ff       	call   80019c <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801046:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801049:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80104c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80104f:	89 ec                	mov    %ebp,%esp
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	89 1c 24             	mov    %ebx,(%esp)
  80105c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801060:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801064:	be 00 00 00 00       	mov    $0x0,%esi
  801069:	b8 0d 00 00 00       	mov    $0xd,%eax
  80106e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801071:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801074:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80107c:	8b 1c 24             	mov    (%esp),%ebx
  80107f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801083:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801087:	89 ec                	mov    %ebp,%esp
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 38             	sub    $0x38,%esp
  801091:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801094:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801097:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80109a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80109f:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a7:	89 cb                	mov    %ecx,%ebx
  8010a9:	89 cf                	mov    %ecx,%edi
  8010ab:	89 ce                	mov    %ecx,%esi
  8010ad:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	7e 28                	jle    8010db <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b7:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8010be:	00 
  8010bf:	c7 44 24 08 f4 42 80 	movl   $0x8042f4,0x8(%esp)
  8010c6:	00 
  8010c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ce:	00 
  8010cf:	c7 04 24 11 43 80 00 	movl   $0x804311,(%esp)
  8010d6:	e8 c1 f0 ff ff       	call   80019c <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010db:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010de:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010e1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010e4:	89 ec                	mov    %ebp,%esp
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    

008010e8 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
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
  8010f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fe:	b8 0f 00 00 00       	mov    $0xf,%eax
  801103:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801106:	8b 55 08             	mov    0x8(%ebp),%edx
  801109:	89 df                	mov    %ebx,%edi
  80110b:	89 de                	mov    %ebx,%esi
  80110d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80110f:	8b 1c 24             	mov    (%esp),%ebx
  801112:	8b 74 24 04          	mov    0x4(%esp),%esi
  801116:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80111a:	89 ec                	mov    %ebp,%esp
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 0c             	sub    $0xc,%esp
  801124:	89 1c 24             	mov    %ebx,(%esp)
  801127:	89 74 24 04          	mov    %esi,0x4(%esp)
  80112b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80112f:	ba 00 00 00 00       	mov    $0x0,%edx
  801134:	b8 11 00 00 00       	mov    $0x11,%eax
  801139:	89 d1                	mov    %edx,%ecx
  80113b:	89 d3                	mov    %edx,%ebx
  80113d:	89 d7                	mov    %edx,%edi
  80113f:	89 d6                	mov    %edx,%esi
  801141:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801143:	8b 1c 24             	mov    (%esp),%ebx
  801146:	8b 74 24 04          	mov    0x4(%esp),%esi
  80114a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80114e:	89 ec                	mov    %ebp,%esp
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	89 1c 24             	mov    %ebx,(%esp)
  80115b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80115f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801163:	bb 00 00 00 00       	mov    $0x0,%ebx
  801168:	b8 12 00 00 00       	mov    $0x12,%eax
  80116d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801170:	8b 55 08             	mov    0x8(%ebp),%edx
  801173:	89 df                	mov    %ebx,%edi
  801175:	89 de                	mov    %ebx,%esi
  801177:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801179:	8b 1c 24             	mov    (%esp),%ebx
  80117c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801180:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801184:	89 ec                	mov    %ebp,%esp
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
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
  801199:	b9 00 00 00 00       	mov    $0x0,%ecx
  80119e:	b8 13 00 00 00       	mov    $0x13,%eax
  8011a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a6:	89 cb                	mov    %ecx,%ebx
  8011a8:	89 cf                	mov    %ecx,%edi
  8011aa:	89 ce                	mov    %ecx,%esi
  8011ac:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  8011ae:	8b 1c 24             	mov    (%esp),%ebx
  8011b1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011b5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011b9:	89 ec                	mov    %ebp,%esp
  8011bb:	5d                   	pop    %ebp
  8011bc:	c3                   	ret    

008011bd <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 0c             	sub    $0xc,%esp
  8011c3:	89 1c 24             	mov    %ebx,(%esp)
  8011c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ca:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011ce:	b8 10 00 00 00       	mov    $0x10,%eax
  8011d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8011d6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011df:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e2:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  8011e4:	8b 1c 24             	mov    (%esp),%ebx
  8011e7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011eb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ef:	89 ec                	mov    %ebp,%esp
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    
	...

00801200 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801203:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801208:	75 11                	jne    80121b <_ZL8fd_validPK2Fd+0x1b>
  80120a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80120f:	76 0a                	jbe    80121b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801211:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801216:	0f 96 c0             	setbe  %al
  801219:	eb 05                	jmp    801220 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80121b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	53                   	push   %ebx
  801226:	83 ec 14             	sub    $0x14,%esp
  801229:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80122b:	e8 d0 ff ff ff       	call   801200 <_ZL8fd_validPK2Fd>
  801230:	84 c0                	test   %al,%al
  801232:	75 24                	jne    801258 <_ZL9fd_isopenPK2Fd+0x36>
  801234:	c7 44 24 0c 1f 43 80 	movl   $0x80431f,0xc(%esp)
  80123b:	00 
  80123c:	c7 44 24 08 2c 43 80 	movl   $0x80432c,0x8(%esp)
  801243:	00 
  801244:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80124b:	00 
  80124c:	c7 04 24 41 43 80 00 	movl   $0x804341,(%esp)
  801253:	e8 44 ef ff ff       	call   80019c <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801258:	89 d8                	mov    %ebx,%eax
  80125a:	c1 e8 16             	shr    $0x16,%eax
  80125d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
  801269:	f6 c2 01             	test   $0x1,%dl
  80126c:	74 0d                	je     80127b <_ZL9fd_isopenPK2Fd+0x59>
  80126e:	c1 eb 0c             	shr    $0xc,%ebx
  801271:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801278:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80127b:	83 c4 14             	add    $0x14,%esp
  80127e:	5b                   	pop    %ebx
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 08             	sub    $0x8,%esp
  801287:	89 1c 24             	mov    %ebx,(%esp)
  80128a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80128e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801291:	8b 75 0c             	mov    0xc(%ebp),%esi
  801294:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801298:	83 fb 1f             	cmp    $0x1f,%ebx
  80129b:	77 18                	ja     8012b5 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80129d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  8012a3:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  8012a6:	84 c0                	test   %al,%al
  8012a8:	74 21                	je     8012cb <_Z9fd_lookupiPP2Fdb+0x4a>
  8012aa:	89 d8                	mov    %ebx,%eax
  8012ac:	e8 71 ff ff ff       	call   801222 <_ZL9fd_isopenPK2Fd>
  8012b1:	84 c0                	test   %al,%al
  8012b3:	75 16                	jne    8012cb <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  8012b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  8012bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  8012c0:	8b 1c 24             	mov    (%esp),%ebx
  8012c3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012c7:	89 ec                	mov    %ebp,%esp
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  8012cb:	89 1e                	mov    %ebx,(%esi)
		return 0;
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d2:	eb ec                	jmp    8012c0 <_Z9fd_lookupiPP2Fdb+0x3f>

008012d4 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	53                   	push   %ebx
  8012d8:	83 ec 14             	sub    $0x14,%esp
  8012db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  8012de:	89 d8                	mov    %ebx,%eax
  8012e0:	e8 1b ff ff ff       	call   801200 <_ZL8fd_validPK2Fd>
  8012e5:	84 c0                	test   %al,%al
  8012e7:	75 24                	jne    80130d <_Z6fd2numP2Fd+0x39>
  8012e9:	c7 44 24 0c 1f 43 80 	movl   $0x80431f,0xc(%esp)
  8012f0:	00 
  8012f1:	c7 44 24 08 2c 43 80 	movl   $0x80432c,0x8(%esp)
  8012f8:	00 
  8012f9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801300:	00 
  801301:	c7 04 24 41 43 80 00 	movl   $0x804341,(%esp)
  801308:	e8 8f ee ff ff       	call   80019c <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80130d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801313:	c1 e8 0c             	shr    $0xc,%eax
}
  801316:	83 c4 14             	add    $0x14,%esp
  801319:	5b                   	pop    %ebx
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	89 04 24             	mov    %eax,(%esp)
  801328:	e8 a7 ff ff ff       	call   8012d4 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  80132d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801332:	c1 e0 0c             	shl    $0xc,%eax
}
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	57                   	push   %edi
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	83 ec 2c             	sub    $0x2c,%esp
  801340:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801343:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801348:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80134b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801352:	00 
  801353:	89 74 24 04          	mov    %esi,0x4(%esp)
  801357:	89 1c 24             	mov    %ebx,(%esp)
  80135a:	e8 22 ff ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  80135f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801362:	e8 bb fe ff ff       	call   801222 <_ZL9fd_isopenPK2Fd>
  801367:	84 c0                	test   %al,%al
  801369:	75 0c                	jne    801377 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80136b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136e:	89 07                	mov    %eax,(%edi)
			return 0;
  801370:	b8 00 00 00 00       	mov    $0x0,%eax
  801375:	eb 13                	jmp    80138a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801377:	83 c3 01             	add    $0x1,%ebx
  80137a:	83 fb 20             	cmp    $0x20,%ebx
  80137d:	75 cc                	jne    80134b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80137f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801385:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80138a:	83 c4 2c             	add    $0x2c,%esp
  80138d:	5b                   	pop    %ebx
  80138e:	5e                   	pop    %esi
  80138f:	5f                   	pop    %edi
  801390:	5d                   	pop    %ebp
  801391:	c3                   	ret    

00801392 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	53                   	push   %ebx
  801396:	83 ec 14             	sub    $0x14,%esp
  801399:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80139f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013a4:	39 0d 04 50 80 00    	cmp    %ecx,0x805004
  8013aa:	75 16                	jne    8013c2 <_Z10dev_lookupiPP3Dev+0x30>
  8013ac:	eb 06                	jmp    8013b4 <_Z10dev_lookupiPP3Dev+0x22>
  8013ae:	39 0a                	cmp    %ecx,(%edx)
  8013b0:	75 10                	jne    8013c2 <_Z10dev_lookupiPP3Dev+0x30>
  8013b2:	eb 05                	jmp    8013b9 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013b4:	ba 04 50 80 00       	mov    $0x805004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  8013b9:	89 13                	mov    %edx,(%ebx)
			return 0;
  8013bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c0:	eb 35                	jmp    8013f7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013c2:	83 c0 01             	add    $0x1,%eax
  8013c5:	8b 14 85 ac 43 80 00 	mov    0x8043ac(,%eax,4),%edx
  8013cc:	85 d2                	test   %edx,%edx
  8013ce:	75 de                	jne    8013ae <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013d0:	a1 00 60 80 00       	mov    0x806000,%eax
  8013d5:	8b 40 04             	mov    0x4(%eax),%eax
  8013d8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e0:	c7 04 24 68 43 80 00 	movl   $0x804368,(%esp)
  8013e7:	e8 ce ee ff ff       	call   8002ba <_Z7cprintfPKcz>
	*dev = 0;
  8013ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8013f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013f7:	83 c4 14             	add    $0x14,%esp
  8013fa:	5b                   	pop    %ebx
  8013fb:	5d                   	pop    %ebp
  8013fc:	c3                   	ret    

008013fd <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	56                   	push   %esi
  801401:	53                   	push   %ebx
  801402:	83 ec 20             	sub    $0x20,%esp
  801405:	8b 75 08             	mov    0x8(%ebp),%esi
  801408:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  80140c:	89 34 24             	mov    %esi,(%esp)
  80140f:	e8 c0 fe ff ff       	call   8012d4 <_Z6fd2numP2Fd>
  801414:	0f b6 d3             	movzbl %bl,%edx
  801417:	89 54 24 08          	mov    %edx,0x8(%esp)
  80141b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80141e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801422:	89 04 24             	mov    %eax,(%esp)
  801425:	e8 57 fe ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  80142a:	85 c0                	test   %eax,%eax
  80142c:	78 05                	js     801433 <_Z8fd_closeP2Fdb+0x36>
  80142e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801431:	74 0c                	je     80143f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801433:	80 fb 01             	cmp    $0x1,%bl
  801436:	19 db                	sbb    %ebx,%ebx
  801438:	f7 d3                	not    %ebx
  80143a:	83 e3 fd             	and    $0xfffffffd,%ebx
  80143d:	eb 3d                	jmp    80147c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80143f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801442:	89 44 24 04          	mov    %eax,0x4(%esp)
  801446:	8b 06                	mov    (%esi),%eax
  801448:	89 04 24             	mov    %eax,(%esp)
  80144b:	e8 42 ff ff ff       	call   801392 <_Z10dev_lookupiPP3Dev>
  801450:	89 c3                	mov    %eax,%ebx
  801452:	85 c0                	test   %eax,%eax
  801454:	78 16                	js     80146c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801459:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80145c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801461:	85 c0                	test   %eax,%eax
  801463:	74 07                	je     80146c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801465:	89 34 24             	mov    %esi,(%esp)
  801468:	ff d0                	call   *%eax
  80146a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80146c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801470:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801477:	e8 01 fa ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
	return r;
}
  80147c:	89 d8                	mov    %ebx,%eax
  80147e:	83 c4 20             	add    $0x20,%esp
  801481:	5b                   	pop    %ebx
  801482:	5e                   	pop    %esi
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    

00801485 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80148b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801492:	00 
  801493:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	89 04 24             	mov    %eax,(%esp)
  8014a0:	e8 dc fd ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	78 13                	js     8014bc <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  8014a9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014b0:	00 
  8014b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b4:	89 04 24             	mov    %eax,(%esp)
  8014b7:	e8 41 ff ff ff       	call   8013fd <_Z8fd_closeP2Fdb>
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <_Z9close_allv>:

void
close_all(void)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	53                   	push   %ebx
  8014c2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  8014c5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014ca:	89 1c 24             	mov    %ebx,(%esp)
  8014cd:	e8 b3 ff ff ff       	call   801485 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  8014d2:	83 c3 01             	add    $0x1,%ebx
  8014d5:	83 fb 20             	cmp    $0x20,%ebx
  8014d8:	75 f0                	jne    8014ca <_Z9close_allv+0xc>
		close(i);
}
  8014da:	83 c4 14             	add    $0x14,%esp
  8014dd:	5b                   	pop    %ebx
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    

008014e0 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 48             	sub    $0x48,%esp
  8014e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8014ef:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8014f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8014f9:	00 
  8014fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	89 04 24             	mov    %eax,(%esp)
  801507:	e8 75 fd ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  80150c:	89 c3                	mov    %eax,%ebx
  80150e:	85 c0                	test   %eax,%eax
  801510:	0f 88 ce 00 00 00    	js     8015e4 <_Z3dupii+0x104>
  801516:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80151d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  80151e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801521:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801525:	89 34 24             	mov    %esi,(%esp)
  801528:	e8 54 fd ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  80152d:	89 c3                	mov    %eax,%ebx
  80152f:	85 c0                	test   %eax,%eax
  801531:	0f 89 bc 00 00 00    	jns    8015f3 <_Z3dupii+0x113>
  801537:	e9 a8 00 00 00       	jmp    8015e4 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  80153c:	89 d8                	mov    %ebx,%eax
  80153e:	c1 e8 0c             	shr    $0xc,%eax
  801541:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801548:	f6 c2 01             	test   $0x1,%dl
  80154b:	74 32                	je     80157f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80154d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801554:	25 07 0e 00 00       	and    $0xe07,%eax
  801559:	89 44 24 10          	mov    %eax,0x10(%esp)
  80155d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801561:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801568:	00 
  801569:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80156d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801574:	e8 a6 f8 ff ff       	call   800e1f <_Z12sys_page_mapiPviS_i>
  801579:	89 c3                	mov    %eax,%ebx
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 3e                	js     8015bd <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80157f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801582:	89 c2                	mov    %eax,%edx
  801584:	c1 ea 0c             	shr    $0xc,%edx
  801587:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80158e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801594:	89 54 24 10          	mov    %edx,0x10(%esp)
  801598:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80159b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80159f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015a6:	00 
  8015a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b2:	e8 68 f8 ff ff       	call   800e1f <_Z12sys_page_mapiPviS_i>
  8015b7:	89 c3                	mov    %eax,%ebx
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	79 25                	jns    8015e2 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015cb:	e8 ad f8 ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  8015d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015db:	e8 9d f8 ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
	return r;
  8015e0:	eb 02                	jmp    8015e4 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8015e2:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015e4:	89 d8                	mov    %ebx,%eax
  8015e6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015e9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015ef:	89 ec                	mov    %ebp,%esp
  8015f1:	5d                   	pop    %ebp
  8015f2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  8015f3:	89 34 24             	mov    %esi,(%esp)
  8015f6:	e8 8a fe ff ff       	call   801485 <_Z5closei>

	ova = fd2data(oldfd);
  8015fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fe:	89 04 24             	mov    %eax,(%esp)
  801601:	e8 16 fd ff ff       	call   80131c <_Z7fd2dataP2Fd>
  801606:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801608:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160b:	89 04 24             	mov    %eax,(%esp)
  80160e:	e8 09 fd ff ff       	call   80131c <_Z7fd2dataP2Fd>
  801613:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801615:	89 d8                	mov    %ebx,%eax
  801617:	c1 e8 16             	shr    $0x16,%eax
  80161a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801621:	a8 01                	test   $0x1,%al
  801623:	0f 85 13 ff ff ff    	jne    80153c <_Z3dupii+0x5c>
  801629:	e9 51 ff ff ff       	jmp    80157f <_Z3dupii+0x9f>

0080162e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	53                   	push   %ebx
  801632:	83 ec 24             	sub    $0x24,%esp
  801635:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801638:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80163f:	00 
  801640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801643:	89 44 24 04          	mov    %eax,0x4(%esp)
  801647:	89 1c 24             	mov    %ebx,(%esp)
  80164a:	e8 32 fc ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  80164f:	85 c0                	test   %eax,%eax
  801651:	78 5f                	js     8016b2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801653:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801656:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80165d:	8b 00                	mov    (%eax),%eax
  80165f:	89 04 24             	mov    %eax,(%esp)
  801662:	e8 2b fd ff ff       	call   801392 <_Z10dev_lookupiPP3Dev>
  801667:	85 c0                	test   %eax,%eax
  801669:	79 4d                	jns    8016b8 <_Z4readiPvj+0x8a>
  80166b:	eb 45                	jmp    8016b2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80166d:	a1 00 60 80 00       	mov    0x806000,%eax
  801672:	8b 40 04             	mov    0x4(%eax),%eax
  801675:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801679:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167d:	c7 04 24 4a 43 80 00 	movl   $0x80434a,(%esp)
  801684:	e8 31 ec ff ff       	call   8002ba <_Z7cprintfPKcz>
		return -E_INVAL;
  801689:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80168e:	eb 22                	jmp    8016b2 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801693:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801696:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80169b:	85 d2                	test   %edx,%edx
  80169d:	74 13                	je     8016b2 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80169f:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ad:	89 0c 24             	mov    %ecx,(%esp)
  8016b0:	ff d2                	call   *%edx
}
  8016b2:	83 c4 24             	add    $0x24,%esp
  8016b5:	5b                   	pop    %ebx
  8016b6:	5d                   	pop    %ebp
  8016b7:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016b8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016bb:	8b 41 08             	mov    0x8(%ecx),%eax
  8016be:	83 e0 03             	and    $0x3,%eax
  8016c1:	83 f8 01             	cmp    $0x1,%eax
  8016c4:	75 ca                	jne    801690 <_Z4readiPvj+0x62>
  8016c6:	eb a5                	jmp    80166d <_Z4readiPvj+0x3f>

008016c8 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	57                   	push   %edi
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 1c             	sub    $0x1c,%esp
  8016d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016d4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8016d7:	85 f6                	test   %esi,%esi
  8016d9:	74 2f                	je     80170a <_Z5readniPvj+0x42>
  8016db:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016e0:	89 f0                	mov    %esi,%eax
  8016e2:	29 d8                	sub    %ebx,%eax
  8016e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016e8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8016eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 04 24             	mov    %eax,(%esp)
  8016f5:	e8 34 ff ff ff       	call   80162e <_Z4readiPvj>
		if (m < 0)
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	78 13                	js     801711 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  8016fe:	85 c0                	test   %eax,%eax
  801700:	74 0d                	je     80170f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801702:	01 c3                	add    %eax,%ebx
  801704:	39 de                	cmp    %ebx,%esi
  801706:	77 d8                	ja     8016e0 <_Z5readniPvj+0x18>
  801708:	eb 05                	jmp    80170f <_Z5readniPvj+0x47>
  80170a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80170f:	89 d8                	mov    %ebx,%eax
}
  801711:	83 c4 1c             	add    $0x1c,%esp
  801714:	5b                   	pop    %ebx
  801715:	5e                   	pop    %esi
  801716:	5f                   	pop    %edi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80171f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801726:	00 
  801727:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80172a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	89 04 24             	mov    %eax,(%esp)
  801734:	e8 48 fb ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  801739:	85 c0                	test   %eax,%eax
  80173b:	78 3c                	js     801779 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80173d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801740:	89 44 24 04          	mov    %eax,0x4(%esp)
  801744:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801747:	8b 00                	mov    (%eax),%eax
  801749:	89 04 24             	mov    %eax,(%esp)
  80174c:	e8 41 fc ff ff       	call   801392 <_Z10dev_lookupiPP3Dev>
  801751:	85 c0                	test   %eax,%eax
  801753:	79 26                	jns    80177b <_Z5writeiPKvj+0x62>
  801755:	eb 22                	jmp    801779 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  80175d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801762:	85 c9                	test   %ecx,%ecx
  801764:	74 13                	je     801779 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801766:	8b 45 10             	mov    0x10(%ebp),%eax
  801769:	89 44 24 08          	mov    %eax,0x8(%esp)
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	89 44 24 04          	mov    %eax,0x4(%esp)
  801774:	89 14 24             	mov    %edx,(%esp)
  801777:	ff d1                	call   *%ecx
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80177b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80177e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801783:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801787:	74 f0                	je     801779 <_Z5writeiPKvj+0x60>
  801789:	eb cc                	jmp    801757 <_Z5writeiPKvj+0x3e>

0080178b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801791:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801798:	00 
  801799:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	89 04 24             	mov    %eax,(%esp)
  8017a6:	e8 d6 fa ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	78 0e                	js     8017bd <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  8017af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	53                   	push   %ebx
  8017c3:	83 ec 24             	sub    $0x24,%esp
  8017c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8017c9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8017d0:	00 
  8017d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d8:	89 1c 24             	mov    %ebx,(%esp)
  8017db:	e8 a1 fa ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	78 58                	js     80183c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8017ee:	8b 00                	mov    (%eax),%eax
  8017f0:	89 04 24             	mov    %eax,(%esp)
  8017f3:	e8 9a fb ff ff       	call   801392 <_Z10dev_lookupiPP3Dev>
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	79 46                	jns    801842 <_Z9ftruncateii+0x83>
  8017fc:	eb 3e                	jmp    80183c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  8017fe:	a1 00 60 80 00       	mov    0x806000,%eax
  801803:	8b 40 04             	mov    0x4(%eax),%eax
  801806:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80180a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180e:	c7 04 24 88 43 80 00 	movl   $0x804388,(%esp)
  801815:	e8 a0 ea ff ff       	call   8002ba <_Z7cprintfPKcz>
		return -E_INVAL;
  80181a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181f:	eb 1b                	jmp    80183c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801824:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801827:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80182c:	85 d2                	test   %edx,%edx
  80182e:	74 0c                	je     80183c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801830:	8b 45 0c             	mov    0xc(%ebp),%eax
  801833:	89 44 24 04          	mov    %eax,0x4(%esp)
  801837:	89 0c 24             	mov    %ecx,(%esp)
  80183a:	ff d2                	call   *%edx
}
  80183c:	83 c4 24             	add    $0x24,%esp
  80183f:	5b                   	pop    %ebx
  801840:	5d                   	pop    %ebp
  801841:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801842:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801845:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801849:	75 d6                	jne    801821 <_Z9ftruncateii+0x62>
  80184b:	eb b1                	jmp    8017fe <_Z9ftruncateii+0x3f>

0080184d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	53                   	push   %ebx
  801851:	83 ec 24             	sub    $0x24,%esp
  801854:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801857:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80185e:	00 
  80185f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801862:	89 44 24 04          	mov    %eax,0x4(%esp)
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	89 04 24             	mov    %eax,(%esp)
  80186c:	e8 10 fa ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  801871:	85 c0                	test   %eax,%eax
  801873:	78 3e                	js     8018b3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801875:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801878:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80187f:	8b 00                	mov    (%eax),%eax
  801881:	89 04 24             	mov    %eax,(%esp)
  801884:	e8 09 fb ff ff       	call   801392 <_Z10dev_lookupiPP3Dev>
  801889:	85 c0                	test   %eax,%eax
  80188b:	79 2c                	jns    8018b9 <_Z5fstatiP4Stat+0x6c>
  80188d:	eb 24                	jmp    8018b3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80188f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801892:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801899:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  8018a0:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ad:	89 04 24             	mov    %eax,(%esp)
  8018b0:	ff 52 14             	call   *0x14(%edx)
}
  8018b3:	83 c4 24             	add    $0x24,%esp
  8018b6:	5b                   	pop    %ebx
  8018b7:	5d                   	pop    %ebp
  8018b8:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8018b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  8018bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8018c1:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8018c5:	75 c8                	jne    80188f <_Z5fstatiP4Stat+0x42>
  8018c7:	eb ea                	jmp    8018b3 <_Z5fstatiP4Stat+0x66>

008018c9 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 18             	sub    $0x18,%esp
  8018cf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8018d2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018dc:	00 
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	89 04 24             	mov    %eax,(%esp)
  8018e3:	e8 d6 09 00 00       	call   8022be <_Z4openPKci>
  8018e8:	89 c3                	mov    %eax,%ebx
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 1b                	js     801909 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8018ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f5:	89 1c 24             	mov    %ebx,(%esp)
  8018f8:	e8 50 ff ff ff       	call   80184d <_Z5fstatiP4Stat>
  8018fd:	89 c6                	mov    %eax,%esi
	close(fd);
  8018ff:	89 1c 24             	mov    %ebx,(%esp)
  801902:	e8 7e fb ff ff       	call   801485 <_Z5closei>
	return r;
  801907:	89 f3                	mov    %esi,%ebx
}
  801909:	89 d8                	mov    %ebx,%eax
  80190b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80190e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801911:	89 ec                	mov    %ebp,%esp
  801913:	5d                   	pop    %ebp
  801914:	c3                   	ret    
	...

00801920 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801923:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801928:	85 d2                	test   %edx,%edx
  80192a:	78 33                	js     80195f <_ZL10inode_dataP5Inodei+0x3f>
  80192c:	3b 50 08             	cmp    0x8(%eax),%edx
  80192f:	7d 2e                	jge    80195f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801931:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801937:	85 d2                	test   %edx,%edx
  801939:	0f 49 ca             	cmovns %edx,%ecx
  80193c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  80193f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801943:	c1 e1 0c             	shl    $0xc,%ecx
  801946:	89 d0                	mov    %edx,%eax
  801948:	c1 f8 1f             	sar    $0x1f,%eax
  80194b:	c1 e8 14             	shr    $0x14,%eax
  80194e:	01 c2                	add    %eax,%edx
  801950:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801956:	29 c2                	sub    %eax,%edx
  801958:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  80195f:	89 c8                	mov    %ecx,%eax
  801961:	5d                   	pop    %ebp
  801962:	c3                   	ret    

00801963 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801966:	8b 48 08             	mov    0x8(%eax),%ecx
  801969:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  80196c:	8b 00                	mov    (%eax),%eax
  80196e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  801971:	c7 82 80 00 00 00 04 	movl   $0x805004,0x80(%edx)
  801978:	50 80 00 
}
  80197b:	5d                   	pop    %ebp
  80197c:	c3                   	ret    

0080197d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  801983:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  801989:	85 c0                	test   %eax,%eax
  80198b:	74 08                	je     801995 <_ZL9get_inodei+0x18>
  80198d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  801993:	7e 20                	jle    8019b5 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  801995:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801999:	c7 44 24 08 c0 43 80 	movl   $0x8043c0,0x8(%esp)
  8019a0:	00 
  8019a1:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  8019a8:	00 
  8019a9:	c7 04 24 d6 43 80 00 	movl   $0x8043d6,(%esp)
  8019b0:	e8 e7 e7 ff ff       	call   80019c <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  8019b5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  8019bb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8019c1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8019c7:	85 d2                	test   %edx,%edx
  8019c9:	0f 48 d1             	cmovs  %ecx,%edx
  8019cc:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  8019cf:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  8019d6:	c1 e0 0c             	shl    $0xc,%eax
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
  8019e0:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  8019e3:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  8019e9:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  8019ec:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  8019f2:	76 20                	jbe    801a14 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  8019f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019f8:	c7 44 24 08 fc 43 80 	movl   $0x8043fc,0x8(%esp)
  8019ff:	00 
  801a00:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801a07:	00 
  801a08:	c7 04 24 d6 43 80 00 	movl   $0x8043d6,(%esp)
  801a0f:	e8 88 e7 ff ff       	call   80019c <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  801a14:	83 fe 01             	cmp    $0x1,%esi
  801a17:	7e 08                	jle    801a21 <_ZL10bcache_ipcPvi+0x46>
  801a19:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  801a1f:	7d 12                	jge    801a33 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801a21:	89 f3                	mov    %esi,%ebx
  801a23:	c1 e3 04             	shl    $0x4,%ebx
  801a26:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801a28:	81 c6 00 00 05 00    	add    $0x50000,%esi
  801a2e:	c1 e6 0c             	shl    $0xc,%esi
  801a31:	eb 20                	jmp    801a53 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  801a33:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a37:	c7 44 24 08 2c 44 80 	movl   $0x80442c,0x8(%esp)
  801a3e:	00 
  801a3f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801a46:	00 
  801a47:	c7 04 24 d6 43 80 00 	movl   $0x8043d6,(%esp)
  801a4e:	e8 49 e7 ff ff       	call   80019c <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801a53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a5a:	00 
  801a5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a62:	00 
  801a63:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a67:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801a6e:	e8 cc 21 00 00       	call   803c3f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801a73:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a7a:	00 
  801a7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a86:	e8 25 21 00 00       	call   803bb0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  801a8b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  801a8e:	74 c3                	je     801a53 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    

00801a97 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 28             	sub    $0x28,%esp
  801a9d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801aa0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801aa3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801aa6:	89 c7                	mov    %eax,%edi
  801aa8:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  801aaa:	c7 04 24 3d 1d 80 00 	movl   $0x801d3d,(%esp)
  801ab1:	e8 05 20 00 00       	call   803abb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  801ab6:	89 f8                	mov    %edi,%eax
  801ab8:	e8 c0 fe ff ff       	call   80197d <_ZL9get_inodei>
  801abd:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  801abf:	ba 02 00 00 00       	mov    $0x2,%edx
  801ac4:	e8 12 ff ff ff       	call   8019db <_ZL10bcache_ipcPvi>
	if (r < 0) {
  801ac9:	85 c0                	test   %eax,%eax
  801acb:	79 08                	jns    801ad5 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  801acd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  801ad3:	eb 2e                	jmp    801b03 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	75 1c                	jne    801af5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  801ad9:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  801adf:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  801ae6:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  801ae9:	ba 06 00 00 00       	mov    $0x6,%edx
  801aee:	89 d8                	mov    %ebx,%eax
  801af0:	e8 e6 fe ff ff       	call   8019db <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  801af5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  801afc:	89 1e                	mov    %ebx,(%esi)
	return 0;
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b03:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b06:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b09:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b0c:	89 ec                	mov    %ebp,%esp
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    

00801b10 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	57                   	push   %edi
  801b14:	56                   	push   %esi
  801b15:	53                   	push   %ebx
  801b16:	83 ec 2c             	sub    $0x2c,%esp
  801b19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801b1c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  801b1f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  801b24:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  801b2a:	0f 87 3d 01 00 00    	ja     801c6d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  801b30:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b33:	8b 42 08             	mov    0x8(%edx),%eax
  801b36:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	0f 49 f0             	cmovns %eax,%esi
  801b41:	c1 fe 0c             	sar    $0xc,%esi
  801b44:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  801b46:	8b 7d d8             	mov    -0x28(%ebp),%edi
  801b49:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  801b4f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  801b52:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801b55:	0f 82 a6 00 00 00    	jb     801c01 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  801b5b:	39 fe                	cmp    %edi,%esi
  801b5d:	0f 8d f2 00 00 00    	jge    801c55 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801b63:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  801b67:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801b6a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801b6d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  801b70:	83 3e 00             	cmpl   $0x0,(%esi)
  801b73:	75 77                	jne    801bec <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801b75:	ba 02 00 00 00       	mov    $0x2,%edx
  801b7a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801b7f:	e8 57 fe ff ff       	call   8019db <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801b84:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  801b8a:	83 f9 02             	cmp    $0x2,%ecx
  801b8d:	7e 43                	jle    801bd2 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  801b8f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801b94:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  801b99:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  801ba0:	74 29                	je     801bcb <_ZL14inode_set_sizeP5Inodej+0xbb>
  801ba2:	e9 ce 00 00 00       	jmp    801c75 <_ZL14inode_set_sizeP5Inodej+0x165>
  801ba7:	89 c7                	mov    %eax,%edi
  801ba9:	0f b6 10             	movzbl (%eax),%edx
  801bac:	83 c0 01             	add    $0x1,%eax
  801baf:	84 d2                	test   %dl,%dl
  801bb1:	74 18                	je     801bcb <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  801bb3:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801bb6:	ba 05 00 00 00       	mov    $0x5,%edx
  801bbb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801bc0:	e8 16 fe ff ff       	call   8019db <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  801bc5:	85 db                	test   %ebx,%ebx
  801bc7:	79 1e                	jns    801be7 <_ZL14inode_set_sizeP5Inodej+0xd7>
  801bc9:	eb 07                	jmp    801bd2 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801bcb:	83 c3 01             	add    $0x1,%ebx
  801bce:	39 d9                	cmp    %ebx,%ecx
  801bd0:	7f d5                	jg     801ba7 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  801bd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bd5:	8b 50 08             	mov    0x8(%eax),%edx
  801bd8:	e8 33 ff ff ff       	call   801b10 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  801bdd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801be2:	e9 86 00 00 00       	jmp    801c6d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  801be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bea:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  801bec:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  801bf0:	83 c6 04             	add    $0x4,%esi
  801bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bf6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  801bf9:	0f 8f 6e ff ff ff    	jg     801b6d <_ZL14inode_set_sizeP5Inodej+0x5d>
  801bff:	eb 54                	jmp    801c55 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  801c01:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c04:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  801c09:	83 f8 01             	cmp    $0x1,%eax
  801c0c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801c0f:	ba 02 00 00 00       	mov    $0x2,%edx
  801c14:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c19:	e8 bd fd ff ff       	call   8019db <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  801c1e:	39 f7                	cmp    %esi,%edi
  801c20:	7d 24                	jge    801c46 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  801c22:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801c25:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  801c29:	8b 10                	mov    (%eax),%edx
  801c2b:	85 d2                	test   %edx,%edx
  801c2d:	74 0d                	je     801c3c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  801c2f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  801c36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  801c3c:	83 eb 01             	sub    $0x1,%ebx
  801c3f:	83 e8 04             	sub    $0x4,%eax
  801c42:	39 fb                	cmp    %edi,%ebx
  801c44:	75 e3                	jne    801c29 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c46:	ba 05 00 00 00       	mov    $0x5,%edx
  801c4b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c50:	e8 86 fd ff ff       	call   8019db <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  801c55:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c5b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  801c5e:	ba 04 00 00 00       	mov    $0x4,%edx
  801c63:	e8 73 fd ff ff       	call   8019db <_ZL10bcache_ipcPvi>
	return 0;
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6d:	83 c4 2c             	add    $0x2c,%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5f                   	pop    %edi
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  801c75:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801c7c:	ba 05 00 00 00       	mov    $0x5,%edx
  801c81:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801c86:	e8 50 fd ff ff       	call   8019db <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  801c8b:	bb 02 00 00 00       	mov    $0x2,%ebx
  801c90:	e9 52 ff ff ff       	jmp    801be7 <_ZL14inode_set_sizeP5Inodej+0xd7>

00801c95 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	53                   	push   %ebx
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  801c9e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  801ca4:	83 e8 01             	sub    $0x1,%eax
  801ca7:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  801cad:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  801cb1:	75 40                	jne    801cf3 <_ZL11inode_closeP5Inode+0x5e>
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	75 3c                	jne    801cf3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  801cb7:	ba 02 00 00 00       	mov    $0x2,%edx
  801cbc:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801cc1:	e8 15 fd ff ff       	call   8019db <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  801ccb:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  801ccf:	85 d2                	test   %edx,%edx
  801cd1:	74 07                	je     801cda <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  801cd3:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  801cda:	83 c0 01             	add    $0x1,%eax
  801cdd:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  801ce2:	75 e7                	jne    801ccb <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  801ce4:	ba 05 00 00 00       	mov    $0x5,%edx
  801ce9:	b8 00 20 00 50       	mov    $0x50002000,%eax
  801cee:	e8 e8 fc ff ff       	call   8019db <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  801cf3:	ba 03 00 00 00       	mov    $0x3,%edx
  801cf8:	89 d8                	mov    %ebx,%eax
  801cfa:	e8 dc fc ff ff       	call   8019db <_ZL10bcache_ipcPvi>
}
  801cff:	83 c4 04             	add    $0x4,%esp
  801d02:	5b                   	pop    %ebx
  801d03:	5d                   	pop    %ebp
  801d04:	c3                   	ret    

00801d05 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	53                   	push   %ebx
  801d09:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d12:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d15:	e8 7d fd ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  801d1a:	89 c3                	mov    %eax,%ebx
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	78 15                	js     801d35 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  801d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d26:	e8 e5 fd ff ff       	call   801b10 <_ZL14inode_set_sizeP5Inodej>
  801d2b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  801d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d30:	e8 60 ff ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
	return r;
}
  801d35:	89 d8                	mov    %ebx,%eax
  801d37:	83 c4 14             	add    $0x14,%esp
  801d3a:	5b                   	pop    %ebx
  801d3b:	5d                   	pop    %ebp
  801d3c:	c3                   	ret    

00801d3d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	53                   	push   %ebx
  801d41:	83 ec 14             	sub    $0x14,%esp
  801d44:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  801d47:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  801d49:	89 c2                	mov    %eax,%edx
  801d4b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  801d51:	78 32                	js     801d85 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  801d53:	ba 00 00 00 00       	mov    $0x0,%edx
  801d58:	e8 7e fc ff ff       	call   8019db <_ZL10bcache_ipcPvi>
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	74 1c                	je     801d7d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  801d61:	c7 44 24 08 e1 43 80 	movl   $0x8043e1,0x8(%esp)
  801d68:	00 
  801d69:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801d70:	00 
  801d71:	c7 04 24 d6 43 80 00 	movl   $0x8043d6,(%esp)
  801d78:	e8 1f e4 ff ff       	call   80019c <_Z6_panicPKciS0_z>
    resume(utf);
  801d7d:	89 1c 24             	mov    %ebx,(%esp)
  801d80:	e8 0b 1e 00 00       	call   803b90 <resume>
}
  801d85:	83 c4 14             	add    $0x14,%esp
  801d88:	5b                   	pop    %ebx
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    

00801d8b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 28             	sub    $0x28,%esp
  801d91:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d94:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d9a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801d9d:	8b 43 0c             	mov    0xc(%ebx),%eax
  801da0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801da3:	e8 ef fc ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 26                	js     801dd2 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  801dac:	83 c3 10             	add    $0x10,%ebx
  801daf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801db3:	89 34 24             	mov    %esi,(%esp)
  801db6:	e8 1f eb ff ff       	call   8008da <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  801dbb:	89 f2                	mov    %esi,%edx
  801dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc0:	e8 9e fb ff ff       	call   801963 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  801dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc8:	e8 c8 fe ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
	return 0;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801dd5:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801dd8:	89 ec                	mov    %ebp,%esp
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    

00801ddc <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	53                   	push   %ebx
  801de0:	83 ec 24             	sub    $0x24,%esp
  801de3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801de6:	89 1c 24             	mov    %ebx,(%esp)
  801de9:	e8 9e 15 00 00       	call   80338c <_Z7pagerefPv>
  801dee:	89 c2                	mov    %eax,%edx
        return 0;
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  801df5:	83 fa 01             	cmp    $0x1,%edx
  801df8:	7f 1e                	jg     801e18 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801dfa:	8b 43 0c             	mov    0xc(%ebx),%eax
  801dfd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e00:	e8 92 fc ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  801e05:	85 c0                	test   %eax,%eax
  801e07:	78 0f                	js     801e18 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  801e13:	e8 7d fe ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
}
  801e18:	83 c4 24             	add    $0x24,%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5d                   	pop    %ebp
  801e1d:	c3                   	ret    

00801e1e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	57                   	push   %edi
  801e22:	56                   	push   %esi
  801e23:	53                   	push   %ebx
  801e24:	83 ec 3c             	sub    $0x3c,%esp
  801e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801e2a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  801e2d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e30:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801e33:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e36:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801e39:	e8 59 fc ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	0f 88 8c 00 00 00    	js     801ed2 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801e46:	8b 53 04             	mov    0x4(%ebx),%edx
  801e49:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  801e4f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  801e55:	29 d7                	sub    %edx,%edi
  801e57:	39 f7                	cmp    %esi,%edi
  801e59:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  801e5c:	85 ff                	test   %edi,%edi
  801e5e:	74 16                	je     801e76 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801e60:	8d 14 17             	lea    (%edi,%edx,1),%edx
  801e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e66:	3b 50 08             	cmp    0x8(%eax),%edx
  801e69:	76 6f                	jbe    801eda <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  801e6b:	e8 a0 fc ff ff       	call   801b10 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  801e70:	85 c0                	test   %eax,%eax
  801e72:	79 66                	jns    801eda <_ZL13devfile_writeP2FdPKvj+0xbc>
  801e74:	eb 4e                	jmp    801ec4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801e76:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  801e7c:	76 24                	jbe    801ea2 <_ZL13devfile_writeP2FdPKvj+0x84>
  801e7e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801e80:	8b 53 04             	mov    0x4(%ebx),%edx
  801e83:	81 c2 00 10 00 00    	add    $0x1000,%edx
  801e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e8c:	3b 50 08             	cmp    0x8(%eax),%edx
  801e8f:	0f 86 83 00 00 00    	jbe    801f18 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  801e95:	e8 76 fc ff ff       	call   801b10 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	79 7a                	jns    801f18 <_ZL13devfile_writeP2FdPKvj+0xfa>
  801e9e:	66 90                	xchg   %ax,%ax
  801ea0:	eb 22                	jmp    801ec4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  801ea2:	85 f6                	test   %esi,%esi
  801ea4:	74 1e                	je     801ec4 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801ea6:	89 f2                	mov    %esi,%edx
  801ea8:	03 53 04             	add    0x4(%ebx),%edx
  801eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eae:	3b 50 08             	cmp    0x8(%eax),%edx
  801eb1:	0f 86 b8 00 00 00    	jbe    801f6f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  801eb7:	e8 54 fc ff ff       	call   801b10 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	0f 89 ab 00 00 00    	jns    801f6f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  801ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec7:	e8 c9 fd ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  801ecc:	8b 43 04             	mov    0x4(%ebx),%eax
  801ecf:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  801ed2:	83 c4 3c             	add    $0x3c,%esp
  801ed5:	5b                   	pop    %ebx
  801ed6:	5e                   	pop    %esi
  801ed7:	5f                   	pop    %edi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  801eda:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801edc:	8b 53 04             	mov    0x4(%ebx),%edx
  801edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ee2:	e8 39 fa ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
  801ee7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  801eea:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ef8:	89 04 24             	mov    %eax,(%esp)
  801efb:	e8 f7 eb ff ff       	call   800af7 <memcpy>
        fd->fd_offset += n2;
  801f00:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  801f03:	ba 04 00 00 00       	mov    $0x4,%edx
  801f08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f0b:	e8 cb fa ff ff       	call   8019db <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  801f10:	01 7d 0c             	add    %edi,0xc(%ebp)
  801f13:	e9 5e ff ff ff       	jmp    801e76 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801f18:	8b 53 04             	mov    0x4(%ebx),%edx
  801f1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f1e:	e8 fd f9 ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
  801f23:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  801f25:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801f2c:	00 
  801f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f34:	89 34 24             	mov    %esi,(%esp)
  801f37:	e8 bb eb ff ff       	call   800af7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801f3c:	ba 04 00 00 00       	mov    $0x4,%edx
  801f41:	89 f0                	mov    %esi,%eax
  801f43:	e8 93 fa ff ff       	call   8019db <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  801f48:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  801f4e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  801f55:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  801f5c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  801f62:	0f 87 18 ff ff ff    	ja     801e80 <_ZL13devfile_writeP2FdPKvj+0x62>
  801f68:	89 fe                	mov    %edi,%esi
  801f6a:	e9 33 ff ff ff       	jmp    801ea2 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  801f6f:	8b 53 04             	mov    0x4(%ebx),%edx
  801f72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f75:	e8 a6 f9 ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
  801f7a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  801f7c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f87:	89 3c 24             	mov    %edi,(%esp)
  801f8a:	e8 68 eb ff ff       	call   800af7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  801f8f:	ba 04 00 00 00       	mov    $0x4,%edx
  801f94:	89 f8                	mov    %edi,%eax
  801f96:	e8 40 fa ff ff       	call   8019db <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  801f9b:	01 73 04             	add    %esi,0x4(%ebx)
  801f9e:	e9 21 ff ff ff       	jmp    801ec4 <_ZL13devfile_writeP2FdPKvj+0xa6>

00801fa3 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	57                   	push   %edi
  801fa7:	56                   	push   %esi
  801fa8:	53                   	push   %ebx
  801fa9:	83 ec 3c             	sub    $0x3c,%esp
  801fac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801faf:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  801fb2:	8b 43 04             	mov    0x4(%ebx),%eax
  801fb5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  801fb8:	8b 43 0c             	mov    0xc(%ebx),%eax
  801fbb:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  801fbe:	e8 d4 fa ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	0f 88 d3 00 00 00    	js     80209e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  801fcb:	8b 73 04             	mov    0x4(%ebx),%esi
  801fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd1:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  801fd4:	8b 50 08             	mov    0x8(%eax),%edx
  801fd7:	29 f2                	sub    %esi,%edx
  801fd9:	3b 48 08             	cmp    0x8(%eax),%ecx
  801fdc:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  801fdf:	89 f2                	mov    %esi,%edx
  801fe1:	e8 3a f9 ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	0f 84 a2 00 00 00    	je     802090 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  801fee:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  801ff4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801ffa:	29 f2                	sub    %esi,%edx
  801ffc:	39 d7                	cmp    %edx,%edi
  801ffe:	0f 46 d7             	cmovbe %edi,%edx
  802001:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802004:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802006:	01 d6                	add    %edx,%esi
  802008:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80200b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80200f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802013:	8b 45 0c             	mov    0xc(%ebp),%eax
  802016:	89 04 24             	mov    %eax,(%esp)
  802019:	e8 d9 ea ff ff       	call   800af7 <memcpy>
    buf = (void *)((char *)buf + n2);
  80201e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802021:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802024:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80202a:	76 3e                	jbe    80206a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80202c:	8b 53 04             	mov    0x4(%ebx),%edx
  80202f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802032:	e8 e9 f8 ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
  802037:	85 c0                	test   %eax,%eax
  802039:	74 55                	je     802090 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80203b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802042:	00 
  802043:	89 44 24 04          	mov    %eax,0x4(%esp)
  802047:	89 34 24             	mov    %esi,(%esp)
  80204a:	e8 a8 ea ff ff       	call   800af7 <memcpy>
        n -= PGSIZE;
  80204f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802055:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80205b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802062:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802068:	77 c2                	ja     80202c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80206a:	85 ff                	test   %edi,%edi
  80206c:	74 22                	je     802090 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80206e:	8b 53 04             	mov    0x4(%ebx),%edx
  802071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802074:	e8 a7 f8 ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
  802079:	85 c0                	test   %eax,%eax
  80207b:	74 13                	je     802090 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80207d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802081:	89 44 24 04          	mov    %eax,0x4(%esp)
  802085:	89 34 24             	mov    %esi,(%esp)
  802088:	e8 6a ea ff ff       	call   800af7 <memcpy>
        fd->fd_offset += n;
  80208d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802090:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802093:	e8 fd fb ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802098:	8b 43 04             	mov    0x4(%ebx),%eax
  80209b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80209e:	83 c4 3c             	add    $0x3c,%esp
  8020a1:	5b                   	pop    %ebx
  8020a2:	5e                   	pop    %esi
  8020a3:	5f                   	pop    %edi
  8020a4:	5d                   	pop    %ebp
  8020a5:	c3                   	ret    

008020a6 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	57                   	push   %edi
  8020aa:	56                   	push   %esi
  8020ab:	53                   	push   %ebx
  8020ac:	83 ec 4c             	sub    $0x4c,%esp
  8020af:	89 c6                	mov    %eax,%esi
  8020b1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8020b4:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  8020b7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  8020bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  8020c6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8020c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ce:	e8 c4 f9 ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  8020d3:	89 c7                	mov    %eax,%edi
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	0f 88 cd 01 00 00    	js     8022aa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8020dd:	89 f3                	mov    %esi,%ebx
  8020df:	80 3e 2f             	cmpb   $0x2f,(%esi)
  8020e2:	75 08                	jne    8020ec <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  8020e4:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8020e7:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8020ea:	74 f8                	je     8020e4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8020ec:	0f b6 03             	movzbl (%ebx),%eax
  8020ef:	3c 2f                	cmp    $0x2f,%al
  8020f1:	74 16                	je     802109 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8020f3:	84 c0                	test   %al,%al
  8020f5:	74 12                	je     802109 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8020f7:	89 da                	mov    %ebx,%edx
		++path;
  8020f9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8020fc:	0f b6 02             	movzbl (%edx),%eax
  8020ff:	3c 2f                	cmp    $0x2f,%al
  802101:	74 08                	je     80210b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802103:	84 c0                	test   %al,%al
  802105:	75 f2                	jne    8020f9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802107:	eb 02                	jmp    80210b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802109:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80210b:	89 d0                	mov    %edx,%eax
  80210d:	29 d8                	sub    %ebx,%eax
  80210f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802112:	0f b6 02             	movzbl (%edx),%eax
  802115:	89 d6                	mov    %edx,%esi
  802117:	3c 2f                	cmp    $0x2f,%al
  802119:	75 0a                	jne    802125 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80211b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80211e:	0f b6 06             	movzbl (%esi),%eax
  802121:	3c 2f                	cmp    $0x2f,%al
  802123:	74 f6                	je     80211b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802125:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802129:	75 1b                	jne    802146 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80212b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80212e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802131:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802133:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802136:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80213c:	bf 00 00 00 00       	mov    $0x0,%edi
  802141:	e9 64 01 00 00       	jmp    8022aa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802146:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  80214a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214e:	74 06                	je     802156 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802150:	84 c0                	test   %al,%al
  802152:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802156:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802159:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80215c:	83 3a 02             	cmpl   $0x2,(%edx)
  80215f:	0f 85 f4 00 00 00    	jne    802259 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802165:	89 d0                	mov    %edx,%eax
  802167:	8b 52 08             	mov    0x8(%edx),%edx
  80216a:	85 d2                	test   %edx,%edx
  80216c:	7e 78                	jle    8021e6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80216e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802175:	bf 00 00 00 00       	mov    $0x0,%edi
  80217a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80217d:	89 fb                	mov    %edi,%ebx
  80217f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802182:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802184:	89 da                	mov    %ebx,%edx
  802186:	89 f0                	mov    %esi,%eax
  802188:	e8 93 f7 ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
  80218d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80218f:	83 38 00             	cmpl   $0x0,(%eax)
  802192:	74 26                	je     8021ba <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802194:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802197:	3b 50 04             	cmp    0x4(%eax),%edx
  80219a:	75 33                	jne    8021cf <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80219c:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8021a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a7:	8d 47 08             	lea    0x8(%edi),%eax
  8021aa:	89 04 24             	mov    %eax,(%esp)
  8021ad:	e8 86 e9 ff ff       	call   800b38 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	0f 84 fa 00 00 00    	je     8022b4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  8021ba:	83 3f 00             	cmpl   $0x0,(%edi)
  8021bd:	75 10                	jne    8021cf <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  8021bf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8021c3:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8021c6:	84 c0                	test   %al,%al
  8021c8:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  8021cc:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8021cf:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  8021d5:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8021d7:	8b 56 08             	mov    0x8(%esi),%edx
  8021da:	39 d0                	cmp    %edx,%eax
  8021dc:	7c a6                	jl     802184 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  8021de:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8021e1:	8b 75 c0             	mov    -0x40(%ebp),%esi
  8021e4:	eb 07                	jmp    8021ed <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  8021e6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  8021ed:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  8021f1:	74 6d                	je     802260 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  8021f3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8021f7:	75 24                	jne    80221d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  8021f9:	83 ea 80             	sub    $0xffffff80,%edx
  8021fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021ff:	e8 0c f9 ff ff       	call   801b10 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802204:	85 c0                	test   %eax,%eax
  802206:	0f 88 90 00 00 00    	js     80229c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80220c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80220f:	8b 50 08             	mov    0x8(%eax),%edx
  802212:	83 c2 80             	add    $0xffffff80,%edx
  802215:	e8 06 f7 ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
  80221a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80221d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802224:	00 
  802225:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80222c:	00 
  80222d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802230:	89 14 24             	mov    %edx,(%esp)
  802233:	e8 e9 e7 ff ff       	call   800a21 <memset>
	empty->de_namelen = namelen;
  802238:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80223b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80223e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802241:	89 54 24 08          	mov    %edx,0x8(%esp)
  802245:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802249:	83 c0 08             	add    $0x8,%eax
  80224c:	89 04 24             	mov    %eax,(%esp)
  80224f:	e8 a3 e8 ff ff       	call   800af7 <memcpy>
	*de_store = empty;
  802254:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802257:	eb 5e                	jmp    8022b7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802259:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80225e:	eb 42                	jmp    8022a2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802260:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802265:	eb 3b                	jmp    8022a2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80226a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80226d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80226f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802272:	89 38                	mov    %edi,(%eax)
			return 0;
  802274:	bf 00 00 00 00       	mov    $0x0,%edi
  802279:	eb 2f                	jmp    8022aa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80227b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80227e:	8b 07                	mov    (%edi),%eax
  802280:	e8 12 f8 ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  802285:	85 c0                	test   %eax,%eax
  802287:	78 17                	js     8022a0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80228c:	e8 04 fa ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802291:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802294:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802297:	e9 41 fe ff ff       	jmp    8020dd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80229c:	89 c7                	mov    %eax,%edi
  80229e:	eb 02                	jmp    8022a2 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  8022a0:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  8022a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a5:	e8 eb f9 ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
	return r;
}
  8022aa:	89 f8                	mov    %edi,%eax
  8022ac:	83 c4 4c             	add    $0x4c,%esp
  8022af:	5b                   	pop    %ebx
  8022b0:	5e                   	pop    %esi
  8022b1:	5f                   	pop    %edi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    
  8022b4:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  8022b7:	80 3e 00             	cmpb   $0x0,(%esi)
  8022ba:	75 bf                	jne    80227b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  8022bc:	eb a9                	jmp    802267 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

008022be <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 3c             	sub    $0x3c,%esp
  8022c7:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  8022ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8022cd:	89 04 24             	mov    %eax,(%esp)
  8022d0:	e8 62 f0 ff ff       	call   801337 <_Z14fd_find_unusedPP2Fd>
  8022d5:	89 c3                	mov    %eax,%ebx
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	0f 88 16 02 00 00    	js     8024f5 <_Z4openPKci+0x237>
  8022df:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022e6:	00 
  8022e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f5:	e8 c6 ea ff ff       	call   800dc0 <_Z14sys_page_allociPvi>
  8022fa:	89 c3                	mov    %eax,%ebx
  8022fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802301:	85 db                	test   %ebx,%ebx
  802303:	0f 88 ec 01 00 00    	js     8024f5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802309:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80230d:	0f 84 ec 01 00 00    	je     8024ff <_Z4openPKci+0x241>
  802313:	83 c0 01             	add    $0x1,%eax
  802316:	83 f8 78             	cmp    $0x78,%eax
  802319:	75 ee                	jne    802309 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  80231b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802320:	e9 b9 01 00 00       	jmp    8024de <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802325:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802328:	81 e7 00 01 00 00    	and    $0x100,%edi
  80232e:	89 3c 24             	mov    %edi,(%esp)
  802331:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802334:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802337:	89 f0                	mov    %esi,%eax
  802339:	e8 68 fd ff ff       	call   8020a6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80233e:	89 c3                	mov    %eax,%ebx
  802340:	85 c0                	test   %eax,%eax
  802342:	0f 85 96 01 00 00    	jne    8024de <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802348:	85 ff                	test   %edi,%edi
  80234a:	75 41                	jne    80238d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  80234c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80234f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802354:	75 08                	jne    80235e <_Z4openPKci+0xa0>
            fileino = dirino;
  802356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802359:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80235c:	eb 14                	jmp    802372 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  80235e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802361:	8b 00                	mov    (%eax),%eax
  802363:	e8 2f f7 ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  802368:	89 c3                	mov    %eax,%ebx
  80236a:	85 c0                	test   %eax,%eax
  80236c:	0f 88 5d 01 00 00    	js     8024cf <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802372:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802375:	83 38 02             	cmpl   $0x2,(%eax)
  802378:	0f 85 d2 00 00 00    	jne    802450 <_Z4openPKci+0x192>
  80237e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802382:	0f 84 c8 00 00 00    	je     802450 <_Z4openPKci+0x192>
  802388:	e9 38 01 00 00       	jmp    8024c5 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80238d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802394:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80239b:	0f 8e a8 00 00 00    	jle    802449 <_Z4openPKci+0x18b>
  8023a1:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  8023a6:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  8023a9:	89 f8                	mov    %edi,%eax
  8023ab:	e8 e7 f6 ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  8023b0:	89 c3                	mov    %eax,%ebx
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	0f 88 15 01 00 00    	js     8024cf <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  8023ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023bd:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8023c1:	75 68                	jne    80242b <_Z4openPKci+0x16d>
  8023c3:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  8023ca:	75 5f                	jne    80242b <_Z4openPKci+0x16d>
			*ino_store = ino;
  8023cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  8023cf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  8023d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  8023df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  8023e6:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  8023ed:	00 
  8023ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023f5:	00 
  8023f6:	83 c0 0c             	add    $0xc,%eax
  8023f9:	89 04 24             	mov    %eax,(%esp)
  8023fc:	e8 20 e6 ff ff       	call   800a21 <memset>
        de->de_inum = fileino->i_inum;
  802401:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802404:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  80240a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80240d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  80240f:	ba 04 00 00 00       	mov    $0x4,%edx
  802414:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802417:	e8 bf f5 ff ff       	call   8019db <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  80241c:	ba 04 00 00 00       	mov    $0x4,%edx
  802421:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802424:	e8 b2 f5 ff ff       	call   8019db <_ZL10bcache_ipcPvi>
  802429:	eb 25                	jmp    802450 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  80242b:	e8 65 f8 ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802430:	83 c7 01             	add    $0x1,%edi
  802433:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802439:	0f 8c 67 ff ff ff    	jl     8023a6 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  80243f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802444:	e9 86 00 00 00       	jmp    8024cf <_Z4openPKci+0x211>
  802449:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  80244e:	eb 7f                	jmp    8024cf <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802450:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802457:	74 0d                	je     802466 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802459:	ba 00 00 00 00       	mov    $0x0,%edx
  80245e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802461:	e8 aa f6 ff ff       	call   801b10 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802466:	8b 15 04 50 80 00    	mov    0x805004,%edx
  80246c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802474:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80247b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80247e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802481:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802484:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80248a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80248d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802491:	83 c0 10             	add    $0x10,%eax
  802494:	89 04 24             	mov    %eax,(%esp)
  802497:	e8 3e e4 ff ff       	call   8008da <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80249c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80249f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  8024a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a9:	e8 e7 f7 ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  8024ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b1:	e8 df f7 ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  8024b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b9:	89 04 24             	mov    %eax,(%esp)
  8024bc:	e8 13 ee ff ff       	call   8012d4 <_Z6fd2numP2Fd>
  8024c1:	89 c3                	mov    %eax,%ebx
  8024c3:	eb 30                	jmp    8024f5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  8024c5:	e8 cb f7 ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  8024ca:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  8024cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d2:	e8 be f7 ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
  8024d7:	eb 05                	jmp    8024de <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8024d9:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  8024de:	a1 00 60 80 00       	mov    0x806000,%eax
  8024e3:	8b 40 04             	mov    0x4(%eax),%eax
  8024e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024ed:	89 04 24             	mov    %eax,(%esp)
  8024f0:	e8 88 e9 ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  8024f5:	89 d8                	mov    %ebx,%eax
  8024f7:	83 c4 3c             	add    $0x3c,%esp
  8024fa:	5b                   	pop    %ebx
  8024fb:	5e                   	pop    %esi
  8024fc:	5f                   	pop    %edi
  8024fd:	5d                   	pop    %ebp
  8024fe:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  8024ff:	83 f8 78             	cmp    $0x78,%eax
  802502:	0f 85 1d fe ff ff    	jne    802325 <_Z4openPKci+0x67>
  802508:	eb cf                	jmp    8024d9 <_Z4openPKci+0x21b>

0080250a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	53                   	push   %ebx
  80250e:	83 ec 24             	sub    $0x24,%esp
  802511:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802514:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802517:	8b 45 08             	mov    0x8(%ebp),%eax
  80251a:	e8 78 f5 ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  80251f:	85 c0                	test   %eax,%eax
  802521:	78 27                	js     80254a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802523:	c7 44 24 04 f4 43 80 	movl   $0x8043f4,0x4(%esp)
  80252a:	00 
  80252b:	89 1c 24             	mov    %ebx,(%esp)
  80252e:	e8 a7 e3 ff ff       	call   8008da <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802533:	89 da                	mov    %ebx,%edx
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	e8 26 f4 ff ff       	call   801963 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	e8 50 f7 ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
	return 0;
  802545:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254a:	83 c4 24             	add    $0x24,%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5d                   	pop    %ebp
  80254f:	c3                   	ret    

00802550 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	53                   	push   %ebx
  802554:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802557:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80255e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802561:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	e8 3a fb ff ff       	call   8020a6 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80256c:	89 c3                	mov    %eax,%ebx
  80256e:	85 c0                	test   %eax,%eax
  802570:	78 5f                	js     8025d1 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802572:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	e8 18 f5 ff ff       	call   801a97 <_ZL10inode_openiPP5Inode>
  80257f:	89 c3                	mov    %eax,%ebx
  802581:	85 c0                	test   %eax,%eax
  802583:	78 44                	js     8025c9 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802585:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258d:	83 38 02             	cmpl   $0x2,(%eax)
  802590:	74 2f                	je     8025c1 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802595:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80259b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  8025a2:	ba 04 00 00 00       	mov    $0x4,%edx
  8025a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025aa:	e8 2c f4 ff ff       	call   8019db <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  8025af:	ba 04 00 00 00       	mov    $0x4,%edx
  8025b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b7:	e8 1f f4 ff ff       	call   8019db <_ZL10bcache_ipcPvi>
	r = 0;
  8025bc:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	e8 cc f6 ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	e8 c4 f6 ff ff       	call   801c95 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  8025d1:	89 d8                	mov    %ebx,%eax
  8025d3:	83 c4 24             	add    $0x24,%esp
  8025d6:	5b                   	pop    %ebx
  8025d7:	5d                   	pop    %ebp
  8025d8:	c3                   	ret    

008025d9 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  8025dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e1:	5d                   	pop    %ebp
  8025e2:	c3                   	ret    

008025e3 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	57                   	push   %edi
  8025e7:	56                   	push   %esi
  8025e8:	53                   	push   %ebx
  8025e9:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  8025ef:	c7 04 24 3d 1d 80 00 	movl   $0x801d3d,(%esp)
  8025f6:	e8 c0 14 00 00       	call   803abb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  8025fb:	a1 00 10 00 50       	mov    0x50001000,%eax
  802600:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802605:	74 28                	je     80262f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802607:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  80260e:	4a 
  80260f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802613:	c7 44 24 08 5c 44 80 	movl   $0x80445c,0x8(%esp)
  80261a:	00 
  80261b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802622:	00 
  802623:	c7 04 24 d6 43 80 00 	movl   $0x8043d6,(%esp)
  80262a:	e8 6d db ff ff       	call   80019c <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  80262f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802634:	83 f8 03             	cmp    $0x3,%eax
  802637:	7f 1c                	jg     802655 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802639:	c7 44 24 08 90 44 80 	movl   $0x804490,0x8(%esp)
  802640:	00 
  802641:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802648:	00 
  802649:	c7 04 24 d6 43 80 00 	movl   $0x8043d6,(%esp)
  802650:	e8 47 db ff ff       	call   80019c <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802655:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  80265b:	85 d2                	test   %edx,%edx
  80265d:	7f 1c                	jg     80267b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  80265f:	c7 44 24 08 c0 44 80 	movl   $0x8044c0,0x8(%esp)
  802666:	00 
  802667:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  80266e:	00 
  80266f:	c7 04 24 d6 43 80 00 	movl   $0x8043d6,(%esp)
  802676:	e8 21 db ff ff       	call   80019c <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80267b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802681:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802687:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80268d:	85 c9                	test   %ecx,%ecx
  80268f:	0f 48 cb             	cmovs  %ebx,%ecx
  802692:	c1 f9 0c             	sar    $0xc,%ecx
  802695:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802699:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80269f:	39 c8                	cmp    %ecx,%eax
  8026a1:	7c 13                	jl     8026b6 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	7f 3d                	jg     8026e4 <_Z4fsckv+0x101>
  8026a7:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  8026ae:	00 00 00 
  8026b1:	e9 ac 00 00 00       	jmp    802762 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  8026b6:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  8026bc:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  8026c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8026c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026c8:	c7 44 24 08 f0 44 80 	movl   $0x8044f0,0x8(%esp)
  8026cf:	00 
  8026d0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  8026d7:	00 
  8026d8:	c7 04 24 d6 43 80 00 	movl   $0x8043d6,(%esp)
  8026df:	e8 b8 da ff ff       	call   80019c <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8026e4:	be 00 20 00 50       	mov    $0x50002000,%esi
  8026e9:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  8026f0:	00 00 00 
  8026f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026f8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  8026fe:	39 df                	cmp    %ebx,%edi
  802700:	7e 27                	jle    802729 <_Z4fsckv+0x146>
  802702:	0f b6 06             	movzbl (%esi),%eax
  802705:	84 c0                	test   %al,%al
  802707:	74 4b                	je     802754 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802709:	0f be c0             	movsbl %al,%eax
  80270c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802710:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802714:	c7 04 24 34 45 80 00 	movl   $0x804534,(%esp)
  80271b:	e8 9a db ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  802720:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802727:	eb 2b                	jmp    802754 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802729:	0f b6 06             	movzbl (%esi),%eax
  80272c:	3c 01                	cmp    $0x1,%al
  80272e:	76 24                	jbe    802754 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802730:	0f be c0             	movsbl %al,%eax
  802733:	89 44 24 08          	mov    %eax,0x8(%esp)
  802737:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80273b:	c7 04 24 68 45 80 00 	movl   $0x804568,(%esp)
  802742:	e8 73 db ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  802747:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  80274e:	80 3e 00             	cmpb   $0x0,(%esi)
  802751:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802754:	83 c3 01             	add    $0x1,%ebx
  802757:	83 c6 01             	add    $0x1,%esi
  80275a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802760:	7f 9c                	jg     8026fe <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802762:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802769:	0f 8e e1 02 00 00    	jle    802a50 <_Z4fsckv+0x46d>
  80276f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802776:	00 00 00 
		struct Inode *ino = get_inode(i);
  802779:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80277f:	e8 f9 f1 ff ff       	call   80197d <_ZL9get_inodei>
  802784:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80278a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80278e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802795:	75 22                	jne    8027b9 <_Z4fsckv+0x1d6>
  802797:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80279e:	0f 84 a9 06 00 00    	je     802e4d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  8027a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a9:	e8 2d f2 ff ff       	call   8019db <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	74 3a                	je     8027ec <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  8027b2:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  8027b9:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8027bf:	8b 02                	mov    (%edx),%eax
  8027c1:	83 f8 01             	cmp    $0x1,%eax
  8027c4:	74 26                	je     8027ec <_Z4fsckv+0x209>
  8027c6:	83 f8 02             	cmp    $0x2,%eax
  8027c9:	74 21                	je     8027ec <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  8027cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027cf:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8027d5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8027d9:	c7 04 24 94 45 80 00 	movl   $0x804594,(%esp)
  8027e0:	e8 d5 da ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  8027e5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  8027ec:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8027f3:	75 3f                	jne    802834 <_Z4fsckv+0x251>
  8027f5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8027fb:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8027ff:	75 15                	jne    802816 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802801:	c7 04 24 b8 45 80 00 	movl   $0x8045b8,(%esp)
  802808:	e8 ad da ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  80280d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802814:	eb 1e                	jmp    802834 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802816:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80281c:	83 3a 02             	cmpl   $0x2,(%edx)
  80281f:	74 13                	je     802834 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802821:	c7 04 24 ec 45 80 00 	movl   $0x8045ec,(%esp)
  802828:	e8 8d da ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  80282d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802834:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802839:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802840:	0f 84 93 00 00 00    	je     8028d9 <_Z4fsckv+0x2f6>
  802846:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  80284c:	8b 41 08             	mov    0x8(%ecx),%eax
  80284f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802854:	7e 23                	jle    802879 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802856:	89 44 24 08          	mov    %eax,0x8(%esp)
  80285a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802860:	89 44 24 04          	mov    %eax,0x4(%esp)
  802864:	c7 04 24 1c 46 80 00 	movl   $0x80461c,(%esp)
  80286b:	e8 4a da ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  802870:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802877:	eb 09                	jmp    802882 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802879:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802880:	74 4b                	je     8028cd <_Z4fsckv+0x2ea>
  802882:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802888:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80288e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802894:	74 23                	je     8028b9 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802896:	89 44 24 08          	mov    %eax,0x8(%esp)
  80289a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8028a0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028a4:	c7 04 24 40 46 80 00 	movl   $0x804640,(%esp)
  8028ab:	e8 0a da ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  8028b0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8028b7:	eb 09                	jmp    8028c2 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  8028b9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8028c0:	74 12                	je     8028d4 <_Z4fsckv+0x2f1>
  8028c2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8028c8:	8b 78 08             	mov    0x8(%eax),%edi
  8028cb:	eb 0c                	jmp    8028d9 <_Z4fsckv+0x2f6>
  8028cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d2:	eb 05                	jmp    8028d9 <_Z4fsckv+0x2f6>
  8028d4:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  8028d9:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  8028de:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8028e4:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8028e8:	89 d8                	mov    %ebx,%eax
  8028ea:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  8028ed:	39 c7                	cmp    %eax,%edi
  8028ef:	7e 2b                	jle    80291c <_Z4fsckv+0x339>
  8028f1:	85 f6                	test   %esi,%esi
  8028f3:	75 27                	jne    80291c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  8028f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028fd:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802903:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802907:	c7 04 24 64 46 80 00 	movl   $0x804664,(%esp)
  80290e:	e8 a7 d9 ff ff       	call   8002ba <_Z7cprintfPKcz>
				++errors;
  802913:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80291a:	eb 36                	jmp    802952 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  80291c:	39 f8                	cmp    %edi,%eax
  80291e:	7c 32                	jl     802952 <_Z4fsckv+0x36f>
  802920:	85 f6                	test   %esi,%esi
  802922:	74 2e                	je     802952 <_Z4fsckv+0x36f>
  802924:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  80292b:	74 25                	je     802952 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  80292d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802931:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802935:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80293b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80293f:	c7 04 24 a8 46 80 00 	movl   $0x8046a8,(%esp)
  802946:	e8 6f d9 ff ff       	call   8002ba <_Z7cprintfPKcz>
				++errors;
  80294b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802952:	85 f6                	test   %esi,%esi
  802954:	0f 84 a0 00 00 00    	je     8029fa <_Z4fsckv+0x417>
  80295a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802961:	0f 84 93 00 00 00    	je     8029fa <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802967:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  80296d:	7e 27                	jle    802996 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  80296f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802973:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802977:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  80297d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802981:	c7 04 24 ec 46 80 00 	movl   $0x8046ec,(%esp)
  802988:	e8 2d d9 ff ff       	call   8002ba <_Z7cprintfPKcz>
					++errors;
  80298d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802994:	eb 64                	jmp    8029fa <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  802996:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80299d:	3c 01                	cmp    $0x1,%al
  80299f:	75 27                	jne    8029c8 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  8029a1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8029a5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029a9:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8029af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029b3:	c7 04 24 30 47 80 00 	movl   $0x804730,(%esp)
  8029ba:	e8 fb d8 ff ff       	call   8002ba <_Z7cprintfPKcz>
					++errors;
  8029bf:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8029c6:	eb 32                	jmp    8029fa <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  8029c8:	3c ff                	cmp    $0xff,%al
  8029ca:	75 27                	jne    8029f3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  8029cc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8029d0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029d4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8029da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029de:	c7 04 24 6c 47 80 00 	movl   $0x80476c,(%esp)
  8029e5:	e8 d0 d8 ff ff       	call   8002ba <_Z7cprintfPKcz>
					++errors;
  8029ea:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8029f1:	eb 07                	jmp    8029fa <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  8029f3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  8029fa:	83 c3 01             	add    $0x1,%ebx
  8029fd:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  802a03:	0f 85 d5 fe ff ff    	jne    8028de <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  802a09:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802a10:	0f 94 c0             	sete   %al
  802a13:	0f b6 c0             	movzbl %al,%eax
  802a16:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802a1c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  802a22:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  802a29:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  802a30:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802a37:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  802a3e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802a44:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  802a4a:	0f 8f 29 fd ff ff    	jg     802779 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802a50:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802a57:	0f 8e 7f 03 00 00    	jle    802ddc <_Z4fsckv+0x7f9>
  802a5d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  802a62:	89 f0                	mov    %esi,%eax
  802a64:	e8 14 ef ff ff       	call   80197d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  802a69:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802a70:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802a77:	c1 e2 08             	shl    $0x8,%edx
  802a7a:	09 ca                	or     %ecx,%edx
  802a7c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  802a83:	c1 e1 10             	shl    $0x10,%ecx
  802a86:	09 ca                	or     %ecx,%edx
  802a88:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  802a8f:	83 e1 7f             	and    $0x7f,%ecx
  802a92:	c1 e1 18             	shl    $0x18,%ecx
  802a95:	09 d1                	or     %edx,%ecx
  802a97:	74 0e                	je     802aa7 <_Z4fsckv+0x4c4>
  802a99:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  802aa0:	78 05                	js     802aa7 <_Z4fsckv+0x4c4>
  802aa2:	83 38 02             	cmpl   $0x2,(%eax)
  802aa5:	74 1f                	je     802ac6 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802aa7:	83 c6 01             	add    $0x1,%esi
  802aaa:	a1 08 10 00 50       	mov    0x50001008,%eax
  802aaf:	39 f0                	cmp    %esi,%eax
  802ab1:	7f af                	jg     802a62 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802ab3:	bb 01 00 00 00       	mov    $0x1,%ebx
  802ab8:	83 f8 01             	cmp    $0x1,%eax
  802abb:	0f 8f ad 02 00 00    	jg     802d6e <_Z4fsckv+0x78b>
  802ac1:	e9 16 03 00 00       	jmp    802ddc <_Z4fsckv+0x7f9>
  802ac6:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  802ac8:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  802acf:	8b 40 08             	mov    0x8(%eax),%eax
  802ad2:	a8 7f                	test   $0x7f,%al
  802ad4:	74 23                	je     802af9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  802ad6:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  802add:	00 
  802ade:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ae2:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ae6:	c7 04 24 a8 47 80 00 	movl   $0x8047a8,(%esp)
  802aed:	e8 c8 d7 ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  802af2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802af9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  802b00:	00 00 00 
  802b03:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  802b09:	e9 3d 02 00 00       	jmp    802d4b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  802b0e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b14:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802b1a:	e8 01 ee ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
  802b1f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  802b21:	83 38 00             	cmpl   $0x0,(%eax)
  802b24:	0f 84 15 02 00 00    	je     802d3f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  802b2a:	8b 40 04             	mov    0x4(%eax),%eax
  802b2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b30:	83 fa 76             	cmp    $0x76,%edx
  802b33:	76 27                	jbe    802b5c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  802b35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b39:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802b3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b43:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b47:	c7 04 24 dc 47 80 00 	movl   $0x8047dc,(%esp)
  802b4e:	e8 67 d7 ff ff       	call   8002ba <_Z7cprintfPKcz>
				++errors;
  802b53:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802b5a:	eb 28                	jmp    802b84 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  802b5c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  802b61:	74 21                	je     802b84 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  802b63:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802b69:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b6d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b71:	c7 04 24 08 48 80 00 	movl   $0x804808,(%esp)
  802b78:	e8 3d d7 ff ff       	call   8002ba <_Z7cprintfPKcz>
				++errors;
  802b7d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  802b84:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  802b8b:	00 
  802b8c:	8d 43 08             	lea    0x8(%ebx),%eax
  802b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b93:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802b99:	89 0c 24             	mov    %ecx,(%esp)
  802b9c:	e8 56 df ff ff       	call   800af7 <memcpy>
  802ba1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802ba5:	bf 77 00 00 00       	mov    $0x77,%edi
  802baa:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  802bae:	85 ff                	test   %edi,%edi
  802bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb5:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  802bb8:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  802bbf:	00 

			if (de->de_inum >= super->s_ninodes) {
  802bc0:	8b 03                	mov    (%ebx),%eax
  802bc2:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802bc8:	7c 3e                	jl     802c08 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  802bca:	89 44 24 10          	mov    %eax,0x10(%esp)
  802bce:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802bd4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bd8:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802bde:	89 54 24 08          	mov    %edx,0x8(%esp)
  802be2:	89 74 24 04          	mov    %esi,0x4(%esp)
  802be6:	c7 04 24 3c 48 80 00 	movl   $0x80483c,(%esp)
  802bed:	e8 c8 d6 ff ff       	call   8002ba <_Z7cprintfPKcz>
				++errors;
  802bf2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  802bf9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  802c00:	00 00 00 
  802c03:	e9 0b 01 00 00       	jmp    802d13 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  802c08:	e8 70 ed ff ff       	call   80197d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  802c0d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802c14:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  802c1b:	c1 e2 08             	shl    $0x8,%edx
  802c1e:	09 d1                	or     %edx,%ecx
  802c20:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  802c27:	c1 e2 10             	shl    $0x10,%edx
  802c2a:	09 d1                	or     %edx,%ecx
  802c2c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802c33:	83 e2 7f             	and    $0x7f,%edx
  802c36:	c1 e2 18             	shl    $0x18,%edx
  802c39:	09 ca                	or     %ecx,%edx
  802c3b:	83 c2 01             	add    $0x1,%edx
  802c3e:	89 d1                	mov    %edx,%ecx
  802c40:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  802c46:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  802c4c:	0f b6 d5             	movzbl %ch,%edx
  802c4f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  802c55:	89 ca                	mov    %ecx,%edx
  802c57:	c1 ea 10             	shr    $0x10,%edx
  802c5a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  802c60:	c1 e9 18             	shr    $0x18,%ecx
  802c63:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  802c6a:	83 e2 80             	and    $0xffffff80,%edx
  802c6d:	09 ca                	or     %ecx,%edx
  802c6f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  802c75:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802c79:	0f 85 7a ff ff ff    	jne    802bf9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  802c7f:	8b 03                	mov    (%ebx),%eax
  802c81:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c85:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  802c8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802c8f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802c95:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c99:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c9d:	c7 04 24 6c 48 80 00 	movl   $0x80486c,(%esp)
  802ca4:	e8 11 d6 ff ff       	call   8002ba <_Z7cprintfPKcz>
					++errors;
  802ca9:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802cb0:	e9 44 ff ff ff       	jmp    802bf9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802cb5:	3b 78 04             	cmp    0x4(%eax),%edi
  802cb8:	75 52                	jne    802d0c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  802cba:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802cbe:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  802cc4:	89 54 24 04          	mov    %edx,0x4(%esp)
  802cc8:	83 c0 08             	add    $0x8,%eax
  802ccb:	89 04 24             	mov    %eax,(%esp)
  802cce:	e8 65 de ff ff       	call   800b38 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	75 35                	jne    802d0c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  802cd7:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802cdd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ce1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  802ce7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ceb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802cf1:	89 54 24 08          	mov    %edx,0x8(%esp)
  802cf5:	89 74 24 04          	mov    %esi,0x4(%esp)
  802cf9:	c7 04 24 9c 48 80 00 	movl   $0x80489c,(%esp)
  802d00:	e8 b5 d5 ff ff       	call   8002ba <_Z7cprintfPKcz>
					++errors;
  802d05:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802d0c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  802d13:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  802d19:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  802d1f:	7e 1e                	jle    802d3f <_Z4fsckv+0x75c>
  802d21:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  802d25:	7f 18                	jg     802d3f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  802d27:	89 ca                	mov    %ecx,%edx
  802d29:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802d2f:	e8 ec eb ff ff       	call   801920 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  802d34:	83 38 00             	cmpl   $0x0,(%eax)
  802d37:	0f 85 78 ff ff ff    	jne    802cb5 <_Z4fsckv+0x6d2>
  802d3d:	eb cd                	jmp    802d0c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802d3f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  802d45:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802d4b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802d51:	83 ea 80             	sub    $0xffffff80,%edx
  802d54:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  802d5a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802d60:	3b 51 08             	cmp    0x8(%ecx),%edx
  802d63:	0f 8f e7 fc ff ff    	jg     802a50 <_Z4fsckv+0x46d>
  802d69:	e9 a0 fd ff ff       	jmp    802b0e <_Z4fsckv+0x52b>
  802d6e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  802d74:	89 d8                	mov    %ebx,%eax
  802d76:	e8 02 ec ff ff       	call   80197d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  802d7b:	8b 50 04             	mov    0x4(%eax),%edx
  802d7e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  802d85:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  802d8c:	c1 e7 08             	shl    $0x8,%edi
  802d8f:	09 f9                	or     %edi,%ecx
  802d91:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  802d98:	c1 e7 10             	shl    $0x10,%edi
  802d9b:	09 f9                	or     %edi,%ecx
  802d9d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  802da4:	83 e7 7f             	and    $0x7f,%edi
  802da7:	c1 e7 18             	shl    $0x18,%edi
  802daa:	09 f9                	or     %edi,%ecx
  802dac:	39 ca                	cmp    %ecx,%edx
  802dae:	74 1b                	je     802dcb <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  802db0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802db4:	89 54 24 08          	mov    %edx,0x8(%esp)
  802db8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802dbc:	c7 04 24 cc 48 80 00 	movl   $0x8048cc,(%esp)
  802dc3:	e8 f2 d4 ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  802dc8:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  802dcb:	83 c3 01             	add    $0x1,%ebx
  802dce:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  802dd4:	7f 9e                	jg     802d74 <_Z4fsckv+0x791>
  802dd6:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802ddc:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  802de3:	7e 4f                	jle    802e34 <_Z4fsckv+0x851>
  802de5:	bb 00 00 00 00       	mov    $0x0,%ebx
  802dea:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  802df0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  802df7:	3c ff                	cmp    $0xff,%al
  802df9:	75 09                	jne    802e04 <_Z4fsckv+0x821>
			freemap[i] = 0;
  802dfb:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  802e02:	eb 1f                	jmp    802e23 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  802e04:	84 c0                	test   %al,%al
  802e06:	75 1b                	jne    802e23 <_Z4fsckv+0x840>
  802e08:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  802e0e:	7c 13                	jl     802e23 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  802e10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e14:	c7 04 24 f8 48 80 00 	movl   $0x8048f8,(%esp)
  802e1b:	e8 9a d4 ff ff       	call   8002ba <_Z7cprintfPKcz>
			++errors;
  802e20:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  802e23:	83 c3 01             	add    $0x1,%ebx
  802e26:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802e2c:	7f c2                	jg     802df0 <_Z4fsckv+0x80d>
  802e2e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  802e34:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  802e3b:	19 c0                	sbb    %eax,%eax
  802e3d:	f7 d0                	not    %eax
  802e3f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  802e42:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  802e48:	5b                   	pop    %ebx
  802e49:	5e                   	pop    %esi
  802e4a:	5f                   	pop    %edi
  802e4b:	5d                   	pop    %ebp
  802e4c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802e4d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802e54:	0f 84 92 f9 ff ff    	je     8027ec <_Z4fsckv+0x209>
  802e5a:	e9 5a f9 ff ff       	jmp    8027b9 <_Z4fsckv+0x1d6>
	...

00802e60 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e60:	55                   	push   %ebp
  802e61:	89 e5                	mov    %esp,%ebp
  802e63:	83 ec 18             	sub    $0x18,%esp
  802e66:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802e69:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802e6c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	89 04 24             	mov    %eax,(%esp)
  802e75:	e8 a2 e4 ff ff       	call   80131c <_Z7fd2dataP2Fd>
  802e7a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802e7c:	c7 44 24 04 2b 49 80 	movl   $0x80492b,0x4(%esp)
  802e83:	00 
  802e84:	89 34 24             	mov    %esi,(%esp)
  802e87:	e8 4e da ff ff       	call   8008da <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  802e8c:	8b 43 04             	mov    0x4(%ebx),%eax
  802e8f:	2b 03                	sub    (%ebx),%eax
  802e91:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  802e94:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  802e9b:	c7 86 80 00 00 00 20 	movl   $0x805020,0x80(%esi)
  802ea2:	50 80 00 
	return 0;
}
  802ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eaa:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802ead:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802eb0:	89 ec                	mov    %ebp,%esp
  802eb2:	5d                   	pop    %ebp
  802eb3:	c3                   	ret    

00802eb4 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  802eb4:	55                   	push   %ebp
  802eb5:	89 e5                	mov    %esp,%ebp
  802eb7:	53                   	push   %ebx
  802eb8:	83 ec 14             	sub    $0x14,%esp
  802ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802ebe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ec2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ec9:	e8 af df ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  802ece:	89 1c 24             	mov    %ebx,(%esp)
  802ed1:	e8 46 e4 ff ff       	call   80131c <_Z7fd2dataP2Fd>
  802ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ee1:	e8 97 df ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
}
  802ee6:	83 c4 14             	add    $0x14,%esp
  802ee9:	5b                   	pop    %ebx
  802eea:	5d                   	pop    %ebp
  802eeb:	c3                   	ret    

00802eec <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
  802eef:	57                   	push   %edi
  802ef0:	56                   	push   %esi
  802ef1:	53                   	push   %ebx
  802ef2:	83 ec 2c             	sub    $0x2c,%esp
  802ef5:	89 c7                	mov    %eax,%edi
  802ef7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  802efa:	a1 00 60 80 00       	mov    0x806000,%eax
  802eff:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  802f02:	89 3c 24             	mov    %edi,(%esp)
  802f05:	e8 82 04 00 00       	call   80338c <_Z7pagerefPv>
  802f0a:	89 c3                	mov    %eax,%ebx
  802f0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0f:	89 04 24             	mov    %eax,(%esp)
  802f12:	e8 75 04 00 00       	call   80338c <_Z7pagerefPv>
  802f17:	39 c3                	cmp    %eax,%ebx
  802f19:	0f 94 c0             	sete   %al
  802f1c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  802f1f:	8b 15 00 60 80 00    	mov    0x806000,%edx
  802f25:	8b 52 58             	mov    0x58(%edx),%edx
  802f28:	39 d6                	cmp    %edx,%esi
  802f2a:	75 08                	jne    802f34 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  802f2c:	83 c4 2c             	add    $0x2c,%esp
  802f2f:	5b                   	pop    %ebx
  802f30:	5e                   	pop    %esi
  802f31:	5f                   	pop    %edi
  802f32:	5d                   	pop    %ebp
  802f33:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 c2                	je     802efa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  802f38:	c7 04 24 32 49 80 00 	movl   $0x804932,(%esp)
  802f3f:	e8 76 d3 ff ff       	call   8002ba <_Z7cprintfPKcz>
  802f44:	eb b4                	jmp    802efa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00802f46 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f46:	55                   	push   %ebp
  802f47:	89 e5                	mov    %esp,%ebp
  802f49:	57                   	push   %edi
  802f4a:	56                   	push   %esi
  802f4b:	53                   	push   %ebx
  802f4c:	83 ec 1c             	sub    $0x1c,%esp
  802f4f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802f52:	89 34 24             	mov    %esi,(%esp)
  802f55:	e8 c2 e3 ff ff       	call   80131c <_Z7fd2dataP2Fd>
  802f5a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802f5c:	bf 00 00 00 00       	mov    $0x0,%edi
  802f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802f65:	75 46                	jne    802fad <_ZL13devpipe_writeP2FdPKvj+0x67>
  802f67:	eb 52                	jmp    802fbb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  802f69:	89 da                	mov    %ebx,%edx
  802f6b:	89 f0                	mov    %esi,%eax
  802f6d:	e8 7a ff ff ff       	call   802eec <_ZL13_pipeisclosedP2FdP4Pipe>
  802f72:	85 c0                	test   %eax,%eax
  802f74:	75 49                	jne    802fbf <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  802f76:	e8 11 de ff ff       	call   800d8c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  802f7b:	8b 43 04             	mov    0x4(%ebx),%eax
  802f7e:	89 c2                	mov    %eax,%edx
  802f80:	2b 13                	sub    (%ebx),%edx
  802f82:	83 fa 20             	cmp    $0x20,%edx
  802f85:	74 e2                	je     802f69 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f87:	89 c2                	mov    %eax,%edx
  802f89:	c1 fa 1f             	sar    $0x1f,%edx
  802f8c:	c1 ea 1b             	shr    $0x1b,%edx
  802f8f:	01 d0                	add    %edx,%eax
  802f91:	83 e0 1f             	and    $0x1f,%eax
  802f94:	29 d0                	sub    %edx,%eax
  802f96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f99:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  802f9d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  802fa1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802fa5:	83 c7 01             	add    $0x1,%edi
  802fa8:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802fab:	76 0e                	jbe    802fbb <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  802fad:	8b 43 04             	mov    0x4(%ebx),%eax
  802fb0:	89 c2                	mov    %eax,%edx
  802fb2:	2b 13                	sub    (%ebx),%edx
  802fb4:	83 fa 20             	cmp    $0x20,%edx
  802fb7:	74 b0                	je     802f69 <_ZL13devpipe_writeP2FdPKvj+0x23>
  802fb9:	eb cc                	jmp    802f87 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  802fbb:	89 f8                	mov    %edi,%eax
  802fbd:	eb 05                	jmp    802fc4 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  802fbf:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  802fc4:	83 c4 1c             	add    $0x1c,%esp
  802fc7:	5b                   	pop    %ebx
  802fc8:	5e                   	pop    %esi
  802fc9:	5f                   	pop    %edi
  802fca:	5d                   	pop    %ebp
  802fcb:	c3                   	ret    

00802fcc <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802fcc:	55                   	push   %ebp
  802fcd:	89 e5                	mov    %esp,%ebp
  802fcf:	83 ec 28             	sub    $0x28,%esp
  802fd2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802fd5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802fd8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802fdb:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  802fde:	89 3c 24             	mov    %edi,(%esp)
  802fe1:	e8 36 e3 ff ff       	call   80131c <_Z7fd2dataP2Fd>
  802fe6:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  802fe8:	be 00 00 00 00       	mov    $0x0,%esi
  802fed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ff1:	75 47                	jne    80303a <_ZL12devpipe_readP2FdPvj+0x6e>
  802ff3:	eb 52                	jmp    803047 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  802ff5:	89 f0                	mov    %esi,%eax
  802ff7:	eb 5e                	jmp    803057 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  802ff9:	89 da                	mov    %ebx,%edx
  802ffb:	89 f8                	mov    %edi,%eax
  802ffd:	8d 76 00             	lea    0x0(%esi),%esi
  803000:	e8 e7 fe ff ff       	call   802eec <_ZL13_pipeisclosedP2FdP4Pipe>
  803005:	85 c0                	test   %eax,%eax
  803007:	75 49                	jne    803052 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803009:	e8 7e dd ff ff       	call   800d8c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80300e:	8b 03                	mov    (%ebx),%eax
  803010:	3b 43 04             	cmp    0x4(%ebx),%eax
  803013:	74 e4                	je     802ff9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803015:	89 c2                	mov    %eax,%edx
  803017:	c1 fa 1f             	sar    $0x1f,%edx
  80301a:	c1 ea 1b             	shr    $0x1b,%edx
  80301d:	01 d0                	add    %edx,%eax
  80301f:	83 e0 1f             	and    $0x1f,%eax
  803022:	29 d0                	sub    %edx,%eax
  803024:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80302f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803032:	83 c6 01             	add    $0x1,%esi
  803035:	39 75 10             	cmp    %esi,0x10(%ebp)
  803038:	76 0d                	jbe    803047 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80303a:	8b 03                	mov    (%ebx),%eax
  80303c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80303f:	75 d4                	jne    803015 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803041:	85 f6                	test   %esi,%esi
  803043:	75 b0                	jne    802ff5 <_ZL12devpipe_readP2FdPvj+0x29>
  803045:	eb b2                	jmp    802ff9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803047:	89 f0                	mov    %esi,%eax
  803049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803050:	eb 05                	jmp    803057 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803052:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803057:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80305a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80305d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803060:	89 ec                	mov    %ebp,%esp
  803062:	5d                   	pop    %ebp
  803063:	c3                   	ret    

00803064 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803064:	55                   	push   %ebp
  803065:	89 e5                	mov    %esp,%ebp
  803067:	83 ec 48             	sub    $0x48,%esp
  80306a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80306d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803070:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803073:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803076:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803079:	89 04 24             	mov    %eax,(%esp)
  80307c:	e8 b6 e2 ff ff       	call   801337 <_Z14fd_find_unusedPP2Fd>
  803081:	89 c3                	mov    %eax,%ebx
  803083:	85 c0                	test   %eax,%eax
  803085:	0f 88 0b 01 00 00    	js     803196 <_Z4pipePi+0x132>
  80308b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803092:	00 
  803093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803096:	89 44 24 04          	mov    %eax,0x4(%esp)
  80309a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030a1:	e8 1a dd ff ff       	call   800dc0 <_Z14sys_page_allociPvi>
  8030a6:	89 c3                	mov    %eax,%ebx
  8030a8:	85 c0                	test   %eax,%eax
  8030aa:	0f 89 f5 00 00 00    	jns    8031a5 <_Z4pipePi+0x141>
  8030b0:	e9 e1 00 00 00       	jmp    803196 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8030b5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030bc:	00 
  8030bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030cb:	e8 f0 dc ff ff       	call   800dc0 <_Z14sys_page_allociPvi>
  8030d0:	89 c3                	mov    %eax,%ebx
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	0f 89 e2 00 00 00    	jns    8031bc <_Z4pipePi+0x158>
  8030da:	e9 a4 00 00 00       	jmp    803183 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e2:	89 04 24             	mov    %eax,(%esp)
  8030e5:	e8 32 e2 ff ff       	call   80131c <_Z7fd2dataP2Fd>
  8030ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8030f1:	00 
  8030f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8030fd:	00 
  8030fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  803102:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803109:	e8 11 dd ff ff       	call   800e1f <_Z12sys_page_mapiPviS_i>
  80310e:	89 c3                	mov    %eax,%ebx
  803110:	85 c0                	test   %eax,%eax
  803112:	78 4c                	js     803160 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803114:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80311a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80311f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803122:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803129:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80312f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803132:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803137:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80313e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803141:	89 04 24             	mov    %eax,(%esp)
  803144:	e8 8b e1 ff ff       	call   8012d4 <_Z6fd2numP2Fd>
  803149:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80314b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80314e:	89 04 24             	mov    %eax,(%esp)
  803151:	e8 7e e1 ff ff       	call   8012d4 <_Z6fd2numP2Fd>
  803156:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803159:	bb 00 00 00 00       	mov    $0x0,%ebx
  80315e:	eb 36                	jmp    803196 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803160:	89 74 24 04          	mov    %esi,0x4(%esp)
  803164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80316b:	e8 0d dd ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803170:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803173:	89 44 24 04          	mov    %eax,0x4(%esp)
  803177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80317e:	e8 fa dc ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803186:	89 44 24 04          	mov    %eax,0x4(%esp)
  80318a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803191:	e8 e7 dc ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803196:	89 d8                	mov    %ebx,%eax
  803198:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80319b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80319e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8031a1:	89 ec                	mov    %ebp,%esp
  8031a3:	5d                   	pop    %ebp
  8031a4:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8031a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8031a8:	89 04 24             	mov    %eax,(%esp)
  8031ab:	e8 87 e1 ff ff       	call   801337 <_Z14fd_find_unusedPP2Fd>
  8031b0:	89 c3                	mov    %eax,%ebx
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	0f 89 fb fe ff ff    	jns    8030b5 <_Z4pipePi+0x51>
  8031ba:	eb c7                	jmp    803183 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8031bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bf:	89 04 24             	mov    %eax,(%esp)
  8031c2:	e8 55 e1 ff ff       	call   80131c <_Z7fd2dataP2Fd>
  8031c7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031c9:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031d0:	00 
  8031d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031dc:	e8 df db ff ff       	call   800dc0 <_Z14sys_page_allociPvi>
  8031e1:	89 c3                	mov    %eax,%ebx
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	0f 89 f4 fe ff ff    	jns    8030df <_Z4pipePi+0x7b>
  8031eb:	eb 83                	jmp    803170 <_Z4pipePi+0x10c>

008031ed <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  8031ed:	55                   	push   %ebp
  8031ee:	89 e5                	mov    %esp,%ebp
  8031f0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8031f3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8031fa:	00 
  8031fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	89 04 24             	mov    %eax,(%esp)
  803208:	e8 74 e0 ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  80320d:	85 c0                	test   %eax,%eax
  80320f:	78 15                	js     803226 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	89 04 24             	mov    %eax,(%esp)
  803217:	e8 00 e1 ff ff       	call   80131c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80321c:	89 c2                	mov    %eax,%edx
  80321e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803221:	e8 c6 fc ff ff       	call   802eec <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803226:	c9                   	leave  
  803227:	c3                   	ret    

00803228 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803228:	55                   	push   %ebp
  803229:	89 e5                	mov    %esp,%ebp
  80322b:	53                   	push   %ebx
  80322c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80322f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803232:	89 04 24             	mov    %eax,(%esp)
  803235:	e8 fd e0 ff ff       	call   801337 <_Z14fd_find_unusedPP2Fd>
  80323a:	89 c3                	mov    %eax,%ebx
  80323c:	85 c0                	test   %eax,%eax
  80323e:	0f 88 be 00 00 00    	js     803302 <_Z18pipe_ipc_recv_readv+0xda>
  803244:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80324b:	00 
  80324c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803253:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80325a:	e8 61 db ff ff       	call   800dc0 <_Z14sys_page_allociPvi>
  80325f:	89 c3                	mov    %eax,%ebx
  803261:	85 c0                	test   %eax,%eax
  803263:	0f 89 a1 00 00 00    	jns    80330a <_Z18pipe_ipc_recv_readv+0xe2>
  803269:	e9 94 00 00 00       	jmp    803302 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80326e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803271:	85 c0                	test   %eax,%eax
  803273:	75 0e                	jne    803283 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803275:	c7 04 24 90 49 80 00 	movl   $0x804990,(%esp)
  80327c:	e8 39 d0 ff ff       	call   8002ba <_Z7cprintfPKcz>
  803281:	eb 10                	jmp    803293 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803283:	89 44 24 04          	mov    %eax,0x4(%esp)
  803287:	c7 04 24 45 49 80 00 	movl   $0x804945,(%esp)
  80328e:	e8 27 d0 ff ff       	call   8002ba <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803293:	c7 04 24 4f 49 80 00 	movl   $0x80494f,(%esp)
  80329a:	e8 1b d0 ff ff       	call   8002ba <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80329f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a2:	a8 04                	test   $0x4,%al
  8032a4:	74 04                	je     8032aa <_Z18pipe_ipc_recv_readv+0x82>
  8032a6:	a8 01                	test   $0x1,%al
  8032a8:	75 24                	jne    8032ce <_Z18pipe_ipc_recv_readv+0xa6>
  8032aa:	c7 44 24 0c 62 49 80 	movl   $0x804962,0xc(%esp)
  8032b1:	00 
  8032b2:	c7 44 24 08 2c 43 80 	movl   $0x80432c,0x8(%esp)
  8032b9:	00 
  8032ba:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8032c1:	00 
  8032c2:	c7 04 24 7f 49 80 00 	movl   $0x80497f,(%esp)
  8032c9:	e8 ce ce ff ff       	call   80019c <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  8032ce:	8b 15 20 50 80 00    	mov    0x805020,%edx
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  8032e3:	89 04 24             	mov    %eax,(%esp)
  8032e6:	e8 e9 df ff ff       	call   8012d4 <_Z6fd2numP2Fd>
  8032eb:	89 c3                	mov    %eax,%ebx
  8032ed:	eb 13                	jmp    803302 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032fd:	e8 7b db ff ff       	call   800e7d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803302:	89 d8                	mov    %ebx,%eax
  803304:	83 c4 24             	add    $0x24,%esp
  803307:	5b                   	pop    %ebx
  803308:	5d                   	pop    %ebp
  803309:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330d:	89 04 24             	mov    %eax,(%esp)
  803310:	e8 07 e0 ff ff       	call   80131c <_Z7fd2dataP2Fd>
  803315:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803318:	89 54 24 08          	mov    %edx,0x8(%esp)
  80331c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803320:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803323:	89 04 24             	mov    %eax,(%esp)
  803326:	e8 85 08 00 00       	call   803bb0 <_Z8ipc_recvPiPvS_>
  80332b:	89 c3                	mov    %eax,%ebx
  80332d:	85 c0                	test   %eax,%eax
  80332f:	0f 89 39 ff ff ff    	jns    80326e <_Z18pipe_ipc_recv_readv+0x46>
  803335:	eb b8                	jmp    8032ef <_Z18pipe_ipc_recv_readv+0xc7>

00803337 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803337:	55                   	push   %ebp
  803338:	89 e5                	mov    %esp,%ebp
  80333a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  80333d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803344:	00 
  803345:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80334c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334f:	89 04 24             	mov    %eax,(%esp)
  803352:	e8 2a df ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  803357:	85 c0                	test   %eax,%eax
  803359:	78 2f                	js     80338a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	89 04 24             	mov    %eax,(%esp)
  803361:	e8 b6 df ff ff       	call   80131c <_Z7fd2dataP2Fd>
  803366:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80336d:	00 
  80336e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803372:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803379:	00 
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	89 04 24             	mov    %eax,(%esp)
  803380:	e8 ba 08 00 00       	call   803c3f <_Z8ipc_sendijPvi>
    return 0;
  803385:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80338a:	c9                   	leave  
  80338b:	c3                   	ret    

0080338c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80338c:	55                   	push   %ebp
  80338d:	89 e5                	mov    %esp,%ebp
  80338f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803392:	89 d0                	mov    %edx,%eax
  803394:	c1 e8 16             	shr    $0x16,%eax
  803397:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  80339e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8033a3:	f6 c1 01             	test   $0x1,%cl
  8033a6:	74 1d                	je     8033c5 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  8033a8:	c1 ea 0c             	shr    $0xc,%edx
  8033ab:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8033b2:	f6 c2 01             	test   $0x1,%dl
  8033b5:	74 0e                	je     8033c5 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8033b7:	c1 ea 0c             	shr    $0xc,%edx
  8033ba:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  8033c1:	ef 
  8033c2:	0f b7 c0             	movzwl %ax,%eax
}
  8033c5:	5d                   	pop    %ebp
  8033c6:	c3                   	ret    
	...

008033d0 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8033d0:	55                   	push   %ebp
  8033d1:	89 e5                	mov    %esp,%ebp
  8033d3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8033d6:	c7 44 24 04 b3 49 80 	movl   $0x8049b3,0x4(%esp)
  8033dd:	00 
  8033de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e1:	89 04 24             	mov    %eax,(%esp)
  8033e4:	e8 f1 d4 ff ff       	call   8008da <_Z6strcpyPcPKc>
	return 0;
}
  8033e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ee:	c9                   	leave  
  8033ef:	c3                   	ret    

008033f0 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8033f0:	55                   	push   %ebp
  8033f1:	89 e5                	mov    %esp,%ebp
  8033f3:	53                   	push   %ebx
  8033f4:	83 ec 14             	sub    $0x14,%esp
  8033f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8033fa:	89 1c 24             	mov    %ebx,(%esp)
  8033fd:	e8 8a ff ff ff       	call   80338c <_Z7pagerefPv>
  803402:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803404:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803409:	83 fa 01             	cmp    $0x1,%edx
  80340c:	75 0b                	jne    803419 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80340e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803411:	89 04 24             	mov    %eax,(%esp)
  803414:	e8 fe 02 00 00       	call   803717 <_Z11nsipc_closei>
	else
		return 0;
}
  803419:	83 c4 14             	add    $0x14,%esp
  80341c:	5b                   	pop    %ebx
  80341d:	5d                   	pop    %ebp
  80341e:	c3                   	ret    

0080341f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80341f:	55                   	push   %ebp
  803420:	89 e5                	mov    %esp,%ebp
  803422:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803425:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80342c:	00 
  80342d:	8b 45 10             	mov    0x10(%ebp),%eax
  803430:	89 44 24 08          	mov    %eax,0x8(%esp)
  803434:	8b 45 0c             	mov    0xc(%ebp),%eax
  803437:	89 44 24 04          	mov    %eax,0x4(%esp)
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	8b 40 0c             	mov    0xc(%eax),%eax
  803441:	89 04 24             	mov    %eax,(%esp)
  803444:	e8 c9 03 00 00       	call   803812 <_Z10nsipc_sendiPKvij>
}
  803449:	c9                   	leave  
  80344a:	c3                   	ret    

0080344b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80344b:	55                   	push   %ebp
  80344c:	89 e5                	mov    %esp,%ebp
  80344e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803451:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803458:	00 
  803459:	8b 45 10             	mov    0x10(%ebp),%eax
  80345c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803460:	8b 45 0c             	mov    0xc(%ebp),%eax
  803463:	89 44 24 04          	mov    %eax,0x4(%esp)
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	8b 40 0c             	mov    0xc(%eax),%eax
  80346d:	89 04 24             	mov    %eax,(%esp)
  803470:	e8 1d 03 00 00       	call   803792 <_Z10nsipc_recviPvij>
}
  803475:	c9                   	leave  
  803476:	c3                   	ret    

00803477 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803477:	55                   	push   %ebp
  803478:	89 e5                	mov    %esp,%ebp
  80347a:	83 ec 28             	sub    $0x28,%esp
  80347d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803480:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803483:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803485:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803488:	89 04 24             	mov    %eax,(%esp)
  80348b:	e8 a7 de ff ff       	call   801337 <_Z14fd_find_unusedPP2Fd>
  803490:	89 c3                	mov    %eax,%ebx
  803492:	85 c0                	test   %eax,%eax
  803494:	78 21                	js     8034b7 <_ZL12alloc_sockfdi+0x40>
  803496:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80349d:	00 
  80349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034ac:	e8 0f d9 ff ff       	call   800dc0 <_Z14sys_page_allociPvi>
  8034b1:	89 c3                	mov    %eax,%ebx
  8034b3:	85 c0                	test   %eax,%eax
  8034b5:	79 14                	jns    8034cb <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8034b7:	89 34 24             	mov    %esi,(%esp)
  8034ba:	e8 58 02 00 00       	call   803717 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  8034bf:	89 d8                	mov    %ebx,%eax
  8034c1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8034c4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8034c7:	89 ec                	mov    %ebp,%esp
  8034c9:	5d                   	pop    %ebp
  8034ca:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  8034cb:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8034d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8034e0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8034e3:	89 04 24             	mov    %eax,(%esp)
  8034e6:	e8 e9 dd ff ff       	call   8012d4 <_Z6fd2numP2Fd>
  8034eb:	89 c3                	mov    %eax,%ebx
  8034ed:	eb d0                	jmp    8034bf <_ZL12alloc_sockfdi+0x48>

008034ef <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  8034ef:	55                   	push   %ebp
  8034f0:	89 e5                	mov    %esp,%ebp
  8034f2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  8034f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8034fc:	00 
  8034fd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803500:	89 54 24 04          	mov    %edx,0x4(%esp)
  803504:	89 04 24             	mov    %eax,(%esp)
  803507:	e8 75 dd ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  80350c:	85 c0                	test   %eax,%eax
  80350e:	78 15                	js     803525 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803510:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803513:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803518:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80351e:	39 0a                	cmp    %ecx,(%edx)
  803520:	75 03                	jne    803525 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803522:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803525:	c9                   	leave  
  803526:	c3                   	ret    

00803527 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803527:	55                   	push   %ebp
  803528:	89 e5                	mov    %esp,%ebp
  80352a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80352d:	8b 45 08             	mov    0x8(%ebp),%eax
  803530:	e8 ba ff ff ff       	call   8034ef <_ZL9fd2sockidi>
  803535:	85 c0                	test   %eax,%eax
  803537:	78 1f                	js     803558 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803539:	8b 55 10             	mov    0x10(%ebp),%edx
  80353c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803540:	8b 55 0c             	mov    0xc(%ebp),%edx
  803543:	89 54 24 04          	mov    %edx,0x4(%esp)
  803547:	89 04 24             	mov    %eax,(%esp)
  80354a:	e8 19 01 00 00       	call   803668 <_Z12nsipc_acceptiP8sockaddrPj>
  80354f:	85 c0                	test   %eax,%eax
  803551:	78 05                	js     803558 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803553:	e8 1f ff ff ff       	call   803477 <_ZL12alloc_sockfdi>
}
  803558:	c9                   	leave  
  803559:	c3                   	ret    

0080355a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80355a:	55                   	push   %ebp
  80355b:	89 e5                	mov    %esp,%ebp
  80355d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	e8 87 ff ff ff       	call   8034ef <_ZL9fd2sockidi>
  803568:	85 c0                	test   %eax,%eax
  80356a:	78 16                	js     803582 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80356c:	8b 55 10             	mov    0x10(%ebp),%edx
  80356f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803573:	8b 55 0c             	mov    0xc(%ebp),%edx
  803576:	89 54 24 04          	mov    %edx,0x4(%esp)
  80357a:	89 04 24             	mov    %eax,(%esp)
  80357d:	e8 34 01 00 00       	call   8036b6 <_Z10nsipc_bindiP8sockaddrj>
}
  803582:	c9                   	leave  
  803583:	c3                   	ret    

00803584 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803584:	55                   	push   %ebp
  803585:	89 e5                	mov    %esp,%ebp
  803587:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	e8 5d ff ff ff       	call   8034ef <_ZL9fd2sockidi>
  803592:	85 c0                	test   %eax,%eax
  803594:	78 0f                	js     8035a5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803596:	8b 55 0c             	mov    0xc(%ebp),%edx
  803599:	89 54 24 04          	mov    %edx,0x4(%esp)
  80359d:	89 04 24             	mov    %eax,(%esp)
  8035a0:	e8 50 01 00 00       	call   8036f5 <_Z14nsipc_shutdownii>
}
  8035a5:	c9                   	leave  
  8035a6:	c3                   	ret    

008035a7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8035a7:	55                   	push   %ebp
  8035a8:	89 e5                	mov    %esp,%ebp
  8035aa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	e8 3a ff ff ff       	call   8034ef <_ZL9fd2sockidi>
  8035b5:	85 c0                	test   %eax,%eax
  8035b7:	78 16                	js     8035cf <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8035b9:	8b 55 10             	mov    0x10(%ebp),%edx
  8035bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8035c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8035c7:	89 04 24             	mov    %eax,(%esp)
  8035ca:	e8 62 01 00 00       	call   803731 <_Z13nsipc_connectiPK8sockaddrj>
}
  8035cf:	c9                   	leave  
  8035d0:	c3                   	ret    

008035d1 <_Z6listenii>:

int
listen(int s, int backlog)
{
  8035d1:	55                   	push   %ebp
  8035d2:	89 e5                	mov    %esp,%ebp
  8035d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035da:	e8 10 ff ff ff       	call   8034ef <_ZL9fd2sockidi>
  8035df:	85 c0                	test   %eax,%eax
  8035e1:	78 0f                	js     8035f2 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8035e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8035ea:	89 04 24             	mov    %eax,(%esp)
  8035ed:	e8 7e 01 00 00       	call   803770 <_Z12nsipc_listenii>
}
  8035f2:	c9                   	leave  
  8035f3:	c3                   	ret    

008035f4 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8035f4:	55                   	push   %ebp
  8035f5:	89 e5                	mov    %esp,%ebp
  8035f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8035fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8035fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  803601:	8b 45 0c             	mov    0xc(%ebp),%eax
  803604:	89 44 24 04          	mov    %eax,0x4(%esp)
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	89 04 24             	mov    %eax,(%esp)
  80360e:	e8 72 02 00 00       	call   803885 <_Z12nsipc_socketiii>
  803613:	85 c0                	test   %eax,%eax
  803615:	78 05                	js     80361c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803617:	e8 5b fe ff ff       	call   803477 <_ZL12alloc_sockfdi>
}
  80361c:	c9                   	leave  
  80361d:	8d 76 00             	lea    0x0(%esi),%esi
  803620:	c3                   	ret    
  803621:	00 00                	add    %al,(%eax)
	...

00803624 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803624:	55                   	push   %ebp
  803625:	89 e5                	mov    %esp,%ebp
  803627:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80362a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803631:	00 
  803632:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803639:	00 
  80363a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80363e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803645:	e8 f5 05 00 00       	call   803c3f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  80364a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803651:	00 
  803652:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803659:	00 
  80365a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803661:	e8 4a 05 00 00       	call   803bb0 <_Z8ipc_recvPiPvS_>
}
  803666:	c9                   	leave  
  803667:	c3                   	ret    

00803668 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803668:	55                   	push   %ebp
  803669:	89 e5                	mov    %esp,%ebp
  80366b:	53                   	push   %ebx
  80366c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803677:	b8 01 00 00 00       	mov    $0x1,%eax
  80367c:	e8 a3 ff ff ff       	call   803624 <_ZL5nsipcj>
  803681:	89 c3                	mov    %eax,%ebx
  803683:	85 c0                	test   %eax,%eax
  803685:	78 27                	js     8036ae <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803687:	a1 10 70 80 00       	mov    0x807010,%eax
  80368c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803690:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803697:	00 
  803698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369b:	89 04 24             	mov    %eax,(%esp)
  80369e:	e8 d9 d3 ff ff       	call   800a7c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  8036a3:	8b 15 10 70 80 00    	mov    0x807010,%edx
  8036a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8036ac:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8036ae:	89 d8                	mov    %ebx,%eax
  8036b0:	83 c4 14             	add    $0x14,%esp
  8036b3:	5b                   	pop    %ebx
  8036b4:	5d                   	pop    %ebp
  8036b5:	c3                   	ret    

008036b6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036b6:	55                   	push   %ebp
  8036b7:	89 e5                	mov    %esp,%ebp
  8036b9:	53                   	push   %ebx
  8036ba:	83 ec 14             	sub    $0x14,%esp
  8036bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c3:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8036c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036d3:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8036da:	e8 9d d3 ff ff       	call   800a7c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8036df:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8036e5:	b8 02 00 00 00       	mov    $0x2,%eax
  8036ea:	e8 35 ff ff ff       	call   803624 <_ZL5nsipcj>
}
  8036ef:	83 c4 14             	add    $0x14,%esp
  8036f2:	5b                   	pop    %ebx
  8036f3:	5d                   	pop    %ebp
  8036f4:	c3                   	ret    

008036f5 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  8036f5:	55                   	push   %ebp
  8036f6:	89 e5                	mov    %esp,%ebp
  8036f8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803703:	8b 45 0c             	mov    0xc(%ebp),%eax
  803706:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80370b:	b8 03 00 00 00       	mov    $0x3,%eax
  803710:	e8 0f ff ff ff       	call   803624 <_ZL5nsipcj>
}
  803715:	c9                   	leave  
  803716:	c3                   	ret    

00803717 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803717:	55                   	push   %ebp
  803718:	89 e5                	mov    %esp,%ebp
  80371a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80371d:	8b 45 08             	mov    0x8(%ebp),%eax
  803720:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803725:	b8 04 00 00 00       	mov    $0x4,%eax
  80372a:	e8 f5 fe ff ff       	call   803624 <_ZL5nsipcj>
}
  80372f:	c9                   	leave  
  803730:	c3                   	ret    

00803731 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803731:	55                   	push   %ebp
  803732:	89 e5                	mov    %esp,%ebp
  803734:	53                   	push   %ebx
  803735:	83 ec 14             	sub    $0x14,%esp
  803738:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80373b:	8b 45 08             	mov    0x8(%ebp),%eax
  80373e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803743:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80374e:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803755:	e8 22 d3 ff ff       	call   800a7c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80375a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803760:	b8 05 00 00 00       	mov    $0x5,%eax
  803765:	e8 ba fe ff ff       	call   803624 <_ZL5nsipcj>
}
  80376a:	83 c4 14             	add    $0x14,%esp
  80376d:	5b                   	pop    %ebx
  80376e:	5d                   	pop    %ebp
  80376f:	c3                   	ret    

00803770 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803770:	55                   	push   %ebp
  803771:	89 e5                	mov    %esp,%ebp
  803773:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803776:	8b 45 08             	mov    0x8(%ebp),%eax
  803779:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80377e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803781:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803786:	b8 06 00 00 00       	mov    $0x6,%eax
  80378b:	e8 94 fe ff ff       	call   803624 <_ZL5nsipcj>
}
  803790:	c9                   	leave  
  803791:	c3                   	ret    

00803792 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803792:	55                   	push   %ebp
  803793:	89 e5                	mov    %esp,%ebp
  803795:	56                   	push   %esi
  803796:	53                   	push   %ebx
  803797:	83 ec 10             	sub    $0x10,%esp
  80379a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80379d:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8037a5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8037ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8037ae:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8037b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8037b8:	e8 67 fe ff ff       	call   803624 <_ZL5nsipcj>
  8037bd:	89 c3                	mov    %eax,%ebx
  8037bf:	85 c0                	test   %eax,%eax
  8037c1:	78 46                	js     803809 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  8037c3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8037c8:	7f 04                	jg     8037ce <_Z10nsipc_recviPvij+0x3c>
  8037ca:	39 f0                	cmp    %esi,%eax
  8037cc:	7e 24                	jle    8037f2 <_Z10nsipc_recviPvij+0x60>
  8037ce:	c7 44 24 0c bf 49 80 	movl   $0x8049bf,0xc(%esp)
  8037d5:	00 
  8037d6:	c7 44 24 08 2c 43 80 	movl   $0x80432c,0x8(%esp)
  8037dd:	00 
  8037de:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8037e5:	00 
  8037e6:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  8037ed:	e8 aa c9 ff ff       	call   80019c <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8037f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037f6:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8037fd:	00 
  8037fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803801:	89 04 24             	mov    %eax,(%esp)
  803804:	e8 73 d2 ff ff       	call   800a7c <memmove>
	}

	return r;
}
  803809:	89 d8                	mov    %ebx,%eax
  80380b:	83 c4 10             	add    $0x10,%esp
  80380e:	5b                   	pop    %ebx
  80380f:	5e                   	pop    %esi
  803810:	5d                   	pop    %ebp
  803811:	c3                   	ret    

00803812 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803812:	55                   	push   %ebp
  803813:	89 e5                	mov    %esp,%ebp
  803815:	53                   	push   %ebx
  803816:	83 ec 14             	sub    $0x14,%esp
  803819:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803824:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80382a:	7e 24                	jle    803850 <_Z10nsipc_sendiPKvij+0x3e>
  80382c:	c7 44 24 0c e0 49 80 	movl   $0x8049e0,0xc(%esp)
  803833:	00 
  803834:	c7 44 24 08 2c 43 80 	movl   $0x80432c,0x8(%esp)
  80383b:	00 
  80383c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803843:	00 
  803844:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  80384b:	e8 4c c9 ff ff       	call   80019c <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803850:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803854:	8b 45 0c             	mov    0xc(%ebp),%eax
  803857:	89 44 24 04          	mov    %eax,0x4(%esp)
  80385b:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803862:	e8 15 d2 ff ff       	call   800a7c <memmove>
	nsipcbuf.send.req_size = size;
  803867:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80386d:	8b 45 14             	mov    0x14(%ebp),%eax
  803870:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803875:	b8 08 00 00 00       	mov    $0x8,%eax
  80387a:	e8 a5 fd ff ff       	call   803624 <_ZL5nsipcj>
}
  80387f:	83 c4 14             	add    $0x14,%esp
  803882:	5b                   	pop    %ebx
  803883:	5d                   	pop    %ebp
  803884:	c3                   	ret    

00803885 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803885:	55                   	push   %ebp
  803886:	89 e5                	mov    %esp,%ebp
  803888:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80388b:	8b 45 08             	mov    0x8(%ebp),%eax
  80388e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803893:	8b 45 0c             	mov    0xc(%ebp),%eax
  803896:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80389b:	8b 45 10             	mov    0x10(%ebp),%eax
  80389e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8038a3:	b8 09 00 00 00       	mov    $0x9,%eax
  8038a8:	e8 77 fd ff ff       	call   803624 <_ZL5nsipcj>
}
  8038ad:	c9                   	leave  
  8038ae:	c3                   	ret    
	...

008038b0 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8038b0:	55                   	push   %ebp
  8038b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8038b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b8:	5d                   	pop    %ebp
  8038b9:	c3                   	ret    

008038ba <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8038ba:	55                   	push   %ebp
  8038bb:	89 e5                	mov    %esp,%ebp
  8038bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8038c0:	c7 44 24 04 ec 49 80 	movl   $0x8049ec,0x4(%esp)
  8038c7:	00 
  8038c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038cb:	89 04 24             	mov    %eax,(%esp)
  8038ce:	e8 07 d0 ff ff       	call   8008da <_Z6strcpyPcPKc>
	return 0;
}
  8038d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d8:	c9                   	leave  
  8038d9:	c3                   	ret    

008038da <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038da:	55                   	push   %ebp
  8038db:	89 e5                	mov    %esp,%ebp
  8038dd:	57                   	push   %edi
  8038de:	56                   	push   %esi
  8038df:	53                   	push   %ebx
  8038e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8038eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8038ef:	74 3e                	je     80392f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8038f1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8038f7:	8b 75 10             	mov    0x10(%ebp),%esi
  8038fa:	29 de                	sub    %ebx,%esi
  8038fc:	83 fe 7f             	cmp    $0x7f,%esi
  8038ff:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803904:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803907:	89 74 24 08          	mov    %esi,0x8(%esp)
  80390b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80390e:	01 d8                	add    %ebx,%eax
  803910:	89 44 24 04          	mov    %eax,0x4(%esp)
  803914:	89 3c 24             	mov    %edi,(%esp)
  803917:	e8 60 d1 ff ff       	call   800a7c <memmove>
		sys_cputs(buf, m);
  80391c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803920:	89 3c 24             	mov    %edi,(%esp)
  803923:	e8 6c d3 ff ff       	call   800c94 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803928:	01 f3                	add    %esi,%ebx
  80392a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  80392d:	77 c8                	ja     8038f7 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80392f:	89 d8                	mov    %ebx,%eax
  803931:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803937:	5b                   	pop    %ebx
  803938:	5e                   	pop    %esi
  803939:	5f                   	pop    %edi
  80393a:	5d                   	pop    %ebp
  80393b:	c3                   	ret    

0080393c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80393c:	55                   	push   %ebp
  80393d:	89 e5                	mov    %esp,%ebp
  80393f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803942:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803947:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80394b:	75 07                	jne    803954 <_ZL12devcons_readP2FdPvj+0x18>
  80394d:	eb 2a                	jmp    803979 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80394f:	e8 38 d4 ff ff       	call   800d8c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803954:	e8 6e d3 ff ff       	call   800cc7 <_Z9sys_cgetcv>
  803959:	85 c0                	test   %eax,%eax
  80395b:	74 f2                	je     80394f <_ZL12devcons_readP2FdPvj+0x13>
  80395d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80395f:	85 c0                	test   %eax,%eax
  803961:	78 16                	js     803979 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803963:	83 f8 04             	cmp    $0x4,%eax
  803966:	74 0c                	je     803974 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80396b:	88 10                	mov    %dl,(%eax)
	return 1;
  80396d:	b8 01 00 00 00       	mov    $0x1,%eax
  803972:	eb 05                	jmp    803979 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803974:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803979:	c9                   	leave  
  80397a:	c3                   	ret    

0080397b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80397b:	55                   	push   %ebp
  80397c:	89 e5                	mov    %esp,%ebp
  80397e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803981:	8b 45 08             	mov    0x8(%ebp),%eax
  803984:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803987:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80398e:	00 
  80398f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803992:	89 04 24             	mov    %eax,(%esp)
  803995:	e8 fa d2 ff ff       	call   800c94 <_Z9sys_cputsPKcj>
}
  80399a:	c9                   	leave  
  80399b:	c3                   	ret    

0080399c <_Z7getcharv>:

int
getchar(void)
{
  80399c:	55                   	push   %ebp
  80399d:	89 e5                	mov    %esp,%ebp
  80399f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8039a2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8039a9:	00 
  8039aa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8039ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039b8:	e8 71 dc ff ff       	call   80162e <_Z4readiPvj>
	if (r < 0)
  8039bd:	85 c0                	test   %eax,%eax
  8039bf:	78 0f                	js     8039d0 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  8039c1:	85 c0                	test   %eax,%eax
  8039c3:	7e 06                	jle    8039cb <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  8039c5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8039c9:	eb 05                	jmp    8039d0 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8039cb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8039d0:	c9                   	leave  
  8039d1:	c3                   	ret    

008039d2 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  8039d2:	55                   	push   %ebp
  8039d3:	89 e5                	mov    %esp,%ebp
  8039d5:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8039d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8039df:	00 
  8039e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8039e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ea:	89 04 24             	mov    %eax,(%esp)
  8039ed:	e8 8f d8 ff ff       	call   801281 <_Z9fd_lookupiPP2Fdb>
  8039f2:	85 c0                	test   %eax,%eax
  8039f4:	78 11                	js     803a07 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  8039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f9:	8b 15 58 50 80 00    	mov    0x805058,%edx
  8039ff:	39 10                	cmp    %edx,(%eax)
  803a01:	0f 94 c0             	sete   %al
  803a04:	0f b6 c0             	movzbl %al,%eax
}
  803a07:	c9                   	leave  
  803a08:	c3                   	ret    

00803a09 <_Z8openconsv>:

int
opencons(void)
{
  803a09:	55                   	push   %ebp
  803a0a:	89 e5                	mov    %esp,%ebp
  803a0c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803a0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a12:	89 04 24             	mov    %eax,(%esp)
  803a15:	e8 1d d9 ff ff       	call   801337 <_Z14fd_find_unusedPP2Fd>
  803a1a:	85 c0                	test   %eax,%eax
  803a1c:	78 3c                	js     803a5a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803a1e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803a25:	00 
  803a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a34:	e8 87 d3 ff ff       	call   800dc0 <_Z14sys_page_allociPvi>
  803a39:	85 c0                	test   %eax,%eax
  803a3b:	78 1d                	js     803a5a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803a3d:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a46:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803a52:	89 04 24             	mov    %eax,(%esp)
  803a55:	e8 7a d8 ff ff       	call   8012d4 <_Z6fd2numP2Fd>
}
  803a5a:	c9                   	leave  
  803a5b:	c3                   	ret    
  803a5c:	00 00                	add    %al,(%eax)
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
  803a6d:	8b 04 9d 00 80 80 00 	mov    0x808000(,%ebx,4),%eax
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
  803a8e:	e8 c5 d2 ff ff       	call   800d58 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803a93:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803a97:	89 74 24 10          	mov    %esi,0x10(%esp)
  803a9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a9f:	c7 44 24 08 f8 49 80 	movl   $0x8049f8,0x8(%esp)
  803aa6:	00 
  803aa7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803aae:	00 
  803aaf:	c7 04 24 7c 4a 80 00 	movl   $0x804a7c,(%esp)
  803ab6:	e8 e1 c6 ff ff       	call   80019c <_Z6_panicPKciS0_z>

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
  803ac6:	e8 8d d2 ff ff       	call   800d58 <_Z12sys_getenvidv>
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
  803aec:	e8 cf d2 ff ff       	call   800dc0 <_Z14sys_page_allociPvi>
  803af1:	85 c0                	test   %eax,%eax
  803af3:	74 20                	je     803b15 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803af5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803af9:	c7 44 24 08 30 4a 80 	movl   $0x804a30,0x8(%esp)
  803b00:	00 
  803b01:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803b08:	00 
  803b09:	c7 04 24 7c 4a 80 00 	movl   $0x804a7c,(%esp)
  803b10:	e8 87 c6 ff ff       	call   80019c <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803b15:	c7 44 24 04 60 3a 80 	movl   $0x803a60,0x4(%esp)
  803b1c:	00 
  803b1d:	89 34 24             	mov    %esi,(%esp)
  803b20:	e8 d0 d4 ff ff       	call   800ff5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803b25:	a1 00 80 80 00       	mov    0x808000,%eax
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
  803b37:	8b 14 85 00 80 80 00 	mov    0x808000(,%eax,4),%edx
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
  803b57:	89 1c 85 00 80 80 00 	mov    %ebx,0x808000(,%eax,4)
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
  803b71:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  803b78:	00 
  803b79:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803b80:	00 
  803b81:	c7 04 24 7c 4a 80 00 	movl   $0x804a7c,(%esp)
  803b88:	e8 0f c6 ff ff       	call   80019c <_Z6_panicPKciS0_z>
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
  803bce:	e8 b8 d4 ff ff       	call   80108b <_Z12sys_ipc_recvPv>
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
  803bf1:	e8 62 d1 ff ff       	call   800d58 <_Z12sys_getenvidv>
  803bf6:	25 ff 03 00 00       	and    $0x3ff,%eax
  803bfb:	6b c0 78             	imul   $0x78,%eax,%eax
  803bfe:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  803c03:	8b 40 60             	mov    0x60(%eax),%eax
  803c06:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  803c08:	85 f6                	test   %esi,%esi
  803c0a:	74 17                	je     803c23 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  803c0c:	e8 47 d1 ff ff       	call   800d58 <_Z12sys_getenvidv>
  803c11:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c16:	6b c0 78             	imul   $0x78,%eax,%eax
  803c19:	05 00 00 00 ef       	add    $0xef000000,%eax
  803c1e:	8b 40 70             	mov    0x70(%eax),%eax
  803c21:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  803c23:	e8 30 d1 ff ff       	call   800d58 <_Z12sys_getenvidv>
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
  803c6d:	e8 e1 d3 ff ff       	call   801053 <_Z16sys_ipc_try_sendijPvi>
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
  803c80:	e8 07 d1 ff ff       	call   800d8c <_Z9sys_yieldv>
  803c85:	eb d4                	jmp    803c5b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  803c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c8b:	c7 44 24 08 8a 4a 80 	movl   $0x804a8a,0x8(%esp)
  803c92:	00 
  803c93:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  803c9a:	00 
  803c9b:	c7 04 24 97 4a 80 00 	movl   $0x804a97,(%esp)
  803ca2:	e8 f5 c4 ff ff       	call   80019c <_Z6_panicPKciS0_z>
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
