
obj/user/primespipe:     file format elf32-i386


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
  80002c:	e8 93 02 00 00       	call   8002c4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z9primeproci>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800040:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800043:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800046:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004d:	00 
  80004e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800052:	89 1c 24             	mov    %ebx,(%esp)
  800055:	e8 fe 1c 00 00       	call   801d58 <_Z5readniPvj>
  80005a:	83 f8 04             	cmp    $0x4,%eax
  80005d:	74 2e                	je     80008d <_Z9primeproci+0x59>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005f:	85 c0                	test   %eax,%eax
  800061:	ba 00 00 00 00       	mov    $0x0,%edx
  800066:	0f 4e d0             	cmovle %eax,%edx
  800069:	89 54 24 10          	mov    %edx,0x10(%esp)
  80006d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800071:	c7 44 24 08 a0 45 80 	movl   $0x8045a0,0x8(%esp)
  800078:	00 
  800079:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800080:	00 
  800081:	c7 04 24 cf 45 80 00 	movl   $0x8045cf,(%esp)
  800088:	e8 bb 02 00 00       	call   800348 <_Z6_panicPKciS0_z>

	cprintf("%d\n", p);
  80008d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800090:	89 44 24 04          	mov    %eax,0x4(%esp)
  800094:	c7 04 24 e1 45 80 00 	movl   $0x8045e1,(%esp)
  80009b:	e8 c6 03 00 00       	call   800466 <_Z7cprintfPKcz>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000a0:	89 3c 24             	mov    %edi,(%esp)
  8000a3:	e8 4c 36 00 00       	call   8036f4 <_Z4pipePi>
  8000a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000ab:	85 c0                	test   %eax,%eax
  8000ad:	79 20                	jns    8000cf <_Z9primeproci+0x9b>
		panic("pipe: %e", i);
  8000af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b3:	c7 44 24 08 e5 45 80 	movl   $0x8045e5,0x8(%esp)
  8000ba:	00 
  8000bb:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c2:	00 
  8000c3:	c7 04 24 cf 45 80 00 	movl   $0x8045cf,(%esp)
  8000ca:	e8 79 02 00 00       	call   800348 <_Z6_panicPKciS0_z>
	if ((id = fork()) < 0)
  8000cf:	e8 c9 14 00 00       	call   80159d <_Z4forkv>
  8000d4:	85 c0                	test   %eax,%eax
  8000d6:	79 20                	jns    8000f8 <_Z9primeproci+0xc4>
		panic("fork: %e", id);
  8000d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000dc:	c7 44 24 08 48 4a 80 	movl   $0x804a48,0x8(%esp)
  8000e3:	00 
  8000e4:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000eb:	00 
  8000ec:	c7 04 24 cf 45 80 00 	movl   $0x8045cf,(%esp)
  8000f3:	e8 50 02 00 00       	call   800348 <_Z6_panicPKciS0_z>
	if (id == 0) {
  8000f8:	85 c0                	test   %eax,%eax
  8000fa:	75 1b                	jne    800117 <_Z9primeproci+0xe3>
		close(fd);
  8000fc:	89 1c 24             	mov    %ebx,(%esp)
  8000ff:	e8 11 1a 00 00       	call   801b15 <_Z5closei>
		close(pfd[1]);
  800104:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800107:	89 04 24             	mov    %eax,(%esp)
  80010a:	e8 06 1a 00 00       	call   801b15 <_Z5closei>
		fd = pfd[0];
  80010f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800112:	e9 2f ff ff ff       	jmp    800046 <_Z9primeproci+0x12>
	}

	close(pfd[0]);
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	89 04 24             	mov    %eax,(%esp)
  80011d:	e8 f3 19 00 00       	call   801b15 <_Z5closei>
	wfd = pfd[1];
  800122:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800125:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800128:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80012f:	00 
  800130:	89 74 24 04          	mov    %esi,0x4(%esp)
  800134:	89 1c 24             	mov    %ebx,(%esp)
  800137:	e8 1c 1c 00 00       	call   801d58 <_Z5readniPvj>
  80013c:	83 f8 04             	cmp    $0x4,%eax
  80013f:	74 39                	je     80017a <_Z9primeproci+0x146>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800141:	85 c0                	test   %eax,%eax
  800143:	ba 00 00 00 00       	mov    $0x0,%edx
  800148:	0f 4e d0             	cmovle %eax,%edx
  80014b:	89 54 24 18          	mov    %edx,0x18(%esp)
  80014f:	89 44 24 14          	mov    %eax,0x14(%esp)
  800153:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800157:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015e:	c7 44 24 08 ee 45 80 	movl   $0x8045ee,0x8(%esp)
  800165:	00 
  800166:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  80016d:	00 
  80016e:	c7 04 24 cf 45 80 00 	movl   $0x8045cf,(%esp)
  800175:	e8 ce 01 00 00       	call   800348 <_Z6_panicPKciS0_z>
		if (i%p)
  80017a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017d:	89 c2                	mov    %eax,%edx
  80017f:	c1 fa 1f             	sar    $0x1f,%edx
  800182:	f7 7d e0             	idivl  -0x20(%ebp)
  800185:	85 d2                	test   %edx,%edx
  800187:	74 9f                	je     800128 <_Z9primeproci+0xf4>
			if ((r=write(wfd, &i, 4)) != 4)
  800189:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800190:	00 
  800191:	89 74 24 04          	mov    %esi,0x4(%esp)
  800195:	89 3c 24             	mov    %edi,(%esp)
  800198:	e8 0c 1c 00 00       	call   801da9 <_Z5writeiPKvj>
  80019d:	83 f8 04             	cmp    $0x4,%eax
  8001a0:	74 86                	je     800128 <_Z9primeproci+0xf4>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a9:	0f 4e d0             	cmovle %eax,%edx
  8001ac:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001bb:	c7 44 24 08 0a 46 80 	movl   $0x80460a,0x8(%esp)
  8001c2:	00 
  8001c3:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001ca:	00 
  8001cb:	c7 04 24 cf 45 80 00 	movl   $0x8045cf,(%esp)
  8001d2:	e8 71 01 00 00       	call   800348 <_Z6_panicPKciS0_z>

008001d7 <_Z5umainiPPc>:
	}
}

void
umain(int argc, char **argv)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	53                   	push   %ebx
  8001db:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	argv0 = "primespipe";
  8001de:	c7 05 04 70 80 00 24 	movl   $0x804624,0x807004
  8001e5:	46 80 00 

	if ((i=pipe(p)) < 0)
  8001e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001eb:	89 04 24             	mov    %eax,(%esp)
  8001ee:	e8 01 35 00 00       	call   8036f4 <_Z4pipePi>
  8001f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001f6:	85 c0                	test   %eax,%eax
  8001f8:	79 20                	jns    80021a <_Z5umainiPPc+0x43>
		panic("pipe: %e", i);
  8001fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001fe:	c7 44 24 08 e5 45 80 	movl   $0x8045e5,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 cf 45 80 00 	movl   $0x8045cf,(%esp)
  800215:	e8 2e 01 00 00       	call   800348 <_Z6_panicPKciS0_z>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80021a:	e8 7e 13 00 00       	call   80159d <_Z4forkv>
  80021f:	85 c0                	test   %eax,%eax
  800221:	79 20                	jns    800243 <_Z5umainiPPc+0x6c>
		panic("fork: %e", id);
  800223:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800227:	c7 44 24 08 48 4a 80 	movl   $0x804a48,0x8(%esp)
  80022e:	00 
  80022f:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  800236:	00 
  800237:	c7 04 24 cf 45 80 00 	movl   $0x8045cf,(%esp)
  80023e:	e8 05 01 00 00       	call   800348 <_Z6_panicPKciS0_z>

	if (id == 0) {
  800243:	85 c0                	test   %eax,%eax
  800245:	75 16                	jne    80025d <_Z5umainiPPc+0x86>
		close(p[1]);
  800247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80024a:	89 04 24             	mov    %eax,(%esp)
  80024d:	e8 c3 18 00 00       	call   801b15 <_Z5closei>
		primeproc(p[0]);
  800252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	e8 d7 fd ff ff       	call   800034 <_Z9primeproci>
	}

	close(p[0]);
  80025d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800260:	89 04 24             	mov    %eax,(%esp)
  800263:	e8 ad 18 00 00       	call   801b15 <_Z5closei>

	// feed all the integers through
	for (i=2;; i++)
  800268:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80026f:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  800272:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800279:	00 
  80027a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800281:	89 04 24             	mov    %eax,(%esp)
  800284:	e8 20 1b 00 00       	call   801da9 <_Z5writeiPKvj>
  800289:	83 f8 04             	cmp    $0x4,%eax
  80028c:	74 2e                	je     8002bc <_Z5umainiPPc+0xe5>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  80028e:	85 c0                	test   %eax,%eax
  800290:	ba 00 00 00 00       	mov    $0x0,%edx
  800295:	0f 4e d0             	cmovle %eax,%edx
  800298:	89 54 24 10          	mov    %edx,0x10(%esp)
  80029c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a0:	c7 44 24 08 2f 46 80 	movl   $0x80462f,0x8(%esp)
  8002a7:	00 
  8002a8:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002af:	00 
  8002b0:	c7 04 24 cf 45 80 00 	movl   $0x8045cf,(%esp)
  8002b7:	e8 8c 00 00 00       	call   800348 <_Z6_panicPKciS0_z>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002bc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  8002c0:	eb b0                	jmp    800272 <_Z5umainiPPc+0x9b>
	...

008002c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	57                   	push   %edi
  8002c8:	56                   	push   %esi
  8002c9:	53                   	push   %ebx
  8002ca:	83 ec 1c             	sub    $0x1c,%esp
  8002cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8002d3:	e8 20 0c 00 00       	call   800ef8 <_Z12sys_getenvidv>
  8002d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002dd:	6b c0 78             	imul   $0x78,%eax,%eax
  8002e0:	05 00 00 00 ef       	add    $0xef000000,%eax
  8002e5:	a3 00 70 80 00       	mov    %eax,0x807000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ea:	85 ff                	test   %edi,%edi
  8002ec:	7e 07                	jle    8002f5 <libmain+0x31>
		binaryname = argv[0];
  8002ee:	8b 06                	mov    (%esi),%eax
  8002f0:	a3 00 60 80 00       	mov    %eax,0x806000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8002f5:	b8 05 52 80 00       	mov    $0x805205,%eax
  8002fa:	3d 05 52 80 00       	cmp    $0x805205,%eax
  8002ff:	76 0f                	jbe    800310 <libmain+0x4c>
  800301:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800303:	83 eb 04             	sub    $0x4,%ebx
  800306:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800308:	81 fb 05 52 80 00    	cmp    $0x805205,%ebx
  80030e:	77 f3                	ja     800303 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800310:	89 74 24 04          	mov    %esi,0x4(%esp)
  800314:	89 3c 24             	mov    %edi,(%esp)
  800317:	e8 bb fe ff ff       	call   8001d7 <_Z5umainiPPc>

	// exit gracefully
	exit();
  80031c:	e8 0b 00 00 00       	call   80032c <_Z4exitv>
}
  800321:	83 c4 1c             	add    $0x1c,%esp
  800324:	5b                   	pop    %ebx
  800325:	5e                   	pop    %esi
  800326:	5f                   	pop    %edi
  800327:	5d                   	pop    %ebp
  800328:	c3                   	ret    
  800329:	00 00                	add    %al,(%eax)
	...

0080032c <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800332:	e8 17 18 00 00       	call   801b4e <_Z9close_allv>
	sys_env_destroy(0);
  800337:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80033e:	e8 58 0b 00 00       	call   800e9b <_Z15sys_env_destroyi>
}
  800343:	c9                   	leave  
  800344:	c3                   	ret    
  800345:	00 00                	add    %al,(%eax)
	...

00800348 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	56                   	push   %esi
  80034c:	53                   	push   %ebx
  80034d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800350:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  800353:	a1 04 70 80 00       	mov    0x807004,%eax
  800358:	85 c0                	test   %eax,%eax
  80035a:	74 10                	je     80036c <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  80035c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800360:	c7 04 24 51 46 80 00 	movl   $0x804651,(%esp)
  800367:	e8 fa 00 00 00       	call   800466 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  80036c:	8b 1d 00 60 80 00    	mov    0x806000,%ebx
  800372:	e8 81 0b 00 00       	call   800ef8 <_Z12sys_getenvidv>
  800377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80037a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80037e:	8b 55 08             	mov    0x8(%ebp),%edx
  800381:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800385:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800389:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038d:	c7 04 24 58 46 80 00 	movl   $0x804658,(%esp)
  800394:	e8 cd 00 00 00       	call   800466 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  800399:	89 74 24 04          	mov    %esi,0x4(%esp)
  80039d:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a0:	89 04 24             	mov    %eax,(%esp)
  8003a3:	e8 5d 00 00 00       	call   800405 <_Z8vcprintfPKcPc>
	cprintf("\n");
  8003a8:	c7 04 24 e3 45 80 00 	movl   $0x8045e3,(%esp)
  8003af:	e8 b2 00 00 00       	call   800466 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003b4:	cc                   	int3   
  8003b5:	eb fd                	jmp    8003b4 <_Z6_panicPKciS0_z+0x6c>
	...

008003b8 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	83 ec 18             	sub    $0x18,%esp
  8003be:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8003c1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8003c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  8003c7:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8003c9:	8b 03                	mov    (%ebx),%eax
  8003cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ce:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8003d2:	83 c0 01             	add    $0x1,%eax
  8003d5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8003d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003dc:	75 19                	jne    8003f7 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8003de:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003e5:	00 
  8003e6:	8d 43 08             	lea    0x8(%ebx),%eax
  8003e9:	89 04 24             	mov    %eax,(%esp)
  8003ec:	e8 43 0a 00 00       	call   800e34 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8003f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003f7:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8003fb:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8003fe:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800401:	89 ec                	mov    %ebp,%esp
  800403:	5d                   	pop    %ebp
  800404:	c3                   	ret    

00800405 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80040e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800415:	00 00 00 
	b.cnt = 0;
  800418:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80041f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800422:	8b 45 0c             	mov    0xc(%ebp),%eax
  800425:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800430:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800436:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043a:	c7 04 24 b8 03 80 00 	movl   $0x8003b8,(%esp)
  800441:	e8 a1 01 00 00       	call   8005e7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800446:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80044c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800450:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800456:	89 04 24             	mov    %eax,(%esp)
  800459:	e8 d6 09 00 00       	call   800e34 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  80045e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800464:	c9                   	leave  
  800465:	c3                   	ret    

00800466 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80046c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80046f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	89 04 24             	mov    %eax,(%esp)
  800479:	e8 87 ff ff ff       	call   800405 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  80047e:	c9                   	leave  
  80047f:	c3                   	ret    

00800480 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	57                   	push   %edi
  800484:	56                   	push   %esi
  800485:	53                   	push   %ebx
  800486:	83 ec 4c             	sub    $0x4c,%esp
  800489:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80048c:	89 d6                	mov    %edx,%esi
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800494:	8b 55 0c             	mov    0xc(%ebp),%edx
  800497:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80049a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80049d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a5:	39 d0                	cmp    %edx,%eax
  8004a7:	72 11                	jb     8004ba <_ZL8printnumPFviPvES_yjii+0x3a>
  8004a9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ac:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  8004af:	76 09                	jbe    8004ba <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004b1:	83 eb 01             	sub    $0x1,%ebx
  8004b4:	85 db                	test   %ebx,%ebx
  8004b6:	7f 5d                	jg     800515 <_ZL8printnumPFviPvES_yjii+0x95>
  8004b8:	eb 6c                	jmp    800526 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ba:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004be:	83 eb 01             	sub    $0x1,%ebx
  8004c1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004d0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004d7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8004da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004e1:	00 
  8004e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004e5:	89 14 24             	mov    %edx,(%esp)
  8004e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004ef:	e8 4c 3e 00 00       	call   804340 <__udivdi3>
  8004f4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8004f7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004fa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004fe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800502:	89 04 24             	mov    %eax,(%esp)
  800505:	89 54 24 04          	mov    %edx,0x4(%esp)
  800509:	89 f2                	mov    %esi,%edx
  80050b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80050e:	e8 6d ff ff ff       	call   800480 <_ZL8printnumPFviPvES_yjii>
  800513:	eb 11                	jmp    800526 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800515:	89 74 24 04          	mov    %esi,0x4(%esp)
  800519:	89 3c 24             	mov    %edi,(%esp)
  80051c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051f:	83 eb 01             	sub    $0x1,%ebx
  800522:	85 db                	test   %ebx,%ebx
  800524:	7f ef                	jg     800515 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800526:	89 74 24 04          	mov    %esi,0x4(%esp)
  80052a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80052e:	8b 45 10             	mov    0x10(%ebp),%eax
  800531:	89 44 24 08          	mov    %eax,0x8(%esp)
  800535:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80053c:	00 
  80053d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800540:	89 14 24             	mov    %edx,(%esp)
  800543:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800546:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80054a:	e8 01 3f 00 00       	call   804450 <__umoddi3>
  80054f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800553:	0f be 80 7b 46 80 00 	movsbl 0x80467b(%eax),%eax
  80055a:	89 04 24             	mov    %eax,(%esp)
  80055d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800560:	83 c4 4c             	add    $0x4c,%esp
  800563:	5b                   	pop    %ebx
  800564:	5e                   	pop    %esi
  800565:	5f                   	pop    %edi
  800566:	5d                   	pop    %ebp
  800567:	c3                   	ret    

00800568 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800568:	55                   	push   %ebp
  800569:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80056b:	83 fa 01             	cmp    $0x1,%edx
  80056e:	7e 0e                	jle    80057e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800570:	8b 10                	mov    (%eax),%edx
  800572:	8d 4a 08             	lea    0x8(%edx),%ecx
  800575:	89 08                	mov    %ecx,(%eax)
  800577:	8b 02                	mov    (%edx),%eax
  800579:	8b 52 04             	mov    0x4(%edx),%edx
  80057c:	eb 22                	jmp    8005a0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80057e:	85 d2                	test   %edx,%edx
  800580:	74 10                	je     800592 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800582:	8b 10                	mov    (%eax),%edx
  800584:	8d 4a 04             	lea    0x4(%edx),%ecx
  800587:	89 08                	mov    %ecx,(%eax)
  800589:	8b 02                	mov    (%edx),%eax
  80058b:	ba 00 00 00 00       	mov    $0x0,%edx
  800590:	eb 0e                	jmp    8005a0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800592:	8b 10                	mov    (%eax),%edx
  800594:	8d 4a 04             	lea    0x4(%edx),%ecx
  800597:	89 08                	mov    %ecx,(%eax)
  800599:	8b 02                	mov    (%edx),%eax
  80059b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005a0:	5d                   	pop    %ebp
  8005a1:	c3                   	ret    

008005a2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8005a8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005ac:	8b 10                	mov    (%eax),%edx
  8005ae:	3b 50 04             	cmp    0x4(%eax),%edx
  8005b1:	73 0a                	jae    8005bd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8005b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005b6:	88 0a                	mov    %cl,(%edx)
  8005b8:	83 c2 01             	add    $0x1,%edx
  8005bb:	89 10                	mov    %edx,(%eax)
}
  8005bd:	5d                   	pop    %ebp
  8005be:	c3                   	ret    

008005bf <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005bf:	55                   	push   %ebp
  8005c0:	89 e5                	mov    %esp,%ebp
  8005c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005c5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	89 04 24             	mov    %eax,(%esp)
  8005e0:	e8 02 00 00 00       	call   8005e7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8005e5:	c9                   	leave  
  8005e6:	c3                   	ret    

008005e7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	57                   	push   %edi
  8005eb:	56                   	push   %esi
  8005ec:	53                   	push   %ebx
  8005ed:	83 ec 3c             	sub    $0x3c,%esp
  8005f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005f3:	8b 55 10             	mov    0x10(%ebp),%edx
  8005f6:	0f b6 02             	movzbl (%edx),%eax
  8005f9:	89 d3                	mov    %edx,%ebx
  8005fb:	83 c3 01             	add    $0x1,%ebx
  8005fe:	83 f8 25             	cmp    $0x25,%eax
  800601:	74 2b                	je     80062e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800603:	85 c0                	test   %eax,%eax
  800605:	75 10                	jne    800617 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800607:	e9 a5 03 00 00       	jmp    8009b1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80060c:	85 c0                	test   %eax,%eax
  80060e:	66 90                	xchg   %ax,%ax
  800610:	75 08                	jne    80061a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800612:	e9 9a 03 00 00       	jmp    8009b1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800617:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80061a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80061e:	89 04 24             	mov    %eax,(%esp)
  800621:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800623:	0f b6 03             	movzbl (%ebx),%eax
  800626:	83 c3 01             	add    $0x1,%ebx
  800629:	83 f8 25             	cmp    $0x25,%eax
  80062c:	75 de                	jne    80060c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80062e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800632:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800639:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80063e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800645:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80064d:	eb 2b                	jmp    80067a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80064f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800652:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800656:	eb 22                	jmp    80067a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800658:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80065b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80065f:	eb 19                	jmp    80067a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800661:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800664:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80066b:	eb 0d                	jmp    80067a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80066d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800670:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800673:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	0f b6 03             	movzbl (%ebx),%eax
  80067d:	0f b6 d0             	movzbl %al,%edx
  800680:	8d 73 01             	lea    0x1(%ebx),%esi
  800683:	89 75 10             	mov    %esi,0x10(%ebp)
  800686:	83 e8 23             	sub    $0x23,%eax
  800689:	3c 55                	cmp    $0x55,%al
  80068b:	0f 87 d8 02 00 00    	ja     800969 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800691:	0f b6 c0             	movzbl %al,%eax
  800694:	ff 24 85 20 48 80 00 	jmp    *0x804820(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80069b:	83 ea 30             	sub    $0x30,%edx
  80069e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8006a1:	8b 55 10             	mov    0x10(%ebp),%edx
  8006a4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8006a7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8006ad:	83 fa 09             	cmp    $0x9,%edx
  8006b0:	77 4e                	ja     800700 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8006b8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8006bb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8006bf:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  8006c2:	8d 50 d0             	lea    -0x30(%eax),%edx
  8006c5:	83 fa 09             	cmp    $0x9,%edx
  8006c8:	76 eb                	jbe    8006b5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  8006ca:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006cd:	eb 31                	jmp    800700 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8d 50 04             	lea    0x4(%eax),%edx
  8006d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006e0:	eb 1e                	jmp    800700 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8006e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e6:	0f 88 75 ff ff ff    	js     800661 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006ef:	eb 89                	jmp    80067a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8006f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006fb:	e9 7a ff ff ff       	jmp    80067a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800700:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800704:	0f 89 70 ff ff ff    	jns    80067a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80070a:	e9 5e ff ff ff       	jmp    80066d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80070f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800712:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800715:	e9 60 ff ff ff       	jmp    80067a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8d 50 04             	lea    0x4(%eax),%edx
  800720:	89 55 14             	mov    %edx,0x14(%ebp)
  800723:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800727:	8b 00                	mov    (%eax),%eax
  800729:	89 04 24             	mov    %eax,(%esp)
  80072c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80072f:	e9 bf fe ff ff       	jmp    8005f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8d 50 04             	lea    0x4(%eax),%edx
  80073a:	89 55 14             	mov    %edx,0x14(%ebp)
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	89 c2                	mov    %eax,%edx
  800741:	c1 fa 1f             	sar    $0x1f,%edx
  800744:	31 d0                	xor    %edx,%eax
  800746:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800748:	83 f8 14             	cmp    $0x14,%eax
  80074b:	7f 0f                	jg     80075c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80074d:	8b 14 85 80 49 80 00 	mov    0x804980(,%eax,4),%edx
  800754:	85 d2                	test   %edx,%edx
  800756:	0f 85 35 02 00 00    	jne    800991 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80075c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800760:	c7 44 24 08 93 46 80 	movl   $0x804693,0x8(%esp)
  800767:	00 
  800768:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076c:	8b 75 08             	mov    0x8(%ebp),%esi
  80076f:	89 34 24             	mov    %esi,(%esp)
  800772:	e8 48 fe ff ff       	call   8005bf <_Z8printfmtPFviPvES_PKcz>
  800777:	e9 77 fe ff ff       	jmp    8005f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80077c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80077f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800782:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	89 55 14             	mov    %edx,0x14(%ebp)
  80078e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800790:	85 db                	test   %ebx,%ebx
  800792:	ba 8c 46 80 00       	mov    $0x80468c,%edx
  800797:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  80079a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80079e:	7e 72                	jle    800812 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8007a0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8007a4:	74 6c                	je     800812 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007aa:	89 1c 24             	mov    %ebx,(%esp)
  8007ad:	e8 a9 02 00 00       	call   800a5b <_Z7strnlenPKcj>
  8007b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b5:	29 c2                	sub    %eax,%edx
  8007b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007ba:	85 d2                	test   %edx,%edx
  8007bc:	7e 54                	jle    800812 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  8007be:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  8007c2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8007c5:	89 d3                	mov    %edx,%ebx
  8007c7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8007ca:	89 c6                	mov    %eax,%esi
  8007cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d0:	89 34 24             	mov    %esi,(%esp)
  8007d3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d6:	83 eb 01             	sub    $0x1,%ebx
  8007d9:	85 db                	test   %ebx,%ebx
  8007db:	7f ef                	jg     8007cc <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  8007dd:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8007e0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8007e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007ea:	eb 26                	jmp    800812 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007ec:	8d 50 e0             	lea    -0x20(%eax),%edx
  8007ef:	83 fa 5e             	cmp    $0x5e,%edx
  8007f2:	76 10                	jbe    800804 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  8007f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007ff:	ff 55 08             	call   *0x8(%ebp)
  800802:	eb 0a                	jmp    80080e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800804:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800808:	89 04 24             	mov    %eax,(%esp)
  80080b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80080e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800812:	0f be 03             	movsbl (%ebx),%eax
  800815:	83 c3 01             	add    $0x1,%ebx
  800818:	85 c0                	test   %eax,%eax
  80081a:	74 11                	je     80082d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80081c:	85 f6                	test   %esi,%esi
  80081e:	78 05                	js     800825 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800820:	83 ee 01             	sub    $0x1,%esi
  800823:	78 0d                	js     800832 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800825:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800829:	75 c1                	jne    8007ec <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80082b:	eb d7                	jmp    800804 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80082d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800830:	eb 03                	jmp    800835 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800835:	85 c0                	test   %eax,%eax
  800837:	0f 8e b6 fd ff ff    	jle    8005f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80083d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800840:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800843:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800847:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80084e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800850:	83 eb 01             	sub    $0x1,%ebx
  800853:	85 db                	test   %ebx,%ebx
  800855:	7f ec                	jg     800843 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800857:	e9 97 fd ff ff       	jmp    8005f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80085c:	83 f9 01             	cmp    $0x1,%ecx
  80085f:	90                   	nop
  800860:	7e 10                	jle    800872 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	8d 50 08             	lea    0x8(%eax),%edx
  800868:	89 55 14             	mov    %edx,0x14(%ebp)
  80086b:	8b 18                	mov    (%eax),%ebx
  80086d:	8b 70 04             	mov    0x4(%eax),%esi
  800870:	eb 26                	jmp    800898 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800872:	85 c9                	test   %ecx,%ecx
  800874:	74 12                	je     800888 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8d 50 04             	lea    0x4(%eax),%edx
  80087c:	89 55 14             	mov    %edx,0x14(%ebp)
  80087f:	8b 18                	mov    (%eax),%ebx
  800881:	89 de                	mov    %ebx,%esi
  800883:	c1 fe 1f             	sar    $0x1f,%esi
  800886:	eb 10                	jmp    800898 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	8d 50 04             	lea    0x4(%eax),%edx
  80088e:	89 55 14             	mov    %edx,0x14(%ebp)
  800891:	8b 18                	mov    (%eax),%ebx
  800893:	89 de                	mov    %ebx,%esi
  800895:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800898:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80089d:	85 f6                	test   %esi,%esi
  80089f:	0f 89 8c 00 00 00    	jns    800931 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8008a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008a9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008b0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008b3:	f7 db                	neg    %ebx
  8008b5:	83 d6 00             	adc    $0x0,%esi
  8008b8:	f7 de                	neg    %esi
			}
			base = 10;
  8008ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bf:	eb 70                	jmp    800931 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008c1:	89 ca                	mov    %ecx,%edx
  8008c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c6:	e8 9d fc ff ff       	call   800568 <_ZL7getuintPPci>
  8008cb:	89 c3                	mov    %eax,%ebx
  8008cd:	89 d6                	mov    %edx,%esi
			base = 10;
  8008cf:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  8008d4:	eb 5b                	jmp    800931 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8008d6:	89 ca                	mov    %ecx,%edx
  8008d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008db:	e8 88 fc ff ff       	call   800568 <_ZL7getuintPPci>
  8008e0:	89 c3                	mov    %eax,%ebx
  8008e2:	89 d6                	mov    %edx,%esi
			base = 8;
  8008e4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  8008e9:	eb 46                	jmp    800931 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  8008eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ef:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008f6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8008f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008fd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800904:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	8d 50 04             	lea    0x4(%eax),%edx
  80090d:	89 55 14             	mov    %edx,0x14(%ebp)
  800910:	8b 18                	mov    (%eax),%ebx
  800912:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800917:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80091c:	eb 13                	jmp    800931 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80091e:	89 ca                	mov    %ecx,%edx
  800920:	8d 45 14             	lea    0x14(%ebp),%eax
  800923:	e8 40 fc ff ff       	call   800568 <_ZL7getuintPPci>
  800928:	89 c3                	mov    %eax,%ebx
  80092a:	89 d6                	mov    %edx,%esi
			base = 16;
  80092c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800931:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800935:	89 54 24 10          	mov    %edx,0x10(%esp)
  800939:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80093c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800940:	89 44 24 08          	mov    %eax,0x8(%esp)
  800944:	89 1c 24             	mov    %ebx,(%esp)
  800947:	89 74 24 04          	mov    %esi,0x4(%esp)
  80094b:	89 fa                	mov    %edi,%edx
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	e8 2b fb ff ff       	call   800480 <_ZL8printnumPFviPvES_yjii>
			break;
  800955:	e9 99 fc ff ff       	jmp    8005f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80095a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095e:	89 14 24             	mov    %edx,(%esp)
  800961:	ff 55 08             	call   *0x8(%ebp)
			break;
  800964:	e9 8a fc ff ff       	jmp    8005f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800969:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80096d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800974:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800977:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80097a:	89 d8                	mov    %ebx,%eax
  80097c:	eb 02                	jmp    800980 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  80097e:	89 d0                	mov    %edx,%eax
  800980:	8d 50 ff             	lea    -0x1(%eax),%edx
  800983:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800987:	75 f5                	jne    80097e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800989:	89 45 10             	mov    %eax,0x10(%ebp)
  80098c:	e9 62 fc ff ff       	jmp    8005f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800995:	c7 44 24 08 a6 4a 80 	movl   $0x804aa6,0x8(%esp)
  80099c:	00 
  80099d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a4:	89 34 24             	mov    %esi,(%esp)
  8009a7:	e8 13 fc ff ff       	call   8005bf <_Z8printfmtPFviPvES_PKcz>
  8009ac:	e9 42 fc ff ff       	jmp    8005f3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009b1:	83 c4 3c             	add    $0x3c,%esp
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5f                   	pop    %edi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 28             	sub    $0x28,%esp
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8009cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009cf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009d3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  8009d6:	85 c0                	test   %eax,%eax
  8009d8:	74 30                	je     800a0a <_Z9vsnprintfPciPKcS_+0x51>
  8009da:	85 d2                	test   %edx,%edx
  8009dc:	7e 2c                	jle    800a0a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f3:	c7 04 24 a2 05 80 00 	movl   $0x8005a2,(%esp)
  8009fa:	e8 e8 fb ff ff       	call   8005e7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  8009ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a02:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a08:	eb 05                	jmp    800a0f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    

