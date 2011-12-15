
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 d3 02 00 00       	call   800304 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_Z5umainiPPc>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 10             	sub    $0x10,%esp
	envid_t ns_envid = sys_getenvid();
  80003c:	e8 f7 0e 00 00       	call   800f38 <_Z12sys_getenvidv>
  800041:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  800043:	c7 05 00 60 80 00 e0 	movl   $0x8045e0,0x806000
  80004a:	45 80 00 

	output_envid = fork();
  80004d:	e8 8b 15 00 00       	call   8015dd <_Z4forkv>
  800052:	a3 00 70 80 00       	mov    %eax,0x807000
	if (output_envid < 0)
  800057:	85 c0                	test   %eax,%eax
  800059:	79 1c                	jns    800077 <_Z5umainiPPc+0x43>
		panic("error forking");
  80005b:	c7 44 24 08 eb 45 80 	movl   $0x8045eb,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 f9 45 80 00 	movl   $0x8045f9,(%esp)
  800072:	e8 11 03 00 00       	call   800388 <_Z6_panicPKciS0_z>
	else if (output_envid == 0) {
  800077:	bb 00 00 00 00       	mov    $0x0,%ebx
  80007c:	85 c0                	test   %eax,%eax
  80007e:	75 0d                	jne    80008d <_Z5umainiPPc+0x59>
		output(ns_envid);
  800080:	89 34 24             	mov    %esi,(%esp)
  800083:	e8 2c 02 00 00       	call   8002b4 <_Z6outputi>
		return;
  800088:	e9 c9 00 00 00       	jmp    800156 <_Z5umainiPPc+0x122>
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80008d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800094:	00 
  800095:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80009c:	0f 
  80009d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a4:	e8 f7 0e 00 00       	call   800fa0 <_Z14sys_page_allociPvi>
  8000a9:	85 c0                	test   %eax,%eax
  8000ab:	79 20                	jns    8000cd <_Z5umainiPPc+0x99>
			panic("sys_page_alloc: %e", r);
  8000ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b1:	c7 44 24 08 0a 46 80 	movl   $0x80460a,0x8(%esp)
  8000b8:	00 
  8000b9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8000c0:	00 
  8000c1:	c7 04 24 f9 45 80 00 	movl   $0x8045f9,(%esp)
  8000c8:	e8 bb 02 00 00       	call   800388 <_Z6_panicPKciS0_z>
		pkt->jp_len = snprintf(pkt->jp_data,
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
  8000cd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000d1:	c7 44 24 08 1d 46 80 	movl   $0x80461d,0x8(%esp)
  8000d8:	00 
  8000d9:	c7 44 24 04 fc 0f 00 	movl   $0xffc,0x4(%esp)
  8000e0:	00 
  8000e1:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  8000e8:	e8 64 09 00 00       	call   800a51 <_Z8snprintfPciPKcz>
  8000ed:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
		cprintf("Transmitting packet %d\n", i);
  8000f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000f6:	c7 04 24 29 46 80 00 	movl   $0x804629,(%esp)
  8000fd:	e8 a4 03 00 00       	call   8004a6 <_Z7cprintfPKcz>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800102:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800109:	00 
  80010a:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  800111:	0f 
  800112:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800119:	00 
  80011a:	a1 00 70 80 00       	mov    0x807000,%eax
  80011f:	89 04 24             	mov    %eax,(%esp)
  800122:	e8 38 18 00 00       	call   80195f <_Z8ipc_sendijPvi>
		sys_page_unmap(0, pkt);
  800127:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80012e:	0f 
  80012f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800136:	e8 22 0f 00 00       	call   80105d <_Z14sys_page_unmapiPv>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80013b:	83 c3 01             	add    $0x1,%ebx
  80013e:	83 fb 0a             	cmp    $0xa,%ebx
  800141:	0f 85 46 ff ff ff    	jne    80008d <_Z5umainiPPc+0x59>
  800147:	b3 00                	mov    $0x0,%bl
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  800149:	e8 1e 0e 00 00       	call   800f6c <_Z9sys_yieldv>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  80014e:	83 c3 01             	add    $0x1,%ebx
  800151:	83 fb 14             	cmp    $0x14,%ebx
  800154:	75 f3                	jne    800149 <_Z5umainiPPc+0x115>
		sys_yield();
}
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5d                   	pop    %ebp
  80015c:	c3                   	ret    
  80015d:	00 00                	add    %al,(%eax)
	...

00800160 <_Z5timerij>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	57                   	push   %edi
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	83 ec 2c             	sub    $0x2c,%esp
  800169:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80016c:	e8 8d 11 00 00       	call   8012fe <_Z13sys_time_msecv>
  800171:	89 c3                	mov    %eax,%ebx
  800173:	03 5d 0c             	add    0xc(%ebp),%ebx

	binaryname = "ns_timer";
  800176:	c7 05 00 60 80 00 41 	movl   $0x804641,0x806000
  80017d:	46 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800180:	8d 7d e4             	lea    -0x1c(%ebp),%edi
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  800183:	e8 76 11 00 00       	call   8012fe <_Z13sys_time_msecv>
  800188:	39 c3                	cmp    %eax,%ebx
  80018a:	0f 86 8b 00 00 00    	jbe    80021b <_Z5timerij+0xbb>
  800190:	85 c0                	test   %eax,%eax
  800192:	78 07                	js     80019b <_Z5timerij+0x3b>
			sys_yield();
  800194:	e8 d3 0d 00 00       	call   800f6c <_Z9sys_yieldv>
  800199:	eb e8                	jmp    800183 <_Z5timerij+0x23>
		}
		if (r < 0)
			panic("sys_time_msec: %e", r);
  80019b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80019f:	c7 44 24 08 4a 46 80 	movl   $0x80464a,0x8(%esp)
  8001a6:	00 
  8001a7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8001ae:	00 
  8001af:	c7 04 24 5c 46 80 00 	movl   $0x80465c,(%esp)
  8001b6:	e8 cd 01 00 00       	call   800388 <_Z6_panicPKciS0_z>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8001bb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001c2:	00 
  8001c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001ca:	00 
  8001cb:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8001d2:	00 
  8001d3:	89 34 24             	mov    %esi,(%esp)
  8001d6:	e8 84 17 00 00       	call   80195f <_Z8ipc_sendijPvi>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8001db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001e2:	00 
  8001e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001ea:	00 
  8001eb:	89 3c 24             	mov    %edi,(%esp)
  8001ee:	e8 dd 16 00 00       	call   8018d0 <_Z8ipc_recvPiPvS_>
  8001f3:	89 c3                	mov    %eax,%ebx

			if (whom != (uint32_t)ns_envid) {
  8001f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f8:	39 c6                	cmp    %eax,%esi
  8001fa:	74 12                	je     80020e <_Z5timerij+0xae>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800200:	c7 04 24 68 46 80 00 	movl   $0x804668,(%esp)
  800207:	e8 9a 02 00 00       	call   8004a6 <_Z7cprintfPKcz>
		if (r < 0)
			panic("sys_time_msec: %e", r);

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
  80020c:	eb cd                	jmp    8001db <_Z5timerij+0x7b>
			if (whom != (uint32_t)ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  80020e:	e8 eb 10 00 00       	call   8012fe <_Z13sys_time_msecv>
  800213:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
  800216:	e9 68 ff ff ff       	jmp    800183 <_Z5timerij+0x23>

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
		}
		if (r < 0)
  80021b:	85 c0                	test   %eax,%eax
  80021d:	8d 76 00             	lea    0x0(%esi),%esi
  800220:	79 99                	jns    8001bb <_Z5timerij+0x5b>
  800222:	e9 74 ff ff ff       	jmp    80019b <_Z5timerij+0x3b>
	...

00800228 <_Z5inputi>:
#include <inc/mmu.h>
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	53                   	push   %ebx
  80022c:	83 ec 14             	sub    $0x14,%esp
  80022f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    binaryname = "ns_input";
  800232:	c7 05 00 60 80 00 a3 	movl   $0x8046a3,0x806000
  800239:	46 80 00 
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
    int len, r;
    while(1)
    {
        if((r = sys_page_alloc(0, &nsipcbuf, PTE_P|PTE_U|PTE_W)) < 0)
  80023c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800243:	00 
  800244:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80024b:	00 
  80024c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800253:	e8 48 0d 00 00       	call   800fa0 <_Z14sys_page_allociPvi>
  800258:	85 c0                	test   %eax,%eax
  80025a:	79 20                	jns    80027c <_Z5inputi+0x54>
            panic("sys_page_alloc: %e\n", r);
  80025c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800260:	c7 44 24 08 ac 46 80 	movl   $0x8046ac,0x8(%esp)
  800267:	00 
  800268:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
  80026f:	00 
  800270:	c7 04 24 c0 46 80 00 	movl   $0x8046c0,(%esp)
  800277:	e8 0c 01 00 00       	call   800388 <_Z6_panicPKciS0_z>
        len = sys_e1000_receive(&nsipcbuf.pkt.jp_data);
  80027c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  800283:	e8 e0 10 00 00       	call   801368 <_Z17sys_e1000_receivePv>
        if (len >= 0)
  800288:	85 c0                	test   %eax,%eax
  80028a:	78 b0                	js     80023c <_Z5inputi+0x14>
        {
            nsipcbuf.pkt.jp_len = len;
  80028c:	a3 00 80 80 00       	mov    %eax,0x808000
            ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_U|PTE_W);
  800291:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800298:	00 
  800299:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8002a0:	00 
  8002a1:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8002a8:	00 
  8002a9:	89 1c 24             	mov    %ebx,(%esp)
  8002ac:	e8 ae 16 00 00       	call   80195f <_Z8ipc_sendijPvi>
  8002b1:	eb 89                	jmp    80023c <_Z5inputi+0x14>
	...

008002b4 <_Z6outputi>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 20             	sub    $0x20,%esp
  8002bc:	8b 75 08             	mov    0x8(%ebp),%esi
	binaryname = "ns_output";
  8002bf:	c7 05 00 60 80 00 cc 	movl   $0x8046cc,0x806000
  8002c6:	46 80 00 
    // LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
    while(1)
    {
        ipc_recv(&envid, &nsipcbuf, 0);
  8002c9:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8002cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8002d3:	00 
  8002d4:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8002db:	00 
  8002dc:	89 1c 24             	mov    %ebx,(%esp)
  8002df:	e8 ec 15 00 00       	call   8018d0 <_Z8ipc_recvPiPvS_>
        if (envid != ns_envid)
  8002e4:	39 75 f4             	cmp    %esi,-0xc(%ebp)
  8002e7:	75 e3                	jne    8002cc <_Z6outputi+0x18>
            continue;
        while(sys_e1000_transmit(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len));
  8002e9:	a1 00 80 80 00       	mov    0x808000,%eax
  8002ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f2:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8002f9:	e8 34 10 00 00       	call   801332 <_Z18sys_e1000_transmitPvj>
  8002fe:	85 c0                	test   %eax,%eax
  800300:	75 e7                	jne    8002e9 <_Z6outputi+0x35>
  800302:	eb c8                	jmp    8002cc <_Z6outputi+0x18>

00800304 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	57                   	push   %edi
  800308:	56                   	push   %esi
  800309:	53                   	push   %ebx
  80030a:	83 ec 1c             	sub    $0x1c,%esp
  80030d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800310:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800313:	e8 20 0c 00 00       	call   800f38 <_Z12sys_getenvidv>
  800318:	25 ff 03 00 00       	and    $0x3ff,%eax
  80031d:	6b c0 78             	imul   $0x78,%eax,%eax
  800320:	05 00 00 00 ef       	add    $0xef000000,%eax
  800325:	a3 04 70 80 00       	mov    %eax,0x807004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032a:	85 ff                	test   %edi,%edi
  80032c:	7e 07                	jle    800335 <libmain+0x31>
		binaryname = argv[0];
  80032e:	8b 06                	mov    (%esi),%eax
  800330:	a3 00 60 80 00       	mov    %eax,0x806000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800335:	b8 7a 52 80 00       	mov    $0x80527a,%eax
  80033a:	3d 7a 52 80 00       	cmp    $0x80527a,%eax
  80033f:	76 0f                	jbe    800350 <libmain+0x4c>
  800341:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800343:	83 eb 04             	sub    $0x4,%ebx
  800346:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800348:	81 fb 7a 52 80 00    	cmp    $0x80527a,%ebx
  80034e:	77 f3                	ja     800343 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800350:	89 74 24 04          	mov    %esi,0x4(%esp)
  800354:	89 3c 24             	mov    %edi,(%esp)
  800357:	e8 d8 fc ff ff       	call   800034 <_Z5umainiPPc>

	// exit gracefully
	exit();
  80035c:	e8 0b 00 00 00       	call   80036c <_Z4exitv>
}
  800361:	83 c4 1c             	add    $0x1c,%esp
  800364:	5b                   	pop    %ebx
  800365:	5e                   	pop    %esi
  800366:	5f                   	pop    %edi
  800367:	5d                   	pop    %ebp
  800368:	c3                   	ret    
  800369:	00 00                	add    %al,(%eax)
	...

0080036c <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800372:	e8 17 19 00 00       	call   801c8e <_Z9close_allv>
	sys_env_destroy(0);
  800377:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80037e:	e8 58 0b 00 00       	call   800edb <_Z15sys_env_destroyi>
}
  800383:	c9                   	leave  
  800384:	c3                   	ret    
  800385:	00 00                	add    %al,(%eax)
	...

00800388 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	56                   	push   %esi
  80038c:	53                   	push   %ebx
  80038d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800390:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  800393:	a1 08 70 80 00       	mov    0x807008,%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	74 10                	je     8003ac <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  80039c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a0:	c7 04 24 e0 46 80 00 	movl   $0x8046e0,(%esp)
  8003a7:	e8 fa 00 00 00       	call   8004a6 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  8003ac:	8b 1d 00 60 80 00    	mov    0x806000,%ebx
  8003b2:	e8 81 0b 00 00       	call   800f38 <_Z12sys_getenvidv>
  8003b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ba:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003be:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003c5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cd:	c7 04 24 e8 46 80 00 	movl   $0x8046e8,(%esp)
  8003d4:	e8 cd 00 00 00       	call   8004a6 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8003d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e0:	89 04 24             	mov    %eax,(%esp)
  8003e3:	e8 5d 00 00 00       	call   800445 <_Z8vcprintfPKcPc>
	cprintf("\n");
  8003e8:	c7 04 24 3f 46 80 00 	movl   $0x80463f,(%esp)
  8003ef:	e8 b2 00 00 00       	call   8004a6 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003f4:	cc                   	int3   
  8003f5:	eb fd                	jmp    8003f4 <_Z6_panicPKciS0_z+0x6c>
	...

008003f8 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	83 ec 18             	sub    $0x18,%esp
  8003fe:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800401:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800404:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  800407:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800409:	8b 03                	mov    (%ebx),%eax
  80040b:	8b 55 08             	mov    0x8(%ebp),%edx
  80040e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800412:	83 c0 01             	add    $0x1,%eax
  800415:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800417:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041c:	75 19                	jne    800437 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  80041e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800425:	00 
  800426:	8d 43 08             	lea    0x8(%ebx),%eax
  800429:	89 04 24             	mov    %eax,(%esp)
  80042c:	e8 43 0a 00 00       	call   800e74 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800431:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800437:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80043b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80043e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800441:	89 ec                	mov    %ebp,%esp
  800443:	5d                   	pop    %ebp
  800444:	c3                   	ret    

00800445 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80044e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800455:	00 00 00 
	b.cnt = 0;
  800458:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80045f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800462:	8b 45 0c             	mov    0xc(%ebp),%eax
  800465:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800470:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800476:	89 44 24 04          	mov    %eax,0x4(%esp)
  80047a:	c7 04 24 f8 03 80 00 	movl   $0x8003f8,(%esp)
  800481:	e8 a1 01 00 00       	call   800627 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800486:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80048c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800490:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800496:	89 04 24             	mov    %eax,(%esp)
  800499:	e8 d6 09 00 00       	call   800e74 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  80049e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004ac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	89 04 24             	mov    %eax,(%esp)
  8004b9:	e8 87 ff ff ff       	call   800445 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	57                   	push   %edi
  8004c4:	56                   	push   %esi
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 4c             	sub    $0x4c,%esp
  8004c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004cc:	89 d6                	mov    %edx,%esi
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004dd:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e5:	39 d0                	cmp    %edx,%eax
  8004e7:	72 11                	jb     8004fa <_ZL8printnumPFviPvES_yjii+0x3a>
  8004e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ec:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  8004ef:	76 09                	jbe    8004fa <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004f1:	83 eb 01             	sub    $0x1,%ebx
  8004f4:	85 db                	test   %ebx,%ebx
  8004f6:	7f 5d                	jg     800555 <_ZL8printnumPFviPvES_yjii+0x95>
  8004f8:	eb 6c                	jmp    800566 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004fa:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004fe:	83 eb 01             	sub    $0x1,%ebx
  800501:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800505:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800508:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80050c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800510:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800514:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800517:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80051a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800521:	00 
  800522:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800525:	89 14 24             	mov    %edx,(%esp)
  800528:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80052b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80052f:	e8 4c 3e 00 00       	call   804380 <__udivdi3>
  800534:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800537:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80053a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80053e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800542:	89 04 24             	mov    %eax,(%esp)
  800545:	89 54 24 04          	mov    %edx,0x4(%esp)
  800549:	89 f2                	mov    %esi,%edx
  80054b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80054e:	e8 6d ff ff ff       	call   8004c0 <_ZL8printnumPFviPvES_yjii>
  800553:	eb 11                	jmp    800566 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800555:	89 74 24 04          	mov    %esi,0x4(%esp)
  800559:	89 3c 24             	mov    %edi,(%esp)
  80055c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80055f:	83 eb 01             	sub    $0x1,%ebx
  800562:	85 db                	test   %ebx,%ebx
  800564:	7f ef                	jg     800555 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800566:	89 74 24 04          	mov    %esi,0x4(%esp)
  80056a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80056e:	8b 45 10             	mov    0x10(%ebp),%eax
  800571:	89 44 24 08          	mov    %eax,0x8(%esp)
  800575:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80057c:	00 
  80057d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800580:	89 14 24             	mov    %edx,(%esp)
  800583:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800586:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80058a:	e8 01 3f 00 00       	call   804490 <__umoddi3>
  80058f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800593:	0f be 80 0b 47 80 00 	movsbl 0x80470b(%eax),%eax
  80059a:	89 04 24             	mov    %eax,(%esp)
  80059d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8005a0:	83 c4 4c             	add    $0x4c,%esp
  8005a3:	5b                   	pop    %ebx
  8005a4:	5e                   	pop    %esi
  8005a5:	5f                   	pop    %edi
  8005a6:	5d                   	pop    %ebp
  8005a7:	c3                   	ret    

008005a8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005a8:	55                   	push   %ebp
  8005a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ab:	83 fa 01             	cmp    $0x1,%edx
  8005ae:	7e 0e                	jle    8005be <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  8005b0:	8b 10                	mov    (%eax),%edx
  8005b2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005b5:	89 08                	mov    %ecx,(%eax)
  8005b7:	8b 02                	mov    (%edx),%eax
  8005b9:	8b 52 04             	mov    0x4(%edx),%edx
  8005bc:	eb 22                	jmp    8005e0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  8005be:	85 d2                	test   %edx,%edx
  8005c0:	74 10                	je     8005d2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  8005c2:	8b 10                	mov    (%eax),%edx
  8005c4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005c7:	89 08                	mov    %ecx,(%eax)
  8005c9:	8b 02                	mov    (%edx),%eax
  8005cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d0:	eb 0e                	jmp    8005e0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005d2:	8b 10                	mov    (%eax),%edx
  8005d4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005d7:	89 08                	mov    %ecx,(%eax)
  8005d9:	8b 02                	mov    (%edx),%eax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8005e8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005ec:	8b 10                	mov    (%eax),%edx
  8005ee:	3b 50 04             	cmp    0x4(%eax),%edx
  8005f1:	73 0a                	jae    8005fd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8005f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005f6:	88 0a                	mov    %cl,(%edx)
  8005f8:	83 c2 01             	add    $0x1,%edx
  8005fb:	89 10                	mov    %edx,(%eax)
}
  8005fd:	5d                   	pop    %ebp
  8005fe:	c3                   	ret    

