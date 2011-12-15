
obj/user/lsfd:     file format elf32-i386


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
  80002c:	e8 1b 01 00 00       	call   80014c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <_Z5usagev>:
#include <inc/lib.h>

void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800046:	c7 04 24 e0 41 80 00 	movl   $0x8041e0,(%esp)
  80004d:	e8 2c 02 00 00       	call   80027e <_Z7cprintfPKcz>
	exit();
  800052:	e8 5d 01 00 00       	call   8001b4 <_Z4exitv>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <_Z5umainiPPc>:

void
umain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	56                   	push   %esi
  80005e:	53                   	push   %ebx
  80005f:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800065:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800068:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80006f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800073:	8d 45 08             	lea    0x8(%ebp),%eax
  800076:	89 04 24             	mov    %eax,(%esp)
  800079:	e8 36 11 00 00       	call   8011b4 <_Z8argstartPiPPcP8Argstate>
}

void
umain(int argc, char **argv)
{
	int i, usefprint = 0;
  80007e:	bf 00 00 00 00       	mov    $0x0,%edi
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800083:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800086:	eb 11                	jmp    800099 <_Z5umainiPPc+0x40>
		if (i == '1')
  800088:	83 f8 31             	cmp    $0x31,%eax
  80008b:	74 07                	je     800094 <_Z5umainiPPc+0x3b>
			usefprint = 1;
		else
			usage();
  80008d:	e8 ae ff ff ff       	call   800040 <_Z5usagev>
  800092:	eb 05                	jmp    800099 <_Z5umainiPPc+0x40>
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
		if (i == '1')
			usefprint = 1;
  800094:	bf 01 00 00 00       	mov    $0x1,%edi
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800099:	89 1c 24             	mov    %ebx,(%esp)
  80009c:	e8 43 11 00 00       	call   8011e4 <_Z7argnextP8Argstate>
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	79 e3                	jns    800088 <_Z5umainiPPc+0x2f>
  8000a5:	bb 00 00 00 00       	mov    $0x0,%ebx
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000aa:	8d b5 54 ff ff ff    	lea    -0xac(%ebp),%esi
  8000b0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000b4:	89 1c 24             	mov    %ebx,(%esp)
  8000b7:	e8 b1 18 00 00       	call   80196d <_Z5fstatiP4Stat>
  8000bc:	85 c0                	test   %eax,%eax
  8000be:	78 74                	js     800134 <_Z5umainiPPc+0xdb>
			if (usefprint)
  8000c0:	85 ff                	test   %edi,%edi
  8000c2:	74 3d                	je     800101 <_Z5umainiPPc+0xa8>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_ftype == FTYPE_DIR,
					st.st_size, st.st_dev->dev_name);
  8000c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c7:	8b 40 04             	mov    0x4(%eax),%eax
  8000ca:	89 44 24 18          	mov    %eax,0x18(%esp)
  8000ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000d1:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000d5:	83 7d d0 02          	cmpl   $0x2,-0x30(%ebp)
  8000d9:	0f 94 c0             	sete   %al
  8000dc:	0f b6 c0             	movzbl %al,%eax
  8000df:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000eb:	c7 44 24 04 f4 41 80 	movl   $0x8041f4,0x4(%esp)
  8000f2:	00 
  8000f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fa:	e8 a1 34 00 00       	call   8035a0 <_Z7fprintfiPKcz>
  8000ff:	eb 33                	jmp    800134 <_Z5umainiPPc+0xdb>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_ftype == FTYPE_DIR,
					st.st_size, st.st_dev->dev_name);
  800101:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800104:	8b 40 04             	mov    0x4(%eax),%eax
  800107:	89 44 24 14          	mov    %eax,0x14(%esp)
  80010b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80010e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800112:	83 7d d0 02          	cmpl   $0x2,-0x30(%ebp)
  800116:	0f 94 c0             	sete   %al
  800119:	0f b6 c0             	movzbl %al,%eax
  80011c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800120:	89 74 24 08          	mov    %esi,0x8(%esp)
  800124:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800128:	c7 04 24 f4 41 80 00 	movl   $0x8041f4,(%esp)
  80012f:	e8 4a 01 00 00       	call   80027e <_Z7cprintfPKcz>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  800134:	83 c3 01             	add    $0x1,%ebx
  800137:	83 fb 20             	cmp    $0x20,%ebx
  80013a:	0f 85 70 ff ff ff    	jne    8000b0 <_Z5umainiPPc+0x57>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_ftype == FTYPE_DIR,
					st.st_size, st.st_dev->dev_name);
		}
}
  800140:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  800146:	5b                   	pop    %ebx
  800147:	5e                   	pop    %esi
  800148:	5f                   	pop    %edi
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    
	...

0080014c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	57                   	push   %edi
  800150:	56                   	push   %esi
  800151:	53                   	push   %ebx
  800152:	83 ec 1c             	sub    $0x1c,%esp
  800155:	8b 7d 08             	mov    0x8(%ebp),%edi
  800158:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  80015b:	e8 b8 0b 00 00       	call   800d18 <_Z12sys_getenvidv>
  800160:	25 ff 03 00 00       	and    $0x3ff,%eax
  800165:	6b c0 78             	imul   $0x78,%eax,%eax
  800168:	05 00 00 00 ef       	add    $0xef000000,%eax
  80016d:	a3 00 60 80 00       	mov    %eax,0x806000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800172:	85 ff                	test   %edi,%edi
  800174:	7e 07                	jle    80017d <libmain+0x31>
		binaryname = argv[0];
  800176:	8b 06                	mov    (%esi),%eax
  800178:	a3 00 50 80 00       	mov    %eax,0x805000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80017d:	b8 4d 4d 80 00       	mov    $0x804d4d,%eax
  800182:	3d 4d 4d 80 00       	cmp    $0x804d4d,%eax
  800187:	76 0f                	jbe    800198 <libmain+0x4c>
  800189:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80018b:	83 eb 04             	sub    $0x4,%ebx
  80018e:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800190:	81 fb 4d 4d 80 00    	cmp    $0x804d4d,%ebx
  800196:	77 f3                	ja     80018b <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800198:	89 74 24 04          	mov    %esi,0x4(%esp)
  80019c:	89 3c 24             	mov    %edi,(%esp)
  80019f:	e8 b5 fe ff ff       	call   800059 <_Z5umainiPPc>

	// exit gracefully
	exit();
  8001a4:	e8 0b 00 00 00       	call   8001b4 <_Z4exitv>
}
  8001a9:	83 c4 1c             	add    $0x1c,%esp
  8001ac:	5b                   	pop    %ebx
  8001ad:	5e                   	pop    %esi
  8001ae:	5f                   	pop    %edi
  8001af:	5d                   	pop    %ebp
  8001b0:	c3                   	ret    
  8001b1:	00 00                	add    %al,(%eax)
	...

008001b4 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001ba:	e8 1f 14 00 00       	call   8015de <_Z9close_allv>
	sys_env_destroy(0);
  8001bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001c6:	e8 f0 0a 00 00       	call   800cbb <_Z15sys_env_destroyi>
}
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    
  8001cd:	00 00                	add    %al,(%eax)
	...

008001d0 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 18             	sub    $0x18,%esp
  8001d6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001d9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  8001df:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8001e1:	8b 03                	mov    (%ebx),%eax
  8001e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001ea:	83 c0 01             	add    $0x1,%eax
  8001ed:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001ef:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f4:	75 19                	jne    80020f <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8001f6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001fd:	00 
  8001fe:	8d 43 08             	lea    0x8(%ebx),%eax
  800201:	89 04 24             	mov    %eax,(%esp)
  800204:	e8 4b 0a 00 00       	call   800c54 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800209:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80020f:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800213:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800216:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800219:	89 ec                	mov    %ebp,%esp
  80021b:	5d                   	pop    %ebp
  80021c:	c3                   	ret    

0080021d <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800226:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022d:	00 00 00 
	b.cnt = 0;
  800230:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800237:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80023a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800241:	8b 45 08             	mov    0x8(%ebp),%eax
  800244:	89 44 24 08          	mov    %eax,0x8(%esp)
  800248:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800252:	c7 04 24 d0 01 80 00 	movl   $0x8001d0,(%esp)
  800259:	e8 a9 01 00 00       	call   800407 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80025e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800264:	89 44 24 04          	mov    %eax,0x4(%esp)
  800268:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026e:	89 04 24             	mov    %eax,(%esp)
  800271:	e8 de 09 00 00       	call   800c54 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800276:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800284:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028b:	8b 45 08             	mov    0x8(%ebp),%eax
  80028e:	89 04 24             	mov    %eax,(%esp)
  800291:	e8 87 ff ff ff       	call   80021d <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800296:	c9                   	leave  
  800297:	c3                   	ret    
	...

008002a0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 4c             	sub    $0x4c,%esp
  8002a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ac:	89 d6                	mov    %edx,%esi
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002bd:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c5:	39 d0                	cmp    %edx,%eax
  8002c7:	72 11                	jb     8002da <_ZL8printnumPFviPvES_yjii+0x3a>
  8002c9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002cc:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  8002cf:	76 09                	jbe    8002da <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002d1:	83 eb 01             	sub    $0x1,%ebx
  8002d4:	85 db                	test   %ebx,%ebx
  8002d6:	7f 5d                	jg     800335 <_ZL8printnumPFviPvES_yjii+0x95>
  8002d8:	eb 6c                	jmp    800346 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002da:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002de:	83 eb 01             	sub    $0x1,%ebx
  8002e1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002f0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002f7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8002fa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800301:	00 
  800302:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800305:	89 14 24             	mov    %edx,(%esp)
  800308:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80030b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80030f:	e8 5c 3c 00 00       	call   803f70 <__udivdi3>
  800314:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800317:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80031a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80031e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800322:	89 04 24             	mov    %eax,(%esp)
  800325:	89 54 24 04          	mov    %edx,0x4(%esp)
  800329:	89 f2                	mov    %esi,%edx
  80032b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80032e:	e8 6d ff ff ff       	call   8002a0 <_ZL8printnumPFviPvES_yjii>
  800333:	eb 11                	jmp    800346 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800335:	89 74 24 04          	mov    %esi,0x4(%esp)
  800339:	89 3c 24             	mov    %edi,(%esp)
  80033c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80033f:	83 eb 01             	sub    $0x1,%ebx
  800342:	85 db                	test   %ebx,%ebx
  800344:	7f ef                	jg     800335 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800346:	89 74 24 04          	mov    %esi,0x4(%esp)
  80034a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80034e:	8b 45 10             	mov    0x10(%ebp),%eax
  800351:	89 44 24 08          	mov    %eax,0x8(%esp)
  800355:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80035c:	00 
  80035d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800360:	89 14 24             	mov    %edx,(%esp)
  800363:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800366:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80036a:	e8 11 3d 00 00       	call   804080 <__umoddi3>
  80036f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800373:	0f be 80 26 42 80 00 	movsbl 0x804226(%eax),%eax
  80037a:	89 04 24             	mov    %eax,(%esp)
  80037d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800380:	83 c4 4c             	add    $0x4c,%esp
  800383:	5b                   	pop    %ebx
  800384:	5e                   	pop    %esi
  800385:	5f                   	pop    %edi
  800386:	5d                   	pop    %ebp
  800387:	c3                   	ret    

00800388 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80038b:	83 fa 01             	cmp    $0x1,%edx
  80038e:	7e 0e                	jle    80039e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800390:	8b 10                	mov    (%eax),%edx
  800392:	8d 4a 08             	lea    0x8(%edx),%ecx
  800395:	89 08                	mov    %ecx,(%eax)
  800397:	8b 02                	mov    (%edx),%eax
  800399:	8b 52 04             	mov    0x4(%edx),%edx
  80039c:	eb 22                	jmp    8003c0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80039e:	85 d2                	test   %edx,%edx
  8003a0:	74 10                	je     8003b2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  8003a2:	8b 10                	mov    (%eax),%edx
  8003a4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a7:	89 08                	mov    %ecx,(%eax)
  8003a9:	8b 02                	mov    (%edx),%eax
  8003ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b0:	eb 0e                	jmp    8003c0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003b2:	8b 10                	mov    (%eax),%edx
  8003b4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003b7:	89 08                	mov    %ecx,(%eax)
  8003b9:	8b 02                	mov    (%edx),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003c0:	5d                   	pop    %ebp
  8003c1:	c3                   	ret    