00800a11 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a17:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	89 04 24             	mov    %eax,(%esp)
  800a32:	e8 82 ff ff ff       	call   8009b9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    
  800a39:	00 00                	add    %al,(%eax)
  800a3b:	00 00                	add    %al,(%eax)
  800a3d:	00 00                	add    %al,(%eax)
	...

00800a40 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a46:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4b:	80 3a 00             	cmpb   $0x0,(%edx)
  800a4e:	74 09                	je     800a59 <_Z6strlenPKc+0x19>
		n++;
  800a50:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a57:	75 f7                	jne    800a50 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a61:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
  800a69:	39 c2                	cmp    %eax,%edx
  800a6b:	74 0b                	je     800a78 <_Z7strnlenPKcj+0x1d>
  800a6d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a71:	74 05                	je     800a78 <_Z7strnlenPKcj+0x1d>
		n++;
  800a73:	83 c0 01             	add    $0x1,%eax
  800a76:	eb f1                	jmp    800a69 <_Z7strnlenPKcj+0xe>
	return n;
}
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	53                   	push   %ebx
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800a84:	ba 00 00 00 00       	mov    $0x0,%edx
  800a89:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a8d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a90:	83 c2 01             	add    $0x1,%edx
  800a93:	84 c9                	test   %cl,%cl
  800a95:	75 f2                	jne    800a89 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800a97:	5b                   	pop    %ebx
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	56                   	push   %esi
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800aa8:	85 f6                	test   %esi,%esi
  800aaa:	74 18                	je     800ac4 <_Z7strncpyPcPKcj+0x2a>
  800aac:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800ab1:	0f b6 1a             	movzbl (%edx),%ebx
  800ab4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ab7:	80 3a 01             	cmpb   $0x1,(%edx)
  800aba:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800abd:	83 c1 01             	add    $0x1,%ecx
  800ac0:	39 ce                	cmp    %ecx,%esi
  800ac2:	77 ed                	ja     800ab1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	56                   	push   %esi
  800acc:	53                   	push   %ebx
  800acd:	8b 75 08             	mov    0x8(%ebp),%esi
  800ad0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800ad6:	89 f0                	mov    %esi,%eax
  800ad8:	85 d2                	test   %edx,%edx
  800ada:	74 17                	je     800af3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800adc:	83 ea 01             	sub    $0x1,%edx
  800adf:	74 18                	je     800af9 <_Z7strlcpyPcPKcj+0x31>
  800ae1:	80 39 00             	cmpb   $0x0,(%ecx)
  800ae4:	74 17                	je     800afd <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800ae6:	0f b6 19             	movzbl (%ecx),%ebx
  800ae9:	88 18                	mov    %bl,(%eax)
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	83 c1 01             	add    $0x1,%ecx
  800af1:	eb e9                	jmp    800adc <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800af3:	29 f0                	sub    %esi,%eax
}
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800af9:	89 c2                	mov    %eax,%edx
  800afb:	eb 02                	jmp    800aff <_Z7strlcpyPcPKcj+0x37>
  800afd:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800aff:	c6 02 00             	movb   $0x0,(%edx)
  800b02:	eb ef                	jmp    800af3 <_Z7strlcpyPcPKcj+0x2b>

00800b04 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b0d:	0f b6 01             	movzbl (%ecx),%eax
  800b10:	84 c0                	test   %al,%al
  800b12:	74 0c                	je     800b20 <_Z6strcmpPKcS0_+0x1c>
  800b14:	3a 02                	cmp    (%edx),%al
  800b16:	75 08                	jne    800b20 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800b18:	83 c1 01             	add    $0x1,%ecx
  800b1b:	83 c2 01             	add    $0x1,%edx
  800b1e:	eb ed                	jmp    800b0d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800b20:	0f b6 c0             	movzbl %al,%eax
  800b23:	0f b6 12             	movzbl (%edx),%edx
  800b26:	29 d0                	sub    %edx,%eax
}
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	53                   	push   %ebx
  800b2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b34:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800b37:	85 d2                	test   %edx,%edx
  800b39:	74 16                	je     800b51 <_Z7strncmpPKcS0_j+0x27>
  800b3b:	0f b6 01             	movzbl (%ecx),%eax
  800b3e:	84 c0                	test   %al,%al
  800b40:	74 17                	je     800b59 <_Z7strncmpPKcS0_j+0x2f>
  800b42:	3a 03                	cmp    (%ebx),%al
  800b44:	75 13                	jne    800b59 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800b46:	83 ea 01             	sub    $0x1,%edx
  800b49:	83 c1 01             	add    $0x1,%ecx
  800b4c:	83 c3 01             	add    $0x1,%ebx
  800b4f:	eb e6                	jmp    800b37 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800b56:	5b                   	pop    %ebx
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800b59:	0f b6 01             	movzbl (%ecx),%eax
  800b5c:	0f b6 13             	movzbl (%ebx),%edx
  800b5f:	29 d0                	sub    %edx,%eax
  800b61:	eb f3                	jmp    800b56 <_Z7strncmpPKcS0_j+0x2c>

00800b63 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6d:	0f b6 10             	movzbl (%eax),%edx
  800b70:	84 d2                	test   %dl,%dl
  800b72:	74 1f                	je     800b93 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800b74:	38 ca                	cmp    %cl,%dl
  800b76:	75 0a                	jne    800b82 <_Z6strchrPKcc+0x1f>
  800b78:	eb 1e                	jmp    800b98 <_Z6strchrPKcc+0x35>
  800b7a:	38 ca                	cmp    %cl,%dl
  800b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b80:	74 16                	je     800b98 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b82:	83 c0 01             	add    $0x1,%eax
  800b85:	0f b6 10             	movzbl (%eax),%edx
  800b88:	84 d2                	test   %dl,%dl
  800b8a:	75 ee                	jne    800b7a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b91:	eb 05                	jmp    800b98 <_Z6strchrPKcc+0x35>
  800b93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba4:	0f b6 10             	movzbl (%eax),%edx
  800ba7:	84 d2                	test   %dl,%dl
  800ba9:	74 14                	je     800bbf <_Z7strfindPKcc+0x25>
		if (*s == c)
  800bab:	38 ca                	cmp    %cl,%dl
  800bad:	75 06                	jne    800bb5 <_Z7strfindPKcc+0x1b>
  800baf:	eb 0e                	jmp    800bbf <_Z7strfindPKcc+0x25>
  800bb1:	38 ca                	cmp    %cl,%dl
  800bb3:	74 0a                	je     800bbf <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bb5:	83 c0 01             	add    $0x1,%eax
  800bb8:	0f b6 10             	movzbl (%eax),%edx
  800bbb:	84 d2                	test   %dl,%dl
  800bbd:	75 f2                	jne    800bb1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	89 1c 24             	mov    %ebx,(%esp)
  800bca:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800bd2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800bdb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800be1:	75 25                	jne    800c08 <memset+0x47>
  800be3:	f6 c1 03             	test   $0x3,%cl
  800be6:	75 20                	jne    800c08 <memset+0x47>
		c &= 0xFF;
  800be8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800beb:	89 d3                	mov    %edx,%ebx
  800bed:	c1 e3 08             	shl    $0x8,%ebx
  800bf0:	89 d6                	mov    %edx,%esi
  800bf2:	c1 e6 18             	shl    $0x18,%esi
  800bf5:	89 d0                	mov    %edx,%eax
  800bf7:	c1 e0 10             	shl    $0x10,%eax
  800bfa:	09 f0                	or     %esi,%eax
  800bfc:	09 d0                	or     %edx,%eax
  800bfe:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800c00:	c1 e9 02             	shr    $0x2,%ecx
  800c03:	fc                   	cld    
  800c04:	f3 ab                	rep stos %eax,%es:(%edi)
  800c06:	eb 03                	jmp    800c0b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800c08:	fc                   	cld    
  800c09:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800c0b:	89 f8                	mov    %edi,%eax
  800c0d:	8b 1c 24             	mov    (%esp),%ebx
  800c10:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c18:	89 ec                	mov    %ebp,%esp
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 08             	sub    $0x8,%esp
  800c22:	89 34 24             	mov    %esi,(%esp)
  800c25:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800c32:	39 c6                	cmp    %eax,%esi
  800c34:	73 36                	jae    800c6c <memmove+0x50>
  800c36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c39:	39 d0                	cmp    %edx,%eax
  800c3b:	73 2f                	jae    800c6c <memmove+0x50>
		s += n;
		d += n;
  800c3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800c40:	f6 c2 03             	test   $0x3,%dl
  800c43:	75 1b                	jne    800c60 <memmove+0x44>
  800c45:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c4b:	75 13                	jne    800c60 <memmove+0x44>
  800c4d:	f6 c1 03             	test   $0x3,%cl
  800c50:	75 0e                	jne    800c60 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c52:	83 ef 04             	sub    $0x4,%edi
  800c55:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c58:	c1 e9 02             	shr    $0x2,%ecx
  800c5b:	fd                   	std    
  800c5c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c5e:	eb 09                	jmp    800c69 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c60:	83 ef 01             	sub    $0x1,%edi
  800c63:	8d 72 ff             	lea    -0x1(%edx),%esi
  800c66:	fd                   	std    
  800c67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c69:	fc                   	cld    
  800c6a:	eb 20                	jmp    800c8c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800c6c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c72:	75 13                	jne    800c87 <memmove+0x6b>
  800c74:	a8 03                	test   $0x3,%al
  800c76:	75 0f                	jne    800c87 <memmove+0x6b>
  800c78:	f6 c1 03             	test   $0x3,%cl
  800c7b:	75 0a                	jne    800c87 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c7d:	c1 e9 02             	shr    $0x2,%ecx
  800c80:	89 c7                	mov    %eax,%edi
  800c82:	fc                   	cld    
  800c83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c85:	eb 05                	jmp    800c8c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800c87:	89 c7                	mov    %eax,%edi
  800c89:	fc                   	cld    
  800c8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800c8c:	8b 34 24             	mov    (%esp),%esi
  800c8f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c93:	89 ec                	mov    %ebp,%esp
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 08             	sub    $0x8,%esp
  800c9d:	89 34 24             	mov    %esi,(%esp)
  800ca0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800caa:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800cad:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cb3:	75 13                	jne    800cc8 <memcpy+0x31>
  800cb5:	a8 03                	test   $0x3,%al
  800cb7:	75 0f                	jne    800cc8 <memcpy+0x31>
  800cb9:	f6 c1 03             	test   $0x3,%cl
  800cbc:	75 0a                	jne    800cc8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cbe:	c1 e9 02             	shr    $0x2,%ecx
  800cc1:	89 c7                	mov    %eax,%edi
  800cc3:	fc                   	cld    
  800cc4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc6:	eb 05                	jmp    800ccd <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800cc8:	89 c7                	mov    %eax,%edi
  800cca:	fc                   	cld    
  800ccb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800ccd:	8b 34 24             	mov    (%esp),%esi
  800cd0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800cd4:	89 ec                	mov    %ebp,%esp
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
  800cde:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ce1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800ce7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800cec:	85 ff                	test   %edi,%edi
  800cee:	74 38                	je     800d28 <memcmp+0x50>
		if (*s1 != *s2)
  800cf0:	0f b6 03             	movzbl (%ebx),%eax
  800cf3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800cf6:	83 ef 01             	sub    $0x1,%edi
  800cf9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800cfe:	38 c8                	cmp    %cl,%al
  800d00:	74 1d                	je     800d1f <memcmp+0x47>
  800d02:	eb 11                	jmp    800d15 <memcmp+0x3d>
  800d04:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800d09:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800d0e:	83 c2 01             	add    $0x1,%edx
  800d11:	38 c8                	cmp    %cl,%al
  800d13:	74 0a                	je     800d1f <memcmp+0x47>
			return *s1 - *s2;
  800d15:	0f b6 c0             	movzbl %al,%eax
  800d18:	0f b6 c9             	movzbl %cl,%ecx
  800d1b:	29 c8                	sub    %ecx,%eax
  800d1d:	eb 09                	jmp    800d28 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d1f:	39 fa                	cmp    %edi,%edx
  800d21:	75 e1                	jne    800d04 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800d23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	53                   	push   %ebx
  800d31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800d34:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800d36:	89 da                	mov    %ebx,%edx
  800d38:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800d3b:	39 d3                	cmp    %edx,%ebx
  800d3d:	73 15                	jae    800d54 <memfind+0x27>
		if (*s == (unsigned char) c)
  800d3f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800d43:	38 0b                	cmp    %cl,(%ebx)
  800d45:	75 06                	jne    800d4d <memfind+0x20>
  800d47:	eb 0b                	jmp    800d54 <memfind+0x27>
  800d49:	38 08                	cmp    %cl,(%eax)
  800d4b:	74 07                	je     800d54 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800d4d:	83 c0 01             	add    $0x1,%eax
  800d50:	39 c2                	cmp    %eax,%edx
  800d52:	77 f5                	ja     800d49 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d54:	5b                   	pop    %ebx
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d63:	0f b6 02             	movzbl (%edx),%eax
  800d66:	3c 20                	cmp    $0x20,%al
  800d68:	74 04                	je     800d6e <_Z6strtolPKcPPci+0x17>
  800d6a:	3c 09                	cmp    $0x9,%al
  800d6c:	75 0e                	jne    800d7c <_Z6strtolPKcPPci+0x25>
		s++;
  800d6e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d71:	0f b6 02             	movzbl (%edx),%eax
  800d74:	3c 20                	cmp    $0x20,%al
  800d76:	74 f6                	je     800d6e <_Z6strtolPKcPPci+0x17>
  800d78:	3c 09                	cmp    $0x9,%al
  800d7a:	74 f2                	je     800d6e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d7c:	3c 2b                	cmp    $0x2b,%al
  800d7e:	75 0a                	jne    800d8a <_Z6strtolPKcPPci+0x33>
		s++;
  800d80:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d83:	bf 00 00 00 00       	mov    $0x0,%edi
  800d88:	eb 10                	jmp    800d9a <_Z6strtolPKcPPci+0x43>
  800d8a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d8f:	3c 2d                	cmp    $0x2d,%al
  800d91:	75 07                	jne    800d9a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800d93:	83 c2 01             	add    $0x1,%edx
  800d96:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9a:	85 db                	test   %ebx,%ebx
  800d9c:	0f 94 c0             	sete   %al
  800d9f:	74 05                	je     800da6 <_Z6strtolPKcPPci+0x4f>
  800da1:	83 fb 10             	cmp    $0x10,%ebx
  800da4:	75 15                	jne    800dbb <_Z6strtolPKcPPci+0x64>
  800da6:	80 3a 30             	cmpb   $0x30,(%edx)
  800da9:	75 10                	jne    800dbb <_Z6strtolPKcPPci+0x64>
  800dab:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800daf:	75 0a                	jne    800dbb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800db1:	83 c2 02             	add    $0x2,%edx
  800db4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800db9:	eb 13                	jmp    800dce <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800dbb:	84 c0                	test   %al,%al
  800dbd:	74 0f                	je     800dce <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dbf:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dc4:	80 3a 30             	cmpb   $0x30,(%edx)
  800dc7:	75 05                	jne    800dce <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800dc9:	83 c2 01             	add    $0x1,%edx
  800dcc:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800dce:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd5:	0f b6 0a             	movzbl (%edx),%ecx
  800dd8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ddb:	80 fb 09             	cmp    $0x9,%bl
  800dde:	77 08                	ja     800de8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800de0:	0f be c9             	movsbl %cl,%ecx
  800de3:	83 e9 30             	sub    $0x30,%ecx
  800de6:	eb 1e                	jmp    800e06 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800de8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800deb:	80 fb 19             	cmp    $0x19,%bl
  800dee:	77 08                	ja     800df8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800df0:	0f be c9             	movsbl %cl,%ecx
  800df3:	83 e9 57             	sub    $0x57,%ecx
  800df6:	eb 0e                	jmp    800e06 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800df8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800dfb:	80 fb 19             	cmp    $0x19,%bl
  800dfe:	77 15                	ja     800e15 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800e00:	0f be c9             	movsbl %cl,%ecx
  800e03:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e06:	39 f1                	cmp    %esi,%ecx
  800e08:	7d 0f                	jge    800e19 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800e0a:	83 c2 01             	add    $0x1,%edx
  800e0d:	0f af c6             	imul   %esi,%eax
  800e10:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800e13:	eb c0                	jmp    800dd5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800e15:	89 c1                	mov    %eax,%ecx
  800e17:	eb 02                	jmp    800e1b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e19:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1f:	74 05                	je     800e26 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800e21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e24:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e26:	89 ca                	mov    %ecx,%edx
  800e28:	f7 da                	neg    %edx
  800e2a:	85 ff                	test   %edi,%edi
  800e2c:	0f 45 c2             	cmovne %edx,%eax
}
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    

