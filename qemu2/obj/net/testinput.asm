
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 d3 05 00 00       	call   800604 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <_Z5umainiPPc>:
	}
}

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	envid_t ns_envid = sys_getenvid();
  80004c:	e8 e7 11 00 00       	call   801238 <_Z12sys_getenvidv>
  800051:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800053:	c7 05 00 60 80 00 20 	movl   $0x804c20,0x806000
  80005a:	4c 80 00 

	output_envid = fork();
  80005d:	e8 7b 18 00 00       	call   8018dd <_Z4forkv>
  800062:	a3 00 70 80 00       	mov    %eax,0x807000
	if (output_envid < 0)
  800067:	85 c0                	test   %eax,%eax
  800069:	79 1c                	jns    800087 <_Z5umainiPPc+0x47>
		panic("error forking");
  80006b:	c7 44 24 08 2a 4c 80 	movl   $0x804c2a,0x8(%esp)
  800072:	00 
  800073:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  80007a:	00 
  80007b:	c7 04 24 38 4c 80 00 	movl   $0x804c38,(%esp)
  800082:	e8 01 06 00 00       	call   800688 <_Z6_panicPKciS0_z>
	else if (output_envid == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 0d                	jne    800098 <_Z5umainiPPc+0x58>
		output(ns_envid);
  80008b:	89 1c 24             	mov    %ebx,(%esp)
  80008e:	e8 21 05 00 00       	call   8005b4 <_Z6outputi>
		return;
  800093:	e9 bb 03 00 00       	jmp    800453 <_Z5umainiPPc+0x413>
	}

	input_envid = fork();
  800098:	e8 40 18 00 00       	call   8018dd <_Z4forkv>
  80009d:	a3 04 70 80 00       	mov    %eax,0x807004
	if (input_envid < 0)
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	79 1c                	jns    8000c2 <_Z5umainiPPc+0x82>
		panic("error forking");
  8000a6:	c7 44 24 08 2a 4c 80 	movl   $0x804c2a,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 38 4c 80 00 	movl   $0x804c38,(%esp)
  8000bd:	e8 c6 05 00 00       	call   800688 <_Z6_panicPKciS0_z>
	else if (input_envid == 0) {
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	75 0f                	jne    8000d5 <_Z5umainiPPc+0x95>
		input(ns_envid);
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 5a 04 00 00       	call   800528 <_Z5inputi>
  8000ce:	66 90                	xchg   %ax,%ax
  8000d0:	e9 7e 03 00 00       	jmp    800453 <_Z5umainiPPc+0x413>
		return;
	}

	cprintf("Sending ARP announcement...\n");
  8000d5:	c7 04 24 48 4c 80 00 	movl   $0x804c48,(%esp)
  8000dc:	e8 c5 06 00 00       	call   8007a6 <_Z7cprintfPKcz>
	// with ARP requests.  Ideally, we would use gratuitous ARP
	// for this, but QEMU's ARP implementation is dumb and only
	// listens for very specific ARP requests, such as requests
	// for the gateway IP.

	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  8000e1:	c6 45 90 52          	movb   $0x52,-0x70(%ebp)
  8000e5:	c6 45 91 54          	movb   $0x54,-0x6f(%ebp)
  8000e9:	c6 45 92 00          	movb   $0x0,-0x6e(%ebp)
  8000ed:	c6 45 93 12          	movb   $0x12,-0x6d(%ebp)
  8000f1:	c6 45 94 34          	movb   $0x34,-0x6c(%ebp)
  8000f5:	c6 45 95 56          	movb   $0x56,-0x6b(%ebp)
	uint32_t myip = inet_addr(IP);
  8000f9:	c7 04 24 65 4c 80 00 	movl   $0x804c65,(%esp)
  800100:	e8 7f 48 00 00       	call   804984 <inet_addr>
  800105:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  800108:	c7 04 24 6f 4c 80 00 	movl   $0x804c6f,(%esp)
  80010f:	e8 70 48 00 00       	call   804984 <inet_addr>
  800114:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int r;

	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800117:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800126:	0f 
  800127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80012e:	e8 6d 11 00 00       	call   8012a0 <_Z14sys_page_allociPvi>
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <_Z5umainiPPc+0x117>
		panic("sys_page_map: %e", r);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 78 4c 80 	movl   $0x804c78,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 38 4c 80 00 	movl   $0x804c38,(%esp)
  800152:	e8 31 05 00 00       	call   800688 <_Z6_panicPKciS0_z>

	struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
	pkt->jp_len = sizeof(*arp);
  800157:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  80015e:	00 00 00 

	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  800161:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800168:	00 
  800169:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800170:	00 
  800171:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  800178:	e8 84 0d 00 00       	call   800f01 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80017d:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800184:	00 
  800185:	8d 5d 90             	lea    -0x70(%ebp),%ebx
  800188:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80018c:	c7 04 24 0a b0 fe 0f 	movl   $0xffeb00a,(%esp)
  800193:	e8 3f 0e 00 00       	call   800fd7 <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  800198:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  80019f:	e8 85 45 00 00       	call   804729 <htons>
  8001a4:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  8001aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001b1:	e8 73 45 00 00       	call   804729 <htons>
  8001b6:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  8001bc:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  8001c3:	e8 61 45 00 00       	call   804729 <htons>
  8001c8:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001ce:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  8001d5:	e8 4f 45 00 00       	call   804729 <htons>
  8001da:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  8001e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001e7:	e8 3d 45 00 00       	call   804729 <htons>
  8001ec:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001f2:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8001f9:	00 
  8001fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001fe:	c7 04 24 1a b0 fe 0f 	movl   $0xffeb01a,(%esp)
  800205:	e8 cd 0d 00 00       	call   800fd7 <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  80020a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800211:	00 
  800212:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800215:	89 44 24 04          	mov    %eax,0x4(%esp)
  800219:	c7 04 24 20 b0 fe 0f 	movl   $0xffeb020,(%esp)
  800220:	e8 b2 0d 00 00       	call   800fd7 <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800225:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80022c:	00 
  80022d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800234:	00 
  800235:	c7 04 24 24 b0 fe 0f 	movl   $0xffeb024,(%esp)
  80023c:	e8 c0 0c 00 00       	call   800f01 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  800241:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800248:	00 
  800249:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80024c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800250:	c7 04 24 2a b0 fe 0f 	movl   $0xffeb02a,(%esp)
  800257:	e8 7b 0d 00 00       	call   800fd7 <memcpy>

	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  80025c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800263:	00 
  800264:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  80026b:	0f 
  80026c:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800273:	00 
  800274:	a1 00 70 80 00       	mov    0x807000,%eax
  800279:	89 04 24             	mov    %eax,(%esp)
  80027c:	e8 de 19 00 00       	call   801c5f <_Z8ipc_sendijPvi>
	sys_page_unmap(0, pkt);
  800281:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800288:	0f 
  800289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800290:	e8 c8 10 00 00       	call   80135d <_Z14sys_page_unmapiPv>

void
umain(int argc, char **argv)
{
	envid_t ns_envid = sys_getenvid();
	int i, r, first = 1;
  800295:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  80029c:	00 00 00 

	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80029f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002a2:	89 45 80             	mov    %eax,-0x80(%ebp)
  8002a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8002a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ac:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8002b3:	0f 
  8002b4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002b7:	89 04 24             	mov    %eax,(%esp)
  8002ba:	e8 11 19 00 00       	call   801bd0 <_Z8ipc_recvPiPvS_>
		if (req < 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	79 20                	jns    8002e3 <_Z5umainiPPc+0x2a3>
			panic("ipc_recv: %e", req);
  8002c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c7:	c7 44 24 08 89 4c 80 	movl   $0x804c89,0x8(%esp)
  8002ce:	00 
  8002cf:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  8002d6:	00 
  8002d7:	c7 04 24 38 4c 80 00 	movl   $0x804c38,(%esp)
  8002de:	e8 a5 03 00 00       	call   800688 <_Z6_panicPKciS0_z>
		if (whom != input_envid)
  8002e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002e6:	3b 15 04 70 80 00    	cmp    0x807004,%edx
  8002ec:	74 20                	je     80030e <_Z5umainiPPc+0x2ce>
			panic("IPC from unexpected environment %08x", whom);
  8002ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002f2:	c7 44 24 08 e0 4c 80 	movl   $0x804ce0,0x8(%esp)
  8002f9:	00 
  8002fa:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800301:	00 
  800302:	c7 04 24 38 4c 80 00 	movl   $0x804c38,(%esp)
  800309:	e8 7a 03 00 00       	call   800688 <_Z6_panicPKciS0_z>
		if (req != NSREQ_INPUT)
  80030e:	83 f8 0a             	cmp    $0xa,%eax
  800311:	74 20                	je     800333 <_Z5umainiPPc+0x2f3>
			panic("Unexpected IPC %d", req);
  800313:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800317:	c7 44 24 08 96 4c 80 	movl   $0x804c96,0x8(%esp)
  80031e:	00 
  80031f:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800326:	00 
  800327:	c7 04 24 38 4c 80 00 	movl   $0x804c38,(%esp)
  80032e:	e8 55 03 00 00       	call   800688 <_Z6_panicPKciS0_z>
		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800333:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  800338:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  80033e:	85 c0                	test   %eax,%eax
  800340:	0f 8e d9 00 00 00    	jle    80041f <_Z5umainiPPc+0x3df>
hexdump(const char *prefix, const void *data, int len)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
  800346:	be 00 00 00 00       	mov    $0x0,%esi
	for (i = 0; i < len; i++) {
  80034b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
  800350:	8d 45 90             	lea    -0x70(%ebp),%eax
  800353:	89 45 84             	mov    %eax,-0x7c(%ebp)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800356:	89 df                	mov    %ebx,%edi
		if (i % 16 == 0)
  800358:	f6 c3 0f             	test   $0xf,%bl
  80035b:	75 2c                	jne    800389 <_Z5umainiPPc+0x349>
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
  80035d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800361:	c7 44 24 0c a8 4c 80 	movl   $0x804ca8,0xc(%esp)
  800368:	00 
  800369:	c7 44 24 08 b0 4c 80 	movl   $0x804cb0,0x8(%esp)
  800370:	00 
  800371:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  800378:	00 
  800379:	8d 45 90             	lea    -0x70(%ebp),%eax
  80037c:	89 04 24             	mov    %eax,(%esp)
  80037f:	e8 cd 09 00 00       	call   800d51 <_Z8snprintfPciPKcz>
  800384:	8d 75 90             	lea    -0x70(%ebp),%esi
  800387:	01 c6                	add    %eax,%esi
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800389:	0f b6 87 04 b0 fe 0f 	movzbl 0xffeb004(%edi),%eax
  800390:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800394:	c7 44 24 08 ba 4c 80 	movl   $0x804cba,0x8(%esp)
  80039b:	00 
  80039c:	8b 45 80             	mov    -0x80(%ebp),%eax
  80039f:	29 f0                	sub    %esi,%eax
  8003a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a5:	89 34 24             	mov    %esi,(%esp)
  8003a8:	e8 a4 09 00 00       	call   800d51 <_Z8snprintfPciPKcz>
  8003ad:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  8003af:	89 d8                	mov    %ebx,%eax
  8003b1:	c1 f8 1f             	sar    $0x1f,%eax
  8003b4:	c1 e8 1c             	shr    $0x1c,%eax
  8003b7:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  8003ba:	83 e7 0f             	and    $0xf,%edi
  8003bd:	29 c7                	sub    %eax,%edi
  8003bf:	83 ff 0f             	cmp    $0xf,%edi
  8003c2:	74 0d                	je     8003d1 <_Z5umainiPPc+0x391>
  8003c4:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8003ca:	83 e8 01             	sub    $0x1,%eax
  8003cd:	39 c3                	cmp    %eax,%ebx
  8003cf:	75 1c                	jne    8003ed <_Z5umainiPPc+0x3ad>
			cprintf("%.*s\n", out - buf, buf);
  8003d1:	8d 45 90             	lea    -0x70(%ebp),%eax
  8003d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d8:	89 f0                	mov    %esi,%eax
  8003da:	2b 45 84             	sub    -0x7c(%ebp),%eax
  8003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e1:	c7 04 24 bf 4c 80 00 	movl   $0x804cbf,(%esp)
  8003e8:	e8 b9 03 00 00       	call   8007a6 <_Z7cprintfPKcz>
		if (i % 2 == 1)
  8003ed:	89 d8                	mov    %ebx,%eax
  8003ef:	c1 e8 1f             	shr    $0x1f,%eax
  8003f2:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8003f5:	83 e2 01             	and    $0x1,%edx
  8003f8:	29 c2                	sub    %eax,%edx
  8003fa:	83 fa 01             	cmp    $0x1,%edx
  8003fd:	75 06                	jne    800405 <_Z5umainiPPc+0x3c5>
			*(out++) = ' ';
  8003ff:	c6 06 20             	movb   $0x20,(%esi)
  800402:	83 c6 01             	add    $0x1,%esi
		if (i % 16 == 7)
  800405:	83 ff 07             	cmp    $0x7,%edi
  800408:	75 06                	jne    800410 <_Z5umainiPPc+0x3d0>
			*(out++) = ' ';
  80040a:	c6 06 20             	movb   $0x20,(%esi)
  80040d:	83 c6 01             	add    $0x1,%esi
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800410:	83 c3 01             	add    $0x1,%ebx
  800413:	39 9d 7c ff ff ff    	cmp    %ebx,-0x84(%ebp)
  800419:	0f 8f 37 ff ff ff    	jg     800356 <_Z5umainiPPc+0x316>
		if (whom != input_envid)
			panic("IPC from unexpected environment %08x", whom);
		if (req != NSREQ_INPUT)
			panic("Unexpected IPC %d", req);
		hexdump("input: ", pkt->jp_data, pkt->jp_len);
		cprintf("\n");
  80041f:	c7 04 24 db 4c 80 00 	movl   $0x804cdb,(%esp)
  800426:	e8 7b 03 00 00       	call   8007a6 <_Z7cprintfPKcz>

		// Only indicate that we're waiting for packets once
		// we've received the ARP reply
		if (first)
  80042b:	83 bd 78 ff ff ff 00 	cmpl   $0x0,-0x88(%ebp)
  800432:	0f 84 6d fe ff ff    	je     8002a5 <_Z5umainiPPc+0x265>
			cprintf("Waiting for packets...\n");
  800438:	c7 04 24 c5 4c 80 00 	movl   $0x804cc5,(%esp)
  80043f:	e8 62 03 00 00       	call   8007a6 <_Z7cprintfPKcz>
		first = 0;
  800444:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  80044b:	00 00 00 
  80044e:	e9 52 fe ff ff       	jmp    8002a5 <_Z5umainiPPc+0x265>
	}
}
  800453:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800459:	5b                   	pop    %ebx
  80045a:	5e                   	pop    %esi
  80045b:	5f                   	pop    %edi
  80045c:	5d                   	pop    %ebp
  80045d:	c3                   	ret    
	...

00800460 <_Z5timerij>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	57                   	push   %edi
  800464:	56                   	push   %esi
  800465:	53                   	push   %ebx
  800466:	83 ec 2c             	sub    $0x2c,%esp
  800469:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80046c:	e8 8d 11 00 00       	call   8015fe <_Z13sys_time_msecv>
  800471:	89 c3                	mov    %eax,%ebx
  800473:	03 5d 0c             	add    0xc(%ebp),%ebx

	binaryname = "ns_timer";
  800476:	c7 05 00 60 80 00 05 	movl   $0x804d05,0x806000
  80047d:	4d 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800480:	8d 7d e4             	lea    -0x1c(%ebp),%edi
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  800483:	e8 76 11 00 00       	call   8015fe <_Z13sys_time_msecv>
  800488:	39 c3                	cmp    %eax,%ebx
  80048a:	0f 86 8b 00 00 00    	jbe    80051b <_Z5timerij+0xbb>
  800490:	85 c0                	test   %eax,%eax
  800492:	78 07                	js     80049b <_Z5timerij+0x3b>
			sys_yield();
  800494:	e8 d3 0d 00 00       	call   80126c <_Z9sys_yieldv>
  800499:	eb e8                	jmp    800483 <_Z5timerij+0x23>
		}
		if (r < 0)
			panic("sys_time_msec: %e", r);
  80049b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80049f:	c7 44 24 08 0e 4d 80 	movl   $0x804d0e,0x8(%esp)
  8004a6:	00 
  8004a7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8004ae:	00 
  8004af:	c7 04 24 20 4d 80 00 	movl   $0x804d20,(%esp)
  8004b6:	e8 cd 01 00 00       	call   800688 <_Z6_panicPKciS0_z>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8004bb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004c2:	00 
  8004c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004ca:	00 
  8004cb:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8004d2:	00 
  8004d3:	89 34 24             	mov    %esi,(%esp)
  8004d6:	e8 84 17 00 00       	call   801c5f <_Z8ipc_sendijPvi>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8004db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004e2:	00 
  8004e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004ea:	00 
  8004eb:	89 3c 24             	mov    %edi,(%esp)
  8004ee:	e8 dd 16 00 00       	call   801bd0 <_Z8ipc_recvPiPvS_>
  8004f3:	89 c3                	mov    %eax,%ebx

			if (whom != (uint32_t)ns_envid) {
  8004f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004f8:	39 c6                	cmp    %eax,%esi
  8004fa:	74 12                	je     80050e <_Z5timerij+0xae>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8004fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800500:	c7 04 24 2c 4d 80 00 	movl   $0x804d2c,(%esp)
  800507:	e8 9a 02 00 00       	call   8007a6 <_Z7cprintfPKcz>
		if (r < 0)
			panic("sys_time_msec: %e", r);

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
  80050c:	eb cd                	jmp    8004db <_Z5timerij+0x7b>
			if (whom != (uint32_t)ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  80050e:	e8 eb 10 00 00       	call   8015fe <_Z13sys_time_msecv>
  800513:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
  800516:	e9 68 ff ff ff       	jmp    800483 <_Z5timerij+0x23>

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
		}
		if (r < 0)
  80051b:	85 c0                	test   %eax,%eax
  80051d:	8d 76 00             	lea    0x0(%esi),%esi
  800520:	79 99                	jns    8004bb <_Z5timerij+0x5b>
  800522:	e9 74 ff ff ff       	jmp    80049b <_Z5timerij+0x3b>
	...

00800528 <_Z5inputi>:
#include <inc/mmu.h>
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800528:	55                   	push   %ebp
  800529:	89 e5                	mov    %esp,%ebp
  80052b:	53                   	push   %ebx
  80052c:	83 ec 14             	sub    $0x14,%esp
  80052f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    binaryname = "ns_input";
  800532:	c7 05 00 60 80 00 67 	movl   $0x804d67,0x806000
  800539:	4d 80 00 
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
    int len, r;
    while(1)
    {
        if((r = sys_page_alloc(0, &nsipcbuf, PTE_P|PTE_U|PTE_W)) < 0)
  80053c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800543:	00 
  800544:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  80054b:	00 
  80054c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800553:	e8 48 0d 00 00       	call   8012a0 <_Z14sys_page_allociPvi>
  800558:	85 c0                	test   %eax,%eax
  80055a:	79 20                	jns    80057c <_Z5inputi+0x54>
            panic("sys_page_alloc: %e\n", r);
  80055c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800560:	c7 44 24 08 70 4d 80 	movl   $0x804d70,0x8(%esp)
  800567:	00 
  800568:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
  80056f:	00 
  800570:	c7 04 24 84 4d 80 00 	movl   $0x804d84,(%esp)
  800577:	e8 0c 01 00 00       	call   800688 <_Z6_panicPKciS0_z>
        len = sys_e1000_receive(&nsipcbuf.pkt.jp_data);
  80057c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  800583:	e8 e0 10 00 00       	call   801668 <_Z17sys_e1000_receivePv>
        if (len >= 0)
  800588:	85 c0                	test   %eax,%eax
  80058a:	78 b0                	js     80053c <_Z5inputi+0x14>
        {
            nsipcbuf.pkt.jp_len = len;
  80058c:	a3 00 80 80 00       	mov    %eax,0x808000
            ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_U|PTE_W);
  800591:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800598:	00 
  800599:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8005a0:	00 
  8005a1:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8005a8:	00 
  8005a9:	89 1c 24             	mov    %ebx,(%esp)
  8005ac:	e8 ae 16 00 00       	call   801c5f <_Z8ipc_sendijPvi>
  8005b1:	eb 89                	jmp    80053c <_Z5inputi+0x14>
	...

008005b4 <_Z6outputi>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	56                   	push   %esi
  8005b8:	53                   	push   %ebx
  8005b9:	83 ec 20             	sub    $0x20,%esp
  8005bc:	8b 75 08             	mov    0x8(%ebp),%esi
	binaryname = "ns_output";
  8005bf:	c7 05 00 60 80 00 90 	movl   $0x804d90,0x806000
  8005c6:	4d 80 00 
    // LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
    while(1)
    {
        ipc_recv(&envid, &nsipcbuf, 0);
  8005c9:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8005cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8005d3:	00 
  8005d4:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8005db:	00 
  8005dc:	89 1c 24             	mov    %ebx,(%esp)
  8005df:	e8 ec 15 00 00       	call   801bd0 <_Z8ipc_recvPiPvS_>
        if (envid != ns_envid)
  8005e4:	39 75 f4             	cmp    %esi,-0xc(%ebp)
  8005e7:	75 e3                	jne    8005cc <_Z6outputi+0x18>
            continue;
        while(sys_e1000_transmit(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len));
  8005e9:	a1 00 80 80 00       	mov    0x808000,%eax
  8005ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f2:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8005f9:	e8 34 10 00 00       	call   801632 <_Z18sys_e1000_transmitPvj>
  8005fe:	85 c0                	test   %eax,%eax
  800600:	75 e7                	jne    8005e9 <_Z6outputi+0x35>
  800602:	eb c8                	jmp    8005cc <_Z6outputi+0x18>

00800604 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	57                   	push   %edi
  800608:	56                   	push   %esi
  800609:	53                   	push   %ebx
  80060a:	83 ec 1c             	sub    $0x1c,%esp
  80060d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800610:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  800613:	e8 20 0c 00 00       	call   801238 <_Z12sys_getenvidv>
  800618:	25 ff 03 00 00       	and    $0x3ff,%eax
  80061d:	6b c0 78             	imul   $0x78,%eax,%eax
  800620:	05 00 00 00 ef       	add    $0xef000000,%eax
  800625:	a3 08 70 80 00       	mov    %eax,0x807008
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80062a:	85 ff                	test   %edi,%edi
  80062c:	7e 07                	jle    800635 <libmain+0x31>
		binaryname = argv[0];
  80062e:	8b 06                	mov    (%esi),%eax
  800630:	a3 00 60 80 00       	mov    %eax,0x806000

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800635:	b8 3a 59 80 00       	mov    $0x80593a,%eax
  80063a:	3d 3a 59 80 00       	cmp    $0x80593a,%eax
  80063f:	76 0f                	jbe    800650 <libmain+0x4c>
  800641:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  800643:	83 eb 04             	sub    $0x4,%ebx
  800646:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800648:	81 fb 3a 59 80 00    	cmp    $0x80593a,%ebx
  80064e:	77 f3                	ja     800643 <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  800650:	89 74 24 04          	mov    %esi,0x4(%esp)
  800654:	89 3c 24             	mov    %edi,(%esp)
  800657:	e8 e4 f9 ff ff       	call   800040 <_Z5umainiPPc>

	// exit gracefully
	exit();
  80065c:	e8 0b 00 00 00       	call   80066c <_Z4exitv>
}
  800661:	83 c4 1c             	add    $0x1c,%esp
  800664:	5b                   	pop    %ebx
  800665:	5e                   	pop    %esi
  800666:	5f                   	pop    %edi
  800667:	5d                   	pop    %ebp
  800668:	c3                   	ret    
  800669:	00 00                	add    %al,(%eax)
	...

0080066c <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800672:	e8 17 19 00 00       	call   801f8e <_Z9close_allv>
	sys_env_destroy(0);
  800677:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80067e:	e8 58 0b 00 00       	call   8011db <_Z15sys_env_destroyi>
}
  800683:	c9                   	leave  
  800684:	c3                   	ret    
  800685:	00 00                	add    %al,(%eax)
	...

00800688 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	56                   	push   %esi
  80068c:	53                   	push   %ebx
  80068d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800690:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  800693:	a1 0c 70 80 00       	mov    0x80700c,%eax
  800698:	85 c0                	test   %eax,%eax
  80069a:	74 10                	je     8006ac <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  80069c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a0:	c7 04 24 a4 4d 80 00 	movl   $0x804da4,(%esp)
  8006a7:	e8 fa 00 00 00       	call   8007a6 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  8006ac:	8b 1d 00 60 80 00    	mov    0x806000,%ebx
  8006b2:	e8 81 0b 00 00       	call   801238 <_Z12sys_getenvidv>
  8006b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ba:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006be:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006c5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8006c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006cd:	c7 04 24 ac 4d 80 00 	movl   $0x804dac,(%esp)
  8006d4:	e8 cd 00 00 00       	call   8007a6 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8006d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e0:	89 04 24             	mov    %eax,(%esp)
  8006e3:	e8 5d 00 00 00       	call   800745 <_Z8vcprintfPKcPc>
	cprintf("\n");
  8006e8:	c7 04 24 db 4c 80 00 	movl   $0x804cdb,(%esp)
  8006ef:	e8 b2 00 00 00       	call   8007a6 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006f4:	cc                   	int3   
  8006f5:	eb fd                	jmp    8006f4 <_Z6_panicPKciS0_z+0x6c>
	...

008006f8 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	83 ec 18             	sub    $0x18,%esp
  8006fe:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800701:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800704:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  800707:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  800709:	8b 03                	mov    (%ebx),%eax
  80070b:	8b 55 08             	mov    0x8(%ebp),%edx
  80070e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800712:	83 c0 01             	add    $0x1,%eax
  800715:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800717:	3d ff 00 00 00       	cmp    $0xff,%eax
  80071c:	75 19                	jne    800737 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  80071e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800725:	00 
  800726:	8d 43 08             	lea    0x8(%ebx),%eax
  800729:	89 04 24             	mov    %eax,(%esp)
  80072c:	e8 43 0a 00 00       	call   801174 <_Z9sys_cputsPKcj>
		b->idx = 0;
  800731:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800737:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  80073b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80073e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800741:	89 ec                	mov    %ebp,%esp
  800743:	5d                   	pop    %ebp
  800744:	c3                   	ret    

00800745 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800745:	55                   	push   %ebp
  800746:	89 e5                	mov    %esp,%ebp
  800748:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80074e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800755:	00 00 00 
	b.cnt = 0;
  800758:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80075f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800762:	8b 45 0c             	mov    0xc(%ebp),%eax
  800765:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800770:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800776:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077a:	c7 04 24 f8 06 80 00 	movl   $0x8006f8,(%esp)
  800781:	e8 a1 01 00 00       	call   800927 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800786:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80078c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800790:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800796:	89 04 24             	mov    %eax,(%esp)
  800799:	e8 d6 09 00 00       	call   801174 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  80079e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007ac:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	89 04 24             	mov    %eax,(%esp)
  8007b9:	e8 87 ff ff ff       	call   800745 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	57                   	push   %edi
  8007c4:	56                   	push   %esi
  8007c5:	53                   	push   %ebx
  8007c6:	83 ec 4c             	sub    $0x4c,%esp
  8007c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007cc:	89 d6                	mov    %edx,%esi
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8007dd:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e5:	39 d0                	cmp    %edx,%eax
  8007e7:	72 11                	jb     8007fa <_ZL8printnumPFviPvES_yjii+0x3a>
  8007e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007ec:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  8007ef:	76 09                	jbe    8007fa <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007f1:	83 eb 01             	sub    $0x1,%ebx
  8007f4:	85 db                	test   %ebx,%ebx
  8007f6:	7f 5d                	jg     800855 <_ZL8printnumPFviPvES_yjii+0x95>
  8007f8:	eb 6c                	jmp    800866 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fa:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8007fe:	83 eb 01             	sub    $0x1,%ebx
  800801:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800805:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800808:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80080c:	8b 44 24 08          	mov    0x8(%esp),%eax
  800810:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800814:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800817:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80081a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800821:	00 
  800822:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800825:	89 14 24             	mov    %edx,(%esp)
  800828:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80082b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80082f:	e8 8c 41 00 00       	call   8049c0 <__udivdi3>
  800834:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800837:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80083a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80083e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800842:	89 04 24             	mov    %eax,(%esp)
  800845:	89 54 24 04          	mov    %edx,0x4(%esp)
  800849:	89 f2                	mov    %esi,%edx
  80084b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80084e:	e8 6d ff ff ff       	call   8007c0 <_ZL8printnumPFviPvES_yjii>
  800853:	eb 11                	jmp    800866 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800855:	89 74 24 04          	mov    %esi,0x4(%esp)
  800859:	89 3c 24             	mov    %edi,(%esp)
  80085c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085f:	83 eb 01             	sub    $0x1,%ebx
  800862:	85 db                	test   %ebx,%ebx
  800864:	7f ef                	jg     800855 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800866:	89 74 24 04          	mov    %esi,0x4(%esp)
  80086a:	8b 74 24 04          	mov    0x4(%esp),%esi
  80086e:	8b 45 10             	mov    0x10(%ebp),%eax
  800871:	89 44 24 08          	mov    %eax,0x8(%esp)
  800875:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80087c:	00 
  80087d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800880:	89 14 24             	mov    %edx,(%esp)
  800883:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800886:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80088a:	e8 41 42 00 00       	call   804ad0 <__umoddi3>
  80088f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800893:	0f be 80 cf 4d 80 00 	movsbl 0x804dcf(%eax),%eax
  80089a:	89 04 24             	mov    %eax,(%esp)
  80089d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8008a0:	83 c4 4c             	add    $0x4c,%esp
  8008a3:	5b                   	pop    %ebx
  8008a4:	5e                   	pop    %esi
  8008a5:	5f                   	pop    %edi
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ab:	83 fa 01             	cmp    $0x1,%edx
  8008ae:	7e 0e                	jle    8008be <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  8008b0:	8b 10                	mov    (%eax),%edx
  8008b2:	8d 4a 08             	lea    0x8(%edx),%ecx
  8008b5:	89 08                	mov    %ecx,(%eax)
  8008b7:	8b 02                	mov    (%edx),%eax
  8008b9:	8b 52 04             	mov    0x4(%edx),%edx
  8008bc:	eb 22                	jmp    8008e0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  8008be:	85 d2                	test   %edx,%edx
  8008c0:	74 10                	je     8008d2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  8008c2:	8b 10                	mov    (%eax),%edx
  8008c4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8008c7:	89 08                	mov    %ecx,(%eax)
  8008c9:	8b 02                	mov    (%edx),%eax
  8008cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d0:	eb 0e                	jmp    8008e0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  8008d2:	8b 10                	mov    (%eax),%edx
  8008d4:	8d 4a 04             	lea    0x4(%edx),%ecx
  8008d7:	89 08                	mov    %ecx,(%eax)
  8008d9:	8b 02                	mov    (%edx),%eax
  8008db:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  8008e8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8008ec:	8b 10                	mov    (%eax),%edx
  8008ee:	3b 50 04             	cmp    0x4(%eax),%edx
  8008f1:	73 0a                	jae    8008fd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  8008f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f6:	88 0a                	mov    %cl,(%edx)
  8008f8:	83 c2 01             	add    $0x1,%edx
  8008fb:	89 10                	mov    %edx,(%eax)
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800905:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800908:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80090c:	8b 45 10             	mov    0x10(%ebp),%eax
  80090f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800913:	8b 45 0c             	mov    0xc(%ebp),%eax
  800916:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	89 04 24             	mov    %eax,(%esp)
  800920:	e8 02 00 00 00       	call   800927 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	57                   	push   %edi
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	83 ec 3c             	sub    $0x3c,%esp
  800930:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800933:	8b 55 10             	mov    0x10(%ebp),%edx
  800936:	0f b6 02             	movzbl (%edx),%eax
  800939:	89 d3                	mov    %edx,%ebx
  80093b:	83 c3 01             	add    $0x1,%ebx
  80093e:	83 f8 25             	cmp    $0x25,%eax
  800941:	74 2b                	je     80096e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800943:	85 c0                	test   %eax,%eax
  800945:	75 10                	jne    800957 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800947:	e9 a5 03 00 00       	jmp    800cf1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  80094c:	85 c0                	test   %eax,%eax
  80094e:	66 90                	xchg   %ax,%ax
  800950:	75 08                	jne    80095a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800952:	e9 9a 03 00 00       	jmp    800cf1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800957:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  80095a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095e:	89 04 24             	mov    %eax,(%esp)
  800961:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800963:	0f b6 03             	movzbl (%ebx),%eax
  800966:	83 c3 01             	add    $0x1,%ebx
  800969:	83 f8 25             	cmp    $0x25,%eax
  80096c:	75 de                	jne    80094c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  80096e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800972:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800979:	be ff ff ff ff       	mov    $0xffffffff,%esi
  80097e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800985:	b9 00 00 00 00       	mov    $0x0,%ecx
  80098a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80098d:	eb 2b                	jmp    8009ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800992:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800996:	eb 22                	jmp    8009ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800998:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80099b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  80099f:	eb 19                	jmp    8009ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  8009a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009ab:	eb 0d                	jmp    8009ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8009ad:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8009b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8009b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ba:	0f b6 03             	movzbl (%ebx),%eax
  8009bd:	0f b6 d0             	movzbl %al,%edx
  8009c0:	8d 73 01             	lea    0x1(%ebx),%esi
  8009c3:	89 75 10             	mov    %esi,0x10(%ebp)
  8009c6:	83 e8 23             	sub    $0x23,%eax
  8009c9:	3c 55                	cmp    $0x55,%al
  8009cb:	0f 87 d8 02 00 00    	ja     800ca9 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  8009d1:	0f b6 c0             	movzbl %al,%eax
  8009d4:	ff 24 85 60 4f 80 00 	jmp    *0x804f60(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8009db:	83 ea 30             	sub    $0x30,%edx
  8009de:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  8009e1:	8b 55 10             	mov    0x10(%ebp),%edx
  8009e4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  8009e7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  8009ed:	83 fa 09             	cmp    $0x9,%edx
  8009f0:	77 4e                	ja     800a40 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009f2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  8009f8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  8009fb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  8009ff:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800a02:	8d 50 d0             	lea    -0x30(%eax),%edx
  800a05:	83 fa 09             	cmp    $0x9,%edx
  800a08:	76 eb                	jbe    8009f5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  800a0a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800a0d:	eb 31                	jmp    800a40 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	8d 50 04             	lea    0x4(%eax),%edx
  800a15:	89 55 14             	mov    %edx,0x14(%ebp)
  800a18:	8b 00                	mov    (%eax),%eax
  800a1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800a20:	eb 1e                	jmp    800a40 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800a22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a26:	0f 88 75 ff ff ff    	js     8009a1 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a2f:	eb 89                	jmp    8009ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800a31:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800a34:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a3b:	e9 7a ff ff ff       	jmp    8009ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800a40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a44:	0f 89 70 ff ff ff    	jns    8009ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800a4a:	e9 5e ff ff ff       	jmp    8009ad <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a52:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a55:	e9 60 ff ff ff       	jmp    8009ba <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	8d 50 04             	lea    0x4(%eax),%edx
  800a60:	89 55 14             	mov    %edx,0x14(%ebp)
  800a63:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a67:	8b 00                	mov    (%eax),%eax
  800a69:	89 04 24             	mov    %eax,(%esp)
  800a6c:	ff 55 08             	call   *0x8(%ebp)
			break;
  800a6f:	e9 bf fe ff ff       	jmp    800933 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	8d 50 04             	lea    0x4(%eax),%edx
  800a7a:	89 55 14             	mov    %edx,0x14(%ebp)
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	89 c2                	mov    %eax,%edx
  800a81:	c1 fa 1f             	sar    $0x1f,%edx
  800a84:	31 d0                	xor    %edx,%eax
  800a86:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a88:	83 f8 14             	cmp    $0x14,%eax
  800a8b:	7f 0f                	jg     800a9c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  800a8d:	8b 14 85 c0 50 80 00 	mov    0x8050c0(,%eax,4),%edx
  800a94:	85 d2                	test   %edx,%edx
  800a96:	0f 85 35 02 00 00    	jne    800cd1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  800a9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800aa0:	c7 44 24 08 e7 4d 80 	movl   $0x804de7,0x8(%esp)
  800aa7:	00 
  800aa8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aac:	8b 75 08             	mov    0x8(%ebp),%esi
  800aaf:	89 34 24             	mov    %esi,(%esp)
  800ab2:	e8 48 fe ff ff       	call   8008ff <_Z8printfmtPFviPvES_PKcz>
  800ab7:	e9 77 fe ff ff       	jmp    800933 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  800abc:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ac2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	8d 50 04             	lea    0x4(%eax),%edx
  800acb:	89 55 14             	mov    %edx,0x14(%ebp)
  800ace:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800ad0:	85 db                	test   %ebx,%ebx
  800ad2:	ba e0 4d 80 00       	mov    $0x804de0,%edx
  800ad7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  800ada:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ade:	7e 72                	jle    800b52 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800ae0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800ae4:	74 6c                	je     800b52 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aea:	89 1c 24             	mov    %ebx,(%esp)
  800aed:	e8 a9 02 00 00       	call   800d9b <_Z7strnlenPKcj>
  800af2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800af5:	29 c2                	sub    %eax,%edx
  800af7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800afa:	85 d2                	test   %edx,%edx
  800afc:	7e 54                	jle    800b52 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  800afe:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800b02:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800b05:	89 d3                	mov    %edx,%ebx
  800b07:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800b0a:	89 c6                	mov    %eax,%esi
  800b0c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b10:	89 34 24             	mov    %esi,(%esp)
  800b13:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	83 eb 01             	sub    $0x1,%ebx
  800b19:	85 db                	test   %ebx,%ebx
  800b1b:	7f ef                	jg     800b0c <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  800b1d:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800b20:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800b23:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800b2a:	eb 26                	jmp    800b52 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800b2c:	8d 50 e0             	lea    -0x20(%eax),%edx
  800b2f:	83 fa 5e             	cmp    $0x5e,%edx
  800b32:	76 10                	jbe    800b44 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800b34:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b38:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800b3f:	ff 55 08             	call   *0x8(%ebp)
  800b42:	eb 0a                	jmp    800b4e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800b44:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b48:	89 04 24             	mov    %eax,(%esp)
  800b4b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800b52:	0f be 03             	movsbl (%ebx),%eax
  800b55:	83 c3 01             	add    $0x1,%ebx
  800b58:	85 c0                	test   %eax,%eax
  800b5a:	74 11                	je     800b6d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  800b5c:	85 f6                	test   %esi,%esi
  800b5e:	78 05                	js     800b65 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800b60:	83 ee 01             	sub    $0x1,%esi
  800b63:	78 0d                	js     800b72 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	75 c1                	jne    800b2c <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  800b6b:	eb d7                	jmp    800b44 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b70:	eb 03                	jmp    800b75 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b75:	85 c0                	test   %eax,%eax
  800b77:	0f 8e b6 fd ff ff    	jle    800933 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  800b7d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800b80:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800b83:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b87:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800b8e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b90:	83 eb 01             	sub    $0x1,%ebx
  800b93:	85 db                	test   %ebx,%ebx
  800b95:	7f ec                	jg     800b83 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800b97:	e9 97 fd ff ff       	jmp    800933 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b9c:	83 f9 01             	cmp    $0x1,%ecx
  800b9f:	90                   	nop
  800ba0:	7e 10                	jle    800bb2 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	8d 50 08             	lea    0x8(%eax),%edx
  800ba8:	89 55 14             	mov    %edx,0x14(%ebp)
  800bab:	8b 18                	mov    (%eax),%ebx
  800bad:	8b 70 04             	mov    0x4(%eax),%esi
  800bb0:	eb 26                	jmp    800bd8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800bb2:	85 c9                	test   %ecx,%ecx
  800bb4:	74 12                	je     800bc8 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	8d 50 04             	lea    0x4(%eax),%edx
  800bbc:	89 55 14             	mov    %edx,0x14(%ebp)
  800bbf:	8b 18                	mov    (%eax),%ebx
  800bc1:	89 de                	mov    %ebx,%esi
  800bc3:	c1 fe 1f             	sar    $0x1f,%esi
  800bc6:	eb 10                	jmp    800bd8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcb:	8d 50 04             	lea    0x4(%eax),%edx
  800bce:	89 55 14             	mov    %edx,0x14(%ebp)
  800bd1:	8b 18                	mov    (%eax),%ebx
  800bd3:	89 de                	mov    %ebx,%esi
  800bd5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800bd8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800bdd:	85 f6                	test   %esi,%esi
  800bdf:	0f 89 8c 00 00 00    	jns    800c71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800be5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800be9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800bf0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800bf3:	f7 db                	neg    %ebx
  800bf5:	83 d6 00             	adc    $0x0,%esi
  800bf8:	f7 de                	neg    %esi
			}
			base = 10;
  800bfa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bff:	eb 70                	jmp    800c71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c01:	89 ca                	mov    %ecx,%edx
  800c03:	8d 45 14             	lea    0x14(%ebp),%eax
  800c06:	e8 9d fc ff ff       	call   8008a8 <_ZL7getuintPPci>
  800c0b:	89 c3                	mov    %eax,%ebx
  800c0d:	89 d6                	mov    %edx,%esi
			base = 10;
  800c0f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800c14:	eb 5b                	jmp    800c71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800c16:	89 ca                	mov    %ecx,%edx
  800c18:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1b:	e8 88 fc ff ff       	call   8008a8 <_ZL7getuintPPci>
  800c20:	89 c3                	mov    %eax,%ebx
  800c22:	89 d6                	mov    %edx,%esi
			base = 8;
  800c24:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800c29:	eb 46                	jmp    800c71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  800c2b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c2f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800c36:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800c39:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c3d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800c44:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	8d 50 04             	lea    0x4(%eax),%edx
  800c4d:	89 55 14             	mov    %edx,0x14(%ebp)
  800c50:	8b 18                	mov    (%eax),%ebx
  800c52:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800c57:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800c5c:	eb 13                	jmp    800c71 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5e:	89 ca                	mov    %ecx,%edx
  800c60:	8d 45 14             	lea    0x14(%ebp),%eax
  800c63:	e8 40 fc ff ff       	call   8008a8 <_ZL7getuintPPci>
  800c68:	89 c3                	mov    %eax,%ebx
  800c6a:	89 d6                	mov    %edx,%esi
			base = 16;
  800c6c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c71:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800c75:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c7c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c80:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c84:	89 1c 24             	mov    %ebx,(%esp)
  800c87:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c8b:	89 fa                	mov    %edi,%edx
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	e8 2b fb ff ff       	call   8007c0 <_ZL8printnumPFviPvES_yjii>
			break;
  800c95:	e9 99 fc ff ff       	jmp    800933 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c9e:	89 14 24             	mov    %edx,(%esp)
  800ca1:	ff 55 08             	call   *0x8(%ebp)
			break;
  800ca4:	e9 8a fc ff ff       	jmp    800933 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ca9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cad:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800cb4:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cb7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cba:	89 d8                	mov    %ebx,%eax
  800cbc:	eb 02                	jmp    800cc0 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  800cbe:	89 d0                	mov    %edx,%eax
  800cc0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800cc7:	75 f5                	jne    800cbe <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800cc9:	89 45 10             	mov    %eax,0x10(%ebp)
  800ccc:	e9 62 fc ff ff       	jmp    800933 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800cd5:	c7 44 24 08 ed 51 80 	movl   $0x8051ed,0x8(%esp)
  800cdc:	00 
  800cdd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ce1:	8b 75 08             	mov    0x8(%ebp),%esi
  800ce4:	89 34 24             	mov    %esi,(%esp)
  800ce7:	e8 13 fc ff ff       	call   8008ff <_Z8printfmtPFviPvES_PKcz>
  800cec:	e9 42 fc ff ff       	jmp    800933 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf1:	83 c4 3c             	add    $0x3c,%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 28             	sub    $0x28,%esp
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d0f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d13:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800d16:	85 c0                	test   %eax,%eax
  800d18:	74 30                	je     800d4a <_Z9vsnprintfPciPKcS_+0x51>
  800d1a:	85 d2                	test   %edx,%edx
  800d1c:	7e 2c                	jle    800d4a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  800d1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d21:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d25:	8b 45 10             	mov    0x10(%ebp),%eax
  800d28:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d2c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d33:	c7 04 24 e2 08 80 00 	movl   $0x8008e2,(%esp)
  800d3a:	e8 e8 fb ff ff       	call   800927 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  800d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d42:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d48:	eb 05                	jmp    800d4f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800d4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d57:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	89 04 24             	mov    %eax,(%esp)
  800d72:	e8 82 ff ff ff       	call   800cf9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    
  800d79:	00 00                	add    %al,(%eax)
  800d7b:	00 00                	add    %al,(%eax)
  800d7d:	00 00                	add    %al,(%eax)
	...

00800d80 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d86:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8b:	80 3a 00             	cmpb   $0x0,(%edx)
  800d8e:	74 09                	je     800d99 <_Z6strlenPKc+0x19>
		n++;
  800d90:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d97:	75 f7                	jne    800d90 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da4:	b8 00 00 00 00       	mov    $0x0,%eax
  800da9:	39 c2                	cmp    %eax,%edx
  800dab:	74 0b                	je     800db8 <_Z7strnlenPKcj+0x1d>
  800dad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800db1:	74 05                	je     800db8 <_Z7strnlenPKcj+0x1d>
		n++;
  800db3:	83 c0 01             	add    $0x1,%eax
  800db6:	eb f1                	jmp    800da9 <_Z7strnlenPKcj+0xe>
	return n;
}
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	53                   	push   %ebx
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  800dc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800dcd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800dd0:	83 c2 01             	add    $0x1,%edx
  800dd3:	84 c9                	test   %cl,%cl
  800dd5:	75 f2                	jne    800dc9 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  800dd7:	5b                   	pop    %ebx
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800de8:	85 f6                	test   %esi,%esi
  800dea:	74 18                	je     800e04 <_Z7strncpyPcPKcj+0x2a>
  800dec:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800df1:	0f b6 1a             	movzbl (%edx),%ebx
  800df4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800df7:	80 3a 01             	cmpb   $0x1,(%edx)
  800dfa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  800dfd:	83 c1 01             	add    $0x1,%ecx
  800e00:	39 ce                	cmp    %ecx,%esi
  800e02:	77 ed                	ja     800df1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    

