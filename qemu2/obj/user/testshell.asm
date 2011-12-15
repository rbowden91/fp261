
obj/user/testshell:     file format elf32-i386


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
  80002c:	e8 5b 05 00 00       	call   80058c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z5wrongiii>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  800040:	8b 7d 08             	mov    0x8(%ebp),%edi
  800043:	8b 75 0c             	mov    0xc(%ebp),%esi
  800046:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800049:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004d:	89 3c 24             	mov    %edi,(%esp)
  800050:	e8 d6 28 00 00       	call   80292b <_Z4seekii>
	seek(kfd, off);
  800055:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800059:	89 34 24             	mov    %esi,(%esp)
  80005c:	e8 ca 28 00 00       	call   80292b <_Z4seekii>

	cprintf("shell produced incorrect output.\n");
  800061:	c7 04 24 80 4f 80 00 	movl   $0x804f80,(%esp)
  800068:	e8 c1 06 00 00       	call   80072e <_Z7cprintfPKcz>
	cprintf("expected:\n===\n");
  80006d:	c7 04 24 1b 50 80 00 	movl   $0x80501b,(%esp)
  800074:	e8 b5 06 00 00       	call   80072e <_Z7cprintfPKcz>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800079:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007c:	eb 0c                	jmp    80008a <_Z5wrongiii+0x56>
		sys_cputs(buf, n);
  80007e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800082:	89 1c 24             	mov    %ebx,(%esp)
  800085:	e8 7a 10 00 00       	call   801104 <_Z9sys_cputsPKcj>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  80008a:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  800091:	00 
  800092:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800096:	89 34 24             	mov    %esi,(%esp)
  800099:	e8 30 27 00 00       	call   8027ce <_Z4readiPvj>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7f dc                	jg     80007e <_Z5wrongiii+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000a2:	c7 04 24 2a 50 80 00 	movl   $0x80502a,(%esp)
  8000a9:	e8 80 06 00 00       	call   80072e <_Z7cprintfPKcz>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ae:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b1:	eb 0c                	jmp    8000bf <_Z5wrongiii+0x8b>
		sys_cputs(buf, n);
  8000b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b7:	89 1c 24             	mov    %ebx,(%esp)
  8000ba:	e8 45 10 00 00       	call   801104 <_Z9sys_cputsPKcj>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bf:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000c6:	00 
  8000c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000cb:	89 3c 24             	mov    %edi,(%esp)
  8000ce:	e8 fb 26 00 00       	call   8027ce <_Z4readiPvj>
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	7f dc                	jg     8000b3 <_Z5wrongiii+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000d7:	c7 04 24 25 50 80 00 	movl   $0x805025,(%esp)
  8000de:	e8 4b 06 00 00       	call   80072e <_Z7cprintfPKcz>
	exit();
  8000e3:	e8 0c 05 00 00       	call   8005f4 <_Z4exitv>
}
  8000e8:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <_Z5umainiPPc>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;

	close(0);
  8000fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800103:	e8 1d 25 00 00       	call   802625 <_Z5closei>
	close(1);
  800108:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010f:	e8 11 25 00 00       	call   802625 <_Z5closei>
	opencons();
  800114:	e8 20 04 00 00       	call   800539 <_Z8openconsv>
	opencons();
  800119:	e8 1b 04 00 00       	call   800539 <_Z8openconsv>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80011e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 38 50 80 00 	movl   $0x805038,(%esp)
  80012d:	e8 2c 33 00 00       	call   80345e <_Z4openPKci>
  800132:	89 c6                	mov    %eax,%esi
  800134:	85 c0                	test   %eax,%eax
  800136:	79 20                	jns    800158 <_Z5umainiPPc+0x65>
		panic("open testshell.sh: %e", rfd);
  800138:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013c:	c7 44 24 08 45 50 80 	movl   $0x805045,0x8(%esp)
  800143:	00 
  800144:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  80014b:	00 
  80014c:	c7 04 24 5b 50 80 00 	movl   $0x80505b,(%esp)
  800153:	e8 b8 04 00 00       	call   800610 <_Z6_panicPKciS0_z>
	if ((wfd = open("testshell.out", O_WRONLY|O_CREAT|O_TRUNC)) < 0)
  800158:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  80015f:	00 
  800160:	c7 04 24 6c 50 80 00 	movl   $0x80506c,(%esp)
  800167:	e8 f2 32 00 00       	call   80345e <_Z4openPKci>
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	85 c0                	test   %eax,%eax
  800170:	79 20                	jns    800192 <_Z5umainiPPc+0x9f>
		panic("open testshell.out: %e", wfd);
  800172:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800176:	c7 44 24 08 7a 50 80 	movl   $0x80507a,0x8(%esp)
  80017d:	00 
  80017e:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
  800185:	00 
  800186:	c7 04 24 5b 50 80 00 	movl   $0x80505b,(%esp)
  80018d:	e8 7e 04 00 00       	call   800610 <_Z6_panicPKciS0_z>

	cprintf("running sh -x < testshell.sh > testshell.out\n");
  800192:	c7 04 24 a4 4f 80 00 	movl   $0x804fa4,(%esp)
  800199:	e8 90 05 00 00       	call   80072e <_Z7cprintfPKcz>
	if ((r = fork()) < 0)
  80019e:	e8 ca 16 00 00       	call   80186d <_Z4forkv>
  8001a3:	89 c3                	mov    %eax,%ebx
  8001a5:	85 c0                	test   %eax,%eax
  8001a7:	79 20                	jns    8001c9 <_Z5umainiPPc+0xd6>
		panic("fork: %e", r);
  8001a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ad:	c7 44 24 08 08 55 80 	movl   $0x805508,0x8(%esp)
  8001b4:	00 
  8001b5:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  8001bc:	00 
  8001bd:	c7 04 24 5b 50 80 00 	movl   $0x80505b,(%esp)
  8001c4:	e8 47 04 00 00       	call   800610 <_Z6_panicPKciS0_z>
	if (r == 0) {
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	0f 85 9f 00 00 00    	jne    800270 <_Z5umainiPPc+0x17d>
		dup(rfd, 0);
  8001d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001d8:	00 
  8001d9:	89 34 24             	mov    %esi,(%esp)
  8001dc:	e8 9f 24 00 00       	call   802680 <_Z3dupii>
		dup(wfd, 1);
  8001e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001e8:	00 
  8001e9:	89 3c 24             	mov    %edi,(%esp)
  8001ec:	e8 8f 24 00 00       	call   802680 <_Z3dupii>
		close(rfd);
  8001f1:	89 34 24             	mov    %esi,(%esp)
  8001f4:	e8 2c 24 00 00       	call   802625 <_Z5closei>
		close(wfd);
  8001f9:	89 3c 24             	mov    %edi,(%esp)
  8001fc:	e8 24 24 00 00       	call   802625 <_Z5closei>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  800201:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800208:	00 
  800209:	c7 44 24 08 91 50 80 	movl   $0x805091,0x8(%esp)
  800210:	00 
  800211:	c7 44 24 04 42 50 80 	movl   $0x805042,0x4(%esp)
  800218:	00 
  800219:	c7 04 24 94 50 80 00 	movl   $0x805094,(%esp)
  800220:	e8 60 21 00 00       	call   802385 <_Z6spawnlPKcS0_z>
  800225:	89 c3                	mov    %eax,%ebx
  800227:	85 c0                	test   %eax,%eax
  800229:	79 20                	jns    80024b <_Z5umainiPPc+0x158>
			panic("spawn: %e", r);
  80022b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80022f:	c7 44 24 08 98 50 80 	movl   $0x805098,0x8(%esp)
  800236:	00 
  800237:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80023e:	00 
  80023f:	c7 04 24 5b 50 80 00 	movl   $0x80505b,(%esp)
  800246:	e8 c5 03 00 00       	call   800610 <_Z6_panicPKciS0_z>
		close(0);
  80024b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800252:	e8 ce 23 00 00       	call   802625 <_Z5closei>
		close(1);
  800257:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80025e:	e8 c2 23 00 00       	call   802625 <_Z5closei>
		wait(r);
  800263:	89 1c 24             	mov    %ebx,(%esp)
  800266:	e8 05 43 00 00       	call   804570 <_Z4waiti>
		exit();
  80026b:	e8 84 03 00 00       	call   8005f4 <_Z4exitv>
	}
	close(rfd);
  800270:	89 34 24             	mov    %esi,(%esp)
  800273:	e8 ad 23 00 00       	call   802625 <_Z5closei>
	close(wfd);
  800278:	89 3c 24             	mov    %edi,(%esp)
  80027b:	e8 a5 23 00 00       	call   802625 <_Z5closei>
	wait(r);
  800280:	89 1c 24             	mov    %ebx,(%esp)
  800283:	e8 e8 42 00 00       	call   804570 <_Z4waiti>

	if ((rfd = open("testshell.out", O_RDONLY)) < 0)
  800288:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80028f:	00 
  800290:	c7 04 24 6c 50 80 00 	movl   $0x80506c,(%esp)
  800297:	e8 c2 31 00 00       	call   80345e <_Z4openPKci>
  80029c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	79 20                	jns    8002c3 <_Z5umainiPPc+0x1d0>
		panic("open testshell.out for reading: %e", rfd);
  8002a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a7:	c7 44 24 08 d4 4f 80 	movl   $0x804fd4,0x8(%esp)
  8002ae:	00 
  8002af:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  8002b6:	00 
  8002b7:	c7 04 24 5b 50 80 00 	movl   $0x80505b,(%esp)
  8002be:	e8 4d 03 00 00       	call   800610 <_Z6_panicPKciS0_z>
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002ca:	00 
  8002cb:	c7 04 24 a2 50 80 00 	movl   $0x8050a2,(%esp)
  8002d2:	e8 87 31 00 00       	call   80345e <_Z4openPKci>
  8002d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	79 20                	jns    8002fe <_Z5umainiPPc+0x20b>
		panic("open testshell.key for reading: %e", kfd);
  8002de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e2:	c7 44 24 08 f8 4f 80 	movl   $0x804ff8,0x8(%esp)
  8002e9:	00 
  8002ea:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002f1:	00 
  8002f2:	c7 04 24 5b 50 80 00 	movl   $0x80505b,(%esp)
  8002f9:	e8 12 03 00 00       	call   800610 <_Z6_panicPKciS0_z>
	close(wfd);
	wait(r);

	if ((rfd = open("testshell.out", O_RDONLY)) < 0)
		panic("open testshell.out for reading: %e", rfd);
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002fe:	bf 01 00 00 00       	mov    $0x1,%edi
  800303:	be 00 00 00 00       	mov    $0x0,%esi
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  800308:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80030f:	00 
  800310:	8d 45 e7             	lea    -0x19(%ebp),%eax
  800313:	89 44 24 04          	mov    %eax,0x4(%esp)
  800317:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80031a:	89 14 24             	mov    %edx,(%esp)
  80031d:	e8 ac 24 00 00       	call   8027ce <_Z4readiPvj>
  800322:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  800324:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80032b:	00 
  80032c:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  80032f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800333:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800336:	89 14 24             	mov    %edx,(%esp)
  800339:	e8 90 24 00 00       	call   8027ce <_Z4readiPvj>
		if (n1 < 0)
  80033e:	85 db                	test   %ebx,%ebx
  800340:	79 20                	jns    800362 <_Z5umainiPPc+0x26f>
			panic("reading testshell.out: %e", n1);
  800342:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800346:	c7 44 24 08 b0 50 80 	movl   $0x8050b0,0x8(%esp)
  80034d:	00 
  80034e:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  800355:	00 
  800356:	c7 04 24 5b 50 80 00 	movl   $0x80505b,(%esp)
  80035d:	e8 ae 02 00 00       	call   800610 <_Z6_panicPKciS0_z>
		if (n2 < 0)
  800362:	85 c0                	test   %eax,%eax
  800364:	79 20                	jns    800386 <_Z5umainiPPc+0x293>
			panic("reading testshell.key: %e", n2);
  800366:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80036a:	c7 44 24 08 ca 50 80 	movl   $0x8050ca,0x8(%esp)
  800371:	00 
  800372:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800379:	00 
  80037a:	c7 04 24 5b 50 80 00 	movl   $0x80505b,(%esp)
  800381:	e8 8a 02 00 00       	call   800610 <_Z6_panicPKciS0_z>
		if (n1 == 0 && n2 == 0)
  800386:	89 c2                	mov    %eax,%edx
  800388:	09 da                	or     %ebx,%edx
  80038a:	74 38                	je     8003c4 <_Z5umainiPPc+0x2d1>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  80038c:	83 fb 01             	cmp    $0x1,%ebx
  80038f:	75 0e                	jne    80039f <_Z5umainiPPc+0x2ac>
  800391:	83 f8 01             	cmp    $0x1,%eax
  800394:	75 09                	jne    80039f <_Z5umainiPPc+0x2ac>
  800396:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  80039a:	38 45 e7             	cmp    %al,-0x19(%ebp)
  80039d:	74 16                	je     8003b5 <_Z5umainiPPc+0x2c2>
			wrong(rfd, kfd, nloff);
  80039f:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003a3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8003a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ad:	89 04 24             	mov    %eax,(%esp)
  8003b0:	e8 7f fc ff ff       	call   800034 <_Z5wrongiii>
		if (c1 == '\n')
  8003b5:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8003b9:	0f 44 f7             	cmove  %edi,%esi
  8003bc:	83 c7 01             	add    $0x1,%edi
		panic("open testshell.out for reading: %e", rfd);
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  8003bf:	e9 44 ff ff ff       	jmp    800308 <_Z5umainiPPc+0x215>
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
	cprintf("shell ran correctly\n");
  8003c4:	c7 04 24 e4 50 80 00 	movl   $0x8050e4,(%esp)
  8003cb:	e8 5e 03 00 00       	call   80072e <_Z7cprintfPKcz>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8003d0:	cc                   	int3   

	breakpoint();
}
  8003d1:	83 c4 3c             	add    $0x3c,%esp
  8003d4:	5b                   	pop    %ebx
  8003d5:	5e                   	pop    %esi
  8003d6:	5f                   	pop    %edi
  8003d7:	5d                   	pop    %ebp
  8003d8:	c3                   	ret    
  8003d9:	00 00                	add    %al,(%eax)
  8003db:	00 00                	add    %al,(%eax)
  8003dd:	00 00                	add    %al,(%eax)
	...

008003e0 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	5d                   	pop    %ebp
  8003e9:	c3                   	ret    

008003ea <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003ea:	55                   	push   %ebp
  8003eb:	89 e5                	mov    %esp,%ebp
  8003ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8003f0:	c7 44 24 04 f9 50 80 	movl   $0x8050f9,0x4(%esp)
  8003f7:	00 
  8003f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fb:	89 04 24             	mov    %eax,(%esp)
  8003fe:	e8 47 09 00 00       	call   800d4a <_Z6strcpyPcPKc>
	return 0;
}
  800403:	b8 00 00 00 00       	mov    $0x0,%eax
  800408:	c9                   	leave  
  800409:	c3                   	ret    

0080040a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	57                   	push   %edi
  80040e:	56                   	push   %esi
  80040f:	53                   	push   %ebx
  800410:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800416:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80041f:	74 3e                	je     80045f <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800421:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  800427:	8b 75 10             	mov    0x10(%ebp),%esi
  80042a:	29 de                	sub    %ebx,%esi
  80042c:	83 fe 7f             	cmp    $0x7f,%esi
  80042f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800434:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800437:	89 74 24 08          	mov    %esi,0x8(%esp)
  80043b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043e:	01 d8                	add    %ebx,%eax
  800440:	89 44 24 04          	mov    %eax,0x4(%esp)
  800444:	89 3c 24             	mov    %edi,(%esp)
  800447:	e8 a0 0a 00 00       	call   800eec <memmove>
		sys_cputs(buf, m);
  80044c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800450:	89 3c 24             	mov    %edi,(%esp)
  800453:	e8 ac 0c 00 00       	call   801104 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800458:	01 f3                	add    %esi,%ebx
  80045a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  80045d:	77 c8                	ja     800427 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80045f:	89 d8                	mov    %ebx,%eax
  800461:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800467:	5b                   	pop    %ebx
  800468:	5e                   	pop    %esi
  800469:	5f                   	pop    %edi
  80046a:	5d                   	pop    %ebp
  80046b:	c3                   	ret    

0080046c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  800477:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80047b:	75 07                	jne    800484 <_ZL12devcons_readP2FdPvj+0x18>
  80047d:	eb 2a                	jmp    8004a9 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80047f:	e8 78 0d 00 00       	call   8011fc <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800484:	e8 ae 0c 00 00       	call   801137 <_Z9sys_cgetcv>
  800489:	85 c0                	test   %eax,%eax
  80048b:	74 f2                	je     80047f <_ZL12devcons_readP2FdPvj+0x13>
  80048d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80048f:	85 c0                	test   %eax,%eax
  800491:	78 16                	js     8004a9 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800493:	83 f8 04             	cmp    $0x4,%eax
  800496:	74 0c                	je     8004a4 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	88 10                	mov    %dl,(%eax)
	return 1;
  80049d:	b8 01 00 00 00       	mov    $0x1,%eax
  8004a2:	eb 05                	jmp    8004a9 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8004a4:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8004a9:	c9                   	leave  
  8004aa:	c3                   	ret    

008004ab <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
  8004ae:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8004b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8004be:	00 
  8004bf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8004c2:	89 04 24             	mov    %eax,(%esp)
  8004c5:	e8 3a 0c 00 00       	call   801104 <_Z9sys_cputsPKcj>
}
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <_Z7getcharv>:

int
getchar(void)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8004d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8004d9:	00 
  8004da:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8004dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004e8:	e8 e1 22 00 00       	call   8027ce <_Z4readiPvj>
	if (r < 0)
  8004ed:	85 c0                	test   %eax,%eax
  8004ef:	78 0f                	js     800500 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  8004f1:	85 c0                	test   %eax,%eax
  8004f3:	7e 06                	jle    8004fb <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  8004f5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8004f9:	eb 05                	jmp    800500 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8004fb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  800500:	c9                   	leave  
  800501:	c3                   	ret    

00800502 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  800508:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80050f:	00 
  800510:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800513:	89 44 24 04          	mov    %eax,0x4(%esp)
  800517:	8b 45 08             	mov    0x8(%ebp),%eax
  80051a:	89 04 24             	mov    %eax,(%esp)
  80051d:	e8 ff 1e 00 00       	call   802421 <_Z9fd_lookupiPP2Fdb>
  800522:	85 c0                	test   %eax,%eax
  800524:	78 11                	js     800537 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  800526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800529:	8b 15 00 60 80 00    	mov    0x806000,%edx
  80052f:	39 10                	cmp    %edx,(%eax)
  800531:	0f 94 c0             	sete   %al
  800534:	0f b6 c0             	movzbl %al,%eax
}
  800537:	c9                   	leave  
  800538:	c3                   	ret    

00800539 <_Z8openconsv>:

int
opencons(void)
{
  800539:	55                   	push   %ebp
  80053a:	89 e5                	mov    %esp,%ebp
  80053c:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  80053f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800542:	89 04 24             	mov    %eax,(%esp)
  800545:	e8 8d 1f 00 00       	call   8024d7 <_Z14fd_find_unusedPP2Fd>
  80054a:	85 c0                	test   %eax,%eax
  80054c:	78 3c                	js     80058a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80054e:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800555:	00 
  800556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800559:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800564:	e8 c7 0c 00 00       	call   801230 <_Z14sys_page_allociPvi>
  800569:	85 c0                	test   %eax,%eax
  80056b:	78 1d                	js     80058a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80056d:	8b 15 00 60 80 00    	mov    0x806000,%edx
  800573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800582:	89 04 24             	mov    %eax,(%esp)
  800585:	e8 ea 1e 00 00       	call   802474 <_Z6fd2numP2Fd>
}
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    

0080058c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	57                   	push   %edi
  800590:	56                   	push   %esi
  800591:	53                   	push   %ebx
  800592:	83 ec 1c             	sub    $0x1c,%esp
  800595:	8b 7d 08             	mov    0x8(%ebp),%edi
  800598:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  80059b:	e8 28 0c 00 00       	call   8011c8 <_Z12sys_getenvidv>
  8005a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005a5:	6b c0 78             	imul   $0x78,%eax,%eax
  8005a8:	05 00 00 00 ef       	add    $0xef000000,%eax
  8005ad:	a3 00 70 80 00       	mov    %eax,0x807000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005b2:	85 ff                	test   %edi,%edi
  8005b4:	7e 07                	jle    8005bd <libmain+0x31>
		binaryname = argv[0];
  8005b6:	8b 06                	mov    (%esi),%eax
  8005b8:	a3 1c 60 80 00       	mov    %eax,0x80601c

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8005bd:	b8 29 5d 80 00       	mov    $0x805d29,%eax
  8005c2:	3d 29 5d 80 00       	cmp    $0x805d29,%eax
  8005c7:	76 0f                	jbe    8005d8 <libmain+0x4c>
  8005c9:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  8005cb:	83 eb 04             	sub    $0x4,%ebx
  8005ce:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  8005d0:	81 fb 29 5d 80 00    	cmp    $0x805d29,%ebx
  8005d6:	77 f3                	ja     8005cb <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  8005d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005dc:	89 3c 24             	mov    %edi,(%esp)
  8005df:	e8 0f fb ff ff       	call   8000f3 <_Z5umainiPPc>

	// exit gracefully
	exit();
  8005e4:	e8 0b 00 00 00       	call   8005f4 <_Z4exitv>
}
  8005e9:	83 c4 1c             	add    $0x1c,%esp
  8005ec:	5b                   	pop    %ebx
  8005ed:	5e                   	pop    %esi
  8005ee:	5f                   	pop    %edi
  8005ef:	5d                   	pop    %ebp
  8005f0:	c3                   	ret    
  8005f1:	00 00                	add    %al,(%eax)
	...

008005f4 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005fa:	e8 5f 20 00 00       	call   80265e <_Z9close_allv>
	sys_env_destroy(0);
  8005ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800606:	e8 60 0b 00 00       	call   80116b <_Z15sys_env_destroyi>
}
  80060b:	c9                   	leave  
  80060c:	c3                   	ret    
  80060d:	00 00                	add    %al,(%eax)
	...

00800610 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800610:	55                   	push   %ebp
  800611:	89 e5                	mov    %esp,%ebp
  800613:	56                   	push   %esi
  800614:	53                   	push   %ebx
  800615:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800618:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  80061b:	a1 04 70 80 00       	mov    0x807004,%eax
  800620:	85 c0                	test   %eax,%eax
  800622:	74 10                	je     800634 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  800624:	89 44 24 04          	mov    %eax,0x4(%esp)
  800628:	c7 04 24 0f 51 80 00 	movl   $0x80510f,(%esp)
  80062f:	e8 fa 00 00 00       	call   80072e <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  800634:	8b 1d 1c 60 80 00    	mov    0x80601c,%ebx
  80063a:	e8 89 0b 00 00       	call   8011c8 <_Z12sys_getenvidv>
  80063f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800642:	89 54 24 10          	mov    %edx,0x10(%esp)
  800646:	8b 55 08             	mov    0x8(%ebp),%edx
  800649:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80064d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800651:	89 44 24 04          	mov    %eax,0x4(%esp)
  800655:	c7 04 24 14 51 80 00 	movl   $0x805114,(%esp)
  80065c:	e8 cd 00 00 00       	call   80072e <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  800661:	89 74 24 04          	mov    %esi,0x4(%esp)
  800665:	8b 45 10             	mov    0x10(%ebp),%eax
  800668:	89 04 24             	mov    %eax,(%esp)
  80066b:	e8 5d 00 00 00       	call   8006cd <_Z8vcprintfPKcPc>
	cprintf("\n");
  800670:	c7 04 24 28 50 80 00 	movl   $0x805028,(%esp)
  800677:	e8 b2 00 00 00       	call   80072e <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80067c:	cc                   	int3   
  80067d:	eb fd                	jmp    80067c <_Z6_panicPKciS0_z+0x6c>
	...

00800680 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	83 ec 18             	sub    $0x18,%esp
  800686:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800689:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80068c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  80068f:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800691:	8b 03                	mov    (%ebx),%eax
  800693:	8b 55 08             	mov    0x8(%ebp),%edx
  800696:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80069a:	83 c0 01             	add    $0x1,%eax
  80069d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80069f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a4:	75 19                	jne    8006bf <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8006a6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8006ad:	00 
  8006ae:	8d 43 08             	lea    0x8(%ebx),%eax
  8006b1:	89 04 24             	mov    %eax,(%esp)
  8006b4:	e8 4b 0a 00 00       	call   801104 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8006b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8006bf:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  8006c3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8006c6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8006c9:	89 ec                	mov    %ebp,%esp
  8006cb:	5d                   	pop    %ebp
  8006cc:	c3                   	ret    

008006cd <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006cd:	55                   	push   %ebp
  8006ce:	89 e5                	mov    %esp,%ebp
  8006d0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8006d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006dd:	00 00 00 
	b.cnt = 0;
  8006e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e7:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006f8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800702:	c7 04 24 80 06 80 00 	movl   $0x800680,(%esp)
  800709:	e8 a9 01 00 00       	call   8008b7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  80070e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800714:	89 44 24 04          	mov    %eax,0x4(%esp)
  800718:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80071e:	89 04 24             	mov    %eax,(%esp)
  800721:	e8 de 09 00 00       	call   801104 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800726:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800734:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800737:	89 44 24 04          	mov    %eax,0x4(%esp)
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	89 04 24             	mov    %eax,(%esp)
  800741:	e8 87 ff ff ff       	call   8006cd <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800746:	c9                   	leave  
  800747:	c3                   	ret    
	...

00800750 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	57                   	push   %edi
  800754:	56                   	push   %esi
  800755:	53                   	push   %ebx
  800756:	83 ec 4c             	sub    $0x4c,%esp
  800759:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80075c:	89 d6                	mov    %edx,%esi
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800764:	8b 55 0c             	mov    0xc(%ebp),%edx
  800767:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80076a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80076d:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800770:	b8 00 00 00 00       	mov    $0x0,%eax
  800775:	39 d0                	cmp    %edx,%eax
  800777:	72 11                	jb     80078a <_ZL8printnumPFviPvES_yjii+0x3a>
  800779:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80077c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  80077f:	76 09                	jbe    80078a <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800781:	83 eb 01             	sub    $0x1,%ebx
  800784:	85 db                	test   %ebx,%ebx
  800786:	7f 5d                	jg     8007e5 <_ZL8printnumPFviPvES_yjii+0x95>
  800788:	eb 6c                	jmp    8007f6 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80078a:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80078e:	83 eb 01             	sub    $0x1,%ebx
  800791:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800795:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800798:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80079c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8007a0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8007a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8007aa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007b1:	00 
  8007b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b5:	89 14 24             	mov    %edx,(%esp)
  8007b8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007bf:	e8 4c 45 00 00       	call   804d10 <__udivdi3>
  8007c4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007c7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007ca:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007ce:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007d2:	89 04 24             	mov    %eax,(%esp)
  8007d5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007d9:	89 f2                	mov    %esi,%edx
  8007db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007de:	e8 6d ff ff ff       	call   800750 <_ZL8printnumPFviPvES_yjii>
  8007e3:	eb 11                	jmp    8007f6 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e9:	89 3c 24             	mov    %edi,(%esp)
  8007ec:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ef:	83 eb 01             	sub    $0x1,%ebx
  8007f2:	85 db                	test   %ebx,%ebx
  8007f4:	7f ef                	jg     8007e5 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007fa:	8b 74 24 04          	mov    0x4(%esp),%esi
  8007fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800801:	89 44 24 08          	mov    %eax,0x8(%esp)
  800805:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80080c:	00 
  80080d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800810:	89 14 24             	mov    %edx,(%esp)
  800813:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800816:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80081a:	e8 01 46 00 00       	call   804e20 <__umoddi3>
  80081f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800823:	0f be 80 37 51 80 00 	movsbl 0x805137(%eax),%eax
  80082a:	89 04 24             	mov    %eax,(%esp)
  80082d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800830:	83 c4 4c             	add    $0x4c,%esp
  800833:	5b                   	pop    %ebx
  800834:	5e                   	pop    %esi
  800835:	5f                   	pop    %edi
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    

00800838 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80083b:	83 fa 01             	cmp    $0x1,%edx
  80083e:	7e 0e                	jle    80084e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800840:	8b 10                	mov    (%eax),%edx
  800842:	8d 4a 08             	lea    0x8(%edx),%ecx
  800845:	89 08                	mov    %ecx,(%eax)
  800847:	8b 02                	mov    (%edx),%eax
  800849:	8b 52 04             	mov    0x4(%edx),%edx
  80084c:	eb 22                	jmp    800870 <_ZL7getuintPPci+0x38>
	else if (lflag)
  80084e:	85 d2                	test   %edx,%edx
  800850:	74 10                	je     800862 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800852:	8b 10                	mov    (%eax),%edx
  800854:	8d 4a 04             	lea    0x4(%edx),%ecx
  800857:	89 08                	mov    %ecx,(%eax)
  800859:	8b 02                	mov    (%edx),%eax
  80085b:	ba 00 00 00 00       	mov    $0x0,%edx
  800860:	eb 0e                	jmp    800870 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800862:	8b 10                	mov    (%eax),%edx
  800864:	8d 4a 04             	lea    0x4(%edx),%ecx
  800867:	89 08                	mov    %ecx,(%eax)
  800869:	8b 02                	mov    (%edx),%eax
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800878:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80087c:	8b 10                	mov    (%eax),%edx
  80087e:	3b 50 04             	cmp    0x4(%eax),%edx
  800881:	73 0a                	jae    80088d <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800883:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800886:	88 0a                	mov    %cl,(%edx)
  800888:	83 c2 01             	add    $0x1,%edx
  80088b:	89 10                	mov    %edx,(%eax)
}
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800895:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800898:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80089c:	8b 45 10             	mov    0x10(%ebp),%eax
  80089f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	89 04 24             	mov    %eax,(%esp)
  8008b0:	e8 02 00 00 00       	call   8008b7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  8008b5:	c9                   	leave  
  8008b6:	c3                   	ret    