008005ff <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005ff:	55                   	push   %ebp
  800600:	89 e5                	mov    %esp,%ebp
  800602:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800605:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800608:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80060c:	8b 45 10             	mov    0x10(%ebp),%eax
  80060f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800613:	8b 45 0c             	mov    0xc(%ebp),%eax
  800616:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	89 04 24             	mov    %eax,(%esp)
  800620:	e8 02 00 00 00       	call   800627 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800625:	c9                   	leave  
  800626:	c3                   	ret    

00800627 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800627:	55                   	push   %ebp
  800628:	89 e5                	mov    %esp,%ebp
  80062a:	57                   	push   %edi
  80062b:	56                   	push   %esi
  80062c:	53                   	push   %ebx
  80062d:	83 ec 3c             	sub    $0x3c,%esp
  800630:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800633:	8b 55 10             	mov    0x10(%ebp),%edx
  800636:	0f b6 02             	movzbl (%edx),%eax
  800639:	89 d3                	mov    %edx,%ebx
  80063b:	83 c3 01             	add    $0x1,%ebx
  80063e:	83 f8 25             	cmp    $0x25,%eax
  800641:	74 2b                	je     80066e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800643:	85 c0                	test   %eax,%eax
  800645:	75 10                	jne    800657 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800647:	e9 a5 03 00 00       	jmp    8009f1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80064c:	85 c0                	test   %eax,%eax
  80064e:	66 90                	xchg   %ax,%ax
  800650:	75 08                	jne    80065a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800652:	e9 9a 03 00 00       	jmp    8009f1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800657:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80065a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80065e:	89 04 24             	mov    %eax,(%esp)
  800661:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800663:	0f b6 03             	movzbl (%ebx),%eax
  800666:	83 c3 01             	add    $0x1,%ebx
  800669:	83 f8 25             	cmp    $0x25,%eax
  80066c:	75 de                	jne    80064c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80066e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800672:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800679:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80067e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800685:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80068d:	eb 2b                	jmp    8006ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800692:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800696:	eb 22                	jmp    8006ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800698:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80069b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80069f:	eb 19                	jmp    8006ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8006a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006ab:	eb 0d                	jmp    8006ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8006ad:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8006b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ba:	0f b6 03             	movzbl (%ebx),%eax
  8006bd:	0f b6 d0             	movzbl %al,%edx
  8006c0:	8d 73 01             	lea    0x1(%ebx),%esi
  8006c3:	89 75 10             	mov    %esi,0x10(%ebp)
  8006c6:	83 e8 23             	sub    $0x23,%eax
  8006c9:	3c 55                	cmp    $0x55,%al
  8006cb:	0f 87 d8 02 00 00    	ja     8009a9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  8006d1:	0f b6 c0             	movzbl %al,%eax
  8006d4:	ff 24 85 a0 48 80 00 	jmp    *0x8048a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006db:	83 ea 30             	sub    $0x30,%edx
  8006de:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8006e1:	8b 55 10             	mov    0x10(%ebp),%edx
  8006e4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8006e7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8006ed:	83 fa 09             	cmp    $0x9,%edx
  8006f0:	77 4e                	ja     800740 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8006f8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8006fb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8006ff:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800702:	8d 50 d0             	lea    -0x30(%eax),%edx
  800705:	83 fa 09             	cmp    $0x9,%edx
  800708:	76 eb                	jbe    8006f5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  80070a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80070d:	eb 31                	jmp    800740 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8d 50 04             	lea    0x4(%eax),%edx
  800715:	89 55 14             	mov    %edx,0x14(%ebp)
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800720:	eb 1e                	jmp    800740 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800726:	0f 88 75 ff ff ff    	js     8006a1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80072f:	eb 89                	jmp    8006ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800731:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800734:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80073b:	e9 7a ff ff ff       	jmp    8006ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800740:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800744:	0f 89 70 ff ff ff    	jns    8006ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  80074a:	e9 5e ff ff ff       	jmp    8006ad <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80074f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800752:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800755:	e9 60 ff ff ff       	jmp    8006ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 50 04             	lea    0x4(%eax),%edx
  800760:	89 55 14             	mov    %edx,0x14(%ebp)
  800763:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800767:	8b 00                	mov    (%eax),%eax
  800769:	89 04 24             	mov    %eax,(%esp)
  80076c:	ff 55 08             	call   *0x8(%ebp)
			break;
  80076f:	e9 bf fe ff ff       	jmp    800633 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 50 04             	lea    0x4(%eax),%edx
  80077a:	89 55 14             	mov    %edx,0x14(%ebp)
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	89 c2                	mov    %eax,%edx
  800781:	c1 fa 1f             	sar    $0x1f,%edx
  800784:	31 d0                	xor    %edx,%eax
  800786:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800788:	83 f8 14             	cmp    $0x14,%eax
  80078b:	7f 0f                	jg     80079c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  80078d:	8b 14 85 00 4a 80 00 	mov    0x804a00(,%eax,4),%edx
  800794:	85 d2                	test   %edx,%edx
  800796:	0f 85 35 02 00 00    	jne    8009d1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  80079c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007a0:	c7 44 24 08 23 47 80 	movl   $0x804723,0x8(%esp)
  8007a7:	00 
  8007a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8007af:	89 34 24             	mov    %esi,(%esp)
  8007b2:	e8 48 fe ff ff       	call   8005ff <_Z8printfmtPFviPvES_PKcz>
  8007b7:	e9 77 fe ff ff       	jmp    800633 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  8007bc:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8d 50 04             	lea    0x4(%eax),%edx
  8007cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ce:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  8007d0:	85 db                	test   %ebx,%ebx
  8007d2:	ba 1c 47 80 00       	mov    $0x80471c,%edx
  8007d7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  8007da:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007de:	7e 72                	jle    800852 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  8007e0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  8007e4:	74 6c                	je     800852 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ea:	89 1c 24             	mov    %ebx,(%esp)
  8007ed:	e8 a9 02 00 00       	call   800a9b <_Z7strnlenPKcj>
  8007f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007f5:	29 c2                	sub    %eax,%edx
  8007f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007fa:	85 d2                	test   %edx,%edx
  8007fc:	7e 54                	jle    800852 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  8007fe:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800802:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800805:	89 d3                	mov    %edx,%ebx
  800807:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80080a:	89 c6                	mov    %eax,%esi
  80080c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800810:	89 34 24             	mov    %esi,(%esp)
  800813:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800816:	83 eb 01             	sub    $0x1,%ebx
  800819:	85 db                	test   %ebx,%ebx
  80081b:	7f ef                	jg     80080c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  80081d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800820:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800823:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80082a:	eb 26                	jmp    800852 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  80082c:	8d 50 e0             	lea    -0x20(%eax),%edx
  80082f:	83 fa 5e             	cmp    $0x5e,%edx
  800832:	76 10                	jbe    800844 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800834:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800838:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80083f:	ff 55 08             	call   *0x8(%ebp)
  800842:	eb 0a                	jmp    80084e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800844:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800848:	89 04 24             	mov    %eax,(%esp)
  80084b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800852:	0f be 03             	movsbl (%ebx),%eax
  800855:	83 c3 01             	add    $0x1,%ebx
  800858:	85 c0                	test   %eax,%eax
  80085a:	74 11                	je     80086d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  80085c:	85 f6                	test   %esi,%esi
  80085e:	78 05                	js     800865 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800860:	83 ee 01             	sub    $0x1,%esi
  800863:	78 0d                	js     800872 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800865:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800869:	75 c1                	jne    80082c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  80086b:	eb d7                	jmp    800844 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80086d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800870:	eb 03                	jmp    800875 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800875:	85 c0                	test   %eax,%eax
  800877:	0f 8e b6 fd ff ff    	jle    800633 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  80087d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800880:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800883:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800887:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80088e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800890:	83 eb 01             	sub    $0x1,%ebx
  800893:	85 db                	test   %ebx,%ebx
  800895:	7f ec                	jg     800883 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800897:	e9 97 fd ff ff       	jmp    800633 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80089c:	83 f9 01             	cmp    $0x1,%ecx
  80089f:	90                   	nop
  8008a0:	7e 10                	jle    8008b2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8d 50 08             	lea    0x8(%eax),%edx
  8008a8:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ab:	8b 18                	mov    (%eax),%ebx
  8008ad:	8b 70 04             	mov    0x4(%eax),%esi
  8008b0:	eb 26                	jmp    8008d8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  8008b2:	85 c9                	test   %ecx,%ecx
  8008b4:	74 12                	je     8008c8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	8d 50 04             	lea    0x4(%eax),%edx
  8008bc:	89 55 14             	mov    %edx,0x14(%ebp)
  8008bf:	8b 18                	mov    (%eax),%ebx
  8008c1:	89 de                	mov    %ebx,%esi
  8008c3:	c1 fe 1f             	sar    $0x1f,%esi
  8008c6:	eb 10                	jmp    8008d8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	8d 50 04             	lea    0x4(%eax),%edx
  8008ce:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d1:	8b 18                	mov    (%eax),%ebx
  8008d3:	89 de                	mov    %ebx,%esi
  8008d5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008d8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008dd:	85 f6                	test   %esi,%esi
  8008df:	0f 89 8c 00 00 00    	jns    800971 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  8008e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008e9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008f0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008f3:	f7 db                	neg    %ebx
  8008f5:	83 d6 00             	adc    $0x0,%esi
  8008f8:	f7 de                	neg    %esi
			}
			base = 10;
  8008fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ff:	eb 70                	jmp    800971 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800901:	89 ca                	mov    %ecx,%edx
  800903:	8d 45 14             	lea    0x14(%ebp),%eax
  800906:	e8 9d fc ff ff       	call   8005a8 <_ZL7getuintPPci>
  80090b:	89 c3                	mov    %eax,%ebx
  80090d:	89 d6                	mov    %edx,%esi
			base = 10;
  80090f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800914:	eb 5b                	jmp    800971 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800916:	89 ca                	mov    %ecx,%edx
  800918:	8d 45 14             	lea    0x14(%ebp),%eax
  80091b:	e8 88 fc ff ff       	call   8005a8 <_ZL7getuintPPci>
  800920:	89 c3                	mov    %eax,%ebx
  800922:	89 d6                	mov    %edx,%esi
			base = 8;
  800924:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800929:	eb 46                	jmp    800971 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  80092b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80092f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800936:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800939:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80093d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800944:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8d 50 04             	lea    0x4(%eax),%edx
  80094d:	89 55 14             	mov    %edx,0x14(%ebp)
  800950:	8b 18                	mov    (%eax),%ebx
  800952:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800957:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  80095c:	eb 13                	jmp    800971 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80095e:	89 ca                	mov    %ecx,%edx
  800960:	8d 45 14             	lea    0x14(%ebp),%eax
  800963:	e8 40 fc ff ff       	call   8005a8 <_ZL7getuintPPci>
  800968:	89 c3                	mov    %eax,%ebx
  80096a:	89 d6                	mov    %edx,%esi
			base = 16;
  80096c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800971:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800975:	89 54 24 10          	mov    %edx,0x10(%esp)
  800979:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800980:	89 44 24 08          	mov    %eax,0x8(%esp)
  800984:	89 1c 24             	mov    %ebx,(%esp)
  800987:	89 74 24 04          	mov    %esi,0x4(%esp)
  80098b:	89 fa                	mov    %edi,%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	e8 2b fb ff ff       	call   8004c0 <_ZL8printnumPFviPvES_yjii>
			break;
  800995:	e9 99 fc ff ff       	jmp    800633 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80099a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80099e:	89 14 24             	mov    %edx,(%esp)
  8009a1:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009a4:	e9 8a fc ff ff       	jmp    800633 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ad:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009b4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009ba:	89 d8                	mov    %ebx,%eax
  8009bc:	eb 02                	jmp    8009c0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  8009be:	89 d0                	mov    %edx,%eax
  8009c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009c3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009c7:	75 f5                	jne    8009be <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  8009c9:	89 45 10             	mov    %eax,0x10(%ebp)
  8009cc:	e9 62 fc ff ff       	jmp    800633 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009d5:	c7 44 24 08 2d 4b 80 	movl   $0x804b2d,0x8(%esp)
  8009dc:	00 
  8009dd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e4:	89 34 24             	mov    %esi,(%esp)
  8009e7:	e8 13 fc ff ff       	call   8005ff <_Z8printfmtPFviPvES_PKcz>
  8009ec:	e9 42 fc ff ff       	jmp    800633 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f1:	83 c4 3c             	add    $0x3c,%esp
  8009f4:	5b                   	pop    %ebx
  8009f5:	5e                   	pop    %esi
  8009f6:	5f                   	pop    %edi
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	83 ec 28             	sub    $0x28,%esp
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800a0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a0f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a13:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800a16:	85 c0                	test   %eax,%eax
  800a18:	74 30                	je     800a4a <_Z9vsnprintfPciPKcS_+0x51>
  800a1a:	85 d2                	test   %edx,%edx
  800a1c:	7e 2c                	jle    800a4a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  800a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a21:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a25:	8b 45 10             	mov    0x10(%ebp),%eax
  800a28:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a2c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a33:	c7 04 24 e2 05 80 00 	movl   $0x8005e2,(%esp)
  800a3a:	e8 e8 fb ff ff       	call   800627 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  800a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a42:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a48:	eb 05                	jmp    800a4f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a4f:	c9                   	leave  
  800a50:	c3                   	ret    

00800a51 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	89 04 24             	mov    %eax,(%esp)
  800a72:	e8 82 ff ff ff       	call   8009f9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    
  800a79:	00 00                	add    %al,(%eax)
  800a7b:	00 00                	add    %al,(%eax)
  800a7d:	00 00                	add    %al,(%eax)
	...

