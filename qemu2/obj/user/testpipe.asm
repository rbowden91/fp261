
obj/user/testpipe:     file format elf32-i386


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
  80002c:	e8 e7 02 00 00       	call   800318 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z5umainiPPc>:

const char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	argv0 = "pipereadeof";
  80003c:	c7 05 04 70 80 00 80 	movl   $0x804680,0x807004
  800043:	46 80 00 

	if ((i = pipe(p)) < 0)
  800046:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 03 37 00 00       	call   803754 <_Z4pipePi>
  800051:	89 c6                	mov    %eax,%esi
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <_Z5umainiPPc+0x43>
		panic("pipe: %e", i);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 8c 46 80 	movl   $0x80468c,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 95 46 80 00 	movl   $0x804695,(%esp)
  800072:	e8 25 03 00 00       	call   80039c <_Z6_panicPKciS0_z>

	if ((pid = fork()) < 0)
  800077:	e8 81 15 00 00       	call   8015fd <_Z4forkv>
  80007c:	89 c3                	mov    %eax,%ebx
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <_Z5umainiPPc+0x6e>
		panic("fork: %e", i);
  800082:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800086:	c7 44 24 08 c8 4b 80 	movl   $0x804bc8,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 95 46 80 00 	movl   $0x804695,(%esp)
  80009d:	e8 fa 02 00 00       	call   80039c <_Z6_panicPKciS0_z>

	if (pid == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	0f 85 d5 00 00 00    	jne    80017f <_Z5umainiPPc+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  8000aa:	a1 00 70 80 00       	mov    0x807000,%eax
  8000af:	8b 40 04             	mov    0x4(%eax),%eax
  8000b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000b5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 a5 46 80 00 	movl   $0x8046a5,(%esp)
  8000c4:	e8 f1 03 00 00       	call   8004ba <_Z7cprintfPKcz>
		close(p[1]);
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	89 04 24             	mov    %eax,(%esp)
  8000cf:	e8 a1 1a 00 00       	call   801b75 <_Z5closei>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000d4:	a1 00 70 80 00       	mov    0x807000,%eax
  8000d9:	8b 40 04             	mov    0x4(%eax),%eax
  8000dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8000df:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e7:	c7 04 24 c2 46 80 00 	movl   $0x8046c2,(%esp)
  8000ee:	e8 c7 03 00 00       	call   8004ba <_Z7cprintfPKcz>
		i = readn(p[0], buf, sizeof buf-1);
  8000f3:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000fa:	00 
  8000fb:	8d 45 8c             	lea    -0x74(%ebp),%eax
  8000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800105:	89 04 24             	mov    %eax,(%esp)
  800108:	e8 ab 1c 00 00       	call   801db8 <_Z5readniPvj>
  80010d:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <_Z5umainiPPc+0xff>
			panic("read: %e", i);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 df 46 80 	movl   $0x8046df,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 95 46 80 00 	movl   $0x804695,(%esp)
  80012e:	e8 69 02 00 00       	call   80039c <_Z6_panicPKciS0_z>
		buf[i] = 0;
  800133:	c6 44 05 8c 00       	movb   $0x0,-0x74(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800138:	a1 00 60 80 00       	mov    0x806000,%eax
  80013d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800141:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800144:	89 04 24             	mov    %eax,(%esp)
  800147:	e8 18 0a 00 00       	call   800b64 <_Z6strcmpPKcS0_>
  80014c:	85 c0                	test   %eax,%eax
  80014e:	75 0e                	jne    80015e <_Z5umainiPPc+0x12a>
			cprintf("\npipe read closed properly\n");
  800150:	c7 04 24 e8 46 80 00 	movl   $0x8046e8,(%esp)
  800157:	e8 5e 03 00 00       	call   8004ba <_Z7cprintfPKcz>
  80015c:	eb 17                	jmp    800175 <_Z5umainiPPc+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015e:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800161:	89 44 24 08          	mov    %eax,0x8(%esp)
  800165:	89 74 24 04          	mov    %esi,0x4(%esp)
  800169:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  800170:	e8 45 03 00 00       	call   8004ba <_Z7cprintfPKcz>
		exit();
  800175:	e8 06 02 00 00       	call   800380 <_Z4exitv>
  80017a:	e9 ac 00 00 00       	jmp    80022b <_Z5umainiPPc+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80017f:	a1 00 70 80 00       	mov    0x807000,%eax
  800184:	8b 40 04             	mov    0x4(%eax),%eax
  800187:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80018a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800192:	c7 04 24 a5 46 80 00 	movl   $0x8046a5,(%esp)
  800199:	e8 1c 03 00 00       	call   8004ba <_Z7cprintfPKcz>
		close(p[0]);
  80019e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001a1:	89 04 24             	mov    %eax,(%esp)
  8001a4:	e8 cc 19 00 00       	call   801b75 <_Z5closei>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001a9:	a1 00 70 80 00       	mov    0x807000,%eax
  8001ae:	8b 40 04             	mov    0x4(%eax),%eax
  8001b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bc:	c7 04 24 17 47 80 00 	movl   $0x804717,(%esp)
  8001c3:	e8 f2 02 00 00       	call   8004ba <_Z7cprintfPKcz>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c8:	a1 00 60 80 00       	mov    0x806000,%eax
  8001cd:	89 04 24             	mov    %eax,(%esp)
  8001d0:	e8 cb 08 00 00       	call   800aa0 <_Z6strlenPKc>
  8001d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d9:	a1 00 60 80 00       	mov    0x806000,%eax
  8001de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e5:	89 04 24             	mov    %eax,(%esp)
  8001e8:	e8 1c 1c 00 00       	call   801e09 <_Z5writeiPKvj>
  8001ed:	89 c6                	mov    %eax,%esi
  8001ef:	a1 00 60 80 00       	mov    0x806000,%eax
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 a4 08 00 00       	call   800aa0 <_Z6strlenPKc>
  8001fc:	39 c6                	cmp    %eax,%esi
  8001fe:	74 20                	je     800220 <_Z5umainiPPc+0x1ec>
			panic("write: %e", i);
  800200:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800204:	c7 44 24 08 34 47 80 	movl   $0x804734,0x8(%esp)
  80020b:	00 
  80020c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800213:	00 
  800214:	c7 04 24 95 46 80 00 	movl   $0x804695,(%esp)
  80021b:	e8 7c 01 00 00       	call   80039c <_Z6_panicPKciS0_z>
		close(p[1]);
  800220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800223:	89 04 24             	mov    %eax,(%esp)
  800226:	e8 4a 19 00 00       	call   801b75 <_Z5closei>
	}
	wait(pid);
  80022b:	89 1c 24             	mov    %ebx,(%esp)
  80022e:	e8 8d 38 00 00       	call   803ac0 <_Z4waiti>

	argv0 = "pipewriteeof";
  800233:	c7 05 04 70 80 00 3e 	movl   $0x80473e,0x807004
  80023a:	47 80 00 
	if ((i = pipe(p)) < 0)
  80023d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800240:	89 04 24             	mov    %eax,(%esp)
  800243:	e8 0c 35 00 00       	call   803754 <_Z4pipePi>
  800248:	89 c6                	mov    %eax,%esi
  80024a:	85 c0                	test   %eax,%eax
  80024c:	79 20                	jns    80026e <_Z5umainiPPc+0x23a>
		panic("pipe: %e", i);
  80024e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800252:	c7 44 24 08 8c 46 80 	movl   $0x80468c,0x8(%esp)
  800259:	00 
  80025a:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800261:	00 
  800262:	c7 04 24 95 46 80 00 	movl   $0x804695,(%esp)
  800269:	e8 2e 01 00 00       	call   80039c <_Z6_panicPKciS0_z>

	if ((pid = fork()) < 0)
  80026e:	e8 8a 13 00 00       	call   8015fd <_Z4forkv>
  800273:	89 c3                	mov    %eax,%ebx
  800275:	85 c0                	test   %eax,%eax
  800277:	79 20                	jns    800299 <_Z5umainiPPc+0x265>
		panic("fork: %e", i);
  800279:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027d:	c7 44 24 08 c8 4b 80 	movl   $0x804bc8,0x8(%esp)
  800284:	00 
  800285:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028c:	00 
  80028d:	c7 04 24 95 46 80 00 	movl   $0x804695,(%esp)
  800294:	e8 03 01 00 00       	call   80039c <_Z6_panicPKciS0_z>

	if (pid == 0) {
  800299:	85 c0                	test   %eax,%eax
  80029b:	75 48                	jne    8002e5 <_Z5umainiPPc+0x2b1>
		close(p[0]);
  80029d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002a0:	89 04 24             	mov    %eax,(%esp)
  8002a3:	e8 cd 18 00 00       	call   801b75 <_Z5closei>
		while (1) {
			cprintf(".");
  8002a8:	c7 04 24 4b 47 80 00 	movl   $0x80474b,(%esp)
  8002af:	e8 06 02 00 00       	call   8004ba <_Z7cprintfPKcz>
			if (write(p[1], "x", 1) != 1)
  8002b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002bb:	00 
  8002bc:	c7 44 24 04 4d 47 80 	movl   $0x80474d,0x4(%esp)
  8002c3:	00 
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	89 04 24             	mov    %eax,(%esp)
  8002ca:	e8 3a 1b 00 00       	call   801e09 <_Z5writeiPKvj>
  8002cf:	83 f8 01             	cmp    $0x1,%eax
  8002d2:	74 d4                	je     8002a8 <_Z5umainiPPc+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d4:	c7 04 24 4f 47 80 00 	movl   $0x80474f,(%esp)
  8002db:	e8 da 01 00 00       	call   8004ba <_Z7cprintfPKcz>
		exit();
  8002e0:	e8 9b 00 00 00       	call   800380 <_Z4exitv>
	}
	close(p[0]);
  8002e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e8:	89 04 24             	mov    %eax,(%esp)
  8002eb:	e8 85 18 00 00       	call   801b75 <_Z5closei>
	close(p[1]);
  8002f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f3:	89 04 24             	mov    %eax,(%esp)
  8002f6:	e8 7a 18 00 00       	call   801b75 <_Z5closei>
	wait(pid);
  8002fb:	89 1c 24             	mov    %ebx,(%esp)
  8002fe:	e8 bd 37 00 00       	call   803ac0 <_Z4waiti>

	cprintf("pipe tests passed\n");
  800303:	c7 04 24 6c 47 80 00 	movl   $0x80476c,(%esp)
  80030a:	e8 ab 01 00 00       	call   8004ba <_Z7cprintfPKcz>
}
  80030f:	83 ec 80             	sub    $0xffffff80,%esp
  800312:	5b                   	pop    %ebx
  800313:	5e                   	pop    %esi
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    
	...

00800318 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	57                   	push   %edi
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 1c             	sub    $0x1c,%esp
  800321:	8b 7d 08             	mov    0x8(%ebp),%edi
  800324:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800327:	e8 2c 0c 00 00       	call   800f58 <_Z12sys_getenvidv>
  80032c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800331:	6b c0 78             	imul   $0x78,%eax,%eax
  800334:	05 00 00 00 ef       	add    $0xef000000,%eax
  800339:	a3 00 70 80 00       	mov    %eax,0x807000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033e:	85 ff                	test   %edi,%edi
  800340:	7e 07                	jle    800349 <libmain+0x31>
		binaryname = argv[0];
  800342:	8b 06                	mov    (%esi),%eax
  800344:	a3 04 60 80 00       	mov    %eax,0x806004

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800349:	b8 a1 53 80 00       	mov    $0x8053a1,%eax
  80034e:	3d a1 53 80 00       	cmp    $0x8053a1,%eax
  800353:	76 0f                	jbe    800364 <libmain+0x4c>
  800355:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800357:	83 eb 04             	sub    $0x4,%ebx
  80035a:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  80035c:	81 fb a1 53 80 00    	cmp    $0x8053a1,%ebx
  800362:	77 f3                	ja     800357 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800364:	89 74 24 04          	mov    %esi,0x4(%esp)
  800368:	89 3c 24             	mov    %edi,(%esp)
  80036b:	e8 c4 fc ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800370:	e8 0b 00 00 00       	call   800380 <_Z4exitv>
}
  800375:	83 c4 1c             	add    $0x1c,%esp
  800378:	5b                   	pop    %ebx
  800379:	5e                   	pop    %esi
  80037a:	5f                   	pop    %edi
  80037b:	5d                   	pop    %ebp
  80037c:	c3                   	ret    
  80037d:	00 00                	add    %al,(%eax)
	...

00800380 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800386:	e8 23 18 00 00       	call   801bae <_Z9close_allv>
	sys_env_destroy(0);
  80038b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800392:	e8 64 0b 00 00       	call   800efb <_Z15sys_env_destroyi>
}
  800397:	c9                   	leave  
  800398:	c3                   	ret    
  800399:	00 00                	add    %al,(%eax)
	...

0080039c <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	56                   	push   %esi
  8003a0:	53                   	push   %ebx
  8003a1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8003a4:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  8003a7:	a1 04 70 80 00       	mov    0x807004,%eax
  8003ac:	85 c0                	test   %eax,%eax
  8003ae:	74 10                	je     8003c0 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  8003b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b4:	c7 04 24 ce 47 80 00 	movl   $0x8047ce,(%esp)
  8003bb:	e8 fa 00 00 00       	call   8004ba <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  8003c0:	8b 1d 04 60 80 00    	mov    0x806004,%ebx
  8003c6:	e8 8d 0b 00 00       	call   800f58 <_Z12sys_getenvidv>
  8003cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ce:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e1:	c7 04 24 d4 47 80 00 	movl   $0x8047d4,(%esp)
  8003e8:	e8 cd 00 00 00       	call   8004ba <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8003ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f4:	89 04 24             	mov    %eax,(%esp)
  8003f7:	e8 5d 00 00 00       	call   800459 <_Z8vcprintfPKcPc>
	cprintf("\n");
  8003fc:	c7 04 24 c0 46 80 00 	movl   $0x8046c0,(%esp)
  800403:	e8 b2 00 00 00       	call   8004ba <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800408:	cc                   	int3   
  800409:	eb fd                	jmp    800408 <_Z6_panicPKciS0_z+0x6c>
	...

0080040c <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	83 ec 18             	sub    $0x18,%esp
  800412:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800415:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800418:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  80041b:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  80041d:	8b 03                	mov    (%ebx),%eax
  80041f:	8b 55 08             	mov    0x8(%ebp),%edx
  800422:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800426:	83 c0 01             	add    $0x1,%eax
  800429:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80042b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800430:	75 19                	jne    80044b <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  800432:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800439:	00 
  80043a:	8d 43 08             	lea    0x8(%ebx),%eax
  80043d:	89 04 24             	mov    %eax,(%esp)
  800440:	e8 4f 0a 00 00       	call   800e94 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80044b:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80044f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800452:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800455:	89 ec                	mov    %ebp,%esp
  800457:	5d                   	pop    %ebp
  800458:	c3                   	ret    

00800459 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800462:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800469:	00 00 00 
	b.cnt = 0;
  80046c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800473:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	89 44 24 08          	mov    %eax,0x8(%esp)
  800484:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80048a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80048e:	c7 04 24 0c 04 80 00 	movl   $0x80040c,(%esp)
  800495:	e8 ad 01 00 00       	call   800647 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80049a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8004a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004aa:	89 04 24             	mov    %eax,(%esp)
  8004ad:	e8 e2 09 00 00       	call   800e94 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  8004b2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004c0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	89 04 24             	mov    %eax,(%esp)
  8004cd:	e8 87 ff ff ff       	call   800459 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  8004d2:	c9                   	leave  
  8004d3:	c3                   	ret    
	...

008004e0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	57                   	push   %edi
  8004e4:	56                   	push   %esi
  8004e5:	53                   	push   %ebx
  8004e6:	83 ec 4c             	sub    $0x4c,%esp
  8004e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ec:	89 d6                	mov    %edx,%esi
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004fd:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	39 d0                	cmp    %edx,%eax
  800507:	72 11                	jb     80051a <_ZL8printnumPFviPvES_yjii+0x3a>
  800509:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80050c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80050f:	76 09                	jbe    80051a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800511:	83 eb 01             	sub    $0x1,%ebx
  800514:	85 db                	test   %ebx,%ebx
  800516:	7f 5d                	jg     800575 <_ZL8printnumPFviPvES_yjii+0x95>
  800518:	eb 6c                	jmp    800586 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80051a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80051e:	83 eb 01             	sub    $0x1,%ebx
  800521:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800525:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800528:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80052c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800530:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800534:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800537:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80053a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800541:	00 
  800542:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800545:	89 14 24             	mov    %edx,(%esp)
  800548:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80054b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80054f:	e8 bc 3e 00 00       	call   804410 <__udivdi3>
  800554:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800557:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80055a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80055e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800562:	89 04 24             	mov    %eax,(%esp)
  800565:	89 54 24 04          	mov    %edx,0x4(%esp)
  800569:	89 f2                	mov    %esi,%edx
  80056b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80056e:	e8 6d ff ff ff       	call   8004e0 <_ZL8printnumPFviPvES_yjii>
  800573:	eb 11                	jmp    800586 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800575:	89 74 24 04          	mov    %esi,0x4(%esp)
  800579:	89 3c 24             	mov    %edi,(%esp)
  80057c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80057f:	83 eb 01             	sub    $0x1,%ebx
  800582:	85 db                	test   %ebx,%ebx
  800584:	7f ef                	jg     800575 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800586:	89 74 24 04          	mov    %esi,0x4(%esp)
  80058a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80058e:	8b 45 10             	mov    0x10(%ebp),%eax
  800591:	89 44 24 08          	mov    %eax,0x8(%esp)
  800595:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80059c:	00 
  80059d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005a0:	89 14 24             	mov    %edx,(%esp)
  8005a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005aa:	e8 71 3f 00 00       	call   804520 <__umoddi3>
  8005af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005b3:	0f be 80 f7 47 80 00 	movsbl 0x8047f7(%eax),%eax
  8005ba:	89 04 24             	mov    %eax,(%esp)
  8005bd:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8005c0:	83 c4 4c             	add    $0x4c,%esp
  8005c3:	5b                   	pop    %ebx
  8005c4:	5e                   	pop    %esi
  8005c5:	5f                   	pop    %edi
  8005c6:	5d                   	pop    %ebp
  8005c7:	c3                   	ret    

008005c8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005cb:	83 fa 01             	cmp    $0x1,%edx
  8005ce:	7e 0e                	jle    8005de <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  8005d0:	8b 10                	mov    (%eax),%edx
  8005d2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005d5:	89 08                	mov    %ecx,(%eax)
  8005d7:	8b 02                	mov    (%edx),%eax
  8005d9:	8b 52 04             	mov    0x4(%edx),%edx
  8005dc:	eb 22                	jmp    800600 <_ZL7getuintPPci+0x38>
	else if (lflag)
  8005de:	85 d2                	test   %edx,%edx
  8005e0:	74 10                	je     8005f2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  8005e2:	8b 10                	mov    (%eax),%edx
  8005e4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005e7:	89 08                	mov    %ecx,(%eax)
  8005e9:	8b 02                	mov    (%edx),%eax
  8005eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f0:	eb 0e                	jmp    800600 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005f2:	8b 10                	mov    (%eax),%edx
  8005f4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005f7:	89 08                	mov    %ecx,(%eax)
  8005f9:	8b 02                	mov    (%edx),%eax
  8005fb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800600:	5d                   	pop    %ebp
  800601:	c3                   	ret    

00800602 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800608:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80060c:	8b 10                	mov    (%eax),%edx
  80060e:	3b 50 04             	cmp    0x4(%eax),%edx
  800611:	73 0a                	jae    80061d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800613:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800616:	88 0a                	mov    %cl,(%edx)
  800618:	83 c2 01             	add    $0x1,%edx
  80061b:	89 10                	mov    %edx,(%eax)
}
  80061d:	5d                   	pop    %ebp
  80061e:	c3                   	ret    

0080061f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800625:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800628:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80062c:	8b 45 10             	mov    0x10(%ebp),%eax
  80062f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	89 44 24 04          	mov    %eax,0x4(%esp)
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	89 04 24             	mov    %eax,(%esp)
  800640:	e8 02 00 00 00       	call   800647 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
  80064a:	57                   	push   %edi
  80064b:	56                   	push   %esi
  80064c:	53                   	push   %ebx
  80064d:	83 ec 3c             	sub    $0x3c,%esp
  800650:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800653:	8b 55 10             	mov    0x10(%ebp),%edx
  800656:	0f b6 02             	movzbl (%edx),%eax
  800659:	89 d3                	mov    %edx,%ebx
  80065b:	83 c3 01             	add    $0x1,%ebx
  80065e:	83 f8 25             	cmp    $0x25,%eax
  800661:	74 2b                	je     80068e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800663:	85 c0                	test   %eax,%eax
  800665:	75 10                	jne    800677 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800667:	e9 a5 03 00 00       	jmp    800a11 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80066c:	85 c0                	test   %eax,%eax
  80066e:	66 90                	xchg   %ax,%ax
  800670:	75 08                	jne    80067a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800672:	e9 9a 03 00 00       	jmp    800a11 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800677:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80067a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80067e:	89 04 24             	mov    %eax,(%esp)
  800681:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800683:	0f b6 03             	movzbl (%ebx),%eax
  800686:	83 c3 01             	add    $0x1,%ebx
  800689:	83 f8 25             	cmp    $0x25,%eax
  80068c:	75 de                	jne    80066c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80068e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800692:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800699:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80069e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8006a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006aa:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006ad:	eb 2b                	jmp    8006da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006af:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b2:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  8006b6:	eb 22                	jmp    8006da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006bb:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  8006bf:	eb 19                	jmp    8006da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8006c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006cb:	eb 0d                	jmp    8006da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8006cd:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	0f b6 03             	movzbl (%ebx),%eax
  8006dd:	0f b6 d0             	movzbl %al,%edx
  8006e0:	8d 73 01             	lea    0x1(%ebx),%esi
  8006e3:	89 75 10             	mov    %esi,0x10(%ebp)
  8006e6:	83 e8 23             	sub    $0x23,%eax
  8006e9:	3c 55                	cmp    $0x55,%al
  8006eb:	0f 87 d8 02 00 00    	ja     8009c9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  8006f1:	0f b6 c0             	movzbl %al,%eax
  8006f4:	ff 24 85 a0 49 80 00 	jmp    *0x8049a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006fb:	83 ea 30             	sub    $0x30,%edx
  8006fe:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800701:	8b 55 10             	mov    0x10(%ebp),%edx
  800704:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800707:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80070a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80070d:	83 fa 09             	cmp    $0x9,%edx
  800710:	77 4e                	ja     800760 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800712:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800715:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800718:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80071b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80071f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800722:	8d 50 d0             	lea    -0x30(%eax),%edx
  800725:	83 fa 09             	cmp    $0x9,%edx
  800728:	76 eb                	jbe    800715 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80072a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80072d:	eb 31                	jmp    800760 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8d 50 04             	lea    0x4(%eax),%edx
  800735:	89 55 14             	mov    %edx,0x14(%ebp)
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800740:	eb 1e                	jmp    800760 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800742:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800746:	0f 88 75 ff ff ff    	js     8006c1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80074f:	eb 89                	jmp    8006da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800751:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800754:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80075b:	e9 7a ff ff ff       	jmp    8006da <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800760:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800764:	0f 89 70 ff ff ff    	jns    8006da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80076a:	e9 5e ff ff ff       	jmp    8006cd <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80076f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800772:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800775:	e9 60 ff ff ff       	jmp    8006da <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8d 50 04             	lea    0x4(%eax),%edx
  800780:	89 55 14             	mov    %edx,0x14(%ebp)
  800783:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800787:	8b 00                	mov    (%eax),%eax
  800789:	89 04 24             	mov    %eax,(%esp)
  80078c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80078f:	e9 bf fe ff ff       	jmp    800653 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	89 55 14             	mov    %edx,0x14(%ebp)
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	c1 fa 1f             	sar    $0x1f,%edx
  8007a4:	31 d0                	xor    %edx,%eax
  8007a6:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007a8:	83 f8 14             	cmp    $0x14,%eax
  8007ab:	7f 0f                	jg     8007bc <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  8007ad:	8b 14 85 00 4b 80 00 	mov    0x804b00(,%eax,4),%edx
  8007b4:	85 d2                	test   %edx,%edx
  8007b6:	0f 85 35 02 00 00    	jne    8009f1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  8007bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c0:	c7 44 24 08 0f 48 80 	movl   $0x80480f,0x8(%esp)
  8007c7:	00 
  8007c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007cf:	89 34 24             	mov    %esi,(%esp)
  8007d2:	e8 48 fe ff ff       	call   80061f <_Z8printfmtPFviPvES_PKcz>
  8007d7:	e9 77 fe ff ff       	jmp    800653 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8007dc:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 50 04             	lea    0x4(%eax),%edx
  8007eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ee:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  8007f0:	85 db                	test   %ebx,%ebx
  8007f2:	ba 08 48 80 00       	mov    $0x804808,%edx
  8007f7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  8007fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007fe:	7e 72                	jle    800872 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800800:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800804:	74 6c                	je     800872 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800806:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080a:	89 1c 24             	mov    %ebx,(%esp)
  80080d:	e8 a9 02 00 00       	call   800abb <_Z7strnlenPKcj>
  800812:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800815:	29 c2                	sub    %eax,%edx
  800817:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80081a:	85 d2                	test   %edx,%edx
  80081c:	7e 54                	jle    800872 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  80081e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800822:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800825:	89 d3                	mov    %edx,%ebx
  800827:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80082a:	89 c6                	mov    %eax,%esi
  80082c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800830:	89 34 24             	mov    %esi,(%esp)
  800833:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800836:	83 eb 01             	sub    $0x1,%ebx
  800839:	85 db                	test   %ebx,%ebx
  80083b:	7f ef                	jg     80082c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80083d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800840:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800843:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80084a:	eb 26                	jmp    800872 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80084c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80084f:	83 fa 5e             	cmp    $0x5e,%edx
  800852:	76 10                	jbe    800864 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800854:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800858:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80085f:	ff 55 08             	call   *0x8(%ebp)
  800862:	eb 0a                	jmp    80086e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800864:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800868:	89 04 24             	mov    %eax,(%esp)
  80086b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80086e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800872:	0f be 03             	movsbl (%ebx),%eax
  800875:	83 c3 01             	add    $0x1,%ebx
  800878:	85 c0                	test   %eax,%eax
  80087a:	74 11                	je     80088d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80087c:	85 f6                	test   %esi,%esi
  80087e:	78 05                	js     800885 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800880:	83 ee 01             	sub    $0x1,%esi
  800883:	78 0d                	js     800892 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800885:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800889:	75 c1                	jne    80084c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80088b:	eb d7                	jmp    800864 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80088d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800890:	eb 03                	jmp    800895 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800895:	85 c0                	test   %eax,%eax
  800897:	0f 8e b6 fd ff ff    	jle    800653 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80089d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8008a0:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  8008a3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008a7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8008ae:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008b0:	83 eb 01             	sub    $0x1,%ebx
  8008b3:	85 db                	test   %ebx,%ebx
  8008b5:	7f ec                	jg     8008a3 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  8008b7:	e9 97 fd ff ff       	jmp    800653 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008bc:	83 f9 01             	cmp    $0x1,%ecx
  8008bf:	90                   	nop
  8008c0:	7e 10                	jle    8008d2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8d 50 08             	lea    0x8(%eax),%edx
  8008c8:	89 55 14             	mov    %edx,0x14(%ebp)
  8008cb:	8b 18                	mov    (%eax),%ebx
  8008cd:	8b 70 04             	mov    0x4(%eax),%esi
  8008d0:	eb 26                	jmp    8008f8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  8008d2:	85 c9                	test   %ecx,%ecx
  8008d4:	74 12                	je     8008e8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	8d 50 04             	lea    0x4(%eax),%edx
  8008dc:	89 55 14             	mov    %edx,0x14(%ebp)
  8008df:	8b 18                	mov    (%eax),%ebx
  8008e1:	89 de                	mov    %ebx,%esi
  8008e3:	c1 fe 1f             	sar    $0x1f,%esi
  8008e6:	eb 10                	jmp    8008f8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	8d 50 04             	lea    0x4(%eax),%edx
  8008ee:	89 55 14             	mov    %edx,0x14(%ebp)
  8008f1:	8b 18                	mov    (%eax),%ebx
  8008f3:	89 de                	mov    %ebx,%esi
  8008f5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008f8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008fd:	85 f6                	test   %esi,%esi
  8008ff:	0f 89 8c 00 00 00    	jns    800991 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800905:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800909:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800910:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800913:	f7 db                	neg    %ebx
  800915:	83 d6 00             	adc    $0x0,%esi
  800918:	f7 de                	neg    %esi
			}
			base = 10;
  80091a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80091f:	eb 70                	jmp    800991 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800921:	89 ca                	mov    %ecx,%edx
  800923:	8d 45 14             	lea    0x14(%ebp),%eax
  800926:	e8 9d fc ff ff       	call   8005c8 <_ZL7getuintPPci>
  80092b:	89 c3                	mov    %eax,%ebx
  80092d:	89 d6                	mov    %edx,%esi
			base = 10;
  80092f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800934:	eb 5b                	jmp    800991 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800936:	89 ca                	mov    %ecx,%edx
  800938:	8d 45 14             	lea    0x14(%ebp),%eax
  80093b:	e8 88 fc ff ff       	call   8005c8 <_ZL7getuintPPci>
  800940:	89 c3                	mov    %eax,%ebx
  800942:	89 d6                	mov    %edx,%esi
			base = 8;
  800944:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800949:	eb 46                	jmp    800991 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80094b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80094f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800956:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800959:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800964:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	8d 50 04             	lea    0x4(%eax),%edx
  80096d:	89 55 14             	mov    %edx,0x14(%ebp)
  800970:	8b 18                	mov    (%eax),%ebx
  800972:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800977:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80097c:	eb 13                	jmp    800991 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80097e:	89 ca                	mov    %ecx,%edx
  800980:	8d 45 14             	lea    0x14(%ebp),%eax
  800983:	e8 40 fc ff ff       	call   8005c8 <_ZL7getuintPPci>
  800988:	89 c3                	mov    %eax,%ebx
  80098a:	89 d6                	mov    %edx,%esi
			base = 16;
  80098c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800991:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800995:	89 54 24 10          	mov    %edx,0x10(%esp)
  800999:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80099c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a4:	89 1c 24             	mov    %ebx,(%esp)
  8009a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009ab:	89 fa                	mov    %edi,%edx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	e8 2b fb ff ff       	call   8004e0 <_ZL8printnumPFviPvES_yjii>
			break;
  8009b5:	e9 99 fc ff ff       	jmp    800653 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009be:	89 14 24             	mov    %edx,(%esp)
  8009c1:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009c4:	e9 8a fc ff ff       	jmp    800653 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009cd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009d4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009da:	89 d8                	mov    %ebx,%eax
  8009dc:	eb 02                	jmp    8009e0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  8009de:	89 d0                	mov    %edx,%eax
  8009e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009e3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009e7:	75 f5                	jne    8009de <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  8009e9:	89 45 10             	mov    %eax,0x10(%ebp)
  8009ec:	e9 62 fc ff ff       	jmp    800653 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009f5:	c7 44 24 08 26 4c 80 	movl   $0x804c26,0x8(%esp)
  8009fc:	00 
  8009fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a01:	8b 75 08             	mov    0x8(%ebp),%esi
  800a04:	89 34 24             	mov    %esi,(%esp)
  800a07:	e8 13 fc ff ff       	call   80061f <_Z8printfmtPFviPvES_PKcz>
  800a0c:	e9 42 fc ff ff       	jmp    800653 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a11:	83 c4 3c             	add    $0x3c,%esp
  800a14:	5b                   	pop    %ebx
  800a15:	5e                   	pop    %esi
  800a16:	5f                   	pop    %edi
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 28             	sub    $0x28,%esp
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800a2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a2f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a33:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800a36:	85 c0                	test   %eax,%eax
  800a38:	74 30                	je     800a6a <_Z9vsnprintfPciPKcS_+0x51>
  800a3a:	85 d2                	test   %edx,%edx
  800a3c:	7e 2c                	jle    800a6a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a45:	8b 45 10             	mov    0x10(%ebp),%eax
  800a48:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a53:	c7 04 24 02 06 80 00 	movl   $0x800602,(%esp)
  800a5a:	e8 e8 fb ff ff       	call   800647 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	eb 05                	jmp    800a6f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a6f:	c9                   	leave  
  800a70:	c3                   	ret    