008008b7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	57                   	push   %edi
  8008bb:	56                   	push   %esi
  8008bc:	53                   	push   %ebx
  8008bd:	83 ec 3c             	sub    $0x3c,%esp
  8008c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c3:	8b 55 10             	mov    0x10(%ebp),%edx
  8008c6:	0f b6 02             	movzbl (%edx),%eax
  8008c9:	89 d3                	mov    %edx,%ebx
  8008cb:	83 c3 01             	add    $0x1,%ebx
  8008ce:	83 f8 25             	cmp    $0x25,%eax
  8008d1:	74 2b                	je     8008fe <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  8008d3:	85 c0                	test   %eax,%eax
  8008d5:	75 10                	jne    8008e7 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  8008d7:	e9 a5 03 00 00       	jmp    800c81 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8008dc:	85 c0                	test   %eax,%eax
  8008de:	66 90                	xchg   %ax,%ax
  8008e0:	75 08                	jne    8008ea <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  8008e2:	e9 9a 03 00 00       	jmp    800c81 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  8008e7:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  8008ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ee:	89 04 24             	mov    %eax,(%esp)
  8008f1:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f3:	0f b6 03             	movzbl (%ebx),%eax
  8008f6:	83 c3 01             	add    $0x1,%ebx
  8008f9:	83 f8 25             	cmp    $0x25,%eax
  8008fc:	75 de                	jne    8008dc <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8008fe:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800902:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800909:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80090e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800915:	b9 00 00 00 00       	mov    $0x0,%ecx
  80091a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80091d:	eb 2b                	jmp    80094a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800922:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800926:	eb 22                	jmp    80094a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800928:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80092b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80092f:	eb 19                	jmp    80094a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800931:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800934:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80093b:	eb 0d                	jmp    80094a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80093d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800940:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800943:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80094a:	0f b6 03             	movzbl (%ebx),%eax
  80094d:	0f b6 d0             	movzbl %al,%edx
  800950:	8d 73 01             	lea    0x1(%ebx),%esi
  800953:	89 75 10             	mov    %esi,0x10(%ebp)
  800956:	83 e8 23             	sub    $0x23,%eax
  800959:	3c 55                	cmp    $0x55,%al
  80095b:	0f 87 d8 02 00 00    	ja     800c39 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800961:	0f b6 c0             	movzbl %al,%eax
  800964:	ff 24 85 e0 52 80 00 	jmp    *0x8052e0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  80096b:	83 ea 30             	sub    $0x30,%edx
  80096e:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800971:	8b 55 10             	mov    0x10(%ebp),%edx
  800974:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800977:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097a:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  80097d:	83 fa 09             	cmp    $0x9,%edx
  800980:	77 4e                	ja     8009d0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800982:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800985:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800988:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  80098b:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  80098f:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800992:	8d 50 d0             	lea    -0x30(%eax),%edx
  800995:	83 fa 09             	cmp    $0x9,%edx
  800998:	76 eb                	jbe    800985 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80099a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80099d:	eb 31                	jmp    8009d0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8d 50 04             	lea    0x4(%eax),%edx
  8009a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8009b0:	eb 1e                	jmp    8009d0 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	0f 88 75 ff ff ff    	js     800931 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8009bf:	eb 89                	jmp    80094a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8009c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8009c4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009cb:	e9 7a ff ff ff       	jmp    80094a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  8009d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d4:	0f 89 70 ff ff ff    	jns    80094a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  8009da:	e9 5e ff ff ff       	jmp    80093d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009df:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8009e5:	e9 60 ff ff ff       	jmp    80094a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	8d 50 04             	lea    0x4(%eax),%edx
  8009f0:	89 55 14             	mov    %edx,0x14(%ebp)
  8009f3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	89 04 24             	mov    %eax,(%esp)
  8009fc:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009ff:	e9 bf fe ff ff       	jmp    8008c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	8d 50 04             	lea    0x4(%eax),%edx
  800a0a:	89 55 14             	mov    %edx,0x14(%ebp)
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	89 c2                	mov    %eax,%edx
  800a11:	c1 fa 1f             	sar    $0x1f,%edx
  800a14:	31 d0                	xor    %edx,%eax
  800a16:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a18:	83 f8 14             	cmp    $0x14,%eax
  800a1b:	7f 0f                	jg     800a2c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  800a1d:	8b 14 85 40 54 80 00 	mov    0x805440(,%eax,4),%edx
  800a24:	85 d2                	test   %edx,%edx
  800a26:	0f 85 35 02 00 00    	jne    800c61 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  800a2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a30:	c7 44 24 08 4f 51 80 	movl   $0x80514f,0x8(%esp)
  800a37:	00 
  800a38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a3c:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3f:	89 34 24             	mov    %esi,(%esp)
  800a42:	e8 48 fe ff ff       	call   80088f <_Z8printfmtPFviPvES_PKcz>
  800a47:	e9 77 fe ff ff       	jmp    8008c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  800a4c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a52:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	8d 50 04             	lea    0x4(%eax),%edx
  800a5b:	89 55 14             	mov    %edx,0x14(%ebp)
  800a5e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800a60:	85 db                	test   %ebx,%ebx
  800a62:	ba 48 51 80 00       	mov    $0x805148,%edx
  800a67:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  800a6a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a6e:	7e 72                	jle    800ae2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800a70:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800a74:	74 6c                	je     800ae2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a76:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a7a:	89 1c 24             	mov    %ebx,(%esp)
  800a7d:	e8 a9 02 00 00       	call   800d2b <_Z7strnlenPKcj>
  800a82:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a85:	29 c2                	sub    %eax,%edx
  800a87:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a8a:	85 d2                	test   %edx,%edx
  800a8c:	7e 54                	jle    800ae2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  800a8e:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800a92:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800a95:	89 d3                	mov    %edx,%ebx
  800a97:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800a9a:	89 c6                	mov    %eax,%esi
  800a9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aa0:	89 34 24             	mov    %esi,(%esp)
  800aa3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa6:	83 eb 01             	sub    $0x1,%ebx
  800aa9:	85 db                	test   %ebx,%ebx
  800aab:	7f ef                	jg     800a9c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  800aad:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800ab0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800ab3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800aba:	eb 26                	jmp    800ae2 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800abc:	8d 50 e0             	lea    -0x20(%eax),%edx
  800abf:	83 fa 5e             	cmp    $0x5e,%edx
  800ac2:	76 10                	jbe    800ad4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800ac4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ac8:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800acf:	ff 55 08             	call   *0x8(%ebp)
  800ad2:	eb 0a                	jmp    800ade <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800ad4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ad8:	89 04 24             	mov    %eax,(%esp)
  800adb:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ade:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800ae2:	0f be 03             	movsbl (%ebx),%eax
  800ae5:	83 c3 01             	add    $0x1,%ebx
  800ae8:	85 c0                	test   %eax,%eax
  800aea:	74 11                	je     800afd <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  800aec:	85 f6                	test   %esi,%esi
  800aee:	78 05                	js     800af5 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800af0:	83 ee 01             	sub    $0x1,%esi
  800af3:	78 0d                	js     800b02 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800af5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800af9:	75 c1                	jne    800abc <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  800afb:	eb d7                	jmp    800ad4 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b00:	eb 03                	jmp    800b05 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b05:	85 c0                	test   %eax,%eax
  800b07:	0f 8e b6 fd ff ff    	jle    8008c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  800b0d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800b10:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800b13:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b17:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800b1e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b20:	83 eb 01             	sub    $0x1,%ebx
  800b23:	85 db                	test   %ebx,%ebx
  800b25:	7f ec                	jg     800b13 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800b27:	e9 97 fd ff ff       	jmp    8008c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b2c:	83 f9 01             	cmp    $0x1,%ecx
  800b2f:	90                   	nop
  800b30:	7e 10                	jle    800b42 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800b32:	8b 45 14             	mov    0x14(%ebp),%eax
  800b35:	8d 50 08             	lea    0x8(%eax),%edx
  800b38:	89 55 14             	mov    %edx,0x14(%ebp)
  800b3b:	8b 18                	mov    (%eax),%ebx
  800b3d:	8b 70 04             	mov    0x4(%eax),%esi
  800b40:	eb 26                	jmp    800b68 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800b42:	85 c9                	test   %ecx,%ecx
  800b44:	74 12                	je     800b58 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800b46:	8b 45 14             	mov    0x14(%ebp),%eax
  800b49:	8d 50 04             	lea    0x4(%eax),%edx
  800b4c:	89 55 14             	mov    %edx,0x14(%ebp)
  800b4f:	8b 18                	mov    (%eax),%ebx
  800b51:	89 de                	mov    %ebx,%esi
  800b53:	c1 fe 1f             	sar    $0x1f,%esi
  800b56:	eb 10                	jmp    800b68 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800b58:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5b:	8d 50 04             	lea    0x4(%eax),%edx
  800b5e:	89 55 14             	mov    %edx,0x14(%ebp)
  800b61:	8b 18                	mov    (%eax),%ebx
  800b63:	89 de                	mov    %ebx,%esi
  800b65:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b68:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b6d:	85 f6                	test   %esi,%esi
  800b6f:	0f 89 8c 00 00 00    	jns    800c01 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800b75:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b79:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b80:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b83:	f7 db                	neg    %ebx
  800b85:	83 d6 00             	adc    $0x0,%esi
  800b88:	f7 de                	neg    %esi
			}
			base = 10;
  800b8a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b8f:	eb 70                	jmp    800c01 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b91:	89 ca                	mov    %ecx,%edx
  800b93:	8d 45 14             	lea    0x14(%ebp),%eax
  800b96:	e8 9d fc ff ff       	call   800838 <_ZL7getuintPPci>
  800b9b:	89 c3                	mov    %eax,%ebx
  800b9d:	89 d6                	mov    %edx,%esi
			base = 10;
  800b9f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800ba4:	eb 5b                	jmp    800c01 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800ba6:	89 ca                	mov    %ecx,%edx
  800ba8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bab:	e8 88 fc ff ff       	call   800838 <_ZL7getuintPPci>
  800bb0:	89 c3                	mov    %eax,%ebx
  800bb2:	89 d6                	mov    %edx,%esi
			base = 8;
  800bb4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800bb9:	eb 46                	jmp    800c01 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  800bbb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bbf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800bc6:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800bc9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bcd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800bd4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bda:	8d 50 04             	lea    0x4(%eax),%edx
  800bdd:	89 55 14             	mov    %edx,0x14(%ebp)
  800be0:	8b 18                	mov    (%eax),%ebx
  800be2:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800be7:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800bec:	eb 13                	jmp    800c01 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bee:	89 ca                	mov    %ecx,%edx
  800bf0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf3:	e8 40 fc ff ff       	call   800838 <_ZL7getuintPPci>
  800bf8:	89 c3                	mov    %eax,%ebx
  800bfa:	89 d6                	mov    %edx,%esi
			base = 16;
  800bfc:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c01:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800c05:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c0c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c10:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c14:	89 1c 24             	mov    %ebx,(%esp)
  800c17:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c1b:	89 fa                	mov    %edi,%edx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	e8 2b fb ff ff       	call   800750 <_ZL8printnumPFviPvES_yjii>
			break;
  800c25:	e9 99 fc ff ff       	jmp    8008c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c2e:	89 14 24             	mov    %edx,(%esp)
  800c31:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c34:	e9 8a fc ff ff       	jmp    8008c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c39:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c3d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c44:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c47:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c4a:	89 d8                	mov    %ebx,%eax
  800c4c:	eb 02                	jmp    800c50 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  800c4e:	89 d0                	mov    %edx,%eax
  800c50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c53:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c57:	75 f5                	jne    800c4e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800c59:	89 45 10             	mov    %eax,0x10(%ebp)
  800c5c:	e9 62 fc ff ff       	jmp    8008c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c61:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c65:	c7 44 24 08 88 55 80 	movl   $0x805588,0x8(%esp)
  800c6c:	00 
  800c6d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c71:	8b 75 08             	mov    0x8(%ebp),%esi
  800c74:	89 34 24             	mov    %esi,(%esp)
  800c77:	e8 13 fc ff ff       	call   80088f <_Z8printfmtPFviPvES_PKcz>
  800c7c:	e9 42 fc ff ff       	jmp    8008c3 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c81:	83 c4 3c             	add    $0x3c,%esp
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 28             	sub    $0x28,%esp
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800c9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c9f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ca3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	74 30                	je     800cda <_Z9vsnprintfPciPKcS_+0x51>
  800caa:	85 d2                	test   %edx,%edx
  800cac:	7e 2c                	jle    800cda <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  800cae:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc3:	c7 04 24 72 08 80 00 	movl   $0x800872,(%esp)
  800cca:	e8 e8 fb ff ff       	call   8008b7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  800ccf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cd8:	eb 05                	jmp    800cdf <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800cda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    

00800ce1 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ce7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 04 24             	mov    %eax,(%esp)
  800d02:	e8 82 ff ff ff       	call   800c89 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    
  800d09:	00 00                	add    %al,(%eax)
  800d0b:	00 00                	add    %al,(%eax)
  800d0d:	00 00                	add    %al,(%eax)
	...

00800d10 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d16:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1b:	80 3a 00             	cmpb   $0x0,(%edx)
  800d1e:	74 09                	je     800d29 <_Z6strlenPKc+0x19>
		n++;
  800d20:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d27:	75 f7                	jne    800d20 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d31:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d34:	b8 00 00 00 00       	mov    $0x0,%eax
  800d39:	39 c2                	cmp    %eax,%edx
  800d3b:	74 0b                	je     800d48 <_Z7strnlenPKcj+0x1d>
  800d3d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d41:	74 05                	je     800d48 <_Z7strnlenPKcj+0x1d>
		n++;
  800d43:	83 c0 01             	add    $0x1,%eax
  800d46:	eb f1                	jmp    800d39 <_Z7strnlenPKcj+0xe>
	return n;
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	53                   	push   %ebx
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800d54:	ba 00 00 00 00       	mov    $0x0,%edx
  800d59:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d5d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800d60:	83 c2 01             	add    $0x1,%edx
  800d63:	84 c9                	test   %cl,%cl
  800d65:	75 f2                	jne    800d59 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800d67:	5b                   	pop    %ebx
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d75:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800d78:	85 f6                	test   %esi,%esi
  800d7a:	74 18                	je     800d94 <_Z7strncpyPcPKcj+0x2a>
  800d7c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800d81:	0f b6 1a             	movzbl (%edx),%ebx
  800d84:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d87:	80 3a 01             	cmpb   $0x1,(%edx)
  800d8a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800d8d:	83 c1 01             	add    $0x1,%ecx
  800d90:	39 ce                	cmp    %ecx,%esi
  800d92:	77 ed                	ja     800d81 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	8b 75 08             	mov    0x8(%ebp),%esi
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800da6:	89 f0                	mov    %esi,%eax
  800da8:	85 d2                	test   %edx,%edx
  800daa:	74 17                	je     800dc3 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800dac:	83 ea 01             	sub    $0x1,%edx
  800daf:	74 18                	je     800dc9 <_Z7strlcpyPcPKcj+0x31>
  800db1:	80 39 00             	cmpb   $0x0,(%ecx)
  800db4:	74 17                	je     800dcd <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800db6:	0f b6 19             	movzbl (%ecx),%ebx
  800db9:	88 18                	mov    %bl,(%eax)
  800dbb:	83 c0 01             	add    $0x1,%eax
  800dbe:	83 c1 01             	add    $0x1,%ecx
  800dc1:	eb e9                	jmp    800dac <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800dc3:	29 f0                	sub    %esi,%eax
}
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dc9:	89 c2                	mov    %eax,%edx
  800dcb:	eb 02                	jmp    800dcf <_Z7strlcpyPcPKcj+0x37>
  800dcd:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800dcf:	c6 02 00             	movb   $0x0,(%edx)
  800dd2:	eb ef                	jmp    800dc3 <_Z7strlcpyPcPKcj+0x2b>

00800dd4 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dda:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ddd:	0f b6 01             	movzbl (%ecx),%eax
  800de0:	84 c0                	test   %al,%al
  800de2:	74 0c                	je     800df0 <_Z6strcmpPKcS0_+0x1c>
  800de4:	3a 02                	cmp    (%edx),%al
  800de6:	75 08                	jne    800df0 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800de8:	83 c1 01             	add    $0x1,%ecx
  800deb:	83 c2 01             	add    $0x1,%edx
  800dee:	eb ed                	jmp    800ddd <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800df0:	0f b6 c0             	movzbl %al,%eax
  800df3:	0f b6 12             	movzbl (%edx),%edx
  800df6:	29 d0                	sub    %edx,%eax
}
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    

00800dfa <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	53                   	push   %ebx
  800dfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e04:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800e07:	85 d2                	test   %edx,%edx
  800e09:	74 16                	je     800e21 <_Z7strncmpPKcS0_j+0x27>
  800e0b:	0f b6 01             	movzbl (%ecx),%eax
  800e0e:	84 c0                	test   %al,%al
  800e10:	74 17                	je     800e29 <_Z7strncmpPKcS0_j+0x2f>
  800e12:	3a 03                	cmp    (%ebx),%al
  800e14:	75 13                	jne    800e29 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800e16:	83 ea 01             	sub    $0x1,%edx
  800e19:	83 c1 01             	add    $0x1,%ecx
  800e1c:	83 c3 01             	add    $0x1,%ebx
  800e1f:	eb e6                	jmp    800e07 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800e21:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800e26:	5b                   	pop    %ebx
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800e29:	0f b6 01             	movzbl (%ecx),%eax
  800e2c:	0f b6 13             	movzbl (%ebx),%edx
  800e2f:	29 d0                	sub    %edx,%eax
  800e31:	eb f3                	jmp    800e26 <_Z7strncmpPKcS0_j+0x2c>

00800e33 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e3d:	0f b6 10             	movzbl (%eax),%edx
  800e40:	84 d2                	test   %dl,%dl
  800e42:	74 1f                	je     800e63 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800e44:	38 ca                	cmp    %cl,%dl
  800e46:	75 0a                	jne    800e52 <_Z6strchrPKcc+0x1f>
  800e48:	eb 1e                	jmp    800e68 <_Z6strchrPKcc+0x35>
  800e4a:	38 ca                	cmp    %cl,%dl
  800e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e50:	74 16                	je     800e68 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e52:	83 c0 01             	add    $0x1,%eax
  800e55:	0f b6 10             	movzbl (%eax),%edx
  800e58:	84 d2                	test   %dl,%dl
  800e5a:	75 ee                	jne    800e4a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e61:	eb 05                	jmp    800e68 <_Z6strchrPKcc+0x35>
  800e63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e74:	0f b6 10             	movzbl (%eax),%edx
  800e77:	84 d2                	test   %dl,%dl
  800e79:	74 14                	je     800e8f <_Z7strfindPKcc+0x25>
		if (*s == c)
  800e7b:	38 ca                	cmp    %cl,%dl
  800e7d:	75 06                	jne    800e85 <_Z7strfindPKcc+0x1b>
  800e7f:	eb 0e                	jmp    800e8f <_Z7strfindPKcc+0x25>
  800e81:	38 ca                	cmp    %cl,%dl
  800e83:	74 0a                	je     800e8f <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e85:	83 c0 01             	add    $0x1,%eax
  800e88:	0f b6 10             	movzbl (%eax),%edx
  800e8b:	84 d2                	test   %dl,%dl
  800e8d:	75 f2                	jne    800e81 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    

00800e91 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	83 ec 0c             	sub    $0xc,%esp
  800e97:	89 1c 24             	mov    %ebx,(%esp)
  800e9a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e9e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ea2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800eab:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800eb1:	75 25                	jne    800ed8 <memset+0x47>
  800eb3:	f6 c1 03             	test   $0x3,%cl
  800eb6:	75 20                	jne    800ed8 <memset+0x47>
		c &= 0xFF;
  800eb8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ebb:	89 d3                	mov    %edx,%ebx
  800ebd:	c1 e3 08             	shl    $0x8,%ebx
  800ec0:	89 d6                	mov    %edx,%esi
  800ec2:	c1 e6 18             	shl    $0x18,%esi
  800ec5:	89 d0                	mov    %edx,%eax
  800ec7:	c1 e0 10             	shl    $0x10,%eax
  800eca:	09 f0                	or     %esi,%eax
  800ecc:	09 d0                	or     %edx,%eax
  800ece:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800ed0:	c1 e9 02             	shr    $0x2,%ecx
  800ed3:	fc                   	cld    
  800ed4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ed6:	eb 03                	jmp    800edb <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800ed8:	fc                   	cld    
  800ed9:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800edb:	89 f8                	mov    %edi,%eax
  800edd:	8b 1c 24             	mov    (%esp),%ebx
  800ee0:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ee4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ee8:	89 ec                	mov    %ebp,%esp
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 08             	sub    $0x8,%esp
  800ef2:	89 34 24             	mov    %esi,(%esp)
  800ef5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eff:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800f02:	39 c6                	cmp    %eax,%esi
  800f04:	73 36                	jae    800f3c <memmove+0x50>
  800f06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f09:	39 d0                	cmp    %edx,%eax
  800f0b:	73 2f                	jae    800f3c <memmove+0x50>
		s += n;
		d += n;
  800f0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800f10:	f6 c2 03             	test   $0x3,%dl
  800f13:	75 1b                	jne    800f30 <memmove+0x44>
  800f15:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f1b:	75 13                	jne    800f30 <memmove+0x44>
  800f1d:	f6 c1 03             	test   $0x3,%cl
  800f20:	75 0e                	jne    800f30 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f22:	83 ef 04             	sub    $0x4,%edi
  800f25:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f28:	c1 e9 02             	shr    $0x2,%ecx
  800f2b:	fd                   	std    
  800f2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f2e:	eb 09                	jmp    800f39 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f30:	83 ef 01             	sub    $0x1,%edi
  800f33:	8d 72 ff             	lea    -0x1(%edx),%esi
  800f36:	fd                   	std    
  800f37:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f39:	fc                   	cld    
  800f3a:	eb 20                	jmp    800f5c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800f3c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f42:	75 13                	jne    800f57 <memmove+0x6b>
  800f44:	a8 03                	test   $0x3,%al
  800f46:	75 0f                	jne    800f57 <memmove+0x6b>
  800f48:	f6 c1 03             	test   $0x3,%cl
  800f4b:	75 0a                	jne    800f57 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f4d:	c1 e9 02             	shr    $0x2,%ecx
  800f50:	89 c7                	mov    %eax,%edi
  800f52:	fc                   	cld    
  800f53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f55:	eb 05                	jmp    800f5c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800f57:	89 c7                	mov    %eax,%edi
  800f59:	fc                   	cld    
  800f5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800f5c:	8b 34 24             	mov    (%esp),%esi
  800f5f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800f63:	89 ec                	mov    %ebp,%esp
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 08             	sub    $0x8,%esp
  800f6d:	89 34 24             	mov    %esi,(%esp)
  800f70:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800f7d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f83:	75 13                	jne    800f98 <memcpy+0x31>
  800f85:	a8 03                	test   $0x3,%al
  800f87:	75 0f                	jne    800f98 <memcpy+0x31>
  800f89:	f6 c1 03             	test   $0x3,%cl
  800f8c:	75 0a                	jne    800f98 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f8e:	c1 e9 02             	shr    $0x2,%ecx
  800f91:	89 c7                	mov    %eax,%edi
  800f93:	fc                   	cld    
  800f94:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f96:	eb 05                	jmp    800f9d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800f98:	89 c7                	mov    %eax,%edi
  800f9a:	fc                   	cld    
  800f9b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800f9d:	8b 34 24             	mov    (%esp),%esi
  800fa0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800fa4:	89 ec                	mov    %ebp,%esp
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
  800fae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800fb1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fb4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800fb7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800fbc:	85 ff                	test   %edi,%edi
  800fbe:	74 38                	je     800ff8 <memcmp+0x50>
		if (*s1 != *s2)
  800fc0:	0f b6 03             	movzbl (%ebx),%eax
  800fc3:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800fc6:	83 ef 01             	sub    $0x1,%edi
  800fc9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800fce:	38 c8                	cmp    %cl,%al
  800fd0:	74 1d                	je     800fef <memcmp+0x47>
  800fd2:	eb 11                	jmp    800fe5 <memcmp+0x3d>
  800fd4:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800fd9:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800fde:	83 c2 01             	add    $0x1,%edx
  800fe1:	38 c8                	cmp    %cl,%al
  800fe3:	74 0a                	je     800fef <memcmp+0x47>
			return *s1 - *s2;
  800fe5:	0f b6 c0             	movzbl %al,%eax
  800fe8:	0f b6 c9             	movzbl %cl,%ecx
  800feb:	29 c8                	sub    %ecx,%eax
  800fed:	eb 09                	jmp    800ff8 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800fef:	39 fa                	cmp    %edi,%edx
  800ff1:	75 e1                	jne    800fd4 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800ff3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5f                   	pop    %edi
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    

00800ffd <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	53                   	push   %ebx
  801001:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  801004:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  801006:	89 da                	mov    %ebx,%edx
  801008:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  80100b:	39 d3                	cmp    %edx,%ebx
  80100d:	73 15                	jae    801024 <memfind+0x27>
		if (*s == (unsigned char) c)
  80100f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801013:	38 0b                	cmp    %cl,(%ebx)
  801015:	75 06                	jne    80101d <memfind+0x20>
  801017:	eb 0b                	jmp    801024 <memfind+0x27>
  801019:	38 08                	cmp    %cl,(%eax)
  80101b:	74 07                	je     801024 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  80101d:	83 c0 01             	add    $0x1,%eax
  801020:	39 c2                	cmp    %eax,%edx
  801022:	77 f5                	ja     801019 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  801024:	5b                   	pop    %ebx
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	53                   	push   %ebx
  80102d:	8b 55 08             	mov    0x8(%ebp),%edx
  801030:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801033:	0f b6 02             	movzbl (%edx),%eax
  801036:	3c 20                	cmp    $0x20,%al
  801038:	74 04                	je     80103e <_Z6strtolPKcPPci+0x17>
  80103a:	3c 09                	cmp    $0x9,%al
  80103c:	75 0e                	jne    80104c <_Z6strtolPKcPPci+0x25>
		s++;
  80103e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801041:	0f b6 02             	movzbl (%edx),%eax
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f6                	je     80103e <_Z6strtolPKcPPci+0x17>
  801048:	3c 09                	cmp    $0x9,%al
  80104a:	74 f2                	je     80103e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  80104c:	3c 2b                	cmp    $0x2b,%al
  80104e:	75 0a                	jne    80105a <_Z6strtolPKcPPci+0x33>
		s++;
  801050:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801053:	bf 00 00 00 00       	mov    $0x0,%edi
  801058:	eb 10                	jmp    80106a <_Z6strtolPKcPPci+0x43>
  80105a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80105f:	3c 2d                	cmp    $0x2d,%al
  801061:	75 07                	jne    80106a <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  801063:	83 c2 01             	add    $0x1,%edx
  801066:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80106a:	85 db                	test   %ebx,%ebx
  80106c:	0f 94 c0             	sete   %al
  80106f:	74 05                	je     801076 <_Z6strtolPKcPPci+0x4f>
  801071:	83 fb 10             	cmp    $0x10,%ebx
  801074:	75 15                	jne    80108b <_Z6strtolPKcPPci+0x64>
  801076:	80 3a 30             	cmpb   $0x30,(%edx)
  801079:	75 10                	jne    80108b <_Z6strtolPKcPPci+0x64>
  80107b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80107f:	75 0a                	jne    80108b <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  801081:	83 c2 02             	add    $0x2,%edx
  801084:	bb 10 00 00 00       	mov    $0x10,%ebx
  801089:	eb 13                	jmp    80109e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  80108b:	84 c0                	test   %al,%al
  80108d:	74 0f                	je     80109e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80108f:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801094:	80 3a 30             	cmpb   $0x30,(%edx)
  801097:	75 05                	jne    80109e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  801099:	83 c2 01             	add    $0x1,%edx
  80109c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  80109e:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a5:	0f b6 0a             	movzbl (%edx),%ecx
  8010a8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8010ab:	80 fb 09             	cmp    $0x9,%bl
  8010ae:	77 08                	ja     8010b8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  8010b0:	0f be c9             	movsbl %cl,%ecx
  8010b3:	83 e9 30             	sub    $0x30,%ecx
  8010b6:	eb 1e                	jmp    8010d6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  8010b8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8010bb:	80 fb 19             	cmp    $0x19,%bl
  8010be:	77 08                	ja     8010c8 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  8010c0:	0f be c9             	movsbl %cl,%ecx
  8010c3:	83 e9 57             	sub    $0x57,%ecx
  8010c6:	eb 0e                	jmp    8010d6 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  8010c8:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8010cb:	80 fb 19             	cmp    $0x19,%bl
  8010ce:	77 15                	ja     8010e5 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  8010d0:	0f be c9             	movsbl %cl,%ecx
  8010d3:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8010d6:	39 f1                	cmp    %esi,%ecx
  8010d8:	7d 0f                	jge    8010e9 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  8010da:	83 c2 01             	add    $0x1,%edx
  8010dd:	0f af c6             	imul   %esi,%eax
  8010e0:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  8010e3:	eb c0                	jmp    8010a5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  8010e5:	89 c1                	mov    %eax,%ecx
  8010e7:	eb 02                	jmp    8010eb <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010e9:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ef:	74 05                	je     8010f6 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  8010f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8010f4:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  8010f6:	89 ca                	mov    %ecx,%edx
  8010f8:	f7 da                	neg    %edx
  8010fa:	85 ff                	test   %edi,%edi
  8010fc:	0f 45 c2             	cmovne %edx,%eax
}
  8010ff:	5b                   	pop    %ebx
  801100:	5e                   	pop    %esi
  801101:	5f                   	pop    %edi
  801102:	5d                   	pop    %ebp
  801103:	c3                   	ret    

00801104 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	89 1c 24             	mov    %ebx,(%esp)
  80110d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801111:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
  80111a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111d:	8b 55 08             	mov    0x8(%ebp),%edx
  801120:	89 c3                	mov    %eax,%ebx
  801122:	89 c7                	mov    %eax,%edi
  801124:	89 c6                	mov    %eax,%esi
  801126:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801128:	8b 1c 24             	mov    (%esp),%ebx
  80112b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80112f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801133:	89 ec                	mov    %ebp,%esp
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 0c             	sub    $0xc,%esp
  80113d:	89 1c 24             	mov    %ebx,(%esp)
  801140:	89 74 24 04          	mov    %esi,0x4(%esp)
  801144:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801148:	ba 00 00 00 00       	mov    $0x0,%edx
  80114d:	b8 01 00 00 00       	mov    $0x1,%eax
  801152:	89 d1                	mov    %edx,%ecx
  801154:	89 d3                	mov    %edx,%ebx
  801156:	89 d7                	mov    %edx,%edi
  801158:	89 d6                	mov    %edx,%esi
  80115a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80115c:	8b 1c 24             	mov    (%esp),%ebx
  80115f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801163:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801167:	89 ec                	mov    %ebp,%esp
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 38             	sub    $0x38,%esp
  801171:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801174:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801177:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80117a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80117f:	b8 03 00 00 00       	mov    $0x3,%eax
  801184:	8b 55 08             	mov    0x8(%ebp),%edx
  801187:	89 cb                	mov    %ecx,%ebx
  801189:	89 cf                	mov    %ecx,%edi
  80118b:	89 ce                	mov    %ecx,%esi
  80118d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80118f:	85 c0                	test   %eax,%eax
  801191:	7e 28                	jle    8011bb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801193:	89 44 24 10          	mov    %eax,0x10(%esp)
  801197:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80119e:	00 
  80119f:	c7 44 24 08 94 54 80 	movl   $0x805494,0x8(%esp)
  8011a6:	00 
  8011a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ae:	00 
  8011af:	c7 04 24 b1 54 80 00 	movl   $0x8054b1,(%esp)
  8011b6:	e8 55 f4 ff ff       	call   800610 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011c4:	89 ec                	mov    %ebp,%esp
  8011c6:	5d                   	pop    %ebp
  8011c7:	c3                   	ret    

008011c8 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 0c             	sub    $0xc,%esp
  8011ce:	89 1c 24             	mov    %ebx,(%esp)
  8011d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011de:	b8 02 00 00 00       	mov    $0x2,%eax
  8011e3:	89 d1                	mov    %edx,%ecx
  8011e5:	89 d3                	mov    %edx,%ebx
  8011e7:	89 d7                	mov    %edx,%edi
  8011e9:	89 d6                	mov    %edx,%esi
  8011eb:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011ed:	8b 1c 24             	mov    (%esp),%ebx
  8011f0:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011f4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011f8:	89 ec                	mov    %ebp,%esp
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <_Z9sys_yieldv>:

void
sys_yield(void)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 0c             	sub    $0xc,%esp
  801202:	89 1c 24             	mov    %ebx,(%esp)
  801205:	89 74 24 04          	mov    %esi,0x4(%esp)
  801209:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80120d:	ba 00 00 00 00       	mov    $0x0,%edx
  801212:	b8 04 00 00 00       	mov    $0x4,%eax
  801217:	89 d1                	mov    %edx,%ecx
  801219:	89 d3                	mov    %edx,%ebx
  80121b:	89 d7                	mov    %edx,%edi
  80121d:	89 d6                	mov    %edx,%esi
  80121f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801221:	8b 1c 24             	mov    (%esp),%ebx
  801224:	8b 74 24 04          	mov    0x4(%esp),%esi
  801228:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80122c:	89 ec                	mov    %ebp,%esp
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 38             	sub    $0x38,%esp
  801236:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801239:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80123c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80123f:	be 00 00 00 00       	mov    $0x0,%esi
  801244:	b8 08 00 00 00       	mov    $0x8,%eax
  801249:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80124c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124f:	8b 55 08             	mov    0x8(%ebp),%edx
  801252:	89 f7                	mov    %esi,%edi
  801254:	cd 30                	int    $0x30

	if(check && ret > 0)
  801256:	85 c0                	test   %eax,%eax
  801258:	7e 28                	jle    801282 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  80125a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80125e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801265:	00 
  801266:	c7 44 24 08 94 54 80 	movl   $0x805494,0x8(%esp)
  80126d:	00 
  80126e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801275:	00 
  801276:	c7 04 24 b1 54 80 00 	movl   $0x8054b1,(%esp)
  80127d:	e8 8e f3 ff ff       	call   800610 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801282:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801285:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801288:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80128b:	89 ec                	mov    %ebp,%esp
  80128d:	5d                   	pop    %ebp
  80128e:	c3                   	ret    

0080128f <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 38             	sub    $0x38,%esp
  801295:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801298:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80129b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80129e:	b8 09 00 00 00       	mov    $0x9,%eax
  8012a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8012a6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012af:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b2:	cd 30                	int    $0x30

	if(check && ret > 0)
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	7e 28                	jle    8012e0 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012bc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8012c3:	00 
  8012c4:	c7 44 24 08 94 54 80 	movl   $0x805494,0x8(%esp)
  8012cb:	00 
  8012cc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012d3:	00 
  8012d4:	c7 04 24 b1 54 80 00 	movl   $0x8054b1,(%esp)
  8012db:	e8 30 f3 ff ff       	call   800610 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012e0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012e3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012e6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012e9:	89 ec                	mov    %ebp,%esp
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 38             	sub    $0x38,%esp
  8012f3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012f6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012f9:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801301:	b8 0a 00 00 00       	mov    $0xa,%eax
  801306:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801309:	8b 55 08             	mov    0x8(%ebp),%edx
  80130c:	89 df                	mov    %ebx,%edi
  80130e:	89 de                	mov    %ebx,%esi
  801310:	cd 30                	int    $0x30

	if(check && ret > 0)
  801312:	85 c0                	test   %eax,%eax
  801314:	7e 28                	jle    80133e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801316:	89 44 24 10          	mov    %eax,0x10(%esp)
  80131a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801321:	00 
  801322:	c7 44 24 08 94 54 80 	movl   $0x805494,0x8(%esp)
  801329:	00 
  80132a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801331:	00 
  801332:	c7 04 24 b1 54 80 00 	movl   $0x8054b1,(%esp)
  801339:	e8 d2 f2 ff ff       	call   800610 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80133e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801341:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801344:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801347:	89 ec                	mov    %ebp,%esp
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

0080134b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	83 ec 38             	sub    $0x38,%esp
  801351:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801354:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801357:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80135a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80135f:	b8 05 00 00 00       	mov    $0x5,%eax
  801364:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801367:	8b 55 08             	mov    0x8(%ebp),%edx
  80136a:	89 df                	mov    %ebx,%edi
  80136c:	89 de                	mov    %ebx,%esi
  80136e:	cd 30                	int    $0x30

	if(check && ret > 0)
  801370:	85 c0                	test   %eax,%eax
  801372:	7e 28                	jle    80139c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801374:	89 44 24 10          	mov    %eax,0x10(%esp)
  801378:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80137f:	00 
  801380:	c7 44 24 08 94 54 80 	movl   $0x805494,0x8(%esp)
  801387:	00 
  801388:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80138f:	00 
  801390:	c7 04 24 b1 54 80 00 	movl   $0x8054b1,(%esp)
  801397:	e8 74 f2 ff ff       	call   800610 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80139c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80139f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013a5:	89 ec                	mov    %ebp,%esp
  8013a7:	5d                   	pop    %ebp
  8013a8:	c3                   	ret    

008013a9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
  8013ac:	83 ec 38             	sub    $0x38,%esp
  8013af:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013bd:	b8 06 00 00 00       	mov    $0x6,%eax
  8013c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c8:	89 df                	mov    %ebx,%edi
  8013ca:	89 de                	mov    %ebx,%esi
  8013cc:	cd 30                	int    $0x30

	if(check && ret > 0)
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	7e 28                	jle    8013fa <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013d2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013d6:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8013dd:	00 
  8013de:	c7 44 24 08 94 54 80 	movl   $0x805494,0x8(%esp)
  8013e5:	00 
  8013e6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013ed:	00 
  8013ee:	c7 04 24 b1 54 80 00 	movl   $0x8054b1,(%esp)
  8013f5:	e8 16 f2 ff ff       	call   800610 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  8013fa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013fd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801400:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801403:	89 ec                	mov    %ebp,%esp
  801405:	5d                   	pop    %ebp
  801406:	c3                   	ret    