00800e08 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	56                   	push   %esi
  800e0c:	53                   	push   %ebx
  800e0d:	8b 75 08             	mov    0x8(%ebp),%esi
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  800e16:	89 f0                	mov    %esi,%eax
  800e18:	85 d2                	test   %edx,%edx
  800e1a:	74 17                	je     800e33 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  800e1c:	83 ea 01             	sub    $0x1,%edx
  800e1f:	74 18                	je     800e39 <_Z7strlcpyPcPKcj+0x31>
  800e21:	80 39 00             	cmpb   $0x0,(%ecx)
  800e24:	74 17                	je     800e3d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  800e26:	0f b6 19             	movzbl (%ecx),%ebx
  800e29:	88 18                	mov    %bl,(%eax)
  800e2b:	83 c0 01             	add    $0x1,%eax
  800e2e:	83 c1 01             	add    $0x1,%ecx
  800e31:	eb e9                	jmp    800e1c <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  800e33:	29 f0                	sub    %esi,%eax
}
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e39:	89 c2                	mov    %eax,%edx
  800e3b:	eb 02                	jmp    800e3f <_Z7strlcpyPcPKcj+0x37>
  800e3d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800e3f:	c6 02 00             	movb   $0x0,(%edx)
  800e42:	eb ef                	jmp    800e33 <_Z7strlcpyPcPKcj+0x2b>

00800e44 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e4d:	0f b6 01             	movzbl (%ecx),%eax
  800e50:	84 c0                	test   %al,%al
  800e52:	74 0c                	je     800e60 <_Z6strcmpPKcS0_+0x1c>
  800e54:	3a 02                	cmp    (%edx),%al
  800e56:	75 08                	jne    800e60 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  800e58:	83 c1 01             	add    $0x1,%ecx
  800e5b:	83 c2 01             	add    $0x1,%edx
  800e5e:	eb ed                	jmp    800e4d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  800e60:	0f b6 c0             	movzbl %al,%eax
  800e63:	0f b6 12             	movzbl (%edx),%edx
  800e66:	29 d0                	sub    %edx,%eax
}
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	53                   	push   %ebx
  800e6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e74:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  800e77:	85 d2                	test   %edx,%edx
  800e79:	74 16                	je     800e91 <_Z7strncmpPKcS0_j+0x27>
  800e7b:	0f b6 01             	movzbl (%ecx),%eax
  800e7e:	84 c0                	test   %al,%al
  800e80:	74 17                	je     800e99 <_Z7strncmpPKcS0_j+0x2f>
  800e82:	3a 03                	cmp    (%ebx),%al
  800e84:	75 13                	jne    800e99 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  800e86:	83 ea 01             	sub    $0x1,%edx
  800e89:	83 c1 01             	add    $0x1,%ecx
  800e8c:	83 c3 01             	add    $0x1,%ebx
  800e8f:	eb e6                	jmp    800e77 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  800e91:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  800e96:	5b                   	pop    %ebx
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  800e99:	0f b6 01             	movzbl (%ecx),%eax
  800e9c:	0f b6 13             	movzbl (%ebx),%edx
  800e9f:	29 d0                	sub    %edx,%eax
  800ea1:	eb f3                	jmp    800e96 <_Z7strncmpPKcS0_j+0x2c>

00800ea3 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ead:	0f b6 10             	movzbl (%eax),%edx
  800eb0:	84 d2                	test   %dl,%dl
  800eb2:	74 1f                	je     800ed3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  800eb4:	38 ca                	cmp    %cl,%dl
  800eb6:	75 0a                	jne    800ec2 <_Z6strchrPKcc+0x1f>
  800eb8:	eb 1e                	jmp    800ed8 <_Z6strchrPKcc+0x35>
  800eba:	38 ca                	cmp    %cl,%dl
  800ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ec0:	74 16                	je     800ed8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ec2:	83 c0 01             	add    $0x1,%eax
  800ec5:	0f b6 10             	movzbl (%eax),%edx
  800ec8:	84 d2                	test   %dl,%dl
  800eca:	75 ee                	jne    800eba <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  800ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed1:	eb 05                	jmp    800ed8 <_Z6strchrPKcc+0x35>
  800ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ee4:	0f b6 10             	movzbl (%eax),%edx
  800ee7:	84 d2                	test   %dl,%dl
  800ee9:	74 14                	je     800eff <_Z7strfindPKcc+0x25>
		if (*s == c)
  800eeb:	38 ca                	cmp    %cl,%dl
  800eed:	75 06                	jne    800ef5 <_Z7strfindPKcc+0x1b>
  800eef:	eb 0e                	jmp    800eff <_Z7strfindPKcc+0x25>
  800ef1:	38 ca                	cmp    %cl,%dl
  800ef3:	74 0a                	je     800eff <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ef5:	83 c0 01             	add    $0x1,%eax
  800ef8:	0f b6 10             	movzbl (%eax),%edx
  800efb:	84 d2                	test   %dl,%dl
  800efd:	75 f2                	jne    800ef1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    

00800f01 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	89 1c 24             	mov    %ebx,(%esp)
  800f0a:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f12:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f18:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  800f1b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f21:	75 25                	jne    800f48 <memset+0x47>
  800f23:	f6 c1 03             	test   $0x3,%cl
  800f26:	75 20                	jne    800f48 <memset+0x47>
		c &= 0xFF;
  800f28:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f2b:	89 d3                	mov    %edx,%ebx
  800f2d:	c1 e3 08             	shl    $0x8,%ebx
  800f30:	89 d6                	mov    %edx,%esi
  800f32:	c1 e6 18             	shl    $0x18,%esi
  800f35:	89 d0                	mov    %edx,%eax
  800f37:	c1 e0 10             	shl    $0x10,%eax
  800f3a:	09 f0                	or     %esi,%eax
  800f3c:	09 d0                	or     %edx,%eax
  800f3e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  800f40:	c1 e9 02             	shr    $0x2,%ecx
  800f43:	fc                   	cld    
  800f44:	f3 ab                	rep stos %eax,%es:(%edi)
  800f46:	eb 03                	jmp    800f4b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  800f48:	fc                   	cld    
  800f49:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  800f4b:	89 f8                	mov    %edi,%eax
  800f4d:	8b 1c 24             	mov    (%esp),%ebx
  800f50:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f54:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f58:	89 ec                	mov    %ebp,%esp
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 08             	sub    $0x8,%esp
  800f62:	89 34 24             	mov    %esi,(%esp)
  800f65:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  800f72:	39 c6                	cmp    %eax,%esi
  800f74:	73 36                	jae    800fac <memmove+0x50>
  800f76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f79:	39 d0                	cmp    %edx,%eax
  800f7b:	73 2f                	jae    800fac <memmove+0x50>
		s += n;
		d += n;
  800f7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800f80:	f6 c2 03             	test   $0x3,%dl
  800f83:	75 1b                	jne    800fa0 <memmove+0x44>
  800f85:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f8b:	75 13                	jne    800fa0 <memmove+0x44>
  800f8d:	f6 c1 03             	test   $0x3,%cl
  800f90:	75 0e                	jne    800fa0 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f92:	83 ef 04             	sub    $0x4,%edi
  800f95:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f98:	c1 e9 02             	shr    $0x2,%ecx
  800f9b:	fd                   	std    
  800f9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f9e:	eb 09                	jmp    800fa9 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800fa0:	83 ef 01             	sub    $0x1,%edi
  800fa3:	8d 72 ff             	lea    -0x1(%edx),%esi
  800fa6:	fd                   	std    
  800fa7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fa9:	fc                   	cld    
  800faa:	eb 20                	jmp    800fcc <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800fac:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800fb2:	75 13                	jne    800fc7 <memmove+0x6b>
  800fb4:	a8 03                	test   $0x3,%al
  800fb6:	75 0f                	jne    800fc7 <memmove+0x6b>
  800fb8:	f6 c1 03             	test   $0x3,%cl
  800fbb:	75 0a                	jne    800fc7 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fbd:	c1 e9 02             	shr    $0x2,%ecx
  800fc0:	89 c7                	mov    %eax,%edi
  800fc2:	fc                   	cld    
  800fc3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fc5:	eb 05                	jmp    800fcc <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  800fc7:	89 c7                	mov    %eax,%edi
  800fc9:	fc                   	cld    
  800fca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  800fcc:	8b 34 24             	mov    (%esp),%esi
  800fcf:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800fd3:	89 ec                	mov    %ebp,%esp
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 08             	sub    $0x8,%esp
  800fdd:	89 34 24             	mov    %esi,(%esp)
  800fe0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fea:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  800fed:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ff3:	75 13                	jne    801008 <memcpy+0x31>
  800ff5:	a8 03                	test   $0x3,%al
  800ff7:	75 0f                	jne    801008 <memcpy+0x31>
  800ff9:	f6 c1 03             	test   $0x3,%cl
  800ffc:	75 0a                	jne    801008 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ffe:	c1 e9 02             	shr    $0x2,%ecx
  801001:	89 c7                	mov    %eax,%edi
  801003:	fc                   	cld    
  801004:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801006:	eb 05                	jmp    80100d <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  801008:	89 c7                	mov    %eax,%edi
  80100a:	fc                   	cld    
  80100b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  80100d:	8b 34 24             	mov    (%esp),%esi
  801010:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801014:	89 ec                	mov    %ebp,%esp
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
  80101e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801021:	8b 75 0c             	mov    0xc(%ebp),%esi
  801024:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  801027:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  80102c:	85 ff                	test   %edi,%edi
  80102e:	74 38                	je     801068 <memcmp+0x50>
		if (*s1 != *s2)
  801030:	0f b6 03             	movzbl (%ebx),%eax
  801033:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  801036:	83 ef 01             	sub    $0x1,%edi
  801039:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  80103e:	38 c8                	cmp    %cl,%al
  801040:	74 1d                	je     80105f <memcmp+0x47>
  801042:	eb 11                	jmp    801055 <memcmp+0x3d>
  801044:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801049:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  80104e:	83 c2 01             	add    $0x1,%edx
  801051:	38 c8                	cmp    %cl,%al
  801053:	74 0a                	je     80105f <memcmp+0x47>
			return *s1 - *s2;
  801055:	0f b6 c0             	movzbl %al,%eax
  801058:	0f b6 c9             	movzbl %cl,%ecx
  80105b:	29 c8                	sub    %ecx,%eax
  80105d:	eb 09                	jmp    801068 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  80105f:	39 fa                	cmp    %edi,%edx
  801061:	75 e1                	jne    801044 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801068:	5b                   	pop    %ebx
  801069:	5e                   	pop    %esi
  80106a:	5f                   	pop    %edi
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	53                   	push   %ebx
  801071:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  801074:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  801076:	89 da                	mov    %ebx,%edx
  801078:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  80107b:	39 d3                	cmp    %edx,%ebx
  80107d:	73 15                	jae    801094 <memfind+0x27>
		if (*s == (unsigned char) c)
  80107f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801083:	38 0b                	cmp    %cl,(%ebx)
  801085:	75 06                	jne    80108d <memfind+0x20>
  801087:	eb 0b                	jmp    801094 <memfind+0x27>
  801089:	38 08                	cmp    %cl,(%eax)
  80108b:	74 07                	je     801094 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  80108d:	83 c0 01             	add    $0x1,%eax
  801090:	39 c2                	cmp    %eax,%edx
  801092:	77 f5                	ja     801089 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  801094:	5b                   	pop    %ebx
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	57                   	push   %edi
  80109b:	56                   	push   %esi
  80109c:	53                   	push   %ebx
  80109d:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	0f b6 02             	movzbl (%edx),%eax
  8010a6:	3c 20                	cmp    $0x20,%al
  8010a8:	74 04                	je     8010ae <_Z6strtolPKcPPci+0x17>
  8010aa:	3c 09                	cmp    $0x9,%al
  8010ac:	75 0e                	jne    8010bc <_Z6strtolPKcPPci+0x25>
		s++;
  8010ae:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b1:	0f b6 02             	movzbl (%edx),%eax
  8010b4:	3c 20                	cmp    $0x20,%al
  8010b6:	74 f6                	je     8010ae <_Z6strtolPKcPPci+0x17>
  8010b8:	3c 09                	cmp    $0x9,%al
  8010ba:	74 f2                	je     8010ae <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010bc:	3c 2b                	cmp    $0x2b,%al
  8010be:	75 0a                	jne    8010ca <_Z6strtolPKcPPci+0x33>
		s++;
  8010c0:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8010c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c8:	eb 10                	jmp    8010da <_Z6strtolPKcPPci+0x43>
  8010ca:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8010cf:	3c 2d                	cmp    $0x2d,%al
  8010d1:	75 07                	jne    8010da <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  8010d3:	83 c2 01             	add    $0x1,%edx
  8010d6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010da:	85 db                	test   %ebx,%ebx
  8010dc:	0f 94 c0             	sete   %al
  8010df:	74 05                	je     8010e6 <_Z6strtolPKcPPci+0x4f>
  8010e1:	83 fb 10             	cmp    $0x10,%ebx
  8010e4:	75 15                	jne    8010fb <_Z6strtolPKcPPci+0x64>
  8010e6:	80 3a 30             	cmpb   $0x30,(%edx)
  8010e9:	75 10                	jne    8010fb <_Z6strtolPKcPPci+0x64>
  8010eb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8010ef:	75 0a                	jne    8010fb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  8010f1:	83 c2 02             	add    $0x2,%edx
  8010f4:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010f9:	eb 13                	jmp    80110e <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 0f                	je     80110e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8010ff:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801104:	80 3a 30             	cmpb   $0x30,(%edx)
  801107:	75 05                	jne    80110e <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  801109:	83 c2 01             	add    $0x1,%edx
  80110c:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  80110e:	b8 00 00 00 00       	mov    $0x0,%eax
  801113:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801115:	0f b6 0a             	movzbl (%edx),%ecx
  801118:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  80111b:	80 fb 09             	cmp    $0x9,%bl
  80111e:	77 08                	ja     801128 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  801120:	0f be c9             	movsbl %cl,%ecx
  801123:	83 e9 30             	sub    $0x30,%ecx
  801126:	eb 1e                	jmp    801146 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  801128:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  80112b:	80 fb 19             	cmp    $0x19,%bl
  80112e:	77 08                	ja     801138 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  801130:	0f be c9             	movsbl %cl,%ecx
  801133:	83 e9 57             	sub    $0x57,%ecx
  801136:	eb 0e                	jmp    801146 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801138:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  80113b:	80 fb 19             	cmp    $0x19,%bl
  80113e:	77 15                	ja     801155 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  801140:	0f be c9             	movsbl %cl,%ecx
  801143:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801146:	39 f1                	cmp    %esi,%ecx
  801148:	7d 0f                	jge    801159 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  80114a:	83 c2 01             	add    $0x1,%edx
  80114d:	0f af c6             	imul   %esi,%eax
  801150:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  801153:	eb c0                	jmp    801115 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  801155:	89 c1                	mov    %eax,%ecx
  801157:	eb 02                	jmp    80115b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801159:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80115b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115f:	74 05                	je     801166 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  801161:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801164:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801166:	89 ca                	mov    %ecx,%edx
  801168:	f7 da                	neg    %edx
  80116a:	85 ff                	test   %edi,%edi
  80116c:	0f 45 c2             	cmovne %edx,%eax
}
  80116f:	5b                   	pop    %ebx
  801170:	5e                   	pop    %esi
  801171:	5f                   	pop    %edi
  801172:	5d                   	pop    %ebp
  801173:	c3                   	ret    

00801174 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	83 ec 0c             	sub    $0xc,%esp
  80117a:	89 1c 24             	mov    %ebx,(%esp)
  80117d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801181:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
  80118a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118d:	8b 55 08             	mov    0x8(%ebp),%edx
  801190:	89 c3                	mov    %eax,%ebx
  801192:	89 c7                	mov    %eax,%edi
  801194:	89 c6                	mov    %eax,%esi
  801196:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801198:	8b 1c 24             	mov    (%esp),%ebx
  80119b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80119f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011a3:	89 ec                	mov    %ebp,%esp
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 0c             	sub    $0xc,%esp
  8011ad:	89 1c 24             	mov    %ebx,(%esp)
  8011b0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011b4:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8011c2:	89 d1                	mov    %edx,%ecx
  8011c4:	89 d3                	mov    %edx,%ebx
  8011c6:	89 d7                	mov    %edx,%edi
  8011c8:	89 d6                	mov    %edx,%esi
  8011ca:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8011cc:	8b 1c 24             	mov    (%esp),%ebx
  8011cf:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011d3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011d7:	89 ec                	mov    %ebp,%esp
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 38             	sub    $0x38,%esp
  8011e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011e4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011e7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8011ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f7:	89 cb                	mov    %ecx,%ebx
  8011f9:	89 cf                	mov    %ecx,%edi
  8011fb:	89 ce                	mov    %ecx,%esi
  8011fd:	cd 30                	int    $0x30

	if(check && ret > 0)
  8011ff:	85 c0                	test   %eax,%eax
  801201:	7e 28                	jle    80122b <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801203:	89 44 24 10          	mov    %eax,0x10(%esp)
  801207:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80120e:	00 
  80120f:	c7 44 24 08 14 51 80 	movl   $0x805114,0x8(%esp)
  801216:	00 
  801217:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80121e:	00 
  80121f:	c7 04 24 31 51 80 00 	movl   $0x805131,(%esp)
  801226:	e8 5d f4 ff ff       	call   800688 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80122b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80122e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801231:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801234:	89 ec                	mov    %ebp,%esp
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    

00801238 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
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
  801249:	ba 00 00 00 00       	mov    $0x0,%edx
  80124e:	b8 02 00 00 00       	mov    $0x2,%eax
  801253:	89 d1                	mov    %edx,%ecx
  801255:	89 d3                	mov    %edx,%ebx
  801257:	89 d7                	mov    %edx,%edi
  801259:	89 d6                	mov    %edx,%esi
  80125b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80125d:	8b 1c 24             	mov    (%esp),%ebx
  801260:	8b 74 24 04          	mov    0x4(%esp),%esi
  801264:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801268:	89 ec                	mov    %ebp,%esp
  80126a:	5d                   	pop    %ebp
  80126b:	c3                   	ret    

0080126c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	83 ec 0c             	sub    $0xc,%esp
  801272:	89 1c 24             	mov    %ebx,(%esp)
  801275:	89 74 24 04          	mov    %esi,0x4(%esp)
  801279:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80127d:	ba 00 00 00 00       	mov    $0x0,%edx
  801282:	b8 04 00 00 00       	mov    $0x4,%eax
  801287:	89 d1                	mov    %edx,%ecx
  801289:	89 d3                	mov    %edx,%ebx
  80128b:	89 d7                	mov    %edx,%edi
  80128d:	89 d6                	mov    %edx,%esi
  80128f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801291:	8b 1c 24             	mov    (%esp),%ebx
  801294:	8b 74 24 04          	mov    0x4(%esp),%esi
  801298:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80129c:	89 ec                	mov    %ebp,%esp
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    

