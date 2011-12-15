
obj/fs/bufcache:     file format elf32-i386


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
  80002c:	e8 9f 08 00 00       	call   8008d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <_ZL14ide_wait_readyb>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	89 c1                	mov    %eax,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80003a:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003f:	ec                   	in     (%dx),%al
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800040:	0f b6 d8             	movzbl %al,%ebx
  800043:	89 d8                	mov    %ebx,%eax
  800045:	25 c0 00 00 00       	and    $0xc0,%eax
  80004a:	83 f8 40             	cmp    $0x40,%eax
  80004d:	75 f0                	jne    80003f <_ZL14ide_wait_readyb+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -E_IO;
	return 0;
  80004f:	b0 00                	mov    $0x0,%al
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800051:	84 c9                	test   %cl,%cl
  800053:	74 0d                	je     800062 <_ZL14ide_wait_readyb+0x2e>
  800055:	83 e3 21             	and    $0x21,%ebx
		return -E_IO;
	return 0;
  800058:	83 fb 01             	cmp    $0x1,%ebx
  80005b:	19 c0                	sbb    %eax,%eax
  80005d:	f7 d0                	not    %eax
  80005f:	83 e0 ec             	and    $0xffffffec,%eax
}
  800062:	5b                   	pop    %ebx
  800063:	5d                   	pop    %ebp
  800064:	c3                   	ret    

00800065 <_Z15ide_probe_disk1v>:

bool
ide_probe_disk1(void)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	53                   	push   %ebx
  800069:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80006c:	b8 00 00 00 00       	mov    $0x0,%eax
  800071:	e8 be ff ff ff       	call   800034 <_ZL14ide_wait_readyb>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800076:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800080:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  800081:	bb 00 00 00 00       	mov    $0x0,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800086:	b2 f7                	mov    $0xf7,%dl
  800088:	eb 0b                	jmp    800095 <_Z15ide_probe_disk1v+0x30>
  80008a:	83 c3 01             	add    $0x1,%ebx
  80008d:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  800093:	74 05                	je     80009a <_Z15ide_probe_disk1v+0x35>
  800095:	ec                   	in     (%dx),%al
  800096:	a8 a1                	test   $0xa1,%al
  800098:	75 f0                	jne    80008a <_Z15ide_probe_disk1v+0x25>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80009a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009f:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  8000a4:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a5:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  8000ab:	0f 9e c0             	setle  %al
  8000ae:	0f b6 c0             	movzbl %al,%eax
  8000b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b5:	c7 04 24 c0 46 80 00 	movl   $0x8046c0,(%esp)
  8000bc:	e8 b1 09 00 00       	call   800a72 <_Z7cprintfPKcz>
	return (x < 1000);
  8000c1:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  8000c7:	0f 9e c0             	setle  %al
}
  8000ca:	83 c4 14             	add    $0x14,%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5d                   	pop    %ebp
  8000cf:	c3                   	ret    

008000d0 <_Z12ide_set_diski>:

void
ide_set_disk(int d)
{
  8000d0:	55                   	push   %ebp
  8000d1:	89 e5                	mov    %esp,%ebp
  8000d3:	83 ec 18             	sub    $0x18,%esp
  8000d6:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000d9:	83 f8 01             	cmp    $0x1,%eax
  8000dc:	76 1c                	jbe    8000fa <_Z12ide_set_diski+0x2a>
		panic("bad disk number");
  8000de:	c7 44 24 08 d7 46 80 	movl   $0x8046d7,0x8(%esp)
  8000e5:	00 
  8000e6:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  8000ed:	00 
  8000ee:	c7 04 24 e7 46 80 00 	movl   $0x8046e7,(%esp)
  8000f5:	e8 5a 08 00 00       	call   800954 <_Z6_panicPKciS0_z>
	diskno = d;
  8000fa:	a3 00 60 80 00       	mov    %eax,0x806000
}
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <_Z8ide_readjPvj>:

int
ide_read(uint32_t secno, void *dst_voidp, size_t nsecs)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	57                   	push   %edi
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	83 ec 1c             	sub    $0x1c,%esp
  80010a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010d:	8b 75 10             	mov    0x10(%ebp),%esi
	char *dst = (char *) dst_voidp;
	int r;

	assert(nsecs <= 256);
  800110:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800116:	76 24                	jbe    80013c <_Z8ide_readjPvj+0x3b>
  800118:	c7 44 24 0c f0 46 80 	movl   $0x8046f0,0xc(%esp)
  80011f:	00 
  800120:	c7 44 24 08 fd 46 80 	movl   $0x8046fd,0x8(%esp)
  800127:	00 
  800128:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
  80012f:	00 
  800130:	c7 04 24 e7 46 80 00 	movl   $0x8046e7,(%esp)
  800137:	e8 18 08 00 00       	call   800954 <_Z6_panicPKciS0_z>

	ide_wait_ready(0);
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	e8 ee fe ff ff       	call   800034 <_ZL14ide_wait_readyb>
  800146:	ba f2 01 00 00       	mov    $0x1f2,%edx
  80014b:	89 f0                	mov    %esi,%eax
  80014d:	ee                   	out    %al,(%dx)
  80014e:	b2 f3                	mov    $0xf3,%dl
  800150:	89 d8                	mov    %ebx,%eax
  800152:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800153:	89 d8                	mov    %ebx,%eax
  800155:	c1 e8 08             	shr    $0x8,%eax
  800158:	b2 f4                	mov    $0xf4,%dl
  80015a:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80015b:	89 d8                	mov    %ebx,%eax
  80015d:	c1 e8 10             	shr    $0x10,%eax
  800160:	b2 f5                	mov    $0xf5,%dl
  800162:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800163:	a1 00 60 80 00       	mov    0x806000,%eax
  800168:	83 e0 01             	and    $0x1,%eax
  80016b:	c1 e0 04             	shl    $0x4,%eax
  80016e:	83 c8 e0             	or     $0xffffffe0,%eax
  800171:	c1 eb 18             	shr    $0x18,%ebx
  800174:	83 e3 0f             	and    $0xf,%ebx
  800177:	09 d8                	or     %ebx,%eax
  800179:	b2 f6                	mov    $0xf6,%dl
  80017b:	ee                   	out    %al,(%dx)
  80017c:	b2 f7                	mov    $0xf7,%dl
  80017e:	b8 20 00 00 00       	mov    $0x20,%eax
  800183:	ee                   	out    %al,(%dx)
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800189:	85 f6                	test   %esi,%esi
  80018b:	74 32                	je     8001bf <_Z8ide_readjPvj+0xbe>
}

int
ide_read(uint32_t secno, void *dst_voidp, size_t nsecs)
{
	char *dst = (char *) dst_voidp;
  80018d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800190:	b8 01 00 00 00       	mov    $0x1,%eax
  800195:	e8 9a fe ff ff       	call   800034 <_ZL14ide_wait_readyb>
  80019a:	85 c0                	test   %eax,%eax
  80019c:	78 21                	js     8001bf <_Z8ide_readjPvj+0xbe>
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
  80019e:	89 df                	mov    %ebx,%edi
  8001a0:	b9 80 00 00 00       	mov    $0x80,%ecx
  8001a5:	ba f0 01 00 00       	mov    $0x1f0,%edx
  8001aa:	fc                   	cld    
  8001ab:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001ad:	83 ee 01             	sub    $0x1,%esi
  8001b0:	74 08                	je     8001ba <_Z8ide_readjPvj+0xb9>
  8001b2:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8001b8:	eb d6                	jmp    800190 <_Z8ide_readjPvj+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001bf:	83 c4 1c             	add    $0x1c,%esp
  8001c2:	5b                   	pop    %ebx
  8001c3:	5e                   	pop    %esi
  8001c4:	5f                   	pop    %edi
  8001c5:	5d                   	pop    %ebp
  8001c6:	c3                   	ret    

008001c7 <_Z9ide_writejPKvj>:

int
ide_write(uint32_t secno, const void *src_voidp, size_t nsecs)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	57                   	push   %edi
  8001cb:	56                   	push   %esi
  8001cc:	53                   	push   %ebx
  8001cd:	83 ec 1c             	sub    $0x1c,%esp
  8001d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d3:	8b 7d 10             	mov    0x10(%ebp),%edi
	const char *src = (const char *) src_voidp;
	int r;

	assert(nsecs <= 256);
  8001d6:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001dc:	76 24                	jbe    800202 <_Z9ide_writejPKvj+0x3b>
  8001de:	c7 44 24 0c f0 46 80 	movl   $0x8046f0,0xc(%esp)
  8001e5:	00 
  8001e6:	c7 44 24 08 fd 46 80 	movl   $0x8046fd,0x8(%esp)
  8001ed:	00 
  8001ee:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  8001f5:	00 
  8001f6:	c7 04 24 e7 46 80 00 	movl   $0x8046e7,(%esp)
  8001fd:	e8 52 07 00 00       	call   800954 <_Z6_panicPKciS0_z>

	ide_wait_ready(0);
  800202:	b8 00 00 00 00       	mov    $0x0,%eax
  800207:	e8 28 fe ff ff       	call   800034 <_ZL14ide_wait_readyb>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80020c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800211:	89 f8                	mov    %edi,%eax
  800213:	ee                   	out    %al,(%dx)
  800214:	b2 f3                	mov    $0xf3,%dl
  800216:	89 d8                	mov    %ebx,%eax
  800218:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800219:	89 d8                	mov    %ebx,%eax
  80021b:	c1 e8 08             	shr    $0x8,%eax
  80021e:	b2 f4                	mov    $0xf4,%dl
  800220:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800221:	89 d8                	mov    %ebx,%eax
  800223:	c1 e8 10             	shr    $0x10,%eax
  800226:	b2 f5                	mov    $0xf5,%dl
  800228:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800229:	a1 00 60 80 00       	mov    0x806000,%eax
  80022e:	83 e0 01             	and    $0x1,%eax
  800231:	c1 e0 04             	shl    $0x4,%eax
  800234:	83 c8 e0             	or     $0xffffffe0,%eax
  800237:	c1 eb 18             	shr    $0x18,%ebx
  80023a:	83 e3 0f             	and    $0xf,%ebx
  80023d:	09 d8                	or     %ebx,%eax
  80023f:	b2 f6                	mov    $0xf6,%dl
  800241:	ee                   	out    %al,(%dx)
  800242:	b2 f7                	mov    $0xf7,%dl
  800244:	b8 30 00 00 00       	mov    $0x30,%eax
  800249:	ee                   	out    %al,(%dx)
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80024a:	b8 00 00 00 00       	mov    $0x0,%eax
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80024f:	85 ff                	test   %edi,%edi
  800251:	74 32                	je     800285 <_Z9ide_writejPKvj+0xbe>
}

int
ide_write(uint32_t secno, const void *src_voidp, size_t nsecs)
{
	const char *src = (const char *) src_voidp;
  800253:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800256:	b8 01 00 00 00       	mov    $0x1,%eax
  80025b:	e8 d4 fd ff ff       	call   800034 <_ZL14ide_wait_readyb>
  800260:	85 c0                	test   %eax,%eax
  800262:	78 21                	js     800285 <_Z9ide_writejPKvj+0xbe>
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
			 "=S" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "cc");
  800264:	89 de                	mov    %ebx,%esi
  800266:	b9 80 00 00 00       	mov    $0x80,%ecx
  80026b:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800270:	fc                   	cld    
  800271:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800273:	83 ef 01             	sub    $0x1,%edi
  800276:	74 08                	je     800280 <_Z9ide_writejPKvj+0xb9>
  800278:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80027e:	eb d6                	jmp    800256 <_Z9ide_writejPKvj+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  800280:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800285:	83 c4 1c             	add    $0x1c,%esp
  800288:	5b                   	pop    %ebx
  800289:	5e                   	pop    %esi
  80028a:	5f                   	pop    %edi
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    
  80028d:	00 00                	add    %al,(%eax)
	...

00800290 <_ZL14get_block_infoiPP9BlockInfoi>:
//   (blocknum out of range), -E_IO (I/O error), -E_NOT_FOUND (blocknum has
//   no BlockInfo yet and 'create' is 0).
//
static int
get_block_info(blocknum_t blocknum, struct BlockInfo **result, int create)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 28             	sub    $0x28,%esp
  800296:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800299:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80029c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80029f:	89 d3                	mov    %edx,%ebx
	struct BlockInfo *bip;
	int r;

	*result = 0;
  8002a1:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;
  8002a7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
{
	struct BlockInfo *bip;
	int r;

	*result = 0;
	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
  8002ac:	3d ff ff 07 00       	cmp    $0x7ffff,%eax
  8002b1:	0f 8f 82 00 00 00    	jg     800339 <_ZL14get_block_infoiPP9BlockInfoi+0xa9>
		return -E_INVAL;

	bip = &((struct BlockInfo *) BLOCKINFOMAP)[blocknum];
  8002b7:	89 c6                	mov    %eax,%esi
  8002b9:	c1 e6 06             	shl    $0x6,%esi
  8002bc:	81 c6 00 00 00 30    	add    $0x30000000,%esi

	// ensure that page exists
	if (!(vpd[PDX(bip)] & PTE_P) || !(vpt[PGNUM(bip)] & PTE_P)) {
  8002c2:	89 f0                	mov    %esi,%eax
  8002c4:	c1 e8 16             	shr    $0x16,%eax
  8002c7:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8002ce:	a8 01                	test   $0x1,%al
  8002d0:	74 10                	je     8002e2 <_ZL14get_block_infoiPP9BlockInfoi+0x52>
  8002d2:	89 f0                	mov    %esi,%eax
  8002d4:	c1 e8 0c             	shr    $0xc,%eax
  8002d7:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8002de:	a8 01                	test   $0x1,%al
  8002e0:	75 50                	jne    800332 <_ZL14get_block_infoiPP9BlockInfoi+0xa2>
		struct BlockInfo *page_bip, *end_page_bip;

		if (!create)
			return -E_NOT_FOUND;
  8002e2:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx

	// ensure that page exists
	if (!(vpd[PDX(bip)] & PTE_P) || !(vpt[PGNUM(bip)] & PTE_P)) {
		struct BlockInfo *page_bip, *end_page_bip;

		if (!create)
  8002e7:	85 c9                	test   %ecx,%ecx
  8002e9:	74 4e                	je     800339 <_ZL14get_block_infoiPP9BlockInfoi+0xa9>
			return -E_NOT_FOUND;

		page_bip = (struct BlockInfo *) ROUNDDOWN(bip, PGSIZE);
  8002eb:	89 f7                	mov    %esi,%edi
  8002ed:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
		if ((r = sys_page_alloc(0, page_bip, PTE_P | PTE_U | PTE_W)) < 0)
  8002f3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8002fa:	00 
  8002fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800306:	e8 65 12 00 00       	call   801570 <_Z14sys_page_allociPvi>
  80030b:	89 c2                	mov    %eax,%edx
  80030d:	85 c0                	test   %eax,%eax
  80030f:	78 28                	js     800339 <_ZL14get_block_infoiPP9BlockInfoi+0xa9>
			return r;

		// initialize contents
		end_page_bip = (struct BlockInfo *) ROUNDUP(page_bip + 1, PGSIZE);
  800311:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
		while (page_bip < end_page_bip) {
  800317:	39 c7                	cmp    %eax,%edi
  800319:	73 17                	jae    800332 <_ZL14get_block_infoiPP9BlockInfoi+0xa2>
			page_bip->bi_head = 0;
  80031b:	c6 47 28 00          	movb   $0x0,0x28(%edi)
			page_bip->bi_nlocked = 0;
  80031f:	c6 47 29 00          	movb   $0x0,0x29(%edi)
			page_bip->bi_count = 0;
  800323:	c6 47 2a 00          	movb   $0x0,0x2a(%edi)
			page_bip->bi_initialized = 0;
  800327:	c6 47 2b 00          	movb   $0x0,0x2b(%edi)
			++page_bip;
  80032b:	83 c7 40             	add    $0x40,%edi
		if ((r = sys_page_alloc(0, page_bip, PTE_P | PTE_U | PTE_W)) < 0)
			return r;

		// initialize contents
		end_page_bip = (struct BlockInfo *) ROUNDUP(page_bip + 1, PGSIZE);
		while (page_bip < end_page_bip) {
  80032e:	39 f8                	cmp    %edi,%eax
  800330:	77 e9                	ja     80031b <_ZL14get_block_infoiPP9BlockInfoi+0x8b>
			page_bip->bi_initialized = 0;
			++page_bip;
		}
	}

	*result = bip;
  800332:	89 33                	mov    %esi,(%ebx)
	return 0;
  800334:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800339:	89 d0                	mov    %edx,%eax
  80033b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80033e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800341:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800344:	89 ec                	mov    %ebp,%esp
  800346:	5d                   	pop    %ebp
  800347:	c3                   	ret    

00800348 <_ZL11flush_blocki>:
// Returns 0 on success, < 0 on failure.  Error codes include -E_INVAL
//   (blocknum out of range), -E_FAULT (block not in memory), -E_IO.
//
static int
flush_block(blocknum_t blocknum)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	53                   	push   %ebx
  80034c:	83 ec 14             	sub    $0x14,%esp
  80034f:	89 c2                	mov    %eax,%edx
	uintptr_t va = DISKMAP + blocknum * BLKSIZE;
	BlockInfo *bip;
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;
  800351:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
{
	uintptr_t va = DISKMAP + blocknum * BLKSIZE;
	BlockInfo *bip;
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
  800356:	81 fa ff ff 07 00    	cmp    $0x7ffff,%edx
  80035c:	7f 4c                	jg     8003aa <_ZL11flush_blocki+0x62>
//   (blocknum out of range), -E_FAULT (block not in memory), -E_IO.
//
static int
flush_block(blocknum_t blocknum)
{
	uintptr_t va = DISKMAP + blocknum * BLKSIZE;
  80035e:	8d 8a 00 00 05 00    	lea    0x50000(%edx),%ecx
  800364:	c1 e1 0c             	shl    $0xc,%ecx
	BlockInfo *bip;
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[PGNUM(va)] & PTE_P))
  800367:	89 c8                	mov    %ecx,%eax
  800369:	c1 e8 16             	shr    $0x16,%eax
  80036c:	8b 1c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ebx
		return -E_FAULT;
  800373:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
	BlockInfo *bip;
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[PGNUM(va)] & PTE_P))
  800378:	f6 c3 01             	test   $0x1,%bl
  80037b:	74 2d                	je     8003aa <_ZL11flush_blocki+0x62>
  80037d:	89 c8                	mov    %ecx,%eax
  80037f:	c1 e8 0c             	shr    $0xc,%eax
  800382:	8b 1c 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%ebx
		return -E_FAULT;
  800389:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
	BlockInfo *bip;
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[PGNUM(va)] & PTE_P))
  80038e:	f6 c3 01             	test   $0x1,%bl
  800391:	74 17                	je     8003aa <_ZL11flush_blocki+0x62>
		return -E_FAULT;

	return ide_write(blocknum * BLKSECTS, (void *) va, BLKSECTS);
  800393:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  80039a:	00 
  80039b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80039f:	c1 e2 03             	shl    $0x3,%edx
  8003a2:	89 14 24             	mov    %edx,(%esp)
  8003a5:	e8 1d fe ff ff       	call   8001c7 <_Z9ide_writejPKvj>
}
  8003aa:	83 c4 14             	add    $0x14,%esp
  8003ad:	5b                   	pop    %ebx
  8003ae:	5d                   	pop    %ebp
  8003af:	c3                   	ret    

008003b0 <_ZL10send_blockiii>:
// Send DISKMAP block 'blocknum' to environment 'envid'.
// The block is sent with permissions PTE_P|PTE_U|PTE_W|PTE_SHARE.
//
static void
send_block(envid_t envid, blocknum_t blocknum, int success_value)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	83 ec 38             	sub    $0x38,%esp
  8003b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8003bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c2:	89 d3                	mov    %edx,%ebx
  8003c4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
get_block(blocknum_t blocknum)
{
	uintptr_t va = DISKMAP + blocknum * BLKSIZE;
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
  8003c7:	81 fa ff ff 07 00    	cmp    $0x7ffff,%edx
  8003cd:	7f 6e                	jg     80043d <_ZL10send_blockiii+0x8d>
// Error codes include -E_INVAL (blocknum out of range), -E_NO_MEM.
//
static int
get_block(blocknum_t blocknum)
{
	uintptr_t va = DISKMAP + blocknum * BLKSIZE;
  8003cf:	8d ba 00 00 05 00    	lea    0x50000(%edx),%edi
  8003d5:	c1 e7 0c             	shl    $0xc,%edi
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;

	if ((vpd[PDX(va)] & PTE_P) && (vpt[PGNUM(va)] & PTE_P))
  8003d8:	89 f8                	mov    %edi,%eax
  8003da:	c1 e8 16             	shr    $0x16,%eax
  8003dd:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  8003e4:	a8 01                	test   $0x1,%al
  8003e6:	74 7b                	je     800463 <_ZL10send_blockiii+0xb3>
  8003e8:	89 f8                	mov    %edi,%eax
  8003ea:	c1 e8 0c             	shr    $0xc,%eax
  8003ed:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  8003f4:	a8 01                	test   $0x1,%al
  8003f6:	0f 85 8b 00 00 00    	jne    800487 <_ZL10send_blockiii+0xd7>
  8003fc:	eb 65                	jmp    800463 <_ZL10send_blockiii+0xb3>
		return 0;	// already mapped

	if ((r = sys_page_alloc(0, (void *) va, PTE_P | PTE_U | PTE_W)) < 0)
		return r;
	if ((r = ide_read(blocknum * BLKSECTS, (void *) va, BLKSECTS)) < 0) {
  8003fe:	c1 e3 03             	shl    $0x3,%ebx
  800401:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800408:	00 
  800409:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80040d:	89 1c 24             	mov    %ebx,(%esp)
  800410:	e8 ec fc ff ff       	call   800101 <_Z8ide_readjPvj>
  800415:	89 c6                	mov    %eax,%esi
  800417:	85 c0                	test   %eax,%eax
  800419:	79 6c                	jns    800487 <_ZL10send_blockiii+0xd7>
		cprintf("ide_read of %d fails\n", blocknum * BLKSECTS);
  80041b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80041f:	c7 04 24 12 47 80 00 	movl   $0x804712,(%esp)
  800426:	e8 47 06 00 00       	call   800a72 <_Z7cprintfPKcz>
		sys_page_unmap(0, (void *) va);
  80042b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800436:	e8 f2 11 00 00       	call   80162d <_Z14sys_page_unmapiPv>
  80043b:	eb 05                	jmp    800442 <_ZL10send_blockiii+0x92>
{
	uintptr_t va = DISKMAP + blocknum * BLKSIZE;
	int r;

	if (blocknum >= (blocknum_t) (DISKSIZE / BLKSIZE))
		return -E_INVAL;
  80043d:	be fd ff ff ff       	mov    $0xfffffffd,%esi
static void
send_block(envid_t envid, blocknum_t blocknum, int success_value)
{
	int r;
	if ((r = get_block(blocknum)) < 0)
		ipc_send(envid, r, 0, 0);
  800442:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800449:	00 
  80044a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800451:	00 
  800452:	89 74 24 04          	mov    %esi,0x4(%esp)
  800456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800459:	89 04 24             	mov    %eax,(%esp)
  80045c:	e8 de 15 00 00       	call   801a3f <_Z8ipc_sendijPvi>
  800461:	eb 42                	jmp    8004a5 <_ZL10send_blockiii+0xf5>
		return -E_INVAL;

	if ((vpd[PDX(va)] & PTE_P) && (vpt[PGNUM(va)] & PTE_P))
		return 0;	// already mapped

	if ((r = sys_page_alloc(0, (void *) va, PTE_P | PTE_U | PTE_W)) < 0)
  800463:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80046a:	00 
  80046b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800476:	e8 f5 10 00 00       	call   801570 <_Z14sys_page_allociPvi>
  80047b:	89 c6                	mov    %eax,%esi
  80047d:	85 c0                	test   %eax,%eax
  80047f:	0f 89 79 ff ff ff    	jns    8003fe <_ZL10send_blockiii+0x4e>
  800485:	eb bb                	jmp    800442 <_ZL10send_blockiii+0x92>
{
	int r;
	if ((r = get_block(blocknum)) < 0)
		ipc_send(envid, r, 0, 0);
	else
		ipc_send(envid, success_value, (void *) (DISKMAP + blocknum * BLKSIZE), PTE_P | PTE_W | PTE_U | PTE_SHARE);
  800487:	c7 44 24 0c 07 04 00 	movl   $0x407,0xc(%esp)
  80048e:	00 
  80048f:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049d:	89 04 24             	mov    %eax,(%esp)
  8004a0:	e8 9a 15 00 00       	call   801a3f <_Z8ipc_sendijPvi>
}
  8004a5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004a8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004ab:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004ae:	89 ec                	mov    %ebp,%esp
  8004b0:	5d                   	pop    %ebp
  8004b1:	c3                   	ret    

008004b2 <_Z5umainiPPc>:
	return 0;
}

void
umain(int argc, char **argv)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	57                   	push   %edi
  8004b6:	56                   	push   %esi
  8004b7:	53                   	push   %ebx
  8004b8:	83 ec 4c             	sub    $0x4c,%esp
	static_assert(sizeof(struct BlockInfo) == 64);
	static_assert(BLOCKINFOMAP + (DISKSIZE / BLKSIZE) * sizeof(struct BlockInfo) <= DISKMAP);
	assert(thisenv->env_id == ENVID_BUFCACHE);
  8004bb:	a1 00 70 80 00       	mov    0x807000,%eax
  8004c0:	8b 40 04             	mov    0x4(%eax),%eax
  8004c3:	3d 00 11 00 00       	cmp    $0x1100,%eax
  8004c8:	74 24                	je     8004ee <_Z5umainiPPc+0x3c>
  8004ca:	c7 44 24 0c 6c 47 80 	movl   $0x80476c,0xc(%esp)
  8004d1:	00 
  8004d2:	c7 44 24 08 fd 46 80 	movl   $0x8046fd,0x8(%esp)
  8004d9:	00 
  8004da:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  8004e1:	00 
  8004e2:	c7 04 24 28 47 80 00 	movl   $0x804728,(%esp)
  8004e9:	e8 66 04 00 00       	call   800954 <_Z6_panicPKciS0_z>

	binaryname = "bufcache";
  8004ee:	c7 05 04 60 80 00 36 	movl   $0x804736,0x806004
  8004f5:	47 80 00 
	cprintf("bufcache is running\n");
  8004f8:	c7 04 24 3f 47 80 00 	movl   $0x80473f,(%esp)
  8004ff:	e8 6e 05 00 00       	call   800a72 <_Z7cprintfPKcz>

	// If it looks like I/O will definitely fail, then yield first to
	// other runnable, non-idle environments.
	// (This helps previous grading scripts: environment IDs are as
	// expected, but tests still complete quickly.)
	while (!(thisenv->env_tf.tf_eflags & FL_IOPL_MASK)
  800504:	8b 15 00 70 80 00    	mov    0x807000,%edx
  80050a:	8b 42 4c             	mov    0x4c(%edx),%eax
  80050d:	f6 c4 30             	test   $0x30,%ah
  800510:	75 2f                	jne    800541 <_Z5umainiPPc+0x8f>
  800512:	b8 01 00 00 00       	mov    $0x1,%eax
static bool
another_runnable_environment_exists(void)
{
	int e;
	for (e = 1; e < NENV; ++e)
		if (&envs[e] != thisenv && envs[e].env_status == ENV_RUNNABLE)
  800517:	6b c8 78             	imul   $0x78,%eax,%ecx
  80051a:	81 c1 00 00 00 ef    	add    $0xef000000,%ecx
  800520:	39 ca                	cmp    %ecx,%edx
  800522:	0f 84 82 03 00 00    	je     8008aa <_Z5umainiPPc+0x3f8>
  800528:	6b c8 78             	imul   $0x78,%eax,%ecx
  80052b:	8b 89 0c 00 00 ef    	mov    -0x10fffff4(%ecx),%ecx
  800531:	83 f9 01             	cmp    $0x1,%ecx
  800534:	0f 85 70 03 00 00    	jne    8008aa <_Z5umainiPPc+0x3f8>
	// other runnable, non-idle environments.
	// (This helps previous grading scripts: environment IDs are as
	// expected, but tests still complete quickly.)
	while (!(thisenv->env_tf.tf_eflags & FL_IOPL_MASK)
	       && another_runnable_environment_exists())
		sys_yield();
  80053a:	e8 fd 0f 00 00       	call   80153c <_Z9sys_yieldv>
  80053f:	eb c3                	jmp    800504 <_Z5umainiPPc+0x52>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  800541:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  800546:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  80054b:	66 ef                	out    %ax,(%dx)

	outw(0x8A00, 0x8A00);
	cprintf("bufcache can do I/O\n");
  80054d:	c7 04 24 54 47 80 00 	movl   $0x804754,(%esp)
  800554:	e8 19 05 00 00       	call   800a72 <_Z7cprintfPKcz>

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  800559:	e8 07 fb ff ff       	call   800065 <_Z15ide_probe_disk1v>
  80055e:	84 c0                	test   %al,%al
  800560:	74 0e                	je     800570 <_Z5umainiPPc+0xbe>
		ide_set_disk(1);
  800562:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800569:	e8 62 fb ff ff       	call   8000d0 <_Z12ide_set_diski>
  80056e:	eb 0c                	jmp    80057c <_Z5umainiPPc+0xca>
	else
		ide_set_disk(0);
  800570:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800577:	e8 54 fb ff ff       	call   8000d0 <_Z12ide_set_diski>
	// Process incoming requests
	while (1) {
		int32_t breq;
		envid_t envid;

		breq = ipc_recv(&envid, 0, 0);
  80057c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800583:	00 
  800584:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80058b:	00 
  80058c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80058f:	89 04 24             	mov    %eax,(%esp)
  800592:	e8 19 14 00 00       	call   8019b0 <_Z8ipc_recvPiPvS_>
		handle_breq(envid, breq);
  800597:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80059a:	89 55 d0             	mov    %edx,-0x30(%ebp)
{
	struct BlockInfo *bip;
	int r;

	// Extract block number and request type from request.
	blocknum_t blocknum = BCREQ_BLOCKNUM(breq);
  80059d:	89 c3                	mov    %eax,%ebx
  80059f:	c1 eb 04             	shr    $0x4,%ebx
	int reqtype = BCREQ_TYPE(breq);
  8005a2:	89 c6                	mov    %eax,%esi
  8005a4:	83 e6 0f             	and    $0xf,%esi
	// Check request type.
	if (reqtype < BCREQ_MAP || reqtype > BCREQ_INITIALIZE) {
  8005a7:	83 fe 06             	cmp    $0x6,%esi
  8005aa:	76 22                	jbe    8005ce <_Z5umainiPPc+0x11c>
		ipc_send(envid, -E_NOT_SUPP, 0, 0);
  8005ac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005b3:	00 
  8005b4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8005bb:	00 
  8005bc:	c7 44 24 04 f1 ff ff 	movl   $0xfffffff1,0x4(%esp)
  8005c3:	ff 
  8005c4:	89 14 24             	mov    %edx,(%esp)
  8005c7:	e8 73 14 00 00       	call   801a3f <_Z8ipc_sendijPvi>
  8005cc:	eb ae                	jmp    80057c <_Z5umainiPPc+0xca>
		return;
	}

	// Handle simple requests.
	if (reqtype == BCREQ_FLUSH) {
  8005ce:	83 fe 04             	cmp    $0x4,%esi
  8005d1:	75 28                	jne    8005fb <_Z5umainiPPc+0x149>
		ipc_send(envid, flush_block(blocknum), 0, 0);
  8005d3:	89 d8                	mov    %ebx,%eax
  8005d5:	e8 6e fd ff ff       	call   800348 <_ZL11flush_blocki>
  8005da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005e1:	00 
  8005e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8005e9:	00 
  8005ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ee:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005f1:	89 0c 24             	mov    %ecx,(%esp)
  8005f4:	e8 46 14 00 00       	call   801a3f <_Z8ipc_sendijPvi>
  8005f9:	eb 81                	jmp    80057c <_Z5umainiPPc+0xca>
		return;
	} else if (reqtype == BCREQ_MAP) {
  8005fb:	85 f6                	test   %esi,%esi
  8005fd:	75 2e                	jne    80062d <_Z5umainiPPc+0x17b>
		r = get_block_info(blocknum, &bip, 0);
  8005ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800604:	8d 55 e0             	lea    -0x20(%ebp),%edx
  800607:	89 d8                	mov    %ebx,%eax
  800609:	e8 82 fc ff ff       	call   800290 <_ZL14get_block_infoiPP9BlockInfoi>
		send_block(envid, blocknum, r >= 0 ? bip->bi_initialized : 0);
  80060e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800613:	85 c0                	test   %eax,%eax
  800615:	78 07                	js     80061e <_Z5umainiPPc+0x16c>
  800617:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061a:	0f b6 48 2b          	movzbl 0x2b(%eax),%ecx
  80061e:	89 da                	mov    %ebx,%edx
  800620:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800623:	e8 88 fd ff ff       	call   8003b0 <_ZL10send_blockiii>
  800628:	e9 4f ff ff ff       	jmp    80057c <_Z5umainiPPc+0xca>
		return;
	}

	// More complex requests need the block_info pointer.
	if ((r = get_block_info(blocknum, &bip, 1)) < 0) {
  80062d:	b9 01 00 00 00       	mov    $0x1,%ecx
  800632:	8d 55 e0             	lea    -0x20(%ebp),%edx
  800635:	89 d8                	mov    %ebx,%eax
  800637:	e8 54 fc ff ff       	call   800290 <_ZL14get_block_infoiPP9BlockInfoi>
  80063c:	85 c0                	test   %eax,%eax
  80063e:	79 24                	jns    800664 <_Z5umainiPPc+0x1b2>
		ipc_send(envid, r, 0, 0);
  800640:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800647:	00 
  800648:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80064f:	00 
  800650:	89 44 24 04          	mov    %eax,0x4(%esp)
  800654:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800657:	89 1c 24             	mov    %ebx,(%esp)
  80065a:	e8 e0 13 00 00       	call   801a3f <_Z8ipc_sendijPvi>
  80065f:	e9 18 ff ff ff       	jmp    80057c <_Z5umainiPPc+0xca>
		return;
	}

	if (reqtype == BCREQ_INITIALIZE) {
  800664:	83 fe 06             	cmp    $0x6,%esi
  800667:	75 2f                	jne    800698 <_Z5umainiPPc+0x1e6>
		int old_initialized = bip->bi_initialized;
  800669:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066c:	0f b6 50 2b          	movzbl 0x2b(%eax),%edx
		bip->bi_initialized = 1;
  800670:	c6 40 2b 01          	movb   $0x1,0x2b(%eax)
		ipc_send(envid, old_initialized, 0, 0);
  800674:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80067b:	00 
  80067c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800683:	00 
  800684:	89 54 24 04          	mov    %edx,0x4(%esp)
  800688:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80068b:	89 04 24             	mov    %eax,(%esp)
  80068e:	e8 ac 13 00 00       	call   801a3f <_Z8ipc_sendijPvi>
  800693:	e9 e4 fe ff ff       	jmp    80057c <_Z5umainiPPc+0xca>
		return;
	}

	// Warn about one particularly simple deadlock.
	if (reqtype == BCREQ_MAP_WLOCK && bip->bi_nlocked > 0
  800698:	83 fe 02             	cmp    $0x2,%esi
  80069b:	75 40                	jne    8006dd <_Z5umainiPPc+0x22b>
  80069d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a0:	80 78 29 00          	cmpb   $0x0,0x29(%eax)
  8006a4:	74 37                	je     8006dd <_Z5umainiPPc+0x22b>
	    && BI_REQTYPE(bip, 0) == BCREQ_MAP_WLOCK
  8006a6:	0f b6 50 28          	movzbl 0x28(%eax),%edx
  8006aa:	83 e2 07             	and    $0x7,%edx
		ipc_send(envid, old_initialized, 0, 0);
		return;
	}

	// Warn about one particularly simple deadlock.
	if (reqtype == BCREQ_MAP_WLOCK && bip->bi_nlocked > 0
  8006ad:	80 7c 10 20 02       	cmpb   $0x2,0x20(%eax,%edx,1)
  8006b2:	0f 85 32 01 00 00    	jne    8007ea <_Z5umainiPPc+0x338>
  8006b8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8006bb:	3b 0c 90             	cmp    (%eax,%edx,4),%ecx
  8006be:	0f 85 26 01 00 00    	jne    8007ea <_Z5umainiPPc+0x338>
	    && BI_REQTYPE(bip, 0) == BCREQ_MAP_WLOCK
	    && BI_ENVID(bip, 0) == envid)
		cprintf("bufcache: DEADLOCK: env [%08x] re-requests write lock on block %d!\n", envid, blocknum);
  8006c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8006c8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006cc:	c7 04 24 90 47 80 00 	movl   $0x804790,(%esp)
  8006d3:	e8 9a 03 00 00       	call   800a72 <_Z7cprintfPKcz>
  8006d8:	e9 0d 01 00 00       	jmp    8007ea <_Z5umainiPPc+0x338>

	if (reqtype == BCREQ_UNLOCK || reqtype == BCREQ_UNLOCK_FLUSH) {
  8006dd:	83 fe 03             	cmp    $0x3,%esi
  8006e0:	74 09                	je     8006eb <_Z5umainiPPc+0x239>
  8006e2:	83 fe 05             	cmp    $0x5,%esi
  8006e5:	0f 85 ff 00 00 00    	jne    8007ea <_Z5umainiPPc+0x338>
		// Ensure that envid is one of the environments
		// currently locking the block
		int n = 0;
		while (n < bip->bi_nlocked && BI_ENVID(bip, n) != envid)
  8006eb:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006ee:	0f b6 57 29          	movzbl 0x29(%edi),%edx
  8006f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f7:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8006fa:	39 d0                	cmp    %edx,%eax
  8006fc:	0f 8d bb 01 00 00    	jge    8008bd <_Z5umainiPPc+0x40b>
  800702:	0f b6 4f 28          	movzbl 0x28(%edi),%ecx
  800706:	8d 0c 08             	lea    (%eax,%ecx,1),%ecx
  800709:	89 cb                	mov    %ecx,%ebx
  80070b:	c1 fb 1f             	sar    $0x1f,%ebx
  80070e:	c1 eb 1d             	shr    $0x1d,%ebx
  800711:	01 d9                	add    %ebx,%ecx
  800713:	83 e1 07             	and    $0x7,%ecx
  800716:	29 d9                	sub    %ebx,%ecx
  800718:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  80071b:	3b 1c 8f             	cmp    (%edi,%ecx,4),%ebx
  80071e:	0f 84 99 01 00 00    	je     8008bd <_Z5umainiPPc+0x40b>
			++n;
  800724:	83 c0 01             	add    $0x1,%eax
  800727:	eb d1                	jmp    8006fa <_Z5umainiPPc+0x248>
		if (n == bip->bi_nlocked) {
			ipc_send(envid, -E_NOT_LOCKED, 0, 0);
  800729:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800730:	00 
  800731:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800738:	00 
  800739:	c7 44 24 04 ef ff ff 	movl   $0xffffffef,0x4(%esp)
  800740:	ff 
  800741:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800744:	89 04 24             	mov    %eax,(%esp)
  800747:	e8 f3 12 00 00       	call   801a3f <_Z8ipc_sendijPvi>
  80074c:	e9 2b fe ff ff       	jmp    80057c <_Z5umainiPPc+0xca>
			return;
		}

		BI_ENVID(bip, n) = BI_ENVID(bip, 0);
  800751:	0f b6 57 28          	movzbl 0x28(%edi),%edx
  800755:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800758:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  80075b:	c1 f9 1f             	sar    $0x1f,%ecx
  80075e:	c1 e9 1d             	shr    $0x1d,%ecx
  800761:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800764:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800767:	03 4d d4             	add    -0x2c(%ebp),%ecx
  80076a:	83 e1 07             	and    $0x7,%ecx
  80076d:	2b 4d d4             	sub    -0x2c(%ebp),%ecx
  800770:	83 e2 07             	and    $0x7,%edx
  800773:	8b 14 97             	mov    (%edi,%edx,4),%edx
  800776:	89 14 8f             	mov    %edx,(%edi,%ecx,4)
		BI_REQTYPE(bip, n) = BI_REQTYPE(bip, 0);
  800779:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80077c:	0f b6 7a 28          	movzbl 0x28(%edx),%edi
  800780:	01 f8                	add    %edi,%eax
  800782:	89 c1                	mov    %eax,%ecx
  800784:	c1 f9 1f             	sar    $0x1f,%ecx
  800787:	c1 e9 1d             	shr    $0x1d,%ecx
  80078a:	01 c8                	add    %ecx,%eax
  80078c:	83 e0 07             	and    $0x7,%eax
  80078f:	29 c8                	sub    %ecx,%eax
  800791:	83 e7 07             	and    $0x7,%edi
  800794:	0f b6 4c 3a 20       	movzbl 0x20(%edx,%edi,1),%ecx
  800799:	88 4c 02 20          	mov    %cl,0x20(%edx,%eax,1)
		++bip->bi_head;
  80079d:	80 42 28 01          	addb   $0x1,0x28(%edx)
		--bip->bi_nlocked;
  8007a1:	80 6a 29 01          	subb   $0x1,0x29(%edx)
		--bip->bi_count;
  8007a5:	80 6a 2a 01          	subb   $0x1,0x2a(%edx)

		r = (reqtype == BCREQ_UNLOCK ? 0 : flush_block(blocknum));
  8007a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ae:	83 fe 03             	cmp    $0x3,%esi
  8007b1:	74 07                	je     8007ba <_Z5umainiPPc+0x308>
  8007b3:	89 d8                	mov    %ebx,%eax
  8007b5:	e8 8e fb ff ff       	call   800348 <_ZL11flush_blocki>
		ipc_send(envid, r, 0, 0);
  8007ba:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007c1:	00 
  8007c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007c9:	00 
  8007ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007d1:	89 04 24             	mov    %eax,(%esp)
  8007d4:	e8 66 12 00 00       	call   801a3f <_Z8ipc_sendijPvi>
		BI_REQTYPE(bip, bip->bi_count) = reqtype;
		++bip->bi_count;
	}

	// Process the request queue
	while (bip->bi_nlocked < bip->bi_count) {
  8007d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007dc:	0f b6 50 29          	movzbl 0x29(%eax),%edx
  8007e0:	3a 50 2a             	cmp    0x2a(%eax),%dl
  8007e3:	72 66                	jb     80084b <_Z5umainiPPc+0x399>
  8007e5:	e9 92 fd ff ff       	jmp    80057c <_Z5umainiPPc+0xca>
		r = (reqtype == BCREQ_UNLOCK ? 0 : flush_block(blocknum));
		ipc_send(envid, r, 0, 0);
		// Continue on to clear the request queue: perhaps this
		// environment's unlock reqtype lets the next environment lock

	} else if (bip->bi_count == BI_QSIZE) {
  8007ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ed:	0f b6 50 2a          	movzbl 0x2a(%eax),%edx
  8007f1:	80 fa 08             	cmp    $0x8,%dl
  8007f4:	75 28                	jne    80081e <_Z5umainiPPc+0x36c>
		// The queue is full; ask the environment to try again later
		ipc_send(envid, -E_AGAIN, 0, 0);
  8007f6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007fd:	00 
  8007fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800805:	00 
  800806:	c7 44 24 04 f0 ff ff 	movl   $0xfffffff0,0x4(%esp)
  80080d:	ff 
  80080e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800811:	89 14 24             	mov    %edx,(%esp)
  800814:	e8 26 12 00 00       	call   801a3f <_Z8ipc_sendijPvi>
  800819:	e9 5e fd ff ff       	jmp    80057c <_Z5umainiPPc+0xca>
		return;

	} else {
		BI_ENVID(bip, bip->bi_count) = envid;
  80081e:	0f b6 48 28          	movzbl 0x28(%eax),%ecx
  800822:	8d 14 11             	lea    (%ecx,%edx,1),%edx
  800825:	83 e2 07             	and    $0x7,%edx
  800828:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80082b:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
		BI_REQTYPE(bip, bip->bi_count) = reqtype;
  80082e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800831:	0f b6 48 2a          	movzbl 0x2a(%eax),%ecx
  800835:	0f b6 50 28          	movzbl 0x28(%eax),%edx
  800839:	8d 14 11             	lea    (%ecx,%edx,1),%edx
  80083c:	83 e2 07             	and    $0x7,%edx
  80083f:	89 f1                	mov    %esi,%ecx
  800841:	88 4c 10 20          	mov    %cl,0x20(%eax,%edx,1)
		++bip->bi_count;
  800845:	80 40 2a 01          	addb   $0x1,0x2a(%eax)
  800849:	eb 8e                	jmp    8007d9 <_Z5umainiPPc+0x327>
	}

	// Process the request queue
	while (bip->bi_nlocked < bip->bi_count) {
		// If trying to write lock, must be first attempt
		if (BI_REQTYPE(bip, bip->bi_nlocked) == BCREQ_MAP_WLOCK
  80084b:	0f b6 78 28          	movzbl 0x28(%eax),%edi
  80084f:	8d 34 17             	lea    (%edi,%edx,1),%esi
  800852:	83 e6 07             	and    $0x7,%esi
  800855:	0f b6 4c 30 20       	movzbl 0x20(%eax,%esi,1),%ecx
  80085a:	80 f9 02             	cmp    $0x2,%cl
  80085d:	75 09                	jne    800868 <_Z5umainiPPc+0x3b6>
  80085f:	84 d2                	test   %dl,%dl
  800861:	74 21                	je     800884 <_Z5umainiPPc+0x3d2>
  800863:	e9 14 fd ff ff       	jmp    80057c <_Z5umainiPPc+0xca>
		    && bip->bi_nlocked > 0)
			break;
		// If trying to read lock, any existing lock must be read
		if (BI_REQTYPE(bip, bip->bi_nlocked) == BCREQ_MAP_RLOCK
  800868:	80 f9 01             	cmp    $0x1,%cl
  80086b:	90                   	nop
  80086c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800870:	75 12                	jne    800884 <_Z5umainiPPc+0x3d2>
  800872:	84 d2                	test   %dl,%dl
  800874:	74 0e                	je     800884 <_Z5umainiPPc+0x3d2>
		    && bip->bi_nlocked > 0
		    && BI_REQTYPE(bip, 0) != BCREQ_MAP_RLOCK)
  800876:	83 e7 07             	and    $0x7,%edi
		// If trying to write lock, must be first attempt
		if (BI_REQTYPE(bip, bip->bi_nlocked) == BCREQ_MAP_WLOCK
		    && bip->bi_nlocked > 0)
			break;
		// If trying to read lock, any existing lock must be read
		if (BI_REQTYPE(bip, bip->bi_nlocked) == BCREQ_MAP_RLOCK
  800879:	80 7c 38 20 01       	cmpb   $0x1,0x20(%eax,%edi,1)
  80087e:	0f 85 f8 fc ff ff    	jne    80057c <_Z5umainiPPc+0xca>
		    && bip->bi_nlocked > 0
		    && BI_REQTYPE(bip, 0) != BCREQ_MAP_RLOCK)
			break;
		// If we get here, we can grant the page to this queue element
		send_block(BI_ENVID(bip, bip->bi_nlocked), blocknum,
			   bip->bi_initialized);
  800884:	0f b6 48 2b          	movzbl 0x2b(%eax),%ecx
  800888:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  80088b:	89 da                	mov    %ebx,%edx
  80088d:	e8 1e fb ff ff       	call   8003b0 <_ZL10send_blockiii>
		++bip->bi_nlocked;
  800892:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800895:	80 40 29 01          	addb   $0x1,0x29(%eax)
		BI_REQTYPE(bip, bip->bi_count) = reqtype;
		++bip->bi_count;
	}

	// Process the request queue
	while (bip->bi_nlocked < bip->bi_count) {
  800899:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089c:	0f b6 50 29          	movzbl 0x29(%eax),%edx
  8008a0:	3a 50 2a             	cmp    0x2a(%eax),%dl
  8008a3:	72 a6                	jb     80084b <_Z5umainiPPc+0x399>
  8008a5:	e9 d2 fc ff ff       	jmp    80057c <_Z5umainiPPc+0xca>

static bool
another_runnable_environment_exists(void)
{
	int e;
	for (e = 1; e < NENV; ++e)
  8008aa:	83 c0 01             	add    $0x1,%eax
  8008ad:	3d 00 04 00 00       	cmp    $0x400,%eax
  8008b2:	0f 85 5f fc ff ff    	jne    800517 <_Z5umainiPPc+0x65>
  8008b8:	e9 84 fc ff ff       	jmp    800541 <_Z5umainiPPc+0x8f>
  8008bd:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
		// Ensure that envid is one of the environments
		// currently locking the block
		int n = 0;
		while (n < bip->bi_nlocked && BI_ENVID(bip, n) != envid)
			++n;
		if (n == bip->bi_nlocked) {
  8008c0:	39 c2                	cmp    %eax,%edx
  8008c2:	0f 85 89 fe ff ff    	jne    800751 <_Z5umainiPPc+0x29f>
  8008c8:	e9 5c fe ff ff       	jmp    800729 <_Z5umainiPPc+0x277>
  8008cd:	00 00                	add    %al,(%eax)
	...

008008d0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

asmlinkage void
libmain(int argc, char **argv)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	57                   	push   %edi
  8008d4:	56                   	push   %esi
  8008d5:	53                   	push   %ebx
  8008d6:	83 ec 1c             	sub    $0x1c,%esp
  8008d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	extern uintptr_t sctors[], ectors[];
	uintptr_t *ctorva;

	// set thisenv to point at our Env structure in envs[]
	thisenv = &envs[ENVX(sys_getenvid())]; /* Really? */
  8008df:	e8 24 0c 00 00       	call   801508 <_Z12sys_getenvidv>
  8008e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8008e9:	6b c0 78             	imul   $0x78,%eax,%eax
  8008ec:	05 00 00 00 ef       	add    $0xef000000,%eax
  8008f1:	a3 00 70 80 00       	mov    %eax,0x807000
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008f6:	85 ff                	test   %edi,%edi
  8008f8:	7e 07                	jle    800901 <libmain+0x31>
		binaryname = argv[0];
  8008fa:	8b 06                	mov    (%esi),%eax
  8008fc:	a3 04 60 80 00       	mov    %eax,0x806004

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800901:	b8 ea 52 80 00       	mov    $0x8052ea,%eax
  800906:	3d ea 52 80 00       	cmp    $0x8052ea,%eax
  80090b:	76 0f                	jbe    80091c <libmain+0x4c>
  80090d:	89 c3                	mov    %eax,%ebx
		((void(*)()) *--ctorva)();
  80090f:	83 eb 04             	sub    $0x4,%ebx
  800912:	ff 13                	call   *(%ebx)
		binaryname = argv[0];

	// Call any global constructors (e.g., defined by C++).
	// This relies on linker script magic to define the 'sctors' and
	// 'ectors' symbols; see user/user.ld.
	for (ctorva = ectors; ctorva > sctors; )
  800914:	81 fb ea 52 80 00    	cmp    $0x8052ea,%ebx
  80091a:	77 f3                	ja     80090f <libmain+0x3f>
		((void(*)()) *--ctorva)();

	// call user main routine
	umain(argc, argv);
  80091c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800920:	89 3c 24             	mov    %edi,(%esp)
  800923:	e8 8a fb ff ff       	call   8004b2 <_Z5umainiPPc>

	// exit gracefully
	exit();
  800928:	e8 0b 00 00 00       	call   800938 <_Z4exitv>
}
  80092d:	83 c4 1c             	add    $0x1c,%esp
  800930:	5b                   	pop    %ebx
  800931:	5e                   	pop    %esi
  800932:	5f                   	pop    %edi
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    
  800935:	00 00                	add    %al,(%eax)
	...

00800938 <_Z4exitv>:

#include <inc/lib.h>

void
exit(void)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80093e:	e8 2b 14 00 00       	call   801d6e <_Z9close_allv>
	sys_env_destroy(0);
  800943:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80094a:	e8 5c 0b 00 00       	call   8014ab <_Z15sys_env_destroyi>
}
  80094f:	c9                   	leave  
  800950:	c3                   	ret    
  800951:	00 00                	add    %al,(%eax)
	...

00800954 <_Z6_panicPKciS0_z>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	56                   	push   %esi
  800958:	53                   	push   %ebx
  800959:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80095c:	8d 75 14             	lea    0x14(%ebp),%esi

	// Print the panic message
	if (argv0)
  80095f:	a1 04 70 80 00       	mov    0x807004,%eax
  800964:	85 c0                	test   %eax,%eax
  800966:	74 10                	je     800978 <_Z6_panicPKciS0_z+0x24>
		cprintf("%s: ", argv0);
  800968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096c:	c7 04 24 de 47 80 00 	movl   $0x8047de,(%esp)
  800973:	e8 fa 00 00 00       	call   800a72 <_Z7cprintfPKcz>
	cprintf("[%08x] user panic in %s at %s:%d: ",
		sys_getenvid(), binaryname, file, line);
  800978:	8b 1d 04 60 80 00    	mov    0x806004,%ebx
  80097e:	e8 85 0b 00 00       	call   801508 <_Z12sys_getenvidv>
  800983:	8b 55 0c             	mov    0xc(%ebp),%edx
  800986:	89 54 24 10          	mov    %edx,0x10(%esp)
  80098a:	8b 55 08             	mov    0x8(%ebp),%edx
  80098d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800991:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800995:	89 44 24 04          	mov    %eax,0x4(%esp)
  800999:	c7 04 24 e4 47 80 00 	movl   $0x8047e4,(%esp)
  8009a0:	e8 cd 00 00 00       	call   800a72 <_Z7cprintfPKcz>
	vcprintf(fmt, ap);
  8009a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ac:	89 04 24             	mov    %eax,(%esp)
  8009af:	e8 5d 00 00 00       	call   800a11 <_Z8vcprintfPKcPc>
	cprintf("\n");
  8009b4:	c7 04 24 67 47 80 00 	movl   $0x804767,(%esp)
  8009bb:	e8 b2 00 00 00       	call   800a72 <_Z7cprintfPKcz>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009c0:	cc                   	int3   
  8009c1:	eb fd                	jmp    8009c0 <_Z6_panicPKciS0_z+0x6c>
	...

008009c4 <_ZL5putchiPv>:
};


static void
putch(int ch, void *ptr)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	83 ec 18             	sub    $0x18,%esp
  8009ca:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8009cd:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8009d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) ptr;
  8009d3:	89 de                	mov    %ebx,%esi
	b->buf[b->idx++] = ch;
  8009d5:	8b 03                	mov    (%ebx),%eax
  8009d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8009da:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8009de:	83 c0 01             	add    $0x1,%eax
  8009e1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8009e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009e8:	75 19                	jne    800a03 <_ZL5putchiPv+0x3f>
		sys_cputs(b->buf, b->idx);
  8009ea:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8009f1:	00 
  8009f2:	8d 43 08             	lea    0x8(%ebx),%eax
  8009f5:	89 04 24             	mov    %eax,(%esp)
  8009f8:	e8 47 0a 00 00       	call   801444 <_Z9sys_cputsPKcj>
		b->idx = 0;
  8009fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800a03:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  800a07:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800a0a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800a0d:	89 ec                	mov    %ebp,%esp
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <_Z8vcprintfPKcPc>:

int
vcprintf(const char *fmt, va_list ap)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800a1a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a21:	00 00 00 
	b.cnt = 0;
  800a24:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a2b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a3c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a46:	c7 04 24 c4 09 80 00 	movl   $0x8009c4,(%esp)
  800a4d:	e8 a5 01 00 00       	call   800bf7 <_Z9vprintfmtPFviPvES_PKcPc>
	sys_cputs(b.buf, b.idx);
  800a52:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a5c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800a62:	89 04 24             	mov    %eax,(%esp)
  800a65:	e8 da 09 00 00       	call   801444 <_Z9sys_cputsPKcj>

	return b.cnt;
}
  800a6a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <_Z7cprintfPKcz>:

int
cprintf(const char *fmt, ...)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a78:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	89 04 24             	mov    %eax,(%esp)
  800a85:	e8 87 ff ff ff       	call   800a11 <_Z8vcprintfPKcPc>
	va_end(ap);

	return cnt;
}
  800a8a:	c9                   	leave  
  800a8b:	c3                   	ret    
  800a8c:	00 00                	add    %al,(%eax)
	...

00800a90 <_ZL8printnumPFviPvES_yjii>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	57                   	push   %edi
  800a94:	56                   	push   %esi
  800a95:	53                   	push   %ebx
  800a96:	83 ec 4c             	sub    $0x4c,%esp
  800a99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a9c:	89 d6                	mov    %edx,%esi
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800aaa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800aad:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	39 d0                	cmp    %edx,%eax
  800ab7:	72 11                	jb     800aca <_ZL8printnumPFviPvES_yjii+0x3a>
  800ab9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800abc:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  800abf:	76 09                	jbe    800aca <_ZL8printnumPFviPvES_yjii+0x3a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ac1:	83 eb 01             	sub    $0x1,%ebx
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	7f 5d                	jg     800b25 <_ZL8printnumPFviPvES_yjii+0x95>
  800ac8:	eb 6c                	jmp    800b36 <_ZL8printnumPFviPvES_yjii+0xa6>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800aca:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800ace:	83 eb 01             	sub    $0x1,%ebx
  800ad1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800ad5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ad8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800adc:	8b 44 24 08          	mov    0x8(%esp),%eax
  800ae0:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800ae4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800ae7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800aea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800af1:	00 
  800af2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800af5:	89 14 24             	mov    %edx,(%esp)
  800af8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800afb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800aff:	e8 5c 39 00 00       	call   804460 <__udivdi3>
  800b04:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800b07:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800b0a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b0e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800b12:	89 04 24             	mov    %eax,(%esp)
  800b15:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b19:	89 f2                	mov    %esi,%edx
  800b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b1e:	e8 6d ff ff ff       	call   800a90 <_ZL8printnumPFviPvES_yjii>
  800b23:	eb 11                	jmp    800b36 <_ZL8printnumPFviPvES_yjii+0xa6>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b29:	89 3c 24             	mov    %edi,(%esp)
  800b2c:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b2f:	83 eb 01             	sub    $0x1,%ebx
  800b32:	85 db                	test   %ebx,%ebx
  800b34:	7f ef                	jg     800b25 <_ZL8printnumPFviPvES_yjii+0x95>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b36:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b3a:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b41:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b45:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800b4c:	00 
  800b4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800b50:	89 14 24             	mov    %edx,(%esp)
  800b53:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b56:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800b5a:	e8 11 3a 00 00       	call   804570 <__umoddi3>
  800b5f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b63:	0f be 80 07 48 80 00 	movsbl 0x804807(%eax),%eax
  800b6a:	89 04 24             	mov    %eax,(%esp)
  800b6d:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800b70:	83 c4 4c             	add    $0x4c,%esp
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5f                   	pop    %edi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <_ZL7getuintPPci>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b7b:	83 fa 01             	cmp    $0x1,%edx
  800b7e:	7e 0e                	jle    800b8e <_ZL7getuintPPci+0x16>
		return va_arg(*ap, unsigned long long);
  800b80:	8b 10                	mov    (%eax),%edx
  800b82:	8d 4a 08             	lea    0x8(%edx),%ecx
  800b85:	89 08                	mov    %ecx,(%eax)
  800b87:	8b 02                	mov    (%edx),%eax
  800b89:	8b 52 04             	mov    0x4(%edx),%edx
  800b8c:	eb 22                	jmp    800bb0 <_ZL7getuintPPci+0x38>
	else if (lflag)
  800b8e:	85 d2                	test   %edx,%edx
  800b90:	74 10                	je     800ba2 <_ZL7getuintPPci+0x2a>
		return va_arg(*ap, unsigned long);
  800b92:	8b 10                	mov    (%eax),%edx
  800b94:	8d 4a 04             	lea    0x4(%edx),%ecx
  800b97:	89 08                	mov    %ecx,(%eax)
  800b99:	8b 02                	mov    (%edx),%eax
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	eb 0e                	jmp    800bb0 <_ZL7getuintPPci+0x38>
	else
		return va_arg(*ap, unsigned int);
  800ba2:	8b 10                	mov    (%eax),%edx
  800ba4:	8d 4a 04             	lea    0x4(%edx),%ecx
  800ba7:	89 08                	mov    %ecx,(%eax)
  800ba9:	8b 02                	mov    (%edx),%eax
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <_ZL11sprintputchiPv>:
	int cnt;
};

static void
sprintputch(int ch, void *ptr)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
	struct sprintbuf *b = (struct sprintbuf *) ptr;
	b->cnt++;
  800bb8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800bbc:	8b 10                	mov    (%eax),%edx
  800bbe:	3b 50 04             	cmp    0x4(%eax),%edx
  800bc1:	73 0a                	jae    800bcd <_ZL11sprintputchiPv+0x1b>
		*b->buf++ = ch;
  800bc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc6:	88 0a                	mov    %cl,(%edx)
  800bc8:	83 c2 01             	add    $0x1,%edx
  800bcb:	89 10                	mov    %edx,(%eax)
}
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <_Z8printfmtPFviPvES_PKcz>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bd5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800bd8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	89 04 24             	mov    %eax,(%esp)
  800bf0:	e8 02 00 00 00       	call   800bf7 <_Z9vprintfmtPFviPvES_PKcPc>
	va_end(ap);
}
  800bf5:	c9                   	leave  
  800bf6:	c3                   	ret    

00800bf7 <_Z9vprintfmtPFviPvES_PKcPc>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	83 ec 3c             	sub    $0x3c,%esp
  800c00:	8b 7d 0c             	mov    0xc(%ebp),%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c03:	8b 55 10             	mov    0x10(%ebp),%edx
  800c06:	0f b6 02             	movzbl (%edx),%eax
  800c09:	89 d3                	mov    %edx,%ebx
  800c0b:	83 c3 01             	add    $0x1,%ebx
  800c0e:	83 f8 25             	cmp    $0x25,%eax
  800c11:	74 2b                	je     800c3e <_Z9vprintfmtPFviPvES_PKcPc+0x47>
			if (ch == '\0')
  800c13:	85 c0                	test   %eax,%eax
  800c15:	75 10                	jne    800c27 <_Z9vprintfmtPFviPvES_PKcPc+0x30>
  800c17:	e9 a5 03 00 00       	jmp    800fc1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800c1c:	85 c0                	test   %eax,%eax
  800c1e:	66 90                	xchg   %ax,%ax
  800c20:	75 08                	jne    800c2a <_Z9vprintfmtPFviPvES_PKcPc+0x33>
  800c22:	e9 9a 03 00 00       	jmp    800fc1 <_Z9vprintfmtPFviPvES_PKcPc+0x3ca>
  800c27:	8b 75 08             	mov    0x8(%ebp),%esi
				return;
			putch(ch, putdat);
  800c2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c2e:	89 04 24             	mov    %eax,(%esp)
  800c31:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c33:	0f b6 03             	movzbl (%ebx),%eax
  800c36:	83 c3 01             	add    $0x1,%ebx
  800c39:	83 f8 25             	cmp    $0x25,%eax
  800c3c:	75 de                	jne    800c1c <_Z9vprintfmtPFviPvES_PKcPc+0x25>
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800c3e:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
  800c42:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800c49:	be ff ff ff ff       	mov    $0xffffffff,%esi
  800c4e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800c55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c5a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800c5d:	eb 2b                	jmp    800c8a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c5f:	8b 5d 10             	mov    0x10(%ebp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  800c62:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
  800c66:	eb 22                	jmp    800c8a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c68:	8b 5d 10             	mov    0x10(%ebp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c6b:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
  800c6f:	eb 19                	jmp    800c8a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c71:	8b 5d 10             	mov    0x10(%ebp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  800c74:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800c7b:	eb 0d                	jmp    800c8a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800c7d:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800c80:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800c83:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c8a:	0f b6 03             	movzbl (%ebx),%eax
  800c8d:	0f b6 d0             	movzbl %al,%edx
  800c90:	8d 73 01             	lea    0x1(%ebx),%esi
  800c93:	89 75 10             	mov    %esi,0x10(%ebp)
  800c96:	83 e8 23             	sub    $0x23,%eax
  800c99:	3c 55                	cmp    $0x55,%al
  800c9b:	0f 87 d8 02 00 00    	ja     800f79 <_Z9vprintfmtPFviPvES_PKcPc+0x382>
  800ca1:	0f b6 c0             	movzbl %al,%eax
  800ca4:	ff 24 85 a0 49 80 00 	jmp    *0x8049a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800cab:	83 ea 30             	sub    $0x30,%edx
  800cae:	89 55 d8             	mov    %edx,-0x28(%ebp)
				ch = *fmt;
  800cb1:	8b 55 10             	mov    0x10(%ebp),%edx
  800cb4:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  800cb7:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cba:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  800cbd:	83 fa 09             	cmp    $0x9,%edx
  800cc0:	77 4e                	ja     800d10 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cc2:	8b 75 d8             	mov    -0x28(%ebp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cc5:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  800cc8:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  800ccb:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  800ccf:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  800cd2:	8d 50 d0             	lea    -0x30(%eax),%edx
  800cd5:	83 fa 09             	cmp    $0x9,%edx
  800cd8:	76 eb                	jbe    800cc5 <_Z9vprintfmtPFviPvES_PKcPc+0xce>
  800cda:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800cdd:	eb 31                	jmp    800d10 <_Z9vprintfmtPFviPvES_PKcPc+0x119>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	8d 50 04             	lea    0x4(%eax),%edx
  800ce5:	89 55 14             	mov    %edx,0x14(%ebp)
  800ce8:	8b 00                	mov    (%eax),%eax
  800cea:	89 45 d8             	mov    %eax,-0x28(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ced:	8b 5d 10             	mov    0x10(%ebp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800cf0:	eb 1e                	jmp    800d10 <_Z9vprintfmtPFviPvES_PKcPc+0x119>

		case '.':
			if (width < 0)
  800cf2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf6:	0f 88 75 ff ff ff    	js     800c71 <_Z9vprintfmtPFviPvES_PKcPc+0x7a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cff:	eb 89                	jmp    800c8a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800d01:	8b 5d 10             	mov    0x10(%ebp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800d04:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d0b:	e9 7a ff ff ff       	jmp    800c8a <_Z9vprintfmtPFviPvES_PKcPc+0x93>

		process_precision:
			if (width < 0)
  800d10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d14:	0f 89 70 ff ff ff    	jns    800c8a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
  800d1a:	e9 5e ff ff ff       	jmp    800c7d <_Z9vprintfmtPFviPvES_PKcPc+0x86>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d1f:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d22:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d25:	e9 60 ff ff ff       	jmp    800c8a <_Z9vprintfmtPFviPvES_PKcPc+0x93>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2d:	8d 50 04             	lea    0x4(%eax),%edx
  800d30:	89 55 14             	mov    %edx,0x14(%ebp)
  800d33:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d37:	8b 00                	mov    (%eax),%eax
  800d39:	89 04 24             	mov    %eax,(%esp)
  800d3c:	ff 55 08             	call   *0x8(%ebp)
			break;
  800d3f:	e9 bf fe ff ff       	jmp    800c03 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d44:	8b 45 14             	mov    0x14(%ebp),%eax
  800d47:	8d 50 04             	lea    0x4(%eax),%edx
  800d4a:	89 55 14             	mov    %edx,0x14(%ebp)
  800d4d:	8b 00                	mov    (%eax),%eax
  800d4f:	89 c2                	mov    %eax,%edx
  800d51:	c1 fa 1f             	sar    $0x1f,%edx
  800d54:	31 d0                	xor    %edx,%eax
  800d56:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d58:	83 f8 14             	cmp    $0x14,%eax
  800d5b:	7f 0f                	jg     800d6c <_Z9vprintfmtPFviPvES_PKcPc+0x175>
  800d5d:	8b 14 85 00 4b 80 00 	mov    0x804b00(,%eax,4),%edx
  800d64:	85 d2                	test   %edx,%edx
  800d66:	0f 85 35 02 00 00    	jne    800fa1 <_Z9vprintfmtPFviPvES_PKcPc+0x3aa>
				printfmt(putch, putdat, "error %d", err);
  800d6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d70:	c7 44 24 08 1f 48 80 	movl   $0x80481f,0x8(%esp)
  800d77:	00 
  800d78:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d7c:	8b 75 08             	mov    0x8(%ebp),%esi
  800d7f:	89 34 24             	mov    %esi,(%esp)
  800d82:	e8 48 fe ff ff       	call   800bcf <_Z8printfmtPFviPvES_PKcz>
  800d87:	e9 77 fe ff ff       	jmp    800c03 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  800d8c:	8b 75 d8             	mov    -0x28(%ebp),%esi
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d92:	89 45 d8             	mov    %eax,-0x28(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d95:	8b 45 14             	mov    0x14(%ebp),%eax
  800d98:	8d 50 04             	lea    0x4(%eax),%edx
  800d9b:	89 55 14             	mov    %edx,0x14(%ebp)
  800d9e:	8b 18                	mov    (%eax),%ebx
				p = "(null)";
  800da0:	85 db                	test   %ebx,%ebx
  800da2:	ba 18 48 80 00       	mov    $0x804818,%edx
  800da7:	0f 44 da             	cmove  %edx,%ebx
			if (width > 0 && padc != '-')
  800daa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800dae:	7e 72                	jle    800e22 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
  800db0:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
  800db4:	74 6c                	je     800e22 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800db6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dba:	89 1c 24             	mov    %ebx,(%esp)
  800dbd:	e8 a9 02 00 00       	call   80106b <_Z7strnlenPKcj>
  800dc2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800dc5:	29 c2                	sub    %eax,%edx
  800dc7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800dca:	85 d2                	test   %edx,%edx
  800dcc:	7e 54                	jle    800e22 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
  800dce:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
  800dd2:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800dd5:	89 d3                	mov    %edx,%ebx
  800dd7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800dda:	89 c6                	mov    %eax,%esi
  800ddc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800de0:	89 34 24             	mov    %esi,(%esp)
  800de3:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de6:	83 eb 01             	sub    $0x1,%ebx
  800de9:	85 db                	test   %ebx,%ebx
  800deb:	7f ef                	jg     800ddc <_Z9vprintfmtPFviPvES_PKcPc+0x1e5>
  800ded:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800df0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800df3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800dfa:	eb 26                	jmp    800e22 <_Z9vprintfmtPFviPvES_PKcPc+0x22b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800dfc:	8d 50 e0             	lea    -0x20(%eax),%edx
  800dff:	83 fa 5e             	cmp    $0x5e,%edx
  800e02:	76 10                	jbe    800e14 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
					putch('?', putdat);
  800e04:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e08:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800e0f:	ff 55 08             	call   *0x8(%ebp)
  800e12:	eb 0a                	jmp    800e1e <_Z9vprintfmtPFviPvES_PKcPc+0x227>
				else
					putch(ch, putdat);
  800e14:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e18:	89 04 24             	mov    %eax,(%esp)
  800e1b:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e1e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800e22:	0f be 03             	movsbl (%ebx),%eax
  800e25:	83 c3 01             	add    $0x1,%ebx
  800e28:	85 c0                	test   %eax,%eax
  800e2a:	74 11                	je     800e3d <_Z9vprintfmtPFviPvES_PKcPc+0x246>
  800e2c:	85 f6                	test   %esi,%esi
  800e2e:	78 05                	js     800e35 <_Z9vprintfmtPFviPvES_PKcPc+0x23e>
  800e30:	83 ee 01             	sub    $0x1,%esi
  800e33:	78 0d                	js     800e42 <_Z9vprintfmtPFviPvES_PKcPc+0x24b>
				if (altflag && (ch < ' ' || ch > '~'))
  800e35:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e39:	75 c1                	jne    800dfc <_Z9vprintfmtPFviPvES_PKcPc+0x205>
  800e3b:	eb d7                	jmp    800e14 <_Z9vprintfmtPFviPvES_PKcPc+0x21d>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e40:	eb 03                	jmp    800e45 <_Z9vprintfmtPFviPvES_PKcPc+0x24e>
  800e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	0f 8e b6 fd ff ff    	jle    800c03 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
  800e4d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800e50:	8b 75 08             	mov    0x8(%ebp),%esi
				putch(' ', putdat);
  800e53:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e57:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800e5e:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e60:	83 eb 01             	sub    $0x1,%ebx
  800e63:	85 db                	test   %ebx,%ebx
  800e65:	7f ec                	jg     800e53 <_Z9vprintfmtPFviPvES_PKcPc+0x25c>
  800e67:	e9 97 fd ff ff       	jmp    800c03 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800e6c:	83 f9 01             	cmp    $0x1,%ecx
  800e6f:	90                   	nop
  800e70:	7e 10                	jle    800e82 <_Z9vprintfmtPFviPvES_PKcPc+0x28b>
		return va_arg(*ap, long long);
  800e72:	8b 45 14             	mov    0x14(%ebp),%eax
  800e75:	8d 50 08             	lea    0x8(%eax),%edx
  800e78:	89 55 14             	mov    %edx,0x14(%ebp)
  800e7b:	8b 18                	mov    (%eax),%ebx
  800e7d:	8b 70 04             	mov    0x4(%eax),%esi
  800e80:	eb 26                	jmp    800ea8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else if (lflag)
  800e82:	85 c9                	test   %ecx,%ecx
  800e84:	74 12                	je     800e98 <_Z9vprintfmtPFviPvES_PKcPc+0x2a1>
		return va_arg(*ap, long);
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	8d 50 04             	lea    0x4(%eax),%edx
  800e8c:	89 55 14             	mov    %edx,0x14(%ebp)
  800e8f:	8b 18                	mov    (%eax),%ebx
  800e91:	89 de                	mov    %ebx,%esi
  800e93:	c1 fe 1f             	sar    $0x1f,%esi
  800e96:	eb 10                	jmp    800ea8 <_Z9vprintfmtPFviPvES_PKcPc+0x2b1>
	else
		return va_arg(*ap, int);
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	8d 50 04             	lea    0x4(%eax),%edx
  800e9e:	89 55 14             	mov    %edx,0x14(%ebp)
  800ea1:	8b 18                	mov    (%eax),%ebx
  800ea3:	89 de                	mov    %ebx,%esi
  800ea5:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800ea8:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800ead:	85 f6                	test   %esi,%esi
  800eaf:	0f 89 8c 00 00 00    	jns    800f41 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
				putch('-', putdat);
  800eb5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eb9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800ec0:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800ec3:	f7 db                	neg    %ebx
  800ec5:	83 d6 00             	adc    $0x0,%esi
  800ec8:	f7 de                	neg    %esi
			}
			base = 10;
  800eca:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ecf:	eb 70                	jmp    800f41 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed1:	89 ca                	mov    %ecx,%edx
  800ed3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed6:	e8 9d fc ff ff       	call   800b78 <_ZL7getuintPPci>
  800edb:	89 c3                	mov    %eax,%ebx
  800edd:	89 d6                	mov    %edx,%esi
			base = 10;
  800edf:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  800ee4:	eb 5b                	jmp    800f41 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800ee6:	89 ca                	mov    %ecx,%edx
  800ee8:	8d 45 14             	lea    0x14(%ebp),%eax
  800eeb:	e8 88 fc ff ff       	call   800b78 <_ZL7getuintPPci>
  800ef0:	89 c3                	mov    %eax,%ebx
  800ef2:	89 d6                	mov    %edx,%esi
			base = 8;
  800ef4:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
  800ef9:	eb 46                	jmp    800f41 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// pointer
		case 'p':
			putch('0', putdat);
  800efb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eff:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800f06:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800f09:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f0d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800f14:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800f17:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1a:	8d 50 04             	lea    0x4(%eax),%edx
  800f1d:	89 55 14             	mov    %edx,0x14(%ebp)
  800f20:	8b 18                	mov    (%eax),%ebx
  800f22:	be 00 00 00 00       	mov    $0x0,%esi
			base = 16;
  800f27:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800f2c:	eb 13                	jmp    800f41 <_Z9vprintfmtPFviPvES_PKcPc+0x34a>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f2e:	89 ca                	mov    %ecx,%edx
  800f30:	8d 45 14             	lea    0x14(%ebp),%eax
  800f33:	e8 40 fc ff ff       	call   800b78 <_ZL7getuintPPci>
  800f38:	89 c3                	mov    %eax,%ebx
  800f3a:	89 d6                	mov    %edx,%esi
			base = 16;
  800f3c:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f41:	0f be 55 e0          	movsbl -0x20(%ebp),%edx
  800f45:	89 54 24 10          	mov    %edx,0x10(%esp)
  800f49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f4c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f50:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f54:	89 1c 24             	mov    %ebx,(%esp)
  800f57:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f5b:	89 fa                	mov    %edi,%edx
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	e8 2b fb ff ff       	call   800a90 <_ZL8printnumPFviPvES_yjii>
			break;
  800f65:	e9 99 fc ff ff       	jmp    800c03 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f6e:	89 14 24             	mov    %edx,(%esp)
  800f71:	ff 55 08             	call   *0x8(%ebp)
			break;
  800f74:	e9 8a fc ff ff       	jmp    800c03 <_Z9vprintfmtPFviPvES_PKcPc+0xc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f79:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f7d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800f84:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f87:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f8a:	89 d8                	mov    %ebx,%eax
  800f8c:	eb 02                	jmp    800f90 <_Z9vprintfmtPFviPvES_PKcPc+0x399>
  800f8e:	89 d0                	mov    %edx,%eax
  800f90:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f93:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800f97:	75 f5                	jne    800f8e <_Z9vprintfmtPFviPvES_PKcPc+0x397>
  800f99:	89 45 10             	mov    %eax,0x10(%ebp)
  800f9c:	e9 62 fc ff ff       	jmp    800c03 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fa5:	c7 44 24 08 0f 47 80 	movl   $0x80470f,0x8(%esp)
  800fac:	00 
  800fad:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fb1:	8b 75 08             	mov    0x8(%ebp),%esi
  800fb4:	89 34 24             	mov    %esi,(%esp)
  800fb7:	e8 13 fc ff ff       	call   800bcf <_Z8printfmtPFviPvES_PKcz>
  800fbc:	e9 42 fc ff ff       	jmp    800c03 <_Z9vprintfmtPFviPvES_PKcPc+0xc>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fc1:	83 c4 3c             	add    $0x3c,%esp
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <_Z9vsnprintfPciPKcS_>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	83 ec 28             	sub    $0x28,%esp
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800fdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fdf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800fe3:	89 4d f0             	mov    %ecx,-0x10(%ebp)

	if (buf == NULL || n < 1)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	74 30                	je     80101a <_Z9vsnprintfPciPKcS_+0x51>
  800fea:	85 d2                	test   %edx,%edx
  800fec:	7e 2c                	jle    80101a <_Z9vsnprintfPciPKcS_+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt(sprintputch, &b, fmt, ap);
  800fee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ff5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ffc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801003:	c7 04 24 b2 0b 80 00 	movl   $0x800bb2,(%esp)
  80100a:	e8 e8 fb ff ff       	call   800bf7 <_Z9vprintfmtPFviPvES_PKcPc>

	// null terminate the buffer
	*b.buf = '\0';
  80100f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801012:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801018:	eb 05                	jmp    80101f <_Z9vsnprintfPciPKcS_+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  80101a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <_Z8snprintfPciPKcz>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801027:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80102a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80102e:	8b 45 10             	mov    0x10(%ebp),%eax
  801031:	89 44 24 08          	mov    %eax,0x8(%esp)
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	89 44 24 04          	mov    %eax,0x4(%esp)
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	89 04 24             	mov    %eax,(%esp)
  801042:	e8 82 ff ff ff       	call   800fc9 <_Z9vsnprintfPciPKcS_>
	va_end(ap);

	return rc;
}
  801047:	c9                   	leave  
  801048:	c3                   	ret    
  801049:	00 00                	add    %al,(%eax)
  80104b:	00 00                	add    %al,(%eax)
  80104d:	00 00                	add    %al,(%eax)
	...

00801050 <_Z6strlenPKc>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801056:	b8 00 00 00 00       	mov    $0x0,%eax
  80105b:	80 3a 00             	cmpb   $0x0,(%edx)
  80105e:	74 09                	je     801069 <_Z6strlenPKc+0x19>
		n++;
  801060:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801063:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801067:	75 f7                	jne    801060 <_Z6strlenPKc+0x10>
		n++;
	return n;
}
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <_Z7strnlenPKcj>:

int
strnlen(const char *s, size_t size)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801071:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801074:	b8 00 00 00 00       	mov    $0x0,%eax
  801079:	39 c2                	cmp    %eax,%edx
  80107b:	74 0b                	je     801088 <_Z7strnlenPKcj+0x1d>
  80107d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801081:	74 05                	je     801088 <_Z7strnlenPKcj+0x1d>
		n++;
  801083:	83 c0 01             	add    $0x1,%eax
  801086:	eb f1                	jmp    801079 <_Z7strnlenPKcj+0xe>
	return n;
}
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    

0080108a <_Z6strcpyPcPKc>:

char *
strcpy(char *dst, const char *src)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	53                   	push   %ebx
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret = dst;

	while ((*dst++ = *src++) != '\0')
  801094:	ba 00 00 00 00       	mov    $0x0,%edx
  801099:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80109d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8010a0:	83 c2 01             	add    $0x1,%edx
  8010a3:	84 c9                	test   %cl,%cl
  8010a5:	75 f2                	jne    801099 <_Z6strcpyPcPKc+0xf>
		/* do nothing */;
	return ret;
}
  8010a7:	5b                   	pop    %ebx
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    

008010aa <_Z7strncpyPcPKcj>:

char *
strncpy(char *dst, const char *src, size_t size)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	56                   	push   %esi
  8010ae:	53                   	push   %ebx
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8010b8:	85 f6                	test   %esi,%esi
  8010ba:	74 18                	je     8010d4 <_Z7strncpyPcPKcj+0x2a>
  8010bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8010c1:	0f b6 1a             	movzbl (%edx),%ebx
  8010c4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8010c7:	80 3a 01             	cmpb   $0x1,(%edx)
  8010ca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size)
{
	size_t i;
	char *ret = dst;

	for (i = 0; i < size; i++) {
  8010cd:	83 c1 01             	add    $0x1,%ecx
  8010d0:	39 ce                	cmp    %ecx,%esi
  8010d2:	77 ed                	ja     8010c1 <_Z7strncpyPcPKcj+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    

008010d8 <_Z7strlcpyPcPKcj>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	56                   	push   %esi
  8010dc:	53                   	push   %ebx
  8010dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8010e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in = dst;

	if (size > 0) {
  8010e6:	89 f0                	mov    %esi,%eax
  8010e8:	85 d2                	test   %edx,%edx
  8010ea:	74 17                	je     801103 <_Z7strlcpyPcPKcj+0x2b>
		while (--size > 0 && *src != '\0')
  8010ec:	83 ea 01             	sub    $0x1,%edx
  8010ef:	74 18                	je     801109 <_Z7strlcpyPcPKcj+0x31>
  8010f1:	80 39 00             	cmpb   $0x0,(%ecx)
  8010f4:	74 17                	je     80110d <_Z7strlcpyPcPKcj+0x35>
			*dst++ = *src++;
  8010f6:	0f b6 19             	movzbl (%ecx),%ebx
  8010f9:	88 18                	mov    %bl,(%eax)
  8010fb:	83 c0 01             	add    $0x1,%eax
  8010fe:	83 c1 01             	add    $0x1,%ecx
  801101:	eb e9                	jmp    8010ec <_Z7strlcpyPcPKcj+0x14>
		*dst = '\0';
	}
	return dst - dst_in;
  801103:	29 f0                	sub    %esi,%eax
}
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    
strlcpy(char *dst, const char *src, size_t size)
{
	char *dst_in = dst;

	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801109:	89 c2                	mov    %eax,%edx
  80110b:	eb 02                	jmp    80110f <_Z7strlcpyPcPKcj+0x37>
  80110d:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  80110f:	c6 02 00             	movb   $0x0,(%edx)
  801112:	eb ef                	jmp    801103 <_Z7strlcpyPcPKcj+0x2b>

00801114 <_Z6strcmpPKcS0_>:
	return dst - dst_in;
}

int
strcmp(const char *p, const char *q)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80111d:	0f b6 01             	movzbl (%ecx),%eax
  801120:	84 c0                	test   %al,%al
  801122:	74 0c                	je     801130 <_Z6strcmpPKcS0_+0x1c>
  801124:	3a 02                	cmp    (%edx),%al
  801126:	75 08                	jne    801130 <_Z6strcmpPKcS0_+0x1c>
		p++, q++;
  801128:	83 c1 01             	add    $0x1,%ecx
  80112b:	83 c2 01             	add    $0x1,%edx
  80112e:	eb ed                	jmp    80111d <_Z6strcmpPKcS0_+0x9>
	return (unsigned char) *p - (unsigned char) *q;
  801130:	0f b6 c0             	movzbl %al,%eax
  801133:	0f b6 12             	movzbl (%edx),%edx
  801136:	29 d0                	sub    %edx,%eax
}
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <_Z7strncmpPKcS0_j>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	53                   	push   %ebx
  80113e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801141:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801144:	8b 55 10             	mov    0x10(%ebp),%edx
	while (n > 0 && *p && *p == *q)
  801147:	85 d2                	test   %edx,%edx
  801149:	74 16                	je     801161 <_Z7strncmpPKcS0_j+0x27>
  80114b:	0f b6 01             	movzbl (%ecx),%eax
  80114e:	84 c0                	test   %al,%al
  801150:	74 17                	je     801169 <_Z7strncmpPKcS0_j+0x2f>
  801152:	3a 03                	cmp    (%ebx),%al
  801154:	75 13                	jne    801169 <_Z7strncmpPKcS0_j+0x2f>
		n--, p++, q++;
  801156:	83 ea 01             	sub    $0x1,%edx
  801159:	83 c1 01             	add    $0x1,%ecx
  80115c:	83 c3 01             	add    $0x1,%ebx
  80115f:	eb e6                	jmp    801147 <_Z7strncmpPKcS0_j+0xd>
	if (n == 0)
		return 0;
  801161:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (unsigned char) *p - (unsigned char) *q;
}
  801166:	5b                   	pop    %ebx
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (unsigned char) *p - (unsigned char) *q;
  801169:	0f b6 01             	movzbl (%ecx),%eax
  80116c:	0f b6 13             	movzbl (%ebx),%edx
  80116f:	29 d0                	sub    %edx,%eax
  801171:	eb f3                	jmp    801166 <_Z7strncmpPKcS0_j+0x2c>

00801173 <_Z6strchrPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80117d:	0f b6 10             	movzbl (%eax),%edx
  801180:	84 d2                	test   %dl,%dl
  801182:	74 1f                	je     8011a3 <_Z6strchrPKcc+0x30>
		if (*s == c)
  801184:	38 ca                	cmp    %cl,%dl
  801186:	75 0a                	jne    801192 <_Z6strchrPKcc+0x1f>
  801188:	eb 1e                	jmp    8011a8 <_Z6strchrPKcc+0x35>
  80118a:	38 ca                	cmp    %cl,%dl
  80118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801190:	74 16                	je     8011a8 <_Z6strchrPKcc+0x35>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801192:	83 c0 01             	add    $0x1,%eax
  801195:	0f b6 10             	movzbl (%eax),%edx
  801198:	84 d2                	test   %dl,%dl
  80119a:	75 ee                	jne    80118a <_Z6strchrPKcc+0x17>
		if (*s == c)
			return (char *) s;
	return 0;
  80119c:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a1:	eb 05                	jmp    8011a8 <_Z6strchrPKcc+0x35>
  8011a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    

008011aa <_Z7strfindPKcc>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8011b4:	0f b6 10             	movzbl (%eax),%edx
  8011b7:	84 d2                	test   %dl,%dl
  8011b9:	74 14                	je     8011cf <_Z7strfindPKcc+0x25>
		if (*s == c)
  8011bb:	38 ca                	cmp    %cl,%dl
  8011bd:	75 06                	jne    8011c5 <_Z7strfindPKcc+0x1b>
  8011bf:	eb 0e                	jmp    8011cf <_Z7strfindPKcc+0x25>
  8011c1:	38 ca                	cmp    %cl,%dl
  8011c3:	74 0a                	je     8011cf <_Z7strfindPKcc+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c5:	83 c0 01             	add    $0x1,%eax
  8011c8:	0f b6 10             	movzbl (%eax),%edx
  8011cb:	84 d2                	test   %dl,%dl
  8011cd:	75 f2                	jne    8011c1 <_Z7strfindPKcc+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    

008011d1 <memset>:

asmlinkage void *
memset(void *v, int c, size_t n)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	89 1c 24             	mov    %ebx,(%esp)
  8011da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	if ((uintptr_t) v % 4 == 0 && n % 4 == 0) {
  8011eb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8011f1:	75 25                	jne    801218 <memset+0x47>
  8011f3:	f6 c1 03             	test   $0x3,%cl
  8011f6:	75 20                	jne    801218 <memset+0x47>
		c &= 0xFF;
  8011f8:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011fb:	89 d3                	mov    %edx,%ebx
  8011fd:	c1 e3 08             	shl    $0x8,%ebx
  801200:	89 d6                	mov    %edx,%esi
  801202:	c1 e6 18             	shl    $0x18,%esi
  801205:	89 d0                	mov    %edx,%eax
  801207:	c1 e0 10             	shl    $0x10,%eax
  80120a:	09 f0                	or     %esi,%eax
  80120c:	09 d0                	or     %edx,%eax
  80120e:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
  801210:	c1 e9 02             	shr    $0x2,%ecx
  801213:	fc                   	cld    
  801214:	f3 ab                	rep stos %eax,%es:(%edi)
  801216:	eb 03                	jmp    80121b <memset+0x4a>
	} else
		asm volatile("cld; rep stosb\n"
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
  801218:	fc                   	cld    
  801219:	f3 aa                	rep stos %al,%es:(%edi)
	while (n-- > 0)
		*p++ = c;
#endif

	return v;
}
  80121b:	89 f8                	mov    %edi,%eax
  80121d:	8b 1c 24             	mov    (%esp),%ebx
  801220:	8b 74 24 04          	mov    0x4(%esp),%esi
  801224:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801228:	89 ec                	mov    %ebp,%esp
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <memmove>:

asmlinkage void *
memmove(void *dst, const void *src, size_t n)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 08             	sub    $0x8,%esp
  801232:	89 34 24             	mov    %esi,(%esp)
  801235:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80123f:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if (s < d && s + n > d) {
  801242:	39 c6                	cmp    %eax,%esi
  801244:	73 36                	jae    80127c <memmove+0x50>
  801246:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801249:	39 d0                	cmp    %edx,%eax
  80124b:	73 2f                	jae    80127c <memmove+0x50>
		s += n;
		d += n;
  80124d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  801250:	f6 c2 03             	test   $0x3,%dl
  801253:	75 1b                	jne    801270 <memmove+0x44>
  801255:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80125b:	75 13                	jne    801270 <memmove+0x44>
  80125d:	f6 c1 03             	test   $0x3,%cl
  801260:	75 0e                	jne    801270 <memmove+0x44>
		    && n % 4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801262:	83 ef 04             	sub    $0x4,%edi
  801265:	8d 72 fc             	lea    -0x4(%edx),%esi
  801268:	c1 e9 02             	shr    $0x2,%ecx
  80126b:	fd                   	std    
  80126c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80126e:	eb 09                	jmp    801279 <memmove+0x4d>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801270:	83 ef 01             	sub    $0x1,%edi
  801273:	8d 72 ff             	lea    -0x1(%edx),%esi
  801276:	fd                   	std    
  801277:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801279:	fc                   	cld    
  80127a:	eb 20                	jmp    80129c <memmove+0x70>
	} else {
		if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  80127c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801282:	75 13                	jne    801297 <memmove+0x6b>
  801284:	a8 03                	test   $0x3,%al
  801286:	75 0f                	jne    801297 <memmove+0x6b>
  801288:	f6 c1 03             	test   $0x3,%cl
  80128b:	75 0a                	jne    801297 <memmove+0x6b>
		    && n % 4 == 0)
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80128d:	c1 e9 02             	shr    $0x2,%ecx
  801290:	89 c7                	mov    %eax,%edi
  801292:	fc                   	cld    
  801293:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801295:	eb 05                	jmp    80129c <memmove+0x70>
		else
			asm volatile("cld; rep movsb\n"
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  801297:	89 c7                	mov    %eax,%edi
  801299:	fc                   	cld    
  80129a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
			*d++ = *s++;

#endif

	return dst;
}
  80129c:	8b 34 24             	mov    (%esp),%esi
  80129f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8012a3:	89 ec                	mov    %ebp,%esp
  8012a5:	5d                   	pop    %ebp
  8012a6:	c3                   	ret    

008012a7 <memcpy>:

asmlinkage void *
memcpy(void *dst, const void *src, size_t n)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 08             	sub    $0x8,%esp
  8012ad:	89 34 24             	mov    %esi,(%esp)
  8012b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
#if ASM
	const char *s = (const char *) src;
	char *d = (char *) dst;

	if ((uintptr_t) s % 4 == 0 && (uintptr_t) d % 4 == 0
  8012bd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8012c3:	75 13                	jne    8012d8 <memcpy+0x31>
  8012c5:	a8 03                	test   $0x3,%al
  8012c7:	75 0f                	jne    8012d8 <memcpy+0x31>
  8012c9:	f6 c1 03             	test   $0x3,%cl
  8012cc:	75 0a                	jne    8012d8 <memcpy+0x31>
	    && n % 4 == 0)
		asm volatile("cld; rep movsl\n"
			:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012ce:	c1 e9 02             	shr    $0x2,%ecx
  8012d1:	89 c7                	mov    %eax,%edi
  8012d3:	fc                   	cld    
  8012d4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012d6:	eb 05                	jmp    8012dd <memcpy+0x36>
	else
		asm volatile("cld; rep movsb\n"
			:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
  8012d8:	89 c7                	mov    %eax,%edi
  8012da:	fc                   	cld    
  8012db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	while (n-- > 0)
		*d++ = *s++;
#endif

	return dst;
}
  8012dd:	8b 34 24             	mov    (%esp),%esi
  8012e0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8012e4:	89 ec                	mov    %ebp,%esp
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    

008012e8 <memcmp>:

asmlinkage int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	57                   	push   %edi
  8012ec:	56                   	push   %esi
  8012ed:	53                   	push   %ebx
  8012ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f4:	8b 7d 10             	mov    0x10(%ebp),%edi
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  8012f7:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  8012fc:	85 ff                	test   %edi,%edi
  8012fe:	74 38                	je     801338 <memcmp+0x50>
		if (*s1 != *s2)
  801300:	0f b6 03             	movzbl (%ebx),%eax
  801303:	0f b6 0e             	movzbl (%esi),%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  801306:	83 ef 01             	sub    $0x1,%edi
  801309:	ba 00 00 00 00       	mov    $0x0,%edx
		if (*s1 != *s2)
  80130e:	38 c8                	cmp    %cl,%al
  801310:	74 1d                	je     80132f <memcmp+0x47>
  801312:	eb 11                	jmp    801325 <memcmp+0x3d>
  801314:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801319:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  80131e:	83 c2 01             	add    $0x1,%edx
  801321:	38 c8                	cmp    %cl,%al
  801323:	74 0a                	je     80132f <memcmp+0x47>
			return *s1 - *s2;
  801325:	0f b6 c0             	movzbl %al,%eax
  801328:	0f b6 c9             	movzbl %cl,%ecx
  80132b:	29 c8                	sub    %ecx,%eax
  80132d:	eb 09                	jmp    801338 <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const unsigned char *s1 = (const unsigned char *) v1;
	const unsigned char *s2 = (const unsigned char *) v2;

	while (n-- > 0) {
  80132f:	39 fa                	cmp    %edi,%edx
  801331:	75 e1                	jne    801314 <memcmp+0x2c>
		if (*s1 != *s2)
			return *s1 - *s2;
		s1++, s2++;
	}

	return 0;
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801338:	5b                   	pop    %ebx
  801339:	5e                   	pop    %esi
  80133a:	5f                   	pop    %edi
  80133b:	5d                   	pop    %ebp
  80133c:	c3                   	ret    

0080133d <memfind>:

asmlinkage void *
memfind(const void *v, int c, size_t n)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	53                   	push   %ebx
  801341:	8b 5d 08             	mov    0x8(%ebp),%ebx
	const unsigned char *s = (const unsigned char *) v;
  801344:	89 d8                	mov    %ebx,%eax
	const unsigned char *ends = s + n;
  801346:	89 da                	mov    %ebx,%edx
  801348:	03 55 10             	add    0x10(%ebp),%edx

	for (; s < ends; s++)
  80134b:	39 d3                	cmp    %edx,%ebx
  80134d:	73 15                	jae    801364 <memfind+0x27>
		if (*s == (unsigned char) c)
  80134f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801353:	38 0b                	cmp    %cl,(%ebx)
  801355:	75 06                	jne    80135d <memfind+0x20>
  801357:	eb 0b                	jmp    801364 <memfind+0x27>
  801359:	38 08                	cmp    %cl,(%eax)
  80135b:	74 07                	je     801364 <memfind+0x27>
memfind(const void *v, int c, size_t n)
{
	const unsigned char *s = (const unsigned char *) v;
	const unsigned char *ends = s + n;

	for (; s < ends; s++)
  80135d:	83 c0 01             	add    $0x1,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	77 f5                	ja     801359 <memfind+0x1c>
		if (*s == (unsigned char) c)
			break;
	return (void *) s;
}
  801364:	5b                   	pop    %ebx
  801365:	5d                   	pop    %ebp
  801366:	c3                   	ret    

00801367 <_Z6strtolPKcPPci>:

long
strtol(const char *s, char **endptr, int base)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	57                   	push   %edi
  80136b:	56                   	push   %esi
  80136c:	53                   	push   %ebx
  80136d:	8b 55 08             	mov    0x8(%ebp),%edx
  801370:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801373:	0f b6 02             	movzbl (%edx),%eax
  801376:	3c 20                	cmp    $0x20,%al
  801378:	74 04                	je     80137e <_Z6strtolPKcPPci+0x17>
  80137a:	3c 09                	cmp    $0x9,%al
  80137c:	75 0e                	jne    80138c <_Z6strtolPKcPPci+0x25>
		s++;
  80137e:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801381:	0f b6 02             	movzbl (%edx),%eax
  801384:	3c 20                	cmp    $0x20,%al
  801386:	74 f6                	je     80137e <_Z6strtolPKcPPci+0x17>
  801388:	3c 09                	cmp    $0x9,%al
  80138a:	74 f2                	je     80137e <_Z6strtolPKcPPci+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  80138c:	3c 2b                	cmp    $0x2b,%al
  80138e:	75 0a                	jne    80139a <_Z6strtolPKcPPci+0x33>
		s++;
  801390:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801393:	bf 00 00 00 00       	mov    $0x0,%edi
  801398:	eb 10                	jmp    8013aa <_Z6strtolPKcPPci+0x43>
  80139a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80139f:	3c 2d                	cmp    $0x2d,%al
  8013a1:	75 07                	jne    8013aa <_Z6strtolPKcPPci+0x43>
		s++, neg = 1;
  8013a3:	83 c2 01             	add    $0x1,%edx
  8013a6:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013aa:	85 db                	test   %ebx,%ebx
  8013ac:	0f 94 c0             	sete   %al
  8013af:	74 05                	je     8013b6 <_Z6strtolPKcPPci+0x4f>
  8013b1:	83 fb 10             	cmp    $0x10,%ebx
  8013b4:	75 15                	jne    8013cb <_Z6strtolPKcPPci+0x64>
  8013b6:	80 3a 30             	cmpb   $0x30,(%edx)
  8013b9:	75 10                	jne    8013cb <_Z6strtolPKcPPci+0x64>
  8013bb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8013bf:	75 0a                	jne    8013cb <_Z6strtolPKcPPci+0x64>
		s += 2, base = 16;
  8013c1:	83 c2 02             	add    $0x2,%edx
  8013c4:	bb 10 00 00 00       	mov    $0x10,%ebx
  8013c9:	eb 13                	jmp    8013de <_Z6strtolPKcPPci+0x77>
	else if (base == 0 && s[0] == '0')
  8013cb:	84 c0                	test   %al,%al
  8013cd:	74 0f                	je     8013de <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8013cf:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8013d4:	80 3a 30             	cmpb   $0x30,(%edx)
  8013d7:	75 05                	jne    8013de <_Z6strtolPKcPPci+0x77>
		s++, base = 8;
  8013d9:	83 c2 01             	add    $0x1,%edx
  8013dc:	b3 08                	mov    $0x8,%bl
	else if (base == 0)
		base = 10;
  8013de:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e3:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e5:	0f b6 0a             	movzbl (%edx),%ecx
  8013e8:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8013eb:	80 fb 09             	cmp    $0x9,%bl
  8013ee:	77 08                	ja     8013f8 <_Z6strtolPKcPPci+0x91>
			dig = *s - '0';
  8013f0:	0f be c9             	movsbl %cl,%ecx
  8013f3:	83 e9 30             	sub    $0x30,%ecx
  8013f6:	eb 1e                	jmp    801416 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'a' && *s <= 'z')
  8013f8:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8013fb:	80 fb 19             	cmp    $0x19,%bl
  8013fe:	77 08                	ja     801408 <_Z6strtolPKcPPci+0xa1>
			dig = *s - 'a' + 10;
  801400:	0f be c9             	movsbl %cl,%ecx
  801403:	83 e9 57             	sub    $0x57,%ecx
  801406:	eb 0e                	jmp    801416 <_Z6strtolPKcPPci+0xaf>
		else if (*s >= 'A' && *s <= 'Z')
  801408:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  80140b:	80 fb 19             	cmp    $0x19,%bl
  80140e:	77 15                	ja     801425 <_Z6strtolPKcPPci+0xbe>
			dig = *s - 'A' + 10;
  801410:	0f be c9             	movsbl %cl,%ecx
  801413:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801416:	39 f1                	cmp    %esi,%ecx
  801418:	7d 0f                	jge    801429 <_Z6strtolPKcPPci+0xc2>
			break;
		s++, val = (val * base) + dig;
  80141a:	83 c2 01             	add    $0x1,%edx
  80141d:	0f af c6             	imul   %esi,%eax
  801420:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		s++, base = 8;
	else if (base == 0)
		base = 10;

	// digits
	while (1) {
  801423:	eb c0                	jmp    8013e5 <_Z6strtolPKcPPci+0x7e>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  801425:	89 c1                	mov    %eax,%ecx
  801427:	eb 02                	jmp    80142b <_Z6strtolPKcPPci+0xc4>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801429:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80142b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142f:	74 05                	je     801436 <_Z6strtolPKcPPci+0xcf>
		*endptr = (char *) s;
  801431:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801434:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801436:	89 ca                	mov    %ecx,%edx
  801438:	f7 da                	neg    %edx
  80143a:	85 ff                	test   %edi,%edi
  80143c:	0f 45 c2             	cmovne %edx,%eax
}
  80143f:	5b                   	pop    %ebx
  801440:	5e                   	pop    %esi
  801441:	5f                   	pop    %edi
  801442:	5d                   	pop    %ebp
  801443:	c3                   	ret    

00801444 <_Z9sys_cputsPKcj>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	89 1c 24             	mov    %ebx,(%esp)
  80144d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801451:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801455:	b8 00 00 00 00       	mov    $0x0,%eax
  80145a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	89 c3                	mov    %eax,%ebx
  801462:	89 c7                	mov    %eax,%edi
  801464:	89 c6                	mov    %eax,%esi
  801466:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801468:	8b 1c 24             	mov    (%esp),%ebx
  80146b:	8b 74 24 04          	mov    0x4(%esp),%esi
  80146f:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801473:	89 ec                	mov    %ebp,%esp
  801475:	5d                   	pop    %ebp
  801476:	c3                   	ret    

00801477 <_Z9sys_cgetcv>:

int
sys_cgetc(void)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 0c             	sub    $0xc,%esp
  80147d:	89 1c 24             	mov    %ebx,(%esp)
  801480:	89 74 24 04          	mov    %esi,0x4(%esp)
  801484:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801488:	ba 00 00 00 00       	mov    $0x0,%edx
  80148d:	b8 01 00 00 00       	mov    $0x1,%eax
  801492:	89 d1                	mov    %edx,%ecx
  801494:	89 d3                	mov    %edx,%ebx
  801496:	89 d7                	mov    %edx,%edi
  801498:	89 d6                	mov    %edx,%esi
  80149a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80149c:	8b 1c 24             	mov    (%esp),%ebx
  80149f:	8b 74 24 04          	mov    0x4(%esp),%esi
  8014a3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8014a7:	89 ec                	mov    %ebp,%esp
  8014a9:	5d                   	pop    %ebp
  8014aa:	c3                   	ret    

008014ab <_Z15sys_env_destroyi>:

int
sys_env_destroy(envid_t envid)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 38             	sub    $0x38,%esp
  8014b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8014ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014bf:	b8 03 00 00 00       	mov    $0x3,%eax
  8014c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c7:	89 cb                	mov    %ecx,%ebx
  8014c9:	89 cf                	mov    %ecx,%edi
  8014cb:	89 ce                	mov    %ecx,%esi
  8014cd:	cd 30                	int    $0x30

	if(check && ret > 0)
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	7e 28                	jle    8014fb <_Z15sys_env_destroyi+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014d7:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8014de:	00 
  8014df:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  8014e6:	00 
  8014e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014ee:	00 
  8014ef:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  8014f6:	e8 59 f4 ff ff       	call   800954 <_Z6_panicPKciS0_z>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8014fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801501:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801504:	89 ec                	mov    %ebp,%esp
  801506:	5d                   	pop    %ebp
  801507:	c3                   	ret    

00801508 <_Z12sys_getenvidv>:

envid_t
sys_getenvid(void)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 0c             	sub    $0xc,%esp
  80150e:	89 1c 24             	mov    %ebx,(%esp)
  801511:	89 74 24 04          	mov    %esi,0x4(%esp)
  801515:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801519:	ba 00 00 00 00       	mov    $0x0,%edx
  80151e:	b8 02 00 00 00       	mov    $0x2,%eax
  801523:	89 d1                	mov    %edx,%ecx
  801525:	89 d3                	mov    %edx,%ebx
  801527:	89 d7                	mov    %edx,%edi
  801529:	89 d6                	mov    %edx,%esi
  80152b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80152d:	8b 1c 24             	mov    (%esp),%ebx
  801530:	8b 74 24 04          	mov    0x4(%esp),%esi
  801534:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801538:	89 ec                	mov    %ebp,%esp
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    

0080153c <_Z9sys_yieldv>:

void
sys_yield(void)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 0c             	sub    $0xc,%esp
  801542:	89 1c 24             	mov    %ebx,(%esp)
  801545:	89 74 24 04          	mov    %esi,0x4(%esp)
  801549:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80154d:	ba 00 00 00 00       	mov    $0x0,%edx
  801552:	b8 04 00 00 00       	mov    $0x4,%eax
  801557:	89 d1                	mov    %edx,%ecx
  801559:	89 d3                	mov    %edx,%ebx
  80155b:	89 d7                	mov    %edx,%edi
  80155d:	89 d6                	mov    %edx,%esi
  80155f:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801561:	8b 1c 24             	mov    (%esp),%ebx
  801564:	8b 74 24 04          	mov    0x4(%esp),%esi
  801568:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80156c:	89 ec                	mov    %ebp,%esp
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <_Z14sys_page_allociPvi>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 38             	sub    $0x38,%esp
  801576:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801579:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80157c:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80157f:	be 00 00 00 00       	mov    $0x0,%esi
  801584:	b8 08 00 00 00       	mov    $0x8,%eax
  801589:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80158c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80158f:	8b 55 08             	mov    0x8(%ebp),%edx
  801592:	89 f7                	mov    %esi,%edi
  801594:	cd 30                	int    $0x30

	if(check && ret > 0)
  801596:	85 c0                	test   %eax,%eax
  801598:	7e 28                	jle    8015c2 <_Z14sys_page_allociPvi+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  80159a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80159e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8015a5:	00 
  8015a6:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  8015ad:	00 
  8015ae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015b5:	00 
  8015b6:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  8015bd:	e8 92 f3 ff ff       	call   800954 <_Z6_panicPKciS0_z>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8015c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015c5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015cb:	89 ec                	mov    %ebp,%esp
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <_Z12sys_page_mapiPviS_i>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 38             	sub    $0x38,%esp
  8015d5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015d8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015db:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8015de:	b8 09 00 00 00       	mov    $0x9,%eax
  8015e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8015e6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f2:	cd 30                	int    $0x30

	if(check && ret > 0)
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	7e 28                	jle    801620 <_Z12sys_page_mapiPviS_i+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015fc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801603:	00 
  801604:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  80160b:	00 
  80160c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801613:	00 
  801614:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  80161b:	e8 34 f3 ff ff       	call   800954 <_Z6_panicPKciS0_z>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801620:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801623:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801626:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801629:	89 ec                	mov    %ebp,%esp
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    

0080162d <_Z14sys_page_unmapiPv>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 38             	sub    $0x38,%esp
  801633:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801636:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801639:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801641:	b8 0a 00 00 00       	mov    $0xa,%eax
  801646:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801649:	8b 55 08             	mov    0x8(%ebp),%edx
  80164c:	89 df                	mov    %ebx,%edi
  80164e:	89 de                	mov    %ebx,%esi
  801650:	cd 30                	int    $0x30

	if(check && ret > 0)
  801652:	85 c0                	test   %eax,%eax
  801654:	7e 28                	jle    80167e <_Z14sys_page_unmapiPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801656:	89 44 24 10          	mov    %eax,0x10(%esp)
  80165a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801661:	00 
  801662:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  801669:	00 
  80166a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801671:	00 
  801672:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  801679:	e8 d6 f2 ff ff       	call   800954 <_Z6_panicPKciS0_z>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80167e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801681:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801684:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801687:	89 ec                	mov    %ebp,%esp
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    

0080168b <_Z18sys_env_set_statusii>:

int
sys_env_set_status(envid_t envid, int status)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 38             	sub    $0x38,%esp
  801691:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801694:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801697:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80169a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80169f:	b8 05 00 00 00       	mov    $0x5,%eax
  8016a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8016aa:	89 df                	mov    %ebx,%edi
  8016ac:	89 de                	mov    %ebx,%esi
  8016ae:	cd 30                	int    $0x30

	if(check && ret > 0)
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	7e 28                	jle    8016dc <_Z18sys_env_set_statusii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016b4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016b8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8016bf:	00 
  8016c0:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  8016c7:	00 
  8016c8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016cf:	00 
  8016d0:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  8016d7:	e8 78 f2 ff ff       	call   800954 <_Z6_panicPKciS0_z>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8016dc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016df:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016e5:	89 ec                	mov    %ebp,%esp
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <_Z20sys_env_set_priorityii>:

int
sys_env_set_priority(envid_t envid, int priority)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 38             	sub    $0x38,%esp
  8016ef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016f2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016f5:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8016f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016fd:	b8 06 00 00 00       	mov    $0x6,%eax
  801702:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801705:	8b 55 08             	mov    0x8(%ebp),%edx
  801708:	89 df                	mov    %ebx,%edi
  80170a:	89 de                	mov    %ebx,%esi
  80170c:	cd 30                	int    $0x30

	if(check && ret > 0)
  80170e:	85 c0                	test   %eax,%eax
  801710:	7e 28                	jle    80173a <_Z20sys_env_set_priorityii+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801712:	89 44 24 10          	mov    %eax,0x10(%esp)
  801716:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80171d:	00 
  80171e:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  801725:	00 
  801726:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80172d:	00 
  80172e:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  801735:	e8 1a f2 ff ff       	call   800954 <_Z6_panicPKciS0_z>

int
sys_env_set_priority(envid_t envid, int priority)
{
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80173a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80173d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801740:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801743:	89 ec                	mov    %ebp,%esp
  801745:	5d                   	pop    %ebp
  801746:	c3                   	ret    

00801747 <_Z21sys_env_set_trapframeiP9Trapframe>:

// sys_exofork is inlined in lib.h

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 38             	sub    $0x38,%esp
  80174d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801750:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801753:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801756:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801760:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801763:	8b 55 08             	mov    0x8(%ebp),%edx
  801766:	89 df                	mov    %ebx,%edi
  801768:	89 de                	mov    %ebx,%esi
  80176a:	cd 30                	int    $0x30

	if(check && ret > 0)
  80176c:	85 c0                	test   %eax,%eax
  80176e:	7e 28                	jle    801798 <_Z21sys_env_set_trapframeiP9Trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801770:	89 44 24 10          	mov    %eax,0x10(%esp)
  801774:	c7 44 24 0c 0b 00 00 	movl   $0xb,0xc(%esp)
  80177b:	00 
  80177c:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  801783:	00 
  801784:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80178b:	00 
  80178c:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  801793:	e8 bc f1 ff ff       	call   800954 <_Z6_panicPKciS0_z>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801798:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80179b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80179e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017a1:	89 ec                	mov    %ebp,%esp
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    

008017a5 <_Z26sys_env_set_pgfault_upcalliPv>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 38             	sub    $0x38,%esp
  8017ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8017b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8017be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c4:	89 df                	mov    %ebx,%edi
  8017c6:	89 de                	mov    %ebx,%esi
  8017c8:	cd 30                	int    $0x30

	if(check && ret > 0)
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	7e 28                	jle    8017f6 <_Z26sys_env_set_pgfault_upcalliPv+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017d2:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
  8017d9:	00 
  8017da:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  8017e1:	00 
  8017e2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017e9:	00 
  8017ea:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  8017f1:	e8 5e f1 ff ff       	call   800954 <_Z6_panicPKciS0_z>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8017f6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017f9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017fc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017ff:	89 ec                	mov    %ebp,%esp
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    

00801803 <_Z16sys_ipc_try_sendijPvi>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	89 1c 24             	mov    %ebx,(%esp)
  80180c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801810:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801814:	be 00 00 00 00       	mov    $0x0,%esi
  801819:	b8 0d 00 00 00       	mov    $0xd,%eax
  80181e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801821:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801824:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801827:	8b 55 08             	mov    0x8(%ebp),%edx
  80182a:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80182c:	8b 1c 24             	mov    (%esp),%ebx
  80182f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801833:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801837:	89 ec                	mov    %ebp,%esp
  801839:	5d                   	pop    %ebp
  80183a:	c3                   	ret    

0080183b <_Z12sys_ipc_recvPv>:

int
sys_ipc_recv(void *dstva)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 38             	sub    $0x38,%esp
  801841:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801844:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801847:	89 7d fc             	mov    %edi,-0x4(%ebp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80184a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80184f:	b8 0e 00 00 00       	mov    $0xe,%eax
  801854:	8b 55 08             	mov    0x8(%ebp),%edx
  801857:	89 cb                	mov    %ecx,%ebx
  801859:	89 cf                	mov    %ecx,%edi
  80185b:	89 ce                	mov    %ecx,%esi
  80185d:	cd 30                	int    $0x30

	if(check && ret > 0)
  80185f:	85 c0                	test   %eax,%eax
  801861:	7e 28                	jle    80188b <_Z12sys_ipc_recvPv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801863:	89 44 24 10          	mov    %eax,0x10(%esp)
  801867:	c7 44 24 0c 0e 00 00 	movl   $0xe,0xc(%esp)
  80186e:	00 
  80186f:	c7 44 24 08 54 4b 80 	movl   $0x804b54,0x8(%esp)
  801876:	00 
  801877:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80187e:	00 
  80187f:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  801886:	e8 c9 f0 ff ff       	call   800954 <_Z6_panicPKciS0_z>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80188b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80188e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801891:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801894:	89 ec                	mov    %ebp,%esp
  801896:	5d                   	pop    %ebp
  801897:	c3                   	ret    

00801898 <_Z18sys_program_lookupPKcj>:

int
sys_program_lookup(const char *name, size_t len)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 0c             	sub    $0xc,%esp
  80189e:	89 1c 24             	mov    %ebx,(%esp)
  8018a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018a5:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8018a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ae:	b8 0f 00 00 00       	mov    $0xf,%eax
  8018b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b9:	89 df                	mov    %ebx,%edi
  8018bb:	89 de                	mov    %ebx,%esi
  8018bd:	cd 30                	int    $0x30

int
sys_program_lookup(const char *name, size_t len)
{
	return syscall(SYS_program_lookup, 0, (uintptr_t) name, len, 0, 0, 0);
}
  8018bf:	8b 1c 24             	mov    (%esp),%ebx
  8018c2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8018c6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8018ca:	89 ec                	mov    %ebp,%esp
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    

008018ce <_Z13sys_time_msecv>:

uint32_t
sys_time_msec(void)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 0c             	sub    $0xc,%esp
  8018d4:	89 1c 24             	mov    %ebx,(%esp)
  8018d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018db:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	b8 11 00 00 00       	mov    $0x11,%eax
  8018e9:	89 d1                	mov    %edx,%ecx
  8018eb:	89 d3                	mov    %edx,%ebx
  8018ed:	89 d7                	mov    %edx,%edi
  8018ef:	89 d6                	mov    %edx,%esi
  8018f1:	cd 30                	int    $0x30

uint32_t
sys_time_msec(void)
{
    return syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8018f3:	8b 1c 24             	mov    (%esp),%ebx
  8018f6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8018fa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8018fe:	89 ec                	mov    %ebp,%esp
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <_Z18sys_e1000_transmitPvj>:

int
sys_e1000_transmit(void *buffer, size_t len)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 0c             	sub    $0xc,%esp
  801908:	89 1c 24             	mov    %ebx,(%esp)
  80190b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80190f:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801913:	bb 00 00 00 00       	mov    $0x0,%ebx
  801918:	b8 12 00 00 00       	mov    $0x12,%eax
  80191d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801920:	8b 55 08             	mov    0x8(%ebp),%edx
  801923:	89 df                	mov    %ebx,%edi
  801925:	89 de                	mov    %ebx,%esi
  801927:	cd 30                	int    $0x30

int
sys_e1000_transmit(void *buffer, size_t len)
{
    return syscall(SYS_e1000_transmit, 0, (uint32_t)buffer, (uint32_t)len, 0, 0, 0);
}
  801929:	8b 1c 24             	mov    (%esp),%ebx
  80192c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801930:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801934:	89 ec                	mov    %ebp,%esp
  801936:	5d                   	pop    %ebp
  801937:	c3                   	ret    

00801938 <_Z17sys_e1000_receivePv>:

size_t
sys_e1000_receive(void *buffer)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 0c             	sub    $0xc,%esp
  80193e:	89 1c 24             	mov    %ebx,(%esp)
  801941:	89 74 24 04          	mov    %esi,0x4(%esp)
  801945:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  801949:	b9 00 00 00 00       	mov    $0x0,%ecx
  80194e:	b8 13 00 00 00       	mov    $0x13,%eax
  801953:	8b 55 08             	mov    0x8(%ebp),%edx
  801956:	89 cb                	mov    %ecx,%ebx
  801958:	89 cf                	mov    %ecx,%edi
  80195a:	89 ce                	mov    %ecx,%esi
  80195c:	cd 30                	int    $0x30

size_t
sys_e1000_receive(void *buffer)
{
    return syscall(SYS_e1000_receive, 0, (uint32_t)buffer, 0, 0, 0, 0);
}
  80195e:	8b 1c 24             	mov    (%esp),%ebx
  801961:	8b 74 24 04          	mov    0x4(%esp),%esi
  801965:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801969:	89 ec                	mov    %ebp,%esp
  80196b:	5d                   	pop    %ebp
  80196c:	c3                   	ret    

0080196d <_Z16sys_program_readiPvijj>:

ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 0c             	sub    $0xc,%esp
  801973:	89 1c 24             	mov    %ebx,(%esp)
  801976:	89 74 24 04          	mov    %esi,0x4(%esp)
  80197a:	89 7c 24 08          	mov    %edi,0x8(%esp)
		  "d" (a1),
		  "c" (a2),
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
  80197e:	b8 10 00 00 00       	mov    $0x10,%eax
  801983:	8b 75 18             	mov    0x18(%ebp),%esi
  801986:	8b 7d 14             	mov    0x14(%ebp),%edi
  801989:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80198c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80198f:	8b 55 08             	mov    0x8(%ebp),%edx
  801992:	cd 30                	int    $0x30
ssize_t
sys_program_read(envid_t dst_env, void *va,
		 int programid, size_t offset, size_t len)
{
	return syscall(SYS_program_read, 0, dst_env, (uintptr_t) va, programid, offset, len);
}
  801994:	8b 1c 24             	mov    (%esp),%ebx
  801997:	8b 74 24 04          	mov    0x4(%esp),%esi
  80199b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80199f:	89 ec                	mov    %ebp,%esp
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    
	...

008019b0 <_Z8ipc_recvPiPvS_>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	56                   	push   %esi
  8019b4:	53                   	push   %ebx
  8019b5:	83 ec 10             	sub    $0x10,%esp
  8019b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8019bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019be:	8b 75 10             	mov    0x10(%ebp),%esi
    int ret;
    
    // UTOP is above the valid region for ipc mapping
    if (pg == NULL)
        pg = (void *)UTOP;
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	ba 00 00 00 ef       	mov    $0xef000000,%edx
  8019c8:	0f 44 c2             	cmove  %edx,%eax

    // if there is an error in receiving, null everything out and return
    if ((ret = sys_ipc_recv(pg)) < 0)
  8019cb:	89 04 24             	mov    %eax,(%esp)
  8019ce:	e8 68 fe ff ff       	call   80183b <_Z12sys_ipc_recvPv>
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	79 16                	jns    8019ed <_Z8ipc_recvPiPvS_+0x3d>
    {
        if(from_env_store)
  8019d7:	85 db                	test   %ebx,%ebx
  8019d9:	74 06                	je     8019e1 <_Z8ipc_recvPiPvS_+0x31>
            *from_env_store = 0;
  8019db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        if(perm_store)
  8019e1:	85 f6                	test   %esi,%esi
  8019e3:	74 53                	je     801a38 <_Z8ipc_recvPiPvS_+0x88>
            *perm_store = 0;
  8019e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8019eb:	eb 4b                	jmp    801a38 <_Z8ipc_recvPiPvS_+0x88>
        return ret;
    }

    // else set env_store and perm_store to the proper return values, and 
    // return the sent value
    if(from_env_store)
  8019ed:	85 db                	test   %ebx,%ebx
  8019ef:	74 17                	je     801a08 <_Z8ipc_recvPiPvS_+0x58>
        *from_env_store = THISENV->env_ipc_from;
  8019f1:	e8 12 fb ff ff       	call   801508 <_Z12sys_getenvidv>
  8019f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8019fb:	6b c0 78             	imul   $0x78,%eax,%eax
  8019fe:	05 0c 00 00 ef       	add    $0xef00000c,%eax
  801a03:	8b 40 60             	mov    0x60(%eax),%eax
  801a06:	89 03                	mov    %eax,(%ebx)
    if(perm_store)
  801a08:	85 f6                	test   %esi,%esi
  801a0a:	74 17                	je     801a23 <_Z8ipc_recvPiPvS_+0x73>
        *perm_store = THISENV->env_ipc_perm;
  801a0c:	e8 f7 fa ff ff       	call   801508 <_Z12sys_getenvidv>
  801a11:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a16:	6b c0 78             	imul   $0x78,%eax,%eax
  801a19:	05 00 00 00 ef       	add    $0xef000000,%eax
  801a1e:	8b 40 70             	mov    0x70(%eax),%eax
  801a21:	89 06                	mov    %eax,(%esi)
    return THISENV->env_ipc_value;
  801a23:	e8 e0 fa ff ff       	call   801508 <_Z12sys_getenvidv>
  801a28:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a2d:	6b c0 78             	imul   $0x78,%eax,%eax
  801a30:	05 08 00 00 ef       	add    $0xef000008,%eax
  801a35:	8b 40 60             	mov    0x60(%eax),%eax

}
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <_Z8ipc_sendijPvi>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	57                   	push   %edi
  801a43:	56                   	push   %esi
  801a44:	53                   	push   %ebx
  801a45:	83 ec 1c             	sub    $0x1c,%esp
  801a48:	8b 75 08             	mov    0x8(%ebp),%esi
  801a4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// UTOP is above the valid region for ipc mapping
    if (pg == NULL)
  801a51:	85 db                	test   %ebx,%ebx
        pg = (void *) UTOP;
  801a53:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  801a58:	0f 44 d8             	cmove  %eax,%ebx

    int ret;

    // continue until the message is sent
    while (true)
        if ((ret = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  801a5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a62:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a66:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a6a:	89 34 24             	mov    %esi,(%esp)
  801a6d:	e8 91 fd ff ff       	call   801803 <_Z16sys_ipc_try_sendijPvi>
  801a72:	85 c0                	test   %eax,%eax
  801a74:	79 31                	jns    801aa7 <_Z8ipc_sendijPvi+0x68>
        {
            // yield, since we don't know how long it will take for
            // the other environment to wait for a message
            if (ret == -E_IPC_NOT_RECV)
  801a76:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a79:	75 0c                	jne    801a87 <_Z8ipc_sendijPvi+0x48>
            {
                sys_yield();
  801a7b:	90                   	nop
  801a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801a80:	e8 b7 fa ff ff       	call   80153c <_Z9sys_yieldv>
  801a85:	eb d4                	jmp    801a5b <_Z8ipc_sendijPvi+0x1c>
            }
            else
                panic("ipc_send: %e", ret);
  801a87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a8b:	c7 44 24 08 7f 4b 80 	movl   $0x804b7f,0x8(%esp)
  801a92:	00 
  801a93:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801a9a:	00 
  801a9b:	c7 04 24 8c 4b 80 00 	movl   $0x804b8c,(%esp)
  801aa2:	e8 ad ee ff ff       	call   800954 <_Z6_panicPKciS0_z>
        }
        else
            return;    
}
  801aa7:	83 c4 1c             	add    $0x1c,%esp
  801aaa:	5b                   	pop    %ebx
  801aab:	5e                   	pop    %esi
  801aac:	5f                   	pop    %edi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
	...

00801ab0 <_ZL8fd_validPK2Fd>:

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801ab3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801ab8:	75 11                	jne    801acb <_ZL8fd_validPK2Fd+0x1b>
  801aba:	3d ff ff ff cf       	cmp    $0xcfffffff,%eax
  801abf:	76 0a                	jbe    801acb <_ZL8fd_validPK2Fd+0x1b>
}

// Return true iff 'fd' is a valid file descriptor pointer.
//
static bool
fd_valid(const struct Fd *fd)
  801ac1:	3d ff ff 01 d0       	cmp    $0xd001ffff,%eax
  801ac6:	0f 96 c0             	setbe  %al
  801ac9:	eb 05                	jmp    801ad0 <_ZL8fd_validPK2Fd+0x20>
{
	return PGOFF(fd) == 0 && fd >= (const struct Fd *) FDTABLE
		&& fd < (const struct Fd *) (FDTABLE + NFD * PGSIZE);
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad0:	5d                   	pop    %ebp
  801ad1:	c3                   	ret    

00801ad2 <_ZL9fd_isopenPK2Fd>:

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	53                   	push   %ebx
  801ad6:	83 ec 14             	sub    $0x14,%esp
  801ad9:	89 c3                	mov    %eax,%ebx
	assert(fd_valid(fd));
  801adb:	e8 d0 ff ff ff       	call   801ab0 <_ZL8fd_validPK2Fd>
  801ae0:	84 c0                	test   %al,%al
  801ae2:	75 24                	jne    801b08 <_ZL9fd_isopenPK2Fd+0x36>
  801ae4:	c7 44 24 0c 96 4b 80 	movl   $0x804b96,0xc(%esp)
  801aeb:	00 
  801aec:	c7 44 24 08 fd 46 80 	movl   $0x8046fd,0x8(%esp)
  801af3:	00 
  801af4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801afb:	00 
  801afc:	c7 04 24 a3 4b 80 00 	movl   $0x804ba3,(%esp)
  801b03:	e8 4c ee ff ff       	call   800954 <_Z6_panicPKciS0_z>
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
  801b08:	89 d8                	mov    %ebx,%eax
  801b0a:	c1 e8 16             	shr    $0x16,%eax
  801b0d:	8b 14 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%edx
  801b14:	b8 00 00 00 00       	mov    $0x0,%eax
  801b19:	f6 c2 01             	test   $0x1,%dl
  801b1c:	74 0d                	je     801b2b <_ZL9fd_isopenPK2Fd+0x59>
  801b1e:	c1 eb 0c             	shr    $0xc,%ebx
  801b21:	8b 04 9d 00 00 80 ef 	mov    -0x10800000(,%ebx,4),%eax
}

// Return true iff 'fd' is currently open.
//
static bool
fd_isopen(const struct Fd *fd)
  801b28:	83 e0 01             	and    $0x1,%eax
{
	assert(fd_valid(fd));
	return (vpd[PDX(fd)] & PTE_P) && (vpt[PGNUM(fd)] & PTE_P);
}
  801b2b:	83 c4 14             	add    $0x14,%esp
  801b2e:	5b                   	pop    %ebx
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    

00801b31 <_Z9fd_lookupiPP2Fdb>:
// or NULL is returned.
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 08             	sub    $0x8,%esp
  801b37:	89 1c 24             	mov    %ebx,(%esp)
  801b3a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b41:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b44:	0f b6 45 10          	movzbl 0x10(%ebp),%eax
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801b48:	83 fb 1f             	cmp    $0x1f,%ebx
  801b4b:	77 18                	ja     801b65 <_Z9fd_lookupiPP2Fdb+0x34>
// Returns 0 on success, < 0 error code on failure.
//
int
fd_lookup(int fdnum, struct Fd **fd_store, bool must_exist)
{
	struct Fd *fd = (struct Fd *) (FDTABLE + fdnum * PGSIZE);
  801b4d:	81 c3 00 00 0d 00    	add    $0xd0000,%ebx
  801b53:	c1 e3 0c             	shl    $0xc,%ebx

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
  801b56:	84 c0                	test   %al,%al
  801b58:	74 21                	je     801b7b <_Z9fd_lookupiPP2Fdb+0x4a>
  801b5a:	89 d8                	mov    %ebx,%eax
  801b5c:	e8 71 ff ff ff       	call   801ad2 <_ZL9fd_isopenPK2Fd>
  801b61:	84 c0                	test   %al,%al
  801b63:	75 16                	jne    801b7b <_Z9fd_lookupiPP2Fdb+0x4a>
		*fd_store = 0;
  801b65:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return -E_INVAL;
  801b6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	} else {
		*fd_store = fd;
		return 0;
	}
}
  801b70:	8b 1c 24             	mov    (%esp),%ebx
  801b73:	8b 74 24 04          	mov    0x4(%esp),%esi
  801b77:	89 ec                	mov    %ebp,%esp
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    

	if (fdnum < 0 || fdnum >= NFD || (must_exist && !fd_isopen(fd))) {
		*fd_store = 0;
		return -E_INVAL;
	} else {
		*fd_store = fd;
  801b7b:	89 1e                	mov    %ebx,(%esi)
		return 0;
  801b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b82:	eb ec                	jmp    801b70 <_Z9fd_lookupiPP2Fdb+0x3f>

00801b84 <_Z6fd2numP2Fd>:

// Return the file descriptor number for a 'struct Fd'.
//
int
fd2num(struct Fd *fd)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	53                   	push   %ebx
  801b88:	83 ec 14             	sub    $0x14,%esp
  801b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(fd_valid(fd));
  801b8e:	89 d8                	mov    %ebx,%eax
  801b90:	e8 1b ff ff ff       	call   801ab0 <_ZL8fd_validPK2Fd>
  801b95:	84 c0                	test   %al,%al
  801b97:	75 24                	jne    801bbd <_Z6fd2numP2Fd+0x39>
  801b99:	c7 44 24 0c 96 4b 80 	movl   $0x804b96,0xc(%esp)
  801ba0:	00 
  801ba1:	c7 44 24 08 fd 46 80 	movl   $0x8046fd,0x8(%esp)
  801ba8:	00 
  801ba9:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801bb0:	00 
  801bb1:	c7 04 24 a3 4b 80 00 	movl   $0x804ba3,(%esp)
  801bb8:	e8 97 ed ff ff       	call   800954 <_Z6_panicPKciS0_z>
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801bbd:	8d 83 00 00 00 30    	lea    0x30000000(%ebx),%eax
  801bc3:	c1 e8 0c             	shr    $0xc,%eax
}
  801bc6:	83 c4 14             	add    $0x14,%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    

00801bcc <_Z7fd2dataP2Fd>:

// Return the file descriptor data pointer for a 'struct Fd'.
//
char *
fd2data(struct Fd *fd)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 18             	sub    $0x18,%esp
	int num = fd2num(fd);
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	89 04 24             	mov    %eax,(%esp)
  801bd8:	e8 a7 ff ff ff       	call   801b84 <_Z6fd2numP2Fd>
	return (char *) (FDDATA + num * PGSIZE);
  801bdd:	05 20 00 0d 00       	add    $0xd0020,%eax
  801be2:	c1 e0 0c             	shl    $0xc,%eax
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <_Z14fd_find_unusedPP2Fd>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_find_unused(struct Fd **fd_store)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	57                   	push   %edi
  801beb:	56                   	push   %esi
  801bec:	53                   	push   %ebx
  801bed:	83 ec 2c             	sub    $0x2c,%esp
  801bf0:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801bf3:	bb 00 00 00 00       	mov    $0x0,%ebx
		(void) fd_lookup(i, &fd, false);
  801bf8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  801bfb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c02:	00 
  801c03:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c07:	89 1c 24             	mov    %ebx,(%esp)
  801c0a:	e8 22 ff ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
		if (!fd_isopen(fd)) {
  801c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c12:	e8 bb fe ff ff       	call   801ad2 <_ZL9fd_isopenPK2Fd>
  801c17:	84 c0                	test   %al,%al
  801c19:	75 0c                	jne    801c27 <_Z14fd_find_unusedPP2Fd+0x40>
			*fd_store = fd;
  801c1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c1e:	89 07                	mov    %eax,(%edi)
			return 0;
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
  801c25:	eb 13                	jmp    801c3a <_Z14fd_find_unusedPP2Fd+0x53>
fd_find_unused(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < NFD; i++) {
  801c27:	83 c3 01             	add    $0x1,%ebx
  801c2a:	83 fb 20             	cmp    $0x20,%ebx
  801c2d:	75 cc                	jne    801bfb <_Z14fd_find_unusedPP2Fd+0x14>
		if (!fd_isopen(fd)) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c2f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801c35:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c3a:	83 c4 2c             	add    $0x2c,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5e                   	pop    %esi
  801c3f:	5f                   	pop    %edi
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    

00801c42 <_Z10dev_lookupiPP3Dev>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	53                   	push   %ebx
  801c46:	83 ec 14             	sub    $0x14,%esp
  801c49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
  801c4f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (devtab[i]->dev_id == dev_id) {
  801c54:	39 0d 08 60 80 00    	cmp    %ecx,0x806008
  801c5a:	75 16                	jne    801c72 <_Z10dev_lookupiPP3Dev+0x30>
  801c5c:	eb 06                	jmp    801c64 <_Z10dev_lookupiPP3Dev+0x22>
  801c5e:	39 0a                	cmp    %ecx,(%edx)
  801c60:	75 10                	jne    801c72 <_Z10dev_lookupiPP3Dev+0x30>
  801c62:	eb 05                	jmp    801c69 <_Z10dev_lookupiPP3Dev+0x27>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c64:	ba 08 60 80 00       	mov    $0x806008,%edx
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801c69:	89 13                	mov    %edx,(%ebx)
			return 0;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c70:	eb 35                	jmp    801ca7 <_Z10dev_lookupiPP3Dev+0x65>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c72:	83 c0 01             	add    $0x1,%eax
  801c75:	8b 14 85 0c 4c 80 00 	mov    0x804c0c(,%eax,4),%edx
  801c7c:	85 d2                	test   %edx,%edx
  801c7e:	75 de                	jne    801c5e <_Z10dev_lookupiPP3Dev+0x1c>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c80:	a1 00 70 80 00       	mov    0x807000,%eax
  801c85:	8b 40 04             	mov    0x4(%eax),%eax
  801c88:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c90:	c7 04 24 c8 4b 80 00 	movl   $0x804bc8,(%esp)
  801c97:	e8 d6 ed ff ff       	call   800a72 <_Z7cprintfPKcz>
	*dev = 0;
  801c9c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801ca2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ca7:	83 c4 14             	add    $0x14,%esp
  801caa:	5b                   	pop    %ebx
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    

00801cad <_Z8fd_closeP2Fdb>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	56                   	push   %esi
  801cb1:	53                   	push   %ebx
  801cb2:	83 ec 20             	sub    $0x20,%esp
  801cb5:	8b 75 08             	mov    0x8(%ebp),%esi
  801cb8:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
  801cbc:	89 34 24             	mov    %esi,(%esp)
  801cbf:	e8 c0 fe ff ff       	call   801b84 <_Z6fd2numP2Fd>
  801cc4:	0f b6 d3             	movzbl %bl,%edx
  801cc7:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ccb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801cce:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cd2:	89 04 24             	mov    %eax,(%esp)
  801cd5:	e8 57 fe ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	78 05                	js     801ce3 <_Z8fd_closeP2Fdb+0x36>
  801cde:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801ce1:	74 0c                	je     801cef <_Z8fd_closeP2Fdb+0x42>
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
  801ce3:	80 fb 01             	cmp    $0x1,%bl
  801ce6:	19 db                	sbb    %ebx,%ebx
  801ce8:	f7 d3                	not    %ebx
  801cea:	83 e3 fd             	and    $0xfffffffd,%ebx
  801ced:	eb 3d                	jmp    801d2c <_Z8fd_closeP2Fdb+0x7f>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf6:	8b 06                	mov    (%esi),%eax
  801cf8:	89 04 24             	mov    %eax,(%esp)
  801cfb:	e8 42 ff ff ff       	call   801c42 <_Z10dev_lookupiPP3Dev>
  801d00:	89 c3                	mov    %eax,%ebx
  801d02:	85 c0                	test   %eax,%eax
  801d04:	78 16                	js     801d1c <_Z8fd_closeP2Fdb+0x6f>
		if (dev->dev_close)
  801d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d09:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801d0c:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2, must_exist)) < 0
	    || fd != fd2)
		return (must_exist ? -E_INVAL : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801d11:	85 c0                	test   %eax,%eax
  801d13:	74 07                	je     801d1c <_Z8fd_closeP2Fdb+0x6f>
			r = (*dev->dev_close)(fd);
  801d15:	89 34 24             	mov    %esi,(%esp)
  801d18:	ff d0                	call   *%eax
  801d1a:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d27:	e8 01 f9 ff ff       	call   80162d <_Z14sys_page_unmapiPv>
	return r;
}
  801d2c:	89 d8                	mov    %ebx,%eax
  801d2e:	83 c4 20             	add    $0x20,%esp
  801d31:	5b                   	pop    %ebx
  801d32:	5e                   	pop    %esi
  801d33:	5d                   	pop    %ebp
  801d34:	c3                   	ret    

00801d35 <_Z5closei>:
// File descriptor interface functions
// --------------------------------------------------------------

int
close(int fdnum)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  801d3b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801d42:	00 
  801d43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	89 04 24             	mov    %eax,(%esp)
  801d50:	e8 dc fd ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  801d55:	85 c0                	test   %eax,%eax
  801d57:	78 13                	js     801d6c <_Z5closei+0x37>
		return r;
	else
		return fd_close(fd, true);
  801d59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d60:	00 
  801d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d64:	89 04 24             	mov    %eax,(%esp)
  801d67:	e8 41 ff ff ff       	call   801cad <_Z8fd_closeP2Fdb>
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <_Z9close_allv>:

void
close_all(void)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	53                   	push   %ebx
  801d72:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < NFD; i++)
  801d75:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801d7a:	89 1c 24             	mov    %ebx,(%esp)
  801d7d:	e8 b3 ff ff ff       	call   801d35 <_Z5closei>

void
close_all(void)
{
	int i;
	for (i = 0; i < NFD; i++)
  801d82:	83 c3 01             	add    $0x1,%ebx
  801d85:	83 fb 20             	cmp    $0x20,%ebx
  801d88:	75 f0                	jne    801d7a <_Z9close_allv+0xc>
		close(i);
}
  801d8a:	83 c4 14             	add    $0x14,%esp
  801d8d:	5b                   	pop    %ebx
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    

00801d90 <_Z3dupii>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 48             	sub    $0x48,%esp
  801d96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d99:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d9c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801d9f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801da2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801da9:	00 
  801daa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	89 04 24             	mov    %eax,(%esp)
  801db7:	e8 75 fd ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  801dbc:	89 c3                	mov    %eax,%ebx
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	0f 88 ce 00 00 00    	js     801e94 <_Z3dupii+0x104>
  801dc6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dcd:	00 
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
  801dce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
  801dd5:	89 34 24             	mov    %esi,(%esp)
  801dd8:	e8 54 fd ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  801ddd:	89 c3                	mov    %eax,%ebx
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	0f 89 bc 00 00 00    	jns    801ea3 <_Z3dupii+0x113>
  801de7:	e9 a8 00 00 00       	jmp    801e94 <_Z3dupii+0x104>
	close(newfdnum);

	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801dec:	89 d8                	mov    %ebx,%eax
  801dee:	c1 e8 0c             	shr    $0xc,%eax
  801df1:	8b 14 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%edx
  801df8:	f6 c2 01             	test   $0x1,%dl
  801dfb:	74 32                	je     801e2f <_Z3dupii+0x9f>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801dfd:	8b 04 85 00 00 80 ef 	mov    -0x10800000(,%eax,4),%eax
  801e04:	25 07 0e 00 00       	and    $0xe07,%eax
  801e09:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e11:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e18:	00 
  801e19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e24:	e8 a6 f7 ff ff       	call   8015cf <_Z12sys_page_mapiPviS_i>
  801e29:	89 c3                	mov    %eax,%ebx
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	78 3e                	js     801e6d <_Z3dupii+0xdd>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e32:	89 c2                	mov    %eax,%edx
  801e34:	c1 ea 0c             	shr    $0xc,%edx
  801e37:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
  801e3e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801e44:	89 54 24 10          	mov    %edx,0x10(%esp)
  801e48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e4b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e56:	00 
  801e57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e62:	e8 68 f7 ff ff       	call   8015cf <_Z12sys_page_mapiPviS_i>
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	79 25                	jns    801e92 <_Z3dupii+0x102>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e7b:	e8 ad f7 ff ff       	call   80162d <_Z14sys_page_unmapiPv>
	sys_page_unmap(0, nva);
  801e80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e8b:	e8 9d f7 ff ff       	call   80162d <_Z14sys_page_unmapiPv>
	return r;
  801e90:	eb 02                	jmp    801e94 <_Z3dupii+0x104>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;

	return newfdnum;
  801e92:	89 f3                	mov    %esi,%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801e94:	89 d8                	mov    %ebx,%eax
  801e96:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801e99:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801e9c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801e9f:	89 ec                	mov    %ebp,%esp
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd, true)) < 0
	    || (r = fd_lookup(newfdnum, &newfd, false)) < 0)
		return r;
	close(newfdnum);
  801ea3:	89 34 24             	mov    %esi,(%esp)
  801ea6:	e8 8a fe ff ff       	call   801d35 <_Z5closei>

	ova = fd2data(oldfd);
  801eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eae:	89 04 24             	mov    %eax,(%esp)
  801eb1:	e8 16 fd ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  801eb6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801eb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ebb:	89 04 24             	mov    %eax,(%esp)
  801ebe:	e8 09 fd ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  801ec3:	89 c7                	mov    %eax,%edi

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[PGNUM(ova)] & PTE_P))
  801ec5:	89 d8                	mov    %ebx,%eax
  801ec7:	c1 e8 16             	shr    $0x16,%eax
  801eca:	8b 04 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%eax
  801ed1:	a8 01                	test   $0x1,%al
  801ed3:	0f 85 13 ff ff ff    	jne    801dec <_Z3dupii+0x5c>
  801ed9:	e9 51 ff ff ff       	jmp    801e2f <_Z3dupii+0x9f>

00801ede <_Z4readiPvj>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	53                   	push   %ebx
  801ee2:	83 ec 24             	sub    $0x24,%esp
  801ee5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801ee8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801eef:	00 
  801ef0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef7:	89 1c 24             	mov    %ebx,(%esp)
  801efa:	e8 32 fc ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  801eff:	85 c0                	test   %eax,%eax
  801f01:	78 5f                	js     801f62 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801f0d:	8b 00                	mov    (%eax),%eax
  801f0f:	89 04 24             	mov    %eax,(%esp)
  801f12:	e8 2b fd ff ff       	call   801c42 <_Z10dev_lookupiPP3Dev>
  801f17:	85 c0                	test   %eax,%eax
  801f19:	79 4d                	jns    801f68 <_Z4readiPvj+0x8a>
  801f1b:	eb 45                	jmp    801f62 <_Z4readiPvj+0x84>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f1d:	a1 00 70 80 00       	mov    0x807000,%eax
  801f22:	8b 40 04             	mov    0x4(%eax),%eax
  801f25:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2d:	c7 04 24 ac 4b 80 00 	movl   $0x804bac,(%esp)
  801f34:	e8 39 eb ff ff       	call   800a72 <_Z7cprintfPKcz>
		return -E_INVAL;
  801f39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f3e:	eb 22                	jmp    801f62 <_Z4readiPvj+0x84>
	}
	if (!dev->dev_read)
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	8b 50 08             	mov    0x8(%eax),%edx
		return -E_NOT_SUPP;
  801f46:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801f4b:	85 d2                	test   %edx,%edx
  801f4d:	74 13                	je     801f62 <_Z4readiPvj+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f52:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5d:	89 0c 24             	mov    %ecx,(%esp)
  801f60:	ff d2                	call   *%edx
}
  801f62:	83 c4 24             	add    $0x24,%esp
  801f65:	5b                   	pop    %ebx
  801f66:	5d                   	pop    %ebp
  801f67:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f68:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f6b:	8b 41 08             	mov    0x8(%ecx),%eax
  801f6e:	83 e0 03             	and    $0x3,%eax
  801f71:	83 f8 01             	cmp    $0x1,%eax
  801f74:	75 ca                	jne    801f40 <_Z4readiPvj+0x62>
  801f76:	eb a5                	jmp    801f1d <_Z4readiPvj+0x3f>

00801f78 <_Z5readniPvj>:
	return (*dev->dev_read)(fd, buf, n);
}

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	57                   	push   %edi
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 1c             	sub    $0x1c,%esp
  801f81:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f84:	8b 75 10             	mov    0x10(%ebp),%esi
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801f87:	85 f6                	test   %esi,%esi
  801f89:	74 2f                	je     801fba <_Z5readniPvj+0x42>
  801f8b:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801f90:	89 f0                	mov    %esi,%eax
  801f92:	29 d8                	sub    %ebx,%eax
  801f94:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f98:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801f9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	89 04 24             	mov    %eax,(%esp)
  801fa5:	e8 34 ff ff ff       	call   801ede <_Z4readiPvj>
		if (m < 0)
  801faa:	85 c0                	test   %eax,%eax
  801fac:	78 13                	js     801fc1 <_Z5readniPvj+0x49>
			return m;
		if (m == 0)
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	74 0d                	je     801fbf <_Z5readniPvj+0x47>
readn(int fdnum, void *buf, size_t n)
{
	int m;
	size_t tot;

	for (tot = 0; tot < n; tot += m) {
  801fb2:	01 c3                	add    %eax,%ebx
  801fb4:	39 de                	cmp    %ebx,%esi
  801fb6:	77 d8                	ja     801f90 <_Z5readniPvj+0x18>
  801fb8:	eb 05                	jmp    801fbf <_Z5readniPvj+0x47>
  801fba:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801fbf:	89 d8                	mov    %ebx,%eax
}
  801fc1:	83 c4 1c             	add    $0x1c,%esp
  801fc4:	5b                   	pop    %ebx
  801fc5:	5e                   	pop    %esi
  801fc6:	5f                   	pop    %edi
  801fc7:	5d                   	pop    %ebp
  801fc8:	c3                   	ret    

00801fc9 <_Z5writeiPKvj>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801fcf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801fd6:	00 
  801fd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fda:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	89 04 24             	mov    %eax,(%esp)
  801fe4:	e8 48 fb ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	78 3c                	js     802029 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  801ff7:	8b 00                	mov    (%eax),%eax
  801ff9:	89 04 24             	mov    %eax,(%esp)
  801ffc:	e8 41 fc ff ff       	call   801c42 <_Z10dev_lookupiPP3Dev>
  802001:	85 c0                	test   %eax,%eax
  802003:	79 26                	jns    80202b <_Z5writeiPKvj+0x62>
  802005:	eb 22                	jmp    802029 <_Z5writeiPKvj+0x60>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	8b 48 0c             	mov    0xc(%eax),%ecx
		return -E_NOT_SUPP;
  80200d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
		return -E_INVAL;
	if (!dev->dev_write)
  802012:	85 c9                	test   %ecx,%ecx
  802014:	74 13                	je     802029 <_Z5writeiPKvj+0x60>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802016:	8b 45 10             	mov    0x10(%ebp),%eax
  802019:	89 44 24 08          	mov    %eax,0x8(%esp)
  80201d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802020:	89 44 24 04          	mov    %eax,0x4(%esp)
  802024:	89 14 24             	mov    %edx,(%esp)
  802027:	ff d1                	call   *%ecx
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  80202b:	8b 55 f0             	mov    -0x10(%ebp),%edx
		return -E_INVAL;
  80202e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
  802033:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  802037:	74 f0                	je     802029 <_Z5writeiPKvj+0x60>
  802039:	eb cc                	jmp    802007 <_Z5writeiPKvj+0x3e>

0080203b <_Z4seekii>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  802041:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802048:	00 
  802049:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	89 04 24             	mov    %eax,(%esp)
  802056:	e8 d6 fa ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  80205b:	85 c0                	test   %eax,%eax
  80205d:	78 0e                	js     80206d <_Z4seekii+0x32>
		return r;
	fd->fd_offset = offset;
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	8b 55 0c             	mov    0xc(%ebp),%edx
  802065:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <_Z9ftruncateii>:

int
ftruncate(int fdnum, off_t newsize)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	53                   	push   %ebx
  802073:	83 ec 24             	sub    $0x24,%esp
  802076:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802079:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802080:	00 
  802081:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802084:	89 44 24 04          	mov    %eax,0x4(%esp)
  802088:	89 1c 24             	mov    %ebx,(%esp)
  80208b:	e8 a1 fa ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  802090:	85 c0                	test   %eax,%eax
  802092:	78 58                	js     8020ec <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802094:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802097:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209b:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80209e:	8b 00                	mov    (%eax),%eax
  8020a0:	89 04 24             	mov    %eax,(%esp)
  8020a3:	e8 9a fb ff ff       	call   801c42 <_Z10dev_lookupiPP3Dev>
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	79 46                	jns    8020f2 <_Z9ftruncateii+0x83>
  8020ac:	eb 3e                	jmp    8020ec <_Z9ftruncateii+0x7d>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
  8020ae:	a1 00 70 80 00       	mov    0x807000,%eax
  8020b3:	8b 40 04             	mov    0x4(%eax),%eax
  8020b6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020be:	c7 04 24 e8 4b 80 00 	movl   $0x804be8,(%esp)
  8020c5:	e8 a8 e9 ff ff       	call   800a72 <_Z7cprintfPKcz>
		return -E_INVAL;
  8020ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020cf:	eb 1b                	jmp    8020ec <_Z9ftruncateii+0x7d>
	}
	if (!dev->dev_trunc)
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 50 18             	mov    0x18(%eax),%edx
		return -E_NOT_SUPP;
  8020d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8020dc:	85 d2                	test   %edx,%edx
  8020de:	74 0c                	je     8020ec <_Z9ftruncateii+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8020e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e7:	89 0c 24             	mov    %ecx,(%esp)
  8020ea:	ff d2                	call   *%edx
}
  8020ec:	83 c4 24             	add    $0x24,%esp
  8020ef:	5b                   	pop    %ebx
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020f2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020f5:	f6 41 08 03          	testb  $0x3,0x8(%ecx)
  8020f9:	75 d6                	jne    8020d1 <_Z9ftruncateii+0x62>
  8020fb:	eb b1                	jmp    8020ae <_Z9ftruncateii+0x3f>

008020fd <_Z5fstatiP4Stat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	53                   	push   %ebx
  802101:	83 ec 24             	sub    $0x24,%esp
  802104:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  802107:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80210e:	00 
  80210f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802112:	89 44 24 04          	mov    %eax,0x4(%esp)
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	89 04 24             	mov    %eax,(%esp)
  80211c:	e8 10 fa ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  802121:	85 c0                	test   %eax,%eax
  802123:	78 3e                	js     802163 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802125:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212c:	8b 45 f0             	mov    -0x10(%ebp),%eax
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
  80212f:	8b 00                	mov    (%eax),%eax
  802131:	89 04 24             	mov    %eax,(%esp)
  802134:	e8 09 fb ff ff       	call   801c42 <_Z10dev_lookupiPP3Dev>
  802139:	85 c0                	test   %eax,%eax
  80213b:	79 2c                	jns    802169 <_Z5fstatiP4Stat+0x6c>
  80213d:	eb 24                	jmp    802163 <_Z5fstatiP4Stat+0x66>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80213f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802142:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
	stat->st_ftype = 0;
  802149:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	stat->st_dev = dev;
  802150:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802156:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215d:	89 04 24             	mov    %eax,(%esp)
  802160:	ff 52 14             	call   *0x14(%edx)
}
  802163:	83 c4 24             	add    $0x24,%esp
  802166:	5b                   	pop    %ebx
  802167:	5d                   	pop    %ebp
  802168:	c3                   	ret    
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802169:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  80216c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802171:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  802175:	75 c8                	jne    80213f <_Z5fstatiP4Stat+0x42>
  802177:	eb ea                	jmp    802163 <_Z5fstatiP4Stat+0x66>

00802179 <_Z4statPKcP4Stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	83 ec 18             	sub    $0x18,%esp
  80217f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802182:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802185:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80218c:	00 
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	89 04 24             	mov    %eax,(%esp)
  802193:	e8 d6 09 00 00       	call   802b6e <_Z4openPKci>
  802198:	89 c3                	mov    %eax,%ebx
  80219a:	85 c0                	test   %eax,%eax
  80219c:	78 1b                	js     8021b9 <_Z4statPKcP4Stat+0x40>
		return fd;
	r = fstat(fd, stat);
  80219e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a5:	89 1c 24             	mov    %ebx,(%esp)
  8021a8:	e8 50 ff ff ff       	call   8020fd <_Z5fstatiP4Stat>
  8021ad:	89 c6                	mov    %eax,%esi
	close(fd);
  8021af:	89 1c 24             	mov    %ebx,(%esp)
  8021b2:	e8 7e fb ff ff       	call   801d35 <_Z5closei>
	return r;
  8021b7:	89 f3                	mov    %esi,%ebx
}
  8021b9:	89 d8                	mov    %ebx,%eax
  8021bb:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8021be:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8021c1:	89 ec                	mov    %ebp,%esp
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    
	...

008021d0 <_ZL10inode_dataP5Inodei>:
// in the file 'ino'.
// Returns NULL if 'off' is out of range for the file.
//
static void *
inode_data(struct Inode *ino, off_t off)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
		return 0;
  8021d3:	b9 00 00 00 00       	mov    $0x0,%ecx
//
static void *
inode_data(struct Inode *ino, off_t off)
{
	blocknum_t blocknum;
	if (off < 0 || off >= ino->i_size)
  8021d8:	85 d2                	test   %edx,%edx
  8021da:	78 33                	js     80220f <_ZL10inode_dataP5Inodei+0x3f>
  8021dc:	3b 50 08             	cmp    0x8(%eax),%edx
  8021df:	7d 2e                	jge    80220f <_ZL10inode_dataP5Inodei+0x3f>
		return 0;
	blocknum = ino->i_direct[off / PGSIZE];
  8021e1:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  8021e7:	85 d2                	test   %edx,%edx
  8021e9:	0f 49 ca             	cmovns %edx,%ecx
  8021ec:	c1 f9 0c             	sar    $0xc,%ecx
	return (void *) (FSMAP + blocknum * BLKSIZE + off % PGSIZE);
  8021ef:	8b 4c 88 0c          	mov    0xc(%eax,%ecx,4),%ecx
  8021f3:	c1 e1 0c             	shl    $0xc,%ecx
  8021f6:	89 d0                	mov    %edx,%eax
  8021f8:	c1 f8 1f             	sar    $0x1f,%eax
  8021fb:	c1 e8 14             	shr    $0x14,%eax
  8021fe:	01 c2                	add    %eax,%edx
  802200:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802206:	29 c2                	sub    %eax,%edx
  802208:	8d 8c 11 00 00 00 50 	lea    0x50000000(%ecx,%edx,1),%ecx
}
  80220f:	89 c8                	mov    %ecx,%eax
  802211:	5d                   	pop    %ebp
  802212:	c3                   	ret    

00802213 <_ZL9stat_basePK5InodeP4Stat>:
    return fd->fd_offset - orig_offset;
}

static void
stat_base(const struct Inode *ino, struct Stat *stat)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	stat->st_size = ino->i_size;
  802216:	8b 48 08             	mov    0x8(%eax),%ecx
  802219:	89 4a 78             	mov    %ecx,0x78(%edx)
	stat->st_ftype = ino->i_ftype;
  80221c:	8b 00                	mov    (%eax),%eax
  80221e:	89 42 7c             	mov    %eax,0x7c(%edx)
	stat->st_dev = &devfile;
  802221:	c7 82 80 00 00 00 08 	movl   $0x806008,0x80(%edx)
  802228:	60 80 00 
}
  80222b:	5d                   	pop    %ebp
  80222c:	c3                   	ret    

0080222d <_ZL9get_inodei>:
// Return a pointer to inode number 'inum'.
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 18             	sub    $0x18,%esp
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802233:	8b 15 04 10 00 50    	mov    0x50001004,%edx
	if (inum == 0 || inum > super->s_ninodes)
  802239:	85 c0                	test   %eax,%eax
  80223b:	74 08                	je     802245 <_ZL9get_inodei+0x18>
  80223d:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  802243:	7e 20                	jle    802265 <_ZL9get_inodei+0x38>
		panic("inode %d out of range", inum);
  802245:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802249:	c7 44 24 08 20 4c 80 	movl   $0x804c20,0x8(%esp)
  802250:	00 
  802251:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  802258:	00 
  802259:	c7 04 24 36 4c 80 00 	movl   $0x804c36,(%esp)
  802260:	e8 ef e6 ff ff       	call   800954 <_Z6_panicPKciS0_z>
// The inode might not be in memory right now (it should be demand paged).
//
static struct Inode *
get_inode(int inum)
{
	blocknum_t b = 1 + ROUNDUP(super->s_nblocks, PGSIZE) / PGSIZE + inum;
  802265:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80226b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802271:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  802277:	85 d2                	test   %edx,%edx
  802279:	0f 48 d1             	cmovs  %ecx,%edx
  80227c:	c1 fa 0c             	sar    $0xc,%edx
	if (inum == 0 || inum > super->s_ninodes)
		panic("inode %d out of range", inum);
	return (struct Inode *) (FSMAP + b * BLKSIZE);
  80227f:	8d 84 10 01 00 05 00 	lea    0x50001(%eax,%edx,1),%eax
  802286:	c1 e0 0c             	shl    $0xc,%eax
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <_ZL10bcache_ipcPvi>:
// for the file system block containing 'addr'.
// Returns 0 on success, < 0 on error.
//
static int
bcache_ipc(void *addr, int reqtype)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	56                   	push   %esi
  80228f:	53                   	push   %ebx
  802290:	83 ec 10             	sub    $0x10,%esp
	int r;
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
  802293:	8d b0 00 00 00 b0    	lea    -0x50000000(%eax),%esi
  802299:	c1 ee 0c             	shr    $0xc,%esi
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
  80229c:	81 fe 00 00 08 00    	cmp    $0x80000,%esi
  8022a2:	76 20                	jbe    8022c4 <_ZL10bcache_ipcPvi+0x39>
		panic("bcache_ipc: va %08x out of disk address range", addr);
  8022a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022a8:	c7 44 24 08 5c 4c 80 	movl   $0x804c5c,0x8(%esp)
  8022af:	00 
  8022b0:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8022b7:	00 
  8022b8:	c7 04 24 36 4c 80 00 	movl   $0x804c36,(%esp)
  8022bf:	e8 90 e6 ff ff       	call   800954 <_Z6_panicPKciS0_z>
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
  8022c4:	83 fe 01             	cmp    $0x1,%esi
  8022c7:	7e 08                	jle    8022d1 <_ZL10bcache_ipcPvi+0x46>
  8022c9:	3b 35 04 10 00 50    	cmp    0x50001004,%esi
  8022cf:	7d 12                	jge    8022e3 <_ZL10bcache_ipcPvi+0x58>
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  8022d1:	89 f3                	mov    %esi,%ebx
  8022d3:	c1 e3 04             	shl    $0x4,%ebx
  8022d6:	09 d3                	or     %edx,%ebx
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  8022d8:	81 c6 00 00 05 00    	add    $0x50000,%esi
  8022de:	c1 e6 0c             	shl    $0xc,%esi
  8022e1:	eb 20                	jmp    802303 <_ZL10bcache_ipcPvi+0x78>
	blocknum_t b = ((uintptr_t) addr - FSMAP) / BLKSIZE;
	if (b < 0 || b > (blocknum_t) (DISKSIZE / BLKSIZE))
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);
  8022e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8022e7:	c7 44 24 08 8c 4c 80 	movl   $0x804c8c,0x8(%esp)
  8022ee:	00 
  8022ef:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8022f6:	00 
  8022f7:	c7 04 24 36 4c 80 00 	movl   $0x804c36,(%esp)
  8022fe:	e8 51 e6 ff ff       	call   800954 <_Z6_panicPKciS0_z>

	do {
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
  802303:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80230a:	00 
  80230b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802312:	00 
  802313:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802317:	c7 04 24 00 11 00 00 	movl   $0x1100,(%esp)
  80231e:	e8 1c f7 ff ff       	call   801a3f <_Z8ipc_sendijPvi>
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
  802323:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80232a:	00 
  80232b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80232f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802336:	e8 75 f6 ff ff       	call   8019b0 <_Z8ipc_recvPiPvS_>
		panic("bcache_ipc: va %08x out of disk address range", addr);
	// Be careful: check 'super' might not be loaded!
	if (b >= 2 && b >= super->s_nblocks)
		panic("bcache_ipc: block %d out of file system bounds", b);

	do {
  80233b:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80233e:	74 c3                	je     802303 <_ZL10bcache_ipcPvi+0x78>
		ipc_send(ENVID_BUFCACHE, MAKE_BCREQ(b, reqtype), 0, 0);
		r = ipc_recv(0, (void *) (FSMAP + b * PGSIZE), 0);
	} while (r == -E_AGAIN);

	return r;
}
  802340:	83 c4 10             	add    $0x10,%esp
  802343:	5b                   	pop    %ebx
  802344:	5e                   	pop    %esi
  802345:	5d                   	pop    %ebp
  802346:	c3                   	ret    

00802347 <_ZL10inode_openiPP5Inode>:
// Every inode_open() must be balanced by an inode_close().
// Returns 0 on success, < 0 on failure.
//
static int
inode_open(int inum, struct Inode **ino_store)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	83 ec 28             	sub    $0x28,%esp
  80234d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802350:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802353:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802356:	89 c7                	mov    %eax,%edi
  802358:	89 d6                	mov    %edx,%esi
	int r;
	struct Inode *ino;

	// Always make sure our pagefault handler is installed.
	add_pgfault_handler(bcache_pgfault_handler);
  80235a:	c7 04 24 ed 25 80 00 	movl   $0x8025ed,(%esp)
  802361:	e8 05 20 00 00       	call   80436b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	ino = get_inode(inum);
  802366:	89 f8                	mov    %edi,%eax
  802368:	e8 c0 fe ff ff       	call   80222d <_ZL9get_inodei>
  80236d:	89 c3                	mov    %eax,%ebx
	r = bcache_ipc(ino, BCREQ_MAP_WLOCK);
  80236f:	ba 02 00 00 00       	mov    $0x2,%edx
  802374:	e8 12 ff ff ff       	call   80228b <_ZL10bcache_ipcPvi>
	if (r < 0) {
  802379:	85 c0                	test   %eax,%eax
  80237b:	79 08                	jns    802385 <_ZL10inode_openiPP5Inode+0x3e>
		*ino_store = 0;
  80237d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		return r;
  802383:	eb 2e                	jmp    8023b3 <_ZL10inode_openiPP5Inode+0x6c>
	}

	// Initialize memory-only fields when an inode is first read from disk.
	if (r == 0) {		// i.e., the block has not been INITIALIZEd
  802385:	85 c0                	test   %eax,%eax
  802387:	75 1c                	jne    8023a5 <_ZL10inode_openiPP5Inode+0x5e>
		ino->i_inum = inum;
  802389:	89 bb f4 0f 00 00    	mov    %edi,0xff4(%ebx)
		ino->i_opencount = 0;
  80238f:	c7 83 f8 0f 00 00 00 	movl   $0x0,0xff8(%ebx)
  802396:	00 00 00 
		bcache_ipc(ino, BCREQ_INITIALIZE);
  802399:	ba 06 00 00 00       	mov    $0x6,%edx
  80239e:	89 d8                	mov    %ebx,%eax
  8023a0:	e8 e6 fe ff ff       	call   80228b <_ZL10bcache_ipcPvi>
	}

	// Account for our reservation and return.
	++ino->i_opencount;
  8023a5:	83 83 f8 0f 00 00 01 	addl   $0x1,0xff8(%ebx)
	*ino_store = ino;
  8023ac:	89 1e                	mov    %ebx,(%esi)
	return 0;
  8023ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023b6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8023b9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8023bc:	89 ec                	mov    %ebp,%esp
  8023be:	5d                   	pop    %ebp
  8023bf:	c3                   	ret    

008023c0 <_ZL14inode_set_sizeP5Inodej>:
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	57                   	push   %edi
  8023c4:	56                   	push   %esi
  8023c5:	53                   	push   %ebx
  8023c6:	83 ec 2c             	sub    $0x2c,%esp
  8023c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023cc:	89 55 d8             	mov    %edx,-0x28(%ebp)
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
		return -E_FILE_SIZE;
  8023cf:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
	// all cases.  Read the spec carefully: what is missing?
	// LAB 5: Your code somewhere here

	int b1, b2;

	if (size > MAXFILESIZE)
  8023d4:	81 fa 00 a0 3f 00    	cmp    $0x3fa000,%edx
  8023da:	0f 87 3d 01 00 00    	ja     80251d <_ZL14inode_set_sizeP5Inodej+0x15d>
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
  8023e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8023e3:	8b 42 08             	mov    0x8(%edx),%eax
  8023e6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  8023ec:	85 c0                	test   %eax,%eax
  8023ee:	0f 49 f0             	cmovns %eax,%esi
  8023f1:	c1 fe 0c             	sar    $0xc,%esi
  8023f4:	89 f3                	mov    %esi,%ebx
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
  8023f6:	8b 7d d8             	mov    -0x28(%ebp),%edi
  8023f9:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
  8023ff:	c1 ef 0c             	shr    $0xc,%edi
    if (size >= (size_t)ino->i_size)
  802402:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802405:	0f 82 a6 00 00 00    	jb     8024b1 <_ZL14inode_set_sizeP5Inodej+0xf1>
    {
        for (; b1 < b2; ++b1)
  80240b:	39 fe                	cmp    %edi,%esi
  80240d:	0f 8d f2 00 00 00    	jge    802505 <_ZL14inode_set_sizeP5Inodej+0x145>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  802413:	8d 74 b2 0c          	lea    0xc(%edx,%esi,4),%esi
  802417:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80241a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80241d:	89 75 e0             	mov    %esi,-0x20(%ebp)
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
  802420:	83 3e 00             	cmpl   $0x0,(%esi)
  802423:	75 77                	jne    80249c <_ZL14inode_set_sizeP5Inodej+0xdc>
	// Find a free block, allocate it, and return its number.
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802425:	ba 02 00 00 00       	mov    $0x2,%edx
  80242a:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80242f:	e8 57 fe ff ff       	call   80228b <_ZL10bcache_ipcPvi>
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802434:	8b 0d 04 10 00 50    	mov    0x50001004,%ecx
  80243a:	83 f9 02             	cmp    $0x2,%ecx
  80243d:	7e 43                	jle    802482 <_ZL14inode_set_sizeP5Inodej+0xc2>
    {
        if(freemap[i] != 0)
  80243f:	b8 03 20 00 50       	mov    $0x50002003,%eax
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  802444:	bb 02 00 00 00       	mov    $0x2,%ebx
    {
        if(freemap[i] != 0)
  802449:	80 3d 02 20 00 50 00 	cmpb   $0x0,0x50002002
  802450:	74 29                	je     80247b <_ZL14inode_set_sizeP5Inodej+0xbb>
  802452:	e9 ce 00 00 00       	jmp    802525 <_ZL14inode_set_sizeP5Inodej+0x165>
  802457:	89 c7                	mov    %eax,%edi
  802459:	0f b6 10             	movzbl (%eax),%edx
  80245c:	83 c0 01             	add    $0x1,%eax
  80245f:	84 d2                	test   %dl,%dl
  802461:	74 18                	je     80247b <_ZL14inode_set_sizeP5Inodej+0xbb>
        {
            freemap[i] = 0;
  802463:	c6 07 00             	movb   $0x0,(%edi)
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802466:	ba 05 00 00 00       	mov    $0x5,%edx
  80246b:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802470:	e8 16 fe ff ff       	call   80228b <_ZL10bcache_ipcPvi>
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
  802475:	85 db                	test   %ebx,%ebx
  802477:	79 1e                	jns    802497 <_ZL14inode_set_sizeP5Inodej+0xd7>
  802479:	eb 07                	jmp    802482 <_ZL14inode_set_sizeP5Inodej+0xc2>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80247b:	83 c3 01             	add    $0x1,%ebx
  80247e:	39 d9                	cmp    %ebx,%ecx
  802480:	7f d5                	jg     802457 <_ZL14inode_set_sizeP5Inodej+0x97>
    {
        for (; b1 < b2; ++b1)
            if (ino->i_direct[b1] == 0) {
                blocknum_t b = block_alloc();
                if (b < 0) {
                    inode_set_size(ino, ino->i_size);
  802482:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802485:	8b 50 08             	mov    0x8(%eax),%edx
  802488:	e8 33 ff ff ff       	call   8023c0 <_ZL14inode_set_sizeP5Inodej>
                    return -E_NO_DISK;
  80248d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802492:	e9 86 00 00 00       	jmp    80251d <_ZL14inode_set_sizeP5Inodej+0x15d>
                }
                ino->i_direct[b1] = b;
  802497:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80249a:	89 1a                	mov    %ebx,(%edx)
		return -E_FILE_SIZE;
    b1 = ino->i_size / BLKSIZE;
    b2 = ROUNDUP(size, BLKSIZE) / BLKSIZE;
    if (size >= (size_t)ino->i_size)
    {
        for (; b1 < b2; ++b1)
  80249c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  8024a0:	83 c6 04             	add    $0x4,%esi
  8024a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024a6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8024a9:	0f 8f 6e ff ff ff    	jg     80241d <_ZL14inode_set_sizeP5Inodej+0x5d>
  8024af:	eb 54                	jmp    802505 <_ZL14inode_set_sizeP5Inodej+0x145>
                ino->i_direct[b1] = b;
            }
    }
    else
    {
        if(!(size % BLKSIZE))
  8024b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b4:	25 ff 0f 00 00       	and    $0xfff,%eax
            b2--;
  8024b9:	83 f8 01             	cmp    $0x1,%eax
  8024bc:	83 df 00             	sbb    $0x0,%edi
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  8024bf:	ba 02 00 00 00       	mov    $0x2,%edx
  8024c4:	b8 00 20 00 50       	mov    $0x50002000,%eax
  8024c9:	e8 bd fd ff ff       	call   80228b <_ZL10bcache_ipcPvi>
        for(; b2 < b1; b1--)
  8024ce:	39 f7                	cmp    %esi,%edi
  8024d0:	7d 24                	jge    8024f6 <_ZL14inode_set_sizeP5Inodej+0x136>
//	possibly others
// On error, the inode's size and disk's allocation state should be unchanged.
// On success, any changed blocks are flushed.
//
static int
inode_set_size(struct Inode *ino, size_t size)
  8024d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024d5:	8d 44 b2 0c          	lea    0xc(%edx,%esi,4),%eax
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
            if (ino->i_direct[b1] != 0)
  8024d9:	8b 10                	mov    (%eax),%edx
  8024db:	85 d2                	test   %edx,%edx
  8024dd:	74 0d                	je     8024ec <_ZL14inode_set_sizeP5Inodej+0x12c>
            {
                freemap[ino->i_direct[b1]] = 1;
  8024df:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
                ino->i_direct[b1] = 0;
  8024e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    else
    {
        if(!(size % BLKSIZE))
            b2--;
	    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(; b2 < b1; b1--)
  8024ec:	83 eb 01             	sub    $0x1,%ebx
  8024ef:	83 e8 04             	sub    $0x4,%eax
  8024f2:	39 fb                	cmp    %edi,%ebx
  8024f4:	75 e3                	jne    8024d9 <_ZL14inode_set_sizeP5Inodej+0x119>
            if (ino->i_direct[b1] != 0)
            {
                freemap[ino->i_direct[b1]] = 1;
                ino->i_direct[b1] = 0;
            }
	    bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  8024f6:	ba 05 00 00 00       	mov    $0x5,%edx
  8024fb:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802500:	e8 86 fd ff ff       	call   80228b <_ZL10bcache_ipcPvi>
    }
	ino->i_size = size;
  802505:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80250b:	89 50 08             	mov    %edx,0x8(%eax)
	bcache_ipc(ino, BCREQ_FLUSH);
  80250e:	ba 04 00 00 00       	mov    $0x4,%edx
  802513:	e8 73 fd ff ff       	call   80228b <_ZL10bcache_ipcPvi>
	return 0;
  802518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80251d:	83 c4 2c             	add    $0x2c,%esp
  802520:	5b                   	pop    %ebx
  802521:	5e                   	pop    %esi
  802522:	5f                   	pop    %edi
  802523:	5d                   	pop    %ebp
  802524:	c3                   	ret    
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
    {
        if(freemap[i] != 0)
        {
            freemap[i] = 0;
  802525:	c6 05 02 20 00 50 00 	movb   $0x0,0x50002002
            bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  80252c:	ba 05 00 00 00       	mov    $0x5,%edx
  802531:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802536:	e8 50 fd ff ff       	call   80228b <_ZL10bcache_ipcPvi>
	// Use block locking to avoid concurrency issues -- but try to
	// avoid unnecessary IPCs.
	//
	// LAB 5: Your code here.
    bcache_ipc(freemap, BCREQ_MAP_WLOCK);
    for(blocknum_t i = 2; i < super->s_nblocks; i++)
  80253b:	bb 02 00 00 00       	mov    $0x2,%ebx
  802540:	e9 52 ff ff ff       	jmp    802497 <_ZL14inode_set_sizeP5Inodej+0xd7>

00802545 <_ZL11inode_closeP5Inode>:
// Reduce its i_opencount and unlock the corresponding block.
// If the inode is now free, then free the corresponding data blocks.
//
static int
inode_close(struct Inode *ino)
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
  802548:	53                   	push   %ebx
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	89 c3                	mov    %eax,%ebx
	--ino->i_opencount;
  80254e:	8b 80 f8 0f 00 00    	mov    0xff8(%eax),%eax
  802554:	83 e8 01             	sub    $0x1,%eax
  802557:	89 83 f8 0f 00 00    	mov    %eax,0xff8(%ebx)
	// The inode might now be free.
	// If no references remain on disk or in memory, then free the
	// corresponding data blocks.
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
  80255d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  802561:	75 40                	jne    8025a3 <_ZL11inode_closeP5Inode+0x5e>
  802563:	85 c0                	test   %eax,%eax
  802565:	75 3c                	jne    8025a3 <_ZL11inode_closeP5Inode+0x5e>
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
  802567:	ba 02 00 00 00       	mov    $0x2,%edx
  80256c:	b8 00 20 00 50       	mov    $0x50002000,%eax
  802571:	e8 15 fd ff ff       	call   80228b <_ZL10bcache_ipcPvi>
        for(int i = 0; i < NDIRECT; i++)
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
        {
            if(ino->i_direct[i] != 0)
  80257b:	8b 54 83 0c          	mov    0xc(%ebx,%eax,4),%edx
  80257f:	85 d2                	test   %edx,%edx
  802581:	74 07                	je     80258a <_ZL11inode_closeP5Inode+0x45>
                freemap[ino->i_direct[i]] = 1;
  802583:	c6 82 00 20 00 50 01 	movb   $0x1,0x50002000(%edx)
	//
	// LAB 5: Your code here.
    if(!ino->i_refcount && !ino->i_opencount)
    {
        bcache_ipc(freemap, BCREQ_MAP_WLOCK);
        for(int i = 0; i < NDIRECT; i++)
  80258a:	83 c0 01             	add    $0x1,%eax
  80258d:	3d fa 03 00 00       	cmp    $0x3fa,%eax
  802592:	75 e7                	jne    80257b <_ZL11inode_closeP5Inode+0x36>
        {
            if(ino->i_direct[i] != 0)
                freemap[ino->i_direct[i]] = 1;
            
        }
        bcache_ipc(freemap, BCREQ_UNLOCK_FLUSH);
  802594:	ba 05 00 00 00       	mov    $0x5,%edx
  802599:	b8 00 20 00 50       	mov    $0x50002000,%eax
  80259e:	e8 e8 fc ff ff       	call   80228b <_ZL10bcache_ipcPvi>
    }
    
	return bcache_ipc(ino, BCREQ_UNLOCK);
  8025a3:	ba 03 00 00 00       	mov    $0x3,%edx
  8025a8:	89 d8                	mov    %ebx,%eax
  8025aa:	e8 dc fc ff ff       	call   80228b <_ZL10bcache_ipcPvi>
}
  8025af:	83 c4 04             	add    $0x4,%esp
  8025b2:	5b                   	pop    %ebx
  8025b3:	5d                   	pop    %ebp
  8025b4:	c3                   	ret    

008025b5 <_ZL13devfile_truncP2Fdi>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
  8025b8:	53                   	push   %ebx
  8025b9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8025c5:	e8 7d fd ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  8025ca:	89 c3                	mov    %eax,%ebx
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	78 15                	js     8025e5 <_ZL13devfile_truncP2Fdi+0x30>
		return r;

	r = inode_set_size(ino, newsize);
  8025d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	e8 e5 fd ff ff       	call   8023c0 <_ZL14inode_set_sizeP5Inodej>
  8025db:	89 c3                	mov    %eax,%ebx

	inode_close(ino);
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	e8 60 ff ff ff       	call   802545 <_ZL11inode_closeP5Inode>
	return r;
}
  8025e5:	89 d8                	mov    %ebx,%eax
  8025e7:	83 c4 14             	add    $0x14,%esp
  8025ea:	5b                   	pop    %ebx
  8025eb:	5d                   	pop    %ebp
  8025ec:	c3                   	ret    

008025ed <_ZL22bcache_pgfault_handlerP10UTrapframe>:
// Panic if the load fails.
// If the fault isn't in the disk area, return so other handlers run.
//
static void
bcache_pgfault_handler(struct UTrapframe *utf)
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
  8025f0:	53                   	push   %ebx
  8025f1:	83 ec 14             	sub    $0x14,%esp
  8025f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    void *va = (void *)utf->utf_fault_va;
  8025f7:	8b 03                	mov    (%ebx),%eax
    if (va < (void *)FSMAP || va >= (void *)(FSMAP + DISKSIZE))
  8025f9:	89 c2                	mov    %eax,%edx
  8025fb:	81 ea 00 00 00 50    	sub    $0x50000000,%edx
  802601:	78 32                	js     802635 <_ZL22bcache_pgfault_handlerP10UTrapframe+0x48>
        return;
    if (bcache_ipc(va, BCREQ_MAP))
  802603:	ba 00 00 00 00       	mov    $0x0,%edx
  802608:	e8 7e fc ff ff       	call   80228b <_ZL10bcache_ipcPvi>
  80260d:	85 c0                	test   %eax,%eax
  80260f:	74 1c                	je     80262d <_ZL22bcache_pgfault_handlerP10UTrapframe+0x40>
        panic("bcache_ipc failure");
  802611:	c7 44 24 08 41 4c 80 	movl   $0x804c41,0x8(%esp)
  802618:	00 
  802619:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  802620:	00 
  802621:	c7 04 24 36 4c 80 00 	movl   $0x804c36,(%esp)
  802628:	e8 27 e3 ff ff       	call   800954 <_Z6_panicPKciS0_z>
    resume(utf);
  80262d:	89 1c 24             	mov    %ebx,(%esp)
  802630:	e8 0b 1e 00 00       	call   804440 <resume>
}
  802635:	83 c4 14             	add    $0x14,%esp
  802638:	5b                   	pop    %ebx
  802639:	5d                   	pop    %ebp
  80263a:	c3                   	ret    

0080263b <_ZL12devfile_statP2FdP4Stat>:
	stat->st_dev = &devfile;
}

static int
devfile_stat(struct Fd *fd, struct Stat *stat)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	83 ec 28             	sub    $0x28,%esp
  802641:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802644:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80264a:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	struct Inode *ino;

	if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  80264d:	8b 43 0c             	mov    0xc(%ebx),%eax
  802650:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802653:	e8 ef fc ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  802658:	85 c0                	test   %eax,%eax
  80265a:	78 26                	js     802682 <_ZL12devfile_statP2FdP4Stat+0x47>
		return r;

	strcpy(stat->st_name, fd->fd_file.open_path);
  80265c:	83 c3 10             	add    $0x10,%ebx
  80265f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802663:	89 34 24             	mov    %esi,(%esp)
  802666:	e8 1f ea ff ff       	call   80108a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  80266b:	89 f2                	mov    %esi,%edx
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	e8 9e fb ff ff       	call   802213 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	e8 c8 fe ff ff       	call   802545 <_ZL11inode_closeP5Inode>
	return 0;
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802682:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802685:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802688:	89 ec                	mov    %ebp,%esp
  80268a:	5d                   	pop    %ebp
  80268b:	c3                   	ret    

0080268c <_ZL13devfile_closeP2Fd>:

// Close the file descriptor.
//
static int
devfile_close(struct Fd *fd)
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
  80268f:	53                   	push   %ebx
  802690:	83 ec 24             	sub    $0x24,%esp
  802693:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  802696:	89 1c 24             	mov    %ebx,(%esp)
  802699:	e8 9e 15 00 00       	call   803c3c <_Z7pagerefPv>
  80269e:	89 c2                	mov    %eax,%edx
        return 0;
  8026a0:	b8 00 00 00 00       	mov    $0x0,%eax
	// But the file descriptor might still be open elsewhere
	// (because of fork and dup).  Use pageref to check.
	//
	// LAB 5: Your code here.
    //cprintf("%d\n", pageref(fd));
    if (pageref(fd) > 1)
  8026a5:	83 fa 01             	cmp    $0x1,%edx
  8026a8:	7f 1e                	jg     8026c8 <_ZL13devfile_closeP2Fd+0x3c>
        return 0;
    struct Inode *ino;
    int r;
    if ((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8026aa:	8b 43 0c             	mov    0xc(%ebx),%eax
  8026ad:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8026b0:	e8 92 fc ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	78 0f                	js     8026c8 <_ZL13devfile_closeP2Fd+0x3c>
        return r;
    ino->i_opencount--;
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	83 a8 f8 0f 00 00 01 	subl   $0x1,0xff8(%eax)
    return inode_close(ino);
  8026c3:	e8 7d fe ff ff       	call   802545 <_ZL11inode_closeP5Inode>
}
  8026c8:	83 c4 24             	add    $0x24,%esp
  8026cb:	5b                   	pop    %ebx
  8026cc:	5d                   	pop    %ebp
  8026cd:	c3                   	ret    

008026ce <_ZL13devfile_writeP2FdPKvj>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
  8026d1:	57                   	push   %edi
  8026d2:	56                   	push   %esi
  8026d3:	53                   	push   %ebx
  8026d4:	83 ec 3c             	sub    $0x3c,%esp
  8026d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8026da:	8b 75 10             	mov    0x10(%ebp),%esi
	// Be careful of block boundaries!
	// Flush any blocks you change using BCREQ_FLUSH.
	//
	// LAB 5: Your code here.
    int r;
    size_t orig_offset = fd->fd_offset;
  8026dd:	8b 43 04             	mov    0x4(%ebx),%eax
  8026e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  8026e3:	8b 43 0c             	mov    0xc(%ebx),%eax
  8026e6:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  8026e9:	e8 59 fc ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	0f 88 8c 00 00 00    	js     802782 <_ZL13devfile_writeP2FdPKvj+0xb4>
        return r;
    void *data;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  8026f6:	8b 53 04             	mov    0x4(%ebx),%edx
  8026f9:	8d ba ff 0f 00 00    	lea    0xfff(%edx),%edi
  8026ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  802705:	29 d7                	sub    %edx,%edi
  802707:	39 f7                	cmp    %esi,%edi
  802709:	0f 47 fe             	cmova  %esi,%edi
    if (n2 > n)
        n2 = n;
    if(n2)
  80270c:	85 ff                	test   %edi,%edi
  80270e:	74 16                	je     802726 <_ZL13devfile_writeP2FdPKvj+0x58>
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802710:	8d 14 17             	lea    (%edi,%edx,1),%edx
  802713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802716:	3b 50 08             	cmp    0x8(%eax),%edx
  802719:	76 6f                	jbe    80278a <_ZL13devfile_writeP2FdPKvj+0xbc>
           inode_set_size(ino, fd->fd_offset + n2) < 0)
  80271b:	e8 a0 fc ff ff       	call   8023c0 <_ZL14inode_set_sizeP5Inodej>
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
  802720:	85 c0                	test   %eax,%eax
  802722:	79 66                	jns    80278a <_ZL13devfile_writeP2FdPKvj+0xbc>
  802724:	eb 4e                	jmp    802774 <_ZL13devfile_writeP2FdPKvj+0xa6>
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  802726:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  80272c:	76 24                	jbe    802752 <_ZL13devfile_writeP2FdPKvj+0x84>
  80272e:	89 f7                	mov    %esi,%edi
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  802730:	8b 53 04             	mov    0x4(%ebx),%edx
  802733:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273c:	3b 50 08             	cmp    0x8(%eax),%edx
  80273f:	0f 86 83 00 00 00    	jbe    8027c8 <_ZL13devfile_writeP2FdPKvj+0xfa>
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
  802745:	e8 76 fc ff ff       	call   8023c0 <_ZL14inode_set_sizeP5Inodej>
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
  80274a:	85 c0                	test   %eax,%eax
  80274c:	79 7a                	jns    8027c8 <_ZL13devfile_writeP2FdPKvj+0xfa>
  80274e:	66 90                	xchg   %ax,%ax
  802750:	eb 22                	jmp    802774 <_ZL13devfile_writeP2FdPKvj+0xa6>
        bcache_ipc(data, BCREQ_FLUSH);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  802752:	85 f6                	test   %esi,%esi
  802754:	74 1e                	je     802774 <_ZL13devfile_writeP2FdPKvj+0xa6>
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  802756:	89 f2                	mov    %esi,%edx
  802758:	03 53 04             	add    0x4(%ebx),%edx
  80275b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275e:	3b 50 08             	cmp    0x8(%eax),%edx
  802761:	0f 86 b8 00 00 00    	jbe    80281f <_ZL13devfile_writeP2FdPKvj+0x151>
           inode_set_size(ino, fd->fd_offset + n) < 0)
  802767:	e8 54 fc ff ff       	call   8023c0 <_ZL14inode_set_sizeP5Inodej>
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
  80276c:	85 c0                	test   %eax,%eax
  80276e:	0f 89 ab 00 00 00    	jns    80281f <_ZL13devfile_writeP2FdPKvj+0x151>
        bcache_ipc(data, BCREQ_FLUSH);
        fd->fd_offset += n;
    }

wrapup:
    inode_close(ino);
  802774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802777:	e8 c9 fd ff ff       	call   802545 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  80277c:	8b 43 04             	mov    0x4(%ebx),%eax
  80277f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
}
  802782:	83 c4 3c             	add    $0x3c,%esp
  802785:	5b                   	pop    %ebx
  802786:	5e                   	pop    %esi
  802787:	5f                   	pop    %edi
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    if(n2)
    {
        n -= n2;
  80278a:	29 fe                	sub    %edi,%esi
        if(fd->fd_offset + n2 > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n2) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80278c:	8b 53 04             	mov    0x4(%ebx),%edx
  80278f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802792:	e8 39 fa ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
  802797:	89 45 d0             	mov    %eax,-0x30(%ebp)
        memcpy(data, buf, n2);
  80279a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80279e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027a8:	89 04 24             	mov    %eax,(%esp)
  8027ab:	e8 f7 ea ff ff       	call   8012a7 <memcpy>
        fd->fd_offset += n2;
  8027b0:	01 7b 04             	add    %edi,0x4(%ebx)
        bcache_ipc(data, BCREQ_FLUSH);
  8027b3:	ba 04 00 00 00       	mov    $0x4,%edx
  8027b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027bb:	e8 cb fa ff ff       	call   80228b <_ZL10bcache_ipcPvi>
        buf = (void *)((char *)buf + n2);
  8027c0:	01 7d 0c             	add    %edi,0xc(%ebp)
  8027c3:	e9 5e ff ff ff       	jmp    802726 <_ZL13devfile_writeP2FdPKvj+0x58>
    while (n / PGSIZE)
    {
        if(fd->fd_offset + PGSIZE > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + PGSIZE) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  8027c8:	8b 53 04             	mov    0x4(%ebx),%edx
  8027cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ce:	e8 fd f9 ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
  8027d3:	89 c6                	mov    %eax,%esi
        memcpy(data, buf, PGSIZE);
  8027d5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8027dc:	00 
  8027dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e4:	89 34 24             	mov    %esi,(%esp)
  8027e7:	e8 bb ea ff ff       	call   8012a7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  8027ec:	ba 04 00 00 00       	mov    $0x4,%edx
  8027f1:	89 f0                	mov    %esi,%eax
  8027f3:	e8 93 fa ff ff       	call   80228b <_ZL10bcache_ipcPvi>
        n -= PGSIZE;
  8027f8:	81 ef 00 10 00 00    	sub    $0x1000,%edi
        buf = (void *)((char *)buf + PGSIZE);
  8027fe:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
        fd->fd_offset += PGSIZE;
  802805:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
        memcpy(data, buf, n2);
        fd->fd_offset += n2;
        bcache_ipc(data, BCREQ_FLUSH);
        buf = (void *)((char *)buf + n2);
    }
    while (n / PGSIZE)
  80280c:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802812:	0f 87 18 ff ff ff    	ja     802730 <_ZL13devfile_writeP2FdPKvj+0x62>
  802818:	89 fe                	mov    %edi,%esi
  80281a:	e9 33 ff ff ff       	jmp    802752 <_ZL13devfile_writeP2FdPKvj+0x84>
    if (n > 0)
    {
        if(fd->fd_offset + n > (size_t)ino->i_size && 
           inode_set_size(ino, fd->fd_offset + n) < 0)
            goto wrapup;
        data = inode_data(ino, fd->fd_offset);
  80281f:	8b 53 04             	mov    0x4(%ebx),%edx
  802822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802825:	e8 a6 f9 ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
  80282a:	89 c7                	mov    %eax,%edi
        memcpy(data, buf, n);
  80282c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802830:	8b 45 0c             	mov    0xc(%ebp),%eax
  802833:	89 44 24 04          	mov    %eax,0x4(%esp)
  802837:	89 3c 24             	mov    %edi,(%esp)
  80283a:	e8 68 ea ff ff       	call   8012a7 <memcpy>
        bcache_ipc(data, BCREQ_FLUSH);
  80283f:	ba 04 00 00 00       	mov    $0x4,%edx
  802844:	89 f8                	mov    %edi,%eax
  802846:	e8 40 fa ff ff       	call   80228b <_ZL10bcache_ipcPvi>
        fd->fd_offset += n;
  80284b:	01 73 04             	add    %esi,0x4(%ebx)
  80284e:	e9 21 ff ff ff       	jmp    802774 <_ZL13devfile_writeP2FdPKvj+0xa6>

00802853 <_ZL12devfile_readP2FdPvj>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
  802856:	57                   	push   %edi
  802857:	56                   	push   %esi
  802858:	53                   	push   %ebx
  802859:	83 ec 3c             	sub    $0x3c,%esp
  80285c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80285f:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Use inode_open, inode_close, and inode_data.
	// Be careful of block boundaries!
	//
	// LAB 5: Your code here.
    int r;
    ssize_t orig_offset = fd->fd_offset;
  802862:	8b 43 04             	mov    0x4(%ebx),%eax
  802865:	89 45 d0             	mov    %eax,-0x30(%ebp)
    struct Inode *ino;
    if((r = inode_open(fd->fd_file.inum, &ino)) < 0)
  802868:	8b 43 0c             	mov    0xc(%ebx),%eax
  80286b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  80286e:	e8 d4 fa ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  802873:	85 c0                	test   %eax,%eax
  802875:	0f 88 d3 00 00 00    	js     80294e <_ZL12devfile_readP2FdPvj+0xfb>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
  80287b:	8b 73 04             	mov    0x4(%ebx),%esi
  80287e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802881:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
        n = ino->i_size - fd->fd_offset;
  802884:	8b 50 08             	mov    0x8(%eax),%edx
  802887:	29 f2                	sub    %esi,%edx
  802889:	3b 48 08             	cmp    0x8(%eax),%ecx
  80288c:	0f 47 fa             	cmova  %edx,%edi
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
    if (n2 > n)
        n2 = n;
    n -= n2;
    if((data = inode_data(ino, fd->fd_offset)) == 0)
  80288f:	89 f2                	mov    %esi,%edx
  802891:	e8 3a f9 ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
  802896:	85 c0                	test   %eax,%eax
  802898:	0f 84 a2 00 00 00    	je     802940 <_ZL12devfile_readP2FdPvj+0xed>
        return r;

    void *data;
    if (n + fd->fd_offset > (size_t)ino->i_size)
        n = ino->i_size - fd->fd_offset;
    size_t n2 = ROUNDUP(fd->fd_offset, PGSIZE) - fd->fd_offset;
  80289e:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  8028a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8028aa:	29 f2                	sub    %esi,%edx
  8028ac:	39 d7                	cmp    %edx,%edi
  8028ae:	0f 46 d7             	cmovbe %edi,%edx
  8028b1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    if (n2 > n)
        n2 = n;
    n -= n2;
  8028b4:	29 d7                	sub    %edx,%edi
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
  8028b6:	01 d6                	add    %edx,%esi
  8028b8:	89 73 04             	mov    %esi,0x4(%ebx)
    memcpy(buf, data, n2);
  8028bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c6:	89 04 24             	mov    %eax,(%esp)
  8028c9:	e8 d9 e9 ff ff       	call   8012a7 <memcpy>
    buf = (void *)((char *)buf + n2);
  8028ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028d1:	03 75 d4             	add    -0x2c(%ebp),%esi
    while (n / PGSIZE)
  8028d4:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  8028da:	76 3e                	jbe    80291a <_ZL12devfile_readP2FdPvj+0xc7>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  8028dc:	8b 53 04             	mov    0x4(%ebx),%edx
  8028df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e2:	e8 e9 f8 ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	74 55                	je     802940 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, PGSIZE);
  8028eb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8028f2:	00 
  8028f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f7:	89 34 24             	mov    %esi,(%esp)
  8028fa:	e8 a8 e9 ff ff       	call   8012a7 <memcpy>
        n -= PGSIZE;
  8028ff:	81 ef 00 10 00 00    	sub    $0x1000,%edi
//
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
  802905:	81 c6 00 10 00 00    	add    $0x1000,%esi
        if((data = inode_data(ino, fd->fd_offset)) == 0)
            goto wrapup;
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
  80290b:	81 43 04 00 10 00 00 	addl   $0x1000,0x4(%ebx)
    if((data = inode_data(ino, fd->fd_offset)) == 0)
        goto wrapup;
    fd->fd_offset += n2;
    memcpy(buf, data, n2);
    buf = (void *)((char *)buf + n2);
    while (n / PGSIZE)
  802912:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
  802918:	77 c2                	ja     8028dc <_ZL12devfile_readP2FdPvj+0x89>
        memcpy(buf, data, PGSIZE);
        n -= PGSIZE;
        buf = (void *)((char *)buf + PGSIZE);
        fd->fd_offset += PGSIZE;
    }
    if (n > 0)
  80291a:	85 ff                	test   %edi,%edi
  80291c:	74 22                	je     802940 <_ZL12devfile_readP2FdPvj+0xed>
    {
        if((data = inode_data(ino, fd->fd_offset)) == 0)
  80291e:	8b 53 04             	mov    0x4(%ebx),%edx
  802921:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802924:	e8 a7 f8 ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
  802929:	85 c0                	test   %eax,%eax
  80292b:	74 13                	je     802940 <_ZL12devfile_readP2FdPvj+0xed>
            goto wrapup;
        memcpy(buf, data, n);
  80292d:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802931:	89 44 24 04          	mov    %eax,0x4(%esp)
  802935:	89 34 24             	mov    %esi,(%esp)
  802938:	e8 6a e9 ff ff       	call   8012a7 <memcpy>
        fd->fd_offset += n;
  80293d:	01 7b 04             	add    %edi,0x4(%ebx)
    }

wrapup:
    inode_close(ino);
  802940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802943:	e8 fd fb ff ff       	call   802545 <_ZL11inode_closeP5Inode>
    return fd->fd_offset - orig_offset;
  802948:	8b 43 04             	mov    0x4(%ebx),%eax
  80294b:	2b 45 d0             	sub    -0x30(%ebp),%eax
}
  80294e:	83 c4 3c             	add    $0x3c,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    

00802956 <_ZL9path_walkPKcPP5InodePP8Direntryi>:
//
static int
path_walk(const char *path,
	  struct Inode **dirino_store, struct Direntry **de_store,
	  int create)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	57                   	push   %edi
  80295a:	56                   	push   %esi
  80295b:	53                   	push   %ebx
  80295c:	83 ec 4c             	sub    $0x4c,%esp
  80295f:	89 c6                	mov    %eax,%esi
  802961:	89 55 bc             	mov    %edx,-0x44(%ebp)
  802964:	89 4d b8             	mov    %ecx,-0x48(%ebp)
	struct Inode *ino, *next_ino;
	struct Direntry *de;
	const char *component;
	int component_len;

	*dirino_store = 0;
  802967:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	*de_store = 0;
  80296d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if ((r = inode_open(1, &ino)) < 0)
  802976:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  802979:	b8 01 00 00 00       	mov    $0x1,%eax
  80297e:	e8 c4 f9 ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  802983:	89 c7                	mov    %eax,%edi
  802985:	85 c0                	test   %eax,%eax
  802987:	0f 88 cd 01 00 00    	js     802b5a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  80298d:	89 f3                	mov    %esi,%ebx
  80298f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  802992:	75 08                	jne    80299c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x46>
		++path;
  802994:	83 c3 01             	add    $0x1,%ebx

static const char *
path_next_component(const char *path,
		    const char **component, int *component_len)
{
	while (*path == '/')
  802997:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  80299a:	74 f8                	je     802994 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x3e>
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  80299c:	0f b6 03             	movzbl (%ebx),%eax
  80299f:	3c 2f                	cmp    $0x2f,%al
  8029a1:	74 16                	je     8029b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8029a3:	84 c0                	test   %al,%al
  8029a5:	74 12                	je     8029b9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x63>
  8029a7:	89 da                	mov    %ebx,%edx
		++path;
  8029a9:	83 c2 01             	add    $0x1,%edx
		    const char **component, int *component_len)
{
	while (*path == '/')
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
  8029ac:	0f b6 02             	movzbl (%edx),%eax
  8029af:	3c 2f                	cmp    $0x2f,%al
  8029b1:	74 08                	je     8029bb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8029b3:	84 c0                	test   %al,%al
  8029b5:	75 f2                	jne    8029a9 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x53>
  8029b7:	eb 02                	jmp    8029bb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x65>
  8029b9:	89 da                	mov    %ebx,%edx
		++path;
	*component_len = path - *component;
  8029bb:	89 d0                	mov    %edx,%eax
  8029bd:	29 d8                	sub    %ebx,%eax
  8029bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	while (*path == '/')
  8029c2:	0f b6 02             	movzbl (%edx),%eax
  8029c5:	89 d6                	mov    %edx,%esi
  8029c7:	3c 2f                	cmp    $0x2f,%al
  8029c9:	75 0a                	jne    8029d5 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x7f>
		++path;
  8029cb:	83 c6 01             	add    $0x1,%esi
		++path;
	*component = path;
	while (*path != '/' && *path != 0)
		++path;
	*component_len = path - *component;
	while (*path == '/')
  8029ce:	0f b6 06             	movzbl (%esi),%eax
  8029d1:	3c 2f                	cmp    $0x2f,%al
  8029d3:	74 f6                	je     8029cb <_ZL9path_walkPKcPP5InodePP8Direntryi+0x75>
	while (1) {
		// Find next path component
		path = path_next_component(path, &component, &component_len);

		// Special case: root directory
		if (component_len == 0) {
  8029d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8029d9:	75 1b                	jne    8029f6 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xa0>
			*dirino_store = ino;
  8029db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029de:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8029e1:	89 02                	mov    %eax,(%edx)
			*de_store = &super->s_root;
  8029e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029e6:	c7 00 0c 10 00 50    	movl   $0x5000100c,(%eax)
			return 0;
  8029ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f1:	e9 64 01 00 00       	jmp    802b5a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  8029f6:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
  8029fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fe:	74 06                	je     802a06 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xb0>
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802a00:	84 c0                	test   %al,%al
  802a02:	0f 94 45 cb          	sete   -0x35(%ebp)
		}

		// Look up directory component
		// (This is the last path component iff *path == 0.)
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
  802a06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a09:	89 55 d0             	mov    %edx,-0x30(%ebp)
	off_t off;
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
  802a0c:	83 3a 02             	cmpl   $0x2,(%edx)
  802a0f:	0f 85 f4 00 00 00    	jne    802b09 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1b3>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802a15:	89 d0                	mov    %edx,%eax
  802a17:	8b 52 08             	mov    0x8(%edx),%edx
  802a1a:	85 d2                	test   %edx,%edx
  802a1c:	7e 78                	jle    802a96 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x140>
  802a1e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  802a25:	bf 00 00 00 00       	mov    $0x0,%edi
  802a2a:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  802a2d:	89 fb                	mov    %edi,%ebx
  802a2f:	89 75 c0             	mov    %esi,-0x40(%ebp)
  802a32:	89 c6                	mov    %eax,%esi
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802a34:	89 da                	mov    %ebx,%edx
  802a36:	89 f0                	mov    %esi,%eax
  802a38:	e8 93 f7 ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
  802a3d:	89 c7                	mov    %eax,%edi

		if (de->de_inum != 0
  802a3f:	83 38 00             	cmpl   $0x0,(%eax)
  802a42:	74 26                	je     802a6a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x114>
  802a44:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a47:	3b 50 04             	cmp    0x4(%eax),%edx
  802a4a:	75 33                	jne    802a7f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
		    && de->de_namelen == namelen
		    && memcmp(de->de_name, name, namelen) == 0) {
  802a4c:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a50:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a57:	8d 47 08             	lea    0x8(%edi),%eax
  802a5a:	89 04 24             	mov    %eax,(%esp)
  802a5d:	e8 86 e8 ff ff       	call   8012e8 <memcmp>
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);

		if (de->de_inum != 0
  802a62:	85 c0                	test   %eax,%eax
  802a64:	0f 84 fa 00 00 00    	je     802b64 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x20e>
		    && memcmp(de->de_name, name, namelen) == 0) {
			*de_store = de;
			return 0;
		}

		if (de->de_inum == 0 && !empty)
  802a6a:	83 3f 00             	cmpl   $0x0,(%edi)
  802a6d:	75 10                	jne    802a7f <_ZL9path_walkPKcPP5InodePP8Direntryi+0x129>
  802a6f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a73:	0f 94 c0             	sete   %al

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
		struct Direntry *de = (struct Direntry *) inode_data(ino, off);
  802a76:	84 c0                	test   %al,%al
  802a78:	0f 44 7d cc          	cmove  -0x34(%ebp),%edi
  802a7c:	89 7d cc             	mov    %edi,-0x34(%ebp)
//
// Returns 0 on success, < 0 on error.
// Error codes: See dir_find().
//
static int
path_walk(const char *path,
  802a7f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  802a85:	89 c3                	mov    %eax,%ebx
	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;

	for (off = 0; off < ino->i_size; off += sizeof(struct Direntry)) {
  802a87:	8b 56 08             	mov    0x8(%esi),%edx
  802a8a:	39 d0                	cmp    %edx,%eax
  802a8c:	7c a6                	jl     802a34 <_ZL9path_walkPKcPP5InodePP8Direntryi+0xde>
  802a8e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  802a91:	8b 75 c0             	mov    -0x40(%ebp),%esi
  802a94:	eb 07                	jmp    802a9d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x147>
  802a96:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)

		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
  802a9d:	80 7d cb 00          	cmpb   $0x0,-0x35(%ebp)
  802aa1:	74 6d                	je     802b10 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1ba>
		return -E_NOT_FOUND;

	if (!empty) {
  802aa3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802aa7:	75 24                	jne    802acd <_ZL9path_walkPKcPP5InodePP8Direntryi+0x177>
		int r = inode_set_size(ino, ino->i_size + sizeof(struct Direntry));
  802aa9:	83 ea 80             	sub    $0xffffff80,%edx
  802aac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802aaf:	e8 0c f9 ff ff       	call   8023c0 <_ZL14inode_set_sizeP5Inodej>
		if (r < 0)
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	0f 88 90 00 00 00    	js     802b4c <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1f6>
			return r;
		empty = (struct Direntry *) inode_data(ino, ino->i_size - sizeof(struct Direntry));
  802abc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802abf:	8b 50 08             	mov    0x8(%eax),%edx
  802ac2:	83 c2 80             	add    $0xffffff80,%edx
  802ac5:	e8 06 f7 ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
  802aca:	89 45 cc             	mov    %eax,-0x34(%ebp)
	}

	memset(empty, 0, sizeof(struct Direntry));
  802acd:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
  802ad4:	00 
  802ad5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802adc:	00 
  802add:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ae0:	89 14 24             	mov    %edx,(%esp)
  802ae3:	e8 e9 e6 ff ff       	call   8011d1 <memset>
	empty->de_namelen = namelen;
  802ae8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802aeb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aee:	89 50 04             	mov    %edx,0x4(%eax)
	memcpy(empty->de_name, name, namelen);
  802af1:	89 54 24 08          	mov    %edx,0x8(%esp)
  802af5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802af9:	83 c0 08             	add    $0x8,%eax
  802afc:	89 04 24             	mov    %eax,(%esp)
  802aff:	e8 a3 e7 ff ff       	call   8012a7 <memcpy>
	*de_store = empty;
  802b04:	8b 7d cc             	mov    -0x34(%ebp),%edi
  802b07:	eb 5e                	jmp    802b67 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x211>
	struct Direntry *empty = 0;

	*de_store = 0;

	if (ino->i_ftype != FTYPE_DIR)
		return -E_BAD_PATH;
  802b09:	bf f3 ff ff ff       	mov    $0xfffffff3,%edi
  802b0e:	eb 42                	jmp    802b52 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
		if (de->de_inum == 0 && !empty)
			empty = de;
	}

	if (!create)
		return -E_NOT_FOUND;
  802b10:	bf f4 ff ff ff       	mov    $0xfffffff4,%edi
  802b15:	eb 3b                	jmp    802b52 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
			*dirino_store = ino;
  802b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b1a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802b1d:	89 02                	mov    %eax,(%edx)
			*de_store = de;
  802b1f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b22:	89 38                	mov    %edi,(%eax)
			return 0;
  802b24:	bf 00 00 00 00       	mov    $0x0,%edi
  802b29:	eb 2f                	jmp    802b5a <_ZL9path_walkPKcPP5InodePP8Direntryi+0x204>
		}

		// Otherwise, walk into subdirectory.
		// Always open the next inode before closing the current one.
		if ((r = inode_open(de->de_inum, &next_ino)) < 0)
  802b2b:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802b2e:	8b 07                	mov    (%edi),%eax
  802b30:	e8 12 f8 ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  802b35:	85 c0                	test   %eax,%eax
  802b37:	78 17                	js     802b50 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fa>
			goto fail;
		inode_close(ino);
  802b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3c:	e8 04 fa ff ff       	call   802545 <_ZL11inode_closeP5Inode>
		ino = next_ino;
  802b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*dirino_store = 0;
	*de_store = 0;
	if ((r = inode_open(1, &ino)) < 0)
		return r;

	while (1) {
  802b47:	e9 41 fe ff ff       	jmp    80298d <_ZL9path_walkPKcPP5InodePP8Direntryi+0x37>
  802b4c:	89 c7                	mov    %eax,%edi
  802b4e:	eb 02                	jmp    802b52 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1fc>
  802b50:	89 c7                	mov    %eax,%edi
		inode_close(ino);
		ino = next_ino;
	}

 fail:
	inode_close(ino);
  802b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b55:	e8 eb f9 ff ff       	call   802545 <_ZL11inode_closeP5Inode>
	return r;
}
  802b5a:	89 f8                	mov    %edi,%eax
  802b5c:	83 c4 4c             	add    $0x4c,%esp
  802b5f:	5b                   	pop    %ebx
  802b60:	5e                   	pop    %esi
  802b61:	5f                   	pop    %edi
  802b62:	5d                   	pop    %ebp
  802b63:	c3                   	ret    
  802b64:	8b 75 c0             	mov    -0x40(%ebp),%esi
		if ((r = dir_find(ino, component, component_len, &de,
				  create && *path == 0)) < 0)
			goto fail;

		// If done, return this direntry
		if (*path == 0) {
  802b67:	80 3e 00             	cmpb   $0x0,(%esi)
  802b6a:	75 bf                	jne    802b2b <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1d5>
  802b6c:	eb a9                	jmp    802b17 <_ZL9path_walkPKcPP5InodePP8Direntryi+0x1c1>

00802b6e <_Z4openPKci>:
//	-E_MAX_FD if no more file descriptors
//	-E_NOT_FOUND if the file (or a path component) was not found
//	(and others)
int
open(const char *path, int mode)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
  802b71:	57                   	push   %edi
  802b72:	56                   	push   %esi
  802b73:	53                   	push   %ebx
  802b74:	83 ec 3c             	sub    $0x3c,%esp
  802b77:	8b 75 08             	mov    0x8(%ebp),%esi
	// and allocate a page there (PTE_P|PTE_U|PTE_W|PTE_SHARE).
	//
	// LAB 5: Your code here
    int r;
    struct Fd *fd;
    if((r = fd_find_unused(&fd)) < 0 || 
  802b7a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b7d:	89 04 24             	mov    %eax,(%esp)
  802b80:	e8 62 f0 ff ff       	call   801be7 <_Z14fd_find_unusedPP2Fd>
  802b85:	89 c3                	mov    %eax,%ebx
  802b87:	85 c0                	test   %eax,%eax
  802b89:	0f 88 16 02 00 00    	js     802da5 <_Z4openPKci+0x237>
  802b8f:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b96:	00 
  802b97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ba5:	e8 c6 e9 ff ff       	call   801570 <_Z14sys_page_allociPvi>
  802baa:	89 c3                	mov    %eax,%ebx
  802bac:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb1:	85 db                	test   %ebx,%ebx
  802bb3:	0f 88 ec 01 00 00    	js     802da5 <_Z4openPKci+0x237>
	// The root directory is a special case -- if you aren't careful,
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
  802bb9:	80 3c 06 00          	cmpb   $0x0,(%esi,%eax,1)
  802bbd:	0f 84 ec 01 00 00    	je     802daf <_Z4openPKci+0x241>
  802bc3:	83 c0 01             	add    $0x1,%eax
  802bc6:	83 f8 78             	cmp    $0x78,%eax
  802bc9:	75 ee                	jne    802bb9 <_Z4openPKci+0x4b>
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802bcb:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
  802bd0:	e9 b9 01 00 00       	jmp    802d8e <_Z4openPKci+0x220>
        goto err2;
    }
    struct Inode *dirino;
    struct Direntry *de;
    if((r = path_walk(path, &dirino, &de, mode & O_CREAT)))
  802bd5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802bd8:	81 e7 00 01 00 00    	and    $0x100,%edi
  802bde:	89 3c 24             	mov    %edi,(%esp)
  802be1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  802be4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  802be7:	89 f0                	mov    %esi,%eax
  802be9:	e8 68 fd ff ff       	call   802956 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802bee:	89 c3                	mov    %eax,%ebx
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	0f 85 96 01 00 00    	jne    802d8e <_Z4openPKci+0x220>
        goto err2;
    struct Inode *fileino;
    
    if(!(mode & O_CREAT))
  802bf8:	85 ff                	test   %edi,%edi
  802bfa:	75 41                	jne    802c3d <_Z4openPKci+0xcf>
    {
        if(de == &super->s_root)
  802bfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bff:	3d 0c 10 00 50       	cmp    $0x5000100c,%eax
  802c04:	75 08                	jne    802c0e <_Z4openPKci+0xa0>
            fileino = dirino;
  802c06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802c0c:	eb 14                	jmp    802c22 <_Z4openPKci+0xb4>
        else if((r = inode_open(de->de_inum, &fileino)) < 0)
  802c0e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	e8 2f f7 ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  802c18:	89 c3                	mov    %eax,%ebx
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	0f 88 5d 01 00 00    	js     802d7f <_Z4openPKci+0x211>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
  802c22:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c25:	83 38 02             	cmpl   $0x2,(%eax)
  802c28:	0f 85 d2 00 00 00    	jne    802d00 <_Z4openPKci+0x192>
  802c2e:	f6 45 0c 03          	testb  $0x3,0xc(%ebp)
  802c32:	0f 84 c8 00 00 00    	je     802d00 <_Z4openPKci+0x192>
  802c38:	e9 38 01 00 00       	jmp    802d75 <_Z4openPKci+0x207>
inode_alloc(struct Inode **ino_store)
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
  802c3d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802c44:	83 3d 08 10 00 50 02 	cmpl   $0x2,0x50001008
  802c4b:	0f 8e a8 00 00 00    	jle    802cf9 <_Z4openPKci+0x18b>
  802c51:	bf 02 00 00 00       	mov    $0x2,%edi
		if ((r = inode_open(inum, &ino)) < 0)
  802c56:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  802c59:	89 f8                	mov    %edi,%eax
  802c5b:	e8 e7 f6 ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  802c60:	89 c3                	mov    %eax,%ebx
  802c62:	85 c0                	test   %eax,%eax
  802c64:	0f 88 15 01 00 00    	js     802d7f <_Z4openPKci+0x211>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
  802c6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c6d:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  802c71:	75 68                	jne    802cdb <_Z4openPKci+0x16d>
  802c73:	83 b8 f8 0f 00 00 01 	cmpl   $0x1,0xff8(%eax)
  802c7a:	75 5f                	jne    802cdb <_Z4openPKci+0x16d>
			*ino_store = ino;
  802c7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    }
    else 
    {
        if((r = inode_alloc(&fileino)) < 0)
            goto err3;
        fileino->i_ftype = FTYPE_REG;
  802c7f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        fileino->i_refcount = 1;
  802c85:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c88:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
        fileino->i_size = 0;
  802c8f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        memset(&fileino->i_direct, 0, NDIRECT * sizeof (blocknum_t));
  802c96:	c7 44 24 08 e8 0f 00 	movl   $0xfe8,0x8(%esp)
  802c9d:	00 
  802c9e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802ca5:	00 
  802ca6:	83 c0 0c             	add    $0xc,%eax
  802ca9:	89 04 24             	mov    %eax,(%esp)
  802cac:	e8 20 e5 ff ff       	call   8011d1 <memset>
        de->de_inum = fileino->i_inum;
  802cb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cb4:	8b 90 f4 0f 00 00    	mov    0xff4(%eax),%edx
  802cba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cbd:	89 10                	mov    %edx,(%eax)
        bcache_ipc(fileino, BCREQ_FLUSH); 
  802cbf:	ba 04 00 00 00       	mov    $0x4,%edx
  802cc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cc7:	e8 bf f5 ff ff       	call   80228b <_ZL10bcache_ipcPvi>
        bcache_ipc(dirino, BCREQ_FLUSH); 
  802ccc:	ba 04 00 00 00       	mov    $0x4,%edx
  802cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd4:	e8 b2 f5 ff ff       	call   80228b <_ZL10bcache_ipcPvi>
  802cd9:	eb 25                	jmp    802d00 <_Z4openPKci+0x192>
			return r;
		if (ino->i_refcount == 0 && ino->i_opencount == 1) {
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
  802cdb:	e8 65 f8 ff ff       	call   802545 <_ZL11inode_closeP5Inode>
{
	inum_t inum;
	int r;
	struct Inode *ino;
	*ino_store = 0;
	for (inum = 2; inum < super->s_ninodes; ++inum) {
  802ce0:	83 c7 01             	add    $0x1,%edi
  802ce3:	3b 3d 08 10 00 50    	cmp    0x50001008,%edi
  802ce9:	0f 8c 67 ff ff ff    	jl     802c56 <_Z4openPKci+0xe8>
			*ino_store = ino;
			return 0;
		}
		inode_close(ino);
	}
	return -E_NO_DISK;
  802cef:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802cf4:	e9 86 00 00 00       	jmp    802d7f <_Z4openPKci+0x211>
  802cf9:	bb f6 ff ff ff       	mov    $0xfffffff6,%ebx
  802cfe:	eb 7f                	jmp    802d7f <_Z4openPKci+0x211>
    }
	// If '(mode & O_TRUNC) != 0' and the open mode is not read-only,
	// set the file's length to 0.  Flush any blocks you change.
	//
	// LAB 5: Your code here (Exercise 8).
    if((mode & O_TRUNC))
  802d00:	f7 45 0c 00 02 00 00 	testl  $0x200,0xc(%ebp)
  802d07:	74 0d                	je     802d16 <_Z4openPKci+0x1a8>
    {
        inode_set_size(fileino, 0);
  802d09:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d11:	e8 aa f6 ff ff       	call   8023c0 <_ZL14inode_set_sizeP5Inodej>
	// error messages later.
	// You must account for the open file reference in the inode as well.
	// Clean up any open inodes.
	//
	// LAB 5: Your code here (Exercise 4).
    fd->fd_dev_id = devfile.dev_id;
  802d16:	8b 15 08 60 80 00    	mov    0x806008,%edx
  802d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1f:	89 10                	mov    %edx,(%eax)
    fd->fd_offset = 0;
  802d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    fd->fd_omode = mode;
  802d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d2e:	89 50 08             	mov    %edx,0x8(%eax)
    fd->fd_file.inum = fileino->i_inum; 
  802d31:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d34:	8b 92 f4 0f 00 00    	mov    0xff4(%edx),%edx
  802d3a:	89 50 0c             	mov    %edx,0xc(%eax)
    strcpy(fd->fd_file.open_path, path);
  802d3d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d41:	83 c0 10             	add    $0x10,%eax
  802d44:	89 04 24             	mov    %eax,(%esp)
  802d47:	e8 3e e3 ff ff       	call   80108a <_Z6strcpyPcPKc>
    fileino->i_opencount++;
  802d4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d4f:	83 80 f8 0f 00 00 01 	addl   $0x1,0xff8(%eax)
    inode_close(dirino);
  802d56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d59:	e8 e7 f7 ff ff       	call   802545 <_ZL11inode_closeP5Inode>
    inode_close(fileino);
  802d5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d61:	e8 df f7 ff ff       	call   802545 <_ZL11inode_closeP5Inode>
    return fd2num(fd);
  802d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d69:	89 04 24             	mov    %eax,(%esp)
  802d6c:	e8 13 ee ff ff       	call   801b84 <_Z6fd2numP2Fd>
  802d71:	89 c3                	mov    %eax,%ebx
  802d73:	eb 30                	jmp    802da5 <_Z4openPKci+0x237>

err4:
    inode_close(fileino);
  802d75:	e8 cb f7 ff ff       	call   802545 <_ZL11inode_closeP5Inode>
            goto err3;
        
        if(fileino->i_ftype == FTYPE_DIR && (
           mode & O_ACCMODE) != O_RDONLY)
        {
            r = -E_IS_DIR;
  802d7a:	bb ed ff ff ff       	mov    $0xffffffed,%ebx
    return fd2num(fd);

err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
  802d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d82:	e8 be f7 ff ff       	call   802545 <_ZL11inode_closeP5Inode>
  802d87:	eb 05                	jmp    802d8e <_Z4openPKci+0x220>
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
    {
        r = -E_BAD_PATH;
  802d89:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
err4:
    inode_close(fileino);
err3:
    inode_close(dirino);
err2:
    sys_page_unmap(thisenv->env_id, fd);
  802d8e:	a1 00 70 80 00       	mov    0x807000,%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d99:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d9d:	89 04 24             	mov    %eax,(%esp)
  802da0:	e8 88 e8 ff ff       	call   80162d <_Z14sys_page_unmapiPv>
err1:
    return r;
}
  802da5:	89 d8                	mov    %ebx,%eax
  802da7:	83 c4 3c             	add    $0x3c,%esp
  802daa:	5b                   	pop    %ebx
  802dab:	5e                   	pop    %esi
  802dac:	5f                   	pop    %edi
  802dad:	5d                   	pop    %ebp
  802dae:	c3                   	ret    
	// you will deadlock when the root directory is opened.  (Why?)
	//
	// LAB 5: Your code here.
    int i;
    for(i = 0; i < MAXNAMELEN && path[i]; i++); 
    if(i == MAXNAMELEN)
  802daf:	83 f8 78             	cmp    $0x78,%eax
  802db2:	0f 85 1d fe ff ff    	jne    802bd5 <_Z4openPKci+0x67>
  802db8:	eb cf                	jmp    802d89 <_Z4openPKci+0x21b>

00802dba <_Z5istatiP4Stat>:
	return 0;
}

int
istat(inum_t inum, struct Stat *stat)
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
  802dbd:	53                   	push   %ebx
  802dbe:	83 ec 24             	sub    $0x24,%esp
  802dc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Inode *ino;

	if ((r = inode_open(inum, &ino)) < 0)
  802dc4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	e8 78 f5 ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	78 27                	js     802dfa <_Z5istatiP4Stat+0x40>
		return r;

	strcpy(stat->st_name, "<inode>");
  802dd3:	c7 44 24 04 54 4c 80 	movl   $0x804c54,0x4(%esp)
  802dda:	00 
  802ddb:	89 1c 24             	mov    %ebx,(%esp)
  802dde:	e8 a7 e2 ff ff       	call   80108a <_Z6strcpyPcPKc>
	stat_base(ino, stat);
  802de3:	89 da                	mov    %ebx,%edx
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	e8 26 f4 ff ff       	call   802213 <_ZL9stat_basePK5InodeP4Stat>

	inode_close(ino);
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	e8 50 f7 ff ff       	call   802545 <_ZL11inode_closeP5Inode>
	return 0;
  802df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dfa:	83 c4 24             	add    $0x24,%esp
  802dfd:	5b                   	pop    %ebx
  802dfe:	5d                   	pop    %ebp
  802dff:	c3                   	ret    

00802e00 <_Z6unlinkPKc>:

// Deletes a file.
//
int
unlink(const char *path)
{
  802e00:	55                   	push   %ebp
  802e01:	89 e5                	mov    %esp,%ebp
  802e03:	53                   	push   %ebx
  802e04:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Inode *dirino, *ino;
	struct Direntry *de;

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
  802e07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e0e:	8d 4d ec             	lea    -0x14(%ebp),%ecx
  802e11:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	e8 3a fb ff ff       	call   802956 <_ZL9path_walkPKcPP5InodePP8Direntryi>
  802e1c:	89 c3                	mov    %eax,%ebx
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	78 5f                	js     802e81 <_Z6unlinkPKc+0x81>
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
  802e22:	8d 55 f0             	lea    -0x10(%ebp),%edx
  802e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	e8 18 f5 ff ff       	call   802347 <_ZL10inode_openiPP5Inode>
  802e2f:	89 c3                	mov    %eax,%ebx
  802e31:	85 c0                	test   %eax,%eax
  802e33:	78 44                	js     802e79 <_Z6unlinkPKc+0x79>
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
		r = -E_IS_DIR;
  802e35:	bb ed ff ff ff       	mov    $0xffffffed,%ebx

	if ((r = path_walk(path, &dirino, &de, 0)) < 0)
		goto done;
	if ((r = inode_open(de->de_inum, &ino)) < 0)
		goto closedirino;
	if (ino->i_ftype == FTYPE_DIR) {
  802e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3d:	83 38 02             	cmpl   $0x2,(%eax)
  802e40:	74 2f                	je     802e71 <_Z6unlinkPKc+0x71>
		r = -E_IS_DIR;
		goto closeino;
	}
	// clear directory entry
	de->de_inum = 0;
  802e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	--ino->i_refcount;
  802e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4e:	83 68 04 01          	subl   $0x1,0x4(%eax)
	bcache_ipc(de, BCREQ_FLUSH);
  802e52:	ba 04 00 00 00       	mov    $0x4,%edx
  802e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5a:	e8 2c f4 ff ff       	call   80228b <_ZL10bcache_ipcPvi>
	bcache_ipc(ino, BCREQ_FLUSH);
  802e5f:	ba 04 00 00 00       	mov    $0x4,%edx
  802e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e67:	e8 1f f4 ff ff       	call   80228b <_ZL10bcache_ipcPvi>
	r = 0;
  802e6c:	bb 00 00 00 00       	mov    $0x0,%ebx
 closeino:
	inode_close(ino);
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	e8 cc f6 ff ff       	call   802545 <_ZL11inode_closeP5Inode>
 closedirino:
	inode_close(dirino);
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	e8 c4 f6 ff ff       	call   802545 <_ZL11inode_closeP5Inode>
 done:
	return r;
}
  802e81:	89 d8                	mov    %ebx,%eax
  802e83:	83 c4 24             	add    $0x24,%esp
  802e86:	5b                   	pop    %ebx
  802e87:	5d                   	pop    %ebp
  802e88:	c3                   	ret    

00802e89 <_Z4syncv>:

// Synchronizes the disk with buffer cache.
//
int
sync(void)
{
  802e89:	55                   	push   %ebp
  802e8a:	89 e5                	mov    %esp,%ebp
	// Our current implementation is synchronous.
	return 0;
}
  802e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e91:	5d                   	pop    %ebp
  802e92:	c3                   	ret    

00802e93 <_Z4fsckv>:
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
{
  802e93:	55                   	push   %ebp
  802e94:	89 e5                	mov    %esp,%ebp
  802e96:	57                   	push   %edi
  802e97:	56                   	push   %esi
  802e98:	53                   	push   %ebx
  802e99:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	blocknum_t min_nblocks;
	int i, j, k;
	int errors = 0;

	add_pgfault_handler(bcache_pgfault_handler);
  802e9f:	c7 04 24 ed 25 80 00 	movl   $0x8025ed,(%esp)
  802ea6:	e8 c0 14 00 00       	call   80436b <_Z19add_pgfault_handlerPFvP10UTrapframeE>

	// superblock checks
	if (super->s_magic != FS_MAGIC)
  802eab:	a1 00 10 00 50       	mov    0x50001000,%eax
  802eb0:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  802eb5:	74 28                	je     802edf <_Z4fsckv+0x4c>
		panic("fsck: file system magic number %08x should be %08x", super->s_magic, FS_MAGIC);
  802eb7:	c7 44 24 10 ae 30 05 	movl   $0x4a0530ae,0x10(%esp)
  802ebe:	4a 
  802ebf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ec3:	c7 44 24 08 bc 4c 80 	movl   $0x804cbc,0x8(%esp)
  802eca:	00 
  802ecb:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
  802ed2:	00 
  802ed3:	c7 04 24 36 4c 80 00 	movl   $0x804c36,(%esp)
  802eda:	e8 75 da ff ff       	call   800954 <_Z6_panicPKciS0_z>
	if (super->s_nblocks < 4)
  802edf:	a1 04 10 00 50       	mov    0x50001004,%eax
  802ee4:	83 f8 03             	cmp    $0x3,%eax
  802ee7:	7f 1c                	jg     802f05 <_Z4fsckv+0x72>
		panic("fsck: file system must have at least 4 blocks");
  802ee9:	c7 44 24 08 f0 4c 80 	movl   $0x804cf0,0x8(%esp)
  802ef0:	00 
  802ef1:	c7 44 24 04 1d 03 00 	movl   $0x31d,0x4(%esp)
  802ef8:	00 
  802ef9:	c7 04 24 36 4c 80 00 	movl   $0x804c36,(%esp)
  802f00:	e8 4f da ff ff       	call   800954 <_Z6_panicPKciS0_z>
	if (super->s_ninodes < 1)
  802f05:	8b 15 08 10 00 50    	mov    0x50001008,%edx
  802f0b:	85 d2                	test   %edx,%edx
  802f0d:	7f 1c                	jg     802f2b <_Z4fsckv+0x98>
		panic("fsck: file system must have at least 1 inode");
  802f0f:	c7 44 24 08 20 4d 80 	movl   $0x804d20,0x8(%esp)
  802f16:	00 
  802f17:	c7 44 24 04 1f 03 00 	movl   $0x31f,0x4(%esp)
  802f1e:	00 
  802f1f:	c7 04 24 36 4c 80 00 	movl   $0x804c36,(%esp)
  802f26:	e8 29 da ff ff       	call   800954 <_Z6_panicPKciS0_z>
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
  802f2b:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
  802f31:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
		+ (super->s_ninodes - 1); /* inodes */
  802f37:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
  802f3d:	85 c9                	test   %ecx,%ecx
  802f3f:	0f 48 cb             	cmovs  %ebx,%ecx
  802f42:	c1 f9 0c             	sar    $0xc,%ecx
  802f45:	8d 4c 0a 01          	lea    0x1(%edx,%ecx,1),%ecx
  802f49:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
	if (super->s_nblocks < min_nblocks)
  802f4f:	39 c8                	cmp    %ecx,%eax
  802f51:	7c 13                	jl     802f66 <_Z4fsckv+0xd3>
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802f53:	85 c0                	test   %eax,%eax
  802f55:	7f 3d                	jg     802f94 <_Z4fsckv+0x101>
  802f57:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802f5e:	00 00 00 
  802f61:	e9 ac 00 00 00       	jmp    803012 <_Z4fsckv+0x17f>
		panic("fsck: file system must have at least 1 inode");
	min_nblocks = 2 /* boot sector, superblock */
		+ ROUNDUP(super->s_nblocks, BLKSIZE) / BLKSIZE /* freemap */
		+ (super->s_ninodes - 1); /* inodes */
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);
  802f66:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  802f6c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  802f70:	89 44 24 10          	mov    %eax,0x10(%esp)
  802f74:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802f78:	c7 44 24 08 50 4d 80 	movl   $0x804d50,0x8(%esp)
  802f7f:	00 
  802f80:	c7 44 24 04 24 03 00 	movl   $0x324,0x4(%esp)
  802f87:	00 
  802f88:	c7 04 24 36 4c 80 00 	movl   $0x804c36,(%esp)
  802f8f:	e8 c0 d9 ff ff       	call   800954 <_Z6_panicPKciS0_z>

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  802f94:	be 00 20 00 50       	mov    $0x50002000,%esi
  802f99:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
  802fa0:	00 00 00 
  802fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  802fa8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
		if (i < min_nblocks && freemap[i] != 0) {
  802fae:	39 df                	cmp    %ebx,%edi
  802fb0:	7e 27                	jle    802fd9 <_Z4fsckv+0x146>
  802fb2:	0f b6 06             	movzbl (%esi),%eax
  802fb5:	84 c0                	test   %al,%al
  802fb7:	74 4b                	je     803004 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 (allocated), is %d\n", i, freemap[i]);
  802fb9:	0f be c0             	movsbl %al,%eax
  802fbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802fc0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802fc4:	c7 04 24 94 4d 80 00 	movl   $0x804d94,(%esp)
  802fcb:	e8 a2 da ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  802fd0:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  802fd7:	eb 2b                	jmp    803004 <_Z4fsckv+0x171>
		} else if (freemap[i] != 0 && freemap[i] != 1) {
  802fd9:	0f b6 06             	movzbl (%esi),%eax
  802fdc:	3c 01                	cmp    $0x1,%al
  802fde:	76 24                	jbe    803004 <_Z4fsckv+0x171>
			cprintf("fsck: freemap[%d]: should be 0 or 1, is %d\n", i, freemap[i]);
  802fe0:	0f be c0             	movsbl %al,%eax
  802fe3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802fe7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802feb:	c7 04 24 c8 4d 80 00 	movl   $0x804dc8,(%esp)
  802ff2:	e8 7b da ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  802ff7:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
  802ffe:	80 3e 00             	cmpb   $0x0,(%esi)
  803001:	0f 9f 06             	setg   (%esi)
	if (super->s_nblocks < min_nblocks)
		panic("fsck: file system with %d inodes has %d blocks, needs at least %d", super->s_ninodes, super->s_nblocks, min_nblocks);

	// basic freemap checks: initial blocks not free, free blocks marked
	// with 1 (later checks will overwrite freemap)
	for (i = 0; i < super->s_nblocks; ++i)
  803004:	83 c3 01             	add    $0x1,%ebx
  803007:	83 c6 01             	add    $0x1,%esi
  80300a:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  803010:	7f 9c                	jg     802fae <_Z4fsckv+0x11b>
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  803012:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803019:	0f 8e e1 02 00 00    	jle    803300 <_Z4fsckv+0x46d>
  80301f:	c7 85 58 ff ff ff 01 	movl   $0x1,-0xa8(%ebp)
  803026:	00 00 00 
		struct Inode *ino = get_inode(i);
  803029:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80302f:	e8 f9 f1 ff ff       	call   80222d <_ZL9get_inodei>
  803034:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
  80303a:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
		if (!active && ino->i_opencount != 0
  80303e:	0f 95 85 5c ff ff ff 	setne  -0xa4(%ebp)
  803045:	75 22                	jne    803069 <_Z4fsckv+0x1d6>
  803047:	83 b8 f8 0f 00 00 00 	cmpl   $0x0,0xff8(%eax)
  80304e:	0f 84 a9 06 00 00    	je     8036fd <_Z4fsckv+0x86a>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
  803054:	ba 00 00 00 00       	mov    $0x0,%edx
  803059:	e8 2d f2 ff ff       	call   80228b <_ZL10bcache_ipcPvi>
		struct Inode *ino = get_inode(i);
		off_t true_size;
		// check for open-but-unreferenced inode; be careful of
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 3a                	je     80309c <_Z4fsckv+0x209>
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
  803062:	c6 85 5c ff ff ff 01 	movb   $0x1,-0xa4(%ebp)
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  803069:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80306f:	8b 02                	mov    (%edx),%eax
  803071:	83 f8 01             	cmp    $0x1,%eax
  803074:	74 26                	je     80309c <_Z4fsckv+0x209>
  803076:	83 f8 02             	cmp    $0x2,%eax
  803079:	74 21                	je     80309c <_Z4fsckv+0x209>
			cprintf("fsck: inode[%d]: odd i_ftype %d\n", i, ino->i_ftype);
  80307b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80307f:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803085:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803089:	c7 04 24 f4 4d 80 00 	movl   $0x804df4,(%esp)
  803090:	e8 dd d9 ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  803095:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (i == 1 && ino->i_refcount == 0) {
  80309c:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8030a3:	75 3f                	jne    8030e4 <_Z4fsckv+0x251>
  8030a5:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8030ab:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  8030af:	75 15                	jne    8030c6 <_Z4fsckv+0x233>
			cprintf("fsck: inode[1]: root inode should be referenced\n");
  8030b1:	c7 04 24 18 4e 80 00 	movl   $0x804e18,(%esp)
  8030b8:	e8 b5 d9 ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  8030bd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8030c4:	eb 1e                	jmp    8030e4 <_Z4fsckv+0x251>
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
  8030c6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8030cc:	83 3a 02             	cmpl   $0x2,(%edx)
  8030cf:	74 13                	je     8030e4 <_Z4fsckv+0x251>
			cprintf("fsck: inode[1]: root inode should be directory\n");
  8030d1:	c7 04 24 4c 4e 80 00 	movl   $0x804e4c,(%esp)
  8030d8:	e8 95 d9 ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  8030dd:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
		}
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
  8030e4:	bf 00 00 00 00       	mov    $0x0,%edi
			++errors;
		} else if (i == 1 && ino->i_ftype != FTYPE_DIR) {
			cprintf("fsck: inode[1]: root inode should be directory\n");
			++errors;
		}
		if (active && ino->i_size > MAXFILESIZE) {
  8030e9:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8030f0:	0f 84 93 00 00 00    	je     803189 <_Z4fsckv+0x2f6>
  8030f6:	8b 8d 64 ff ff ff    	mov    -0x9c(%ebp),%ecx
  8030fc:	8b 41 08             	mov    0x8(%ecx),%eax
  8030ff:	3d 00 a0 3f 00       	cmp    $0x3fa000,%eax
  803104:	7e 23                	jle    803129 <_Z4fsckv+0x296>
			cprintf("fsck: inode[%d]: size %d too large\n", i, ino->i_size);
  803106:	89 44 24 08          	mov    %eax,0x8(%esp)
  80310a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  803110:	89 44 24 04          	mov    %eax,0x4(%esp)
  803114:	c7 04 24 7c 4e 80 00 	movl   $0x804e7c,(%esp)
  80311b:	e8 52 d9 ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  803120:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803127:	eb 09                	jmp    803132 <_Z4fsckv+0x29f>
		}
		if (active && ino->i_inum != i) {
  803129:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803130:	74 4b                	je     80317d <_Z4fsckv+0x2ea>
  803132:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803138:	8b 82 f4 0f 00 00    	mov    0xff4(%edx),%eax
  80313e:	3b 85 58 ff ff ff    	cmp    -0xa8(%ebp),%eax
  803144:	74 23                	je     803169 <_Z4fsckv+0x2d6>
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
  803146:	89 44 24 08          	mov    %eax,0x8(%esp)
  80314a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803150:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803154:	c7 04 24 a0 4e 80 00 	movl   $0x804ea0,(%esp)
  80315b:	e8 12 d9 ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  803160:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803167:	eb 09                	jmp    803172 <_Z4fsckv+0x2df>
		}
		true_size = active ? ino->i_size : 0;
  803169:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803170:	74 12                	je     803184 <_Z4fsckv+0x2f1>
  803172:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803178:	8b 78 08             	mov    0x8(%eax),%edi
  80317b:	eb 0c                	jmp    803189 <_Z4fsckv+0x2f6>
  80317d:	bf 00 00 00 00       	mov    $0x0,%edi
  803182:	eb 05                	jmp    803189 <_Z4fsckv+0x2f6>
  803184:	bf 00 00 00 00       	mov    $0x0,%edi
		for (j = 0; j < NDIRECT; ++j) {
  803189:	bb 00 00 00 00       	mov    $0x0,%ebx
			blocknum_t b = ino->i_direct[j];
  80318e:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803194:	8b 74 9a 0c          	mov    0xc(%edx,%ebx,4),%esi
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  803198:	89 d8                	mov    %ebx,%eax
  80319a:	c1 e0 0c             	shl    $0xc,%eax
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
			blocknum_t b = ino->i_direct[j];
			if (j * BLKSIZE < true_size && !b) {
  80319d:	39 c7                	cmp    %eax,%edi
  80319f:	7e 2b                	jle    8031cc <_Z4fsckv+0x339>
  8031a1:	85 f6                	test   %esi,%esi
  8031a3:	75 27                	jne    8031cc <_Z4fsckv+0x339>
				cprintf("fsck: inode[%d]: direct block %d is null, though file size is %d\n", i, j, true_size);
  8031a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031ad:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8031b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031b7:	c7 04 24 c4 4e 80 00 	movl   $0x804ec4,(%esp)
  8031be:	e8 af d8 ff ff       	call   800a72 <_Z7cprintfPKcz>
				++errors;
  8031c3:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8031ca:	eb 36                	jmp    803202 <_Z4fsckv+0x36f>
			} else if (j * BLKSIZE >= true_size && b && active) {
  8031cc:	39 f8                	cmp    %edi,%eax
  8031ce:	7c 32                	jl     803202 <_Z4fsckv+0x36f>
  8031d0:	85 f6                	test   %esi,%esi
  8031d2:	74 2e                	je     803202 <_Z4fsckv+0x36f>
  8031d4:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  8031db:	74 25                	je     803202 <_Z4fsckv+0x36f>
				cprintf("fsck: inode[%d]: direct block %d exists, though file size is %d\n", i, j, true_size);
  8031dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031e1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031e5:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8031eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ef:	c7 04 24 08 4f 80 00 	movl   $0x804f08,(%esp)
  8031f6:	e8 77 d8 ff ff       	call   800a72 <_Z7cprintfPKcz>
				++errors;
  8031fb:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			if (b && active) {
  803202:	85 f6                	test   %esi,%esi
  803204:	0f 84 a0 00 00 00    	je     8032aa <_Z4fsckv+0x417>
  80320a:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803211:	0f 84 93 00 00 00    	je     8032aa <_Z4fsckv+0x417>
				if (b < min_nblocks) {
  803217:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  80321d:	7e 27                	jle    803246 <_Z4fsckv+0x3b3>
					cprintf("fsck: inode[%d]: direct block %d == %d is in special block range\n", i, j, b);
  80321f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803223:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803227:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  80322d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803231:	c7 04 24 4c 4f 80 00 	movl   $0x804f4c,(%esp)
  803238:	e8 35 d8 ff ff       	call   800a72 <_Z7cprintfPKcz>
					++errors;
  80323d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803244:	eb 64                	jmp    8032aa <_Z4fsckv+0x417>
				} else if (freemap[b] == 1) {
  803246:	0f b6 86 00 20 00 50 	movzbl 0x50002000(%esi),%eax
  80324d:	3c 01                	cmp    $0x1,%al
  80324f:	75 27                	jne    803278 <_Z4fsckv+0x3e5>
					cprintf("fsck: inode[%d]: direct block %d == %d is marked as free\n", i, j, b);
  803251:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803255:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803259:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  80325f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803263:	c7 04 24 90 4f 80 00 	movl   $0x804f90,(%esp)
  80326a:	e8 03 d8 ff ff       	call   800a72 <_Z7cprintfPKcz>
					++errors;
  80326f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803276:	eb 32                	jmp    8032aa <_Z4fsckv+0x417>
				} else if (freemap[b] == -1) {
  803278:	3c ff                	cmp    $0xff,%al
  80327a:	75 27                	jne    8032a3 <_Z4fsckv+0x410>
					cprintf("fsck: inode[%d]: direct block %d == %d used more than once\n", i, j, b);
  80327c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803280:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803284:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80328a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80328e:	c7 04 24 cc 4f 80 00 	movl   $0x804fcc,(%esp)
  803295:	e8 d8 d7 ff ff       	call   800a72 <_Z7cprintfPKcz>
					++errors;
  80329a:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  8032a1:	eb 07                	jmp    8032aa <_Z4fsckv+0x417>
				} else
					freemap[b] = -1;
  8032a3:	c6 86 00 20 00 50 ff 	movb   $0xff,0x50002000(%esi)
		if (active && ino->i_inum != i) {
			cprintf("fsck: inode[%d]: wrong inumber %d\n", i, ino->i_inum);
			++errors;
		}
		true_size = active ? ino->i_size : 0;
		for (j = 0; j < NDIRECT; ++j) {
  8032aa:	83 c3 01             	add    $0x1,%ebx
  8032ad:	81 fb fa 03 00 00    	cmp    $0x3fa,%ebx
  8032b3:	0f 85 d5 fe ff ff    	jne    80318e <_Z4fsckv+0x2fb>
					++errors;
				} else
					freemap[b] = -1;
			}
		}
		ino->i_fsck_refcount = (i == 1 ? 1 : 0);
  8032b9:	83 bd 58 ff ff ff 01 	cmpl   $0x1,-0xa8(%ebp)
  8032c0:	0f 94 c0             	sete   %al
  8032c3:	0f b6 c0             	movzbl %al,%eax
  8032c6:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8032cc:	88 82 fc 0f 00 00    	mov    %al,0xffc(%edx)
  8032d2:	c6 82 fd 0f 00 00 00 	movb   $0x0,0xffd(%edx)
  8032d9:	c6 82 fe 0f 00 00 00 	movb   $0x0,0xffe(%edx)
		ino->i_fsck_checked = 0;
  8032e0:	c6 82 ff 0f 00 00 00 	movb   $0x0,0xfff(%edx)
			freemap[i] = (freemap[i] > 0 ? 1 : 0);
		}

	// inode checks: inode 1 is referenced, unreferenced inodes
	// have no data pointers, ftype makes sense, no data pointer overlap
	for (i = 1; i < super->s_ninodes; ++i) {
  8032e7:	83 85 58 ff ff ff 01 	addl   $0x1,-0xa8(%ebp)
  8032ee:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  8032f4:	39 0d 08 10 00 50    	cmp    %ecx,0x50001008
  8032fa:	0f 8f 29 fd ff ff    	jg     803029 <_Z4fsckv+0x196>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803300:	83 3d 08 10 00 50 01 	cmpl   $0x1,0x50001008
  803307:	0f 8e 7f 03 00 00    	jle    80368c <_Z4fsckv+0x7f9>
  80330d:	be 01 00 00 00       	mov    $0x1,%esi
			ino = get_inode(i);
  803312:	89 f0                	mov    %esi,%eax
  803314:	e8 14 ef ff ff       	call   80222d <_ZL9get_inodei>
			if (ino->i_fsck_refcount > 0
  803319:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803320:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  803327:	c1 e2 08             	shl    $0x8,%edx
  80332a:	09 ca                	or     %ecx,%edx
  80332c:	0f b6 88 fe 0f 00 00 	movzbl 0xffe(%eax),%ecx
  803333:	c1 e1 10             	shl    $0x10,%ecx
  803336:	09 ca                	or     %ecx,%edx
  803338:	0f b6 88 ff 0f 00 00 	movzbl 0xfff(%eax),%ecx
  80333f:	83 e1 7f             	and    $0x7f,%ecx
  803342:	c1 e1 18             	shl    $0x18,%ecx
  803345:	09 d1                	or     %edx,%ecx
  803347:	74 0e                	je     803357 <_Z4fsckv+0x4c4>
  803349:	80 b8 ff 0f 00 00 00 	cmpb   $0x0,0xfff(%eax)
  803350:	78 05                	js     803357 <_Z4fsckv+0x4c4>
  803352:	83 38 02             	cmpl   $0x2,(%eax)
  803355:	74 1f                	je     803376 <_Z4fsckv+0x4e3>
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  803357:	83 c6 01             	add    $0x1,%esi
  80335a:	a1 08 10 00 50       	mov    0x50001008,%eax
  80335f:	39 f0                	cmp    %esi,%eax
  803361:	7f af                	jg     803312 <_Z4fsckv+0x47f>
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  803363:	bb 01 00 00 00       	mov    $0x1,%ebx
  803368:	83 f8 01             	cmp    $0x1,%eax
  80336b:	0f 8f ad 02 00 00    	jg     80361e <_Z4fsckv+0x78b>
  803371:	e9 16 03 00 00       	jmp    80368c <_Z4fsckv+0x7f9>
  803376:	89 c3                	mov    %eax,%ebx
				goto check_directory_inode;
		}
		break;

	check_directory_inode:
		ino->i_fsck_checked = 1;
  803378:	80 88 ff 0f 00 00 80 	orb    $0x80,0xfff(%eax)
		if (ino->i_size % sizeof(struct Direntry) != 0) {
  80337f:	8b 40 08             	mov    0x8(%eax),%eax
  803382:	a8 7f                	test   $0x7f,%al
  803384:	74 23                	je     8033a9 <_Z4fsckv+0x516>
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
  803386:	c7 44 24 0c 80 00 00 	movl   $0x80,0xc(%esp)
  80338d:	00 
  80338e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803392:	89 74 24 04          	mov    %esi,0x4(%esp)
  803396:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80339d:	e8 d0 d6 ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  8033a2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8033a9:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%ebp)
  8033b0:	00 00 00 
  8033b3:	89 9d 58 ff ff ff    	mov    %ebx,-0xa8(%ebp)
  8033b9:	e9 3d 02 00 00       	jmp    8035fb <_Z4fsckv+0x768>
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
			struct Direntry *de = (struct Direntry *) inode_data(ino, j);
  8033be:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8033c4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8033ca:	e8 01 ee ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
  8033cf:	89 c3                	mov    %eax,%ebx
			char name[MAXNAMELEN];
			int namelen;

			if (de->de_inum == 0)
  8033d1:	83 38 00             	cmpl   $0x0,(%eax)
  8033d4:	0f 84 15 02 00 00    	je     8035ef <_Z4fsckv+0x75c>
				continue;

			if (de->de_namelen <= 0 || de->de_namelen >= MAXNAMELEN) {
  8033da:	8b 40 04             	mov    0x4(%eax),%eax
  8033dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8033e0:	83 fa 76             	cmp    $0x76,%edx
  8033e3:	76 27                	jbe    80340c <_Z4fsckv+0x579>
				cprintf("inode[%d] de@%d: bad filename length %d\n", i, j, de->de_namelen);
  8033e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033e9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8033ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8033f7:	c7 04 24 3c 50 80 00 	movl   $0x80503c,(%esp)
  8033fe:	e8 6f d6 ff ff       	call   800a72 <_Z7cprintfPKcz>
				++errors;
  803403:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  80340a:	eb 28                	jmp    803434 <_Z4fsckv+0x5a1>
			} else if (de->de_name[de->de_namelen] != 0) {
  80340c:	80 7c 03 08 00       	cmpb   $0x0,0x8(%ebx,%eax,1)
  803411:	74 21                	je     803434 <_Z4fsckv+0x5a1>
				cprintf("inode[%d] de@%d: filename is not null terminated\n", i, j);
  803413:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803419:	89 54 24 08          	mov    %edx,0x8(%esp)
  80341d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803421:	c7 04 24 68 50 80 00 	movl   $0x805068,(%esp)
  803428:	e8 45 d6 ff ff       	call   800a72 <_Z7cprintfPKcz>
				++errors;
  80342d:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			}
			memcpy(name, de->de_name, MAXNAMELEN);
  803434:	c7 44 24 08 78 00 00 	movl   $0x78,0x8(%esp)
  80343b:	00 
  80343c:	8d 43 08             	lea    0x8(%ebx),%eax
  80343f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803443:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  803449:	89 0c 24             	mov    %ecx,(%esp)
  80344c:	e8 56 de ff ff       	call   8012a7 <memcpy>
  803451:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  803455:	bf 77 00 00 00       	mov    $0x77,%edi
  80345a:	0f 4e 7b 04          	cmovle 0x4(%ebx),%edi
  80345e:	85 ff                	test   %edi,%edi
  803460:	b8 00 00 00 00       	mov    $0x0,%eax
  803465:	0f 48 f8             	cmovs  %eax,%edi
			namelen = MAX(MIN(de->de_namelen, MAXNAMELEN - 1), 0);
			name[namelen] = 0;
  803468:	c6 84 3d 70 ff ff ff 	movb   $0x0,-0x90(%ebp,%edi,1)
  80346f:	00 

			if (de->de_inum >= super->s_ninodes) {
  803470:	8b 03                	mov    (%ebx),%eax
  803472:	3b 05 08 10 00 50    	cmp    0x50001008,%eax
  803478:	7c 3e                	jl     8034b8 <_Z4fsckv+0x625>
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
  80347a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80347e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803484:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803488:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  80348e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803492:	89 74 24 04          	mov    %esi,0x4(%esp)
  803496:	c7 04 24 9c 50 80 00 	movl   $0x80509c,(%esp)
  80349d:	e8 d0 d5 ff ff       	call   800a72 <_Z7cprintfPKcz>
				++errors;
  8034a2:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
	}

	// directory checks
	while (1) {
		struct Inode *ino;
		for (i = 1; i < super->s_ninodes; ++i) {
  8034a9:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
  8034b0:	00 00 00 
  8034b3:	e9 0b 01 00 00       	jmp    8035c3 <_Z4fsckv+0x730>

			if (de->de_inum >= super->s_ninodes) {
				cprintf("inode[%d] de@%d (%s): inode %d out of range\n", i, j, name, de->de_inum);
				++errors;
			} else {
				struct Inode *refed = get_inode(de->de_inum);
  8034b8:	e8 70 ed ff ff       	call   80222d <_ZL9get_inodei>
				++refed->i_fsck_refcount;
  8034bd:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  8034c4:	0f b6 90 fd 0f 00 00 	movzbl 0xffd(%eax),%edx
  8034cb:	c1 e2 08             	shl    $0x8,%edx
  8034ce:	09 d1                	or     %edx,%ecx
  8034d0:	0f b6 90 fe 0f 00 00 	movzbl 0xffe(%eax),%edx
  8034d7:	c1 e2 10             	shl    $0x10,%edx
  8034da:	09 d1                	or     %edx,%ecx
  8034dc:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  8034e3:	83 e2 7f             	and    $0x7f,%edx
  8034e6:	c1 e2 18             	shl    $0x18,%edx
  8034e9:	09 ca                	or     %ecx,%edx
  8034eb:	83 c2 01             	add    $0x1,%edx
  8034ee:	89 d1                	mov    %edx,%ecx
  8034f0:	81 e1 ff ff ff 7f    	and    $0x7fffffff,%ecx
  8034f6:	88 90 fc 0f 00 00    	mov    %dl,0xffc(%eax)
  8034fc:	0f b6 d5             	movzbl %ch,%edx
  8034ff:	88 90 fd 0f 00 00    	mov    %dl,0xffd(%eax)
  803505:	89 ca                	mov    %ecx,%edx
  803507:	c1 ea 10             	shr    $0x10,%edx
  80350a:	88 90 fe 0f 00 00    	mov    %dl,0xffe(%eax)
  803510:	c1 e9 18             	shr    $0x18,%ecx
  803513:	0f b6 90 ff 0f 00 00 	movzbl 0xfff(%eax),%edx
  80351a:	83 e2 80             	and    $0xffffff80,%edx
  80351d:	09 ca                	or     %ecx,%edx
  80351f:	88 90 ff 0f 00 00    	mov    %dl,0xfff(%eax)
				if (refed->i_refcount == 0) {
  803525:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  803529:	0f 85 7a ff ff ff    	jne    8034a9 <_Z4fsckv+0x616>
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
  80352f:	8b 03                	mov    (%ebx),%eax
  803531:	89 44 24 10          	mov    %eax,0x10(%esp)
  803535:	8d 8d 70 ff ff ff    	lea    -0x90(%ebp),%ecx
  80353b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80353f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  803545:	89 44 24 08          	mov    %eax,0x8(%esp)
  803549:	89 74 24 04          	mov    %esi,0x4(%esp)
  80354d:	c7 04 24 cc 50 80 00 	movl   $0x8050cc,(%esp)
  803554:	e8 19 d5 ff ff       	call   800a72 <_Z7cprintfPKcz>
					++errors;
  803559:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
  803560:	e9 44 ff ff ff       	jmp    8034a9 <_Z4fsckv+0x616>
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803565:	3b 78 04             	cmp    0x4(%eax),%edi
  803568:	75 52                	jne    8035bc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
  80356a:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80356e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  803574:	89 54 24 04          	mov    %edx,0x4(%esp)
  803578:	83 c0 08             	add    $0x8,%eax
  80357b:	89 04 24             	mov    %eax,(%esp)
  80357e:	e8 65 dd ff ff       	call   8012e8 <memcmp>
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
				if (xde->de_inum != 0
  803583:	85 c0                	test   %eax,%eax
  803585:	75 35                	jne    8035bc <_Z4fsckv+0x729>
				    && xde->de_namelen == namelen
				    && memcmp(xde->de_name, name, namelen) == 0) {
					cprintf("inode[%d] de@%d (%s): same filename as de@%d\n", i, j, name, k);
  803587:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  80358d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803591:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  803597:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80359b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  8035a1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8035a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8035a9:	c7 04 24 fc 50 80 00 	movl   $0x8050fc,(%esp)
  8035b0:	e8 bd d4 ff ff       	call   800a72 <_Z7cprintfPKcz>
					++errors;
  8035b5:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8035bc:	83 ad 5c ff ff ff 80 	subl   $0xffffff80,-0xa4(%ebp)
				if (refed->i_refcount == 0) {
					cprintf("inode[%d] de@%d (%s): refers to free inode %d\n", i, j, name, de->de_inum);
					++errors;
				}
			}
			for (k = 0; k < j && de->de_namelen < MAXNAMELEN; k += sizeof(struct Direntry)) {
  8035c3:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8035c9:	39 8d 64 ff ff ff    	cmp    %ecx,-0x9c(%ebp)
  8035cf:	7e 1e                	jle    8035ef <_Z4fsckv+0x75c>
  8035d1:	83 7b 04 77          	cmpl   $0x77,0x4(%ebx)
  8035d5:	7f 18                	jg     8035ef <_Z4fsckv+0x75c>
				struct Direntry *xde = (struct Direntry *) inode_data(ino, k);
  8035d7:	89 ca                	mov    %ecx,%edx
  8035d9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8035df:	e8 ec eb ff ff       	call   8021d0 <_ZL10inode_dataP5Inodei>
				if (xde->de_inum != 0
  8035e4:	83 38 00             	cmpl   $0x0,(%eax)
  8035e7:	0f 85 78 ff ff ff    	jne    803565 <_Z4fsckv+0x6d2>
  8035ed:	eb cd                	jmp    8035bc <_Z4fsckv+0x729>
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  8035ef:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8035f5:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
// Does no locking, so if run in parallel with other environments, it can
// get confused and report transient "errors."
// Returns 0 if the file system is OK, -E_INVAL if any errors were found.
//
int
fsck(void)
  8035fb:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  803601:	83 ea 80             	sub    $0xffffff80,%edx
  803604:	89 95 50 ff ff ff    	mov    %edx,-0xb0(%ebp)
		ino->i_fsck_checked = 1;
		if (ino->i_size % sizeof(struct Direntry) != 0) {
			cprintf("inode[%d]: directory size %d not multiple of %d\n", i, ino->i_size, sizeof(struct Direntry));
			++errors;
		}
		for (j = 0; (off_t) (j + sizeof(struct Direntry)) <= ino->i_size; j += sizeof(struct Direntry)) {
  80360a:	8b 8d 58 ff ff ff    	mov    -0xa8(%ebp),%ecx
  803610:	3b 51 08             	cmp    0x8(%ecx),%edx
  803613:	0f 8f e7 fc ff ff    	jg     803300 <_Z4fsckv+0x46d>
  803619:	e9 a0 fd ff ff       	jmp    8033be <_Z4fsckv+0x52b>
  80361e:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
		struct Inode *ino = get_inode(i);
  803624:	89 d8                	mov    %ebx,%eax
  803626:	e8 02 ec ff ff       	call   80222d <_ZL9get_inodei>
		if (ino->i_refcount != ino->i_fsck_refcount) {
  80362b:	8b 50 04             	mov    0x4(%eax),%edx
  80362e:	0f b6 88 fc 0f 00 00 	movzbl 0xffc(%eax),%ecx
  803635:	0f b6 b8 fd 0f 00 00 	movzbl 0xffd(%eax),%edi
  80363c:	c1 e7 08             	shl    $0x8,%edi
  80363f:	09 f9                	or     %edi,%ecx
  803641:	0f b6 b8 fe 0f 00 00 	movzbl 0xffe(%eax),%edi
  803648:	c1 e7 10             	shl    $0x10,%edi
  80364b:	09 f9                	or     %edi,%ecx
  80364d:	0f b6 b8 ff 0f 00 00 	movzbl 0xfff(%eax),%edi
  803654:	83 e7 7f             	and    $0x7f,%edi
  803657:	c1 e7 18             	shl    $0x18,%edi
  80365a:	09 f9                	or     %edi,%ecx
  80365c:	39 ca                	cmp    %ecx,%edx
  80365e:	74 1b                	je     80367b <_Z4fsckv+0x7e8>
			cprintf("fsck: inode[%d]: refcount %d should be %d\n", i, ino->i_refcount, ino->i_fsck_refcount);
  803660:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803664:	89 54 24 08          	mov    %edx,0x8(%esp)
  803668:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80366c:	c7 04 24 2c 51 80 00 	movl   $0x80512c,(%esp)
  803673:	e8 fa d3 ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  803678:	83 c6 01             	add    $0x1,%esi
			}
		}
	}

	// refcount consistency
	for (i = 1; i < super->s_ninodes; ++i) {
  80367b:	83 c3 01             	add    $0x1,%ebx
  80367e:	39 1d 08 10 00 50    	cmp    %ebx,0x50001008
  803684:	7f 9e                	jg     803624 <_Z4fsckv+0x791>
  803686:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  80368c:	83 3d 04 10 00 50 00 	cmpl   $0x0,0x50001004
  803693:	7e 4f                	jle    8036e4 <_Z4fsckv+0x851>
  803695:	bb 00 00 00 00       	mov    $0x0,%ebx
  80369a:	8b b5 60 ff ff ff    	mov    -0xa0(%ebp),%esi
		if (freemap[i] == -1)
  8036a0:	0f b6 83 00 20 00 50 	movzbl 0x50002000(%ebx),%eax
  8036a7:	3c ff                	cmp    $0xff,%al
  8036a9:	75 09                	jne    8036b4 <_Z4fsckv+0x821>
			freemap[i] = 0;
  8036ab:	c6 83 00 20 00 50 00 	movb   $0x0,0x50002000(%ebx)
  8036b2:	eb 1f                	jmp    8036d3 <_Z4fsckv+0x840>
		else if (freemap[i] == 0 && i >= min_nblocks) {
  8036b4:	84 c0                	test   %al,%al
  8036b6:	75 1b                	jne    8036d3 <_Z4fsckv+0x840>
  8036b8:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  8036be:	7c 13                	jl     8036d3 <_Z4fsckv+0x840>
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
  8036c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8036c4:	c7 04 24 58 51 80 00 	movl   $0x805158,(%esp)
  8036cb:	e8 a2 d3 ff ff       	call   800a72 <_Z7cprintfPKcz>
			++errors;
  8036d0:	83 c6 01             	add    $0x1,%esi
			++errors;
		}
	}

	// clean up freemap
	for (i = 0; i < super->s_nblocks; ++i)
  8036d3:	83 c3 01             	add    $0x1,%ebx
  8036d6:	39 1d 04 10 00 50    	cmp    %ebx,0x50001004
  8036dc:	7f c2                	jg     8036a0 <_Z4fsckv+0x80d>
  8036de:	89 b5 60 ff ff ff    	mov    %esi,-0xa0(%ebp)
		else if (freemap[i] == 0 && i >= min_nblocks) {
			cprintf("fsck: freemap[%d]: unreferenced block is not free\n", i);
			++errors;
		}

	return errors ? -E_INVAL : 0;
  8036e4:	83 bd 60 ff ff ff 01 	cmpl   $0x1,-0xa0(%ebp)
  8036eb:	19 c0                	sbb    %eax,%eax
  8036ed:	f7 d0                	not    %eax
  8036ef:	83 e0 fd             	and    $0xfffffffd,%eax
}
  8036f2:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  8036f8:	5b                   	pop    %ebx
  8036f9:	5e                   	pop    %esi
  8036fa:	5f                   	pop    %edi
  8036fb:	5d                   	pop    %ebp
  8036fc:	c3                   	ret    
		// uninitialized inodes (use bcache_ipc to check)
		bool active = ino->i_refcount != 0;
		if (!active && ino->i_opencount != 0
		    && bcache_ipc(ino, BCREQ_MAP) != 0)
			active = true;
		if (active && ino->i_ftype != FTYPE_REG && ino->i_ftype != FTYPE_DIR) {
  8036fd:	80 bd 5c ff ff ff 00 	cmpb   $0x0,-0xa4(%ebp)
  803704:	0f 84 92 f9 ff ff    	je     80309c <_Z4fsckv+0x209>
  80370a:	e9 5a f9 ff ff       	jmp    803069 <_Z4fsckv+0x1d6>
	...

00803710 <_ZL12devpipe_statP2FdP4Stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803710:	55                   	push   %ebp
  803711:	89 e5                	mov    %esp,%ebp
  803713:	83 ec 18             	sub    $0x18,%esp
  803716:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803719:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80371c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80371f:	8b 45 08             	mov    0x8(%ebp),%eax
  803722:	89 04 24             	mov    %eax,(%esp)
  803725:	e8 a2 e4 ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  80372a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80372c:	c7 44 24 04 8b 51 80 	movl   $0x80518b,0x4(%esp)
  803733:	00 
  803734:	89 34 24             	mov    %esi,(%esp)
  803737:	e8 4e d9 ff ff       	call   80108a <_Z6strcpyPcPKc>
	stat->st_size = p->p_wpos - p->p_rpos;
  80373c:	8b 43 04             	mov    0x4(%ebx),%eax
  80373f:	2b 03                	sub    (%ebx),%eax
  803741:	89 46 78             	mov    %eax,0x78(%esi)
	stat->st_ftype = FTYPE_REG;
  803744:	c7 46 7c 01 00 00 00 	movl   $0x1,0x7c(%esi)
	stat->st_dev = &devpipe;
  80374b:	c7 86 80 00 00 00 24 	movl   $0x806024,0x80(%esi)
  803752:	60 80 00 
	return 0;
}
  803755:	b8 00 00 00 00       	mov    $0x0,%eax
  80375a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80375d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803760:	89 ec                	mov    %ebp,%esp
  803762:	5d                   	pop    %ebp
  803763:	c3                   	ret    

00803764 <_ZL13devpipe_closeP2Fd>:

static int
devpipe_close(struct Fd *fd)
{
  803764:	55                   	push   %ebp
  803765:	89 e5                	mov    %esp,%ebp
  803767:	53                   	push   %ebx
  803768:	83 ec 14             	sub    $0x14,%esp
  80376b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80376e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803772:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803779:	e8 af de ff ff       	call   80162d <_Z14sys_page_unmapiPv>
	return sys_page_unmap(0, fd2data(fd));
  80377e:	89 1c 24             	mov    %ebx,(%esp)
  803781:	e8 46 e4 ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  803786:	89 44 24 04          	mov    %eax,0x4(%esp)
  80378a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803791:	e8 97 de ff ff       	call   80162d <_Z14sys_page_unmapiPv>
}
  803796:	83 c4 14             	add    $0x14,%esp
  803799:	5b                   	pop    %ebx
  80379a:	5d                   	pop    %ebp
  80379b:	c3                   	ret    

0080379c <_ZL13_pipeisclosedP2FdP4Pipe>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80379c:	55                   	push   %ebp
  80379d:	89 e5                	mov    %esp,%ebp
  80379f:	57                   	push   %edi
  8037a0:	56                   	push   %esi
  8037a1:	53                   	push   %ebx
  8037a2:	83 ec 2c             	sub    $0x2c,%esp
  8037a5:	89 c7                	mov    %eax,%edi
  8037a7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	// LAB 5: Your code here.
    int i;
    uint32_t orig_id;
    while(true)
    {
        orig_id = thisenv->env_runs;
  8037aa:	a1 00 70 80 00       	mov    0x807000,%eax
  8037af:	8b 70 58             	mov    0x58(%eax),%esi
        i = pageref(fd) == pageref(p);
  8037b2:	89 3c 24             	mov    %edi,(%esp)
  8037b5:	e8 82 04 00 00       	call   803c3c <_Z7pagerefPv>
  8037ba:	89 c3                	mov    %eax,%ebx
  8037bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bf:	89 04 24             	mov    %eax,(%esp)
  8037c2:	e8 75 04 00 00       	call   803c3c <_Z7pagerefPv>
  8037c7:	39 c3                	cmp    %eax,%ebx
  8037c9:	0f 94 c0             	sete   %al
  8037cc:	0f b6 c0             	movzbl %al,%eax
        if(orig_id == thisenv->env_runs)
  8037cf:	8b 15 00 70 80 00    	mov    0x807000,%edx
  8037d5:	8b 52 58             	mov    0x58(%edx),%edx
  8037d8:	39 d6                	cmp    %edx,%esi
  8037da:	75 08                	jne    8037e4 <_ZL13_pipeisclosedP2FdP4Pipe+0x48>
            return i;
        else if(i)
            cprintf("pipe race avoided\n");
    }
}
  8037dc:	83 c4 2c             	add    $0x2c,%esp
  8037df:	5b                   	pop    %ebx
  8037e0:	5e                   	pop    %esi
  8037e1:	5f                   	pop    %edi
  8037e2:	5d                   	pop    %ebp
  8037e3:	c3                   	ret    
    {
        orig_id = thisenv->env_runs;
        i = pageref(fd) == pageref(p);
        if(orig_id == thisenv->env_runs)
            return i;
        else if(i)
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	74 c2                	je     8037aa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>
            cprintf("pipe race avoided\n");
  8037e8:	c7 04 24 92 51 80 00 	movl   $0x805192,(%esp)
  8037ef:	e8 7e d2 ff ff       	call   800a72 <_Z7cprintfPKcz>
  8037f4:	eb b4                	jmp    8037aa <_ZL13_pipeisclosedP2FdP4Pipe+0xe>

008037f6 <_ZL13devpipe_writeP2FdPKvj>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037f6:	55                   	push   %ebp
  8037f7:	89 e5                	mov    %esp,%ebp
  8037f9:	57                   	push   %edi
  8037fa:	56                   	push   %esi
  8037fb:	53                   	push   %ebx
  8037fc:	83 ec 1c             	sub    $0x1c,%esp
  8037ff:	8b 75 08             	mov    0x8(%ebp),%esi
	// wait for the pipe to empty and then keep copying.
	// If the pipe is full and closed, return the number of characters
	// written.  Use _pipeisclosed to check whether the pipe is closed.

	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  803802:	89 34 24             	mov    %esi,(%esp)
  803805:	e8 c2 e3 ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  80380a:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  80380c:	bf 00 00 00 00       	mov    $0x0,%edi
  803811:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803815:	75 46                	jne    80385d <_ZL13devpipe_writeP2FdPKvj+0x67>
  803817:	eb 52                	jmp    80386b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
  803819:	89 da                	mov    %ebx,%edx
  80381b:	89 f0                	mov    %esi,%eax
  80381d:	e8 7a ff ff ff       	call   80379c <_ZL13_pipeisclosedP2FdP4Pipe>
  803822:	85 c0                	test   %eax,%eax
  803824:	75 49                	jne    80386f <_ZL13devpipe_writeP2FdPKvj+0x79>
				return 0;
			else
				sys_yield();
  803826:	e8 11 dd ff ff       	call   80153c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80382b:	8b 43 04             	mov    0x4(%ebx),%eax
  80382e:	89 c2                	mov    %eax,%edx
  803830:	2b 13                	sub    (%ebx),%edx
  803832:	83 fa 20             	cmp    $0x20,%edx
  803835:	74 e2                	je     803819 <_ZL13devpipe_writeP2FdPKvj+0x23>
				return 0;
			else
				sys_yield();
		}

		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803837:	89 c2                	mov    %eax,%edx
  803839:	c1 fa 1f             	sar    $0x1f,%edx
  80383c:	c1 ea 1b             	shr    $0x1b,%edx
  80383f:	01 d0                	add    %edx,%eax
  803841:	83 e0 1f             	and    $0x1f,%eax
  803844:	29 d0                	sub    %edx,%eax
  803846:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803849:	0f b6 14 39          	movzbl (%ecx,%edi,1),%edx
  80384d:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
  803851:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	// LAB 5: Your code here.
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803855:	83 c7 01             	add    $0x1,%edi
  803858:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80385b:	76 0e                	jbe    80386b <_ZL13devpipe_writeP2FdPKvj+0x75>
		while (p->p_wpos - p->p_rpos == PIPEBUFSIZ) {
  80385d:	8b 43 04             	mov    0x4(%ebx),%eax
  803860:	89 c2                	mov    %eax,%edx
  803862:	2b 13                	sub    (%ebx),%edx
  803864:	83 fa 20             	cmp    $0x20,%edx
  803867:	74 b0                	je     803819 <_ZL13devpipe_writeP2FdPKvj+0x23>
  803869:	eb cc                	jmp    803837 <_ZL13devpipe_writeP2FdPKvj+0x41>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
  80386b:	89 f8                	mov    %edi,%eax
  80386d:	eb 05                	jmp    803874 <_ZL13devpipe_writeP2FdPKvj+0x7e>
			// The pipe is currently full
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (_pipeisclosed(fd, p))
				return 0;
  80386f:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_wpos++;
	}

	return i;
}
  803874:	83 c4 1c             	add    $0x1c,%esp
  803877:	5b                   	pop    %ebx
  803878:	5e                   	pop    %esi
  803879:	5f                   	pop    %edi
  80387a:	5d                   	pop    %ebp
  80387b:	c3                   	ret    

0080387c <_ZL12devpipe_readP2FdPvj>:
}


static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80387c:	55                   	push   %ebp
  80387d:	89 e5                	mov    %esp,%ebp
  80387f:	83 ec 28             	sub    $0x28,%esp
  803882:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803885:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803888:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80388b:	8b 7d 08             	mov    0x8(%ebp),%edi
	struct Pipe *p = (struct Pipe *) fd2data(fd);
  80388e:	89 3c 24             	mov    %edi,(%esp)
  803891:	e8 36 e3 ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  803896:	89 c3                	mov    %eax,%ebx
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  803898:	be 00 00 00 00       	mov    $0x0,%esi
  80389d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8038a1:	75 47                	jne    8038ea <_ZL12devpipe_readP2FdPvj+0x6e>
  8038a3:	eb 52                	jmp    8038f7 <_ZL12devpipe_readP2FdPvj+0x7b>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
  8038a5:	89 f0                	mov    %esi,%eax
  8038a7:	eb 5e                	jmp    803907 <_ZL12devpipe_readP2FdPvj+0x8b>
			else if (_pipeisclosed(fd, p))
  8038a9:	89 da                	mov    %ebx,%edx
  8038ab:	89 f8                	mov    %edi,%eax
  8038ad:	8d 76 00             	lea    0x0(%esi),%esi
  8038b0:	e8 e7 fe ff ff       	call   80379c <_ZL13_pipeisclosedP2FdP4Pipe>
  8038b5:	85 c0                	test   %eax,%eax
  8038b7:	75 49                	jne    803902 <_ZL12devpipe_readP2FdPvj+0x86>
				return 0;
			else
				sys_yield();
  8038b9:	e8 7e dc ff ff       	call   80153c <_Z9sys_yieldv>
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8038be:	8b 03                	mov    (%ebx),%eax
  8038c0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8038c3:	74 e4                	je     8038a9 <_ZL12devpipe_readP2FdPvj+0x2d>
				return 0;
			else
				sys_yield();
		}

		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038c5:	89 c2                	mov    %eax,%edx
  8038c7:	c1 fa 1f             	sar    $0x1f,%edx
  8038ca:	c1 ea 1b             	shr    $0x1b,%edx
  8038cd:	01 d0                	add    %edx,%eax
  8038cf:	83 e0 1f             	and    $0x1f,%eax
  8038d2:	29 d0                	sub    %edx,%eax
  8038d4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8038d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038dc:	88 04 32             	mov    %al,(%edx,%esi,1)
		// The increment must come AFTER we write to the buffer,
		// or the C compiler might update the pointer before writing
		// to the buffer!  In fact, we need a memory barrier here---
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
  8038df:	83 03 01             	addl   $0x1,(%ebx)
{
	struct Pipe *p = (struct Pipe *) fd2data(fd);
	uint8_t *buf = (uint8_t *) vbuf;
	size_t i;

	for (i = 0; i < n; i++) {
  8038e2:	83 c6 01             	add    $0x1,%esi
  8038e5:	39 75 10             	cmp    %esi,0x10(%ebp)
  8038e8:	76 0d                	jbe    8038f7 <_ZL12devpipe_readP2FdPvj+0x7b>
		while (p->p_rpos == p->p_wpos) {
  8038ea:	8b 03                	mov    (%ebx),%eax
  8038ec:	3b 43 04             	cmp    0x4(%ebx),%eax
  8038ef:	75 d4                	jne    8038c5 <_ZL12devpipe_readP2FdPvj+0x49>
			// The pipe is currently empty.
			// If any data has been read, return it.
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
  8038f1:	85 f6                	test   %esi,%esi
  8038f3:	75 b0                	jne    8038a5 <_ZL12devpipe_readP2FdPvj+0x29>
  8038f5:	eb b2                	jmp    8038a9 <_ZL12devpipe_readP2FdPvj+0x2d>
		// on some machines a memory barrier instruction.
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
  8038f7:	89 f0                	mov    %esi,%eax
  8038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803900:	eb 05                	jmp    803907 <_ZL12devpipe_readP2FdPvj+0x8b>
			// Otherwise, check for EOF; if not EOF, yield
			// and try again.
			if (i > 0)
				return i;
			else if (_pipeisclosed(fd, p))
				return 0;
  803902:	b8 00 00 00 00       	mov    $0x0,%eax
		asm volatile("" : : : "memory");
		p->p_rpos++;
	}

	return i;
}
  803907:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80390a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80390d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803910:	89 ec                	mov    %ebp,%esp
  803912:	5d                   	pop    %ebp
  803913:	c3                   	ret    

00803914 <_Z4pipePi>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803914:	55                   	push   %ebp
  803915:	89 e5                	mov    %esp,%ebp
  803917:	83 ec 48             	sub    $0x48,%esp
  80391a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80391d:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803920:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803923:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
  803926:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803929:	89 04 24             	mov    %eax,(%esp)
  80392c:	e8 b6 e2 ff ff       	call   801be7 <_Z14fd_find_unusedPP2Fd>
  803931:	89 c3                	mov    %eax,%ebx
  803933:	85 c0                	test   %eax,%eax
  803935:	0f 88 0b 01 00 00    	js     803a46 <_Z4pipePi+0x132>
  80393b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803942:	00 
  803943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803946:	89 44 24 04          	mov    %eax,0x4(%esp)
  80394a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803951:	e8 1a dc ff ff       	call   801570 <_Z14sys_page_allociPvi>
  803956:	89 c3                	mov    %eax,%ebx
  803958:	85 c0                	test   %eax,%eax
  80395a:	0f 89 f5 00 00 00    	jns    803a55 <_Z4pipePi+0x141>
  803960:	e9 e1 00 00 00       	jmp    803a46 <_Z4pipePi+0x132>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803965:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80396c:	00 
  80396d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803970:	89 44 24 04          	mov    %eax,0x4(%esp)
  803974:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80397b:	e8 f0 db ff ff       	call   801570 <_Z14sys_page_allociPvi>
  803980:	89 c3                	mov    %eax,%ebx
  803982:	85 c0                	test   %eax,%eax
  803984:	0f 89 e2 00 00 00    	jns    803a6c <_Z4pipePi+0x158>
  80398a:	e9 a4 00 00 00       	jmp    803a33 <_Z4pipePi+0x11f>

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80398f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803992:	89 04 24             	mov    %eax,(%esp)
  803995:	e8 32 e2 ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  80399a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8039a1:	00 
  8039a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8039ad:	00 
  8039ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8039b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039b9:	e8 11 dc ff ff       	call   8015cf <_Z12sys_page_mapiPviS_i>
  8039be:	89 c3                	mov    %eax,%ebx
  8039c0:	85 c0                	test   %eax,%eax
  8039c2:	78 4c                	js     803a10 <_Z4pipePi+0xfc>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8039c4:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8039ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8039cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8039d9:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8039df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8039e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, vpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8039ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f1:	89 04 24             	mov    %eax,(%esp)
  8039f4:	e8 8b e1 ff ff       	call   801b84 <_Z6fd2numP2Fd>
  8039f9:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8039fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039fe:	89 04 24             	mov    %eax,(%esp)
  803a01:	e8 7e e1 ff ff       	call   801b84 <_Z6fd2numP2Fd>
  803a06:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803a09:	bb 00 00 00 00       	mov    $0x0,%ebx
  803a0e:	eb 36                	jmp    803a46 <_Z4pipePi+0x132>

    err3:
	sys_page_unmap(0, va);
  803a10:	89 74 24 04          	mov    %esi,0x4(%esp)
  803a14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a1b:	e8 0d dc ff ff       	call   80162d <_Z14sys_page_unmapiPv>
    err2:
	sys_page_unmap(0, fd1);
  803a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a2e:	e8 fa db ff ff       	call   80162d <_Z14sys_page_unmapiPv>
    err1:
	sys_page_unmap(0, fd0);
  803a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a36:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a41:	e8 e7 db ff ff       	call   80162d <_Z14sys_page_unmapiPv>
    err:
	return r;
}
  803a46:	89 d8                	mov    %ebx,%eax
  803a48:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803a4b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803a4e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803a51:	89 ec                	mov    %ebp,%esp
  803a53:	5d                   	pop    %ebp
  803a54:	c3                   	ret    
	// allocate the file descriptor table entries
	if ((r = fd_find_unused(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_find_unused(&fd1)) < 0
  803a55:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803a58:	89 04 24             	mov    %eax,(%esp)
  803a5b:	e8 87 e1 ff ff       	call   801be7 <_Z14fd_find_unusedPP2Fd>
  803a60:	89 c3                	mov    %eax,%ebx
  803a62:	85 c0                	test   %eax,%eax
  803a64:	0f 89 fb fe ff ff    	jns    803965 <_Z4pipePi+0x51>
  803a6a:	eb c7                	jmp    803a33 <_Z4pipePi+0x11f>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6f:	89 04 24             	mov    %eax,(%esp)
  803a72:	e8 55 e1 ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  803a77:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a79:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803a80:	00 
  803a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a8c:	e8 df da ff ff       	call   801570 <_Z14sys_page_allociPvi>
  803a91:	89 c3                	mov    %eax,%ebx
  803a93:	85 c0                	test   %eax,%eax
  803a95:	0f 89 f4 fe ff ff    	jns    80398f <_Z4pipePi+0x7b>
  803a9b:	eb 83                	jmp    803a20 <_Z4pipePi+0x10c>

00803a9d <_Z12pipeisclosedi>:
    }
}

int
pipeisclosed(int fdnum)
{
  803a9d:	55                   	push   %ebp
  803a9e:	89 e5                	mov    %esp,%ebp
  803aa0:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  803aa3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803aaa:	00 
  803aab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab5:	89 04 24             	mov    %eax,(%esp)
  803ab8:	e8 74 e0 ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  803abd:	85 c0                	test   %eax,%eax
  803abf:	78 15                	js     803ad6 <_Z12pipeisclosedi+0x39>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac4:	89 04 24             	mov    %eax,(%esp)
  803ac7:	e8 00 e1 ff ff       	call   801bcc <_Z7fd2dataP2Fd>
	return _pipeisclosed(fd, p);
  803acc:	89 c2                	mov    %eax,%edx
  803ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad1:	e8 c6 fc ff ff       	call   80379c <_ZL13_pipeisclosedP2FdP4Pipe>
}
  803ad6:	c9                   	leave  
  803ad7:	c3                   	ret    

00803ad8 <_Z18pipe_ipc_recv_readv>:

int
pipe_ipc_recv_read() {
  803ad8:	55                   	push   %ebp
  803ad9:	89 e5                	mov    %esp,%ebp
  803adb:	53                   	push   %ebx
  803adc:	83 ec 24             	sub    $0x24,%esp
    int r;
    struct Fd *fd;

    // allocate the file descriptor table entries
    if ((r = fd_find_unused(&fd)) < 0
  803adf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ae2:	89 04 24             	mov    %eax,(%esp)
  803ae5:	e8 fd e0 ff ff       	call   801be7 <_Z14fd_find_unusedPP2Fd>
  803aea:	89 c3                	mov    %eax,%ebx
  803aec:	85 c0                	test   %eax,%eax
  803aee:	0f 88 be 00 00 00    	js     803bb2 <_Z18pipe_ipc_recv_readv+0xda>
  803af4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803afb:	00 
  803afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aff:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b0a:	e8 61 da ff ff       	call   801570 <_Z14sys_page_allociPvi>
  803b0f:	89 c3                	mov    %eax,%ebx
  803b11:	85 c0                	test   %eax,%eax
  803b13:	0f 89 a1 00 00 00    	jns    803bba <_Z18pipe_ipc_recv_readv+0xe2>
  803b19:	e9 94 00 00 00       	jmp    803bb2 <_Z18pipe_ipc_recv_readv+0xda>
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
        goto err1;
    }

    if(perm == 0)
  803b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b21:	85 c0                	test   %eax,%eax
  803b23:	75 0e                	jne    803b33 <_Z18pipe_ipc_recv_readv+0x5b>
        cprintf("no page was actually transferred!\n");
  803b25:	c7 04 24 f0 51 80 00 	movl   $0x8051f0,(%esp)
  803b2c:	e8 41 cf ff ff       	call   800a72 <_Z7cprintfPKcz>
  803b31:	eb 10                	jmp    803b43 <_Z18pipe_ipc_recv_readv+0x6b>
    else
        cprintf("perm: %x\n", perm);
  803b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b37:	c7 04 24 a5 51 80 00 	movl   $0x8051a5,(%esp)
  803b3e:	e8 2f cf ff ff       	call   800a72 <_Z7cprintfPKcz>

    cprintf("finished ipc_recv\n");
  803b43:	c7 04 24 af 51 80 00 	movl   $0x8051af,(%esp)
  803b4a:	e8 23 cf ff ff       	call   800a72 <_Z7cprintfPKcz>

    assert(perm & PTE_U && perm & PTE_P);
  803b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b52:	a8 04                	test   $0x4,%al
  803b54:	74 04                	je     803b5a <_Z18pipe_ipc_recv_readv+0x82>
  803b56:	a8 01                	test   $0x1,%al
  803b58:	75 24                	jne    803b7e <_Z18pipe_ipc_recv_readv+0xa6>
  803b5a:	c7 44 24 0c c2 51 80 	movl   $0x8051c2,0xc(%esp)
  803b61:	00 
  803b62:	c7 44 24 08 fd 46 80 	movl   $0x8046fd,0x8(%esp)
  803b69:	00 
  803b6a:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  803b71:	00 
  803b72:	c7 04 24 df 51 80 00 	movl   $0x8051df,(%esp)
  803b79:	e8 d6 cd ff ff       	call   800954 <_Z6_panicPKciS0_z>
    
    // set up fd structures
    fd->fd_dev_id = devpipe.dev_id;
  803b7e:	8b 15 24 60 80 00    	mov    0x806024,%edx
  803b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b87:	89 10                	mov    %edx,(%eax)
    fd->fd_omode = O_RDONLY;
  803b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    return fd2num(fd);
  803b93:	89 04 24             	mov    %eax,(%esp)
  803b96:	e8 e9 df ff ff       	call   801b84 <_Z6fd2numP2Fd>
  803b9b:	89 c3                	mov    %eax,%ebx
  803b9d:	eb 13                	jmp    803bb2 <_Z18pipe_ipc_recv_readv+0xda>

err1:
    sys_page_unmap(0, fd);
  803b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ba6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803bad:	e8 7b da ff ff       	call   80162d <_Z14sys_page_unmapiPv>
err:
    return r;
}
  803bb2:	89 d8                	mov    %ebx,%eax
  803bb4:	83 c4 24             	add    $0x24,%esp
  803bb7:	5b                   	pop    %ebx
  803bb8:	5d                   	pop    %ebp
  803bb9:	c3                   	ret    
        goto err;
    }

    envid_t from_env;
    int perm;
    if ((r = ipc_recv(&from_env, fd2data(fd), &perm)) < 0) {
  803bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbd:	89 04 24             	mov    %eax,(%esp)
  803bc0:	e8 07 e0 ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  803bc5:	8d 55 ec             	lea    -0x14(%ebp),%edx
  803bc8:	89 54 24 08          	mov    %edx,0x8(%esp)
  803bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bd0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803bd3:	89 04 24             	mov    %eax,(%esp)
  803bd6:	e8 d5 dd ff ff       	call   8019b0 <_Z8ipc_recvPiPvS_>
  803bdb:	89 c3                	mov    %eax,%ebx
  803bdd:	85 c0                	test   %eax,%eax
  803bdf:	0f 89 39 ff ff ff    	jns    803b1e <_Z18pipe_ipc_recv_readv+0x46>
  803be5:	eb b8                	jmp    803b9f <_Z18pipe_ipc_recv_readv+0xc7>

00803be7 <_Z13pipe_ipc_sendii>:
    return r;
}


int
pipe_ipc_send(envid_t envid, int read_fdnum) {
  803be7:	55                   	push   %ebp
  803be8:	89 e5                	mov    %esp,%ebp
  803bea:	83 ec 28             	sub    $0x28,%esp
    struct Fd *fd;
    int r;
    if ((r = fd_lookup(read_fdnum, &fd, true)) < 0) {
  803bed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803bf4:	00 
  803bf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bff:	89 04 24             	mov    %eax,(%esp)
  803c02:	e8 2a df ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  803c07:	85 c0                	test   %eax,%eax
  803c09:	78 2f                	js     803c3a <_Z13pipe_ipc_sendii+0x53>
        return r;
    }
    ipc_send(envid, 0, fd2data(fd), PTE_P | PTE_U | PTE_W);
  803c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0e:	89 04 24             	mov    %eax,(%esp)
  803c11:	e8 b6 df ff ff       	call   801bcc <_Z7fd2dataP2Fd>
  803c16:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803c1d:	00 
  803c1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803c29:	00 
  803c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2d:	89 04 24             	mov    %eax,(%esp)
  803c30:	e8 0a de ff ff       	call   801a3f <_Z8ipc_sendijPvi>
    return 0;
  803c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c3a:	c9                   	leave  
  803c3b:	c3                   	ret    

00803c3c <_Z7pagerefPv>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c3c:	55                   	push   %ebp
  803c3d:	89 e5                	mov    %esp,%ebp
  803c3f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803c42:	89 d0                	mov    %edx,%eax
  803c44:	c1 e8 16             	shr    $0x16,%eax
  803c47:	8b 0c 85 00 e0 bb ef 	mov    -0x10442000(,%eax,4),%ecx
		return 0;
  803c4e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803c53:	f6 c1 01             	test   $0x1,%cl
  803c56:	74 1d                	je     803c75 <_Z7pagerefPv+0x39>
		return 0;
	pte = vpt[PGNUM(v)];
  803c58:	c1 ea 0c             	shr    $0xc,%edx
  803c5b:	8b 14 95 00 00 80 ef 	mov    -0x10800000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803c62:	f6 c2 01             	test   $0x1,%dl
  803c65:	74 0e                	je     803c75 <_Z7pagerefPv+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803c67:	c1 ea 0c             	shr    $0xc,%edx
  803c6a:	0f b7 04 d5 04 00 40 	movzwl -0x10bffffc(,%edx,8),%eax
  803c71:	ef 
  803c72:	0f b7 c0             	movzwl %ax,%eax
}
  803c75:	5d                   	pop    %ebp
  803c76:	c3                   	ret    
	...

00803c80 <_ZL12devsock_statP2FdP4Stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803c80:	55                   	push   %ebp
  803c81:	89 e5                	mov    %esp,%ebp
  803c83:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803c86:	c7 44 24 04 13 52 80 	movl   $0x805213,0x4(%esp)
  803c8d:	00 
  803c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c91:	89 04 24             	mov    %eax,(%esp)
  803c94:	e8 f1 d3 ff ff       	call   80108a <_Z6strcpyPcPKc>
	return 0;
}
  803c99:	b8 00 00 00 00       	mov    $0x0,%eax
  803c9e:	c9                   	leave  
  803c9f:	c3                   	ret    

00803ca0 <_ZL13devsock_closeP2Fd>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803ca0:	55                   	push   %ebp
  803ca1:	89 e5                	mov    %esp,%ebp
  803ca3:	53                   	push   %ebx
  803ca4:	83 ec 14             	sub    $0x14,%esp
  803ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  803caa:	89 1c 24             	mov    %ebx,(%esp)
  803cad:	e8 8a ff ff ff       	call   803c3c <_Z7pagerefPv>
  803cb2:	89 c2                	mov    %eax,%edx
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803cb9:	83 fa 01             	cmp    $0x1,%edx
  803cbc:	75 0b                	jne    803cc9 <_ZL13devsock_closeP2Fd+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  803cbe:	8b 43 0c             	mov    0xc(%ebx),%eax
  803cc1:	89 04 24             	mov    %eax,(%esp)
  803cc4:	e8 fe 02 00 00       	call   803fc7 <_Z11nsipc_closei>
	else
		return 0;
}
  803cc9:	83 c4 14             	add    $0x14,%esp
  803ccc:	5b                   	pop    %ebx
  803ccd:	5d                   	pop    %ebp
  803cce:	c3                   	ret    

00803ccf <_ZL13devsock_writeP2FdPKvj>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803ccf:	55                   	push   %ebp
  803cd0:	89 e5                	mov    %esp,%ebp
  803cd2:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803cd5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803cdc:	00 
  803cdd:	8b 45 10             	mov    0x10(%ebp),%eax
  803ce0:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cee:	8b 40 0c             	mov    0xc(%eax),%eax
  803cf1:	89 04 24             	mov    %eax,(%esp)
  803cf4:	e8 c9 03 00 00       	call   8040c2 <_Z10nsipc_sendiPKvij>
}
  803cf9:	c9                   	leave  
  803cfa:	c3                   	ret    

00803cfb <_ZL12devsock_readP2FdPvj>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803cfb:	55                   	push   %ebp
  803cfc:	89 e5                	mov    %esp,%ebp
  803cfe:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803d01:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803d08:	00 
  803d09:	8b 45 10             	mov    0x10(%ebp),%eax
  803d0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d13:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d17:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1a:	8b 40 0c             	mov    0xc(%eax),%eax
  803d1d:	89 04 24             	mov    %eax,(%esp)
  803d20:	e8 1d 03 00 00       	call   804042 <_Z10nsipc_recviPvij>
}
  803d25:	c9                   	leave  
  803d26:	c3                   	ret    

00803d27 <_ZL12alloc_sockfdi>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803d27:	55                   	push   %ebp
  803d28:	89 e5                	mov    %esp,%ebp
  803d2a:	83 ec 28             	sub    $0x28,%esp
  803d2d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803d30:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803d33:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_find_unused(&sfd)) < 0
  803d35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803d38:	89 04 24             	mov    %eax,(%esp)
  803d3b:	e8 a7 de ff ff       	call   801be7 <_Z14fd_find_unusedPP2Fd>
  803d40:	89 c3                	mov    %eax,%ebx
  803d42:	85 c0                	test   %eax,%eax
  803d44:	78 21                	js     803d67 <_ZL12alloc_sockfdi+0x40>
  803d46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803d4d:	00 
  803d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d5c:	e8 0f d8 ff ff       	call   801570 <_Z14sys_page_allociPvi>
  803d61:	89 c3                	mov    %eax,%ebx
  803d63:	85 c0                	test   %eax,%eax
  803d65:	79 14                	jns    803d7b <_ZL12alloc_sockfdi+0x54>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
  803d67:	89 34 24             	mov    %esi,(%esp)
  803d6a:	e8 58 02 00 00       	call   803fc7 <_Z11nsipc_closei>

	sfd->fd_dev_id = devsock.dev_id;
	sfd->fd_omode = O_RDWR;
	sfd->fd_sock.sockid = sockid;
	return fd2num(sfd);
}
  803d6f:	89 d8                	mov    %ebx,%eax
  803d71:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803d74:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803d77:	89 ec                	mov    %ebp,%esp
  803d79:	5d                   	pop    %ebp
  803d7a:	c3                   	ret    
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
		nsipc_close(sockid);
		return r;
	}

	sfd->fd_dev_id = devsock.dev_id;
  803d7b:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d84:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d89:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803d90:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803d93:	89 04 24             	mov    %eax,(%esp)
  803d96:	e8 e9 dd ff ff       	call   801b84 <_Z6fd2numP2Fd>
  803d9b:	89 c3                	mov    %eax,%ebx
  803d9d:	eb d0                	jmp    803d6f <_ZL12alloc_sockfdi+0x48>

00803d9f <_ZL9fd2sockidi>:
    devsock_stat,
};

static int
fd2sockid(int fd)
{
  803d9f:	55                   	push   %ebp
  803da0:	89 e5                	mov    %esp,%ebp
  803da2:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
  803da5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803dac:	00 
  803dad:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803db0:	89 54 24 04          	mov    %edx,0x4(%esp)
  803db4:	89 04 24             	mov    %eax,(%esp)
  803db7:	e8 75 dd ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  803dbc:	85 c0                	test   %eax,%eax
  803dbe:	78 15                	js     803dd5 <_ZL9fd2sockidi+0x36>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803dc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
		return -E_NOT_SUPP;
  803dc3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd, 0)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803dc8:	8b 0d 40 60 80 00    	mov    0x806040,%ecx
  803dce:	39 0a                	cmp    %ecx,(%edx)
  803dd0:	75 03                	jne    803dd5 <_ZL9fd2sockidi+0x36>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803dd2:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803dd5:	c9                   	leave  
  803dd6:	c3                   	ret    

00803dd7 <_Z6acceptiP8sockaddrPj>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803dd7:	55                   	push   %ebp
  803dd8:	89 e5                	mov    %esp,%ebp
  803dda:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  803de0:	e8 ba ff ff ff       	call   803d9f <_ZL9fd2sockidi>
  803de5:	85 c0                	test   %eax,%eax
  803de7:	78 1f                	js     803e08 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803de9:	8b 55 10             	mov    0x10(%ebp),%edx
  803dec:	89 54 24 08          	mov    %edx,0x8(%esp)
  803df0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803df3:	89 54 24 04          	mov    %edx,0x4(%esp)
  803df7:	89 04 24             	mov    %eax,(%esp)
  803dfa:	e8 19 01 00 00       	call   803f18 <_Z12nsipc_acceptiP8sockaddrPj>
  803dff:	85 c0                	test   %eax,%eax
  803e01:	78 05                	js     803e08 <_Z6acceptiP8sockaddrPj+0x31>
		return r;
	return alloc_sockfd(r);
  803e03:	e8 1f ff ff ff       	call   803d27 <_ZL12alloc_sockfdi>
}
  803e08:	c9                   	leave  
  803e09:	c3                   	ret    

00803e0a <_Z4bindiP8sockaddrj>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803e0a:	55                   	push   %ebp
  803e0b:	89 e5                	mov    %esp,%ebp
  803e0d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e10:	8b 45 08             	mov    0x8(%ebp),%eax
  803e13:	e8 87 ff ff ff       	call   803d9f <_ZL9fd2sockidi>
  803e18:	85 c0                	test   %eax,%eax
  803e1a:	78 16                	js     803e32 <_Z4bindiP8sockaddrj+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803e1c:	8b 55 10             	mov    0x10(%ebp),%edx
  803e1f:	89 54 24 08          	mov    %edx,0x8(%esp)
  803e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e26:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e2a:	89 04 24             	mov    %eax,(%esp)
  803e2d:	e8 34 01 00 00       	call   803f66 <_Z10nsipc_bindiP8sockaddrj>
}
  803e32:	c9                   	leave  
  803e33:	c3                   	ret    

00803e34 <_Z8shutdownii>:

int
shutdown(int s, int how)
{
  803e34:	55                   	push   %ebp
  803e35:	89 e5                	mov    %esp,%ebp
  803e37:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3d:	e8 5d ff ff ff       	call   803d9f <_ZL9fd2sockidi>
  803e42:	85 c0                	test   %eax,%eax
  803e44:	78 0f                	js     803e55 <_Z8shutdownii+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e49:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e4d:	89 04 24             	mov    %eax,(%esp)
  803e50:	e8 50 01 00 00       	call   803fa5 <_Z14nsipc_shutdownii>
}
  803e55:	c9                   	leave  
  803e56:	c3                   	ret    

00803e57 <_Z7connectiPK8sockaddrj>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803e57:	55                   	push   %ebp
  803e58:	89 e5                	mov    %esp,%ebp
  803e5a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e60:	e8 3a ff ff ff       	call   803d9f <_ZL9fd2sockidi>
  803e65:	85 c0                	test   %eax,%eax
  803e67:	78 16                	js     803e7f <_Z7connectiPK8sockaddrj+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803e69:	8b 55 10             	mov    0x10(%ebp),%edx
  803e6c:	89 54 24 08          	mov    %edx,0x8(%esp)
  803e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e73:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e77:	89 04 24             	mov    %eax,(%esp)
  803e7a:	e8 62 01 00 00       	call   803fe1 <_Z13nsipc_connectiPK8sockaddrj>
}
  803e7f:	c9                   	leave  
  803e80:	c3                   	ret    

00803e81 <_Z6listenii>:

int
listen(int s, int backlog)
{
  803e81:	55                   	push   %ebp
  803e82:	89 e5                	mov    %esp,%ebp
  803e84:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e87:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8a:	e8 10 ff ff ff       	call   803d9f <_ZL9fd2sockidi>
  803e8f:	85 c0                	test   %eax,%eax
  803e91:	78 0f                	js     803ea2 <_Z6listenii+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e96:	89 54 24 04          	mov    %edx,0x4(%esp)
  803e9a:	89 04 24             	mov    %eax,(%esp)
  803e9d:	e8 7e 01 00 00       	call   804020 <_Z12nsipc_listenii>
}
  803ea2:	c9                   	leave  
  803ea3:	c3                   	ret    

00803ea4 <_Z6socketiii>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803ea4:	55                   	push   %ebp
  803ea5:	89 e5                	mov    %esp,%ebp
  803ea7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  803ead:	89 44 24 08          	mov    %eax,0x8(%esp)
  803eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ebb:	89 04 24             	mov    %eax,(%esp)
  803ebe:	e8 72 02 00 00       	call   804135 <_Z12nsipc_socketiii>
  803ec3:	85 c0                	test   %eax,%eax
  803ec5:	78 05                	js     803ecc <_Z6socketiii+0x28>
		return r;
	return alloc_sockfd(r);
  803ec7:	e8 5b fe ff ff       	call   803d27 <_ZL12alloc_sockfdi>
}
  803ecc:	c9                   	leave  
  803ecd:	8d 76 00             	lea    0x0(%esi),%esi
  803ed0:	c3                   	ret    
  803ed1:	00 00                	add    %al,(%eax)
	...

00803ed4 <_ZL5nsipcj>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803ed4:	55                   	push   %ebp
  803ed5:	89 e5                	mov    %esp,%ebp
  803ed7:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803eda:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803ee1:	00 
  803ee2:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803ee9:	00 
  803eea:	89 44 24 04          	mov    %eax,0x4(%esp)
  803eee:	c7 04 24 01 11 00 00 	movl   $0x1101,(%esp)
  803ef5:	e8 45 db ff ff       	call   801a3f <_Z8ipc_sendijPvi>
	return ipc_recv(NULL, NULL, NULL);
  803efa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803f01:	00 
  803f02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803f09:	00 
  803f0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f11:	e8 9a da ff ff       	call   8019b0 <_Z8ipc_recvPiPvS_>
}
  803f16:	c9                   	leave  
  803f17:	c3                   	ret    

00803f18 <_Z12nsipc_acceptiP8sockaddrPj>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803f18:	55                   	push   %ebp
  803f19:	89 e5                	mov    %esp,%ebp
  803f1b:	53                   	push   %ebx
  803f1c:	83 ec 14             	sub    $0x14,%esp
	int r;

	nsipcbuf.accept.req_s = s;
  803f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f22:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803f27:	b8 01 00 00 00       	mov    $0x1,%eax
  803f2c:	e8 a3 ff ff ff       	call   803ed4 <_ZL5nsipcj>
  803f31:	89 c3                	mov    %eax,%ebx
  803f33:	85 c0                	test   %eax,%eax
  803f35:	78 27                	js     803f5e <_Z12nsipc_acceptiP8sockaddrPj+0x46>
		memmove(addr, &nsipcbuf.acceptRet.ret_addr, nsipcbuf.acceptRet.ret_addrlen);
  803f37:	a1 10 80 80 00       	mov    0x808010,%eax
  803f3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803f40:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803f47:	00 
  803f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f4b:	89 04 24             	mov    %eax,(%esp)
  803f4e:	e8 d9 d2 ff ff       	call   80122c <memmove>
		*addrlen = nsipcbuf.acceptRet.ret_addrlen;
  803f53:	8b 15 10 80 80 00    	mov    0x808010,%edx
  803f59:	8b 45 10             	mov    0x10(%ebp),%eax
  803f5c:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803f5e:	89 d8                	mov    %ebx,%eax
  803f60:	83 c4 14             	add    $0x14,%esp
  803f63:	5b                   	pop    %ebx
  803f64:	5d                   	pop    %ebp
  803f65:	c3                   	ret    

00803f66 <_Z10nsipc_bindiP8sockaddrj>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f66:	55                   	push   %ebp
  803f67:	89 e5                	mov    %esp,%ebp
  803f69:	53                   	push   %ebx
  803f6a:	83 ec 14             	sub    $0x14,%esp
  803f6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803f70:	8b 45 08             	mov    0x8(%ebp),%eax
  803f73:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803f78:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f83:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803f8a:	e8 9d d2 ff ff       	call   80122c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803f8f:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  803f95:	b8 02 00 00 00       	mov    $0x2,%eax
  803f9a:	e8 35 ff ff ff       	call   803ed4 <_ZL5nsipcj>
}
  803f9f:	83 c4 14             	add    $0x14,%esp
  803fa2:	5b                   	pop    %ebx
  803fa3:	5d                   	pop    %ebp
  803fa4:	c3                   	ret    

00803fa5 <_Z14nsipc_shutdownii>:

int
nsipc_shutdown(int s, int how)
{
  803fa5:	55                   	push   %ebp
  803fa6:	89 e5                	mov    %esp,%ebp
  803fa8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803fab:	8b 45 08             	mov    0x8(%ebp),%eax
  803fae:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fb6:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803fbb:	b8 03 00 00 00       	mov    $0x3,%eax
  803fc0:	e8 0f ff ff ff       	call   803ed4 <_ZL5nsipcj>
}
  803fc5:	c9                   	leave  
  803fc6:	c3                   	ret    

00803fc7 <_Z11nsipc_closei>:

int
nsipc_close(int s)
{
  803fc7:	55                   	push   %ebp
  803fc8:	89 e5                	mov    %esp,%ebp
  803fca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd0:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803fd5:	b8 04 00 00 00       	mov    $0x4,%eax
  803fda:	e8 f5 fe ff ff       	call   803ed4 <_ZL5nsipcj>
}
  803fdf:	c9                   	leave  
  803fe0:	c3                   	ret    

00803fe1 <_Z13nsipc_connectiPK8sockaddrj>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803fe1:	55                   	push   %ebp
  803fe2:	89 e5                	mov    %esp,%ebp
  803fe4:	53                   	push   %ebx
  803fe5:	83 ec 14             	sub    $0x14,%esp
  803fe8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803feb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fee:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ff3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ffa:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ffe:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  804005:	e8 22 d2 ff ff       	call   80122c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80400a:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  804010:	b8 05 00 00 00       	mov    $0x5,%eax
  804015:	e8 ba fe ff ff       	call   803ed4 <_ZL5nsipcj>
}
  80401a:	83 c4 14             	add    $0x14,%esp
  80401d:	5b                   	pop    %ebx
  80401e:	5d                   	pop    %ebp
  80401f:	c3                   	ret    

00804020 <_Z12nsipc_listenii>:

int
nsipc_listen(int s, int backlog)
{
  804020:	55                   	push   %ebp
  804021:	89 e5                	mov    %esp,%ebp
  804023:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  804026:	8b 45 08             	mov    0x8(%ebp),%eax
  804029:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  80402e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804031:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  804036:	b8 06 00 00 00       	mov    $0x6,%eax
  80403b:	e8 94 fe ff ff       	call   803ed4 <_ZL5nsipcj>
}
  804040:	c9                   	leave  
  804041:	c3                   	ret    

00804042 <_Z10nsipc_recviPvij>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804042:	55                   	push   %ebp
  804043:	89 e5                	mov    %esp,%ebp
  804045:	56                   	push   %esi
  804046:	53                   	push   %ebx
  804047:	83 ec 10             	sub    $0x10,%esp
  80404a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80404d:	8b 45 08             	mov    0x8(%ebp),%eax
  804050:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  804055:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80405b:	8b 45 14             	mov    0x14(%ebp),%eax
  80405e:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804063:	b8 07 00 00 00       	mov    $0x7,%eax
  804068:	e8 67 fe ff ff       	call   803ed4 <_ZL5nsipcj>
  80406d:	89 c3                	mov    %eax,%ebx
  80406f:	85 c0                	test   %eax,%eax
  804071:	78 46                	js     8040b9 <_Z10nsipc_recviPvij+0x77>
		assert(r < 1600 && r <= len);
  804073:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  804078:	7f 04                	jg     80407e <_Z10nsipc_recviPvij+0x3c>
  80407a:	39 f0                	cmp    %esi,%eax
  80407c:	7e 24                	jle    8040a2 <_Z10nsipc_recviPvij+0x60>
  80407e:	c7 44 24 0c 1f 52 80 	movl   $0x80521f,0xc(%esp)
  804085:	00 
  804086:	c7 44 24 08 fd 46 80 	movl   $0x8046fd,0x8(%esp)
  80408d:	00 
  80408e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  804095:	00 
  804096:	c7 04 24 34 52 80 00 	movl   $0x805234,(%esp)
  80409d:	e8 b2 c8 ff ff       	call   800954 <_Z6_panicPKciS0_z>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8040a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8040a6:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8040ad:	00 
  8040ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040b1:	89 04 24             	mov    %eax,(%esp)
  8040b4:	e8 73 d1 ff ff       	call   80122c <memmove>
	}

	return r;
}
  8040b9:	89 d8                	mov    %ebx,%eax
  8040bb:	83 c4 10             	add    $0x10,%esp
  8040be:	5b                   	pop    %ebx
  8040bf:	5e                   	pop    %esi
  8040c0:	5d                   	pop    %ebp
  8040c1:	c3                   	ret    

008040c2 <_Z10nsipc_sendiPKvij>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8040c2:	55                   	push   %ebp
  8040c3:	89 e5                	mov    %esp,%ebp
  8040c5:	53                   	push   %ebx
  8040c6:	83 ec 14             	sub    $0x14,%esp
  8040c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8040cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cf:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8040d4:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8040da:	7e 24                	jle    804100 <_Z10nsipc_sendiPKvij+0x3e>
  8040dc:	c7 44 24 0c 40 52 80 	movl   $0x805240,0xc(%esp)
  8040e3:	00 
  8040e4:	c7 44 24 08 fd 46 80 	movl   $0x8046fd,0x8(%esp)
  8040eb:	00 
  8040ec:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  8040f3:	00 
  8040f4:	c7 04 24 34 52 80 00 	movl   $0x805234,(%esp)
  8040fb:	e8 54 c8 ff ff       	call   800954 <_Z6_panicPKciS0_z>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804100:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804104:	8b 45 0c             	mov    0xc(%ebp),%eax
  804107:	89 44 24 04          	mov    %eax,0x4(%esp)
  80410b:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  804112:	e8 15 d1 ff ff       	call   80122c <memmove>
	nsipcbuf.send.req_size = size;
  804117:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  80411d:	8b 45 14             	mov    0x14(%ebp),%eax
  804120:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  804125:	b8 08 00 00 00       	mov    $0x8,%eax
  80412a:	e8 a5 fd ff ff       	call   803ed4 <_ZL5nsipcj>
}
  80412f:	83 c4 14             	add    $0x14,%esp
  804132:	5b                   	pop    %ebx
  804133:	5d                   	pop    %ebp
  804134:	c3                   	ret    

00804135 <_Z12nsipc_socketiii>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804135:	55                   	push   %ebp
  804136:	89 e5                	mov    %esp,%ebp
  804138:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80413b:	8b 45 08             	mov    0x8(%ebp),%eax
  80413e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  804143:	8b 45 0c             	mov    0xc(%ebp),%eax
  804146:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  80414b:	8b 45 10             	mov    0x10(%ebp),%eax
  80414e:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  804153:	b8 09 00 00 00       	mov    $0x9,%eax
  804158:	e8 77 fd ff ff       	call   803ed4 <_ZL5nsipcj>
}
  80415d:	c9                   	leave  
  80415e:	c3                   	ret    
	...

00804160 <_ZL13devcons_closeP2Fd>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  804160:	55                   	push   %ebp
  804161:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  804163:	b8 00 00 00 00       	mov    $0x0,%eax
  804168:	5d                   	pop    %ebp
  804169:	c3                   	ret    

0080416a <_ZL12devcons_statP2FdP4Stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80416a:	55                   	push   %ebp
  80416b:	89 e5                	mov    %esp,%ebp
  80416d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  804170:	c7 44 24 04 4c 52 80 	movl   $0x80524c,0x4(%esp)
  804177:	00 
  804178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80417b:	89 04 24             	mov    %eax,(%esp)
  80417e:	e8 07 cf ff ff       	call   80108a <_Z6strcpyPcPKc>
	return 0;
}
  804183:	b8 00 00 00 00       	mov    $0x0,%eax
  804188:	c9                   	leave  
  804189:	c3                   	ret    

0080418a <_ZL13devcons_writeP2FdPKvj>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80418a:	55                   	push   %ebp
  80418b:	89 e5                	mov    %esp,%ebp
  80418d:	57                   	push   %edi
  80418e:	56                   	push   %esi
  80418f:	53                   	push   %ebx
  804190:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804196:	bb 00 00 00 00       	mov    $0x0,%ebx
  80419b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80419f:	74 3e                	je     8041df <_ZL13devcons_writeP2FdPKvj+0x55>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8041a1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8041a7:	8b 75 10             	mov    0x10(%ebp),%esi
  8041aa:	29 de                	sub    %ebx,%esi
  8041ac:	83 fe 7f             	cmp    $0x7f,%esi
  8041af:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8041b4:	0f 47 f0             	cmova  %eax,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8041b7:	89 74 24 08          	mov    %esi,0x8(%esp)
  8041bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041be:	01 d8                	add    %ebx,%eax
  8041c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041c4:	89 3c 24             	mov    %edi,(%esp)
  8041c7:	e8 60 d0 ff ff       	call   80122c <memmove>
		sys_cputs(buf, m);
  8041cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8041d0:	89 3c 24             	mov    %edi,(%esp)
  8041d3:	e8 6c d2 ff ff       	call   801444 <_Z9sys_cputsPKcj>
	size_t tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041d8:	01 f3                	add    %esi,%ebx
  8041da:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  8041dd:	77 c8                	ja     8041a7 <_ZL13devcons_writeP2FdPKvj+0x1d>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8041df:	89 d8                	mov    %ebx,%eax
  8041e1:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8041e7:	5b                   	pop    %ebx
  8041e8:	5e                   	pop    %esi
  8041e9:	5f                   	pop    %edi
  8041ea:	5d                   	pop    %ebp
  8041eb:	c3                   	ret    

008041ec <_ZL12devcons_readP2FdPvj>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041ec:	55                   	push   %ebp
  8041ed:	89 e5                	mov    %esp,%ebp
  8041ef:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8041f2:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8041f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8041fb:	75 07                	jne    804204 <_ZL12devcons_readP2FdPvj+0x18>
  8041fd:	eb 2a                	jmp    804229 <_ZL12devcons_readP2FdPvj+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8041ff:	e8 38 d3 ff ff       	call   80153c <_Z9sys_yieldv>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804204:	e8 6e d2 ff ff       	call   801477 <_Z9sys_cgetcv>
  804209:	85 c0                	test   %eax,%eax
  80420b:	74 f2                	je     8041ff <_ZL12devcons_readP2FdPvj+0x13>
  80420d:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  80420f:	85 c0                	test   %eax,%eax
  804211:	78 16                	js     804229 <_ZL12devcons_readP2FdPvj+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  804213:	83 f8 04             	cmp    $0x4,%eax
  804216:	74 0c                	je     804224 <_ZL12devcons_readP2FdPvj+0x38>
		return 0;
	*(char*)vbuf = c;
  804218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80421b:	88 10                	mov    %dl,(%eax)
	return 1;
  80421d:	b8 01 00 00 00       	mov    $0x1,%eax
  804222:	eb 05                	jmp    804229 <_ZL12devcons_readP2FdPvj+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  804224:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  804229:	c9                   	leave  
  80422a:	c3                   	ret    

0080422b <_Z8cputchari>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80422b:	55                   	push   %ebp
  80422c:	89 e5                	mov    %esp,%ebp
  80422e:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  804231:	8b 45 08             	mov    0x8(%ebp),%eax
  804234:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804237:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80423e:	00 
  80423f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804242:	89 04 24             	mov    %eax,(%esp)
  804245:	e8 fa d1 ff ff       	call   801444 <_Z9sys_cputsPKcj>
}
  80424a:	c9                   	leave  
  80424b:	c3                   	ret    

0080424c <_Z7getcharv>:

int
getchar(void)
{
  80424c:	55                   	push   %ebp
  80424d:	89 e5                	mov    %esp,%ebp
  80424f:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804252:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804259:	00 
  80425a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80425d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804261:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804268:	e8 71 dc ff ff       	call   801ede <_Z4readiPvj>
	if (r < 0)
  80426d:	85 c0                	test   %eax,%eax
  80426f:	78 0f                	js     804280 <_Z7getcharv+0x34>
		return r;
	if (r < 1)
  804271:	85 c0                	test   %eax,%eax
  804273:	7e 06                	jle    80427b <_Z7getcharv+0x2f>
		return -E_EOF;
	return c;
  804275:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  804279:	eb 05                	jmp    804280 <_Z7getcharv+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  80427b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  804280:	c9                   	leave  
  804281:	c3                   	ret    

00804282 <_Z6isconsi>:
	/* .dev_trunc = */	0
};

int
iscons(int fdnum)
{
  804282:	55                   	push   %ebp
  804283:	89 e5                	mov    %esp,%ebp
  804285:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;
	if ((r = fd_lookup(fdnum, &fd, true)) < 0)
  804288:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80428f:	00 
  804290:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804293:	89 44 24 04          	mov    %eax,0x4(%esp)
  804297:	8b 45 08             	mov    0x8(%ebp),%eax
  80429a:	89 04 24             	mov    %eax,(%esp)
  80429d:	e8 8f d8 ff ff       	call   801b31 <_Z9fd_lookupiPP2Fdb>
  8042a2:	85 c0                	test   %eax,%eax
  8042a4:	78 11                	js     8042b7 <_Z6isconsi+0x35>
		return r;
	else
		return fd->fd_dev_id == devcons.dev_id;
  8042a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042a9:	8b 15 5c 60 80 00    	mov    0x80605c,%edx
  8042af:	39 10                	cmp    %edx,(%eax)
  8042b1:	0f 94 c0             	sete   %al
  8042b4:	0f b6 c0             	movzbl %al,%eax
}
  8042b7:	c9                   	leave  
  8042b8:	c3                   	ret    

008042b9 <_Z8openconsv>:

int
opencons(void)
{
  8042b9:	55                   	push   %ebp
  8042ba:	89 e5                	mov    %esp,%ebp
  8042bc:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_find_unused(&fd)) < 0)
  8042bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8042c2:	89 04 24             	mov    %eax,(%esp)
  8042c5:	e8 1d d9 ff ff       	call   801be7 <_Z14fd_find_unusedPP2Fd>
  8042ca:	85 c0                	test   %eax,%eax
  8042cc:	78 3c                	js     80430a <_Z8openconsv+0x51>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8042ce:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8042d5:	00 
  8042d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8042e4:	e8 87 d2 ff ff       	call   801570 <_Z14sys_page_allociPvi>
  8042e9:	85 c0                	test   %eax,%eax
  8042eb:	78 1d                	js     80430a <_Z8openconsv+0x51>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8042ed:	8b 15 5c 60 80 00    	mov    0x80605c,%edx
  8042f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8042f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042fb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  804302:	89 04 24             	mov    %eax,(%esp)
  804305:	e8 7a d8 ff ff       	call   801b84 <_Z6fd2numP2Fd>
}
  80430a:	c9                   	leave  
  80430b:	c3                   	ret    
  80430c:	00 00                	add    %al,(%eax)
	...

00804310 <_pgfault_upcall>:
// The page fault handler function calls each user page fault handler in order.
// One of the page fault handlers should handle fault and call resume().
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
  804310:	55                   	push   %ebp
  804311:	89 e5                	mov    %esp,%ebp
  804313:	56                   	push   %esi
  804314:	53                   	push   %ebx
  804315:	83 ec 20             	sub    $0x20,%esp
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804318:	bb 07 00 00 00       	mov    $0x7,%ebx
		if (user_handlers[i])
  80431d:	8b 04 9d 00 90 80 00 	mov    0x809000(,%ebx,4),%eax
  804324:	85 c0                	test   %eax,%eax
  804326:	74 08                	je     804330 <_pgfault_upcall+0x20>
			user_handlers[i](&utf);
  804328:	8d 55 08             	lea    0x8(%ebp),%edx
  80432b:	89 14 24             	mov    %edx,(%esp)
  80432e:	ff d0                	call   *%eax
//
asmlinkage void
_pgfault_upcall(struct UTrapframe utf)
{
	int i;
	for (i = NUSER_HANDLERS - 1; i >= 0; --i)
  804330:	83 eb 01             	sub    $0x1,%ebx
  804333:	83 fb ff             	cmp    $0xffffffff,%ebx
  804336:	75 e5                	jne    80431d <_pgfault_upcall+0xd>
		if (user_handlers[i])
			user_handlers[i](&utf);

	panic("[%08x] unhandled page fault at va %08x from eip %08x\n",
  804338:	8b 5d 38             	mov    0x38(%ebp),%ebx
  80433b:	8b 75 08             	mov    0x8(%ebp),%esi
  80433e:	e8 c5 d1 ff ff       	call   801508 <_Z12sys_getenvidv>
	      sys_getenvid(), utf.utf_fault_va, utf.utf_eip);
  804343:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  804347:	89 74 24 10          	mov    %esi,0x10(%esp)
  80434b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80434f:	c7 44 24 08 58 52 80 	movl   $0x805258,0x8(%esp)
  804356:	00 
  804357:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80435e:	00 
  80435f:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  804366:	e8 e9 c5 ff ff       	call   800954 <_Z6_panicPKciS0_z>

0080436b <_Z19add_pgfault_handlerPFvP10UTrapframeE>:
// at UXSTACKTOP), and tell the kernel to call the
// _pgfault_upcall routine when a page fault occurs.
//
void
add_pgfault_handler(pgfault_handler_t handler)
{
  80436b:	55                   	push   %ebp
  80436c:	89 e5                	mov    %esp,%ebp
  80436e:	56                   	push   %esi
  80436f:	53                   	push   %ebx
  804370:	83 ec 10             	sub    $0x10,%esp
  804373:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    envid_t envid = sys_getenvid();
  804376:	e8 8d d1 ff ff       	call   801508 <_Z12sys_getenvidv>
  80437b:	89 c6                	mov    %eax,%esi
	if (!thisenv->env_pgfault_upcall) {
  80437d:	a1 00 70 80 00       	mov    0x807000,%eax
  804382:	8b 40 5c             	mov    0x5c(%eax),%eax
  804385:	85 c0                	test   %eax,%eax
  804387:	75 4c                	jne    8043d5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x6a>
	    if(sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P))
  804389:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  804390:	00 
  804391:	c7 44 24 04 00 f0 ff 	movl   $0xeefff000,0x4(%esp)
  804398:	ee 
  804399:	89 34 24             	mov    %esi,(%esp)
  80439c:	e8 cf d1 ff ff       	call   801570 <_Z14sys_page_allociPvi>
  8043a1:	85 c0                	test   %eax,%eax
  8043a3:	74 20                	je     8043c5 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x5a>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
  8043a5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8043a9:	c7 44 24 08 90 52 80 	movl   $0x805290,0x8(%esp)
  8043b0:	00 
  8043b1:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8043b8:	00 
  8043b9:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  8043c0:	e8 8f c5 ff ff       	call   800954 <_Z6_panicPKciS0_z>
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
  8043c5:	c7 44 24 04 10 43 80 	movl   $0x804310,0x4(%esp)
  8043cc:	00 
  8043cd:	89 34 24             	mov    %esi,(%esp)
  8043d0:	e8 d0 d3 ff ff       	call   8017a5 <_Z26sys_env_set_pgfault_upcalliPv>
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
		if (user_handlers[i] == handler || !user_handlers[i]) {
  8043d5:	a1 00 90 80 00       	mov    0x809000,%eax
  8043da:	39 d8                	cmp    %ebx,%eax
  8043dc:	74 1a                	je     8043f8 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x8d>
  8043de:	85 c0                	test   %eax,%eax
  8043e0:	74 20                	je     804402 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x97>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8043e2:	b8 01 00 00 00       	mov    $0x1,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
  8043e7:	8b 14 85 00 90 80 00 	mov    0x809000(,%eax,4),%edx
  8043ee:	39 da                	cmp    %ebx,%edx
  8043f0:	74 15                	je     804407 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  8043f2:	85 d2                	test   %edx,%edx
  8043f4:	75 1f                	jne    804415 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0xaa>
  8043f6:	eb 0f                	jmp    804407 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  8043f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8043fd:	8d 76 00             	lea    0x0(%esi),%esi
  804400:	eb 05                	jmp    804407 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x9c>
  804402:	b8 00 00 00 00       	mov    $0x0,%eax
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
  804407:	89 1c 85 00 90 80 00 	mov    %ebx,0x809000(,%eax,4)
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
}
  80440e:	83 c4 10             	add    $0x10,%esp
  804411:	5b                   	pop    %ebx
  804412:	5e                   	pop    %esi
  804413:	5d                   	pop    %ebp
  804414:	c3                   	ret    
	        panic("[%08x] couldn't allocate UXSTACK\n", envid);
        sys_env_set_pgfault_upcall(envid, (void *)_pgfault_upcall);
    }

	// Store handler pointer in our list of handlers.
	for (int i = 0; i < NUSER_HANDLERS; ++i)
  804415:	83 c0 01             	add    $0x1,%eax
  804418:	83 f8 08             	cmp    $0x8,%eax
  80441b:	75 ca                	jne    8043e7 <_Z19add_pgfault_handlerPFvP10UTrapframeE+0x7c>
		if (user_handlers[i] == handler || !user_handlers[i]) {
			user_handlers[i] = handler;
			return;
		}

	panic("[%08x] too many page fault handlers\n", envid);
  80441d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  804421:	c7 44 24 08 b4 52 80 	movl   $0x8052b4,0x8(%esp)
  804428:	00 
  804429:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  804430:	00 
  804431:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  804438:	e8 17 c5 ff ff       	call   800954 <_Z6_panicPKciS0_z>
  80443d:	00 00                	add    %al,(%eax)
	...

00804440 <resume>:
  804440:	83 c4 04             	add    $0x4,%esp
  804443:	5c                   	pop    %esp
  804444:	83 c4 08             	add    $0x8,%esp
  804447:	8b 44 24 28          	mov    0x28(%esp),%eax
  80444b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  80444f:	83 eb 04             	sub    $0x4,%ebx
  804452:	89 03                	mov    %eax,(%ebx)
  804454:	89 5c 24 24          	mov    %ebx,0x24(%esp)
  804458:	61                   	popa   
  804459:	9d                   	popf   
  80445a:	5c                   	pop    %esp
  80445b:	c3                   	ret    

0080445c <spin>:
  80445c:	eb fe                	jmp    80445c <spin>
	...

00804460 <__udivdi3>:
  804460:	55                   	push   %ebp
  804461:	89 e5                	mov    %esp,%ebp
  804463:	57                   	push   %edi
  804464:	56                   	push   %esi
  804465:	83 ec 20             	sub    $0x20,%esp
  804468:	8b 45 14             	mov    0x14(%ebp),%eax
  80446b:	8b 75 08             	mov    0x8(%ebp),%esi
  80446e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804471:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804474:	85 c0                	test   %eax,%eax
  804476:	89 75 e8             	mov    %esi,-0x18(%ebp)
  804479:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80447c:	75 3a                	jne    8044b8 <__udivdi3+0x58>
  80447e:	39 f9                	cmp    %edi,%ecx
  804480:	77 66                	ja     8044e8 <__udivdi3+0x88>
  804482:	85 c9                	test   %ecx,%ecx
  804484:	75 0b                	jne    804491 <__udivdi3+0x31>
  804486:	b8 01 00 00 00       	mov    $0x1,%eax
  80448b:	31 d2                	xor    %edx,%edx
  80448d:	f7 f1                	div    %ecx
  80448f:	89 c1                	mov    %eax,%ecx
  804491:	89 f8                	mov    %edi,%eax
  804493:	31 d2                	xor    %edx,%edx
  804495:	f7 f1                	div    %ecx
  804497:	89 c7                	mov    %eax,%edi
  804499:	89 f0                	mov    %esi,%eax
  80449b:	f7 f1                	div    %ecx
  80449d:	89 fa                	mov    %edi,%edx
  80449f:	89 c6                	mov    %eax,%esi
  8044a1:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8044a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8044a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8044ad:	83 c4 20             	add    $0x20,%esp
  8044b0:	5e                   	pop    %esi
  8044b1:	5f                   	pop    %edi
  8044b2:	5d                   	pop    %ebp
  8044b3:	c3                   	ret    
  8044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8044b8:	31 d2                	xor    %edx,%edx
  8044ba:	31 f6                	xor    %esi,%esi
  8044bc:	39 f8                	cmp    %edi,%eax
  8044be:	77 e1                	ja     8044a1 <__udivdi3+0x41>
  8044c0:	0f bd d0             	bsr    %eax,%edx
  8044c3:	83 f2 1f             	xor    $0x1f,%edx
  8044c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8044c9:	75 2d                	jne    8044f8 <__udivdi3+0x98>
  8044cb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8044ce:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  8044d1:	76 06                	jbe    8044d9 <__udivdi3+0x79>
  8044d3:	39 f8                	cmp    %edi,%eax
  8044d5:	89 f2                	mov    %esi,%edx
  8044d7:	73 c8                	jae    8044a1 <__udivdi3+0x41>
  8044d9:	31 d2                	xor    %edx,%edx
  8044db:	be 01 00 00 00       	mov    $0x1,%esi
  8044e0:	eb bf                	jmp    8044a1 <__udivdi3+0x41>
  8044e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8044e8:	89 f0                	mov    %esi,%eax
  8044ea:	89 fa                	mov    %edi,%edx
  8044ec:	f7 f1                	div    %ecx
  8044ee:	31 d2                	xor    %edx,%edx
  8044f0:	89 c6                	mov    %eax,%esi
  8044f2:	eb ad                	jmp    8044a1 <__udivdi3+0x41>
  8044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8044f8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8044fc:	89 c2                	mov    %eax,%edx
  8044fe:	b8 20 00 00 00       	mov    $0x20,%eax
  804503:	8b 75 f0             	mov    -0x10(%ebp),%esi
  804506:	2b 45 ec             	sub    -0x14(%ebp),%eax
  804509:	d3 e2                	shl    %cl,%edx
  80450b:	89 c1                	mov    %eax,%ecx
  80450d:	d3 ee                	shr    %cl,%esi
  80450f:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804513:	09 d6                	or     %edx,%esi
  804515:	89 fa                	mov    %edi,%edx
  804517:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80451a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  80451d:	d3 e6                	shl    %cl,%esi
  80451f:	89 c1                	mov    %eax,%ecx
  804521:	d3 ea                	shr    %cl,%edx
  804523:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804527:	89 75 f0             	mov    %esi,-0x10(%ebp)
  80452a:	8b 75 e8             	mov    -0x18(%ebp),%esi
  80452d:	d3 e7                	shl    %cl,%edi
  80452f:	89 c1                	mov    %eax,%ecx
  804531:	d3 ee                	shr    %cl,%esi
  804533:	09 fe                	or     %edi,%esi
  804535:	89 f0                	mov    %esi,%eax
  804537:	f7 75 e4             	divl   -0x1c(%ebp)
  80453a:	89 d7                	mov    %edx,%edi
  80453c:	89 c6                	mov    %eax,%esi
  80453e:	f7 65 f0             	mull   -0x10(%ebp)
  804541:	39 d7                	cmp    %edx,%edi
  804543:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  804546:	72 12                	jb     80455a <__udivdi3+0xfa>
  804548:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80454b:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80454f:	d3 e2                	shl    %cl,%edx
  804551:	39 c2                	cmp    %eax,%edx
  804553:	73 08                	jae    80455d <__udivdi3+0xfd>
  804555:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  804558:	75 03                	jne    80455d <__udivdi3+0xfd>
  80455a:	83 ee 01             	sub    $0x1,%esi
  80455d:	31 d2                	xor    %edx,%edx
  80455f:	e9 3d ff ff ff       	jmp    8044a1 <__udivdi3+0x41>
	...

00804570 <__umoddi3>:
  804570:	55                   	push   %ebp
  804571:	89 e5                	mov    %esp,%ebp
  804573:	57                   	push   %edi
  804574:	56                   	push   %esi
  804575:	83 ec 20             	sub    $0x20,%esp
  804578:	8b 7d 14             	mov    0x14(%ebp),%edi
  80457b:	8b 45 08             	mov    0x8(%ebp),%eax
  80457e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804581:	8b 75 0c             	mov    0xc(%ebp),%esi
  804584:	85 ff                	test   %edi,%edi
  804586:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804589:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80458c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80458f:	89 f2                	mov    %esi,%edx
  804591:	75 15                	jne    8045a8 <__umoddi3+0x38>
  804593:	39 f1                	cmp    %esi,%ecx
  804595:	76 41                	jbe    8045d8 <__umoddi3+0x68>
  804597:	f7 f1                	div    %ecx
  804599:	89 d0                	mov    %edx,%eax
  80459b:	31 d2                	xor    %edx,%edx
  80459d:	83 c4 20             	add    $0x20,%esp
  8045a0:	5e                   	pop    %esi
  8045a1:	5f                   	pop    %edi
  8045a2:	5d                   	pop    %ebp
  8045a3:	c3                   	ret    
  8045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8045a8:	39 f7                	cmp    %esi,%edi
  8045aa:	77 4c                	ja     8045f8 <__umoddi3+0x88>
  8045ac:	0f bd c7             	bsr    %edi,%eax
  8045af:	83 f0 1f             	xor    $0x1f,%eax
  8045b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8045b5:	75 51                	jne    804608 <__umoddi3+0x98>
  8045b7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  8045ba:	0f 87 e8 00 00 00    	ja     8046a8 <__umoddi3+0x138>
  8045c0:	89 f2                	mov    %esi,%edx
  8045c2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  8045c5:	29 ce                	sub    %ecx,%esi
  8045c7:	19 fa                	sbb    %edi,%edx
  8045c9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  8045cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045cf:	83 c4 20             	add    $0x20,%esp
  8045d2:	5e                   	pop    %esi
  8045d3:	5f                   	pop    %edi
  8045d4:	5d                   	pop    %ebp
  8045d5:	c3                   	ret    
  8045d6:	66 90                	xchg   %ax,%ax
  8045d8:	85 c9                	test   %ecx,%ecx
  8045da:	75 0b                	jne    8045e7 <__umoddi3+0x77>
  8045dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8045e1:	31 d2                	xor    %edx,%edx
  8045e3:	f7 f1                	div    %ecx
  8045e5:	89 c1                	mov    %eax,%ecx
  8045e7:	89 f0                	mov    %esi,%eax
  8045e9:	31 d2                	xor    %edx,%edx
  8045eb:	f7 f1                	div    %ecx
  8045ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045f0:	eb a5                	jmp    804597 <__umoddi3+0x27>
  8045f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8045f8:	89 f2                	mov    %esi,%edx
  8045fa:	83 c4 20             	add    $0x20,%esp
  8045fd:	5e                   	pop    %esi
  8045fe:	5f                   	pop    %edi
  8045ff:	5d                   	pop    %ebp
  804600:	c3                   	ret    
  804601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804608:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80460c:	89 f2                	mov    %esi,%edx
  80460e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804611:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  804618:	29 45 f0             	sub    %eax,-0x10(%ebp)
  80461b:	d3 e7                	shl    %cl,%edi
  80461d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804620:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804624:	d3 e8                	shr    %cl,%eax
  804626:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80462a:	09 f8                	or     %edi,%eax
  80462c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80462f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804632:	d3 e0                	shl    %cl,%eax
  804634:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804638:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80463b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80463e:	d3 ea                	shr    %cl,%edx
  804640:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804644:	d3 e6                	shl    %cl,%esi
  804646:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80464a:	d3 e8                	shr    %cl,%eax
  80464c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804650:	09 f0                	or     %esi,%eax
  804652:	8b 75 e8             	mov    -0x18(%ebp),%esi
  804655:	f7 75 e4             	divl   -0x1c(%ebp)
  804658:	d3 e6                	shl    %cl,%esi
  80465a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80465d:	89 d6                	mov    %edx,%esi
  80465f:	f7 65 f4             	mull   -0xc(%ebp)
  804662:	89 d7                	mov    %edx,%edi
  804664:	89 c2                	mov    %eax,%edx
  804666:	39 fe                	cmp    %edi,%esi
  804668:	89 f9                	mov    %edi,%ecx
  80466a:	72 30                	jb     80469c <__umoddi3+0x12c>
  80466c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80466f:	72 27                	jb     804698 <__umoddi3+0x128>
  804671:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804674:	29 d0                	sub    %edx,%eax
  804676:	19 ce                	sbb    %ecx,%esi
  804678:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80467c:	89 f2                	mov    %esi,%edx
  80467e:	d3 e8                	shr    %cl,%eax
  804680:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804684:	d3 e2                	shl    %cl,%edx
  804686:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  80468a:	09 d0                	or     %edx,%eax
  80468c:	89 f2                	mov    %esi,%edx
  80468e:	d3 ea                	shr    %cl,%edx
  804690:	83 c4 20             	add    $0x20,%esp
  804693:	5e                   	pop    %esi
  804694:	5f                   	pop    %edi
  804695:	5d                   	pop    %ebp
  804696:	c3                   	ret    
  804697:	90                   	nop
  804698:	39 fe                	cmp    %edi,%esi
  80469a:	75 d5                	jne    804671 <__umoddi3+0x101>
  80469c:	89 f9                	mov    %edi,%ecx
  80469e:	89 c2                	mov    %eax,%edx
  8046a0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  8046a3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8046a6:	eb c9                	jmp    804671 <__umoddi3+0x101>
  8046a8:	39 f7                	cmp    %esi,%edi
  8046aa:	0f 82 10 ff ff ff    	jb     8045c0 <__umoddi3+0x50>
  8046b0:	e9 17 ff ff ff       	jmp    8045cc <__umoddi3+0x5c>