00800a80 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	80 3a 00             	cmpb   $0x0,(%edx)
  800a8e:	74 09                	je     800a99 <_Z6strlenPKc+0x19>
		n++;
  800a90:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a97:	75 f7                	jne    800a90 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa9:	39 c2                	cmp    %eax,%edx
  800aab:	74 0b                	je     800ab8 <_Z7strnlenPKcj+0x1d>
  800aad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ab1:	74 05                	je     800ab8 <_Z7strnlenPKcj+0x1d>
		n++;
  800ab3:	83 c0 01             	add    $0x1,%eax
  800ab6:	eb f1                	jmp    800aa9 <_Z7strnlenPKcj+0xe>
	return n;
}
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	53                   	push   %ebx
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800acd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ad0:	83 c2 01             	add    $0x1,%edx
  800ad3:	84 c9                	test   %cl,%cl
  800ad5:	75 f2                	jne    800ac9 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800ad7:	5b                   	pop    %ebx
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	56                   	push   %esi
  800ade:	53                   	push   %ebx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800ae8:	85 f6                	test   %esi,%esi
  800aea:	74 18                	je     800b04 <_Z7strncpyPcPKcj+0x2a>
  800aec:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800af1:	0f b6 1a             	movzbl (%edx),%ebx
  800af4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800af7:	80 3a 01             	cmpb   $0x1,(%edx)
  800afa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800afd:	83 c1 01             	add    $0x1,%ecx
  800b00:	39 ce                	cmp    %ecx,%esi
  800b02:	77 ed                	ja     800af1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b13:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800b16:	89 f0                	mov    %esi,%eax
  800b18:	85 d2                	test   %edx,%edx
  800b1a:	74 17                	je     800b33 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800b1c:	83 ea 01             	sub    $0x1,%edx
  800b1f:	74 18                	je     800b39 <_Z7strlcpyPcPKcj+0x31>
  800b21:	80 39 00             	cmpb   $0x0,(%ecx)
  800b24:	74 17                	je     800b3d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800b26:	0f b6 19             	movzbl (%ecx),%ebx
  800b29:	88 18                	mov    %bl,(%eax)
  800b2b:	83 c0 01             	add    $0x1,%eax
  800b2e:	83 c1 01             	add    $0x1,%ecx
  800b31:	eb e9                	jmp    800b1c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800b33:	29 f0                	sub    %esi,%eax
}
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b39:	89 c2                	mov    %eax,%edx
  800b3b:	eb 02                	jmp    800b3f <_Z7strlcpyPcPKcj+0x37>
  800b3d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b3f:	c6 02 00             	movb   $0x0,(%edx)
  800b42:	eb ef                	jmp    800b33 <_Z7strlcpyPcPKcj+0x2b>

00800b44 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b4d:	0f b6 01             	movzbl (%ecx),%eax
  800b50:	84 c0                	test   %al,%al
  800b52:	74 0c                	je     800b60 <_Z6strcmpPKcS0_+0x1c>
  800b54:	3a 02                	cmp    (%edx),%al
  800b56:	75 08                	jne    800b60 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800b58:	83 c1 01             	add    $0x1,%ecx
  800b5b:	83 c2 01             	add    $0x1,%edx
  800b5e:	eb ed                	jmp    800b4d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800b60:	0f b6 c0             	movzbl %al,%eax
  800b63:	0f b6 12             	movzbl (%edx),%edx
  800b66:	29 d0                	sub    %edx,%eax
}
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	53                   	push   %ebx
  800b6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b74:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800b77:	85 d2                	test   %edx,%edx
  800b79:	74 16                	je     800b91 <_Z7strncmpPKcS0_j+0x27>
  800b7b:	0f b6 01             	movzbl (%ecx),%eax
  800b7e:	84 c0                	test   %al,%al
  800b80:	74 17                	je     800b99 <_Z7strncmpPKcS0_j+0x2f>
  800b82:	3a 03                	cmp    (%ebx),%al
  800b84:	75 13                	jne    800b99 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800b86:	83 ea 01             	sub    $0x1,%edx
  800b89:	83 c1 01             	add    $0x1,%ecx
  800b8c:	83 c3 01             	add    $0x1,%ebx
  800b8f:	eb e6                	jmp    800b77 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800b96:	5b                   	pop    %ebx
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800b99:	0f b6 01             	movzbl (%ecx),%eax
  800b9c:	0f b6 13             	movzbl (%ebx),%edx
  800b9f:	29 d0                	sub    %edx,%eax
  800ba1:	eb f3                	jmp    800b96 <_Z7strncmpPKcS0_j+0x2c>

00800ba3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bad:	0f b6 10             	movzbl (%eax),%edx
  800bb0:	84 d2                	test   %dl,%dl
  800bb2:	74 1f                	je     800bd3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800bb4:	38 ca                	cmp    %cl,%dl
  800bb6:	75 0a                	jne    800bc2 <_Z6strchrPKcc+0x1f>
  800bb8:	eb 1e                	jmp    800bd8 <_Z6strchrPKcc+0x35>
  800bba:	38 ca                	cmp    %cl,%dl
  800bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800bc0:	74 16                	je     800bd8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bc2:	83 c0 01             	add    $0x1,%eax
  800bc5:	0f b6 10             	movzbl (%eax),%edx
  800bc8:	84 d2                	test   %dl,%dl
  800bca:	75 ee                	jne    800bba <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd1:	eb 05                	jmp    800bd8 <_Z6strchrPKcc+0x35>
  800bd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be4:	0f b6 10             	movzbl (%eax),%edx
  800be7:	84 d2                	test   %dl,%dl
  800be9:	74 14                	je     800bff <_Z7strfindPKcc+0x25>
		if (*s == c)
  800beb:	38 ca                	cmp    %cl,%dl
  800bed:	75 06                	jne    800bf5 <_Z7strfindPKcc+0x1b>
  800bef:	eb 0e                	jmp    800bff <_Z7strfindPKcc+0x25>
  800bf1:	38 ca                	cmp    %cl,%dl
  800bf3:	74 0a                	je     800bff <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bf5:	83 c0 01             	add    $0x1,%eax
  800bf8:	0f b6 10             	movzbl (%eax),%edx
  800bfb:	84 d2                	test   %dl,%dl
  800bfd:	75 f2                	jne    800bf1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    

00800c01 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	83 ec 0c             	sub    $0xc,%esp
  800c07:	89 1c 24             	mov    %ebx,(%esp)
  800c0a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c12:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c18:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800c1b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c21:	75 25                	jne    800c48 <memset+0x47>
  800c23:	f6 c1 03             	test   $0x3,%cl
  800c26:	75 20                	jne    800c48 <memset+0x47>
		c &= 0xFF;
  800c28:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c2b:	89 d3                	mov    %edx,%ebx
  800c2d:	c1 e3 08             	shl    $0x8,%ebx
  800c30:	89 d6                	mov    %edx,%esi
  800c32:	c1 e6 18             	shl    $0x18,%esi
  800c35:	89 d0                	mov    %edx,%eax
  800c37:	c1 e0 10             	shl    $0x10,%eax
  800c3a:	09 f0                	or     %esi,%eax
  800c3c:	09 d0                	or     %edx,%eax
  800c3e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800c40:	c1 e9 02             	shr    $0x2,%ecx
  800c43:	fc                   	cld    
  800c44:	f3 ab                	rep stos %eax,%es:(%edi)
  800c46:	eb 03                	jmp    800c4b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800c48:	fc                   	cld    
  800c49:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800c4b:	89 f8                	mov    %edi,%eax
  800c4d:	8b 1c 24             	mov    (%esp),%ebx
  800c50:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c54:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c58:	89 ec                	mov    %ebp,%esp
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	89 34 24             	mov    %esi,(%esp)
  800c65:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800c72:	39 c6                	cmp    %eax,%esi
  800c74:	73 36                	jae    800cac <memmove+0x50>
  800c76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c79:	39 d0                	cmp    %edx,%eax
  800c7b:	73 2f                	jae    800cac <memmove+0x50>
		s += n;
		d += n;
  800c7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800c80:	f6 c2 03             	test   $0x3,%dl
  800c83:	75 1b                	jne    800ca0 <memmove+0x44>
  800c85:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c8b:	75 13                	jne    800ca0 <memmove+0x44>
  800c8d:	f6 c1 03             	test   $0x3,%cl
  800c90:	75 0e                	jne    800ca0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c92:	83 ef 04             	sub    $0x4,%edi
  800c95:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c98:	c1 e9 02             	shr    $0x2,%ecx
  800c9b:	fd                   	std    
  800c9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c9e:	eb 09                	jmp    800ca9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ca0:	83 ef 01             	sub    $0x1,%edi
  800ca3:	8d 72 ff             	lea    -0x1(%edx),%esi
  800ca6:	fd                   	std    
  800ca7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ca9:	fc                   	cld    
  800caa:	eb 20                	jmp    800ccc <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800cac:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cb2:	75 13                	jne    800cc7 <memmove+0x6b>
  800cb4:	a8 03                	test   $0x3,%al
  800cb6:	75 0f                	jne    800cc7 <memmove+0x6b>
  800cb8:	f6 c1 03             	test   $0x3,%cl
  800cbb:	75 0a                	jne    800cc7 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cbd:	c1 e9 02             	shr    $0x2,%ecx
  800cc0:	89 c7                	mov    %eax,%edi
  800cc2:	fc                   	cld    
  800cc3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc5:	eb 05                	jmp    800ccc <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800cc7:	89 c7                	mov    %eax,%edi
  800cc9:	fc                   	cld    
  800cca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800ccc:	8b 34 24             	mov    (%esp),%esi
  800ccf:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800cd3:	89 ec                	mov    %ebp,%esp
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 08             	sub    $0x8,%esp
  800cdd:	89 34 24             	mov    %esi,(%esp)
  800ce0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cea:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800ced:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cf3:	75 13                	jne    800d08 <memcpy+0x31>
  800cf5:	a8 03                	test   $0x3,%al
  800cf7:	75 0f                	jne    800d08 <memcpy+0x31>
  800cf9:	f6 c1 03             	test   $0x3,%cl
  800cfc:	75 0a                	jne    800d08 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cfe:	c1 e9 02             	shr    $0x2,%ecx
  800d01:	89 c7                	mov    %eax,%edi
  800d03:	fc                   	cld    
  800d04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d06:	eb 05                	jmp    800d0d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800d08:	89 c7                	mov    %eax,%edi
  800d0a:	fc                   	cld    
  800d0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  800d0d:	8b 34 24             	mov    (%esp),%esi
  800d10:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d14:	89 ec                	mov    %ebp,%esp
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
  800d1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d21:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d24:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d2c:	85 ff                	test   %edi,%edi
  800d2e:	74 38                	je     800d68 <memcmp+0x50>
		if (*s1 != *s2)
  800d30:	0f b6 03             	movzbl (%ebx),%eax
  800d33:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d36:	83 ef 01             	sub    $0x1,%edi
  800d39:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  800d3e:	38 c8                	cmp    %cl,%al
  800d40:	74 1d                	je     800d5f <memcmp+0x47>
  800d42:	eb 11                	jmp    800d55 <memcmp+0x3d>
  800d44:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  800d49:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  800d4e:	83 c2 01             	add    $0x1,%edx
  800d51:	38 c8                	cmp    %cl,%al
  800d53:	74 0a                	je     800d5f <memcmp+0x47>
			return *s1 - *s2;
  800d55:	0f b6 c0             	movzbl %al,%eax
  800d58:	0f b6 c9             	movzbl %cl,%ecx
  800d5b:	29 c8                	sub    %ecx,%eax
  800d5d:	eb 09                	jmp    800d68 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  800d5f:	39 fa                	cmp    %edi,%edx
  800d61:	75 e1                	jne    800d44 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  800d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	53                   	push   %ebx
  800d71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  800d74:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  800d76:	89 da                	mov    %ebx,%edx
  800d78:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  800d7b:	39 d3                	cmp    %edx,%ebx
  800d7d:	73 15                	jae    800d94 <memfind+0x27>
		if (*s == (unsigned char) c)
  800d7f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800d83:	38 0b                	cmp    %cl,(%ebx)
  800d85:	75 06                	jne    800d8d <memfind+0x20>
  800d87:	eb 0b                	jmp    800d94 <memfind+0x27>
  800d89:	38 08                	cmp    %cl,(%eax)
  800d8b:	74 07                	je     800d94 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  800d8d:	83 c0 01             	add    $0x1,%eax
  800d90:	39 c2                	cmp    %eax,%edx
  800d92:	77 f5                	ja     800d89 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d94:	5b                   	pop    %ebx
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800da0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800da3:	0f b6 02             	movzbl (%edx),%eax
  800da6:	3c 20                	cmp    $0x20,%al
  800da8:	74 04                	je     800dae <_Z6strtolPKcPPci+0x17>
  800daa:	3c 09                	cmp    $0x9,%al
  800dac:	75 0e                	jne    800dbc <_Z6strtolPKcPPci+0x25>
		s++;
  800dae:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800db1:	0f b6 02             	movzbl (%edx),%eax
  800db4:	3c 20                	cmp    $0x20,%al
  800db6:	74 f6                	je     800dae <_Z6strtolPKcPPci+0x17>
  800db8:	3c 09                	cmp    $0x9,%al
  800dba:	74 f2                	je     800dae <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dbc:	3c 2b                	cmp    $0x2b,%al
  800dbe:	75 0a                	jne    800dca <_Z6strtolPKcPPci+0x33>
		s++;
  800dc0:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800dc3:	bf 00 00 00 00       	mov    $0x0,%edi
  800dc8:	eb 10                	jmp    800dda <_Z6strtolPKcPPci+0x43>
  800dca:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800dcf:	3c 2d                	cmp    $0x2d,%al
  800dd1:	75 07                	jne    800dda <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  800dd3:	83 c2 01             	add    $0x1,%edx
  800dd6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dda:	85 db                	test   %ebx,%ebx
  800ddc:	0f 94 c0             	sete   %al
  800ddf:	74 05                	je     800de6 <_Z6strtolPKcPPci+0x4f>
  800de1:	83 fb 10             	cmp    $0x10,%ebx
  800de4:	75 15                	jne    800dfb <_Z6strtolPKcPPci+0x64>
  800de6:	80 3a 30             	cmpb   $0x30,(%edx)
  800de9:	75 10                	jne    800dfb <_Z6strtolPKcPPci+0x64>
  800deb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800def:	75 0a                	jne    800dfb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  800df1:	83 c2 02             	add    $0x2,%edx
  800df4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800df9:	eb 13                	jmp    800e0e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  800dfb:	84 c0                	test   %al,%al
  800dfd:	74 0f                	je     800e0e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dff:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e04:	80 3a 30             	cmpb   $0x30,(%edx)
  800e07:	75 05                	jne    800e0e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  800e09:	83 c2 01             	add    $0x1,%edx
  800e0c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e13:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e15:	0f b6 0a             	movzbl (%edx),%ecx
  800e18:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e1b:	80 fb 09             	cmp    $0x9,%bl
  800e1e:	77 08                	ja     800e28 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  800e20:	0f be c9             	movsbl %cl,%ecx
  800e23:	83 e9 30             	sub    $0x30,%ecx
  800e26:	eb 1e                	jmp    800e46 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  800e28:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  800e2b:	80 fb 19             	cmp    $0x19,%bl
  800e2e:	77 08                	ja     800e38 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  800e30:	0f be c9             	movsbl %cl,%ecx
  800e33:	83 e9 57             	sub    $0x57,%ecx
  800e36:	eb 0e                	jmp    800e46 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  800e38:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  800e3b:	80 fb 19             	cmp    $0x19,%bl
  800e3e:	77 15                	ja     800e55 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  800e40:	0f be c9             	movsbl %cl,%ecx
  800e43:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e46:	39 f1                	cmp    %esi,%ecx
  800e48:	7d 0f                	jge    800e59 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  800e4a:	83 c2 01             	add    $0x1,%edx
  800e4d:	0f af c6             	imul   %esi,%eax
  800e50:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  800e53:	eb c0                	jmp    800e15 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  800e55:	89 c1                	mov    %eax,%ecx
  800e57:	eb 02                	jmp    800e5b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e59:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5f:	74 05                	je     800e66 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  800e61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e64:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e66:	89 ca                	mov    %ecx,%edx
  800e68:	f7 da                	neg    %edx
  800e6a:	85 ff                	test   %edi,%edi
  800e6c:	0f 45 c2             	cmovne %edx,%eax
}
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	89 1c 24             	mov    %ebx,(%esp)
  800e7d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e81:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 c3                	mov    %eax,%ebx
  800e92:	89 c7                	mov    %eax,%edi
  800e94:	89 c6                	mov    %eax,%esi
  800e96:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e98:	8b 1c 24             	mov    (%esp),%ebx
  800e9b:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e9f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ea3:	89 ec                	mov    %ebp,%esp
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	83 ec 0c             	sub    $0xc,%esp
  800ead:	89 1c 24             	mov    %ebx,(%esp)
  800eb0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eb4:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800eb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebd:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	89 d3                	mov    %edx,%ebx
  800ec6:	89 d7                	mov    %edx,%edi
  800ec8:	89 d6                	mov    %edx,%esi
  800eca:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ecc:	8b 1c 24             	mov    (%esp),%ebx
  800ecf:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ed3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ed7:	89 ec                	mov    %ebp,%esp
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
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
  800eea:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eef:	b8 03 00 00 00       	mov    $0x3,%eax
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	89 cb                	mov    %ecx,%ebx
  800ef9:	89 cf                	mov    %ecx,%edi
  800efb:	89 ce                	mov    %ecx,%esi
  800efd:	cd 30                	int    $0x30

	if(check && ret > 0)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	7e 28                	jle    800f2b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f07:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f0e:	00 
  800f0f:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  800f16:	00 
  800f17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1e:	00 
  800f1f:	c7 04 24 71 4a 80 00 	movl   $0x804a71,(%esp)
  800f26:	e8 5d f4 ff ff       	call   800388 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f2b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f2e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f31:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f34:	89 ec                	mov    %ebp,%esp
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 0c             	sub    $0xc,%esp
  800f3e:	89 1c 24             	mov    %ebx,(%esp)
  800f41:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f45:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f49:	ba 00 00 00 00       	mov    $0x0,%edx
  800f4e:	b8 02 00 00 00       	mov    $0x2,%eax
  800f53:	89 d1                	mov    %edx,%ecx
  800f55:	89 d3                	mov    %edx,%ebx
  800f57:	89 d7                	mov    %edx,%edi
  800f59:	89 d6                	mov    %edx,%esi
  800f5b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f5d:	8b 1c 24             	mov    (%esp),%ebx
  800f60:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f64:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f68:	89 ec                	mov    %ebp,%esp
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 0c             	sub    $0xc,%esp
  800f72:	89 1c 24             	mov    %ebx,(%esp)
  800f75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f79:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800f7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f82:	b8 04 00 00 00       	mov    $0x4,%eax
  800f87:	89 d1                	mov    %edx,%ecx
  800f89:	89 d3                	mov    %edx,%ebx
  800f8b:	89 d7                	mov    %edx,%edi
  800f8d:	89 d6                	mov    %edx,%esi
  800f8f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f91:	8b 1c 24             	mov    (%esp),%ebx
  800f94:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f98:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f9c:	89 ec                	mov    %ebp,%esp
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 38             	sub    $0x38,%esp
  800fa6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fa9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fac:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  800faf:	be 00 00 00 00       	mov    $0x0,%esi
  800fb4:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc2:	89 f7                	mov    %esi,%edi
  800fc4:	cd 30                	int    $0x30

	if(check && ret > 0)
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	7e 28                	jle    800ff2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fca:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fce:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fd5:	00 
  800fd6:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  800fdd:	00 
  800fde:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe5:	00 
  800fe6:	c7 04 24 71 4a 80 00 	movl   $0x804a71,(%esp)
  800fed:	e8 96 f3 ff ff       	call   800388 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ff2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ff5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ff8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ffb:	89 ec                	mov    %ebp,%esp
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 38             	sub    $0x38,%esp
  801005:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801008:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80100b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80100e:	b8 09 00 00 00       	mov    $0x9,%eax
  801013:	8b 75 18             	mov    0x18(%ebp),%esi
  801016:	8b 7d 14             	mov    0x14(%ebp),%edi
  801019:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80101c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101f:	8b 55 08             	mov    0x8(%ebp),%edx
  801022:	cd 30                	int    $0x30

	if(check && ret > 0)
  801024:	85 c0                	test   %eax,%eax
  801026:	7e 28                	jle    801050 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801028:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801033:	00 
  801034:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  80103b:	00 
  80103c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801043:	00 
  801044:	c7 04 24 71 4a 80 00 	movl   $0x804a71,(%esp)
  80104b:	e8 38 f3 ff ff       	call   800388 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801050:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801053:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801056:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801059:	89 ec                	mov    %ebp,%esp
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 38             	sub    $0x38,%esp
  801063:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801066:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801069:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80106c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801071:	b8 0a 00 00 00       	mov    $0xa,%eax
  801076:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	89 df                	mov    %ebx,%edi
  80107e:	89 de                	mov    %ebx,%esi
  801080:	cd 30                	int    $0x30

	if(check && ret > 0)
  801082:	85 c0                	test   %eax,%eax
  801084:	7e 28                	jle    8010ae <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801086:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801091:	00 
  801092:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  801099:	00 
  80109a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a1:	00 
  8010a2:	c7 04 24 71 4a 80 00 	movl   $0x804a71,(%esp)
  8010a9:	e8 da f2 ff ff       	call   800388 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010b1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010b4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010b7:	89 ec                	mov    %ebp,%esp
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    

