
obj/user/testfdsharing:     file format elf32-i386


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
  80002c:	e8 cf 03 00 00       	call   800400 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z5umainiPPc>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800044:	00 
  800045:	c7 04 24 c3 47 80 00 	movl   $0x8047c3,(%esp)
  80004c:	e8 3d 2a 00 00       	call   802a8e <_Z4openPKci>
  800051:	89 c3                	mov    %eax,%ebx
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <_Z5umainiPPc+0x43>
		panic("open motd: %e", fd);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 60 47 80 	movl   $0x804760,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  800072:	e8 0d 04 00 00       	call   800484 <_Z6_panicPKciS0_z>
	seek(fd, 0);
  800077:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007e:	00 
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 d4 1e 00 00       	call   801f5b <_Z4seekii>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800087:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  800096:	00 
  800097:	89 1c 24             	mov    %ebx,(%esp)
  80009a:	e8 f9 1d 00 00       	call   801e98 <_Z5readniPvj>
  80009f:	89 c7                	mov    %eax,%edi
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	7f 20                	jg     8000c5 <_Z5umainiPPc+0x91>
		panic("readn: %e", n);
  8000a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a9:	c7 44 24 08 83 47 80 	movl   $0x804783,0x8(%esp)
  8000b0:	00 
  8000b1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b8:	00 
  8000b9:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  8000c0:	e8 bf 03 00 00       	call   800484 <_Z6_panicPKciS0_z>

	if ((r = fork()) < 0)
  8000c5:	e8 13 16 00 00       	call   8016dd <_Z4forkv>
  8000ca:	89 c6                	mov    %eax,%esi
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	79 20                	jns    8000f0 <_Z5umainiPPc+0xbc>
		panic("fork: %e", r);
  8000d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d4:	c7 44 24 08 68 4d 80 	movl   $0x804d68,0x8(%esp)
  8000db:	00 
  8000dc:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e3:	00 
  8000e4:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  8000eb:	e8 94 03 00 00       	call   800484 <_Z6_panicPKciS0_z>
	if (r == 0) {
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	0f 85 bd 00 00 00    	jne    8001b5 <_Z5umainiPPc+0x181>
		seek(fd, 0);
  8000f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ff:	00 
  800100:	89 1c 24             	mov    %ebx,(%esp)
  800103:	e8 53 1e 00 00       	call   801f5b <_Z4seekii>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800108:	c7 04 24 34 48 80 00 	movl   $0x804834,(%esp)
  80010f:	e8 8e 04 00 00       	call   8005a2 <_Z7cprintfPKcz>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800114:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011b:	00 
  80011c:	c7 44 24 04 00 72 80 	movl   $0x807200,0x4(%esp)
  800123:	00 
  800124:	89 1c 24             	mov    %ebx,(%esp)
  800127:	e8 6c 1d 00 00       	call   801e98 <_Z5readniPvj>
  80012c:	39 c7                	cmp    %eax,%edi
  80012e:	74 24                	je     800154 <_Z5umainiPPc+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  800130:	89 44 24 10          	mov    %eax,0x10(%esp)
  800134:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800138:	c7 44 24 08 78 48 80 	movl   $0x804878,0x8(%esp)
  80013f:	00 
  800140:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800147:	00 
  800148:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  80014f:	e8 30 03 00 00       	call   800484 <_Z6_panicPKciS0_z>
		if (memcmp(buf, buf2, n) != 0)
  800154:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800158:	c7 44 24 04 00 72 80 	movl   $0x807200,0x4(%esp)
  80015f:	00 
  800160:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  800167:	e8 ac 0c 00 00       	call   800e18 <memcmp>
  80016c:	85 c0                	test   %eax,%eax
  80016e:	74 1c                	je     80018c <_Z5umainiPPc+0x158>
			panic("read in parent got different bytes from read in child");
  800170:	c7 44 24 08 a4 48 80 	movl   $0x8048a4,0x8(%esp)
  800177:	00 
  800178:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017f:	00 
  800180:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  800187:	e8 f8 02 00 00       	call   800484 <_Z6_panicPKciS0_z>
		cprintf("read in child succeeded\n");
  80018c:	c7 04 24 8d 47 80 00 	movl   $0x80478d,(%esp)
  800193:	e8 0a 04 00 00       	call   8005a2 <_Z7cprintfPKcz>
		seek(fd, 0);
  800198:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019f:	00 
  8001a0:	89 1c 24             	mov    %ebx,(%esp)
  8001a3:	e8 b3 1d 00 00       	call   801f5b <_Z4seekii>
		close(fd);
  8001a8:	89 1c 24             	mov    %ebx,(%esp)
  8001ab:	e8 a5 1a 00 00       	call   801c55 <_Z5closei>
		exit();
  8001b0:	e8 b3 02 00 00       	call   800468 <_Z4exitv>
	}
	wait(r);
  8001b5:	89 34 24             	mov    %esi,(%esp)
  8001b8:	e8 e3 39 00 00       	call   803ba0 <_Z4waiti>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c4:	00 
  8001c5:	c7 44 24 04 00 72 80 	movl   $0x807200,0x4(%esp)
  8001cc:	00 
  8001cd:	89 1c 24             	mov    %ebx,(%esp)
  8001d0:	e8 c3 1c 00 00       	call   801e98 <_Z5readniPvj>
  8001d5:	39 c7                	cmp    %eax,%edi
  8001d7:	74 24                	je     8001fd <_Z5umainiPPc+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e1:	c7 44 24 08 dc 48 80 	movl   $0x8048dc,0x8(%esp)
  8001e8:	00 
  8001e9:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001f0:	00 
  8001f1:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  8001f8:	e8 87 02 00 00       	call   800484 <_Z6_panicPKciS0_z>
	cprintf("read in parent succeeded\n");
  8001fd:	c7 04 24 a6 47 80 00 	movl   $0x8047a6,(%esp)
  800204:	e8 99 03 00 00       	call   8005a2 <_Z7cprintfPKcz>
	close(fd);
  800209:	89 1c 24             	mov    %ebx,(%esp)
  80020c:	e8 44 1a 00 00       	call   801c55 <_Z5closei>

	if ((fd = open("newmotd", O_RDWR)) < 0)
  800211:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  800218:	00 
  800219:	c7 04 24 c0 47 80 00 	movl   $0x8047c0,(%esp)
  800220:	e8 69 28 00 00       	call   802a8e <_Z4openPKci>
  800225:	89 c3                	mov    %eax,%ebx
  800227:	85 c0                	test   %eax,%eax
  800229:	79 20                	jns    80024b <_Z5umainiPPc+0x217>
		panic("open newmotd: %e", fd);
  80022b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80022f:	c7 44 24 08 c8 47 80 	movl   $0x8047c8,0x8(%esp)
  800236:	00 
  800237:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  80023e:	00 
  80023f:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  800246:	e8 39 02 00 00       	call   800484 <_Z6_panicPKciS0_z>
	seek(fd, 0);
  80024b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800252:	00 
  800253:	89 04 24             	mov    %eax,(%esp)
  800256:	e8 00 1d 00 00       	call   801f5b <_Z4seekii>
	if ((n = write(fd, "hello", 5)) != 5)
  80025b:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  800262:	00 
  800263:	c7 44 24 04 d9 47 80 	movl   $0x8047d9,0x4(%esp)
  80026a:	00 
  80026b:	89 1c 24             	mov    %ebx,(%esp)
  80026e:	e8 76 1c 00 00       	call   801ee9 <_Z5writeiPKvj>
  800273:	83 f8 05             	cmp    $0x5,%eax
  800276:	74 20                	je     800298 <_Z5umainiPPc+0x264>
		panic("write: %e", n);
  800278:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80027c:	c7 44 24 08 df 47 80 	movl   $0x8047df,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  80028b:	00 
  80028c:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  800293:	e8 ec 01 00 00       	call   800484 <_Z6_panicPKciS0_z>

	if ((r = fork()) < 0)
  800298:	e8 40 14 00 00       	call   8016dd <_Z4forkv>
  80029d:	89 c6                	mov    %eax,%esi
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	79 20                	jns    8002c3 <_Z5umainiPPc+0x28f>
		panic("fork: %e", r);
  8002a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a7:	c7 44 24 08 68 4d 80 	movl   $0x804d68,0x8(%esp)
  8002ae:	00 
  8002af:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002b6:	00 
  8002b7:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  8002be:	e8 c1 01 00 00       	call   800484 <_Z6_panicPKciS0_z>
	if (r == 0) {
  8002c3:	85 c0                	test   %eax,%eax
  8002c5:	75 72                	jne    800339 <_Z5umainiPPc+0x305>
		seek(fd, 0);
  8002c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002ce:	00 
  8002cf:	89 1c 24             	mov    %ebx,(%esp)
  8002d2:	e8 84 1c 00 00       	call   801f5b <_Z4seekii>
		cprintf("going to write in child\n");
  8002d7:	c7 04 24 e9 47 80 00 	movl   $0x8047e9,(%esp)
  8002de:	e8 bf 02 00 00       	call   8005a2 <_Z7cprintfPKcz>
		if ((n = write(fd, "world", 5)) != 5)
  8002e3:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  8002ea:	00 
  8002eb:	c7 44 24 04 02 48 80 	movl   $0x804802,0x4(%esp)
  8002f2:	00 
  8002f3:	89 1c 24             	mov    %ebx,(%esp)
  8002f6:	e8 ee 1b 00 00       	call   801ee9 <_Z5writeiPKvj>
  8002fb:	83 f8 05             	cmp    $0x5,%eax
  8002fe:	74 20                	je     800320 <_Z5umainiPPc+0x2ec>
			panic("write in child: %e", n);
  800300:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800304:	c7 44 24 08 08 48 80 	movl   $0x804808,0x8(%esp)
  80030b:	00 
  80030c:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  800313:	00 
  800314:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  80031b:	e8 64 01 00 00       	call   800484 <_Z6_panicPKciS0_z>
		cprintf("write in child finished\n");
  800320:	c7 04 24 1b 48 80 00 	movl   $0x80481b,(%esp)
  800327:	e8 76 02 00 00       	call   8005a2 <_Z7cprintfPKcz>
		close(fd);
  80032c:	89 1c 24             	mov    %ebx,(%esp)
  80032f:	e8 21 19 00 00       	call   801c55 <_Z5closei>
		exit();
  800334:	e8 2f 01 00 00       	call   800468 <_Z4exitv>
	}
	wait(r);
  800339:	89 34 24             	mov    %esi,(%esp)
  80033c:	e8 5f 38 00 00       	call   803ba0 <_Z4waiti>
	seek(fd, 0);
  800341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800348:	00 
  800349:	89 1c 24             	mov    %ebx,(%esp)
  80034c:	e8 0a 1c 00 00       	call   801f5b <_Z4seekii>
	if ((n = readn(fd, buf, 5)) != 5)
  800351:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  800358:	00 
  800359:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  800360:	00 
  800361:	89 1c 24             	mov    %ebx,(%esp)
  800364:	e8 2f 1b 00 00       	call   801e98 <_Z5readniPvj>
  800369:	83 f8 05             	cmp    $0x5,%eax
  80036c:	74 20                	je     80038e <_Z5umainiPPc+0x35a>
		panic("readn: %e", n);
  80036e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800372:	c7 44 24 08 83 47 80 	movl   $0x804783,0x8(%esp)
  800379:	00 
  80037a:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  800381:	00 
  800382:	c7 04 24 6e 47 80 00 	movl   $0x80476e,(%esp)
  800389:	e8 f6 00 00 00       	call   800484 <_Z6_panicPKciS0_z>
	buf[5] = 0;
  80038e:	c6 05 05 70 80 00 00 	movb   $0x0,0x807005
	if (strcmp(buf, "hello") == 0)
  800395:	c7 44 24 04 d9 47 80 	movl   $0x8047d9,0x4(%esp)
  80039c:	00 
  80039d:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8003a4:	e8 9b 08 00 00       	call   800c44 <_Z6strcmpPKcS0_>
  8003a9:	85 c0                	test   %eax,%eax
  8003ab:	75 0e                	jne    8003bb <_Z5umainiPPc+0x387>
		cprintf("write to file data page failed; got old data\n");
  8003ad:	c7 04 24 00 49 80 00 	movl   $0x804900,(%esp)
  8003b4:	e8 e9 01 00 00       	call   8005a2 <_Z7cprintfPKcz>
  8003b9:	eb 3a                	jmp    8003f5 <_Z5umainiPPc+0x3c1>
	else if (strcmp(buf, "world") == 0)
  8003bb:	c7 44 24 04 02 48 80 	movl   $0x804802,0x4(%esp)
  8003c2:	00 
  8003c3:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8003ca:	e8 75 08 00 00       	call   800c44 <_Z6strcmpPKcS0_>
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	75 0e                	jne    8003e1 <_Z5umainiPPc+0x3ad>
		cprintf("write to file data page succeeded\n");
  8003d3:	c7 04 24 30 49 80 00 	movl   $0x804930,(%esp)
  8003da:	e8 c3 01 00 00       	call   8005a2 <_Z7cprintfPKcz>
  8003df:	eb 14                	jmp    8003f5 <_Z5umainiPPc+0x3c1>
	else
		cprintf("write to file data page failed; got %s\n", buf);
  8003e1:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8003e8:	00 
  8003e9:	c7 04 24 54 49 80 00 	movl   $0x804954,(%esp)
  8003f0:	e8 ad 01 00 00       	call   8005a2 <_Z7cprintfPKcz>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8003f5:	cc                   	int3   

	breakpoint();
}
  8003f6:	83 c4 2c             	add    $0x2c,%esp
  8003f9:	5b                   	pop    %ebx
  8003fa:	5e                   	pop    %esi
  8003fb:	5f                   	pop    %edi
  8003fc:	5d                   	pop    %ebp
  8003fd:	c3                   	ret    
	...

00800400 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	57                   	push   %edi
  800404:	56                   	push   %esi
  800405:	53                   	push   %ebx
  800406:	83 ec 1c             	sub    $0x1c,%esp
  800409:	8b 7d 08             	mov    0x8(%ebp),%edi
  80040c:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  80040f:	e8 24 0c 00 00       	call   801038 <_Z12sys_getenvidv>
  800414:	25 ff 03 00 00       	and    $0x3ff,%eax
  800419:	6b c0 78             	imul   $0x78,%eax,%eax
  80041c:	05 00 00 00 ef       	add    $0xef000000,%eax
  800421:	a3 00 74 80 00       	mov    %eax,0x807400
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800426:	85 ff                	test   %edi,%edi
  800428:	7e 07                	jle    800431 <libmain+0x31>
		binaryname = argv[0];
  80042a:	8b 06                	mov    (%esi),%eax
  80042c:	a3 00 60 80 00       	mov    %eax,0x806000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800431:	b8 41 55 80 00       	mov    $0x805541,%eax
  800436:	3d 41 55 80 00       	cmp    $0x805541,%eax
  80043b:	76 0f                	jbe    80044c <libmain+0x4c>
  80043d:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80043f:	83 eb 04             	sub    $0x4,%ebx
  800442:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800444:	81 fb 41 55 80 00    	cmp    $0x805541,%ebx
  80044a:	77 f3                	ja     80043f <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  80044c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800450:	89 3c 24             	mov    %edi,(%esp)
  800453:	e8 dc fb ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800458:	e8 0b 00 00 00       	call   800468 <_Z4exitv>
}
  80045d:	83 c4 1c             	add    $0x1c,%esp
  800460:	5b                   	pop    %ebx
  800461:	5e                   	pop    %esi
  800462:	5f                   	pop    %edi
  800463:	5d                   	pop    %ebp
  800464:	c3                   	ret    
  800465:	00 00                	add    %al,(%eax)
	...

00800468 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80046e:	e8 1b 18 00 00       	call   801c8e <_Z9close_allv>
	sys_env_destroy(0);
  800473:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80047a:	e8 5c 0b 00 00       	call   800fdb <_Z15sys_env_destroyi>
}
  80047f:	c9                   	leave  
  800480:	c3                   	ret    
  800481:	00 00                	add    %al,(%eax)
	...

00800484 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	56                   	push   %esi
  800488:	53                   	push   %ebx
  800489:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80048c:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  80048f:	a1 04 74 80 00       	mov    0x807404,%eax
  800494:	85 c0                	test   %eax,%eax
  800496:	74 10                	je     8004a8 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  800498:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049c:	c7 04 24 86 49 80 00 	movl   $0x804986,(%esp)
  8004a3:	e8 fa 00 00 00       	call   8005a2 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  8004a8:	8b 1d 00 60 80 00    	mov    0x806000,%ebx
  8004ae:	e8 85 0b 00 00       	call   801038 <_Z12sys_getenvidv>
  8004b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b6:	89 54 24 10          	mov    %edx,0x10(%esp)
  8004ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8004bd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004c1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c9:	c7 04 24 8c 49 80 00 	movl   $0x80498c,(%esp)
  8004d0:	e8 cd 00 00 00       	call   8005a2 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8004d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004dc:	89 04 24             	mov    %eax,(%esp)
  8004df:	e8 5d 00 00 00       	call   800541 <_Z8vcprintfPKcPc>
	cprintf("\n");
  8004e4:	c7 04 24 a4 47 80 00 	movl   $0x8047a4,(%esp)
  8004eb:	e8 b2 00 00 00       	call   8005a2 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004f0:	cc                   	int3   
  8004f1:	eb fd                	jmp    8004f0 <_Z6_panicPKciS0_z+0x6c>
	...

008004f4 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8004f4:	55                   	push   %ebp
  8004f5:	89 e5                	mov    %esp,%ebp
  8004f7:	83 ec 18             	sub    $0x18,%esp
  8004fa:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8004fd:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800500:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  800503:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800505:	8b 03                	mov    (%ebx),%eax
  800507:	8b 55 08             	mov    0x8(%ebp),%edx
  80050a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80050e:	83 c0 01             	add    $0x1,%eax
  800511:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800513:	3d ff 00 00 00       	cmp    $0xff,%eax
  800518:	75 19                	jne    800533 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  80051a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800521:	00 
  800522:	8d 43 08             	lea    0x8(%ebx),%eax
  800525:	89 04 24             	mov    %eax,(%esp)
  800528:	e8 47 0a 00 00       	call   800f74 <_Z9sys_cputsPKcj>
		b->idx = 0;
  80052d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800533:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800537:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80053a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80053d:	89 ec                	mov    %ebp,%esp
  80053f:	5d                   	pop    %ebp
  800540:	c3                   	ret    

00800541 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800541:	55                   	push   %ebp
  800542:	89 e5                	mov    %esp,%ebp
  800544:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80054a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800551:	00 00 00 
	b.cnt = 0;
  800554:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80055b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80055e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800561:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	89 44 24 08          	mov    %eax,0x8(%esp)
  80056c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800572:	89 44 24 04          	mov    %eax,0x4(%esp)
  800576:	c7 04 24 f4 04 80 00 	movl   $0x8004f4,(%esp)
  80057d:	e8 a5 01 00 00       	call   800727 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800582:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80058c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800592:	89 04 24             	mov    %eax,(%esp)
  800595:	e8 da 09 00 00       	call   800f74 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  80059a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	89 04 24             	mov    %eax,(%esp)
  8005b5:	e8 87 ff ff ff       	call   800541 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  8005ba:	c9                   	leave  
  8005bb:	c3                   	ret    
  8005bc:	00 00                	add    %al,(%eax)
	...

008005c0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c0:	55                   	push   %ebp
  8005c1:	89 e5                	mov    %esp,%ebp
  8005c3:	57                   	push   %edi
  8005c4:	56                   	push   %esi
  8005c5:	53                   	push   %ebx
  8005c6:	83 ec 4c             	sub    $0x4c,%esp
  8005c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005cc:	89 d6                	mov    %edx,%esi
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8005dd:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	39 d0                	cmp    %edx,%eax
  8005e7:	72 11                	jb     8005fa <_ZL8printnumPFviPvES_yjii+0x3a>
  8005e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005ec:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  8005ef:	76 09                	jbe    8005fa <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f1:	83 eb 01             	sub    $0x1,%ebx
  8005f4:	85 db                	test   %ebx,%ebx
  8005f6:	7f 5d                	jg     800655 <_ZL8printnumPFviPvES_yjii+0x95>
  8005f8:	eb 6c                	jmp    800666 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005fa:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8005fe:	83 eb 01             	sub    $0x1,%ebx
  800601:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800605:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800608:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80060c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800610:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800614:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800617:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80061a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800621:	00 
  800622:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800625:	89 14 24             	mov    %edx,(%esp)
  800628:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80062b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80062f:	e8 bc 3e 00 00       	call   8044f0 <__udivdi3>
  800634:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800637:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80063a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80063e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800642:	89 04 24             	mov    %eax,(%esp)
  800645:	89 54 24 04          	mov    %edx,0x4(%esp)
  800649:	89 f2                	mov    %esi,%edx
  80064b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80064e:	e8 6d ff ff ff       	call   8005c0 <_ZL8printnumPFviPvES_yjii>
  800653:	eb 11                	jmp    800666 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800655:	89 74 24 04          	mov    %esi,0x4(%esp)
  800659:	89 3c 24             	mov    %edi,(%esp)
  80065c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80065f:	83 eb 01             	sub    $0x1,%ebx
  800662:	85 db                	test   %ebx,%ebx
  800664:	7f ef                	jg     800655 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800666:	89 74 24 04          	mov    %esi,0x4(%esp)
  80066a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80066e:	8b 45 10             	mov    0x10(%ebp),%eax
  800671:	89 44 24 08          	mov    %eax,0x8(%esp)
  800675:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80067c:	00 
  80067d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800680:	89 14 24             	mov    %edx,(%esp)
  800683:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800686:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80068a:	e8 71 3f 00 00       	call   804600 <__umoddi3>
  80068f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800693:	0f be 80 af 49 80 00 	movsbl 0x8049af(%eax),%eax
  80069a:	89 04 24             	mov    %eax,(%esp)
  80069d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8006a0:	83 c4 4c             	add    $0x4c,%esp
  8006a3:	5b                   	pop    %ebx
  8006a4:	5e                   	pop    %esi
  8006a5:	5f                   	pop    %edi
  8006a6:	5d                   	pop    %ebp
  8006a7:	c3                   	ret    

008006a8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ab:	83 fa 01             	cmp    $0x1,%edx
  8006ae:	7e 0e                	jle    8006be <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8006b5:	89 08                	mov    %ecx,(%eax)
  8006b7:	8b 02                	mov    (%edx),%eax
  8006b9:	8b 52 04             	mov    0x4(%edx),%edx
  8006bc:	eb 22                	jmp    8006e0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  8006be:	85 d2                	test   %edx,%edx
  8006c0:	74 10                	je     8006d2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  8006c2:	8b 10                	mov    (%eax),%edx
  8006c4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006c7:	89 08                	mov    %ecx,(%eax)
  8006c9:	8b 02                	mov    (%edx),%eax
  8006cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d0:	eb 0e                	jmp    8006e0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  8006d2:	8b 10                	mov    (%eax),%edx
  8006d4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006d7:	89 08                	mov    %ecx,(%eax)
  8006d9:	8b 02                	mov    (%edx),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e0:	5d                   	pop    %ebp
  8006e1:	c3                   	ret    