008003c2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8003c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003cc:	8b 10                	mov    (%eax),%edx
  8003ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d1:	73 0a                	jae    8003dd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8003d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d6:	88 0a                	mov    %cl,(%edx)
  8003d8:	83 c2 01             	add    $0x1,%edx
  8003db:	89 10                	mov    %edx,(%eax)
}
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003e5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	89 04 24             	mov    %eax,(%esp)
  800400:	e8 02 00 00 00       	call   800407 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	57                   	push   %edi
  80040b:	56                   	push   %esi
  80040c:	53                   	push   %ebx
  80040d:	83 ec 3c             	sub    $0x3c,%esp
  800410:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800413:	8b 55 10             	mov    0x10(%ebp),%edx
  800416:	0f b6 02             	movzbl (%edx),%eax
  800419:	89 d3                	mov    %edx,%ebx
  80041b:	83 c3 01             	add    $0x1,%ebx
  80041e:	83 f8 25             	cmp    $0x25,%eax
  800421:	74 2b                	je     80044e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800423:	85 c0                	test   %eax,%eax
  800425:	75 10                	jne    800437 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800427:	e9 a5 03 00 00       	jmp    8007d1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80042c:	85 c0                	test   %eax,%eax
  80042e:	66 90                	xchg   %ax,%ax
  800430:	75 08                	jne    80043a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800432:	e9 9a 03 00 00       	jmp    8007d1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800437:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80043a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80043e:	89 04 24             	mov    %eax,(%esp)
  800441:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800443:	0f b6 03             	movzbl (%ebx),%eax
  800446:	83 c3 01             	add    $0x1,%ebx
  800449:	83 f8 25             	cmp    $0x25,%eax
  80044c:	75 de                	jne    80042c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80044e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800452:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800459:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80045e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800465:	b9 00 00 00 00       	mov    $0x0,%ecx
  80046a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80046d:	eb 2b                	jmp    80049a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800472:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800476:	eb 22                	jmp    80049a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80047b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80047f:	eb 19                	jmp    80049a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800484:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80048b:	eb 0d                	jmp    80049a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80048d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800490:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800493:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	0f b6 03             	movzbl (%ebx),%eax
  80049d:	0f b6 d0             	movzbl %al,%edx
  8004a0:	8d 73 01             	lea    0x1(%ebx),%esi
  8004a3:	89 75 10             	mov    %esi,0x10(%ebp)
  8004a6:	83 e8 23             	sub    $0x23,%eax
  8004a9:	3c 55                	cmp    $0x55,%al
  8004ab:	0f 87 d8 02 00 00    	ja     800789 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  8004b1:	0f b6 c0             	movzbl %al,%eax
  8004b4:	ff 24 85 c0 43 80 00 	jmp    *0x8043c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004bb:	83 ea 30             	sub    $0x30,%edx
  8004be:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8004c1:	8b 55 10             	mov    0x10(%ebp),%edx
  8004c4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8004c7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8004cd:	83 fa 09             	cmp    $0x9,%edx
  8004d0:	77 4e                	ja     800520 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004d5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8004d8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8004db:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8004df:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  8004e2:	8d 50 d0             	lea    -0x30(%eax),%edx
  8004e5:	83 fa 09             	cmp    $0x9,%edx
  8004e8:	76 eb                	jbe    8004d5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  8004ea:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004ed:	eb 31                	jmp    800520 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8d 50 04             	lea    0x4(%eax),%edx
  8004f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800500:	eb 1e                	jmp    800520 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800502:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800506:	0f 88 75 ff ff ff    	js     800481 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80050f:	eb 89                	jmp    80049a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800511:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800514:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80051b:	e9 7a ff ff ff       	jmp    80049a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800520:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800524:	0f 89 70 ff ff ff    	jns    80049a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80052a:	e9 5e ff ff ff       	jmp    80048d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80052f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800532:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800535:	e9 60 ff ff ff       	jmp    80049a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8d 50 04             	lea    0x4(%eax),%edx
  800540:	89 55 14             	mov    %edx,0x14(%ebp)
  800543:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 04 24             	mov    %eax,(%esp)
  80054c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80054f:	e9 bf fe ff ff       	jmp    800413 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8d 50 04             	lea    0x4(%eax),%edx
  80055a:	89 55 14             	mov    %edx,0x14(%ebp)
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	89 c2                	mov    %eax,%edx
  800561:	c1 fa 1f             	sar    $0x1f,%edx
  800564:	31 d0                	xor    %edx,%eax
  800566:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800568:	83 f8 14             	cmp    $0x14,%eax
  80056b:	7f 0f                	jg     80057c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80056d:	8b 14 85 20 45 80 00 	mov    0x804520(,%eax,4),%edx
  800574:	85 d2                	test   %edx,%edx
  800576:	0f 85 35 02 00 00    	jne    8007b1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80057c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800580:	c7 44 24 08 3e 42 80 	movl   $0x80423e,0x8(%esp)
  800587:	00 
  800588:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058c:	8b 75 08             	mov    0x8(%ebp),%esi
  80058f:	89 34 24             	mov    %esi,(%esp)
  800592:	e8 48 fe ff ff       	call   8003df <_Z8printfmtPFviPvES_PKcz>
  800597:	e9 77 fe ff ff       	jmp    800413 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80059c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8d 50 04             	lea    0x4(%eax),%edx
  8005ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ae:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  8005b0:	85 db                	test   %ebx,%ebx
  8005b2:	ba 37 42 80 00       	mov    $0x804237,%edx
  8005b7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  8005ba:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005be:	7e 72                	jle    800632 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8005c0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8005c4:	74 6c                	je     800632 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ca:	89 1c 24             	mov    %ebx,(%esp)
  8005cd:	e8 a9 02 00 00       	call   80087b <_Z7strnlenPKcj>
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	29 c2                	sub    %eax,%edx
  8005d7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005da:	85 d2                	test   %edx,%edx
  8005dc:	7e 54                	jle    800632 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  8005de:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  8005e2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8005e5:	89 d3                	mov    %edx,%ebx
  8005e7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8005ea:	89 c6                	mov    %eax,%esi
  8005ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f0:	89 34 24             	mov    %esi,(%esp)
  8005f3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f6:	83 eb 01             	sub    $0x1,%ebx
  8005f9:	85 db                	test   %ebx,%ebx
  8005fb:	7f ef                	jg     8005ec <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  8005fd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800600:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800603:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80060a:	eb 26                	jmp    800632 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80060c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80060f:	83 fa 5e             	cmp    $0x5e,%edx
  800612:	76 10                	jbe    800624 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800614:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800618:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80061f:	ff 55 08             	call   *0x8(%ebp)
  800622:	eb 0a                	jmp    80062e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800624:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800628:	89 04 24             	mov    %eax,(%esp)
  80062b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800632:	0f be 03             	movsbl (%ebx),%eax
  800635:	83 c3 01             	add    $0x1,%ebx
  800638:	85 c0                	test   %eax,%eax
  80063a:	74 11                	je     80064d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80063c:	85 f6                	test   %esi,%esi
  80063e:	78 05                	js     800645 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800640:	83 ee 01             	sub    $0x1,%esi
  800643:	78 0d                	js     800652 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800645:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800649:	75 c1                	jne    80060c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80064b:	eb d7                	jmp    800624 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800650:	eb 03                	jmp    800655 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800655:	85 c0                	test   %eax,%eax
  800657:	0f 8e b6 fd ff ff    	jle    800413 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80065d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800660:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800663:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800667:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80066e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800670:	83 eb 01             	sub    $0x1,%ebx
  800673:	85 db                	test   %ebx,%ebx
  800675:	7f ec                	jg     800663 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800677:	e9 97 fd ff ff       	jmp    800413 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80067c:	83 f9 01             	cmp    $0x1,%ecx
  80067f:	90                   	nop
  800680:	7e 10                	jle    800692 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8d 50 08             	lea    0x8(%eax),%edx
  800688:	89 55 14             	mov    %edx,0x14(%ebp)
  80068b:	8b 18                	mov    (%eax),%ebx
  80068d:	8b 70 04             	mov    0x4(%eax),%esi
  800690:	eb 26                	jmp    8006b8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800692:	85 c9                	test   %ecx,%ecx
  800694:	74 12                	je     8006a8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 50 04             	lea    0x4(%eax),%edx
  80069c:	89 55 14             	mov    %edx,0x14(%ebp)
  80069f:	8b 18                	mov    (%eax),%ebx
  8006a1:	89 de                	mov    %ebx,%esi
  8006a3:	c1 fe 1f             	sar    $0x1f,%esi
  8006a6:	eb 10                	jmp    8006b8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 50 04             	lea    0x4(%eax),%edx
  8006ae:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b1:	8b 18                	mov    (%eax),%ebx
  8006b3:	89 de                	mov    %ebx,%esi
  8006b5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006b8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006bd:	85 f6                	test   %esi,%esi
  8006bf:	0f 89 8c 00 00 00    	jns    800751 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8006c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006d0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006d3:	f7 db                	neg    %ebx
  8006d5:	83 d6 00             	adc    $0x0,%esi
  8006d8:	f7 de                	neg    %esi
			}
			base = 10;
  8006da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006df:	eb 70                	jmp    800751 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e1:	89 ca                	mov    %ecx,%edx
  8006e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e6:	e8 9d fc ff ff       	call   800388 <_ZL7getuintPPci>
  8006eb:	89 c3                	mov    %eax,%ebx
  8006ed:	89 d6                	mov    %edx,%esi
			base = 10;
  8006ef:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8006f4:	eb 5b                	jmp    800751 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006f6:	89 ca                	mov    %ecx,%edx
  8006f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006fb:	e8 88 fc ff ff       	call   800388 <_ZL7getuintPPci>
  800700:	89 c3                	mov    %eax,%ebx
  800702:	89 d6                	mov    %edx,%esi
			base = 8;
  800704:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800709:	eb 46                	jmp    800751 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80070b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800716:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800719:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800724:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 50 04             	lea    0x4(%eax),%edx
  80072d:	89 55 14             	mov    %edx,0x14(%ebp)
  800730:	8b 18                	mov    (%eax),%ebx
  800732:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800737:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80073c:	eb 13                	jmp    800751 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80073e:	89 ca                	mov    %ecx,%edx
  800740:	8d 45 14             	lea    0x14(%ebp),%eax
  800743:	e8 40 fc ff ff       	call   800388 <_ZL7getuintPPci>
  800748:	89 c3                	mov    %eax,%ebx
  80074a:	89 d6                	mov    %edx,%esi
			base = 16;
  80074c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800751:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800755:	89 54 24 10          	mov    %edx,0x10(%esp)
  800759:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80075c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800760:	89 44 24 08          	mov    %eax,0x8(%esp)
  800764:	89 1c 24             	mov    %ebx,(%esp)
  800767:	89 74 24 04          	mov    %esi,0x4(%esp)
  80076b:	89 fa                	mov    %edi,%edx
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	e8 2b fb ff ff       	call   8002a0 <_ZL8printnumPFviPvES_yjii>
			break;
  800775:	e9 99 fc ff ff       	jmp    800413 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80077a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077e:	89 14 24             	mov    %edx,(%esp)
  800781:	ff 55 08             	call   *0x8(%ebp)
			break;
  800784:	e9 8a fc ff ff       	jmp    800413 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800789:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800794:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800797:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80079a:	89 d8                	mov    %ebx,%eax
  80079c:	eb 02                	jmp    8007a0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80079e:	89 d0                	mov    %edx,%eax
  8007a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8007a3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a7:	75 f5                	jne    80079e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  8007a9:	89 45 10             	mov    %eax,0x10(%ebp)
  8007ac:	e9 62 fc ff ff       	jmp    800413 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007b5:	c7 44 24 08 be 45 80 	movl   $0x8045be,0x8(%esp)
  8007bc:	00 
  8007bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c4:	89 34 24             	mov    %esi,(%esp)
  8007c7:	e8 13 fc ff ff       	call   8003df <_Z8printfmtPFviPvES_PKcz>
  8007cc:	e9 42 fc ff ff       	jmp    800413 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007d1:	83 c4 3c             	add    $0x3c,%esp
  8007d4:	5b                   	pop    %ebx
  8007d5:	5e                   	pop    %esi
  8007d6:	5f                   	pop    %edi
  8007d7:	5d                   	pop    %ebp
  8007d8:	c3                   	ret    

008007d9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d9:	55                   	push   %ebp
  8007da:	89 e5                	mov    %esp,%ebp
  8007dc:	83 ec 28             	sub    $0x28,%esp
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8007ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ef:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  8007f6:	85 c0                	test   %eax,%eax
  8007f8:	74 30                	je     80082a <_Z9vsnprintfPciPKcS_+0x51>
  8007fa:	85 d2                	test   %edx,%edx
  8007fc:	7e 2c                	jle    80082a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800805:	8b 45 10             	mov    0x10(%ebp),%eax
  800808:	89 44 24 08          	mov    %eax,0x8(%esp)
  80080c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80080f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800813:	c7 04 24 c2 03 80 00 	movl   $0x8003c2,(%esp)
  80081a:	e8 e8 fb ff ff       	call   800407 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80081f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800822:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800828:	eb 05                	jmp    80082f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80082a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80082f:	c9                   	leave  
  800830:	c3                   	ret    

00800831 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800837:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80083e:	8b 45 10             	mov    0x10(%ebp),%eax
  800841:	89 44 24 08          	mov    %eax,0x8(%esp)
  800845:	8b 45 0c             	mov    0xc(%ebp),%eax
  800848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	89 04 24             	mov    %eax,(%esp)
  800852:	e8 82 ff ff ff       	call   8007d9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800857:	c9                   	leave  
  800858:	c3                   	ret    
  800859:	00 00                	add    %al,(%eax)
  80085b:	00 00                	add    %al,(%eax)
  80085d:	00 00                	add    %al,(%eax)
	...

00800860 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800866:	b8 00 00 00 00       	mov    $0x0,%eax
  80086b:	80 3a 00             	cmpb   $0x0,(%edx)
  80086e:	74 09                	je     800879 <_Z6strlenPKc+0x19>
		n++;
  800870:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800873:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800877:	75 f7                	jne    800870 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800884:	b8 00 00 00 00       	mov    $0x0,%eax
  800889:	39 c2                	cmp    %eax,%edx
  80088b:	74 0b                	je     800898 <_Z7strnlenPKcj+0x1d>
  80088d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800891:	74 05                	je     800898 <_Z7strnlenPKcj+0x1d>
		n++;
  800893:	83 c0 01             	add    $0x1,%eax
  800896:	eb f1                	jmp    800889 <_Z7strnlenPKcj+0xe>
	return n;
}
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	53                   	push   %ebx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  8008a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ad:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008b0:	83 c2 01             	add    $0x1,%edx
  8008b3:	84 c9                	test   %cl,%cl
  8008b5:	75 f2                	jne    8008a9 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  8008b7:	5b                   	pop    %ebx
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	56                   	push   %esi
  8008be:	53                   	push   %ebx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8008c8:	85 f6                	test   %esi,%esi
  8008ca:	74 18                	je     8008e4 <_Z7strncpyPcPKcj+0x2a>
  8008cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8008d1:	0f b6 1a             	movzbl (%edx),%ebx
  8008d4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008d7:	80 3a 01             	cmpb   $0x1,(%edx)
  8008da:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8008dd:	83 c1 01             	add    $0x1,%ecx
  8008e0:	39 ce                	cmp    %ecx,%esi
  8008e2:	77 ed                	ja     8008d1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008e4:	5b                   	pop    %ebx
  8008e5:	5e                   	pop    %esi
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	56                   	push   %esi
  8008ec:	53                   	push   %ebx
  8008ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  8008f6:	89 f0                	mov    %esi,%eax
  8008f8:	85 d2                	test   %edx,%edx
  8008fa:	74 17                	je     800913 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  8008fc:	83 ea 01             	sub    $0x1,%edx
  8008ff:	74 18                	je     800919 <_Z7strlcpyPcPKcj+0x31>
  800901:	80 39 00             	cmpb   $0x0,(%ecx)
  800904:	74 17                	je     80091d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800906:	0f b6 19             	movzbl (%ecx),%ebx
  800909:	88 18                	mov    %bl,(%eax)
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	83 c1 01             	add    $0x1,%ecx
  800911:	eb e9                	jmp    8008fc <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800913:	29 f0                	sub    %esi,%eax
}
  800915:	5b                   	pop    %ebx
  800916:	5e                   	pop    %esi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800919:	89 c2                	mov    %eax,%edx
  80091b:	eb 02                	jmp    80091f <_Z7strlcpyPcPKcj+0x37>
  80091d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  80091f:	c6 02 00             	movb   $0x0,(%edx)
  800922:	eb ef                	jmp    800913 <_Z7strlcpyPcPKcj+0x2b>

00800924 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80092d:	0f b6 01             	movzbl (%ecx),%eax
  800930:	84 c0                	test   %al,%al
  800932:	74 0c                	je     800940 <_Z6strcmpPKcS0_+0x1c>
  800934:	3a 02                	cmp    (%edx),%al
  800936:	75 08                	jne    800940 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800938:	83 c1 01             	add    $0x1,%ecx
  80093b:	83 c2 01             	add    $0x1,%edx
  80093e:	eb ed                	jmp    80092d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800940:	0f b6 c0             	movzbl %al,%eax
  800943:	0f b6 12             	movzbl (%edx),%edx
  800946:	29 d0                	sub    %edx,%eax
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	53                   	push   %ebx
  80094e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800951:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800954:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800957:	85 d2                	test   %edx,%edx
  800959:	74 16                	je     800971 <_Z7strncmpPKcS0_j+0x27>
  80095b:	0f b6 01             	movzbl (%ecx),%eax
  80095e:	84 c0                	test   %al,%al
  800960:	74 17                	je     800979 <_Z7strncmpPKcS0_j+0x2f>
  800962:	3a 03                	cmp    (%ebx),%al
  800964:	75 13                	jne    800979 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800966:	83 ea 01             	sub    $0x1,%edx
  800969:	83 c1 01             	add    $0x1,%ecx
  80096c:	83 c3 01             	add    $0x1,%ebx
  80096f:	eb e6                	jmp    800957 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800971:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800976:	5b                   	pop    %ebx
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800979:	0f b6 01             	movzbl (%ecx),%eax
  80097c:	0f b6 13             	movzbl (%ebx),%edx
  80097f:	29 d0                	sub    %edx,%eax
  800981:	eb f3                	jmp    800976 <_Z7strncmpPKcS0_j+0x2c>