00800e34 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 0c             	sub    $0xc,%esp
  800e3a:	89 1c 24             	mov    %ebx,(%esp)
  800e3d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e41:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e45:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e50:	89 c3                	mov    %eax,%ebx
  800e52:	89 c7                	mov    %eax,%edi
  800e54:	89 c6                	mov    %eax,%esi
  800e56:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e58:	8b 1c 24             	mov    (%esp),%ebx
  800e5b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e5f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e63:	89 ec                	mov    %ebp,%esp
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 0c             	sub    $0xc,%esp
  800e6d:	89 1c 24             	mov    %ebx,(%esp)
  800e70:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e74:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e78:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  800e82:	89 d1                	mov    %edx,%ecx
  800e84:	89 d3                	mov    %edx,%ebx
  800e86:	89 d7                	mov    %edx,%edi
  800e88:	89 d6                	mov    %edx,%esi
  800e8a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e8c:	8b 1c 24             	mov    (%esp),%ebx
  800e8f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e93:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e97:	89 ec                	mov    %ebp,%esp
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
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
  800eaa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaf:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	89 cb                	mov    %ecx,%ebx
  800eb9:	89 cf                	mov    %ecx,%edi
  800ebb:	89 ce                	mov    %ecx,%esi
  800ebd:	cd 30                	int    $0x30

	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7e 28                	jle    800eeb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ece:	00 
  800ecf:	c7 44 24 08 d4 49 80 	movl   $0x8049d4,0x8(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ede:	00 
  800edf:	c7 04 24 f1 49 80 00 	movl   $0x8049f1,(%esp)
  800ee6:	e8 5d f4 ff ff       	call   800348 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800eeb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef4:	89 ec                	mov    %ebp,%esp
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	89 1c 24             	mov    %ebx,(%esp)
  800f01:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f05:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f09:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0e:	b8 02 00 00 00       	mov    $0x2,%eax
  800f13:	89 d1                	mov    %edx,%ecx
  800f15:	89 d3                	mov    %edx,%ebx
  800f17:	89 d7                	mov    %edx,%edi
  800f19:	89 d6                	mov    %edx,%esi
  800f1b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f1d:	8b 1c 24             	mov    (%esp),%ebx
  800f20:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f28:	89 ec                	mov    %ebp,%esp
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 0c             	sub    $0xc,%esp
  800f32:	89 1c 24             	mov    %ebx,(%esp)
  800f35:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f39:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f42:	b8 04 00 00 00       	mov    $0x4,%eax
  800f47:	89 d1                	mov    %edx,%ecx
  800f49:	89 d3                	mov    %edx,%ebx
  800f4b:	89 d7                	mov    %edx,%edi
  800f4d:	89 d6                	mov    %edx,%esi
  800f4f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f51:	8b 1c 24             	mov    (%esp),%ebx
  800f54:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f5c:	89 ec                	mov    %ebp,%esp
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	83 ec 38             	sub    $0x38,%esp
  800f66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f6f:	be 00 00 00 00       	mov    $0x0,%esi
  800f74:	b8 08 00 00 00       	mov    $0x8,%eax
  800f79:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	89 f7                	mov    %esi,%edi
  800f84:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f86:	85 c0                	test   %eax,%eax
  800f88:	7e 28                	jle    800fb2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f95:	00 
  800f96:	c7 44 24 08 d4 49 80 	movl   $0x8049d4,0x8(%esp)
  800f9d:	00 
  800f9e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa5:	00 
  800fa6:	c7 04 24 f1 49 80 00 	movl   $0x8049f1,(%esp)
  800fad:	e8 96 f3 ff ff       	call   800348 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fb2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fbb:	89 ec                	mov    %ebp,%esp
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    

00800fbf <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 38             	sub    $0x38,%esp
  800fc5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fcb:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fce:	b8 09 00 00 00       	mov    $0x9,%eax
  800fd3:	8b 75 18             	mov    0x18(%ebp),%esi
  800fd6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	7e 28                	jle    801010 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fec:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 08 d4 49 80 	movl   $0x8049d4,0x8(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801003:	00 
  801004:	c7 04 24 f1 49 80 00 	movl   $0x8049f1,(%esp)
  80100b:	e8 38 f3 ff ff       	call   800348 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801010:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801013:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801016:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801019:	89 ec                	mov    %ebp,%esp
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 38             	sub    $0x38,%esp
  801023:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801026:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801029:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80102c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801031:	b8 0a 00 00 00       	mov    $0xa,%eax
  801036:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801039:	8b 55 08             	mov    0x8(%ebp),%edx
  80103c:	89 df                	mov    %ebx,%edi
  80103e:	89 de                	mov    %ebx,%esi
  801040:	cd 30                	int    $0x30

	if(check && ret > 0)
  801042:	85 c0                	test   %eax,%eax
  801044:	7e 28                	jle    80106e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801046:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801051:	00 
  801052:	c7 44 24 08 d4 49 80 	movl   $0x8049d4,0x8(%esp)
  801059:	00 
  80105a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801061:	00 
  801062:	c7 04 24 f1 49 80 00 	movl   $0x8049f1,(%esp)
  801069:	e8 da f2 ff ff       	call   800348 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80106e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801071:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801074:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801077:	89 ec                	mov    %ebp,%esp
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 38             	sub    $0x38,%esp
  801081:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801084:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801087:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80108a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108f:	b8 05 00 00 00       	mov    $0x5,%eax
  801094:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801097:	8b 55 08             	mov    0x8(%ebp),%edx
  80109a:	89 df                	mov    %ebx,%edi
  80109c:	89 de                	mov    %ebx,%esi
  80109e:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	7e 28                	jle    8010cc <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010af:	00 
  8010b0:	c7 44 24 08 d4 49 80 	movl   $0x8049d4,0x8(%esp)
  8010b7:	00 
  8010b8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010bf:	00 
  8010c0:	c7 04 24 f1 49 80 00 	movl   $0x8049f1,(%esp)
  8010c7:	e8 7c f2 ff ff       	call   800348 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010cf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d5:	89 ec                	mov    %ebp,%esp
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	83 ec 38             	sub    $0x38,%esp
  8010df:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010e5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ed:	b8 06 00 00 00       	mov    $0x6,%eax
  8010f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f8:	89 df                	mov    %ebx,%edi
  8010fa:	89 de                	mov    %ebx,%esi
  8010fc:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010fe:	85 c0                	test   %eax,%eax
  801100:	7e 28                	jle    80112a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801102:	89 44 24 10          	mov    %eax,0x10(%esp)
  801106:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80110d:	00 
  80110e:	c7 44 24 08 d4 49 80 	movl   $0x8049d4,0x8(%esp)
  801115:	00 
  801116:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80111d:	00 
  80111e:	c7 04 24 f1 49 80 00 	movl   $0x8049f1,(%esp)
  801125:	e8 1e f2 ff ff       	call   800348 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80112a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80112d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801130:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801133:	89 ec                	mov    %ebp,%esp
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 38             	sub    $0x38,%esp
  80113d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801140:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801143:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801146:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801150:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	89 df                	mov    %ebx,%edi
  801158:	89 de                	mov    %ebx,%esi
  80115a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	7e 28                	jle    801188 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801160:	89 44 24 10          	mov    %eax,0x10(%esp)
  801164:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80116b:	00 
  80116c:	c7 44 24 08 d4 49 80 	movl   $0x8049d4,0x8(%esp)
  801173:	00 
  801174:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80117b:	00 
  80117c:	c7 04 24 f1 49 80 00 	movl   $0x8049f1,(%esp)
  801183:	e8 c0 f1 ff ff       	call   800348 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801188:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80118b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80118e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801191:	89 ec                	mov    %ebp,%esp
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    

00801195 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 38             	sub    $0x38,%esp
  80119b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80119e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b4:	89 df                	mov    %ebx,%edi
  8011b6:	89 de                	mov    %ebx,%esi
  8011b8:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	7e 28                	jle    8011e6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  8011c9:	00 
  8011ca:	c7 44 24 08 d4 49 80 	movl   $0x8049d4,0x8(%esp)
  8011d1:	00 
  8011d2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d9:	00 
  8011da:	c7 04 24 f1 49 80 00 	movl   $0x8049f1,(%esp)
  8011e1:	e8 62 f1 ff ff       	call   800348 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011e6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011ef:	89 ec                	mov    %ebp,%esp
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	89 1c 24             	mov    %ebx,(%esp)
  8011fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801200:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801204:	be 00 00 00 00       	mov    $0x0,%esi
  801209:	b8 0d 00 00 00       	mov    $0xd,%eax
  80120e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801211:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801214:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801217:	8b 55 08             	mov    0x8(%ebp),%edx
  80121a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80121c:	8b 1c 24             	mov    (%esp),%ebx
  80121f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801223:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801227:	89 ec                	mov    %ebp,%esp
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    

0080122b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	83 ec 38             	sub    $0x38,%esp
  801231:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801234:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801237:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80123a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80123f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801244:	8b 55 08             	mov    0x8(%ebp),%edx
  801247:	89 cb                	mov    %ecx,%ebx
  801249:	89 cf                	mov    %ecx,%edi
  80124b:	89 ce                	mov    %ecx,%esi
  80124d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80124f:	85 c0                	test   %eax,%eax
  801251:	7e 28                	jle    80127b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801253:	89 44 24 10          	mov    %eax,0x10(%esp)
  801257:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80125e:	00 
  80125f:	c7 44 24 08 d4 49 80 	movl   $0x8049d4,0x8(%esp)
  801266:	00 
  801267:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80126e:	00 
  80126f:	c7 04 24 f1 49 80 00 	movl   $0x8049f1,(%esp)
  801276:	e8 cd f0 ff ff       	call   800348 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80127b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80127e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801281:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801284:	89 ec                	mov    %ebp,%esp
  801286:	5d                   	pop    %ebp
  801287:	c3                   	ret    

00801288 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	83 ec 0c             	sub    $0xc,%esp
  80128e:	89 1c 24             	mov    %ebx,(%esp)
  801291:	89 74 24 04          	mov    %esi,0x4(%esp)
  801295:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801299:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129e:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a9:	89 df                	mov    %ebx,%edi
  8012ab:	89 de                	mov    %ebx,%esi
  8012ad:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8012af:	8b 1c 24             	mov    (%esp),%ebx
  8012b2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012b6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012ba:	89 ec                	mov    %ebp,%esp
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    

008012be <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 0c             	sub    $0xc,%esp
  8012c4:	89 1c 24             	mov    %ebx,(%esp)
  8012c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012cb:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d4:	b8 11 00 00 00       	mov    $0x11,%eax
  8012d9:	89 d1                	mov    %edx,%ecx
  8012db:	89 d3                	mov    %edx,%ebx
  8012dd:	89 d7                	mov    %edx,%edi
  8012df:	89 d6                	mov    %edx,%esi
  8012e1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012e3:	8b 1c 24             	mov    (%esp),%ebx
  8012e6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012ea:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012ee:	89 ec                	mov    %ebp,%esp
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    

008012f2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 0c             	sub    $0xc,%esp
  8012f8:	89 1c 24             	mov    %ebx,(%esp)
  8012fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012ff:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801303:	bb 00 00 00 00       	mov    $0x0,%ebx
  801308:	b8 12 00 00 00       	mov    $0x12,%eax
  80130d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801310:	8b 55 08             	mov    0x8(%ebp),%edx
  801313:	89 df                	mov    %ebx,%edi
  801315:	89 de                	mov    %ebx,%esi
  801317:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801319:	8b 1c 24             	mov    (%esp),%ebx
  80131c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801320:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801324:	89 ec                	mov    %ebp,%esp
  801326:	5d                   	pop    %ebp
  801327:	c3                   	ret    

00801328 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	83 ec 0c             	sub    $0xc,%esp
  80132e:	89 1c 24             	mov    %ebx,(%esp)
  801331:	89 74 24 04          	mov    %esi,0x4(%esp)
  801335:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801339:	b9 00 00 00 00       	mov    $0x0,%ecx
  80133e:	b8 13 00 00 00       	mov    $0x13,%eax
  801343:	8b 55 08             	mov    0x8(%ebp),%edx
  801346:	89 cb                	mov    %ecx,%ebx
  801348:	89 cf                	mov    %ecx,%edi
  80134a:	89 ce                	mov    %ecx,%esi
  80134c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80134e:	8b 1c 24             	mov    (%esp),%ebx
  801351:	8b 74 24 04          	mov    0x4(%esp),%esi
  801355:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801359:	89 ec                	mov    %ebp,%esp
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    

0080135d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	89 1c 24             	mov    %ebx,(%esp)
  801366:	89 74 24 04          	mov    %esi,0x4(%esp)
  80136a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80136e:	b8 10 00 00 00       	mov    $0x10,%eax
  801373:	8b 75 18             	mov    0x18(%ebp),%esi
  801376:	8b 7d 14             	mov    0x14(%ebp),%edi
  801379:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80137c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80137f:	8b 55 08             	mov    0x8(%ebp),%edx
  801382:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801384:	8b 1c 24             	mov    (%esp),%ebx
  801387:	8b 74 24 04          	mov    0x4(%esp),%esi
  80138b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80138f:	89 ec                	mov    %ebp,%esp
  801391:	5d                   	pop    %ebp
  801392:	c3                   	ret    
	...

00801394 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 38             	sub    $0x38,%esp
  80139a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80139d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013a0:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  8013a3:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  8013aa:	f6 c7 04             	test   $0x4,%bh
  8013ad:	74 31                	je     8013e0 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  8013af:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  8013b6:	c1 e2 0c             	shl    $0xc,%edx
  8013b9:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8013bf:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8013c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d6:	e8 e4 fb ff ff       	call   800fbf <_Z12sys_page_mapiPviS_i>
        return r;
  8013db:	e9 8c 00 00 00       	jmp    80146c <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  8013e0:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  8013e7:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  8013ec:	f7 c6 00 08 00 00    	test   $0x800,%esi
  8013f2:	75 2a                	jne    80141e <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  8013f4:	84 c9                	test   %cl,%cl
  8013f6:	74 0f                	je     801407 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  8013f8:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  8013ff:	83 e3 02             	and    $0x2,%ebx
  801402:	80 cf 02             	or     $0x2,%bh
  801405:	eb 17                	jmp    80141e <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  801407:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  80140e:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  801411:	83 f9 01             	cmp    $0x1,%ecx
  801414:	19 db                	sbb    %ebx,%ebx
  801416:	f7 d3                	not    %ebx
  801418:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80141e:	89 df                	mov    %ebx,%edi
  801420:	83 cf 05             	or     $0x5,%edi
  801423:	89 d6                	mov    %edx,%esi
  801425:	c1 e6 0c             	shl    $0xc,%esi
  801428:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80142c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801430:	89 44 24 08          	mov    %eax,0x8(%esp)
  801434:	89 74 24 04          	mov    %esi,0x4(%esp)
  801438:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80143f:	e8 7b fb ff ff       	call   800fbf <_Z12sys_page_mapiPviS_i>
  801444:	85 c0                	test   %eax,%eax
  801446:	75 24                	jne    80146c <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  801448:	85 db                	test   %ebx,%ebx
  80144a:	74 20                	je     80146c <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80144c:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801450:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801454:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80145b:	00 
  80145c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801460:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801467:	e8 53 fb ff ff       	call   800fbf <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  80146c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80146f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801472:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801475:	89 ec                	mov    %ebp,%esp
  801477:	5d                   	pop    %ebp
  801478:	c3                   	ret    

00801479 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 28             	sub    $0x28,%esp
  80147f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801482:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801485:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  801488:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  80148a:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  80148e:	0f 84 ff 00 00 00    	je     801593 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  801494:	89 f0                	mov    %esi,%eax
  801496:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  801499:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8014a0:	f6 c4 08             	test   $0x8,%ah
  8014a3:	0f 84 ea 00 00 00    	je     801593 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8014a9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014b0:	00 
  8014b1:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014b8:	00 
  8014b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c0:	e8 9b fa ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	79 20                	jns    8014e9 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  8014c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014cd:	c7 44 24 08 ff 49 80 	movl   $0x8049ff,0x8(%esp)
  8014d4:	00 
  8014d5:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8014dc:	00 
  8014dd:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  8014e4:	e8 5f ee ff ff       	call   800348 <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  8014e9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  8014ef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014f6:	00 
  8014f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014fb:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801502:	e8 90 f7 ff ff       	call   800c97 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801507:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80150e:	00 
  80150f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801513:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80151a:	00 
  80151b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801522:	00 
  801523:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80152a:	e8 90 fa ff ff       	call   800fbf <_Z12sys_page_mapiPviS_i>
  80152f:	85 c0                	test   %eax,%eax
  801531:	79 20                	jns    801553 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  801533:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801537:	c7 44 24 08 1d 4a 80 	movl   $0x804a1d,0x8(%esp)
  80153e:	00 
  80153f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801546:	00 
  801547:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  80154e:	e8 f5 ed ff ff       	call   800348 <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801553:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80155a:	00 
  80155b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801562:	e8 b6 fa ff ff       	call   80101d <_Z14sys_page_unmapiPv>
  801567:	85 c0                	test   %eax,%eax
  801569:	79 20                	jns    80158b <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  80156b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80156f:	c7 44 24 08 2e 4a 80 	movl   $0x804a2e,0x8(%esp)
  801576:	00 
  801577:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80157e:	00 
  80157f:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  801586:	e8 bd ed ff ff       	call   800348 <_Z6_panicPKciS0_z>
    resume(utf);
  80158b:	89 1c 24             	mov    %ebx,(%esp)
  80158e:	e8 8d 2c 00 00       	call   804220 <resume>
}
  801593:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801596:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801599:	89 ec                	mov    %ebp,%esp
  80159b:	5d                   	pop    %ebp
  80159c:	c3                   	ret    

0080159d <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	57                   	push   %edi
  8015a1:	56                   	push   %esi
  8015a2:	53                   	push   %ebx
  8015a3:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  8015a6:	c7 04 24 79 14 80 00 	movl   $0x801479,(%esp)
  8015ad:	e8 99 2b 00 00       	call   80414b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  8015b2:	be 07 00 00 00       	mov    $0x7,%esi
  8015b7:	89 f0                	mov    %esi,%eax
  8015b9:	cd 30                	int    $0x30
  8015bb:	89 c6                	mov    %eax,%esi
  8015bd:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	79 20                	jns    8015e3 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  8015c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015c7:	c7 44 24 08 41 4a 80 	movl   $0x804a41,0x8(%esp)
  8015ce:	00 
  8015cf:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8015d6:	00 
  8015d7:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  8015de:	e8 65 ed ff ff       	call   800348 <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  8015e3:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	75 1c                	jne    801608 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  8015ec:	e8 07 f9 ff ff       	call   800ef8 <_Z12sys_getenvidv>
  8015f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015f6:	6b c0 78             	imul   $0x78,%eax,%eax
  8015f9:	05 00 00 00 ef       	add    $0xef000000,%eax
  8015fe:	a3 00 70 80 00       	mov    %eax,0x807000
        return 0;
  801603:	e9 de 00 00 00       	jmp    8016e6 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  801608:	89 d8                	mov    %ebx,%eax
  80160a:	c1 f8 0a             	sar    $0xa,%eax
  80160d:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801614:	a8 01                	test   $0x1,%al
  801616:	75 08                	jne    801620 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  801618:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  80161e:	eb 19                	jmp    801639 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  801620:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801627:	a8 01                	test   $0x1,%al
  801629:	74 0e                	je     801639 <_Z4forkv+0x9c>
            duppage(envid, pn);
  80162b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801630:	89 da                	mov    %ebx,%edx
  801632:	89 f8                	mov    %edi,%eax
  801634:	e8 5b fd ff ff       	call   801394 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801639:	83 eb 01             	sub    $0x1,%ebx
  80163c:	79 ca                	jns    801608 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  80163e:	a1 00 70 80 00       	mov    0x807000,%eax
  801643:	8b 40 5c             	mov    0x5c(%eax),%eax
  801646:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164a:	89 34 24             	mov    %esi,(%esp)
  80164d:	e8 43 fb ff ff       	call   801195 <_Z26sys_env_set_pgfault_upcalliPv>
  801652:	85 c0                	test   %eax,%eax
  801654:	74 20                	je     801676 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801656:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80165a:	c7 44 24 08 68 4a 80 	movl   $0x804a68,0x8(%esp)
  801661:	00 
  801662:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  801669:	00 
  80166a:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  801671:	e8 d2 ec ff ff       	call   800348 <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801676:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80167d:	00 
  80167e:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  801685:	ee 
  801686:	89 34 24             	mov    %esi,(%esp)
  801689:	e8 d2 f8 ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  80168e:	85 c0                	test   %eax,%eax
  801690:	79 20                	jns    8016b2 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  801692:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801696:	c7 44 24 08 ff 49 80 	movl   $0x8049ff,0x8(%esp)
  80169d:	00 
  80169e:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  8016a5:	00 
  8016a6:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  8016ad:	e8 96 ec ff ff       	call   800348 <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8016b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016b9:	00 
  8016ba:	89 34 24             	mov    %esi,(%esp)
  8016bd:	e8 b9 f9 ff ff       	call   80107b <_Z18sys_env_set_statusii>
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	79 20                	jns    8016e6 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  8016c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016ca:	c7 44 24 08 51 4a 80 	movl   $0x804a51,0x8(%esp)
  8016d1:	00 
  8016d2:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  8016d9:	00 
  8016da:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  8016e1:	e8 62 ec ff ff       	call   800348 <_Z6_panicPKciS0_z>

    return envid;
}
  8016e6:	89 f0                	mov    %esi,%eax
  8016e8:	83 c4 1c             	add    $0x1c,%esp
  8016eb:	5b                   	pop    %ebx
  8016ec:	5e                   	pop    %esi
  8016ed:	5f                   	pop    %edi
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	57                   	push   %edi
  8016f4:	56                   	push   %esi
  8016f5:	53                   	push   %ebx
  8016f6:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  8016f9:	c7 04 24 79 14 80 00 	movl   $0x801479,(%esp)
  801700:	e8 46 2a 00 00       	call   80414b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  801705:	be 07 00 00 00       	mov    $0x7,%esi
  80170a:	89 f0                	mov    %esi,%eax
  80170c:	cd 30                	int    $0x30
  80170e:	89 c6                	mov    %eax,%esi
  801710:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  801712:	85 c0                	test   %eax,%eax
  801714:	79 20                	jns    801736 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  801716:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80171a:	c7 44 24 08 41 4a 80 	movl   $0x804a41,0x8(%esp)
  801721:	00 
  801722:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  801729:	00 
  80172a:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  801731:	e8 12 ec ff ff       	call   800348 <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  801736:	85 c0                	test   %eax,%eax
  801738:	0f 84 40 01 00 00    	je     80187e <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  80173e:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  801740:	c1 eb 0c             	shr    $0xc,%ebx
  801743:	83 eb 01             	sub    $0x1,%ebx
  801746:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  801749:	eb 31                	jmp    80177c <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  80174b:	89 d8                	mov    %ebx,%eax
  80174d:	c1 f8 0a             	sar    $0xa,%eax
  801750:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801757:	a8 01                	test   $0x1,%al
  801759:	75 08                	jne    801763 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  80175b:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801761:	eb 19                	jmp    80177c <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  801763:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  80176a:	a8 01                	test   $0x1,%al
  80176c:	74 0e                	je     80177c <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  80176e:	b9 01 00 00 00       	mov    $0x1,%ecx
  801773:	89 da                	mov    %ebx,%edx
  801775:	89 f8                	mov    %edi,%eax
  801777:	e8 18 fc ff ff       	call   801394 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  80177c:	83 eb 01             	sub    $0x1,%ebx
  80177f:	79 ca                	jns    80174b <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  801781:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  801788:	7f 3f                	jg     8017c9 <_Z5sforkv+0xd9>
  80178a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  80178d:	89 d8                	mov    %ebx,%eax
  80178f:	c1 f8 0a             	sar    $0xa,%eax
  801792:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801799:	a8 01                	test   $0x1,%al
  80179b:	75 08                	jne    8017a5 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  80179d:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8017a3:	eb 19                	jmp    8017be <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  8017a5:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8017ac:	a8 01                	test   $0x1,%al
  8017ae:	74 0e                	je     8017be <_Z5sforkv+0xce>
            duppage(envid, i);
  8017b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b5:	89 da                	mov    %ebx,%edx
  8017b7:	89 f8                	mov    %edi,%eax
  8017b9:	e8 d6 fb ff ff       	call   801394 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  8017be:	83 c3 01             	add    $0x1,%ebx
  8017c1:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  8017c7:	7e c4                	jle    80178d <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  8017c9:	e8 2a f7 ff ff       	call   800ef8 <_Z12sys_getenvidv>
  8017ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017d3:	6b c0 78             	imul   $0x78,%eax,%eax
  8017d6:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  8017db:	8b 40 50             	mov    0x50(%eax),%eax
  8017de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e2:	89 34 24             	mov    %esi,(%esp)
  8017e5:	e8 ab f9 ff ff       	call   801195 <_Z26sys_env_set_pgfault_upcalliPv>
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	74 20                	je     80180e <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  8017ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017f2:	c7 44 24 08 68 4a 80 	movl   $0x804a68,0x8(%esp)
  8017f9:	00 
  8017fa:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801801:	00 
  801802:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  801809:	e8 3a eb ff ff       	call   800348 <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80180e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801815:	00 
  801816:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  80181d:	ee 
  80181e:	89 34 24             	mov    %esi,(%esp)
  801821:	e8 3a f7 ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  801826:	85 c0                	test   %eax,%eax
  801828:	79 20                	jns    80184a <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  80182a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80182e:	c7 44 24 08 ff 49 80 	movl   $0x8049ff,0x8(%esp)
  801835:	00 
  801836:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  80183d:	00 
  80183e:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  801845:	e8 fe ea ff ff       	call   800348 <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80184a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801851:	00 
  801852:	89 34 24             	mov    %esi,(%esp)
  801855:	e8 21 f8 ff ff       	call   80107b <_Z18sys_env_set_statusii>
  80185a:	85 c0                	test   %eax,%eax
  80185c:	79 20                	jns    80187e <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  80185e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801862:	c7 44 24 08 51 4a 80 	movl   $0x804a51,0x8(%esp)
  801869:	00 
  80186a:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  801871:	00 
  801872:	c7 04 24 12 4a 80 00 	movl   $0x804a12,(%esp)
  801879:	e8 ca ea ff ff       	call   800348 <_Z6_panicPKciS0_z>

    return envid;
    
}
  80187e:	89 f0                	mov    %esi,%eax
  801880:	83 c4 2c             	add    $0x2c,%esp
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5f                   	pop    %edi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    
	...

00801890 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801893:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801898:	75 11                	jne    8018ab <_ZL8fd_validPK2Fd+0x1b>
  80189a:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  80189f:	76 0a                	jbe    8018ab <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  8018a1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  8018a6:	0f 96 c0             	setbe  %al
  8018a9:	eb 05                	jmp    8018b0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    

008018b2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	53                   	push   %ebx
  8018b6:	83 ec 14             	sub    $0x14,%esp
  8018b9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8018bb:	e8 d0 ff ff ff       	call   801890 <_ZL8fd_validPK2Fd>
  8018c0:	84 c0                	test   %al,%al
  8018c2:	75 24                	jne    8018e8 <_ZL9fd_isopenPK2Fd+0x36>
  8018c4:	c7 44 24 0c 87 4a 80 	movl   $0x804a87,0xc(%esp)
  8018cb:	00 
  8018cc:	c7 44 24 08 94 4a 80 	movl   $0x804a94,0x8(%esp)
  8018d3:	00 
  8018d4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8018db:	00 
  8018dc:	c7 04 24 a9 4a 80 00 	movl   $0x804aa9,(%esp)
  8018e3:	e8 60 ea ff ff       	call   800348 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  8018e8:	89 d8                	mov    %ebx,%eax
  8018ea:	c1 e8 16             	shr    $0x16,%eax
  8018ed:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f9:	f6 c2 01             	test   $0x1,%dl
  8018fc:	74 0d                	je     80190b <_ZL9fd_isopenPK2Fd+0x59>
  8018fe:	c1 eb 0c             	shr    $0xc,%ebx
  801901:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801908:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80190b:	83 c4 14             	add    $0x14,%esp
  80190e:	5b                   	pop    %ebx
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    

00801911 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	89 1c 24             	mov    %ebx,(%esp)
  80191a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80191e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801921:	8b 75 0c             	mov    0xc(%ebp),%esi
  801924:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801928:	83 fb 1f             	cmp    $0x1f,%ebx
  80192b:	77 18                	ja     801945 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80192d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801933:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801936:	84 c0                	test   %al,%al
  801938:	74 21                	je     80195b <_Z9fd_lookupiPP2Fdb+0x4a>
  80193a:	89 d8                	mov    %ebx,%eax
  80193c:	e8 71 ff ff ff       	call   8018b2 <_ZL9fd_isopenPK2Fd>
  801941:	84 c0                	test   %al,%al
  801943:	75 16                	jne    80195b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801945:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80194b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801950:	8b 1c 24             	mov    (%esp),%ebx
  801953:	8b 74 24 04          	mov    0x4(%esp),%esi
  801957:	89 ec                	mov    %ebp,%esp
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80195b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80195d:	b8 00 00 00 00       	mov    $0x0,%eax
  801962:	eb ec                	jmp    801950 <_Z9fd_lookupiPP2Fdb+0x3f>

00801964 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	53                   	push   %ebx
  801968:	83 ec 14             	sub    $0x14,%esp
  80196b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80196e:	89 d8                	mov    %ebx,%eax
  801970:	e8 1b ff ff ff       	call   801890 <_ZL8fd_validPK2Fd>
  801975:	84 c0                	test   %al,%al
  801977:	75 24                	jne    80199d <_Z6fd2numP2Fd+0x39>
  801979:	c7 44 24 0c 87 4a 80 	movl   $0x804a87,0xc(%esp)
  801980:	00 
  801981:	c7 44 24 08 94 4a 80 	movl   $0x804a94,0x8(%esp)
  801988:	00 
  801989:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801990:	00 
  801991:	c7 04 24 a9 4a 80 00 	movl   $0x804aa9,(%esp)
  801998:	e8 ab e9 ff ff       	call   800348 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80199d:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  8019a3:	c1 e8 0c             	shr    $0xc,%eax
}
  8019a6:	83 c4 14             	add    $0x14,%esp
  8019a9:	5b                   	pop    %ebx
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    

008019ac <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	89 04 24             	mov    %eax,(%esp)
  8019b8:	e8 a7 ff ff ff       	call   801964 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8019bd:	05 20 00 0d 00       	add    $0xd0020,%eax
  8019c2:	c1 e0 0c             	shl    $0xc,%eax
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	57                   	push   %edi
  8019cb:	56                   	push   %esi
  8019cc:	53                   	push   %ebx
  8019cd:	83 ec 2c             	sub    $0x2c,%esp
  8019d0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8019d3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8019d8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8019db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019e2:	00 
  8019e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019e7:	89 1c 24             	mov    %ebx,(%esp)
  8019ea:	e8 22 ff ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  8019ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f2:	e8 bb fe ff ff       	call   8018b2 <_ZL9fd_isopenPK2Fd>
  8019f7:	84 c0                	test   %al,%al
  8019f9:	75 0c                	jne    801a07 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  8019fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019fe:	89 07                	mov    %eax,(%edi)
			return 0;
  801a00:	b8 00 00 00 00       	mov    $0x0,%eax
  801a05:	eb 13                	jmp    801a1a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801a07:	83 c3 01             	add    $0x1,%ebx
  801a0a:	83 fb 20             	cmp    $0x20,%ebx
  801a0d:	75 cc                	jne    8019db <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a0f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801a15:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801a1a:	83 c4 2c             	add    $0x2c,%esp
  801a1d:	5b                   	pop    %ebx
  801a1e:	5e                   	pop    %esi
  801a1f:	5f                   	pop    %edi
  801a20:	5d                   	pop    %ebp
  801a21:	c3                   	ret    