00801407 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	83 ec 38             	sub    $0x38,%esp
  80140d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801410:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801413:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801416:	bb 00 00 00 00       	mov    $0x0,%ebx
  80141b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801423:	8b 55 08             	mov    0x8(%ebp),%edx
  801426:	89 df                	mov    %ebx,%edi
  801428:	89 de                	mov    %ebx,%esi
  80142a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80142c:	85 c0                	test   %eax,%eax
  80142e:	7e 28                	jle    801458 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801430:	89 44 24 10          	mov    %eax,0x10(%esp)
  801434:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80143b:	00 
  80143c:	c7 44 24 08 94 54 80 	movl   $0x805494,0x8(%esp)
  801443:	00 
  801444:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80144b:	00 
  80144c:	c7 04 24 b1 54 80 00 	movl   $0x8054b1,(%esp)
  801453:	e8 b8 f1 ff ff       	call   800610 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801458:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80145b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80145e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801461:	89 ec                	mov    %ebp,%esp
  801463:	5d                   	pop    %ebp
  801464:	c3                   	ret    

00801465 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 38             	sub    $0x38,%esp
  80146b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80146e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801471:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801474:	bb 00 00 00 00       	mov    $0x0,%ebx
  801479:	b8 0c 00 00 00       	mov    $0xc,%eax
  80147e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801481:	8b 55 08             	mov    0x8(%ebp),%edx
  801484:	89 df                	mov    %ebx,%edi
  801486:	89 de                	mov    %ebx,%esi
  801488:	cd 30                	int    $0x30

	if(check && ret > 0)
  80148a:	85 c0                	test   %eax,%eax
  80148c:	7e 28                	jle    8014b6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80148e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801492:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801499:	00 
  80149a:	c7 44 24 08 94 54 80 	movl   $0x805494,0x8(%esp)
  8014a1:	00 
  8014a2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014a9:	00 
  8014aa:	c7 04 24 b1 54 80 00 	movl   $0x8054b1,(%esp)
  8014b1:	e8 5a f1 ff ff       	call   800610 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8014b6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014b9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014bc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014bf:	89 ec                	mov    %ebp,%esp
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 0c             	sub    $0xc,%esp
  8014c9:	89 1c 24             	mov    %ebx,(%esp)
  8014cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014d0:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8014d4:	be 00 00 00 00       	mov    $0x0,%esi
  8014d9:	b8 0d 00 00 00       	mov    $0xd,%eax
  8014de:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ea:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8014ec:	8b 1c 24             	mov    (%esp),%ebx
  8014ef:	8b 74 24 04          	mov    0x4(%esp),%esi
  8014f3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8014f7:	89 ec                	mov    %ebp,%esp
  8014f9:	5d                   	pop    %ebp
  8014fa:	c3                   	ret    

008014fb <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 38             	sub    $0x38,%esp
  801501:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801504:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801507:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80150a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80150f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801514:	8b 55 08             	mov    0x8(%ebp),%edx
  801517:	89 cb                	mov    %ecx,%ebx
  801519:	89 cf                	mov    %ecx,%edi
  80151b:	89 ce                	mov    %ecx,%esi
  80151d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80151f:	85 c0                	test   %eax,%eax
  801521:	7e 28                	jle    80154b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801523:	89 44 24 10          	mov    %eax,0x10(%esp)
  801527:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80152e:	00 
  80152f:	c7 44 24 08 94 54 80 	movl   $0x805494,0x8(%esp)
  801536:	00 
  801537:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80153e:	00 
  80153f:	c7 04 24 b1 54 80 00 	movl   $0x8054b1,(%esp)
  801546:	e8 c5 f0 ff ff       	call   800610 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80154b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80154e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801551:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801554:	89 ec                	mov    %ebp,%esp
  801556:	5d                   	pop    %ebp
  801557:	c3                   	ret    

00801558 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 0c             	sub    $0xc,%esp
  80155e:	89 1c 24             	mov    %ebx,(%esp)
  801561:	89 74 24 04          	mov    %esi,0x4(%esp)
  801565:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801569:	bb 00 00 00 00       	mov    $0x0,%ebx
  80156e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801573:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801576:	8b 55 08             	mov    0x8(%ebp),%edx
  801579:	89 df                	mov    %ebx,%edi
  80157b:	89 de                	mov    %ebx,%esi
  80157d:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  80157f:	8b 1c 24             	mov    (%esp),%ebx
  801582:	8b 74 24 04          	mov    0x4(%esp),%esi
  801586:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80158a:	89 ec                	mov    %ebp,%esp
  80158c:	5d                   	pop    %ebp
  80158d:	c3                   	ret    

0080158e <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	89 1c 24             	mov    %ebx,(%esp)
  801597:	89 74 24 04          	mov    %esi,0x4(%esp)
  80159b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80159f:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a4:	b8 11 00 00 00       	mov    $0x11,%eax
  8015a9:	89 d1                	mov    %edx,%ecx
  8015ab:	89 d3                	mov    %edx,%ebx
  8015ad:	89 d7                	mov    %edx,%edi
  8015af:	89 d6                	mov    %edx,%esi
  8015b1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8015b3:	8b 1c 24             	mov    (%esp),%ebx
  8015b6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8015ba:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8015be:	89 ec                	mov    %ebp,%esp
  8015c0:	5d                   	pop    %ebp
  8015c1:	c3                   	ret    

008015c2 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 0c             	sub    $0xc,%esp
  8015c8:	89 1c 24             	mov    %ebx,(%esp)
  8015cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015cf:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8015d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d8:	b8 12 00 00 00       	mov    $0x12,%eax
  8015dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e3:	89 df                	mov    %ebx,%edi
  8015e5:	89 de                	mov    %ebx,%esi
  8015e7:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  8015e9:	8b 1c 24             	mov    (%esp),%ebx
  8015ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8015f0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8015f4:	89 ec                	mov    %ebp,%esp
  8015f6:	5d                   	pop    %ebp
  8015f7:	c3                   	ret    

008015f8 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	89 1c 24             	mov    %ebx,(%esp)
  801601:	89 74 24 04          	mov    %esi,0x4(%esp)
  801605:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801609:	b9 00 00 00 00       	mov    $0x0,%ecx
  80160e:	b8 13 00 00 00       	mov    $0x13,%eax
  801613:	8b 55 08             	mov    0x8(%ebp),%edx
  801616:	89 cb                	mov    %ecx,%ebx
  801618:	89 cf                	mov    %ecx,%edi
  80161a:	89 ce                	mov    %ecx,%esi
  80161c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80161e:	8b 1c 24             	mov    (%esp),%ebx
  801621:	8b 74 24 04          	mov    0x4(%esp),%esi
  801625:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801629:	89 ec                	mov    %ebp,%esp
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    

0080162d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 0c             	sub    $0xc,%esp
  801633:	89 1c 24             	mov    %ebx,(%esp)
  801636:	89 74 24 04          	mov    %esi,0x4(%esp)
  80163a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80163e:	b8 10 00 00 00       	mov    $0x10,%eax
  801643:	8b 75 18             	mov    0x18(%ebp),%esi
  801646:	8b 7d 14             	mov    0x14(%ebp),%edi
  801649:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80164c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80164f:	8b 55 08             	mov    0x8(%ebp),%edx
  801652:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801654:	8b 1c 24             	mov    (%esp),%ebx
  801657:	8b 74 24 04          	mov    0x4(%esp),%esi
  80165b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80165f:	89 ec                	mov    %ebp,%esp
  801661:	5d                   	pop    %ebp
  801662:	c3                   	ret    
	...

00801664 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 38             	sub    $0x38,%esp
  80166a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80166d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801670:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  801673:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  80167a:	f6 c7 04             	test   $0x4,%bh
  80167d:	74 31                	je     8016b0 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  80167f:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  801686:	c1 e2 0c             	shl    $0xc,%edx
  801689:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80168f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801693:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801697:	89 44 24 08          	mov    %eax,0x8(%esp)
  80169b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80169f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a6:	e8 e4 fb ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
        return r;
  8016ab:	e9 8c 00 00 00       	jmp    80173c <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  8016b0:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  8016b7:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  8016bc:	f7 c6 00 08 00 00    	test   $0x800,%esi
  8016c2:	75 2a                	jne    8016ee <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  8016c4:	84 c9                	test   %cl,%cl
  8016c6:	74 0f                	je     8016d7 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  8016c8:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  8016cf:	83 e3 02             	and    $0x2,%ebx
  8016d2:	80 cf 02             	or     $0x2,%bh
  8016d5:	eb 17                	jmp    8016ee <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  8016d7:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  8016de:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  8016e1:	83 f9 01             	cmp    $0x1,%ecx
  8016e4:	19 db                	sbb    %ebx,%ebx
  8016e6:	f7 d3                	not    %ebx
  8016e8:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  8016ee:	89 df                	mov    %ebx,%edi
  8016f0:	83 cf 05             	or     $0x5,%edi
  8016f3:	89 d6                	mov    %edx,%esi
  8016f5:	c1 e6 0c             	shl    $0xc,%esi
  8016f8:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8016fc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801700:	89 44 24 08          	mov    %eax,0x8(%esp)
  801704:	89 74 24 04          	mov    %esi,0x4(%esp)
  801708:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80170f:	e8 7b fb ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  801714:	85 c0                	test   %eax,%eax
  801716:	75 24                	jne    80173c <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  801718:	85 db                	test   %ebx,%ebx
  80171a:	74 20                	je     80173c <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80171c:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801720:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801724:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80172b:	00 
  80172c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801737:	e8 53 fb ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  80173c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80173f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801742:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801745:	89 ec                	mov    %ebp,%esp
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    

00801749 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 28             	sub    $0x28,%esp
  80174f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801752:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801755:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  801758:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  80175a:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  80175e:	0f 84 ff 00 00 00    	je     801863 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  801764:	89 f0                	mov    %esi,%eax
  801766:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  801769:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801770:	f6 c4 08             	test   $0x8,%ah
  801773:	0f 84 ea 00 00 00    	je     801863 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801779:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801780:	00 
  801781:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801788:	00 
  801789:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801790:	e8 9b fa ff ff       	call   801230 <_Z14sys_page_allociPvi>
  801795:	85 c0                	test   %eax,%eax
  801797:	79 20                	jns    8017b9 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  801799:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80179d:	c7 44 24 08 bf 54 80 	movl   $0x8054bf,0x8(%esp)
  8017a4:	00 
  8017a5:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8017ac:	00 
  8017ad:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  8017b4:	e8 57 ee ff ff       	call   800610 <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  8017b9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  8017bf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8017c6:	00 
  8017c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017cb:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8017d2:	e8 90 f7 ff ff       	call   800f67 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8017d7:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8017de:	00 
  8017df:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017ea:	00 
  8017eb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8017f2:	00 
  8017f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017fa:	e8 90 fa ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  8017ff:	85 c0                	test   %eax,%eax
  801801:	79 20                	jns    801823 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  801803:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801807:	c7 44 24 08 dd 54 80 	movl   $0x8054dd,0x8(%esp)
  80180e:	00 
  80180f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801816:	00 
  801817:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  80181e:	e8 ed ed ff ff       	call   800610 <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801823:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80182a:	00 
  80182b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801832:	e8 b6 fa ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
  801837:	85 c0                	test   %eax,%eax
  801839:	79 20                	jns    80185b <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  80183b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80183f:	c7 44 24 08 ee 54 80 	movl   $0x8054ee,0x8(%esp)
  801846:	00 
  801847:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80184e:	00 
  80184f:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  801856:	e8 b5 ed ff ff       	call   800610 <_Z6_panicPKciS0_z>
    resume(utf);
  80185b:	89 1c 24             	mov    %ebx,(%esp)
  80185e:	e8 8d 33 00 00       	call   804bf0 <resume>
}
  801863:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801866:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801869:	89 ec                	mov    %ebp,%esp
  80186b:	5d                   	pop    %ebp
  80186c:	c3                   	ret    

0080186d <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	57                   	push   %edi
  801871:	56                   	push   %esi
  801872:	53                   	push   %ebx
  801873:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  801876:	c7 04 24 49 17 80 00 	movl   $0x801749,(%esp)
  80187d:	e8 99 32 00 00       	call   804b1b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  801882:	be 07 00 00 00       	mov    $0x7,%esi
  801887:	89 f0                	mov    %esi,%eax
  801889:	cd 30                	int    $0x30
  80188b:	89 c6                	mov    %eax,%esi
  80188d:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  80188f:	85 c0                	test   %eax,%eax
  801891:	79 20                	jns    8018b3 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  801893:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801897:	c7 44 24 08 01 55 80 	movl   $0x805501,0x8(%esp)
  80189e:	00 
  80189f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8018a6:	00 
  8018a7:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  8018ae:	e8 5d ed ff ff       	call   800610 <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  8018b3:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	75 1c                	jne    8018d8 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  8018bc:	e8 07 f9 ff ff       	call   8011c8 <_Z12sys_getenvidv>
  8018c1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8018c6:	6b c0 78             	imul   $0x78,%eax,%eax
  8018c9:	05 00 00 00 ef       	add    $0xef000000,%eax
  8018ce:	a3 00 70 80 00       	mov    %eax,0x807000
        return 0;
  8018d3:	e9 de 00 00 00       	jmp    8019b6 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  8018d8:	89 d8                	mov    %ebx,%eax
  8018da:	c1 f8 0a             	sar    $0xa,%eax
  8018dd:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8018e4:	a8 01                	test   $0x1,%al
  8018e6:	75 08                	jne    8018f0 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  8018e8:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8018ee:	eb 19                	jmp    801909 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  8018f0:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8018f7:	a8 01                	test   $0x1,%al
  8018f9:	74 0e                	je     801909 <_Z4forkv+0x9c>
            duppage(envid, pn);
  8018fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801900:	89 da                	mov    %ebx,%edx
  801902:	89 f8                	mov    %edi,%eax
  801904:	e8 5b fd ff ff       	call   801664 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801909:	83 eb 01             	sub    $0x1,%ebx
  80190c:	79 ca                	jns    8018d8 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  80190e:	a1 00 70 80 00       	mov    0x807000,%eax
  801913:	8b 40 5c             	mov    0x5c(%eax),%eax
  801916:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191a:	89 34 24             	mov    %esi,(%esp)
  80191d:	e8 43 fb ff ff       	call   801465 <_Z26sys_env_set_pgfault_upcalliPv>
  801922:	85 c0                	test   %eax,%eax
  801924:	74 20                	je     801946 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801926:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80192a:	c7 44 24 08 28 55 80 	movl   $0x805528,0x8(%esp)
  801931:	00 
  801932:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  801939:	00 
  80193a:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  801941:	e8 ca ec ff ff       	call   800610 <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801946:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80194d:	00 
  80194e:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  801955:	ee 
  801956:	89 34 24             	mov    %esi,(%esp)
  801959:	e8 d2 f8 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  80195e:	85 c0                	test   %eax,%eax
  801960:	79 20                	jns    801982 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  801962:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801966:	c7 44 24 08 bf 54 80 	movl   $0x8054bf,0x8(%esp)
  80196d:	00 
  80196e:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  801975:	00 
  801976:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  80197d:	e8 8e ec ff ff       	call   800610 <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801982:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801989:	00 
  80198a:	89 34 24             	mov    %esi,(%esp)
  80198d:	e8 b9 f9 ff ff       	call   80134b <_Z18sys_env_set_statusii>
  801992:	85 c0                	test   %eax,%eax
  801994:	79 20                	jns    8019b6 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  801996:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80199a:	c7 44 24 08 11 55 80 	movl   $0x805511,0x8(%esp)
  8019a1:	00 
  8019a2:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  8019a9:	00 
  8019aa:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  8019b1:	e8 5a ec ff ff       	call   800610 <_Z6_panicPKciS0_z>

    return envid;
}
  8019b6:	89 f0                	mov    %esi,%eax
  8019b8:	83 c4 1c             	add    $0x1c,%esp
  8019bb:	5b                   	pop    %ebx
  8019bc:	5e                   	pop    %esi
  8019bd:	5f                   	pop    %edi
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    

008019c0 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	57                   	push   %edi
  8019c4:	56                   	push   %esi
  8019c5:	53                   	push   %ebx
  8019c6:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  8019c9:	c7 04 24 49 17 80 00 	movl   $0x801749,(%esp)
  8019d0:	e8 46 31 00 00       	call   804b1b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  8019d5:	be 07 00 00 00       	mov    $0x7,%esi
  8019da:	89 f0                	mov    %esi,%eax
  8019dc:	cd 30                	int    $0x30
  8019de:	89 c6                	mov    %eax,%esi
  8019e0:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	79 20                	jns    801a06 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  8019e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ea:	c7 44 24 08 01 55 80 	movl   $0x805501,0x8(%esp)
  8019f1:	00 
  8019f2:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  8019f9:	00 
  8019fa:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  801a01:	e8 0a ec ff ff       	call   800610 <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  801a06:	85 c0                	test   %eax,%eax
  801a08:	0f 84 40 01 00 00    	je     801b4e <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  801a0e:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  801a10:	c1 eb 0c             	shr    $0xc,%ebx
  801a13:	83 eb 01             	sub    $0x1,%ebx
  801a16:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  801a19:	eb 31                	jmp    801a4c <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  801a1b:	89 d8                	mov    %ebx,%eax
  801a1d:	c1 f8 0a             	sar    $0xa,%eax
  801a20:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801a27:	a8 01                	test   $0x1,%al
  801a29:	75 08                	jne    801a33 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  801a2b:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801a31:	eb 19                	jmp    801a4c <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  801a33:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801a3a:	a8 01                	test   $0x1,%al
  801a3c:	74 0e                	je     801a4c <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  801a3e:	b9 01 00 00 00       	mov    $0x1,%ecx
  801a43:	89 da                	mov    %ebx,%edx
  801a45:	89 f8                	mov    %edi,%eax
  801a47:	e8 18 fc ff ff       	call   801664 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  801a4c:	83 eb 01             	sub    $0x1,%ebx
  801a4f:	79 ca                	jns    801a1b <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  801a51:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  801a58:	7f 3f                	jg     801a99 <_Z5sforkv+0xd9>
  801a5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  801a5d:	89 d8                	mov    %ebx,%eax
  801a5f:	c1 f8 0a             	sar    $0xa,%eax
  801a62:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801a69:	a8 01                	test   $0x1,%al
  801a6b:	75 08                	jne    801a75 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  801a6d:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801a73:	eb 19                	jmp    801a8e <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  801a75:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801a7c:	a8 01                	test   $0x1,%al
  801a7e:	74 0e                	je     801a8e <_Z5sforkv+0xce>
            duppage(envid, i);
  801a80:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a85:	89 da                	mov    %ebx,%edx
  801a87:	89 f8                	mov    %edi,%eax
  801a89:	e8 d6 fb ff ff       	call   801664 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  801a8e:	83 c3 01             	add    $0x1,%ebx
  801a91:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  801a97:	7e c4                	jle    801a5d <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  801a99:	e8 2a f7 ff ff       	call   8011c8 <_Z12sys_getenvidv>
  801a9e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801aa3:	6b c0 78             	imul   $0x78,%eax,%eax
  801aa6:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  801aab:	8b 40 50             	mov    0x50(%eax),%eax
  801aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab2:	89 34 24             	mov    %esi,(%esp)
  801ab5:	e8 ab f9 ff ff       	call   801465 <_Z26sys_env_set_pgfault_upcalliPv>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	74 20                	je     801ade <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801abe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ac2:	c7 44 24 08 28 55 80 	movl   $0x805528,0x8(%esp)
  801ac9:	00 
  801aca:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801ad1:	00 
  801ad2:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  801ad9:	e8 32 eb ff ff       	call   800610 <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801ade:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ae5:	00 
  801ae6:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  801aed:	ee 
  801aee:	89 34 24             	mov    %esi,(%esp)
  801af1:	e8 3a f7 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  801af6:	85 c0                	test   %eax,%eax
  801af8:	79 20                	jns    801b1a <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  801afa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801afe:	c7 44 24 08 bf 54 80 	movl   $0x8054bf,0x8(%esp)
  801b05:	00 
  801b06:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  801b0d:	00 
  801b0e:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  801b15:	e8 f6 ea ff ff       	call   800610 <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801b1a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b21:	00 
  801b22:	89 34 24             	mov    %esi,(%esp)
  801b25:	e8 21 f8 ff ff       	call   80134b <_Z18sys_env_set_statusii>
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	79 20                	jns    801b4e <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  801b2e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b32:	c7 44 24 08 11 55 80 	movl   $0x805511,0x8(%esp)
  801b39:	00 
  801b3a:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  801b41:	00 
  801b42:	c7 04 24 d2 54 80 00 	movl   $0x8054d2,(%esp)
  801b49:	e8 c2 ea ff ff       	call   800610 <_Z6_panicPKciS0_z>

    return envid;
    
}
  801b4e:	89 f0                	mov    %esi,%eax
  801b50:	83 c4 2c             	add    $0x2c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    

00801b58 <_ZL24utemp_addr_to_stack_addrPv>:
//
// Shift an address from the UTEMP page to the corresponding value in the
// normal stack page (top address USTACKTOP).
//
static uintptr_t utemp_addr_to_stack_addr(void *ptr)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 18             	sub    $0x18,%esp
	uintptr_t addr = (uintptr_t) ptr;
	assert(ptr >= UTEMP && ptr < (char *) UTEMP + PGSIZE);
  801b5e:	8d 90 00 00 c0 ff    	lea    -0x400000(%eax),%edx
  801b64:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
  801b6a:	76 24                	jbe    801b90 <_ZL24utemp_addr_to_stack_addrPv+0x38>
  801b6c:	c7 44 24 0c 48 55 80 	movl   $0x805548,0xc(%esp)
  801b73:	00 
  801b74:	c7 44 24 08 76 55 80 	movl   $0x805576,0x8(%esp)
  801b7b:	00 
  801b7c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  801b83:	00 
  801b84:	c7 04 24 8b 55 80 00 	movl   $0x80558b,(%esp)
  801b8b:	e8 80 ea ff ff       	call   800610 <_Z6_panicPKciS0_z>
	return USTACKTOP - PGSIZE + PGOFF(addr);
  801b90:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b95:	2d 00 30 00 11       	sub    $0x11003000,%eax
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <_Z10spawn_readiPvijji>:
//

int
spawn_read(envid_t dst_env, void *va, int programid, size_t offset, 
           size_t len, int fs_read)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	57                   	push   %edi
  801ba0:	56                   	push   %esi
  801ba1:	53                   	push   %ebx
  801ba2:	83 ec 3c             	sub    $0x3c,%esp
  801ba5:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ba8:	8b 7d 10             	mov    0x10(%ebp),%edi
  801bab:	8b 45 14             	mov    0x14(%ebp),%eax
    int r;
    if(!fs_read)
  801bae:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801bb2:	75 25                	jne    801bd9 <_Z10spawn_readiPvijji+0x3d>
        return sys_program_read(dst_env, va, programid, offset, len);
  801bb4:	8b 55 18             	mov    0x18(%ebp),%edx
  801bb7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801bbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bbf:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801bc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	89 04 24             	mov    %eax,(%esp)
  801bcd:	e8 5b fa ff ff       	call   80162d <_Z16sys_program_readiPvijj>
  801bd2:	89 c3                	mov    %eax,%ebx
  801bd4:	e9 7d 01 00 00       	jmp    801d56 <_Z10spawn_readiPvijji+0x1ba>
    if((r = seek(programid, offset)))
  801bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdd:	89 3c 24             	mov    %edi,(%esp)
  801be0:	e8 46 0d 00 00       	call   80292b <_Z4seekii>
  801be5:	89 c3                	mov    %eax,%ebx
  801be7:	85 c0                	test   %eax,%eax
  801be9:	0f 85 67 01 00 00    	jne    801d56 <_Z10spawn_readiPvijji+0x1ba>
        return r;
    if((uint32_t)va % PGSIZE)
  801bef:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801bf2:	89 f2                	mov    %esi,%edx
  801bf4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801bfa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801bfd:	0f 84 ab 00 00 00    	je     801cae <_Z10spawn_readiPvijji+0x112>
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
  801c03:	a1 00 70 80 00       	mov    0x807000,%eax
  801c08:	8b 40 04             	mov    0x4(%eax),%eax
  801c0b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c12:	00 
  801c13:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c1a:	00 
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 0d f6 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  801c23:	85 c0                	test   %eax,%eax
  801c25:	0f 85 29 01 00 00    	jne    801d54 <_Z10spawn_readiPvijji+0x1b8>
        return sys_program_read(dst_env, va, programid, offset, len);
    if((r = seek(programid, offset)))
        return r;
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
  801c2b:	66 b8 00 10          	mov    $0x1000,%ax
  801c2f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
  801c32:	3b 45 18             	cmp    0x18(%ebp),%eax
  801c35:	0f 47 45 18          	cmova  0x18(%ebp),%eax
  801c39:	89 45 dc             	mov    %eax,-0x24(%ebp)
            return r;
        if((r = readn(programid,(char *)UTEMP+(uint32_t)va%PGSIZE, bytes))<0 ||
  801c3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c43:	05 00 00 40 00       	add    $0x400000,%eax
  801c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4c:	89 3c 24             	mov    %edi,(%esp)
  801c4f:	e8 14 0c 00 00       	call   802868 <_Z5readniPvj>
  801c54:	89 c6                	mov    %eax,%esi
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 39                	js     801c93 <_Z10spawn_readiPvijji+0xf7>
  801c5a:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801c61:	00 
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
  801c62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
            return r;
        if((r = readn(programid,(char *)UTEMP+(uint32_t)va%PGSIZE, bytes))<0 ||
  801c6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c75:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c7c:	00 
  801c7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c84:	e8 06 f6 ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  801c89:	89 c6                	mov    %eax,%esi
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	0f 84 cd 00 00 00    	je     801d60 <_Z10spawn_readiPvijji+0x1c4>
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
  801c93:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c9a:	00 
  801c9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca2:	e8 46 f6 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
            return r;
  801ca7:	89 f3                	mov    %esi,%ebx
  801ca9:	e9 a8 00 00 00       	jmp    801d56 <_Z10spawn_readiPvijji+0x1ba>
        sys_page_unmap(0, UTEMP);
        va = ROUNDUP(va, PGSIZE);
        len -= bytes;
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
  801cae:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801cb1:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb4:	01 f2                	add    %esi,%edx
  801cb6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801cb9:	39 f2                	cmp    %esi,%edx
  801cbb:	0f 86 95 00 00 00    	jbe    801d56 <_Z10spawn_readiPvijji+0x1ba>
// Returns the new environment's ID on success, and < 0 on error.
// If an error occurs, any new environment is destroyed.
//

int
spawn_read(envid_t dst_env, void *va, int programid, size_t offset, 
  801cc1:	8b 75 18             	mov    0x18(%ebp),%esi
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
    {
        uint32_t bytes = (uint32_t)MIN((uint32_t)va + len - (uint32_t)i, (uint32_t)PGSIZE);
        if((r = sys_page_alloc(0, UTEMP, PTE_U | PTE_P|PTE_W)))
  801cc4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ccb:	00 
  801ccc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cd3:	00 
  801cd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cdb:	e8 50 f5 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  801ce0:	89 c3                	mov    %eax,%ebx
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	75 70                	jne    801d56 <_Z10spawn_readiPvijji+0x1ba>
            return r;
        if((r = readn(programid, UTEMP, bytes)) < 0 ||
  801ce6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
  801cec:	b8 00 10 00 00       	mov    $0x1000,%eax
  801cf1:	0f 46 c6             	cmovbe %esi,%eax
  801cf4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cff:	00 
  801d00:	89 3c 24             	mov    %edi,(%esp)
  801d03:	e8 60 0b 00 00       	call   802868 <_Z5readniPvj>
  801d08:	89 c3                	mov    %eax,%ebx
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 30                	js     801d3e <_Z10spawn_readiPvijji+0x1a2>
  801d0e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801d15:	00 
  801d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d19:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d20:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d24:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d2b:	00 
  801d2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d33:	e8 57 f5 ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  801d38:	89 c3                	mov    %eax,%ebx
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	74 50                	je     801d8e <_Z10spawn_readiPvijji+0x1f2>
           (r = sys_page_map(0, UTEMP, dst_env, i, PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
  801d3e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d45:	00 
  801d46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4d:	e8 9b f5 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
            return r;
  801d52:	eb 02                	jmp    801d56 <_Z10spawn_readiPvijji+0x1ba>
        return r;
    if((uint32_t)va % PGSIZE)
    {
        uint32_t bytes = MIN(PGSIZE - (uint32_t)va % PGSIZE, len);
        if((r = sys_page_alloc(thisenv->env_id, UTEMP, PTE_U | PTE_W|PTE_P)))
            return r;
  801d54:	89 c3                	mov    %eax,%ebx
            return r;
        }
        sys_page_unmap(0, UTEMP);
    }
    return 0;
}
  801d56:	89 d8                	mov    %ebx,%eax
  801d58:	83 c4 3c             	add    $0x3c,%esp
  801d5b:	5b                   	pop    %ebx
  801d5c:	5e                   	pop    %esi
  801d5d:	5f                   	pop    %edi
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    
           (r = sys_page_map(0, UTEMP, dst_env, (void *)ROUNDDOWN(va, PGSIZE), PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
  801d60:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d67:	00 
  801d68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d6f:	e8 79 f5 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
        va = ROUNDUP(va, PGSIZE);
  801d74:	8b 75 e0             	mov    -0x20(%ebp),%esi
  801d77:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
  801d7d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        len -= bytes;
  801d83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d86:	29 45 18             	sub    %eax,0x18(%ebp)
  801d89:	e9 20 ff ff ff       	jmp    801cae <_Z10spawn_readiPvijji+0x112>
           (r = sys_page_map(0, UTEMP, dst_env, i, PTE_U | PTE_W | PTE_P)))
        {
            sys_page_unmap(0, UTEMP);
            return r;
        }
        sys_page_unmap(0, UTEMP);
  801d8e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d95:	00 
  801d96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d9d:	e8 4b f5 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
        sys_page_unmap(0, UTEMP);
        va = ROUNDUP(va, PGSIZE);
        len -= bytes;
    }

    for(char *i = (char *)va; i < len + (char *)va; i += PGSIZE)
  801da2:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
  801da9:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  801daf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801db2:	39 55 e0             	cmp    %edx,-0x20(%ebp)
  801db5:	0f 87 09 ff ff ff    	ja     801cc4 <_Z10spawn_readiPvijji+0x128>
  801dbb:	eb 99                	jmp    801d56 <_Z10spawn_readiPvijji+0x1ba>

00801dbd <_Z5spawnPKcPS0_>:
    return 0;
}

envid_t
spawn(const char *prog, const char **argv)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	81 ec b8 02 00 00    	sub    $0x2b8,%esp
  801dc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801dc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801dcc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801dcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unfortunately, you cannot 'read' into a child address space,
	// so you'll need to code the 'read' case differently.
	//
	// Also, make sure you close the file descriptor, if any,
	// before returning from spawn().
    int fs_load = prog[0] == '/';
  801dd2:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  801dd5:	0f 94 c0             	sete   %al
  801dd8:	0f b6 c0             	movzbl %al,%eax
  801ddb:	89 c6                	mov    %eax,%esi
    memset(elf_buf, 0, sizeof(elf_buf)); // ensure stack is writable
  801ddd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801de4:	00 
  801de5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dec:	00 
  801ded:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801df3:	89 04 24             	mov    %eax,(%esp)
  801df6:	e8 96 f0 ff ff       	call   800e91 <memset>
    if(fs_load)
  801dfb:	85 f6                	test   %esi,%esi
  801dfd:	74 41                	je     801e40 <_Z5spawnPKcPS0_+0x83>
    {
        if ((progid = open(prog, O_RDONLY)) < 0)
  801dff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e06:	00 
  801e07:	89 1c 24             	mov    %ebx,(%esp)
  801e0a:	e8 4f 16 00 00       	call   80345e <_Z4openPKci>
  801e0f:	89 c3                	mov    %eax,%ebx
  801e11:	85 c0                	test   %eax,%eax
  801e13:	0f 88 4e 05 00 00    	js     802367 <_Z5spawnPKcPS0_+0x5aa>
            return progid;
        if (readn(progid, elf,sizeof(elf_buf)) != sizeof elf_buf)
  801e19:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801e20:	00 
  801e21:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2b:	89 1c 24             	mov    %ebx,(%esp)
  801e2e:	e8 35 0a 00 00       	call   802868 <_Z5readniPvj>
  801e33:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e38:	0f 85 11 05 00 00    	jne    80234f <_Z5spawnPKcPS0_+0x592>
  801e3e:	eb 51                	jmp    801e91 <_Z5spawnPKcPS0_+0xd4>
            return -E_NOT_EXEC;
    }
    else
    {
        // Read ELF header from the kernel's binary collection.
        if ((progid = sys_program_lookup(prog, strlen(prog))) < 0)
  801e40:	89 1c 24             	mov    %ebx,(%esp)
  801e43:	e8 c8 ee ff ff       	call   800d10 <_Z6strlenPKc>
  801e48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4c:	89 1c 24             	mov    %ebx,(%esp)
  801e4f:	e8 04 f7 ff ff       	call   801558 <_Z18sys_program_lookupPKcj>
  801e54:	89 c3                	mov    %eax,%ebx
  801e56:	85 c0                	test   %eax,%eax
  801e58:	0f 88 09 05 00 00    	js     802367 <_Z5spawnPKcPS0_+0x5aa>
            return progid;
        if (sys_program_read(0, elf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf, 0))
  801e5e:	c7 44 24 10 00 02 00 	movl   $0x200,0x10(%esp)
  801e65:	00 
  801e66:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e6d:	00 
  801e6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e72:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e83:	e8 a5 f7 ff ff       	call   80162d <_Z16sys_program_readiPvijj>
  801e88:	83 f8 04             	cmp    $0x4,%eax
  801e8b:	0f 85 c5 04 00 00    	jne    802356 <_Z5spawnPKcPS0_+0x599>
            return -E_NOT_EXEC;
    }
    if (elf->e_magic != ELF_MAGIC) {
  801e91:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
  801e97:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  801e9c:	74 22                	je     801ec0 <_Z5spawnPKcPS0_+0x103>
        cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801e9e:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801ea5:	46 
  801ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eaa:	c7 04 24 97 55 80 00 	movl   $0x805597,(%esp)
  801eb1:	e8 78 e8 ff ff       	call   80072e <_Z7cprintfPKcz>
        return -E_NOT_EXEC;
  801eb6:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  801ebb:	e9 a7 04 00 00       	jmp    802367 <_Z5spawnPKcPS0_+0x5aa>
	//   although you won't use that fact here.)
	// - Check out sys_env_set_trapframe and init_stack.
	//
	

    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
  801ec0:	8b 95 c0 fd ff ff    	mov    -0x240(%ebp),%edx
  801ec6:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
    struct Proghdr *eph = ph + elf->e_phnum;
  801ecc:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
  801ed3:	66 89 85 76 fd ff ff 	mov    %ax,-0x28a(%ebp)
  801eda:	ba 07 00 00 00       	mov    $0x7,%edx
  801edf:	89 d0                	mov    %edx,%eax
  801ee1:	cd 30                	int    $0x30
  801ee3:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801ee9:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
    
    envid_t envid;
    if ((envid = sys_exofork()) < 0)
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	0f 88 66 04 00 00    	js     80235d <_Z5spawnPKcPS0_+0x5a0>
        return envid;
    
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
  801ef7:	25 ff 03 00 00       	and    $0x3ff,%eax
  801efc:	6b c0 78             	imul   $0x78,%eax,%eax
  801eff:	05 14 00 00 ef       	add    $0xef000014,%eax
  801f04:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  801f0b:	00 
  801f0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f10:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  801f13:	89 04 24             	mov    %eax,(%esp)
  801f16:	e8 4c f0 ff ff       	call   800f67 <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1e:	8b 02                	mov    (%edx),%eax
  801f20:	85 c0                	test   %eax,%eax
  801f22:	0f 84 93 00 00 00    	je     801fbb <_Z5spawnPKcPS0_+0x1fe>
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801f28:	bf 00 00 00 00       	mov    $0x0,%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801f2d:	c7 85 90 fd ff ff 00 	movl   $0x0,-0x270(%ebp)
  801f34:	00 00 00 
  801f37:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801f3d:	89 b5 84 fd ff ff    	mov    %esi,-0x27c(%ebp)
  801f43:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f48:	89 d6                	mov    %edx,%esi
		string_size += strlen(argv[argc]) + 1;
  801f4a:	89 04 24             	mov    %eax,(%esp)
  801f4d:	e8 be ed ff ff       	call   800d10 <_Z6strlenPKc>
  801f52:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801f56:	83 c3 01             	add    $0x1,%ebx
  801f59:	89 da                	mov    %ebx,%edx
  801f5b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801f62:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801f65:	85 c0                	test   %eax,%eax
  801f67:	75 e1                	jne    801f4a <_Z5spawnPKcPS0_+0x18d>
  801f69:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801f6f:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801f75:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
  801f7b:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  801f81:	89 8d 70 fd ff ff    	mov    %ecx,-0x290(%ebp)
	// into the temporary page at UTEMP.
	// Later, we'll remap that page into the child environment
	// at (USTACKTOP - PGSIZE).

	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801f87:	f7 df                	neg    %edi
  801f89:	81 c7 00 10 40 00    	add    $0x401000,%edi

	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);
  801f8f:	89 fa                	mov    %edi,%edx
  801f91:	83 e2 fc             	and    $0xfffffffc,%edx
  801f94:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801f9a:	f7 d0                	not    %eax
  801f9c:	8d 04 82             	lea    (%edx,%eax,4),%eax
  801f9f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801fa5:	83 e8 08             	sub    $0x8,%eax
  801fa8:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801fae:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801fb3:	0f 86 78 01 00 00    	jbe    802131 <_Z5spawnPKcPS0_+0x374>
  801fb9:	eb 37                	jmp    801ff2 <_Z5spawnPKcPS0_+0x235>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801fbb:	c7 85 70 fd ff ff 00 	movl   $0x0,-0x290(%ebp)
  801fc2:	00 00 00 
  801fc5:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801fcc:	00 00 00 
  801fcf:	c7 85 90 fd ff ff 00 	movl   $0x0,-0x270(%ebp)
  801fd6:	00 00 00 
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801fd9:	c7 85 84 fd ff ff f4 	movl   $0x400ff4,-0x27c(%ebp)
  801fe0:	0f 40 00 
	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;

	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *) ROUNDDOWN(string_store, 4) - (argc + 1);
  801fe3:	c7 85 8c fd ff ff fc 	movl   $0x400ffc,-0x274(%ebp)
  801fea:	0f 40 00 
	// into the temporary page at UTEMP.
	// Later, we'll remap that page into the child environment
	// at (USTACKTOP - PGSIZE).

	// strings are topmost on the stack.
	string_store = (char *) UTEMP + PGSIZE - string_size;
  801fed:	bf 00 10 40 00       	mov    $0x401000,%edi
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;

	// Allocate a page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ff2:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ff9:	00 
  801ffa:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802001:	00 
  802002:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802009:	e8 22 f2 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  80200e:	85 c0                	test   %eax,%eax
  802010:	0f 88 1b 01 00 00    	js     802131 <_Z5spawnPKcPS0_+0x374>
		return r;

	// Store the 'argc' and 'argv' parameters themselves
	// below 'argv_store' on the stack.  These parameters will be passed
	// to umain().
	argv_store[-2] = argc;
  802016:	8b 95 7c fd ff ff    	mov    -0x284(%ebp),%edx
  80201c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802022:	89 10                	mov    %edx,(%eax)
	argv_store[-1] = utemp_addr_to_stack_addr(argv_store);
  802024:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80202a:	e8 29 fb ff ff       	call   801b58 <_ZL24utemp_addr_to_stack_addrPv>
  80202f:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802035:	89 42 fc             	mov    %eax,-0x4(%edx)
	// and initialize 'argv_store[i]' to point at argument string i
	// in the child's address space.
	// Then set 'argv_store[argc]' to 0 to null-terminate the args array.
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
  802038:	83 bd 90 fd ff ff 00 	cmpl   $0x0,-0x270(%ebp)
  80203f:	7e 71                	jle    8020b2 <_Z5spawnPKcPS0_+0x2f5>
  802041:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802048:	00 00 00 
  80204b:	89 9d 6c fd ff ff    	mov    %ebx,-0x294(%ebp)
  802051:	89 b5 68 fd ff ff    	mov    %esi,-0x298(%ebp)
  802057:	be 00 00 00 00       	mov    $0x0,%esi
  80205c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);
  80205f:	89 f8                	mov    %edi,%eax
  802061:	e8 f2 fa ff ff       	call   801b58 <_ZL24utemp_addr_to_stack_addrPv>
    }
    return 0;
}