00800a71 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a77:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a81:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 04 24             	mov    %eax,(%esp)
  800a92:	e8 82 ff ff ff       	call   800a19 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800a97:	c9                   	leave  
  800a98:	c3                   	ret    
  800a99:	00 00                	add    %al,(%eax)
  800a9b:	00 00                	add    %al,(%eax)
  800a9d:	00 00                	add    %al,(%eax)
	...

00800aa0 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aab:	80 3a 00             	cmpb   $0x0,(%edx)
  800aae:	74 09                	je     800ab9 <_Z6strlenPKc+0x19>
		n++;
  800ab0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab7:	75 f7                	jne    800ab0 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	74 0b                	je     800ad8 <_Z7strnlenPKcj+0x1d>
  800acd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ad1:	74 05                	je     800ad8 <_Z7strnlenPKcj+0x1d>
		n++;
  800ad3:	83 c0 01             	add    $0x1,%eax
  800ad6:	eb f1                	jmp    800ac9 <_Z7strnlenPKcj+0xe>
	return n;
}
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	53                   	push   %ebx
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800af0:	83 c2 01             	add    $0x1,%edx
  800af3:	84 c9                	test   %cl,%cl
  800af5:	75 f2                	jne    800ae9 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800af7:	5b                   	pop    %ebx
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800b08:	85 f6                	test   %esi,%esi
  800b0a:	74 18                	je     800b24 <_Z7strncpyPcPKcj+0x2a>
  800b0c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800b11:	0f b6 1a             	movzbl (%edx),%ebx
  800b14:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b17:	80 3a 01             	cmpb   $0x1,(%edx)
  800b1a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	39 ce                	cmp    %ecx,%esi
  800b22:	77 ed                	ja     800b11 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b33:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800b36:	89 f0                	mov    %esi,%eax
  800b38:	85 d2                	test   %edx,%edx
  800b3a:	74 17                	je     800b53 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800b3c:	83 ea 01             	sub    $0x1,%edx
  800b3f:	74 18                	je     800b59 <_Z7strlcpyPcPKcj+0x31>
  800b41:	80 39 00             	cmpb   $0x0,(%ecx)
  800b44:	74 17                	je     800b5d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800b46:	0f b6 19             	movzbl (%ecx),%ebx
  800b49:	88 18                	mov    %bl,(%eax)
  800b4b:	83 c0 01             	add    $0x1,%eax
  800b4e:	83 c1 01             	add    $0x1,%ecx
  800b51:	eb e9                	jmp    800b3c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800b53:	29 f0                	sub    %esi,%eax
}
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b59:	89 c2                	mov    %eax,%edx
  800b5b:	eb 02                	jmp    800b5f <_Z7strlcpyPcPKcj+0x37>
  800b5d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b5f:	c6 02 00             	movb   $0x0,(%edx)
  800b62:	eb ef                	jmp    800b53 <_Z7strlcpyPcPKcj+0x2b>

00800b64 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b6d:	0f b6 01             	movzbl (%ecx),%eax
  800b70:	84 c0                	test   %al,%al
  800b72:	74 0c                	je     800b80 <_Z6strcmpPKcS0_+0x1c>
  800b74:	3a 02                	cmp    (%edx),%al
  800b76:	75 08                	jne    800b80 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800b78:	83 c1 01             	add    $0x1,%ecx
  800b7b:	83 c2 01             	add    $0x1,%edx
  800b7e:	eb ed                	jmp    800b6d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800b80:	0f b6 c0             	movzbl %al,%eax
  800b83:	0f b6 12             	movzbl (%edx),%edx
  800b86:	29 d0                	sub    %edx,%eax
}
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	53                   	push   %ebx
  800b8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b94:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800b97:	85 d2                	test   %edx,%edx
  800b99:	74 16                	je     800bb1 <_Z7strncmpPKcS0_j+0x27>
  800b9b:	0f b6 01             	movzbl (%ecx),%eax
  800b9e:	84 c0                	test   %al,%al
  800ba0:	74 17                	je     800bb9 <_Z7strncmpPKcS0_j+0x2f>
  800ba2:	3a 03                	cmp    (%ebx),%al
  800ba4:	75 13                	jne    800bb9 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800ba6:	83 ea 01             	sub    $0x1,%edx
  800ba9:	83 c1 01             	add    $0x1,%ecx
  800bac:	83 c3 01             	add    $0x1,%ebx
  800baf:	eb e6                	jmp    800b97 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800bb6:	5b                   	pop    %ebx
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800bb9:	0f b6 01             	movzbl (%ecx),%eax
  800bbc:	0f b6 13             	movzbl (%ebx),%edx
  800bbf:	29 d0                	sub    %edx,%eax
  800bc1:	eb f3                	jmp    800bb6 <_Z7strncmpPKcS0_j+0x2c>

00800bc3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bcd:	0f b6 10             	movzbl (%eax),%edx
  800bd0:	84 d2                	test   %dl,%dl
  800bd2:	74 1f                	je     800bf3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800bd4:	38 ca                	cmp    %cl,%dl
  800bd6:	75 0a                	jne    800be2 <_Z6strchrPKcc+0x1f>
  800bd8:	eb 1e                	jmp    800bf8 <_Z6strchrPKcc+0x35>
  800bda:	38 ca                	cmp    %cl,%dl
  800bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800be0:	74 16                	je     800bf8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800be2:	83 c0 01             	add    $0x1,%eax
  800be5:	0f b6 10             	movzbl (%eax),%edx
  800be8:	84 d2                	test   %dl,%dl
  800bea:	75 ee                	jne    800bda <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	eb 05                	jmp    800bf8 <_Z6strchrPKcc+0x35>
  800bf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c04:	0f b6 10             	movzbl (%eax),%edx
  800c07:	84 d2                	test   %dl,%dl
  800c09:	74 14                	je     800c1f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800c0b:	38 ca                	cmp    %cl,%dl
  800c0d:	75 06                	jne    800c15 <_Z7strfindPKcc+0x1b>
  800c0f:	eb 0e                	jmp    800c1f <_Z7strfindPKcc+0x25>
  800c11:	38 ca                	cmp    %cl,%dl
  800c13:	74 0a                	je     800c1f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c15:	83 c0 01             	add    $0x1,%eax
  800c18:	0f b6 10             	movzbl (%eax),%edx
  800c1b:	84 d2                	test   %dl,%dl
  800c1d:	75 f2                	jne    800c11 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 0c             	sub    $0xc,%esp
  800c27:	89 1c 24             	mov    %ebx,(%esp)
  800c2a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c32:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800c3b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c41:	75 25                	jne    800c68 <memset+0x47>
  800c43:	f6 c1 03             	test   $0x3,%cl
  800c46:	75 20                	jne    800c68 <memset+0x47>
		c &= 0xFF;
  800c48:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	c1 e3 08             	shl    $0x8,%ebx
  800c50:	89 d6                	mov    %edx,%esi
  800c52:	c1 e6 18             	shl    $0x18,%esi
  800c55:	89 d0                	mov    %edx,%eax
  800c57:	c1 e0 10             	shl    $0x10,%eax
  800c5a:	09 f0                	or     %esi,%eax
  800c5c:	09 d0                	or     %edx,%eax
  800c5e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800c60:	c1 e9 02             	shr    $0x2,%ecx
  800c63:	fc                   	cld    
  800c64:	f3 ab                	rep stos %eax,%es:(%edi)
  800c66:	eb 03                	jmp    800c6b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800c68:	fc                   	cld    
  800c69:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800c6b:	89 f8                	mov    %edi,%eax
  800c6d:	8b 1c 24             	mov    (%esp),%ebx
  800c70:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c74:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c78:	89 ec                	mov    %ebp,%esp
  800c7a:	5d                   	pop    %ebp
  800c7b:	c3                   	ret    

00800c7c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	89 34 24             	mov    %esi,(%esp)
  800c85:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800c92:	39 c6                	cmp    %eax,%esi
  800c94:	73 36                	jae    800ccc <memmove+0x50>
  800c96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c99:	39 d0                	cmp    %edx,%eax
  800c9b:	73 2f                	jae    800ccc <memmove+0x50>
		s += n;
		d += n;
  800c9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800ca0:	f6 c2 03             	test   $0x3,%dl
  800ca3:	75 1b                	jne    800cc0 <memmove+0x44>
  800ca5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cab:	75 13                	jne    800cc0 <memmove+0x44>
  800cad:	f6 c1 03             	test   $0x3,%cl
  800cb0:	75 0e                	jne    800cc0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cb2:	83 ef 04             	sub    $0x4,%edi
  800cb5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb8:	c1 e9 02             	shr    $0x2,%ecx
  800cbb:	fd                   	std    
  800cbc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cbe:	eb 09                	jmp    800cc9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cc0:	83 ef 01             	sub    $0x1,%edi
  800cc3:	8d 72 ff             	lea    -0x1(%edx),%esi
  800cc6:	fd                   	std    
  800cc7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc9:	fc                   	cld    
  800cca:	eb 20                	jmp    800cec <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800ccc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cd2:	75 13                	jne    800ce7 <memmove+0x6b>
  800cd4:	a8 03                	test   $0x3,%al
  800cd6:	75 0f                	jne    800ce7 <memmove+0x6b>
  800cd8:	f6 c1 03             	test   $0x3,%cl
  800cdb:	75 0a                	jne    800ce7 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cdd:	c1 e9 02             	shr    $0x2,%ecx
  800ce0:	89 c7                	mov    %eax,%edi
  800ce2:	fc                   	cld    
  800ce3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ce5:	eb 05                	jmp    800cec <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800ce7:	89 c7                	mov    %eax,%edi
  800ce9:	fc                   	cld    
  800cea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800cec:	8b 34 24             	mov    (%esp),%esi
  800cef:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800cf3:	89 ec                	mov    %ebp,%esp
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	89 34 24             	mov    %esi,(%esp)
  800d00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800d0d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d13:	75 13                	jne    800d28 <memcpy+0x31>
  800d15:	a8 03                	test   $0x3,%al
  800d17:	75 0f                	jne    800d28 <memcpy+0x31>
  800d19:	f6 c1 03             	test   $0x3,%cl
  800d1c:	75 0a                	jne    800d28 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d1e:	c1 e9 02             	shr    $0x2,%ecx
  800d21:	89 c7                	mov    %eax,%edi
  800d23:	fc                   	cld    
  800d24:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d26:	eb 05                	jmp    800d2d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800d28:	89 c7                	mov    %eax,%edi
  800d2a:	fc                   	cld    
  800d2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800d2d:	8b 34 24             	mov    (%esp),%esi
  800d30:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d34:	89 ec                	mov    %ebp,%esp
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
  800d3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d41:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d44:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800d47:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d4c:	85 ff                	test   %edi,%edi
  800d4e:	74 38                	je     800d88 <memcmp+0x50>
		if (*s1 != *s2)
  800d50:	0f b6 03             	movzbl (%ebx),%eax
  800d53:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d56:	83 ef 01             	sub    $0x1,%edi
  800d59:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800d5e:	38 c8                	cmp    %cl,%al
  800d60:	74 1d                	je     800d7f <memcmp+0x47>
  800d62:	eb 11                	jmp    800d75 <memcmp+0x3d>
  800d64:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800d69:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800d6e:	83 c2 01             	add    $0x1,%edx
  800d71:	38 c8                	cmp    %cl,%al
  800d73:	74 0a                	je     800d7f <memcmp+0x47>
			return *s1 - *s2;
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	0f b6 c9             	movzbl %cl,%ecx
  800d7b:	29 c8                	sub    %ecx,%eax
  800d7d:	eb 09                	jmp    800d88 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d7f:	39 fa                	cmp    %edi,%edx
  800d81:	75 e1                	jne    800d64 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	53                   	push   %ebx
  800d91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800d94:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800d96:	89 da                	mov    %ebx,%edx
  800d98:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800d9b:	39 d3                	cmp    %edx,%ebx
  800d9d:	73 15                	jae    800db4 <memfind+0x27>
		if (*s == (unsigned char) c)
  800d9f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800da3:	38 0b                	cmp    %cl,(%ebx)
  800da5:	75 06                	jne    800dad <memfind+0x20>
  800da7:	eb 0b                	jmp    800db4 <memfind+0x27>
  800da9:	38 08                	cmp    %cl,(%eax)
  800dab:	74 07                	je     800db4 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800dad:	83 c0 01             	add    $0x1,%eax
  800db0:	39 c2                	cmp    %eax,%edx
  800db2:	77 f5                	ja     800da9 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800db4:	5b                   	pop    %ebx
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dc3:	0f b6 02             	movzbl (%edx),%eax
  800dc6:	3c 20                	cmp    $0x20,%al
  800dc8:	74 04                	je     800dce <_Z6strtolPKcPPci+0x17>
  800dca:	3c 09                	cmp    $0x9,%al
  800dcc:	75 0e                	jne    800ddc <_Z6strtolPKcPPci+0x25>
		s++;
  800dce:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dd1:	0f b6 02             	movzbl (%edx),%eax
  800dd4:	3c 20                	cmp    $0x20,%al
  800dd6:	74 f6                	je     800dce <_Z6strtolPKcPPci+0x17>
  800dd8:	3c 09                	cmp    $0x9,%al
  800dda:	74 f2                	je     800dce <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ddc:	3c 2b                	cmp    $0x2b,%al
  800dde:	75 0a                	jne    800dea <_Z6strtolPKcPPci+0x33>
		s++;
  800de0:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800de3:	bf 00 00 00 00       	mov    $0x0,%edi
  800de8:	eb 10                	jmp    800dfa <_Z6strtolPKcPPci+0x43>
  800dea:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800def:	3c 2d                	cmp    $0x2d,%al
  800df1:	75 07                	jne    800dfa <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800df3:	83 c2 01             	add    $0x1,%edx
  800df6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dfa:	85 db                	test   %ebx,%ebx
  800dfc:	0f 94 c0             	sete   %al
  800dff:	74 05                	je     800e06 <_Z6strtolPKcPPci+0x4f>
  800e01:	83 fb 10             	cmp    $0x10,%ebx
  800e04:	75 15                	jne    800e1b <_Z6strtolPKcPPci+0x64>
  800e06:	80 3a 30             	cmpb   $0x30,(%edx)
  800e09:	75 10                	jne    800e1b <_Z6strtolPKcPPci+0x64>
  800e0b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e0f:	75 0a                	jne    800e1b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800e11:	83 c2 02             	add    $0x2,%edx
  800e14:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e19:	eb 13                	jmp    800e2e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800e1b:	84 c0                	test   %al,%al
  800e1d:	74 0f                	je     800e2e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e1f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e24:	80 3a 30             	cmpb   $0x30,(%edx)
  800e27:	75 05                	jne    800e2e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800e29:	83 c2 01             	add    $0x1,%edx
  800e2c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e33:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e35:	0f b6 0a             	movzbl (%edx),%ecx
  800e38:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e3b:	80 fb 09             	cmp    $0x9,%bl
  800e3e:	77 08                	ja     800e48 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800e40:	0f be c9             	movsbl %cl,%ecx
  800e43:	83 e9 30             	sub    $0x30,%ecx
  800e46:	eb 1e                	jmp    800e66 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800e48:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800e4b:	80 fb 19             	cmp    $0x19,%bl
  800e4e:	77 08                	ja     800e58 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800e50:	0f be c9             	movsbl %cl,%ecx
  800e53:	83 e9 57             	sub    $0x57,%ecx
  800e56:	eb 0e                	jmp    800e66 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800e58:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800e5b:	80 fb 19             	cmp    $0x19,%bl
  800e5e:	77 15                	ja     800e75 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800e60:	0f be c9             	movsbl %cl,%ecx
  800e63:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e66:	39 f1                	cmp    %esi,%ecx
  800e68:	7d 0f                	jge    800e79 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800e6a:	83 c2 01             	add    $0x1,%edx
  800e6d:	0f af c6             	imul   %esi,%eax
  800e70:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800e73:	eb c0                	jmp    800e35 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800e75:	89 c1                	mov    %eax,%ecx
  800e77:	eb 02                	jmp    800e7b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e79:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	74 05                	je     800e86 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800e81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e84:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e86:	89 ca                	mov    %ecx,%edx
  800e88:	f7 da                	neg    %edx
  800e8a:	85 ff                	test   %edi,%edi
  800e8c:	0f 45 c2             	cmovne %edx,%eax
}
  800e8f:	5b                   	pop    %ebx
  800e90:	5e                   	pop    %esi
  800e91:	5f                   	pop    %edi
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    

00800e94 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	83 ec 0c             	sub    $0xc,%esp
  800e9a:	89 1c 24             	mov    %ebx,(%esp)
  800e9d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ea1:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ead:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb0:	89 c3                	mov    %eax,%ebx
  800eb2:	89 c7                	mov    %eax,%edi
  800eb4:	89 c6                	mov    %eax,%esi
  800eb6:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800eb8:	8b 1c 24             	mov    (%esp),%ebx
  800ebb:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ebf:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ec3:	89 ec                	mov    %ebp,%esp
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 0c             	sub    $0xc,%esp
  800ecd:	89 1c 24             	mov    %ebx,(%esp)
  800ed0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ed4:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800ed8:	ba 00 00 00 00       	mov    $0x0,%edx
  800edd:	b8 01 00 00 00       	mov    $0x1,%eax
  800ee2:	89 d1                	mov    %edx,%ecx
  800ee4:	89 d3                	mov    %edx,%ebx
  800ee6:	89 d7                	mov    %edx,%edi
  800ee8:	89 d6                	mov    %edx,%esi
  800eea:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800eec:	8b 1c 24             	mov    (%esp),%ebx
  800eef:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ef3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ef7:	89 ec                	mov    %ebp,%esp
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 38             	sub    $0x38,%esp
  800f01:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f04:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f07:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0f:	b8 03 00 00 00       	mov    $0x3,%eax
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	89 cb                	mov    %ecx,%ebx
  800f19:	89 cf                	mov    %ecx,%edi
  800f1b:	89 ce                	mov    %ecx,%esi
  800f1d:	cd 30                	int    $0x30

	if(check && ret > 0)
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	7e 28                	jle    800f4b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f27:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f2e:	00 
  800f2f:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  800f36:	00 
  800f37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3e:	00 
  800f3f:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  800f46:	e8 51 f4 ff ff       	call   80039c <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f4b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f4e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f51:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f54:	89 ec                	mov    %ebp,%esp
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    

00800f58 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 0c             	sub    $0xc,%esp
  800f5e:	89 1c 24             	mov    %ebx,(%esp)
  800f61:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f65:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f69:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6e:	b8 02 00 00 00       	mov    $0x2,%eax
  800f73:	89 d1                	mov    %edx,%ecx
  800f75:	89 d3                	mov    %edx,%ebx
  800f77:	89 d7                	mov    %edx,%edi
  800f79:	89 d6                	mov    %edx,%esi
  800f7b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f7d:	8b 1c 24             	mov    (%esp),%ebx
  800f80:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f84:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f88:	89 ec                	mov    %ebp,%esp
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 0c             	sub    $0xc,%esp
  800f92:	89 1c 24             	mov    %ebx,(%esp)
  800f95:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f99:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa2:	b8 04 00 00 00       	mov    $0x4,%eax
  800fa7:	89 d1                	mov    %edx,%ecx
  800fa9:	89 d3                	mov    %edx,%ebx
  800fab:	89 d7                	mov    %edx,%edi
  800fad:	89 d6                	mov    %edx,%esi
  800faf:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fb1:	8b 1c 24             	mov    (%esp),%ebx
  800fb4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fb8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fbc:	89 ec                	mov    %ebp,%esp
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 38             	sub    $0x38,%esp
  800fc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fcc:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fcf:	be 00 00 00 00       	mov    $0x0,%esi
  800fd4:	b8 08 00 00 00       	mov    $0x8,%eax
  800fd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	89 f7                	mov    %esi,%edi
  800fe4:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	7e 28                	jle    801012 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fea:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fee:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ff5:	00 
  800ff6:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  800ffd:	00 
  800ffe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801005:	00 
  801006:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  80100d:	e8 8a f3 ff ff       	call   80039c <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801012:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801015:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801018:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101b:	89 ec                	mov    %ebp,%esp
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 38             	sub    $0x38,%esp
  801025:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801028:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80102e:	b8 09 00 00 00       	mov    $0x9,%eax
  801033:	8b 75 18             	mov    0x18(%ebp),%esi
  801036:	8b 7d 14             	mov    0x14(%ebp),%edi
  801039:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	cd 30                	int    $0x30

	if(check && ret > 0)
  801044:	85 c0                	test   %eax,%eax
  801046:	7e 28                	jle    801070 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801048:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801053:	00 
  801054:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  80105b:	00 
  80105c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801063:	00 
  801064:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  80106b:	e8 2c f3 ff ff       	call   80039c <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801070:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801073:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801076:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801079:	89 ec                	mov    %ebp,%esp
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 38             	sub    $0x38,%esp
  801083:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801086:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801089:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80108c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801091:	b8 0a 00 00 00       	mov    $0xa,%eax
  801096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801099:	8b 55 08             	mov    0x8(%ebp),%edx
  80109c:	89 df                	mov    %ebx,%edi
  80109e:	89 de                	mov    %ebx,%esi
  8010a0:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	7e 28                	jle    8010ce <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010aa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010b1:	00 
  8010b2:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  8010b9:	00 
  8010ba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c1:	00 
  8010c2:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  8010c9:	e8 ce f2 ff ff       	call   80039c <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010ce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d7:	89 ec                	mov    %ebp,%esp
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 38             	sub    $0x38,%esp
  8010e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010e7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8010f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fa:	89 df                	mov    %ebx,%edi
  8010fc:	89 de                	mov    %ebx,%esi
  8010fe:	cd 30                	int    $0x30

	if(check && ret > 0)
  801100:	85 c0                	test   %eax,%eax
  801102:	7e 28                	jle    80112c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801104:	89 44 24 10          	mov    %eax,0x10(%esp)
  801108:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80110f:	00 
  801110:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  801117:	00 
  801118:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80111f:	00 
  801120:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  801127:	e8 70 f2 ff ff       	call   80039c <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80112c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80112f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801132:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801135:	89 ec                	mov    %ebp,%esp
  801137:	5d                   	pop    %ebp
  801138:	c3                   	ret    