00801a22 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	53                   	push   %ebx
  801a26:	83 ec 14             	sub    $0x14,%esp
  801a29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  801a2f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a34:	39 0d 04 60 80 00    	cmp    %ecx,0x806004
  801a3a:	75 16                	jne    801a52 <_Z10dev_lookupiPP3Dev+0x30>
  801a3c:	eb 06                	jmp    801a44 <_Z10dev_lookupiPP3Dev+0x22>
  801a3e:	39 0a                	cmp    %ecx,(%edx)
  801a40:	75 10                	jne    801a52 <_Z10dev_lookupiPP3Dev+0x30>
  801a42:	eb 05                	jmp    801a49 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801a44:	ba 04 60 80 00       	mov    $0x806004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801a49:	89 13                	mov    %edx,(%ebx)
			return 0;
  801a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a50:	eb 35                	jmp    801a87 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801a52:	83 c0 01             	add    $0x1,%eax
  801a55:	8b 14 85 14 4b 80 00 	mov    0x804b14(,%eax,4),%edx
  801a5c:	85 d2                	test   %edx,%edx
  801a5e:	75 de                	jne    801a3e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a60:	a1 00 70 80 00       	mov    0x807000,%eax
  801a65:	8b 40 04             	mov    0x4(%eax),%eax
  801a68:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a70:	c7 04 24 d0 4a 80 00 	movl   $0x804ad0,(%esp)
  801a77:	e8 ea e9 ff ff       	call   800466 <_Z7cprintfPKcz>
	*dev = 0;
  801a7c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801a82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a87:	83 c4 14             	add    $0x14,%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    

00801a8d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	56                   	push   %esi
  801a91:	53                   	push   %ebx
  801a92:	83 ec 20             	sub    $0x20,%esp
  801a95:	8b 75 08             	mov    0x8(%ebp),%esi
  801a98:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  801a9c:	89 34 24             	mov    %esi,(%esp)
  801a9f:	e8 c0 fe ff ff       	call   801964 <_Z6fd2numP2Fd>
  801aa4:	0f b6 d3             	movzbl %bl,%edx
  801aa7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801aab:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801aae:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ab2:	89 04 24             	mov    %eax,(%esp)
  801ab5:	e8 57 fe ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 05                	js     801ac3 <_Z8fd_closeP2Fdb+0x36>
  801abe:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801ac1:	74 0c                	je     801acf <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801ac3:	80 fb 01             	cmp    $0x1,%bl
  801ac6:	19 db                	sbb    %ebx,%ebx
  801ac8:	f7 d3                	not    %ebx
  801aca:	83 e3 fd             	and    $0xfffffffd,%ebx
  801acd:	eb 3d                	jmp    801b0c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801acf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad6:	8b 06                	mov    (%esi),%eax
  801ad8:	89 04 24             	mov    %eax,(%esp)
  801adb:	e8 42 ff ff ff       	call   801a22 <_Z10dev_lookupiPP3Dev>
  801ae0:	89 c3                	mov    %eax,%ebx
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	78 16                	js     801afc <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801aec:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801af1:	85 c0                	test   %eax,%eax
  801af3:	74 07                	je     801afc <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801af5:	89 34 24             	mov    %esi,(%esp)
  801af8:	ff d0                	call   *%eax
  801afa:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801afc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b07:	e8 11 f5 ff ff       	call   80101d <_Z14sys_page_unmapiPv>
	return r;
}
  801b0c:	89 d8                	mov    %ebx,%eax
  801b0e:	83 c4 20             	add    $0x20,%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5d                   	pop    %ebp
  801b14:	c3                   	ret    

00801b15 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801b1b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801b22:	00 
  801b23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	89 04 24             	mov    %eax,(%esp)
  801b30:	e8 dc fd ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 13                	js     801b4c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801b39:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b40:	00 
  801b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b44:	89 04 24             	mov    %eax,(%esp)
  801b47:	e8 41 ff ff ff       	call   801a8d <_Z8fd_closeP2Fdb>
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <_Z9close_allv>:

void
close_all(void)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	53                   	push   %ebx
  801b52:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801b55:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b5a:	89 1c 24             	mov    %ebx,(%esp)
  801b5d:	e8 b3 ff ff ff       	call   801b15 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801b62:	83 c3 01             	add    $0x1,%ebx
  801b65:	83 fb 20             	cmp    $0x20,%ebx
  801b68:	75 f0                	jne    801b5a <_Z9close_allv+0xc>
		close(i);
}
  801b6a:	83 c4 14             	add    $0x14,%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    

00801b70 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 48             	sub    $0x48,%esp
  801b76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b79:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b7c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b7f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801b82:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801b89:	00 
  801b8a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	89 04 24             	mov    %eax,(%esp)
  801b97:	e8 75 fd ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  801b9c:	89 c3                	mov    %eax,%ebx
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	0f 88 ce 00 00 00    	js     801c74 <_Z3dupii+0x104>
  801ba6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bad:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  801bae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801bb5:	89 34 24             	mov    %esi,(%esp)
  801bb8:	e8 54 fd ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  801bbd:	89 c3                	mov    %eax,%ebx
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	0f 89 bc 00 00 00    	jns    801c83 <_Z3dupii+0x113>
  801bc7:	e9 a8 00 00 00       	jmp    801c74 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	c1 e8 0c             	shr    $0xc,%eax
  801bd1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801bd8:	f6 c2 01             	test   $0x1,%dl
  801bdb:	74 32                	je     801c0f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801bdd:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801be4:	25 07 0e 00 00       	and    $0xe07,%eax
  801be9:	89 44 24 10          	mov    %eax,0x10(%esp)
  801bed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bf1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bf8:	00 
  801bf9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bfd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c04:	e8 b6 f3 ff ff       	call   800fbf <_Z12sys_page_mapiPviS_i>
  801c09:	89 c3                	mov    %eax,%ebx
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	78 3e                	js     801c4d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c12:	89 c2                	mov    %eax,%edx
  801c14:	c1 ea 0c             	shr    $0xc,%edx
  801c17:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  801c1e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801c24:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c2b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c36:	00 
  801c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c42:	e8 78 f3 ff ff       	call   800fbf <_Z12sys_page_mapiPviS_i>
  801c47:	89 c3                	mov    %eax,%ebx
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	79 25                	jns    801c72 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801c4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c5b:	e8 bd f3 ff ff       	call   80101d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801c60:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c6b:	e8 ad f3 ff ff       	call   80101d <_Z14sys_page_unmapiPv>
	return r;
  801c70:	eb 02                	jmp    801c74 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801c72:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801c74:	89 d8                	mov    %ebx,%eax
  801c76:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c79:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c7c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c7f:	89 ec                	mov    %ebp,%esp
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801c83:	89 34 24             	mov    %esi,(%esp)
  801c86:	e8 8a fe ff ff       	call   801b15 <_Z5closei>

	ova = fd2data(oldfd);
  801c8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c8e:	89 04 24             	mov    %eax,(%esp)
  801c91:	e8 16 fd ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  801c96:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c9b:	89 04 24             	mov    %eax,(%esp)
  801c9e:	e8 09 fd ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  801ca3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801ca5:	89 d8                	mov    %ebx,%eax
  801ca7:	c1 e8 16             	shr    $0x16,%eax
  801caa:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801cb1:	a8 01                	test   $0x1,%al
  801cb3:	0f 85 13 ff ff ff    	jne    801bcc <_Z3dupii+0x5c>
  801cb9:	e9 51 ff ff ff       	jmp    801c0f <_Z3dupii+0x9f>

00801cbe <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	53                   	push   %ebx
  801cc2:	83 ec 24             	sub    $0x24,%esp
  801cc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801cc8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ccf:	00 
  801cd0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd7:	89 1c 24             	mov    %ebx,(%esp)
  801cda:	e8 32 fc ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	78 5f                	js     801d42 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ce3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801ced:	8b 00                	mov    (%eax),%eax
  801cef:	89 04 24             	mov    %eax,(%esp)
  801cf2:	e8 2b fd ff ff       	call   801a22 <_Z10dev_lookupiPP3Dev>
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	79 4d                	jns    801d48 <_Z4readiPvj+0x8a>
  801cfb:	eb 45                	jmp    801d42 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801cfd:	a1 00 70 80 00       	mov    0x807000,%eax
  801d02:	8b 40 04             	mov    0x4(%eax),%eax
  801d05:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0d:	c7 04 24 b2 4a 80 00 	movl   $0x804ab2,(%esp)
  801d14:	e8 4d e7 ff ff       	call   800466 <_Z7cprintfPKcz>
		return -E_INVAL;
  801d19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d1e:	eb 22                	jmp    801d42 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d23:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801d26:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801d2b:	85 d2                	test   %edx,%edx
  801d2d:	74 13                	je     801d42 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3d:	89 0c 24             	mov    %ecx,(%esp)
  801d40:	ff d2                	call   *%edx
}
  801d42:	83 c4 24             	add    $0x24,%esp
  801d45:	5b                   	pop    %ebx
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d48:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d4b:	8b 41 08             	mov    0x8(%ecx),%eax
  801d4e:	83 e0 03             	and    $0x3,%eax
  801d51:	83 f8 01             	cmp    $0x1,%eax
  801d54:	75 ca                	jne    801d20 <_Z4readiPvj+0x62>
  801d56:	eb a5                	jmp    801cfd <_Z4readiPvj+0x3f>

00801d58 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	57                   	push   %edi
  801d5c:	56                   	push   %esi
  801d5d:	53                   	push   %ebx
  801d5e:	83 ec 1c             	sub    $0x1c,%esp
  801d61:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d64:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801d67:	85 f6                	test   %esi,%esi
  801d69:	74 2f                	je     801d9a <_Z5readniPvj+0x42>
  801d6b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d70:	89 f0                	mov    %esi,%eax
  801d72:	29 d8                	sub    %ebx,%eax
  801d74:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d78:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	89 04 24             	mov    %eax,(%esp)
  801d85:	e8 34 ff ff ff       	call   801cbe <_Z4readiPvj>
		if (m < 0)
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 13                	js     801da1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	74 0d                	je     801d9f <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801d92:	01 c3                	add    %eax,%ebx
  801d94:	39 de                	cmp    %ebx,%esi
  801d96:	77 d8                	ja     801d70 <_Z5readniPvj+0x18>
  801d98:	eb 05                	jmp    801d9f <_Z5readniPvj+0x47>
  801d9a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801d9f:	89 d8                	mov    %ebx,%eax
}
  801da1:	83 c4 1c             	add    $0x1c,%esp
  801da4:	5b                   	pop    %ebx
  801da5:	5e                   	pop    %esi
  801da6:	5f                   	pop    %edi
  801da7:	5d                   	pop    %ebp
  801da8:	c3                   	ret    

00801da9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801daf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801db6:	00 
  801db7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dba:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	89 04 24             	mov    %eax,(%esp)
  801dc4:	e8 48 fb ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  801dc9:	85 c0                	test   %eax,%eax
  801dcb:	78 3c                	js     801e09 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801dcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801dd7:	8b 00                	mov    (%eax),%eax
  801dd9:	89 04 24             	mov    %eax,(%esp)
  801ddc:	e8 41 fc ff ff       	call   801a22 <_Z10dev_lookupiPP3Dev>
  801de1:	85 c0                	test   %eax,%eax
  801de3:	79 26                	jns    801e0b <_Z5writeiPKvj+0x62>
  801de5:	eb 22                	jmp    801e09 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dea:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  801ded:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801df2:	85 c9                	test   %ecx,%ecx
  801df4:	74 13                	je     801e09 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801df6:	8b 45 10             	mov    0x10(%ebp),%eax
  801df9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	89 14 24             	mov    %edx,(%esp)
  801e07:	ff d1                	call   *%ecx
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801e0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  801e0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801e13:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801e17:	74 f0                	je     801e09 <_Z5writeiPKvj+0x60>
  801e19:	eb cc                	jmp    801de7 <_Z5writeiPKvj+0x3e>

00801e1b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801e21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e28:	00 
  801e29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	89 04 24             	mov    %eax,(%esp)
  801e36:	e8 d6 fa ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	78 0e                	js     801e4d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  801e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e45:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	53                   	push   %ebx
  801e53:	83 ec 24             	sub    $0x24,%esp
  801e56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e59:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e60:	00 
  801e61:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e68:	89 1c 24             	mov    %ebx,(%esp)
  801e6b:	e8 a1 fa ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  801e70:	85 c0                	test   %eax,%eax
  801e72:	78 58                	js     801ecc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e7e:	8b 00                	mov    (%eax),%eax
  801e80:	89 04 24             	mov    %eax,(%esp)
  801e83:	e8 9a fb ff ff       	call   801a22 <_Z10dev_lookupiPP3Dev>
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	79 46                	jns    801ed2 <_Z9ftruncateii+0x83>
  801e8c:	eb 3e                	jmp    801ecc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801e8e:	a1 00 70 80 00       	mov    0x807000,%eax
  801e93:	8b 40 04             	mov    0x4(%eax),%eax
  801e96:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9e:	c7 04 24 f0 4a 80 00 	movl   $0x804af0,(%esp)
  801ea5:	e8 bc e5 ff ff       	call   800466 <_Z7cprintfPKcz>
		return -E_INVAL;
  801eaa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eaf:	eb 1b                	jmp    801ecc <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801eb7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ebc:	85 d2                	test   %edx,%edx
  801ebe:	74 0c                	je     801ecc <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec7:	89 0c 24             	mov    %ecx,(%esp)
  801eca:	ff d2                	call   *%edx
}
  801ecc:	83 c4 24             	add    $0x24,%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5d                   	pop    %ebp
  801ed1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ed2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ed5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801ed9:	75 d6                	jne    801eb1 <_Z9ftruncateii+0x62>
  801edb:	eb b1                	jmp    801e8e <_Z9ftruncateii+0x3f>

00801edd <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	53                   	push   %ebx
  801ee1:	83 ec 24             	sub    $0x24,%esp
  801ee4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801ee7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801eee:	00 
  801eef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	89 04 24             	mov    %eax,(%esp)
  801efc:	e8 10 fa ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 3e                	js     801f43 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801f0f:	8b 00                	mov    (%eax),%eax
  801f11:	89 04 24             	mov    %eax,(%esp)
  801f14:	e8 09 fb ff ff       	call   801a22 <_Z10dev_lookupiPP3Dev>
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	79 2c                	jns    801f49 <_Z5fstatiP4Stat+0x6c>
  801f1d:	eb 24                	jmp    801f43 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801f1f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801f22:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801f29:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801f30:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801f36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3d:	89 04 24             	mov    %eax,(%esp)
  801f40:	ff 52 14             	call   *0x14(%edx)
}
  801f43:	83 c4 24             	add    $0x24,%esp
  801f46:	5b                   	pop    %ebx
  801f47:	5d                   	pop    %ebp
  801f48:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  801f4c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801f51:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801f55:	75 c8                	jne    801f1f <_Z5fstatiP4Stat+0x42>
  801f57:	eb ea                	jmp    801f43 <_Z5fstatiP4Stat+0x66>

00801f59 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 18             	sub    $0x18,%esp
  801f5f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801f62:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801f65:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f6c:	00 
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	89 04 24             	mov    %eax,(%esp)
  801f73:	e8 d6 09 00 00       	call   80294e <_Z4openPKci>
  801f78:	89 c3                	mov    %eax,%ebx
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	78 1b                	js     801f99 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f85:	89 1c 24             	mov    %ebx,(%esp)
  801f88:	e8 50 ff ff ff       	call   801edd <_Z5fstatiP4Stat>
  801f8d:	89 c6                	mov    %eax,%esi
	close(fd);
  801f8f:	89 1c 24             	mov    %ebx,(%esp)
  801f92:	e8 7e fb ff ff       	call   801b15 <_Z5closei>
	return r;
  801f97:	89 f3                	mov    %esi,%ebx
}
  801f99:	89 d8                	mov    %ebx,%eax
  801f9b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f9e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801fa1:	89 ec                	mov    %ebp,%esp
  801fa3:	5d                   	pop    %ebp
  801fa4:	c3                   	ret    
	...

00801fb0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  801fb3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  801fb8:	85 d2                	test   %edx,%edx
  801fba:	78 33                	js     801fef <_ZL10inode_dataP5Inodei+0x3f>
  801fbc:	3b 50 08             	cmp    0x8(%eax),%edx
  801fbf:	7d 2e                	jge    801fef <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  801fc1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801fc7:	85 d2                	test   %edx,%edx
  801fc9:	0f 49 ca             	cmovns %edx,%ecx
  801fcc:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  801fcf:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  801fd3:	c1 e1 0c             	shl    $0xc,%ecx
  801fd6:	89 d0                	mov    %edx,%eax
  801fd8:	c1 f8 1f             	sar    $0x1f,%eax
  801fdb:	c1 e8 14             	shr    $0x14,%eax
  801fde:	01 c2                	add    %eax,%edx
  801fe0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801fe6:	29 c2                	sub    %eax,%edx
  801fe8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  801fef:	89 c8                	mov    %ecx,%eax
  801ff1:	5d                   	pop    %ebp
  801ff2:	c3                   	ret    

00801ff3 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  801ff6:	8b 48 08             	mov    0x8(%eax),%ecx
  801ff9:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  801ffc:	8b 00                	mov    (%eax),%eax
  801ffe:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  802001:	c7 82 80 00 00 00 04 	movl   $0x806004,0x80(%edx)
  802008:	60 80 00 
}
  80200b:	5d                   	pop    %ebp
  80200c:	c3                   	ret    

0080200d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802013:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  802019:	85 c0                	test   %eax,%eax
  80201b:	74 08                	je     802025 <_ZL9get_inodei+0x18>
  80201d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802023:	7e 20                	jle    802045 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  802025:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802029:	c7 44 24 08 28 4b 80 	movl   $0x804b28,0x8(%esp)
  802030:	00 
  802031:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  802038:	00 
  802039:	c7 04 24 3e 4b 80 00 	movl   $0x804b3e,(%esp)
  802040:	e8 03 e3 ff ff       	call   800348 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802045:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80204b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802051:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802057:	85 d2                	test   %edx,%edx
  802059:	0f 48 d1             	cmovs  %ecx,%edx
  80205c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  80205f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  802066:	c1 e0 0c             	shl    $0xc,%eax
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	56                   	push   %esi
  80206f:	53                   	push   %ebx
  802070:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  802073:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  802079:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  80207c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  802082:	76 20                	jbe    8020a4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  802084:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802088:	c7 44 24 08 64 4b 80 	movl   $0x804b64,0x8(%esp)
  80208f:	00 
  802090:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802097:	00 
  802098:	c7 04 24 3e 4b 80 00 	movl   $0x804b3e,(%esp)
  80209f:	e8 a4 e2 ff ff       	call   800348 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  8020a4:	83 fe 01             	cmp    $0x1,%esi
  8020a7:	7e 08                	jle    8020b1 <_ZL10bcache_ipcPvi+0x46>
  8020a9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  8020af:	7d 12                	jge    8020c3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8020b1:	89 f3                	mov    %esi,%ebx
  8020b3:	c1 e3 04             	shl    $0x4,%ebx
  8020b6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8020b8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  8020be:	c1 e6 0c             	shl    $0xc,%esi
  8020c1:	eb 20                	jmp    8020e3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  8020c3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8020c7:	c7 44 24 08 94 4b 80 	movl   $0x804b94,0x8(%esp)
  8020ce:	00 
  8020cf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8020d6:	00 
  8020d7:	c7 04 24 3e 4b 80 00 	movl   $0x804b3e,(%esp)
  8020de:	e8 65 e2 ff ff       	call   800348 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8020e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020ea:	00 
  8020eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020f2:	00 
  8020f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020f7:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  8020fe:	e8 cc 21 00 00       	call   8042cf <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802103:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80210a:	00 
  80210b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80210f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802116:	e8 25 21 00 00       	call   804240 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  80211b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80211e:	74 c3                	je     8020e3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  802120:	83 c4 10             	add    $0x10,%esp
  802123:	5b                   	pop    %ebx
  802124:	5e                   	pop    %esi
  802125:	5d                   	pop    %ebp
  802126:	c3                   	ret    

00802127 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 28             	sub    $0x28,%esp
  80212d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802130:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802133:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802136:	89 c7                	mov    %eax,%edi
  802138:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  80213a:	c7 04 24 cd 23 80 00 	movl   $0x8023cd,(%esp)
  802141:	e8 05 20 00 00       	call   80414b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  802146:	89 f8                	mov    %edi,%eax
  802148:	e8 c0 fe ff ff       	call   80200d <_ZL9get_inodei>
  80214d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  80214f:	ba 02 00 00 00       	mov    $0x2,%edx
  802154:	e8 12 ff ff ff       	call   80206b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  802159:	85 c0                	test   %eax,%eax
  80215b:	79 08                	jns    802165 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  80215d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  802163:	eb 2e                	jmp    802193 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  802165:	85 c0                	test   %eax,%eax
  802167:	75 1c                	jne    802185 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  802169:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  80216f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  802176:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  802179:	ba 06 00 00 00       	mov    $0x6,%edx
  80217e:	89 d8                	mov    %ebx,%eax
  802180:	e8 e6 fe ff ff       	call   80206b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  802185:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  80218c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  80218e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802193:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802196:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802199:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80219c:	89 ec                	mov    %ebp,%esp
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    

008021a0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	57                   	push   %edi
  8021a4:	56                   	push   %esi
  8021a5:	53                   	push   %ebx
  8021a6:	83 ec 2c             	sub    $0x2c,%esp
  8021a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8021ac:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  8021af:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  8021b4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  8021ba:	0f 87 3d 01 00 00    	ja     8022fd <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  8021c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8021c3:	8b 42 08             	mov    0x8(%edx),%eax
  8021c6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	0f 49 f0             	cmovns %eax,%esi
  8021d1:	c1 fe 0c             	sar    $0xc,%esi
  8021d4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  8021d6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  8021d9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  8021df:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  8021e2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8021e5:	0f 82 a6 00 00 00    	jb     802291 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  8021eb:	39 fe                	cmp    %edi,%esi
  8021ed:	0f 8d f2 00 00 00    	jge    8022e5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8021f3:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  8021f7:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8021fa:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8021fd:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  802200:	83 3e 00             	cmpl   $0x0,(%esi)
  802203:	75 77                	jne    80227c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802205:	ba 02 00 00 00       	mov    $0x2,%edx
  80220a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80220f:	e8 57 fe ff ff       	call   80206b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802214:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  80221a:	83 f9 02             	cmp    $0x2,%ecx
  80221d:	7e 43                	jle    802262 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  80221f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802224:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  802229:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802230:	74 29                	je     80225b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802232:	e9 ce 00 00 00       	jmp    802305 <_ZL14inode_set_sizeP5Inodej+0x165>
  802237:	89 c7                	mov    %eax,%edi
  802239:	0f b6 10             	movzbl (%eax),%edx
  80223c:	83 c0 01             	add    $0x1,%eax
  80223f:	84 d2                	test   %dl,%dl
  802241:	74 18                	je     80225b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802243:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802246:	ba 05 00 00 00       	mov    $0x5,%edx
  80224b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802250:	e8 16 fe ff ff       	call   80206b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802255:	85 db                	test   %ebx,%ebx
  802257:	79 1e                	jns    802277 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802259:	eb 07                	jmp    802262 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80225b:	83 c3 01             	add    $0x1,%ebx
  80225e:	39 d9                	cmp    %ebx,%ecx
  802260:	7f d5                	jg     802237 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  802262:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802265:	8b 50 08             	mov    0x8(%eax),%edx
  802268:	e8 33 ff ff ff       	call   8021a0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  80226d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802272:	e9 86 00 00 00       	jmp    8022fd <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  802277:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80227a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  80227c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  802280:	83 c6 04             	add    $0x4,%esi
  802283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802286:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  802289:	0f 8f 6e ff ff ff    	jg     8021fd <_ZL14inode_set_sizeP5Inodej+0x5d>
  80228f:	eb 54                	jmp    8022e5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  802291:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802294:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  802299:	83 f8 01             	cmp    $0x1,%eax
  80229c:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  80229f:	ba 02 00 00 00       	mov    $0x2,%edx
  8022a4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8022a9:	e8 bd fd ff ff       	call   80206b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  8022ae:	39 f7                	cmp    %esi,%edi
  8022b0:	7d 24                	jge    8022d6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8022b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8022b5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  8022b9:	8b 10                	mov    (%eax),%edx
  8022bb:	85 d2                	test   %edx,%edx
  8022bd:	74 0d                	je     8022cc <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  8022bf:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  8022c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  8022cc:	83 eb 01             	sub    $0x1,%ebx
  8022cf:	83 e8 04             	sub    $0x4,%eax
  8022d2:	39 fb                	cmp    %edi,%ebx
  8022d4:	75 e3                	jne    8022b9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8022d6:	ba 05 00 00 00       	mov    $0x5,%edx
  8022db:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8022e0:	e8 86 fd ff ff       	call   80206b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  8022e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022eb:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  8022ee:	ba 04 00 00 00       	mov    $0x4,%edx
  8022f3:	e8 73 fd ff ff       	call   80206b <_ZL10bcache_ipcPvi>
	return 0;
  8022f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fd:	83 c4 2c             	add    $0x2c,%esp
  802300:	5b                   	pop    %ebx
  802301:	5e                   	pop    %esi
  802302:	5f                   	pop    %edi
  802303:	5d                   	pop    %ebp
  802304:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802305:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  80230c:	ba 05 00 00 00       	mov    $0x5,%edx
  802311:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802316:	e8 50 fd ff ff       	call   80206b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80231b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802320:	e9 52 ff ff ff       	jmp    802277 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802325 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	53                   	push   %ebx
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  80232e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802334:	83 e8 01             	sub    $0x1,%eax
  802337:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  80233d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802341:	75 40                	jne    802383 <_ZL11inode_closeP5Inode+0x5e>
  802343:	85 c0                	test   %eax,%eax
  802345:	75 3c                	jne    802383 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802347:	ba 02 00 00 00       	mov    $0x2,%edx
  80234c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802351:	e8 15 fd ff ff       	call   80206b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802356:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  80235b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  80235f:	85 d2                	test   %edx,%edx
  802361:	74 07                	je     80236a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  802363:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  80236a:	83 c0 01             	add    $0x1,%eax
  80236d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  802372:	75 e7                	jne    80235b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802374:	ba 05 00 00 00       	mov    $0x5,%edx
  802379:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80237e:	e8 e8 fc ff ff       	call   80206b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  802383:	ba 03 00 00 00       	mov    $0x3,%edx
  802388:	89 d8                	mov    %ebx,%eax
  80238a:	e8 dc fc ff ff       	call   80206b <_ZL10bcache_ipcPvi>
}
  80238f:	83 c4 04             	add    $0x4,%esp
  802392:	5b                   	pop    %ebx
  802393:	5d                   	pop    %ebp
  802394:	c3                   	ret    

00802395 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	53                   	push   %ebx
  802399:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8023a5:	e8 7d fd ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  8023aa:	89 c3                	mov    %eax,%ebx
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	78 15                	js     8023c5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  8023b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	e8 e5 fd ff ff       	call   8021a0 <_ZL14inode_set_sizeP5Inodej>
  8023bb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	e8 60 ff ff ff       	call   802325 <_ZL11inode_closeP5Inode>
	return r;
}
  8023c5:	89 d8                	mov    %ebx,%eax
  8023c7:	83 c4 14             	add    $0x14,%esp
  8023ca:	5b                   	pop    %ebx
  8023cb:	5d                   	pop    %ebp
  8023cc:	c3                   	ret    