envid_t
spawn(const char *prog, const char **argv)
  802066:	89 f1                	mov    %esi,%ecx
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);
  802068:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  80206e:	89 04 b2             	mov    %eax,(%edx,%esi,4)

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  802071:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802074:	0f b6 00             	movzbl (%eax),%eax
  802077:	84 c0                	test   %al,%al
  802079:	74 18                	je     802093 <_Z5spawnPKcPS0_+0x2d6>
  80207b:	ba 00 00 00 00       	mov    $0x0,%edx
        {
            *string_store = argv[i][j];
  802080:	88 07                	mov    %al,(%edi)
            string_store++;
  802082:	83 c7 01             	add    $0x1,%edi
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  802085:	83 c2 01             	add    $0x1,%edx
  802088:	8b 04 8b             	mov    (%ebx,%ecx,4),%eax
  80208b:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  80208f:	84 c0                	test   %al,%al
  802091:	75 ed                	jne    802080 <_Z5spawnPKcPS0_+0x2c3>
        {
            *string_store = argv[i][j];
            string_store++;
        }
        // terminate the string
        *string_store = '\0';
  802093:	c6 07 00             	movb   $0x0,(%edi)
	// and initialize 'argv_store[i]' to point at argument string i
	// in the child's address space.
	// Then set 'argv_store[argc]' to 0 to null-terminate the args array.
	// LAB 4: Your code here.

	for (int i = 0; i < argc; i++)
  802096:	83 c6 01             	add    $0x1,%esi
  802099:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  80209f:	7d 05                	jge    8020a6 <_Z5spawnPKcPS0_+0x2e9>
            *string_store = argv[i][j];
            string_store++;
        }
        // terminate the string
        *string_store = '\0';
        string_store++;
  8020a1:	83 c7 01             	add    $0x1,%edi
  8020a4:	eb b9                	jmp    80205f <_Z5spawnPKcPS0_+0x2a2>
  8020a6:	8b 9d 6c fd ff ff    	mov    -0x294(%ebp),%ebx
  8020ac:	8b b5 68 fd ff ff    	mov    -0x298(%ebp),%esi
    }   
    
    // null-terminate the whole argv array
    argv_store[argc] = 0;
  8020b2:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8020b8:	8b 85 70 fd ff ff    	mov    -0x290(%ebp),%eax
  8020be:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)

	// Set *init_esp to the initial stack pointer for the child:
	// it should point at the "argc" value stored on the stack.
	// set the initial stack to point at argc
    *init_esp = utemp_addr_to_stack_addr(&argv_store[-2]);
  8020c5:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8020cb:	e8 88 fa ff ff       	call   801b58 <_ZL24utemp_addr_to_stack_addrPv>
  8020d0:	89 45 e0             	mov    %eax,-0x20(%ebp)


	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020d3:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8020da:	00 
  8020db:	c7 44 24 0c 00 d0 ff 	movl   $0xeeffd000,0xc(%esp)
  8020e2:	ee 
  8020e3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020ed:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020f4:	00 
  8020f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020fc:	e8 8e f1 ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  802101:	85 c0                	test   %eax,%eax
  802103:	78 18                	js     80211d <_Z5spawnPKcPS0_+0x360>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802105:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80210c:	00 
  80210d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802114:	e8 d4 f1 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
  802119:	85 c0                	test   %eax,%eax
  80211b:	79 14                	jns    802131 <_Z5spawnPKcPS0_+0x374>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80211d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802124:	00 
  802125:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212c:	e8 bc f1 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
        return envid;
    
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
  802131:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
  802137:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if ((r = sys_env_set_trapframe(envid, &tf)))
  80213a:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  80213d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802141:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802147:	89 14 24             	mov    %edx,(%esp)
  80214a:	e8 b8 f2 ff ff       	call   801407 <_Z21sys_env_set_trapframeiP9Trapframe>
  80214f:	85 c0                	test   %eax,%eax
  802151:	0f 85 0e 02 00 00    	jne    802365 <_Z5spawnPKcPS0_+0x5a8>
	//   although you won't use that fact here.)
	// - Check out sys_env_set_trapframe and init_stack.
	//
	

    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
  802157:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80215d:	03 bd 80 fd ff ff    	add    -0x280(%ebp),%edi
    struct Proghdr *eph = ph + elf->e_phnum;
  802163:	0f b7 85 76 fd ff ff 	movzwl -0x28a(%ebp),%eax
  80216a:	c1 e0 05             	shl    $0x5,%eax
  80216d:	8d 04 07             	lea    (%edi,%eax,1),%eax
  802170:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
    // iterate over each program header in the elf file
    for(; ph < eph; ++ph)
  802176:	39 c7                	cmp    %eax,%edi
  802178:	0f 83 25 01 00 00    	jae    8022a3 <_Z5spawnPKcPS0_+0x4e6>
  80217e:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  802184:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  80218a:	89 fe                	mov    %edi,%esi
  80218c:	8b bd 78 fd ff ff    	mov    -0x288(%ebp),%edi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
  802192:	83 3e 01             	cmpl   $0x1,(%esi)
  802195:	0f 85 ed 00 00 00    	jne    802288 <_Z5spawnPKcPS0_+0x4cb>
{
    // identical to segment alloc for load_elf!
    int r;

    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
  80219b:	8b 5e 08             	mov    0x8(%esi),%ebx
  80219e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    len = ROUNDUP(va + len, PGSIZE);
  8021a4:	8b 46 14             	mov    0x14(%esi),%eax
  8021a7:	8d 84 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%eax
  8021ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021b3:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)

    // allocate pages for the whole region
    for (uintptr_t i = va; i < len; i+=PGSIZE)
  8021b9:	39 c3                	cmp    %eax,%ebx
  8021bb:	73 3c                	jae    8021f9 <_Z5spawnPKcPS0_+0x43c>
  8021bd:	89 b5 8c fd ff ff    	mov    %esi,-0x274(%ebp)
  8021c3:	89 c6                	mov    %eax,%esi
        if ((r = sys_page_alloc(dst_env, (void *)i, PTE_P|PTE_U|PTE_W)))
  8021c5:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8021cc:	00 
  8021cd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021d1:	89 3c 24             	mov    %edi,(%esp)
  8021d4:	e8 57 f0 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	74 0c                	je     8021e9 <_Z5spawnPKcPS0_+0x42c>
  8021dd:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
        {
            // allocate the region for it and read the data into the region
	        if ((r = segment_alloc(envid, ph->p_va, ph->p_memsz)) ||
  8021e3:	f7 d8                	neg    %eax
  8021e5:	75 4b                	jne    802232 <_Z5spawnPKcPS0_+0x475>
  8021e7:	eb 10                	jmp    8021f9 <_Z5spawnPKcPS0_+0x43c>
    uintptr_t oldva = va;
    va = ROUNDDOWN(va, PGSIZE);
    len = ROUNDUP(va + len, PGSIZE);

    // allocate pages for the whole region
    for (uintptr_t i = va; i < len; i+=PGSIZE)
  8021e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8021ef:	39 de                	cmp    %ebx,%esi
  8021f1:	77 d2                	ja     8021c5 <_Z5spawnPKcPS0_+0x408>
  8021f3:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
    {
        // load it into memory if we are supposed to
        if (ph->p_type == ELF_PROG_LOAD)
        {
            // allocate the region for it and read the data into the region
	        if ((r = segment_alloc(envid, ph->p_va, ph->p_memsz)) ||
  8021f9:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8021ff:	89 44 24 14          	mov    %eax,0x14(%esp)
  802203:	8b 46 10             	mov    0x10(%esi),%eax
  802206:	89 44 24 10          	mov    %eax,0x10(%esp)
  80220a:	8b 46 04             	mov    0x4(%esi),%eax
  80220d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802211:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  802217:	89 54 24 08          	mov    %edx,0x8(%esp)
  80221b:	8b 46 08             	mov    0x8(%esi),%eax
  80221e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802222:	89 3c 24             	mov    %edi,(%esp)
  802225:	e8 72 f9 ff ff       	call   801b9c <_Z10spawn_readiPvijji>
  80222a:	85 c0                	test   %eax,%eax
  80222c:	0f 89 44 01 00 00    	jns    802376 <_Z5spawnPKcPS0_+0x5b9>
  802232:	89 c7                	mov    %eax,%edi
               (r = spawn_read(envid, (void *)ph->p_va, progid, ph->p_offset, ph->p_filesz, fs_load)) < 0)
            {
                sys_env_destroy(envid);
  802234:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80223a:	89 04 24             	mov    %eax,(%esp)
  80223d:	e8 29 ef ff ff       	call   80116b <_Z15sys_env_destroyi>
                return r;
  802242:	89 fb                	mov    %edi,%ebx
  802244:	e9 1e 01 00 00       	jmp    802367 <_Z5spawnPKcPS0_+0x5aa>
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  802249:	8b 46 08             	mov    0x8(%esi),%eax
  80224c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802251:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  802258:	00 
  802259:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80225d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802261:	89 44 24 04          	mov    %eax,0x4(%esp)
  802265:	89 3c 24             	mov    %edi,(%esp)
  802268:	e8 22 f0 ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  80226d:	85 c0                	test   %eax,%eax
  80226f:	74 17                	je     802288 <_Z5spawnPKcPS0_+0x4cb>
  802271:	89 c7                	mov    %eax,%edi
            {
                sys_env_destroy(envid);
  802273:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802279:	89 14 24             	mov    %edx,(%esp)
  80227c:	e8 ea ee ff ff       	call   80116b <_Z15sys_env_destroyi>
                return r;
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  802281:	89 fb                	mov    %edi,%ebx
            {
                sys_env_destroy(envid);
                return r;
  802283:	e9 df 00 00 00       	jmp    802367 <_Z5spawnPKcPS0_+0x5aa>
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
    // iterate over each program header in the elf file
    for(; ph < eph; ++ph)
  802288:	83 c6 20             	add    $0x20,%esi
  80228b:	39 b5 94 fd ff ff    	cmp    %esi,-0x26c(%ebp)
  802291:	0f 87 fb fe ff ff    	ja     802192 <_Z5spawnPKcPS0_+0x3d5>
  802297:	8b 9d 84 fd ff ff    	mov    -0x27c(%ebp),%ebx
  80229d:	8b b5 80 fd ff ff    	mov    -0x280(%ebp),%esi
            }
                 
        }
    }

    if(fs_load)
  8022a3:	85 f6                	test   %esi,%esi
  8022a5:	74 08                	je     8022af <_Z5spawnPKcPS0_+0x4f2>
        close(progid);
  8022a7:	89 1c 24             	mov    %ebx,(%esp)
  8022aa:	e8 76 03 00 00       	call   802625 <_Z5closei>
    {
        // store the start of the word in the next argv
        argv_store[i] = utemp_addr_to_stack_addr(string_store);

        // store each character in the string_store
		for(int j = 0; argv[i][j] != 0; j++)
  8022af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022b4:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
copy_shared_pages(envid_t child)
{
	uintptr_t va;
	int r;
	for (va = 0; va < UTOP; va += PGSIZE)
		if (!(vpd[PDX(va)] & PTE_P))
  8022ba:	89 d8                	mov    %ebx,%eax
  8022bc:	c1 e8 16             	shr    $0x16,%eax
  8022bf:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8022c6:	a8 01                	test   $0x1,%al
  8022c8:	75 0e                	jne    8022d8 <_Z5spawnPKcPS0_+0x51b>
			va = ROUNDUP(va + 1, PTSIZE) - PGSIZE;
  8022ca:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  8022d0:	8d 9b 00 f0 3f 00    	lea    0x3ff000(%ebx),%ebx
  8022d6:	eb 46                	jmp    80231e <_Z5spawnPKcPS0_+0x561>
		else if ((vpt[PGNUM(va)] & (PTE_P|PTE_SHARE)) == (PTE_P|PTE_SHARE)) {
  8022d8:	89 d8                	mov    %ebx,%eax
  8022da:	c1 e8 0c             	shr    $0xc,%eax
  8022dd:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8022e4:	81 e2 01 04 00 00    	and    $0x401,%edx
  8022ea:	81 fa 01 04 00 00    	cmp    $0x401,%edx
  8022f0:	75 2c                	jne    80231e <_Z5spawnPKcPS0_+0x561>
			r = sys_page_map(0, (void *) va, child, (void *) va,
					 vpt[PGNUM(va)] & PTE_SYSCALL);
  8022f2:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8022f9:	25 07 0e 00 00       	and    $0xe07,%eax
  8022fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  802302:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802306:	89 74 24 08          	mov    %esi,0x8(%esp)
  80230a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80230e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802315:	e8 75 ef ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
			if (r < 0)
  80231a:	85 c0                	test   %eax,%eax
  80231c:	78 0e                	js     80232c <_Z5spawnPKcPS0_+0x56f>
static int
copy_shared_pages(envid_t child)
{
	uintptr_t va;
	int r;
	for (va = 0; va < UTOP; va += PGSIZE)
  80231e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802324:	81 fb ff ff ff ee    	cmp    $0xeeffffff,%ebx
  80232a:	76 8e                	jbe    8022ba <_Z5spawnPKcPS0_+0x4fd>
    if(fs_load)
        close(progid);
    copy_shared_pages(envid);
    
    // set our spawned process to runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80232c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802333:	00 
  802334:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80233a:	89 04 24             	mov    %eax,(%esp)
  80233d:	e8 09 f0 ff ff       	call   80134b <_Z18sys_env_set_statusii>
        return r;
  802342:	85 c0                	test   %eax,%eax
  802344:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
  80234a:	0f 48 d8             	cmovs  %eax,%ebx
  80234d:	eb 18                	jmp    802367 <_Z5spawnPKcPS0_+0x5aa>
    if(fs_load)
    {
        if ((progid = open(prog, O_RDONLY)) < 0)
            return progid;
        if (readn(progid, elf,sizeof(elf_buf)) != sizeof elf_buf)
            return -E_NOT_EXEC;
  80234f:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  802354:	eb 11                	jmp    802367 <_Z5spawnPKcPS0_+0x5aa>
    {
        // Read ELF header from the kernel's binary collection.
        if ((progid = sys_program_lookup(prog, strlen(prog))) < 0)
            return progid;
        if (sys_program_read(0, elf, progid, 0, sizeof(elf_buf)) != sizeof(elf_buf, 0))
            return -E_NOT_EXEC;
  802356:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
  80235b:	eb 0a                	jmp    802367 <_Z5spawnPKcPS0_+0x5aa>
    ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
    struct Proghdr *eph = ph + elf->e_phnum;
    
    envid_t envid;
    if ((envid = sys_exofork()) < 0)
        return envid;
  80235d:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
  802363:	eb 02                	jmp    802367 <_Z5spawnPKcPS0_+0x5aa>
    struct Trapframe tf;
    memcpy(&tf, (void *)&envs[ENVX(envid)].env_tf, sizeof(struct Trapframe));
    init_stack(envid, argv, &tf.tf_esp);
    tf.tf_eip = elf->e_entry;
    if ((r = sys_env_set_trapframe(envid, &tf)))
        return r;
  802365:	89 c3                	mov    %eax,%ebx
    
    // set our spawned process to runnable
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
        return r;
    return envid;
}
  802367:	89 d8                	mov    %ebx,%eax
  802369:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80236c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80236f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802372:	89 ec                	mov    %ebp,%esp
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    
                return r;
            }

            // if the region is not flagged writeable, remove write permissions
            int perm = (ph->p_flags & ELF_PROG_FLAG_WRITE)?PTE_W:0;
            if(!perm && (r = sys_page_map(envid, (void *)ROUNDDOWN(ph->p_va, PGSIZE),envid, (void *)ROUNDDOWN(ph->p_va,PGSIZE), PTE_U | PTE_P)))
  802376:	f6 46 18 02          	testb  $0x2,0x18(%esi)
  80237a:	0f 85 08 ff ff ff    	jne    802288 <_Z5spawnPKcPS0_+0x4cb>
  802380:	e9 c4 fe ff ff       	jmp    802249 <_Z5spawnPKcPS0_+0x48c>

00802385 <_Z6spawnlPKcS0_z>:
}

// Spawn, taking command-line arguments array directly on the stack.
envid_t
spawnl(const char *prog, const char *arg0, ...)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  80238b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80238e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	89 04 24             	mov    %eax,(%esp)
  802398:	e8 20 fa ff ff       	call   801dbd <_Z5spawnPKcPS0_>
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    
	...

008023a0 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8023a3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8023a8:	75 11                	jne    8023bb <_ZL8fd_validPK2Fd+0x1b>
  8023aa:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  8023af:	76 0a                	jbe    8023bb <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  8023b1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  8023b6:	0f 96 c0             	setbe  %al
  8023b9:	eb 05                	jmp    8023c0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c0:	5d                   	pop    %ebp
  8023c1:	c3                   	ret    

008023c2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	53                   	push   %ebx
  8023c6:	83 ec 14             	sub    $0x14,%esp
  8023c9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  8023cb:	e8 d0 ff ff ff       	call   8023a0 <_ZL8fd_validPK2Fd>
  8023d0:	84 c0                	test   %al,%al
  8023d2:	75 24                	jne    8023f8 <_ZL9fd_isopenPK2Fd+0x36>
  8023d4:	c7 44 24 0c b1 55 80 	movl   $0x8055b1,0xc(%esp)
  8023db:	00 
  8023dc:	c7 44 24 08 76 55 80 	movl   $0x805576,0x8(%esp)
  8023e3:	00 
  8023e4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8023eb:	00 
  8023ec:	c7 04 24 be 55 80 00 	movl   $0x8055be,(%esp)
  8023f3:	e8 18 e2 ff ff       	call   800610 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  8023f8:	89 d8                	mov    %ebx,%eax
  8023fa:	c1 e8 16             	shr    $0x16,%eax
  8023fd:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  802404:	b8 00 00 00 00       	mov    $0x0,%eax
  802409:	f6 c2 01             	test   $0x1,%dl
  80240c:	74 0d                	je     80241b <_ZL9fd_isopenPK2Fd+0x59>
  80240e:	c1 eb 0c             	shr    $0xc,%ebx
  802411:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  802418:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  80241b:	83 c4 14             	add    $0x14,%esp
  80241e:	5b                   	pop    %ebx
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    

00802421 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	83 ec 08             	sub    $0x8,%esp
  802427:	89 1c 24             	mov    %ebx,(%esp)
  80242a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80242e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802431:	8b 75 0c             	mov    0xc(%ebp),%esi
  802434:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  802438:	83 fb 1f             	cmp    $0x1f,%ebx
  80243b:	77 18                	ja     802455 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  80243d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  802443:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  802446:	84 c0                	test   %al,%al
  802448:	74 21                	je     80246b <_Z9fd_lookupiPP2Fdb+0x4a>
  80244a:	89 d8                	mov    %ebx,%eax
  80244c:	e8 71 ff ff ff       	call   8023c2 <_ZL9fd_isopenPK2Fd>
  802451:	84 c0                	test   %al,%al
  802453:	75 16                	jne    80246b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  802455:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  80245b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  802460:	8b 1c 24             	mov    (%esp),%ebx
  802463:	8b 74 24 04          	mov    0x4(%esp),%esi
  802467:	89 ec                	mov    %ebp,%esp
  802469:	5d                   	pop    %ebp
  80246a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  80246b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  80246d:	b8 00 00 00 00       	mov    $0x0,%eax
  802472:	eb ec                	jmp    802460 <_Z9fd_lookupiPP2Fdb+0x3f>

00802474 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	53                   	push   %ebx
  802478:	83 ec 14             	sub    $0x14,%esp
  80247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  80247e:	89 d8                	mov    %ebx,%eax
  802480:	e8 1b ff ff ff       	call   8023a0 <_ZL8fd_validPK2Fd>
  802485:	84 c0                	test   %al,%al
  802487:	75 24                	jne    8024ad <_Z6fd2numP2Fd+0x39>
  802489:	c7 44 24 0c b1 55 80 	movl   $0x8055b1,0xc(%esp)
  802490:	00 
  802491:	c7 44 24 08 76 55 80 	movl   $0x805576,0x8(%esp)
  802498:	00 
  802499:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8024a0:	00 
  8024a1:	c7 04 24 be 55 80 00 	movl   $0x8055be,(%esp)
  8024a8:	e8 63 e1 ff ff       	call   800610 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024ad:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  8024b3:	c1 e8 0c             	shr    $0xc,%eax
}
  8024b6:	83 c4 14             	add    $0x14,%esp
  8024b9:	5b                   	pop    %ebx
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    

008024bc <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	89 04 24             	mov    %eax,(%esp)
  8024c8:	e8 a7 ff ff ff       	call   802474 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  8024cd:	05 20 00 0d 00       	add    $0xd0020,%eax
  8024d2:	c1 e0 0c             	shl    $0xc,%eax
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	57                   	push   %edi
  8024db:	56                   	push   %esi
  8024dc:	53                   	push   %ebx
  8024dd:	83 ec 2c             	sub    $0x2c,%esp
  8024e0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  8024e3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  8024e8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8024eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024f2:	00 
  8024f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024f7:	89 1c 24             	mov    %ebx,(%esp)
  8024fa:	e8 22 ff ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  8024ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802502:	e8 bb fe ff ff       	call   8023c2 <_ZL9fd_isopenPK2Fd>
  802507:	84 c0                	test   %al,%al
  802509:	75 0c                	jne    802517 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  80250b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250e:	89 07                	mov    %eax,(%edi)
			return 0;
  802510:	b8 00 00 00 00       	mov    $0x0,%eax
  802515:	eb 13                	jmp    80252a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  802517:	83 c3 01             	add    $0x1,%ebx
  80251a:	83 fb 20             	cmp    $0x20,%ebx
  80251d:	75 cc                	jne    8024eb <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80251f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  802525:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80252a:	83 c4 2c             	add    $0x2c,%esp
  80252d:	5b                   	pop    %ebx
  80252e:	5e                   	pop    %esi
  80252f:	5f                   	pop    %edi
  802530:	5d                   	pop    %ebp
  802531:	c3                   	ret    

00802532 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	53                   	push   %ebx
  802536:	83 ec 14             	sub    $0x14,%esp
  802539:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80253c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  80253f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  802544:	39 0d 20 60 80 00    	cmp    %ecx,0x806020
  80254a:	75 16                	jne    802562 <_Z10dev_lookupiPP3Dev+0x30>
  80254c:	eb 06                	jmp    802554 <_Z10dev_lookupiPP3Dev+0x22>
  80254e:	39 0a                	cmp    %ecx,(%edx)
  802550:	75 10                	jne    802562 <_Z10dev_lookupiPP3Dev+0x30>
  802552:	eb 05                	jmp    802559 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802554:	ba 20 60 80 00       	mov    $0x806020,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  802559:	89 13                	mov    %edx,(%ebx)
			return 0;
  80255b:	b8 00 00 00 00       	mov    $0x0,%eax
  802560:	eb 35                	jmp    802597 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802562:	83 c0 01             	add    $0x1,%eax
  802565:	8b 14 85 28 56 80 00 	mov    0x805628(,%eax,4),%edx
  80256c:	85 d2                	test   %edx,%edx
  80256e:	75 de                	jne    80254e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802570:	a1 00 70 80 00       	mov    0x807000,%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80257c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802580:	c7 04 24 e4 55 80 00 	movl   $0x8055e4,(%esp)
  802587:	e8 a2 e1 ff ff       	call   80072e <_Z7cprintfPKcz>
	*dev = 0;
  80258c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  802592:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802597:	83 c4 14             	add    $0x14,%esp
  80259a:	5b                   	pop    %ebx
  80259b:	5d                   	pop    %ebp
  80259c:	c3                   	ret    

0080259d <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
  8025a0:	56                   	push   %esi
  8025a1:	53                   	push   %ebx
  8025a2:	83 ec 20             	sub    $0x20,%esp
  8025a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8025a8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  8025ac:	89 34 24             	mov    %esi,(%esp)
  8025af:	e8 c0 fe ff ff       	call   802474 <_Z6fd2numP2Fd>
  8025b4:	0f b6 d3             	movzbl %bl,%edx
  8025b7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025bb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025be:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025c2:	89 04 24             	mov    %eax,(%esp)
  8025c5:	e8 57 fe ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  8025ca:	85 c0                	test   %eax,%eax
  8025cc:	78 05                	js     8025d3 <_Z8fd_closeP2Fdb+0x36>
  8025ce:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8025d1:	74 0c                	je     8025df <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  8025d3:	80 fb 01             	cmp    $0x1,%bl
  8025d6:	19 db                	sbb    %ebx,%ebx
  8025d8:	f7 d3                	not    %ebx
  8025da:	83 e3 fd             	and    $0xfffffffd,%ebx
  8025dd:	eb 3d                	jmp    80261c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8025df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e6:	8b 06                	mov    (%esi),%eax
  8025e8:	89 04 24             	mov    %eax,(%esp)
  8025eb:	e8 42 ff ff ff       	call   802532 <_Z10dev_lookupiPP3Dev>
  8025f0:	89 c3                	mov    %eax,%ebx
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	78 16                	js     80260c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  8025f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f9:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8025fc:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802601:	85 c0                	test   %eax,%eax
  802603:	74 07                	je     80260c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  802605:	89 34 24             	mov    %esi,(%esp)
  802608:	ff d0                	call   *%eax
  80260a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80260c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802610:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802617:	e8 d1 ec ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
	return r;
}
  80261c:	89 d8                	mov    %ebx,%eax
  80261e:	83 c4 20             	add    $0x20,%esp
  802621:	5b                   	pop    %ebx
  802622:	5e                   	pop    %esi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    

00802625 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
  802628:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  80262b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802632:	00 
  802633:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802636:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	89 04 24             	mov    %eax,(%esp)
  802640:	e8 dc fd ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  802645:	85 c0                	test   %eax,%eax
  802647:	78 13                	js     80265c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  802649:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802650:	00 
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	89 04 24             	mov    %eax,(%esp)
  802657:	e8 41 ff ff ff       	call   80259d <_Z8fd_closeP2Fdb>
}
  80265c:	c9                   	leave  
  80265d:	c3                   	ret    

0080265e <_Z9close_allv>:

void
close_all(void)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
  802661:	53                   	push   %ebx
  802662:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  802665:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80266a:	89 1c 24             	mov    %ebx,(%esp)
  80266d:	e8 b3 ff ff ff       	call   802625 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  802672:	83 c3 01             	add    $0x1,%ebx
  802675:	83 fb 20             	cmp    $0x20,%ebx
  802678:	75 f0                	jne    80266a <_Z9close_allv+0xc>
		close(i);
}
  80267a:	83 c4 14             	add    $0x14,%esp
  80267d:	5b                   	pop    %ebx
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    

00802680 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 48             	sub    $0x48,%esp
  802686:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802689:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80268c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80268f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  802692:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802699:	00 
  80269a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80269d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a4:	89 04 24             	mov    %eax,(%esp)
  8026a7:	e8 75 fd ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  8026ac:	89 c3                	mov    %eax,%ebx
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	0f 88 ce 00 00 00    	js     802784 <_Z3dupii+0x104>
  8026b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026bd:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  8026be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8026c1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  8026c5:	89 34 24             	mov    %esi,(%esp)
  8026c8:	e8 54 fd ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  8026cd:	89 c3                	mov    %eax,%ebx
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	0f 89 bc 00 00 00    	jns    802793 <_Z3dupii+0x113>
  8026d7:	e9 a8 00 00 00       	jmp    802784 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8026dc:	89 d8                	mov    %ebx,%eax
  8026de:	c1 e8 0c             	shr    $0xc,%eax
  8026e1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  8026e8:	f6 c2 01             	test   $0x1,%dl
  8026eb:	74 32                	je     80271f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8026ed:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8026f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8026f9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8026fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802701:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802708:	00 
  802709:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80270d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802714:	e8 76 eb ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  802719:	89 c3                	mov    %eax,%ebx
  80271b:	85 c0                	test   %eax,%eax
  80271d:	78 3e                	js     80275d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80271f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802722:	89 c2                	mov    %eax,%edx
  802724:	c1 ea 0c             	shr    $0xc,%edx
  802727:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80272e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802734:	89 54 24 10          	mov    %edx,0x10(%esp)
  802738:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80273b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80273f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802746:	00 
  802747:	89 44 24 04          	mov    %eax,0x4(%esp)
  80274b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802752:	e8 38 eb ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  802757:	89 c3                	mov    %eax,%ebx
  802759:	85 c0                	test   %eax,%eax
  80275b:	79 25                	jns    802782 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80275d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802760:	89 44 24 04          	mov    %eax,0x4(%esp)
  802764:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80276b:	e8 7d eb ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  802770:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802774:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80277b:	e8 6d eb ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
	return r;
  802780:	eb 02                	jmp    802784 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  802782:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802784:	89 d8                	mov    %ebx,%eax
  802786:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802789:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80278c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80278f:	89 ec                	mov    %ebp,%esp
  802791:	5d                   	pop    %ebp
  802792:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  802793:	89 34 24             	mov    %esi,(%esp)
  802796:	e8 8a fe ff ff       	call   802625 <_Z5closei>

	ova = fd2data(oldfd);
  80279b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279e:	89 04 24             	mov    %eax,(%esp)
  8027a1:	e8 16 fd ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  8027a6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8027a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ab:	89 04 24             	mov    %eax,(%esp)
  8027ae:	e8 09 fd ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  8027b3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8027b5:	89 d8                	mov    %ebx,%eax
  8027b7:	c1 e8 16             	shr    $0x16,%eax
  8027ba:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8027c1:	a8 01                	test   $0x1,%al
  8027c3:	0f 85 13 ff ff ff    	jne    8026dc <_Z3dupii+0x5c>
  8027c9:	e9 51 ff ff ff       	jmp    80271f <_Z3dupii+0x9f>

008027ce <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8027ce:	55                   	push   %ebp
  8027cf:	89 e5                	mov    %esp,%ebp
  8027d1:	53                   	push   %ebx
  8027d2:	83 ec 24             	sub    $0x24,%esp
  8027d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8027d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8027df:	00 
  8027e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8027e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e7:	89 1c 24             	mov    %ebx,(%esp)
  8027ea:	e8 32 fc ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	78 5f                	js     802852 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8027fd:	8b 00                	mov    (%eax),%eax
  8027ff:	89 04 24             	mov    %eax,(%esp)
  802802:	e8 2b fd ff ff       	call   802532 <_Z10dev_lookupiPP3Dev>
  802807:	85 c0                	test   %eax,%eax
  802809:	79 4d                	jns    802858 <_Z4readiPvj+0x8a>
  80280b:	eb 45                	jmp    802852 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80280d:	a1 00 70 80 00       	mov    0x807000,%eax
  802812:	8b 40 04             	mov    0x4(%eax),%eax
  802815:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802819:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281d:	c7 04 24 c7 55 80 00 	movl   $0x8055c7,(%esp)
  802824:	e8 05 df ff ff       	call   80072e <_Z7cprintfPKcz>
		return -E_INVAL;
  802829:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80282e:	eb 22                	jmp    802852 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  802836:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80283b:	85 d2                	test   %edx,%edx
  80283d:	74 13                	je     802852 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80283f:	8b 45 10             	mov    0x10(%ebp),%eax
  802842:	89 44 24 08          	mov    %eax,0x8(%esp)
  802846:	8b 45 0c             	mov    0xc(%ebp),%eax
  802849:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284d:	89 0c 24             	mov    %ecx,(%esp)
  802850:	ff d2                	call   *%edx
}
  802852:	83 c4 24             	add    $0x24,%esp
  802855:	5b                   	pop    %ebx
  802856:	5d                   	pop    %ebp
  802857:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802858:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80285b:	8b 41 08             	mov    0x8(%ecx),%eax
  80285e:	83 e0 03             	and    $0x3,%eax
  802861:	83 f8 01             	cmp    $0x1,%eax
  802864:	75 ca                	jne    802830 <_Z4readiPvj+0x62>
  802866:	eb a5                	jmp    80280d <_Z4readiPvj+0x3f>

00802868 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
  80286b:	57                   	push   %edi
  80286c:	56                   	push   %esi
  80286d:	53                   	push   %ebx
  80286e:	83 ec 1c             	sub    $0x1c,%esp
  802871:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802874:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  802877:	85 f6                	test   %esi,%esi
  802879:	74 2f                	je     8028aa <_Z5readniPvj+0x42>
  80287b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  802880:	89 f0                	mov    %esi,%eax
  802882:	29 d8                	sub    %ebx,%eax
  802884:	89 44 24 08          	mov    %eax,0x8(%esp)
  802888:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80288b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	89 04 24             	mov    %eax,(%esp)
  802895:	e8 34 ff ff ff       	call   8027ce <_Z4readiPvj>
		if (m < 0)
  80289a:	85 c0                	test   %eax,%eax
  80289c:	78 13                	js     8028b1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	74 0d                	je     8028af <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8028a2:	01 c3                	add    %eax,%ebx
  8028a4:	39 de                	cmp    %ebx,%esi
  8028a6:	77 d8                	ja     802880 <_Z5readniPvj+0x18>
  8028a8:	eb 05                	jmp    8028af <_Z5readniPvj+0x47>
  8028aa:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8028af:	89 d8                	mov    %ebx,%eax
}
  8028b1:	83 c4 1c             	add    $0x1c,%esp
  8028b4:	5b                   	pop    %ebx
  8028b5:	5e                   	pop    %esi
  8028b6:	5f                   	pop    %edi
  8028b7:	5d                   	pop    %ebp
  8028b8:	c3                   	ret    

008028b9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8028b9:	55                   	push   %ebp
  8028ba:	89 e5                	mov    %esp,%ebp
  8028bc:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8028bf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8028c6:	00 
  8028c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8028ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	89 04 24             	mov    %eax,(%esp)
  8028d4:	e8 48 fb ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	78 3c                	js     802919 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	89 04 24             	mov    %eax,(%esp)
  8028ec:	e8 41 fc ff ff       	call   802532 <_Z10dev_lookupiPP3Dev>
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	79 26                	jns    80291b <_Z5writeiPKvj+0x62>
  8028f5:	eb 22                	jmp    802919 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  8028fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  802902:	85 c9                	test   %ecx,%ecx
  802904:	74 13                	je     802919 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802906:	8b 45 10             	mov    0x10(%ebp),%eax
  802909:	89 44 24 08          	mov    %eax,0x8(%esp)
  80290d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802910:	89 44 24 04          	mov    %eax,0x4(%esp)
  802914:	89 14 24             	mov    %edx,(%esp)
  802917:	ff d1                	call   *%ecx
}
  802919:	c9                   	leave  
  80291a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80291b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80291e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  802923:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  802927:	74 f0                	je     802919 <_Z5writeiPKvj+0x60>
  802929:	eb cc                	jmp    8028f7 <_Z5writeiPKvj+0x3e>