00801139 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 38             	sub    $0x38,%esp
  80113f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801142:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801145:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801148:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114d:	b8 06 00 00 00       	mov    $0x6,%eax
  801152:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 df                	mov    %ebx,%edi
  80115a:	89 de                	mov    %ebx,%esi
  80115c:	cd 30                	int    $0x30

	if(check && ret > 0)
  80115e:	85 c0                	test   %eax,%eax
  801160:	7e 28                	jle    80118a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801162:	89 44 24 10          	mov    %eax,0x10(%esp)
  801166:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80116d:	00 
  80116e:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  801175:	00 
  801176:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80117d:	00 
  80117e:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  801185:	e8 12 f2 ff ff       	call   80039c <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80118a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80118d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801190:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801193:	89 ec                	mov    %ebp,%esp
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 38             	sub    $0x38,%esp
  80119d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011a0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011a3:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ab:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b6:	89 df                	mov    %ebx,%edi
  8011b8:	89 de                	mov    %ebx,%esi
  8011ba:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	7e 28                	jle    8011e8 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c4:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8011cb:	00 
  8011cc:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  8011d3:	00 
  8011d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011db:	00 
  8011dc:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  8011e3:	e8 b4 f1 ff ff       	call   80039c <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011e8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011eb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011f1:	89 ec                	mov    %ebp,%esp
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    

008011f5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 38             	sub    $0x38,%esp
  8011fb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011fe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801201:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801204:	bb 00 00 00 00       	mov    $0x0,%ebx
  801209:	b8 0c 00 00 00       	mov    $0xc,%eax
  80120e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801211:	8b 55 08             	mov    0x8(%ebp),%edx
  801214:	89 df                	mov    %ebx,%edi
  801216:	89 de                	mov    %ebx,%esi
  801218:	cd 30                	int    $0x30

	if(check && ret > 0)
  80121a:	85 c0                	test   %eax,%eax
  80121c:	7e 28                	jle    801246 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80121e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801222:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801229:	00 
  80122a:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  801231:	00 
  801232:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801239:	00 
  80123a:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  801241:	e8 56 f1 ff ff       	call   80039c <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801246:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801249:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80124c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80124f:	89 ec                	mov    %ebp,%esp
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	89 1c 24             	mov    %ebx,(%esp)
  80125c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801260:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801264:	be 00 00 00 00       	mov    $0x0,%esi
  801269:	b8 0d 00 00 00       	mov    $0xd,%eax
  80126e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801271:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801274:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801277:	8b 55 08             	mov    0x8(%ebp),%edx
  80127a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80127c:	8b 1c 24             	mov    (%esp),%ebx
  80127f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801283:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801287:	89 ec                	mov    %ebp,%esp
  801289:	5d                   	pop    %ebp
  80128a:	c3                   	ret    

0080128b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	83 ec 38             	sub    $0x38,%esp
  801291:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801294:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801297:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80129a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80129f:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a7:	89 cb                	mov    %ecx,%ebx
  8012a9:	89 cf                	mov    %ecx,%edi
  8012ab:	89 ce                	mov    %ecx,%esi
  8012ad:	cd 30                	int    $0x30

	if(check && ret > 0)
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	7e 28                	jle    8012db <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b7:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  8012be:	00 
  8012bf:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  8012c6:	00 
  8012c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ce:	00 
  8012cf:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  8012d6:	e8 c1 f0 ff ff       	call   80039c <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012db:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012de:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012e1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012e4:	89 ec                	mov    %ebp,%esp
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    

008012e8 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 0c             	sub    $0xc,%esp
  8012ee:	89 1c 24             	mov    %ebx,(%esp)
  8012f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fe:	b8 0f 00 00 00       	mov    $0xf,%eax
  801303:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801306:	8b 55 08             	mov    0x8(%ebp),%edx
  801309:	89 df                	mov    %ebx,%edi
  80130b:	89 de                	mov    %ebx,%esi
  80130d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80130f:	8b 1c 24             	mov    (%esp),%ebx
  801312:	8b 74 24 04          	mov    0x4(%esp),%esi
  801316:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80131a:	89 ec                	mov    %ebp,%esp
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    

0080131e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 0c             	sub    $0xc,%esp
  801324:	89 1c 24             	mov    %ebx,(%esp)
  801327:	89 74 24 04          	mov    %esi,0x4(%esp)
  80132b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80132f:	ba 00 00 00 00       	mov    $0x0,%edx
  801334:	b8 11 00 00 00       	mov    $0x11,%eax
  801339:	89 d1                	mov    %edx,%ecx
  80133b:	89 d3                	mov    %edx,%ebx
  80133d:	89 d7                	mov    %edx,%edi
  80133f:	89 d6                	mov    %edx,%esi
  801341:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801343:	8b 1c 24             	mov    (%esp),%ebx
  801346:	8b 74 24 04          	mov    0x4(%esp),%esi
  80134a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80134e:	89 ec                	mov    %ebp,%esp
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    

00801352 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	83 ec 0c             	sub    $0xc,%esp
  801358:	89 1c 24             	mov    %ebx,(%esp)
  80135b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80135f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801363:	bb 00 00 00 00       	mov    $0x0,%ebx
  801368:	b8 12 00 00 00       	mov    $0x12,%eax
  80136d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801370:	8b 55 08             	mov    0x8(%ebp),%edx
  801373:	89 df                	mov    %ebx,%edi
  801375:	89 de                	mov    %ebx,%esi
  801377:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801379:	8b 1c 24             	mov    (%esp),%ebx
  80137c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801380:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801384:	89 ec                	mov    %ebp,%esp
  801386:	5d                   	pop    %ebp
  801387:	c3                   	ret    

00801388 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	83 ec 0c             	sub    $0xc,%esp
  80138e:	89 1c 24             	mov    %ebx,(%esp)
  801391:	89 74 24 04          	mov    %esi,0x4(%esp)
  801395:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801399:	b9 00 00 00 00       	mov    $0x0,%ecx
  80139e:	b8 13 00 00 00       	mov    $0x13,%eax
  8013a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a6:	89 cb                	mov    %ecx,%ebx
  8013a8:	89 cf                	mov    %ecx,%edi
  8013aa:	89 ce                	mov    %ecx,%esi
  8013ac:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  8013ae:	8b 1c 24             	mov    (%esp),%ebx
  8013b1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013b5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013b9:	89 ec                	mov    %ebp,%esp
  8013bb:	5d                   	pop    %ebp
  8013bc:	c3                   	ret    

008013bd <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	89 1c 24             	mov    %ebx,(%esp)
  8013c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ca:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013ce:	b8 10 00 00 00       	mov    $0x10,%eax
  8013d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8013d6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013df:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e2:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  8013e4:	8b 1c 24             	mov    (%esp),%ebx
  8013e7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013eb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013ef:	89 ec                	mov    %ebp,%esp
  8013f1:	5d                   	pop    %ebp
  8013f2:	c3                   	ret    
	...

008013f4 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 38             	sub    $0x38,%esp
  8013fa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013fd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801400:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  801403:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  80140a:	f6 c7 04             	test   $0x4,%bh
  80140d:	74 31                	je     801440 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  80140f:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  801416:	c1 e2 0c             	shl    $0xc,%edx
  801419:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80141f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801423:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801427:	89 44 24 08          	mov    %eax,0x8(%esp)
  80142b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80142f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801436:	e8 e4 fb ff ff       	call   80101f <_Z12sys_page_mapiPviS_i>
        return r;
  80143b:	e9 8c 00 00 00       	jmp    8014cc <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  801440:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  801447:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  80144c:	f7 c6 00 08 00 00    	test   $0x800,%esi
  801452:	75 2a                	jne    80147e <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  801454:	84 c9                	test   %cl,%cl
  801456:	74 0f                	je     801467 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  801458:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  80145f:	83 e3 02             	and    $0x2,%ebx
  801462:	80 cf 02             	or     $0x2,%bh
  801465:	eb 17                	jmp    80147e <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  801467:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  80146e:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  801471:	83 f9 01             	cmp    $0x1,%ecx
  801474:	19 db                	sbb    %ebx,%ebx
  801476:	f7 d3                	not    %ebx
  801478:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80147e:	89 df                	mov    %ebx,%edi
  801480:	83 cf 05             	or     $0x5,%edi
  801483:	89 d6                	mov    %edx,%esi
  801485:	c1 e6 0c             	shl    $0xc,%esi
  801488:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80148c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801490:	89 44 24 08          	mov    %eax,0x8(%esp)
  801494:	89 74 24 04          	mov    %esi,0x4(%esp)
  801498:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80149f:	e8 7b fb ff ff       	call   80101f <_Z12sys_page_mapiPviS_i>
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	75 24                	jne    8014cc <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  8014a8:	85 db                	test   %ebx,%ebx
  8014aa:	74 20                	je     8014cc <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  8014ac:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8014b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014b4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014bb:	00 
  8014bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c7:	e8 53 fb ff ff       	call   80101f <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  8014cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014cf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014d5:	89 ec                	mov    %ebp,%esp
  8014d7:	5d                   	pop    %ebp
  8014d8:	c3                   	ret    

008014d9 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 28             	sub    $0x28,%esp
  8014df:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8014e2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8014e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  8014e8:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  8014ea:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  8014ee:	0f 84 ff 00 00 00    	je     8015f3 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  8014f4:	89 f0                	mov    %esi,%eax
  8014f6:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  8014f9:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801500:	f6 c4 08             	test   $0x8,%ah
  801503:	0f 84 ea 00 00 00    	je     8015f3 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801509:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801510:	00 
  801511:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801518:	00 
  801519:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801520:	e8 9b fa ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  801525:	85 c0                	test   %eax,%eax
  801527:	79 20                	jns    801549 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  801529:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80152d:	c7 44 24 08 7f 4b 80 	movl   $0x804b7f,0x8(%esp)
  801534:	00 
  801535:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  80153c:	00 
  80153d:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  801544:	e8 53 ee ff ff       	call   80039c <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  801549:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  80154f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801556:	00 
  801557:	89 74 24 04          	mov    %esi,0x4(%esp)
  80155b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801562:	e8 90 f7 ff ff       	call   800cf7 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801567:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80156e:	00 
  80156f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801573:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80157a:	00 
  80157b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801582:	00 
  801583:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80158a:	e8 90 fa ff ff       	call   80101f <_Z12sys_page_mapiPviS_i>
  80158f:	85 c0                	test   %eax,%eax
  801591:	79 20                	jns    8015b3 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  801593:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801597:	c7 44 24 08 9d 4b 80 	movl   $0x804b9d,0x8(%esp)
  80159e:	00 
  80159f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8015a6:	00 
  8015a7:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  8015ae:	e8 e9 ed ff ff       	call   80039c <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  8015b3:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8015ba:	00 
  8015bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015c2:	e8 b6 fa ff ff       	call   80107d <_Z14sys_page_unmapiPv>
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	79 20                	jns    8015eb <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  8015cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015cf:	c7 44 24 08 ae 4b 80 	movl   $0x804bae,0x8(%esp)
  8015d6:	00 
  8015d7:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8015de:	00 
  8015df:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  8015e6:	e8 b1 ed ff ff       	call   80039c <_Z6_panicPKciS0_z>
    resume(utf);
  8015eb:	89 1c 24             	mov    %ebx,(%esp)
  8015ee:	e8 fd 2c 00 00       	call   8042f0 <resume>
}
  8015f3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015f6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015f9:	89 ec                	mov    %ebp,%esp
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	57                   	push   %edi
  801601:	56                   	push   %esi
  801602:	53                   	push   %ebx
  801603:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  801606:	c7 04 24 d9 14 80 00 	movl   $0x8014d9,(%esp)
  80160d:	e8 09 2c 00 00       	call   80421b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  801612:	be 07 00 00 00       	mov    $0x7,%esi
  801617:	89 f0                	mov    %esi,%eax
  801619:	cd 30                	int    $0x30
  80161b:	89 c6                	mov    %eax,%esi
  80161d:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  80161f:	85 c0                	test   %eax,%eax
  801621:	79 20                	jns    801643 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  801623:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801627:	c7 44 24 08 c1 4b 80 	movl   $0x804bc1,0x8(%esp)
  80162e:	00 
  80162f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801636:	00 
  801637:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  80163e:	e8 59 ed ff ff       	call   80039c <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801643:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  801648:	85 c0                	test   %eax,%eax
  80164a:	75 1c                	jne    801668 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  80164c:	e8 07 f9 ff ff       	call   800f58 <_Z12sys_getenvidv>
  801651:	25 ff 03 00 00       	and    $0x3ff,%eax
  801656:	6b c0 78             	imul   $0x78,%eax,%eax
  801659:	05 00 00 00 ef       	add    $0xef000000,%eax
  80165e:	a3 00 70 80 00       	mov    %eax,0x807000
        return 0;
  801663:	e9 de 00 00 00       	jmp    801746 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  801668:	89 d8                	mov    %ebx,%eax
  80166a:	c1 f8 0a             	sar    $0xa,%eax
  80166d:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801674:	a8 01                	test   $0x1,%al
  801676:	75 08                	jne    801680 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  801678:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  80167e:	eb 19                	jmp    801699 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  801680:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801687:	a8 01                	test   $0x1,%al
  801689:	74 0e                	je     801699 <_Z4forkv+0x9c>
            duppage(envid, pn);
  80168b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801690:	89 da                	mov    %ebx,%edx
  801692:	89 f8                	mov    %edi,%eax
  801694:	e8 5b fd ff ff       	call   8013f4 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801699:	83 eb 01             	sub    $0x1,%ebx
  80169c:	79 ca                	jns    801668 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  80169e:	a1 00 70 80 00       	mov    0x807000,%eax
  8016a3:	8b 40 5c             	mov    0x5c(%eax),%eax
  8016a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016aa:	89 34 24             	mov    %esi,(%esp)
  8016ad:	e8 43 fb ff ff       	call   8011f5 <_Z26sys_env_set_pgfault_upcalliPv>
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	74 20                	je     8016d6 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  8016b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016ba:	c7 44 24 08 e8 4b 80 	movl   $0x804be8,0x8(%esp)
  8016c1:	00 
  8016c2:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  8016c9:	00 
  8016ca:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  8016d1:	e8 c6 ec ff ff       	call   80039c <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8016d6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016dd:	00 
  8016de:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8016e5:	ee 
  8016e6:	89 34 24             	mov    %esi,(%esp)
  8016e9:	e8 d2 f8 ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	79 20                	jns    801712 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  8016f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016f6:	c7 44 24 08 7f 4b 80 	movl   $0x804b7f,0x8(%esp)
  8016fd:	00 
  8016fe:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  801705:	00 
  801706:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  80170d:	e8 8a ec ff ff       	call   80039c <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801712:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801719:	00 
  80171a:	89 34 24             	mov    %esi,(%esp)
  80171d:	e8 b9 f9 ff ff       	call   8010db <_Z18sys_env_set_statusii>
  801722:	85 c0                	test   %eax,%eax
  801724:	79 20                	jns    801746 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  801726:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80172a:	c7 44 24 08 d1 4b 80 	movl   $0x804bd1,0x8(%esp)
  801731:	00 
  801732:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801739:	00 
  80173a:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  801741:	e8 56 ec ff ff       	call   80039c <_Z6_panicPKciS0_z>

    return envid;
}
  801746:	89 f0                	mov    %esi,%eax
  801748:	83 c4 1c             	add    $0x1c,%esp
  80174b:	5b                   	pop    %ebx
  80174c:	5e                   	pop    %esi
  80174d:	5f                   	pop    %edi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	57                   	push   %edi
  801754:	56                   	push   %esi
  801755:	53                   	push   %ebx
  801756:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  801759:	c7 04 24 d9 14 80 00 	movl   $0x8014d9,(%esp)
  801760:	e8 b6 2a 00 00       	call   80421b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  801765:	be 07 00 00 00       	mov    $0x7,%esi
  80176a:	89 f0                	mov    %esi,%eax
  80176c:	cd 30                	int    $0x30
  80176e:	89 c6                	mov    %eax,%esi
  801770:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  801772:	85 c0                	test   %eax,%eax
  801774:	79 20                	jns    801796 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  801776:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80177a:	c7 44 24 08 c1 4b 80 	movl   $0x804bc1,0x8(%esp)
  801781:	00 
  801782:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  801789:	00 
  80178a:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  801791:	e8 06 ec ff ff       	call   80039c <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  801796:	85 c0                	test   %eax,%eax
  801798:	0f 84 40 01 00 00    	je     8018de <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  80179e:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  8017a0:	c1 eb 0c             	shr    $0xc,%ebx
  8017a3:	83 eb 01             	sub    $0x1,%ebx
  8017a6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  8017a9:	eb 31                	jmp    8017dc <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  8017ab:	89 d8                	mov    %ebx,%eax
  8017ad:	c1 f8 0a             	sar    $0xa,%eax
  8017b0:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8017b7:	a8 01                	test   $0x1,%al
  8017b9:	75 08                	jne    8017c3 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  8017bb:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8017c1:	eb 19                	jmp    8017dc <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  8017c3:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8017ca:	a8 01                	test   $0x1,%al
  8017cc:	74 0e                	je     8017dc <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  8017ce:	b9 01 00 00 00       	mov    $0x1,%ecx
  8017d3:	89 da                	mov    %ebx,%edx
  8017d5:	89 f8                	mov    %edi,%eax
  8017d7:	e8 18 fc ff ff       	call   8013f4 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  8017dc:	83 eb 01             	sub    $0x1,%ebx
  8017df:	79 ca                	jns    8017ab <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  8017e1:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  8017e8:	7f 3f                	jg     801829 <_Z5sforkv+0xd9>
  8017ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  8017ed:	89 d8                	mov    %ebx,%eax
  8017ef:	c1 f8 0a             	sar    $0xa,%eax
  8017f2:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8017f9:	a8 01                	test   $0x1,%al
  8017fb:	75 08                	jne    801805 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  8017fd:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801803:	eb 19                	jmp    80181e <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  801805:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  80180c:	a8 01                	test   $0x1,%al
  80180e:	74 0e                	je     80181e <_Z5sforkv+0xce>
            duppage(envid, i);
  801810:	b9 00 00 00 00       	mov    $0x0,%ecx
  801815:	89 da                	mov    %ebx,%edx
  801817:	89 f8                	mov    %edi,%eax
  801819:	e8 d6 fb ff ff       	call   8013f4 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  80181e:	83 c3 01             	add    $0x1,%ebx
  801821:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  801827:	7e c4                	jle    8017ed <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  801829:	e8 2a f7 ff ff       	call   800f58 <_Z12sys_getenvidv>
  80182e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801833:	6b c0 78             	imul   $0x78,%eax,%eax
  801836:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  80183b:	8b 40 50             	mov    0x50(%eax),%eax
  80183e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801842:	89 34 24             	mov    %esi,(%esp)
  801845:	e8 ab f9 ff ff       	call   8011f5 <_Z26sys_env_set_pgfault_upcalliPv>
  80184a:	85 c0                	test   %eax,%eax
  80184c:	74 20                	je     80186e <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  80184e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801852:	c7 44 24 08 e8 4b 80 	movl   $0x804be8,0x8(%esp)
  801859:	00 
  80185a:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801861:	00 
  801862:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  801869:	e8 2e eb ff ff       	call   80039c <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80186e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801875:	00 
  801876:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  80187d:	ee 
  80187e:	89 34 24             	mov    %esi,(%esp)
  801881:	e8 3a f7 ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  801886:	85 c0                	test   %eax,%eax
  801888:	79 20                	jns    8018aa <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  80188a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80188e:	c7 44 24 08 7f 4b 80 	movl   $0x804b7f,0x8(%esp)
  801895:	00 
  801896:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  80189d:	00 
  80189e:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  8018a5:	e8 f2 ea ff ff       	call   80039c <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8018aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018b1:	00 
  8018b2:	89 34 24             	mov    %esi,(%esp)
  8018b5:	e8 21 f8 ff ff       	call   8010db <_Z18sys_env_set_statusii>
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	79 20                	jns    8018de <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  8018be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018c2:	c7 44 24 08 d1 4b 80 	movl   $0x804bd1,0x8(%esp)
  8018c9:	00 
  8018ca:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  8018d1:	00 
  8018d2:	c7 04 24 92 4b 80 00 	movl   $0x804b92,(%esp)
  8018d9:	e8 be ea ff ff       	call   80039c <_Z6_panicPKciS0_z>

    return envid;
    
}
  8018de:	89 f0                	mov    %esi,%eax
  8018e0:	83 c4 2c             	add    $0x2c,%esp
  8018e3:	5b                   	pop    %ebx
  8018e4:	5e                   	pop    %esi
  8018e5:	5f                   	pop    %edi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    
	...

008018f0 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8018f3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8018f8:	75 11                	jne    80190b <_ZL8fd_validPK2Fd+0x1b>
  8018fa:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  8018ff:	76 0a                	jbe    80190b <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801901:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801906:	0f 96 c0             	setbe  %al
  801909:	eb 05                	jmp    801910 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  80190b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801910:	5d                   	pop    %ebp
  801911:	c3                   	ret    

00801912 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	53                   	push   %ebx
  801916:	83 ec 14             	sub    $0x14,%esp
  801919:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  80191b:	e8 d0 ff ff ff       	call   8018f0 <_ZL8fd_validPK2Fd>
  801920:	84 c0                	test   %al,%al
  801922:	75 24                	jne    801948 <_ZL9fd_isopenPK2Fd+0x36>
  801924:	c7 44 24 0c 07 4c 80 	movl   $0x804c07,0xc(%esp)
  80192b:	00 
  80192c:	c7 44 24 08 14 4c 80 	movl   $0x804c14,0x8(%esp)
  801933:	00 
  801934:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80193b:	00 
  80193c:	c7 04 24 29 4c 80 00 	movl   $0x804c29,(%esp)
  801943:	e8 54 ea ff ff       	call   80039c <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	c1 e8 16             	shr    $0x16,%eax
  80194d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
  801959:	f6 c2 01             	test   $0x1,%dl
  80195c:	74 0d                	je     80196b <_ZL9fd_isopenPK2Fd+0x59>
  80195e:	c1 eb 0c             	shr    $0xc,%ebx
  801961:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801968:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80196b:	83 c4 14             	add    $0x14,%esp
  80196e:	5b                   	pop    %ebx
  80196f:	5d                   	pop    %ebp
  801970:	c3                   	ret    

00801971 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	89 1c 24             	mov    %ebx,(%esp)
  80197a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80197e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801981:	8b 75 0c             	mov    0xc(%ebp),%esi
  801984:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801988:	83 fb 1f             	cmp    $0x1f,%ebx
  80198b:	77 18                	ja     8019a5 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80198d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801993:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801996:	84 c0                	test   %al,%al
  801998:	74 21                	je     8019bb <_Z9fd_lookupiPP2Fdb+0x4a>
  80199a:	89 d8                	mov    %ebx,%eax
  80199c:	e8 71 ff ff ff       	call   801912 <_ZL9fd_isopenPK2Fd>
  8019a1:	84 c0                	test   %al,%al
  8019a3:	75 16                	jne    8019bb <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  8019a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  8019ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  8019b0:	8b 1c 24             	mov    (%esp),%ebx
  8019b3:	8b 74 24 04          	mov    0x4(%esp),%esi
  8019b7:	89 ec                	mov    %ebp,%esp
  8019b9:	5d                   	pop    %ebp
  8019ba:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  8019bb:	89 1e                	mov    %ebx,(%esi)
		return 0;
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c2:	eb ec                	jmp    8019b0 <_Z9fd_lookupiPP2Fdb+0x3f>

008019c4 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	53                   	push   %ebx
  8019c8:	83 ec 14             	sub    $0x14,%esp
  8019cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  8019ce:	89 d8                	mov    %ebx,%eax
  8019d0:	e8 1b ff ff ff       	call   8018f0 <_ZL8fd_validPK2Fd>
  8019d5:	84 c0                	test   %al,%al
  8019d7:	75 24                	jne    8019fd <_Z6fd2numP2Fd+0x39>
  8019d9:	c7 44 24 0c 07 4c 80 	movl   $0x804c07,0xc(%esp)
  8019e0:	00 
  8019e1:	c7 44 24 08 14 4c 80 	movl   $0x804c14,0x8(%esp)
  8019e8:	00 
  8019e9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8019f0:	00 
  8019f1:	c7 04 24 29 4c 80 00 	movl   $0x804c29,(%esp)
  8019f8:	e8 9f e9 ff ff       	call   80039c <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019fd:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801a03:	c1 e8 0c             	shr    $0xc,%eax
}
  801a06:	83 c4 14             	add    $0x14,%esp
  801a09:	5b                   	pop    %ebx
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	89 04 24             	mov    %eax,(%esp)
  801a18:	e8 a7 ff ff ff       	call   8019c4 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  801a1d:	05 20 00 0d 00       	add    $0xd0020,%eax
  801a22:	c1 e0 0c             	shl    $0xc,%eax
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	57                   	push   %edi
  801a2b:	56                   	push   %esi
  801a2c:	53                   	push   %ebx
  801a2d:	83 ec 2c             	sub    $0x2c,%esp
  801a30:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801a33:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801a38:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  801a3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a42:	00 
  801a43:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a47:	89 1c 24             	mov    %ebx,(%esp)
  801a4a:	e8 22 ff ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  801a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a52:	e8 bb fe ff ff       	call   801912 <_ZL9fd_isopenPK2Fd>
  801a57:	84 c0                	test   %al,%al
  801a59:	75 0c                	jne    801a67 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  801a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a5e:	89 07                	mov    %eax,(%edi)
			return 0;
  801a60:	b8 00 00 00 00       	mov    $0x0,%eax
  801a65:	eb 13                	jmp    801a7a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801a67:	83 c3 01             	add    $0x1,%ebx
  801a6a:	83 fb 20             	cmp    $0x20,%ebx
  801a6d:	75 cc                	jne    801a3b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a6f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801a75:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801a7a:	83 c4 2c             	add    $0x2c,%esp
  801a7d:	5b                   	pop    %ebx
  801a7e:	5e                   	pop    %esi
  801a7f:	5f                   	pop    %edi
  801a80:	5d                   	pop    %ebp
  801a81:	c3                   	ret    

00801a82 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	53                   	push   %ebx
  801a86:	83 ec 14             	sub    $0x14,%esp
  801a89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  801a8f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a94:	39 0d 08 60 80 00    	cmp    %ecx,0x806008
  801a9a:	75 16                	jne    801ab2 <_Z10dev_lookupiPP3Dev+0x30>
  801a9c:	eb 06                	jmp    801aa4 <_Z10dev_lookupiPP3Dev+0x22>
  801a9e:	39 0a                	cmp    %ecx,(%edx)
  801aa0:	75 10                	jne    801ab2 <_Z10dev_lookupiPP3Dev+0x30>
  801aa2:	eb 05                	jmp    801aa9 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801aa4:	ba 08 60 80 00       	mov    $0x806008,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801aa9:	89 13                	mov    %edx,(%ebx)
			return 0;
  801aab:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab0:	eb 35                	jmp    801ae7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ab2:	83 c0 01             	add    $0x1,%eax
  801ab5:	8b 14 85 94 4c 80 00 	mov    0x804c94(,%eax,4),%edx
  801abc:	85 d2                	test   %edx,%edx
  801abe:	75 de                	jne    801a9e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ac0:	a1 00 70 80 00       	mov    0x807000,%eax
  801ac5:	8b 40 04             	mov    0x4(%eax),%eax
  801ac8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801acc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad0:	c7 04 24 50 4c 80 00 	movl   $0x804c50,(%esp)
  801ad7:	e8 de e9 ff ff       	call   8004ba <_Z7cprintfPKcz>
	*dev = 0;
  801adc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801ae2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ae7:	83 c4 14             	add    $0x14,%esp
  801aea:	5b                   	pop    %ebx
  801aeb:	5d                   	pop    %ebp
  801aec:	c3                   	ret    