008010bb <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 38             	sub    $0x38,%esp
  8010c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8010ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8010d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010da:	89 df                	mov    %ebx,%edi
  8010dc:	89 de                	mov    %ebx,%esi
  8010de:	cd 30                	int    $0x30

	if(check && ret > 0)
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	7e 28                	jle    80110c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010ef:	00 
  8010f0:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  8010f7:	00 
  8010f8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ff:	00 
  801100:	c7 04 24 71 4a 80 00 	movl   $0x804a71,(%esp)
  801107:	e8 7c f2 ff ff       	call   800388 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80110c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80110f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801112:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801115:	89 ec                	mov    %ebp,%esp
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    

00801119 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 38             	sub    $0x38,%esp
  80111f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801122:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801125:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801128:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112d:	b8 06 00 00 00       	mov    $0x6,%eax
  801132:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801135:	8b 55 08             	mov    0x8(%ebp),%edx
  801138:	89 df                	mov    %ebx,%edi
  80113a:	89 de                	mov    %ebx,%esi
  80113c:	cd 30                	int    $0x30

	if(check && ret > 0)
  80113e:	85 c0                	test   %eax,%eax
  801140:	7e 28                	jle    80116a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801142:	89 44 24 10          	mov    %eax,0x10(%esp)
  801146:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80114d:	00 
  80114e:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  801155:	00 
  801156:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80115d:	00 
  80115e:	c7 04 24 71 4a 80 00 	movl   $0x804a71,(%esp)
  801165:	e8 1e f2 ff ff       	call   800388 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80116a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80116d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801170:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801173:	89 ec                	mov    %ebp,%esp
  801175:	5d                   	pop    %ebp
  801176:	c3                   	ret    

00801177 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 38             	sub    $0x38,%esp
  80117d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801180:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801183:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801186:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801190:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801193:	8b 55 08             	mov    0x8(%ebp),%edx
  801196:	89 df                	mov    %ebx,%edi
  801198:	89 de                	mov    %ebx,%esi
  80119a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80119c:	85 c0                	test   %eax,%eax
  80119e:	7e 28                	jle    8011c8 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a4:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8011ab:	00 
  8011ac:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  8011b3:	00 
  8011b4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011bb:	00 
  8011bc:	c7 04 24 71 4a 80 00 	movl   $0x804a71,(%esp)
  8011c3:	e8 c0 f1 ff ff       	call   800388 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011cb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011d1:	89 ec                	mov    %ebp,%esp
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    

008011d5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	83 ec 38             	sub    $0x38,%esp
  8011db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f4:	89 df                	mov    %ebx,%edi
  8011f6:	89 de                	mov    %ebx,%esi
  8011f8:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	7e 28                	jle    801226 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  801202:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801209:	00 
  80120a:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  801211:	00 
  801212:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801219:	00 
  80121a:	c7 04 24 71 4a 80 00 	movl   $0x804a71,(%esp)
  801221:	e8 62 f1 ff ff       	call   800388 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801226:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801229:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80122c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80122f:	89 ec                	mov    %ebp,%esp
  801231:	5d                   	pop    %ebp
  801232:	c3                   	ret    

00801233 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	83 ec 0c             	sub    $0xc,%esp
  801239:	89 1c 24             	mov    %ebx,(%esp)
  80123c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801240:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801244:	be 00 00 00 00       	mov    $0x0,%esi
  801249:	b8 0d 00 00 00       	mov    $0xd,%eax
  80124e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801251:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801254:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801257:	8b 55 08             	mov    0x8(%ebp),%edx
  80125a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80125c:	8b 1c 24             	mov    (%esp),%ebx
  80125f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801263:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801267:	89 ec                	mov    %ebp,%esp
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    

0080126b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	83 ec 38             	sub    $0x38,%esp
  801271:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801274:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801277:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80127a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80127f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801284:	8b 55 08             	mov    0x8(%ebp),%edx
  801287:	89 cb                	mov    %ecx,%ebx
  801289:	89 cf                	mov    %ecx,%edi
  80128b:	89 ce                	mov    %ecx,%esi
  80128d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80128f:	85 c0                	test   %eax,%eax
  801291:	7e 28                	jle    8012bb <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801293:	89 44 24 10          	mov    %eax,0x10(%esp)
  801297:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80129e:	00 
  80129f:	c7 44 24 08 54 4a 80 	movl   $0x804a54,0x8(%esp)
  8012a6:	00 
  8012a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ae:	00 
  8012af:	c7 04 24 71 4a 80 00 	movl   $0x804a71,(%esp)
  8012b6:	e8 cd f0 ff ff       	call   800388 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012c4:	89 ec                	mov    %ebp,%esp
  8012c6:	5d                   	pop    %ebp
  8012c7:	c3                   	ret    

008012c8 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 0c             	sub    $0xc,%esp
  8012ce:	89 1c 24             	mov    %ebx,(%esp)
  8012d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012de:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e9:	89 df                	mov    %ebx,%edi
  8012eb:	89 de                	mov    %ebx,%esi
  8012ed:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8012ef:	8b 1c 24             	mov    (%esp),%ebx
  8012f2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012f6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012fa:	89 ec                	mov    %ebp,%esp
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    

008012fe <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 0c             	sub    $0xc,%esp
  801304:	89 1c 24             	mov    %ebx,(%esp)
  801307:	89 74 24 04          	mov    %esi,0x4(%esp)
  80130b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80130f:	ba 00 00 00 00       	mov    $0x0,%edx
  801314:	b8 11 00 00 00       	mov    $0x11,%eax
  801319:	89 d1                	mov    %edx,%ecx
  80131b:	89 d3                	mov    %edx,%ebx
  80131d:	89 d7                	mov    %edx,%edi
  80131f:	89 d6                	mov    %edx,%esi
  801321:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801323:	8b 1c 24             	mov    (%esp),%ebx
  801326:	8b 74 24 04          	mov    0x4(%esp),%esi
  80132a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80132e:	89 ec                	mov    %ebp,%esp
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    

00801332 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	89 1c 24             	mov    %ebx,(%esp)
  80133b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80133f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801343:	bb 00 00 00 00       	mov    $0x0,%ebx
  801348:	b8 12 00 00 00       	mov    $0x12,%eax
  80134d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801350:	8b 55 08             	mov    0x8(%ebp),%edx
  801353:	89 df                	mov    %ebx,%edi
  801355:	89 de                	mov    %ebx,%esi
  801357:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801359:	8b 1c 24             	mov    (%esp),%ebx
  80135c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801360:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801364:	89 ec                	mov    %ebp,%esp
  801366:	5d                   	pop    %ebp
  801367:	c3                   	ret    

00801368 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
  80136b:	83 ec 0c             	sub    $0xc,%esp
  80136e:	89 1c 24             	mov    %ebx,(%esp)
  801371:	89 74 24 04          	mov    %esi,0x4(%esp)
  801375:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801379:	b9 00 00 00 00       	mov    $0x0,%ecx
  80137e:	b8 13 00 00 00       	mov    $0x13,%eax
  801383:	8b 55 08             	mov    0x8(%ebp),%edx
  801386:	89 cb                	mov    %ecx,%ebx
  801388:	89 cf                	mov    %ecx,%edi
  80138a:	89 ce                	mov    %ecx,%esi
  80138c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80138e:	8b 1c 24             	mov    (%esp),%ebx
  801391:	8b 74 24 04          	mov    0x4(%esp),%esi
  801395:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801399:	89 ec                	mov    %ebp,%esp
  80139b:	5d                   	pop    %ebp
  80139c:	c3                   	ret    

0080139d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 0c             	sub    $0xc,%esp
  8013a3:	89 1c 24             	mov    %ebx,(%esp)
  8013a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013ae:	b8 10 00 00 00       	mov    $0x10,%eax
  8013b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8013b6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c2:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  8013c4:	8b 1c 24             	mov    (%esp),%ebx
  8013c7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013cb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013cf:	89 ec                	mov    %ebp,%esp
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    
	...

008013d4 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 38             	sub    $0x38,%esp
  8013da:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013dd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013e0:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  8013e3:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  8013ea:	f6 c7 04             	test   $0x4,%bh
  8013ed:	74 31                	je     801420 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  8013ef:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  8013f6:	c1 e2 0c             	shl    $0xc,%edx
  8013f9:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8013ff:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801403:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801407:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80140f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801416:	e8 e4 fb ff ff       	call   800fff <_Z12sys_page_mapiPviS_i>
        return r;
  80141b:	e9 8c 00 00 00       	jmp    8014ac <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  801420:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  801427:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  80142c:	f7 c6 00 08 00 00    	test   $0x800,%esi
  801432:	75 2a                	jne    80145e <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  801434:	84 c9                	test   %cl,%cl
  801436:	74 0f                	je     801447 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  801438:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  80143f:	83 e3 02             	and    $0x2,%ebx
  801442:	80 cf 02             	or     $0x2,%bh
  801445:	eb 17                	jmp    80145e <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  801447:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  80144e:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  801451:	83 f9 01             	cmp    $0x1,%ecx
  801454:	19 db                	sbb    %ebx,%ebx
  801456:	f7 d3                	not    %ebx
  801458:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80145e:	89 df                	mov    %ebx,%edi
  801460:	83 cf 05             	or     $0x5,%edi
  801463:	89 d6                	mov    %edx,%esi
  801465:	c1 e6 0c             	shl    $0xc,%esi
  801468:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80146c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801470:	89 44 24 08          	mov    %eax,0x8(%esp)
  801474:	89 74 24 04          	mov    %esi,0x4(%esp)
  801478:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80147f:	e8 7b fb ff ff       	call   800fff <_Z12sys_page_mapiPviS_i>
  801484:	85 c0                	test   %eax,%eax
  801486:	75 24                	jne    8014ac <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  801488:	85 db                	test   %ebx,%ebx
  80148a:	74 20                	je     8014ac <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80148c:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801490:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801494:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80149b:	00 
  80149c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a7:	e8 53 fb ff ff       	call   800fff <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  8014ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014af:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014b5:	89 ec                	mov    %ebp,%esp
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    

008014b9 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	83 ec 28             	sub    $0x28,%esp
  8014bf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8014c2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8014c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  8014c8:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  8014ca:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  8014ce:	0f 84 ff 00 00 00    	je     8015d3 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  8014d4:	89 f0                	mov    %esi,%eax
  8014d6:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  8014d9:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8014e0:	f6 c4 08             	test   $0x8,%ah
  8014e3:	0f 84 ea 00 00 00    	je     8015d3 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8014e9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014f0:	00 
  8014f1:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014f8:	00 
  8014f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801500:	e8 9b fa ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
  801505:	85 c0                	test   %eax,%eax
  801507:	79 20                	jns    801529 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  801509:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80150d:	c7 44 24 08 0a 46 80 	movl   $0x80460a,0x8(%esp)
  801514:	00 
  801515:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  80151c:	00 
  80151d:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  801524:	e8 5f ee ff ff       	call   800388 <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  801529:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  80152f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801536:	00 
  801537:	89 74 24 04          	mov    %esi,0x4(%esp)
  80153b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801542:	e8 90 f7 ff ff       	call   800cd7 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801547:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80154e:	00 
  80154f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801553:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80155a:	00 
  80155b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801562:	00 
  801563:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80156a:	e8 90 fa ff ff       	call   800fff <_Z12sys_page_mapiPviS_i>
  80156f:	85 c0                	test   %eax,%eax
  801571:	79 20                	jns    801593 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  801573:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801577:	c7 44 24 08 8a 4a 80 	movl   $0x804a8a,0x8(%esp)
  80157e:	00 
  80157f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801586:	00 
  801587:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  80158e:	e8 f5 ed ff ff       	call   800388 <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801593:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80159a:	00 
  80159b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a2:	e8 b6 fa ff ff       	call   80105d <_Z14sys_page_unmapiPv>
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	79 20                	jns    8015cb <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  8015ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015af:	c7 44 24 08 9b 4a 80 	movl   $0x804a9b,0x8(%esp)
  8015b6:	00 
  8015b7:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8015be:	00 
  8015bf:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  8015c6:	e8 bd ed ff ff       	call   800388 <_Z6_panicPKciS0_z>
    resume(utf);
  8015cb:	89 1c 24             	mov    %ebx,(%esp)
  8015ce:	e8 8d 2d 00 00       	call   804360 <resume>
}
  8015d3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015d6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015d9:	89 ec                	mov    %ebp,%esp
  8015db:	5d                   	pop    %ebp
  8015dc:	c3                   	ret    