00800983 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098d:	0f b6 10             	movzbl (%eax),%edx
  800990:	84 d2                	test   %dl,%dl
  800992:	74 1f                	je     8009b3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800994:	38 ca                	cmp    %cl,%dl
  800996:	75 0a                	jne    8009a2 <_Z6strchrPKcc+0x1f>
  800998:	eb 1e                	jmp    8009b8 <_Z6strchrPKcc+0x35>
  80099a:	38 ca                	cmp    %cl,%dl
  80099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8009a0:	74 16                	je     8009b8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009a2:	83 c0 01             	add    $0x1,%eax
  8009a5:	0f b6 10             	movzbl (%eax),%edx
  8009a8:	84 d2                	test   %dl,%dl
  8009aa:	75 ee                	jne    80099a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  8009ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b1:	eb 05                	jmp    8009b8 <_Z6strchrPKcc+0x35>
  8009b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c4:	0f b6 10             	movzbl (%eax),%edx
  8009c7:	84 d2                	test   %dl,%dl
  8009c9:	74 14                	je     8009df <_Z7strfindPKcc+0x25>
		if (*s == c)
  8009cb:	38 ca                	cmp    %cl,%dl
  8009cd:	75 06                	jne    8009d5 <_Z7strfindPKcc+0x1b>
  8009cf:	eb 0e                	jmp    8009df <_Z7strfindPKcc+0x25>
  8009d1:	38 ca                	cmp    %cl,%dl
  8009d3:	74 0a                	je     8009df <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009d5:	83 c0 01             	add    $0x1,%eax
  8009d8:	0f b6 10             	movzbl (%eax),%edx
  8009db:	84 d2                	test   %dl,%dl
  8009dd:	75 f2                	jne    8009d1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	83 ec 0c             	sub    $0xc,%esp
  8009e7:	89 1c 24             	mov    %ebx,(%esp)
  8009ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009f2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  8009fb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a01:	75 25                	jne    800a28 <memset+0x47>
  800a03:	f6 c1 03             	test   $0x3,%cl
  800a06:	75 20                	jne    800a28 <memset+0x47>
		c &= 0xFF;
  800a08:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a0b:	89 d3                	mov    %edx,%ebx
  800a0d:	c1 e3 08             	shl    $0x8,%ebx
  800a10:	89 d6                	mov    %edx,%esi
  800a12:	c1 e6 18             	shl    $0x18,%esi
  800a15:	89 d0                	mov    %edx,%eax
  800a17:	c1 e0 10             	shl    $0x10,%eax
  800a1a:	09 f0                	or     %esi,%eax
  800a1c:	09 d0                	or     %edx,%eax
  800a1e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800a20:	c1 e9 02             	shr    $0x2,%ecx
  800a23:	fc                   	cld    
  800a24:	f3 ab                	rep stos %eax,%es:(%edi)
  800a26:	eb 03                	jmp    800a2b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800a28:	fc                   	cld    
  800a29:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800a2b:	89 f8                	mov    %edi,%eax
  800a2d:	8b 1c 24             	mov    (%esp),%ebx
  800a30:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a38:	89 ec                	mov    %ebp,%esp
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	89 34 24             	mov    %esi,(%esp)
  800a45:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800a52:	39 c6                	cmp    %eax,%esi
  800a54:	73 36                	jae    800a8c <memmove+0x50>
  800a56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a59:	39 d0                	cmp    %edx,%eax
  800a5b:	73 2f                	jae    800a8c <memmove+0x50>
		s += n;
		d += n;
  800a5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a60:	f6 c2 03             	test   $0x3,%dl
  800a63:	75 1b                	jne    800a80 <memmove+0x44>
  800a65:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a6b:	75 13                	jne    800a80 <memmove+0x44>
  800a6d:	f6 c1 03             	test   $0x3,%cl
  800a70:	75 0e                	jne    800a80 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a72:	83 ef 04             	sub    $0x4,%edi
  800a75:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a78:	c1 e9 02             	shr    $0x2,%ecx
  800a7b:	fd                   	std    
  800a7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7e:	eb 09                	jmp    800a89 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a80:	83 ef 01             	sub    $0x1,%edi
  800a83:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a86:	fd                   	std    
  800a87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a89:	fc                   	cld    
  800a8a:	eb 20                	jmp    800aac <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800a8c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a92:	75 13                	jne    800aa7 <memmove+0x6b>
  800a94:	a8 03                	test   $0x3,%al
  800a96:	75 0f                	jne    800aa7 <memmove+0x6b>
  800a98:	f6 c1 03             	test   $0x3,%cl
  800a9b:	75 0a                	jne    800aa7 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9d:	c1 e9 02             	shr    $0x2,%ecx
  800aa0:	89 c7                	mov    %eax,%edi
  800aa2:	fc                   	cld    
  800aa3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa5:	eb 05                	jmp    800aac <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800aa7:	89 c7                	mov    %eax,%edi
  800aa9:	fc                   	cld    
  800aaa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800aac:	8b 34 24             	mov    (%esp),%esi
  800aaf:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ab3:	89 ec                	mov    %ebp,%esp
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	89 34 24             	mov    %esi,(%esp)
  800ac0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aca:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800acd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad3:	75 13                	jne    800ae8 <memcpy+0x31>
  800ad5:	a8 03                	test   $0x3,%al
  800ad7:	75 0f                	jne    800ae8 <memcpy+0x31>
  800ad9:	f6 c1 03             	test   $0x3,%cl
  800adc:	75 0a                	jne    800ae8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ade:	c1 e9 02             	shr    $0x2,%ecx
  800ae1:	89 c7                	mov    %eax,%edi
  800ae3:	fc                   	cld    
  800ae4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae6:	eb 05                	jmp    800aed <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800ae8:	89 c7                	mov    %eax,%edi
  800aea:	fc                   	cld    
  800aeb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800aed:	8b 34 24             	mov    (%esp),%esi
  800af0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800af4:	89 ec                	mov    %ebp,%esp
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	57                   	push   %edi
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
  800afe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b01:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b04:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800b07:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b0c:	85 ff                	test   %edi,%edi
  800b0e:	74 38                	je     800b48 <memcmp+0x50>
		if (*s1 != *s2)
  800b10:	0f b6 03             	movzbl (%ebx),%eax
  800b13:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b16:	83 ef 01             	sub    $0x1,%edi
  800b19:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800b1e:	38 c8                	cmp    %cl,%al
  800b20:	74 1d                	je     800b3f <memcmp+0x47>
  800b22:	eb 11                	jmp    800b35 <memcmp+0x3d>
  800b24:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800b29:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800b2e:	83 c2 01             	add    $0x1,%edx
  800b31:	38 c8                	cmp    %cl,%al
  800b33:	74 0a                	je     800b3f <memcmp+0x47>
			return *s1 - *s2;
  800b35:	0f b6 c0             	movzbl %al,%eax
  800b38:	0f b6 c9             	movzbl %cl,%ecx
  800b3b:	29 c8                	sub    %ecx,%eax
  800b3d:	eb 09                	jmp    800b48 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800b3f:	39 fa                	cmp    %edi,%edx
  800b41:	75 e1                	jne    800b24 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5f                   	pop    %edi
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	53                   	push   %ebx
  800b51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800b54:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800b56:	89 da                	mov    %ebx,%edx
  800b58:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800b5b:	39 d3                	cmp    %edx,%ebx
  800b5d:	73 15                	jae    800b74 <memfind+0x27>
		if (*s == (unsigned char) c)
  800b5f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b63:	38 0b                	cmp    %cl,(%ebx)
  800b65:	75 06                	jne    800b6d <memfind+0x20>
  800b67:	eb 0b                	jmp    800b74 <memfind+0x27>
  800b69:	38 08                	cmp    %cl,(%eax)
  800b6b:	74 07                	je     800b74 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800b6d:	83 c0 01             	add    $0x1,%eax
  800b70:	39 c2                	cmp    %eax,%edx
  800b72:	77 f5                	ja     800b69 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b74:	5b                   	pop    %ebx
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	57                   	push   %edi
  800b7b:	56                   	push   %esi
  800b7c:	53                   	push   %ebx
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b83:	0f b6 02             	movzbl (%edx),%eax
  800b86:	3c 20                	cmp    $0x20,%al
  800b88:	74 04                	je     800b8e <_Z6strtolPKcPPci+0x17>
  800b8a:	3c 09                	cmp    $0x9,%al
  800b8c:	75 0e                	jne    800b9c <_Z6strtolPKcPPci+0x25>
		s++;
  800b8e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b91:	0f b6 02             	movzbl (%edx),%eax
  800b94:	3c 20                	cmp    $0x20,%al
  800b96:	74 f6                	je     800b8e <_Z6strtolPKcPPci+0x17>
  800b98:	3c 09                	cmp    $0x9,%al
  800b9a:	74 f2                	je     800b8e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b9c:	3c 2b                	cmp    $0x2b,%al
  800b9e:	75 0a                	jne    800baa <_Z6strtolPKcPPci+0x33>
		s++;
  800ba0:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ba3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba8:	eb 10                	jmp    800bba <_Z6strtolPKcPPci+0x43>
  800baa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800baf:	3c 2d                	cmp    $0x2d,%al
  800bb1:	75 07                	jne    800bba <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800bb3:	83 c2 01             	add    $0x1,%edx
  800bb6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bba:	85 db                	test   %ebx,%ebx
  800bbc:	0f 94 c0             	sete   %al
  800bbf:	74 05                	je     800bc6 <_Z6strtolPKcPPci+0x4f>
  800bc1:	83 fb 10             	cmp    $0x10,%ebx
  800bc4:	75 15                	jne    800bdb <_Z6strtolPKcPPci+0x64>
  800bc6:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc9:	75 10                	jne    800bdb <_Z6strtolPKcPPci+0x64>
  800bcb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bcf:	75 0a                	jne    800bdb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800bd1:	83 c2 02             	add    $0x2,%edx
  800bd4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd9:	eb 13                	jmp    800bee <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800bdb:	84 c0                	test   %al,%al
  800bdd:	74 0f                	je     800bee <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdf:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800be4:	80 3a 30             	cmpb   $0x30,(%edx)
  800be7:	75 05                	jne    800bee <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800be9:	83 c2 01             	add    $0x1,%edx
  800bec:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800bee:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bf5:	0f b6 0a             	movzbl (%edx),%ecx
  800bf8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bfb:	80 fb 09             	cmp    $0x9,%bl
  800bfe:	77 08                	ja     800c08 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800c00:	0f be c9             	movsbl %cl,%ecx
  800c03:	83 e9 30             	sub    $0x30,%ecx
  800c06:	eb 1e                	jmp    800c26 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800c08:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800c0b:	80 fb 19             	cmp    $0x19,%bl
  800c0e:	77 08                	ja     800c18 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800c10:	0f be c9             	movsbl %cl,%ecx
  800c13:	83 e9 57             	sub    $0x57,%ecx
  800c16:	eb 0e                	jmp    800c26 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800c18:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800c1b:	80 fb 19             	cmp    $0x19,%bl
  800c1e:	77 15                	ja     800c35 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800c20:	0f be c9             	movsbl %cl,%ecx
  800c23:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c26:	39 f1                	cmp    %esi,%ecx
  800c28:	7d 0f                	jge    800c39 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800c2a:	83 c2 01             	add    $0x1,%edx
  800c2d:	0f af c6             	imul   %esi,%eax
  800c30:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800c33:	eb c0                	jmp    800bf5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800c35:	89 c1                	mov    %eax,%ecx
  800c37:	eb 02                	jmp    800c3b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c39:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800c3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3f:	74 05                	je     800c46 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800c41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c44:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c46:	89 ca                	mov    %ecx,%edx
  800c48:	f7 da                	neg    %edx
  800c4a:	85 ff                	test   %edi,%edi
  800c4c:	0f 45 c2             	cmovne %edx,%eax
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	89 1c 24             	mov    %ebx,(%esp)
  800c5d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c61:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c65:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c70:	89 c3                	mov    %eax,%ebx
  800c72:	89 c7                	mov    %eax,%edi
  800c74:	89 c6                	mov    %eax,%esi
  800c76:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c78:	8b 1c 24             	mov    (%esp),%ebx
  800c7b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c7f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c83:	89 ec                	mov    %ebp,%esp
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 0c             	sub    $0xc,%esp
  800c8d:	89 1c 24             	mov    %ebx,(%esp)
  800c90:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c94:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800c98:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9d:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca2:	89 d1                	mov    %edx,%ecx
  800ca4:	89 d3                	mov    %edx,%ebx
  800ca6:	89 d7                	mov    %edx,%edi
  800ca8:	89 d6                	mov    %edx,%esi
  800caa:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cac:	8b 1c 24             	mov    (%esp),%ebx
  800caf:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cb3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cb7:	89 ec                	mov    %ebp,%esp
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 38             	sub    $0x38,%esp
  800cc1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cc4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cc7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800cca:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ccf:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	89 cb                	mov    %ecx,%ebx
  800cd9:	89 cf                	mov    %ecx,%edi
  800cdb:	89 ce                	mov    %ecx,%esi
  800cdd:	cd 30                	int    $0x30

	if(check && ret > 0)
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	7e 28                	jle    800d0b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ce7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cee:	00 
  800cef:	c7 44 24 08 74 45 80 	movl   $0x804574,0x8(%esp)
  800cf6:	00 
  800cf7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cfe:	00 
  800cff:	c7 04 24 91 45 80 00 	movl   $0x804591,(%esp)
  800d06:	e8 a1 2f 00 00       	call   803cac <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d0e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d11:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d14:	89 ec                	mov    %ebp,%esp
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	83 ec 0c             	sub    $0xc,%esp
  800d1e:	89 1c 24             	mov    %ebx,(%esp)
  800d21:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d25:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2e:	b8 02 00 00 00       	mov    $0x2,%eax
  800d33:	89 d1                	mov    %edx,%ecx
  800d35:	89 d3                	mov    %edx,%ebx
  800d37:	89 d7                	mov    %edx,%edi
  800d39:	89 d6                	mov    %edx,%esi
  800d3b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d3d:	8b 1c 24             	mov    (%esp),%ebx
  800d40:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d44:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d48:	89 ec                	mov    %ebp,%esp
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	89 1c 24             	mov    %ebx,(%esp)
  800d55:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d59:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d62:	b8 04 00 00 00       	mov    $0x4,%eax
  800d67:	89 d1                	mov    %edx,%ecx
  800d69:	89 d3                	mov    %edx,%ebx
  800d6b:	89 d7                	mov    %edx,%edi
  800d6d:	89 d6                	mov    %edx,%esi
  800d6f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d71:	8b 1c 24             	mov    (%esp),%ebx
  800d74:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d7c:	89 ec                	mov    %ebp,%esp
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 38             	sub    $0x38,%esp
  800d86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d89:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d8c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800d8f:	be 00 00 00 00       	mov    $0x0,%esi
  800d94:	b8 08 00 00 00       	mov    $0x8,%eax
  800d99:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	89 f7                	mov    %esi,%edi
  800da4:	cd 30                	int    $0x30

	if(check && ret > 0)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	7e 28                	jle    800dd2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800daa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dae:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800db5:	00 
  800db6:	c7 44 24 08 74 45 80 	movl   $0x804574,0x8(%esp)
  800dbd:	00 
  800dbe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc5:	00 
  800dc6:	c7 04 24 91 45 80 00 	movl   $0x804591,(%esp)
  800dcd:	e8 da 2e 00 00       	call   803cac <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ddb:	89 ec                	mov    %ebp,%esp
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 38             	sub    $0x38,%esp
  800de5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800deb:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800dee:	b8 09 00 00 00       	mov    $0x9,%eax
  800df3:	8b 75 18             	mov    0x18(%ebp),%esi
  800df6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	7e 28                	jle    800e30 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e08:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e13:	00 
  800e14:	c7 44 24 08 74 45 80 	movl   $0x804574,0x8(%esp)
  800e1b:	00 
  800e1c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e23:	00 
  800e24:	c7 04 24 91 45 80 00 	movl   $0x804591,(%esp)
  800e2b:	e8 7c 2e 00 00       	call   803cac <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e30:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e33:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e36:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e39:	89 ec                	mov    %ebp,%esp
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    