008023cd <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	53                   	push   %ebx
  8023d1:	83 ec 14             	sub    $0x14,%esp
  8023d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  8023d7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  8023d9:	89 c2                	mov    %eax,%edx
  8023db:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  8023e1:	78 32                	js     802415 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  8023e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e8:	e8 7e fc ff ff       	call   80206b <_ZL10bcache_ipcPvi>
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	74 1c                	je     80240d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  8023f1:	c7 44 24 08 49 4b 80 	movl   $0x804b49,0x8(%esp)
  8023f8:	00 
  8023f9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802400:	00 
  802401:	c7 04 24 3e 4b 80 00 	movl   $0x804b3e,(%esp)
  802408:	e8 3b df ff ff       	call   800348 <_Z6_panicPKciS0_z>
    resume(utf);
  80240d:	89 1c 24             	mov    %ebx,(%esp)
  802410:	e8 0b 1e 00 00       	call   804220 <resume>
}
  802415:	83 c4 14             	add    $0x14,%esp
  802418:	5b                   	pop    %ebx
  802419:	5d                   	pop    %ebp
  80241a:	c3                   	ret    

0080241b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 28             	sub    $0x28,%esp
  802421:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802424:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80242a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80242d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802430:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802433:	e8 ef fc ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  802438:	85 c0                	test   %eax,%eax
  80243a:	78 26                	js     802462 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80243c:	83 c3 10             	add    $0x10,%ebx
  80243f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802443:	89 34 24             	mov    %esi,(%esp)
  802446:	e8 2f e6 ff ff       	call   800a7a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80244b:	89 f2                	mov    %esi,%edx
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	e8 9e fb ff ff       	call   801ff3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	e8 c8 fe ff ff       	call   802325 <_ZL11inode_closeP5Inode>
	return 0;
  80245d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802462:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802465:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802468:	89 ec                	mov    %ebp,%esp
  80246a:	5d                   	pop    %ebp
  80246b:	c3                   	ret    

0080246c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	53                   	push   %ebx
  802470:	83 ec 24             	sub    $0x24,%esp
  802473:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802476:	89 1c 24             	mov    %ebx,(%esp)
  802479:	e8 9e 15 00 00       	call   803a1c <_Z7pagerefPv>
  80247e:	89 c2                	mov    %eax,%edx
        return 0;
  802480:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802485:	83 fa 01             	cmp    $0x1,%edx
  802488:	7f 1e                	jg     8024a8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80248a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80248d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802490:	e8 92 fc ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  802495:	85 c0                	test   %eax,%eax
  802497:	78 0f                	js     8024a8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  8024a3:	e8 7d fe ff ff       	call   802325 <_ZL11inode_closeP5Inode>
}
  8024a8:	83 c4 24             	add    $0x24,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5d                   	pop    %ebp
  8024ad:	c3                   	ret    

008024ae <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 3c             	sub    $0x3c,%esp
  8024b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024ba:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  8024bd:	8b 43 04             	mov    0x4(%ebx),%eax
  8024c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8024c3:	8b 43 0c             	mov    0xc(%ebx),%eax
  8024c6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8024c9:	e8 59 fc ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	0f 88 8c 00 00 00    	js     802562 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8024d6:	8b 53 04             	mov    0x4(%ebx),%edx
  8024d9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  8024df:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  8024e5:	29 d7                	sub    %edx,%edi
  8024e7:	39 f7                	cmp    %esi,%edi
  8024e9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  8024ec:	85 ff                	test   %edi,%edi
  8024ee:	74 16                	je     802506 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  8024f0:	8d 14 17             	lea    (%edi,%edx,1),%edx
  8024f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f6:	3b 50 08             	cmp    0x8(%eax),%edx
  8024f9:	76 6f                	jbe    80256a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  8024fb:	e8 a0 fc ff ff       	call   8021a0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802500:	85 c0                	test   %eax,%eax
  802502:	79 66                	jns    80256a <_ZL13devfile_writeP2FdPKvj+0xbc>
  802504:	eb 4e                	jmp    802554 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802506:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80250c:	76 24                	jbe    802532 <_ZL13devfile_writeP2FdPKvj+0x84>
  80250e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802510:	8b 53 04             	mov    0x4(%ebx),%edx
  802513:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251c:	3b 50 08             	cmp    0x8(%eax),%edx
  80251f:	0f 86 83 00 00 00    	jbe    8025a8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802525:	e8 76 fc ff ff       	call   8021a0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80252a:	85 c0                	test   %eax,%eax
  80252c:	79 7a                	jns    8025a8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80252e:	66 90                	xchg   %ax,%ax
  802530:	eb 22                	jmp    802554 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802532:	85 f6                	test   %esi,%esi
  802534:	74 1e                	je     802554 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802536:	89 f2                	mov    %esi,%edx
  802538:	03 53 04             	add    0x4(%ebx),%edx
  80253b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253e:	3b 50 08             	cmp    0x8(%eax),%edx
  802541:	0f 86 b8 00 00 00    	jbe    8025ff <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802547:	e8 54 fc ff ff       	call   8021a0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80254c:	85 c0                	test   %eax,%eax
  80254e:	0f 89 ab 00 00 00    	jns    8025ff <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802557:	e8 c9 fd ff ff       	call   802325 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80255c:	8b 43 04             	mov    0x4(%ebx),%eax
  80255f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  802562:	83 c4 3c             	add    $0x3c,%esp
  802565:	5b                   	pop    %ebx
  802566:	5e                   	pop    %esi
  802567:	5f                   	pop    %edi
  802568:	5d                   	pop    %ebp
  802569:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80256a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80256c:	8b 53 04             	mov    0x4(%ebx),%edx
  80256f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802572:	e8 39 fa ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
  802577:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80257a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80257e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802581:	89 44 24 04          	mov    %eax,0x4(%esp)
  802585:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802588:	89 04 24             	mov    %eax,(%esp)
  80258b:	e8 07 e7 ff ff       	call   800c97 <memcpy>
        fd->fd_offset += n2;
  802590:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  802593:	ba 04 00 00 00       	mov    $0x4,%edx
  802598:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80259b:	e8 cb fa ff ff       	call   80206b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  8025a0:	01 7d 0c             	add    %edi,0xc(%ebp)
  8025a3:	e9 5e ff ff ff       	jmp    802506 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8025a8:	8b 53 04             	mov    0x4(%ebx),%edx
  8025ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ae:	e8 fd f9 ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
  8025b3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  8025b5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8025bc:	00 
  8025bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c4:	89 34 24             	mov    %esi,(%esp)
  8025c7:	e8 cb e6 ff ff       	call   800c97 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8025cc:	ba 04 00 00 00       	mov    $0x4,%edx
  8025d1:	89 f0                	mov    %esi,%eax
  8025d3:	e8 93 fa ff ff       	call   80206b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  8025d8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  8025de:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  8025e5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8025ec:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8025f2:	0f 87 18 ff ff ff    	ja     802510 <_ZL13devfile_writeP2FdPKvj+0x62>
  8025f8:	89 fe                	mov    %edi,%esi
  8025fa:	e9 33 ff ff ff       	jmp    802532 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8025ff:	8b 53 04             	mov    0x4(%ebx),%edx
  802602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802605:	e8 a6 f9 ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
  80260a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80260c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802610:	8b 45 0c             	mov    0xc(%ebp),%eax
  802613:	89 44 24 04          	mov    %eax,0x4(%esp)
  802617:	89 3c 24             	mov    %edi,(%esp)
  80261a:	e8 78 e6 ff ff       	call   800c97 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80261f:	ba 04 00 00 00       	mov    $0x4,%edx
  802624:	89 f8                	mov    %edi,%eax
  802626:	e8 40 fa ff ff       	call   80206b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80262b:	01 73 04             	add    %esi,0x4(%ebx)
  80262e:	e9 21 ff ff ff       	jmp    802554 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802633 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	57                   	push   %edi
  802637:	56                   	push   %esi
  802638:	53                   	push   %ebx
  802639:	83 ec 3c             	sub    $0x3c,%esp
  80263c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80263f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802642:	8b 43 04             	mov    0x4(%ebx),%eax
  802645:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802648:	8b 43 0c             	mov    0xc(%ebx),%eax
  80264b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80264e:	e8 d4 fa ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  802653:	85 c0                	test   %eax,%eax
  802655:	0f 88 d3 00 00 00    	js     80272e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80265b:	8b 73 04             	mov    0x4(%ebx),%esi
  80265e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802661:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802664:	8b 50 08             	mov    0x8(%eax),%edx
  802667:	29 f2                	sub    %esi,%edx
  802669:	3b 48 08             	cmp    0x8(%eax),%ecx
  80266c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80266f:	89 f2                	mov    %esi,%edx
  802671:	e8 3a f9 ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
  802676:	85 c0                	test   %eax,%eax
  802678:	0f 84 a2 00 00 00    	je     802720 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80267e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802684:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80268a:	29 f2                	sub    %esi,%edx
  80268c:	39 d7                	cmp    %edx,%edi
  80268e:	0f 46 d7             	cmovbe %edi,%edx
  802691:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802694:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802696:	01 d6                	add    %edx,%esi
  802698:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  80269b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80269f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a6:	89 04 24             	mov    %eax,(%esp)
  8026a9:	e8 e9 e5 ff ff       	call   800c97 <memcpy>
    buf = (void *)((char *)buf + n2);
  8026ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026b1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8026b4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8026ba:	76 3e                	jbe    8026fa <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8026bc:	8b 53 04             	mov    0x4(%ebx),%edx
  8026bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c2:	e8 e9 f8 ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	74 55                	je     802720 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  8026cb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8026d2:	00 
  8026d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d7:	89 34 24             	mov    %esi,(%esp)
  8026da:	e8 b8 e5 ff ff       	call   800c97 <memcpy>
        n -= PGSIZE;
  8026df:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8026e5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8026eb:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  8026f2:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8026f8:	77 c2                	ja     8026bc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  8026fa:	85 ff                	test   %edi,%edi
  8026fc:	74 22                	je     802720 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8026fe:	8b 53 04             	mov    0x4(%ebx),%edx
  802701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802704:	e8 a7 f8 ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
  802709:	85 c0                	test   %eax,%eax
  80270b:	74 13                	je     802720 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80270d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802711:	89 44 24 04          	mov    %eax,0x4(%esp)
  802715:	89 34 24             	mov    %esi,(%esp)
  802718:	e8 7a e5 ff ff       	call   800c97 <memcpy>
        fd->fd_offset += n;
  80271d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802723:	e8 fd fb ff ff       	call   802325 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802728:	8b 43 04             	mov    0x4(%ebx),%eax
  80272b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80272e:	83 c4 3c             	add    $0x3c,%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5f                   	pop    %edi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    

00802736 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	57                   	push   %edi
  80273a:	56                   	push   %esi
  80273b:	53                   	push   %ebx
  80273c:	83 ec 4c             	sub    $0x4c,%esp
  80273f:	89 c6                	mov    %eax,%esi
  802741:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802744:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802747:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80274d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802756:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802759:	b8 01 00 00 00       	mov    $0x1,%eax
  80275e:	e8 c4 f9 ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  802763:	89 c7                	mov    %eax,%edi
  802765:	85 c0                	test   %eax,%eax
  802767:	0f 88 cd 01 00 00    	js     80293a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80276d:	89 f3                	mov    %esi,%ebx
  80276f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802772:	75 08                	jne    80277c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802774:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802777:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80277a:	74 f8                	je     802774 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80277c:	0f b6 03             	movzbl (%ebx),%eax
  80277f:	3c 2f                	cmp    $0x2f,%al
  802781:	74 16                	je     802799 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802783:	84 c0                	test   %al,%al
  802785:	74 12                	je     802799 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802787:	89 da                	mov    %ebx,%edx
		++path;
  802789:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80278c:	0f b6 02             	movzbl (%edx),%eax
  80278f:	3c 2f                	cmp    $0x2f,%al
  802791:	74 08                	je     80279b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802793:	84 c0                	test   %al,%al
  802795:	75 f2                	jne    802789 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802797:	eb 02                	jmp    80279b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802799:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  80279b:	89 d0                	mov    %edx,%eax
  80279d:	29 d8                	sub    %ebx,%eax
  80279f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  8027a2:	0f b6 02             	movzbl (%edx),%eax
  8027a5:	89 d6                	mov    %edx,%esi
  8027a7:	3c 2f                	cmp    $0x2f,%al
  8027a9:	75 0a                	jne    8027b5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  8027ab:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  8027ae:	0f b6 06             	movzbl (%esi),%eax
  8027b1:	3c 2f                	cmp    $0x2f,%al
  8027b3:	74 f6                	je     8027ab <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8027b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8027b9:	75 1b                	jne    8027d6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8027bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027be:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8027c1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8027c3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027c6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8027cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d1:	e9 64 01 00 00       	jmp    80293a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8027d6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8027da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027de:	74 06                	je     8027e6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8027e0:	84 c0                	test   %al,%al
  8027e2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8027e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8027ec:	83 3a 02             	cmpl   $0x2,(%edx)
  8027ef:	0f 85 f4 00 00 00    	jne    8028e9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8027f5:	89 d0                	mov    %edx,%eax
  8027f7:	8b 52 08             	mov    0x8(%edx),%edx
  8027fa:	85 d2                	test   %edx,%edx
  8027fc:	7e 78                	jle    802876 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  8027fe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802805:	bf 00 00 00 00       	mov    $0x0,%edi
  80280a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80280d:	89 fb                	mov    %edi,%ebx
  80280f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802812:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802814:	89 da                	mov    %ebx,%edx
  802816:	89 f0                	mov    %esi,%eax
  802818:	e8 93 f7 ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
  80281d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80281f:	83 38 00             	cmpl   $0x0,(%eax)
  802822:	74 26                	je     80284a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802824:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802827:	3b 50 04             	cmp    0x4(%eax),%edx
  80282a:	75 33                	jne    80285f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80282c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802830:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802833:	89 44 24 04          	mov    %eax,0x4(%esp)
  802837:	8d 47 08             	lea    0x8(%edi),%eax
  80283a:	89 04 24             	mov    %eax,(%esp)
  80283d:	e8 96 e4 ff ff       	call   800cd8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802842:	85 c0                	test   %eax,%eax
  802844:	0f 84 fa 00 00 00    	je     802944 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80284a:	83 3f 00             	cmpl   $0x0,(%edi)
  80284d:	75 10                	jne    80285f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80284f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802853:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802856:	84 c0                	test   %al,%al
  802858:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80285c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80285f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802865:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802867:	8b 56 08             	mov    0x8(%esi),%edx
  80286a:	39 d0                	cmp    %edx,%eax
  80286c:	7c a6                	jl     802814 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80286e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802871:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802874:	eb 07                	jmp    80287d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802876:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80287d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802881:	74 6d                	je     8028f0 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802883:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802887:	75 24                	jne    8028ad <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802889:	83 ea 80             	sub    $0xffffff80,%edx
  80288c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80288f:	e8 0c f9 ff ff       	call   8021a0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802894:	85 c0                	test   %eax,%eax
  802896:	0f 88 90 00 00 00    	js     80292c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  80289c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80289f:	8b 50 08             	mov    0x8(%eax),%edx
  8028a2:	83 c2 80             	add    $0xffffff80,%edx
  8028a5:	e8 06 f7 ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
  8028aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  8028ad:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8028b4:	00 
  8028b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8028bc:	00 
  8028bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028c0:	89 14 24             	mov    %edx,(%esp)
  8028c3:	e8 f9 e2 ff ff       	call   800bc1 <memset>
	empty->de_namelen = namelen;
  8028c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ce:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8028d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028d9:	83 c0 08             	add    $0x8,%eax
  8028dc:	89 04 24             	mov    %eax,(%esp)
  8028df:	e8 b3 e3 ff ff       	call   800c97 <memcpy>
	*de_store = empty;
  8028e4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  8028e7:	eb 5e                	jmp    802947 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  8028e9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  8028ee:	eb 42                	jmp    802932 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  8028f0:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  8028f5:	eb 3b                	jmp    802932 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  8028f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fa:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8028fd:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  8028ff:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802902:	89 38                	mov    %edi,(%eax)
			return 0;
  802904:	bf 00 00 00 00       	mov    $0x0,%edi
  802909:	eb 2f                	jmp    80293a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80290b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80290e:	8b 07                	mov    (%edi),%eax
  802910:	e8 12 f8 ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  802915:	85 c0                	test   %eax,%eax
  802917:	78 17                	js     802930 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802919:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291c:	e8 04 fa ff ff       	call   802325 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802921:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802924:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802927:	e9 41 fe ff ff       	jmp    80276d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80292c:	89 c7                	mov    %eax,%edi
  80292e:	eb 02                	jmp    802932 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802930:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802935:	e8 eb f9 ff ff       	call   802325 <_ZL11inode_closeP5Inode>
	return r;
}
  80293a:	89 f8                	mov    %edi,%eax
  80293c:	83 c4 4c             	add    $0x4c,%esp
  80293f:	5b                   	pop    %ebx
  802940:	5e                   	pop    %esi
  802941:	5f                   	pop    %edi
  802942:	5d                   	pop    %ebp
  802943:	c3                   	ret    
  802944:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802947:	80 3e 00             	cmpb   $0x0,(%esi)
  80294a:	75 bf                	jne    80290b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80294c:	eb a9                	jmp    8028f7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080294e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	57                   	push   %edi
  802952:	56                   	push   %esi
  802953:	53                   	push   %ebx
  802954:	83 ec 3c             	sub    $0x3c,%esp
  802957:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80295a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80295d:	89 04 24             	mov    %eax,(%esp)
  802960:	e8 62 f0 ff ff       	call   8019c7 <_Z14fd_find_unusedPP2Fd>
  802965:	89 c3                	mov    %eax,%ebx
  802967:	85 c0                	test   %eax,%eax
  802969:	0f 88 16 02 00 00    	js     802b85 <_Z4openPKci+0x237>
  80296f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802976:	00 
  802977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80297e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802985:	e8 d6 e5 ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  80298a:	89 c3                	mov    %eax,%ebx
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
  802991:	85 db                	test   %ebx,%ebx
  802993:	0f 88 ec 01 00 00    	js     802b85 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802999:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  80299d:	0f 84 ec 01 00 00    	je     802b8f <_Z4openPKci+0x241>
  8029a3:	83 c0 01             	add    $0x1,%eax
  8029a6:	83 f8 78             	cmp    $0x78,%eax
  8029a9:	75 ee                	jne    802999 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8029ab:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8029b0:	e9 b9 01 00 00       	jmp    802b6e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8029b5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8029b8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8029be:	89 3c 24             	mov    %edi,(%esp)
  8029c1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  8029c4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8029c7:	89 f0                	mov    %esi,%eax
  8029c9:	e8 68 fd ff ff       	call   802736 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8029ce:	89 c3                	mov    %eax,%ebx
  8029d0:	85 c0                	test   %eax,%eax
  8029d2:	0f 85 96 01 00 00    	jne    802b6e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8029d8:	85 ff                	test   %edi,%edi
  8029da:	75 41                	jne    802a1d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8029dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029df:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  8029e4:	75 08                	jne    8029ee <_Z4openPKci+0xa0>
            fileino = dirino;
  8029e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8029ec:	eb 14                	jmp    802a02 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  8029ee:	8d 55 d8             	lea    -0x28(%ebp),%edx
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	e8 2f f7 ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  8029f8:	89 c3                	mov    %eax,%ebx
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	0f 88 5d 01 00 00    	js     802b5f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802a02:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a05:	83 38 02             	cmpl   $0x2,(%eax)
  802a08:	0f 85 d2 00 00 00    	jne    802ae0 <_Z4openPKci+0x192>
  802a0e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802a12:	0f 84 c8 00 00 00    	je     802ae0 <_Z4openPKci+0x192>
  802a18:	e9 38 01 00 00       	jmp    802b55 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  802a1d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802a24:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  802a2b:	0f 8e a8 00 00 00    	jle    802ad9 <_Z4openPKci+0x18b>
  802a31:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802a36:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802a39:	89 f8                	mov    %edi,%eax
  802a3b:	e8 e7 f6 ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  802a40:	89 c3                	mov    %eax,%ebx
  802a42:	85 c0                	test   %eax,%eax
  802a44:	0f 88 15 01 00 00    	js     802b5f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  802a4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a4d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802a51:	75 68                	jne    802abb <_Z4openPKci+0x16d>
  802a53:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  802a5a:	75 5f                	jne    802abb <_Z4openPKci+0x16d>
			*ino_store = ino;
  802a5c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  802a5f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802a65:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a68:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  802a6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802a76:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  802a7d:	00 
  802a7e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a85:	00 
  802a86:	83 c0 0c             	add    $0xc,%eax
  802a89:	89 04 24             	mov    %eax,(%esp)
  802a8c:	e8 30 e1 ff ff       	call   800bc1 <memset>
        de->de_inum = fileino->i_inum;
  802a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a94:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  802a9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a9d:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  802a9f:	ba 04 00 00 00       	mov    $0x4,%edx
  802aa4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802aa7:	e8 bf f5 ff ff       	call   80206b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  802aac:	ba 04 00 00 00       	mov    $0x4,%edx
  802ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab4:	e8 b2 f5 ff ff       	call   80206b <_ZL10bcache_ipcPvi>
  802ab9:	eb 25                	jmp    802ae0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  802abb:	e8 65 f8 ff ff       	call   802325 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802ac0:	83 c7 01             	add    $0x1,%edi
  802ac3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802ac9:	0f 8c 67 ff ff ff    	jl     802a36 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  802acf:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802ad4:	e9 86 00 00 00       	jmp    802b5f <_Z4openPKci+0x211>
  802ad9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802ade:	eb 7f                	jmp    802b5f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802ae0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802ae7:	74 0d                	je     802af6 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802ae9:	ba 00 00 00 00       	mov    $0x0,%edx
  802aee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802af1:	e8 aa f6 ff ff       	call   8021a0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802af6:	8b 15 04 60 80 00    	mov    0x806004,%edx
  802afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aff:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  802b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b0e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802b11:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b14:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  802b1a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  802b1d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b21:	83 c0 10             	add    $0x10,%eax
  802b24:	89 04 24             	mov    %eax,(%esp)
  802b27:	e8 4e df ff ff       	call   800a7a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  802b2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b2f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b39:	e8 e7 f7 ff ff       	call   802325 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  802b3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b41:	e8 df f7 ff ff       	call   802325 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802b46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b49:	89 04 24             	mov    %eax,(%esp)
  802b4c:	e8 13 ee ff ff       	call   801964 <_Z6fd2numP2Fd>
  802b51:	89 c3                	mov    %eax,%ebx
  802b53:	eb 30                	jmp    802b85 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802b55:	e8 cb f7 ff ff       	call   802325 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  802b5a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  802b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b62:	e8 be f7 ff ff       	call   802325 <_ZL11inode_closeP5Inode>
  802b67:	eb 05                	jmp    802b6e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802b69:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  802b6e:	a1 00 70 80 00       	mov    0x807000,%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b79:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b7d:	89 04 24             	mov    %eax,(%esp)
  802b80:	e8 98 e4 ff ff       	call   80101d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802b85:	89 d8                	mov    %ebx,%eax
  802b87:	83 c4 3c             	add    $0x3c,%esp
  802b8a:	5b                   	pop    %ebx
  802b8b:	5e                   	pop    %esi
  802b8c:	5f                   	pop    %edi
  802b8d:	5d                   	pop    %ebp
  802b8e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  802b8f:	83 f8 78             	cmp    $0x78,%eax
  802b92:	0f 85 1d fe ff ff    	jne    8029b5 <_Z4openPKci+0x67>
  802b98:	eb cf                	jmp    802b69 <_Z4openPKci+0x21b>

00802b9a <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  802b9a:	55                   	push   %ebp
  802b9b:	89 e5                	mov    %esp,%ebp
  802b9d:	53                   	push   %ebx
  802b9e:	83 ec 24             	sub    $0x24,%esp
  802ba1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802ba4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	e8 78 f5 ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	78 27                	js     802bda <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802bb3:	c7 44 24 04 5c 4b 80 	movl   $0x804b5c,0x4(%esp)
  802bba:	00 
  802bbb:	89 1c 24             	mov    %ebx,(%esp)
  802bbe:	e8 b7 de ff ff       	call   800a7a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802bc3:	89 da                	mov    %ebx,%edx
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	e8 26 f4 ff ff       	call   801ff3 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	e8 50 f7 ff ff       	call   802325 <_ZL11inode_closeP5Inode>
	return 0;
  802bd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bda:	83 c4 24             	add    $0x24,%esp
  802bdd:	5b                   	pop    %ebx
  802bde:	5d                   	pop    %ebp
  802bdf:	c3                   	ret    

00802be0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
  802be3:	53                   	push   %ebx
  802be4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802be7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bee:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802bf1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	e8 3a fb ff ff       	call   802736 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802bfc:	89 c3                	mov    %eax,%ebx
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	78 5f                	js     802c61 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802c02:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	e8 18 f5 ff ff       	call   802127 <_ZL10inode_openiPP5Inode>
  802c0f:	89 c3                	mov    %eax,%ebx
  802c11:	85 c0                	test   %eax,%eax
  802c13:	78 44                	js     802c59 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802c15:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	83 38 02             	cmpl   $0x2,(%eax)
  802c20:	74 2f                	je     802c51 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  802c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802c32:	ba 04 00 00 00       	mov    $0x4,%edx
  802c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3a:	e8 2c f4 ff ff       	call   80206b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  802c3f:	ba 04 00 00 00       	mov    $0x4,%edx
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	e8 1f f4 ff ff       	call   80206b <_ZL10bcache_ipcPvi>
	r = 0;
  802c4c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c54:	e8 cc f6 ff ff       	call   802325 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	e8 c4 f6 ff ff       	call   802325 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802c61:	89 d8                	mov    %ebx,%eax
  802c63:	83 c4 24             	add    $0x24,%esp
  802c66:	5b                   	pop    %ebx
  802c67:	5d                   	pop    %ebp
  802c68:	c3                   	ret    

00802c69 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802c69:	55                   	push   %ebp
  802c6a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c71:	5d                   	pop    %ebp
  802c72:	c3                   	ret    