008015dd <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	57                   	push   %edi
  8015e1:	56                   	push   %esi
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  8015e6:	c7 04 24 b9 14 80 00 	movl   $0x8014b9,(%esp)
  8015ed:	e8 99 2c 00 00       	call   80428b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  8015f2:	be 07 00 00 00       	mov    $0x7,%esi
  8015f7:	89 f0                	mov    %esi,%eax
  8015f9:	cd 30                	int    $0x30
  8015fb:	89 c6                	mov    %eax,%esi
  8015fd:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  8015ff:	85 c0                	test   %eax,%eax
  801601:	79 20                	jns    801623 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  801603:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801607:	c7 44 24 08 ae 4a 80 	movl   $0x804aae,0x8(%esp)
  80160e:	00 
  80160f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801616:	00 
  801617:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  80161e:	e8 65 ed ff ff       	call   800388 <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801623:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  801628:	85 c0                	test   %eax,%eax
  80162a:	75 1c                	jne    801648 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  80162c:	e8 07 f9 ff ff       	call   800f38 <_Z12sys_getenvidv>
  801631:	25 ff 03 00 00       	and    $0x3ff,%eax
  801636:	6b c0 78             	imul   $0x78,%eax,%eax
  801639:	05 00 00 00 ef       	add    $0xef000000,%eax
  80163e:	a3 04 70 80 00       	mov    %eax,0x807004
        return 0;
  801643:	e9 de 00 00 00       	jmp    801726 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  801648:	89 d8                	mov    %ebx,%eax
  80164a:	c1 f8 0a             	sar    $0xa,%eax
  80164d:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801654:	a8 01                	test   $0x1,%al
  801656:	75 08                	jne    801660 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  801658:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  80165e:	eb 19                	jmp    801679 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  801660:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801667:	a8 01                	test   $0x1,%al
  801669:	74 0e                	je     801679 <_Z4forkv+0x9c>
            duppage(envid, pn);
  80166b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801670:	89 da                	mov    %ebx,%edx
  801672:	89 f8                	mov    %edi,%eax
  801674:	e8 5b fd ff ff       	call   8013d4 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801679:	83 eb 01             	sub    $0x1,%ebx
  80167c:	79 ca                	jns    801648 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  80167e:	a1 04 70 80 00       	mov    0x807004,%eax
  801683:	8b 40 5c             	mov    0x5c(%eax),%eax
  801686:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168a:	89 34 24             	mov    %esi,(%esp)
  80168d:	e8 43 fb ff ff       	call   8011d5 <_Z26sys_env_set_pgfault_upcalliPv>
  801692:	85 c0                	test   %eax,%eax
  801694:	74 20                	je     8016b6 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801696:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80169a:	c7 44 24 08 d8 4a 80 	movl   $0x804ad8,0x8(%esp)
  8016a1:	00 
  8016a2:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  8016a9:	00 
  8016aa:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  8016b1:	e8 d2 ec ff ff       	call   800388 <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8016b6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016bd:	00 
  8016be:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8016c5:	ee 
  8016c6:	89 34 24             	mov    %esi,(%esp)
  8016c9:	e8 d2 f8 ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	79 20                	jns    8016f2 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  8016d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016d6:	c7 44 24 08 0a 46 80 	movl   $0x80460a,0x8(%esp)
  8016dd:	00 
  8016de:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  8016e5:	00 
  8016e6:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  8016ed:	e8 96 ec ff ff       	call   800388 <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8016f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016f9:	00 
  8016fa:	89 34 24             	mov    %esi,(%esp)
  8016fd:	e8 b9 f9 ff ff       	call   8010bb <_Z18sys_env_set_statusii>
  801702:	85 c0                	test   %eax,%eax
  801704:	79 20                	jns    801726 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  801706:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80170a:	c7 44 24 08 be 4a 80 	movl   $0x804abe,0x8(%esp)
  801711:	00 
  801712:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801719:	00 
  80171a:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  801721:	e8 62 ec ff ff       	call   800388 <_Z6_panicPKciS0_z>

    return envid;
}
  801726:	89 f0                	mov    %esi,%eax
  801728:	83 c4 1c             	add    $0x1c,%esp
  80172b:	5b                   	pop    %ebx
  80172c:	5e                   	pop    %esi
  80172d:	5f                   	pop    %edi
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	57                   	push   %edi
  801734:	56                   	push   %esi
  801735:	53                   	push   %ebx
  801736:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  801739:	c7 04 24 b9 14 80 00 	movl   $0x8014b9,(%esp)
  801740:	e8 46 2b 00 00       	call   80428b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  801745:	be 07 00 00 00       	mov    $0x7,%esi
  80174a:	89 f0                	mov    %esi,%eax
  80174c:	cd 30                	int    $0x30
  80174e:	89 c6                	mov    %eax,%esi
  801750:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  801752:	85 c0                	test   %eax,%eax
  801754:	79 20                	jns    801776 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  801756:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80175a:	c7 44 24 08 ae 4a 80 	movl   $0x804aae,0x8(%esp)
  801761:	00 
  801762:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  801769:	00 
  80176a:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  801771:	e8 12 ec ff ff       	call   800388 <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  801776:	85 c0                	test   %eax,%eax
  801778:	0f 84 40 01 00 00    	je     8018be <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  80177e:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  801780:	c1 eb 0c             	shr    $0xc,%ebx
  801783:	83 eb 01             	sub    $0x1,%ebx
  801786:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  801789:	eb 31                	jmp    8017bc <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  80178b:	89 d8                	mov    %ebx,%eax
  80178d:	c1 f8 0a             	sar    $0xa,%eax
  801790:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801797:	a8 01                	test   $0x1,%al
  801799:	75 08                	jne    8017a3 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  80179b:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8017a1:	eb 19                	jmp    8017bc <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  8017a3:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8017aa:	a8 01                	test   $0x1,%al
  8017ac:	74 0e                	je     8017bc <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  8017ae:	b9 01 00 00 00       	mov    $0x1,%ecx
  8017b3:	89 da                	mov    %ebx,%edx
  8017b5:	89 f8                	mov    %edi,%eax
  8017b7:	e8 18 fc ff ff       	call   8013d4 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  8017bc:	83 eb 01             	sub    $0x1,%ebx
  8017bf:	79 ca                	jns    80178b <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  8017c1:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  8017c8:	7f 3f                	jg     801809 <_Z5sforkv+0xd9>
  8017ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  8017cd:	89 d8                	mov    %ebx,%eax
  8017cf:	c1 f8 0a             	sar    $0xa,%eax
  8017d2:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8017d9:	a8 01                	test   $0x1,%al
  8017db:	75 08                	jne    8017e5 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  8017dd:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  8017e3:	eb 19                	jmp    8017fe <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  8017e5:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  8017ec:	a8 01                	test   $0x1,%al
  8017ee:	74 0e                	je     8017fe <_Z5sforkv+0xce>
            duppage(envid, i);
  8017f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017f5:	89 da                	mov    %ebx,%edx
  8017f7:	89 f8                	mov    %edi,%eax
  8017f9:	e8 d6 fb ff ff       	call   8013d4 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  8017fe:	83 c3 01             	add    $0x1,%ebx
  801801:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  801807:	7e c4                	jle    8017cd <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  801809:	e8 2a f7 ff ff       	call   800f38 <_Z12sys_getenvidv>
  80180e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801813:	6b c0 78             	imul   $0x78,%eax,%eax
  801816:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  80181b:	8b 40 50             	mov    0x50(%eax),%eax
  80181e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801822:	89 34 24             	mov    %esi,(%esp)
  801825:	e8 ab f9 ff ff       	call   8011d5 <_Z26sys_env_set_pgfault_upcalliPv>
  80182a:	85 c0                	test   %eax,%eax
  80182c:	74 20                	je     80184e <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  80182e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801832:	c7 44 24 08 d8 4a 80 	movl   $0x804ad8,0x8(%esp)
  801839:	00 
  80183a:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801841:	00 
  801842:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  801849:	e8 3a eb ff ff       	call   800388 <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80184e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801855:	00 
  801856:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  80185d:	ee 
  80185e:	89 34 24             	mov    %esi,(%esp)
  801861:	e8 3a f7 ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
  801866:	85 c0                	test   %eax,%eax
  801868:	79 20                	jns    80188a <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  80186a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80186e:	c7 44 24 08 0a 46 80 	movl   $0x80460a,0x8(%esp)
  801875:	00 
  801876:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  80187d:	00 
  80187e:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  801885:	e8 fe ea ff ff       	call   800388 <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80188a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801891:	00 
  801892:	89 34 24             	mov    %esi,(%esp)
  801895:	e8 21 f8 ff ff       	call   8010bb <_Z18sys_env_set_statusii>
  80189a:	85 c0                	test   %eax,%eax
  80189c:	79 20                	jns    8018be <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  80189e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018a2:	c7 44 24 08 be 4a 80 	movl   $0x804abe,0x8(%esp)
  8018a9:	00 
  8018aa:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  8018b1:	00 
  8018b2:	c7 04 24 7f 4a 80 00 	movl   $0x804a7f,(%esp)
  8018b9:	e8 ca ea ff ff       	call   800388 <_Z6_panicPKciS0_z>

    return envid;
    
}
  8018be:	89 f0                	mov    %esi,%eax
  8018c0:	83 c4 2c             	add    $0x2c,%esp
  8018c3:	5b                   	pop    %ebx
  8018c4:	5e                   	pop    %esi
  8018c5:	5f                   	pop    %edi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    
	...

008018d0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	56                   	push   %esi
  8018d4:	53                   	push   %ebx
  8018d5:	83 ec 10             	sub    $0x10,%esp
  8018d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8018db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018de:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8018e8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  8018eb:	89 04 24             	mov    %eax,(%esp)
  8018ee:	e8 78 f9 ff ff       	call   80126b <_Z12sys_ipc_recvPv>
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	79 16                	jns    80190d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  8018f7:	85 db                	test   %ebx,%ebx
  8018f9:	74 06                	je     801901 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  8018fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  801901:	85 f6                	test   %esi,%esi
  801903:	74 53                	je     801958 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  801905:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  80190b:	eb 4b                	jmp    801958 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  80190d:	85 db                	test   %ebx,%ebx
  80190f:	74 17                	je     801928 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  801911:	e8 22 f6 ff ff       	call   800f38 <_Z12sys_getenvidv>
  801916:	25 ff 03 00 00       	and    $0x3ff,%eax
  80191b:	6b c0 78             	imul   $0x78,%eax,%eax
  80191e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  801923:	8b 40 60             	mov    0x60(%eax),%eax
  801926:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  801928:	85 f6                	test   %esi,%esi
  80192a:	74 17                	je     801943 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  80192c:	e8 07 f6 ff ff       	call   800f38 <_Z12sys_getenvidv>
  801931:	25 ff 03 00 00       	and    $0x3ff,%eax
  801936:	6b c0 78             	imul   $0x78,%eax,%eax
  801939:	05 00 00 00 ef       	add    $0xef000000,%eax
  80193e:	8b 40 70             	mov    0x70(%eax),%eax
  801941:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  801943:	e8 f0 f5 ff ff       	call   800f38 <_Z12sys_getenvidv>
  801948:	25 ff 03 00 00       	and    $0x3ff,%eax
  80194d:	6b c0 78             	imul   $0x78,%eax,%eax
  801950:	05 08 00 00 ef       	add    $0xef000008,%eax
  801955:	8b 40 60             	mov    0x60(%eax),%eax

}
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5d                   	pop    %ebp
  80195e:	c3                   	ret    