008006e2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8006e8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006ec:	8b 10                	mov    (%eax),%edx
  8006ee:	3b 50 04             	cmp    0x4(%eax),%edx
  8006f1:	73 0a                	jae    8006fd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8006f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006f6:	88 0a                	mov    %cl,(%edx)
  8006f8:	83 c2 01             	add    $0x1,%edx
  8006fb:	89 10                	mov    %edx,(%eax)
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800705:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800708:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800713:	8b 45 0c             	mov    0xc(%ebp),%eax
  800716:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	89 04 24             	mov    %eax,(%esp)
  800720:	e8 02 00 00 00       	call   800727 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	57                   	push   %edi
  80072b:	56                   	push   %esi
  80072c:	53                   	push   %ebx
  80072d:	83 ec 3c             	sub    $0x3c,%esp
  800730:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800733:	8b 55 10             	mov    0x10(%ebp),%edx
  800736:	0f b6 02             	movzbl (%edx),%eax
  800739:	89 d3                	mov    %edx,%ebx
  80073b:	83 c3 01             	add    $0x1,%ebx
  80073e:	83 f8 25             	cmp    $0x25,%eax
  800741:	74 2b                	je     80076e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800743:	85 c0                	test   %eax,%eax
  800745:	75 10                	jne    800757 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800747:	e9 a5 03 00 00       	jmp    800af1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80074c:	85 c0                	test   %eax,%eax
  80074e:	66 90                	xchg   %ax,%ax
  800750:	75 08                	jne    80075a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800752:	e9 9a 03 00 00       	jmp    800af1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800757:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80075a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075e:	89 04 24             	mov    %eax,(%esp)
  800761:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800763:	0f b6 03             	movzbl (%ebx),%eax
  800766:	83 c3 01             	add    $0x1,%ebx
  800769:	83 f8 25             	cmp    $0x25,%eax
  80076c:	75 de                	jne    80074c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80076e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800772:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800779:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80077e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800785:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80078d:	eb 2b                	jmp    8007ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800792:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800796:	eb 22                	jmp    8007ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80079f:	eb 19                	jmp    8007ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8007a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007ab:	eb 0d                	jmp    8007ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8007ad:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8007b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ba:	0f b6 03             	movzbl (%ebx),%eax
  8007bd:	0f b6 d0             	movzbl %al,%edx
  8007c0:	8d 73 01             	lea    0x1(%ebx),%esi
  8007c3:	89 75 10             	mov    %esi,0x10(%ebp)
  8007c6:	83 e8 23             	sub    $0x23,%eax
  8007c9:	3c 55                	cmp    $0x55,%al
  8007cb:	0f 87 d8 02 00 00    	ja     800aa9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  8007d1:	0f b6 c0             	movzbl %al,%eax
  8007d4:	ff 24 85 40 4b 80 00 	jmp    *0x804b40(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8007db:	83 ea 30             	sub    $0x30,%edx
  8007de:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8007e1:	8b 55 10             	mov    0x10(%ebp),%edx
  8007e4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8007e7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8007ed:	83 fa 09             	cmp    $0x9,%edx
  8007f0:	77 4e                	ja     800840 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8007f8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8007fb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8007ff:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800802:	8d 50 d0             	lea    -0x30(%eax),%edx
  800805:	83 fa 09             	cmp    $0x9,%edx
  800808:	76 eb                	jbe    8007f5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80080a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80080d:	eb 31                	jmp    800840 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8d 50 04             	lea    0x4(%eax),%edx
  800815:	89 55 14             	mov    %edx,0x14(%ebp)
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80081d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800820:	eb 1e                	jmp    800840 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800826:	0f 88 75 ff ff ff    	js     8007a1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80082f:	eb 89                	jmp    8007ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800831:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800834:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80083b:	e9 7a ff ff ff       	jmp    8007ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800840:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800844:	0f 89 70 ff ff ff    	jns    8007ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80084a:	e9 5e ff ff ff       	jmp    8007ad <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800852:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800855:	e9 60 ff ff ff       	jmp    8007ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8d 50 04             	lea    0x4(%eax),%edx
  800860:	89 55 14             	mov    %edx,0x14(%ebp)
  800863:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 04 24             	mov    %eax,(%esp)
  80086c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80086f:	e9 bf fe ff ff       	jmp    800733 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 50 04             	lea    0x4(%eax),%edx
  80087a:	89 55 14             	mov    %edx,0x14(%ebp)
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	89 c2                	mov    %eax,%edx
  800881:	c1 fa 1f             	sar    $0x1f,%edx
  800884:	31 d0                	xor    %edx,%eax
  800886:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800888:	83 f8 14             	cmp    $0x14,%eax
  80088b:	7f 0f                	jg     80089c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80088d:	8b 14 85 a0 4c 80 00 	mov    0x804ca0(,%eax,4),%edx
  800894:	85 d2                	test   %edx,%edx
  800896:	0f 85 35 02 00 00    	jne    800ad1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80089c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a0:	c7 44 24 08 c7 49 80 	movl   $0x8049c7,0x8(%esp)
  8008a7:	00 
  8008a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8008af:	89 34 24             	mov    %esi,(%esp)
  8008b2:	e8 48 fe ff ff       	call   8006ff <_Z8printfmtPFviPvES_PKcz>
  8008b7:	e9 77 fe ff ff       	jmp    800733 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8008bc:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8d 50 04             	lea    0x4(%eax),%edx
  8008cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ce:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  8008d0:	85 db                	test   %ebx,%ebx
  8008d2:	ba c0 49 80 00       	mov    $0x8049c0,%edx
  8008d7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  8008da:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008de:	7e 72                	jle    800952 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8008e0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8008e4:	74 6c                	je     800952 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008ea:	89 1c 24             	mov    %ebx,(%esp)
  8008ed:	e8 a9 02 00 00       	call   800b9b <_Z7strnlenPKcj>
  8008f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008f5:	29 c2                	sub    %eax,%edx
  8008f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008fa:	85 d2                	test   %edx,%edx
  8008fc:	7e 54                	jle    800952 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  8008fe:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800902:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800905:	89 d3                	mov    %edx,%ebx
  800907:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80090a:	89 c6                	mov    %eax,%esi
  80090c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800910:	89 34 24             	mov    %esi,(%esp)
  800913:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800916:	83 eb 01             	sub    $0x1,%ebx
  800919:	85 db                	test   %ebx,%ebx
  80091b:	7f ef                	jg     80090c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80091d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800920:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800923:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80092a:	eb 26                	jmp    800952 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80092c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80092f:	83 fa 5e             	cmp    $0x5e,%edx
  800932:	76 10                	jbe    800944 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800934:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800938:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80093f:	ff 55 08             	call   *0x8(%ebp)
  800942:	eb 0a                	jmp    80094e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800944:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800948:	89 04 24             	mov    %eax,(%esp)
  80094b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800952:	0f be 03             	movsbl (%ebx),%eax
  800955:	83 c3 01             	add    $0x1,%ebx
  800958:	85 c0                	test   %eax,%eax
  80095a:	74 11                	je     80096d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80095c:	85 f6                	test   %esi,%esi
  80095e:	78 05                	js     800965 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800960:	83 ee 01             	sub    $0x1,%esi
  800963:	78 0d                	js     800972 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800965:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800969:	75 c1                	jne    80092c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80096b:	eb d7                	jmp    800944 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80096d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800970:	eb 03                	jmp    800975 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800975:	85 c0                	test   %eax,%eax
  800977:	0f 8e b6 fd ff ff    	jle    800733 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80097d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800980:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800983:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800987:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80098e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800990:	83 eb 01             	sub    $0x1,%ebx
  800993:	85 db                	test   %ebx,%ebx
  800995:	7f ec                	jg     800983 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800997:	e9 97 fd ff ff       	jmp    800733 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80099c:	83 f9 01             	cmp    $0x1,%ecx
  80099f:	90                   	nop
  8009a0:	7e 10                	jle    8009b2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	8d 50 08             	lea    0x8(%eax),%edx
  8009a8:	89 55 14             	mov    %edx,0x14(%ebp)
  8009ab:	8b 18                	mov    (%eax),%ebx
  8009ad:	8b 70 04             	mov    0x4(%eax),%esi
  8009b0:	eb 26                	jmp    8009d8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  8009b2:	85 c9                	test   %ecx,%ecx
  8009b4:	74 12                	je     8009c8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	8d 50 04             	lea    0x4(%eax),%edx
  8009bc:	89 55 14             	mov    %edx,0x14(%ebp)
  8009bf:	8b 18                	mov    (%eax),%ebx
  8009c1:	89 de                	mov    %ebx,%esi
  8009c3:	c1 fe 1f             	sar    $0x1f,%esi
  8009c6:	eb 10                	jmp    8009d8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	8d 50 04             	lea    0x4(%eax),%edx
  8009ce:	89 55 14             	mov    %edx,0x14(%ebp)
  8009d1:	8b 18                	mov    (%eax),%ebx
  8009d3:	89 de                	mov    %ebx,%esi
  8009d5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8009d8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8009dd:	85 f6                	test   %esi,%esi
  8009df:	0f 89 8c 00 00 00    	jns    800a71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8009e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009e9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009f0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8009f3:	f7 db                	neg    %ebx
  8009f5:	83 d6 00             	adc    $0x0,%esi
  8009f8:	f7 de                	neg    %esi
			}
			base = 10;
  8009fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ff:	eb 70                	jmp    800a71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a01:	89 ca                	mov    %ecx,%edx
  800a03:	8d 45 14             	lea    0x14(%ebp),%eax
  800a06:	e8 9d fc ff ff       	call   8006a8 <_ZL7getuintPPci>
  800a0b:	89 c3                	mov    %eax,%ebx
  800a0d:	89 d6                	mov    %edx,%esi
			base = 10;
  800a0f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800a14:	eb 5b                	jmp    800a71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800a16:	89 ca                	mov    %ecx,%edx
  800a18:	8d 45 14             	lea    0x14(%ebp),%eax
  800a1b:	e8 88 fc ff ff       	call   8006a8 <_ZL7getuintPPci>
  800a20:	89 c3                	mov    %eax,%ebx
  800a22:	89 d6                	mov    %edx,%esi
			base = 8;
  800a24:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800a29:	eb 46                	jmp    800a71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  800a2b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a2f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a36:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800a39:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a3d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a44:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	8d 50 04             	lea    0x4(%eax),%edx
  800a4d:	89 55 14             	mov    %edx,0x14(%ebp)
  800a50:	8b 18                	mov    (%eax),%ebx
  800a52:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800a57:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800a5c:	eb 13                	jmp    800a71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a5e:	89 ca                	mov    %ecx,%edx
  800a60:	8d 45 14             	lea    0x14(%ebp),%eax
  800a63:	e8 40 fc ff ff       	call   8006a8 <_ZL7getuintPPci>
  800a68:	89 c3                	mov    %eax,%ebx
  800a6a:	89 d6                	mov    %edx,%esi
			base = 16;
  800a6c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a71:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800a75:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a7c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a80:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a84:	89 1c 24             	mov    %ebx,(%esp)
  800a87:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a8b:	89 fa                	mov    %edi,%edx
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	e8 2b fb ff ff       	call   8005c0 <_ZL8printnumPFviPvES_yjii>
			break;
  800a95:	e9 99 fc ff ff       	jmp    800733 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a9a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a9e:	89 14 24             	mov    %edx,(%esp)
  800aa1:	ff 55 08             	call   *0x8(%ebp)
			break;
  800aa4:	e9 8a fc ff ff       	jmp    800733 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aad:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800ab4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aba:	89 d8                	mov    %ebx,%eax
  800abc:	eb 02                	jmp    800ac0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  800abe:	89 d0                	mov    %edx,%eax
  800ac0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ac3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ac7:	75 f5                	jne    800abe <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800ac9:	89 45 10             	mov    %eax,0x10(%ebp)
  800acc:	e9 62 fc ff ff       	jmp    800733 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ad5:	c7 44 24 08 c6 4d 80 	movl   $0x804dc6,0x8(%esp)
  800adc:	00 
  800add:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ae1:	8b 75 08             	mov    0x8(%ebp),%esi
  800ae4:	89 34 24             	mov    %esi,(%esp)
  800ae7:	e8 13 fc ff ff       	call   8006ff <_Z8printfmtPFviPvES_PKcz>
  800aec:	e9 42 fc ff ff       	jmp    800733 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af1:	83 c4 3c             	add    $0x3c,%esp
  800af4:	5b                   	pop    %ebx
  800af5:	5e                   	pop    %esi
  800af6:	5f                   	pop    %edi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	83 ec 28             	sub    $0x28,%esp
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b0f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b13:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800b16:	85 c0                	test   %eax,%eax
  800b18:	74 30                	je     800b4a <_Z9vsnprintfPciPKcS_+0x51>
  800b1a:	85 d2                	test   %edx,%edx
  800b1c:	7e 2c                	jle    800b4a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b25:	8b 45 10             	mov    0x10(%ebp),%eax
  800b28:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b2c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b33:	c7 04 24 e2 06 80 00 	movl   $0x8006e2,(%esp)
  800b3a:	e8 e8 fb ff ff       	call   800727 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  800b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b42:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b48:	eb 05                	jmp    800b4f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800b4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b57:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b61:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 04 24             	mov    %eax,(%esp)
  800b72:	e8 82 ff ff ff       	call   800af9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    
  800b79:	00 00                	add    %al,(%eax)
  800b7b:	00 00                	add    %al,(%eax)
  800b7d:	00 00                	add    %al,(%eax)
	...

00800b80 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b86:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b8e:	74 09                	je     800b99 <_Z6strlenPKc+0x19>
		n++;
  800b90:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b97:	75 f7                	jne    800b90 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 0b                	je     800bb8 <_Z7strnlenPKcj+0x1d>
  800bad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800bb1:	74 05                	je     800bb8 <_Z7strnlenPKcj+0x1d>
		n++;
  800bb3:	83 c0 01             	add    $0x1,%eax
  800bb6:	eb f1                	jmp    800ba9 <_Z7strnlenPKcj+0xe>
	return n;
}
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	53                   	push   %ebx
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bcd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bd0:	83 c2 01             	add    $0x1,%edx
  800bd3:	84 c9                	test   %cl,%cl
  800bd5:	75 f2                	jne    800bc9 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800bd7:	5b                   	pop    %ebx
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	56                   	push   %esi
  800bde:	53                   	push   %ebx
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800be8:	85 f6                	test   %esi,%esi
  800bea:	74 18                	je     800c04 <_Z7strncpyPcPKcj+0x2a>
  800bec:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800bf1:	0f b6 1a             	movzbl (%edx),%ebx
  800bf4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bf7:	80 3a 01             	cmpb   $0x1,(%edx)
  800bfa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800bfd:	83 c1 01             	add    $0x1,%ecx
  800c00:	39 ce                	cmp    %ecx,%esi
  800c02:	77 ed                	ja     800bf1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c13:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800c16:	89 f0                	mov    %esi,%eax
  800c18:	85 d2                	test   %edx,%edx
  800c1a:	74 17                	je     800c33 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800c1c:	83 ea 01             	sub    $0x1,%edx
  800c1f:	74 18                	je     800c39 <_Z7strlcpyPcPKcj+0x31>
  800c21:	80 39 00             	cmpb   $0x0,(%ecx)
  800c24:	74 17                	je     800c3d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800c26:	0f b6 19             	movzbl (%ecx),%ebx
  800c29:	88 18                	mov    %bl,(%eax)
  800c2b:	83 c0 01             	add    $0x1,%eax
  800c2e:	83 c1 01             	add    $0x1,%ecx
  800c31:	eb e9                	jmp    800c1c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800c33:	29 f0                	sub    %esi,%eax
}
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c39:	89 c2                	mov    %eax,%edx
  800c3b:	eb 02                	jmp    800c3f <_Z7strlcpyPcPKcj+0x37>
  800c3d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800c3f:	c6 02 00             	movb   $0x0,(%edx)
  800c42:	eb ef                	jmp    800c33 <_Z7strlcpyPcPKcj+0x2b>

00800c44 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c4d:	0f b6 01             	movzbl (%ecx),%eax
  800c50:	84 c0                	test   %al,%al
  800c52:	74 0c                	je     800c60 <_Z6strcmpPKcS0_+0x1c>
  800c54:	3a 02                	cmp    (%edx),%al
  800c56:	75 08                	jne    800c60 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800c58:	83 c1 01             	add    $0x1,%ecx
  800c5b:	83 c2 01             	add    $0x1,%edx
  800c5e:	eb ed                	jmp    800c4d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800c60:	0f b6 c0             	movzbl %al,%eax
  800c63:	0f b6 12             	movzbl (%edx),%edx
  800c66:	29 d0                	sub    %edx,%eax
}
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	53                   	push   %ebx
  800c6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c74:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800c77:	85 d2                	test   %edx,%edx
  800c79:	74 16                	je     800c91 <_Z7strncmpPKcS0_j+0x27>
  800c7b:	0f b6 01             	movzbl (%ecx),%eax
  800c7e:	84 c0                	test   %al,%al
  800c80:	74 17                	je     800c99 <_Z7strncmpPKcS0_j+0x2f>
  800c82:	3a 03                	cmp    (%ebx),%al
  800c84:	75 13                	jne    800c99 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800c86:	83 ea 01             	sub    $0x1,%edx
  800c89:	83 c1 01             	add    $0x1,%ecx
  800c8c:	83 c3 01             	add    $0x1,%ebx
  800c8f:	eb e6                	jmp    800c77 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800c91:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800c96:	5b                   	pop    %ebx
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800c99:	0f b6 01             	movzbl (%ecx),%eax
  800c9c:	0f b6 13             	movzbl (%ebx),%edx
  800c9f:	29 d0                	sub    %edx,%eax
  800ca1:	eb f3                	jmp    800c96 <_Z7strncmpPKcS0_j+0x2c>

00800ca3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cad:	0f b6 10             	movzbl (%eax),%edx
  800cb0:	84 d2                	test   %dl,%dl
  800cb2:	74 1f                	je     800cd3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800cb4:	38 ca                	cmp    %cl,%dl
  800cb6:	75 0a                	jne    800cc2 <_Z6strchrPKcc+0x1f>
  800cb8:	eb 1e                	jmp    800cd8 <_Z6strchrPKcc+0x35>
  800cba:	38 ca                	cmp    %cl,%dl
  800cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800cc0:	74 16                	je     800cd8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cc2:	83 c0 01             	add    $0x1,%eax
  800cc5:	0f b6 10             	movzbl (%eax),%edx
  800cc8:	84 d2                	test   %dl,%dl
  800cca:	75 ee                	jne    800cba <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd1:	eb 05                	jmp    800cd8 <_Z6strchrPKcc+0x35>
  800cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ce4:	0f b6 10             	movzbl (%eax),%edx
  800ce7:	84 d2                	test   %dl,%dl
  800ce9:	74 14                	je     800cff <_Z7strfindPKcc+0x25>
		if (*s == c)
  800ceb:	38 ca                	cmp    %cl,%dl
  800ced:	75 06                	jne    800cf5 <_Z7strfindPKcc+0x1b>
  800cef:	eb 0e                	jmp    800cff <_Z7strfindPKcc+0x25>
  800cf1:	38 ca                	cmp    %cl,%dl
  800cf3:	74 0a                	je     800cff <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cf5:	83 c0 01             	add    $0x1,%eax
  800cf8:	0f b6 10             	movzbl (%eax),%edx
  800cfb:	84 d2                	test   %dl,%dl
  800cfd:	75 f2                	jne    800cf1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	83 ec 0c             	sub    $0xc,%esp
  800d07:	89 1c 24             	mov    %ebx,(%esp)
  800d0a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d12:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800d1b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d21:	75 25                	jne    800d48 <memset+0x47>
  800d23:	f6 c1 03             	test   $0x3,%cl
  800d26:	75 20                	jne    800d48 <memset+0x47>
		c &= 0xFF;
  800d28:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d2b:	89 d3                	mov    %edx,%ebx
  800d2d:	c1 e3 08             	shl    $0x8,%ebx
  800d30:	89 d6                	mov    %edx,%esi
  800d32:	c1 e6 18             	shl    $0x18,%esi
  800d35:	89 d0                	mov    %edx,%eax
  800d37:	c1 e0 10             	shl    $0x10,%eax
  800d3a:	09 f0                	or     %esi,%eax
  800d3c:	09 d0                	or     %edx,%eax
  800d3e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800d40:	c1 e9 02             	shr    $0x2,%ecx
  800d43:	fc                   	cld    
  800d44:	f3 ab                	rep stos %eax,%es:(%edi)
  800d46:	eb 03                	jmp    800d4b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800d48:	fc                   	cld    
  800d49:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800d4b:	89 f8                	mov    %edi,%eax
  800d4d:	8b 1c 24             	mov    (%esp),%ebx
  800d50:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d54:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d58:	89 ec                	mov    %ebp,%esp
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	83 ec 08             	sub    $0x8,%esp
  800d62:	89 34 24             	mov    %esi,(%esp)
  800d65:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800d72:	39 c6                	cmp    %eax,%esi
  800d74:	73 36                	jae    800dac <memmove+0x50>
  800d76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d79:	39 d0                	cmp    %edx,%eax
  800d7b:	73 2f                	jae    800dac <memmove+0x50>
		s += n;
		d += n;
  800d7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800d80:	f6 c2 03             	test   $0x3,%dl
  800d83:	75 1b                	jne    800da0 <memmove+0x44>
  800d85:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d8b:	75 13                	jne    800da0 <memmove+0x44>
  800d8d:	f6 c1 03             	test   $0x3,%cl
  800d90:	75 0e                	jne    800da0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d92:	83 ef 04             	sub    $0x4,%edi
  800d95:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d98:	c1 e9 02             	shr    $0x2,%ecx
  800d9b:	fd                   	std    
  800d9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d9e:	eb 09                	jmp    800da9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800da0:	83 ef 01             	sub    $0x1,%edi
  800da3:	8d 72 ff             	lea    -0x1(%edx),%esi
  800da6:	fd                   	std    
  800da7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800da9:	fc                   	cld    
  800daa:	eb 20                	jmp    800dcc <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800dac:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800db2:	75 13                	jne    800dc7 <memmove+0x6b>
  800db4:	a8 03                	test   $0x3,%al
  800db6:	75 0f                	jne    800dc7 <memmove+0x6b>
  800db8:	f6 c1 03             	test   $0x3,%cl
  800dbb:	75 0a                	jne    800dc7 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dbd:	c1 e9 02             	shr    $0x2,%ecx
  800dc0:	89 c7                	mov    %eax,%edi
  800dc2:	fc                   	cld    
  800dc3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dc5:	eb 05                	jmp    800dcc <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800dc7:	89 c7                	mov    %eax,%edi
  800dc9:	fc                   	cld    
  800dca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800dcc:	8b 34 24             	mov    (%esp),%esi
  800dcf:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800dd3:	89 ec                	mov    %ebp,%esp
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	89 34 24             	mov    %esi,(%esp)
  800de0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dea:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800ded:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800df3:	75 13                	jne    800e08 <memcpy+0x31>
  800df5:	a8 03                	test   $0x3,%al
  800df7:	75 0f                	jne    800e08 <memcpy+0x31>
  800df9:	f6 c1 03             	test   $0x3,%cl
  800dfc:	75 0a                	jne    800e08 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dfe:	c1 e9 02             	shr    $0x2,%ecx
  800e01:	89 c7                	mov    %eax,%edi
  800e03:	fc                   	cld    
  800e04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e06:	eb 05                	jmp    800e0d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800e08:	89 c7                	mov    %eax,%edi
  800e0a:	fc                   	cld    
  800e0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800e0d:	8b 34 24             	mov    (%esp),%esi
  800e10:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800e14:	89 ec                	mov    %ebp,%esp
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	57                   	push   %edi
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
  800e1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e21:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e24:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800e27:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800e2c:	85 ff                	test   %edi,%edi
  800e2e:	74 38                	je     800e68 <memcmp+0x50>
		if (*s1 != *s2)
  800e30:	0f b6 03             	movzbl (%ebx),%eax
  800e33:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800e36:	83 ef 01             	sub    $0x1,%edi
  800e39:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800e3e:	38 c8                	cmp    %cl,%al
  800e40:	74 1d                	je     800e5f <memcmp+0x47>
  800e42:	eb 11                	jmp    800e55 <memcmp+0x3d>
  800e44:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800e49:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800e4e:	83 c2 01             	add    $0x1,%edx
  800e51:	38 c8                	cmp    %cl,%al
  800e53:	74 0a                	je     800e5f <memcmp+0x47>
			return *s1 - *s2;
  800e55:	0f b6 c0             	movzbl %al,%eax
  800e58:	0f b6 c9             	movzbl %cl,%ecx
  800e5b:	29 c8                	sub    %ecx,%eax
  800e5d:	eb 09                	jmp    800e68 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800e5f:	39 fa                	cmp    %edi,%edx
  800e61:	75 e1                	jne    800e44 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800e63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e68:	5b                   	pop    %ebx
  800e69:	5e                   	pop    %esi
  800e6a:	5f                   	pop    %edi
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    

00800e6d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	53                   	push   %ebx
  800e71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800e74:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800e76:	89 da                	mov    %ebx,%edx
  800e78:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800e7b:	39 d3                	cmp    %edx,%ebx
  800e7d:	73 15                	jae    800e94 <memfind+0x27>
		if (*s == (unsigned char) c)
  800e7f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e83:	38 0b                	cmp    %cl,(%ebx)
  800e85:	75 06                	jne    800e8d <memfind+0x20>
  800e87:	eb 0b                	jmp    800e94 <memfind+0x27>
  800e89:	38 08                	cmp    %cl,(%eax)
  800e8b:	74 07                	je     800e94 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800e8d:	83 c0 01             	add    $0x1,%eax
  800e90:	39 c2                	cmp    %eax,%edx
  800e92:	77 f5                	ja     800e89 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e94:	5b                   	pop    %ebx
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	57                   	push   %edi
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ea3:	0f b6 02             	movzbl (%edx),%eax
  800ea6:	3c 20                	cmp    $0x20,%al
  800ea8:	74 04                	je     800eae <_Z6strtolPKcPPci+0x17>
  800eaa:	3c 09                	cmp    $0x9,%al
  800eac:	75 0e                	jne    800ebc <_Z6strtolPKcPPci+0x25>
		s++;
  800eae:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb1:	0f b6 02             	movzbl (%edx),%eax
  800eb4:	3c 20                	cmp    $0x20,%al
  800eb6:	74 f6                	je     800eae <_Z6strtolPKcPPci+0x17>
  800eb8:	3c 09                	cmp    $0x9,%al
  800eba:	74 f2                	je     800eae <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ebc:	3c 2b                	cmp    $0x2b,%al
  800ebe:	75 0a                	jne    800eca <_Z6strtolPKcPPci+0x33>
		s++;
  800ec0:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ec3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ec8:	eb 10                	jmp    800eda <_Z6strtolPKcPPci+0x43>
  800eca:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ecf:	3c 2d                	cmp    $0x2d,%al
  800ed1:	75 07                	jne    800eda <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800ed3:	83 c2 01             	add    $0x1,%edx
  800ed6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eda:	85 db                	test   %ebx,%ebx
  800edc:	0f 94 c0             	sete   %al
  800edf:	74 05                	je     800ee6 <_Z6strtolPKcPPci+0x4f>
  800ee1:	83 fb 10             	cmp    $0x10,%ebx
  800ee4:	75 15                	jne    800efb <_Z6strtolPKcPPci+0x64>
  800ee6:	80 3a 30             	cmpb   $0x30,(%edx)
  800ee9:	75 10                	jne    800efb <_Z6strtolPKcPPci+0x64>
  800eeb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800eef:	75 0a                	jne    800efb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800ef1:	83 c2 02             	add    $0x2,%edx
  800ef4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ef9:	eb 13                	jmp    800f0e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800efb:	84 c0                	test   %al,%al
  800efd:	74 0f                	je     800f0e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800eff:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f04:	80 3a 30             	cmpb   $0x30,(%edx)
  800f07:	75 05                	jne    800f0e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800f09:	83 c2 01             	add    $0x1,%edx
  800f0c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f13:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f15:	0f b6 0a             	movzbl (%edx),%ecx
  800f18:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f1b:	80 fb 09             	cmp    $0x9,%bl
  800f1e:	77 08                	ja     800f28 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800f20:	0f be c9             	movsbl %cl,%ecx
  800f23:	83 e9 30             	sub    $0x30,%ecx
  800f26:	eb 1e                	jmp    800f46 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800f28:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800f2b:	80 fb 19             	cmp    $0x19,%bl
  800f2e:	77 08                	ja     800f38 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800f30:	0f be c9             	movsbl %cl,%ecx
  800f33:	83 e9 57             	sub    $0x57,%ecx
  800f36:	eb 0e                	jmp    800f46 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800f38:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800f3b:	80 fb 19             	cmp    $0x19,%bl
  800f3e:	77 15                	ja     800f55 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800f40:	0f be c9             	movsbl %cl,%ecx
  800f43:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f46:	39 f1                	cmp    %esi,%ecx
  800f48:	7d 0f                	jge    800f59 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800f4a:	83 c2 01             	add    $0x1,%edx
  800f4d:	0f af c6             	imul   %esi,%eax
  800f50:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800f53:	eb c0                	jmp    800f15 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800f55:	89 c1                	mov    %eax,%ecx
  800f57:	eb 02                	jmp    800f5b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f59:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f5f:	74 05                	je     800f66 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800f61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f64:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f66:	89 ca                	mov    %ecx,%edx
  800f68:	f7 da                	neg    %edx
  800f6a:	85 ff                	test   %edi,%edi
  800f6c:	0f 45 c2             	cmovne %edx,%eax
}
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
  800f77:	83 ec 0c             	sub    $0xc,%esp
  800f7a:	89 1c 24             	mov    %ebx,(%esp)
  800f7d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f81:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f85:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	89 c3                	mov    %eax,%ebx
  800f92:	89 c7                	mov    %eax,%edi
  800f94:	89 c6                	mov    %eax,%esi
  800f96:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f98:	8b 1c 24             	mov    (%esp),%ebx
  800f9b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f9f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fa3:	89 ec                	mov    %ebp,%esp
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 0c             	sub    $0xc,%esp
  800fad:	89 1c 24             	mov    %ebx,(%esp)
  800fb0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fb4:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbd:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc2:	89 d1                	mov    %edx,%ecx
  800fc4:	89 d3                	mov    %edx,%ebx
  800fc6:	89 d7                	mov    %edx,%edi
  800fc8:	89 d6                	mov    %edx,%esi
  800fca:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fcc:	8b 1c 24             	mov    (%esp),%ebx
  800fcf:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fd3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fd7:	89 ec                	mov    %ebp,%esp
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 38             	sub    $0x38,%esp
  800fe1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fe4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fe7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800fea:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fef:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	89 cb                	mov    %ecx,%ebx
  800ff9:	89 cf                	mov    %ecx,%edi
  800ffb:	89 ce                	mov    %ecx,%esi
  800ffd:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fff:	85 c0                	test   %eax,%eax
  801001:	7e 28                	jle    80102b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801003:	89 44 24 10          	mov    %eax,0x10(%esp)
  801007:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80100e:	00 
  80100f:	c7 44 24 08 f4 4c 80 	movl   $0x804cf4,0x8(%esp)
  801016:	00 
  801017:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80101e:	00 
  80101f:	c7 04 24 11 4d 80 00 	movl   $0x804d11,(%esp)
  801026:	e8 59 f4 ff ff       	call   800484 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80102b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80102e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801031:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801034:	89 ec                	mov    %ebp,%esp
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	89 1c 24             	mov    %ebx,(%esp)
  801041:	89 74 24 04          	mov    %esi,0x4(%esp)
  801045:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801049:	ba 00 00 00 00       	mov    $0x0,%edx
  80104e:	b8 02 00 00 00       	mov    $0x2,%eax
  801053:	89 d1                	mov    %edx,%ecx
  801055:	89 d3                	mov    %edx,%ebx
  801057:	89 d7                	mov    %edx,%edi
  801059:	89 d6                	mov    %edx,%esi
  80105b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80105d:	8b 1c 24             	mov    (%esp),%ebx
  801060:	8b 74 24 04          	mov    0x4(%esp),%esi
  801064:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801068:	89 ec                	mov    %ebp,%esp
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    

0080106c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 0c             	sub    $0xc,%esp
  801072:	89 1c 24             	mov    %ebx,(%esp)
  801075:	89 74 24 04          	mov    %esi,0x4(%esp)
  801079:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80107d:	ba 00 00 00 00       	mov    $0x0,%edx
  801082:	b8 04 00 00 00       	mov    $0x4,%eax
  801087:	89 d1                	mov    %edx,%ecx
  801089:	89 d3                	mov    %edx,%ebx
  80108b:	89 d7                	mov    %edx,%edi
  80108d:	89 d6                	mov    %edx,%esi
  80108f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801091:	8b 1c 24             	mov    (%esp),%ebx
  801094:	8b 74 24 04          	mov    0x4(%esp),%esi
  801098:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80109c:	89 ec                	mov    %ebp,%esp
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    

008010a0 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	83 ec 38             	sub    $0x38,%esp
  8010a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010a9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010af:	be 00 00 00 00       	mov    $0x0,%esi
  8010b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8010b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c2:	89 f7                	mov    %esi,%edi
  8010c4:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	7e 28                	jle    8010f2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ce:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010d5:	00 
  8010d6:	c7 44 24 08 f4 4c 80 	movl   $0x804cf4,0x8(%esp)
  8010dd:	00 
  8010de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e5:	00 
  8010e6:	c7 04 24 11 4d 80 00 	movl   $0x804d11,(%esp)
  8010ed:	e8 92 f3 ff ff       	call   800484 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010fb:	89 ec                	mov    %ebp,%esp
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    