00801aed <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	56                   	push   %esi
  801af1:	53                   	push   %ebx
  801af2:	83 ec 20             	sub    $0x20,%esp
  801af5:	8b 75 08             	mov    0x8(%ebp),%esi
  801af8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  801afc:	89 34 24             	mov    %esi,(%esp)
  801aff:	e8 c0 fe ff ff       	call   8019c4 <_Z6fd2numP2Fd>
  801b04:	0f b6 d3             	movzbl %bl,%edx
  801b07:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b0b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b0e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b12:	89 04 24             	mov    %eax,(%esp)
  801b15:	e8 57 fe ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 05                	js     801b23 <_Z8fd_closeP2Fdb+0x36>
  801b1e:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801b21:	74 0c                	je     801b2f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801b23:	80 fb 01             	cmp    $0x1,%bl
  801b26:	19 db                	sbb    %ebx,%ebx
  801b28:	f7 d3                	not    %ebx
  801b2a:	83 e3 fd             	and    $0xfffffffd,%ebx
  801b2d:	eb 3d                	jmp    801b6c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b32:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b36:	8b 06                	mov    (%esi),%eax
  801b38:	89 04 24             	mov    %eax,(%esp)
  801b3b:	e8 42 ff ff ff       	call   801a82 <_Z10dev_lookupiPP3Dev>
  801b40:	89 c3                	mov    %eax,%ebx
  801b42:	85 c0                	test   %eax,%eax
  801b44:	78 16                	js     801b5c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b49:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801b4c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801b51:	85 c0                	test   %eax,%eax
  801b53:	74 07                	je     801b5c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801b55:	89 34 24             	mov    %esi,(%esp)
  801b58:	ff d0                	call   *%eax
  801b5a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801b5c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b67:	e8 11 f5 ff ff       	call   80107d <_Z14sys_page_unmapiPv>
	return r;
}
  801b6c:	89 d8                	mov    %ebx,%eax
  801b6e:	83 c4 20             	add    $0x20,%esp
  801b71:	5b                   	pop    %ebx
  801b72:	5e                   	pop    %esi
  801b73:	5d                   	pop    %ebp
  801b74:	c3                   	ret    

00801b75 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801b7b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801b82:	00 
  801b83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b86:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	89 04 24             	mov    %eax,(%esp)
  801b90:	e8 dc fd ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  801b95:	85 c0                	test   %eax,%eax
  801b97:	78 13                	js     801bac <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801b99:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ba0:	00 
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	89 04 24             	mov    %eax,(%esp)
  801ba7:	e8 41 ff ff ff       	call   801aed <_Z8fd_closeP2Fdb>
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <_Z9close_allv>:

void
close_all(void)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	53                   	push   %ebx
  801bb2:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801bb5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801bba:	89 1c 24             	mov    %ebx,(%esp)
  801bbd:	e8 b3 ff ff ff       	call   801b75 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801bc2:	83 c3 01             	add    $0x1,%ebx
  801bc5:	83 fb 20             	cmp    $0x20,%ebx
  801bc8:	75 f0                	jne    801bba <_Z9close_allv+0xc>
		close(i);
}
  801bca:	83 c4 14             	add    $0x14,%esp
  801bcd:	5b                   	pop    %ebx
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    

00801bd0 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 48             	sub    $0x48,%esp
  801bd6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801bd9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801bdc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bdf:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801be2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801be9:	00 
  801bea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801bed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	89 04 24             	mov    %eax,(%esp)
  801bf7:	e8 75 fd ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  801bfc:	89 c3                	mov    %eax,%ebx
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	0f 88 ce 00 00 00    	js     801cd4 <_Z3dupii+0x104>
  801c06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c0d:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  801c0e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801c11:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801c15:	89 34 24             	mov    %esi,(%esp)
  801c18:	e8 54 fd ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  801c1d:	89 c3                	mov    %eax,%ebx
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	0f 89 bc 00 00 00    	jns    801ce3 <_Z3dupii+0x113>
  801c27:	e9 a8 00 00 00       	jmp    801cd4 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801c2c:	89 d8                	mov    %ebx,%eax
  801c2e:	c1 e8 0c             	shr    $0xc,%eax
  801c31:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801c38:	f6 c2 01             	test   $0x1,%dl
  801c3b:	74 32                	je     801c6f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c3d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801c44:	25 07 0e 00 00       	and    $0xe07,%eax
  801c49:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c51:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c58:	00 
  801c59:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c64:	e8 b6 f3 ff ff       	call   80101f <_Z12sys_page_mapiPviS_i>
  801c69:	89 c3                	mov    %eax,%ebx
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	78 3e                	js     801cad <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c72:	89 c2                	mov    %eax,%edx
  801c74:	c1 ea 0c             	shr    $0xc,%edx
  801c77:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  801c7e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801c84:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c8f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c96:	00 
  801c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca2:	e8 78 f3 ff ff       	call   80101f <_Z12sys_page_mapiPviS_i>
  801ca7:	89 c3                	mov    %eax,%ebx
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	79 25                	jns    801cd2 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cbb:	e8 bd f3 ff ff       	call   80107d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801cc0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ccb:	e8 ad f3 ff ff       	call   80107d <_Z14sys_page_unmapiPv>
	return r;
  801cd0:	eb 02                	jmp    801cd4 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801cd2:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801cd4:	89 d8                	mov    %ebx,%eax
  801cd6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cd9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801cdc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801cdf:	89 ec                	mov    %ebp,%esp
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801ce3:	89 34 24             	mov    %esi,(%esp)
  801ce6:	e8 8a fe ff ff       	call   801b75 <_Z5closei>

	ova = fd2data(oldfd);
  801ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cee:	89 04 24             	mov    %eax,(%esp)
  801cf1:	e8 16 fd ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  801cf6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801cf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cfb:	89 04 24             	mov    %eax,(%esp)
  801cfe:	e8 09 fd ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  801d03:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801d05:	89 d8                	mov    %ebx,%eax
  801d07:	c1 e8 16             	shr    $0x16,%eax
  801d0a:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801d11:	a8 01                	test   $0x1,%al
  801d13:	0f 85 13 ff ff ff    	jne    801c2c <_Z3dupii+0x5c>
  801d19:	e9 51 ff ff ff       	jmp    801c6f <_Z3dupii+0x9f>

00801d1e <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	53                   	push   %ebx
  801d22:	83 ec 24             	sub    $0x24,%esp
  801d25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801d28:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d2f:	00 
  801d30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d37:	89 1c 24             	mov    %ebx,(%esp)
  801d3a:	e8 32 fc ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	78 5f                	js     801da2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801d4d:	8b 00                	mov    (%eax),%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 2b fd ff ff       	call   801a82 <_Z10dev_lookupiPP3Dev>
  801d57:	85 c0                	test   %eax,%eax
  801d59:	79 4d                	jns    801da8 <_Z4readiPvj+0x8a>
  801d5b:	eb 45                	jmp    801da2 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d5d:	a1 00 70 80 00       	mov    0x807000,%eax
  801d62:	8b 40 04             	mov    0x4(%eax),%eax
  801d65:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6d:	c7 04 24 32 4c 80 00 	movl   $0x804c32,(%esp)
  801d74:	e8 41 e7 ff ff       	call   8004ba <_Z7cprintfPKcz>
		return -E_INVAL;
  801d79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d7e:	eb 22                	jmp    801da2 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801d86:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801d8b:	85 d2                	test   %edx,%edx
  801d8d:	74 13                	je     801da2 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9d:	89 0c 24             	mov    %ecx,(%esp)
  801da0:	ff d2                	call   *%edx
}
  801da2:	83 c4 24             	add    $0x24,%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801da8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801dab:	8b 41 08             	mov    0x8(%ecx),%eax
  801dae:	83 e0 03             	and    $0x3,%eax
  801db1:	83 f8 01             	cmp    $0x1,%eax
  801db4:	75 ca                	jne    801d80 <_Z4readiPvj+0x62>
  801db6:	eb a5                	jmp    801d5d <_Z4readiPvj+0x3f>

00801db8 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	57                   	push   %edi
  801dbc:	56                   	push   %esi
  801dbd:	53                   	push   %ebx
  801dbe:	83 ec 1c             	sub    $0x1c,%esp
  801dc1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801dc4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801dc7:	85 f6                	test   %esi,%esi
  801dc9:	74 2f                	je     801dfa <_Z5readniPvj+0x42>
  801dcb:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801dd0:	89 f0                	mov    %esi,%eax
  801dd2:	29 d8                	sub    %ebx,%eax
  801dd4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	89 04 24             	mov    %eax,(%esp)
  801de5:	e8 34 ff ff ff       	call   801d1e <_Z4readiPvj>
		if (m < 0)
  801dea:	85 c0                	test   %eax,%eax
  801dec:	78 13                	js     801e01 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801dee:	85 c0                	test   %eax,%eax
  801df0:	74 0d                	je     801dff <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801df2:	01 c3                	add    %eax,%ebx
  801df4:	39 de                	cmp    %ebx,%esi
  801df6:	77 d8                	ja     801dd0 <_Z5readniPvj+0x18>
  801df8:	eb 05                	jmp    801dff <_Z5readniPvj+0x47>
  801dfa:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801dff:	89 d8                	mov    %ebx,%eax
}
  801e01:	83 c4 1c             	add    $0x1c,%esp
  801e04:	5b                   	pop    %ebx
  801e05:	5e                   	pop    %esi
  801e06:	5f                   	pop    %edi
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    

00801e09 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e0f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e16:	00 
  801e17:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	89 04 24             	mov    %eax,(%esp)
  801e24:	e8 48 fb ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	78 3c                	js     801e69 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e37:	8b 00                	mov    (%eax),%eax
  801e39:	89 04 24             	mov    %eax,(%esp)
  801e3c:	e8 41 fc ff ff       	call   801a82 <_Z10dev_lookupiPP3Dev>
  801e41:	85 c0                	test   %eax,%eax
  801e43:	79 26                	jns    801e6b <_Z5writeiPKvj+0x62>
  801e45:	eb 22                	jmp    801e69 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  801e4d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801e52:	85 c9                	test   %ecx,%ecx
  801e54:	74 13                	je     801e69 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801e56:	8b 45 10             	mov    0x10(%ebp),%eax
  801e59:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e64:	89 14 24             	mov    %edx,(%esp)
  801e67:	ff d1                	call   *%ecx
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801e6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  801e6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801e73:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801e77:	74 f0                	je     801e69 <_Z5writeiPKvj+0x60>
  801e79:	eb cc                	jmp    801e47 <_Z5writeiPKvj+0x3e>

00801e7b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801e81:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e88:	00 
  801e89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	89 04 24             	mov    %eax,(%esp)
  801e96:	e8 d6 fa ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	78 0e                	js     801ead <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  801e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	53                   	push   %ebx
  801eb3:	83 ec 24             	sub    $0x24,%esp
  801eb6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801eb9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ec0:	00 
  801ec1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec8:	89 1c 24             	mov    %ebx,(%esp)
  801ecb:	e8 a1 fa ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	78 58                	js     801f2c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ed4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801ede:	8b 00                	mov    (%eax),%eax
  801ee0:	89 04 24             	mov    %eax,(%esp)
  801ee3:	e8 9a fb ff ff       	call   801a82 <_Z10dev_lookupiPP3Dev>
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	79 46                	jns    801f32 <_Z9ftruncateii+0x83>
  801eec:	eb 3e                	jmp    801f2c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801eee:	a1 00 70 80 00       	mov    0x807000,%eax
  801ef3:	8b 40 04             	mov    0x4(%eax),%eax
  801ef6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801efa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efe:	c7 04 24 70 4c 80 00 	movl   $0x804c70,(%esp)
  801f05:	e8 b0 e5 ff ff       	call   8004ba <_Z7cprintfPKcz>
		return -E_INVAL;
  801f0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f0f:	eb 1b                	jmp    801f2c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801f17:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801f1c:	85 d2                	test   %edx,%edx
  801f1e:	74 0c                	je     801f2c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f27:	89 0c 24             	mov    %ecx,(%esp)
  801f2a:	ff d2                	call   *%edx
}
  801f2c:	83 c4 24             	add    $0x24,%esp
  801f2f:	5b                   	pop    %ebx
  801f30:	5d                   	pop    %ebp
  801f31:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f32:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f35:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  801f39:	75 d6                	jne    801f11 <_Z9ftruncateii+0x62>
  801f3b:	eb b1                	jmp    801eee <_Z9ftruncateii+0x3f>

00801f3d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	53                   	push   %ebx
  801f41:	83 ec 24             	sub    $0x24,%esp
  801f44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801f47:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801f4e:	00 
  801f4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	89 04 24             	mov    %eax,(%esp)
  801f5c:	e8 10 fa ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  801f61:	85 c0                	test   %eax,%eax
  801f63:	78 3e                	js     801fa3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801f6f:	8b 00                	mov    (%eax),%eax
  801f71:	89 04 24             	mov    %eax,(%esp)
  801f74:	e8 09 fb ff ff       	call   801a82 <_Z10dev_lookupiPP3Dev>
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	79 2c                	jns    801fa9 <_Z5fstatiP4Stat+0x6c>
  801f7d:	eb 24                	jmp    801fa3 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801f7f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801f82:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  801f89:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  801f90:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801f96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9d:	89 04 24             	mov    %eax,(%esp)
  801fa0:	ff 52 14             	call   *0x14(%edx)
}
  801fa3:	83 c4 24             	add    $0x24,%esp
  801fa6:	5b                   	pop    %ebx
  801fa7:	5d                   	pop    %ebp
  801fa8:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801fa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  801fac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801fb1:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801fb5:	75 c8                	jne    801f7f <_Z5fstatiP4Stat+0x42>
  801fb7:	eb ea                	jmp    801fa3 <_Z5fstatiP4Stat+0x66>

00801fb9 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 18             	sub    $0x18,%esp
  801fbf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801fc2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801fc5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fcc:	00 
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	89 04 24             	mov    %eax,(%esp)
  801fd3:	e8 d6 09 00 00       	call   8029ae <_Z4openPKci>
  801fd8:	89 c3                	mov    %eax,%ebx
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	78 1b                	js     801ff9 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe5:	89 1c 24             	mov    %ebx,(%esp)
  801fe8:	e8 50 ff ff ff       	call   801f3d <_Z5fstatiP4Stat>
  801fed:	89 c6                	mov    %eax,%esi
	close(fd);
  801fef:	89 1c 24             	mov    %ebx,(%esp)
  801ff2:	e8 7e fb ff ff       	call   801b75 <_Z5closei>
	return r;
  801ff7:	89 f3                	mov    %esi,%ebx
}
  801ff9:	89 d8                	mov    %ebx,%eax
  801ffb:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ffe:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802001:	89 ec                	mov    %ebp,%esp
  802003:	5d                   	pop    %ebp
  802004:	c3                   	ret    
	...

00802010 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  802013:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  802018:	85 d2                	test   %edx,%edx
  80201a:	78 33                	js     80204f <_ZL10inode_dataP5Inodei+0x3f>
  80201c:	3b 50 08             	cmp    0x8(%eax),%edx
  80201f:	7d 2e                	jge    80204f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  802021:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802027:	85 d2                	test   %edx,%edx
  802029:	0f 49 ca             	cmovns %edx,%ecx
  80202c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  80202f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  802033:	c1 e1 0c             	shl    $0xc,%ecx
  802036:	89 d0                	mov    %edx,%eax
  802038:	c1 f8 1f             	sar    $0x1f,%eax
  80203b:	c1 e8 14             	shr    $0x14,%eax
  80203e:	01 c2                	add    %eax,%edx
  802040:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802046:	29 c2                	sub    %eax,%edx
  802048:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  80204f:	89 c8                	mov    %ecx,%eax
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    

00802053 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  802056:	8b 48 08             	mov    0x8(%eax),%ecx
  802059:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  80205c:	8b 00                	mov    (%eax),%eax
  80205e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  802061:	c7 82 80 00 00 00 08 	movl   $0x806008,0x80(%edx)
  802068:	60 80 00 
}
  80206b:	5d                   	pop    %ebp
  80206c:	c3                   	ret    

0080206d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802073:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  802079:	85 c0                	test   %eax,%eax
  80207b:	74 08                	je     802085 <_ZL9get_inodei+0x18>
  80207d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802083:	7e 20                	jle    8020a5 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  802085:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802089:	c7 44 24 08 a8 4c 80 	movl   $0x804ca8,0x8(%esp)
  802090:	00 
  802091:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  802098:	00 
  802099:	c7 04 24 be 4c 80 00 	movl   $0x804cbe,(%esp)
  8020a0:	e8 f7 e2 ff ff       	call   80039c <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  8020a5:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  8020ab:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8020b1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8020b7:	85 d2                	test   %edx,%edx
  8020b9:	0f 48 d1             	cmovs  %ecx,%edx
  8020bc:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  8020bf:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  8020c6:	c1 e0 0c             	shl    $0xc,%eax
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  8020d3:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  8020d9:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  8020dc:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  8020e2:	76 20                	jbe    802104 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  8020e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020e8:	c7 44 24 08 e4 4c 80 	movl   $0x804ce4,0x8(%esp)
  8020ef:	00 
  8020f0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8020f7:	00 
  8020f8:	c7 04 24 be 4c 80 00 	movl   $0x804cbe,(%esp)
  8020ff:	e8 98 e2 ff ff       	call   80039c <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  802104:	83 fe 01             	cmp    $0x1,%esi
  802107:	7e 08                	jle    802111 <_ZL10bcache_ipcPvi+0x46>
  802109:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  80210f:	7d 12                	jge    802123 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802111:	89 f3                	mov    %esi,%ebx
  802113:	c1 e3 04             	shl    $0x4,%ebx
  802116:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802118:	81 c6 00 00 05 00    	add    $0x50000,%esi
  80211e:	c1 e6 0c             	shl    $0xc,%esi
  802121:	eb 20                	jmp    802143 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  802123:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802127:	c7 44 24 08 14 4d 80 	movl   $0x804d14,0x8(%esp)
  80212e:	00 
  80212f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802136:	00 
  802137:	c7 04 24 be 4c 80 00 	movl   $0x804cbe,(%esp)
  80213e:	e8 59 e2 ff ff       	call   80039c <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802143:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80214a:	00 
  80214b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802152:	00 
  802153:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802157:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  80215e:	e8 3c 22 00 00       	call   80439f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802163:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80216a:	00 
  80216b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80216f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802176:	e8 95 21 00 00       	call   804310 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  80217b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80217e:	74 c3                	je     802143 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  802180:	83 c4 10             	add    $0x10,%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5d                   	pop    %ebp
  802186:	c3                   	ret    

00802187 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 28             	sub    $0x28,%esp
  80218d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802190:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802193:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802196:	89 c7                	mov    %eax,%edi
  802198:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  80219a:	c7 04 24 2d 24 80 00 	movl   $0x80242d,(%esp)
  8021a1:	e8 75 20 00 00       	call   80421b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  8021a6:	89 f8                	mov    %edi,%eax
  8021a8:	e8 c0 fe ff ff       	call   80206d <_ZL9get_inodei>
  8021ad:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  8021af:	ba 02 00 00 00       	mov    $0x2,%edx
  8021b4:	e8 12 ff ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
	if (r < 0) {
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	79 08                	jns    8021c5 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  8021bd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  8021c3:	eb 2e                	jmp    8021f3 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	75 1c                	jne    8021e5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  8021c9:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  8021cf:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  8021d6:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  8021d9:	ba 06 00 00 00       	mov    $0x6,%edx
  8021de:	89 d8                	mov    %ebx,%eax
  8021e0:	e8 e6 fe ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  8021e5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  8021ec:	89 1e                	mov    %ebx,(%esi)
	return 0;
  8021ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8021f6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8021f9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8021fc:	89 ec                	mov    %ebp,%esp
  8021fe:	5d                   	pop    %ebp
  8021ff:	c3                   	ret    

00802200 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	57                   	push   %edi
  802204:	56                   	push   %esi
  802205:	53                   	push   %ebx
  802206:	83 ec 2c             	sub    $0x2c,%esp
  802209:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80220c:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  80220f:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  802214:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  80221a:	0f 87 3d 01 00 00    	ja     80235d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  802220:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802223:	8b 42 08             	mov    0x8(%edx),%eax
  802226:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  80222c:	85 c0                	test   %eax,%eax
  80222e:	0f 49 f0             	cmovns %eax,%esi
  802231:	c1 fe 0c             	sar    $0xc,%esi
  802234:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  802236:	8b 7d d8             	mov    -0x28(%ebp),%edi
  802239:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  80223f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  802242:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802245:	0f 82 a6 00 00 00    	jb     8022f1 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  80224b:	39 fe                	cmp    %edi,%esi
  80224d:	0f 8d f2 00 00 00    	jge    802345 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802253:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  802257:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80225a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80225d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  802260:	83 3e 00             	cmpl   $0x0,(%esi)
  802263:	75 77                	jne    8022dc <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802265:	ba 02 00 00 00       	mov    $0x2,%edx
  80226a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80226f:	e8 57 fe ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802274:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  80227a:	83 f9 02             	cmp    $0x2,%ecx
  80227d:	7e 43                	jle    8022c2 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  80227f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802284:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  802289:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802290:	74 29                	je     8022bb <_ZL14inode_set_sizeP5Inodej+0xbb>
  802292:	e9 ce 00 00 00       	jmp    802365 <_ZL14inode_set_sizeP5Inodej+0x165>
  802297:	89 c7                	mov    %eax,%edi
  802299:	0f b6 10             	movzbl (%eax),%edx
  80229c:	83 c0 01             	add    $0x1,%eax
  80229f:	84 d2                	test   %dl,%dl
  8022a1:	74 18                	je     8022bb <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  8022a3:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8022a6:	ba 05 00 00 00       	mov    $0x5,%edx
  8022ab:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8022b0:	e8 16 fe ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  8022b5:	85 db                	test   %ebx,%ebx
  8022b7:	79 1e                	jns    8022d7 <_ZL14inode_set_sizeP5Inodej+0xd7>
  8022b9:	eb 07                	jmp    8022c2 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  8022bb:	83 c3 01             	add    $0x1,%ebx
  8022be:	39 d9                	cmp    %ebx,%ecx
  8022c0:	7f d5                	jg     802297 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  8022c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022c5:	8b 50 08             	mov    0x8(%eax),%edx
  8022c8:	e8 33 ff ff ff       	call   802200 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  8022cd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8022d2:	e9 86 00 00 00       	jmp    80235d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  8022d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022da:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  8022dc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  8022e0:	83 c6 04             	add    $0x4,%esi
  8022e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8022e9:	0f 8f 6e ff ff ff    	jg     80225d <_ZL14inode_set_sizeP5Inodej+0x5d>
  8022ef:	eb 54                	jmp    802345 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  8022f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022f4:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  8022f9:	83 f8 01             	cmp    $0x1,%eax
  8022fc:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8022ff:	ba 02 00 00 00       	mov    $0x2,%edx
  802304:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802309:	e8 bd fd ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  80230e:	39 f7                	cmp    %esi,%edi
  802310:	7d 24                	jge    802336 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802312:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802315:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  802319:	8b 10                	mov    (%eax),%edx
  80231b:	85 d2                	test   %edx,%edx
  80231d:	74 0d                	je     80232c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  80231f:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  802326:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  80232c:	83 eb 01             	sub    $0x1,%ebx
  80232f:	83 e8 04             	sub    $0x4,%eax
  802332:	39 fb                	cmp    %edi,%ebx
  802334:	75 e3                	jne    802319 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802336:	ba 05 00 00 00       	mov    $0x5,%edx
  80233b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802340:	e8 86 fd ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  802345:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80234b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  80234e:	ba 04 00 00 00       	mov    $0x4,%edx
  802353:	e8 73 fd ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
	return 0;
  802358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235d:	83 c4 2c             	add    $0x2c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802365:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  80236c:	ba 05 00 00 00       	mov    $0x5,%edx
  802371:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802376:	e8 50 fd ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80237b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802380:	e9 52 ff ff ff       	jmp    8022d7 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802385 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	53                   	push   %ebx
  802389:	83 ec 04             	sub    $0x4,%esp
  80238c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  80238e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802394:	83 e8 01             	sub    $0x1,%eax
  802397:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  80239d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  8023a1:	75 40                	jne    8023e3 <_ZL11inode_closeP5Inode+0x5e>
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	75 3c                	jne    8023e3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8023a7:	ba 02 00 00 00       	mov    $0x2,%edx
  8023ac:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8023b1:	e8 15 fd ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  8023bb:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  8023bf:	85 d2                	test   %edx,%edx
  8023c1:	74 07                	je     8023ca <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  8023c3:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  8023ca:	83 c0 01             	add    $0x1,%eax
  8023cd:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  8023d2:	75 e7                	jne    8023bb <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8023d4:	ba 05 00 00 00       	mov    $0x5,%edx
  8023d9:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8023de:	e8 e8 fc ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  8023e3:	ba 03 00 00 00       	mov    $0x3,%edx
  8023e8:	89 d8                	mov    %ebx,%eax
  8023ea:	e8 dc fc ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
}
  8023ef:	83 c4 04             	add    $0x4,%esp
  8023f2:	5b                   	pop    %ebx
  8023f3:	5d                   	pop    %ebp
  8023f4:	c3                   	ret    

008023f5 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	53                   	push   %ebx
  8023f9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802402:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802405:	e8 7d fd ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  80240a:	89 c3                	mov    %eax,%ebx
  80240c:	85 c0                	test   %eax,%eax
  80240e:	78 15                	js     802425 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  802410:	8b 55 0c             	mov    0xc(%ebp),%edx
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	e8 e5 fd ff ff       	call   802200 <_ZL14inode_set_sizeP5Inodej>
  80241b:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	e8 60 ff ff ff       	call   802385 <_ZL11inode_closeP5Inode>
	return r;
}
  802425:	89 d8                	mov    %ebx,%eax
  802427:	83 c4 14             	add    $0x14,%esp
  80242a:	5b                   	pop    %ebx
  80242b:	5d                   	pop    %ebp
  80242c:	c3                   	ret    

0080242d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	53                   	push   %ebx
  802431:	83 ec 14             	sub    $0x14,%esp
  802434:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  802437:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  802439:	89 c2                	mov    %eax,%edx
  80243b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  802441:	78 32                	js     802475 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  802443:	ba 00 00 00 00       	mov    $0x0,%edx
  802448:	e8 7e fc ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
  80244d:	85 c0                	test   %eax,%eax
  80244f:	74 1c                	je     80246d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  802451:	c7 44 24 08 c9 4c 80 	movl   $0x804cc9,0x8(%esp)
  802458:	00 
  802459:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802460:	00 
  802461:	c7 04 24 be 4c 80 00 	movl   $0x804cbe,(%esp)
  802468:	e8 2f df ff ff       	call   80039c <_Z6_panicPKciS0_z>
    resume(utf);
  80246d:	89 1c 24             	mov    %ebx,(%esp)
  802470:	e8 7b 1e 00 00       	call   8042f0 <resume>
}
  802475:	83 c4 14             	add    $0x14,%esp
  802478:	5b                   	pop    %ebx
  802479:	5d                   	pop    %ebp
  80247a:	c3                   	ret    

0080247b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
  80247e:	83 ec 28             	sub    $0x28,%esp
  802481:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802484:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80248a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80248d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802490:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802493:	e8 ef fc ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  802498:	85 c0                	test   %eax,%eax
  80249a:	78 26                	js     8024c2 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80249c:	83 c3 10             	add    $0x10,%ebx
  80249f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024a3:	89 34 24             	mov    %esi,(%esp)
  8024a6:	e8 2f e6 ff ff       	call   800ada <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8024ab:	89 f2                	mov    %esi,%edx
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	e8 9e fb ff ff       	call   802053 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	e8 c8 fe ff ff       	call   802385 <_ZL11inode_closeP5Inode>
	return 0;
  8024bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8024c5:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8024c8:	89 ec                	mov    %ebp,%esp
  8024ca:	5d                   	pop    %ebp
  8024cb:	c3                   	ret    