0080195f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	57                   	push   %edi
  801963:	56                   	push   %esi
  801964:	53                   	push   %ebx
  801965:	83 ec 1c             	sub    $0x1c,%esp
  801968:	8b 75 08             	mov    0x8(%ebp),%esi
  80196b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80196e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  801971:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  801973:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  801978:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  80197b:	8b 45 14             	mov    0x14(%ebp),%eax
  80197e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801982:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801986:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80198a:	89 34 24             	mov    %esi,(%esp)
  80198d:	e8 a1 f8 ff ff       	call   801233 <_Z16sys_ipc_try_sendijPvi>
  801992:	85 c0                	test   %eax,%eax
  801994:	79 31                	jns    8019c7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  801996:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801999:	75 0c                	jne    8019a7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  80199b:	90                   	nop
  80199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8019a0:	e8 c7 f5 ff ff       	call   800f6c <_Z9sys_yieldv>
  8019a5:	eb d4                	jmp    80197b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  8019a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ab:	c7 44 24 08 f7 4a 80 	movl   $0x804af7,0x8(%esp)
  8019b2:	00 
  8019b3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8019ba:	00 
  8019bb:	c7 04 24 04 4b 80 00 	movl   $0x804b04,(%esp)
  8019c2:	e8 c1 e9 ff ff       	call   800388 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  8019c7:	83 c4 1c             	add    $0x1c,%esp
  8019ca:	5b                   	pop    %ebx
  8019cb:	5e                   	pop    %esi
  8019cc:	5f                   	pop    %edi
  8019cd:	5d                   	pop    %ebp
  8019ce:	c3                   	ret    
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
  801a04:	c7 44 24 0c 0e 4b 80 	movl   $0x804b0e,0xc(%esp)
  801a0b:	00 
  801a0c:	c7 44 24 08 1b 4b 80 	movl   $0x804b1b,0x8(%esp)
  801a13:	00 
  801a14:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801a1b:	00 
  801a1c:	c7 04 24 30 4b 80 00 	movl   $0x804b30,(%esp)
  801a23:	e8 60 e9 ff ff       	call   800388 <_Z6_panicPKciS0_z>
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
  801ab9:	c7 44 24 0c 0e 4b 80 	movl   $0x804b0e,0xc(%esp)
  801ac0:	00 
  801ac1:	c7 44 24 08 1b 4b 80 	movl   $0x804b1b,0x8(%esp)
  801ac8:	00 
  801ac9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801ad0:	00 
  801ad1:	c7 04 24 30 4b 80 00 	movl   $0x804b30,(%esp)
  801ad8:	e8 ab e8 ff ff       	call   800388 <_Z6_panicPKciS0_z>
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
  801b95:	8b 14 85 9c 4b 80 00 	mov    0x804b9c(,%eax,4),%edx
  801b9c:	85 d2                	test   %edx,%edx
  801b9e:	75 de                	jne    801b7e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ba0:	a1 04 70 80 00       	mov    0x807004,%eax
  801ba5:	8b 40 04             	mov    0x4(%eax),%eax
  801ba8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb0:	c7 04 24 58 4b 80 00 	movl   $0x804b58,(%esp)
  801bb7:	e8 ea e8 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  801c47:	e8 11 f4 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
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
  801d44:	e8 b6 f2 ff ff       	call   800fff <_Z12sys_page_mapiPviS_i>
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
  801d82:	e8 78 f2 ff ff       	call   800fff <_Z12sys_page_mapiPviS_i>
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
  801d9b:	e8 bd f2 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801da0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801da4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dab:	e8 ad f2 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
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
  801e3d:	a1 04 70 80 00       	mov    0x807004,%eax
  801e42:	8b 40 04             	mov    0x4(%eax),%eax
  801e45:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	c7 04 24 39 4b 80 00 	movl   $0x804b39,(%esp)
  801e54:	e8 4d e6 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  801fce:	a1 04 70 80 00       	mov    0x807004,%eax
  801fd3:	8b 40 04             	mov    0x4(%eax),%eax
  801fd6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fda:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fde:	c7 04 24 78 4b 80 00 	movl   $0x804b78,(%esp)
  801fe5:	e8 bc e4 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  802169:	c7 44 24 08 b0 4b 80 	movl   $0x804bb0,0x8(%esp)
  802170:	00 
  802171:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  802178:	00 
  802179:	c7 04 24 c6 4b 80 00 	movl   $0x804bc6,(%esp)
  802180:	e8 03 e2 ff ff       	call   800388 <_Z6_panicPKciS0_z>
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
  8021c8:	c7 44 24 08 ec 4b 80 	movl   $0x804bec,0x8(%esp)
  8021cf:	00 
  8021d0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8021d7:	00 
  8021d8:	c7 04 24 c6 4b 80 00 	movl   $0x804bc6,(%esp)
  8021df:	e8 a4 e1 ff ff       	call   800388 <_Z6_panicPKciS0_z>
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
  802207:	c7 44 24 08 1c 4c 80 	movl   $0x804c1c,0x8(%esp)
  80220e:	00 
  80220f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802216:	00 
  802217:	c7 04 24 c6 4b 80 00 	movl   $0x804bc6,(%esp)
  80221e:	e8 65 e1 ff ff       	call   800388 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802223:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80222a:	00 
  80222b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802232:	00 
  802233:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802237:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  80223e:	e8 1c f7 ff ff       	call   80195f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802243:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80224a:	00 
  80224b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80224f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802256:	e8 75 f6 ff ff       	call   8018d0 <_Z8ipc_recvPiPvS_>
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
  802281:	e8 05 20 00 00       	call   80428b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

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
  802531:	c7 44 24 08 d1 4b 80 	movl   $0x804bd1,0x8(%esp)
  802538:	00 
  802539:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802540:	00 
  802541:	c7 04 24 c6 4b 80 00 	movl   $0x804bc6,(%esp)
  802548:	e8 3b de ff ff       	call   800388 <_Z6_panicPKciS0_z>
    resume(utf);
  80254d:	89 1c 24             	mov    %ebx,(%esp)
  802550:	e8 0b 1e 00 00       	call   804360 <resume>
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
  802586:	e8 2f e5 ff ff       	call   800aba <_Z6strcpyPcPKc>
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
  8026cb:	e8 07 e6 ff ff       	call   800cd7 <memcpy>
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
  802707:	e8 cb e5 ff ff       	call   800cd7 <memcpy>
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
  80275a:	e8 78 e5 ff ff       	call   800cd7 <memcpy>
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
  8027e9:	e8 e9 e4 ff ff       	call   800cd7 <memcpy>
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
  80281a:	e8 b8 e4 ff ff       	call   800cd7 <memcpy>
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
  802858:	e8 7a e4 ff ff       	call   800cd7 <memcpy>
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
  80297d:	e8 96 e3 ff ff       	call   800d18 <memcmp>
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
  802a03:	e8 f9 e1 ff ff       	call   800c01 <memset>
	empty->de_namelen = namelen;
  802a08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802a11:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a15:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a19:	83 c0 08             	add    $0x8,%eax
  802a1c:	89 04 24             	mov    %eax,(%esp)
  802a1f:	e8 b3 e2 ff ff       	call   800cd7 <memcpy>
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
  802ac5:	e8 d6 e4 ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
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
  802bcc:	e8 30 e0 ff ff       	call   800c01 <memset>
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
  802c67:	e8 4e de ff ff       	call   800aba <_Z6strcpyPcPKc>
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
  802cae:	a1 04 70 80 00       	mov    0x807004,%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cb9:	89 54 24 04          	mov    %edx,0x4(%esp)
  802cbd:	89 04 24             	mov    %eax,(%esp)
  802cc0:	e8 98 e3 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
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
  802cf3:	c7 44 24 04 e4 4b 80 	movl   $0x804be4,0x4(%esp)
  802cfa:	00 
  802cfb:	89 1c 24             	mov    %ebx,(%esp)
  802cfe:	e8 b7 dd ff ff       	call   800aba <_Z6strcpyPcPKc>
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
  802dc6:	e8 c0 14 00 00       	call   80428b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802dcb:	a1 00 10 00 50       	mov    0x50001000,%eax
  802dd0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802dd5:	74 28                	je     802dff <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802dd7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802dde:	4a 
  802ddf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802de3:	c7 44 24 08 4c 4c 80 	movl   $0x804c4c,0x8(%esp)
  802dea:	00 
  802deb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802df2:	00 
  802df3:	c7 04 24 c6 4b 80 00 	movl   $0x804bc6,(%esp)
  802dfa:	e8 89 d5 ff ff       	call   800388 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802dff:	a1 04 10 00 50       	mov    0x50001004,%eax
  802e04:	83 f8 03             	cmp    $0x3,%eax
  802e07:	7f 1c                	jg     802e25 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802e09:	c7 44 24 08 80 4c 80 	movl   $0x804c80,0x8(%esp)
  802e10:	00 
  802e11:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802e18:	00 
  802e19:	c7 04 24 c6 4b 80 00 	movl   $0x804bc6,(%esp)
  802e20:	e8 63 d5 ff ff       	call   800388 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802e25:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802e2b:	85 d2                	test   %edx,%edx
  802e2d:	7f 1c                	jg     802e4b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802e2f:	c7 44 24 08 b0 4c 80 	movl   $0x804cb0,0x8(%esp)
  802e36:	00 
  802e37:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802e3e:	00 
  802e3f:	c7 04 24 c6 4b 80 00 	movl   $0x804bc6,(%esp)
  802e46:	e8 3d d5 ff ff       	call   800388 <_Z6_panicPKciS0_z>
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
  802e98:	c7 44 24 08 e0 4c 80 	movl   $0x804ce0,0x8(%esp)
  802e9f:	00 
  802ea0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802ea7:	00 
  802ea8:	c7 04 24 c6 4b 80 00 	movl   $0x804bc6,(%esp)
  802eaf:	e8 d4 d4 ff ff       	call   800388 <_Z6_panicPKciS0_z>

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
  802ee4:	c7 04 24 24 4d 80 00 	movl   $0x804d24,(%esp)
  802eeb:	e8 b6 d5 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  802f0b:	c7 04 24 58 4d 80 00 	movl   $0x804d58,(%esp)
  802f12:	e8 8f d5 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  802fa9:	c7 04 24 84 4d 80 00 	movl   $0x804d84,(%esp)
  802fb0:	e8 f1 d4 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  802fd1:	c7 04 24 a8 4d 80 00 	movl   $0x804da8,(%esp)
  802fd8:	e8 c9 d4 ff ff       	call   8004a6 <_Z7cprintfPKcz>
			++errors;
  802fdd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802fe4:	eb 1e                	jmp    803004 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  802fe6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  802fec:	83 3a 02             	cmpl   $0x2,(%edx)
  802fef:	74 13                	je     803004 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  802ff1:	c7 04 24 dc 4d 80 00 	movl   $0x804ddc,(%esp)
  802ff8:	e8 a9 d4 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  803034:	c7 04 24 0c 4e 80 00 	movl   $0x804e0c,(%esp)
  80303b:	e8 66 d4 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  803074:	c7 04 24 30 4e 80 00 	movl   $0x804e30,(%esp)
  80307b:	e8 26 d4 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  8030d7:	c7 04 24 54 4e 80 00 	movl   $0x804e54,(%esp)
  8030de:	e8 c3 d3 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  80310f:	c7 04 24 98 4e 80 00 	movl   $0x804e98,(%esp)
  803116:	e8 8b d3 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  803151:	c7 04 24 dc 4e 80 00 	movl   $0x804edc,(%esp)
  803158:	e8 49 d3 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  803183:	c7 04 24 20 4f 80 00 	movl   $0x804f20,(%esp)
  80318a:	e8 17 d3 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  8031ae:	c7 04 24 5c 4f 80 00 	movl   $0x804f5c,(%esp)
  8031b5:	e8 ec d2 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  8032b6:	c7 04 24 98 4f 80 00 	movl   $0x804f98,(%esp)
  8032bd:	e8 e4 d1 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  803317:	c7 04 24 cc 4f 80 00 	movl   $0x804fcc,(%esp)
  80331e:	e8 83 d1 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  803341:	c7 04 24 f8 4f 80 00 	movl   $0x804ff8,(%esp)
  803348:	e8 59 d1 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  80336c:	e8 66 d9 ff ff       	call   800cd7 <memcpy>
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
  8033b6:	c7 04 24 2c 50 80 00 	movl   $0x80502c,(%esp)
  8033bd:	e8 e4 d0 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  80346d:	c7 04 24 5c 50 80 00 	movl   $0x80505c,(%esp)
  803474:	e8 2d d0 ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  80349e:	e8 75 d8 ff ff       	call   800d18 <memcmp>
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
  8034c9:	c7 04 24 8c 50 80 00 	movl   $0x80508c,(%esp)
  8034d0:	e8 d1 cf ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  80358c:	c7 04 24 bc 50 80 00 	movl   $0x8050bc,(%esp)
  803593:	e8 0e cf ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  8035e4:	c7 04 24 e8 50 80 00 	movl   $0x8050e8,(%esp)
  8035eb:	e8 b6 ce ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  80364c:	c7 44 24 04 1b 51 80 	movl   $0x80511b,0x4(%esp)
  803653:	00 
  803654:	89 34 24             	mov    %esi,(%esp)
  803657:	e8 5e d4 ff ff       	call   800aba <_Z6strcpyPcPKc>
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
  803699:	e8 bf d9 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80369e:	89 1c 24             	mov    %ebx,(%esp)
  8036a1:	e8 46 e4 ff ff       	call   801aec <_Z7fd2dataP2Fd>
  8036a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036b1:	e8 a7 d9 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
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
  8036ca:	a1 04 70 80 00       	mov    0x807004,%eax
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
  8036ef:	8b 15 04 70 80 00    	mov    0x807004,%edx
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
  803708:	c7 04 24 22 51 80 00 	movl   $0x805122,(%esp)
  80370f:	e8 92 cd ff ff       	call   8004a6 <_Z7cprintfPKcz>
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
  803746:	e8 21 d8 ff ff       	call   800f6c <_Z9sys_yieldv>
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
  8037d9:	e8 8e d7 ff ff       	call   800f6c <_Z9sys_yieldv>
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
  803871:	e8 2a d7 ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
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
  80389b:	e8 00 d7 ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
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
  8038d9:	e8 21 d7 ff ff       	call   800fff <_Z12sys_page_mapiPviS_i>
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
  80393b:	e8 1d d7 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803940:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803943:	89 44 24 04          	mov    %eax,0x4(%esp)
  803947:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80394e:	e8 0a d7 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803956:	89 44 24 04          	mov    %eax,0x4(%esp)
  80395a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803961:	e8 f7 d6 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
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
  8039ac:	e8 ef d5 ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
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
  803a2a:	e8 71 d5 ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
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
  803a45:	c7 04 24 80 51 80 00 	movl   $0x805180,(%esp)
  803a4c:	e8 55 ca ff ff       	call   8004a6 <_Z7cprintfPKcz>
  803a51:	eb 10                	jmp    803a63 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a57:	c7 04 24 35 51 80 00 	movl   $0x805135,(%esp)
  803a5e:	e8 43 ca ff ff       	call   8004a6 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803a63:	c7 04 24 3f 51 80 00 	movl   $0x80513f,(%esp)
  803a6a:	e8 37 ca ff ff       	call   8004a6 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  803a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a72:	a8 04                	test   $0x4,%al
  803a74:	74 04                	je     803a7a <_Z18pipe_ipc_recv_readv+0x82>
  803a76:	a8 01                	test   $0x1,%al
  803a78:	75 24                	jne    803a9e <_Z18pipe_ipc_recv_readv+0xa6>
  803a7a:	c7 44 24 0c 52 51 80 	movl   $0x805152,0xc(%esp)
  803a81:	00 
  803a82:	c7 44 24 08 1b 4b 80 	movl   $0x804b1b,0x8(%esp)
  803a89:	00 
  803a8a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803a91:	00 
  803a92:	c7 04 24 6f 51 80 00 	movl   $0x80516f,(%esp)
  803a99:	e8 ea c8 ff ff       	call   800388 <_Z6_panicPKciS0_z>
    
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
  803acd:	e8 8b d5 ff ff       	call   80105d <_Z14sys_page_unmapiPv>
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
  803af6:	e8 d5 dd ff ff       	call   8018d0 <_Z8ipc_recvPiPvS_>
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
  803b50:	e8 0a de ff ff       	call   80195f <_Z8ipc_sendijPvi>
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

00803ba0 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803ba0:	55                   	push   %ebp
  803ba1:	89 e5                	mov    %esp,%ebp
  803ba3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803ba6:	c7 44 24 04 a3 51 80 	movl   $0x8051a3,0x4(%esp)
  803bad:	00 
  803bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bb1:	89 04 24             	mov    %eax,(%esp)
  803bb4:	e8 01 cf ff ff       	call   800aba <_Z6strcpyPcPKc>
	return 0;
}
  803bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbe:	c9                   	leave  
  803bbf:	c3                   	ret    

00803bc0 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803bc0:	55                   	push   %ebp
  803bc1:	89 e5                	mov    %esp,%ebp
  803bc3:	53                   	push   %ebx
  803bc4:	83 ec 14             	sub    $0x14,%esp
  803bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803bca:	89 1c 24             	mov    %ebx,(%esp)
  803bcd:	e8 8a ff ff ff       	call   803b5c <_Z7pagerefPv>
  803bd2:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803bd9:	83 fa 01             	cmp    $0x1,%edx
  803bdc:	75 0b                	jne    803be9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  803bde:	8b 43 0c             	mov    0xc(%ebx),%eax
  803be1:	89 04 24             	mov    %eax,(%esp)
  803be4:	e8 fe 02 00 00       	call   803ee7 <_Z11nsipc_closei>
	else
		return 0;
}
  803be9:	83 c4 14             	add    $0x14,%esp
  803bec:	5b                   	pop    %ebx
  803bed:	5d                   	pop    %ebp
  803bee:	c3                   	ret    

00803bef <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803bef:	55                   	push   %ebp
  803bf0:	89 e5                	mov    %esp,%ebp
  803bf2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803bf5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803bfc:	00 
  803bfd:	8b 45 10             	mov    0x10(%ebp),%eax
  803c00:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  803c11:	89 04 24             	mov    %eax,(%esp)
  803c14:	e8 c9 03 00 00       	call   803fe2 <_Z10nsipc_sendiPKvij>
}
  803c19:	c9                   	leave  
  803c1a:	c3                   	ret    

00803c1b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803c1b:	55                   	push   %ebp
  803c1c:	89 e5                	mov    %esp,%ebp
  803c1e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803c21:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803c28:	00 
  803c29:	8b 45 10             	mov    0x10(%ebp),%eax
  803c2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c37:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3a:	8b 40 0c             	mov    0xc(%eax),%eax
  803c3d:	89 04 24             	mov    %eax,(%esp)
  803c40:	e8 1d 03 00 00       	call   803f62 <_Z10nsipc_recviPvij>
}
  803c45:	c9                   	leave  
  803c46:	c3                   	ret    

00803c47 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803c47:	55                   	push   %ebp
  803c48:	89 e5                	mov    %esp,%ebp
  803c4a:	83 ec 28             	sub    $0x28,%esp
  803c4d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803c50:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803c53:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803c55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803c58:	89 04 24             	mov    %eax,(%esp)
  803c5b:	e8 a7 de ff ff       	call   801b07 <_Z14fd_find_unusedPP2Fd>
  803c60:	89 c3                	mov    %eax,%ebx
  803c62:	85 c0                	test   %eax,%eax
  803c64:	78 21                	js     803c87 <_ZL12alloc_sockfdi+0x40>
  803c66:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803c6d:	00 
  803c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c7c:	e8 1f d3 ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
  803c81:	89 c3                	mov    %eax,%ebx
  803c83:	85 c0                	test   %eax,%eax
  803c85:	79 14                	jns    803c9b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803c87:	89 34 24             	mov    %esi,(%esp)
  803c8a:	e8 58 02 00 00       	call   803ee7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803c8f:	89 d8                	mov    %ebx,%eax
  803c91:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803c94:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803c97:	89 ec                	mov    %ebp,%esp
  803c99:	5d                   	pop    %ebp
  803c9a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803c9b:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  803ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803cb0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803cb3:	89 04 24             	mov    %eax,(%esp)
  803cb6:	e8 e9 dd ff ff       	call   801aa4 <_Z6fd2numP2Fd>
  803cbb:	89 c3                	mov    %eax,%ebx
  803cbd:	eb d0                	jmp    803c8f <_ZL12alloc_sockfdi+0x48>

00803cbf <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803cbf:	55                   	push   %ebp
  803cc0:	89 e5                	mov    %esp,%ebp
  803cc2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803cc5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803ccc:	00 
  803ccd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803cd0:	89 54 24 04          	mov    %edx,0x4(%esp)
  803cd4:	89 04 24             	mov    %eax,(%esp)
  803cd7:	e8 75 dd ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  803cdc:	85 c0                	test   %eax,%eax
  803cde:	78 15                	js     803cf5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803ce3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803ce8:	8b 0d 3c 60 80 00    	mov    0x80603c,%ecx
  803cee:	39 0a                	cmp    %ecx,(%edx)
  803cf0:	75 03                	jne    803cf5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803cf2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803cf5:	c9                   	leave  
  803cf6:	c3                   	ret    

00803cf7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803cf7:	55                   	push   %ebp
  803cf8:	89 e5                	mov    %esp,%ebp
  803cfa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803d00:	e8 ba ff ff ff       	call   803cbf <_ZL9fd2sockidi>
  803d05:	85 c0                	test   %eax,%eax
  803d07:	78 1f                	js     803d28 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803d09:	8b 55 10             	mov    0x10(%ebp),%edx
  803d0c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d13:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d17:	89 04 24             	mov    %eax,(%esp)
  803d1a:	e8 19 01 00 00       	call   803e38 <_Z12nsipc_acceptiP8sockaddrPj>
  803d1f:	85 c0                	test   %eax,%eax
  803d21:	78 05                	js     803d28 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803d23:	e8 1f ff ff ff       	call   803c47 <_ZL12alloc_sockfdi>
}
  803d28:	c9                   	leave  
  803d29:	c3                   	ret    

00803d2a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803d2a:	55                   	push   %ebp
  803d2b:	89 e5                	mov    %esp,%ebp
  803d2d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d30:	8b 45 08             	mov    0x8(%ebp),%eax
  803d33:	e8 87 ff ff ff       	call   803cbf <_ZL9fd2sockidi>
  803d38:	85 c0                	test   %eax,%eax
  803d3a:	78 16                	js     803d52 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803d3c:	8b 55 10             	mov    0x10(%ebp),%edx
  803d3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d46:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d4a:	89 04 24             	mov    %eax,(%esp)
  803d4d:	e8 34 01 00 00       	call   803e86 <_Z10nsipc_bindiP8sockaddrj>
}
  803d52:	c9                   	leave  
  803d53:	c3                   	ret    