008010ff <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 38             	sub    $0x38,%esp
  801105:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801108:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80110b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80110e:	b8 09 00 00 00       	mov    $0x9,%eax
  801113:	8b 75 18             	mov    0x18(%ebp),%esi
  801116:	8b 7d 14             	mov    0x14(%ebp),%edi
  801119:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80111c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	cd 30                	int    $0x30

	if(check && ret > 0)
  801124:	85 c0                	test   %eax,%eax
  801126:	7e 28                	jle    801150 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801128:	89 44 24 10          	mov    %eax,0x10(%esp)
  80112c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801133:	00 
  801134:	c7 44 24 08 f4 4c 80 	movl   $0x804cf4,0x8(%esp)
  80113b:	00 
  80113c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801143:	00 
  801144:	c7 04 24 11 4d 80 00 	movl   $0x804d11,(%esp)
  80114b:	e8 34 f3 ff ff       	call   800484 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801150:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801153:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801156:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801159:	89 ec                	mov    %ebp,%esp
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    

0080115d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 38             	sub    $0x38,%esp
  801163:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801166:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801169:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80116c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801171:	b8 0a 00 00 00       	mov    $0xa,%eax
  801176:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801179:	8b 55 08             	mov    0x8(%ebp),%edx
  80117c:	89 df                	mov    %ebx,%edi
  80117e:	89 de                	mov    %ebx,%esi
  801180:	cd 30                	int    $0x30

	if(check && ret > 0)
  801182:	85 c0                	test   %eax,%eax
  801184:	7e 28                	jle    8011ae <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801186:	89 44 24 10          	mov    %eax,0x10(%esp)
  80118a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801191:	00 
  801192:	c7 44 24 08 f4 4c 80 	movl   $0x804cf4,0x8(%esp)
  801199:	00 
  80119a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a1:	00 
  8011a2:	c7 04 24 11 4d 80 00 	movl   $0x804d11,(%esp)
  8011a9:	e8 d6 f2 ff ff       	call   800484 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011b1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011b4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011b7:	89 ec                	mov    %ebp,%esp
  8011b9:	5d                   	pop    %ebp
  8011ba:	c3                   	ret    

008011bb <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 38             	sub    $0x38,%esp
  8011c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8011d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011da:	89 df                	mov    %ebx,%edi
  8011dc:	89 de                	mov    %ebx,%esi
  8011de:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	7e 28                	jle    80120c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011ef:	00 
  8011f0:	c7 44 24 08 f4 4c 80 	movl   $0x804cf4,0x8(%esp)
  8011f7:	00 
  8011f8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ff:	00 
  801200:	c7 04 24 11 4d 80 00 	movl   $0x804d11,(%esp)
  801207:	e8 78 f2 ff ff       	call   800484 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80120c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80120f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801212:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801215:	89 ec                	mov    %ebp,%esp
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    

00801219 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 38             	sub    $0x38,%esp
  80121f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801222:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801225:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801228:	bb 00 00 00 00       	mov    $0x0,%ebx
  80122d:	b8 06 00 00 00       	mov    $0x6,%eax
  801232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801235:	8b 55 08             	mov    0x8(%ebp),%edx
  801238:	89 df                	mov    %ebx,%edi
  80123a:	89 de                	mov    %ebx,%esi
  80123c:	cd 30                	int    $0x30

	if(check && ret > 0)
  80123e:	85 c0                	test   %eax,%eax
  801240:	7e 28                	jle    80126a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801242:	89 44 24 10          	mov    %eax,0x10(%esp)
  801246:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80124d:	00 
  80124e:	c7 44 24 08 f4 4c 80 	movl   $0x804cf4,0x8(%esp)
  801255:	00 
  801256:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80125d:	00 
  80125e:	c7 04 24 11 4d 80 00 	movl   $0x804d11,(%esp)
  801265:	e8 1a f2 ff ff       	call   800484 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80126a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80126d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801270:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801273:	89 ec                	mov    %ebp,%esp
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    

00801277 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 38             	sub    $0x38,%esp
  80127d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801280:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801283:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801286:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801290:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801293:	8b 55 08             	mov    0x8(%ebp),%edx
  801296:	89 df                	mov    %ebx,%edi
  801298:	89 de                	mov    %ebx,%esi
  80129a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80129c:	85 c0                	test   %eax,%eax
  80129e:	7e 28                	jle    8012c8 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a4:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8012ab:	00 
  8012ac:	c7 44 24 08 f4 4c 80 	movl   $0x804cf4,0x8(%esp)
  8012b3:	00 
  8012b4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012bb:	00 
  8012bc:	c7 04 24 11 4d 80 00 	movl   $0x804d11,(%esp)
  8012c3:	e8 bc f1 ff ff       	call   800484 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012cb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012ce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012d1:	89 ec                	mov    %ebp,%esp
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 38             	sub    $0x38,%esp
  8012db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f4:	89 df                	mov    %ebx,%edi
  8012f6:	89 de                	mov    %ebx,%esi
  8012f8:	cd 30                	int    $0x30

	if(check && ret > 0)
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	7e 28                	jle    801326 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  801302:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801309:	00 
  80130a:	c7 44 24 08 f4 4c 80 	movl   $0x804cf4,0x8(%esp)
  801311:	00 
  801312:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801319:	00 
  80131a:	c7 04 24 11 4d 80 00 	movl   $0x804d11,(%esp)
  801321:	e8 5e f1 ff ff       	call   800484 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801326:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801329:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80132c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80132f:	89 ec                	mov    %ebp,%esp
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    

00801333 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	89 1c 24             	mov    %ebx,(%esp)
  80133c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801340:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801344:	be 00 00 00 00       	mov    $0x0,%esi
  801349:	b8 0d 00 00 00       	mov    $0xd,%eax
  80134e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801351:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801354:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801357:	8b 55 08             	mov    0x8(%ebp),%edx
  80135a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80135c:	8b 1c 24             	mov    (%esp),%ebx
  80135f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801363:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801367:	89 ec                	mov    %ebp,%esp
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    

0080136b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	83 ec 38             	sub    $0x38,%esp
  801371:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801374:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801377:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80137a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80137f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801384:	8b 55 08             	mov    0x8(%ebp),%edx
  801387:	89 cb                	mov    %ecx,%ebx
  801389:	89 cf                	mov    %ecx,%edi
  80138b:	89 ce                	mov    %ecx,%esi
  80138d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80138f:	85 c0                	test   %eax,%eax
  801391:	7e 28                	jle    8013bb <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801393:	89 44 24 10          	mov    %eax,0x10(%esp)
  801397:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80139e:	00 
  80139f:	c7 44 24 08 f4 4c 80 	movl   $0x804cf4,0x8(%esp)
  8013a6:	00 
  8013a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013ae:	00 
  8013af:	c7 04 24 11 4d 80 00 	movl   $0x804d11,(%esp)
  8013b6:	e8 c9 f0 ff ff       	call   800484 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8013bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013c4:	89 ec                	mov    %ebp,%esp
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    

008013c8 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 0c             	sub    $0xc,%esp
  8013ce:	89 1c 24             	mov    %ebx,(%esp)
  8013d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013d5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013de:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e9:	89 df                	mov    %ebx,%edi
  8013eb:	89 de                	mov    %ebx,%esi
  8013ed:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8013ef:	8b 1c 24             	mov    (%esp),%ebx
  8013f2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013f6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013fa:	89 ec                	mov    %ebp,%esp
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    

008013fe <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	89 1c 24             	mov    %ebx,(%esp)
  801407:	89 74 24 04          	mov    %esi,0x4(%esp)
  80140b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80140f:	ba 00 00 00 00       	mov    $0x0,%edx
  801414:	b8 11 00 00 00       	mov    $0x11,%eax
  801419:	89 d1                	mov    %edx,%ecx
  80141b:	89 d3                	mov    %edx,%ebx
  80141d:	89 d7                	mov    %edx,%edi
  80141f:	89 d6                	mov    %edx,%esi
  801421:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801423:	8b 1c 24             	mov    (%esp),%ebx
  801426:	8b 74 24 04          	mov    0x4(%esp),%esi
  80142a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80142e:	89 ec                	mov    %ebp,%esp
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    

00801432 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 0c             	sub    $0xc,%esp
  801438:	89 1c 24             	mov    %ebx,(%esp)
  80143b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80143f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801443:	bb 00 00 00 00       	mov    $0x0,%ebx
  801448:	b8 12 00 00 00       	mov    $0x12,%eax
  80144d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801450:	8b 55 08             	mov    0x8(%ebp),%edx
  801453:	89 df                	mov    %ebx,%edi
  801455:	89 de                	mov    %ebx,%esi
  801457:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801459:	8b 1c 24             	mov    (%esp),%ebx
  80145c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801460:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801464:	89 ec                	mov    %ebp,%esp
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    

00801468 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	89 1c 24             	mov    %ebx,(%esp)
  801471:	89 74 24 04          	mov    %esi,0x4(%esp)
  801475:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801479:	b9 00 00 00 00       	mov    $0x0,%ecx
  80147e:	b8 13 00 00 00       	mov    $0x13,%eax
  801483:	8b 55 08             	mov    0x8(%ebp),%edx
  801486:	89 cb                	mov    %ecx,%ebx
  801488:	89 cf                	mov    %ecx,%edi
  80148a:	89 ce                	mov    %ecx,%esi
  80148c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80148e:	8b 1c 24             	mov    (%esp),%ebx
  801491:	8b 74 24 04          	mov    0x4(%esp),%esi
  801495:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801499:	89 ec                	mov    %ebp,%esp
  80149b:	5d                   	pop    %ebp
  80149c:	c3                   	ret    

0080149d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	89 1c 24             	mov    %ebx,(%esp)
  8014a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8014ae:	b8 10 00 00 00       	mov    $0x10,%eax
  8014b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8014b6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c2:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  8014c4:	8b 1c 24             	mov    (%esp),%ebx
  8014c7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8014cb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8014cf:	89 ec                	mov    %ebp,%esp
  8014d1:	5d                   	pop    %ebp
  8014d2:	c3                   	ret    
	...

008014d4 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 38             	sub    $0x38,%esp
  8014da:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014dd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014e0:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  8014e3:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  8014ea:	f6 c7 04             	test   $0x4,%bh
  8014ed:	74 31                	je     801520 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  8014ef:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  8014f6:	c1 e2 0c             	shl    $0xc,%edx
  8014f9:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8014ff:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801503:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801507:	89 44 24 08          	mov    %eax,0x8(%esp)
  80150b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80150f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801516:	e8 e4 fb ff ff       	call   8010ff <_Z12sys_page_mapiPviS_i>
        return r;
  80151b:	e9 8c 00 00 00       	jmp    8015ac <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  801520:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  801527:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  80152c:	f7 c6 00 08 00 00    	test   $0x800,%esi
  801532:	75 2a                	jne    80155e <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  801534:	84 c9                	test   %cl,%cl
  801536:	74 0f                	je     801547 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  801538:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  80153f:	83 e3 02             	and    $0x2,%ebx
  801542:	80 cf 02             	or     $0x2,%bh
  801545:	eb 17                	jmp    80155e <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  801547:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  80154e:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  801551:	83 f9 01             	cmp    $0x1,%ecx
  801554:	19 db                	sbb    %ebx,%ebx
  801556:	f7 d3                	not    %ebx
  801558:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80155e:	89 df                	mov    %ebx,%edi
  801560:	83 cf 05             	or     $0x5,%edi
  801563:	89 d6                	mov    %edx,%esi
  801565:	c1 e6 0c             	shl    $0xc,%esi
  801568:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80156c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801570:	89 44 24 08          	mov    %eax,0x8(%esp)
  801574:	89 74 24 04          	mov    %esi,0x4(%esp)
  801578:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80157f:	e8 7b fb ff ff       	call   8010ff <_Z12sys_page_mapiPviS_i>
  801584:	85 c0                	test   %eax,%eax
  801586:	75 24                	jne    8015ac <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  801588:	85 db                	test   %ebx,%ebx
  80158a:	74 20                	je     8015ac <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80158c:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801590:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801594:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80159b:	00 
  80159c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a7:	e8 53 fb ff ff       	call   8010ff <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  8015ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015af:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015b5:	89 ec                	mov    %ebp,%esp
  8015b7:	5d                   	pop    %ebp
  8015b8:	c3                   	ret    

008015b9 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 28             	sub    $0x28,%esp
  8015bf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015c2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  8015c8:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  8015ca:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  8015ce:	0f 84 ff 00 00 00    	je     8016d3 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  8015d4:	89 f0                	mov    %esi,%eax
  8015d6:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  8015d9:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8015e0:	f6 c4 08             	test   $0x8,%ah
  8015e3:	0f 84 ea 00 00 00    	je     8016d3 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8015e9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015f0:	00 
  8015f1:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8015f8:	00 
  8015f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801600:	e8 9b fa ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  801605:	85 c0                	test   %eax,%eax
  801607:	79 20                	jns    801629 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  801609:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80160d:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  801614:	00 
  801615:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  80161c:	00 
  80161d:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  801624:	e8 5b ee ff ff       	call   800484 <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  801629:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  80162f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801636:	00 
  801637:	89 74 24 04          	mov    %esi,0x4(%esp)
  80163b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801642:	e8 90 f7 ff ff       	call   800dd7 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801647:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80164e:	00 
  80164f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801653:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80165a:	00 
  80165b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801662:	00 
  801663:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80166a:	e8 90 fa ff ff       	call   8010ff <_Z12sys_page_mapiPviS_i>
  80166f:	85 c0                	test   %eax,%eax
  801671:	79 20                	jns    801693 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  801673:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801677:	c7 44 24 08 3d 4d 80 	movl   $0x804d3d,0x8(%esp)
  80167e:	00 
  80167f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801686:	00 
  801687:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  80168e:	e8 f1 ed ff ff       	call   800484 <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801693:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80169a:	00 
  80169b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a2:	e8 b6 fa ff ff       	call   80115d <_Z14sys_page_unmapiPv>
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	79 20                	jns    8016cb <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  8016ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016af:	c7 44 24 08 4e 4d 80 	movl   $0x804d4e,0x8(%esp)
  8016b6:	00 
  8016b7:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8016be:	00 
  8016bf:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  8016c6:	e8 b9 ed ff ff       	call   800484 <_Z6_panicPKciS0_z>
    resume(utf);
  8016cb:	89 1c 24             	mov    %ebx,(%esp)
  8016ce:	e8 fd 2c 00 00       	call   8043d0 <resume>
}
  8016d3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8016d6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8016d9:	89 ec                	mov    %ebp,%esp
  8016db:	5d                   	pop    %ebp
  8016dc:	c3                   	ret    

008016dd <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	57                   	push   %edi
  8016e1:	56                   	push   %esi
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  8016e6:	c7 04 24 b9 15 80 00 	movl   $0x8015b9,(%esp)
  8016ed:	e8 09 2c 00 00       	call   8042fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  8016f2:	be 07 00 00 00       	mov    $0x7,%esi
  8016f7:	89 f0                	mov    %esi,%eax
  8016f9:	cd 30                	int    $0x30
  8016fb:	89 c6                	mov    %eax,%esi
  8016fd:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  8016ff:	85 c0                	test   %eax,%eax
  801701:	79 20                	jns    801723 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  801703:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801707:	c7 44 24 08 61 4d 80 	movl   $0x804d61,0x8(%esp)
  80170e:	00 
  80170f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801716:	00 
  801717:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  80171e:	e8 61 ed ff ff       	call   800484 <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801723:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  801728:	85 c0                	test   %eax,%eax
  80172a:	75 1c                	jne    801748 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  80172c:	e8 07 f9 ff ff       	call   801038 <_Z12sys_getenvidv>
  801731:	25 ff 03 00 00       	and    $0x3ff,%eax
  801736:	6b c0 78             	imul   $0x78,%eax,%eax
  801739:	05 00 00 00 ef       	add    $0xef000000,%eax
  80173e:	a3 00 74 80 00       	mov    %eax,0x807400
        return 0;
  801743:	e9 de 00 00 00       	jmp    801826 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  801748:	89 d8                	mov    %ebx,%eax
  80174a:	c1 f8 0a             	sar    $0xa,%eax
  80174d:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801754:	a8 01                	test   $0x1,%al
  801756:	75 08                	jne    801760 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  801758:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  80175e:	eb 19                	jmp    801779 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  801760:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801767:	a8 01                	test   $0x1,%al
  801769:	74 0e                	je     801779 <_Z4forkv+0x9c>
            duppage(envid, pn);
  80176b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801770:	89 da                	mov    %ebx,%edx
  801772:	89 f8                	mov    %edi,%eax
  801774:	e8 5b fd ff ff       	call   8014d4 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801779:	83 eb 01             	sub    $0x1,%ebx
  80177c:	79 ca                	jns    801748 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  80177e:	a1 00 74 80 00       	mov    0x807400,%eax
  801783:	8b 40 5c             	mov    0x5c(%eax),%eax
  801786:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178a:	89 34 24             	mov    %esi,(%esp)
  80178d:	e8 43 fb ff ff       	call   8012d5 <_Z26sys_env_set_pgfault_upcalliPv>
  801792:	85 c0                	test   %eax,%eax
  801794:	74 20                	je     8017b6 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801796:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80179a:	c7 44 24 08 88 4d 80 	movl   $0x804d88,0x8(%esp)
  8017a1:	00 
  8017a2:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  8017a9:	00 
  8017aa:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  8017b1:	e8 ce ec ff ff       	call   800484 <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8017b6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8017bd:	00 
  8017be:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8017c5:	ee 
  8017c6:	89 34 24             	mov    %esi,(%esp)
  8017c9:	e8 d2 f8 ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	79 20                	jns    8017f2 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  8017d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017d6:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  8017dd:	00 
  8017de:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  8017e5:	00 
  8017e6:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  8017ed:	e8 92 ec ff ff       	call   800484 <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8017f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017f9:	00 
  8017fa:	89 34 24             	mov    %esi,(%esp)
  8017fd:	e8 b9 f9 ff ff       	call   8011bb <_Z18sys_env_set_statusii>
  801802:	85 c0                	test   %eax,%eax
  801804:	79 20                	jns    801826 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  801806:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80180a:	c7 44 24 08 71 4d 80 	movl   $0x804d71,0x8(%esp)
  801811:	00 
  801812:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801819:	00 
  80181a:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  801821:	e8 5e ec ff ff       	call   800484 <_Z6_panicPKciS0_z>

    return envid;
}
  801826:	89 f0                	mov    %esi,%eax
  801828:	83 c4 1c             	add    $0x1c,%esp
  80182b:	5b                   	pop    %ebx
  80182c:	5e                   	pop    %esi
  80182d:	5f                   	pop    %edi
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    

00801830 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	57                   	push   %edi
  801834:	56                   	push   %esi
  801835:	53                   	push   %ebx
  801836:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  801839:	c7 04 24 b9 15 80 00 	movl   $0x8015b9,(%esp)
  801840:	e8 b6 2a 00 00       	call   8042fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  801845:	be 07 00 00 00       	mov    $0x7,%esi
  80184a:	89 f0                	mov    %esi,%eax
  80184c:	cd 30                	int    $0x30
  80184e:	89 c6                	mov    %eax,%esi
  801850:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  801852:	85 c0                	test   %eax,%eax
  801854:	79 20                	jns    801876 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  801856:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80185a:	c7 44 24 08 61 4d 80 	movl   $0x804d61,0x8(%esp)
  801861:	00 
  801862:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  801869:	00 
  80186a:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  801871:	e8 0e ec ff ff       	call   800484 <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  801876:	85 c0                	test   %eax,%eax
  801878:	0f 84 40 01 00 00    	je     8019be <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  80187e:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  801880:	c1 eb 0c             	shr    $0xc,%ebx
  801883:	83 eb 01             	sub    $0x1,%ebx
  801886:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  801889:	eb 31                	jmp    8018bc <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  80188b:	89 d8                	mov    %ebx,%eax
  80188d:	c1 f8 0a             	sar    $0xa,%eax
  801890:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801897:	a8 01                	test   $0x1,%al
  801899:	75 08                	jne    8018a3 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  80189b:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8018a1:	eb 19                	jmp    8018bc <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  8018a3:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8018aa:	a8 01                	test   $0x1,%al
  8018ac:	74 0e                	je     8018bc <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  8018ae:	b9 01 00 00 00       	mov    $0x1,%ecx
  8018b3:	89 da                	mov    %ebx,%edx
  8018b5:	89 f8                	mov    %edi,%eax
  8018b7:	e8 18 fc ff ff       	call   8014d4 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  8018bc:	83 eb 01             	sub    $0x1,%ebx
  8018bf:	79 ca                	jns    80188b <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  8018c1:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  8018c8:	7f 3f                	jg     801909 <_Z5sforkv+0xd9>
  8018ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  8018cd:	89 d8                	mov    %ebx,%eax
  8018cf:	c1 f8 0a             	sar    $0xa,%eax
  8018d2:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8018d9:	a8 01                	test   $0x1,%al
  8018db:	75 08                	jne    8018e5 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  8018dd:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8018e3:	eb 19                	jmp    8018fe <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  8018e5:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8018ec:	a8 01                	test   $0x1,%al
  8018ee:	74 0e                	je     8018fe <_Z5sforkv+0xce>
            duppage(envid, i);
  8018f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f5:	89 da                	mov    %ebx,%edx
  8018f7:	89 f8                	mov    %edi,%eax
  8018f9:	e8 d6 fb ff ff       	call   8014d4 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  8018fe:	83 c3 01             	add    $0x1,%ebx
  801901:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  801907:	7e c4                	jle    8018cd <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  801909:	e8 2a f7 ff ff       	call   801038 <_Z12sys_getenvidv>
  80190e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801913:	6b c0 78             	imul   $0x78,%eax,%eax
  801916:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  80191b:	8b 40 50             	mov    0x50(%eax),%eax
  80191e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801922:	89 34 24             	mov    %esi,(%esp)
  801925:	e8 ab f9 ff ff       	call   8012d5 <_Z26sys_env_set_pgfault_upcalliPv>
  80192a:	85 c0                	test   %eax,%eax
  80192c:	74 20                	je     80194e <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  80192e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801932:	c7 44 24 08 88 4d 80 	movl   $0x804d88,0x8(%esp)
  801939:	00 
  80193a:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801941:	00 
  801942:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  801949:	e8 36 eb ff ff       	call   800484 <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80194e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801955:	00 
  801956:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  80195d:	ee 
  80195e:	89 34 24             	mov    %esi,(%esp)
  801961:	e8 3a f7 ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  801966:	85 c0                	test   %eax,%eax
  801968:	79 20                	jns    80198a <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  80196a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80196e:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  801975:	00 
  801976:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  80197d:	00 
  80197e:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  801985:	e8 fa ea ff ff       	call   800484 <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80198a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801991:	00 
  801992:	89 34 24             	mov    %esi,(%esp)
  801995:	e8 21 f8 ff ff       	call   8011bb <_Z18sys_env_set_statusii>
  80199a:	85 c0                	test   %eax,%eax
  80199c:	79 20                	jns    8019be <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  80199e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019a2:	c7 44 24 08 71 4d 80 	movl   $0x804d71,0x8(%esp)
  8019a9:	00 
  8019aa:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  8019b1:	00 
  8019b2:	c7 04 24 32 4d 80 00 	movl   $0x804d32,(%esp)
  8019b9:	e8 c6 ea ff ff       	call   800484 <_Z6_panicPKciS0_z>

    return envid;
    
}
  8019be:	89 f0                	mov    %esi,%eax
  8019c0:	83 c4 2c             	add    $0x2c,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5e                   	pop    %esi
  8019c5:	5f                   	pop    %edi
  8019c6:	5d                   	pop    %ebp
  8019c7:	c3                   	ret    
	...

008019d0 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8019d3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8019d8:	75 11                	jne    8019eb <_ZL8fd_validPK2Fd+0x1b>
  8019da:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  8019df:	76 0a                	jbe    8019eb <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  8019e1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  8019e6:	0f 96 c0             	setbe  %al
  8019e9:	eb 05                	jmp    8019f0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8019eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f0:	5d                   	pop    %ebp
  8019f1:	c3                   	ret    

008019f2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	53                   	push   %ebx
  8019f6:	83 ec 14             	sub    $0x14,%esp
  8019f9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8019fb:	e8 d0 ff ff ff       	call   8019d0 <_ZL8fd_validPK2Fd>
  801a00:	84 c0                	test   %al,%al
  801a02:	75 24                	jne    801a28 <_ZL9fd_isopenPK2Fd+0x36>
  801a04:	c7 44 24 0c a7 4d 80 	movl   $0x804da7,0xc(%esp)
  801a0b:	00 
  801a0c:	c7 44 24 08 b4 4d 80 	movl   $0x804db4,0x8(%esp)
  801a13:	00 
  801a14:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801a1b:	00 
  801a1c:	c7 04 24 c9 4d 80 00 	movl   $0x804dc9,(%esp)
  801a23:	e8 5c ea ff ff       	call   800484 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801a28:	89 d8                	mov    %ebx,%eax
  801a2a:	c1 e8 16             	shr    $0x16,%eax
  801a2d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax
  801a39:	f6 c2 01             	test   $0x1,%dl
  801a3c:	74 0d                	je     801a4b <_ZL9fd_isopenPK2Fd+0x59>
  801a3e:	c1 eb 0c             	shr    $0xc,%ebx
  801a41:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801a48:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  801a4b:	83 c4 14             	add    $0x14,%esp
  801a4e:	5b                   	pop    %ebx
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 08             	sub    $0x8,%esp
  801a57:	89 1c 24             	mov    %ebx,(%esp)
  801a5a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a61:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a64:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801a68:	83 fb 1f             	cmp    $0x1f,%ebx
  801a6b:	77 18                	ja     801a85 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  801a6d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801a73:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801a76:	84 c0                	test   %al,%al
  801a78:	74 21                	je     801a9b <_Z9fd_lookupiPP2Fdb+0x4a>
  801a7a:	89 d8                	mov    %ebx,%eax
  801a7c:	e8 71 ff ff ff       	call   8019f2 <_ZL9fd_isopenPK2Fd>
  801a81:	84 c0                	test   %al,%al
  801a83:	75 16                	jne    801a9b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801a85:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  801a8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801a90:	8b 1c 24             	mov    (%esp),%ebx
  801a93:	8b 74 24 04          	mov    0x4(%esp),%esi
  801a97:	89 ec                	mov    %ebp,%esp
  801a99:	5d                   	pop    %ebp
  801a9a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  801a9b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  801a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa2:	eb ec                	jmp    801a90 <_Z9fd_lookupiPP2Fdb+0x3f>

00801aa4 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 14             	sub    $0x14,%esp
  801aab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  801aae:	89 d8                	mov    %ebx,%eax
  801ab0:	e8 1b ff ff ff       	call   8019d0 <_ZL8fd_validPK2Fd>
  801ab5:	84 c0                	test   %al,%al
  801ab7:	75 24                	jne    801add <_Z6fd2numP2Fd+0x39>
  801ab9:	c7 44 24 0c a7 4d 80 	movl   $0x804da7,0xc(%esp)
  801ac0:	00 
  801ac1:	c7 44 24 08 b4 4d 80 	movl   $0x804db4,0x8(%esp)
  801ac8:	00 
  801ac9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801ad0:	00 
  801ad1:	c7 04 24 c9 4d 80 00 	movl   $0x804dc9,(%esp)
  801ad8:	e8 a7 e9 ff ff       	call   800484 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801add:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801ae3:	c1 e8 0c             	shr    $0xc,%eax
}
  801ae6:	83 c4 14             	add    $0x14,%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	89 04 24             	mov    %eax,(%esp)
  801af8:	e8 a7 ff ff ff       	call   801aa4 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  801afd:	05 20 00 0d 00       	add    $0xd0020,%eax
  801b02:	c1 e0 0c             	shl    $0xc,%eax
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	57                   	push   %edi
  801b0b:	56                   	push   %esi
  801b0c:	53                   	push   %ebx
  801b0d:	83 ec 2c             	sub    $0x2c,%esp
  801b10:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801b13:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801b18:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  801b1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b22:	00 
  801b23:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b27:	89 1c 24             	mov    %ebx,(%esp)
  801b2a:	e8 22 ff ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  801b2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b32:	e8 bb fe ff ff       	call   8019f2 <_ZL9fd_isopenPK2Fd>
  801b37:	84 c0                	test   %al,%al
  801b39:	75 0c                	jne    801b47 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  801b3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b3e:	89 07                	mov    %eax,(%edi)
			return 0;
  801b40:	b8 00 00 00 00       	mov    $0x0,%eax
  801b45:	eb 13                	jmp    801b5a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801b47:	83 c3 01             	add    $0x1,%ebx
  801b4a:	83 fb 20             	cmp    $0x20,%ebx
  801b4d:	75 cc                	jne    801b1b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801b4f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801b55:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801b5a:	83 c4 2c             	add    $0x2c,%esp
  801b5d:	5b                   	pop    %ebx
  801b5e:	5e                   	pop    %esi
  801b5f:	5f                   	pop    %edi
  801b60:	5d                   	pop    %ebp
  801b61:	c3                   	ret    