0080292b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
  80292e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  802931:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802938:	00 
  802939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80293c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	89 04 24             	mov    %eax,(%esp)
  802946:	e8 d6 fa ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  80294b:	85 c0                	test   %eax,%eax
  80294d:	78 0e                	js     80295d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 55 0c             	mov    0xc(%ebp),%edx
  802955:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80295d:	c9                   	leave  
  80295e:	c3                   	ret    

0080295f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80295f:	55                   	push   %ebp
  802960:	89 e5                	mov    %esp,%ebp
  802962:	53                   	push   %ebx
  802963:	83 ec 24             	sub    $0x24,%esp
  802966:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802969:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802970:	00 
  802971:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802974:	89 44 24 04          	mov    %eax,0x4(%esp)
  802978:	89 1c 24             	mov    %ebx,(%esp)
  80297b:	e8 a1 fa ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  802980:	85 c0                	test   %eax,%eax
  802982:	78 58                	js     8029dc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802984:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	89 04 24             	mov    %eax,(%esp)
  802993:	e8 9a fb ff ff       	call   802532 <_Z10dev_lookupiPP3Dev>
  802998:	85 c0                	test   %eax,%eax
  80299a:	79 46                	jns    8029e2 <_Z9ftruncateii+0x83>
  80299c:	eb 3e                	jmp    8029dc <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  80299e:	a1 00 70 80 00       	mov    0x807000,%eax
  8029a3:	8b 40 04             	mov    0x4(%eax),%eax
  8029a6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ae:	c7 04 24 04 56 80 00 	movl   $0x805604,(%esp)
  8029b5:	e8 74 dd ff ff       	call   80072e <_Z7cprintfPKcz>
		return -E_INVAL;
  8029ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029bf:	eb 1b                	jmp    8029dc <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8029c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8029cc:	85 d2                	test   %edx,%edx
  8029ce:	74 0c                	je     8029dc <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8029d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d7:	89 0c 24             	mov    %ecx,(%esp)
  8029da:	ff d2                	call   *%edx
}
  8029dc:	83 c4 24             	add    $0x24,%esp
  8029df:	5b                   	pop    %ebx
  8029e0:	5d                   	pop    %ebp
  8029e1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029e2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8029e5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  8029e9:	75 d6                	jne    8029c1 <_Z9ftruncateii+0x62>
  8029eb:	eb b1                	jmp    80299e <_Z9ftruncateii+0x3f>

008029ed <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8029ed:	55                   	push   %ebp
  8029ee:	89 e5                	mov    %esp,%ebp
  8029f0:	53                   	push   %ebx
  8029f1:	83 ec 24             	sub    $0x24,%esp
  8029f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8029f7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8029fe:	00 
  8029ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802a02:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	89 04 24             	mov    %eax,(%esp)
  802a0c:	e8 10 fa ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  802a11:	85 c0                	test   %eax,%eax
  802a13:	78 3e                	js     802a53 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	89 04 24             	mov    %eax,(%esp)
  802a24:	e8 09 fb ff ff       	call   802532 <_Z10dev_lookupiPP3Dev>
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	79 2c                	jns    802a59 <_Z5fstatiP4Stat+0x6c>
  802a2d:	eb 24                	jmp    802a53 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802a2f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802a32:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  802a39:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  802a40:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802a46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4d:	89 04 24             	mov    %eax,(%esp)
  802a50:	ff 52 14             	call   *0x14(%edx)
}
  802a53:	83 c4 24             	add    $0x24,%esp
  802a56:	5b                   	pop    %ebx
  802a57:	5d                   	pop    %ebp
  802a58:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  802a5c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802a61:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  802a65:	75 c8                	jne    802a2f <_Z5fstatiP4Stat+0x42>
  802a67:	eb ea                	jmp    802a53 <_Z5fstatiP4Stat+0x66>

00802a69 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  802a69:	55                   	push   %ebp
  802a6a:	89 e5                	mov    %esp,%ebp
  802a6c:	83 ec 18             	sub    $0x18,%esp
  802a6f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802a72:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a75:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a7c:	00 
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	89 04 24             	mov    %eax,(%esp)
  802a83:	e8 d6 09 00 00       	call   80345e <_Z4openPKci>
  802a88:	89 c3                	mov    %eax,%ebx
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	78 1b                	js     802aa9 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  802a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a91:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a95:	89 1c 24             	mov    %ebx,(%esp)
  802a98:	e8 50 ff ff ff       	call   8029ed <_Z5fstatiP4Stat>
  802a9d:	89 c6                	mov    %eax,%esi
	close(fd);
  802a9f:	89 1c 24             	mov    %ebx,(%esp)
  802aa2:	e8 7e fb ff ff       	call   802625 <_Z5closei>
	return r;
  802aa7:	89 f3                	mov    %esi,%ebx
}
  802aa9:	89 d8                	mov    %ebx,%eax
  802aab:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802aae:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802ab1:	89 ec                	mov    %ebp,%esp
  802ab3:	5d                   	pop    %ebp
  802ab4:	c3                   	ret    
	...

00802ac0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  802ac3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  802ac8:	85 d2                	test   %edx,%edx
  802aca:	78 33                	js     802aff <_ZL10inode_dataP5Inodei+0x3f>
  802acc:	3b 50 08             	cmp    0x8(%eax),%edx
  802acf:	7d 2e                	jge    802aff <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  802ad1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802ad7:	85 d2                	test   %edx,%edx
  802ad9:	0f 49 ca             	cmovns %edx,%ecx
  802adc:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  802adf:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  802ae3:	c1 e1 0c             	shl    $0xc,%ecx
  802ae6:	89 d0                	mov    %edx,%eax
  802ae8:	c1 f8 1f             	sar    $0x1f,%eax
  802aeb:	c1 e8 14             	shr    $0x14,%eax
  802aee:	01 c2                	add    %eax,%edx
  802af0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802af6:	29 c2                	sub    %eax,%edx
  802af8:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  802aff:	89 c8                	mov    %ecx,%eax
  802b01:	5d                   	pop    %ebp
  802b02:	c3                   	ret    

00802b03 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  802b03:	55                   	push   %ebp
  802b04:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  802b06:	8b 48 08             	mov    0x8(%eax),%ecx
  802b09:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  802b11:	c7 82 80 00 00 00 20 	movl   $0x806020,0x80(%edx)
  802b18:	60 80 00 
}
  802b1b:	5d                   	pop    %ebp
  802b1c:	c3                   	ret    

00802b1d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  802b1d:	55                   	push   %ebp
  802b1e:	89 e5                	mov    %esp,%ebp
  802b20:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802b23:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	74 08                	je     802b35 <_ZL9get_inodei+0x18>
  802b2d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802b33:	7e 20                	jle    802b55 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  802b35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b39:	c7 44 24 08 3c 56 80 	movl   $0x80563c,0x8(%esp)
  802b40:	00 
  802b41:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  802b48:	00 
  802b49:	c7 04 24 52 56 80 00 	movl   $0x805652,(%esp)
  802b50:	e8 bb da ff ff       	call   800610 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802b55:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  802b5b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802b61:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802b67:	85 d2                	test   %edx,%edx
  802b69:	0f 48 d1             	cmovs  %ecx,%edx
  802b6c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  802b6f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  802b76:	c1 e0 0c             	shl    $0xc,%eax
}
  802b79:	c9                   	leave  
  802b7a:	c3                   	ret    

00802b7b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  802b7b:	55                   	push   %ebp
  802b7c:	89 e5                	mov    %esp,%ebp
  802b7e:	56                   	push   %esi
  802b7f:	53                   	push   %ebx
  802b80:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  802b83:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  802b89:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  802b8c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  802b92:	76 20                	jbe    802bb4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  802b94:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b98:	c7 44 24 08 78 56 80 	movl   $0x805678,0x8(%esp)
  802b9f:	00 
  802ba0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  802ba7:	00 
  802ba8:	c7 04 24 52 56 80 00 	movl   $0x805652,(%esp)
  802baf:	e8 5c da ff ff       	call   800610 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  802bb4:	83 fe 01             	cmp    $0x1,%esi
  802bb7:	7e 08                	jle    802bc1 <_ZL10bcache_ipcPvi+0x46>
  802bb9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  802bbf:	7d 12                	jge    802bd3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802bc1:	89 f3                	mov    %esi,%ebx
  802bc3:	c1 e3 04             	shl    $0x4,%ebx
  802bc6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802bc8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  802bce:	c1 e6 0c             	shl    $0xc,%esi
  802bd1:	eb 20                	jmp    802bf3 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  802bd3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802bd7:	c7 44 24 08 a8 56 80 	movl   $0x8056a8,0x8(%esp)
  802bde:	00 
  802bdf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802be6:	00 
  802be7:	c7 04 24 52 56 80 00 	movl   $0x805652,(%esp)
  802bee:	e8 1d da ff ff       	call   800610 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802bf3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802bfa:	00 
  802bfb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802c02:	00 
  802c03:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c07:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  802c0e:	e8 8c 20 00 00       	call   804c9f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802c13:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802c1a:	00 
  802c1b:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c26:	e8 e5 1f 00 00       	call   804c10 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  802c2b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  802c2e:	74 c3                	je     802bf3 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  802c30:	83 c4 10             	add    $0x10,%esp
  802c33:	5b                   	pop    %ebx
  802c34:	5e                   	pop    %esi
  802c35:	5d                   	pop    %ebp
  802c36:	c3                   	ret    

00802c37 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  802c37:	55                   	push   %ebp
  802c38:	89 e5                	mov    %esp,%ebp
  802c3a:	83 ec 28             	sub    $0x28,%esp
  802c3d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802c40:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802c43:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802c46:	89 c7                	mov    %eax,%edi
  802c48:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  802c4a:	c7 04 24 dd 2e 80 00 	movl   $0x802edd,(%esp)
  802c51:	e8 c5 1e 00 00       	call   804b1b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  802c56:	89 f8                	mov    %edi,%eax
  802c58:	e8 c0 fe ff ff       	call   802b1d <_ZL9get_inodei>
  802c5d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  802c5f:	ba 02 00 00 00       	mov    $0x2,%edx
  802c64:	e8 12 ff ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	79 08                	jns    802c75 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  802c6d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  802c73:	eb 2e                	jmp    802ca3 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  802c75:	85 c0                	test   %eax,%eax
  802c77:	75 1c                	jne    802c95 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  802c79:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  802c7f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  802c86:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  802c89:	ba 06 00 00 00       	mov    $0x6,%edx
  802c8e:	89 d8                	mov    %ebx,%eax
  802c90:	e8 e6 fe ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  802c95:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  802c9c:	89 1e                	mov    %ebx,(%esi)
	return 0;
  802c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ca6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802ca9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802cac:	89 ec                	mov    %ebp,%esp
  802cae:	5d                   	pop    %ebp
  802caf:	c3                   	ret    

00802cb0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  802cb0:	55                   	push   %ebp
  802cb1:	89 e5                	mov    %esp,%ebp
  802cb3:	57                   	push   %edi
  802cb4:	56                   	push   %esi
  802cb5:	53                   	push   %ebx
  802cb6:	83 ec 2c             	sub    $0x2c,%esp
  802cb9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802cbc:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  802cbf:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  802cc4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  802cca:	0f 87 3d 01 00 00    	ja     802e0d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  802cd0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802cd3:	8b 42 08             	mov    0x8(%edx),%eax
  802cd6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	0f 49 f0             	cmovns %eax,%esi
  802ce1:	c1 fe 0c             	sar    $0xc,%esi
  802ce4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  802ce6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  802ce9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  802cef:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  802cf2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802cf5:	0f 82 a6 00 00 00    	jb     802da1 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  802cfb:	39 fe                	cmp    %edi,%esi
  802cfd:	0f 8d f2 00 00 00    	jge    802df5 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802d03:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  802d07:	89 7d dc             	mov    %edi,-0x24(%ebp)
  802d0a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  802d0d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  802d10:	83 3e 00             	cmpl   $0x0,(%esi)
  802d13:	75 77                	jne    802d8c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802d15:	ba 02 00 00 00       	mov    $0x2,%edx
  802d1a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802d1f:	e8 57 fe ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802d24:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  802d2a:	83 f9 02             	cmp    $0x2,%ecx
  802d2d:	7e 43                	jle    802d72 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  802d2f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802d34:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  802d39:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802d40:	74 29                	je     802d6b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802d42:	e9 ce 00 00 00       	jmp    802e15 <_ZL14inode_set_sizeP5Inodej+0x165>
  802d47:	89 c7                	mov    %eax,%edi
  802d49:	0f b6 10             	movzbl (%eax),%edx
  802d4c:	83 c0 01             	add    $0x1,%eax
  802d4f:	84 d2                	test   %dl,%dl
  802d51:	74 18                	je     802d6b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802d53:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802d56:	ba 05 00 00 00       	mov    $0x5,%edx
  802d5b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802d60:	e8 16 fe ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802d65:	85 db                	test   %ebx,%ebx
  802d67:	79 1e                	jns    802d87 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802d69:	eb 07                	jmp    802d72 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802d6b:	83 c3 01             	add    $0x1,%ebx
  802d6e:	39 d9                	cmp    %ebx,%ecx
  802d70:	7f d5                	jg     802d47 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  802d72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d75:	8b 50 08             	mov    0x8(%eax),%edx
  802d78:	e8 33 ff ff ff       	call   802cb0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  802d7d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802d82:	e9 86 00 00 00       	jmp    802e0d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  802d87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d8a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  802d8c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  802d90:	83 c6 04             	add    $0x4,%esi
  802d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d96:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  802d99:	0f 8f 6e ff ff ff    	jg     802d0d <_ZL14inode_set_sizeP5Inodej+0x5d>
  802d9f:	eb 54                	jmp    802df5 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  802da1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802da4:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  802da9:	83 f8 01             	cmp    $0x1,%eax
  802dac:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802daf:	ba 02 00 00 00       	mov    $0x2,%edx
  802db4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802db9:	e8 bd fd ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  802dbe:	39 f7                	cmp    %esi,%edi
  802dc0:	7d 24                	jge    802de6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802dc2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802dc5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  802dc9:	8b 10                	mov    (%eax),%edx
  802dcb:	85 d2                	test   %edx,%edx
  802dcd:	74 0d                	je     802ddc <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  802dcf:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  802dd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  802ddc:	83 eb 01             	sub    $0x1,%ebx
  802ddf:	83 e8 04             	sub    $0x4,%eax
  802de2:	39 fb                	cmp    %edi,%ebx
  802de4:	75 e3                	jne    802dc9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802de6:	ba 05 00 00 00       	mov    $0x5,%edx
  802deb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802df0:	e8 86 fd ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  802df5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802df8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dfb:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  802dfe:	ba 04 00 00 00       	mov    $0x4,%edx
  802e03:	e8 73 fd ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
	return 0;
  802e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0d:	83 c4 2c             	add    $0x2c,%esp
  802e10:	5b                   	pop    %ebx
  802e11:	5e                   	pop    %esi
  802e12:	5f                   	pop    %edi
  802e13:	5d                   	pop    %ebp
  802e14:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802e15:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802e1c:	ba 05 00 00 00       	mov    $0x5,%edx
  802e21:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802e26:	e8 50 fd ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802e2b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802e30:	e9 52 ff ff ff       	jmp    802d87 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802e35 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802e35:	55                   	push   %ebp
  802e36:	89 e5                	mov    %esp,%ebp
  802e38:	53                   	push   %ebx
  802e39:	83 ec 04             	sub    $0x4,%esp
  802e3c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  802e3e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802e44:	83 e8 01             	sub    $0x1,%eax
  802e47:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  802e4d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802e51:	75 40                	jne    802e93 <_ZL11inode_closeP5Inode+0x5e>
  802e53:	85 c0                	test   %eax,%eax
  802e55:	75 3c                	jne    802e93 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802e57:	ba 02 00 00 00       	mov    $0x2,%edx
  802e5c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802e61:	e8 15 fd ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802e66:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  802e6b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  802e6f:	85 d2                	test   %edx,%edx
  802e71:	74 07                	je     802e7a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  802e73:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  802e7a:	83 c0 01             	add    $0x1,%eax
  802e7d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  802e82:	75 e7                	jne    802e6b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802e84:	ba 05 00 00 00       	mov    $0x5,%edx
  802e89:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802e8e:	e8 e8 fc ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  802e93:	ba 03 00 00 00       	mov    $0x3,%edx
  802e98:	89 d8                	mov    %ebx,%eax
  802e9a:	e8 dc fc ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
}
  802e9f:	83 c4 04             	add    $0x4,%esp
  802ea2:	5b                   	pop    %ebx
  802ea3:	5d                   	pop    %ebp
  802ea4:	c3                   	ret    

00802ea5 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ea5:	55                   	push   %ebp
  802ea6:	89 e5                	mov    %esp,%ebp
  802ea8:	53                   	push   %ebx
  802ea9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802eb5:	e8 7d fd ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  802eba:	89 c3                	mov    %eax,%ebx
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	78 15                	js     802ed5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  802ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	e8 e5 fd ff ff       	call   802cb0 <_ZL14inode_set_sizeP5Inodej>
  802ecb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	e8 60 ff ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
	return r;
}
  802ed5:	89 d8                	mov    %ebx,%eax
  802ed7:	83 c4 14             	add    $0x14,%esp
  802eda:	5b                   	pop    %ebx
  802edb:	5d                   	pop    %ebp
  802edc:	c3                   	ret    

00802edd <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  802edd:	55                   	push   %ebp
  802ede:	89 e5                	mov    %esp,%ebp
  802ee0:	53                   	push   %ebx
  802ee1:	83 ec 14             	sub    $0x14,%esp
  802ee4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  802ee7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  802ee9:	89 c2                	mov    %eax,%edx
  802eeb:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  802ef1:	78 32                	js     802f25 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  802ef3:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef8:	e8 7e fc ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
  802efd:	85 c0                	test   %eax,%eax
  802eff:	74 1c                	je     802f1d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  802f01:	c7 44 24 08 5d 56 80 	movl   $0x80565d,0x8(%esp)
  802f08:	00 
  802f09:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802f10:	00 
  802f11:	c7 04 24 52 56 80 00 	movl   $0x805652,(%esp)
  802f18:	e8 f3 d6 ff ff       	call   800610 <_Z6_panicPKciS0_z>
    resume(utf);
  802f1d:	89 1c 24             	mov    %ebx,(%esp)
  802f20:	e8 cb 1c 00 00       	call   804bf0 <resume>
}
  802f25:	83 c4 14             	add    $0x14,%esp
  802f28:	5b                   	pop    %ebx
  802f29:	5d                   	pop    %ebp
  802f2a:	c3                   	ret    

00802f2b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  802f2b:	55                   	push   %ebp
  802f2c:	89 e5                	mov    %esp,%ebp
  802f2e:	83 ec 28             	sub    $0x28,%esp
  802f31:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802f34:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802f3a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802f3d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802f40:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802f43:	e8 ef fc ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	78 26                	js     802f72 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  802f4c:	83 c3 10             	add    $0x10,%ebx
  802f4f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f53:	89 34 24             	mov    %esi,(%esp)
  802f56:	e8 ef dd ff ff       	call   800d4a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802f5b:	89 f2                	mov    %esi,%edx
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	e8 9e fb ff ff       	call   802b03 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	e8 c8 fe ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
	return 0;
  802f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f72:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802f75:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802f78:	89 ec                	mov    %ebp,%esp
  802f7a:	5d                   	pop    %ebp
  802f7b:	c3                   	ret    

00802f7c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  802f7c:	55                   	push   %ebp
  802f7d:	89 e5                	mov    %esp,%ebp
  802f7f:	53                   	push   %ebx
  802f80:	83 ec 24             	sub    $0x24,%esp
  802f83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802f86:	89 1c 24             	mov    %ebx,(%esp)
  802f89:	e8 9e 15 00 00       	call   80452c <_Z7pagerefPv>
  802f8e:	89 c2                	mov    %eax,%edx
        return 0;
  802f90:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802f95:	83 fa 01             	cmp    $0x1,%edx
  802f98:	7f 1e                	jg     802fb8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802f9a:	8b 43 0c             	mov    0xc(%ebx),%eax
  802f9d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802fa0:	e8 92 fc ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	78 0f                	js     802fb8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  802fb3:	e8 7d fe ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
}
  802fb8:	83 c4 24             	add    $0x24,%esp
  802fbb:	5b                   	pop    %ebx
  802fbc:	5d                   	pop    %ebp
  802fbd:	c3                   	ret    

00802fbe <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802fbe:	55                   	push   %ebp
  802fbf:	89 e5                	mov    %esp,%ebp
  802fc1:	57                   	push   %edi
  802fc2:	56                   	push   %esi
  802fc3:	53                   	push   %ebx
  802fc4:	83 ec 3c             	sub    $0x3c,%esp
  802fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802fca:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  802fcd:	8b 43 04             	mov    0x4(%ebx),%eax
  802fd0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802fd3:	8b 43 0c             	mov    0xc(%ebx),%eax
  802fd6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802fd9:	e8 59 fc ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  802fde:	85 c0                	test   %eax,%eax
  802fe0:	0f 88 8c 00 00 00    	js     803072 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802fe6:	8b 53 04             	mov    0x4(%ebx),%edx
  802fe9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  802fef:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802ff5:	29 d7                	sub    %edx,%edi
  802ff7:	39 f7                	cmp    %esi,%edi
  802ff9:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  802ffc:	85 ff                	test   %edi,%edi
  802ffe:	74 16                	je     803016 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  803000:	8d 14 17             	lea    (%edi,%edx,1),%edx
  803003:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803006:	3b 50 08             	cmp    0x8(%eax),%edx
  803009:	76 6f                	jbe    80307a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80300b:	e8 a0 fc ff ff       	call   802cb0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  803010:	85 c0                	test   %eax,%eax
  803012:	79 66                	jns    80307a <_ZL13devfile_writeP2FdPKvj+0xbc>
  803014:	eb 4e                	jmp    803064 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  803016:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80301c:	76 24                	jbe    803042 <_ZL13devfile_writeP2FdPKvj+0x84>
  80301e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  803020:	8b 53 04             	mov    0x4(%ebx),%edx
  803023:	81 c2 00 10 00 00    	add    $0x1000,%edx
  803029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302c:	3b 50 08             	cmp    0x8(%eax),%edx
  80302f:	0f 86 83 00 00 00    	jbe    8030b8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  803035:	e8 76 fc ff ff       	call   802cb0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80303a:	85 c0                	test   %eax,%eax
  80303c:	79 7a                	jns    8030b8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80303e:	66 90                	xchg   %ax,%ax
  803040:	eb 22                	jmp    803064 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  803042:	85 f6                	test   %esi,%esi
  803044:	74 1e                	je     803064 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  803046:	89 f2                	mov    %esi,%edx
  803048:	03 53 04             	add    0x4(%ebx),%edx
  80304b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304e:	3b 50 08             	cmp    0x8(%eax),%edx
  803051:	0f 86 b8 00 00 00    	jbe    80310f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  803057:	e8 54 fc ff ff       	call   802cb0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80305c:	85 c0                	test   %eax,%eax
  80305e:	0f 89 ab 00 00 00    	jns    80310f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  803064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803067:	e8 c9 fd ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80306c:	8b 43 04             	mov    0x4(%ebx),%eax
  80306f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  803072:	83 c4 3c             	add    $0x3c,%esp
  803075:	5b                   	pop    %ebx
  803076:	5e                   	pop    %esi
  803077:	5f                   	pop    %edi
  803078:	5d                   	pop    %ebp
  803079:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80307a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80307c:	8b 53 04             	mov    0x4(%ebx),%edx
  80307f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803082:	e8 39 fa ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
  803087:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80308a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80308e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803091:	89 44 24 04          	mov    %eax,0x4(%esp)
  803095:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803098:	89 04 24             	mov    %eax,(%esp)
  80309b:	e8 c7 de ff ff       	call   800f67 <memcpy>
        fd->fd_offset += n2;
  8030a0:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  8030a3:	ba 04 00 00 00       	mov    $0x4,%edx
  8030a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030ab:	e8 cb fa ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  8030b0:	01 7d 0c             	add    %edi,0xc(%ebp)
  8030b3:	e9 5e ff ff ff       	jmp    803016 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8030b8:	8b 53 04             	mov    0x4(%ebx),%edx
  8030bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030be:	e8 fd f9 ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
  8030c3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  8030c5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8030cc:	00 
  8030cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030d4:	89 34 24             	mov    %esi,(%esp)
  8030d7:	e8 8b de ff ff       	call   800f67 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8030dc:	ba 04 00 00 00       	mov    $0x4,%edx
  8030e1:	89 f0                	mov    %esi,%eax
  8030e3:	e8 93 fa ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  8030e8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  8030ee:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  8030f5:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  8030fc:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  803102:	0f 87 18 ff ff ff    	ja     803020 <_ZL13devfile_writeP2FdPKvj+0x62>
  803108:	89 fe                	mov    %edi,%esi
  80310a:	e9 33 ff ff ff       	jmp    803042 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80310f:	8b 53 04             	mov    0x4(%ebx),%edx
  803112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803115:	e8 a6 f9 ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
  80311a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80311c:	89 74 24 08          	mov    %esi,0x8(%esp)
  803120:	8b 45 0c             	mov    0xc(%ebp),%eax
  803123:	89 44 24 04          	mov    %eax,0x4(%esp)
  803127:	89 3c 24             	mov    %edi,(%esp)
  80312a:	e8 38 de ff ff       	call   800f67 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80312f:	ba 04 00 00 00       	mov    $0x4,%edx
  803134:	89 f8                	mov    %edi,%eax
  803136:	e8 40 fa ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80313b:	01 73 04             	add    %esi,0x4(%ebx)
  80313e:	e9 21 ff ff ff       	jmp    803064 <_ZL13devfile_writeP2FdPKvj+0xa6>