008012a0 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	83 ec 38             	sub    $0x38,%esp
  8012a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012a9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8012af:	be 00 00 00 00       	mov    $0x0,%esi
  8012b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8012b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c2:	89 f7                	mov    %esi,%edi
  8012c4:	cd 30                	int    $0x30

	if(check && ret > 0)
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	7e 28                	jle    8012f2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ce:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8012d5:	00 
  8012d6:	c7 44 24 08 14 51 80 	movl   $0x805114,0x8(%esp)
  8012dd:	00 
  8012de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012e5:	00 
  8012e6:	c7 04 24 31 51 80 00 	movl   $0x805131,(%esp)
  8012ed:	e8 96 f3 ff ff       	call   800688 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012fb:	89 ec                	mov    %ebp,%esp
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    

008012ff <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 38             	sub    $0x38,%esp
  801305:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801308:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80130b:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80130e:	b8 09 00 00 00       	mov    $0x9,%eax
  801313:	8b 75 18             	mov    0x18(%ebp),%esi
  801316:	8b 7d 14             	mov    0x14(%ebp),%edi
  801319:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80131c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131f:	8b 55 08             	mov    0x8(%ebp),%edx
  801322:	cd 30                	int    $0x30

	if(check && ret > 0)
  801324:	85 c0                	test   %eax,%eax
  801326:	7e 28                	jle    801350 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801328:	89 44 24 10          	mov    %eax,0x10(%esp)
  80132c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801333:	00 
  801334:	c7 44 24 08 14 51 80 	movl   $0x805114,0x8(%esp)
  80133b:	00 
  80133c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801343:	00 
  801344:	c7 04 24 31 51 80 00 	movl   $0x805131,(%esp)
  80134b:	e8 38 f3 ff ff       	call   800688 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801350:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801353:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801356:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801359:	89 ec                	mov    %ebp,%esp
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    

0080135d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 38             	sub    $0x38,%esp
  801363:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801366:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801369:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80136c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801371:	b8 0a 00 00 00       	mov    $0xa,%eax
  801376:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801379:	8b 55 08             	mov    0x8(%ebp),%edx
  80137c:	89 df                	mov    %ebx,%edi
  80137e:	89 de                	mov    %ebx,%esi
  801380:	cd 30                	int    $0x30

	if(check && ret > 0)
  801382:	85 c0                	test   %eax,%eax
  801384:	7e 28                	jle    8013ae <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801386:	89 44 24 10          	mov    %eax,0x10(%esp)
  80138a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801391:	00 
  801392:	c7 44 24 08 14 51 80 	movl   $0x805114,0x8(%esp)
  801399:	00 
  80139a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013a1:	00 
  8013a2:	c7 04 24 31 51 80 00 	movl   $0x805131,(%esp)
  8013a9:	e8 da f2 ff ff       	call   800688 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013b1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013b4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013b7:	89 ec                	mov    %ebp,%esp
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 38             	sub    $0x38,%esp
  8013c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8013ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8013d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013da:	89 df                	mov    %ebx,%edi
  8013dc:	89 de                	mov    %ebx,%esi
  8013de:	cd 30                	int    $0x30

	if(check && ret > 0)
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	7e 28                	jle    80140c <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8013ef:	00 
  8013f0:	c7 44 24 08 14 51 80 	movl   $0x805114,0x8(%esp)
  8013f7:	00 
  8013f8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013ff:	00 
  801400:	c7 04 24 31 51 80 00 	movl   $0x805131,(%esp)
  801407:	e8 7c f2 ff ff       	call   800688 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80140c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80140f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801412:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801415:	89 ec                	mov    %ebp,%esp
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	83 ec 38             	sub    $0x38,%esp
  80141f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801422:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801425:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801428:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142d:	b8 06 00 00 00       	mov    $0x6,%eax
  801432:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801435:	8b 55 08             	mov    0x8(%ebp),%edx
  801438:	89 df                	mov    %ebx,%edi
  80143a:	89 de                	mov    %ebx,%esi
  80143c:	cd 30                	int    $0x30

	if(check && ret > 0)
  80143e:	85 c0                	test   %eax,%eax
  801440:	7e 28                	jle    80146a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801442:	89 44 24 10          	mov    %eax,0x10(%esp)
  801446:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80144d:	00 
  80144e:	c7 44 24 08 14 51 80 	movl   $0x805114,0x8(%esp)
  801455:	00 
  801456:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80145d:	00 
  80145e:	c7 04 24 31 51 80 00 	movl   $0x805131,(%esp)
  801465:	e8 1e f2 ff ff       	call   800688 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80146a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80146d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801470:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801473:	89 ec                	mov    %ebp,%esp
  801475:	5d                   	pop    %ebp
  801476:	c3                   	ret    

00801477 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 38             	sub    $0x38,%esp
  80147d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801480:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801483:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801486:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801490:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801493:	8b 55 08             	mov    0x8(%ebp),%edx
  801496:	89 df                	mov    %ebx,%edi
  801498:	89 de                	mov    %ebx,%esi
  80149a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80149c:	85 c0                	test   %eax,%eax
  80149e:	7e 28                	jle    8014c8 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014a4:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  8014ab:	00 
  8014ac:	c7 44 24 08 14 51 80 	movl   $0x805114,0x8(%esp)
  8014b3:	00 
  8014b4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014bb:	00 
  8014bc:	c7 04 24 31 51 80 00 	movl   $0x805131,(%esp)
  8014c3:	e8 c0 f1 ff ff       	call   800688 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8014c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014cb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014ce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014d1:	89 ec                	mov    %ebp,%esp
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 38             	sub    $0x38,%esp
  8014db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8014e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8014ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f4:	89 df                	mov    %ebx,%edi
  8014f6:	89 de                	mov    %ebx,%esi
  8014f8:	cd 30                	int    $0x30

	if(check && ret > 0)
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	7e 28                	jle    801526 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  801502:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  801509:	00 
  80150a:	c7 44 24 08 14 51 80 	movl   $0x805114,0x8(%esp)
  801511:	00 
  801512:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801519:	00 
  80151a:	c7 04 24 31 51 80 00 	movl   $0x805131,(%esp)
  801521:	e8 62 f1 ff ff       	call   800688 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801526:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801529:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80152c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80152f:	89 ec                	mov    %ebp,%esp
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    

00801533 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	89 1c 24             	mov    %ebx,(%esp)
  80153c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801540:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801544:	be 00 00 00 00       	mov    $0x0,%esi
  801549:	b8 0d 00 00 00       	mov    $0xd,%eax
  80154e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801551:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801554:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801557:	8b 55 08             	mov    0x8(%ebp),%edx
  80155a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80155c:	8b 1c 24             	mov    (%esp),%ebx
  80155f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801563:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801567:	89 ec                	mov    %ebp,%esp
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 38             	sub    $0x38,%esp
  801571:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801574:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801577:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80157a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80157f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801584:	8b 55 08             	mov    0x8(%ebp),%edx
  801587:	89 cb                	mov    %ecx,%ebx
  801589:	89 cf                	mov    %ecx,%edi
  80158b:	89 ce                	mov    %ecx,%esi
  80158d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80158f:	85 c0                	test   %eax,%eax
  801591:	7e 28                	jle    8015bb <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801593:	89 44 24 10          	mov    %eax,0x10(%esp)
  801597:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80159e:	00 
  80159f:	c7 44 24 08 14 51 80 	movl   $0x805114,0x8(%esp)
  8015a6:	00 
  8015a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015ae:	00 
  8015af:	c7 04 24 31 51 80 00 	movl   $0x805131,(%esp)
  8015b6:	e8 cd f0 ff ff       	call   800688 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8015bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015c4:	89 ec                	mov    %ebp,%esp
  8015c6:	5d                   	pop    %ebp
  8015c7:	c3                   	ret    

008015c8 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	89 1c 24             	mov    %ebx,(%esp)
  8015d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015d5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8015d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015de:	b8 0f 00 00 00       	mov    $0xf,%eax
  8015e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e9:	89 df                	mov    %ebx,%edi
  8015eb:	89 de                	mov    %ebx,%esi
  8015ed:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8015ef:	8b 1c 24             	mov    (%esp),%ebx
  8015f2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8015f6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8015fa:	89 ec                	mov    %ebp,%esp
  8015fc:	5d                   	pop    %ebp
  8015fd:	c3                   	ret    

008015fe <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	89 1c 24             	mov    %ebx,(%esp)
  801607:	89 74 24 04          	mov    %esi,0x4(%esp)
  80160b:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80160f:	ba 00 00 00 00       	mov    $0x0,%edx
  801614:	b8 11 00 00 00       	mov    $0x11,%eax
  801619:	89 d1                	mov    %edx,%ecx
  80161b:	89 d3                	mov    %edx,%ebx
  80161d:	89 d7                	mov    %edx,%edi
  80161f:	89 d6                	mov    %edx,%esi
  801621:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801623:	8b 1c 24             	mov    (%esp),%ebx
  801626:	8b 74 24 04          	mov    0x4(%esp),%esi
  80162a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80162e:	89 ec                	mov    %ebp,%esp
  801630:	5d                   	pop    %ebp
  801631:	c3                   	ret    

00801632 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 0c             	sub    $0xc,%esp
  801638:	89 1c 24             	mov    %ebx,(%esp)
  80163b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80163f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801643:	bb 00 00 00 00       	mov    $0x0,%ebx
  801648:	b8 12 00 00 00       	mov    $0x12,%eax
  80164d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801650:	8b 55 08             	mov    0x8(%ebp),%edx
  801653:	89 df                	mov    %ebx,%edi
  801655:	89 de                	mov    %ebx,%esi
  801657:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801659:	8b 1c 24             	mov    (%esp),%ebx
  80165c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801660:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801664:	89 ec                	mov    %ebp,%esp
  801666:	5d                   	pop    %ebp
  801667:	c3                   	ret    

00801668 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	89 1c 24             	mov    %ebx,(%esp)
  801671:	89 74 24 04          	mov    %esi,0x4(%esp)
  801675:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801679:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167e:	b8 13 00 00 00       	mov    $0x13,%eax
  801683:	8b 55 08             	mov    0x8(%ebp),%edx
  801686:	89 cb                	mov    %ecx,%ebx
  801688:	89 cf                	mov    %ecx,%edi
  80168a:	89 ce                	mov    %ecx,%esi
  80168c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80168e:	8b 1c 24             	mov    (%esp),%ebx
  801691:	8b 74 24 04          	mov    0x4(%esp),%esi
  801695:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801699:	89 ec                	mov    %ebp,%esp
  80169b:	5d                   	pop    %ebp
  80169c:	c3                   	ret    

0080169d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 0c             	sub    $0xc,%esp
  8016a3:	89 1c 24             	mov    %ebx,(%esp)
  8016a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8016ae:	b8 10 00 00 00       	mov    $0x10,%eax
  8016b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8016b6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c2:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  8016c4:	8b 1c 24             	mov    (%esp),%ebx
  8016c7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8016cb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8016cf:	89 ec                	mov    %ebp,%esp
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    
	...

008016d4 <_ZL7duppageijb>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 38             	sub    $0x38,%esp
  8016da:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016dd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016e0:	89 7d fc             	mov    %edi,-0x4(%ebp)
    // if a page is already COW, then it will be duplicated COW, even if using
    // sfork.  If we are meant to share, then we no longer want to get rid
    // of the write permissions.  Finally, if we aren't meant to share,
    // then we must be COW, so all writable pages are COW

    if((vpt[pn] & PTE_SHARE))
  8016e3:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  8016ea:	f6 c7 04             	test   $0x4,%bh
  8016ed:	74 31                	je     801720 <_ZL7duppageijb+0x4c>
    {
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
  8016ef:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  8016f6:	c1 e2 0c             	shl    $0xc,%edx
  8016f9:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8016ff:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801703:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801707:	89 44 24 08          	mov    %eax,0x8(%esp)
  80170b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80170f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801716:	e8 e4 fb ff ff       	call   8012ff <_Z12sys_page_mapiPviS_i>
        return r;
  80171b:	e9 8c 00 00 00       	jmp    8017ac <_ZL7duppageijb+0xd8>
    }


    if((vpt[pn] & PTE_COW))
  801720:	8b 34 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%esi
        perm = PTE_COW;
  801727:	bb 00 08 00 00       	mov    $0x800,%ebx
        r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_SYSCALL);
        return r;
    }


    if((vpt[pn] & PTE_COW))
  80172c:	f7 c6 00 08 00 00    	test   $0x800,%esi
  801732:	75 2a                	jne    80175e <_ZL7duppageijb+0x8a>
        perm = PTE_COW;
    else if (shared)
  801734:	84 c9                	test   %cl,%cl
  801736:	74 0f                	je     801747 <_ZL7duppageijb+0x73>
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
  801738:	8b 1c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ebx
  80173f:	83 e3 02             	and    $0x2,%ebx
  801742:	80 cf 02             	or     $0x2,%bh
  801745:	eb 17                	jmp    80175e <_ZL7duppageijb+0x8a>
    else if (vpt[pn] & PTE_W)
  801747:	8b 0c 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%ecx
  80174e:	83 e1 02             	and    $0x2,%ecx
//
static int
duppage(envid_t envid, unsigned pn, bool shared = false)
{
	int r;
    int perm = 0;
  801751:	83 f9 01             	cmp    $0x1,%ecx
  801754:	19 db                	sbb    %ebx,%ebx
  801756:	f7 d3                	not    %ebx
  801758:	81 e3 00 08 00 00    	and    $0x800,%ebx
        perm = PTE_SHARED | ((vpt[pn] & PTE_W)?PTE_W:0);
    else if (vpt[pn] & PTE_W)
        perm = PTE_COW;

    // map the page with the given permissions in our new environment
	if((r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80175e:	89 df                	mov    %ebx,%edi
  801760:	83 cf 05             	or     $0x5,%edi
  801763:	89 d6                	mov    %edx,%esi
  801765:	c1 e6 0c             	shl    $0xc,%esi
  801768:	89 7c 24 10          	mov    %edi,0x10(%esp)
  80176c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801770:	89 44 24 08          	mov    %eax,0x8(%esp)
  801774:	89 74 24 04          	mov    %esi,0x4(%esp)
  801778:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80177f:	e8 7b fb ff ff       	call   8012ff <_Z12sys_page_mapiPviS_i>
  801784:	85 c0                	test   %eax,%eax
  801786:	75 24                	jne    8017ac <_ZL7duppageijb+0xd8>
        return r;

    // remap it in our own environment (to make sure it is COW)
    if(perm)
  801788:	85 db                	test   %ebx,%ebx
  80178a:	74 20                	je     8017ac <_ZL7duppageijb+0xd8>
	    if((r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE), PTE_P|PTE_U|perm)))
  80178c:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801790:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801794:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80179b:	00 
  80179c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a7:	e8 53 fb ff ff       	call   8012ff <_Z12sys_page_mapiPviS_i>
            return r;

    return 0;
}
  8017ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017af:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017b5:	89 ec                	mov    %ebp,%esp
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    

008017b9 <_ZL7pgfaultP10UTrapframe>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy and call resume(utf).
//
static void
pgfault(struct UTrapframe *utf)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 28             	sub    $0x28,%esp
  8017bf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8017c2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *addr = (void *)utf->utf_fault_va;
  8017c8:	8b 33                	mov    (%ebx),%esi

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  8017ca:	f6 43 04 02          	testb  $0x2,0x4(%ebx)
  8017ce:	0f 84 ff 00 00 00    	je     8018d3 <_ZL7pgfaultP10UTrapframe+0x11a>
	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, return 0.
	// Hint: Use vpd and vpt.

    // page number
    uint32_t pn = (uint32_t)addr >> 12;
  8017d4:	89 f0                	mov    %esi,%eax
  8017d6:	c1 e8 0c             	shr    $0xc,%eax
    
    // if this isn't a COW case, just return
    if (!(err & FEC_W) || !(vpt[pn] & PTE_COW))
  8017d9:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8017e0:	f6 c4 08             	test   $0x8,%ah
  8017e3:	0f 84 ea 00 00 00    	je     8018d3 <_ZL7pgfaultP10UTrapframe+0x11a>

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);

    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8017e9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8017f0:	00 
  8017f1:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8017f8:	00 
  8017f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801800:	e8 9b fa ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  801805:	85 c0                	test   %eax,%eax
  801807:	79 20                	jns    801829 <_ZL7pgfaultP10UTrapframe+0x70>
        panic("sys_page_alloc: %e", r);
  801809:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80180d:	c7 44 24 08 3f 51 80 	movl   $0x80513f,0x8(%esp)
  801814:	00 
  801815:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  80181c:	00 
  80181d:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  801824:	e8 5f ee ff ff       	call   800688 <_Z6_panicPKciS0_z>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

    // now we need to copy the page and update our mapping so we can write to it
    addr = ROUNDDOWN(addr, PGSIZE);
  801829:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // allocate a new page in PFTEMP
    if ((r = sys_page_alloc(0, PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
        panic("sys_page_alloc: %e", r);

    // copy everything over to it
    memcpy(PFTEMP, addr, PGSIZE);
  80182f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801836:	00 
  801837:	89 74 24 04          	mov    %esi,0x4(%esp)
  80183b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801842:	e8 90 f7 ff ff       	call   800fd7 <memcpy>

    // now remap our page at addr to PFTEMP, with write permissions
    if ((r = sys_page_map(0, PFTEMP, 0, addr, PTE_P|PTE_U|PTE_W)) < 0)
  801847:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80184e:	00 
  80184f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801853:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80185a:	00 
  80185b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801862:	00 
  801863:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80186a:	e8 90 fa ff ff       	call   8012ff <_Z12sys_page_mapiPviS_i>
  80186f:	85 c0                	test   %eax,%eax
  801871:	79 20                	jns    801893 <_ZL7pgfaultP10UTrapframe+0xda>
        panic("sys_page_map: %e", r);
  801873:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801877:	c7 44 24 08 78 4c 80 	movl   $0x804c78,0x8(%esp)
  80187e:	00 
  80187f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801886:	00 
  801887:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  80188e:	e8 f5 ed ff ff       	call   800688 <_Z6_panicPKciS0_z>

    // and unmap PFTEMP
    if ((r = sys_page_unmap(0, PFTEMP)) < 0)
  801893:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80189a:	00 
  80189b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a2:	e8 b6 fa ff ff       	call   80135d <_Z14sys_page_unmapiPv>
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	79 20                	jns    8018cb <_ZL7pgfaultP10UTrapframe+0x112>
        panic("sys_page_unmap: %e", r);
  8018ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018af:	c7 44 24 08 5d 51 80 	movl   $0x80515d,0x8(%esp)
  8018b6:	00 
  8018b7:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8018be:	00 
  8018bf:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  8018c6:	e8 bd ed ff ff       	call   800688 <_Z6_panicPKciS0_z>
    resume(utf);
  8018cb:	89 1c 24             	mov    %ebx,(%esp)
  8018ce:	e8 8d 2d 00 00       	call   804660 <resume>
}
  8018d3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8018d6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8018d9:	89 ec                	mov    %ebp,%esp
  8018db:	5d                   	pop    %ebp
  8018dc:	c3                   	ret    

008018dd <_Z4forkv>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	57                   	push   %edi
  8018e1:	56                   	push   %esi
  8018e2:	53                   	push   %ebx
  8018e3:	83 ec 1c             	sub    $0x1c,%esp
    int r;                          // errors
    int pn = UTOP / PGSIZE - 1;     // page number
    

    add_pgfault_handler(pgfault);
  8018e6:	c7 04 24 b9 17 80 00 	movl   $0x8017b9,(%esp)
  8018ed:	e8 99 2c 00 00       	call   80458b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
	envid_t ret;
	__asm __volatile("int %2"
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
  8018f2:	be 07 00 00 00       	mov    $0x7,%esi
  8018f7:	89 f0                	mov    %esi,%eax
  8018f9:	cd 30                	int    $0x30
  8018fb:	89 c6                	mov    %eax,%esi
  8018fd:	89 c7                	mov    %eax,%edi

    // fork new environment
    envid_t envid = sys_exofork();
    if (envid < 0)
  8018ff:	85 c0                	test   %eax,%eax
  801901:	79 20                	jns    801923 <_Z4forkv+0x46>
        panic("sys_exofork: %e", envid);
  801903:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801907:	c7 44 24 08 70 51 80 	movl   $0x805170,0x8(%esp)
  80190e:	00 
  80190f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801916:	00 
  801917:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  80191e:	e8 65 ed ff ff       	call   800688 <_Z6_panicPKciS0_z>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801923:	bb fe ef 0e 00       	mov    $0xeeffe,%ebx
    envid_t envid = sys_exofork();
    if (envid < 0)
        panic("sys_exofork: %e", envid);

    // if we are the child, update thisenv and exit
    if (envid == 0)
  801928:	85 c0                	test   %eax,%eax
  80192a:	75 1c                	jne    801948 <_Z4forkv+0x6b>
    {
        thisenv = &envs[ENVX(sys_getenvid())];
  80192c:	e8 07 f9 ff ff       	call   801238 <_Z12sys_getenvidv>
  801931:	25 ff 03 00 00       	and    $0x3ff,%eax
  801936:	6b c0 78             	imul   $0x78,%eax,%eax
  801939:	05 00 00 00 ef       	add    $0xef000000,%eax
  80193e:	a3 08 70 80 00       	mov    %eax,0x807008
        return 0;
  801943:	e9 de 00 00 00       	jmp    801a26 <_Z4forkv+0x149>
    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
    {
        // if the page directory present bit isn't set, we can
        // skip all of the pages of that directory entry
        if(!(vpd[pn >> 10] & PTE_P))
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	c1 f8 0a             	sar    $0xa,%eax
  80194d:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801954:	a8 01                	test   $0x1,%al
  801956:	75 08                	jne    801960 <_Z4forkv+0x83>
            pn = (pn >> 10) << 10;
  801958:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  80195e:	eb 19                	jmp    801979 <_Z4forkv+0x9c>

        // if the page table entry is set, then we need to 
        // duplicate the page
        else if (vpt[pn] & PTE_P)
  801960:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801967:	a8 01                	test   $0x1,%al
  801969:	74 0e                	je     801979 <_Z4forkv+0x9c>
            duppage(envid, pn);
  80196b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801970:	89 da                	mov    %ebx,%edx
  801972:	89 f8                	mov    %edi,%eax
  801974:	e8 5b fd ff ff       	call   8016d4 <_ZL7duppageijb>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }

    // loop over all pages in the user address space (below the stack)
    while (--pn >= 0)
  801979:	83 eb 01             	sub    $0x1,%ebx
  80197c:	79 ca                	jns    801948 <_Z4forkv+0x6b>
            duppage(envid, pn);
    }


    // set the pgfault_upcall of the child
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)thisenv->env_pgfault_upcall)))
  80197e:	a1 08 70 80 00       	mov    0x807008,%eax
  801983:	8b 40 5c             	mov    0x5c(%eax),%eax
  801986:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198a:	89 34 24             	mov    %esi,(%esp)
  80198d:	e8 43 fb ff ff       	call   8014d5 <_Z26sys_env_set_pgfault_upcalliPv>
  801992:	85 c0                	test   %eax,%eax
  801994:	74 20                	je     8019b6 <_Z4forkv+0xd9>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801996:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80199a:	c7 44 24 08 98 51 80 	movl   $0x805198,0x8(%esp)
  8019a1:	00 
  8019a2:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  8019a9:	00 
  8019aa:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  8019b1:	e8 d2 ec ff ff       	call   800688 <_Z6_panicPKciS0_z>

    // give the child an exception stack page
    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8019b6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8019bd:	00 
  8019be:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8019c5:	ee 
  8019c6:	89 34 24             	mov    %esi,(%esp)
  8019c9:	e8 d2 f8 ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	79 20                	jns    8019f2 <_Z4forkv+0x115>
        panic("sys_page_alloc: %e", r);
  8019d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019d6:	c7 44 24 08 3f 51 80 	movl   $0x80513f,0x8(%esp)
  8019dd:	00 
  8019de:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  8019e5:	00 
  8019e6:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  8019ed:	e8 96 ec ff ff       	call   800688 <_Z6_panicPKciS0_z>

    // and let the child go free!
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8019f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019f9:	00 
  8019fa:	89 34 24             	mov    %esi,(%esp)
  8019fd:	e8 b9 f9 ff ff       	call   8013bb <_Z18sys_env_set_statusii>
  801a02:	85 c0                	test   %eax,%eax
  801a04:	79 20                	jns    801a26 <_Z4forkv+0x149>
        panic("sys_env_set_status: %e", r);
  801a06:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a0a:	c7 44 24 08 80 51 80 	movl   $0x805180,0x8(%esp)
  801a11:	00 
  801a12:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801a19:	00 
  801a1a:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  801a21:	e8 62 ec ff ff       	call   800688 <_Z6_panicPKciS0_z>

    return envid;
}
  801a26:	89 f0                	mov    %esi,%eax
  801a28:	83 c4 1c             	add    $0x1c,%esp
  801a2b:	5b                   	pop    %ebx
  801a2c:	5e                   	pop    %esi
  801a2d:	5f                   	pop    %edi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <_Z5sforkv>:

// Challenge!
int
sfork(void)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	57                   	push   %edi
  801a34:	56                   	push   %esi
  801a35:	53                   	push   %ebx
  801a36:	83 ec 2c             	sub    $0x2c,%esp
    int r; 

    add_pgfault_handler(pgfault);
  801a39:	c7 04 24 b9 17 80 00 	movl   $0x8017b9,(%esp)
  801a40:	e8 46 2b 00 00       	call   80458b <_Z19add_pgfault_handlerPFvP10UTrapframeE>
  801a45:	be 07 00 00 00       	mov    $0x7,%esi
  801a4a:	89 f0                	mov    %esi,%eax
  801a4c:	cd 30                	int    $0x30
  801a4e:	89 c6                	mov    %eax,%esi
  801a50:	89 c7                	mov    %eax,%edi

    // make a new child
    envid_t envid = sys_exofork();
    if (envid < 0)
  801a52:	85 c0                	test   %eax,%eax
  801a54:	79 20                	jns    801a76 <_Z5sforkv+0x46>
        panic("sys_exofork: %e", envid);
  801a56:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a5a:	c7 44 24 08 70 51 80 	movl   $0x805170,0x8(%esp)
  801a61:	00 
  801a62:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  801a69:	00 
  801a6a:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  801a71:	e8 12 ec ff ff       	call   800688 <_Z6_panicPKciS0_z>

    // unlike above, no need to set thisenv for child
    if (envid == 0)
  801a76:	85 c0                	test   %eax,%eax
  801a78:	0f 84 40 01 00 00    	je     801bbe <_Z5sforkv+0x18e>

static __inline uint32_t
read_esp(void)
{
        uint32_t esp;
        __asm __volatile("movl %%esp,%0" : "=r" (esp));
  801a7e:	89 e3                	mov    %esp,%ebx
        return 0;
    
    // we only want to share the pages below the current stack page
    int pn = (read_esp() >> 12) - 1;
  801a80:	c1 eb 0c             	shr    $0xc,%ebx
  801a83:	83 eb 01             	sub    $0x1,%ebx
  801a86:	89 5d e4             	mov    %ebx,-0x1c(%ebp)

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  801a89:	eb 31                	jmp    801abc <_Z5sforkv+0x8c>
    {
        if(!(vpd[pn >> 10] & PTE_P))
  801a8b:	89 d8                	mov    %ebx,%eax
  801a8d:	c1 f8 0a             	sar    $0xa,%eax
  801a90:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801a97:	a8 01                	test   $0x1,%al
  801a99:	75 08                	jne    801aa3 <_Z5sforkv+0x73>
            pn = (pn >> 10) << 10;
  801a9b:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801aa1:	eb 19                	jmp    801abc <_Z5sforkv+0x8c>
        else if (vpt[pn] & PTE_P)
  801aa3:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801aaa:	a8 01                	test   $0x1,%al
  801aac:	74 0e                	je     801abc <_Z5sforkv+0x8c>
            duppage(envid, pn, true);
  801aae:	b9 01 00 00 00       	mov    $0x1,%ecx
  801ab3:	89 da                	mov    %ebx,%edx
  801ab5:	89 f8                	mov    %edi,%eax
  801ab7:	e8 18 fc ff ff       	call   8016d4 <_ZL7duppageijb>

    // remember the lowest stack page so we can mark all of them COW
    int pn_start = pn;

    // same as in fork
    while (--pn >= 0)
  801abc:	83 eb 01             	sub    $0x1,%ebx
  801abf:	79 ca                	jns    801a8b <_Z5sforkv+0x5b>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  801ac1:	81 7d e4 fe ef 0e 00 	cmpl   $0xeeffe,-0x1c(%ebp)
  801ac8:	7f 3f                	jg     801b09 <_Z5sforkv+0xd9>
  801aca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    {
        if(!(vpd[i >> 10] & PTE_P))
  801acd:	89 d8                	mov    %ebx,%eax
  801acf:	c1 f8 0a             	sar    $0xa,%eax
  801ad2:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801ad9:	a8 01                	test   $0x1,%al
  801adb:	75 08                	jne    801ae5 <_Z5sforkv+0xb5>
            i = (i >> 10) << 10;
  801add:	81 e3 00 fc ff ff    	and    $0xfffffc00,%ebx
  801ae3:	eb 19                	jmp    801afe <_Z5sforkv+0xce>
        else if (vpt[i] & PTE_P)
  801ae5:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
  801aec:	a8 01                	test   $0x1,%al
  801aee:	74 0e                	je     801afe <_Z5sforkv+0xce>
            duppage(envid, i);
  801af0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af5:	89 da                	mov    %ebx,%edx
  801af7:	89 f8                	mov    %edi,%eax
  801af9:	e8 d6 fb ff ff       	call   8016d4 <_ZL7duppageijb>
        else if (vpt[pn] & PTE_P)
            duppage(envid, pn, true);
    }

    // same as above, but duppage isn't flagged to share pages
    for(int i = pn_start; i < (int)(UTOP / PGSIZE - 1); i++)
  801afe:	83 c3 01             	add    $0x1,%ebx
  801b01:	81 fb fe ef 0e 00    	cmp    $0xeeffe,%ebx
  801b07:	7e c4                	jle    801acd <_Z5sforkv+0x9d>
        else if (vpt[i] & PTE_P)
            duppage(envid, i);
    }

    // same as in fork!
    if ((r = sys_env_set_pgfault_upcall(envid, (void *)THISENV->env_pgfault_upcall)))
  801b09:	e8 2a f7 ff ff       	call   801238 <_Z12sys_getenvidv>
  801b0e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b13:	6b c0 78             	imul   $0x78,%eax,%eax
  801b16:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  801b1b:	8b 40 50             	mov    0x50(%eax),%eax
  801b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b22:	89 34 24             	mov    %esi,(%esp)
  801b25:	e8 ab f9 ff ff       	call   8014d5 <_Z26sys_env_set_pgfault_upcalliPv>
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	74 20                	je     801b4e <_Z5sforkv+0x11e>
        panic("sys_env_set_pgfault_upcall: %e", r);
  801b2e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b32:	c7 44 24 08 98 51 80 	movl   $0x805198,0x8(%esp)
  801b39:	00 
  801b3a:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801b41:	00 
  801b42:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  801b49:	e8 3a eb ff ff       	call   800688 <_Z6_panicPKciS0_z>

    if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b4e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801b55:	00 
  801b56:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  801b5d:	ee 
  801b5e:	89 34 24             	mov    %esi,(%esp)
  801b61:	e8 3a f7 ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  801b66:	85 c0                	test   %eax,%eax
  801b68:	79 20                	jns    801b8a <_Z5sforkv+0x15a>
        panic("sys_page_alloc: %e", r);
  801b6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b6e:	c7 44 24 08 3f 51 80 	movl   $0x80513f,0x8(%esp)
  801b75:	00 
  801b76:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  801b7d:	00 
  801b7e:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  801b85:	e8 fe ea ff ff       	call   800688 <_Z6_panicPKciS0_z>
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801b8a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b91:	00 
  801b92:	89 34 24             	mov    %esi,(%esp)
  801b95:	e8 21 f8 ff ff       	call   8013bb <_Z18sys_env_set_statusii>
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	79 20                	jns    801bbe <_Z5sforkv+0x18e>
        panic("sys_env_set_status: %e", r);
  801b9e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ba2:	c7 44 24 08 80 51 80 	movl   $0x805180,0x8(%esp)
  801ba9:	00 
  801baa:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  801bb1:	00 
  801bb2:	c7 04 24 52 51 80 00 	movl   $0x805152,(%esp)
  801bb9:	e8 ca ea ff ff       	call   800688 <_Z6_panicPKciS0_z>

    return envid;
    
}
  801bbe:	89 f0                	mov    %esi,%eax
  801bc0:	83 c4 2c             	add    $0x2c,%esp
  801bc3:	5b                   	pop    %ebx
  801bc4:	5e                   	pop    %esi
  801bc5:	5f                   	pop    %edi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
	...