00800e3d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 38             	sub    $0x38,%esp
  800e43:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e46:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e49:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 df                	mov    %ebx,%edi
  800e5e:	89 de                	mov    %ebx,%esi
  800e60:	cd 30                	int    $0x30

	if(check && ret > 0)
  800e62:	85 c0                	test   %eax,%eax
  800e64:	7e 28                	jle    800e8e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e66:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e71:	00 
  800e72:	c7 44 24 08 74 45 80 	movl   $0x804574,0x8(%esp)
  800e79:	00 
  800e7a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e81:	00 
  800e82:	c7 04 24 91 45 80 00 	movl   $0x804591,(%esp)
  800e89:	e8 1e 2e 00 00       	call   803cac <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e8e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e91:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e94:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e97:	89 ec                	mov    %ebp,%esp
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 38             	sub    $0x38,%esp
  800ea1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800eaa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eaf:	b8 05 00 00 00       	mov    $0x5,%eax
  800eb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eba:	89 df                	mov    %ebx,%edi
  800ebc:	89 de                	mov    %ebx,%esi
  800ebe:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	7e 28                	jle    800eec <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec4:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ecf:	00 
  800ed0:	c7 44 24 08 74 45 80 	movl   $0x804574,0x8(%esp)
  800ed7:	00 
  800ed8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800edf:	00 
  800ee0:	c7 04 24 91 45 80 00 	movl   $0x804591,(%esp)
  800ee7:	e8 c0 2d 00 00       	call   803cac <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eec:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eef:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef5:	89 ec                	mov    %ebp,%esp
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 38             	sub    $0x38,%esp
  800eff:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f02:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f05:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	89 df                	mov    %ebx,%edi
  800f1a:	89 de                	mov    %ebx,%esi
  800f1c:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f1e:	85 c0                	test   %eax,%eax
  800f20:	7e 28                	jle    800f4a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f22:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f26:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f2d:	00 
  800f2e:	c7 44 24 08 74 45 80 	movl   $0x804574,0x8(%esp)
  800f35:	00 
  800f36:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3d:	00 
  800f3e:	c7 04 24 91 45 80 00 	movl   $0x804591,(%esp)
  800f45:	e8 62 2d 00 00       	call   803cac <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800f4a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f4d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f50:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f53:	89 ec                	mov    %ebp,%esp
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 38             	sub    $0x38,%esp
  800f5d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f60:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f63:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	89 df                	mov    %ebx,%edi
  800f78:	89 de                	mov    %ebx,%esi
  800f7a:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	7e 28                	jle    800fa8 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f84:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 08 74 45 80 	movl   $0x804574,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 91 45 80 00 	movl   $0x804591,(%esp)
  800fa3:	e8 04 2d 00 00       	call   803cac <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fa8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb1:	89 ec                	mov    %ebp,%esp
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 38             	sub    $0x38,%esp
  800fbb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fbe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	89 df                	mov    %ebx,%edi
  800fd6:	89 de                	mov    %ebx,%esi
  800fd8:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	7e 28                	jle    801006 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fde:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  800fe9:	00 
  800fea:	c7 44 24 08 74 45 80 	movl   $0x804574,0x8(%esp)
  800ff1:	00 
  800ff2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff9:	00 
  800ffa:	c7 04 24 91 45 80 00 	movl   $0x804591,(%esp)
  801001:	e8 a6 2c 00 00       	call   803cac <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801006:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801009:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80100f:	89 ec                	mov    %ebp,%esp
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	89 1c 24             	mov    %ebx,(%esp)
  80101c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801020:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801024:	be 00 00 00 00       	mov    $0x0,%esi
  801029:	b8 0d 00 00 00       	mov    $0xd,%eax
  80102e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801031:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801034:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801037:	8b 55 08             	mov    0x8(%ebp),%edx
  80103a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80103c:	8b 1c 24             	mov    (%esp),%ebx
  80103f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801043:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801047:	89 ec                	mov    %ebp,%esp
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    

0080104b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 38             	sub    $0x38,%esp
  801051:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801054:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801057:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80105a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	89 cb                	mov    %ecx,%ebx
  801069:	89 cf                	mov    %ecx,%edi
  80106b:	89 ce                	mov    %ecx,%esi
  80106d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80106f:	85 c0                	test   %eax,%eax
  801071:	7e 28                	jle    80109b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801073:	89 44 24 10          	mov    %eax,0x10(%esp)
  801077:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80107e:	00 
  80107f:	c7 44 24 08 74 45 80 	movl   $0x804574,0x8(%esp)
  801086:	00 
  801087:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80108e:	00 
  80108f:	c7 04 24 91 45 80 00 	movl   $0x804591,(%esp)
  801096:	e8 11 2c 00 00       	call   803cac <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80109b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80109e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010a4:	89 ec                	mov    %ebp,%esp
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 0c             	sub    $0xc,%esp
  8010ae:	89 1c 24             	mov    %ebx,(%esp)
  8010b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010b5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010be:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c9:	89 df                	mov    %ebx,%edi
  8010cb:	89 de                	mov    %ebx,%esi
  8010cd:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8010cf:	8b 1c 24             	mov    (%esp),%ebx
  8010d2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010d6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010da:	89 ec                	mov    %ebp,%esp
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 0c             	sub    $0xc,%esp
  8010e4:	89 1c 24             	mov    %ebx,(%esp)
  8010e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010eb:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f4:	b8 11 00 00 00       	mov    $0x11,%eax
  8010f9:	89 d1                	mov    %edx,%ecx
  8010fb:	89 d3                	mov    %edx,%ebx
  8010fd:	89 d7                	mov    %edx,%edi
  8010ff:	89 d6                	mov    %edx,%esi
  801101:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801103:	8b 1c 24             	mov    (%esp),%ebx
  801106:	8b 74 24 04          	mov    0x4(%esp),%esi
  80110a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80110e:	89 ec                	mov    %ebp,%esp
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    

00801112 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 0c             	sub    $0xc,%esp
  801118:	89 1c 24             	mov    %ebx,(%esp)
  80111b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80111f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801123:	bb 00 00 00 00       	mov    $0x0,%ebx
  801128:	b8 12 00 00 00       	mov    $0x12,%eax
  80112d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801130:	8b 55 08             	mov    0x8(%ebp),%edx
  801133:	89 df                	mov    %ebx,%edi
  801135:	89 de                	mov    %ebx,%esi
  801137:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801139:	8b 1c 24             	mov    (%esp),%ebx
  80113c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801140:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801144:	89 ec                	mov    %ebp,%esp
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    

00801148 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	89 1c 24             	mov    %ebx,(%esp)
  801151:	89 74 24 04          	mov    %esi,0x4(%esp)
  801155:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801159:	b9 00 00 00 00       	mov    $0x0,%ecx
  80115e:	b8 13 00 00 00       	mov    $0x13,%eax
  801163:	8b 55 08             	mov    0x8(%ebp),%edx
  801166:	89 cb                	mov    %ecx,%ebx
  801168:	89 cf                	mov    %ecx,%edi
  80116a:	89 ce                	mov    %ecx,%esi
  80116c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80116e:	8b 1c 24             	mov    (%esp),%ebx
  801171:	8b 74 24 04          	mov    0x4(%esp),%esi
  801175:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801179:	89 ec                	mov    %ebp,%esp
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 0c             	sub    $0xc,%esp
  801183:	89 1c 24             	mov    %ebx,(%esp)
  801186:	89 74 24 04          	mov    %esi,0x4(%esp)
  80118a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80118e:	b8 10 00 00 00       	mov    $0x10,%eax
  801193:	8b 75 18             	mov    0x18(%ebp),%esi
  801196:	8b 7d 14             	mov    0x14(%ebp),%edi
  801199:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80119c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  8011a4:	8b 1c 24             	mov    (%esp),%ebx
  8011a7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011ab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011af:	89 ec                	mov    %ebp,%esp
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    
	...

008011b4 <_Z8argstartPiPPcP8Argstate>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8011c0:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8011c2:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8011c5:	83 3a 01             	cmpl   $0x1,(%edx)
  8011c8:	7e 09                	jle    8011d3 <_Z8argstartPiPPcP8Argstate+0x1f>
  8011ca:	ba f1 41 80 00       	mov    $0x8041f1,%edx
  8011cf:	85 c9                	test   %ecx,%ecx
  8011d1:	75 05                	jne    8011d8 <_Z8argstartPiPPcP8Argstate+0x24>
  8011d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d8:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8011db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8011e2:	5d                   	pop    %ebp
  8011e3:	c3                   	ret    

008011e4 <_Z7argnextP8Argstate>:

int
argnext(struct Argstate *args)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 28             	sub    $0x28,%esp
  8011ea:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011ed:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011f0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8011f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8011f6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8011fd:	8b 53 08             	mov    0x8(%ebx),%edx
		return -1;
  801200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	int arg;

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801205:	85 d2                	test   %edx,%edx
  801207:	74 6f                	je     801278 <_Z7argnextP8Argstate+0x94>
		return -1;

	if (!*args->curarg) {
  801209:	80 3a 00             	cmpb   $0x0,(%edx)
  80120c:	75 50                	jne    80125e <_Z7argnextP8Argstate+0x7a>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80120e:	8b 0b                	mov    (%ebx),%ecx
  801210:	83 39 01             	cmpl   $0x1,(%ecx)
  801213:	74 57                	je     80126c <_Z7argnextP8Argstate+0x88>
		    || args->argv[1][0] != '-'
  801215:	8b 43 04             	mov    0x4(%ebx),%eax
  801218:	8d 70 04             	lea    0x4(%eax),%esi
  80121b:	8b 50 04             	mov    0x4(%eax),%edx
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80121e:	80 3a 2d             	cmpb   $0x2d,(%edx)
  801221:	75 49                	jne    80126c <_Z7argnextP8Argstate+0x88>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
  801223:	8d 7a 01             	lea    0x1(%edx),%edi
		return -1;

	if (!*args->curarg) {
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801226:	80 7a 01 00          	cmpb   $0x0,0x1(%edx)
  80122a:	74 40                	je     80126c <_Z7argnextP8Argstate+0x88>
		    || args->argv[1][0] != '-'
		    || args->argv[1][1] == '\0')
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80122c:	89 7b 08             	mov    %edi,0x8(%ebx)
		memcpy(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80122f:	8b 11                	mov    (%ecx),%edx
  801231:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801238:	89 54 24 08          	mov    %edx,0x8(%esp)
  80123c:	83 c0 08             	add    $0x8,%eax
  80123f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801243:	89 34 24             	mov    %esi,(%esp)
  801246:	e8 6c f8 ff ff       	call   800ab7 <memcpy>
		(*args->argc)--;
  80124b:	8b 03                	mov    (%ebx),%eax
  80124d:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801250:	8b 43 08             	mov    0x8(%ebx),%eax
  801253:	80 38 2d             	cmpb   $0x2d,(%eax)
  801256:	75 06                	jne    80125e <_Z7argnextP8Argstate+0x7a>
  801258:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80125c:	74 0e                	je     80126c <_Z7argnextP8Argstate+0x88>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80125e:	8b 53 08             	mov    0x8(%ebx),%edx
  801261:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801264:	83 c2 01             	add    $0x1,%edx
  801267:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  80126a:	eb 0c                	jmp    801278 <_Z7argnextP8Argstate+0x94>

    endofargs:
	args->curarg = 0;
  80126c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801278:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80127b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80127e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801281:	89 ec                	mov    %ebp,%esp
  801283:	5d                   	pop    %ebp
  801284:	c3                   	ret    

00801285 <_Z12argnextvalueP8Argstate>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 18             	sub    $0x18,%esp
  80128b:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80128e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801291:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801294:	8b 53 08             	mov    0x8(%ebx),%edx
		return 0;
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
}

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
  80129c:	85 d2                	test   %edx,%edx
  80129e:	74 58                	je     8012f8 <_Z12argnextvalueP8Argstate+0x73>
		return 0;
	if (*args->curarg) {
  8012a0:	80 3a 00             	cmpb   $0x0,(%edx)
  8012a3:	74 0c                	je     8012b1 <_Z12argnextvalueP8Argstate+0x2c>
		args->argvalue = args->curarg;
  8012a5:	89 53 0c             	mov    %edx,0xc(%ebx)
		args->curarg = "";
  8012a8:	c7 43 08 f1 41 80 00 	movl   $0x8041f1,0x8(%ebx)
  8012af:	eb 44                	jmp    8012f5 <_Z12argnextvalueP8Argstate+0x70>
	} else if (*args->argc > 1) {
  8012b1:	8b 03                	mov    (%ebx),%eax
  8012b3:	83 38 01             	cmpl   $0x1,(%eax)
  8012b6:	7e 2f                	jle    8012e7 <_Z12argnextvalueP8Argstate+0x62>
		args->argvalue = args->argv[1];
  8012b8:	8b 53 04             	mov    0x4(%ebx),%edx
  8012bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8012be:	8b 72 04             	mov    0x4(%edx),%esi
  8012c1:	89 73 0c             	mov    %esi,0xc(%ebx)
		memcpy(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8012c4:	8b 00                	mov    (%eax),%eax
  8012c6:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8012cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012d1:	83 c2 08             	add    $0x8,%edx
  8012d4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012d8:	89 0c 24             	mov    %ecx,(%esp)
  8012db:	e8 d7 f7 ff ff       	call   800ab7 <memcpy>
		(*args->argc)--;
  8012e0:	8b 03                	mov    (%ebx),%eax
  8012e2:	83 28 01             	subl   $0x1,(%eax)
  8012e5:	eb 0e                	jmp    8012f5 <_Z12argnextvalueP8Argstate+0x70>
	} else {
		args->argvalue = 0;
  8012e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8012ee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  8012f5:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8012f8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8012fb:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8012fe:	89 ec                	mov    %ebp,%esp
  801300:	5d                   	pop    %ebp
  801301:	c3                   	ret    

00801302 <_Z8argvalueP8Argstate>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	83 ec 18             	sub    $0x18,%esp
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80130b:	8b 42 0c             	mov    0xc(%edx),%eax
  80130e:	85 c0                	test   %eax,%eax
  801310:	75 08                	jne    80131a <_Z8argvalueP8Argstate+0x18>
  801312:	89 14 24             	mov    %edx,(%esp)
  801315:	e8 6b ff ff ff       	call   801285 <_Z12argnextvalueP8Argstate>
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    
  80131c:	00 00                	add    %al,(%eax)
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
  801354:	c7 44 24 0c 9f 45 80 	movl   $0x80459f,0xc(%esp)
  80135b:	00 
  80135c:	c7 44 24 08 ac 45 80 	movl   $0x8045ac,0x8(%esp)
  801363:	00 
  801364:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80136b:	00 
  80136c:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801373:	e8 34 29 00 00       	call   803cac <_Z6_panicPKciS0_z>
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
  801409:	c7 44 24 0c 9f 45 80 	movl   $0x80459f,0xc(%esp)
  801410:	00 
  801411:	c7 44 24 08 ac 45 80 	movl   $0x8045ac,0x8(%esp)
  801418:	00 
  801419:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801420:	00 
  801421:	c7 04 24 c1 45 80 00 	movl   $0x8045c1,(%esp)
  801428:	e8 7f 28 00 00       	call   803cac <_Z6_panicPKciS0_z>
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
  8014e5:	8b 14 85 2c 46 80 00 	mov    0x80462c(,%eax,4),%edx
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
  801500:	c7 04 24 e8 45 80 00 	movl   $0x8045e8,(%esp)
  801507:	e8 72 ed ff ff       	call   80027e <_Z7cprintfPKcz>
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
  801597:	e8 a1 f8 ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
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
  801694:	e8 46 f7 ff ff       	call   800ddf <_Z12sys_page_mapiPviS_i>
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
  8016d2:	e8 08 f7 ff ff       	call   800ddf <_Z12sys_page_mapiPviS_i>
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
  8016eb:	e8 4d f7 ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  8016f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016fb:	e8 3d f7 ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
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
  80179d:	c7 04 24 ca 45 80 00 	movl   $0x8045ca,(%esp)
  8017a4:	e8 d5 ea ff ff       	call   80027e <_Z7cprintfPKcz>
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
  80192e:	c7 04 24 08 46 80 00 	movl   $0x804608,(%esp)
  801935:	e8 44 e9 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  801ab9:	c7 44 24 08 40 46 80 	movl   $0x804640,0x8(%esp)
  801ac0:	00 
  801ac1:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  801ac8:	00 
  801ac9:	c7 04 24 56 46 80 00 	movl   $0x804656,(%esp)
  801ad0:	e8 d7 21 00 00       	call   803cac <_Z6_panicPKciS0_z>
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
  801b18:	c7 44 24 08 7c 46 80 	movl   $0x80467c,0x8(%esp)
  801b1f:	00 
  801b20:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801b27:	00 
  801b28:	c7 04 24 56 46 80 00 	movl   $0x804656,(%esp)
  801b2f:	e8 78 21 00 00       	call   803cac <_Z6_panicPKciS0_z>
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
  801b57:	c7 44 24 08 ac 46 80 	movl   $0x8046ac,0x8(%esp)
  801b5e:	00 
  801b5f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801b66:	00 
  801b67:	c7 04 24 56 46 80 00 	movl   $0x804656,(%esp)
  801b6e:	e8 39 21 00 00       	call   803cac <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  801b73:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b7a:	00 
  801b7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b82:	00 
  801b83:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b87:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  801b8e:	e8 6c 23 00 00       	call   803eff <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  801b93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b9a:	00 
  801b9b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ba6:	e8 c5 22 00 00       	call   803e70 <_Z8ipc_recvPiPvS_>
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
  801bd1:	e8 a5 21 00 00       	call   803d7b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

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
  801e81:	c7 44 24 08 61 46 80 	movl   $0x804661,0x8(%esp)
  801e88:	00 
  801e89:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801e90:	00 
  801e91:	c7 04 24 56 46 80 00 	movl   $0x804656,(%esp)
  801e98:	e8 0f 1e 00 00       	call   803cac <_Z6_panicPKciS0_z>
    resume(utf);
  801e9d:	89 1c 24             	mov    %ebx,(%esp)
  801ea0:	e8 ab 1f 00 00       	call   803e50 <resume>
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
  801ed6:	e8 bf e9 ff ff       	call   80089a <_Z6strcpyPcPKc>
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
  801f09:	e8 d6 16 00 00       	call   8035e4 <_Z7pagerefPv>
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
  80201b:	e8 97 ea ff ff       	call   800ab7 <memcpy>
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
  802057:	e8 5b ea ff ff       	call   800ab7 <memcpy>
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
  8020aa:	e8 08 ea ff ff       	call   800ab7 <memcpy>
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
  802139:	e8 79 e9 ff ff       	call   800ab7 <memcpy>
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
  80216a:	e8 48 e9 ff ff       	call   800ab7 <memcpy>
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
  8021a8:	e8 0a e9 ff ff       	call   800ab7 <memcpy>
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
  8022cd:	e8 26 e8 ff ff       	call   800af8 <memcmp>
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
  802353:	e8 89 e6 ff ff       	call   8009e1 <memset>
	empty->de_namelen = namelen;
  802358:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80235b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80235e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802361:	89 54 24 08          	mov    %edx,0x8(%esp)
  802365:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802369:	83 c0 08             	add    $0x8,%eax
  80236c:	89 04 24             	mov    %eax,(%esp)
  80236f:	e8 43 e7 ff ff       	call   800ab7 <memcpy>
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
  802415:	e8 66 e9 ff ff       	call   800d80 <_Z14sys_page_allociPvi>
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
  80251c:	e8 c0 e4 ff ff       	call   8009e1 <memset>
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
  8025b7:	e8 de e2 ff ff       	call   80089a <_Z6strcpyPcPKc>
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
  802610:	e8 28 e8 ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
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
  802643:	c7 44 24 04 74 46 80 	movl   $0x804674,0x4(%esp)
  80264a:	00 
  80264b:	89 1c 24             	mov    %ebx,(%esp)
  80264e:	e8 47 e2 ff ff       	call   80089a <_Z6strcpyPcPKc>
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
  802716:	e8 60 16 00 00       	call   803d7b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  80271b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802720:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802725:	74 28                	je     80274f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802727:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  80272e:	4a 
  80272f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802733:	c7 44 24 08 dc 46 80 	movl   $0x8046dc,0x8(%esp)
  80273a:	00 
  80273b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802742:	00 
  802743:	c7 04 24 56 46 80 00 	movl   $0x804656,(%esp)
  80274a:	e8 5d 15 00 00       	call   803cac <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  80274f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802754:	83 f8 03             	cmp    $0x3,%eax
  802757:	7f 1c                	jg     802775 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802759:	c7 44 24 08 10 47 80 	movl   $0x804710,0x8(%esp)
  802760:	00 
  802761:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802768:	00 
  802769:	c7 04 24 56 46 80 00 	movl   $0x804656,(%esp)
  802770:	e8 37 15 00 00       	call   803cac <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802775:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  80277b:	85 d2                	test   %edx,%edx
  80277d:	7f 1c                	jg     80279b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  80277f:	c7 44 24 08 40 47 80 	movl   $0x804740,0x8(%esp)
  802786:	00 
  802787:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  80278e:	00 
  80278f:	c7 04 24 56 46 80 00 	movl   $0x804656,(%esp)
  802796:	e8 11 15 00 00       	call   803cac <_Z6_panicPKciS0_z>
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
  8027e8:	c7 44 24 08 70 47 80 	movl   $0x804770,0x8(%esp)
  8027ef:	00 
  8027f0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  8027f7:	00 
  8027f8:	c7 04 24 56 46 80 00 	movl   $0x804656,(%esp)
  8027ff:	e8 a8 14 00 00       	call   803cac <_Z6_panicPKciS0_z>

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
  802834:	c7 04 24 b4 47 80 00 	movl   $0x8047b4,(%esp)
  80283b:	e8 3e da ff ff       	call   80027e <_Z7cprintfPKcz>
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
  80285b:	c7 04 24 e8 47 80 00 	movl   $0x8047e8,(%esp)
  802862:	e8 17 da ff ff       	call   80027e <_Z7cprintfPKcz>
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
  8028f9:	c7 04 24 14 48 80 00 	movl   $0x804814,(%esp)
  802900:	e8 79 d9 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802921:	c7 04 24 38 48 80 00 	movl   $0x804838,(%esp)
  802928:	e8 51 d9 ff ff       	call   80027e <_Z7cprintfPKcz>
			++errors;
  80292d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802934:	eb 1e                	jmp    802954 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802936:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80293c:	83 3a 02             	cmpl   $0x2,(%edx)
  80293f:	74 13                	je     802954 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802941:	c7 04 24 6c 48 80 00 	movl   $0x80486c,(%esp)
  802948:	e8 31 d9 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802984:	c7 04 24 9c 48 80 00 	movl   $0x80489c,(%esp)
  80298b:	e8 ee d8 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  8029c4:	c7 04 24 c0 48 80 00 	movl   $0x8048c0,(%esp)
  8029cb:	e8 ae d8 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802a27:	c7 04 24 e4 48 80 00 	movl   $0x8048e4,(%esp)
  802a2e:	e8 4b d8 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802a5f:	c7 04 24 28 49 80 00 	movl   $0x804928,(%esp)
  802a66:	e8 13 d8 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802aa1:	c7 04 24 6c 49 80 00 	movl   $0x80496c,(%esp)
  802aa8:	e8 d1 d7 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802ad3:	c7 04 24 b0 49 80 00 	movl   $0x8049b0,(%esp)
  802ada:	e8 9f d7 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802afe:	c7 04 24 ec 49 80 00 	movl   $0x8049ec,(%esp)
  802b05:	e8 74 d7 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802c06:	c7 04 24 28 4a 80 00 	movl   $0x804a28,(%esp)
  802c0d:	e8 6c d6 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802c67:	c7 04 24 5c 4a 80 00 	movl   $0x804a5c,(%esp)
  802c6e:	e8 0b d6 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802c91:	c7 04 24 88 4a 80 00 	movl   $0x804a88,(%esp)
  802c98:	e8 e1 d5 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802cbc:	e8 f6 dd ff ff       	call   800ab7 <memcpy>
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
  802d06:	c7 04 24 bc 4a 80 00 	movl   $0x804abc,(%esp)
  802d0d:	e8 6c d5 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802dbd:	c7 04 24 ec 4a 80 00 	movl   $0x804aec,(%esp)
  802dc4:	e8 b5 d4 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802dee:	e8 05 dd ff ff       	call   800af8 <memcmp>
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
  802e19:	c7 04 24 1c 4b 80 00 	movl   $0x804b1c,(%esp)
  802e20:	e8 59 d4 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802edc:	c7 04 24 4c 4b 80 00 	movl   $0x804b4c,(%esp)
  802ee3:	e8 96 d3 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802f34:	c7 04 24 78 4b 80 00 	movl   $0x804b78,(%esp)
  802f3b:	e8 3e d3 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  802f9c:	c7 44 24 04 ab 4b 80 	movl   $0x804bab,0x4(%esp)
  802fa3:	00 
  802fa4:	89 34 24             	mov    %esi,(%esp)
  802fa7:	e8 ee d8 ff ff       	call   80089a <_Z6strcpyPcPKc>
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
  802fe9:	e8 4f de ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  802fee:	89 1c 24             	mov    %ebx,(%esp)
  802ff1:	e8 46 e4 ff ff       	call   80143c <_Z7fd2dataP2Fd>
  802ff6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ffa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803001:	e8 37 de ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
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
  803025:	e8 ba 05 00 00       	call   8035e4 <_Z7pagerefPv>
  80302a:	89 c3                	mov    %eax,%ebx
  80302c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302f:	89 04 24             	mov    %eax,(%esp)
  803032:	e8 ad 05 00 00       	call   8035e4 <_Z7pagerefPv>
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
  803058:	c7 04 24 b2 4b 80 00 	movl   $0x804bb2,(%esp)
  80305f:	e8 1a d2 ff ff       	call   80027e <_Z7cprintfPKcz>
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
  803096:	e8 b1 dc ff ff       	call   800d4c <_Z9sys_yieldv>
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
  803129:	e8 1e dc ff ff       	call   800d4c <_Z9sys_yieldv>
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
  8031c1:	e8 ba db ff ff       	call   800d80 <_Z14sys_page_allociPvi>
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
  8031eb:	e8 90 db ff ff       	call   800d80 <_Z14sys_page_allociPvi>
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
  803229:	e8 b1 db ff ff       	call   800ddf <_Z12sys_page_mapiPviS_i>
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
  80328b:	e8 ad db ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803290:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803293:	89 44 24 04          	mov    %eax,0x4(%esp)
  803297:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80329e:	e8 9a db ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  8032a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032b1:	e8 87 db ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
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
  8032fc:	e8 7f da ff ff       	call   800d80 <_Z14sys_page_allociPvi>
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
  80337a:	e8 01 da ff ff       	call   800d80 <_Z14sys_page_allociPvi>
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
  803395:	c7 04 24 10 4c 80 00 	movl   $0x804c10,(%esp)
  80339c:	e8 dd ce ff ff       	call   80027e <_Z7cprintfPKcz>
  8033a1:	eb 10                	jmp    8033b3 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  8033a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033a7:	c7 04 24 c5 4b 80 00 	movl   $0x804bc5,(%esp)
  8033ae:	e8 cb ce ff ff       	call   80027e <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  8033b3:	c7 04 24 cf 4b 80 00 	movl   $0x804bcf,(%esp)
  8033ba:	e8 bf ce ff ff       	call   80027e <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  8033bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c2:	a8 04                	test   $0x4,%al
  8033c4:	74 04                	je     8033ca <_Z18pipe_ipc_recv_readv+0x82>
  8033c6:	a8 01                	test   $0x1,%al
  8033c8:	75 24                	jne    8033ee <_Z18pipe_ipc_recv_readv+0xa6>
  8033ca:	c7 44 24 0c e2 4b 80 	movl   $0x804be2,0xc(%esp)
  8033d1:	00 
  8033d2:	c7 44 24 08 ac 45 80 	movl   $0x8045ac,0x8(%esp)
  8033d9:	00 
  8033da:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8033e1:	00 
  8033e2:	c7 04 24 ff 4b 80 00 	movl   $0x804bff,(%esp)
  8033e9:	e8 be 08 00 00       	call   803cac <_Z6_panicPKciS0_z>
    
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
  80341d:	e8 1b da ff ff       	call   800e3d <_Z14sys_page_unmapiPv>
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
  803446:	e8 25 0a 00 00       	call   803e70 <_Z8ipc_recvPiPvS_>
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
  8034a0:	e8 5a 0a 00 00       	call   803eff <_Z8ipc_sendijPvi>
    return 0;
  8034a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034aa:	c9                   	leave  
  8034ab:	c3                   	ret    

008034ac <_ZL8writebufP8printbuf>:
};


static void
writebuf(struct printbuf *b)
{
  8034ac:	55                   	push   %ebp
  8034ad:	89 e5                	mov    %esp,%ebp
  8034af:	53                   	push   %ebx
  8034b0:	83 ec 14             	sub    $0x14,%esp
  8034b3:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8034b5:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8034b9:	7e 31                	jle    8034ec <_ZL8writebufP8printbuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8034bb:	8b 40 04             	mov    0x4(%eax),%eax
  8034be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034c2:	8d 43 10             	lea    0x10(%ebx),%eax
  8034c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034c9:	8b 03                	mov    (%ebx),%eax
  8034cb:	89 04 24             	mov    %eax,(%esp)
  8034ce:	e8 66 e3 ff ff       	call   801839 <_Z5writeiPKvj>
		if (result > 0)
  8034d3:	85 c0                	test   %eax,%eax
  8034d5:	7e 03                	jle    8034da <_ZL8writebufP8printbuf+0x2e>
			b->result += result;
  8034d7:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8034da:	39 43 04             	cmp    %eax,0x4(%ebx)
  8034dd:	74 0d                	je     8034ec <_ZL8writebufP8printbuf+0x40>
			b->error = (result < 0 ? result : 0);
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e6:	0f 4f c2             	cmovg  %edx,%eax
  8034e9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8034ec:	83 c4 14             	add    $0x14,%esp
  8034ef:	5b                   	pop    %ebx
  8034f0:	5d                   	pop    %ebp
  8034f1:	c3                   	ret    

008034f2 <_ZL5putchiPv>:

static void
putch(int ch, void *thunk)
{
  8034f2:	55                   	push   %ebp
  8034f3:	89 e5                	mov    %esp,%ebp
  8034f5:	53                   	push   %ebx
  8034f6:	83 ec 04             	sub    $0x4,%esp
  8034f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8034fc:	8b 43 04             	mov    0x4(%ebx),%eax
  8034ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803502:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  803506:	83 c0 01             	add    $0x1,%eax
  803509:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  80350c:	3d 00 01 00 00       	cmp    $0x100,%eax
  803511:	75 0e                	jne    803521 <_ZL5putchiPv+0x2f>
		writebuf(b);
  803513:	89 d8                	mov    %ebx,%eax
  803515:	e8 92 ff ff ff       	call   8034ac <_ZL8writebufP8printbuf>
		b->idx = 0;
  80351a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  803521:	83 c4 04             	add    $0x4,%esp
  803524:	5b                   	pop    %ebx
  803525:	5d                   	pop    %ebp
  803526:	c3                   	ret    

00803527 <_Z8vfprintfiPKcPc>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803527:	55                   	push   %ebp
  803528:	89 e5                	mov    %esp,%ebp
  80352a:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  803539:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  803540:	00 00 00 
	b.result = 0;
  803543:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80354a:	00 00 00 
	b.error = 1;
  80354d:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  803554:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803557:	8b 45 10             	mov    0x10(%ebp),%eax
  80355a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80355e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803561:	89 44 24 08          	mov    %eax,0x8(%esp)
  803565:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80356b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80356f:	c7 04 24 f2 34 80 00 	movl   $0x8034f2,(%esp)
  803576:	e8 8c ce ff ff       	call   800407 <_Z9vprintfmtPFviPvES_PKcPc>
	if (b.idx > 0)
  80357b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  803582:	7e 0b                	jle    80358f <_Z8vfprintfiPKcPc+0x68>
		writebuf(&b);
  803584:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80358a:	e8 1d ff ff ff       	call   8034ac <_ZL8writebufP8printbuf>

	return (b.result ? b.result : b.error);
  80358f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80359e:	c9                   	leave  
  80359f:	c3                   	ret    

008035a0 <_Z7fprintfiPKcz>:

int
fprintf(int fd, const char *fmt, ...)
{
  8035a0:	55                   	push   %ebp
  8035a1:	89 e5                	mov    %esp,%ebp
  8035a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8035a6:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8035a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8035ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b7:	89 04 24             	mov    %eax,(%esp)
  8035ba:	e8 68 ff ff ff       	call   803527 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  8035bf:	c9                   	leave  
  8035c0:	c3                   	ret    

008035c1 <_Z6printfPKcz>:

int
printf(const char *fmt, ...)
{
  8035c1:	55                   	push   %ebp
  8035c2:	89 e5                	mov    %esp,%ebp
  8035c4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8035c7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8035ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8035dc:	e8 46 ff ff ff       	call   803527 <_Z8vfprintfiPKcPc>
	va_end(ap);

	return cnt;
}
  8035e1:	c9                   	leave  
  8035e2:	c3                   	ret    
	...

008035e4 <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8035e4:	55                   	push   %ebp
  8035e5:	89 e5                	mov    %esp,%ebp
  8035e7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8035ea:	89 d0                	mov    %edx,%eax
  8035ec:	c1 e8 16             	shr    $0x16,%eax
  8035ef:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  8035f6:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8035fb:	f6 c1 01             	test   $0x1,%cl
  8035fe:	74 1d                	je     80361d <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803600:	c1 ea 0c             	shr    $0xc,%edx
  803603:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80360a:	f6 c2 01             	test   $0x1,%dl
  80360d:	74 0e                	je     80361d <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80360f:	c1 ea 0c             	shr    $0xc,%edx
  803612:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803619:	ef 
  80361a:	0f b7 c0             	movzwl %ax,%eax
}
  80361d:	5d                   	pop    %ebp
  80361e:	c3                   	ret    
	...

00803620 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803620:	55                   	push   %ebp
  803621:	89 e5                	mov    %esp,%ebp
  803623:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803626:	c7 44 24 04 33 4c 80 	movl   $0x804c33,0x4(%esp)
  80362d:	00 
  80362e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803631:	89 04 24             	mov    %eax,(%esp)
  803634:	e8 61 d2 ff ff       	call   80089a <_Z6strcpyPcPKc>
	return 0;
}
  803639:	b8 00 00 00 00       	mov    $0x0,%eax
  80363e:	c9                   	leave  
  80363f:	c3                   	ret    

00803640 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803640:	55                   	push   %ebp
  803641:	89 e5                	mov    %esp,%ebp
  803643:	53                   	push   %ebx
  803644:	83 ec 14             	sub    $0x14,%esp
  803647:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80364a:	89 1c 24             	mov    %ebx,(%esp)
  80364d:	e8 92 ff ff ff       	call   8035e4 <_Z7pagerefPv>
  803652:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803654:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803659:	83 fa 01             	cmp    $0x1,%edx
  80365c:	75 0b                	jne    803669 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80365e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803661:	89 04 24             	mov    %eax,(%esp)
  803664:	e8 fe 02 00 00       	call   803967 <_Z11nsipc_closei>
	else
		return 0;
}
  803669:	83 c4 14             	add    $0x14,%esp
  80366c:	5b                   	pop    %ebx
  80366d:	5d                   	pop    %ebp
  80366e:	c3                   	ret    

0080366f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80366f:	55                   	push   %ebp
  803670:	89 e5                	mov    %esp,%ebp
  803672:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803675:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80367c:	00 
  80367d:	8b 45 10             	mov    0x10(%ebp),%eax
  803680:	89 44 24 08          	mov    %eax,0x8(%esp)
  803684:	8b 45 0c             	mov    0xc(%ebp),%eax
  803687:	89 44 24 04          	mov    %eax,0x4(%esp)
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	8b 40 0c             	mov    0xc(%eax),%eax
  803691:	89 04 24             	mov    %eax,(%esp)
  803694:	e8 c9 03 00 00       	call   803a62 <_Z10nsipc_sendiPKvij>
}
  803699:	c9                   	leave  
  80369a:	c3                   	ret    

0080369b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80369b:	55                   	push   %ebp
  80369c:	89 e5                	mov    %esp,%ebp
  80369e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8036a8:	00 
  8036a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8036ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8036b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8036bd:	89 04 24             	mov    %eax,(%esp)
  8036c0:	e8 1d 03 00 00       	call   8039e2 <_Z10nsipc_recviPvij>
}
  8036c5:	c9                   	leave  
  8036c6:	c3                   	ret    