00803143 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803143:	55                   	push   %ebp
  803144:	89 e5                	mov    %esp,%ebp
  803146:	57                   	push   %edi
  803147:	56                   	push   %esi
  803148:	53                   	push   %ebx
  803149:	83 ec 3c             	sub    $0x3c,%esp
  80314c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80314f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  803152:	8b 43 04             	mov    0x4(%ebx),%eax
  803155:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  803158:	8b 43 0c             	mov    0xc(%ebx),%eax
  80315b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80315e:	e8 d4 fa ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  803163:	85 c0                	test   %eax,%eax
  803165:	0f 88 d3 00 00 00    	js     80323e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80316b:	8b 73 04             	mov    0x4(%ebx),%esi
  80316e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803171:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  803174:	8b 50 08             	mov    0x8(%eax),%edx
  803177:	29 f2                	sub    %esi,%edx
  803179:	3b 48 08             	cmp    0x8(%eax),%ecx
  80317c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80317f:	89 f2                	mov    %esi,%edx
  803181:	e8 3a f9 ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
  803186:	85 c0                	test   %eax,%eax
  803188:	0f 84 a2 00 00 00    	je     803230 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80318e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  803194:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80319a:	29 f2                	sub    %esi,%edx
  80319c:	39 d7                	cmp    %edx,%edi
  80319e:	0f 46 d7             	cmovbe %edi,%edx
  8031a1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  8031a4:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  8031a6:	01 d6                	add    %edx,%esi
  8031a8:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  8031ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8031af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b6:	89 04 24             	mov    %eax,(%esp)
  8031b9:	e8 a9 dd ff ff       	call   800f67 <memcpy>
    buf = (void *)((char *)buf + n2);
  8031be:	8b 75 0c             	mov    0xc(%ebp),%esi
  8031c1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8031c4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8031ca:	76 3e                	jbe    80320a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8031cc:	8b 53 04             	mov    0x4(%ebx),%edx
  8031cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d2:	e8 e9 f8 ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	74 55                	je     803230 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  8031db:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8031e2:	00 
  8031e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031e7:	89 34 24             	mov    %esi,(%esp)
  8031ea:	e8 78 dd ff ff       	call   800f67 <memcpy>
        n -= PGSIZE;
  8031ef:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  8031f5:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  8031fb:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  803202:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  803208:	77 c2                	ja     8031cc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80320a:	85 ff                	test   %edi,%edi
  80320c:	74 22                	je     803230 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80320e:	8b 53 04             	mov    0x4(%ebx),%edx
  803211:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803214:	e8 a7 f8 ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
  803219:	85 c0                	test   %eax,%eax
  80321b:	74 13                	je     803230 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80321d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803221:	89 44 24 04          	mov    %eax,0x4(%esp)
  803225:	89 34 24             	mov    %esi,(%esp)
  803228:	e8 3a dd ff ff       	call   800f67 <memcpy>
        fd->fd_offset += n;
  80322d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  803230:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803233:	e8 fd fb ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  803238:	8b 43 04             	mov    0x4(%ebx),%eax
  80323b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80323e:	83 c4 3c             	add    $0x3c,%esp
  803241:	5b                   	pop    %ebx
  803242:	5e                   	pop    %esi
  803243:	5f                   	pop    %edi
  803244:	5d                   	pop    %ebp
  803245:	c3                   	ret    

00803246 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  803246:	55                   	push   %ebp
  803247:	89 e5                	mov    %esp,%ebp
  803249:	57                   	push   %edi
  80324a:	56                   	push   %esi
  80324b:	53                   	push   %ebx
  80324c:	83 ec 4c             	sub    $0x4c,%esp
  80324f:	89 c6                	mov    %eax,%esi
  803251:	89 55 bc             	mov    %edx,-0x44(%ebp)
  803254:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  803257:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80325d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  803266:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  803269:	b8 01 00 00 00       	mov    $0x1,%eax
  80326e:	e8 c4 f9 ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  803273:	89 c7                	mov    %eax,%edi
  803275:	85 c0                	test   %eax,%eax
  803277:	0f 88 cd 01 00 00    	js     80344a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80327d:	89 f3                	mov    %esi,%ebx
  80327f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  803282:	75 08                	jne    80328c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  803284:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  803287:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80328a:	74 f8                	je     803284 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80328c:	0f b6 03             	movzbl (%ebx),%eax
  80328f:	3c 2f                	cmp    $0x2f,%al
  803291:	74 16                	je     8032a9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  803293:	84 c0                	test   %al,%al
  803295:	74 12                	je     8032a9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  803297:	89 da                	mov    %ebx,%edx
		++path;
  803299:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80329c:	0f b6 02             	movzbl (%edx),%eax
  80329f:	3c 2f                	cmp    $0x2f,%al
  8032a1:	74 08                	je     8032ab <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8032a3:	84 c0                	test   %al,%al
  8032a5:	75 f2                	jne    803299 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  8032a7:	eb 02                	jmp    8032ab <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8032a9:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  8032ab:	89 d0                	mov    %edx,%eax
  8032ad:	29 d8                	sub    %ebx,%eax
  8032af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  8032b2:	0f b6 02             	movzbl (%edx),%eax
  8032b5:	89 d6                	mov    %edx,%esi
  8032b7:	3c 2f                	cmp    $0x2f,%al
  8032b9:	75 0a                	jne    8032c5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  8032bb:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  8032be:	0f b6 06             	movzbl (%esi),%eax
  8032c1:	3c 2f                	cmp    $0x2f,%al
  8032c3:	74 f6                	je     8032bb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8032c5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032c9:	75 1b                	jne    8032e6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8032cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ce:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8032d1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8032d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8032d6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8032dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8032e1:	e9 64 01 00 00       	jmp    80344a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8032e6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8032ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ee:	74 06                	je     8032f6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  8032f0:	84 c0                	test   %al,%al
  8032f2:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8032f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032f9:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  8032fc:	83 3a 02             	cmpl   $0x2,(%edx)
  8032ff:	0f 85 f4 00 00 00    	jne    8033f9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  803305:	89 d0                	mov    %edx,%eax
  803307:	8b 52 08             	mov    0x8(%edx),%edx
  80330a:	85 d2                	test   %edx,%edx
  80330c:	7e 78                	jle    803386 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  80330e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  803315:	bf 00 00 00 00       	mov    $0x0,%edi
  80331a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  80331d:	89 fb                	mov    %edi,%ebx
  80331f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  803322:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  803324:	89 da                	mov    %ebx,%edx
  803326:	89 f0                	mov    %esi,%eax
  803328:	e8 93 f7 ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
  80332d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  80332f:	83 38 00             	cmpl   $0x0,(%eax)
  803332:	74 26                	je     80335a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  803334:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803337:	3b 50 04             	cmp    0x4(%eax),%edx
  80333a:	75 33                	jne    80336f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  80333c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803340:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803343:	89 44 24 04          	mov    %eax,0x4(%esp)
  803347:	8d 47 08             	lea    0x8(%edi),%eax
  80334a:	89 04 24             	mov    %eax,(%esp)
  80334d:	e8 56 dc ff ff       	call   800fa8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  803352:	85 c0                	test   %eax,%eax
  803354:	0f 84 fa 00 00 00    	je     803454 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  80335a:	83 3f 00             	cmpl   $0x0,(%edi)
  80335d:	75 10                	jne    80336f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  80335f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803363:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  803366:	84 c0                	test   %al,%al
  803368:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  80336c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  80336f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  803375:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  803377:	8b 56 08             	mov    0x8(%esi),%edx
  80337a:	39 d0                	cmp    %edx,%eax
  80337c:	7c a6                	jl     803324 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  80337e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  803381:	8b 75 c0             	mov    -0x40(%ebp),%esi
  803384:	eb 07                	jmp    80338d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  803386:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  80338d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  803391:	74 6d                	je     803400 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  803393:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803397:	75 24                	jne    8033bd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  803399:	83 ea 80             	sub    $0xffffff80,%edx
  80339c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80339f:	e8 0c f9 ff ff       	call   802cb0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	0f 88 90 00 00 00    	js     80343c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  8033ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033af:	8b 50 08             	mov    0x8(%eax),%edx
  8033b2:	83 c2 80             	add    $0xffffff80,%edx
  8033b5:	e8 06 f7 ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
  8033ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  8033bd:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  8033c4:	00 
  8033c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8033cc:	00 
  8033cd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8033d0:	89 14 24             	mov    %edx,(%esp)
  8033d3:	e8 b9 da ff ff       	call   800e91 <memset>
	empty->de_namelen = namelen;
  8033d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8033de:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  8033e1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8033e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8033e9:	83 c0 08             	add    $0x8,%eax
  8033ec:	89 04 24             	mov    %eax,(%esp)
  8033ef:	e8 73 db ff ff       	call   800f67 <memcpy>
	*de_store = empty;
  8033f4:	8b 7d cc             	mov    -0x34(%ebp),%edi
  8033f7:	eb 5e                	jmp    803457 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  8033f9:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  8033fe:	eb 42                	jmp    803442 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  803400:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  803405:	eb 3b                	jmp    803442 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  803407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80340d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  80340f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803412:	89 38                	mov    %edi,(%eax)
			return 0;
  803414:	bf 00 00 00 00       	mov    $0x0,%edi
  803419:	eb 2f                	jmp    80344a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  80341b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  80341e:	8b 07                	mov    (%edi),%eax
  803420:	e8 12 f8 ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  803425:	85 c0                	test   %eax,%eax
  803427:	78 17                	js     803440 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  803429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342c:	e8 04 fa ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  803431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  803437:	e9 41 fe ff ff       	jmp    80327d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  80343c:	89 c7                	mov    %eax,%edi
  80343e:	eb 02                	jmp    803442 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  803440:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  803442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803445:	e8 eb f9 ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
	return r;
}
  80344a:	89 f8                	mov    %edi,%eax
  80344c:	83 c4 4c             	add    $0x4c,%esp
  80344f:	5b                   	pop    %ebx
  803450:	5e                   	pop    %esi
  803451:	5f                   	pop    %edi
  803452:	5d                   	pop    %ebp
  803453:	c3                   	ret    
  803454:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  803457:	80 3e 00             	cmpb   $0x0,(%esi)
  80345a:	75 bf                	jne    80341b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  80345c:	eb a9                	jmp    803407 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

0080345e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  80345e:	55                   	push   %ebp
  80345f:	89 e5                	mov    %esp,%ebp
  803461:	57                   	push   %edi
  803462:	56                   	push   %esi
  803463:	53                   	push   %ebx
  803464:	83 ec 3c             	sub    $0x3c,%esp
  803467:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  80346a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80346d:	89 04 24             	mov    %eax,(%esp)
  803470:	e8 62 f0 ff ff       	call   8024d7 <_Z14fd_find_unusedPP2Fd>
  803475:	89 c3                	mov    %eax,%ebx
  803477:	85 c0                	test   %eax,%eax
  803479:	0f 88 16 02 00 00    	js     803695 <_Z4openPKci+0x237>
  80347f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803486:	00 
  803487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80348e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803495:	e8 96 dd ff ff       	call   801230 <_Z14sys_page_allociPvi>
  80349a:	89 c3                	mov    %eax,%ebx
  80349c:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a1:	85 db                	test   %ebx,%ebx
  8034a3:	0f 88 ec 01 00 00    	js     803695 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  8034a9:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  8034ad:	0f 84 ec 01 00 00    	je     80369f <_Z4openPKci+0x241>
  8034b3:	83 c0 01             	add    $0x1,%eax
  8034b6:	83 f8 78             	cmp    $0x78,%eax
  8034b9:	75 ee                	jne    8034a9 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  8034bb:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  8034c0:	e9 b9 01 00 00       	jmp    80367e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  8034c5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8034c8:	81 e7 00 01 00 00    	and    $0x100,%edi
  8034ce:	89 3c 24             	mov    %edi,(%esp)
  8034d1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  8034d4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  8034d7:	89 f0                	mov    %esi,%eax
  8034d9:	e8 68 fd ff ff       	call   803246 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  8034de:	89 c3                	mov    %eax,%ebx
  8034e0:	85 c0                	test   %eax,%eax
  8034e2:	0f 85 96 01 00 00    	jne    80367e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  8034e8:	85 ff                	test   %edi,%edi
  8034ea:	75 41                	jne    80352d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  8034ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ef:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  8034f4:	75 08                	jne    8034fe <_Z4openPKci+0xa0>
            fileino = dirino;
  8034f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8034fc:	eb 14                	jmp    803512 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  8034fe:	8d 55 d8             	lea    -0x28(%ebp),%edx
  803501:	8b 00                	mov    (%eax),%eax
  803503:	e8 2f f7 ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  803508:	89 c3                	mov    %eax,%ebx
  80350a:	85 c0                	test   %eax,%eax
  80350c:	0f 88 5d 01 00 00    	js     80366f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  803512:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803515:	83 38 02             	cmpl   $0x2,(%eax)
  803518:	0f 85 d2 00 00 00    	jne    8035f0 <_Z4openPKci+0x192>
  80351e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  803522:	0f 84 c8 00 00 00    	je     8035f0 <_Z4openPKci+0x192>
  803528:	e9 38 01 00 00       	jmp    803665 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  80352d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  803534:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  80353b:	0f 8e a8 00 00 00    	jle    8035e9 <_Z4openPKci+0x18b>
  803541:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  803546:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  803549:	89 f8                	mov    %edi,%eax
  80354b:	e8 e7 f6 ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  803550:	89 c3                	mov    %eax,%ebx
  803552:	85 c0                	test   %eax,%eax
  803554:	0f 88 15 01 00 00    	js     80366f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  80355a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803561:	75 68                	jne    8035cb <_Z4openPKci+0x16d>
  803563:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  80356a:	75 5f                	jne    8035cb <_Z4openPKci+0x16d>
			*ino_store = ino;
  80356c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  80356f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  803575:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803578:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  80357f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  803586:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  80358d:	00 
  80358e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803595:	00 
  803596:	83 c0 0c             	add    $0xc,%eax
  803599:	89 04 24             	mov    %eax,(%esp)
  80359c:	e8 f0 d8 ff ff       	call   800e91 <memset>
        de->de_inum = fileino->i_inum;
  8035a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035a4:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  8035aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ad:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  8035af:	ba 04 00 00 00       	mov    $0x4,%edx
  8035b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035b7:	e8 bf f5 ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  8035bc:	ba 04 00 00 00       	mov    $0x4,%edx
  8035c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035c4:	e8 b2 f5 ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
  8035c9:	eb 25                	jmp    8035f0 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  8035cb:	e8 65 f8 ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  8035d0:	83 c7 01             	add    $0x1,%edi
  8035d3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  8035d9:	0f 8c 67 ff ff ff    	jl     803546 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  8035df:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8035e4:	e9 86 00 00 00       	jmp    80366f <_Z4openPKci+0x211>
  8035e9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  8035ee:	eb 7f                	jmp    80366f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  8035f0:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  8035f7:	74 0d                	je     803606 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  8035f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8035fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803601:	e8 aa f6 ff ff       	call   802cb0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  803606:	8b 15 20 60 80 00    	mov    0x806020,%edx
  80360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  803611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803614:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  80361b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80361e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  803621:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803624:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  80362a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  80362d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803631:	83 c0 10             	add    $0x10,%eax
  803634:	89 04 24             	mov    %eax,(%esp)
  803637:	e8 0e d7 ff ff       	call   800d4a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  80363c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80363f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  803646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803649:	e8 e7 f7 ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  80364e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803651:	e8 df f7 ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  803656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803659:	89 04 24             	mov    %eax,(%esp)
  80365c:	e8 13 ee ff ff       	call   802474 <_Z6fd2numP2Fd>
  803661:	89 c3                	mov    %eax,%ebx
  803663:	eb 30                	jmp    803695 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  803665:	e8 cb f7 ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  80366a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  80366f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803672:	e8 be f7 ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
  803677:	eb 05                	jmp    80367e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  803679:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  80367e:	a1 00 70 80 00       	mov    0x807000,%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803689:	89 54 24 04          	mov    %edx,0x4(%esp)
  80368d:	89 04 24             	mov    %eax,(%esp)
  803690:	e8 58 dc ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  803695:	89 d8                	mov    %ebx,%eax
  803697:	83 c4 3c             	add    $0x3c,%esp
  80369a:	5b                   	pop    %ebx
  80369b:	5e                   	pop    %esi
  80369c:	5f                   	pop    %edi
  80369d:	5d                   	pop    %ebp
  80369e:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  80369f:	83 f8 78             	cmp    $0x78,%eax
  8036a2:	0f 85 1d fe ff ff    	jne    8034c5 <_Z4openPKci+0x67>
  8036a8:	eb cf                	jmp    803679 <_Z4openPKci+0x21b>

008036aa <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  8036aa:	55                   	push   %ebp
  8036ab:	89 e5                	mov    %esp,%ebp
  8036ad:	53                   	push   %ebx
  8036ae:	83 ec 24             	sub    $0x24,%esp
  8036b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  8036b4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8036b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ba:	e8 78 f5 ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	78 27                	js     8036ea <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  8036c3:	c7 44 24 04 70 56 80 	movl   $0x805670,0x4(%esp)
  8036ca:	00 
  8036cb:	89 1c 24             	mov    %ebx,(%esp)
  8036ce:	e8 77 d6 ff ff       	call   800d4a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  8036d3:	89 da                	mov    %ebx,%edx
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	e8 26 f4 ff ff       	call   802b03 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  8036dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e0:	e8 50 f7 ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
	return 0;
  8036e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036ea:	83 c4 24             	add    $0x24,%esp
  8036ed:	5b                   	pop    %ebx
  8036ee:	5d                   	pop    %ebp
  8036ef:	c3                   	ret    

008036f0 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  8036f0:	55                   	push   %ebp
  8036f1:	89 e5                	mov    %esp,%ebp
  8036f3:	53                   	push   %ebx
  8036f4:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  8036f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036fe:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  803701:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	e8 3a fb ff ff       	call   803246 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80370c:	89 c3                	mov    %eax,%ebx
  80370e:	85 c0                	test   %eax,%eax
  803710:	78 5f                	js     803771 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  803712:	8d 55 f0             	lea    -0x10(%ebp),%edx
  803715:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	e8 18 f5 ff ff       	call   802c37 <_ZL10inode_openiPP5Inode>
  80371f:	89 c3                	mov    %eax,%ebx
  803721:	85 c0                	test   %eax,%eax
  803723:	78 44                	js     803769 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  803725:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80372a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372d:	83 38 02             	cmpl   $0x2,(%eax)
  803730:	74 2f                	je     803761 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  803732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80373b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  803742:	ba 04 00 00 00       	mov    $0x4,%edx
  803747:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80374a:	e8 2c f4 ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80374f:	ba 04 00 00 00       	mov    $0x4,%edx
  803754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803757:	e8 1f f4 ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
	r = 0;
  80375c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  803761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803764:	e8 cc f6 ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  803769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376c:	e8 c4 f6 ff ff       	call   802e35 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  803771:	89 d8                	mov    %ebx,%eax
  803773:	83 c4 24             	add    $0x24,%esp
  803776:	5b                   	pop    %ebx
  803777:	5d                   	pop    %ebp
  803778:	c3                   	ret    

00803779 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  803779:	55                   	push   %ebp
  80377a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  80377c:	b8 00 00 00 00       	mov    $0x0,%eax
  803781:	5d                   	pop    %ebp
  803782:	c3                   	ret    

00803783 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  803783:	55                   	push   %ebp
  803784:	89 e5                	mov    %esp,%ebp
  803786:	57                   	push   %edi
  803787:	56                   	push   %esi
  803788:	53                   	push   %ebx
  803789:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  80378f:	c7 04 24 dd 2e 80 00 	movl   $0x802edd,(%esp)
  803796:	e8 80 13 00 00       	call   804b1b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  80379b:	a1 00 10 00 50       	mov    0x50001000,%eax
  8037a0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  8037a5:	74 28                	je     8037cf <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  8037a7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  8037ae:	4a 
  8037af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037b3:	c7 44 24 08 d8 56 80 	movl   $0x8056d8,0x8(%esp)
  8037ba:	00 
  8037bb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  8037c2:	00 
  8037c3:	c7 04 24 52 56 80 00 	movl   $0x805652,(%esp)
  8037ca:	e8 41 ce ff ff       	call   800610 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  8037cf:	a1 04 10 00 50       	mov    0x50001004,%eax
  8037d4:	83 f8 03             	cmp    $0x3,%eax
  8037d7:	7f 1c                	jg     8037f5 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  8037d9:	c7 44 24 08 0c 57 80 	movl   $0x80570c,0x8(%esp)
  8037e0:	00 
  8037e1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  8037e8:	00 
  8037e9:	c7 04 24 52 56 80 00 	movl   $0x805652,(%esp)
  8037f0:	e8 1b ce ff ff       	call   800610 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  8037f5:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  8037fb:	85 d2                	test   %edx,%edx
  8037fd:	7f 1c                	jg     80381b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  8037ff:	c7 44 24 08 3c 57 80 	movl   $0x80573c,0x8(%esp)
  803806:	00 
  803807:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  80380e:	00 
  80380f:	c7 04 24 52 56 80 00 	movl   $0x805652,(%esp)
  803816:	e8 f5 cd ff ff       	call   800610 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80381b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  803821:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  803827:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80382d:	85 c9                	test   %ecx,%ecx
  80382f:	0f 48 cb             	cmovs  %ebx,%ecx
  803832:	c1 f9 0c             	sar    $0xc,%ecx
  803835:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  803839:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80383f:	39 c8                	cmp    %ecx,%eax
  803841:	7c 13                	jl     803856 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  803843:	85 c0                	test   %eax,%eax
  803845:	7f 3d                	jg     803884 <_Z4fsckv+0x101>
  803847:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80384e:	00 00 00 
  803851:	e9 ac 00 00 00       	jmp    803902 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  803856:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80385c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  803860:	89 44 24 10          	mov    %eax,0x10(%esp)
  803864:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803868:	c7 44 24 08 6c 57 80 	movl   $0x80576c,0x8(%esp)
  80386f:	00 
  803870:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  803877:	00 
  803878:	c7 04 24 52 56 80 00 	movl   $0x805652,(%esp)
  80387f:	e8 8c cd ff ff       	call   800610 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  803884:	be 00 20 00 50       	mov    $0x50002000,%esi
  803889:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  803890:	00 00 00 
  803893:	bb 00 00 00 00       	mov    $0x0,%ebx
  803898:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  80389e:	39 df                	cmp    %ebx,%edi
  8038a0:	7e 27                	jle    8038c9 <_Z4fsckv+0x146>
  8038a2:	0f b6 06             	movzbl (%esi),%eax
  8038a5:	84 c0                	test   %al,%al
  8038a7:	74 4b                	je     8038f4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  8038a9:	0f be c0             	movsbl %al,%eax
  8038ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8038b4:	c7 04 24 b0 57 80 00 	movl   $0x8057b0,(%esp)
  8038bb:	e8 6e ce ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  8038c0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8038c7:	eb 2b                	jmp    8038f4 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  8038c9:	0f b6 06             	movzbl (%esi),%eax
  8038cc:	3c 01                	cmp    $0x1,%al
  8038ce:	76 24                	jbe    8038f4 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  8038d0:	0f be c0             	movsbl %al,%eax
  8038d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038d7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8038db:	c7 04 24 e4 57 80 00 	movl   $0x8057e4,(%esp)
  8038e2:	e8 47 ce ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  8038e7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  8038ee:	80 3e 00             	cmpb   $0x0,(%esi)
  8038f1:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8038f4:	83 c3 01             	add    $0x1,%ebx
  8038f7:	83 c6 01             	add    $0x1,%esi
  8038fa:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  803900:	7f 9c                	jg     80389e <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803902:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803909:	0f 8e e1 02 00 00    	jle    803bf0 <_Z4fsckv+0x46d>
  80390f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  803916:	00 00 00 
		struct Inode *ino = get_inode(i);
  803919:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80391f:	e8 f9 f1 ff ff       	call   802b1d <_ZL9get_inodei>
  803924:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80392a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80392e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  803935:	75 22                	jne    803959 <_Z4fsckv+0x1d6>
  803937:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80393e:	0f 84 a9 06 00 00    	je     803fed <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  803944:	ba 00 00 00 00       	mov    $0x0,%edx
  803949:	e8 2d f2 ff ff       	call   802b7b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80394e:	85 c0                	test   %eax,%eax
  803950:	74 3a                	je     80398c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  803952:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  803959:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80395f:	8b 02                	mov    (%edx),%eax
  803961:	83 f8 01             	cmp    $0x1,%eax
  803964:	74 26                	je     80398c <_Z4fsckv+0x209>
  803966:	83 f8 02             	cmp    $0x2,%eax
  803969:	74 21                	je     80398c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80396b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80396f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803975:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803979:	c7 04 24 10 58 80 00 	movl   $0x805810,(%esp)
  803980:	e8 a9 cd ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  803985:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80398c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  803993:	75 3f                	jne    8039d4 <_Z4fsckv+0x251>
  803995:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80399b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80399f:	75 15                	jne    8039b6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  8039a1:	c7 04 24 34 58 80 00 	movl   $0x805834,(%esp)
  8039a8:	e8 81 cd ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  8039ad:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8039b4:	eb 1e                	jmp    8039d4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  8039b6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8039bc:	83 3a 02             	cmpl   $0x2,(%edx)
  8039bf:	74 13                	je     8039d4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8039c1:	c7 04 24 68 58 80 00 	movl   $0x805868,(%esp)
  8039c8:	e8 61 cd ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  8039cd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  8039d4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  8039d9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8039e0:	0f 84 93 00 00 00    	je     803a79 <_Z4fsckv+0x2f6>
  8039e6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8039ec:	8b 41 08             	mov    0x8(%ecx),%eax
  8039ef:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  8039f4:	7e 23                	jle    803a19 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  8039f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8039fa:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a04:	c7 04 24 98 58 80 00 	movl   $0x805898,(%esp)
  803a0b:	e8 1e cd ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  803a10:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803a17:	eb 09                	jmp    803a22 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  803a19:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803a20:	74 4b                	je     803a6d <_Z4fsckv+0x2ea>
  803a22:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803a28:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  803a2e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  803a34:	74 23                	je     803a59 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  803a36:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a3a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803a40:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a44:	c7 04 24 bc 58 80 00 	movl   $0x8058bc,(%esp)
  803a4b:	e8 de cc ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  803a50:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803a57:	eb 09                	jmp    803a62 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  803a59:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803a60:	74 12                	je     803a74 <_Z4fsckv+0x2f1>
  803a62:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803a68:	8b 78 08             	mov    0x8(%eax),%edi
  803a6b:	eb 0c                	jmp    803a79 <_Z4fsckv+0x2f6>
  803a6d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a72:	eb 05                	jmp    803a79 <_Z4fsckv+0x2f6>
  803a74:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  803a79:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  803a7e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803a84:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  803a88:	89 d8                	mov    %ebx,%eax
  803a8a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  803a8d:	39 c7                	cmp    %eax,%edi
  803a8f:	7e 2b                	jle    803abc <_Z4fsckv+0x339>
  803a91:	85 f6                	test   %esi,%esi
  803a93:	75 27                	jne    803abc <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  803a95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a99:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a9d:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803aa3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aa7:	c7 04 24 e0 58 80 00 	movl   $0x8058e0,(%esp)
  803aae:	e8 7b cc ff ff       	call   80072e <_Z7cprintfPKcz>
				++errors;
  803ab3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803aba:	eb 36                	jmp    803af2 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  803abc:	39 f8                	cmp    %edi,%eax
  803abe:	7c 32                	jl     803af2 <_Z4fsckv+0x36f>
  803ac0:	85 f6                	test   %esi,%esi
  803ac2:	74 2e                	je     803af2 <_Z4fsckv+0x36f>
  803ac4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803acb:	74 25                	je     803af2 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  803acd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ad1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ad5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  803adf:	c7 04 24 24 59 80 00 	movl   $0x805924,(%esp)
  803ae6:	e8 43 cc ff ff       	call   80072e <_Z7cprintfPKcz>
				++errors;
  803aeb:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  803af2:	85 f6                	test   %esi,%esi
  803af4:	0f 84 a0 00 00 00    	je     803b9a <_Z4fsckv+0x417>
  803afa:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803b01:	0f 84 93 00 00 00    	je     803b9a <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  803b07:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  803b0d:	7e 27                	jle    803b36 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  803b0f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803b13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b17:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  803b1d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803b21:	c7 04 24 68 59 80 00 	movl   $0x805968,(%esp)
  803b28:	e8 01 cc ff ff       	call   80072e <_Z7cprintfPKcz>
					++errors;
  803b2d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803b34:	eb 64                	jmp    803b9a <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  803b36:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  803b3d:	3c 01                	cmp    $0x1,%al
  803b3f:	75 27                	jne    803b68 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  803b41:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803b45:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b49:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803b4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b53:	c7 04 24 ac 59 80 00 	movl   $0x8059ac,(%esp)
  803b5a:	e8 cf cb ff ff       	call   80072e <_Z7cprintfPKcz>
					++errors;
  803b5f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803b66:	eb 32                	jmp    803b9a <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  803b68:	3c ff                	cmp    $0xff,%al
  803b6a:	75 27                	jne    803b93 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  803b6c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803b70:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b74:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b7e:	c7 04 24 e8 59 80 00 	movl   $0x8059e8,(%esp)
  803b85:	e8 a4 cb ff ff       	call   80072e <_Z7cprintfPKcz>
					++errors;
  803b8a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803b91:	eb 07                	jmp    803b9a <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  803b93:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  803b9a:	83 c3 01             	add    $0x1,%ebx
  803b9d:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  803ba3:	0f 85 d5 fe ff ff    	jne    803a7e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  803ba9:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  803bb0:	0f 94 c0             	sete   %al
  803bb3:	0f b6 c0             	movzbl %al,%eax
  803bb6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803bbc:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  803bc2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  803bc9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  803bd0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803bd7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  803bde:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803be4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  803bea:	0f 8f 29 fd ff ff    	jg     803919 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803bf0:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803bf7:	0f 8e 7f 03 00 00    	jle    803f7c <_Z4fsckv+0x7f9>
  803bfd:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  803c02:	89 f0                	mov    %esi,%eax
  803c04:	e8 14 ef ff ff       	call   802b1d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  803c09:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803c10:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803c17:	c1 e2 08             	shl    $0x8,%edx
  803c1a:	09 ca                	or     %ecx,%edx
  803c1c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803c23:	c1 e1 10             	shl    $0x10,%ecx
  803c26:	09 ca                	or     %ecx,%edx
  803c28:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  803c2f:	83 e1 7f             	and    $0x7f,%ecx
  803c32:	c1 e1 18             	shl    $0x18,%ecx
  803c35:	09 d1                	or     %edx,%ecx
  803c37:	74 0e                	je     803c47 <_Z4fsckv+0x4c4>
  803c39:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803c40:	78 05                	js     803c47 <_Z4fsckv+0x4c4>
  803c42:	83 38 02             	cmpl   $0x2,(%eax)
  803c45:	74 1f                	je     803c66 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803c47:	83 c6 01             	add    $0x1,%esi
  803c4a:	a1 08 10 00 50       	mov    0x50001008,%eax
  803c4f:	39 f0                	cmp    %esi,%eax
  803c51:	7f af                	jg     803c02 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803c53:	bb 01 00 00 00       	mov    $0x1,%ebx
  803c58:	83 f8 01             	cmp    $0x1,%eax
  803c5b:	0f 8f ad 02 00 00    	jg     803f0e <_Z4fsckv+0x78b>
  803c61:	e9 16 03 00 00       	jmp    803f7c <_Z4fsckv+0x7f9>
  803c66:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  803c68:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  803c6f:	8b 40 08             	mov    0x8(%eax),%eax
  803c72:	a8 7f                	test   $0x7f,%al
  803c74:	74 23                	je     803c99 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  803c76:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  803c7d:	00 
  803c7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c82:	89 74 24 04          	mov    %esi,0x4(%esp)
  803c86:	c7 04 24 24 5a 80 00 	movl   $0x805a24,(%esp)
  803c8d:	e8 9c ca ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  803c92:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803c99:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  803ca0:	00 00 00 
  803ca3:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  803ca9:	e9 3d 02 00 00       	jmp    803eeb <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  803cae:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803cb4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803cba:	e8 01 ee ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
  803cbf:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  803cc1:	83 38 00             	cmpl   $0x0,(%eax)
  803cc4:	0f 84 15 02 00 00    	je     803edf <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  803cca:	8b 40 04             	mov    0x4(%eax),%eax
  803ccd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803cd0:	83 fa 76             	cmp    $0x76,%edx
  803cd3:	76 27                	jbe    803cfc <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  803cd5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cd9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803cdf:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ce3:	89 74 24 04          	mov    %esi,0x4(%esp)
  803ce7:	c7 04 24 58 5a 80 00 	movl   $0x805a58,(%esp)
  803cee:	e8 3b ca ff ff       	call   80072e <_Z7cprintfPKcz>
				++errors;
  803cf3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803cfa:	eb 28                	jmp    803d24 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  803cfc:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  803d01:	74 21                	je     803d24 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  803d03:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803d09:	89 54 24 08          	mov    %edx,0x8(%esp)
  803d0d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803d11:	c7 04 24 84 5a 80 00 	movl   $0x805a84,(%esp)
  803d18:	e8 11 ca ff ff       	call   80072e <_Z7cprintfPKcz>
				++errors;
  803d1d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803d24:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  803d2b:	00 
  803d2c:	8d 43 08             	lea    0x8(%ebx),%eax
  803d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d33:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803d39:	89 0c 24             	mov    %ecx,(%esp)
  803d3c:	e8 26 d2 ff ff       	call   800f67 <memcpy>
  803d41:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803d45:	bf 77 00 00 00       	mov    $0x77,%edi
  803d4a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  803d4e:	85 ff                	test   %edi,%edi
  803d50:	b8 00 00 00 00       	mov    $0x0,%eax
  803d55:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803d58:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  803d5f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803d60:	8b 03                	mov    (%ebx),%eax
  803d62:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803d68:	7c 3e                	jl     803da8 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  803d6a:	89 44 24 10          	mov    %eax,0x10(%esp)
  803d6e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803d74:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d78:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803d7e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803d82:	89 74 24 04          	mov    %esi,0x4(%esp)
  803d86:	c7 04 24 b8 5a 80 00 	movl   $0x805ab8,(%esp)
  803d8d:	e8 9c c9 ff ff       	call   80072e <_Z7cprintfPKcz>
				++errors;
  803d92:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803d99:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  803da0:	00 00 00 
  803da3:	e9 0b 01 00 00       	jmp    803eb3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  803da8:	e8 70 ed ff ff       	call   802b1d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  803dad:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803db4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803dbb:	c1 e2 08             	shl    $0x8,%edx
  803dbe:	09 d1                	or     %edx,%ecx
  803dc0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  803dc7:	c1 e2 10             	shl    $0x10,%edx
  803dca:	09 d1                	or     %edx,%ecx
  803dcc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803dd3:	83 e2 7f             	and    $0x7f,%edx
  803dd6:	c1 e2 18             	shl    $0x18,%edx
  803dd9:	09 ca                	or     %ecx,%edx
  803ddb:	83 c2 01             	add    $0x1,%edx
  803dde:	89 d1                	mov    %edx,%ecx
  803de0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  803de6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  803dec:	0f b6 d5             	movzbl %ch,%edx
  803def:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  803df5:	89 ca                	mov    %ecx,%edx
  803df7:	c1 ea 10             	shr    $0x10,%edx
  803dfa:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  803e00:	c1 e9 18             	shr    $0x18,%ecx
  803e03:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803e0a:	83 e2 80             	and    $0xffffff80,%edx
  803e0d:	09 ca                	or     %ecx,%edx
  803e0f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803e15:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803e19:	0f 85 7a ff ff ff    	jne    803d99 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  803e1f:	8b 03                	mov    (%ebx),%eax
  803e21:	89 44 24 10          	mov    %eax,0x10(%esp)
  803e25:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803e2b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e2f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803e35:	89 44 24 08          	mov    %eax,0x8(%esp)
  803e39:	89 74 24 04          	mov    %esi,0x4(%esp)
  803e3d:	c7 04 24 e8 5a 80 00 	movl   $0x805ae8,(%esp)
  803e44:	e8 e5 c8 ff ff       	call   80072e <_Z7cprintfPKcz>
					++errors;
  803e49:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803e50:	e9 44 ff ff ff       	jmp    803d99 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803e55:	3b 78 04             	cmp    0x4(%eax),%edi
  803e58:	75 52                	jne    803eac <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  803e5a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803e5e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803e64:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e68:	83 c0 08             	add    $0x8,%eax
  803e6b:	89 04 24             	mov    %eax,(%esp)
  803e6e:	e8 35 d1 ff ff       	call   800fa8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803e73:	85 c0                	test   %eax,%eax
  803e75:	75 35                	jne    803eac <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  803e77:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803e7d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803e81:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803e87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e8b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803e91:	89 54 24 08          	mov    %edx,0x8(%esp)
  803e95:	89 74 24 04          	mov    %esi,0x4(%esp)
  803e99:	c7 04 24 18 5b 80 00 	movl   $0x805b18,(%esp)
  803ea0:	e8 89 c8 ff ff       	call   80072e <_Z7cprintfPKcz>
					++errors;
  803ea5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  803eac:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  803eb3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  803eb9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  803ebf:	7e 1e                	jle    803edf <_Z4fsckv+0x75c>
  803ec1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803ec5:	7f 18                	jg     803edf <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  803ec7:	89 ca                	mov    %ecx,%edx
  803ec9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803ecf:	e8 ec eb ff ff       	call   802ac0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  803ed4:	83 38 00             	cmpl   $0x0,(%eax)
  803ed7:	0f 85 78 ff ff ff    	jne    803e55 <_Z4fsckv+0x6d2>
  803edd:	eb cd                	jmp    803eac <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  803edf:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  803ee5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  803eeb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803ef1:	83 ea 80             	sub    $0xffffff80,%edx
  803ef4:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  803efa:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803f00:	3b 51 08             	cmp    0x8(%ecx),%edx
  803f03:	0f 8f e7 fc ff ff    	jg     803bf0 <_Z4fsckv+0x46d>
  803f09:	e9 a0 fd ff ff       	jmp    803cae <_Z4fsckv+0x52b>
  803f0e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803f14:	89 d8                	mov    %ebx,%eax
  803f16:	e8 02 ec ff ff       	call   802b1d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  803f1b:	8b 50 04             	mov    0x4(%eax),%edx
  803f1e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803f25:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  803f2c:	c1 e7 08             	shl    $0x8,%edi
  803f2f:	09 f9                	or     %edi,%ecx
  803f31:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803f38:	c1 e7 10             	shl    $0x10,%edi
  803f3b:	09 f9                	or     %edi,%ecx
  803f3d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803f44:	83 e7 7f             	and    $0x7f,%edi
  803f47:	c1 e7 18             	shl    $0x18,%edi
  803f4a:	09 f9                	or     %edi,%ecx
  803f4c:	39 ca                	cmp    %ecx,%edx
  803f4e:	74 1b                	je     803f6b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803f50:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f54:	89 54 24 08          	mov    %edx,0x8(%esp)
  803f58:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803f5c:	c7 04 24 48 5b 80 00 	movl   $0x805b48,(%esp)
  803f63:	e8 c6 c7 ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  803f68:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803f6b:	83 c3 01             	add    $0x1,%ebx
  803f6e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  803f74:	7f 9e                	jg     803f14 <_Z4fsckv+0x791>
  803f76:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803f7c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  803f83:	7e 4f                	jle    803fd4 <_Z4fsckv+0x851>
  803f85:	bb 00 00 00 00       	mov    $0x0,%ebx
  803f8a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  803f90:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  803f97:	3c ff                	cmp    $0xff,%al
  803f99:	75 09                	jne    803fa4 <_Z4fsckv+0x821>
			freemap[i] = 0;
  803f9b:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  803fa2:	eb 1f                	jmp    803fc3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  803fa4:	84 c0                	test   %al,%al
  803fa6:	75 1b                	jne    803fc3 <_Z4fsckv+0x840>
  803fa8:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  803fae:	7c 13                	jl     803fc3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  803fb0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803fb4:	c7 04 24 74 5b 80 00 	movl   $0x805b74,(%esp)
  803fbb:	e8 6e c7 ff ff       	call   80072e <_Z7cprintfPKcz>
			++errors;
  803fc0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  803fc3:	83 c3 01             	add    $0x1,%ebx
  803fc6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  803fcc:	7f c2                	jg     803f90 <_Z4fsckv+0x80d>
  803fce:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803fd4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  803fdb:	19 c0                	sbb    %eax,%eax
  803fdd:	f7 d0                	not    %eax
  803fdf:	83 e0 fd             	and    $0xfffffffd,%eax
}
  803fe2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  803fe8:	5b                   	pop    %ebx
  803fe9:	5e                   	pop    %esi
  803fea:	5f                   	pop    %edi
  803feb:	5d                   	pop    %ebp
  803fec:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  803fed:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803ff4:	0f 84 92 f9 ff ff    	je     80398c <_Z4fsckv+0x209>
  803ffa:	e9 5a f9 ff ff       	jmp    803959 <_Z4fsckv+0x1d6>
	...