00801b62 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	53                   	push   %ebx
  801b66:	83 ec 14             	sub    $0x14,%esp
  801b69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  801b6f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801b74:	39 0d 04 60 80 00    	cmp    %ecx,0x806004
  801b7a:	75 16                	jne    801b92 <_Z10dev_lookupiPP3Dev+0x30>
  801b7c:	eb 06                	jmp    801b84 <_Z10dev_lookupiPP3Dev+0x22>
  801b7e:	39 0a                	cmp    %ecx,(%edx)
  801b80:	75 10                	jne    801b92 <_Z10dev_lookupiPP3Dev+0x30>
  801b82:	eb 05                	jmp    801b89 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801b84:	ba 04 60 80 00       	mov    $0x806004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801b89:	89 13                	mov    %edx,(%ebx)
			return 0;
  801b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b90:	eb 35                	jmp    801bc7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801b92:	83 c0 01             	add    $0x1,%eax
  801b95:	8b 14 85 34 4e 80 00 	mov    0x804e34(,%eax,4),%edx
  801b9c:	85 d2                	test   %edx,%edx
  801b9e:	75 de                	jne    801b7e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ba0:	a1 00 74 80 00       	mov    0x807400,%eax
  801ba5:	8b 40 04             	mov    0x4(%eax),%eax
  801ba8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb0:	c7 04 24 f0 4d 80 00 	movl   $0x804df0,(%esp)
  801bb7:	e8 e6 e9 ff ff       	call   8005a2 <_Z7cprintfPKcz>
	*dev = 0;
  801bbc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801bc2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801bc7:	83 c4 14             	add    $0x14,%esp
  801bca:	5b                   	pop    %ebx
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    

00801bcd <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	56                   	push   %esi
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 20             	sub    $0x20,%esp
  801bd5:	8b 75 08             	mov    0x8(%ebp),%esi
  801bd8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  801bdc:	89 34 24             	mov    %esi,(%esp)
  801bdf:	e8 c0 fe ff ff       	call   801aa4 <_Z6fd2numP2Fd>
  801be4:	0f b6 d3             	movzbl %bl,%edx
  801be7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801beb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bee:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bf2:	89 04 24             	mov    %eax,(%esp)
  801bf5:	e8 57 fe ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	78 05                	js     801c03 <_Z8fd_closeP2Fdb+0x36>
  801bfe:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801c01:	74 0c                	je     801c0f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801c03:	80 fb 01             	cmp    $0x1,%bl
  801c06:	19 db                	sbb    %ebx,%ebx
  801c08:	f7 d3                	not    %ebx
  801c0a:	83 e3 fd             	and    $0xfffffffd,%ebx
  801c0d:	eb 3d                	jmp    801c4c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c16:	8b 06                	mov    (%esi),%eax
  801c18:	89 04 24             	mov    %eax,(%esp)
  801c1b:	e8 42 ff ff ff       	call   801b62 <_Z10dev_lookupiPP3Dev>
  801c20:	89 c3                	mov    %eax,%ebx
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 16                	js     801c3c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c29:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801c2c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801c31:	85 c0                	test   %eax,%eax
  801c33:	74 07                	je     801c3c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801c35:	89 34 24             	mov    %esi,(%esp)
  801c38:	ff d0                	call   *%eax
  801c3a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801c3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c47:	e8 11 f5 ff ff       	call   80115d <_Z14sys_page_unmapiPv>
	return r;
}
  801c4c:	89 d8                	mov    %ebx,%eax
  801c4e:	83 c4 20             	add    $0x20,%esp
  801c51:	5b                   	pop    %ebx
  801c52:	5e                   	pop    %esi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    

00801c55 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801c5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801c62:	00 
  801c63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	89 04 24             	mov    %eax,(%esp)
  801c70:	e8 dc fd ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  801c75:	85 c0                	test   %eax,%eax
  801c77:	78 13                	js     801c8c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801c79:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c80:	00 
  801c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c84:	89 04 24             	mov    %eax,(%esp)
  801c87:	e8 41 ff ff ff       	call   801bcd <_Z8fd_closeP2Fdb>
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <_Z9close_allv>:

void
close_all(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	53                   	push   %ebx
  801c92:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801c95:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801c9a:	89 1c 24             	mov    %ebx,(%esp)
  801c9d:	e8 b3 ff ff ff       	call   801c55 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801ca2:	83 c3 01             	add    $0x1,%ebx
  801ca5:	83 fb 20             	cmp    $0x20,%ebx
  801ca8:	75 f0                	jne    801c9a <_Z9close_allv+0xc>
		close(i);
}
  801caa:	83 c4 14             	add    $0x14,%esp
  801cad:	5b                   	pop    %ebx
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    

00801cb0 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 48             	sub    $0x48,%esp
  801cb6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801cb9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801cbc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801cbf:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801cc2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801cc9:	00 
  801cca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	89 04 24             	mov    %eax,(%esp)
  801cd7:	e8 75 fd ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  801cdc:	89 c3                	mov    %eax,%ebx
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	0f 88 ce 00 00 00    	js     801db4 <_Z3dupii+0x104>
  801ce6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ced:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  801cee:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801cf5:	89 34 24             	mov    %esi,(%esp)
  801cf8:	e8 54 fd ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  801cfd:	89 c3                	mov    %eax,%ebx
  801cff:	85 c0                	test   %eax,%eax
  801d01:	0f 89 bc 00 00 00    	jns    801dc3 <_Z3dupii+0x113>
  801d07:	e9 a8 00 00 00       	jmp    801db4 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801d0c:	89 d8                	mov    %ebx,%eax
  801d0e:	c1 e8 0c             	shr    $0xc,%eax
  801d11:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801d18:	f6 c2 01             	test   $0x1,%dl
  801d1b:	74 32                	je     801d4f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801d1d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801d24:	25 07 0e 00 00       	and    $0xe07,%eax
  801d29:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d31:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d38:	00 
  801d39:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d44:	e8 b6 f3 ff ff       	call   8010ff <_Z12sys_page_mapiPviS_i>
  801d49:	89 c3                	mov    %eax,%ebx
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	78 3e                	js     801d8d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d52:	89 c2                	mov    %eax,%edx
  801d54:	c1 ea 0c             	shr    $0xc,%edx
  801d57:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  801d5e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801d64:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d6b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d6f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d76:	00 
  801d77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d82:	e8 78 f3 ff ff       	call   8010ff <_Z12sys_page_mapiPviS_i>
  801d87:	89 c3                	mov    %eax,%ebx
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	79 25                	jns    801db2 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d9b:	e8 bd f3 ff ff       	call   80115d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801da0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801da4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dab:	e8 ad f3 ff ff       	call   80115d <_Z14sys_page_unmapiPv>
	return r;
  801db0:	eb 02                	jmp    801db4 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801db2:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801db4:	89 d8                	mov    %ebx,%eax
  801db6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801db9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801dbc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801dbf:	89 ec                	mov    %ebp,%esp
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801dc3:	89 34 24             	mov    %esi,(%esp)
  801dc6:	e8 8a fe ff ff       	call   801c55 <_Z5closei>

	ova = fd2data(oldfd);
  801dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dce:	89 04 24             	mov    %eax,(%esp)
  801dd1:	e8 16 fd ff ff       	call   801aec <_Z7fd2dataP2Fd>
  801dd6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ddb:	89 04 24             	mov    %eax,(%esp)
  801dde:	e8 09 fd ff ff       	call   801aec <_Z7fd2dataP2Fd>
  801de3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801de5:	89 d8                	mov    %ebx,%eax
  801de7:	c1 e8 16             	shr    $0x16,%eax
  801dea:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801df1:	a8 01                	test   $0x1,%al
  801df3:	0f 85 13 ff ff ff    	jne    801d0c <_Z3dupii+0x5c>
  801df9:	e9 51 ff ff ff       	jmp    801d4f <_Z3dupii+0x9f>

00801dfe <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	53                   	push   %ebx
  801e02:	83 ec 24             	sub    $0x24,%esp
  801e05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e08:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801e0f:	00 
  801e10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e17:	89 1c 24             	mov    %ebx,(%esp)
  801e1a:	e8 32 fc ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	78 5f                	js     801e82 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801e2d:	8b 00                	mov    (%eax),%eax
  801e2f:	89 04 24             	mov    %eax,(%esp)
  801e32:	e8 2b fd ff ff       	call   801b62 <_Z10dev_lookupiPP3Dev>
  801e37:	85 c0                	test   %eax,%eax
  801e39:	79 4d                	jns    801e88 <_Z4readiPvj+0x8a>
  801e3b:	eb 45                	jmp    801e82 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801e3d:	a1 00 74 80 00       	mov    0x807400,%eax
  801e42:	8b 40 04             	mov    0x4(%eax),%eax
  801e45:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	c7 04 24 d2 4d 80 00 	movl   $0x804dd2,(%esp)
  801e54:	e8 49 e7 ff ff       	call   8005a2 <_Z7cprintfPKcz>
		return -E_INVAL;
  801e59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e5e:	eb 22                	jmp    801e82 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801e66:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801e6b:	85 d2                	test   %edx,%edx
  801e6d:	74 13                	je     801e82 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7d:	89 0c 24             	mov    %ecx,(%esp)
  801e80:	ff d2                	call   *%edx
}
  801e82:	83 c4 24             	add    $0x24,%esp
  801e85:	5b                   	pop    %ebx
  801e86:	5d                   	pop    %ebp
  801e87:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801e88:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e8b:	8b 41 08             	mov    0x8(%ecx),%eax
  801e8e:	83 e0 03             	and    $0x3,%eax
  801e91:	83 f8 01             	cmp    $0x1,%eax
  801e94:	75 ca                	jne    801e60 <_Z4readiPvj+0x62>
  801e96:	eb a5                	jmp    801e3d <_Z4readiPvj+0x3f>

00801e98 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	57                   	push   %edi
  801e9c:	56                   	push   %esi
  801e9d:	53                   	push   %ebx
  801e9e:	83 ec 1c             	sub    $0x1c,%esp
  801ea1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ea4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801ea7:	85 f6                	test   %esi,%esi
  801ea9:	74 2f                	je     801eda <_Z5readniPvj+0x42>
  801eab:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801eb0:	89 f0                	mov    %esi,%eax
  801eb2:	29 d8                	sub    %ebx,%eax
  801eb4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eb8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801ebb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	89 04 24             	mov    %eax,(%esp)
  801ec5:	e8 34 ff ff ff       	call   801dfe <_Z4readiPvj>
		if (m < 0)
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	78 13                	js     801ee1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	74 0d                	je     801edf <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801ed2:	01 c3                	add    %eax,%ebx
  801ed4:	39 de                	cmp    %ebx,%esi
  801ed6:	77 d8                	ja     801eb0 <_Z5readniPvj+0x18>
  801ed8:	eb 05                	jmp    801edf <_Z5readniPvj+0x47>
  801eda:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801edf:	89 d8                	mov    %ebx,%eax
}
  801ee1:	83 c4 1c             	add    $0x1c,%esp
  801ee4:	5b                   	pop    %ebx
  801ee5:	5e                   	pop    %esi
  801ee6:	5f                   	pop    %edi
  801ee7:	5d                   	pop    %ebp
  801ee8:	c3                   	ret    

00801ee9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801eef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801ef6:	00 
  801ef7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801efa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	89 04 24             	mov    %eax,(%esp)
  801f04:	e8 48 fb ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	78 3c                	js     801f49 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801f17:	8b 00                	mov    (%eax),%eax
  801f19:	89 04 24             	mov    %eax,(%esp)
  801f1c:	e8 41 fc ff ff       	call   801b62 <_Z10dev_lookupiPP3Dev>
  801f21:	85 c0                	test   %eax,%eax
  801f23:	79 26                	jns    801f4b <_Z5writeiPKvj+0x62>
  801f25:	eb 22                	jmp    801f49 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  801f2d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  801f32:	85 c9                	test   %ecx,%ecx
  801f34:	74 13                	je     801f49 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801f36:	8b 45 10             	mov    0x10(%ebp),%eax
  801f39:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f44:	89 14 24             	mov    %edx,(%esp)
  801f47:	ff d1                	call   *%ecx
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801f4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  801f4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  801f53:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801f57:	74 f0                	je     801f49 <_Z5writeiPKvj+0x60>
  801f59:	eb cc                	jmp    801f27 <_Z5writeiPKvj+0x3e>

00801f5b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801f61:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801f68:	00 
  801f69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	89 04 24             	mov    %eax,(%esp)
  801f76:	e8 d6 fa ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	78 0e                	js     801f8d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f85:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	53                   	push   %ebx
  801f93:	83 ec 24             	sub    $0x24,%esp
  801f96:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801f99:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801fa0:	00 
  801fa1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa8:	89 1c 24             	mov    %ebx,(%esp)
  801fab:	e8 a1 fa ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	78 58                	js     80200c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801fbe:	8b 00                	mov    (%eax),%eax
  801fc0:	89 04 24             	mov    %eax,(%esp)
  801fc3:	e8 9a fb ff ff       	call   801b62 <_Z10dev_lookupiPP3Dev>
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	79 46                	jns    802012 <_Z9ftruncateii+0x83>
  801fcc:	eb 3e                	jmp    80200c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  801fce:	a1 00 74 80 00       	mov    0x807400,%eax
  801fd3:	8b 40 04             	mov    0x4(%eax),%eax
  801fd6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fda:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fde:	c7 04 24 10 4e 80 00 	movl   $0x804e10,(%esp)
  801fe5:	e8 b8 e5 ff ff       	call   8005a2 <_Z7cprintfPKcz>
		return -E_INVAL;
  801fea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fef:	eb 1b                	jmp    80200c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  801ff7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ffc:	85 d2                	test   %edx,%edx
  801ffe:	74 0c                	je     80200c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802000:	8b 45 0c             	mov    0xc(%ebp),%eax
  802003:	89 44 24 04          	mov    %eax,0x4(%esp)
  802007:	89 0c 24             	mov    %ecx,(%esp)
  80200a:	ff d2                	call   *%edx
}
  80200c:	83 c4 24             	add    $0x24,%esp
  80200f:	5b                   	pop    %ebx
  802010:	5d                   	pop    %ebp
  802011:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802012:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802015:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  802019:	75 d6                	jne    801ff1 <_Z9ftruncateii+0x62>
  80201b:	eb b1                	jmp    801fce <_Z9ftruncateii+0x3f>

0080201d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	53                   	push   %ebx
  802021:	83 ec 24             	sub    $0x24,%esp
  802024:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802027:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80202e:	00 
  80202f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802032:	89 44 24 04          	mov    %eax,0x4(%esp)
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	89 04 24             	mov    %eax,(%esp)
  80203c:	e8 10 fa ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  802041:	85 c0                	test   %eax,%eax
  802043:	78 3e                	js     802083 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802045:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802048:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80204f:	8b 00                	mov    (%eax),%eax
  802051:	89 04 24             	mov    %eax,(%esp)
  802054:	e8 09 fb ff ff       	call   801b62 <_Z10dev_lookupiPP3Dev>
  802059:	85 c0                	test   %eax,%eax
  80205b:	79 2c                	jns    802089 <_Z5fstatiP4Stat+0x6c>
  80205d:	eb 24                	jmp    802083 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80205f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802062:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  802069:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  802070:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802076:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207d:	89 04 24             	mov    %eax,(%esp)
  802080:	ff 52 14             	call   *0x14(%edx)
}
  802083:	83 c4 24             	add    $0x24,%esp
  802086:	5b                   	pop    %ebx
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802089:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80208c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802091:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  802095:	75 c8                	jne    80205f <_Z5fstatiP4Stat+0x42>
  802097:	eb ea                	jmp    802083 <_Z5fstatiP4Stat+0x66>

00802099 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 18             	sub    $0x18,%esp
  80209f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8020a2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8020a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020ac:	00 
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	89 04 24             	mov    %eax,(%esp)
  8020b3:	e8 d6 09 00 00       	call   802a8e <_Z4openPKci>
  8020b8:	89 c3                	mov    %eax,%ebx
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	78 1b                	js     8020d9 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8020be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c5:	89 1c 24             	mov    %ebx,(%esp)
  8020c8:	e8 50 ff ff ff       	call   80201d <_Z5fstatiP4Stat>
  8020cd:	89 c6                	mov    %eax,%esi
	close(fd);
  8020cf:	89 1c 24             	mov    %ebx,(%esp)
  8020d2:	e8 7e fb ff ff       	call   801c55 <_Z5closei>
	return r;
  8020d7:	89 f3                	mov    %esi,%ebx
}
  8020d9:	89 d8                	mov    %ebx,%eax
  8020db:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8020de:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8020e1:	89 ec                	mov    %ebp,%esp
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    
	...

008020f0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8020f3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8020f8:	85 d2                	test   %edx,%edx
  8020fa:	78 33                	js     80212f <_ZL10inode_dataP5Inodei+0x3f>
  8020fc:	3b 50 08             	cmp    0x8(%eax),%edx
  8020ff:	7d 2e                	jge    80212f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  802101:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802107:	85 d2                	test   %edx,%edx
  802109:	0f 49 ca             	cmovns %edx,%ecx
  80210c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  80210f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  802113:	c1 e1 0c             	shl    $0xc,%ecx
  802116:	89 d0                	mov    %edx,%eax
  802118:	c1 f8 1f             	sar    $0x1f,%eax
  80211b:	c1 e8 14             	shr    $0x14,%eax
  80211e:	01 c2                	add    %eax,%edx
  802120:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802126:	29 c2                	sub    %eax,%edx
  802128:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  80212f:	89 c8                	mov    %ecx,%eax
  802131:	5d                   	pop    %ebp
  802132:	c3                   	ret    

00802133 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  802136:	8b 48 08             	mov    0x8(%eax),%ecx
  802139:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  80213c:	8b 00                	mov    (%eax),%eax
  80213e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  802141:	c7 82 80 00 00 00 04 	movl   $0x806004,0x80(%edx)
  802148:	60 80 00 
}
  80214b:	5d                   	pop    %ebp
  80214c:	c3                   	ret    

0080214d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802153:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  802159:	85 c0                	test   %eax,%eax
  80215b:	74 08                	je     802165 <_ZL9get_inodei+0x18>
  80215d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802163:	7e 20                	jle    802185 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  802165:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802169:	c7 44 24 08 48 4e 80 	movl   $0x804e48,0x8(%esp)
  802170:	00 
  802171:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  802178:	00 
  802179:	c7 04 24 5e 4e 80 00 	movl   $0x804e5e,(%esp)
  802180:	e8 ff e2 ff ff       	call   800484 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802185:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80218b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802191:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802197:	85 d2                	test   %edx,%edx
  802199:	0f 48 d1             	cmovs  %ecx,%edx
  80219c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  80219f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  8021a6:	c1 e0 0c             	shl    $0xc,%eax
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	56                   	push   %esi
  8021af:	53                   	push   %ebx
  8021b0:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  8021b3:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  8021b9:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  8021bc:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  8021c2:	76 20                	jbe    8021e4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  8021c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021c8:	c7 44 24 08 84 4e 80 	movl   $0x804e84,0x8(%esp)
  8021cf:	00 
  8021d0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8021d7:	00 
  8021d8:	c7 04 24 5e 4e 80 00 	movl   $0x804e5e,(%esp)
  8021df:	e8 a0 e2 ff ff       	call   800484 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  8021e4:	83 fe 01             	cmp    $0x1,%esi
  8021e7:	7e 08                	jle    8021f1 <_ZL10bcache_ipcPvi+0x46>
  8021e9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  8021ef:	7d 12                	jge    802203 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8021f1:	89 f3                	mov    %esi,%ebx
  8021f3:	c1 e3 04             	shl    $0x4,%ebx
  8021f6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8021f8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  8021fe:	c1 e6 0c             	shl    $0xc,%esi
  802201:	eb 20                	jmp    802223 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  802203:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802207:	c7 44 24 08 b4 4e 80 	movl   $0x804eb4,0x8(%esp)
  80220e:	00 
  80220f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802216:	00 
  802217:	c7 04 24 5e 4e 80 00 	movl   $0x804e5e,(%esp)
  80221e:	e8 61 e2 ff ff       	call   800484 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802223:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80222a:	00 
  80222b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802232:	00 
  802233:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802237:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  80223e:	e8 3c 22 00 00       	call   80447f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802243:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80224a:	00 
  80224b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80224f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802256:	e8 95 21 00 00       	call   8043f0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  80225b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80225e:	74 c3                	je     802223 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  802260:	83 c4 10             	add    $0x10,%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5d                   	pop    %ebp
  802266:	c3                   	ret    

00802267 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
  80226a:	83 ec 28             	sub    $0x28,%esp
  80226d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802270:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802273:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802276:	89 c7                	mov    %eax,%edi
  802278:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  80227a:	c7 04 24 0d 25 80 00 	movl   $0x80250d,(%esp)
  802281:	e8 75 20 00 00       	call   8042fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  802286:	89 f8                	mov    %edi,%eax
  802288:	e8 c0 fe ff ff       	call   80214d <_ZL9get_inodei>
  80228d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  80228f:	ba 02 00 00 00       	mov    $0x2,%edx
  802294:	e8 12 ff ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
	if (r < 0) {
  802299:	85 c0                	test   %eax,%eax
  80229b:	79 08                	jns    8022a5 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  80229d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  8022a3:	eb 2e                	jmp    8022d3 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	75 1c                	jne    8022c5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  8022a9:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  8022af:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  8022b6:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  8022b9:	ba 06 00 00 00       	mov    $0x6,%edx
  8022be:	89 d8                	mov    %ebx,%eax
  8022c0:	e8 e6 fe ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  8022c5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  8022cc:	89 1e                	mov    %ebx,(%esi)
	return 0;
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8022d6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8022d9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8022dc:	89 ec                	mov    %ebp,%esp
  8022de:	5d                   	pop    %ebp
  8022df:	c3                   	ret    

008022e0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	57                   	push   %edi
  8022e4:	56                   	push   %esi
  8022e5:	53                   	push   %ebx
  8022e6:	83 ec 2c             	sub    $0x2c,%esp
  8022e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8022ec:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  8022ef:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  8022f4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  8022fa:	0f 87 3d 01 00 00    	ja     80243d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  802300:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802303:	8b 42 08             	mov    0x8(%edx),%eax
  802306:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  80230c:	85 c0                	test   %eax,%eax
  80230e:	0f 49 f0             	cmovns %eax,%esi
  802311:	c1 fe 0c             	sar    $0xc,%esi
  802314:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  802316:	8b 7d d8             	mov    -0x28(%ebp),%edi
  802319:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  80231f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  802322:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802325:	0f 82 a6 00 00 00    	jb     8023d1 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  80232b:	39 fe                	cmp    %edi,%esi
  80232d:	0f 8d f2 00 00 00    	jge    802425 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802333:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  802337:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80233a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80233d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  802340:	83 3e 00             	cmpl   $0x0,(%esi)
  802343:	75 77                	jne    8023bc <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802345:	ba 02 00 00 00       	mov    $0x2,%edx
  80234a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80234f:	e8 57 fe ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802354:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  80235a:	83 f9 02             	cmp    $0x2,%ecx
  80235d:	7e 43                	jle    8023a2 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  80235f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802364:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  802369:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802370:	74 29                	je     80239b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802372:	e9 ce 00 00 00       	jmp    802445 <_ZL14inode_set_sizeP5Inodej+0x165>
  802377:	89 c7                	mov    %eax,%edi
  802379:	0f b6 10             	movzbl (%eax),%edx
  80237c:	83 c0 01             	add    $0x1,%eax
  80237f:	84 d2                	test   %dl,%dl
  802381:	74 18                	je     80239b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802383:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802386:	ba 05 00 00 00       	mov    $0x5,%edx
  80238b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802390:	e8 16 fe ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802395:	85 db                	test   %ebx,%ebx
  802397:	79 1e                	jns    8023b7 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802399:	eb 07                	jmp    8023a2 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80239b:	83 c3 01             	add    $0x1,%ebx
  80239e:	39 d9                	cmp    %ebx,%ecx
  8023a0:	7f d5                	jg     802377 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  8023a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023a5:	8b 50 08             	mov    0x8(%eax),%edx
  8023a8:	e8 33 ff ff ff       	call   8022e0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  8023ad:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8023b2:	e9 86 00 00 00       	jmp    80243d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  8023b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023ba:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  8023bc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  8023c0:	83 c6 04             	add    $0x4,%esi
  8023c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8023c9:	0f 8f 6e ff ff ff    	jg     80233d <_ZL14inode_set_sizeP5Inodej+0x5d>
  8023cf:	eb 54                	jmp    802425 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  8023d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023d4:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  8023d9:	83 f8 01             	cmp    $0x1,%eax
  8023dc:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8023df:	ba 02 00 00 00       	mov    $0x2,%edx
  8023e4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8023e9:	e8 bd fd ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  8023ee:	39 f7                	cmp    %esi,%edi
  8023f0:	7d 24                	jge    802416 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8023f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023f5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  8023f9:	8b 10                	mov    (%eax),%edx
  8023fb:	85 d2                	test   %edx,%edx
  8023fd:	74 0d                	je     80240c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  8023ff:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  802406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  80240c:	83 eb 01             	sub    $0x1,%ebx
  80240f:	83 e8 04             	sub    $0x4,%eax
  802412:	39 fb                	cmp    %edi,%ebx
  802414:	75 e3                	jne    8023f9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802416:	ba 05 00 00 00       	mov    $0x5,%edx
  80241b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802420:	e8 86 fd ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  802425:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80242b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  80242e:	ba 04 00 00 00       	mov    $0x4,%edx
  802433:	e8 73 fd ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
	return 0;
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243d:	83 c4 2c             	add    $0x2c,%esp
  802440:	5b                   	pop    %ebx
  802441:	5e                   	pop    %esi
  802442:	5f                   	pop    %edi
  802443:	5d                   	pop    %ebp
  802444:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802445:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  80244c:	ba 05 00 00 00       	mov    $0x5,%edx
  802451:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802456:	e8 50 fd ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80245b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802460:	e9 52 ff ff ff       	jmp    8023b7 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802465 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	53                   	push   %ebx
  802469:	83 ec 04             	sub    $0x4,%esp
  80246c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  80246e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802474:	83 e8 01             	sub    $0x1,%eax
  802477:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  80247d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802481:	75 40                	jne    8024c3 <_ZL11inode_closeP5Inode+0x5e>
  802483:	85 c0                	test   %eax,%eax
  802485:	75 3c                	jne    8024c3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802487:	ba 02 00 00 00       	mov    $0x2,%edx
  80248c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802491:	e8 15 fd ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  80249b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  80249f:	85 d2                	test   %edx,%edx
  8024a1:	74 07                	je     8024aa <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  8024a3:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  8024aa:	83 c0 01             	add    $0x1,%eax
  8024ad:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  8024b2:	75 e7                	jne    80249b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8024b4:	ba 05 00 00 00       	mov    $0x5,%edx
  8024b9:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8024be:	e8 e8 fc ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  8024c3:	ba 03 00 00 00       	mov    $0x3,%edx
  8024c8:	89 d8                	mov    %ebx,%eax
  8024ca:	e8 dc fc ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
}
  8024cf:	83 c4 04             	add    $0x4,%esp
  8024d2:	5b                   	pop    %ebx
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    

008024d5 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	53                   	push   %ebx
  8024d9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024e5:	e8 7d fd ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  8024ea:	89 c3                	mov    %eax,%ebx
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	78 15                	js     802505 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  8024f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	e8 e5 fd ff ff       	call   8022e0 <_ZL14inode_set_sizeP5Inodej>
  8024fb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	e8 60 ff ff ff       	call   802465 <_ZL11inode_closeP5Inode>
	return r;
}
  802505:	89 d8                	mov    %ebx,%eax
  802507:	83 c4 14             	add    $0x14,%esp
  80250a:	5b                   	pop    %ebx
  80250b:	5d                   	pop    %ebp
  80250c:	c3                   	ret    