008036c7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8036c7:	55                   	push   %ebp
  8036c8:	89 e5                	mov    %esp,%ebp
  8036ca:	83 ec 28             	sub    $0x28,%esp
  8036cd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8036d0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8036d3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  8036d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036d8:	89 04 24             	mov    %eax,(%esp)
  8036db:	e8 77 dd ff ff       	call   801457 <_Z14fd_find_unusedPP2Fd>
  8036e0:	89 c3                	mov    %eax,%ebx
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	78 21                	js     803707 <_ZL12alloc_sockfdi+0x40>
  8036e6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8036ed:	00 
  8036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036fc:	e8 7f d6 ff ff       	call   800d80 <_Z14sys_page_allociPvi>
  803701:	89 c3                	mov    %eax,%ebx
  803703:	85 c0                	test   %eax,%eax
  803705:	79 14                	jns    80371b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803707:	89 34 24             	mov    %esi,(%esp)
  80370a:	e8 58 02 00 00       	call   803967 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  80370f:	89 d8                	mov    %ebx,%eax
  803711:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803714:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803717:	89 ec                	mov    %ebp,%esp
  803719:	5d                   	pop    %ebp
  80371a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  80371b:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803724:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803730:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803733:	89 04 24             	mov    %eax,(%esp)
  803736:	e8 b9 dc ff ff       	call   8013f4 <_Z6fd2numP2Fd>
  80373b:	89 c3                	mov    %eax,%ebx
  80373d:	eb d0                	jmp    80370f <_ZL12alloc_sockfdi+0x48>

0080373f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  80373f:	55                   	push   %ebp
  803740:	89 e5                	mov    %esp,%ebp
  803742:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803745:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80374c:	00 
  80374d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803750:	89 54 24 04          	mov    %edx,0x4(%esp)
  803754:	89 04 24             	mov    %eax,(%esp)
  803757:	e8 45 dc ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  80375c:	85 c0                	test   %eax,%eax
  80375e:	78 15                	js     803775 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803760:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803763:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803768:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80376e:	39 0a                	cmp    %ecx,(%edx)
  803770:	75 03                	jne    803775 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803772:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803775:	c9                   	leave  
  803776:	c3                   	ret    

00803777 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803777:	55                   	push   %ebp
  803778:	89 e5                	mov    %esp,%ebp
  80377a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80377d:	8b 45 08             	mov    0x8(%ebp),%eax
  803780:	e8 ba ff ff ff       	call   80373f <_ZL9fd2sockidi>
  803785:	85 c0                	test   %eax,%eax
  803787:	78 1f                	js     8037a8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803789:	8b 55 10             	mov    0x10(%ebp),%edx
  80378c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803790:	8b 55 0c             	mov    0xc(%ebp),%edx
  803793:	89 54 24 04          	mov    %edx,0x4(%esp)
  803797:	89 04 24             	mov    %eax,(%esp)
  80379a:	e8 19 01 00 00       	call   8038b8 <_Z12nsipc_acceptiP8sockaddrPj>
  80379f:	85 c0                	test   %eax,%eax
  8037a1:	78 05                	js     8037a8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  8037a3:	e8 1f ff ff ff       	call   8036c7 <_ZL12alloc_sockfdi>
}
  8037a8:	c9                   	leave  
  8037a9:	c3                   	ret    

008037aa <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037aa:	55                   	push   %ebp
  8037ab:	89 e5                	mov    %esp,%ebp
  8037ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b3:	e8 87 ff ff ff       	call   80373f <_ZL9fd2sockidi>
  8037b8:	85 c0                	test   %eax,%eax
  8037ba:	78 16                	js     8037d2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8037bc:	8b 55 10             	mov    0x10(%ebp),%edx
  8037bf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8037c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8037ca:	89 04 24             	mov    %eax,(%esp)
  8037cd:	e8 34 01 00 00       	call   803906 <_Z10nsipc_bindiP8sockaddrj>
}
  8037d2:	c9                   	leave  
  8037d3:	c3                   	ret    

008037d4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  8037d4:	55                   	push   %ebp
  8037d5:	89 e5                	mov    %esp,%ebp
  8037d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	e8 5d ff ff ff       	call   80373f <_ZL9fd2sockidi>
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	78 0f                	js     8037f5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8037e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8037ed:	89 04 24             	mov    %eax,(%esp)
  8037f0:	e8 50 01 00 00       	call   803945 <_Z14nsipc_shutdownii>
}
  8037f5:	c9                   	leave  
  8037f6:	c3                   	ret    

008037f7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037f7:	55                   	push   %ebp
  8037f8:	89 e5                	mov    %esp,%ebp
  8037fa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	e8 3a ff ff ff       	call   80373f <_ZL9fd2sockidi>
  803805:	85 c0                	test   %eax,%eax
  803807:	78 16                	js     80381f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803809:	8b 55 10             	mov    0x10(%ebp),%edx
  80380c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803810:	8b 55 0c             	mov    0xc(%ebp),%edx
  803813:	89 54 24 04          	mov    %edx,0x4(%esp)
  803817:	89 04 24             	mov    %eax,(%esp)
  80381a:	e8 62 01 00 00       	call   803981 <_Z13nsipc_connectiPK8sockaddrj>
}
  80381f:	c9                   	leave  
  803820:	c3                   	ret    

00803821 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803821:	55                   	push   %ebp
  803822:	89 e5                	mov    %esp,%ebp
  803824:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803827:	8b 45 08             	mov    0x8(%ebp),%eax
  80382a:	e8 10 ff ff ff       	call   80373f <_ZL9fd2sockidi>
  80382f:	85 c0                	test   %eax,%eax
  803831:	78 0f                	js     803842 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803833:	8b 55 0c             	mov    0xc(%ebp),%edx
  803836:	89 54 24 04          	mov    %edx,0x4(%esp)
  80383a:	89 04 24             	mov    %eax,(%esp)
  80383d:	e8 7e 01 00 00       	call   8039c0 <_Z12nsipc_listenii>
}
  803842:	c9                   	leave  
  803843:	c3                   	ret    

00803844 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803844:	55                   	push   %ebp
  803845:	89 e5                	mov    %esp,%ebp
  803847:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80384a:	8b 45 10             	mov    0x10(%ebp),%eax
  80384d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803851:	8b 45 0c             	mov    0xc(%ebp),%eax
  803854:	89 44 24 04          	mov    %eax,0x4(%esp)
  803858:	8b 45 08             	mov    0x8(%ebp),%eax
  80385b:	89 04 24             	mov    %eax,(%esp)
  80385e:	e8 72 02 00 00       	call   803ad5 <_Z12nsipc_socketiii>
  803863:	85 c0                	test   %eax,%eax
  803865:	78 05                	js     80386c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803867:	e8 5b fe ff ff       	call   8036c7 <_ZL12alloc_sockfdi>
}
  80386c:	c9                   	leave  
  80386d:	8d 76 00             	lea    0x0(%esi),%esi
  803870:	c3                   	ret    
  803871:	00 00                	add    %al,(%eax)
	...

00803874 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803874:	55                   	push   %ebp
  803875:	89 e5                	mov    %esp,%ebp
  803877:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80387a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803881:	00 
  803882:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803889:	00 
  80388a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80388e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803895:	e8 65 06 00 00       	call   803eff <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  80389a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8038a1:	00 
  8038a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8038a9:	00 
  8038aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038b1:	e8 ba 05 00 00       	call   803e70 <_Z8ipc_recvPiPvS_>
}
  8038b6:	c9                   	leave  
  8038b7:	c3                   	ret    

008038b8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038b8:	55                   	push   %ebp
  8038b9:	89 e5                	mov    %esp,%ebp
  8038bb:	53                   	push   %ebx
  8038bc:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8038c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8038cc:	e8 a3 ff ff ff       	call   803874 <_ZL5nsipcj>
  8038d1:	89 c3                	mov    %eax,%ebx
  8038d3:	85 c0                	test   %eax,%eax
  8038d5:	78 27                	js     8038fe <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  8038d7:	a1 10 70 80 00       	mov    0x807010,%eax
  8038dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038e0:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8038e7:	00 
  8038e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038eb:	89 04 24             	mov    %eax,(%esp)
  8038ee:	e8 49 d1 ff ff       	call   800a3c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  8038f3:	8b 15 10 70 80 00    	mov    0x807010,%edx
  8038f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8038fc:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8038fe:	89 d8                	mov    %ebx,%eax
  803900:	83 c4 14             	add    $0x14,%esp
  803903:	5b                   	pop    %ebx
  803904:	5d                   	pop    %ebp
  803905:	c3                   	ret    

00803906 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803906:	55                   	push   %ebp
  803907:	89 e5                	mov    %esp,%ebp
  803909:	53                   	push   %ebx
  80390a:	83 ec 14             	sub    $0x14,%esp
  80390d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803918:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80391c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80391f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803923:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80392a:	e8 0d d1 ff ff       	call   800a3c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80392f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803935:	b8 02 00 00 00       	mov    $0x2,%eax
  80393a:	e8 35 ff ff ff       	call   803874 <_ZL5nsipcj>
}
  80393f:	83 c4 14             	add    $0x14,%esp
  803942:	5b                   	pop    %ebx
  803943:	5d                   	pop    %ebp
  803944:	c3                   	ret    

00803945 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803945:	55                   	push   %ebp
  803946:	89 e5                	mov    %esp,%ebp
  803948:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80394b:	8b 45 08             	mov    0x8(%ebp),%eax
  80394e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803953:	8b 45 0c             	mov    0xc(%ebp),%eax
  803956:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80395b:	b8 03 00 00 00       	mov    $0x3,%eax
  803960:	e8 0f ff ff ff       	call   803874 <_ZL5nsipcj>
}
  803965:	c9                   	leave  
  803966:	c3                   	ret    

00803967 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803967:	55                   	push   %ebp
  803968:	89 e5                	mov    %esp,%ebp
  80396a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80396d:	8b 45 08             	mov    0x8(%ebp),%eax
  803970:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803975:	b8 04 00 00 00       	mov    $0x4,%eax
  80397a:	e8 f5 fe ff ff       	call   803874 <_ZL5nsipcj>
}
  80397f:	c9                   	leave  
  803980:	c3                   	ret    

00803981 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803981:	55                   	push   %ebp
  803982:	89 e5                	mov    %esp,%ebp
  803984:	53                   	push   %ebx
  803985:	83 ec 14             	sub    $0x14,%esp
  803988:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803993:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80399a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80399e:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8039a5:	e8 92 d0 ff ff       	call   800a3c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8039aa:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8039b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8039b5:	e8 ba fe ff ff       	call   803874 <_ZL5nsipcj>
}
  8039ba:	83 c4 14             	add    $0x14,%esp
  8039bd:	5b                   	pop    %ebx
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    

008039c0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  8039c0:	55                   	push   %ebp
  8039c1:	89 e5                	mov    %esp,%ebp
  8039c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8039ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039d1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8039d6:	b8 06 00 00 00       	mov    $0x6,%eax
  8039db:	e8 94 fe ff ff       	call   803874 <_ZL5nsipcj>
}
  8039e0:	c9                   	leave  
  8039e1:	c3                   	ret    