00804000 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804000:	55                   	push   %ebp
  804001:	89 e5                	mov    %esp,%ebp
  804003:	83 ec 18             	sub    $0x18,%esp
  804006:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  804009:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80400c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80400f:	8b 45 08             	mov    0x8(%ebp),%eax
  804012:	89 04 24             	mov    %eax,(%esp)
  804015:	e8 a2 e4 ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  80401a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80401c:	c7 44 24 04 a7 5b 80 	movl   $0x805ba7,0x4(%esp)
  804023:	00 
  804024:	89 34 24             	mov    %esi,(%esp)
  804027:	e8 1e cd ff ff       	call   800d4a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80402c:	8b 43 04             	mov    0x4(%ebx),%eax
  80402f:	2b 03                	sub    (%ebx),%eax
  804031:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  804034:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80403b:	c7 86 80 00 00 00 3c 	movl   $0x80603c,0x80(%esi)
  804042:	60 80 00 
	return 0;
}
  804045:	b8 00 00 00 00       	mov    $0x0,%eax
  80404a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80404d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  804050:	89 ec                	mov    %ebp,%esp
  804052:	5d                   	pop    %ebp
  804053:	c3                   	ret    

00804054 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  804054:	55                   	push   %ebp
  804055:	89 e5                	mov    %esp,%ebp
  804057:	53                   	push   %ebx
  804058:	83 ec 14             	sub    $0x14,%esp
  80405b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80405e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  804062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804069:	e8 7f d2 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80406e:	89 1c 24             	mov    %ebx,(%esp)
  804071:	e8 46 e4 ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  804076:	89 44 24 04          	mov    %eax,0x4(%esp)
  80407a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804081:	e8 67 d2 ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
}
  804086:	83 c4 14             	add    $0x14,%esp
  804089:	5b                   	pop    %ebx
  80408a:	5d                   	pop    %ebp
  80408b:	c3                   	ret    

0080408c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80408c:	55                   	push   %ebp
  80408d:	89 e5                	mov    %esp,%ebp
  80408f:	57                   	push   %edi
  804090:	56                   	push   %esi
  804091:	53                   	push   %ebx
  804092:	83 ec 2c             	sub    $0x2c,%esp
  804095:	89 c7                	mov    %eax,%edi
  804097:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  80409a:	a1 00 70 80 00       	mov    0x807000,%eax
  80409f:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  8040a2:	89 3c 24             	mov    %edi,(%esp)
  8040a5:	e8 82 04 00 00       	call   80452c <_Z7pagerefPv>
  8040aa:	89 c3                	mov    %eax,%ebx
  8040ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040af:	89 04 24             	mov    %eax,(%esp)
  8040b2:	e8 75 04 00 00       	call   80452c <_Z7pagerefPv>
  8040b7:	39 c3                	cmp    %eax,%ebx
  8040b9:	0f 94 c0             	sete   %al
  8040bc:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  8040bf:	8b 15 00 70 80 00    	mov    0x807000,%edx
  8040c5:	8b 52 58             	mov    0x58(%edx),%edx
  8040c8:	39 d6                	cmp    %edx,%esi
  8040ca:	75 08                	jne    8040d4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  8040cc:	83 c4 2c             	add    $0x2c,%esp
  8040cf:	5b                   	pop    %ebx
  8040d0:	5e                   	pop    %esi
  8040d1:	5f                   	pop    %edi
  8040d2:	5d                   	pop    %ebp
  8040d3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  8040d4:	85 c0                	test   %eax,%eax
  8040d6:	74 c2                	je     80409a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  8040d8:	c7 04 24 ae 5b 80 00 	movl   $0x805bae,(%esp)
  8040df:	e8 4a c6 ff ff       	call   80072e <_Z7cprintfPKcz>
  8040e4:	eb b4                	jmp    80409a <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

008040e6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040e6:	55                   	push   %ebp
  8040e7:	89 e5                	mov    %esp,%ebp
  8040e9:	57                   	push   %edi
  8040ea:	56                   	push   %esi
  8040eb:	53                   	push   %ebx
  8040ec:	83 ec 1c             	sub    $0x1c,%esp
  8040ef:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  8040f2:	89 34 24             	mov    %esi,(%esp)
  8040f5:	e8 c2 e3 ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  8040fa:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8040fc:	bf 00 00 00 00       	mov    $0x0,%edi
  804101:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804105:	75 46                	jne    80414d <_ZL13devpipe_writeP2FdPKvj+0x67>
  804107:	eb 52                	jmp    80415b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  804109:	89 da                	mov    %ebx,%edx
  80410b:	89 f0                	mov    %esi,%eax
  80410d:	e8 7a ff ff ff       	call   80408c <_ZL13_pipeisclosedP2FdP4Pipe>
  804112:	85 c0                	test   %eax,%eax
  804114:	75 49                	jne    80415f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  804116:	e8 e1 d0 ff ff       	call   8011fc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80411b:	8b 43 04             	mov    0x4(%ebx),%eax
  80411e:	89 c2                	mov    %eax,%edx
  804120:	2b 13                	sub    (%ebx),%edx
  804122:	83 fa 20             	cmp    $0x20,%edx
  804125:	74 e2                	je     804109 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804127:	89 c2                	mov    %eax,%edx
  804129:	c1 fa 1f             	sar    $0x1f,%edx
  80412c:	c1 ea 1b             	shr    $0x1b,%edx
  80412f:	01 d0                	add    %edx,%eax
  804131:	83 e0 1f             	and    $0x1f,%eax
  804134:	29 d0                	sub    %edx,%eax
  804136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  804139:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80413d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  804141:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  804145:	83 c7 01             	add    $0x1,%edi
  804148:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80414b:	76 0e                	jbe    80415b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80414d:	8b 43 04             	mov    0x4(%ebx),%eax
  804150:	89 c2                	mov    %eax,%edx
  804152:	2b 13                	sub    (%ebx),%edx
  804154:	83 fa 20             	cmp    $0x20,%edx
  804157:	74 b0                	je     804109 <_ZL13devpipe_writeP2FdPKvj+0x23>
  804159:	eb cc                	jmp    804127 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80415b:	89 f8                	mov    %edi,%eax
  80415d:	eb 05                	jmp    804164 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80415f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  804164:	83 c4 1c             	add    $0x1c,%esp
  804167:	5b                   	pop    %ebx
  804168:	5e                   	pop    %esi
  804169:	5f                   	pop    %edi
  80416a:	5d                   	pop    %ebp
  80416b:	c3                   	ret    

0080416c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80416c:	55                   	push   %ebp
  80416d:	89 e5                	mov    %esp,%ebp
  80416f:	83 ec 28             	sub    $0x28,%esp
  804172:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  804175:	89 75 f8             	mov    %esi,-0x8(%ebp)
  804178:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80417b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80417e:	89 3c 24             	mov    %edi,(%esp)
  804181:	e8 36 e3 ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  804186:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  804188:	be 00 00 00 00       	mov    $0x0,%esi
  80418d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804191:	75 47                	jne    8041da <_ZL12devpipe_readP2FdPvj+0x6e>
  804193:	eb 52                	jmp    8041e7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  804195:	89 f0                	mov    %esi,%eax
  804197:	eb 5e                	jmp    8041f7 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  804199:	89 da                	mov    %ebx,%edx
  80419b:	89 f8                	mov    %edi,%eax
  80419d:	8d 76 00             	lea    0x0(%esi),%esi
  8041a0:	e8 e7 fe ff ff       	call   80408c <_ZL13_pipeisclosedP2FdP4Pipe>
  8041a5:	85 c0                	test   %eax,%eax
  8041a7:	75 49                	jne    8041f2 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  8041a9:	e8 4e d0 ff ff       	call   8011fc <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8041ae:	8b 03                	mov    (%ebx),%eax
  8041b0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8041b3:	74 e4                	je     804199 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8041b5:	89 c2                	mov    %eax,%edx
  8041b7:	c1 fa 1f             	sar    $0x1f,%edx
  8041ba:	c1 ea 1b             	shr    $0x1b,%edx
  8041bd:	01 d0                	add    %edx,%eax
  8041bf:	83 e0 1f             	and    $0x1f,%eax
  8041c2:	29 d0                	sub    %edx,%eax
  8041c4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8041c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041cc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8041cf:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8041d2:	83 c6 01             	add    $0x1,%esi
  8041d5:	39 75 10             	cmp    %esi,0x10(%ebp)
  8041d8:	76 0d                	jbe    8041e7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8041da:	8b 03                	mov    (%ebx),%eax
  8041dc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8041df:	75 d4                	jne    8041b5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8041e1:	85 f6                	test   %esi,%esi
  8041e3:	75 b0                	jne    804195 <_ZL12devpipe_readP2FdPvj+0x29>
  8041e5:	eb b2                	jmp    804199 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8041e7:	89 f0                	mov    %esi,%eax
  8041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8041f0:	eb 05                	jmp    8041f7 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  8041f2:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  8041f7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8041fa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8041fd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  804200:	89 ec                	mov    %ebp,%esp
  804202:	5d                   	pop    %ebp
  804203:	c3                   	ret    

00804204 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804204:	55                   	push   %ebp
  804205:	89 e5                	mov    %esp,%ebp
  804207:	83 ec 48             	sub    $0x48,%esp
  80420a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80420d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  804210:	89 7d fc             	mov    %edi,-0x4(%ebp)
  804213:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  804216:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  804219:	89 04 24             	mov    %eax,(%esp)
  80421c:	e8 b6 e2 ff ff       	call   8024d7 <_Z14fd_find_unusedPP2Fd>
  804221:	89 c3                	mov    %eax,%ebx
  804223:	85 c0                	test   %eax,%eax
  804225:	0f 88 0b 01 00 00    	js     804336 <_Z4pipePi+0x132>
  80422b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804232:	00 
  804233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80423a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804241:	e8 ea cf ff ff       	call   801230 <_Z14sys_page_allociPvi>
  804246:	89 c3                	mov    %eax,%ebx
  804248:	85 c0                	test   %eax,%eax
  80424a:	0f 89 f5 00 00 00    	jns    804345 <_Z4pipePi+0x141>
  804250:	e9 e1 00 00 00       	jmp    804336 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  804255:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80425c:	00 
  80425d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804260:	89 44 24 04          	mov    %eax,0x4(%esp)
  804264:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80426b:	e8 c0 cf ff ff       	call   801230 <_Z14sys_page_allociPvi>
  804270:	89 c3                	mov    %eax,%ebx
  804272:	85 c0                	test   %eax,%eax
  804274:	0f 89 e2 00 00 00    	jns    80435c <_Z4pipePi+0x158>
  80427a:	e9 a4 00 00 00       	jmp    804323 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80427f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804282:	89 04 24             	mov    %eax,(%esp)
  804285:	e8 32 e2 ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  80428a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  804291:	00 
  804292:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804296:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80429d:	00 
  80429e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8042a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8042a9:	e8 e1 cf ff ff       	call   80128f <_Z12sys_page_mapiPviS_i>
  8042ae:	89 c3                	mov    %eax,%ebx
  8042b0:	85 c0                	test   %eax,%eax
  8042b2:	78 4c                	js     804300 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8042b4:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  8042ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042bd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8042bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8042c9:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  8042cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042d2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8042d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8042de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042e1:	89 04 24             	mov    %eax,(%esp)
  8042e4:	e8 8b e1 ff ff       	call   802474 <_Z6fd2numP2Fd>
  8042e9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8042eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042ee:	89 04 24             	mov    %eax,(%esp)
  8042f1:	e8 7e e1 ff ff       	call   802474 <_Z6fd2numP2Fd>
  8042f6:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8042f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8042fe:	eb 36                	jmp    804336 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  804300:	89 74 24 04          	mov    %esi,0x4(%esp)
  804304:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80430b:	e8 dd cf ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  804310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804313:	89 44 24 04          	mov    %eax,0x4(%esp)
  804317:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80431e:	e8 ca cf ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  804323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804326:	89 44 24 04          	mov    %eax,0x4(%esp)
  80432a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804331:	e8 b7 cf ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  804336:	89 d8                	mov    %ebx,%eax
  804338:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80433b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80433e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  804341:	89 ec                	mov    %ebp,%esp
  804343:	5d                   	pop    %ebp
  804344:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  804345:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804348:	89 04 24             	mov    %eax,(%esp)
  80434b:	e8 87 e1 ff ff       	call   8024d7 <_Z14fd_find_unusedPP2Fd>
  804350:	89 c3                	mov    %eax,%ebx
  804352:	85 c0                	test   %eax,%eax
  804354:	0f 89 fb fe ff ff    	jns    804255 <_Z4pipePi+0x51>
  80435a:	eb c7                	jmp    804323 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80435c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80435f:	89 04 24             	mov    %eax,(%esp)
  804362:	e8 55 e1 ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  804367:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804369:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804370:	00 
  804371:	89 44 24 04          	mov    %eax,0x4(%esp)
  804375:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80437c:	e8 af ce ff ff       	call   801230 <_Z14sys_page_allociPvi>
  804381:	89 c3                	mov    %eax,%ebx
  804383:	85 c0                	test   %eax,%eax
  804385:	0f 89 f4 fe ff ff    	jns    80427f <_Z4pipePi+0x7b>
  80438b:	eb 83                	jmp    804310 <_Z4pipePi+0x10c>

0080438d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  80438d:	55                   	push   %ebp
  80438e:	89 e5                	mov    %esp,%ebp
  804390:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  804393:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80439a:	00 
  80439b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80439e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8043a5:	89 04 24             	mov    %eax,(%esp)
  8043a8:	e8 74 e0 ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  8043ad:	85 c0                	test   %eax,%eax
  8043af:	78 15                	js     8043c6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8043b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b4:	89 04 24             	mov    %eax,(%esp)
  8043b7:	e8 00 e1 ff ff       	call   8024bc <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  8043bc:	89 c2                	mov    %eax,%edx
  8043be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043c1:	e8 c6 fc ff ff       	call   80408c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  8043c6:	c9                   	leave  
  8043c7:	c3                   	ret    

008043c8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  8043c8:	55                   	push   %ebp
  8043c9:	89 e5                	mov    %esp,%ebp
  8043cb:	53                   	push   %ebx
  8043cc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  8043cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8043d2:	89 04 24             	mov    %eax,(%esp)
  8043d5:	e8 fd e0 ff ff       	call   8024d7 <_Z14fd_find_unusedPP2Fd>
  8043da:	89 c3                	mov    %eax,%ebx
  8043dc:	85 c0                	test   %eax,%eax
  8043de:	0f 88 be 00 00 00    	js     8044a2 <_Z18pipe_ipc_recv_readv+0xda>
  8043e4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8043eb:	00 
  8043ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8043fa:	e8 31 ce ff ff       	call   801230 <_Z14sys_page_allociPvi>
  8043ff:	89 c3                	mov    %eax,%ebx
  804401:	85 c0                	test   %eax,%eax
  804403:	0f 89 a1 00 00 00    	jns    8044aa <_Z18pipe_ipc_recv_readv+0xe2>
  804409:	e9 94 00 00 00       	jmp    8044a2 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  80440e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804411:	85 c0                	test   %eax,%eax
  804413:	75 0e                	jne    804423 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  804415:	c7 04 24 0c 5c 80 00 	movl   $0x805c0c,(%esp)
  80441c:	e8 0d c3 ff ff       	call   80072e <_Z7cprintfPKcz>
  804421:	eb 10                	jmp    804433 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  804423:	89 44 24 04          	mov    %eax,0x4(%esp)
  804427:	c7 04 24 c1 5b 80 00 	movl   $0x805bc1,(%esp)
  80442e:	e8 fb c2 ff ff       	call   80072e <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  804433:	c7 04 24 cb 5b 80 00 	movl   $0x805bcb,(%esp)
  80443a:	e8 ef c2 ff ff       	call   80072e <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  80443f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804442:	a8 04                	test   $0x4,%al
  804444:	74 04                	je     80444a <_Z18pipe_ipc_recv_readv+0x82>
  804446:	a8 01                	test   $0x1,%al
  804448:	75 24                	jne    80446e <_Z18pipe_ipc_recv_readv+0xa6>
  80444a:	c7 44 24 0c de 5b 80 	movl   $0x805bde,0xc(%esp)
  804451:	00 
  804452:	c7 44 24 08 76 55 80 	movl   $0x805576,0x8(%esp)
  804459:	00 
  80445a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  804461:	00 
  804462:	c7 04 24 fb 5b 80 00 	movl   $0x805bfb,(%esp)
  804469:	e8 a2 c1 ff ff       	call   800610 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  80446e:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  804474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804477:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  804479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80447c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  804483:	89 04 24             	mov    %eax,(%esp)
  804486:	e8 e9 df ff ff       	call   802474 <_Z6fd2numP2Fd>
  80448b:	89 c3                	mov    %eax,%ebx
  80448d:	eb 13                	jmp    8044a2 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  80448f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804492:	89 44 24 04          	mov    %eax,0x4(%esp)
  804496:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80449d:	e8 4b ce ff ff       	call   8012ed <_Z14sys_page_unmapiPv>
err:
    return r;
}
  8044a2:	89 d8                	mov    %ebx,%eax
  8044a4:	83 c4 24             	add    $0x24,%esp
  8044a7:	5b                   	pop    %ebx
  8044a8:	5d                   	pop    %ebp
  8044a9:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  8044aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044ad:	89 04 24             	mov    %eax,(%esp)
  8044b0:	e8 07 e0 ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  8044b5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  8044b8:	89 54 24 08          	mov    %edx,0x8(%esp)
  8044bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8044c3:	89 04 24             	mov    %eax,(%esp)
  8044c6:	e8 45 07 00 00       	call   804c10 <_Z8ipc_recvPiPvS_>
  8044cb:	89 c3                	mov    %eax,%ebx
  8044cd:	85 c0                	test   %eax,%eax
  8044cf:	0f 89 39 ff ff ff    	jns    80440e <_Z18pipe_ipc_recv_readv+0x46>
  8044d5:	eb b8                	jmp    80448f <_Z18pipe_ipc_recv_readv+0xc7>

008044d7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  8044d7:	55                   	push   %ebp
  8044d8:	89 e5                	mov    %esp,%ebp
  8044da:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  8044dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8044e4:	00 
  8044e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8044e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044ef:	89 04 24             	mov    %eax,(%esp)
  8044f2:	e8 2a df ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  8044f7:	85 c0                	test   %eax,%eax
  8044f9:	78 2f                	js     80452a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  8044fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044fe:	89 04 24             	mov    %eax,(%esp)
  804501:	e8 b6 df ff ff       	call   8024bc <_Z7fd2dataP2Fd>
  804506:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80450d:	00 
  80450e:	89 44 24 08          	mov    %eax,0x8(%esp)
  804512:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  804519:	00 
  80451a:	8b 45 08             	mov    0x8(%ebp),%eax
  80451d:	89 04 24             	mov    %eax,(%esp)
  804520:	e8 7a 07 00 00       	call   804c9f <_Z8ipc_sendijPvi>
    return 0;
  804525:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80452a:	c9                   	leave  
  80452b:	c3                   	ret    

0080452c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80452c:	55                   	push   %ebp
  80452d:	89 e5                	mov    %esp,%ebp
  80452f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  804532:	89 d0                	mov    %edx,%eax
  804534:	c1 e8 16             	shr    $0x16,%eax
  804537:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  80453e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  804543:	f6 c1 01             	test   $0x1,%cl
  804546:	74 1d                	je     804565 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  804548:	c1 ea 0c             	shr    $0xc,%edx
  80454b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  804552:	f6 c2 01             	test   $0x1,%dl
  804555:	74 0e                	je     804565 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  804557:	c1 ea 0c             	shr    $0xc,%edx
  80455a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  804561:	ef 
  804562:	0f b7 c0             	movzwl %ax,%eax
}
  804565:	5d                   	pop    %ebp
  804566:	c3                   	ret    
	...

00804570 <_Z4waiti>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804570:	55                   	push   %ebp
  804571:	89 e5                	mov    %esp,%ebp
  804573:	56                   	push   %esi
  804574:	53                   	push   %ebx
  804575:	83 ec 10             	sub    $0x10,%esp
  804578:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80457b:	85 f6                	test   %esi,%esi
  80457d:	75 24                	jne    8045a3 <_Z4waiti+0x33>
  80457f:	c7 44 24 0c 2f 5c 80 	movl   $0x805c2f,0xc(%esp)
  804586:	00 
  804587:	c7 44 24 08 76 55 80 	movl   $0x805576,0x8(%esp)
  80458e:	00 
  80458f:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  804596:	00 
  804597:	c7 04 24 3a 5c 80 00 	movl   $0x805c3a,(%esp)
  80459e:	e8 6d c0 ff ff       	call   800610 <_Z6_panicPKciS0_z>
	e = &envs[ENVX(envid)];
  8045a3:	89 f3                	mov    %esi,%ebx
  8045a5:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8045ab:	6b db 78             	imul   $0x78,%ebx,%ebx
  8045ae:	8b 83 04 00 00 ef    	mov    -0x10fffffc(%ebx),%eax
  8045b4:	39 f0                	cmp    %esi,%eax
  8045b6:	75 11                	jne    8045c9 <_Z4waiti+0x59>
  8045b8:	8b 83 0c 00 00 ef    	mov    -0x10fffff4(%ebx),%eax
  8045be:	85 c0                	test   %eax,%eax
  8045c0:	74 07                	je     8045c9 <_Z4waiti+0x59>
		sys_yield();
  8045c2:	e8 35 cc ff ff       	call   8011fc <_Z9sys_yieldv>
  8045c7:	eb e5                	jmp    8045ae <_Z4waiti+0x3e>
}
  8045c9:	83 c4 10             	add    $0x10,%esp
  8045cc:	5b                   	pop    %ebx
  8045cd:	5e                   	pop    %esi
  8045ce:	5d                   	pop    %ebp
  8045cf:	90                   	nop
  8045d0:	c3                   	ret    
	...

008045e0 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8045e0:	55                   	push   %ebp
  8045e1:	89 e5                	mov    %esp,%ebp
  8045e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8045e6:	c7 44 24 04 45 5c 80 	movl   $0x805c45,0x4(%esp)
  8045ed:	00 
  8045ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045f1:	89 04 24             	mov    %eax,(%esp)
  8045f4:	e8 51 c7 ff ff       	call   800d4a <_Z6strcpyPcPKc>
	return 0;
}
  8045f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8045fe:	c9                   	leave  
  8045ff:	c3                   	ret    

00804600 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  804600:	55                   	push   %ebp
  804601:	89 e5                	mov    %esp,%ebp
  804603:	53                   	push   %ebx
  804604:	83 ec 14             	sub    $0x14,%esp
  804607:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80460a:	89 1c 24             	mov    %ebx,(%esp)
  80460d:	e8 1a ff ff ff       	call   80452c <_Z7pagerefPv>
  804612:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  804614:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  804619:	83 fa 01             	cmp    $0x1,%edx
  80461c:	75 0b                	jne    804629 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80461e:	8b 43 0c             	mov    0xc(%ebx),%eax
  804621:	89 04 24             	mov    %eax,(%esp)
  804624:	e8 fe 02 00 00       	call   804927 <_Z11nsipc_closei>
	else
		return 0;
}
  804629:	83 c4 14             	add    $0x14,%esp
  80462c:	5b                   	pop    %ebx
  80462d:	5d                   	pop    %ebp
  80462e:	c3                   	ret    

0080462f <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80462f:	55                   	push   %ebp
  804630:	89 e5                	mov    %esp,%ebp
  804632:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804635:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80463c:	00 
  80463d:	8b 45 10             	mov    0x10(%ebp),%eax
  804640:	89 44 24 08          	mov    %eax,0x8(%esp)
  804644:	8b 45 0c             	mov    0xc(%ebp),%eax
  804647:	89 44 24 04          	mov    %eax,0x4(%esp)
  80464b:	8b 45 08             	mov    0x8(%ebp),%eax
  80464e:	8b 40 0c             	mov    0xc(%eax),%eax
  804651:	89 04 24             	mov    %eax,(%esp)
  804654:	e8 c9 03 00 00       	call   804a22 <_Z10nsipc_sendiPKvij>
}
  804659:	c9                   	leave  
  80465a:	c3                   	ret    

0080465b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80465b:	55                   	push   %ebp
  80465c:	89 e5                	mov    %esp,%ebp
  80465e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  804661:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  804668:	00 
  804669:	8b 45 10             	mov    0x10(%ebp),%eax
  80466c:	89 44 24 08          	mov    %eax,0x8(%esp)
  804670:	8b 45 0c             	mov    0xc(%ebp),%eax
  804673:	89 44 24 04          	mov    %eax,0x4(%esp)
  804677:	8b 45 08             	mov    0x8(%ebp),%eax
  80467a:	8b 40 0c             	mov    0xc(%eax),%eax
  80467d:	89 04 24             	mov    %eax,(%esp)
  804680:	e8 1d 03 00 00       	call   8049a2 <_Z10nsipc_recviPvij>
}
  804685:	c9                   	leave  
  804686:	c3                   	ret    

00804687 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  804687:	55                   	push   %ebp
  804688:	89 e5                	mov    %esp,%ebp
  80468a:	83 ec 28             	sub    $0x28,%esp
  80468d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  804690:	89 75 fc             	mov    %esi,-0x4(%ebp)
  804693:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  804695:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804698:	89 04 24             	mov    %eax,(%esp)
  80469b:	e8 37 de ff ff       	call   8024d7 <_Z14fd_find_unusedPP2Fd>
  8046a0:	89 c3                	mov    %eax,%ebx
  8046a2:	85 c0                	test   %eax,%eax
  8046a4:	78 21                	js     8046c7 <_ZL12alloc_sockfdi+0x40>
  8046a6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8046ad:	00 
  8046ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8046b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8046bc:	e8 6f cb ff ff       	call   801230 <_Z14sys_page_allociPvi>
  8046c1:	89 c3                	mov    %eax,%ebx
  8046c3:	85 c0                	test   %eax,%eax
  8046c5:	79 14                	jns    8046db <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  8046c7:	89 34 24             	mov    %esi,(%esp)
  8046ca:	e8 58 02 00 00       	call   804927 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  8046cf:	89 d8                	mov    %ebx,%eax
  8046d1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8046d4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8046d7:	89 ec                	mov    %ebp,%esp
  8046d9:	5d                   	pop    %ebp
  8046da:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  8046db:	8b 15 58 60 80 00    	mov    0x806058,%edx
  8046e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046e4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046e9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8046f0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8046f3:	89 04 24             	mov    %eax,(%esp)
  8046f6:	e8 79 dd ff ff       	call   802474 <_Z6fd2numP2Fd>
  8046fb:	89 c3                	mov    %eax,%ebx
  8046fd:	eb d0                	jmp    8046cf <_ZL12alloc_sockfdi+0x48>

008046ff <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  8046ff:	55                   	push   %ebp
  804700:	89 e5                	mov    %esp,%ebp
  804702:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  804705:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80470c:	00 
  80470d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  804710:	89 54 24 04          	mov    %edx,0x4(%esp)
  804714:	89 04 24             	mov    %eax,(%esp)
  804717:	e8 05 dd ff ff       	call   802421 <_Z9fd_lookupiPP2Fdb>
  80471c:	85 c0                	test   %eax,%eax
  80471e:	78 15                	js     804735 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  804720:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  804723:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  804728:	8b 0d 58 60 80 00    	mov    0x806058,%ecx
  80472e:	39 0a                	cmp    %ecx,(%edx)
  804730:	75 03                	jne    804735 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  804732:	8b 42 0c             	mov    0xc(%edx),%eax
}
  804735:	c9                   	leave  
  804736:	c3                   	ret    