0080250d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
  802510:	53                   	push   %ebx
  802511:	83 ec 14             	sub    $0x14,%esp
  802514:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  802517:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  802519:	89 c2                	mov    %eax,%edx
  80251b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  802521:	78 32                	js     802555 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  802523:	ba 00 00 00 00       	mov    $0x0,%edx
  802528:	e8 7e fc ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
  80252d:	85 c0                	test   %eax,%eax
  80252f:	74 1c                	je     80254d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  802531:	c7 44 24 08 69 4e 80 	movl   $0x804e69,0x8(%esp)
  802538:	00 
  802539:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802540:	00 
  802541:	c7 04 24 5e 4e 80 00 	movl   $0x804e5e,(%esp)
  802548:	e8 37 df ff ff       	call   800484 <_Z6_panicPKciS0_z>
    resume(utf);
  80254d:	89 1c 24             	mov    %ebx,(%esp)
  802550:	e8 7b 1e 00 00       	call   8043d0 <resume>
}
  802555:	83 c4 14             	add    $0x14,%esp
  802558:	5b                   	pop    %ebx
  802559:	5d                   	pop    %ebp
  80255a:	c3                   	ret    

0080255b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	83 ec 28             	sub    $0x28,%esp
  802561:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802564:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80256a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80256d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802570:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802573:	e8 ef fc ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  802578:	85 c0                	test   %eax,%eax
  80257a:	78 26                	js     8025a2 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80257c:	83 c3 10             	add    $0x10,%ebx
  80257f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802583:	89 34 24             	mov    %esi,(%esp)
  802586:	e8 2f e6 ff ff       	call   800bba <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80258b:	89 f2                	mov    %esi,%edx
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	e8 9e fb ff ff       	call   802133 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	e8 c8 fe ff ff       	call   802465 <_ZL11inode_closeP5Inode>
	return 0;
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025a5:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025a8:	89 ec                	mov    %ebp,%esp
  8025aa:	5d                   	pop    %ebp
  8025ab:	c3                   	ret    

008025ac <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	53                   	push   %ebx
  8025b0:	83 ec 24             	sub    $0x24,%esp
  8025b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8025b6:	89 1c 24             	mov    %ebx,(%esp)
  8025b9:	e8 9e 15 00 00       	call   803b5c <_Z7pagerefPv>
  8025be:	89 c2                	mov    %eax,%edx
        return 0;
  8025c0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8025c5:	83 fa 01             	cmp    $0x1,%edx
  8025c8:	7f 1e                	jg     8025e8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8025ca:	8b 43 0c             	mov    0xc(%ebx),%eax
  8025cd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025d0:	e8 92 fc ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	78 0f                	js     8025e8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  8025e3:	e8 7d fe ff ff       	call   802465 <_ZL11inode_closeP5Inode>
}
  8025e8:	83 c4 24             	add    $0x24,%esp
  8025eb:	5b                   	pop    %ebx
  8025ec:	5d                   	pop    %ebp
  8025ed:	c3                   	ret    

008025ee <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
  8025f1:	57                   	push   %edi
  8025f2:	56                   	push   %esi
  8025f3:	53                   	push   %ebx
  8025f4:	83 ec 3c             	sub    $0x3c,%esp
  8025f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8025fa:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  8025fd:	8b 43 04             	mov    0x4(%ebx),%eax
  802600:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802603:	8b 43 0c             	mov    0xc(%ebx),%eax
  802606:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802609:	e8 59 fc ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  80260e:	85 c0                	test   %eax,%eax
  802610:	0f 88 8c 00 00 00    	js     8026a2 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802616:	8b 53 04             	mov    0x4(%ebx),%edx
  802619:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  80261f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802625:	29 d7                	sub    %edx,%edi
  802627:	39 f7                	cmp    %esi,%edi
  802629:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  80262c:	85 ff                	test   %edi,%edi
  80262e:	74 16                	je     802646 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802630:	8d 14 17             	lea    (%edi,%edx,1),%edx
  802633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802636:	3b 50 08             	cmp    0x8(%eax),%edx
  802639:	76 6f                	jbe    8026aa <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80263b:	e8 a0 fc ff ff       	call   8022e0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802640:	85 c0                	test   %eax,%eax
  802642:	79 66                	jns    8026aa <_ZL13devfile_writeP2FdPKvj+0xbc>
  802644:	eb 4e                	jmp    802694 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802646:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80264c:	76 24                	jbe    802672 <_ZL13devfile_writeP2FdPKvj+0x84>
  80264e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802650:	8b 53 04             	mov    0x4(%ebx),%edx
  802653:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265c:	3b 50 08             	cmp    0x8(%eax),%edx
  80265f:	0f 86 83 00 00 00    	jbe    8026e8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802665:	e8 76 fc ff ff       	call   8022e0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80266a:	85 c0                	test   %eax,%eax
  80266c:	79 7a                	jns    8026e8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80266e:	66 90                	xchg   %ax,%ax
  802670:	eb 22                	jmp    802694 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802672:	85 f6                	test   %esi,%esi
  802674:	74 1e                	je     802694 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802676:	89 f2                	mov    %esi,%edx
  802678:	03 53 04             	add    0x4(%ebx),%edx
  80267b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267e:	3b 50 08             	cmp    0x8(%eax),%edx
  802681:	0f 86 b8 00 00 00    	jbe    80273f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802687:	e8 54 fc ff ff       	call   8022e0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80268c:	85 c0                	test   %eax,%eax
  80268e:	0f 89 ab 00 00 00    	jns    80273f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802697:	e8 c9 fd ff ff       	call   802465 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80269c:	8b 43 04             	mov    0x4(%ebx),%eax
  80269f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  8026a2:	83 c4 3c             	add    $0x3c,%esp
  8026a5:	5b                   	pop    %ebx
  8026a6:	5e                   	pop    %esi
  8026a7:	5f                   	pop    %edi
  8026a8:	5d                   	pop    %ebp
  8026a9:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  8026aa:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8026ac:	8b 53 04             	mov    0x4(%ebx),%edx
  8026af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b2:	e8 39 fa ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
  8026b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  8026ba:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026c8:	89 04 24             	mov    %eax,(%esp)
  8026cb:	e8 07 e7 ff ff       	call   800dd7 <memcpy>
        fd->fd_offset += n2;
  8026d0:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  8026d3:	ba 04 00 00 00       	mov    $0x4,%edx
  8026d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026db:	e8 cb fa ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  8026e0:	01 7d 0c             	add    %edi,0xc(%ebp)
  8026e3:	e9 5e ff ff ff       	jmp    802646 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8026e8:	8b 53 04             	mov    0x4(%ebx),%edx
  8026eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ee:	e8 fd f9 ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
  8026f3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  8026f5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8026fc:	00 
  8026fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802700:	89 44 24 04          	mov    %eax,0x4(%esp)
  802704:	89 34 24             	mov    %esi,(%esp)
  802707:	e8 cb e6 ff ff       	call   800dd7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80270c:	ba 04 00 00 00       	mov    $0x4,%edx
  802711:	89 f0                	mov    %esi,%eax
  802713:	e8 93 fa ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  802718:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  80271e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802725:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80272c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802732:	0f 87 18 ff ff ff    	ja     802650 <_ZL13devfile_writeP2FdPKvj+0x62>
  802738:	89 fe                	mov    %edi,%esi
  80273a:	e9 33 ff ff ff       	jmp    802672 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80273f:	8b 53 04             	mov    0x4(%ebx),%edx
  802742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802745:	e8 a6 f9 ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
  80274a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80274c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802750:	8b 45 0c             	mov    0xc(%ebp),%eax
  802753:	89 44 24 04          	mov    %eax,0x4(%esp)
  802757:	89 3c 24             	mov    %edi,(%esp)
  80275a:	e8 78 e6 ff ff       	call   800dd7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80275f:	ba 04 00 00 00       	mov    $0x4,%edx
  802764:	89 f8                	mov    %edi,%eax
  802766:	e8 40 fa ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80276b:	01 73 04             	add    %esi,0x4(%ebx)
  80276e:	e9 21 ff ff ff       	jmp    802694 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802773 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	57                   	push   %edi
  802777:	56                   	push   %esi
  802778:	53                   	push   %ebx
  802779:	83 ec 3c             	sub    $0x3c,%esp
  80277c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80277f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802782:	8b 43 04             	mov    0x4(%ebx),%eax
  802785:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802788:	8b 43 0c             	mov    0xc(%ebx),%eax
  80278b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80278e:	e8 d4 fa ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  802793:	85 c0                	test   %eax,%eax
  802795:	0f 88 d3 00 00 00    	js     80286e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80279b:	8b 73 04             	mov    0x4(%ebx),%esi
  80279e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a1:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  8027a4:	8b 50 08             	mov    0x8(%eax),%edx
  8027a7:	29 f2                	sub    %esi,%edx
  8027a9:	3b 48 08             	cmp    0x8(%eax),%ecx
  8027ac:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  8027af:	89 f2                	mov    %esi,%edx
  8027b1:	e8 3a f9 ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	0f 84 a2 00 00 00    	je     802860 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8027be:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  8027c4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8027ca:	29 f2                	sub    %esi,%edx
  8027cc:	39 d7                	cmp    %edx,%edi
  8027ce:	0f 46 d7             	cmovbe %edi,%edx
  8027d1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  8027d4:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  8027d6:	01 d6                	add    %edx,%esi
  8027d8:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  8027db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e6:	89 04 24             	mov    %eax,(%esp)
  8027e9:	e8 e9 e5 ff ff       	call   800dd7 <memcpy>
    buf = (void *)((char *)buf + n2);
  8027ee:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027f1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8027f4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8027fa:	76 3e                	jbe    80283a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8027fc:	8b 53 04             	mov    0x4(%ebx),%edx
  8027ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802802:	e8 e9 f8 ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
  802807:	85 c0                	test   %eax,%eax
  802809:	74 55                	je     802860 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  80280b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802812:	00 
  802813:	89 44 24 04          	mov    %eax,0x4(%esp)
  802817:	89 34 24             	mov    %esi,(%esp)
  80281a:	e8 b8 e5 ff ff       	call   800dd7 <memcpy>
        n -= PGSIZE;
  80281f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802825:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80282b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802832:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802838:	77 c2                	ja     8027fc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80283a:	85 ff                	test   %edi,%edi
  80283c:	74 22                	je     802860 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80283e:	8b 53 04             	mov    0x4(%ebx),%edx
  802841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802844:	e8 a7 f8 ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
  802849:	85 c0                	test   %eax,%eax
  80284b:	74 13                	je     802860 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80284d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802851:	89 44 24 04          	mov    %eax,0x4(%esp)
  802855:	89 34 24             	mov    %esi,(%esp)
  802858:	e8 7a e5 ff ff       	call   800dd7 <memcpy>
        fd->fd_offset += n;
  80285d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802863:	e8 fd fb ff ff       	call   802465 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802868:	8b 43 04             	mov    0x4(%ebx),%eax
  80286b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80286e:	83 c4 3c             	add    $0x3c,%esp
  802871:	5b                   	pop    %ebx
  802872:	5e                   	pop    %esi
  802873:	5f                   	pop    %edi
  802874:	5d                   	pop    %ebp
  802875:	c3                   	ret    

00802876 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
  802879:	57                   	push   %edi
  80287a:	56                   	push   %esi
  80287b:	53                   	push   %ebx
  80287c:	83 ec 4c             	sub    $0x4c,%esp
  80287f:	89 c6                	mov    %eax,%esi
  802881:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802884:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802887:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80288d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802896:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802899:	b8 01 00 00 00       	mov    $0x1,%eax
  80289e:	e8 c4 f9 ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  8028a3:	89 c7                	mov    %eax,%edi
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	0f 88 cd 01 00 00    	js     802a7a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8028ad:	89 f3                	mov    %esi,%ebx
  8028af:	80 3e 2f             	cmpb   $0x2f,(%esi)
  8028b2:	75 08                	jne    8028bc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  8028b4:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  8028b7:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8028ba:	74 f8                	je     8028b4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8028bc:	0f b6 03             	movzbl (%ebx),%eax
  8028bf:	3c 2f                	cmp    $0x2f,%al
  8028c1:	74 16                	je     8028d9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8028c3:	84 c0                	test   %al,%al
  8028c5:	74 12                	je     8028d9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8028c7:	89 da                	mov    %ebx,%edx
		++path;
  8028c9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8028cc:	0f b6 02             	movzbl (%edx),%eax
  8028cf:	3c 2f                	cmp    $0x2f,%al
  8028d1:	74 08                	je     8028db <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8028d3:	84 c0                	test   %al,%al
  8028d5:	75 f2                	jne    8028c9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  8028d7:	eb 02                	jmp    8028db <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8028d9:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  8028db:	89 d0                	mov    %edx,%eax
  8028dd:	29 d8                	sub    %ebx,%eax
  8028df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  8028e2:	0f b6 02             	movzbl (%edx),%eax
  8028e5:	89 d6                	mov    %edx,%esi
  8028e7:	3c 2f                	cmp    $0x2f,%al
  8028e9:	75 0a                	jne    8028f5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  8028eb:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  8028ee:	0f b6 06             	movzbl (%esi),%eax
  8028f1:	3c 2f                	cmp    $0x2f,%al
  8028f3:	74 f6                	je     8028eb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8028f5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8028f9:	75 1b                	jne    802916 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8028fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fe:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802901:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802903:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802906:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  80290c:	bf 00 00 00 00       	mov    $0x0,%edi
  802911:	e9 64 01 00 00       	jmp    802a7a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802916:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  80291a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291e:	74 06                	je     802926 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802920:	84 c0                	test   %al,%al
  802922:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802926:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802929:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  80292c:	83 3a 02             	cmpl   $0x2,(%edx)
  80292f:	0f 85 f4 00 00 00    	jne    802a29 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802935:	89 d0                	mov    %edx,%eax
  802937:	8b 52 08             	mov    0x8(%edx),%edx
  80293a:	85 d2                	test   %edx,%edx
  80293c:	7e 78                	jle    8029b6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80293e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802945:	bf 00 00 00 00       	mov    $0x0,%edi
  80294a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80294d:	89 fb                	mov    %edi,%ebx
  80294f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802952:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802954:	89 da                	mov    %ebx,%edx
  802956:	89 f0                	mov    %esi,%eax
  802958:	e8 93 f7 ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
  80295d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80295f:	83 38 00             	cmpl   $0x0,(%eax)
  802962:	74 26                	je     80298a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802964:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802967:	3b 50 04             	cmp    0x4(%eax),%edx
  80296a:	75 33                	jne    80299f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80296c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802970:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802973:	89 44 24 04          	mov    %eax,0x4(%esp)
  802977:	8d 47 08             	lea    0x8(%edi),%eax
  80297a:	89 04 24             	mov    %eax,(%esp)
  80297d:	e8 96 e4 ff ff       	call   800e18 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802982:	85 c0                	test   %eax,%eax
  802984:	0f 84 fa 00 00 00    	je     802a84 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80298a:	83 3f 00             	cmpl   $0x0,(%edi)
  80298d:	75 10                	jne    80299f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80298f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802993:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802996:	84 c0                	test   %al,%al
  802998:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80299c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80299f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  8029a5:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  8029a7:	8b 56 08             	mov    0x8(%esi),%edx
  8029aa:	39 d0                	cmp    %edx,%eax
  8029ac:	7c a6                	jl     802954 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  8029ae:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8029b1:	8b 75 c0             	mov    -0x40(%ebp),%esi
  8029b4:	eb 07                	jmp    8029bd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  8029b6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  8029bd:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  8029c1:	74 6d                	je     802a30 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  8029c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029c7:	75 24                	jne    8029ed <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  8029c9:	83 ea 80             	sub    $0xffffff80,%edx
  8029cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029cf:	e8 0c f9 ff ff       	call   8022e0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	0f 88 90 00 00 00    	js     802a6c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  8029dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029df:	8b 50 08             	mov    0x8(%eax),%edx
  8029e2:	83 c2 80             	add    $0xffffff80,%edx
  8029e5:	e8 06 f7 ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
  8029ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  8029ed:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8029f4:	00 
  8029f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8029fc:	00 
  8029fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a00:	89 14 24             	mov    %edx,(%esp)
  802a03:	e8 f9 e2 ff ff       	call   800d01 <memset>
	empty->de_namelen = namelen;
  802a08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802a11:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a15:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a19:	83 c0 08             	add    $0x8,%eax
  802a1c:	89 04 24             	mov    %eax,(%esp)
  802a1f:	e8 b3 e3 ff ff       	call   800dd7 <memcpy>
	*de_store = empty;
  802a24:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802a27:	eb 5e                	jmp    802a87 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802a29:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  802a2e:	eb 42                	jmp    802a72 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802a30:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802a35:	eb 3b                	jmp    802a72 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802a3d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  802a3f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a42:	89 38                	mov    %edi,(%eax)
			return 0;
  802a44:	bf 00 00 00 00       	mov    $0x0,%edi
  802a49:	eb 2f                	jmp    802a7a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  802a4b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802a4e:	8b 07                	mov    (%edi),%eax
  802a50:	e8 12 f8 ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  802a55:	85 c0                	test   %eax,%eax
  802a57:	78 17                	js     802a70 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802a59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5c:	e8 04 fa ff ff       	call   802465 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802a67:	e9 41 fe ff ff       	jmp    8028ad <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  802a6c:	89 c7                	mov    %eax,%edi
  802a6e:	eb 02                	jmp    802a72 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802a70:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802a72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a75:	e8 eb f9 ff ff       	call   802465 <_ZL11inode_closeP5Inode>
	return r;
}
  802a7a:	89 f8                	mov    %edi,%eax
  802a7c:	83 c4 4c             	add    $0x4c,%esp
  802a7f:	5b                   	pop    %ebx
  802a80:	5e                   	pop    %esi
  802a81:	5f                   	pop    %edi
  802a82:	5d                   	pop    %ebp
  802a83:	c3                   	ret    
  802a84:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802a87:	80 3e 00             	cmpb   $0x0,(%esi)
  802a8a:	75 bf                	jne    802a4b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  802a8c:	eb a9                	jmp    802a37 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

00802a8e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  802a8e:	55                   	push   %ebp
  802a8f:	89 e5                	mov    %esp,%ebp
  802a91:	57                   	push   %edi
  802a92:	56                   	push   %esi
  802a93:	53                   	push   %ebx
  802a94:	83 ec 3c             	sub    $0x3c,%esp
  802a97:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  802a9a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802a9d:	89 04 24             	mov    %eax,(%esp)
  802aa0:	e8 62 f0 ff ff       	call   801b07 <_Z14fd_find_unusedPP2Fd>
  802aa5:	89 c3                	mov    %eax,%ebx
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	0f 88 16 02 00 00    	js     802cc5 <_Z4openPKci+0x237>
  802aaf:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ab6:	00 
  802ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aba:	89 44 24 04          	mov    %eax,0x4(%esp)
  802abe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ac5:	e8 d6 e5 ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  802aca:	89 c3                	mov    %eax,%ebx
  802acc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad1:	85 db                	test   %ebx,%ebx
  802ad3:	0f 88 ec 01 00 00    	js     802cc5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802ad9:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  802add:	0f 84 ec 01 00 00    	je     802ccf <_Z4openPKci+0x241>
  802ae3:	83 c0 01             	add    $0x1,%eax
  802ae6:	83 f8 78             	cmp    $0x78,%eax
  802ae9:	75 ee                	jne    802ad9 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802aeb:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802af0:	e9 b9 01 00 00       	jmp    802cae <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802af5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802af8:	81 e7 00 01 00 00    	and    $0x100,%edi
  802afe:	89 3c 24             	mov    %edi,(%esp)
  802b01:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802b04:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802b07:	89 f0                	mov    %esi,%eax
  802b09:	e8 68 fd ff ff       	call   802876 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802b0e:	89 c3                	mov    %eax,%ebx
  802b10:	85 c0                	test   %eax,%eax
  802b12:	0f 85 96 01 00 00    	jne    802cae <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802b18:	85 ff                	test   %edi,%edi
  802b1a:	75 41                	jne    802b5d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  802b1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b1f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802b24:	75 08                	jne    802b2e <_Z4openPKci+0xa0>
            fileino = dirino;
  802b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b29:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802b2c:	eb 14                	jmp    802b42 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  802b2e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802b31:	8b 00                	mov    (%eax),%eax
  802b33:	e8 2f f7 ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  802b38:	89 c3                	mov    %eax,%ebx
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	0f 88 5d 01 00 00    	js     802c9f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802b42:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b45:	83 38 02             	cmpl   $0x2,(%eax)
  802b48:	0f 85 d2 00 00 00    	jne    802c20 <_Z4openPKci+0x192>
  802b4e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802b52:	0f 84 c8 00 00 00    	je     802c20 <_Z4openPKci+0x192>
  802b58:	e9 38 01 00 00       	jmp    802c95 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  802b5d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802b64:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  802b6b:	0f 8e a8 00 00 00    	jle    802c19 <_Z4openPKci+0x18b>
  802b71:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802b76:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802b79:	89 f8                	mov    %edi,%eax
  802b7b:	e8 e7 f6 ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  802b80:	89 c3                	mov    %eax,%ebx
  802b82:	85 c0                	test   %eax,%eax
  802b84:	0f 88 15 01 00 00    	js     802c9f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  802b8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802b8d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802b91:	75 68                	jne    802bfb <_Z4openPKci+0x16d>
  802b93:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  802b9a:	75 5f                	jne    802bfb <_Z4openPKci+0x16d>
			*ino_store = ino;
  802b9c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  802b9f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802ba5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ba8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  802baf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802bb6:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  802bbd:	00 
  802bbe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802bc5:	00 
  802bc6:	83 c0 0c             	add    $0xc,%eax
  802bc9:	89 04 24             	mov    %eax,(%esp)
  802bcc:	e8 30 e1 ff ff       	call   800d01 <memset>
        de->de_inum = fileino->i_inum;
  802bd1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bd4:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  802bda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bdd:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  802bdf:	ba 04 00 00 00       	mov    $0x4,%edx
  802be4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802be7:	e8 bf f5 ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  802bec:	ba 04 00 00 00       	mov    $0x4,%edx
  802bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf4:	e8 b2 f5 ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
  802bf9:	eb 25                	jmp    802c20 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  802bfb:	e8 65 f8 ff ff       	call   802465 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802c00:	83 c7 01             	add    $0x1,%edi
  802c03:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802c09:	0f 8c 67 ff ff ff    	jl     802b76 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  802c0f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802c14:	e9 86 00 00 00       	jmp    802c9f <_Z4openPKci+0x211>
  802c19:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802c1e:	eb 7f                	jmp    802c9f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802c20:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802c27:	74 0d                	je     802c36 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802c29:	ba 00 00 00 00       	mov    $0x0,%edx
  802c2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c31:	e8 aa f6 ff ff       	call   8022e0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802c36:	8b 15 04 60 80 00    	mov    0x806004,%edx
  802c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  802c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c4e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802c51:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c54:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  802c5a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  802c5d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c61:	83 c0 10             	add    $0x10,%eax
  802c64:	89 04 24             	mov    %eax,(%esp)
  802c67:	e8 4e df ff ff       	call   800bba <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  802c6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c6f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802c76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c79:	e8 e7 f7 ff ff       	call   802465 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  802c7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c81:	e8 df f7 ff ff       	call   802465 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c89:	89 04 24             	mov    %eax,(%esp)
  802c8c:	e8 13 ee ff ff       	call   801aa4 <_Z6fd2numP2Fd>
  802c91:	89 c3                	mov    %eax,%ebx
  802c93:	eb 30                	jmp    802cc5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802c95:	e8 cb f7 ff ff       	call   802465 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  802c9a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  802c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca2:	e8 be f7 ff ff       	call   802465 <_ZL11inode_closeP5Inode>
  802ca7:	eb 05                	jmp    802cae <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802ca9:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  802cae:	a1 00 74 80 00       	mov    0x807400,%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cb9:	89 54 24 04          	mov    %edx,0x4(%esp)
  802cbd:	89 04 24             	mov    %eax,(%esp)
  802cc0:	e8 98 e4 ff ff       	call   80115d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802cc5:	89 d8                	mov    %ebx,%eax
  802cc7:	83 c4 3c             	add    $0x3c,%esp
  802cca:	5b                   	pop    %ebx
  802ccb:	5e                   	pop    %esi
  802ccc:	5f                   	pop    %edi
  802ccd:	5d                   	pop    %ebp
  802cce:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  802ccf:	83 f8 78             	cmp    $0x78,%eax
  802cd2:	0f 85 1d fe ff ff    	jne    802af5 <_Z4openPKci+0x67>
  802cd8:	eb cf                	jmp    802ca9 <_Z4openPKci+0x21b>

00802cda <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  802cda:	55                   	push   %ebp
  802cdb:	89 e5                	mov    %esp,%ebp
  802cdd:	53                   	push   %ebx
  802cde:	83 ec 24             	sub    $0x24,%esp
  802ce1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802ce4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	e8 78 f5 ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	78 27                	js     802d1a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802cf3:	c7 44 24 04 7c 4e 80 	movl   $0x804e7c,0x4(%esp)
  802cfa:	00 
  802cfb:	89 1c 24             	mov    %ebx,(%esp)
  802cfe:	e8 b7 de ff ff       	call   800bba <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802d03:	89 da                	mov    %ebx,%edx
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	e8 26 f4 ff ff       	call   802133 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	e8 50 f7 ff ff       	call   802465 <_ZL11inode_closeP5Inode>
	return 0;
  802d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d1a:	83 c4 24             	add    $0x24,%esp
  802d1d:	5b                   	pop    %ebx
  802d1e:	5d                   	pop    %ebp
  802d1f:	c3                   	ret    

00802d20 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802d20:	55                   	push   %ebp
  802d21:	89 e5                	mov    %esp,%ebp
  802d23:	53                   	push   %ebx
  802d24:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802d27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d2e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802d31:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	e8 3a fb ff ff       	call   802876 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802d3c:	89 c3                	mov    %eax,%ebx
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	78 5f                	js     802da1 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802d42:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	e8 18 f5 ff ff       	call   802267 <_ZL10inode_openiPP5Inode>
  802d4f:	89 c3                	mov    %eax,%ebx
  802d51:	85 c0                	test   %eax,%eax
  802d53:	78 44                	js     802d99 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802d55:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	83 38 02             	cmpl   $0x2,(%eax)
  802d60:	74 2f                	je     802d91 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802d72:	ba 04 00 00 00       	mov    $0x4,%edx
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	e8 2c f4 ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  802d7f:	ba 04 00 00 00       	mov    $0x4,%edx
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	e8 1f f4 ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
	r = 0;
  802d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	e8 cc f6 ff ff       	call   802465 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	e8 c4 f6 ff ff       	call   802465 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802da1:	89 d8                	mov    %ebx,%eax
  802da3:	83 c4 24             	add    $0x24,%esp
  802da6:	5b                   	pop    %ebx
  802da7:	5d                   	pop    %ebp
  802da8:	c3                   	ret    

00802da9 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802da9:	55                   	push   %ebp
  802daa:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  802dac:	b8 00 00 00 00       	mov    $0x0,%eax
  802db1:	5d                   	pop    %ebp
  802db2:	c3                   	ret    