00803d54 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803d54:	55                   	push   %ebp
  803d55:	89 e5                	mov    %esp,%ebp
  803d57:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5d:	e8 5d ff ff ff       	call   803cbf <_ZL9fd2sockidi>
  803d62:	85 c0                	test   %eax,%eax
  803d64:	78 0f                	js     803d75 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d69:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d6d:	89 04 24             	mov    %eax,(%esp)
  803d70:	e8 50 01 00 00       	call   803ec5 <_Z14nsipc_shutdownii>
}
  803d75:	c9                   	leave  
  803d76:	c3                   	ret    

00803d77 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d77:	55                   	push   %ebp
  803d78:	89 e5                	mov    %esp,%ebp
  803d7a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d80:	e8 3a ff ff ff       	call   803cbf <_ZL9fd2sockidi>
  803d85:	85 c0                	test   %eax,%eax
  803d87:	78 16                	js     803d9f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803d89:	8b 55 10             	mov    0x10(%ebp),%edx
  803d8c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d93:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d97:	89 04 24             	mov    %eax,(%esp)
  803d9a:	e8 62 01 00 00       	call   803f01 <_Z13nsipc_connectiPK8sockaddrj>
}
  803d9f:	c9                   	leave  
  803da0:	c3                   	ret    

00803da1 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803da1:	55                   	push   %ebp
  803da2:	89 e5                	mov    %esp,%ebp
  803da4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803da7:	8b 45 08             	mov    0x8(%ebp),%eax
  803daa:	e8 10 ff ff ff       	call   803cbf <_ZL9fd2sockidi>
  803daf:	85 c0                	test   %eax,%eax
  803db1:	78 0f                	js     803dc2 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  803db6:	89 54 24 04          	mov    %edx,0x4(%esp)
  803dba:	89 04 24             	mov    %eax,(%esp)
  803dbd:	e8 7e 01 00 00       	call   803f40 <_Z12nsipc_listenii>
}
  803dc2:	c9                   	leave  
  803dc3:	c3                   	ret    

00803dc4 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803dc4:	55                   	push   %ebp
  803dc5:	89 e5                	mov    %esp,%ebp
  803dc7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803dca:	8b 45 10             	mov    0x10(%ebp),%eax
  803dcd:	89 44 24 08          	mov    %eax,0x8(%esp)
  803dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ddb:	89 04 24             	mov    %eax,(%esp)
  803dde:	e8 72 02 00 00       	call   804055 <_Z12nsipc_socketiii>
  803de3:	85 c0                	test   %eax,%eax
  803de5:	78 05                	js     803dec <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803de7:	e8 5b fe ff ff       	call   803c47 <_ZL12alloc_sockfdi>
}
  803dec:	c9                   	leave  
  803ded:	8d 76 00             	lea    0x0(%esi),%esi
  803df0:	c3                   	ret    
  803df1:	00 00                	add    %al,(%eax)
	...

00803df4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803df4:	55                   	push   %ebp
  803df5:	89 e5                	mov    %esp,%ebp
  803df7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803dfa:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803e01:	00 
  803e02:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803e09:	00 
  803e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e0e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803e15:	e8 45 db ff ff       	call   80195f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803e1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803e21:	00 
  803e22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803e29:	00 
  803e2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e31:	e8 9a da ff ff       	call   8018d0 <_Z8ipc_recvPiPvS_>
}
  803e36:	c9                   	leave  
  803e37:	c3                   	ret    

00803e38 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803e38:	55                   	push   %ebp
  803e39:	89 e5                	mov    %esp,%ebp
  803e3b:	53                   	push   %ebx
  803e3c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e42:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803e47:	b8 01 00 00 00       	mov    $0x1,%eax
  803e4c:	e8 a3 ff ff ff       	call   803df4 <_ZL5nsipcj>
  803e51:	89 c3                	mov    %eax,%ebx
  803e53:	85 c0                	test   %eax,%eax
  803e55:	78 27                	js     803e7e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803e57:	a1 10 80 80 00       	mov    0x808010,%eax
  803e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803e60:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803e67:	00 
  803e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e6b:	89 04 24             	mov    %eax,(%esp)
  803e6e:	e8 e9 cd ff ff       	call   800c5c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803e73:	8b 15 10 80 80 00    	mov    0x808010,%edx
  803e79:	8b 45 10             	mov    0x10(%ebp),%eax
  803e7c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803e7e:	89 d8                	mov    %ebx,%eax
  803e80:	83 c4 14             	add    $0x14,%esp
  803e83:	5b                   	pop    %ebx
  803e84:	5d                   	pop    %ebp
  803e85:	c3                   	ret    

00803e86 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803e86:	55                   	push   %ebp
  803e87:	89 e5                	mov    %esp,%ebp
  803e89:	53                   	push   %ebx
  803e8a:	83 ec 14             	sub    $0x14,%esp
  803e8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803e90:	8b 45 08             	mov    0x8(%ebp),%eax
  803e93:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803e98:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ea3:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803eaa:	e8 ad cd ff ff       	call   800c5c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803eaf:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803eb5:	b8 02 00 00 00       	mov    $0x2,%eax
  803eba:	e8 35 ff ff ff       	call   803df4 <_ZL5nsipcj>
}
  803ebf:	83 c4 14             	add    $0x14,%esp
  803ec2:	5b                   	pop    %ebx
  803ec3:	5d                   	pop    %ebp
  803ec4:	c3                   	ret    

00803ec5 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803ec5:	55                   	push   %ebp
  803ec6:	89 e5                	mov    %esp,%ebp
  803ec8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ece:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ed6:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803edb:	b8 03 00 00 00       	mov    $0x3,%eax
  803ee0:	e8 0f ff ff ff       	call   803df4 <_ZL5nsipcj>
}
  803ee5:	c9                   	leave  
  803ee6:	c3                   	ret    

00803ee7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803ee7:	55                   	push   %ebp
  803ee8:	89 e5                	mov    %esp,%ebp
  803eea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803eed:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef0:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803ef5:	b8 04 00 00 00       	mov    $0x4,%eax
  803efa:	e8 f5 fe ff ff       	call   803df4 <_ZL5nsipcj>
}
  803eff:	c9                   	leave  
  803f00:	c3                   	ret    

00803f01 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803f01:	55                   	push   %ebp
  803f02:	89 e5                	mov    %esp,%ebp
  803f04:	53                   	push   %ebx
  803f05:	83 ec 14             	sub    $0x14,%esp
  803f08:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803f13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f1e:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803f25:	e8 32 cd ff ff       	call   800c5c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803f2a:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  803f30:	b8 05 00 00 00       	mov    $0x5,%eax
  803f35:	e8 ba fe ff ff       	call   803df4 <_ZL5nsipcj>
}
  803f3a:	83 c4 14             	add    $0x14,%esp
  803f3d:	5b                   	pop    %ebx
  803f3e:	5d                   	pop    %ebp
  803f3f:	c3                   	ret    

00803f40 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  803f40:	55                   	push   %ebp
  803f41:	89 e5                	mov    %esp,%ebp
  803f43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803f46:	8b 45 08             	mov    0x8(%ebp),%eax
  803f49:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f51:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803f56:	b8 06 00 00 00       	mov    $0x6,%eax
  803f5b:	e8 94 fe ff ff       	call   803df4 <_ZL5nsipcj>
}
  803f60:	c9                   	leave  
  803f61:	c3                   	ret    

00803f62 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803f62:	55                   	push   %ebp
  803f63:	89 e5                	mov    %esp,%ebp
  803f65:	56                   	push   %esi
  803f66:	53                   	push   %ebx
  803f67:	83 ec 10             	sub    $0x10,%esp
  803f6a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f70:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803f75:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803f7b:	8b 45 14             	mov    0x14(%ebp),%eax
  803f7e:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803f83:	b8 07 00 00 00       	mov    $0x7,%eax
  803f88:	e8 67 fe ff ff       	call   803df4 <_ZL5nsipcj>
  803f8d:	89 c3                	mov    %eax,%ebx
  803f8f:	85 c0                	test   %eax,%eax
  803f91:	78 46                	js     803fd9 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  803f93:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803f98:	7f 04                	jg     803f9e <_Z10nsipc_recviPvij+0x3c>
  803f9a:	39 f0                	cmp    %esi,%eax
  803f9c:	7e 24                	jle    803fc2 <_Z10nsipc_recviPvij+0x60>
  803f9e:	c7 44 24 0c af 51 80 	movl   $0x8051af,0xc(%esp)
  803fa5:	00 
  803fa6:	c7 44 24 08 1b 4b 80 	movl   $0x804b1b,0x8(%esp)
  803fad:	00 
  803fae:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  803fb5:	00 
  803fb6:	c7 04 24 c4 51 80 00 	movl   $0x8051c4,(%esp)
  803fbd:	e8 c6 c3 ff ff       	call   800388 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803fc2:	89 44 24 08          	mov    %eax,0x8(%esp)
  803fc6:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803fcd:	00 
  803fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fd1:	89 04 24             	mov    %eax,(%esp)
  803fd4:	e8 83 cc ff ff       	call   800c5c <memmove>
	}

	return r;
}
  803fd9:	89 d8                	mov    %ebx,%eax
  803fdb:	83 c4 10             	add    $0x10,%esp
  803fde:	5b                   	pop    %ebx
  803fdf:	5e                   	pop    %esi
  803fe0:	5d                   	pop    %ebp
  803fe1:	c3                   	ret    

00803fe2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803fe2:	55                   	push   %ebp
  803fe3:	89 e5                	mov    %esp,%ebp
  803fe5:	53                   	push   %ebx
  803fe6:	83 ec 14             	sub    $0x14,%esp
  803fe9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803fec:	8b 45 08             	mov    0x8(%ebp),%eax
  803fef:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  803ff4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803ffa:	7e 24                	jle    804020 <_Z10nsipc_sendiPKvij+0x3e>
  803ffc:	c7 44 24 0c d0 51 80 	movl   $0x8051d0,0xc(%esp)
  804003:	00 
  804004:	c7 44 24 08 1b 4b 80 	movl   $0x804b1b,0x8(%esp)
  80400b:	00 
  80400c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  804013:	00 
  804014:	c7 04 24 c4 51 80 00 	movl   $0x8051c4,(%esp)
  80401b:	e8 68 c3 ff ff       	call   800388 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804020:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804024:	8b 45 0c             	mov    0xc(%ebp),%eax
  804027:	89 44 24 04          	mov    %eax,0x4(%esp)
  80402b:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  804032:	e8 25 cc ff ff       	call   800c5c <memmove>
	nsipcbuf.send.req_size = size;
  804037:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  80403d:	8b 45 14             	mov    0x14(%ebp),%eax
  804040:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  804045:	b8 08 00 00 00       	mov    $0x8,%eax
  80404a:	e8 a5 fd ff ff       	call   803df4 <_ZL5nsipcj>
}
  80404f:	83 c4 14             	add    $0x14,%esp
  804052:	5b                   	pop    %ebx
  804053:	5d                   	pop    %ebp
  804054:	c3                   	ret    

00804055 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804055:	55                   	push   %ebp
  804056:	89 e5                	mov    %esp,%ebp
  804058:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80405b:	8b 45 08             	mov    0x8(%ebp),%eax
  80405e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  804063:	8b 45 0c             	mov    0xc(%ebp),%eax
  804066:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  80406b:	8b 45 10             	mov    0x10(%ebp),%eax
  80406e:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  804073:	b8 09 00 00 00       	mov    $0x9,%eax
  804078:	e8 77 fd ff ff       	call   803df4 <_ZL5nsipcj>
}
  80407d:	c9                   	leave  
  80407e:	c3                   	ret    
	...

00804080 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  804080:	55                   	push   %ebp
  804081:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  804083:	b8 00 00 00 00       	mov    $0x0,%eax
  804088:	5d                   	pop    %ebp
  804089:	c3                   	ret    

0080408a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80408a:	55                   	push   %ebp
  80408b:	89 e5                	mov    %esp,%ebp
  80408d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804090:	c7 44 24 04 dc 51 80 	movl   $0x8051dc,0x4(%esp)
  804097:	00 
  804098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80409b:	89 04 24             	mov    %eax,(%esp)
  80409e:	e8 17 ca ff ff       	call   800aba <_Z6strcpyPcPKc>
	return 0;
}
  8040a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a8:	c9                   	leave  
  8040a9:	c3                   	ret    

008040aa <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040aa:	55                   	push   %ebp
  8040ab:	89 e5                	mov    %esp,%ebp
  8040ad:	57                   	push   %edi
  8040ae:	56                   	push   %esi
  8040af:	53                   	push   %ebx
  8040b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8040bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8040bf:	74 3e                	je     8040ff <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8040c1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8040c7:	8b 75 10             	mov    0x10(%ebp),%esi
  8040ca:	29 de                	sub    %ebx,%esi
  8040cc:	83 fe 7f             	cmp    $0x7f,%esi
  8040cf:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8040d4:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8040d7:	89 74 24 08          	mov    %esi,0x8(%esp)
  8040db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040de:	01 d8                	add    %ebx,%eax
  8040e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040e4:	89 3c 24             	mov    %edi,(%esp)
  8040e7:	e8 70 cb ff ff       	call   800c5c <memmove>
		sys_cputs(buf, m);
  8040ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8040f0:	89 3c 24             	mov    %edi,(%esp)
  8040f3:	e8 7c cd ff ff       	call   800e74 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040f8:	01 f3                	add    %esi,%ebx
  8040fa:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  8040fd:	77 c8                	ja     8040c7 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8040ff:	89 d8                	mov    %ebx,%eax
  804101:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  804107:	5b                   	pop    %ebx
  804108:	5e                   	pop    %esi
  804109:	5f                   	pop    %edi
  80410a:	5d                   	pop    %ebp
  80410b:	c3                   	ret    

0080410c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80410c:	55                   	push   %ebp
  80410d:	89 e5                	mov    %esp,%ebp
  80410f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  804112:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  804117:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80411b:	75 07                	jne    804124 <_ZL12devcons_readP2FdPvj+0x18>
  80411d:	eb 2a                	jmp    804149 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80411f:	e8 48 ce ff ff       	call   800f6c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804124:	e8 7e cd ff ff       	call   800ea7 <_Z9sys_cgetcv>
  804129:	85 c0                	test   %eax,%eax
  80412b:	74 f2                	je     80411f <_ZL12devcons_readP2FdPvj+0x13>
  80412d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80412f:	85 c0                	test   %eax,%eax
  804131:	78 16                	js     804149 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  804133:	83 f8 04             	cmp    $0x4,%eax
  804136:	74 0c                	je     804144 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  804138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80413b:	88 10                	mov    %dl,(%eax)
	return 1;
  80413d:	b8 01 00 00 00       	mov    $0x1,%eax
  804142:	eb 05                	jmp    804149 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  804144:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  804149:	c9                   	leave  
  80414a:	c3                   	ret    

0080414b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80414b:	55                   	push   %ebp
  80414c:	89 e5                	mov    %esp,%ebp
  80414e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  804151:	8b 45 08             	mov    0x8(%ebp),%eax
  804154:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804157:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80415e:	00 
  80415f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804162:	89 04 24             	mov    %eax,(%esp)
  804165:	e8 0a cd ff ff       	call   800e74 <_Z9sys_cputsPKcj>
}
  80416a:	c9                   	leave  
  80416b:	c3                   	ret    

0080416c <_Z7getcharv>:

int
getchar(void)
{
  80416c:	55                   	push   %ebp
  80416d:	89 e5                	mov    %esp,%ebp
  80416f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804172:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804179:	00 
  80417a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80417d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804181:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804188:	e8 71 dc ff ff       	call   801dfe <_Z4readiPvj>
	if (r < 0)
  80418d:	85 c0                	test   %eax,%eax
  80418f:	78 0f                	js     8041a0 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  804191:	85 c0                	test   %eax,%eax
  804193:	7e 06                	jle    80419b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  804195:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804199:	eb 05                	jmp    8041a0 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80419b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8041a0:	c9                   	leave  
  8041a1:	c3                   	ret    

008041a2 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  8041a2:	55                   	push   %ebp
  8041a3:	89 e5                	mov    %esp,%ebp
  8041a5:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8041a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8041af:	00 
  8041b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8041b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ba:	89 04 24             	mov    %eax,(%esp)
  8041bd:	e8 8f d8 ff ff       	call   801a51 <_Z9fd_lookupiPP2Fdb>
  8041c2:	85 c0                	test   %eax,%eax
  8041c4:	78 11                	js     8041d7 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  8041c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041c9:	8b 15 58 60 80 00    	mov    0x806058,%edx
  8041cf:	39 10                	cmp    %edx,(%eax)
  8041d1:	0f 94 c0             	sete   %al
  8041d4:	0f b6 c0             	movzbl %al,%eax
}
  8041d7:	c9                   	leave  
  8041d8:	c3                   	ret    