008024cc <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	53                   	push   %ebx
  8024d0:	83 ec 24             	sub    $0x24,%esp
  8024d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8024d6:	89 1c 24             	mov    %ebx,(%esp)
  8024d9:	e8 9e 15 00 00       	call   803a7c <_Z7pagerefPv>
  8024de:	89 c2                	mov    %eax,%edx
        return 0;
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8024e5:	83 fa 01             	cmp    $0x1,%edx
  8024e8:	7f 1e                	jg     802508 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8024ea:	8b 43 0c             	mov    0xc(%ebx),%eax
  8024ed:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024f0:	e8 92 fc ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	78 0f                	js     802508 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802503:	e8 7d fe ff ff       	call   802385 <_ZL11inode_closeP5Inode>
}
  802508:	83 c4 24             	add    $0x24,%esp
  80250b:	5b                   	pop    %ebx
  80250c:	5d                   	pop    %ebp
  80250d:	c3                   	ret    

0080250e <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 3c             	sub    $0x3c,%esp
  802517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80251a:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  80251d:	8b 43 04             	mov    0x4(%ebx),%eax
  802520:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802523:	8b 43 0c             	mov    0xc(%ebx),%eax
  802526:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802529:	e8 59 fc ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  80252e:	85 c0                	test   %eax,%eax
  802530:	0f 88 8c 00 00 00    	js     8025c2 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802536:	8b 53 04             	mov    0x4(%ebx),%edx
  802539:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  80253f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802545:	29 d7                	sub    %edx,%edi
  802547:	39 f7                	cmp    %esi,%edi
  802549:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  80254c:	85 ff                	test   %edi,%edi
  80254e:	74 16                	je     802566 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802550:	8d 14 17             	lea    (%edi,%edx,1),%edx
  802553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802556:	3b 50 08             	cmp    0x8(%eax),%edx
  802559:	76 6f                	jbe    8025ca <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80255b:	e8 a0 fc ff ff       	call   802200 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802560:	85 c0                	test   %eax,%eax
  802562:	79 66                	jns    8025ca <_ZL13devfile_writeP2FdPKvj+0xbc>
  802564:	eb 4e                	jmp    8025b4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802566:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80256c:	76 24                	jbe    802592 <_ZL13devfile_writeP2FdPKvj+0x84>
  80256e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802570:	8b 53 04             	mov    0x4(%ebx),%edx
  802573:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257c:	3b 50 08             	cmp    0x8(%eax),%edx
  80257f:	0f 86 83 00 00 00    	jbe    802608 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802585:	e8 76 fc ff ff       	call   802200 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80258a:	85 c0                	test   %eax,%eax
  80258c:	79 7a                	jns    802608 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80258e:	66 90                	xchg   %ax,%ax
  802590:	eb 22                	jmp    8025b4 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802592:	85 f6                	test   %esi,%esi
  802594:	74 1e                	je     8025b4 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802596:	89 f2                	mov    %esi,%edx
  802598:	03 53 04             	add    0x4(%ebx),%edx
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	3b 50 08             	cmp    0x8(%eax),%edx
  8025a1:	0f 86 b8 00 00 00    	jbe    80265f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  8025a7:	e8 54 fc ff ff       	call   802200 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	0f 89 ab 00 00 00    	jns    80265f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  8025b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b7:	e8 c9 fd ff ff       	call   802385 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  8025bc:	8b 43 04             	mov    0x4(%ebx),%eax
  8025bf:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  8025c2:	83 c4 3c             	add    $0x3c,%esp
  8025c5:	5b                   	pop    %ebx
  8025c6:	5e                   	pop    %esi
  8025c7:	5f                   	pop    %edi
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  8025ca:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8025cc:	8b 53 04             	mov    0x4(%ebx),%edx
  8025cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d2:	e8 39 fa ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
  8025d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  8025da:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025e8:	89 04 24             	mov    %eax,(%esp)
  8025eb:	e8 07 e7 ff ff       	call   800cf7 <memcpy>
        fd->fd_offset += n2;
  8025f0:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  8025f3:	ba 04 00 00 00       	mov    $0x4,%edx
  8025f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025fb:	e8 cb fa ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  802600:	01 7d 0c             	add    %edi,0xc(%ebp)
  802603:	e9 5e ff ff ff       	jmp    802566 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802608:	8b 53 04             	mov    0x4(%ebx),%edx
  80260b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260e:	e8 fd f9 ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
  802613:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  802615:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80261c:	00 
  80261d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802620:	89 44 24 04          	mov    %eax,0x4(%esp)
  802624:	89 34 24             	mov    %esi,(%esp)
  802627:	e8 cb e6 ff ff       	call   800cf7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80262c:	ba 04 00 00 00       	mov    $0x4,%edx
  802631:	89 f0                	mov    %esi,%eax
  802633:	e8 93 fa ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  802638:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  80263e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802645:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80264c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802652:	0f 87 18 ff ff ff    	ja     802570 <_ZL13devfile_writeP2FdPKvj+0x62>
  802658:	89 fe                	mov    %edi,%esi
  80265a:	e9 33 ff ff ff       	jmp    802592 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80265f:	8b 53 04             	mov    0x4(%ebx),%edx
  802662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802665:	e8 a6 f9 ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
  80266a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80266c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802670:	8b 45 0c             	mov    0xc(%ebp),%eax
  802673:	89 44 24 04          	mov    %eax,0x4(%esp)
  802677:	89 3c 24             	mov    %edi,(%esp)
  80267a:	e8 78 e6 ff ff       	call   800cf7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80267f:	ba 04 00 00 00       	mov    $0x4,%edx
  802684:	89 f8                	mov    %edi,%eax
  802686:	e8 40 fa ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80268b:	01 73 04             	add    %esi,0x4(%ebx)
  80268e:	e9 21 ff ff ff       	jmp    8025b4 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802693 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	57                   	push   %edi
  802697:	56                   	push   %esi
  802698:	53                   	push   %ebx
  802699:	83 ec 3c             	sub    $0x3c,%esp
  80269c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80269f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  8026a2:	8b 43 04             	mov    0x4(%ebx),%eax
  8026a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8026a8:	8b 43 0c             	mov    0xc(%ebx),%eax
  8026ab:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8026ae:	e8 d4 fa ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	0f 88 d3 00 00 00    	js     80278e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  8026bb:	8b 73 04             	mov    0x4(%ebx),%esi
  8026be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c1:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  8026c4:	8b 50 08             	mov    0x8(%eax),%edx
  8026c7:	29 f2                	sub    %esi,%edx
  8026c9:	3b 48 08             	cmp    0x8(%eax),%ecx
  8026cc:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  8026cf:	89 f2                	mov    %esi,%edx
  8026d1:	e8 3a f9 ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	0f 84 a2 00 00 00    	je     802780 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8026de:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  8026e4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8026ea:	29 f2                	sub    %esi,%edx
  8026ec:	39 d7                	cmp    %edx,%edi
  8026ee:	0f 46 d7             	cmovbe %edi,%edx
  8026f1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  8026f4:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  8026f6:	01 d6                	add    %edx,%esi
  8026f8:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  8026fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802703:	8b 45 0c             	mov    0xc(%ebp),%eax
  802706:	89 04 24             	mov    %eax,(%esp)
  802709:	e8 e9 e5 ff ff       	call   800cf7 <memcpy>
    buf = (void *)((char *)buf + n2);
  80270e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802711:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802714:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  80271a:	76 3e                	jbe    80275a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80271c:	8b 53 04             	mov    0x4(%ebx),%edx
  80271f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802722:	e8 e9 f8 ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
  802727:	85 c0                	test   %eax,%eax
  802729:	74 55                	je     802780 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80272b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802732:	00 
  802733:	89 44 24 04          	mov    %eax,0x4(%esp)
  802737:	89 34 24             	mov    %esi,(%esp)
  80273a:	e8 b8 e5 ff ff       	call   800cf7 <memcpy>
        n -= PGSIZE;
  80273f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802745:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80274b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802752:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802758:	77 c2                	ja     80271c <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80275a:	85 ff                	test   %edi,%edi
  80275c:	74 22                	je     802780 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80275e:	8b 53 04             	mov    0x4(%ebx),%edx
  802761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802764:	e8 a7 f8 ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
  802769:	85 c0                	test   %eax,%eax
  80276b:	74 13                	je     802780 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80276d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802771:	89 44 24 04          	mov    %eax,0x4(%esp)
  802775:	89 34 24             	mov    %esi,(%esp)
  802778:	e8 7a e5 ff ff       	call   800cf7 <memcpy>
        fd->fd_offset += n;
  80277d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802783:	e8 fd fb ff ff       	call   802385 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802788:	8b 43 04             	mov    0x4(%ebx),%eax
  80278b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80278e:	83 c4 3c             	add    $0x3c,%esp
  802791:	5b                   	pop    %ebx
  802792:	5e                   	pop    %esi
  802793:	5f                   	pop    %edi
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    

00802796 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	57                   	push   %edi
  80279a:	56                   	push   %esi
  80279b:	53                   	push   %ebx
  80279c:	83 ec 4c             	sub    $0x4c,%esp
  80279f:	89 c6                	mov    %eax,%esi
  8027a1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  8027a4:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  8027a7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  8027ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  8027b6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8027b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027be:	e8 c4 f9 ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  8027c3:	89 c7                	mov    %eax,%edi
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	0f 88 cd 01 00 00    	js     80299a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8027cd:	89 f3                	mov    %esi,%ebx
  8027cf:	80 3e 2f             	cmpb   $0x2f,(%esi)
  8027d2:	75 08                	jne    8027dc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  8027d4:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8027d7:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8027da:	74 f8                	je     8027d4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8027dc:	0f b6 03             	movzbl (%ebx),%eax
  8027df:	3c 2f                	cmp    $0x2f,%al
  8027e1:	74 16                	je     8027f9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8027e3:	84 c0                	test   %al,%al
  8027e5:	74 12                	je     8027f9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8027e7:	89 da                	mov    %ebx,%edx
		++path;
  8027e9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8027ec:	0f b6 02             	movzbl (%edx),%eax
  8027ef:	3c 2f                	cmp    $0x2f,%al
  8027f1:	74 08                	je     8027fb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8027f3:	84 c0                	test   %al,%al
  8027f5:	75 f2                	jne    8027e9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  8027f7:	eb 02                	jmp    8027fb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8027f9:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  8027fb:	89 d0                	mov    %edx,%eax
  8027fd:	29 d8                	sub    %ebx,%eax
  8027ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802802:	0f b6 02             	movzbl (%edx),%eax
  802805:	89 d6                	mov    %edx,%esi
  802807:	3c 2f                	cmp    $0x2f,%al
  802809:	75 0a                	jne    802815 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  80280b:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  80280e:	0f b6 06             	movzbl (%esi),%eax
  802811:	3c 2f                	cmp    $0x2f,%al
  802813:	74 f6                	je     80280b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802815:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802819:	75 1b                	jne    802836 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  80281b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802821:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802823:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802826:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80282c:	bf 00 00 00 00       	mov    $0x0,%edi
  802831:	e9 64 01 00 00       	jmp    80299a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802836:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  80283a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80283e:	74 06                	je     802846 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802840:	84 c0                	test   %al,%al
  802842:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802846:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802849:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80284c:	83 3a 02             	cmpl   $0x2,(%edx)
  80284f:	0f 85 f4 00 00 00    	jne    802949 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802855:	89 d0                	mov    %edx,%eax
  802857:	8b 52 08             	mov    0x8(%edx),%edx
  80285a:	85 d2                	test   %edx,%edx
  80285c:	7e 78                	jle    8028d6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80285e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802865:	bf 00 00 00 00       	mov    $0x0,%edi
  80286a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80286d:	89 fb                	mov    %edi,%ebx
  80286f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802872:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802874:	89 da                	mov    %ebx,%edx
  802876:	89 f0                	mov    %esi,%eax
  802878:	e8 93 f7 ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
  80287d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80287f:	83 38 00             	cmpl   $0x0,(%eax)
  802882:	74 26                	je     8028aa <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802884:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802887:	3b 50 04             	cmp    0x4(%eax),%edx
  80288a:	75 33                	jne    8028bf <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80288c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802890:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802893:	89 44 24 04          	mov    %eax,0x4(%esp)
  802897:	8d 47 08             	lea    0x8(%edi),%eax
  80289a:	89 04 24             	mov    %eax,(%esp)
  80289d:	e8 96 e4 ff ff       	call   800d38 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	0f 84 fa 00 00 00    	je     8029a4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  8028aa:	83 3f 00             	cmpl   $0x0,(%edi)
  8028ad:	75 10                	jne    8028bf <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  8028af:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028b3:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  8028b6:	84 c0                	test   %al,%al
  8028b8:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  8028bc:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8028bf:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  8028c5:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8028c7:	8b 56 08             	mov    0x8(%esi),%edx
  8028ca:	39 d0                	cmp    %edx,%eax
  8028cc:	7c a6                	jl     802874 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  8028ce:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8028d1:	8b 75 c0             	mov    -0x40(%ebp),%esi
  8028d4:	eb 07                	jmp    8028dd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  8028d6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  8028dd:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  8028e1:	74 6d                	je     802950 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  8028e3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028e7:	75 24                	jne    80290d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  8028e9:	83 ea 80             	sub    $0xffffff80,%edx
  8028ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028ef:	e8 0c f9 ff ff       	call   802200 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	0f 88 90 00 00 00    	js     80298c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  8028fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028ff:	8b 50 08             	mov    0x8(%eax),%edx
  802902:	83 c2 80             	add    $0xffffff80,%edx
  802905:	e8 06 f7 ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
  80290a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  80290d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802914:	00 
  802915:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80291c:	00 
  80291d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802920:	89 14 24             	mov    %edx,(%esp)
  802923:	e8 f9 e2 ff ff       	call   800c21 <memset>
	empty->de_namelen = namelen;
  802928:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80292b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80292e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802931:	89 54 24 08          	mov    %edx,0x8(%esp)
  802935:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802939:	83 c0 08             	add    $0x8,%eax
  80293c:	89 04 24             	mov    %eax,(%esp)
  80293f:	e8 b3 e3 ff ff       	call   800cf7 <memcpy>
	*de_store = empty;
  802944:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802947:	eb 5e                	jmp    8029a7 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802949:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  80294e:	eb 42                	jmp    802992 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802950:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802955:	eb 3b                	jmp    802992 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80295d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80295f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802962:	89 38                	mov    %edi,(%eax)
			return 0;
  802964:	bf 00 00 00 00       	mov    $0x0,%edi
  802969:	eb 2f                	jmp    80299a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80296b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80296e:	8b 07                	mov    (%edi),%eax
  802970:	e8 12 f8 ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  802975:	85 c0                	test   %eax,%eax
  802977:	78 17                	js     802990 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297c:	e8 04 fa ff ff       	call   802385 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802981:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802984:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802987:	e9 41 fe ff ff       	jmp    8027cd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80298c:	89 c7                	mov    %eax,%edi
  80298e:	eb 02                	jmp    802992 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802990:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802995:	e8 eb f9 ff ff       	call   802385 <_ZL11inode_closeP5Inode>
	return r;
}
  80299a:	89 f8                	mov    %edi,%eax
  80299c:	83 c4 4c             	add    $0x4c,%esp
  80299f:	5b                   	pop    %ebx
  8029a0:	5e                   	pop    %esi
  8029a1:	5f                   	pop    %edi
  8029a2:	5d                   	pop    %ebp
  8029a3:	c3                   	ret    
  8029a4:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  8029a7:	80 3e 00             	cmpb   $0x0,(%esi)
  8029aa:	75 bf                	jne    80296b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  8029ac:	eb a9                	jmp    802957 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

008029ae <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	53                   	push   %ebx
  8029b4:	83 ec 3c             	sub    $0x3c,%esp
  8029b7:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  8029ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8029bd:	89 04 24             	mov    %eax,(%esp)
  8029c0:	e8 62 f0 ff ff       	call   801a27 <_Z14fd_find_unusedPP2Fd>
  8029c5:	89 c3                	mov    %eax,%ebx
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	0f 88 16 02 00 00    	js     802be5 <_Z4openPKci+0x237>
  8029cf:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029d6:	00 
  8029d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029e5:	e8 d6 e5 ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  8029ea:	89 c3                	mov    %eax,%ebx
  8029ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f1:	85 db                	test   %ebx,%ebx
  8029f3:	0f 88 ec 01 00 00    	js     802be5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  8029f9:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  8029fd:	0f 84 ec 01 00 00    	je     802bef <_Z4openPKci+0x241>
  802a03:	83 c0 01             	add    $0x1,%eax
  802a06:	83 f8 78             	cmp    $0x78,%eax
  802a09:	75 ee                	jne    8029f9 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802a0b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802a10:	e9 b9 01 00 00       	jmp    802bce <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802a15:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a18:	81 e7 00 01 00 00    	and    $0x100,%edi
  802a1e:	89 3c 24             	mov    %edi,(%esp)
  802a21:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802a24:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802a27:	89 f0                	mov    %esi,%eax
  802a29:	e8 68 fd ff ff       	call   802796 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802a2e:	89 c3                	mov    %eax,%ebx
  802a30:	85 c0                	test   %eax,%eax
  802a32:	0f 85 96 01 00 00    	jne    802bce <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802a38:	85 ff                	test   %edi,%edi
  802a3a:	75 41                	jne    802a7d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  802a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a3f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802a44:	75 08                	jne    802a4e <_Z4openPKci+0xa0>
            fileino = dirino;
  802a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a49:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802a4c:	eb 14                	jmp    802a62 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  802a4e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	e8 2f f7 ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  802a58:	89 c3                	mov    %eax,%ebx
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	0f 88 5d 01 00 00    	js     802bbf <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802a62:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a65:	83 38 02             	cmpl   $0x2,(%eax)
  802a68:	0f 85 d2 00 00 00    	jne    802b40 <_Z4openPKci+0x192>
  802a6e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802a72:	0f 84 c8 00 00 00    	je     802b40 <_Z4openPKci+0x192>
  802a78:	e9 38 01 00 00       	jmp    802bb5 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  802a7d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802a84:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  802a8b:	0f 8e a8 00 00 00    	jle    802b39 <_Z4openPKci+0x18b>
  802a91:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802a96:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802a99:	89 f8                	mov    %edi,%eax
  802a9b:	e8 e7 f6 ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  802aa0:	89 c3                	mov    %eax,%ebx
  802aa2:	85 c0                	test   %eax,%eax
  802aa4:	0f 88 15 01 00 00    	js     802bbf <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  802aaa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802aad:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802ab1:	75 68                	jne    802b1b <_Z4openPKci+0x16d>
  802ab3:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  802aba:	75 5f                	jne    802b1b <_Z4openPKci+0x16d>
			*ino_store = ino;
  802abc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  802abf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802ac5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ac8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  802acf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802ad6:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  802add:	00 
  802ade:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802ae5:	00 
  802ae6:	83 c0 0c             	add    $0xc,%eax
  802ae9:	89 04 24             	mov    %eax,(%esp)
  802aec:	e8 30 e1 ff ff       	call   800c21 <memset>
        de->de_inum = fileino->i_inum;
  802af1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802af4:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  802afa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802afd:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  802aff:	ba 04 00 00 00       	mov    $0x4,%edx
  802b04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b07:	e8 bf f5 ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  802b0c:	ba 04 00 00 00       	mov    $0x4,%edx
  802b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b14:	e8 b2 f5 ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
  802b19:	eb 25                	jmp    802b40 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  802b1b:	e8 65 f8 ff ff       	call   802385 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802b20:	83 c7 01             	add    $0x1,%edi
  802b23:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802b29:	0f 8c 67 ff ff ff    	jl     802a96 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  802b2f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802b34:	e9 86 00 00 00       	jmp    802bbf <_Z4openPKci+0x211>
  802b39:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802b3e:	eb 7f                	jmp    802bbf <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802b40:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802b47:	74 0d                	je     802b56 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802b49:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b51:	e8 aa f6 ff ff       	call   802200 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802b56:	8b 15 08 60 80 00    	mov    0x806008,%edx
  802b5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  802b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b6e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802b71:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b74:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  802b7a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  802b7d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b81:	83 c0 10             	add    $0x10,%eax
  802b84:	89 04 24             	mov    %eax,(%esp)
  802b87:	e8 4e df ff ff       	call   800ada <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  802b8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b8f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802b96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b99:	e8 e7 f7 ff ff       	call   802385 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  802b9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ba1:	e8 df f7 ff ff       	call   802385 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba9:	89 04 24             	mov    %eax,(%esp)
  802bac:	e8 13 ee ff ff       	call   8019c4 <_Z6fd2numP2Fd>
  802bb1:	89 c3                	mov    %eax,%ebx
  802bb3:	eb 30                	jmp    802be5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802bb5:	e8 cb f7 ff ff       	call   802385 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  802bba:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  802bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc2:	e8 be f7 ff ff       	call   802385 <_ZL11inode_closeP5Inode>
  802bc7:	eb 05                	jmp    802bce <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802bc9:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  802bce:	a1 00 70 80 00       	mov    0x807000,%eax
  802bd3:	8b 40 04             	mov    0x4(%eax),%eax
  802bd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bd9:	89 54 24 04          	mov    %edx,0x4(%esp)
  802bdd:	89 04 24             	mov    %eax,(%esp)
  802be0:	e8 98 e4 ff ff       	call   80107d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802be5:	89 d8                	mov    %ebx,%eax
  802be7:	83 c4 3c             	add    $0x3c,%esp
  802bea:	5b                   	pop    %ebx
  802beb:	5e                   	pop    %esi
  802bec:	5f                   	pop    %edi
  802bed:	5d                   	pop    %ebp
  802bee:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  802bef:	83 f8 78             	cmp    $0x78,%eax
  802bf2:	0f 85 1d fe ff ff    	jne    802a15 <_Z4openPKci+0x67>
  802bf8:	eb cf                	jmp    802bc9 <_Z4openPKci+0x21b>

00802bfa <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  802bfa:	55                   	push   %ebp
  802bfb:	89 e5                	mov    %esp,%ebp
  802bfd:	53                   	push   %ebx
  802bfe:	83 ec 24             	sub    $0x24,%esp
  802c01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802c04:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	e8 78 f5 ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  802c0f:	85 c0                	test   %eax,%eax
  802c11:	78 27                	js     802c3a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802c13:	c7 44 24 04 dc 4c 80 	movl   $0x804cdc,0x4(%esp)
  802c1a:	00 
  802c1b:	89 1c 24             	mov    %ebx,(%esp)
  802c1e:	e8 b7 de ff ff       	call   800ada <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802c23:	89 da                	mov    %ebx,%edx
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	e8 26 f4 ff ff       	call   802053 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	e8 50 f7 ff ff       	call   802385 <_ZL11inode_closeP5Inode>
	return 0;
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c3a:	83 c4 24             	add    $0x24,%esp
  802c3d:	5b                   	pop    %ebx
  802c3e:	5d                   	pop    %ebp
  802c3f:	c3                   	ret    

00802c40 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802c40:	55                   	push   %ebp
  802c41:	89 e5                	mov    %esp,%ebp
  802c43:	53                   	push   %ebx
  802c44:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802c47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c4e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802c51:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	e8 3a fb ff ff       	call   802796 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802c5c:	89 c3                	mov    %eax,%ebx
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	78 5f                	js     802cc1 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802c62:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	e8 18 f5 ff ff       	call   802187 <_ZL10inode_openiPP5Inode>
  802c6f:	89 c3                	mov    %eax,%ebx
  802c71:	85 c0                	test   %eax,%eax
  802c73:	78 44                	js     802cb9 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802c75:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	83 38 02             	cmpl   $0x2,(%eax)
  802c80:	74 2f                	je     802cb1 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  802c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802c92:	ba 04 00 00 00       	mov    $0x4,%edx
  802c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9a:	e8 2c f4 ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  802c9f:	ba 04 00 00 00       	mov    $0x4,%edx
  802ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca7:	e8 1f f4 ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
	r = 0;
  802cac:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	e8 cc f6 ff ff       	call   802385 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	e8 c4 f6 ff ff       	call   802385 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802cc1:	89 d8                	mov    %ebx,%eax
  802cc3:	83 c4 24             	add    $0x24,%esp
  802cc6:	5b                   	pop    %ebx
  802cc7:	5d                   	pop    %ebp
  802cc8:	c3                   	ret    

00802cc9 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802cc9:	55                   	push   %ebp
  802cca:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  802ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd1:	5d                   	pop    %ebp
  802cd2:	c3                   	ret    