00801bd0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	56                   	push   %esi
  801bd4:	53                   	push   %ebx
  801bd5:	83 ec 10             	sub    $0x10,%esp
  801bd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bde:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  801be1:	85 c0                	test   %eax,%eax
  801be3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  801be8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  801beb:	89 04 24             	mov    %eax,(%esp)
  801bee:	e8 78 f9 ff ff       	call   80156b <_Z12sys_ipc_recvPv>
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	79 16                	jns    801c0d <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  801bf7:	85 db                	test   %ebx,%ebx
  801bf9:	74 06                	je     801c01 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  801bfb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  801c01:	85 f6                	test   %esi,%esi
  801c03:	74 53                	je     801c58 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  801c05:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  801c0b:	eb 4b                	jmp    801c58 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  801c0d:	85 db                	test   %ebx,%ebx
  801c0f:	74 17                	je     801c28 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  801c11:	e8 22 f6 ff ff       	call   801238 <_Z12sys_getenvidv>
  801c16:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c1b:	6b c0 78             	imul   $0x78,%eax,%eax
  801c1e:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  801c23:	8b 40 60             	mov    0x60(%eax),%eax
  801c26:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  801c28:	85 f6                	test   %esi,%esi
  801c2a:	74 17                	je     801c43 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  801c2c:	e8 07 f6 ff ff       	call   801238 <_Z12sys_getenvidv>
  801c31:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c36:	6b c0 78             	imul   $0x78,%eax,%eax
  801c39:	05 00 00 00 ef       	add    $0xef000000,%eax
  801c3e:	8b 40 70             	mov    0x70(%eax),%eax
  801c41:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  801c43:	e8 f0 f5 ff ff       	call   801238 <_Z12sys_getenvidv>
  801c48:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c4d:	6b c0 78             	imul   $0x78,%eax,%eax
  801c50:	05 08 00 00 ef       	add    $0xef000008,%eax
  801c55:	8b 40 60             	mov    0x60(%eax),%eax

}
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5d                   	pop    %ebp
  801c5e:	c3                   	ret    

00801c5f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	57                   	push   %edi
  801c63:	56                   	push   %esi
  801c64:	53                   	push   %ebx
  801c65:	83 ec 1c             	sub    $0x1c,%esp
  801c68:	8b 75 08             	mov    0x8(%ebp),%esi
  801c6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  801c71:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  801c73:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  801c78:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  801c7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c82:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c86:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c8a:	89 34 24             	mov    %esi,(%esp)
  801c8d:	e8 a1 f8 ff ff       	call   801533 <_Z16sys_ipc_try_sendijPvi>
  801c92:	85 c0                	test   %eax,%eax
  801c94:	79 31                	jns    801cc7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  801c96:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c99:	75 0c                	jne    801ca7 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  801c9b:	90                   	nop
  801c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ca0:	e8 c7 f5 ff ff       	call   80126c <_Z9sys_yieldv>
  801ca5:	eb d4                	jmp    801c7b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  801ca7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cab:	c7 44 24 08 b7 51 80 	movl   $0x8051b7,0x8(%esp)
  801cb2:	00 
  801cb3:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801cba:	00 
  801cbb:	c7 04 24 c4 51 80 00 	movl   $0x8051c4,(%esp)
  801cc2:	e8 c1 e9 ff ff       	call   800688 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  801cc7:	83 c4 1c             	add    $0x1c,%esp
  801cca:	5b                   	pop    %ebx
  801ccb:	5e                   	pop    %esi
  801ccc:	5f                   	pop    %edi
  801ccd:	5d                   	pop    %ebp
  801cce:	c3                   	ret    
	...

00801cd0 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801cd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801cd8:	75 11                	jne    801ceb <_ZL8fd_validPK2Fd+0x1b>
  801cda:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  801cdf:	76 0a                	jbe    801ceb <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801ce1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801ce6:	0f 96 c0             	setbe  %al
  801ce9:	eb 05                	jmp    801cf0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf0:	5d                   	pop    %ebp
  801cf1:	c3                   	ret    

00801cf2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	53                   	push   %ebx
  801cf6:	83 ec 14             	sub    $0x14,%esp
  801cf9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  801cfb:	e8 d0 ff ff ff       	call   801cd0 <_ZL8fd_validPK2Fd>
  801d00:	84 c0                	test   %al,%al
  801d02:	75 24                	jne    801d28 <_ZL9fd_isopenPK2Fd+0x36>
  801d04:	c7 44 24 0c ce 51 80 	movl   $0x8051ce,0xc(%esp)
  801d0b:	00 
  801d0c:	c7 44 24 08 db 51 80 	movl   $0x8051db,0x8(%esp)
  801d13:	00 
  801d14:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801d1b:	00 
  801d1c:	c7 04 24 f0 51 80 00 	movl   $0x8051f0,(%esp)
  801d23:	e8 60 e9 ff ff       	call   800688 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801d28:	89 d8                	mov    %ebx,%eax
  801d2a:	c1 e8 16             	shr    $0x16,%eax
  801d2d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	f6 c2 01             	test   $0x1,%dl
  801d3c:	74 0d                	je     801d4b <_ZL9fd_isopenPK2Fd+0x59>
  801d3e:	c1 eb 0c             	shr    $0xc,%ebx
  801d41:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801d48:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  801d4b:	83 c4 14             	add    $0x14,%esp
  801d4e:	5b                   	pop    %ebx
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    

00801d51 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 08             	sub    $0x8,%esp
  801d57:	89 1c 24             	mov    %ebx,(%esp)
  801d5a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d61:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d64:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801d68:	83 fb 1f             	cmp    $0x1f,%ebx
  801d6b:	77 18                	ja     801d85 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  801d6d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801d73:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801d76:	84 c0                	test   %al,%al
  801d78:	74 21                	je     801d9b <_Z9fd_lookupiPP2Fdb+0x4a>
  801d7a:	89 d8                	mov    %ebx,%eax
  801d7c:	e8 71 ff ff ff       	call   801cf2 <_ZL9fd_isopenPK2Fd>
  801d81:	84 c0                	test   %al,%al
  801d83:	75 16                	jne    801d9b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801d85:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  801d8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801d90:	8b 1c 24             	mov    (%esp),%ebx
  801d93:	8b 74 24 04          	mov    0x4(%esp),%esi
  801d97:	89 ec                	mov    %ebp,%esp
  801d99:	5d                   	pop    %ebp
  801d9a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  801d9b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801da2:	eb ec                	jmp    801d90 <_Z9fd_lookupiPP2Fdb+0x3f>

00801da4 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	53                   	push   %ebx
  801da8:	83 ec 14             	sub    $0x14,%esp
  801dab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  801dae:	89 d8                	mov    %ebx,%eax
  801db0:	e8 1b ff ff ff       	call   801cd0 <_ZL8fd_validPK2Fd>
  801db5:	84 c0                	test   %al,%al
  801db7:	75 24                	jne    801ddd <_Z6fd2numP2Fd+0x39>
  801db9:	c7 44 24 0c ce 51 80 	movl   $0x8051ce,0xc(%esp)
  801dc0:	00 
  801dc1:	c7 44 24 08 db 51 80 	movl   $0x8051db,0x8(%esp)
  801dc8:	00 
  801dc9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801dd0:	00 
  801dd1:	c7 04 24 f0 51 80 00 	movl   $0x8051f0,(%esp)
  801dd8:	e8 ab e8 ff ff       	call   800688 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ddd:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801de3:	c1 e8 0c             	shr    $0xc,%eax
}
  801de6:	83 c4 14             	add    $0x14,%esp
  801de9:	5b                   	pop    %ebx
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	89 04 24             	mov    %eax,(%esp)
  801df8:	e8 a7 ff ff ff       	call   801da4 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  801dfd:	05 20 00 0d 00       	add    $0xd0020,%eax
  801e02:	c1 e0 0c             	shl    $0xc,%eax
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	57                   	push   %edi
  801e0b:	56                   	push   %esi
  801e0c:	53                   	push   %ebx
  801e0d:	83 ec 2c             	sub    $0x2c,%esp
  801e10:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801e13:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801e18:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  801e1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e22:	00 
  801e23:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e27:	89 1c 24             	mov    %ebx,(%esp)
  801e2a:	e8 22 ff ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  801e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e32:	e8 bb fe ff ff       	call   801cf2 <_ZL9fd_isopenPK2Fd>
  801e37:	84 c0                	test   %al,%al
  801e39:	75 0c                	jne    801e47 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  801e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3e:	89 07                	mov    %eax,(%edi)
			return 0;
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
  801e45:	eb 13                	jmp    801e5a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801e47:	83 c3 01             	add    $0x1,%ebx
  801e4a:	83 fb 20             	cmp    $0x20,%ebx
  801e4d:	75 cc                	jne    801e1b <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e4f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801e55:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e5a:	83 c4 2c             	add    $0x2c,%esp
  801e5d:	5b                   	pop    %ebx
  801e5e:	5e                   	pop    %esi
  801e5f:	5f                   	pop    %edi
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    

00801e62 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	53                   	push   %ebx
  801e66:	83 ec 14             	sub    $0x14,%esp
  801e69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  801e6f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801e74:	39 0d 04 60 80 00    	cmp    %ecx,0x806004
  801e7a:	75 16                	jne    801e92 <_Z10dev_lookupiPP3Dev+0x30>
  801e7c:	eb 06                	jmp    801e84 <_Z10dev_lookupiPP3Dev+0x22>
  801e7e:	39 0a                	cmp    %ecx,(%edx)
  801e80:	75 10                	jne    801e92 <_Z10dev_lookupiPP3Dev+0x30>
  801e82:	eb 05                	jmp    801e89 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e84:	ba 04 60 80 00       	mov    $0x806004,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801e89:	89 13                	mov    %edx,(%ebx)
			return 0;
  801e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e90:	eb 35                	jmp    801ec7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e92:	83 c0 01             	add    $0x1,%eax
  801e95:	8b 14 85 5c 52 80 00 	mov    0x80525c(,%eax,4),%edx
  801e9c:	85 d2                	test   %edx,%edx
  801e9e:	75 de                	jne    801e7e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ea0:	a1 08 70 80 00       	mov    0x807008,%eax
  801ea5:	8b 40 04             	mov    0x4(%eax),%eax
  801ea8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb0:	c7 04 24 18 52 80 00 	movl   $0x805218,(%esp)
  801eb7:	e8 ea e8 ff ff       	call   8007a6 <_Z7cprintfPKcz>
	*dev = 0;
  801ebc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801ec2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ec7:	83 c4 14             	add    $0x14,%esp
  801eca:	5b                   	pop    %ebx
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    

00801ecd <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	56                   	push   %esi
  801ed1:	53                   	push   %ebx
  801ed2:	83 ec 20             	sub    $0x20,%esp
  801ed5:	8b 75 08             	mov    0x8(%ebp),%esi
  801ed8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  801edc:	89 34 24             	mov    %esi,(%esp)
  801edf:	e8 c0 fe ff ff       	call   801da4 <_Z6fd2numP2Fd>
  801ee4:	0f b6 d3             	movzbl %bl,%edx
  801ee7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eeb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801eee:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ef2:	89 04 24             	mov    %eax,(%esp)
  801ef5:	e8 57 fe ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 05                	js     801f03 <_Z8fd_closeP2Fdb+0x36>
  801efe:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801f01:	74 0c                	je     801f0f <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801f03:	80 fb 01             	cmp    $0x1,%bl
  801f06:	19 db                	sbb    %ebx,%ebx
  801f08:	f7 d3                	not    %ebx
  801f0a:	83 e3 fd             	and    $0xfffffffd,%ebx
  801f0d:	eb 3d                	jmp    801f4c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f16:	8b 06                	mov    (%esi),%eax
  801f18:	89 04 24             	mov    %eax,(%esp)
  801f1b:	e8 42 ff ff ff       	call   801e62 <_Z10dev_lookupiPP3Dev>
  801f20:	89 c3                	mov    %eax,%ebx
  801f22:	85 c0                	test   %eax,%eax
  801f24:	78 16                	js     801f3c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f29:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801f2c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801f31:	85 c0                	test   %eax,%eax
  801f33:	74 07                	je     801f3c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801f35:	89 34 24             	mov    %esi,(%esp)
  801f38:	ff d0                	call   *%eax
  801f3a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f47:	e8 11 f4 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
	return r;
}
  801f4c:	89 d8                	mov    %ebx,%eax
  801f4e:	83 c4 20             	add    $0x20,%esp
  801f51:	5b                   	pop    %ebx
  801f52:	5e                   	pop    %esi
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    

00801f55 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801f5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801f62:	00 
  801f63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f66:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	89 04 24             	mov    %eax,(%esp)
  801f70:	e8 dc fd ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  801f75:	85 c0                	test   %eax,%eax
  801f77:	78 13                	js     801f8c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801f79:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f80:	00 
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	89 04 24             	mov    %eax,(%esp)
  801f87:	e8 41 ff ff ff       	call   801ecd <_Z8fd_closeP2Fdb>
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <_Z9close_allv>:

void
close_all(void)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	53                   	push   %ebx
  801f92:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801f95:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801f9a:	89 1c 24             	mov    %ebx,(%esp)
  801f9d:	e8 b3 ff ff ff       	call   801f55 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801fa2:	83 c3 01             	add    $0x1,%ebx
  801fa5:	83 fb 20             	cmp    $0x20,%ebx
  801fa8:	75 f0                	jne    801f9a <_Z9close_allv+0xc>
		close(i);
}
  801faa:	83 c4 14             	add    $0x14,%esp
  801fad:	5b                   	pop    %ebx
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    

00801fb0 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 48             	sub    $0x48,%esp
  801fb6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801fb9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801fbc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801fbf:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801fc2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801fc9:	00 
  801fca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	89 04 24             	mov    %eax,(%esp)
  801fd7:	e8 75 fd ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  801fdc:	89 c3                	mov    %eax,%ebx
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	0f 88 ce 00 00 00    	js     8020b4 <_Z3dupii+0x104>
  801fe6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fed:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  801fee:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801ff5:	89 34 24             	mov    %esi,(%esp)
  801ff8:	e8 54 fd ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  801ffd:	89 c3                	mov    %eax,%ebx
  801fff:	85 c0                	test   %eax,%eax
  802001:	0f 89 bc 00 00 00    	jns    8020c3 <_Z3dupii+0x113>
  802007:	e9 a8 00 00 00       	jmp    8020b4 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  80200c:	89 d8                	mov    %ebx,%eax
  80200e:	c1 e8 0c             	shr    $0xc,%eax
  802011:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  802018:	f6 c2 01             	test   $0x1,%dl
  80201b:	74 32                	je     80204f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80201d:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  802024:	25 07 0e 00 00       	and    $0xe07,%eax
  802029:	89 44 24 10          	mov    %eax,0x10(%esp)
  80202d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802031:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802038:	00 
  802039:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80203d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802044:	e8 b6 f2 ff ff       	call   8012ff <_Z12sys_page_mapiPviS_i>
  802049:	89 c3                	mov    %eax,%ebx
  80204b:	85 c0                	test   %eax,%eax
  80204d:	78 3e                	js     80208d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80204f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802052:	89 c2                	mov    %eax,%edx
  802054:	c1 ea 0c             	shr    $0xc,%edx
  802057:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  80205e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802064:	89 54 24 10          	mov    %edx,0x10(%esp)
  802068:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80206b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80206f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802076:	00 
  802077:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802082:	e8 78 f2 ff ff       	call   8012ff <_Z12sys_page_mapiPviS_i>
  802087:	89 c3                	mov    %eax,%ebx
  802089:	85 c0                	test   %eax,%eax
  80208b:	79 25                	jns    8020b2 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80208d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802090:	89 44 24 04          	mov    %eax,0x4(%esp)
  802094:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80209b:	e8 bd f2 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  8020a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8020a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ab:	e8 ad f2 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
	return r;
  8020b0:	eb 02                	jmp    8020b4 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  8020b2:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8020b4:	89 d8                	mov    %ebx,%eax
  8020b6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020b9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020bc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020bf:	89 ec                	mov    %ebp,%esp
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  8020c3:	89 34 24             	mov    %esi,(%esp)
  8020c6:	e8 8a fe ff ff       	call   801f55 <_Z5closei>

	ova = fd2data(oldfd);
  8020cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020ce:	89 04 24             	mov    %eax,(%esp)
  8020d1:	e8 16 fd ff ff       	call   801dec <_Z7fd2dataP2Fd>
  8020d6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8020d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020db:	89 04 24             	mov    %eax,(%esp)
  8020de:	e8 09 fd ff ff       	call   801dec <_Z7fd2dataP2Fd>
  8020e3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  8020e5:	89 d8                	mov    %ebx,%eax
  8020e7:	c1 e8 16             	shr    $0x16,%eax
  8020ea:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8020f1:	a8 01                	test   $0x1,%al
  8020f3:	0f 85 13 ff ff ff    	jne    80200c <_Z3dupii+0x5c>
  8020f9:	e9 51 ff ff ff       	jmp    80204f <_Z3dupii+0x9f>

008020fe <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	53                   	push   %ebx
  802102:	83 ec 24             	sub    $0x24,%esp
  802105:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802108:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80210f:	00 
  802110:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802113:	89 44 24 04          	mov    %eax,0x4(%esp)
  802117:	89 1c 24             	mov    %ebx,(%esp)
  80211a:	e8 32 fc ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 5f                	js     802182 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802123:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802126:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80212d:	8b 00                	mov    (%eax),%eax
  80212f:	89 04 24             	mov    %eax,(%esp)
  802132:	e8 2b fd ff ff       	call   801e62 <_Z10dev_lookupiPP3Dev>
  802137:	85 c0                	test   %eax,%eax
  802139:	79 4d                	jns    802188 <_Z4readiPvj+0x8a>
  80213b:	eb 45                	jmp    802182 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80213d:	a1 08 70 80 00       	mov    0x807008,%eax
  802142:	8b 40 04             	mov    0x4(%eax),%eax
  802145:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802149:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214d:	c7 04 24 f9 51 80 00 	movl   $0x8051f9,(%esp)
  802154:	e8 4d e6 ff ff       	call   8007a6 <_Z7cprintfPKcz>
		return -E_INVAL;
  802159:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80215e:	eb 22                	jmp    802182 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  802160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802163:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  802166:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80216b:	85 d2                	test   %edx,%edx
  80216d:	74 13                	je     802182 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80216f:	8b 45 10             	mov    0x10(%ebp),%eax
  802172:	89 44 24 08          	mov    %eax,0x8(%esp)
  802176:	8b 45 0c             	mov    0xc(%ebp),%eax
  802179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217d:	89 0c 24             	mov    %ecx,(%esp)
  802180:	ff d2                	call   *%edx
}
  802182:	83 c4 24             	add    $0x24,%esp
  802185:	5b                   	pop    %ebx
  802186:	5d                   	pop    %ebp
  802187:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802188:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80218b:	8b 41 08             	mov    0x8(%ecx),%eax
  80218e:	83 e0 03             	and    $0x3,%eax
  802191:	83 f8 01             	cmp    $0x1,%eax
  802194:	75 ca                	jne    802160 <_Z4readiPvj+0x62>
  802196:	eb a5                	jmp    80213d <_Z4readiPvj+0x3f>

00802198 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	57                   	push   %edi
  80219c:	56                   	push   %esi
  80219d:	53                   	push   %ebx
  80219e:	83 ec 1c             	sub    $0x1c,%esp
  8021a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8021a4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8021a7:	85 f6                	test   %esi,%esi
  8021a9:	74 2f                	je     8021da <_Z5readniPvj+0x42>
  8021ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021b0:	89 f0                	mov    %esi,%eax
  8021b2:	29 d8                	sub    %ebx,%eax
  8021b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b8:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8021bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	89 04 24             	mov    %eax,(%esp)
  8021c5:	e8 34 ff ff ff       	call   8020fe <_Z4readiPvj>
		if (m < 0)
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	78 13                	js     8021e1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	74 0d                	je     8021df <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  8021d2:	01 c3                	add    %eax,%ebx
  8021d4:	39 de                	cmp    %ebx,%esi
  8021d6:	77 d8                	ja     8021b0 <_Z5readniPvj+0x18>
  8021d8:	eb 05                	jmp    8021df <_Z5readniPvj+0x47>
  8021da:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8021df:	89 d8                	mov    %ebx,%eax
}
  8021e1:	83 c4 1c             	add    $0x1c,%esp
  8021e4:	5b                   	pop    %ebx
  8021e5:	5e                   	pop    %esi
  8021e6:	5f                   	pop    %edi
  8021e7:	5d                   	pop    %ebp
  8021e8:	c3                   	ret    

008021e9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8021ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021f6:	00 
  8021f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	89 04 24             	mov    %eax,(%esp)
  802204:	e8 48 fb ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  802209:	85 c0                	test   %eax,%eax
  80220b:	78 3c                	js     802249 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80220d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802210:	89 44 24 04          	mov    %eax,0x4(%esp)
  802214:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802217:	8b 00                	mov    (%eax),%eax
  802219:	89 04 24             	mov    %eax,(%esp)
  80221c:	e8 41 fc ff ff       	call   801e62 <_Z10dev_lookupiPP3Dev>
  802221:	85 c0                	test   %eax,%eax
  802223:	79 26                	jns    80224b <_Z5writeiPKvj+0x62>
  802225:	eb 22                	jmp    802249 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  80222d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  802232:	85 c9                	test   %ecx,%ecx
  802234:	74 13                	je     802249 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802236:	8b 45 10             	mov    0x10(%ebp),%eax
  802239:	89 44 24 08          	mov    %eax,0x8(%esp)
  80223d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802240:	89 44 24 04          	mov    %eax,0x4(%esp)
  802244:	89 14 24             	mov    %edx,(%esp)
  802247:	ff d1                	call   *%ecx
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80224b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80224e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  802253:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  802257:	74 f0                	je     802249 <_Z5writeiPKvj+0x60>
  802259:	eb cc                	jmp    802227 <_Z5writeiPKvj+0x3e>

0080225b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  802261:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802268:	00 
  802269:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	89 04 24             	mov    %eax,(%esp)
  802276:	e8 d6 fa ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  80227b:	85 c0                	test   %eax,%eax
  80227d:	78 0e                	js     80228d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	8b 55 0c             	mov    0xc(%ebp),%edx
  802285:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	53                   	push   %ebx
  802293:	83 ec 24             	sub    $0x24,%esp
  802296:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802299:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022a0:	00 
  8022a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a8:	89 1c 24             	mov    %ebx,(%esp)
  8022ab:	e8 a1 fa ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	78 58                	js     80230c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	89 04 24             	mov    %eax,(%esp)
  8022c3:	e8 9a fb ff ff       	call   801e62 <_Z10dev_lookupiPP3Dev>
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	79 46                	jns    802312 <_Z9ftruncateii+0x83>
  8022cc:	eb 3e                	jmp    80230c <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  8022ce:	a1 08 70 80 00       	mov    0x807008,%eax
  8022d3:	8b 40 04             	mov    0x4(%eax),%eax
  8022d6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022de:	c7 04 24 38 52 80 00 	movl   $0x805238,(%esp)
  8022e5:	e8 bc e4 ff ff       	call   8007a6 <_Z7cprintfPKcz>
		return -E_INVAL;
  8022ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022ef:	eb 1b                	jmp    80230c <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8022f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8022fc:	85 d2                	test   %edx,%edx
  8022fe:	74 0c                	je     80230c <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802300:	8b 45 0c             	mov    0xc(%ebp),%eax
  802303:	89 44 24 04          	mov    %eax,0x4(%esp)
  802307:	89 0c 24             	mov    %ecx,(%esp)
  80230a:	ff d2                	call   *%edx
}
  80230c:	83 c4 24             	add    $0x24,%esp
  80230f:	5b                   	pop    %ebx
  802310:	5d                   	pop    %ebp
  802311:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802312:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802315:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  802319:	75 d6                	jne    8022f1 <_Z9ftruncateii+0x62>
  80231b:	eb b1                	jmp    8022ce <_Z9ftruncateii+0x3f>

0080231d <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	53                   	push   %ebx
  802321:	83 ec 24             	sub    $0x24,%esp
  802324:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802327:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80232e:	00 
  80232f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802332:	89 44 24 04          	mov    %eax,0x4(%esp)
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	89 04 24             	mov    %eax,(%esp)
  80233c:	e8 10 fa ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  802341:	85 c0                	test   %eax,%eax
  802343:	78 3e                	js     802383 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802345:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	89 04 24             	mov    %eax,(%esp)
  802354:	e8 09 fb ff ff       	call   801e62 <_Z10dev_lookupiPP3Dev>
  802359:	85 c0                	test   %eax,%eax
  80235b:	79 2c                	jns    802389 <_Z5fstatiP4Stat+0x6c>
  80235d:	eb 24                	jmp    802383 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80235f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802362:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  802369:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  802370:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802376:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237d:	89 04 24             	mov    %eax,(%esp)
  802380:	ff 52 14             	call   *0x14(%edx)
}
  802383:	83 c4 24             	add    $0x24,%esp
  802386:	5b                   	pop    %ebx
  802387:	5d                   	pop    %ebp
  802388:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802389:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80238c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802391:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  802395:	75 c8                	jne    80235f <_Z5fstatiP4Stat+0x42>
  802397:	eb ea                	jmp    802383 <_Z5fstatiP4Stat+0x66>

00802399 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 18             	sub    $0x18,%esp
  80239f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023a2:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8023a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023ac:	00 
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	89 04 24             	mov    %eax,(%esp)
  8023b3:	e8 d6 09 00 00       	call   802d8e <_Z4openPKci>
  8023b8:	89 c3                	mov    %eax,%ebx
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	78 1b                	js     8023d9 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8023be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c5:	89 1c 24             	mov    %ebx,(%esp)
  8023c8:	e8 50 ff ff ff       	call   80231d <_Z5fstatiP4Stat>
  8023cd:	89 c6                	mov    %eax,%esi
	close(fd);
  8023cf:	89 1c 24             	mov    %ebx,(%esp)
  8023d2:	e8 7e fb ff ff       	call   801f55 <_Z5closei>
	return r;
  8023d7:	89 f3                	mov    %esi,%ebx
}
  8023d9:	89 d8                	mov    %ebx,%eax
  8023db:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8023de:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8023e1:	89 ec                	mov    %ebp,%esp
  8023e3:	5d                   	pop    %ebp
  8023e4:	c3                   	ret    
	...

008023f0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8023f3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8023f8:	85 d2                	test   %edx,%edx
  8023fa:	78 33                	js     80242f <_ZL10inode_dataP5Inodei+0x3f>
  8023fc:	3b 50 08             	cmp    0x8(%eax),%edx
  8023ff:	7d 2e                	jge    80242f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  802401:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802407:	85 d2                	test   %edx,%edx
  802409:	0f 49 ca             	cmovns %edx,%ecx
  80240c:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  80240f:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  802413:	c1 e1 0c             	shl    $0xc,%ecx
  802416:	89 d0                	mov    %edx,%eax
  802418:	c1 f8 1f             	sar    $0x1f,%eax
  80241b:	c1 e8 14             	shr    $0x14,%eax
  80241e:	01 c2                	add    %eax,%edx
  802420:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802426:	29 c2                	sub    %eax,%edx
  802428:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  80242f:	89 c8                	mov    %ecx,%eax
  802431:	5d                   	pop    %ebp
  802432:	c3                   	ret    

00802433 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  802436:	8b 48 08             	mov    0x8(%eax),%ecx
  802439:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  802441:	c7 82 80 00 00 00 04 	movl   $0x806004,0x80(%edx)
  802448:	60 80 00 
}
  80244b:	5d                   	pop    %ebp
  80244c:	c3                   	ret    

0080244d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802453:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  802459:	85 c0                	test   %eax,%eax
  80245b:	74 08                	je     802465 <_ZL9get_inodei+0x18>
  80245d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802463:	7e 20                	jle    802485 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  802465:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802469:	c7 44 24 08 70 52 80 	movl   $0x805270,0x8(%esp)
  802470:	00 
  802471:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  802478:	00 
  802479:	c7 04 24 86 52 80 00 	movl   $0x805286,(%esp)
  802480:	e8 03 e2 ff ff       	call   800688 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802485:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80248b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802491:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802497:	85 d2                	test   %edx,%edx
  802499:	0f 48 d1             	cmovs  %ecx,%edx
  80249c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  80249f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  8024a6:	c1 e0 0c             	shl    $0xc,%eax
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	56                   	push   %esi
  8024af:	53                   	push   %ebx
  8024b0:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  8024b3:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  8024b9:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  8024bc:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  8024c2:	76 20                	jbe    8024e4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  8024c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c8:	c7 44 24 08 ac 52 80 	movl   $0x8052ac,0x8(%esp)
  8024cf:	00 
  8024d0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8024d7:	00 
  8024d8:	c7 04 24 86 52 80 00 	movl   $0x805286,(%esp)
  8024df:	e8 a4 e1 ff ff       	call   800688 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  8024e4:	83 fe 01             	cmp    $0x1,%esi
  8024e7:	7e 08                	jle    8024f1 <_ZL10bcache_ipcPvi+0x46>
  8024e9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  8024ef:	7d 12                	jge    802503 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8024f1:	89 f3                	mov    %esi,%ebx
  8024f3:	c1 e3 04             	shl    $0x4,%ebx
  8024f6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8024f8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  8024fe:	c1 e6 0c             	shl    $0xc,%esi
  802501:	eb 20                	jmp    802523 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  802503:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802507:	c7 44 24 08 dc 52 80 	movl   $0x8052dc,0x8(%esp)
  80250e:	00 
  80250f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802516:	00 
  802517:	c7 04 24 86 52 80 00 	movl   $0x805286,(%esp)
  80251e:	e8 65 e1 ff ff       	call   800688 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802523:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80252a:	00 
  80252b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802532:	00 
  802533:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802537:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  80253e:	e8 1c f7 ff ff       	call   801c5f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802543:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80254a:	00 
  80254b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80254f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802556:	e8 75 f6 ff ff       	call   801bd0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  80255b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80255e:	74 c3                	je     802523 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  802560:	83 c4 10             	add    $0x10,%esp
  802563:	5b                   	pop    %ebx
  802564:	5e                   	pop    %esi
  802565:	5d                   	pop    %ebp
  802566:	c3                   	ret    