00802c73 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802c73:	55                   	push   %ebp
  802c74:	89 e5                	mov    %esp,%ebp
  802c76:	57                   	push   %edi
  802c77:	56                   	push   %esi
  802c78:	53                   	push   %ebx
  802c79:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  802c7f:	c7 04 24 cd 23 80 00 	movl   $0x8023cd,(%esp)
  802c86:	e8 c0 14 00 00       	call   80414b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802c8b:	a1 00 10 00 50       	mov    0x50001000,%eax
  802c90:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802c95:	74 28                	je     802cbf <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802c97:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802c9e:	4a 
  802c9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ca3:	c7 44 24 08 c4 4b 80 	movl   $0x804bc4,0x8(%esp)
  802caa:	00 
  802cab:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802cb2:	00 
  802cb3:	c7 04 24 3e 4b 80 00 	movl   $0x804b3e,(%esp)
  802cba:	e8 89 d6 ff ff       	call   800348 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802cbf:	a1 04 10 00 50       	mov    0x50001004,%eax
  802cc4:	83 f8 03             	cmp    $0x3,%eax
  802cc7:	7f 1c                	jg     802ce5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802cc9:	c7 44 24 08 f8 4b 80 	movl   $0x804bf8,0x8(%esp)
  802cd0:	00 
  802cd1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802cd8:	00 
  802cd9:	c7 04 24 3e 4b 80 00 	movl   $0x804b3e,(%esp)
  802ce0:	e8 63 d6 ff ff       	call   800348 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802ce5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802ceb:	85 d2                	test   %edx,%edx
  802ced:	7f 1c                	jg     802d0b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802cef:	c7 44 24 08 28 4c 80 	movl   $0x804c28,0x8(%esp)
  802cf6:	00 
  802cf7:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802cfe:	00 
  802cff:	c7 04 24 3e 4b 80 00 	movl   $0x804b3e,(%esp)
  802d06:	e8 3d d6 ff ff       	call   800348 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802d0b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802d11:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802d17:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802d1d:	85 c9                	test   %ecx,%ecx
  802d1f:	0f 48 cb             	cmovs  %ebx,%ecx
  802d22:	c1 f9 0c             	sar    $0xc,%ecx
  802d25:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802d29:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802d2f:	39 c8                	cmp    %ecx,%eax
  802d31:	7c 13                	jl     802d46 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802d33:	85 c0                	test   %eax,%eax
  802d35:	7f 3d                	jg     802d74 <_Z4fsckv+0x101>
  802d37:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802d3e:	00 00 00 
  802d41:	e9 ac 00 00 00       	jmp    802df2 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802d46:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802d4c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802d50:	89 44 24 10          	mov    %eax,0x10(%esp)
  802d54:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802d58:	c7 44 24 08 58 4c 80 	movl   $0x804c58,0x8(%esp)
  802d5f:	00 
  802d60:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802d67:	00 
  802d68:	c7 04 24 3e 4b 80 00 	movl   $0x804b3e,(%esp)
  802d6f:	e8 d4 d5 ff ff       	call   800348 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802d74:	be 00 20 00 50       	mov    $0x50002000,%esi
  802d79:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802d80:	00 00 00 
  802d83:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d88:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802d8e:	39 df                	cmp    %ebx,%edi
  802d90:	7e 27                	jle    802db9 <_Z4fsckv+0x146>
  802d92:	0f b6 06             	movzbl (%esi),%eax
  802d95:	84 c0                	test   %al,%al
  802d97:	74 4b                	je     802de4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802d99:	0f be c0             	movsbl %al,%eax
  802d9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802da0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802da4:	c7 04 24 9c 4c 80 00 	movl   $0x804c9c,(%esp)
  802dab:	e8 b6 d6 ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  802db0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802db7:	eb 2b                	jmp    802de4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802db9:	0f b6 06             	movzbl (%esi),%eax
  802dbc:	3c 01                	cmp    $0x1,%al
  802dbe:	76 24                	jbe    802de4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802dc0:	0f be c0             	movsbl %al,%eax
  802dc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802dc7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802dcb:	c7 04 24 d0 4c 80 00 	movl   $0x804cd0,(%esp)
  802dd2:	e8 8f d6 ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  802dd7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802dde:	80 3e 00             	cmpb   $0x0,(%esi)
  802de1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802de4:	83 c3 01             	add    $0x1,%ebx
  802de7:	83 c6 01             	add    $0x1,%esi
  802dea:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802df0:	7f 9c                	jg     802d8e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802df2:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802df9:	0f 8e e1 02 00 00    	jle    8030e0 <_Z4fsckv+0x46d>
  802dff:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802e06:	00 00 00 
		struct Inode *ino = get_inode(i);
  802e09:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802e0f:	e8 f9 f1 ff ff       	call   80200d <_ZL9get_inodei>
  802e14:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  802e1a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  802e1e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802e25:	75 22                	jne    802e49 <_Z4fsckv+0x1d6>
  802e27:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  802e2e:	0f 84 a9 06 00 00    	je     8034dd <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802e34:	ba 00 00 00 00       	mov    $0x0,%edx
  802e39:	e8 2d f2 ff ff       	call   80206b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	74 3a                	je     802e7c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802e42:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802e49:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802e4f:	8b 02                	mov    (%edx),%eax
  802e51:	83 f8 01             	cmp    $0x1,%eax
  802e54:	74 26                	je     802e7c <_Z4fsckv+0x209>
  802e56:	83 f8 02             	cmp    $0x2,%eax
  802e59:	74 21                	je     802e7c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  802e5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e5f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802e65:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e69:	c7 04 24 fc 4c 80 00 	movl   $0x804cfc,(%esp)
  802e70:	e8 f1 d5 ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  802e75:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  802e7c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802e83:	75 3f                	jne    802ec4 <_Z4fsckv+0x251>
  802e85:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802e8b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802e8f:	75 15                	jne    802ea6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802e91:	c7 04 24 20 4d 80 00 	movl   $0x804d20,(%esp)
  802e98:	e8 c9 d5 ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  802e9d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ea4:	eb 1e                	jmp    802ec4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802ea6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802eac:	83 3a 02             	cmpl   $0x2,(%edx)
  802eaf:	74 13                	je     802ec4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802eb1:	c7 04 24 54 4d 80 00 	movl   $0x804d54,(%esp)
  802eb8:	e8 a9 d5 ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  802ebd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802ec4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802ec9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ed0:	0f 84 93 00 00 00    	je     802f69 <_Z4fsckv+0x2f6>
  802ed6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  802edc:	8b 41 08             	mov    0x8(%ecx),%eax
  802edf:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802ee4:	7e 23                	jle    802f09 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802ee6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802eea:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ef4:	c7 04 24 84 4d 80 00 	movl   $0x804d84,(%esp)
  802efb:	e8 66 d5 ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  802f00:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f07:	eb 09                	jmp    802f12 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802f09:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802f10:	74 4b                	je     802f5d <_Z4fsckv+0x2ea>
  802f12:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f18:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  802f1e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802f24:	74 23                	je     802f49 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802f26:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f2a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802f30:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f34:	c7 04 24 a8 4d 80 00 	movl   $0x804da8,(%esp)
  802f3b:	e8 26 d5 ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  802f40:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f47:	eb 09                	jmp    802f52 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802f49:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802f50:	74 12                	je     802f64 <_Z4fsckv+0x2f1>
  802f52:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802f58:	8b 78 08             	mov    0x8(%eax),%edi
  802f5b:	eb 0c                	jmp    802f69 <_Z4fsckv+0x2f6>
  802f5d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f62:	eb 05                	jmp    802f69 <_Z4fsckv+0x2f6>
  802f64:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802f69:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  802f6e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f74:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802f78:	89 d8                	mov    %ebx,%eax
  802f7a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802f7d:	39 c7                	cmp    %eax,%edi
  802f7f:	7e 2b                	jle    802fac <_Z4fsckv+0x339>
  802f81:	85 f6                	test   %esi,%esi
  802f83:	75 27                	jne    802fac <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802f85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f8d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802f93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f97:	c7 04 24 cc 4d 80 00 	movl   $0x804dcc,(%esp)
  802f9e:	e8 c3 d4 ff ff       	call   800466 <_Z7cprintfPKcz>
				++errors;
  802fa3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802faa:	eb 36                	jmp    802fe2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  802fac:	39 f8                	cmp    %edi,%eax
  802fae:	7c 32                	jl     802fe2 <_Z4fsckv+0x36f>
  802fb0:	85 f6                	test   %esi,%esi
  802fb2:	74 2e                	je     802fe2 <_Z4fsckv+0x36f>
  802fb4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802fbb:	74 25                	je     802fe2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  802fbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fc1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fc5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802fcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fcf:	c7 04 24 10 4e 80 00 	movl   $0x804e10,(%esp)
  802fd6:	e8 8b d4 ff ff       	call   800466 <_Z7cprintfPKcz>
				++errors;
  802fdb:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  802fe2:	85 f6                	test   %esi,%esi
  802fe4:	0f 84 a0 00 00 00    	je     80308a <_Z4fsckv+0x417>
  802fea:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802ff1:	0f 84 93 00 00 00    	je     80308a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  802ff7:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  802ffd:	7e 27                	jle    803026 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  802fff:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803003:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803007:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  80300d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803011:	c7 04 24 54 4e 80 00 	movl   $0x804e54,(%esp)
  803018:	e8 49 d4 ff ff       	call   800466 <_Z7cprintfPKcz>
					++errors;
  80301d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803024:	eb 64                	jmp    80308a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  803026:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80302d:	3c 01                	cmp    $0x1,%al
  80302f:	75 27                	jne    803058 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  803031:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803035:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803039:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  80303f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803043:	c7 04 24 98 4e 80 00 	movl   $0x804e98,(%esp)
  80304a:	e8 17 d4 ff ff       	call   800466 <_Z7cprintfPKcz>
					++errors;
  80304f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803056:	eb 32                	jmp    80308a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  803058:	3c ff                	cmp    $0xff,%al
  80305a:	75 27                	jne    803083 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  80305c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803060:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803064:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80306a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80306e:	c7 04 24 d4 4e 80 00 	movl   $0x804ed4,(%esp)
  803075:	e8 ec d3 ff ff       	call   800466 <_Z7cprintfPKcz>
					++errors;
  80307a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803081:	eb 07                	jmp    80308a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  803083:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  80308a:	83 c3 01             	add    $0x1,%ebx
  80308d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  803093:	0f 85 d5 fe ff ff    	jne    802f6e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  803099:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8030a0:	0f 94 c0             	sete   %al
  8030a3:	0f b6 c0             	movzbl %al,%eax
  8030a6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8030ac:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  8030b2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  8030b9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  8030c0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8030c7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  8030ce:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8030d4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  8030da:	0f 8f 29 fd ff ff    	jg     802e09 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8030e0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  8030e7:	0f 8e 7f 03 00 00    	jle    80346c <_Z4fsckv+0x7f9>
  8030ed:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  8030f2:	89 f0                	mov    %esi,%eax
  8030f4:	e8 14 ef ff ff       	call   80200d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  8030f9:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803100:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803107:	c1 e2 08             	shl    $0x8,%edx
  80310a:	09 ca                	or     %ecx,%edx
  80310c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803113:	c1 e1 10             	shl    $0x10,%ecx
  803116:	09 ca                	or     %ecx,%edx
  803118:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  80311f:	83 e1 7f             	and    $0x7f,%ecx
  803122:	c1 e1 18             	shl    $0x18,%ecx
  803125:	09 d1                	or     %edx,%ecx
  803127:	74 0e                	je     803137 <_Z4fsckv+0x4c4>
  803129:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803130:	78 05                	js     803137 <_Z4fsckv+0x4c4>
  803132:	83 38 02             	cmpl   $0x2,(%eax)
  803135:	74 1f                	je     803156 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803137:	83 c6 01             	add    $0x1,%esi
  80313a:	a1 08 10 00 50       	mov    0x50001008,%eax
  80313f:	39 f0                	cmp    %esi,%eax
  803141:	7f af                	jg     8030f2 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803143:	bb 01 00 00 00       	mov    $0x1,%ebx
  803148:	83 f8 01             	cmp    $0x1,%eax
  80314b:	0f 8f ad 02 00 00    	jg     8033fe <_Z4fsckv+0x78b>
  803151:	e9 16 03 00 00       	jmp    80346c <_Z4fsckv+0x7f9>
  803156:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  803158:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  80315f:	8b 40 08             	mov    0x8(%eax),%eax
  803162:	a8 7f                	test   $0x7f,%al
  803164:	74 23                	je     803189 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  803166:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  80316d:	00 
  80316e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803172:	89 74 24 04          	mov    %esi,0x4(%esp)
  803176:	c7 04 24 10 4f 80 00 	movl   $0x804f10,(%esp)
  80317d:	e8 e4 d2 ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  803182:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803189:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  803190:	00 00 00 
  803193:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  803199:	e9 3d 02 00 00       	jmp    8033db <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  80319e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8031a4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8031aa:	e8 01 ee ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
  8031af:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  8031b1:	83 38 00             	cmpl   $0x0,(%eax)
  8031b4:	0f 84 15 02 00 00    	je     8033cf <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8031c0:	83 fa 76             	cmp    $0x76,%edx
  8031c3:	76 27                	jbe    8031ec <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  8031c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031c9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8031cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031d7:	c7 04 24 44 4f 80 00 	movl   $0x804f44,(%esp)
  8031de:	e8 83 d2 ff ff       	call   800466 <_Z7cprintfPKcz>
				++errors;
  8031e3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8031ea:	eb 28                	jmp    803214 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  8031ec:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  8031f1:	74 21                	je     803214 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  8031f3:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8031f9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8031fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  803201:	c7 04 24 70 4f 80 00 	movl   $0x804f70,(%esp)
  803208:	e8 59 d2 ff ff       	call   800466 <_Z7cprintfPKcz>
				++errors;
  80320d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803214:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  80321b:	00 
  80321c:	8d 43 08             	lea    0x8(%ebx),%eax
  80321f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803223:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803229:	89 0c 24             	mov    %ecx,(%esp)
  80322c:	e8 66 da ff ff       	call   800c97 <memcpy>
  803231:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803235:	bf 77 00 00 00       	mov    $0x77,%edi
  80323a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80323e:	85 ff                	test   %edi,%edi
  803240:	b8 00 00 00 00       	mov    $0x0,%eax
  803245:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803248:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80324f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803250:	8b 03                	mov    (%ebx),%eax
  803252:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803258:	7c 3e                	jl     803298 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80325a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80325e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803264:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803268:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80326e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803272:	89 74 24 04          	mov    %esi,0x4(%esp)
  803276:	c7 04 24 a4 4f 80 00 	movl   $0x804fa4,(%esp)
  80327d:	e8 e4 d1 ff ff       	call   800466 <_Z7cprintfPKcz>
				++errors;
  803282:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803289:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  803290:	00 00 00 
  803293:	e9 0b 01 00 00       	jmp    8033a3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  803298:	e8 70 ed ff ff       	call   80200d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  80329d:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8032a4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  8032ab:	c1 e2 08             	shl    $0x8,%edx
  8032ae:	09 d1                	or     %edx,%ecx
  8032b0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  8032b7:	c1 e2 10             	shl    $0x10,%edx
  8032ba:	09 d1                	or     %edx,%ecx
  8032bc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  8032c3:	83 e2 7f             	and    $0x7f,%edx
  8032c6:	c1 e2 18             	shl    $0x18,%edx
  8032c9:	09 ca                	or     %ecx,%edx
  8032cb:	83 c2 01             	add    $0x1,%edx
  8032ce:	89 d1                	mov    %edx,%ecx
  8032d0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  8032d6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  8032dc:	0f b6 d5             	movzbl %ch,%edx
  8032df:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  8032e5:	89 ca                	mov    %ecx,%edx
  8032e7:	c1 ea 10             	shr    $0x10,%edx
  8032ea:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  8032f0:	c1 e9 18             	shr    $0x18,%ecx
  8032f3:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  8032fa:	83 e2 80             	and    $0xffffff80,%edx
  8032fd:	09 ca                	or     %ecx,%edx
  8032ff:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803305:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803309:	0f 85 7a ff ff ff    	jne    803289 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  80330f:	8b 03                	mov    (%ebx),%eax
  803311:	89 44 24 10          	mov    %eax,0x10(%esp)
  803315:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80331b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80331f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803325:	89 44 24 08          	mov    %eax,0x8(%esp)
  803329:	89 74 24 04          	mov    %esi,0x4(%esp)
  80332d:	c7 04 24 d4 4f 80 00 	movl   $0x804fd4,(%esp)
  803334:	e8 2d d1 ff ff       	call   800466 <_Z7cprintfPKcz>
					++errors;
  803339:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803340:	e9 44 ff ff ff       	jmp    803289 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803345:	3b 78 04             	cmp    0x4(%eax),%edi
  803348:	75 52                	jne    80339c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  80334a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80334e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803354:	89 54 24 04          	mov    %edx,0x4(%esp)
  803358:	83 c0 08             	add    $0x8,%eax
  80335b:	89 04 24             	mov    %eax,(%esp)
  80335e:	e8 75 d9 ff ff       	call   800cd8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803363:	85 c0                	test   %eax,%eax
  803365:	75 35                	jne    80339c <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  803367:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80336d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803371:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803377:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80337b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803381:	89 54 24 08          	mov    %edx,0x8(%esp)
  803385:	89 74 24 04          	mov    %esi,0x4(%esp)
  803389:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  803390:	e8 d1 d0 ff ff       	call   800466 <_Z7cprintfPKcz>
					++errors;
  803395:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80339c:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  8033a3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8033a9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  8033af:	7e 1e                	jle    8033cf <_Z4fsckv+0x75c>
  8033b1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  8033b5:	7f 18                	jg     8033cf <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  8033b7:	89 ca                	mov    %ecx,%edx
  8033b9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8033bf:	e8 ec eb ff ff       	call   801fb0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  8033c4:	83 38 00             	cmpl   $0x0,(%eax)
  8033c7:	0f 85 78 ff ff ff    	jne    803345 <_Z4fsckv+0x6d2>
  8033cd:	eb cd                	jmp    80339c <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  8033cf:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8033d5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8033db:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8033e1:	83 ea 80             	sub    $0xffffff80,%edx
  8033e4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  8033ea:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8033f0:	3b 51 08             	cmp    0x8(%ecx),%edx
  8033f3:	0f 8f e7 fc ff ff    	jg     8030e0 <_Z4fsckv+0x46d>
  8033f9:	e9 a0 fd ff ff       	jmp    80319e <_Z4fsckv+0x52b>
  8033fe:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803404:	89 d8                	mov    %ebx,%eax
  803406:	e8 02 ec ff ff       	call   80200d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  80340b:	8b 50 04             	mov    0x4(%eax),%edx
  80340e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803415:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80341c:	c1 e7 08             	shl    $0x8,%edi
  80341f:	09 f9                	or     %edi,%ecx
  803421:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803428:	c1 e7 10             	shl    $0x10,%edi
  80342b:	09 f9                	or     %edi,%ecx
  80342d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803434:	83 e7 7f             	and    $0x7f,%edi
  803437:	c1 e7 18             	shl    $0x18,%edi
  80343a:	09 f9                	or     %edi,%ecx
  80343c:	39 ca                	cmp    %ecx,%edx
  80343e:	74 1b                	je     80345b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803440:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803444:	89 54 24 08          	mov    %edx,0x8(%esp)
  803448:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80344c:	c7 04 24 34 50 80 00 	movl   $0x805034,(%esp)
  803453:	e8 0e d0 ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  803458:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80345b:	83 c3 01             	add    $0x1,%ebx
  80345e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  803464:	7f 9e                	jg     803404 <_Z4fsckv+0x791>
  803466:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  80346c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  803473:	7e 4f                	jle    8034c4 <_Z4fsckv+0x851>
  803475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80347a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  803480:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  803487:	3c ff                	cmp    $0xff,%al
  803489:	75 09                	jne    803494 <_Z4fsckv+0x821>
			freemap[i] = 0;
  80348b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803492:	eb 1f                	jmp    8034b3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803494:	84 c0                	test   %al,%al
  803496:	75 1b                	jne    8034b3 <_Z4fsckv+0x840>
  803498:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  80349e:	7c 13                	jl     8034b3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  8034a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8034a4:	c7 04 24 60 50 80 00 	movl   $0x805060,(%esp)
  8034ab:	e8 b6 cf ff ff       	call   800466 <_Z7cprintfPKcz>
			++errors;
  8034b0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8034b3:	83 c3 01             	add    $0x1,%ebx
  8034b6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8034bc:	7f c2                	jg     803480 <_Z4fsckv+0x80d>
  8034be:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  8034c4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  8034cb:	19 c0                	sbb    %eax,%eax
  8034cd:	f7 d0                	not    %eax
  8034cf:	83 e0 fd             	and    $0xfffffffd,%eax
}
  8034d2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  8034d8:	5b                   	pop    %ebx
  8034d9:	5e                   	pop    %esi
  8034da:	5f                   	pop    %edi
  8034db:	5d                   	pop    %ebp
  8034dc:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  8034dd:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8034e4:	0f 84 92 f9 ff ff    	je     802e7c <_Z4fsckv+0x209>
  8034ea:	e9 5a f9 ff ff       	jmp    802e49 <_Z4fsckv+0x1d6>
	...

008034f0 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8034f0:	55                   	push   %ebp
  8034f1:	89 e5                	mov    %esp,%ebp
  8034f3:	83 ec 18             	sub    $0x18,%esp
  8034f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8034f9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8034fc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	89 04 24             	mov    %eax,(%esp)
  803505:	e8 a2 e4 ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  80350a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80350c:	c7 44 24 04 93 50 80 	movl   $0x805093,0x4(%esp)
  803513:	00 
  803514:	89 34 24             	mov    %esi,(%esp)
  803517:	e8 5e d5 ff ff       	call   800a7a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80351c:	8b 43 04             	mov    0x4(%ebx),%eax
  80351f:	2b 03                	sub    (%ebx),%eax
  803521:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803524:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80352b:	c7 86 80 00 00 00 20 	movl   $0x806020,0x80(%esi)
  803532:	60 80 00 
	return 0;
}
  803535:	b8 00 00 00 00       	mov    $0x0,%eax
  80353a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80353d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803540:	89 ec                	mov    %ebp,%esp
  803542:	5d                   	pop    %ebp
  803543:	c3                   	ret    

00803544 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803544:	55                   	push   %ebp
  803545:	89 e5                	mov    %esp,%ebp
  803547:	53                   	push   %ebx
  803548:	83 ec 14             	sub    $0x14,%esp
  80354b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80354e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803552:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803559:	e8 bf da ff ff       	call   80101d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80355e:	89 1c 24             	mov    %ebx,(%esp)
  803561:	e8 46 e4 ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  803566:	89 44 24 04          	mov    %eax,0x4(%esp)
  80356a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803571:	e8 a7 da ff ff       	call   80101d <_Z14sys_page_unmapiPv>
}
  803576:	83 c4 14             	add    $0x14,%esp
  803579:	5b                   	pop    %ebx
  80357a:	5d                   	pop    %ebp
  80357b:	c3                   	ret    

0080357c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80357c:	55                   	push   %ebp
  80357d:	89 e5                	mov    %esp,%ebp
  80357f:	57                   	push   %edi
  803580:	56                   	push   %esi
  803581:	53                   	push   %ebx
  803582:	83 ec 2c             	sub    $0x2c,%esp
  803585:	89 c7                	mov    %eax,%edi
  803587:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80358a:	a1 00 70 80 00       	mov    0x807000,%eax
  80358f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  803592:	89 3c 24             	mov    %edi,(%esp)
  803595:	e8 82 04 00 00       	call   803a1c <_Z7pagerefPv>
  80359a:	89 c3                	mov    %eax,%ebx
  80359c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359f:	89 04 24             	mov    %eax,(%esp)
  8035a2:	e8 75 04 00 00       	call   803a1c <_Z7pagerefPv>
  8035a7:	39 c3                	cmp    %eax,%ebx
  8035a9:	0f 94 c0             	sete   %al
  8035ac:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  8035af:	8b 15 00 70 80 00    	mov    0x807000,%edx
  8035b5:	8b 52 58             	mov    0x58(%edx),%edx
  8035b8:	39 d6                	cmp    %edx,%esi
  8035ba:	75 08                	jne    8035c4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  8035bc:	83 c4 2c             	add    $0x2c,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5f                   	pop    %edi
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  8035c4:	85 c0                	test   %eax,%eax
  8035c6:	74 c2                	je     80358a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  8035c8:	c7 04 24 9a 50 80 00 	movl   $0x80509a,(%esp)
  8035cf:	e8 92 ce ff ff       	call   800466 <_Z7cprintfPKcz>
  8035d4:	eb b4                	jmp    80358a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

008035d6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
  8035d9:	57                   	push   %edi
  8035da:	56                   	push   %esi
  8035db:	53                   	push   %ebx
  8035dc:	83 ec 1c             	sub    $0x1c,%esp
  8035df:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8035e2:	89 34 24             	mov    %esi,(%esp)
  8035e5:	e8 c2 e3 ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  8035ea:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8035ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8035f5:	75 46                	jne    80363d <_ZL13devpipe_writeP2FdPKvj+0x67>
  8035f7:	eb 52                	jmp    80364b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  8035f9:	89 da                	mov    %ebx,%edx
  8035fb:	89 f0                	mov    %esi,%eax
  8035fd:	e8 7a ff ff ff       	call   80357c <_ZL13_pipeisclosedP2FdP4Pipe>
  803602:	85 c0                	test   %eax,%eax
  803604:	75 49                	jne    80364f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803606:	e8 21 d9 ff ff       	call   800f2c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80360b:	8b 43 04             	mov    0x4(%ebx),%eax
  80360e:	89 c2                	mov    %eax,%edx
  803610:	2b 13                	sub    (%ebx),%edx
  803612:	83 fa 20             	cmp    $0x20,%edx
  803615:	74 e2                	je     8035f9 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803617:	89 c2                	mov    %eax,%edx
  803619:	c1 fa 1f             	sar    $0x1f,%edx
  80361c:	c1 ea 1b             	shr    $0x1b,%edx
  80361f:	01 d0                	add    %edx,%eax
  803621:	83 e0 1f             	and    $0x1f,%eax
  803624:	29 d0                	sub    %edx,%eax
  803626:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803629:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80362d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803631:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803635:	83 c7 01             	add    $0x1,%edi
  803638:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80363b:	76 0e                	jbe    80364b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80363d:	8b 43 04             	mov    0x4(%ebx),%eax
  803640:	89 c2                	mov    %eax,%edx
  803642:	2b 13                	sub    (%ebx),%edx
  803644:	83 fa 20             	cmp    $0x20,%edx
  803647:	74 b0                	je     8035f9 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803649:	eb cc                	jmp    803617 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80364b:	89 f8                	mov    %edi,%eax
  80364d:	eb 05                	jmp    803654 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80364f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803654:	83 c4 1c             	add    $0x1c,%esp
  803657:	5b                   	pop    %ebx
  803658:	5e                   	pop    %esi
  803659:	5f                   	pop    %edi
  80365a:	5d                   	pop    %ebp
  80365b:	c3                   	ret    