00802db3 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802db3:	55                   	push   %ebp
  802db4:	89 e5                	mov    %esp,%ebp
  802db6:	57                   	push   %edi
  802db7:	56                   	push   %esi
  802db8:	53                   	push   %ebx
  802db9:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  802dbf:	c7 04 24 0d 25 80 00 	movl   $0x80250d,(%esp)
  802dc6:	e8 30 15 00 00       	call   8042fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802dcb:	a1 00 10 00 50       	mov    0x50001000,%eax
  802dd0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802dd5:	74 28                	je     802dff <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802dd7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802dde:	4a 
  802ddf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802de3:	c7 44 24 08 e4 4e 80 	movl   $0x804ee4,0x8(%esp)
  802dea:	00 
  802deb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802df2:	00 
  802df3:	c7 04 24 5e 4e 80 00 	movl   $0x804e5e,(%esp)
  802dfa:	e8 85 d6 ff ff       	call   800484 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802dff:	a1 04 10 00 50       	mov    0x50001004,%eax
  802e04:	83 f8 03             	cmp    $0x3,%eax
  802e07:	7f 1c                	jg     802e25 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802e09:	c7 44 24 08 18 4f 80 	movl   $0x804f18,0x8(%esp)
  802e10:	00 
  802e11:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802e18:	00 
  802e19:	c7 04 24 5e 4e 80 00 	movl   $0x804e5e,(%esp)
  802e20:	e8 5f d6 ff ff       	call   800484 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802e25:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802e2b:	85 d2                	test   %edx,%edx
  802e2d:	7f 1c                	jg     802e4b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802e2f:	c7 44 24 08 48 4f 80 	movl   $0x804f48,0x8(%esp)
  802e36:	00 
  802e37:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802e3e:	00 
  802e3f:	c7 04 24 5e 4e 80 00 	movl   $0x804e5e,(%esp)
  802e46:	e8 39 d6 ff ff       	call   800484 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802e4b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802e51:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802e57:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802e5d:	85 c9                	test   %ecx,%ecx
  802e5f:	0f 48 cb             	cmovs  %ebx,%ecx
  802e62:	c1 f9 0c             	sar    $0xc,%ecx
  802e65:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802e69:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802e6f:	39 c8                	cmp    %ecx,%eax
  802e71:	7c 13                	jl     802e86 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802e73:	85 c0                	test   %eax,%eax
  802e75:	7f 3d                	jg     802eb4 <_Z4fsckv+0x101>
  802e77:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802e7e:	00 00 00 
  802e81:	e9 ac 00 00 00       	jmp    802f32 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802e86:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802e8c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802e90:	89 44 24 10          	mov    %eax,0x10(%esp)
  802e94:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802e98:	c7 44 24 08 78 4f 80 	movl   $0x804f78,0x8(%esp)
  802e9f:	00 
  802ea0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802ea7:	00 
  802ea8:	c7 04 24 5e 4e 80 00 	movl   $0x804e5e,(%esp)
  802eaf:	e8 d0 d5 ff ff       	call   800484 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802eb4:	be 00 20 00 50       	mov    $0x50002000,%esi
  802eb9:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802ec0:	00 00 00 
  802ec3:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ec8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802ece:	39 df                	cmp    %ebx,%edi
  802ed0:	7e 27                	jle    802ef9 <_Z4fsckv+0x146>
  802ed2:	0f b6 06             	movzbl (%esi),%eax
  802ed5:	84 c0                	test   %al,%al
  802ed7:	74 4b                	je     802f24 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802ed9:	0f be c0             	movsbl %al,%eax
  802edc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ee0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ee4:	c7 04 24 bc 4f 80 00 	movl   $0x804fbc,(%esp)
  802eeb:	e8 b2 d6 ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  802ef0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802ef7:	eb 2b                	jmp    802f24 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802ef9:	0f b6 06             	movzbl (%esi),%eax
  802efc:	3c 01                	cmp    $0x1,%al
  802efe:	76 24                	jbe    802f24 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802f00:	0f be c0             	movsbl %al,%eax
  802f03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f07:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f0b:	c7 04 24 f0 4f 80 00 	movl   $0x804ff0,(%esp)
  802f12:	e8 8b d6 ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  802f17:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802f1e:	80 3e 00             	cmpb   $0x0,(%esi)
  802f21:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802f24:	83 c3 01             	add    $0x1,%ebx
  802f27:	83 c6 01             	add    $0x1,%esi
  802f2a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  802f30:	7f 9c                	jg     802ece <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  802f32:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  802f39:	0f 8e e1 02 00 00    	jle    803220 <_Z4fsckv+0x46d>
  802f3f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  802f46:	00 00 00 
		struct Inode *ino = get_inode(i);
  802f49:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  802f4f:	e8 f9 f1 ff ff       	call   80214d <_ZL9get_inodei>
  802f54:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  802f5a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  802f5e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  802f65:	75 22                	jne    802f89 <_Z4fsckv+0x1d6>
  802f67:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  802f6e:	0f 84 a9 06 00 00    	je     80361d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  802f74:	ba 00 00 00 00       	mov    $0x0,%edx
  802f79:	e8 2d f2 ff ff       	call   8021ab <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 3a                	je     802fbc <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  802f82:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  802f89:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802f8f:	8b 02                	mov    (%edx),%eax
  802f91:	83 f8 01             	cmp    $0x1,%eax
  802f94:	74 26                	je     802fbc <_Z4fsckv+0x209>
  802f96:	83 f8 02             	cmp    $0x2,%eax
  802f99:	74 21                	je     802fbc <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  802f9b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f9f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  802fa5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fa9:	c7 04 24 1c 50 80 00 	movl   $0x80501c,(%esp)
  802fb0:	e8 ed d5 ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  802fb5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  802fbc:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  802fc3:	75 3f                	jne    803004 <_Z4fsckv+0x251>
  802fc5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  802fcb:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802fcf:	75 15                	jne    802fe6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  802fd1:	c7 04 24 40 50 80 00 	movl   $0x805040,(%esp)
  802fd8:	e8 c5 d5 ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  802fdd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802fe4:	eb 1e                	jmp    803004 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802fe6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802fec:	83 3a 02             	cmpl   $0x2,(%edx)
  802fef:	74 13                	je     803004 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802ff1:	c7 04 24 74 50 80 00 	movl   $0x805074,(%esp)
  802ff8:	e8 a5 d5 ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  802ffd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  803004:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  803009:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803010:	0f 84 93 00 00 00    	je     8030a9 <_Z4fsckv+0x2f6>
  803016:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  80301c:	8b 41 08             	mov    0x8(%ecx),%eax
  80301f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  803024:	7e 23                	jle    803049 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  803026:	89 44 24 08          	mov    %eax,0x8(%esp)
  80302a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803030:	89 44 24 04          	mov    %eax,0x4(%esp)
  803034:	c7 04 24 a4 50 80 00 	movl   $0x8050a4,(%esp)
  80303b:	e8 62 d5 ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  803040:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803047:	eb 09                	jmp    803052 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  803049:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803050:	74 4b                	je     80309d <_Z4fsckv+0x2ea>
  803052:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803058:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80305e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  803064:	74 23                	je     803089 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  803066:	89 44 24 08          	mov    %eax,0x8(%esp)
  80306a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803070:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803074:	c7 04 24 c8 50 80 00 	movl   $0x8050c8,(%esp)
  80307b:	e8 22 d5 ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  803080:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803087:	eb 09                	jmp    803092 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  803089:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803090:	74 12                	je     8030a4 <_Z4fsckv+0x2f1>
  803092:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803098:	8b 78 08             	mov    0x8(%eax),%edi
  80309b:	eb 0c                	jmp    8030a9 <_Z4fsckv+0x2f6>
  80309d:	bf 00 00 00 00       	mov    $0x0,%edi
  8030a2:	eb 05                	jmp    8030a9 <_Z4fsckv+0x2f6>
  8030a4:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  8030a9:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  8030ae:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8030b4:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8030b8:	89 d8                	mov    %ebx,%eax
  8030ba:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  8030bd:	39 c7                	cmp    %eax,%edi
  8030bf:	7e 2b                	jle    8030ec <_Z4fsckv+0x339>
  8030c1:	85 f6                	test   %esi,%esi
  8030c3:	75 27                	jne    8030ec <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  8030c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030cd:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8030d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030d7:	c7 04 24 ec 50 80 00 	movl   $0x8050ec,(%esp)
  8030de:	e8 bf d4 ff ff       	call   8005a2 <_Z7cprintfPKcz>
				++errors;
  8030e3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8030ea:	eb 36                	jmp    803122 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  8030ec:	39 f8                	cmp    %edi,%eax
  8030ee:	7c 32                	jl     803122 <_Z4fsckv+0x36f>
  8030f0:	85 f6                	test   %esi,%esi
  8030f2:	74 2e                	je     803122 <_Z4fsckv+0x36f>
  8030f4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8030fb:	74 25                	je     803122 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8030fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803101:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803105:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80310b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80310f:	c7 04 24 30 51 80 00 	movl   $0x805130,(%esp)
  803116:	e8 87 d4 ff ff       	call   8005a2 <_Z7cprintfPKcz>
				++errors;
  80311b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  803122:	85 f6                	test   %esi,%esi
  803124:	0f 84 a0 00 00 00    	je     8031ca <_Z4fsckv+0x417>
  80312a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803131:	0f 84 93 00 00 00    	je     8031ca <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  803137:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  80313d:	7e 27                	jle    803166 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  80313f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803143:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803147:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  80314d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803151:	c7 04 24 74 51 80 00 	movl   $0x805174,(%esp)
  803158:	e8 45 d4 ff ff       	call   8005a2 <_Z7cprintfPKcz>
					++errors;
  80315d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803164:	eb 64                	jmp    8031ca <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  803166:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80316d:	3c 01                	cmp    $0x1,%al
  80316f:	75 27                	jne    803198 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  803171:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803175:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803179:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  80317f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803183:	c7 04 24 b8 51 80 00 	movl   $0x8051b8,(%esp)
  80318a:	e8 13 d4 ff ff       	call   8005a2 <_Z7cprintfPKcz>
					++errors;
  80318f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803196:	eb 32                	jmp    8031ca <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  803198:	3c ff                	cmp    $0xff,%al
  80319a:	75 27                	jne    8031c3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  80319c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8031a0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031a4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8031aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ae:	c7 04 24 f4 51 80 00 	movl   $0x8051f4,(%esp)
  8031b5:	e8 e8 d3 ff ff       	call   8005a2 <_Z7cprintfPKcz>
					++errors;
  8031ba:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8031c1:	eb 07                	jmp    8031ca <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  8031c3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  8031ca:	83 c3 01             	add    $0x1,%ebx
  8031cd:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  8031d3:	0f 85 d5 fe ff ff    	jne    8030ae <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  8031d9:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8031e0:	0f 94 c0             	sete   %al
  8031e3:	0f b6 c0             	movzbl %al,%eax
  8031e6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8031ec:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  8031f2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  8031f9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  803200:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803207:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  80320e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803214:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  80321a:	0f 8f 29 fd ff ff    	jg     802f49 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803220:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803227:	0f 8e 7f 03 00 00    	jle    8035ac <_Z4fsckv+0x7f9>
  80322d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  803232:	89 f0                	mov    %esi,%eax
  803234:	e8 14 ef ff ff       	call   80214d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  803239:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803240:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803247:	c1 e2 08             	shl    $0x8,%edx
  80324a:	09 ca                	or     %ecx,%edx
  80324c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803253:	c1 e1 10             	shl    $0x10,%ecx
  803256:	09 ca                	or     %ecx,%edx
  803258:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  80325f:	83 e1 7f             	and    $0x7f,%ecx
  803262:	c1 e1 18             	shl    $0x18,%ecx
  803265:	09 d1                	or     %edx,%ecx
  803267:	74 0e                	je     803277 <_Z4fsckv+0x4c4>
  803269:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803270:	78 05                	js     803277 <_Z4fsckv+0x4c4>
  803272:	83 38 02             	cmpl   $0x2,(%eax)
  803275:	74 1f                	je     803296 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803277:	83 c6 01             	add    $0x1,%esi
  80327a:	a1 08 10 00 50       	mov    0x50001008,%eax
  80327f:	39 f0                	cmp    %esi,%eax
  803281:	7f af                	jg     803232 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803283:	bb 01 00 00 00       	mov    $0x1,%ebx
  803288:	83 f8 01             	cmp    $0x1,%eax
  80328b:	0f 8f ad 02 00 00    	jg     80353e <_Z4fsckv+0x78b>
  803291:	e9 16 03 00 00       	jmp    8035ac <_Z4fsckv+0x7f9>
  803296:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  803298:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  80329f:	8b 40 08             	mov    0x8(%eax),%eax
  8032a2:	a8 7f                	test   $0x7f,%al
  8032a4:	74 23                	je     8032c9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  8032a6:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  8032ad:	00 
  8032ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8032b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8032b6:	c7 04 24 30 52 80 00 	movl   $0x805230,(%esp)
  8032bd:	e8 e0 d2 ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  8032c2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8032c9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  8032d0:	00 00 00 
  8032d3:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  8032d9:	e9 3d 02 00 00       	jmp    80351b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  8032de:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8032e4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8032ea:	e8 01 ee ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
  8032ef:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  8032f1:	83 38 00             	cmpl   $0x0,(%eax)
  8032f4:	0f 84 15 02 00 00    	je     80350f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  8032fa:	8b 40 04             	mov    0x4(%eax),%eax
  8032fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803300:	83 fa 76             	cmp    $0x76,%edx
  803303:	76 27                	jbe    80332c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  803305:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803309:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80330f:	89 44 24 08          	mov    %eax,0x8(%esp)
  803313:	89 74 24 04          	mov    %esi,0x4(%esp)
  803317:	c7 04 24 64 52 80 00 	movl   $0x805264,(%esp)
  80331e:	e8 7f d2 ff ff       	call   8005a2 <_Z7cprintfPKcz>
				++errors;
  803323:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80332a:	eb 28                	jmp    803354 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  80332c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  803331:	74 21                	je     803354 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  803333:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803339:	89 54 24 08          	mov    %edx,0x8(%esp)
  80333d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803341:	c7 04 24 90 52 80 00 	movl   $0x805290,(%esp)
  803348:	e8 55 d2 ff ff       	call   8005a2 <_Z7cprintfPKcz>
				++errors;
  80334d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803354:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  80335b:	00 
  80335c:	8d 43 08             	lea    0x8(%ebx),%eax
  80335f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803363:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803369:	89 0c 24             	mov    %ecx,(%esp)
  80336c:	e8 66 da ff ff       	call   800dd7 <memcpy>
  803371:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803375:	bf 77 00 00 00       	mov    $0x77,%edi
  80337a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80337e:	85 ff                	test   %edi,%edi
  803380:	b8 00 00 00 00       	mov    $0x0,%eax
  803385:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803388:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80338f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803390:	8b 03                	mov    (%ebx),%eax
  803392:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803398:	7c 3e                	jl     8033d8 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80339a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80339e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8033a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033a8:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8033ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8033b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8033b6:	c7 04 24 c4 52 80 00 	movl   $0x8052c4,(%esp)
  8033bd:	e8 e0 d1 ff ff       	call   8005a2 <_Z7cprintfPKcz>
				++errors;
  8033c2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8033c9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  8033d0:	00 00 00 
  8033d3:	e9 0b 01 00 00       	jmp    8034e3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  8033d8:	e8 70 ed ff ff       	call   80214d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  8033dd:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8033e4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  8033eb:	c1 e2 08             	shl    $0x8,%edx
  8033ee:	09 d1                	or     %edx,%ecx
  8033f0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  8033f7:	c1 e2 10             	shl    $0x10,%edx
  8033fa:	09 d1                	or     %edx,%ecx
  8033fc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803403:	83 e2 7f             	and    $0x7f,%edx
  803406:	c1 e2 18             	shl    $0x18,%edx
  803409:	09 ca                	or     %ecx,%edx
  80340b:	83 c2 01             	add    $0x1,%edx
  80340e:	89 d1                	mov    %edx,%ecx
  803410:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  803416:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  80341c:	0f b6 d5             	movzbl %ch,%edx
  80341f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  803425:	89 ca                	mov    %ecx,%edx
  803427:	c1 ea 10             	shr    $0x10,%edx
  80342a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  803430:	c1 e9 18             	shr    $0x18,%ecx
  803433:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  80343a:	83 e2 80             	and    $0xffffff80,%edx
  80343d:	09 ca                	or     %ecx,%edx
  80343f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803445:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803449:	0f 85 7a ff ff ff    	jne    8033c9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  80344f:	8b 03                	mov    (%ebx),%eax
  803451:	89 44 24 10          	mov    %eax,0x10(%esp)
  803455:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80345b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80345f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803465:	89 44 24 08          	mov    %eax,0x8(%esp)
  803469:	89 74 24 04          	mov    %esi,0x4(%esp)
  80346d:	c7 04 24 f4 52 80 00 	movl   $0x8052f4,(%esp)
  803474:	e8 29 d1 ff ff       	call   8005a2 <_Z7cprintfPKcz>
					++errors;
  803479:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803480:	e9 44 ff ff ff       	jmp    8033c9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803485:	3b 78 04             	cmp    0x4(%eax),%edi
  803488:	75 52                	jne    8034dc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  80348a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80348e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803494:	89 54 24 04          	mov    %edx,0x4(%esp)
  803498:	83 c0 08             	add    $0x8,%eax
  80349b:	89 04 24             	mov    %eax,(%esp)
  80349e:	e8 75 d9 ff ff       	call   800e18 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  8034a3:	85 c0                	test   %eax,%eax
  8034a5:	75 35                	jne    8034dc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  8034a7:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8034ad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8034b1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8034b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034bb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8034c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8034c5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8034c9:	c7 04 24 24 53 80 00 	movl   $0x805324,(%esp)
  8034d0:	e8 cd d0 ff ff       	call   8005a2 <_Z7cprintfPKcz>
					++errors;
  8034d5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8034dc:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  8034e3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8034e9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  8034ef:	7e 1e                	jle    80350f <_Z4fsckv+0x75c>
  8034f1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  8034f5:	7f 18                	jg     80350f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  8034f7:	89 ca                	mov    %ecx,%edx
  8034f9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8034ff:	e8 ec eb ff ff       	call   8020f0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  803504:	83 38 00             	cmpl   $0x0,(%eax)
  803507:	0f 85 78 ff ff ff    	jne    803485 <_Z4fsckv+0x6d2>
  80350d:	eb cd                	jmp    8034dc <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80350f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  803515:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80351b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803521:	83 ea 80             	sub    $0xffffff80,%edx
  803524:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80352a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803530:	3b 51 08             	cmp    0x8(%ecx),%edx
  803533:	0f 8f e7 fc ff ff    	jg     803220 <_Z4fsckv+0x46d>
  803539:	e9 a0 fd ff ff       	jmp    8032de <_Z4fsckv+0x52b>
  80353e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803544:	89 d8                	mov    %ebx,%eax
  803546:	e8 02 ec ff ff       	call   80214d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  80354b:	8b 50 04             	mov    0x4(%eax),%edx
  80354e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803555:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80355c:	c1 e7 08             	shl    $0x8,%edi
  80355f:	09 f9                	or     %edi,%ecx
  803561:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803568:	c1 e7 10             	shl    $0x10,%edi
  80356b:	09 f9                	or     %edi,%ecx
  80356d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803574:	83 e7 7f             	and    $0x7f,%edi
  803577:	c1 e7 18             	shl    $0x18,%edi
  80357a:	09 f9                	or     %edi,%ecx
  80357c:	39 ca                	cmp    %ecx,%edx
  80357e:	74 1b                	je     80359b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803580:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803584:	89 54 24 08          	mov    %edx,0x8(%esp)
  803588:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80358c:	c7 04 24 54 53 80 00 	movl   $0x805354,(%esp)
  803593:	e8 0a d0 ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  803598:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80359b:	83 c3 01             	add    $0x1,%ebx
  80359e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  8035a4:	7f 9e                	jg     803544 <_Z4fsckv+0x791>
  8035a6:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8035ac:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  8035b3:	7e 4f                	jle    803604 <_Z4fsckv+0x851>
  8035b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8035ba:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  8035c0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  8035c7:	3c ff                	cmp    $0xff,%al
  8035c9:	75 09                	jne    8035d4 <_Z4fsckv+0x821>
			freemap[i] = 0;
  8035cb:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  8035d2:	eb 1f                	jmp    8035f3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  8035d4:	84 c0                	test   %al,%al
  8035d6:	75 1b                	jne    8035f3 <_Z4fsckv+0x840>
  8035d8:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  8035de:	7c 13                	jl     8035f3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  8035e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8035e4:	c7 04 24 80 53 80 00 	movl   $0x805380,(%esp)
  8035eb:	e8 b2 cf ff ff       	call   8005a2 <_Z7cprintfPKcz>
			++errors;
  8035f0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8035f3:	83 c3 01             	add    $0x1,%ebx
  8035f6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8035fc:	7f c2                	jg     8035c0 <_Z4fsckv+0x80d>
  8035fe:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803604:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80360b:	19 c0                	sbb    %eax,%eax
  80360d:	f7 d0                	not    %eax
  80360f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  803612:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  803618:	5b                   	pop    %ebx
  803619:	5e                   	pop    %esi
  80361a:	5f                   	pop    %edi
  80361b:	5d                   	pop    %ebp
  80361c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  80361d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803624:	0f 84 92 f9 ff ff    	je     802fbc <_Z4fsckv+0x209>
  80362a:	e9 5a f9 ff ff       	jmp    802f89 <_Z4fsckv+0x1d6>
	...

00803630 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803630:	55                   	push   %ebp
  803631:	89 e5                	mov    %esp,%ebp
  803633:	83 ec 18             	sub    $0x18,%esp
  803636:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803639:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80363c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	89 04 24             	mov    %eax,(%esp)
  803645:	e8 a2 e4 ff ff       	call   801aec <_Z7fd2dataP2Fd>
  80364a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80364c:	c7 44 24 04 b3 53 80 	movl   $0x8053b3,0x4(%esp)
  803653:	00 
  803654:	89 34 24             	mov    %esi,(%esp)
  803657:	e8 5e d5 ff ff       	call   800bba <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80365c:	8b 43 04             	mov    0x4(%ebx),%eax
  80365f:	2b 03                	sub    (%ebx),%eax
  803661:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803664:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80366b:	c7 86 80 00 00 00 20 	movl   $0x806020,0x80(%esi)
  803672:	60 80 00 
	return 0;
}
  803675:	b8 00 00 00 00       	mov    $0x0,%eax
  80367a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80367d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803680:	89 ec                	mov    %ebp,%esp
  803682:	5d                   	pop    %ebp
  803683:	c3                   	ret    

00803684 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803684:	55                   	push   %ebp
  803685:	89 e5                	mov    %esp,%ebp
  803687:	53                   	push   %ebx
  803688:	83 ec 14             	sub    $0x14,%esp
  80368b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80368e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803692:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803699:	e8 bf da ff ff       	call   80115d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80369e:	89 1c 24             	mov    %ebx,(%esp)
  8036a1:	e8 46 e4 ff ff       	call   801aec <_Z7fd2dataP2Fd>
  8036a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036b1:	e8 a7 da ff ff       	call   80115d <_Z14sys_page_unmapiPv>
}
  8036b6:	83 c4 14             	add    $0x14,%esp
  8036b9:	5b                   	pop    %ebx
  8036ba:	5d                   	pop    %ebp
  8036bb:	c3                   	ret    

008036bc <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8036bc:	55                   	push   %ebp
  8036bd:	89 e5                	mov    %esp,%ebp
  8036bf:	57                   	push   %edi
  8036c0:	56                   	push   %esi
  8036c1:	53                   	push   %ebx
  8036c2:	83 ec 2c             	sub    $0x2c,%esp
  8036c5:	89 c7                	mov    %eax,%edi
  8036c7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  8036ca:	a1 00 74 80 00       	mov    0x807400,%eax
  8036cf:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  8036d2:	89 3c 24             	mov    %edi,(%esp)
  8036d5:	e8 82 04 00 00       	call   803b5c <_Z7pagerefPv>
  8036da:	89 c3                	mov    %eax,%ebx
  8036dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036df:	89 04 24             	mov    %eax,(%esp)
  8036e2:	e8 75 04 00 00       	call   803b5c <_Z7pagerefPv>
  8036e7:	39 c3                	cmp    %eax,%ebx
  8036e9:	0f 94 c0             	sete   %al
  8036ec:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  8036ef:	8b 15 00 74 80 00    	mov    0x807400,%edx
  8036f5:	8b 52 58             	mov    0x58(%edx),%edx
  8036f8:	39 d6                	cmp    %edx,%esi
  8036fa:	75 08                	jne    803704 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  8036fc:	83 c4 2c             	add    $0x2c,%esp
  8036ff:	5b                   	pop    %ebx
  803700:	5e                   	pop    %esi
  803701:	5f                   	pop    %edi
  803702:	5d                   	pop    %ebp
  803703:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803704:	85 c0                	test   %eax,%eax
  803706:	74 c2                	je     8036ca <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803708:	c7 04 24 ba 53 80 00 	movl   $0x8053ba,(%esp)
  80370f:	e8 8e ce ff ff       	call   8005a2 <_Z7cprintfPKcz>
  803714:	eb b4                	jmp    8036ca <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00803716 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803716:	55                   	push   %ebp
  803717:	89 e5                	mov    %esp,%ebp
  803719:	57                   	push   %edi
  80371a:	56                   	push   %esi
  80371b:	53                   	push   %ebx
  80371c:	83 ec 1c             	sub    $0x1c,%esp
  80371f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803722:	89 34 24             	mov    %esi,(%esp)
  803725:	e8 c2 e3 ff ff       	call   801aec <_Z7fd2dataP2Fd>
  80372a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80372c:	bf 00 00 00 00       	mov    $0x0,%edi
  803731:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803735:	75 46                	jne    80377d <_ZL13devpipe_writeP2FdPKvj+0x67>
  803737:	eb 52                	jmp    80378b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803739:	89 da                	mov    %ebx,%edx
  80373b:	89 f0                	mov    %esi,%eax
  80373d:	e8 7a ff ff ff       	call   8036bc <_ZL13_pipeisclosedP2FdP4Pipe>
  803742:	85 c0                	test   %eax,%eax
  803744:	75 49                	jne    80378f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803746:	e8 21 d9 ff ff       	call   80106c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80374b:	8b 43 04             	mov    0x4(%ebx),%eax
  80374e:	89 c2                	mov    %eax,%edx
  803750:	2b 13                	sub    (%ebx),%edx
  803752:	83 fa 20             	cmp    $0x20,%edx
  803755:	74 e2                	je     803739 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803757:	89 c2                	mov    %eax,%edx
  803759:	c1 fa 1f             	sar    $0x1f,%edx
  80375c:	c1 ea 1b             	shr    $0x1b,%edx
  80375f:	01 d0                	add    %edx,%eax
  803761:	83 e0 1f             	and    $0x1f,%eax
  803764:	29 d0                	sub    %edx,%eax
  803766:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803769:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80376d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803771:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803775:	83 c7 01             	add    $0x1,%edi
  803778:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80377b:	76 0e                	jbe    80378b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80377d:	8b 43 04             	mov    0x4(%ebx),%eax
  803780:	89 c2                	mov    %eax,%edx
  803782:	2b 13                	sub    (%ebx),%edx
  803784:	83 fa 20             	cmp    $0x20,%edx
  803787:	74 b0                	je     803739 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803789:	eb cc                	jmp    803757 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80378b:	89 f8                	mov    %edi,%eax
  80378d:	eb 05                	jmp    803794 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80378f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803794:	83 c4 1c             	add    $0x1c,%esp
  803797:	5b                   	pop    %ebx
  803798:	5e                   	pop    %esi
  803799:	5f                   	pop    %edi
  80379a:	5d                   	pop    %ebp
  80379b:	c3                   	ret    

0080379c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80379c:	55                   	push   %ebp
  80379d:	89 e5                	mov    %esp,%ebp
  80379f:	83 ec 28             	sub    $0x28,%esp
  8037a2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8037a5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8037a8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8037ab:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8037ae:	89 3c 24             	mov    %edi,(%esp)
  8037b1:	e8 36 e3 ff ff       	call   801aec <_Z7fd2dataP2Fd>
  8037b6:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8037b8:	be 00 00 00 00       	mov    $0x0,%esi
  8037bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8037c1:	75 47                	jne    80380a <_ZL12devpipe_readP2FdPvj+0x6e>
  8037c3:	eb 52                	jmp    803817 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  8037c5:	89 f0                	mov    %esi,%eax
  8037c7:	eb 5e                	jmp    803827 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  8037c9:	89 da                	mov    %ebx,%edx
  8037cb:	89 f8                	mov    %edi,%eax
  8037cd:	8d 76 00             	lea    0x0(%esi),%esi
  8037d0:	e8 e7 fe ff ff       	call   8036bc <_ZL13_pipeisclosedP2FdP4Pipe>
  8037d5:	85 c0                	test   %eax,%eax
  8037d7:	75 49                	jne    803822 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  8037d9:	e8 8e d8 ff ff       	call   80106c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8037de:	8b 03                	mov    (%ebx),%eax
  8037e0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8037e3:	74 e4                	je     8037c9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8037e5:	89 c2                	mov    %eax,%edx
  8037e7:	c1 fa 1f             	sar    $0x1f,%edx
  8037ea:	c1 ea 1b             	shr    $0x1b,%edx
  8037ed:	01 d0                	add    %edx,%eax
  8037ef:	83 e0 1f             	and    $0x1f,%eax
  8037f2:	29 d0                	sub    %edx,%eax
  8037f4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8037f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037fc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8037ff:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803802:	83 c6 01             	add    $0x1,%esi
  803805:	39 75 10             	cmp    %esi,0x10(%ebp)
  803808:	76 0d                	jbe    803817 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  80380a:	8b 03                	mov    (%ebx),%eax
  80380c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80380f:	75 d4                	jne    8037e5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803811:	85 f6                	test   %esi,%esi
  803813:	75 b0                	jne    8037c5 <_ZL12devpipe_readP2FdPvj+0x29>
  803815:	eb b2                	jmp    8037c9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803817:	89 f0                	mov    %esi,%eax
  803819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803820:	eb 05                	jmp    803827 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803822:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803827:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80382a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80382d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803830:	89 ec                	mov    %ebp,%esp
  803832:	5d                   	pop    %ebp
  803833:	c3                   	ret    