00802567 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
  80256a:	83 ec 28             	sub    $0x28,%esp
  80256d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802570:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802573:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802576:	89 c7                	mov    %eax,%edi
  802578:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  80257a:	c7 04 24 0d 28 80 00 	movl   $0x80280d,(%esp)
  802581:	e8 05 20 00 00       	call   80458b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  802586:	89 f8                	mov    %edi,%eax
  802588:	e8 c0 fe ff ff       	call   80244d <_ZL9get_inodei>
  80258d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  80258f:	ba 02 00 00 00       	mov    $0x2,%edx
  802594:	e8 12 ff ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
	if (r < 0) {
  802599:	85 c0                	test   %eax,%eax
  80259b:	79 08                	jns    8025a5 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  80259d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  8025a3:	eb 2e                	jmp    8025d3 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	75 1c                	jne    8025c5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  8025a9:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  8025af:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  8025b6:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  8025b9:	ba 06 00 00 00       	mov    $0x6,%edx
  8025be:	89 d8                	mov    %ebx,%eax
  8025c0:	e8 e6 fe ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  8025c5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  8025cc:	89 1e                	mov    %ebx,(%esi)
	return 0;
  8025ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025d6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025d9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025dc:	89 ec                	mov    %ebp,%esp
  8025de:	5d                   	pop    %ebp
  8025df:	c3                   	ret    

008025e0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	57                   	push   %edi
  8025e4:	56                   	push   %esi
  8025e5:	53                   	push   %ebx
  8025e6:	83 ec 2c             	sub    $0x2c,%esp
  8025e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025ec:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  8025ef:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  8025f4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  8025fa:	0f 87 3d 01 00 00    	ja     80273d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  802600:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802603:	8b 42 08             	mov    0x8(%edx),%eax
  802606:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  80260c:	85 c0                	test   %eax,%eax
  80260e:	0f 49 f0             	cmovns %eax,%esi
  802611:	c1 fe 0c             	sar    $0xc,%esi
  802614:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  802616:	8b 7d d8             	mov    -0x28(%ebp),%edi
  802619:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  80261f:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  802622:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802625:	0f 82 a6 00 00 00    	jb     8026d1 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  80262b:	39 fe                	cmp    %edi,%esi
  80262d:	0f 8d f2 00 00 00    	jge    802725 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802633:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  802637:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80263a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80263d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  802640:	83 3e 00             	cmpl   $0x0,(%esi)
  802643:	75 77                	jne    8026bc <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802645:	ba 02 00 00 00       	mov    $0x2,%edx
  80264a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80264f:	e8 57 fe ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802654:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  80265a:	83 f9 02             	cmp    $0x2,%ecx
  80265d:	7e 43                	jle    8026a2 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  80265f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802664:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  802669:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802670:	74 29                	je     80269b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802672:	e9 ce 00 00 00       	jmp    802745 <_ZL14inode_set_sizeP5Inodej+0x165>
  802677:	89 c7                	mov    %eax,%edi
  802679:	0f b6 10             	movzbl (%eax),%edx
  80267c:	83 c0 01             	add    $0x1,%eax
  80267f:	84 d2                	test   %dl,%dl
  802681:	74 18                	je     80269b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802683:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802686:	ba 05 00 00 00       	mov    $0x5,%edx
  80268b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802690:	e8 16 fe ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802695:	85 db                	test   %ebx,%ebx
  802697:	79 1e                	jns    8026b7 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802699:	eb 07                	jmp    8026a2 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80269b:	83 c3 01             	add    $0x1,%ebx
  80269e:	39 d9                	cmp    %ebx,%ecx
  8026a0:	7f d5                	jg     802677 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  8026a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026a5:	8b 50 08             	mov    0x8(%eax),%edx
  8026a8:	e8 33 ff ff ff       	call   8025e0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  8026ad:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8026b2:	e9 86 00 00 00       	jmp    80273d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  8026b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ba:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  8026bc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  8026c0:	83 c6 04             	add    $0x4,%esi
  8026c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8026c9:	0f 8f 6e ff ff ff    	jg     80263d <_ZL14inode_set_sizeP5Inodej+0x5d>
  8026cf:	eb 54                	jmp    802725 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  8026d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026d4:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  8026d9:	83 f8 01             	cmp    $0x1,%eax
  8026dc:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8026df:	ba 02 00 00 00       	mov    $0x2,%edx
  8026e4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8026e9:	e8 bd fd ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  8026ee:	39 f7                	cmp    %esi,%edi
  8026f0:	7d 24                	jge    802716 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8026f2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026f5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  8026f9:	8b 10                	mov    (%eax),%edx
  8026fb:	85 d2                	test   %edx,%edx
  8026fd:	74 0d                	je     80270c <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  8026ff:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  802706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  80270c:	83 eb 01             	sub    $0x1,%ebx
  80270f:	83 e8 04             	sub    $0x4,%eax
  802712:	39 fb                	cmp    %edi,%ebx
  802714:	75 e3                	jne    8026f9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802716:	ba 05 00 00 00       	mov    $0x5,%edx
  80271b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802720:	e8 86 fd ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  802725:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80272b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  80272e:	ba 04 00 00 00       	mov    $0x4,%edx
  802733:	e8 73 fd ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
	return 0;
  802738:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80273d:	83 c4 2c             	add    $0x2c,%esp
  802740:	5b                   	pop    %ebx
  802741:	5e                   	pop    %esi
  802742:	5f                   	pop    %edi
  802743:	5d                   	pop    %ebp
  802744:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802745:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  80274c:	ba 05 00 00 00       	mov    $0x5,%edx
  802751:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802756:	e8 50 fd ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80275b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802760:	e9 52 ff ff ff       	jmp    8026b7 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802765 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
  802768:	53                   	push   %ebx
  802769:	83 ec 04             	sub    $0x4,%esp
  80276c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  80276e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802774:	83 e8 01             	sub    $0x1,%eax
  802777:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  80277d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802781:	75 40                	jne    8027c3 <_ZL11inode_closeP5Inode+0x5e>
  802783:	85 c0                	test   %eax,%eax
  802785:	75 3c                	jne    8027c3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802787:	ba 02 00 00 00       	mov    $0x2,%edx
  80278c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802791:	e8 15 fd ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  80279b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  80279f:	85 d2                	test   %edx,%edx
  8027a1:	74 07                	je     8027aa <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  8027a3:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  8027aa:	83 c0 01             	add    $0x1,%eax
  8027ad:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  8027b2:	75 e7                	jne    80279b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8027b4:	ba 05 00 00 00       	mov    $0x5,%edx
  8027b9:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8027be:	e8 e8 fc ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  8027c3:	ba 03 00 00 00       	mov    $0x3,%edx
  8027c8:	89 d8                	mov    %ebx,%eax
  8027ca:	e8 dc fc ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
}
  8027cf:	83 c4 04             	add    $0x4,%esp
  8027d2:	5b                   	pop    %ebx
  8027d3:	5d                   	pop    %ebp
  8027d4:	c3                   	ret    

008027d5 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
  8027d8:	53                   	push   %ebx
  8027d9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8027e5:	e8 7d fd ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  8027ea:	89 c3                	mov    %eax,%ebx
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	78 15                	js     802805 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  8027f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	e8 e5 fd ff ff       	call   8025e0 <_ZL14inode_set_sizeP5Inodej>
  8027fb:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	e8 60 ff ff ff       	call   802765 <_ZL11inode_closeP5Inode>
	return r;
}
  802805:	89 d8                	mov    %ebx,%eax
  802807:	83 c4 14             	add    $0x14,%esp
  80280a:	5b                   	pop    %ebx
  80280b:	5d                   	pop    %ebp
  80280c:	c3                   	ret    

0080280d <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
  802810:	53                   	push   %ebx
  802811:	83 ec 14             	sub    $0x14,%esp
  802814:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  802817:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  802819:	89 c2                	mov    %eax,%edx
  80281b:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  802821:	78 32                	js     802855 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  802823:	ba 00 00 00 00       	mov    $0x0,%edx
  802828:	e8 7e fc ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
  80282d:	85 c0                	test   %eax,%eax
  80282f:	74 1c                	je     80284d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  802831:	c7 44 24 08 91 52 80 	movl   $0x805291,0x8(%esp)
  802838:	00 
  802839:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802840:	00 
  802841:	c7 04 24 86 52 80 00 	movl   $0x805286,(%esp)
  802848:	e8 3b de ff ff       	call   800688 <_Z6_panicPKciS0_z>
    resume(utf);
  80284d:	89 1c 24             	mov    %ebx,(%esp)
  802850:	e8 0b 1e 00 00       	call   804660 <resume>
}
  802855:	83 c4 14             	add    $0x14,%esp
  802858:	5b                   	pop    %ebx
  802859:	5d                   	pop    %ebp
  80285a:	c3                   	ret    

0080285b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	83 ec 28             	sub    $0x28,%esp
  802861:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802864:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80286a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80286d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802870:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802873:	e8 ef fc ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  802878:	85 c0                	test   %eax,%eax
  80287a:	78 26                	js     8028a2 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80287c:	83 c3 10             	add    $0x10,%ebx
  80287f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802883:	89 34 24             	mov    %esi,(%esp)
  802886:	e8 2f e5 ff ff       	call   800dba <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80288b:	89 f2                	mov    %esi,%edx
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	e8 9e fb ff ff       	call   802433 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	e8 c8 fe ff ff       	call   802765 <_ZL11inode_closeP5Inode>
	return 0;
  80289d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8028a5:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8028a8:	89 ec                	mov    %ebp,%esp
  8028aa:	5d                   	pop    %ebp
  8028ab:	c3                   	ret    

008028ac <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	53                   	push   %ebx
  8028b0:	83 ec 24             	sub    $0x24,%esp
  8028b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8028b6:	89 1c 24             	mov    %ebx,(%esp)
  8028b9:	e8 9e 15 00 00       	call   803e5c <_Z7pagerefPv>
  8028be:	89 c2                	mov    %eax,%edx
        return 0;
  8028c0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8028c5:	83 fa 01             	cmp    $0x1,%edx
  8028c8:	7f 1e                	jg     8028e8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8028ca:	8b 43 0c             	mov    0xc(%ebx),%eax
  8028cd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8028d0:	e8 92 fc ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	78 0f                	js     8028e8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  8028e3:	e8 7d fe ff ff       	call   802765 <_ZL11inode_closeP5Inode>
}
  8028e8:	83 c4 24             	add    $0x24,%esp
  8028eb:	5b                   	pop    %ebx
  8028ec:	5d                   	pop    %ebp
  8028ed:	c3                   	ret    

008028ee <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028ee:	55                   	push   %ebp
  8028ef:	89 e5                	mov    %esp,%ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	53                   	push   %ebx
  8028f4:	83 ec 3c             	sub    $0x3c,%esp
  8028f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8028fa:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  8028fd:	8b 43 04             	mov    0x4(%ebx),%eax
  802900:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802903:	8b 43 0c             	mov    0xc(%ebx),%eax
  802906:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802909:	e8 59 fc ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  80290e:	85 c0                	test   %eax,%eax
  802910:	0f 88 8c 00 00 00    	js     8029a2 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802916:	8b 53 04             	mov    0x4(%ebx),%edx
  802919:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  80291f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802925:	29 d7                	sub    %edx,%edi
  802927:	39 f7                	cmp    %esi,%edi
  802929:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  80292c:	85 ff                	test   %edi,%edi
  80292e:	74 16                	je     802946 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802930:	8d 14 17             	lea    (%edi,%edx,1),%edx
  802933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802936:	3b 50 08             	cmp    0x8(%eax),%edx
  802939:	76 6f                	jbe    8029aa <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80293b:	e8 a0 fc ff ff       	call   8025e0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802940:	85 c0                	test   %eax,%eax
  802942:	79 66                	jns    8029aa <_ZL13devfile_writeP2FdPKvj+0xbc>
  802944:	eb 4e                	jmp    802994 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802946:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80294c:	76 24                	jbe    802972 <_ZL13devfile_writeP2FdPKvj+0x84>
  80294e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802950:	8b 53 04             	mov    0x4(%ebx),%edx
  802953:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295c:	3b 50 08             	cmp    0x8(%eax),%edx
  80295f:	0f 86 83 00 00 00    	jbe    8029e8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802965:	e8 76 fc ff ff       	call   8025e0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80296a:	85 c0                	test   %eax,%eax
  80296c:	79 7a                	jns    8029e8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80296e:	66 90                	xchg   %ax,%ax
  802970:	eb 22                	jmp    802994 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802972:	85 f6                	test   %esi,%esi
  802974:	74 1e                	je     802994 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802976:	89 f2                	mov    %esi,%edx
  802978:	03 53 04             	add    0x4(%ebx),%edx
  80297b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297e:	3b 50 08             	cmp    0x8(%eax),%edx
  802981:	0f 86 b8 00 00 00    	jbe    802a3f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802987:	e8 54 fc ff ff       	call   8025e0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80298c:	85 c0                	test   %eax,%eax
  80298e:	0f 89 ab 00 00 00    	jns    802a3f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802994:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802997:	e8 c9 fd ff ff       	call   802765 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80299c:	8b 43 04             	mov    0x4(%ebx),%eax
  80299f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  8029a2:	83 c4 3c             	add    $0x3c,%esp
  8029a5:	5b                   	pop    %ebx
  8029a6:	5e                   	pop    %esi
  8029a7:	5f                   	pop    %edi
  8029a8:	5d                   	pop    %ebp
  8029a9:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  8029aa:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8029ac:	8b 53 04             	mov    0x4(%ebx),%edx
  8029af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b2:	e8 39 fa ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
  8029b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  8029ba:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029c8:	89 04 24             	mov    %eax,(%esp)
  8029cb:	e8 07 e6 ff ff       	call   800fd7 <memcpy>
        fd->fd_offset += n2;
  8029d0:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  8029d3:	ba 04 00 00 00       	mov    $0x4,%edx
  8029d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029db:	e8 cb fa ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  8029e0:	01 7d 0c             	add    %edi,0xc(%ebp)
  8029e3:	e9 5e ff ff ff       	jmp    802946 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8029e8:	8b 53 04             	mov    0x4(%ebx),%edx
  8029eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ee:	e8 fd f9 ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
  8029f3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  8029f5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8029fc:	00 
  8029fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a04:	89 34 24             	mov    %esi,(%esp)
  802a07:	e8 cb e5 ff ff       	call   800fd7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  802a0c:	ba 04 00 00 00       	mov    $0x4,%edx
  802a11:	89 f0                	mov    %esi,%eax
  802a13:	e8 93 fa ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  802a18:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  802a1e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802a25:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802a2c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802a32:	0f 87 18 ff ff ff    	ja     802950 <_ZL13devfile_writeP2FdPKvj+0x62>
  802a38:	89 fe                	mov    %edi,%esi
  802a3a:	e9 33 ff ff ff       	jmp    802972 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  802a3f:	8b 53 04             	mov    0x4(%ebx),%edx
  802a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a45:	e8 a6 f9 ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
  802a4a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  802a4c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802a50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a57:	89 3c 24             	mov    %edi,(%esp)
  802a5a:	e8 78 e5 ff ff       	call   800fd7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  802a5f:	ba 04 00 00 00       	mov    $0x4,%edx
  802a64:	89 f8                	mov    %edi,%eax
  802a66:	e8 40 fa ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  802a6b:	01 73 04             	add    %esi,0x4(%ebx)
  802a6e:	e9 21 ff ff ff       	jmp    802994 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802a73 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
  802a76:	57                   	push   %edi
  802a77:	56                   	push   %esi
  802a78:	53                   	push   %ebx
  802a79:	83 ec 3c             	sub    $0x3c,%esp
  802a7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802a7f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802a82:	8b 43 04             	mov    0x4(%ebx),%eax
  802a85:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802a88:	8b 43 0c             	mov    0xc(%ebx),%eax
  802a8b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802a8e:	e8 d4 fa ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  802a93:	85 c0                	test   %eax,%eax
  802a95:	0f 88 d3 00 00 00    	js     802b6e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  802a9b:	8b 73 04             	mov    0x4(%ebx),%esi
  802a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa1:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802aa4:	8b 50 08             	mov    0x8(%eax),%edx
  802aa7:	29 f2                	sub    %esi,%edx
  802aa9:	3b 48 08             	cmp    0x8(%eax),%ecx
  802aac:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  802aaf:	89 f2                	mov    %esi,%edx
  802ab1:	e8 3a f9 ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	0f 84 a2 00 00 00    	je     802b60 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  802abe:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  802ac4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802aca:	29 f2                	sub    %esi,%edx
  802acc:	39 d7                	cmp    %edx,%edi
  802ace:	0f 46 d7             	cmovbe %edi,%edx
  802ad1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  802ad4:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  802ad6:	01 d6                	add    %edx,%esi
  802ad8:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  802adb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae6:	89 04 24             	mov    %eax,(%esp)
  802ae9:	e8 e9 e4 ff ff       	call   800fd7 <memcpy>
    buf = (void *)((char *)buf + n2);
  802aee:	8b 75 0c             	mov    0xc(%ebp),%esi
  802af1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  802af4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802afa:	76 3e                	jbe    802b3a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  802afc:	8b 53 04             	mov    0x4(%ebx),%edx
  802aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b02:	e8 e9 f8 ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 55                	je     802b60 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  802b0b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802b12:	00 
  802b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b17:	89 34 24             	mov    %esi,(%esp)
  802b1a:	e8 b8 e4 ff ff       	call   800fd7 <memcpy>
        n -= PGSIZE;
  802b1f:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802b25:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  802b2b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802b32:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802b38:	77 c2                	ja     802afc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802b3a:	85 ff                	test   %edi,%edi
  802b3c:	74 22                	je     802b60 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  802b3e:	8b 53 04             	mov    0x4(%ebx),%edx
  802b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b44:	e8 a7 f8 ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	74 13                	je     802b60 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  802b4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b51:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b55:	89 34 24             	mov    %esi,(%esp)
  802b58:	e8 7a e4 ff ff       	call   800fd7 <memcpy>
        fd->fd_offset += n;
  802b5d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802b60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b63:	e8 fd fb ff ff       	call   802765 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802b68:	8b 43 04             	mov    0x4(%ebx),%eax
  802b6b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  802b6e:	83 c4 3c             	add    $0x3c,%esp
  802b71:	5b                   	pop    %ebx
  802b72:	5e                   	pop    %esi
  802b73:	5f                   	pop    %edi
  802b74:	5d                   	pop    %ebp
  802b75:	c3                   	ret    

00802b76 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802b76:	55                   	push   %ebp
  802b77:	89 e5                	mov    %esp,%ebp
  802b79:	57                   	push   %edi
  802b7a:	56                   	push   %esi
  802b7b:	53                   	push   %ebx
  802b7c:	83 ec 4c             	sub    $0x4c,%esp
  802b7f:	89 c6                	mov    %eax,%esi
  802b81:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802b84:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802b87:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  802b8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802b96:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802b99:	b8 01 00 00 00       	mov    $0x1,%eax
  802b9e:	e8 c4 f9 ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  802ba3:	89 c7                	mov    %eax,%edi
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	0f 88 cd 01 00 00    	js     802d7a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802bad:	89 f3                	mov    %esi,%ebx
  802baf:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802bb2:	75 08                	jne    802bbc <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802bb4:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802bb7:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  802bba:	74 f8                	je     802bb4 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  802bbc:	0f b6 03             	movzbl (%ebx),%eax
  802bbf:	3c 2f                	cmp    $0x2f,%al
  802bc1:	74 16                	je     802bd9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802bc3:	84 c0                	test   %al,%al
  802bc5:	74 12                	je     802bd9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  802bc7:	89 da                	mov    %ebx,%edx
		++path;
  802bc9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  802bcc:	0f b6 02             	movzbl (%edx),%eax
  802bcf:	3c 2f                	cmp    $0x2f,%al
  802bd1:	74 08                	je     802bdb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802bd3:	84 c0                	test   %al,%al
  802bd5:	75 f2                	jne    802bc9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  802bd7:	eb 02                	jmp    802bdb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  802bd9:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  802bdb:	89 d0                	mov    %edx,%eax
  802bdd:	29 d8                	sub    %ebx,%eax
  802bdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  802be2:	0f b6 02             	movzbl (%edx),%eax
  802be5:	89 d6                	mov    %edx,%esi
  802be7:	3c 2f                	cmp    $0x2f,%al
  802be9:	75 0a                	jne    802bf5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  802beb:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  802bee:	0f b6 06             	movzbl (%esi),%eax
  802bf1:	3c 2f                	cmp    $0x2f,%al
  802bf3:	74 f6                	je     802beb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  802bf5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802bf9:	75 1b                	jne    802c16 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  802bfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfe:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802c01:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  802c03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c06:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  802c0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802c11:	e9 64 01 00 00       	jmp    802d7a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802c16:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  802c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c1e:	74 06                	je     802c26 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802c20:	84 c0                	test   %al,%al
  802c22:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802c26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c29:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  802c2c:	83 3a 02             	cmpl   $0x2,(%edx)
  802c2f:	0f 85 f4 00 00 00    	jne    802d29 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802c35:	89 d0                	mov    %edx,%eax
  802c37:	8b 52 08             	mov    0x8(%edx),%edx
  802c3a:	85 d2                	test   %edx,%edx
  802c3c:	7e 78                	jle    802cb6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  802c3e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802c45:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  802c4d:	89 fb                	mov    %edi,%ebx
  802c4f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802c52:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802c54:	89 da                	mov    %ebx,%edx
  802c56:	89 f0                	mov    %esi,%eax
  802c58:	e8 93 f7 ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
  802c5d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  802c5f:	83 38 00             	cmpl   $0x0,(%eax)
  802c62:	74 26                	je     802c8a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802c64:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c67:	3b 50 04             	cmp    0x4(%eax),%edx
  802c6a:	75 33                	jne    802c9f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  802c6c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c77:	8d 47 08             	lea    0x8(%edi),%eax
  802c7a:	89 04 24             	mov    %eax,(%esp)
  802c7d:	e8 96 e3 ff ff       	call   801018 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802c82:	85 c0                	test   %eax,%eax
  802c84:	0f 84 fa 00 00 00    	je     802d84 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  802c8a:	83 3f 00             	cmpl   $0x0,(%edi)
  802c8d:	75 10                	jne    802c9f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  802c8f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c93:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802c96:	84 c0                	test   %al,%al
  802c98:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  802c9c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802c9f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802ca5:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802ca7:	8b 56 08             	mov    0x8(%esi),%edx
  802caa:	39 d0                	cmp    %edx,%eax
  802cac:	7c a6                	jl     802c54 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  802cae:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802cb1:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802cb4:	eb 07                	jmp    802cbd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802cb6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  802cbd:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802cc1:	74 6d                	je     802d30 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802cc3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cc7:	75 24                	jne    802ced <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802cc9:	83 ea 80             	sub    $0xffffff80,%edx
  802ccc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ccf:	e8 0c f9 ff ff       	call   8025e0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	0f 88 90 00 00 00    	js     802d6c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  802cdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cdf:	8b 50 08             	mov    0x8(%eax),%edx
  802ce2:	83 c2 80             	add    $0xffffff80,%edx
  802ce5:	e8 06 f7 ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
  802cea:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  802ced:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802cf4:	00 
  802cf5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802cfc:	00 
  802cfd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d00:	89 14 24             	mov    %edx,(%esp)
  802d03:	e8 f9 e1 ff ff       	call   800f01 <memset>
	empty->de_namelen = namelen;
  802d08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d0b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d0e:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802d11:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d15:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d19:	83 c0 08             	add    $0x8,%eax
  802d1c:	89 04 24             	mov    %eax,(%esp)
  802d1f:	e8 b3 e2 ff ff       	call   800fd7 <memcpy>
	*de_store = empty;
  802d24:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802d27:	eb 5e                	jmp    802d87 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802d29:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  802d2e:	eb 42                	jmp    802d72 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802d30:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802d35:	eb 3b                	jmp    802d72 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802d37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802d3d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  802d3f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d42:	89 38                	mov    %edi,(%eax)
			return 0;
  802d44:	bf 00 00 00 00       	mov    $0x0,%edi
  802d49:	eb 2f                	jmp    802d7a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  802d4b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802d4e:	8b 07                	mov    (%edi),%eax
  802d50:	e8 12 f8 ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  802d55:	85 c0                	test   %eax,%eax
  802d57:	78 17                	js     802d70 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5c:	e8 04 fa ff ff       	call   802765 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802d67:	e9 41 fe ff ff       	jmp    802bad <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  802d6c:	89 c7                	mov    %eax,%edi
  802d6e:	eb 02                	jmp    802d72 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802d70:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802d72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d75:	e8 eb f9 ff ff       	call   802765 <_ZL11inode_closeP5Inode>
	return r;
}
  802d7a:	89 f8                	mov    %edi,%eax
  802d7c:	83 c4 4c             	add    $0x4c,%esp
  802d7f:	5b                   	pop    %ebx
  802d80:	5e                   	pop    %esi
  802d81:	5f                   	pop    %edi
  802d82:	5d                   	pop    %ebp
  802d83:	c3                   	ret    
  802d84:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802d87:	80 3e 00             	cmpb   $0x0,(%esi)
  802d8a:	75 bf                	jne    802d4b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  802d8c:	eb a9                	jmp    802d37 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

00802d8e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  802d8e:	55                   	push   %ebp
  802d8f:	89 e5                	mov    %esp,%ebp
  802d91:	57                   	push   %edi
  802d92:	56                   	push   %esi
  802d93:	53                   	push   %ebx
  802d94:	83 ec 3c             	sub    $0x3c,%esp
  802d97:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  802d9a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802d9d:	89 04 24             	mov    %eax,(%esp)
  802da0:	e8 62 f0 ff ff       	call   801e07 <_Z14fd_find_unusedPP2Fd>
  802da5:	89 c3                	mov    %eax,%ebx
  802da7:	85 c0                	test   %eax,%eax
  802da9:	0f 88 16 02 00 00    	js     802fc5 <_Z4openPKci+0x237>
  802daf:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802db6:	00 
  802db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dba:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dbe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dc5:	e8 d6 e4 ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  802dca:	89 c3                	mov    %eax,%ebx
  802dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd1:	85 db                	test   %ebx,%ebx
  802dd3:	0f 88 ec 01 00 00    	js     802fc5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802dd9:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  802ddd:	0f 84 ec 01 00 00    	je     802fcf <_Z4openPKci+0x241>
  802de3:	83 c0 01             	add    $0x1,%eax
  802de6:	83 f8 78             	cmp    $0x78,%eax
  802de9:	75 ee                	jne    802dd9 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802deb:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802df0:	e9 b9 01 00 00       	jmp    802fae <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802df5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802df8:	81 e7 00 01 00 00    	and    $0x100,%edi
  802dfe:	89 3c 24             	mov    %edi,(%esp)
  802e01:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802e04:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802e07:	89 f0                	mov    %esi,%eax
  802e09:	e8 68 fd ff ff       	call   802b76 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802e0e:	89 c3                	mov    %eax,%ebx
  802e10:	85 c0                	test   %eax,%eax
  802e12:	0f 85 96 01 00 00    	jne    802fae <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802e18:	85 ff                	test   %edi,%edi
  802e1a:	75 41                	jne    802e5d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  802e1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1f:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802e24:	75 08                	jne    802e2e <_Z4openPKci+0xa0>
            fileino = dirino;
  802e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e29:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802e2c:	eb 14                	jmp    802e42 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  802e2e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	e8 2f f7 ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  802e38:	89 c3                	mov    %eax,%ebx
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	0f 88 5d 01 00 00    	js     802f9f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802e42:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e45:	83 38 02             	cmpl   $0x2,(%eax)
  802e48:	0f 85 d2 00 00 00    	jne    802f20 <_Z4openPKci+0x192>
  802e4e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802e52:	0f 84 c8 00 00 00    	je     802f20 <_Z4openPKci+0x192>
  802e58:	e9 38 01 00 00       	jmp    802f95 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  802e5d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802e64:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  802e6b:	0f 8e a8 00 00 00    	jle    802f19 <_Z4openPKci+0x18b>
  802e71:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802e76:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802e79:	89 f8                	mov    %edi,%eax
  802e7b:	e8 e7 f6 ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  802e80:	89 c3                	mov    %eax,%ebx
  802e82:	85 c0                	test   %eax,%eax
  802e84:	0f 88 15 01 00 00    	js     802f9f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  802e8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e8d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802e91:	75 68                	jne    802efb <_Z4openPKci+0x16d>
  802e93:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  802e9a:	75 5f                	jne    802efb <_Z4openPKci+0x16d>
			*ino_store = ino;
  802e9c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  802e9f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802ea5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ea8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  802eaf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802eb6:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  802ebd:	00 
  802ebe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802ec5:	00 
  802ec6:	83 c0 0c             	add    $0xc,%eax
  802ec9:	89 04 24             	mov    %eax,(%esp)
  802ecc:	e8 30 e0 ff ff       	call   800f01 <memset>
        de->de_inum = fileino->i_inum;
  802ed1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ed4:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  802eda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802edd:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  802edf:	ba 04 00 00 00       	mov    $0x4,%edx
  802ee4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ee7:	e8 bf f5 ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  802eec:	ba 04 00 00 00       	mov    $0x4,%edx
  802ef1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef4:	e8 b2 f5 ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
  802ef9:	eb 25                	jmp    802f20 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  802efb:	e8 65 f8 ff ff       	call   802765 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802f00:	83 c7 01             	add    $0x1,%edi
  802f03:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802f09:	0f 8c 67 ff ff ff    	jl     802e76 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  802f0f:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802f14:	e9 86 00 00 00       	jmp    802f9f <_Z4openPKci+0x211>
  802f19:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802f1e:	eb 7f                	jmp    802f9f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802f20:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802f27:	74 0d                	je     802f36 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802f29:	ba 00 00 00 00       	mov    $0x0,%edx
  802f2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f31:	e8 aa f6 ff ff       	call   8025e0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802f36:	8b 15 04 60 80 00    	mov    0x806004,%edx
  802f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  802f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802f51:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f54:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  802f5a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  802f5d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f61:	83 c0 10             	add    $0x10,%eax
  802f64:	89 04 24             	mov    %eax,(%esp)
  802f67:	e8 4e de ff ff       	call   800dba <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  802f6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f6f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f79:	e8 e7 f7 ff ff       	call   802765 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  802f7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f81:	e8 df f7 ff ff       	call   802765 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f89:	89 04 24             	mov    %eax,(%esp)
  802f8c:	e8 13 ee ff ff       	call   801da4 <_Z6fd2numP2Fd>
  802f91:	89 c3                	mov    %eax,%ebx
  802f93:	eb 30                	jmp    802fc5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802f95:	e8 cb f7 ff ff       	call   802765 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  802f9a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  802f9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa2:	e8 be f7 ff ff       	call   802765 <_ZL11inode_closeP5Inode>
  802fa7:	eb 05                	jmp    802fae <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802fa9:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  802fae:	a1 08 70 80 00       	mov    0x807008,%eax
  802fb3:	8b 40 04             	mov    0x4(%eax),%eax
  802fb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fb9:	89 54 24 04          	mov    %edx,0x4(%esp)
  802fbd:	89 04 24             	mov    %eax,(%esp)
  802fc0:	e8 98 e3 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802fc5:	89 d8                	mov    %ebx,%eax
  802fc7:	83 c4 3c             	add    $0x3c,%esp
  802fca:	5b                   	pop    %ebx
  802fcb:	5e                   	pop    %esi
  802fcc:	5f                   	pop    %edi
  802fcd:	5d                   	pop    %ebp
  802fce:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  802fcf:	83 f8 78             	cmp    $0x78,%eax
  802fd2:	0f 85 1d fe ff ff    	jne    802df5 <_Z4openPKci+0x67>
  802fd8:	eb cf                	jmp    802fa9 <_Z4openPKci+0x21b>

00802fda <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
  802fdd:	53                   	push   %ebx
  802fde:	83 ec 24             	sub    $0x24,%esp
  802fe1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802fe4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	e8 78 f5 ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  802fef:	85 c0                	test   %eax,%eax
  802ff1:	78 27                	js     80301a <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802ff3:	c7 44 24 04 a4 52 80 	movl   $0x8052a4,0x4(%esp)
  802ffa:	00 
  802ffb:	89 1c 24             	mov    %ebx,(%esp)
  802ffe:	e8 b7 dd ff ff       	call   800dba <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  803003:	89 da                	mov    %ebx,%edx
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	e8 26 f4 ff ff       	call   802433 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	e8 50 f7 ff ff       	call   802765 <_ZL11inode_closeP5Inode>
	return 0;
  803015:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80301a:	83 c4 24             	add    $0x24,%esp
  80301d:	5b                   	pop    %ebx
  80301e:	5d                   	pop    %ebp
  80301f:	c3                   	ret    

00803020 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  803020:	55                   	push   %ebp
  803021:	89 e5                	mov    %esp,%ebp
  803023:	53                   	push   %ebx
  803024:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  803027:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80302e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  803031:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	e8 3a fb ff ff       	call   802b76 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  80303c:	89 c3                	mov    %eax,%ebx
  80303e:	85 c0                	test   %eax,%eax
  803040:	78 5f                	js     8030a1 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  803042:	8d 55 f0             	lea    -0x10(%ebp),%edx
  803045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	e8 18 f5 ff ff       	call   802567 <_ZL10inode_openiPP5Inode>
  80304f:	89 c3                	mov    %eax,%ebx
  803051:	85 c0                	test   %eax,%eax
  803053:	78 44                	js     803099 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  803055:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  80305a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305d:	83 38 02             	cmpl   $0x2,(%eax)
  803060:	74 2f                	je     803091 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  803062:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  80306b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  803072:	ba 04 00 00 00       	mov    $0x4,%edx
  803077:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307a:	e8 2c f4 ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  80307f:	ba 04 00 00 00       	mov    $0x4,%edx
  803084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803087:	e8 1f f4 ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
	r = 0;
  80308c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  803091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803094:	e8 cc f6 ff ff       	call   802765 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	e8 c4 f6 ff ff       	call   802765 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  8030a1:	89 d8                	mov    %ebx,%eax
  8030a3:	83 c4 24             	add    $0x24,%esp
  8030a6:	5b                   	pop    %ebx
  8030a7:	5d                   	pop    %ebp
  8030a8:	c3                   	ret    

008030a9 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  8030a9:	55                   	push   %ebp
  8030aa:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  8030ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b1:	5d                   	pop    %ebp
  8030b2:	c3                   	ret    