00802cd3 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802cd3:	55                   	push   %ebp
  802cd4:	89 e5                	mov    %esp,%ebp
  802cd6:	57                   	push   %edi
  802cd7:	56                   	push   %esi
  802cd8:	53                   	push   %ebx
  802cd9:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  802cdf:	c7 04 24 2d 24 80 00 	movl   $0x80242d,(%esp)
  802ce6:	e8 30 15 00 00       	call   80421b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802ceb:	a1 00 10 00 50       	mov    0x50001000,%eax
  802cf0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802cf5:	74 28                	je     802d1f <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802cf7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802cfe:	4a 
  802cff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d03:	c7 44 24 08 44 4d 80 	movl   $0x804d44,0x8(%esp)
  802d0a:	00 
  802d0b:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802d12:	00 
  802d13:	c7 04 24 be 4c 80 00 	movl   $0x804cbe,(%esp)
  802d1a:	e8 7d d6 ff ff       	call   80039c <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802d1f:	a1 04 10 00 50       	mov    0x50001004,%eax
  802d24:	83 f8 03             	cmp    $0x3,%eax
  802d27:	7f 1c                	jg     802d45 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802d29:	c7 44 24 08 78 4d 80 	movl   $0x804d78,0x8(%esp)
  802d30:	00 
  802d31:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802d38:	00 
  802d39:	c7 04 24 be 4c 80 00 	movl   $0x804cbe,(%esp)
  802d40:	e8 57 d6 ff ff       	call   80039c <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802d45:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802d4b:	85 d2                	test   %edx,%edx
  802d4d:	7f 1c                	jg     802d6b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802d4f:	c7 44 24 08 a8 4d 80 	movl   $0x804da8,0x8(%esp)
  802d56:	00 
  802d57:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802d5e:	00 
  802d5f:	c7 04 24 be 4c 80 00 	movl   $0x804cbe,(%esp)
  802d66:	e8 31 d6 ff ff       	call   80039c <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802d6b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802d71:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802d77:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802d7d:	85 c9                	test   %ecx,%ecx
  802d7f:	0f 48 cb             	cmovs  %ebx,%ecx
  802d82:	c1 f9 0c             	sar    $0xc,%ecx
  802d85:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802d89:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802d8f:	39 c8                	cmp    %ecx,%eax
  802d91:	7c 13                	jl     802da6 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802d93:	85 c0                	test   %eax,%eax
  802d95:	7f 3d                	jg     802dd4 <_Z4fsckv+0x101>
  802d97:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802d9e:	00 00 00 
  802da1:	e9 ac 00 00 00       	jmp    802e52 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802da6:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802dac:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802db0:	89 44 24 10          	mov    %eax,0x10(%esp)
  802db4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802db8:	c7 44 24 08 d8 4d 80 	movl   $0x804dd8,0x8(%esp)
  802dbf:	00 
  802dc0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802dc7:	00 
  802dc8:	c7 04 24 be 4c 80 00 	movl   $0x804cbe,(%esp)
  802dcf:	e8 c8 d5 ff ff       	call   80039c <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802dd4:	be 00 20 00 50       	mov    $0x50002000,%esi
  802dd9:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802de0:	00 00 00 
  802de3:	bb 00 00 00 00       	mov    $0x0,%ebx
  802de8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802dee:	39 df                	cmp    %ebx,%edi
  802df0:	7e 27                	jle    802e19 <_Z4fsckv+0x146>
  802df2:	0f b6 06             	movzbl (%esi),%eax
  802df5:	84 c0                	test   %al,%al
  802df7:	74 4b                	je     802e44 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802df9:	0f be c0             	movsbl %al,%eax
  802dfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e04:	c7 04 24 1c 4e 80 00 	movl   $0x804e1c,(%esp)
  802e0b:	e8 aa d6 ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  802e10:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802e17:	eb 2b                	jmp    802e44 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802e19:	0f b6 06             	movzbl (%esi),%eax
  802e1c:	3c 01                	cmp    $0x1,%al
  802e1e:	76 24                	jbe    802e44 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802e20:	0f be c0             	movsbl %al,%eax
  802e23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e27:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e2b:	c7 04 24 50 4e 80 00 	movl   $0x804e50,(%esp)
  802e32:	e8 83 d6 ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  802e37:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802e3e:	80 3e 00             	cmpb   $0x0,(%esi)
  802e41:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802e44:	83 c3 01             	add    $0x1,%ebx
  802e47:	83 c6 01             	add    $0x1,%esi
  802e4a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802e50:	7f 9c                	jg     802dee <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802e52:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802e59:	0f 8e e1 02 00 00    	jle    803140 <_Z4fsckv+0x46d>
  802e5f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802e66:	00 00 00 
		struct Inode *ino = get_inode(i);
  802e69:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802e6f:	e8 f9 f1 ff ff       	call   80206d <_ZL9get_inodei>
  802e74:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  802e7a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  802e7e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802e85:	75 22                	jne    802ea9 <_Z4fsckv+0x1d6>
  802e87:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  802e8e:	0f 84 a9 06 00 00    	je     80353d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802e94:	ba 00 00 00 00       	mov    $0x0,%edx
  802e99:	e8 2d f2 ff ff       	call   8020cb <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	74 3a                	je     802edc <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802ea2:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802ea9:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802eaf:	8b 02                	mov    (%edx),%eax
  802eb1:	83 f8 01             	cmp    $0x1,%eax
  802eb4:	74 26                	je     802edc <_Z4fsckv+0x209>
  802eb6:	83 f8 02             	cmp    $0x2,%eax
  802eb9:	74 21                	je     802edc <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  802ebb:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ebf:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802ec5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ec9:	c7 04 24 7c 4e 80 00 	movl   $0x804e7c,(%esp)
  802ed0:	e8 e5 d5 ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  802ed5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  802edc:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802ee3:	75 3f                	jne    802f24 <_Z4fsckv+0x251>
  802ee5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802eeb:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802eef:	75 15                	jne    802f06 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802ef1:	c7 04 24 a0 4e 80 00 	movl   $0x804ea0,(%esp)
  802ef8:	e8 bd d5 ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  802efd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f04:	eb 1e                	jmp    802f24 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802f06:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f0c:	83 3a 02             	cmpl   $0x2,(%edx)
  802f0f:	74 13                	je     802f24 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802f11:	c7 04 24 d4 4e 80 00 	movl   $0x804ed4,(%esp)
  802f18:	e8 9d d5 ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  802f1d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  802f24:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  802f29:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802f30:	0f 84 93 00 00 00    	je     802fc9 <_Z4fsckv+0x2f6>
  802f36:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  802f3c:	8b 41 08             	mov    0x8(%ecx),%eax
  802f3f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  802f44:	7e 23                	jle    802f69 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  802f46:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f4a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802f50:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f54:	c7 04 24 04 4f 80 00 	movl   $0x804f04,(%esp)
  802f5b:	e8 5a d5 ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  802f60:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802f67:	eb 09                	jmp    802f72 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  802f69:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802f70:	74 4b                	je     802fbd <_Z4fsckv+0x2ea>
  802f72:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f78:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  802f7e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  802f84:	74 23                	je     802fa9 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  802f86:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f8a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802f90:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f94:	c7 04 24 28 4f 80 00 	movl   $0x804f28,(%esp)
  802f9b:	e8 1a d5 ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  802fa0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802fa7:	eb 09                	jmp    802fb2 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  802fa9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  802fb0:	74 12                	je     802fc4 <_Z4fsckv+0x2f1>
  802fb2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802fb8:	8b 78 08             	mov    0x8(%eax),%edi
  802fbb:	eb 0c                	jmp    802fc9 <_Z4fsckv+0x2f6>
  802fbd:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc2:	eb 05                	jmp    802fc9 <_Z4fsckv+0x2f6>
  802fc4:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  802fc9:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  802fce:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802fd4:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  802fd8:	89 d8                	mov    %ebx,%eax
  802fda:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  802fdd:	39 c7                	cmp    %eax,%edi
  802fdf:	7e 2b                	jle    80300c <_Z4fsckv+0x339>
  802fe1:	85 f6                	test   %esi,%esi
  802fe3:	75 27                	jne    80300c <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  802fe5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fe9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fed:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802ff3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ff7:	c7 04 24 4c 4f 80 00 	movl   $0x804f4c,(%esp)
  802ffe:	e8 b7 d4 ff ff       	call   8004ba <_Z7cprintfPKcz>
				++errors;
  803003:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80300a:	eb 36                	jmp    803042 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  80300c:	39 f8                	cmp    %edi,%eax
  80300e:	7c 32                	jl     803042 <_Z4fsckv+0x36f>
  803010:	85 f6                	test   %esi,%esi
  803012:	74 2e                	je     803042 <_Z4fsckv+0x36f>
  803014:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  80301b:	74 25                	je     803042 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  80301d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803021:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803025:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80302b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80302f:	c7 04 24 90 4f 80 00 	movl   $0x804f90,(%esp)
  803036:	e8 7f d4 ff ff       	call   8004ba <_Z7cprintfPKcz>
				++errors;
  80303b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  803042:	85 f6                	test   %esi,%esi
  803044:	0f 84 a0 00 00 00    	je     8030ea <_Z4fsckv+0x417>
  80304a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803051:	0f 84 93 00 00 00    	je     8030ea <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  803057:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  80305d:	7e 27                	jle    803086 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  80305f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803063:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803067:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  80306d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803071:	c7 04 24 d4 4f 80 00 	movl   $0x804fd4,(%esp)
  803078:	e8 3d d4 ff ff       	call   8004ba <_Z7cprintfPKcz>
					++errors;
  80307d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803084:	eb 64                	jmp    8030ea <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  803086:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80308d:	3c 01                	cmp    $0x1,%al
  80308f:	75 27                	jne    8030b8 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  803091:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803095:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803099:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  80309f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030a3:	c7 04 24 18 50 80 00 	movl   $0x805018,(%esp)
  8030aa:	e8 0b d4 ff ff       	call   8004ba <_Z7cprintfPKcz>
					++errors;
  8030af:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8030b6:	eb 32                	jmp    8030ea <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  8030b8:	3c ff                	cmp    $0xff,%al
  8030ba:	75 27                	jne    8030e3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  8030bc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8030c0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030c4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8030ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030ce:	c7 04 24 54 50 80 00 	movl   $0x805054,(%esp)
  8030d5:	e8 e0 d3 ff ff       	call   8004ba <_Z7cprintfPKcz>
					++errors;
  8030da:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8030e1:	eb 07                	jmp    8030ea <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  8030e3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  8030ea:	83 c3 01             	add    $0x1,%ebx
  8030ed:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  8030f3:	0f 85 d5 fe ff ff    	jne    802fce <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  8030f9:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  803100:	0f 94 c0             	sete   %al
  803103:	0f b6 c0             	movzbl %al,%eax
  803106:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80310c:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  803112:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  803119:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  803120:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803127:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  80312e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803134:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  80313a:	0f 8f 29 fd ff ff    	jg     802e69 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803140:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803147:	0f 8e 7f 03 00 00    	jle    8034cc <_Z4fsckv+0x7f9>
  80314d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  803152:	89 f0                	mov    %esi,%eax
  803154:	e8 14 ef ff ff       	call   80206d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  803159:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803160:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803167:	c1 e2 08             	shl    $0x8,%edx
  80316a:	09 ca                	or     %ecx,%edx
  80316c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803173:	c1 e1 10             	shl    $0x10,%ecx
  803176:	09 ca                	or     %ecx,%edx
  803178:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  80317f:	83 e1 7f             	and    $0x7f,%ecx
  803182:	c1 e1 18             	shl    $0x18,%ecx
  803185:	09 d1                	or     %edx,%ecx
  803187:	74 0e                	je     803197 <_Z4fsckv+0x4c4>
  803189:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803190:	78 05                	js     803197 <_Z4fsckv+0x4c4>
  803192:	83 38 02             	cmpl   $0x2,(%eax)
  803195:	74 1f                	je     8031b6 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803197:	83 c6 01             	add    $0x1,%esi
  80319a:	a1 08 10 00 50       	mov    0x50001008,%eax
  80319f:	39 f0                	cmp    %esi,%eax
  8031a1:	7f af                	jg     803152 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  8031a3:	bb 01 00 00 00       	mov    $0x1,%ebx
  8031a8:	83 f8 01             	cmp    $0x1,%eax
  8031ab:	0f 8f ad 02 00 00    	jg     80345e <_Z4fsckv+0x78b>
  8031b1:	e9 16 03 00 00       	jmp    8034cc <_Z4fsckv+0x7f9>
  8031b6:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  8031b8:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  8031bf:	8b 40 08             	mov    0x8(%eax),%eax
  8031c2:	a8 7f                	test   $0x7f,%al
  8031c4:	74 23                	je     8031e9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  8031c6:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  8031cd:	00 
  8031ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031d6:	c7 04 24 90 50 80 00 	movl   $0x805090,(%esp)
  8031dd:	e8 d8 d2 ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  8031e2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8031e9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  8031f0:	00 00 00 
  8031f3:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  8031f9:	e9 3d 02 00 00       	jmp    80343b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  8031fe:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803204:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80320a:	e8 01 ee ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
  80320f:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  803211:	83 38 00             	cmpl   $0x0,(%eax)
  803214:	0f 84 15 02 00 00    	je     80342f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  80321a:	8b 40 04             	mov    0x4(%eax),%eax
  80321d:	8d 50 ff             	lea    -0x1(%eax),%edx
  803220:	83 fa 76             	cmp    $0x76,%edx
  803223:	76 27                	jbe    80324c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  803225:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803229:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80322f:	89 44 24 08          	mov    %eax,0x8(%esp)
  803233:	89 74 24 04          	mov    %esi,0x4(%esp)
  803237:	c7 04 24 c4 50 80 00 	movl   $0x8050c4,(%esp)
  80323e:	e8 77 d2 ff ff       	call   8004ba <_Z7cprintfPKcz>
				++errors;
  803243:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80324a:	eb 28                	jmp    803274 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  80324c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  803251:	74 21                	je     803274 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  803253:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803259:	89 54 24 08          	mov    %edx,0x8(%esp)
  80325d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803261:	c7 04 24 f0 50 80 00 	movl   $0x8050f0,(%esp)
  803268:	e8 4d d2 ff ff       	call   8004ba <_Z7cprintfPKcz>
				++errors;
  80326d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803274:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  80327b:	00 
  80327c:	8d 43 08             	lea    0x8(%ebx),%eax
  80327f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803283:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803289:	89 0c 24             	mov    %ecx,(%esp)
  80328c:	e8 66 da ff ff       	call   800cf7 <memcpy>
  803291:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803295:	bf 77 00 00 00       	mov    $0x77,%edi
  80329a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80329e:	85 ff                	test   %edi,%edi
  8032a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a5:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  8032a8:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  8032af:	00 

			if (de->de_inum >= super->s_ninodes) {
  8032b0:	8b 03                	mov    (%ebx),%eax
  8032b2:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  8032b8:	7c 3e                	jl     8032f8 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  8032ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8032be:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8032c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032c8:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8032ce:	89 54 24 08          	mov    %edx,0x8(%esp)
  8032d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8032d6:	c7 04 24 24 51 80 00 	movl   $0x805124,(%esp)
  8032dd:	e8 d8 d1 ff ff       	call   8004ba <_Z7cprintfPKcz>
				++errors;
  8032e2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8032e9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  8032f0:	00 00 00 
  8032f3:	e9 0b 01 00 00       	jmp    803403 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  8032f8:	e8 70 ed ff ff       	call   80206d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  8032fd:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803304:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  80330b:	c1 e2 08             	shl    $0x8,%edx
  80330e:	09 d1                	or     %edx,%ecx
  803310:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  803317:	c1 e2 10             	shl    $0x10,%edx
  80331a:	09 d1                	or     %edx,%ecx
  80331c:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803323:	83 e2 7f             	and    $0x7f,%edx
  803326:	c1 e2 18             	shl    $0x18,%edx
  803329:	09 ca                	or     %ecx,%edx
  80332b:	83 c2 01             	add    $0x1,%edx
  80332e:	89 d1                	mov    %edx,%ecx
  803330:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  803336:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  80333c:	0f b6 d5             	movzbl %ch,%edx
  80333f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  803345:	89 ca                	mov    %ecx,%edx
  803347:	c1 ea 10             	shr    $0x10,%edx
  80334a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  803350:	c1 e9 18             	shr    $0x18,%ecx
  803353:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  80335a:	83 e2 80             	and    $0xffffff80,%edx
  80335d:	09 ca                	or     %ecx,%edx
  80335f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803365:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803369:	0f 85 7a ff ff ff    	jne    8032e9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  80336f:	8b 03                	mov    (%ebx),%eax
  803371:	89 44 24 10          	mov    %eax,0x10(%esp)
  803375:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80337b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80337f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803385:	89 44 24 08          	mov    %eax,0x8(%esp)
  803389:	89 74 24 04          	mov    %esi,0x4(%esp)
  80338d:	c7 04 24 54 51 80 00 	movl   $0x805154,(%esp)
  803394:	e8 21 d1 ff ff       	call   8004ba <_Z7cprintfPKcz>
					++errors;
  803399:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8033a0:	e9 44 ff ff ff       	jmp    8032e9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  8033a5:	3b 78 04             	cmp    0x4(%eax),%edi
  8033a8:	75 52                	jne    8033fc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  8033aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8033ae:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  8033b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8033b8:	83 c0 08             	add    $0x8,%eax
  8033bb:	89 04 24             	mov    %eax,(%esp)
  8033be:	e8 75 d9 ff ff       	call   800d38 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	75 35                	jne    8033fc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  8033c7:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8033cd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8033d1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8033d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033db:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8033e1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8033e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8033e9:	c7 04 24 84 51 80 00 	movl   $0x805184,(%esp)
  8033f0:	e8 c5 d0 ff ff       	call   8004ba <_Z7cprintfPKcz>
					++errors;
  8033f5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8033fc:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  803403:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803409:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  80340f:	7e 1e                	jle    80342f <_Z4fsckv+0x75c>
  803411:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803415:	7f 18                	jg     80342f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  803417:	89 ca                	mov    %ecx,%edx
  803419:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80341f:	e8 ec eb ff ff       	call   802010 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  803424:	83 38 00             	cmpl   $0x0,(%eax)
  803427:	0f 85 78 ff ff ff    	jne    8033a5 <_Z4fsckv+0x6d2>
  80342d:	eb cd                	jmp    8033fc <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80342f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  803435:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80343b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803441:	83 ea 80             	sub    $0xffffff80,%edx
  803444:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80344a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803450:	3b 51 08             	cmp    0x8(%ecx),%edx
  803453:	0f 8f e7 fc ff ff    	jg     803140 <_Z4fsckv+0x46d>
  803459:	e9 a0 fd ff ff       	jmp    8031fe <_Z4fsckv+0x52b>
  80345e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803464:	89 d8                	mov    %ebx,%eax
  803466:	e8 02 ec ff ff       	call   80206d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  80346b:	8b 50 04             	mov    0x4(%eax),%edx
  80346e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803475:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80347c:	c1 e7 08             	shl    $0x8,%edi
  80347f:	09 f9                	or     %edi,%ecx
  803481:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803488:	c1 e7 10             	shl    $0x10,%edi
  80348b:	09 f9                	or     %edi,%ecx
  80348d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803494:	83 e7 7f             	and    $0x7f,%edi
  803497:	c1 e7 18             	shl    $0x18,%edi
  80349a:	09 f9                	or     %edi,%ecx
  80349c:	39 ca                	cmp    %ecx,%edx
  80349e:	74 1b                	je     8034bb <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  8034a0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034a4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8034a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8034ac:	c7 04 24 b4 51 80 00 	movl   $0x8051b4,(%esp)
  8034b3:	e8 02 d0 ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  8034b8:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  8034bb:	83 c3 01             	add    $0x1,%ebx
  8034be:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  8034c4:	7f 9e                	jg     803464 <_Z4fsckv+0x791>
  8034c6:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8034cc:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  8034d3:	7e 4f                	jle    803524 <_Z4fsckv+0x851>
  8034d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8034da:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  8034e0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  8034e7:	3c ff                	cmp    $0xff,%al
  8034e9:	75 09                	jne    8034f4 <_Z4fsckv+0x821>
			freemap[i] = 0;
  8034eb:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  8034f2:	eb 1f                	jmp    803513 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  8034f4:	84 c0                	test   %al,%al
  8034f6:	75 1b                	jne    803513 <_Z4fsckv+0x840>
  8034f8:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  8034fe:	7c 13                	jl     803513 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803500:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803504:	c7 04 24 e0 51 80 00 	movl   $0x8051e0,(%esp)
  80350b:	e8 aa cf ff ff       	call   8004ba <_Z7cprintfPKcz>
			++errors;
  803510:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803513:	83 c3 01             	add    $0x1,%ebx
  803516:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  80351c:	7f c2                	jg     8034e0 <_Z4fsckv+0x80d>
  80351e:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803524:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80352b:	19 c0                	sbb    %eax,%eax
  80352d:	f7 d0                	not    %eax
  80352f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  803532:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  803538:	5b                   	pop    %ebx
  803539:	5e                   	pop    %esi
  80353a:	5f                   	pop    %edi
  80353b:	5d                   	pop    %ebp
  80353c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  80353d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803544:	0f 84 92 f9 ff ff    	je     802edc <_Z4fsckv+0x209>
  80354a:	e9 5a f9 ff ff       	jmp    802ea9 <_Z4fsckv+0x1d6>
	...

00803550 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803550:	55                   	push   %ebp
  803551:	89 e5                	mov    %esp,%ebp
  803553:	83 ec 18             	sub    $0x18,%esp
  803556:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803559:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80355c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	89 04 24             	mov    %eax,(%esp)
  803565:	e8 a2 e4 ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  80356a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80356c:	c7 44 24 04 13 52 80 	movl   $0x805213,0x4(%esp)
  803573:	00 
  803574:	89 34 24             	mov    %esi,(%esp)
  803577:	e8 5e d5 ff ff       	call   800ada <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80357c:	8b 43 04             	mov    0x4(%ebx),%eax
  80357f:	2b 03                	sub    (%ebx),%eax
  803581:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803584:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80358b:	c7 86 80 00 00 00 24 	movl   $0x806024,0x80(%esi)
  803592:	60 80 00 
	return 0;
}
  803595:	b8 00 00 00 00       	mov    $0x0,%eax
  80359a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80359d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8035a0:	89 ec                	mov    %ebp,%esp
  8035a2:	5d                   	pop    %ebp
  8035a3:	c3                   	ret    

008035a4 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  8035a4:	55                   	push   %ebp
  8035a5:	89 e5                	mov    %esp,%ebp
  8035a7:	53                   	push   %ebx
  8035a8:	83 ec 14             	sub    $0x14,%esp
  8035ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8035ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8035b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035b9:	e8 bf da ff ff       	call   80107d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  8035be:	89 1c 24             	mov    %ebx,(%esp)
  8035c1:	e8 46 e4 ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  8035c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035d1:	e8 a7 da ff ff       	call   80107d <_Z14sys_page_unmapiPv>
}
  8035d6:	83 c4 14             	add    $0x14,%esp
  8035d9:	5b                   	pop    %ebx
  8035da:	5d                   	pop    %ebp
  8035db:	c3                   	ret    

008035dc <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035dc:	55                   	push   %ebp
  8035dd:	89 e5                	mov    %esp,%ebp
  8035df:	57                   	push   %edi
  8035e0:	56                   	push   %esi
  8035e1:	53                   	push   %ebx
  8035e2:	83 ec 2c             	sub    $0x2c,%esp
  8035e5:	89 c7                	mov    %eax,%edi
  8035e7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  8035ea:	a1 00 70 80 00       	mov    0x807000,%eax
  8035ef:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  8035f2:	89 3c 24             	mov    %edi,(%esp)
  8035f5:	e8 82 04 00 00       	call   803a7c <_Z7pagerefPv>
  8035fa:	89 c3                	mov    %eax,%ebx
  8035fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ff:	89 04 24             	mov    %eax,(%esp)
  803602:	e8 75 04 00 00       	call   803a7c <_Z7pagerefPv>
  803607:	39 c3                	cmp    %eax,%ebx
  803609:	0f 94 c0             	sete   %al
  80360c:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  80360f:	8b 15 00 70 80 00    	mov    0x807000,%edx
  803615:	8b 52 58             	mov    0x58(%edx),%edx
  803618:	39 d6                	cmp    %edx,%esi
  80361a:	75 08                	jne    803624 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  80361c:	83 c4 2c             	add    $0x2c,%esp
  80361f:	5b                   	pop    %ebx
  803620:	5e                   	pop    %esi
  803621:	5f                   	pop    %edi
  803622:	5d                   	pop    %ebp
  803623:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803624:	85 c0                	test   %eax,%eax
  803626:	74 c2                	je     8035ea <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803628:	c7 04 24 1a 52 80 00 	movl   $0x80521a,(%esp)
  80362f:	e8 86 ce ff ff       	call   8004ba <_Z7cprintfPKcz>
  803634:	eb b4                	jmp    8035ea <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00803636 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803636:	55                   	push   %ebp
  803637:	89 e5                	mov    %esp,%ebp
  803639:	57                   	push   %edi
  80363a:	56                   	push   %esi
  80363b:	53                   	push   %ebx
  80363c:	83 ec 1c             	sub    $0x1c,%esp
  80363f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803642:	89 34 24             	mov    %esi,(%esp)
  803645:	e8 c2 e3 ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  80364a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80364c:	bf 00 00 00 00       	mov    $0x0,%edi
  803651:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803655:	75 46                	jne    80369d <_ZL13devpipe_writeP2FdPKvj+0x67>
  803657:	eb 52                	jmp    8036ab <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803659:	89 da                	mov    %ebx,%edx
  80365b:	89 f0                	mov    %esi,%eax
  80365d:	e8 7a ff ff ff       	call   8035dc <_ZL13_pipeisclosedP2FdP4Pipe>
  803662:	85 c0                	test   %eax,%eax
  803664:	75 49                	jne    8036af <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803666:	e8 21 d9 ff ff       	call   800f8c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80366b:	8b 43 04             	mov    0x4(%ebx),%eax
  80366e:	89 c2                	mov    %eax,%edx
  803670:	2b 13                	sub    (%ebx),%edx
  803672:	83 fa 20             	cmp    $0x20,%edx
  803675:	74 e2                	je     803659 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803677:	89 c2                	mov    %eax,%edx
  803679:	c1 fa 1f             	sar    $0x1f,%edx
  80367c:	c1 ea 1b             	shr    $0x1b,%edx
  80367f:	01 d0                	add    %edx,%eax
  803681:	83 e0 1f             	and    $0x1f,%eax
  803684:	29 d0                	sub    %edx,%eax
  803686:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803689:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80368d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803691:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803695:	83 c7 01             	add    $0x1,%edi
  803698:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80369b:	76 0e                	jbe    8036ab <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80369d:	8b 43 04             	mov    0x4(%ebx),%eax
  8036a0:	89 c2                	mov    %eax,%edx
  8036a2:	2b 13                	sub    (%ebx),%edx
  8036a4:	83 fa 20             	cmp    $0x20,%edx
  8036a7:	74 b0                	je     803659 <_ZL13devpipe_writeP2FdPKvj+0x23>
  8036a9:	eb cc                	jmp    803677 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  8036ab:	89 f8                	mov    %edi,%eax
  8036ad:	eb 05                	jmp    8036b4 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  8036af:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  8036b4:	83 c4 1c             	add    $0x1c,%esp
  8036b7:	5b                   	pop    %ebx
  8036b8:	5e                   	pop    %esi
  8036b9:	5f                   	pop    %edi
  8036ba:	5d                   	pop    %ebp
  8036bb:	c3                   	ret    

008036bc <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8036bc:	55                   	push   %ebp
  8036bd:	89 e5                	mov    %esp,%ebp
  8036bf:	83 ec 28             	sub    $0x28,%esp
  8036c2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8036c5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8036c8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8036cb:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8036ce:	89 3c 24             	mov    %edi,(%esp)
  8036d1:	e8 36 e3 ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  8036d6:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8036d8:	be 00 00 00 00       	mov    $0x0,%esi
  8036dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8036e1:	75 47                	jne    80372a <_ZL12devpipe_readP2FdPvj+0x6e>
  8036e3:	eb 52                	jmp    803737 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  8036e5:	89 f0                	mov    %esi,%eax
  8036e7:	eb 5e                	jmp    803747 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  8036e9:	89 da                	mov    %ebx,%edx
  8036eb:	89 f8                	mov    %edi,%eax
  8036ed:	8d 76 00             	lea    0x0(%esi),%esi
  8036f0:	e8 e7 fe ff ff       	call   8035dc <_ZL13_pipeisclosedP2FdP4Pipe>
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	75 49                	jne    803742 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  8036f9:	e8 8e d8 ff ff       	call   800f8c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8036fe:	8b 03                	mov    (%ebx),%eax
  803700:	3b 43 04             	cmp    0x4(%ebx),%eax
  803703:	74 e4                	je     8036e9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803705:	89 c2                	mov    %eax,%edx
  803707:	c1 fa 1f             	sar    $0x1f,%edx
  80370a:	c1 ea 1b             	shr    $0x1b,%edx
  80370d:	01 d0                	add    %edx,%eax
  80370f:	83 e0 1f             	and    $0x1f,%eax
  803712:	29 d0                	sub    %edx,%eax
  803714:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80371c:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  80371f:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803722:	83 c6 01             	add    $0x1,%esi
  803725:	39 75 10             	cmp    %esi,0x10(%ebp)
  803728:	76 0d                	jbe    803737 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80372a:	8b 03                	mov    (%ebx),%eax
  80372c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80372f:	75 d4                	jne    803705 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803731:	85 f6                	test   %esi,%esi
  803733:	75 b0                	jne    8036e5 <_ZL12devpipe_readP2FdPvj+0x29>
  803735:	eb b2                	jmp    8036e9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803737:	89 f0                	mov    %esi,%eax
  803739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803740:	eb 05                	jmp    803747 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803742:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803747:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80374a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80374d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803750:	89 ec                	mov    %ebp,%esp
  803752:	5d                   	pop    %ebp
  803753:	c3                   	ret    