0080365c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80365c:	55                   	push   %ebp
  80365d:	89 e5                	mov    %esp,%ebp
  80365f:	83 ec 28             	sub    $0x28,%esp
  803662:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803665:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803668:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80366b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80366e:	89 3c 24             	mov    %edi,(%esp)
  803671:	e8 36 e3 ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  803676:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803678:	be 00 00 00 00       	mov    $0x0,%esi
  80367d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803681:	75 47                	jne    8036ca <_ZL12devpipe_readP2FdPvj+0x6e>
  803683:	eb 52                	jmp    8036d7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803685:	89 f0                	mov    %esi,%eax
  803687:	eb 5e                	jmp    8036e7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803689:	89 da                	mov    %ebx,%edx
  80368b:	89 f8                	mov    %edi,%eax
  80368d:	8d 76 00             	lea    0x0(%esi),%esi
  803690:	e8 e7 fe ff ff       	call   80357c <_ZL13_pipeisclosedP2FdP4Pipe>
  803695:	85 c0                	test   %eax,%eax
  803697:	75 49                	jne    8036e2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803699:	e8 8e d8 ff ff       	call   800f2c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80369e:	8b 03                	mov    (%ebx),%eax
  8036a0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8036a3:	74 e4                	je     803689 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036a5:	89 c2                	mov    %eax,%edx
  8036a7:	c1 fa 1f             	sar    $0x1f,%edx
  8036aa:	c1 ea 1b             	shr    $0x1b,%edx
  8036ad:	01 d0                	add    %edx,%eax
  8036af:	83 e0 1f             	and    $0x1f,%eax
  8036b2:	29 d0                	sub    %edx,%eax
  8036b4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8036b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036bc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8036bf:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8036c2:	83 c6 01             	add    $0x1,%esi
  8036c5:	39 75 10             	cmp    %esi,0x10(%ebp)
  8036c8:	76 0d                	jbe    8036d7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8036ca:	8b 03                	mov    (%ebx),%eax
  8036cc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8036cf:	75 d4                	jne    8036a5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8036d1:	85 f6                	test   %esi,%esi
  8036d3:	75 b0                	jne    803685 <_ZL12devpipe_readP2FdPvj+0x29>
  8036d5:	eb b2                	jmp    803689 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8036d7:	89 f0                	mov    %esi,%eax
  8036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8036e0:	eb 05                	jmp    8036e7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8036e2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8036e7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8036ea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8036ed:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8036f0:	89 ec                	mov    %ebp,%esp
  8036f2:	5d                   	pop    %ebp
  8036f3:	c3                   	ret    

008036f4 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8036f4:	55                   	push   %ebp
  8036f5:	89 e5                	mov    %esp,%ebp
  8036f7:	83 ec 48             	sub    $0x48,%esp
  8036fa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8036fd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803700:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803703:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803706:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803709:	89 04 24             	mov    %eax,(%esp)
  80370c:	e8 b6 e2 ff ff       	call   8019c7 <_Z14fd_find_unusedPP2Fd>
  803711:	89 c3                	mov    %eax,%ebx
  803713:	85 c0                	test   %eax,%eax
  803715:	0f 88 0b 01 00 00    	js     803826 <_Z4pipePi+0x132>
  80371b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803722:	00 
  803723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803726:	89 44 24 04          	mov    %eax,0x4(%esp)
  80372a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803731:	e8 2a d8 ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  803736:	89 c3                	mov    %eax,%ebx
  803738:	85 c0                	test   %eax,%eax
  80373a:	0f 89 f5 00 00 00    	jns    803835 <_Z4pipePi+0x141>
  803740:	e9 e1 00 00 00       	jmp    803826 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803745:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80374c:	00 
  80374d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803750:	89 44 24 04          	mov    %eax,0x4(%esp)
  803754:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80375b:	e8 00 d8 ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  803760:	89 c3                	mov    %eax,%ebx
  803762:	85 c0                	test   %eax,%eax
  803764:	0f 89 e2 00 00 00    	jns    80384c <_Z4pipePi+0x158>
  80376a:	e9 a4 00 00 00       	jmp    803813 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80376f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803772:	89 04 24             	mov    %eax,(%esp)
  803775:	e8 32 e2 ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  80377a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803781:	00 
  803782:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803786:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80378d:	00 
  80378e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803792:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803799:	e8 21 d8 ff ff       	call   800fbf <_Z12sys_page_mapiPviS_i>
  80379e:	89 c3                	mov    %eax,%ebx
  8037a0:	85 c0                	test   %eax,%eax
  8037a2:	78 4c                	js     8037f0 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037a4:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8037aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8037af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037b9:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8037bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8037c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8037ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d1:	89 04 24             	mov    %eax,(%esp)
  8037d4:	e8 8b e1 ff ff       	call   801964 <_Z6fd2numP2Fd>
  8037d9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8037db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037de:	89 04 24             	mov    %eax,(%esp)
  8037e1:	e8 7e e1 ff ff       	call   801964 <_Z6fd2numP2Fd>
  8037e6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8037e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8037ee:	eb 36                	jmp    803826 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  8037f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8037f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037fb:	e8 1d d8 ff ff       	call   80101d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803800:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803803:	89 44 24 04          	mov    %eax,0x4(%esp)
  803807:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80380e:	e8 0a d8 ff ff       	call   80101d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803816:	89 44 24 04          	mov    %eax,0x4(%esp)
  80381a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803821:	e8 f7 d7 ff ff       	call   80101d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803826:	89 d8                	mov    %ebx,%eax
  803828:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80382b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80382e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803831:	89 ec                	mov    %ebp,%esp
  803833:	5d                   	pop    %ebp
  803834:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803835:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803838:	89 04 24             	mov    %eax,(%esp)
  80383b:	e8 87 e1 ff ff       	call   8019c7 <_Z14fd_find_unusedPP2Fd>
  803840:	89 c3                	mov    %eax,%ebx
  803842:	85 c0                	test   %eax,%eax
  803844:	0f 89 fb fe ff ff    	jns    803745 <_Z4pipePi+0x51>
  80384a:	eb c7                	jmp    803813 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80384c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384f:	89 04 24             	mov    %eax,(%esp)
  803852:	e8 55 e1 ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  803857:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803859:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803860:	00 
  803861:	89 44 24 04          	mov    %eax,0x4(%esp)
  803865:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80386c:	e8 ef d6 ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  803871:	89 c3                	mov    %eax,%ebx
  803873:	85 c0                	test   %eax,%eax
  803875:	0f 89 f4 fe ff ff    	jns    80376f <_Z4pipePi+0x7b>
  80387b:	eb 83                	jmp    803800 <_Z4pipePi+0x10c>

0080387d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80387d:	55                   	push   %ebp
  80387e:	89 e5                	mov    %esp,%ebp
  803880:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803883:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80388a:	00 
  80388b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80388e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803892:	8b 45 08             	mov    0x8(%ebp),%eax
  803895:	89 04 24             	mov    %eax,(%esp)
  803898:	e8 74 e0 ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  80389d:	85 c0                	test   %eax,%eax
  80389f:	78 15                	js     8038b6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8038a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a4:	89 04 24             	mov    %eax,(%esp)
  8038a7:	e8 00 e1 ff ff       	call   8019ac <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  8038ac:	89 c2                	mov    %eax,%edx
  8038ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b1:	e8 c6 fc ff ff       	call   80357c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8038b6:	c9                   	leave  
  8038b7:	c3                   	ret    

008038b8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8038b8:	55                   	push   %ebp
  8038b9:	89 e5                	mov    %esp,%ebp
  8038bb:	53                   	push   %ebx
  8038bc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8038bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8038c2:	89 04 24             	mov    %eax,(%esp)
  8038c5:	e8 fd e0 ff ff       	call   8019c7 <_Z14fd_find_unusedPP2Fd>
  8038ca:	89 c3                	mov    %eax,%ebx
  8038cc:	85 c0                	test   %eax,%eax
  8038ce:	0f 88 be 00 00 00    	js     803992 <_Z18pipe_ipc_recv_readv+0xda>
  8038d4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8038db:	00 
  8038dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038ea:	e8 71 d6 ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  8038ef:	89 c3                	mov    %eax,%ebx
  8038f1:	85 c0                	test   %eax,%eax
  8038f3:	0f 89 a1 00 00 00    	jns    80399a <_Z18pipe_ipc_recv_readv+0xe2>
  8038f9:	e9 94 00 00 00       	jmp    803992 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  8038fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803901:	85 c0                	test   %eax,%eax
  803903:	75 0e                	jne    803913 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803905:	c7 04 24 f4 50 80 00 	movl   $0x8050f4,(%esp)
  80390c:	e8 55 cb ff ff       	call   800466 <_Z7cprintfPKcz>
  803911:	eb 10                	jmp    803923 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803913:	89 44 24 04          	mov    %eax,0x4(%esp)
  803917:	c7 04 24 ad 50 80 00 	movl   $0x8050ad,(%esp)
  80391e:	e8 43 cb ff ff       	call   800466 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803923:	c7 04 24 b7 50 80 00 	movl   $0x8050b7,(%esp)
  80392a:	e8 37 cb ff ff       	call   800466 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80392f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803932:	a8 04                	test   $0x4,%al
  803934:	74 04                	je     80393a <_Z18pipe_ipc_recv_readv+0x82>
  803936:	a8 01                	test   $0x1,%al
  803938:	75 24                	jne    80395e <_Z18pipe_ipc_recv_readv+0xa6>
  80393a:	c7 44 24 0c ca 50 80 	movl   $0x8050ca,0xc(%esp)
  803941:	00 
  803942:	c7 44 24 08 94 4a 80 	movl   $0x804a94,0x8(%esp)
  803949:	00 
  80394a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803951:	00 
  803952:	c7 04 24 e7 50 80 00 	movl   $0x8050e7,(%esp)
  803959:	e8 ea c9 ff ff       	call   800348 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80395e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  803964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803967:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803973:	89 04 24             	mov    %eax,(%esp)
  803976:	e8 e9 df ff ff       	call   801964 <_Z6fd2numP2Fd>
  80397b:	89 c3                	mov    %eax,%ebx
  80397d:	eb 13                	jmp    803992 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803982:	89 44 24 04          	mov    %eax,0x4(%esp)
  803986:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80398d:	e8 8b d6 ff ff       	call   80101d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803992:	89 d8                	mov    %ebx,%eax
  803994:	83 c4 24             	add    $0x24,%esp
  803997:	5b                   	pop    %ebx
  803998:	5d                   	pop    %ebp
  803999:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  80399a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399d:	89 04 24             	mov    %eax,(%esp)
  8039a0:	e8 07 e0 ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  8039a5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8039a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8039ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8039b3:	89 04 24             	mov    %eax,(%esp)
  8039b6:	e8 85 08 00 00       	call   804240 <_Z8ipc_recvPiPvS_>
  8039bb:	89 c3                	mov    %eax,%ebx
  8039bd:	85 c0                	test   %eax,%eax
  8039bf:	0f 89 39 ff ff ff    	jns    8038fe <_Z18pipe_ipc_recv_readv+0x46>
  8039c5:	eb b8                	jmp    80397f <_Z18pipe_ipc_recv_readv+0xc7>

008039c7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  8039c7:	55                   	push   %ebp
  8039c8:	89 e5                	mov    %esp,%ebp
  8039ca:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  8039cd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8039d4:	00 
  8039d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8039d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039df:	89 04 24             	mov    %eax,(%esp)
  8039e2:	e8 2a df ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  8039e7:	85 c0                	test   %eax,%eax
  8039e9:	78 2f                	js     803a1a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  8039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ee:	89 04 24             	mov    %eax,(%esp)
  8039f1:	e8 b6 df ff ff       	call   8019ac <_Z7fd2dataP2Fd>
  8039f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8039fd:	00 
  8039fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803a09:	00 
  803a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0d:	89 04 24             	mov    %eax,(%esp)
  803a10:	e8 ba 08 00 00       	call   8042cf <_Z8ipc_sendijPvi>
    return 0;
  803a15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a1a:	c9                   	leave  
  803a1b:	c3                   	ret    

00803a1c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a1c:	55                   	push   %ebp
  803a1d:	89 e5                	mov    %esp,%ebp
  803a1f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803a22:	89 d0                	mov    %edx,%eax
  803a24:	c1 e8 16             	shr    $0x16,%eax
  803a27:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  803a2e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803a33:	f6 c1 01             	test   $0x1,%cl
  803a36:	74 1d                	je     803a55 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803a38:	c1 ea 0c             	shr    $0xc,%edx
  803a3b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803a42:	f6 c2 01             	test   $0x1,%dl
  803a45:	74 0e                	je     803a55 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803a47:	c1 ea 0c             	shr    $0xc,%edx
  803a4a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803a51:	ef 
  803a52:	0f b7 c0             	movzwl %ax,%eax
}
  803a55:	5d                   	pop    %ebp
  803a56:	c3                   	ret    
	...

00803a60 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a60:	55                   	push   %ebp
  803a61:	89 e5                	mov    %esp,%ebp
  803a63:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803a66:	c7 44 24 04 17 51 80 	movl   $0x805117,0x4(%esp)
  803a6d:	00 
  803a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a71:	89 04 24             	mov    %eax,(%esp)
  803a74:	e8 01 d0 ff ff       	call   800a7a <_Z6strcpyPcPKc>
	return 0;
}
  803a79:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7e:	c9                   	leave  
  803a7f:	c3                   	ret    

00803a80 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803a80:	55                   	push   %ebp
  803a81:	89 e5                	mov    %esp,%ebp
  803a83:	53                   	push   %ebx
  803a84:	83 ec 14             	sub    $0x14,%esp
  803a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803a8a:	89 1c 24             	mov    %ebx,(%esp)
  803a8d:	e8 8a ff ff ff       	call   803a1c <_Z7pagerefPv>
  803a92:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803a94:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803a99:	83 fa 01             	cmp    $0x1,%edx
  803a9c:	75 0b                	jne    803aa9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  803a9e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803aa1:	89 04 24             	mov    %eax,(%esp)
  803aa4:	e8 fe 02 00 00       	call   803da7 <_Z11nsipc_closei>
	else
		return 0;
}
  803aa9:	83 c4 14             	add    $0x14,%esp
  803aac:	5b                   	pop    %ebx
  803aad:	5d                   	pop    %ebp
  803aae:	c3                   	ret    

00803aaf <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803aaf:	55                   	push   %ebp
  803ab0:	89 e5                	mov    %esp,%ebp
  803ab2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803ab5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803abc:	00 
  803abd:	8b 45 10             	mov    0x10(%ebp),%eax
  803ac0:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  803acb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ace:	8b 40 0c             	mov    0xc(%eax),%eax
  803ad1:	89 04 24             	mov    %eax,(%esp)
  803ad4:	e8 c9 03 00 00       	call   803ea2 <_Z10nsipc_sendiPKvij>
}
  803ad9:	c9                   	leave  
  803ada:	c3                   	ret    

00803adb <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803adb:	55                   	push   %ebp
  803adc:	89 e5                	mov    %esp,%ebp
  803ade:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803ae1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803ae8:	00 
  803ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  803aec:	89 44 24 08          	mov    %eax,0x8(%esp)
  803af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  803af7:	8b 45 08             	mov    0x8(%ebp),%eax
  803afa:	8b 40 0c             	mov    0xc(%eax),%eax
  803afd:	89 04 24             	mov    %eax,(%esp)
  803b00:	e8 1d 03 00 00       	call   803e22 <_Z10nsipc_recviPvij>
}
  803b05:	c9                   	leave  
  803b06:	c3                   	ret    

00803b07 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803b07:	55                   	push   %ebp
  803b08:	89 e5                	mov    %esp,%ebp
  803b0a:	83 ec 28             	sub    $0x28,%esp
  803b0d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803b10:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803b13:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803b15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803b18:	89 04 24             	mov    %eax,(%esp)
  803b1b:	e8 a7 de ff ff       	call   8019c7 <_Z14fd_find_unusedPP2Fd>
  803b20:	89 c3                	mov    %eax,%ebx
  803b22:	85 c0                	test   %eax,%eax
  803b24:	78 21                	js     803b47 <_ZL12alloc_sockfdi+0x40>
  803b26:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803b2d:	00 
  803b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b3c:	e8 1f d4 ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  803b41:	89 c3                	mov    %eax,%ebx
  803b43:	85 c0                	test   %eax,%eax
  803b45:	79 14                	jns    803b5b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803b47:	89 34 24             	mov    %esi,(%esp)
  803b4a:	e8 58 02 00 00       	call   803da7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803b4f:	89 d8                	mov    %ebx,%eax
  803b51:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803b54:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803b57:	89 ec                	mov    %ebp,%esp
  803b59:	5d                   	pop    %ebp
  803b5a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803b5b:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  803b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b64:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b69:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803b70:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803b73:	89 04 24             	mov    %eax,(%esp)
  803b76:	e8 e9 dd ff ff       	call   801964 <_Z6fd2numP2Fd>
  803b7b:	89 c3                	mov    %eax,%ebx
  803b7d:	eb d0                	jmp    803b4f <_ZL12alloc_sockfdi+0x48>

00803b7f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803b7f:	55                   	push   %ebp
  803b80:	89 e5                	mov    %esp,%ebp
  803b82:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803b85:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803b8c:	00 
  803b8d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803b90:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b94:	89 04 24             	mov    %eax,(%esp)
  803b97:	e8 75 dd ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  803b9c:	85 c0                	test   %eax,%eax
  803b9e:	78 15                	js     803bb5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803ba0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803ba3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803ba8:	8b 0d 3c 60 80 00    	mov    0x80603c,%ecx
  803bae:	39 0a                	cmp    %ecx,(%edx)
  803bb0:	75 03                	jne    803bb5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803bb2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803bb5:	c9                   	leave  
  803bb6:	c3                   	ret    

00803bb7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803bb7:	55                   	push   %ebp
  803bb8:	89 e5                	mov    %esp,%ebp
  803bba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc0:	e8 ba ff ff ff       	call   803b7f <_ZL9fd2sockidi>
  803bc5:	85 c0                	test   %eax,%eax
  803bc7:	78 1f                	js     803be8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803bc9:	8b 55 10             	mov    0x10(%ebp),%edx
  803bcc:	89 54 24 08          	mov    %edx,0x8(%esp)
  803bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803bd3:	89 54 24 04          	mov    %edx,0x4(%esp)
  803bd7:	89 04 24             	mov    %eax,(%esp)
  803bda:	e8 19 01 00 00       	call   803cf8 <_Z12nsipc_acceptiP8sockaddrPj>
  803bdf:	85 c0                	test   %eax,%eax
  803be1:	78 05                	js     803be8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803be3:	e8 1f ff ff ff       	call   803b07 <_ZL12alloc_sockfdi>
}
  803be8:	c9                   	leave  
  803be9:	c3                   	ret    

00803bea <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803bea:	55                   	push   %ebp
  803beb:	89 e5                	mov    %esp,%ebp
  803bed:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf3:	e8 87 ff ff ff       	call   803b7f <_ZL9fd2sockidi>
  803bf8:	85 c0                	test   %eax,%eax
  803bfa:	78 16                	js     803c12 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803bfc:	8b 55 10             	mov    0x10(%ebp),%edx
  803bff:	89 54 24 08          	mov    %edx,0x8(%esp)
  803c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c06:	89 54 24 04          	mov    %edx,0x4(%esp)
  803c0a:	89 04 24             	mov    %eax,(%esp)
  803c0d:	e8 34 01 00 00       	call   803d46 <_Z10nsipc_bindiP8sockaddrj>
}
  803c12:	c9                   	leave  
  803c13:	c3                   	ret    

00803c14 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803c14:	55                   	push   %ebp
  803c15:	89 e5                	mov    %esp,%ebp
  803c17:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1d:	e8 5d ff ff ff       	call   803b7f <_ZL9fd2sockidi>
  803c22:	85 c0                	test   %eax,%eax
  803c24:	78 0f                	js     803c35 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803c26:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c29:	89 54 24 04          	mov    %edx,0x4(%esp)
  803c2d:	89 04 24             	mov    %eax,(%esp)
  803c30:	e8 50 01 00 00       	call   803d85 <_Z14nsipc_shutdownii>
}
  803c35:	c9                   	leave  
  803c36:	c3                   	ret    

00803c37 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c37:	55                   	push   %ebp
  803c38:	89 e5                	mov    %esp,%ebp
  803c3a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c40:	e8 3a ff ff ff       	call   803b7f <_ZL9fd2sockidi>
  803c45:	85 c0                	test   %eax,%eax
  803c47:	78 16                	js     803c5f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803c49:	8b 55 10             	mov    0x10(%ebp),%edx
  803c4c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c53:	89 54 24 04          	mov    %edx,0x4(%esp)
  803c57:	89 04 24             	mov    %eax,(%esp)
  803c5a:	e8 62 01 00 00       	call   803dc1 <_Z13nsipc_connectiPK8sockaddrj>
}
  803c5f:	c9                   	leave  
  803c60:	c3                   	ret    

00803c61 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803c61:	55                   	push   %ebp
  803c62:	89 e5                	mov    %esp,%ebp
  803c64:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c67:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6a:	e8 10 ff ff ff       	call   803b7f <_ZL9fd2sockidi>
  803c6f:	85 c0                	test   %eax,%eax
  803c71:	78 0f                	js     803c82 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c76:	89 54 24 04          	mov    %edx,0x4(%esp)
  803c7a:	89 04 24             	mov    %eax,(%esp)
  803c7d:	e8 7e 01 00 00       	call   803e00 <_Z12nsipc_listenii>
}
  803c82:	c9                   	leave  
  803c83:	c3                   	ret    

00803c84 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803c84:	55                   	push   %ebp
  803c85:	89 e5                	mov    %esp,%ebp
  803c87:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803c8a:	8b 45 10             	mov    0x10(%ebp),%eax
  803c8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c98:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9b:	89 04 24             	mov    %eax,(%esp)
  803c9e:	e8 72 02 00 00       	call   803f15 <_Z12nsipc_socketiii>
  803ca3:	85 c0                	test   %eax,%eax
  803ca5:	78 05                	js     803cac <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803ca7:	e8 5b fe ff ff       	call   803b07 <_ZL12alloc_sockfdi>
}
  803cac:	c9                   	leave  
  803cad:	8d 76 00             	lea    0x0(%esi),%esi
  803cb0:	c3                   	ret    
  803cb1:	00 00                	add    %al,(%eax)
	...

00803cb4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803cb4:	55                   	push   %ebp
  803cb5:	89 e5                	mov    %esp,%ebp
  803cb7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803cba:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803cc1:	00 
  803cc2:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803cc9:	00 
  803cca:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cce:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803cd5:	e8 f5 05 00 00       	call   8042cf <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803cda:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803ce1:	00 
  803ce2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803ce9:	00 
  803cea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803cf1:	e8 4a 05 00 00       	call   804240 <_Z8ipc_recvPiPvS_>
}
  803cf6:	c9                   	leave  
  803cf7:	c3                   	ret    

00803cf8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803cf8:	55                   	push   %ebp
  803cf9:	89 e5                	mov    %esp,%ebp
  803cfb:	53                   	push   %ebx
  803cfc:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803cff:	8b 45 08             	mov    0x8(%ebp),%eax
  803d02:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803d07:	b8 01 00 00 00       	mov    $0x1,%eax
  803d0c:	e8 a3 ff ff ff       	call   803cb4 <_ZL5nsipcj>
  803d11:	89 c3                	mov    %eax,%ebx
  803d13:	85 c0                	test   %eax,%eax
  803d15:	78 27                	js     803d3e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803d17:	a1 10 80 80 00       	mov    0x808010,%eax
  803d1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803d20:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803d27:	00 
  803d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d2b:	89 04 24             	mov    %eax,(%esp)
  803d2e:	e8 e9 ce ff ff       	call   800c1c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803d33:	8b 15 10 80 80 00    	mov    0x808010,%edx
  803d39:	8b 45 10             	mov    0x10(%ebp),%eax
  803d3c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803d3e:	89 d8                	mov    %ebx,%eax
  803d40:	83 c4 14             	add    $0x14,%esp
  803d43:	5b                   	pop    %ebx
  803d44:	5d                   	pop    %ebp
  803d45:	c3                   	ret    

00803d46 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803d46:	55                   	push   %ebp
  803d47:	89 e5                	mov    %esp,%ebp
  803d49:	53                   	push   %ebx
  803d4a:	83 ec 14             	sub    $0x14,%esp
  803d4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803d50:	8b 45 08             	mov    0x8(%ebp),%eax
  803d53:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803d58:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d63:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803d6a:	e8 ad ce ff ff       	call   800c1c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803d6f:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803d75:	b8 02 00 00 00       	mov    $0x2,%eax
  803d7a:	e8 35 ff ff ff       	call   803cb4 <_ZL5nsipcj>
}
  803d7f:	83 c4 14             	add    $0x14,%esp
  803d82:	5b                   	pop    %ebx
  803d83:	5d                   	pop    %ebp
  803d84:	c3                   	ret    

00803d85 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803d85:	55                   	push   %ebp
  803d86:	89 e5                	mov    %esp,%ebp
  803d88:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d96:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803d9b:	b8 03 00 00 00       	mov    $0x3,%eax
  803da0:	e8 0f ff ff ff       	call   803cb4 <_ZL5nsipcj>
}
  803da5:	c9                   	leave  
  803da6:	c3                   	ret    

00803da7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803da7:	55                   	push   %ebp
  803da8:	89 e5                	mov    %esp,%ebp
  803daa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803dad:	8b 45 08             	mov    0x8(%ebp),%eax
  803db0:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803db5:	b8 04 00 00 00       	mov    $0x4,%eax
  803dba:	e8 f5 fe ff ff       	call   803cb4 <_ZL5nsipcj>
}
  803dbf:	c9                   	leave  
  803dc0:	c3                   	ret    

00803dc1 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803dc1:	55                   	push   %ebp
  803dc2:	89 e5                	mov    %esp,%ebp
  803dc4:	53                   	push   %ebx
  803dc5:	83 ec 14             	sub    $0x14,%esp
  803dc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803dce:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803dd3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dda:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dde:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803de5:	e8 32 ce ff ff       	call   800c1c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803dea:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803df0:	b8 05 00 00 00       	mov    $0x5,%eax
  803df5:	e8 ba fe ff ff       	call   803cb4 <_ZL5nsipcj>
}
  803dfa:	83 c4 14             	add    $0x14,%esp
  803dfd:	5b                   	pop    %ebx
  803dfe:	5d                   	pop    %ebp
  803dff:	c3                   	ret    

00803e00 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803e00:	55                   	push   %ebp
  803e01:	89 e5                	mov    %esp,%ebp
  803e03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803e06:	8b 45 08             	mov    0x8(%ebp),%eax
  803e09:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e11:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803e16:	b8 06 00 00 00       	mov    $0x6,%eax
  803e1b:	e8 94 fe ff ff       	call   803cb4 <_ZL5nsipcj>
}
  803e20:	c9                   	leave  
  803e21:	c3                   	ret    