008030b3 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  8030b3:	55                   	push   %ebp
  8030b4:	89 e5                	mov    %esp,%ebp
  8030b6:	57                   	push   %edi
  8030b7:	56                   	push   %esi
  8030b8:	53                   	push   %ebx
  8030b9:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  8030bf:	c7 04 24 0d 28 80 00 	movl   $0x80280d,(%esp)
  8030c6:	e8 c0 14 00 00       	call   80458b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  8030cb:	a1 00 10 00 50       	mov    0x50001000,%eax
  8030d0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  8030d5:	74 28                	je     8030ff <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  8030d7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  8030de:	4a 
  8030df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030e3:	c7 44 24 08 0c 53 80 	movl   $0x80530c,0x8(%esp)
  8030ea:	00 
  8030eb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  8030f2:	00 
  8030f3:	c7 04 24 86 52 80 00 	movl   $0x805286,(%esp)
  8030fa:	e8 89 d5 ff ff       	call   800688 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  8030ff:	a1 04 10 00 50       	mov    0x50001004,%eax
  803104:	83 f8 03             	cmp    $0x3,%eax
  803107:	7f 1c                	jg     803125 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  803109:	c7 44 24 08 40 53 80 	movl   $0x805340,0x8(%esp)
  803110:	00 
  803111:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  803118:	00 
  803119:	c7 04 24 86 52 80 00 	movl   $0x805286,(%esp)
  803120:	e8 63 d5 ff ff       	call   800688 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  803125:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  80312b:	85 d2                	test   %edx,%edx
  80312d:	7f 1c                	jg     80314b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  80312f:	c7 44 24 08 70 53 80 	movl   $0x805370,0x8(%esp)
  803136:	00 
  803137:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  80313e:	00 
  80313f:	c7 04 24 86 52 80 00 	movl   $0x805286,(%esp)
  803146:	e8 3d d5 ff ff       	call   800688 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  80314b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  803151:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  803157:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  80315d:	85 c9                	test   %ecx,%ecx
  80315f:	0f 48 cb             	cmovs  %ebx,%ecx
  803162:	c1 f9 0c             	sar    $0xc,%ecx
  803165:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  803169:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  80316f:	39 c8                	cmp    %ecx,%eax
  803171:	7c 13                	jl     803186 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  803173:	85 c0                	test   %eax,%eax
  803175:	7f 3d                	jg     8031b4 <_Z4fsckv+0x101>
  803177:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  80317e:	00 00 00 
  803181:	e9 ac 00 00 00       	jmp    803232 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  803186:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  80318c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  803190:	89 44 24 10          	mov    %eax,0x10(%esp)
  803194:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803198:	c7 44 24 08 a0 53 80 	movl   $0x8053a0,0x8(%esp)
  80319f:	00 
  8031a0:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  8031a7:	00 
  8031a8:	c7 04 24 86 52 80 00 	movl   $0x805286,(%esp)
  8031af:	e8 d4 d4 ff ff       	call   800688 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  8031b4:	be 00 20 00 50       	mov    $0x50002000,%esi
  8031b9:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  8031c0:	00 00 00 
  8031c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8031c8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  8031ce:	39 df                	cmp    %ebx,%edi
  8031d0:	7e 27                	jle    8031f9 <_Z4fsckv+0x146>
  8031d2:	0f b6 06             	movzbl (%esi),%eax
  8031d5:	84 c0                	test   %al,%al
  8031d7:	74 4b                	je     803224 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  8031d9:	0f be c0             	movsbl %al,%eax
  8031dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8031e4:	c7 04 24 e4 53 80 00 	movl   $0x8053e4,(%esp)
  8031eb:	e8 b6 d5 ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  8031f0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8031f7:	eb 2b                	jmp    803224 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  8031f9:	0f b6 06             	movzbl (%esi),%eax
  8031fc:	3c 01                	cmp    $0x1,%al
  8031fe:	76 24                	jbe    803224 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  803200:	0f be c0             	movsbl %al,%eax
  803203:	89 44 24 08          	mov    %eax,0x8(%esp)
  803207:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80320b:	c7 04 24 18 54 80 00 	movl   $0x805418,(%esp)
  803212:	e8 8f d5 ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  803217:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  80321e:	80 3e 00             	cmpb   $0x0,(%esi)
  803221:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  803224:	83 c3 01             	add    $0x1,%ebx
  803227:	83 c6 01             	add    $0x1,%esi
  80322a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  803230:	7f 9c                	jg     8031ce <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803232:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803239:	0f 8e e1 02 00 00    	jle    803520 <_Z4fsckv+0x46d>
  80323f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  803246:	00 00 00 
		struct Inode *ino = get_inode(i);
  803249:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80324f:	e8 f9 f1 ff ff       	call   80244d <_ZL9get_inodei>
  803254:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80325a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80325e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  803265:	75 22                	jne    803289 <_Z4fsckv+0x1d6>
  803267:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80326e:	0f 84 a9 06 00 00    	je     80391d <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  803274:	ba 00 00 00 00       	mov    $0x0,%edx
  803279:	e8 2d f2 ff ff       	call   8024ab <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 3a                	je     8032bc <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  803282:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  803289:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80328f:	8b 02                	mov    (%edx),%eax
  803291:	83 f8 01             	cmp    $0x1,%eax
  803294:	74 26                	je     8032bc <_Z4fsckv+0x209>
  803296:	83 f8 02             	cmp    $0x2,%eax
  803299:	74 21                	je     8032bc <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80329b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80329f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8032a5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032a9:	c7 04 24 44 54 80 00 	movl   $0x805444,(%esp)
  8032b0:	e8 f1 d4 ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  8032b5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  8032bc:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8032c3:	75 3f                	jne    803304 <_Z4fsckv+0x251>
  8032c5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8032cb:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8032cf:	75 15                	jne    8032e6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  8032d1:	c7 04 24 68 54 80 00 	movl   $0x805468,(%esp)
  8032d8:	e8 c9 d4 ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  8032dd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8032e4:	eb 1e                	jmp    803304 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  8032e6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8032ec:	83 3a 02             	cmpl   $0x2,(%edx)
  8032ef:	74 13                	je     803304 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8032f1:	c7 04 24 9c 54 80 00 	movl   $0x80549c,(%esp)
  8032f8:	e8 a9 d4 ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  8032fd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  803304:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  803309:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803310:	0f 84 93 00 00 00    	je     8033a9 <_Z4fsckv+0x2f6>
  803316:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  80331c:	8b 41 08             	mov    0x8(%ecx),%eax
  80331f:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  803324:	7e 23                	jle    803349 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  803326:	89 44 24 08          	mov    %eax,0x8(%esp)
  80332a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803330:	89 44 24 04          	mov    %eax,0x4(%esp)
  803334:	c7 04 24 cc 54 80 00 	movl   $0x8054cc,(%esp)
  80333b:	e8 66 d4 ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  803340:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803347:	eb 09                	jmp    803352 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  803349:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803350:	74 4b                	je     80339d <_Z4fsckv+0x2ea>
  803352:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803358:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80335e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  803364:	74 23                	je     803389 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  803366:	89 44 24 08          	mov    %eax,0x8(%esp)
  80336a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803370:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803374:	c7 04 24 f0 54 80 00 	movl   $0x8054f0,(%esp)
  80337b:	e8 26 d4 ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  803380:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803387:	eb 09                	jmp    803392 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  803389:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803390:	74 12                	je     8033a4 <_Z4fsckv+0x2f1>
  803392:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803398:	8b 78 08             	mov    0x8(%eax),%edi
  80339b:	eb 0c                	jmp    8033a9 <_Z4fsckv+0x2f6>
  80339d:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a2:	eb 05                	jmp    8033a9 <_Z4fsckv+0x2f6>
  8033a4:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  8033a9:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  8033ae:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8033b4:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8033b8:	89 d8                	mov    %ebx,%eax
  8033ba:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  8033bd:	39 c7                	cmp    %eax,%edi
  8033bf:	7e 2b                	jle    8033ec <_Z4fsckv+0x339>
  8033c1:	85 f6                	test   %esi,%esi
  8033c3:	75 27                	jne    8033ec <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  8033c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033cd:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8033d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033d7:	c7 04 24 14 55 80 00 	movl   $0x805514,(%esp)
  8033de:	e8 c3 d3 ff ff       	call   8007a6 <_Z7cprintfPKcz>
				++errors;
  8033e3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8033ea:	eb 36                	jmp    803422 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  8033ec:	39 f8                	cmp    %edi,%eax
  8033ee:	7c 32                	jl     803422 <_Z4fsckv+0x36f>
  8033f0:	85 f6                	test   %esi,%esi
  8033f2:	74 2e                	je     803422 <_Z4fsckv+0x36f>
  8033f4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8033fb:	74 25                	je     803422 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8033fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803401:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803405:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80340b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80340f:	c7 04 24 58 55 80 00 	movl   $0x805558,(%esp)
  803416:	e8 8b d3 ff ff       	call   8007a6 <_Z7cprintfPKcz>
				++errors;
  80341b:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  803422:	85 f6                	test   %esi,%esi
  803424:	0f 84 a0 00 00 00    	je     8034ca <_Z4fsckv+0x417>
  80342a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803431:	0f 84 93 00 00 00    	je     8034ca <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  803437:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  80343d:	7e 27                	jle    803466 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  80343f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803443:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803447:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  80344d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803451:	c7 04 24 9c 55 80 00 	movl   $0x80559c,(%esp)
  803458:	e8 49 d3 ff ff       	call   8007a6 <_Z7cprintfPKcz>
					++errors;
  80345d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803464:	eb 64                	jmp    8034ca <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  803466:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80346d:	3c 01                	cmp    $0x1,%al
  80346f:	75 27                	jne    803498 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  803471:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803475:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803479:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  80347f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803483:	c7 04 24 e0 55 80 00 	movl   $0x8055e0,(%esp)
  80348a:	e8 17 d3 ff ff       	call   8007a6 <_Z7cprintfPKcz>
					++errors;
  80348f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803496:	eb 32                	jmp    8034ca <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  803498:	3c ff                	cmp    $0xff,%al
  80349a:	75 27                	jne    8034c3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  80349c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8034a0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034a4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8034aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034ae:	c7 04 24 1c 56 80 00 	movl   $0x80561c,(%esp)
  8034b5:	e8 ec d2 ff ff       	call   8007a6 <_Z7cprintfPKcz>
					++errors;
  8034ba:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8034c1:	eb 07                	jmp    8034ca <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  8034c3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  8034ca:	83 c3 01             	add    $0x1,%ebx
  8034cd:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  8034d3:	0f 85 d5 fe ff ff    	jne    8033ae <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  8034d9:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8034e0:	0f 94 c0             	sete   %al
  8034e3:	0f b6 c0             	movzbl %al,%eax
  8034e6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8034ec:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  8034f2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  8034f9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  803500:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803507:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  80350e:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803514:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  80351a:	0f 8f 29 fd ff ff    	jg     803249 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803520:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803527:	0f 8e 7f 03 00 00    	jle    8038ac <_Z4fsckv+0x7f9>
  80352d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  803532:	89 f0                	mov    %esi,%eax
  803534:	e8 14 ef ff ff       	call   80244d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  803539:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803540:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803547:	c1 e2 08             	shl    $0x8,%edx
  80354a:	09 ca                	or     %ecx,%edx
  80354c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803553:	c1 e1 10             	shl    $0x10,%ecx
  803556:	09 ca                	or     %ecx,%edx
  803558:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  80355f:	83 e1 7f             	and    $0x7f,%ecx
  803562:	c1 e1 18             	shl    $0x18,%ecx
  803565:	09 d1                	or     %edx,%ecx
  803567:	74 0e                	je     803577 <_Z4fsckv+0x4c4>
  803569:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803570:	78 05                	js     803577 <_Z4fsckv+0x4c4>
  803572:	83 38 02             	cmpl   $0x2,(%eax)
  803575:	74 1f                	je     803596 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803577:	83 c6 01             	add    $0x1,%esi
  80357a:	a1 08 10 00 50       	mov    0x50001008,%eax
  80357f:	39 f0                	cmp    %esi,%eax
  803581:	7f af                	jg     803532 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803583:	bb 01 00 00 00       	mov    $0x1,%ebx
  803588:	83 f8 01             	cmp    $0x1,%eax
  80358b:	0f 8f ad 02 00 00    	jg     80383e <_Z4fsckv+0x78b>
  803591:	e9 16 03 00 00       	jmp    8038ac <_Z4fsckv+0x7f9>
  803596:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  803598:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  80359f:	8b 40 08             	mov    0x8(%eax),%eax
  8035a2:	a8 7f                	test   $0x7f,%al
  8035a4:	74 23                	je     8035c9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  8035a6:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  8035ad:	00 
  8035ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8035b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8035b6:	c7 04 24 58 56 80 00 	movl   $0x805658,(%esp)
  8035bd:	e8 e4 d1 ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  8035c2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8035c9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  8035d0:	00 00 00 
  8035d3:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  8035d9:	e9 3d 02 00 00       	jmp    80381b <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  8035de:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8035e4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8035ea:	e8 01 ee ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
  8035ef:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  8035f1:	83 38 00             	cmpl   $0x0,(%eax)
  8035f4:	0f 84 15 02 00 00    	je     80380f <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  8035fa:	8b 40 04             	mov    0x4(%eax),%eax
  8035fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803600:	83 fa 76             	cmp    $0x76,%edx
  803603:	76 27                	jbe    80362c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  803605:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803609:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80360f:	89 44 24 08          	mov    %eax,0x8(%esp)
  803613:	89 74 24 04          	mov    %esi,0x4(%esp)
  803617:	c7 04 24 8c 56 80 00 	movl   $0x80568c,(%esp)
  80361e:	e8 83 d1 ff ff       	call   8007a6 <_Z7cprintfPKcz>
				++errors;
  803623:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80362a:	eb 28                	jmp    803654 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  80362c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  803631:	74 21                	je     803654 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  803633:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803639:	89 54 24 08          	mov    %edx,0x8(%esp)
  80363d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803641:	c7 04 24 b8 56 80 00 	movl   $0x8056b8,(%esp)
  803648:	e8 59 d1 ff ff       	call   8007a6 <_Z7cprintfPKcz>
				++errors;
  80364d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803654:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  80365b:	00 
  80365c:	8d 43 08             	lea    0x8(%ebx),%eax
  80365f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803663:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803669:	89 0c 24             	mov    %ecx,(%esp)
  80366c:	e8 66 d9 ff ff       	call   800fd7 <memcpy>
  803671:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803675:	bf 77 00 00 00       	mov    $0x77,%edi
  80367a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80367e:	85 ff                	test   %edi,%edi
  803680:	b8 00 00 00 00       	mov    $0x0,%eax
  803685:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803688:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80368f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803690:	8b 03                	mov    (%ebx),%eax
  803692:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803698:	7c 3e                	jl     8036d8 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80369a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80369e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8036a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036a8:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8036ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8036b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8036b6:	c7 04 24 ec 56 80 00 	movl   $0x8056ec,(%esp)
  8036bd:	e8 e4 d0 ff ff       	call   8007a6 <_Z7cprintfPKcz>
				++errors;
  8036c2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8036c9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  8036d0:	00 00 00 
  8036d3:	e9 0b 01 00 00       	jmp    8037e3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  8036d8:	e8 70 ed ff ff       	call   80244d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  8036dd:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8036e4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  8036eb:	c1 e2 08             	shl    $0x8,%edx
  8036ee:	09 d1                	or     %edx,%ecx
  8036f0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  8036f7:	c1 e2 10             	shl    $0x10,%edx
  8036fa:	09 d1                	or     %edx,%ecx
  8036fc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  803703:	83 e2 7f             	and    $0x7f,%edx
  803706:	c1 e2 18             	shl    $0x18,%edx
  803709:	09 ca                	or     %ecx,%edx
  80370b:	83 c2 01             	add    $0x1,%edx
  80370e:	89 d1                	mov    %edx,%ecx
  803710:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  803716:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  80371c:	0f b6 d5             	movzbl %ch,%edx
  80371f:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  803725:	89 ca                	mov    %ecx,%edx
  803727:	c1 ea 10             	shr    $0x10,%edx
  80372a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  803730:	c1 e9 18             	shr    $0x18,%ecx
  803733:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  80373a:	83 e2 80             	and    $0xffffff80,%edx
  80373d:	09 ca                	or     %ecx,%edx
  80373f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803745:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803749:	0f 85 7a ff ff ff    	jne    8036c9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  80374f:	8b 03                	mov    (%ebx),%eax
  803751:	89 44 24 10          	mov    %eax,0x10(%esp)
  803755:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80375b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80375f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803765:	89 44 24 08          	mov    %eax,0x8(%esp)
  803769:	89 74 24 04          	mov    %esi,0x4(%esp)
  80376d:	c7 04 24 1c 57 80 00 	movl   $0x80571c,(%esp)
  803774:	e8 2d d0 ff ff       	call   8007a6 <_Z7cprintfPKcz>
					++errors;
  803779:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803780:	e9 44 ff ff ff       	jmp    8036c9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803785:	3b 78 04             	cmp    0x4(%eax),%edi
  803788:	75 52                	jne    8037dc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  80378a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80378e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803794:	89 54 24 04          	mov    %edx,0x4(%esp)
  803798:	83 c0 08             	add    $0x8,%eax
  80379b:	89 04 24             	mov    %eax,(%esp)
  80379e:	e8 75 d8 ff ff       	call   801018 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	75 35                	jne    8037dc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  8037a7:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8037ad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8037b1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  8037b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037bb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8037c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8037c5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8037c9:	c7 04 24 4c 57 80 00 	movl   $0x80574c,(%esp)
  8037d0:	e8 d1 cf ff ff       	call   8007a6 <_Z7cprintfPKcz>
					++errors;
  8037d5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8037dc:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  8037e3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8037e9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  8037ef:	7e 1e                	jle    80380f <_Z4fsckv+0x75c>
  8037f1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  8037f5:	7f 18                	jg     80380f <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  8037f7:	89 ca                	mov    %ecx,%edx
  8037f9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8037ff:	e8 ec eb ff ff       	call   8023f0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  803804:	83 38 00             	cmpl   $0x0,(%eax)
  803807:	0f 85 78 ff ff ff    	jne    803785 <_Z4fsckv+0x6d2>
  80380d:	eb cd                	jmp    8037dc <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80380f:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  803815:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  80381b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803821:	83 ea 80             	sub    $0xffffff80,%edx
  803824:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80382a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803830:	3b 51 08             	cmp    0x8(%ecx),%edx
  803833:	0f 8f e7 fc ff ff    	jg     803520 <_Z4fsckv+0x46d>
  803839:	e9 a0 fd ff ff       	jmp    8035de <_Z4fsckv+0x52b>
  80383e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803844:	89 d8                	mov    %ebx,%eax
  803846:	e8 02 ec ff ff       	call   80244d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  80384b:	8b 50 04             	mov    0x4(%eax),%edx
  80384e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803855:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80385c:	c1 e7 08             	shl    $0x8,%edi
  80385f:	09 f9                	or     %edi,%ecx
  803861:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803868:	c1 e7 10             	shl    $0x10,%edi
  80386b:	09 f9                	or     %edi,%ecx
  80386d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803874:	83 e7 7f             	and    $0x7f,%edi
  803877:	c1 e7 18             	shl    $0x18,%edi
  80387a:	09 f9                	or     %edi,%ecx
  80387c:	39 ca                	cmp    %ecx,%edx
  80387e:	74 1b                	je     80389b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803880:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803884:	89 54 24 08          	mov    %edx,0x8(%esp)
  803888:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80388c:	c7 04 24 7c 57 80 00 	movl   $0x80577c,(%esp)
  803893:	e8 0e cf ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  803898:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80389b:	83 c3 01             	add    $0x1,%ebx
  80389e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  8038a4:	7f 9e                	jg     803844 <_Z4fsckv+0x791>
  8038a6:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8038ac:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  8038b3:	7e 4f                	jle    803904 <_Z4fsckv+0x851>
  8038b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8038ba:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  8038c0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  8038c7:	3c ff                	cmp    $0xff,%al
  8038c9:	75 09                	jne    8038d4 <_Z4fsckv+0x821>
			freemap[i] = 0;
  8038cb:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  8038d2:	eb 1f                	jmp    8038f3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  8038d4:	84 c0                	test   %al,%al
  8038d6:	75 1b                	jne    8038f3 <_Z4fsckv+0x840>
  8038d8:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  8038de:	7c 13                	jl     8038f3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  8038e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8038e4:	c7 04 24 a8 57 80 00 	movl   $0x8057a8,(%esp)
  8038eb:	e8 b6 ce ff ff       	call   8007a6 <_Z7cprintfPKcz>
			++errors;
  8038f0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8038f3:	83 c3 01             	add    $0x1,%ebx
  8038f6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8038fc:	7f c2                	jg     8038c0 <_Z4fsckv+0x80d>
  8038fe:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  803904:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  80390b:	19 c0                	sbb    %eax,%eax
  80390d:	f7 d0                	not    %eax
  80390f:	83 e0 fd             	and    $0xfffffffd,%eax
}
  803912:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  803918:	5b                   	pop    %ebx
  803919:	5e                   	pop    %esi
  80391a:	5f                   	pop    %edi
  80391b:	5d                   	pop    %ebp
  80391c:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  80391d:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803924:	0f 84 92 f9 ff ff    	je     8032bc <_Z4fsckv+0x209>
  80392a:	e9 5a f9 ff ff       	jmp    803289 <_Z4fsckv+0x1d6>
	...

00803930 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803930:	55                   	push   %ebp
  803931:	89 e5                	mov    %esp,%ebp
  803933:	83 ec 18             	sub    $0x18,%esp
  803936:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803939:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80393c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80393f:	8b 45 08             	mov    0x8(%ebp),%eax
  803942:	89 04 24             	mov    %eax,(%esp)
  803945:	e8 a2 e4 ff ff       	call   801dec <_Z7fd2dataP2Fd>
  80394a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80394c:	c7 44 24 04 db 57 80 	movl   $0x8057db,0x4(%esp)
  803953:	00 
  803954:	89 34 24             	mov    %esi,(%esp)
  803957:	e8 5e d4 ff ff       	call   800dba <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80395c:	8b 43 04             	mov    0x4(%ebx),%eax
  80395f:	2b 03                	sub    (%ebx),%eax
  803961:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803964:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80396b:	c7 86 80 00 00 00 20 	movl   $0x806020,0x80(%esi)
  803972:	60 80 00 
	return 0;
}
  803975:	b8 00 00 00 00       	mov    $0x0,%eax
  80397a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80397d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803980:	89 ec                	mov    %ebp,%esp
  803982:	5d                   	pop    %ebp
  803983:	c3                   	ret    

00803984 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803984:	55                   	push   %ebp
  803985:	89 e5                	mov    %esp,%ebp
  803987:	53                   	push   %ebx
  803988:	83 ec 14             	sub    $0x14,%esp
  80398b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80398e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803992:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803999:	e8 bf d9 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80399e:	89 1c 24             	mov    %ebx,(%esp)
  8039a1:	e8 46 e4 ff ff       	call   801dec <_Z7fd2dataP2Fd>
  8039a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039b1:	e8 a7 d9 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
}
  8039b6:	83 c4 14             	add    $0x14,%esp
  8039b9:	5b                   	pop    %ebx
  8039ba:	5d                   	pop    %ebp
  8039bb:	c3                   	ret    

008039bc <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8039bc:	55                   	push   %ebp
  8039bd:	89 e5                	mov    %esp,%ebp
  8039bf:	57                   	push   %edi
  8039c0:	56                   	push   %esi
  8039c1:	53                   	push   %ebx
  8039c2:	83 ec 2c             	sub    $0x2c,%esp
  8039c5:	89 c7                	mov    %eax,%edi
  8039c7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  8039ca:	a1 08 70 80 00       	mov    0x807008,%eax
  8039cf:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  8039d2:	89 3c 24             	mov    %edi,(%esp)
  8039d5:	e8 82 04 00 00       	call   803e5c <_Z7pagerefPv>
  8039da:	89 c3                	mov    %eax,%ebx
  8039dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039df:	89 04 24             	mov    %eax,(%esp)
  8039e2:	e8 75 04 00 00       	call   803e5c <_Z7pagerefPv>
  8039e7:	39 c3                	cmp    %eax,%ebx
  8039e9:	0f 94 c0             	sete   %al
  8039ec:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  8039ef:	8b 15 08 70 80 00    	mov    0x807008,%edx
  8039f5:	8b 52 58             	mov    0x58(%edx),%edx
  8039f8:	39 d6                	cmp    %edx,%esi
  8039fa:	75 08                	jne    803a04 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  8039fc:	83 c4 2c             	add    $0x2c,%esp
  8039ff:	5b                   	pop    %ebx
  803a00:	5e                   	pop    %esi
  803a01:	5f                   	pop    %edi
  803a02:	5d                   	pop    %ebp
  803a03:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  803a04:	85 c0                	test   %eax,%eax
  803a06:	74 c2                	je     8039ca <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  803a08:	c7 04 24 e2 57 80 00 	movl   $0x8057e2,(%esp)
  803a0f:	e8 92 cd ff ff       	call   8007a6 <_Z7cprintfPKcz>
  803a14:	eb b4                	jmp    8039ca <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

00803a16 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a16:	55                   	push   %ebp
  803a17:	89 e5                	mov    %esp,%ebp
  803a19:	57                   	push   %edi
  803a1a:	56                   	push   %esi
  803a1b:	53                   	push   %ebx
  803a1c:	83 ec 1c             	sub    $0x1c,%esp
  803a1f:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803a22:	89 34 24             	mov    %esi,(%esp)
  803a25:	e8 c2 e3 ff ff       	call   801dec <_Z7fd2dataP2Fd>
  803a2a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803a2c:	bf 00 00 00 00       	mov    $0x0,%edi
  803a31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803a35:	75 46                	jne    803a7d <_ZL13devpipe_writeP2FdPKvj+0x67>
  803a37:	eb 52                	jmp    803a8b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803a39:	89 da                	mov    %ebx,%edx
  803a3b:	89 f0                	mov    %esi,%eax
  803a3d:	e8 7a ff ff ff       	call   8039bc <_ZL13_pipeisclosedP2FdP4Pipe>
  803a42:	85 c0                	test   %eax,%eax
  803a44:	75 49                	jne    803a8f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803a46:	e8 21 d8 ff ff       	call   80126c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  803a4b:	8b 43 04             	mov    0x4(%ebx),%eax
  803a4e:	89 c2                	mov    %eax,%edx
  803a50:	2b 13                	sub    (%ebx),%edx
  803a52:	83 fa 20             	cmp    $0x20,%edx
  803a55:	74 e2                	je     803a39 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a57:	89 c2                	mov    %eax,%edx
  803a59:	c1 fa 1f             	sar    $0x1f,%edx
  803a5c:	c1 ea 1b             	shr    $0x1b,%edx
  803a5f:	01 d0                	add    %edx,%eax
  803a61:	83 e0 1f             	and    $0x1f,%eax
  803a64:	29 d0                	sub    %edx,%eax
  803a66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803a69:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  803a6d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803a71:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803a75:	83 c7 01             	add    $0x1,%edi
  803a78:	39 7d 10             	cmp    %edi,0x10(%ebp)
  803a7b:	76 0e                	jbe    803a8b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  803a7d:	8b 43 04             	mov    0x4(%ebx),%eax
  803a80:	89 c2                	mov    %eax,%edx
  803a82:	2b 13                	sub    (%ebx),%edx
  803a84:	83 fa 20             	cmp    $0x20,%edx
  803a87:	74 b0                	je     803a39 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803a89:	eb cc                	jmp    803a57 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  803a8b:	89 f8                	mov    %edi,%eax
  803a8d:	eb 05                	jmp    803a94 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  803a8f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803a94:	83 c4 1c             	add    $0x1c,%esp
  803a97:	5b                   	pop    %ebx
  803a98:	5e                   	pop    %esi
  803a99:	5f                   	pop    %edi
  803a9a:	5d                   	pop    %ebp
  803a9b:	c3                   	ret    

00803a9c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a9c:	55                   	push   %ebp
  803a9d:	89 e5                	mov    %esp,%ebp
  803a9f:	83 ec 28             	sub    $0x28,%esp
  803aa2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803aa5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803aa8:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803aab:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803aae:	89 3c 24             	mov    %edi,(%esp)
  803ab1:	e8 36 e3 ff ff       	call   801dec <_Z7fd2dataP2Fd>
  803ab6:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803ab8:	be 00 00 00 00       	mov    $0x0,%esi
  803abd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803ac1:	75 47                	jne    803b0a <_ZL12devpipe_readP2FdPvj+0x6e>
  803ac3:	eb 52                	jmp    803b17 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  803ac5:	89 f0                	mov    %esi,%eax
  803ac7:	eb 5e                	jmp    803b27 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  803ac9:	89 da                	mov    %ebx,%edx
  803acb:	89 f8                	mov    %edi,%eax
  803acd:	8d 76 00             	lea    0x0(%esi),%esi
  803ad0:	e8 e7 fe ff ff       	call   8039bc <_ZL13_pipeisclosedP2FdP4Pipe>
  803ad5:	85 c0                	test   %eax,%eax
  803ad7:	75 49                	jne    803b22 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  803ad9:	e8 8e d7 ff ff       	call   80126c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803ade:	8b 03                	mov    (%ebx),%eax
  803ae0:	3b 43 04             	cmp    0x4(%ebx),%eax
  803ae3:	74 e4                	je     803ac9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803ae5:	89 c2                	mov    %eax,%edx
  803ae7:	c1 fa 1f             	sar    $0x1f,%edx
  803aea:	c1 ea 1b             	shr    $0x1b,%edx
  803aed:	01 d0                	add    %edx,%eax
  803aef:	83 e0 1f             	and    $0x1f,%eax
  803af2:	29 d0                	sub    %edx,%eax
  803af4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  803afc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  803aff:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803b02:	83 c6 01             	add    $0x1,%esi
  803b05:	39 75 10             	cmp    %esi,0x10(%ebp)
  803b08:	76 0d                	jbe    803b17 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  803b0a:	8b 03                	mov    (%ebx),%eax
  803b0c:	3b 43 04             	cmp    0x4(%ebx),%eax
  803b0f:	75 d4                	jne    803ae5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  803b11:	85 f6                	test   %esi,%esi
  803b13:	75 b0                	jne    803ac5 <_ZL12devpipe_readP2FdPvj+0x29>
  803b15:	eb b2                	jmp    803ac9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  803b17:	89 f0                	mov    %esi,%eax
  803b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803b20:	eb 05                	jmp    803b27 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803b22:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803b27:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803b2a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803b2d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803b30:	89 ec                	mov    %ebp,%esp
  803b32:	5d                   	pop    %ebp
  803b33:	c3                   	ret    

00803b34 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803b34:	55                   	push   %ebp
  803b35:	89 e5                	mov    %esp,%ebp
  803b37:	83 ec 48             	sub    $0x48,%esp
  803b3a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803b3d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803b40:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803b43:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803b46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803b49:	89 04 24             	mov    %eax,(%esp)
  803b4c:	e8 b6 e2 ff ff       	call   801e07 <_Z14fd_find_unusedPP2Fd>
  803b51:	89 c3                	mov    %eax,%ebx
  803b53:	85 c0                	test   %eax,%eax
  803b55:	0f 88 0b 01 00 00    	js     803c66 <_Z4pipePi+0x132>
  803b5b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803b62:	00 
  803b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b71:	e8 2a d7 ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  803b76:	89 c3                	mov    %eax,%ebx
  803b78:	85 c0                	test   %eax,%eax
  803b7a:	0f 89 f5 00 00 00    	jns    803c75 <_Z4pipePi+0x141>
  803b80:	e9 e1 00 00 00       	jmp    803c66 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803b85:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803b8c:	00 
  803b8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b9b:	e8 00 d7 ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  803ba0:	89 c3                	mov    %eax,%ebx
  803ba2:	85 c0                	test   %eax,%eax
  803ba4:	0f 89 e2 00 00 00    	jns    803c8c <_Z4pipePi+0x158>
  803baa:	e9 a4 00 00 00       	jmp    803c53 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803baf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bb2:	89 04 24             	mov    %eax,(%esp)
  803bb5:	e8 32 e2 ff ff       	call   801dec <_Z7fd2dataP2Fd>
  803bba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803bc1:	00 
  803bc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bc6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803bcd:	00 
  803bce:	89 74 24 04          	mov    %esi,0x4(%esp)
  803bd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803bd9:	e8 21 d7 ff ff       	call   8012ff <_Z12sys_page_mapiPviS_i>
  803bde:	89 c3                	mov    %eax,%ebx
  803be0:	85 c0                	test   %eax,%eax
  803be2:	78 4c                	js     803c30 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803be4:	8b 15 20 60 80 00    	mov    0x806020,%edx
  803bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803bf9:	8b 15 20 60 80 00    	mov    0x806020,%edx
  803bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c02:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803c04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c07:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c11:	89 04 24             	mov    %eax,(%esp)
  803c14:	e8 8b e1 ff ff       	call   801da4 <_Z6fd2numP2Fd>
  803c19:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  803c1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c1e:	89 04 24             	mov    %eax,(%esp)
  803c21:	e8 7e e1 ff ff       	call   801da4 <_Z6fd2numP2Fd>
  803c26:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803c29:	bb 00 00 00 00       	mov    $0x0,%ebx
  803c2e:	eb 36                	jmp    803c66 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803c30:	89 74 24 04          	mov    %esi,0x4(%esp)
  803c34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c3b:	e8 1d d7 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803c40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c4e:	e8 0a d7 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c61:	e8 f7 d6 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803c66:	89 d8                	mov    %ebx,%eax
  803c68:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803c6b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803c6e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803c71:	89 ec                	mov    %ebp,%esp
  803c73:	5d                   	pop    %ebp
  803c74:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803c75:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803c78:	89 04 24             	mov    %eax,(%esp)
  803c7b:	e8 87 e1 ff ff       	call   801e07 <_Z14fd_find_unusedPP2Fd>
  803c80:	89 c3                	mov    %eax,%ebx
  803c82:	85 c0                	test   %eax,%eax
  803c84:	0f 89 fb fe ff ff    	jns    803b85 <_Z4pipePi+0x51>
  803c8a:	eb c7                	jmp    803c53 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8f:	89 04 24             	mov    %eax,(%esp)
  803c92:	e8 55 e1 ff ff       	call   801dec <_Z7fd2dataP2Fd>
  803c97:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c99:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803ca0:	00 
  803ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ca5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803cac:	e8 ef d5 ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  803cb1:	89 c3                	mov    %eax,%ebx
  803cb3:	85 c0                	test   %eax,%eax
  803cb5:	0f 89 f4 fe ff ff    	jns    803baf <_Z4pipePi+0x7b>
  803cbb:	eb 83                	jmp    803c40 <_Z4pipePi+0x10c>