00803834 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803834:	55                   	push   %ebp
  803835:	89 e5                	mov    %esp,%ebp
  803837:	83 ec 48             	sub    $0x48,%esp
  80383a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80383d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803840:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803843:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803846:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803849:	89 04 24             	mov    %eax,(%esp)
  80384c:	e8 b6 e2 ff ff       	call   801b07 <_Z14fd_find_unusedPP2Fd>
  803851:	89 c3                	mov    %eax,%ebx
  803853:	85 c0                	test   %eax,%eax
  803855:	0f 88 0b 01 00 00    	js     803966 <_Z4pipePi+0x132>
  80385b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803862:	00 
  803863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803866:	89 44 24 04          	mov    %eax,0x4(%esp)
  80386a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803871:	e8 2a d8 ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  803876:	89 c3                	mov    %eax,%ebx
  803878:	85 c0                	test   %eax,%eax
  80387a:	0f 89 f5 00 00 00    	jns    803975 <_Z4pipePi+0x141>
  803880:	e9 e1 00 00 00       	jmp    803966 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803885:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80388c:	00 
  80388d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803890:	89 44 24 04          	mov    %eax,0x4(%esp)
  803894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80389b:	e8 00 d8 ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  8038a0:	89 c3                	mov    %eax,%ebx
  8038a2:	85 c0                	test   %eax,%eax
  8038a4:	0f 89 e2 00 00 00    	jns    80398c <_Z4pipePi+0x158>
  8038aa:	e9 a4 00 00 00       	jmp    803953 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b2:	89 04 24             	mov    %eax,(%esp)
  8038b5:	e8 32 e2 ff ff       	call   801aec <_Z7fd2dataP2Fd>
  8038ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8038c1:	00 
  8038c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8038cd:	00 
  8038ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8038d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038d9:	e8 21 d8 ff ff       	call   8010ff <_Z12sys_page_mapiPviS_i>
  8038de:	89 c3                	mov    %eax,%ebx
  8038e0:	85 c0                	test   %eax,%eax
  8038e2:	78 4c                	js     803930 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8038e4:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8038ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8038ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8038f9:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8038ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803902:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803904:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803907:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80390e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803911:	89 04 24             	mov    %eax,(%esp)
  803914:	e8 8b e1 ff ff       	call   801aa4 <_Z6fd2numP2Fd>
  803919:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80391b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80391e:	89 04 24             	mov    %eax,(%esp)
  803921:	e8 7e e1 ff ff       	call   801aa4 <_Z6fd2numP2Fd>
  803926:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803929:	bb 00 00 00 00       	mov    $0x0,%ebx
  80392e:	eb 36                	jmp    803966 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803930:	89 74 24 04          	mov    %esi,0x4(%esp)
  803934:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80393b:	e8 1d d8 ff ff       	call   80115d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803940:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803943:	89 44 24 04          	mov    %eax,0x4(%esp)
  803947:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80394e:	e8 0a d8 ff ff       	call   80115d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803956:	89 44 24 04          	mov    %eax,0x4(%esp)
  80395a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803961:	e8 f7 d7 ff ff       	call   80115d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803966:	89 d8                	mov    %ebx,%eax
  803968:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80396b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80396e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803971:	89 ec                	mov    %ebp,%esp
  803973:	5d                   	pop    %ebp
  803974:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803975:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803978:	89 04 24             	mov    %eax,(%esp)
  80397b:	e8 87 e1 ff ff       	call   801b07 <_Z14fd_find_unusedPP2Fd>
  803980:	89 c3                	mov    %eax,%ebx
  803982:	85 c0                	test   %eax,%eax
  803984:	0f 89 fb fe ff ff    	jns    803885 <_Z4pipePi+0x51>
  80398a:	eb c7                	jmp    803953 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80398c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398f:	89 04 24             	mov    %eax,(%esp)
  803992:	e8 55 e1 ff ff       	call   801aec <_Z7fd2dataP2Fd>
  803997:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803999:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8039a0:	00 
  8039a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039ac:	e8 ef d6 ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  8039b1:	89 c3                	mov    %eax,%ebx
  8039b3:	85 c0                	test   %eax,%eax
  8039b5:	0f 89 f4 fe ff ff    	jns    8038af <_Z4pipePi+0x7b>
  8039bb:	eb 83                	jmp    803940 <_Z4pipePi+0x10c>

008039bd <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  8039bd:	55                   	push   %ebp
  8039be:	89 e5                	mov    %esp,%ebp
  8039c0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8039c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8039ca:	00 
  8039cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8039ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d5:	89 04 24             	mov    %eax,(%esp)
  8039d8:	e8 74 e0 ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  8039dd:	85 c0                	test   %eax,%eax
  8039df:	78 15                	js     8039f6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e4:	89 04 24             	mov    %eax,(%esp)
  8039e7:	e8 00 e1 ff ff       	call   801aec <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  8039ec:	89 c2                	mov    %eax,%edx
  8039ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f1:	e8 c6 fc ff ff       	call   8036bc <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8039f6:	c9                   	leave  
  8039f7:	c3                   	ret    

008039f8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8039f8:	55                   	push   %ebp
  8039f9:	89 e5                	mov    %esp,%ebp
  8039fb:	53                   	push   %ebx
  8039fc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8039ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a02:	89 04 24             	mov    %eax,(%esp)
  803a05:	e8 fd e0 ff ff       	call   801b07 <_Z14fd_find_unusedPP2Fd>
  803a0a:	89 c3                	mov    %eax,%ebx
  803a0c:	85 c0                	test   %eax,%eax
  803a0e:	0f 88 be 00 00 00    	js     803ad2 <_Z18pipe_ipc_recv_readv+0xda>
  803a14:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803a1b:	00 
  803a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a2a:	e8 71 d6 ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  803a2f:	89 c3                	mov    %eax,%ebx
  803a31:	85 c0                	test   %eax,%eax
  803a33:	0f 89 a1 00 00 00    	jns    803ada <_Z18pipe_ipc_recv_readv+0xe2>
  803a39:	e9 94 00 00 00       	jmp    803ad2 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  803a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a41:	85 c0                	test   %eax,%eax
  803a43:	75 0e                	jne    803a53 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803a45:	c7 04 24 18 54 80 00 	movl   $0x805418,(%esp)
  803a4c:	e8 51 cb ff ff       	call   8005a2 <_Z7cprintfPKcz>
  803a51:	eb 10                	jmp    803a63 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a57:	c7 04 24 cd 53 80 00 	movl   $0x8053cd,(%esp)
  803a5e:	e8 3f cb ff ff       	call   8005a2 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803a63:	c7 04 24 d7 53 80 00 	movl   $0x8053d7,(%esp)
  803a6a:	e8 33 cb ff ff       	call   8005a2 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  803a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a72:	a8 04                	test   $0x4,%al
  803a74:	74 04                	je     803a7a <_Z18pipe_ipc_recv_readv+0x82>
  803a76:	a8 01                	test   $0x1,%al
  803a78:	75 24                	jne    803a9e <_Z18pipe_ipc_recv_readv+0xa6>
  803a7a:	c7 44 24 0c ea 53 80 	movl   $0x8053ea,0xc(%esp)
  803a81:	00 
  803a82:	c7 44 24 08 b4 4d 80 	movl   $0x804db4,0x8(%esp)
  803a89:	00 
  803a8a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803a91:	00 
  803a92:	c7 04 24 07 54 80 00 	movl   $0x805407,(%esp)
  803a99:	e8 e6 c9 ff ff       	call   800484 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  803a9e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  803aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa7:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803ab3:	89 04 24             	mov    %eax,(%esp)
  803ab6:	e8 e9 df ff ff       	call   801aa4 <_Z6fd2numP2Fd>
  803abb:	89 c3                	mov    %eax,%ebx
  803abd:	eb 13                	jmp    803ad2 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  803abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ac6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803acd:	e8 8b d6 ff ff       	call   80115d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803ad2:	89 d8                	mov    %ebx,%eax
  803ad4:	83 c4 24             	add    $0x24,%esp
  803ad7:	5b                   	pop    %ebx
  803ad8:	5d                   	pop    %ebp
  803ad9:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  803ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803add:	89 04 24             	mov    %eax,(%esp)
  803ae0:	e8 07 e0 ff ff       	call   801aec <_Z7fd2dataP2Fd>
  803ae5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803ae8:	89 54 24 08          	mov    %edx,0x8(%esp)
  803aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  803af0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803af3:	89 04 24             	mov    %eax,(%esp)
  803af6:	e8 f5 08 00 00       	call   8043f0 <_Z8ipc_recvPiPvS_>
  803afb:	89 c3                	mov    %eax,%ebx
  803afd:	85 c0                	test   %eax,%eax
  803aff:	0f 89 39 ff ff ff    	jns    803a3e <_Z18pipe_ipc_recv_readv+0x46>
  803b05:	eb b8                	jmp    803abf <_Z18pipe_ipc_recv_readv+0xc7>

00803b07 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803b07:	55                   	push   %ebp
  803b08:	89 e5                	mov    %esp,%ebp
  803b0a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  803b0d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803b14:	00 
  803b15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b1f:	89 04 24             	mov    %eax,(%esp)
  803b22:	e8 2a df ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  803b27:	85 c0                	test   %eax,%eax
  803b29:	78 2f                	js     803b5a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  803b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2e:	89 04 24             	mov    %eax,(%esp)
  803b31:	e8 b6 df ff ff       	call   801aec <_Z7fd2dataP2Fd>
  803b36:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803b3d:	00 
  803b3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803b42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803b49:	00 
  803b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4d:	89 04 24             	mov    %eax,(%esp)
  803b50:	e8 2a 09 00 00       	call   80447f <_Z8ipc_sendijPvi>
    return 0;
  803b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b5a:	c9                   	leave  
  803b5b:	c3                   	ret    

00803b5c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b5c:	55                   	push   %ebp
  803b5d:	89 e5                	mov    %esp,%ebp
  803b5f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803b62:	89 d0                	mov    %edx,%eax
  803b64:	c1 e8 16             	shr    $0x16,%eax
  803b67:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  803b6e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803b73:	f6 c1 01             	test   $0x1,%cl
  803b76:	74 1d                	je     803b95 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803b78:	c1 ea 0c             	shr    $0xc,%edx
  803b7b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803b82:	f6 c2 01             	test   $0x1,%dl
  803b85:	74 0e                	je     803b95 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803b87:	c1 ea 0c             	shr    $0xc,%edx
  803b8a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803b91:	ef 
  803b92:	0f b7 c0             	movzwl %ax,%eax
}
  803b95:	5d                   	pop    %ebp
  803b96:	c3                   	ret    
	...

00803ba0 <_Z4waiti>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803ba0:	55                   	push   %ebp
  803ba1:	89 e5                	mov    %esp,%ebp
  803ba3:	56                   	push   %esi
  803ba4:	53                   	push   %ebx
  803ba5:	83 ec 10             	sub    $0x10,%esp
  803ba8:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803bab:	85 f6                	test   %esi,%esi
  803bad:	75 24                	jne    803bd3 <_Z4waiti+0x33>
  803baf:	c7 44 24 0c 3b 54 80 	movl   $0x80543b,0xc(%esp)
  803bb6:	00 
  803bb7:	c7 44 24 08 b4 4d 80 	movl   $0x804db4,0x8(%esp)
  803bbe:	00 
  803bbf:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  803bc6:	00 
  803bc7:	c7 04 24 46 54 80 00 	movl   $0x805446,(%esp)
  803bce:	e8 b1 c8 ff ff       	call   800484 <_Z6_panicPKciS0_z>
	e = &envs[ENVX(envid)];
  803bd3:	89 f3                	mov    %esi,%ebx
  803bd5:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803bdb:	6b db 78             	imul   $0x78,%ebx,%ebx
  803bde:	8b 83 04 00 00 ef    	mov    -0x10fffffc(%ebx),%eax
  803be4:	39 f0                	cmp    %esi,%eax
  803be6:	75 11                	jne    803bf9 <_Z4waiti+0x59>
  803be8:	8b 83 0c 00 00 ef    	mov    -0x10fffff4(%ebx),%eax
  803bee:	85 c0                	test   %eax,%eax
  803bf0:	74 07                	je     803bf9 <_Z4waiti+0x59>
		sys_yield();
  803bf2:	e8 75 d4 ff ff       	call   80106c <_Z9sys_yieldv>
  803bf7:	eb e5                	jmp    803bde <_Z4waiti+0x3e>
}
  803bf9:	83 c4 10             	add    $0x10,%esp
  803bfc:	5b                   	pop    %ebx
  803bfd:	5e                   	pop    %esi
  803bfe:	5d                   	pop    %ebp
  803bff:	90                   	nop
  803c00:	c3                   	ret    
	...

00803c10 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803c10:	55                   	push   %ebp
  803c11:	89 e5                	mov    %esp,%ebp
  803c13:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803c16:	c7 44 24 04 51 54 80 	movl   $0x805451,0x4(%esp)
  803c1d:	00 
  803c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c21:	89 04 24             	mov    %eax,(%esp)
  803c24:	e8 91 cf ff ff       	call   800bba <_Z6strcpyPcPKc>
	return 0;
}
  803c29:	b8 00 00 00 00       	mov    $0x0,%eax
  803c2e:	c9                   	leave  
  803c2f:	c3                   	ret    

00803c30 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803c30:	55                   	push   %ebp
  803c31:	89 e5                	mov    %esp,%ebp
  803c33:	53                   	push   %ebx
  803c34:	83 ec 14             	sub    $0x14,%esp
  803c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803c3a:	89 1c 24             	mov    %ebx,(%esp)
  803c3d:	e8 1a ff ff ff       	call   803b5c <_Z7pagerefPv>
  803c42:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803c44:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803c49:	83 fa 01             	cmp    $0x1,%edx
  803c4c:	75 0b                	jne    803c59 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  803c4e:	8b 43 0c             	mov    0xc(%ebx),%eax
  803c51:	89 04 24             	mov    %eax,(%esp)
  803c54:	e8 fe 02 00 00       	call   803f57 <_Z11nsipc_closei>
	else
		return 0;
}
  803c59:	83 c4 14             	add    $0x14,%esp
  803c5c:	5b                   	pop    %ebx
  803c5d:	5d                   	pop    %ebp
  803c5e:	c3                   	ret    

00803c5f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803c5f:	55                   	push   %ebp
  803c60:	89 e5                	mov    %esp,%ebp
  803c62:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803c65:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803c6c:	00 
  803c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  803c70:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  803c81:	89 04 24             	mov    %eax,(%esp)
  803c84:	e8 c9 03 00 00       	call   804052 <_Z10nsipc_sendiPKvij>
}
  803c89:	c9                   	leave  
  803c8a:	c3                   	ret    

00803c8b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803c8b:	55                   	push   %ebp
  803c8c:	89 e5                	mov    %esp,%ebp
  803c8e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803c91:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803c98:	00 
  803c99:	8b 45 10             	mov    0x10(%ebp),%eax
  803c9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  803caa:	8b 40 0c             	mov    0xc(%eax),%eax
  803cad:	89 04 24             	mov    %eax,(%esp)
  803cb0:	e8 1d 03 00 00       	call   803fd2 <_Z10nsipc_recviPvij>
}
  803cb5:	c9                   	leave  
  803cb6:	c3                   	ret    

00803cb7 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803cb7:	55                   	push   %ebp
  803cb8:	89 e5                	mov    %esp,%ebp
  803cba:	83 ec 28             	sub    $0x28,%esp
  803cbd:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803cc0:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803cc3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803cc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803cc8:	89 04 24             	mov    %eax,(%esp)
  803ccb:	e8 37 de ff ff       	call   801b07 <_Z14fd_find_unusedPP2Fd>
  803cd0:	89 c3                	mov    %eax,%ebx
  803cd2:	85 c0                	test   %eax,%eax
  803cd4:	78 21                	js     803cf7 <_ZL12alloc_sockfdi+0x40>
  803cd6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803cdd:	00 
  803cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ce5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803cec:	e8 af d3 ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  803cf1:	89 c3                	mov    %eax,%ebx
  803cf3:	85 c0                	test   %eax,%eax
  803cf5:	79 14                	jns    803d0b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803cf7:	89 34 24             	mov    %esi,(%esp)
  803cfa:	e8 58 02 00 00       	call   803f57 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803cff:	89 d8                	mov    %ebx,%eax
  803d01:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803d04:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803d07:	89 ec                	mov    %ebp,%esp
  803d09:	5d                   	pop    %ebp
  803d0a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803d0b:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  803d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d14:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d19:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803d20:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803d23:	89 04 24             	mov    %eax,(%esp)
  803d26:	e8 79 dd ff ff       	call   801aa4 <_Z6fd2numP2Fd>
  803d2b:	89 c3                	mov    %eax,%ebx
  803d2d:	eb d0                	jmp    803cff <_ZL12alloc_sockfdi+0x48>

00803d2f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803d2f:	55                   	push   %ebp
  803d30:	89 e5                	mov    %esp,%ebp
  803d32:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803d35:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803d3c:	00 
  803d3d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803d40:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d44:	89 04 24             	mov    %eax,(%esp)
  803d47:	e8 05 dd ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  803d4c:	85 c0                	test   %eax,%eax
  803d4e:	78 15                	js     803d65 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803d50:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803d53:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803d58:	8b 0d 3c 60 80 00    	mov    0x80603c,%ecx
  803d5e:	39 0a                	cmp    %ecx,(%edx)
  803d60:	75 03                	jne    803d65 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803d62:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803d65:	c9                   	leave  
  803d66:	c3                   	ret    

00803d67 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803d67:	55                   	push   %ebp
  803d68:	89 e5                	mov    %esp,%ebp
  803d6a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d70:	e8 ba ff ff ff       	call   803d2f <_ZL9fd2sockidi>
  803d75:	85 c0                	test   %eax,%eax
  803d77:	78 1f                	js     803d98 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803d79:	8b 55 10             	mov    0x10(%ebp),%edx
  803d7c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d83:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d87:	89 04 24             	mov    %eax,(%esp)
  803d8a:	e8 19 01 00 00       	call   803ea8 <_Z12nsipc_acceptiP8sockaddrPj>
  803d8f:	85 c0                	test   %eax,%eax
  803d91:	78 05                	js     803d98 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803d93:	e8 1f ff ff ff       	call   803cb7 <_ZL12alloc_sockfdi>
}
  803d98:	c9                   	leave  
  803d99:	c3                   	ret    

00803d9a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803d9a:	55                   	push   %ebp
  803d9b:	89 e5                	mov    %esp,%ebp
  803d9d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803da0:	8b 45 08             	mov    0x8(%ebp),%eax
  803da3:	e8 87 ff ff ff       	call   803d2f <_ZL9fd2sockidi>
  803da8:	85 c0                	test   %eax,%eax
  803daa:	78 16                	js     803dc2 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803dac:	8b 55 10             	mov    0x10(%ebp),%edx
  803daf:	89 54 24 08          	mov    %edx,0x8(%esp)
  803db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803db6:	89 54 24 04          	mov    %edx,0x4(%esp)
  803dba:	89 04 24             	mov    %eax,(%esp)
  803dbd:	e8 34 01 00 00       	call   803ef6 <_Z10nsipc_bindiP8sockaddrj>
}
  803dc2:	c9                   	leave  
  803dc3:	c3                   	ret    

00803dc4 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803dc4:	55                   	push   %ebp
  803dc5:	89 e5                	mov    %esp,%ebp
  803dc7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803dca:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcd:	e8 5d ff ff ff       	call   803d2f <_ZL9fd2sockidi>
  803dd2:	85 c0                	test   %eax,%eax
  803dd4:	78 0f                	js     803de5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  803dd9:	89 54 24 04          	mov    %edx,0x4(%esp)
  803ddd:	89 04 24             	mov    %eax,(%esp)
  803de0:	e8 50 01 00 00       	call   803f35 <_Z14nsipc_shutdownii>
}
  803de5:	c9                   	leave  
  803de6:	c3                   	ret    

00803de7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803de7:	55                   	push   %ebp
  803de8:	89 e5                	mov    %esp,%ebp
  803dea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ded:	8b 45 08             	mov    0x8(%ebp),%eax
  803df0:	e8 3a ff ff ff       	call   803d2f <_ZL9fd2sockidi>
  803df5:	85 c0                	test   %eax,%eax
  803df7:	78 16                	js     803e0f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803df9:	8b 55 10             	mov    0x10(%ebp),%edx
  803dfc:	89 54 24 08          	mov    %edx,0x8(%esp)
  803e00:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e03:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e07:	89 04 24             	mov    %eax,(%esp)
  803e0a:	e8 62 01 00 00       	call   803f71 <_Z13nsipc_connectiPK8sockaddrj>
}
  803e0f:	c9                   	leave  
  803e10:	c3                   	ret    

00803e11 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803e11:	55                   	push   %ebp
  803e12:	89 e5                	mov    %esp,%ebp
  803e14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e17:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1a:	e8 10 ff ff ff       	call   803d2f <_ZL9fd2sockidi>
  803e1f:	85 c0                	test   %eax,%eax
  803e21:	78 0f                	js     803e32 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e26:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e2a:	89 04 24             	mov    %eax,(%esp)
  803e2d:	e8 7e 01 00 00       	call   803fb0 <_Z12nsipc_listenii>
}
  803e32:	c9                   	leave  
  803e33:	c3                   	ret    

00803e34 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803e34:	55                   	push   %ebp
  803e35:	89 e5                	mov    %esp,%ebp
  803e37:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  803e3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e44:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e48:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4b:	89 04 24             	mov    %eax,(%esp)
  803e4e:	e8 72 02 00 00       	call   8040c5 <_Z12nsipc_socketiii>
  803e53:	85 c0                	test   %eax,%eax
  803e55:	78 05                	js     803e5c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803e57:	e8 5b fe ff ff       	call   803cb7 <_ZL12alloc_sockfdi>
}
  803e5c:	c9                   	leave  
  803e5d:	8d 76 00             	lea    0x0(%esi),%esi
  803e60:	c3                   	ret    
  803e61:	00 00                	add    %al,(%eax)
	...

00803e64 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803e64:	55                   	push   %ebp
  803e65:	89 e5                	mov    %esp,%ebp
  803e67:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803e6a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803e71:	00 
  803e72:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803e79:	00 
  803e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e7e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803e85:	e8 f5 05 00 00       	call   80447f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803e8a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803e91:	00 
  803e92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803e99:	00 
  803e9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ea1:	e8 4a 05 00 00       	call   8043f0 <_Z8ipc_recvPiPvS_>
}
  803ea6:	c9                   	leave  
  803ea7:	c3                   	ret    

00803ea8 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803ea8:	55                   	push   %ebp
  803ea9:	89 e5                	mov    %esp,%ebp
  803eab:	53                   	push   %ebx
  803eac:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb2:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803eb7:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebc:	e8 a3 ff ff ff       	call   803e64 <_ZL5nsipcj>
  803ec1:	89 c3                	mov    %eax,%ebx
  803ec3:	85 c0                	test   %eax,%eax
  803ec5:	78 27                	js     803eee <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803ec7:	a1 10 80 80 00       	mov    0x808010,%eax
  803ecc:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ed0:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803ed7:	00 
  803ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803edb:	89 04 24             	mov    %eax,(%esp)
  803ede:	e8 79 ce ff ff       	call   800d5c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803ee3:	8b 15 10 80 80 00    	mov    0x808010,%edx
  803ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  803eec:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803eee:	89 d8                	mov    %ebx,%eax
  803ef0:	83 c4 14             	add    $0x14,%esp
  803ef3:	5b                   	pop    %ebx
  803ef4:	5d                   	pop    %ebp
  803ef5:	c3                   	ret    

00803ef6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803ef6:	55                   	push   %ebp
  803ef7:	89 e5                	mov    %esp,%ebp
  803ef9:	53                   	push   %ebx
  803efa:	83 ec 14             	sub    $0x14,%esp
  803efd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803f00:	8b 45 08             	mov    0x8(%ebp),%eax
  803f03:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803f08:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f13:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803f1a:	e8 3d ce ff ff       	call   800d5c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803f1f:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803f25:	b8 02 00 00 00       	mov    $0x2,%eax
  803f2a:	e8 35 ff ff ff       	call   803e64 <_ZL5nsipcj>
}
  803f2f:	83 c4 14             	add    $0x14,%esp
  803f32:	5b                   	pop    %ebx
  803f33:	5d                   	pop    %ebp
  803f34:	c3                   	ret    

00803f35 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803f35:	55                   	push   %ebp
  803f36:	89 e5                	mov    %esp,%ebp
  803f38:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f46:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803f4b:	b8 03 00 00 00       	mov    $0x3,%eax
  803f50:	e8 0f ff ff ff       	call   803e64 <_ZL5nsipcj>
}
  803f55:	c9                   	leave  
  803f56:	c3                   	ret    

00803f57 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803f57:	55                   	push   %ebp
  803f58:	89 e5                	mov    %esp,%ebp
  803f5a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f60:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803f65:	b8 04 00 00 00       	mov    $0x4,%eax
  803f6a:	e8 f5 fe ff ff       	call   803e64 <_ZL5nsipcj>
}
  803f6f:	c9                   	leave  
  803f70:	c3                   	ret    

00803f71 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803f71:	55                   	push   %ebp
  803f72:	89 e5                	mov    %esp,%ebp
  803f74:	53                   	push   %ebx
  803f75:	83 ec 14             	sub    $0x14,%esp
  803f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803f83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f8e:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803f95:	e8 c2 cd ff ff       	call   800d5c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803f9a:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803fa0:	b8 05 00 00 00       	mov    $0x5,%eax
  803fa5:	e8 ba fe ff ff       	call   803e64 <_ZL5nsipcj>
}
  803faa:	83 c4 14             	add    $0x14,%esp
  803fad:	5b                   	pop    %ebx
  803fae:	5d                   	pop    %ebp
  803faf:	c3                   	ret    

00803fb0 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803fb0:	55                   	push   %ebp
  803fb1:	89 e5                	mov    %esp,%ebp
  803fb3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb9:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fc1:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803fc6:	b8 06 00 00 00       	mov    $0x6,%eax
  803fcb:	e8 94 fe ff ff       	call   803e64 <_ZL5nsipcj>
}
  803fd0:	c9                   	leave  
  803fd1:	c3                   	ret    

00803fd2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803fd2:	55                   	push   %ebp
  803fd3:	89 e5                	mov    %esp,%ebp
  803fd5:	56                   	push   %esi
  803fd6:	53                   	push   %ebx
  803fd7:	83 ec 10             	sub    $0x10,%esp
  803fda:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe0:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803fe5:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803feb:	8b 45 14             	mov    0x14(%ebp),%eax
  803fee:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ff3:	b8 07 00 00 00       	mov    $0x7,%eax
  803ff8:	e8 67 fe ff ff       	call   803e64 <_ZL5nsipcj>
  803ffd:	89 c3                	mov    %eax,%ebx
  803fff:	85 c0                	test   %eax,%eax
  804001:	78 46                	js     804049 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  804003:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  804008:	7f 04                	jg     80400e <_Z10nsipc_recviPvij+0x3c>
  80400a:	39 f0                	cmp    %esi,%eax
  80400c:	7e 24                	jle    804032 <_Z10nsipc_recviPvij+0x60>
  80400e:	c7 44 24 0c 5d 54 80 	movl   $0x80545d,0xc(%esp)
  804015:	00 
  804016:	c7 44 24 08 b4 4d 80 	movl   $0x804db4,0x8(%esp)
  80401d:	00 
  80401e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  804025:	00 
  804026:	c7 04 24 72 54 80 00 	movl   $0x805472,(%esp)
  80402d:	e8 52 c4 ff ff       	call   800484 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804032:	89 44 24 08          	mov    %eax,0x8(%esp)
  804036:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80403d:	00 
  80403e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804041:	89 04 24             	mov    %eax,(%esp)
  804044:	e8 13 cd ff ff       	call   800d5c <memmove>
	}

	return r;
}
  804049:	89 d8                	mov    %ebx,%eax
  80404b:	83 c4 10             	add    $0x10,%esp
  80404e:	5b                   	pop    %ebx
  80404f:	5e                   	pop    %esi
  804050:	5d                   	pop    %ebp
  804051:	c3                   	ret    