00803754 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803754:	55                   	push   %ebp
  803755:	89 e5                	mov    %esp,%ebp
  803757:	83 ec 48             	sub    $0x48,%esp
  80375a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80375d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803760:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803763:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803766:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803769:	89 04 24             	mov    %eax,(%esp)
  80376c:	e8 b6 e2 ff ff       	call   801a27 <_Z14fd_find_unusedPP2Fd>
  803771:	89 c3                	mov    %eax,%ebx
  803773:	85 c0                	test   %eax,%eax
  803775:	0f 88 0b 01 00 00    	js     803886 <_Z4pipePi+0x132>
  80377b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803782:	00 
  803783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803786:	89 44 24 04          	mov    %eax,0x4(%esp)
  80378a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803791:	e8 2a d8 ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  803796:	89 c3                	mov    %eax,%ebx
  803798:	85 c0                	test   %eax,%eax
  80379a:	0f 89 f5 00 00 00    	jns    803895 <_Z4pipePi+0x141>
  8037a0:	e9 e1 00 00 00       	jmp    803886 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  8037a5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8037ac:	00 
  8037ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037bb:	e8 00 d8 ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  8037c0:	89 c3                	mov    %eax,%ebx
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	0f 89 e2 00 00 00    	jns    8038ac <_Z4pipePi+0x158>
  8037ca:	e9 a4 00 00 00       	jmp    803873 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d2:	89 04 24             	mov    %eax,(%esp)
  8037d5:	e8 32 e2 ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  8037da:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8037e1:	00 
  8037e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8037ed:	00 
  8037ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8037f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037f9:	e8 21 d8 ff ff       	call   80101f <_Z12sys_page_mapiPviS_i>
  8037fe:	89 c3                	mov    %eax,%ebx
  803800:	85 c0                	test   %eax,%eax
  803802:	78 4c                	js     803850 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803804:	8b 15 24 60 80 00    	mov    0x806024,%edx
  80380a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80380f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803812:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803819:	8b 15 24 60 80 00    	mov    0x806024,%edx
  80381f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803822:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803824:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803827:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80382e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803831:	89 04 24             	mov    %eax,(%esp)
  803834:	e8 8b e1 ff ff       	call   8019c4 <_Z6fd2numP2Fd>
  803839:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80383b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383e:	89 04 24             	mov    %eax,(%esp)
  803841:	e8 7e e1 ff ff       	call   8019c4 <_Z6fd2numP2Fd>
  803846:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803849:	bb 00 00 00 00       	mov    $0x0,%ebx
  80384e:	eb 36                	jmp    803886 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803850:	89 74 24 04          	mov    %esi,0x4(%esp)
  803854:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80385b:	e8 1d d8 ff ff       	call   80107d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803860:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803863:	89 44 24 04          	mov    %eax,0x4(%esp)
  803867:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80386e:	e8 0a d8 ff ff       	call   80107d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803876:	89 44 24 04          	mov    %eax,0x4(%esp)
  80387a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803881:	e8 f7 d7 ff ff       	call   80107d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803886:	89 d8                	mov    %ebx,%eax
  803888:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80388b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80388e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803891:	89 ec                	mov    %ebp,%esp
  803893:	5d                   	pop    %ebp
  803894:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803895:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803898:	89 04 24             	mov    %eax,(%esp)
  80389b:	e8 87 e1 ff ff       	call   801a27 <_Z14fd_find_unusedPP2Fd>
  8038a0:	89 c3                	mov    %eax,%ebx
  8038a2:	85 c0                	test   %eax,%eax
  8038a4:	0f 89 fb fe ff ff    	jns    8037a5 <_Z4pipePi+0x51>
  8038aa:	eb c7                	jmp    803873 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8038ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038af:	89 04 24             	mov    %eax,(%esp)
  8038b2:	e8 55 e1 ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  8038b7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038b9:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8038c0:	00 
  8038c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038cc:	e8 ef d6 ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  8038d1:	89 c3                	mov    %eax,%ebx
  8038d3:	85 c0                	test   %eax,%eax
  8038d5:	0f 89 f4 fe ff ff    	jns    8037cf <_Z4pipePi+0x7b>
  8038db:	eb 83                	jmp    803860 <_Z4pipePi+0x10c>

008038dd <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  8038dd:	55                   	push   %ebp
  8038de:	89 e5                	mov    %esp,%ebp
  8038e0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8038e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8038ea:	00 
  8038eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8038ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f5:	89 04 24             	mov    %eax,(%esp)
  8038f8:	e8 74 e0 ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  8038fd:	85 c0                	test   %eax,%eax
  8038ff:	78 15                	js     803916 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803904:	89 04 24             	mov    %eax,(%esp)
  803907:	e8 00 e1 ff ff       	call   801a0c <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  80390c:	89 c2                	mov    %eax,%edx
  80390e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803911:	e8 c6 fc ff ff       	call   8035dc <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803916:	c9                   	leave  
  803917:	c3                   	ret    

00803918 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803918:	55                   	push   %ebp
  803919:	89 e5                	mov    %esp,%ebp
  80391b:	53                   	push   %ebx
  80391c:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  80391f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803922:	89 04 24             	mov    %eax,(%esp)
  803925:	e8 fd e0 ff ff       	call   801a27 <_Z14fd_find_unusedPP2Fd>
  80392a:	89 c3                	mov    %eax,%ebx
  80392c:	85 c0                	test   %eax,%eax
  80392e:	0f 88 be 00 00 00    	js     8039f2 <_Z18pipe_ipc_recv_readv+0xda>
  803934:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80393b:	00 
  80393c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803943:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80394a:	e8 71 d6 ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  80394f:	89 c3                	mov    %eax,%ebx
  803951:	85 c0                	test   %eax,%eax
  803953:	0f 89 a1 00 00 00    	jns    8039fa <_Z18pipe_ipc_recv_readv+0xe2>
  803959:	e9 94 00 00 00       	jmp    8039f2 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80395e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803961:	85 c0                	test   %eax,%eax
  803963:	75 0e                	jne    803973 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803965:	c7 04 24 78 52 80 00 	movl   $0x805278,(%esp)
  80396c:	e8 49 cb ff ff       	call   8004ba <_Z7cprintfPKcz>
  803971:	eb 10                	jmp    803983 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803973:	89 44 24 04          	mov    %eax,0x4(%esp)
  803977:	c7 04 24 2d 52 80 00 	movl   $0x80522d,(%esp)
  80397e:	e8 37 cb ff ff       	call   8004ba <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803983:	c7 04 24 37 52 80 00 	movl   $0x805237,(%esp)
  80398a:	e8 2b cb ff ff       	call   8004ba <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80398f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803992:	a8 04                	test   $0x4,%al
  803994:	74 04                	je     80399a <_Z18pipe_ipc_recv_readv+0x82>
  803996:	a8 01                	test   $0x1,%al
  803998:	75 24                	jne    8039be <_Z18pipe_ipc_recv_readv+0xa6>
  80399a:	c7 44 24 0c 4a 52 80 	movl   $0x80524a,0xc(%esp)
  8039a1:	00 
  8039a2:	c7 44 24 08 14 4c 80 	movl   $0x804c14,0x8(%esp)
  8039a9:	00 
  8039aa:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8039b1:	00 
  8039b2:	c7 04 24 67 52 80 00 	movl   $0x805267,(%esp)
  8039b9:	e8 de c9 ff ff       	call   80039c <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  8039be:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8039c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c7:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  8039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  8039d3:	89 04 24             	mov    %eax,(%esp)
  8039d6:	e8 e9 df ff ff       	call   8019c4 <_Z6fd2numP2Fd>
  8039db:	89 c3                	mov    %eax,%ebx
  8039dd:	eb 13                	jmp    8039f2 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  8039df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039ed:	e8 8b d6 ff ff       	call   80107d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  8039f2:	89 d8                	mov    %ebx,%eax
  8039f4:	83 c4 24             	add    $0x24,%esp
  8039f7:	5b                   	pop    %ebx
  8039f8:	5d                   	pop    %ebp
  8039f9:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  8039fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fd:	89 04 24             	mov    %eax,(%esp)
  803a00:	e8 07 e0 ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  803a05:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803a08:	89 54 24 08          	mov    %edx,0x8(%esp)
  803a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803a13:	89 04 24             	mov    %eax,(%esp)
  803a16:	e8 f5 08 00 00       	call   804310 <_Z8ipc_recvPiPvS_>
  803a1b:	89 c3                	mov    %eax,%ebx
  803a1d:	85 c0                	test   %eax,%eax
  803a1f:	0f 89 39 ff ff ff    	jns    80395e <_Z18pipe_ipc_recv_readv+0x46>
  803a25:	eb b8                	jmp    8039df <_Z18pipe_ipc_recv_readv+0xc7>

00803a27 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803a27:	55                   	push   %ebp
  803a28:	89 e5                	mov    %esp,%ebp
  803a2a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  803a2d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803a34:	00 
  803a35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a3f:	89 04 24             	mov    %eax,(%esp)
  803a42:	e8 2a df ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  803a47:	85 c0                	test   %eax,%eax
  803a49:	78 2f                	js     803a7a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  803a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4e:	89 04 24             	mov    %eax,(%esp)
  803a51:	e8 b6 df ff ff       	call   801a0c <_Z7fd2dataP2Fd>
  803a56:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803a5d:	00 
  803a5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803a69:	00 
  803a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6d:	89 04 24             	mov    %eax,(%esp)
  803a70:	e8 2a 09 00 00       	call   80439f <_Z8ipc_sendijPvi>
    return 0;
  803a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a7a:	c9                   	leave  
  803a7b:	c3                   	ret    

00803a7c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803a7c:	55                   	push   %ebp
  803a7d:	89 e5                	mov    %esp,%ebp
  803a7f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803a82:	89 d0                	mov    %edx,%eax
  803a84:	c1 e8 16             	shr    $0x16,%eax
  803a87:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  803a8e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803a93:	f6 c1 01             	test   $0x1,%cl
  803a96:	74 1d                	je     803ab5 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803a98:	c1 ea 0c             	shr    $0xc,%edx
  803a9b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803aa2:	f6 c2 01             	test   $0x1,%dl
  803aa5:	74 0e                	je     803ab5 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803aa7:	c1 ea 0c             	shr    $0xc,%edx
  803aaa:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803ab1:	ef 
  803ab2:	0f b7 c0             	movzwl %ax,%eax
}
  803ab5:	5d                   	pop    %ebp
  803ab6:	c3                   	ret    
	...

00803ac0 <_Z4waiti>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803ac0:	55                   	push   %ebp
  803ac1:	89 e5                	mov    %esp,%ebp
  803ac3:	56                   	push   %esi
  803ac4:	53                   	push   %ebx
  803ac5:	83 ec 10             	sub    $0x10,%esp
  803ac8:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803acb:	85 f6                	test   %esi,%esi
  803acd:	75 24                	jne    803af3 <_Z4waiti+0x33>
  803acf:	c7 44 24 0c 9b 52 80 	movl   $0x80529b,0xc(%esp)
  803ad6:	00 
  803ad7:	c7 44 24 08 14 4c 80 	movl   $0x804c14,0x8(%esp)
  803ade:	00 
  803adf:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  803ae6:	00 
  803ae7:	c7 04 24 a6 52 80 00 	movl   $0x8052a6,(%esp)
  803aee:	e8 a9 c8 ff ff       	call   80039c <_Z6_panicPKciS0_z>
	e = &envs[ENVX(envid)];
  803af3:	89 f3                	mov    %esi,%ebx
  803af5:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803afb:	6b db 78             	imul   $0x78,%ebx,%ebx
  803afe:	8b 83 04 00 00 ef    	mov    -0x10fffffc(%ebx),%eax
  803b04:	39 f0                	cmp    %esi,%eax
  803b06:	75 11                	jne    803b19 <_Z4waiti+0x59>
  803b08:	8b 83 0c 00 00 ef    	mov    -0x10fffff4(%ebx),%eax
  803b0e:	85 c0                	test   %eax,%eax
  803b10:	74 07                	je     803b19 <_Z4waiti+0x59>
		sys_yield();
  803b12:	e8 75 d4 ff ff       	call   800f8c <_Z9sys_yieldv>
  803b17:	eb e5                	jmp    803afe <_Z4waiti+0x3e>
}
  803b19:	83 c4 10             	add    $0x10,%esp
  803b1c:	5b                   	pop    %ebx
  803b1d:	5e                   	pop    %esi
  803b1e:	5d                   	pop    %ebp
  803b1f:	90                   	nop
  803b20:	c3                   	ret    
	...

00803b30 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803b30:	55                   	push   %ebp
  803b31:	89 e5                	mov    %esp,%ebp
  803b33:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803b36:	c7 44 24 04 b1 52 80 	movl   $0x8052b1,0x4(%esp)
  803b3d:	00 
  803b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b41:	89 04 24             	mov    %eax,(%esp)
  803b44:	e8 91 cf ff ff       	call   800ada <_Z6strcpyPcPKc>
	return 0;
}
  803b49:	b8 00 00 00 00       	mov    $0x0,%eax
  803b4e:	c9                   	leave  
  803b4f:	c3                   	ret    

00803b50 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803b50:	55                   	push   %ebp
  803b51:	89 e5                	mov    %esp,%ebp
  803b53:	53                   	push   %ebx
  803b54:	83 ec 14             	sub    $0x14,%esp
  803b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803b5a:	89 1c 24             	mov    %ebx,(%esp)
  803b5d:	e8 1a ff ff ff       	call   803a7c <_Z7pagerefPv>
  803b62:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803b64:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803b69:	83 fa 01             	cmp    $0x1,%edx
  803b6c:	75 0b                	jne    803b79 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  803b6e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803b71:	89 04 24             	mov    %eax,(%esp)
  803b74:	e8 fe 02 00 00       	call   803e77 <_Z11nsipc_closei>
	else
		return 0;
}
  803b79:	83 c4 14             	add    $0x14,%esp
  803b7c:	5b                   	pop    %ebx
  803b7d:	5d                   	pop    %ebp
  803b7e:	c3                   	ret    

00803b7f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803b7f:	55                   	push   %ebp
  803b80:	89 e5                	mov    %esp,%ebp
  803b82:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803b85:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803b8c:	00 
  803b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  803b90:	89 44 24 08          	mov    %eax,0x8(%esp)
  803b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  803ba1:	89 04 24             	mov    %eax,(%esp)
  803ba4:	e8 c9 03 00 00       	call   803f72 <_Z10nsipc_sendiPKvij>
}
  803ba9:	c9                   	leave  
  803baa:	c3                   	ret    

00803bab <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803bab:	55                   	push   %ebp
  803bac:	89 e5                	mov    %esp,%ebp
  803bae:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803bb1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803bb8:	00 
  803bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  803bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  803bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bca:	8b 40 0c             	mov    0xc(%eax),%eax
  803bcd:	89 04 24             	mov    %eax,(%esp)
  803bd0:	e8 1d 03 00 00       	call   803ef2 <_Z10nsipc_recviPvij>
}
  803bd5:	c9                   	leave  
  803bd6:	c3                   	ret    

00803bd7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803bd7:	55                   	push   %ebp
  803bd8:	89 e5                	mov    %esp,%ebp
  803bda:	83 ec 28             	sub    $0x28,%esp
  803bdd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803be0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803be3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803be5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803be8:	89 04 24             	mov    %eax,(%esp)
  803beb:	e8 37 de ff ff       	call   801a27 <_Z14fd_find_unusedPP2Fd>
  803bf0:	89 c3                	mov    %eax,%ebx
  803bf2:	85 c0                	test   %eax,%eax
  803bf4:	78 21                	js     803c17 <_ZL12alloc_sockfdi+0x40>
  803bf6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803bfd:	00 
  803bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c0c:	e8 af d3 ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  803c11:	89 c3                	mov    %eax,%ebx
  803c13:	85 c0                	test   %eax,%eax
  803c15:	79 14                	jns    803c2b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803c17:	89 34 24             	mov    %esi,(%esp)
  803c1a:	e8 58 02 00 00       	call   803e77 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803c1f:	89 d8                	mov    %ebx,%eax
  803c21:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803c24:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803c27:	89 ec                	mov    %ebp,%esp
  803c29:	5d                   	pop    %ebp
  803c2a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803c2b:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c34:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c39:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803c40:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803c43:	89 04 24             	mov    %eax,(%esp)
  803c46:	e8 79 dd ff ff       	call   8019c4 <_Z6fd2numP2Fd>
  803c4b:	89 c3                	mov    %eax,%ebx
  803c4d:	eb d0                	jmp    803c1f <_ZL12alloc_sockfdi+0x48>

00803c4f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803c4f:	55                   	push   %ebp
  803c50:	89 e5                	mov    %esp,%ebp
  803c52:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803c55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803c5c:	00 
  803c5d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803c60:	89 54 24 04          	mov    %edx,0x4(%esp)
  803c64:	89 04 24             	mov    %eax,(%esp)
  803c67:	e8 05 dd ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  803c6c:	85 c0                	test   %eax,%eax
  803c6e:	78 15                	js     803c85 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803c73:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803c78:	8b 0d 40 60 80 00    	mov    0x806040,%ecx
  803c7e:	39 0a                	cmp    %ecx,(%edx)
  803c80:	75 03                	jne    803c85 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803c82:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803c85:	c9                   	leave  
  803c86:	c3                   	ret    

00803c87 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c87:	55                   	push   %ebp
  803c88:	89 e5                	mov    %esp,%ebp
  803c8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c90:	e8 ba ff ff ff       	call   803c4f <_ZL9fd2sockidi>
  803c95:	85 c0                	test   %eax,%eax
  803c97:	78 1f                	js     803cb8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803c99:	8b 55 10             	mov    0x10(%ebp),%edx
  803c9c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ca3:	89 54 24 04          	mov    %edx,0x4(%esp)
  803ca7:	89 04 24             	mov    %eax,(%esp)
  803caa:	e8 19 01 00 00       	call   803dc8 <_Z12nsipc_acceptiP8sockaddrPj>
  803caf:	85 c0                	test   %eax,%eax
  803cb1:	78 05                	js     803cb8 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803cb3:	e8 1f ff ff ff       	call   803bd7 <_ZL12alloc_sockfdi>
}
  803cb8:	c9                   	leave  
  803cb9:	c3                   	ret    

00803cba <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803cba:	55                   	push   %ebp
  803cbb:	89 e5                	mov    %esp,%ebp
  803cbd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc3:	e8 87 ff ff ff       	call   803c4f <_ZL9fd2sockidi>
  803cc8:	85 c0                	test   %eax,%eax
  803cca:	78 16                	js     803ce2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803ccc:	8b 55 10             	mov    0x10(%ebp),%edx
  803ccf:	89 54 24 08          	mov    %edx,0x8(%esp)
  803cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cd6:	89 54 24 04          	mov    %edx,0x4(%esp)
  803cda:	89 04 24             	mov    %eax,(%esp)
  803cdd:	e8 34 01 00 00       	call   803e16 <_Z10nsipc_bindiP8sockaddrj>
}
  803ce2:	c9                   	leave  
  803ce3:	c3                   	ret    

00803ce4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803ce4:	55                   	push   %ebp
  803ce5:	89 e5                	mov    %esp,%ebp
  803ce7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803cea:	8b 45 08             	mov    0x8(%ebp),%eax
  803ced:	e8 5d ff ff ff       	call   803c4f <_ZL9fd2sockidi>
  803cf2:	85 c0                	test   %eax,%eax
  803cf4:	78 0f                	js     803d05 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803cf9:	89 54 24 04          	mov    %edx,0x4(%esp)
  803cfd:	89 04 24             	mov    %eax,(%esp)
  803d00:	e8 50 01 00 00       	call   803e55 <_Z14nsipc_shutdownii>
}
  803d05:	c9                   	leave  
  803d06:	c3                   	ret    

00803d07 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d07:	55                   	push   %ebp
  803d08:	89 e5                	mov    %esp,%ebp
  803d0a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d10:	e8 3a ff ff ff       	call   803c4f <_ZL9fd2sockidi>
  803d15:	85 c0                	test   %eax,%eax
  803d17:	78 16                	js     803d2f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803d19:	8b 55 10             	mov    0x10(%ebp),%edx
  803d1c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d23:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d27:	89 04 24             	mov    %eax,(%esp)
  803d2a:	e8 62 01 00 00       	call   803e91 <_Z13nsipc_connectiPK8sockaddrj>
}
  803d2f:	c9                   	leave  
  803d30:	c3                   	ret    

00803d31 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803d31:	55                   	push   %ebp
  803d32:	89 e5                	mov    %esp,%ebp
  803d34:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d37:	8b 45 08             	mov    0x8(%ebp),%eax
  803d3a:	e8 10 ff ff ff       	call   803c4f <_ZL9fd2sockidi>
  803d3f:	85 c0                	test   %eax,%eax
  803d41:	78 0f                	js     803d52 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d46:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d4a:	89 04 24             	mov    %eax,(%esp)
  803d4d:	e8 7e 01 00 00       	call   803ed0 <_Z12nsipc_listenii>
}
  803d52:	c9                   	leave  
  803d53:	c3                   	ret    

00803d54 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803d54:	55                   	push   %ebp
  803d55:	89 e5                	mov    %esp,%ebp
  803d57:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  803d5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d68:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6b:	89 04 24             	mov    %eax,(%esp)
  803d6e:	e8 72 02 00 00       	call   803fe5 <_Z12nsipc_socketiii>
  803d73:	85 c0                	test   %eax,%eax
  803d75:	78 05                	js     803d7c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803d77:	e8 5b fe ff ff       	call   803bd7 <_ZL12alloc_sockfdi>
}
  803d7c:	c9                   	leave  
  803d7d:	8d 76 00             	lea    0x0(%esi),%esi
  803d80:	c3                   	ret    
  803d81:	00 00                	add    %al,(%eax)
	...

00803d84 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803d84:	55                   	push   %ebp
  803d85:	89 e5                	mov    %esp,%ebp
  803d87:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803d8a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803d91:	00 
  803d92:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803d99:	00 
  803d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d9e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803da5:	e8 f5 05 00 00       	call   80439f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803daa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803db1:	00 
  803db2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803db9:	00 
  803dba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803dc1:	e8 4a 05 00 00       	call   804310 <_Z8ipc_recvPiPvS_>
}
  803dc6:	c9                   	leave  
  803dc7:	c3                   	ret    

00803dc8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803dc8:	55                   	push   %ebp
  803dc9:	89 e5                	mov    %esp,%ebp
  803dcb:	53                   	push   %ebx
  803dcc:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd2:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803dd7:	b8 01 00 00 00       	mov    $0x1,%eax
  803ddc:	e8 a3 ff ff ff       	call   803d84 <_ZL5nsipcj>
  803de1:	89 c3                	mov    %eax,%ebx
  803de3:	85 c0                	test   %eax,%eax
  803de5:	78 27                	js     803e0e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803de7:	a1 10 80 80 00       	mov    0x808010,%eax
  803dec:	89 44 24 08          	mov    %eax,0x8(%esp)
  803df0:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803df7:	00 
  803df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dfb:	89 04 24             	mov    %eax,(%esp)
  803dfe:	e8 79 ce ff ff       	call   800c7c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803e03:	8b 15 10 80 80 00    	mov    0x808010,%edx
  803e09:	8b 45 10             	mov    0x10(%ebp),%eax
  803e0c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803e0e:	89 d8                	mov    %ebx,%eax
  803e10:	83 c4 14             	add    $0x14,%esp
  803e13:	5b                   	pop    %ebx
  803e14:	5d                   	pop    %ebp
  803e15:	c3                   	ret    

00803e16 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803e16:	55                   	push   %ebp
  803e17:	89 e5                	mov    %esp,%ebp
  803e19:	53                   	push   %ebx
  803e1a:	83 ec 14             	sub    $0x14,%esp
  803e1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803e20:	8b 45 08             	mov    0x8(%ebp),%eax
  803e23:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803e28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e33:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803e3a:	e8 3d ce ff ff       	call   800c7c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803e3f:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803e45:	b8 02 00 00 00       	mov    $0x2,%eax
  803e4a:	e8 35 ff ff ff       	call   803d84 <_ZL5nsipcj>
}
  803e4f:	83 c4 14             	add    $0x14,%esp
  803e52:	5b                   	pop    %ebx
  803e53:	5d                   	pop    %ebp
  803e54:	c3                   	ret    

00803e55 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803e55:	55                   	push   %ebp
  803e56:	89 e5                	mov    %esp,%ebp
  803e58:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e66:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803e6b:	b8 03 00 00 00       	mov    $0x3,%eax
  803e70:	e8 0f ff ff ff       	call   803d84 <_ZL5nsipcj>
}
  803e75:	c9                   	leave  
  803e76:	c3                   	ret    

00803e77 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803e77:	55                   	push   %ebp
  803e78:	89 e5                	mov    %esp,%ebp
  803e7a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e80:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803e85:	b8 04 00 00 00       	mov    $0x4,%eax
  803e8a:	e8 f5 fe ff ff       	call   803d84 <_ZL5nsipcj>
}
  803e8f:	c9                   	leave  
  803e90:	c3                   	ret    

00803e91 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803e91:	55                   	push   %ebp
  803e92:	89 e5                	mov    %esp,%ebp
  803e94:	53                   	push   %ebx
  803e95:	83 ec 14             	sub    $0x14,%esp
  803e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ea3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eae:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803eb5:	e8 c2 cd ff ff       	call   800c7c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803eba:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803ec0:	b8 05 00 00 00       	mov    $0x5,%eax
  803ec5:	e8 ba fe ff ff       	call   803d84 <_ZL5nsipcj>
}
  803eca:	83 c4 14             	add    $0x14,%esp
  803ecd:	5b                   	pop    %ebx
  803ece:	5d                   	pop    %ebp
  803ecf:	c3                   	ret    

00803ed0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803ed0:	55                   	push   %ebp
  803ed1:	89 e5                	mov    %esp,%ebp
  803ed3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed9:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ee1:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803ee6:	b8 06 00 00 00       	mov    $0x6,%eax
  803eeb:	e8 94 fe ff ff       	call   803d84 <_ZL5nsipcj>
}
  803ef0:	c9                   	leave  
  803ef1:	c3                   	ret    

00803ef2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803ef2:	55                   	push   %ebp
  803ef3:	89 e5                	mov    %esp,%ebp
  803ef5:	56                   	push   %esi
  803ef6:	53                   	push   %ebx
  803ef7:	83 ec 10             	sub    $0x10,%esp
  803efa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803efd:	8b 45 08             	mov    0x8(%ebp),%eax
  803f00:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803f05:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803f0b:	8b 45 14             	mov    0x14(%ebp),%eax
  803f0e:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803f13:	b8 07 00 00 00       	mov    $0x7,%eax
  803f18:	e8 67 fe ff ff       	call   803d84 <_ZL5nsipcj>
  803f1d:	89 c3                	mov    %eax,%ebx
  803f1f:	85 c0                	test   %eax,%eax
  803f21:	78 46                	js     803f69 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803f23:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803f28:	7f 04                	jg     803f2e <_Z10nsipc_recviPvij+0x3c>
  803f2a:	39 f0                	cmp    %esi,%eax
  803f2c:	7e 24                	jle    803f52 <_Z10nsipc_recviPvij+0x60>
  803f2e:	c7 44 24 0c bd 52 80 	movl   $0x8052bd,0xc(%esp)
  803f35:	00 
  803f36:	c7 44 24 08 14 4c 80 	movl   $0x804c14,0x8(%esp)
  803f3d:	00 
  803f3e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803f45:	00 
  803f46:	c7 04 24 d2 52 80 00 	movl   $0x8052d2,(%esp)
  803f4d:	e8 4a c4 ff ff       	call   80039c <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803f52:	89 44 24 08          	mov    %eax,0x8(%esp)
  803f56:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803f5d:	00 
  803f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f61:	89 04 24             	mov    %eax,(%esp)
  803f64:	e8 13 cd ff ff       	call   800c7c <memmove>
	}

	return r;
}
  803f69:	89 d8                	mov    %ebx,%eax
  803f6b:	83 c4 10             	add    $0x10,%esp
  803f6e:	5b                   	pop    %ebx
  803f6f:	5e                   	pop    %esi
  803f70:	5d                   	pop    %ebp
  803f71:	c3                   	ret    