00803cbd <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  803cbd:	55                   	push   %ebp
  803cbe:	89 e5                	mov    %esp,%ebp
  803cc0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803cc3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803cca:	00 
  803ccb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd5:	89 04 24             	mov    %eax,(%esp)
  803cd8:	e8 74 e0 ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  803cdd:	85 c0                	test   %eax,%eax
  803cdf:	78 15                	js     803cf6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce4:	89 04 24             	mov    %eax,(%esp)
  803ce7:	e8 00 e1 ff ff       	call   801dec <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  803cec:	89 c2                	mov    %eax,%edx
  803cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf1:	e8 c6 fc ff ff       	call   8039bc <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803cf6:	c9                   	leave  
  803cf7:	c3                   	ret    

00803cf8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803cf8:	55                   	push   %ebp
  803cf9:	89 e5                	mov    %esp,%ebp
  803cfb:	53                   	push   %ebx
  803cfc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  803cff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803d02:	89 04 24             	mov    %eax,(%esp)
  803d05:	e8 fd e0 ff ff       	call   801e07 <_Z14fd_find_unusedPP2Fd>
  803d0a:	89 c3                	mov    %eax,%ebx
  803d0c:	85 c0                	test   %eax,%eax
  803d0e:	0f 88 be 00 00 00    	js     803dd2 <_Z18pipe_ipc_recv_readv+0xda>
  803d14:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803d1b:	00 
  803d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d2a:	e8 71 d5 ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  803d2f:	89 c3                	mov    %eax,%ebx
  803d31:	85 c0                	test   %eax,%eax
  803d33:	0f 89 a1 00 00 00    	jns    803dda <_Z18pipe_ipc_recv_readv+0xe2>
  803d39:	e9 94 00 00 00       	jmp    803dd2 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  803d3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d41:	85 c0                	test   %eax,%eax
  803d43:	75 0e                	jne    803d53 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803d45:	c7 04 24 40 58 80 00 	movl   $0x805840,(%esp)
  803d4c:	e8 55 ca ff ff       	call   8007a6 <_Z7cprintfPKcz>
  803d51:	eb 10                	jmp    803d63 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d57:	c7 04 24 f5 57 80 00 	movl   $0x8057f5,(%esp)
  803d5e:	e8 43 ca ff ff       	call   8007a6 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803d63:	c7 04 24 ff 57 80 00 	movl   $0x8057ff,(%esp)
  803d6a:	e8 37 ca ff ff       	call   8007a6 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  803d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d72:	a8 04                	test   $0x4,%al
  803d74:	74 04                	je     803d7a <_Z18pipe_ipc_recv_readv+0x82>
  803d76:	a8 01                	test   $0x1,%al
  803d78:	75 24                	jne    803d9e <_Z18pipe_ipc_recv_readv+0xa6>
  803d7a:	c7 44 24 0c 12 58 80 	movl   $0x805812,0xc(%esp)
  803d81:	00 
  803d82:	c7 44 24 08 db 51 80 	movl   $0x8051db,0x8(%esp)
  803d89:	00 
  803d8a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803d91:	00 
  803d92:	c7 04 24 2f 58 80 00 	movl   $0x80582f,(%esp)
  803d99:	e8 ea c8 ff ff       	call   800688 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  803d9e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  803da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da7:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803db3:	89 04 24             	mov    %eax,(%esp)
  803db6:	e8 e9 df ff ff       	call   801da4 <_Z6fd2numP2Fd>
  803dbb:	89 c3                	mov    %eax,%ebx
  803dbd:	eb 13                	jmp    803dd2 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  803dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803dcd:	e8 8b d5 ff ff       	call   80135d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803dd2:	89 d8                	mov    %ebx,%eax
  803dd4:	83 c4 24             	add    $0x24,%esp
  803dd7:	5b                   	pop    %ebx
  803dd8:	5d                   	pop    %ebp
  803dd9:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  803dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddd:	89 04 24             	mov    %eax,(%esp)
  803de0:	e8 07 e0 ff ff       	call   801dec <_Z7fd2dataP2Fd>
  803de5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803de8:	89 54 24 08          	mov    %edx,0x8(%esp)
  803dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  803df0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803df3:	89 04 24             	mov    %eax,(%esp)
  803df6:	e8 d5 dd ff ff       	call   801bd0 <_Z8ipc_recvPiPvS_>
  803dfb:	89 c3                	mov    %eax,%ebx
  803dfd:	85 c0                	test   %eax,%eax
  803dff:	0f 89 39 ff ff ff    	jns    803d3e <_Z18pipe_ipc_recv_readv+0x46>
  803e05:	eb b8                	jmp    803dbf <_Z18pipe_ipc_recv_readv+0xc7>

00803e07 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803e07:	55                   	push   %ebp
  803e08:	89 e5                	mov    %esp,%ebp
  803e0a:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  803e0d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803e14:	00 
  803e15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e1f:	89 04 24             	mov    %eax,(%esp)
  803e22:	e8 2a df ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  803e27:	85 c0                	test   %eax,%eax
  803e29:	78 2f                	js     803e5a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  803e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2e:	89 04 24             	mov    %eax,(%esp)
  803e31:	e8 b6 df ff ff       	call   801dec <_Z7fd2dataP2Fd>
  803e36:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803e3d:	00 
  803e3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803e42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803e49:	00 
  803e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4d:	89 04 24             	mov    %eax,(%esp)
  803e50:	e8 0a de ff ff       	call   801c5f <_Z8ipc_sendijPvi>
    return 0;
  803e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e5a:	c9                   	leave  
  803e5b:	c3                   	ret    

00803e5c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e5c:	55                   	push   %ebp
  803e5d:	89 e5                	mov    %esp,%ebp
  803e5f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803e62:	89 d0                	mov    %edx,%eax
  803e64:	c1 e8 16             	shr    $0x16,%eax
  803e67:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  803e6e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803e73:	f6 c1 01             	test   $0x1,%cl
  803e76:	74 1d                	je     803e95 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803e78:	c1 ea 0c             	shr    $0xc,%edx
  803e7b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803e82:	f6 c2 01             	test   $0x1,%dl
  803e85:	74 0e                	je     803e95 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803e87:	c1 ea 0c             	shr    $0xc,%edx
  803e8a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803e91:	ef 
  803e92:	0f b7 c0             	movzwl %ax,%eax
}
  803e95:	5d                   	pop    %ebp
  803e96:	c3                   	ret    
	...

00803ea0 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803ea0:	55                   	push   %ebp
  803ea1:	89 e5                	mov    %esp,%ebp
  803ea3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803ea6:	c7 44 24 04 63 58 80 	movl   $0x805863,0x4(%esp)
  803ead:	00 
  803eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eb1:	89 04 24             	mov    %eax,(%esp)
  803eb4:	e8 01 cf ff ff       	call   800dba <_Z6strcpyPcPKc>
	return 0;
}
  803eb9:	b8 00 00 00 00       	mov    $0x0,%eax
  803ebe:	c9                   	leave  
  803ebf:	c3                   	ret    

00803ec0 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803ec0:	55                   	push   %ebp
  803ec1:	89 e5                	mov    %esp,%ebp
  803ec3:	53                   	push   %ebx
  803ec4:	83 ec 14             	sub    $0x14,%esp
  803ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803eca:	89 1c 24             	mov    %ebx,(%esp)
  803ecd:	e8 8a ff ff ff       	call   803e5c <_Z7pagerefPv>
  803ed2:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803ed4:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803ed9:	83 fa 01             	cmp    $0x1,%edx
  803edc:	75 0b                	jne    803ee9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  803ede:	8b 43 0c             	mov    0xc(%ebx),%eax
  803ee1:	89 04 24             	mov    %eax,(%esp)
  803ee4:	e8 fe 02 00 00       	call   8041e7 <_Z11nsipc_closei>
	else
		return 0;
}
  803ee9:	83 c4 14             	add    $0x14,%esp
  803eec:	5b                   	pop    %ebx
  803eed:	5d                   	pop    %ebp
  803eee:	c3                   	ret    

00803eef <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803eef:	55                   	push   %ebp
  803ef0:	89 e5                	mov    %esp,%ebp
  803ef2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803ef5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803efc:	00 
  803efd:	8b 45 10             	mov    0x10(%ebp),%eax
  803f00:	89 44 24 08          	mov    %eax,0x8(%esp)
  803f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f07:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0e:	8b 40 0c             	mov    0xc(%eax),%eax
  803f11:	89 04 24             	mov    %eax,(%esp)
  803f14:	e8 c9 03 00 00       	call   8042e2 <_Z10nsipc_sendiPKvij>
}
  803f19:	c9                   	leave  
  803f1a:	c3                   	ret    

00803f1b <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803f1b:	55                   	push   %ebp
  803f1c:	89 e5                	mov    %esp,%ebp
  803f1e:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803f21:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803f28:	00 
  803f29:	8b 45 10             	mov    0x10(%ebp),%eax
  803f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f33:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f37:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  803f3d:	89 04 24             	mov    %eax,(%esp)
  803f40:	e8 1d 03 00 00       	call   804262 <_Z10nsipc_recviPvij>
}
  803f45:	c9                   	leave  
  803f46:	c3                   	ret    

00803f47 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803f47:	55                   	push   %ebp
  803f48:	89 e5                	mov    %esp,%ebp
  803f4a:	83 ec 28             	sub    $0x28,%esp
  803f4d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803f50:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803f53:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803f58:	89 04 24             	mov    %eax,(%esp)
  803f5b:	e8 a7 de ff ff       	call   801e07 <_Z14fd_find_unusedPP2Fd>
  803f60:	89 c3                	mov    %eax,%ebx
  803f62:	85 c0                	test   %eax,%eax
  803f64:	78 21                	js     803f87 <_ZL12alloc_sockfdi+0x40>
  803f66:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f6d:	00 
  803f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f71:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f7c:	e8 1f d3 ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  803f81:	89 c3                	mov    %eax,%ebx
  803f83:	85 c0                	test   %eax,%eax
  803f85:	79 14                	jns    803f9b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803f87:	89 34 24             	mov    %esi,(%esp)
  803f8a:	e8 58 02 00 00       	call   8041e7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803f8f:	89 d8                	mov    %ebx,%eax
  803f91:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803f94:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803f97:	89 ec                	mov    %ebp,%esp
  803f99:	5d                   	pop    %ebp
  803f9a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803f9b:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  803fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803fb0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803fb3:	89 04 24             	mov    %eax,(%esp)
  803fb6:	e8 e9 dd ff ff       	call   801da4 <_Z6fd2numP2Fd>
  803fbb:	89 c3                	mov    %eax,%ebx
  803fbd:	eb d0                	jmp    803f8f <_ZL12alloc_sockfdi+0x48>

00803fbf <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803fbf:	55                   	push   %ebp
  803fc0:	89 e5                	mov    %esp,%ebp
  803fc2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803fc5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803fcc:	00 
  803fcd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803fd0:	89 54 24 04          	mov    %edx,0x4(%esp)
  803fd4:	89 04 24             	mov    %eax,(%esp)
  803fd7:	e8 75 dd ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  803fdc:	85 c0                	test   %eax,%eax
  803fde:	78 15                	js     803ff5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803fe0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803fe3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803fe8:	8b 0d 3c 60 80 00    	mov    0x80603c,%ecx
  803fee:	39 0a                	cmp    %ecx,(%edx)
  803ff0:	75 03                	jne    803ff5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803ff2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803ff5:	c9                   	leave  
  803ff6:	c3                   	ret    

00803ff7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803ff7:	55                   	push   %ebp
  803ff8:	89 e5                	mov    %esp,%ebp
  803ffa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  804000:	e8 ba ff ff ff       	call   803fbf <_ZL9fd2sockidi>
  804005:	85 c0                	test   %eax,%eax
  804007:	78 1f                	js     804028 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804009:	8b 55 10             	mov    0x10(%ebp),%edx
  80400c:	89 54 24 08          	mov    %edx,0x8(%esp)
  804010:	8b 55 0c             	mov    0xc(%ebp),%edx
  804013:	89 54 24 04          	mov    %edx,0x4(%esp)
  804017:	89 04 24             	mov    %eax,(%esp)
  80401a:	e8 19 01 00 00       	call   804138 <_Z12nsipc_acceptiP8sockaddrPj>
  80401f:	85 c0                	test   %eax,%eax
  804021:	78 05                	js     804028 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  804023:	e8 1f ff ff ff       	call   803f47 <_ZL12alloc_sockfdi>
}
  804028:	c9                   	leave  
  804029:	c3                   	ret    

0080402a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80402a:	55                   	push   %ebp
  80402b:	89 e5                	mov    %esp,%ebp
  80402d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  804030:	8b 45 08             	mov    0x8(%ebp),%eax
  804033:	e8 87 ff ff ff       	call   803fbf <_ZL9fd2sockidi>
  804038:	85 c0                	test   %eax,%eax
  80403a:	78 16                	js     804052 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  80403c:	8b 55 10             	mov    0x10(%ebp),%edx
  80403f:	89 54 24 08          	mov    %edx,0x8(%esp)
  804043:	8b 55 0c             	mov    0xc(%ebp),%edx
  804046:	89 54 24 04          	mov    %edx,0x4(%esp)
  80404a:	89 04 24             	mov    %eax,(%esp)
  80404d:	e8 34 01 00 00       	call   804186 <_Z10nsipc_bindiP8sockaddrj>
}
  804052:	c9                   	leave  
  804053:	c3                   	ret    

00804054 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  804054:	55                   	push   %ebp
  804055:	89 e5                	mov    %esp,%ebp
  804057:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80405a:	8b 45 08             	mov    0x8(%ebp),%eax
  80405d:	e8 5d ff ff ff       	call   803fbf <_ZL9fd2sockidi>
  804062:	85 c0                	test   %eax,%eax
  804064:	78 0f                	js     804075 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  804066:	8b 55 0c             	mov    0xc(%ebp),%edx
  804069:	89 54 24 04          	mov    %edx,0x4(%esp)
  80406d:	89 04 24             	mov    %eax,(%esp)
  804070:	e8 50 01 00 00       	call   8041c5 <_Z14nsipc_shutdownii>
}
  804075:	c9                   	leave  
  804076:	c3                   	ret    

00804077 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804077:	55                   	push   %ebp
  804078:	89 e5                	mov    %esp,%ebp
  80407a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80407d:	8b 45 08             	mov    0x8(%ebp),%eax
  804080:	e8 3a ff ff ff       	call   803fbf <_ZL9fd2sockidi>
  804085:	85 c0                	test   %eax,%eax
  804087:	78 16                	js     80409f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  804089:	8b 55 10             	mov    0x10(%ebp),%edx
  80408c:	89 54 24 08          	mov    %edx,0x8(%esp)
  804090:	8b 55 0c             	mov    0xc(%ebp),%edx
  804093:	89 54 24 04          	mov    %edx,0x4(%esp)
  804097:	89 04 24             	mov    %eax,(%esp)
  80409a:	e8 62 01 00 00       	call   804201 <_Z13nsipc_connectiPK8sockaddrj>
}
  80409f:	c9                   	leave  
  8040a0:	c3                   	ret    

008040a1 <_Z6listenii>:

int
listen(int s, int backlog)
{
  8040a1:	55                   	push   %ebp
  8040a2:	89 e5                	mov    %esp,%ebp
  8040a4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8040a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040aa:	e8 10 ff ff ff       	call   803fbf <_ZL9fd2sockidi>
  8040af:	85 c0                	test   %eax,%eax
  8040b1:	78 0f                	js     8040c2 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8040b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8040b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8040ba:	89 04 24             	mov    %eax,(%esp)
  8040bd:	e8 7e 01 00 00       	call   804240 <_Z12nsipc_listenii>
}
  8040c2:	c9                   	leave  
  8040c3:	c3                   	ret    

008040c4 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8040c4:	55                   	push   %ebp
  8040c5:	89 e5                	mov    %esp,%ebp
  8040c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8040ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8040cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8040d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8040db:	89 04 24             	mov    %eax,(%esp)
  8040de:	e8 72 02 00 00       	call   804355 <_Z12nsipc_socketiii>
  8040e3:	85 c0                	test   %eax,%eax
  8040e5:	78 05                	js     8040ec <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  8040e7:	e8 5b fe ff ff       	call   803f47 <_ZL12alloc_sockfdi>
}
  8040ec:	c9                   	leave  
  8040ed:	8d 76 00             	lea    0x0(%esi),%esi
  8040f0:	c3                   	ret    
  8040f1:	00 00                	add    %al,(%eax)
	...

008040f4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8040f4:	55                   	push   %ebp
  8040f5:	89 e5                	mov    %esp,%ebp
  8040f7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8040fa:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  804101:	00 
  804102:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  804109:	00 
  80410a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80410e:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  804115:	e8 45 db ff ff       	call   801c5f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  80411a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  804121:	00 
  804122:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  804129:	00 
  80412a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804131:	e8 9a da ff ff       	call   801bd0 <_Z8ipc_recvPiPvS_>
}
  804136:	c9                   	leave  
  804137:	c3                   	ret    

00804138 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804138:	55                   	push   %ebp
  804139:	89 e5                	mov    %esp,%ebp
  80413b:	53                   	push   %ebx
  80413c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  80413f:	8b 45 08             	mov    0x8(%ebp),%eax
  804142:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804147:	b8 01 00 00 00       	mov    $0x1,%eax
  80414c:	e8 a3 ff ff ff       	call   8040f4 <_ZL5nsipcj>
  804151:	89 c3                	mov    %eax,%ebx
  804153:	85 c0                	test   %eax,%eax
  804155:	78 27                	js     80417e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  804157:	a1 10 80 80 00       	mov    0x808010,%eax
  80415c:	89 44 24 08          	mov    %eax,0x8(%esp)
  804160:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  804167:	00 
  804168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80416b:	89 04 24             	mov    %eax,(%esp)
  80416e:	e8 e9 cd ff ff       	call   800f5c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  804173:	8b 15 10 80 80 00    	mov    0x808010,%edx
  804179:	8b 45 10             	mov    0x10(%ebp),%eax
  80417c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  80417e:	89 d8                	mov    %ebx,%eax
  804180:	83 c4 14             	add    $0x14,%esp
  804183:	5b                   	pop    %ebx
  804184:	5d                   	pop    %ebp
  804185:	c3                   	ret    

00804186 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804186:	55                   	push   %ebp
  804187:	89 e5                	mov    %esp,%ebp
  804189:	53                   	push   %ebx
  80418a:	83 ec 14             	sub    $0x14,%esp
  80418d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  804190:	8b 45 08             	mov    0x8(%ebp),%eax
  804193:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804198:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80419c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80419f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041a3:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8041aa:	e8 ad cd ff ff       	call   800f5c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8041af:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  8041b5:	b8 02 00 00 00       	mov    $0x2,%eax
  8041ba:	e8 35 ff ff ff       	call   8040f4 <_ZL5nsipcj>
}
  8041bf:	83 c4 14             	add    $0x14,%esp
  8041c2:	5b                   	pop    %ebx
  8041c3:	5d                   	pop    %ebp
  8041c4:	c3                   	ret    

008041c5 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  8041c5:	55                   	push   %ebp
  8041c6:	89 e5                	mov    %esp,%ebp
  8041c8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8041cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ce:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8041d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041d6:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8041db:	b8 03 00 00 00       	mov    $0x3,%eax
  8041e0:	e8 0f ff ff ff       	call   8040f4 <_ZL5nsipcj>
}
  8041e5:	c9                   	leave  
  8041e6:	c3                   	ret    

008041e7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  8041e7:	55                   	push   %ebp
  8041e8:	89 e5                	mov    %esp,%ebp
  8041ea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8041ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f0:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8041f5:	b8 04 00 00 00       	mov    $0x4,%eax
  8041fa:	e8 f5 fe ff ff       	call   8040f4 <_ZL5nsipcj>
}
  8041ff:	c9                   	leave  
  804200:	c3                   	ret    

00804201 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804201:	55                   	push   %ebp
  804202:	89 e5                	mov    %esp,%ebp
  804204:	53                   	push   %ebx
  804205:	83 ec 14             	sub    $0x14,%esp
  804208:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80420b:	8b 45 08             	mov    0x8(%ebp),%eax
  80420e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804213:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80421a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80421e:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  804225:	e8 32 cd ff ff       	call   800f5c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80422a:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  804230:	b8 05 00 00 00       	mov    $0x5,%eax
  804235:	e8 ba fe ff ff       	call   8040f4 <_ZL5nsipcj>
}
  80423a:	83 c4 14             	add    $0x14,%esp
  80423d:	5b                   	pop    %ebx
  80423e:	5d                   	pop    %ebp
  80423f:	c3                   	ret    

00804240 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  804240:	55                   	push   %ebp
  804241:	89 e5                	mov    %esp,%ebp
  804243:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  804246:	8b 45 08             	mov    0x8(%ebp),%eax
  804249:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  80424e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804251:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  804256:	b8 06 00 00 00       	mov    $0x6,%eax
  80425b:	e8 94 fe ff ff       	call   8040f4 <_ZL5nsipcj>
}
  804260:	c9                   	leave  
  804261:	c3                   	ret    

00804262 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804262:	55                   	push   %ebp
  804263:	89 e5                	mov    %esp,%ebp
  804265:	56                   	push   %esi
  804266:	53                   	push   %ebx
  804267:	83 ec 10             	sub    $0x10,%esp
  80426a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80426d:	8b 45 08             	mov    0x8(%ebp),%eax
  804270:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  804275:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80427b:	8b 45 14             	mov    0x14(%ebp),%eax
  80427e:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804283:	b8 07 00 00 00       	mov    $0x7,%eax
  804288:	e8 67 fe ff ff       	call   8040f4 <_ZL5nsipcj>
  80428d:	89 c3                	mov    %eax,%ebx
  80428f:	85 c0                	test   %eax,%eax
  804291:	78 46                	js     8042d9 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  804293:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  804298:	7f 04                	jg     80429e <_Z10nsipc_recviPvij+0x3c>
  80429a:	39 f0                	cmp    %esi,%eax
  80429c:	7e 24                	jle    8042c2 <_Z10nsipc_recviPvij+0x60>
  80429e:	c7 44 24 0c 6f 58 80 	movl   $0x80586f,0xc(%esp)
  8042a5:	00 
  8042a6:	c7 44 24 08 db 51 80 	movl   $0x8051db,0x8(%esp)
  8042ad:	00 
  8042ae:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8042b5:	00 
  8042b6:	c7 04 24 84 58 80 00 	movl   $0x805884,(%esp)
  8042bd:	e8 c6 c3 ff ff       	call   800688 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8042c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8042c6:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8042cd:	00 
  8042ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042d1:	89 04 24             	mov    %eax,(%esp)
  8042d4:	e8 83 cc ff ff       	call   800f5c <memmove>
	}

	return r;
}
  8042d9:	89 d8                	mov    %ebx,%eax
  8042db:	83 c4 10             	add    $0x10,%esp
  8042de:	5b                   	pop    %ebx
  8042df:	5e                   	pop    %esi
  8042e0:	5d                   	pop    %ebp
  8042e1:	c3                   	ret    

008042e2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8042e2:	55                   	push   %ebp
  8042e3:	89 e5                	mov    %esp,%ebp
  8042e5:	53                   	push   %ebx
  8042e6:	83 ec 14             	sub    $0x14,%esp
  8042e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8042ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ef:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8042f4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8042fa:	7e 24                	jle    804320 <_Z10nsipc_sendiPKvij+0x3e>
  8042fc:	c7 44 24 0c 90 58 80 	movl   $0x805890,0xc(%esp)
  804303:	00 
  804304:	c7 44 24 08 db 51 80 	movl   $0x8051db,0x8(%esp)
  80430b:	00 
  80430c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  804313:	00 
  804314:	c7 04 24 84 58 80 00 	movl   $0x805884,(%esp)
  80431b:	e8 68 c3 ff ff       	call   800688 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804320:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804324:	8b 45 0c             	mov    0xc(%ebp),%eax
  804327:	89 44 24 04          	mov    %eax,0x4(%esp)
  80432b:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  804332:	e8 25 cc ff ff       	call   800f5c <memmove>
	nsipcbuf.send.req_size = size;
  804337:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  80433d:	8b 45 14             	mov    0x14(%ebp),%eax
  804340:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  804345:	b8 08 00 00 00       	mov    $0x8,%eax
  80434a:	e8 a5 fd ff ff       	call   8040f4 <_ZL5nsipcj>
}
  80434f:	83 c4 14             	add    $0x14,%esp
  804352:	5b                   	pop    %ebx
  804353:	5d                   	pop    %ebp
  804354:	c3                   	ret    

00804355 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804355:	55                   	push   %ebp
  804356:	89 e5                	mov    %esp,%ebp
  804358:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80435b:	8b 45 08             	mov    0x8(%ebp),%eax
  80435e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  804363:	8b 45 0c             	mov    0xc(%ebp),%eax
  804366:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  80436b:	8b 45 10             	mov    0x10(%ebp),%eax
  80436e:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  804373:	b8 09 00 00 00       	mov    $0x9,%eax
  804378:	e8 77 fd ff ff       	call   8040f4 <_ZL5nsipcj>
}
  80437d:	c9                   	leave  
  80437e:	c3                   	ret    
	...

00804380 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  804380:	55                   	push   %ebp
  804381:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  804383:	b8 00 00 00 00       	mov    $0x0,%eax
  804388:	5d                   	pop    %ebp
  804389:	c3                   	ret    

0080438a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80438a:	55                   	push   %ebp
  80438b:	89 e5                	mov    %esp,%ebp
  80438d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804390:	c7 44 24 04 9c 58 80 	movl   $0x80589c,0x4(%esp)
  804397:	00 
  804398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80439b:	89 04 24             	mov    %eax,(%esp)
  80439e:	e8 17 ca ff ff       	call   800dba <_Z6strcpyPcPKc>
	return 0;
}
  8043a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8043a8:	c9                   	leave  
  8043a9:	c3                   	ret    

008043aa <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8043aa:	55                   	push   %ebp
  8043ab:	89 e5                	mov    %esp,%ebp
  8043ad:	57                   	push   %edi
  8043ae:	56                   	push   %esi
  8043af:	53                   	push   %ebx
  8043b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8043b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8043bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8043bf:	74 3e                	je     8043ff <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8043c1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8043c7:	8b 75 10             	mov    0x10(%ebp),%esi
  8043ca:	29 de                	sub    %ebx,%esi
  8043cc:	83 fe 7f             	cmp    $0x7f,%esi
  8043cf:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8043d4:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8043d7:	89 74 24 08          	mov    %esi,0x8(%esp)
  8043db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043de:	01 d8                	add    %ebx,%eax
  8043e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043e4:	89 3c 24             	mov    %edi,(%esp)
  8043e7:	e8 70 cb ff ff       	call   800f5c <memmove>
		sys_cputs(buf, m);
  8043ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8043f0:	89 3c 24             	mov    %edi,(%esp)
  8043f3:	e8 7c cd ff ff       	call   801174 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8043f8:	01 f3                	add    %esi,%ebx
  8043fa:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  8043fd:	77 c8                	ja     8043c7 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8043ff:	89 d8                	mov    %ebx,%eax
  804401:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  804407:	5b                   	pop    %ebx
  804408:	5e                   	pop    %esi
  804409:	5f                   	pop    %edi
  80440a:	5d                   	pop    %ebp
  80440b:	c3                   	ret    

0080440c <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80440c:	55                   	push   %ebp
  80440d:	89 e5                	mov    %esp,%ebp
  80440f:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  804412:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  804417:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80441b:	75 07                	jne    804424 <_ZL12devcons_readP2FdPvj+0x18>
  80441d:	eb 2a                	jmp    804449 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80441f:	e8 48 ce ff ff       	call   80126c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804424:	e8 7e cd ff ff       	call   8011a7 <_Z9sys_cgetcv>
  804429:	85 c0                	test   %eax,%eax
  80442b:	74 f2                	je     80441f <_ZL12devcons_readP2FdPvj+0x13>
  80442d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80442f:	85 c0                	test   %eax,%eax
  804431:	78 16                	js     804449 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  804433:	83 f8 04             	cmp    $0x4,%eax
  804436:	74 0c                	je     804444 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  804438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80443b:	88 10                	mov    %dl,(%eax)
	return 1;
  80443d:	b8 01 00 00 00       	mov    $0x1,%eax
  804442:	eb 05                	jmp    804449 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  804444:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  804449:	c9                   	leave  
  80444a:	c3                   	ret    

0080444b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80444b:	55                   	push   %ebp
  80444c:	89 e5                	mov    %esp,%ebp
  80444e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  804451:	8b 45 08             	mov    0x8(%ebp),%eax
  804454:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804457:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80445e:	00 
  80445f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804462:	89 04 24             	mov    %eax,(%esp)
  804465:	e8 0a cd ff ff       	call   801174 <_Z9sys_cputsPKcj>
}
  80446a:	c9                   	leave  
  80446b:	c3                   	ret    

0080446c <_Z7getcharv>:

int
getchar(void)
{
  80446c:	55                   	push   %ebp
  80446d:	89 e5                	mov    %esp,%ebp
  80446f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804472:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804479:	00 
  80447a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80447d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804481:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804488:	e8 71 dc ff ff       	call   8020fe <_Z4readiPvj>
	if (r < 0)
  80448d:	85 c0                	test   %eax,%eax
  80448f:	78 0f                	js     8044a0 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  804491:	85 c0                	test   %eax,%eax
  804493:	7e 06                	jle    80449b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  804495:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804499:	eb 05                	jmp    8044a0 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80449b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8044a0:	c9                   	leave  
  8044a1:	c3                   	ret    

008044a2 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  8044a2:	55                   	push   %ebp
  8044a3:	89 e5                	mov    %esp,%ebp
  8044a5:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  8044a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8044af:	00 
  8044b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8044b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ba:	89 04 24             	mov    %eax,(%esp)
  8044bd:	e8 8f d8 ff ff       	call   801d51 <_Z9fd_lookupiPP2Fdb>
  8044c2:	85 c0                	test   %eax,%eax
  8044c4:	78 11                	js     8044d7 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  8044c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044c9:	8b 15 58 60 80 00    	mov    0x806058,%edx
  8044cf:	39 10                	cmp    %edx,(%eax)
  8044d1:	0f 94 c0             	sete   %al
  8044d4:	0f b6 c0             	movzbl %al,%eax
}
  8044d7:	c9                   	leave  
  8044d8:	c3                   	ret    

008044d9 <_Z8openconsv>:

int
opencons(void)
{
  8044d9:	55                   	push   %ebp
  8044da:	89 e5                	mov    %esp,%ebp
  8044dc:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  8044df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8044e2:	89 04 24             	mov    %eax,(%esp)
  8044e5:	e8 1d d9 ff ff       	call   801e07 <_Z14fd_find_unusedPP2Fd>
  8044ea:	85 c0                	test   %eax,%eax
  8044ec:	78 3c                	js     80452a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8044ee:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8044f5:	00 
  8044f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804504:	e8 97 cd ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  804509:	85 c0                	test   %eax,%eax
  80450b:	78 1d                	js     80452a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  80450d:	8b 15 58 60 80 00    	mov    0x806058,%edx
  804513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804516:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  804518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80451b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  804522:	89 04 24             	mov    %eax,(%esp)
  804525:	e8 7a d8 ff ff       	call   801da4 <_Z6fd2numP2Fd>
}
  80452a:	c9                   	leave  
  80452b:	c3                   	ret    
  80452c:	00 00                	add    %al,(%eax)
	...