008039e2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8039e2:	55                   	push   %ebp
  8039e3:	89 e5                	mov    %esp,%ebp
  8039e5:	56                   	push   %esi
  8039e6:	53                   	push   %ebx
  8039e7:	83 ec 10             	sub    $0x10,%esp
  8039ea:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8039ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8039f5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8039fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8039fe:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a03:	b8 07 00 00 00       	mov    $0x7,%eax
  803a08:	e8 67 fe ff ff       	call   803874 <_ZL5nsipcj>
  803a0d:	89 c3                	mov    %eax,%ebx
  803a0f:	85 c0                	test   %eax,%eax
  803a11:	78 46                	js     803a59 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803a13:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803a18:	7f 04                	jg     803a1e <_Z10nsipc_recviPvij+0x3c>
  803a1a:	39 f0                	cmp    %esi,%eax
  803a1c:	7e 24                	jle    803a42 <_Z10nsipc_recviPvij+0x60>
  803a1e:	c7 44 24 0c 3f 4c 80 	movl   $0x804c3f,0xc(%esp)
  803a25:	00 
  803a26:	c7 44 24 08 ac 45 80 	movl   $0x8045ac,0x8(%esp)
  803a2d:	00 
  803a2e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803a35:	00 
  803a36:	c7 04 24 54 4c 80 00 	movl   $0x804c54,(%esp)
  803a3d:	e8 6a 02 00 00       	call   803cac <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803a42:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a46:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803a4d:	00 
  803a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a51:	89 04 24             	mov    %eax,(%esp)
  803a54:	e8 e3 cf ff ff       	call   800a3c <memmove>
	}

	return r;
}
  803a59:	89 d8                	mov    %ebx,%eax
  803a5b:	83 c4 10             	add    $0x10,%esp
  803a5e:	5b                   	pop    %ebx
  803a5f:	5e                   	pop    %esi
  803a60:	5d                   	pop    %ebp
  803a61:	c3                   	ret    

00803a62 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a62:	55                   	push   %ebp
  803a63:	89 e5                	mov    %esp,%ebp
  803a65:	53                   	push   %ebx
  803a66:	83 ec 14             	sub    $0x14,%esp
  803a69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803a74:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803a7a:	7e 24                	jle    803aa0 <_Z10nsipc_sendiPKvij+0x3e>
  803a7c:	c7 44 24 0c 60 4c 80 	movl   $0x804c60,0xc(%esp)
  803a83:	00 
  803a84:	c7 44 24 08 ac 45 80 	movl   $0x8045ac,0x8(%esp)
  803a8b:	00 
  803a8c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803a93:	00 
  803a94:	c7 04 24 54 4c 80 00 	movl   $0x804c54,(%esp)
  803a9b:	e8 0c 02 00 00       	call   803cac <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803aa0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  803aab:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803ab2:	e8 85 cf ff ff       	call   800a3c <memmove>
	nsipcbuf.send.req_size = size;
  803ab7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  803abd:	8b 45 14             	mov    0x14(%ebp),%eax
  803ac0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803ac5:	b8 08 00 00 00       	mov    $0x8,%eax
  803aca:	e8 a5 fd ff ff       	call   803874 <_ZL5nsipcj>
}
  803acf:	83 c4 14             	add    $0x14,%esp
  803ad2:	5b                   	pop    %ebx
  803ad3:	5d                   	pop    %ebp
  803ad4:	c3                   	ret    

00803ad5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ad5:	55                   	push   %ebp
  803ad6:	89 e5                	mov    %esp,%ebp
  803ad8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803adb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ade:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ae6:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  803aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  803aee:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803af3:	b8 09 00 00 00       	mov    $0x9,%eax
  803af8:	e8 77 fd ff ff       	call   803874 <_ZL5nsipcj>
}
  803afd:	c9                   	leave  
  803afe:	c3                   	ret    
	...

00803b00 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803b00:	55                   	push   %ebp
  803b01:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803b03:	b8 00 00 00 00       	mov    $0x0,%eax
  803b08:	5d                   	pop    %ebp
  803b09:	c3                   	ret    

00803b0a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b0a:	55                   	push   %ebp
  803b0b:	89 e5                	mov    %esp,%ebp
  803b0d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803b10:	c7 44 24 04 6c 4c 80 	movl   $0x804c6c,0x4(%esp)
  803b17:	00 
  803b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1b:	89 04 24             	mov    %eax,(%esp)
  803b1e:	e8 77 cd ff ff       	call   80089a <_Z6strcpyPcPKc>
	return 0;
}
  803b23:	b8 00 00 00 00       	mov    $0x0,%eax
  803b28:	c9                   	leave  
  803b29:	c3                   	ret    

00803b2a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b2a:	55                   	push   %ebp
  803b2b:	89 e5                	mov    %esp,%ebp
  803b2d:	57                   	push   %edi
  803b2e:	56                   	push   %esi
  803b2f:	53                   	push   %ebx
  803b30:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b36:	bb 00 00 00 00       	mov    $0x0,%ebx
  803b3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803b3f:	74 3e                	je     803b7f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803b41:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803b47:	8b 75 10             	mov    0x10(%ebp),%esi
  803b4a:	29 de                	sub    %ebx,%esi
  803b4c:	83 fe 7f             	cmp    $0x7f,%esi
  803b4f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803b54:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803b57:	89 74 24 08          	mov    %esi,0x8(%esp)
  803b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b5e:	01 d8                	add    %ebx,%eax
  803b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b64:	89 3c 24             	mov    %edi,(%esp)
  803b67:	e8 d0 ce ff ff       	call   800a3c <memmove>
		sys_cputs(buf, m);
  803b6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803b70:	89 3c 24             	mov    %edi,(%esp)
  803b73:	e8 dc d0 ff ff       	call   800c54 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b78:	01 f3                	add    %esi,%ebx
  803b7a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803b7d:	77 c8                	ja     803b47 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803b7f:	89 d8                	mov    %ebx,%eax
  803b81:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803b87:	5b                   	pop    %ebx
  803b88:	5e                   	pop    %esi
  803b89:	5f                   	pop    %edi
  803b8a:	5d                   	pop    %ebp
  803b8b:	c3                   	ret    

00803b8c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b8c:	55                   	push   %ebp
  803b8d:	89 e5                	mov    %esp,%ebp
  803b8f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803b92:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803b97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803b9b:	75 07                	jne    803ba4 <_ZL12devcons_readP2FdPvj+0x18>
  803b9d:	eb 2a                	jmp    803bc9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803b9f:	e8 a8 d1 ff ff       	call   800d4c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803ba4:	e8 de d0 ff ff       	call   800c87 <_Z9sys_cgetcv>
  803ba9:	85 c0                	test   %eax,%eax
  803bab:	74 f2                	je     803b9f <_ZL12devcons_readP2FdPvj+0x13>
  803bad:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803baf:	85 c0                	test   %eax,%eax
  803bb1:	78 16                	js     803bc9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803bb3:	83 f8 04             	cmp    $0x4,%eax
  803bb6:	74 0c                	je     803bc4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bbb:	88 10                	mov    %dl,(%eax)
	return 1;
  803bbd:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc2:	eb 05                	jmp    803bc9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803bc4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803bc9:	c9                   	leave  
  803bca:	c3                   	ret    

00803bcb <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bcb:	55                   	push   %ebp
  803bcc:	89 e5                	mov    %esp,%ebp
  803bce:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  803bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bd7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803bde:	00 
  803bdf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803be2:	89 04 24             	mov    %eax,(%esp)
  803be5:	e8 6a d0 ff ff       	call   800c54 <_Z9sys_cputsPKcj>
}
  803bea:	c9                   	leave  
  803beb:	c3                   	ret    

00803bec <_Z7getcharv>:

int
getchar(void)
{
  803bec:	55                   	push   %ebp
  803bed:	89 e5                	mov    %esp,%ebp
  803bef:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803bf2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803bf9:	00 
  803bfa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c08:	e8 41 db ff ff       	call   80174e <_Z4readiPvj>
	if (r < 0)
  803c0d:	85 c0                	test   %eax,%eax
  803c0f:	78 0f                	js     803c20 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  803c11:	85 c0                	test   %eax,%eax
  803c13:	7e 06                	jle    803c1b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  803c15:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803c19:	eb 05                	jmp    803c20 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803c1b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  803c20:	c9                   	leave  
  803c21:	c3                   	ret    

00803c22 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  803c22:	55                   	push   %ebp
  803c23:	89 e5                	mov    %esp,%ebp
  803c25:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803c28:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803c2f:	00 
  803c30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c37:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3a:	89 04 24             	mov    %eax,(%esp)
  803c3d:	e8 5f d7 ff ff       	call   8013a1 <_Z9fd_lookupiPP2Fdb>
  803c42:	85 c0                	test   %eax,%eax
  803c44:	78 11                	js     803c57 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  803c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c49:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803c4f:	39 10                	cmp    %edx,(%eax)
  803c51:	0f 94 c0             	sete   %al
  803c54:	0f b6 c0             	movzbl %al,%eax
}
  803c57:	c9                   	leave  
  803c58:	c3                   	ret    

00803c59 <_Z8openconsv>:

int
opencons(void)
{
  803c59:	55                   	push   %ebp
  803c5a:	89 e5                	mov    %esp,%ebp
  803c5c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  803c5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803c62:	89 04 24             	mov    %eax,(%esp)
  803c65:	e8 ed d7 ff ff       	call   801457 <_Z14fd_find_unusedPP2Fd>
  803c6a:	85 c0                	test   %eax,%eax
  803c6c:	78 3c                	js     803caa <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c6e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803c75:	00 
  803c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c84:	e8 f7 d0 ff ff       	call   800d80 <_Z14sys_page_allociPvi>
  803c89:	85 c0                	test   %eax,%eax
  803c8b:	78 1d                	js     803caa <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  803c8d:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c96:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803ca2:	89 04 24             	mov    %eax,(%esp)
  803ca5:	e8 4a d7 ff ff       	call   8013f4 <_Z6fd2numP2Fd>
}
  803caa:	c9                   	leave  
  803cab:	c3                   	ret    

00803cac <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803cac:	55                   	push   %ebp
  803cad:	89 e5                	mov    %esp,%ebp
  803caf:	56                   	push   %esi
  803cb0:	53                   	push   %ebx
  803cb1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  803cb4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  803cb7:	a1 00 80 80 00       	mov    0x808000,%eax
  803cbc:	85 c0                	test   %eax,%eax
  803cbe:	74 10                	je     803cd0 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  803cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cc4:	c7 04 24 78 4c 80 00 	movl   $0x804c78,(%esp)
  803ccb:	e8 ae c5 ff ff       	call   80027e <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  803cd0:	8b 1d 00 50 80 00    	mov    0x805000,%ebx
  803cd6:	e8 3d d0 ff ff       	call   800d18 <_Z12sys_getenvidv>
  803cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cde:	89 54 24 10          	mov    %edx,0x10(%esp)
  803ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ce5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803ce9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ced:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cf1:	c7 04 24 80 4c 80 00 	movl   $0x804c80,(%esp)
  803cf8:	e8 81 c5 ff ff       	call   80027e <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  803cfd:	89 74 24 04          	mov    %esi,0x4(%esp)
  803d01:	8b 45 10             	mov    0x10(%ebp),%eax
  803d04:	89 04 24             	mov    %eax,(%esp)
  803d07:	e8 11 c5 ff ff       	call   80021d <_Z8vcprintfPKcPc>
	cprintf("\n");
  803d0c:	c7 04 24 f0 41 80 00 	movl   $0x8041f0,(%esp)
  803d13:	e8 66 c5 ff ff       	call   80027e <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803d18:	cc                   	int3   
  803d19:	eb fd                	jmp    803d18 <_Z6_panicPKciS0_z+0x6c>
  803d1b:	00 00                	add    %al,(%eax)
  803d1d:	00 00                	add    %al,(%eax)
	...

00803d20 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  803d20:	55                   	push   %ebp
  803d21:	89 e5                	mov    %esp,%ebp
  803d23:	56                   	push   %esi
  803d24:	53                   	push   %ebx
  803d25:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803d28:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  803d2d:	8b 04 9d 20 80 80 00 	mov    0x808020(,%ebx,4),%eax
  803d34:	85 c0                	test   %eax,%eax
  803d36:	74 08                	je     803d40 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  803d38:	8d 55 08             	lea    0x8(%ebp),%edx
  803d3b:	89 14 24             	mov    %edx,(%esp)
  803d3e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  803d40:	83 eb 01             	sub    $0x1,%ebx
  803d43:	83 fb ff             	cmp    $0xffffffff,%ebx
  803d46:	75 e5                	jne    803d2d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  803d48:	8b 5d 38             	mov    0x38(%ebp),%ebx
  803d4b:	8b 75 08             	mov    0x8(%ebp),%esi
  803d4e:	e8 c5 cf ff ff       	call   800d18 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  803d53:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  803d57:	89 74 24 10          	mov    %esi,0x10(%esp)
  803d5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d5f:	c7 44 24 08 a4 4c 80 	movl   $0x804ca4,0x8(%esp)
  803d66:	00 
  803d67:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  803d6e:	00 
  803d6f:	c7 04 24 28 4d 80 00 	movl   $0x804d28,(%esp)
  803d76:	e8 31 ff ff ff       	call   803cac <_Z6_panicPKciS0_z>