00804737 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804737:	55                   	push   %ebp
  804738:	89 e5                	mov    %esp,%ebp
  80473a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80473d:	8b 45 08             	mov    0x8(%ebp),%eax
  804740:	e8 ba ff ff ff       	call   8046ff <_ZL9fd2sockidi>
  804745:	85 c0                	test   %eax,%eax
  804747:	78 1f                	js     804768 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804749:	8b 55 10             	mov    0x10(%ebp),%edx
  80474c:	89 54 24 08          	mov    %edx,0x8(%esp)
  804750:	8b 55 0c             	mov    0xc(%ebp),%edx
  804753:	89 54 24 04          	mov    %edx,0x4(%esp)
  804757:	89 04 24             	mov    %eax,(%esp)
  80475a:	e8 19 01 00 00       	call   804878 <_Z12nsipc_acceptiP8sockaddrPj>
  80475f:	85 c0                	test   %eax,%eax
  804761:	78 05                	js     804768 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  804763:	e8 1f ff ff ff       	call   804687 <_ZL12alloc_sockfdi>
}
  804768:	c9                   	leave  
  804769:	c3                   	ret    

0080476a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80476a:	55                   	push   %ebp
  80476b:	89 e5                	mov    %esp,%ebp
  80476d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  804770:	8b 45 08             	mov    0x8(%ebp),%eax
  804773:	e8 87 ff ff ff       	call   8046ff <_ZL9fd2sockidi>
  804778:	85 c0                	test   %eax,%eax
  80477a:	78 16                	js     804792 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80477c:	8b 55 10             	mov    0x10(%ebp),%edx
  80477f:	89 54 24 08          	mov    %edx,0x8(%esp)
  804783:	8b 55 0c             	mov    0xc(%ebp),%edx
  804786:	89 54 24 04          	mov    %edx,0x4(%esp)
  80478a:	89 04 24             	mov    %eax,(%esp)
  80478d:	e8 34 01 00 00       	call   8048c6 <_Z10nsipc_bindiP8sockaddrj>
}
  804792:	c9                   	leave  
  804793:	c3                   	ret    

00804794 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  804794:	55                   	push   %ebp
  804795:	89 e5                	mov    %esp,%ebp
  804797:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80479a:	8b 45 08             	mov    0x8(%ebp),%eax
  80479d:	e8 5d ff ff ff       	call   8046ff <_ZL9fd2sockidi>
  8047a2:	85 c0                	test   %eax,%eax
  8047a4:	78 0f                	js     8047b5 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8047a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8047a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8047ad:	89 04 24             	mov    %eax,(%esp)
  8047b0:	e8 50 01 00 00       	call   804905 <_Z14nsipc_shutdownii>
}
  8047b5:	c9                   	leave  
  8047b6:	c3                   	ret    

008047b7 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8047b7:	55                   	push   %ebp
  8047b8:	89 e5                	mov    %esp,%ebp
  8047ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8047bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8047c0:	e8 3a ff ff ff       	call   8046ff <_ZL9fd2sockidi>
  8047c5:	85 c0                	test   %eax,%eax
  8047c7:	78 16                	js     8047df <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8047c9:	8b 55 10             	mov    0x10(%ebp),%edx
  8047cc:	89 54 24 08          	mov    %edx,0x8(%esp)
  8047d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8047d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8047d7:	89 04 24             	mov    %eax,(%esp)
  8047da:	e8 62 01 00 00       	call   804941 <_Z13nsipc_connectiPK8sockaddrj>
}
  8047df:	c9                   	leave  
  8047e0:	c3                   	ret    

008047e1 <_Z6listenii>:

int
listen(int s, int backlog)
{
  8047e1:	55                   	push   %ebp
  8047e2:	89 e5                	mov    %esp,%ebp
  8047e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8047e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8047ea:	e8 10 ff ff ff       	call   8046ff <_ZL9fd2sockidi>
  8047ef:	85 c0                	test   %eax,%eax
  8047f1:	78 0f                	js     804802 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8047f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8047f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8047fa:	89 04 24             	mov    %eax,(%esp)
  8047fd:	e8 7e 01 00 00       	call   804980 <_Z12nsipc_listenii>
}
  804802:	c9                   	leave  
  804803:	c3                   	ret    

00804804 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  804804:	55                   	push   %ebp
  804805:	89 e5                	mov    %esp,%ebp
  804807:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80480a:	8b 45 10             	mov    0x10(%ebp),%eax
  80480d:	89 44 24 08          	mov    %eax,0x8(%esp)
  804811:	8b 45 0c             	mov    0xc(%ebp),%eax
  804814:	89 44 24 04          	mov    %eax,0x4(%esp)
  804818:	8b 45 08             	mov    0x8(%ebp),%eax
  80481b:	89 04 24             	mov    %eax,(%esp)
  80481e:	e8 72 02 00 00       	call   804a95 <_Z12nsipc_socketiii>
  804823:	85 c0                	test   %eax,%eax
  804825:	78 05                	js     80482c <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  804827:	e8 5b fe ff ff       	call   804687 <_ZL12alloc_sockfdi>
}
  80482c:	c9                   	leave  
  80482d:	8d 76 00             	lea    0x0(%esi),%esi
  804830:	c3                   	ret    
  804831:	00 00                	add    %al,(%eax)
	...

00804834 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  804834:	55                   	push   %ebp
  804835:	89 e5                	mov    %esp,%ebp
  804837:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80483a:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  804841:	00 
  804842:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  804849:	00 
  80484a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80484e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  804855:	e8 45 04 00 00       	call   804c9f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  80485a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  804861:	00 
  804862:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  804869:	00 
  80486a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804871:	e8 9a 03 00 00       	call   804c10 <_Z8ipc_recvPiPvS_>
}
  804876:	c9                   	leave  
  804877:	c3                   	ret    

00804878 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804878:	55                   	push   %ebp
  804879:	89 e5                	mov    %esp,%ebp
  80487b:	53                   	push   %ebx
  80487c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  80487f:	8b 45 08             	mov    0x8(%ebp),%eax
  804882:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804887:	b8 01 00 00 00       	mov    $0x1,%eax
  80488c:	e8 a3 ff ff ff       	call   804834 <_ZL5nsipcj>
  804891:	89 c3                	mov    %eax,%ebx
  804893:	85 c0                	test   %eax,%eax
  804895:	78 27                	js     8048be <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  804897:	a1 10 80 80 00       	mov    0x808010,%eax
  80489c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8048a0:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8048a7:	00 
  8048a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8048ab:	89 04 24             	mov    %eax,(%esp)
  8048ae:	e8 39 c6 ff ff       	call   800eec <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  8048b3:	8b 15 10 80 80 00    	mov    0x808010,%edx
  8048b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8048bc:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8048be:	89 d8                	mov    %ebx,%eax
  8048c0:	83 c4 14             	add    $0x14,%esp
  8048c3:	5b                   	pop    %ebx
  8048c4:	5d                   	pop    %ebp
  8048c5:	c3                   	ret    

008048c6 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8048c6:	55                   	push   %ebp
  8048c7:	89 e5                	mov    %esp,%ebp
  8048c9:	53                   	push   %ebx
  8048ca:	83 ec 14             	sub    $0x14,%esp
  8048cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8048d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8048d3:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8048d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8048dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8048df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8048e3:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8048ea:	e8 fd c5 ff ff       	call   800eec <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8048ef:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  8048f5:	b8 02 00 00 00       	mov    $0x2,%eax
  8048fa:	e8 35 ff ff ff       	call   804834 <_ZL5nsipcj>
}
  8048ff:	83 c4 14             	add    $0x14,%esp
  804902:	5b                   	pop    %ebx
  804903:	5d                   	pop    %ebp
  804904:	c3                   	ret    

00804905 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  804905:	55                   	push   %ebp
  804906:	89 e5                	mov    %esp,%ebp
  804908:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80490b:	8b 45 08             	mov    0x8(%ebp),%eax
  80490e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  804913:	8b 45 0c             	mov    0xc(%ebp),%eax
  804916:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  80491b:	b8 03 00 00 00       	mov    $0x3,%eax
  804920:	e8 0f ff ff ff       	call   804834 <_ZL5nsipcj>
}
  804925:	c9                   	leave  
  804926:	c3                   	ret    

00804927 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  804927:	55                   	push   %ebp
  804928:	89 e5                	mov    %esp,%ebp
  80492a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80492d:	8b 45 08             	mov    0x8(%ebp),%eax
  804930:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  804935:	b8 04 00 00 00       	mov    $0x4,%eax
  80493a:	e8 f5 fe ff ff       	call   804834 <_ZL5nsipcj>
}
  80493f:	c9                   	leave  
  804940:	c3                   	ret    

00804941 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804941:	55                   	push   %ebp
  804942:	89 e5                	mov    %esp,%ebp
  804944:	53                   	push   %ebx
  804945:	83 ec 14             	sub    $0x14,%esp
  804948:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80494b:	8b 45 08             	mov    0x8(%ebp),%eax
  80494e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804953:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80495a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80495e:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  804965:	e8 82 c5 ff ff       	call   800eec <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80496a:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  804970:	b8 05 00 00 00       	mov    $0x5,%eax
  804975:	e8 ba fe ff ff       	call   804834 <_ZL5nsipcj>
}
  80497a:	83 c4 14             	add    $0x14,%esp
  80497d:	5b                   	pop    %ebx
  80497e:	5d                   	pop    %ebp
  80497f:	c3                   	ret    

00804980 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  804980:	55                   	push   %ebp
  804981:	89 e5                	mov    %esp,%ebp
  804983:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  804986:	8b 45 08             	mov    0x8(%ebp),%eax
  804989:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  80498e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804991:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  804996:	b8 06 00 00 00       	mov    $0x6,%eax
  80499b:	e8 94 fe ff ff       	call   804834 <_ZL5nsipcj>
}
  8049a0:	c9                   	leave  
  8049a1:	c3                   	ret    

008049a2 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8049a2:	55                   	push   %ebp
  8049a3:	89 e5                	mov    %esp,%ebp
  8049a5:	56                   	push   %esi
  8049a6:	53                   	push   %ebx
  8049a7:	83 ec 10             	sub    $0x10,%esp
  8049aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8049ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8049b0:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  8049b5:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  8049bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8049be:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8049c3:	b8 07 00 00 00       	mov    $0x7,%eax
  8049c8:	e8 67 fe ff ff       	call   804834 <_ZL5nsipcj>
  8049cd:	89 c3                	mov    %eax,%ebx
  8049cf:	85 c0                	test   %eax,%eax
  8049d1:	78 46                	js     804a19 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  8049d3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8049d8:	7f 04                	jg     8049de <_Z10nsipc_recviPvij+0x3c>
  8049da:	39 f0                	cmp    %esi,%eax
  8049dc:	7e 24                	jle    804a02 <_Z10nsipc_recviPvij+0x60>
  8049de:	c7 44 24 0c 51 5c 80 	movl   $0x805c51,0xc(%esp)
  8049e5:	00 
  8049e6:	c7 44 24 08 76 55 80 	movl   $0x805576,0x8(%esp)
  8049ed:	00 
  8049ee:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8049f5:	00 
  8049f6:	c7 04 24 66 5c 80 00 	movl   $0x805c66,(%esp)
  8049fd:	e8 0e bc ff ff       	call   800610 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804a02:	89 44 24 08          	mov    %eax,0x8(%esp)
  804a06:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  804a0d:	00 
  804a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804a11:	89 04 24             	mov    %eax,(%esp)
  804a14:	e8 d3 c4 ff ff       	call   800eec <memmove>
	}

	return r;
}
  804a19:	89 d8                	mov    %ebx,%eax
  804a1b:	83 c4 10             	add    $0x10,%esp
  804a1e:	5b                   	pop    %ebx
  804a1f:	5e                   	pop    %esi
  804a20:	5d                   	pop    %ebp
  804a21:	c3                   	ret    

00804a22 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804a22:	55                   	push   %ebp
  804a23:	89 e5                	mov    %esp,%ebp
  804a25:	53                   	push   %ebx
  804a26:	83 ec 14             	sub    $0x14,%esp
  804a29:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  804a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  804a2f:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  804a34:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  804a3a:	7e 24                	jle    804a60 <_Z10nsipc_sendiPKvij+0x3e>
  804a3c:	c7 44 24 0c 72 5c 80 	movl   $0x805c72,0xc(%esp)
  804a43:	00 
  804a44:	c7 44 24 08 76 55 80 	movl   $0x805576,0x8(%esp)
  804a4b:	00 
  804a4c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  804a53:	00 
  804a54:	c7 04 24 66 5c 80 00 	movl   $0x805c66,(%esp)
  804a5b:	e8 b0 bb ff ff       	call   800610 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804a60:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  804a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  804a6b:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  804a72:	e8 75 c4 ff ff       	call   800eec <memmove>
	nsipcbuf.send.req_size = size;
  804a77:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  804a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  804a80:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  804a85:	b8 08 00 00 00       	mov    $0x8,%eax
  804a8a:	e8 a5 fd ff ff       	call   804834 <_ZL5nsipcj>
}
  804a8f:	83 c4 14             	add    $0x14,%esp
  804a92:	5b                   	pop    %ebx
  804a93:	5d                   	pop    %ebp
  804a94:	c3                   	ret    

00804a95 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804a95:	55                   	push   %ebp
  804a96:	89 e5                	mov    %esp,%ebp
  804a98:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  804a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  804a9e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  804aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  804aa6:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  804aab:	8b 45 10             	mov    0x10(%ebp),%eax
  804aae:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  804ab3:	b8 09 00 00 00       	mov    $0x9,%eax
  804ab8:	e8 77 fd ff ff       	call   804834 <_ZL5nsipcj>
}
  804abd:	c9                   	leave  
  804abe:	c3                   	ret    
	...

00804ac0 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  804ac0:	55                   	push   %ebp
  804ac1:	89 e5                	mov    %esp,%ebp
  804ac3:	56                   	push   %esi
  804ac4:	53                   	push   %ebx
  804ac5:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804ac8:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  804acd:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  804ad4:	85 c0                	test   %eax,%eax
  804ad6:	74 08                	je     804ae0 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  804ad8:	8d 55 08             	lea    0x8(%ebp),%edx
  804adb:	89 14 24             	mov    %edx,(%esp)
  804ade:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804ae0:	83 eb 01             	sub    $0x1,%ebx
  804ae3:	83 fb ff             	cmp    $0xffffffff,%ebx
  804ae6:	75 e5                	jne    804acd <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  804ae8:	8b 5d 38             	mov    0x38(%ebp),%ebx
  804aeb:	8b 75 08             	mov    0x8(%ebp),%esi
  804aee:	e8 d5 c6 ff ff       	call   8011c8 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  804af3:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  804af7:	89 74 24 10          	mov    %esi,0x10(%esp)
  804afb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804aff:	c7 44 24 08 80 5c 80 	movl   $0x805c80,0x8(%esp)
  804b06:	00 
  804b07:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  804b0e:	00 
  804b0f:	c7 04 24 04 5d 80 00 	movl   $0x805d04,(%esp)
  804b16:	e8 f5 ba ff ff       	call   800610 <_Z6_panicPKciS0_z>

00804b1b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  804b1b:	55                   	push   %ebp
  804b1c:	89 e5                	mov    %esp,%ebp
  804b1e:	56                   	push   %esi
  804b1f:	53                   	push   %ebx
  804b20:	83 ec 10             	sub    $0x10,%esp
  804b23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804b26:	e8 9d c6 ff ff       	call   8011c8 <_Z12sys_getenvidv>
  804b2b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  804b2d:	a1 00 70 80 00       	mov    0x807000,%eax
  804b32:	8b 40 5c             	mov    0x5c(%eax),%eax
  804b35:	85 c0                	test   %eax,%eax
  804b37:	75 4c                	jne    804b85 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  804b39:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  804b40:	00 
  804b41:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  804b48:	ee 
  804b49:	89 34 24             	mov    %esi,(%esp)
  804b4c:	e8 df c6 ff ff       	call   801230 <_Z14sys_page_allociPvi>
  804b51:	85 c0                	test   %eax,%eax
  804b53:	74 20                	je     804b75 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  804b55:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804b59:	c7 44 24 08 b8 5c 80 	movl   $0x805cb8,0x8(%esp)
  804b60:	00 
  804b61:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  804b68:	00 
  804b69:	c7 04 24 04 5d 80 00 	movl   $0x805d04,(%esp)
  804b70:	e8 9b ba ff ff       	call   800610 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  804b75:	c7 44 24 04 c0 4a 80 	movl   $0x804ac0,0x4(%esp)
  804b7c:	00 
  804b7d:	89 34 24             	mov    %esi,(%esp)
  804b80:	e8 e0 c8 ff ff       	call   801465 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804b85:	a1 00 90 80 00       	mov    0x809000,%eax
  804b8a:	39 d8                	cmp    %ebx,%eax
  804b8c:	74 1a                	je     804ba8 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  804b8e:	85 c0                	test   %eax,%eax
  804b90:	74 20                	je     804bb2 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804b92:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804b97:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  804b9e:	39 da                	cmp    %ebx,%edx
  804ba0:	74 15                	je     804bb7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804ba2:	85 d2                	test   %edx,%edx
  804ba4:	75 1f                	jne    804bc5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804ba6:	eb 0f                	jmp    804bb7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  804bad:	8d 76 00             	lea    0x0(%esi),%esi
  804bb0:	eb 05                	jmp    804bb7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804bb2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804bb7:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  804bbe:	83 c4 10             	add    $0x10,%esp
  804bc1:	5b                   	pop    %ebx
  804bc2:	5e                   	pop    %esi
  804bc3:	5d                   	pop    %ebp
  804bc4:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804bc5:	83 c0 01             	add    $0x1,%eax
  804bc8:	83 f8 08             	cmp    $0x8,%eax
  804bcb:	75 ca                	jne    804b97 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  804bcd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804bd1:	c7 44 24 08 dc 5c 80 	movl   $0x805cdc,0x8(%esp)
  804bd8:	00 
  804bd9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804be0:	00 
  804be1:	c7 04 24 04 5d 80 00 	movl   $0x805d04,(%esp)
  804be8:	e8 23 ba ff ff       	call   800610 <_Z6_panicPKciS0_z>
  804bed:	00 00                	add    %al,(%eax)
	...

00804bf0 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  804bf0:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  804bf3:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  804bf4:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  804bf7:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  804bfb:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  804bff:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  804c02:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  804c04:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  804c08:	61                   	popa   
    popf
  804c09:	9d                   	popf   
    popl %esp
  804c0a:	5c                   	pop    %esp
    ret
  804c0b:	c3                   	ret    

00804c0c <spin>:

spin:	jmp spin
  804c0c:	eb fe                	jmp    804c0c <spin>
	...

00804c10 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804c10:	55                   	push   %ebp
  804c11:	89 e5                	mov    %esp,%ebp
  804c13:	56                   	push   %esi
  804c14:	53                   	push   %ebx
  804c15:	83 ec 10             	sub    $0x10,%esp
  804c18:	8b 5d 08             	mov    0x8(%ebp),%ebx
  804c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  804c1e:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  804c21:	85 c0                	test   %eax,%eax
  804c23:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  804c28:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  804c2b:	89 04 24             	mov    %eax,(%esp)
  804c2e:	e8 c8 c8 ff ff       	call   8014fb <_Z12sys_ipc_recvPv>
  804c33:	85 c0                	test   %eax,%eax
  804c35:	79 16                	jns    804c4d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  804c37:	85 db                	test   %ebx,%ebx
  804c39:	74 06                	je     804c41 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  804c3b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  804c41:	85 f6                	test   %esi,%esi
  804c43:	74 53                	je     804c98 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  804c45:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  804c4b:	eb 4b                	jmp    804c98 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  804c4d:	85 db                	test   %ebx,%ebx
  804c4f:	74 17                	je     804c68 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  804c51:	e8 72 c5 ff ff       	call   8011c8 <_Z12sys_getenvidv>
  804c56:	25 ff 03 00 00       	and    $0x3ff,%eax
  804c5b:	6b c0 78             	imul   $0x78,%eax,%eax
  804c5e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  804c63:	8b 40 60             	mov    0x60(%eax),%eax
  804c66:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  804c68:	85 f6                	test   %esi,%esi
  804c6a:	74 17                	je     804c83 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  804c6c:	e8 57 c5 ff ff       	call   8011c8 <_Z12sys_getenvidv>
  804c71:	25 ff 03 00 00       	and    $0x3ff,%eax
  804c76:	6b c0 78             	imul   $0x78,%eax,%eax
  804c79:	05 00 00 00 ef       	add    $0xef000000,%eax
  804c7e:	8b 40 70             	mov    0x70(%eax),%eax
  804c81:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  804c83:	e8 40 c5 ff ff       	call   8011c8 <_Z12sys_getenvidv>
  804c88:	25 ff 03 00 00       	and    $0x3ff,%eax
  804c8d:	6b c0 78             	imul   $0x78,%eax,%eax
  804c90:	05 08 00 00 ef       	add    $0xef000008,%eax
  804c95:	8b 40 60             	mov    0x60(%eax),%eax

}
  804c98:	83 c4 10             	add    $0x10,%esp
  804c9b:	5b                   	pop    %ebx
  804c9c:	5e                   	pop    %esi
  804c9d:	5d                   	pop    %ebp
  804c9e:	c3                   	ret    

00804c9f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804c9f:	55                   	push   %ebp
  804ca0:	89 e5                	mov    %esp,%ebp
  804ca2:	57                   	push   %edi
  804ca3:	56                   	push   %esi
  804ca4:	53                   	push   %ebx
  804ca5:	83 ec 1c             	sub    $0x1c,%esp
  804ca8:	8b 75 08             	mov    0x8(%ebp),%esi
  804cab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804cae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  804cb1:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  804cb3:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  804cb8:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  804cbb:	8b 45 14             	mov    0x14(%ebp),%eax
  804cbe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804cc2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804cc6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  804cca:	89 34 24             	mov    %esi,(%esp)
  804ccd:	e8 f1 c7 ff ff       	call   8014c3 <_Z16sys_ipc_try_sendijPvi>
  804cd2:	85 c0                	test   %eax,%eax
  804cd4:	79 31                	jns    804d07 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  804cd6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  804cd9:	75 0c                	jne    804ce7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  804cdb:	90                   	nop
  804cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804ce0:	e8 17 c5 ff ff       	call   8011fc <_Z9sys_yieldv>
  804ce5:	eb d4                	jmp    804cbb <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  804ce7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804ceb:	c7 44 24 08 12 5d 80 	movl   $0x805d12,0x8(%esp)
  804cf2:	00 
  804cf3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  804cfa:	00 
  804cfb:	c7 04 24 1f 5d 80 00 	movl   $0x805d1f,(%esp)
  804d02:	e8 09 b9 ff ff       	call   800610 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  804d07:	83 c4 1c             	add    $0x1c,%esp
  804d0a:	5b                   	pop    %ebx
  804d0b:	5e                   	pop    %esi
  804d0c:	5f                   	pop    %edi
  804d0d:	5d                   	pop    %ebp
  804d0e:	c3                   	ret    
	...

00804d10 <__udivdi3>:
  804d10:	55                   	push   %ebp
  804d11:	89 e5                	mov    %esp,%ebp
  804d13:	57                   	push   %edi
  804d14:	56                   	push   %esi
  804d15:	83 ec 20             	sub    $0x20,%esp
  804d18:	8b 45 14             	mov    0x14(%ebp),%eax
  804d1b:	8b 75 08             	mov    0x8(%ebp),%esi
  804d1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804d21:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804d24:	85 c0                	test   %eax,%eax
  804d26:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804d29:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  804d2c:	75 3a                	jne    804d68 <__udivdi3+0x58>
  804d2e:	39 f9                	cmp    %edi,%ecx
  804d30:	77 66                	ja     804d98 <__udivdi3+0x88>
  804d32:	85 c9                	test   %ecx,%ecx
  804d34:	75 0b                	jne    804d41 <__udivdi3+0x31>
  804d36:	b8 01 00 00 00       	mov    $0x1,%eax
  804d3b:	31 d2                	xor    %edx,%edx
  804d3d:	f7 f1                	div    %ecx
  804d3f:	89 c1                	mov    %eax,%ecx
  804d41:	89 f8                	mov    %edi,%eax
  804d43:	31 d2                	xor    %edx,%edx
  804d45:	f7 f1                	div    %ecx
  804d47:	89 c7                	mov    %eax,%edi
  804d49:	89 f0                	mov    %esi,%eax
  804d4b:	f7 f1                	div    %ecx
  804d4d:	89 fa                	mov    %edi,%edx
  804d4f:	89 c6                	mov    %eax,%esi
  804d51:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804d54:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804d5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804d5d:	83 c4 20             	add    $0x20,%esp
  804d60:	5e                   	pop    %esi
  804d61:	5f                   	pop    %edi
  804d62:	5d                   	pop    %ebp
  804d63:	c3                   	ret    
  804d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804d68:	31 d2                	xor    %edx,%edx
  804d6a:	31 f6                	xor    %esi,%esi
  804d6c:	39 f8                	cmp    %edi,%eax
  804d6e:	77 e1                	ja     804d51 <__udivdi3+0x41>
  804d70:	0f bd d0             	bsr    %eax,%edx
  804d73:	83 f2 1f             	xor    $0x1f,%edx
  804d76:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804d79:	75 2d                	jne    804da8 <__udivdi3+0x98>
  804d7b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  804d7e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804d81:	76 06                	jbe    804d89 <__udivdi3+0x79>
  804d83:	39 f8                	cmp    %edi,%eax
  804d85:	89 f2                	mov    %esi,%edx
  804d87:	73 c8                	jae    804d51 <__udivdi3+0x41>
  804d89:	31 d2                	xor    %edx,%edx
  804d8b:	be 01 00 00 00       	mov    $0x1,%esi
  804d90:	eb bf                	jmp    804d51 <__udivdi3+0x41>
  804d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804d98:	89 f0                	mov    %esi,%eax
  804d9a:	89 fa                	mov    %edi,%edx
  804d9c:	f7 f1                	div    %ecx
  804d9e:	31 d2                	xor    %edx,%edx
  804da0:	89 c6                	mov    %eax,%esi
  804da2:	eb ad                	jmp    804d51 <__udivdi3+0x41>
  804da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804da8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804dac:	89 c2                	mov    %eax,%edx
  804dae:	b8 20 00 00 00       	mov    $0x20,%eax
  804db3:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804db6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804db9:	d3 e2                	shl    %cl,%edx
  804dbb:	89 c1                	mov    %eax,%ecx
  804dbd:	d3 ee                	shr    %cl,%esi
  804dbf:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804dc3:	09 d6                	or     %edx,%esi
  804dc5:	89 fa                	mov    %edi,%edx
  804dc7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  804dca:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804dcd:	d3 e6                	shl    %cl,%esi
  804dcf:	89 c1                	mov    %eax,%ecx
  804dd1:	d3 ea                	shr    %cl,%edx
  804dd3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804dd7:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804dda:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804ddd:	d3 e7                	shl    %cl,%edi
  804ddf:	89 c1                	mov    %eax,%ecx
  804de1:	d3 ee                	shr    %cl,%esi
  804de3:	09 fe                	or     %edi,%esi
  804de5:	89 f0                	mov    %esi,%eax
  804de7:	f7 75 e4             	divl   -0x1c(%ebp)
  804dea:	89 d7                	mov    %edx,%edi
  804dec:	89 c6                	mov    %eax,%esi
  804dee:	f7 65 f0             	mull   -0x10(%ebp)
  804df1:	39 d7                	cmp    %edx,%edi
  804df3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804df6:	72 12                	jb     804e0a <__udivdi3+0xfa>
  804df8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804dfb:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804dff:	d3 e2                	shl    %cl,%edx
  804e01:	39 c2                	cmp    %eax,%edx
  804e03:	73 08                	jae    804e0d <__udivdi3+0xfd>
  804e05:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804e08:	75 03                	jne    804e0d <__udivdi3+0xfd>
  804e0a:	83 ee 01             	sub    $0x1,%esi
  804e0d:	31 d2                	xor    %edx,%edx
  804e0f:	e9 3d ff ff ff       	jmp    804d51 <__udivdi3+0x41>
	...

00804e20 <__umoddi3>:
  804e20:	55                   	push   %ebp
  804e21:	89 e5                	mov    %esp,%ebp
  804e23:	57                   	push   %edi
  804e24:	56                   	push   %esi
  804e25:	83 ec 20             	sub    $0x20,%esp
  804e28:	8b 7d 14             	mov    0x14(%ebp),%edi
  804e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  804e2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804e31:	8b 75 0c             	mov    0xc(%ebp),%esi
  804e34:	85 ff                	test   %edi,%edi
  804e36:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804e39:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  804e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804e3f:	89 f2                	mov    %esi,%edx
  804e41:	75 15                	jne    804e58 <__umoddi3+0x38>
  804e43:	39 f1                	cmp    %esi,%ecx
  804e45:	76 41                	jbe    804e88 <__umoddi3+0x68>
  804e47:	f7 f1                	div    %ecx
  804e49:	89 d0                	mov    %edx,%eax
  804e4b:	31 d2                	xor    %edx,%edx
  804e4d:	83 c4 20             	add    $0x20,%esp
  804e50:	5e                   	pop    %esi
  804e51:	5f                   	pop    %edi
  804e52:	5d                   	pop    %ebp
  804e53:	c3                   	ret    
  804e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804e58:	39 f7                	cmp    %esi,%edi
  804e5a:	77 4c                	ja     804ea8 <__umoddi3+0x88>
  804e5c:	0f bd c7             	bsr    %edi,%eax
  804e5f:	83 f0 1f             	xor    $0x1f,%eax
  804e62:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804e65:	75 51                	jne    804eb8 <__umoddi3+0x98>
  804e67:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  804e6a:	0f 87 e8 00 00 00    	ja     804f58 <__umoddi3+0x138>
  804e70:	89 f2                	mov    %esi,%edx
  804e72:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804e75:	29 ce                	sub    %ecx,%esi
  804e77:	19 fa                	sbb    %edi,%edx
  804e79:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804e7f:	83 c4 20             	add    $0x20,%esp
  804e82:	5e                   	pop    %esi
  804e83:	5f                   	pop    %edi
  804e84:	5d                   	pop    %ebp
  804e85:	c3                   	ret    
  804e86:	66 90                	xchg   %ax,%ax
  804e88:	85 c9                	test   %ecx,%ecx
  804e8a:	75 0b                	jne    804e97 <__umoddi3+0x77>
  804e8c:	b8 01 00 00 00       	mov    $0x1,%eax
  804e91:	31 d2                	xor    %edx,%edx
  804e93:	f7 f1                	div    %ecx
  804e95:	89 c1                	mov    %eax,%ecx
  804e97:	89 f0                	mov    %esi,%eax
  804e99:	31 d2                	xor    %edx,%edx
  804e9b:	f7 f1                	div    %ecx
  804e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804ea0:	eb a5                	jmp    804e47 <__umoddi3+0x27>
  804ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804ea8:	89 f2                	mov    %esi,%edx
  804eaa:	83 c4 20             	add    $0x20,%esp
  804ead:	5e                   	pop    %esi
  804eae:	5f                   	pop    %edi
  804eaf:	5d                   	pop    %ebp
  804eb0:	c3                   	ret    
  804eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804eb8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804ebc:	89 f2                	mov    %esi,%edx
  804ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ec1:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804ec8:	29 45 f0             	sub    %eax,-0x10(%ebp)
  804ecb:	d3 e7                	shl    %cl,%edi
  804ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ed0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804ed4:	d3 e8                	shr    %cl,%eax
  804ed6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804eda:	09 f8                	or     %edi,%eax
  804edc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  804edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ee2:	d3 e0                	shl    %cl,%eax
  804ee4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804eee:	d3 ea                	shr    %cl,%edx
  804ef0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804ef4:	d3 e6                	shl    %cl,%esi
  804ef6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804efa:	d3 e8                	shr    %cl,%eax
  804efc:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804f00:	09 f0                	or     %esi,%eax
  804f02:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804f05:	f7 75 e4             	divl   -0x1c(%ebp)
  804f08:	d3 e6                	shl    %cl,%esi
  804f0a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804f0d:	89 d6                	mov    %edx,%esi
  804f0f:	f7 65 f4             	mull   -0xc(%ebp)
  804f12:	89 d7                	mov    %edx,%edi
  804f14:	89 c2                	mov    %eax,%edx
  804f16:	39 fe                	cmp    %edi,%esi
  804f18:	89 f9                	mov    %edi,%ecx
  804f1a:	72 30                	jb     804f4c <__umoddi3+0x12c>
  804f1c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  804f1f:	72 27                	jb     804f48 <__umoddi3+0x128>
  804f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804f24:	29 d0                	sub    %edx,%eax
  804f26:	19 ce                	sbb    %ecx,%esi
  804f28:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804f2c:	89 f2                	mov    %esi,%edx
  804f2e:	d3 e8                	shr    %cl,%eax
  804f30:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804f34:	d3 e2                	shl    %cl,%edx
  804f36:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804f3a:	09 d0                	or     %edx,%eax
  804f3c:	89 f2                	mov    %esi,%edx
  804f3e:	d3 ea                	shr    %cl,%edx
  804f40:	83 c4 20             	add    $0x20,%esp
  804f43:	5e                   	pop    %esi
  804f44:	5f                   	pop    %edi
  804f45:	5d                   	pop    %ebp
  804f46:	c3                   	ret    
  804f47:	90                   	nop
  804f48:	39 fe                	cmp    %edi,%esi
  804f4a:	75 d5                	jne    804f21 <__umoddi3+0x101>
  804f4c:	89 f9                	mov    %edi,%ecx
  804f4e:	89 c2                	mov    %eax,%edx
  804f50:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804f53:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804f56:	eb c9                	jmp    804f21 <__umoddi3+0x101>
  804f58:	39 f7                	cmp    %esi,%edi
  804f5a:	0f 82 10 ff ff ff    	jb     804e70 <__umoddi3+0x50>
  804f60:	e9 17 ff ff ff       	jmp    804e7c <__umoddi3+0x5c>