00804530 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  804530:	55                   	push   %ebp
  804531:	89 e5                	mov    %esp,%ebp
  804533:	56                   	push   %esi
  804534:	53                   	push   %ebx
  804535:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804538:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  80453d:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  804544:	85 c0                	test   %eax,%eax
  804546:	74 08                	je     804550 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  804548:	8d 55 08             	lea    0x8(%ebp),%edx
  80454b:	89 14 24             	mov    %edx,(%esp)
  80454e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804550:	83 eb 01             	sub    $0x1,%ebx
  804553:	83 fb ff             	cmp    $0xffffffff,%ebx
  804556:	75 e5                	jne    80453d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  804558:	8b 5d 38             	mov    0x38(%ebp),%ebx
  80455b:	8b 75 08             	mov    0x8(%ebp),%esi
  80455e:	e8 d5 cc ff ff       	call   801238 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  804563:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  804567:	89 74 24 10          	mov    %esi,0x10(%esp)
  80456b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80456f:	c7 44 24 08 a8 58 80 	movl   $0x8058a8,0x8(%esp)
  804576:	00 
  804577:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80457e:	00 
  80457f:	c7 04 24 2c 59 80 00 	movl   $0x80592c,(%esp)
  804586:	e8 fd c0 ff ff       	call   800688 <_Z6_panicPKciS0_z>

0080458b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  80458b:	55                   	push   %ebp
  80458c:	89 e5                	mov    %esp,%ebp
  80458e:	56                   	push   %esi
  80458f:	53                   	push   %ebx
  804590:	83 ec 10             	sub    $0x10,%esp
  804593:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804596:	e8 9d cc ff ff       	call   801238 <_Z12sys_getenvidv>
  80459b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80459d:	a1 08 70 80 00       	mov    0x807008,%eax
  8045a2:	8b 40 5c             	mov    0x5c(%eax),%eax
  8045a5:	85 c0                	test   %eax,%eax
  8045a7:	75 4c                	jne    8045f5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  8045a9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8045b0:	00 
  8045b1:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  8045b8:	ee 
  8045b9:	89 34 24             	mov    %esi,(%esp)
  8045bc:	e8 df cc ff ff       	call   8012a0 <_Z14sys_page_allociPvi>
  8045c1:	85 c0                	test   %eax,%eax
  8045c3:	74 20                	je     8045e5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  8045c5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8045c9:	c7 44 24 08 e0 58 80 	movl   $0x8058e0,0x8(%esp)
  8045d0:	00 
  8045d1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8045d8:	00 
  8045d9:	c7 04 24 2c 59 80 00 	movl   $0x80592c,(%esp)
  8045e0:	e8 a3 c0 ff ff       	call   800688 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  8045e5:	c7 44 24 04 30 45 80 	movl   $0x804530,0x4(%esp)
  8045ec:	00 
  8045ed:	89 34 24             	mov    %esi,(%esp)
  8045f0:	e8 e0 ce ff ff       	call   8014d5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  8045f5:	a1 00 90 80 00       	mov    0x809000,%eax
  8045fa:	39 d8                	cmp    %ebx,%eax
  8045fc:	74 1a                	je     804618 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  8045fe:	85 c0                	test   %eax,%eax
  804600:	74 20                	je     804622 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804602:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  804607:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  80460e:	39 da                	cmp    %ebx,%edx
  804610:	74 15                	je     804627 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804612:	85 d2                	test   %edx,%edx
  804614:	75 1f                	jne    804635 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  804616:	eb 0f                	jmp    804627 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804618:	b8 00 00 00 00       	mov    $0x0,%eax
  80461d:	8d 76 00             	lea    0x0(%esi),%esi
  804620:	eb 05                	jmp    804627 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804622:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804627:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80462e:	83 c4 10             	add    $0x10,%esp
  804631:	5b                   	pop    %ebx
  804632:	5e                   	pop    %esi
  804633:	5d                   	pop    %ebp
  804634:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804635:	83 c0 01             	add    $0x1,%eax
  804638:	83 f8 08             	cmp    $0x8,%eax
  80463b:	75 ca                	jne    804607 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80463d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804641:	c7 44 24 08 04 59 80 	movl   $0x805904,0x8(%esp)
  804648:	00 
  804649:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804650:	00 
  804651:	c7 04 24 2c 59 80 00 	movl   $0x80592c,(%esp)
  804658:	e8 2b c0 ff ff       	call   800688 <_Z6_panicPKciS0_z>
  80465d:	00 00                	add    %al,(%eax)
	...

00804660 <resume>:
.globl resume
resume:
	// This function is called from C, so uses the C calling convention.
	// The first word on the stack is the return address.
	// We have no plan to return so scrap it.
	addl $4, %esp
  804660:	83 c4 04             	add    $0x4,%esp
	// Next on the stack is the function argument: a pointer to the UTF.
	// This instruction pops that pointer *into the stack pointer*,
	// which you will find useful.
	popl %esp
  804663:	5c                   	pop    %esp
	//
	// Hint: Check out 'popal', 'popf', and 'popl'.

	// LAB 4: Your code here.

    addl $0x8, %esp
  804664:	83 c4 08             	add    $0x8,%esp
    movl 40(%esp), %eax
  804667:	8b 44 24 28          	mov    0x28(%esp),%eax
    movl 36(%esp), %ebx
  80466b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
    subl $4, %ebx
  80466f:	83 eb 04             	sub    $0x4,%ebx
    movl %eax, (%ebx)
  804672:	89 03                	mov    %eax,(%ebx)
    movl %ebx, 36(%esp)
  804674:	89 5c 24 24          	mov    %ebx,0x24(%esp)
    popal
  804678:	61                   	popa   
    popf
  804679:	9d                   	popf   
    popl %esp
  80467a:	5c                   	pop    %esp
    ret
  80467b:	c3                   	ret    

0080467c <spin>:

spin:	jmp spin
  80467c:	eb fe                	jmp    80467c <spin>
	...

00804680 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804680:	55                   	push   %ebp
  804681:	89 e5                	mov    %esp,%ebp
  804683:	57                   	push   %edi
  804684:	56                   	push   %esi
  804685:	53                   	push   %ebx
  804686:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804689:	8b 45 08             	mov    0x8(%ebp),%eax
  80468c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  80468f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  804692:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  804695:	8d 45 ef             	lea    -0x11(%ebp),%eax
  804698:	89 45 e0             	mov    %eax,-0x20(%ebp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80469b:	bb 20 90 80 00       	mov    $0x809020,%ebx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  8046a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8046a3:	0f b6 08             	movzbl (%eax),%ecx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  8046a6:	ba 00 00 00 00       	mov    $0x0,%edx
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  8046ab:	b8 cd ff ff ff       	mov    $0xffffffcd,%eax
  8046b0:	f6 e1                	mul    %cl
  8046b2:	66 c1 e8 08          	shr    $0x8,%ax
  8046b6:	c0 e8 03             	shr    $0x3,%al
  8046b9:	89 c6                	mov    %eax,%esi
  8046bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8046be:	01 c0                	add    %eax,%eax
  8046c0:	28 c1                	sub    %al,%cl
  8046c2:	89 c8                	mov    %ecx,%eax
      *ap /= (u8_t)10;
  8046c4:	89 f1                	mov    %esi,%ecx
      inv[i++] = '0' + rem;
  8046c6:	0f b6 fa             	movzbl %dl,%edi
  8046c9:	83 c0 30             	add    $0x30,%eax
  8046cc:	88 44 3d f1          	mov    %al,-0xf(%ebp,%edi,1)
  8046d0:	83 c2 01             	add    $0x1,%edx

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
  8046d3:	84 c9                	test   %cl,%cl
  8046d5:	75 d4                	jne    8046ab <inet_ntoa+0x2b>
  8046d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8046da:	88 08                	mov    %cl,(%eax)
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8046dc:	84 d2                	test   %dl,%dl
  8046de:	74 24                	je     804704 <inet_ntoa+0x84>
  8046e0:	83 ea 01             	sub    $0x1,%edx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  8046e3:	0f b6 fa             	movzbl %dl,%edi
  8046e6:	8d 74 3b 01          	lea    0x1(%ebx,%edi,1),%esi
  8046ea:	89 d8                	mov    %ebx,%eax
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  8046ec:	0f b6 ca             	movzbl %dl,%ecx
  8046ef:	0f b6 4c 0d f1       	movzbl -0xf(%ebp,%ecx,1),%ecx
  8046f4:	88 08                	mov    %cl,(%eax)
  8046f6:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8046f9:	83 ea 01             	sub    $0x1,%edx
  8046fc:	39 f0                	cmp    %esi,%eax
  8046fe:	75 ec                	jne    8046ec <inet_ntoa+0x6c>
  804700:	8d 5c 3b 01          	lea    0x1(%ebx,%edi,1),%ebx
      *rp++ = inv[i];
    *rp++ = '.';
  804704:	c6 03 2e             	movb   $0x2e,(%ebx)
  804707:	83 c3 01             	add    $0x1,%ebx
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80470a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80470d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  804710:	74 06                	je     804718 <inet_ntoa+0x98>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  804712:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  804716:	eb 88                	jmp    8046a0 <inet_ntoa+0x20>
  }
  *--rp = 0;
  804718:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  return str;
}
  80471c:	b8 20 90 80 00       	mov    $0x809020,%eax
  804721:	83 c4 18             	add    $0x18,%esp
  804724:	5b                   	pop    %ebx
  804725:	5e                   	pop    %esi
  804726:	5f                   	pop    %edi
  804727:	5d                   	pop    %ebp
  804728:	c3                   	ret    

00804729 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  804729:	55                   	push   %ebp
  80472a:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80472c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  804730:	66 c1 c0 08          	rol    $0x8,%ax
}
  804734:	5d                   	pop    %ebp
  804735:	c3                   	ret    

00804736 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  804736:	55                   	push   %ebp
  804737:	89 e5                	mov    %esp,%ebp
  804739:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  80473c:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  804740:	89 04 24             	mov    %eax,(%esp)
  804743:	e8 e1 ff ff ff       	call   804729 <htons>
}
  804748:	c9                   	leave  
  804749:	c3                   	ret    

0080474a <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80474a:	55                   	push   %ebp
  80474b:	89 e5                	mov    %esp,%ebp
  80474d:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  804750:	89 d1                	mov    %edx,%ecx
  804752:	c1 e9 18             	shr    $0x18,%ecx
  804755:	89 d0                	mov    %edx,%eax
  804757:	c1 e0 18             	shl    $0x18,%eax
  80475a:	09 c8                	or     %ecx,%eax
  80475c:	89 d1                	mov    %edx,%ecx
  80475e:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  804764:	c1 e1 08             	shl    $0x8,%ecx
  804767:	09 c8                	or     %ecx,%eax
  804769:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  80476f:	c1 ea 08             	shr    $0x8,%edx
  804772:	09 d0                	or     %edx,%eax
}
  804774:	5d                   	pop    %ebp
  804775:	c3                   	ret    

00804776 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  804776:	55                   	push   %ebp
  804777:	89 e5                	mov    %esp,%ebp
  804779:	57                   	push   %edi
  80477a:	56                   	push   %esi
  80477b:	53                   	push   %ebx
  80477c:	83 ec 28             	sub    $0x28,%esp
  80477f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  804782:	0f be 11             	movsbl (%ecx),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804785:	8d 5a d0             	lea    -0x30(%edx),%ebx
      return (0);
  804788:	b8 00 00 00 00       	mov    $0x0,%eax
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  80478d:	80 fb 09             	cmp    $0x9,%bl
  804790:	0f 87 c4 01 00 00    	ja     80495a <inet_aton+0x1e4>
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  804796:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  804799:	89 45 d8             	mov    %eax,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80479c:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  80479f:	89 5d e0             	mov    %ebx,-0x20(%ebp)
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
  8047a2:	c7 45 dc 0a 00 00 00 	movl   $0xa,-0x24(%ebp)
    if (c == '0') {
  8047a9:	83 fa 30             	cmp    $0x30,%edx
  8047ac:	75 25                	jne    8047d3 <inet_aton+0x5d>
      c = *++cp;
  8047ae:	83 c1 01             	add    $0x1,%ecx
  8047b1:	0f be 11             	movsbl (%ecx),%edx
      if (c == 'x' || c == 'X') {
  8047b4:	83 fa 78             	cmp    $0x78,%edx
  8047b7:	74 0c                	je     8047c5 <inet_aton+0x4f>
        base = 16;
        c = *++cp;
      } else
        base = 8;
  8047b9:	c7 45 dc 08 00 00 00 	movl   $0x8,-0x24(%ebp)
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
  8047c0:	83 fa 58             	cmp    $0x58,%edx
  8047c3:	75 0e                	jne    8047d3 <inet_aton+0x5d>
        base = 16;
        c = *++cp;
  8047c5:	0f be 51 01          	movsbl 0x1(%ecx),%edx
  8047c9:	83 c1 01             	add    $0x1,%ecx
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  8047cc:	c7 45 dc 10 00 00 00 	movl   $0x10,-0x24(%ebp)
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  8047d3:	8d 41 01             	lea    0x1(%ecx),%eax
  8047d6:	be 00 00 00 00       	mov    $0x0,%esi
  8047db:	eb 03                	jmp    8047e0 <inet_aton+0x6a>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  8047dd:	83 c0 01             	add    $0x1,%eax
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
  8047e0:	8d 78 ff             	lea    -0x1(%eax),%edi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  8047e3:	89 d1                	mov    %edx,%ecx
  8047e5:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8047e8:	80 fb 09             	cmp    $0x9,%bl
  8047eb:	77 0d                	ja     8047fa <inet_aton+0x84>
        val = (val * base) + (int)(c - '0');
  8047ed:	0f af 75 dc          	imul   -0x24(%ebp),%esi
  8047f1:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  8047f5:	0f be 10             	movsbl (%eax),%edx
  8047f8:	eb e3                	jmp    8047dd <inet_aton+0x67>
      } else if (base == 16 && isxdigit(c)) {
  8047fa:	83 7d dc 10          	cmpl   $0x10,-0x24(%ebp)
  8047fe:	0f 85 5e 01 00 00    	jne    804962 <inet_aton+0x1ec>
  804804:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  804807:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  80480a:	80 fb 05             	cmp    $0x5,%bl
  80480d:	76 0c                	jbe    80481b <inet_aton+0xa5>
  80480f:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  804812:	80 fb 05             	cmp    $0x5,%bl
  804815:	0f 87 4d 01 00 00    	ja     804968 <inet_aton+0x1f2>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  80481b:	89 f1                	mov    %esi,%ecx
  80481d:	c1 e1 04             	shl    $0x4,%ecx
  804820:	8d 72 0a             	lea    0xa(%edx),%esi
  804823:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  804827:	19 d2                	sbb    %edx,%edx
  804829:	83 e2 20             	and    $0x20,%edx
  80482c:	83 c2 41             	add    $0x41,%edx
  80482f:	29 d6                	sub    %edx,%esi
  804831:	09 ce                	or     %ecx,%esi
        c = *++cp;
  804833:	0f be 10             	movsbl (%eax),%edx
  804836:	eb a5                	jmp    8047dd <inet_aton+0x67>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  804838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80483b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  80483e:	0f 83 0a 01 00 00    	jae    80494e <inet_aton+0x1d8>
        return (0);
      *pp++ = val;
  804844:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804847:	89 1a                	mov    %ebx,(%edx)
      c = *++cp;
  804849:	8d 4f 01             	lea    0x1(%edi),%ecx
  80484c:	0f be 57 01          	movsbl 0x1(%edi),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  804850:	8d 42 d0             	lea    -0x30(%edx),%eax
  804853:	3c 09                	cmp    $0x9,%al
  804855:	0f 87 fa 00 00 00    	ja     804955 <inet_aton+0x1df>
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
  80485b:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  80485f:	e9 3e ff ff ff       	jmp    8047a2 <inet_aton+0x2c>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  804864:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804869:	80 f9 1f             	cmp    $0x1f,%cl
  80486c:	0f 86 e8 00 00 00    	jbe    80495a <inet_aton+0x1e4>
  804872:	84 d2                	test   %dl,%dl
  804874:	0f 88 e0 00 00 00    	js     80495a <inet_aton+0x1e4>
  80487a:	83 fa 20             	cmp    $0x20,%edx
  80487d:	74 1d                	je     80489c <inet_aton+0x126>
  80487f:	83 fa 0c             	cmp    $0xc,%edx
  804882:	74 18                	je     80489c <inet_aton+0x126>
  804884:	83 fa 0a             	cmp    $0xa,%edx
  804887:	74 13                	je     80489c <inet_aton+0x126>
  804889:	83 fa 0d             	cmp    $0xd,%edx
  80488c:	74 0e                	je     80489c <inet_aton+0x126>
  80488e:	83 fa 09             	cmp    $0x9,%edx
  804891:	74 09                	je     80489c <inet_aton+0x126>
  804893:	83 fa 0b             	cmp    $0xb,%edx
  804896:	0f 85 be 00 00 00    	jne    80495a <inet_aton+0x1e4>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80489c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80489f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8048a2:	29 c2                	sub    %eax,%edx
  8048a4:	c1 fa 02             	sar    $0x2,%edx
  8048a7:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  8048aa:	83 fa 02             	cmp    $0x2,%edx
  8048ad:	74 25                	je     8048d4 <inet_aton+0x15e>
  8048af:	83 fa 02             	cmp    $0x2,%edx
  8048b2:	7f 0f                	jg     8048c3 <inet_aton+0x14d>

  case 0:
    return (0);       /* initial nondigit */
  8048b4:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  8048b9:	85 d2                	test   %edx,%edx
  8048bb:	0f 84 99 00 00 00    	je     80495a <inet_aton+0x1e4>
  8048c1:	eb 6c                	jmp    80492f <inet_aton+0x1b9>
  8048c3:	83 fa 03             	cmp    $0x3,%edx
  8048c6:	74 23                	je     8048eb <inet_aton+0x175>
  8048c8:	83 fa 04             	cmp    $0x4,%edx
  8048cb:	90                   	nop
  8048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8048d0:	75 5d                	jne    80492f <inet_aton+0x1b9>
  8048d2:	eb 36                	jmp    80490a <inet_aton+0x194>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  8048d4:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8048d9:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  8048df:	77 79                	ja     80495a <inet_aton+0x1e4>
      return (0);
    val |= parts[0] << 24;
  8048e1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8048e4:	c1 e6 18             	shl    $0x18,%esi
  8048e7:	09 de                	or     %ebx,%esi
    break;
  8048e9:	eb 44                	jmp    80492f <inet_aton+0x1b9>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  8048eb:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8048f0:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  8048f6:	77 62                	ja     80495a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8048f8:	8b 75 e8             	mov    -0x18(%ebp),%esi
  8048fb:	c1 e6 10             	shl    $0x10,%esi
  8048fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804901:	c1 e0 18             	shl    $0x18,%eax
  804904:	09 c6                	or     %eax,%esi
  804906:	09 de                	or     %ebx,%esi
    break;
  804908:	eb 25                	jmp    80492f <inet_aton+0x1b9>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  80490a:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80490f:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  804915:	77 43                	ja     80495a <inet_aton+0x1e4>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804917:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80491a:	c1 e6 10             	shl    $0x10,%esi
  80491d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804920:	c1 e0 18             	shl    $0x18,%eax
  804923:	09 c6                	or     %eax,%esi
  804925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804928:	c1 e0 08             	shl    $0x8,%eax
  80492b:	09 c6                	or     %eax,%esi
  80492d:	09 de                	or     %ebx,%esi
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  80492f:	b8 01 00 00 00       	mov    $0x1,%eax
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  804934:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804938:	74 20                	je     80495a <inet_aton+0x1e4>
    addr->s_addr = htonl(val);
  80493a:	89 34 24             	mov    %esi,(%esp)
  80493d:	e8 08 fe ff ff       	call   80474a <htonl>
  804942:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  804945:	89 03                	mov    %eax,(%ebx)
  return (1);
  804947:	b8 01 00 00 00       	mov    $0x1,%eax
  80494c:	eb 0c                	jmp    80495a <inet_aton+0x1e4>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80494e:	b8 00 00 00 00       	mov    $0x0,%eax
  804953:	eb 05                	jmp    80495a <inet_aton+0x1e4>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  804955:	b8 00 00 00 00       	mov    $0x0,%eax
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
}
  80495a:	83 c4 28             	add    $0x28,%esp
  80495d:	5b                   	pop    %ebx
  80495e:	5e                   	pop    %esi
  80495f:	5f                   	pop    %edi
  804960:	5d                   	pop    %ebp
  804961:	c3                   	ret    
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  804962:	89 d0                	mov    %edx,%eax
  804964:	89 f3                	mov    %esi,%ebx
  804966:	eb 04                	jmp    80496c <inet_aton+0x1f6>
  804968:	89 d0                	mov    %edx,%eax
  80496a:	89 f3                	mov    %esi,%ebx
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
    if (c == '.') {
  80496c:	83 f8 2e             	cmp    $0x2e,%eax
  80496f:	0f 84 c3 fe ff ff    	je     804838 <inet_aton+0xc2>
  804975:	89 f3                	mov    %esi,%ebx
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  804977:	85 d2                	test   %edx,%edx
  804979:	0f 84 1d ff ff ff    	je     80489c <inet_aton+0x126>
  80497f:	e9 e0 fe ff ff       	jmp    804864 <inet_aton+0xee>

00804984 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804984:	55                   	push   %ebp
  804985:	89 e5                	mov    %esp,%ebp
  804987:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80498a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80498d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804991:	8b 45 08             	mov    0x8(%ebp),%eax
  804994:	89 04 24             	mov    %eax,(%esp)
  804997:	e8 da fd ff ff       	call   804776 <inet_aton>
  80499c:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80499e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8049a3:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  8049a7:	c9                   	leave  
  8049a8:	c3                   	ret    

008049a9 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8049a9:	55                   	push   %ebp
  8049aa:	89 e5                	mov    %esp,%ebp
  8049ac:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  8049af:	8b 45 08             	mov    0x8(%ebp),%eax
  8049b2:	89 04 24             	mov    %eax,(%esp)
  8049b5:	e8 90 fd ff ff       	call   80474a <htonl>
}
  8049ba:	c9                   	leave  
  8049bb:	c3                   	ret    
  8049bc:	00 00                	add    %al,(%eax)
	...

008049c0 <__udivdi3>:
  8049c0:	55                   	push   %ebp
  8049c1:	89 e5                	mov    %esp,%ebp
  8049c3:	57                   	push   %edi
  8049c4:	56                   	push   %esi
  8049c5:	83 ec 20             	sub    $0x20,%esp
  8049c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8049cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8049ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8049d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8049d4:	85 c0                	test   %eax,%eax
  8049d6:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8049d9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8049dc:	75 3a                	jne    804a18 <__udivdi3+0x58>
  8049de:	39 f9                	cmp    %edi,%ecx
  8049e0:	77 66                	ja     804a48 <__udivdi3+0x88>
  8049e2:	85 c9                	test   %ecx,%ecx
  8049e4:	75 0b                	jne    8049f1 <__udivdi3+0x31>
  8049e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8049eb:	31 d2                	xor    %edx,%edx
  8049ed:	f7 f1                	div    %ecx
  8049ef:	89 c1                	mov    %eax,%ecx
  8049f1:	89 f8                	mov    %edi,%eax
  8049f3:	31 d2                	xor    %edx,%edx
  8049f5:	f7 f1                	div    %ecx
  8049f7:	89 c7                	mov    %eax,%edi
  8049f9:	89 f0                	mov    %esi,%eax
  8049fb:	f7 f1                	div    %ecx
  8049fd:	89 fa                	mov    %edi,%edx
  8049ff:	89 c6                	mov    %eax,%esi
  804a01:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804a04:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804a0d:	83 c4 20             	add    $0x20,%esp
  804a10:	5e                   	pop    %esi
  804a11:	5f                   	pop    %edi
  804a12:	5d                   	pop    %ebp
  804a13:	c3                   	ret    
  804a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804a18:	31 d2                	xor    %edx,%edx
  804a1a:	31 f6                	xor    %esi,%esi
  804a1c:	39 f8                	cmp    %edi,%eax
  804a1e:	77 e1                	ja     804a01 <__udivdi3+0x41>
  804a20:	0f bd d0             	bsr    %eax,%edx
  804a23:	83 f2 1f             	xor    $0x1f,%edx
  804a26:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804a29:	75 2d                	jne    804a58 <__udivdi3+0x98>
  804a2b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  804a2e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  804a31:	76 06                	jbe    804a39 <__udivdi3+0x79>
  804a33:	39 f8                	cmp    %edi,%eax
  804a35:	89 f2                	mov    %esi,%edx
  804a37:	73 c8                	jae    804a01 <__udivdi3+0x41>
  804a39:	31 d2                	xor    %edx,%edx
  804a3b:	be 01 00 00 00       	mov    $0x1,%esi
  804a40:	eb bf                	jmp    804a01 <__udivdi3+0x41>
  804a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804a48:	89 f0                	mov    %esi,%eax
  804a4a:	89 fa                	mov    %edi,%edx
  804a4c:	f7 f1                	div    %ecx
  804a4e:	31 d2                	xor    %edx,%edx
  804a50:	89 c6                	mov    %eax,%esi
  804a52:	eb ad                	jmp    804a01 <__udivdi3+0x41>
  804a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804a58:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a5c:	89 c2                	mov    %eax,%edx
  804a5e:	b8 20 00 00 00       	mov    $0x20,%eax
  804a63:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804a66:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804a69:	d3 e2                	shl    %cl,%edx
  804a6b:	89 c1                	mov    %eax,%ecx
  804a6d:	d3 ee                	shr    %cl,%esi
  804a6f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a73:	09 d6                	or     %edx,%esi
  804a75:	89 fa                	mov    %edi,%edx
  804a77:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  804a7a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804a7d:	d3 e6                	shl    %cl,%esi
  804a7f:	89 c1                	mov    %eax,%ecx
  804a81:	d3 ea                	shr    %cl,%edx
  804a83:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804a87:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804a8a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804a8d:	d3 e7                	shl    %cl,%edi
  804a8f:	89 c1                	mov    %eax,%ecx
  804a91:	d3 ee                	shr    %cl,%esi
  804a93:	09 fe                	or     %edi,%esi
  804a95:	89 f0                	mov    %esi,%eax
  804a97:	f7 75 e4             	divl   -0x1c(%ebp)
  804a9a:	89 d7                	mov    %edx,%edi
  804a9c:	89 c6                	mov    %eax,%esi
  804a9e:	f7 65 f0             	mull   -0x10(%ebp)
  804aa1:	39 d7                	cmp    %edx,%edi
  804aa3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804aa6:	72 12                	jb     804aba <__udivdi3+0xfa>
  804aa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804aab:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804aaf:	d3 e2                	shl    %cl,%edx
  804ab1:	39 c2                	cmp    %eax,%edx
  804ab3:	73 08                	jae    804abd <__udivdi3+0xfd>
  804ab5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804ab8:	75 03                	jne    804abd <__udivdi3+0xfd>
  804aba:	83 ee 01             	sub    $0x1,%esi
  804abd:	31 d2                	xor    %edx,%edx
  804abf:	e9 3d ff ff ff       	jmp    804a01 <__udivdi3+0x41>
	...

00804ad0 <__umoddi3>:
  804ad0:	55                   	push   %ebp
  804ad1:	89 e5                	mov    %esp,%ebp
  804ad3:	57                   	push   %edi
  804ad4:	56                   	push   %esi
  804ad5:	83 ec 20             	sub    $0x20,%esp
  804ad8:	8b 7d 14             	mov    0x14(%ebp),%edi
  804adb:	8b 45 08             	mov    0x8(%ebp),%eax
  804ade:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804ae1:	8b 75 0c             	mov    0xc(%ebp),%esi
  804ae4:	85 ff                	test   %edi,%edi
  804ae6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804ae9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  804aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804aef:	89 f2                	mov    %esi,%edx
  804af1:	75 15                	jne    804b08 <__umoddi3+0x38>
  804af3:	39 f1                	cmp    %esi,%ecx
  804af5:	76 41                	jbe    804b38 <__umoddi3+0x68>
  804af7:	f7 f1                	div    %ecx
  804af9:	89 d0                	mov    %edx,%eax
  804afb:	31 d2                	xor    %edx,%edx
  804afd:	83 c4 20             	add    $0x20,%esp
  804b00:	5e                   	pop    %esi
  804b01:	5f                   	pop    %edi
  804b02:	5d                   	pop    %ebp
  804b03:	c3                   	ret    
  804b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804b08:	39 f7                	cmp    %esi,%edi
  804b0a:	77 4c                	ja     804b58 <__umoddi3+0x88>
  804b0c:	0f bd c7             	bsr    %edi,%eax
  804b0f:	83 f0 1f             	xor    $0x1f,%eax
  804b12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804b15:	75 51                	jne    804b68 <__umoddi3+0x98>
  804b17:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  804b1a:	0f 87 e8 00 00 00    	ja     804c08 <__umoddi3+0x138>
  804b20:	89 f2                	mov    %esi,%edx
  804b22:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804b25:	29 ce                	sub    %ecx,%esi
  804b27:	19 fa                	sbb    %edi,%edx
  804b29:	89 75 f0             	mov    %esi,-0x10(%ebp)
  804b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b2f:	83 c4 20             	add    $0x20,%esp
  804b32:	5e                   	pop    %esi
  804b33:	5f                   	pop    %edi
  804b34:	5d                   	pop    %ebp
  804b35:	c3                   	ret    
  804b36:	66 90                	xchg   %ax,%ax
  804b38:	85 c9                	test   %ecx,%ecx
  804b3a:	75 0b                	jne    804b47 <__umoddi3+0x77>
  804b3c:	b8 01 00 00 00       	mov    $0x1,%eax
  804b41:	31 d2                	xor    %edx,%edx
  804b43:	f7 f1                	div    %ecx
  804b45:	89 c1                	mov    %eax,%ecx
  804b47:	89 f0                	mov    %esi,%eax
  804b49:	31 d2                	xor    %edx,%edx
  804b4b:	f7 f1                	div    %ecx
  804b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804b50:	eb a5                	jmp    804af7 <__umoddi3+0x27>
  804b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804b58:	89 f2                	mov    %esi,%edx
  804b5a:	83 c4 20             	add    $0x20,%esp
  804b5d:	5e                   	pop    %esi
  804b5e:	5f                   	pop    %edi
  804b5f:	5d                   	pop    %ebp
  804b60:	c3                   	ret    
  804b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804b68:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804b6c:	89 f2                	mov    %esi,%edx
  804b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804b71:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804b78:	29 45 f0             	sub    %eax,-0x10(%ebp)
  804b7b:	d3 e7                	shl    %cl,%edi
  804b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b80:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804b84:	d3 e8                	shr    %cl,%eax
  804b86:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804b8a:	09 f8                	or     %edi,%eax
  804b8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  804b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b92:	d3 e0                	shl    %cl,%eax
  804b94:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b9e:	d3 ea                	shr    %cl,%edx
  804ba0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804ba4:	d3 e6                	shl    %cl,%esi
  804ba6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804baa:	d3 e8                	shr    %cl,%eax
  804bac:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804bb0:	09 f0                	or     %esi,%eax
  804bb2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804bb5:	f7 75 e4             	divl   -0x1c(%ebp)
  804bb8:	d3 e6                	shl    %cl,%esi
  804bba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804bbd:	89 d6                	mov    %edx,%esi
  804bbf:	f7 65 f4             	mull   -0xc(%ebp)
  804bc2:	89 d7                	mov    %edx,%edi
  804bc4:	89 c2                	mov    %eax,%edx
  804bc6:	39 fe                	cmp    %edi,%esi
  804bc8:	89 f9                	mov    %edi,%ecx
  804bca:	72 30                	jb     804bfc <__umoddi3+0x12c>
  804bcc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  804bcf:	72 27                	jb     804bf8 <__umoddi3+0x128>
  804bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bd4:	29 d0                	sub    %edx,%eax
  804bd6:	19 ce                	sbb    %ecx,%esi
  804bd8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804bdc:	89 f2                	mov    %esi,%edx
  804bde:	d3 e8                	shr    %cl,%eax
  804be0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804be4:	d3 e2                	shl    %cl,%edx
  804be6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804bea:	09 d0                	or     %edx,%eax
  804bec:	89 f2                	mov    %esi,%edx
  804bee:	d3 ea                	shr    %cl,%edx
  804bf0:	83 c4 20             	add    $0x20,%esp
  804bf3:	5e                   	pop    %esi
  804bf4:	5f                   	pop    %edi
  804bf5:	5d                   	pop    %ebp
  804bf6:	c3                   	ret    
  804bf7:	90                   	nop
  804bf8:	39 fe                	cmp    %edi,%esi
  804bfa:	75 d5                	jne    804bd1 <__umoddi3+0x101>
  804bfc:	89 f9                	mov    %edi,%ecx
  804bfe:	89 c2                	mov    %eax,%edx
  804c00:	2b 55 f4             	sub    -0xc(%ebp),%edx
  804c03:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  804c06:	eb c9                	jmp    804bd1 <__umoddi3+0x101>
  804c08:	39 f7                	cmp    %esi,%edi
  804c0a:	0f 82 10 ff ff ff    	jb     804b20 <__umoddi3+0x50>
  804c10:	e9 17 ff ff ff       	jmp    804b2c <__umoddi3+0x5c>