00803d7b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  803d7b:	55                   	push   %ebp
  803d7c:	89 e5                	mov    %esp,%ebp
  803d7e:	56                   	push   %esi
  803d7f:	53                   	push   %ebx
  803d80:	83 ec 10             	sub    $0x10,%esp
  803d83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  803d86:	e8 8d cf ff ff       	call   800d18 <_Z12sys_getenvidv>
  803d8b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  803d8d:	a1 00 60 80 00       	mov    0x806000,%eax
  803d92:	8b 40 5c             	mov    0x5c(%eax),%eax
  803d95:	85 c0                	test   %eax,%eax
  803d97:	75 4c                	jne    803de5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  803d99:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803da0:	00 
  803da1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  803da8:	ee 
  803da9:	89 34 24             	mov    %esi,(%esp)
  803dac:	e8 cf cf ff ff       	call   800d80 <_Z14sys_page_allociPvi>
  803db1:	85 c0                	test   %eax,%eax
  803db3:	74 20                	je     803dd5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  803db5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803db9:	c7 44 24 08 dc 4c 80 	movl   $0x804cdc,0x8(%esp)
  803dc0:	00 
  803dc1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  803dc8:	00 
  803dc9:	c7 04 24 28 4d 80 00 	movl   $0x804d28,(%esp)
  803dd0:	e8 d7 fe ff ff       	call   803cac <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  803dd5:	c7 44 24 04 20 3d 80 	movl   $0x803d20,0x4(%esp)
  803ddc:	00 
  803ddd:	89 34 24             	mov    %esi,(%esp)
  803de0:	e8 d0 d1 ff ff       	call   800fb5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803de5:	a1 20 80 80 00       	mov    0x808020,%eax
  803dea:	39 d8                	cmp    %ebx,%eax
  803dec:	74 1a                	je     803e08 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  803dee:	85 c0                	test   %eax,%eax
  803df0:	74 20                	je     803e12 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803df2:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  803df7:	8b 14 85 20 80 80 00 	mov    0x808020(,%eax,4),%edx
  803dfe:	39 da                	cmp    %ebx,%edx
  803e00:	74 15                	je     803e17 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803e02:	85 d2                	test   %edx,%edx
  803e04:	75 1f                	jne    803e25 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  803e06:	eb 0f                	jmp    803e17 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803e08:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0d:	8d 76 00             	lea    0x0(%esi),%esi
  803e10:	eb 05                	jmp    803e17 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  803e12:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  803e17:	89 1c 85 20 80 80 00 	mov    %ebx,0x808020(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  803e1e:	83 c4 10             	add    $0x10,%esp
  803e21:	5b                   	pop    %ebx
  803e22:	5e                   	pop    %esi
  803e23:	5d                   	pop    %ebp
  803e24:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  803e25:	83 c0 01             	add    $0x1,%eax
  803e28:	83 f8 08             	cmp    $0x8,%eax
  803e2b:	75 ca                	jne    803df7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  803e2d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803e31:	c7 44 24 08 00 4d 80 	movl   $0x804d00,0x8(%esp)
  803e38:	00 
  803e39:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803e40:	00 
  803e41:	c7 04 24 28 4d 80 00 	movl   $0x804d28,(%esp)
  803e48:	e8 5f fe ff ff       	call   803cac <_Z6_panicPKciS0_z>
  803e4d:	00 00                	add    %al,(%eax)
	...

00803e50 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  803e50:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  803e53:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  803e54:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  803e57:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  803e5b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  803e5f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  803e62:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  803e64:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  803e68:	61                   	popa   
    popf
  803e69:	9d                   	popf   
    popl %esp
  803e6a:	5c                   	pop    %esp
    ret
  803e6b:	c3                   	ret    

00803e6c <spin>:

spin:	jmp spin
  803e6c:	eb fe                	jmp    803e6c <spin>
	...

00803e70 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e70:	55                   	push   %ebp
  803e71:	89 e5                	mov    %esp,%ebp
  803e73:	56                   	push   %esi
  803e74:	53                   	push   %ebx
  803e75:	83 ec 10             	sub    $0x10,%esp
  803e78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e7e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  803e81:	85 c0                	test   %eax,%eax
  803e83:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  803e88:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  803e8b:	89 04 24             	mov    %eax,(%esp)
  803e8e:	e8 b8 d1 ff ff       	call   80104b <_Z12sys_ipc_recvPv>
  803e93:	85 c0                	test   %eax,%eax
  803e95:	79 16                	jns    803ead <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  803e97:	85 db                	test   %ebx,%ebx
  803e99:	74 06                	je     803ea1 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  803e9b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  803ea1:	85 f6                	test   %esi,%esi
  803ea3:	74 53                	je     803ef8 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  803ea5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803eab:	eb 4b                	jmp    803ef8 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  803ead:	85 db                	test   %ebx,%ebx
  803eaf:	74 17                	je     803ec8 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  803eb1:	e8 62 ce ff ff       	call   800d18 <_Z12sys_getenvidv>
  803eb6:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ebb:	6b c0 78             	imul   $0x78,%eax,%eax
  803ebe:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  803ec3:	8b 40 60             	mov    0x60(%eax),%eax
  803ec6:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  803ec8:	85 f6                	test   %esi,%esi
  803eca:	74 17                	je     803ee3 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  803ecc:	e8 47 ce ff ff       	call   800d18 <_Z12sys_getenvidv>
  803ed1:	25 ff 03 00 00       	and    $0x3ff,%eax
  803ed6:	6b c0 78             	imul   $0x78,%eax,%eax
  803ed9:	05 00 00 00 ef       	add    $0xef000000,%eax
  803ede:	8b 40 70             	mov    0x70(%eax),%eax
  803ee1:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  803ee3:	e8 30 ce ff ff       	call   800d18 <_Z12sys_getenvidv>
  803ee8:	25 ff 03 00 00       	and    $0x3ff,%eax
  803eed:	6b c0 78             	imul   $0x78,%eax,%eax
  803ef0:	05 08 00 00 ef       	add    $0xef000008,%eax
  803ef5:	8b 40 60             	mov    0x60(%eax),%eax

}
  803ef8:	83 c4 10             	add    $0x10,%esp
  803efb:	5b                   	pop    %ebx
  803efc:	5e                   	pop    %esi
  803efd:	5d                   	pop    %ebp
  803efe:	c3                   	ret    

00803eff <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803eff:	55                   	push   %ebp
  803f00:	89 e5                	mov    %esp,%ebp
  803f02:	57                   	push   %edi
  803f03:	56                   	push   %esi
  803f04:	53                   	push   %ebx
  803f05:	83 ec 1c             	sub    $0x1c,%esp
  803f08:	8b 75 08             	mov    0x8(%ebp),%esi
  803f0b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803f0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  803f11:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  803f13:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803f18:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  803f1e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f22:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f26:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803f2a:	89 34 24             	mov    %esi,(%esp)
  803f2d:	e8 e1 d0 ff ff       	call   801013 <_Z16sys_ipc_try_sendijPvi>
  803f32:	85 c0                	test   %eax,%eax
  803f34:	79 31                	jns    803f67 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  803f36:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803f39:	75 0c                	jne    803f47 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  803f3b:	90                   	nop
  803f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803f40:	e8 07 ce ff ff       	call   800d4c <_Z9sys_yieldv>
  803f45:	eb d4                	jmp    803f1b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  803f47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f4b:	c7 44 24 08 36 4d 80 	movl   $0x804d36,0x8(%esp)
  803f52:	00 
  803f53:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  803f5a:	00 
  803f5b:	c7 04 24 43 4d 80 00 	movl   $0x804d43,(%esp)
  803f62:	e8 45 fd ff ff       	call   803cac <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  803f67:	83 c4 1c             	add    $0x1c,%esp
  803f6a:	5b                   	pop    %ebx
  803f6b:	5e                   	pop    %esi
  803f6c:	5f                   	pop    %edi
  803f6d:	5d                   	pop    %ebp
  803f6e:	c3                   	ret    
	...

00803f70 <__udivdi3>:
  803f70:	55                   	push   %ebp
  803f71:	89 e5                	mov    %esp,%ebp
  803f73:	57                   	push   %edi
  803f74:	56                   	push   %esi
  803f75:	83 ec 20             	sub    $0x20,%esp
  803f78:	8b 45 14             	mov    0x14(%ebp),%eax
  803f7b:	8b 75 08             	mov    0x8(%ebp),%esi
  803f7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803f81:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803f84:	85 c0                	test   %eax,%eax
  803f86:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803f89:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  803f8c:	75 3a                	jne    803fc8 <__udivdi3+0x58>
  803f8e:	39 f9                	cmp    %edi,%ecx
  803f90:	77 66                	ja     803ff8 <__udivdi3+0x88>
  803f92:	85 c9                	test   %ecx,%ecx
  803f94:	75 0b                	jne    803fa1 <__udivdi3+0x31>
  803f96:	b8 01 00 00 00       	mov    $0x1,%eax
  803f9b:	31 d2                	xor    %edx,%edx
  803f9d:	f7 f1                	div    %ecx
  803f9f:	89 c1                	mov    %eax,%ecx
  803fa1:	89 f8                	mov    %edi,%eax
  803fa3:	31 d2                	xor    %edx,%edx
  803fa5:	f7 f1                	div    %ecx
  803fa7:	89 c7                	mov    %eax,%edi
  803fa9:	89 f0                	mov    %esi,%eax
  803fab:	f7 f1                	div    %ecx
  803fad:	89 fa                	mov    %edi,%edx
  803faf:	89 c6                	mov    %eax,%esi
  803fb1:	89 75 f0             	mov    %esi,-0x10(%ebp)
  803fb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fbd:	83 c4 20             	add    $0x20,%esp
  803fc0:	5e                   	pop    %esi
  803fc1:	5f                   	pop    %edi
  803fc2:	5d                   	pop    %ebp
  803fc3:	c3                   	ret    
  803fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803fc8:	31 d2                	xor    %edx,%edx
  803fca:	31 f6                	xor    %esi,%esi
  803fcc:	39 f8                	cmp    %edi,%eax
  803fce:	77 e1                	ja     803fb1 <__udivdi3+0x41>
  803fd0:	0f bd d0             	bsr    %eax,%edx
  803fd3:	83 f2 1f             	xor    $0x1f,%edx
  803fd6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803fd9:	75 2d                	jne    804008 <__udivdi3+0x98>
  803fdb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  803fde:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  803fe1:	76 06                	jbe    803fe9 <__udivdi3+0x79>
  803fe3:	39 f8                	cmp    %edi,%eax
  803fe5:	89 f2                	mov    %esi,%edx
  803fe7:	73 c8                	jae    803fb1 <__udivdi3+0x41>
  803fe9:	31 d2                	xor    %edx,%edx
  803feb:	be 01 00 00 00       	mov    $0x1,%esi
  803ff0:	eb bf                	jmp    803fb1 <__udivdi3+0x41>
  803ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803ff8:	89 f0                	mov    %esi,%eax
  803ffa:	89 fa                	mov    %edi,%edx
  803ffc:	f7 f1                	div    %ecx
  803ffe:	31 d2                	xor    %edx,%edx
  804000:	89 c6                	mov    %eax,%esi
  804002:	eb ad                	jmp    803fb1 <__udivdi3+0x41>
  804004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804008:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80400c:	89 c2                	mov    %eax,%edx
  80400e:	b8 20 00 00 00       	mov    $0x20,%eax
  804013:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804016:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804019:	d3 e2                	shl    %cl,%edx
  80401b:	89 c1                	mov    %eax,%ecx
  80401d:	d3 ee                	shr    %cl,%esi
  80401f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804023:	09 d6                	or     %edx,%esi
  804025:	89 fa                	mov    %edi,%edx
  804027:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80402a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80402d:	d3 e6                	shl    %cl,%esi
  80402f:	89 c1                	mov    %eax,%ecx
  804031:	d3 ea                	shr    %cl,%edx
  804033:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804037:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80403a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80403d:	d3 e7                	shl    %cl,%edi
  80403f:	89 c1                	mov    %eax,%ecx
  804041:	d3 ee                	shr    %cl,%esi
  804043:	09 fe                	or     %edi,%esi
  804045:	89 f0                	mov    %esi,%eax
  804047:	f7 75 e4             	divl   -0x1c(%ebp)
  80404a:	89 d7                	mov    %edx,%edi
  80404c:	89 c6                	mov    %eax,%esi
  80404e:	f7 65 f0             	mull   -0x10(%ebp)
  804051:	39 d7                	cmp    %edx,%edi
  804053:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804056:	72 12                	jb     80406a <__udivdi3+0xfa>
  804058:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80405b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80405f:	d3 e2                	shl    %cl,%edx
  804061:	39 c2                	cmp    %eax,%edx
  804063:	73 08                	jae    80406d <__udivdi3+0xfd>
  804065:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804068:	75 03                	jne    80406d <__udivdi3+0xfd>
  80406a:	83 ee 01             	sub    $0x1,%esi
  80406d:	31 d2                	xor    %edx,%edx
  80406f:	e9 3d ff ff ff       	jmp    803fb1 <__udivdi3+0x41>
	...

00804080 <__umoddi3>:
  804080:	55                   	push   %ebp
  804081:	89 e5                	mov    %esp,%ebp
  804083:	57                   	push   %edi
  804084:	56                   	push   %esi
  804085:	83 ec 20             	sub    $0x20,%esp
  804088:	8b 7d 14             	mov    0x14(%ebp),%edi
  80408b:	8b 45 08             	mov    0x8(%ebp),%eax
  80408e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804091:	8b 75 0c             	mov    0xc(%ebp),%esi
  804094:	85 ff                	test   %edi,%edi
  804096:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804099:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80409c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80409f:	89 f2                	mov    %esi,%edx
  8040a1:	75 15                	jne    8040b8 <__umoddi3+0x38>
  8040a3:	39 f1                	cmp    %esi,%ecx
  8040a5:	76 41                	jbe    8040e8 <__umoddi3+0x68>
  8040a7:	f7 f1                	div    %ecx
  8040a9:	89 d0                	mov    %edx,%eax
  8040ab:	31 d2                	xor    %edx,%edx
  8040ad:	83 c4 20             	add    $0x20,%esp
  8040b0:	5e                   	pop    %esi
  8040b1:	5f                   	pop    %edi
  8040b2:	5d                   	pop    %ebp
  8040b3:	c3                   	ret    
  8040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8040b8:	39 f7                	cmp    %esi,%edi
  8040ba:	77 4c                	ja     804108 <__umoddi3+0x88>
  8040bc:	0f bd c7             	bsr    %edi,%eax
  8040bf:	83 f0 1f             	xor    $0x1f,%eax
  8040c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8040c5:	75 51                	jne    804118 <__umoddi3+0x98>
  8040c7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  8040ca:	0f 87 e8 00 00 00    	ja     8041b8 <__umoddi3+0x138>
  8040d0:	89 f2                	mov    %esi,%edx
  8040d2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8040d5:	29 ce                	sub    %ecx,%esi
  8040d7:	19 fa                	sbb    %edi,%edx
  8040d9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8040dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040df:	83 c4 20             	add    $0x20,%esp
  8040e2:	5e                   	pop    %esi
  8040e3:	5f                   	pop    %edi
  8040e4:	5d                   	pop    %ebp
  8040e5:	c3                   	ret    
  8040e6:	66 90                	xchg   %ax,%ax
  8040e8:	85 c9                	test   %ecx,%ecx
  8040ea:	75 0b                	jne    8040f7 <__umoddi3+0x77>
  8040ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8040f1:	31 d2                	xor    %edx,%edx
  8040f3:	f7 f1                	div    %ecx
  8040f5:	89 c1                	mov    %eax,%ecx
  8040f7:	89 f0                	mov    %esi,%eax
  8040f9:	31 d2                	xor    %edx,%edx
  8040fb:	f7 f1                	div    %ecx
  8040fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804100:	eb a5                	jmp    8040a7 <__umoddi3+0x27>
  804102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804108:	89 f2                	mov    %esi,%edx
  80410a:	83 c4 20             	add    $0x20,%esp
  80410d:	5e                   	pop    %esi
  80410e:	5f                   	pop    %edi
  80410f:	5d                   	pop    %ebp
  804110:	c3                   	ret    
  804111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804118:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80411c:	89 f2                	mov    %esi,%edx
  80411e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804121:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804128:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80412b:	d3 e7                	shl    %cl,%edi
  80412d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804130:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804134:	d3 e8                	shr    %cl,%eax
  804136:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80413a:	09 f8                	or     %edi,%eax
  80413c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80413f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804142:	d3 e0                	shl    %cl,%eax
  804144:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804148:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80414b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80414e:	d3 ea                	shr    %cl,%edx
  804150:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804154:	d3 e6                	shl    %cl,%esi
  804156:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80415a:	d3 e8                	shr    %cl,%eax
  80415c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804160:	09 f0                	or     %esi,%eax
  804162:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804165:	f7 75 e4             	divl   -0x1c(%ebp)
  804168:	d3 e6                	shl    %cl,%esi
  80416a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80416d:	89 d6                	mov    %edx,%esi
  80416f:	f7 65 f4             	mull   -0xc(%ebp)
  804172:	89 d7                	mov    %edx,%edi
  804174:	89 c2                	mov    %eax,%edx
  804176:	39 fe                	cmp    %edi,%esi
  804178:	89 f9                	mov    %edi,%ecx
  80417a:	72 30                	jb     8041ac <__umoddi3+0x12c>
  80417c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80417f:	72 27                	jb     8041a8 <__umoddi3+0x128>
  804181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804184:	29 d0                	sub    %edx,%eax
  804186:	19 ce                	sbb    %ecx,%esi
  804188:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80418c:	89 f2                	mov    %esi,%edx
  80418e:	d3 e8                	shr    %cl,%eax
  804190:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804194:	d3 e2                	shl    %cl,%edx
  804196:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80419a:	09 d0                	or     %edx,%eax
  80419c:	89 f2                	mov    %esi,%edx
  80419e:	d3 ea                	shr    %cl,%edx
  8041a0:	83 c4 20             	add    $0x20,%esp
  8041a3:	5e                   	pop    %esi
  8041a4:	5f                   	pop    %edi
  8041a5:	5d                   	pop    %ebp
  8041a6:	c3                   	ret    
  8041a7:	90                   	nop
  8041a8:	39 fe                	cmp    %edi,%esi
  8041aa:	75 d5                	jne    804181 <__umoddi3+0x101>
  8041ac:	89 f9                	mov    %edi,%ecx
  8041ae:	89 c2                	mov    %eax,%edx
  8041b0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  8041b3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8041b6:	eb c9                	jmp    804181 <__umoddi3+0x101>
  8041b8:	39 f7                	cmp    %esi,%edi
  8041ba:	0f 82 10 ff ff ff    	jb     8040d0 <__umoddi3+0x50>
  8041c0:	e9 17 ff ff ff       	jmp    8040dc <__umoddi3+0x5c>