00803e22 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803e22:	55                   	push   %ebp
  803e23:	89 e5                	mov    %esp,%ebp
  803e25:	56                   	push   %esi
  803e26:	53                   	push   %ebx
  803e27:	83 ec 10             	sub    $0x10,%esp
  803e2a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e30:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803e35:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803e3b:	8b 45 14             	mov    0x14(%ebp),%eax
  803e3e:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803e43:	b8 07 00 00 00       	mov    $0x7,%eax
  803e48:	e8 67 fe ff ff       	call   803cb4 <_ZL5nsipcj>
  803e4d:	89 c3                	mov    %eax,%ebx
  803e4f:	85 c0                	test   %eax,%eax
  803e51:	78 46                	js     803e99 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803e53:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803e58:	7f 04                	jg     803e5e <_Z10nsipc_recviPvij+0x3c>
  803e5a:	39 f0                	cmp    %esi,%eax
  803e5c:	7e 24                	jle    803e82 <_Z10nsipc_recviPvij+0x60>
  803e5e:	c7 44 24 0c 23 51 80 	movl   $0x805123,0xc(%esp)
  803e65:	00 
  803e66:	c7 44 24 08 94 4a 80 	movl   $0x804a94,0x8(%esp)
  803e6d:	00 
  803e6e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803e75:	00 
  803e76:	c7 04 24 38 51 80 00 	movl   $0x805138,(%esp)
  803e7d:	e8 c6 c4 ff ff       	call   800348 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803e82:	89 44 24 08          	mov    %eax,0x8(%esp)
  803e86:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803e8d:	00 
  803e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e91:	89 04 24             	mov    %eax,(%esp)
  803e94:	e8 83 cd ff ff       	call   800c1c <memmove>
	}

	return r;
}
  803e99:	89 d8                	mov    %ebx,%eax
  803e9b:	83 c4 10             	add    $0x10,%esp
  803e9e:	5b                   	pop    %ebx
  803e9f:	5e                   	pop    %esi
  803ea0:	5d                   	pop    %ebp
  803ea1:	c3                   	ret    

00803ea2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ea2:	55                   	push   %ebp
  803ea3:	89 e5                	mov    %esp,%ebp
  803ea5:	53                   	push   %ebx
  803ea6:	83 ec 14             	sub    $0x14,%esp
  803ea9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803eac:	8b 45 08             	mov    0x8(%ebp),%eax
  803eaf:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  803eb4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803eba:	7e 24                	jle    803ee0 <_Z10nsipc_sendiPKvij+0x3e>
  803ebc:	c7 44 24 0c 44 51 80 	movl   $0x805144,0xc(%esp)
  803ec3:	00 
  803ec4:	c7 44 24 08 94 4a 80 	movl   $0x804a94,0x8(%esp)
  803ecb:	00 
  803ecc:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803ed3:	00 
  803ed4:	c7 04 24 38 51 80 00 	movl   $0x805138,(%esp)
  803edb:	e8 68 c4 ff ff       	call   800348 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803ee0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eeb:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  803ef2:	e8 25 cd ff ff       	call   800c1c <memmove>
	nsipcbuf.send.req_size = size;
  803ef7:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803efd:	8b 45 14             	mov    0x14(%ebp),%eax
  803f00:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  803f05:	b8 08 00 00 00       	mov    $0x8,%eax
  803f0a:	e8 a5 fd ff ff       	call   803cb4 <_ZL5nsipcj>
}
  803f0f:	83 c4 14             	add    $0x14,%esp
  803f12:	5b                   	pop    %ebx
  803f13:	5d                   	pop    %ebp
  803f14:	c3                   	ret    

00803f15 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803f15:	55                   	push   %ebp
  803f16:	89 e5                	mov    %esp,%ebp
  803f18:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f26:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  803f2e:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  803f33:	b8 09 00 00 00       	mov    $0x9,%eax
  803f38:	e8 77 fd ff ff       	call   803cb4 <_ZL5nsipcj>
}
  803f3d:	c9                   	leave  
  803f3e:	c3                   	ret    
	...

00803f40 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803f40:	55                   	push   %ebp
  803f41:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803f43:	b8 00 00 00 00       	mov    $0x0,%eax
  803f48:	5d                   	pop    %ebp
  803f49:	c3                   	ret    

00803f4a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f4a:	55                   	push   %ebp
  803f4b:	89 e5                	mov    %esp,%ebp
  803f4d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803f50:	c7 44 24 04 50 51 80 	movl   $0x805150,0x4(%esp)
  803f57:	00 
  803f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f5b:	89 04 24             	mov    %eax,(%esp)
  803f5e:	e8 17 cb ff ff       	call   800a7a <_Z6strcpyPcPKc>
	return 0;
}
  803f63:	b8 00 00 00 00       	mov    $0x0,%eax
  803f68:	c9                   	leave  
  803f69:	c3                   	ret    

00803f6a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f6a:	55                   	push   %ebp
  803f6b:	89 e5                	mov    %esp,%ebp
  803f6d:	57                   	push   %edi
  803f6e:	56                   	push   %esi
  803f6f:	53                   	push   %ebx
  803f70:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f76:	bb 00 00 00 00       	mov    $0x0,%ebx
  803f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803f7f:	74 3e                	je     803fbf <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803f81:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  803f87:	8b 75 10             	mov    0x10(%ebp),%esi
  803f8a:	29 de                	sub    %ebx,%esi
  803f8c:	83 fe 7f             	cmp    $0x7f,%esi
  803f8f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803f94:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  803f97:	89 74 24 08          	mov    %esi,0x8(%esp)
  803f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f9e:	01 d8                	add    %ebx,%eax
  803fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fa4:	89 3c 24             	mov    %edi,(%esp)
  803fa7:	e8 70 cc ff ff       	call   800c1c <memmove>
		sys_cputs(buf, m);
  803fac:	89 74 24 04          	mov    %esi,0x4(%esp)
  803fb0:	89 3c 24             	mov    %edi,(%esp)
  803fb3:	e8 7c ce ff ff       	call   800e34 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803fb8:	01 f3                	add    %esi,%ebx
  803fba:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  803fbd:	77 c8                	ja     803f87 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  803fbf:	89 d8                	mov    %ebx,%eax
  803fc1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  803fc7:	5b                   	pop    %ebx
  803fc8:	5e                   	pop    %esi
  803fc9:	5f                   	pop    %edi
  803fca:	5d                   	pop    %ebp
  803fcb:	c3                   	ret    

00803fcc <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fcc:	55                   	push   %ebp
  803fcd:	89 e5                	mov    %esp,%ebp
  803fcf:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  803fd2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803fd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803fdb:	75 07                	jne    803fe4 <_ZL12devcons_readP2FdPvj+0x18>
  803fdd:	eb 2a                	jmp    804009 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803fdf:	e8 48 cf ff ff       	call   800f2c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803fe4:	e8 7e ce ff ff       	call   800e67 <_Z9sys_cgetcv>
  803fe9:	85 c0                	test   %eax,%eax
  803feb:	74 f2                	je     803fdf <_ZL12devcons_readP2FdPvj+0x13>
  803fed:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  803fef:	85 c0                	test   %eax,%eax
  803ff1:	78 16                	js     804009 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  803ff3:	83 f8 04             	cmp    $0x4,%eax
  803ff6:	74 0c                	je     804004 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  803ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ffb:	88 10                	mov    %dl,(%eax)
	return 1;
  803ffd:	b8 01 00 00 00       	mov    $0x1,%eax
  804002:	eb 05                	jmp    804009 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  804004:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  804009:	c9                   	leave  
  80400a:	c3                   	ret    

0080400b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80400b:	55                   	push   %ebp
  80400c:	89 e5                	mov    %esp,%ebp
  80400e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  804011:	8b 45 08             	mov    0x8(%ebp),%eax
  804014:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804017:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80401e:	00 
  80401f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804022:	89 04 24             	mov    %eax,(%esp)
  804025:	e8 0a ce ff ff       	call   800e34 <_Z9sys_cputsPKcj>
}
  80402a:	c9                   	leave  
  80402b:	c3                   	ret    

0080402c <_Z7getcharv>:

int
getchar(void)
{
  80402c:	55                   	push   %ebp
  80402d:	89 e5                	mov    %esp,%ebp
  80402f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804032:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804039:	00 
  80403a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80403d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804041:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804048:	e8 71 dc ff ff       	call   801cbe <_Z4readiPvj>
	if (r < 0)
  80404d:	85 c0                	test   %eax,%eax
  80404f:	78 0f                	js     804060 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  804051:	85 c0                	test   %eax,%eax
  804053:	7e 06                	jle    80405b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  804055:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804059:	eb 05                	jmp    804060 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80405b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  804060:	c9                   	leave  
  804061:	c3                   	ret    

00804062 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  804062:	55                   	push   %ebp
  804063:	89 e5                	mov    %esp,%ebp
  804065:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  804068:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80406f:	00 
  804070:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804073:	89 44 24 04          	mov    %eax,0x4(%esp)
  804077:	8b 45 08             	mov    0x8(%ebp),%eax
  80407a:	89 04 24             	mov    %eax,(%esp)
  80407d:	e8 8f d8 ff ff       	call   801911 <_Z9fd_lookupiPP2Fdb>
  804082:	85 c0                	test   %eax,%eax
  804084:	78 11                	js     804097 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  804086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804089:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80408f:	39 10                	cmp    %edx,(%eax)
  804091:	0f 94 c0             	sete   %al
  804094:	0f b6 c0             	movzbl %al,%eax
}
  804097:	c9                   	leave  
  804098:	c3                   	ret    

00804099 <_Z8openconsv>:

int
opencons(void)
{
  804099:	55                   	push   %ebp
  80409a:	89 e5                	mov    %esp,%ebp
  80409c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80409f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8040a2:	89 04 24             	mov    %eax,(%esp)
  8040a5:	e8 1d d9 ff ff       	call   8019c7 <_Z14fd_find_unusedPP2Fd>
  8040aa:	85 c0                	test   %eax,%eax
  8040ac:	78 3c                	js     8040ea <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8040ae:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8040b5:	00 
  8040b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8040c4:	e8 97 ce ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  8040c9:	85 c0                	test   %eax,%eax
  8040cb:	78 1d                	js     8040ea <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8040cd:	8b 15 58 60 80 00    	mov    0x806058,%edx
  8040d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8040d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8040e2:	89 04 24             	mov    %eax,(%esp)
  8040e5:	e8 7a d8 ff ff       	call   801964 <_Z6fd2numP2Fd>
}
  8040ea:	c9                   	leave  
  8040eb:	c3                   	ret    
  8040ec:	00 00                	add    %al,(%eax)
	...

008040f0 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  8040f0:	55                   	push   %ebp
  8040f1:	89 e5                	mov    %esp,%ebp
  8040f3:	56                   	push   %esi
  8040f4:	53                   	push   %ebx
  8040f5:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8040f8:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  8040fd:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  804104:	85 c0                	test   %eax,%eax
  804106:	74 08                	je     804110 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  804108:	8d 55 08             	lea    0x8(%ebp),%edx
  80410b:	89 14 24             	mov    %edx,(%esp)
  80410e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804110:	83 eb 01             	sub    $0x1,%ebx
  804113:	83 fb ff             	cmp    $0xffffffff,%ebx
  804116:	75 e5                	jne    8040fd <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  804118:	8b 5d 38             	mov    0x38(%ebp),%ebx
  80411b:	8b 75 08             	mov    0x8(%ebp),%esi
  80411e:	e8 d5 cd ff ff       	call   800ef8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  804123:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  804127:	89 74 24 10          	mov    %esi,0x10(%esp)
  80412b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80412f:	c7 44 24 08 5c 51 80 	movl   $0x80515c,0x8(%esp)
  804136:	00 
  804137:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80413e:	00 
  80413f:	c7 04 24 e0 51 80 00 	movl   $0x8051e0,(%esp)
  804146:	e8 fd c1 ff ff       	call   800348 <_Z6_panicPKciS0_z>

0080414b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  80414b:	55                   	push   %ebp
  80414c:	89 e5                	mov    %esp,%ebp
  80414e:	56                   	push   %esi
  80414f:	53                   	push   %ebx
  804150:	83 ec 10             	sub    $0x10,%esp
  804153:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804156:	e8 9d cd ff ff       	call   800ef8 <_Z12sys_getenvidv>
  80415b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80415d:	a1 00 70 80 00       	mov    0x807000,%eax
  804162:	8b 40 5c             	mov    0x5c(%eax),%eax
  804165:	85 c0                	test   %eax,%eax
  804167:	75 4c                	jne    8041b5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  804169:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  804170:	00 
  804171:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  804178:	ee 
  804179:	89 34 24             	mov    %esi,(%esp)
  80417c:	e8 df cd ff ff       	call   800f60 <_Z14sys_page_allociPvi>
  804181:	85 c0                	test   %eax,%eax
  804183:	74 20                	je     8041a5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  804185:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804189:	c7 44 24 08 94 51 80 	movl   $0x805194,0x8(%esp)
  804190:	00 
  804191:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  804198:	00 
  804199:	c7 04 24 e0 51 80 00 	movl   $0x8051e0,(%esp)
  8041a0:	e8 a3 c1 ff ff       	call   800348 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  8041a5:	c7 44 24 04 f0 40 80 	movl   $0x8040f0,0x4(%esp)
  8041ac:	00 
  8041ad:	89 34 24             	mov    %esi,(%esp)
  8041b0:	e8 e0 cf ff ff       	call   801195 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  8041b5:	a1 00 90 80 00       	mov    0x809000,%eax
  8041ba:	39 d8                	cmp    %ebx,%eax
  8041bc:	74 1a                	je     8041d8 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  8041be:	85 c0                	test   %eax,%eax
  8041c0:	74 20                	je     8041e2 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8041c2:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  8041c7:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  8041ce:	39 da                	cmp    %ebx,%edx
  8041d0:	74 15                	je     8041e7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  8041d2:	85 d2                	test   %edx,%edx
  8041d4:	75 1f                	jne    8041f5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  8041d6:	eb 0f                	jmp    8041e7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8041d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8041dd:	8d 76 00             	lea    0x0(%esi),%esi
  8041e0:	eb 05                	jmp    8041e7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  8041e2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  8041e7:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  8041ee:	83 c4 10             	add    $0x10,%esp
  8041f1:	5b                   	pop    %ebx
  8041f2:	5e                   	pop    %esi
  8041f3:	5d                   	pop    %ebp
  8041f4:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8041f5:	83 c0 01             	add    $0x1,%eax
  8041f8:	83 f8 08             	cmp    $0x8,%eax
  8041fb:	75 ca                	jne    8041c7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  8041fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804201:	c7 44 24 08 b8 51 80 	movl   $0x8051b8,0x8(%esp)
  804208:	00 
  804209:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804210:	00 
  804211:	c7 04 24 e0 51 80 00 	movl   $0x8051e0,(%esp)
  804218:	e8 2b c1 ff ff       	call   800348 <_Z6_panicPKciS0_z>
  80421d:	00 00                	add    %al,(%eax)
	...

00804220 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  804220:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  804223:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  804224:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  804227:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  80422b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  80422f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  804232:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  804234:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  804238:	61                   	popa   
    popf
  804239:	9d                   	popf   
    popl %esp
  80423a:	5c                   	pop    %esp
    ret
  80423b:	c3                   	ret    

0080423c <spin>:

spin:	jmp spin
  80423c:	eb fe                	jmp    80423c <spin>
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
  80425e:	e8 c8 cf ff ff       	call   80122b <_Z12sys_ipc_recvPv>
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
  804281:	e8 72 cc ff ff       	call   800ef8 <_Z12sys_getenvidv>
  804286:	25 ff 03 00 00       	and    $0x3ff,%eax
  80428b:	6b c0 78             	imul   $0x78,%eax,%eax
  80428e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804293:	8b 40 60             	mov    0x60(%eax),%eax
  804296:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804298:	85 f6                	test   %esi,%esi
  80429a:	74 17                	je     8042b3 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80429c:	e8 57 cc ff ff       	call   800ef8 <_Z12sys_getenvidv>
  8042a1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8042a6:	6b c0 78             	imul   $0x78,%eax,%eax
  8042a9:	05 00 00 00 ef       	add    $0xef000000,%eax
  8042ae:	8b 40 70             	mov    0x70(%eax),%eax
  8042b1:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  8042b3:	e8 40 cc ff ff       	call   800ef8 <_Z12sys_getenvidv>
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
  8042fd:	e8 f1 ce ff ff       	call   8011f3 <_Z16sys_ipc_try_sendijPvi>
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
  804310:	e8 17 cc ff ff       	call   800f2c <_Z9sys_yieldv>
  804315:	eb d4                	jmp    8042eb <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  804317:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80431b:	c7 44 24 08 ee 51 80 	movl   $0x8051ee,0x8(%esp)
  804322:	00 
  804323:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  80432a:	00 
  80432b:	c7 04 24 fb 51 80 00 	movl   $0x8051fb,(%esp)
  804332:	e8 11 c0 ff ff       	call   800348 <_Z6_panicPKciS0_z>
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

00804340 <__udivdi3>:
  804340:	55                   	push   %ebp
  804341:	89 e5                	mov    %esp,%ebp
  804343:	57                   	push   %edi
  804344:	56                   	push   %esi
  804345:	83 ec 20             	sub    $0x20,%esp
  804348:	8b 45 14             	mov    0x14(%ebp),%eax
  80434b:	8b 75 08             	mov    0x8(%ebp),%esi
  80434e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804351:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804354:	85 c0                	test   %eax,%eax
  804356:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804359:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80435c:	75 3a                	jne    804398 <__udivdi3+0x58>
  80435e:	39 f9                	cmp    %edi,%ecx
  804360:	77 66                	ja     8043c8 <__udivdi3+0x88>
  804362:	85 c9                	test   %ecx,%ecx
  804364:	75 0b                	jne    804371 <__udivdi3+0x31>
  804366:	b8 01 00 00 00       	mov    $0x1,%eax
  80436b:	31 d2                	xor    %edx,%edx
  80436d:	f7 f1                	div    %ecx
  80436f:	89 c1                	mov    %eax,%ecx
  804371:	89 f8                	mov    %edi,%eax
  804373:	31 d2                	xor    %edx,%edx
  804375:	f7 f1                	div    %ecx
  804377:	89 c7                	mov    %eax,%edi
  804379:	89 f0                	mov    %esi,%eax
  80437b:	f7 f1                	div    %ecx
  80437d:	89 fa                	mov    %edi,%edx
  80437f:	89 c6                	mov    %eax,%esi
  804381:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804384:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80438a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80438d:	83 c4 20             	add    $0x20,%esp
  804390:	5e                   	pop    %esi
  804391:	5f                   	pop    %edi
  804392:	5d                   	pop    %ebp
  804393:	c3                   	ret    
  804394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804398:	31 d2                	xor    %edx,%edx
  80439a:	31 f6                	xor    %esi,%esi
  80439c:	39 f8                	cmp    %edi,%eax
  80439e:	77 e1                	ja     804381 <__udivdi3+0x41>
  8043a0:	0f bd d0             	bsr    %eax,%edx
  8043a3:	83 f2 1f             	xor    $0x1f,%edx
  8043a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8043a9:	75 2d                	jne    8043d8 <__udivdi3+0x98>
  8043ab:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8043ae:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  8043b1:	76 06                	jbe    8043b9 <__udivdi3+0x79>
  8043b3:	39 f8                	cmp    %edi,%eax
  8043b5:	89 f2                	mov    %esi,%edx
  8043b7:	73 c8                	jae    804381 <__udivdi3+0x41>
  8043b9:	31 d2                	xor    %edx,%edx
  8043bb:	be 01 00 00 00       	mov    $0x1,%esi
  8043c0:	eb bf                	jmp    804381 <__udivdi3+0x41>
  8043c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8043c8:	89 f0                	mov    %esi,%eax
  8043ca:	89 fa                	mov    %edi,%edx
  8043cc:	f7 f1                	div    %ecx
  8043ce:	31 d2                	xor    %edx,%edx
  8043d0:	89 c6                	mov    %eax,%esi
  8043d2:	eb ad                	jmp    804381 <__udivdi3+0x41>
  8043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8043d8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043dc:	89 c2                	mov    %eax,%edx
  8043de:	b8 20 00 00 00       	mov    $0x20,%eax
  8043e3:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8043e6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8043e9:	d3 e2                	shl    %cl,%edx
  8043eb:	89 c1                	mov    %eax,%ecx
  8043ed:	d3 ee                	shr    %cl,%esi
  8043ef:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8043f3:	09 d6                	or     %edx,%esi
  8043f5:	89 fa                	mov    %edi,%edx
  8043f7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8043fa:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8043fd:	d3 e6                	shl    %cl,%esi
  8043ff:	89 c1                	mov    %eax,%ecx
  804401:	d3 ea                	shr    %cl,%edx
  804403:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804407:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80440a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80440d:	d3 e7                	shl    %cl,%edi
  80440f:	89 c1                	mov    %eax,%ecx
  804411:	d3 ee                	shr    %cl,%esi
  804413:	09 fe                	or     %edi,%esi
  804415:	89 f0                	mov    %esi,%eax
  804417:	f7 75 e4             	divl   -0x1c(%ebp)
  80441a:	89 d7                	mov    %edx,%edi
  80441c:	89 c6                	mov    %eax,%esi
  80441e:	f7 65 f0             	mull   -0x10(%ebp)
  804421:	39 d7                	cmp    %edx,%edi
  804423:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804426:	72 12                	jb     80443a <__udivdi3+0xfa>
  804428:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80442b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80442f:	d3 e2                	shl    %cl,%edx
  804431:	39 c2                	cmp    %eax,%edx
  804433:	73 08                	jae    80443d <__udivdi3+0xfd>
  804435:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804438:	75 03                	jne    80443d <__udivdi3+0xfd>
  80443a:	83 ee 01             	sub    $0x1,%esi
  80443d:	31 d2                	xor    %edx,%edx
  80443f:	e9 3d ff ff ff       	jmp    804381 <__udivdi3+0x41>
	...

00804450 <__umoddi3>:
  804450:	55                   	push   %ebp
  804451:	89 e5                	mov    %esp,%ebp
  804453:	57                   	push   %edi
  804454:	56                   	push   %esi
  804455:	83 ec 20             	sub    $0x20,%esp
  804458:	8b 7d 14             	mov    0x14(%ebp),%edi
  80445b:	8b 45 08             	mov    0x8(%ebp),%eax
  80445e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804461:	8b 75 0c             	mov    0xc(%ebp),%esi
  804464:	85 ff                	test   %edi,%edi
  804466:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804469:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80446c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80446f:	89 f2                	mov    %esi,%edx
  804471:	75 15                	jne    804488 <__umoddi3+0x38>
  804473:	39 f1                	cmp    %esi,%ecx
  804475:	76 41                	jbe    8044b8 <__umoddi3+0x68>
  804477:	f7 f1                	div    %ecx
  804479:	89 d0                	mov    %edx,%eax
  80447b:	31 d2                	xor    %edx,%edx
  80447d:	83 c4 20             	add    $0x20,%esp
  804480:	5e                   	pop    %esi
  804481:	5f                   	pop    %edi
  804482:	5d                   	pop    %ebp
  804483:	c3                   	ret    
  804484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804488:	39 f7                	cmp    %esi,%edi
  80448a:	77 4c                	ja     8044d8 <__umoddi3+0x88>
  80448c:	0f bd c7             	bsr    %edi,%eax
  80448f:	83 f0 1f             	xor    $0x1f,%eax
  804492:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804495:	75 51                	jne    8044e8 <__umoddi3+0x98>
  804497:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80449a:	0f 87 e8 00 00 00    	ja     804588 <__umoddi3+0x138>
  8044a0:	89 f2                	mov    %esi,%edx
  8044a2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8044a5:	29 ce                	sub    %ecx,%esi
  8044a7:	19 fa                	sbb    %edi,%edx
  8044a9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8044ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044af:	83 c4 20             	add    $0x20,%esp
  8044b2:	5e                   	pop    %esi
  8044b3:	5f                   	pop    %edi
  8044b4:	5d                   	pop    %ebp
  8044b5:	c3                   	ret    
  8044b6:	66 90                	xchg   %ax,%ax
  8044b8:	85 c9                	test   %ecx,%ecx
  8044ba:	75 0b                	jne    8044c7 <__umoddi3+0x77>
  8044bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8044c1:	31 d2                	xor    %edx,%edx
  8044c3:	f7 f1                	div    %ecx
  8044c5:	89 c1                	mov    %eax,%ecx
  8044c7:	89 f0                	mov    %esi,%eax
  8044c9:	31 d2                	xor    %edx,%edx
  8044cb:	f7 f1                	div    %ecx
  8044cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044d0:	eb a5                	jmp    804477 <__umoddi3+0x27>
  8044d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8044d8:	89 f2                	mov    %esi,%edx
  8044da:	83 c4 20             	add    $0x20,%esp
  8044dd:	5e                   	pop    %esi
  8044de:	5f                   	pop    %edi
  8044df:	5d                   	pop    %ebp
  8044e0:	c3                   	ret    
  8044e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8044e8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8044ec:	89 f2                	mov    %esi,%edx
  8044ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044f1:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  8044f8:	29 45 f0             	sub    %eax,-0x10(%ebp)
  8044fb:	d3 e7                	shl    %cl,%edi
  8044fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804500:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804504:	d3 e8                	shr    %cl,%eax
  804506:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80450a:	09 f8                	or     %edi,%eax
  80450c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80450f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804512:	d3 e0                	shl    %cl,%eax
  804514:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804518:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80451b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80451e:	d3 ea                	shr    %cl,%edx
  804520:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804524:	d3 e6                	shl    %cl,%esi
  804526:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80452a:	d3 e8                	shr    %cl,%eax
  80452c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804530:	09 f0                	or     %esi,%eax
  804532:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804535:	f7 75 e4             	divl   -0x1c(%ebp)
  804538:	d3 e6                	shl    %cl,%esi
  80453a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80453d:	89 d6                	mov    %edx,%esi
  80453f:	f7 65 f4             	mull   -0xc(%ebp)
  804542:	89 d7                	mov    %edx,%edi
  804544:	89 c2                	mov    %eax,%edx
  804546:	39 fe                	cmp    %edi,%esi
  804548:	89 f9                	mov    %edi,%ecx
  80454a:	72 30                	jb     80457c <__umoddi3+0x12c>
  80454c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80454f:	72 27                	jb     804578 <__umoddi3+0x128>
  804551:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804554:	29 d0                	sub    %edx,%eax
  804556:	19 ce                	sbb    %ecx,%esi
  804558:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80455c:	89 f2                	mov    %esi,%edx
  80455e:	d3 e8                	shr    %cl,%eax
  804560:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804564:	d3 e2                	shl    %cl,%edx
  804566:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80456a:	09 d0                	or     %edx,%eax
  80456c:	89 f2                	mov    %esi,%edx
  80456e:	d3 ea                	shr    %cl,%edx
  804570:	83 c4 20             	add    $0x20,%esp
  804573:	5e                   	pop    %esi
  804574:	5f                   	pop    %edi
  804575:	5d                   	pop    %ebp
  804576:	c3                   	ret    
  804577:	90                   	nop
  804578:	39 fe                	cmp    %edi,%esi
  80457a:	75 d5                	jne    804551 <__umoddi3+0x101>
  80457c:	89 f9                	mov    %edi,%ecx
  80457e:	89 c2                	mov    %eax,%edx
  804580:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804583:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804586:	eb c9                	jmp    804551 <__umoddi3+0x101>
  804588:	39 f7                	cmp    %esi,%edi
  80458a:	0f 82 10 ff ff ff    	jb     8044a0 <__umoddi3+0x50>
  804590:	e9 17 ff ff ff       	jmp    8044ac <__umoddi3+0x5c>