00804052 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804052:	55                   	push   %ebp
  804053:	89 e5                	mov    %esp,%ebp
  804055:	53                   	push   %ebx
  804056:	83 ec 14             	sub    $0x14,%esp
  804059:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80405c:	8b 45 08             	mov    0x8(%ebp),%eax
  80405f:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  804064:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80406a:	7e 24                	jle    804090 <_Z10nsipc_sendiPKvij+0x3e>
  80406c:	c7 44 24 0c 7e 54 80 	movl   $0x80547e,0xc(%esp)
  804073:	00 
  804074:	c7 44 24 08 b4 4d 80 	movl   $0x804db4,0x8(%esp)
  80407b:	00 
  80407c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  804083:	00 
  804084:	c7 04 24 72 54 80 00 	movl   $0x805472,(%esp)
  80408b:	e8 f4 c3 ff ff       	call   800484 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804090:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804094:	8b 45 0c             	mov    0xc(%ebp),%eax
  804097:	89 44 24 04          	mov    %eax,0x4(%esp)
  80409b:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8040a2:	e8 b5 cc ff ff       	call   800d5c <memmove>
	nsipcbuf.send.req_size = size;
  8040a7:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8040ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8040b0:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8040b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8040ba:	e8 a5 fd ff ff       	call   803e64 <_ZL5nsipcj>
}
  8040bf:	83 c4 14             	add    $0x14,%esp
  8040c2:	5b                   	pop    %ebx
  8040c3:	5d                   	pop    %ebp
  8040c4:	c3                   	ret    

008040c5 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8040c5:	55                   	push   %ebp
  8040c6:	89 e5                	mov    %esp,%ebp
  8040c8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8040cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ce:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8040d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040d6:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8040db:	8b 45 10             	mov    0x10(%ebp),%eax
  8040de:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8040e3:	b8 09 00 00 00       	mov    $0x9,%eax
  8040e8:	e8 77 fd ff ff       	call   803e64 <_ZL5nsipcj>
}
  8040ed:	c9                   	leave  
  8040ee:	c3                   	ret    
	...

008040f0 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8040f0:	55                   	push   %ebp
  8040f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8040f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f8:	5d                   	pop    %ebp
  8040f9:	c3                   	ret    

008040fa <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8040fa:	55                   	push   %ebp
  8040fb:	89 e5                	mov    %esp,%ebp
  8040fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804100:	c7 44 24 04 8a 54 80 	movl   $0x80548a,0x4(%esp)
  804107:	00 
  804108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80410b:	89 04 24             	mov    %eax,(%esp)
  80410e:	e8 a7 ca ff ff       	call   800bba <_Z6strcpyPcPKc>
	return 0;
}
  804113:	b8 00 00 00 00       	mov    $0x0,%eax
  804118:	c9                   	leave  
  804119:	c3                   	ret    

0080411a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80411a:	55                   	push   %ebp
  80411b:	89 e5                	mov    %esp,%ebp
  80411d:	57                   	push   %edi
  80411e:	56                   	push   %esi
  80411f:	53                   	push   %ebx
  804120:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804126:	bb 00 00 00 00       	mov    $0x0,%ebx
  80412b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80412f:	74 3e                	je     80416f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804131:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  804137:	8b 75 10             	mov    0x10(%ebp),%esi
  80413a:	29 de                	sub    %ebx,%esi
  80413c:	83 fe 7f             	cmp    $0x7f,%esi
  80413f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  804144:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804147:	89 74 24 08          	mov    %esi,0x8(%esp)
  80414b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80414e:	01 d8                	add    %ebx,%eax
  804150:	89 44 24 04          	mov    %eax,0x4(%esp)
  804154:	89 3c 24             	mov    %edi,(%esp)
  804157:	e8 00 cc ff ff       	call   800d5c <memmove>
		sys_cputs(buf, m);
  80415c:	89 74 24 04          	mov    %esi,0x4(%esp)
  804160:	89 3c 24             	mov    %edi,(%esp)
  804163:	e8 0c ce ff ff       	call   800f74 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804168:	01 f3                	add    %esi,%ebx
  80416a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  80416d:	77 c8                	ja     804137 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80416f:	89 d8                	mov    %ebx,%eax
  804171:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  804177:	5b                   	pop    %ebx
  804178:	5e                   	pop    %esi
  804179:	5f                   	pop    %edi
  80417a:	5d                   	pop    %ebp
  80417b:	c3                   	ret    

0080417c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80417c:	55                   	push   %ebp
  80417d:	89 e5                	mov    %esp,%ebp
  80417f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  804182:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  804187:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80418b:	75 07                	jne    804194 <_ZL12devcons_readP2FdPvj+0x18>
  80418d:	eb 2a                	jmp    8041b9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80418f:	e8 d8 ce ff ff       	call   80106c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804194:	e8 0e ce ff ff       	call   800fa7 <_Z9sys_cgetcv>
  804199:	85 c0                	test   %eax,%eax
  80419b:	74 f2                	je     80418f <_ZL12devcons_readP2FdPvj+0x13>
  80419d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80419f:	85 c0                	test   %eax,%eax
  8041a1:	78 16                	js     8041b9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8041a3:	83 f8 04             	cmp    $0x4,%eax
  8041a6:	74 0c                	je     8041b4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  8041a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041ab:	88 10                	mov    %dl,(%eax)
	return 1;
  8041ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8041b2:	eb 05                	jmp    8041b9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8041b4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8041b9:	c9                   	leave  
  8041ba:	c3                   	ret    

008041bb <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8041bb:	55                   	push   %ebp
  8041bc:	89 e5                	mov    %esp,%ebp
  8041be:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8041c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8041c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8041ce:	00 
  8041cf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8041d2:	89 04 24             	mov    %eax,(%esp)
  8041d5:	e8 9a cd ff ff       	call   800f74 <_Z9sys_cputsPKcj>
}
  8041da:	c9                   	leave  
  8041db:	c3                   	ret    

008041dc <_Z7getcharv>:

int
getchar(void)
{
  8041dc:	55                   	push   %ebp
  8041dd:	89 e5                	mov    %esp,%ebp
  8041df:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8041e2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8041e9:	00 
  8041ea:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8041ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8041f8:	e8 01 dc ff ff       	call   801dfe <_Z4readiPvj>
	if (r < 0)
  8041fd:	85 c0                	test   %eax,%eax
  8041ff:	78 0f                	js     804210 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  804201:	85 c0                	test   %eax,%eax
  804203:	7e 06                	jle    80420b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  804205:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804209:	eb 05                	jmp    804210 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80420b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  804210:	c9                   	leave  
  804211:	c3                   	ret    

00804212 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  804212:	55                   	push   %ebp
  804213:	89 e5                	mov    %esp,%ebp
  804215:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  804218:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80421f:	00 
  804220:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804223:	89 44 24 04          	mov    %eax,0x4(%esp)
  804227:	8b 45 08             	mov    0x8(%ebp),%eax
  80422a:	89 04 24             	mov    %eax,(%esp)
  80422d:	e8 1f d8 ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  804232:	85 c0                	test   %eax,%eax
  804234:	78 11                	js     804247 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  804236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804239:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80423f:	39 10                	cmp    %edx,(%eax)
  804241:	0f 94 c0             	sete   %al
  804244:	0f b6 c0             	movzbl %al,%eax
}
  804247:	c9                   	leave  
  804248:	c3                   	ret    

00804249 <_Z8openconsv>:

int
opencons(void)
{
  804249:	55                   	push   %ebp
  80424a:	89 e5                	mov    %esp,%ebp
  80424c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80424f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804252:	89 04 24             	mov    %eax,(%esp)
  804255:	e8 ad d8 ff ff       	call   801b07 <_Z14fd_find_unusedPP2Fd>
  80425a:	85 c0                	test   %eax,%eax
  80425c:	78 3c                	js     80429a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80425e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804265:	00 
  804266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804269:	89 44 24 04          	mov    %eax,0x4(%esp)
  80426d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804274:	e8 27 ce ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  804279:	85 c0                	test   %eax,%eax
  80427b:	78 1d                	js     80429a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80427d:	8b 15 58 60 80 00    	mov    0x806058,%edx
  804283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804286:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  804288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80428b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  804292:	89 04 24             	mov    %eax,(%esp)
  804295:	e8 0a d8 ff ff       	call   801aa4 <_Z6fd2numP2Fd>
}
  80429a:	c9                   	leave  
  80429b:	c3                   	ret    
  80429c:	00 00                	add    %al,(%eax)
	...

008042a0 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  8042a0:	55                   	push   %ebp
  8042a1:	89 e5                	mov    %esp,%ebp
  8042a3:	56                   	push   %esi
  8042a4:	53                   	push   %ebx
  8042a5:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8042a8:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  8042ad:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  8042b4:	85 c0                	test   %eax,%eax
  8042b6:	74 08                	je     8042c0 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  8042b8:	8d 55 08             	lea    0x8(%ebp),%edx
  8042bb:	89 14 24             	mov    %edx,(%esp)
  8042be:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  8042c0:	83 eb 01             	sub    $0x1,%ebx
  8042c3:	83 fb ff             	cmp    $0xffffffff,%ebx
  8042c6:	75 e5                	jne    8042ad <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  8042c8:	8b 5d 38             	mov    0x38(%ebp),%ebx
  8042cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8042ce:	e8 65 cd ff ff       	call   801038 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  8042d3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  8042d7:	89 74 24 10          	mov    %esi,0x10(%esp)
  8042db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042df:	c7 44 24 08 98 54 80 	movl   $0x805498,0x8(%esp)
  8042e6:	00 
  8042e7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8042ee:	00 
  8042ef:	c7 04 24 1c 55 80 00 	movl   $0x80551c,(%esp)
  8042f6:	e8 89 c1 ff ff       	call   800484 <_Z6_panicPKciS0_z>

008042fb <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  8042fb:	55                   	push   %ebp
  8042fc:	89 e5                	mov    %esp,%ebp
  8042fe:	56                   	push   %esi
  8042ff:	53                   	push   %ebx
  804300:	83 ec 10             	sub    $0x10,%esp
  804303:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804306:	e8 2d cd ff ff       	call   801038 <_Z12sys_getenvidv>
  80430b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80430d:	a1 00 74 80 00       	mov    0x807400,%eax
  804312:	8b 40 5c             	mov    0x5c(%eax),%eax
  804315:	85 c0                	test   %eax,%eax
  804317:	75 4c                	jne    804365 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  804319:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  804320:	00 
  804321:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  804328:	ee 
  804329:	89 34 24             	mov    %esi,(%esp)
  80432c:	e8 6f cd ff ff       	call   8010a0 <_Z14sys_page_allociPvi>
  804331:	85 c0                	test   %eax,%eax
  804333:	74 20                	je     804355 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  804335:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804339:	c7 44 24 08 d0 54 80 	movl   $0x8054d0,0x8(%esp)
  804340:	00 
  804341:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  804348:	00 
  804349:	c7 04 24 1c 55 80 00 	movl   $0x80551c,(%esp)
  804350:	e8 2f c1 ff ff       	call   800484 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  804355:	c7 44 24 04 a0 42 80 	movl   $0x8042a0,0x4(%esp)
  80435c:	00 
  80435d:	89 34 24             	mov    %esi,(%esp)
  804360:	e8 70 cf ff ff       	call   8012d5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804365:	a1 00 90 80 00       	mov    0x809000,%eax
  80436a:	39 d8                	cmp    %ebx,%eax
  80436c:	74 1a                	je     804388 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  80436e:	85 c0                	test   %eax,%eax
  804370:	74 20                	je     804392 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804372:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804377:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  80437e:	39 da                	cmp    %ebx,%edx
  804380:	74 15                	je     804397 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804382:	85 d2                	test   %edx,%edx
  804384:	75 1f                	jne    8043a5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804386:	eb 0f                	jmp    804397 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804388:	b8 00 00 00 00       	mov    $0x0,%eax
  80438d:	8d 76 00             	lea    0x0(%esi),%esi
  804390:	eb 05                	jmp    804397 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804392:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804397:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80439e:	83 c4 10             	add    $0x10,%esp
  8043a1:	5b                   	pop    %ebx
  8043a2:	5e                   	pop    %esi
  8043a3:	5d                   	pop    %ebp
  8043a4:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8043a5:	83 c0 01             	add    $0x1,%eax
  8043a8:	83 f8 08             	cmp    $0x8,%eax
  8043ab:	75 ca                	jne    804377 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  8043ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8043b1:	c7 44 24 08 f4 54 80 	movl   $0x8054f4,0x8(%esp)
  8043b8:	00 
  8043b9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8043c0:	00 
  8043c1:	c7 04 24 1c 55 80 00 	movl   $0x80551c,(%esp)
  8043c8:	e8 b7 c0 ff ff       	call   800484 <_Z6_panicPKciS0_z>
  8043cd:	00 00                	add    %al,(%eax)
	...

008043d0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  8043d0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  8043d3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  8043d4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  8043d7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  8043db:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  8043df:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  8043e2:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  8043e4:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  8043e8:	61                   	popa   
    popf
  8043e9:	9d                   	popf   
    popl %esp
  8043ea:	5c                   	pop    %esp
    ret
  8043eb:	c3                   	ret    

008043ec <spin>:

spin:	jmp spin
  8043ec:	eb fe                	jmp    8043ec <spin>
	...

008043f0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8043f0:	55                   	push   %ebp
  8043f1:	89 e5                	mov    %esp,%ebp
  8043f3:	56                   	push   %esi
  8043f4:	53                   	push   %ebx
  8043f5:	83 ec 10             	sub    $0x10,%esp
  8043f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8043fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043fe:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  804401:	85 c0                	test   %eax,%eax
  804403:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  804408:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  80440b:	89 04 24             	mov    %eax,(%esp)
  80440e:	e8 58 cf ff ff       	call   80136b <_Z12sys_ipc_recvPv>
  804413:	85 c0                	test   %eax,%eax
  804415:	79 16                	jns    80442d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  804417:	85 db                	test   %ebx,%ebx
  804419:	74 06                	je     804421 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  80441b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804421:	85 f6                	test   %esi,%esi
  804423:	74 53                	je     804478 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804425:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80442b:	eb 4b                	jmp    804478 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80442d:	85 db                	test   %ebx,%ebx
  80442f:	74 17                	je     804448 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804431:	e8 02 cc ff ff       	call   801038 <_Z12sys_getenvidv>
  804436:	25 ff 03 00 00       	and    $0x3ff,%eax
  80443b:	6b c0 78             	imul   $0x78,%eax,%eax
  80443e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804443:	8b 40 60             	mov    0x60(%eax),%eax
  804446:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804448:	85 f6                	test   %esi,%esi
  80444a:	74 17                	je     804463 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80444c:	e8 e7 cb ff ff       	call   801038 <_Z12sys_getenvidv>
  804451:	25 ff 03 00 00       	and    $0x3ff,%eax
  804456:	6b c0 78             	imul   $0x78,%eax,%eax
  804459:	05 00 00 00 ef       	add    $0xef000000,%eax
  80445e:	8b 40 70             	mov    0x70(%eax),%eax
  804461:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  804463:	e8 d0 cb ff ff       	call   801038 <_Z12sys_getenvidv>
  804468:	25 ff 03 00 00       	and    $0x3ff,%eax
  80446d:	6b c0 78             	imul   $0x78,%eax,%eax
  804470:	05 08 00 00 ef       	add    $0xef000008,%eax
  804475:	8b 40 60             	mov    0x60(%eax),%eax

}
  804478:	83 c4 10             	add    $0x10,%esp
  80447b:	5b                   	pop    %ebx
  80447c:	5e                   	pop    %esi
  80447d:	5d                   	pop    %ebp
  80447e:	c3                   	ret    

0080447f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80447f:	55                   	push   %ebp
  804480:	89 e5                	mov    %esp,%ebp
  804482:	57                   	push   %edi
  804483:	56                   	push   %esi
  804484:	53                   	push   %ebx
  804485:	83 ec 1c             	sub    $0x1c,%esp
  804488:	8b 75 08             	mov    0x8(%ebp),%esi
  80448b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80448e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  804491:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  804493:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  804498:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  80449b:	8b 45 14             	mov    0x14(%ebp),%eax
  80449e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8044a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8044aa:	89 34 24             	mov    %esi,(%esp)
  8044ad:	e8 81 ce ff ff       	call   801333 <_Z16sys_ipc_try_sendijPvi>
  8044b2:	85 c0                	test   %eax,%eax
  8044b4:	79 31                	jns    8044e7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  8044b6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8044b9:	75 0c                	jne    8044c7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  8044bb:	90                   	nop
  8044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8044c0:	e8 a7 cb ff ff       	call   80106c <_Z9sys_yieldv>
  8044c5:	eb d4                	jmp    80449b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  8044c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044cb:	c7 44 24 08 2a 55 80 	movl   $0x80552a,0x8(%esp)
  8044d2:	00 
  8044d3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8044da:	00 
  8044db:	c7 04 24 37 55 80 00 	movl   $0x805537,(%esp)
  8044e2:	e8 9d bf ff ff       	call   800484 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  8044e7:	83 c4 1c             	add    $0x1c,%esp
  8044ea:	5b                   	pop    %ebx
  8044eb:	5e                   	pop    %esi
  8044ec:	5f                   	pop    %edi
  8044ed:	5d                   	pop    %ebp
  8044ee:	c3                   	ret    
	...

008044f0 <__udivdi3>:
  8044f0:	55                   	push   %ebp
  8044f1:	89 e5                	mov    %esp,%ebp
  8044f3:	57                   	push   %edi
  8044f4:	56                   	push   %esi
  8044f5:	83 ec 20             	sub    $0x20,%esp
  8044f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8044fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8044fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804501:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804504:	85 c0                	test   %eax,%eax
  804506:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804509:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80450c:	75 3a                	jne    804548 <__udivdi3+0x58>
  80450e:	39 f9                	cmp    %edi,%ecx
  804510:	77 66                	ja     804578 <__udivdi3+0x88>
  804512:	85 c9                	test   %ecx,%ecx
  804514:	75 0b                	jne    804521 <__udivdi3+0x31>
  804516:	b8 01 00 00 00       	mov    $0x1,%eax
  80451b:	31 d2                	xor    %edx,%edx
  80451d:	f7 f1                	div    %ecx
  80451f:	89 c1                	mov    %eax,%ecx
  804521:	89 f8                	mov    %edi,%eax
  804523:	31 d2                	xor    %edx,%edx
  804525:	f7 f1                	div    %ecx
  804527:	89 c7                	mov    %eax,%edi
  804529:	89 f0                	mov    %esi,%eax
  80452b:	f7 f1                	div    %ecx
  80452d:	89 fa                	mov    %edi,%edx
  80452f:	89 c6                	mov    %eax,%esi
  804531:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804534:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80453a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80453d:	83 c4 20             	add    $0x20,%esp
  804540:	5e                   	pop    %esi
  804541:	5f                   	pop    %edi
  804542:	5d                   	pop    %ebp
  804543:	c3                   	ret    
  804544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804548:	31 d2                	xor    %edx,%edx
  80454a:	31 f6                	xor    %esi,%esi
  80454c:	39 f8                	cmp    %edi,%eax
  80454e:	77 e1                	ja     804531 <__udivdi3+0x41>
  804550:	0f bd d0             	bsr    %eax,%edx
  804553:	83 f2 1f             	xor    $0x1f,%edx
  804556:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804559:	75 2d                	jne    804588 <__udivdi3+0x98>
  80455b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80455e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804561:	76 06                	jbe    804569 <__udivdi3+0x79>
  804563:	39 f8                	cmp    %edi,%eax
  804565:	89 f2                	mov    %esi,%edx
  804567:	73 c8                	jae    804531 <__udivdi3+0x41>
  804569:	31 d2                	xor    %edx,%edx
  80456b:	be 01 00 00 00       	mov    $0x1,%esi
  804570:	eb bf                	jmp    804531 <__udivdi3+0x41>
  804572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804578:	89 f0                	mov    %esi,%eax
  80457a:	89 fa                	mov    %edi,%edx
  80457c:	f7 f1                	div    %ecx
  80457e:	31 d2                	xor    %edx,%edx
  804580:	89 c6                	mov    %eax,%esi
  804582:	eb ad                	jmp    804531 <__udivdi3+0x41>
  804584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804588:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80458c:	89 c2                	mov    %eax,%edx
  80458e:	b8 20 00 00 00       	mov    $0x20,%eax
  804593:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804596:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804599:	d3 e2                	shl    %cl,%edx
  80459b:	89 c1                	mov    %eax,%ecx
  80459d:	d3 ee                	shr    %cl,%esi
  80459f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045a3:	09 d6                	or     %edx,%esi
  8045a5:	89 fa                	mov    %edi,%edx
  8045a7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8045aa:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8045ad:	d3 e6                	shl    %cl,%esi
  8045af:	89 c1                	mov    %eax,%ecx
  8045b1:	d3 ea                	shr    %cl,%edx
  8045b3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045b7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8045ba:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8045bd:	d3 e7                	shl    %cl,%edi
  8045bf:	89 c1                	mov    %eax,%ecx
  8045c1:	d3 ee                	shr    %cl,%esi
  8045c3:	09 fe                	or     %edi,%esi
  8045c5:	89 f0                	mov    %esi,%eax
  8045c7:	f7 75 e4             	divl   -0x1c(%ebp)
  8045ca:	89 d7                	mov    %edx,%edi
  8045cc:	89 c6                	mov    %eax,%esi
  8045ce:	f7 65 f0             	mull   -0x10(%ebp)
  8045d1:	39 d7                	cmp    %edx,%edi
  8045d3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8045d6:	72 12                	jb     8045ea <__udivdi3+0xfa>
  8045d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8045db:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045df:	d3 e2                	shl    %cl,%edx
  8045e1:	39 c2                	cmp    %eax,%edx
  8045e3:	73 08                	jae    8045ed <__udivdi3+0xfd>
  8045e5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  8045e8:	75 03                	jne    8045ed <__udivdi3+0xfd>
  8045ea:	83 ee 01             	sub    $0x1,%esi
  8045ed:	31 d2                	xor    %edx,%edx
  8045ef:	e9 3d ff ff ff       	jmp    804531 <__udivdi3+0x41>
	...

00804600 <__umoddi3>:
  804600:	55                   	push   %ebp
  804601:	89 e5                	mov    %esp,%ebp
  804603:	57                   	push   %edi
  804604:	56                   	push   %esi
  804605:	83 ec 20             	sub    $0x20,%esp
  804608:	8b 7d 14             	mov    0x14(%ebp),%edi
  80460b:	8b 45 08             	mov    0x8(%ebp),%eax
  80460e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804611:	8b 75 0c             	mov    0xc(%ebp),%esi
  804614:	85 ff                	test   %edi,%edi
  804616:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804619:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80461c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80461f:	89 f2                	mov    %esi,%edx
  804621:	75 15                	jne    804638 <__umoddi3+0x38>
  804623:	39 f1                	cmp    %esi,%ecx
  804625:	76 41                	jbe    804668 <__umoddi3+0x68>
  804627:	f7 f1                	div    %ecx
  804629:	89 d0                	mov    %edx,%eax
  80462b:	31 d2                	xor    %edx,%edx
  80462d:	83 c4 20             	add    $0x20,%esp
  804630:	5e                   	pop    %esi
  804631:	5f                   	pop    %edi
  804632:	5d                   	pop    %ebp
  804633:	c3                   	ret    
  804634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804638:	39 f7                	cmp    %esi,%edi
  80463a:	77 4c                	ja     804688 <__umoddi3+0x88>
  80463c:	0f bd c7             	bsr    %edi,%eax
  80463f:	83 f0 1f             	xor    $0x1f,%eax
  804642:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804645:	75 51                	jne    804698 <__umoddi3+0x98>
  804647:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  80464a:	0f 87 e8 00 00 00    	ja     804738 <__umoddi3+0x138>
  804650:	89 f2                	mov    %esi,%edx
  804652:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804655:	29 ce                	sub    %ecx,%esi
  804657:	19 fa                	sbb    %edi,%edx
  804659:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80465c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80465f:	83 c4 20             	add    $0x20,%esp
  804662:	5e                   	pop    %esi
  804663:	5f                   	pop    %edi
  804664:	5d                   	pop    %ebp
  804665:	c3                   	ret    
  804666:	66 90                	xchg   %ax,%ax
  804668:	85 c9                	test   %ecx,%ecx
  80466a:	75 0b                	jne    804677 <__umoddi3+0x77>
  80466c:	b8 01 00 00 00       	mov    $0x1,%eax
  804671:	31 d2                	xor    %edx,%edx
  804673:	f7 f1                	div    %ecx
  804675:	89 c1                	mov    %eax,%ecx
  804677:	89 f0                	mov    %esi,%eax
  804679:	31 d2                	xor    %edx,%edx
  80467b:	f7 f1                	div    %ecx
  80467d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804680:	eb a5                	jmp    804627 <__umoddi3+0x27>
  804682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804688:	89 f2                	mov    %esi,%edx
  80468a:	83 c4 20             	add    $0x20,%esp
  80468d:	5e                   	pop    %esi
  80468e:	5f                   	pop    %edi
  80468f:	5d                   	pop    %ebp
  804690:	c3                   	ret    
  804691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804698:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80469c:	89 f2                	mov    %esi,%edx
  80469e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8046a1:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  8046a8:	29 45 f0             	sub    %eax,-0x10(%ebp)
  8046ab:	d3 e7                	shl    %cl,%edi
  8046ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8046b4:	d3 e8                	shr    %cl,%eax
  8046b6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8046ba:	09 f8                	or     %edi,%eax
  8046bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8046bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046c2:	d3 e0                	shl    %cl,%eax
  8046c4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8046c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8046cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046ce:	d3 ea                	shr    %cl,%edx
  8046d0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8046d4:	d3 e6                	shl    %cl,%esi
  8046d6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8046da:	d3 e8                	shr    %cl,%eax
  8046dc:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8046e0:	09 f0                	or     %esi,%eax
  8046e2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8046e5:	f7 75 e4             	divl   -0x1c(%ebp)
  8046e8:	d3 e6                	shl    %cl,%esi
  8046ea:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8046ed:	89 d6                	mov    %edx,%esi
  8046ef:	f7 65 f4             	mull   -0xc(%ebp)
  8046f2:	89 d7                	mov    %edx,%edi
  8046f4:	89 c2                	mov    %eax,%edx
  8046f6:	39 fe                	cmp    %edi,%esi
  8046f8:	89 f9                	mov    %edi,%ecx
  8046fa:	72 30                	jb     80472c <__umoddi3+0x12c>
  8046fc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8046ff:	72 27                	jb     804728 <__umoddi3+0x128>
  804701:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804704:	29 d0                	sub    %edx,%eax
  804706:	19 ce                	sbb    %ecx,%esi
  804708:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80470c:	89 f2                	mov    %esi,%edx
  80470e:	d3 e8                	shr    %cl,%eax
  804710:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804714:	d3 e2                	shl    %cl,%edx
  804716:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80471a:	09 d0                	or     %edx,%eax
  80471c:	89 f2                	mov    %esi,%edx
  80471e:	d3 ea                	shr    %cl,%edx
  804720:	83 c4 20             	add    $0x20,%esp
  804723:	5e                   	pop    %esi
  804724:	5f                   	pop    %edi
  804725:	5d                   	pop    %ebp
  804726:	c3                   	ret    
  804727:	90                   	nop
  804728:	39 fe                	cmp    %edi,%esi
  80472a:	75 d5                	jne    804701 <__umoddi3+0x101>
  80472c:	89 f9                	mov    %edi,%ecx
  80472e:	89 c2                	mov    %eax,%edx
  804730:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804733:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804736:	eb c9                	jmp    804701 <__umoddi3+0x101>
  804738:	39 f7                	cmp    %esi,%edi
  80473a:	0f 82 10 ff ff ff    	jb     804650 <__umoddi3+0x50>
  804740:	e9 17 ff ff ff       	jmp    80465c <__umoddi3+0x5c>