00803f72 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803f72:	55                   	push   %ebp
  803f73:	89 e5                	mov    %esp,%ebp
  803f75:	53                   	push   %ebx
  803f76:	83 ec 14             	sub    $0x14,%esp
  803f79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7f:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  803f84:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803f8a:	7e 24                	jle    803fb0 <_Z10nsipc_sendiPKvij+0x3e>
  803f8c:	c7 44 24 0c de 52 80 	movl   $0x8052de,0xc(%esp)
  803f93:	00 
  803f94:	c7 44 24 08 14 4c 80 	movl   $0x804c14,0x8(%esp)
  803f9b:	00 
  803f9c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  803fa3:	00 
  803fa4:	c7 04 24 d2 52 80 00 	movl   $0x8052d2,(%esp)
  803fab:	e8 ec c3 ff ff       	call   80039c <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803fb0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fbb:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  803fc2:	e8 b5 cc ff ff       	call   800c7c <memmove>
	nsipcbuf.send.req_size = size;
  803fc7:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803fcd:	8b 45 14             	mov    0x14(%ebp),%eax
  803fd0:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  803fd5:	b8 08 00 00 00       	mov    $0x8,%eax
  803fda:	e8 a5 fd ff ff       	call   803d84 <_ZL5nsipcj>
}
  803fdf:	83 c4 14             	add    $0x14,%esp
  803fe2:	5b                   	pop    %ebx
  803fe3:	5d                   	pop    %ebp
  803fe4:	c3                   	ret    

00803fe5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803fe5:	55                   	push   %ebp
  803fe6:	89 e5                	mov    %esp,%ebp
  803fe8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803feb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fee:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ff6:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  803ffe:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  804003:	b8 09 00 00 00       	mov    $0x9,%eax
  804008:	e8 77 fd ff ff       	call   803d84 <_ZL5nsipcj>
}
  80400d:	c9                   	leave  
  80400e:	c3                   	ret    
	...

00804010 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  804010:	55                   	push   %ebp
  804011:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  804013:	b8 00 00 00 00       	mov    $0x0,%eax
  804018:	5d                   	pop    %ebp
  804019:	c3                   	ret    

0080401a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80401a:	55                   	push   %ebp
  80401b:	89 e5                	mov    %esp,%ebp
  80401d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804020:	c7 44 24 04 ea 52 80 	movl   $0x8052ea,0x4(%esp)
  804027:	00 
  804028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80402b:	89 04 24             	mov    %eax,(%esp)
  80402e:	e8 a7 ca ff ff       	call   800ada <_Z6strcpyPcPKc>
	return 0;
}
  804033:	b8 00 00 00 00       	mov    $0x0,%eax
  804038:	c9                   	leave  
  804039:	c3                   	ret    

0080403a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80403a:	55                   	push   %ebp
  80403b:	89 e5                	mov    %esp,%ebp
  80403d:	57                   	push   %edi
  80403e:	56                   	push   %esi
  80403f:	53                   	push   %ebx
  804040:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80404b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80404f:	74 3e                	je     80408f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804051:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  804057:	8b 75 10             	mov    0x10(%ebp),%esi
  80405a:	29 de                	sub    %ebx,%esi
  80405c:	83 fe 7f             	cmp    $0x7f,%esi
  80405f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  804064:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804067:	89 74 24 08          	mov    %esi,0x8(%esp)
  80406b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80406e:	01 d8                	add    %ebx,%eax
  804070:	89 44 24 04          	mov    %eax,0x4(%esp)
  804074:	89 3c 24             	mov    %edi,(%esp)
  804077:	e8 00 cc ff ff       	call   800c7c <memmove>
		sys_cputs(buf, m);
  80407c:	89 74 24 04          	mov    %esi,0x4(%esp)
  804080:	89 3c 24             	mov    %edi,(%esp)
  804083:	e8 0c ce ff ff       	call   800e94 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804088:	01 f3                	add    %esi,%ebx
  80408a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  80408d:	77 c8                	ja     804057 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80408f:	89 d8                	mov    %ebx,%eax
  804091:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  804097:	5b                   	pop    %ebx
  804098:	5e                   	pop    %esi
  804099:	5f                   	pop    %edi
  80409a:	5d                   	pop    %ebp
  80409b:	c3                   	ret    

0080409c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80409c:	55                   	push   %ebp
  80409d:	89 e5                	mov    %esp,%ebp
  80409f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8040a2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8040a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8040ab:	75 07                	jne    8040b4 <_ZL12devcons_readP2FdPvj+0x18>
  8040ad:	eb 2a                	jmp    8040d9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8040af:	e8 d8 ce ff ff       	call   800f8c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8040b4:	e8 0e ce ff ff       	call   800ec7 <_Z9sys_cgetcv>
  8040b9:	85 c0                	test   %eax,%eax
  8040bb:	74 f2                	je     8040af <_ZL12devcons_readP2FdPvj+0x13>
  8040bd:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8040bf:	85 c0                	test   %eax,%eax
  8040c1:	78 16                	js     8040d9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8040c3:	83 f8 04             	cmp    $0x4,%eax
  8040c6:	74 0c                	je     8040d4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8040c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040cb:	88 10                	mov    %dl,(%eax)
	return 1;
  8040cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8040d2:	eb 05                	jmp    8040d9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8040d4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8040d9:	c9                   	leave  
  8040da:	c3                   	ret    

008040db <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8040db:	55                   	push   %ebp
  8040dc:	89 e5                	mov    %esp,%ebp
  8040de:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8040e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8040e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8040ee:	00 
  8040ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8040f2:	89 04 24             	mov    %eax,(%esp)
  8040f5:	e8 9a cd ff ff       	call   800e94 <_Z9sys_cputsPKcj>
}
  8040fa:	c9                   	leave  
  8040fb:	c3                   	ret    

008040fc <_Z7getcharv>:

int
getchar(void)
{
  8040fc:	55                   	push   %ebp
  8040fd:	89 e5                	mov    %esp,%ebp
  8040ff:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804102:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804109:	00 
  80410a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80410d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804111:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804118:	e8 01 dc ff ff       	call   801d1e <_Z4readiPvj>
	if (r < 0)
  80411d:	85 c0                	test   %eax,%eax
  80411f:	78 0f                	js     804130 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  804121:	85 c0                	test   %eax,%eax
  804123:	7e 06                	jle    80412b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  804125:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804129:	eb 05                	jmp    804130 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80412b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  804130:	c9                   	leave  
  804131:	c3                   	ret    

00804132 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  804132:	55                   	push   %ebp
  804133:	89 e5                	mov    %esp,%ebp
  804135:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  804138:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80413f:	00 
  804140:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804143:	89 44 24 04          	mov    %eax,0x4(%esp)
  804147:	8b 45 08             	mov    0x8(%ebp),%eax
  80414a:	89 04 24             	mov    %eax,(%esp)
  80414d:	e8 1f d8 ff ff       	call   801971 <_Z9fd_lookupiPP2Fdb>
  804152:	85 c0                	test   %eax,%eax
  804154:	78 11                	js     804167 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  804156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804159:	8b 15 5c 60 80 00    	mov    0x80605c,%edx
  80415f:	39 10                	cmp    %edx,(%eax)
  804161:	0f 94 c0             	sete   %al
  804164:	0f b6 c0             	movzbl %al,%eax
}
  804167:	c9                   	leave  
  804168:	c3                   	ret    

00804169 <_Z8openconsv>:

int
opencons(void)
{
  804169:	55                   	push   %ebp
  80416a:	89 e5                	mov    %esp,%ebp
  80416c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80416f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804172:	89 04 24             	mov    %eax,(%esp)
  804175:	e8 ad d8 ff ff       	call   801a27 <_Z14fd_find_unusedPP2Fd>
  80417a:	85 c0                	test   %eax,%eax
  80417c:	78 3c                	js     8041ba <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80417e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804185:	00 
  804186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804189:	89 44 24 04          	mov    %eax,0x4(%esp)
  80418d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804194:	e8 27 ce ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  804199:	85 c0                	test   %eax,%eax
  80419b:	78 1d                	js     8041ba <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80419d:	8b 15 5c 60 80 00    	mov    0x80605c,%edx
  8041a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8041a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8041b2:	89 04 24             	mov    %eax,(%esp)
  8041b5:	e8 0a d8 ff ff       	call   8019c4 <_Z6fd2numP2Fd>
}
  8041ba:	c9                   	leave  
  8041bb:	c3                   	ret    
  8041bc:	00 00                	add    %al,(%eax)
	...

008041c0 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  8041c0:	55                   	push   %ebp
  8041c1:	89 e5                	mov    %esp,%ebp
  8041c3:	56                   	push   %esi
  8041c4:	53                   	push   %ebx
  8041c5:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8041c8:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  8041cd:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  8041d4:	85 c0                	test   %eax,%eax
  8041d6:	74 08                	je     8041e0 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  8041d8:	8d 55 08             	lea    0x8(%ebp),%edx
  8041db:	89 14 24             	mov    %edx,(%esp)
  8041de:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8041e0:	83 eb 01             	sub    $0x1,%ebx
  8041e3:	83 fb ff             	cmp    $0xffffffff,%ebx
  8041e6:	75 e5                	jne    8041cd <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  8041e8:	8b 5d 38             	mov    0x38(%ebp),%ebx
  8041eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8041ee:	e8 65 cd ff ff       	call   800f58 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  8041f3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8041f7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8041fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041ff:	c7 44 24 08 f8 52 80 	movl   $0x8052f8,0x8(%esp)
  804206:	00 
  804207:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80420e:	00 
  80420f:	c7 04 24 7c 53 80 00 	movl   $0x80537c,(%esp)
  804216:	e8 81 c1 ff ff       	call   80039c <_Z6_panicPKciS0_z>

0080421b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  80421b:	55                   	push   %ebp
  80421c:	89 e5                	mov    %esp,%ebp
  80421e:	56                   	push   %esi
  80421f:	53                   	push   %ebx
  804220:	83 ec 10             	sub    $0x10,%esp
  804223:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804226:	e8 2d cd ff ff       	call   800f58 <_Z12sys_getenvidv>
  80422b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80422d:	a1 00 70 80 00       	mov    0x807000,%eax
  804232:	8b 40 5c             	mov    0x5c(%eax),%eax
  804235:	85 c0                	test   %eax,%eax
  804237:	75 4c                	jne    804285 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  804239:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  804240:	00 
  804241:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  804248:	ee 
  804249:	89 34 24             	mov    %esi,(%esp)
  80424c:	e8 6f cd ff ff       	call   800fc0 <_Z14sys_page_allociPvi>
  804251:	85 c0                	test   %eax,%eax
  804253:	74 20                	je     804275 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  804255:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804259:	c7 44 24 08 30 53 80 	movl   $0x805330,0x8(%esp)
  804260:	00 
  804261:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  804268:	00 
  804269:	c7 04 24 7c 53 80 00 	movl   $0x80537c,(%esp)
  804270:	e8 27 c1 ff ff       	call   80039c <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  804275:	c7 44 24 04 c0 41 80 	movl   $0x8041c0,0x4(%esp)
  80427c:	00 
  80427d:	89 34 24             	mov    %esi,(%esp)
  804280:	e8 70 cf ff ff       	call   8011f5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804285:	a1 00 90 80 00       	mov    0x809000,%eax
  80428a:	39 d8                	cmp    %ebx,%eax
  80428c:	74 1a                	je     8042a8 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  80428e:	85 c0                	test   %eax,%eax
  804290:	74 20                	je     8042b2 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804292:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804297:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  80429e:	39 da                	cmp    %ebx,%edx
  8042a0:	74 15                	je     8042b7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  8042a2:	85 d2                	test   %edx,%edx
  8042a4:	75 1f                	jne    8042c5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  8042a6:	eb 0f                	jmp    8042b7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8042a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ad:	8d 76 00             	lea    0x0(%esi),%esi
  8042b0:	eb 05                	jmp    8042b7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  8042b2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  8042b7:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  8042be:	83 c4 10             	add    $0x10,%esp
  8042c1:	5b                   	pop    %ebx
  8042c2:	5e                   	pop    %esi
  8042c3:	5d                   	pop    %ebp
  8042c4:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8042c5:	83 c0 01             	add    $0x1,%eax
  8042c8:	83 f8 08             	cmp    $0x8,%eax
  8042cb:	75 ca                	jne    804297 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  8042cd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8042d1:	c7 44 24 08 54 53 80 	movl   $0x805354,0x8(%esp)
  8042d8:	00 
  8042d9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8042e0:	00 
  8042e1:	c7 04 24 7c 53 80 00 	movl   $0x80537c,(%esp)
  8042e8:	e8 af c0 ff ff       	call   80039c <_Z6_panicPKciS0_z>
  8042ed:	00 00                	add    %al,(%eax)
	...

008042f0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  8042f0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  8042f3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  8042f4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  8042f7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  8042fb:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  8042ff:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  804302:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  804304:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  804308:	61                   	popa   
    popf
  804309:	9d                   	popf   
    popl %esp
  80430a:	5c                   	pop    %esp
    ret
  80430b:	c3                   	ret    

0080430c <spin>:

spin:	jmp spin
  80430c:	eb fe                	jmp    80430c <spin>
	...

00804310 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804310:	55                   	push   %ebp
  804311:	89 e5                	mov    %esp,%ebp
  804313:	56                   	push   %esi
  804314:	53                   	push   %ebx
  804315:	83 ec 10             	sub    $0x10,%esp
  804318:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80431b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80431e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  804321:	85 c0                	test   %eax,%eax
  804323:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  804328:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80432b:	89 04 24             	mov    %eax,(%esp)
  80432e:	e8 58 cf ff ff       	call   80128b <_Z12sys_ipc_recvPv>
  804333:	85 c0                	test   %eax,%eax
  804335:	79 16                	jns    80434d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  804337:	85 db                	test   %ebx,%ebx
  804339:	74 06                	je     804341 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80433b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804341:	85 f6                	test   %esi,%esi
  804343:	74 53                	je     804398 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804345:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80434b:	eb 4b                	jmp    804398 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80434d:	85 db                	test   %ebx,%ebx
  80434f:	74 17                	je     804368 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804351:	e8 02 cc ff ff       	call   800f58 <_Z12sys_getenvidv>
  804356:	25 ff 03 00 00       	and    $0x3ff,%eax
  80435b:	6b c0 78             	imul   $0x78,%eax,%eax
  80435e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804363:	8b 40 60             	mov    0x60(%eax),%eax
  804366:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804368:	85 f6                	test   %esi,%esi
  80436a:	74 17                	je     804383 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80436c:	e8 e7 cb ff ff       	call   800f58 <_Z12sys_getenvidv>
  804371:	25 ff 03 00 00       	and    $0x3ff,%eax
  804376:	6b c0 78             	imul   $0x78,%eax,%eax
  804379:	05 00 00 00 ef       	add    $0xef000000,%eax
  80437e:	8b 40 70             	mov    0x70(%eax),%eax
  804381:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  804383:	e8 d0 cb ff ff       	call   800f58 <_Z12sys_getenvidv>
  804388:	25 ff 03 00 00       	and    $0x3ff,%eax
  80438d:	6b c0 78             	imul   $0x78,%eax,%eax
  804390:	05 08 00 00 ef       	add    $0xef000008,%eax
  804395:	8b 40 60             	mov    0x60(%eax),%eax

}
  804398:	83 c4 10             	add    $0x10,%esp
  80439b:	5b                   	pop    %ebx
  80439c:	5e                   	pop    %esi
  80439d:	5d                   	pop    %ebp
  80439e:	c3                   	ret    

0080439f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80439f:	55                   	push   %ebp
  8043a0:	89 e5                	mov    %esp,%ebp
  8043a2:	57                   	push   %edi
  8043a3:	56                   	push   %esi
  8043a4:	53                   	push   %ebx
  8043a5:	83 ec 1c             	sub    $0x1c,%esp
  8043a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8043ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8043ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  8043b1:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  8043b3:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8043b8:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8043bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8043be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8043c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8043ca:	89 34 24             	mov    %esi,(%esp)
  8043cd:	e8 81 ce ff ff       	call   801253 <_Z16sys_ipc_try_sendijPvi>
  8043d2:	85 c0                	test   %eax,%eax
  8043d4:	79 31                	jns    804407 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  8043d6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8043d9:	75 0c                	jne    8043e7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  8043db:	90                   	nop
  8043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8043e0:	e8 a7 cb ff ff       	call   800f8c <_Z9sys_yieldv>
  8043e5:	eb d4                	jmp    8043bb <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  8043e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8043eb:	c7 44 24 08 8a 53 80 	movl   $0x80538a,0x8(%esp)
  8043f2:	00 
  8043f3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8043fa:	00 
  8043fb:	c7 04 24 97 53 80 00 	movl   $0x805397,(%esp)
  804402:	e8 95 bf ff ff       	call   80039c <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  804407:	83 c4 1c             	add    $0x1c,%esp
  80440a:	5b                   	pop    %ebx
  80440b:	5e                   	pop    %esi
  80440c:	5f                   	pop    %edi
  80440d:	5d                   	pop    %ebp
  80440e:	c3                   	ret    
	...

00804410 <__udivdi3>:
  804410:	55                   	push   %ebp
  804411:	89 e5                	mov    %esp,%ebp
  804413:	57                   	push   %edi
  804414:	56                   	push   %esi
  804415:	83 ec 20             	sub    $0x20,%esp
  804418:	8b 45 14             	mov    0x14(%ebp),%eax
  80441b:	8b 75 08             	mov    0x8(%ebp),%esi
  80441e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804421:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804424:	85 c0                	test   %eax,%eax
  804426:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804429:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80442c:	75 3a                	jne    804468 <__udivdi3+0x58>
  80442e:	39 f9                	cmp    %edi,%ecx
  804430:	77 66                	ja     804498 <__udivdi3+0x88>
  804432:	85 c9                	test   %ecx,%ecx
  804434:	75 0b                	jne    804441 <__udivdi3+0x31>
  804436:	b8 01 00 00 00       	mov    $0x1,%eax
  80443b:	31 d2                	xor    %edx,%edx
  80443d:	f7 f1                	div    %ecx
  80443f:	89 c1                	mov    %eax,%ecx
  804441:	89 f8                	mov    %edi,%eax
  804443:	31 d2                	xor    %edx,%edx
  804445:	f7 f1                	div    %ecx
  804447:	89 c7                	mov    %eax,%edi
  804449:	89 f0                	mov    %esi,%eax
  80444b:	f7 f1                	div    %ecx
  80444d:	89 fa                	mov    %edi,%edx
  80444f:	89 c6                	mov    %eax,%esi
  804451:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804454:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80445a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80445d:	83 c4 20             	add    $0x20,%esp
  804460:	5e                   	pop    %esi
  804461:	5f                   	pop    %edi
  804462:	5d                   	pop    %ebp
  804463:	c3                   	ret    
  804464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804468:	31 d2                	xor    %edx,%edx
  80446a:	31 f6                	xor    %esi,%esi
  80446c:	39 f8                	cmp    %edi,%eax
  80446e:	77 e1                	ja     804451 <__udivdi3+0x41>
  804470:	0f bd d0             	bsr    %eax,%edx
  804473:	83 f2 1f             	xor    $0x1f,%edx
  804476:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804479:	75 2d                	jne    8044a8 <__udivdi3+0x98>
  80447b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80447e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804481:	76 06                	jbe    804489 <__udivdi3+0x79>
  804483:	39 f8                	cmp    %edi,%eax
  804485:	89 f2                	mov    %esi,%edx
  804487:	73 c8                	jae    804451 <__udivdi3+0x41>
  804489:	31 d2                	xor    %edx,%edx
  80448b:	be 01 00 00 00       	mov    $0x1,%esi
  804490:	eb bf                	jmp    804451 <__udivdi3+0x41>
  804492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804498:	89 f0                	mov    %esi,%eax
  80449a:	89 fa                	mov    %edi,%edx
  80449c:	f7 f1                	div    %ecx
  80449e:	31 d2                	xor    %edx,%edx
  8044a0:	89 c6                	mov    %eax,%esi
  8044a2:	eb ad                	jmp    804451 <__udivdi3+0x41>
  8044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8044a8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8044ac:	89 c2                	mov    %eax,%edx
  8044ae:	b8 20 00 00 00       	mov    $0x20,%eax
  8044b3:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8044b6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8044b9:	d3 e2                	shl    %cl,%edx
  8044bb:	89 c1                	mov    %eax,%ecx
  8044bd:	d3 ee                	shr    %cl,%esi
  8044bf:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8044c3:	09 d6                	or     %edx,%esi
  8044c5:	89 fa                	mov    %edi,%edx
  8044c7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8044ca:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8044cd:	d3 e6                	shl    %cl,%esi
  8044cf:	89 c1                	mov    %eax,%ecx
  8044d1:	d3 ea                	shr    %cl,%edx
  8044d3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8044d7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8044da:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8044dd:	d3 e7                	shl    %cl,%edi
  8044df:	89 c1                	mov    %eax,%ecx
  8044e1:	d3 ee                	shr    %cl,%esi
  8044e3:	09 fe                	or     %edi,%esi
  8044e5:	89 f0                	mov    %esi,%eax
  8044e7:	f7 75 e4             	divl   -0x1c(%ebp)
  8044ea:	89 d7                	mov    %edx,%edi
  8044ec:	89 c6                	mov    %eax,%esi
  8044ee:	f7 65 f0             	mull   -0x10(%ebp)
  8044f1:	39 d7                	cmp    %edx,%edi
  8044f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8044f6:	72 12                	jb     80450a <__udivdi3+0xfa>
  8044f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044fb:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8044ff:	d3 e2                	shl    %cl,%edx
  804501:	39 c2                	cmp    %eax,%edx
  804503:	73 08                	jae    80450d <__udivdi3+0xfd>
  804505:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804508:	75 03                	jne    80450d <__udivdi3+0xfd>
  80450a:	83 ee 01             	sub    $0x1,%esi
  80450d:	31 d2                	xor    %edx,%edx
  80450f:	e9 3d ff ff ff       	jmp    804451 <__udivdi3+0x41>
	...

00804520 <__umoddi3>:
  804520:	55                   	push   %ebp
  804521:	89 e5                	mov    %esp,%ebp
  804523:	57                   	push   %edi
  804524:	56                   	push   %esi
  804525:	83 ec 20             	sub    $0x20,%esp
  804528:	8b 7d 14             	mov    0x14(%ebp),%edi
  80452b:	8b 45 08             	mov    0x8(%ebp),%eax
  80452e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804531:	8b 75 0c             	mov    0xc(%ebp),%esi
  804534:	85 ff                	test   %edi,%edi
  804536:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804539:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80453c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80453f:	89 f2                	mov    %esi,%edx
  804541:	75 15                	jne    804558 <__umoddi3+0x38>
  804543:	39 f1                	cmp    %esi,%ecx
  804545:	76 41                	jbe    804588 <__umoddi3+0x68>
  804547:	f7 f1                	div    %ecx
  804549:	89 d0                	mov    %edx,%eax
  80454b:	31 d2                	xor    %edx,%edx
  80454d:	83 c4 20             	add    $0x20,%esp
  804550:	5e                   	pop    %esi
  804551:	5f                   	pop    %edi
  804552:	5d                   	pop    %ebp
  804553:	c3                   	ret    
  804554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804558:	39 f7                	cmp    %esi,%edi
  80455a:	77 4c                	ja     8045a8 <__umoddi3+0x88>
  80455c:	0f bd c7             	bsr    %edi,%eax
  80455f:	83 f0 1f             	xor    $0x1f,%eax
  804562:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804565:	75 51                	jne    8045b8 <__umoddi3+0x98>
  804567:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80456a:	0f 87 e8 00 00 00    	ja     804658 <__umoddi3+0x138>
  804570:	89 f2                	mov    %esi,%edx
  804572:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804575:	29 ce                	sub    %ecx,%esi
  804577:	19 fa                	sbb    %edi,%edx
  804579:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80457c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80457f:	83 c4 20             	add    $0x20,%esp
  804582:	5e                   	pop    %esi
  804583:	5f                   	pop    %edi
  804584:	5d                   	pop    %ebp
  804585:	c3                   	ret    
  804586:	66 90                	xchg   %ax,%ax
  804588:	85 c9                	test   %ecx,%ecx
  80458a:	75 0b                	jne    804597 <__umoddi3+0x77>
  80458c:	b8 01 00 00 00       	mov    $0x1,%eax
  804591:	31 d2                	xor    %edx,%edx
  804593:	f7 f1                	div    %ecx
  804595:	89 c1                	mov    %eax,%ecx
  804597:	89 f0                	mov    %esi,%eax
  804599:	31 d2                	xor    %edx,%edx
  80459b:	f7 f1                	div    %ecx
  80459d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045a0:	eb a5                	jmp    804547 <__umoddi3+0x27>
  8045a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8045a8:	89 f2                	mov    %esi,%edx
  8045aa:	83 c4 20             	add    $0x20,%esp
  8045ad:	5e                   	pop    %esi
  8045ae:	5f                   	pop    %edi
  8045af:	5d                   	pop    %ebp
  8045b0:	c3                   	ret    
  8045b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8045b8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045bc:	89 f2                	mov    %esi,%edx
  8045be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045c1:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  8045c8:	29 45 f0             	sub    %eax,-0x10(%ebp)
  8045cb:	d3 e7                	shl    %cl,%edi
  8045cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045d0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8045d4:	d3 e8                	shr    %cl,%eax
  8045d6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045da:	09 f8                	or     %edi,%eax
  8045dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8045df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e2:	d3 e0                	shl    %cl,%eax
  8045e4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8045e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8045eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045ee:	d3 ea                	shr    %cl,%edx
  8045f0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045f4:	d3 e6                	shl    %cl,%esi
  8045f6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8045fa:	d3 e8                	shr    %cl,%eax
  8045fc:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804600:	09 f0                	or     %esi,%eax
  804602:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804605:	f7 75 e4             	divl   -0x1c(%ebp)
  804608:	d3 e6                	shl    %cl,%esi
  80460a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80460d:	89 d6                	mov    %edx,%esi
  80460f:	f7 65 f4             	mull   -0xc(%ebp)
  804612:	89 d7                	mov    %edx,%edi
  804614:	89 c2                	mov    %eax,%edx
  804616:	39 fe                	cmp    %edi,%esi
  804618:	89 f9                	mov    %edi,%ecx
  80461a:	72 30                	jb     80464c <__umoddi3+0x12c>
  80461c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80461f:	72 27                	jb     804648 <__umoddi3+0x128>
  804621:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804624:	29 d0                	sub    %edx,%eax
  804626:	19 ce                	sbb    %ecx,%esi
  804628:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80462c:	89 f2                	mov    %esi,%edx
  80462e:	d3 e8                	shr    %cl,%eax
  804630:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804634:	d3 e2                	shl    %cl,%edx
  804636:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80463a:	09 d0                	or     %edx,%eax
  80463c:	89 f2                	mov    %esi,%edx
  80463e:	d3 ea                	shr    %cl,%edx
  804640:	83 c4 20             	add    $0x20,%esp
  804643:	5e                   	pop    %esi
  804644:	5f                   	pop    %edi
  804645:	5d                   	pop    %ebp
  804646:	c3                   	ret    
  804647:	90                   	nop
  804648:	39 fe                	cmp    %edi,%esi
  80464a:	75 d5                	jne    804621 <__umoddi3+0x101>
  80464c:	89 f9                	mov    %edi,%ecx
  80464e:	89 c2                	mov    %eax,%edx
  804650:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804653:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804656:	eb c9                	jmp    804621 <__umoddi3+0x101>
  804658:	39 f7                	cmp    %esi,%edi
  80465a:	0f 82 10 ff ff ff    	jb     804570 <__umoddi3+0x50>
  804660:	e9 17 ff ff ff       	jmp    80457c <__umoddi3+0x5c>