008041d9 <_Z8openconsv>:

int
opencons(void)
{
  8041d9:	55                   	push   %ebp
  8041da:	89 e5                	mov    %esp,%ebp
  8041dc:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  8041df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8041e2:	89 04 24             	mov    %eax,(%esp)
  8041e5:	e8 1d d9 ff ff       	call   801b07 <_Z14fd_find_unusedPP2Fd>
  8041ea:	85 c0                	test   %eax,%eax
  8041ec:	78 3c                	js     80422a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8041ee:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8041f5:	00 
  8041f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804204:	e8 97 cd ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
  804209:	85 c0                	test   %eax,%eax
  80420b:	78 1d                	js     80422a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80420d:	8b 15 58 60 80 00    	mov    0x806058,%edx
  804213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804216:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  804218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80421b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  804222:	89 04 24             	mov    %eax,(%esp)
  804225:	e8 7a d8 ff ff       	call   801aa4 <_Z6fd2numP2Fd>
}
  80422a:	c9                   	leave  
  80422b:	c3                   	ret    
  80422c:	00 00                	add    %al,(%eax)
	...

00804230 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  804230:	55                   	push   %ebp
  804231:	89 e5                	mov    %esp,%ebp
  804233:	56                   	push   %esi
  804234:	53                   	push   %ebx
  804235:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804238:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  80423d:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  804244:	85 c0                	test   %eax,%eax
  804246:	74 08                	je     804250 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  804248:	8d 55 08             	lea    0x8(%ebp),%edx
  80424b:	89 14 24             	mov    %edx,(%esp)
  80424e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804250:	83 eb 01             	sub    $0x1,%ebx
  804253:	83 fb ff             	cmp    $0xffffffff,%ebx
  804256:	75 e5                	jne    80423d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  804258:	8b 5d 38             	mov    0x38(%ebp),%ebx
  80425b:	8b 75 08             	mov    0x8(%ebp),%esi
  80425e:	e8 d5 cc ff ff       	call   800f38 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  804263:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  804267:	89 74 24 10          	mov    %esi,0x10(%esp)
  80426b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80426f:	c7 44 24 08 e8 51 80 	movl   $0x8051e8,0x8(%esp)
  804276:	00 
  804277:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80427e:	00 
  80427f:	c7 04 24 6c 52 80 00 	movl   $0x80526c,(%esp)
  804286:	e8 fd c0 ff ff       	call   800388 <_Z6_panicPKciS0_z>

0080428b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  80428b:	55                   	push   %ebp
  80428c:	89 e5                	mov    %esp,%ebp
  80428e:	56                   	push   %esi
  80428f:	53                   	push   %ebx
  804290:	83 ec 10             	sub    $0x10,%esp
  804293:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804296:	e8 9d cc ff ff       	call   800f38 <_Z12sys_getenvidv>
  80429b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80429d:	a1 04 70 80 00       	mov    0x807004,%eax
  8042a2:	8b 40 5c             	mov    0x5c(%eax),%eax
  8042a5:	85 c0                	test   %eax,%eax
  8042a7:	75 4c                	jne    8042f5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  8042a9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8042b0:	00 
  8042b1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8042b8:	ee 
  8042b9:	89 34 24             	mov    %esi,(%esp)
  8042bc:	e8 df cc ff ff       	call   800fa0 <_Z14sys_page_allociPvi>
  8042c1:	85 c0                	test   %eax,%eax
  8042c3:	74 20                	je     8042e5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  8042c5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8042c9:	c7 44 24 08 20 52 80 	movl   $0x805220,0x8(%esp)
  8042d0:	00 
  8042d1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8042d8:	00 
  8042d9:	c7 04 24 6c 52 80 00 	movl   $0x80526c,(%esp)
  8042e0:	e8 a3 c0 ff ff       	call   800388 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  8042e5:	c7 44 24 04 30 42 80 	movl   $0x804230,0x4(%esp)
  8042ec:	00 
  8042ed:	89 34 24             	mov    %esi,(%esp)
  8042f0:	e8 e0 ce ff ff       	call   8011d5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  8042f5:	a1 00 90 80 00       	mov    0x809000,%eax
  8042fa:	39 d8                	cmp    %ebx,%eax
  8042fc:	74 1a                	je     804318 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  8042fe:	85 c0                	test   %eax,%eax
  804300:	74 20                	je     804322 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804302:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804307:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  80430e:	39 da                	cmp    %ebx,%edx
  804310:	74 15                	je     804327 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804312:	85 d2                	test   %edx,%edx
  804314:	75 1f                	jne    804335 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804316:	eb 0f                	jmp    804327 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804318:	b8 00 00 00 00       	mov    $0x0,%eax
  80431d:	8d 76 00             	lea    0x0(%esi),%esi
  804320:	eb 05                	jmp    804327 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804322:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804327:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80432e:	83 c4 10             	add    $0x10,%esp
  804331:	5b                   	pop    %ebx
  804332:	5e                   	pop    %esi
  804333:	5d                   	pop    %ebp
  804334:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804335:	83 c0 01             	add    $0x1,%eax
  804338:	83 f8 08             	cmp    $0x8,%eax
  80433b:	75 ca                	jne    804307 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80433d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804341:	c7 44 24 08 44 52 80 	movl   $0x805244,0x8(%esp)
  804348:	00 
  804349:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804350:	00 
  804351:	c7 04 24 6c 52 80 00 	movl   $0x80526c,(%esp)
  804358:	e8 2b c0 ff ff       	call   800388 <_Z6_panicPKciS0_z>
  80435d:	00 00                	add    %al,(%eax)
	...

00804360 <resume>:
  804360:	83 c4 04             	add    $0x4,%esp
  804363:	5c                   	pop    %esp
  804364:	83 c4 08             	add    $0x8,%esp
  804367:	8b 44 24 28          	mov    0x28(%esp),%eax
  80436b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  80436f:	83 eb 04             	sub    $0x4,%ebx
  804372:	89 03                	mov    %eax,(%ebx)
  804374:	89 5c 24 24          	mov    %ebx,0x24(%esp)
  804378:	61                   	popa   
  804379:	9d                   	popf   
  80437a:	5c                   	pop    %esp
  80437b:	c3                   	ret    

0080437c <spin>:
  80437c:	eb fe                	jmp    80437c <spin>
	...

00804380 <__udivdi3>:
  804380:	55                   	push   %ebp
  804381:	89 e5                	mov    %esp,%ebp
  804383:	57                   	push   %edi
  804384:	56                   	push   %esi
  804385:	83 ec 20             	sub    $0x20,%esp
  804388:	8b 45 14             	mov    0x14(%ebp),%eax
  80438b:	8b 75 08             	mov    0x8(%ebp),%esi
  80438e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804391:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804394:	85 c0                	test   %eax,%eax
  804396:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804399:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80439c:	75 3a                	jne    8043d8 <__udivdi3+0x58>
  80439e:	39 f9                	cmp    %edi,%ecx
  8043a0:	77 66                	ja     804408 <__udivdi3+0x88>
  8043a2:	85 c9                	test   %ecx,%ecx
  8043a4:	75 0b                	jne    8043b1 <__udivdi3+0x31>
  8043a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8043ab:	31 d2                	xor    %edx,%edx
  8043ad:	f7 f1                	div    %ecx
  8043af:	89 c1                	mov    %eax,%ecx
  8043b1:	89 f8                	mov    %edi,%eax
  8043b3:	31 d2                	xor    %edx,%edx
  8043b5:	f7 f1                	div    %ecx
  8043b7:	89 c7                	mov    %eax,%edi
  8043b9:	89 f0                	mov    %esi,%eax
  8043bb:	f7 f1                	div    %ecx
  8043bd:	89 fa                	mov    %edi,%edx
  8043bf:	89 c6                	mov    %eax,%esi
  8043c1:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8043c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8043c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043cd:	83 c4 20             	add    $0x20,%esp
  8043d0:	5e                   	pop    %esi
  8043d1:	5f                   	pop    %edi
  8043d2:	5d                   	pop    %ebp
  8043d3:	c3                   	ret    
  8043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8043d8:	31 d2                	xor    %edx,%edx
  8043da:	31 f6                	xor    %esi,%esi
  8043dc:	39 f8                	cmp    %edi,%eax
  8043de:	77 e1                	ja     8043c1 <__udivdi3+0x41>
  8043e0:	0f bd d0             	bsr    %eax,%edx
  8043e3:	83 f2 1f             	xor    $0x1f,%edx
  8043e6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8043e9:	75 2d                	jne    804418 <__udivdi3+0x98>
  8043eb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8043ee:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  8043f1:	76 06                	jbe    8043f9 <__udivdi3+0x79>
  8043f3:	39 f8                	cmp    %edi,%eax
  8043f5:	89 f2                	mov    %esi,%edx
  8043f7:	73 c8                	jae    8043c1 <__udivdi3+0x41>
  8043f9:	31 d2                	xor    %edx,%edx
  8043fb:	be 01 00 00 00       	mov    $0x1,%esi
  804400:	eb bf                	jmp    8043c1 <__udivdi3+0x41>
  804402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804408:	89 f0                	mov    %esi,%eax
  80440a:	89 fa                	mov    %edi,%edx
  80440c:	f7 f1                	div    %ecx
  80440e:	31 d2                	xor    %edx,%edx
  804410:	89 c6                	mov    %eax,%esi
  804412:	eb ad                	jmp    8043c1 <__udivdi3+0x41>
  804414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804418:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80441c:	89 c2                	mov    %eax,%edx
  80441e:	b8 20 00 00 00       	mov    $0x20,%eax
  804423:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804426:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804429:	d3 e2                	shl    %cl,%edx
  80442b:	89 c1                	mov    %eax,%ecx
  80442d:	d3 ee                	shr    %cl,%esi
  80442f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804433:	09 d6                	or     %edx,%esi
  804435:	89 fa                	mov    %edi,%edx
  804437:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80443a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80443d:	d3 e6                	shl    %cl,%esi
  80443f:	89 c1                	mov    %eax,%ecx
  804441:	d3 ea                	shr    %cl,%edx
  804443:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804447:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80444a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80444d:	d3 e7                	shl    %cl,%edi
  80444f:	89 c1                	mov    %eax,%ecx
  804451:	d3 ee                	shr    %cl,%esi
  804453:	09 fe                	or     %edi,%esi
  804455:	89 f0                	mov    %esi,%eax
  804457:	f7 75 e4             	divl   -0x1c(%ebp)
  80445a:	89 d7                	mov    %edx,%edi
  80445c:	89 c6                	mov    %eax,%esi
  80445e:	f7 65 f0             	mull   -0x10(%ebp)
  804461:	39 d7                	cmp    %edx,%edi
  804463:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804466:	72 12                	jb     80447a <__udivdi3+0xfa>
  804468:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80446b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80446f:	d3 e2                	shl    %cl,%edx
  804471:	39 c2                	cmp    %eax,%edx
  804473:	73 08                	jae    80447d <__udivdi3+0xfd>
  804475:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804478:	75 03                	jne    80447d <__udivdi3+0xfd>
  80447a:	83 ee 01             	sub    $0x1,%esi
  80447d:	31 d2                	xor    %edx,%edx
  80447f:	e9 3d ff ff ff       	jmp    8043c1 <__udivdi3+0x41>
	...

00804490 <__umoddi3>:
  804490:	55                   	push   %ebp
  804491:	89 e5                	mov    %esp,%ebp
  804493:	57                   	push   %edi
  804494:	56                   	push   %esi
  804495:	83 ec 20             	sub    $0x20,%esp
  804498:	8b 7d 14             	mov    0x14(%ebp),%edi
  80449b:	8b 45 08             	mov    0x8(%ebp),%eax
  80449e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8044a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8044a4:	85 ff                	test   %edi,%edi
  8044a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8044a9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8044ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8044af:	89 f2                	mov    %esi,%edx
  8044b1:	75 15                	jne    8044c8 <__umoddi3+0x38>
  8044b3:	39 f1                	cmp    %esi,%ecx
  8044b5:	76 41                	jbe    8044f8 <__umoddi3+0x68>
  8044b7:	f7 f1                	div    %ecx
  8044b9:	89 d0                	mov    %edx,%eax
  8044bb:	31 d2                	xor    %edx,%edx
  8044bd:	83 c4 20             	add    $0x20,%esp
  8044c0:	5e                   	pop    %esi
  8044c1:	5f                   	pop    %edi
  8044c2:	5d                   	pop    %ebp
  8044c3:	c3                   	ret    
  8044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8044c8:	39 f7                	cmp    %esi,%edi
  8044ca:	77 4c                	ja     804518 <__umoddi3+0x88>
  8044cc:	0f bd c7             	bsr    %edi,%eax
  8044cf:	83 f0 1f             	xor    $0x1f,%eax
  8044d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8044d5:	75 51                	jne    804528 <__umoddi3+0x98>
  8044d7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  8044da:	0f 87 e8 00 00 00    	ja     8045c8 <__umoddi3+0x138>
  8044e0:	89 f2                	mov    %esi,%edx
  8044e2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8044e5:	29 ce                	sub    %ecx,%esi
  8044e7:	19 fa                	sbb    %edi,%edx
  8044e9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8044ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044ef:	83 c4 20             	add    $0x20,%esp
  8044f2:	5e                   	pop    %esi
  8044f3:	5f                   	pop    %edi
  8044f4:	5d                   	pop    %ebp
  8044f5:	c3                   	ret    
  8044f6:	66 90                	xchg   %ax,%ax
  8044f8:	85 c9                	test   %ecx,%ecx
  8044fa:	75 0b                	jne    804507 <__umoddi3+0x77>
  8044fc:	b8 01 00 00 00       	mov    $0x1,%eax
  804501:	31 d2                	xor    %edx,%edx
  804503:	f7 f1                	div    %ecx
  804505:	89 c1                	mov    %eax,%ecx
  804507:	89 f0                	mov    %esi,%eax
  804509:	31 d2                	xor    %edx,%edx
  80450b:	f7 f1                	div    %ecx
  80450d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804510:	eb a5                	jmp    8044b7 <__umoddi3+0x27>
  804512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804518:	89 f2                	mov    %esi,%edx
  80451a:	83 c4 20             	add    $0x20,%esp
  80451d:	5e                   	pop    %esi
  80451e:	5f                   	pop    %edi
  80451f:	5d                   	pop    %ebp
  804520:	c3                   	ret    
  804521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804528:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80452c:	89 f2                	mov    %esi,%edx
  80452e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804531:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804538:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80453b:	d3 e7                	shl    %cl,%edi
  80453d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804540:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804544:	d3 e8                	shr    %cl,%eax
  804546:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80454a:	09 f8                	or     %edi,%eax
  80454c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804552:	d3 e0                	shl    %cl,%eax
  804554:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804558:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80455b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80455e:	d3 ea                	shr    %cl,%edx
  804560:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804564:	d3 e6                	shl    %cl,%esi
  804566:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80456a:	d3 e8                	shr    %cl,%eax
  80456c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804570:	09 f0                	or     %esi,%eax
  804572:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804575:	f7 75 e4             	divl   -0x1c(%ebp)
  804578:	d3 e6                	shl    %cl,%esi
  80457a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80457d:	89 d6                	mov    %edx,%esi
  80457f:	f7 65 f4             	mull   -0xc(%ebp)
  804582:	89 d7                	mov    %edx,%edi
  804584:	89 c2                	mov    %eax,%edx
  804586:	39 fe                	cmp    %edi,%esi
  804588:	89 f9                	mov    %edi,%ecx
  80458a:	72 30                	jb     8045bc <__umoddi3+0x12c>
  80458c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80458f:	72 27                	jb     8045b8 <__umoddi3+0x128>
  804591:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804594:	29 d0                	sub    %edx,%eax
  804596:	19 ce                	sbb    %ecx,%esi
  804598:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80459c:	89 f2                	mov    %esi,%edx
  80459e:	d3 e8                	shr    %cl,%eax
  8045a0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8045a4:	d3 e2                	shl    %cl,%edx
  8045a6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8045aa:	09 d0                	or     %edx,%eax
  8045ac:	89 f2                	mov    %esi,%edx
  8045ae:	d3 ea                	shr    %cl,%edx
  8045b0:	83 c4 20             	add    $0x20,%esp
  8045b3:	5e                   	pop    %esi
  8045b4:	5f                   	pop    %edi
  8045b5:	5d                   	pop    %ebp
  8045b6:	c3                   	ret    
  8045b7:	90                   	nop
  8045b8:	39 fe                	cmp    %edi,%esi
  8045ba:	75 d5                	jne    804591 <__umoddi3+0x101>
  8045bc:	89 f9                	mov    %edi,%ecx
  8045be:	89 c2                	mov    %eax,%edx
  8045c0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  8045c3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8045c6:	eb c9                	jmp    804591 <__umoddi3+0x101>
  8045c8:	39 f7                	cmp    %esi,%edi
  8045ca:	0f 82 10 ff ff ff    	jb     8044e0 <__umoddi3+0x50>
  8045d0:	e9 17 ff ff ff       	jmp    8044ec <__umoddi3+0x5c>
